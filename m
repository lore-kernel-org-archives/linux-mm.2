Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 086EBD0D170
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 20:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 730506B0093; Wed,  7 Jan 2026 15:32:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DA256B0095; Wed,  7 Jan 2026 15:32:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9F36B0096; Wed,  7 Jan 2026 15:32:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3C56B0093
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:32:46 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E569759039
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:32:45 +0000 (UTC)
X-FDA: 84306316290.10.35412DF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0BC4B120006
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:32:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="hEbYo/MO";
	spf=pass (imf29.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767817964; a=rsa-sha256;
	cv=none;
	b=vasgP/GIYL4brQX23m6Lhy8G/9ZwiE8HFYgxh3POXwYzvoAShvpx6xHohbTEUSs/REu3Tc
	FYE1lW2ioCwfH2cXvhcsfQ746urmP5ts+xR50x1+GjkPYr66i2Ma1axkqsVhzl42ppbTao
	iWV89n8LQgOFZ0XijILzAmFzYigGyxw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="hEbYo/MO";
	spf=pass (imf29.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767817964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=w4w0YXsQ4tHqn86Cdn9lgCFQXlRLiJdMmnLM/2nY/7I=;
	b=Ttx8tl9+fmxrHy9RDug8RpQ1r+lEydiVmVn53d96QXugFCpUFkX0jyGv7BOyryQxP8l90B
	o1EnFLI37YdeNJCjLLDY7nTbwGSYaajioo8RWCt2amnp0hl8jQ5LBMNFyxrMcQ2T5Jq1Og
	2w2Lj9QEa39U3iPHZF+lDVy6YIMpJX0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767817963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=w4w0YXsQ4tHqn86Cdn9lgCFQXlRLiJdMmnLM/2nY/7I=;
	b=hEbYo/MOi17uwIfBoaoyQuC/QiIuTin3PVacR/F2e7kvmk4cjTGL3tyOfu1GL0ZWe5Ao5k
	mYL4CdnY2KTw5NcWrgmLFsUyhcDM7VxnV7Ok1wvOaCoF01BHsQMau3shuPbe18ZHO4WN8g
	6A+cGd3D4VPUnOSAu56PHyDwxyv5jnM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-397-tOaLPL9DOgKv2Mj1GCj-kA-1; Wed,
 07 Jan 2026 15:32:38 -0500
X-MC-Unique: tOaLPL9DOgKv2Mj1GCj-kA-1
X-Mimecast-MFC-AGG-ID: tOaLPL9DOgKv2Mj1GCj-kA_1767817956
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 56EAF1955F34;
	Wed,  7 Jan 2026 20:32:36 +0000 (UTC)
Received: from debian4.vm (unknown [10.44.33.27])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 5091F18007D2;
	Wed,  7 Jan 2026 20:32:32 +0000 (UTC)
Received: by debian4.vm (sSMTP sendmail emulation); Wed, 07 Jan 2026 21:32:30 +0100
Message-ID: <20260107203230.880324802@debian4.vm>
User-Agent: quilt/0.68
Date: Wed, 07 Jan 2026 21:31:15 +0100
From: Mikulas Patocka <mpatocka@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
 David Hildenbrand <david@redhat.com>,
 amd-gfx@lists.freedesktop.org,
 linux-mm@kvack.org,
 Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>,
 Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v4 2/2] amdgpu: delete the "Failed to register MMU notifier" message
References: <20260107203113.690118053@debian4.vm>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TggXv5OKyuEByUSn_loSioTXr_yJVoXCD1EcWGtTHSM_1767817956
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BC4B120006
X-Rspamd-Server: rspam04
X-Stat-Signature: f37zkgogg3da4x4rqwixi6ixxypaciwo
X-HE-Tag: 1767817963-400237
X-HE-Meta: U2FsdGVkX19D0fJLTFybqs4jl3dOsZ/lBgCF2k0cIErYIuIdJKO1bWIm8S6sFxvk5ZD74yvK33M92T2IlZ8Xwxv96swfuT/m+HjNuZNtpaPRpUzgc962uSUIZJRBi2i4n7ZWZne1nwTHUPkcAStcVRIPS9ECXA+60IdxXdJm+t5g+7tXdDE8Zcbsn2kUfNJXfI4+Y2nW6R73LwGnlpxd/FabNUlLRsGdFVJRbRHyZ5I17TzcBldDJKiKFt04Yyp+9vPY4UX2h4v33+G21mgBShk1Ciu6Nnom/WyDiI/9zWviMLnDvpSftgGNQ2940vPesY4F7yahgp/p5p2lIocFNg6QBLvIOvQyzz5Vu7J3s1Wmi+RsAszyAm717Pnu5qCft+0KM6wTAWDKCDbBVwP3ud31v+OKDtEVNUQE2HVQEddva6ikveIwdnIT1NTEIqRfjOtcFPHQ/FzhJ3Q2rbLyeFqzWSnw33PM9QRKitlIzI2zN+kyYMHkcpToAeZtTjkUAa3RlanA7kdCRx3Yzg+1ZimdoPskD07nzKWHWV8orvrRgTTnhxwNCwgX3JAKsKieMoLF12DLJScDgU+jHRkYJkh5GnJedDw1M0iFO37g//F7bawENzkI0WOpZmHTKGiXeuCxvr2B1l0dwWdhD4RUF1uhiszpyXfa093Kt8rL6gckVdWHbAKIt1nv2DzP/9VEZdNxBEcgu/qeVnRlc2dQDWdiIgHAumMfiQAeYalJvtvF4uJ6eBrPBFJRyuTEFHqhOTKf8m1KhYwnR+bG3Kbcwe2JrDQ+dknbHmblj82TrNsX4ZjI2miF4j7PpTXDoHm81Z9wKvKqBp/irhOVK/g5Aw7mxCQqOdNcFSSU+VgnK2mYYjjgSnw3AhzTwfu3kny9IY+xJoDL2LoHvxco+qKSJCSIoC6rZ3dHpkDtH5Ec4pA5fif5owZ0fLRAJeeiTwGeG5OOoDsOsKGf3lQHY/P
 H08pVUZO
 xhDOGZetTgTcT9V3jrSPhCw0dK5XJ2Mp6p04dqLpYj79WRaht/MyPTsp0z0F1B+/TPoOdZC8DWmc0M2ho2Y3kp1hUIrKymd2ZgXmElza+S1mIfbqJ8tD9pDce+Ykw37vnGXpc4AFo2jDL6N8bMjbChmko5UtTyOnDKxX3mBxFBp4BnLNs861Id2aq7xNDU+0/NJ5LR8FbVLMReZoJcWSLWviUsV+HwjcjIOxvS5biNf1Mu4bi16AvtGDPo2C8fMYe8wllHaBpNUXkNiff0z8KHiiIo/k57+cQLqCvuqsNbQY7KSHL4imW3DoEflIJfFAmd5HgKDyKsR960r6usX2OdwEhCRTzW9fgdAOW0HgiyUW+UIekp7PeqNVjiOQUEXFGFtpS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This error may happen if mm_take_all_locks was interrupted by a signal -
the userspace will retry an ioctl that returned -EINTR, so there is no
need to report it to the syslog.

Christian König suggested to remove this message at all, so let's do it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: mm/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
===================================================================
--- mm.orig/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c	2026-01-07 20:09:51.000000000 +0100
+++ mm/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c	2026-01-07 20:12:11.000000000 +0100
@@ -1069,11 +1069,8 @@ static int init_user_pages(struct kgd_me
 	}
 
 	ret = amdgpu_hmm_register(bo, user_addr);
-	if (ret) {
-		pr_err("%s: Failed to register MMU notifier: %d\n",
-		       __func__, ret);
+	if (ret)
 		goto out;
-	}
 
 	if (criu_resume) {
 		/*


