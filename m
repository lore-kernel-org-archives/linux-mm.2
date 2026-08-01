Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA1ABC54FCD
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 06:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BF7E6B007B; Sat,  1 Aug 2026 02:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796456B0088; Sat,  1 Aug 2026 02:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ABE86B008A; Sat,  1 Aug 2026 02:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48DEB6B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:58:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A024280157
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:57:59 +0000 (UTC)
X-FDA: 85051795878.06.946378A
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8ED7720008
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:57:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="u/jEXbng";
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785567477;
	b=TJ1lZ/nod/zeYo/L4nM18YvKgnGF8PNVWp05iDnEY1faiZL8+Lyu1gbRxIMMGwwD6S2hFV
	2sfQiMr1Tj5IT6LcYf1leHtnVfdbaqF7rMerXDh5ytGBFPxbz80QYatVNnMoj5z6W21bOz
	YgPIibYZzGHJWHxS7XWV3NlKRykBddE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="u/jEXbng";
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785567477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l6qM8HHytw9VOLZx3IXJ9Xf+DVG4kFaCSzoE8n3hynw=;
	b=xBHylGCnWUFi2gn8CqAWqN9T3doj9Ee4clMSUAe8N6enjJT4OUlwTtL7M+V1hxoOm1h1tT
	XSlCo3eAGWg1XZkqbvJqczuE3PgkH487dmIZYAWMMXXbMk5aTuePMfF1/4JUvZgiXakn8M
	Wg31cDMQPMH3Z9LgmImolWkcTYmeJCA=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5218927884fso15831771cf.3
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 23:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785567476; x=1786172276; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l6qM8HHytw9VOLZx3IXJ9Xf+DVG4kFaCSzoE8n3hynw=;
        b=u/jEXbngfdFQHB3UGqLZd6/VcBpLVEtOjIBMnmcM1SWH2B8j80TKh0M3huK6f5B7Wn
         cr957dNsapPL/hQIBda51LfNWiq6OVYs0O1nguFLEYqqt8FoqIv/L6nIoSL9N1mvuUpC
         MICudyUlXC+8hudVAaTk/gN5XsoO3NeD+MO6n4cOucfrCZZ+SRfkNLSlNDI+k+V1DyXb
         m6aDsXLpGbjIzTAcWK3AJgqBm2ytZ3j57JWfDVZPYc9xVAPrXMQ+Zvf/qoNXavWn4+WG
         OEjVGcDR5WskVQPrMk7hH9GqPqMfcLvZ9K6N1DBOArJpF8nvj9Fd4dh0udDbCJHT/r4Q
         DeJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785567476; x=1786172276;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l6qM8HHytw9VOLZx3IXJ9Xf+DVG4kFaCSzoE8n3hynw=;
        b=gBcDNAEBly3jiwO6S9o9hiekvSkxiw7uG22O7mgiXBkV+HakINlcVgwRi+9KoR4qV7
         yknDiFHrrgytGImpSlWX25UJaA+xIeNWdxb03hCAqIRHXfuAT2s5quc2IFXSTm7ddpdA
         knNbNFANSGoTH3R09l16DfZPAhh/R+X38sSa1T5Hxng8gaiaZ4KGkGxsapxt2JgmtRJa
         E7vvH2iwMVm1Xyvc/xzZI0ViUP43c1D1QsPCu5Ie5SeU/RK76T6oUEM2fXRAGPErVTLI
         hUZQfrpPeKQ+A+QxpeayFY7fiSZFGSjSqSbFH3iTGyupIGhm00cMF9FiZ0FgcQ+ej0lc
         Hu/Q==
X-Forwarded-Encrypted: i=1; AHgh+RoVoZXXgI7bhLuXw9RULSVpyOfgayG5jVNUeayE8j7frimyLqQMn8Kb2VFtHKtDcBz0OOGdm8+tHg==@kvack.org
X-Gm-Message-State: AOJu0Yzs1uhS2IvRUqpLsOV0ouiiaATBDrPq/cZuVbgDth5Blw1YxHHA
	j/g2lOF5f02qG5ZagCFNPZyHL3SVL9FQR6c1ac4Dq02ImkiLF3HruMKEpBgqLEg8gbM=
X-Gm-Gg: AR+sD13Fn2xcVh4WqwY4AVPr/34nyNRS9dfU74BFH0U9Su0naq4SIqk344ULhQFWS6B
	lRKzvrfyVikkXSNM0WhBhRfCvDr42aguLlP8YKqe16NaUmWy/X7lLufJPLtFlNUBazbjP4WsPU5
	VU404lcuHAK+bWEoUlKusOaE2nVPxVzH6lJTsMndjMKSOWT9yFeiVsG3neE6u9Gq+uakKsYE8Ar
	q0aETVtUQPjeyeR+Eg1fEFRKNkHrUuqWcJdXgQV8S8/AD45mIsb1pGRU3S9Me7NOCDhoZI9z4rq
	m4cppTk2p/pESgnxtpUl0+MbM2woqQjpSQNfI5sON0yUCAtAwFxO/EEU/25TUTFmaeHoo0RevWX
	XbVHjm/UITjRk1TTyrctM68Adg/bYwHaVDCXCqfUZk5icIDRSbETPrgqfN1yW0favld4hWDGICu
	4kWd/bSjD2yMKI1XfNwy8ZphtqZvJusjKSimg4rpxsZCn9LbmPhNbvhebsdjY=
X-Received: by 2002:a05:622a:4d98:b0:51c:19af:6330 with SMTP id d75a77b69052e-52b567cdeeemr57512221cf.36.1785567476437;
        Fri, 31 Jul 2026 23:57:56 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9084a8386a3sm13495486d6.15.2026.07.31.23.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 23:57:55 -0700 (PDT)
Date: Sat, 1 Aug 2026 02:57:51 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	William Kucharski <william.kucharski@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] mm/huge_memory: use folio's memcg inside
 __folio_split()
Message-ID: <am2Y78jxTQTlIPPe@cmpxchg.org>
References: <20260730-add-gfp_account-to-xas_split_alloc-v2-0-5a56c2361d85@nvidia.com>
 <20260730-add-gfp_account-to-xas_split_alloc-v2-1-5a56c2361d85@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-add-gfp_account-to-xas_split_alloc-v2-1-5a56c2361d85@nvidia.com>
X-Stat-Signature: kdgrszcnoa9g6cak4jkszbpdaxp5dk5h
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8ED7720008
X-Rspam-User: 
X-HE-Tag: 1785567477-781619
X-HE-Meta: U2FsdGVkX18Q/xQ7kP2OyWkUy0rHuZWSIlKdyDeDeKt21VH0zvEazWZynr36gYSjmPz5toUspsD2eo1bp71fBk4MtAt6OpH7WQ1MUCyVLjfm7uSy+CK9IlBCfJ8hU9Yp0D68QTYk4HmLd4KlWWt44t+emedPV5H3G8jn9H+lHetpkQ+BKMFdLVf8Y1ZInal0pN1umUP3uSHaY7mXjBRcb4XjQylZgHkNqd18tz+I/4YAlSfjLNFbbSPI1OX+5Z3GVdyTsk7tnt3hhSbqicScLPl1LtT8dvKAFfCUILuMhTPW0E8C8m9RQ+cdpCBMkaczBj9YihbfzZ3h/hdpRhNZ6e1en/Sl7YCprbivJzfG7EHl7UBxtxmUXU0NyGIQDYH7BKumME3uWFqZbnAlxnLRJW6nzAiin+7tZ9C/QOiVskMp0YRTJbB2S22VqAdLnGxfgxbCW51VCB9wVFad9VJCDpYdCGT20+u4X6Zuk3E/W+tNpbjnFSEvlS5Ie2InWvVwhWZbnZ+3hFQwDB/BnoylI6mqB5R1jYYhuppRrc5iw9LpoLWxW7FDuH2GU01GCm40AidHs/754mGOtt4J9U13/rORiHoyffnJdUrH24EtmCLQkr0dJFQc9NqH5c6dy+7QZvZ0oZHDsMgqS3bNAQ1Xp9PIGO8C091Ns5UeNbF+i7IAuSJa6OO+vzMb5mE32nHy3Dazert+OzouGh9BtNEHKCZ7WLoTy0WrAQSLymJ4qaM+DT0Hg1q7LQdGm+dlvZ3cTaVOZy8FpnOuPYkY2VF4XKfxuTc6RJLmngepy1eR+RelbtIiLmV1uiBwIdBv7lmeEaqJ2dZ2/oXxfBgpwtMxH0OeKB0NYxeY+MrHbmxPGHJqzU0BPeZqYBLCCrFqygs5yUEJpMWdleEZd9Xm+a7ayGpipato32z8c0kyp+W7dWWY9tytQgqvLFqqrVCxwu1J4KInVMlYDmdrnRdeuhP
 rFLqZbq/
 dvly5TV0iiox6uOjbzw9TpOWfpF9NcMoKEJNvPI0lSdH+BcEvjT9kMnVUjRKoxBRYhA/zk5vdj0/c9swS5LUe7aVTddCTmDYpjNetmkvu8LMUQUsxnwiVBO2yZbh6G4gGxtHI3dBM3OBTipo4FdHOBV74HtcgAR7Wjs+ZHGuVuCd3gagqM06zPmdKKJI1rxgidYXhYKaJi5vgJGee5DLrdXDm9ysBcPh2fSnGOgciVeM7oNxWeAKLylLM7HDmstMb1wMO8/64/OOd22d/JwO2p10/klK5DuhIdAQQlio1tlq7ugn0rgBaSwk+Cz7mKsNdOB4dkrDGdDV9mGQB4aVJKxWSlm5em7kNLSSh+z0W00/kt/XzIoT91fwHjSYGsJ2b88gw3s6MPTF+EnRB+4blk56VNBe3w16DJreXVX46PA8n/8c5VyAK7zEIl2GCAH+GcqNLHiEG7QIrOKF3c7lAuZuw7wiOvMtln/iis1+/3lMvdz3c29QtjwLW5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 10:18:00PM -0400, Zi Yan wrote:
> During a pagecache folio split, an xarray node allocation can happen and
> needs to charge at folio's memcg instead of folio split invoker's memcg,
> because for example folio split can happen during reclaim and reclaim's
> active memcg might not be folio's memcg. Switch to folio's memcg at the
> beginning and switch back afterwards.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Fixes: 6b24ca4a1a8d4 ("mm: Use multi-index entries in the page cache")
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

