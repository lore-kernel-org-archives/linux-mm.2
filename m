Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92DEACD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 19:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02C156B008A; Mon,  4 May 2026 15:55:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8056B008C; Mon,  4 May 2026 15:55:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D98F56B0092; Mon,  4 May 2026 15:55:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C94A46B008A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 15:55:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51AB5C1457
	for <linux-mm@kvack.org>; Mon,  4 May 2026 19:55:01 +0000 (UTC)
X-FDA: 84730790802.05.271D17A
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3D8C2100005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 19:54:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=smQLbvXp;
	spf=pass (imf14.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777924499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=erT6UBqquuMP02SpaxioEEnOQAd0rZiSq9AXy326h74=;
	b=NNBSHy6iFTgOhEbtWEqEKcH7+XlAknPCqT/g7FdK3EwYMvPoID56wwB3RUYWc8UfULkVXf
	VFtUCYH9qksm5bEZHxaP/ulH2ymF71piEphKFw7SNOXbihE77KzGb61Ut+CFIXfq3flS5A
	aK8fgBHuxvpvutXm1G6dI/gukJmzKVE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=smQLbvXp;
	spf=pass (imf14.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777924499; a=rsa-sha256;
	cv=none;
	b=2avjZXgM7pUUHTntAuiQXZ9QLTPpHaJoTj3YJNijdbSPeWf2kO10CYv/1J+2ULJEiS1/m+
	Cj1aYgb7c/63XwRsw0AFnU3k8HsIc3HuPX1xiiK+Edr4uYGvpYNmrCiG3ZUl9CxLI1JiT8
	vRGbi2nktzBZ0clE6glpEX4jjj22tds=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-449d6c68ed8so3375619f8f.0
        for <linux-mm@kvack.org>; Mon, 04 May 2026 12:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777924498; x=1778529298; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=erT6UBqquuMP02SpaxioEEnOQAd0rZiSq9AXy326h74=;
        b=smQLbvXp5UxisyDECx+IQcbXYCNFhLRrD/1BQDIR3z54iD+Nxg++LOamlothJj904A
         idU7Ejd56jao7hnGOg10tRTQjkcbplujqir8/EEzdLdxwQhu9Pz+iSk867L0BsTtcTVn
         aTbdmScqj2LtbHH4xxV1FV0AFg2AU9yU8sVf7KqZpP2YgdwTHAXjOLVlUqIp3Oy6BeZU
         pcNqNA9M2BueNLJZW3ygGxzVq1JZnRMEVuNVWP+Ce06Ooch1DRHprigBLvGaakljcpSj
         YU43aKvJu8AGiTtRPw7DsMdhCfO+lZBKRFICVUT7Y7Xx6eor7Hp3CMfMMIlJZqBc4MfY
         ogrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777924498; x=1778529298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=erT6UBqquuMP02SpaxioEEnOQAd0rZiSq9AXy326h74=;
        b=W44f6tuWLT9NJuxo0QnZIf4aJjEfQk1KmMSQRaq46bWgNflxNt4yNkeM7e7CIK/K8k
         XcdfXogV4NYsnzVgMrotvVIjmYlUvkPTt61l+BXZnTYbJ/HmXokiS3YwNavhWjKvjWtl
         VC6gWsBfnouzKc6XJXUoJboutFf3QrdQlgtB/o22CejtlU0we61Idci1q9QtlvrZYOOO
         Z9/FpBbHr+CbFpEiI3NSkqfmrp7CCSY3VlkqRhm6N7dKKNHyLM5QLiH2aKP0tH+QJaeU
         CJlgqU9pBbuQSt3GpuVctjEQY9CFPknJzQTEJ9d0kCtzvE1dE5+UCI/zv5GKSkXbzLJ3
         ZIsg==
X-Forwarded-Encrypted: i=1; AFNElJ+AzxItVaRwLuWxqvgaCc0o7lXLe4qyDx7Oo1s6qOfPSJaq/ONnc7yoQoGiAQxvznaPczaavAqV4A==@kvack.org
X-Gm-Message-State: AOJu0YyEG0ffzpQRgMWjfUu15qYu1cXPXHPwFncVDEv1qHjf30p/1LtI
	AY7t90SZlwoCcySH14QFon1Sr1oKJh16GITgVRV7LuDIIlemQv5a8JuD
X-Gm-Gg: AeBDieuoKba3uQsL//y1fnFfbgjPIKZvIEXuysQ2pxnjL+Twg8T1bgDoEddkaEkYVCn
	DW9SiQsAuw2c7uN79I36WmXQMSCpQXJje03oL2IqF1pfIrTd73v2F4UunesbE0uNX9eVyLQJVAO
	eVAqXn187xtlTvX3O2RMo0qmQ/PGdtxezCiGRnZHm4bhWAlgsBb8u3LVchv0VbDz4+n0tTaIIKt
	4uITBrxfhzGVaWKC5no80aOfRYiEwxwCsgdthWLlKtrzq4bDAvp4LaDbJohb18sbBB/5F6IIWYg
	vYgkpgwjZ9fGN/tiA1Nbx86FufIhi7dopkU8DA/1HaCJSjZWZ1wWN9YD4RnBTdkf0eTNXkpCrcW
	LjMiAgT+hxOVvqkgZYITwrcjheGE4lXUyZZJWF7fENqvTYYuagNjLmE7fTXiGCvQPxW/+MiFMGg
	BDEroK07YbKS46N/Ex22u3yekvX52LUdnBsUATAApo
X-Received: by 2002:a05:6000:228a:b0:43f:df1b:9e07 with SMTP id ffacd0b85a97d-44bb6ab19c2mr18028339f8f.42.1777924497759;
        Mon, 04 May 2026 12:54:57 -0700 (PDT)
Received: from fedora ([156.207.149.151])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4500f8ce84csm275794f8f.19.2026.05.04.12.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 12:54:57 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: Andrei Vagin <avagin@gmail.com>
Cc: stable@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	Ahmed Elaidy <elaidya225@gmail.com>
Subject: [PATCH 6.18.y v3] mm: fix VM_SOFTDIRTY propagation on VMA merge
Date: Mon,  4 May 2026 22:54:47 +0300
Message-ID: <20260504195447.31794-1-elaidya225@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <CANaxB-xFcF7U=wJv8EqKy=j=-P3SN+sLQ9ytH8Ej69h03tqL8Q@mail.gmail.com>
References: <CANaxB-xFcF7U=wJv8EqKy=j=-P3SN+sLQ9ytH8Ej69h03tqL8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3D8C2100005
X-Stat-Signature: bsmenahcj7k6f36qs95o85kersq3qi6q
X-HE-Tag: 1777924499-62028
X-HE-Meta: U2FsdGVkX19n8tPzOFoz+ZMVFPdMi+lvAgh4dp/onLP2M6+zZeJOaydSA473Xw6jdLcbgoAs2rXSIXFxGoJEVMY+GQ8pVlIyXfPmytrtYye9KxY1RVQ9GgdsjqPw25PZ/yqrqAPd7zBhMgMA5hLgC+4U7g0bBlgMHYpvBle6F0NZCHzLufx9/wzu1pQhQkWEJpy1OcJFYM23U13jE4vf5KI/31k1Ss7HCHE2psdcZAV1njeLrmnyWugUUzoCbP3i7t8rkAJTgxRW//NQnUoUCQ1OAg+vsYAeNtY9xkpgbDCALPhg6gk4bKmqUohe0xNvuOyLP4b11vSUyWxCDv9cO8PFQp2MOmObHclGEeJChQIPXmfNHUINwOtbJcR79fJXlimuzrwjZC/OB5vjZbg60sjut8BUStwr6i2uw5JtPSpahdxk4arDKghdrO4KVK5JSQt4up3WPvjIgHu1nmpNFgzc4bolJyCRsiPywQCfNHHnGA66uSbzvQnpkrIEyiW9GsTyDPMPdSfQc674KQ2OZbVxL79s/mD+L79Dd1UFlf4cxPro55zjnRQSSdsfvk1EZqlDEsk8elzD1PDNxDsm3GIMrGzrZJ5UyUY8PC84sD1bG2H0NO9JtStFdx+oxSIoG4ViLz2jxbY7OE6Sf3/txjELEG3/UewIdueqVkyr+OxTCbUZe/OXOGdG+/CszTauq0b8WxCrJ8H97nZREqapKb1B/Q/5zNF0Zr/0+EvOIcW/F5TWBIm/O4Zc6+mExbNZwmVYE0WWpsIVh6V9azGPplriO7wXblbU9Ny7Eh8JacGPCEvekVUWuW6dvZ1lNaMNw7dH6ybufTmq6tTs/vChpbVVjvHwQjero2UYMBzLsMavCzAUh+OBVI/CxzWpCSe0K1bf0UORUQSi71UIEc782fFRm3PnEbj3wakAjJk7eZuQoLq4OeIcSdx4lI4yAfKCT6hbgPbe4IE4FDcsnxG
 U7r1kw0r
 DC2jhZPTwtL+gazyMoA9BD4KH1R6VybEZzcbISbEtcklJB+Nh54kPy5x8M44b3GFr0XyLGx89F4mmjWFJSe6RbC3cG8aVR2jFA0Lau19tvaySYWvu0FSNNlA1Dl99s4L82wk8HU40ThyxtJSfJkz2Vsh3qDJZeSsUnT7+MXpfyX/encIfdEBw9Tvy119CGr5Jo+zOINLChxzY682Vx5PVwJGEimk0JmeF7Ucixu+0khbrBhyIdtMKDghSG6R9VhaNHIFW7f6RH6itpLaDkXfAD7usuGRdBH+JKm2xHh7aus2Skd0Sm2HTStLT0BjEDikVPne5rB3gE8BBWrLz3NeZ+OmPwAfBPH27M8+QXumQsfccYjS+SvbgIAlem8ghHZz7zT8ShuPNVRKo2rV6f5bzV20lgdgknhPq/uFhk3MPMPNzdba+9iwRT7i+u5t2YIyXcTVO81hcGeEELbfQOs0XxKi52W6gakormnmk67fx1etGXqRafQe/UL3NAcl770H66gAEQtBLX/jKStaujkk7LCb5J2n5EieTIQLT8j56NerSLBcH+yMllAw0Fl1CGfFtByqn4ET84hNwywJzy6hYHVFxOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During VMA merging, such as through mprotect(), VM_SOFTDIRTY flags could be
lost. This breaks tools relying on soft-dirty tracking, such as CRIU
incremental dump/restore.

Upstream resolved this using a broader VM_STICKY infrastructure (commit
bf14d4a05387 "mm: propagate VM_SOFTDIRTY on merge"). To minimize churn and
risk in the stable 6.18.y tree, this patch skips backporting the entire
VM_STICKY series (9 patches). Instead, it introduces a minimal standalone fix.

VM_SOFTDIRTY is intentionally excluded from normal flag comparison to allow
merging in mprotect and mmap. This patch ensures the resulting merged VMA retains
the VM_SOFTDIRTY flag if either of the original VMAs had it.

Fixes: 34228d473efe ("mm: ignore VM_SOFTDIRTY on VMA merging")
Suggested-by: Andrei Vagin <avagin@gmail.com>
Cc: stable@vger.kernel.org # 6.18.x
Cc: lorenzo.stoakes@oracle.com
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>
---
 mm/vma.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index 5815ae9e5770..2988f6b3feff 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -978,6 +978,14 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	if (err || commit_merge(vmg))
 		goto abort;
 
+	/*
+	 * VM_SOFTDIRTY is excluded from normal flag comparison to allow
+	 * merging in mprotect, but we have to ensure the result is correctly
+	 * marked with it if either side had it.
+	 */
+	if ((vmg->target->vm_flags ^ vmg->vm_flags) & VM_SOFTDIRTY)
+		vm_flags_set(vmg->target, VM_SOFTDIRTY);
+
 	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
 	vmg->state = VMA_MERGE_SUCCESS;
 	return vmg->target;
@@ -1098,6 +1106,14 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 	 * following VMA if we have VMAs on both sides.
 	 */
 	if (vmg->target && !vma_expand(vmg)) {
+		/*
+		 * VM_SOFTDIRTY is excluded from normal flag comparison to allow
+		 * merging, but we have to ensure the result is correctly
+		 * marked with it if either side had it.
+		 */
+		if ((vmg->target->vm_flags ^ vmg->vm_flags) & VM_SOFTDIRTY)
+			vm_flags_set(vmg->target, VM_SOFTDIRTY);
+
 		khugepaged_enter_vma(vmg->target, vmg->vm_flags);
 		vmg->state = VMA_MERGE_SUCCESS;
 		return vmg->target;
-- 
2.54.0


