Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83355CE8D7C
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 307588E0016; Fri, 14 Nov 2025 14:00:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28FAE8E0006; Fri, 14 Nov 2025 14:00:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180548E0016; Fri, 14 Nov 2025 14:00:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F324A8E0006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:00:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC3951404C6
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:16 +0000 (UTC)
X-FDA: 84110128032.02.BCD40C0
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id AE1C9C0019
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Zc+bX5yd;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763146814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CmV4Tapi6eaC+qTnDSzcGvKGmED+q5xqWekcnxWZ1ms=;
	b=jvU1cO6+fjzBbea3WwLUrE1a97rBUqA6BKDXWGkQQ0oziOFalgJWxweAOwuM69nSSzJDp+
	HSqXrWukjGipix5uWb98oQfwks2vELJE5EfgrnjoJUqrjx8d3VkQlMLrOM49vMV9vZmIJl
	W+2vY+wlAK8NtbhgxyKQRc0UiVVXNiA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763146815; a=rsa-sha256;
	cv=none;
	b=Oi/UaV+M+gfQ8DHvrmGFhis/3Tvb8jFsOHwhPItc6td3HG9d0pIKKbFXo80EfFFlaon2+7
	rvTzumo5e0/9mZyyfIx0wGcb/efAvZW3LflNWfi3iIPHLiaGq1EpI6ZD2/wcMZ3LaSswWb
	bzGUfjHkBAU4U0BkC9vhY/WPbc5M6fc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Zc+bX5yd;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-63f996d4e1aso2095635d50.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763146814; x=1763751614; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CmV4Tapi6eaC+qTnDSzcGvKGmED+q5xqWekcnxWZ1ms=;
        b=Zc+bX5ydb1r6fEwy0Dp2R0pyIhKtYihVOoeHPoCiUCslFcUr1ZOWAZBbPTiBMqjSW9
         hpqOih49jmtdCcWc+fQeE9pf6cBom0bd9lR/90IjXXH0mBH5Wc5ovDglNRCTh4GnmsmY
         vCTfe4D/2HbuwoIWVwXXcOdJRMFsGWtFSQygWI+8fXs6Kikh8hXOiXNx0Vf4v/vhHCvN
         OSWIMYI6v3K0E28SKl61t0cpYnKFUwy67vOje1/oQ56bftQPnQ62vGzwYkFEjdr/mTmp
         2LjEB6jvwv8+STxDkfwaUIgzHe0EQgCo4eXYopqYLEj0eof5Zg52IhgnOoA/i/OZ0IP7
         C5xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763146814; x=1763751614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CmV4Tapi6eaC+qTnDSzcGvKGmED+q5xqWekcnxWZ1ms=;
        b=T5cLvAXUEZQl+5ofcvcSb4bLubbZFW6o+kJ2PhH7kU8EeYMNRoN+oBVpi1nX0r0YRb
         9sYwwYOp38Zzj+DAVhvNmcmVtodx8aeeF8fL+g9NSR1cKP5exhfNvf0zeIVJTrwFeIuq
         /OFzDq26je3JkdSW1yPRAg1KitGlJwbvk4CKq5Hi9946eHYzVS/hXlkpy0R2mIIwEYpD
         HxZ+69qtw993KOo8pM6M3wa6+dqwxwqUrf+dwwKZHd2xWU2+IiIUkd2O97bfi+iaiN5i
         mO0taOK+1Nvv9dxf2MZsisRgKXloUygRSTklBUv6JqMB2UzeZyfuZ81mVhWzGmYp6QoQ
         DbGg==
X-Forwarded-Encrypted: i=1; AJvYcCWhweIu33uaRVicanf77mGLjz0AqexgJu8qEX8517w6yPJpnOD0xAdf0QPYfI6xhzv0jIRul7xXTg==@kvack.org
X-Gm-Message-State: AOJu0YwbI5/eLRoJQo666qm1qsYARPJIHyuEdfsQCU+KkFEYI0LyC57i
	lxBOrQgpGfyYQ3LmffnRuGPyQ5Ev9eDRig1bTSBrR7cMQfkhp/Y4uWtqni8sI5OldFc=
X-Gm-Gg: ASbGncuBK6TwU3CYOCq0Cq/GmPpC4W6WED9q0JUlLZ2/5UYIJEec/Q7VZQxGKmQ7vHh
	8xCXNk4s3a0r8BLSicsv8pDXQVv6Ft4gADpqgp23O6gFVPdVlve4mrYBhrIUpAf7SZ+ZiuJz6OT
	NFGbyLV8rWLJymj215dpKS27dWQmLNpJ96mznid85ybVrOUmXMXLQs1JpzKMDvaHEwFTVK1FOf5
	tHNJC9cMMqXDLuxhOFtEd4yVY6W71XCFnTCPVlrmz0osA80lYhWlsFoYTQnQ/jt1DghBfAau/Fd
	iDTomTXARM25b/ZfibGfv6XHiX3oNO7X+pQts4SFGUfE7UbfEo3LR5LTb+CxLZpJBFWwLAASLPo
	RNbQQvfWYCESJcM+QVpAbFw1nY+LVylXbM/YK7KeI/gxcGtmqIMN7yP5amxB/1/NnDmBlslcGFQ
	Fp/6oGtWbiNxJuEDz/9MlP4p2Zom9hSdcEpkUdefQye256zPxTe5bYs9YLPTJceg05A7e/
X-Google-Smtp-Source: AGHT+IFAKuuH0ctE7rv8UKB4xSpR2fZv8zxYrTA+ywvPJYYrpw0z8KKJWcD+1hoAuKOrrQSN5X6HsA==
X-Received: by 2002:a05:690e:d06:b0:63e:b62:5826 with SMTP id 956f58d0204a3-641e7716e5fmr3272878d50.67.1763146813743;
        Fri, 14 Nov 2025 11:00:13 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6410e8f4f2esm2014058d50.0.2025.11.14.11.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 11:00:13 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	jasonmiu@google.com,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 06/13] kho: Always expose output FDT in debugfs
Date: Fri, 14 Nov 2025 13:59:55 -0500
Message-ID: <20251114190002.3311679-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AE1C9C0019
X-Stat-Signature: 4m3zg5bdpehs3fwdm113hiep1sgwuymy
X-Rspam-User: 
X-HE-Tag: 1763146814-166704
X-HE-Meta: U2FsdGVkX19JMMqARCEaFsPI03LOFwPsqUABLkz/64ff8H7aNUh929GyDh4PvNJCdy2x2Z5E+8PbMR2wp1Hjqp28gHaUN6+h8LAquCuFpAlrOYylJP13fSGLnkqSoOmw4wXFfCMLiMHKpfLW3TbbJLHn5adKIVTwLOikastWl61OQk27hRZvDI1CQE/4dYrFfzPmy8wUupGh4SQlPYI6+oEXu4dPbu78wlC1W/ppA4VWbtGJPdPT2SN7iJpL9wgwgSWZuGOZ0CYsQ0xSEdEwxxLTScGC6ZQqRpDh+DbjzcDESyGFgXEAbKYSXSILxm7f0WCZICyRhkc0gVS96WzzWhroPo44fV9rS6nE8YDZxEaIrQlUz3QQrK/bOanCGP/paXK9zxJPy1qA8N9XPP/KmZGKh52Gm0NmZ+OEGZmjK9yvm8Nq7AQozNlwDkFMriU9g68Pw7K1RAuUo3sTUhWje//jhZ+fX/7bsaSsTap+EnD2zs6Ck5wsTppPGCy/rxVXwYxwlLa+NxDh80VoWa1JMhTtBIGq0jqt3rL6TRGVRhKCdIPnZHjGNo1loptEHCpB7GxonN+qGC77bln9+wDeKMc3xGITnQXodPGQdS8mJdSanXiRWWW7yLwPxNV5a0FLc0TN+n8+DC7KAfVs5UydLsi/Ta88NXFFdyOQBeQNqVklYDb3ftcIYl8+loxtnvGJGw5wZwChmnxghby89i6x0iIZznj1FkVdQH3Eh6wvnKMWsih2U0je+iaFOVlWMqVsqHvuWFAvYnGrtLpYk1Ln9WXO1hjETndn9uwZ3DPirA4VngdKlc3cN3Tg7hcS/Tq9YvToLnDTSCgXFSu3HGjzdkPzQYrr4+arCUCAEq6JFCZrthRa1ZGe5Y5qePXh3tWM820DlkT4Trcqc2JnGYHNunxS2LhNPsrsyybp3AI4Q4YB3QNd1PUPfbOLL/w1aYTmdsrXa285WI8p7rGULUg
 wXcKuORM
 d/sY6gHJA8BRqynQxBfWkLBnBQ5wYLNyRK9ALa8aNWdCLT0/a8pVAwgNGx4DIDWm8A4ltU1R28BhJZkVz8c2I7kNB+iwa1koiZNVC5MnleDur2iuMgXDjEDa7dcPATSCM8khNH3ZvLBGTCBsB7fS4YpW/UNJYfl+DfHrXS5eFyp7B5W8DMu5NHv0cICRAN+n23c1p28BLNCVWA2hoHuA7ulkWwztlUOQOjC//c7z2ySzfiHoZG3ja0O9qB4TZlo01SGQb+jG4GszJXSTkaKxsWT7oq/vbNcipIGvMfPdKoMFKq4wLh5KaVcEyHbfUmFH+W4knQEFxE5hGDxEYO9nO/i9VdcecdZmIq+D4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the output FDT is added to debugfs only when KHO is
finalized and removed when aborted.

There is no need to hide the FDT based on the state. Always expose it
starting from initialization. This aids the transition toward removing
the explicit abort functionality and converting KHO to be fully
stateless.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index bed611bae1df..3e32c61a64b1 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1234,8 +1234,6 @@ int kho_abort(void)
 	__kho_abort();
 	kho_out.finalized = false;
 
-	kho_debugfs_fdt_remove(&kho_out.dbg, kho_out.fdt);
-
 	return 0;
 }
 
@@ -1306,9 +1304,6 @@ int kho_finalize(void)
 
 	kho_out.finalized = true;
 
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
-					 kho_out.fdt, true));
-
 	return 0;
 }
 
@@ -1425,6 +1420,9 @@ static __init int kho_init(void)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
 	}
 
+	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
+					 kho_out.fdt, true));
+
 	return 0;
 
 err_free_fdt:
-- 
2.52.0.rc1.455.g30608eb744-goog


