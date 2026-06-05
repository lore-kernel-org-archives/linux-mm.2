Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04235CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69BEE6B0098; Fri,  5 Jun 2026 14:35:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF546B0099; Fri,  5 Jun 2026 14:35:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42A046B009B; Fri,  5 Jun 2026 14:35:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 306146B0098
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:35:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 018D08CCCD
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:27 +0000 (UTC)
X-FDA: 84846711894.13.DAD04FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6D7B3100009
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gmowAtOv;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=alS6uT4DTp+WwL7sso5ivBySgAZ17Nint0mun5DyoD4=;
	b=C9MAK5/6OgKo2WiNfs9+WEJm0GhAqwxYAWPO5R9Xptu/cckonJbBR2w7V3VD6REnvbfMDb
	ZYwl9IRRQco4xI0XDrKcAbvehQAp4NN77UZ/Sb5EGuvPShkqV70hSlZzjnk3jVmynE62Ij
	HfsH4oaWVoAHQjui2ZgCUIoO9lp0fWo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684525;
	b=EDEQjo98x6CuYFplfNeZpc/lvZAFrsRWKfkomTHFhz+Mt9QWcGwRX4eJIyj5WSV5tYJG7e
	CXiuzpSPLaz6vdm3+hr37ke5h6W+nsA6fVyuDON7llGwBPgdItjTcl+/RuL03cc8Mi/SPt
	ADWOiOGk4FnJyFMwR6sal87+nxIecKM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gmowAtOv;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A49E600AE;
	Fri,  5 Jun 2026 18:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7341F00898;
	Fri,  5 Jun 2026 18:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684524;
	bh=alS6uT4DTp+WwL7sso5ivBySgAZ17Nint0mun5DyoD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gmowAtOvxTzKu9ncHNPpRCnzGA8aVRacUBa9izDlXmH8W4c2eEeVmTQbE3rGtjedw
	 9ua31Na8GiOZ1dansxYyc4ww00X4kERyhigsjMj//6tPpR1dT8ta5FAYuC9rLTEbY6
	 clH238G1imQE2lF4pz4yqmu2Olzn6gfL3cS4YKiSBIBQxOkulAuY7RUm42r8PIKhIl
	 AWQ4DPyn4eD0GIIoepvbCSkRashG4zd8VlKWBU/q5j/RtQ430n6KVgFAiCgEclekwd
	 +GSPWHJEw/TboqaF5GTuSVNhantMko73vA//MVGrF5uImhBihA8fQztwHqDoFvqgWB
	 zbxK+H2/vhaqQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/18] kho: move all memory retrieval logic to kho_mem_retrieve()
Date: Fri,  5 Jun 2026 20:34:38 +0200
Message-ID: <20260605183501.3884950-6-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6D7B3100009
X-Stat-Signature: uo7ryoxdppbrm5pjkprgg58no6dzq5cr
X-HE-Tag: 1780684525-903351
X-HE-Meta: U2FsdGVkX194SCzQpW6BTt/seU71cVAG40tmG+5nM2S+yLf605WjGT9AGIlAc5+tZJsoxuI6blNDnQWrfz+3pEARUFVediup4CElBTjjECSQHYeXt1ZdS7VdkGRym3ct16f/T7nSAi69iyeMCV8w+DbaxI/g/jVslR+1fXCRjcUNY17nvNrFd8FTZrFGfI8Og7IoIRvvB+qjnyPPcHIRzJ/TeDMUlGLATn32czXFgkQa0Ew0OuAczCvs+vqgxzBezt7iQleeFHuGpGCog+RSXlGJ5N61OIgn6xVJZZ+b/WBOxnvx8vYZjySAu1xiwyX4dFjaVSBFkFjy8h1FRz4pTzNKnIl78lHKWSU9Np8g99S3uHA/8gTD9RuskLINAF444wXevgHV++VjqrI5S8kzjl2DExjyyA9inx4XNBs5Ng+5sEH2KheA3ew7WYp2HAxG27dNz74wHWekMAS04uCRfPVirQr2j70KBT4zI9oSR1APjiU7gdjxK33WpDcD49+jMtwPwMviPZ8jLwnM9T3fYzYQyqabZASNeg3bUMhf9xWK1Sc/lvVXrAKz2ue6KUdwExRqX92FNbAB1BaqmXCuuLGjjLM9Qa/+SPH4yiDK3I4m3le7bdyS9t1lox6DcDkXY5ksoX91eGe4Pfbbj4Qdutl8CANAZAZsGgzeAjcKnJNMsQDkniTemVo5vK4QI3A8FHLdniM8Pre6q5rJyWGHm/rAyQ8jsc87YJnScfnCBUOV2UgHsWo9WZATV6nS4DHkfQt3cUo1qS2MKqrNhXxxeemFVF5W8Mdz63onzYfnb9u6F1atMIEnON6FHlBV2AnI/oJ11S9qpkyc3/D91bku8qWxrcPI+GECjQkmnV3EOFdPtoHIgYRE5AvzYcDYAgLKKCLvBczpSIoGk2qBG3nh2gjqOv4XZtkIk6JmqGeat5Gaenj43z2ZpP9u7Caa/H00oRyo0k4rQjMAJyxDfhU
 2i9x684Y
 27pmKnKtbfEymKONi1dH1LlkyIl74aYhhGWuJ3TnIW+Nm04vyibjewOSg1HcG6Fde2q2JFOobKCJ+u1EnT8j9pSPMmJ2AIjvpDmpAcNRHfqrlNHLkmPPwKcj+w35uKbC8pZWBv88xNPHSlEIZmyPeRWX6FEV56XVPMOA5E85VBulRso7T1IzYMVOQiidK3WaX4adLKRQMXtUh0aTneAygresUjKPedrJG/LBUfbhfUWK3LKxjb//BjjCLCRBGQvEL9HR2wBLMxnBEAIPkya4gJEdK0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The memory retrieval logic is spread out across kho_mem_retrieve() and
kho_memory_init(). The incoming scratch area is initialized at
kho_memory_init(), and the error handling is done there too.

Consolidate all this logic into kho_mem_retrieve() to make the code
cleaner.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 31 ++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 61e436f5077e..7e556afae283 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1412,8 +1412,13 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size)
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
-static int __init kho_mem_retrieve(const void *fdt)
+static void __init kho_mem_retrieve(void)
 {
+	const void *fdt = kho_get_fdt();
+	int err;
+
+	kho_scratch = phys_to_virt(kho_in.scratch_phys);
+
 	/*
 	 * kho_get_mem_map() should always succeed. If it fails, kho_populate()
 	 * catches that and never sets kho_in.scratch_phys, which stops memory
@@ -1421,8 +1426,16 @@ static int __init kho_mem_retrieve(const void *fdt)
 	 */
 	kho_in.radix_tree.root = kho_get_mem_map(fdt);
 	mutex_init(&kho_in.radix_tree.lock);
-	return kho_radix_walk_tree(&kho_in.radix_tree,
-				   kho_preserved_memory_reserve);
+
+	err = kho_radix_walk_tree(&kho_in.radix_tree, kho_preserved_memory_reserve);
+	if (err) {
+		/*
+		 * Failed to initialize preserved memory. Clear FDT and radix
+		 * so KHO users don't treat it as a KHO boot.
+		 */
+		kho_in.fdt_phys = 0;
+		kho_in.radix_tree.root = NULL;
+	}
 }
 
 static __init int kho_out_fdt_setup(void)
@@ -1626,16 +1639,10 @@ fs_initcall(kho_init);
 
 void __init kho_memory_init(void)
 {
-	if (kho_in.scratch_phys) {
-		kho_scratch = phys_to_virt(kho_in.scratch_phys);
-
-		if (kho_mem_retrieve(kho_get_fdt())) {
-			kho_in.fdt_phys = 0;
-			kho_in.radix_tree.root = NULL;
-		}
-	} else {
+	if (kho_in.scratch_phys)
+		kho_mem_retrieve();
+	else
 		kho_reserve_scratch();
-	}
 }
 
 void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
-- 
2.54.0.1032.g2f8565e1d1-goog


