Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C3D0109446B
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 10:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC7F76B009D; Sat, 21 Mar 2026 06:57:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78D26B00A1; Sat, 21 Mar 2026 06:57:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8E756B00A2; Sat, 21 Mar 2026 06:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B8736B009D
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:57:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E209C1ABD
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:57:44 +0000 (UTC)
X-FDA: 84569769648.26.81FE6B3
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6DABD40008
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:57:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=smail.nju.edu.cn header.s=iohv2404 header.b=omkRl74L;
	spf=pass (imf11.hostedemail.com: domain of kexinsun@smail.nju.edu.cn designates 54.92.39.34 as permitted sender) smtp.mailfrom=kexinsun@smail.nju.edu.cn;
	dmarc=pass (policy=reject) header.from=smail.nju.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774090662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TJKZtWiprgUspY4RNaw1d9jTovs7Pv0dIVGo3CDvBTg=;
	b=UALj0zC/UIzR8pHBf4vm2GLnL3OqoB6aKbTxC7QkFT9QX75MnDOsA5743NTgBSajDPw5DS
	mS6gge8VKwYlcWYccMq9x0PCVIsoVfppTHiBpstwJdpHzIR9dJg5QNZ4xJ3N1oxg0x3qmo
	stek/twpWFaj5TK8Kegy0c5TaEwvGOE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774090662; a=rsa-sha256;
	cv=none;
	b=4d5H2J+CEBPmwbIqwZlDb6B6BK5UCYO/TDRqVcCuA5Gkw+V1ErRi/YdWTf616SfWxqflRw
	2XUvwKLsKll7owWvzK5CrM9bsMmt7OA3jqbRaiO5EikLmHrmI5JNU1NVTW66C1BlxlS1/n
	OCr7yIQX4Ap/Sek058CWYj1sfgoIQbw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=smail.nju.edu.cn header.s=iohv2404 header.b=omkRl74L;
	spf=pass (imf11.hostedemail.com: domain of kexinsun@smail.nju.edu.cn designates 54.92.39.34 as permitted sender) smtp.mailfrom=kexinsun@smail.nju.edu.cn;
	dmarc=pass (policy=reject) header.from=smail.nju.edu.cn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1774090629;
	bh=TJKZtWiprgUspY4RNaw1d9jTovs7Pv0dIVGo3CDvBTg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=omkRl74L9BnJ+syWg1rrYKy7TuMZlDspPBFpAszf+Zk8obRbGAlX6chTIfe8cifA2
	 4ipUxhZQ2Vj4jDg6S8KJb0ToAH9pM6Ng9yAx/Cu7afp7+VKhxPjxnywTqe9zX6+6SC
	 SU4WH+iSfkHs8XZUVngdMwXZHy1/bcmkMZ4hIC1E=
X-QQ-mid: esmtpsz21t1774090627t30d284b7
X-QQ-Originating-IP: AQ19W+u9FUPANAVegDK9vd8HUPQnUE5SAnb8ksdr+Z8=
Received: from localhost.localdomain ( [116.172.93.199])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 21 Mar 2026 18:57:04 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 2755794152099023227
EX-QQ-RecipientCnt: 14
From: Kexin Sun <kexinsun@smail.nju.edu.cn>
To: david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: julia.lawall@inria.fr,
	xutong.ma@inria.fr,
	kexinsun@smail.nju.edu.cn,
	yunbolyu@smu.edu.sg,
	ratnadiraw@smu.edu.sg
Subject: [PATCH] drivers/base/memory: fix stale reference to memory_block_add_nid()
Date: Sat, 21 Mar 2026 18:57:04 +0800
Message-Id: <20260321105704.6093-1-kexinsun@smail.nju.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:smail.nju.edu.cn:qybglogicsvrgz:qybglogicsvrgz5b-0
X-QQ-XMAILINFO: M+Q6fuWNcK3qxaTfR/EjiLvlNn+SojSLtfYIRYWpvmnVf46LZVbR7cd6
	2h6EuqnnXrMJu9B5AjSCL94RGDYajEF+90vMPPHcF5tyRtNmfWVBedCC/G3PoAn3G9CmKmL
	uSsuOIGo7KFSEF75vcfokM+Rm/Nu0DcnCyZM9MFhTN8LqD/7brIVypvk1BOSOD/XPNViybA
	jGCkDNNVKXN4bWPLTVegdgHnZVIKscDEjUOvJ/RJKbVJQsDumdxK15yjgG9ajcoJHo+NU/D
	/NKhDPJAXTcEDV5bUUcuBj5ZzRDZ6w5tI7KVZUBezhlny8sTHzukPDKCwY9BhZXKXUOw+LH
	2HDbobROoRmQtvnee3/0F906GDG1FMwNrYPREvFel29SLcZD0DdNKObdvMF9+/XDMyAjuRW
	Un/+yWh6zW/lZIeHx1iCzxMEWJ70Y8yS1YvY4SrUaivW0XwL/AIGJBguUrzpiWUX/kY56lf
	YM3Qc1155Fw2qlpCbXw1ed7y1lYx1PX6ZMTWJ9jq/8zgMkWJEGF+j5Q7SI5KyprhWU5rB99
	kOq6IetHFI7Myecjfc46HGMe1PLCy+Ci5j8R5tS9dyGlhaA6b4JIemG2CYUpdl7bAg15cMN
	10A8/j8SLNzACz3jJdsw/mYz7hbMX2CMMY19JZsl2FAdVwynwmNMg91SzA/My1CNv/OHY4N
	JedFqzDUMAs1V45kjHV/enQTheXcN+ZpJKzcL1Vgv7CbKiq+4wF5uS5euv5henVELH9sNsa
	ELEjzZfAwdH8jwyhlAAmGzKRL7wUiCr0hgnm6tSaye1alD1dedx4aIo7jpw7qY/P7M4o7tE
	zQ1CT2icxAEE61b0IddO7vnlPmmO9AMZqbNkAMd9QK/8C6QifREiVx+ier7hOyvZvGei4Cv
	iCRk0WjHr9rscB7aC4fvGWedY0RG8WYVbSe1uMHrfH5FUU1tLxEBG9fI7cZ3hJwdY4v8X/E
	URR0Z271wAT5atE8bdYV6yumQSnTXi7B+CTCtOLpwKYvfkwocPtLxyPxmdEVKsvPs8YMIbl
	csjiNup8AtZXr9Upld8eMslSpOVoR5P9muefSo1JnTE2vZNBL+CpVVH6ZMTaWkqpMGpjniO
	w==
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: ge11ba7hdkx3k3dfhgwszziwbsb1z9tj
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DABD40008
X-Rspamd-Server: rspam12
X-HE-Tag: 1774090658-16893
X-HE-Meta: U2FsdGVkX1/Umf7Bh/bME1LQfAmRmZVe/NZ2Wcm44/dAEB2NelqzbYK2/Za9RqDedGMGW7F1x0SUY9O4uPufO87wsUigOV84+PbGvrkoU8uZylr+lJkozjNuKz/GXcXzJbcrsoDy9yJbmCcrr4VGWpvFKRMDnk+Ma0+b69eE3N79flU1p6EQ1aPZoRfRfjOgqlrcWidBAbYdm5jxPP0aEDh9pS6O1mYdLPLTPQgs/cn73/9gGjLys9joeT1qqYXAxhVwDv77lhd/1tS8s/TAYjzUJKIE13Qid/fAYQ5cGGrQpMYr/LA5/Uw6iFU/qve5sLbKTKbEszt3DFRl8wdTc2vPoMq5NsYi6IJ/FzmzmF7DH1d+CbxgU3ugfPfhOKmX1OIKBBRJmq1lQlQzKSTXf1T/X/5db1kJN4BHugPF8rgxPfkYJFvXwD29ta++fS1CILV3OpF7Ir8morJzijUSVPdfif6IN0tAd0N6tlGLP37rrFK1vJ0qWy6WFj/VSyXAskc0JccEXGmvcJP9GjlJC6bIUB4VArQp98lp8xtqsQ1WqykExaP+K7WpKJkGrfpNdp1CtY8bXxrLh5m470Kh6LPvc3RAqnXXy9geWPYzZEIYYjALPCkfj9iSKSnaol0eBKVITEdTdzTiYHud2I2e7brVF+88CHsvijcKtILxU1p1JbxQHAnWtKlvS0SA126ttj67MPEsyo7tbueKL6IDOI50ADDkKkvm+F+rBYNHHZ0bGOeibOXRRk0BNqHjc8Ys4zh1l8RE+o/VJ+HcWbkx7q1hQ2l1c5drgHGFjhsGP2k5dErsZF7//lZhQW4g8Z0KxI3mvg/0DA64T09i5wxRc44MZyEVQjTSfzd0XmmyRh2DRrf0EFjlud4eJR4ssgvKwq1LZ6+mSow7O0pnN4WNYmqKKk2hgOaLvkh6HGNP1udtwneraoYkZVCUDFFFEO+UoQAWYMRPHDfKDgQOIrZ
 +SN8MaL6
 xtwoTj5JKKuqubZeqwYxNYOMw7cDXFQImMVNgMvfi3jmM5ejHp7ZXX5eW+XMFbMoVuUz+7sX7ksXTni/QIT/31ePG3BVPVl3qANXlMUjAPtHo5IPYdkI+psX+8H/R6KsSdFp6RGKoexW16feWpwOoiri4NhSTFSq6HlGGwXrmLltoLOkwk57AjU7o5OOXtIfYLJffW1AiLEVq1RLA5MNGlYMIOrcwxGIy7b31uaUjr1YtM8zERhQanwHeEHrtC4/Cx/ksARxDtHkihlhmjqR5WvsgXsr9PMpsogxZ8tEP5uwUJKwDh+6TljFlMoP0RbpEGlam0bPfnHy7M5OPluZgB22sT3WJNUZ91+ih
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function memory_block_add_nid() was renamed to
memory_block_add_nid_early() by commit 0a947c14e48c
("drivers/base: move memory_block_add_nid() into the
caller").  Update the stale reference in add_memory_block().

Assisted-by: unnamed:deepseek-v3.2 coccinelle
Signed-off-by: Kexin Sun <kexinsun@smail.nju.edu.cn>
---
 drivers/base/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index a3091924918b..0d6ccc7cdf05 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -815,7 +815,7 @@ static int add_memory_block(unsigned long block_id, int nid, unsigned long state
 		/*
 		 * MEM_ONLINE at this point implies early memory. With NUMA,
 		 * we'll determine the zone when setting the node id via
-		 * memory_block_add_nid(). Memory hotplug updated the zone
+		 * memory_block_add_nid_early(). Memory hotplug updated the zone
 		 * manually when memory onlining/offlining succeeds.
 		 */
 		mem->zone = early_node_zone_for_memory_block(mem, NUMA_NO_NODE);
-- 
2.25.1


