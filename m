Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48CADCF6BFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 08:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AE066B0092; Wed,  7 Jan 2026 03:37:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385CF6B0093; Wed,  7 Jan 2026 03:37:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292676B0095; Wed,  7 Jan 2026 03:37:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1474F6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 03:37:18 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA3D11401D8
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 08:37:17 +0000 (UTC)
X-FDA: 84304513314.17.E79EA00
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id BC6E2C0003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 08:37:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DL5LpQgX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767775035; a=rsa-sha256;
	cv=none;
	b=uKlCacH5gyzfBXA8XqsfTL1By4FGS8PkoWlzroNIFwzhZ+4F+SmXu0WYy/fwqroLQBkgoA
	KSfnU3c1NGUZQSoe27EUNARBjHzLIE3FmGtBF0wDFXKXHc+tx7WsKgCFOjBp1Plp5xlL+4
	wTywKZQ31gpW9mKvCAwMcX7NYFKxCPk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DL5LpQgX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767775035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdAcvdDBIdlI3ixkRUxMILmY4jLEVswSgN2G6I9tIGk=;
	b=7LIRdAWrzetN2qwwGg5PIAL2cT4m3orQSy+XvuXO0CV99ov37T2PjL5XSXk18zwUg/m3Al
	lpkBds5KGqvor8x54sLHQRvKJeO3/Mj7qBQJ0LnSAu9vtaNE0uFLjEmeMkVsl3LVAS8XlQ
	qg4rlhF5CRSJYM3FlAnqvWVU7oU0CAo=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a3e76d0f64so2420175ad.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 00:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767775034; x=1768379834; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qdAcvdDBIdlI3ixkRUxMILmY4jLEVswSgN2G6I9tIGk=;
        b=DL5LpQgXqHvuxYeLRBGJ0o6cIoA2TBnCt5zqcMeAjk7C6yFMrli7MsjuYVfo29xANG
         F8vwh2GiI32FM3s5+GtXmOtA8Gym09dU/kmm39LraJid1mxGV96XnGO+77cYelDoJcv3
         CvLoIEVe5ml/SFP4ekBQPH0z3w7IUhQQjZ+G2euk1MWWPerZnBvbAbdrEKQCIoQRuiM5
         lRLvJt1RbE3l4ouF5KcahOlj0+x58sdJ2ihCuimgoHXBE5feJm8NAJjBZvhjzY6W5EVc
         RlXyfnYsnXy/9baGJBcqYxGVXwxkRR0aj3tqqEwMlaQ3w5W1mXZh9F8rVpfgY+gn77fL
         cgKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767775034; x=1768379834;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qdAcvdDBIdlI3ixkRUxMILmY4jLEVswSgN2G6I9tIGk=;
        b=Aw99XdMD/UZOOoL8lMTT3EosoIZ2zvKVZdURewQnTJqkQkYgbpsiBpFLI/vOTtcEs7
         P3tLIMKd23mB6KlEPm4QdDn5NxpfZcTKGY43DdSE6jT1kLbvJ7zrrxMU5azo8RBQzwwX
         Faw6XpW6KhjUVwsPiO81qm9+TyzY7FdMTijKP0KtR1/AeHefvOdDluoxN4NDFYpEUOJe
         aaWr7KZFF82KDqMNxtwXySwSPy0hIIju+qwnmol09XWMD3Y/MhMSrtNNiNcaxvXr58fk
         vqfFMyLEOlCz9Hqxondw8cEhCftzHLVVr+X1kZFLMuphpXSXarvPHrLBjpvZJG7fCLSd
         llnA==
X-Forwarded-Encrypted: i=1; AJvYcCVqZPdKXOY3luenYTZ8DqE4poR8+nw1JqRqUkr2PzFEGa+ZVylllxlUakjdtuzJW/S/+Gp1gUnulg==@kvack.org
X-Gm-Message-State: AOJu0YzL1lLMRwIVIzOlCDbmK4m27ufq3ONCTxUcHBL4ZEl0c/c9R5Zw
	bMa86TqUdelHV4LowMQiCwPzgcDw1s0Gb2fMlwKUKhy1TQxbLUOq6OPb
X-Gm-Gg: AY/fxX7SgXHG3w4z0t4U8lA2Gv9xTHn6dxyoTTiVJENEEFNOWdxFMy/WqNB+KGr6Ayg
	7UqcnCZx28RQFvRiGpy9ACOzjTCHsXBzkGGOab4jCBrpmicBMsDD7yszZLlGU/aGTk5Zv5UTxRJ
	tp+XoJSFd6XcA6Ch3NHVTJojHg+4p/19ay0oNH797YMMSz0LSPuPFliSAKAFMUCqApPq303jB+b
	0h0MkK6c++lCdGQqYl55CDct5MTJWw/0xCz1sEudoHKFlOUiCVemXw6VT1RN8kir/xuONnCeqSI
	Yi1OLprlcRA8bV9mmVYH9Qfn/lNbIzsGRtHmN67eFxe/d3mWbACY5yjRcKPmEB9JUqRJ5mq7x7K
	aJqf975YZzcUrG5gOp2SL1qyKKLZ0JCt0Sj+V2+tyVaJ/xSgj3WL/3W9Qrq0kcYx1k/++OZa1Vx
	wMx53P18zgvrFBdrhmBDP4ZbU=
X-Google-Smtp-Source: AGHT+IEjlT4LeKIRIsQ7dHOBBnnFwcB+UWyf40UyxxuJhutt8jucLZvg1T0hSGRL1JfewCwjHRFhFA==
X-Received: by 2002:a17:90b:2247:b0:349:162d:ae0c with SMTP id 98e67ed59e1d1-34f68b4b2admr1959009a91.4.1767775034311;
        Wed, 07 Jan 2026 00:37:14 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5fa7820fsm4286447a91.2.2026.01.07.00.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 00:37:13 -0800 (PST)
Date: Wed, 7 Jan 2026 16:36:48 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, dev.jain@arm.com, richard.weiyang@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>, akpm@linux-foundation.org, 
	david@kernel.org
Subject: Re: [PATCH v3 5/6] mm: khugepaged: skip lazy-free folios at scanning
Message-ID: <hkswa6klm7vizw77ldhchjkrbjhtl7ystvez764sif4v6onbij@i5y4ngzmyvgy>
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
 <20260104054112.4541-6-yanglincheng@kylinos.cn>
 <9c82ffaa-5f62-4110-80cc-00f0c46e90fb@linux.dev>
 <3lbptab7e2nhqilwnoccq6kxks2r55j3ffqtslt62o2qtgulk5@w4mwglb2kd75>
 <d3fd4546-3161-4d58-b018-31aca53b6b04@linux.dev>
 <CACZaFFNJO+-yZdDPdN-5rQLuJvT5cp2pbtqV13FHo9PeqtxARg@mail.gmail.com>
 <cf094519-82e1-4f11-b670-dacf89da22ef@linux.dev>
 <tpowqsrlxwx6hu5ljry54wpt5lverarqeincc3jufrqhfjmwwy@uzs6q6gecubd>
 <CAGsJ_4wXg_jZQ+RTK=zR2vohijz7A+RU9nXdp2CDmyE=Zyvu8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4wXg_jZQ+RTK=zR2vohijz7A+RU9nXdp2CDmyE=Zyvu8Q@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BC6E2C0003
X-Stat-Signature: knqqf6nfmdyan1zcsyeqozzecrrsq447
X-Rspam-User: 
X-HE-Tag: 1767775035-880411
X-HE-Meta: U2FsdGVkX18ir173B6gosZ3c+/FT1QOj/g7o9RK3zFVF1drYkpQRheK23myEtzbfK57uvnV1BUfIrhOmoAjvpI9tMPK6bGGbHgMJUlfomtflpuvxKYNaSZg3knNRSgfOHzadKgbNuJy/wyziP6tndD77LNNYqyuMSp2oBgUuavqX9JAKhJI6pBgdhdHtcnc5UKJHV2hcd/2+bTc/8DVEjFW5Enb8rKgs+sRH8TxkpXf9AltCkD/o5kDkTy1zoCWjbyzr28C5ch4tlQEZRhHbWNXuz/U1I0GciYKz0CAYUW//yOncJDTGtFsefwzj4LjOstnAXOt39iw+ms7gcKDYVrdFsjxPIp5bX6t3VELroGBm2y5PMgHEjzd9f8VL3FBQg4k6LQBa9mQayH+fuObFLDnLVxK43ckSc1g6zgJTANnUJ2WfmVbd4NGJsDGPXADxJNOpCgT7JlEh5job6wJwNYzqTuQn/ZtFrgUshPWz6G24H7VfGrNZH3zvqrc670oz3f6uDzyCKnS571q+rDFMNZuYKaIPGsGjJOr5IMNT7TmLNlTg6v9FJJhKS25biVMLzqW8ZlqchSl3qAfZq+Yu18cu3c1Xx7CI426pl8cLw3rFfZaht6iQW8Pj3Ew+CxhyTbcSDVnox05p4dopxMqNFboJkf205K078v193KyKr5BhqYviVlAHH5t680YKHdE6HtI9UPQA03MJQSOD5kQdsp19SpQUgA4m8hc6DzeqcAOS54Ialr9JpglXQyLdtmhFypChGBNsPoXdxNd9F/R0iRYI5t9Ak40ZIhAsNVtm24gQrPUXlDwBtz4Td1/H3l6Afn4fMFeOszYWtSGNASP7dlNdskBq3qIUrMHPGircQE1IRyCs8lZK4sG7nAom4xDhkDI1nUpl1XC+8uvj01gDN0xsNJLIF9jtj3LssuoVAPuY5INRi2yWO/YGcbC610zHKN+LK4IaqI1TI3zGbdl
 laCobZJV
 WmYeimTyLIe9egMglTY6xjtCQYkTjZFZmN9A0lkWQTt6DehHzq8MY+Hk8Ubu82zUpuHY+BR9cHW8w5Mtoaoo3MM5ApoST6wq+vS08BPM6Q9t7ySDlTwxQopsfpgvA1x+J1K6IBUKplrJ2syCCQjAK3rE5Vahp53qTz1y0qweOME1+xMxc0IbHU09OYS7fL4qzqCcLviVnVRjFDfa+yeefNGV3gW5RBQwdb7dfyqlWz1Ue1Vkqoyt5B9/+pOSLtJrJhojksVvc73zTEk5/DlfhhIiDEFf+nVcx5+Q2FS73ifaPEp0fmJbVDzCU5XLKx8pTpgUybWEo0J2rm8YJIigzTp9JO7wkgt1VY/s6W+oVlpumIdWhDeTOuJUVQgUSQRS0HYJayzQ+t7gb0r3B6DMM0hD2BdQeTVKfDDZmXuCSCqPQ+0z6xZ6xBSYpESJy9cctitO3GNloSXPJXcAlXUoxZjb2rLcqe6pE/tC0EJbvUhpQcUpRHje6Uya2hmEOvmanWbI5NTVuS3RzyVFIP5GfdaRFVrzZWf/xW/83bY2V6pfE2JU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 11:33:35PM +1300, Barry Song wrote:
> On Tue, Jan 6, 2026 at 1:31 AM Vernon Yang <vernon2gm@gmail.com> wrote:
> >
> > On Mon, Jan 05, 2026 at 11:35:58AM +0800, Lance Yang wrote:
> > >
> > >
> > > On 2026/1/5 11:12, Vernon Yang wrote:
> > > > On Mon, Jan 5, 2026 at 10:51 AM Lance Yang <lance.yang@linux.dev> wrote:
> > > > >
> > > > > On 2026/1/5 09:48, Vernon Yang wrote:
> > > > > > On Sun, Jan 04, 2026 at 08:10:17PM +0800, Lance Yang wrote:
> > > > > > >
> > > > > > >
> > > > > > > On 2026/1/4 13:41, Vernon Yang wrote:
> > > > > > > > For example, create three task: hot1 -> cold -> hot2. After all three
> > > > > > > > task are created, each allocate memory 128MB. the hot1/hot2 task
> > > > > > > > continuously access 128 MB memory, while the cold task only accesses
> > > > > > > > its memory briefly andthen call madvise(MADV_FREE). However, khugepaged
> > > > > > > > still prioritizes scanning the cold task and only scans the hot2 task
> > > > > > > > after completing the scan of the cold task.
> > > > > > > >
> > > > > > > > So if the user has explicitly informed us via MADV_FREE that this memory
> > > > > > > > will be freed, it is appropriate for khugepaged to skip it only, thereby
> > > > > > > > avoiding unnecessary scan and collapse operations to reducing CPU
> > > > > > > > wastage.
> > > > > > > >
> > > > > > > > Here are the performance test results:
> > > > > > > > (Throughput bigger is better, other smaller is better)
> > > > > > > >
> > > > > > > > Testing on x86_64 machine:
> > > > > > > >
> > > > > > > > | task hot2           | without patch | with patch    |  delta  |
> > > > > > > > |---------------------|---------------|---------------|---------|
> > > > > > > > | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> > > > > > > > | cycles per access   |  4.96         |  2.21         | -55.44% |
> > > > > > > > | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> > > > > > > > | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
> > > > > > > >
> > > > > > > > Testing on qemu-system-x86_64 -enable-kvm:
> > > > > > > >
> > > > > > > > | task hot2           | without patch | with patch    |  delta  |
> > > > > > > > |---------------------|---------------|---------------|---------|
> > > > > > > > | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> > > > > > > > | cycles per access   |  7.29         |  2.07         | -71.60% |
> > > > > > > > | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> > > > > > > > | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
> > > > > > > >
> > > > > > > > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > > > > > > > ---
> > > > > > > >     include/trace/events/huge_memory.h | 1 +
> > > > > > > >     mm/khugepaged.c                    | 6 ++++++
> > > > > > > >     2 files changed, 7 insertions(+)
> > > > > > > >
> > > > > > > > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> > > > > > > > index 01225dd27ad5..e99d5f71f2a4 100644
> > > > > > > > --- a/include/trace/events/huge_memory.h
> > > > > > > > +++ b/include/trace/events/huge_memory.h
> > > > > > > > @@ -25,6 +25,7 @@
> > > > > > > >      EM( SCAN_PAGE_LRU,              "page_not_in_lru")              \
> > > > > > > >      EM( SCAN_PAGE_LOCK,             "page_locked")                  \
> > > > > > > >      EM( SCAN_PAGE_ANON,             "page_not_anon")                \
> > > > > > > > +   EM( SCAN_PAGE_LAZYFREE,         "page_lazyfree")                \
> > > > > > > >      EM( SCAN_PAGE_COMPOUND,         "page_compound")                \
> > > > > > > >      EM( SCAN_ANY_PROCESS,           "no_process_for_page")          \
> > > > > > > >      EM( SCAN_VMA_NULL,              "vma_null")                     \
> > > > > > > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > > > > > > index 30786c706c4a..1ca034a5f653 100644
> > > > > > > > --- a/mm/khugepaged.c
> > > > > > > > +++ b/mm/khugepaged.c
> > > > > > > > @@ -45,6 +45,7 @@ enum scan_result {
> > > > > > > >      SCAN_PAGE_LRU,
> > > > > > > >      SCAN_PAGE_LOCK,
> > > > > > > >      SCAN_PAGE_ANON,
> > > > > > > > +   SCAN_PAGE_LAZYFREE,
> > > > > > > >      SCAN_PAGE_COMPOUND,
> > > > > > > >      SCAN_ANY_PROCESS,
> > > > > > > >      SCAN_VMA_NULL,
> > > > > > > > @@ -1337,6 +1338,11 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> > > > > > > >              }
> > > > > > > >              folio = page_folio(page);
> > > > > > > > +           if (folio_is_lazyfree(folio)) {
> > > > > > > > +                   result = SCAN_PAGE_LAZYFREE;
> > > > > > > > +                   goto out_unmap;
> > > > > > > > +           }
> > > > > > >
> > > > > > > That's a bit tricky ... I don't think we need to handle MADV_FREE pages
> > > > > > > differently :)
> > > > > > >
> > > > > > > MADV_FREE pages are likely cold memory, but what if there are just
> > > > > > > a few MADV_FREE pages in a hot memory region? Skipping the entire
> > > > > > > region would be unfortunate ...
> > > > > >
> > > > > > If there are hot in lazyfree folios, the folio will be set as non-lazyfree
> > > > > > in the memory reclaim path, it is not skipped in the next scan in the
> > > > > > khugepaged.
> > > > > >
> > > > > > shrink_folio_list()
> > > > > >     try_to_unmap()
> > > > > >       folio_set_swapbacked()
> > > > > >
> > > > > > If there are no hot in lazyfree folios, continuing the collapse would
> > > > > > waste CPU and require a long wait (khugepaged_scan_sleep_millisecs).
> > > > > > Additionally, due to collapse hugepage become non-lazyfree, preventing
> > > > > > the rapid release of lazyfree folios in the memory reclaim path.
> > > > > >
> > > > > > So skipping lazy-free folios make sense here for us.
> > > > > >
> > > > > > If I missed something, please let me know, thank!
> > > > >
> > > > > I'm not saying lazyfree pages become hot :)
> > > > >
> > > > > If a PMD region has mostly hot pages but just a few lazyfree
> > > > > pages, we would skip the entire region. Those hot pages won't
> > > > > be collapsed.
> > > >
> > > > Same above, the lazyfree folios will be set as non-lazyfree
> > >
> > > Nop ...
> > >
> > > > in the memory reclaim path, it is not skipped in the next scan,
> > > > the PMD region will collapse :)
> > >
> > > Let me be more specific:
> > >
> > > Assume we have a PMD region (512 pages):
> > > - Pages 0-499: hot pages (frequently accessed, NOT lazyfree)
> > > - Pages 500-511: lazyfree pages (MADV_FREE'd and clean)
> > >
> > > This patch skips the entire region when it hits page 500. So pages
> > > 0-499 can't be collapsed, even though they are hot.
> > >
> > > I'm NOT saying lazyfree pages themselves become hot ;)
> > >
> > > As I mentioned earlier, even if we skip these pages now, after they
> > > are reclaimed they become pte_none. Then khugepaged will try to
> > > collapse them anyway (based on khugepaged_max_ptes_none). So
> > > skipping them just delays things, it does not really change the
> > > final result ...

here

> >
> > I got it. Thank you for explain.
> > I refine the code, it can resolve this issue, as follows:
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 30786c706c4a..afea2e12394e 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -45,6 +45,7 @@ enum scan_result {
> >         SCAN_PAGE_LRU,
> >         SCAN_PAGE_LOCK,
> >         SCAN_PAGE_ANON,
> > +       SCAN_PAGE_LAZYFREE,
> >         SCAN_PAGE_COMPOUND,
> >         SCAN_ANY_PROCESS,
> >         SCAN_VMA_NULL,
> > @@ -1256,6 +1257,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> >         pte_t *pte, *_pte;
> >         int result = SCAN_FAIL, referenced = 0;
> >         int none_or_zero = 0, shared = 0;
> > +       int lazyfree = 0;
> >         struct page *page = NULL;
> >         struct folio *folio = NULL;
> >         unsigned long addr;
> > @@ -1337,6 +1339,21 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> >                 }
> >                 folio = page_folio(page);
> >
> > +               if (cc->is_khugepaged && !pte_dirty(pteval) &&
> > +                   folio_is_lazyfree(folio)) {
> > +                       ++lazyfree;
> > +
> > +                       /*
> > +                        * Due to the lazyfree-folios is reclaimed become
> > +                        * pte_none, make sure it doesn't continue to be
> > +                        * collapsed when skip ahead.
> > +                        */
> > +                       if ((lazyfree + none_or_zero) > khugepaged_max_ptes_none) {
> > +                               result = SCAN_PAGE_LAZYFREE;
> > +                               goto out_unmap;
> > +                       }
> > +               }
> > +
>
> I am still not fully convinced that this is the correct approach. You may
> want to look at jemalloc or scudo to see how userspace heaps use
> MADV_FREE for small size classes. In practice, it can be quite
> difficult to form a large range of PTEs that are all marked lazyfree.
> From my perspective, it would make more sense not to collapse the
> entire range if only part of it is lazyfree.
> I mean:
> for ptes as below,
>     lazyfree, lazyfree, non-lazyfree, non-lazyfree
>
> Collapsing the range is unnecessary, as the first two entries are likely
> to be freed soon.

But if the later two entries are hot, we not collapse, the describes of
Lance may occur.

> >                 if (!folio_test_anon(folio)) {
> >                         result = SCAN_PAGE_ANON;
> >                         goto out_unmap;
> >
> >
> > If it has anything bug or better idea, please let me know, thanks!
> > If no, I will send it in the next version.
> >
> > --
> > Thanks,
> > Vernon
>

