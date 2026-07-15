Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E2ADC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34F5F6B008C; Wed, 15 Jul 2026 10:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 300636B0096; Wed, 15 Jul 2026 10:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EF4C6B0098; Wed, 15 Jul 2026 10:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E11106B008C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:37:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 766211401C4
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:37:06 +0000 (UTC)
X-FDA: 84991263252.07.3561D40
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id AEDBDA000B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:37:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eTT7jjpO;
	spf=pass (imf15.hostedemail.com: domain of gaikwad.dcg@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=gaikwad.dcg@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784126224;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZT6vdOdhwC/AsmQEkeWpnNcH/bprH+MunGvD8DHMRhw=;
	b=0kzxBLRcLfswDelXcrCLRWyhTuP7zG3DlXo3V1NjWugPYsKst91u5m5rFRtV9LnzPCb666
	4cb2r9C3ClpuQ7tAdTY0QZIlS6yPW89UBmc/kJJPIw3D25uWLg3+Pnc6eTbhvIJQFcSfyY
	I1gjq5kg7dCH5/vzpmXBrlttQcaj8zs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eTT7jjpO;
	spf=pass (imf15.hostedemail.com: domain of gaikwad.dcg@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=gaikwad.dcg@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784126224;
	b=hj55HxA/JH0bCnrsR4Rly7pBUFdK3QbKLimFz6XrD90RxQ+iCWdU71tV+9HSUmp7IQGN/n
	tJ3bWA6AtN/9vUK2Ewhc8SZbLc6P6ZyhJrvTZd7UFPD3eARsi1alw8QSYUS3jcd0nOiDFe
	hP/iM6sV4lpDH3goCJ4nkMLQ37BcRfc=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8485b358552so6113291b3a.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 07:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784126223; x=1784731023; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZT6vdOdhwC/AsmQEkeWpnNcH/bprH+MunGvD8DHMRhw=;
        b=eTT7jjpOlpr1tnSMN/Zy6sV7iFeBtCtFiFTM/RxeFzzwTWaEkqPzOY6/9h9qj2F7Kp
         +LSIj2Rze40YoNRzPXFbdthDrjScc1F6b06/EPJ38Nuxg2fCMaysnLqMtnv3oXxxMYDl
         VYWDtcTR/dE5toPlcMr8PoyCS20cS/7vSqV42vp5eMVvqHQ3XopXA5nAEU2pXXp3I3iO
         /C5tQZOn2rZXzA1LIlOlgzBtOcM4d46Iq9v7TSCATf/vc96PBs11vIcHaM/XGe63qTCF
         PzD6dWD+5wQrqbqLLDs1wp1r7SQ0IkKaWVLc64RhjhYdXjWxQW6wlIhDCFuIpKdSJoyc
         RC5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784126223; x=1784731023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:sender:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZT6vdOdhwC/AsmQEkeWpnNcH/bprH+MunGvD8DHMRhw=;
        b=nZSc6EcAiEsiAdSQUBIPb9nmL7WXiKVVqJrH7vNcpsl+6N4o5mqY65oMLZd/iud6NY
         vHlkypyqv+AYTYWgjmcV8cW3B7K0EEcZjKKianYIGZsLXiC5AHmuZIty6ki/m4sHkT9E
         hTinOWK5yH52Ny5SoSWu7cY3OyWP7WYKVUSGamnPZOsE3B/8y2NZSYQLX5QJQePYQj3O
         zH9aQ/J9BjIvDKYOheZ/QKMd/h4kCA7D9LOeqt4lmvFOPKNxLYc7TqNE8gUJPGgUJ5EL
         wjbYBjolvzs19bJRMObVcrpyNcVAQh3dP1oJ6uN1cFlARTNOMWtOmME5eW/hcx94jGzJ
         YgJw==
X-Forwarded-Encrypted: i=1; AHgh+RqzzumBN8mP6sPO2bn9MYQSKtMBSe2Mhwq4PEx9MMfVdDet7wTKGKvl9Yq6KUiLJsiwJYSvgbvt+g==@kvack.org
X-Gm-Message-State: AOJu0YzrLjycYPuh5VK9OINHxbtZbfLKCAfZNlPWe1ruW6JHeRbmD5n8
	kXk8CaNEb8pWNXPb7fQvTx33rRUzj8xUQ0Y/04vWCBrr/Xb/+5PuISJh
X-Gm-Gg: AfdE7cndBiB6LwCI2ZoPtghBOHQaz7etAGth08y8oahb7LA0l9sJ+4rNBoVWM295Byo
	o2a1bm/FeR0J/ow576KDl6wrLlYYC1Ueiui1fky/H5pinfaGx0TaBMPdCdYc0dd6OGkr7P8Wxef
	kmnJ/YBtmXznrbJJr5xyNd1GZvD41HJlrsW3YazotDXiK2X2hDXMSjf3ptjTHwZwIuuwZAHbj4A
	eCFUTDziHuUsun2ik82FyYfZ4S7WcXMuvgn9ZJQeLMHRHk4OqBg21eoxjL6gvb7GM8Q3VkKi/pC
	qvS8sSmlRSI8/moxDfpMbjpInNLTQhE5H050j7loPjTzwr9UNH5hccF4K9Z1y8MCfHX/x1I5S7C
	w+2HdzWJgcjpexDCVZyQc2QapeajYyk9SgsCZSU1GobsW3JIxgn5j+es8oAG6yzB9QSvodV75My
	EBMJSNdDffhr1nn0nE8X8GTPunvyp3g7ZUhHF7fvtDHTInjub7Eb0=
X-Received: by 2002:a05:6a21:610f:b0:3bf:6c08:fb9c with SMTP id adf61e73a8af0-3c35754eddbmr8066746637.48.1784126223500;
        Wed, 15 Jul 2026 07:37:03 -0700 (PDT)
Received: from localhost.localdomain ([2406:7400:90:2db1:3066:c473:74d2:497d])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e4fd3e9sm2020161eec.1.2026.07.15.07.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 07:37:02 -0700 (PDT)
From: deepakraog <gaikwad.dcg@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] mm: vrealloc: grow vm_area mappings in place
Date: Wed, 15 Jul 2026 20:06:43 +0530
Message-ID: <20260715143646.15828-3-gaikwad.dcg@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715143646.15828-1-gaikwad.dcg@gmail.com>
References: <20260715143646.15828-1-gaikwad.dcg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7w8g9z1xpd1uoza1hpsoomf7o8mufjx3
X-Rspamd-Queue-Id: AEDBDA000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784126224-697849
X-HE-Meta: U2FsdGVkX1+Y+ihqK7/iXzGaGe8UKJSRUcmpdxhtNlaJSFqV5PDX8eiQwN/CKUpj16LtrlP+oF6uLaZMDQnXRbNUwjV4tAmvty/3EEoOOjCep0Kw+ipa2gDyYa8m4khyWW/BQl5jdmy7wp7d/CizblbtLEyATmaFPWUcLz0UfiGyRSsogcX3p6Y3NvCfa6FwaSwVuNaze3IDFA0cZezYbJT2DMfVBPV+3ll3NA55m5H2BpkSb46JDaQYdDFs5H2SLiex/OZdxgbn8A5yUIlRTIOzMPc2tLrrc9ZZokpaMltDU/jGA44ASdE3auwB15ROSw75DMR9hUwG+aLfRIuVYd2oqW4OW3pt7xArOpDLTY3wSI88NLLmFnEzQiySYGzifDX2kwPJFPXHn3Ya4lpiK8/O/xLqrdVesslNgICI1dtTCpAw+UcUdT+Ak1uu7ZyntT5ol4VvP9rVMWuboGEP80UQT1BQxmycs2VSNEboVnAbfPk9yXoEAo+2yz7w5j4MUJmdKBpRL8gBm2bRGK+BeOlsN9tg6JoZClaSKriTKJfxF05sqKbCk/0V0fnE2K5VgMo1MBl4/1zM568oRBW68mpPPvP9YfDWqcZ/bJ6gai1lHI7oLiln3O7S0aAM0F25cO/M48/CWyTiQtU06AiwD/miFxZl26IjpD18Uiu8nfxGlMLVgxH6zOYcQt7yu67ku1tzatMU7RmqOr0NP5eVtWOgDdIE97Ax3F+7abtz97S4LQR0ps3uj56aCQsnrUk6JUquE51hrB19t06Nq2hh2cnFxbjuBHuWBsZdvUxv1ReUU5wIsrOT/1IptQqdj9SgdVUDTO6rYJ19oLJPN5uFYx2Ze7vMA6AxBlr0chawS+pApenUQDdC+mAaDUd5hCOUDD676tHY29Ah+FXq5zs8YZDlNnYxS+aosreRdGIO9hQnPGmKSeH9tH/8bw2PB+rXBN7j7qkdJKBt4i3ljDZ
 Lu3kG0ol
 1+ITiSnSKU7Bc4pc2pzphjLOto5Ml5VVIHlab1t2lXYZF4LqPosYt5/zrn+gevaDy0ilJ7tJIa8X2+ejFK05TmT256F9rq7Hp5pnrCHJm32a+MuH50moWFj6iK0ggvRbtun8eV2hS+B2N12J7mWoqEYRgYoSL5CbIOVegqO+XleW0IhuJDajKBPXv4j4TrD2RnhnZLgroDbA1eJh1IAaYs14w0rpDyz6wccCXiulXMiyInyVoJmuXfByG62wcOvhEYR3g0lI4qCTZ/5jOF2GfBkMdAuYaox/kfSwgPjRdqNbXp/mz5CCYy3QnX+GOzmZD73RSUOFbCe3TcuKiG7yqnO+RXv/WSdwplPYKZZFrIbELQSxKDcldSd11Q4ErtdzQ5t9u25uE1dv5R6MoIum9WVm4u90BA3CRyJQcqkOvgfelk2XquGzZdU9omEtdDS9Fp40EU8TEHWUL2GYOquxZqSb+8N4OCJQvHIZztfyHGrwM5Bq+A6qBMh68WA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When vrealloc() needs more pages than are currently mapped, allocate and
map additional pages at the end of the existing vm_area instead of
always allocating a new area and memcpy()'ing. Fall back to the
existing realloc path when in-place grow is not possible.

Signed-off-by: deepakraog <gaikwad.dcg@gmail.com>
---
 mm/vmalloc.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1afca3568..46cf10c62 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4426,8 +4426,56 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 		return (void *)p;
 	}
 
+	{
+		unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+		unsigned int old_nr_pages = vm->nr_pages;
+
+		if (new_nr_pages > old_nr_pages && !vm_area_page_order(vm) &&
+		    !(vm->flags & (VM_FLUSH_RESET_PERMS | VM_USERMAP)) &&
+		    gfp_has_io_fs(flags)) {
+			unsigned int extra = new_nr_pages - old_nr_pages;
+			unsigned long addr = (unsigned long)kasan_reset_tag(p);
+			struct vmap_node *vn = addr_to_node(addr);
+			struct page **pages;
+			int ret;
+
+			pages = kvmalloc_array(extra, sizeof(struct page *), gfp);
+			if (!pages)
+				goto need_realloc;
+
+			if (vm_area_alloc_pages(vmalloc_gfp_adjust(gfp, 0), nid,
+						0, extra, pages) != extra) {
+				kvfree(pages);
+				goto need_realloc;
+			}
+
+			spin_lock(&vn->busy.lock);
+			ret = vmap_pages_range(addr + ((unsigned long)old_nr_pages
+						       << PAGE_SHIFT),
+					       addr + ((unsigned long)new_nr_pages
+						       << PAGE_SHIFT),
+					       PAGE_KERNEL, pages, PAGE_SHIFT);
+			spin_unlock(&vn->busy.lock);
+			if (ret < 0) {
+				free_pages_bulk(pages, extra);
+				kvfree(pages);
+				goto need_realloc;
+			}
+
+			memcpy(&vm->pages[old_nr_pages], pages,
+			       extra * sizeof(struct page *));
+			kvfree(pages);
+			vm->nr_pages = new_nr_pages;
+			vm->requested_size = size;
+			kasan_vrealloc(p, old_size, size);
+			if (want_init_on_alloc(flags))
+				memset((void *)p + old_size, 0, size - old_size);
+			return (void *)p;
+		}
+	}
+
 need_realloc:
-	/* TODO: Grow the vm_area, i.e. allocate and map additional pages. */
+	/* Fall back to a fresh vm_area when in-place grow is not possible. */
 	n = __vmalloc_node_noprof(size, align, flags, nid, __builtin_return_address(0));
 
 	if (!n)
-- 
Deepak Rao Gaikwad


