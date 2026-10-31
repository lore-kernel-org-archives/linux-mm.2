Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53232606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 05:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZS2ZvjJl
Received: by kanga.kvack.org (Postfix)
	id BB7626B00EF; Sat, 31 Oct 2026 01:55:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40946B05B1; Sat, 31 Oct 2026 01:55:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A094C6B05B2; Sat, 31 Oct 2026 01:55:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 745FE6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 01:55:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6417A861F
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:55:09 +0000 (UTC)
X-FDA: 85381858338.24.0856C9E
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0525640002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:55:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZS2ZvjJl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793426108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCgjURrKo6HedSLNTmVowrdbKxaGNL1I2PpeVk6fWxc=;
	b=lFNEN9QoSD8oCAVOcM2lpKigO09SiwqFgSrHxpMUIvWx5GqodA0e6cYUiL5T8+Xo1BLxNQ
	NWjMIbdlqziyhXARuKZ/noYCIW9ysWeaiCo7lG1rQo0IPRQhIRLycgoMRWoZpPFRZ8KIkV
	+Ac2CIikQb9N9Y8R61XbpczU0x8d1KQ=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZS2ZvjJl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793426108;
	b=XPBJD2mX2NICNyZuOn/0s+wRxR8gfp9YJUvzfe5NJSMZLopo7tSvFp1NlZWk6NLPhhrD/6
	afuESlI13ZkkwyYeUhe6FZdyzxxmDksNOJ2mDBQ2wCGx2Tju4Uco4QyJxCUFCku9lwXfZG
	D6O1hDyQ1JP7a/QJ1Xh+q2fiyUQpSGs=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6acb57c2b88so1712181a12.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:55:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793426106; cv=none;
        d=google.com; s=arc-20260327;
        b=QVD/ReLxkbUDGLcFi+Wm05lSTkfUe+zP+VkEqsuKApCVZcLDXMCZBXSpwa+hKCRKLG
         MoQb+NVn+hTnIUNAzerTfFTMeDIIyh9P7n5zXo5KoThTiYe2N11Kt395vauF4yGXZbz4
         QPY8mXo/UjhuhgUaZF9ITlGS2UkBw03HoJWwbtLcxyMo1PoRDBWc/PNq6slaIWmcamxF
         ekNdqfeimkJJD1sdkeXV/no3EUJ+CdCE0JHUPdz7CGu/UkKfPUagXUr7t62T1GIFooWz
         0kXvthI95p+S9E8gmVN1f1e1aG7Vj6DIyQp4djJu+QnC/V+ibSOXikFY2WckZ0EjGktn
         PSwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mCgjURrKo6HedSLNTmVowrdbKxaGNL1I2PpeVk6fWxc=;
        fh=3YUrGy4j+I3Mhef2QOn/2DrUJFjSwIFC9I0LHmKqqKY=;
        b=kpUW41hB2VA2g8pxobTWwb4DaCi3CGRPqPI2PMCO9xlKY9S+iAkcQAMDqpaOu4HsxE
         uBViuhC2LM1KT62xmPJ0K8W4s6CTz8IzHAFiBE4wzkAdpuzJGBQNNhgDnNPYtdvU12OO
         bxHJDAaD3MCaijJxGAqmXG7Kda5Fy+GV71OOtr6bcQYMPJc0RRfme8EjSncCngfozXyB
         j4mw3SZkXmp5WQf0/yZEP8efbp+Jqojso21hKS9HksLfGSv8a73E4tMHKoEBixWMec0Z
         F8Pi2G+f/l/gIKRXQgBBxtYmU7OUCWPhE4x4USmL+bTnd7yfDd5ikIi6UmeIn4+MJW4K
         Qpwg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793426106; x=1794030906; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mCgjURrKo6HedSLNTmVowrdbKxaGNL1I2PpeVk6fWxc=;
        b=ZS2ZvjJlZyVLpbBpE3eO3If9BUNTVj99eavA1VwteHNgr8zTTSztJpet864U3Z1Tw2
         i2ntdD1BnF7GGSasW6y+4sVzgupYHlEUQQzpa2AuiVcw285O/lsFCDkueeTspHdDP3NW
         3mT2yaQmqzQ0/HW697N0l1A9M6cOuYTDrTTAPQped1v+SO+Js1fdtdx8akR4E/hWlqJL
         zBoo4zd5NfksboXCI5F/bTVEKdPYZ3FDe7LaZ1Qactsf1PVM0NBRbPigj0NmuI9v0KsE
         1cjmh6Uu0u0xr9CR6OI813QyVI7TPAoiiwBGJVoHJRs7zAvKzG2x2l0QPPuR9ZFkxv3R
         /9ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793426106; x=1794030906;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mCgjURrKo6HedSLNTmVowrdbKxaGNL1I2PpeVk6fWxc=;
        b=fNjkznEFJkG+MbXVeHO+u20Rj/Z1NoL3ozbQ/Q2JBNS6zbCKzfeuL35obunKT9TVRY
         PrP8OlhIod9itOcuSlUm8j4AsxfYDbomJxTcmZo9SsVyBx2JU6eEwLBEBoEBe2hqHv1O
         xssrKU5Yac5DBNQwfw6k0ISJH2xdg5xXWqwYzlkPZ3a6oSUQCIv3O5zbAMNj0ZbQGNqR
         Kgc7hHGx/L+pakAo/9C42oSX6iWaigXJbIWBGqqMPXiNhwTMIodscr68MXqCnqjxOpMH
         HG3zxwo9fRBlk2vMOhBpBFNSpo/5zjFzMEfdT3S5Mfk46stAetuZKpraMNPcwygjZUuY
         wtjA==
X-Forwarded-Encrypted: i=1; AKwUvBwLyhOWTTfrloZlwqqSEPa+D96YxenWJZ2byaDU8V+ipkKlP8Ejl8NPgUjQcHXqCALdQL2IITHtKg==@kvack.org
X-Gm-Message-State: AFq9FYKZX0UWnwVDb8z6vrA1AZiH9Ercvq1/TtkREkBn8lAXRC8CAA3a
	qe1CTuCpsIy7WXa0xG5jR04Ct5gAyoq9mPfUAWIEhIvT8T5V0wQ3jf6WGt6UVfXj1JFEppkkEhE
	dqNO6xrvN4AtS1o58SIsDKESQQx/rc2A=
X-Gm-Gg: AYBFou3CwEgcA5C1NuhdywRNl3pZ7cm0PXdk0tn1rKEuI+1cM3o4jm12RtKLsiBcSWU
	uXIl5rqejkgu7zDCZTiLJb0OyjkrcTXFqnrBKDj0iRN46VPMe3vozHmM5KL9t6SZZAL/5fCd4mM
	yKN/XvVJBRnKcLuwCJmfbLW0O8x0TFsWB57PHFTaz3mdE+u3FFNf6+qSLCG378QOBInnlZn90xT
	oftcyqlZXjnA3H3G8eZjnqhN1FYZfwgoa0WanJ6/XpkyIBiKymPirYW5ce+k68DFKFv48rnvKjw
	+at3gD1uO19SXQXuPz1NCjw3YUchTEuQBlXQcDc6stBHtIdJKJHQFDLtdP/rehByW3JZzYN1cv2
	30WHZ09mdAlA4XEZwopkl7/iEx3yfV2wEPTX6BcKjXNoQJ/WJ53Jxpq6PIe3s74r0pSx5GRA=
X-Received: by 2002:a17:907:2d25:b0:c41:1e13:8896 with SMTP id
 a640c23a62f3a-c4ca7a7586fmr378054666b.28.1793426106050; Fri, 30 Oct 2026
 22:55:06 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261030-swapin-large-unmapped-v1-1-41e4ae378e6c@columbia.edu>
In-Reply-To: <20261030-swapin-large-unmapped-v1-1-41e4ae378e6c@columbia.edu>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 31 Oct 2026 13:54:29 +0800
X-Gm-Features: AclHuK-xDhrqISf5wq7z_z32la-j7uMJ_BSTSk-mqM8zIBPegNWP5UzqHeqNVC0
Message-ID: <CAMgjq7CwaE1Fmdz1Edm60HVyqSWWpFrUo0n5GZFdJoCZUbhKbA@mail.gmail.com>
Subject: Re: [PATCH] mm/swapfile: drop a large unmapped swap-in folio in unuse_pte()
To: mt4022@columbia.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0525640002
X-Stat-Signature: hk7parxjse4er7mmrdaa4tpdifqjqnn4
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793426107-463897
X-HE-Meta: U2FsdGVkX1/A81wXTOUhXu0lIqY0W8483WBRguDJCkw7MyxodGXpEGFWJFq1qozwOAJTTlWQ1ZyQLAJuvbn10BTX1OBQjHpp+JGk/y0GvJff1wXMv5wDWFclewnnsUSsZEBOrvf29biQ/XTM9tkVDZfWpRf9Uvx2QX4v929TaSg5AA9dnch2GcAVIOpJR7pLFHTuUtcO+F2hqLs8m/eb1M/shEVX2TAlWMWVqXYclrbVezXy8EycO5tOSRCRqCfbYwGUSHiXiMBTw3Nqwl68e0MCScMlGbYbIXSXNpqV+1PAzWKa7jfqzr2g8vi9S7XqbJ1t88BbWk1Hzzr2UN4IRBYK2dYAQq5rtEi1PYc9ttk45Pv05vCVlk5brzoRiS9seJoac23UB7Ac8XvdjzniNmNik7+/INAWP1FVCgShBGyxi3weAgf7XsfrlD9DbkHWeJuyKeHKsEUVhNuc50xY1DBZ1ao11Eufh6oqioZ+Z9Q1f8/Q9jt4uK9Qe7DLaefivvwlZL9OrDqSkmZAqXe/yPzh9t3fMZjI8D3DxYnAajlEyku3/c0KXiQHZ8VoAjSrEz80LpNz72ElxjL4p1yypfqWGy1ETb2x3mUNpZW4bQXNsoO9jbRM9j6xWYeCOtCN1dtHwlJMgI/2ojqe8ak3+jo9a3nCh7Ww6xgdPdbU4MiNcfCJkoYyj0hrde53cZutLACB2b4Nj7fk9TPg9QWH2ecLEcDh7n5v5nemMJhLN0avf0EOxDtiko6gtBb4BTuPYARwiL0c9KzK6Bzj2UNNhT5VOcVF/K9mQFzJmncnq6VasQjjafWpEL0Rimm1QznGwjpkYHV7mZfadSggSbwNskTJXvIzJcL37TB/3xbLslFo+52mLHfCIzKUzXgSQuqmplrwz17NAfQSSZXHNXD78fVCLjGpJFq7o3uklZ9JuX37H7vuPlAfb+JACy+OWVm7fzC/HFiPdoNqS7cRhG8
 bIa7JapS
 wIMAdylUPSHOYO7kqReAJgmJE7uLQyEcTDHSUEJP3uG8nIXK82gKrPXGTtHApa7WIwTun6Eh5MI0x3T9F6mANqjC6jOZPJ0mceixwz+3VEh81fRYCakA/Z0uLX+/ksMlY7H32JQjEHB39O1rzfKyiGoLM6y5Nsf756OyqtHkmPJ27Mjj8Dm3rUwFtXXJxdJz2jsXcndO5TeZgix4FfEGzupV5OaQ2YFy37dmKQUFG1o/SLejm2NoWSptaCUysOPTr+7CB0KKfjPLYZtMWwegtacmk/mFvrGgeJ+v45wI7rJIrtrS14ubEtgPpnvLUghC4nWfYue2buKuXinjYYUlRhnoV0aCEEjSqgyCGfs5qmWyhws/itpfHjFu2sEuqjatRBWs/QUStDoDT1rB0c5WMUu6pzbiOqPnGfRaszlidO3756bUQr1nr7UgQgBzo/ndu0ieTxA/Kuf0cJq6bOfwNzZZhSOgAxsLzPKuEyMGNRp357dVk0lEm/6OYgEJsoHmlUH/tKfFaokk3A1wHQ9FFiJWWA8xca6N1RjRLXXA8nuYVUrJcgQC63D6yISq8N+1q1aUdq4AyPNqhE/w6uI7daDwv+F6pz+dnD6/8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 3:12=E2=80=AFAM Mani Tofigh via B4 Relay
<devnull+mt4022.columbia.edu@kernel.org> wrote:
>
> From: Mani Tofigh <mt4022@columbia.edu>
>
> Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even
> for SWP_SYNCHRONOUS_IO"), a fault can read a swapped-out mTHP range into
> one large folio in the swap cache.  The folio only becomes anon once
> do_swap_page() maps all of it, so if the faulting PTE changes in the
> meantime the folio stays in the swap cache while not being mapped or
> anon:
>
>   Task A (fault)                       Task B
>   do_swap_page()
>     /* swaps in large folio F */
>                                        madvise(MADV_DONTNEED)
>                                          /* zaps the faulting PTE */
>     /* PTE changed (F not mapped) */
>
> swapoff then maps it, which marks all of its pages as mapped and
> exclusive, and the next fault on one of the other PTEs crashes in
> do_swap_page():
>
>   [    6.424485] kernel BUG at mm/memory.c:5195!

So what's being triggered here is this right?
BUG_ON(folio_test_anon(folio) && PageAnonExclusive(page));

That check is a bit overkill to be a BUG I think, and we have been trying
to remove unnecessary kernel panics. Before f1879e8a0c60 we can occasionall=
y
see large folios got stuck in swap cache and partially mapped (e.g. failed
writeback, see activate_locked: in vmscan.c, much less likely but still
occurs from time to time), but the ones still referenced by swap PTEs don't
have PAE set so we are good.

Now the problem here is unuse_pte() calls folio_add_new_anon_rmap()
while only one sub PTE is mapped.  So yeah, that's a problem.
Still it doesn't have to panic the kernel though.

>   [    6.424503] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>   [    6.427654] CPU: 0 UID: 0 PID: 67 Comm: swapmthp Tainted: G        W=
            7.3.0-17087-gd865f2677c44 #1 PREEMPT
>   [    6.432665] RIP: 0010:do_swap_page+0x24eb/0x2fa0
>   [    6.451035] Call Trace:
>   [    6.451567]  <TASK>
>   [    6.453841]  __handle_mm_fault+0x13b5/0x3b40
>   [    6.458525]  handle_mm_fault+0x16f/0x480
>   [    6.461143]  do_user_addr_fault+0x312/0xa30
>   [    6.462044]  exc_page_fault+0x66/0xc0
>   [    6.462846]  asm_exc_page_fault+0x26/0x30
>   [    6.476708]  </TASK>
>
> do_swap_page() already drops such a folio from the swap cache when it
> can't map all of it.  Do the same in unuse_pte() so that swapoff swaps
> the entries in again.  With the fix, nothing is reported.
>
> This bug was identified and confirmed with the help of a deterministic
> hypervisor currently under development.  The C reproducer below however
> hits it within a second.

Great working catching this!

>
> Fixes: f1879e8a0c60 ("mm, swap: never bypass the swap cache even for SWP_=
SYNCHRONOUS_IO")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
> ---
> This conflicts in context with patch 41/47 of David's v2 series [1],
> which changes the line right below in unuse_pte() for KSM folios.  I
> can rebase on top of it once it's applied if needed.
>
> [1] https://lore.kernel.org/all/20261029-fixes_core-v2-41-a64ce7f83abb@ke=
rnel.org/
>
> Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/sw=
apmthp.c
> ---
>  mm/swapfile.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 189f04d8838f..b0b75ff16835 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2518,6 +2518,18 @@ static int unuse_pte(struct vm_area_struct *vma, p=
md_t *pmd,
>         if (!folio_matches_swap_entry(folio, entry))
>                 return 0;
>
> +       /*
> +        * A large folio that is not anon yet was swapped in by a page fa=
ult
> +        * that did not map it (yet). It can only be mapped as a whole, b=
y
> +        * do_swap_page(). Drop it from the swap cache and swap in small
> +        * folios instead.
> +        */
> +       if (unlikely(folio_test_large(folio) && !folio_test_anon(folio)))=
 {
> +               if (!WARN_ON_ONCE(folio_test_dirty(folio)))
> +                       swap_cache_del_folio(folio);
> +               return 0;
> +       }

Force dropping a large folio for any swapoff doesn't seems very
reasonable.. We really should reuse the common large swapin code between
unuse_pte and the ordinary fault processing code, and there has been quite
some patches just for unuse_pte just because its out of sync with
do_swap_page.

But, having this fix first and backport for stable looks good to me, clean
up and improvement can come later and I'm trying to properly split the
folios when the PTE backing it is partially gone during swapin, that seems
much more reasonable.

Introducing a helper to avoid code duplication from this fix is also a
good idea.

