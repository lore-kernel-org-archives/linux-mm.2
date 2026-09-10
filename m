Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C807C79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C6B46B009B; Thu, 10 Sep 2026 19:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123396B009D; Thu, 10 Sep 2026 19:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB8066B009E; Thu, 10 Sep 2026 19:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B07026B009B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:47:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 30BC21405EE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:47:57 +0000 (UTC)
X-FDA: 85199492994.28.8EC199B
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf12.hostedemail.com (Postfix) with ESMTP id 77DDF40004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:47:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L3bcli9D;
	spf=pass (imf12.hostedemail.com: domain of 3qUGjagYKCBYEGD09x2AA270.yA8749GJ-886Hwy6.AD2@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3qUGjagYKCBYEGD09x2AA270.yA8749GJ-886Hwy6.AD2@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfCQoIF9r6drT2/q6iU4FW+cbq+J7ShlN3xdWU35XRs=;
	b=27+jxgFgWRN0zol3xuDUlgDJKAPf4MZRQmFu+QtyRgmp7CrX45JaKckItv4E8f5DofKl96
	/8M3S3aJ265Jh5XRWlpNAeDhU7AzFo//sZDcIpduxWjhGYEOlkWcjhgaH123PAur9M78le
	3ym4QZOwOa6R8OwV2Rps4U39QybtrkY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084075;
	b=cE8+5+Tlz5/VNqILucbcMUE7mCut9iuuHCmJ3w1y3rv2qb43Xe5QIL6Q8PXKOqWGsVbCYx
	u3xqNnEgdtOnCS2c/XpKb6NMLfWDAxa6wmfV9tefv7tqUWNk1quPonKYdJOJCE4PgcnDHl
	0KlgNoVkIo2zp82zTlQJWoSyexy/+Wk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L3bcli9D;
	spf=pass (imf12.hostedemail.com: domain of 3qUGjagYKCBYEGD09x2AA270.yA8749GJ-886Hwy6.AD2@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3qUGjagYKCBYEGD09x2AA270.yA8749GJ-886Hwy6.AD2@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbee6bb8408so408010a12.3
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789084074; x=1789688874; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MfCQoIF9r6drT2/q6iU4FW+cbq+J7ShlN3xdWU35XRs=;
        b=L3bcli9D0dnrEawXEx3cD4X+hX/OADADMj8NUMchtyglkw0QRFK/PpQK0hvAa2Ky8q
         lzusPuFawZ0GsF3V/+TTdY/2U5R268LfBejK7syvjtda3e90MpbzC6UxYQXtWToZcD0J
         rN5GasaC1QzbIP4cHOXdUv8kWbSJPRZEzx0bV67i9MqdnexSDGZ8BOc3AAJc7XXp755C
         jaEfsHJ/oLZaQUxQ6G20y6WG45nLBI5hCyU4b7GYK0vc/eQuEJIAePsR6cKnIBHtKndP
         YpoG6V9ge0AhCvloWrpT6eAtoBv7s626ybhl5MEW6pguRzccH7qxQlUa4TYyToBgYvtQ
         Z82A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789084074; x=1789688874;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MfCQoIF9r6drT2/q6iU4FW+cbq+J7ShlN3xdWU35XRs=;
        b=iA4lpGz1BPdk+xbfKIEY5nmnAKKBHbZi5S8P7f7w6P2knoIpWdNH+xjpQteJmeBLsz
         zwbDz4kYJkuR7z93nnzxXGV/ebdUTDSSKAoqsHWpyCymHqLXyPtlNAknEfkIcOwER+Jm
         zNiDJQzrOa3jiHQFJ83NQAyyZpU4Hym/hqQNbnbJxilzKYpIlKMuEJmKZmIzHNubaP1N
         nHfE2vZCNXU5FtGZyUDgPgInoFtftMeytKWe0Ysqq7Zq/3EpdWjpD0H7aB/8KS1TBI+J
         vs0rHLpCWpcS5Pg0TbOnAO03F/CWt75ZwLsziKC8j6aHGaot7ShncxAkq7WPpdXfXejc
         TrgQ==
X-Forwarded-Encrypted: i=1; AKwUvBwS/ZbIOOt1Jt8r2gooKRJEnwsKOUxGdzPtVibigfHfgv1TbvqocNUZAuEHIwDOIg4CdsDhgBrKnw==@kvack.org
X-Gm-Message-State: AFuF++lFgqACHfaZ2xwbp5yTeFg6NrLF2lWFkvNPz2dIqqkw6ThEZbon
	FlvzhzQkDzPw8xBMptvFTN7jjt4N2/H+Uuw4J4hWWeYpfYF6BQOTXj0Q5p+m6OMPnmKd3FnXvxj
	VdPDYyQ==
X-Received: from dlk12.prod.google.com ([2002:a05:7022:10c:b0:143:54dd:1d39])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4309:b0:3da:1e7b:ea27
 with SMTP id adf61e73a8af0-3daed3b7eaemr2196858637.21.1789084073982; Thu, 10
 Sep 2026 16:47:53 -0700 (PDT)
Date: Thu, 10 Sep 2026 16:47:35 -0700
In-Reply-To: <20260910234737.1340642-1-surenb@google.com>
Mime-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260910234737.1340642-6-surenb@google.com>
Subject: [PATCH v3 5/7] proc/task_mmu: change proc_get_vma() to stop returning
 gate VMA at the end
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xjrqqpb56y8zzqik7u3zfdtc6upqdb84
X-Rspam-User: 
X-Rspamd-Queue-Id: 77DDF40004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789084075-737225
X-HE-Meta: U2FsdGVkX1+zJ3XaGi6HmadeC9q1pRzexEd5o6Z329oK9gmBTAI2uA2h7n1jpJIo7tr+tyRkDuzonuQ00VbwrLB3w/cNNGPSPZpeTwH/L4TKVDB8hFci4J4DHbxcy9J9UbGJbzIfcCKr8EikXkezTYPALXP6ciEteKhmMzPEucFe3XQv1CE+u8ZbLDRfbuw4kSVZxfQirOp8d0+xFrwNOxx7A/jZlmn3I3FappgRcrsIwW0YdBDQ7id9jiocOqyLJlXyNuQoYxnUhu9z0Or1JewiJ7ecjzRfsUWUf75euDU9jEtwcwYXRSNSJ1SiqzneFVvyJdY4tDui0LOKshT97NLOCKrwQujo8kRxyU/sAW0f3hLFYU6Zy/lUk4EpC1lStIGNotJHH/aoVjCOGzRAqo8FqeKO2n0MLTYidCRLuU2JxWgMcHAX8SBpLVyuij9qSxhwsAHsu1K20aYjtU58xVmCx44PzfKmK4i6UOzJICf+yHpfuNQFSGUjat1yqahAGkz0GbOphIghny3pj/1kZoRPMK5asDAV28U+cRRRLcoVBXdvKZqsOu2Eas96gwHhGxkxSJn+94OpAhL2PjGMywaCyI7EiWJcY3Rgg14pU5crVWkoMVoEoRVaoUwg4o21KUcQxwPNeqLbhnuGutfR4RFaD4yTL6EIjU/tObowWPeQQeiIh8b54S+LjiIUvnK+tPqkVmB7xr9W4tUy4mJVd8XvdwaIraaML+UUQ/nK7K0JshWJ2dTs8qCJ8NVNzpRoj8Eocg/Be9EUkxii3qLOjx7uZPw8LobDIzSQ6NGRcvNuhibVNgLs59DO6afrJalbuDVZDsql42Wa8m91Q3tI7tj+pzsN+c0rCAqfyun1T7qbdrgBw7YBEYPyjo+0tmVxvSuOU1oS6vgccrueermnKrRb0jkVulKmViAS4H/Ugisd6RGBBmB6QkBBIOg2nr/fN686vA6hGGv5IMw5F0T
 yVB/oSF3
 /HGng3B6TO1C6U8RGersHhoLMtQc3vGUcg4w+eOZTSM6oOeb0zPCnCnfhGWMyfLsd/kMS8P+okCXP6kDDqeGWnN5RS1g4MmxcXXW6yDXoGe6sBBiehtEZyz+yj1rK8aDNWLC26395tFEnQReDK233msdELRv6JW97G0ErIFx/r5uZyyc3w/76Lha0zdjFSBybZrnaYPlunTH5CvsQZ40qchLTpqA8r6yBfC8qeQWhmt+6Zq5biauRvNKkdG7S7PvW0aQ4y/oP2dWlnhX5KcBU2IMt/DotUMyjfPy5gq807XfKdhAyGReD8xT7ej+XKix9ig5LSpjRVivgmDOnpGRP2m5+6lSBJgFG1VaFvigfHl2Xj26piziHHHkqtOFSMKxULqKI8sL9MyFNvRkyxsgbaQtmdbOQrjB+lwJJh7Y+td+ulYAeU81q7buTK/7vmbMVIOLaO0r0RHoh0765YtwMMfDA7dh/bKCd6IoSl98vWxkpkGi4DkrPxmGQRU/Mwlw+2Q9BXCcFOWkoThsl3j22QWcde1vIdy1MjGfaI5X0FCYdi8HG2SAvL9NcLkf+BX3SdGgMuaD1RSSKUI9YGTlDEAkv9RwoniwCaj1/ZQqpAh69B2Bi4S00mpHXkDinqn8SqC037aQJTKzHE9EC4hUK13mASTX+CHoteFgA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

proc_get_vma() returning gate VMA at the end is desirable for the its
current m_start/m_next callers, as they need to report a gate VMA at the
end of the address space. This behavior is very specific to these callers
and makes proc_get_vma() hard to use for other purposes.

Move this usage-specific behavior into the callers themselves so that
proc_get_vma() returns either a valid VMA, an error or a NULL when no
more VMAs are available. This makes it more generic, simpler and usable
in the later patches.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 fs/proc/task_mmu.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index ecce7ce116cb..9a3c996c1d61 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -236,9 +236,6 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
 		 * found the extended vma with the same vm_start.
 		 */
 		*ppos = vma->vm_end;
-	} else {
-		*ppos = SENTINEL_VMA_GATE;
-		vma = get_gate_vma(priv->lock_ctx.mm);
 	}
 
 	return vma;
@@ -248,6 +245,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
 	struct proc_maps_locking_ctx *lock_ctx;
+	struct vm_area_struct *vma;
 	loff_t last_addr = *ppos;
 	struct mm_struct *mm;
 
@@ -280,16 +278,31 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 	if (last_addr == SENTINEL_VMA_GATE)
 		return get_gate_vma(mm);
 
-	return proc_get_vma(m, ppos);
+	vma = proc_get_vma(m, ppos);
+	if (vma)
+		return vma;
+
+	/* Return gate VMA at the end */
+	*ppos = SENTINEL_VMA_GATE;
+	return get_gate_vma(mm);
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
 {
+	struct proc_maps_private *priv = m->private;
+	struct vm_area_struct *vma;
+
 	if (*ppos == SENTINEL_VMA_GATE) {
 		*ppos = SENTINEL_VMA_END;
 		return NULL;
 	}
-	return proc_get_vma(m, ppos);
+	vma = proc_get_vma(m, ppos);
+	if (vma)
+		return vma;
+
+	/* Return gate VMA at the end */
+	*ppos = SENTINEL_VMA_GATE;
+	return get_gate_vma(priv->lock_ctx.mm);
 }
 
 static void m_stop(struct seq_file *m, void *v)
-- 
2.55.0.1007.g17ff1f9808-goog


