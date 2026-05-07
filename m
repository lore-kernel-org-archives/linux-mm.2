Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17D93CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453246B00D3; Thu,  7 May 2026 16:34:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 429DA6B00DE; Thu,  7 May 2026 16:34:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3408E6B00DF; Thu,  7 May 2026 16:34:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1ECAD6B00D3
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:34:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B832D4059F
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:34:37 +0000 (UTC)
X-FDA: 84741776994.25.852E542
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id 060C340002
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:34:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Uuvdd7ov;
	spf=pass (imf27.hostedemail.com: domain of 3Wvf8aQsKCJMxz71E81LGA33BB381.zB985AHK-997Ixz7.BE3@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3Wvf8aQsKCJMxz71E81LGA33BB381.zB985AHK-997Ixz7.BE3@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778186076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMq4ZGb8sxP9J+x/Ocr+9N7VOn891ReIc+MoQxb2Bzc=;
	b=REL0W/0VOaJRRDGPny12aNVTUSU6o6FsN/z4RDtld4c8Hz1suZgSOeqMNRIk/HbxvSDefR
	pSy99vX63a14CrTOmUuwjCPVylC/WKkJ2nddSBp8+g8gkpYBk/6Q7SkKcBYyE7Sre1yrwq
	LHvc4yE4gobatA1yKwkJTJB0T/ODsNw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Uuvdd7ov;
	spf=pass (imf27.hostedemail.com: domain of 3Wvf8aQsKCJMxz71E81LGA33BB381.zB985AHK-997Ixz7.BE3@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3Wvf8aQsKCJMxz71E81LGA33BB381.zB985AHK-997Ixz7.BE3@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778186076; a=rsa-sha256;
	cv=none;
	b=JElr4lIpkKCMufVgebqA/4VTAAK4V0AgLClmHyX9etWpN/vwagM8LqeRvIW5kDNRYCK5kv
	CmuTGryI89O9GMEvG7wKExcl4Gfk8AQKTW5+MGYuxGwK6ApmduJAHw9B4HOCXGAB4WInyb
	WsuBLMYxbgsv2B5tfMb8xMLoCYathwo=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3663d5e9bf4so507635a91.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 13:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778186075; x=1778790875; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wMq4ZGb8sxP9J+x/Ocr+9N7VOn891ReIc+MoQxb2Bzc=;
        b=Uuvdd7ovwQUawN5Dw9DaGXrXU3VEYpBti7UJb5KnCZByqD6DpkYlysKl/v2DaTbeg3
         fGyoXRv5RNEM1eOuXWZ6oP6yHYHiH2jAm4BNHVoj3Pc+9jv6SM0GxA+6uyae2duNWrsK
         mgO9hm2V0zfFY3sMqx5le1XPSc7Ejw3l1wE6VLvcupUn1AhnQocTSBZncN725uDDk7+7
         0MSPOREF/1Me8BKD5UHgQgf3LC0Qe8u0ZG/ycip026kK+NH3mUMue7tr9ZOvrGiWBnuS
         Mvu0JEL7Lh6+nanh25ID9ZShqaj0zvtUkYcM+iSGxr45yww9brwFxlDlktZSCqoDbwoi
         ggXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778186075; x=1778790875;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wMq4ZGb8sxP9J+x/Ocr+9N7VOn891ReIc+MoQxb2Bzc=;
        b=SKs2E5ch9yyCWPONp2BcJFcgRk0jgyF4V9cebX7xzg1etZX3uz1U+VNi4WsJYgV1RY
         WX9e3csEg7evIXpT/Y/uix5UA8kRyGkkntcyfGsTnhTZUvMSlZkuf/To9bDQYNtVR5Vj
         eMpA53d4suSl5lwngDTrpxF9pX5hYoYVMxWBdtDh7nH6ui6SAULuC9b084UOc7DMfD/5
         gR8z3A6QG21XOFsNsDf5LpLwhGfYSFPSmXtta2xOxejF0YKSfvPeNObdMjAe26Y/xQWb
         mvZG68txKUTlAYtMoD1qpLssvITfKnzjJcENfcsj3abK8Bt82Jn+rXLdUlIEcsQAu+QU
         Tp7g==
X-Forwarded-Encrypted: i=1; AFNElJ89r6lTL6uvsyU162DV+fSIG7E/YYcS+/qsQ7vGY7OC4O93MVmRMPGlpwhPXKDJVPs9wLm3lp8sig==@kvack.org
X-Gm-Message-State: AOJu0Yx1YG2uyaFzlDv7SEoIGr/8uL/AoMj19QaxGflYkrN9bob/5jTh
	jSzOAT65dtUxY/rpoeAtQeUwN+ou7Ab6AsaorZhdBHJj3cyfOt6Pzr2HzKCObLiuIdcu6EuFHCY
	uKrdKL+BtD9MT1UM0PblT4+yzZQ==
X-Received: from pgbcs6.prod.google.com ([2002:a05:6a02:4186:b0:c7e:68a1:910c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:1584:b0:39c:c07:1450 with SMTP id adf61e73a8af0-3aa5a9da657mr10646690637.42.1778186074357;
 Thu, 07 May 2026 13:34:34 -0700 (PDT)
Date: Thu,  7 May 2026 13:34:21 -0700
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
Mime-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <cover.1778185936.git.ackerleytng@google.com>
Subject: [POC PATCH 0/5] guest_memfd in-place conversion selftests for SNP
From: Ackerley Tng <ackerleytng@google.com>
To: devnull+ackerleytng.google.com@kernel.org
Cc: ackerleytng@google.com, aik@amd.com, akpm@linux-foundation.org, 
	andrew.jones@linux.dev, aneesh.kumar@kernel.org, axelrasmussen@google.com, 
	baohua@kernel.org, bhe@redhat.com, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, chrisl@kernel.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	forkloop@google.com, hpa@zytor.com, ira.weiny@intel.com, jgg@ziepe.ca, 
	jmattson@google.com, jthoughton@google.com, kas@kernel.org, 
	kasong@tencent.com, kvm@vger.kernel.org, liam@infradead.org, 
	linux-coco@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	mathieu.desnoyers@efficios.com, mhiramat@kernel.org, michael.roth@amd.com, 
	mingo@redhat.com, nphamcs@gmail.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, pratyush@kernel.org, qi.zheng@linux.dev, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, shivankg@amd.com, shuah@kernel.org, 
	skhan@linuxfoundation.org, steven.price@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vannapurve@google.com, vbabka@kernel.org, 
	weixugc@google.com, willy@infradead.org, wyihan@google.com, x86@kernel.org, 
	yan.y.zhao@intel.com, youngjun.park@lge.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: j8caomjw4d6rqh6jsnookbn937znamjj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 060C340002
X-Rspam-User: 
X-HE-Tag: 1778186075-417279
X-HE-Meta: U2FsdGVkX1/drfKXeggDBYUgVuyAGX33AQgLTpePvV+Qu14WWtGP/ae/iA9pK9/kpyPFaJMgARzdApIIj6NE6Vv+rKh5GV0qW5EMftPZaF7UABFaDQPGCJHcGGVX2/s9R4pf7ZGzPmHklQ+obr9ShJ8OdBFVvcq7H/aBA6TRH5nvfm4k7uBhLnBIqig/FjUuKoq8buPd4X5H0AC9Z/PAXs1pXumUfLUV9UwO+hxG+yV4LwRx7Uz5Mz+hUOKco4r8GEgF8miD4EbD5fqLO9K354VA4OzpffztyPIlyTuHHV88fGEJlRJ6nxFytB4HsK/476i6dDAMtYybqh/zfwSFLRdHhG9H4NT46DPSNEQEnWAuxFXijB2Hg1c888AnvulIvs9NDhvUQ0nU7o63Rgis6xbBS09Ep2FCmT2LNE3NhRk1R/VNVHDNu4mx3Wk3BexZuo+YhkAs5iRR9LhYc7OwwtdnA9LMBIpNyACmcnQ9JLCJWDsBQbx/mfaSgN+jGkXkzlloGraRjNIZmpmtSTLy1c3eIm11ow/8h3fcwNsPj6RBsm/LIVkyUxD+NKwjDggaV1F+HKS4edBC9tgFTLc1TmWyfVfhOLZAd/OjZ38VZLXDRvI3PJz5JxC7N3DZBLfkyp7BNPF6wwhUn9AyAZ6EuoGbXX23d33nmdZSJaXoaCpt3f5Fz5sbyVoMZ3boAdQpj31ORDr/wJBtwxz5qZR1MlzjawnMkATTyIThc/FRxRnX1+WG3VAtx6qVvfiCCDOsHj8t9KSfOJY/rIOV/tVoDbDYJU/UuflLK5xp70f+JRyHhemZPOzG8E91ab8PaSwIMTCykuN+r0pechXCRHieDqflfLILQsX7XdljkDMhgMgEBq9KAo13YS1N/J0v0SuvKnzSSr/tcWPm2pWC6WSzrHsAr9tnNs97LTeTCEwXXaEjj5Eqq76K3JrrCrYTaNwwhsnV5qYO3iexIgV2GoN
 NPEV0KmQ
 Vr++U5kStEqWSDirqhYdTEWZTRaDOTjH74tVc8RzhD9RkRXPZFMoVl8txBvCBYo17uZxtdsYVNoN4FQKuMbz79IwahWJrjDFXJFQS7IH3h9SSvstNXMWxpY0dE50/n88m13159QYF7B7ltC5bL9hKmzQJyI5RaL6jZjghq+68X5I5pC6auHjXBqOc2hN8rSAQaEN1nnFpYi4HK7d+PvD760Zo/YviaE2BSd5k9FkwjmMeXB5Cmt1q4WH+1tg+cPCDLnwWrO585JlhZbCBAFhezAIjK9jlk1zFQEJjQnZxE4hrkxfPq9QJBHVGn1YcWb57iodJys6r3W1shf0PnZP4XqhJ00UHWOsh8J+3cNWg9UhwiP5EY18QLrnOWo56Vui3R639qe3LwsQ980IWiKnw/XofiQxRakQ4/JyVFmj/Iyy/T0du2Z4dtHZO6eIRdbI1tq3mx1BTvjgbg6q4kRdkdQA/ujg3dzWsi+JTQUovJgqLG1wHf30jS68PyMLFKTGBEJIFOuo7lvI0Y0LTKO9VWK1qbJ98rDMaykt7lAYsm2+fSvobqC7kBLL1SPmcUE3ix43YqXEnpjtm7YnX0CPs+oyOHim7oDxvaDeodfbys9kYVqx8Tm/Tdal3sGsspQ2OzFxxjgLhnWWy5c7TfhB1BxhVKLQIJTH5AUmcPEVyez1GmBRTFrDySaJY7pZ5Bj56wRct1qOk/hxatj1xKFaZHXb6im1mepiUaFoJiV99Bxw9o/dq/JmYUhZPqVEiDCbYdR8V53tYI7zNrDzzTbggNfPjkB7Sz7czOLUMIWkNs7GUIlDFJ5O1e5WRm1jqBZtoI/upvERL60usphI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With these POC patches, I was able to test the set memory
attributes/conversion ioctls with SNP.

After allowing src_addr to be NULL, SNP_LAUNCH_UPDATE can accept NULL
for source address and the SNP VM runs fine. :)

Ackerley Tng (5):
  KVM: selftests: Initialize guest_memfd with INIT_SHARED
  KVM: selftests: Use guest_memfd memory contents in-place for SNP
    launch update
  KVM: selftests: Make guest_code_xsave more friendly
  KVM: selftests: Allow specifying CoCo-privateness while mapping a page
  KVM: selftests: Test conversions for SNP

 .../selftests/kvm/include/x86/processor.h     |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  12 +-
 .../testing/selftests/kvm/lib/x86/processor.c |  13 +-
 tools/testing/selftests/kvm/lib/x86/sev.c     |   3 +-
 .../selftests/kvm/x86/sev_smoke_test.c        | 222 +++++++++++++++++-
 5 files changed, 234 insertions(+), 18 deletions(-)

--
2.54.0.563.g4f69b47b94-goog

