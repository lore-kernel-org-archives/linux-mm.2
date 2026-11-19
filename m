Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BE89606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 02:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=IhXC76BP
Received: by kanga.kvack.org (Postfix)
	id 7E6256B0656; Wed, 18 Nov 2026 21:05:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76FA66B0657; Wed, 18 Nov 2026 21:05:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610296B0661; Wed, 18 Nov 2026 21:05:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 249B26B0656
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:05:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A207CC090D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:04:56 +0000 (UTC)
X-FDA: 85450225392.12.9CCB76D
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id BAF8418000C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:04:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=IhXC76BP;
	spf=pass (imf24.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.216.52 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795053894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kC+uhz3Afjp9Cqz8zh23wNboDVMQQa75pZ1niNRa9cE=;
	b=rTIXmaODiAiTy515tRspU6z49z2Tod/hgwkZY44mAfJmGd9kErTVMXjV8wE9zwLOomJlZR
	n/qsi/GPoZOqcN6hzbkt0O5mSlvunRWGH2JZSpDGxxkcnJXCzQ2wrd516rjgOyQHIoX4pE
	DIEvdAgEOOBp/ag7B93euEUKlEyhul8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=IhXC76BP;
	spf=pass (imf24.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.216.52 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795053894;
	b=oGAJVAe1GN01E9JUdjidbmSdiGTJN4DSljGcAqGa+2fhruBblOISrhIYbXNF7BAnt8tLsl
	jRRJ/IJPv4EBudPb4oKoK+4lMXMDNY2wb98F25p3W6JjVnWrWkLdzarEegiF4lX2tDPtV6
	s18h8802bZs1CHTgwTeyp5jQdFv8lCc=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3b3fff0d993so27989a91.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795053893; x=1795658693; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kC+uhz3Afjp9Cqz8zh23wNboDVMQQa75pZ1niNRa9cE=;
        b=IhXC76BPQQuG0rrXprO+llDkZAB79MPtTuJ3aZ/08wHQ4iHe+qoxhb0iUuoatLOFfh
         0OSxy1EthRPGEhvXxnj8H8vwgMNa7VBdC0Vu8hMZ5nVUqJj15XosnTAfILKikEffNd1r
         S/Bnh2WYwKajoptk/3HJ4VDPJiLpzRBLWLAEw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795053893; x=1795658693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kC+uhz3Afjp9Cqz8zh23wNboDVMQQa75pZ1niNRa9cE=;
        b=Rt4ZieSyByINQsH3soIKRkboCCX4n/EZtbFZhXtB99TezwHrhSGJHwzwP0P/DRUQ5T
         9yXTU4EZb3O8k8lN0WG+tLRRe+/KSfgMraJXTHyxDaGVa8AsCfPitCXn20L5zmnRHDNj
         Y9MqbL7GJK22ZzSN8bkDZK/DVQXxUqNgtrw7k0OQNWaX/qIWKvfNu+0ahH52H6ItvaNw
         ldEj7eNVo7ZmT6IgVwpW1moF+TtiEidHQNj3CGcIFd6QP6J8ddetNz7fTXyDejKz3c3U
         hxVaPShOCmG4qln666Kgcy/rGe4Vo/sdTUIzHBpEZ3FVQtYjmNtbpsuWPxjJVv3YUQ35
         x/IA==
X-Forwarded-Encrypted: i=1; AL+hErHr3VJdu25H5IXNBhr82m2RRnXR78/V0zlR0bljsxpuj2kgRtFWKGI2B2xvqpBBOOxcceSHT5hSBg==@kvack.org
X-Gm-Message-State: APuU4Z87ky8HAYJRNfiSaSxHysIEQzWfrwY6n911e99aCVFqguEpw8/h
	N+uxKXFgjKxwpG2Mi8fjgHDJJc0PvGKoG+6fCLJL+1m9Pd6cjKUkPZ9XnGI78GLLzw==
X-Gm-Gg: AZFdTZdG16zY6xBoMOahrW583Li/g7TmQYFaypVC8yInAbwQuJi5oSLcvZbR9eGgoP4
	ZIR+wFEod9hom658AO2YHYp9+G+YLEbErDFdUPFqhzt08UPtsbmgAvNb8jO0+nC/RqCzrDeoFBp
	dcOqs6+VkSjaKd7mlMsZo/gVkZ+RaWQVTC7qPYUW3pVoPb9PP7KlpiXDylNoTAJM2lcJzAqq/K1
	TVvS0ulIyRAgtBDrn+3ZeZEK+PnY62Q3N8GTNar0pX3aRz/BSgydE9P+Wpi9dgVMaQ0PTTitYNy
	9O9xCyewI2EzG1bNAbcpxKkQFnuRGpqNUWBQ2uBdsWvbDV/4wQUXmE1KRGjc5qGQJV11lOOZB/z
	tdl/L6lU1itiKzperimNZRMyNfBx5educHm7SdMdcEH2NmP4Kh0jz05/X2/sAQIORn0Yog0RPwe
	oWZ7L1Jx+POpAFhjvW6m7TXGdJsHS1f03GrCVFqMP1PGXFnIfAZnePgqRFT0h7kuQMj9VG1RzGv
	Y8aZJi36vt0aS0HEjZqVd+4ceo78KCn08z/rlAziY5q4Yn48EEYzVM0trc4MaqPIldGY6ciXum5
	SBBcXheIAOvwthkyPlgopa5+R+rmLULPUiybqaQe1P9DqkdU16uDNwW7f+SvZZMLQS+I/g==
X-Received: by 2002:a17:90b:2805:b0:3b3:c92e:f523 with SMTP id 98e67ed59e1d1-3b3d0764320mr7560562a91.3.1795053893354;
        Wed, 18 Nov 2026 18:04:53 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-3b3fe0e5bd4sm772079a91.17.2026.11.18.18.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 18:04:52 -0800 (PST)
From: Jeff Xu <jeffxu@chromium.org>
To: David Hildenbrand <david@kernel.org>
Cc: Jeff Xu <jeffxu@chromium.org>,
	Tomasz Figa <tfiga@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Marco Elver <elver@google.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Ian Rickards <ian.rickards@arm.com>,
	Jann Horn <jannh@google.com>,
	Jeff Vander Stoep <jeffv@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Kees Cook <kees@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Collingbourne <peter@pcc.me.uk>,
	=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kexec@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/7] mm: kasan: skip KASAN for GFP_HIGHUSER
Date: Wed, 18 Nov 2026 18:04:45 -0800
Message-ID: <20261119020445.1096831-1-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
In-Reply-To: <332f315d-ea27-488a-9a3c-28cdfdcd5f27@kernel.org>
References: <20261116230627.3537051-1-jeffxu@chromium.org> <2066d131-f999-4747-beb8-520d5e0ce1db@kernel.org> <CAAFQd5DzTmyeVQxNdhdy8pPi+ts1cCgbztVJiMoNBeJWBzjdQQ@mail.gmail.com> <20261118012858.289236-1-jeffxu@chromium.org> <332f315d-ea27-488a-9a3c-28cdfdcd5f27@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: carzcmwb5sfshzqg48xzwfoga9hpybeg
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BAF8418000C
X-HE-Tag: 1795053894-139326
X-HE-Meta: U2FsdGVkX1/ut5hu3gpeip1rveb194r/X6I5TmiMxKQowm9ABh9fqHpDerRGNtrCN0XRsxfEPUNjEw4r9EP1i4pSPB/HaEAfwl5G3UcBPKQhDRj5WlY6nrUNt8pEpQJsLs8AirvkiNx1cHeerGryp7O4TshuQbYPHhneWHAFpLVNEp5wsiiDq7uBVlts7O0gZv1aeP5uCWavHcfZiR9Hmk67vwy4qw1EkiC/3fsVXrcrmAgPAafJBH9lLSv+0BOfwUepcBJtu+9X94XQxxSDHCthCeB+YWLLoZtGsvlUdcO02E4LHwYLcMSR9qfO3aPcgiHwTbklsjF3mC3TVcfi2Ue+xiCx3BoRh36+cGzUFVb19Zh1f5xnQOhaFf2gK9Y8n37vAIXHro4rQ9oBCznvUiNxQ0Ehg+wFhso4dJypG+2MZOfYDTWzthOlzIE0s7FLnXf7cCm5rjuXTJAugjVWdghkPu8esZoP49K9HKNSeOs105v0TORdwGENMa+ilm5Wib0+JLml8snooIYntj0vm3NYSvVeBLgplxyjMY1+AbttRnKTikFQl3ciXMVkOOYiZwFHxePiRN3kQvjUmtfyOq7gDoNykdNGsohwQW6f3T5iNk9+gb0/LIXm2kTskUPaGYn+Zf3DlMNHEXd2ELjGhifmr9PHqNO5jLL/0YEXPBe7xdHe8FoC85lPG4i+RRpAQq+Djm+jrLCB3lobFt3YwjcLN1wDB94AJy9zTaXterJIAM/aJgT/RvJBlFAoSle1FFHF/zZLAAlJc6HjnU/QYbGTpD4vOSXgnJzAF07Bb18fwGohsyzbaLHaSutuGXTuYfWUz5E9kRMKt/CdsFSa6Is0MJhfnfIdeEFybJawwNAwW5X2ZTayiaplMWViPsn1AhG4wDfLtvMQ2ihhm6q9p2VYHBYL1MQwIXae/zg+C47Vs3Oo1pSbBuWBuFIEwqXE0T0mJjsFsjzWmf0wGTS
 78MRtxsD
 rVOsEIVOt/j54s7ZClI3areSvx4rQr3KQM9rAr6fe/EFrtxsrpqimD4fTFdI9Tib0n3EiqD4gsLGcrbbsjZ6TZQHZfqORLS+B/Vmr/Z2dsMmI9eVXaQ857svkOZaC6vrZaPHThXfwKIqQ+jadYfO0SKoyUrm5NyE1r3MpUSun9DWj1WPU/Nocb9Zm/yMhWJL32Sat4BjRSuarufaC3tZ6d3WyILkKqRPLTdqxuw+HJi8kK16Mrgi8b0PqM6nsoBsHqtyyB7m70+F/3TSJe1JiVxqiUFUWtQKSg0s2FZqCvmW2N0XUwN/xTBt/Osy4FS0VvhDF/y/0JYPQbhuZleV+Bpwsd2sWjxY2UVxbcOo9BEz9oLj7K6AzxuWcCKa3P68jhZrJxP1Q6fh2i9skUWxM6IwivhPKe3iObrq6VV2D6KHpuBk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 10:46 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
> > 1) Simply keep those 4 cases under GFP_HIGHUSER (drop patches 1-4 and
> >    7), reducing the series to just the GFP_HIGHUSER change and its KUnit
> >    test.
>
> That's what I would look into first.

Thanks David. I'll wait a few days in case there is more feedback, for
example from the KASAN side, and then send v2 with approach (1).

Jeff

