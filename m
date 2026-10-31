Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AA61606A31F
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 16:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f48maP2D
Received: by kanga.kvack.org (Postfix)
	id 3384E6B00EF; Sat, 31 Oct 2026 12:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2F26B05B1; Sat, 31 Oct 2026 12:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18AD86B05B2; Sat, 31 Oct 2026 12:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D47736B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 12:06:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3EC6E1C4408
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:06:06 +0000 (UTC)
X-FDA: 85383397932.27.A4AD787
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 48018C0003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:06:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f48maP2D;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf28.hostedemail.com: domain of devnull+joasantonio108.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+joasantonio108.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793462764;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rkymqaY7xVAzdi59LAjiM9RaFMfOkE/t6iQNHmjVNAY=;
	b=fynpFkdSioAiOj0k3FnKZ97mH1PTK30Or6DAQGheKgdMr1Otz0UKi6i8gU3BkcQMa/YcLf
	Oir4m5pWFjOtCTrkI563NZfjBDyZXWYguwZ+AyI76QqwLGYfI7tdAOFw6Ygao3AnPk/mTB
	9WeebmYdv3pdbReq/ez52mvUxBtKwvM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f48maP2D;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf28.hostedemail.com: domain of devnull+joasantonio108.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+joasantonio108.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793462764;
	b=tOy+AnLPaZHTetacyLVlp/DOZyoV68OESgNjXn9Zw3Da9wj8f35oFtQ9Ev2MnGx1TnIx9h
	cW+k8XIryup5EvDSS4l4ElhXz/991Ae/kFiuXi+Bfm3ejmkcR8B1Kwn39zSsVkIKfGUlEf
	0Pcir9MMQfTW9Uw2YNaChJWYb5mkQaU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D56FD6061E;
	Sat, 31 Oct 2026 16:06:03 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793462763;
	b=bmFu7/pzFL1Y8Rl+rCHTK3eh1TEobgsm+cerp+DY4txDqHvpixCCT90NLVq4HjLMQquQ
	 rvUN/Z/vdeGyq872WgVCoZhj+h7V8J751OLU8SuBfBtsGP2Jd6ukXb2ANsIPn18YrNaWN
	 V8yfdu8t/llQqLXrvaceUbWhJEPI8ZekyWevt2nwcuU4b8Gl6rSDAI2cRdahICqzrwQcv
	 W9Behq7nhiKCsrAomEPmx/6y2uV+TsAanCAU4nmnVV4p00qwcV9pyKsw6ox3MkrOQq4BU
	 RjPHIJjPr2E4C7Jf5kJMTd9irtBs+U5uyXST4ZUh5bx9zB4KEh5aDj04F9yk/mppWmg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793462763;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=rkymqaY7xVAzdi59LAjiM9RaFMfOkE/t6iQNHmjVNAY=;
	b=vD1lO74qNrmtqWKgDqekRFWyf4CoNkHisOZiMxLLBe0B9z51UXGYUa303rysEHMZjKkh
	 ItRlbXjgW7popX5X7ZMV2DPAUjbHfoWyxW4quonz4LhcqUy0rlt62MSr26NNPZ5NVt/nW
	 S4D9jOlHS1UCsryCYJrcJ7TMplINU0fC5BVkffkLjE28FNRX/8iO1HK4Wa/u/0i5v1wOO
	 OfxfJC6vf/HHD6OYVEr+DF9HEIvdNkskVE8WLT1Srz03qBhRBAASSSXOGYV4sSbJTf21n
	 vF1SqbfVs1doCPHLS9LI5katvWy42QLkqBy1NJt29GBUEP6R+NCMaDAE5Rj85tVbdLA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id ED1DF1F00A02;
	Sat, 31 Oct 2026 16:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793462763;
	bh=rkymqaY7xVAzdi59LAjiM9RaFMfOkE/t6iQNHmjVNAY=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=f48maP2DUE6yleQgq35vY96i4aVCMDxGF80luuZ92fT3SWEC9wQRlHhvzyvMbLRBO
	 g8rKVu018sDoVKHUf2vvVhfWt0xNSw+dJejYiRDFhRvRUwE1Yg2GPibAbuaEeO0hAC
	 7vm+1/QQWO/1Agct9CjeoU38sOqi6GfJf1FWeV+MliC21AXLcmZeWgBc0pYR8bXS75
	 ACU4LekX+VMmVBrZGUWgOhv4obNBxrR9BVCn0LVEBsDaUpyAytsqmyrnSxOR3Nf1fr
	 TckdJKXtI0lhVev0a+nlsugexYThxMQCGfZgZkb+sHHPLOpwhlXeUzr6Bi/Pg1ygsE
	 N22JIhUsuxLHQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4ED8945F27;
	Sat, 31 Oct 2026 16:06:02 +0000 (UTC)
From: Joas Antonio dos Santos via B4 Relay <devnull+joasantonio108.gmail.com@kernel.org>
Date: Sat, 31 Oct 2026 16:06:02 +0000
Subject: [PATCH] hugetlbfs: emit hugetlbfs_free_inode from
 ->destroy_inode()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261031-b4-hugetlbfs-trace-v1-1-4ec8d02a30cc@gmail.com>
X-B4-Tracking: v=1; b=H4sIAOkR5moC/x3MSwqAMAwA0atI1gasrR+8irhoNGpAVNoqQvHuF
 pdvMRPBsxP20GURHN/i5dgTVJ7BuNp9YZQpGcqirFWhFZLB9Vo4bDR7DM6OjNoo0rq1VDUEKTw
 dz/L803543w8rE6aMZAAAAA==
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
 Hongbo Li <lihongbo22@huawei.com>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 syzbot+91e1fc35f51774c479b2@syzkaller.appspotmail.com, 
 stable@vger.kernel.org, Joas Antonio dos Santos <joasantonio108@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793462761; l=3980;
 i=joasantonio108@gmail.com; s=20261031; h=from:subject:message-id;
 bh=CimqNwtPRA6nxILdhyc+0Xn4gqEkC2G7lMQ2JLmnouo=;
 b=yjuS2uTzQ9DedPHbuDm6WP0AuJe1WwYvU3AL0T/UCB287QqTTK/wXTcArMWRSVnwIEyUeH8rb
 qV6kSiKFMPyCX4BeVFMi8oIBqxxY16vKLP3MQWAKCoduXNPhXggr+3X
X-Developer-Key: i=joasantonio108@gmail.com; a=ed25519;
 pk=ZxAznJT/FcPPdzLrDDFJQm4LLjjHVGBBqDSG3TXS23w=
X-Endpoint-Received: by B4 Relay for joasantonio108@gmail.com/20261031 with
 auth_id=1371
X-Original-From: Joas Antonio dos Santos <joasantonio108@gmail.com>
Reply-To: joasantonio108@gmail.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 48018C0003
X-Stat-Signature: cix4aw4tww35dmyf7dozfg5jjbihnf11
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_REPLYTO_END_DIGIT,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793462764-535610
X-HE-Meta: U2FsdGVkX1+lb/3naEW+A8ZGiNeCrxAiVPnMy7CsfwmP/L1C6JKN+8gqQUjBQWCIE0wglGQ5hj56TwmObDg2bSMGf+BuFL6Wh834hOuHmpkJfz0lGVgQmXgulBHnH6CJtGqJtBgY9scW2hrU3xdGcfOkx1D5Zu95hzJkVpdmzhEHHeoURxE1NNaYL17Wr26zvkCSJIb58dJ+9I6w9bp71Sp1qX0mCsHQJ/Rr3YB2SmBdTA3TAP9mSE7mKsSy7YN+uxWphwCcEQcwqaDeHmDfJpu6GYf+RH37V/H370ZXJJea+2GGCTKB3KCE27EXkmjYPWX+3LTUd/vTN2JDWK7LObmBhInwjx00Yoa6x2mADvJ7r6j6QF/Q7P09a65T26qXT407PRBRpwg31uqPpiBz7d/Q8X0VVOiKKWsWDV3FKloIiHeRx617dfdGuR36VqYrasWShFUaWTugjUMGWN66GR2BYh8hj2W5fxx7PWm3fjk/lgEUPByU0cXFvOSJvhIZykVlaPjezuPFknWbhK/bgSyXqbDolxt3nX+nKkGqNpTVrcmsotOz8vIEz3g82OmBJFY0Opz2v75u5UMSdkPdbQ29Fz2aYg3PBiHNfJFv3ealy5k+40VAHsY3KPmTxSi8PqkEVB2YIuyZ68gBfpG86Fc1OvGedfIoRE6Yk2/GKO0KgyQDgABCJaY8vlXUr3tcXQEulaS6+3YjOBjU+F5+D2mlHINOwJx/nqCdrC93rcrJIBrWK4vbwnbE66luk4U0uhTifqoiCcieZGf9laft6EtpcQiNverreu7GtreqSiWNqMxuN/0TLpeMKTR7UsMdEUikQtDCeiJyQOXk1vZq29Kz31t0kwyngp8oJt24QysM1PABHyj09EYBA4VVYw6//IBKc6RP8SnYwPPRDgWrFTYY3OwZnhKWp+i9YguJQemL4UGZeUCj0XLs0icitVRjFRZrr4PSrn+EqdmdwZq
 c++TzK6u
 RbdshnmDRf1zMI5LMsKspq8R0CkQQvrYyrNYN32r5W3oilPMt1y4TpiCSy0xYAtSkaat921dk+xtZAGPmjUN7M2JeYus7nN3DhYrhoP2m++dsoc2kU+IrWENjdpPS02nYrPjrNpW8MF6IFpK7pszjoHP4Ow6PWwC576rPv1Wu7oLmw2U904ierGQRXDV1/FJVsi97tBwdbu7gaBe6BZInbPapG2IeAYD+AkPZKlUtm2f/z6aqO/DmgRWyUHXc6lSfI6XmWSeHlzkiwEq0E+oiTOMKBMZ++Y5SJQbpqerHS792N9lgUWOrJVE0sPlI8z/asI1JsRhOItHRUrxVC7PJgCtUQHeU65pGZKQs3qHKsyg4+rvPNRxvSZKLEdHUoi3ZUI3bCepl3QW72LcRi5qBZitT3bf5y1/25U3BjmbKwVKL+xJdOba+DOTtLdzw8HMAibiQwKDE8/m8xZN1MjkkRRjW3jNlUFEJYy3AJWtCFinMYqINZdEVCQkBdyJSJWDfz38APRSWL5E0hR5n5aViWG1mmopMJ4qGiBuTy9halrlqCLvNqxh/Xmn1+gHMO2Yubh3GYpKdpysEB59af2MxHmIRqn9yd0l8AB9LdXW5QwSoWHsgVQtMQekj/FVBWwpiXHFSZ6PJhFIMaPNmcrl2G4KdldqvCiN7gzs0duXDipk9647NgEJnxQ8rpmalrz1yLMSxBNXZUIqXupHK+tYusriIQOlZwRLS68r75l0mgMvTHZnyl/qckPh/oUsQkA3AiIl57THLYCqtqEEf+AHmMe8ngJ/MnaeKQYG3IVGdq/UayFjyl7rlr64LroIwtHTfG1mE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

hugetlbfs_free_inode() calls trace_hugetlbfs_free_inode(), and the
hugetlbfs__inode event class records inode->i_sb->s_dev.  ->free_inode()
runs from an RCU callback (destroy_inode() queues i_callback() with
call_rcu()), and Documentation/filesystems/porting.rst says that this
callback "is *NOT* ordered wrt superblock destruction; as the matter of
fact, the superblock and all associated structures might be already
gone".  put_super() frees the superblock with call_rcu() followed by a
workqueue item (destroy_super_rcu() -> destroy_super_work()).  syzbot
hit this with the event enabled:

  BUG: KASAN: slab-use-after-free in trace_event_raw_event_hugetlbfs__inode+0x45b/0x4c0 include/trace/events/hugetlbfs.h:36
  Read of size 4 at addr ffff888038850010 by task syz-executor952/6134
   hugetlbfs_free_inode+0x15e/0x1f0 fs/hugetlbfs/inode.c:1182
   i_callback+0x46/0x80 fs/inode.c:317
   rcu_do_batch kernel/rcu/tree.c:2650 [inline]
   rcu_core+0x5f0/0x1220 kernel/rcu/tree.c:2919
  Allocated by task 6134:
   alloc_super fs/super.c:326 [inline]
   sget_fc+0x1ba/0x1f60 fs/super.c:874
   hugetlbfs_get_tree+0x1e7/0x2b0 fs/hugetlbfs/inode.c:1431
  Freed by task 855:
   kfree+0x22b/0x6d0 mm/slub.c:6923
   process_one_work+0xac7/0x1b10 kernel/workqueue.c:3495

Emit the event from hugetlbfs_destroy_inode() instead.  destroy_inode()
calls ->destroy_inode() synchronously, before it queues the RCU
callback, while the superblock is still alive; hugetlbfs_destroy_inode()
already dereferences inode->i_sb there.  ->free_inode() is left with
only the kmem_cache_free().

Fixes: 014ad7c42a69 ("hugetlbfs: use tracepoints in hugetlbfs functions.")
Reported-by: syzbot+91e1fc35f51774c479b2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6ae27525.5451848c.f7707.0001.GAE@google.com/
Cc: stable@vger.kernel.org
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
---
Resend: my mail provider blocked the original submission to the lists
on 2026-10-29, so only the direct recipients got it. No change to the
patch, except dropping a deprecated Assisted-by trailer.

David asked whether the tracepoint should be renamed now that it no
longer fires from ->free_inode(). I'd keep this patch as is, since it
is tagged for stable and the event name is visible in tracefs
(events/hugetlbfs/hugetlbfs_free_inode); renaming it in stable kernels
would break existing tracing setups just to fix the use-after-free. I
can send a follow-up for mm-unstable that renames it to
hugetlbfs_destroy_inode, next to hugetlbfs_evict_inode, or fold the
rename into a v2 if preferred.

Tested with the syzbot C reproducer on a KASAN kernel with the event
enabled: the use-after-free reproduced in 3 of 3 boots without the
patch and in none of 12 runs with it, and the event is still emitted.

Tool-use note: the analysis and testing were done with help from an
LLM-based assistant; I reviewed the change and ran the tests myself.
---
 fs/hugetlbfs/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 01c4d6f44..5bd348288 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1179,12 +1179,16 @@ static struct inode *hugetlbfs_alloc_inode(struct super_block *sb)
 
 static void hugetlbfs_free_inode(struct inode *inode)
 {
-	trace_hugetlbfs_free_inode(inode);
 	kmem_cache_free(hugetlbfs_inode_cachep, HUGETLBFS_I(inode));
 }
 
 static void hugetlbfs_destroy_inode(struct inode *inode)
 {
+	/*
+	 * Not in ->free_inode(): that runs from an RCU callback, when the
+	 * superblock the event reads may already be freed.
+	 */
+	trace_hugetlbfs_free_inode(inode);
 	hugetlbfs_inc_free_inodes(HUGETLBFS_SB(inode->i_sb));
 }
 

---
base-commit: c339f4010dea8b0d754f84ace70cd1b089878ef8
change-id: 20261031-b4-hugetlbfs-trace-341b338ab57b

Best regards,
-- 
Joas Antonio dos Santos <joasantonio108@gmail.com>



