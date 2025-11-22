Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8211CFD30D
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED9686B0028; Sat, 22 Nov 2025 17:24:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC7846B0029; Sat, 22 Nov 2025 17:24:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA3066B002A; Sat, 22 Nov 2025 17:24:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A71696B0028
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:24:05 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 605F64F394
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:05 +0000 (UTC)
X-FDA: 84139672050.07.E11EC1A
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8D93D180008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="UXUde2p/";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763850243; a=rsa-sha256;
	cv=none;
	b=Mn8xJtyeiuU9QCmHg/KYabesgVvxqR4jGdB72A85kbbG0HjwFr5MMi9YXvZhWa6eXXCqGO
	uEpqZG4gsm4nn8iq8gxHGEspN8XDno14qUaFk2Fmsx/rH+AzbcQjpgltynVwVLfyGro78F
	xhqTVbb0IRGwAsk+Ib/CyuOgbwrmmME=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="UXUde2p/";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763850243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5KiW0twGUwiDqt6nePE1kGiL7dytg0Q0KVXgthRcks=;
	b=Twv4xgjooyBC9WD/IirgArwBFg1GadmWZjO7R6yprbt4HCozEOxhbK47RdkodTQRoWNhvl
	7utSG2zZOKqGMVdEZx4aaM2ouP023RW5oMWxC0S0OJFohWtxIgP1Dthc2A6e5LMUsLn451
	GZxhqfhi8zy6fPNeIZV6+KXSp3YgkXA=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-78a7af9fe4fso33199247b3.2
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763850242; x=1764455042; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I5KiW0twGUwiDqt6nePE1kGiL7dytg0Q0KVXgthRcks=;
        b=UXUde2p/zKkV6BrY88gYW2e1zhreYfwXASzHHifjEr2udo485TsUokKejQYxrApQty
         tJWby2WJfpCZFHHdE8ZhLMybLN/mIXgavnB+2JWypWfdOKCU3/jHqliQPEUzhdGD8dNU
         LZ/CZ+CEMDK2BiBvssr5XCJdWvy6yYjnMJc4SjhV8yy2hjaHCfchCNCTUWekwOTBr0JJ
         9vEtf/In7ctFycEURLFpIzxR7obThUektEs82/MpBMPwAZdg+HIz9L96iwUe/1dvDEX8
         tLOdf7mWENTBuP0hVY8VECO5H/2XT0Py3LQvVauQxmpTUbaLVF7yLgfwu5I5dSUwWCUh
         COVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763850242; x=1764455042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=I5KiW0twGUwiDqt6nePE1kGiL7dytg0Q0KVXgthRcks=;
        b=o/KN1SL+HogieSXqDpyVjNmY320D1LBOCRqL1fSmT6peMge71EqpRWwRxMxDxSkKSj
         cuhY1000NH3VfHAz3Xch3QPnd+tUDbGoaWyL7cGK9oQPxhnwNadqBEYf9DuVvaPMx7vL
         FrUNi9fCWU3t138PPSLh7BCSTRcttzJgp0ncFOu6rajRB/F2MUYwgK2n7nH8KrQVwBM8
         wi6kp3bVNWuyydtbLR2W4h+UI3oXkyCUQrDuqC6hs7+VyWF/RvuKrbgEqBwpTCYGC7om
         3tt+EFRM9kXGzCvSo+ARzdfC1YGPeaYY7CE+OXV6JPrxqs40Ookf6WvB0i8sasY/gUJm
         uBHQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5qJWpXDKBR+5E4COHDj7Xzyul6u/t6x34A1HpWqNhTrqeZJIlkP6e8S/jswdg8XurgmxeUgfiAQ==@kvack.org
X-Gm-Message-State: AOJu0YzqQPVmZqXW7aRn2irWUunNLFvZRaDKfEEruBVkmRxIGBLOXPzr
	BtCdHQo9i3+p7Gl/f9L3juvlLIkxOE22ULyVkGZC2sanY4HlWytGm2U2uzqz8IPBVxQ=
X-Gm-Gg: ASbGncu+qR+ZQurp9SZbm/vclHRxuK95DKGYhC5BSy0b9cmBhak+H42QGNr1xboRAaq
	7jyWWPiBcYKardui1aoiAUKoiM+gYPCMZWjyA2AGS4xW5w/p5EP/tQ3Hl0WA81cQMme+6Y30Gpy
	DJ9O5sefVgogfZmJ9ipRZvwXLLWMOyfsRQg5a1ZVlX99N+W7c+W+5uv60ifkgdN9Ukd7SQHKQBC
	BUqOCrd5O410/SDN5Y9LBA2Z5LOgq3Hn3CHSmaqMHF2m0xHP85lg604ZVevObDR3/faSK9HRON8
	8DgDjlFPOHWCcgYkTT6WS90NqaQxV/L9ST3EXkBYMNMtOJe0dM8FG5ecWupDUEZ3lFBOTq8kQUT
	qsJHDaRDOwxVvrXTUezm6Pxh1+uSP/ZtGAQqpE2Tz60n9ZbxbqqDAS/agqJsNgP1axHeubUYPNe
	bRVRy/CUYHkS5Gd0+jIEwOfrxGf8vVVfaVv6hWpU7nIxQ1A/RJXVznbTCK8wmsidtE+Y9V3fm1M
	pxBw2U=
X-Google-Smtp-Source: AGHT+IHuoY23QTvRNhRkhmDmGHRrDBpwbesFLAGgRZdemrA8LoJ/P/EIeiLQ/hTmePkctRQeLMtVhA==
X-Received: by 2002:a05:690e:130d:b0:63f:abf6:1c9 with SMTP id 956f58d0204a3-64302a4b3fdmr5160190d50.25.1763850242430;
        Sat, 22 Nov 2025 14:24:02 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79779a4esm28858937b3.0.2025.11.22.14.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:24:02 -0800 (PST)
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
Subject: [PATCH v7 03/22] kexec: call liveupdate_reboot() before kexec
Date: Sat, 22 Nov 2025 17:23:30 -0500
Message-ID: <20251122222351.1059049-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
In-Reply-To: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8D93D180008
X-Stat-Signature: 143atfu471xnr3y53ojwt57jwqbuoc58
X-Rspam-User: 
X-HE-Tag: 1763850243-780220
X-HE-Meta: U2FsdGVkX1/1DBIOPqmccreqEeH+7yHW15ndLZo65nRqYQEf9IxDxJt/ElZZ2l9vUY564E6QUTo6j2UTVtHD/Ccdf62MFlwtJMv54pFizyPmhGEIGe8QlawH5APswRc1HCWvrJGSPl/Xsahw6jaZ5laT2Mw+5Zw2qDYSf6tV+rmIoZXZYHFbHvGUW58rcQFAZS8QUA2CH9Q7TDCyVaf+sMVEn8PGG0B7UKpxlRU4rIL5jHdOIiSUxtxntq6hu2z9dKmnF/hOddslPdUG7/YNpPoIXCew24UiKCcxhWWgcUfC6Hdnt5vHs/+zeDTqleDyUs8Ge64WKKEMhsjLfKJdiKx6yeABPVCVSP/uKn3gtEM0G7+hN1q+x7MmD5E2WVN90eDTwfht/isF/JmtXAteOJix7fXHzGgeiZCItsz1PjE66onysMGsAkqxA0o+wRUk2ushaR7dpSQgqTgTner7bxDJUqilTtJxA+OCy1/NmFNFcQdSyBRX2gBmEKS2c4Hfi7RxKdvzOD5s5/lD5B12UUlSSO/Gq6RO7gEpOH6b/xPyIaszHXrheUmPfroZ9Biw7nm8+ZASvdDc63X3fmfmf14SesfMzm02oTFhoz/AANPCJBTPIoLD2V8aA7Te4P0+mZjjP85FDgMaNpNAD78JuITb2qc5HPpf/scsoqLU9usBPyrBwfyRXC7JkIOjtl5eriA/OxKHc1nywmTwF7K66hyjxG7qzgSk7Yn0Fcqz23Pi/bXhwhSrpFH+CCWrc49EVAbAvoHNaqdHzAEGHwh+sFjEG6UhvAFNxKG3LEd308iIrKh+2X94E/7CyXebTw3I7G9xUnlwctFIyjBGFuxJc0oC49aT0kpcZdD7I74S27Zv9KfHNCywSjVVVli+xEsY2Z0PU/eVugVGkapcsIscQMxkl+KkAaHaCdryVnPu3f2ze+anSHdhrgpt+MsUoyD8g6TO/AB1HJAVimVylS+
 dWBTS6s0
 MOFq5cjDkcqHZNXFrI4+rI8i58G0yuLh3FQEFUBVLdwFMWm/73DkEXkB4+Q8+9RKg17sodwpkr6ykK7QyJh3K51PB6o7hUdeAumHicTR2GvDQWuWUqaHUUtdeAh5+O7X2RtQ/K/35GeqLTjzEUFNA9VAfF47Fn4rGwF7vzRUHL4V3wg4vduJaDM7cfrwl1PxmKYJSf5F75jO8ApdB5IG8Jt6iqg5KpHB09/8DC+xfIs1hiCm2mkWw24sk+sy9Dca2jd4WFFKsQ3PVnQlmNYtWn9Et3iJ1TjlMmFrVGr+AX8ES2a2KYUjmnd4MGq2UWIu4psA0gfiw0JZbSKkOYFw5J+ce+w0May8LnkVOEnQLovGdd5qFJQI66vbPVTaud8tAC8eyuOGMRrz0aQe/fJRu9yulPcxT21Wr017mHNdeEcYdEqIgGOvwlLV5fMER/Zkzstz94t4EV5IB5j0AK7RgnAzQ9weW+8FqvYiMXkc1nmfd8s6qacn+hxS3cw==
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
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
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
2.52.0.rc2.455.g230fcf2819-goog


