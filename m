Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8431BC982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C6C66B0093; Sun, 20 Sep 2026 15:37:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19E2F6B0095; Sun, 20 Sep 2026 15:37:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08D106B0096; Sun, 20 Sep 2026 15:37:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB31C6B0093
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:37:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DCEE41604F7
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:37:15 +0000 (UTC)
X-FDA: 85235149230.20.D9DBFB4
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1658E180002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:37:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VffYttOi;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjdNKKGx+yhFaJeCA90Rv+NyjnhIa6+HpCMo5c2ikFg=;
	b=u0lrzY0LYSboJ5c2L6AkdPnGaGHna8yb6h58uDzyrAtzkl+FrA8EQu32+dlVjNKVQ4rYCL
	keprnBMFbhaPO46a/FeuP7H5ZAora9Mre1G8uu9KHyYUjdBKKwV+kd0B0eJcy1x8U2jyF3
	AEMQHJVbzR3jPNw+sc8FT3VeeN6sgtM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VffYttOi;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933034;
	b=sgGjfAkpQcrv7OQqYv11ZxOeNv59wJaLC8R4d95oODzJDR/ONysSBRPvX7/xbKAOXlc/ip
	B41zJyMfYI4d9oSk5g+FErLkec8/7AyTMTIB1h0299R3xSw/+bAaUXZ1krYzR/vQNgW+hw
	Rfkb09/CwHlOS9ywNtnd78z7CTt70s4=
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d43ac8d1dso14783957b3.3
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933033; x=1790537833; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gjdNKKGx+yhFaJeCA90Rv+NyjnhIa6+HpCMo5c2ikFg=;
        b=VffYttOi0vXu84SHmiRrhNO7xKR0IctHgCAg2SJln8+aW+/LbihixlnKh3p3upkEMv
         sHWqqOTXVvtP7H/ToWNbtIrwAvcxYAE222gxMWw6YGLdF18R/E+1pnFOUA+qD+gtMwb4
         zvjfQ0biPGU2UtTdYE/84S2WaZ8SzqBqWLyy9s0DFaomPzLQAcbCwgYrWB39I3bR61BA
         YLeQBQ+vWT6+nxheNCneW63nw2142N/6HMK0mKMbM4QcCP25Bgva/TN4Dpi+g/N/iBZc
         e9oH+qHkX51OFTw4+6l2Ta0/VP/v4mSctAwIKmIt9tY8fYUlEHvvnHs8XbmzzkAjDGrY
         oIgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933033; x=1790537833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=gjdNKKGx+yhFaJeCA90Rv+NyjnhIa6+HpCMo5c2ikFg=;
        b=iJV4HO+4oUvhbedUQZ8A6DCWhZMxcrtoSB17Dpz1Ne5w+sYSVxjTQKb8WvW0qrsRLh
         +zXZ24bcNl7+rTLx5/r6+YjKpNblgiiLT+XSqBlnijaaJzGGEz4GdyLXYv6g4eNYnv7w
         9lFtMKlKqXad032S4DOTlNX3+Yj5q0BEtDUcU/P8HTmzvz03GYYZKANlJnt4zuUfNFCF
         MN8434P+cn/VUSZMT8rx/doWPOK+4vnq9w/kji7uks473HMpubsGrPMq6e/E49IT2a6r
         AlzVfwdvHyhCN1jXJQH+nOd/ZFVtZGLTwdytu77Ijien+Ho+XnPo3tCGuwrU06LBNjGA
         xsEA==
X-Forwarded-Encrypted: i=1; AKwUvBwsUbp7wzPkM5bcQJtyyE0ihLNcfjigs+dut1EDPBGHojEngfdcQZYVEy6vxx8UsIJnVRT0L4BxZw==@kvack.org
X-Gm-Message-State: AFuF++n3vmznj69Q4wyYbNyq90mN2eZPLRwRibto02pDHXF5f9tM6dvO
	7L1Vijdd4VRgfqqMUGsvhNyn1OWUxPqlv2NNa6uxaIHM88n9unozUVBcjd6rHV+wAbQ=
X-Gm-Gg: AYBFou1NI0TPVhOwNKW8xVvvSOXroCqzc/J6vrI3haIoeJUjTyg0BBs5JqQOBlvCimA
	bbsqn0XQu4jtNjpm+W7sStRBgG+Bcgg/KC9lzoQYpIA+V7q7P6upMJQNRAmfjf5U0YkSdQlCgm5
	KIPkqo0Ngl1X3u5lOmlGipAobQAZJvVnk+Ur/ReNN6gXAKozg+W0qpkMvdT05ey67lVWHyiaMUN
	dyWtTwMJAuWEWqXZeEHirzlCqZCdbjdCAznAsnG2RyWeciZd6fB7k1wWkMj5WWxeGmQc+hMzc4F
	twnRuW9PwwZ14o+I2ejPD76D3h09QW0Vf5/BnCv9y11YK7wop1ST0G207YNftf+DO5adYHNZFAu
	raxWLeo3Mp6gwzCevdhtkBfyUFQWDkmYEkWmiG9kkbkhUdB/2ojT7Y0hZLI3rZjoKaCcwQ0/i+m
	nLMnlcf1+2kI5xeYgGvNLVfUE8LlvWn90VZViY3byaJoTqUSs7PL3g6C7uYIcl+0A2Yi1Utvs7f
	pxrXEfOBq2TR1P5PUfPa1R0l7b7ycDbm0AsxM5NzqZI+1f3Dvi43WFit/WVRShGpXOhbnuxUJ2W
	pkKfrw2MNMFfHiJ5gQQ=
X-Received: by 2002:a05:690c:9988:b0:89b:5551:4305 with SMTP id 00721157ae682-89b5560974dmr13921117b3.17.1789933033098;
        Sun, 20 Sep 2026 12:37:13 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a48aab042sm18596427b3.47.2026.09.20.12.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:37:12 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 03/46] KVM: arm64: Split kvm_sys_reg_{get,set}_user from kernel accessors
Date: Sun, 20 Sep 2026 15:36:07 -0400
Message-ID: <20260920193650.3373435-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1658E180002
X-Stat-Signature: rz5nxux414hebhbb1cdbhse3rt3frrny
X-Rspam-User: 
X-HE-Tag: 1789933033-127622
X-HE-Meta: U2FsdGVkX1+gcOQXKdDcbChQwMZoZJF12AnLVqucq7snLYIyX0+o2NEMlfeloP6cxyCdDKAwfrUMkKX7S68Ml+gqqUoVWYukzbdmViLP+k/WAH6DxRp/xDJeaR632YW2aChvn2Nl/O0xv341AoeoPltC6OkvUePGImeXuUj5SceJiqJB7BSE1j4XddCy2oyxDA5b6sy3KYnGZ6OnpWBFhYgI6d/Kzr+tjtL+je4Nr1UhgpOVbE/jWRxX+bHTB0bHOT9e70OZr1xV1zhll6IXX8nKaDy9ReB6RLH5LTDSg1qd41sepZOOliYJn/VCiuoGyvN1dfnF/6KIiFsqfa39DsoISCIqH/psVbUcDn9WtmlqsC+RgzPiQ0RzVmOJIuCl0U3bfsgnIwxLCKtsZu6FFFcab1HTxeiaGG4gBd/dph6sElo7Q/In0GNh1AS7ymr4VohD7sR6/DZhgzLoz36Kbti4UczTWQU1nAXvV84OeBFFO6l88qMvq7dd8wdqmg+2sfyEcjyNempRSIgzcST3ATqh+wdI27frwg3QIPJiSWQZQLbX5hyDsgjan1brXj3MIcxEgXvEsi0LcLasRdf5Uw3t1dP6ji7oc6HPS/KN7lUetWRdmYQ1S+soX8fhh0oKeI2u/sSb5nxel02U4CYfUM4HMD8Kw7WgAI2Ioo2RxxOuVq5lu+O3qODQ0pn76VRHI39caOS+6WtAqczbhpk17qIvNCY3KfK0f6eCaVkQRDn2mV/DSbWAwHaROqOQTE9Jvm0/x7C3flgU10LNDNErT9h4oMXvOdYNsVEP0Bj1psj7v4CbCokKeYPauSHbKoOq3PxPAMVnR5WlrIfxKV1NQKS7hnA1qypGx0KrHVsMaaV3cnNVF5FOZ6OQR9LH4kHJIONfxnqHSyBzzBEsymk6EEiR0YFSFk5uzzPao47X7U494dGmkOqQsD9PO/oikSL3TZ1yRygMdvrtGZJMpIO
 ACC9tKbk
 O/RHjKS6Y1BrfV2TbzJ1bfA8SAmCSlMfbRiMg4LCBjUf/0hgbJdIH6U3QQupOJn/ABoP0TXU6OcBudByD9SQO7M0HCALABqMW3pd+7XkWp1xoQIZeIoFHyriDrR3lhsgb/uUME8UI4RcI1HUV/qfTco8NJsNsQAgDR24cryu/cJjCVrzq6lRyx6YtFGQqS47k4L3Gzfb5i5xWq2jV03s7aAHLM+1qmSw9Wq6pnvfUg9RmZlLTouCVyZPc97bMJ/CY9ycdP0jZ8TBmSqw+QpaivXJwHMe0cxrkx5tUwWvnDsF5a5TEAaXwFLXRzPS02ZoEMsivosUvul2O934bVfcqYhhtMEcwiE9hdHUeH17xDGmMttvc12ZF1Mfidw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Factor __kvm_sys_reg_get() and __kvm_sys_reg_set() out of the userspace
ioctl handlers and introduce struct sys_reg_index_sink so in-kernel
callers can enumerate, read, and write architectural system registers
via kvm_arm_get_sys_reg_indices(), kvm_arm_sys_reg_read(), and
kvm_arm_sys_reg_write().

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/arm64/kvm/sys_regs.c | 199 ++++++++++++++++++++++++++++++--------
 arch/arm64/kvm/sys_regs.h |   4 +
 2 files changed, 160 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b873ccf1ab14..0049e460e5ad 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5569,38 +5569,43 @@ static int demux_c15_set(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
 	return demux_c15_set_val(vcpu, id, newval);
 }
 
-static u64 kvm_one_reg_to_id(const struct kvm_one_reg *reg)
+static u64 kvm_one_reg_to_id(u64 reg_id)
 {
-	switch(reg->id) {
+	switch (reg_id) {
 	case KVM_REG_ARM_TIMER_CVAL:
 		return TO_ARM64_SYS_REG(CNTV_CVAL_EL0);
 	case KVM_REG_ARM_TIMER_CNT:
 		return TO_ARM64_SYS_REG(CNTVCT_EL0);
 	default:
-		return reg->id;
+		return reg_id;
 	}
 }
 
-int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
-			 const struct sys_reg_desc table[], unsigned int num)
+static int __kvm_sys_reg_get(struct kvm_vcpu *vcpu, u64 reg_id, u64 *val,
+			     const struct sys_reg_desc table[], unsigned int num)
 {
-	u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
 	const struct sys_reg_desc *r;
-	u64 id = kvm_one_reg_to_id(reg);
-	u64 val;
-	int ret;
+	u64 id = kvm_one_reg_to_id(reg_id);
 
 	r = id_to_sys_reg_desc(vcpu, id, table, num);
 	if (!r || sysreg_hidden(vcpu, r))
 		return -ENOENT;
 
-	if (r->get_user) {
-		ret = (r->get_user)(vcpu, r, &val);
-	} else {
-		val = __vcpu_sys_reg(vcpu, r->reg);
-		ret = 0;
-	}
+	if (r->get_user)
+		return (r->get_user)(vcpu, r, val);
+
+	*val = __vcpu_sys_reg(vcpu, r->reg);
+	return 0;
+}
+
+int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
+			 const struct sys_reg_desc table[], unsigned int num)
+{
+	u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
+	u64 val;
+	int ret;
 
+	ret = __kvm_sys_reg_get(vcpu, reg->id, &val, table, num);
 	if (!ret)
 		ret = put_user(val, uaddr);
 
@@ -5618,17 +5623,11 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 				    sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 }
 
-int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
-			 const struct sys_reg_desc table[], unsigned int num)
+static int __kvm_sys_reg_set(struct kvm_vcpu *vcpu, u64 reg_id, u64 val,
+			     const struct sys_reg_desc table[], unsigned int num)
 {
-	u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
 	const struct sys_reg_desc *r;
-	u64 id = kvm_one_reg_to_id(reg);
-	u64 val;
-	int ret;
-
-	if (get_user(val, uaddr))
-		return -EFAULT;
+	u64 id = kvm_one_reg_to_id(reg_id);
 
 	r = id_to_sys_reg_desc(vcpu, id, table, num);
 	if (!r || sysreg_hidden(vcpu, r))
@@ -5637,14 +5636,23 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 	if (sysreg_user_write_ignore(vcpu, r))
 		return 0;
 
-	if (r->set_user) {
-		ret = (r->set_user)(vcpu, r, val);
-	} else {
-		__vcpu_assign_sys_reg(vcpu, r->reg, val);
-		ret = 0;
-	}
+	if (r->set_user)
+		return (r->set_user)(vcpu, r, val);
 
-	return ret;
+	__vcpu_assign_sys_reg(vcpu, r->reg, val);
+	return 0;
+}
+
+int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
+			 const struct sys_reg_desc table[], unsigned int num)
+{
+	u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
+	u64 val;
+
+	if (get_user(val, uaddr))
+		return -EFAULT;
+
+	return __kvm_sys_reg_set(vcpu, reg->id, val, table, num);
 }
 
 int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
@@ -5688,25 +5696,24 @@ static u64 sys_reg_to_index(const struct sys_reg_desc *reg)
 		(reg->Op2 << KVM_REG_ARM64_SYSREG_OP2_SHIFT));
 }
 
-static bool copy_reg_to_user(const struct sys_reg_desc *reg, u64 __user **uind)
+static u64 reg_to_user_idx(const struct sys_reg_desc *reg)
 {
-	u64 idx;
-
-	if (!*uind)
-		return true;
-
 	switch (reg_to_encoding(reg)) {
 	case SYS_CNTV_CVAL_EL0:
-		idx = KVM_REG_ARM_TIMER_CVAL;
-		break;
+		return KVM_REG_ARM_TIMER_CVAL;
 	case SYS_CNTVCT_EL0:
-		idx = KVM_REG_ARM_TIMER_CNT;
-		break;
+		return KVM_REG_ARM_TIMER_CNT;
 	default:
-		idx = sys_reg_to_index(reg);
+		return sys_reg_to_index(reg);
 	}
+}
 
-	if (put_user(idx, *uind))
+static bool copy_reg_to_user(const struct sys_reg_desc *reg, u64 __user **uind)
+{
+	if (!*uind)
+		return true;
+
+	if (put_user(reg_to_user_idx(reg), *uind))
 		return false;
 
 	(*uind)++;
@@ -5986,3 +5993,109 @@ int __init kvm_sys_reg_table_init(void)
 
 	return ret;
 }
+
+/* The GICv3 CPU interface sysregs, or NULL if the in-kernel GICv3 is unused. */
+static const struct sys_reg_desc *vcpu_gic_sysreg_table(struct kvm_vcpu *vcpu,
+							unsigned int *num)
+{
+	if (!irqchip_in_kernel(vcpu->kvm) ||
+	    vcpu->kvm->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
+		return NULL;
+
+	return vgic_v3_get_sysreg_table(num);
+}
+
+static void collect_table_indices(struct kvm_vcpu *vcpu,
+				  const struct sys_reg_desc *table,
+				  unsigned int num, u64 **out, int *count)
+{
+	unsigned int i;
+
+	for (i = 0; i < num; i++) {
+		const struct sys_reg_desc *rd = &table[i];
+
+		if (!(rd->reg || rd->get_user) || sysreg_hidden(vcpu, rd))
+			continue;
+		if (*out)
+			*(*out)++ = reg_to_user_idx(rd);
+		(*count)++;
+	}
+}
+
+/*
+ * Enumerate every system register that kvm_arm_sys_reg_read() can return for
+ * @vcpu.  This is a superset of KVM_GET_REG_LIST: it also covers the GICv3 CPU
+ * interface table, which has no uAPI representation.  Pass a NULL @indices to
+ * query the number of entries the array needs to hold.
+ */
+int kvm_arm_get_sys_reg_indices(struct kvm_vcpu *vcpu, u64 *indices)
+{
+	const struct sys_reg_desc *gic_regs;
+	unsigned int sz = 0, i;
+	int count = 0;
+
+	collect_table_indices(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs),
+			      &indices, &count);
+
+	gic_regs = vcpu_gic_sysreg_table(vcpu, &sz);
+	if (gic_regs)
+		collect_table_indices(vcpu, gic_regs, sz, &indices, &count);
+
+	for (i = 0; i < CSSELR_MAX; i++) {
+		if (indices)
+			*indices++ = KVM_REG_ARM64 | KVM_REG_SIZE_U32 |
+				     KVM_REG_ARM_DEMUX |
+				     KVM_REG_ARM_DEMUX_ID_CCSIDR | i;
+		count++;
+	}
+
+	return count;
+}
+
+int kvm_arm_sys_reg_read(struct kvm_vcpu *vcpu, u64 reg_id, u64 *val)
+{
+	const struct sys_reg_desc *gic_regs;
+	unsigned int sz = 0;
+	int ret;
+
+	if ((reg_id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX) {
+		u32 uval;
+
+		ret = demux_c15_get_val(vcpu, reg_id, &uval);
+		if (!ret)
+			*val = uval;
+		return ret;
+	}
+
+	ret = __kvm_sys_reg_get(vcpu, reg_id, val, sys_reg_descs,
+				ARRAY_SIZE(sys_reg_descs));
+	if (ret != -ENOENT)
+		return ret;
+
+	gic_regs = vcpu_gic_sysreg_table(vcpu, &sz);
+	if (!gic_regs)
+		return ret;
+
+	return __kvm_sys_reg_get(vcpu, reg_id, val, gic_regs, sz);
+}
+
+int kvm_arm_sys_reg_write(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
+{
+	const struct sys_reg_desc *gic_regs;
+	unsigned int sz = 0;
+	int ret;
+
+	if ((reg_id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
+		return demux_c15_set_val(vcpu, reg_id, (u32)val);
+
+	ret = __kvm_sys_reg_set(vcpu, reg_id, val, sys_reg_descs,
+				ARRAY_SIZE(sys_reg_descs));
+	if (ret != -ENOENT)
+		return ret;
+
+	gic_regs = vcpu_gic_sysreg_table(vcpu, &sz);
+	if (!gic_regs)
+		return ret;
+
+	return __kvm_sys_reg_set(vcpu, reg_id, val, gic_regs, sz);
+}
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index bd56a45abbf9..9837db99909b 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -292,4 +292,8 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu);
 					      sys_reg_CRm(SYS_ ## r),	\
 					      sys_reg_Op2(SYS_ ## r))
 
+int kvm_arm_get_sys_reg_indices(struct kvm_vcpu *vcpu, u64 *indices);
+int kvm_arm_sys_reg_read(struct kvm_vcpu *vcpu, u64 reg_id, u64 *val);
+int kvm_arm_sys_reg_write(struct kvm_vcpu *vcpu, u64 reg_id, u64 val);
+
 #endif /* __ARM64_KVM_SYS_REGS_LOCAL_H__ */
-- 
2.55.0.1082.g2b9226bbc0-goog


