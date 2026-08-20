Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7787C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 13:18:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA1B96B00A0; Thu, 20 Aug 2026 09:18:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E78BF6B00A1; Thu, 20 Aug 2026 09:18:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8EF06B00A2; Thu, 20 Aug 2026 09:18:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A36626B00A0
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:18:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B67A0160179
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:18:40 +0000 (UTC)
X-FDA: 85121702400.18.F8B6894
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id E4C591C0002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:18:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IUAQnVsz;
	spf=pass (imf20.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787231918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/dzYche3n13dnE4ECcGdXysT5dUdq4Uh980G2RdpPA=;
	b=i6iwvWscDSbkHngKiYCQ9R2yU5iEuc0lTNhSA0/wGiF27H0RscgGzLA4xGBwjv2qckSz0g
	dd2/doKP7eNcNlFQR2vhq7h2ujV5f3n0Erdp4Y4cfPVQeoXF3TgnpwIS+N2dcjUUAxnOKI
	HjTLny3EpSKt4KsLp2lL0y8uW9UO5Is=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787231918;
	b=5qNIHoQY19F+/yWPhpKwVacRRy3iwh//2emWBjMDm4FwDrIIFOxSUvVc1XJG+1K6cKjI0O
	yVEttw1MeMYqFZa+1bmXBVXO+xvUuSBt4ggK+Zh5nLE2TQ10FBmDW96r3T06hPOENvjEuq
	VPRadLR3p+X7q55eZtgBhQ4dNL0z7e8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IUAQnVsz;
	spf=pass (imf20.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4998590d392so19803575e9.0
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787231918; x=1787836718; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d/dzYche3n13dnE4ECcGdXysT5dUdq4Uh980G2RdpPA=;
        b=IUAQnVszgZ9hjdn7cTux0EIdN7iVqO97fBC6T/TBhAUBQhNWL2WMgKIthNXZ4WPYcw
         eJ/An6DC0+YkrfxO3V91ReT3Yl1TjpUtfWtgSCm0MHJlIzzAfcltvXr/9pvHc1dS8ddY
         Gx1Sd1oisBJ9KMt9lXUbyhgpYHtTavOZ2kF/7JMOmQPMnrNQ4cEg70MIG0MUkyeZZJTq
         l0Wah/n79RQwVbfCWAaq0GOVumJpFIlEcWuLTq+/K8lctwrRUCgv8ngfOq75Jg1DYifo
         ZtP1pWFTcWTL2lrQaJcmVouw0g7iWQQiDDzJE4nE/PMd6+P9IHbF8XRlilPRCaEpwVhi
         /+AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787231918; x=1787836718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d/dzYche3n13dnE4ECcGdXysT5dUdq4Uh980G2RdpPA=;
        b=W9g3Uke9qli7iZzUWXNIsPZTpQYgmqjYDJ4F5Z1yOwHUZPGLU0hPfNP1cDL2hUkHcS
         mf1RbFn34cTTfCCxT3wJP6vle4hs69g//q6MBlV4vgHS7k5XUucBwRks1AxgzKDzzIwd
         XwfiOZKqzK5BZKSuEvvsbMRbdcAsv3o8zjr+o2a7Jbc4jLpmvZKwvTdEG0RJudFHIWHi
         v84eHDS67dAB9S/n/vK3f3gi+umADwu3NBdll1qjF+Sz0rZTLbt0g9s2Gmuwpl6I+SX+
         boRfyjCKY0MTMseXrpwo3jNj1jS7JqEDwETgnyjHGT8x4gWkFMPIQy4/blKgfgXNTT6P
         xOHg==
X-Forwarded-Encrypted: i=1; AHgh+RqNPfZb82vqQ48RyYLMjaPwe3SGG1ddBrSVZT6oKEUyKY24GOX18wNmBzOBN3I03rZz0kxI13gq8Q==@kvack.org
X-Gm-Message-State: AOJu0Yx1RF3c9ZPVadosbs0AxSJfKuBWLb3+NlagTrrfDL3UbRmE/7vu
	uf8O/6Yl4JyRhFF8dqNT1+Kx2Y98Kewyr2vCeFhMlfiqgC6ct4jBBs90
X-Gm-Gg: AR+sD1294ju+neolZqq4ZAEFVoI4HewvW0CZKDNu/T/TF5Q14KVcExD6I2eRcsvleHV
	4+sqUHwFuCZPOf+PrDu6lMlqto9brORAgZpwzp+xGnAgkZyzETEgWy1TfHvt8wvUNMTZoZn9WpV
	JKG9vFy6X9hDgEQJpxWS5WH5Q5btQBoLBOlDAaVeEscxUJz5kAf82uN0OGq/euGA8SvgGb9riGh
	A/SmWLsLHRGt/Ml2xD/JT4lNWOwErF6h8kLtJqTGJ7kg2NzWiGrWqUEByCgF0Fm4+ZhrwBUFcsl
	H9rRGojrgEssQS9MaizApyexfGzZFHsMNbJGvQUuXg/0xfT7Rf3psqNHwEDWSQTJlj2uZ8gDy9u
	ye8IeqLEDB9iAX4CuL8eKWMKjX7KCUMyUcPfQTx2rGhK1fB7aUjLX7ajpIG1027ov78SH4QmZHK
	H3k7W3i/9K0mqWwwAvjvVgqFr5g2kZVnkOFeT+TNkG5QP22JFSSLbsdNrTsjrPp3mRoEA9CcU51
	bCDtRQzMw==
X-Received: by 2002:a05:600c:6749:b0:495:6274:56c2 with SMTP id 5b1f17b1804b1-499aa1896f1mr232088665e9.2.1787231917285;
        Thu, 20 Aug 2026 06:18:37 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5e:1100:7303:647d:7cc4:8552])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499aa0e473dsm136027275e9.15.2026.08.20.06.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 06:18:36 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	kpsingh@kernel.org,
	matt@bobrowski.net,
	song@kernel.org,
	utilityemal77@gmail.com,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v2 1/3] mm: Add copy_remote_mm_str()
Date: Thu, 20 Aug 2026 16:17:59 +0300
Message-ID: <20260820131801.68759-2-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820131801.68759-1-tasos.papagiannnis@gmail.com>
References: <20260820131801.68759-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 44xpcxci6o6opwtgun8ho6r39m15wh78
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E4C591C0002
X-HE-Tag: 1787231918-580112
X-HE-Meta: U2FsdGVkX1/6r5C74pGyqR5CqnTPhKRbJOeuaLxohNcfk4Aoi7WZoG6cDOJ/Itv3icttY9aGqjjuglwL6HsIkzW71xUlXwj44btIhg7QZ/eyMgVdnNI0PlF6xCUPkUbna4c1X3Mug6ryB5nm7+imS9B5fILjVCqeMK+McEPyqBGmXzqu1d9qzYaL55+irtVGK1sGnNxkv3uAUgBkZQYSE8gPdjaN6Eyvg0fPErSh5Oc1mTiahPn3ceU+dCdqOUT7Yco7leSWSLvVFXLOAMkw/W5mNvzQU5bl1NjbiEwzMISZ4INDySGHhOFIyVebzEw1BHe9tasTj/EO++382nju5Ed14ZxBmhG/Gf9XkdjzJKYVf2o2nXiQlDMqGd/LvobzrQfxv4KUiUsaUQkYvW84QdZzAsxZwrRUdnfi/MHhdfAzOXxjzkRaGcxa5wFKn9DwwC9ohJRXK13235ntRhQuronyloXWiu5+BPfHM3Y2Sj0lI87sM1hN6Y49HPC1npBw6fhbN4COw5VrMGmIgGZ+VEYGGDJPnVqrM//lB723BA3fbudBUmITvc/pKTJjmjPpY5dYBNA7PjQJ2tpuovairihspV2DSMsUqPqSNWF4CBzBzL0vCHVMRcBIh0jP3IlQWAYJ00XbVP0H5Nv0IAlhLiVTyd6V8xXvi8f4//7JLNsZrP/6CxZrk0JqGTXW5Ms9bqs2wrGgA3z9SMjrSc2onMZM32Si0bjDdxCPsWV0xQMubuneMuGPXFAaNYl3bujoe5y/gqA+w83Uu2lxzdAm2ViL5ncalQMYgbtrrpc698N+/OUHGxteKPu4uMPqSPulaGpQS+jgy0T/iUdMZoFEzEsKnQitpwnzVR4oLT+fTK+yiI5rqpaDt0ICUK4y9C1RP5xcvwJhLarHxrwPUbrVwVJo3UWVMcuzKnTlkzPhbf7qFoaQ+k6ffh/Iq+tgJzMcyWCuxhhvJIimV6PYfoi
 cJI+hJLG
 ucJeKyOUoLEtLhLWspElte2FW3BKZV3BIEP/lYXMBs9MhtLuWQbHRRzcuO58+zoyTZQxo5ozDwHKIBuc64ehWjlgrKwQIxOWZkEpMMySiNWLKNdk0gZbSdbwtvNyzF+RdyIGzzbMZKVbiP5QJ0I/UbmbERyj2G2Ata+KC0C4zlJu3yX5ERDXCXBRmT2ZJE81pi3umYpDC2NJn1g70FdpdctRCeHM00EyufDLT7R81/Lm1NBRjrYAdNYjUi5M2jWAW0JOT31xP0T525wf32umqXUtGDi3Yz5By+CynejaItEr2x6uvJ3y/AtGToG61YTp0XzLzruyEX48jHYV6N5DTofJm8ROTcjWRZL8KhYDzMUCfav69/MfFBGG0CDzVvckrvBPyfBdIk8wccWSZAGijo7ekpTJqJhf8o297uxj093XE5wirqIrSOu2ynGzi80UbJSE39q0eFp+q9L3Qj1c6+zEu7VHmZdnn0Du7IN6JWWReOXJfzFm8wDjOptzbXW4Vt8keMGMkuUXRTKDfVh8RY3Xb9+dsktmjZIlu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

copy_remote_vm_str() gets the target address space from a struct
task_struct. This does not work for an address space that exists but is
not yet associated with a task_struct, such as the mm held by struct
linux_binprm during exec.

Add copy_remote_mm_str(), which operates directly on a struct mm_struct.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 include/linux/mm.h |  2 ++
 mm/memory.c        | 26 +++++++++++++++++++++++++-
 mm/nommu.c         | 26 +++++++++++++++++++++++++-
 3 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..eede435bf4a3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3222,6 +3222,8 @@ extern int access_remote_vm(struct mm_struct *mm, unsigned long addr,
 		void *buf, int len, unsigned int gup_flags);
 
 #ifdef CONFIG_BPF_SYSCALL
+extern int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
+			      void *buf, int len, unsigned int gup_flags);
 extern int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
 			      void *buf, int len, unsigned int gup_flags);
 #endif
diff --git a/mm/memory.c b/mm/memory.c
index 6b8280cfc1db..da0010c4475d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7218,6 +7218,30 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
 	return buf - old_buf;
 }
 
+/**
+ * copy_remote_mm_str - copy a string from a remote address space.
+ * @mm:	the remote address space
+ * @addr:	start address to read from
+ * @buf:	destination buffer
+ * @len:	number of bytes to copy
+ * @gup_flags:	flags modifying lookup behaviour
+ *
+ * The caller must hold a reference on @mm.
+ *
+ * Return: number of bytes copied from @addr (source) to @buf (destination),
+ * not including the trailing NUL. If @len is zero, return 0 without accessing
+ * @buf. Otherwise, @buf is always NUL-terminated. On any error, return
+ * -EFAULT.
+ */
+int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
+		       void *buf, int len, unsigned int gup_flags)
+{
+	if (unlikely(len == 0))
+		return 0;
+
+	return __copy_remote_vm_str(mm, addr, buf, len, gup_flags);
+}
+
 /**
  * copy_remote_vm_str - copy a string from another process's address space.
  * @tsk:	the task of the target address space
@@ -7247,7 +7271,7 @@ int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
 		return -EFAULT;
 	}
 
-	ret = __copy_remote_vm_str(mm, addr, buf, len, gup_flags);
+	ret = copy_remote_mm_str(mm, addr, buf, len, gup_flags);
 
 	mmput(mm);
 
diff --git a/mm/nommu.c b/mm/nommu.c
index ed3934bc2de4..1fca0bb7f042 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1752,6 +1752,30 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
 	return ret;
 }
 
+/**
+ * copy_remote_mm_str - copy a string from a remote address space.
+ * @mm:         the remote address space
+ * @addr:       start address to read from
+ * @buf:        destination buffer
+ * @len:        number of bytes to copy
+ * @gup_flags:  flags modifying lookup behaviour (unused)
+ *
+ * The caller must hold a reference on @mm.
+ *
+ * Return: number of bytes copied from @addr (source) to @buf (destination),
+ * not including the trailing NUL. If @len is zero, return 0 without accessing
+ * @buf. Otherwise, @buf is always NUL-terminated. On any error, return
+ * -EFAULT.
+ */
+int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
+		       void *buf, int len, unsigned int gup_flags)
+{
+	if (unlikely(len == 0))
+		return 0;
+
+	return __copy_remote_vm_str(mm, addr, buf, len);
+}
+
 /**
  * copy_remote_vm_str - copy a string from another process's address space.
  * @tsk:	the task of the target address space
@@ -1781,7 +1805,7 @@ int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
 		return -EFAULT;
 	}
 
-	ret = __copy_remote_vm_str(mm, addr, buf, len);
+	ret = copy_remote_mm_str(mm, addr, buf, len, gup_flags);
 
 	mmput(mm);
 
-- 
2.55.0


