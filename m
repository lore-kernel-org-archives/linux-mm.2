Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C245E674B8
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 14:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DBE16B0005; Mon, 22 Dec 2025 09:47:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17F6F6B0089; Mon, 22 Dec 2025 09:47:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0956F6B008A; Mon, 22 Dec 2025 09:47:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E8C8A6B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:47:00 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F032C033D
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:47:00 +0000 (UTC)
X-FDA: 84247384200.12.D0F7F0F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 49488C0003
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:46:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JoVRqncz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of vkuznets@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vkuznets@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766414818; a=rsa-sha256;
	cv=none;
	b=sjsC6Dm52HIBZ4HXJLVQFHfoVxP2p7HuZTvyTceT843QwMzAlqRtF+mY9qcPGW7CtjSysU
	QP79RZLv6ILIldJrRCydReB0CyYhHo7dO3XOCbNTLevvaj/UOVfP2KhzCD2IJEIt4Ba2CY
	8Pz/BTwRk1oRt18FUCNU3c8iFwj00ic=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JoVRqncz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of vkuznets@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vkuznets@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766414818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KzMGwCNuh4UKVnwrVDK9vpCeDxQ9Awa9Q60+T4do64k=;
	b=E0y+NdbRRPrQ1Wh70msS5E6wFAOTnu9sUysuJGGKvjRX1mBl+y9gJU2z1Kz1zEYPy/lzgY
	Sx5cghctaIZ0jbvCfug6iMPAIoY5kg5699ZP5dRIrEuGs8yFCdJW6U/v38ksOm0oVtXOcv
	EFFy24LlZoNo4di+/GzuKVxkJnoZbNE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766414816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KzMGwCNuh4UKVnwrVDK9vpCeDxQ9Awa9Q60+T4do64k=;
	b=JoVRqnczqra+S82kUBC/h6mUCPTzh1h9FAVBiDb7JySAugwXSuytH29Nb06vQVMH4gthvz
	tJ1S1cP7i2ZAwDp+56slEmJiDQi06G/zAzVBB1cK8A/j7d6/ItLBn1m1NhOW16i+RYAxi3
	1bo5Om8/Xg601g+MkmNNUO3EwBTWoeY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-542-w_k57mVwPxKjussPnLGOVQ-1; Mon,
 22 Dec 2025 09:46:53 -0500
X-MC-Unique: w_k57mVwPxKjussPnLGOVQ-1
X-Mimecast-MFC-AGG-ID: w_k57mVwPxKjussPnLGOVQ_1766414812
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B9A90195FD1A;
	Mon, 22 Dec 2025 14:46:50 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.224.9])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9BF53180066F;
	Mon, 22 Dec 2025 14:46:47 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Cc: Ingo Molnar <mingo@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Pradipta Banerjee <prbanerj@redhat.com>,
	Frank Liang <xiliang@redhat.com>,
	Alexander Graf <graf@amazon.com>
Subject: [PATCH] vmgenid: Remap memory as decrypted
Date: Mon, 22 Dec 2025 15:46:46 +0100
Message-ID: <20251222144646.1426256-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 49488C0003
X-Stat-Signature: jmrr5f3hkgo5ay5nzpby4o65iuxka9nt
X-HE-Tag: 1766414817-558929
X-HE-Meta: U2FsdGVkX18g6vRrvBzs3zjle5XDt7Zo/AH5mCOzOFV0oJ6VH+eH/iUji/bnsvqoT/+NpgLICUR2e7QfhOJ3mpgqjfeG5nVKS01/EOGnF4OxlH9Z0mthYCF30IgnF3sXHufcDrJEpp4EiV0L+tshAurITf1W2fL5R9iBmvZGeLeGWzk1y34LjP9VMs8VMhs2w96TTVi79VsssOrTWwuYplOhRO71i/oy59oKzF1TdcPDgN3XDZcksJiPcGSNBZIrAoRYIHMJh/Jld4iVP8oEcRy2CitSvWtrb1ughtXkDKFY/Gy715WLvxGNNWZHEq/+7gOqjk3Q1kcknJkk9rMgwkFesHCDHgndaaCF4d+bwy4Q5SVoewD+J3Bjlhyb3a6lfIBYppD0u+f62SQVdpgM7Yr/rDq5fytyXRdNiicv5gg9OxTpG+iLWVlRHwJ/xdq8GkT21McRAF0mi0xyOdgm24Tr0ZSRIh9NTYEOW/6kW9iHJdqsG74B7aMagdBz/3qMF5P32/Y45YuqzAwyGDTZIuJNsqUoliBA9+4UTpb7BwoSu7HhgO7qq8Qgju/b2pZ1mmfhI1bDyt2ABetRtFx7bUDDPS08lGXFW6GK67mFe/DA2lO5Kg0dCnFV1c/4nw4t8jX+Cwej6NT1HnxQlnjp+Lf7b4ZQVGSrlWPueDryx7c9VeJg4C49rzkZ8a1crn4+IosaY+kMk9ybwXJRJ+gjTZc5zenFtTRU05rxI3N6onOBWCVIjMFUudN0Dhf/u8LPbtVYQ30xGkOGpXGJRdhioSanY7ZdDGpOcRaoPRAzugGPqrRquELMnFturSCAcn1h57rkngz3GNvL2OnofANPZ68KVdHFCpN4xaGMgsWhJ8zx0JgeKFu/CkVmb18C9vCCcwMA/VmYuc58PIXj2uT+r2zWRGWwk4zbtyDaZYX6Fc+YkBMn/L7e2GK+sOEL6reml37XjhZDqDZs6aSAtvo
 lh19BSJQ
 B/7W2sghHQRubki/D/+bpN0p24mf0GquVlJxVU4iGTZDT97rPJDzuHl74hY6VrqRIt7MH7NjEmEvOfPO9h59YUwUUuHv6RQeLYL+HbNJKw/u/9F4ebMcqEbW0oxxwH3xeNeNbSqvYKVIKGKXyzpGj/O1lUEimt0CQIV3QDHLkTVkcCXmlwN3CQOspq0z7fKFQnzBs+6NUDOtxkWjuAD5SOGg0PV+3cxu6ss4jFLaQNgEGs+jtWKURjtK+hxvXh2bGXvfi11NQNeJ+jTXSUHtnOJTz2ptGDsZNqYSKe6cq6tRUZ2Kd9lG5C0ObYbKwwglBYVy63VDVTjCCSGo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It was found that AWS SEV-SNP enabled instances are not able to boot with
commit 81256a50aa0f ("x86/mm: Make memremap(MEMREMAP_WB) map memory as
encrypted by default") applied and the reason seems to be the vmgenid
device which requires unencrypted writeable memory.

A similar problem was previously fixed in DRM with commit
7dfede7d7edd ("drm/vmwgfx: Fix guests running with TDX/SEV").

Note, trusting vmgenid device in a Confidential VM is questionable: the
malicious host may intentionally avoid notifying the guest when a copy is
created.

Fixes: 81256a50aa0f ("x86/mm: Make memremap(MEMREMAP_WB) map memory as encrypted by default")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/virt/vmgenid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/virt/vmgenid.c b/drivers/virt/vmgenid.c
index 66135eac3abf..2cf0096aa217 100644
--- a/drivers/virt/vmgenid.c
+++ b/drivers/virt/vmgenid.c
@@ -75,7 +75,8 @@ static int vmgenid_add_acpi(struct device *dev, struct vmgenid_state *state)
 	phys_addr = (obj->package.elements[0].integer.value << 0) |
 		    (obj->package.elements[1].integer.value << 32);
 
-	virt_addr = devm_memremap(&device->dev, phys_addr, VMGENID_SIZE, MEMREMAP_WB);
+	virt_addr = devm_memremap(&device->dev, phys_addr, VMGENID_SIZE,
+				  MEMREMAP_WB | MEMREMAP_DEC);
 	if (IS_ERR(virt_addr)) {
 		ret = PTR_ERR(virt_addr);
 		goto out;
-- 
2.52.0


