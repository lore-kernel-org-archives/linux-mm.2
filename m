Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1750DCDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5CE6B0096; Mon, 22 Jun 2026 06:33:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208546B0098; Mon, 22 Jun 2026 06:33:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11DBE6B0099; Mon, 22 Jun 2026 06:33:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDD256B0096
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:33:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43EE8140624
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:33:52 +0000 (UTC)
X-FDA: 84907187904.12.D8DA9E4
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 79BFCA0003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:33:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GkaLHKVd;
	spf=pass (imf15.hostedemail.com: domain of 3jA85agkKCOccJadWbJQdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3jA85agkKCOccJadWbJQdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782124430;
	b=5KmXbffVj/grW9WxLdGk/rr+EsVIqSsBaeVDD9yD+7lOBwiS7QklhjE1Di2eqBwbLiUy/R
	jW5Yui+taXymuDDF+Ls6a0S+5RUhJaDQH+lwrtCPijcrDpUCDkX3Qv0EANgeEfTNo9ayFM
	W5QhGBYHiFGYpjnmZRaPZLIDvrF8NBw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GkaLHKVd;
	spf=pass (imf15.hostedemail.com: domain of 3jA85agkKCOccJadWbJQdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3jA85agkKCOccJadWbJQdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782124430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0tMHlxfhNRj9OWJ2aLcf95z6Lv7ns1VwKEy9Zm5rfk=;
	b=ZUzkXg0pluf1GCB6xyRTZ7+fbY7IQulXftkGEhe9QDcsXJCQ85hzvODtuNySAkkbQP3g74
	8WLsuCpKMq+gFKtQ16WXhoxhmmRs7/zXYKKzhMNgPkJsHzk27s0VEvgwRi2kE27odjgubh
	mF28De5vmTj1kEjpwVCMXygjfHUScxU=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c07ea058c29so358343966b.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782124429; x=1782729229; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W0tMHlxfhNRj9OWJ2aLcf95z6Lv7ns1VwKEy9Zm5rfk=;
        b=GkaLHKVdi8s9fuO0iSjBO29njaIOKWdp1K/tdbhraSd3425gp4DQ2roGKeb/lKkku3
         ksF7obSkxwkT1dXa9FbhSZcKnAoKb4LJGoIXlmEA5kB/LixO7tGp7D9BiOCZPyzNZz6T
         OUASDH8001NBW0q3JJ45/6wB6rrCOZ3/wF3o1m4zBqhivqzWt6aphDCldq1Pc9u8MtdW
         5pf5KroRZTyahR0lF/mYynulzXcnBrRU4gpZeIinhcbkBU6hakaXfFNSeFdH/sQUTZKo
         rvhWAJ+5B4RIFhzPmT8OpHPETALxaPFKZKbUVnj6+P38rTNExFb25oF5vZtxg9mxEkpv
         ZCfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782124429; x=1782729229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W0tMHlxfhNRj9OWJ2aLcf95z6Lv7ns1VwKEy9Zm5rfk=;
        b=PJsArwEMNX91enYq1hN3p2fdDpJcYIjoRLY80rCdvqe84gBh1fQZ/af/cmW7pYJ0p7
         22ZW5vV+gi6Kl0lTr9cqUhXyDM+0tnHW2mYaiZCdpXXx9vZOPNPiCMIllhVDK96/v619
         k9728K6ZVXiCzFB87Jycg0zGFrCZyZl9/YMxPXhT38M449TvNOrrOrJHoIiLUV2QaLhy
         +KBVPTGhZdvEsbOesgNGSQitKHXmDNi6t+dozY8PPLDAvN/YWcAZA6xFc7POGC7IZ4Bs
         i8wW2OhAXVMly4wpL1vfCWByWfsZcJVeVOdm/3arHJcRImSEQreUuSsBogrRHruFsySA
         uPLQ==
X-Gm-Message-State: AOJu0YyneTWZtT4NBY67PhCByW1Fqr22IvSoQmRmnAZiCXH6YT1Nsa7O
	dYP35LD7l73I3Zu6Zy/zgjKFLQwkvGKbtf+tXkQngx+KpDl6ggeYCmucG8uG4TAGyPnzdM/yJfi
	QtpA1B1Vh2yiGIpDJCg==
X-Received: from ejcci24.prod.google.com ([2002:a17:907:2678:b0:bfa:ef9f:483c])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:c13:b0:bee:e07:3f0e with SMTP id a640c23a62f3a-c0b601ea898mr640255266b.2.1782124428817;
 Mon, 22 Jun 2026 03:33:48 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:33:44 +0000
In-Reply-To: <cover.1781866575.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1781866575.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <85fb8f5a308203c4cb352189c6eb65b44c03bc49.1781866575.git.tarunsahu@google.com>
Subject: [PATCH v3 1/2] kho: add KHOSER_COPY_TYPE(UN)SAFE for phys copy
From: Tarun Sahu <tarunsahu@google.com>
To: Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 79BFCA0003
X-Stat-Signature: w4a7pzf5z9honhyk4p9j5md5hti5891u
X-Rspam-User: 
X-HE-Tag: 1782124430-390668
X-HE-Meta: U2FsdGVkX19tjwXW2oaz8e8prYFQKLD1O9NEbWyHBL4Nj1P8Bl2GOkrqlg9NQHqbmq9fgJwQvKHrn5g2hes2AY36n50TYagZfnry40LqzQcPg78W2vFVg3YTJEJmpLlAziNgY6BpeOtFmatZc0QDHakCgjyMw/K8R4iDPL57Fayl98M8OJDhqDOBCItq5UBD0RG7bLdEU/12r/DXQL079aeVfMHlyv6TwTflyI8l2tenMmUFXKXxiLu7Lg5fJ02+eQlpAvDas0ESKO6psl9jqVex2oKgJRofPTOCK6EW2DsU8kWFfKllZpB7pDZMRDA6p/znRopf8I7eK8M9Z00u17PLQa//mUuXVefKUdMpxnIIcfJONSko39I9HmYq2mBAeYq/Got/7ZWoFFpvnTXp0UpINmHXdBNj2uTQyQXUKAcOCn8cgRtW+yx0ZUwhMxcDgluZxvaCTrj2S9gTeWSBx7EsQhvyweTt4ZoC3nPF88C8mSnSikiWwuAxZrr57GG5VbUVAx1pD1HlvAcHXwSNN/MgPV3uusLISYYtb1mBF3cfeo3wcBVmVuDj/YmlTjfS0fVlsD0KfIRhi30EMOYNuRjbzFftbLplEb2AztvKznFosqTTppoY9ZsCmnRlDB/Bh2QWDDC5dnx/dX8etuW9Do0H4nH9ZqbnyHFvy2xyAPN4kvVi02GYVlOnxj5JtBR/JwtXH5eoGpmxxYHsrbbFNVDzm0XF72PDsVf0XJTGLRTCdGinalMwpISG6M3gH/PJr0VROWLrpIvi+w/afijZMhzP8Mii7Bz4cx4aXKNv0mXO+lR/PARQH+uTLFIBVjA9/gP0u0o9rpekqeR2ReZGGXB0U2IyJ+lnpDrx8Xs9oGolmxgBeMfJ92pYxsFeGf58h/g/rslrIZUzzlCl/Qrgrp2QB9e5vQ5OFHDKPHnu68urXBUgfQp8QYZhJC3LiS60bqq8si2TBEi7Ydr2Yk4
 0RBmTO7T
 n3Ehm/F9EbqrPhcFxxKSliSCCQqeGLRfyoVWNbn9WyUIr+5ryOd2xoclKjKPvfNcYH3ivTVmqNE5Wrd18ft8LIODIO6Z/NCd5hIkHuPbBpA3GGQzmopxbyMcaTCOn6W6Ju2oDILnuLG3kyYxnJjCeh0lnOx3ZSye98qNgAaAoFgUw/gjLHvL8NvfhGGriG7Pzh8U2q3m/vPP5ZtLAkBQZ1nLIOPIYOCtj7KPw/v5t1BkPMICOSp+Ln+KJXOLE4w9R2N888Z8VA+A4qjJWkn+Vom5Yl1VwnDr7hnK60j/4EXK2r8qSq0AoEENn/Qm525J6aMMeEpX8pi4qUFZllhlJ3mALYvmDVWbKtONcpOK2JizzCWnisXkDVwOlAAjgI0NO8JKtsIVHdooxHYvPQ+6H9VraH3mOSLvIv9p3c+ScNRTgD1CCHjD/MJGKNIj0CwDbCCvc9c9sD796f7Nf7Mwm4klVfXlNvCErgbC32zdyL7VahU2mMo9Lc1BfzOToj1eU+Dzo6NohfPoYCt7Tjq7U720zODHBf8gGezEBHhh3QiPAPzI4tbTOHuZwXgShyuAVEC9NvF7aD0xecxSe+VnYq3/o9m2JAi45D3QoWzewdSiwwos=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding KHOSER_COPY_TYPESAFE and KHOSER_COPY_TYPEUNSAFE to copy one
serializeable pointer to another. It basically allows copy of phys val
of the serializeable pointer.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/kexec_handover.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 5e2eb8519bda..618408fbe9c9 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -139,6 +139,18 @@
 		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
 	})
 
+/* Copies one serializable pointer to another of same type. */
+#define KHOSER_COPY_TYPESAFE(dest, src) \
+	({ \
+		typecheck(typeof((dest).ptr), (src).ptr); \
+		(dest).phys = (src).phys; \
+	})
+
+/* Copies one serializable pointer to another. */
+#define KHOSER_COPY_TYPEUNSAFE(dest, src) \
+	({ \
+		(dest).phys = (src).phys; \
+	})
 /*
  * This header is embedded at the beginning of each `kho_vmalloc_chunk`
  * and contains a pointer to the next chunk in the linked list,
-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog


