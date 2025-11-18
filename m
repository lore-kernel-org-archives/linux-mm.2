Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F8B5CEE347
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 18:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB7486B0029; Tue, 18 Nov 2025 13:24:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8EC56B002B; Tue, 18 Nov 2025 13:24:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5966B00AA; Tue, 18 Nov 2025 13:24:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A7F176B0029
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:24:59 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 501AD14012A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:24:59 +0000 (UTC)
X-FDA: 84124554318.10.1C6495D
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id 79CAF100010
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:24:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VRx4ZkaB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763490297; a=rsa-sha256;
	cv=none;
	b=OSWIEkOT5yd+YrryJU6tImrm+yyxTQVg4mzOB9rUTQWKe04Z2H/FRbKRsl8rZjaI85CSXp
	TdUT4muf38egU8fDXc9Vz3DjOiW/4dXxM17nL9VlgrDen2JtFibtxhMZcQifnO6RtRt0SK
	IGPcFra0xzQ5s0N4hFuHSfGtTki1oK8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VRx4ZkaB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763490297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qQnbesnerSB3y8ncBb71UjE8VSNcMr413GQOdybdeUk=;
	b=ENYRwWHrwZxanFs1eMggFGczsslNvaOepSvDgZiCLXuZzzuEtgIZjCt9yh4xVOJkbmXyGl
	aW/kmU+LfTjHkEtQOIATqnHrJlUa6SAimZyIVVvaKgTAOiQMTEkK95kiJPPDW/P7NhkVK0
	qhxJ2znJ/LOQdS46zb6Ocez9lCdlj/M=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b98983bae80so4330364a12.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763490296; x=1764095096; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qQnbesnerSB3y8ncBb71UjE8VSNcMr413GQOdybdeUk=;
        b=VRx4ZkaBK6ucM4dBSP9gh6lymCNquZYNBOBNFOo3LHBes1mE8fTKoXHuGVypbU6A9o
         7pzP3xNGRkthbTSnCPFUP65ztmGOLvlmD5qTJ5bcfmKUAn9aqzw3Vu2SWkJpnB6VPBhT
         fEtrt/Y63Y9j1LVIU0HRHbATVEhJxB6rK9tnNvP5uILoxGJqtN0obEnHaV5vQPcJdq19
         NNym5PaWi4aYEn0b4/syXNUJVD5/5t6T/dGAoxJhhBvlcJ2p8ffI7XN3BTA3Jby2YFMT
         Ap08Ni9BZ6i6edoEkEbTwhkRy530vjPZ6rQRw5ZsmYQukDvQfkNN7d3dBd8rLlvX/B6W
         S3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763490296; x=1764095096;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qQnbesnerSB3y8ncBb71UjE8VSNcMr413GQOdybdeUk=;
        b=tj+pGXl0iuOgIjlekGRH6prSfVIAhm5mlqqwHsTupBNrP+O52qi+Xscb6E4nn78ZDf
         wUEK9RQ+kHeX/Uis3/90JoAieDQhI6ag/PeMqjOYwaLKbroXHQcQDAdpuFvhoUnEdXCd
         vn12LmoNiTEIO1b5gn+kHsIVHJtjQSaTBCLXJ9ElXtrGoa/Db/zpcQf/k8CZFBOdl4ju
         2bNL2DyQkFZBrpDfZlAUgr+Eb9/VDBGI2CaTJWyDlfYm12YqCWB5P+MbxAbPKG28YH/R
         rdXOPwiO8oNCdkcSiDACWZdG2NcoumNusF0LbjA5v93RcEua7sbPeRCJzM6dHYwamozE
         WUVg==
X-Gm-Message-State: AOJu0YytlsSfQNVTEZ0rjJDYqjJhkdXIYiGrQzfvtCxmQRXU31KCzioP
	LN7Wbnrp6n3B5lzBi6fpYmyl5ErdHRZs8Dfg0WQTyCtQCUrUhrE8t+1m
X-Gm-Gg: ASbGnctosrYvvvUgK6BkOqwCI/Z3mGoLyFaq5tKB2eR8o1nCqYKcu1HqzV3TWkl8Ur7
	OG/Mf1Jbto1Shy0iHE2rMTjVFzCJVAZJ0j3ySqRXqye5sPSLRpktYs/u+6k4GkrUQuSr2YH3cMe
	iM+YF0C/bOC6mp5d3ZbDABUHbmA70Msz5WGZ/4J7X9CWrxQQmxXNDNPwNVZHVIyQzTB2QW4mZb3
	8ptZY/K7Ldr8csP6KAJGmjVOFq3tLX0AN774wp58I681PtfHCE67NaFcHNv7Mvun+VSwRmV9B6P
	fdmpcS/dX5NppIoZsbLwqrNYx5lK2NzNyqbKtOfYD4kdyRJKt9JaPDRBWHyaMhwyl3mULYfV4eQ
	ltnbSxWqcFmRSqo6SbK50fPBimULRJRa1BF+qhApDjh/eIzxS7eFUddZUpipDLE2Qd+bV83wbKQ
	PAXS2Kj/5ecMcwc2U+7wfrus8ardIo63XPPxMDFRSYwOK/hmb2i1CLow==
X-Google-Smtp-Source: AGHT+IGwfbVhXHE8R3bzrvjEiLi7UupUZzru266g8XK9la08J2rAiSGe2vSV7F6eALZQGQNpotvaOQ==
X-Received: by 2002:a05:7300:f48c:b0:2a4:6bb6:c84a with SMTP id 5a478bee46e88-2a4ab872881mr5179746eec.6.1763490295984;
        Tue, 18 Nov 2025 10:24:55 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a49d9ead79sm78252515eec.1.2025.11.18.10.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 10:24:54 -0800 (PST)
Date: Tue, 18 Nov 2025 10:24:52 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: "Preble, Adam C" <adam.c.preble@intel.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Understanding profiled tagged allocator growth in a stock kernel
 that's just idling
Message-ID: <aRy59MtQ6UtauWrQ@fedora>
References: <PH7PR11MB652386A774115119B0DC7B38A9C9A@PH7PR11MB6523.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR11MB652386A774115119B0DC7B38A9C9A@PH7PR11MB6523.namprd11.prod.outlook.com>
X-Rspamd-Queue-Id: 79CAF100010
X-Rspamd-Server: rspam07
X-Stat-Signature: 5zqgfp1cjtzc9d6nuf6rtarniswaeqpp
X-Rspam-User: 
X-HE-Tag: 1763490297-619440
X-HE-Meta: U2FsdGVkX1+v8F4js1HL70i1uSf9tFdHFOtrKfVtbveCAwG/WCtEIGR2X28zBoUGQxkhO39KND9C0EawvrO5sbCFvodAhOzzMgzR0AZWq1czlDi9KsbFga75PjdLK4s4MSjehJTmWaXk0Dj0VzUnMb2gH9g8IppJh4wXQN3wS2uww3Ij4WTjGyyWM+cXh/sHjldAdRn+BRc8H4x0IaaOv0Myka5PsJ8aOrkktTx8OwGI2U0bN3bMOcQxbUZPySVp3N0hWnMHVvihgxBUNgTxfY9RbSvhB1p3Ab+Wh5jFMzTMLpWAvQxcAKQeVeZ5KSY8rvJkaAUcnBhCjgNk2F/+A85FkqR5FUcRgj5guJqpx05Jo9ovJkFsiZdhg2j4YvJNdHpkN5aVWIUB/6R0FZdfwva361iWHpwOJsq1Y7aG0BV699twGHcdqL8tAWy6BvPyWReCpD5NyUQ2iWQTn3fG82sod9rBXUl+/m1s/Wimw+nbJkV0s2uccsxY8vqzGqtucmIRUVQ2Uo+etyqxRCD81509xO/txIIbNe72FS8nqrUZlcZ/J8+zV13K6OoityjOzCLlZ+/NY75Oi5vFPIL1hZfmxR4fKrPmIZiqmuGttWgudCLoDJWcVR0E35Qzy8tM1y5OnZoq+PG4XdXVn+4ChCPuDVLHlF6nrNgojs3RwF2iAUMA1ue+QuKXeY7qsLX3JRBFPUUVEUjhkCWhuwcXa1bfQFCz5lSFvgUOaaHUG0hKF/SpMsxHI2BNGMaB2K+a7sLQ3B6J2EkYcARsO7eQxy7l0EAaWE+1o6NjDhvUgXeawE7w4SnalGVnUnRkc/dUHmJGgLK6oriwRMX55CRmU80Zb8/wPOSM3eXvYBqJV7UiH6xy+lm1geYmgIxu5IGxG+AeSX43e8yeZmnDSRskBHV9W3Kxfm0AONu5hQD4kwJ6FmKI5Bpj2gFnWrjQtFMhBRH9vnGARMoz1Wa+T2u
 2avjpodk
 pGvJukqK18U4brhFWFFGRYldV71pt9BXGUdJgU+Ewt6K8IT1+3i36DFJBUQvPEH4j1nqUOMQZ6lcP+0ZnbyyZgKV5uBuXp/GEBd4Pjp9MjItbtcJ1q65hr4ufRMDQyWTzWeBUYO7Oyw2el6RpZ0t8/f3LUdCE2LYFXDI5TE1Pe1hRQjAOyFBKe406OmqTJZGxqafrx4rIioKX4xWjqNWSB6Dt8juWbrtQ7u2fEMPZQOmQuvJoS1sS1dwMeP0Z6ypYQaL8CrTYO5/yrWq4lnDvdmwxA8WtUyaNf+/tzMMKGTdbo4YMVsUb2BD3FRl9kNIjeyu4BhjKr7ZHCIaJpcbpNboLqHqrrsl4gbcVLuz+EMNo2zapRtEztnpIYb6FXcukQAqCpy6YHD7zQpMsKo1whnSZpF9Hxy7u+yL8S8swObLix2Qj9t/tz6ItPJbTVd5RtsMkC6quaphKJ4ooNYZKj43kYQ7m4m8c1RMXsXKsGQSig4MHDqGb96uurvK0geKckK0HZmRuVBBUpdwN698ZK/Hy7jG7N3PqbkzR8lpvQMBjYcTkiZouEyjg8Pt+M0pEAG2U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 11:16:51PM +0000, Preble, Adam C wrote:
> I had sent a note to the list a few weeks ago about a situation where my vmap_area allocations were continuing to grow and I couldn't account for anything in a kmemleak report (it was completely empty). This lead me (thanks, Lance!) to enabling CONFIG_MEM_ALLOC_PROFILING=y. I then saved /proc/allocinfo before and after my workloads. I then used a script to collect the two reports, determine what grew, and sort it by how each tagged allocation grew.

When making referencees, please link them. Especially in cases like this
where the subject line is different from your first post[1]. It makes it
easier to keep track of discussions :).

> I got a bunch of suspicious things, but I couldn't trace any of it back to anything I were doing. For example, I tried to collect kstacks with bpftrace by kprobing any of these functions I could. I mostly had to get near them because a lot didn't have direct trace points. I haven't tried with manually-inserted trace points yet.
> 
> After multiple experiments, I took it back to a stock kernel (6.17, tag v6.17 commit e5f0a698b34ed76002dc5cff3804a61c80233a7a) and just let it sit idle for a few days. This still generated some growth:
> 
>     Growth    NewSize TagInfo
> ============================================================
>  676085760  820760576 mm/slub.c:2492 func:alloc_slab_page
>  591151104  672784384 mm/filemap.c:1981 func:__filemap_get_folio
>  528635360  532319824 fs/ext4/super.c:1384 func:ext4_alloc_inode
>  187793408  325976064 mm/readahead.c:186 func:ractl_alloc_folio
>   95700288  103415040 fs/dcache.c:1690 func:__d_alloc
>   29970432   63787008 mm/slub.c:2494 func:alloc_slab_page
>   20316160   39485440 mm/percpu-vm.c:95 func:pcpu_alloc_pages
>   15044120   16415048 fs/buffer.c:3025 func:alloc_buffer_head
>    3116224    8994768 lib/xarray.c:378 func:xas_alloc
>    2138208    4317472 mm/percpu.c:512 func:pcpu_mem_zalloc
> 
> I don't entirely know what I'm looking at with all this yet; kernel memory management beyond kmalloc and vmalloc wasn't really on my 2025 bingo card. I only listened to a talk about folios after I first saw this stuff and didn't know they were a thing before now. There are a few things I can still do to try to normalize my setup like taking it to a stock Linux image of some kind in QEMU, but I was hoping for some advice before I keep slashing away. If there's one quirky thing to disclose, it's that the file system is ext3.

The numbers here look pretty normal to me. There are a number of places
where we can reuse objects, so we don't proactively free them.

> First, is any of that information actually relevant? Like, I wonder if I'm just looking at some records that are known to not have their corresponding free operations properly correlated. Second, would any of that actually be relevant to progressive growth of vmap_area?

I'd recommend confirming that the external module isn't the source of
the leak first. Memory allocation profiling doesn't track statistics
once a module is unloaded, so I'd recommend inserting a 'while(1);' in
the last line of your module, then checking /proc/allocinfo.

Also, afaik vmap_area is only allocated from within mm/vmalloc.c, so if
this is a kernel-side leak, I'd start looking from there first.

[1] https://lore.kernel.org/linux-mm/PH7PR11MB6523C5200943207E879FB5CAA9F8A@PH7PR11MB6523.namprd11.prod.outlook.com/

