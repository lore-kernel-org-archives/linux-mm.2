Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72747CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 07:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 933F58E00C5; Thu, 18 Sep 2025 03:17:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B468E0093; Thu, 18 Sep 2025 03:17:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848B18E00C5; Thu, 18 Sep 2025 03:17:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 73C788E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:17:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0CD398729C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:17:59 +0000 (UTC)
X-FDA: 83901516678.07.D73A7C6
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 09326A0004
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:17:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m3iQCM2T;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758179877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=njN97PvBPLC4bDZRs8q/T0cTu4eF2v+Wk3jFZfVWHnw=;
	b=lrKd7MtbxwkQo7c+CjXf6WMk1LcmslcCIEGTirjFR9ivA0zLMnCKNYauVlG04IBeWABYxo
	Pnw7qO66CRFq/HtoHREALXfdvr/d8ZAvaTMVBjUQ7yQg2oVaF30dQf9EvIiB19aXBQvYK6
	rLbbk0gyR24HYoL1GZ+FYfSegmN+Fow=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758179877; a=rsa-sha256;
	cv=none;
	b=uE2aqLp1gXhubanU6CQtJerPOpDgN0o6s6wwWSXvFh9VsDedM3s8DbKd11MebzdGvvSfbO
	Dci0+XI+N9uqXsATniqJRaZdihsahOicaTbuqgVXzGgB+n/3gOfTposaEbzWNKf0ytW4RU
	6DvIoPdqccoDhdVLx8dzwkQ5UBLgqVA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m3iQCM2T;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758179874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=njN97PvBPLC4bDZRs8q/T0cTu4eF2v+Wk3jFZfVWHnw=;
	b=m3iQCM2TOJA+kmwLLav6k0tpHUtNL0IBO87TXdQfOVw4AG2EYcVb6OGbJ0WG7CRdyF/bFr
	a51psNoJIanaLFs9imtLLnJBQyM03SrVwmYeQ+MxEPlJkoyH4IjcuBBbQqECJAbWNNzNYr
	MvZH82gNkKZ0m2BkQ1C43r9Tpr8o7ec=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: Ye Liu <liuye@kylinos.cn>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/vmstat: add header line to /proc/buddyinfo output
Date: Thu, 18 Sep 2025 15:17:40 +0800
Message-ID: <20250918071741.526280-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 09326A0004
X-Stat-Signature: 7cisx3jnayhz4e5qrumw5pbhti34ok5b
X-Rspam-User: 
X-HE-Tag: 1758179876-974697
X-HE-Meta: U2FsdGVkX1+Juuq0gGYj1nT4kv6YNbcm5Dv1k2x02BUYcf2Hk4ixL61TQ0LA7MQxnM4zxMbIk12alO8W5VuFTWX55lUOxiLk4x47gTXMoGCiil+/CtT63sVUgT9R41AqiC3s819dEcy76iTRR12ONRzmWSeYl/u6LwpUNDrAuGlBh/FgReT4d0e5Glfw6TDP41LGgRmUM0esLorgBaoXs30bgw0JnAwVXI51iCazR4RBmgQs/gpLPO+4p4ISppkmJuJO+AtXA36NOWXWiTQiTRYvBNLFnecmiVCC049Ax+CYBk5ncZWIn6NjlnluBIDIVq1Sfw8UZBcNFBvoKH+YTV05IsSX1jCRdFrQQT9twF/fP8+bDA3ngPskFwTw5XwXk+K9DlRQ9OFFbG+kRYeAXgTrH1lERi//LWrI0noTIlVlp8fk1aj2b9sjbJx78Rvgc1hF8NrLntLzOgRnFnYFJ5kY3GvtIT1OZH9D0O9c//lL1oGVjKYODXPW4dErRvAZzEw4Klrv6GBLmTm98rZzfAkRK0mqHgjQi7W3p9enrCZTlRVUvPx/Hwyp/GJm3xN6nAWC/GIjZwQlf4/0rT884aB0mFZtm/NG9rNtkEkejGMtUuZyejOsuveWIA6PQe9Zkz8jZDIDclAxOW7QIzN51LduyHmyh+pOfXDYfq7hqR0TYEqeWVwujVPxq7wL84fPXN3zrg8WWNGXSd5wJ5+WvCAGgn2EYw4dLbwv29gYkylu4Dlg8zi9SJgvwkZvI6CPKB3+fGEvpo7NIOKLxVBmZrY2dGGpWgoFOXuKZD8AlcT+OwMKoxGy1GBbNBbgx6WUt+ghZIdnr9HmpReSYRGvxDNqqgFwPCYraL+kkDX/9X/U6+3UkzUkKrUt4I6tOqBIeQB7CCwBvIBp/S9YOY2wCfjATd2eBw/JmFuDpt2sEbNSZ1X1hCdmRLPyMT00Se98LAK9TTKmjbe9bDuMfx6
 O05I9gEg
 pmn80q/PF0MtpTf7uxfV3q7NO8ZWbPpYML9ZuJdd4XHeWSMl4jtXSbG1EQfCe19+zvE8VN6Kn50BC1dxp3hUHKQ6s43HzTwSP3rVRdhf0TE+W/AXPo0z0L5OqOFZuRcMXyrNihk48RDMeCV32XvnabgXQyDBsZ6yH3ZLh6d0pWP7Y9sSz251Z6DWZHFB4nwUQswSL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Add a header line to /proc/buddyinfo that shows the order numbers
for better readability and clarity.

Before:
Node 0, zone      DMA      0      0      0      0      0      0      0 ...
Node 0, zone    DMA32      5      8      6      6      7      5      8 ...
Node 0, zone   Normal   1113    351    138     65     38     31     25 ...

After:
Free pages per order       0      1      2      3      4      5      6 ...
Node 0, zone      DMA      0      0      0      0      0      0      0 ...
Node 0, zone    DMA32      5      8      6      6      7      5      8 ...
Node 0, zone   Normal   1113    351    138     65     38     31     25 ...

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/vmstat.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index bb09c032eecf..e9606457ab91 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1574,7 +1574,14 @@ static void frag_show_print(struct seq_file *m, pg_data_t *pgdat,
  */
 static int frag_show(struct seq_file *m, void *arg)
 {
+	int order;
 	pg_data_t *pgdat = (pg_data_t *)arg;
+	/* Print header */
+	seq_printf(m, "%-21s ", "Free pages per order");
+	for (order = 0; order < NR_PAGE_ORDERS; ++order)
+		seq_printf(m, "%6d ", order);
+	seq_putc(m, '\n');
+
 	walk_zones_in_node(m, pgdat, true, false, frag_show_print);
 	return 0;
 }
-- 
2.43.0


