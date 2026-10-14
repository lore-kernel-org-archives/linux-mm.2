Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 162E4CC6B24
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:36:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6121A6B0099; Wed, 14 Oct 2026 11:36:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C27C6B009B; Wed, 14 Oct 2026 11:36:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48B126B009D; Wed, 14 Oct 2026 11:36:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1162F6B0099
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:36:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8ED5C12056C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:36:12 +0000 (UTC)
X-FDA: 85321632984.29.A9BE97B
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id B2FE740004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:36:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oa4Lub7b;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791992170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dAMXxWVecBisExRUQtUNYk1sARRmcgk7oEoVaJAln/M=;
	b=SpqYub1L8Lgy3ECuFoyTmDLFkBEFnVzrtqS8fHHUZ9RP7eTXvwFkUtWd8mjhDTogyWwDVX
	jq6rGmGwyD52WKY6e357p4B9WCTfZDE0/UUMltS3iaRHBepkBcejaPX1Y+Xfd4+egDPXLK
	srWqPXUSI7gstB/UpLQBA4MZnB/lW9s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oa4Lub7b;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791992170;
	b=yQ6Ng1eaNUc5CTz304j5klPm4RYAAJ/oB+tlWtjpTDUKGEXQN1Eo/4ooENYWUJHqsztlrH
	ILHehdVldaNMZYz/0Ye7xxLPKi8yaNUB9gmrUQgBNidnBXYVHVJfgTgdMlooubRHfENxPH
	6PHJ4/ChOORtTemEE2bnEcQ4e/6BJ/w=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so390668a91.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791992169; x=1792596969; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dAMXxWVecBisExRUQtUNYk1sARRmcgk7oEoVaJAln/M=;
        b=oa4Lub7ble+sWm4lI5YaD+/o5aBbPtUSDbMAIxCZExVuJb5cLOFfQOky8rIgkVQVOT
         wy6AMGZxmyiUpjRMan+HNuePRD6t7ej3d3U4ChPzV9oeLqJdA+SkF8XzJLbwUiQFhf8C
         lKnLjPLzdPAPcnNrYFmb74KLcW1PqFVY/qEEKBnQbNprBL37J48sk5xhHeZXdN9ppgPb
         qVslRkr/uPjv1Ej00q1JNKU+eUv40fRqUohLxTWWR2kYMn5E6qfhG5qzMhvIUyVFybDn
         z3z3YfbdkU5bf3K7n8+RD03R+Ps9Jcit9amXs01Xc1Si09DimCBjEBqzhQtKezaxW7nk
         0b9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791992169; x=1792596969;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dAMXxWVecBisExRUQtUNYk1sARRmcgk7oEoVaJAln/M=;
        b=Fa3GgHAdws0XHbxffSkTXMGeMS2b42FBXIyP0j2ZC6D4xK/1qyrnzbZ3bBRpI5ZtZI
         SA3JanAqXpcecVSvUY0/l8VqgJzRasfiBDikS/N1sgv1DtSGS5fAvCUkezrc5N5OPqgV
         KL3a+TKlac8sDdobTuYxILko4aGt5qRau2oOCvy5y2PGdkp/SLPiAgwAAnRTv7kc3k7o
         YYNOtyo4ODsWPbZrUT+SVL2WezcEPsWVg9xIg2PvM89eImmm9M4NXy9rVz+h3Ii/VCUA
         VnWvHUwW62WED8CvemmKI8zJMZbMxqzPBDXi0VLvk5C7c/MAsE5J7esNjB9FfKONxlWB
         HPQg==
X-Forwarded-Encrypted: i=1; AKwUvByO3BzUqM/t+6PE6GRxDpg1J9/bnr8mDY6EO6qGjVPOIvFlA/O4ZLU+4c0q9XrnfeZio9Yn2gLIPg==@kvack.org
X-Gm-Message-State: AFq9FYL5hrtAtDARN7WArioZrd3PaNEXWD0xdzA/VGis8EYAuWXKHbr9
	EWMZ3oe9tDsdWkBj/vcZDkE8g3tBjHBBeO9EIR7NB/xKWmic4jfsOOOR
X-Gm-Gg: AYBFou3T9OU9PpjvI7iljokTNReQ2+DiwNi5KwHFFkW6EWuv3rCiIbtbLg+BoWMfLYG
	KU9Zozbg798LYAppu30/MzgkOrIoYyRK1DrBFH0TWSB6JVRivBzqqabsJ/UVeP+1XiAuQzt+Wy0
	FScn3FLV7F5QGGOBbIMH9JLKXOmBsDcYQlCAvI3CjbMb3foiYEsF/E3nhzDHlCha0nWE8WQ2q+h
	lNnfykzawn+qDWkn74fBG995m5eWJNgs3DMzJPS174Pu/vOvixSMgucoBLNOknHlJVMJQVrGk2h
	xRmU+ZgGYsFGCFt9as8VfEJ4/7HwHVajev+yd9JVsqlduUz+I2W2VOuoCuye0rPXuo7c8U/SmUb
	1xVpQWJ/DmmMdFnvamkOGaO60HgC4duXJbNSef7hi/Mc3ktaghZyNeREPQd3MEncKL/YblPFjNp
	9IsVe2TD4+NfWJLwq8+bVFtc5L64WcrKSq+iCp+motRqKloi8nJ+hgL7t/o55/J7vWsLwAmONZ4
	iiUPljVeOPQwXAf
X-Received: by 2002:a17:90b:224c:b0:3a7:9adb:2a0d with SMTP id 98e67ed59e1d1-3ab3a0218bfmr15319248a91.0.1791992169371;
        Wed, 14 Oct 2026 08:36:09 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac5f2ba9efsm4715588a91.16.2026.10.14.08.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 08:36:08 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	bgeffon@google.com,
	minchan@kernel.org,
	richardycc@google.com,
	baohua@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 10/11] zram: use rw_semaphore for decompression streams
Date: Wed, 14 Oct 2026 23:36:03 +0800
Message-Id: <20261014153603.1365617-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261013035201.2809924-11-senozhatsky@chromium.org>
References: <20261013035201.2809924-11-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B2FE740004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: gn6fxu8xmmksxktttkxk649uui8dufur
X-HE-Tag: 1791992170-884468
X-HE-Meta: U2FsdGVkX18pz9yEjy0Y8bLEpij4cintOoqZZL2GBpfVzZC5wZhuQiw9IcVa6CJ5Dgmi4d1cjlaws1ure9CqC9MG5w/t+cCdsBguFbpJY6YmhPeIHZRqSDNnKsKf6MhbhwQfnr/ul2yoToCHVTBG7GRsH1MxmTCQT5LBKxtt0YLleL1pGFXetoR8ENT/QnSKQXYCyuU+h6xlifw6yNCQB9CT8MM8vEV3tBYXZY+RIhaNvcaVx247x52euWmPSZLujgasMevyFS2kq7oVU9zazsc4t4DrukeqVWz0ubcOHcMyZspzZ7rpZ2FN7XBV2qdSt74SbrT3ewtUOJwIQZ2pEWdt8lxajm973C3Dz5IIDk2yHoI0+rqguuO/JGEt+JVZlKCStaLw4ESsVIzNl9A5OxIQmH58Fpexxb7uPeDxM63fEBXi4/mdKIhAUuL8pNEDbMTFUd4BlBBSYsjnL5qvoRyAVLTixN9xqcpcTy0frLk0PNtX/ueXG0Mc9l0YMNI5ASlsz0NjsYTQR9TGbd86tCS/aAKVZi6pcj0k+MJDj5QFvE45g9YEXZlq7AHp43O26qsnpQ2Hv2PwrtBHrBEuyKJXrGThFh1lThK2Ydlg3A/bE1TkmHQb69SdQgTuMEBEskE3CDssFBFiGR4N8gcMU5hYSJx+j7jSqQ0CYBNT7kH7KX0/HL9HdpcV4Vz0WuVHvwm5MXfIM3781UZmxEtWjq5z33jEJe8LL+IJMXK1BerND1nw+lyyK61ggJ9y3Gu/OIRvUU5m0AvIyzd8RzoaEywEUE8tLpxLl/v4tJBZUV7teV+yrdLBT05526ePulTObNRniM7Hpjw/dy7IvKL5i5gK5xprj/2hkhS7tCQkBTZ6bSwGrMrEGGdyyiwJNnqUcN5WjO+/0k2stIeKVlFNa/MgH2ApViOgmdIILlW7nn5tppXBw9PUwfmlh3HaP0iyGzbOt6ws4f5LdVPBP+B
 /4yQqekH
 6hkTg2hKw+JQkIsDW5njBsMvQ7ZE7jR90lQSBTlySG5Ni9+pvcYrCfAzc/rcO/ODBOmaYc8HdpaZj+WuU7535adwLAhVN+EmQnPot2B9RAPby4VQB9qWHQhe/oFAtObzRA7lfHz6dz26BfkHIo/+tGcrQCgipNrfpNEj07lxznaw5JE9ntlEaaqMMdCGAhnHe192vDBIM6QfExWjDfWi8QvKtFzuurWvlhlIV4VpZnxGjCmtq6j2MzGjYFST5CIxTP99b0DBZqe7NSgXG0P3kVehAvh/o261EKHI/sTJvparJn6jFzZ2cgmWLJC6+4vNrAQQlfOyf+XbFgYuboVZQ7K7R+TxmGNy+6qsgeRmNbaRj7CraCdnmPUb3hIS21t5xGPuU3MuyVzhdNZqbv04OG9C7vl4DUsQV0Br7SDarX/nRWlAcY2vJw1udZyo6J5kNYWri
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Following up on the RFC thread [1]: Sergey pointed me at this series as
the reworked version of the by-direction split I had tested, so I applied
patches 9 and 10 and re-ran the same A/B. Big improvement.

[1] https://lore.kernel.org/lkml/20261012123328.1138059-1-zhangbo56@xiaomi.com

Setup as before: real Android device (MemTotal ~7.7GB, zram ~8GB), cycle
20 apps through fg/bg to force swap-out/in, 8 rounds, reboot before each.
Same trylock instrumentation on the stream locks across all builds. For
patch 10, "read contended" = dpin_contended + dexcl_contended. Decompress
("read") is the swap-in path, which is what matters for us.

I use decompress acquire count (swapped-in pages) as the comparability anchor
instead of swap volume, which stays within ~20% across builds.

                      baseline   preempt-disable   9 + 10
  read contended      24,749     406               1,959
  read wait_ns total  239.8 s    3.78 s            ~12 s
  read wait_ns max    757 ms     51.7 ms           72-96 ms
  read acquire        3,948,150  4,305,078         3,510,610

Decompression on 9+10 splits into:
  shared (stateless backend, single-page): 76.7% -> down_read never
      blocked (dpin_contended = 0)
  exclusive (cross-page object): 23.3% -> excl_lock, ~1,959 contended

- 9+10: read contention -92%, total wait ~-95%, worst case 757ms -> ~90ms.
  The rwsem does the heavy lifting: ~77% of swap-in decompressions now run
  concurrently with zero pin contention - exactly the reader-vs-reader
  queuing we were hitting. Clear win over the two-mutex split.
- Residual contention is all on the exclusive path, mostly cross-page
  objects (which need the ->local_copy bounce), not a specific backend -
  lzo-rle single-page objects all go shared.
- preempt-disable still shows the lowest read contention (406). It covers
  the other half of the root cause (holder preempted/migrated while
  holding the stream), so the two are complementary rather than
  competing: 9+10 removes reader-vs-reader queuing structurally, and the
  ~90ms tail that remains on 9+10 is the preempt/migrate effect.

Happy to share scripts and raw numbers on request.

Thanks,
Bo

