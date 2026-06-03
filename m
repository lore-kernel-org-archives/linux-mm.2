Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14B5CCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 09:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B09F6B008C; Wed,  3 Jun 2026 05:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73AFC6B0092; Wed,  3 Jun 2026 05:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 602406B0093; Wed,  3 Jun 2026 05:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6C96B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:17:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D83E61402A9
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:17:15 +0000 (UTC)
X-FDA: 84838047630.05.C3AEFFE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0425A140005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:17:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eNnUdHOO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780478234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MQcYvCT3a1VhxRUtA3yBud3Cov811xvbS3O5Ig1I1EU=;
	b=iKiu6VfMlZOL/WSBcWOc8H2VwHdSgaqz3//QTOsaU4HWwMrqVChn81vj2mYpGulpMDXWBa
	41OjSwilu46dePmjkiLRzj9VAqbbOInckDAI0E6oGkhmfB/4is2zknRWN/UB2hwpmK03aa
	thnwQpHB7MKeKq2grD3vMDLkW74VP68=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eNnUdHOO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780478234;
	b=7X5DqNydMBQf/+he5j59iwJkiszRUZU05EnYhGD8whKv4KBTkB1JDLaEJUFG1T/5IFWqh/
	bRUte9gJXEwJ+kjFtUxexWuY5kbHascoTRKjqA3Lfp72FeZQdBpIKsAKhTkhEg3rqDE5yN
	hCT+FM2PKOaazMZrEzoIID6iB8teBvo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 712956008A;
	Wed,  3 Jun 2026 09:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06701F00893;
	Wed,  3 Jun 2026 09:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780478233;
	bh=MQcYvCT3a1VhxRUtA3yBud3Cov811xvbS3O5Ig1I1EU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eNnUdHOONZj/Uqfobds326We859nRyj5alnrvuw22DWztlicGiTtvdh/lPqUMHomH
	 eusa4H1OccADhexFj1ZDOpYnipOmGEVGsmmWLCqRXYHX6GeVbfE6sq6sEw0wlYbVpb
	 +pFWjneZKUQta42+/f8Nf1T6gFffvQ3ehLIzBzKTvSASlplK9weKercZg/MIhicvyh
	 xyKmyPwJTFKDYktmLbUpzKaaPXn5ri57SqdVgp7qgrSzD/hvcjXWEHeIwAoTJpKh8N
	 ASglMn8rh4GxR0GHGJwf+npyEvFk+88ZWdOtDh+WbDtescacZBZp3AhSbo/HcvL7Sn
	 afoMjRs6v8nyQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id D04F1F40069;
	Wed,  3 Jun 2026 05:17:11 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 03 Jun 2026 05:17:11 -0400
X-ME-Sender: <xms:F_EfanZcvCdn_IXcFRLd4iKDazSop5vjxZl1ouYp9GeOxqA5nRavYA>
    <xme:F_EfaoyIf5rFHeBAAQeAbqI69rWQlwaEF6zrVKizOgD_i4CgwUw9RCyta3eCRGdFM
    9HdhRUIPOkIjB5TCakGwIqkpMFTJ-BN7jt9Xeo28JQodLGaTX1Tc1E>
X-ME-Received: <xmr:F_EfajPtnZ9KNOhTYs4_uvPIl61OW-YIyf7DhoYiXTlhBYTrlVlY1g8BhsxveQ>
X-ME-Proxy-Cause: dmFkZTEezkExBEAIasghnBjiLysnYWt/PY0pVmQQaVS2AHfOsx523B0oS6FXtB65660IUX
    Ik7qeiMI7PD1c2/VWZGwROrAwi/xjvTxBVXtAeKDoQTzSe4rcT7tz5VEeOidVy1nkIsUJw
    qMPOdTqvhppr6iBrbU5iKf5PbS34JKc7KWpNMXWq1iVfFe86W2okDBZ7BsLYh2sxJXDph5
    WPj/raJ/oHFgrbYK7fCJEbDyu56K4mVEhEsrwg8DfdXEyRID3Id62znlLnyAXMSO7DqL/v
    6ud7XPsjkkElM2rszubqPIZFZyPZCVQXpSeF3Vo1JRkGbK6ITAKQbE9lwWpkpp9ZZbNLEI
    1E7YAFlvx6zOFsgMTeUSEtVbXlXsKL1XV/Jpq7Zay7VdPwgSJGtXu8hg77KrmAs1fNKomh
    XOuW2GO7NEgX1KY9JugpJ6hC0eBYlX70fuOf7c1+NrFxOH/Th16u7rkJNzCXYhBdNvy3Ct
    8ksInv+Hp3fIa4yqVA/JS40Fre0RM0bto9HQ5nsmCF2XotFbHo0V7fOgiyXcRW4CD3VR70
    sf+5PrMtdU/v5qRMJ3KMZJclBdzVDnYic3o383/5L0KefvqeNTz7pAYVnZNMqn6B475kwJ
    QKWZZLCwpz33f/ujUS9CAXEfSaWe2FpYzxuZpdLbT7PhSijxsfF0Um9zUntg
X-ME-Proxy: <xmx:F_Efagx8HkpG9ov_-pm8rTOFX4E5eMtiHJzbN_1TM0Dd4anhnaXGyg>
    <xmx:F_EfalCi8PbrH6J7VCPFstQ77JnqVE2F699dViPj9tuSiFP9KA1ONA>
    <xmx:F_EfarMrzoXMp6lunk_04ZhhPiGoB_SMYETpVC0V2f-c2SUz-5AZ3A>
    <xmx:F_EfamYDrvz_hD_WXX9b291GPjGzmQ0qmS6BZW8S0jOJggTlP_GKhQ>
    <xmx:F_EfahJZ_12Jbk3MrZtBOfiKCh1BeMskekjHnRrNiN2w48UMPjI9aUoz>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 3 Jun 2026 05:17:11 -0400 (EDT)
Date: Wed, 3 Jun 2026 10:17:10 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
	David Hildenbrand <david@kernel.org>, stable@vger.kernel.org, 
	Sashiko AI review <sashiko-bot@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>, Pedro Falcato <pfalcato@suse.de>, 
	Alice Ryhl <aliceryhl@google.com>
Subject: Re: [PATCH 6/6] userfaultfd: build __VMA_UFFD_FLAGS from
 config-gated masks
Message-ID: <ah_xBwbAexZ7ew0t@thinkstation>
References: <20260529172331.356655-1-kas@kernel.org>
 <20260529172331.356655-7-kas@kernel.org>
 <ah6VNjfXXx-3Nh9l@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah6VNjfXXx-3Nh9l@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0425A140005
X-Stat-Signature: bku7moktwc14to8sp8bnzs81hz5m1fxi
X-Rspam-User: 
X-HE-Tag: 1780478233-856018
X-HE-Meta: U2FsdGVkX19WqtBkpzldBlj2ro/nV/z27lvydy3+dGqj/AlZ8PnKCZH4UHiHHJMsR7/jLE9KhtFu0V9ZSTzFYoE2nz719R92TZVj3INbYIVuPHEGG37ZE5hOOJ1j7IEp/LMyAXo4MsMJO6vdaywOXVt14L/Uzuaje1AAG38si1UZgBwX4fIL/2nZ7mDJC33EluYH+fqfU0QzIqEXUCA48IQL4vIDMrjMb1ExZQTQhuiY4+ZGjml5/nhc4vk535CwAw4IDqSr5+btk1EC8daQSKU1M9Ntlo8cNFOpt4fHAInzme4xxaPjnubFfPM4kcC15AeNZvoDGBMDufM/Mx5h3VeSXX7tDlTN/GieDXvounwGxQQN07bSZzfRMbhopNlNVttu6Zp9QE29Zm1A/oW/XTBIhJWeDb5g/CJIcuMmKwkeJY0vr7vgtW9jj2FdJIAWx3HyAbHJxGPk0rgUHDf0MyaW2gLXPxte39Iaqw9m3scWYTdAN531h+7FfyXHc0GRKTOPDXiDGPBAbHa4B27pNffE+WjeXLV0uHM4yZaqZZ9JWQk90HwbMAmglyNSWlHfyuYF1qRS1Ix/C3IXUaCEFIgkWaRGfUYUZb0CxLy4aM+HQB/heiXOC1tNFOvTrI84ztjtEKgYjEpFHoYCDi2YaQZFdZIzbVokYsTDO7JhLNl0nDXnMbRbPvpALqTPAak3BBbepesAJEQhhvxX9McxO5CaqhD5vZ1c1fdMfbDRmmNCwzd/WD9Apx07dzWftFUR4JQlLWi3U3U/poBSTARJQ0LYM5XUwQaw9OHL68oYqMBDXPi6SVJdF+C8c/ZcSkj7LNEZZmI4ygL2soEWUwfD+ZAGT0F6qOne6JemmyRikFdVYODYioxiz9AZp0vIJTA8OdLMesLqV0YMaM0r8IjHxZwQY0HPqCNKR/LRN5J0wwSMlqqRaW/qee9/K9PPLd+jZTkcTi7Rdl3RmGEdhG9
 a533aHPy
 50buBEJ7XItlKC2o+NTbnaDIZVuHuWYEV6xofoQyK1S41DRYqu2KUgX4PUYxTwurwaPAVqe18FM+7MY4lz5e28woIu/ZVQr2o4YYldYMmAxXtSbLChQAZIL1lghxQxvLtBVqmPrbTgBR/+xOM+oszU+ka/VsEPRNijUpFCZKaXy77dUBO1cuL4QkOZOD9dDoFLCGQTvjknJ8l3btIqkG6PhZpL/+e8IAv1YL644uUTjZ000vxNnppgUPZ9ql6EmH271uZGJE1tXmS+etzJul73qS7bQFF9ZNxGBQaKRmbcKmBQYSwHvA13nthNgCjgpjf8QzxnuUEozM3CKC0Xv3o/AUuHXatSQLwWZPz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 11:32:54AM +0300, Mike Rapoport wrote:
> On Fri, May 29, 2026 at 06:23:30PM +0100, Kiryl Shutsemau (Meta) wrote:
> > The VMA flags bitmap is a single word today: NUM_VMA_FLAG_BITS is
> > BITS_PER_LONG, so on 32-bit vma_flags_t holds only 32 bits. (The bitmap
> > type exists so this can grow past BITS_PER_LONG later; until it does,
> > anything declared above the first word is out of range on 32-bit.) The bit
> > enum nevertheless declares some bits unconditionally above BITS_PER_LONG --
> > VMA_UFFD_MINOR_BIT is 41, with VM_UFFD_MINOR == VM_NONE on 32-bit so no VMA
> > actually carries the bit.
> > 
> > __VMA_UFFD_FLAGS feeds VMA_UFFD_MINOR_BIT to mk_vma_flags() unconditionally.
> > On 32-bit that becomes __set_bit(41, &one_long), a write one word past the
> > end of the single-word bitmap. The compiler folds the out-of-bounds store
> > with wraparound (1UL << (41 % 32) == bit 9) into the first word; bit 9 is
> > already in __VMA_UFFD_FLAGS so the mask happens to come out right today, but
> > it is an out-of-bounds write all the same, and any high-numbered bit whose
> > mod-BITS_PER_LONG position is otherwise unused would silently OR an extra
> > bit into the mask.
> > 
> > Rather than feed bit numbers that may not exist on the current build to
> > mk_vma_flags(), build the mask from whole per-mode masks that collapse to
> > EMPTY_VMA_FLAGS when their feature is unavailable. Add
> > mk_vma_flags_from_masks() for that, and define VMA_UFFD_MISSING / _WP /
> > _MINOR alongside the VM_UFFD_* flags, gating VMA_UFFD_MINOR on the same
> > config as VM_UFFD_MINOR (which implies 64BIT, where bit 41 fits). An
> > out-of-range bit is then never materialised, on any arch, and the in-range
> > fast path stays a compile-time constant.
> > 
> > Fixes: 9ea35a25d51b ("mm: introduce VMA flags bitmap type")
> > Cc: stable@vger.kernel.org
> > Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
> > Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Assisted-by: Claude:claude-opus-4-8
> 
> Can you ask claude to produce more concise changelogs and better split it
> to paragraphs?

Will do!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

