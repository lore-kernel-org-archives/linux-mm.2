Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D4F3CD4F54
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:51:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96F7F6B009F; Mon, 18 May 2026 05:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91FE66B00A1; Mon, 18 May 2026 05:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E7386B00A0; Mon, 18 May 2026 05:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D3916B009D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:50:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36E5F925E5
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:50:55 +0000 (UTC)
X-FDA: 84780071670.20.66C1CFD
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5636BC0003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:50:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=K30HU6Xz;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="hCBP/NQu";
	spf=pass (imf28.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jc7l/gg80oX0jL/4qJmHKXqxml1Vo+aQQWLxItlgPwo=;
	b=yoQXwC/WP+wv1Ir7gBhmhNHH/UP+exrwkc1kRhMoU/n4UBlaLDCs9gK9yyZmaBBh0O1anJ
	jdsg2FcRn8nNLWP0ehplGb0U1YPbkC31ECfXguJ6r1kGLTfvcLMiqPRnOVhpGHg5BCsWTT
	9TK7lBJV2X+aQLrLm3I00JAA/OyjCvY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=K30HU6Xz;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="hCBP/NQu";
	spf=pass (imf28.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097853; a=rsa-sha256;
	cv=none;
	b=JTGTmochWol+gr+rS/CwG39LlvkIOla7vHHkr9S4xQ3FcZebJ7/LXJgJxlYmmMNdZ90ri6
	3hzn++dOzS4i+mpKUjQIu0qET0ar0OKOacDKqiZdJuIMznee9nNsvwLhsO9m5Bsm6cyWVr
	7OcVANX0ixy0r8XBmtmtc06CMniRPKE=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1779097850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jc7l/gg80oX0jL/4qJmHKXqxml1Vo+aQQWLxItlgPwo=;
	b=K30HU6Xz+/81xSNbNLhiKBnmtZnlVx4ZZkYj8p+N3j9jCZDGrl0ecrRjpkwYAG0XckZbm5
	5AuzP0jnAQjPItmUOz4BjG0qa7FbDzeZbVx/ZHm4DiFguoYxFa0od3yyXTUtCtZiMqpCv7
	hwlIRlsSszyAZVicxFRuHr2fa3RJMtQW5Ai+KNFyHUe3ZETraWqGuiq5zund0mxKLgWpqu
	R76le1iwJWo6n8QHxrWuZskWIZq7KYoO5duLTDiVmk1eJ1pN3Xm99B+eJvBY1jQS5As1CL
	UVnJF1AGf/g+U29C/gp3QebIDplFPyMpmHnmRB74fbb4GqC5faP/S2Dc2/jCNg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1779097850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jc7l/gg80oX0jL/4qJmHKXqxml1Vo+aQQWLxItlgPwo=;
	b=hCBP/NQu4Zf+ysJPIP+Wj8MSwDJVODDN5Sy7HUuzAwDy50pUx/VadCw0LQYLcfNEzv7rb+
	ws8v6EnW8PTDY3DA==
Date: Mon, 18 May 2026 11:49:43 +0200
Subject: [PATCH v3 5/6] vdso/datastore: Allow prefaulting by mlockall()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260518-vdso-mlockall-v3-5-bf4f2af2b41f@linutronix.de>
References: <20260518-vdso-mlockall-v3-0-bf4f2af2b41f@linutronix.de>
In-Reply-To: <20260518-vdso-mlockall-v3-0-bf4f2af2b41f@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Thomas Gleixner <tglx@kernel.org>
Cc: Nam Cao <namcao@linutronix.de>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779097846; l=1829;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=XWSQwoDFIaH2o1UGbnO7M9TuyMOc7ANs+7v39DOcLXw=;
 b=txqlEqpsMZu3yYNsjeo+PZQxSxxMLxOn1RELhIfkP1Q33PdbnPa53tZqehLhcLg0fZEvViCa/
 UP+m2x5q3XuAhzPsAELANtmInSGHmsQh8b6E4qHB/Hk3mbwHiQbQkzV
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5636BC0003
X-Rspam-User: 
X-Stat-Signature: 8yzgj49oxfdy6pwwk5xm9tmaxf11kdwk
X-HE-Tag: 1779097853-274993
X-HE-Meta: U2FsdGVkX18afAkUvak6HcKXOxwb00x68un3QVDz/9kA7FwfC3snYfcA6Fc3oStM4X5VHWb+W0SGLstuONQdMd5IcbfKjvQ0GJmQG2rGG0FhnMeBa44YrrTvYBprdr0UnvSLvWMoGvlN2IKaBlQQ4MprqGSbAFwVgc2yYmxyZuQ4WrDkmvDIZ45ljRV1cDkwoKqchrDFnQ3e01aE+4JJPQnbyQcqkE1qJb3x+QuikH1iVj6Vxb5sLPtnmJ3Acsctq5lJOPwMJlTs83XTpppXXy3VneSU8mMjwiHyglGid8ckMLWnw6RKkrTISuGZhnBSL8ZGqsM0JjR7C8A46yk/gmy8AEU8a5Gm8XCHkKkx/uIBT1ddde8TZ+HkaAl1N6h8aV0lM16Xwforg8c1XPxon3L3ajf9Nm5oRcVwaKopBfq6ACTIFYVjdHqulx2jzXGDjLWtWMcF0sxXhJxnp6of+K8S62Z4QOPkaka0tUwUTz3vnfSmqffOCHOyrnnREaS+uVMZlLGamfFTB9EzCAlMqr68ac6trilCF/C5GDfoNPNGc+WLRAQ4KFRKbQh+fddAmKEFX1jcmSjy83M/nj8NTJSyWwsBRqpC2At8tvI81pTeM7dlqgolSXK97VgVXQrbK9+zuG4035cf1CbggCcQ+vu869U2klR+oQQMK9nzS/H7fnkhWCqm2wcafD63GpW7onG6NYUlTf1jPV0dvKZ/V1u8U1Tb3/6GeaeyZQiSQD8mIwGO3SUHb9LdWIP+tddXd5jrT0ta5lHCorpSRyyMWbR/fYfDzM8QQSwjpZ58DcNn2eRj6Mplxqw006Fb+CZ1uRPi7RHFGBBQodOSOymA4WzO4yfKaAtnxpw+wndbyjGL+VfRCcWQYPT2sCR3Aeukskwo8lfZbtVmMqJSlyyEOelNoJnDtCSePbTXQ6ZQUzCrESFs8hNCWnYYFe8qqiYz3NjtHvfGuFvFLaD4vFO
 v+tI27KU
 /GAPpkdxqJf1DJrgpDW3tjjZ/kkwLxSx00Dxb51qD4xdKt+yVG2lkQn0uEVI8UNlos53BQApAGMAm7iAeV1y7ILLQKr5Q06w8Ne1ztKhAWdNlrGvK1HApM80BKLKUTFNMr+C4nNdTBs8P9szL9rXaJx7g91IA5OviCXYAvU6jJoA5wQRBVX6Je7fcN0vo/+kcMTg9aCxpUK+7ixQowH9n0wtFhZDMHlYRjsu2Hqo2MElH7VaUKm+Ho2o4IeW6uZBTZTcbaS5D5MWXUuTPH9b42E6wBdONVLXDlpaXOqaCr5JvJ/ThoJBPGdaWaR59C35eDfeEAvmGdzsMNCzOj77GR30Jva+mNxnMEJhtT4V+9hmFvBctSY4QvZ/nPrtbDDfUwYWbbdQvh6UhWTYhGMmFAe+oJLzc2GMlB7u+TINqDlqax0mhlcnKPR0mIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While mlockall() is meant to lock page *memory*, effectively it will
also create and lock the corresponding page table entries.
Latency-sensitive applications expect not to experience any pagefaults
after calling mlockall(). However mlockall() ignores VM_IO mappings,
which is used by the generic vDSO datastore.
While the fault handler itself is very fast, going through the full
pagefault exception handling is much slower, on the order of 20us in a
test machine.

Since the memory behind the datastore mappings is always present and
accessible it is not necessary to use VM_IO for them.

The data page mapping is now also aligned with the architecture-specific
code pages. Some architecture-specific data pages, like the x86 VCLOCK
pages, continue to use VM_IO as they are not always mappable. They will
require their own special handling later when the general aproach has
been agreed upon.

Regular mlock() would also work, but userspace does not know the boundaries
of the vDSO.

Reported-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Tested-by: Nam Cao <namcao@linutronix.de>
---
 lib/vdso/datastore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/vdso/datastore.c b/lib/vdso/datastore.c
index 3381ccf9edb1..3f837cb6a886 100644
--- a/lib/vdso/datastore.c
+++ b/lib/vdso/datastore.c
@@ -125,7 +125,7 @@ const struct vm_special_mapping vdso_vvar_mapping = {
 struct vm_area_struct *vdso_install_vvar_mapping(struct mm_struct *mm, unsigned long addr)
 {
 	return _install_special_mapping(mm, addr, VDSO_NR_PAGES * PAGE_SIZE,
-					VM_READ | VM_MAYREAD | VM_IO | VM_DONTDUMP |
+					VM_READ | VM_MAYREAD | VM_DONTDUMP |
 					VM_MIXEDMAP | VM_SEALED_SYSMAP,
 					&vdso_vvar_mapping);
 }

-- 
2.53.0


