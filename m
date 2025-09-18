Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83F43CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 08:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFEE58E00D9; Thu, 18 Sep 2025 04:48:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7138E0093; Thu, 18 Sep 2025 04:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13528E00D9; Thu, 18 Sep 2025 04:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A42818E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:48:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B5B8C084D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:48:32 +0000 (UTC)
X-FDA: 83901744864.11.00FA0DA
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9726A4000A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:48:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=UMJvnw7t;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=rnUpVrH7;
	spf=pass (imf27.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758185310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NovFkcDVYf3fWWfVdmD07cNejJYNvS+8SZukBGrwXpA=;
	b=z/UPHDlFZ4xDGI+iA2RBFskcnToXdlLq1tTwGVaRM0MFHctouOAIKTmTc5KqI+U1OlQnTK
	Ez4yLhe9XgWBBESpMJfbMQoVicpbJndVeuN8p7Aj7d5CEp7/f7fjxHwEz9/7fRf4cRI8uc
	KwXNhH0aVLkr5hUnMUeQsRJ0iUT08Qs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=UMJvnw7t;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=rnUpVrH7;
	spf=pass (imf27.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758185310; a=rsa-sha256;
	cv=none;
	b=TpSn2NPDoR7xnxD2dqfGTQ9n4iFNx1QiQZZXNE3R7jMbObUE8zUAdHIcVLUsM6LJzuGgxU
	F6kPyvHeNExYbqDhodUKy0zERVH509COUQsYhhDRlq8wFufo0WViZNdBrONHoSrOrYqcWs
	gw4l0yvDW59QRF0M0j7u3D0XckDsz38=
Date: Thu, 18 Sep 2025 10:48:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1758185308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NovFkcDVYf3fWWfVdmD07cNejJYNvS+8SZukBGrwXpA=;
	b=UMJvnw7tiZL+wh09yBToLHDtDL90kX13No0ExrtQl+3EY/ze8xgLAgMsERf4qS8jdOXkZ7
	oxgp+16vwQNQ588n+AQOpNu/bvCaBpsHh2RrLRjqVvIDINfBe1ZrOi0oEgoa9r77kDtkN7
	hdgbx6fAFRa9RwmYwrz+XLgewSHDKgjBj0VLc4puD5yGQMgZA2zeEvis492h3cOsYg+S3H
	TZ//CW7P1vEa1qYJnBznmYll7XP9zBfA5ffYXF1EGvpl7FP2ZKvKkAplMxcyjYfh6U0+Vz
	WV80UlDKKIheOU6PbJ0RpSc312vj49Xe+XTkwSLWVn9v2vvSpad8TmAUk0JdPQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1758185308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NovFkcDVYf3fWWfVdmD07cNejJYNvS+8SZukBGrwXpA=;
	b=rnUpVrH7VLqgqPHwqBZcw1/2erH1AKrwHgZd1huwdHAkcgbLyJnSRkZEPRrNCsbs46vuhb
	OUG1H3/w667CjnAw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: syzbot <syzbot+80cb3cc5c14fad191a10@syzkaller.appspotmail.com>,
	Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	bsegall@google.com, david@redhat.com, dietmar.eggemann@arm.com,
	juri.lelli@redhat.com, kees@kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com,
	mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
	rppt@kernel.org, surenb@google.com, syzkaller-bugs@googlegroups.com,
	vincent.guittot@linaro.org, vschneid@redhat.com
Subject: Re: [syzbot] [mm?] WARNING: bad unlock balance in copy_process
Message-ID: <20250918084827.TWzT-hc4@linutronix.de>
References: <68cb1cbd.050a0220.2ff435.0599.GAE@google.com>
 <867144d3-b05e-4ce2-8bb6-da01e10fbd73@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <867144d3-b05e-4ce2-8bb6-da01e10fbd73@suse.cz>
X-Rspamd-Queue-Id: 9726A4000A
X-Rspamd-Server: rspam05
X-Stat-Signature: 7aqzkz7wai7cbi4qu4fzppxfo6za3g7w
X-Rspam-User: 
X-HE-Tag: 1758185310-190205
X-HE-Meta: U2FsdGVkX18IzaiPNzh3w2NJIV/zIypt/McbtV9q6jvnphqa5HqL7TVgHEojfbGaagsNMPQ4GBccwqItITfelRH9m0kbNpF/RS1DPAdR5XoiARgjcya0yqOyPwcUiS5TXpy3YuQxCNb2XkaKfrFU5AoySXu1Erd+yGoI8y2xzsKt6MZOLGGYYvmaWMrg/b68wliik/ZSPE8xJY1DMCW05j3hghLv/avbzBuO/E2HVEv3SypT7e3D0DhfBIV+W0tBhuvM79lK7fLzdlQW8JaBk9ph6zpXqyNdcw7ql8hBdnxc5q+RHRM+Pwi+cVkIFvgPfxil1jXNaOrmKrY9sOxdrlZ3QW9EIMdYrjSlCkPah763J36lPCP2ZbAHWlQWSG9qCu2awU13+7c0k6rQIVJfIv6xx/7ElXqsFi+WtkdE6f5qMvedS7NTUdfCdFuqrmdgy9z/vk3QXwMx4kaLWXqT4Kz9v/a34hkyrXpwdtyWTtoz+LegvuIg+fkvK5xx2gUyZ+i+H4VuWhFEZdSujsNFOhGIBudmz/yAQdfHE/qebnDD199EYPQbOSvxHEXmHsrZjIOE8zKijXCR9XI16OvcikFA2T3QKS1Dufsll/StLD0bILfT8RZMesrit/YDSa8GzxNx/ic7UhchPy0gPtI/LWlBlrvc5Pk5RiXT+wAV0c2q8oKt8AlLuIGPx1SiQzspQCK+PJn5s5CkTpLDHQ9KUHUFMXfOM+S7RPMqiW87IKOyyrX5Xd/Hus32LKSTDuwr/pZ8lODivafKKkOFrDx+Qn18FzX+ouBYKlDaLb0bYXjeQ35sngbVtRDIcKgzmMHu4//oaGUmQJVlc/8N5QelGCK+8oeAhi5FFDroiW9wLdyiFiZ0bzc8NKJjc2n7q63F0WsdTHMgNl5HAdkytUjK0+w8ZX2+BGmzz7v8wLKV/g/RmKC/coFpg/wN6WcymwZd5OuJzwdINoISvBQjTBV
 WkkqT5Ah
 F6iAdOagguSa1+2eW015qPLxP1KAzBcVj+f0tE24A6s6/yPq02Kr983waNVCGI/QmZEHznzcw8QA8ghZnRIKq137oMN/Bc5jh1yuqdB2VXZG8jBp5mgc1YNX0ET9FM38x4SoPoymaszh9YNHDFZOaaPugVFxxLtte+S/5RJGadQDYxdvJKGEB+fXsP8BDDNa4X2MMXVVlheoo2XpVfBLXDCRIQ/ElTvjIirI22YX/onxA9h+r3G39jdSroFT4T88weeUFUvfsI0+iPWaRcjWt+2iFIzjsqq+Ip27GmkTO/mEqnNcVqz/l+NruaLAFZ3BfR6unbNHj16RfQKEXAkLj2FbXn7m4p1H1VYXJdiV2mEXFaNwsYjMn14Q2u1jGrG0R5OhK035qDBNB4BUVfH/gtCQv9QnG23mdZpqfrAbH1yb6jfKNfHTVk3zWt9mE4fBXzYcelBKiu1rBdWG4WriHPcVzx2B5PWsaTGGhsC4B8H59UaM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-18 10:35:24 [+0200], Vlastimil Babka wrote:
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+80cb3cc5c14fad191a10@syzkaller.appspotmail.com
> > 
> > =====================================
> > WARNING: bad unlock balance detected!
> > syzkaller #0 Not tainted
> > -------------------------------------
> > syz.1.48/6865 is trying to release lock (&sighand->siglock) at:
> > [<ffff8000803b8634>] spin_unlock include/linux/spinlock.h:391 [inline]
> > [<ffff8000803b8634>] copy_process+0x22d4/0x31ec kernel/fork.c:2432
> 
> bad_fork_core_free:
>         sched_core_free(p);
>         spin_unlock(&current->sighand->siglock); <- here
> 
> Sebastian, I think it's your 7c4f75a21f63 ("futex: Allow automatic
> allocation of process wide futex hash") adding a "goto bad_fork_core_free;"
> from a place that doesn't yet have current->sighand->siglock locked?

Yes. Judging from -rc6, if futex_hash_allocate_default() fails we hold
neither siglock nor tasklist_lock. sched_core_free() looks also bad as
the cookie was allocated later in sched_core_fork(). sched_cgroup_fork()
does nothing special. So it should be

diff --git a/kernel/fork.c b/kernel/fork.c
index c4ada32598bd5..6ca8689a83b5b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2295,7 +2295,7 @@ __latent_entropy struct task_struct *copy_process(
 	if (need_futex_hash_allocate_default(clone_flags)) {
 		retval = futex_hash_allocate_default();
 		if (retval)
-			goto bad_fork_core_free;
+			goto bad_fork_cancel_cgroup;
 		/*
 		 * If we fail beyond this point we don't free the allocated
 		 * futex hash map. We assume that another thread will be created

Sebastian

