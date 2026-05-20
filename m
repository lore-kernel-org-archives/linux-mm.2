Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3F06CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1868F6B0096; Wed, 20 May 2026 04:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15D556B0099; Wed, 20 May 2026 04:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 073516B009B; Wed, 20 May 2026 04:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9E816B0096
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:19:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BCD5C101C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:19:20 +0000 (UTC)
X-FDA: 84787098480.04.88AC9D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id BDAFEC0009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:19:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QGRWwolu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779265158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GVDlYomtipo4qtAHTcknpPeYaQN/qiVuV/EAqg0FNOE=;
	b=CAcAl67cH9EjsjOYXw6oywZUBhP/Hg7QQM4eQwCOPxkO4Giw9Zg176WShvyPrGTgmGnZrc
	+oiHFiYlHZIigkC4cBIM8tXv0aZ6pPbJFzzX7FQ50oIr/wcWBJpsclcpMJavT/XMaM3/Mh
	BFTmLwsOLLNhRaDOSK6AW1SjgPN//vg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779265158; a=rsa-sha256;
	cv=none;
	b=iIvvZe83d0OQn0UIpvtZ9HHoYgijFRkTPngoD08OgQGKSYf8WJP3QO6r9Ft2hQO/Zd6gp2
	noB1CbABEW88uQ3NBwKUClcSJ3ryL+TFClRT8Zdw2gHSuP+jLDXLpPNVl/t+MLBkN1WUKY
	VDL8aZIt2piQScKB7Uc+TGuyKN7uYck=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QGRWwolu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D5BB43E73;
	Wed, 20 May 2026 08:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A23C1F00893;
	Wed, 20 May 2026 08:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779265158;
	bh=GVDlYomtipo4qtAHTcknpPeYaQN/qiVuV/EAqg0FNOE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QGRWwoluHB1wxqmq1NnHTwUGrOw0HmNcITLn8Pe3aTepQ46r2jdkcAYNLOmQLC6Ws
	 fAO7nMcK4IAkEmw7q1Rz88yVzOt27cWANLTYW1boJbIknXERD1KFDTQKy4tYZOuC8K
	 Xa83/+bLmy01KovNY7i3HHz3XSz0Y55T2cD1454db7Enrehvtwru2MztE1Skbw8C6K
	 TzwzSQ9MpvS02tzUSDzYmwgI436vCppFZB1Rztx7znFzz5ZPc7GKf2Bv7bJ/FVIRKG
	 DWbYxGBPnHJkKZKcVSZ0d3B7MBNCEqN4D1I+B9cReO5mepsJHAHs9ie8fqs14ga6GT
	 +nHHtsTbiaf7Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 20 May 2026 11:18:55 +0300
Subject: [PATCH 1/3] selinux: use k[mz]alloc() to allocate temporary
 buffers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-security-v1-1-831bd8e21dd0@kernel.org>
References: <20260520-security-v1-0-831bd8e21dd0@kernel.org>
In-Reply-To: <20260520-security-v1-0-831bd8e21dd0@kernel.org>
To: James Morris <jmorris@namei.org>, 
 John Johansen <john.johansen@canonical.com>, 
 Ondrej Mosnacek <omosnace@redhat.com>, Paul Moore <paul@paul-moore.com>, 
 "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, apparmor@lists.ubuntu.com, 
 selinux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2557; i=rppt@kernel.org;
 h=from:subject:message-id; bh=egsexhbhZMn6N2VNXPeFT9FZiiU9sNsftvujWkJEIxM=;
 b=owEBbQGS/pANAwAKATkDhibLDv2RAcsmYgBqDW51z/2b9a1wBbACD7Lqy3AESWFSJG96Ft/Fc
 u9GHWORn7qJATMEAAEKAB0WIQR45VhVpZkvn3TRr+k5A4Ymyw79kQUCag1udQAKCRA5A4Ymyw79
 kesfB/95neKLPMgBSsir1CVvO5hzi/mjOmpGVmukHgd+jj7BYpflrDOxXDEgBs6XHWLBXr6p9JI
 xvWliqXNwwYOaRYZrG10Gbl4vCSoFGOQPMOCctQQm9FEIATJM8lY9frjkw41Nd9vpyDWOUNoaB2
 3KByTXQIPueuUKZKZxZf990V0FXHun2IroxnjikC7dbpoD+Ok7KlOfCucRjXTKN283DLquejXI/
 MXWd19xgl5hyQaJR8l/0oPy+zZfbJBFZRt//57o+nv0whqgh4IDwfpdTwytJ50DBSSXdYZ7OH1j
 GtKAKh+ZMI9rY83yzUXjIC1ZjMGgzVRheIfJSJrbV+SP0mx7
X-Developer-Key: i=rppt@kernel.org; a=openpgp;
 fpr=B8E96E880C4A40C3C1255AA8C532392DE6DA7CE9
X-Rspam-User: 
X-Rspamd-Queue-Id: BDAFEC0009
X-Rspamd-Server: rspam04
X-Stat-Signature: zj3d9cb1k4cccmjc7irouaeertr4xhz8
X-HE-Tag: 1779265158-186066
X-HE-Meta: U2FsdGVkX1/ZG3QLwItjvrZNcew4ZQMFx7eYu2SqoMAduOzqfA0nbtosDkoOgJpeDNguWFMfwkwuJx5v/P9PzcGQH4azTwyWWD+NFb+1PLPMfH7UsSiRGfv8lTEni38xAf0HDLB8wX7pCq2zWcy4vvjpN3SMBdtWNMbuMmtMwF/+J9qBPo2Ty5G/rGXTc9tiZB3jXsdIPuDclWwukvfX97HGA39GhedDgwnOaJC/rOq9sKjgssBJ4gD2r4/AZIjDDvxaicfLL16sSwn61kMOK8dOBnhMbAauo9Ocq4N8rcfpPA/c/x9a4KVGVdDSnr6J11BA3B+1xoyaVc2M/UN4RzT6dlR05vcv0ZRiGwV+Mmpab9NQyMTsFRQRbX0JsYu8VB3BtTHslRYqMY6zXRPOKzy9DNl/vSwe2QfHzYAtpkcCef79D6nfGxOYu/UWX+B57fZS2bAca/+TbJ3I8kDLTTzjaCEeMKWn2EUB9JFQy4za4oIuz4BCWDMRf9iaqoAEw9f873wD6Kd8bIifNMZz4LkNj5k1ewRGizkQs5Qe7UT/hY0LP9tIT2Bdxyvsr5mUO5KqSMMdFFZKidhJ2yxPmSbL8L2u4XETcjwrStOmldsgly3Sm39fsmVwiaVO87p1qCrXPftShZc/oiUmuSHKw8+U39pllB/47+MY4ZN3YgkgmFNzqeqXq7LwJ2pNzZkAZxBOR5r8G+PC6PJPv4e5WprYNM+dihqDEi0wR1xwP3TwzCCQNrYt0yqneXqHuOV3K1YvzBIsj4nO65CupEywkozjjk6hcxGsC/xtnyprXVq2Y9V3Y+J48C0QBHbaPDOY+AV/pwbmPDq0STJR2mWVfgvXgk9leLgIG13ebHPMoNqZpLNaailWzfAapeeuluUf/tEqJ6GUUjMHzLvEncwfHY2zC6EGpb4FguoV6pzACixIalLwis+wadvFX++39zXZNMSoL7gxPYOCI5K0ED/
 +GYSBAPu
 1zVb1EbpDOJGC3S6zwOrdoTJpIatH+NIyA2QpdyE2tqEMTFJWGnXJSuYktlw8SmU19otRjInLKgbOXbh/xSKS380cptjeOpGFOZvMAYv4NXJvvwrlI4q/IrMZpvQjgJxvgLnGDttoX+PXng8FVlzEHvvTfKjzrxKqpEvhvtMjCnOmC0LkGbZmcPCLbz0Qr0CtM/066MjjzwKEt2dC3ezzuHqQeguBFRoyBz95g6jTlGR6YPKiiT4YgvDHpmozAVb69AH312MX1TI81ZFEI4B1cTYmY3HBeIsr0jYhSKP8O6YMrWtd9KXc5S3xJsUG65dl2/xLiZ67gVRscD6y9I7fmd38lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Several functions in selinuxfs.c allocate temporary buffers using
__get_free_page() or get_zeroed_page().

These buffers are used either to store a string generated by snprintf() (in
sel_make_bools()) or to copy data from user (sel_read_avc_hash_stats() and
sel_read_sidtab_hash_stats()).

Such usage does not require struct page access and it is better to allocate
these buffers with kzalloc()/kmalloc() that provide better scalability and
more debugging possibilities.

Replace use of get_zeroed_page() with kzalloc() and usage of
__get_free_page() with kmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 security/selinux/selinuxfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 25ca7d714014..e7b884eedf80 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1244,7 +1244,7 @@ static int sel_make_bools(struct selinux_policy *newpolicy, struct dentry *bool_
 	char **names, *page;
 	u32 i, num;
 
-	page = (char *)get_zeroed_page(GFP_KERNEL);
+	page = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
@@ -1290,7 +1290,7 @@ static int sel_make_bools(struct selinux_policy *newpolicy, struct dentry *bool_
 		ret = sel_attach_file(bool_dir, names[i], inode);
 	}
 out:
-	free_page((unsigned long)page);
+	kfree(page);
 	return ret;
 }
 
@@ -1349,14 +1349,14 @@ static ssize_t sel_read_avc_hash_stats(struct file *filp, char __user *buf,
 	char *page;
 	ssize_t length;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
+	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
 	length = avc_get_hash_stats(page);
 	if (length >= 0)
 		length = simple_read_from_buffer(buf, count, ppos, page, length);
-	free_page((unsigned long)page);
+	kfree(page);
 
 	return length;
 }
@@ -1367,7 +1367,7 @@ static ssize_t sel_read_sidtab_hash_stats(struct file *filp, char __user *buf,
 	char *page;
 	ssize_t length;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
+	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
@@ -1375,7 +1375,7 @@ static ssize_t sel_read_sidtab_hash_stats(struct file *filp, char __user *buf,
 	if (length >= 0)
 		length = simple_read_from_buffer(buf, count, ppos, page,
 						length);
-	free_page((unsigned long)page);
+	kfree(page);
 
 	return length;
 }

-- 
2.53.0


