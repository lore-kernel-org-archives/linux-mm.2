Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87427C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 17:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 810F76B007B; Mon, 27 Jul 2026 13:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79B5E6B0088; Mon, 27 Jul 2026 13:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63EF66B008A; Mon, 27 Jul 2026 13:24:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 319FD6B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:24:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C1954A0634
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:24:02 +0000 (UTC)
X-FDA: 85035229524.14.2927C3E
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id A85E1180007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:24:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HNc1E0EA;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785173041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/ZbfBCCG0jHDBCNH9TydT1nctmDeBJrWwsqu8EzeJ4=;
	b=fzC4ZP+saFlv7q3RSVxPSwZsFEMOI4zZX+OzcQvcscmCvx3NcHZY0ujPgerz65D49Z6mAG
	tLVCwme+hhXf8D3CC8sDv6lfD8ESov0w6k6nJ3tw7XMTp0BTQsXAitm4D5u1zQ6pl32p1w
	41faaaGqyn4D2gE6968toGONIewJBiA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HNc1E0EA;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785173041;
	b=HmL3yANw0T0GLFaK2H3LS/AaDoiawKZ8JQ3F1BfWyc8+ug2cAhzdwHTzwjCepxiKEykMzK
	yX5wM2Z3wiZr6aIuSl0KMo9+i3mLonlxjDQqQNXcKvrCIAaGcUwZW88oHBuPyLP2ldf/Ll
	mXNGbZzhw4m9MACi8lltIj+qozWWzKI=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8ff88549786so29809216d6.3
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785173040; x=1785777840; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5/ZbfBCCG0jHDBCNH9TydT1nctmDeBJrWwsqu8EzeJ4=;
        b=HNc1E0EAjwPio6w/nHI3kt/xg2nMEs8bNjdTJCVhjsXk1FTq9uiPLZObtDeCuinDFl
         USzsIpm3N51inlgP0rtqxsdEduBJS7cJq7XgMmfxw1mYC5+tNQoHue8DnGNpSCmmBXpv
         ozXTh86RPWE0aTLXyl8jzy5WTJx6bX9fRmc2QU4uq3QPZuUcY8C6dL8ZLHbEibl1KKnw
         gzY0AGCxNbwMo1sXC1AwScuAyA5ZV/NmJAOO7+KOPkDnXGu7+qxZ3ajOrouvbhYKY4nl
         YUqAaAAGZ6P/m3GFD2M68hgo15xeaxTJgj/trPh0K1/uYIXnApxtIESru4zQhVxpPDHE
         AjVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785173040; x=1785777840;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5/ZbfBCCG0jHDBCNH9TydT1nctmDeBJrWwsqu8EzeJ4=;
        b=JsIzu752JE7eYXEVAQIo5IbLeNxc99LHNzNJJdlootg/BBrFjE+XlXNNmr9F2akRDg
         qhB8XcYMQ7k1MvMseuehcSsOwD569duCW7cIkth88BXkPQqZx07/iCEV32ZINqkr3z32
         LTxOvz18Y0zpBLQXUvxhvt+cg+UBlp+pe927r4Dl8XLhEl6xBWZiZD/p31YepGnkvyOE
         SVrSX50En8Sfd/uEn+DPiNsmOIe/TTNDJ2J+xeR0EJInXOdY4uFRjRf0KJlpYYJEi8wX
         0/uwG0C2HHdfhl5T9st8N8YjGN5klE+3OcZlYL+BZyjH4Txx2S3ElTAnyBcokfK3646F
         Ufpw==
X-Forwarded-Encrypted: i=1; AHgh+RqEE8YcRSFVL89x8o81wdHUiPJTVt6pGOhmnO16ORmLrEfAhj7QvdYV34YUAVvHzgAJqQp5jnVjpg==@kvack.org
X-Gm-Message-State: AOJu0Yw3Pyq8Br8XSsqSXt8oQg2PbNgMD1KB/XwVxPsZDtL9NAHVHOkg
	ebs+wDIU+zgP5jMYR0tGYlWq5wnGK3T+jaT7G0KL6VkmWEPlWsujOToimUbcPCb+y24=
X-Gm-Gg: AR+sD10xQIj2zgF2YKTVm34Nw7Zj4BBOm/wRWLnVqMjnilf+g986nz3RoYi+gG9gnK4
	eotxGtBcEMCL3s5jMgwK/RpALTRolVnmmmudsfzGm8vV6MmgFebDXX+emyCiMOD8JlGzwX6vXNB
	bfV0onBOmz5AoUQDSNUaZ+SZOX1Z8JrfiXsjKtrrfc6AJNySvIIueuW3DtqlWGLTiNBjPX+O/IH
	dj0fRwASxSON+4w8yA6VSqCaUVf8TSuLjCKZL6QY9P79deaPgXPUxYOWOthX2emODsEtxmzxgMf
	YQqqXsB0TeYhOaeeJNQ9J8/obk128plvDD2BjZcnhZuU318bxcBwvk6iGvJ2VistfaYue3nj4xD
	saKS1izZY6H854+jzDbQMaCUv9XgMSsPb51ufQcCNVyNA5FNV6Re4LSsmqqk+BjD2jXvAhb8iFJ
	2kUjxmqmA15y4kYHlHyy8OBmOKSr78Aws7V+UuUN05ecWzV+xxr8tEEsfdmuoj9ShaOVZNHB4=
X-Received: by 2002:a05:6214:e6f:b0:8df:93d1:ca18 with SMTP id 6a1803df08f44-90812689696mr6173636d6.3.1785173039676;
        Mon, 27 Jul 2026 10:23:59 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907e858c4c1sm69737366d6.22.2026.07.27.10.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 10:23:59 -0700 (PDT)
Date: Mon, 27 Jul 2026 13:23:55 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev,
	youngjun.park@lge.com, roman.gushchin@linux.dev,
	muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v5 2/3] mm/vmscan: add pgrotate_anon and pgrotate_file
 vmstat counters
Message-ID: <ameUK827HSgx77kW@cmpxchg.org>
References: <20260727162550.2032-1-usama.arif@linux.dev>
 <20260727162550.2032-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727162550.2032-3-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A85E1180007
X-Stat-Signature: y159953fxya6znu41oq8pard3kwu9kg7
X-HE-Tag: 1785173040-371455
X-HE-Meta: U2FsdGVkX1+Dw6oR9MNSe99xAF+kK3z0/+g+ogfBzn1JMK+qPXwS3j/qbRwHw/oMPpETSY84ThP0W1ArVZxU8PRlyiQ3TFbZrWrb9+WRqPexCtbt0UapIwbFYA5NIGz8GIRt0r+19r4aY6Yt8fwYGWJKauVu+k7/Tf22CD5ox2ZHmNBfXiXoTaCsv/EpHOyyrA4Gcm1unNwWCPBvmvGDYu/o7Wg4W+MIqglzcaCv0vtSEHl3+SNA+tJpVvG3kokT93ZQxqPl4gCUm7oUgQ9qUDL/sKnxV0jq9z583DCip+netXud3L7OcvJvRz5Qopie/zheFlAj7QetQtoeG1NRkhNkooXOxJIiCSGlvYeF3yOaf1ANyz2mO0LnEkggmEjHqLMHxLnF5pVTUS5uG3o6pzOvMDBo5vpseaC7InR6jQkXlDNLwnA7A/IAqdOnD5md3LVCoLcI9HMjAany6hP2KO5lN+j5vr0jW76+cpBCI8occMUhuVcL5iSg/Aokf3kvFIcflQQ7Qt2VA5j8IiB4zVULKn0ixX+C/Y6lo2EzI2/3A6ylw42TxZ3ruti1rWboX+PZ8x3SQKNybHfe5k9iZD9j5APFwxNwyRclwW3sCdXBLOm5VVInjP5TBunp52/VKh9pNWzlRbMVPX/8eHnIf2NyeL0RSk2z3SaiknaSCeS50D7pLnDSWyLvA316eTy2HAOe9+tyCm8Z+uJQZKnBWozWnJT+4ei8U5hg8Fg8NZ4Jdqu+qTDIstGf4S9PqfZP6QtW7RrhcyTtafINdqh/z4bHm5lEmoYa/Dngq6IDBmL0r66WXRzsEylty+i45RNEKBcb9Z2H9llREbIERf0XU9ZKGI9M701qBaB1URtiyL5mmG79cpQYd4yxxh76Cdagcq5aZ1mHp661dR8jYTZNS1kT9xBLKFows6VeiXJMvUMI9Vfu13ezHiVapu+rPMuAiTWvJBSvc6SvoY6TOdI
 WmFakJgG
 7R29mpl/yGaNOznQiMRLZmH5VuUGLP4wwHZybGrkt2SbzvYXC70Okw08AFtsMaIjHerFP34+wb5auUUPGMapkuN8NnpUbc3CPSAeZ7pVzJ0AiXOrl8PiwJOvJfPqhGzNiibTtzfjfL+ySbg3XdSMGlKUhHm9qJQNch/ZFH3H2MPd5UIchpCbRQwPLIvwTYbgxPeHT5n8h8ApiH0mNy5EHnMyOFuQsrrbe+w/cZoxwMByreHhTvM/bCEgnu8HSfNs4isSTLSanicjC5L9cnXyYLe7FXRUo9oaiMU8biBEYiqBm9z8Q0W6ptF9WW+saGGiz/7bI2xIhilWlT4qKrg9+htn9pxxEkEHLumkWB+dSYhQXncXKdpYKNl+vkvdMM6jcK+tNvFJjnWsTsq8Xm7fY6DsIwijF6viGxNt35swlnIwP15ptvmSFxgL/UJi52BH8a07bPFMeP3Tlt+pwtlG0T+p5bQljj4hlAHGo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 09:23:24AM -0700, Usama Arif wrote:
> Reclaim can spend substantial work on an LRU type without immediately
> reclaiming or demoting a corresponding amount of memory. Record this
> work in PGROTATE_ANON and PGROTATE_FILE.
> 
> For classic LRU reclaim:
> 
>   - Inactive-list reclaim adds nr_scanned - nr_reclaimed to the
>     corresponding anon/file counter when isolation succeeds.
>   - Active-list reclaim adds referenced executable file folios that
>     are retained on the active list to PGROTATE_FILE. Active anon
>     reclaim does not contribute this component.
> 
> For MGLRU, add the number of initially isolated pages that remain
> unreclaimed after both the initial and retry passes to the counter for
> the selected anon/file type.
> 
> These counters are distinct from the existing pgrotated vm event.
> pgrotated records an actual move to the inactive-list tail, primarily
> after reclaim-marked writeback completes or failed invalidation leaves
> a folio for accelerated reclaim. PGROTATE_ANON and PGROTATE_FILE
> measure reclaim cost and do not imply that a folio moved to an LRU tail.
> 
> A subsequent patch will consume these counters for anon/file scan
> balancing.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

