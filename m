Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 279D9109E528
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 23:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798576B0089; Wed, 25 Mar 2026 19:13:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748556B008C; Wed, 25 Mar 2026 19:13:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637CB6B0092; Wed, 25 Mar 2026 19:13:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 512CD6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:13:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 204921A0A8F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:13:49 +0000 (UTC)
X-FDA: 84586139778.19.30D0382
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 69CE640013
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:13:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i7j6QyFf;
	spf=pass (imf27.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774480427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=8k/92Vl0S2lizBewoJmB2ydadzdk7wy8S0qCfjQ/afs=;
	b=qseANPvDQhdirpF/5dK8B/J/jseNWoqLx6LoLbrAugQ+QB3aNan24pxG2zm4mHtKxGB0jU
	gsXJPJDURdhEBbj1FSlINqsr3scfHNoJDPoUiq50ubYWZrbbXW5Zvp+1qR5GaevPW397HM
	ON/iclEAHXDxmkAc3PsKNgGLILRPdAo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i7j6QyFf;
	spf=pass (imf27.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774480427; a=rsa-sha256;
	cv=none;
	b=uLa5eh11wfG6PudQ7Km3RFfY7Tq8GvU9qnez7tjwMM+7dryMHKOZKT1I4hm4WaLH4a7b73
	7n64dMIdLMe4DpwrZD7LHI+8cvL+CyxPKhaU1Wr8Tih39QwsU4Aaz8U5nz/cFOzO7U0x5y
	MDPrYjQcXMazorb4lEeS1SidOeW0ZrM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 08A2E443C1;
	Wed, 25 Mar 2026 23:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD25EC4CEF7;
	Wed, 25 Mar 2026 23:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774480425;
	bh=6HOi28c0aIsZQhT8sVNi8T1x2rw2HK7r7jexGLskZ5Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=i7j6QyFfV4EDmQQsY0gJwgpsIW7ADhhYgGnyo8je+pZf/Yd1/B6CSVyfqsiGz5whw
	 ffi5t6lwmD73ikTBg4EWjDEh8WdW0XprkdwnHJsz0VO6ETGA7mmy0gNFFDKvQlzplP
	 mVeoq1VreB4lz1/RKR4DFbZJ8FyS3vZ1boOSmPiVM/bPleVXHxEEpInuJg5mP/MyFB
	 F5htIIPnERsMGLVuolqa8UZcItUTh0ekV4PoSoKgsr96fDtqm2RVYvDPbDGGvEu42B
	 tdjEKu5BUx7ahAJDO+rjjuyxNWMVkkWYRXpVaUgrelTRl7IvIJ6sVYrlkuTtugFytx
	 5zvSEuGK+u7MQ==
Date: Wed, 25 Mar 2026 18:13:44 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
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
Subject: Re: [PATCH v3 03/24] PCI: Require Live Update preserved devices are
 in singleton iommu_groups
Message-ID: <20260325231344.GA1293155@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323235817.1960573-4-dmatlack@google.com>
X-Rspamd-Queue-Id: 69CE640013
X-Stat-Signature: tazigbdkn173wm94dgbnip5zfrdbfuy1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774480427-828779
X-HE-Meta: U2FsdGVkX1+h48Rl9rA15tIU9HveA1nOB87hRgDAbG5ow+mQr7JLDuZsRiIjH6RHNiSCyqIDBMzaH00XFgiZpCK5nYUmsuez9BsGnDxQxQfQrEGGIAOXwjorjj1y8GC5/ECwQzYmNSDXqS96njTsTm5eIjP63sYOyrg1K0orZkhQme6jGf7it9DQdfOEWz7Es0xr9MeG2SP9dkmRbG0Etq43xnMHbMMOXhqAjyiG0eQpfn2RCMmf6Di02903rM/tbAinDb8FqGPD1wv04w0RVt78qB7iq74pFuXAQajqMP4NUZ4ESf4su0c/MBcO2ggPoL70we58mDK0asYi3/QoinKSKzhqD5M210gqQD/lcD6dBtsLsLqswGy4i3Tq1FHtsvmXqw5RbxrNYgFdgh3GZ5XwzglY2zfB0exBTvQS8vu2baRUIU7d5Nz8ZavPg8KZx3qjP2vlJwMRZlqGqUyhjICxx+tTrTUIc+ixdIRpRNy+hLfFcfK0nP/101DG2n8Holl++RhXmlZhal5raBeRbfllDDvVwle3WMaHh5oJo6CFNtvphoiiTDG9an/TcwRL0pb7vghORpL0E7/6StPub4jPiqJJP+9vPNhpBkFvsG0Ep2uHq5f6HBbwAuF30mqBHqxaGybmRtgQU0if5WJStCiJix2TmHt4zA6/8nlye//LNiuO4zQ2cuK89/Y4UgERB32cYN7kIxbautoC4vrhpSN9d1u8Bg3bJ0u+0Twyd1fOqj1oxyVn6x9oxE4lFb3qWcm4RdYJNuc9ebzhv6G8B3ZdQSj3VN4Kw7S11Y2TmmbSNajD21i2xKzmFICv7CVWpGCjEJXkZGfhVv4BangD7e9Wb5PL1PPWVwDB25KjN48TC8sk/mhl3S7ygAfkM3TzgWw8kcjmxch+OOEEBV/TVHpigQSTgcw7fcLmejR9teArXaeNd4P3OlLvi7yfKL45bVo5qOj81tvrR9BgWIO
 lNQaLYPl
 MWlE8LypgBgvzwFOHSOociKJ80satawrout2F+l1JaaS69tmENX2GXy1ELIsA8sPtm9Y27ImyX0txAQs4g731TrUh89PA5ThU7NZZ0Q0P2JvtfcjVW3BLCNGGUN0JxRU0Jf+BP93UblHdFZxeY/hBcE7zHkUa49R6ufMyD4b42OK7hgb2k8ex3lsvg53pC8e6gXBJx0Z68UqmUX/M6nsU6f8m0KSAUNnq/mR2y6DI7gC4wBFpTyMGuNgeRrKIIQPImPbta6UdtJezqK0P0BkQkT9jE0CNQdXnEgG73V4q545L+ZfXXwiW8j7dFbi25hcJ+uMsti55pg6Q6oFc8x41rH3r3WQV3wB3OtoekT/C0gKI4Dx1tRMeNrmXrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 11:57:55PM +0000, David Matlack wrote:
> Require that Live Update preserved devices are in singleton iommu_groups
> during preservation (outgoing kernel) and retrieval (incoming kernel).
> 
> PCI devices preserved across Live Update will be allowed to perform
> memory transactions throughout the Live Update. Thus IOMMU groups for
> preserved devices must remain fixed. Since all current use cases for
> Live Update are for PCI devices in singleton iommu_groups, require that
> as a starting point. This avoids the complexity of needing to enforce
> arbitrary iommu_group topologies while still allowing all current use
> cases.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/liveupdate.c | 34 +++++++++++++++++++++++++++++++++-
>  1 file changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index bec7b3500057..a3dbe06650ff 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -75,6 +75,8 @@
>   *
>   *  * The device must not be a Physical Function (PF).
>   *
> + *  * The device must be the only device in its IOMMU group.
> + *
>   * Preservation Behavior
>   * =====================
>   *
> @@ -105,6 +107,7 @@
>  
>  #include <linux/bsearch.h>
>  #include <linux/io.h>
> +#include <linux/iommu.h>
>  #include <linux/kexec_handover.h>
>  #include <linux/kho/abi/pci.h>
>  #include <linux/liveupdate.h>
> @@ -222,6 +225,31 @@ static void pci_ser_delete(struct pci_ser *ser, struct pci_dev *dev)
>  	ser->nr_devices--;
>  }
>  
> +static int count_devices(struct device *dev, void *__nr_devices)
> +{
> +	(*(int *)__nr_devices)++;
> +	return 0;
> +}
> +
> +static int pci_liveupdate_validate_iommu_group(struct pci_dev *dev)
> +{
> +	struct iommu_group *group;
> +	int nr_devices = 0;
> +
> +	group = iommu_group_get(&dev->dev);
> +	if (group) {
> +		iommu_group_for_each_dev(group, &nr_devices, count_devices);
> +		iommu_group_put(group);
> +	}
> +
> +	if (nr_devices != 1) {
> +		pci_warn(dev, "Live Update preserved devices must be in singleton iommu groups!");
> +		return -EINVAL;
> +	}
> +
> +	return 0;

I assume the requirement is that there *is* an iommu_group and also
that dev is the only member.  If so, I think the intent would be a
little clearer as:

    group = iommu_group_get(&dev->dev);
    if (!group)
      goto no_group;

    iommu_group_for_each_dev(group, &nr_devices, count_devices);
    iommu_group_put(group);

    if (nr_devices == 1) {
      return 0;

  no_group:
    pci_warn(...);
    return -EINVAL;

> +}
> +
>  int pci_liveupdate_preserve(struct pci_dev *dev)
>  {
>  	struct pci_dev_ser new = INIT_PCI_DEV_SER(dev);
> @@ -232,6 +260,10 @@ int pci_liveupdate_preserve(struct pci_dev *dev)
>  	if (dev->is_virtfn || dev->is_physfn)
>  		return -EINVAL;
>  
> +	ret = pci_liveupdate_validate_iommu_group(dev);
> +	if (ret)
> +		return ret;
> +
>  	guard(mutex)(&pci_flb_outgoing_lock);
>  
>  	if (dev->liveupdate_outgoing)
> @@ -357,7 +389,7 @@ int pci_liveupdate_retrieve(struct pci_dev *dev)
>  	if (!dev->liveupdate_incoming)
>  		return -EINVAL;
>  
> -	return 0;
> +	return pci_liveupdate_validate_iommu_group(dev);
>  }
>  EXPORT_SYMBOL_GPL(pci_liveupdate_retrieve);
>  
> -- 
> 2.53.0.983.g0bb29b3bc5-goog
> 

