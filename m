Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FDDDEC1E9A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 10:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE7E66B0089; Thu,  5 Feb 2026 05:56:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D94986B0092; Thu,  5 Feb 2026 05:56:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA12F6B009B; Thu,  5 Feb 2026 05:56:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B264C6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:56:54 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 636031B2756
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:56:54 +0000 (UTC)
X-FDA: 84410100348.15.DAD70BF
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id 72B9B1A000B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:56:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tlQvUERg;
	spf=pass (imf19.hostedemail.com: domain of 3PnaEaQkKCI8t41vxAH04z77z4x.v75416DG-553Etv3.7Az@flex--aliceryhl.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3PnaEaQkKCI8t41vxAH04z77z4x.v75416DG-553Etv3.7Az@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770289012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FUC+IUQsyh6FSH9XQxPnuJxAw63qa2QoaAdOGHxWeSY=;
	b=2BKCSPjZ80M2Nyw33qdvcUWDj2CnhaDVDOm9DiC8GmaLYQYpvLxx+K1OkL47AGZy7oagrK
	DxnB7AjbbrCwMQ71duHIzZIwCIKTuBDUdqGCwT6fylHJLs40404jUbI3XThfr1aXqFWJY4
	Vgthqdym6+6Cl8wimVB6C9shS4spflQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770289012; a=rsa-sha256;
	cv=none;
	b=ExvjhXWU3F5pOZQzXlonz5W6y+I/vqAKqwzAX9ruyWLjGfW83Xb02Wx3p1WFhbnWePmDs5
	U8lCSfAG/OE0PUiZbOu1PH2WFNdTNkai7PTB2SfDh6cTzK6dtWN4R55hYv6qF8ekWIOLlW
	FhqpLQrRQDB2rDsvdP6TS9JhM4dwtc0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tlQvUERg;
	spf=pass (imf19.hostedemail.com: domain of 3PnaEaQkKCI8t41vxAH04z77z4x.v75416DG-553Etv3.7Az@flex--aliceryhl.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3PnaEaQkKCI8t41vxAH04z77z4x.v75416DG-553Etv3.7Az@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b874c325d10so76126366b.1
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 02:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770289011; x=1770893811; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FUC+IUQsyh6FSH9XQxPnuJxAw63qa2QoaAdOGHxWeSY=;
        b=tlQvUERgL1hgT8GX3bv+O4nHiSKmgwxDjFSNsfhlhh0dcRhdq0YUYJOI7hesvcZ+6Y
         jjGMLV8YKMMaX9x3P/MjOskOwEAjE0YB3nw72hGU91yvWSLz+LocDvUcqJFiJGcisNTR
         MJnqUQgTbpWCMdNOmAXHoJOn8oMD0o7D56la8KipERJ1+IWWDNPjqn8frP1nTS3tyvg2
         agRPqaEDM0mK35kQ4TXK0jGUBEuulk7VqOQM3g+UU09ceusTgpyOhumRST7QSZ21KVIP
         CjEQzkMZJMM0t0TlEHoq1GEwG/D7I5ycPmYYrMfpvkoP91N/zbyYfZDexbo1V/xKcJry
         17Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770289011; x=1770893811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FUC+IUQsyh6FSH9XQxPnuJxAw63qa2QoaAdOGHxWeSY=;
        b=qxbi1NL9lRrGi+FA6cEvs9xHTtBGqmN+aTkPA2fhsMxGsr+xySBXWSWkYt1+i+8A4B
         oCwshVnXNUUc9TkqL7LOodE8Lp9TPsRJ4hDc+u5HzrCt32wGWus2KGbAn0/P+NqGuaAV
         XIC1ZwRNRi6HjJhyvaKxEFq4XZx1MswKUuZ+xEj3sj3c6Pl+cKPhk23DOhzZjjzeUJ1o
         Iqgq0RmwYJcg2pb2AaMm46EVSpjDMvOTRFckzFnj03GvLpBpSTwQPjckc+LU2KbPhpmx
         cZu0l/MueHIUOZPaHNRHJoMutLXYE3sPfBjQPLM1MbZTEFhhovnYjS6nofaAyjtbOPiP
         /2Zw==
X-Forwarded-Encrypted: i=1; AJvYcCVrVUMHwwqTPTZ9mg66EWIR/LgyniQ0vasYoAVpOFsGOC0j7mnAQAmIwFvoRPDdlurGTHqmfpGHKg==@kvack.org
X-Gm-Message-State: AOJu0YyYxUxpyz+gwOmQe3KpYlYnf4kNerO5dDqcSCYDW0h7UWuwC+mF
	wk2R5ErzD+g1UFMCPS0sCKfVujiR4dqz/RtoZUVlchVFiBZ7qeySmWyydgXzDJd3cpuztlS1rl5
	l93o6pW6VpP1vunv8kg==
X-Received: from wmbz19.prod.google.com ([2002:a05:600c:c093:b0:480:4a03:7b7d])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f8b:b0:480:1b65:b741 with SMTP id 5b1f17b1804b1-4830e93566emr86248865e9.15.1770288702092;
 Thu, 05 Feb 2026 02:51:42 -0800 (PST)
Date: Thu, 05 Feb 2026 10:51:26 +0000
In-Reply-To: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
Mime-Version: 1.0
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=2600; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=w6m8/CBcsVO45PErliVcnFx0D1tqtbL2J7ITeUkz298=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBphHY4wQ4kwP9Io25J2mxMCK0RJeRY4R9bMrUFI
 K93z2EKoVeJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaYR2OAAKCRAEWL7uWMY5
 RhmBD/4kCYBswFm2BtpYeMGLP4ihYfx7f4XUht5vAtF6sKzLqkxWIxbMVo6sn/e59ZLr/Dxxvnv
 HDEelcjeJTEabMLBoH1FKvnerzLzGiGkxX4IHCUX3rYm+WVsuluY8NrnGrXgzmBXWlVqaaQlscx
 i9PorwuCwYxjtYHwlJZkQqXnQmhXZHV0jz/9cPC6G/4jDtn4CcWYpBwx2rJOlKDzwaUrMwt0qtb
 IHi5T0drgp8PpJ1YYGJVRFbKbIogwsOBBBkEESh55KhgIixlaYSE6MO/ydSA+alfi591dhhUmV+
 lYnqlg6s1/COwZs06MokoR1jqDstgg6GjM3SF+e1H/Xu8MVJzkj/e5zjPWSlRFC7OL5jVV0sEk/
 szu7SlqvpdFFCUGsuuuCFVJU/viD5uebiBRLO9ZfNlFAZ7mk8sRnSXIYYae9qCBpJLEq3O9U9m9
 C+PDh2b3Ym5sDs+L5aq8eC3dhqO46LkvonWRJrZoQTQ+DiKTnef0ULt31jYO6uerKX3uGJvcSqf
 SP4b20Y8o/tRQgVejrU+MvkXUFpqY1kKs2m+8npV9m838jez0jY3C2jI2Dm/xDW++Mfnv7vYmni
 zDK3CV8BK2B0hmQOVgCGefVXoOlUeg9ktxWHg7qkv8LSoM0KxzGHcGCalsA/pTveoxGaeixjUGV QCNnFbOAhUfMrBQ==
X-Mailer: b4 0.14.2
Message-ID: <20260205-binder-tristate-v1-1-dfc947c35d35@google.com>
Subject: [PATCH 1/5] export file_close_fd and task_work_add
From: Alice Ryhl <aliceryhl@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 72B9B1A000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: uhkbx9s6683i51e4qcn4w4kmcojs6t1m
X-HE-Tag: 1770289012-790341
X-HE-Meta: U2FsdGVkX1/9tdksT2iug/RK59FMHAeGXGsvfoHg0sCMIjTOtDFu4lRsBlyjieozPnpf6JEb97U9+1+WwaR4wtbLHbK1dnt3kGGxeg9cltJD9b8Us9s5zzdvZmVhCvhql5oVCOSG5XmeZqArJCazDzt06YJG9iB9dZHsJvvegGfxdoXkATEFMgNx3t+xivxzBJF8oPxZeIdd4/4e9r1f4qOv5XKAOA/ZvdezS9VE17KSa+PMwwSUHCWz/Xj8/DSmGCs66xIetq9Bd7c6US7wclt+VsvNvu4EfKq3DVEKzhUMUnsUOoDLwdM9ixpq3goQ3HgygXHWEM0sqP/8tWtUfNeqTiOfy/CLQus8IAdHIsRCdGB+11Mx3i4xYnU8qg0vNUoSzkRjtZKnmYJ8y3RlErgRX9cGeJhkeR6Mi6SSquzAT6/Smfn0sJh4/M9nQYRvTRu5+JGaHynr5M0QUCBAg3ZSKWhMap5aSHc87z89/L3TTsMv7yNQpEDufoif+7U4lUKBB/z5AeRkEeQX4xSmxEcUuynuJTYQAZAn7NtZUHSoQjvRwo62mc7qY2UUQvJvDZk+mceUs/QJOihbEnLYPIIJjkZl7njzyFfsfno+iXrhtKEvJatfiXbEtYOMNqqzxgOZIkktbFnqt1hEgd0IzbHpYUOlWpm2ba0hWj8ZCCymSkSYXcIUBc/QZWHCsce/pMh5EeMWjbG746CWfJ3BoF2V2y4aSY3MXHqLimOwOFp2VTvtmewd42n1EibxzcdIhpbD4HwdoSFsCaVA5zRM3DAsm/YHH9otGM4w11/c78EF7MYiMmUS5676bbdL83k4UxJi+u6O0GhjSSVIAjKWTR28AufiBsVUjM3C+z75PtOveWmt0/rDm0vnsB0OWYeXgVTfx3LWSByepfr8rab2AJxupJFFhFff/IzK+76nncxU7x5lVD2NCUjhn0qUhry5/7VreA1sOnQdR2pppO4
 alLZxJro
 Lh20b2iPUth8DGohskcvWnNw3wV6PrxbdmtweG4Pa9prWAmHsZQAhRcm84hyPliK5f8B2/EHpgAjZtI16WvOcWH1/xm2283YaHOd4iOjVpAbczKUjD4ekb/e4y07Qb5MGtlBEcaRvn1zhU4qwlC8CvDSyqqetbhTerWB2SUO+GTFZAMrxm2VwxiMrKGpcYF6E+U/LUuVb2okQ/T0mOXzPzU3amniSXsajlxDgGeAafgXaNgpqkmArlYeHRyzCtTRsHeFdOoqNmydkBFp+3/3C+NDUdF4wjSjrRzf3rmFQx2Fd8bNFzxO4oh95Zuni60v0g1q0pYWmX1OV+ofHakHMMnKTpwSJChAjjaD3Np85S0vnSFVGQ5WHWIN+wGcjMeKAe6QKaqUqsSJjvMFg9f+bJIAp7QERUlGG3YUFsHY4ceIrGAIL8JVjhI0MBgt7RG6DI6ISmr2vILTuATi4CpRmsmYT+FZQa4der5UCjRmcaMcJG6dhXnBdpVFNEG0SoJFI0qfq1Ej+JYwCtshtLk6gm1VWFEoBL5ife9aby7xrFg4jn7EcR8/bnWPrQyFZp4HoIosjmt0VUKb2xDrvEUhQ3VpLxYjuMYoP0g8WfEo83PDjAFmdWENq9LlIBtl1os1J4i0bEvedf2wHKg1CoYW3gUpbr0nkfh4JLHHqLmvk4MTr1/w/JfcWoXMvBGPcmWtBhdGcxJDLl0nyECNV/rJwntrBV/S0LtGjhnj7O+G3juSPWMtMTTh1fHKr0mhedTj6Yvq5kCBS/xydlmo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This exports the functionality needed by Binder to close file
descriptors.

When you send a fd over Binder, what happens is this:

1. The sending process turns the fd into a struct file and stores it in
   the transaction object.
2. When the receiving process gets the message, the fd is installed as a
   fd into the current process.
3. When the receiving process is done handling the message, it tells
   Binder to clean up the transaction. As part of this, fds embedded in
   the transaction are closed.

Note that it was not always implemented like this. Previously the
sending process would install the fd directly into the receiving proc in
step 1, but as discussed previously [1] this is not ideal and has since
been changed so that fd install happens during receive.

The functions being exported here are for closing the fd in step 3. They
are required because closing a fd from an ioctl is in general not safe.
This is to meet the requirements for using fdget(), which is used by the
ioctl framework code before calling into the driver's implementation of
the ioctl. Binder works around this with this sequence of operations:

1. file_close_fd()
2. get_file()
3. filp_close()
4. task_work_add(current, TWA_RESUME)
5. <binder returns from ioctl>
6. fput()

This ensures that when fput() is called in the task work, the fdget()
that the ioctl framework code uses has already been fdput(), so if the
fd being closed happens to be the same fd, then the fd is not closed
in violation of the fdget() rules.

Link: https://lore.kernel.org/all/20180730203633.GC12962@bombadil.infradead.org/ [1]
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 fs/file.c          | 1 +
 kernel/task_work.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/file.c b/fs/file.c
index 0a4f3bdb2dec6284a0c7b9687213137f2eecb250..0046d0034bf16270cdea7e30a86866ebea3a5a81 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -881,6 +881,7 @@ struct file *file_close_fd(unsigned int fd)
 
 	return file;
 }
+EXPORT_SYMBOL(file_close_fd);
 
 void do_close_on_exec(struct files_struct *files)
 {
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 0f7519f8e7c93f9a4536c26a341255799c320432..08eb29abaea6b98cc443d1087ddb1d0f1a38c9ae 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -102,6 +102,7 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
 
 	return 0;
 }
+EXPORT_SYMBOL(task_work_add);
 
 /**
  * task_work_cancel_match - cancel a pending work added by task_work_add()

-- 
2.53.0.rc2.204.g2597b5adb4-goog


