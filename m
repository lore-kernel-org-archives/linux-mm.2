Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F25B3C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECEA16B008C; Mon, 24 Aug 2026 10:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5B76B0095; Mon, 24 Aug 2026 10:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBC206B0099; Mon, 24 Aug 2026 10:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B396B6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:37:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F77D1C0669
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:37:05 +0000 (UTC)
X-FDA: 85136415210.20.4099C3D
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7ECD31C0013
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:37:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aTn1wFch;
	spf=pass (imf21.hostedemail.com: domain of hughd@google.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787582223;
	b=fMoIYlcN1pM++N3c+vTmBcKnQCk6iRDv4IevSJU7BWmPsw1xMgiZq+KN+ab2DtPNnAuXOc
	FOovhP+Aydi7kRgnABIihA7MZhqqYFeEbA2s6iyOzGuLHRcke5SlajPfuuYwzGtOr9gEKy
	JA7/UVAnLackZZsn+whG8bsMtd1Vn4c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aTn1wFch;
	spf=pass (imf21.hostedemail.com: domain of hughd@google.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787582223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFFCpD+eyjMYiOlaAWIMnRn59i/x4sm2LgO1kNi90A0=;
	b=SXSCu9kW7UVKVAR0/2qXwUfcH0pCANorsgBPMGcw4tglbkwYnGnh7VxOgDgOHQhtkihy+e
	+D9JBqAAvND2lKPlRk3Tc+J+REbXIsKYa0TbbX9HSX5+uHLXhYzO246dLdLmZrW9NjN1QQ
	wkOMrnLioLCSk7N2n0JwE66rRs+ynb0=
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-66d116f0de8so382881d50.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787582223; x=1788187023; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dFFCpD+eyjMYiOlaAWIMnRn59i/x4sm2LgO1kNi90A0=;
        b=aTn1wFchncYyUjhU+yYM1GLJ4CAUY7GUmAzNsb7WJZhSUNfPDcVNKanc/Sse+a3hFj
         rLeoidAJnUevhhhAy2UJbfFdPFMyzDS8KqrY0pYuFuQ/BxvbdfqPP+GOPOp63iv9XBru
         4D9OSkdlHk59sMe9nk1U8siGnNCVtjy6LITvOpQPjjHo7CfsBc+SCa+O/6lgs8bKiW7q
         CuyiJvp+OviKc+e+m8QTj/TQTheGjTxFrndtZRMuP05zyawnSpoP/tCEiYgXWxwT2tWo
         mnkuQk+vLCYlDhE+CD/H+YO8/7tkFdUW6fAj4uXm+1kAbYmXQR3X15/ZLOHT/7Jm24p2
         8QUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787582223; x=1788187023;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dFFCpD+eyjMYiOlaAWIMnRn59i/x4sm2LgO1kNi90A0=;
        b=eJVGsN+S/tHq8weGw+KMOVeYrWRHJFaVkpQIBFS7lTLG78MXgginHIyczIsUmHftBB
         nNwTBsSfW0rUIhtWrvsk9kevHLXsfnaPI9px64zmbRCEeJ8f2LixVtJ7coZC8T8ZISVJ
         lPKG+8kDLIhDKKZ8hWF00zMyXPS/D35r1Y2Z+slQvjU2w1CU4/sHbDo/YGHS+Y/1R3pa
         y+ZjlOYGKDr0onFPlJONJL11oPpwujc1kSicp/uOKlGkkhvzMSQuFKRdGYOisxK1gVkp
         BDKYpxm/bDhFrEQL5u3ZKKLbJxuY71uI3pVJZRXl6UDXkKWgbw6XsV2GrBKZlpDsTqqP
         n1Vg==
X-Forwarded-Encrypted: i=1; AHgh+RoFstPgedecvE70wKWk6UGcCfritgqXJb2m5vOs5aliI7bks+RGCZ7WOnAjiP2Y2IgUtMPpvPg2rA==@kvack.org
X-Gm-Message-State: AFuF++kOeMCiD290q57I9dRl9jEhK+WRSiImW+QXMExzdzmjBkrYXUrC
	DmG1DeQBVulN708DiZ8RR7NTse8Ka5rLbxnoGRc7h17va/Aal3pFPvEmG3rR6lJeZw==
X-Gm-Gg: AR+sD13gj6VdkNu9Wko+Q5WikvFmUyvwRHA7q1rT5/Blk2wf6VTkGc3+dvtM/toqbfP
	qL+K+BGq0QMgdEdMVdNlThDQyyNyS7ECvBRUvl9daRZjpHfQlS35jfTqelRuGjCXfSMnZ7iUvTG
	x3MayeU1BpOcDEMcBoGIqW6oSrwnUjeyz+0AkHwwmwhv1A1C8P14KrDD2iREItYHAdhnq/RbqIv
	+BFbi0uguBJV8FP9K/tZeWr2YSqi7rr9xhRmMvG02y4g/aQcyuQsWQ1+VK+XI1zab4bqJoAm+9G
	kuC6IrpT1f7esOdMt295FKmkpXg5qiH1MU+D4QHxUBLTWBuCwjgAOSsODkwcA8LTlp9ZgLKluTg
	xuBv+l1uRHqa2esUGVDAsIJPVmBj+lbfZK4t3D/ImXeOd5DR1dEy6jIrggjYVJEyoK3UUoyaP2Z
	QAGfKrSjlLR2YNTqJjVXvjkx6lTeDS7FSlCs/DsvoHcYyj6jBHdvUaAft7YojG3I1w2RA3jJb6x
	alRybn337YH7fkuwbOvfuSqHRK27sT3z74tdndqzt1ysXh1
X-Received: by 2002:a05:690e:1309:b0:66d:7b7:e36c with SMTP id 956f58d0204a3-66d07b7ea83mr2357073d50.48.1787582221803;
        Mon, 24 Aug 2026 07:37:01 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66cf46460aesm3729534d50.6.2026.08.24.07.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:37:01 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:36:57 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 19/25] mm/fbatch: vm/stat_refresh include lru_add_drain() on
 each cpu
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <509da837-bd5c-2090-d26d-0002fef0b1ac@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7ECD31C0013
X-Stat-Signature: qjj1p3etyp6upgsr58dhunwr5y7mwnou
X-HE-Tag: 1787582223-29454
X-HE-Meta: U2FsdGVkX1+m2xv75k9FaWKgQr8t1zI3Am048UTE3lJtWayDKWpJmoEsPuCrYBY9KSgS9LNxoOH3Q1HoRGmjVEyEfaE0MUW3R4tLTPtB0lQhUWpv+FCdfo+pUAKauQ3fyNOLlOOlhuk4n6kcDTa02/LCH7XBFbK2dyNu2xxCewFo0zQUPg4PrxrJy+wSEK6KsERpA1kIIEv2woFc5ftfhiNpZ0htRShHPLxz3XAJWeopvgQa1RSQXyIcSLW9pW/nQTbpABbyrLi58JObaFvI1fQU896EAJRu/svcI75FSTylZIrViDwQZ2rzqMClvVrJ97HjfKwE2Ijiqxed8a/Xa2L04Cra9u64/Y1CFz4AOCOm5qD0htSOkCjCUp7uhGF0Qm6lhfj7d3gl7xzRNVIKTfBXGWPgCe79wQrqIAh1//rhW3CCvF5Li/G+Cja4RlhQin1a3v671cvgcl4fP9dwwGnI1fb1PR/Z7qh1Th8YqktkMTWy2gZi0jsUBzx6qDWqdx02zkSMXyYswWlPeWJ/i5LsmjuBmc4LE5W9iNxlBqfEKwflDGG0L7A74HlHcDEit1b647tuMYeG+LDZOq7J2ziS++6TaGfzUxqG3bPpkGv+MYfO/E+4nYveoPLpAHiroYh8cdjMKhbycpcpYRMnYb30hgXewZARMQNOY4HCo/5o2k6H2dEsULY1xE55QYrx/ciGV2lfJGPVtBKfReVRC0fQ09i5dgW6WvpAPPDg1nQlSK68FT20kYs0qHX+4fHKgaz8eUok1XjCRxGl5eyS7AneJxd52k/YbHHGPmJwsW9dZRWCLgm9YnnvQF3CISa9wNfSEzFDsi56RjEpmuF3/2lOfLU7c9GKqMjmzihChhcoWOaSX1X61ylMH8Aii1pxWDQgjEj6pXpZowYzBOtsl8OHu2y87+SzTBSFqZpJWSS52FHcMzlL8IJDZgD2fpovL4OQ3sNw5W7g28399bU
 uTtY8iIh
 mARXcDa33c3WQevm3PQiiN7InbUmFE0qyfCCX4l5zVMZSwz+s3nN2mgwOXxZ9dWQlXSlWTpgC+C0NIgTCyHzcOglxYkbM7RAyQxjCIrwyTh5cSILWX1XM+/5P9rEU+q0aomu7jpiXKo1PhNhM2SjkhaWcmyQKx/fo6wPM9jCzvXJF21d9HyzwTGo979TcKOuPSiUy0pKlgCk9unRUbDP9mhqO1R38WhBZhysEqHg163hXi+FL+Kz/tpTYvQT8xT0vD+CANLxbCh91/VYBvohnHBqvFzgFy2dHx0FaWWCZRGsCwOg5j6i8PHSNFf6HPEE0rQCpXLWQV80csplJhkScHeH+AmNI7H+eiLke14eEg/OQ4ziuU1yHbYAdsTLcdRgmZam+0ojWS7+fnuNggWXZFG0CVTMVoVEbS6yy7lt9o3uvAI83LaNnHul+HOA6YAr+OXMQbclpL678kh0FRTiLH2AZvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reading or writing /proc/sys/vm/stat_refresh has long been a way for
testing to force an immediate refresh of /proc/vmstat numbers: it seems
appropriate that it should also call lru_add_drain() on each cpu that it
visits, before collecting that processor's diffs.

Add that in refresh_vm_stats(). I wanted it in refresh_cpu_vm_stats(),
which would include it in the regular (default HZ) vmstat_update() too:
which might be a wise precaution when proposing to eliminate almost all
the old calls to lru_add_drain_all(). However, that would go against its
"strives to only access node local memory" cacheline care, and bring it
into lruvec lock contention: which would probably displease its authors.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/vmstat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 3b5cb1031f72..0f75488687b5 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1973,6 +1973,7 @@ static int vmstat_late_init_done;
 #ifdef CONFIG_PROC_FS
 static void refresh_vm_stats(struct work_struct *work)
 {
+	lru_add_drain();
 	refresh_cpu_vm_stats(true);
 }
 
-- 
2.51.0


