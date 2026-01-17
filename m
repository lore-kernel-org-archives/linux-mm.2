Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68235C98303
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 02:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1496B0005; Fri, 16 Jan 2026 21:49:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A44876B0088; Fri, 16 Jan 2026 21:49:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97BA26B0089; Fri, 16 Jan 2026 21:49:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8058A6B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 21:49:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 14C941A0301
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:49:18 +0000 (UTC)
X-FDA: 84339924396.09.20030EC
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3C65B180003
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:49:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=TJb4Au16;
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768618156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ltCImzVsYOrvhYk1oTG8nKP6i8CBZtCNaMyQqLS/sX8=;
	b=FnQOTQKDup0juzH3VYZVJ5a+KEXNmFLewscuUGfe77MyPDVCwLdLLAxUUES348+LkxOSsm
	UO03NbkQgB0tVdtm+vWiBRjxlYaRfaQ6ypUN4G1S0DV7MGpMDVsnKeM9v/uJVjk1UllY9J
	LUAdP0ZghTT7Demcphlgm6YyHOEXjr8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=TJb4Au16;
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768618156; a=rsa-sha256;
	cv=none;
	b=VGr1vwDbhJUhC33ysuL3EokAVGQU/Ekjs/voj5n/5ejrL+F1yvv4UVjaZUxPRa6jCQ/Nv2
	E18bCR8jwmWQOArBn+cXdKB/fGZ1zoj3KNXHvs0bTJWv+9yzFQFZf4ZdP5pR27nRWKeWVR
	5e0WipQHcf2MgaJbvue7JkShxKzZpPU=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c47ee987401so1098823a12.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768618155; x=1769222955; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ltCImzVsYOrvhYk1oTG8nKP6i8CBZtCNaMyQqLS/sX8=;
        b=TJb4Au16s+IGFf6LlhkirK4Fht8aojFPyuWPsyWBt96adcm6F9FjXBTigsJiuNH5r7
         o3keWxWqBkv3AlMJwqExnafdJCkSNFMIKl7UTJIgOBoW3o2iVNaI/yGMa2i4Sq2X8IuS
         s4XcAuySTQqlFZEJvigEEYDf5XzEQVGSvda6Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768618155; x=1769222955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ltCImzVsYOrvhYk1oTG8nKP6i8CBZtCNaMyQqLS/sX8=;
        b=KVH4cQfuj3KIiNAXq0g+AI7vsmS7SGvQvDv40jI6PhJxYrLaNdtKPamx5Y5t1UVt20
         ZHB1L7u4sjJNi6ZDH+RfkbVmX3XrTpjLuNevrzoE/xXDOglxAj0qWnMSn1aoGr80j3g1
         98u0jWVGnUzJciqqIeyfmAQQAtieLy+KpxgqowYsfO9I/uoom7KO7qAJpDF4KuGqD19g
         Qnzk9JwtCviuzmOch5tjzRbEXzOvzY1xlnqCp9oAZO0LRcFHnUtHQXjCiU21ZTqaZQ7w
         /Om17lbZvXg5nbyYeg0/EOUHC9P0rq368nnRgeftDh4yGkOIEtaCkFLFEmDeD/1s839p
         p1Iw==
X-Forwarded-Encrypted: i=1; AJvYcCUothWRXAOe6C6yC8VD70Vj24p6e7sQelsJUmhftFpSFDgPHkISWI3r4rkDx1xLDgeF9Ujz8vZFfQ==@kvack.org
X-Gm-Message-State: AOJu0YyVCS1u1qa3FcUGXtK4LLRhvPA7NC4pz623szI5WhFCI7a27+eG
	BA5CbV2kekrnVrYJofHD/zrwwXeM6fZFVdewNS1Nn1cKrY84WO5C+V9GLmXQVM97vA==
X-Gm-Gg: AY/fxX4hieT1DMOuTfWtpzC4Be8VlMIyDgo0R3TLNlfOJHMWQYjD6YQ1aG1N9NyLl5B
	/FENqBDrwYNwNNzf0pkLEwmBKW5Fww0dTgAJoevPb23aUDwmRT5+WnTUeHjAJOqKZ2Agc6q1cQl
	+CnmzOGtK1Iz7ObNbqSUqk1oajIu9ASVUhzMN/ALhu8iGwnKTcc+rDD/NMtHvVifXoRvQWbikSI
	9ji35rHZFLPaQVDk33+hdB6xCRWgIlKrcEW42b/kbfUsZ+pj9aPHweE+G13Xi4U5mcLz5aq+2em
	YwGerost3nH32ywVbm9/a7CsF8iIB2Y/Ix93zhJ4qnXGPk66sxB72DQMXifoZS1FrrvcYVuHryE
	8d+AsEZWQSe9R5J5ZQhWE/oXTk+IdnEV/AGfhY5hfdgUeMyII5k9JU1VBo6sFYCFQJgklgfUJqu
	jYelb+xlh8/QijP0wy3usa4TvLcsnxxI6e9ykSxr+gHXbyg4mdbZ28olTEioyx2AyfPC2JTItUT
	Q==
X-Received: by 2002:a05:6a21:4d92:b0:35d:d477:a7f9 with SMTP id adf61e73a8af0-38dff28c08amr4379072637.12.1768618155119;
        Fri, 16 Jan 2026 18:49:15 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:fb0f:ccef:d815:5581])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-352733adebfsm1587019a91.1.2026.01.16.18.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 18:49:14 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH] zsmalloc: fixup zsmalloc-introduce-sg-list-based-object-read-api.patch
Date: Sat, 17 Jan 2026 11:48:40 +0900
Message-ID: <20260117024900.792237-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260114001121.5B6ADC19421@smtp.kernel.org>
References: <20260114001121.5B6ADC19421@smtp.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3C65B180003
X-Stat-Signature: n7smznxqcam1wi7jthwzkr5zu3racucz
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768618156-824985
X-HE-Meta: U2FsdGVkX1+tEx7Ti44l0fXmEOXFVlnEFrTLAAcSRDkXGiNiSXRdJsw4F25tR1RbsK+0weDhw3TdIOq42NJUsQrJw1FUZZc5zCd3uBoGc7di2wva73t6zcUcli2HzVuudvn78pFTWslFoMRHuvGzikzkYsNe0I0Q2jjb+UhmgrtmBSOySEekIYqLUhLRrQ/OMIKmeBSz6TMMw1hFkL/UwC6SiM5cKKZC3/JfsfaNtCBpj4gqdfxNFO0a550WpCU7My32gMiwg2LVVVxi9SGg7OjEDPWUjmw33FmNdXwTpfx2TMlIEeyenlzG5ti6ZhzMwfMMgIOQt/XxxgoDjPQcZMseI5a3Zs6uzC1O65Tbnthk2PXLJoL8kmQ8lGMp7oEqXXtexNZLM2mjWzGH4qFQNI4oDCEq5SsLwROXg04RpaIMmP4Eo5QIWnImcumINb3YNacnltL11ICRRdfOqlcoAmjMXj5XsJjAeSKVkAYifeXkEnt6rbf81ODi2Iods4ER1Lx8zpCGzxR9uukaqPrz9ht+2yvOIVk3FcCfaPlNbhD3ImpxyKLhU6OP6f7hCDNz43qhefR1Gifa4mhXSVCVBOz5aEFtq77uH43tHuhgL7gIptf3YtHZdcvkrCqFNGz9gpDI2BSXdEsysW9dFN0GQCGqVFb4gsze2LLXO/kQSwmKiJMuVf+aSPPgwsrhHuYJJJMwnwS10HKOHnsoFjl/5tVldTtcLZ7fIzZPJQ3JeWUDRFJBHZ3Cx/GVxVjPqHOC2cKrNp0sjUMJSGD/Zh7GQ6dz5PTSCjYllizqBIlFdKIrIF9vaUMgPmMdO1ANe/QTLZCm6eAk03nS1P2VQark42e/AzmcxmWjNIu1+66R8Dn11QoKmWAk8bTNqiY63iN2z+kzZ7xrzrY9LPVN3ACtgRptnarrPZt45UuqXZscqqmYtnbyH0q06ZUZyAHhlsn2YItvE3Odb0X4U7HXyKf
 qoKFB9GN
 KNdPg3OEd24nBqbD/OZKgLul0vyJ/NRyBs/qtR8iHnpq2zH7TVSdwe712Ce/YSEP1rz1BbPDjc681soOO732Nk2KEDsBKKbaLeEgEAuvtYbm2H8vk+pCK+K4vIOQUjMzYfgb4L7kCweC4spVN9B1uXUpTSSjsa5xzquLgffyxzOeK5oYgvrMMTD/I89hxHsxwg2SsQdnS+DhiK+3LuVsKbDLLFgK75qUF/ok8IQ/uHhG56IYthLIbR1eR7uD9vrEOWv/6slCLdNHlJhujyQMPnbX5lruZGjoSk655vwmy8fnil53tEASn2yxXNqcDedPbJ0DymM8c0OsU817nKyTb7fOTDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zs_obj_read_sg_begin() always returns 0, convert it to void (per Yosry).

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 include/linux/zsmalloc.h | 4 ++--
 mm/zsmalloc.c            | 6 ++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 11e614663dd3..478410c880b1 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -44,8 +44,8 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
 			size_t mem_len, void *local_copy);
 void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
 		     size_t mem_len, void *handle_mem);
-int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
-		   struct scatterlist *sg, size_t mem_len);
+void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
+			  struct scatterlist *sg, size_t mem_len);
 void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
 void zs_obj_write(struct zs_pool *pool, unsigned long handle,
 		  void *handle_mem, size_t mem_len);
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 5abb8bc0956a..5a68349403d5 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1147,8 +1147,8 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_end);
 
-int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
-			 struct scatterlist *sg, size_t mem_len)
+void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
+			  struct scatterlist *sg, size_t mem_len)
 {
 	struct zspage *zspage;
 	struct zpdesc *zpdesc;
@@ -1191,8 +1191,6 @@ int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
 
 		sg_set_page(sg, zpdesc_page(zpdesc), sizes[1], 0);
 	}
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_sg_begin);
 
-- 
2.52.0.457.g6b5491de43-goog


