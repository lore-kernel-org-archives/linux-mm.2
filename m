Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F694CD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:36:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 255686B0093; Mon, 18 May 2026 05:36:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22D496B0095; Mon, 18 May 2026 05:36:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143E86B0096; Mon, 18 May 2026 05:36:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F36886B0093
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:36:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B690DC2B4F
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:47 +0000 (UTC)
X-FDA: 84780036054.29.7FD1412
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 063A920007
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YxzilP2P;
	spf=pass (imf13.hostedemail.com: domain of 3rN0KagkKCOkeLcfYdLSfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--tarunsahu.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3rN0KagkKCOkeLcfYdLSfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jv7htWRaexdWX7r0/O/5aQjJsBEQgyvtoCI5ugM9CJs=;
	b=au5lcBNrNe7eTjwJn5w3cRs379yBskjXhqazkTOMhIzMGymU89+i7DHmK+a0GNPJhxAK+u
	cAg7uKB5EBs3WIZjYUvIRLnBKiRx7oz8N66n9RLm3+Dxfy+VCm94ryWZcBQy+Xh4NBF/Ro
	drO4K0jlxCr1Tw4NOVCl10O1gmAW8B0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YxzilP2P;
	spf=pass (imf13.hostedemail.com: domain of 3rN0KagkKCOkeLcfYdLSfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--tarunsahu.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3rN0KagkKCOkeLcfYdLSfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097006; a=rsa-sha256;
	cv=none;
	b=2M6YFKAO2N2EanXB7yUL3AfZw4rO3lEfJOkBB1RBa1oQrIBU1OUXf4vuj3vG6xDWWHkdTH
	dWUbwmNSnkKktdetTKtBfaIMHKzpnsKwVMNbdngMYbOmNQOVhUMv/qRWxO8ls3UD991v9W
	WVR7eus/fwx5vokhRGpNJdBGIiCVQmo=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43d7a5b9678so1307610f8f.2
        for <linux-mm@kvack.org>; Mon, 18 May 2026 02:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779097004; x=1779701804; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jv7htWRaexdWX7r0/O/5aQjJsBEQgyvtoCI5ugM9CJs=;
        b=YxzilP2P10LEbCNdtDmer24kaPuHzNChKSKHf3BN+0t8E9A+3pnJzv7koRw/X2ISfV
         9ECCXXj5DNAHIw1PFVck4S/389RiEwQkdrkMcGoLcOLt7QVU/3SiRaS510OyXm7bkIXi
         w35ZIowzToPqe2ch+gTf3vRubhfC61Q4hd49JpjQgtTHbIbasGiAJCnVIrN0+/Z54UDh
         5lUSaJ32dWNBj+7tdlIxy14OcO+dOsMHw9VgzyPm/+z/n3tUDo93UHMREy7o90p4JmEd
         BITfddkWNksT47pWxPKexaH9B7j1oed37MQmQEv4/KjJ0OXnh8r7l+ufoajisC+Pnxhd
         UjAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779097004; x=1779701804;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jv7htWRaexdWX7r0/O/5aQjJsBEQgyvtoCI5ugM9CJs=;
        b=I6Nc/Sdr12qj+2sshUZ30oTiMi8Kcwv63zRL7Q78Tf0HpN8F/e+AQrSj/1mf54y1Di
         PXRx9x/VtTpEPCei0qQRmVYlW84cI+e0j2Xp4gSQKezmMqRl+2VExyYW53x46CKxUTbR
         YaoqJh3xT7vHTIjCjXYn0x59zL5CQVUsuGYgDS9Jki9RIFCJq11oGW1K/0mh/l2NM/OL
         KF86L+VNAYzITwTFNbWm8jOD+124G2HUX1PQkgLAoL1s8RufjiHvr7lHzn4hNK2Fguwc
         5LFFpTrfpNdEIlrR5S4J3d2RlervccbNLOA08dFkAAzWY9kSk6uSwtU6hTyXZ45rr5VA
         wVUA==
X-Forwarded-Encrypted: i=1; AFNElJ8qpRrm2eR2ZXbbdiAODpqr1MH8QbIquvCNHG9+VFlt5nhxGJwkTOiPw3Uaa4ETIoVQTp7JtG76Zg==@kvack.org
X-Gm-Message-State: AOJu0Ywk7Nv1aMvSd4NMKN8W/i868NN93Uqr7AkH/wjKQGC+enE/RBJI
	y82/NeQBuEfPiXsmp3tICIrWJ8VkFNGCjSegM1mZm7W7zEFOkWCOF5ffMCB7mR012w9M/PoFGp8
	QEa1lAPRSZUyRz+t5Bg==
X-Received: from wrmj10.prod.google.com ([2002:adf:e50a:0:b0:44c:111d:990b])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b6e:b0:48a:6fd4:d3d3 with SMTP id 5b1f17b1804b1-48fe61ed21amr229120015e9.20.1779097004324;
 Mon, 18 May 2026 02:36:44 -0700 (PDT)
Date: Mon, 18 May 2026 09:36:32 +0000
In-Reply-To: <cover.1779080766.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1779080766.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <63776195da42f3307cfa0ad9ee7aa5504e4c2cb1.1779080766.git.tarunsahu@google.com>
Subject: [RFC PATCH v1 2/9] liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
From: Tarun Sahu <tarunsahu@google.com>
To: axelrasmussen@google.com, mark.rutland@arm.com, skhawaja@google.com, 
	Mike Rapoport <rppt@kernel.org>, sagis@google.com, Jason Gunthorpe <jgg@ziepe.ca>, 
	Shuah Khan <shuah@kernel.org>, ackerleytng@google.com, corbet@lwn.net, 
	dmatlack@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, vannapurve@google.com, 
	Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, aneesh.kumar@kernel.org, 
	vipinsh@google.com, Alexander Graf <graf@amazon.com>, David Hildenbrand <david@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kexec@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 063A920007
X-Stat-Signature: nahjkoufrhn5j5zudu6y95wx4xtw44sx
X-HE-Tag: 1779097005-877908
X-HE-Meta: U2FsdGVkX19jKndGM0ePJykenuwpaze2LTJxJm7VCy5dl/ESGqmLFFeXzM1rvxwtTtGarO4ZBQkCdCADlr3epaAWoMfN8QP8cpUkl8h7dczEy3fTif1BOaK4rzjEHj4O3iSusCfHxe8Y7vSQDcS0ffyGYrNndpw/uIzEymuifFv2c4L/H8cJPgli0Q6+cBy53cY5vw6BE3BLf0/FZF4COBl86rjzuLpngLpACkLbh7bZv3I3rubpmZaVI3CTWyTPVOaNV6trL9vMgnbKgfZCfHGPZXLt9NO3IdCJvrD/7nC0zGotb9voCvH5SjlqID7d05XNQ7bjoBsJ0XDMsTsxSISVDBiFLngXOU8ie10SGxP4KcZV8SArdFcq2rucwUAg3XISeqn6Gsi5AZkfBv1yUC1tswBmrJBb80aDbf4i3ij7ofkS4m4e5JWl2zo1dvQjvJ2vYqwZM35BUXb8xkUWTsxVlNoTRG5sEv72hDsOeNIpqyYYEl3PTT0tEq2XN450HYpbdB2AmEHQJdXCJiSYmXMdqWZcjhOu+eOv4Gu4gaygQydZNx4tFp6b0UvslC2X/ppnGw2Rqlp+ofD4kX33vet6pv7y2Irc1YqyVnfw5bmJsk0ecjY3j5/5qE9152wsFlnJCVLXdoXAd2QS6qpqGwgQSX+HaVHD7i4gaOuuIC3vKzDXHPEQZ2TA5vOktzqMWd1cF+3DNsa2iLGmDLXENYrVBQnqj7FRWIL628t/1g84VApKfuevvfDfs+G2V3hR0FUFc5KlLKCBaCSx2490HT7UMBV8BIdX/QOv+lMohxXZa01Wa1CtZ5Y01n2/Laa3ck39ngOE35puBV77MvRCeDjZSVKGSC0vZiZs0eHB/7mZfGEQ1mGdnH+D5EZPIQOHz78t7zaNN+r4tLzlmz6PxmIgumYO/VKQWs6c57jISJM4a3AWAJ04ASrQ0OvZyanMlZPAHnsGRajp13V/ELo
 lcDqI9Eo
 /LoG5KpkNLcKsIONK7TOy0tufjpVbn/0yKfygrvQlFqD83bhSmd9MXDvLgr9ne9L92ZGUxcLBBc+FULqEMux217qJpaubdl89urhwHrxQvx0nNn/R6RnIKybEa9x2CiX4s06t0KUVhRtQe9zYSG5/9r6KUbLbjV50fnC5almJmJgqBkL9owFiyeThLr56fsNy1x/3Y3c/Bvmfsvp/SWyiE7zyOcSiGonSTRWygMylsnv0WMEdjrVkmIBoL0ZgURv5k4OUMdRAAZEoWkzuab9HCagQGcDOHjuEZJ8eahnk+Dpy1IhiQOfqozR30go8XURCpdeKOrUG/yjkxlHKjFxc6QB4lRCJeMQGgbZN1dS4ZhwJJbE+3KbUdT8B1ePUDSxKs7pYl8QbDBFfafQNE18Y9t0tQjvN2/ocIf+4cxEXG7CqagMCF50dKHysQEif7SIPe5a771aOAlPMOvU7CmEKaRONisV7aCcGJO7VsIvZj7yiZr1tF7k6/NV5FmFGspbX0UI/oFw4SuiHkCiM1fCg8l5Uvd04I0JLovdWoyiRpgEP4g4lmwscLNmFaLFzs9r7jS1foEz5RmlC/CM1Z9UM5w4PhPbNGFvDSE+wGyHdG1EOIh4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the LIVEUPDATE_GUEST_MEMFD Kconfig option. This option
enables live update support for KVM guest_memfd files, enabling
guest_memfd-backed memory preservation across kernel upgrades.

Currently this support only guest_memfd files that are full-shared
and pre-faulted.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 kernel/liveupdate/Kconfig | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index 1a8513f16ef7..0bbc4037192e 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -88,4 +88,19 @@ config LIVEUPDATE_MEMFD
 
 	  If unsure, say N.
 
+config LIVEUPDATE_GUEST_MEMFD
+	bool "Live update support for guest_memfd"
+	depends on LIVEUPDATE
+	depends on KVM_GUEST_MEMFD
+	default LIVEUPDATE
+	help
+	  Enable live update support for KVM guest_memfd files. This allows
+	  preserving VM Memory backed by guest_memfd file across kernel live
+	  updates.
+
+	  This can only be used for the guest_memfd that are fully-shared
+	  and pre-faulted.
+
+	  If unsure, say N.
+
 endmenu
-- 
2.54.0.563.g4f69b47b94-goog


