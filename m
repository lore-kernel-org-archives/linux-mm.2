Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBC35FC9ED1
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 06:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6458D6B0005; Sat,  7 Mar 2026 01:42:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3526B0089; Sat,  7 Mar 2026 01:42:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D4886B008A; Sat,  7 Mar 2026 01:42:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6396B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 01:42:19 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9712A1B855A
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 06:42:18 +0000 (UTC)
X-FDA: 84518322756.02.8FB0464
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id D9317160002
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 06:42:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cBjKsg5G;
	spf=pass (imf08.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772865736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=60kOj0Rx2KfuuAB5qkGX0OsAbGbuDnekxaZcro1gQO8=;
	b=D+XkrX8f61kjM8gquHAfmJU4z8WbdiCfbQhAfoRlYoPlQHFgStuVkO4/xTpKXltVXEzqIU
	SCZU58Rr9S7Zjffn5IFbovjaIWjr14v1WH4pV/DzTFB0fx52EKHz2RJ8U7ACz1w9GS+BHc
	g8Yt7L79Njt7D5kliWTgkNEaBx9fJoA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cBjKsg5G;
	spf=pass (imf08.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772865736; a=rsa-sha256;
	cv=none;
	b=He86D8OUb8PqxzkdKOwKu2fvw3ULKwad0BA+Y8q5u7JfegGOzDhyenuTJ/lMnori8Y6HxX
	rhvlVAkuYHEymoNZTjguN8DxuUSt0OFpaoFBWl9MpOOw1swaqaadIkdLDNZC4nuIKe+nCQ
	WuRAYrNPcR+kJNs23i7P+2HR2vzKQ8A=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-359a5d8b3f8so2447287a91.3
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 22:42:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772865736; x=1773470536; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=60kOj0Rx2KfuuAB5qkGX0OsAbGbuDnekxaZcro1gQO8=;
        b=cBjKsg5G+UJVfZCSl5g20bvqkBMMDmkjMTQ2Q7VfGmPJRhgmPGcDoRkcTJH2/vnAwJ
         eSxKppzMTZu0VNv7phNOfVsAPOZ/q2m65NA9z3H12rc9gemMlmL9J5GP1dkq5J6xhpmK
         uJpYIOmy0x3Z7wkmHuBze8ZvBhsIhUlEg+pII7oYol7qWbezPMd9+PjwWF9izQ3TZFaW
         Vcy7RcZ0bKZbcxZMaK9PWZN8oR1RheS5oAD6GJsmhDD/7Ubfa7TWtnHHOHjwryeWnZws
         Sk/9URLHXjQUyArKlpPSMX+uFOkUV8LY2iQyCibM7CV1mQJFPAB3YBHEkdtEA/0MWjGa
         n1IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772865736; x=1773470536;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=60kOj0Rx2KfuuAB5qkGX0OsAbGbuDnekxaZcro1gQO8=;
        b=LL3XITxWlU9wGV/LaFyMGm4cVF4X52pAFSNAVQHPE3KcaJR4OtS1zqXOr/jWIDwviT
         I5Gz9QV2pzRDkj6JjcAzmUpt+RC8542Uh3NNqbXCrUiBtjP/JnmIKHWt5xbv6rqMUlQY
         YBMbceCh07J1H+rzIlE/naS1l5G6nOcdjFiPz/7K/U1OcXhKZaVBncDkN8afgeOY7/v8
         sOdJnr5snQKyupph4YMU0FseNKnc4/7tPQUruyap0wmVIe7qjfwWZaME3my+W3qdM2eV
         9jtUGC3g5U3V2gSnDGVezuIYGRWTIz2dub3qbrCQD9W0DJ2NXQzfTkT0eu/9+jO9S8Ry
         IhdA==
X-Forwarded-Encrypted: i=1; AJvYcCV4aRL8IEVLzXfn3jhHXAwitmu3zzfRLJ1wSTHI0MbVDObXBfM0apNuJUrV7A84K0Zo8Y+1HIz6fw==@kvack.org
X-Gm-Message-State: AOJu0Ywn6h/mGTvDR6Rq92eVIs14MesT+LU995UDtH8vus0h1g+GtwSF
	JFE5fkwQogcizoUkny6okWkh1lYnykg5I7KyF65Nwyznk5FK5O7yF2SH
X-Gm-Gg: ATEYQzwWQF97EN3UXX4jHB8NcoRSbyeMNIRWmBQCDdneeN8Gqk1jfnxTzONXzLRmcu6
	N1J6/x9ZQClrN1+B639nqLht01rz7r/ApACI/dm+6sdwG6KSj7v/Wo7dX3NRv0con9aApmdvTwM
	JIlW7V02O/uGvmEkxgj7TSmE/IIG8rWEfCCCdrrnDKYLKVq0+he5zefYLqXv6MDs0lCroHttpck
	9aoYM1Qi58K62m7YDwJasAPMQnTV0LlAjE+1Mzhwmjd4QOp1pEO48XDwC+o5XEFWc2Gw+Wy+zpS
	3NtLVP61wQhW5Z3eHDBxOIbFZkhMRDQdDz+afOdTXEBydfk8HBeAO9N2zs6g1BIiDwpHxqaBxMB
	wNdwEeRP7aeYwHLETkcl8Q/r5S4TirCQZ2zMBueoCsK/Fv57vfMfl/3HBUZ40I5UOH8+Csn3PVR
	mHEGo7rwEgQG5mIit7W+0Ib5W2D4x3wgeDktllF4ZjY8+MhgjPm+shOzwqxjAOowBq9ThHAXuHg
	zBEtDE=
X-Received: by 2002:a17:90b:4ecd:b0:349:9d63:8511 with SMTP id 98e67ed59e1d1-359be329dd6mr4323714a91.25.1772865735476;
        Fri, 06 Mar 2026 22:42:15 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:4191:5f1c:7dc6:bad2])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739dfbf4fesm3507947a12.0.2026.03.06.22.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 22:42:14 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kees@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brauner@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>
Subject: [PATCH] kernel/fork: validate exit_signal in clone() syscall
Date: Sat,  7 Mar 2026 12:12:02 +0530
Message-ID: <20260307064202.353405-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D9317160002
X-Stat-Signature: 8yxjsax7ycn9bqa9hzstadu9wn7dghtx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772865736-869026
X-HE-Meta: U2FsdGVkX1+ar4cJe+zK5MzmZl+dOOuL3SwLizdaYOnAuX+l2g40v6+QspJYpRhaLDreM86M5hlA1HODS+3WlyMgPvQ/GZscq+BpE2egTw8vdgeUjmgAsahDwztwdXNbwIkvX53b982JVtn916i+mAM337Sy3B4FdSyONCBiM1XQiwo0fluX9G6CuwSXv/MVsmIoFJNrQB5OOgkWiA7TKQYMgP7gGjZixkzy+Vd0SWy0INCVvJriaSl3EYWp/JnsDaVQ8l0E/SwzL3g0RzG/nGjt9sYNqhb3kmkc3AvNVuo7+vitmcc75w09801OSvoR0zbMU6rw3JgR5DqzSuMr9UdbT0rI0FQC/GBjDvTPa26+WhWoaB6dRoTAeiU6Hy+a9W1igmdkDUipnjAcgF/Y5e6MDGeelICP2iJQQEAcc6Z8y5wmnO0duquw/9hjSL4u3qc0rVjfnMQnCFFNkysDZZ2gJbgbr7nUr32NsiShLi3zJRs+cHEKTVQAn29cL9VnW/o8Jpt4Jkv1hB6nR/Y1tnDQSkC46KfhGXC/kkBH5PrM/8oBEweBVVr1QE0mF4CNtQ3jM0axKZX3t3yqSyJMXH4QKaWMEReE09AijKuHDnp64xelGQO0+FcXrxFM7QBl9G1JhcUjsd+o3ek0CbL/LDswyRWGUjdN4pJ0YEe0Vc8vJkh5rEkN3woiCyBqvrSaPWBZAFQHbs8W/9MGz5K7tqaLsMmqqwxT1pQFpgsh0fHgyi+gL4alk99e6zzTsi3rsDVZCbMwJf6UNpRB7h3MUbFF27/p6O4vRsQ+R5K7fDYvcX8LPGiBpVNs3kT4b9bMDVcBLjlsRkxi5MR0vU7sl5RCRnqa8gsGr+rs3302pnQnvxWGqdq4ujwyuHIsKw+Rq/TcVkrUmtYII4j0BxtLj4ikzHfWlIN8fYECgYhs4MGl/8y6vhB2Lax8HHA9QAFQ+9vTbMQhPHgQqoJnQVf
 QYKqiJ1J
 H5hxkuVok7KsNJA18VXHBPFtYnSmCHOZ0RcZJ3HnXHWfuHnsDmQkjGvW9GuG8iKuF5NMJnC7CnQbq0cXRvd61ycVYeT3sH99KfND2vWBCNGzcMT4/fqgBo28aKvqFhDphu8YTfV/Pfm+a3gsEONGCApQYOQqTWHvlOCVr5Jf62k/FTSmMXsAHAxCLvckuJMCag1/wAOPp0G1Zpk1lqMc+Q1w6ODd4VGfTcwX1K3l4n890AkPIIZ6BL+6tYj+HNIClY9N3MTq4L46BDyU6j0kFMV9lMf77xfZcqJGFN+IdzxMVOcnnXQHB7nyxPaYLIn7Xp6kzNdKtUuXcqQb0asbldbC748ddQ5dgYjwDuJPscNGq7eTyoAS69TzRxWz758CyELVtGWomG7NtP3tv22VyMG3pb+yzjQLKJQsRwQp6cQ8h3DsOkKqicAPfQwNLlkf+H4vAdL/w9iU3LuWwTX26EDuiYYg9+fl/3RsBVNHucqwuXpCZRA9kupwpjSXt5CA6cJv8jTvnoB2mvK+k8GH7tGZX6D5/2gfMFoRfY9s59TpQn1sL71ntyzNMk/fNOli47e20m31B/FTj4hGGgjHK9i8pruC02zi3DAH5B6zdGiakYj9zw4mVrL5M7B61UeIOV0JUDU+DSHJmZJFeYnhxnABz+/qX3P/1XaLAQNVtObGC0C/uRfswlnu3kVFn3srJORyMbQVuk3P7XVWwBR26nwvetGGQeCbZOkIVgpajABhbibE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a child process exits, it sends exit_signal to its parent via
do_notify_parent(). The clone() syscall constructs exit_signal as:

  (lower_32_bits(clone_flags) & CSIGNAL)

CSIGNAL is 0xff, so values in the range 65-255 are possible. However,
valid_signal() only accepts signals up to _NSIG (64 on x86_64), causing
a WARN_ON in do_notify_parent() when the process exits:

  WARNING: kernel/signal.c:2174 do_notify_parent+0xc7e/0xd70

The syzkaller reproducer triggers this by calling clone() with
flags=0x80, resulting in exit_signal = (0x80 & CSIGNAL) = 128, which
exceeds _NSIG and is not a valid signal.

The comment above kernel_clone() states that callers are expected to
validate exit_signal. clone3() correctly does this:

  if (unlikely((args.exit_signal & ~((u64)CSIGNAL)) ||
               !valid_signal(args.exit_signal)))
          return -EINVAL;

The clone() syscall has no such check. Add the missing valid_signal()
check to clone(), consistent with the existing validation in clone3().

Fixes: 3f2c788a1314 ("fork: prevent accidental access to clone3 features")
Reported-by: syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bbe6b99feefc3a0842de
Tested-by: syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
---
 kernel/fork.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 947a8dbce06a..dbe26ac6ca10 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2845,7 +2845,8 @@ SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 		.stack		= newsp,
 		.tls		= tls,
 	};
-
+	if (!valid_signal(args.exit_signal))
+		return -EINVAL;
 	return kernel_clone(&args);
 }
 #endif
-- 
2.43.0


