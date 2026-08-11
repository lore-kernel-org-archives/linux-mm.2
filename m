Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 221D4C5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 11:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F10E6B0099; Tue, 11 Aug 2026 07:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE7E6B009B; Tue, 11 Aug 2026 07:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A6276B009D; Tue, 11 Aug 2026 07:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC0D86B0099
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:22:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7552312041D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:22:46 +0000 (UTC)
X-FDA: 85088751132.09.1C9A0ED
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9DD0620002
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:22:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NlDSeTfF;
	spf=pass (imf31.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786447364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rcy5zMa/mQvTQ0drm+XsfTSCaDYlJAty3EgPpWyKkzc=;
	b=1Nb4akZWJO3bLSoOK0UWPoI6mmo0zBlecHiw22vUV75bYypXqsIzq2muNH5FemqrolmdwN
	d9tc27vxHQ0jUsB470xmlT8DCG5YBXW9daRIAGPQrb4LLj6RYp7koom+XOxM01yh24iiRX
	/kcO4WFosv8oo7tnNa1FDpP3Dr457lw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786447364;
	b=bvV/2tuAA6MbWprQAZqtIrpeUEkL7Ceb54G4T024lJ5m1YzpjfTFHR1jJVT+SpokqflQvB
	iyFEYYGFNuuYHMhnoGZaOxZV+Hylhnoc2L8Tm+1KJL60670priXVKv8ssgFPTgOEyLJDL5
	GIHQD6UXzaQO18Qzca933M3e+9LqLxg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NlDSeTfF;
	spf=pass (imf31.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4956242332dso28848255e9.2
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786447363; x=1787052163; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rcy5zMa/mQvTQ0drm+XsfTSCaDYlJAty3EgPpWyKkzc=;
        b=NlDSeTfFcFvlmg++m27sYMwvsotoMNnAogPSZxODTpPe1+VRxvXn8E2VoY3L62/NMR
         1BzR9so82tgn1ggRFY/h7Nfv9Hs6+BRTEJSjxSk2/S/zd2Rgl+PgXSKV2l21EKwH+hJ1
         Odj4EszPrmztpt1/pp/d7kCICHV9bSLpsf5qs4DvzE6vICF3Pyqspvl6hXzaawye62iL
         ke3+gC6jg8fmTIcreGvis6SiT2V4zWjTA/pabV/g2yzSVBAL9zwGgGwvRYgxVVKyxmqW
         c2q+ySTHnrFnUK2DP0aYTzc7DyaWSpAhfPzwaTQIg6oTG2eVyQo19dzVdZHYp/rkx788
         0pMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786447363; x=1787052163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rcy5zMa/mQvTQ0drm+XsfTSCaDYlJAty3EgPpWyKkzc=;
        b=FuQi+uwjOljWuAzNv56qCqknVGvzF0g/eGk7Z+wlNtH3r+3uqtsyrQEzgzsXNLnBwE
         P54xCgD5J4o45SIjrO0qAidMDjiD4Sl9RB3vgNWzZv7L1WfmIv/jQBqtJmxUixDnxb43
         /HDC4lFGd3T5Bg0lOwBobYDhEl69Px08D9wik+ws6QMGWCthQG1+L4mToD5LV0zTngOS
         zJOy4XEaXS4zQgDK/ex2/18hwUxHSDv+GPPh9yva7c1jC3DpIhw3JrtF7lhPyMKIj+rg
         A6i3Ulht35WjwU9uS7+6HDP8LzD7oPLT7MGxhQ4sHGxFTt1MRK/9kVNYhfPqYjyLwz8p
         C3Yg==
X-Forwarded-Encrypted: i=1; AHgh+RoNrGz3o0X15TcDrh74w4G1gzDE5YQTnhIBuKvZWFLJn10Sk8IsYCTsS3lVAQzhT3PjiJ/JQ65dLg==@kvack.org
X-Gm-Message-State: AOJu0YxL0kqKgV84UfHNi93OadmGmD7/tsRmeYS6i4MsItnSH0LlJNp5
	6PsNBEXXz79dm+c9j2yVWHD+TG9f6gzsJF2xoy55jwUST8YrlCKLGNk0
X-Gm-Gg: AR+sD10/DL7z2yfwipRMcRpXaPAF48JJEj3ad66OEcinNO7Qzcvc8SEyLiAbS9Uy+tG
	qnkIlA9n+aQXL08Yr4eB2VmfWLDMyiIvERgLDrAjDjhZjyoABZQqR+WD/hCXesw3FYNdjFzeNzw
	qain4BBUZHGbDvWTx4Y29c6JTQfv4Jz0YAJCRZmDepQcpQFZR+0jSqeJml2BXz/+amGzUjDqzAq
	SB9EnmxjIc90fE/uRiJ9MVXg+hJUISHGWzA3i7Zp70Va+UXFIoLqfPBWHRonAEgYY9RYvFT1IDS
	xKoABXJ3ETbY8VgsyaqLWD5jXEzNMgp5kNjaTF76WWZd1wAa8p2rNDDoXK16iycCPUOsxTgBrpy
	Zt0S/ewwyux/g0/8L3I2R/Wza1/NFUYhmyC4216tEi1iy2TRzpFSQVo/5F0vme6kpEks6GFZ0Xe
	7r62uyaPSbIa2BlZzi5jNjOVn7KGODzSwhevXDn1iIQJSJjrPbDQghyQIjeBlHJA5CqLaZMFgDo
	HmIAqI8sDa3IRw=
X-Received: by 2002:a05:600c:1912:b0:499:737c:8a8b with SMTP id 5b1f17b1804b1-4997845e778mr44282705e9.12.1786447363236;
        Tue, 11 Aug 2026 04:22:43 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5e:1100:7303:647d:7cc4:8552])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997889c2bcsm47547665e9.3.2026.08.11.04.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 04:22:42 -0700 (PDT)
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
Subject: [PATCH bpf-next 2/5] bpf: Add user memory access kfuncs for mm_struct
Date: Tue, 11 Aug 2026 14:21:51 +0300
Message-ID: <20260811112154.94053-3-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811112154.94053-1-tasos.papagiannnis@gmail.com>
References: <20260811112154.94053-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: h1ia6q3xs43n1b9n7ecyh8wzo63j8ony
X-Rspamd-Queue-Id: 9DD0620002
X-HE-Tag: 1786447364-724038
X-HE-Meta: U2FsdGVkX19wUrMkTLzLQa3zuMa0/ejD9vzRLEuiNDzPPR3XNpqJbEvz7T7hg0uZrGpd0xAlgJEfjoNi68y1ZugP7c8VwuL6Fjfnde9eT2UWNOHk1dKG2GiOsuCWcRXlhUicQaXWtv4wCNpPGqthMRgHR7h6Npx1fTDwrBUgMBRezvmgrWgXYPRQY2Q22jiWhCmUT/B3NfyLRz7uV1G3UO7PdXGPDZ71Nwh2y+V2uSg9anZDPLjHiVo2CaBEcQZnekpse3GlDl9my2f3YxY+QNrZFRHv+nXFaoqOrbHhgJUKN5kjuWep8+7Y3zpsG8HpJdiarY/4Viomulo0P4Xi0Tqa7EiyhsdymnrJTOqMe4zspsR96iAPzsP71rXlYpcRWpQcy5hW3m92Km6hrr92cGHdfnh00fd5nJXkvkVf2OplmIN9Atk6sUKyGHnGSw0rzWrE6IyWvmADeXHOaN5viwJPt0g3MIj+jljreyNF17h2e0HnWNrYk4J7sDR2CBUC803yuC36V/HOoP87iDQW/fNDPfiv4mH+zjv0WRsn3dvHsjIalIRUNRcZ5lkIX467fgiocV4y9GM4IY+VyL0xfs4otCpYryU/uleGeAw8cII49uQp/I7YSf+NRvhSfPoCPrdC7NhSrf7y7HATDhYQ4VtzJ8ZvIZl5ARvR+H+LKXkzJCHjYObMc3a2gV6W0OlaMiG4kF39tb5J3SmebxqoUDGnsEsalFKL7Yxl1LPm2mGPuEYZMSJR2AS1q4UizS/mkcB4AUynvI8uFXTUY4iwj7f+UCGmjmFjRmNnlpiysel4XlUgZZt2UxCAY2+GtzRsS2ylYz1CFpsCCydR+Ys0jqtyN7kUzdvev086FhJhADwpNVb82dxmae/RXqfkKTbPVaX1+ffg5m7UtrI2VW+85mLNkNYLAUvIbiqSlBUpmE5NFH0mFGiDXcorZSHt9efkmGz1LuVP+FYZLsl/BYG
 QQ/IBksV
 kvLJzue0nxtjMioFRtO+qy7YzHAnQ4+Iff2kqfNbb2rUpgetA0fZ3+TXG5F7YDUO3SH6/LPWDqGRpVpKwr26he27mEjADe0TFPmYUZG5U2eWPGByw8cD6mMYkjxCWsV3QPT1Gs2RW8NEHJpZjwZOb/vuh1woM0Sb6y8jezjdo5Zjsq0pmuEyw9v51/b5AcfO8SY6Ygxbsx1Ai2ot3pT7ul6a7ZmywfQ/FDdigcYDxugEcLO36RrAHBuGTkV/tp/NqIWZLW/V/hTv7EEiEZkms+6BRcXwbQU+cjchS3rx8szdjr+aVYZikp9qN6QuwZ203YgBdc9ABMBa55o+zRRgOr8YBoWwFqaTNcm2mDzKGbcnBVBnzLQox6yzjJGo1nm8dDeDtF70MzFF0Jij45W8RGt7SOO7i5pPME1jZVJHqmUaDx7r0+wRbBCpO0jIk8jxQ/0MNv7NUNPiu1bFG8UnH0RUBtX0qSjdsSgfuwIwO65Qvndieb4CXmTGtPBI9/DzvcyzPn2uXixJN1C8S6RjWrRu6FFu7SC1DZipT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When security_bprm_check runs, the arg and env strings for the exec have
been copied into bprm->mm. The new address space has not been associated
yet with a task_struct until exec_mmap(), so existing BPF user memory
helpers can only read from the calling task's old address space.

Add bpf_copy_from_user_mm() and bpf_copy_from_user_mm_str() kfuncs. Both
take a struct mm_struct pointer directly, allowing callers to access
trusted address spaces that are not associated with a task_struct.

bpf_copy_from_user_mm() has similar semantics to
bpf_copy_from_user_task(). bpf_copy_from_user_mm_str() copies one
NUL-terminated string and returns its size including the NUL terminator.
It accepts BPF_F_PAD_ZEROS to clear unused destination bytes on success.

Register both kfuncs with the common BPF_EVENTS kfunc set and mark them
KF_SLEEPABLE because accessing the remote address space can fault. The next
patch marks linux_binprm->mm as trusted-or-null, allowing BPF LSM programs
attached to security_bprm_check to read arguments beginning at bprm->p
after a NULL check and reject an exec based on its command-line arguments.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 kernel/bpf/helpers.c     |  2 +
 kernel/trace/bpf_trace.c | 83 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 6388b6b23e49..9ba3362832cd 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -4931,6 +4931,8 @@ BTF_ID_FLAGS(func, bpf_iter_kmem_cache_destroy, KF_ITER_DESTROY | KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_local_irq_save)
 BTF_ID_FLAGS(func, bpf_local_irq_restore)
 #ifdef CONFIG_BPF_EVENTS
+BTF_ID_FLAGS(func, bpf_copy_from_user_mm, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_copy_from_user_mm_str, KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_probe_read_user_dynptr)
 BTF_ID_FLAGS(func, bpf_probe_read_kernel_dynptr)
 BTF_ID_FLAGS(func, bpf_probe_read_user_str_dynptr)
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 891897f8a1b3..8931b3b2fc9d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -24,6 +24,7 @@
 #include <linux/key.h>
 #include <linux/namei.h>
 #include <linux/file.h>
+#include <linux/mm.h>
 
 #include <net/bpf_sk_storage.h>
 
@@ -3619,6 +3620,88 @@ __bpf_kfunc int bpf_send_signal_task(struct task_struct *task, int sig, enum pid
 	return bpf_send_signal_common(sig, type, task, value);
 }
 
+/**
+ * bpf_copy_from_user_mm() - Copy data from an address space
+ * @dst:             Destination address, in kernel space
+ * @dst__sz:         Number of bytes to copy
+ * @unsafe_ptr__ign: Source address in the address space
+ * @mm:              Address space to copy from
+ * @flags:           Reserved for future use; must be zero
+ *
+ * Copies data from the user address space associated with @mm. The destination
+ * is zeroed if the requested number of bytes cannot be copied in full.
+ *
+ * Return: 0 on success, -EINVAL if @flags is non-zero, or -EFAULT if the copy
+ * fails or is partial.
+ */
+__bpf_kfunc int bpf_copy_from_user_mm(void *dst, u32 dst__sz,
+				      const void __user *unsafe_ptr__ign,
+				      struct mm_struct *mm, u64 flags)
+{
+	int ret;
+
+	if (unlikely(flags))
+		return -EINVAL;
+
+	if (unlikely(!dst__sz))
+		return 0;
+
+	ret = access_remote_vm(mm, (unsigned long)unsafe_ptr__ign,
+			       dst, dst__sz, 0);
+	if (ret == dst__sz)
+		return 0;
+
+	memset(dst, 0, dst__sz);
+	return ret < 0 ? ret : -EFAULT;
+}
+
+/**
+ * bpf_copy_from_user_mm_str() - Copy a string from an address space
+ * @dst:             Destination address, in kernel space. This buffer must be
+ *                   at least @dst__sz bytes long
+ * @dst__sz:         Maximum number of bytes to copy, including the trailing NUL
+ * @unsafe_ptr__ign: Source address in the address space
+ * @mm:              Address space to copy from
+ * @flags:           The only supported flag is BPF_F_PAD_ZEROS
+ *
+ * Copies a NUL-terminated string from the user address space associated with
+ * @mm. If the string is too long, @dst is still NUL-terminated unless @dst__sz
+ * is zero.
+ *
+ * If BPF_F_PAD_ZEROS is set, the unused portion of @dst is cleared on success
+ * and all of @dst is cleared on failure.
+ *
+ * Return: The number of copied bytes including the NUL terminator on success,
+ * or a negative error code on failure.
+ */
+__bpf_kfunc int bpf_copy_from_user_mm_str(void *dst, u32 dst__sz,
+					  const void __user *unsafe_ptr__ign,
+					  struct mm_struct *mm, u64 flags)
+{
+	int ret;
+
+	if (unlikely(flags & ~BPF_F_PAD_ZEROS))
+		return -EINVAL;
+
+	if (unlikely(!dst__sz))
+		return 0;
+
+	ret = copy_remote_mm_str(mm, (unsigned long)unsafe_ptr__ign,
+				 dst, dst__sz, 0);
+	if (ret < 0)
+		goto err;
+
+	if (flags & BPF_F_PAD_ZEROS)
+		memset(dst + ret, 0, dst__sz - ret);
+
+	return ret + 1;
+
+err:
+	if (flags & BPF_F_PAD_ZEROS)
+		memset(dst, 0, dst__sz);
+	return ret;
+}
+
 __bpf_kfunc int bpf_probe_read_user_dynptr(const struct bpf_dynptr *dptr, u64 off,
 					   u64 size, const void __user *unsafe_ptr__ign)
 {
-- 
2.55.0


