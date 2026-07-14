Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE553C4450B
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:15:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 811FD6B00E7; Tue, 14 Jul 2026 11:15:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9B76B00E9; Tue, 14 Jul 2026 11:15:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1676B00EA; Tue, 14 Jul 2026 11:15:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6AE6B00E7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4B6F1203EC
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:16 +0000 (UTC)
X-FDA: 84987730632.17.502728F
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf26.hostedemail.com (Postfix) with ESMTP id 046BF140013
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M1nlwfrv;
	spf=pass (imf26.hostedemail.com: domain of 3gVJWagcKCNgPCJCHMBAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--vipinsh.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3gVJWagcKCNgPCJCHMBAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NsilKFLygw8IS3OsjN731JV3UeNVYFWUky8KZoNrr2s=;
	b=SOvaJpcb2dXVwXbXpQXDEIlXhP3pAA9631mitUDxe2AAfdoCxuSGMV+HUMTMZrgUPlh0Fy
	lkmW1MOVib/IDJnnLy7SJZIET6WbkyKWYIsTQu5jQjHTOKpkn0Iu4SYLjKzJcvex/jWj6+
	M32J99vnBCVqfH5dzr58ORioWD/cV2k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M1nlwfrv;
	spf=pass (imf26.hostedemail.com: domain of 3gVJWagcKCNgPCJCHMBAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--vipinsh.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3gVJWagcKCNgPCJCHMBAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042115;
	b=A5v+NFRe+Dx8lS/LR4/aFL+NCOzHvoOEqh4+o9WNGxPYBSr5LBcSvtowL0T8PJnmbbuVht
	UbSXW1FZ6B8/tkqTLHWmV2RbHdVi26rLUQz374ED35RQ+apz47/788TatLzo0ZgpYxL3Ma
	Sy6sgtWkWZ0pUsMEH3cvT1z5Tf4wedw=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-848860def2cso4614399b3a.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042114; x=1784646914; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NsilKFLygw8IS3OsjN731JV3UeNVYFWUky8KZoNrr2s=;
        b=M1nlwfrvyOizR49prWM/XhncbFdoIyKrCPtL4zfaxQEHlcPlhxMH6Tgh+hBX3s9GAD
         IgjJcquB7bpuFN4P4lcVUK1pm9oUMT6K+hIJYlMG1ZZ+zrElnNIGNn0po5luZmlc8qn4
         Av353vi+CiAjYrKUX0iB4/25tFychJYMvX2pAu4H8RfluFzVLQRKMofCgjreD1UADWby
         wlMHh3f942d6FbVppP0DG5mDXzhMN+b+gyaOeD6K541y0zq8Z4BQnm6BNkqorrZFsD7K
         RHAJJ4azKw82CUeLLt03ZrnB524R+lMMSaDb7kSiBju+gnlI1vWDoi4A6HJjcu29/a1M
         zNlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042114; x=1784646914;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NsilKFLygw8IS3OsjN731JV3UeNVYFWUky8KZoNrr2s=;
        b=LVrBfIfbMDepPfaLWxDugVhEp++Vh+p1jVEo2PHFrkGJ45NWH9hmk9YacGXzjKp6Wc
         1k9pcO2s21q70F+pz+Crj2vn17u6Y9RlsxAUjMh+/MUOiOsno6S2Q3voT9BQyjpBb7J2
         +qg+rMNhgJFSKpJDa9LaesQIys6KWhPaz70Uf5dD29wC84HczYzmJPQvgmlo60qj2qyN
         2Wkkzr3Xi885RNyIixEP0rEypHabn1mzedhHXQHzzUeHqd8kkXRDbcebUajxnT4V2+bD
         NedJToj6/D0oWSlVr8/Vrw16Cv6n+WfolGsmlrpOsvpkgUwrW4gdl6r4ElKrYAzH/JqT
         ee8w==
X-Forwarded-Encrypted: i=1; AHgh+RoBDNk2/jUA//T/6tTcjgJdO3JCPwSn6M8BJRMvaOSfpS2MkeZfM5trRWeNJdh9p8IzG4urwWRtaw==@kvack.org
X-Gm-Message-State: AOJu0YyQQ6Sto//HMXXJCTL29Y7F4TLHCW8xp3usQyo8Gle715r5BQ0e
	y+KCHsvF/opRPdXiLkdLNrgoTrcGLb9swftREpZsOccvOMhelpfhFzA/ufOlOaQoPmXH7z+DDOD
	tSf7yyHBXgw==
X-Received: from pfff9.prod.google.com ([2002:a05:6a00:bd09:b0:848:487e:d23c])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:992:b0:848:65f3:23c1
 with SMTP id d2e1a72fcca58-848897d7661mr12194779b3a.69.1784042113533; Tue, 14
 Jul 2026 08:15:13 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:14:49 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-5-vipinsh@google.com>
Subject: [PATCH v5 04/20] liveupdate: Export symbols needed by modules
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, 
	rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vipinsh@google.com, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, 
	yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 046BF140013
X-Stat-Signature: 7xgmw7f76wjwccayfukbammitk6gtxen
X-HE-Tag: 1784042114-969808
X-HE-Meta: U2FsdGVkX19WEN6uLvqvUBTT6Znf981AG0KkDAhqeZBhDoaUJa7xIzvYVd3WS9tnBhv8I72N7r11aJFxwdmgnBFoAjml2uu3aAfhndK2xZ31qsWMmlwsJdWRluarlHq6BVMc6Voq9LT2XOpClCbaituojxB/kG1BIUFIHC5Vz0++uMkdtLQeucY+f5kA5fWQah/+IuosRYYJ1mRCSI16fM4Trmjm6j/jcxn9Mz7HWWCGjP1nue/G3ecR+4A7hbmiE0kSIlOPp5zQ2hi8fFrBe29cC5yCsjOEq5Mm5kEC/uEIsCfBL54XAHc37SadPgLiKiScLVbjNL9uhlESgg9pPF4wjoSF4sCilindT/odGwKO4U6gF7K+UYb7bKnpBU8znIbBsSYt4ngbwW+ORj+PfoZNuIeGLIFD5uw+JjBGlsbZI+SDziEpY+rgbjWAdL5zM4En8PTBYdEAzCdqo8SBESgQKfjYk8L9lxzKzHpURWWRZ+qQhzwjJj2kj7EyMPONVeL08fkRfWvc4xIs8/nCvwRl/tlxYgf1+lNeih4s7DkZzEXxn28JZz4dtg+J/EhCi+94uyioBga+DvOv75QEI+0h2+VqLuTpK/y2r9/sjNI6b2Nn9g03yR6A3/8VCkaYwY0r3NpzCDs+xqiHaJ2MQ4fTbPaRY8UR7UnFB34mG+0WYaab1TJILJyPKymU00QB5ouYpcmtYsHyx/O2joT5LdJw6VMcWJJXhDPptH+KKDbw+pRDrk/Ovz02Q4wYE5HTij43+mnJFJhQ1ydZnFzVWMXQ4c5GKBkU6Lpkoq/QBPQVIULTuR+LwiaOuDwXoRhOqO1Cw+hpgwV51xhjvKDa+w3dU/HmMry03tsZCn6skEV1+kBoPmHIS1YWxjOzJrHvpPNDZO1IoJdWMjNxvoUHhKBFw+dAlYLjpMF99WBov4DrBQtHjnW1XPn0/jwa8hS37Aj5EkUAVtqiBDGnZt4
 a/HN3E0t
 mR7j47fL1KaxL1Ta2WyYWGr6PjdKXt45rMJKzAjaf6LKZSyTRyiumykdWkW7TZrC+dARewqtjKY9cQMy8VDoFeXR/wRB0jBq8a4bNkvQ5yMejdeL2XkgdKXqm6XRLwu4elx9t9jhMkblc9gQAVY0FDMoB1sIOLyw2dR/LWR3Usxkhq3UsNrd7/XDV2lOGPbMlBGVWkx11zHj4XcJdXA7xw+qFdNfnQOHGeLYSrFXgmFngzpCvsmyl998F3BZ/3rY7As/0Ck0ZQiecWXDFfBzc2/2Pktc4oIFn93YZnotwrO4vAEjlHBIw2Fncoo16dR0mcwNBdjcEaQHg6GbwvYNu8shTuZmP8e7VYEbz7ciIi1jT01diYRT70uG7ljlh3Bbg1EYDQG07VvG/J83meWLw7bE/W2xiIdRhW9PmCK8w34GYP/htTh24sDN8eJHohfUe+W1Ibj6H5xJziIPlBCHeRp1wiZih8xyr68hJBJvo3bWaEfPfBLaMN1O6zg0bOg0kv13QqTxxLiFdi+XdGNMwXT+YojKlD5E6yjuF47JLDOR/K5d/w+pPDR2clSVADWFU26d06tmnhkcLBmoZIQuRy7wHwlOsmeVbGwAS9Nle9eWSJgtunukRYymq8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Export liveupdate_register_file_handler() and
liveupdate_unregister_file_handler(). All of these will be used by
vfio-pci in a subsequent commit, which can be built as a module.

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 kernel/liveupdate/luo_file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index c39f96961a85..dd4e26ac34f0 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -909,6 +909,7 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 	up_write(&luo_register_rwlock);
 	return err;
 }
+EXPORT_SYMBOL_GPL(liveupdate_register_file_handler);
 
 /**
  * liveupdate_unregister_file_handler - Unregister a liveupdate file handler
@@ -926,3 +927,4 @@ void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	luo_flb_unregister_all(fh);
 	list_del(&ACCESS_PRIVATE(fh, list));
 }
+EXPORT_SYMBOL_GPL(liveupdate_unregister_file_handler);
-- 
2.55.0.795.g602f6c329a-goog


