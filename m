Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87A83CA0EED
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 23:19:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 821216B0005; Sun, 24 Aug 2025 19:19:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2A46B0007; Sun, 24 Aug 2025 19:19:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A646B0008; Sun, 24 Aug 2025 19:19:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 508E96B0005
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 19:19:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D1B5516025A
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 23:19:50 +0000 (UTC)
X-FDA: 83813220540.15.A0ACAF6
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 133BD180007
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 23:19:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="AyR5g/Qh";
	spf=pass (imf06.hostedemail.com: domain of mallikarjunst09@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=mallikarjunst09@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756077589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UmM40kFHu7y6w1kDElLTxjdz9xSmHdOgb73sn9dXdkQ=;
	b=dvVqYz++yc+Vy4dtB4G75GIzb7imnfxZAqa5nN1iNB8FN+YfG1SGr4vBpDY+a1EK+DX5+N
	lasmjcOvkcOxbp9/+dzB2A4F+/8mDa8gOwyERctdfT6GNW1HyEH8MVNgoqFYrsu7zf3pdi
	/IRUKiCcrDGbv5URQiFVlgwFQxD/r8U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756077589; a=rsa-sha256;
	cv=none;
	b=hBrtGsFghY0h1GtcowclXVy8KF9A8DoOM5Ngs5zqmZh4r1PX5hKrLo9C9ZcDbjosP4g9mj
	VHojfu4TqGJqSuUoew2+/prPLXTBra2IV3oL35cAl6+HLmOLZNck1srzzc/FYNqwbnocTD
	oIAo8FzA+Ie1nIIC8KpuRtpI1Vy8U+A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="AyR5g/Qh";
	spf=pass (imf06.hostedemail.com: domain of mallikarjunst09@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=mallikarjunst09@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-55f3a3f2f60so985557e87.2
        for <linux-mm@kvack.org>; Sun, 24 Aug 2025 16:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756077587; x=1756682387; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UmM40kFHu7y6w1kDElLTxjdz9xSmHdOgb73sn9dXdkQ=;
        b=AyR5g/QhuJOL75peikx6f+axYzNOhiClA1U0NyfU2p54iUKsCC3gH2dhZtI1Yli50j
         pVVr9x+ZQbvRhsf1vYWYHBX6dCeZWqHrTqReKRpxhMjd3QzFJE2tWWvHFVzdWH4dFWr8
         wUkni8p1cGrUv83N4HjGjwOZxvaddvfTqakURmbvJD1NzXXRHVV379WN+9qZEiixnroq
         Au5S1hKZA/i3E4CnSLNdvmRUNnOpPUJGk30mTSZpvKcAZnw2INsIuWdGAaEed9MV0rTj
         ziz6l34T5AmT2nTgKR96HkQ1HmM6CRgBYPsNrGVC9Kf61xZSea3jq4/j6GgYRq6wAKMQ
         ghmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756077587; x=1756682387;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UmM40kFHu7y6w1kDElLTxjdz9xSmHdOgb73sn9dXdkQ=;
        b=Hc4EhNE3mnmy7YliCcG9d5BsqVwuszgbAYbA+l2+ICjE4h5zcHYRvvFelzbZFjp23a
         pkAkbmOxeGYjLMi8RM5N7SrHVMvB8cBk7n7OsdSgAcz2h5G0DUbvenkiKKRnHdS6mbQS
         1vIHNMNoKRTDYZ8EPt4KxicBbLmSlOTh07cfDfCu0G9kX05M8hM0VDZUnzby24ki/YFx
         sSvgR2Fp+L5LoBtvwkfWgoa6qXuoURD/4xpUwERJLNCc6k7mtbQEwX7Gw/9mUczMcUt7
         TNGOK3PNKtP3FD811OP4EHXFtuqApIXPNWem3aZy/jKFa+VetlL0ovKRLcGGrjGERR94
         FNRQ==
X-Gm-Message-State: AOJu0YwdwgxbfAXC2Evs++LQnrIuByxN5jIIP6Cxk/iV0msvd3sRxTBI
	xtd3zUPGgh+N03FoJ+daaL6oA1zlJGlJnjR/puWhSCszhZYdHUPSCsv+
X-Gm-Gg: ASbGncu1R455CX2jkr4FcZe1eaoXv9tmYVJNKIks/QncbpizboPc4k8dEDRNLvj/cek
	dgOxMFRhKdkE5dQUnGqkWdkjMU9dPkvDnvfrNMRz8G16nb9pd/C6Hay2OSbP0kKSlqjbCzZKd6N
	DpVwnUgQ7NVhs3WV6AxvfYqJCcEpKmnUykpKd9kkgvFDo8z0BD6j/NLncff0aVf76QSuCIaHyEd
	PPhg7Mw5GUfjmpmrJYEdoVNHB3UK8b+C9TX7DlkuJF/XQMKfGlEr8PqOefAPBEim8x1ZuxOj1TS
	gpae5k1zIyrHJH5wubrefg/0qGXu4f/SznK8Wcm9ILlQlmDl6UMswV524rwfAaCq3QYOh9YZGqS
	rTgbLWqWe2ErcgBogtzGhd5MfOpBlkOzTZ//6D3Urp1xhHEs+nFllF2cK3yZ/AQbTO01n64hhPs
	zlHQUdvT+j4Rsl1PPYJpq/A5qlIzBsu+qoaNeUOMuOkLtOa3IlrTzKrw==
X-Google-Smtp-Source: AGHT+IFH8Gguydnj/gZwYUIqVoUJZDcXxQXD16TPLJVRIthpGvYhR/+6vI99F1aFwVlA/sgsldzduw==
X-Received: by 2002:a05:6512:234c:b0:55f:42b8:b11 with SMTP id 2adb3069b0e04-55f42b80c99mr817992e87.45.1756077586954;
        Sun, 24 Aug 2025 16:19:46 -0700 (PDT)
Received: from ip-172-31-45-110.eu-north-1.compute.internal (ec2-13-51-206-214.eu-north-1.compute.amazonaws.com. [13.51.206.214])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55f35c9a199sm1294898e87.110.2025.08.24.16.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Aug 2025 16:19:46 -0700 (PDT)
From: Mallikarjun Thammanavar <mallikarjunst09@gmail.com>
To: nphamcs@gmail.com,
	shuah@kernel.org,
	hannes@cmpxchg.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mallikarjun Thammanavar <mallikarjunst09@gmail.com>
Subject: [PATCH] selftests/cachestat: fix grammar and debug prints
Date: Sun, 24 Aug 2025 23:19:42 +0000
Message-ID: <20250824231942.3910-1-mallikarjunst09@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 133BD180007
X-Stat-Signature: izqd1o6omd1ewxig5oe1ohcbhjsk1xdp
X-Rspam-User: 
X-HE-Tag: 1756077588-685753
X-HE-Meta: U2FsdGVkX1+4/fxVfwpu9CPlrClKkyDV2SMpVJDylgk1sxGxdV459Uzn3zkjcCrMq/Ese9EDw3D9nIlhj+Z9sJe+Ixte8ZkxIpCf94RNhvGdpT/Uvm5oOKrOa1w0NfURu4NwnEHYyY1cFwDgmyoZC6bZ4uthbuQZyMJCIvbVCc/nKztnu5UZSChtmSJlM7pfWcZU3iSkwOSGLWfFQvfOaAbe7tMr7PxlCFRPEDuOegf7RrNrhhkdoT4zEwqCdJZLTBYbAuTGRTboOz+1CCqdwtOe2XGY1sy7AdwpaB5EnEw/RouYikGtKgqgmUO+8/uCdgbFMP9hFzoHAvX4dcxmHcIv5QIXJu4buawIwdxRbEngm2hdMnoiFf1j/H+0T/UX+2r/21qJDKRZi4B8pbaZZIUztRJ8BjbmcYRdnVFdZ2UiO3FJRvZ3ppghuDUvo+KJq3djo0c9odI9HDSAvB2X/f0439Y/2F7dwHJTeQ9In7JJKPJWdMBHlCqeXj8XHb1q0stAdaHWIC5b49PhacgL1NB7tm26hCDYrD60nPvDzPayMStj9UA7mMGTvtrxbjMAh3xCRtfpOafhTh6UskW9YEVaNAGCJF36L0ryC+ys5UsPvLllfvXrIGKa4tZjzrY1D3YRjnLbCQ1iEp/9sifIIC5fe3CTSRaApLDBhkOSBoawV+Xnz9bGpww8dZENjdNIWEaOyRcGWAZ51aoIRfcmQUF/9raHV0BPmpRHqiUminwSRM3vPA1PUpjNzYiySixPgxwekbIy/wCCVktANyya9Z6J+2viamSYzkoR1I0KD5qWsQFnqaUPG/92e5caNbdOPaNyrMM8W7dbGNaH28+XJvxqacSueMc+Wcu1Eyjm4Fx7W+wjgl3YwEcA67TJZ7l3uGy+idPJqlVvPN4dY0/34FCZtv8HKDp6F/x8BFQFOu2+9C88STALuqiEeON+4TqXqZ9Y667fdtLxFQTt1td
 W/jabXrD
 8/tEwlaB8lcV7p1ENWAMQLhpgk5i8Pfk6VPzPMerYp5E5RWjFk9FI7c7mbQ9qOl8QEvfmsIuB8JdnpUBz60KsAd2jhZw0e18nUAuP7RH8ohuFhybC2yOSmWvgSoXT188K4PeyeUV0mFz7wG/YxyhyecCmGqMNiKKlBwUAS+oISAEwE9NSixlZwe7TKPiCvRou8TOmRInzVKamVi73HtWof1P/B8rGrW1jE4Nws6fKxsHpxao7dVA1p+KAct/JUkerp8sxXalT1H2i7TsWl2oHkq8luNjo60uLJ8bp2yYVkGOAe4YX61dmSOfmSmiMpxog3ZO8+ZrEbj8xHyOjr3GAnrDhJwf5xTisW5bV0ki4gZbITajuhUrqAGVKvvXLIUHCCvX1p4EfCYcVr95sYca3QI8mzf+SPHEJ8fP/IZDo6fPOLsKSBJjvqs/iupKlpxEFJh8fR7U+dZSCavGZjHK1sjAC/w0/3FdGgQjMDGUCB4AfGC476QPlfOVwDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix minor grammar in ksft_print_msg() output for better readability.

Signed-off-by: Mallikarjun Thammanavar <mallikarjunst09@gmail.com>
---
 tools/testing/selftests/cachestat/test_cachestat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cachestat/test_cachestat.c b/tools/testing/selftests/cachestat/test_cachestat.c
index 632ab44737ec..1417d7fb7910 100644
--- a/tools/testing/selftests/cachestat/test_cachestat.c
+++ b/tools/testing/selftests/cachestat/test_cachestat.c
@@ -76,7 +76,7 @@ bool write_exactly(int fd, size_t filesize)
 		ssize_t write_len = write(fd, cursor, remained);
 
 		if (write_len <= 0) {
-			ksft_print_msg("Unable write random data to file.\n");
+			ksft_print_msg("Unable to write random data to file.\n");
 			ret = false;
 			goto out_free_data;
 		}
@@ -183,7 +183,7 @@ static int test_cachestat(const char *filename, bool write_random, bool create,
 				if (cs.nr_dirty) {
 					ret = KSFT_FAIL;
 					ksft_print_msg(
-						"Number of dirty should be zero after fsync.\n");
+						"Number of dirty pages should be zero after fsync.\n");
 				}
 			} else {
 				ksft_print_msg("Cachestat (after fsync) returned non-zero.\n");
-- 
2.43.0


