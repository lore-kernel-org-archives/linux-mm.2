Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C16BCD37BB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 20:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA6DE8E001A; Wed, 12 Nov 2025 15:24:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7E0E8E0011; Wed, 12 Nov 2025 15:24:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBBD28E001A; Wed, 12 Nov 2025 15:24:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CB7568E0011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:24:50 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9CE9F8980B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:24:50 +0000 (UTC)
X-FDA: 84103083540.01.B7F3C01
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 212AC180002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:24:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MMV7TwLQ;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762979089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w99u8UTaeMEokMZw0/vRmMX2Eo0plGVgzdi9tGIbBcM=;
	b=d9XF38vLet/jIgtPRBvNfEyrMPXCQvmeg5aGicVtmBre47pXzEsaBmUYT4Ohv+q76OGiuZ
	+M8+HGt3IOntIb/tTF0JIpVXnFMNnwo6OVJOpeDoBX9uSlvONsghqrJhxgzNlkYDtQWSTQ
	y2TapkrUFkyGy0NUI4StJXZCCm5Iej8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MMV7TwLQ;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762979089; a=rsa-sha256;
	cv=none;
	b=xo9BLd0bDUioaCygH5Jh8nZhThoiMPB27fAJ/w/ORzcZAD+UBM+kGZ8nYtrkFT0M7/pLdg
	2H3bnRh7rBb9vlkEfQmzT7hAH+w7r+k3om2NfTuaGqzgPr7IbtJ2K9waQYycjl/Mv3/OS7
	TGXWDMjf7EDyawWEVzDvuJV4DabRt+I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 35CE4601BB;
	Wed, 12 Nov 2025 20:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F883C4CEF1;
	Wed, 12 Nov 2025 20:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762979087;
	bh=TW9NSBuZC0pCuqNjfj0PDRPjYM0/XDdyBFkYzlhTUz4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MMV7TwLQJIgxVHH9Jfnn46TzH8kkfNaH3YCBvwOtvaROgcrfmaOqvv1Qxyj2a9TSq
	 d59+NX27bhJounNl3b67AuiZlrcIpp9Pcs/XTM8FabyhC4qlmByxyR1JDVPmcsFkgf
	 8YB4+GRYweYr9seeG6OE4aQ5UMPKXUBln5Ehofag=
Date: Wed, 12 Nov 2025 12:24:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka
 <vbabka@suse.cz>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
 stable@vger.kernel.org,
 syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/mmap_lock: Reset maple state on lock_vma_under_rcu()
 retry
Message-Id: <20251112122446.e1f2c037550dc591a4d6b307@linux-foundation.org>
In-Reply-To: <aoq7jyue2qamctxmvtlic4nv53phskj6k7iizh7k6kwruwdgxk@qgjnaib7xgze>
References: <20251111215605.1721380-1-Liam.Howlett@oracle.com>
	<8219599b-941e-4ffd-875f-6548e217c16c@suse.cz>
	<CAJuCfpESKECudgqvm8CQ_whi761hWRPAhurR5efRVC4Hp2r8Qw@mail.gmail.com>
	<kfqzb2dfxubn6twcbiu3frihfkf6u34g2rcnui2m63rbc4x4kk@dh3bxvpzpnmp>
	<CAJuCfpEWMD-Z1j=nPYHcQW4F7E2Wka09KTXzGv7VE7oW1S8hcw@mail.gmail.com>
	<aoq7jyue2qamctxmvtlic4nv53phskj6k7iizh7k6kwruwdgxk@qgjnaib7xgze>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 212AC180002
X-Stat-Signature: ajgr3n7wwcy5j5hpwectcnpoyy5xygbg
X-Rspam-User: 
X-HE-Tag: 1762979088-962766
X-HE-Meta: U2FsdGVkX1/ottwhDfpW5k94tb9UQyINl6fJQYv6Lo1OUbbaRLwmCeinAtkymvCy0MrYP4McsrKP4AAa5Cd4AbqolEBcT98vlFxUrUSEpPFJzBAdGSylQsD5kTWePUy/D2Kk01xdTYYIRD6WYnT0fyS4mvqujI4PJH2RyYZDwRQwRCse90eIRHfhwhpnQ6PTIRfI84/B2t0FxDJAQcfTouw+jGL7XwbtwAqkRwvqQ0vuqTfLoySeFkvK6HSvUPdorpbzsWkXTXujpY1Qxq/a89R84oFKQ68jzjs+tp8VzjDOyOF2YF+taX2alo8/rjsosL1F4ODp4YNM2zovS8T4Z8WiiQdoj9d3R2PGJ9AlIc7Bnha+mrxVmeiLlh3xvgGIVrHPL4g+SV9TCDBwYJpgm32LLSi/NyZ1iYQApp8ia/eS6oT8nBhZj97ZX2bwUVHi+voz3O3ZfCqJwqItwombrPEuMi+tYrev19/J/TA2YhcxvW7HX0FdonoHKms07ua9rx90fgYcI7Bcc3Tmf5oNTAqONsNyQfK8nKsViqC4bhYnw9pdma+qhvNNBXp2O5e0IC1h4q5UkulBW/GnXINUEkuSW+JjlgYp1EET9jx1Qv+oZiLI/tLNy6URh4Qjg8BL9IHBs8Bul+uh7X2cH0K+8jcGiA67O0ZA3egnzrCbktOMaO13pGBKNky2fAw+aNlax59AjypVTVSfc66zJf9HsodxTnB33enIGp19VTawDAQj474ZhLuiSrBLzAYzVqEKOBkjPqG+Nh9XFCD3zSPDEpLTE4IptTOSzd86kLZjK0ZUBLl4QXyjK+r8TFLmCpeov7jZYNvoo12mRTYRm9JY5vi8yDmCclTXZGt5Pv5m7NrsYavz1bl6cbufMykaPI7ZtlqO7SYBY+acAMKoopwA/BdUrb0u2y3xbwuTUP7UOXHfUtcD/Vm1zUx4ChyQgjXbzHdC1cev7rFkRF/qWNC
 E5i/pM2I
 EYvDUGCbaAaTdY1oWtPvrJ6QruBd9g8K9cng126d0EZzMch2BnnW1yS4AP4LDbG2O83sxMjVYYtABzle7zyp2oo0B/+fR2FJMPS9K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Nov 2025 21:18:19 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> > Prior to commit 0b16f8bed19c ("mm: change vma_start_read() to drop RCU
> > lock on failure"), vma_start_read() would drop rcu read lock and
> > return NULL, so the retry would not have happened. However, now that
> > vma_start_read() drops rcu read lock on failure followed by a retry,
> > we may end up using a freed maple tree node cached in the maple state.
> 
> Yes, sounds good.
> 
> Andrew, can you make this change and also drop Cc stable tag?

Done.

> This needs to be a hot fix, as Vlastimil said earlier.

Yup.

