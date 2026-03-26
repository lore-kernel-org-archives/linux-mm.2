Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0891A109E550
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 05:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33F366B0005; Thu, 26 Mar 2026 01:31:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0116B0088; Thu, 26 Mar 2026 01:31:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DF2D6B0089; Thu, 26 Mar 2026 01:31:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 099216B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:31:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 68E1D1A0BA2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:31:18 +0000 (UTC)
X-FDA: 84587091036.26.E16CA71
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9B2F540011
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:31:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fvmRXRUl;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774503076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SCaEAJNhTo2UqbKFUufVu1cRos+o9lEhWFxuFYsDYtk=;
	b=ycmGPcPPrlZSAdGwzdJXuk6+QTAPyWCgp4T4UTzG0rZjOTgL4gYuOrwwtO4Y41GHCQaF2y
	tsN35yzFQPTXdcqAGlK7FqhAnLCHQ9lZamkrb72rQxlplfOy4qyJu9J9AqZhNdP5su5fhF
	e70P3WgLm/lJ5grthcV0INK2W9tfm54=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774503076; a=rsa-sha256;
	cv=pass;
	b=XVUAgbXZCSQT39nMCoZb4LQurC9IJYRoP7VOwbIvjtWSCDG4E7HpXZRZKEaRIhv6Ulq0LW
	kywf/+70RvgK0WWd/8VdEfO/5qOyjb5qx1eziBwFs2aHIUN44KvfO2fRI63Ey0duC/VSNL
	nVvRrXwY0VcYB++OitH3bIrd9a4ehos=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fvmRXRUl;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50b268fba9aso6090371cf.3
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 22:31:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774503076; cv=none;
        d=google.com; s=arc-20240605;
        b=NxM+bvYhU+UFGIrbB29QI5ER3sHgJxk+aTIKhnAV9RGsfWOpTPh8UH817zNivJYOvA
         7DLOPNsh/eskUOYD3CT0bjMyYV0VYOQQXbWMBSaTSXqvEt5EYiTTHPEoi2zXl/ms14YW
         OqDbw1ieSDOWFlaaxZyL8lqyQokWzUoaTZL3MyBZUqkpQbMwsQoevMNlGp+bFg3BtI2G
         rdxl7CQqSNrD6R5G//4ZUnJq7F9hD0pVZ3PITxdbR9JB80sTNItmZ8QjGmfmzMotVmnS
         G2nvW4nDTwFkBnORa2HuHntXIqEPnwVOqGShT12HHCybXbddyMpP3UTVUzbFCUIwRcqc
         uAhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SCaEAJNhTo2UqbKFUufVu1cRos+o9lEhWFxuFYsDYtk=;
        fh=LM7iBDeOGACTa4DrCGxDBaPTjphNe9e4GI4fqaCaHcI=;
        b=NGvu9b6oY+G6+qRm30+Reo3mxjcXqP3vntqxfWI+wWnOlUiCVYS5np/0QE6KOrTbaP
         4hPrMN3GWTYhja/ALLxHrAgao451QbFuTFuMe+ISuk/mBRQzPI1SMHHDNDnPemv9BgXg
         ZFYVZ7EyYH8luFK/kiswsWfnCYbxKBWkoL/utwNXqQItIsbSjdyMH2z+P+GjEvFTllKq
         UDFanArutfTe4TZrjpg4n5yzEcZCuppxqEr5jnryRDecJhB+j7TUeGzfEP6VvJ3fa2Cj
         V2vbg842c7rGDmDjqzqXa3KjcbHdojwVo9VcIKV2E2TveQScQcb4FoEzcpBk/9CYDg9g
         u25A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774503076; x=1775107876; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SCaEAJNhTo2UqbKFUufVu1cRos+o9lEhWFxuFYsDYtk=;
        b=fvmRXRUlaqnqsNysdT2WTkd7u+u8qufqXFrs4K5/EteSOoCVH+SZNAkPVIRU5BVA2w
         y8U5iyhQa/P8V6tnfr313iRmg0TkOZAEAujhJoRBlP7bMEx7xdmyLeKZutA6nFN5UWQB
         FqfVni94XJLFUSJ7x0wwEJYUFj5cHsQEuUY36FWX6rdAcQaorOcLCnCcfjSHRx0SXhyF
         We32NaeYB7ArWeYKO1OTmJdoetiNqW+N7JKTTr+IOKSFIeAnlb82Z8Y2vhaZuyj0AXzN
         LqnHcPwQPKlJL/LpFBoNkrvMZyBScFKeBJi2YBpS63v0AL18tSmYo+X+RRVoir3cNzEh
         /4ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774503076; x=1775107876;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SCaEAJNhTo2UqbKFUufVu1cRos+o9lEhWFxuFYsDYtk=;
        b=A0LwbhQTBbTXwzeCwqwEsmU+oIbKyT485phON557zowT8YyseDwecNh7qIdjLjzftQ
         jAVESrfSxIok/efj7t4muWVd3GtWBTHd3hCayCvgZ+06lgHzSaOnW5+ZKI8m/of94AuA
         eflj9ZxCm9JpIv8ncj2aSgyUyljkXYbLKB2uSUSYsJ2hr9V7CM4/u3Jyo3v+UxutWzoY
         YUTDgn5fYmSwsz8hRI7MLPdAExvckDk9yWfr4Nj+AWxCqpKgwsAd18+WQ5YjP5AtuYab
         G1tuqW0IwZddWUdn1Ztp02Q2QH2OCNRBtHQ4CJ0Q8Rvigusy1/ZueHJCW8MHvaNSkCD2
         ZqVg==
X-Forwarded-Encrypted: i=1; AJvYcCWZJ0aEDWCNAhZnFRYjCgzb5mZWDvhUsU9AGIzhQ6OzZ+KtIslZ38pKIqkx9IN//uiwobagA5UlaA==@kvack.org
X-Gm-Message-State: AOJu0YymymGrx6RSuOgV5esJef1ONhtgWBsNSucu9MlCx2sAiraHMM4m
	kIoxevNw+s3l3Gubha5GHNhN/auQUk63f+yh58CbKER5GauCNmj+duWkEd5NoeupTAnFk2auXQ/
	/Y7rgy7vYCK0HTXJz95tWigIYnVeCEI8=
X-Gm-Gg: ATEYQzzseH974fJFsgdGBjftm4hyv/IAYlRxA9JCEEf8zbRvFZ2UO0sNooXGB/kTlwS
	ncVIYwcFpy2W8tQmMFkOoj1se/EgU1BCHQrCnFYAqg4lMZ+y4GCqYoYt8CeEoVZaQp7YTCFHJB6
	Z8WoQK3TSlK7UAQ7Zw1dAtB6tQk5hsNnvkGEHOGS+XxBB7zk8turKQs6GQkTF1OBEPj9XIbQqPu
	2KHJEfswW39eRHsx/i+SVz82PJl1cN3EHkXpkpKT1VR+SnJFCp87hfJ6WXTSnKTN9YkXRm9h2YU
	9x0UcDSUFC5w3dcugnz/ghHRkkpQJ3skLIY4lv3TBBzPGzRaYgByEnhnzED/iSvoiq+m5lLOxg=
	=
X-Received: by 2002:a05:622a:649:b0:50b:4537:2e21 with SMTP id
 d75a77b69052e-50b80e31f63mr88188291cf.45.1774503075181; Wed, 25 Mar 2026
 22:31:15 -0700 (PDT)
MIME-Version: 1.0
References: <12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4yEWn3kVZPQZatOJX7NLLv-OK9pAqUDuWz25XxG5hpV=w@mail.gmail.com>
 <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com> <CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
 <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com> <43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
 <e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com> <86f611cb-1292-44e4-b629-6503135d33ca@kernel.org>
 <e5cb474a-a84d-4edc-8289-d68378feee7d@lucifer.local> <e3e374cc-ddf2-4112-b063-6cb1839ea566@kernel.org>
 <e227a7f7-0186-4d10-b7b4-c84ca8424bdd@lucifer.local> <bfd282b1-523d-4945-97a0-ec30fe1df577@linux.alibaba.com>
In-Reply-To: <bfd282b1-523d-4945-97a0-ec30fe1df577@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 26 Mar 2026 13:31:03 +0800
X-Gm-Features: AQROBzCIiNeStZAQ0EbA6A6QH1SNX_HIcZ_FnWTDII6KaQNjc7QCXZELtVpC91U
Message-ID: <CAGsJ_4xL8Rm929oXG54TRXeL8LoHqMYM76rGUc8eKWwC_iPZKA@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the references
 for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, 
	catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com, 
	ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com, 
	harry.yoo@oracle.com, jannh@google.com, willy@infradead.org, dev.jain@arm.com, 
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9B2F540011
X-Stat-Signature: 9wiog93ingxnfuen7696sgnhnjni1r1x
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774503076-943430
X-HE-Meta: U2FsdGVkX1/iSZDQ1ExM5IrgDUPrW9tQNfJusV6uAMuWWmR1eTTkf2LW+6ORrUhlej55TURSIkqFXF6gHxl38qQ5G4LXTTXET1jG6WTfSCI1MUqHxcjpROEEPRUmaPOB1xmD1AB67euUKfB68ZWx7hg2ABnWY0e4z4yKdai6vyHn2Gxp1zuIt1TlhK0JLTooy9cqQnBumN+SXtja8FouTu9G/GlwKBvPth8iqhXeD2cGG4Z2FAW3b84zF0tkV5SwboKxRwwIsIcKXvoDqh91kcKOojsOaCo0Ww1ed4jv6D77b6KY6t+lWPSB/lgT0R1WKil6BCpU2TVpKKzvipJcFvBDuXnC3tfbsKC6Guzf8ImxxyW3KogZIUqF65EljBsuxtor5NwaSD5L6R1O3++jCtA75WyBWk0SIoZ58Mu2elS5K0E50XuaCi4l35+2xse2vy5ONjd/EmlfmjQpppaJzK3EU5oPTjoZZn3da5nMA4Zb4M6RBW3hVPvjXB/KfcTYJeyZ0d4E7yoZvgcyzKnno26xslqbzzS1nXItvqeNZR6pZUo60+dzsc1Vzirn4NriFyhqnUiNPBRpzZeKvlnlLo+WNauHDoBfSnQ7DMF3TNTV/uLPP8hNKkDTBgbQiKco8uHGWLoQnUBkxjy6WNzzQN0eW8Zlyk7BNa1GhdMRArSgSceVelHXBJlsZ253kMjioAkz/7P+jrgWlhniaCgN+LBP8cC0kTmpnHtNyX8k/hwNSDPnHKDKW5YkI1Hq3qntOISssWCSRuwVufwCImgpod1ucSRqFzwL7CUFLvo8drLRUMVRdKMjSJqYQL2qA/LJu7rxMptJHa+k5iByYpcz0Lcytxy5MSX4Db3CJY+P78rHOFUT3NUNvcdSnFEVHUh2xLYjvwoG/gPLNA8uDBVTxkw+QZALu5EOuwYbV3/HjE9LbtKwfF/EoC9eXGl/A+VK3d075t/m1m3T+kcJ7MC
 yCIRSRcP
 7aXJfoyGA5yEetKRaqpGpR9cSpbgw7G3OgUFbTpZPgXkQMr0ogq6AgRQ1Lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 9:47=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 3/25/26 11:06 PM, Lorenzo Stoakes (Oracle) wrote:
> > On Wed, Mar 25, 2026 at 03:58:36PM +0100, David Hildenbrand (Arm) wrote=
:
> >> On 3/25/26 15:36, Lorenzo Stoakes (Oracle) wrote:
> >>> On Mon, Mar 16, 2026 at 03:15:18PM +0100, David Hildenbrand (Arm) wro=
te:
> >>>> On 3/16/26 07:25, Baolin Wang wrote:
> >>>>>
> >>>>>
> >>>>>
> >>>>> Sure. However, after investigating RISC=E2=80=91V and x86, I found =
that
> >>>>> ptep_clear_flush_young() does not flush the TLB on these architectu=
res:
> >>>>>
> >>>>> int ptep_clear_flush_young(struct vm_area_struct *vma,
> >>>>>                 unsigned long address, pte_t *ptep)
> >>>>> {
> >>>>>      /*
> >>>>>       * On x86 CPUs, clearing the accessed bit without a TLB flush
> >>>>>       * doesn't cause data corruption. [ It could cause incorrect
> >>>>>       * page aging and the (mistaken) reclaim of hot pages, but the
> >>>>>       * chance of that should be relatively low. ]
> >>>>>       *
> >>>>>       * So as a performance optimization don't flush the TLB when
> >>>>>       * clearing the accessed bit, it will eventually be flushed by
> >>>>>       * a context switch or a VM operation anyway. [ In the rare
> >>>>>       * event of it not getting flushed for a long time the delay
> >>>>>       * shouldn't really matter because there's no real memory
> >>>>>       * pressure for swapout to react to. ]
> >>>>>       */
> >>>>>      return ptep_test_and_clear_young(vma, address, ptep);
> >>>>> }
> >>>>
> >>>> You'd probably want an arch helper then, that tells you whether
> >>>> a flush_tlb_range() after ptep_test_and_clear_young() is required.
> >>>>
> >>>> Or some special flush_tlb_range() helper.
> >>>>
> >>>> I agree that it requires more work.
>
> (Sorry, David. I forgot to reply to your email because I've had a lot to
> sort out recently.)
>
> Rather than adding more arch helpers (we already have plenty for the
> young flag check), I think we should try removing the TLB flush, as I
> mentioned to Barry[1]. MGLRU reclaim already skips the TLB flush, and it
> seems to work fine. What do you think?
>
> Here are our previous attempts to remove the TLB flush:
>
> My patch: https://lkml.org/lkml/2023/10/24/533
> Barry's patch:
> https://lore.kernel.org/lkml/20220617070555.344368-1-21cnbao@gmail.com/
>
> [1]
> https://lore.kernel.org/all/6bdc4b03-9631-4717-a3fa-2785a7930aba@linux.al=
ibaba.com/

x86: ptep_clear_flush_young does not perform any TLB
invalidation. simply, calling ptep_test_and_clear_young()

RISC-V: follows the exact same behavior as x86.

S390:
simply, calling ptep_test_and_clear_young()

powerpc:
simply, calling ptep_test_and_clear_young();

parisc:
set_pte + __flush_cache_page
but ptep_test_and_clear_young() doesn't need __flush_cache_page()

arm64:
ptep_test_and_clear_young() followed by
flush_tlb_page_nosync() can still be expensive,
based on my previous observations.

others:
ptep_test_and_clear_young + flush_tlb_page

revisiting the comment for x86:
        /*
         * On x86 CPUs, clearing the accessed bit without a TLB flush
         * doesn't cause data corruption. [ It could cause incorrect
         * page aging and the (mistaken) reclaim of hot pages, but the
         * chance of that should be relatively low. ]
         *
         * So as a performance optimization don't flush the TLB when
         * clearing the accessed bit, it will eventually be flushed by
         * a context switch or a VM operation anyway. [ In the rare
         * event of it not getting flushed for a long time the delay
         * shouldn't really matter because there's no real memory
         * pressure for swapout to react to. ]
         */

At least I feel this also applies to ARM64?
Maybe Ryan, Will, or Catalin can clarify why ARM64 requires a
nosync TLBI, whereas x86 does not?

Thanks
Barry

