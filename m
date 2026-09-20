Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CBE9C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8A76B009B; Sun, 20 Sep 2026 15:37:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6826E6B009D; Sun, 20 Sep 2026 15:37:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570056B009E; Sun, 20 Sep 2026 15:37:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D5186B009B
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:37:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A49721204DF
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:37:32 +0000 (UTC)
X-FDA: 85235149944.14.89F8FD6
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf15.hostedemail.com (Postfix) with ESMTP id DEED1A0004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:37:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GDhRmj+Z;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933050;
	b=4ltUDi3FB5khtoDpEvzkgKOQSdDLdR36uXVDJRO6M9yRehfOHUvT5O+eVWy5ROU9lPY8Q9
	3qN/l44VZDxQiz6gOsFpVx3BSh4AArhk4103+N2bzwhjlx+hsJZOBLQtJ5FwtSEyAg4U68
	h1DIMHnMfCMAVMjyyP9bNAtGroZ0+RE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GDhRmj+Z;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qTv8uFL1FYxhccWvDyiinfq9K+eUMO7fyy31bgvC6E4=;
	b=GZ+eZSUnpeYGBoEbVNAel5Pz6wJA92ozoJHemaOV5bX/coxrgAYGRdN9aMXA2u3LcnOm7V
	dShUzdaVVMWYws4A7BGnxRjubqRw48wKinCd3iTPKkayRiyjcwlI/3z0n3HiJaTAf6BK1S
	hCiOjJep/6FLm9uzjD2zIjoCYi/J1E0=
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e56a1b327so1754451d50.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933050; x=1790537850; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qTv8uFL1FYxhccWvDyiinfq9K+eUMO7fyy31bgvC6E4=;
        b=GDhRmj+Z9JAxthaORqE2tQLNo+0MnEL2D3Vbwp3qdF5oRZMreXOqwR9MrsJNrS6Xwm
         gH4kfJRif9I3XXIy8lhvHOhU1WxemkL6QYqp6JgrKeacrPqKdDf/xb5anViBmC6yi7rH
         JOBnsI4BhK5iTsO23wJa/tuPUt0DI17uQZq7CS0AhWeVfC2PJFLfpbtc43O/FvkrkNX5
         o/n6LneZFoxzRkTF0+NypHfL1A+yN+3RsMwy5rjyNz/i6p5ZFsiQ7VRexJlgLdFT8nfS
         n4+KmlnDvkfbBIzJjAPMBfqWnBn/WxmgH4MJEj1E84FQ/r7IrLg6PwJSf9FQTm7oopZx
         NYBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933050; x=1790537850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=qTv8uFL1FYxhccWvDyiinfq9K+eUMO7fyy31bgvC6E4=;
        b=C8vYnlSAEWGtPAvMkw4OLb1d9ZYsO//2CYk+FSWkJ6dxk/1qzj+3xHDLDFOX3VEuvg
         x/CdL5FgPW+Mcd+gW3qUjNSRzV0d1XP1+GDLqp6xuDytaYy1dCpJ3uRpbPP7NLHo1eGi
         5zA6arqQq9pTW70j2p8WQm/iCkmifH/NVWgfltobWgx1l3za8Cd39d1Q/EpLWQ1a3ljk
         zhn4SCOFodg/HQbDMAiHWQtH7WwvtclEE1oIR1Cz6bA/KABzQ8iMotT88LfBW8kqy0gU
         dGtiuhEbVHWvFH5O1dijoB2CrlFn88t1gXy/H0Uq8hXQcMoKhbcEKjhQrXoX8yTtckQV
         9bmQ==
X-Forwarded-Encrypted: i=1; AKwUvBzllHGSxF52tEFdKkmqdJ4MYE8hvIw5K2jBi5akyagSebprl7ioRHDq/nqeiQLlx1B5RdTElCqpYw==@kvack.org
X-Gm-Message-State: AFuF++nnJGV3g9OEvYCdQpf2k4Ad9P11S5903XIXBHUhCoeiCxIZ3O3R
	pmpfKHixtQWxYwyH1IbiEEaQImMmyhTasH6xDaFTE77KgEs5aLb34UFIRX8k+hFRN68=
X-Gm-Gg: AYBFou2qanXvYXD1APzIlL1zDtTsvoHBVa4PlxrrXucRBrxw6hhv16Uir16jI64HhP8
	lpQTprHJ5XU29Pko8Xtho1xFTatzGAby8cihpRTdksGRkS92eglLh2bFjTmWx5NuDwsdjgKJROH
	MrCOk/fq83IACgu+fQlEIwYDlZwUVwgmvXBrmnrZutVJ/QcYhfLLdkXY1HwwZHjaFDefjgD37j3
	PPCEf+3iYgrHhmJAoy0cEnY86qsZE5oMA8MMx0iVGOdOL3SZ7QvfDGneyBejQttBhf3toFOg59A
	lo/ySZQ6A7S7wZGXPASWe4YELK/wL3IXDk9AduYsvlPWtMYSByI8ob5edYNeQqDmRQM8pdOgfLk
	X/CRtNOUwv6TC94BlJG1ZE5RLhK0TYStWqrLzvIbKZTyiXjejYLbWXjRey3SHhKyyTpVUR06ofE
	ZTxMEI0mc1tuRSZ/FZzjsf2ZZHhVAOX1m8H3xbDlJ1j20aj+2N4XIsQtovCy2mjKRPf4zcISxU+
	F8Ao/WYKT/dQyX8Eit37oHu+TIPknmXe3laE6OHlJjBnZYTqBVAtr+5OGgudgAxQWFNMVqqNVWl
	IdLS8t8tE/ahQcxEgvdA
X-Received: by 2002:a05:690e:134b:b0:671:70d1:d6e5 with SMTP id 956f58d0204a3-6717fe597a3mr2639510d50.87.1789933049997;
        Sun, 20 Sep 2026 12:37:29 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67298f64c7esm2656294d50.2.2026.09.20.12.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:37:29 -0700 (PDT)
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
Subject: [RFC PATCH 06/46] x86/smp: Skip offline CPUs for REBOOT_VECTOR in native_stop_other_cpus()
Date: Sun, 20 Sep 2026 15:36:10 -0400
Message-ID: <20260920193650.3373435-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DEED1A0004
X-Stat-Signature: afj7zjqkwrjtwzcq7s8fkk7aatgq9zqb
X-HE-Tag: 1789933050-990439
X-HE-Meta: U2FsdGVkX1/uUEMsY+AUsf5MhLLNOJYj6qJNyys725kI/kgJ3xnp7jprZ/6trj6UXkoyot//dNR5bMJ6UfhTSA66fljFw0DgoUO1uFl3fCiXm2uQRbAB40N767lOl7TWeevdXav33xlM3zAWCYIOg7NzbV7xnQGtMeSmWQD0I7uk5WkZ58pt5mZSBt0Ps3tqcVW1Zm2IBVPJ5fZ8FlWM1CZ9hjEt44o33pHlJeFj6UFeR8R/sfUrPTd7QcpS+rrMYCEYKBpteTKhC94G0srvNT+C5DJizIJ561pD3MiV0I3nt1L/ViB52XVReE1KRbu3EmdEOOS2Xk8kDXWl1olxyo6PvsMgp7/ZcbPOL9tqmMv4ve2otJzDeAsKP/q9EI+d/9R6lGahyrUcADJ3FxW6BVBXDLEuJc+g/qcPuYvbmHV2BRDFnvovKyk5yPOObEqAD3GpCr3rqypnVXFMhoTuFEDlrry4ZWQtvfFD0nawVXSbauO61hVeLXnwpONyR3UCxQlysEQnexzKjIptDRe6tVb+uNNchqMxjTx83pes3j6dk3frRb991L/LON+u0fNJfJGEp523+YUKHyn3hc8hvwLbhCkjTHU85HAgLtYpnJT7jIzaZ5zME4OFYSAnD4P6Joa0WYSrwQb2XKWIw6UAu37R+xF57+c1wlu33yZz0lT3Y9SliJS3KgS7msaaTEcd5lVJY0+d6CVJK2zq5c8A/VxM3LxZQcEb6CgjP/19b5213AeIJ9ntap7x4YEi3+TAj367lr2sYyp1LnekH8wyuMYElZV0R6Ug2XRFYEcJHA6Us2F6kulqmTNqGq4QAg6Hi8yh16Z3PYCKg/eKdeAAyyfsPhdeHaDAENHZeWhV6JiAPItnyYOaaaxmYU5H6c3oOnRyk7HbmwaE0F4NKajCSDKguiWsqtgBhwvcIegK0Mq+AEjFjKT0GsVVw62pR8JRH4apjuQ4XEmoNVW8Qjj
 KGGlzSo8
 ro1PJ1+x8Oa3QbnkL33dDqkd0lYWwYiwdDEbgZUtjQLJT6DmV1xjpKcrU7o9SIQwI51umv6Nd9ngBCooCzusZm8OmIkRZbe4+70qeGVu3JaIZplm5r5WjDrIEXEJs3WWo2ZOzLmawBFavkV4/sGxI35pe1m//xXdc+mwZF3BuPCBV0PgmSXVHhHukFAgU3IMu0VNP5dpqL04vIqra5rXy5BnV51cbthv/6AovlLeH/CdYB3YF3byBP+soykqU+7tDyuKUers8j7IjnbZezop5OBGJzRdNkWrZD78gdfaP4dg6x8oyWn0quehfOO67OmYAVpYO2uBDElHLBo1g0Rj47xKSU9o8MAmO/FWCmfQPzdJ+0d6Plhs8zwH/Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In native_stop_other_cpus(), cpus_stop_mask is initialized to
cpu_online_mask minus the calling CPU. However,
apic_send_IPI_allbutself(REBOOT_VECTOR) uses the APIC broadcast
shorthand when enabled, which delivers the IPI to all physical APICs
including offline CPUs.

Use __apic_send_IPI_mask(&cpus_stop_mask, REBOOT_VECTOR) so that
REBOOT_VECTOR is sent only to the target online CPUs in
cpus_stop_mask.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kernel/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 985103cab16c..2449d15c6667 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -192,7 +192,7 @@ static void native_stop_other_cpus(int wait)
 	cpumask_clear_cpu(this_cpu, &cpus_stop_mask);
 
 	if (!cpumask_empty(&cpus_stop_mask)) {
-		apic_send_IPI_allbutself(REBOOT_VECTOR);
+		__apic_send_IPI_mask(&cpus_stop_mask, REBOOT_VECTOR);
 
 		/*
 		 * Don't wait longer than a second for IPI completion. The
-- 
2.55.0.1082.g2b9226bbc0-goog


