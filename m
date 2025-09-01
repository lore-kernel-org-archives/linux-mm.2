Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 716FACA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 06:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4FD48E0009; Mon,  1 Sep 2025 02:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8D78E0006; Mon,  1 Sep 2025 02:12:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C79578E0009; Mon,  1 Sep 2025 02:12:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8C488E0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:12:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D4CA1A068E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:42 +0000 (UTC)
X-FDA: 83839662564.26.59E9B33
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf26.hostedemail.com (Postfix) with ESMTP id 683D514000E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=FK2LALiX;
	spf=pass (imf26.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756707160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+6TrnZpXfWUfs5R5hmEGqosfCHRnwv9JCMokN8V3u0=;
	b=0eN4pK8dzsvBCg8Y1qLntJ9k1CdxenlF57/m/yK2gwVzl/XcVpOBO/GW8LVWK6EIM4HfbD
	9mqef1Kh3zeCy/gCg+qemodLYIIGxSmDqLb/Zji4pl3IWXVGBtZ9gc4U/pTQZEPxTRw+Cl
	omKjh4oAoONnHioOxJDSz3BpF5mw0LM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=FK2LALiX;
	spf=pass (imf26.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756707160; a=rsa-sha256;
	cv=none;
	b=Ry50UtIYZZLkoUYsDnexu3m//oLXTm8F1dzwVg1D7fcgq1oWuD2rjXkQ5Y5aVEMehIlxJ7
	2UFLclXl1YQWY1UOHSEQf79DxdryusGkPcLz+1gB6C/aTQVqA8Gq+oJnz8EXoi65rhy3KH
	VsB8Cjav1jObDp/XsSdO5/3Y6wNVxJ8=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6188b5ad4f0so5178560a12.0
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756707159; x=1757311959; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+6TrnZpXfWUfs5R5hmEGqosfCHRnwv9JCMokN8V3u0=;
        b=FK2LALiXacUGltyY73h1Sl6dOCY99bQEA0w2k0pE7o/fI2rPh7wvyAPwkAMI55BMhj
         l4I2zaK0SMEB8y6oLOtSNSHFVCW30A0rI3CQHmJDUPJe4mKaw/EzrlF89McOjwDFB9T6
         Pu5Xj700y/OTNHjQKb2FGRABnG1iTVfWIp0/d0XVoHzFfKWqlAuHqEyQO6iD1wA5cX28
         Ms6NmuagLjIbWNO+OmqHi8kN8aMjSgF95SUZahcjgKVXS7R65NDJnQWQy3Me4uf+9MKM
         hwmvPgtUKP4l/cdkGwofKQ5gukjuog6VaWPTYm6HdrPnOt4GmXJ55hIV4a4WB9yp3pdv
         vJ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756707159; x=1757311959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z+6TrnZpXfWUfs5R5hmEGqosfCHRnwv9JCMokN8V3u0=;
        b=ux6zCtgAHeeTmhrU3t1EjAiG0FJTk98RAqOfVD5FTbnGWXuPlnOdHNPpDUErvSf3Xj
         LAsYSBjyrjDoADepG+gaNC2v8Y4AlpUCX5yIXg+kiRZ1oHHbxxiK9aVTLZd+Ctk9fraw
         1gdRmkylqv5xJKlp5SE1MeRtdZn6s94ZiBWlDjd6xTYKfH3Z/MfFUBXraMNVPIObkytl
         DRSf4cVZjZolZspJGF2fMQRnUOHyjZ0blJuRiN8NkGfYSgL7zDWz7fhX1flP8wqY3feJ
         EI21T1IRdrutdh6p64bCkLc1fR6wy+lTVH5vVevIW+D0svHAU7+xWKstY+Iciq40DKm7
         1Nkg==
X-Forwarded-Encrypted: i=1; AJvYcCUP2jZLoNfpoj/khf34f70bHx1Q5FYi2SVpmun4BgsdJhKCq1yvi1IbI1otkAE2fu8vq22rZXXhUg==@kvack.org
X-Gm-Message-State: AOJu0YxQm2rMK7r9ncHwogobi8x7cLDwFy1RBn64Rj4z9gSoR0+CZcPf
	ruG8PKfsbv97eO1uI/qEciQe51BQVreXet0uZvhfb1JGy7oJJGsUNnmII3Sx8oa5YX8=
X-Gm-Gg: ASbGncu62/rt1EmFGgghR2PQUoUySo1Pf9hfH0v9Kbo/fK5x7YHm8lMIWqQkETBiYBv
	qqQigArTdNe4mwUicbabWLW01vY+IPMvkxTARo4y+3WgyCiemMlzVM2e+aNS8atUuec0FZKy1Pk
	3XsPJMUL2mH03rCpXhphLysgD7DMxdWG8q8xSmteAG99NUeRMe1A86AwMb0SxLDAmArNNeeAK7H
	zlKBvhMU+uymWKlWHRVHky66jI8N2Lc5397TlAyEOnj2wX8HTQQlI30i/fD3m+DqXCdy2KxRIG4
	KwWuDpfOY5WVt4QCU0fAXyJoh8rZLX9N9P8G20EDREpiSIQFV7YXSK2ZLwo9uiY0S6yM8hKeLVy
	/44JJdpOd7yTn/aAwe10puip5pV0uFHpIgnWoQWkhAOFr/ME9oWIGwTXn5VfZ8OMliCi1QF4iih
	a3o4QZXUZyn/snaF7sBqgJYg==
X-Google-Smtp-Source: AGHT+IFWkdcM4RcAmhz/n+Efu+qXJCifj1zR/DVBAtOqTkxm9VZW/RyLABBNVHQDHruJ7fqXDjXWyQ==
X-Received: by 2002:a05:6402:348b:b0:61c:5342:7d81 with SMTP id 4fb4d7f45d1cf-61d26d84f7emr6290550a12.23.1756707158967;
        Sun, 31 Aug 2025 23:12:38 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc231561sm6374533a12.23.2025.08.31.23.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 23:12:38 -0700 (PDT)
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
	vishal.moola@gmail.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v3 07/12] parisc: add `const` to mmap_upper_limit() parameter
Date: Mon,  1 Sep 2025 08:12:18 +0200
Message-ID: <20250901061223.2939097-8-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901061223.2939097-1-max.kellermann@ionos.com>
References: <20250901061223.2939097-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 683D514000E
X-Stat-Signature: hoztiw3txwbjf7g1a9pbkx85sb45xdjz
X-Rspam-User: 
X-HE-Tag: 1756707160-771922
X-HE-Meta: U2FsdGVkX1/mLDFX1VVWo9ttsJRTPUi3qwS1M6RKqoPO0aqt95H7A2aBIgR9gKp7gm66zzHai0Q2G/02dKdpvby/IoguffGCpNN7By/v4MvDyxtLi/Y/FG0eCRxMD7TkM8en/TqjmbVWd78tU/WCxMMyc9j5EWzOs1G7Vy0THQ+g5jC/GhLR2ScUlaYwyZ1OlOz4WIAAqhlllpX6PrlTDnFydyX7DILPetJQsSnhP+mmyLVETw8JzczdgkqOaMPFMe40t4mLfd+4XCw5NIQJZLw3lG/iVRGz/hIStdtkQyEoseDxzM/UlNUZgivECz3o2w3AXzhjxunMpPImukI5nU7mtxL/snL+NCuetyhpisoienQb+WLalMw6MYy/JuGCzUjBaVuQADJOjjINazv0pOD7orSVxVUfd8vdu6e69N8b4lfcTJ1g0sDIB2IKyk0VjbmfaPNNge46lE+AxPu1c1F72MNo+naNEx7Wm2NJu0rvyBO+EaNFoCWWn16Ouvoz9TwycePIbXAVp3wM7gBMHcVue3L7Awy4nUzwSQw7ChEfDeLSsJxfgMtKdw22IQSkbrYiAhf7CcXVTmkjbfb8XnAxu15J5yS8JrSoayMBGunzXhkPrGI2YinR+DEl40RCxm88JDo/MxBxQP2fiaEfCgbJV5XGAnvt55iSESC7/JulcZoGkZY+iql/EcmPuFrhP7cYRPw5otKHHq+UhBerXV34INOLechMHXVoMggQ/EQK1Bw7TOSiklAX3XwONUnyMYlvoY5+puee01ktWwChvThjS3VCf+KYYDud0cX7L4JjkX5oGmIRT+ecejq74m7NgQFt+a+9c++poO+2PZVQz8I+LWA5EkJsUuIFET3RJ4H9ePUKmaMIp4iy5YTfcKjMn21LZQGlGiU1EO0ewMBTDIE34LjkaYx+xORIuducaqn1MWqPP63x8LRNs3VnLhpd0pKwBWo1tPR3lqhxgib
 8MfM1PEk
 HRLwb+/Vvpq9wUoFpGRTuMpweBL0ZyZ2U4gE1NzKgRyYEH+EVg8skKO5vXae6jq+R8kp0JVZhvdqewoRqck48UQRDjX26W1fPJX/ptP4Uc/wjmwbbJod4czrs3n2OdaoEosg8qA2WDUAqDAe68dpfrR1x5a/mdo+oRKyy8OYu23ovsee22yg2bvjjsHdWR1NfEMrxfBIcy5WHleZ4SzqX3qljW8mDJn6vutnVd8lc0Z+FNS6yIIY+zB20dF8IHQvbv58q//HdqkfI0KgfK5dfqHELS57NYGLKyUfvgEuCIV7+GkIAeQ65trY53F5g8McIhoqaksjnSF641+GXnOKd07b0MgEwJBNSW3tuiMP/dgwpQnfVbs1rzvg3kIpwxRXE/i2wZn1Kss3wNwoXLH+dqUQOAxzj4A5Kg+Avio32qVghggZo9WntGnFWS3mzAOt+eEclDa8RbJ6FCJpgYBqiwFu3ygbFJtsnK8uf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.  This piece is necessary to make the
`rlim_stack` parameter to mmap_base() const.

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
index f852fe274abe..c2bbaef7e6b7 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -77,7 +77,7 @@ unsigned long calc_max_stack_size(unsigned long stack_max)
  * indicating that "current" should be used instead of a passed-in
  * value from the exec bprm as done with arch_pick_mmap_layout().
  */
-unsigned long mmap_upper_limit(struct rlimit *rlim_stack)
+unsigned long mmap_upper_limit(const struct rlimit *const rlim_stack)
 {
 	unsigned long stack_base;
 
-- 
2.47.2


