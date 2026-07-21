Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CAC1C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 10:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A6C46B00A4; Tue, 21 Jul 2026 06:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47E216B00A7; Tue, 21 Jul 2026 06:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BE806B00AA; Tue, 21 Jul 2026 06:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 117FD6B00A4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:09:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E7E580433
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:09:09 +0000 (UTC)
X-FDA: 85012360818.21.9FC417A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C6368140005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:09:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dfFcQbR1;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784628547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HhgiFT7gO89ZbsoBF977sX4zSyifCWX/9pr2xPYrWr8=;
	b=ikr7LJy7UlhGeh9jifF+rqbXSZzs52DqZTLDlQs0df8mFLQ/wJOuM8QGiEcSlXkLKPgxNk
	794dWNzKeEpBaW60B1lRCbZzROix5Oztwb6BHarRtDMyut4u0TIC9QEUDFHksIGVZJ6wGj
	Iv14S7pzoJqOoOf0aK2grTn+70QeILk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784628547;
	b=TgJaxRojoRc/2KwpNTn6y/hXhZeDP/E3G8ApowCXw99PlbNBzSPFeB/gTVkz0h4XYsNY/W
	esHVCXBJ+FqXFH6pFuUOeMaxNi/wLt2fLLDqtjtC5pKcoTffU6m8L2Trfre4eT36jHEZEw
	rqeYjxm0qp9fr05TN7iAf7doWbJ0hcY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dfFcQbR1;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D89A9436DF;
	Tue, 21 Jul 2026 10:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0F71F00A3D;
	Tue, 21 Jul 2026 10:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784628546;
	bh=HhgiFT7gO89ZbsoBF977sX4zSyifCWX/9pr2xPYrWr8=;
	h=From:To:Cc:Subject:Date;
	b=dfFcQbR1u/TdFv+tY8MlY9H7YDBQJaV5W8E4oIz4qNkMOVVKJiXONvo87Dvecag0S
	 QCsF6+gLgGAATS2Vka9Y8U13kG39TPBfME96ic7LHtwSkkuv/FpyDakq0ssUqyzYfO
	 kzKcxru4YGETZLSYs/J958X6/iaX0rhNEJwga0n4PJFnFT/YrF9sRp1YP+7X9hOwni
	 40l5VC+n82c+sRlZo2NHFf/GnRrGoDfy5oVXf5YhTIvqs4CVGDvV9qsMD8iBYeUVi3
	 sb/2cZBspZi50pxT4vUIM79ZdphD/yLwYLspdQLWWY4F780fwDnP9zu3asvuDNNNxN
	 74k8nqmqY7giA==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH] exec: fix unsigned loop counter wrap in transfer_args_to_stack()
Date: Tue, 21 Jul 2026 12:08:49 +0200
Message-ID: <20260721-hochachtung-staumauer-pigmente-15d71f7d7d04@brauner>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2999; i=brauner@kernel.org; h=from:subject:message-id; bh=BfGVnvLylOR1ukv19F3xDAtbizuM3JaHDvahSFlKH8w=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFu5pnM/w/kBcX9SbY+PubiPnV+7x8rr7S7cpb43nM8 Mthj9O+HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN5/JGR4Wrvu9/sk82/vp/6 beWPXXytMjv9P9pcPXTY5GmenYpM/iFGhu0iQveOWRmUfdJQOWl9v6Hf4q/N9OLMdU+UTu74ya/ 1lh8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C6368140005
X-Stat-Signature: b8yojwdni8f4e1u3apdzdds61x3rocyx
X-Rspam-User: 
X-HE-Tag: 1784628547-231599
X-HE-Meta: U2FsdGVkX1+hrwIPMYeoqAHp/z+JaPP6A4cNRXJddofV+75/3d0w2W/waxyxsbJM5HaeFxngBiFDzSATNJsdSWUxgWE21USubdTI+WcNwuGDVp85DxepE0ybxRZQ+ceI1QPoOgNoGPJcViKFQ+I4fJZ0izhjInV1UYUgwoFcjUTEIrs+hToRF+bfuiflJMpyvNqx1yttMtzIpMPWhs+53hq0hpNQdLXJNDbBFCedWjuz3KuTLoCvrI7SHPtbscIfv2cTCQYz4IdDJzIuHDQK+kXz0ZTgUpjmTqUh5yJqWy5UGSb5gneZTiG5RdJEPWLAMKMwnUilcc0BkV8IHla9XPccXwVu7yWzFzKVH0DNvtz0Q6opouOzOrs+m6OsW5KgEARLGXWVJgT7xlq6KZQsbzcw0Do778KEfuuoNBcLAgJJ+BwubJtsDPBh5Dp3mlgXZUUw20iIIMvVQzh6Dz9aD+8IrQTCwmQnUWC7jArSkfUZhzxS82Mcg/FEfUDnotzWxTci0BbtMi6m6mAOmpUxh3o7xKgHec/gVGrEaiXhFMbodfLDquAdjQW80ZFrgX9VHmp2X/y8gmXjiCt4CHfjaPL9CxglazGyfvKR510xq3/0dj+Tm8CyDIt6cNorP+WVJ0xLHGeXiptgNRB9knXhePGatP2PuXUVxgZBZjEDHTG/uNV9tFdZIbDh2kPVIUxvr63jPZWuMYPb/znGvqrWe2knqafhXYmpPOTeKvS0ANPobvDxFt58jE7vx7JUskZdJQkY8yCdjKlOWA/OE4qI5ew/AyWpNVdN5ktD2uoEdQwaANeMdOMQgwaqrSP71ATCOfnKJCjZTAlL88YrdbfKPFFdXM85YW+gWvcbIWz/ZQfIyNNa6GvbzhOzJw7tDR6vC/BtebcoowigWrWIk4UdfYViBK+79CW81MfRQ0szyXaiUivPAs1lxIBkIbTNY5UZM0xvjM0xMEpFJhKc0E3
 3gqrQzqG
 K6hwHtI47yDgkCB1+gGDHXZVft0cvzflUKxd4AUStp2n7946TfXSiqNSHmpFwtuLz6fZHz2Xt6fyeleAQHxe+tkNjRgq/UvK+KeIrtowPyQIi6vIF5d8aomRWUxyFV/QcsTfZBPNV6lxrMEpOkBxq9TMtximoOqsLaS0U7ZN4axAbBDVN+z2xy95Na+fUY1ANKmaHZPI/jp59tJwVuXDxIoSnl744UcYS1HXKorlzLNQ9MYe3m48ZzwkVXI3tgtEUANbXOr7DtLphrrJbDdcHnGdzzO4lvi4So/26BFufk4dItjmUjvmh8jhTT3NZeY9Jaq/pwXFkrcxVT4w664cAFXEbIIiq0IxF8y568uS7Qik7Dks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The stop value is derived from bprm->p >> PAGE_SHIFT. The index variable
is an unsigned long. If bprm->p drops below PAGE_SIZE and stop becomes
zero the loop condition index >= stop is always true.

After the index == 0 iteration the decrement wraps to ULONG_MAX and
bprm->page[ULONG_MAX] reads sizeof(void *) bytes in front of the array.
The pointer has wrapped to -1. That garbage pointer is then passed to
kmap_local_page() and PAGE_SIZE bytes are copied from wherever that
lands into the stack of the process being created. And the loop doesn't
terminate either...

Getting there only requires bprm->p < PAGE_SIZE. On !MMU
bprm_set_stack_limit() and bprm_hit_stack_limit() are empty. So the only
constraint on how far bprm->p is pushed down is valid_arg_len(), i.e.
that each individual string still fits in what is left.

bprm->p starts at PAGE_SIZE * MAX_ARG_PAGES - sizeof(void *) so a
single argument or environment string of a little over 31 pages leaves
it in the first page:

  Oops - load access fault [#1]
  CPU: 0 UID: 0 PID: 1 Comm: victim Not tainted 7.2.0-rc4 #1
  epc : __memcpy+0xd4/0xf8
   ra : transfer_args_to_stack+0xaa/0xae
   s4 : ffffffffffffffff   s2 : 0000000000000000
   a1 : ffffffdc98000000   a2 : 0000000000001000
  status: 0000000a00001880 badaddr: ffffffdc98000000 cause: 0000000000000005
  [<801a5324>] __memcpy+0xd4/0xf8
  [<800d5f6a>] load_flat_binary+0x43a/0x65e
  [<800a2de4>] bprm_execve+0x1d4/0x316
  [<800a351a>] do_execveat_common+0x12e/0x138
  [<800a3d44>] __riscv_sys_execve+0x38/0x4e
  Kernel panic - not syncing: Fatal exception in interrupt

This is an arcane bug but we should still fix it.

Count down from MAX_ARG_PAGES so the loop ends when index reaches stop,
stop == 0 included. The iterations performed are unchanged for every
other value of stop.

Only CONFIG_MMU=n builds are affected, transfer_args_to_stack() is used
by binfmt_flat and binfmt_elf_fdpic on nommu only.

The loop predates git history. commit 7e7ec6a93434
("elf_fdpic_transfer_args_to_stack(): make it generic") only moved it
from binfmt_elf_fdpic.c into fs/exec.c and narrowed the copy to the used
part of the first page. The condition and the decrement are unchanged
from 2.6.12-rc2.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index d5993cedc829..c7b8f2d6366c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -740,7 +740,7 @@ int transfer_args_to_stack(struct linux_binprm *bprm,
 	stop = bprm->p >> PAGE_SHIFT;
 	sp = *sp_location;
 
-	for (index = MAX_ARG_PAGES - 1; index >= stop; index--) {
+	for (index = MAX_ARG_PAGES; index-- > stop; ) {
 		unsigned int offset = index == stop ? bprm->p & ~PAGE_MASK : 0;
 		char *src = kmap_local_page(bprm->page[index]) + offset;
 		sp -= PAGE_SIZE - offset;
-- 
2.53.0


