Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E286D2CE18
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 03:40:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6E416B00F6; Thu,  4 Dec 2025 22:40:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C45DC6B00F7; Thu,  4 Dec 2025 22:40:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B839F6B00F8; Thu,  4 Dec 2025 22:40:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A94CE6B00F6
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:40:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37060160410
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 03:40:26 +0000 (UTC)
X-FDA: 84184014852.27.20B3FFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A41C7C000A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 03:40:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TsxVmgkH;
	spf=pass (imf10.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764906024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2XwREYxKSw05YMjoXQcYwWLwl4+TgwVTsoQgX7AfDkc=;
	b=zPnhmQlmTgmC1PeC51qrwo4kXuvaaA/nseRDMK27n6tzAnFaoJ+0faUnuHOyhDEUOnd7mw
	I7W3C/2cJHg0u5OF20qre3u0OZWFR7rUc5yLurpd50ILB5ZKSiRlxpk71vS/5lxM6O7KnJ
	ZMceRxU6Rv3N7tuSSCbyiASUwCXpopw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764906024; a=rsa-sha256;
	cv=none;
	b=0AGRFIvFGYaLDkiOwDL82T8sRlqUTiLV8SRhzVQnMcZ+DbaDKw/Z2w4xZ8/20xSLV/ZsWC
	/pfzmR0aliPd2y5fu+tLya1dHzi1shLiSaRau8inJIOIx3SZd/IGa0Lh6wXTQ9f6D3J6ge
	GzxDht6zawRoS2TmgiOTKW+AyQtHZ9c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TsxVmgkH;
	spf=pass (imf10.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 221D960206;
	Fri,  5 Dec 2025 03:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB03C4CEFB;
	Fri,  5 Dec 2025 03:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764906023;
	bh=pmtBP/IRAchq9Y+Of4LdB+8xUK6lrQZOgkP3KGgymBs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TsxVmgkHn5wz5hbY7X9e3YNY1yGivGCcIOtNeg3iaYGszqvV7YnRbUAHyCeXbbKgz
	 FUdcYygxNjaB9gm3Q41cR98Ivd1A94Q5fiiOwHbgm3cg8DFnYKJkAFjciSp/WTQWSM
	 8vk1nl3T+71SZ4FTbQLNjV6Z4SvdD7jNc6i1XSGATq4IHdyZI7aWQvZ+SSs4vTBd1R
	 9NVxrTKMKfsq6lXfhnSv0tMxb/+hWqP5A/Q6ReMb4dNM1opuVkh+Ax2p0li7qNbNWk
	 pG9ABSvmz6ibZwjC+ayCzcinjeWngw046Nxs71xsBefPtZ9CjiPdWBCPFXDorKRZE9
	 KC3xE1ArkomLg==
Date: Thu, 4 Dec 2025 19:40:23 -0800
From: Kees Cook <kees@kernel.org>
To: Andrei Vagin <avagin@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, criu@lists.linux.dev,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Vipin Sharma <vipinsh@google.com>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 1/3] cgroup, binfmt_elf: Add hwcap masks to the misc
 controller
Message-ID: <202512041939.63DA7C96C2@keescook>
References: <20251205005841.3942668-1-avagin@google.com>
 <20251205005841.3942668-2-avagin@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205005841.3942668-2-avagin@google.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A41C7C000A
X-Stat-Signature: kw9cuekkuebq41d1supzjuxwb3n7fz86
X-Rspam-User: 
X-HE-Tag: 1764906024-676691
X-HE-Meta: U2FsdGVkX19D80/gjxi6rUvb/A+1GCy6zXTqVE2aHdjTh1pkERduVWytQbCOkdnyB1Coj6TrTUAdGCrjRz3XNCEJ4CiQbWMQwZ6oh7pTLcORwLnc943KvhvXzawpRZpBJTUKwM9KoX+t/rEMS4adqh99uCwIuOB8uxjLURvcuVHqNNacks6rA0XIVxjxhmZgwKS2oG8H6+PGPEKPWobOv1dO9jEyao1y8Cbq7nPEC4j9T43NaP//wCYU2uvKPg2uIv6bpTV11K3tozk/wemGu7I0y/rQuSK/cjpUO7+a/9a1kOdqrhH3C9tAlMUggwJA+YcZ5INHQIczaexAS5HP6RdS1ufRpHo5col/e67KcX70GGhkTGT7JUPBjVGTjOD4EKaOGJTNgjIRY5yXshSJUsHbqhaR7FV9urc2ABY6vlcz8TSbTL8DYqKl9XgNv9hOicFwQ4vS6TDbmdcxc8W8i0F/quTjqG5XdGB4vMHAUYRHPPTwE9maor9kj7m8Q3q2l5FS4W1nhPuQMizOJO3G557nlNEtcw4pbNI4dPm7pjGbHTbEhbjg33/ifqJEOYt+uOyFBZzygCzaakHhsCGyQgIxtgWV3S3NlD0MYvYPcMhE3zQYGPNXPfksUUTH4phymCMINnym4pb9afmb55F74lThX/IaqkkcTW0sK/FOjr3nW/QVUiSCkgWKEpULXqw7HHjdwZm0/KIDD9twFD09r6OQN8i9qccQO51UaM3uYdZbd3VhlCZsIyIVeVk+9tmzGdQR36i0rPWdPXa1NB+bMpW2niIhyHnWRKzxSG7S5sQP8YNcKwOiY1eTd24noGa5LsOp3AstZRKYFT1XAid9QR4Hww1pRLKXIPY7QaqR+kq2T4sj2YRdb2y83Gt8wOkeK1Sx28AoHFCoE/DG8+4EDpzbHLcRCRn4U+pMkyIhrvxaZHvFHCk67HtsgVt3UbUuNRK/b5/HuACpUQ3ihbc
 025KfBfP
 i0xVD3TLEmiy9YWtgqUZlrSJ4dWuFXkB9jQyK4jz0JW2rEIveQPtnOCBrhK4Vzx9fH9mKDSwsL0J3M89lRCbvfSQKdczTcOJ8N08NHxcikPKfWW0hxH1KcPJQsZxbaVOJB9AelRQCxguMl1cjFnXOSn25wxv9fP35Ap7zCC17pVrZQxhi8evtM0qTpLsFSe4bDTBNPUvBHkipD2KE8t4PdPUX2o3iJ89tD7lR/jtEyQ5H0JL4vd7Ltom4eor9y9xSucqHbNaXqmfNZpX+7i4gUxQ+VocCTZF/JKpcv7KZwPkCF1hyN1sUEVjf0Hp18JwH+hPupGYskMb1YDAZzNlEW52F3T16r/AZH8H4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 12:58:29AM +0000, Andrei Vagin wrote:
> Add an interface to the misc cgroup controller that allows masking out
> hardware capabilities (AT_HWCAP) reported to user-space processes. This
> provides a mechanism to restrict the features a containerized
> application can see.
> 
> The new "misc.mask" cgroup file allows users to specify masks for
> AT_HWCAP, AT_HWCAP2, AT_HWCAP3, and AT_HWCAP4.
> 
> The output of "misc.mask" is extended to display the effective mask,
> which is a combination of the masks from the current cgroup and all its
> ancestors.
> 
> Signed-off-by: Andrei Vagin <avagin@google.com>
> ---
>  fs/binfmt_elf.c             |  24 +++++--
>  include/linux/misc_cgroup.h |  25 +++++++
>  kernel/cgroup/misc.c        | 126 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 171 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 3eb734c192e9..59137784e81d 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -47,6 +47,7 @@
>  #include <linux/dax.h>
>  #include <linux/uaccess.h>
>  #include <uapi/linux/rseq.h>
> +#include <linux/misc_cgroup.h>
>  #include <asm/param.h>
>  #include <asm/page.h>
>  
> @@ -182,6 +183,21 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
>  	int ei_index;
>  	const struct cred *cred = current_cred();
>  	struct vm_area_struct *vma;
> +	struct misc_cg *misc_cg;
> +	u64 hwcap_mask[4] = {0, 0, 0, 0};
> +
> +	misc_cg = get_current_misc_cg();
> +	misc_cg_get_mask(MISC_CG_MASK_HWCAP, misc_cg, &hwcap_mask[0]);
> +#ifdef ELF_HWCAP2
> +	misc_cg_get_mask(MISC_CG_MASK_HWCAP2, misc_cg, &hwcap_mask[1]);
> +#endif
> +#ifdef ELF_HWCAP3
> +	misc_cg_get_mask(MISC_CG_MASK_HWCAP3, misc_cg, &hwcap_mask[2]);
> +#endif
> +#ifdef ELF_HWCAP4
> +	misc_cg_get_mask(MISC_CG_MASK_HWCAP4, misc_cg, &hwcap_mask[3]);
> +#endif

Can we avoid having the open-coded 4, 0, 1, 2, 3 where these are used?
I imagine it also doesn't need to be a 4 element array if ELF_HWCAP4
isn't defined, etc?

-- 
Kees Cook

