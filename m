Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58A0BC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 17:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30DB96B0099; Tue, 21 Jul 2026 13:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BDBE6B00A0; Tue, 21 Jul 2026 13:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185A26B00A1; Tue, 21 Jul 2026 13:16:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8EBE6B0099
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:16:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B897A0503
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:16:57 +0000 (UTC)
X-FDA: 85013438874.14.4F82AD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id CEA354000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:16:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=INSdq0Jh;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784654215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4p0jLk0hWrusAXNcO2QsKnQrXyxqVvMPo+V5GGUXDvw=;
	b=sb69JJPKwSHw8i1VkwFlXZsWP1nYSNOZR74LqV7GIX7r25mAEjU+jgmAPtbe1hWdUR9Z1l
	vAe/1yq3GD4B8Z0I+i52mSPXvfnLEE/u/BtXuH6wR/ZqYqPywQMeea2dRQ0SF24njMxrY0
	sMrnVJEtYDFnzvNdFXgaPL6S0jBjIkU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=INSdq0Jh;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784654215;
	b=MAIkVQa8okOBN14EAUDAJxbLwiRfw6PVselFRy/VJpWqb1s7mdPYdZ3n4XnTT5Ji158Xzt
	cKGTmRo7Eqo3aQMVsH5B4Q6AOFgHi6xMWrZdR+HgrT6Cuw2/cOmyKR/2aWZROjGeqjYpZx
	o8W8PwnW504hMlbSddofB+OhU9Wyu60=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C225040656;
	Tue, 21 Jul 2026 17:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275181F000E9;
	Tue, 21 Jul 2026 17:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784654214;
	bh=4p0jLk0hWrusAXNcO2QsKnQrXyxqVvMPo+V5GGUXDvw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=INSdq0JhbWOwLqdV8BEGL9GB/JoFkWjXSauwNsyuu0/ZvV0n69zWiQHOVcKvEIq3t
	 7o3StUAGsExB9s1uDIwsX+4k5bLRf/3+XpuEzsbAn2h63XzAx3JvRQO9cRNFLxpKut
	 AlvHpfivgYBnJBB60Vf6Pi3CYj6puhivnrOTdrOFLaOA8uuVuHBu4rN+sl3nkkrUaN
	 LixGSj8SYkp9pgjvM6bB8H+VuM0YEVaY9qzvl9O5TORwUUTuAFFYqQbbnz/pAs9A51
	 cyTYtfpI8afsVrs8guyGUInKpw5Hy2EohG3rmFbIebgmkXzLKH20xBRH7X/ZnW/tj+
	 foio8xWfb5fig==
Date: Tue, 21 Jul 2026 18:16:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org, Albert Ou <aou@eecs.berkeley.edu>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Brendan Jackman <jackmanb@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
	Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Michal Hocko <mhocko@suse.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Suren Baghdasaryan <surenb@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
	x86@kernel.org, Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH RFC 01/18] x86/mm/pat: Don't gate cpa_lock on
 debug_pagealloc_enabled()
Message-ID: <al-oTOKY7vkdPHr5@lucifer>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
 <20260721-generic-set-memory-v0-1-v1-1-2c1fc62306b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-1-2c1fc62306b3@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: CEA354000C
X-Rspamd-Server: rspam01
X-Stat-Signature: bntnetyrbrjjy61ejd7wgxrkib5i1gaj
X-HE-Tag: 1784654215-456783
X-HE-Meta: U2FsdGVkX19pB4Kpj+TIw7A1CC2cS7sIonKJ9VVID3nJcQcMxvi4/sQxpopUvnD/5BEfBe5bzd0qxPHw28KBNbzpeT7YIh196nvpzoJBI7DGYKzp4sRzfyW/UMpWJi1omlLatDDzT+/iN4sXBosCzjI3BGcTVpjAPjHASAl4hgucefOmVtoDhXtrJJ/EVGadwrsiT28c2i5t7fGYExDw8yvqVCMXnyruzCViZ9sgAuW0gahSQReQ28QwrgLuYaGLui0XlNxYGef9FGWT61/hBl7TJwlmFhTVSYjHThp9w2v3VNs12nGf5l1k4ZEXHhUZGNNDLqhOOSiHANoSiU6cXJ29WdJcabNUs9psgMeliJM5UgLdw4xMUAPNF/m4+gJqtL3ZruUWwj1osAoVRccCKpYs2C/cLlESGWsKK9tkcwXHoK3zz+6pWaM61eZUWrA06UfqjBLRfjffXBJL6ZlnujUiifvV5up/YxkFDRhvWpcZEN2cC6kJmabgE6yYKDkBdTc6DmE40JdsrfMHZzSINIoSftSq4Z7Okwq0fVZltuwUhZUUNsfOGvgVRjXq5ipe4sSO/7jDzQtG8hOqjpNQRFTvr5WtUiGRv8VKOQqxfvJMt9lq1HkzIwp1ySIhu72F8YocuctpdjqFbGrcVNifER84zgzIUicszqEyO6SrElPBrPtCLtPDRckR82xmLRGeGF/XDSB1p/m/bcePEebxLfMypZ5+S1C6mVthH+Ftpvt6nhiQKR3rmANEvkB9RjjXGHDELk9wQy6WYfDFcI/arIpg4MMcsJsdnVlcjowM7ykL2cLKid/a0gBDRiEgH91WZ3MxI4rlsb0Ps3SEEw4N2nBQPXRfPF3HIXfsr1wrYZw6Wt8GKf87Xga4XkYsu/P8Z7f28kWxNj6+lsXRO2fsrQ8OTp2Z5CXQIkOfXnbfC6pqVmqELD8TwD0JzKyoRunOpFKlElmpWPSrWz9vVUK
 h1B35sGN
 NoKr+EME1h0DtTnMyJq4cvGTzy/ArXKp4I36VZVu/KIoCrRdoPjLDp0/EKmdsqdWkf3fThOJueiDvV01RrTDgF33EFkF1tJwJNqF8aXFj5Ib+G4qe0N6STG4gs7DZv0+5v2Gvj3Qemkd3GXg3zZw/xnGOPZaTFGqNvEOjc6uqRrYvLk1tQgUmPGKO+ox67EW0W8Yc6arlDuSC59yiGpVIok8t1NonezLNBcJ1hmqClnr3CyfL1x4DUOjI3qn/yHXK+lezX3Jedzb/28crIDdlObdqjg5oZMosJqt85MB6IKVaGHbUeXVOcI3YPdZo5Cd8dO3FQ824CNZLqZ6EULKoyUE7SND2gKub6GvZNJfOTzHya1nMD7SgKmWX7veO+42Lp/GOBom31iGXRGhI+xmAdX0f9k3+3o2oW6HB28aVkWQmQD7Lk6XY5kiOCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 07:23:24PM +0300, Mike Rapoport (Microsoft) wrote:
> The splitting and merging of kernel page table mappings between small and
> large is protected by cpa_lock. The merging is relatively new but the
> splitting is ancient.
>
> The splitting has a locking optimization: since DEBUG_PAGEALLOC forces all
> mappings to 4k, there are no large pages to split. So the code that *might*
> cause a split can just skip the locking (and a few other things).
>
> This is entertaining, but it adds complexity and makes for weird locking
> rules. Plus it's all for a debugging feature which makes the kernel super
> slow in the first place. Optimizing something which is already super slow
> and not used in production is not the best way to spend our complexity
> budget.
>
> Stop gating cpa_lock on debug_pagealloc_enabled() to simplify the code
> and the locking rules.
>
> [ dhansen: flesh out changelog ]
>
> Suggested-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Link: https://patch.msgid.link/20260715144519.934289-1-rppt@kernel.org
> Link: https://lore.kernel.org/all/aab44f08-89f8-47fe-bee4-0ab6b25968c6@intel.com/

Hmm this patch is already taken separately though? ([0]) (obv. commented there
already with review feedback).

Intended to be with this series as some kind of background or? Probably better
to separate out given it's a live patch

Thanks, Lorenzo

[0]:https://lore.kernel.org/all/20260715144519.934289-1-rppt@kernel.org/


> ---
>  arch/x86/mm/pat/set_memory.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index d023a40a1e03..e8316f5ffa8a 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -62,10 +62,9 @@ enum cpa_warn {
>  static const int cpa_warn_level = CPA_PROTECT;
>
>  /*
> - * Serialize cpa() (for !DEBUG_PAGEALLOC which uses large identity mappings)
> - * using cpa_lock. So that we don't allow any other cpu, with stale large tlb
> - * entries change the page attribute in parallel to some other cpu
> - * splitting a large page entry along with changing the attribute.
> + * Serialize cpa() using cpa_lock so that we don't allow any other cpu, with
> + * stale large tlb entries, to change the page attribute in parallel to some
> + * other cpu splitting a large page entry along with changing the attribute.
>   */
>  static DEFINE_SPINLOCK(cpa_lock);
>
> @@ -1235,11 +1234,9 @@ static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
>  {
>  	struct ptdesc *ptdesc;
>
> -	if (!debug_pagealloc_enabled())
> -		spin_unlock(&cpa_lock);
> +	spin_unlock(&cpa_lock);
>  	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
> -	if (!debug_pagealloc_enabled())
> -		spin_lock(&cpa_lock);
> +	spin_lock(&cpa_lock);
>  	if (!ptdesc)
>  		return -ENOMEM;
>
> @@ -2023,11 +2020,9 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int primary)
>  		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
>  			cpa->numpages = 1;
>
> -		if (!debug_pagealloc_enabled())
> -			spin_lock(&cpa_lock);
> +		spin_lock(&cpa_lock);
>  		ret = __change_page_attr(cpa, primary);
> -		if (!debug_pagealloc_enabled())
> -			spin_unlock(&cpa_lock);
> +		spin_unlock(&cpa_lock);
>  		if (ret)
>  			goto out;
>
>
> --
> 2.53.0
>

