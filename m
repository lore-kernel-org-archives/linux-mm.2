Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A0CCC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:47:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA78D8E0006; Wed, 23 Jul 2025 06:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7F3B8E0001; Wed, 23 Jul 2025 06:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA0A8E0006; Wed, 23 Jul 2025 06:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 819FA8E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C8591A05FD
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:21 +0000 (UTC)
X-FDA: 83695202682.17.3BE1C0A
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id 66614140006
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cQ6cznDR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3tb2AaAUKCH4vcddciqqing.eqonkpwz-oomxcem.qti@flex--tabba.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3tb2AaAUKCH4vcddciqqing.eqonkpwz-oomxcem.qti@flex--tabba.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267639; a=rsa-sha256;
	cv=none;
	b=q0nkqzuvciCdT+9nC28lJs9NkdUGnNoo9XSeHsgxTJKEFOGdL8Ee8J/Cj+qESYBdx0Jcvd
	PbNjJKfeqE7ZUp9MIoO5xgACScdutonoqXkMVcLFU55X86svBxH6p9N83Dct7O+CbIMZ0V
	//h6ziE7G9UfslH6LLzwseGS1hs8aQQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cQ6cznDR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3tb2AaAUKCH4vcddciqqing.eqonkpwz-oomxcem.qti@flex--tabba.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3tb2AaAUKCH4vcddciqqing.eqonkpwz-oomxcem.qti@flex--tabba.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tzfZi60oZ9UO8raD765xxT1ZFhO1WsdtivBMYCkRGQ0=;
	b=Bw5ORvbSnDQlKKKoShnbsTl53J2sA5tmAygThWF22s1Myt3Da4Zdbt66a8J7rLSXn9BVeR
	AM27vvDYVC9sdw89UNNfaYJRsadoHMOjmJkjLNu82oK0ESbNkVNxdl2j9/9T782hnQCX51
	/LEMcobeKjEg4txhb5GuaywHYQHlWYg=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a5058f9ef4so2561834f8f.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267638; x=1753872438; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tzfZi60oZ9UO8raD765xxT1ZFhO1WsdtivBMYCkRGQ0=;
        b=cQ6cznDRz3Zjf1PTFRImt4FlLI2/yFUm8R5BwsnRmtLKKQBqksNJswMQO2nDYAAZuE
         zXxo89h9XA+kM07q6HrlTigf9A3vwpEpov6IzDkaPZUgXA6U6vSt0z2oQ4SaREWyPjq+
         HS6DFuEk9IxA518Ee6sp5978aCVkuAzt09pyzZhBGGJNRfsLZRuRcg1mpLQtwraeI/W/
         O/zBZfRMaWaD3vEUrJ4tD3eNyZVnqpzrFhjk1kE4MQQfxQk9bTl13YycIXeNrT4XnJzr
         tZelBif2hEHwdX7buY1jwgP9CaOHro5INbjcydUXh7yJXQcCWAOZY/bpezFxhJG88BPf
         XX0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267638; x=1753872438;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tzfZi60oZ9UO8raD765xxT1ZFhO1WsdtivBMYCkRGQ0=;
        b=OgQuPQWIKhgTZaW8hUoDqL7A9K8eG4B6djZvVoQi3LtU3nlDpXJXu+dJDvFYUrFHr4
         V8u0JVZl+pR2H9iQ1Vp1up8FgRDXiAqVAHnv2oZINoBVcLmXkMLruEkb72Ue3739cTVI
         bfEaGX6eCeNChM7BdaODDKrqV8+MazHWLeZHIJ2VHyIPqciajusjg2BYFzsr5q6W1KOO
         0PcWq1W7Qiq9mnDL83ze0Js2dV7oK4PXcqYcLhh8IW5iVY+hyB9tWJEy5Daeyb/67vY2
         8yXlTtEMBLsle74yCyjk0M4u5fsxc2cCnIyq1+ItJxn0Hqa/+6M463iSKZl8xr4XDScF
         IXig==
X-Forwarded-Encrypted: i=1; AJvYcCVP3qvMDrUImtSsNdS7ZkrlpEu+HYTQUV3IPEwmuTdE6GIjN+/RZKgtUtFB3H0i8qWLasv3Arraow==@kvack.org
X-Gm-Message-State: AOJu0YyRdu7E/uXdH2g7jrAa2jxlbovddG+9i5K8p9kftzgp13x5+6wB
	Z/FZ+HeTodh8p1sNSjybFtHGGTpbyfN1b1+U9hTcKHVpZ0ntSpS9DydRyWq9QTMElmXgUOB00ZM
	tyA==
X-Google-Smtp-Source: AGHT+IEo+s/VxPokXQ2vXolGdtsGLlmgFDoyNvmXKyvht3UuZi1/vOjCI4q8w/CILxGvMZbP18VFTQSgFQ==
X-Received: from wmbhc10.prod.google.com ([2002:a05:600c:870a:b0:453:6ee6:e62a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:26c9:b0:3a4:e393:11e2
 with SMTP id ffacd0b85a97d-3b768ef9646mr2055449f8f.34.1753267637872; Wed, 23
 Jul 2025 03:47:17 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:46:55 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-4-tabba@google.com>
Subject: [PATCH v16 03/22] KVM: x86: Select KVM_GENERIC_PRIVATE_MEM directly
 from KVM_SW_PROTECTED_VM
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 66614140006
X-Stat-Signature: d4gow3g6b3t7bojamag5my9fj5ji5jgj
X-Rspam-User: 
X-HE-Tag: 1753267639-483521
X-HE-Meta: U2FsdGVkX1/FpmSdL0y4z5iwRVTJSG9r5aIuCL/Ie+BZGfizcKN1HzYT+CQhKeXdHhTw6MxrKpIUb/LG51UGlrxn6+jWyV0tftwztrg31GKsNvQPHOY4NEXB5zC8jVZw54SeTlhJ5itdF7KsIg0BLMNe+tAZBkwXWZ7gjZkgsJoypR9fTcU4rgBuYh54UE61/VCn8GNInhZTwYVOaYnFc005aoeWXXz5EHBqeH/s3aN9oQ2RE2mHJuB/suOw5eWBsVAQHuRWSLB68Q9lkyyYf/NZoz9ct3XaFACggUg1pTk3x2xlBS34jR29paV5TEQQjUhzRHvwQVlm6fU85FcdEIXociTYpKa7LW387Xe8XpxpSBm4ae5ujZtacwKvka9HOgiq9sIjP7xxe2iCi5/DRDMlMwmWbVufMgJnCigwhyYdGMvyOJWhESTomJnrxRMbbQeJImZh9CCP8yrQSc3IdZ3aulV3VvZaV/dMSqTmFwMA9TfSjvYy1IoZekqd24INYLqXEZgytrgzIJ2FEX3+E1uCT1sKwC9wRXfcWVdJG52/f01+6iso2BC53IGZvAPgCA9WHCry3ECH9LIe5Rs8J+xNdqIokoexnFzqOtUTh8uht2FzhU8c1ZZfOl7KS9TcjdPFCcM3nr2JlAbZsvDHBBH5ZnkOVdRA0VkofOHiJVHIV0/MfIkOl5AnTVSafxK28ACkkvgNfOjd4FmOadbNIXi62njw9GvFqK2/zTRf3RoMfiwi29YQ+az+7bkFd8BCijF3v9+oPUH+xa+IM4qGqAkhWm815McHgIo2YBjQjTZ9fYNKKvXlp7pm2M3kkVzlL3Wubk9W6SJqk+fgZbT0uSIiszZxxL7UkzetFZ5wiEeDMgVeKf03XCgRPScsoHnRlcbImy6RqL+8lghTAURtw30dIc/Lj56JD6PrLwuv9vlZOy+7E7y+8jsntSIV3OLk6N61FAo2tuGw62mYfiH
 Ng1x0E+4
 F9xnRq8fdPK9AB5IDXE13877QIXHR+mtv87mn9nedwxF8Viaz6pem91LMVC/SoVIl0n7d0ijuxxyi0+XNP+l64aKgl0nvuxbQaBsu+/PLtT9mzzBuOXftpR6M9/Z6VSyXIvge/kQgIhg+86KSTsEP4BO5iyC8fkxROxwVzuM2nHDFP82BdFycX2E+nrz2j59QLppHbXtJlpMc/4Ps3cy6S+lBe0OkpzZiQmCDH2dMhCKMw7mRse248o3BOeiEX3rdJqczzujW/eR2HCzkCU+y+YCKRkFsFtuXhs3GBpsBViHytu+mPKLEHkLYxRShd0GqXgB8bOrYT/RMsPbJgmvlvvsQL8sXd/arKAZPiPMw4YbJxyvjc474/8vWu9QJx6oAKns9IzZAMRxb/XF3JY0TkMYvEMgeYwciO197t4/XVLRUw20WiGeMfSoqTXlVGG19Q42qH4wljCv9GwPfrjh7E5Tty+GkevGhRnWFlIQdpgCmphKy+blgrnonC32P7Qf+7FHWEYyZSWuimW77gd27wTSPxUA4x+H3rxXSLcKgdPxYwnmTePzES0T0rgET76/myiSD89iEITi973yNTdmP2u0azaBpzeXEit6iSvvo4Ddqlo0+QmHnhIxcsQ7+krcjzgJcQfQxVUpebC+hfb/4PKZxYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Now that KVM_SW_PROTECTED_VM doesn't have a hidden dependency on KVM_X86,
select KVM_GENERIC_PRIVATE_MEM from within KVM_SW_PROTECTED_VM instead of
conditionally selecting it from KVM_X86.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 9895fc3cd901..402ba00fdf45 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -46,7 +46,6 @@ config KVM_X86
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_PRE_FAULT_MEMORY
-	select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
 	select KVM_WERROR if WERROR
 
 config KVM
@@ -84,6 +83,7 @@ config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
 	depends on KVM_X86 && X86_64
+	select KVM_GENERIC_PRIVATE_MEM
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
-- 
2.50.1.470.g6ba607880d-goog


