Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B89CC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E184B6B00F9; Tue,  4 Aug 2026 10:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA1A56B00FB; Tue,  4 Aug 2026 10:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B574C6B00FC; Tue,  4 Aug 2026 10:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86C876B00F9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:34:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08F571601BC
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:34:34 +0000 (UTC)
X-FDA: 85063832868.03.7587CFC
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf23.hostedemail.com (Postfix) with ESMTP id 28604140004
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:34:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=ji9LdWq4;
	spf=pass (imf23.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785854072;
	b=szIFCyk49xv0+phYDWBsEvQzNIF5cp2kl3dLlSjDi7vvU+Q9NyH2bgM4lOxKgcVMA+JKJL
	z8//VKVzjbRC4Hv677k+A34jzwjfOtFBHexyLFlud+TXkLTIIAtJANaXpafaRirPvz3WnT
	gNyD4zKVJz7rD7Sv36I1o8oAJcOWhV8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=ji9LdWq4;
	spf=pass (imf23.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785854072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=21zjkfFx8Bd2QE70xWkHO29FtkTbLcjGqTShMlcEBzk=;
	b=V5GhSu+N38FZtZwq+GNvEBO1SSAdmRKRx+QlFs6Aq7q8xRL5HMJ3OPl0uu5H9T392m3uAC
	4C6B86fCOMti14aeWkgdTeuqvuYR9BuC+5iSizp+06zLraLr+iDRvrZdmH4J4a+DQNzQO0
	fasXxO5YNE7wKrbW1WjfPxCvMN352Sg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1785854070;
	bh=t2/dzBTyaqSCZw1EvUdAXRFRaOxYUcoJjZpvMK48UmE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ji9LdWq4IpXUZokTPsvP3oo9BStidXc2recnK8/+iFL9Y8o6+NnLTnCJs+GB9JQ9L
	 hanbzWxBOzLyFyo6sbIwq9ZTDVglTxtf6Lk66TZuBzDSP5mzaMNj3ExUwlQgay7i7k
	 ZH8CfDwtm40bknAIMErFhO9MJb9ReNGLQCQIupnDmy/n1klNsxWTYpsPcspS7tXD/8
	 biUPBVMwHpAoMtneUja/ZUobixgeKbkPsa/XOMt54faiF0NzHN6cCLSSRj/PLw54iB
	 tGGGVKRhhC8EeqJ1406CJB6fbHqgsbBJKO58uqbrBeA/0lX/076oF6hw58qiocDdYD
	 rue0kw9cYTJxQ==
Received: from fedora-21.home (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9C2E417E06DB;
	Tue, 04 Aug 2026 16:34:29 +0200 (CEST)
Date: Tue, 4 Aug 2026 16:34:25 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: "Christian A. Ehrhardt" <lk@c--e.de>
Cc: dri-devel@lists.freedesktop.org, Pedro Demarchi Gomes
 <pedrodemargomes@gmail.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] drm/shmem_helper: Check VMA boundaries for PMD mappings
Message-ID: <20260804163425.222363ca@fedora-21.home>
In-Reply-To: <20260622215718.1532689-1-lk@c--e.de>
References: <20260622215718.1532689-1-lk@c--e.de>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 5478buafi6x39ehz759tfw4zsyrxe47h
X-Rspamd-Queue-Id: 28604140004
X-Rspamd-Server: rspam08
X-HE-Tag: 1785854071-389794
X-HE-Meta: U2FsdGVkX1/jFIuzFeHnRWAK3HMoUo1CNd7CHVH2XgLUPySqad6Rt8qOpQ5Zal1LfxVh94TOVpTKuFA6cJCE1EdYAmvkKfB4pNOc0Eb8FLm4s5B5MaF/uFZlIcolNpI4In2mnAZMY2WfUI9bN3FuB6VBtbbYUZNuE6kuHjVHjhbp83gXHkeq0vLsBpc8bj/xvjBGls3CH8ufx048pPqtGNjdeIBvw98+SqRWZK1HO+KfULlTqZCTA82dhXHXygMc/zm3Lve2RLIx4lnUUxXeriBlqrNoG5UZyNLwuGKwbDh6JQhLip6Dm4rb4obMPoFnhjmAeXgOPpjMWps+SOR0jcpvb/KkFqUfD/HMpUr2vlrvdn82ycsaNk5Ww3S+o3HXljPVnxEt+lOglWXvTCokxSqn7apNSe3tAHPMA46U/MSgdNGRQgJ40SF02p1Mibb6q2I/i+HzBA60D7ixMNtceWymgqSD50Jhec59Z3+c/FAFhYSadmIUtkhNK3NotL16TEsx5No8UTIeknlCZru50C3g8jaTaACqmnGNemTflBQSPd+sR1QJZk5/Ucbusw9+u3Cfk1PpJpTuIE7YtSq6ie6CnDHeIVN0Q22tICCVtfcSSFO3RtM6rcsnggY5RNhDs56zWeOzsfeP2G8Pqh7VTL9QrTnNX0ggNvBYVW33UjkVpu1Rg1aidoMw4ngWP+yLvKicFMetVWXEm6z7I8JUafQKO+iC3PuV5PqsVpZ5cMRI29V9TXzLeCE8JOb279KMv/XKsib6Fg5jLzyrHgecM+0I9bJy93GoeM6rtMThOtMUVSQ4tN5ppUzkYVDLuqZX82uEd/Jp+KYE+SVZUb+Lt+lQ12tptovyiQPY8JzUdWkfI3+1X8qvFaSuMntZaNug0Nb6FcIf7z1SdEyXylu7KqccCsx9C968i+mGTLBDQ+/ZhGFYMYlF6VxuRSr5Shebq1gV/hgRPX91RTb7X73
 sZc2Pwee
 4rxN/PdCbiSvlywDgbVJZab8jntWp/ZQ5rzt+dX6Bx690MHQNfV4WEZ8RFJN+BFRbue+St94ZNdNaFU3d4k/eBUPPsfbVdp3XxFC546Kh/fel8a16FpSFswBjvN/vCzPI1AMN/2bfjVPhirQuyW+6xuA8bkb6LNwQkOXeZKtzcbyVL+7GWy3nv0LYy82BULyN6G6qS/fEiOUNwTEwpB3mSRw5jhsvOPsnQNipElW2OxpJj/OGNbel10VMeCb+T3Sovxgy9OHmpu+apfbKhEX2Sdc+/hGxYRl6lQvn+BpEZPGZuCcfN9VEgG9BrSdhb8ebeMHS7NFjK3EFVFthb0hQvcPzBDhA8DNT+wDBKujQ5ALH5Qc0TvrTuZ3mHHRp3DP/pth7x9a41Ab0kPr8YQ+6ND8hgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Jun 2026 23:57:17 +0200
"Christian A. Ehrhardt" <lk@c--e.de> wrote:

> In the ->huge_fault handler do not install a PMD huge page
> mapping if the huge page exceeds the boundaries of the VMA.
> 
> All other ->huge_fault handlers have similar checks and the
> resulting mapping will trigger a VM_BUG_ON_VMA() if it ever
> reaches copy_pmd_range().
> 
> Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> Cc: Boris Brezillon <boris.brezillon@collabora.com>
> Cc: stable@vger.kernel.org
> Fixes: fc3bbf34e643 ("drm/shmem-helper: Fix huge page mapping in fault handler")
> Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>

It looks like this one fell through the cracks and was never queued. I
just queued it to drm-misc-fixes. Sorry for the delay.

> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index c989459eb215..00807039f8d7 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -597,9 +597,13 @@ static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
>  #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>  	} else if (order == PMD_ORDER) {
>  		unsigned long paddr = pfn << PAGE_SHIFT;
> +		struct vm_area_struct *vma = vmf->vma;
> +		unsigned long start = ALIGN_DOWN(vmf->address, PMD_SIZE);
> +		unsigned long end = start + PMD_SIZE;
> +		bool in_range = vma->vm_start <= start && end <= vma->vm_end;
>  		bool aligned = (vmf->address & ~PMD_MASK) == (paddr & ~PMD_MASK);
>  
> -		if (aligned &&
> +		if (aligned && in_range &&
>  		    folio_test_pmd_mappable(page_folio(pfn_to_page(pfn)))) {
>  			vm_fault_t ret;
>  


