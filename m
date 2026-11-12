Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5220606AEA2
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=G5XnN9lW
Received: by kanga.kvack.org (Postfix)
	id 91DDC6B05B4; Thu, 12 Nov 2026 09:01:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CDE56B05B5; Thu, 12 Nov 2026 09:01:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E4E66B05B6; Thu, 12 Nov 2026 09:01:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4220C6B05B4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:01:37 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 760E11A0639
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:01:36 +0000 (UTC)
X-FDA: 85426629792.28.4B517C4
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7B8771C0016
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:01:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=G5XnN9lW;
	spf=pass (imf20.hostedemail.com: domain of adrianhuang0701@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794492094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+d+2w/kP1HSpx1Wuo82bePoixwqF95UhUQrN/Uv14yk=;
	b=qs80BmC6cXztgIDxlhgJufOQ3gYqV1BWKOzYJLIPhXRWNpj6PiJs4mBLfPdq0+TnhOIl8U
	p9SV/daubyulq3mkn/dmibGhSo7U4GkbGSMqhxTo30E+aSTPRFKet8GJSareJNfcUsE1/S
	nia4XV4Rexmatr/079e8xtr5P0yBF2Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794492094;
	b=7M0Bm2fRczVrTTstZcMKkUgumaJfLrRbSjpcI1P63NmrUO0LN4eUZf5kyK9SlEHyMsqSP5
	h2Ut8ZB7uqTI8H3PilxuyFgyLz3ow6N099djkdoHptFsTTh3ryq0KcqjURlGWNN8WN7DcU
	0itfRmqvfJsZH/Dc9zq7q2U0cefl45E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=G5XnN9lW;
	spf=pass (imf20.hostedemail.com: domain of adrianhuang0701@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1b3ada81853so4000146c88.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794492093; x=1795096893; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+d+2w/kP1HSpx1Wuo82bePoixwqF95UhUQrN/Uv14yk=;
        b=G5XnN9lWZYbu8eeWgmTndt60/lMUCXnC51+jyI3KSsPI9uVojQ2FPPQIqMI+e63XDf
         uAYPJXCS6tjtCLb5lo0QCI+xXNI6gp8t9c3+G6itT1jdZMZOkLP9wy/8czdgJ/N672AJ
         j//7KVQNcjBLhI9wrgsUhAUujKZmc6T5o8vnHdJarOwGechEMSjXR0WMnwq+PbYRt0Xv
         Qx2P7LeOoirWRoYWY2e4o4EZ/uxmcjdi456xUKLuYejo0s9ZAe4oQlUunoENCb5xSl7D
         SWr2O5oJzTZy3CtMrND1bBCr5ZisY7iTfHbuOqqwVQv2lY1O+GtTNLS91EEsqSPmtxCn
         7Qlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794492093; x=1795096893;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+d+2w/kP1HSpx1Wuo82bePoixwqF95UhUQrN/Uv14yk=;
        b=AIUoqJnH2HlFFixiR/QWuepwKbVaohLqfmVz0pbg29p2aXU4xO0RZ0SQQ0XAhd/Om3
         I6u/9IboJBrBBnlLM8XbsntI9m107uqXzp4r2UULcU4v0WEYkahQkPEuoLXim9Eo5oh0
         wrd2sUhG3QQ630RAI/3X9iu0Gp+RCpnMrj3V5PUTdmlI5ROSt9VsZqwjFGHR+DaaUjTv
         ztzPQvKOQhPJoQD7l9keNx1bmBIC3FEKrlXFAfZ/uSHZIPLxQXKlkUYQ9iykZUe9n7ob
         hobP0QGB9RUQ2YleOAShwyqUFFYmeLEngm8J815bIIoocgsjo+bMQ9cdW/GlT0DAWfu8
         7Hmw==
X-Forwarded-Encrypted: i=1; AL+hErFbgiePvRsYfvTvuvhJAq2XUwWURG6eSAABm2RiPRIeq3TN/N15oyFonaBlMjij4z2jKlASAyUeZA==@kvack.org
X-Gm-Message-State: APuU4Z+bMaIrcvDwrknvBXF2gI3ANXvmWvmzjJOiV7lYpvhL5bmnWIyv
	kukCKXKLRzkXWa02Kik9m6hqSXr9qh51htX2wz8eCe5S3x8HxcNf8Zny
X-Gm-Gg: AYBFou2D6dxvXqA/O57nD9+ryvyXAoaRC23qO5yHcEg8zb6uezsqLRXaIXa+aZIpkgI
	pU4+gRVPJySla4ewvF1GxdxvIX4W27FA0r8DFmieLQjDpW/m902jKAqCDi+QcWJJFPtXq8+Ss8z
	TQUPKndEKqL2QBrMgIl/GusxhlEOSloHBirAWWtSmOW/q3nR8606Pxn7HajH2Z2lnCuvRst2TTZ
	vIAqg6UYtQ8CkQa0S1rZ8LGHyQEb1VLLq/Rn7rtFrgnx7QVqLfwMhfyqT6xqGUP8+vt0ZW8tLoq
	SeQjL0eDE2UTtLWyB/67YZ7ameK+pO60/+y0BWTCDWzrlPU8I5PsPIV/yhNokVTmhilX7/Ci1/1
	ijK/CpTAOjna7UhZaL/AyPlG5dk0nq2ZojpVZ1yptzZPda2xEr+RAZXXSzleEIOSzbTzzyKGpT9
	EHw0lWJj9gGGZsreM5F4DSdWkciB4S6IYzTyqmeUT/I1WUh2Mqx6LagldlIP9Z/zPs1+mfrgLEd
	WrCGK1oRdH0eCH5yIshfL4t71zRaFtKi5KbVsqnEZYN3pTBVLUhKhWWLQpR/cwnliEhuZCMNvKG
	HSZI8hoZXeTrgbI2gA1IjMbpBwVhmTKHAL2PtUnnnTzM2IT1pE4LCoxvlVrOLfuPTVfQEu4Nc0Z
	b+24PbrrvY13m4le5h2atPFA+qHUEYg==
X-Received: by 2002:a05:7022:c93:b0:176:a225:e364 with SMTP id a92af1059eb24-1b3c0342f80mr4576641c88.35.1794492092808;
        Thu, 12 Nov 2026 06:01:32 -0800 (PST)
Received: from AHUANG12-3ZHH9X.lenovo.com (static-ip-5-78-56-61.rev.dyxnet.com. [61.56.78.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520cfdfadsm31478659eec.19.2026.11.12.06.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 06:01:32 -0800 (PST)
From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	ahuang12@lenovo.com,
	"Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Subject: [PATCH mm-unstable 1/1] fs/proc/task_mmu: advance seq_file position on interrupted VMA lookup
Date: Thu, 12 Nov 2026 22:01:01 +0800
Message-Id: <20261112140101.647-1-adrianhuang0701@gmail.com>
X-Mailer: git-send-email 2.25.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ixy9d6shkmakg5c3pjka1kapczurtsag
X-Rspamd-Queue-Id: 7B8771C0016
X-Rspam-User: 
X-HE-Tag: 1794492094-500164
X-HE-Meta: U2FsdGVkX1+DWNQDe5s3Q/+PwbEzjussRtrUjuVgx+Da2+XkW7c0kEqkdd/IUSoKfq1DVoqL8jPhlEbIJB8V6twiYkmKKZuw59WYqy8gITLytCUWZQllkHN14kvDIVpmoR6XbiAQLo4ggp2O/BtIWbPK5eLAO47CK/GEhQfhTngXXxJa7Sca28wB2Z8V/PZoYJNp40oIsS81buyvvfxZJ2oU1v9kCY5zxDUIWotzk44+QovJyNUm4TOkJe9XZfk2VL6QcgXCufpaZvXRUkmNOgRFUJp1kfeuu5/8rNAJ4JTJcuitIgkajiqXZF1QFOJOhiDPr9UwonOVY//9o+mqa4n+TQEdCpW+b3O9V/eO9rmX1UTWjvEQFoLMl7H9iQgRpnHK+FCgK1tYXyuPqgbqeVxTMvAYHUNyk8sbdsKGv4Pj5a55pxl6loQvxWaBr/HyIUSw1FrDQz7Daq8t6B6REsakbHzRv5Ex1q3aVKE4NeYa4gDk4eIu5rbBroMmDih8XIWXhbmM+VTyf6rV3SLqASxywsufLLHOSE4eYinc/my78CTHBAZuTvxN75XfrZCM9ahLRc4WVjuHUqdlJPH7aH68+dMEXl2RbB304GGar9IXBGX+SGbckv3LEmhRL1momE3P+t4pzyDnQzb2zM7LycFVECCx5O8fs0TtFvvyK0QRxZOrdrYF7LEx6fpvNpybx1KoXzoUTfanz5H20ZXJu2lfnaqdn4Z8CaaVFWfAPQRcjzcovo3jlwwngu5NLQZkl4pQuZlqGp/V7ZDif25oLug4mIHUrs/fuIqFkQnhpmBG4vhpGgvkbHWSpPoldtf6tZD+M7EgzaiiSSUO1FPrPzUxv3vBZIeugD1qnCBWUYtlMU3XCjNsjU6Ep49ioZGbtnqeRWXzjOGrrPwZ+VJc3PL1AAkU/rAF4aYKxJZuUNQ4r7QRRaZAxndrljhX2pHa7A6yHNNjomTFT/vSAbS
 aPLEIqZW
 JV3/yFbn/XfpXkWzbeXF/imzComJqU+eTZaclQZ1Rrq1nCcF2UTkq95T1xDYbllwbJOmUJ9MqoxqJ41ev4f4uj+jrzGaIN84Qpvsx0EWD3KPA/hxiWgYltOLYUomfZ4nxm9Ih6uubBKwQpYdnQW0gYMM74Q/CU7eToIjDTlBl7B/FHlR9Qp5D+pFGBkv80fHQp5UB/8uNN1AUrBweXa6iVFRuoWxllMVam7DmlWQR4YlhMLiZ635Y7KvMipnEZqzUX3BjvJfHIyvZ4+W9fDEEjwf5xtkoY00l7cdMfXwPXrPIznZkgl0fXMevTHx8CrLQfg3UO/7LER1c6Ucia1XPA2fJNn6ykGZlg5qc4d6IUsxuM/Yj6GZnLomSODiliB/V8QA49DLVPwU8h0ZfzCk0VAjXfLcuDpg9CdP0/D6eCrHhtqBfryk9Yyx6dVRhxPDCPTvwtpu7VK/Au1Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under
per-vma lock") introduced the possibility of returning -EINTR
from proc_get_vma() when the VMA lookup is interrupted.

When this happens in m_next(), proc_get_vma() returns an error
pointer without updating the position index. Consequently,
seq_read_iter() reports:

  seq_file: buggy .next function m_next did not update position index

The above buggy message is reproduced by the following command:

  # stress-ng --vma 0 -t 60

Update the position index when VMA lookup fails, as required by
the seq_file interface. Also save the original position in
priv->last_pos so that subsequent iteration can restart from
the correct address without skipping or repeating a VMA.

Fixes: 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock")
Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
---
 fs/proc/task_mmu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 22361607020d..164b4efc5e09 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -221,6 +221,16 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
 		if (PTR_ERR(vma) == -EAGAIN && fallback_to_mmap_lock(priv, *ppos))
 			goto retry;
 
+		/*
+		 * seq_file checks that the position advanced before it looks at
+		 * the returned pointer, so an error return that leaves *ppos
+		 * alone is reported as a buggy ->next. Advance it, and keep
+		 * last_pos at the pending position so m_start() would resume
+		 * the lookup from there.
+		 */
+		priv->last_pos = *ppos;
+		(*ppos)++;
+
 		return vma;
 	}
 
-- 
2.43.0


