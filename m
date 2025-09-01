Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6344CA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 06:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F3DD8E0001; Mon,  1 Sep 2025 02:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107AE8E0006; Mon,  1 Sep 2025 02:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01AD68E0001; Mon,  1 Sep 2025 02:12:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E62478E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:12:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A285BAE6E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:39 +0000 (UTC)
X-FDA: 83839662438.28.F988943
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8F5C31C000E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ABcDzvW+;
	spf=pass (imf21.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756707157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpCkz1SZAm30DtLN9HzajIn9qKAPCWS80gkzy9YwyJg=;
	b=4X6gwFm/YOw8MKoCPVsjcmmpGtNQlJ1tCwu8PrBVZyR08y71iWdIsl9iGzY5M7ozMnj2vI
	N4swqiuqS+B2dDRk7/kmRS5qgoHuKWuMM/DFMqgtKSSGrA8+NXM+rJrJTAEFHld8OzAhBX
	l2Uv72e6xR2XFyBJgSrBsijMr1ksNA0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ABcDzvW+;
	spf=pass (imf21.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756707157; a=rsa-sha256;
	cv=none;
	b=IDdfQ00n+lKnHvRz5VHUItTi/oWXCXCaIhmriu/2waFquwi6Kukm2TFYGK+iiSbSm8Gvsk
	lYrOGYGIRf/haUaaLL9zFxNcKpEkR/RaESvZ7WOzIT5ZAViOtxIhPd0y4WeNjAFUtSBksm
	6/0HBXHsloEG2RGMUrqPKHLemuvX1as=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b040df389easo226547266b.3
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756707156; x=1757311956; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fpCkz1SZAm30DtLN9HzajIn9qKAPCWS80gkzy9YwyJg=;
        b=ABcDzvW+D7guGOda+ZtLqJrI9ms4/pHmqQQnogsRiyFwynr/1ws7KHEMNnj/N/luyY
         doT1V7I48FKzwyTgd1qJ48j+DpQQ4T6cdG6u3r/Bx6+naKJx7dpE19JXQ4tCObwGOBIC
         pPCij2stR5sWLpHr9rcug8ua8aPtAuL2whFCdbc/k9Cq8+Mtmo5Zg35IHvxTKysvlLaH
         YS1E6CRuxikcBpCUe9XVvZBX4jG/+S/gqZeHqMSEo6o8YE5dr2dRAyRIOkTGgV2dzf5R
         RJzGgsX5zvVDWCmHwRWQCON3R4VuqU62UR+cWE2OSDSozMI7cz0T8ENfg0H37HW/AuL5
         4Xhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756707156; x=1757311956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fpCkz1SZAm30DtLN9HzajIn9qKAPCWS80gkzy9YwyJg=;
        b=wDgrAFtjhPFpFYKx53ZkWTa8hyxpYO/SWDhbVMoNqacIfCyTLDv0cNTXyeMYP+cnl0
         Gf+pZvjhP1rNqSUT8YC4YKB2riQJZs8t4JrEovYOAtUx4P8x74Rjjumh/xC5vC2dSfEh
         /nFcDN3JUvazXajOYL74mhSGNKllo8rggbz9nyoF0OB5kXbM2ZmnV38nGJYW9e5U4mJE
         nPQxUSpYj23fUjnOXyUoRVHcAkAF4PJN8FmVf3jfVxNveGo3IagYdsRGkXryUiGhmq56
         opcG/+SsfCv0WcRngy842/GoDyVBsO9fgWQfV/o9+x926nvXO5uXMnsrkB9Wy06j46YA
         weqA==
X-Forwarded-Encrypted: i=1; AJvYcCXbGBeHUf0dS8971hb9iRaf7fpSRMsBvfS6vUe128NSEzEZCeP11Wqeax9WvEcIY/MB00E2Z56RxA==@kvack.org
X-Gm-Message-State: AOJu0Yyj/NbOek4bDJh6QOPfUAdPW6+JYl7jdnsDqtf9f8HEPMs4xkLR
	Lr3JAb/5sQwD6XlgMPmqbeHx4lmW8p7E+7XJ+WyCkHcx3QqFs1ZtDzRdDcwHJf2uezI=
X-Gm-Gg: ASbGnct9+fJqy7U1udB0BMDIQxYJZ6SEm+SBCb5MaiSp6eJJEiNNKk5XMb3C1TSLlmK
	Os0f5X1yrYr0JeGQQMUXloWyEuXg008d1GXKRbxsAFy/ClEqsQxNLpdsLpiYLBBzVbe+8+xNuBb
	ufCpT5yDQ57NinOAxB9X9pUPAot1IM5mH/LhhcSCjXPHNchv2RVxKLKshMo2ZyuteUNfkAyKdhO
	wkb+fCe1vUBmUGCiNrtJpkL+vOS6fDbKm34THCsTH97X98phEvRGGhGkW9u9a3qpvuDQ934tXXm
	JDAA6TB9ggDJbbuUb3pc4CADZLkXsCboomIRNl5x139KhiQPlFlGwHdy3xtU1XG/Y/6HflPevvE
	RxD2zzdJDrS1pMORGTXdLXOvQTcWm36mZ1a/FaNavAE/C5H5YHyBBmIVTC+SkZH6QmBlaqvfg1N
	MOZ6aCggCiRG29D+yp/o/n2+etjBawcs4M
X-Google-Smtp-Source: AGHT+IFiW66dPNAjaKWaNSd5/rc66CQvfLy+BReC835wGyDy9GLSMV8wAFikPHytw5Ty44iyPHhAkg==
X-Received: by 2002:a05:6402:358f:b0:61d:3d9b:6522 with SMTP id 4fb4d7f45d1cf-61d3d9b65a2mr3731973a12.8.1756707156180;
        Sun, 31 Aug 2025 23:12:36 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc231561sm6374533a12.23.2025.08.31.23.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 23:12:35 -0700 (PDT)
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
Subject: [PATCH v3 04/12] fs: add `const` to several pointer parameters
Date: Mon,  1 Sep 2025 08:12:15 +0200
Message-ID: <20250901061223.2939097-5-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901061223.2939097-1-max.kellermann@ionos.com>
References: <20250901061223.2939097-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8F5C31C000E
X-Stat-Signature: nh4figpbwy9rwy7uxumqq4uskjiyzete
X-Rspam-User: 
X-HE-Tag: 1756707157-134829
X-HE-Meta: U2FsdGVkX189IhY+A9p2izzu7fQ41dTNxMZmNIr159Tk+xPiS5NaMv6lVrwBqanP8ehRQJ1UxI+NcHLFrsjQc7Krq1YkhHpaFYFD5/d9UCWUa+iMb3Oad+JJf4YyksAHKlX0EWyTxGltLY8+Ul9yD2V5tjCzurqS1GLvABvk3N8cZtxxf7ixhZeToaj6DeC9DAHfVUNz1nG25BjF6h3ePFR/nsepVrYJ3/KTktDFI0C7+qCVLlzQyh4LhkCCEiqOKVegB2weCNHXb0C2/XXxRkb5GMz0PEt8rqr4gK77RJNIvEIcW7mzwYk0PkvVbOCbgazhv2liOpqRdxkcCHpF0VPmBYJdFr+cF1BHCAOJ9SJeXvlmXq/+zXu8E53N7HBsIBI0nuAte3C9PqWf+7eH3pkH36l5iqjROMNmIPvQTRjj/YtaVAOMhMc2VE8zjUic81CIHPY/rA3eV6rGQ/fpq+xhanCs7rOmTrqR9t5d+xCkaXg+xpXeAciYJZX99qTO8+0rY9Lud6Fg79DbUINhXA5lxZ15MvZbPbLPHIL0iTY9oJnP1DmDkQVUCv5yFPZbGYJwlmrQDbO6V0S/a9nn5rueHdNDqcn3L0Mr9f3t6MtH19aQkRbcgbpYBgFUP1ZRy3DHSXt4I7WgDCvyhPGcDTDrUFxeg+CaSJbfKDfqA75yZ4Vv8W8hNjPj94RT07/VYcFLxy0byHTgz4GJGosZoj0Cx3c4BT5AapNfC1Gmmu0yksOD3idDMN4S2Ev0MvJn4SxBbGFq7EDduUm3uAtJzd0/EVebO9ospZQzuHg4mNEPxnXfIRHPSZgQiOiPDuUPX9wO6iXDOFQzjiagbJwN9RLsScnxLLAkyZ2W+oc0goU3PWsb+q2lztarOGSKhnGjqo9R5BDl0aLuh4NvmgXrE3FgCvgPfpAs+h+vSln2wPYx3O5N24OGw3JX/+aviB+IVoMeitPgfvGRzXEaVRp
 IvMhzv2G
 TQxHq9yyfS5gmQ+q8Vs/UqrIrLXFSnRrpQ9cJGX7bawG446Dadvbz2CI/PQhtKkdu+YHoHy4Z3NqQjH0JhAm+1tue1l5zg10YmkDOf2d9NCm7tIqU/wz9WzRXPwtiMp83vJxAta0sHcTKz/fFQyeYxWlZqX3kBSnGMwcXlRXqmL5HzKsi3EkJ7DhSZ2740X7LkjYO7xKCBT6nx/8nM9bt33OIjqVWffNlBgit0/ZUtdkNpTxG0MPA0/gemg1opMHcwMMSKopawS1pyok6ZWngvU18H3Y2UDsPCXZoVg3FhEvpDUKvVwIDQReQGajBWjgYVGYSO/Z9p0z2YFskWak3LwI+KlDYL335UUOW0OzfHy7etoCSWX6pqu494FPQfTSpOAHSyNF+cq8j+dWZL1a5THUVfeq8uksPi6zUhCEK9YO07+Ahv7pOt2AUAk6MA8jL7ttXfg+z/EMRdm8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/fs.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3b9f54446db0..8dc46337467d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -537,7 +537,8 @@ struct address_space {
 /*
  * Returns true if any of the pages in the mapping are marked with the tag.
  */
-static inline bool mapping_tagged(struct address_space *mapping, xa_mark_t tag)
+static inline bool mapping_tagged(const struct address_space *const mapping,
+				  const xa_mark_t tag)
 {
 	return xa_marked(&mapping->i_pages, tag);
 }
@@ -585,7 +586,7 @@ static inline void i_mmap_assert_write_locked(struct address_space *mapping)
 /*
  * Might pages of this file be mapped into userspace?
  */
-static inline int mapping_mapped(struct address_space *mapping)
+static inline int mapping_mapped(const struct address_space *const mapping)
 {
 	return	!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root);
 }
@@ -599,7 +600,7 @@ static inline int mapping_mapped(struct address_space *mapping)
  * If i_mmap_writable is negative, no new writable mappings are allowed. You
  * can only deny writable mappings, if none exists right now.
  */
-static inline int mapping_writably_mapped(struct address_space *mapping)
+static inline int mapping_writably_mapped(const struct address_space *const mapping)
 {
 	return atomic_read(&mapping->i_mmap_writable) > 0;
 }
-- 
2.47.2


