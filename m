Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D83CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 691E46B00A5; Sat, 23 May 2026 13:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66A6D6B00A6; Sat, 23 May 2026 13:55:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6F86B00A7; Sat, 23 May 2026 13:55:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 499656B00A5
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:55:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 18966A0BD5
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:55:42 +0000 (UTC)
X-FDA: 84799437324.01.C459997
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7695A40003
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:55:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jjm6d2SI;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779558940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ciy3fc6rPG867pO7XlQiiPhPSYMnUaJVLh8uNzpmzP4=;
	b=QTHsdC6QGbwk5nfD2WLxR4cwhM8+1aJSnRznFVVQ4IplDX6ziR9vF+DP/9MI/sD6MlEvcS
	IhAx0a5PRJdC6Ural8IIq5ykOvPH5+u1ZwJx+uo47FTB1pDsopdwVAE+dM/aOG02hE4DQx
	jabZYDJC1m173f7rv/nnhMhFPThqNwc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779558940; a=rsa-sha256;
	cv=none;
	b=HeH+nMa57rwhKLz2zsFhvTAcvUdwEXmIrz2NRce4FGIcNAsAWQgwiZjkHNI8xqw4k4vpxu
	MNQkxbKfwp80AlNna4EgsO8v5Q5oNfN/+bHE5cvuC7UQ0N/Q5A/RXBuNIYgOkfvv3dDPTj
	Flz57N+8YS9qejL5tq6BEz61HkBNE9w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jjm6d2SI;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1820C60136;
	Sat, 23 May 2026 17:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D2C1F000E9;
	Sat, 23 May 2026 17:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779558939;
	bh=Ciy3fc6rPG867pO7XlQiiPhPSYMnUaJVLh8uNzpmzP4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jjm6d2SI9Nu7Hx3j1OC2PLh3FqVe4KFNVo+MSAgv41PgIQXEqGyPVMvwpSfYgKnXH
	 uzkfQ6qPea9ETsNeZobk+IVCuwvfr8LMKc2Q6kcmtsEoSQH4hnwmUngCTvzOg1hFFK
	 CIRM38hr6bBmHU+IMHxo8otBgSjrHUnlcK7YmSCGa4B+ktawZtU2XLQk7TOtPkNKfm
	 FO6jSlM6EBnZMmmQ/MVg/PXMYVhGaUjesm/iVxPHj2YthtQiCBY1qwXPlDnxfGkM5L
	 egE3jan3i9N+780/faPy3D4BiqHbima0B01JeASewk99glkhCmxR3CIG5rCUqLCQBw
	 DXOcG91KaO07g==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 23 May 2026 20:54:20 +0300
Subject: [PATCH 08/17] libfs: simple_transaction_get(): replace
 get_zeroed_page() with kzalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-b4-fs-v1-8-275e36a83f0e@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
In-Reply-To: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
To: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
 Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, 
 Kees Cook <kees@kernel.org>, 
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam11
X-Stat-Signature: 7o48xap199uchmsbweyi116ym3c47rxb
X-Rspamd-Queue-Id: 7695A40003
X-Rspam-User: 
X-HE-Tag: 1779558940-528151
X-HE-Meta: U2FsdGVkX19SmXgHsfo3/QM/jeTK8T9GOho4tmRxkyAjxQwTqZoN/oyM9I2Dn4Tfyaj5OIEZR7KD9zx/0WN4dkmGFV7HooK+1/kBvVtzb3CxtebP2UADW12fjSCkL7OLWip4vVucuKQ31qgBTlL1FRBphGt703jEHiPlVb97/bTwCieGXGWKXciO7zOaPwNSmR35rHgZik82925JxFy7LVpNhJzS27XhyKGNdj5+SsLQbGHZzEQH/I4VEsOtv4L3fEWxpJfBQwpv5QanzmmzdrHRNs5nk2aKNQja+rZWOwGbbTtYl7JiiQ8JGdKgl2Y4JHN03nFlsRBiHojhGLVBzTUTlV5vJR+vKDAVGvYskyc1pNxAQIbnBZITtcrMyAnv4qs/GOuyvtAUUlIRG7hu8/9tdYXIIxe61rYLc+xHmiVQW6Hai5LXbnU6lxBrkaBuyutuvRAbtvAQpbhwQ/XzhYHzmPkH70efbWwDNYhbdDVGu1+mY/bOw1brjNPPrmihZdpWcazEw4F0LPjNURRepw6LoXp61j6+hY0862+6gXSNpFiLs9/nS/5+g/3ebQVirsLCoJKSt2+wSA+pPa5P4bmBEIXWXFAl4veeL2AYbul6dl1REptrtJYM+nL1xVIDFnTBaT4NZd4sCk8xZah3dz6aLvZ7R700vRROYrTnm5UN+IHpIe9EB7Piu3lKrDDdBgwjPi4vPaaT+6RRt9niNiYekPER5CAmm85DmPhL4uinBEV5EwKw727Sls4QqKg5abK3XkMb6J7mJymwD4kmNHfpdON9iGRJDlGC4qMd1mq4fw3jMZyyRFKbx+yug2b4whpqMELQU+2XLp/tt90jmpR9oY3r5ZeeNevrPRBmWZJjve1e2pGmxPNrh7+c3Ymzsk2afYD9uPIb9edrqpAEURwS+6TOZLs66jXFnLMW2b5ynxRMHjrhhAB0Peg/0KHqqJ9aJ3/8OBy32wr7RpZ
 NBlRKXO2
 xGYv0BBNTDzt+MfUf3zFCSq69wZoteOyQBCC+d8oA3HVl9a6Skcr1DRlA6jjpDkiWlPlklLX05Pz5wbS63E1Z7EDGZdgWKnDMyGUTSzjetua3r9Pcr9KuWnzoNXsNXmYbNXB+M8Typ71o2lh2Jl/N6Uc/xbxkc53VBFz8oMJkPIBqKishBH8Yvv7zSw37oRmpk4dUWhRGKKzEujqyw8FIzh2ssRQutL8PUiap61+Rqf73q521HAEjaGHnaqTRTTrnXcaCHHRMkvjUAIWEG6M7skTWyI1sWOMY9wnmxDLCmMqkKvR8paxIYX/vEKiyCFk1Vu25R+ojU7JsISf40xgAJFDxvVoKX9lW6UUe/6r07lQDKW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

simple_transaction_get() allocates memory with get_zeroed_page(). That
memory is used as a file local buffer that is accessed using
copy_from_user() and simple_read_from_buffer().

kmalloc() is a better API for such use and it also provides better
scalability and more debugging possibilities.

Replace use of get_zeroed_page() with kzalloc().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/libfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 1bbea5e7bae3..80a330c8296f 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1258,7 +1258,7 @@ char *simple_transaction_get(struct file *file, const char __user *buf, size_t s
 	if (size > SIMPLE_TRANSACTION_LIMIT - 1)
 		return ERR_PTR(-EFBIG);
 
-	ar = (struct simple_transaction_argresp *)get_zeroed_page(GFP_KERNEL);
+	ar = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!ar)
 		return ERR_PTR(-ENOMEM);
 
@@ -1267,7 +1267,7 @@ char *simple_transaction_get(struct file *file, const char __user *buf, size_t s
 	/* only one write allowed per open */
 	if (file->private_data) {
 		spin_unlock(&simple_transaction_lock);
-		free_page((unsigned long)ar);
+		kfree(ar);
 		return ERR_PTR(-EBUSY);
 	}
 
@@ -1294,7 +1294,7 @@ EXPORT_SYMBOL(simple_transaction_read);
 
 int simple_transaction_release(struct inode *inode, struct file *file)
 {
-	free_page((unsigned long)file->private_data);
+	kfree(file->private_data);
 	return 0;
 }
 EXPORT_SYMBOL(simple_transaction_release);

-- 
2.53.0


