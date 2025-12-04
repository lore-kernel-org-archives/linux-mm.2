Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14803D1D899
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 09:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 430C56B0010; Thu,  4 Dec 2025 04:05:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 408706B0011; Thu,  4 Dec 2025 04:05:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3450D6B0023; Thu,  4 Dec 2025 04:05:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 273426B0010
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 04:05:55 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 252C5BC043
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:05:51 +0000 (UTC)
X-FDA: 84181206102.22.9D2333F
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id 66904100012
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:05:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rdpor7nj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764839149; a=rsa-sha256;
	cv=none;
	b=LNmpS6Tr742ElUl6W3YLaMHo0OdC8oH/z7d2AtMfpYKcfG+QflnqN7Eofv6U9K9X7GOKFK
	cw/9OuyA/Ru0Bhew3pzoGh/OgzTmdNQZpwUNo1skwhSPG5V3MMC4XGGDak1J5tmeAQeDkL
	Wg2c8YW89zIc5HKzbMwDykTA2lNzXIw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rdpor7nj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764839149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nhr4pVUpTAxl8RbNgTq9oKqYXeRZskyCLbxB66PTaTk=;
	b=WvU/GIHMuRiH6ti6jfUe72JqHko3E8+akmPpDZWBv0otTAqqmLasNDWHEokiObqXu5Tj28
	iD+PA84ejppq6r6SHmAFUajcbv3IiCyp8KQuSAEcXSS4z27JSCZEHtrMfFlVQ/jSKPe3SK
	+Vv4Uo8zekKSqEhjP/7BV+1p5E3wdPc=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-343dd5aa6e7so662025a91.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 01:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764839148; x=1765443948; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nhr4pVUpTAxl8RbNgTq9oKqYXeRZskyCLbxB66PTaTk=;
        b=Rdpor7njj9xr6+p9z0E5dgAONDQDNA4wcQ3sUx8fUWZ7l3AjMmyR0NcEkrWUg5q4jV
         7qTweEdFk052vd4IDZ/lHGr9C/GE9KFG/CDTgDq5OqEHNGzHpPBO2Pw8p/EnOEbjnDwg
         luEu9AC3QN4RPMXkrql0jjgsvEq3zg7bcX2yVYwyMU7xWcA+8mUEvRqF/MDvMdI9OCjm
         rJNrsdpCyKUi2c5wi9XGdhOc4yDq3Q5TibOZr17arMrvqAYBOkmK3N7ILXMg163lsn87
         KOgWNMAku7n+Pr7cS7DMN7NJMkUFJ+X8LDobf/vDbk4Ig20JEyAhCT/Ttc3VI3UtfazD
         r2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764839148; x=1765443948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nhr4pVUpTAxl8RbNgTq9oKqYXeRZskyCLbxB66PTaTk=;
        b=C+W4fioh8/+1IB8pwwgXTtiD0LS3r+qU3P1K1P73jPoz1htmFlFHuBhUvuKeC6kpsf
         hJzbas9lO7gNbof+2Y4Zygby9GuSPufrXOyGJBPTKGuHCLBQDJbWpbq12+Q9wTvPkVFR
         brXxYuAy56k7jo0dVCqXP0DujS1j21U9C1mcgqd6aBWwSGGvp4MAQwVNJ3sPZ+C7qtbM
         PDvO8qUoV1OpuBFnSdH2IAuqu/CW5DoR55H/4b1fe58mKiRaNJmpqq8KOcKz7gYFXY52
         xAiCo6VhO9qZio+KM5eLCg8YFv2LWWg9eprXLrSAOxf7UbjT6/vU/9xGeJjU7rVHr3Oy
         RRLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXgfUgmAKwXPxN1wShrf2KpW5O6HQAzvIQ8V0IqVQ1DrSL6+OSs+Tixu3sH1bZ5HIDszB+1YhcQw==@kvack.org
X-Gm-Message-State: AOJu0YwjKr9XeUmhhqnAdxTO9q7y5C4qCxVPORE3DXo3JX9sbSvxVH4M
	3gZbGYM8R85sZ4VP02mtN5q0XNHiut2J7rEOXcYVR/mL9f7iQ5dMaHDK
X-Gm-Gg: ASbGncvhyw1TZR8fzLMVBKwMbZjj3Cb/N9noQwYYH7WrQz7Ai2iRRI44yGgxhU8PKhb
	ideSvGzUyVnL0m6nuustSAxoQkMj+gEx7jIqkeKixNu2vc2xdPGD3OjTAOs8AbD4VuuZNoGE7EX
	C79EfIlcQV2AN8qeAuWXHmS3NL4UkV8Xc9pAMZkXNHpqYDjzhRC9fVinWIibPkzcyHI9hxAgZnV
	t4DN+8UmoLVGhFMWEk8JeiVhnIVFe1jT7z6wcwp3NPZoHsmLNGA4z5JMs80+oUvSuYv27FzOBjI
	7bcIfxe/JZe76JlkBBmxA8aXZwEevmgGu9e0b/1IXpjSP6CSt6HpP2xvsn+Gqu1AxhFV/fzleBA
	O06uHu7su8QAw1sC/9+WRjPR0DUonsZQWWV+jwutajZ6eW1zu1nh1BppbmYAjnCpfJDGUvCrY
X-Google-Smtp-Source: AGHT+IGfiMOtpXgZeBx9rT3HkNo2MRxiUw9kgJxBB5QkRdJyMCEJQCvjFHmL91A7LD+DWBbzFwla3g==
X-Received: by 2002:a17:90b:38ce:b0:343:7714:4c9e with SMTP id 98e67ed59e1d1-349125bf02fmr5458002a91.2.1764839147906;
        Thu, 04 Dec 2025 01:05:47 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([2a12:a305:4::3086])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3494f5a874asm1154929a91.15.2025.12.04.01.05.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 04 Dec 2025 01:05:47 -0800 (PST)
From: Lance Yang <ioworker0@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	chenridong@huawei.com,
	chenridong@huaweicloud.com,
	hannes@cmpxchg.org,
	jaewon31.kim@samsung.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	lujialin4@huawei.com,
	mhocko@kernel.org,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	yuzhao@google.com,
	zhengqi.arch@bytedance.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH -next] mm: vmscan: correct nr_requested tracing in
Date: Thu,  4 Dec 2025 17:05:34 +0800
Message-ID: <20251204090534.22909-1-ioworker0@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <98cbf348-ff21-4c90-af32-b8009c34e5fd@kernel.org>
References: <98cbf348-ff21-4c90-af32-b8009c34e5fd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 66904100012
X-Stat-Signature: y57kxg7hn6j5cdr8b9joyknnhg7zegb6
X-Rspam-User: 
X-HE-Tag: 1764839149-839803
X-HE-Meta: U2FsdGVkX1/HdHD3VX6Ro84JBrIA5L3j3wpQVn46eB4znB1igtHWWrcTCmRdIFPSc4ojR9Ql/+biPx8vAsAZ7KMocxpZq0lSROVl12o24sEwK+yMg3PaQT8qdDhanAMkmke01SZwbfbJaPgG0lHzfzfXplRuz0Xfe8p3nZIioN5lH5dYPkHTvEFEv0h1OSkL4m3wwK98MIsU2ouZLH0u26Fsqi6RhrbGzoqwnR4C+iEMHyo8FieTm9LDh3xtVZsxwHMU+EOYq7ik9Du5EnzQle/kuvo2dqfGMC65ILjOfYLPXqGN71+YEj3Pzb9aKAovoPSoLL6DHpLsQ6L47O1QwztlFo4+MCTqzEXCKQLPrWsoQGio2gg1Icm/N6Cf7WywgSmzI2K//Clyid7XiXLGRerJfldiy+rHxLws9sc0/LbeyF28ytZvW4TpYmq738N8JhFITNOddXcyQUOBM9tNhYkMtArtph+wAv+Xj/z0X2ohqDGvrPZCUYd3ZmZEO9rAHGce7Se9g5s6EDoaaxKBXLPuYmF37hY6xD36q+W9TkJCa7/kylsG5eCk7mdzPlIMB5YqWDm81h5a0fJFgn6rAQA50rjqfT4/Y5WYlVrCZxkfAsrxVaM59TYrlGhbn+VBY0LNSfTt7PYDcVatEKGlLm5GHgukigJJDJa47i3dSr/KgOv7AAuq0wVSG+ymyiOZz6JCaR0JOdOLR7pZiPB6Ng27DJPbqdJsEkl24EkQJ/CWC8bSu7+uCauAt7fl4GCPuxGMM8Vs2dEY2vaGzd1oyqlhu6OBd0EUoyJ4EF6Fy3AZq8Cbe3sIKiLX9UC2LdjhYS7sXfazPtegzgh8CVZrx6eCjr0dI97LeL79M2BxSfbrt7AA0cz384TQnsyHKEWwowRYVSgXE3ny79MjVYOHGJG1hBx6CFkP2+N2oCVD2S7gXFTwUT0+JEavmApEyGVXotM8IaEZmwlCbo+n2Yh
 AR6TOQ9r
 d3VO7Veb/XDyw5TmtZHzNl+dYNnLQGSTcdQ7e5INBcSm4pxKOTvYr1rN3bim4ztbkm8tAT+bj7ejQHBbrNzV1WdHRZXb6Qx8p5yqZlGesl5EGVAQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>


On Wed, 3 Dec 2025 12:33:07 +0100, David Hildenbrand (Red Hat) wrote:
> On 12/3/25 10:40, Chen Ridong wrote:
> > From: Chen Ridong <chenridong@huawei.com>
> > 
> > When enabling vmscan tracing, it is observed that nr_requested is always
> > 4096, which is confusing.
> > 
> >          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
> >          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
> >          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
> >          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
> >          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
> >          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
> >          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
> > 
> > This is because it prints MAX_LRU_BATCH, which is meaningless as it's a
> > constant. To fix this, modify it to print nr_to_scan as isolate_lru_folios
> > does.
> > 
> > Fixes: 8c2214fc9a47 ("mm: multi-gen LRU: reuse some legacy trace events")
> > Signed-off-by: Chen Ridong <chenridong@huawei.com>
> > ---
> >   mm/vmscan.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index fddd168a9737..8cfafd50a7a8 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4601,7 +4601,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> >   	count_memcg_events(memcg, item, isolated);
> >   	count_memcg_events(memcg, PGREFILL, sorted);
> >   	__count_vm_events(PGSCAN_ANON + type, isolated);
> > -	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, MAX_LRU_BATCH,
> > +	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
> >   				scanned, skipped, isolated,
> 
> We do that in isolate_lru_folios().
> 
> Given that we do
> 
> 	int remaining = min(nr_to_scan, MAX_LRU_BATCH);
> 
> and effectively cap it, I wonder if we would want to trace that capped 
> valued instead of MAX_LRU_BATCH.

Yeah, since we explicitly clamp the work at MAX_LRU_BATCH, the trace
should reflect that reality :)


