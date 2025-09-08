Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA238CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 10:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D2608E000E; Mon,  8 Sep 2025 06:41:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AA2E8E0001; Mon,  8 Sep 2025 06:41:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E6F98E000E; Mon,  8 Sep 2025 06:41:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 29CBB8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:41:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01574C0AD1
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:41:08 +0000 (UTC)
X-FDA: 83865740658.17.DEAC0B4
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0225B180004
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:41:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cFpe2Jdy;
	spf=pass (imf06.hostedemail.com: domain of hughd@google.com designates 209.85.219.170 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757328067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PgQX2wVjrXWCDgPEti9JrRCjB/uTC6KZSt3aT19EMWA=;
	b=NU5EM9x3YEpGAvZfiZNfWif8xKIUZtkz1s0kta8ux3/YC+O7waQJGgwNHqEr4OjkIpxCQ+
	3h9h57ZWq6oROhtGyYl1aveRwjkt+Zw+VeCx8O/vAKn2ENeslBWEeIzII2SLBrWc+LBHvi
	NKSbH5YK0FP+0ajCfVTO+2ffPB8N39Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cFpe2Jdy;
	spf=pass (imf06.hostedemail.com: domain of hughd@google.com designates 209.85.219.170 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757328067; a=rsa-sha256;
	cv=none;
	b=geXY5HYnT2kAJ5DaepR1jTdsE8FprVd3JsEJuPTfy2cpES6wHC0+73g6sEfQjxNXYjUykA
	zAfdcEhGmhYFlSenEGtOwOMF9rL9qXto8kXj2VtEZZs7DqkqEf/Xmr2xb+8XtMTFzXRONb
	RQyHjmAM0l/UpotGrMVl1UckGxUdZGs=
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e9d5e41c670so3962707276.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 03:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757328066; x=1757932866; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PgQX2wVjrXWCDgPEti9JrRCjB/uTC6KZSt3aT19EMWA=;
        b=cFpe2JdyeTi5htGppIvD5z+1ChESP6IphNWPn00k9Mw7CXmy6K+Wk+35324VGz8zy3
         RCV0L7biIJkwcp5vJssjdGxREXbLB0WpuZBd9NsG/Te3YRIan3SC6Kp8yAKS/ECxeyBY
         j5zLLLgF6LEEm3fcjhCx0AsMGTttEqnWBZUA4yYq+7GQw9qA7TbWnmvqPx+VyiF3OnAA
         s4d+38kASxT+ZW9RzWliGJDcGjtZzWYcTP0HYcxgK1gZOMEygqeKdSMrkpBHg4Xx+L7D
         hTq/BQzVYsbSqqboGHAAOyZpwaFO/Kl2j+NHLYmCD1rTv3EQMFMWDeVCdHJfLbuSEvnA
         DRxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757328066; x=1757932866;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PgQX2wVjrXWCDgPEti9JrRCjB/uTC6KZSt3aT19EMWA=;
        b=f0TWVQ3t0VuN3AvqvN6vXTiBlmzm1m53gPHf+JlEjAxgPCFRZ1AGbNXRQQi05Zin31
         lxnd4+QZjYef2xOcn9ZAiCcmDwdRGopr/j7xLLVAuZeRXGAj3Pbr57abd1B2NcLaBKJK
         p6MHe6UQmsokSo0VfVT2G0l/58kCa2BXqklG4nhhY1RebqO2W8Cil4qMcrwnGon4rvhu
         THxxt8bjnSVnGiowtzD3ZfsdvCkoWicpyp+Q/srlvawQaZnhkUvTxCOVZzeqKXJOkM1a
         lOzBtGR57uAoP4ioJxZtFowKGZCzqthEVq6Ym9Iil3NrZveNI1HrnUhiQIAkz3gLnoZW
         Yq2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWP4UqZ/vC98JoimBlI6DcCF8+OzhWchQwCIdm3XhRx5XGHw8wkMy1aaQ3TdLynLqKFFJ4jz57JPw==@kvack.org
X-Gm-Message-State: AOJu0YyMBbs+PHjM/EoHot89CuKu21r6VzrOG7XzM7tUW30zWsWOmCMz
	zLXtS19pXB8TqMaB5pAIyuw37+iXv5E/yPLLgaKoaF9IOzrA1hKSJrxEhp4OndPghg==
X-Gm-Gg: ASbGncsm/TijB6YVAPA9cdIi1ilhcl++4gCujzQTiA5oq2QyoJYIHwCILu6GdJtw4rN
	USiXqE8fAw5N8ZNswy06M93+u2mWv0wpMMpoKQxcLNle2kdpZhyVp3buPZ+fKtItO+xf0HqENtP
	jrLe3jIZ2yHCIln6bc9ECeiuRWywMFfTBY0/HnIN8VTtOcvdD7LW15oQv99lrl2rDvgCZpXl14V
	4FTgqZhTdC47xUgy7c3Gk+Z+tH91I7REfvTWsbQ4CzMtIZu3BJ2F9eKVzvD8j+VImNs6P9DmkRH
	AUBogE+lhNtD7ZNgNNLfHKpYvtdcy9eJbAbK+ZGjes3mdoJ7e5TKwic9fRekWcfcAIoEP5cu53S
	vV7FURY9E66c62uziZZ/F1ZfSQw2hgCHV1or9vC6wPT90Rz+YgU2QU/IbJG3uxDcuEw07dw9B5r
	eyDlwEJi2BlqmmBu2CBKRK9/sd
X-Google-Smtp-Source: AGHT+IFPUzPrmMuGqYymtA/EsR5L9cPsDdw3hltvchIp0nKAJ6ffXeCZG+zbzSfw+JCOtbL6FoAJJQ==
X-Received: by 2002:a05:6902:6317:b0:e98:8b69:f437 with SMTP id 3f1490d57ef6-e9f67ea5375mr4369860276.43.1757328065893;
        Mon, 08 Sep 2025 03:41:05 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e9bbe08a7b4sm5448785276.25.2025.09.08.03.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 03:41:04 -0700 (PDT)
Date: Mon, 8 Sep 2025 03:40:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: David Hildenbrand <david@redhat.com>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Will Deacon <will@kernel.org>, Shivank Garg <shivankg@amd.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Christoph Hellwig <hch@infradead.org>, Keir Fraser <keirf@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
    Frederick Mayle <fmayle@google.com>, Peter Xu <peterx@redhat.com>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Alexander Krabler <Alexander.Krabler@kuka.com>, 
    Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: Re: [PATCH 2/7] mm/gup: check ref_count instead of lru before
 migration
In-Reply-To: <e54b1d8c-ad63-4c7a-8b1b-b7c3d76446f2@redhat.com>
Message-ID: <b008aef2-f69f-e2fb-d4d7-71a42d308529@google.com>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com> <47c51c9a-140f-1ea1-b692-c4bae5d1fa58@google.com> <e54b1d8c-ad63-4c7a-8b1b-b7c3d76446f2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0225B180004
X-Stat-Signature: 3t5a7iph95t8jxp1j7atc5xar5zwdh5j
X-Rspam-User: 
X-HE-Tag: 1757328066-339811
X-HE-Meta: U2FsdGVkX1+YujVtxMdC/pUgTJj6c6n1q8ZLLw77sPtnsddxdfwPd4E4HcshXRKOQ1WFGAePhJ4VzgCR7n14HNG3UDc8vC2b5EkOjjDnS8bo8CLxk0g4vic3eV7Hc9tLemveivCii0msWuT8bSYDfceMRPTL24kH+ksGbhLgV4qTCRRiIc7eZXxN42w36RLPuD8JjwWDLWSZKKl0p2rATDNdBzuHN6XaiY62NSO6uVqhBOZbtmGwHwhOkOUag0vpwShUFqSgTXshbvuhuNxKU6oEUIsWX0fkSmEDvrXEo2vEKTUrvdDh2THSzyTxk6Jim37VFMcPe6szwwWc4M0EEHYCMScK8bc9c50GcLtIradyt3+e+IyPcmgJqsKhSpCGqZXlalu0dkaDX0PuvQdFlw4fFu10YYnUR8ignaZSddLN2Nv0g74a4HHEIPtVpxN4imZoHlmLA1nISZTPpotvllbCWwUIgFtmODDhAl3S3cGByJr2qIuXzF3DO5ePGHcy/HpqW6PzNVzTkFEBzxlftgJ4XyZR2+wos4KwFyIhuyWhCOxeUcgfvmufGyQot/fvjYWpQTEk9x5aO+IEo+4LWQwkPSfMlxh6VumR8akEZj88lERzG1VYzJ1yBrVe939DSQ1UsyfyZf5J/jbU8Dx3MFvERc7RvOW5bbNWfjnZy/RCeZ4v+7AnVwk8i0I9eXpAJHjBkwVLGO8GVtsk0oblWmAZDPkTuWaOUIZsZLuYqSeArGpyJZsEQGOpA/arH92UvDdEdG80+5wv8LATkXw1UO9FBE5waL3yC34Mf5jLoaY9avgUCMJP4ANLMkwpQnNXZT1SBAg/XB8C4k3jw3sYCgbPwASlYssBIpBZ63+moNLHgvooxhp9WAQKtnLKOoKeqLn+dNG/JDJHq/rVOOoxcA0pEDV8OP5AsETSvF5KEFHIxtrUb+g393luRbs5KVlZW7cxM/1XpYbCuU5JrVm
 vWORD5/4
 tm3hRzFBRtPDoeLX4WAntZA6Z1IbVumSI0VrnzlB0uLLJ1iPad6oEjGpQCBeO7ic1jH8/DEKdqHO7Ltmi9fevjzXtOkGtMocYO+vmXyM0mm/Gh/HWstlyq6/XRPchN4tmg/g+CALICLlDu0EXh4Qinu6ZflGsl6AnliXdYO0ABm58oSpc5FVOQplBpfIK0MOLtkcjYQ4z5o2YyD1UBqfGIR/iDOIH7UGe51eCyOuzs0qgYQjcyWWMSHaBI1tlyme0K6lg8bB2+Zbmtux8Kv5tMZaN6z2SLCEYeeglBUDm6DeERioa/OeHP8c2PER4NBu+Nwg3KN84c/NCLYKgRaJMpNiUMP9acsmVfOELNbVEkzbgOS5fum5NI0qAnkOU1FvzL2m5npp7C8FHh6llDGLyodAyAizzunzQ4UBYqv+SbOqBr2UaMhm+Fxxyjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Sep 2025, David Hildenbrand wrote:
> On 31.08.25 11:05, Hugh Dickins wrote:
> > diff --git a/mm/gup.c b/mm/gup.c
> > index adffe663594d..82aec6443c0a 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -2307,7 +2307,8 @@ static unsigned long
> > collect_longterm_unpinnable_folios(
> >     	continue;
> >     }
> >   -		if (!folio_test_lru(folio) && drain_allow) {
> > +		if (drain_allow && folio_ref_count(folio) !=
> > +				   folio_expected_ref_count(folio) + 1) {
> >      lru_add_drain_all();
> >      drain_allow = false;
> >     }
> 
> In general, to the fix idea
> 
> 	Acked-by: David Hildenbrand <david@redhat.com>

Thanks, but I'd better not assume that in v2, even though code the same.
Will depend on how you feel about added paragraph in v2 commit message.

> 
> But as raised in reply to patch #1, we have to be a bit careful about
> including private_2 in folio_expected_ref_count() at this point.
> 
> If we cannot include it in folio_expected_ref_count(), it's all going to be a
> mess until PG_private_2 is removed for good.
> 
> So that part still needs to be figured out.

Here's that added paragraph:

Note on PG_private_2: ceph and nfs are still using the deprecated
PG_private_2 flag, with the aid of netfs and filemap support functions.
Although it is consistently matched by an increment of folio ref_count,
folio_expected_ref_count() intentionally does not recognize it, and ceph
folio migration currently depends on that for PG_private_2 folios to be
rejected.  New references to the deprecated flag are discouraged, so do
not add it into the collect_longterm_unpinnable_folios() calculation:
but longterm pinning of transiently PG_private_2 ceph and nfs folios
(an uncommon case) may invoke a redundant lru_add_drain_all().  And
this makes easy the backport to earlier releases: up to and including
6.12, btrfs also used PG_private_2, but without a ref_count increment.

Hugh

