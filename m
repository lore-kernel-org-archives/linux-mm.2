Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9956C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DB0D6B00EC; Wed, 12 Aug 2026 07:12:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78E0B6B00EF; Wed, 12 Aug 2026 07:12:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62C566B00F0; Wed, 12 Aug 2026 07:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3384E6B00EC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:12:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C2E3B1C0A7A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:12:14 +0000 (UTC)
X-FDA: 85092353388.09.4DB2F77
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id 08FB3140004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:12:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jAD7Af5o;
	spf=pass (imf09.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786533133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HnziYhdT7UChl1G7MKYkZ/8e/rooUTVlGFzd76e4LeU=;
	b=ECIcdlBc4eCevMh4qiFVgAg+oKyPud77g6EB5hhOmKBXq2S5EDTRZDOuRP1FPeLHkrbH6Z
	vWgTyK3dj9ASFVr7ACrFUr0pighgNHgFfbkbMon7CnVrsrisXoVcs29khyK7V0uNK2GGfG
	1m8j6mSIHuBp5mzTkewiNph+kV7U1g8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jAD7Af5o;
	spf=pass (imf09.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786533133;
	b=PFWSOSo5XrqifTW1PLYcyKQQSGSxndAvfJGv+sk9uRNbLg9xSvQWzkzYg7So+Lx51geMFJ
	YTt9YYTOeWoj9CuwWNaoPiCYcH5hMvLCam0P7wb/ymySmmJQS20zkqCn8xAXHAwHGX6el4
	46dBEkFePmTnJ3wkFD9cB0e8hPwcPoY=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49553515a8bso11975275e9.1
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786533132; x=1787137932; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HnziYhdT7UChl1G7MKYkZ/8e/rooUTVlGFzd76e4LeU=;
        b=jAD7Af5o0ckup/xB3iiWFvpEtNmmM7t8ancbSXBYt4KmuoW3dGYxuFBI9KNxaeGhdy
         FYKuXDJzK+dZC7mdi/TTFgj99QTAX2DGW0H+sX/bT/qGUPFsjMcDufac7xuhlR87AZA5
         dVwmrBwVoZwAlxEjp3rUDujineel6XY0n6UJJkvaRqH8/2W3a6uZHlelDIcYcXlySXO7
         0wHe4Wq80Wpcs0c+D0O9j7zz2vA0bErhcgd/O2C3gNb4jRm7xHVeaL2fq6rzgKdsBnMU
         uYpdWIn3h6WocfDeJS7nZqcJKKE99WE7AXH/qbMZ6VJgeh0ht7wakRNY4I2Pgx4kSAZk
         Vs3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786533132; x=1787137932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HnziYhdT7UChl1G7MKYkZ/8e/rooUTVlGFzd76e4LeU=;
        b=j6wYyrjZl7KhteLb4May05MFeRjVRItYi9bt8SAeha9VviCx1M+UprolwjCjzd8nTs
         8m/4jUCeMpT00bidfFKySp0hUYT3UjLOnQD3Ymq+KgAIgU3nI4AuFzDb2TOPr3vEXfmC
         BwIgWCDxkOiXYyGbC/lQ4zXQem+/bgmRx1in0o/q7VGFQkzF0Tf9uHTFZlbLfKHuTbuZ
         jWnTSfJZjl/u9YrPF8qhOjDeVhRDqakKQNfISd4ww/iwT0nuIeRH1xgRFDOhSOkIDuiM
         1h1LzwZfki6+vtLLpJpBYsnC2zUfNqIFIKEJcytABjuIDvm6qZ2MNfrxyP2baJWas1P0
         8UYQ==
X-Forwarded-Encrypted: i=1; AHgh+Row47Yuhp6NVfBTDxJCN7Vu8nVRJ4PNpuRS/shRG2C9WOPD2owaap4HzABwOqJZo3IjVG3h8owNZA==@kvack.org
X-Gm-Message-State: AOJu0YyCC1HplXffw1jENQHJR8ugsnb7GvQuCXiJV3Lh23cHGMf3Zplt
	JfU3a82dQaukXky45m70OF3poBAhbvx9iMu/P7kgSK30SULJEB65njcO
X-Gm-Gg: AR+sD10VJQN9eS00dzbK8z8Fje26LAnyTnDAls7mr6vSENJ2XQyzs4nZRR5Bi7m0IZJ
	UnDMqy6CimFwoKhHqfovcNM0ZP6uUgpi/wyMFkEZKNdUU9fgfOiqJOCrtxqOWnNtD3W5UT38XEr
	m3Yuil12JacRHD5IA4hkmG4WCE5kkoH7Stxgu7Zz+CsrbZkoIhxRbM21TqHk1in4UI/nUjx1Feq
	JrAuJr/HC27WHYkMuu4Zxq5dj+v/qAdbkkbIKFu8xadYuA5jjigGjRYjBMAS0pLtiLMOJxw5dm0
	KLQ7bxnuLqvHerVPW67x7co5EjdLeRjP2T3leb6+I/qxEn1EvLZSJFcSelZhshSv2M+GfRJS2tp
	Z6XAf8p+FEOYtX0HcwOQY/beGC+9ytc55xnpn76ZYlx85jAh989ygHKqBCRMnU7I82PvTP+pvQw
	MOu0+FDfz97H5zm+MOVyUm6H0mjZ3M27nSCY57Iqc7N4x26qoyIab2fOY+VJznot+KBdp3QxGeq
	Kqy
X-Received: by 2002:a05:600c:4690:b0:490:c6c2:52 with SMTP id 5b1f17b1804b1-4997c0fe67cmr52327655e9.3.1786533131316;
        Wed, 12 Aug 2026 04:12:11 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5e:1100:7303:647d:7cc4:8552])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997c9417bcsm54830855e9.4.2026.08.12.04.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 04:12:10 -0700 (PDT)
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
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next 1/3] mm: Add copy_remote_mm_str()
Date: Wed, 12 Aug 2026 14:11:38 +0300
Message-ID: <20260812111140.7762-2-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812111140.7762-1-tasos.papagiannnis@gmail.com>
References: <20260812111140.7762-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 08FB3140004
X-Stat-Signature: rjdjapexqrxe19363k1cw6ss1m79xptm
X-Rspam-User: 
X-HE-Tag: 1786533132-797389
X-HE-Meta: U2FsdGVkX19NNkWjFqcISyFFwEAS4JUZE+tygKAUkMiW0OJDzt00zfRuCbUiynCZPtzvSjxWuxynCGfiYXY7phxMH5WLeYevBS64J12C8fWaktx0A1rlm12AyBhk6klgZp3Q0+VyDYuvdO9MDHWXXjKP1Kx09q66ax5LYevRd3pVtWTMmPLTCg3MnHNcaL2KFycprJMsdixxn0/PDm9tZKX6vPGAN5td2dFfrFnpTdrnOJS2fFyYJxvTGopAw3A90cR6aqASUgwMRbEEAQfiG1+QKCtgjUDGqh1+flbnSn4ac7xUpOz3dd6MdS/Gm4hiuE+zPYZ1GXsL3O6woeGFVjP5vVF7tN9ln1wEu9Sr2QsdIP2WXhClyIUPkBdIG6d59ZU+vbxu1PSVg+k0wKe7y+FX+5GK6Ou9j7azAZcmloVqPuXjDQFd8c9Y4HpKdz5GMrvN7p+5SKsvgPyjup1QymnLlfzMTYClAxXKkAmEZbPD/RaC7VOeNOTcleIe24/QFMXta2lAzF81SArcLO5UVbLGveJXhTME/MLsKfCaAshPtjYxnEYaaNuiQXaHdjd15fDJRAz0ZJ0/iPn1Pdjx0Cu1zsLjvB8cUSg9miRxaFtrnhYCg0HuQ3Lyz5gwUkGcMLIft2v4zwVBpHXxd1baQ0GXr0UQzgI/pJsFtkeLXrJAvP+bjkuegdOShZk4dJ4OiHiqa3zLTKIV8xxO/C4xs3exZJtaAc6IKKYT/BjYBNkxgVsa/acNEi5MTl5erFh/kH0dnjnLVGwSS+tEx/gAAtMrp0EglLKluCtLwdaZ5ASQouLRb9BDCVfxaHMEw9OCBF6xQTh5u72A9SDTYAjYRdsvyR+7jWsDri+JYB+aVPMrhryewelQ0Htrh1vE3WIXjFJCxAywv/qmnbf0RplqwO1iYJ0lHWwuuHP5RWnE4fYwydlgR5fgqKJmX2K/I1QE7875P6Fuu1IVJgx2UH2
 ucuR8xh9
 ZmTzoVKEbR0MC09fcmhPUmxeQjAsBb48PdTG9+X35bFAOdVNHM2vLX0MW2fR23jkMiNaRqOp1SlUs01B2waIq8Ur/YnEsOqq+SPHjcaRjB8Q+PJDIeQ0o1dIiauJinbWCVviRYf06j7KuNqu/Xp5tFu4zGqnRh1V+7Za928BzRag+n4xx5GFXL6cZBeDD6bliNmMuN0lNWXs8TTXCi+wd1NikrHJiJ1Jgcfw0P1WsxDUl32D3OV0gIXE40MrNPj0k4GUtFSAuh7tttvG/Pqrq9+kLiQcTSquTr9KzrAdxzkzs0bo+1/k5h/UO5+sngWz00TQAmR9QokvGxHObr2qnqxq7w/dCc2nw/dYzX0S8kOTZ1MP4eUO8abgPrgR24i7JCH3NiF+Fam88QX5fiGePtvq5FX/tbtVr8BwlOubm0X67kqV3BwPz4YuJ4TyzFZY4B467hn6KF14eFok3YAaNvXYhP1y1OyEKPD5jUHL5cHeg+8vUn9v1IQ3Mcdo6Uye35pD5xdwRXutBi9cqUfALXlI9AqxDoDjA0Ol/
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
index 6b8280cfc1db..a70c43d9b17e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7218,6 +7218,29 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
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


