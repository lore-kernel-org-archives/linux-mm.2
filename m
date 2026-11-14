Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AF48606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 21:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ao3LF58o
Received: by kanga.kvack.org (Postfix)
	id 6F3286B00EF; Sat, 14 Nov 2026 16:44:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A47C6B05B0; Sat, 14 Nov 2026 16:44:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BC046B05B1; Sat, 14 Nov 2026 16:44:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 395876B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:44:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 89C2A80210
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 21:44:55 +0000 (UTC)
X-FDA: 85435054950.14.10CE91E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id E5235A0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 21:44:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ao3LF58o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794692694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v6NxdjJjQL36OTTvzD1oqqfX5SLRSErId6XzHf4YkWM=;
	b=JHAGpVk8ITbx2NKNsKDabX4MsR7E277V9/sb+vAdlFyoD3jlNJ7/ZoVldKtrDFEno5SRyF
	9p+sgeasKoca7mb2dkM2ruxjWm24JBEIywjyC84TCr7zJZCnAgi0f/sBc7kJwJNxP1rm/Z
	pIo/kG1saxVTSZvbyy3c+3geW7qkHZo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ao3LF58o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794692694;
	b=MvzAOxy+RWcz/i1HKkJw7lA5ADzbNauuFfsbYXSJSZxs7Tob4F9K1f7PrffYlKnVdS+N8G
	QAFpBAvis9/2Y53ZQNHZFUPujNJ1IDwDY/UunyalJh82vYq8jDj/tUypk1gP2bcI0hr2pS
	juQS6CrUBBLflgSOZUzJcq1kqu7ZDIM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F34CA611B8;
	Sat, 14 Nov 2026 21:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55481F000C5;
	Sat, 14 Nov 2026 21:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794692692;
	bh=v6NxdjJjQL36OTTvzD1oqqfX5SLRSErId6XzHf4YkWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ao3LF58ovnn0pkc75f0Q6ybVOmqamTvXcQzw8Qcj8CFm44wa9tRndr0rh0dy+b2oC
	 6xa4vLb4m0QsYMg2Eqb0LcpBxhaKVx7JTDqy3bEFLpSEfFWpdYVCC0OMjQReuddaYW
	 3Kze0S8ecpOOYRak2TQzZQZDW9P3vXDL1xg2vjaddm63xYpj59t5xk2X2GDagnfD09
	 8W0EmXw8HG79Zo6+p1DTAymwUU9QFB1Aw9OJKgxW/tw/1FOYveWeWBQ5KPSR8uXxLH
	 ww0JH4CU3yPPHFirT1IIQqv29nbsb1Wi4CX0e8oAoycxC2FzP6M9iA0rxLoQnzKPIP
	 b2ThBGpq0n0fw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: sashiko-bot@kernel.org
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-mm@kvack.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	sashiko-reviews@lists.linux.dev,
	shakeel.butt@linux.dev,
	sidchintamaneni@gmail.com,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn
Subject: Re: [PATCH v9 11/16] mm/mglru: Run aging when one type is drained
Date: Sun, 15 Nov 2026 05:44:38 +0800
Message-Id: <20261114214438.70148-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <sashiko-outbox-215014@kernel.org>
References: <sashiko-outbox-215014@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E5235A0005
X-Stat-Signature: 3ne6pogx7mn9mm5fx47iwep4pt9jhn8w
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794692693-775626
X-HE-Meta: U2FsdGVkX19JE7F+VUGNZQxSjQxEteML09cMpJIvblj/WEK0WfP/hJp8Knrmh83aceKy2/5tsrM+4TIVZ1d8j0Ue/Nb1f1Ius/qmB8V+xNKt0qCSSaER1khjSbooy8CpzuMciRuXaco5EOjFOSEkUOX7dhyizdtoDcjd3WZnz+DflEq+5/IP15Y+Lc8yC+VmkD0luUiyuLztc/P+bhjc0LMw7Sx8MPDbZ3vEYN3tk2qULvdc7ZvG6G3ifDZ1KqgipiQ900WyOnTn4u2J9nBEc85JNGcRSTVDIAyY9rAYDYz1fbTGiBurxDq5yFkgK1kWFbeTDZMl46et7tlOYbG8qocoE1zEDfgyp/DixOT4Wc7suCztQpJ6W1UbLqRcDPJo/xsFqbe1CcCmgxamNSTZXoNtgt6FxqXz/0xQ3lXpuYTErYkCUmQ64G3PBIE6tWMNUuE2vs8oKq6oDxLii/GJk1D/OMAGm331QYAqP6phAEGqXfQJcbzn2ncaOL5KmJcrmAsvfX8CtJH1/MMLckBqR3y4u55oJYnCBx2kaHg2Rp401TAPDsovM4xY+Zy84ZUcCLbSMgC2+oinphMHlALH5XD4rl68NArdFKXS1tJT1yK45IPlEmrzxx33GXEipBidxSQTyIFDg1KPEQ2x/qfI3Je75vfOJzE2ixxoPrbJOIKeN5N2uGH6kQVfTXzv+TWTWgA89JaN+zqnORaE0xy/NcmnE5aTRqwr3EHHW0y2OpcLJLu8GvLitet32sCjBUgt4rrd4DfA9zKU725VqVp9fh6UATz3XRvxfmx12rAdTSwCnpii4o2INZ54n6NcQPfDax+M5VyoVVOPiFJmNq0242tPy2CVGvZHLf/6U4EJx6GFCkenpMvHJnOY12fGOrNm1RKrI/JXfhfhPjYNWo8HDnGt2lMiwr/py9sSwVUcZq7ESwejrrL7njtGMKbjqU2KYlJ9OW/T+RjNSL78xtc
 kDGKBfjT
 LUupOGUkfVsaKcMIfuBe2OrmHOP64rMDCZWbJ3ZqqEOBPiQUQnMs+0x1DGfB4ynkcJfAVSkCvsNfk5O/iAv360RoXi72bWJVJTzC9wCF0F4rX4ehzBP7NpzSk3sjjjlRIjZw4O+y4i6ia+mZWWQqkTvfO1gOp1E2IZ+Wc3umHcR7OwuBdd55NpyP8ZIxcJjX7LExo38MCORwP2FA4XB8VvkJbyDe60F0u+JLmW2N9otnf52LjjQB2QDzsYf8l4m54UhSV45+oschb3KeNwZRNUVV9q2YXIpV77bjUAwcxZOcCxaXWDIWSw9AkmcSpEKtkjjsz7OXak/NM2aKgh36dwKJHOnw8SJ8O0r6MhwXQSnXDD0Et22Y76xw6BM++uQEunZsL56eE69ALsm/V3jSXVsSIECtb8P+/iZ2y4Zm3T/tsiXI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 4:50 AM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Medium] mm/mglru: scan_folios() scans seq below min_seq at
>   DEF_PRIORITY

I guess reparenting could be a corner case where it's difficult to
properly preserve the cold/hot ordering.

As mentioned in my earlier reply, I discussed this with Kairui,
and we still prefer having `lruvec_populated_min_seq()` return
`max_seq` instead of `min_seq`:

https://lore.kernel.org/linux-mm/CAGsJ_4xbDy8Qy=5yqmn+59jfxPm3WOgAH7zX9gwhJyO-6fiT6A@mail.gmail.com/

But for sure I can skip the scanning in scan_folios()
if (seq < lrugen->min_seq[type]).


> - [Low] mm/mglru: missed eviction retry in try_to_shrink_lruvec() on
>   concurrent aging
> --

[...]

> When a concurrent reclaimer advances max_seq after scan_folios() finds no
> folios and before new_seq is read, do_drained_age is skipped because
> max_seq != new_seq and should_run_aging() is evaluated against the already
> incremented new_seq.  Comparing lrugen.max_seq against new_seq then sees no
> change and breaks out of try_to_shrink_lruvec() without retrying eviction
> on the newly aged generation.

I actually considered this before sending the patch. I think either
approach is fine, and comparing against `max_seq` instead of `new_seq`
would also be reasonable.

Comparing against `new_seq` still gives us a chance to retry, since
we call `try_to_inc_max_seq()` here, which may advance
`lruvec->lrugen.max_seq` beyond `new_seq`. By the time we reach this
check, `new_seq != READ_ONCE(lruvec->lrugen.max_seq)` may already
be true.

Overall, I think the following fix should address both comments:

From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Date: Sun, 15 Nov 2026 10:24:32 +1300
Subject: [PATCH] Fix-mm-mglru-Run-aging-when-one-type-is-drained.patch

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a6c6c7c1c5e1..a5b8244d4768 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4788,6 +4788,9 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		seq = lrugen->max_seq;
 
 	seq = lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq);
+	if (seq < lrugen->min_seq[type])
+		return 0;
+
 	*scanned_seq = seq;
 	gen = lru_gen_from_seq(seq);
 	max_gen = lru_gen_from_seq(max_seq);
@@ -5278,7 +5281,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 
 		if (!scanned) {
 			/* Retry once if aging advanced max_seq */
-			if (retried || new_seq == READ_ONCE(lruvec->lrugen.max_seq))
+			if (retried || max_seq == READ_ONCE(lruvec->lrugen.max_seq))
 				break;
 			retried = true;
 		}
-- 
2.34.1

>
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261114200803.23129-1-baohua@kernel.org?part=11

