Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85EB1CEBF88
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C688F8E0011; Sat, 15 Nov 2025 18:34:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18858E0007; Sat, 15 Nov 2025 18:34:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6478E0011; Sat, 15 Nov 2025 18:34:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8938D8E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:34:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 51BD31A0863
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:25 +0000 (UTC)
X-FDA: 84114447690.21.16F02D1
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id A8D254000D
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LuejERYL;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763249663; a=rsa-sha256;
	cv=none;
	b=tG/KpLKsrleuClAdtbRg4gzxHWJOoqcPHIakNKEg1kJFKqdJu7DdtQ0h/2XCGYoMoodk6t
	gBECUNJK1qtynJCybMgT2/dgIDnC9r9Czn7r4TUnHklMREvY4PsGwJhR8HwyQwPvov92Vc
	yAfUVq0P4dVrCbEi6gwHm5z6YlW9x+k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LuejERYL;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763249663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffF6ShDH072kEeRsAneEmG7BXpD8z3YnDwKiTvXVzXs=;
	b=l/JqvqzUGZ8s3V9E1gz3e6Y3Z3WGfZ2dVeTvTJA0YcUHRU04c4jmuq82Y8b/nE0ld6kJPN
	kY9yBr5NyRBownUMC2ZbN+9NA1zUctvGMgtpE4IsKfUhOdycatiC8osakxynxQXeIt06Lk
	crqP5gnjduGhCP08zyglnDUFq6Zg42Q=
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-63f96d5038dso2589021d50.1
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763249663; x=1763854463; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ffF6ShDH072kEeRsAneEmG7BXpD8z3YnDwKiTvXVzXs=;
        b=LuejERYLZQbVVz2FQwz48OW6WYgBoYavLG3JM1icVmLAVtLwQ/Ie0weV/XAKcwvSLc
         /hWiJPmuP4PS3lPi37adA9bMZytvQGuyNfdqbqujdtSzmqKpWNHnYZpaC+t0qbpPYF1a
         VDSQupQbl7lwAleLWo93WbHvwdF5ye3BzR5Ug2aaPVPFTy2G5jBbowhSoWw88WY3XEaW
         JezVXlGSVv0O141iR8pNb1U/kiutLxvvRNwqscSFydRhfoJXBI6NU6bagNDlnN5VOSXq
         t+NvIeQ2rds0ba7Vxf2JqyaQedjk8Q2KakYmVn1PN7f1fBNGyliWgmeg3r/Sy+spSgYe
         SGIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763249663; x=1763854463;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ffF6ShDH072kEeRsAneEmG7BXpD8z3YnDwKiTvXVzXs=;
        b=ik6VGww/5TycpPPzrKHQ5Nk9cwjvDhVSM93AZi2r4VYcAOl4Roh074v6jkhvAG9DyF
         Zw8PkE4xanb15JJg4jKmjpDF69nhgSE16AkmEXOGpTPoybe7EzplYRBE7SKMJUjGcPQA
         vX4BiVKTuK2wnYdfMN4Eu8cC5Te2KvWZRMmP9BjWTFbWoR7AlAd/Q5CWWAdZVZ/gKTo3
         +xib2+zqk83FxrbavNqEjztPlF0Q/Df/RKNugpSeinYZSmnZrn+cuNW0W/71eklRiAk5
         Di9iqw7iuqD8ul+k+xrLo5ibrst0gMuIjxMPp1/T8xWn1LXetuyw0mX8Z5xinYNPitFu
         5Yhg==
X-Forwarded-Encrypted: i=1; AJvYcCU69/gAoqSicW+o+2uw8BvmF5ffBi3i+ppIN8mSrvMNnfckOIkjmbdjgvpyxKR1YCbOdnpz/NKT5A==@kvack.org
X-Gm-Message-State: AOJu0Yzy1PJQ5t1mjEEfGmpxLvs97KyZQC2/UJSguy1+TiujNNeon2qa
	gRc09M76hKboY4Fks8/+uk61EReADunZ634baYqvOZJdW/i7P+PwAbBQs5CbICgStYU=
X-Gm-Gg: ASbGnct7D0yEZOHtBRTjB8L9lpF5/fiDLtkfYlgtNwKsWHZRWA+Z4EwyAkibTAV3aRL
	aanFIpWWgBrInygGvTNTzwRlUmbJewWiL2SApIlHQB+lDMVFqc3U93nUkiOfDMryNUgtc2h2az/
	7qzKFDXuTX++lyQXmSXo8ULm1g/00Go3d9/cmOQwK7r9gLNWDTvegaLjWBnHp45cVYxZitupBEe
	KbA7R7wWGa5IJDUuZGhttDKhESdC4MBLz0sbfgNbIz0Bdq5qTUiMSI8brrU9844hqit9QYDjZl/
	AIMrqmHLDKqZPm5CX9vTuDEZi2QASU6l1ZJSt1u2S3dZGoOXqQyRXu5x3rSBvFrO3DR6kHRTvlJ
	qy0FBtpzcGaCLSoRpAcAfnEwQjkJpFNreb7QmbrOTZhWgUkSeBB0QgVB75CkAXHAWWFZ3wtMFb1
	xoJT+5o9rFCaWY4RPM9aUv+GJqqPM46/bVULPu3xzo6tmtl3m/M/JPo4SEkuSPsub8KA/fgcSRE
	7i4m8k=
X-Google-Smtp-Source: AGHT+IGaaou1T8IlNwnvhEGAvgtl5hmvWdjNxQr9knw88/sarPOBHEpKzr0vdGK9CACIRmLZkXd5Qw==
X-Received: by 2002:a05:690e:4366:b0:63f:b6a4:dcbb with SMTP id 956f58d0204a3-641e76b2c36mr5840850d50.69.1763249662685;
        Sat, 15 Nov 2025 15:34:22 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7882218774esm28462007b3.57.2025.11.15.15.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 15:34:21 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org
Subject: [PATCH v6 03/20] kexec: call liveupdate_reboot() before kexec
Date: Sat, 15 Nov 2025 18:33:49 -0500
Message-ID: <20251115233409.768044-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115233409.768044-1-pasha.tatashin@soleen.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A8D254000D
X-Stat-Signature: mfe7r1zzp39p1aqo8nrxxig9an1xfcf5
X-Rspam-User: 
X-HE-Tag: 1763249663-374034
X-HE-Meta: U2FsdGVkX19OQAdUKH5Yf4ZGaMtiXqf0M0ZJ1nxc6v2+2UWuvnOgusYQvmxG+WxlRi7jTNSwxplHbqq/KeRCmyAnPRxQj/DxpNyP74gxk6VZ+UlYW6V1jGHPyKzHlqpZdSClFJ4+JtVClLf2WdpH6gM4dWFqg2nw/Zv6Ri2QHAOeADzzA87GCN2GWzjx91E2t5XYtVl3pCZtJYddWCCgprWobw1XphyVl97wiu3cHYeM+a7NeqKQbm+vBo5BlGru8RgX7CNAHjwnWtUG1DKyGctf7zp6LrdheXMmBvFBDR7RbdvOJYq1pgpkCWm+sSGCmbd6bscL/gjANAufdpyCBvRU/p62UyqrPnTB83gqyZd3+STW6POvsN3TdrBlpcUuVAMAOxrAlS2z9Q6zf01mi1Ao1vxu0cyHNQHp9Wxc6MaC1R8bbkW1Hl+pIoGPK4FU5Gfprn2oeS5UgJmnkfPMNaLOxk49MEcrJfcJj1kgCpvCAGv4oM4f8I78MD2yWP1Gji+1QRg4UFqAr1d7K/yIoajRQm8YBfAjkJZm530R023Bx/lekaY8VaJNstkYNxBpkkmSsNcSin6APTAiaYTWF03JwVkQs1PwDXDFp2xZttuIVCzwqiM3SYfsC59iBFEKvOOSLEE3k7TB7lK8B6qUB9/nNKW6/szBMbJGwAD1AZ2Pjj4KSLZQAyeFfp0g1xH2xAzea1ZtVUzFAVlmaE3qnKZqkS0vzXyUkYYrY98Wv5UIpykeGBMicOvk+X9DcNWShB1bSvLpcdhGO4k1335iOMr6ACVWbhrxjhowkSf7Ef3FmP/O+bG5jUVDjrNgN7GKnCAzCY9Wrkq85N+zpnZ6D5yu78d3Vr2eltICxiG2ECGwdZd90nNN1CDF7T06c9D3SykZw/7wvBjnYftMwmMtKSv+fHxtUR0VD2gSDsx9db+CgJO6ANPS04i8an7vKov5E9fTsrjzxdIW1BKTjLn
 yhk2juzy
 RldP/zYSrBcw4qTagTG7+EAGVuXz9dcGBeCHt0fcjhUTPH45vg7C5GQA0jRfv3i8YyEOtgl6sbSn4JKwgY5gt2+QtH5NUCXGDrWQsbjZ5Oz2gokFk5wdKH91ArB+NbVG74YCCMuBYJuMgSipDQ1HLf5A/Rl+JLSNHYjzV3ytJb1eRxXk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Modify the kernel_kexec() to call liveupdate_reboot().

This ensures that the Live Update Orchestrator is notified just
before the kernel executes the kexec jump. The liveupdate_reboot()
function triggers the final freeze event, allowing participating
FDs perform last-minute check or state saving within the blackout
window.

If liveupdate_reboot() returns an error (indicating a failure during
LUO finalization), the kexec operation is aborted to prevent proceeding
with an inconsistent state. An error is returned to user.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/kexec_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index a8890dd03a1d..3122235c225b 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -15,6 +15,7 @@
 #include <linux/kexec.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
+#include <linux/liveupdate.h>
 #include <linux/highmem.h>
 #include <linux/syscalls.h>
 #include <linux/reboot.h>
@@ -1145,6 +1146,10 @@ int kernel_kexec(void)
 		goto Unlock;
 	}
 
+	error = liveupdate_reboot();
+	if (error)
+		goto Unlock;
+
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
 		/*
-- 
2.52.0.rc1.455.g30608eb744-goog


