Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED59ACCD19A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 07:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 548B78E0007; Thu, 16 Oct 2025 03:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9388E0002; Thu, 16 Oct 2025 03:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7D68E0007; Thu, 16 Oct 2025 03:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 28B4E8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 03:32:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC1EA1DD804
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:31:59 +0000 (UTC)
X-FDA: 84003158358.14.3B6E1DE
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id B35831C000D
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:31:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YLIc0jg5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760599917;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j/xCn9ZLnPU5SjhfsEFXQQU1A2rrcxC3wMAyKVdAXkk=;
	b=yzp6nceR0mfBoc+46BYRnFZZVy6SPIfxvLdhYQO4qTuyMzQGiijfCOTWZvGZzyQOfjGDBO
	hx1+6q6RAVbGvZsSGgcCDbb5/SEwO9xzdRtOu8df0pKZa3ZMq8cDTVbCkVTsHwkugc7KHd
	A9+tTX+rsfSfk5vJlIVIiVhv2JbPjWQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760599917; a=rsa-sha256;
	cv=none;
	b=xJnYZcHehHnU4DYKlIPBNzL2XtpurMI/BzOmrHdnKTRSWm0DoB9NOmpHmB+GOE0IAzwJIk
	LKO+6HiuhjolWT4iLbQ62ON33z2udSDui1Tgj+0PbM1UI2KQfjtUWehve90TiUuaXsv8YR
	+ZMS8SBCRKB4+mGDujEnkIGzTwnia4M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YLIc0jg5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-63bfbbbdd0bso781977a12.3
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 00:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760599916; x=1761204716; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j/xCn9ZLnPU5SjhfsEFXQQU1A2rrcxC3wMAyKVdAXkk=;
        b=YLIc0jg5n3fCr2M7VFH+7RyrWndMwIQXpKmNt1+8HOCDkJAojp3kK88AcE+vlMGx5u
         2DJkt3k4iKmeLDCeh2+tznO9KrjR3mZbwIQY0xfGPL/ABRyk8bCw70d+1pE5TZbuba2q
         V+vWM9yXXjhP4xqP/yBG8ig8O50oJ3RJ2sZQTjPq3eBWSH3xvTr2GmOdbcQJAz+nLzib
         pL2+rampkWIPfGYZwYLkWI8kUrU8fiejX24KezqzCnjlHfuXtZtkk0dzG7SYdk/tbp9J
         XcBRqJW1YO69HcvLq1XBHmf0k/acnYPV6meFqtjH+UkNufKqH3XnbuKnvKgpdfeXpUIK
         OKGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760599916; x=1761204716;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j/xCn9ZLnPU5SjhfsEFXQQU1A2rrcxC3wMAyKVdAXkk=;
        b=D+m2H1lokzEdFSeWggjcWNQA9XbRCIp5UiCr/voy/gRwdtQXWPaazhvFgzU/rNCsEI
         SEuRCgE4lW8pdE4IzMA+peNO+PGbw4jySy0y6haSa8nPtJpYfnG22KdiWg8uYGudiicQ
         KF5+GMUajqiaFonGAq2YlM986Td+3XTT9M1LEkWf1TcYk42bS5UbGbvhhfIvDBzM8myA
         Tt6GQ8IPrpzny7M1juUCGAbNfQMjN9TD9uU1UYubNt9pffrq7VsiSw+CH1UEBCErr4UY
         2GfkcuFkzhzdVPBNsqdGJpS81cDTZfxC0pCXkEXvhuJVxHf+1SBhlgMdP7Sr5JSGSr3z
         0gIw==
X-Forwarded-Encrypted: i=1; AJvYcCXKCLMZKxKSwAhknt8Qg7BEKKzWocSQi7ukvlzGUIe7hnJ/l2B4ViovuvqzeHEZ5uZcuAh3o/5NAw==@kvack.org
X-Gm-Message-State: AOJu0YziAVUnVqDnNP9X/NdCMaiQNvY9rN0TNdrxRt+Ggho/yGThn7dB
	U0KRvBtL9CqnO/znzUS8I2yXWX66+GBdoZSqCa61nqX3NJVafix159DX
X-Gm-Gg: ASbGnctS4PRFv8wjw2nXagK2x7AfO+Ek/1gcASNQT0nQtzAa/0wj0XC18f3VMH/9zLi
	iyADZHd7RGcq5xu6XRWnM0UGhCfmv0TGvwCm7++CMj50pIbwIz4mrLu2+KTT6+pwXuF6fy9Wi+n
	JG4jnhWsQTziC3pKeUyLeXi2r6A2OPVrf1DqRAKDdmzqidvCOrUko1FuB/96gdXz4oTS12hint6
	CAceVJC06kz7U3ofYHzhmer0JMAbZ6b6Vv1ED75Fn8DRxG9VDvHsdLoa/ytXoL7zfgStmCqGbqW
	NKUyhkQlblNNLMe0XWZqq9M9LdV7IRO5BXHb2iMf0REaefXZrO8r+juYy18RxoOGkN/GV1nH5lo
	WS32ly4VifMXohYDHgrE8q3ZUJ7JU4S/ojtb59qd/xck20wAIrc/0p0WSQsnABfsbnGrtsk8612
	WQY1EWPzvvhg==
X-Google-Smtp-Source: AGHT+IGUvAIwpaxHWzzdwac13S1QOSDuohR/UN6k77FdmvL5uVxRJPPLfJW0okmo/Fz60mD03IKWVA==
X-Received: by 2002:a17:907:9617:b0:b3f:f207:b754 with SMTP id a640c23a62f3a-b50abaaf85emr3444754566b.30.1760599915853;
        Thu, 16 Oct 2025 00:31:55 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5ccccb5132sm439674966b.54.2025.10.16.00.31.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Oct 2025 00:31:55 -0700 (PDT)
Date: Thu, 16 Oct 2025 07:31:54 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
	kernel@pankajraghav.com,
	syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org,
	mcgrof@kernel.org, nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Wei Yang <richard.weiyang@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v2 1/3] mm/huge_memory: do not change split_huge_page*()
 target order silently.
Message-ID: <20251016073154.6vfydmo6lnvgyuzz@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251016033452.125479-1-ziy@nvidia.com>
 <20251016033452.125479-2-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016033452.125479-2-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: B35831C000D
X-Rspamd-Server: rspam02
X-Stat-Signature: y698pmfksaduucu6hjnwmkyjzijs66ne
X-HE-Tag: 1760599917-325595
X-HE-Meta: U2FsdGVkX18CRBI0re1h13tLZTNaBDErHl5Mopo+b0IVfk65I+SBf60L16GSJSUdwjjisSa0rA7wp75votgyCbUMj/PRq+Dqis19uFeMwPhEnDxdEW5n4PB6ITisB7fcCSXaBjNK3NHCV0Kknu/xbOMlvMqORB0AyhgTWm2g4oKl2G8E1aB4qvc+FX+cQuObBU1M1PaKA/Y32n2jJ5TVQwrk69uuexmrdWcZj0RWphwl3xNc6nKm25uC0ED0Pq7E8iAcH60ZqGqKXhlnlo/Vm2oNUMNi1NBUndgQqMQqWJH1lWWjpIr0X1UXJwsIzOKFgjdEZo4p5Ty7jh+5tzh7HvNv6sekLMUcw9AKF+pUKn9kNTY6a/yOds84KAQuuH4g6Pd4h1nfMqs5RslbgcbFHTr0mAxT59058KDdCbtFi2ACUsVgaiNa7vzNYdCgbCW3KMpT0egELwJRKwWt51/pqFnWl/WMFJ9QOSlPSRwHiBGVgD3IyqTITEyC7qbm+FSgoZS9ldMnkDtEri+uHCxIE6r+6nLIngWdHk2pwAcSmW6PcxtXxN7TP3OKUqvQQHp7FavJLtiK8iJ0jn+JEE/2eHcDYWVgc+kLIQJPF/afxGs89OqwDf4BmKEaVYtg9TS3Ff/hdzEebFcc/SAjgC/52RSpdAF82ETeIKlHG/zR20alKTrJtrWbXZ9DSAuYjsqaMavxIU9bNTBtF0Vj6Nd6I65rrgwtnGzWKTVIWdmEXIbXkyFdVGunsC+I2vo4XYmvYtWreVzcsViuL+r3aTZmLE1RBCQRp99fkseCLqmChAhIg8H5uzhlb3TPGwKTKA8DqOZPPlMIBFQvQk54TICsJ89lxr+pIuiihOfb1csBG1KVBcQPZfCroIKg1jyrfBVvJoJ9VZ/BsyQn6ooQd8beKNTVTykhU/25ed8BDA/8b2NIRlwpUvF/RCmJU554YIzA7nSeBsm2KeqI0QfkQiC
 i3R0UAoW
 LJDeYEdLrNhazTGscMIYWmJ+M0JXmZN51flasqvIwK234RREMlxHepr55MgfPKvafPJzEBDjPrkWdLtBWbAUJ1fFTukSvET8nSC3opjsbXd0l1Ol+7KHIU05QkXAW5WOy9gNfUWonIllydRyImuRpIOB33kws79oCL5u1zCiBZj4jehB+r0/nvyBW6F9z8mJDumwjDTKjkhF7KswPhtXt/1ufrYeJZQ2FwMqaIbNNfMNLoGU1AczhtXWHjxHrX0k/atIOdZNlnntrc1uwlKqmjPFCT3NLqgxo94qp7xtpBOoCfnZJVod7h/Ebui/ntLLmKg9Xyq1UgMFnZTmKj12K6mtrQ2kQo4oCFbR3SS32oEhHOc0whyBUWS1WuPtED0SeBPqRhV/Gw8omjCe2NaJFtOyFNIKQ88ZgcYL4m6PCtxiketJFO8o+ROTyP8ukxUaosh9ncXbDAz4A2RG4ZXXKhyFMpjnLeUX1zfYbpEKELFRquxwTbikdCBSB/FbxiZwhP92RPK4FF0Cm+AQjxZD5Q/aR2XTT5aIzfmaLGvtnk7bEGaOlMV86mYnjvWn205vqQiA3DW0rfL0YAXVzMjk2B8j3qLvd8eh2XpiobKeN86MmHYK2PH4HydkKRsOUsYzAR8W+dsNKwcm8gSo7S0c1pMxLk9GYvYX8xAvVakRFHMtwf8qdXozLZ8V6yOXc1c7QLWQz4XsMTRCiLuxA7VcgSjLxpjfA6i0xIGWAYaNuKJqVqej59J7M/qUXOipSar/yH7lvrTu56T70xvFlZARZwSMF/Ledzvq/SroNde2YyM/d/I5UkRhRJpy8HfkRUGp0EK+hCylqPgfYHZK85qIbhvpzIRvKPgYtOF5fNX+36K4fD571YPodVnPunqsMEHgZlO8nSMUUhKKbDYfwX6xUYPrggwhErhrTtU1iDOiJyikjYIMLtqpM3LJEIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 11:34:50PM -0400, Zi Yan wrote:
>Page cache folios from a file system that support large block size (LBS)
>can have minimal folio order greater than 0, thus a high order folio might
>not be able to be split down to order-0. Commit e220917fa507 ("mm: split a
>folio in minimum folio order chunks") bumps the target order of
>split_huge_page*() to the minimum allowed order when splitting a LBS folio.
>This causes confusion for some split_huge_page*() callers like memory
>failure handling code, since they expect after-split folios all have
>order-0 when split succeeds but in really get min_order_for_split() order
>folios.
>
>Fix it by failing a split if the folio cannot be split to the target order.
>Rename try_folio_split() to try_folio_split_to_order() to reflect the added
>new_order parameter. Remove its unused list parameter.
>
>Fixes: e220917fa507 ("mm: split a folio in minimum folio order chunks")
>[The test poisons LBS folios, which cannot be split to order-0 folios, and
>also tries to poison all memory. The non split LBS folios take more memory
>than the test anticipated, leading to OOM. The patch fixed the kernel
>warning and the test needs some change to avoid OOM.]
>Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
>Closes: https://lore.kernel.org/all/68d2c943.a70a0220.1b52b.02b3.GAE@google.com/
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
>Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>

Do we want to cc stable?

>---
> include/linux/huge_mm.h | 55 +++++++++++++++++------------------------
> mm/huge_memory.c        |  9 +------
> mm/truncate.c           |  6 +++--
> 3 files changed, 28 insertions(+), 42 deletions(-)
>
>diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>index c4a811958cda..3d9587f40c0b 100644
>--- a/include/linux/huge_mm.h
>+++ b/include/linux/huge_mm.h
>@@ -383,45 +383,30 @@ static inline int split_huge_page_to_list_to_order(struct page *page, struct lis
> }
> 
> /*
>- * try_folio_split - try to split a @folio at @page using non uniform split.
>+ * try_folio_split_to_order - try to split a @folio at @page to @new_order using
>+ * non uniform split.
>  * @folio: folio to be split
>- * @page: split to order-0 at the given page
>- * @list: store the after-split folios
>+ * @page: split to @order at the given page

split to @new_order?

>+ * @new_order: the target split order
>  *
>- * Try to split a @folio at @page using non uniform split to order-0, if
>- * non uniform split is not supported, fall back to uniform split.
>+ * Try to split a @folio at @page using non uniform split to @new_order, if
>+ * non uniform split is not supported, fall back to uniform split. After-split
>+ * folios are put back to LRU list. Use min_order_for_split() to get the lower
>+ * bound of @new_order.

We removed min_order_for_split() here right?

>  *
>  * Return: 0: split is successful, otherwise split failed.
>  */
>-static inline int try_folio_split(struct folio *folio, struct page *page,
>-		struct list_head *list)
>+static inline int try_folio_split_to_order(struct folio *folio,
>+		struct page *page, unsigned int new_order)
> {
>-	int ret = min_order_for_split(folio);
>-
>-	if (ret < 0)
>-		return ret;
>-
>-	if (!non_uniform_split_supported(folio, 0, false))
>-		return split_huge_page_to_list_to_order(&folio->page, list,
>-				ret);
>-	return folio_split(folio, ret, page, list);
>+	if (!non_uniform_split_supported(folio, new_order, /* warns= */ false))
>+		return split_huge_page_to_list_to_order(&folio->page, NULL,
>+				new_order);
>+	return folio_split(folio, new_order, page, NULL);
> }

-- 
Wei Yang
Help you, Help me

