Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38EF9CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 08:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 826818E00C6; Tue, 14 Oct 2025 04:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D5B48E0005; Tue, 14 Oct 2025 04:15:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EB6C8E00C6; Tue, 14 Oct 2025 04:15:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 498278E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:15:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 749A1BB27C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:08:28 +0000 (UTC)
X-FDA: 83995992696.20.A9DC379
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8C5D31C0009
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:08:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jDWsxC3L;
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760429306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lNULsJSShi9Qv044L8BUWXwBT0WWB+xiPbW9Mna22LI=;
	b=GDsOyhyEoeCNJfosoALel91W9FBj5VTTsLQ7FmFNS1xy/aHeI6j8+xQja+KEsCpjnn8Tyk
	W9j8v2FM3U3IRnoTb6lDGTIulgpKGucr+0bo31tXDnEF2Xax1HGgsBH1gOEXn+v4PwJnan
	Y6f/Xj4vIhwvYPpd/gUoTyDQTh8we5o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jDWsxC3L;
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760429306; a=rsa-sha256;
	cv=none;
	b=w2ZmkKP2z9AnK5aqHOU5zpy7CZwJSIyP22MFVxbhPN9tZR9JAU5/AwyO7IMVQj0xPYyLOj
	eB58+WzjNUJ98+60jssqvv3CC9ewouU8XdyR8G0PsUvfR29afwmFrZr3L1YpHR8P9z+OqW
	aB4EgkMDRMJJCKsPUza7QaZ7jwwM+rw=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-27d3540a43fso47858005ad.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 01:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760429305; x=1761034105; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lNULsJSShi9Qv044L8BUWXwBT0WWB+xiPbW9Mna22LI=;
        b=jDWsxC3LQIzQMqKEjGQVKmlCEkjnE9f6cFEZXgqCASlD4dAn6idt55UaLHg626LTng
         /dPqAJH6AMnmhtb5/Y5a8Q3HxZCwtmORqPirtc6H395qiZWAxI3HKayEfK4mtExd5kLE
         uyjudg32OJhb1Xj38uhQiPECwozbvIe/PJ/RPPdT5pAw8K18FwSLjzB9GPORPUEsl+Kx
         dMis5AzA3iokJGyyLqHGM17dMfzApPqk73OWbpHN41auL9mi/P1ZlIqk1N8kF0tr6f8c
         85rzsP+t5aUQ2Rtfiq9W57ZI+XDGvWTSlOPCVUm6Wf12Y25M1Y2V7oVi1XAI3f7FU7K6
         IQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760429305; x=1761034105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lNULsJSShi9Qv044L8BUWXwBT0WWB+xiPbW9Mna22LI=;
        b=cVEcwrbI5XKy3dg2ZoeRXG5TxY2aAGEu7klYczx941asT8DAKRAl4urN8qjr6g06hi
         4rfxW5c8E9c9CEr7Fc+oO5QQkY/AWWmZRAHPvZhtFDWml663XdzTdm2I/q/jMvi9+Rrd
         mauroIZXpBU57sGMuldeUMUVroenyCy9QV4IuB5wdaxz7kXikRur5GaWWNoQMeOMGA5n
         J9zKVAPs31qNSSZnj4tkNpQKok2b195IFXK+7eYTpWe9kuWeFSAZw0ZeHb54SGqteGus
         HNsREgGc2Gy4m1v4tCn3cH4Fd6KPOP1EgQ5F0xhN57WjSDQJsKRIgBgjNiUiC0a6Hbq9
         Oyog==
X-Forwarded-Encrypted: i=1; AJvYcCUU0OGSfHFIsaKYa804ZlKTi8EMmN2LAFI54nD+qjWjUL/V3MKEOz0UdKSZyXdyDuUzz2AZzvn8uQ==@kvack.org
X-Gm-Message-State: AOJu0YxFd1N9Kz9ZKls+4wUgp0O/FOJNkKf2JHdaKFmHY0lnsud7R/Ve
	l/HtuYHQwVhgaDUTfPgf1GinK0MEDoBlrEWIu9vU0DoEywGNCSPNdWAf
X-Gm-Gg: ASbGncu3Sq161WjISBvammtr0mEuyczH1jyHxvV7dKVT5AdwQ1YH9t29f/JRQv2HrqD
	cJupAyD7J4TQb3wiTzNvcnWgWaB0wf/TMhxjzwJR/cJKKiQWMkO3onHwsD/C30pwSYd2Kf7Jle1
	ainAjFS3iScsKNHmCMxLVe1JyGsMZecNsE/LAZ3t1uyMXbvbiEzaaUYpUemkfzAH14EN4dt6hfP
	xieWAynQBE7ECpNtuC91jH0rghjMCVglUjqeLIgt7Iy1qnaTARlA3TCM1P6whRWtUAYMp/+5aCs
	9ageqye3+pTUGo4A5hxQXJxMW3dE95OBfT+POZCclAlEpL/XgemDZNRCS027YeybZOaXwQd1TGL
	CTqMW+RTJYnA/Z5L5yylYbY5kZU+sXzKsx43rrgMz3nXmbypE2PM8pmmmahe5SGFWwctoAriKpF
	lOGZvmRzlL3kR+uA==
X-Google-Smtp-Source: AGHT+IEgCv4Yi86mKXuSGOsGI+y5z9FGwzXobVA9uILnehkakJ1dqhotPD42azyffPNXp0Nf9zpNBg==
X-Received: by 2002:a17:902:d58e:b0:28e:8c3a:fb02 with SMTP id d9443c01a7336-2902723eeb6mr285920325ad.14.1760429305163;
        Tue, 14 Oct 2025 01:08:25 -0700 (PDT)
Received: from Barrys-MBP.hub ([47.72.128.212])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f08912sm155263155ad.78.2025.10.14.01.08.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Oct 2025 01:08:24 -0700 (PDT)
From: Barry Song <21cnbao@gmail.com>
To: mhocko@suse.com
Cc: 21cnbao@gmail.com,
	alexei.starovoitov@gmail.com,
	corbet@lwn.net,
	davem@davemloft.net,
	david@redhat.com,
	edumazet@google.com,
	hannes@cmpxchg.org,
	harry.yoo@oracle.com,
	horms@kernel.org,
	jackmanb@google.com,
	kuba@kernel.org,
	kuniyu@google.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linyunsheng@huawei.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	roman.gushchin@linux.dev,
	surenb@google.com,
	v-songbaohua@oppo.com,
	vbabka@suse.cz,
	willemb@google.com,
	willy@infradead.org,
	zhouhuacai@oppo.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
Date: Tue, 14 Oct 2025 16:08:12 +0800
Message-Id: <20251014080812.2985-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <aO37Od0VxOGmWCjm@tiehlicka>
References: <aO37Od0VxOGmWCjm@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8C5D31C0009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6j3fnf88qygy8zx4qci13pnbtgw9ph44
X-HE-Tag: 1760429306-429417
X-HE-Meta: U2FsdGVkX19UV2VyOMAQWy+lD/266lwOFaeEBYPpESsrfSbMpvOdGry9Qo1F7aB9jSUZtv2S3rQ8CiKwmeXacvCCimkePSivxbEneRlj9Y9AOhjBRUERGI8YGnpcLU5DwW/Vh5RO/djSYnNZAlZujqboqiqTPc6QhsmBYrEwmC93E//Z+0RgzzX40zi78RhHIylm4pTz/a3dWbuMfpJzP2RC5KYauT7lGnNXLxr9Ys3O+X4l9cUVqOf92yMMDHVAwVbGtDidNzhJNJjt95dG7csCtsfhULmXOnKr1nJe/A+nXpQElJABLF5fOmnypY6vaqTH2lzW/61NsJaW6YP7Qh9isKkvEvswtSg2WEd85jrGCA2eGu9RRbvS5x1BEejppbwyg0fJmrNSE/jdkMDg+QTxTcj9HgvKnk0CtAnznKHmvHAZyPBmzpbOW3dnKZxt93xoHoHTem7DYXdwFdbAnLYqtzzhkaJYwSlP8Sjyhst/7xwyEM4pHFSiSysRf6G0teBKLQXD9RT77YbkYGbOUQbI+FCs9fV8OZIiUbSoMu5Wd5irG2VYpUlnxRvwYiiN72nqdmLhuL/bhYHPJnkLEOMNmkDNPJcvnTpElL6BizEsaJlVzOHB+3RBhWgrD64qLHt55z9tkjuY0Dgt1MVYQGhB6B6kqfdPVvJ9t+6X6ah53DgGuevraTRae+uMbgNg/BFbw+ygdhQFbNL61RzdK4CAp9HTgcTkdCg47Ds2fmGVbfZACE828lFRA39DFXRozN/kW3u+Z0hwoqHtfnbDCHA5DpaLQQKIpt31H7ap+EqdpuEOG+L1Xhe3zWrRwaaRQklIWKNcLyatZteQC+CiX/nm2OvhRctiA6+FRiC4D84V065Vw88SCFzHS8mHyBwuEDvVbhFcpveDP972qCA3IbJDI2Pboo9XPvSKUe/M9K6u89uMMK2KUqRhqfZHCcvlzL6ObJrSo6+h29tINE1
 JYIz5PaK
 4vao5kd1k5tm+KWzp+bfZ+g8+Sw8KVo2mdXhoC4l1WJzq7obVeoDospwtDJy94M+WIO1FX3OSy8QZ+P73MSmvf2hfAWNiRisNZytgJe1iXk/OmZbgKG4evssh/etj6uL4AURV6MqIkd83KeTpBMZ3+3rMS6pjSvVe2hNkHFDXtf3xhZm7J0TMBDLxn/fVeh1dhf/mpYUZRPulR1EDAOLxveYdSX4fln4ys+fAAHKUHWELjwfv7B7tC0za85NG8uclCDEtlCKEVYQCqsG3L0OIcwLVc0FizHLdMRB69X6QCer30C6+c9xFAEXEqGOxMHp3u2niAHDG+TSlYAI8QizYLBS/+XDeFaJTUzkFH8OKqTSr9gwiBKUegzYpO+AoGzh6xj1DCtNazCF+jeyH8JWJxm57Gk7hfnFbRDvfwbl1yukOb1TXI0xuL8wbXW38+/Pj8wV6ZXgT9amCHAZpj+bUE+ubzOcXMA8W3RSi7G+IKNqZn/Zt6W4WCxu9jSb5Mhl1cfh+ioG3xRUPWPBVWnt/38Soy4c0kXS092vmwyafO54719eBeS8E91vnXIgoXeDzqS6diF5DaX84BQU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 3:26 PM Michal Hocko <mhocko@suse.com> wrote:
>
> On Mon 13-10-25 20:30:13, Vlastimil Babka wrote:
> > On 10/13/25 12:16, Barry Song wrote:
> > > From: Barry Song <v-songbaohua@oppo.com>
> [...]
> > I wonder if we should either:
> >
> > 1) sacrifice a new __GFP flag specifically for "!allow_spin" case to
> > determine it precisely.
>
> As said in other reply I do not think this is a good fit for this
> specific case as it is all or nothing approach. Soon enough we discover
> that "no effort to reclaim/compact" hurts other usecases. So I do not
> think we need a dedicated flag for this specific case. We need a way to
> tell kswapd/kcompactd how much to try instead.

+Baolin, who may have observed the same issue.

An issue with vmscan is that kcompactd is woken up very late, only after
reclaiming a large number of order-0 pages to satisfy an order-3
application.

static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
{

...
                balanced = pgdat_balanced(pgdat, sc.order, highest_zoneidx);
                if (!balanced && nr_boost_reclaim) {
                        nr_boost_reclaim = 0;
                        goto restart;
                }

                /*
                 * If boosting is not active then only reclaim if there are no
                 * eligible zones. Note that sc.reclaim_idx is not used as
                 * buffer_heads_over_limit may have adjusted it.
                 */
                if (!nr_boost_reclaim && balanced)
                        goto out;
...
                if (kswapd_shrink_node(pgdat, &sc))
                        raise_priority = false;
...

out:

                ...
                /*
                 * As there is now likely space, wakeup kcompact to defragment
                 * pageblocks.
                 */
                wakeup_kcompactd(pgdat, pageblock_order, highest_zoneidx);
}

As pgdat_balanced() needs at least one 3-order pages to return true:

bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
                         int highest_zoneidx, unsigned int alloc_flags,
                         long free_pages)
{
        ...  
        if (free_pages <= min + z->lowmem_reserve[highest_zoneidx])
                return false;

        /* If this is an order-0 request then the watermark is fine */
        if (!order)
                return true;

        /* For a high-order request, check at least one suitable page is free */
        for (o = order; o < NR_PAGE_ORDERS; o++) {
                struct free_area *area = &z->free_area[o];
                int mt;

                if (!area->nr_free)
                        continue;

                for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
                        if (!free_area_empty(area, mt)) 
                                return true;
                }    

#ifdef CONFIG_CMA
                if ((alloc_flags & ALLOC_CMA) &&
                    !free_area_empty(area, MIGRATE_CMA)) {
                        return true;
                }    
#endif
                if ((alloc_flags & (ALLOC_HIGHATOMIC|ALLOC_OOM)) &&
                    !free_area_empty(area, MIGRATE_HIGHATOMIC)) {
                        return true;
                }

}

This appears to be incorrect and will always lead to over-reclamation in order0
to satisfy high-order applications.

I wonder if we should "goto out" earlier to wake up kcompactd when there
is plenty of memory available, even if no order-3 pages exist.

Conceptually, what I mean is:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c80fcae7f2a1..d0e03066bbaa 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7057,9 +7057,8 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
                 * eligible zones. Note that sc.reclaim_idx is not used as
                 * buffer_heads_over_limit may have adjusted it.
                 */
-               if (!nr_boost_reclaim && balanced)
+               if (!nr_boost_reclaim && (balanced || we_have_plenty_memory_to_compact()))
                        goto out;

                /* Limit the priority of boosting to avoid reclaim writeback */
                if (nr_boost_reclaim && sc.priority == DEF_PRIORITY - 2)
                        raise_priority = false;


Thanks
Barry

