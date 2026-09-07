Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A23C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 21:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E9906B0093; Mon,  7 Sep 2026 17:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 499F86B0095; Mon,  7 Sep 2026 17:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD8B6B0096; Mon,  7 Sep 2026 17:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDBA26B0093
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:00:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 520D61402DD
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:00:30 +0000 (UTC)
X-FDA: 85188184620.20.6A33443
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6929840009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:00:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JdFeXt6m;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of jannh@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788814828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iQCLFONZFsqSS9MwFNZTsRaivhIEdBav9Smp5SCcRdQ=;
	b=OHhvSAHHL//S6FoGYnuWmurYhA24C2AAzx+QVAZq0AOdiM6z0VW+QP3fS+MquA7EDGRa/u
	L8SwYv8db0hV46ckv8bJM2vEw66MCrtcT7bOf+BPuNaxkkwJcQbuXj69PrrVWXXf7QYsev
	3AET/TEuksgAktjbzprTOqy2nNuHvmg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788814828;
	b=7vbR6SBsT1BcDR9i2AzYkxVgb9oNO2LBgFyQlirWdpFMrcNdcfOz+AsrSWlwqE1THVfaP3
	ntq+vD8J5MwzvNGzWHARK1nqA/3zCuAI8wPQO9tLVu92EAjl87uE5aWUPi4qnRRQQuFEkx
	vxeyPQ8UnwriNedUPvcrgzZwxLKB6M4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JdFeXt6m;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of jannh@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=jannh@google.com
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cda5e048fso87315e9.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 14:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788814827; x=1789419627; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iQCLFONZFsqSS9MwFNZTsRaivhIEdBav9Smp5SCcRdQ=;
        b=JdFeXt6m5HA4g88r6YwAi3Ojkd7kJPE2UvTkglQXWMFOxKC4PX8Q2Dt2CdX4UKmF8G
         5f3d60XYgoqb0hdjPuwC1cEHuxIV3PDuEkPu1SebfRdg3kbmbiXSEuvsVHs9gFkuXoc3
         5TRFBaXmOy1Lg50+PPCNn3anT4sCfz7uy6/I1UhKiWMhF6KDEAoGP1hjcEgr6L56cJs6
         hvttuQxjdI4IJw2EdnSwnYmO/GqaFHm6VsIKvjb37eVjKRB917FKmb5Y7m7Nhg8qDToS
         RP7QvahxtUdFw8BHu4kbeyzgCm4htc+gTIyQS5+3lN9yaBsFErYIrN9SvwiCJZxSuIY/
         K5nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788814827; x=1789419627;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iQCLFONZFsqSS9MwFNZTsRaivhIEdBav9Smp5SCcRdQ=;
        b=FpHDIv4OnQoLFnJBB3rTW7zRQUhqvhtqqQnEUwN4+ALqfmjMZukaUwpLCWSgJHm/to
         K172ZAKN7N3zob+wiNGMslNo1bAxLQt87K50d+S0UxcD1wSCgw1L8vG4gWSZQBuofeML
         xpMG5EpI959NAP3pC8mXWYXP+iqFjd6SrI6/PhTQ1DilPWxjD5UfVDnLcg7gJ07D5V7F
         0EnszNMwT4VWi+HHtJxgfu2tiGDeZeHKao/Ul42Xg8HBMzYBT3jEcEzWLCy43LrBPYRW
         p0+6YV/WFJfVmgXDbzk4SjhybdO46MZjf97Mso1LxeF+K9eJWIzlsfy84oNeNcGMtfFQ
         yjgA==
X-Forwarded-Encrypted: i=1; AKwUvByMe/XOCS5KNEZkFyMLnZhIIZEK/s0eNRGp454UuhyW34+ntQuBP2s4ywTiYFXt8+YqLDm7s8mm/Q==@kvack.org
X-Gm-Message-State: AFuF++khfmSwMpIM47v40ewurPIAKqfjtPOoFEg3aeRz72ALPTJ87VeL
	EUlxZ6iMtkRA4i1lfy8m8jenHloIEBY5L0BHY40ZruF/hHnCG6dKPpEhtLxwUSlJnA==
X-Gm-Gg: AYBFou2yLwrmhSUkD8asEVQeNaNfvjdX2D/bQePnamWCNS4ERV+qdjKg5L+WNY2soKZ
	IKUtPpJ8H+coO7q8iKdAHX7reOOxJUXp3HBw9TccT/ewMLHGt814DmiWaXHf6k45lkjUMisrOk9
	FLngJtQgpxcyOt/8alcCkSPq8l5k2cC2slr2ZLXarufRtgnIBfLEQpQVZXDANKxxgHN3rZ3QepF
	GXhxfnUb7wy1F0t0AArh6exs6OT3R4Ze7QqBMgOC2h1mdTdBFxQ3O8FFdpiF3lB3O9Y1wEKg34g
	WptXHt2inOQ6enGX02JiviNLHKVex+HSmiiHCNOnVY9iOE9/YTxitgtmgR9jmsnvZgeWBE6wNxS
	GaGD7Owbbrmxn2EcfVUamf+2fq0/3TLDS7wiohABIE9IZqYWiZVluRvfzM0rgIYsG+iJHQrsVwh
	KBInlq9/Fkr00W6BFKiXmjoxGIwOcw4isKtkoPmldHZLFF/Mhfo4B8CSNMrgQMjGccx04aId2qI
	sqaSYvI0aeBajigfEGSwe1CaPCYLOUEOgXmagYr5h6qbAaJ
X-Received: by 2002:a05:600c:6a97:b0:49c:e41a:4c70 with SMTP id 5b1f17b1804b1-49d0918770cmr1429165e9.6.1788814826565;
        Mon, 07 Sep 2026 14:00:26 -0700 (PDT)
Received: from localhost ([2a00:79e0:288a:8:437c:9ac6:4a41:e58b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cff8195ffsm284349545e9.14.2026.09.07.14.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 14:00:25 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Mon, 07 Sep 2026 23:00:16 +0200
Subject: [PATCH v3 1/3] proc: refactor /proc/$pid/mem to use struct as
 private_data
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-selinux-pokemem-v3-1-0bafbaeafe50@google.com>
References: <20260907-selinux-pokemem-v3-0-0bafbaeafe50@google.com>
In-Reply-To: <20260907-selinux-pokemem-v3-0-0bafbaeafe50@google.com>
To: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Jeff Xu <jeffxu@google.com>, 
 =?utf-8?q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
 Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788814820; l=2509;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=nXhPP7b+pyPXaxP9+90HyfAUpFQfbnZ7QKkr8iKuqZM=;
 b=TjH93s5viiCaqbVla2fILw+6iavAeMoHXtJBogMiukSdNz0HlukgBb+TDYrU3XHWPX6nl+Ot9
 pD4MowbEkJcBFfFenw8ptozqsSCQUPqx8gGuKY+Ky6uiXYzKNt3+1wC
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6929840009
X-Stat-Signature: 1e1ydnuasdk84wgd89qttx5ozzq5w8f9
X-Rspam-User: 
X-HE-Tag: 1788814828-346067
X-HE-Meta: U2FsdGVkX1/Vy9FwTgwu/5K2zKMIW5SD7e6U6Y/vwPFQz5cNpldhbDIoaCde77I1UglYgR4qmtgIKjQrmf6RscC9kWy0MdNB+Q6mq2Xc029KBF0LT+JO51qPwja0GGglPOZIIZZORF+xUaasUO63ud4ZvdUo+msSKuoXJgkoAIs+8kOCCxpRlen0TxUYmNXbZtlRTMeWwsy+DMiUNvEaCskG59SMT/ijIj/2DIMKxLfdG2dB3lLUj1yM05uJnEGo8PkNEbyHkvd97ZYsX1Rnq/hZFwG0GbxJn8uOs8T9rDS1jeovv/z7Ep5CyQdK3Y4ZnX3cVTx2nl4HinavvnqAr7aqiLJAaxjzYYPnnp7+yXOyHNCiE+HIJ6oibfYKZaXG1+pYvQmImtIVxv/cT8Rp9z+oYKpEi5LEKdB2dESHbCWNigduptV9GywkznYVGnHbEh0KmoNwqJt/IOBkFgY+2XHBtwwMap0nsisi37ayIUPWjdCagqa2z4LH3xN9CJN5MLGQam+4TeH9pMdqA09VEn+0cqog4OsA3KmwDnQUdHluwKZK8yrI4uDHYRlWZPkByPmZbVz6bWlyR5OW9X3K0WfxyHiDAB+cdUWj+kwo4ogMYpjo2tHPGIphi806a52vRQQjOcC/tIMIHldzzJfoFNKV8K1bOkYI/9AG/bJXYdv3DKNnTgXKSI1d+FL6UffZrwHNsb6NH4CNSJYbhfmxe/VvWT6i2eW2/+x2EJqafok5NQ4ENmkj9ct4zpCCDccEnWuG9ju6N42ear5QIgFtuHLEcZVE+0Opq1mm2LwKO+BqEB+KjLdl/GZh6DXfo+ItvHaBPOicR6Lm4zp6qn7oJMaWT/qKtxb4pm2XmMkU8g3Uvx8wIzhCxIe5aVdPjgs9hY4eBDUMZBJGJmJnUfqZ6IM4Ynb7bIwrJdfELr76clbf2LNMc8fzb3jEcJRH1+m2L3bBK8rE58lgAYSJDAP
 cii+EPIl
 j1QKL9IFJZdBXuOSnUV7Rwh9WcqFOZgW4aSbe6XIH47nx08lVHeYlAeWAf/3jwy3zFyWOAjzN6Fge3CTCuXBqRyZ7wcTdzgAvjYo1IE8oaccE/kLoH+l0mo7rjImKpYF2wOcnY4Q/sFpMZ1bX7U/K62Ct9drs/EqM1JkHcbsrJVVvoGisGnez4n1+PgVtoPUCAQU7CKRRDee5MCSk97YUeSHzWDoAb+LWlfwL9wwBQ1i/vKI6P8qZ3unX+4D7Wyvr0JvN5qlh+2kYIMlua05RqmkdZlFfWSaW0Ym1DAwEjBdurHUgSqRhxb+ok+My12CrOALtKorezFROmMMTyuKnqMzhLHfj+w2XUEPOw/DztYuLr80r1JjYLa6Df585/Y2KCDbfOzBNlOjJEMaE39d7le8n+369Rk7hCDKGFgfDmbHJ0fmqbrs8A396/+eZDPaOK7HycP5SPwqhTqcWfoVcadr/xEB3NwgVj63VN+zr0wNYP2wX+od+OI3ViyfaU+RQ9VX0bgo2BMBe7uf4c8WWPXnjiDAN30aCbjE8FbyapB/7APCORtoGqwsBYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor the handlers for proc_mem_operations to use the new struct
mem_private as ->private_data, rather than directly storing an mm_struct*
in ->private_data.

This is in preparation for adding more state in mem_private in the next
commit.

Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Jann Horn <jannh@google.com>
---
 fs/proc/base.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 780f81259052..bec6197329dc 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -848,11 +848,24 @@ static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
 	return 0;
 }
 
+/* private_data for proc_mem_operations */
+struct mem_private {
+	struct mm_struct *mm;
+};
+
 static int mem_open(struct inode *inode, struct file *file)
 {
+	struct mem_private *priv __free(kfree) = kmalloc_obj(struct mem_private);
+
+	if (!priv)
+		return -ENOMEM;
 	if (WARN_ON_ONCE(!(file->f_op->fop_flags & FOP_UNSIGNED_OFFSET)))
 		return -EINVAL;
-	return __mem_open(inode, file, PTRACE_MODE_ATTACH);
+	priv->mm = proc_mem_open(inode, PTRACE_MODE_ATTACH);
+	if (IS_ERR_OR_NULL(priv->mm))
+		return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
+	file->private_data = no_free_ptr(priv);
+	return 0;
 }
 
 static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
@@ -880,7 +893,8 @@ static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
 static ssize_t mem_rw(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos, int write)
 {
-	struct mm_struct *mm = file->private_data;
+	struct mem_private *priv = file->private_data;
+	struct mm_struct *mm = priv->mm;
 	unsigned long addr = *ppos;
 	ssize_t copied;
 	char *page;
@@ -970,12 +984,21 @@ static int mem_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int mem_release_with_private(struct inode *inode, struct file *file)
+{
+	struct mem_private *priv = file->private_data;
+
+	mmdrop(priv->mm);
+	kfree(priv);
+	return 0;
+}
+
 static const struct file_operations proc_mem_operations = {
 	.llseek		= mem_lseek,
 	.read		= mem_read,
 	.write		= mem_write,
 	.open		= mem_open,
-	.release	= mem_release,
+	.release	= mem_release_with_private,
 	.fop_flags	= FOP_UNSIGNED_OFFSET,
 };
 

-- 
2.55.0.1003.g10538fe699-goog


