Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7523FC61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 18:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B0936B008A; Tue, 25 Aug 2026 14:39:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43AB96B0092; Tue, 25 Aug 2026 14:39:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3044D6B0095; Tue, 25 Aug 2026 14:39:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBAAA6B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:39:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 553BD160151
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:39:34 +0000 (UTC)
X-FDA: 85140655068.16.3448AEC
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id 597434000A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:39:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KaNKBrwL;
	spf=pass (imf12.hostedemail.com: domain of jannh@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787683172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZDanl1d4pFlCVpfToYIsXIfzb7i9JlEtociyRendWt4=;
	b=8fOh3YzElPtclyJNeeBncrvB1XnBxgKb4JUVwLonkBNIgwFi5/1wGYP1O/bFLwZCvWbUHm
	lybzeRV/RIKbSe252pM0rzgLUcNsXd1NIohUl7DJS0auv8yezC4ZeTiRSYgh7A7igYPSig
	wpQ3lR6zOYbTZJbw/0eZNLUpfZx+QjU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787683172;
	b=E8LlTbFovK11hDi6w2+vxZ/xBh5RvouocSffXzaLzwARd5BxGHWEGsPezoLa/O3tAzbI8S
	ZgCAjiG86Xyp6cTr2iktUBiMRcH4OxgNoSofmSdSwQHDFk0LKor76qKmBhbK8g1KGGS97I
	x8nU0irhyqhIillpqP8ru/+8/mVBAW8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KaNKBrwL;
	spf=pass (imf12.hostedemail.com: domain of jannh@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a17c7c3c6eso1715a12.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787683171; x=1788287971; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZDanl1d4pFlCVpfToYIsXIfzb7i9JlEtociyRendWt4=;
        b=KaNKBrwLp1QCoDdpacWLSDN7L2S4rZw0eWUbV/5lFVoxvjPxPt9M+SBYUssaqn/Ixs
         B75lu11OKiCRfLtDswUGUkdONEecsGIyY1IdOTxpZI3ZFZKGvUz/GLKOG3ZP3FXykT60
         /0XMdlxNR2NHIm6ozo53tsnE+voGqCQVRjC+zaINUmZVwCdNkIFCRlb5fwtWy7lhv9W+
         3C9DYgBKbUNnJr75RgMzzBE8Tc9VwOuYiJPfOXOL7b8Jxu/w5sx8Ez5PCcrU0ZxtUznw
         5IbN0wv+n4UNsCVvz+Ak/2wPsDgmZLM3XiehIEoRn3CrGbtqQHEU637oZ9i6Uu++HmpX
         ngHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787683171; x=1788287971;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZDanl1d4pFlCVpfToYIsXIfzb7i9JlEtociyRendWt4=;
        b=EFZVnJyPBQhqLyvLvpmxBg6dk2/gt4/8xRoLbhcjuNwnbQq8P/6mErw6P9tVyW1LSF
         O2arZIFdKTPAQ91fDVHgTU6YAZqTITqlPBrOn6mLoqdxV9ugQQJ1E1ykhGbI98l7QYHD
         KqRcC9R3BWs6FW4dnj+9NU9iM2CO+pOTED1hdrYrF4Dzu6hKonehueVlS7asCqWe0oCH
         CzdA93xlSwg4FVv98/zF40IvLm07mCbbgoRUvVYJXa6KWx71l5vNkC7DcY19mvRrMBN3
         hRMYaxumMdn1/wbE0XPwlTVe46QU3oDL54gLNnWaMccfSCKa60WAG9T0la5BHDvykByx
         mtiQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqh+30GXe6SAPbeCyLZCmd63dhtOGUe41zhkOkn5Ij4IfBAQHJW4n/i3BxKuusEkDSzeeUEDtc0sw==@kvack.org
X-Gm-Message-State: AFuF++non9DKvCDoK3dZjvXlUuTr5UmHkIFNEOq1K9NMMT7e8C7JTCsE
	3PaPAid7kmKtSgQeyiQJaOp658lfP3ztY1ZqkKqmjWN+ZRP6f52pSzLMsHOqdx5djQ==
X-Gm-Gg: AR+sD100JLB2/gLVQFD10XrS+gwV3BZIWqE3ZYbeioXv3Sti2pTCW/U+8KVjlL8oYK0
	aAxGBFVYCXBUx87mMzYY1xEYvE71Opa5VFyLQp0EOdF4/ly/tABI81wcDFLCF1x2jFjc4ScCDKj
	N1AkDvn59z4l8x1R2Bs4vhJJGUtdS9sgtyJ6mTnVtofQkJDt1LNTQOduZcQU8iSj1J9kyJc/vMh
	3KsJtWA5Tw+yXvT6mWcVWfs431FwD+Vvn+5voFaoGUhuok7dh4mSCqUFjW1ruI6pRn1lb8ihZT2
	91xRBG6ViFUheQthjBXJdnylnNuz0lt4JXBtkKVJr9L6gM96ZeB1oVoihWseaJn3w06mrrET9B4
	wbhiAKdlI869dvOJ8zVq2fBzIJ1RFsnpXj7oFyB4pQJbpKGLbVhYW+50OM4myBcO+1v4JuWafHR
	MvC+14V8iucP9OdKY0hgk+ndawOQ+FWlt/S0JVAhW7U7XATYHmZXCt2JkX/wbn652UWNgxXAo+4
	bxMAbOr+MoyDBD2x2V9wotKVjJkXq5GlUgtmoKP0WOBVT4=
X-Received: by 2002:a05:6402:1503:b0:68a:e1ba:9cc0 with SMTP id 4fb4d7f45d1cf-6a5c4a438c1mr79208a12.8.1787683170518;
        Tue, 25 Aug 2026 11:39:30 -0700 (PDT)
Received: from localhost ([2a00:79e0:288a:8:980a:b43:2df6:51f2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a704e55sm77188266b.21.2026.08.25.11.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 11:39:29 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Tue, 25 Aug 2026 20:39:17 +0200
Subject: [PATCH v2 1/3] proc: refactor /proc/$pid/mem to use struct as
 private_data
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260825-selinux-pokemem-v2-1-b46bc64916d8@google.com>
References: <20260825-selinux-pokemem-v2-0-b46bc64916d8@google.com>
In-Reply-To: <20260825-selinux-pokemem-v2-0-b46bc64916d8@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787683163; l=2508;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=cMZpfmy5y60iCBgOY8zKfRDT8aXfoJ3FsT1GEaT5qgg=;
 b=etcdXt6YJPtLzJ6NsslFUvgTrScKbEiz++YkD+u7YgmV0etE8NJizSEaw4u8B+QgHDC0OYnkX
 3FNCYVeg1SkCai4r7vUI2wYlcZQZ8x+LEATW601w5uzuzrhWwsKDhRj
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 597434000A
X-Stat-Signature: r1whmcqx4uno6wcgeu1be8e1hqzbzoru
X-HE-Tag: 1787683172-308169
X-HE-Meta: U2FsdGVkX18nhvkE7uRuj3t7aIfLTqHG93u9uBJqWZgWelEBpnKSDi5/semcC04ThHAAH2+jQzUSgfj/egxiysf5ooTMgI0xBOcD6/5ibipO00D5LdRCDi/ZUmPqElqbVfm0HjJuB4cZtaVZ6YwkJ5R1ylhhH3NWukZsGbHSV4+JsQg6MpR9yGVmDrq9hFiIXWOys+ZjSIniSd9PZXc1KfQHHpluy4QWYvdK3sbUJP/7zgBNBd9TFb+Nf7SXLGpRpqAz5Fl7SR7wLJ2kUYNsg/Nf2KzRHRY8SrlxBDp6b1c+7u87uZryeCbkWLpJzkpaqYDRveoNeMqb6udkhlnQShVdoCJR6CHwQJ68TwRpGwBjs+34nMuuzesJpkPWcr/zxBHyMOJzRup1Q3QdJjHFNOlf3meY+2Ez1gXriuLLSb7OlEkiDq4hA5IG3KtFroQWtSKTFKzTaCNILtMKx1yaxAIOsjqqwV1qT0Yvmp/SAFgzP7V+GkL/oVhx8uWptMnwWWBHKebGM0e+n5YHggrAulWMAwLitUtagDJgrsSkSkJPOKTFnExf4fNqhkfqEIf9oY9wt9sspHmmdtb2n3nauEB6gCEyK61Cv/B+vUsM9l8gf2FocsEqOGyDiOz2r1fvSm1HTF9Pe5xSaanMgOdqKPHh2IU6hebNbg79Ob7eW3C+I1SNz9AAB4eErRA2rk4WRZxANWpDkV1YvgMFIdidvG0OY7shOR0Qs9hu2btQiCaPkceUvvAhiWNW8sRPtIki+pOc/dmv9PDkhP3g821bGKZ+Zb9ZFCRbYHVp4JS+Dsn8i8DzBIv72tseUKNSLEnfHS6Vhlph/hTN5tQKTmK6TqkM5O+Z2LcdtbNMgXiZS39tQ/5Jw39Nmj5eboT2jZEdCmPU7hf1IYgQiS9+5Y9zMbZvIeR6AOkuAY2t6gdC9VZJYSucVHBSc9oPgRkwyuhGQeHiYZALs/EUASU3ujp
 bNxUj37M
 Wxux5XcDIQZ1VeoCGwuTthg8fzRliUTgbFf706uEGltQwV0ZagMdTVJNA7YHqG0k7xtc1jdguzFfM65JxN9/R0u6HkDjQvo4YLBAAqZ/J2UMELJPFy76tyJ1nVJljtq3FQPCd3OGIPJJFvUh5sROWJBk1TY6DHtIC1S8QLhbMNd2qD322zEm+HEvx+jEdS101Fg0vbfSnsdHZ50rqaLYVSvuXyiO7m2lTJKk73F28Z2Vm3V/AxI1099E382f6V7W3+dvtJCRvE/w8gqmfuC7tK9uaApT/y2sP2IHJoD6254OwTCDcMAS1zgQhvrM7adq5PkrJzPWd1ADFp/Ii1rcbVAhNczBB9xV9KS99NCGdxTDwIU0B8d9yT5TwhTyeyoiku7o2nK6OafbXiOd3FtvzD8jYfkOp4rN3NucLcTyxXZO4vWj1MhlC6Qscl976KS5MvAygM1ubCkjrfRxw2lP/YwIVJLICn+26v/wLULxIl8eV+luxWixxgM9I4ScI5oCU7Z/mtDwql7YgbGQ6jBfgiiMWPj7cKXT71OYSJV7mo23Ay1YJHefTj5+epQ==
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
2.55.0.860.g4b6b3295ed-goog


