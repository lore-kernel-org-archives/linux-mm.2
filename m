Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 933D7C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 15:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83F416B017E; Wed, 29 Jul 2026 11:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F0396B0181; Wed, 29 Jul 2026 11:17:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706546B0184; Wed, 29 Jul 2026 11:17:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0FD6B017E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:17:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA4B5A1513
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:17:36 +0000 (UTC)
X-FDA: 85042168512.05.BAC02B3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id AD813A0006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:17:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Hrj/dKBS";
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785338255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3DuE2acrJKm1lx3lAybhbSRrGqjpBrUfPbaGHYn3cHA=;
	b=Cx5JXuuz6VduHWjjv6KX6hlkWYROjaw1yInmVBOxqyDywLzYw8YRWZqLBhEftlFTAWrlDA
	TPXTTigish8hOLTjzzwWiMr4tcWdbCY+jjXwXadvRwHObYMqIAv9jpyghY1Q2YdhAUDvnD
	JODdN56V/4BhGUwhvWubHKrzCBrE6QM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785338255;
	b=KeYH7V2Hb83KrRrP+UhB8Pu4mvrRGzS9iN0mUswbJdliDgLwISyB+sXOmASv28ZVSBU7bB
	rXGd38aQsrZgZ2RwYWcuuFKd0BMGbq7bcrt/Tj+TvRGFudAIgT68MD3PYuoyg2RfhcsEwz
	4j7Wi/qzuYvFXGp59tkv8S2JXaBj62Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Hrj/dKBS";
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3DuE2acrJKm1lx3lAybhbSRrGqjpBrUfPbaGHYn3cHA=; b=Hrj/dKBS24t9/BeX1YTwpnj0yG
	OmkWXsZg8EYbhPa/hxzzYeiqk0XF24jXbZatgnCW5R5OLlvDFFm6nYwUN0TOlY5h1gpArsu7AMEsd
	yL4EMfI6vJ26ql+drtmC0esoasRtYY3gNK4/LyxRXd1UsC5G7mtPzk0ZiMJS0OXuDNUuEL8t8ezy4
	N3iWKifETgUH8HVMa3tX13ncXvQnj7ZfZk/pDVm+FM0anHt4j+2t2qCoFvXz+Nw+e75ym0IDKkc6D
	kFuaVpjloVO2htqPYugmDRjlsWfSyY6s/OU3+wl7v8gsyU8lFTjtR9C48/qOkVyIX/Oy77WJ+ZWZZ
	FyygVEDg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp62C-00000008bM1-2SI0;
	Wed, 29 Jul 2026 15:17:28 +0000
Date: Wed, 29 Jul 2026 16:17:28 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v7 00/13] Use generic_file_read_iter() in hugetlbfs
Message-ID: <amoZiGwATl_1Kv0v@casper.infradead.org>
References: <20260728204409.3396238-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728204409.3396238-1-willy@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AD813A0006
X-Stat-Signature: k18geuwpea4z9apacynkboiwn1xziwzk
X-HE-Tag: 1785338254-6484
X-HE-Meta: U2FsdGVkX18PnI9gNH+mNuzd0dG8QJBy649ksJlB5fBcnNRHCo6KiUt9/QqLKi4x3tpC/WvKybun9DGhk4R8Pr4tEhPx4ymOWNyyf65chYe0K5A5D0Ih79JNWGN1y+rM4FSdwQwiWIuw4G4yI5kBJGPZrXnqgFiPSD/oND38S/iWYoxIUH83EQKOU1MscGMKbhjz1jpe5bYOQKHjNeCL+vbYJLbFNJnUSSUaQpdcOkhT5i11GCcLQHhHtu86754bWvmACEaHcwAhsjsbvPUvp7+3d7BAdQrZj7L4TnOY+if2PXhEywj7woaaTMcGjPly1LcFrKXgwmR35xKRaq1OP6VqAoHHcFoKLdwCQOn0ys5h626WGhrB50eydOauajclcWwJqr8FAeiJFVXd5BAEPJ+3+Jegii31JuLAN3GxhS+Bxa7KMFEX6iJb7R7FAfVSZfJtilgT+Uu8j5J7Kt21kGG7k6+5dwlbhFDscPHVclBRJyAMWXl4zj+qZbE4AISaB4im3rCp7NxP7wE3qB1SBSJ9GpF1BHBbT9YgSTJsdfzFwMuptg2ww7+n8HBpjyjIH4bGNcJKeAAKxgq4EvfNH4cYlvAl6xlkXjF/e47RcADiuY8XXRsFuBd8uzcCREgsG7lAMZEqhd+8ztLcCPSocEm6dkL2IANrtwWGKE7olRekp631H+jIwnWScnUwOeUNjZxsBlU24m/YuFRvAnfFz2wMSd7ke94HcYbW+Ha5FISk/Tn3Z0O7puvqKDx2LpS0/ZcAFQ+DuZZxqmb1PZq15c1KVcbDYCQJBiO/Wrv3RFohoptH/Hp+6heAjBKG/vK5QiQTDJOBppQRgjD9xfzTnMR+07HtR/7Agy7Y8ThJHebe2Ic84Ron8ll586VSEUuqhFTyVRZ3durPpLeZD2C9Kq3wQFVlI35rp64EAlH3o1zH5oWQHiqAn7e2OsH3VJ9KkXbaeF2nKqNeLLd0J01
 fNoGqPU6
 GvrF8GCUU55HUQXnHwunMXnYIENliWWg1E8ROEiRvgAM2n9y2FyRCO+smoy8zLo7WkLNzQFP5m5S270jDQbmixiTvQdCR/W2L+bofsyEI4rQOF2ydQQd6rTcC5HuWwDKF4wsopSayEPmrHS9GRyePrHbkNr1BaduUBcYT6+CZN82vZIDPg7UzYc1cuv73d95CohKk0uGjjKhOAmOTP6MFuCeJmnw/WcTA7hwWQAfcfqYAjBP7dG93gvKBU5JLZkFU9WADkoGWfmdLB/4xRcJqFoGr7QasNKjeD7pFTsK4T28kJrtgFi7dSAYHU+9waqB3zyty8HSGqSu4k8Jnv/VQhcyfIVhtC8gWmk3pPGaPc4oujS0BT8+Mv2Avb3mj8ZeGaAMM+aDBum1kj367+hyTzVqD3dX3uECHkXEfFqwpSfvGukGaFgYiKY6IttdllL+QJKFgSUDj128YIVqo2b+RjbOUVEYY58ztMLT4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 09:43:52PM +0100, Matthew Wilcox (Oracle) wrote:
> This set of patches are separated out from Jane's earlier series.
> https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/

Sashiko pointed out that I hadn't touched kpageflags, and it's right.
I'll add this standalone patch for v8:

commit c392dd16cf5f
Author: Matthew Wilcox (Oracle) <willy@infradead.org>
Date:   Wed Jul 29 11:12:01 2026 -0400

    kpageflags: Use is_page_hwpoison() to set KPF_HWPOISON
    
    Instead of knowing how hugetlb handles hwpoison, just ask
    is_page_hwpoison().  This gives us the flexibility to change how hwpoison
    is handled without updating this function in the future.
    
    Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 7d9387143435..28c9a7b724f3 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -233,12 +233,8 @@ u64 stable_page_flags(const struct page *page)
 	u |= kpf_copy_bit(k, KPF_UNEVICTABLE,	PG_unevictable);
 	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
 
-#ifdef CONFIG_MEMORY_FAILURE
-	if (u & (1 << KPF_HUGE))
-		u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
-	else
-		u |= kpf_copy_bit(ps.page_snapshot.flags.f, KPF_HWPOISON, PG_hwpoison);
-#endif
+	if (is_page_hwpoison(page))
+		u |= KPF_HWPOISON;
 
 	u |= kpf_copy_bit(k, KPF_RESERVED,	PG_reserved);
 	u |= kpf_copy_bit(k, KPF_OWNER_2,	PG_owner_2);

