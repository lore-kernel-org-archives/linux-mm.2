Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C6C4606A33A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 04:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IwjNfTHF
Received: by kanga.kvack.org (Postfix)
	id 36A636B05DE; Thu, 12 Nov 2026 23:10:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3425E6B0603; Thu, 12 Nov 2026 23:10:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2587A6B0622; Thu, 12 Nov 2026 23:10:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBAC76B05DE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:10:19 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A0C61A0170
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:10:19 +0000 (UTC)
X-FDA: 85428768558.22.5A4AD41
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9CE7240006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:10:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IwjNfTHF;
	spf=pass (imf27.hostedemail.com: domain of aleszlucero@gmail.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=aleszlucero@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794543017;
	b=7QlPiLC+Gduau1k2Ec+4CaO8n6bbhDE7TBviYflvrxDq9+DB2sAH2bGBbpMUJQNNpuhNf0
	+IXgtsSczd5OIWdvXyct/pToRqMfsLcRsKOwTOQH8z+O4ro/SR49NaEdnVg8YqpIUyUg8t
	A4uGEqxIwIJXm5f9GBGqydVAUyBnbdE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IwjNfTHF;
	spf=pass (imf27.hostedemail.com: domain of aleszlucero@gmail.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=aleszlucero@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794543017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0dyLUPgXHh//k1rqYdikzfnU/k9m9fgYRI9bsvixd+8=;
	b=RGQ+guupA2hn2fwcUlQl10WeKhNjOONaZmNrOsn4XdYwEN3sWA2d1A3mKs93CRTzY+VGyi
	wY/Y455L4Z/NHAD+dlI4sXl28bQ6fp/CR1xT6NgpaFGHVR00KyXhPecSsU65hiyIh/QSV+
	jwn2k2j+BsShX52daEL4qXqrA+u9wbE=
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5eac01ff101so214238e0c.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 20:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794543017; x=1795147817; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0dyLUPgXHh//k1rqYdikzfnU/k9m9fgYRI9bsvixd+8=;
        b=IwjNfTHFBn9KXnSb4lg31vQNG87/kgsrVqJV9T4gPO+OhAFk34b3SgrcKoFCJyuuWk
         qIGGCpvNPNySOgQ68Wxc54xJQTB+uveQ54cXEwXvQAhNeHstVyE6Ujv8f2QlJB1227BT
         KglH0itxVY6qLNXVAEOLp65Dm43O4/tRf5n18KUmFRxZ5pRCbXUPbEGORfqX5XC2uFXi
         SqrBkh7vxuT8+N5Z/k/acnf/sSg2Kz15Xu2vEHTyXj09P4ykmUba7k2BkkSjH7W+7tCu
         14X7ItWQrSyihS3CBV1+SJtSWlf30rhZq8t9WuZx7NcWPx8vVo6JhM0kNR6qsWbbL3u7
         ExAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794543017; x=1795147817;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=0dyLUPgXHh//k1rqYdikzfnU/k9m9fgYRI9bsvixd+8=;
        b=lZoendCmNWsym5KUhk6V54mpqib9o7wW0ioHkteXjk353/9u4AppFfmsIEblUrq0y8
         z5T6I3VldhJ4jmltUMXOYQFAfcRi7oA161zbIkkt2XG3NDZYJ9xfyd/3gpodBxivu1PR
         q/ZDaYl3Kr6u3iZqRh6rWwYqQPXlzUaoojISabn+6thZNtQi7Sh/RCq8e0Bww4C55bbD
         UV3/6e4oMbCRSpyEkOUdkMPuj6moeTpgSvYXc+P3d0+UAGkAfwzjX5rrKircqlRV5vMu
         ADiGxaHOM6lje+QoAgM6Fe1fQ/GiGpg0UB4jOgN88JBGXP86n6NfZpRDZlknO7ZHZJGY
         qXqg==
X-Gm-Message-State: APuU4Z8WScZARQ7egyAARXfbpKoIxtkMBENlM4AnoJf7X2Wnvdyz9sDo
	BOaIhj6CabKl7dCMSKa9+2psLHrDd5NbIJ6nYIQhd8DoHyekNVMGdi23
X-Gm-Gg: AYBFou1SMkNt3rNZxK9SmnGHqgd5RWud297LNOCWYHrLXwEeuNzsKWXjMul0cZnqI2F
	Zn/1Jq970tbTClxdq7wkQzksYlgUWPWiKMn9RUcxLrapKUEPYwfjrHYsOZndTFO8DwX+i6Y4IJA
	3T4Ae106Fi3Y6vJ7JWgAxcX67uXVRgpI+v18yC4CRkdQQa2rlL9ZgsbvPPtYt1ag6ArwZGsnlZS
	/smmtgPorxrjIh4cvjnSyAL0psC1DwrNZUmbA15rU4VZyV0APoN8Doi4lOtGQL6yLStM43TwuE7
	zyUkWMiK5EJAJZKd+7ILZv3bDIMoIBAMiqODc0DeFAstpHnPj1/Igo3h+audHkk+3+KuWb8qdKL
	iPTdGQhg3mqqHIpWwN7TPGX/K7kpGx4i6CSkc8T2plNyKg010rNr+0PN9T/TpMmUaHNNCXSufVw
	9+dLTEuQkv6NPtWzf+V8RXSv02braUxhN+TK+qsBkFznhenwPVjGL5Q3eN+yWBtpYVLz1x7DSo9
	u8TgSrvclbb0uRyLcIes6+TgDEnBgEs1qQruVfgdCryZ7+RqN5WDqR/RN15sge9CeCycBHlnUGL
	5loE3hK+mLif85hvPg==
X-Received: by 2002:a05:6102:604b:b0:7d2:840b:b064 with SMTP id ada2fe7eead31-7d64d47e1a7mr270019137.3.1794543016557;
        Thu, 12 Nov 2026 20:10:16 -0800 (PST)
Received: from [192.168.0.8] ([2a09:bac5:565c:aa::11:1e5])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d64c47fb86sm792188137.6.2026.11.12.20.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 20:10:15 -0800 (PST)
From: =?utf-8?q?Oscar_Alejandro_S=C3=A1nchez_Lucero?= <aleszlucero@gmail.com>
Date: Thu, 12 Nov 2026 22:10:11 -0600
Subject: [PATCH] mm/folio_batch: document missing struct members
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261112-folio-batch-doc-v1-1-e5a1c013e4d6@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MTQqAIBBA4avErBtopB/pKtHCdKyByNCIQLp70
 vJbvJchcRROMFYZIt+SJBwFVFdgN3OsjOKKQTWqJyKFPuwScDGX3dAFi960fmDSbHUHpToje3n
 +4zS/7wfLKgF3YQAAAA==
X-Change-ID: 20261112-folio-batch-doc-fa4f7e18ec85
To: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Oscar_Alejandro_S=C3=A1nchez_Lucero?= <aleszlucero@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794543013; l=1225;
 i=aleszlucero@gmail.com; s=20261104; h=from:subject:message-id;
 bh=OMAbBXvcemwxXwqU4ezuLdvFSjrFqp0C4mq99sFmFE4=;
 b=yDZIedPEmQr67Ky69DJnIrFX8e3/p9mJnummgDENZMYpyxQ8XE27tvk6nU/6EHyLj9FghMcf6
 blVDfBk9GPOCNDs30cjFrRULD1ACSu2V2en8//kQ1xdW07VpgniI14c
X-Developer-Key: i=aleszlucero@gmail.com; a=ed25519;
 pk=zRzEBMID7l1FXqr2CjfnlIn++3m3N05FuNYb5zPA3cw=
X-Stat-Signature: yq83548oo4rg6cbhwbapf9tk3rr4nwmm
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9CE7240006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794543017-537725
X-HE-Meta: U2FsdGVkX1+j8h+oIw9Bvl+6L3An77EH2BjIeoFSL0Uqr8ZdMqD3wZ3g5t/H1oY5bjD8qrw6JkcdPQbTagITjDLH9c2BUEOSddpxi4ZWgOlmRTwy53i/zNQyFwy9sXwBSR9X/cIrucO5nuueAT5lr9Xrgp+B/pnlZJ3X0AL8A+LLhTysGMwic4Tdx3BVIuE934bzzYkP2W9CodvThsfAes/l3P6SK2H6W8S5S3CXU/R3OlWz8MfKefHiHQ0ome2UNbeHvkPD/A+Ohu9jvdZ5G2Ob4b8Ud1JyqltMDvz86NIDJJcJZa8GfwYuDbK3BI05cAPipzW70++DqpGrek/vnDozspFnKF3MkBftTRc8GSadGGPRiGbZWWyegvK5e3J7/X4zxdHrYPLwc4ab9hgldoVplRri9MATVI60pa4tmT4gjNxdA30EvZyYO3CDetgvqR23ynK6qbteW5K2KgtP90R+Q3XblG+tLWFn6xXkfCySJq1te6O+5tBjxPBJdqKEq88YdtH+kuvbe+/n9wrrDJM+Zufsz2lafTTeIQcni950yUe97n1ZT/qAkcjt3GnC9NdnEInpA7DCs1MN+7l3Pe/cOM2dRCEoZDASOmbc2ItsuVHTDAGdaQ1+hbKz1dXwfjM8G3tcKTaZ2VL5jdj7fFAIjIYc9/RSKvdJAeHf5FgX5lycRwnnOdrUV/N0eHsWPIRhvx8YYOCJ2vbf5S4wsZGBUh3KWm7Db6zvMtjiPMY4rzv94uQJYygrTi1nLNlY6h62Pi/dnXPKCFF6Lkc+bH41wG+25geXi6ZkvWRX8UfssXuGqhKSfwRve3T0cV+y8aqpXSovO9KA9X1zXOFvPKhYS3rRlQdf1lSZX+iXo2vihUg52kqgLh4mJbNER++8Ps+BLLjqNg8YNLNopTeuoFPdjWw8QbYhBJgqCDH4FpQNSXUjfYPsplschmlhL63HSnyMxmEmtCOwpVZPH3V
 QN3DQMeP
 yqHzw0qYGeCg1pdBLxohSHEDWZQTE8cP4NLVd3qWl0V50VbdHr4HjnKZRCxXRNK6DwmuHUFgC8uydEWBQiOnZzAu8ndHXnj6UNOjQ0ziUW7rffu8kyyFNIusMsu0e/5DkaYfTzhfLddeOOtLJ6f3PArT+MC5mYsmMi+3IlbJFI/p+3i1jaSWIJX4Bsny+juBqSIAc3mbd1au8eCu+kyefp7GUWabTRFw8BwPAptqhYFjNQBQex9/GClaSdySk6AJ2lpzoWqYRfByuSAoAUMX4LG+kN17jREmIz+B4DAW9/Ev499D3r1z+JdwrUgkOQLYDB1yNBWCVb0bfH72bij53JXaRsQk/okcAgUHtR5GwUtbJkX+2e6YOWjInDcuDAdfDTzwXo87sNbfNNbcX0CMWU9LQfeB4Ag5Mt+y65s5pkCk5J/+eyhHVF4irXdzFPhCuNVbuxjY0Gn9OcS+ZnzTqk5hifJ/f2k6cDvvKPIVZ8Klrm35jG+uJ+B9C2ugYQc0xDfojEJAGzDba5aNnq1xR2r1nmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add missing kernel-doc descriptions for @nr, @i, @percpu_pvec_drained,
and @folios in struct folio_batch to fix warnings.

Signed-off-by: Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>
---
 include/linux/folio_batch.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/folio_batch.h b/include/linux/folio_batch.h
index b45946adc50b..7731dcd249a8 100644
--- a/include/linux/folio_batch.h
+++ b/include/linux/folio_batch.h
@@ -18,6 +18,11 @@ struct folio;
 
 /**
  * struct folio_batch - A collection of folios.
+ * @nr: Number of folios currently in the batch.
+ * @i: Index of the next folio to process in folio_batch_next().
+ * @percpu_pvec_drained: Whether the per-CPU deferred LRU queues have already
+ *                       been drained during __folio_batch_release().
+ * @folios: Array of pointers to the folios in the batch.
  *
  * The folio_batch is used to amortise the cost of retrieving and
  * operating on a set of folios.  The order of folios in the batch may be

---
base-commit: 9d66f26fefacebfeed15de31c1123451a17ff119
change-id: 20261112-folio-batch-doc-fa4f7e18ec85

Best regards,
-- 
Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>


