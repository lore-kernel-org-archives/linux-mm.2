Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB56FC83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 14:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86DF06B0088; Wed, 30 Jul 2025 10:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 817A36B0089; Wed, 30 Jul 2025 10:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7064E6B008A; Wed, 30 Jul 2025 10:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B9606B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 10:23:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D3C156EDA
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:23:14 +0000 (UTC)
X-FDA: 83721148308.09.C5F4ABA
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 639A9140010
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:23:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lnWlA+xT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of pranav.tyagi03@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=pranav.tyagi03@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753885391; a=rsa-sha256;
	cv=none;
	b=fGwumqhm0hGwPI/oggPDv01wA60xtlM9C7Ub7rwRZUaIP2AONntcwba3iPdzpyzhlHThXG
	DrmiLd/Nkdo72UoSyoYTpPGmz+VglltgWpTWjnLjZAh0eJCZgzdtGlgHD+q74xWRaM7fJs
	mhqX68p06ZZx1YsOnHvTFAqM+WA7fMo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lnWlA+xT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of pranav.tyagi03@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=pranav.tyagi03@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753885391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1cRqC1FtXpwVgZZdAo/vwbXfMDd9zPAjXXlAeihsTpA=;
	b=wZbCEyC16W/Asxq/tz7/SshOzUrs9HrdNyXimTgITyj8u2zksTMd6jc7brUDIV2EFJFxCY
	ZgMLLmSUlBHBNkXqNJt/UB+p6qlHAlXaSGAoWD6/O2Z7XRU7GP2UeIv3RIdUVZ5sA7zm6g
	cpfzl7OQEUK+8LBCRdpvz1EOaNPDfUs=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-76bc55f6612so282700b3a.0
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753885390; x=1754490190; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1cRqC1FtXpwVgZZdAo/vwbXfMDd9zPAjXXlAeihsTpA=;
        b=lnWlA+xTVfWw3zzQ15dL+3sQBbAEf/gXKMaaLT8guRs+SSC3T0GtYm1zJjFd95+ZGV
         X0VdvKdC5auQte6iHP+gmw7/JdhYTsbXIpwM27ev+icEYjwVZVzbZ5TOkqsqAN13Bx+M
         OgbDGqIekJRwUlaMw7Xeqo6nha2oev/4CUTDmQCIBPFslcXa69A1dSz0ze+Tn7ugQnI/
         HzPMSV75UoCelitJPuIO/O1ULpgS9SeJx4RrOuRuWgKCWaUjh/rzA3yS0EVS/JV4nwa6
         qHAMsH36UdW5Wv//qHbyTtyq9CZQWUjtKVMQ/RwHjmoOqAyc3CrBvUk/Gi9L/GLkRVpu
         G8lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753885390; x=1754490190;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1cRqC1FtXpwVgZZdAo/vwbXfMDd9zPAjXXlAeihsTpA=;
        b=QY+MjWRq3Uh7hKgF9nkutkz/ZljCtSJl2eqjUfqML4Arg+cFl2iQM4IWt4B2fjnd4k
         +O9Ct6SIqIV4LtEQCu+DRQY1tGzGLT+DrR2orCvrUWdKvQycKTqVtVY1GdcAzd/vXW26
         kAq5fq+ayQgYwnM2W6X47HYgaCLmmvtyL3FvEYIORDR6bf2gFmoVBoYgHL4lzpGenaHx
         l/MjxLo1UAd5f3/7ACVwTd6TYNwBka6KHPqHVZpFLZozgCcyoQvoy22YCZDR2oj2NSJR
         ws+2aVTlb2ewPsZvn0CdomgZHRpjg7PjrbRbzNk8VDtEkVEW9plRNejyE3a0QFM6haQU
         4ZDw==
X-Forwarded-Encrypted: i=1; AJvYcCWtM593gK5IvNgmvju1wNuGpRbTBBbMfdIo2T1+GQLZ5omChZ7LJ/tx40P1jnB7q5DUc/UxvkE9Pw==@kvack.org
X-Gm-Message-State: AOJu0Yx0Vn+kXPbGEpXsC29zI5eThs+KTjUs/kHf/ouWcf/aS3zsL0Q9
	vN2FNdCCdIRCFXBFtFFgijR3r8pELY7wvbYv9bmgtApyxw2Dc4mCuW8t
X-Gm-Gg: ASbGncu88tLDLPiukKw8bq64o0mES8And1AYzXA8yPoEBhs6Bt4mfQ8QTDFyz6VtD/g
	5nqBSmqcctXcMP2Jykc2aEhbDx+i0qsjpQXQrxLfr5WmEIcZBhuumUL1K0CcTCrdu43bTpuhGZv
	E3czrwq+78XiE+d731ojJHfuYghCZd1meMHNf21rzFtaIw1BVibtFVaAIHCMNIiD949BDnrbyhs
	GJEIpIZ1VS3hg2y3Z4tKoxph0rLjkNEmwZs+/fAVNf7WEhJbr8mJA/p/yPh2Bj6uTpjWi9o+wLo
	LLLz84lKRC8NgmyjbksQ/Nl/HBqX+4n267AxwzmEhSjnHlDDsOo+bpJNQVd0I9YrjJe11f3kJyM
	5P9d7zHi992GMzdL9x6noESnKJGcdf3U4YTYrU32rg413LiObib94kg==
X-Google-Smtp-Source: AGHT+IEkuk5DkkrSXb8g61jXiyuwFe8WE4pg2bZKktTui0p034jBJ+2UWZW5+vUGLJdWXD5cf8sXMA==
X-Received: by 2002:a05:6a00:3283:b0:76b:2834:8c5c with SMTP id d2e1a72fcca58-76b28348e14mr3030492b3a.6.1753885390071;
        Wed, 30 Jul 2025 07:23:10 -0700 (PDT)
Received: from manjaro.domain.name ([2401:4900:1c66:2c0e:6464:f87e:9efc:7514])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7640b2dbbc2sm10148099b3a.95.2025.07.30.07.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 07:23:09 -0700 (PDT)
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
To: akpm@linux-foundation.org,
	peterx@redhat.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: linux-kernel-mentees@lists.linux.dev,
	Pranav Tyagi <pranav.tyagi03@gmail.com>
Subject: [PATCH] selftests/mm: use __auto_type in swap() macro
Date: Wed, 30 Jul 2025 19:53:01 +0530
Message-ID: <20250730142301.6754-1-pranav.tyagi03@gmail.com>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 639A9140010
X-Stat-Signature: 6uj7m7fwx35h438y3z11obphon5d4uok
X-Rspam-User: 
X-HE-Tag: 1753885391-499739
X-HE-Meta: U2FsdGVkX18cWSrsumu/QkDydiZlkuP6nHWIKP7R9vwh/p1TgUYTBj2KDRLvVys5TOUnNxr5Wai+6ltoWM8kVbc2YcK2mlreWdSmmmftGqrz5TRyJCpbJqoXELf1jBNQM30vAu3cK2jjiyJzkat8CmAxwjGKixcp6x0fz/UzDIAfru9UbU5KCHwoFP/7ZpjnNO8N17O0cmQFsVp+xtdcBssnW48WUjUvrWB0pZ7MRs3FSKT/nh0nDFNVZR/JkVAVcPfmeGSwv5XUnlVboqKwAFdJMnh68AxK3wwvGiRaonkwYzTaCJMtnTYFwAgCckZ3nAEQJdbDYF4wSpjR1I27HHHz5qwNzK0Z/MYkgDtC+zAsekYhz+W59abIA7h8ZZw3vBrhBqaG3OxZD7uaCzgxNuwWfes7tvDaLfSnqhT8Ll5uaakCVyizGgFbabOy355va1LBl4yDnKrI99N8FD9/6lnIyGPjp4Jt0vaAcEOda3hTG0xuQgeMZhvROtO7DYnIAnUqMVODIJvjpCqueWHh8errnB1hH4AXumIWBh7ZKuIYJ8LzZUx4bfgDYG7gIXm8nkVjrx4m3lJIzVWln3CDhkGiIDnRxjd37l2kxergtypJfyrSFZb+0F7UQMT+idYOKmR+h3Ea9s30Y9b4mwsZ0NW9W6nUZHlWsE1tkmRJYkLtdAG6IaviVaO6eo33Cgc/x1gnsBvPxYEIJqyOjZCYtxgsYwgknv/HTOmYHxzP9vwWMtiCfYCCAYHpVwlZNHURhRmGCcl9z1A8aK9wj4a6uJm9dTs6tr1BZIaR+b3YUmdZ+5sSY350uNc3d55Pm0DNr0XtG0+nihpg39SZLAVP/wyhnWTGcDLpKYZ3WeOhnLbnKjatUZB9uw4o5Ng/9OG2eLHQ648QpnFCS7hIzgw0la+6wSjGvpe8b1HO7oOvbow7NNei5SMYwKojPAudf0RVILGyj72INoFMEIShxXP
 a7bvki2H
 oszGdkLtD39iouBsb1jBTZAQKVzcoQRAs6EOYwVvlxtws7SDqDti36st26UTmOo694S6prGrQ8yPy2oqsJuOvXH+VIv6HuMoTxXk/Q2hQsZw0d4unESLYLgMCk1amyzayRwFHlhz9Vtiv+ilvuGi582Ck+qXLkxWfB8pycCLoSaUIa70B0Bq7QyybLYE+d2nQOFUkk59IPEi1ZLGKkCAhiLMW2qNGcdwA8pdt0HYn730VBX1q2XRPXe4N0XL2Aq3ipoatosHkX3SHRe5Dkb++sHuNAs+dM0JhF0UteyBdHvmtLZki67AFJUQmSwln86l9fic6idQEw0RSnoFq2lpdhsfPLIJxCZlrUHvq0ViZUBT6N1r5nH05eeArCQ0yz08k57s4OAhzATI5qBfp/cQASNFzLiabgJcJX42OcvJzKbDNXjlKpIkXpgkTFhI49VxvvvEWJO6LPQETlZNQLcRNOZ0aE2dq7upo1wZzfN36pgq6FGFIkxQYTXxQhYP0ytccX0njDz4/ArlKc5NiU1OLSRg8UPpqhGe/ZOrXAYmqYBon6irg9nUtaBWVi0MTKfynJ14Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace typeof() with __auto_type in the swap() macro in uffd-stress.c.
__auto_type was introduced in GCC 4.9 and reduces the compile time for
all compilers. No functional changes intended.

Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
---
 tools/testing/selftests/mm/uffd-stress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index 40af7f67c407..c0f64df5085c 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -51,7 +51,7 @@ static char *zeropage;
 pthread_attr_t attr;
 
 #define swap(a, b) \
-	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
+	do { __auto_type __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
 
 const char *examples =
 	"# Run anonymous memory test on 100MiB region with 99999 bounces:\n"
-- 
2.49.0


