Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0530CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 06:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39C56B000E; Mon,  1 Sep 2025 02:12:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE9D98E0001; Mon,  1 Sep 2025 02:12:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD9186B0011; Mon,  1 Sep 2025 02:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEEE46B000E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:12:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A7FFF119FC1
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:36 +0000 (UTC)
X-FDA: 83839662312.27.F1B5B69
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id C36B140002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="Oif9/JlD";
	spf=pass (imf07.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756707154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SAmcQheZtK8H9lT/6SrM187F2xtfPKvpNjdr5OvH7Wc=;
	b=ROFJ95sLHsbDDKCh4RQyrYxP3VAcNG1koS6VsYcSxaO8Rw93o68DLAT8uVc2W/ogZ1h80E
	C0DlQmX4rL3VxD6Z7AKGeW2f6h2ifBquZlSCLofqwsylBOqoIbgaLP/WtnxCZN5nhuWIXp
	JdzVATiY6nxf9rVR7iXabrnEPpuG+vE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="Oif9/JlD";
	spf=pass (imf07.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756707154; a=rsa-sha256;
	cv=none;
	b=wDTosabre4aU+roHFLGTiARmXkO199kUwshJVxCMNKRZK/h4qUcvk/l4LCyYwUm4fsMTh2
	MDYxczBXKdAfwbh9DeDH8CJPiiaa/cGZc4XzQT+6ZeL328zD1xwPONBCK6PDpf4uVa7eeM
	UhlPUx6gWgd9+UcMXndZmM5zLfq1ZMk=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-61cd6089262so6000516a12.3
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756707153; x=1757311953; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SAmcQheZtK8H9lT/6SrM187F2xtfPKvpNjdr5OvH7Wc=;
        b=Oif9/JlDKRTZi9K8VrlfZqMx4q1CG4iYzjXBwjJQD42pt1dEX+U7/vmy3vT/2uv+WV
         4JsdLN0q+ZmQoR5ZSiVkn5vnEBBYT3zkMltsqrVMbo8GsaRwagNld3d/ccvunI32X1S5
         Y75t5UZiF3a0U/YVMo/UcRWr6G4XzOA6QligutGQf9WUaGqhioY4gLoQGymJ76Dx7Leg
         k2KpfSD++Wp7EnBLloMZD8jiOhNsT/vx0o8goOnt/wy2/BtSEKC06kaexEp2xZpPdlZA
         jQU/8MdkVTJLwVTNlTNwfdDEizpbLaZdtRMk2uzhBOe5FJsCpQJ2o1tAbPpps6yVp1+E
         rNsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756707153; x=1757311953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SAmcQheZtK8H9lT/6SrM187F2xtfPKvpNjdr5OvH7Wc=;
        b=fJaqr9O7ySZAS9PQ8H99jEpIZvhb9P3WhIvIF2tZeNZPVqP6pLHL4aqblzviSP1FJg
         +itN9zM0uJCAkWa2f14ZR/zULGERzyyiXTBiLyGzqbwtooC1k6/yxdcS5YLSwFKc31nR
         kgbyIMexN7pk6Ndp8NmrANdCR7uPv1fNhH2OMR22TldcqmZqQNU+MDnElQe5hTSiDfwp
         PVhfuW86aKiRAmSsL7/kGVkyyVRbZCaBdOTnAErv5z564QDOb/TEeNS5XPEqayVcR/Lm
         dicvXteF/urfq4z+cBn0lEPKGw+ySY6poklgOqQnSXBpWmjgzqGvNWJKtw9L2INuGPu8
         voFA==
X-Forwarded-Encrypted: i=1; AJvYcCVxEhi5VAsVFqMIt6gthOOmK5/aOhCkW/fBLaiF8yXeQbFXYtf4RWgvOnsiObkJXFYpEQNezsiMDA==@kvack.org
X-Gm-Message-State: AOJu0Yy6g4DemV4ciiiMxcJpq3TIT7TdNCgIe922H/b1R+ukeQQRd19f
	E6UOBu5AwlAKT4KR0njXUQnByTS0DQyTiKdWazs9JMBMkJVCnIPB11fS5MjvwdVyQmA=
X-Gm-Gg: ASbGncuzP3KvpnElXiIOVBt+H5UjIEfHOHKTXs5vYBgJ0UuhKLVxIjNrW9OSHrgkz9/
	jd1TIFNdqpqzB/0PgUytgN5XHiGy3Z61AVDZ/ct0OKQpruz2XW/yc7EPR7cT1WKpZ29oTkJZvLY
	LE9rogLIZ2QJOWAVwqMo2eNoSW60BudUidDoY27hIjKbnyPxZbxEaxIrMqtTvP97Kvmop+D7/PK
	Q/H/hZN/67cNxchaz7H9Q315Haf/AkJltSBotNEeH7nbyc5FusNgZ9S9ARty3fun5ZR98cnc9vn
	lF5J294CqlkjiBzkPix0ViOmQQatVDr0psp94CuxZv/MORWRUyK+KDy6yhHRORXS6R4+3+UOAC8
	UlLaOwI8g3Ho8M3iktMiZErmVykvCskKvyJ34ijqZOu6AFbnSvnB0t8JINJLY0umRePGPI7gllC
	xX1vFFhNcQ8xOq6Ts+pPvFgyOgkKkc4pur
X-Google-Smtp-Source: AGHT+IGAZtQ8S0AtmfPW/zy24FKXFpTjW7KLkRhUqL2JQUArAEikfl5S7NyGUJW7THgkMENC9KM8zA==
X-Received: by 2002:a05:6402:5419:b0:61c:87da:4bff with SMTP id 4fb4d7f45d1cf-61d26d7801dmr5403229a12.26.1756707153277;
        Sun, 31 Aug 2025 23:12:33 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc231561sm6374533a12.23.2025.08.31.23.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 23:12:32 -0700 (PDT)
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
Subject: [PATCH v3 01/12] mm/shmem: add `const` to lots of pointer parameters
Date: Mon,  1 Sep 2025 08:12:12 +0200
Message-ID: <20250901061223.2939097-2-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901061223.2939097-1-max.kellermann@ionos.com>
References: <20250901061223.2939097-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nm6mmauzn7itsfd7k6j3zxth4dtxnwzo
X-Rspam-User: 
X-Rspamd-Queue-Id: C36B140002
X-Rspamd-Server: rspam05
X-HE-Tag: 1756707154-13296
X-HE-Meta: U2FsdGVkX1+B2LkXiYRJ9fVJO0Bqj/TTIgRCEmvbCHoMlw5L1W/jQktMv/G7HRvOKugDDePwAlOAKNgFuhaaJkaMff1OgRBFULt2JsyP9PEBy7rhvDtuuC8LLi0KaiB2G5uwFdU70MZ8WQwIqiydqkkR0XsYLeYU+G1P9i+g5jqjZgxMtd2J1Zgvbr6+RqCN7Tpc+bUuLOewvZ0PG8N2IYclNLh6F2iCHf4GIJI+flgivmzXcIaNGx8FA6UgxBlRHX9sANPCMSLOhkeyzJ1WCg45ykUAJrwwsNYv+qDm5+nZVihZbKNJSHk9urILq0rUDZVje7n4eBjOhN68SKL5luABQXqZ00YnjZqYPmT6ZyEgxfgo5f9Ciysk5iMWe+PUVGKuIXtWYcok2BSHseG07lsqSE6dP9NgNsi8kHBlcSdQ9vR2c34ZdfBJ86Vnq618Rjwt11jrLOwTWvrIUCjhOx9yU41MuDm56fWTInl4KmsGccYCAOxuKBe5X7CqVocmjK407n3BAvQ1oRga/WypWaIQdPJnf+ESEMJehSoSFAmGuF39Pe70RpbihSWVT46Pa/12WklvX8wgEGLpiq75lNQhtiohVxyqhuATC4nk++BBMY2ArB06palkf/T0u71QCOS4iIApBVBIWY452y6nzXgkhY1rPGj1vqQp8HrOLMhlrZGYzzjqrvsKcZ7Xn9jTB4jSPYC0dMlKnBdgwuZT0Ass7JZr9luyLg51oUfmG69twTINV7aiQpLf7ceuNmIs4Q2ditKLogM3XxZ0Xr30m9mQ6VzR72am6XICP99JvR4DFxYyKbvT/lmPTz8beD92RAkkAKRJaZ9cjhXB+m1cVsIU70QOONjI/V0ZnsmEMW8Owulpk2SFf7arJ8v1GXqEvUuIfZ6CGylNRv5k/Uvq/OJEasO/pI8GPJs5Ph6E75PggEZijdkf8HgGEOEbmfpW0byj7WBGghSiWenchxq
 G9XoM1QL
 eOUOieiqijFcFyTla3ifEaC/SrjGAECebPTB9JWlrAfCYVvwgSjHAGMgjaMZjgu6DJt+53haQ9E3mW5VW2Q6wDAo8dl3r65UlItI4dRqSm1IIVMjgbLFOIDb0pgdC4neY916/+s5fcrEDt74vn4JoxnQYRrn/6PvhGAZ2ih49shQO1VUt1+ZAFLXHsxqDkC8vjqcRofN1O/+OwiVAYSYhc2bGNTscqk5pE+tSacfShDwE1DZjeZXBrYkbgMSa95eNVHNrkG0W0cB7CV26JoI8UykoxBrhbtRiLzShLpisb6sZ0+eYjtenEkekabLyRA+bHGsMU6EYKwTCalG0cv1TKR3bdGtlSOc9HoXDVJW/MAZV9SuYP4oNjs9hrdpuuHQkZOQWodWF52PQnetVgKSDvRLuXYqJEOobte3RYPVxq0SqQX3OiR1aG5S5UPdG5XjEWe4C/Yair64KVwY=
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
 include/linux/mm.h       | 8 ++++----
 include/linux/shmem_fs.h | 4 ++--
 mm/shmem.c               | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cd14298bb958..18deb14cb1f5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -979,11 +979,11 @@ static inline void vma_iter_set(struct vma_iterator *vmi, unsigned long addr)
  * The vma_is_shmem is not inline because it is used only by slow
  * paths in userfault.
  */
-bool vma_is_shmem(struct vm_area_struct *vma);
-bool vma_is_anon_shmem(struct vm_area_struct *vma);
+bool vma_is_shmem(const struct vm_area_struct *vma);
+bool vma_is_anon_shmem(const struct vm_area_struct *vma);
 #else
-static inline bool vma_is_shmem(struct vm_area_struct *vma) { return false; }
-static inline bool vma_is_anon_shmem(struct vm_area_struct *vma) { return false; }
+static inline bool vma_is_shmem(const struct vm_area_struct *vma) { return false; }
+static inline bool vma_is_anon_shmem(const struct vm_area_struct *vma) { return false; }
 #endif
 
 int vma_is_stack_for_current(struct vm_area_struct *vma);
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 6d0f9c599ff7..0e47465ef0fd 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -99,9 +99,9 @@ extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
 #ifdef CONFIG_SHMEM
-bool shmem_mapping(struct address_space *mapping);
+bool shmem_mapping(const struct address_space *mapping);
 #else
-static inline bool shmem_mapping(struct address_space *mapping)
+static inline bool shmem_mapping(const struct address_space *mapping)
 {
 	return false;
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index 640fecc42f60..d55bceaa1c80 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -275,18 +275,18 @@ static const struct vm_operations_struct shmem_vm_ops;
 static const struct vm_operations_struct shmem_anon_vm_ops;
 static struct file_system_type shmem_fs_type;
 
-bool shmem_mapping(struct address_space *mapping)
+bool shmem_mapping(const struct address_space *const mapping)
 {
 	return mapping->a_ops == &shmem_aops;
 }
 EXPORT_SYMBOL_GPL(shmem_mapping);
 
-bool vma_is_anon_shmem(struct vm_area_struct *vma)
+bool vma_is_anon_shmem(const struct vm_area_struct *const vma)
 {
 	return vma->vm_ops == &shmem_anon_vm_ops;
 }
 
-bool vma_is_shmem(struct vm_area_struct *vma)
+bool vma_is_shmem(const struct vm_area_struct *const vma)
 {
 	return vma_is_anon_shmem(vma) || vma->vm_ops == &shmem_vm_ops;
 }
-- 
2.47.2


