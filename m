Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C30BC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EF1A6B00A4; Thu,  9 Jul 2026 20:24:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2528E6B00A7; Thu,  9 Jul 2026 20:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 007A46B00A6; Thu,  9 Jul 2026 20:24:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCB916B00A5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 33C8B120320
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:06 +0000 (UTC)
X-FDA: 84970969692.14.3149971
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9DFF8A0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bLiZMpGb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJOHjYArtxH1+/qkwlfdh08BuCLZ4ONkiqi8cM2xmzA=;
	b=6JYYpL5D5je7HsOOQ3MTiedzT/vJpDOjlVHQkFnF2CqfN75czUlaphIheLsTaT4DlIINMP
	GfJ0LcH1B2zIAA6iMLjLS96puNc0AtwzuhCOUtnfYpNLCNNjtsi7eFu5WjJJxs6zmQmxG2
	aSFsSmyy0yz4FBz50D5yeX/SC+TdwiU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bLiZMpGb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643044;
	b=8atkAQq4w6w7XfMacpftheNcf6Dw5S35S6PfBG/n+U6XaRrPC9rEpzgFnEB3Yz/b80qI9T
	d+7BoSnl+Lbio+u6cGiIYjcMpn7dk6LwcBLXE4OgXDtN0qUimPdxzJ83VOymFtohCHNO1c
	sINVKtFiDyu9s+Dk/Oh8hwEjx6+qofQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E188600C3;
	Fri, 10 Jul 2026 00:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59691F00AC4;
	Fri, 10 Jul 2026 00:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643044;
	bh=yJOHjYArtxH1+/qkwlfdh08BuCLZ4ONkiqi8cM2xmzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bLiZMpGbv0SoHp/IYGQ9hEGn/GGXDcmqL6bIyyKmAQ4bHA7Jnol8zSAUHcAkKpN4V
	 Nvg1GIsTaspSkukYRiJb3rfncFQa5eeL2tNX6pg22tC8pgzqEBVdE8MLxLFq7sSJxH
	 pMO9JWnY35XWabkOjEfbGJ2/LzXMb9FnfJwFWunMtWk2XVf0/MhCC6ZlAiay9Xa/YE
	 8vkPRoNHLbWb/BY0KzL8OKsdPHw+M+g3DDRxSW9Bfl8uMG2vtI6qIKqQUV3laHGPMw
	 zGGOKzQRLiDTwLUcBhuqhND+uLbeTkgbotGRcck+gmXZ1UDBAvjFWhZsh3/RHHDcRg
	 Et7J7t7s+COfw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 16/19] mm/damon/sysfs: implement probe/weight file
Date: Thu,  9 Jul 2026 17:23:42 -0700
Message-ID: <20260710002349.111414-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cx3fcy1sn78f71fd7opao8ah4spn8x49
X-Rspamd-Queue-Id: 9DFF8A0005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783643044-737862
X-HE-Meta: U2FsdGVkX18hKh9BrJ6oA/huWI64RuGBlG8Vtv64XaLoOAzXbTb21swVGcGQcDEynDGYw4R+blCIC20k1MNY38V7IKLTpCNs2Fa1LIM1zu2clUHRxCItEhEghJhxWhYtf8K/XcoFs1sb2GZSZ6Gas3TZz9qV5R/iGT9fdkTwQCoOS+/bSiP1KEwJRXyvB+UpXKthQegKIHR61x+JNJfiEw2XgVg/Vp5aPpQ03aAdyIoVsxqChoSOAR7lp43nS5SGpYofqagW6TEGiaCenNZqA65oXmADUtVCXQSNC66GAlE3XPAPDtxYo5JRS8JYckoQrbljMhauxIlJSKfpvFC8+bnYEoti7USWsuIpMaTGTE7l54LISkPP2QKtx5g+u7x8eCvXma/OpuzwesjY8zxsRT2QbCAOSLuaW2CFRu501RyvEtdz/03xkpstTqVBc9zUk/fzd/JNqRtMghwRk0IQKqGMfxdsM4iCbPfs1zyJeDOPRI3rc33GS3brWCSsBBCcut8GvaibDDVnDv9kvijkKe+F/6h3JobpohueAfjLXxNkXWA+b/k2S4TeNesoaZbMZr01G2a7vDBrGG0XbbyjcD20qkBRmTZHqnxfP9GSQVhmU8cI0be4sVSsiUN4p1YWyKywgXY8VXVkAawIIOMakGpEn+wvpLnKH77GSw3vbidcrKvNiQ8Fp1fGfr0F5NqB/tia4fMF2skVR0pTIZHude1i3GrY/0DwkXYpa+WV7SfkpPblWup63fnitR1eSnOGu8n9BWI8pNJjwWneiKOirizcb0yOykYYh8wX2zsa981UuQJGxEtTR3orJgkspmuwuGwmJ2AMUMMcO6RPM4TScuMYpLft42duCXGD5pywwAwMkDVcE4YjhzACrbHhqKy9CzgX06Xl59BwwLt3W2oA5Ml9vUO285zRdRzvzpVS8//zcDz3N34FGfOP6Sh7YQnI+gmlexO/Pu7AE1Efp9k
 8K/q3mjR
 +4dHt4CcuQpmWK6JlfZwytEVv+cUSB+JLkhI/NHkXmx7jB7krSFJ0MkXXdfYmrV2A2iJ/J+AYvnyeFdCeDFbXciYcLrtW/YbHIgzNGUF5Jwne2jZX/SBxTvW5ODZMVdalVynNJGXXq1QeVhy5rw4cZVHm5YoZSkFEJiWV4fewOwJYTlnUMTaG/i2a5T/ZFET0DQfIwFtQvo0B9pEhwLngC9g6uCXqvSUTSiGW0FwUhg7CD+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a new sysfs file, 'weight', under probe directory.  Users will
be able to set the probe weight and enable the attributes only
monitoring using it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6d7e36c9e509d..b5fe036f78015 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1065,6 +1065,7 @@ static const struct kobj_type damon_sysfs_filters_ktype = {
 
 struct damon_sysfs_probe {
 	struct kobject kobj;
+	unsigned int weight;
 	struct damon_sysfs_filters *filters;
 };
 
@@ -1100,12 +1101,35 @@ static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *probe)
 	}
 }
 
+static ssize_t weight_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_probe *probe = container_of(kobj,
+			struct damon_sysfs_probe, kobj);
+
+	return sysfs_emit(buf, "%u\n", probe->weight);
+}
+
+static ssize_t weight_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_probe *probe = container_of(kobj,
+			struct damon_sysfs_probe, kobj);
+	int err = kstrtouint(buf, 0, &probe->weight);
+
+	return err ? err : count;
+}
+
 static void damon_sysfs_probe_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_probe, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_probe_weight_attr =
+		__ATTR_RW_MODE(weight, 0600);
+
 static struct attribute *damon_sysfs_probe_attrs[] = {
+	&damon_sysfs_probe_weight_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_probe);
@@ -1965,6 +1989,7 @@ static int damon_sysfs_set_probes(struct damon_ctx *ctx,
 			return -ENOMEM;
 		damon_add_probe(ctx, p);
 		sys_probe = sys_probes->probes_arr[i];
+		p->weight = sys_probe->weight;
 		err = damon_sysfs_set_probe(p, sys_probe);
 		if (err)
 			return err;
-- 
2.47.3

