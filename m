Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88A06CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEDA06B0006; Tue,  9 Sep 2025 22:45:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9D938E001C; Tue,  9 Sep 2025 22:45:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8CD38E0016; Tue,  9 Sep 2025 22:45:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3A836B0006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:45:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E90111AC9F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:45:56 +0000 (UTC)
X-FDA: 83871800712.11.DF38A6D
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9919B40008
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:45:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kBoclQC2;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JhIj1wOvMISRgbxTNNRHlkhQqjrik/oerQtu1lBx7LA=;
	b=iqtzvq42eAY8Y0KlGTE+xQKmfpsrJ4bkrd0d0hfH2A99ItdMN86+q/NYP0lBrmPktdXJjQ
	6DifazDgzMfcJ0r+gJvEw0sn7Cpm51r18Ma3tOPOlq9GTrHJRzn3aoVFY6Inf7NfPQs/t9
	+kWUFfmsHkPaATfAXr1v1aXjnFhSbeo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kBoclQC2;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472354; a=rsa-sha256;
	cv=none;
	b=ba57a2ERccJJ5syh0uq2uwgM+/MpbIVx6ft97vbnF8SDtCFRsYjWg4Y6guQVfqrtR4p5te
	ipJBso2S7qXtUE+HfXRJwpbcwRCwojASDyZHsO5/3PHX+OM3Oh9C4aEpKkEKJD9K/cu27g
	emqMOxqGsbyGaA3B6Z3DpBGTC5fy4m4=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b4d1e7d5036so4079658a12.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472353; x=1758077153; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JhIj1wOvMISRgbxTNNRHlkhQqjrik/oerQtu1lBx7LA=;
        b=kBoclQC2SrxeaOvOWF/QrwUqP0pONI1Ri1j/SdotKliBc0h2JVNMdo+a4wbLzGORYi
         75C4Km6sTTVclnozb9419ni8Dg2/k3jng9qvoQ+sxcWCI8a1THdSLK1/2GUxbdWAAgGO
         rUxD9AwTHKIoYUSkHxLGuUo6Ak6hDmufxhyFsrlwX1A+2cojkHfNVdWjQ22Z7pOmo2w+
         2qWPc9VN1qIualWKzsy35jz7m3DoQIGdlJzLRQnf3dDFcjSaxDTy4W8VKcC5VYFUkfsw
         lG3Rt45m8GHU1fyYRgFSASuqZwEiY0TzMnBZDghdgwg0Me6EGqAu7Ou0i/uMYGF0IHcr
         1nQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472353; x=1758077153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JhIj1wOvMISRgbxTNNRHlkhQqjrik/oerQtu1lBx7LA=;
        b=Fv/mglbzsAgewRnaXAxWsYfqhUFQ8TXg4M4zIQQf0vI4sHxWnoRXg0BopQ4Wi0Mrlg
         YpxI5RBZbHA23wT52NhI16cJcNX1Z+/ZACqRUeXXQqRduU4elrghg4mNCidoFNo/KpBj
         9WXtvuVGsTwSniz3WknlprGEkhCSCZAWvgWy2drUNWeGBbcc6r4z9kT/BkeBPQxcEn7f
         wmAvFoR19X3a3yMVbAMttghJMzRQmntIdnZnCeK3/lD4qkMynDDETIi25J0FXGIynSCG
         5YOLQjXepdRPhaLbxWqN9s4g347N9/jZv2fjE39OkbPyOlCCiFXNo3nIdh2GdZ93MYA/
         y3AQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVmAlVn7tJWdW1cgENqtld+K4yqwNoZGJIrhfE2zIV4Vtc0SAqKtzCZUbxzKPJoGHhMea8+yCuiA==@kvack.org
X-Gm-Message-State: AOJu0Yx44fxqczCX3jAEjwTM64fHBiC6stXgpsmhsTLbsmnQOd92mDep
	BBLUBjxzl/kF8XiFKE4p1D2iXi1dUONmLozjMZLeA83Qweg75hqnLuDe
X-Gm-Gg: ASbGnct1q2giaZ3WlBRaV+3JJueSXBz9+emEiVeMZVq0G7Xc1UcedwpCgRp2jg9ysME
	vrqsHMuN6k4x81bgYgdY8RUHWQblWIIClbDYcZYZU+IdP0ks1kYinxgWQkdNXGvm+RSVCWHjtyo
	MjajfU7noGGQ4MtPgdiHg3V4tXesdUsGVEc4/gtnYRP/YiXmej7WBrdq0lYjFyX7H4tC0LBYyDE
	NhrBijl3fQ7H0URuS8Hp47FTzje0PPn1aCs+wclnsG7nUtBbaEonFPZofV1hdetgMx4s17FPYjj
	qNtoFdHCXTMSQzo8jy/2vJWo6IrTROkCVTYGxkfjE9ZjhKozGfyIz+5vFX2kVUx3clb+T6WvBlU
	yfa8y4zeXadCj3O8vA01yg2qGBCiSUPqqvxGycplVaeIUV/2ypYwGA8aiGZx1lXDlZEyy0FpRo4
	eNdLOMRK1Q8bu1jg==
X-Google-Smtp-Source: AGHT+IHR3zVDA4dMic9DbEIss4WDN7ZHBL8jZ8Y/o9+OzUWibAnOWX1U/miaWRldO5YZrP6sorG0wg==
X-Received: by 2002:a17:90b:1b0b:b0:327:f216:4360 with SMTP id 98e67ed59e1d1-32d43f1789cmr17484208a91.8.1757472353463;
        Tue, 09 Sep 2025 19:45:53 -0700 (PDT)
Received: from localhost.localdomain ([101.82.183.17])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dbb314bcesm635831a91.12.2025.09.09.19.45.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 09 Sep 2025 19:45:53 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v7 mm-new 05/10] bpf: mark mm->owner as __safe_rcu_or_null
Date: Wed, 10 Sep 2025 10:44:42 +0800
Message-Id: <20250910024447.64788-6-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250910024447.64788-1-laoar.shao@gmail.com>
References: <20250910024447.64788-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9919B40008
X-Stat-Signature: kz9o5byie577tyuxu4uxban5yzdg9ssy
X-HE-Tag: 1757472354-137458
X-HE-Meta: U2FsdGVkX1/AbHupgjY0AB8YIAtP4YqkTM6B47Pnxs17bo+iQnezBZOGwOrIR3ikjPAtjFLHaUnPu8WNfZwZEtxtio1LM/DrK2zmWiP4W5edUHnvuQIH15McL8bElPz1DVfQtmkYtalI6G2fl7q8WgFUssCWiNEdWRPA0BlEDyN+t9YyAsJGadRu8hhg92KlrGjeVDMJw0bqxYgmEK+9puVMr1PbYRcMRLUYkyX4if/2SyE0PWdgNWIJnkMIZYG5Ge6dIgpQpqekNA2ynPZpTCQdbPLs7AHkQoe21yNnnhQdrIOjTqt1gkWFWWNxPn1640Qy4ld7XMkSM9nYygklapZjOBBNb023vy8Aqdywl/Dq+zt4+vmmjDwzVtU/3CaiU/uWbzbMXgpXO7RjIfa/Q+UaI6PSmi1qqTed/GqaWg8rFmWbjpH88x+YhNKgk3X6K8g9vta3wqwWeW+7jiCdHoSzjRSv9zLpho+fO8f/7n5SzSLVTopsbaXucqTXN0x5CyidpNY17Lymq45H5XgqqIb7d1GOIr0tWOKH+Ok96UxdObnNbzbP48QZ0RrH8HMoJQEpjjZHE/yt3Xze4ov4w3KL5GV1iDJjM5zJR4NGX5nRmEsPn3IW5kJ+lHTozaA9KT5TFkNrllCUooi8s2SgYesGd1I+JYSDPacLhhYWRKqidoNO9m/magxAkEn9yVVCQdqliw1emhJwhoGO3hOg9oGYped72ZePDrXkicPoyyL5/uMj6wU4H9tWZq93LaQPFw9M0AbOu7IFRZuNrXxN6nZzjzM1EpeWlqMDXmFjmkHRyrkUVKNTDn383sDQZ3eP9grdKI43smpbGVQ9zr0YAH3/YkiBDxvdZdL4FlV7C/JBc9LaL2LYnSrJF3KyygmgVg228hExiL0nAbx/leUiQqgd9ttuakyWyIekQb70x7TDbfr1UZONepZH6hOGJC3o/8Ph9mJhOIVez7iJHnx
 WXjKidop
 OV/BMrgoDSc9ui5se5LlPC7iUsQBpQqsBwUDFY+yVnJjaDtg1Fh2GWsaV5644vhmPVVldFUfTx+wHHEOFOfFi0Bm9nxrEHxebZdpXvzhUdNauI4QfISWg1qcKmDsu48t4zjgIw/7FbUMs28U8F2QkddxcPaMFDLpDl2ZybAGZ8Y808ld9ySNrhGDs9jm5Zo8MZznHD+C5K9AHti54Iv1FI0HtuSd00uUUvW+TsrUKoqNd//vUncDVN5RwKsNKIfQXReE8dEbYO2c10uxrih37Ckex/zPR/BlQTLrvsDixqh89lzz9yEns3IVaO0Dg5YsCmhtE1kj6SEWS0ebOJRjXC1PRz6rKwKd0+17V8q0DE+8eOlx76UOUmxGfpy2Wi/lTjeF8qSppl13sC8HV8mj/e4JOP0Pht91f+rKvAerpkVWQzx/iD9PclNbFQeOB74j81vpFgCH6kKiNL8mXKhfZ3KF0uIJdQVxlElcrzEZJiipYokpkm0L+MwGchvTyuz/th+uTsLaQS+nkVk0eGd1JhoTzzmr7Jaf+AjC4wQ5lV7Ei3WHD7vzkO6XrHLFe8XQRKWbwhXM8Nr6q0pIsvRTwQ19Bsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_MEMCG is enabled, we can access mm->owner under RCU. The
owner can be NULL. With this change, BPF helpers can safely access
mm->owner to retrieve the associated task from the mm. We can then make
policy decision based on the task attribute.

The typical use case is as follows,

  bpf_rcu_read_lock(); // rcu lock must be held for rcu trusted field
  @owner = @mm->owner; // mm_struct::owner is rcu trusted or null
  if (!@owner)
      goto out;

  /* Do something based on the task attribute */

out:
  bpf_rcu_read_unlock();

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/verifier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c4f69a9e9af6..d400e18ee31e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7123,6 +7123,9 @@ BTF_TYPE_SAFE_RCU(struct cgroup_subsys_state) {
 /* RCU trusted: these fields are trusted in RCU CS and can be NULL */
 BTF_TYPE_SAFE_RCU_OR_NULL(struct mm_struct) {
 	struct file __rcu *exe_file;
+#ifdef CONFIG_MEMCG
+	struct task_struct __rcu *owner;
+#endif
 };
 
 /* skb->sk, req->sk are not RCU protected, but we mark them as such
-- 
2.47.3


