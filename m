Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85CBCCAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 20:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78158E0016; Wed, 17 Sep 2025 16:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4F5C8E0012; Wed, 17 Sep 2025 16:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C828E0016; Wed, 17 Sep 2025 16:14:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CD618E0012
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:14:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F0B45A493
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:14:13 +0000 (UTC)
X-FDA: 83899843986.16.EC3B27A
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5BEFDA0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:14:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=TH1QaPv1;
	spf=none (imf25.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758140051;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QfpCzaT2p4iQp70qcwxepldsjgNkeN5UhrG79FYYO3s=;
	b=ZRvidjha1ffHghtjES5zSP2Zfs6TXmyizIWW5nD/Hib30gwu0uOvZQDKlU1h7bjrxm1HwJ
	eRonF6IVKYGPwBPjE3tJolpl0Lk9BlzOVQdZWXE1RmDIW/D6moRZkfzkZBwQHV9XHXkeOP
	IMR6Oi7V3ssMqgxQXOaMja8qYHas7aI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758140051; a=rsa-sha256;
	cv=none;
	b=f9Q4pW7PJORdrSvcAmXOVld33GtIbcL5ymwrBYSd0KVAIktX8tXYCjzpjWzDJ5Fl6TRgsw
	mdpPMWGHooDQ5p/i0fPsUJXRIu8Lqfk5KiQVi4kYMwyFEsWGDsIRAc03GMmd/mZ18eWwRj
	650mV81s7m2tpXyQlpV7bwqBbU92PMs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=TH1QaPv1;
	spf=none (imf25.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QfpCzaT2p4iQp70qcwxepldsjgNkeN5UhrG79FYYO3s=; b=TH1QaPv1dzyQ1aS63yfbSauS6s
	/14Z4rgs6HB4WMQvJBLH7sQc/88GK5sBKUlXNSkd5BcdixV+ZooCpi0mQ8hXW22jGL5eCjuLGC6WJ
	z6UdSRiJzFQhOfQm5klQckGM/rq4RFEkWb+LGUGMJY86Qk1YyGwuPl+Xf02ve+CRXG94gEbEOVk02
	o3mlYs2Ke3JHDBnuJTmbghJl0QVX4tSLqdGbMSzznAh52RpRoIk/wr5ClsMYNzCNmR/yslNWbazGp
	t2F8zqY2j5ITvcVB8L79azP8kzZrmsoB+/lg1rNBRwbJH8tHuxhOAsN+pqhibTX738eFqAermHeqd
	Yv/K/iew==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyyXY-00000007ZWo-2zlc;
	Wed, 17 Sep 2025 20:14:08 +0000
Date: Wed, 17 Sep 2025 21:14:08 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Max Kellermann <max.kellermann@ionos.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	ceph-devel@vger.kernel.org
Subject: Re: Need advice with iput() deadlock during writeback
Message-ID: <20250917201408.GX39973@ZenIV>
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5BEFDA0003
X-Stat-Signature: n3d8ewob6rx841m1axuwzhcxuyipnzjt
X-Rspam-User: 
X-HE-Tag: 1758140051-104187
X-HE-Meta: U2FsdGVkX1/Fcm1nEbmRxh8vGm2c1IbL9+62otPS6ndXMgl6n33uLz/4PBMO5RicGvqrq7pkUS5g+OP9aPHpsXCBdkN7YgYdg+HOW448IG6jNe2ckn9qo/KaujpRalJ6XN6bGZfYIWl+8ifLgcvyr16MGdiN8/m4dgNfIEX0tMkK12sFQy4vjJu+qWUAqrwi3kNU43UEup4v8PtpJDCcvxV8OmRyT37vyD6t56zRRHTKkvh/hylZgWwNunU1CxWFZrAaxONJLyybqWC7NDCRKs2IR3fBkdsKIIACuNpRV5uU8NAd5469+7AiGmlJiB0oWWwbnkGS9tVxOWX+0rDTw4YtTMfZiH9Vm1Oojxjk5z9Oz+RfmwNPiYNtY4RaR1sm8dkNu5MKPgUGFU/JxGfqeP9WOpzESn/KfTHW7ClsW55bP4Hpu8hZd6bsMOYWHuUracNFtxpHkfN2fffSY7J8hUSPtC0vMYRX0dQ4wTc9FJs7b1A4vEnqKRLjXuYWpLPSyz2LZSP0gQPdfl7HUcpd/DKEGH3U1g5n4jHWR2VL2+hT7h7DX3cLYm3IaPulT8NJsJbIDhT+MchTRo23u843ux02su+6zG9NKPJsC7viL6g1jnqIdH5hA3lltIlfP0RianRji1RUzdHkmElfpQSVr/lxj64LXdRiilFxNpzN+gwdCqP+/okNQkAhMvwoGosioeEjdP2dVjoXRfu0OFZyVKwg/ZNrjCwjKpeA4+G1oGgJhgcKFSzgghCfH18FJtOybteigfRiiMcg5FE7H+bDVMmMCf602bs6JJpJkjnJ6M9y4SQAHqqOvaFO/g4ptwyYQgEPoPhnBZgGyohDWdAfVlypAbzfdI73u1wbamR6JKmOx53IXNsqvsZYEjnJj2tVH0avz8DT2HR04GUGKlGPG7lX+V09QU8GKqNbTdZ5OHl6xE7pkmBqAMyF/4Z5CJLZNE9bSwLE6Gs7OQfreW2
 gOHgRPI4
 4fK/cizTH8BuNJSC/gS8mgv9IhIRBcr6ZNuLH/VjhqHCbFu6RC8IqEoB6pY/vcSxdKS4jLzHxKNaAYXDVpqYd2YNO1Dqax/koNjYmUV0OIYlaY/dU609ghB2e730tBKwQKYpEaLYSYS4TXog=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:59:23AM +0200, Mateusz Guzik wrote:

> A sketch, incomplete:
> static DECLARE_DELAYED_WORK(delayed_ceph_iput_work, delayed_ceph_iput);
> 
> static void __ceph_iput_async(struct callback_head *work)
> {
>         struct ceph_inode_info *ci = container_of(work, struct
> ceph_inode_info, async_task_work);
>         iput(&ci->netfs.inode);
> }
> 
> void ceph_iput_async(struct ceph_inode_info *ci)
> {
>         struct inode *inode = &ci->netfs.inode;
> 
>         if (atomic_add_unless(&inode->i_count, -1, 1))
>                 return;
> 
>         if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
>                 init_task_work(&ci->async_task_work, __ceph_iput_async);
>                 if (!task_work_add(task, &ci->async_task_work, TWA_RESUME))
>                         return;
>         }
> 
>         if (llist_add(&ci->async_llist, &delayed_ceph_iput_list))
>                 schedule_delayed_work(&delayed_ceph_iput_work, 1);
> }

Looks rather dangerous - what do you do on fs shutdown?

