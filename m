Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95726606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 05:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ZXfl1Ib/
Received: by kanga.kvack.org (Postfix)
	id 7807F6B05B8; Thu,  5 Nov 2026 00:05:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70A546B05BC; Thu,  5 Nov 2026 00:05:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2056B05C2; Thu,  5 Nov 2026 00:05:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3689C6B05B8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:05:28 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25A3B140908
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:05:27 +0000 (UTC)
X-FDA: 85399877094.29.02945B6
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 49613100004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:05:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="ZXfl1Ib/";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793855125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mGyyLkfMtTuuKs4xriRESG+abVUcpds9iYOPA5vDlKw=;
	b=ajU38nApVny9nAXCsjwTMmLdiKhxGIMxm2UHoak6gZTMwXHOaISaCh/rnKCW92GI7boV+D
	iMzadA5UVRo/rVrbbvYzz7+8ry6VK2IaojtroaRFWaqsvTVamcT2mSOIbAb6yo9UE1F64t
	zJBUd+cy3adwNIUOZXlADu1+tE7+knQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793855125;
	b=Vx0ANCKmFXa2MiQI+GPrCVaSKD3860rz61LvGKDts0emGw1uOnc4M8/NZUDUwSauM+4e85
	kynvRF1UCJxrpyQz5zs8cDlaGFfU/cDMWizqJb4+/Ip/LGWZkIFcaxsw6ZBacTs04I+7xN
	8gNpDNacYd2hfw56iPfRoMXZvb+wh40=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="ZXfl1Ib/";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-36e99cf7bb3so39448eec.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 21:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793855124; x=1794459924; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mGyyLkfMtTuuKs4xriRESG+abVUcpds9iYOPA5vDlKw=;
        b=ZXfl1Ib/y7xPPrlPFkLYtSVnGxWaN7rBtJLXYZ6soCiHOwhAOF/3deCG+ZMYSR+ldD
         Ipf97nsm6KIEC4mtuey65SqIzTz085eq1JzhZa8v6mu374WMX3ZE91PVESI0obL3x0mh
         qG4LAvlDoWMlBSdraBc1i7uRnChtPLfD5J6bk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793855124; x=1794459924;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mGyyLkfMtTuuKs4xriRESG+abVUcpds9iYOPA5vDlKw=;
        b=MQhMGjj1f6yt9EMBqFXFBfojP6hZTmac5RgAJL053q9Ya7kNc9O2qRhuDmmgnHUKxZ
         gkmrZg9mk+YMHjT0wG/Y6O20HHWs2jfzwbkUCWfIujXrXQ57s9K0zD384RKgTDgTnlY+
         kqwJa5C95Ihgk5lyxU/LqUUAM+633qncnD/KNll6MPzPqvWllvq6x67KEF4fCQeqjh/E
         qjzWm/NgYgOfxJOMypNIsyqGEuTySSBOEeRbjaurzj1R5B3lE9hzlAGkS6D18JI2focu
         js4E8qr3jC4RJ08fV3MEt21xZL6p26RrVYMQ3VdTjRuYJJ4JVN7I8t9d7QmO5C47Wm6M
         J5cg==
X-Forwarded-Encrypted: i=1; AKwUvBxGTL0LaOiRQwFMyTXq+u2qJZubFZYGuFjjZRClpq3XJRHJJLxk/HxtwuPZe1p32agtHR3kssfTNg==@kvack.org
X-Gm-Message-State: APuU4Z9AtYMoUnHKOwde/wJDzpDaSkQeAHx6HDKo/4ATBPP4mYqBYCGZ
	SFdXiEymaFWXEtVtr8laAFnnLZhrK8oTeJf87m0WoA/8B7tTWzQL2e2qIofrr1mWZQ==
X-Gm-Gg: AYBFou1aeIs4551U8hE3/zNAUkf0NsEN0BVQoRjR7FIdKfxCYEkEnoiYgdmBxeHGri/
	07Wb67GSrLgQgVLVKbx4NIQEWaXYS+zQ1CHyH0x6BzyQFxrkN950v8W/gN/jRQz4mM6WuY2N8Q6
	ZXPzHIBJsODhBWJyaE7Ijd5rMnam/hXb0pmvwNLEeJJ2rxmPOIzbZO3YfuF1ZVu2z2SazhvjBrm
	sepS3Dp0OwdHmLlqAiAk1aA8S5L5awFCFC6Aw2snn0LN/RHz3z7gQNunk/VlPaaeAvsZSF2GbCI
	Ad8Vq9eGDN0biTwrHHfdmaNVtILDpAtesTTqWbWPVCNcyOfyQGqSgUzde0iBA0F3+vpjj0dAYIc
	dsQ/GhzyCz/WlyYoSe8L4d78kFYt3yfI5DE+sZYG67ZO+OeZagcYrbs3Wigt64DpCR3y7k+585h
	1kaR8cRwGKBgDp4zsa2tkShzfTgzkFbioukHHXMKmUhSzz604IVcDyLy8kpinl1L9KJpG6kj0aO
	9pGIeYGFx23z8by9ZjpZZ8jf5dr9IK54Jhx5lyvhrx4IzNDZvcYUPTTQIXBlT5DcLtFqkfiQ0pa
	AAXxgCC+qsJFda1IAEDY3/Dgd0+3ovrrI0qC732m3eRE+MCKqOk+MHgbjoI2H6h5iX2RvQ==
X-Received: by 2002:a05:693c:20c9:20b0:351:245b:d1e7 with SMTP id 5a478bee46e88-36a42061e10mr23766914eec.0.1793855123743;
        Wed, 04 Nov 2026 21:05:23 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:37bc:b763:7ec7:65b4])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36dad72dc52sm5463602eec.0.2026.11.04.21.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 21:05:23 -0800 (PST)
Date: Thu, 5 Nov 2026 14:05:18 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, Chris Wiseman <chriswiseman@google.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Xueyuan Chen <xueyuan.chen@vivo.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
Message-ID: <auwOBaRtM9p_Wxfx@google.com>
References: <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com>
 <aufPMirl4cD7tz0X@google.com>
 <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
 <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
 <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
 <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
 <179384102494.19062.12740032892044628762.b4-reply@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179384102494.19062.12740032892044628762.b4-reply@b4>
X-Stat-Signature: 3pbbdf3fxmdoiy3skjbgj1dqcxs6r9qt
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 49613100004
X-HE-Tag: 1793855125-770304
X-HE-Meta: U2FsdGVkX1/UtYnmt84doaJCcb2fx3Mdj5Gg+/5khjOUkbA4/26798qsg9Qfh33QQTUKCV+AZe3eXYtCmrY7XWv3rqI/GzD87WnITxw5CLFLwfrCBfzw8ntVvjQVVO34XdLIwU9rFpkgJACMklo7dy/fGLHKQb7bbtsQWNdVILCPBwHSRNqGeOc2mqBdm3yV5OAok1vNgYnqdHAKU2OA9HWGAfTKPJsdAFac7N2mAQgDlRAAlXahmF6g6Lq3MRVGqvR/IjBj7DanmA/3ohTStMxPE1jGJFyk3phoF7+xbiis3T6WLUReuWHu6IDMRha4tQAaoy0AK9ihmMwxZmpN1Eh3xMWnLDVSjFisbfVzLJRktnqHAFvgQQJ4KRTxZTvoSZIDLWt6qQoOp8BJ695/J0Bnb/E1EQESgonkczyClyAc5VVkPnp47iYr4ultrMatQM/US7gmUKh8M4HWg+86UWDKw/2c0nseZnO8uG8kvB+4BGc+PNHBgAJnXJELvr43Zre7l6BvUNjLxE86Tn7WegMJMhUtmxGt2ZeEm+0B2eR90arwdlUO8dqwzmZbasr8L2fQZ/84eByLuYyq5K4J+D3TOUy0RPi/chTVNREX7jQgccEFUWNheDaAuig8xfAuPEsOqVw1Uv6gs0mbws+R9XekhF5sU5crDOOtu3Xroh+ZYXItAF3cPq8bUqWDh1O4X2+scjdXjBSTuGUgYUJVA2oja8ibNG7cO1he3yRn3SO9PkHdsoQzBwbr+ch8uw3p+YrY9QP+kDQ58+NgtC4eong1KiySE5sbVqsO0gPMnbJoLyPaW5mrra9UVukqkR84jZO8qNo3kH4fYuGrzmJv5/JRc9ybrKuBjhaGCb/cyAaIamUdDZFBZoqDE3HI0Lt5Wvc2UVuscIqTXq+4KSTjK0BUHDijbTEeY8aoQTY8i7vBgX/I2uX6sEI/rw30lIAlTO6HWrhIP38prJd9ksK
 eF+prAzD
 MP53Rood2ysqKnjwRV+ZOuIIBxm3PBWfnhOaKW+Q13KL0FBUc9Y66X/A7+2fZRWKRQ7R3vX2SgDwn4XLLdS/qqkb9+AqKVZcD0w43SBG02ure+1SOAduQxzvFf6wsrvsQhGBxVIHxEZNGRbBG7ky1GzhRVMaObKEesdrItTxGjgBKoPD9y7kd4HvIM44bdtxOr6MSCxBxz3THKKOifEDPiRCKI4Dh+DxTmw2Q3lAHTFDLBZktVgfIFBgv/tXbfRoPCK9+lQIh1eWmya6yjEzgoD1vuGH06Vb2Ib0rBs4D9FrwhkhsHCecuVeqecE3y8P1eksSq8ylrp32kOYRSIC5rn6rpaVmF6cC34rjN6+6b1TRDYBg3qDJuuSuwBsIpgW8v7bidgaPVdDIFrR8rRovgqpLN3qYu5xWqba8Ci3N1Y2QimyWyiu3CQXfTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/05 09:10), Xueyuan Chen wrote:
[..]
> > SGTM, but I'll let Sergey chime in!
> 
> Thanks, Nhat and Chris, for the discussion.
> 
> If Sergey has no objections, I'd be happy to send a follow-up series
> to make the shrinker configurable and add the unlocked pre-check as
> Nhat suggested.

Thanks.  Sounds like you and Chris will to have "Rock-Paper-Scissors"
to determine who sends a oatch ;)  Just joking, let's first figure
out how exactly we want that zsmalloc-shrinker thing to behave wrt
zswap expectations.

