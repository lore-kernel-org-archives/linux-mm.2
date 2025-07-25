Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1ED6C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 12:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E0D56B007B; Fri, 25 Jul 2025 08:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 391AB6B0088; Fri, 25 Jul 2025 08:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 280B76B0089; Fri, 25 Jul 2025 08:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 178BE6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:16:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9665B1DBBF4
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:16:39 +0000 (UTC)
X-FDA: 83702685318.28.7D3D050
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 80073A000F
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:16:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jrToKTxA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of jannh@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753445797; a=rsa-sha256;
	cv=none;
	b=gnEfThWb78Ml88SgVOwzEOiMwnKQmYdbufS50AEbkt4mpovPZKALKs1/PwDEbkBIoPOEci
	n328X2mE33O2DDbj+vqA6t7gx4SKyVsshPv6lyEGqUI43Qj5RU5g5krjjEZFwnqZLXIoUv
	FyX5CwR4dyQeTTLKv42sfmpHszTtDoo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jrToKTxA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of jannh@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753445797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=v8A06zzov4fRzg2AP/VvqP9aaecoBJtmC4l+aze+HnM=;
	b=rWUSIQnoZeBTXp9i8WG8NcgTUbVU3JWqoD0S0zrj8h+ecQ2ag/pcNQ3P3NX8TCRF6KGiTS
	8scWauPsrvEDWFT3/wBM7C0290zusS6pLNSapLy+XHSG9te07rt2Mrj6nLBuCyySsxxt6T
	tesFvYkFuksF4NflRGxPc2Dq34Qf2Do=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4562b2d98bcso33995e9.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 05:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753445796; x=1754050596; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=v8A06zzov4fRzg2AP/VvqP9aaecoBJtmC4l+aze+HnM=;
        b=jrToKTxA/HfkR9byriCdstTvYmpDu+AwL3X95GOrKjaOMseaKPJpRzNaPjc/yPes8r
         WAC3yiMKgUKfnkqP/XcaqEEbUerWvf89CGQQ4D2CgqJg9k/SZAAZX5QJHE9xjbePiks7
         QSbYfdLR7gYMymp5Y0JqGIr3u0dWBzyCkh90guGnu8ZgSKorB13dvVTrcb3lJ3g9U9+Q
         bBGI5fq7Ivf0SrGMO4kv5mKRpR8+6IK5qzzJX1fHbT8hSbgnbiVkCXh94SgWRFvp8unO
         MFTO34WS6keNbC0mHcz7W3a+JhMWumSC2Mltl2PiWgWabDNPVkhlrALz1pXprY0Xo/z2
         JuqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753445796; x=1754050596;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v8A06zzov4fRzg2AP/VvqP9aaecoBJtmC4l+aze+HnM=;
        b=mAENUmYXtoBJ3xLmWMDPWMKoQf2PcUZsJHRv+d4d79+9Uf0YiHOB5f89POByGIVFg9
         buHmjDk2jWTdHF7cnZXAdLnzWIiyxVgsjIsHnKWDDD6LjJUqRBp92hlxJT1rsBvr4aS5
         DTASc33ixDHmbhJT7PaRCqhg5fSH2LDZujxKyobadou3IOS7rl+hY/ed4UbKN0SJuprw
         fNJstWBOaI8lZ3hdgbNfgnOHzMt1LfsfqjLtAxzYAUpIgjsm1TqPaYGGQRhkf+kL71BP
         W/9PsgjHMNOxz3LEPygNCOLWNr5DWJ/LY6nmm+J4bngz1mjV3pyto7HIWd/es2jPwoaH
         YMhg==
X-Gm-Message-State: AOJu0Yw9KPo5KL1hqoQVz9mKZ+bip/wDa1ugE+Y94W5U1aa+d6Jf4L5R
	nDIM4ueln2mdc1CEKrue4NWxZ7g+9oKUJN2y50lcVjnQpGtvSUEi/Y3sL5YIeB1BpQ==
X-Gm-Gg: ASbGncvX+Oe0Sdf+fdCRFp6iTav9k4V7/sZqL9ZhBhwJU9QlrbxDjE9xkiPiTh7LOwe
	+paySfo/Pt7ac88LvE/+7WC8po+h/3TRMX/J5Am9rm8e3nh19CibvKu3DcwxxdczpepxuWDzuFY
	4J/kK7sqKPsxCfZq6soItPTMXVcSI3SQKeZStBn2LsPG6YgvXnj+HSq7ww4h5hQve79jj6NVXOr
	QkC1Zi1CAENG9gDJJhnioeHkyUyRUl0qOYXxAg/rXTTbZ51HYWtojThPiSl+zsQ9L0S8viuoVjh
	TlZ5n5GHjVRSFEG6XM/ZXkkBuArDJuhf3sDKjM6fjU+E51PALiryOKuLqK++Ilk1+2RhuuDuxl6
	L/3JrS5UBBg==
X-Google-Smtp-Source: AGHT+IGciF+4vEIkN/QlW54EKn9w/jC8q5NchVG0Sr8U59/ARVTa0iNrkl49Gr+973iUxiCoTLx16g==
X-Received: by 2002:a05:600c:548b:b0:455:fb2e:95e9 with SMTP id 5b1f17b1804b1-458730cfd06mr1672715e9.6.1753445795587;
        Fri, 25 Jul 2025 05:16:35 -0700 (PDT)
Received: from localhost ([2a00:79e0:9d:4:5214:94de:bd29:e79d])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b76fc605a4sm4916829f8f.14.2025.07.25.05.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 05:16:34 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Fri, 25 Jul 2025 14:16:24 +0200
Subject: [PATCH v2] mm/rmap: Add anon_vma lifetime debug check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250725-anonvma-uaf-debug-v2-1-bc3c7e5ba5b1@google.com>
X-B4-Tracking: v=1; b=H4sIAJd1g2gC/32NQQ7CIBBFr9LM2jFAahBX3qPpAsqUklgwYImm4
 e5iD+DyveS/v0Om5CnDrdshUfHZx9BAnDqYFh0cobeNQTBxYVL0qEMMZdW46Rktmc2hVtYwMj2
 X0kDbPRPN/n00h7Hx4vMrps9xUfjP/qsVjhyFUldl7dST0HcXo3vQeYorjLXWL2nQBm6zAAAA
X-Change-ID: 20250724-anonvma-uaf-debug-a9db0eb4177b
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1753445791; l=2822;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=RPodm9Ldenuy/H5haDTN8fCr5D6oW2GFg9ixFEFNSgU=;
 b=2aXvVOIInCdwGZjckt0AFw/FmLGP7KvAWt58w6Phvj1VFsc79j9yuxuT9YQ416/22q2uKcSkZ
 SpdyefrwB9RCL/p7QsSAyU1j7eMRm1X9VRAhUvVMJ+pTw/0yPy2nNZJ
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 80073A000F
X-Stat-Signature: 1pw1hzruess7m97panrz8foppt599ec5
X-Rspam-User: 
X-HE-Tag: 1753445797-451882
X-HE-Meta: U2FsdGVkX19bEurj0C9oXou2ngj2TomPKQuqj15fA6tGpqsNvfTP04pU+fPP7hUChWE+79eRdhRsyPYJ7OJP2OEqef+6t/GH80eqoEKYUhxwb396EKJRM/wpe0BUN+7ZFjqtGbZIYPoj6kRY6s7tu5pA90Yz5uKJ1fPbxwbvXskAzTn0Y6AJgF9qwBdsLLODpPZm4CHH3dnOjJqT0wcffAoUZVcnRnHYJYf0OiEeEwQjdOdYT+VR3SDZ/hCW79fZUmDwfwQZGjXC3Z6jrXqAxkE+EP1F6NPxE3P3OFgiefwDtYR/Yv+zahaTHzVa2ZcA7Sd9+Zy4w3RToazJ2WmEx6KyG9Hxrd/hrwPlkbdSKdjaNK6OlDrsMhXp4Uc4ZdMpt1G8v7CJ8eJl3sP1wUNGaNJiSisFwN9WGWfCa/5gOP6qb/3eKfGrDMoxxIoow5n6iKg9dbe7XMf1pBozZwrduqpgc88DMYawlSHRso0Z3GkY/yl4xL81oYyxkxP3SdUDhw2Uj5SLshyWyA4j4WyhxcNyZy4TmDeHeKwIaQQaFHMRB6JIUFeURi9e9sl1KJPWiBYgD9IC/lMCIY9ZXrSioNWFAD2xMHEGX/n06KrOBJZDMTrHsuJByFwsNNJjcuQ/n0qdTCJU7EntiHPiDydb2yhumALTSP1R7O8IdES8d3Ls6e50tlGFlA6k6isNUTi2pSQCqTa4NbNlRQrcAzaWNvbPY3bjY4URO6J2L+T5NBqYUzYsvPEv2wwpRUsFD2g8jb5b8YTDwfLkKTztfh102DBF3tG1NkjI+k94xB8mJunf12wPmJ5r4d1teUNMFScQtpaaKN5B8eF76DBTjqMJaNR6z6Yv7IbzNQx/wwiZEPu+K5f4qq4Wr2xXBS+GJq6dUAHtyujqjqTO5wstbCnteR4crjfeVPaZ5zFdbA2S4jI8cDNczuWQCXWitf790I1WXq/StSZ+zRsG+ZK+o6b
 VDj/cywj
 d7EZLTWbn6PFoscwaU52hqFZLzZx3YxWPNoH5EeQOCUP/uXVpruz9Uft4UJ3CmUuIFphP5UTEVkk/LfxCDy/gqpSxb/+P8N9RaqOKg20xukblLMX1xob6mqgDuiwZpdjiMHHnRzwqkkE18wZsGCyPVIX9rkUvGslg2zqnYNyYNTCoD5g3cQg92Ci3ybSbx/zgLwXwYDCJL3EG1ghWOR242k6Ham/D0Q/27HXOujADdElgF4ocmd4I5CTSJOD7U9R01ozO20a6bxykhc0iwtVKobyWtt3b8q5ykQF+xeqSmAvPRNne2PMl12y/WdYTOSL3rwnUkMJII8SKZNgOesbSEe+Axaf7X1O1xPxEmpptfw1FsvgvWbcF1vn8nNg+SzSCepRVCv44slEsWVSTi5A6AoLfpdXhsiqeyGA43n8U0fE/5oXaL439dmQNlEcMzPEfjmPWzr80DLUEuMTtxKos1Jypvmtsv8eWrrD5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If an anon folio is mapped into userspace, its anon_vma must be alive,
otherwise rmap walks can hit UAF.

There have been syzkaller reports a few months ago[1][2] of UAF in rmap
walks that seems to indicate that there can be pages with elevated mapcount
whose anon_vma has already been freed, but I think we never figured out
what the cause is; and syzkaller only hit these UAFs when memory pressure
randomly caused reclaim to rmap-walk the affected pages, so it of course
didn't manage to create a reproducer.

Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous folios to
hopefully catch such issues more reliably.

[1] https://lore.kernel.org/r/67abaeaf.050a0220.110943.0041.GAE@google.com
[2] https://lore.kernel.org/r/67a76f33.050a0220.3d72c.0028.GAE@google.com

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Jann Horn <jannh@google.com>
---
Changes in v2:
- applied akpm's fixup (use FOLIO_MAPPING_ANON, ...)
- remove CONFIG_DEBUG_VM check and use folio_test_* helpers (David)
- more verbose comment (Lorenzo)
- replaced "page" mentions with "folio" in commit message
- Link to v1: https://lore.kernel.org/r/20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com
---
 include/linux/rmap.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 20803fcb49a7..6cd020eea37a 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -449,6 +449,28 @@ static inline void __folio_rmap_sanity_checks(const struct folio *folio,
 	default:
 		VM_WARN_ON_ONCE(true);
 	}
+
+	/*
+	 * Anon folios must have an associated live anon_vma as long as they're
+	 * mapped into userspace.
+	 * Note that the atomic_read() mainly does two things:
+	 *
+	 * 1. In KASAN builds with CONFIG_SLUB_RCU_DEBUG, it causes KASAN to
+	 *    check that the associated anon_vma has not yet been freed (subject
+	 *    to KASAN's usual limitations). This check will pass if the
+	 *    anon_vma's refcount has already dropped to 0 but an RCU grace
+	 *    period hasn't passed since then.
+	 * 2. If the anon_vma has not yet been freed, it checks that the
+	 *    anon_vma still has a nonzero refcount (as opposed to being in the
+	 *    middle of an RCU delay for getting freed).
+	 */
+	if (folio_test_anon(folio) && !folio_test_ksm(folio)) {
+		unsigned long mapping = (unsigned long)folio->mapping;
+		struct anon_vma *anon_vma;
+
+		anon_vma = (void *)(mapping - FOLIO_MAPPING_ANON);
+		VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) == 0, folio);
+	}
 }
 
 /*

---
base-commit: 1d1c610e32ab2489c49fccb7472a6bef136a0a8b
change-id: 20250724-anonvma-uaf-debug-a9db0eb4177b

-- 
Jann Horn <jannh@google.com>


