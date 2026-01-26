Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55AE2CF65DB
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 12:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47C466B0088; Mon, 26 Jan 2026 07:01:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FF8D6B0089; Mon, 26 Jan 2026 07:01:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B6C6B008A; Mon, 26 Jan 2026 07:01:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1DDA86B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 07:01:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58CE4140692
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:01:31 +0000 (UTC)
X-FDA: 84373975182.23.A2B6E68
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id A29F920017
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:01:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ojjfT47Z
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769428889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4MD0JKg2XNo8f5Vd/iDuV+WzwyogEWvnQdT2mMRPJPc=;
	b=U/n6v0MqDzSW8zbKvPrRKfGCyX2B0ctMCiOrFzKd6TPy4qPo0AbAryypqTVqb0vPQsRfbj
	zj1Lwr/rrInPKOuAzgs9ZqvYXmKpAlcX1D4Nof2nWOEAtmt8MsDeYYpZzM5K/aL93UHT67
	hMTE1LpIjETX0BTYCK3FAOiMEhWq52w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ojjfT47Z;
	spf=none (imf03.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769428889; a=rsa-sha256;
	cv=none;
	b=YJpa4WH7a7gnJ3p0Gn3+obxCogn4AWT4oPj3PJTrek9aLfsq504bexNWuHLSK3Lh/UnArh
	JGWG40hvgne19sMkVnGFhaHeP7WwA7le43RtCvJ/5Nj+bL+jg9vJizaVzzAsqjJus0YrS6
	ijg2s8zrl2gOuS6qsoj/jRI8qH91Rd0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4MD0JKg2XNo8f5Vd/iDuV+WzwyogEWvnQdT2mMRPJPc=; b=ojjfT47ZBr4oqDYV7h38ok75+M
	p3XiCn2p0xutQKqmEFkIi9mdXHk694M+JEC5A2HSXodenka5ejPAqrEIpS+GR7+MIZKg/GiDrU0h/
	cjbkbMVmKAxTCpcV0Crw8twAfmqwO+gHuEy6lwr7KLmPogIciBMC9NUJWI+Ebdv3TldDgNPWnpiAT
	HHy6CIQ1SvX9w0pxi8AjQb0Z8TmM828eRnvex7+0FFxWR1GdpIbzhJOa7kWgZ8AwzFBqluspmowRM
	X+gfS40M0dgf5MQOTY1t4JYXTAL3pUvNcF/lTDoq8BGr5sd0PghDaUSZ9FcYbtVbkCkDj5cVeRJOz
	DXoP1LfA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vkLHR-00G9y1-Js; Mon, 26 Jan 2026 12:01:18 +0000
Date: Mon, 26 Jan 2026 04:01:11 -0800
From: Breno Leitao <leitao@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
	riel@surriel.com, kernel-team@meta.com, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v4] kho: kexec-metadata: track previous kernel chain
Message-ID: <aXdTEzsm88JKu9zY@gmail.com>
References: <20260121-kho-v4-1-5c8fe77b6804@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121-kho-v4-1-5c8fe77b6804@debian.org>
X-Debian-User: leitao
X-Stat-Signature: g5kz4us4bqwbmra35c4xqfkbxuxrdzcc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A29F920017
X-HE-Tag: 1769428889-894179
X-HE-Meta: U2FsdGVkX19EsWEJEmMc5lb5eFBOp7tC9Edusp2ADfg2c4IH2D2pnypvHi0Bf09jOZQD3vA89FQPtsrxV69pmrIA+wVVWxLOKwMFPDJUhL+c2ZLaVaRMDGs7jrItyDdUiUlywMCcSLwa5g0UTUo7k85kvoLWQ5zMur5PKa180vKDa6u6t8EBrWxwE6y/ThSdv13/3RaF5GEwXFhPG7ibe2iH1a+QvkwxjdlRhAiggY1k8vKT/U67gN6LUdb9HMjCQ+ax21h5DTH0WqzSk2JK1t51AKa0tRb/HEfAfiUayNUI+8gm/4GoeflV+nbeYFpbGq/JVH8KQFXmTPRlY5TIpifVD+RS10H17e5hkfmfmPDMKof8glLpBI2sR2dg4NZgm1RbUx77rsJD5pMmhRr0aSDnNlmDSF04LbaCFbHiiiPsfqYIvQpy+Abr2Tdu3pdNOXvctr4XQME5sWN/jUeTboXRY85YY4ECGMj19EuWX8Go0a9ZXlsImL7pZ1YXWrIEBNHNphiP4cujuj15Tab2/qk1H1Ee8IBRYfiCzWiuEqptIFwKXhot3+WAzBaafmtOy7OoO/mCYdN8F/q61mlhpTPNTDsD+5Hz7LeWhRV3NpuIpo/aRRinw1mfFMi5/nbu8hxDia+ukGuhdvCggiKH5M0GnHj8iMsd7GSJdM/Q35etBKNADCAdbJV616ACPz7ukzpTGlnoCuDCb5B6BQNCzh+OpzTRGh6Y2Iynms0JJt2nfXlIZefzQ81kUzjUP1M3pZsKWgNu/5Jmxg9l6i1h7xhv1Wy8k5OjAuuYnqG30jBPj1PNulmpC2j1zZvSqpRPeZOHT81KnzAExyVWuAKRafB+vhLUv+7XYa4p0rlM5z/hN2mjBSD9MPV9vChbknVXeQ8AFfJM6bcT7rhE1RGJFCExBsRy1PaAvJTS4CPdF8ZIc+9F9zWH9gfvDmhcqxPiHPL0oeBot3QT+NtiVJd
 e7PpdbyE
 /O0Oy6jy+o1FST8FsAXdKi0juNC8OCNiYA6yla9rQcnzlvsTYSJqXbkKhwUvGOwlKy/nPDeMLKuBF3xPbmKeqGon/FMiFi2awfJ4ahQeKIm03H25VQgLqrkBambI+f83MUZjsOEzoCIzkX+VYx+ifCfPJH27Y4Eif+IZKYmClF+rn4cI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 06:50:38AM -0800, Breno Leitao wrote:
> +static __init int kho_populate_kexec_metadata(void)
> +{
> +	struct kho_kexec_metadata *metadata;
> +	int err;
> +
> +	metadata = kho_alloc_preserve(sizeof(*metadata));
> +	if (IS_ERR(metadata))
> +		return PTR_ERR(metadata);
> +
> +	strscpy(metadata->previous_release, init_uts_ns.name.release,
> +		sizeof(metadata->previous_release));
> +	/* kho_in.kexec_count is set to 0 on cold boot */
> +	metadata->kexec_count = kho_in.kexec_count + 1;
> +
> +	err = kho_add_subtree(KHO_METADATA_NODE_NAME, metadata);

There is a hidden bug in here when CONFIG_KEXEC_HANDOVER_DEBUGFS is set.

kho_add_subtree() expects a fdt as the second argument, and we are
passing a pure C struct. That works fine, except for debugfs, which
does:

 1. kho_add_subtree() calls kho_debugfs_fdt_add()
 2. kho_debugfs_fdt_add() calls __kho_debugfs_fdt_add()
 3. __kho_debugfs_fdt_add() executes fdt_totalsize(fdt)

The fdt_totalsize() macro reads bytes 4-7 of the input as a big-endian u32, and
this will hit struct kho_kexec_metadata, given I am passing a C struct instead
of a FDT.

  struct kho_kexec_metadata {
      char previous_release[__NEW_UTS_LEN + 1];  // 65 bytes
      u32 kexec_count;
  } __packed;

Bytes 4-7 would be characters from previous_release (e.g., "0-rc" from
"6.19.0-rc4..."). Interpreted as big-endian u32, this gives a garbage size
value.

The alternatives I see here are:

 1) Come back to FDT instead of plain C struct, similarly to the previous
    version [1]
 2) Created some helpers to treat C struct fields specially just for this
    feature, and we can do it later if we have more users.
 3) Move this kexec_metadata to work on top of LUO (similarly to memfd), but
    that would be an unnecessary dependency just to have this kexec_metadata.

That said, for the next version, I am coming back to to FDT.

Link: https://lore.kernel.org/all/20260108-kho-v3-0-b1d6b7a89342@debian.org/ [1]

--breno

