Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64739CD6E57
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 23:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3AC06B018E; Sun, 31 May 2026 19:29:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEB646B018F; Sun, 31 May 2026 19:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA026B0190; Sun, 31 May 2026 19:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3AD6B018E
	for <linux-mm@kvack.org>; Sun, 31 May 2026 19:29:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C4FAC2176
	for <linux-mm@kvack.org>; Sun, 31 May 2026 23:29:35 +0000 (UTC)
X-FDA: 84829309110.19.864F986
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1DEEF140005
	for <linux-mm@kvack.org>; Sun, 31 May 2026 23:29:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hIbGqVWp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780270173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQRXdo9YxYwyrzUF+NcSdzn+gwHEuyRiq4J1P14JkS4=;
	b=Q1abdqcsTckNK0JqAbXybpjA9BEbnNjeOVCeEaoLqjB1IhFVUUMtLV7r/ys7v0DJY9S3SM
	ZCMC1wB9KGHEykD8TaIBCA/s5oWnYiDrRhr5oQ5ySoqe9e21CG7sgLzea7b67wTLNiicsq
	kJsZ3VKrw6jnnvTlm8O8hS6eThvRrKQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hIbGqVWp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780270173; a=rsa-sha256;
	cv=none;
	b=KtYrbpCwcDjn74pEeMINkBgbLhmzOggvRaCCVPq+MpGZGxr68JMiKakzREBGLzJ6kxmxke
	V0PGDguxLXFzM2qFa26kZ7JxH++uzGm0IZdyheo76xD8/6hGdNOLVgobM5gCren2Cl/EOo
	kghfJ0ViuS6zQZS/JpbzLwnQxcImf38=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-45eeba68948so2648582f8f.1
        for <linux-mm@kvack.org>; Sun, 31 May 2026 16:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780270171; x=1780874971; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hQRXdo9YxYwyrzUF+NcSdzn+gwHEuyRiq4J1P14JkS4=;
        b=hIbGqVWpoP0Dx7IQvWi9kGzjuXUFip5CXJwYSFGDfZBB3xlq25lXW0wQ5UN3efCs+o
         vXzKnFFabU9NbjDUJgfccMofd6Bco99vH+4QUO7qg1JYEZRGThWlbutj+LOg/EI/ggDD
         7xPAw5fXxEF/W4knNbNolybuHI4y9ClMAT+Bscf7AkYTb/uT7ppUouggVquDOpzk4n0J
         UxRO0oFGKQIUinIJQrObkkKXmfnV5MNm/CtABseMD/uq9cl9vdbHTczGMh00AgSotWUs
         pCx0wbpyksUmWpmTma9sE+uSn62RrE44+tfI3yyttypr7cmyWmJd9+GVDhmTA3SWWc2L
         zssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780270171; x=1780874971;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hQRXdo9YxYwyrzUF+NcSdzn+gwHEuyRiq4J1P14JkS4=;
        b=LVRwUZgdRzJnNMzI+KROg9eh4D954wNaZLo9MIv4kLw4fq2pKbfRIZzGSwf9COjb1s
         yjcQc+Gh/KEkOHgbdbhwcZ+T7NvWkmSA/xU1h3fLjM9txiCurURB/AvNV/U4e5p3sW61
         BbQvVro+cIHAKDkrn1OxXMBrchcecnj9SntlG6PLjvZAV0JNWdftOnGhWi4YLGNWf+FZ
         YSVic5OwTHJmL8qEZm3tZ/sKhO3Ghaz4qBljyBZJmLGy3ZJ1Vavv2PLa+pFq6ABOgkgV
         xff/UHCGOG4kc+t+3zzb/5s+5iyN4aoOELI9p+7EgFHQ/yKNhjcGbzEqvdRsmKU5RqJq
         m8pw==
X-Forwarded-Encrypted: i=1; AFNElJ/ZrdnuX3P021FT2tPP0U95SOxmGMEq/6EuFWSdflv61NJ5xfqOA+OTW1VTY/adHKuHoa6W69tIXA==@kvack.org
X-Gm-Message-State: AOJu0YzQ/GancXzLu5er6Saat04zebd/tCzYOlWCsA+Q3TMMsEztRbPO
	Lc82crmY9W0tz6X6wFwFvkcWyHRZyLj2d4UHfz7hHj7EBqOxK6EYyrZ+
X-Gm-Gg: Acq92OE64djHks8UQlhhN/BMw0Wbw2OVGcO7cmuVmodGkoNMh4DSjtguP+NCX8dY5F+
	fq3WHfWvZEirQovj//GEKcPgEQ1uiavsI+Jd31c136Lil8gwoIX+p5WUcrIUrcrDH3r+34HG58r
	oeOgyqMf31/+s3OZ6lYAUrzaiahRY1CW4sUTt1T6Wi3HkgzknpIfkmqyzwCDznUsMkL1xQ09Gj3
	+BRvAs92kqkZEpwIhA1VdBkXpxwboPX6tZr1DnSL8fDuBydX1AC7zHC0pD/7eh3QnOvfEHchy4U
	De9e0L5K9qRW9uIJhOP9Rv9pyh5XDaTgPkJavNK05bw1DDrQWWDJLX4aImxgZZK+7byUeuG6/Z9
	XGoRVJjMC9qLKpekqCCOivcJlA1uAC/M453Jy4v5pH46/y9n5QJSnWfWCsQ/LddJjgmXfU98Ur4
	OXYRB/ocucbwMWv3r/gfG9Jok+QS2B+XEY+AJNZNmujPapIOtL7DS1EKm5cPrTS789zNCJ3/sC0
	Ic=
X-Received: by 2002:adf:f14e:0:b0:43d:7d24:b510 with SMTP id ffacd0b85a97d-45ef6b5ae44mr11062126f8f.22.1780270171265;
        Sun, 31 May 2026 16:29:31 -0700 (PDT)
Received: from localhost (pat-125-253.wlan.net.ed.ac.uk. [192.41.125.253])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef354bb7asm20512971f8f.20.2026.05.31.16.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 16:29:30 -0700 (PDT)
Date: Mon, 1 Jun 2026 00:29:29 +0100
From: Karim Manaouil <kmanaouil.dev@gmail.com>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: abuehaze@amazon.com, akpm@linux-foundation.org, alisaidi@amazon.com,
	blakgeof@amazon.com, brauner@kernel.org,
	dipietro.salvatore@gmail.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com, stable@vger.kernel.org, vbabka@suse.com,
	willy@infradead.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order
 allocation
Message-ID: <20260531232929.mn6f76yrnc6e4cpf@wrangler>
References: <20260506123326.17293-1-dipiets@amazon.it>
 <20260527162412.19922-1-dipiets@amazon.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260527162412.19922-1-dipiets@amazon.it>
X-Stat-Signature: hxe1p3ep8zmxxozbo5kbmir9q8b7mbgi
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1DEEF140005
X-Rspam-User: 
X-HE-Tag: 1780270172-811276
X-HE-Meta: U2FsdGVkX1+nz/Zm9TVLPLF7B/Sc1SfOGKL9bFROMLAA7JGKpp9EgP9tR3LA7L+nKAYdxpF91uGo2QS3Kw3GQo5oIVGFyHUdbdaECV2j/7mYMyyRYRira1QmMRr6O9pkPnKmWMXDQ2FiOGufwDy72c+/JBgJ6qw63kJh6jS/rsjFMi4cH9nBWmZNpfj2x1ZwJFM0K0n22Tbk1wg0kcuyjpFQjFMPfpKmnVhlf/8LcpNggaxSDe5d0g7eIJOrrCRb0BCoPAM5z2IQCxO3ex2KcI3/vLJ8QGDOp2p6BH1OjgNsWvwlLKsZezV9kai+H9RLz/6YHfF8uWV0dcMY28o5iwPh8PY7I1o7JNsAVzTT+y7hbScxszb6KHHHU70IHxi5uN9e6DszIqiy/lxYNJgu/L74QMW/oDG1/rY7EHIKc1LZrG/4cFYYLcURU7MXfk+1gFeBLiBjee1PUwSxpSPidUH5e60Ta+00H8pCuPkdcEcvB+1xVj9sGlTkw836BMdz3OWEEIre/0z0BjIDwpaNccKVrqniD+B/kBwQAukhcrHLtJLJXTCRHugHzCWOwkp9kpW1SHiLurL/Aa/4ursbZwQzlBvgtvifiRsoCcKo0W07XClAfwYBNBrb/1Z+PnTEfsn+QHK4mlHCpMEna1ohereQ4S4+GqFr8wOJXcYNRsk0LgmLTgaY3/9cbouoau1YiYIeftaduVCZJaLYPFSQnNhJsXUnrjbanp1mduavm3meZGMleaqY/aLZtLfV90uvmZgVIrEyRHDIxkTk+fKTGcb3Kn1ceqDMcGr+PwQNefwxKadQwjKSkvGYqwMUfVSlrpE+KcfEnEp3aggsujeZNEmqas00x+Voj3tzdHIedh0LOVSO9bqu8566l587sq4AgdMQrPFsBNNIMF33A+ZKoEBnb+euinpUWErSyLMTwc0vrojIBQcAH3lUqY/DUlEOD+copZJe96PHC7UWE89
 yZ/25NOh
 XMLzRUckbZD7cScnD64uF2FretWXNc5xzJ0JPbJ/X1MGLhIpM9gFYdSybQZ1aa3j+0bkO6ErzphbARb/Xj/M7UNv+0WTlKzDrRCznAOaKVrRyIUUOvxzCejMAJz0O4f4NWsRqXSAkZtruV9SLPw8FSea3tCw0Qw4A1ekT70uEFjCnXpSOuZHcxPrrSCyLF/NN1cREaSPoTCwVf1HDYvll4a4PK7Aobw2NMJ+NNMOSyQre5yr+wE5pcvPEds83B7KlXdw/avcGshpfmH09XOq2uBoOfoTX+E9P9CBg3ieZV97aNHrFQZUrDdZSfxBW0F5M6NChpYo1k1btZFES419w9ZNC8unU5nXZvo4B+0lp3EzP/uxJ3ICZ1qmj7zu7qboHZYbzeDNGN7lpOT4qSMokO88tx6NA80G4BSpwVkP3K3znjrUqZPXSvobRnjbwKquNhwyPWgDud53qo4fvPABIP8ThpRpQqcjz8VTRHap5SMpKmJrqPm6Lg+v2p5Z6quObtHsEMwV0NrRqOwFrgMu3ceMcnHAAvE2cQuNc7BNnsdRrH3QKEqMu/cqPzI4l/GXWoPA4i2FOWpOs43jj1UK72jDO/4HeCekWvOShMG4Myi28dHZhR0z/eJts/AsGwe/7js04
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 04:24:10PM +0000, Salvatore Dipietro wrote:
> 
> Thanks Ritesh and Matthew for the continued feedback and guidance on this thread.
> I'd like to summarize where we stand and ask for your input on the best path forward.
> 
> Summary of approaches tested:
> We've now benchmarked all proposed variations (pgbench simple-update, 1024 clients, 
> 96-vCPU arm64, huge_pages=off, PREEMPT_NONE applied [1]):
> 
> | Patch                          | Change Location       | Avg TPS    | % vs Baseline |
> |--------------------------------|-----------------------|-----------:|:-------------:|
> | Baseline (no patch)            | —                     | 101,979.75 |       —       |
> | v1 (original, iomap caller)    | fs/iomap/buffered-io.c| 141,194.20 |    +38.45%    |
> | Ritesh's suggestion            | mm/filemap.c          | 139,200.61 |    +36.50%    |
> | Matthew's suggestion           | mm/filemap.c          | 143,863.82 |    +41.07%    |
> | kcompactd background           | mm/page_alloc.c       | 134,278.47 |    +31.67%    |
> 
> 
> All approaches recover significant throughput. The kcompactd approach (background 
> compaction and returning nopage for costly orders with __GFP_NORETRY) aligns with the
> architectural direction Dave and Christoph proposed, keeping compaction out of the direct 
> reclaim path, and lives entirely in the page allocator. 
> 
> Based on the discussion, I see two possible directions and would appreciate your guidance:
> 
> 1. Page allocator fix (mm/page_alloc.c): The kcompactd background approach addresses 
> Matthew's concern that filemap.c shouldn't know about PAGE_ALLOC_COSTLY_ORDER, and aligns 
> with Dave's vision of removing compaction from the direct reclaim path.
> 
> 2. filemap fix (mm/filemap.c): Both Ritesh's and Matthew's suggestions are minimal, 
> backportable, and preserve lightweight reclaim for non-costly orders. 
> Ritesh's variant differentiates between costly and non-costly orders, while Matthew's 
> is simpler and performs best.

I am not very familiar with THPs in the page cache, but for anonymous
memory, we have /sys/kernel/mm/transparent_hugepages/defrag which
decides what to do in the event of a THP allocation failure, whether to
enter a synchronous compaction or wake up kcompactd.

Check vma_thp_gfp_mask(). Maybe you should adopt something similar called
file_thp_gfp_mask().

The problem with fallback is that your application is never going to get
a THP and eventually TLB pressure might actually end up slowing you
down in the long run.

Also compaction is only really tried if it makes sense. That is if
enough free memory is available to actually perform the compaction and
have a chance of creating a large enough huge page. So compaction is
actually never performed under accute memory pressure. Which means your
system actually has enough free pages, but somehow the compaction is
slow and inefficient.

I am just trying to think loudly here and address the root cause. The
real problem here is fragmentation due to unmovable pages, probably in
your case the page tables. We should work more on reducing pageblock
type mixing. Also page tables can actually be made movable so that
compaction can treat them as movable pages.


> 
> Would either of these directions be acceptable for a v3, or would you prefer a different approach?
> 
> I'm happy to test any additional variations or direction to move this forward
> 
> Salvatore
> 
> 
> [1] https://lore.kernel.org/all/20260403191942.21410-1-dipiets@amazon.it/T/#m8baeeaf48aa7ae5342c8c2db8f4e1c27e03c1368
> 
> 
> 
> 
> AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico
> 
> 

-- 
~karim

