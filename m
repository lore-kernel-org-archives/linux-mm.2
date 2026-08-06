Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 895D0C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:52:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BE046B00A0; Thu,  6 Aug 2026 15:52:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F246B00A3; Thu,  6 Aug 2026 15:52:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4849A6B00A4; Thu,  6 Aug 2026 15:52:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF7606B00A0
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:52:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20097A01F9
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:52:11 +0000 (UTC)
X-FDA: 85071890862.08.76CA2FD
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0EA1E14000B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:52:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="bSn+I1f/";
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786045929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8WUS5fNfGQjbWAXdAqP1J4eQkadhTyRU3K4yvUsCnhM=;
	b=2dNk7JKv1TnH+Y/opjqx0W1CzepxzSiZshKojdJrWpqJtvkYkq8nuwWDKbYVScU83T878A
	gzKgmycQ3PBz04WvAkVateAu1q9z6yFII+6nKT99iIeaTRbEM9Cn3CexbDiaQeg2qVRT9C
	3DmYU/3nGZZjVwLkSAg+X7b8I67hGMg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786045929;
	b=p4g/IPFTjPmHFu0dpIKZ9jvUKdHN+FThvHRbCKveRx7zcCf4eJ2uYiTlnM+8+kjioax3sC
	cJsrUTAQP3EuXL1d6V6yA8V7FHP4BglOFUx9HCALQcMHL+2Uz2PekjrJ13uDQQho0joF1j
	3ArXCQfUwR2RrIt7pJuM7LYu1JL4O6Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="bSn+I1f/";
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92ea24a2dbfso205181385a.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 12:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786045928; x=1786650728; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8WUS5fNfGQjbWAXdAqP1J4eQkadhTyRU3K4yvUsCnhM=;
        b=bSn+I1f/1tA6OPifEo/TPLWCVAGT4SflihFa3MMN2ypSgXZje1rS9AWl5xqgtbN3SX
         ijjTJul7iNV0vRJ13x4tKI/kmvNIPDAicG64kBPs619qT8Q8vkE2U4AkWvumgnumm259
         BhwmHyZCs0qRmSBM0z9Je6V/rc2T7q7TILwPHcvHAhd5iVWChSt6uujtVVGNP29jvkWT
         1wpBKP+luVYqLxoOzEY7yWZIZmnmFJonlwYiaX/dmPM323a7iswLKsZb9jY52iwrq7X1
         4HeOiRE5D9Pq01Z/Exl8VA8HASWGF+rl0Ogpv6fLq6QJmj/nrN3MjmCJpl8OMc5UYpys
         CKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786045928; x=1786650728;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8WUS5fNfGQjbWAXdAqP1J4eQkadhTyRU3K4yvUsCnhM=;
        b=R18eGXkZqh6whE3YIFdMiQz7cWy6jizuA9rkA8EZ+IrSf93x3tnsRsD4zYmctAcxqL
         R/j+EacGfDAySp38yiFeGpMLtuzRxmJo9gAoHmY2c+iQ+4xhm9YjaaL8k0n23gCutdTs
         ITatj7HGFWK7yNkFRFj/e5Bvtfk9e7gybhwtMJkIN9LTg4L/yaYmWsefIQ2Y9iDltpNa
         hxj8JacGQwQct4J6UuVfM+NPEXm9dZGLc+9R5EhkA/ialzzd59iVEdXgD3Yu8ynEY6A1
         fClJAZejvC8K35YSou2PUCN+IaUtnZhwf265t69eB+fgSU3QkVQcoRTe2IeF8pRLoqkt
         uioA==
X-Forwarded-Encrypted: i=1; AHgh+RrD3KM3/Bk6t2GUfgLWFEnX2xJE4E93oZ5Ngrxi8xuDNC4WL83OkBPnmzIOiohM1vkTVkZZuX76iw==@kvack.org
X-Gm-Message-State: AOJu0Yzf17m2G8HbN4lH2DjD1gNJdIGtHwm5MLFLyDjnL7re2yQ8IAFM
	f+BK0S4CgJZuGa7w8dVXQD80lM+pYurptfcH32L12ELoPCzGLRdGWTil+X8Fij8h2TA=
X-Gm-Gg: AR+sD10X897o63pwrgyntmRZy92HY8wEaueCnjbxucrvrKe2mL1sJGvJbif756eWsgt
	mh839o5Rfhw6WONDUYdjKfjQhQGOB107gABr18I+6ooW4Gx138vdIJSI36NxKo/5gdezgHiex9e
	7aRQqQCSJrlf7yPGGItKzXwHLWHYoDAgTxPNOj5GsZiPrE2M+RxBpntazJ2Vm8HfSIB63xZCEAL
	/D64LufnOvb8tqqzJv5FhOtHdn4zUtZL5FL1XkQ2769xqpBQ3qcl5ak3uAOe9M9xq6jllp345A7
	V1BWtRm7kret6cGqMlQcnCC4iD8x3HtF1squZ/y4/f+F1BCxcYX0rM8yuFgzL1cjf+6rVgOuK0s
	Q+nggJd4yEy2wYj9oYkXJjZB+RthjGaqqHpzFAbGU1joVkmcgf9G97Bm/we5DSuyjsGOrNhA0ww
	VgGPUI3b71yec1FTGZ4jmbmh+6DCtd3iL5iNE7PHyGZS7dlb1k+gXnuZoF9yqCKbmjyCwofcs=
X-Received: by 2002:a05:620a:198d:b0:92e:6b16:6a0a with SMTP id af79cd13be357-936491fe653mr1593017085a.40.1786045927815;
        Thu, 06 Aug 2026 12:52:07 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9364a59552esm489438885a.42.2026.08.06.12.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 12:52:07 -0700 (PDT)
Date: Thu, 6 Aug 2026 15:52:03 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, Ye Liu <liuye@kylinos.cn>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/show_mem: fix format string inconsistencies and type
 mismatches
Message-ID: <anTl45iGlcBd_4Uc@cmpxchg.org>
References: <20260805021556.1908807-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805021556.1908807-1-ye.liu@linux.dev>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 3wap8nif4mbnrajwxgxk5utxuwps8ikt
X-Rspamd-Queue-Id: 0EA1E14000B
X-HE-Tag: 1786045928-502598
X-HE-Meta: U2FsdGVkX19UihxOlcZp0cJ5E06m9+58L+eKL5qQKTAVkUeczhdfa/BOh3uUFtAJoYqPldj+y2RSnm3AGZFH2gONh/UKni2bsm4oK+s0J9sJb7chsHS55YA3bXov4ZIK+FOfvORHcnE5JHJCGKNBbLXdXkD31cTulJ6lji4qL6cX1lUsoxi+cCGbT08WYAriwDYwNyuP8z4AjQXXZPnfK69fhypc5zNcx/t+aqf8S1nsnhdmNQXX3+u6fwwJ6/kIaifIGQIFsnpnYLq+lxeqNGlqgldLSoHxzTx1bwdauoC82oQWXPoNZVIb+v6UwJv8hcwydRNMz0P9OGr1yfEfmT6du660y1/jSe7JfwCf6dVjnSFmvnCOBwxZNcJiXSDa66tKM63A1OGUvWevAkpRgndvAGcAY6ZBNgQo8JAG0xaEr6nJBeWPM+okXpTowXupX6uybeK/b2CJdshwVdzz2BO0wPJ2W96mMHL7NVaBnwYGSzBOy0+YJLO7p5hTG52QcQVfaGyIeKTUPpnXKks07vKNa5nt+kG0VaZGum+qW7tXTTAvgdPaPUy/bMlD2gqRrBmb0gjYTkfTjn9vw5xapTqHJLf3gVg419Ks2E5tWks/FX0Nq5Usm6hRwOEVbCW9h8dQsMPyPojm4k1Gk+j7bb4rZAnlo4YSTDJF+780Lwr8KH12Gy1eADrrdfOuDhRvBUzSzHmckjelrt1gSCvS7UydCVpUqtBWDn4WrIm8g9QP0iMV33i0DTpHzivdAzbYkCQUkyDQQjM3B8jpTQEM9wrNJUPxyIda+WTpeKxxYvwSjyZAzmtdNbsgbuSSCZD3jjd3T1wIedsfI30hBvdBl1QrdU4WWyFL9jyG6r6hM7EewskaEaH1+p39vt5kxSEi6DVIVcUxS8hv41Oo8Clar+81f+gZSjEwTuuY83vEJt08CZgx51JwRT+DMjSq8thEWVWpnx1FPEzSnVJfAUd
 0rzkXvGv
 S7pfp+U+hoqYpPAj9cUfF9be5YMl1buNiZF+cENRjXB58P98AFRxu3ABdXdmGqfYLn/xJZDedtayjv8q3b3W6W5MKqCn2tqp+1xKOXEs0Lv1k1VPbinNwWfv3K7LNQSKgvlft76EOdGga1v482tZuPDiZ3Atx+gmE+kgZWlSS5SUs4IL+GR0/xpJ0exKdLwLz3pEt7horHyj5MUjTZqRJXQrGxOFXtLHDouzNWejXJb/oJkTmaLyS6qKhxMbWufImXUjSBaMknQ9oMKNSVaTedAPEtsXjxv6MS1vz20+tlWm/LuET+OZUSbLkjcDSl9FIxeYSDJS9fGbohSRGzzrDgrvH/qDqf0Y5yh+/NoUrLCp4RuzD2QM2mowsiglcQZ/UU/0QFLfGxiugJYr1bj8/8ONzwqVaSI5/U/pKsuN63fGoLLU4kqRvK+mp/lr4VfrF8YSx57dTMecbT6uxK7OEGFir6pjs4jPT5uqC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 10:15:55AM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Fix five format string issues in show_free_areas() and __show_mem():
> 
> 1-2. reserved_highatomic and free_highatomic: %luKB -> %lukB
>    The uppercase "KB" is inconsistent with all other fields in the
>    same output block and with /proc/meminfo convention.
> 
> 3. local_pcp: %ukB -> %lukB with explicit (unsigned long) cast
>    per_cpu_pages.count is int, so K(count) yields int. Using %u
>    was a signed/unsigned mismatch. Cast to unsigned long and use
>    %lu for consistency with all other K() usages in the file.
> 
> 4. total pagecache pages: %ld -> %lu
>    global_node_page_state() returns unsigned long. Using %ld is a
>    signedness mismatch caught by gcc -Wformat-signedness.
> 
> 5. hwpoisoned pages: %lu -> %ld
>    atomic_long_read() returns long (signed). Using %lu is a
>    signedness mismatch caught by gcc -Wformat-signedness.
> 
> Verified with: make KCFLAGS="-Wformat -Wformat-signedness" mm/show_mem.o
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

