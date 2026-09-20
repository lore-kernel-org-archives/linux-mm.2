Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98A09C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792F06B0092; Sun, 20 Sep 2026 15:37:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A346B0093; Sun, 20 Sep 2026 15:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3A46B0095; Sun, 20 Sep 2026 15:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 245806B0092
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:37:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0172FC04C1
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:37:09 +0000 (UTC)
X-FDA: 85235149020.18.79FDF32
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3B7021C0002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:37:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=htW3SkJc;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVwJQFyVies0sN36ZwALD03xlxJgg7HjR5Oz9PMtlp0=;
	b=TPN/6Uw3AaT28SROn3X0Gsvka2ykeU5VHaSLUqDoKd75i7WA7m+nkxAvxhb5R5tAD/EsKp
	7jTdE3YBD/FDz+/yoSepndcsWA4Xk4qlQS63mEtl7/iYPOWhb2JfVl02i0XKrx+5KW/tSK
	dCLJHOgXYAwlXn4jjcS6YBbgL4ksPc4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933028;
	b=Qv8YBIapEdfm/p9XnAZqVbCYaCq3zBOlTMmJcfjOCu38uXxLOKv2MDLHwMpinsxSZvJThB
	6lIJMSp22Nq2P4pxkteCy+ZwCr0tFDclaSpUsR0bkfpiHUhWoyDVI+qx+U1Z1uXa47vXZ0
	2nusvZh31eLo5zD4uvJ3NkZW6CfGMWI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=htW3SkJc;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d4ddd179eso17249547b3.3
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933027; x=1790537827; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wVwJQFyVies0sN36ZwALD03xlxJgg7HjR5Oz9PMtlp0=;
        b=htW3SkJcxC2N3OgXb3QyV4Bt1SWVPxTfm3djUf863aAyXlI2YVE32rVazDV+T67+q0
         uKAbfgWVCfiG3cJHXsZn0fg5zMcgmRD/2BjqWpGcgsheP0am8AMlu7QOEekbaceAJpTT
         qmMQCMC9avk2SUgBaOkLwTvtrYEi1+0LMmxk86HD3ht1XMuk6P80zXR79ZnW16hfHPjw
         JYfS5DLzmMPrFC4XQp09CZKrckMEE9ay4hO4coL6GrsP/fXrtA7bnNL0HIn4c1KpYbb9
         P4KoJ9Y+kKbY47wpGlumSvASmtWdJEvyA2YBoY69lgQ8bR88+tVuoKsDsIePGsGOIW8m
         QomQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933027; x=1790537827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=wVwJQFyVies0sN36ZwALD03xlxJgg7HjR5Oz9PMtlp0=;
        b=atLGcmV0mxSBIQon2i5SUBI6kRkyG/VhFaqDH+dWzTZDq2ptcuEiqvy44WNowXQih9
         DgDHB0HMmBg/i+1RnoLq81+4ngee2l2DVaTpqZ4VGvRAENu6JkO3swKAOTVXW22IK/L0
         7dMRvjpZcXLxSP0WCQT8Lk6RGmKXlw3cnspGzwY9xxN7HXBdXGb+QmWJfDCseFpQ5Weg
         Kq6xSfpq2YUzz/jw6Z6uOf8tH47TuzhCUSpazgr3VMTC4vxJNcDvR94c6IYKOw35dW7Z
         CNr4q6KdJDPWyBzC1P1X/1O1I+bYCyTCLX0CBqj4OBIp4Uh1zgYrR/pYDbxUi4Vi2QBH
         CIhw==
X-Forwarded-Encrypted: i=1; AKwUvBzVS7viz3qCxhrpzsFZILhQT3Omg1k6xgLMFCiu46GJF65crrejKBzQz9F5JUZTi0l1puNNmQqxrQ==@kvack.org
X-Gm-Message-State: AFuF++kcnh5JQTpVkU1MYKR5CAQH98ZwHZLpDhgg/R3b9rdMvIFFzZKH
	/r6tPi7ufIQXSIAILaFD3MnB6x2dMu//1DsK/KF/fskldbmMqkD6knBrzbOzP0pTsKM=
X-Gm-Gg: AYBFou0ecv5Fn/gHSE7zUBK8+QpZJF51IUyL1iZ+Rhd0Wu1u/CFscMv4Ex/Dk1A97FC
	y4BzMjrp0s3A8OS8FrmKHUrMh46eNgVioVQWuSGkKyKzFuzAr0cbXuwpYR6xjSqp9+LYluZDOnU
	6CMln7ghCmftv+alKNfdnuWRRAYUdtEK4x5Uavyhn1vhv1q0DnHOykbLmOzy6yI30abhrSKIjQE
	BP0jGbijdqAgn+K0mYo6klrF49sj80LoqJFQztv6JHHzoR05B87UsBd18A0WC4E4G5RdyHo9vVB
	S7D4Gcrh7RiU7HHgYDIbx8zW4j7byjfjcr2MGmr72qklefbNGP/tTmASKz4ud5Fod//BLzY5Zm6
	rMHENR1PAnSZdsNWvpvJWfoTIpmP2RYHJed6UdcZRNbUUh7fa3bwMGfSnqC9kyEJu3rfrRsxNZd
	ndiMd9QsZawozp9cmOKdpU4GvX36VD47zGy+zxORD8tNudc48puwYHksAHj930W/0ZLHnKgaT91
	victjCB/zJH2BM1e1pkVwDjT+gbmzAhMsCvGT+CLJa56/Om1E9zPX/WsO3kn5Nzssg9DZGFIr3f
	8a21IC3lH9a8nkYXHHU=
X-Received: by 2002:a05:690c:89:b0:89a:63da:cbe1 with SMTP id 00721157ae682-89a63dacc8fmr20430637b3.39.1789933027324;
        Sun, 20 Sep 2026 12:37:07 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a47139db2sm18450487b3.26.2026.09.20.12.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:37:06 -0700 (PDT)
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
Subject: [RFC PATCH 02/46] KVM: arm64: Split demux_c15_{get,set}_val from userspace accessors
Date: Sun, 20 Sep 2026 15:36:06 -0400
Message-ID: <20260920193650.3373435-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3B7021C0002
X-Stat-Signature: xr8zxxxi17sjoc997jqe5x51ejcm7tsh
X-Rspam-User: 
X-HE-Tag: 1789933028-647116
X-HE-Meta: U2FsdGVkX1+ia7qGsXhDhzejZ/fwWx0oV88i9Q9HZ5Sk8M1IzxseMDj22//FiusUlwy2FXqVVG69ei0EcrP/q2uOwr1vVUXQINamY8pFxlhVPgNq23n30tGs3AwKPjGxdIBX69c/u9JCq6XhZ2Bz6v5ErchrGfQRxGDZ7OF9wFjGHaTyNoJL/n+j5DygPSe8TwUf9UXxKaC66+m4tPz/f+w2D3VNe8eNLjget3CJlPeqmHYF+3NiyWRM8qfxHv49ADU1IEv0avjcvBvYO5ZRxCFojPZz60aL3IbhoB0dF78djVv+z+pAsdrHtYVUmZViqVU7pGHWJ6DQIX1uXPAIWF5SsNIZfQbwsa9xDu20VTp6nkC7AtwD0SR0UG9nA/cA+xNTolF55vS+g5cR+HwuiCJbbQErwQHw8c5v5oqITLnr3BnmZgq7MZbt+BCOy7w6JqtIVPY+DqfR2+OFaWwrqDS/yVs4jhWIF84YrOHTzE6h3rTwX+/Npwmb/zT1kbQuzdNxG1EoBz1qzMdtB9SYDMKn97P/bAYDkioKwM60iII91dbefLMgU8Hhj6HWy3gq90+wgVH3cirhFXwzMOd/pAgHcPoqWixgGpU3n524UtyvENnoI+T8+bYKBKCQopgvXijViY9t+Tfnabya+2uTtoqBpPgIjMGaz2fI27/OOPUsVm4isNgS7ZrkdYIzzhoTYEHwpmw5w6y9YRdaFlHAzspfFEwax8e3JlEIi/haWbVf48E3M2W0dcfghPXk97KSMVYbRBOks7v/jC5rUof6nxHMUbXfYjJkZ1BNb1tvZURfF3vKE/UIFT8gc8/2t663IhlL49XhilohiFgWVuMKphaTceswclt2BrGYzJOLs6YzjosmPsrCodeBKIv8LtQUatTch4BIWlFYDn5i+Hvmb9Z8sorGtTqbh+aD374RqA26HFrIkdJ5jkP9Xmb9Twl2PNhe63y1JLXPH+ti5Ld
 EhuqpyfQ
 ivNYvYOgVmeWP2jFfxwjyXqI4jzuEEYzkf4njqUAfQTAQuTl3WrGnoGRUk1Ab7SoYMHUFeQ4rhuHgxF5hMOb4mB6Pzx17Hui2TQ1+PaXX1WxTE3HpsLRmIdwAD3o8nean9OPRbn2F1Hq/JEP6C4BI+8tDGpuD/UXkGjYYRr3k3I0s8qoiv5xIMMlOMon/yBMoN1Xgm92Cwnd3UM6aDVH+irWH+KJlp8ewkrNA4u7TtfQhqNwEV7/8fUGnNuTGstCxoGB2g2peyU4mXggv3P6Q4sf2/4tZrvgymF1TlzwgKKaVLhvzuGAubXNq5MZTQfAopu38/oS6Xo1lnReI4DUNu/s44oDDOCVZO6MipHJ4uqmy9W8iodgV3P/pVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Factor demux_c15_get_val() and demux_c15_set_val() out of demux_c15_get()
and demux_c15_set() so kernel callers can read and write demultiplexed
coprocessor registers without going through userspace pointers.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/arm64/kvm/sys_regs.c | 48 +++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 44aae52c473d..b873ccf1ab14 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5496,10 +5496,9 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
 	return r;
 }
 
-static int demux_c15_get(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
+static int demux_c15_get_val(struct kvm_vcpu *vcpu, u64 id, u32 *val)
 {
-	u32 val;
-	u32 __user *uval = uaddr;
+	u32 idx;
 
 	/* Fail if we have unknown bits set. */
 	if (id & ~(KVM_REG_ARCH_MASK|KVM_REG_SIZE_MASK|KVM_REG_ARM_COPROC_MASK
@@ -5510,21 +5509,34 @@ static int demux_c15_get(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
 	case KVM_REG_ARM_DEMUX_ID_CCSIDR:
 		if (KVM_REG_SIZE(id) != 4)
 			return -ENOENT;
-		val = (id & KVM_REG_ARM_DEMUX_VAL_MASK)
+		idx = (id & KVM_REG_ARM_DEMUX_VAL_MASK)
 			>> KVM_REG_ARM_DEMUX_VAL_SHIFT;
-		if (val >= CSSELR_MAX)
+		if (idx >= CSSELR_MAX)
 			return -ENOENT;
 
-		return put_user(get_ccsidr(vcpu, val), uval);
+		*val = get_ccsidr(vcpu, idx);
+		return 0;
 	default:
 		return -ENOENT;
 	}
 }
 
-static int demux_c15_set(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
+static int demux_c15_get(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
 {
-	u32 val, newval;
 	u32 __user *uval = uaddr;
+	u32 val;
+	int ret;
+
+	ret = demux_c15_get_val(vcpu, id, &val);
+	if (!ret)
+		ret = put_user(val, uval);
+
+	return ret;
+}
+
+static int demux_c15_set_val(struct kvm_vcpu *vcpu, u64 id, u32 newval)
+{
+	u32 idx;
 
 	/* Fail if we have unknown bits set. */
 	if (id & ~(KVM_REG_ARCH_MASK|KVM_REG_SIZE_MASK|KVM_REG_ARM_COPROC_MASK
@@ -5535,20 +5547,28 @@ static int demux_c15_set(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
 	case KVM_REG_ARM_DEMUX_ID_CCSIDR:
 		if (KVM_REG_SIZE(id) != 4)
 			return -ENOENT;
-		val = (id & KVM_REG_ARM_DEMUX_VAL_MASK)
+		idx = (id & KVM_REG_ARM_DEMUX_VAL_MASK)
 			>> KVM_REG_ARM_DEMUX_VAL_SHIFT;
-		if (val >= CSSELR_MAX)
+		if (idx >= CSSELR_MAX)
 			return -ENOENT;
 
-		if (get_user(newval, uval))
-			return -EFAULT;
-
-		return set_ccsidr(vcpu, val, newval);
+		return set_ccsidr(vcpu, idx, newval);
 	default:
 		return -ENOENT;
 	}
 }
 
+static int demux_c15_set(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
+{
+	u32 __user *uval = uaddr;
+	u32 newval;
+
+	if (get_user(newval, uval))
+		return -EFAULT;
+
+	return demux_c15_set_val(vcpu, id, newval);
+}
+
 static u64 kvm_one_reg_to_id(const struct kvm_one_reg *reg)
 {
 	switch(reg->id) {
-- 
2.55.0.1082.g2b9226bbc0-goog


