Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9166C982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 00:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B8246B00A1; Sun, 20 Sep 2026 20:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98FE16B00DB; Sun, 20 Sep 2026 20:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A59E6B00DD; Sun, 20 Sep 2026 20:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 655A46B00A1
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 20:48:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF0F7804E4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:48:42 +0000 (UTC)
X-FDA: 85235934084.20.67BB101
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf08.hostedemail.com (Postfix) with ESMTP id 404A7160005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:48:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vxbWiQr+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3536waggKCAQwole0eneksskpi.gsqpmry1-qqozego.svk@flex--skhawaja.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3536waggKCAQwole0eneksskpi.gsqpmry1-qqozego.svk@flex--skhawaja.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789951721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5rIYSaUxr2dmbQ4fWz0MikFLRE1YKdMT0WLnLm0z0eI=;
	b=0NMl+9hp3dLJS6pSqE7DL3bxshn+iBeq7LZusCKe4tBLgr5cpo8ZIWgrg/sscPTvfK7bAO
	7FL+/0UFS54wnfIl7EYNUAEwfsot8KA0E9x4dxuNqtsbG/rjluhsAcquKqp/s/DSIgXbP5
	v+Z2C5883mt2+v/bEKQ6LjTP4Ke+tgo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789951721;
	b=rvOJIJJDjYqc2/8TJKft2UhNN1OwseB4TCIFNoNKa86aVg6+azSVCFA55/BvSB9QHVGrce
	Z3BOagTAG9jb7Tmfema7uvQ/INjYQ9QTSCPnVzCme8VKSL2pHMI9w4XI9Rr3W+KLoAXOMu
	7PZ+h5jNVzU0O/+iwdusk/w1r6Xxo44=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vxbWiQr+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3536waggKCAQwole0eneksskpi.gsqpmry1-qqozego.svk@flex--skhawaja.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3536waggKCAQwole0eneksskpi.gsqpmry1-qqozego.svk@flex--skhawaja.bounces.google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d55d8cd938so44523025ad.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 17:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789951720; x=1790556520; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5rIYSaUxr2dmbQ4fWz0MikFLRE1YKdMT0WLnLm0z0eI=;
        b=vxbWiQr+ISez0Ofv53y72+etPOGcB8oRY6NGY6IA/TeJ6L/eG+eW44G0kW5MjnpEVN
         JTCePzgPwRs72MagojJws/8dyG1KD5VGjTUX5SnNkGzPtACYIbXYerFUp6Y65ENXSUAa
         BGijSbPvPt+CwSb/nHw297F5daV/qgt5mHon2jbvLIGNIOwFwkQFncbeGnmEvansVKZQ
         +//QGqMd9HQhCX+cMcYW9XB7Ms6gnLhZKUEUQRw0l2MJwqs67fDbJ6ujKEOWMAska38x
         6HdCM8Amj/itwpNDW7nffGCkhFLbGJ6hFcy86d8nwR35Z35mtREEgObKp2SKPCYz2f7u
         UpvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789951720; x=1790556520;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5rIYSaUxr2dmbQ4fWz0MikFLRE1YKdMT0WLnLm0z0eI=;
        b=SjDHvju0KdLm2QR7LSHaWm42vJ+0hUQdVQhZYKqnKmstwsrEsm2XWS0hL/qKwrbyXd
         PdwRmQRiSiMl317gu/iycpFyf04OMj99w/sjobFVQfw6lMGh9IWqP1ph67/aT3de6AN6
         9nyGIU0qn4ZjTc0Gdbj+umS6NifVcL8JPa2MyA1pp1eJMEtq+LHLMCTr1rHv70D9ZTNK
         yRZ0Roz6zfOtFpxfySwW3e5FC06Z65VQlDO/78ml9PfO40iXmt5NXC+BmunCD1bUg/+n
         NDOfAENnJPILNo2bz13NVfz2Zcql+LDFVeZGeQT8fwP78Dob41Ts1T1vT5UfmmrEUAgG
         K/gw==
X-Forwarded-Encrypted: i=1; AKwUvByc24KvwwvchEybqfQ04myvtC8UBO7DYVgm8WdVXHT0JrwLwyBuCFCpRT130dEUYuDwtKA787mNWg==@kvack.org
X-Gm-Message-State: AFuF++lkJxGJRamHw8tvEtjd5XzCeKa9Ct89+Vleoob43RLl1V0dnAk2
	1Y+0aD2b9Jrv4NwyrU04gUlZwfQwWppaQBHswm+Hg1bAzetcslZi7pL77n0WFw9LpchKrxQk9pu
	8/p9l6C2NwnbjEQ==
X-Received: from plld8.prod.google.com ([2002:a17:902:7288:b0:2dd:1e7c:bcec])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3c6b:b0:2dd:c100:9433 with SMTP id d9443c01a7336-2ddc1009c3cmr88814875ad.49.1789951719834;
 Sun, 20 Sep 2026 17:48:39 -0700 (PDT)
Date: Mon, 21 Sep 2026 00:48:17 +0000
In-Reply-To: <20260921004834.2601285-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260921004834.2601285-1-skhawaja@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260921004834.2601285-2-skhawaja@google.com>
Subject: [PATCH v5 01/18] memfd: export memfd_get_seals()
From: Samiullah Khawaja <skhawaja@google.com>
To: David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, "Pratyush Yadav (Google)" <pratyush@kernel.org>, Ankit Soni <Ankit.Soni@amd.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, 
	Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, David Matlack <dmatlack@google.com>, 
	Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 404A7160005
X-Stat-Signature: e9nogbwm5cwq79z1jju4tr8ofg1fqbus
X-HE-Tag: 1789951721-936786
X-HE-Meta: U2FsdGVkX18oXPZxiKffe0gOUiDUtiHEqPi04W2KlJdvd4zCNk+uw0n2Mc3Fkyts8PmgZQLuRuNLWz5oi9V8yqDts0A5yCmREE5bEkuv0JIIi8K8kL8bk8Tl7ZCymb1iC5pPxpdZOnOO0EEN5o3RqQ/fsLSNr1u+OfDlCZbtx17grdoLNfd66V+Jlbnqey5YotvoXWmG1GAVTJQs5ZL6i2Wo2Ao2dFx99pgxvucKe4fHwyIx6dvXY23BTVvJhlmBdH5PLBLAjh+GMnC7DZ8z0i3Ijiq/6FPM+0NmMdT8yJMgNEmdNiHBXFseSR5TIsKwg/bO+cG1qwbz/0ZgIcP3dMDX2OncA0ofi70IvWzboWIKNNn7wfX/wpshU2LRBIqykrlu/XWWAfE+QyaMrW1I8nvAmYnBjIy8TGDiTv6ureDASe0pQ84oTC2KZi6M47nMoAGuBo4KNYv/6iVi0rg02JQzDprw0XMpivDQDiWVTPaqj4ap+3TGslfy5miBtEqPOFILPvsDaJTdFKg62zjKicxhH0JamwWAdbVprdmLxnpD58RRZie3MURhhnktiJ9EkARZZqN13LlwRqYfZIeoCIyxkshihJNY99IdUAMKql6rj/iWYSUQk1bhlJ6du6Ufa9DmZpAfEGvctxGx2JN5KYcsn3HidwhZuaFUeyMVn8Xg7t65Q6WtS3SeqdnajQVCj9ZNIyZZDLJZALWyWHQnA54JZzkIaU0Gypro7+eunioqYOkNr8ZD2CPLdRxwersDOlagJhd0/nXJ7q73aLh21sE1VlACA5pQ0E9n7ZoorVBwoRU0d0+CUNwzTfqB2oCxJ70Tv1B2JFJudhH611hW7H9ZIAbBZSLwjpnUjdocLkloKPiASSTWSoSWYqKaMNdx+4Z48YDPQthUEAyLe0JHfZo0IgAp+K7HF64F11aKL/+xORfBQ8NaLtcdCI/Gg1972RBtUc/Gib7g+cxHqZd
 yrVVYlbx
 YIwKpTkVgLmeOtGdF8FwfR8ZFOyEyGv/kIhOB6/hoDdDyKaOc/q3bKm/LHfeuksasaNE5l59hC1OSUcy/gR46cviFTtBCp0EcqQLoxYk5qB+hBrXCreeziCZ8I1hrHJrh6xpMU0zFgtF+XSKuYEFns8zb08dS6xlAtrJ24Ym64aPvGhmgUezUU+HEcYX/dQRwWabfNPJDWSdrW8pxyFIk0SzSTavseB40wrtX9CczXO5OGZ2CHY354zz4FLJV0WCcaAletdTHhllmR6JOv2gr+npdDFAr4lBxgJOljXn9DenRGVVOjBhcDqjz7Xd4rOqzN43QJtjnvSsjIOFMOCt6VcHhDbpa0qxheoCelaB5TBEKlGuHmSEpFuHEAVjOEtywbhXp6OY91WqRjxNeVIRY3e/in0KwsIakuiQcsA8zaZze3jxJLOWAiyF9zL34yucDFLUqIXpL0yQ/SyVELjBlYDPo8IbrnyPPZUbxwIZ7dWi0jSB/TTjkDGJQPLwSfFpKJ0zbHbtpNDRxdsz6E4donENoy+OBzVmfKsRxlstILMlSBUwflRCbCEK6CtBRpbWnalSYc2VXdhihCZUhmxOxvymwoPJNanT5jqihGtZAvRZYkVXs08pixm7vT0qvFbdhPSqkClU6IJ13tWWnsoCyr3CztEUAU7qk9n96o4pdJxfJs6axE0TMu1cVP+0TzXH5YbHLk7RuzoZou6XUZxrtMyuPPcL0GkuriNIWfx+Kwn6tpqabDbttp9IAziDbpSTdVa7UydlgRhfyTizDup2RUxCjO4HpWfVdva5tp/5EhM5pJlDy12ytq2xo4VUjGk/NdeGN19Hwm8xdDZObpY2yKbKUGfECGQXOdhV1H7RCfkyC5dckCPZC4aliqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memfd_get_seals() is used by iommufd during preservation to make sure
that he preserved memfd was sealed when it was mapped into iommufd.
Since iommufd can be built as a module, export memfd_get_seals() to
avoid linker error.

Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org

Acked-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Ankit Soni <Ankit.Soni@amd.com>
Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 mm/memfd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/memfd.c b/mm/memfd.c
index c708d92533f4..888ccf3778c7 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -6,6 +6,7 @@
  * use by hugetlbfs as well as tmpfs.
  */
 
+#include <linux/export.h>
 #include <linux/fs.h>
 #include <linux/vfs.h>
 #include <linux/pagemap.h>
@@ -310,12 +311,19 @@ int memfd_add_seals(struct file *file, unsigned int seals)
 	return error;
 }
 
+/**
+ * memfd_get_seals - Gets current seals on a memfd
+ * @file: struct file representing the memfd
+ *
+ * Returns seals if file is a memfd, otherwise returns -EINVAL
+ */
 int memfd_get_seals(struct file *file)
 {
 	unsigned int *seals = memfd_file_seals_ptr(file);
 
 	return seals ? *seals : -EINVAL;
 }
+EXPORT_SYMBOL_GPL(memfd_get_seals);
 
 long memfd_fcntl(struct file *file, unsigned int cmd, unsigned int arg)
 {
-- 
2.55.0.1082.g2b9226bbc0-goog


