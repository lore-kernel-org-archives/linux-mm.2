Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEECFCDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 18:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC4E6B0092; Mon, 22 Jun 2026 14:49:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B46F6B0093; Mon, 22 Jun 2026 14:49:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CA256B0095; Mon, 22 Jun 2026 14:49:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0887C6B0092
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:49:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 468321C4F9E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:05 +0000 (UTC)
X-FDA: 84908435850.10.573647E
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id 71AFEA000D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:49:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JHBj5ZHR;
	spf=pass (imf25.hostedemail.com: domain of 3nYM5agkKCOIXEVYRWELYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3nYM5agkKCOIXEVYRWELYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782154143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3NnqtfMpo6SzkdI4Y/HSdjjWo3N5TymmoO6c1c+A8Gw=;
	b=w41IyLioGobxwmJR7NkupX0/Xz7rGShB8MVpepiY4ZoM5gnBmzbS6AeeehZXmcuismUDQX
	JM/G1nxhEtD/BbHl1HgbhjPvP0mVork0npZqyLWHFfFRDAOpDSdEbJDt+C+1jnpt46zR8w
	Pqj4XtJD6KjraT8LJ24HkIB5RxG8aJE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782154143;
	b=AG7sdLEAnCkhHnpLxmou0lr06lGA7Uh+mnZY+cQHqeR6ShkDm2fDvD4D8bWTBwIhU1/cEe
	6YEwlzjm6YNrvBl9Ndfsadb7p2jjvdUL00rxI4dss0tr1Rz2TAWcU1wLTPM9MTifP6908h
	PvP2yuw3BVtU+d9UL1M60BAe/CHXV3M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JHBj5ZHR;
	spf=pass (imf25.hostedemail.com: domain of 3nYM5agkKCOIXEVYRWELYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3nYM5agkKCOIXEVYRWELYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c0afbf73482so308401966b.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782154142; x=1782758942; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3NnqtfMpo6SzkdI4Y/HSdjjWo3N5TymmoO6c1c+A8Gw=;
        b=JHBj5ZHRFF4KVvlhy8LjOBvNxEERkOFB3SAGdzwWzzxL9JsGwoNF1RGDV9TkInPx8P
         CwdUJ8BvDqQk7UoBRtqpNy9rr3onqTxjebmPzxaeJ7QH62b1LVoEQB1VHfHSm8SpTMFA
         pCBPzhdspmgwYOHB/SxTcAnNpg+huNQFl9ziuUBMjtttg1gOaF4Eh/zfDTLYAo55QLMc
         H3N71NSrnOLX2u8nWU6csF/e1MYIJl+hckOITbAgjTd1gg50pDyW0Ha1LVuwBobNgNTp
         3Vci1jD5G/JYdRqZgRhc6O76/CS3MWH383Ir9tTf7Vf8IIyy1lqb+Y/xJNZOpmyZJW6Y
         19fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782154142; x=1782758942;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3NnqtfMpo6SzkdI4Y/HSdjjWo3N5TymmoO6c1c+A8Gw=;
        b=Hjgs90c5KO+jdyrG5nQ/jqwqLDsXiJWbBxYP0ffZqNkZdS3bIi/GBzyRmQhT/KcyGl
         J0+ZqIH61tzXN8Tlgj1Ra7i1B7lm9brebnaZXRE+i759VkvfvhhRoA1C8yKhbTvL4wLz
         2O0hUTYxAvpt0bPz7KqyuZKY7uiD6VEmxglNEP6yiodQlU8ofBcPldBLVTA0r5WLOEe7
         fls/CpRA7c+Z8IqY0X+vRu/SG0nNge7TY5Hb2V337N+wQxyFjTdZB68o3sWz8YLEG0Ob
         yLN3MAYT1MW3K8Z8xgke5m7UMp/iqc/Crif320ore8XUbWzDN1yqqseP9s1PE5cWFHxg
         cLUg==
X-Forwarded-Encrypted: i=1; AFNElJ/Ws64LLHRq3OMLeV7Tw/3ZMmhXvqr0Jsw/Lt99uPj5ITO71BeGX9bxWif61EJH6BfUAwRxvRX6pA==@kvack.org
X-Gm-Message-State: AOJu0Yy+DtRHBKNTh4FtE/LF30rWsPRnP5KyVJKtgdhvpuAgtvz0adxq
	868/ZfodtFxSpz4tIVURr/IgMElVJPP11uXK0MMLetHvWoDwMYKBiGbD8X57h7S3KqCVQlnZaR8
	6DBwDyi1E7KjtxoL+tA==
X-Received: from edh3.prod.google.com ([2002:a05:6402:5043:b0:697:8dab:813a])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3548:b0:695:837d:529f with SMTP id 4fb4d7f45d1cf-696e5221662mr7941415a12.20.1782154141503;
 Mon, 22 Jun 2026 11:49:01 -0700 (PDT)
Date: Mon, 22 Jun 2026 18:48:43 +0000
In-Reply-To: <20260622184851.2309827-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260622184851.2309827-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260622184851.2309827-2-tarunsahu@google.com>
Subject: [PATCH v3 1/9] liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
From: Tarun Sahu <tarunsahu@google.com>
To: Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: wwfg7pafo5gk1cffarkhci14gc67zdho
X-Rspamd-Queue-Id: 71AFEA000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782154143-502488
X-HE-Meta: U2FsdGVkX19qkoPAfjrfvR0dV9vYeQ2Pa+VYlixIXxUKzTaZ/f/fRWHMVhg55P9MGPw0iVqT+2bapNzuWYSc+bi/gIH7QZ7GfzfL9kCQZI9yYogVYlmpUFmwPLFRkadorpjYjguSGkQFmrluJzUeJsNIs3qDOFkARg/QMJiTnEfRj08enueD4P1E2K8YBZdzxVdt1UkSdbXdpsMRC2Rbou7sHg6+RwOolIpAgt8k4E1TEA6+64pOiXfbxhJFJ8CLGP7rrtfzXdxngUVA5IpxNHHuZ7Ue61/kVvbLdYdwELxtjJuwPedprDgDJRB8g46J5tiwbEXX7Wa80Wo6F5mVHadSMhxaIjs8eK0GPYFueUV9vO9Fy0NzWXhNw9YACXNXvqoQJRBcgKfSM+BaKDLn4NYSTSuy70Cgo/AfZKGhRSlGgK2L4ir497Sp14BiLLecS8iqd1fJDnXih8HP4glrrLwpOu9jKJCeWk/KXDtRWIe6/Q14FSEDz+NNA1wfJ9HXFgFFh/PMOdppDx0GL3K02S+VkYlIrwu//62gVmQhm7d0i8v9x+51M9LZnIYtE8bcLdjB53Fi/jmTJhV3hzYI69kEYNhqvrBIxJSYwCvEZghWpAT/yfp0t1ioqp3kbXE1Qy6UW3Wgy8ITLpuKatC31bNkoQKtaKZtIQqeOo/D9UPGPoaDr41Q6jeycCzUweKwRm0zxPLgsMrOZIVJLcnihLEnkKytVXlBI7SHTFQJcoFoqcnNWrqMWkcmW6u97lS5TyccDaXFtZPTauDIjw4di/aXcnawMJEsBqYvxXwH2AT3kdAIyFjABJW2B6u8CIbvBDckyVU0FCqPIAMX0JVFjC7846XtrWDnnNbWz1TSTDNHaxhvtnb+mSCuEPo4gjTNVkHZvX7MJO0up/wiVt3oGuFF7YNtZg/WkQPVfjzwRrl7epFtrjS1Hfp/L5Df48x0uOtLevOG3mkutGM/3SA
 P731Hg/L
 WMD/L58AgzZEJIaTcH4k2S4aDVwp5pqyJ/NtR1ueRLE2XtavHXa8pxF6kscSdv9ayiUSNaBHs9Z1wxDb/TD49RfzrLcrzTDql5GDhFjFCeQQI6P6Td5cJUs3HRz0VxRqU4vOW0ZxQOJoRe7OfFAv75oTUyJ6yXaLT3t3pS9LHCbzVEaMkOQHrXlm0h9Hk5jJaoEZxw4CXlChJnmq4LFsZa8srPgj1xDcssJZ9RD65ApZpf60nTAuJZWJEUN5A2YUJmgW+uSA4Yz5jvDJotRyuVE9/m1LKI14bzWXU3KF1vgXRkV42yLeq4m8XTXoBqlhQRCiAS3mb4FzAfmXV8yV/RmLw1ffOD92blYVpnqBP/VMVTinFOSL5RQJVdWEU7aH923orAp437H/MvlWr2CIoaX9GThd+1DJa/TozyxJcu7QBJE0sbMz0nf39Y996ctRXlSpwUwNQeoIvcS8MUbDtY6JJIxunWn7Ar0XcHYbOYlnJylrOEte+nA+EhV55iVKCrs4DeQWCax5jrrAG1730kDADBhfFsB3/xMTTR/N8/s8JAmcvfFBqcfDqaWl7dXLmSSRhb+iumrx1cMfmRp4QfYX6m6JS/vXVMC9W1mLq3UkyBWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the LIVEUPDATE_GUEST_MEMFD Kconfig option. This option
enables live update support for KVM guest_memfd files, enabling
guest_memfd-backed memory preservation across kernel upgrades.

Currently this support only guest_memfd files that are full-shared
and pre-faulted.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 kernel/liveupdate/Kconfig | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index c13af38..2490f9a 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -86,4 +86,19 @@ config LIVEUPDATE_MEMFD
 
 	  If unsure, say N.
 
+config LIVEUPDATE_GUEST_MEMFD
+	bool "Live update support for guest_memfd"
+	depends on LIVEUPDATE
+	depends on KVM_GUEST_MEMFD
+	default LIVEUPDATE
+	help
+	  Enable live update support for KVM guest_memfd files. This allows
+	  preserving VM Memory backed by guest_memfd file across kernel live
+	  updates.
+
+	  This can only be used for the guest_memfd that are fully-shared
+	  and pre-faulted.
+
+	  If unsure, say N.
+
 endmenu
-- 
2.55.0.rc0.786.g65d90a0328-goog


