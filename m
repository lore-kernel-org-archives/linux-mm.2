Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36758C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 333EB6B008A; Wed, 19 Aug 2026 03:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30A8F6B008C; Wed, 19 Aug 2026 03:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24CB96B0098; Wed, 19 Aug 2026 03:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E81416B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:47:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7504EA0A4A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:47:36 +0000 (UTC)
X-FDA: 85117239312.17.4CA5A63
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id A67F94000C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:47:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k2LZ5Q2i;
	spf=pass (imf01.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787125654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EM9mPI9yixDIV/dQKvKcahELWkdUTMep2I+eKhwYYKU=;
	b=0uxePtKQdm91ta/wcgHzt6APJIwM0lmwLMkoSMynp/GT1/wd691Kv1iGDQo2+Y+aCfNrLb
	jzHG30R8c5FMgms6GbwgVsZS/zm/xv7PCspj2l5j0n5VqeWwubcJGagdEddVH/YS7nwqKR
	dt5y1zMl4KXEM4tiQIEgIZxIgC11+nU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k2LZ5Q2i;
	spf=pass (imf01.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787125654;
	b=AIpX2NHYkt2hJgFNUAbKCdX/8kd3ijZyUUei2gRUIYsOSvtZwR3j37NjTNmHToYsl/tMNN
	nzH7LzDtTztT7v1XpJROCEzCB22zqRkCC6OKMaTE4EZHFzEwipRvBWjD97gsz5Z7wDwwo5
	gBxuVAW5NWMlir0gOp94JnZu/s6Y7CI=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-382ef647e20so814056a91.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 00:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787125653; x=1787730453; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EM9mPI9yixDIV/dQKvKcahELWkdUTMep2I+eKhwYYKU=;
        b=k2LZ5Q2iSyfSBwJyNAqIiR47NY6TJi0apmMuPAzYFs6zD2ZBFr8/SQKtB6wgGVx3uW
         a+VvLBOGass8oUQE+f+b8e/1foFNaELCVbiIVSa24IIfl+of5pEE1JZYCobd2rVKUrY2
         bKZfV9Si4NY5Pk/nL6fC6pwLOkBfd/qsXNec2JDQmmm8sef7eZixbRNGoIGmSOeFzrRw
         qwaV4eSx90dXurFUSz029dSW+n1hZqYhX4FhS+bjajaPbNrEOWcLA1e8hI3hR065excW
         dD7Xbcnb3IvIx8G32pFUbeTznCqnRwwgHPou8ahFA1q5k2nJ0oWiqFCcVnd9bfEt6vG2
         qg+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787125653; x=1787730453;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EM9mPI9yixDIV/dQKvKcahELWkdUTMep2I+eKhwYYKU=;
        b=seqWdePhS/fizpVhpTDS/mq91JWssHlMNkKPp3jj181DBbvFZ99GV3+WNoeARilOo2
         wj5FpV5uirAa14pS6hhXSwhLj0pAUzZYGlQnbva1p6U15Raukc3qDN1qPvyh7yhEvMUy
         J05divrLrMhJq0MoQy0ieUAbF8WsZeEt9ajH9LB2mwi8egdki0S9HNRMmwrePYyct2Bp
         maygKn3LGCFERHIWk+yP5s+LOLjs/D9h6dlsbueIPwpd9jFqkPzt4QJT5OTd6HYofLUB
         pe4kMR1kFuZ6YOpUAnSAqWJ3Eq+ZZt9W9KgT5WQ3+fYZUk63yN5y+vkK15gvyUdpcx6y
         Djlw==
X-Forwarded-Encrypted: i=1; AHgh+RqcmFEDYFn6f0h3dNamGdhVj6pAiHvlYPmT8gzn/iKb18b9oNp8p2nH7QlPuMNadCfUIO8zOxpgNQ==@kvack.org
X-Gm-Message-State: AOJu0YxOzbvC9J9ukOl0xwnVg6tGSzU4nuUqXyq/zSm6j7ebWyTXaKtI
	0cEHmnHem/x5CWFgImLgYsUUJ6zaFORGHsT7hywOJITHjZkk8MoWxBfg
X-Gm-Gg: AR+sD11wWNSlYxFTy3bISh+1TaAGPul5sCdeD8dRCPLC7rsB0pwOClROleSk7BdOQFI
	2CgENyUBJ6X8A8w+mCmghsNu3MYzfciEWN2IfoTtHK+hRLe2VWPto8T9o64F5DtOQRxLm1okLL0
	iN/R6UGsJBmnFJtT2KpE833zeG/EhTNQdeYAjLYrw6hAFweBv9CPds/Hn49lmcrZSvbu218lcLJ
	0Z7kxscMoZEvK8WLvoaG9xJH916S/PR7afX7tCZXFK6RRUCIZRfSa6VN0RibeETGfLC99tB+W2q
	eK+CYlUCtJgwf2+zpwUccjnbSwHCgvQ3DEY/nWqD1U0KmIbc7ifAeBNa1okyun4WMeYc3kzTXb0
	waolrD2lbQY2nQZSBYXxD1B7ISnBl5uk8jYk+SJF2YlkldhuLwZejyAU7P+Ii0RtLuhjmyzpnee
	7Lv9RQ4vpdVvbvdOwOIzycHiExJmSNnhof4uhU9eZi/Qn5smbPr5IgI+xr1o2FxDgZPoKhqixGB
	0Zc8qiPf+Lstdp7QGwi5w==
X-Received: by 2002:a17:90b:5250:b0:381:9028:5945 with SMTP id 98e67ed59e1d1-3958125375amr5603472a91.14.1787125653369;
        Wed, 19 Aug 2026 00:47:33 -0700 (PDT)
Received: from volcano9f8e-host.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1416ad3dd15sm3927299c88.2.2026.08.19.00.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 00:47:33 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	Yury Khrustalev <yury.khrustalev@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hemanth Selam <hemanth.selam@gmail.com>
Subject: [PATCH v2] selftests/mm: remove the local PKEY_UNRESTRICTED fallback
Date: Wed, 19 Aug 2026 13:17:17 +0530
Message-ID: <20260819074717.1345749-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260818114945.1312987-1-hemanth.selam@gmail.com>
References: <20260818114945.1312987-1-hemanth.selam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A67F94000C
X-Stat-Signature: k8ga9we7f3u7rpce1ai4m46jc8cxqd46
X-Rspam-User: 
X-HE-Tag: 1787125654-760041
X-HE-Meta: U2FsdGVkX1+TD8jiOXbkq59lencv3nbm/SjQFFmQ3VOGGM39neWmIQIROD/Oo5SfPm2MilnKE1gMvGP+vz0CpHZWNdQBa2garZ/Ym9V8l77MCYZQpe9FXAd6oqRs7NHjfQYJ7wvyXATWIqq7sQrOFaLrtpSDql/gmra+k8S00TJVXbWKLs7Xx318P2Myb9nh2oiGJlMKu+fb8nbnJehBsNVtKw8nNs/rK3qSQXXAE3SqE6/269FOPJOiiIBSRnRE8LZW/Ds4B86FjqQpLfvzmq9y3UTEdt2+GtPowhnQp7smsB9Cec7MgnlFvt7cc6CFkkzBDEfiOimupRbdbjnnlRtFDaPFJsZdOz9hrx3PzN55wOAZcbCWc5DbpADyUlmzKtfx9wO03S4XOA74uHhw5874t7fMSHQgGf9ZCVigjLlrbDxmuF5zfnizP+7YJVI4zP+hNvWwVuNLHBkeaEOWxfV1epz959OjdG23pgGQwoOWQb0zXEyuT1UMrtWz0C62j1dpkxToaCcIS+si1xUNCb9E9QMK5TFL0uBcOZZndDRLMQHYKzidZNXqHt4tinlPcne9/BDMyvTK2+NXGzIqjwVNrUd7EjRKHV5SG+j1+W1e41dL5R+BOFHxdHVvD9ArTIyOUlAcViwy7VWU9g4Afe4i8N/NbMvBsu53LPSLG87Hq7j6NGPUQoldwkzBtGFjHcNP0w5uISHP2TuuQwtt20gjiXYK9/4A/PNDYfAPNQU0kShQnSJzCfIMvE4enEBJoCC0i+KGs7Tv2KzrakAYcVHfHc20voubIZTJRFjSfUsGPUCoYLgph1gVuF/U5vZ7w2jVhe00byAMM6AXSwK04FK8HIbkuQELIZyN3to3id5zUvhUiAUOYMACi29kQk0+0U14a3uqdIUkqzPxFzy8isuB3ZYuUagdwbvLDpuRuzltIfXXcIwWpeGtsHfZUIjkMsoQbDSvhOD40vavE84
 2lSeRxHV
 xePRZjGhRxJwnICyglrWmDbIt93jgl2aBGclsiO5CuHNlxh1yU56KJLSFdcvjWPeYgZwPk+gtCKBmnl/AaBTkNsxz5n34Z4Eh4Q7Jm7D29Oac2yi90R+1IzoP7IJ4N+9d4zdDPvpBd/WS5embNHowefgkNfyNeCXwImquuX/AJz/w327Cxz/gGghPrUK2L6xlrtLggsH/Mf87r2eK7+iUbV4CoheXdodAKbQ7lQdI6EWStOzlUm1MyB2oHPf6vrQOcRDVedFsci9vVoiaA4KZ+n2eJ707Z++ZoE+MvKe/e9AjV8ezB+nqPrhpRaHOQdgpjyJjAaLyi0hJ6zXQd4Qp4wRwDdjqdk+sO8/aZcc5qPcKmzjmNsLFzbAgsdytV/yR4QIQmoXO0S61I1ONpGo8U1xXc6X7fPtkQvPve2axvy0c7rgOf/pk9dwz5+6jik3coWFfh1XJcoibRXLoKCDHogzgwTKlrzEUn2Bekzga0oK/Eya9zCXv76eafJpNyoH8YKb7REqD/qSuaMFodgDpIrdaxbKj9Aenf+9WgFm4GyCwj4P5nRVxm0vjxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pkey-helpers.h defines PKEY_UNRESTRICTED itself when the macro is not
already known, a stopgap from when the generic definition was still
under review.  It has been merged since, commit 6d61527d931b ("mm/pkey:
Add PKEY_UNRESTRICTED macro"), so the guard is never taken and the FIXME
can be honoured.

The definition comes from tools/include/uapi/asm-generic/mman-common.h
via TOOLS_INCLUDES, which commit e076eaca5906 ("selftests: break the
dependency upon local header files") added so that the mm selftests
build without "make headers".  It is reached through the
<asm-generic/mman.h> that the system <asm/mman.h> includes.  Building
the pkey tests with KHDR_INCLUDES pointing at an empty directory
confirms that; emptying TOOLS_INCLUDES as well is what makes the macro
go missing.

No functional change intended.

Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
Changes in v2:
 - Drop the incorrect claim that the mm selftests are built against the
   headers of the kernel source and would fail without "make headers".
   They are not, as Lorenzo pointed out; describe where the definition
   really comes from instead.
 - Leave tools/testing/selftests/powerpc/include/pkeys.h alone, as
   discussed with David on v1.  Unlike the mm one it is an unconditional
   #undef/#define next to other powerpc specific overrides, and that
   header only includes <sys/mman.h>, which does not provide
   PKEY_UNRESTRICTED with or without TOOLS_INCLUDES, so its definition
   is load bearing.

The full include path, for reference:

  pkey-helpers.h
    -> <linux/mman.h>           tools/include/uapi/linux/mman.h
      -> <asm/mman.h>           /usr/include/asm/mman.h
                                (tools/include/uapi/asm/mman.h does not exist)
        -> <asm-generic/mman.h> tools/include/uapi/asm-generic/mman.h
          -> <asm-generic/mman-common-tools.h>
            -> <asm-generic/mman-common.h>      PKEY_UNRESTRICTED

With KHDR_INCLUDES pointing at an empty directory the tests still build,
and cpp -dD reports the macro coming from
tools/include/uapi/asm-generic/mman-common.h.  Emptying TOOLS_INCLUDES
as well gives:

  pkey-helpers.h:188:30: error: 'PKEY_UNRESTRICTED' undeclared

pkey_sighandler_tests and mseal_test are byte identical before and
after; protection_keys differs only in the __LINE__ values that
pkey-helpers.h embeds into its debug output.

v1: https://lore.kernel.org/all/20260818114945.1312987-1-hemanth.selam@gmail.com/
 tools/testing/selftests/mm/pkey-helpers.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey-helpers.h b/tools/testing/selftests/mm/pkey-helpers.h
index 2c377f4e9df1..626c2e1655dc 100644
--- a/tools/testing/selftests/mm/pkey-helpers.h
+++ b/tools/testing/selftests/mm/pkey-helpers.h
@@ -112,13 +112,6 @@ void record_pkey_malloc(void *ptr, long size, int prot);
 #define PKEY_MASK	(PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE)
 #endif
 
-/*
- * FIXME: Remove once the generic PKEY_UNRESTRICTED definition is merged.
- */
-#ifndef PKEY_UNRESTRICTED
-#define PKEY_UNRESTRICTED 0x0
-#endif
-
 #ifndef set_pkey_bits
 static inline u64 set_pkey_bits(u64 reg, int pkey, u64 flags)
 {
-- 
2.43.7


