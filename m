Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34DDBC982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D32A6B008A; Thu, 17 Sep 2026 12:03:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1857D6B008C; Thu, 17 Sep 2026 12:03:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0746B6B0092; Thu, 17 Sep 2026 12:03:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBC0D6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:03:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8386A1603E9
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:03:18 +0000 (UTC)
X-FDA: 85223723676.15.21240E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6E12E40004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:03:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GwxOw8PR;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789660996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cpr1q5iPo4prGN6gHLTCnzlEG3QCR+sTiAllOyw0NCg=;
	b=3jGDB7yoqGAjz0FfhmLgqmq513JEdJ5cdzTTFlGbTtiEv/5RSrGmaUgcEVZBS6WuzzCGGL
	+70eCm4NdQs1G9A6RG5FpDWvZsFlRxWbB1fjSs4PmCEW+HtpF65ipL7p9Pd6ON4ytW0iA0
	oOCHCE1c41o493qK76YC5SLnDFbQvBs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789660996;
	b=IUt4tsIfLQYstNIXMbMfScXOBkdI0YLr6htTz0Z38k03uCXGg04x9lP+5E/34kxb3avujL
	SZm5caD1GYP+e9daahiHx0lA64nGSLjzAVbf92uCAsTDDrrsk94i8O46GaHAnM8eCgBRyY
	sQflLH0m6ErX1a7GPXfhTwYjE4D5fdo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GwxOw8PR;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA27460204;
	Thu, 17 Sep 2026 16:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD5A1F00893;
	Thu, 17 Sep 2026 16:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789660995;
	bh=Cpr1q5iPo4prGN6gHLTCnzlEG3QCR+sTiAllOyw0NCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GwxOw8PRLCERpuIoY7hX0rjG1CCPahbE1tyiQ17QjRo+F0ZwzPVG++WkIGNOreqtT
	 cG/EpuK1TLpVyj7YrGyRtj2eZQgDN4/RpiDYkmVXzznpqLYtxVlgXoX0i+i1n75y5e
	 ghLh5aeBMHY/d+ykCdJ6j9+WauDLHc4jxozYYbkgfTjLHN+CvUanamZdf/nTIAPmfl
	 x8OUkqmQ0NZUnd6feBHDwgp+Gmlfhw3sEwuAnqUsoVRQzlsMAZ7YxR/NQaycjZYV5V
	 Oq5oFOCiOG77WSLrUbJkvJZoKPPMfBrSbc1hyoKX848J/cmBQvMONSlHj5S+M0o052
	 PtrtPXHWGw8Ww==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 79507198003A;
	Thu, 17 Sep 2026 12:03:11 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 17 Sep 2026 12:03:13 -0400
X-ME-Sender: <xms:Pg-sajjONsWks_q7-E0ZfFSYS96rOgSPkfg-OER_k6I0tWXUpwi6DA>
    <xme:Pg-sav6cHgJBDbIA2BYLi88IIpJXIcmxT2MLD0QfijW_zHun5g9-1mBf0GWd5R42W
    Ita3O6nF6fy-Hfgani08AEI9nYEtEKVy9xegZ9jIn7aJgyTQNb97qM>
X-ME-Received: <xmr:Pg-sagYTFb3P4h_bHFb9T63eODSYGOgGosdJISQH2fP_YwnYIIs1Pvs_NPs>
X-ME-Proxy-Cause: dmFkZTFnWkP/oAjipqhpTyrH15eGRA2bD+A1Xse0B1GSy4xsn8XucvU9sl01MM0Ad0L70K
    RV8rNBOACHl/J1H6Nd7+ghCe17B4OtPsza4h/afczVaboD6XRqg2guprqOWvlU/5CndUAg
    sQ6kUD57YdyJu/WvN0rt/M5l5nKVGS591lpJ/WU2LBIWGf7Vp6j+m5x98KMIj2AD66Tsjw
    KWbEf23UJsl1IsBoDBtObZNzY/nesLje/i595bUpiDidS6up0Icxc7FOr2hpXeOxO6Jrul
    EhWqE8wLo1kUgPbR7ABGGoWKKCdzS3x+CNyoU4etePtnXw8nYT+SRbEW9s8SpefM/Vconi
    E/N6yZH/A04TnMVgCjMdA1NuwXfBgqBFW2TpWi2bm6r643LmRbAHWO0Zx8bdtplEuPGQSQ
    EOZc2tyGZtU8z9wgpFhPqBSx7J+CEdwfkBHoGpkZ3rdh5nwD+zBEelJEkoc0Yie39JVFjb
    Na98vLAMsiOUHwPQUGEcM9bButD8GnTmzzCYGVQDVIYQMOGWS/hbwZj+WMe0wlaeeaQgDN
    rEHmbHAWKWKL9gXUV0Evous+WVXD8DN3NPJwJ9fV77QPCfN6ftjx/c4ia9EUdmqsedZUI2
    sDbBalUG3HP9Ee4TCZKbMDvgTArPeS7pkSYvcoodvihft81sk6egcXWFKwpg
X-ME-Proxy: <xmx:Pg-sasc0SRbuaaM32D9HWaijW5Dm9oC1pwOWdO7zVxm8nD2xfeGOig>
    <xmx:Pg-sat4XkrLWtgPIHrvRMkxfbWuWILjpjl3qlsxuGy7tQIdafnVHhQ>
    <xmx:Pg-saoXjJyFEED-Rrp8mP0TAqAw9UvCNr8PXWxUtZprcynxzdUW8KQ>
    <xmx:Pg-sakYZUierAGOZfbyBTikdsoUxPjvSLBKkIJlT5kYUNGHuJ7Wj_w>
    <xmx:Pw-sanw_dutvM2gvxEXJ0awKigW7SUKTXr92icOa2M7k7oeqoNgR5ATL>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Sep 2026 12:03:10 -0400 (EDT)
Date: Thu, 17 Sep 2026 17:03:09 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/huge_memory: disallow raw PMD mappings of the
 huge zero page
Message-ID: <aqwPHfWhKGty-Q_4@thinkstation>
References: <20260917121010.60966-1-lance.yang@linux.dev>
 <aqv5r6Ar0vyKXa_x@thinkstation>
 <8c70259a-94ed-415c-89c1-572145c64670@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c70259a-94ed-415c-89c1-572145c64670@kernel.org>
X-Stat-Signature: f1n8f75yfb673z3uxbgx1rkytfn5ckqp
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E12E40004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789660996-787224
X-HE-Meta: U2FsdGVkX190FRHZ4wPj8b84dysfEr3MoNLvQR0bVuGMJWfyGE8bgd6rKCgd5jilhKTNF3ndMXfdU1SluPr4I+AV32wYLUk7jm8Fxay31Iraq2m38acIgjielm1UfUrKhrcJud0ETgawbpWNphRok/BRO5RPPJRiI+cx3V+7Cc6WlN3EhSGt9iZJkK6ea+Ng9Zq8Lbv3xDOFqJSzahBEtIK8HXOscc/DnrcwxQVBlexWZsM+Jg63hduHA+vduV00v8eGKeqmBVtrJAf+JBOtZmtotsnuxosKH8qcuionaOFILzEE6PKrVYw/f/JNmVSz2I6PVev8cejS9C2zC8HlkdlKuI8MbTG5TPoSnNiFufw/CEShPlN7YRmlncuk3kKcVA3KzrCJ3SR5bAl6be6xYMpF6ZnQWb0TY8nJAMWrxns0DpZtT2XAQSHix5fHWO+P+9yaYoR3zcBdZYl4uxs5iuntC751Mdku+wAnJAMaMFpAbhF0Mtoox6lr/MXq4vx2vLla/1RUQ/9ZXXyCkj40Orhb4JGl+q9lss18lCWifAO0MBHARnm8I8hIGBkQnBXRLxZntk30E3TOePAm36YbRV7H3ghPJDa97Sp2U4XM0LybDHk57Dhr3dCVvncuD0qBv0OUkeu4Soq7odGol4jY2jhMZ+a9p3aOqJlZ30Ivh51uqDyskMLerrBToGtGSY7hDVH951T8xmrU/gpaiqLXjqef5Hu3HIG0++z21oWUST9N4o3EUdO7MBwivhIR/nGSa3z9T5oyBZCMiAB1GdHRG8K+lcDXyu6CmxzFpyu8P00VUBbuVwCIg7xiUOZI+UF8cbJpd1387EkTxrubdDe2eWTQYMkTA+uNp4ICwtajHW3GAG9liKIXKD9iVqnReedRFsYi0/+l30rEyHALGtiSOdlihd1kH65l05UlOLfp00mhYJWDfhYyE9dUqXPgGUBPx6yS66EbB3Mn+gJ36Ff
 olZ1mwMI
 kXLM88I2Ckll5wmoxdx6fDCOIBZIixujQtnnrdFOVTt01msCIo2gaOU55p4FXKFCXS69Qojl/obWdGYPeScQ5te8sKl+CSsEwhAQBJJvScxl6v91TyqKftAMzi6d2BBhpdYmzI/LvJkSzfLxBop5N4gj8esXbPSNgJD7AObROJUkl0Xo6ph36GGccAi0zyRflKaoHjpuCzrQeTdMWEwxg0jrvKLrSF3QkEkNsqGbWzVIC1llAcSyzRGE9/093H7EeOdRu+pFgh97uNbqMJoGU8lXT/wYNc9d71SYwOUkahasBK+7AFRbceAvA/534sMewG1tCZ6wGccLsVNxikTf2g+PlIORQwqtlEehJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 05:29:48PM +0200, David Hildenbrand (Arm) wrote:
> On 9/17/26 16:32, Kiryl Shutsemau wrote:
> > On Thu, Sep 17, 2026 at 08:10:10PM +0800, Lance Yang wrote:
> >> vm_mixed_zeropage_allowed() validates zeropage insertion into
> >> VM_MIXEDMAP VMAs. No in-tree user needs to insert the huge zero page
> >> through vmf_insert_pfn_pmd().
> >>
> >> Return VM_FAULT_SIGBUS if vmf_insert_pfn_pmd() is asked to map it.
> >>
> >> Link: https://lore.kernel.org/linux-mm/f76beaf8-351a-4b22-b362-a945a5e1af6a@kernel.org/
> >> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> >> Suggested-by: David Hildenbrand <david@kernel.org>
> >> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> > 
> > The patch looks fine, but don't we want to cover the same for non-huge
> > zero page in vmf_insert_pfn_prot()?
> 
> Why would the zeropage be a problem in PFNMAP mapping?

Nothing enforces that it is read-only.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

