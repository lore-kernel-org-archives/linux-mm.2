Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED2F3C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611566B00C3; Tue, 30 Jun 2026 03:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C23B6B00C5; Tue, 30 Jun 2026 03:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FECC6B00C6; Tue, 30 Jun 2026 03:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 204CC6B00C5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:32:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A16831203EF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:32:07 +0000 (UTC)
X-FDA: 84935760294.15.316A98D
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf05.hostedemail.com (Postfix) with ESMTP id E7213100008
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:32:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="b8AKZp/t";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=gNeIOBPB;
	spf=pass (imf05.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782804726;
	b=Q0lKZzIGsX5Q+jKsu5psDWZvCX8w9tAnrGWNQIUZrfUYdB03DAH7ag6rtv4xTf9ncnXoDq
	wl7XICaA98U9/Kx4hi4Kn1KsABnDGmuRJxNbbTEtZYXm06s8a7Hc8fsHO6jvxUQHbqZ2qi
	y9Q0N0HHsP0IaRI3GPHdQiPdtPMWZtQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+5gxk9aax3Z8MOxBntdlxrt0qnkQz1zmf0p9zXt3Ns=;
	b=iYhZAISNuJEDoizIFmaq04Jf99CFncpcemhvYWyHu7v1Rsi+lrsoAi/Pkrcr4mrMp/JwME
	MC3WqlCXb8Aa2n0v/KWzY0nQqPr4l2/qsi4/utC4KrY6B0OPG7kHGEk5RVRQY4WOG3xMUW
	MgyFY+ZCnJLRl8zD5iGEiZaZOEMDbaA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="b8AKZp/t";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=gNeIOBPB;
	spf=pass (imf05.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782804724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W+5gxk9aax3Z8MOxBntdlxrt0qnkQz1zmf0p9zXt3Ns=;
	b=b8AKZp/tZ7bJmZvaxT3DKf6ygmG88fpNOYX2Wy/faJx2mEW9oHuRUa1sf9nswfy5+tZiTR
	pATXXAa1QUI4TyywVXshoQwYwewkzwgeEqsZfCqZI/SXB+Mw7/tvdnC5GlRtPjMhT7EMXn
	iy98ypMWh34mBoK9/TbvT66qZlayzoe+vdRD64ziP9cDYYkvSYqy302mgibYDFp8h/97gI
	DWABZsakMhdHbdp4UKPz7Ip/MIEqZfV4oPs7s47tUhRIa4aBUFeKEinwGmqgzTiRVGy7wI
	ahO/Gfra2WBRz4rRZIZ2XH/VDOcJzusxCzNLiJmh8xzrl7sGwJRuMUcL6CT8xw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782804724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W+5gxk9aax3Z8MOxBntdlxrt0qnkQz1zmf0p9zXt3Ns=;
	b=gNeIOBPB55m13prz9rKch53P+lnHJD3NYpOh49vH9tvvQmkXMqBNY1vmAZRYdmH0zwJwnJ
	GECqEveK9eb9VPDA==
Date: Tue, 30 Jun 2026 09:31:58 +0200
Subject: [PATCH v4 4/6] vdso/datastore: Explicitly prevent remote access to
 timens vvar page
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260630-vdso-mlockall-v4-4-6c93708ce723@linutronix.de>
References: <20260630-vdso-mlockall-v4-0-6c93708ce723@linutronix.de>
In-Reply-To: <20260630-vdso-mlockall-v4-0-6c93708ce723@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Nam Cao <namcao@linutronix.de>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782804721; l=1920;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=62ZyzfWrxivNkkXt0tG+7VuX88Xoz0Nluqqw9A4GpRY=;
 b=a0urJHAq/WQkSKm2trCnr2/J0DvfCsdWRNoNI+pDyw89cBmOwlmyuCdTMoE3pdAJ5fE1nHgnG
 1PqnMjzQVu9Do427gMQOpmp2ArJTnK4842/DKNZWJ/9J/mzsY8FsSrC
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E7213100008
X-Stat-Signature: ju5jchadbzg57pxcphtzk87sb5s7jk8h
X-HE-Tag: 1782804725-867196
X-HE-Meta: U2FsdGVkX1+xGF74fE+Dli75vjFlbSP9NnAhFwRsjuiqimTBaZ2gSCeDCju8owiOgOskJW0C9sBBTE9M49fP/QLSixeOJfYR2meCv6w3aWSvb5c0Z9nW4CDt3QGKKQwmBJB8BellpqbYkWnsEJBIrHPotNpNx08GxtkA8hyaJWu+2pI28/2ykhNVU95fYnxUH2Naefz9PDIq/N7oZXmxJ0OtiwEviC3PNzlm6sPiYRLbglJfMBlqC0W2mRRny28dmUZ9SYt9rR48lRJI8UQzzCe+t7KbsWpxK8RBost/biAX1QkaRiR8B1n1zGvylOdQnB4OFyg7SrlqEwXYdTDJ8EjZgLaWeXXJft28eCuNYkxVOtd/5ZuNahYuIuhXMW7gxZzA2OF2jE91YbhXMuZs6FC1TxjuZn9b3PW7WEvNUgFHZOLgyQ1RzYl0mB/VgpGb5NGkkWiXePKB/9DFDT8864yHf63kPqam9eI1kM1Irf3KYLGWwfZlF69UtFzdYnlo7UfJI0bUijRtX7CKzux+J4WvbOeAVsF6/I76D88WJDwlJKibFULIW3QoHIY6sQXI2b7nz2ySbSDvMIT34NKx6WzM8PgQQls4wNk4+SH8WCI/8NhyhiOWTzYDIbyIRNvEs6JJd8sxuY/HSteMaiwDGJduGNPdcoci4N6AVtGGy2kES0ANVqpZ7MeAD3UCFrmmg3cg4c1lFWsdg4gmCO/9cdgJ2BE31EjXjVbSIpg4bAbUMoQLsSG7trhlpLiiwbFNltexbdEMm/AncLdw5E4SOGhim/p51+IlMZSCn+k1NjREjTfXMpKD0VJcfl8Zx8KIwWmV1vmzmw75aMbxCn1+GwzRWSxnCeo9+37sVTfTDXYu1nrM5ZGf5MJDuWLUA9OoZWWaXXZIvqAXEDqPDy8zThtMOjguayynWBnwpqrMparBXeKmVZLNwecSyMVE9u0MqZebbMCSiB5TnMVxG13
 +U6bQumm
 zC1fTL19RcVBU6AlgveX+DBSyFB2WmlzF4hGZCnrHIbq1HYkbeEigW+K5U6Arxa5jqAZcgSpAFnqE59K/hndqAJNBqlKvZ9Z6NHx7WPVrznWYZhCoxOfKT+U6lmPHejJ6IyI/TMO9TvM0nO9IMFNg2pUtdRdEmbrBR9Ol6K6tKhDuaxc0iPt9YCjM5L5jd74/TvjzMb+bE1nNWv3jvQyLQCqyDC76Jf95Ktl8PQPFJBZ3TmB+IImL8D+jZHOdQgDS8qd16dwHJzCcU3mblRNiunxsoo6sytvqaMw5+mMG3eFG0PhzEvUqAr0f629wN1TSZKzUI1aUQElXF2p3r5dYZoflnAwNfuH+jXJtJvIy3jprz+PwttTky6CaJDSTxUmeneLKnSCRecOiRXvPcJ2MpDpnk/pDmsWXu3mtc7WonvFEFWj5LguI6HK6FQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The fault handler for the timens page does not have access to the target
task and therefore can not be invoked remotely.
Currently the handler relies on the fact that the vvar mapping is marked as
VM_IO and VM_PFNMAP for which the mm core always prevents remote access.
However the VM_IO and VM_PFNMAP flags are going to be removed.

Add an explicit check to prevent remote access to the mapping.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Tested-by: Nam Cao <namcao@linutronix.de>
---
 kernel/time/namespace_vdso.c | 7 ++-----
 lib/vdso/datastore.c         | 3 +++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/time/namespace_vdso.c b/kernel/time/namespace_vdso.c
index 0d74d160eec9..5ac7b6a6d3a8 100644
--- a/kernel/time/namespace_vdso.c
+++ b/kernel/time/namespace_vdso.c
@@ -74,11 +74,8 @@ struct page *find_timens_vvar_page(struct vm_area_struct *vma)
 		return current->nsproxy->time_ns->vvar_page;
 
 	/*
-	 * VM_PFNMAP | VM_IO protect .fault() handler from being called
-	 * through interfaces like /proc/$pid/mem or
-	 * process_vm_{readv,writev}() as long as there's no .access()
-	 * in special_mapping_vmops().
-	 * For more details check_vma_flags() and __access_remote_vm()
+	 * vvar_fault() protects this from being called through remote interfaces like
+	 * /proc/$pid/mem or process_vm_{readv,writev}().
 	 */
 
 	WARN(1, "vvar_page accessed remotely");
diff --git a/lib/vdso/datastore.c b/lib/vdso/datastore.c
index cf7aa80355cf..0ca43965a8a9 100644
--- a/lib/vdso/datastore.c
+++ b/lib/vdso/datastore.c
@@ -68,6 +68,9 @@ static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 {
 	struct page *page, *timens_page;
 
+	if (unlikely(vmf->flags & FAULT_FLAG_REMOTE))
+		return VM_FAULT_SIGBUS;
+
 	page = vdso_data_pages + vmf->pgoff;
 	timens_page = find_timens_vvar_page(vma);
 

-- 
2.55.0


