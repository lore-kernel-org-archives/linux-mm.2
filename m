Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4699ACA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 09:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B3B96B0104; Tue, 26 Aug 2025 05:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21B0C6B0105; Tue, 26 Aug 2025 05:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 153C26B0106; Tue, 26 Aug 2025 05:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EFD2C6B0104
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:34:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AAD2F118E69
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:34:22 +0000 (UTC)
X-FDA: 83818397964.12.C27FEF3
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id E54454000B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:34:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eN47i09f;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756200861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=OTBOw60mwwD5X1cucgy3CKrfSMWOzThrYfsjPFSezM8=;
	b=AtnvbuBL5FVNkROW1AcmKav2H54zyLbYh4vcbQG4K53Dg5qThMKinYBXCH245f9WjioWLl
	jdcNPhLvv+J8ysfIpOa8n/oEKi7z9S04Nq4DFNbQvUDmsGYGXS4Obejy2Dn9oGKaPGmqeb
	UAU6C954XbwXsb2sDGGo24YoxKl3NSY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756200861; a=rsa-sha256;
	cv=none;
	b=iDjh9YMCc5+BwM87E8p30X7lL6X2/t5tKx9X2eIGkwv8hQxVkHyMPWFMMwxZIZRR3USGHk
	1umM5+8qLL9hFS4Y3I6rfa795JUTOXhH0VT1mZZ/TkhmgVJi5+oT2VCZW6VQ212vJOvJRe
	PAEoJg+Ki2Yc6ToCnfg2jSZjHw8+C5s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eN47i09f;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afcb7ace3baso968709066b.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 02:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756200859; x=1756805659; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OTBOw60mwwD5X1cucgy3CKrfSMWOzThrYfsjPFSezM8=;
        b=eN47i09fDblMw6SuThYtRxmuiRGYpi5jXiJICC844koUHF4+LOXfs64eCBTUD6akhQ
         YSkZgjwNPcybM2Cfg86olkcpVkxz1pvIrqhZLIU9yZaxLRqp8XIBcI5HKWfeNI8GpumK
         yZ4WVOWdO2MU/UYMTshndrwWOcIxFKW6GTuOhYNnf3llmfKW2i3h1P0DO5qCEY67COXy
         bbestMIOkvYpSa58hlONKR0gHHTOA+M+4RHifA/gGsM2xMswhQp/damlxxfyQLoinU5B
         z53o70SWVsAQccz2TCk+8GWKzV+BNtb8SP7NuahGwC8oB6hMXZ5GzIA2ohuWpjpBm5k3
         Cwfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756200859; x=1756805659;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OTBOw60mwwD5X1cucgy3CKrfSMWOzThrYfsjPFSezM8=;
        b=DfJSmYdWUh4VKw1I59k4Ci342FrrWXtwniB7A/WWAhN2wXfMEgkByfv6Db2NZrhYQK
         wndxu8OPvFoY8Dzv2wXa+iEfie5j5IHy5zSqTjRxp9svS7ceaGK6Anqi6is05jw60vGp
         1TTwXmxvFMNY7vuSaOC1/Om3WNO9OAEEnoJZolAiGI9ZUEPVtohLxkJYhq7gMebayS9m
         16gXCQmMMFtzIIcrypslRDTYCnOdnD4UEdkqQHezKxLGdr/UymZXO+fhqNY9Pp/oLx6X
         B0gQXzuY9vnQzbA7/IBHFBM67eQaBNCWuEfLWTj+kaN3vTGKaLXi9akMWX6hRX8zqmvE
         G+Og==
X-Gm-Message-State: AOJu0YxE+E6O2333xkjbOgRVbknq8rnHXi5hW1vP0SO/hiZYTqet2lIc
	25MrBcJnb9jNNKBdF2bpBtrT7zfhqJ0Efzt7mZiRvXyxK7dSoHKSsG/x
X-Gm-Gg: ASbGncv2T764qmLtQNqQ+b7xjCUGWmFVS20D4qgpR4mwzm+vpibroySwVpChm8DrSVg
	1WXIu8as+GCV67xM1ZdO0ZECDA46Q148clKCfyHwBBYvQscAwlLEmBgVkeSCpheltomvpn8k0tV
	NlURUSRAA1e4VrNI2KimX3ALVE1499Gwl8dDUllrR+SZzV4fSIhe6aco5xYh9eaKErWCqPjp59k
	A2YOkbZ4j+Fv0CJ2Jd815R8sJTcucW96phqeIo8qNH/mztgpc3kPa6RgvOscKnuvfbb3DqL1+1Z
	AvPuY0u0C8lLKgbPFI83kVCdADQoFW7UkZe3/zbenwFmOZ3kzXC0t0s579VncZ/frj4M6zNHc9P
	uzmKt9jMb1KBT1OcsvrQp5SVWjrZ5ZpQZyjoA
X-Google-Smtp-Source: AGHT+IF5g3ZuJpo2GOESwKCwy+RBDBX5Pxage/B7oJKSJfjCn3qNOWRjFDcBJ99gpdrEE55t9HbTrw==
X-Received: by 2002:a17:907:940c:b0:ad8:a04e:dbd9 with SMTP id a640c23a62f3a-afe294e0887mr1509878366b.31.1756200859409;
        Tue, 26 Aug 2025 02:34:19 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afeb167670esm48309466b.112.2025.08.26.02.34.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Aug 2025 02:34:19 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	vbabka@suse.cz
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 2/2] mm/pageblock-flags: simplify MIGRATETYPE_MASK definition
Date: Tue, 26 Aug 2025 09:31:48 +0000
Message-Id: <20250826093148.30190-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250826093148.30190-1-richard.weiyang@gmail.com>
References: <20250826093148.30190-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E54454000B
X-Stat-Signature: td7gcrrnccmejxdk3aoxtw76mggpon76
X-HE-Tag: 1756200860-276671
X-HE-Meta: U2FsdGVkX1/SIx3GzuVlZnVf9LraJMxnWxlPr9CcxJifO7CETzhzIXM3SNKCz2Pit/lkXnnLpcPpu5EnjsSyah++TB5QTYziEdD73+1jfIfAZ27WL2J5JFre1R7tEGIajf4/8TS94vfRHiWjJZ97HnNmnBJMLkwfsitM8vp6H8vUca2WIHRzUcB3oB0I6nvF4vR2WgOpAC/lEqkaYZ7Vv6NJRHqe9iAS9UckXAmIjYbK8XnNdcSv8nZEfzZ0ucfg1OWpBdefjbOV2hVEr8LwkNt39H65Cp/9bMJGG9MKDXjX7ANCFhs7ARrUeYqEeAedsQZ29wtewggHijTSaAc1MQkmDZCbdNAqmO/n1OMYB2vHHGgM8ZwwzXxUANw8fapsrTnahR+Z9+CaJLadRBJjNldQvJ4yHUiEQ+qnXLVdD4GADZv9raodnyO1AnTwJNnHfxTU9nQJsINQ/60WYw2TTqTfNuvyuSkXxl0jb9I7gZ7Se4EHD8IGm2mYgJwimiGegXHK9ZDOjcuygMR/EFzBQuEGRe+bQVUqxfvHX1gsJKszxsNFp1UC2VRBl4CIS9da03HcljxYD0rDVhGS2/9/N+F1NTpIeWRI9fSusWW1ZNRDoqhcyOVCm3Y7Mr2Yt6WjrxF8I0aUPfxHo8+IZKeloT/0UttpHCHL6he3ol7fLUokEViosQeUnoyQJwke1gRfXxr3B4hkNhDJzwoK0Abqruy1WxDjomEgfIcur58XfqPCVSGkQiYVABNrfOTkxSw9aQmhICqdqu3nzNOTSsMepGZPwVYz93Qy1RoemivMY0Iyor2f1nxsGQ2ZD70JIXXZY4Iuw/Y/Bm0wwqOcHWXyPLiy+UMR551oRDkD91cHmSs5Ddg8xXvKb3n40Jlz5Bsxz80by4oj6+IOx2JeuSuIFsY64RjGXHjlIWHJhH1c41CdCT9AW2oEUkVL+sdoGu34y4R1jjS+QLB9h4kml/a
 yupS//np
 GNKksAn/asRL5Er74t8uW6SoZOHdUDW6y/poCBOWx0xtToJS7QAcr4GB3AKsGFs5r7laXKsPm008KoDjL0ntFYhTk6T6ogv3tl+N6/tnptXIual/cNiGjl9vQFDm1ginzbiD0PJxfFZ3u/YKxttJwV1FEWxQ/IrAd8XQiFUWb1Jc7jaVsGsWt1uyzVKCq6lj0l+HdfK8R5Xn4quCcpfmPpf/hmxky3CmiuEghLP062bZbZEXXYxCSxT02duiri9yzZlrzQ9fOS+Ot+fYJbpAYvU6e8Bw784R9ydg7Oaol6v85nwMz2yAM//DwRphAZtwsD2EGL0jyhXjaJPS5W9SLfd3jQne2i68GcRMaLtEN24M+Mxb8xQg7GBHKFeXBcP+8kd4THyI7dtpGf/LteB9m7aE32GtCHATSuQp6r06rvw63eSwN1X/qcDFbZ6/jDTxU2sPNRimWiB6dw3MTvuNfGbBdwEcLFiN2X7dFryHRJchey6wtloeuJpGZFW5WfdVOFRrExBnFphUIgEVGEK56227r6skiS74S/8hfHzG82QEtrAVO4bxkAPpGMJbVcf93EIjKCskPfRbD3sGKc52T0vE6m7m7U2dHxFpc8P38i0HoZ4I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MIGRATETYPE_MASK is defined to be the mask of possible migratetype.

Define it with PB_migratetype_bits directly would be more clear.

Also, MIGRATETYPE_AND_ISO_MASK is MIGRATETYPE_MASK add isolation bit.
Use MIGRATETYPE_MASK in the definition of MIGRATETYPE_AND_ISO_MASK looks
cleaner.

No functional change intended.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
---
 include/linux/pageblock-flags.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index 6a44be0f39f4..1489c062a5a7 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -37,11 +37,10 @@ enum pageblock_bits {
 
 #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
 
-#define MIGRATETYPE_MASK ((1UL << (PB_migrate_end + 1)) - 1)
+#define MIGRATETYPE_MASK (BIT(PB_migratetype_bits) - 1)
 
 #ifdef CONFIG_MEMORY_ISOLATION
-#define MIGRATETYPE_AND_ISO_MASK \
-	(((1UL << (PB_migrate_end + 1)) - 1) | BIT(PB_migrate_isolate))
+#define MIGRATETYPE_AND_ISO_MASK (MIGRATETYPE_MASK | BIT(PB_migrate_isolate))
 #else
 #define MIGRATETYPE_AND_ISO_MASK MIGRATETYPE_MASK
 #endif
-- 
2.34.1


