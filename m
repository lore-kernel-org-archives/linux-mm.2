Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 207DBC5CFC1
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 11:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3553E6B0098; Tue, 11 Aug 2026 07:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3047F6B009B; Tue, 11 Aug 2026 07:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17ECB6B0099; Tue, 11 Aug 2026 07:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E53236B0096
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:22:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A0D712041D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:22:42 +0000 (UTC)
X-FDA: 85088750964.14.5C72D73
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id A4B96A0007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:22:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RjQtpVfJ;
	spf=pass (imf25.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786447360;
	b=n/lZULNRCOBMMF8zCowtJb/n6k6NWItJI9eU5TB8dLR1adJkO2rXZT8ol7O6/IlmJunX8d
	D+B1NSOZBXHMcb3B6AUVILFgriICdElgC1+neO0xtG76nOb15lmgk7B1XkBvisljkSuHGs
	Bftp0dE0kTtx82jhsn8TwYzh2u5HEfY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RjQtpVfJ;
	spf=pass (imf25.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786447360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oj+eoknvOaxVg+TzcZeSMNSYsDXOGxOvzczJwlu1YLQ=;
	b=GCUPE+CH/DcHVBgeqmI01w6iBlwFu8MFqv047EOzbqZftwbXf5Z8LFLEbQs9GmcmA/NxM8
	WFDLYRBPztht3cr4IO1rT5pxNhq/8NaJv/RDTTvFsE+XYgqujUWwA/QxiyULXk2HdRxmku
	9Q0h0R9QA6kPG69w5sxT7Q8I37jPJek=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-472326ca506so494861f8f.2
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786447359; x=1787052159; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Oj+eoknvOaxVg+TzcZeSMNSYsDXOGxOvzczJwlu1YLQ=;
        b=RjQtpVfJVuVah/N382f5yihS4BkRRtEM2LS6EXvo2/ktzjdJzBFodOKy7I4WN0ZtiQ
         PpzZ9EUQOqqGPkFixOlfnrFxJqT4fd0Z4JjzVRE00Ka5bZqdHRwIXCkW9xz1WBQH0hRR
         ZppaWnexuAeDzhz29p7sVqUWGdJS40ODhGwTaHqlK+MDZN8hriUR9lQT/4xHGQlLiURV
         O6GJGIU1xD1gUJpPBKTXZYq3WAVS5Zu4nbgvGiSOIcbPd4Ar8DR2UANSshpQv9oyynwi
         P69gMOVq9KO3FnwP+26OTV8qc5bs4Ui5AGCPZzLKdZE7dyri/j2DA0D6b7GzxVxkdjFu
         I5bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786447359; x=1787052159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Oj+eoknvOaxVg+TzcZeSMNSYsDXOGxOvzczJwlu1YLQ=;
        b=DSxhIlxBS7t1bUvUjA9n+M5rRZVR6HVLfcm3iZEQJf/qxG5sCT4GfyBQ80usPBfFO2
         3hd+nuD4orofv6DwJd2JaFsaEA6yYvLncQKT2oUsuYaiVmxZ9qDyf+4qTsKp5Qa7I7pw
         YvDZ8SjbVnwS5ApH07LKf+8WpjbBSw62U7TaM+GDU4cqydra0x5qbekgXOq4l/UtdakC
         TJvPwlL4a7P5Z2bzIj3efO9wcYG+pmX2cKeVcVjs26qaAlWsg1tRKPt6FcvWBczBjCHb
         ahYORiaoB4f3NjAjYlNk87BzvljbmislRRvgK58MiYkICn1Ui6k8c4AxzElgwLYg85N2
         ioEQ==
X-Forwarded-Encrypted: i=1; AHgh+RpEKehZ0aof14l5jZpURrxWLuvpyDeYAi/7lAQkeajcmjy40B90MFYQM7b4um9FYnr/2kbgznsDtg==@kvack.org
X-Gm-Message-State: AOJu0YwqjVNtO4E0tEghY3gARI8GTZUeBtDHdya0nS9kiQHErs0Fn2s0
	8s+blyv6bVTKjRuvMiFWbgHM3mbYBazNXSOcWIbDFiks55j45OLZZJhf
X-Gm-Gg: AR+sD11jVAXIiFN5i9Et0N4MMDPuAmpLaNT56tEUJwPdYYrYGeturjp3qloSOzx3H3H
	vNoldNOyCBrGCpUxsAANPsCvwYny34Gob1WvHLKyilXkACi5oyl5nbH2CxJMBgQ0UJGhe4/oItV
	mcpW29V/XujA41k62PBfW/T0MmgHBHTDV5MGZHXbgf+VaoA+mhr17CvrY/1DHV1pMuzwD6RvMPX
	/sO+mNOGtFZqHg2Yt+2viGvlbU6D1AWX31PuioGRFc3mtyaaD2NLhCuSwMUOp5wZhNv6dM+sije
	SweEFsm2MDh9EyvrFGfTigdR25BmcNzIReUPBxa4ULDWrukwEK6oCCaYIzfpMYfDhUYcI6Pnxtj
	edpwY1MvUo7nLXyqloHsfwdXpSibJs5688Jwjf5XQwPBKjxs/I0oYggtvKrFtGZc4jYfaQ3J6dB
	FChcjwxWAM3apLE9pKuqGU+q2YcOVRik+6SAfxWQ4dClsVQcamrSWOsqm4567qDLO3g05DtMNT4
	dhr6K6/nmyjqTw=
X-Received: by 2002:a05:600c:4695:b0:499:726a:117c with SMTP id 5b1f17b1804b1-49978494f70mr32371385e9.19.1786447359204;
        Tue, 11 Aug 2026 04:22:39 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5e:1100:7303:647d:7cc4:8552])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997889c2bcsm47547665e9.3.2026.08.11.04.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 04:22:38 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
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
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next 1/5] mm: Add copy_remote_mm_str()
Date: Tue, 11 Aug 2026 14:21:50 +0300
Message-ID: <20260811112154.94053-2-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811112154.94053-1-tasos.papagiannnis@gmail.com>
References: <20260811112154.94053-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A4B96A0007
X-Stat-Signature: 4gdn3pry8ercdbp8kqnz4nxy4f4fyugh
X-Rspam-User: 
X-HE-Tag: 1786447360-984616
X-HE-Meta: U2FsdGVkX1/f75JkdzkdHJzBSGUNX4RPv9TMF8pZhyEwwVF3GDDO+5yhPnSK0xZ8lAlXJrsUB51JXdXIjN6xUhEwlk2CV7qGZgXP+rhlEfYhs+JHtFUWzb4Gn/iLRbvjhAmuiYZ/RWWeRUWsB+wzH5PAJix8ihaSQJPNvDWP5PKhuq5ewq3mYDVmzB0SMmrSbtRL10tT3hko7xH1Tpr5CRHYS566HFin74q22E/5kb26HECVxM9pbryjZ8mPXLWgW/NkchIKJYq/vFYns++EaTitKi/5hSxHQlrBJMRw+Uwuklzd9VLTj87SikuJAQO47/5OkAZTAVd2ka7kQFrLSufzMrYCKTHtxYWketn+qndhXmkBOIYMr7eYDDG+pGaf52kPag4ALGdTH2tVQiPcCdbrOOv3n977XZvbrqoRmumGVRjozuxcECc1ia/56TucXweN5kP+pHEsdwLhpiro6YKY35YEEO2vHY2e7ArJE6un5vjAv4BXfKK3JKVxqE0YGDEWiwiMOO0R18rDBLa12ynI+s8PGpmmCEtiBpSXyWzF5DjVBLYE2xqZRwsdRc9AtPsFNj/VmxdytRQ/6nBaRdwgioNRUazDdJJ98bJwHQWY9ZoptKORiYtXOGj3Euqo7u02nMQJNxLmyjegr7H5I4cbDbFHOQRrcC60NSdEPW23Cu9anD1+hgCEbwS1xZeBnEm2o5xlRfQh1G9gX/G1EIdWIbJMaaLRxhzVkFLJiCR9w/8HqRtL8dX29Yvco0iASAtadmp5U/rx2/e7WIIuPH+vNBLoMqcnEf+qj/efQJceOuxl0PVacOehxWp+GQY1FowM6Eco2+fxvCBBBrn87nOL+BhlJbnQdP34W9gtmk7FwxviY+872w4OVwLHGN0ZDw1jsHHKuh8/P14lLRYkVl8Gq1Sdrv0v48kAzqHDbTyOujWU7nuRPUuu++hIajprAm9uWl4jZ7nZjv6xSDN
 3u0zmSSn
 6uAwsJ+e0AitZr9KvmNrjrRqnx8eODfmi5fiTRmgVlWeDdk41aKLnc+rb1N+rCSkSsd6cIRxX9vBcRUTet9Xp4Ar+/5AXucSEtEL9Sj8L9bnTtEbgdU9kyc8WdksCtmxdmRS7igxiLZjU71c75YBwGPAN76/VBwAyJ4JpT9H735++swV5AnoGWeM/mP098dIEWbDDq3atrAWMeT9d8Cf5WJjqiAMHjZ4T5a94yNAUciC0zxpBbqKPVs+oPZCJHTmaWbc8sgB75doBIM0YMi+hOlvkoK9pIa+GfZfYP21+zxLpeOxy2ohhyEy1Yh1renlmKtrA650UZ/33icPVzp/tRsyLC2S3nHtd8dnfRp45j4NFM2R/fBYcZq+MFo7cv0WX4uhWXVxrwIchjpx8LL2y+ymbG+DUusENhwGwEG1+CvRBb89d4O+uGDNkvBo4QUOKB+FhX3dFsSyHPiUmwtFZiOZpPvaVf9eSB84jfzAZALIu6hgpwd1Q+UJka1VVzH3L3OA4QSLu8ACDON+DwG3YZaWnEYWtpFtgpr0w
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

This patch adds copy_remote_mm_str(), which operates directly on a struct
mm_struct.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 include/linux/mm.h |  2 ++
 mm/memory.c        | 25 ++++++++++++++++++++++++-
 mm/nommu.c         | 25 ++++++++++++++++++++++++-
 3 files changed, 50 insertions(+), 2 deletions(-)

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
index 6b8280cfc1db..03cbd3b02bef 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7218,6 +7218,29 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
 	return buf - old_buf;
 }
 
+/**
+ * copy_remote_mm_str - copy a string from a remote address space.
+ * @mm:         the remote address space
+ * @addr:       start address to read from
+ * @buf:        destination buffer
+ * @len:        number of bytes to copy
+ * @gup_flags:  flags modifying lookup behaviour
+ *
+ * The caller must hold a reference on @mm.
+ *
+ * Return: number of bytes copied from @addr (source) to @buf (destination),
+ * not including the trailing NUL. Always guarantees a NUL-terminated buffer.
+ * On any error, return -EFAULT.
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
@@ -7247,7 +7270,7 @@ int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
 		return -EFAULT;
 	}
 
-	ret = __copy_remote_vm_str(mm, addr, buf, len, gup_flags);
+	ret = copy_remote_mm_str(mm, addr, buf, len, gup_flags);
 
 	mmput(mm);
 
diff --git a/mm/nommu.c b/mm/nommu.c
index ed3934bc2de4..8fbe6306d074 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1752,6 +1752,29 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
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
+ * not including the trailing NUL. Always guarantees a NUL-terminated buffer.
+ * On any error, return -EFAULT.
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
@@ -1781,7 +1804,7 @@ int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
 		return -EFAULT;
 	}
 
-	ret = __copy_remote_vm_str(mm, addr, buf, len);
+	ret = copy_remote_mm_str(mm, addr, buf, len, gup_flags);
 
 	mmput(mm);
 
-- 
2.55.0


