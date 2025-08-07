Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA46C87FD3
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C022E6B0095; Wed,  6 Aug 2025 21:44:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB4156B0096; Wed,  6 Aug 2025 21:44:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7A376B0098; Wed,  6 Aug 2025 21:44:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 96AF36B0095
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:44:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DD161DD534
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:44:54 +0000 (UTC)
X-FDA: 83748267708.07.CF97D9F
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id CA57280008
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:44:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XO7wNdo0;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kaESzk2f6ioxFaB+zOVCWa3oEolQrGNRo6YQh6Uj768=;
	b=X7coXFkwLUxY39LjGseTnJTzd+GVeuBUMxyKwx7WPxiOWG70QMvTfWU9TacyWiaXiVhvXx
	NEwmeEEakiiMG44CaCfpmbsG+hcscKUfDKkhHnUVmRA9+LeYPicnqw5FPwxLNwpoErx8mo
	rBGKQkEoc63iM+7x/VFB/jFG2170Y1Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531092; a=rsa-sha256;
	cv=none;
	b=8X4GUwYPcFaQRwzQBVGatmm5CNnSgRHGHh2k++78monV4TYCcb6RbDUSu+wvt3Mi8G04Xd
	VCW9iS4l4UjMNgJnzl0sDHNAT4oRM6xrjWtxVnVc/iPrtN50xma6vjnaUyJmPtumkFS9Bq
	942S4tP9/ti5VYGOatcKnM+sTZf4LQo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XO7wNdo0;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-707453b0306so5567786d6.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531092; x=1755135892; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kaESzk2f6ioxFaB+zOVCWa3oEolQrGNRo6YQh6Uj768=;
        b=XO7wNdo0xUIILU9XqUJfwu6KRSHEtYvbjmLaE6uwZH912yf29Ci5bEyjjN5cp1QCC/
         cYv1bK8g2hR8kbWMgHf9QfqNHdHnk4dFY/82iTvGJGQwdwWLiX6/au15SKyqpRqy50bQ
         amlWIkShiDt+7o+B6c17zxmIA6z61qyPWpL+30j5sbxnTW+n1ih8YhiP4MPNkBJzm3/K
         pIXio2IYq6c/Zi6lZXPcIMFc6wZpn8ciKDDmGbBMIulXGHIodVvt5fpunhOMd/5f9B1o
         +jwjZriZCaIWTA78SX6r2+u9j948war48wYxhSb+5huhoPYidnyb9kaDvpHZZydlO2vZ
         aBEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531092; x=1755135892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kaESzk2f6ioxFaB+zOVCWa3oEolQrGNRo6YQh6Uj768=;
        b=lDZWP+WYZMpixbS1A/W35YxXTHs0EmwSX9SoyhLjHwRGN3L6UxmiYGf5h4+jvBAWqG
         rGXdYs6d/e7etvG/x+2fwZoDXCu6Q6DJLygi+F1lgiIrpGAI4PLhSpTTEG3NGbfAx6qd
         +c5vRz7I3k3610Y9P2YOtG1sjLAvnOcIC63trnJMd+1oZ/rFN6K8cYJ843O8XXGU8vM3
         jsFdXDr19De9AlZbTKwBuiZWf8HBAG20jOnC1JJl5hhs18nxmd2TrczCkJgSM2T7foBU
         70POXivU9PoAWSt2gwl/WJqSqK2dIf8bnwjyjSb/tyxmwu6aQg8p5JIQC1sTZssL550K
         +aWg==
X-Forwarded-Encrypted: i=1; AJvYcCX+8upOR2jFg1RWgdGixXn/GYUxythxtvCB0e9Dlcl5bi5d2xtU1Y2EdWMMvcEeNRkieQlD0uMGnQ==@kvack.org
X-Gm-Message-State: AOJu0Yx6mC4Mv/C/KbwBH1D8F46OWJcfF1DWRsNne801YOTIzRQdiDmq
	xkOCtI0wEWV5WOmsTFhwLfDfCN4vsRqxze/7bPhzs+f21J+ttlU7UF+13ykMKNElE6s=
X-Gm-Gg: ASbGncs3me6e5ukgpplOd++rQ2FzZgQykZTCSutPm7UcDIl/w0MitPOAXLYtCE5I4u1
	hoIW+8yyp42qMJL0SqWLIu+FaqRninkn3WzKrHgOf6JjcWYCgcJkc8bkhLq+lTJNnUs3rtLGyxA
	pKC9LWSGdnh0VsZXlTxILfTnKl5fMb6SooT09ZfGmxJ9iWs8IfanQzUJ7lUkLFGiw3Qohk1Krpu
	RjYMffJrWJZkjm/GkpZHn12V3wOo884AFYcWReriAvQhfW6iS4JQ8VX//jbfKma96Ao+ij2W/HB
	dQcivTdUlr9i2gJxE/V41PlBO5At1fOUSJ4Xtzn82r18cO1FJYXtB9SIrvAeCvdtmGNybUYbAZz
	N8RnYRu8CMMe2EiRbceBOAdLCSKx7Keqh7ESsCnKbZVjsP+4s7xescnotmAOi4X03g51Nb00eaT
	VowSpSg0xSVBJv
X-Google-Smtp-Source: AGHT+IEyWMvTBlOM62kNmVMKSSB8JNc55ip6AvkaRw6dwIN2X5ATQTWFGGBA3z7kK5RTd9pgC648bw==
X-Received: by 2002:ad4:5f8f:0:b0:707:4daf:637 with SMTP id 6a1803df08f44-7097af1440bmr64537216d6.29.1754531091759;
        Wed, 06 Aug 2025 18:44:51 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:44:51 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
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
	zhangguopeng@kylinos.cn,
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
	witu@nvidia.com
Subject: [PATCH v3 03/30] kho: warn if KHO is disabled due to an error
Date: Thu,  7 Aug 2025 01:44:09 +0000
Message-ID: <20250807014442.3829950-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CA57280008
X-Stat-Signature: 6eerx9r53ojte4ynj5z6o8r6njw8c49n
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754531092-136088
X-HE-Meta: U2FsdGVkX1960tNQp8K/XfOaKApFVy4w6jR8yGwhzrgQRxa3UVZPsmGfM+pbl/gDSbtN7zcEmMDMAW2f++yGMT+QhnFJzyg3Xb618OtSTDG2MgCOjJotj12WgRla8XSymAY4RbSwl4C4SV8hE+Rr40C/d2k+iGu0RLRbh0zzNFgxrS7RsjoBPwN7hgBjDfsJv9HUdOaqQA7R7VNtUVjKxdjDcr9nwiqBz/kxdpZjTA65h/HS9FlAfjChsDJUC4H99eak3XcOFKAgrQ4JosB3GXHWVUFWR/uYrPCEckZPhPznuvz+B75AXV3xzAQKDJx6h0/2Z69w/Q8jE62VVHEy1E29qZfeUToVi3EICO427UctJZhiKI4yhH61o4oVEAD3Vzv7Z0AbUQlZnJS6yc0TyVTSqoFNz+cLejAEy7XaGIX2ix9OeR/YNiFyR+NbQrMZYcY0olQHWXGu+Uv4qA4QtOfkDNDwYTM2E4yaFKw3eeO/JAuyeN4ctADT2q6X0F416kl8xPPb3UBzUzLayzt+1LuGY+UjHMJv8M/Kdr03GeGZZkLllr/WGpqb4fIfWPe7s+PrUBncdgXh5QGUpUFmVqWfBvkMMaFXJTqaTYUAD3B77BV6xdjKaF4W0fUD9dLr+Mc6CsHUOspSVNoXpR+9gQmyeCa2Lgy2nV2ltBVAaJZehkLvOYcd3A/bpCZ6WN01EDr+4/nlvTpSThR+IYfnCDlhEdv5wZpzihPhNaMYQFcRbvejoMKWRPVVC60gsPfNiiKmeIaVOEDJSU3xlF+LbhtQZjpkr++brUQjdyUapJLQePogyiqVOE9ifpue3yYSPaqSXWFJAT9wg6k81D6QTA61hJngYHNOF4L7aNh1WZObf3CVagrbzE6T+6gSGm7g6S0mLQ8JDzaWGwBoNuR3lnK/JaYj9YsB06shcqnF85AqLcmtnIwf91JxcJymfqoKiUPzO7x0UfZdE2AYOEM
 3m34pxv0
 gygJ+CzzkDZE5MKxjZGED+Q9rrLxOp9ZS/FWGx+0FnFzyQKqKPl/gX+YkOLkMMaNwTjRL3rwiDCtghw6JAo1uf/pv7z9NgnDpp1wmYWmpqHjVV1slm41jdK3XjQb2Utpg9sVC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During boot scratch area is allocated based on command line
parameters or auto calculated. However, scratch area may fail
to allocate, and in that case KHO is disabled. Currently,
no warning is printed that KHO is disabled, which makes it
confusing for the end user to figure out why KHO is not
available. Add the missing warning message.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/kexec_handover.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 6240bc38305b..c2b7e8b86db0 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -565,6 +565,7 @@ static void __init kho_reserve_scratch(void)
 err_free_scratch_desc:
 	memblock_free(kho_scratch, kho_scratch_cnt * sizeof(*kho_scratch));
 err_disable_kho:
+	pr_warn("Failed to reserve scratch area, disabling kexec handover\n");
 	kho_enable = false;
 }
 
-- 
2.50.1.565.gc32cd1483b-goog


