Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9F14D262B2
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 07:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24CAC6B0005; Wed, 21 Jan 2026 02:16:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FAF96B0088; Wed, 21 Jan 2026 02:16:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DC8C6B0089; Wed, 21 Jan 2026 02:16:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EEB2A6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 02:16:27 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5ABF160141
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 07:16:27 +0000 (UTC)
X-FDA: 84355112814.07.447E65B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 79703100002
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 07:16:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="lCh/8K1a";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R1GCO+UG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="lCh/8K1a";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R1GCO+UG;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768979785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/usHWUFZWwt24U9Yjv0VfEz0DO1g3eDaD4Ua5kdbMqM=;
	b=nsyuh92L/guS68ZlQu4MDoCX8owUdFkqE+Kbzaz0xOgNuQ+dT0IR/mTT41ZIsTZ/X0ZMQf
	pcn3cbds8Teq1Y+3eUZ4zdt+1I9CIoVzTv5GB96jo556BKLqxv9otApq7384eYFjpaHaqX
	G+LCW5gx1iuxSRzxmhmyczRwyXYH4dg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768979785; a=rsa-sha256;
	cv=none;
	b=mpPeh1wrfnSy4CnDvrl8zUK8F5iqZ5LOGfuitCgPouND4Ov+2tZZWGUnFRG+nxiYVH0Eq7
	l/rvsy5583tjvRdFaxZvL2ymjLngswSEw31/HLuV07KBWYCxwOTg+43h3rtgM9p9nklv74
	BxUGCfn3I4+BU/+bHZzgUvJY+n5XOKM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="lCh/8K1a";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R1GCO+UG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="lCh/8K1a";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R1GCO+UG;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B2FD333689;
	Wed, 21 Jan 2026 07:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768979783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/usHWUFZWwt24U9Yjv0VfEz0DO1g3eDaD4Ua5kdbMqM=;
	b=lCh/8K1a9jNDAtVaUkabanAAgGWcOuQWUpwWCIrfHiKmOHSzI8xZw/GMmW+aeB34JSl5bt
	mSph2FeDJyvnWMCXs7ry/soqtlhTArPyt+utoypWQdpM2vDNuzLcEviTkBq9ENXYgHqquV
	6ysjPALlK7Tbmgv+p04WmSZ/+9Wa+Lg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768979783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/usHWUFZWwt24U9Yjv0VfEz0DO1g3eDaD4Ua5kdbMqM=;
	b=R1GCO+UGau5+fc8bT/sx9YhTRHRWqVVYBhWyi7sR7aMbT98OGfwPWNnEZcO8wmyNeV7xzz
	EWhcrn6WsnEnxVDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768979783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/usHWUFZWwt24U9Yjv0VfEz0DO1g3eDaD4Ua5kdbMqM=;
	b=lCh/8K1a9jNDAtVaUkabanAAgGWcOuQWUpwWCIrfHiKmOHSzI8xZw/GMmW+aeB34JSl5bt
	mSph2FeDJyvnWMCXs7ry/soqtlhTArPyt+utoypWQdpM2vDNuzLcEviTkBq9ENXYgHqquV
	6ysjPALlK7Tbmgv+p04WmSZ/+9Wa+Lg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768979783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/usHWUFZWwt24U9Yjv0VfEz0DO1g3eDaD4Ua5kdbMqM=;
	b=R1GCO+UGau5+fc8bT/sx9YhTRHRWqVVYBhWyi7sR7aMbT98OGfwPWNnEZcO8wmyNeV7xzz
	EWhcrn6WsnEnxVDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A13543EA63;
	Wed, 21 Jan 2026 07:16:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YvLaJkd9cGn2OAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 21 Jan 2026 07:16:23 +0000
Message-ID: <d29bbf0a-0d70-40e0-a6be-e44b768045a2@suse.cz>
Date: Wed, 21 Jan 2026 08:16:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible KCSAN/lockdep issue in -next barns
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, "Paul E. McKenney" <paulmck@kernel.org>
Cc: linux-mm@kvack.org
References: <c858b9af-2510-448b-9ab3-058f7b80dd42@paulmck-laptop>
 <aXB68e_DtXsr7OcB@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aXB68e_DtXsr7OcB@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 79703100002
X-Rspamd-Server: rspam12
X-Stat-Signature: yyn1ez6c1ydn7bozhf3tgxi81x5bcawu
X-HE-Tag: 1768979785-466568
X-HE-Meta: U2FsdGVkX1+IZ1cxrRAtlw8ziS0NRmMNorG34+LNtuOfSqTgNHAjVrNVXcvyr6Fu8wciT8rxslRuX1/MzkHJCm+vHuuDcAx99cmt9d1CS3fpTEWsL/6jYR4cBDe6JvELvblkfpDG1O4QaW0FFNmvnzShfYhTYpFmAjgGKNyZdG1Yyw3QiaYtZnSW+vA/FFdW1B0yp3S529ztUd8ext2pZzCWB2K8z4NYghTOdUpSBliY9wjdSC+0iCpp5Kq9muAerkQTRonhHV1r59NTwU/Wj/PWnolKmoBpF1vLAK56YeN/I5gmwvbZ+Aja7K8tAzNtKF7fd/fAiXdNyNKG0Ab6dS78afXzyW94J/Y7dHVoV61lTW7mJOs7JAZDCnHRYDVsYlhCpOh6hwvrftwT3y2TrA5QNGJQ64+Z842W2S6v1spKOmzCXJoutzbfk3n4vYlDhwtutacSqNVoSEp+IWMC+V3MOZjutChUuBNzX2Rse1ivlZ7isFXBoEhIHWgjI5+si09cGyW8Fwm42FSYrUp/Inp3hBgvu7UuJyg9ET1KpKyHXgx/T7H97rcvSWZLSdemXmcPomfdpSjhQXhUJlBXm8phIFRH4dECDVp3b8xnpsB4/paMNU/jgDK5EzBJuy4M3OEEIwKy4s0ZgTIygjebybCoc4jvgCFB2gGz/BTxupq0MnsTEMDPl6BVj5kokdum+B4aNZ78++fr2BgLOaVW0a4nU3Md2izs1tovjM51UzjHWsO8S1DbuQkDs2Qi48uqDatfa2L340HcyT9Dae7RM8cWRM4YEFNTyB1j68jo9DH0W4eQDMSoMRUDfediX3IYCeHh6VT0E3c7ftb0fDvwvIrCskIFUfsQuRB9xXiGTJOjJxyBWeyGz4bjJ0H4FBpd2AfqO0mQoPAAQhKJljT0UStWsLUhYnZ9RZWmzTWzcIrEpSpznn2nHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/21/26 08:06, Harry Yoo wrote:
> On Tue, Jan 20, 2026 at 09:41:14PM -0800, Paul E. McKenney wrote:
>> Hello, Vlastimil,
>> 
>> On the off-chance that this is useful new news.  This happened in
>> rcutorture's TREE04 scenario running with KCSAN and lockdep enabled.
>> 
>> Thoughts?
>> 
>> 						Thanx, Paul
>> 
>> ------------------------------------------------------------------------
>> 
>> [  253.872153] =============================
>> [  253.872271] [ BUG: Invalid wait context ]
>> [  253.872271] 6.19.0-rc6-next-20260120 #21508 Not tainted
>> [  253.875774] -----------------------------
>> [  253.877983] migration/1/23 is trying to lock:
>> [  253.877983] ffff8afd01054e98 (&barn->lock){..-.}-{3:3}, at: barn_get_empty_sheaf+0x1d/0xb0
>> [  253.877983] other info that might help us debug this:
>> [  253.877983] context-{5:5}
>> [  253.877983] 3 locks held by migration/1/23:
>> [  253.877983]  #0: ffff8afd01fd89a8 (&p->pi_lock){-.-.}-{2:2}, at: __balance_push_cpu_stop+0x3f/0x200
>> [  253.877983]  #1: ffffffff9f15c5c8 (rcu_read_lock){....}-{1:3}, at: cpuset_cpus_allowed_fallback+0x27/0x250
>> [  253.877983]  #2: ffff8afd1f470be0 ((local_lock_t *)&pcs->lock){+.+.}-{3:3}, at: __kfree_rcu_sheaf+0x52/0x3d0
>> [  253.877983] stack backtrace:
>> [  253.877983] CPU: 1 UID: 0 PID: 23 Comm: migration/1 Not tainted 6.19.0-rc6-next-20260120 #21508 PREEMPTLAZY
>> [  253.877983] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
>> [  253.877983] Stopper: __balance_push_cpu_stop+0x0/0x200 <- balance_push+0x118/0x170
>> [  253.877983] Call Trace:
>> [  253.877983]  <TASK>
>> [  253.877983]  __dump_stack+0x22/0x30
>> [  253.877983]  dump_stack_lvl+0x60/0x80
>> [  253.877983]  dump_stack+0x19/0x24
>> [  253.877983]  __lock_acquire+0xd3a/0x28e0
>> [  253.877983]  ? __lock_acquire+0x5a9/0x28e0
>> [  253.877983]  ? __lock_acquire+0x5a9/0x28e0
>> [  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
>> [  253.877983]  lock_acquire+0xc3/0x270
>> [  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
>> [  253.877983]  ? __kfree_rcu_sheaf+0x52/0x3d0
>> [  253.877983]  _raw_spin_lock_irqsave+0x47/0x70
>> [  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
>> [  253.877983]  barn_get_empty_sheaf+0x1d/0xb0
>> [  253.877983]  ? __kfree_rcu_sheaf+0x52/0x3d0
>> [  253.877983]  __kfree_rcu_sheaf+0x19f/0x3d0
>> [  253.877983]  kvfree_call_rcu+0xaf/0x390
>> [  253.877983]  set_cpus_allowed_force+0xc8/0xf0
> 
> set_cpus_allowed_force() is calling kfree_rcu() with a raw spinlock
> (pi_lock) held, but barn->lock is normal spinlock, lockdep prints an
> error because on PREEMPT_RT normal spinlocks are converted to
> sleeping locks but raw spinlocks are not.

Hm right, Ulad did raise this issue and thus I made kvfree_call_rcu() skip
the kfree_rcu_sheaf() attempt on CONFIG_PREEMPT_RT.

But I forgot that lockdep (or a related debugging option) checks this
context even with !PREEMPT_RT.
We could skip kfree_rcu_sheaf() when this debugging is enabled? Not ideal.
Is there a way to detect such a context on runtime and only skip
kfree_rcu_sheaf() when really necessary?

> Hmm... but it isn't great to convert barn->lock to
> a raw spinlock just because of this?
> 
>> [  253.877983]  ? cpuset_cpus_allowed_fallback+0x27/0x250
>> [  253.877983]  cpuset_cpus_allowed_fallback+0x15d/0x250
>> [  253.877983]  select_fallback_rq+0x1d8/0x250
>> [  253.877983]  ? __pfx___balance_push_cpu_stop+0x10/0x10
>> [  253.877983]  __balance_push_cpu_stop+0x4f/0x200
>> [  253.877983]  cpu_stopper_thread+0x147/0x210
>> [  253.877983]  ? __pfx_cpu_stopper_thread+0x10/0x10
>> [  253.877983]  smpboot_thread_fn+0x24c/0x390
>> [  253.877983]  ? __pfx_smpboot_thread_fn+0x10/0x10
>> [  253.877983]  kthread+0x1fa/0x230
>> [  253.877983]  ? __pfx_smpboot_thread_fn+0x10/0x10
>> [  253.877983]  ? __pfx_kthread+0x10/0x10
>> [  253.877983]  ret_from_fork+0x157/0x2c0
>> [  253.877983]  ? __pfx_kthread+0x10/0x10
>> [  253.877983]  ret_from_fork_asm+0x1a/0x30
>> [  253.877983]  </TASK>
> 


