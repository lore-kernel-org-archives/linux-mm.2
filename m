Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AD67CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0C708E0012; Thu,  6 Nov 2025 09:52:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BBF08E0002; Thu,  6 Nov 2025 09:52:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 884148E0012; Thu,  6 Nov 2025 09:52:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7667B8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:52:18 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 27A80129745
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:52:18 +0000 (UTC)
X-FDA: 84080472756.25.6A0EF9A
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1DE2010000B
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:52:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mq1dv9NM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762440736; a=rsa-sha256;
	cv=none;
	b=I+u35+9nnZSogaRNAfeVfIiJbQ+gX0oNKVyCrxXraIhDIbSvZZVzfMxTL0liBMXFKzsKnM
	wIOEIEBm+xTDNus2XwgRjxTZFkWkkVCVuDM/vclFGTExdQqWLFUug6LYRLNxethGGXgnMJ
	aSklYF6pWWjfW4ZTHFKdwL53sucZIg8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mq1dv9NM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762440736;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wDdygpEaHGMoa57zuV/aMoSnBxXhLlVU6zzsPP0T20o=;
	b=ZqZDl3fW1STU4zIXyX//hXPRnutyF/+YjALP7If5h4Z8crAYQ9w18LWvaqjf4aNglfHhr0
	dWfkMfGgHccRB9fzn2fcX1/HehuRhx8wEHs5KCUI0BHSnDvG8sylsz0aVyMridBXAGni4M
	sgR4abq1iYMMsfZCXWwT4a3bTdnE+Qs=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-640a503fbe8so1741231a12.1
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 06:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762440734; x=1763045534; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wDdygpEaHGMoa57zuV/aMoSnBxXhLlVU6zzsPP0T20o=;
        b=Mq1dv9NMZU7mg2WfYNpznAiU8yzfZ0enaCWT4iJb84+xvCd/0HFJggHmAfoN8f+bGF
         ugtvfnGaT16dwu4ZyuU8HDho5dhoj0NNqpErmjlQTKLxAU5WcWZdHJlImdx0Errn4QQk
         wmd1vNh/PPh0nFmZOQvoCbKzG0/K/rr4aKirrVLQry/ByCQCONIIgoO36y0jokSog7Of
         j/H6+Dbf9msJUGzBJK4YmEVDtbwb3m0jpmB077bb+3xot/sY/B78+OWPzijP3OdseeNK
         5VQzfwuN/GPCQuIee3+x02I8Vw99+OGhwq1enOUrchwsMU1HLOQ34KE190r4Rxic4YBR
         Nykw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762440734; x=1763045534;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wDdygpEaHGMoa57zuV/aMoSnBxXhLlVU6zzsPP0T20o=;
        b=WW10z0AugwBXJqwOPPlsecAKsqD3YaNJNg7m8AnGHWE533OpNPVfRlg+34Du31F3/l
         L6JrpdEL0uCibu8vfdHm2Z/lmQUTRci/5kA9CFzwKO5guRxjJk7mCmW98nUrkxAHOKYU
         L7esW1LNdgYlzE6U28An5SatR+1aHDX/x0F2u20SDjGvgK0nsYgToXUPWyM1hsGybXds
         r9fWykqrZ5Q/liIjbACx+hBgE8/0nUfEEph6HplIv593I+NzvfygnN+x2B+rck1Q2WDP
         Q74wSBY8DzelaLN8MWkNOH9iUlwA9Wy030u2POtJ6B/xnp5/iGd2qc0/TioQXZElF5V7
         rNaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyim/G/7ZXeLoWPotOxacl4Z72zN9qVqSiUD0gKrV8RLvQ8XW7rjSF+1sTML8uWGLGi207sBZxUQ==@kvack.org
X-Gm-Message-State: AOJu0YwI1WYazmRVgsrOn46kavewsmY3YUPC3aEGdXtvyXr7lLv6tu8B
	GEbV+ikmriK8POfnX8aYqNkrk3Hzvdcq6PKLH0OtK114GfvdVk+mbC12
X-Gm-Gg: ASbGncsefxeOjSifLKU8w7Blq85HV/4aU4A7zcMV6vl2qN0X52as51cIZRawnTNZvgf
	aTxyocr65pXyaMZ+82I4JEhlD78IsCtYPr3ILQLO5dZjI0mgL2CJ/IZ88fTELh7vVHZK6+zoHly
	Rai6AzE3LEm+Lnuod0EyDfHCM5sVJUAiSITBPqfVjiycQKd8yOuDix2YfDQyjZmrYXvAuHMRY7N
	mkXxwqA7Z2K/GzVKy3hk2tvWPqMOu8MJp/fm1L4L+OZ0z/mIVIzVmucxu/W9e1pBPlYRaGkqU1O
	OqhBAKYZ4m6OJU35VIYYP8PBfx2mhUR+09ss3crtiRMmoBN4SsPbuGM1cwQAOLNqpqc/NZuQg1O
	nQnBg+MaLzEYvYNPTsE0/Lx6IhOdobp4dY0VrvmgZn8bLDfTdtcI5qGsVigpo//OsekXcsypDgs
	C+y+82CDhNIw==
X-Google-Smtp-Source: AGHT+IGgp/wgiZUKTPVZE3gj8111Pcf5itf4K+msOi2yemcqfhoEzuV1DpvFFwMSKzQh7/JzEeOngQ==
X-Received: by 2002:a05:6402:34c6:b0:640:bd90:350d with SMTP id 4fb4d7f45d1cf-641058899e1mr6623598a12.1.1762440734161;
        Thu, 06 Nov 2025 06:52:14 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6411f8578d4sm1999441a12.18.2025.11.06.06.52.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Nov 2025 06:52:13 -0800 (PST)
Date: Thu, 6 Nov 2025 14:52:13 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, harry.yoo@oracle.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v5 3/4] mm: thp: use folio_batch to handle THP splitting
 in deferred_split_scan()
Message-ID: <20251106145213.jblfgslgjzfr3z7h@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <cover.1760509767.git.zhengqi.arch@bytedance.com>
 <4f5d7a321c72dfe65e0e19a3f89180d5988eae2e.1760509767.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f5d7a321c72dfe65e0e19a3f89180d5988eae2e.1760509767.git.zhengqi.arch@bytedance.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1DE2010000B
X-Stat-Signature: ykbfh1oz8433d9wqw9wxzcu1z64ymf5t
X-Rspam-User: 
X-HE-Tag: 1762440735-700840
X-HE-Meta: U2FsdGVkX1//RUKiaIJahF95/h2AV9DBazR1IUbJU85Vr/ZwDNtw1sefjSbF9KSfptNyA7veYVmgvkwI0VXF3AyHEzeINFYcY4NcSD2k+NRWGhHV0cNeGW1PGFpc5e1YLAiHaAPfrjsVYcJ8hax6qcLH9aqP7iGlrdYMKA7F9SDuQPPUnyw1Nmzse1z9rwq8049Z6Us0reAb8/hA/tcpO1fqBHgXxg5NfxoxsrnEQX3MUFV8N8IshQ5g22VYV6rGyHYXrIKOZ1i06x8ifJjn/Bx1/eTJX9U2YUmQjWtLq9DbjV3Q2EL5H2A1ZnL5WaJeGFgljlcpdD/Cz93InfL3NkQF71ImeyvqrGRaITNcA0IejCxsCvT63wAXsWtRlqnTNvpAB1WWDLVFbflKuXohjfNX4ZCIBGeal2jg86XkkOywnifGe/CxzbsQnyv9+WMKHxAjS4uPn11UK57UEJnzq8KVoFliyFesD0DjMXai6kSqMvEKV9159A3l9j+HPM3pn61fPTJGgi1+Zb7Wcdi2IWTSXIV3KqNqwLj19HD2CoGtstGHlcpXmls7TiOLsOPuT2B1+6qUaRrbO9lS2TY1ZjhG9ADhVMueIAZs4T/7Ffg8juWsgNQaz7eOAKiGrFzxNuDrQskNZV2rRqcc1n4+PxfjwcZ4wmyi8g4weSNSuXkuDJpMmhlagyXSjCmSKO7EKgcgmMTsxDDTV3amiP+0hlhljASDaZ+v6CI5biF396R6LefTiY06lHuLgzsrRk7Ln03uHrb6OM4W7PDvBvLoN4HgvIcZbjGJMUen0Zeh97Y25WQaWnc/qZR8dRxQKUjX8jO2vX6tO1UOSV9rumwhXXwJcI1KHgvDy9DuBuSkPCKxxQ75Bfp1IHeHKl6weO9wo+IvciGN2OO5v2ynE8CwqNBqYvyMlimkPT9I7mc+SjIpwgxECs33bGLGup5wyc4sOBQ6bwd+bNZpYbPevd9
 9FVdxlWk
 PKEquaywga4meIgMvLSkjTa3zwk8WdPrjmkxFzKM9y8LigYNdY8w18e2VEyFQY2oP5ubXgUX2l4Ao8RCe5kqXdjI//c2nJR++Q0NfroseFnkvjy3WIfoCo6bnysOAZ3xhPHoencRYNQMfb4qSjlwqs+cF/NCYqeBSI/7FySdJs+1DH8eSui/NcF0Fgt9vcFHsPJ0wkOfsIIpSGeC1EiFBBfn8xukGJN+S3N75tvzzgYpDwjjYCb0EmsWVSWm5mWIDEZpPpgA724dXWI+F6E8evEzeWoVrcFnzntWwutN4raOFfp6Cjx6dgf7kenx2ujaLUri1kNNHOHnufrM0701lWG+2FSZPaJNBjFj5oadotznpi5Y6QlSwZQaqAe+/mwBXzude28ekBwWV6CkRuGoN5r92joFrjQGsjPn1OcqckaQusiO6x02fiBHEwYvbYSrMZ3C/jLrl3lIeCKO0sd6Ce8duafh5y7jBscNigprXmkH9XajEoEq4RAzI8pYhbVwVrwhezOY7p7onZGXW+gjU1stMwOAtjUx3po70fHkz3GHfRVyM08gul8LZodbmr4EJCgVYmeinrgB+riPvuCAXW6twJO/TDc+7NA7S7Ql/LFknma/NvcZKtqmfzsdeQ6Ypo4ioV/YU2f3u2UHfU7cfgIzQz6XNWV1y23ZMWpracIE4DZy11l2Hbc6NwWD7p93Y5DjTh1aTNZTvfQIYv2WTwKcV7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 02:35:32PM +0800, Qi Zheng wrote:
>From: Muchun Song <songmuchun@bytedance.com>
>
>The maintenance of the folio->_deferred_list is intricate because it's
>reused in a local list.
>
>Here are some peculiarities:
>
>   1) When a folio is removed from its split queue and added to a local
>      on-stack list in deferred_split_scan(), the ->split_queue_len isn't
>      updated, leading to an inconsistency between it and the actual
>      number of folios in the split queue.
>
>   2) When the folio is split via split_folio() later, it's removed from
>      the local list while holding the split queue lock. At this time,
>      the lock is not needed as it is not protecting anything.
>
>   3) To handle the race condition with a third-party freeing or migrating
>      the preceding folio, we must ensure there's always one safe (with
>      raised refcount) folio before by delaying its folio_put(). More
>      details can be found in commit e66f3185fa04 ("mm/thp: fix deferred
>      split queue not partially_mapped"). It's rather tricky.
>
>We can use the folio_batch infrastructure to handle this clearly. In this
>case, ->split_queue_len will be consistent with the real number of folios
>in the split queue. If list_empty(&folio->_deferred_list) returns false,
>it's clear the folio must be in its split queue (not in a local list
>anymore).
>
>In the future, we will reparent LRU folios during memcg offline to
>eliminate dying memory cgroups, which requires reparenting the split queue
>to its parent first. So this patch prepares for using
>folio_split_queue_lock_irqsave() as the memcg may change then.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Acked-by: David Hildenbrand <david@redhat.com>
>Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>---
> mm/huge_memory.c | 87 +++++++++++++++++++++++-------------------------
> 1 file changed, 41 insertions(+), 46 deletions(-)
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index a68f26547cd99..e850bc10da3e2 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -3782,21 +3782,22 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> 		struct lruvec *lruvec;
> 		int expected_refs;
> 
>-		if (folio_order(folio) > 1 &&
>-		    !list_empty(&folio->_deferred_list)) {
>-			ds_queue->split_queue_len--;
>+		if (folio_order(folio) > 1) {
>+			if (!list_empty(&folio->_deferred_list)) {
>+				ds_queue->split_queue_len--;
>+				/*
>+				 * Reinitialize page_deferred_list after removing the
>+				 * page from the split_queue, otherwise a subsequent
>+				 * split will see list corruption when checking the
>+				 * page_deferred_list.
>+				 */
>+				list_del_init(&folio->_deferred_list);
>+			}
> 			if (folio_test_partially_mapped(folio)) {
> 				folio_clear_partially_mapped(folio);
> 				mod_mthp_stat(folio_order(folio),
> 					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> 			}
>-			/*
>-			 * Reinitialize page_deferred_list after removing the
>-			 * page from the split_queue, otherwise a subsequent
>-			 * split will see list corruption when checking the
>-			 * page_deferred_list.
>-			 */
>-			list_del_init(&folio->_deferred_list);

@Andrew

Current mm-new looks not merge the code correctly?

The above removed code is still there.

@Qi

After rescan this, I am confused about this code change.

The difference here is originally it would check/clear partially_mapped if
folio is on a list. But now we would do this even folio is not on a list.

If my understanding is correct, after this change, !list_empty() means folio
is on its ds_queue. And there are total three places to remove it from
ds_queue.

  1) __folio_unqueue_deferred_split()
  2) deferred_split_scan()
  3) __folio_split()

In 1) and 2) we all clear partially_mapped bit before removing folio from
ds_queue, this means if the folio is not on ds_queue in __folio_split(), it is
not necessary to check/clear partially_mapped bit.

Maybe I missed something, would you mind correct me on this?

-- 
Wei Yang
Help you, Help me

