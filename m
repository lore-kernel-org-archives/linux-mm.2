Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73817109C05B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 20:06:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C46896B0088; Wed, 25 Mar 2026 16:06:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF77F6B0089; Wed, 25 Mar 2026 16:06:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE69C6B008A; Wed, 25 Mar 2026 16:06:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C0E16B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:06:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 457F3C343B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:06:56 +0000 (UTC)
X-FDA: 84585668832.29.88AD276
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5DCB1140004
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:06:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ircltfMb;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774469214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+fZRp4AJi5cb/F6jA80ZrndPdXYxEQL1IK9u8/P+m9k=;
	b=Bi9rF4Xbhbd1UEcgURcySheQz9+mi695Pz3CYBH7l6L2nOWLjUtXC59XMp8ZrK/5NdLslH
	udmv+PdwBjrOoiOMiiq1TuQvGg2XqY/xLooeMF1USZDKJ8vw8P0J0rPAXWnriQsZbH0LZv
	eiYZ06f4gYmBEi3vl+CCoAXC/WPifEc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ircltfMb;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774469214; a=rsa-sha256;
	cv=none;
	b=QjGFmqf3HpjAdpia1DVDjfOD7GlvZzq9FHPoQYdKriMENYC3U0up+x83KOyV89ynx+Jua9
	KIHzxazgf+q0zQLDl/umfAsRgLzg3R8NOVT+BMRvpyY1DDofg200Eb2pT1Vuf6GAmVyOvO
	D5yIzHkM62mMrkNA2tVY7oDsWJX+Uqg=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c2af7d09533so235996a12.1
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774469213; x=1775074013; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+fZRp4AJi5cb/F6jA80ZrndPdXYxEQL1IK9u8/P+m9k=;
        b=ircltfMbdyooQtBswBLt30rmIAPt8qWO0C2PsJi2aiUhLXR2ku9E919hIqrQN9NB7B
         u6ybu2BceH9lQC9ueWQ6avz8W5jL7qfn4qGxNpYgIfhZfXCLlPxNcDJGI5aXdA01D3aY
         rb3m+MBPNEZ17qzgoIK7FONfSbISy3MqAS2Qd+Jnsm4cvmZhr5OgC0haVBcHrlKYoO3P
         2R3g/TVuar/5cthQTmiqyHZAHr0FoaIaSqhGSNe3GjutKzeOgZaZWCLoKb28vKBJ/Hnt
         BNV301NIvpCv5PZQCC+bnwaFKEKWl3q2kuOt8lX4Fj1w3yhCQsjgtAJoUodwSJY1B/t+
         449w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774469213; x=1775074013;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+fZRp4AJi5cb/F6jA80ZrndPdXYxEQL1IK9u8/P+m9k=;
        b=QFywL52KS2wl0o1QjzzlulIL067VEh5CQvT+Hs/PbUn0LYgOKdDgPI3t9gfm6L/FRm
         VyugcPsSvEKoonnIC/xtyjCQgPuGDLnBw7mo/eYpxy5YBi62APAlt0zG3TI2qpGmG4Lf
         mmrJE929u4PhO8b9XX3xM2yUx8LedFPO2P3AALuGpVg9fCeT86YqtHyaV7TBrMkYReSy
         ENOcw0/gCqYhLjHhUHn0+cy3boOBZ4+T0+rza513XqfydozgCp3CW7WBl2jA16j/KjKy
         2Dj0gZhV1fIO6lrJBs6dq3e0BgcU+Pz+Ox26rSyOnXPcTpbtMlFCnXm4g0Kr0UQ0wICK
         8IhA==
X-Forwarded-Encrypted: i=1; AJvYcCVN+4FelcS8aWIUBPt1PTmungC3OKkG5rVtzqDPPORxI4um5CyPG10A3D0863gF91oPMzKKc5xdhQ==@kvack.org
X-Gm-Message-State: AOJu0YzqLF8DnnEm4GOWy9wLe+d6UmcIiYeqjgpseIXWd30rW3RQNqbN
	uzA7+m9fsmhC7cngVWMpq3u4rRLUB3Vca/wjqDd5m7U/2KOOG825tJv8SmDYIFmgGA==
X-Gm-Gg: ATEYQzzs5aIT2ZfqctUQIUMt5X9yIuQArevTBOH7CYxLccckBK/e++QXNyXPV+KgJPU
	6zl9t8xgJF96MvpgSOXGxwv1Nh54YnBsecjlDIeGnBdbb3su5GyeRipp8L9cSe7r9QY7gm8LPUM
	L5LTyGkN/zUn8ryH8/vC/PjJfYNswwWVURbe2bVbbmjCngF2+e/Ycl2SkFApWgzsv9FKTe2Qas4
	PtnJ5dGL2Zv6lnDpnJw9gR6jPn6CultBxILtPDO4hNnwI6VA3M1i7kEX76+UISWhXkjaktiZYEI
	xJ2K62XDj1DH3JEzlLvmXCOCm3zQvOoJO64ePnD9wrO0PmvJMvBqEJkeQ7S1xbf0CJRLXMWOU/c
	FaPdCM3rM5gRTwohTG/OSvqdLWuVT8imnPx1QOl9g/JEzSFwlyPqeHQNX25jZeMrtubEJgCNhFN
	nYThdmYVIWyxgs1D3qBidv7GZJg+3/BHjiM38M36xT9rYJQbdRw9NORb2BCXrdJA==
X-Received: by 2002:a05:6a20:8ca6:b0:398:b3bd:de58 with SMTP id adf61e73a8af0-39c4aed5082mr3746836637.65.1774469212632;
        Wed, 25 Mar 2026 13:06:52 -0700 (PDT)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7673819da1sm305751a12.11.2026.03.25.13.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 13:06:51 -0700 (PDT)
Date: Wed, 25 Mar 2026 20:06:47 +0000
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
	Askar Safin <safinaskar@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Chris Li <chrisl@kernel.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	David Rientjes <rientjes@google.com>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	kexec@lists.infradead.org, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>,
	Marco Elver <elver@google.com>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v3 02/24] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <acRAV7IK6RW8h_QM@google.com>
References: <20260323235817.1960573-1-dmatlack@google.com>
 <20260323235817.1960573-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323235817.1960573-3-dmatlack@google.com>
X-Rspam-User: 
X-Stat-Signature: upm4b8kdicrbm86fcbc4sx1z6wm1rppj
X-Rspamd-Queue-Id: 5DCB1140004
X-Rspamd-Server: rspam09
X-HE-Tag: 1774469214-851442
X-HE-Meta: U2FsdGVkX18YZWRSBqfx75m9R2i00nKh1shP9c4zTH5wCVEEYiijIWJzDqSKCG/L8vFMHWQgFEykpYl5rD89eby/MDai7Deo3nXjop+uu9rKq3QdLF2B2x6/JqBcF95Qp8MPFatcMQooNxEgBUqQ2+e+MqeGMAvoEBL5/qv3486esWNtflmS4aU3RQsiVS0IMbKC4AXMWD7eJziC9yzNKw9sFFvYQ70Q6no7PEfewDhFV/ZHr3aUdATeJtK5gcOzIqvcnbAfxiAWucf0AIayJ6WMjm1zsd1vzKdjcDz6LjIC9/7OLilFLPyLOWZe18vBERxOIKHot+9WxgHILk0HZQGyfsQS0CxhnRclt0mQDiekXyL68ZJRSOtJbatkzCWnvu8ezC0+MWbOsV1TNjU9rhV7M2dcWjikYB+gi+RdvJmAap3KVgVwGX77I+UEIWXeqNeE37u1IgOxv7RI9zry4Ml4/ddNM7vX8QuzA1XH0Jx6fWq9UImbyNj0VA5bQrLN5SVr10H1DxWGGKXSRRc6yHv7GBJIh3bUlPD6hSCTwPtCszGQYWb5jhS4zOqNuIVgTDv0MEGLpn+yHDpALidoztg+MUVEsu1ADXzymN81mAbfIoTIy+HrL8QS44zOS94IdzJimzuz93VAh9wMxc9q1haxGnrTsTzbkY+7+ZW6tGGAx1m32lHyTTM0ihUTQ8gC7mZv2E2UnIfEbM8dseSYrNHyXWAqxGB+qReKE4wG5bjwnx/PPq4xK+fXUoP0JXCL3z1LepfHKyMifgYUyVw2WzxYR9kT9/3uY8rAUqczofPJEomclM+3Dk0RPwhLIjyBI8hDp9lJspmzDEVeFtbS+Z3YwTvUKuJ0ly0UdA7up7MlIolTB6Wu1u4mKFNneYzTylgvfUTjRb8wZjKojDNVtHTyJM/5fO550ow2cSAzxGKzaU2OC16aU/tl3pvdP01BFC5/89dVFB4HL6xTjZX
 3xEW+mwj
 nZwGS5c179MAUrCTmepKVQeJEraIyuzhr//nCPw6/rnefytwYBQUzyIQDq/Hp/JgYkcLoAjfLKo3T36lepCBUytUw0C7rqfoAmu9F4ovkxRzX4I6mOGgh2cQDaoTABKmYnVJVPuvWlAFpib0ygCqONHpR+RmZpVFnzIvxDfffqqU3aKY97P9G71XduKh0yWER53yDd5+npfxtb1DcGE/IWLptIz8+rdk/NwDicfkclgyefVHj58DTr639ZicR90F5SJvkmrKllv9UwgCGOhV/0m0MPYpXynmOvtdfydi48k1BDS/vk3diyjURCQ9jaxGOLpgSho0s+fSzHswZ7hclQ5T61inJwAgfLvW207vwOM6J1aL0gs0Ihn5iaaHLQ8hyEz2UegjDFfsoS64pJ7IczqAYfakshdr16Nnl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-23 11:57 PM, David Matlack wrote:

> +static void pci_flb_finish(struct liveupdate_flb_op_args *args)
> +{
> +	kho_restore_free(args->obj);
> +}
> +
> +static struct liveupdate_flb_ops pci_liveupdate_flb_ops = {
> +	.preserve = pci_flb_preserve,
> +	.unpreserve = pci_flb_unpreserve,
> +	.retrieve = pci_flb_retrieve,
> +	.finish = pci_flb_finish,
> +	.owner = THIS_MODULE,
> +};
...
> +static int pci_liveupdate_flb_get_incoming(struct pci_ser **serp)
> +{
> +	int ret;
> +
> +	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)serp);
> +
> +	/* Live Update is not enabled. */
> +	if (ret == -EOPNOTSUPP)
> +		return ret;
> +
> +	/* Live Update is enabled, but there is no incoming FLB data. */
> +	if (ret == -ENODATA)
> +		return ret;
> +
> +	/*
> +	 * Live Update is enabled and there is incoming FLB data, but none of it
> +	 * matches pci_liveupdate_flb.compatible.
> +	 *
> +	 * This could mean that no PCI FLB data was passed by the previous
> +	 * kernel, but it could also mean the previous kernel used a different
> +	 * compatibility string (i.e.a different ABI). The latter deserves at
> +	 * least a WARN_ON_ONCE() but it cannot be distinguished from the
> +	 * former.
> +	 */
> +	if (ret == -ENOENT) {
> +		pr_info_once("PCI: No incoming FLB data detected during Live Update");
> +		return ret;
> +	}
> +
> +	/*
> +	 * There is incoming FLB data that matches pci_liveupdate_flb.compatible
> +	 * but it cannot be retrieved. Proceed with standard initialization as
> +	 * if there was not incoming PCI FLB data.
> +	 */
> +	WARN_ONCE(ret, "PCI: Failed to retrieve incoming FLB data during Live Update");
> +	return ret;
> +}
> +
> +u32 pci_liveupdate_incoming_nr_devices(void)
> +{
> +	struct pci_ser *ser;
> +
> +	if (pci_liveupdate_flb_get_incoming(&ser))
> +		return 0;
> +
> +	return ser->nr_devices;
> +}
> +
> +void pci_liveupdate_setup_device(struct pci_dev *dev)
> +{
> +	struct pci_ser *ser;
> +
> +	if (pci_liveupdate_flb_get_incoming(&ser))
> +		return;
> +
> +	if (!pci_ser_find(ser, dev))
> +		return;
> +
> +	dev->liveupdate_incoming = true;
> +}

There is an inerent race between callers of
liveupdate_flb_get_incoming() and liveupdate_flb_ops.finish(). There is
no way for callers to protect themselves against the finish() callback
running and freeing the incoming FLB after liveupdate_flb_get_incoming()
returns. Sashiko flagged this as well [1].

After some off list discussion with Pasha and Sami, the proposal to fix
this is to have liveupdate_flb_get_incoming() increment the reference
count on the incoming FLB. We will add a liveupdate_flb_put_incoming()
to drop the reference when the caller is done using the incoming FLB.

I plan to include a patch for this in v4.

[1] https://sashiko.dev/#/patchset/20260323235817.1960573-1-dmatlack%40google.com?patch=7974

