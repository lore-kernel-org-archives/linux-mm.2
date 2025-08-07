Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7386FC87FCB
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DC036B00AE; Wed,  6 Aug 2025 21:45:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28B8A6B00AF; Wed,  6 Aug 2025 21:45:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12CA06B00B0; Wed,  6 Aug 2025 21:45:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFC4A6B00AE
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A150A5B85B
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:19 +0000 (UTC)
X-FDA: 83748268758.23.9AFEB04
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id D4F35100006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=P1QCwemr;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531117; a=rsa-sha256;
	cv=none;
	b=L4QXWUKd0Mu+sjqh2Y6v6Og1KlR8UhknFnZ7eIvKvx9h26krpSqrKqfkC3FEPHnDK3CFKf
	VVuJF/3qEdpc2rmS5qxqnyelsrKnt16dZ+i7WT/8Jo8K3pmw+w/xhUQHnvsCmwuOe66LyL
	4VIqrvEVcAfihHtYbNBzekupbzfBV0U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=P1QCwemr;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WtKfUzOgupFaYotRf3a7eOnx1rqlnB537wzbb8Z3Bb4=;
	b=6joDLIlo98Kr0GsodtXvLsI6iL/zvIU6mj/pohUvmCF1NoJsgdJtxpV3ddCH9BqhpOSIOM
	LUn7vK297umU3cLlROv5kHTtgybk6LU3GSvYaNa08hKZexUZWNZeDHggcxufykjia56gyw
	yqs2/hVqMmLf8g4yXqWvrxcStPjfqTU=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-7074a74248dso5529406d6.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531117; x=1755135917; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WtKfUzOgupFaYotRf3a7eOnx1rqlnB537wzbb8Z3Bb4=;
        b=P1QCwemrDhdEtk11fE5mvT1TK3Cn2iO1miQh5HGjXBeZXQYMDGUjxmDhJvMPf97XHI
         TdUzVu6+n53vy9dP61Rdk3Wbu1h5ArV3jxsqx7q/sTzCuj3KKbWNLX149PEmVeMJ17vH
         9zoCki4OSHiaRceoqHHHPpXXPtKb2xHAn3NZpWmU77iWfrYYppRa55G28ILc+rGiciDh
         mq2mw6J4wpyuxJ78P7YvPG/oDon1+3fblCH952uE5JXr4/anHoFcj8I3KDmNNkWoRZGS
         eDVo0UyCWemzt/y21ekAInz2o68kHI9e32G3IJAEWBsrYS6pcc/Br4awlnY9/N1jeSRG
         ftJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531117; x=1755135917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WtKfUzOgupFaYotRf3a7eOnx1rqlnB537wzbb8Z3Bb4=;
        b=vCZc4sToyZLMhHLLiSFL9QHjdxnnf18r2xPdfvJMwhu09ZwKEVJcfvjWlkiQ43/nYw
         sQdWpolYUTB8s6g2Y/xeIyjLEYzt6heiUJj8z6rZW0BxTDGDfLrEbzHGaOPExckSomvX
         derg0DEaEnqrbHKSHGFuLUEsMBE9WZIxIJd80e5La7wD40CgeuHO1ejKYE7A2vobugnF
         SvrmSa4W5XjMygAEvRUH97U2YUVMae/sSQMFyyREgcXmyEwAGI6i3dfJpZB8MQjWF+mr
         oQ9Aatr4wIM+HyabrX3RjzEm0/+RbzbT890kopX0HQEzJPorczUYVT9G8mrfLtPO/tHV
         OJzw==
X-Forwarded-Encrypted: i=1; AJvYcCU6/wqNPxgYCRtx6aKZCgGr6iy8jjDLl8MF9GGkjEYyNuvAiwOWK20hN9cnOnewChaglhK8YXoHmw==@kvack.org
X-Gm-Message-State: AOJu0YwTbtEqXS6LjgvVsP/9sh7Pr9ZZWreWs6bjpekErk+GI+QcSCmc
	YHUSlFRV5R/gtxk7BQuefxvSg5xgt4pG1w694gMeLtEIcg7LL3dtLeT+437pbOFOLpE=
X-Gm-Gg: ASbGnctBebFgLClwA31No9wDPT7ZcCvSAciMveGxp+ESgQp4BL3yl1ePpWrFJX1jaxW
	QZnZGR5fTZAlly2bYg5Eq4U2YtifKo5aFj+E/jPMIKZgGCEASUWFcCfg7R9MWEUxSUimBLU3l/Z
	cD8N+62fJv3MpAFxfdodxYV6boRj3j6SsWvrYkYNa3709LmWJK83ddL4i3MBombEsGvFnHBKLIP
	UNmwTqwNUMuRBmMPcj47qi4vKxeMWLhdZ8nwUayLe5d7UwhiPjjCP79Mjv3a0mHc3M3iWe8G56K
	Qyvk60AuJTvbkgqwY275X+ylzoqxeZedEVlKk2qbQTzRPWHA0i508VSLKYmsG7hgHUd/vPYlP9M
	XQWTGe7Zg3EfgeoRGLDvAnfGso+FsjVbuhGDAwncfD+7dzFHNyE5ok+6Bdonr/Wbx7OYCqcYjwn
	co1KTFZxYxfk+J
X-Google-Smtp-Source: AGHT+IHDHBBqboi0c0b6rcDIt/ymD1qcIlODHNQyebDLYVOHVLNPjCPlRPjhkhoVVjwmxNLgx8k5ag==
X-Received: by 2002:a05:6214:300f:b0:707:29f9:3bd1 with SMTP id 6a1803df08f44-7097964ce99mr76346136d6.46.1754531116814;
        Wed, 06 Aug 2025 18:45:16 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:16 -0700 (PDT)
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
Subject: [PATCH v3 20/30] reboot: call liveupdate_reboot() before kexec
Date: Thu,  7 Aug 2025 01:44:26 +0000
Message-ID: <20250807014442.3829950-21-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D4F35100006
X-Stat-Signature: ncaobrtsdu365ybt6d7dygtkpxmtrgyi
X-HE-Tag: 1754531117-94172
X-HE-Meta: U2FsdGVkX18+NDhUDD9+yLDl0C+iozLh/gN/Ypda2DJkgZzeMH3gwe36Z9Im7TO16Gs4KTEH7kw/a8phALDsVPgOKGVFHVptk3SdlCKVaNNbM6goB5D0QOioM5uYJgnc/NBYUuA3qW1b9pIhNZ4VLYi4DRXX8Dg3hqz+yjQiGFDZGaYLzx2/girKhlTBkmBmNad/oQVy758iOVQu7+heOLM1pRhgWLqO5t9IyDsKY4aFw8O3sPc73xJpbsWEIqako/8Odr+1woOObAF/ZzRbPy7gCbrAHRfP37tQ7dQNhFienoOouDMlwcsEqdqQdxD0YjULZMtY5byT1fiDp6pKkjR+JInWfAz+lrSxtIns4wHXwNNhMnc645oIqIcdyaGoiY3S+6kS5bGyn58ajBdS9JHYDID+8Fft9wjW6iZkRxLumlTFCCvi7usae/hBQf9mJzuwELduV3VpmPhgF/hYLQMnRNEKH5UvUPffHrB192XvCznpOv7WkWsFhk3yWbDyDn6/92sWttaUVGe1aKORLt9xQwX64yueBqJo/cRqNhmXEYqAfHAb46Y8a2SKBRFhljf3mzqTsXIhUaCfpEV7J1BHm65+9mu4U/7kpKrwS3rIFUYp4hswQjFKJOvbEuBulw0WmtezYYblzWBbfkPDb4BYaXEJ9vVyKNCHxCm10LexUdrejANNdFV4IhkqmJpws6k/ktzuVE7MWN+OB33YSfw3vYvwesPH/L0V8jXxhynIj5WIDxZ6r1/kdXnxxLh20mA4EoAFAamyzmRJ94fsNBYB9adzp/DzYPgqEoJ8trFbUqItQpoDTUNWKe/XF5he2rJdVGYRrYCJzY1yxKiZCjk9CqIGhrDZ7rLK5DYB4ztp9nQCQEp5q8HLMPkN3I8DQUc+WD1ciIMhdc4Y/cVu8Q6YLXw9Si3fHfY6+egNTaErdXsreAEqvE8rbWsRZ8a7PXrAwgN1SWKak75rq0d
 wVKZrFJu
 sQgm3Mw38l3RajKjv7sWul08mccFl3jnbOyytEcN6b3V/Mc2D+q8KgjJrnaKfi81rWPlyvIEbrd0xb6uensh0i8AUudm0eqxVNEJw+gjsRgo7/PXl4iGXa+L1p2twoefKmPt2ZhjxZY5ybCNninRNoD9rWLwuLccnrBQRxO3KTBiaE7ILHNDOPMpGu4423fw1ekOm5wToPh2xCBmx5sDfCj1OdnXnNjSrqkSWqMdZfodj+6+zJ0HGL1VXZrBzmOg+hTyfHbLkI7N4fzzKpSS/3fDtHcWmnsgnRS35VV4Tdb/X5MDapYrRyadKw4Ea6yLT1MwEZejYFQfPeN6rr3/cqNXxAfUB/V8gdR1OLlmyGatZGN/dfEIfDTuLI+rh/WW11Qzgv81vbbiH0haPSYVz9Xe6h/5donQp7vDHwlGrNZqS90OQpX3gsz78i2/lUfnf2tYhTaTuLXm5a2uUkvgUTa5lCFMBHyHYE0C02yFm65mYuQrrGcPp5DMnlnuYB9fkj59CUAb9/dAU1Y0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Modify the reboot() syscall handler in kernel/reboot.c to call
liveupdate_reboot() when processing the LINUX_REBOOT_CMD_KEXEC
command.

This ensures that the Live Update Orchestrator is notified just
before the kernel executes the kexec jump. The liveupdate_reboot()
function triggers the final LIVEUPDATE_FREEZE event, allowing
participating subsystems to perform last-minute state saving within
the blackout window, and transitions the LUO state machine to FROZEN.

The call is placed immediately before kernel_kexec() to ensure LUO
finalization happens at the latest possible moment before the kernel
transition.

If liveupdate_reboot() returns an error (indicating a failure during
LUO finalization), the kexec operation is aborted to prevent proceeding
with an inconsistent state.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/reboot.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index ec087827c85c..bdeb04a773db 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -13,6 +13,7 @@
 #include <linux/kexec.h>
 #include <linux/kmod.h>
 #include <linux/kmsg_dump.h>
+#include <linux/liveupdate.h>
 #include <linux/reboot.h>
 #include <linux/suspend.h>
 #include <linux/syscalls.h>
@@ -797,6 +798,9 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 
 #ifdef CONFIG_KEXEC_CORE
 	case LINUX_REBOOT_CMD_KEXEC:
+		ret = liveupdate_reboot();
+		if (ret)
+			break;
 		ret = kernel_kexec();
 		break;
 #endif
-- 
2.50.1.565.gc32cd1483b-goog


