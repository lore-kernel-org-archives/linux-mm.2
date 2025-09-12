Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DB39CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559216B00B9; Fri, 12 Sep 2025 11:10:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5313B6B00BB; Fri, 12 Sep 2025 11:10:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4476F6B00BC; Fri, 12 Sep 2025 11:10:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 344726B00B9
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:10:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB99513BD15
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:55 +0000 (UTC)
X-FDA: 83880935670.21.B2EBE31
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0E43D4000C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=HmkLP3dN;
	spf=pass (imf27.hostedemail.com: domain of eugen.hristev@linaro.org designates 74.125.224.45 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRFg2hFdscTgaOHG8cpymzmUrui3DhwhCxVktuuhhLc=;
	b=o8mg5553y/hXbgcucD6LZcZCiZQFwzwmuBEXD9WcutpNw/kmc1B1Pf6O/sME85mxqjYCBp
	ASADVcONQME1fMy1uLwO8BF87FxIk63uoTgu6hoMrimPWwgGaE6j0t10mE6O9g9GIqNZCV
	sEww+tXUQroS0Nr49DDRy78RkMVOheI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=HmkLP3dN;
	spf=pass (imf27.hostedemail.com: domain of eugen.hristev@linaro.org designates 74.125.224.45 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689854; a=rsa-sha256;
	cv=none;
	b=X9Ioaqi7wVwvYSv4U8Qu4JAFPxbPOIJjR7YI+B9jc/x1HxeMj/NCjF4dNyMQaHrNIL6HUd
	GcULpxrjFGLPDfBhJ8mebWqL2HIM2z6XcCwu3giA7m8iAqJ0Qd1KSID12MSXdf2/W+2Iwn
	YbVkmVQtXIaiDGk0fogezozvxqqmQ3A=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-629061bb7e3so230619d50.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757689853; x=1758294653; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zRFg2hFdscTgaOHG8cpymzmUrui3DhwhCxVktuuhhLc=;
        b=HmkLP3dNM6OMH9lRchJUhfHnhqFh0FGNUt0cheOVbK5vuuF3ckeKXgD7ndzVbsZYMr
         QYZYUGEjf8wcppJ5LasJ4TykO2RILMH3BTDNbQS6f+3uDqBhBSdJpqRo/yyGuj2Pd3Fd
         ix12Mx0vzFf02vu1SnD75q72a0NUBJXCNUuFRLj8ny64qhF+BFsrm6fKl8eonNtx+N5L
         HtPrhkkAzvBuFs+eGAMWoaMWTkc+8w/g0GYyQtk+7xOnACQ/pAGcOCboXOyVfAnfwrf0
         ODOIlfTygIpHLGbfB9UjyG/MdZ3bMs4qr5bL+gu7YpFLWaUVQ+uRuO11m6+jkqKF11KI
         gecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757689853; x=1758294653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zRFg2hFdscTgaOHG8cpymzmUrui3DhwhCxVktuuhhLc=;
        b=WdQTfHgTrgCNJzz7mcpyaQx5OJGA4dIEZshYEB2LUJ5bEd691+5jGBQywBHCBJdZDu
         y6O3ejXW81cIAAxkFQMF4jV4QjV8qoI0EQQ8mbndJ5pmpnZi6mfMeqCbK59iGEvpzTnE
         FPv4dLwRgKXk8/9COu4gvfYGyFN3GBOrGGR+BqhVNnEUXYTYDEmUAYxSbxkP1KGY7OWx
         TAaixZYj8LtfYbdT71M1bHpUpMbxk+7pzCeTw89dKpjbG3CDShtqyiVtW/+pyOi+icJb
         ywgP/8Kdgi1zbslGWRzxOtHX+5/yCeodiwkjDJnJcBzbqo+xn4ux1b/B/vg7LB4vZKT8
         TBBA==
X-Forwarded-Encrypted: i=1; AJvYcCUZHSbA8YhshOEslZcVE/TMc47pWaVnLAmyEVtkamuY7n950PLQQr7RxglIOIP+3jEdaYOL3RawiQ==@kvack.org
X-Gm-Message-State: AOJu0YzsjTQ5qRKoSCXO7y1vzmaRjtyoS6EHJ5/xqWSAI2DMXo0T3FM0
	RetfasmuxytL3BycfG3CWRnpjrlbaiksZAaYEcqxnHSsEM1Zj4ZMJDCk+XyeEOpzwtY=
X-Gm-Gg: ASbGncu5e+LDzGDW5iIJnTII3rbsXzr3CowDUYPej1meJmxPIVq9ncEPg6dH8IyIvGV
	izP63cxU3B96NsQIctvskJ0Fu7O+4N578+tT13a5MjPAKHjtp+XLe3bBbNNJhGF0Gm9sayXRGDh
	eSIoVU36sHsn0R2PKLOvUUi4Jrm/Wa6pDnOgTDmtpSRs7UdA6xLVQ+jAxbPZm3yEEHqBKd769/H
	5iJQ6VOsG7FWbNg0nUJ+KZo7tZmtwmylPHy4H6GApQiNxSp8sh+kRVeAh/JymbJaMIVspT1kjnl
	XPJdZjUT9EC7XnSLyAlENZFQr6mPh246mk3YNZCwApmpBzDS39tJmRFJ7sEBYDl4tSFMU29dCqd
	ZwmByD7eNznS7bTHds1ft3a4Qd0QUcMNMuA==
X-Google-Smtp-Source: AGHT+IGA3TFT+vemEd/ubQxEEhLwHcx7hg7Tn+5tAGBp/Y4gBcPvEFcB1itw15g/ByzT4/+eDheVvA==
X-Received: by 2002:a53:84c7:0:b0:626:d26c:cca3 with SMTP id 956f58d0204a3-62714ee78ffmr2387133d50.0.1757689852988;
        Fri, 12 Sep 2025 08:10:52 -0700 (PDT)
Received: from eugen-station.. ([145.224.119.89])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-624841586c1sm1302244d50.6.2025.09.12.08.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:10:52 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [RFC][PATCH v3 12/16] printk: Register information into Kmemdump
Date: Fri, 12 Sep 2025 18:08:51 +0300
Message-ID: <20250912150855.2901211-13-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912150855.2901211-1-eugen.hristev@linaro.org>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0E43D4000C
X-Rspamd-Server: rspam05
X-Stat-Signature: rhireo6beh3q1yowdnio3mbcgasx43wq
X-Rspam-User: 
X-HE-Tag: 1757689853-70061
X-HE-Meta: U2FsdGVkX18TQFkQoPmm+7eWq78JezmJEshD6anRng5kf5bleLcnPrJHLSD8ItRPhrQblsDiEkGJxvLdAEunf7Ei/kXrRRKSf5fkfL8E2NzdA/a1hCh7yeNWN2zhfS+doQPIp6nUkXPy3a3CGbutdCewJkFt8c9DAQ/y94uDSFK0pi92+KakpcRQPthq7Wdaz7jTJ0FYRGp2ACsyzl60G4jjAXlazbvpBHGTN3OySZgxBCHXvemynmLLJWbJOu/B6ZWMRt2EJCeE0VJ/W7Ern5upOcNtb2jbDWUCbsJbT26nV3zgJvYMpT6uZgY7FaYTiDROVDTXmPbA9cabYSaSpr2+wveka55X5cUgZvjsh7JaOAvG4lKdyT4A0TpZYl7MIU486o4hSJiXsK8nOgGhddI2wOmTYZoyu8T2UoBd7mHGQXSTs2ySAcN4zeCucsucxic1CcC7Vkk/UTcm0ifv2d6PDrB3btnLN1ewKGnYlrPL43DqhgksnsF8CuaYFJlVNTrlJJrsZnfvPxmO9WaKB+dhK//i8BtLKaGVmR7N7+PC5rqSeOVzhoxm/+rlhrGYaOFkvErg22PR0B7g2FgzsQHnTp3jAHuTeAdzBtpoGaqrSsZ1gIwdORDmJXR0Pme6jUE5Zl6SxtWlLOLciNEu0BiTQ+euJR3FhikcvjdaeppZy3UEoBfkc8357A1RiQFWI+/ga6DRgFiIRdk4BTop4q8vSSzyBMcfqT4y39g96bxX/Nh1VKKmfywzfjeDmX4/kRlJbQIvvNxPGzPlWCV9e0r07y/AmXk18qIjG/TRK7eQZE3hoWcYj6jQJ7n0lBNNcMJPvUehHeUX5cOR7SOWKy/raMIGzeVt3y5Bxk87O2SDhhChp9+ISmqQhIk4Yp0D6D6NEKU6k4UdNVjcZsnlOU6yrd5Ln/8kQ/RctK4W4tq6M3gL5yVNxcQTyZLbkwqYYy/YQ6WgLk7+dhzDiYA
 VdY7+CMo
 Hj5v50Bqw1XdsdnDupLTk72B3CZmUW7rS31Xpzhgtq+FEnxJawdTd+mEv9c8UwSOK4nbaESuHDOTvbMHPQD1/L1mbyWT8XFPe34ErBOXDFzn5Hl41gEhYIwcabgs0+9GK2ZyrSsS8mSLeF5cPG3FxyHWZOsBg1ej6t+RpXih1VUoZfTwaUZVrjfPd4Y8wkXdDZqTo4BW4VGS3RKBLzDrUEUaTtvGIYBtj3tlvf/nUYTjgg3EvfyezJ/3lehs33lccwRCmma2yrh2DvXnHcCk/Yf3tDTw70BP621Bh8KNPh6+vidZWzqQUCtJ0Ra5vrj+cEyCvP4hycZfu74jIQuirVFWA3b6tRpwTbGu/K55tSvFZvAy5zc5OKQx1Ym4kcseIPkcDEGMtF2JuJVg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kmemdump requires the prb, data, descriptors and info.
Add it inside the log_buf_vmcoreinfo_setup()

In the case when the log buffer is dynamically replaced by a runtime
allocated version, call kmemdump to register the data but call unregister
to remove the old registered data first.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/printk/printk.c | 47 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 5aee9ffb16b9..f75489fd82df 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -49,6 +49,7 @@
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
 #include <linux/panic.h>
+#include <linux/kmemdump.h>
 
 #include <linux/uaccess.h>
 #include <asm/sections.h>
@@ -964,6 +965,43 @@ const struct file_operations kmsg_fops = {
 };
 
 #ifdef CONFIG_VMCORE_INFO
+static void log_buf_vmcoreinfo_kmemdump_update(void *data, size_t data_size,
+					       void *descs, size_t descs_size,
+					       void *infos, size_t infos_size)
+{
+	kmemdump_unregister(KMEMDUMP_ID_COREIMAGE_prb_data);
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_prb_data,
+			     (void *)data, data_size);
+
+	kmemdump_unregister(KMEMDUMP_ID_COREIMAGE_prb_descs);
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_prb_descs,
+			     (void *)descs, descs_size);
+
+	kmemdump_unregister(KMEMDUMP_ID_COREIMAGE_prb_infos);
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_prb_infos,
+			     (void *)infos, infos_size);
+}
+
+static void log_buf_vmcoreinfo_kmemdump(void)
+{
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_prb,
+			     (void *)&prb, sizeof(prb));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_prb_descs,
+			     (void *)&_printk_rb_static_descs,
+			     sizeof(_printk_rb_static_descs));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_prb_infos,
+			     (void *)&_printk_rb_static_infos,
+			     sizeof(_printk_rb_static_infos));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_prb_data,
+			     (void *)&__log_buf, __LOG_BUF_LEN);
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_printk_rb_static,
+			     (void *)&printk_rb_static,
+			     sizeof(printk_rb_static));
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_printk_rb_dynamic,
+			     (void *)&printk_rb_dynamic,
+			     sizeof(printk_rb_dynamic));
+}
+
 /*
  * This appends the listed symbols to /proc/vmcore
  *
@@ -1029,6 +1067,8 @@ void log_buf_vmcoreinfo_setup(void)
 
 	VMCOREINFO_STRUCT_SIZE(latched_seq);
 	VMCOREINFO_OFFSET(latched_seq, val);
+
+	log_buf_vmcoreinfo_kmemdump();
 }
 #endif
 
@@ -1214,6 +1254,11 @@ void __init setup_log_buf(int early)
 		 new_descs, ilog2(new_descs_count),
 		 new_infos);
 
+#ifdef CONFIG_VMCORE_INFO
+	log_buf_vmcoreinfo_kmemdump_update(new_log_buf, new_log_buf_len,
+					   new_descs, new_descs_size,
+					   new_infos, new_infos_size);
+#endif
 	local_irq_save(flags);
 
 	log_buf_len = new_log_buf_len;
@@ -1257,8 +1302,10 @@ void __init setup_log_buf(int early)
 	return;
 
 err_free_descs:
+	kmemdump_unregister(KMEMDUMP_ID_COREIMAGE_prb_descs);
 	memblock_free(new_descs, new_descs_size);
 err_free_log_buf:
+	kmemdump_unregister(KMEMDUMP_ID_COREIMAGE_prb_data);
 	memblock_free(new_log_buf, new_log_buf_len);
 out:
 	print_log_buf_usage_stats();
-- 
2.43.0


