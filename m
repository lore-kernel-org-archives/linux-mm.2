Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B60FC2A062
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 03:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF7CF6B00D2; Sun,  4 Jan 2026 22:13:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCE616B00D3; Sun,  4 Jan 2026 22:13:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C053C6B00D4; Sun,  4 Jan 2026 22:13:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABB5D6B00D2
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 22:13:08 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BC0B161E53
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 03:13:08 +0000 (UTC)
X-FDA: 84296438856.30.C4C306D
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 47EE7100003
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 03:13:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jBZs2sla;
	spf=pass (imf14.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767582786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+K/sCYDJhEVaxdXKwyK2DyU+EvOU97PJwPpnKB0Rbo=;
	b=UeAFXIj/LnLLgBANEOgTwop0vOQ4kudrHS+6Ig91ESzIq466gpOF1CD/MbPHffb7cUxVcp
	jSQM3ntTluKtIKSlX6pJJJjunB3dLKAikB0buRg0sOzEipTlqHWOBgKLSjc+r5zU3es/PS
	N3bQWQLim6UTFbZNq42x5nOAd8fKTYs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jBZs2sla;
	spf=pass (imf14.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767582786; a=rsa-sha256;
	cv=none;
	b=in41vBQHnocnckQWiB3KerVNnCpzOhkJa0qm7MwoX7sh2IbYSz+iNOpi7OtmyNZW5TQbe0
	Z2/I1engeCKTRXjtyqWZiUawrnrhEclknPHJtHNtRmU8k08tYw4yivJlOvO2eo/1dfGO+Y
	4hB6uuKqjKmOZF6Tp+1VrHURR7UmgGk=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-59581e32163so15896386e87.1
        for <linux-mm@kvack.org>; Sun, 04 Jan 2026 19:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767582784; x=1768187584; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4+K/sCYDJhEVaxdXKwyK2DyU+EvOU97PJwPpnKB0Rbo=;
        b=jBZs2sla8viHX/k5RFIs/77QdFfX75YYDU1eV3VZzldhLMayvegVSegDK9omiI9qTX
         nLMioM+gxd2/1PVB/Pe/Mnb66swcDRF9iLgrfdJdMZgf0Jv52KK8s9stNJpESyKM+r1F
         sQdo+pxLGrDX3NR39bwFct/0aN9ns/+hQFfg6oWkYL6lQkb5QI13XXWZSScpqLadqN30
         lvZqn64kNbLQjCUu0G+pJ+2ZShyyhFV4bUTsdtR1b3k0YJ6bdLDzJVy6zjVP8c3YaCwM
         dmscgBcjyKFekRZU8Z2DQKTFSQpMieJ+wb9dZs7AUQHsi2Tpjy6RxNhJAKBRXQ/oZILt
         o1Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767582784; x=1768187584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4+K/sCYDJhEVaxdXKwyK2DyU+EvOU97PJwPpnKB0Rbo=;
        b=iAYaW9xpEth68ujcbMl0zkBL5vwaCHaNybtXTS0Ct251snwA8Gmq6/U0fCkQmldVsc
         nBtIEZ2mtXuntb+cSavbZDC23j/Yz0BxAKV+5r3VMRIpXesvEJD3G2NxDE9qBkqaxTgf
         jH9RAWRVXa22l3ZSNmLxk97Dp5wQHf1dVe8jN6/tj5GwtRHHz/0/2mMxHcZJb8hq5CIM
         TtL0jVGlVfxhb6O/eH9eCzXKjy/Qblx3xnWQwqhHIdQ4L+R1Od8WzX76YIekB1MB/me/
         nW0cvmBJJXv/elQwaoFUzZzHhPNgLvi5xKhBqaHfvnXfqRjSK0z53yRZyuVaOX7J8mac
         mF9w==
X-Forwarded-Encrypted: i=1; AJvYcCUzsR/cYSANl3pX2Te3t+APvvJaalm3poa7heP/c6GHpxzDKuLL8XJiPEdaEcuVS25NAJRbr8TVuA==@kvack.org
X-Gm-Message-State: AOJu0YysR1rMH6oNE8E2m8CVM8bUaG/L/BpWd+RkPlwP/aG8Ont7a4X+
	hyO6Z4nFSDBl48CeqKbruCsKYas2t8FJL4NjMJvDRMkNTQKhmszOG9bt0144IY9Nc02kZMPxS6Y
	ewLnVUJmrSNL9zmi5I2zgGxOIn+aUDy4=
X-Gm-Gg: AY/fxX6BjNLBJIDEg0fava56D/xwYbvpLlpiCWZ6DgJOmHMZLamNH+MnyNZdeG9XVcC
	FJVenrVtxedOmm/tRpxOjiH70ceqEf2ROO2/qcnzi84JySOJYuaMbU4xzfCXM2nlpMBtnCJBorw
	ShlPX4qxYGlcAA1gWBHchDyrwZ6fKCnDWaZ3N0I91qj9UwuIyi68Z/2/7TiGW3DXKEnq64DV6Zh
	G2eYWPVuoM4sJTv5xqdNY54tU7lvW5TzJDpMO+PsRHuaBCWOp3akIS1XF0jj2nGL67IfX0=
X-Google-Smtp-Source: AGHT+IGOEItbgRdlFdlHI487vZtIkm8w95d0t2DtO8/AIIrBuU/rx1+Mn8c2Ml/qezSy5fUqWQYyOwPe2AiQrn7M7BI=
X-Received: by 2002:a05:6512:15a1:b0:598:853e:4866 with SMTP id
 2adb3069b0e04-59a17d67bcbmr15491289e87.51.1767582784138; Sun, 04 Jan 2026
 19:13:04 -0800 (PST)
MIME-Version: 1.0
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
 <20260104054112.4541-6-yanglincheng@kylinos.cn> <9c82ffaa-5f62-4110-80cc-00f0c46e90fb@linux.dev>
 <3lbptab7e2nhqilwnoccq6kxks2r55j3ffqtslt62o2qtgulk5@w4mwglb2kd75> <d3fd4546-3161-4d58-b018-31aca53b6b04@linux.dev>
In-Reply-To: <d3fd4546-3161-4d58-b018-31aca53b6b04@linux.dev>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Mon, 5 Jan 2026 11:12:52 +0800
X-Gm-Features: AQt7F2r-cVUYnw7m8mH_FI1G1zV0Oatw8uLa_T6POQQP9mh9zTYKSzjuEsW7DVs
Message-ID: <CACZaFFNJO+-yZdDPdN-5rQLuJvT5cp2pbtqV13FHo9PeqtxARg@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] mm: khugepaged: skip lazy-free folios at scanning
To: Lance Yang <lance.yang@linux.dev>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com, 
	baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>, 
	akpm@linux-foundation.org, david@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 47EE7100003
X-Stat-Signature: z874g8x67cu3rntefkuoqjjrhnk9hrpo
X-HE-Tag: 1767582786-842476
X-HE-Meta: U2FsdGVkX1/5LWA9nKNx4nJODBdRbxkqRo0KJ0My3T7wX4Jh/JNmpjDCXsRu/6OCYd3KdK4qhGwpj92ua/sHyNfSti7uSMYnLlzkQQT1WETkQRsB4MQja/Gl4qJyJLQ+A93zIPaR3cHZIbKpnft3ug25bQjY2et7knLQDTgsoNsNb4Gn6XFfzUPzBxmgKjF/qt4sp2QD+KvZMsIKQs/l10VxRVuEnJbE/ktm5jiqTbR+hlP005mIfKR5S2m6adChWOpH+krsCaPybA104IDQ7nxOKc7pGMGYVVoNQxM9IucJ/o+jM57gR1p2fpzx113vCfkGRDfGIG14ZTYKhRZPPt5Vjcy1RBdiy3p6hzBF4IkJe81eoPDpkJBtGTt5n2ISCrKCsfsT9gUUTYVQSYVmmJrM8ONjOFcK4SJGQNCKBdZRl+38PGDui8VNuzRTobuAjcQ1bhr+J31lu5wLV0OUTa5VF11LiAlyv2VE1lkR+wOWSEHysvYBWLxbvdE3Af6tsu9IbAr+gJdSpy4D2iYGMBx3XOsOY0iTlgwC7EFSqOqucv53w9Lk0Vt/yCGcGbECvvk8Hf+6ItegSh7fpIhVDszQr0m65/8hkvArNOhbci70bksDQRKi8kssPhJmRc1NbLXu/t8z1o1GR7gCNn+B8ed/IT4f+UbOvSeydk3WVUVfSrp1jH8mxfzf2X1qEt9X8GEG0bLUFfYvMyKj9nxA4mf3+aMY1ANJefW8sCf7fPPMEWPwYPhUCZ0oUIFtbAMjvyNJbGvQINGHa4gAYz/D6mdiV2QNyf3nlxba1CUWvrDorrOaJ+Hfh9oYkj7aKUkRQeT8Ao+3gd2GyvEA55wWZs5wfpgHmPaSIWxIjvF781UN548/F0eV151P7zv5E+c7gl7NLh5mrq4LAHy7hi7t3Qp3EJIQhSyyCvHYWgbwR6+yzxK3A8VnjJOQoneVYR3Ey9ixjVW+akYbd4Dq0t8
 mRdld/af
 zz/x7RhRJkpz/DkKel6XL9NzwkSBpTpm630NdEZtaWhZTJOqyZYG+Tccei6cR/ogrXWYYTwu6ALUXo8YbThjS0akflVSK6XbG9kPDmatCMwitMAxIHdp935Wcue4ZarcPdgs1EiXIxulr7ULfGpmWuXGlI76QUqW+lGDPZ3L7KbtrFf+GKLcLYXFtCqJhwqitldHes4E4Nuepd0dhR7nwDInMCNFQVh8TNDkukjWp5eApphfrWcZr0OGUaelDNFimaVdgZ/mdpyGcszbOkDXtAEluJUNW4sR5ZpEgXEdHCz6jptCJ0PYbeTOiDdrrKk7wmpRRlPtQhXumsJCOL5PQwG7kHfm9kR6RTHGs+CXTsCzOghmn/hfYeJ/iDg9sCg3f5icMXpx8m5dooEMNGg7sl2HUoFvktxJ99sqhxDyNRvviiAY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 5, 2026 at 10:51=E2=80=AFAM Lance Yang <lance.yang@linux.dev> w=
rote:
>
> On 2026/1/5 09:48, Vernon Yang wrote:
> > On Sun, Jan 04, 2026 at 08:10:17PM +0800, Lance Yang wrote:
> >>
> >>
> >> On 2026/1/4 13:41, Vernon Yang wrote:
> >>> For example, create three task: hot1 -> cold -> hot2. After all three
> >>> task are created, each allocate memory 128MB. the hot1/hot2 task
> >>> continuously access 128 MB memory, while the cold task only accesses
> >>> its memory briefly andthen call madvise(MADV_FREE). However, khugepag=
ed
> >>> still prioritizes scanning the cold task and only scans the hot2 task
> >>> after completing the scan of the cold task.
> >>>
> >>> So if the user has explicitly informed us via MADV_FREE that this mem=
ory
> >>> will be freed, it is appropriate for khugepaged to skip it only, ther=
eby
> >>> avoiding unnecessary scan and collapse operations to reducing CPU
> >>> wastage.
> >>>
> >>> Here are the performance test results:
> >>> (Throughput bigger is better, other smaller is better)
> >>>
> >>> Testing on x86_64 machine:
> >>>
> >>> | task hot2           | without patch | with patch    |  delta  |
> >>> |---------------------|---------------|---------------|---------|
> >>> | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> >>> | cycles per access   |  4.96         |  2.21         | -55.44% |
> >>> | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> >>> | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
> >>>
> >>> Testing on qemu-system-x86_64 -enable-kvm:
> >>>
> >>> | task hot2           | without patch | with patch    |  delta  |
> >>> |---------------------|---------------|---------------|---------|
> >>> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> >>> | cycles per access   |  7.29         |  2.07         | -71.60% |
> >>> | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> >>> | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
> >>>
> >>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> >>> ---
> >>>    include/trace/events/huge_memory.h | 1 +
> >>>    mm/khugepaged.c                    | 6 ++++++
> >>>    2 files changed, 7 insertions(+)
> >>>
> >>> diff --git a/include/trace/events/huge_memory.h b/include/trace/event=
s/huge_memory.h
> >>> index 01225dd27ad5..e99d5f71f2a4 100644
> >>> --- a/include/trace/events/huge_memory.h
> >>> +++ b/include/trace/events/huge_memory.h
> >>> @@ -25,6 +25,7 @@
> >>>     EM( SCAN_PAGE_LRU,              "page_not_in_lru")              \
> >>>     EM( SCAN_PAGE_LOCK,             "page_locked")                  \
> >>>     EM( SCAN_PAGE_ANON,             "page_not_anon")                \
> >>> +   EM( SCAN_PAGE_LAZYFREE,         "page_lazyfree")                \
> >>>     EM( SCAN_PAGE_COMPOUND,         "page_compound")                \
> >>>     EM( SCAN_ANY_PROCESS,           "no_process_for_page")          \
> >>>     EM( SCAN_VMA_NULL,              "vma_null")                     \
> >>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >>> index 30786c706c4a..1ca034a5f653 100644
> >>> --- a/mm/khugepaged.c
> >>> +++ b/mm/khugepaged.c
> >>> @@ -45,6 +45,7 @@ enum scan_result {
> >>>     SCAN_PAGE_LRU,
> >>>     SCAN_PAGE_LOCK,
> >>>     SCAN_PAGE_ANON,
> >>> +   SCAN_PAGE_LAZYFREE,
> >>>     SCAN_PAGE_COMPOUND,
> >>>     SCAN_ANY_PROCESS,
> >>>     SCAN_VMA_NULL,
> >>> @@ -1337,6 +1338,11 @@ static int hpage_collapse_scan_pmd(struct mm_s=
truct *mm,
> >>>             }
> >>>             folio =3D page_folio(page);
> >>> +           if (folio_is_lazyfree(folio)) {
> >>> +                   result =3D SCAN_PAGE_LAZYFREE;
> >>> +                   goto out_unmap;
> >>> +           }
> >>
> >> That's a bit tricky ... I don't think we need to handle MADV_FREE page=
s
> >> differently :)
> >>
> >> MADV_FREE pages are likely cold memory, but what if there are just
> >> a few MADV_FREE pages in a hot memory region? Skipping the entire
> >> region would be unfortunate ...
> >
> > If there are hot in lazyfree folios, the folio will be set as non-lazyf=
ree
> > in the memory reclaim path, it is not skipped in the next scan in the
> > khugepaged.
> >
> > shrink_folio_list()
> >    try_to_unmap()
> >      folio_set_swapbacked()
> >
> > If there are no hot in lazyfree folios, continuing the collapse would
> > waste CPU and require a long wait (khugepaged_scan_sleep_millisecs).
> > Additionally, due to collapse hugepage become non-lazyfree, preventing
> > the rapid release of lazyfree folios in the memory reclaim path.
> >
> > So skipping lazy-free folios make sense here for us.
> >
> > If I missed something, please let me know, thank!
>
> I'm not saying lazyfree pages become hot :)
>
> If a PMD region has mostly hot pages but just a few lazyfree
> pages, we would skip the entire region. Those hot pages won't
> be collapsed.

Same above, the lazyfree folios will be set as non-lazyfree
in the memory reclaim path, it is not skipped in the next scan,
the PMD region will collapse :)

> >
> >> Also, even if we skip these pages now, after they are reclaimed, they
> >> become pte_none. Then khugepaged will try to collapse them anyway
> >> (based on khugepaged_max_ptes_none). So skipping them just delays
> >> things, it does not really change the final result ;)
> >
> > This patch just resolve scene for hot1 -> cold -> hot2.
> >
> > --
> > Thanks,
> > Vernon
>

