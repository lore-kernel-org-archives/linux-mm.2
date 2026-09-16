Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65BDEC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 05:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DFFF6B0093; Wed, 16 Sep 2026 01:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B8166B0095; Wed, 16 Sep 2026 01:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A6FE6B0096; Wed, 16 Sep 2026 01:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 44C946B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:06:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B48E1A0606
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:05:59 +0000 (UTC)
X-FDA: 85218438438.25.EFC8716
Received: from mail-qv1-f98.google.com (mail-qv1-f98.google.com [209.85.219.98])
	by imf27.hostedemail.com (Postfix) with ESMTP id 46B5740006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:05:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b="e01/Pg2I";
	dmarc=pass (policy=reject) header.from=broadcom.com;
	spf=pass (imf27.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.219.98 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789535157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6awU6L1NSAdZve1Go4DAFmiBVEoVbQdcfNtuUS9ma4s=;
	b=3bwNbPGHDAtpHCnHx9QagWzGQbLYTWRXZV3fCp6ZNQ/isUz2eoDmKZnvv6s/8m9Ja08bGx
	c8wN2uRDxshBtqE7EWzqV6TRabFbgnNwDEd9C8LvVvIc0VfHsAtXgSQhNWKm5ZRK5RjHqp
	iM7hslFocvpltIy7n3+x/hkeH05djh4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789535157;
	b=ajecWTMWJ/jDdBZ/Yfwg8HH2L0X42pTzPx6t3ABqXdZdnAVCHSvD9jtyX4R/FT8Thi2mMH
	fX8U+xI5Z9tggYCkh7ZI9HwVqGkwXIO9GkhYqDPcftaA3iN0FCbLNEVzeoCk38zWWJPkeH
	NyJmY8sgLaVzvIMbdCKQvt5rc7KArKw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b="e01/Pg2I";
	dmarc=pass (policy=reject) header.from=broadcom.com;
	spf=pass (imf27.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.219.98 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com
Received: by mail-qv1-f98.google.com with SMTP id 6a1803df08f44-90f9f8553e0so16279686d6.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:05:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789535156; x=1790139956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6awU6L1NSAdZve1Go4DAFmiBVEoVbQdcfNtuUS9ma4s=;
        b=HClSMc7kkJqfLoPecTtLSv4OB11WgPnKwcFXPWbcclJwLVP60Yz1QnEeTojlIxbKnX
         21wAuNUTVwbeMOFKnt0id+Q9AiF21FBumd0D+h7KfsNDY0yQuMTWIfJvxkrQYJCWpQX4
         fHfv+nsOz/c46hb0lvLp3SZ0W5ejPFcEKqjXkf0YegDGYg/v64whCayE2T4t+u/H8+CE
         +vuzOx/YmCoJ/qESCmnsk9XxauQ3yrEh/Y1gKz5vwALq3xxEfnnST9BXV+IySUMSuINb
         vyIpDCtmNvXEUlITQXqDVvTNlQD76OnluEU8YPSb7KLnpfXREwy6R/v9ahvbeElo6BMC
         /rnA==
X-Forwarded-Encrypted: i=1; AKwUvBwa+vwHt8l+4rlJHIxIY0BvxevGKXRAa14AqWVN1qmbhpK3EwkqmPiN0XyBj1Fud7AGD+WvswojXA==@kvack.org
X-Gm-Message-State: AFuF++k4Y1MRmjVSYJqlhzDQ9ipJx0Z200RmQFixaNsCcYko32yujL/E
	YILbStsUlESroHBGvC/mb4EjSlIHrowKY0kZJDGLPAPk/Lc9lrEhRoHTlRBefHDe8NG86Q6kvee
	1Uve+MzC91jLZh3l3q6kI4346bNA0uEWRLLJOGa77HPtm5Nu9c7vdeTxwC6xGPJTnkDOjX44enb
	xUYUzIpZRz/tThUZ3fw5LZGTJCCaACB9Zrfhgx7W+4VVO1enSbSpN8I3jVLcX5pjm/BJnMTAshc
	HE=
X-Gm-Gg: AYBFou0EkGG05M9blrRsnRkPrbZyrCmp8c1nrRQn0Aiu1ELx7oBAGDNNAjFBwrnkJwI
	acTtlSGZ/tjCpWoCUBdRZroaSpiFQwEyOLC8pY8DEX7g4eGETGR48BI5WiKruhLryoA2zhdMvTH
	HWDfPKYWhXgdfvXPvwMuayBV+fKbe3bSyejeoOjNKa3Ip7/tEVjrlrKWui3if5fE/NMYZ3Wq27b
	N8x0+8oSNsCamscrGZglx64BO/GzYBKxY2uusSvfL/2Lu6mD8UO7a8WMPVzOK0mrTonwbLetQb/
	/3TUXmTVwMOUFco69oUs8zUOoINspJB11v4B1p/lElmc2ovh8mBULhZ3pO+M2rqwIkkLGVWqZSJ
	Udm8KL7MC+liKCTgOsAsrPzG6evogu4BZHXRck7YKW/OusH9kl+6H8RivVFaYu7FKBNZDdfu7ss
	QcnnNTlsUWEJMQsT6CDos0sh8pjqQnWKBM
X-Received: by 2002:a05:620a:4454:b0:915:9e84:85d1 with SMTP id af79cd13be357-93bb77923aemr191908585a.23.1789535156263;
        Tue, 15 Sep 2026 22:05:56 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-93b6f8a5d8fsm19406585a.1.2026.09.15.22.05.54
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2026 22:05:56 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc132709c76so6624466a12.3
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789535154; x=1790139954; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6awU6L1NSAdZve1Go4DAFmiBVEoVbQdcfNtuUS9ma4s=;
        b=e01/Pg2IBpzC0Bqex9DOMykMe0NH8GqR63sV96dnH3cEAML2LYruI4f/HE7lJLUD7N
         Anqv/DxU5yHtp8TEaWLtL4SH/R8cLjjGx+2bCHJN+4FPnvChfR3loE9GQhXkU3HR/enX
         1IPVE8ziwFphdQ17FTYMR/spfaBQc4VwjW45I=
X-Forwarded-Encrypted: i=1; AKwUvBzbar24tjc6zGN/dn2kNZQWugQYJMCCpa4RjDI7hzjIKPf3tAXGFhYEP9SMv2jfnh0uH6hCv0Qyvw==@kvack.org
X-Received: by 2002:a05:6a20:4388:b0:3cc:8f53:26c0 with SMTP id adf61e73a8af0-3dd5f57bbfamr2773485637.17.1789535153980;
        Tue, 15 Sep 2026 22:05:53 -0700 (PDT)
X-Received: by 2002:a05:6a20:4388:b0:3cc:8f53:26c0 with SMTP id adf61e73a8af0-3dd5f57bbfamr2773437637.17.1789535153567;
        Tue, 15 Sep 2026 22:05:53 -0700 (PDT)
Received: from vertex.localdomain ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5e40494sm3951386eec.15.2026.09.15.22.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 22:05:52 -0700 (PDT)
From: Zack Rusin <zack.rusin@broadcom.com>
To: Borislav Petkov <bp@alien8.de>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	x86@kernel.org,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	virtualization@lists.linux.dev,
	bcm-kernel-feedback-list@broadcom.com,
	linux-kernel@vger.kernel.org,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Bo Gan <bo.gan@broadcom.com>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH v1 1/2] percpu: Use X86_MEM_ENCRYPT for decrypted per-CPU data
Date: Wed, 16 Sep 2026 01:05:39 -0400
Message-ID: <07cdda86e2c60b27a18023e2e5fae339b78db0ab.1789488039.git.zack.rusin@broadcom.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1789488039.git.zack.rusin@broadcom.com>
References: <cover.1789488039.git.zack.rusin@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 46B5740006
X-Stat-Signature: becu7635adfd8ky43a1465s88jh58k1j
X-HE-Tag: 1789535157-699688
X-HE-Meta: U2FsdGVkX18dhfBfKw9HnIZIV18L7GVBUT0dNw6Qn+wAiUdvSk+Yx/Ph39hkLDE32EDu1z9xbhe9PNcYqhvAfwTiy0v0L+E1krTVj5JvDLUd9j6w9Z6EtiPAiPdCyxzPD1aih2SXyF0YQeb7lByqzsIIdpKhHXEQb5OLT0P4S/pIrMrQMRLVZRwlhDQIRVxiKqLxdLYaTze4U3wJxe2BU/GXasXDfiTOUJkR6dMFeSTPhsXTv2blF4XN+r1jfizgnpZXfNczvlMuCQI87gYX2F0SD5/ezZTYyWYshcH3gWOgHAa6JNFPTTBW33Ba9Kc6R3fhiVwEqWgrmkZDvOd9fL+jdCNkxaeRQedusUqtMfiFKfbYyq6gZWG+Oke6MR45GB0E+Ryskj8dHOPtLgAnsXrlXcjW9iDP7NooawnyT21aCFbntmCotQHn0wpDnF52Sv1aGhRztBXgX/RNaRiEBNtP4RWK6UsmpG/2zQ7l6K8nPpVDUficQAfcObYt6ofkviIWqBI1+5Yc66AwLp1ZjhgeorSA/BhREwepRwkx9C58tgS4eiOYoevg0dIo1dXn9o4azcZ8YGAa75dgcJV63XzdmxVzbeKG+v6DX6d5n72F0O0AZo3Niij1VUoan22SCP8KgIAUlO6uqk8HI3JUEKIjnkIvP3KKECNsHMwAAaKIY0UQsAl62WSTkqGKnUs/vmuSYKTi11AMvN7I3GFekS+LXBhyF2FZFLZJayGXP1gDHAps1aNdoDzTzU69NVg/9Hp6FtPmpDp4BANbvTJeLKvqpi4Rc/hr1xTBK7M4Kr0cPIT+pASFA+nWv/JL1wyl7OeMVYQMFQlxcUAI+RvsJ9R8LVP2vtAYZtpZXBjH2308xYoPGkURF21HT6L7dzWsi/56vYZe7DbHiTQs+mAGRfZ8NaInvp+mGLD1E1ru0w8CHDzhtkvKZ42hQngOnmaEYGcRkFZIIxar2InqKdC
 O+sWPbu7
 XaRCX6Ec58JI47aq8qea0+9yy78NycpvIaRpkYqQivOIVo0jl43WFm6AaXIZyMivx3S/joumqL1nzOaMly/ejtDhAnBSFUNkE1P2+OjujYQuo/MN2UeHHyOlLw2j6bqkskKtLoDjUk1DsJPqG3zjrGHD/YJNTgLLEPygmoSrZY1t0tzU9FIb+kIkuzWCNIqn+yWvRkW1us/MOBd8lySZEpKK7eUS8L7vn41zZs8hc5ugapVISvmuDZN84n1Ltlgpczd7jqNmtBsszdmTUVKI8F5X4K4nQddrC5a7/7eP/j/E/R9q6cXMPXlfcw34jwqqsC6TpPm8TubCcyb9/HwFMesIrilzwRwx3YF6wmJBXWcKoHoerlXJL7o7/GS7gbiFDhrNPmqpOrMuLZ/TTgPaPjEU/WgVyZKpee6qmE7yp3voW5TU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Decrypted per-CPU data is gated by AMD_MEM_ENCRYPT. With
INTEL_TDX_GUEST=y and AMD_MEM_ENCRYPT=n it falls back to ordinary
per-CPU storage, so converting a variable to shared memory can expose
unrelated data on the same page.

Gate the declarations and linker section on X86_MEM_ENCRYPT, which both
AMD_MEM_ENCRYPT and INTEL_TDX_GUEST select. Existing AMD configurations
are unchanged.

Keep the decrypted subsection page-aligned at both ends. The per-CPU
template and each allocated per-CPU unit are also page-aligned, so page
conversion cannot expose ordinary per-CPU data. TDX-only configurations
may need additional space for this alignment and isolation.

Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
---
 include/asm-generic/vmlinux.lds.h | 2 +-
 include/linux/percpu-defs.h       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index b2988aa12f66..1448e791773e 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -1013,7 +1013,7 @@
  * Note: We use a separate section so that only this section gets
  * decrypted to avoid exposing more than we wish.
  */
-#ifdef CONFIG_AMD_MEM_ENCRYPT
+#ifdef CONFIG_X86_MEM_ENCRYPT
 #define PERCPU_DECRYPTED_SECTION					\
 	. = ALIGN(PAGE_SIZE);						\
 	*(.data..percpu..decrypted)					\
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index dbe3267a0a13..54ce1442d918 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -172,7 +172,7 @@
  * Declaration/definition used for per-CPU variables that should be accessed
  * as decrypted when memory encryption is enabled in the guest.
  */
-#ifdef CONFIG_AMD_MEM_ENCRYPT
+#ifdef CONFIG_X86_MEM_ENCRYPT
 #define DECLARE_PER_CPU_DECRYPTED(type, name)				\
 	DECLARE_PER_CPU_SECTION(type, name, "..decrypted")
 
-- 
2.53.0


