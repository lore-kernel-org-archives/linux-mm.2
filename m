Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2ABAC5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 01:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B3D36B009D; Thu, 20 Aug 2026 21:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 764866B009F; Thu, 20 Aug 2026 21:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62BCC6B00A0; Thu, 20 Aug 2026 21:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B6716B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 21:20:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B43C71C0C72
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:20:42 +0000 (UTC)
X-FDA: 85123521924.27.6C90D1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id EFA6C80009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:20:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RNNV+cYZ;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787275241;
	b=Zni1L6Q6xCzIS2mwQhKBxYW1rbI+qtpYREOoHnS8L7THXPV11oCAyZhhk7ghBDju2gmfQG
	gmCbj/gTiidU7x6t/6xRYoYgXLkMtHcX6H2lvPRzCBJx4yr+foVzqWMMdtTn0f3b/xIDbg
	i/KGBzUKkFL9OB4g2YbgTqnIlRuJDxE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RNNV+cYZ;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787275241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfFyCgIVsZNfHPslBJGjBS2F3LWrEzkMWOBp11fXAF0=;
	b=OZwb/vASWKDOufoTMp0UTrz6mFPg97mBAceWp5cifvAxG6EyV/mEmmFqTnt7RuWRcAZo6y
	Agcc/qJz7OWCReRC2IxSOmHeQcIaZvV3Y5JvSkQ/Zx/tr5l+FfeMoVYJYX/j6rDn/9JZKc
	x8+bdckxZMxSq7Xk5R1VRqPHBeTyAe0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC6E940112;
	Fri, 21 Aug 2026 01:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11ECB1F000E9;
	Fri, 21 Aug 2026 01:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787275239;
	bh=hfFyCgIVsZNfHPslBJGjBS2F3LWrEzkMWOBp11fXAF0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RNNV+cYZ5+aJda8P1sCv52PVqhOWoeLyirlvjLUKSUBqZOYAefQ/InbP9RhJaxp2+
	 iONedHR86FeYZsi0Ko0TyghBWfBrb5ZrVxVqnTL+/nF5ZvYgF0X3MqeYE03sZsDKb3
	 6Zzb6TLk5b2bSbnTKSPP+yG4YLX/t2vlFNWeNifc=
Date: Thu, 20 Aug 2026 18:20:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: syzbot <syzbot+5f0b6e2e4195c75b5658@syzkaller.appspotmail.com>,
 brendan.jackman@linux.dev, hannes@cmpxchg.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org,
 ziy@nvidia.com, Zhen Ni <zhen.ni@easystack.cn>, Oscar Salvador
 <osalvador@suse.de>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander
 Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in kvm_vm_release (4)
Message-Id: <20260820182038.c45e454506c8cd3c1f21930b@linux-foundation.org>
In-Reply-To: <d477b226-cf6e-4101-9a4a-71c317a891d1@linux.dev>
References: <6a86fe29.f7a79266.2f965f.004a.GAE@google.com>
	<20260820092904.7a2b43fff85ed0c13b9c74ab@linux-foundation.org>
	<d477b226-cf6e-4101-9a4a-71c317a891d1@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EFA6C80009
X-Rspam-User: 
X-Stat-Signature: nirghwsqasbkspdy6u6mrxwp18mg3k8c
X-Rspamd-Server: rspam06
X-HE-Tag: 1787275240-413968
X-HE-Meta: U2FsdGVkX18RbNMtMNyN0d8y58sBuAbGqj782laD69imsBDpNq1oW279OekLlDYX82CcQtWSXGCv8+WlLpW2YlMDtnkCeM/c7/NxeDduFjCMelweoLyQK8d/hJNE0SANlj43wbUq79mTHCTBHMBdvAOp0VqTZLh/UWLOJlIdAgdS2rVC+HKoexHuOqNmA1XqnRAf4gPeqWLDstWK652gXVScoIWggL9HFOC47g5Z+Zly89cNIYEH9MkXajbpdt/rUM2mSFbcX73VAPC39znCzsxwY9vcLF7aqF7WbndZS0llVcwUTVjulDtLuwvqDeppzVqWSzWHHWsoDrzTzyQo+5YlgXCMqmU98T4UKas6enlywQDPljn/R08UzXrEordEW24GWcmLIPpT3TOBUrVfc2/uiqN56phCYZIbu2qDU0q1x39wdOAyuABUyHawCegZowT/IujNtY/j5F7L0cty+IfybV/qSPFPRdSD8smgdITy7mFI5E2WehW+KMlzBFbyFrWTwRxYN+WHEcgQt78n4OfOfRUWvNY8Ww+YHPuAtthyDdOJ1k0IehHBmDtmJLgA/A1rlA2d7vRupADAL2S/rDADEczs6Z07MQYjJBSL9/kD30JenVsUhF6Y7Z8y6zSu+54q0JE7n277q0eNYCa6KvhBNhqKMuvt8smKJ7AJ7sC0JhkSEeVqCnVp2S+PC1Bb3AsH0lKVej2bB4meT2jxHztuR/Fg471+oa84Xiupyh1uWnDStLRh2Wo37nDG+WWuQeGVEe8vjmiHd8igtofavLI+YcnytPUcAbub3h9ojV3j4uWofYKZpqDs7xef/A7f3N50F4FOV0uRv45UsErW286gjGMyS2+TsGy9rg7DucYrkK04XTiObtsM5RZKJWfPHfYhkoqSj+GFeNQhQhJTLcgBP7kGI2+qyGSGYsvXeN9kDSd548Bv4S/E/YhagYvCd3Gj3kXsD27QNcqS+U7
 lTIUtdv3
 N1ZDOjtCdMAySQrNJ6LSMtT+jH5aUfu/DZpnzjaFu4X0NUKDXfd7Oq0Wpem7op3+dpx/O9TF/DqV5pNhqMAeDNYou3pZdhinctU+FOLSEzxjpCK1sGNJmRyuTG8Q4FGilXegppqwkJzgpCnIdTWXl0uWJuOfLcHkCFyl8Q7ujg5JedzfXegE7Sohh0iiN0d4zBW/19pNplOjkihv8ma0nzPPA16t7a50w1I98FJWtJQAz3chwKqaIOys0GP2y+T5TitxSKDgisqw/AcJ4OYFHtiaDekd5ilpxNapGtxpGMLr3teXm32r1AME60MWLf5IwCPw/2TYAwhN16JPz0qWgwT55DB5nzcD+7SSOJrbhybbybLgDYj3406glVbCbslagMCA79518PLf5us5XXpgoPtahNShzMiZzxD5Fg1zA+8f3dSsPBHsPbd8kqxNG0DGTfqSeoLBX5+6jIJeWsWCoMPKcwPUuooxU08Il
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Aug 2026 09:06:48 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> > : The combination of debug tools: KASAN quarantine processing + ORC
> > : unwinder + page_owner stack tracing executed so slowly on the CPU that
> > : it exceeded the RCU stall threshold.
> > 
> > (I think we've recently seen the same thing, different callers)
> > 
> > I can't say I'm terribly motivated.  page_owner is expensive and if you
> > run heavy stress testing with page_owner enabled then such things
> > aren't surprising.
> > 
> > Let me Cc a few page_owner and KASAN people, see if they feel
> > differently.
> 
> Adding cond_resched() to the qlist_free_all() loop would fix this .
> kasan_quarantine_remove_cache() already dose the same in its scanning loop.

I don't think cond_resched() does what we want for RCU stalls.

And cond_resched() is a no-op without CONFIG_PREEMPT_NONE, which wasn't
set here.


