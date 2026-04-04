Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 727B9E63FEA
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 17:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B07DC6B0088; Sat,  4 Apr 2026 13:24:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8836B0089; Sat,  4 Apr 2026 13:24:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7506B008A; Sat,  4 Apr 2026 13:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 890446B0088
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 13:24:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3A73C1403C7
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 17:24:54 +0000 (UTC)
X-FDA: 84621548508.19.C4BF0A9
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 86D6A40005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 17:24:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=THdSAnve;
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775323492; a=rsa-sha256;
	cv=none;
	b=oMLHUGV8eBg1cecpq9FzadccZRksWNzLI2+0SBFWrIDz/KFAgouUTNRDN78dbHCDe0YZ0V
	azwx8o7bdQf8nf18YFEDSQf9kjsJq0mBV8LnqeLHcRCtq40z4uHpVtuLwXWGWrLMo6laJo
	gk97OXR8EV+R+vQCJSDN5QqW9MwnI7M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775323492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=1oGf/F8Zl1olrj7LHwmAzkM6a8hyoOTJaO/XdIoQa0M=;
	b=zTsIOC8VplCq0Y7983IR60fwoQfkF+PJIWExscalQtoO/bdLhLrQj5s+RGSJLwplNsmCBX
	4g3UBEWQ+qw99d0KZ3LLvvks8EAa8kJ0xZ4PhxTtINxPTVkFBQwmZLNDLRiFqOOmO39NbR
	PddBgqWfK+9MJmK7OqorUfComkpzlJg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=THdSAnve;
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c76cce85bd9so897897a12.1
        for <linux-mm@kvack.org>; Sat, 04 Apr 2026 10:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775323490; x=1775928290; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1oGf/F8Zl1olrj7LHwmAzkM6a8hyoOTJaO/XdIoQa0M=;
        b=THdSAnvekZHes7vbAhHd+KVkyNBqt+MAEKeTqtb0KuDXncO3Z1mzo+vWIggtMsRjDc
         e8PEIjKvOyte5JvzaVYUYxCWrjeGJsWSeKe0Gj8VaVDkjs9sd+RdEjLsBxSnzezyF+xT
         gwD+V62dCeaJSMLeLrG9F11qUkVHBSUHQkY9/zp1XCxDvDp4oeWT6HrZVeukzTrg9Tue
         qNMLvdpH6RMIWF5gG+ijz2ByRQZuvcuSRx5pjDmDtGVID+UIXUy3Gk4x/LA0qQzM582M
         OxIPkpvHzKM2Now/7kBBNmv3jbuM4dQntJ1hWLh+pV7O6Jk9+KxciZS6q1C2VfyyCXmd
         Gv8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775323490; x=1775928290;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1oGf/F8Zl1olrj7LHwmAzkM6a8hyoOTJaO/XdIoQa0M=;
        b=X6tDiQL48c9MrrLRdHsYd3PDUyuJ/k1FlS60EgM5MysLzEgGuOSm6uxXIetxqIuA9T
         bRV6ZkXn7u5PKkrMiBbeZDhRfM+cFDEVApfrT8JsJh25Jd4xldMGsC+pNd8ASrrHxisw
         jcc8XIYetqb53/XoOfBLmU/20t9+XA/oo/hSUdd01OlWYG9jLQr/P68b8xMWEVOj5W+B
         NvUwk8gVOLtRHCpebHR/fyxWX4XPc2umQ9vZ+tGCskAMmKLoWvFEIwlzMr8uSyi8CEm0
         FOV9xp6IyZLBAlcQL50ULA7iufkFnjgXmifU8OKueQ7ahpZvxC/TEUlL9XCaeisA9DGb
         Jung==
X-Forwarded-Encrypted: i=1; AJvYcCWiBIX9KHaaHE/w94uDANGuQCKwSJNqJ2ij2NaCrrDYDPlt8E4N6KWoZY+MjOSLSx3uqWaoX8KyAQ==@kvack.org
X-Gm-Message-State: AOJu0Yyecx5ApfK1oGqALZmKHzt9m/G4PZDYeOvFKPM1hZmUxGPDKFDE
	XldJUR/5n2NTmFDIaIj4qbqvER0VU0JbfD57+zRz4xD0D1sC6wly4cRJWZC4fQ==
X-Gm-Gg: AeBDiesHxhcLMtN5q12+CxionlYuKhQOpOwgBkIt/7ya3WTfJ5bEd0nFCt08iUc+u4v
	tkU7zvgcVrdzGLh7Td43pYzIvEB/psNsrnVUTdG4f70BDRs3bRtKq5/gvfz7dDgQbscsHfkj1yR
	a1Ue25makybdL3GfjocjXquUFgjUqbsDfMiiUjDsHZfTIA8RD6tfqBO8d1R0GD1e5vlKmvzu3J4
	8ksbSg3TsXg0Yd5LUzSJorviSOyKGmsdEYOJe5nMaR8/Rnx/K5d59W/lbysUAV6jcx2wHhWCtBS
	/usxXXBFLougUz0vGfaSyB/uXAZNUtEBvxi4A5FYzNSq3ExADl5RpbYvycbVRMQ6zPplO+PVs5f
	YoeqkQ5cWZsEvm+8eILbnelzvGUWi2ctY9CEV0bqgzhYrocqNIP10a/P6vGW6sm8KMZfi7Jw290
	jDp7PnZjtA4ZRrlNO5dPEjJw==
X-Received: by 2002:a05:6a20:2454:b0:39b:8dcb:f37d with SMTP id adf61e73a8af0-39f2ee01ce5mr7551700637.17.1775323490281;
        Sat, 04 Apr 2026 10:24:50 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c657e703sm7990160a12.22.2026.04.04.10.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2026 10:24:49 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Matthew Wilcox <willy@infradead.org>, Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, alisaidi@amazon.com, blakgeof@amazon.com, abuehaze@amazon.de, dipietro.salvatore@gmail.com, stable@vger.kernel.org, Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
In-Reply-To: <adCQTF1PQnlbNMO8@casper.infradead.org>
Date: Sat, 04 Apr 2026 22:17:33 +0530
Message-ID: <5x66n04a.ritesh.list@gmail.com>
References: <20260403193535.9970-1-dipiets@amazon.it> <20260403193535.9970-2-dipiets@amazon.it> <adCQTF1PQnlbNMO8@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 86D6A40005
X-Stat-Signature: th1bzj75b649rineyu9qi6hqb9nppbpg
X-HE-Tag: 1775323492-857592
X-HE-Meta: U2FsdGVkX1+/eD57PGKNTVil4VncA0QQcuKe6wygd1qrpjpq4BLcpRhov5DVeUzTOa5AoRKXSNnuQANwZ07F7S9rZBkr9EggoMwjuarZFDPdu2eZ3OyRsj9xY8JYOUZNFrY1J5gNLml7yvbxCwztP29m9GL4hOvHmABt8xkM4+xXvto4INSBVMx2AEK7FrUPXatWsLsQAhYPXd1B+vkh3g5lxYqk4Rb9k9hPwh7Xqg+yoR+D4hNBrLcSGcEXW6lJUd3u5sxXHmV21+6JisoLbXweD/h8BVNRmLYwfxZnLgYNnp3jImyG8K9SNK20zqISKBaC1blhRDtU8h5bP8hj34TP8f1W2WqtnCFClPZspTNKgN6msuJTXrf/rniKu4DVfyGxrQwxa8BfHb4T9ViXyjb6sBazHRWiHtpemArogVrjfKVl8O/WVYpDlT273Aafa+s49g0dUWfai3r8TFUgR5rNGSjhg+ABq3otrTEN/ra+XW71bw9ndQE7nfWHDOAnVf/mnff250tKIdY0wW0ZXvg9LenY532St4OIVcUcaulepC9OuQ2qBPbN1kJLMMMLuWY90DE/yJjqIJE/q/7Iv0g+tmrOdGYWr3fqQ1mfKOOZJUp9hkBzdl+a/M95Yv3sZHulgYEIGPEVaFzqg95j++5L/26Yi6USP4kRE94nAs+vdv8uvLZoiRf9X3ahW0YayUoFHS0sXsthzWO5OPtxFtQekZLyKZ7pGKbVJj+BQYxKdjb8eGojWh6wqkOhJ1uu5KshH1xf9jP5RSrkOBYVmHkTbtWZcv4V2Dmvzp1HDweM5vb+aNIUQp8SMbdHjdZSBPjnIChNMi7JVSo0MUgAIbOfuTsVcn961aCe12JlzW42bD2N+PWe0lsODU4ti6qOK7fLlhGraSmTm46UppsTLePxtfYEMKR8RsqeXc5JouV67sI8ThTF7JKF55tO/mvhsIOYPzVT8EOZ/q/QIJo
 22vAqydB
 GrDDCePKzX0fIgpN5747iNGrt8k979H7LSW7hlYJPXuAxttP8ZMfnwR+i0k4BdqPhnzHND3mGBQB4gl+ukRWcTH8SYwxKkc0sFPQd9FbuRSgvGgqUrpLFB1lFNmaipNZekPoy6Q78ebrwWZVx9cu8OvIgnMDm/eF6XbyoBin6umxHuvEAzfZYDw+XXGO0P/mof+5GLKgEHQotWgZA2kxkH/jzoHQv4qXlYwCvtnxoqZBBn2VuepnFxpKgMdLg2TefRzfbUcJCElBT58Y2wTS+3QiMbQxGQjLpMPWRPmxMsnKsBT2n7qg0b9f9WvhUEHumRdWhC/3SHIoUeIKHJnDA9Un1vHmlog1he5yGFiSHQrEFZSYEzV/0gR8YjPfusjgj9Vk/4KHx9M9sT16zSuhcrM2Ec6hN2Gr+WpOwvT04/Ryd/1tQ1q7xvIvDSeD+RPY7loLIrJMqeMWO47BzDZv9nDEcV0SU5477TNAtgje8OyqQig4dSRyXY/ka6PzZv2TeS5zeddSiKsmRernRa7sZyxPcWd55SXUjv0f2gGMHd1kvlrs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matthew Wilcox <willy@infradead.org> writes:

> On Fri, Apr 03, 2026 at 07:35:34PM +0000, Salvatore Dipietro wrote:
>> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>> introduced high-order folio allocations in the buffered write
>> path. When memory is fragmented, each failed allocation triggers
>> compaction and drain_all_pages() via __alloc_pages_slowpath(),
>> causing a 0.75x throughput drop on pgbench (simple-update) with 
>> 1024 clients on a 96-vCPU arm64 system.
>> 
>> Strip __GFP_DIRECT_RECLAIM from folio allocations in
>> iomap_get_folio() when the order exceeds PAGE_ALLOC_COSTLY_ORDER,
>> making them purely opportunistic.
>
> If you look at __filemap_get_folio_mpol(), that's kind of being tried
> already:
>
>                         if (order > min_order)
>                                 alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
>
>  * %__GFP_NORETRY: The VM implementation will try only very lightweight
>  * memory direct reclaim to get some memory under memory pressure (thus
>  * it can sleep). It will avoid disruptive actions like OOM killer. The
>  * caller must handle the failure which is quite likely to happen under
>  * heavy memory pressure. The flag is suitable when failure can easily be
>  * handled at small cost, such as reduced throughput.
>
> which, from the description, seemed like the right approach.  So either
> the description or the implementation should be updated, I suppose?
>
> Now, what happens if you change those two lines to:
>
> 			if (order > min_order) {
> 				alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
> 				alloc_gfp |= __GFP_NOWARN;
> 			}

Hi Matthew,

Shouldn't we try this instead? This would still allows us to keep
__GFP_NORETRY and hence light weight direct reclaim/compaction for
atleast the non-costly order allocations, right?

 			if (order > min_order) {
				alloc_gfp |= __GFP_NOWARN;
				if (order > PAGE_ALLOC_COSTLY_ORDER)
					alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
				else
					alloc_gfp |= __GFP_NORETRY;
			}

-ritesh

>
> Do you recover the performance?

