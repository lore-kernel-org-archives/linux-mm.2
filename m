Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6BDCCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 20:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 316418E000E; Mon,  1 Sep 2025 16:50:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5FA8E0009; Mon,  1 Sep 2025 16:50:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167DB8E000E; Mon,  1 Sep 2025 16:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 033728E0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:50:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1CA0C0A07
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:44 +0000 (UTC)
X-FDA: 83841875208.18.D7F4FE0
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9274D40009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=GFTFTzEI;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf01.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756759842; a=rsa-sha256;
	cv=none;
	b=lRknRBdFcPA45pKePw+4LoY8khS9wBGWaVfyesVzFVA/37mIPczV87SfeaYIFPBO6P67VZ
	j8if31YF4toYT5gJOutMG7+5aaPIt95bqpcGmxLl2d8QM5GJtN12/GjHFMgmmOD8iwGIqL
	HsBl23yLcobBXR1ITiFqUiobZuOHcUU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=GFTFTzEI;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf01.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756759842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JbC8N+XiHIHVwpnYZGh3ddN7VzXCXgVoQGtIXVqNTy8=;
	b=XIyGHHUg0OmLv9sXua3r/K/67RtuLmx37kZb2TKp8b48CMjanW+v9UFNG0/PxKkUG+sf6V
	1tG5tE2xcEwyoRSsKckgoqnGC9S4lGPda2PxxuI2F9xmK113sSvCUxY34pVH2Z00K+l2dW
	kas7+od7v/OvQ+iEJID3QIEfJQe9GBA=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-61d3d622a2bso2222874a12.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 13:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756759841; x=1757364641; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JbC8N+XiHIHVwpnYZGh3ddN7VzXCXgVoQGtIXVqNTy8=;
        b=GFTFTzEITIY9JFOPki+KJ+GeCFqw7dvzgHY3ifysGTYH4jTfoZBtyA/eew0ZQViKOX
         yAdlpQu9jua1EatjocngCZ+2f2WNBbmQazNcbyahQbC/vm/660JsD6APnQIDV0YIJIL3
         ida7FDmjG9eDdJNVpMMMlO0JsXEOkg6g/YeJKmxFgwxJJvDokwu/fyzgDR9KrPixUIUI
         h4xwAaU0QOS3pR3DBW0ZUw+F+DK3eBGkMZbZE6Vd3lFG2pbp4iYETyYoh0krxnsqqM7S
         KMUixtrjo0nFOgikZu7NOpMw5yP7LZN5luCbZjVNo7bPQkfMBSMTAB/NcYuhCxMmIgVQ
         bEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756759841; x=1757364641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JbC8N+XiHIHVwpnYZGh3ddN7VzXCXgVoQGtIXVqNTy8=;
        b=MwAnbpwjBUJSCcw4Ef22l0VxO4Rcy3eLjOS7qYFyR1+C21fL7md1QcPqSsQPIo8dRX
         WNCfvqka+jiW1s1oVhwOCb6t6LZJnVyXiKFgNikDOl3PjAf3riQUN9ADF5DdYZ+p8Tey
         LG+4zoCbVPOIXbqdYCc9kIHQe00+3CUxB1MT1mDGHhTte+vT7P+qi41ifpcRWyQxHePs
         wxSKmVYUj/Td50aDHS+8qS0hYFawZzlKg6SuxZ7YgFAKfGx+F/6ZuVub0n15wM2nCoSD
         FmZFBHk+N+50Mpqp8zz7kRLRnyV8XJxswHoM3Tkv5CxifIoF3qn7V+Fm0RcdvrOB41u+
         8yjw==
X-Forwarded-Encrypted: i=1; AJvYcCUcR3wVOIzi+w66reayDKREYRS3RYSXpFQFYubR91quK5xdOkoBv0uPmx+eFnk1JMbeZB91TCWaPg==@kvack.org
X-Gm-Message-State: AOJu0Yx7N8Kd07m8+kOcgBHsQTmRKSS/E0TYTDeRZDiemKsblCQNzBxc
	XR25jL/QDlxTVB9T08G6IcX44S7hgZfnkZs5papvINdn0U+h4LmV/jCp0/HU4RuxY34=
X-Gm-Gg: ASbGncvT1OCTpvFyFxYmCkzpBKs938Qw8Pa92Bq3sQWpn4lcM18zLwtUN8tZ6zCv+Pa
	IJfm32DEPyLNg1TIedTey7EGqNXJsbquZjBYJY3GK8yEyA3rQQOC8oonrwEiLsJth5ykkhNvu/g
	oPbK9AjLc/MkWjMOXuV47pL72uNt9DybIX+4sHOdSljTU1ycTiXax7SIrDN5I8sVxHODTzTw0Cb
	nMFPyDWDKEI1cXf11B/7ShCe4/Iacjdf/ZZ7O2Mb4wp6QLr8xRhyUOnCSfWyXewvchyciJwMeeN
	dEo91nprTWEvBPu9wGiun3cItoVtMh5fkWqglwIKmblTQiABJK8GKpoAxGczSYqwaZAkCCTqNle
	AB92Lq574A6VDmN5ojcQMTiFwCmxQcd/fUXIJ6/jYNDXnRBEXmO7EXYLx9UqTFljc8rQbENGemS
	QbXIoW4Ku9cZir0wS0NDAX0O8i/2jNUxh3
X-Google-Smtp-Source: AGHT+IFaWDHYij5j1CBdsPx53clPCy+ttl9kO3s+0ZW4mKhtLHQkGphieDUSAGfH3AkYqVOXY7BH3Q==
X-Received: by 2002:a17:907:6d28:b0:af9:21ed:6ebe with SMTP id a640c23a62f3a-b01d9754485mr912367266b.21.1756759841055;
        Mon, 01 Sep 2025 13:50:41 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd9090sm937339066b.69.2025.09.01.13.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 13:50:40 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 07/12] parisc: constify mmap_upper_limit() parameter
Date: Mon,  1 Sep 2025 22:50:16 +0200
Message-ID: <20250901205021.3573313-8-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901205021.3573313-1-max.kellermann@ionos.com>
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9274D40009
X-Stat-Signature: n71w9gtjx8agsanxwe1rwwiqmc4uwkpy
X-HE-Tag: 1756759842-643872
X-HE-Meta: U2FsdGVkX1+yQhG7o7p2qlCwyGqEq4HFPHUe/DlIBKffz6IGv5WGg6oNCyFPEL/8aOtDaY+ERvZLgJgGbON7IZBknaO5Wj2aLtEZdJTLzh1X5O4DqlCDMS9x6BFz/s8vWU+tXmbmMz8VKs8z0qwA4h3JOr1+95wkwElktIDkG4vmCQ7mC7Lr52svrcavj4AiG+dlnFYi2YxjLSB3sC+ZLAqrzjTrSiy4n3/3bpUXG2uwdVqeqQY2Wf5g3E0zQuphvwQ9lzLV1MK/hGPbmwo+yWN0zDqkV6pqCnw9R1i5sEZuV9fONrTaNMDZihxTVrN6fgXNCqDNIrsFeiH+Vd0RToi24RRvic/6amTjY10ErkLlAS72CpjnS+C5cBCUJemYGIdve0TwJfo39FVFpPy7NYwtC7/LmmrzY2apG1PHafevUmxNDYaCy6Q060eJNsow3Q7L1nj1KTy2kGXgx6qs2F1aX8+MCLBi8fwhrN/+ZSk54lNwpghsbxb93kTkd5ilCM0g3SMqIQmQjeHF6NG2m0bPEL+ljj8yUH0/RiwrG2diQhSFRF+VSZ+jF/G3CDeVwyH0zGo71VEJyLIqg2IYXcmKi6BfA7z0brHP1ICcavcqtVq8xGagL+Qk0+NvXe/L8/aEb754L9sE9IKsJgxYg1JPtasJHCUhhx+dBef40fM6SsACDggc8Kx3e5sy7TGHKckN0pUcNi2cv1M91mdXr9FI7c2kpquQkGdxomEwUJrA94jMw/t5mipN47baQn9knULIw13WK7gVVO/PXY/HbU6tzr/rF80QWWsPD0eeK58uN/GjnrTI738W3FhJ3FTMFC7cp4U9ff94Na/fcWseH1CKwM8hs+MOalUTl4H8AQt3uXodPKfUf0cAYkYH9ahT9tNHIg92ZZpffip1NV+B1fR4Qz2hXkzjQfUkbpoqGAYoWn6rd15NyS2CN65A6tZ0aPjBxDJSDl3BrUUhKSb
 CFj6p55Z
 dCqvGwfkomGlgzYS7OJ43R+fYx044bG2Ga68zbIGGkRhlddfYF6tr/wbap+MiPSUENeNdUYu8vaz3p5sJ+zDu2gf36gxZJmaAiQLwW96GLBI1xzoZPdeeYBcZbZHtSflP4XmhmysO1Tbio96pZesU0+ICulEHk/XN5LhKaKhOhdzsyKPILOANiuJFHof/+j7+ZIhh/2gpfj0Vs0hdsOjUHkJFzm7pZ2sGhq1FAfeS0kJya0fMILkOpfKY6Gm62VbtV7y2RnFnQHnlBPkFYORlHCQZUJb8dbIsoAVJo7uTqOvEfPhPjdiqciaZqb01e9Ljej1CL2hQTvFHNUttNxe5pD3fgr6WcNu4xjVwjcuK1b1znnNgGF37rfhwdKdEJvc3zq5DWAZ3ADgtQMcy2RPXUSjkqA5CPxI1OVUAroIzH3VycDjCTNNF+Le8KaKDUHjnOwpYhcwiwaHxXsICbuFX7tJ0BQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

This piece is necessary to make the `rlim_stack` parameter to
mmap_base() const.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/parisc/include/asm/processor.h | 2 +-
 arch/parisc/kernel/sys_parisc.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/include/asm/processor.h b/arch/parisc/include/asm/processor.h
index 4c14bde39aac..dd0b5e199559 100644
--- a/arch/parisc/include/asm/processor.h
+++ b/arch/parisc/include/asm/processor.h
@@ -48,7 +48,7 @@
 #ifndef __ASSEMBLER__
 
 struct rlimit;
-unsigned long mmap_upper_limit(struct rlimit *rlim_stack);
+unsigned long mmap_upper_limit(const struct rlimit *rlim_stack);
 unsigned long calc_max_stack_size(unsigned long stack_max);
 
 /*
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index f852fe274abe..b2cdbb8a12b1 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -77,7 +77,7 @@ unsigned long calc_max_stack_size(unsigned long stack_max)
  * indicating that "current" should be used instead of a passed-in
  * value from the exec bprm as done with arch_pick_mmap_layout().
  */
-unsigned long mmap_upper_limit(struct rlimit *rlim_stack)
+unsigned long mmap_upper_limit(const struct rlimit *rlim_stack)
 {
 	unsigned long stack_base;
 
-- 
2.47.2


