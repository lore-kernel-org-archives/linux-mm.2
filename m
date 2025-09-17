Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A570CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 02:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9BD88E0010; Tue, 16 Sep 2025 22:50:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73288E0001; Tue, 16 Sep 2025 22:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0908E0010; Tue, 16 Sep 2025 22:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3568E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:50:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D61AB91F7
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:50:52 +0000 (UTC)
X-FDA: 83897214744.26.863EAF9
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8C0952000C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:50:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GnPOBmv0;
	spf=pass (imf13.hostedemail.com: domain of 3CSLKaAgKCMIri0wvuq2owwotm.kwutqv25-uus3iks.wzo@flex--jasonmiu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3CSLKaAgKCMIri0wvuq2owwotm.kwutqv25-uus3iks.wzo@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758077450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B0DvEATy1boxO8jY+p5CHjM48FocEtwboNagjTq4rGo=;
	b=R+AvgHy8yIAW2s/Q9H3Nx1Ff7IPgPvOQWQGHzlh+IGE1c4c2RJ62Rxnys7+LuimNNX5JD9
	BzTJjsX/2i3JB8HblaJLhPFhNDiBK04316sj2w60avhaOfCO2L5pWlxRI4ptYyzdXXGhEw
	gSl5ptIbZd9Cx8G6aukmU9M2sxhB9Us=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GnPOBmv0;
	spf=pass (imf13.hostedemail.com: domain of 3CSLKaAgKCMIri0wvuq2owwotm.kwutqv25-uus3iks.wzo@flex--jasonmiu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3CSLKaAgKCMIri0wvuq2owwotm.kwutqv25-uus3iks.wzo@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758077450; a=rsa-sha256;
	cv=none;
	b=zt/oJfLu0xX6hXbRLet66xroiShrq1EQ1coVRVkpgr4Djx1CNSie2pcIhIKrgrfyc50HWy
	xRLrsD1MDW8IwRi1abyqtVUB3kbQ7UVO4SpWi7oEqaQBKmc6/g/990teJERE0TCsezJZhC
	upuW3i/FO9vNba5QwkhgJ5CUJB5H4R8=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-244582bc5e4so75879795ad.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758077449; x=1758682249; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B0DvEATy1boxO8jY+p5CHjM48FocEtwboNagjTq4rGo=;
        b=GnPOBmv0lnliZhgNSRpZXqYTg+ZqUOoqlECpKXfv2bxNms5vfUKJtee11VqmUIsp1b
         g/mOhTkv4Ym0jQ+fD2iYjrrL+30eLSus0mTS5E8iK2Js56mACdPhtBqwgWQdPprG5rk9
         q1JODmpJl40TvU+Q+iiF2CFoePuIQ0UXjIZKACBNXEiNOmt5M8xiKb26m2r0XhuQRxG3
         Zp8DiPwbjzYeswik0H/NsY5N1KY4NbdfxN6FDzYa5+pK6dGKUF2OG49/oKVElj3ag8Yt
         DIi1bB86vkg77BeG0saShTG7bNTixQkpRPHCHGHe5Hs+ENj166cbAdRWawx9jGm6L+Ku
         dh2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758077449; x=1758682249;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B0DvEATy1boxO8jY+p5CHjM48FocEtwboNagjTq4rGo=;
        b=kI9E+PwpMUFWG907DJZnUYKUXXJpwuZTFobxnMww8tnmdaFYtSRoAGkD4IxJZ2Jyom
         VOl9Y85QUPCg96lpyzlp5u1jzFVYdPPKM7Ds4wxxBp+hEUdm4cnAfiqLdLB8j+ZyN2Sl
         9a3Ba/LDdewZ8ZZpkApaaShjmsUHJG2JTJM5fQP9CIum/yqNidcaM8nJ4nyiNf+aTM0G
         ptQ16a9gJ0wuocXYHseaGaoYoB5ywibE4Tbj25djWQUOqjy5M84rENuvzFKMidbW4BiZ
         ZIl/Z+9bYK5P3Wo12qPKzyml6zlV8zXzybMZck6a0HAYzHZC48AY3NwYWE+Rw9v9M+tG
         Ys5w==
X-Forwarded-Encrypted: i=1; AJvYcCXsX3Giz6YLi3wumWXOiIW9WXNDRktXhjAS1VIYgFg+nuHgr5mlf/cJjMmBxIf2mWdA5Y6eWiFxsQ==@kvack.org
X-Gm-Message-State: AOJu0YwKdVWrXfJwUvZ5OlUGlP/hG9mBh4B9BHEq0OItHMiFKBPMaSG5
	3Qxpbwi4vdheVmhQ1NMjuOEHx9ew2J1DyacVdw8ETOXoZNIOhCxEjlffg3EK2iGPQdfzDRbZu6Q
	b/g3NHQjjpzaULg==
X-Google-Smtp-Source: AGHT+IERUNLZmWljnHVW/VI2Iz32N7whxhHeQqNofUwRKCrC4MDBM1MGWQZdKx/R1kYbmKHfIml8z0yP7qtaZA==
X-Received: from pjk5.prod.google.com ([2002:a17:90b:5585:b0:32e:3646:77d6])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:db02:b0:267:cdb8:c683 with SMTP id d9443c01a7336-268123806c5mr6135285ad.27.1758077449502;
 Tue, 16 Sep 2025 19:50:49 -0700 (PDT)
Date: Tue, 16 Sep 2025 19:50:19 -0700
In-Reply-To: <20250917025019.1585041-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20250917025019.1585041-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250917025019.1585041-5-jasonmiu@google.com>
Subject: [RFC v1 4/4] kho: Remove notifier system infrastructure
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, 
	Joel Granados <joel.granados@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Petr Mladek <pmladek@suse.com>, 
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Steven Chen <chenste@linux.microsoft.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8C0952000C
X-Rspamd-Server: rspam05
X-Stat-Signature: 7mj5s4xfpurbn5kk8mxqj4bph63zccop
X-Rspam-User: 
X-HE-Tag: 1758077450-658259
X-HE-Meta: U2FsdGVkX186dpN/FcBfhflBFwYN16Sxx2YjkFGkkz1YMdY5SNQz7r9K/tUggJwwPI7hlTMvsJAlcIjNLs/UD9DIdaJqiNpoCXwzL5hTA3siEUDMHyfNPbUl8tvd2Phi/VY1sGquJlyT5eXsaE6jrQFzPdIhdWQAf8VX5ae/ovkPl3SOYmMBDTLCmgfaJ63/L68eAJ8kcMN0FJdbf1Hszm8pWDa1Ac3NNiMW10FS7tMFaxM/dsZ64RfPWPhFALsABPyn2Tt+NpxS0GSwHKnzNmr+OhxZNa05ynKHpV6/sk1rSWrZVh1wbnt2+1DtXVGxIX9WdNNfln+MdVjOKO0M1/6r05FrsjFc5tQRjU3Md8TuF9tzF9OY/H4yveS46o1HlzOjTihnbjEP9mFqjoAFLhnQ4x5SytJYika6F13Y8wajSZVABYLsmonWW7xx58JFsKgyQLK9+5hWg9rOmNSV111gX+okBr7EWggj6b7EJhwiB6jw+ZGUJlq4hHWcX8VhAC/nhZzkvIM+pdt//ZzwutAM5iTFNVDEW/2yd/sg8zysTNbc3UQRfsRyjAqQAlCGV4iq3G/yK8KsnAV3/lGcvNHI5KmZNsDfWLi1Wo7Ow4j6gtrTOjnTMOEbjivBxF38xhDrDEmwjo0epjyCujaGTh3da4W1kUeoV0jM61dQ5w42LJpMSgG0nt3MK8mCfAs1OXnYz+myw+dMuP+O7gwtsrUQwUfpgZ/FbY1QK/y28DlZ3rmcKX3KjFtbn96ycu0tdPptOCjN/lCpzAgr/nurG2aU90IHkMlWkUdVAZ6xO07HLJVjxhkp7g8HbRH2cOGjYFWsN7wYL2nH3cOGeKp5x4QfZZRLMr8XAAZX8UYXKdlB4wPeemWOSf1hlaUGEwzUMTOULMGzWFSIYK5pOGRQ7+MRQ0odbusr/ZHNwWqoSwK4afHW/SkwDUzN5wjBsjQLRt2eF+fi2mBxhobZoiJ
 RuaIzHO1
 tVJe7ZWfXERUK++g1PuGeIcyPh9K4kDKz9QAYxGAdmdLjs9ltEKIh3dZWGROodC4olJ5sWAFiz7RCtC3hTwTD5xTsnMQXe1sVx5LEyb8e5Fq4PNF4MtnLDqtX2iEZv1/N/iCr7eOMUbqWQZd97PaFWEf7fNu3CaJ6m4N3zd4r41f/e6XVWfY596GFXD6pQwQHrzq9QTlmcnQH/u59lXqUgGkv48D2hk11NhIOt4uOXmRx6Q8TETvpMgleSXooiLeXt9nTbvAWZh+GMpFgZa71IzMB4o7CxuzWlUsUIbL0xlTFTLNDt8p9JwokduQwI5yv7KsIPmheo/DdWHzky+/fobFifVaZJsd/C/FjVsk87NWKNFFtGR32NphVu+fx5gvY1yNQHCVOUrWu+2sBPzfRErvfNeNmL3q1to2ZirfjvU9TCcLQSsdOO4XbUrOR8PEkHCDuYIuFW6pzZd+glEbHAoyx8riliLfIcC/Uqm4P7PEJ0Wu0p6iVRLb8hLNZLVb1XRXfB9fMBewhG8Cc2VzKOM84HgE+RNEJhpcoZQR3ZuiUcUegLR3ehCHT5FMLd3VX2kiiqEXYdyywMvRLf5rsk8ziJ/TzlQNfDrHMYsijqOKX1VgJIChuWcgQ+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the KHO notifier system.

Eliminate the core KHO notifier API
functions (`register_kho_notifier`, `unregister_kho_notifier`), the
`kho_event` enum, and the notifier chain head from KHO internal
structures.

This infrastructure was used to support the now-removed finalize and
abort states and is no longer required. Client subsystems now interact
with KHO through direct API calls.

Signed-off-by: Jason Miu <jasonmiu@google.com>
---
 include/linux/kexec_handover.h | 20 --------------------
 kernel/kexec_handover.c        | 15 ---------------
 2 files changed, 35 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index e29dcf53de7e..09e8f0b0fcab 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -10,14 +10,7 @@ struct kho_scratch {
 	phys_addr_t size;
 };
 
-/* KHO Notifier index */
-enum kho_event {
-	KEXEC_KHO_FINALIZE = 0,
-	KEXEC_KHO_ABORT = 1,
-};
-
 struct folio;
-struct notifier_block;
 
 #ifdef CONFIG_KEXEC_HANDOVER
 bool kho_is_enabled(void);
@@ -28,9 +21,6 @@ struct folio *kho_restore_folio(phys_addr_t phys);
 int kho_add_subtree(const char *name, void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
-int register_kho_notifier(struct notifier_block *nb);
-int unregister_kho_notifier(struct notifier_block *nb);
-
 void kho_memory_init(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
@@ -66,16 +56,6 @@ static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 	return -EOPNOTSUPP;
 }
 
-static inline int register_kho_notifier(struct notifier_block *nb)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int unregister_kho_notifier(struct notifier_block *nb)
-{
-	return -EOPNOTSUPP;
-}
-
 static inline void kho_memory_init(void)
 {
 }
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index f7933b434364..62f654b08c74 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -16,7 +16,6 @@
 #include <linux/libfdt.h>
 #include <linux/list.h>
 #include <linux/memblock.h>
-#include <linux/notifier.h>
 #include <linux/page-isolation.h>
 
 #include <asm/early_ioremap.h>
@@ -683,13 +682,11 @@ static int kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
 }
 
 struct kho_out {
-	struct blocking_notifier_head chain_head;
 	struct dentry *dir;
 	struct kho_serialization ser;
 };
 
 static struct kho_out kho_out = {
-	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
 	.ser = {
 		.fdt_list = LIST_HEAD_INIT(kho_out.ser.fdt_list),
 	},
@@ -727,18 +724,6 @@ int kho_add_subtree(const char *name, void *fdt)
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
-int register_kho_notifier(struct notifier_block *nb)
-{
-	return blocking_notifier_chain_register(&kho_out.chain_head, nb);
-}
-EXPORT_SYMBOL_GPL(register_kho_notifier);
-
-int unregister_kho_notifier(struct notifier_block *nb)
-{
-	return blocking_notifier_chain_unregister(&kho_out.chain_head, nb);
-}
-EXPORT_SYMBOL_GPL(unregister_kho_notifier);
-
 /**
  * kho_preserve_folio - preserve a folio across kexec.
  * @folio: folio to preserve.
-- 
2.51.0.384.g4c02a37b29-goog


