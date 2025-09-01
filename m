Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7987FCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 20:50:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33BBE8E000B; Mon,  1 Sep 2025 16:50:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EC4C8E0009; Mon,  1 Sep 2025 16:50:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B4078E000B; Mon,  1 Sep 2025 16:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0BCD88E0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:50:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A28361DF1BF
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:38 +0000 (UTC)
X-FDA: 83841874956.17.A9337E2
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id CFB5D40004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=RAaYMnIp;
	spf=pass (imf12.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756759836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DOUVRSUkKssTlOViJjAfm2Ry0I5gABWdPNOlGM2jpT8=;
	b=sa0Eh+gsmLtpp0cJIx427gi4DfvCYdVSt3DaGzG5qnf6LjZoynfaPf2O7w6BQp/XdezPin
	zivdO9AG42Q/NmGXI/zol2WHN9eflhIB1mgolhufnqAVr4cVOoXMApzzp22FfAd1HSnTe5
	IJ6rRxqB/fIa7CqXsKafqGf4QTV3aAc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756759836; a=rsa-sha256;
	cv=none;
	b=2XOohmwe5F32brC6Xb2P+4aTyizlnkcgaCU3yjanKBn1DVxGvD0fx7g+fcx+I6FWYNNgmH
	WtvmI7irLLFcgLFhoyzs64olkHHkQmZ0h10Q/cDPQW83Lc0H7GurihkRShn4r1sXKOv8UC
	37ZGdOh80vdC4g4lqJtjiiKQbctwN8I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=RAaYMnIp;
	spf=pass (imf12.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-afedbb49c26so718837866b.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 13:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756759835; x=1757364635; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DOUVRSUkKssTlOViJjAfm2Ry0I5gABWdPNOlGM2jpT8=;
        b=RAaYMnIpxtaSAlmdg4RvAHBBuJNJzp7HjwCWYCwzgFPKcr72GV7IymHmMH3l8rc8wC
         RCFx6qLlnF/snjPOs/1e6qgXAHg3vnAOXuMYm9flwt3d3peRctjdh+3Dt40v+nrv+59v
         kFsQmrw7QtU3u6pdxru+l5NLRl8+zRul9tBHqHqHTg9vM3qbMVPlP6xzDxm9yZ2V+Wcm
         BLuVfTkX3DPs6916ZPP2HzLYuICis4/Tbrar1KiHVmypVMEsxnCh+Fu5GiZbhGXieoqD
         SAwZtt8s9h+sW5d65kIAfuXs9gcgsmH1kOjnqOnxY+Q1ZzEZecb2WS1K0fHddj7fwA0h
         6kqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756759835; x=1757364635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DOUVRSUkKssTlOViJjAfm2Ry0I5gABWdPNOlGM2jpT8=;
        b=hMvgrQD+58U7z/ChtdKWv03ynD6MHmCNF1UzOKe10RX7szF/oWPgKzzQo65VtQS7ac
         FbL6ShfYJLMj9T/jSP3XppPE05mCKhtQOzvsEtu1wxJYRK9qz2PPceLB3wyMnguQCdBc
         at7QM+Lzc0INBSHs6yZToSptuv1QPX07ge01TpFmSEoDM+FLIph/aGiqZCGk+L0Pc0Rc
         E8m1zLBEhIkq63ydKrkIyn3nRDv5Ga1nn659sVk85dJebTB58/8P/3hKNS5OnnZm6KVl
         IicMBjQRYWIZG/qZ5OxXoBZoQmA/NO0UN2wtdPKZosKdLz9H2XcRU3lb+iJCLlOIdVRb
         Y8LA==
X-Forwarded-Encrypted: i=1; AJvYcCUCNWZuk3acKqfy4CnQeKWZzbd0j1eOzk856drXSgH5MwGiUsn/+jnazKikB8zT4IRW/epZzwq2uA==@kvack.org
X-Gm-Message-State: AOJu0YxfGJEVEyuspG8nB4MmDMHin9+ZYuQY7r23muA6lzliCUFpvVdk
	fPpMbsAwAPYMDuYbVfMx6BDXGwbfXczGjvonjelU66IMKGtbzFER/c/LTTTLBPMS1Fk=
X-Gm-Gg: ASbGncvkW7julVwnaNQDXQTF6PHRweSJ6pQYi2IniMJ3Z0HF2L4JBsOvVBUPumoFNtB
	j2DzP90ftrFTZZTezFEl6eGaAPoVXUSkbogRDB0c2cnxFqNKolzOuGM0bl2c+b3yVWcGRarHgEy
	h55nRJm+p0MUzfaxNyCfT4KkEmavEBiG+zgXnBi8ktmmxcGb/O0Ew97GkHvxXCRgjnwE59wpUdh
	lLcz9psYWFohCQhF3BUeo6IVDbMNh3KtfC458q7rMxSn4mMjqcNLRy9ol2lAtpnqXvTvmmORc/O
	HcakjsUAx0vsF8L19i6BCetDbv53nMoecspB2Gb7Bisqtmel6wsxLvSnfw2xrD6hcKv5SzJRWRx
	wGpT9z6SqzBD0bN+CDWK5DbRpOYRAT1lwXBoEeSoxYA42CrqGEtFNLC/hAafSteZwtiSwEFXQ08
	Fcl9r02aqBj8UF2ilHxN2aqn7uXKbnfLuf
X-Google-Smtp-Source: AGHT+IGigtKDXFUmdSAlFGcDTy1NmHrauWomJBx5FIkz9t/2ArUf43T05qd7+gJYKJea9RCwhs03Aw==
X-Received: by 2002:a17:907:e8f:b0:afe:8f28:fd5 with SMTP id a640c23a62f3a-b01d9719057mr990403866b.41.1756759835180;
        Mon, 01 Sep 2025 13:50:35 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd9090sm937339066b.69.2025.09.01.13.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 13:50:34 -0700 (PDT)
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
Subject: [PATCH v6 04/12] fs: constify mapping related test functions for improved const-correctness
Date: Mon,  1 Sep 2025 22:50:13 +0200
Message-ID: <20250901205021.3573313-5-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901205021.3573313-1-max.kellermann@ionos.com>
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CFB5D40004
X-Stat-Signature: jnauwpurqhrdreet8yj7kpjroiz4trz5
X-Rspam-User: 
X-HE-Tag: 1756759836-426837
X-HE-Meta: U2FsdGVkX18/jfhjnjS0ig9pNlBZ7zpsAHnX+yPET+u08ns6/bc/cik5JRP5HbhWP00ioUw4XiMgLgfAL74ZhUtAztniAXC9OtguEDh/r/hI105T5JNj4a5OywzOEl5Rfz8UyMYhc76iQZa0pMrMPl1doHmcTj1ugjLWlPaFDNb+UuwuYMJVVjw0aXjv+0Iy4cF+qKGNcCMLzZ6oLzjcESwHIsM9PvMLN0JQqgyQeDzIk1MZoLD3iGeQGX2QiiZfCNWKVF7S84E69gzNEVWD2xDH+9fRoW2/UhRzj7f5hSM6RzTerdmiB9flIIDrH/v6yB3M63DqkAM0rtCsKjeCTTqO0H3rm8CzWVKdF0LD2AEQvJfYX8td+sieLMrAmsZESR67eUNtdZqPRFAOAS9e2SDoTN3OBVkAI13lb5tR+ZaRj+xkVJZc2hm/4+QwrTRX2A5yKvG5drfc/5njGifu1UJJWmn93CjXHC+bJ/ZPnzkz4AGqAaOGKmE1bcMOkosOeQafZSxJVN/sHZfakLpbl1/7+1Gt7wSabCXkIs11i+3lyu5/xVhcfXvoEOzRBANdadwzCQg+yDalZAFuk2l91awZNoRfAggrU4GeQ5oTGGLdSwhsn7qjdPgqTV5yhkKUv4PL8zODHxyLdAIypoU7ISjZOMCSASlsQBM9udpHe+kx19fG0jLIyYWq2zRR7Qrd+Dgs6v9020Q5cq7RdBjeOMNwm0fdYIPH1l4/kWKW9zcw/G5+yVMDj3XHt9bsZCruu1XdiRpLzt/YhWH1q5oMvqSgEsneEfCEODAW7qxSxlTou5j+vGTe17wEe91Lr+T7UjWEvxkziLs55AocK7zzsxQl7QEw45fxJ9JEZKd545gk9MQmQ8kN7DysWM/fd/tayQ/sOWhXmUf3csd/N7gyQTLlk5Xu2kpk5gEdlQsnfYwXEXaj4Cnn5fmb0G7fWrpcu/5H9TfBwqpDXdn4ZZ+
 kxUd25Hy
 BbnqbqjNmACnvH6PCBkroUX6RGF19s5maxk/5JXYmBMxNKHWcMiV11p3ANQs9+/f8fdFnCzlw+AK/n7zlPN+rMbnL6S32DL+Krjc7fXKvA4fNDwbfh2ahUiodMshV0URlrraHJZy3dXJBI7MdWIOUG0ZWguYCgxdzpogKbjrXw2EhJdZxwwn5LVql3JjEfVIbxjdJzHIZIqPIZ7wG2raa17dRB0qI0XkzGRctZ69CnAtXz0UzqIdHNrcugIAYV6d4kkLpmPd7mkI2QVcupm/2EIhbKOZ3EMq3+XGC/RJ639sb4OUotCnAxWrFfOigpiO9STmXiYHFsICibwK2FxQhx6MLyypHiwQ46q//JAxIvvNeUWhl7aeEbEMvacWnQWcLnEWOhtwlyHbvL6PI7iuifvYvr18C9UVCqp4hcD/iHUHr4srhZ1LMJkgf2r8DbcKiz+TcuuvqvMMEGeDiBbCR69DK7AOAP8bfINJyZUJBkr/CuWKuYpafBPpCOlW+V6Zb3JRm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We select certain test functions which either invoke each other,
functions that are already const-ified, or no further functions.

It is therefore relatively trivial to const-ify them, which
provides a basis for further const-ification further up the call
stack.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 include/linux/fs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3b9f54446db0..0b43edb33be2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -537,7 +537,7 @@ struct address_space {
 /*
  * Returns true if any of the pages in the mapping are marked with the tag.
  */
-static inline bool mapping_tagged(struct address_space *mapping, xa_mark_t tag)
+static inline bool mapping_tagged(const struct address_space *mapping, xa_mark_t tag)
 {
 	return xa_marked(&mapping->i_pages, tag);
 }
@@ -585,7 +585,7 @@ static inline void i_mmap_assert_write_locked(struct address_space *mapping)
 /*
  * Might pages of this file be mapped into userspace?
  */
-static inline int mapping_mapped(struct address_space *mapping)
+static inline int mapping_mapped(const struct address_space *mapping)
 {
 	return	!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root);
 }
@@ -599,7 +599,7 @@ static inline int mapping_mapped(struct address_space *mapping)
  * If i_mmap_writable is negative, no new writable mappings are allowed. You
  * can only deny writable mappings, if none exists right now.
  */
-static inline int mapping_writably_mapped(struct address_space *mapping)
+static inline int mapping_writably_mapped(const struct address_space *mapping)
 {
 	return atomic_read(&mapping->i_mmap_writable) > 0;
 }
-- 
2.47.2


