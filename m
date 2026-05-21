Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18B49CD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 11:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E3B16B0088; Thu, 21 May 2026 07:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494846B008A; Thu, 21 May 2026 07:15:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 383E36B008C; Thu, 21 May 2026 07:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 267F36B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:15:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BDC7E1A05B8
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:15:22 +0000 (UTC)
X-FDA: 84791170884.12.CA1578D
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id A4BB614000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:15:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=tphbWfcH;
	spf=pass (imf09.hostedemail.com: domain of vladimir.zapolskiy@linaro.org designates 209.85.167.53 as permitted sender) smtp.mailfrom=vladimir.zapolskiy@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779362120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tZ7P+5t3jLRBE3lOcArAKCuHzvSZ9KoaqAb+k1VS674=;
	b=b07AY0qRczwT+8hd2Mu4jfH9vRuueKE9IjdrloZ5dKZGAK8J7bz7w44W9qmheHxcdx4a1w
	VZlv69GAVRB7800auiw1xtd3kzYxp6lgxCooo6DbXbF8XZ1QNOHE/HnoI5i5CqXVFMwVMC
	qck48ZUhcXOFGKKei/u5gQQqBWlA97A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=tphbWfcH;
	spf=pass (imf09.hostedemail.com: domain of vladimir.zapolskiy@linaro.org designates 209.85.167.53 as permitted sender) smtp.mailfrom=vladimir.zapolskiy@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779362120; a=rsa-sha256;
	cv=none;
	b=KrRa9P9TAGZwG/4roVzqhiT370b84ViLRqEUW+i0VdA9+zTDc8+Y4bAgkFAa1+Yc3J1Jqq
	VolLYRI93qyMAlw8Jg16IFnWjCyk7ePm4R8GpYPQy6UJx0zsM55ekcQsNkpVIXCIn6eonC
	OFUZsDZVwXzyPVly8qGUHGSyMi3Vx1k=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5a4002b1183so472302e87.3
        for <linux-mm@kvack.org>; Thu, 21 May 2026 04:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1779362119; x=1779966919; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tZ7P+5t3jLRBE3lOcArAKCuHzvSZ9KoaqAb+k1VS674=;
        b=tphbWfcHBWeadcgove+Iq7Up086EXPCM8QIXR4gdbYZVuuTz9XUqO+w76jwHONuylp
         YZS9Qn5T3sADLwb6HeI32zko1PL9lUIYMThLRCj1oTFOeBaY56ZYWmVXoNAgEIriiAxB
         bUdPPmhaw+EXk80D3b/7AJPaJE5Zm3j5c16l3PwEkMJammxPQVQaQFhaqK0eV2KeOqB+
         KvnjdmUgITqCThkLrh8n47Tja39jvCYCVIHuIqgIHzTZ/1GGh4vCEF6gpdL+YQbKaG35
         MwOsqZhY5Ept3tSbBbh9pGrkazWE+IcSJPoLKcVoyd3wSp4LfFyQs46mVv3fmaESPL6H
         UImQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779362119; x=1779966919;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tZ7P+5t3jLRBE3lOcArAKCuHzvSZ9KoaqAb+k1VS674=;
        b=Q6ay5eGas+XPz+WNHZczNNop+TewbKyRmCm4sOPMrAnt1mMbpWDyt35mnLo2pESs4p
         +fUXFs2zOdbysbUTQdrNs8+K3G8EbxvhU5Apcz1pXPxg15MQiIqsuwBILnivgmYkbec9
         RLQViq+toKDnD32llx2SEwfYErD9YQo/HI6hQnsF+dJDvhpTNMlCne2Qw2sS6yJ/KRH4
         AJ9N8Jsr1t3MgtOTOuSK1yO0/z0teQvqrLkLH1hlodei6GBYoQ3G88PPvVV4PcBQTPat
         I3b4EiQcWHYy6IG6efSv3unpK0cLGvEW8WfoPvrFqOKMXO7hy7eO06pYsVdHXk55ohFx
         jo6g==
X-Forwarded-Encrypted: i=1; AFNElJ9YIRyA2kpij35zmqdVqNx0110BypldEPJaO5bsGF9cAI0aJQMipgk1eBiHziT7sHNVseeAk3Efog==@kvack.org
X-Gm-Message-State: AOJu0Yy8DEs08Ct1OJnrucWRnxp8BF2stN+eczQ03dmwjr5K5UB58/yK
	3m7B9sX2yilp8+PJLNv1WzXy4sEsHeTeTVyAt5Jt7R46mmW9NpAGi4XEBHlDc8CRjx8=
X-Gm-Gg: Acq92OHTD6aPwTr23CnkeVXZd7wLISDw6zdY9iD26k3MrtLqtyy7JqVkO4zVBQVz7G9
	FmLOc7BSubwmFZRsWBWIcmbgesxDlTNlSZ7p4RsrSgC1bi6QKOQW/GhXt9O7lyoHQayrHsvudkY
	EGTlAFljjEr+3RrtxCIhyGi59fLVcYrC1QcGFK2+TWy4C1zs05x9wUk0tWK08CnK8CJ+9hEeaqE
	mT/A51IOuiv6PJyJri1/No2YFDJmOgv0pDmT5BVgeZn2kjOIjedoQ4Ck+f4IG2xCB0nFKqMGtFD
	SllWHDJnz8J9G80pK1tg+kx3mMhViktg3m6zCt0dGcePwtiqx9s2WO+RlXo8AJzPDkszT9sv4KK
	f4xrAt0nlH0LW03Qk180oH/DAgg6/Z8I/DVX9tCLhYuClYP9vXB1UnSzrvKSxvWE7dnMFGI5h+c
	c6x63kqEILnZP+jrwxikxtxTMLQktYrcanFBbTfG3YHnt9vLY52vb/LFffN2HIKDHFB7boqHVAm
	AeT
X-Received: by 2002:a05:6512:39cf:b0:5a4:a4c:6595 with SMTP id 2adb3069b0e04-5aa2ba9076cmr513290e87.4.1779362118542;
        Thu, 21 May 2026 04:15:18 -0700 (PDT)
Received: from thyme.. (91-159-24-186.elisa-laajakaista.fi. [91.159.24.186])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa2f14f34fsm163861e87.74.2026.05.21.04.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 04:15:18 -0700 (PDT)
From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	Hao Li <hao.li@linux.dev>
Cc: David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/slab: fix probable issue of dentries registration under /sys/kernel/slab
Date: Thu, 21 May 2026 14:15:16 +0300
Message-ID: <20260521111516.1903707-1-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iwpb1jty635hoc3hqcf7trnkxcz8s33c
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A4BB614000B
X-HE-Tag: 1779362120-452406
X-HE-Meta: U2FsdGVkX18r7erfhlUO7vdy0Ejg2ApMQopctq1C4KjjEdWMgTN2EfImRnx3Id8s6FNRaCMPqdy/IQ0zmEaGzXpqxVQTvjeTgygHL5Mwxi8I0DjMSXHFqFeng5QrT2SZbU/hjWfC2MEJ/875Tm5OWpPpgjbOpb0ATzqc4yXNuddYKg1ulZZ73wnzrEvSL9ejAoBmG+rJk4hCSE4T/sm5HasFi3qyj11vuUi+2hgOyPf1If6dITeX8tsqEK/L5ZiSnHebyJtvhFi/oRcDh48YUDEWM5NBDltgMLnDsXi0A+whZT3DGXsEg7uogru8whLRVHVsPGUlpRrYjz0R7kwtbiNA5tbWCW3gp10er+5SNXqONUhhzI6ifKzW+s5HtBRfIPepLmnhHBfYUC0JjCI/muTcYR3APtB0iN7vXHoyZPhtuQHKUM5IyueuiSfJ/lt7UIbtCvRt/xbLXUkryjVIbzY4oBv34XcDyVyoauMwT023C6kNN+5C6I6gWGUZE4G+H8ZCUUde2XYYljXiCA47C8VyoD0iOiatlXcDPGypZowqeZFDGrzwlBprqeJPYG/PaB4lJTkbLE3QEDzs+1oU3reQfnk9/svuT2eoj4XRLCAj0W3w+O7wn+/U2V1dOeyvHqp0zUQyr3H1neQvC+hoJAf7iBSbRBR7h1PcUWxaUblGV0+Z1XnwWPyVs6sa9VxjsKPkkYH2zzYheWIaU3TAba6CdeXnnMO1HUiCITirDpdvJPWLbDXaSuI6o37WoHLr31KWx6hDGpMjuiD2Pgt3Hce3g5igL8uG72T11GMTWYWti4zrM1dkBagVigK1SBAYjRcs+M1T6ZjnV0Yp4fU/EfLoqeRJFvnP7j7x/LqVmGVQTZMz+bkgSwKwlaPoTx9qvM+JEMMAMuKrg1QfEqkKLznzTbfkUabfnzSux4cgdEm2IkmqdMwsiYa0vf5V/vd6cICTBfDxxZ+YSxr0Fr+
 3TxIqMpk
 KeJMwFF4A/D8JyyZVhnFQOUqEbQFAXn4Qz/HfT7YqbdAHDMWEi4wzPKZjUfDK/Omudo6t1WlXJYn+9guHnzJH6Mr4DLmDp/TNLn1VfTn/NCZN3TH554X0dCGP7AADZsVGJIiZa/r6h/21V6eFUCPUoO+gl8jkOWhBnpuffkDnLjX86TQGLGdwUlqchpe+Db/Z7O/o9STnxHW5zE3EK4rP3B0VaY475IaYslMIeejH1FrIazofwR/3g2mbJ3IkBvBpOZG6ucgP6upOQOQ8ovuYMsoPbYT1Bxd7lDXwUGA/cCBQxC3BDAlo0SiklGIHgK7RJc3qSeIz8wF9xnwk0NF2AOuYS3UZ1soOQwit
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

L2TP/IP and L2TP/IPv6 protocol names contain a slash symbol, however these
names are blindly used as symlinks to slab cache objects registered under
/sys/kernel/slab. This kind of symlink creation is successful, but its
dentry is obviously broken, as well it breaks the access to the list of
/sys/kernel/slab dentries.

Likely L2TP protocol renames cannot be done, since the defined protocol
names are exposed over /proc/net/protocols for years, but the symlink
names can be renamed, because they are yet to be properly created, and
this should be eventually done by this change.

The problem manifests itself, if CONFIG_L2TP_IP build symbol is selected.

Fixes: 81819f0fc8285 ("SLUB core")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
Changes from v2 to v1:
* added slash symbol replacement to __kmem_cache_create_args() as well,
  many thanks to Hao and Harry for review.

Link to v1:
* https://lore.kernel.org/linux-mm/8a80496b-1568-4a0b-a878-836c27d19ad5@kernel.org/

 mm/slab_common.c | 23 +++++++++++++++++++----
 mm/slub.c        | 23 ++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index d5a70a831a2a..b9930521496d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -366,16 +366,31 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
 		    object_size - args->usersize < args->useroffset))
 		args->usersize = args->useroffset = 0;
 
-	s = __kmem_cache_alias(name, object_size, flags, args);
-	if (s)
-		goto out_unlock;
-
 	cache_name = kstrdup_const(name, GFP_KERNEL);
 	if (!cache_name) {
 		err = -ENOMEM;
 		goto out_unlock;
 	}
 
+	if (strchr(cache_name, '/')) {
+		char *n;
+
+		n = kstrdup(cache_name, GFP_KERNEL);
+		kfree_const(cache_name);
+		if (!n) {
+			err = -ENOMEM;
+			goto out_unlock;
+		}
+
+		cache_name = strreplace(n, '/', '_');
+	}
+
+	s = __kmem_cache_alias(cache_name, object_size, flags, args);
+	if (s) {
+		kfree_const(cache_name);
+		goto out_unlock;
+	}
+
 	args->align = calculate_alignment(flags, args->align, object_size);
 	s = create_cache(cache_name, object_size, args, flags);
 	if (IS_ERR(s)) {
diff --git a/mm/slub.c b/mm/slub.c
index 0baa906f39ab..843bed864a7f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -9634,6 +9634,7 @@ static struct saved_alias *alias_list;
 int sysfs_slab_alias(struct kmem_cache *s, const char *name)
 {
 	struct saved_alias *al;
+	const char *al_name;
 
 	if (slab_state == FULL) {
 		/*
@@ -9652,8 +9653,27 @@ int sysfs_slab_alias(struct kmem_cache *s, const char *name)
 	if (!al)
 		return -ENOMEM;
 
+	al_name = kstrdup_const(name, GFP_KERNEL);
+	if (!al_name) {
+		kfree(al);
+		return -ENOMEM;
+	}
+
+	if (strchr(al_name, '/')) {
+		char *n;
+
+		n = kstrdup(al_name, GFP_KERNEL);
+		kfree_const(al_name);
+		if (!n) {
+			kfree(al);
+			return -ENOMEM;
+		}
+
+		al_name = strreplace(n, '/', '_');
+	}
+
 	al->s = s;
-	al->name = name;
+	al->name = al_name;
 	al->next = alias_list;
 	alias_list = al;
 	kmsan_unpoison_memory(al, sizeof(*al));
@@ -9691,6 +9711,7 @@ static int __init slab_sysfs_init(void)
 		if (err)
 			pr_err("SLUB: Unable to add boot slab alias %s to sysfs\n",
 			       al->name);
+		kfree_const(al->name);
 		kfree(al);
 	}
 
-- 
2.49.0


