Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82A6FCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 744D98E0002; Fri,  7 Nov 2025 16:05:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678BA8E000D; Fri,  7 Nov 2025 16:05:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369AB8E0002; Fri,  7 Nov 2025 16:05:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 209E88E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:05:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D724059B63
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:40 +0000 (UTC)
X-FDA: 84085042440.25.1B70FA3
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id 10DF9180002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=C8r0CzPN;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LAfmXKExFsP/wCpt9jvB5iXqu6nwsrz4tNI+tUSnwDI=;
	b=CmPr4jrtj3VN7lyy8RAyuppQPeWTePXvbGe/md/Y4dtdPl5AOmElQFNVjOJ7X0D80MDetM
	IFwN3FQE1sRREGG6Vmfv4uequftE32uaNj/a12MiQgieiV4sgHp/yfml1u1/Dodmzn7Ta1
	JxyuOaoja0rzzhb+5jIKoF1Pd3m3LEg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=C8r0CzPN;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549539; a=rsa-sha256;
	cv=none;
	b=fhd20WWZMhxrfj14puzd0p7NJOvBJpYxWrZi4YxABpukFWbsqt75Ljoxs16Z8i4PCQYSG3
	AF0FE4v9rtfGAeblBdj5X7obhru6GBEgpLdYgHSJYgjXdsPhviERBFwJVTZvlxXiw1y4/w
	O+tkWIlgTaEulIMt9/1GS50gU0cNFEA=
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-63f976ef4bdso1100957d50.1
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549538; x=1763154338; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LAfmXKExFsP/wCpt9jvB5iXqu6nwsrz4tNI+tUSnwDI=;
        b=C8r0CzPNPoebjekoN2m2cvkaAQz5352+C/UqLGdIkwtpRPCBtnZPvuqOT54fsUGzmy
         Vghgz+6DjCg6urYBjqAHs1QYx+UJfehXxjtzDULQEmzfY48OKH1s6E7AHi+yDJECD/27
         wJRX9+7hLcYqrmQJXIFqfTech3CCLFwQYETGXeHNHpUO+cWRrdcmnl7F+kEk2xS979BL
         xo0lJUPzwf9ShCJUAuakSGXhuRgCIK4w3lyOiiKb29N29Bv3V5l6a8XFQKz3aqa6hgkA
         E0LDL27e7FUT7QGd5wGdfdtu374gDFFsL/eGTaQJWYzoLJIHcY7tdm/wfSoTtDeWgkNK
         v2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549538; x=1763154338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LAfmXKExFsP/wCpt9jvB5iXqu6nwsrz4tNI+tUSnwDI=;
        b=UljvH/haZfXr8y0L0L2nZHc6aB8aXQo0UzheExKupDlpYQlG/X7oRektlxguKLdccX
         x2onbAyhUjTUxt0TWQhPvnbOjHc/uh0t+CbjuOXPIpxXmbqpOGCU6I+JkyuEyxuB1rtu
         YCDBUsPe84Gvuvcw5bcEGGRKCgH5eGDjxNP48dveqqt0fhVNaj3dPtjr0m5kv5ImjnF6
         SCyJjCU+BrarN1YlOwPbjkyfgHg240lN+dglsnP1Hhuk/crNrM/Ogb2AdgRPYYNmMITm
         RllQrZj+tLHE16j2NL8BU7O6PjY2yBEBn7ev2mK9aL+DoKqCvuDH4KGbTNcuQ9x8nl0b
         KGRw==
X-Forwarded-Encrypted: i=1; AJvYcCVh5Mk8eh2dB/uyGgaUkbHX1wkBq9tS+KIYQ+Apx3L+g5qimgeFDBJPSN3FTo3l2+iKxR4izQ++nQ==@kvack.org
X-Gm-Message-State: AOJu0YwTaf0oB7dLACHHBCC1xQIZgn9mMXW4cgDRJbwgRV5zfOTPtxN4
	7A28Wnk+vtA1b5yUTQcKj9hJgz/w2Co+JyIGVWJ2z6MGMA0Z+MVTydHQp07bPztCy58=
X-Gm-Gg: ASbGncsTbJaqubTG6g1Hz0Wbh/jADHGif4BWwIvQ1unCynS06STH4wKBdxeCamj6L6W
	840XcJiFPNnzU/6OZuWA4cTbnQ0z7D3LUt2nqewR4kjz0rsXScQg824g1DmRPrcvR5QDnyUsilS
	lJU8M14iKMGjtfM5OyWlpj8cjL+FB5sKrtVRwIjDNyxXupos3d9fzlzTYHOC1AKMioWW2b3Jv3b
	85PIfoErl+U/RBZk4OdjQJ/AXjBoe9ZarKJKBmgwm2Xhr0Ke4bSi+Y89/6czHTleptdo1fAE3JX
	ZenDmsUyLctL0/YUOWAxiMu1u00bmKKPn80Z0hNj7AkhMEy4/zy+lDIcyu7K8wzKyNO/oD5Heeu
	lB7RxO+SCt/Mo23O9QWk6riVOK53KU7AAotdrA6kBuEjXeQ8wGBrrciwWCIjpdzvsvSAs3GLAKk
	toN8fKgXuK+iD94l/pBsGt2jkGlLtvOMr4sAsIzfz78q8j8kvXPt5HmITHCzTvfugMIvrLqZ6Ta
	Q==
X-Google-Smtp-Source: AGHT+IHP3QoDDPe69Dq6qZNTn006B72sZIHWCNrPLWZh2Sy97b00SWoXLarWg9cKIVLBa+/0WbjfEw==
X-Received: by 2002:a05:690c:a003:b0:785:e76e:59bf with SMTP id 00721157ae682-787d542919dmr6289787b3.50.1762549537853;
        Fri, 07 Nov 2025 13:05:37 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:05:37 -0800 (PST)
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
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org
Subject: [PATCH v5 03/22] reboot: call liveupdate_reboot() before kexec
Date: Fri,  7 Nov 2025 16:03:01 -0500
Message-ID: <20251107210526.257742-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 10DF9180002
X-Stat-Signature: 9bip957yct4o61w8zpttdmbixwj9fapj
X-Rspam-User: 
X-HE-Tag: 1762549538-906294
X-HE-Meta: U2FsdGVkX19R/uFAjf+TDegUPhu3Zcjol5AagQLABsQ14IwTytWilEYZ7k+ZYCfyPOD8HndoutR670EEYjImhyzen52hMip/KtalOTs0JUsAEEsZS8H2Jbny4jqeNcLzw5bwzRfskUHbADrctWikRewDraeRJMo+Ir4d7WNUWuyPNgqIffjNCX95F4FgJct8c/DxAwDHLMSaM8a/8B2x2o869zbrs6bClDws+HOJFrIK1Dlxbzl+pzm/d4v5vdFFpea8+H+wf6JmVtv3ag7bPRTOASEONwR2PxuNsougZEkjnWmWUaW2ghRF8vt96zLkaD4qzy4d04ak26W0BGsRqvY1MGdRWdN3n48J7UooDS9LW7yvcFFV1xm/GJch0vZrwbBH1XMmBRrArFEhy61/FMntJxGiBmzGQgDC/t/8LJM6m6JylAqOGiHpYD636vdtRqnTIk3YlRCEnuku9+LeRhQ7nDiXEmU4sXRsSZWIhvROQfpNvxBGm11jsYRsH1jTSHknvE3NauxGAaSaBvcb4ELazX9tZnd3WADVfFQuFC5M3djhK+fnIoeaY3WxCxtorna47v6NlbipTHt46Zea7LchQgkbOndzJY914VP2RtDap2GhGY31T8U9JQ7T5OZzUSHunD62w8qklatySXbc9pxeEfnzjl2GvF9SN/F/Nz2Ld31RGkosy/Ok0NHRyyOj2M3ayEdptCg+gJfKiAHupXacS3SUfWc8qERpqz6T18EQ5bjfQh0lYLE3EhMbmAMpvCzetB5odvHwl147H3FX4sJd3tsyJXSCejchSkJr7FEHjwJV6U7FGl+LaUkf2xvXQYJbZRfvSCFW454Y0RLV98V1prmK06sDUaCZzBHhWQyuDfwqXAOSQ9vsSgVL59rjb8a9gPWnBQJbtOr+WC1rMdImX6yHWvH/9LfDUK94XQDs28eXdv0oQZaNTp+ARzQbXBTzRaKs8vih4lB4KO4
 dDjuxu37
 s0hT11KhCJGPLLOzm36RLJpgW+juI+dnuwjiX6W8yGmxxk/S3GbdhDtQ+pPzlwpkZtXOlN5bvqy2b0LnyQNmyJ1i43HaBLCmFJvoDQeQ4K2BBVFWZe5XzDqtAotQmQoZaZAqBItw9kq0/PiT9nnJa2s3rxIOEc6VGFMKfucbG2rBvFBodRBi/EsK+7r2+3fKkYVdInK49qerWB95XMeJ+eG7aW0bhmRr7hf5J1GxquoZZCHVtNUHJugOl5WXWu5C3n6dR2ZGDHoMLMtKSeqSAdEQ7aLd2q+mrTwLF4iPhfHRrUNr4GDPTBtTS8rjpsMgPkU3a/wAz8L3YuvEvJ2sTZbqYCs6Kvz0N7kbCriGM/BnAaOrfU5hqGDpv3J6yylKy2l+v0cBgrTNoyrUgfj/I5+Yrealax6HJpzk4nHJraJ7ABiRN6mygGNzFLjtjUVuAycYNbA4+/eTx2OiZKTjB57ljxbyJgiHGNMhdFyu5lnAN27U4zlG8RYYGVydpZTKed6su8xnn9wJr1+Q=
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
function triggers the final freeze event, allowing participating
FDs perform last-minute check or state saving within the blackout
window.

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
2.51.2.1041.gc1ab5b90ca-goog


