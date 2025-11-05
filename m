Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71123CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 10:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D05938E000B; Wed,  5 Nov 2025 05:20:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB6438E0003; Wed,  5 Nov 2025 05:20:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB9C8E000B; Wed,  5 Nov 2025 05:20:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A706B8E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 05:20:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5BDC51A0281
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:20:48 +0000 (UTC)
X-FDA: 84076159776.02.CADE857
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B556D40007
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:20:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WE37hOhQ;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762338045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8rAQbHFDbivgcpxLCDF/vP/CPRZRLVftucEUjeFRHHI=;
	b=Bo2pqKiwqyuUgBTG14RtNUE3hHKITWPNIR/EBdfSno9tq/VgBe0afNKXU9/SIct4WGaNfS
	n11rZ0eQBiE35a/BJHde1AOtpxZWX7MqQUhPq4KQ4qisbJC8DDqW11dn0KGGo/K2oU79Av
	VnJIY5BqITRg3fTa4v+90KApY/CQO2Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WE37hOhQ;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762338045; a=rsa-sha256;
	cv=none;
	b=RfbmSDarrqI0XJgCwBlha1pkf2OhFp1RcE8uT43cRjNBFI+Qil7xUPdkHQNWi9TMWlHawP
	cgO5AojyZNp+cCZUzT5clQmCKqwc3RKLRw9LcBMY4oq0eKh7VpGKMa+k3OlnfcNSz25bU+
	Fx57DAmNQIb1/17+rBhrAJ024lGRSdo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AA271401C5;
	Wed,  5 Nov 2025 10:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A592C4CEF8;
	Wed,  5 Nov 2025 10:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762338044;
	bh=6FveslA51ZKW3pLjQVKvZG5cxo/vtJS7IwDZAhcHSHU=;
	h=From:To:Cc:Subject:Date:From;
	b=WE37hOhQUGONWW1HuZkGx/QwivLViWcVBLBYY7/qI62GihtTnJ9iPrGkLCmPvhzzh
	 26BHCN7CVQSdC7Yoh5rvDVmfRgel3Ue4Kcmnq6ouHGs3jqTLiwSy6lx05mC/VczSH8
	 xS5KKvCDr3xEu501VMCArrdxnIExC5RMIjJaX6A5dTz2tIpTBrTr3vCxi/Klqcn7g6
	 PlK6acReLoZ9lL69NZfkqaPajZjqyKKkMi0cyrqkUxa7vbZrRwZZmMRQfdNkxC4Y8d
	 9gEvPs3K28qPrsaIfWmSofFO669wrl33Ul+L0+nXvdEHJWFCBTOMlgScd72ALGmGVi
	 n9cBKMI/WK3EQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add myself as a reviewer for KHO
Date: Wed,  5 Nov 2025 11:20:19 +0100
Message-ID: <20251105102022.18798-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B556D40007
X-Stat-Signature: yqt4ffb7htkmtgwr4w18wm636h6j8f1d
X-Rspam-User: 
X-HE-Tag: 1762338045-938904
X-HE-Meta: U2FsdGVkX18vG7IoI+oO6zVi2yyc/ebjZcucoTdJW7SFqE+YOHg7g927PXvI6dDx5+HUpefsOKACFAyp0sgFi7g2cOd8aH3jPgpvJHc9eWaSmsshHmk4F9xeYj8rmUAr1JLSAbqsR/xjqHjXb1MsncxIKRLEUt9kjTTkhiQd+p1tXN8dveyIDEUf3NaBl2hLxdkLuiEqvs3JpShUwrENhMieK/RpBbL9nEU4aozF4gw+YWXtRHp93oVHriVm32uQ1hjs2cGQZ830Vj9Bt2ucAuHR5QQ5TJP0wgYX4XC0FHwGLYNCYwzAWfHDfd6vWZmfPSIMXwH2eVO1mdHnYd7w5jm0y1lKd5V3SDgC58tGr2x7pkuR2dynnfkoCI/vedGiYblWZSDSl5uAhWbJGs+9udGQMrEt4rf4BatXdwDuUtQpP/4gf/+8JnA9uYTH5k0rB+gd3wN6OAYTtqRAekJYJBnRXP9C8CodT+CCUth8BlGWJd7PUV13XNyzhdsvSHGJHpYdYZTH+/knTx9uIzw1CKpeYdOxGGgw3KwIQs23gpqJivHnXQ2uupeSnHmDICduJZtGnZ5PGfc4y/eLKybwAUO8AcL6fdeyH0PCkFzYmh1QkDpCL/zq5cBKdvuLo4VuWUM0GVVUeXrhUfpdpMCbEMo21SdHncJHttiWuZolUbXxm5TVpHcAU4bVCGriIvDKQo9YTHB0dR4uKO0TG0nVZRt6+ZTC+brDk2vaubc99zFYnJfyIdSylNqVOhyF8z/PFJfn3Xp+GAL7t6+PW+f+XOX+/T9Rsw+DsaGCaQO7oNkpsr+zkdgTPO2CXIWJlbxxOXv/mU/Aqmft293AzSY4KGPQ0FIaIisABMVZFMHmZYm5C2kj88GGuZNg4vki/t0jrLrEsL522DJe8gihLuRSjA5GqK6vMujyW5hDzjUEtZQQFiA9d733+BKesMk4IKhKX5zmdcNNJrKKq0Z7E6l
 Cic+vl3W
 tF/3TfeQKMf//o/Jfu+xXb92MD4YWcl2LB/hxoAhw++jgL6kF9cwSfWOFWI4gdf0zC7UiQD1s+EHotJyIqguImSmesHYCQ431h4vm8uvqnpFBxC/uAuAIAn/QvYBe4M56tIGPraGgekBfGJo/V967XFJiZQty/u9zddI2PAYJT+no4Bi0uXoegWv4wCsi1i1ZsgbcIB3pnkTT4A7qY1v53xyKBYJr8dMNCdcDinoY+NpazH6CW6Tj2gPGECGeVTT5em9qk7ygO7cqsSdZrwj8zuGBN4D1hu3ZtrFdY2LxdHmA8rHphVXZ1ogDNtpi03UGEOT7XEXHq+I1r1q9UpJfiVH76zy0CxyaYhrQDVb8DPPNoWrY0MYzcRxQaQbyJatUXXNdFrgpxgijyC20NlgzNFeu3vMDU4Efx3IfikHh5K75JOym6yJ9LoGJuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I have been reviewing most patches for KHO already, and it is easier to
spot them if I am directly in Cc.

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8ee7cb5fe838f..3c85bb0e381fc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13789,6 +13789,7 @@ KEXEC HANDOVER (KHO)
 M:	Alexander Graf <graf@amazon.com>
 M:	Mike Rapoport <rppt@kernel.org>
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+R:	Pratyush Yadav <pratyush@kernel.org>
 L:	kexec@lists.infradead.org
 L:	linux-mm@kvack.org
 S:	Maintained

base-commit: d25eefc46daf21bd1ebbc699f0ffd7fe11d92296
-- 
2.47.3


