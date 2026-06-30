Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF51CC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1506B00A1; Mon, 29 Jun 2026 21:54:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 888BC6B00AC; Mon, 29 Jun 2026 21:54:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ECB16B00AD; Mon, 29 Jun 2026 21:54:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B33B6B00A1
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:54:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B26281C1CDC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:54:10 +0000 (UTC)
X-FDA: 84934908660.12.8ECEF9F
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf19.hostedemail.com (Postfix) with ESMTP id 176241A0005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:54:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LSiiba7z;
	spf=pass (imf19.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782784449;
	b=4RO7e9I0ejKrRakWGXyLh/1DkeXPlzeC95kyUFIT/Fum8RkOy7oAAWeZCMBc1e/OUFy3vb
	vb4Kt+7y/RRDDJq1KxDSmdAXXRB+PlTcpQCVcqS3dEnmn5FGnpwWjnRT3XuLP6E4fX3eZJ
	U1hicwNgX62sUVZMvJP/qLtHZYJxpvk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782784449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMPk4xo0goYwl32b+O7Fi24CGRO5SYSFgHPQLi10p/I=;
	b=aELHBson6bohVlf+ukNfbbgSzz0sl1JtWaX25bTdWkkhpvDc4YmghV9XvW6GSA0EBun7Ua
	wzlLnh9HYLtdG49mvtu0fifBjrvzMW9fotRM2EdcHaV1K1Wr/kHQ9Um0zzE4ctYHjmIZ03
	wdf2qP7QdM1K7wOeisOSX6EpK+A9j8Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LSiiba7z;
	spf=pass (imf19.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782784447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hMPk4xo0goYwl32b+O7Fi24CGRO5SYSFgHPQLi10p/I=;
	b=LSiiba7zXygXulV5c0kYCS4AjrwmfPmf+H7JfVnMeAMhKLgS7OqMOd17+OGxTh+p7SGtYG
	sPhsPus0lUAEOz3RFlS/iZE4mhUSiX2kKvgvUVuAL+z7hPwC3XG5Sx/UM+t48EPTgiEHyr
	3tCK9KErifgzHmgPDtwsOI05IVAX1ZQ=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/7] mm/page_owner: add missing newline to count_threshold format string
Date: Tue, 30 Jun 2026 09:53:22 +0800
Message-ID: <20260630015331.147174-6-ye.liu@linux.dev>
In-Reply-To: <20260630015331.147174-1-ye.liu@linux.dev>
References: <20260630015331.147174-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: jsxpdgf6d9r8ee93b3aeekrp917ukr3t
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 176241A0005
X-HE-Tag: 1782784448-558395
X-HE-Meta: U2FsdGVkX18jSSlfeO/yjuaJ5PozkZP74K7+6M5ziJdPOf83zdH4iKhEidk/y4WQtLgHijsDGF/Lh7+m2XgFmVLVuOYyeUAl13xow6IelKIZz2SmkjFWbGExs3YZpy0ZxzcZjGUbT4CiFijgLO6v4omqA1IYLQvZNlI6aQXStBNV1MVhsZOLx0EcyjsjZvRF12PKe3FPPbKLEjKFR2/7muZ+gO1rGUy4XKFk3TXFAZ15yJRY1ARmpKGpoNdDQbbxqdpVPDAwixoNNnVL+dPXUvt8mVI3D7SP1qONGHsaEGRc93mjQdJtSl7SrQrbaAgQkUTqOp5TJDuokvPlrln9k9uHGxKbH7FK1uXFbMfH4T/8vMBO9WXdlqbA0sthNSYY+HFYe/HdmnVIGGdwFXoF+IuXoCaL2k7xvUOWk6twAGFj9sKf8XaEvzgMtmu8yvPnaL3yvqKxbP9Moxq3awIGMeCPkLSxBoqDiW40rFZeWVBdFEoBH3rpUhnhEwJx+jf44M1iXuzYvdoZ9WMYwFUlL2210VH6U31dfKLLztdKwYb+saDg4mSY0Z1/gUQlHrOMxHo63Y5/qxzdXeAR1PZIRc5/pw7gh02PSQyDbzQBYpJKQq/vMSEjRmYb2/u3Ymd1AxDF5/6LPJMztkaYKu9Ls4LeeNoe0Cgs3z0sygansSstUCGXtLbWojeB0qXCitJonQ6CH1toBwBnBNcw2tRJrRvgAp8KlgXOBqzBwwqV0yjxFvIL7cD87f+HxJdGqOUdzV8dpBod3Yt/BwhcOyBkMCNiLWMJj/yqLg+X/h/lmF6B2ROALflzc5SVihPAu9XL7aQDKM09tN5hbrtdOuZjZL+F8vB6G+cMIY7V+6yDZDXJLasjBYGzTBKMWsLHbBDq3r7xtuHXKjwnZMISgX+wb3ZHUVcOA1PhL3O9CIvWR9BtoiXndvjPJi5P9VSly+2f4vDVhqvviyJAVTsbbgu
 k1u9YPpu
 xyA9oIxXdAi5uzM4qcBw2Gl72H35Q7polHNITS1TkRebMY9g0OZktZNACAgbEUe5dEYpCY3umLeOoruWQkuH1bI1OpqZo+QUpLNJzwKvWvfvP0ouubJ14uRI/ZTMs5dU769DIzQBwiyel36AWShMlvduB7CQQdimd1XA7dA5HPRp3qEESyTR9wdXX7TfCOodoQ27Yf9isq3Q/fgVAxU5cHmz8HQUl1UOZ7gxaSRX/GOHkNiXkIFUNMfLm52h8qPRdHcNlvVdinMJGKqNLPAUcdCdhe1jIogm27/GjtAE713pKaCM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The DEFINE_SIMPLE_ATTRIBUTE format string for page_owner_threshold_fops
is missing a trailing \n.  simple_attr_read() uses scnprintf() with the
format string, which does not append a newline, so reading
/sys/kernel/debug/page_owner_stacks/count_threshold produces output
without a terminating newline.  Add the missing \n to match the
standard debugfs attribute convention.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_owner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index fe2bf2274d8a..7520718f63f1 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -974,7 +974,7 @@ static int page_owner_threshold_set(void *data, u64 val)
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
-			&page_owner_threshold_set, "%llu");
+			&page_owner_threshold_set, "%llu\n");
 
 
 static int __init pageowner_init(void)
-- 
2.43.0


