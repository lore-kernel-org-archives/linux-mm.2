Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F065C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 22:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 131B26B0092; Mon, 31 Aug 2026 18:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093A76B0095; Mon, 31 Aug 2026 18:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E76566B0096; Mon, 31 Aug 2026 18:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C131E6B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 18:13:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 433FFC029C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:13:55 +0000 (UTC)
X-FDA: 85162968030.27.522E1C0
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id 15CAD40003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:13:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=36q+etKU;
	spf=pass (imf12.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788214433;
	b=hYckF0T8CDoXCzsX1gQ7Es2w/bN5bg8g1kR1o+PbXJ1bs7cZ1gkaRif2zR/Ak38ccQ5tK/
	Z7kLir3hzgt3qeZoa/3XAaNKzmswUIP63A/iIFvwuMBjfA5berLaq5TVbBiGUbiPgZxWLG
	wy9UwDRqlIEU3/11D2n1E7N8C/16ZE4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=36q+etKU;
	spf=pass (imf12.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788214433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VOlevrFdEXRUzbmZojs2dVjkkSXh++UDxDK4wG8MPBY=;
	b=Kr9Nm9VNXbpbuleMDyAXuTA+miBHffdxvuv6LbQGzcrGdZOxM8t0k4AU++1u7BofZgxZxw
	KfYOfqP11bLBdsEHUXyzNErLOuZIA1ZoioJ9oTM0Ub7KhdgClzngCvn1KYDq8eFu/XTVcd
	UCkTRURkcgfX84U27pg7vri1nEO/5aE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VOlevrFdEXRUzbmZojs2dVjkkSXh++UDxDK4wG8MPBY=; b=36q+etKUhagPNuiwzgaG5YP4/U
	bxJkAJXydme5CsT5PwvoX7Bdgj1xQ8qSC70UnI0yjYTNIRg2DPG9pn99BN3rMtpmvMUv+2iQMleLX
	lpOE9CwUGFnqhTb2WOZwREc5okZLIrQdmxnVmIwLyh1p02f4Ixl5TRWehOAPqfW3mkSvISnWTBXIv
	7VXDoz+3IrM7n+y+xCwaPQC31ZiJFkYO9I3GLwwosCLuC03ye8GSMaPh62lNnu+TTE/7Ki0SFglk5
	cwDi75BBIkmba3o49OvpdHv9u6AGw39/WJGbP1Ag68rxZqzpgXKM07dlE31GIf4pd91ArG5akXHMG
	pzawV2aA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1AGC-0000000AaEI-0blG;
	Mon, 31 Aug 2026 22:13:48 +0000
Date: Mon, 31 Aug 2026 18:13:45 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@kernel.org>, akpm@linux-foundation.org, ljs@kernel.org, 
	jannh@google.com, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RCU safety for vma maple tree walks
Message-ID: <bft5zaxtu4sqbixj2zuxnjcdjy4we2522w4qxxhqypdvy4lot6@lcwehbvsh3wd>
References: <20260831143511.1133029-1-ak@kernel.org>
 <nq4g527ozizmp2iqmozau7xwgdq4cny43onciw2mw7vu4bwabg@uzkdpjchygkn>
 <apWxTNwhaMU3XiZP@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apWxTNwhaMU3XiZP@firstfloor.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 15CAD40003
X-Stat-Signature: 33dfrt44mayk9nzgp5q98kn16itahey5
X-Rspam-User: 
X-HE-Tag: 1788214431-219029
X-HE-Meta: U2FsdGVkX19Tpji7nxrKD2jSneTXk6m5Zh7V7sBoozCaMNPQuWz/VpQ1izpsjjJSY6ITS/2lN+c3jQV3CNep6uN7TFxAfYzzeo6vaSogI7KzrjK1g/hgZsbvxZWzVEZTuslYqL5XDUF5WayV2lEu5F6vf/t0rv8Btr40BDDtrzjoAxn/SA/QlCDmZ9hpZRQzsm2XRqZUV8AGReLNbvzNidwEW26nFOMcs2/n34xrNvAA+56xEUya2SiukzhbPqPD2PEhgdepjQmWXpTVn6pE2Nx1qrverEZTVQL/ePRGoJCj/foxI72VEL80bLFuWevStLE9LXIh5OJk8wMEMANsDis1f6NvUD/ibFjqke2hx6IrF8HYUxIqI9MBExJlKOaPQQxNXu/GuKG6bm4x0w0BLZvFseg8BEXl2pe7hr5xzsBjMyPXYYsItlYEFULDDsHeNU5opm4HWL7AJ8GW02N9hCr8EvFa4Y2uSiz5Ir+HcYB7ycxn1CxSw9/TNkcGeh6MnAOZMI640BuCy7hwzIuH39r4bNs3jcE5tCe3W8cx2N+CKxx5Fzi4K7X8aNaHkdugeggXooGglgDMnomd2fQ3tK/J70IQeTai8d+4a4L9ySN0Uaa0Hgz2XRrW3UT9rEDONa4mGBjyk+TcXUwh06rQFWIeF9e/45ZsG/YV1AyoxF5dNvGMnSsSzqhGEeBO1N0l7XZvv3oKxYloKoz3di0V9hKW/yhuIHtUE04f3HDkjql6iy5GKdlZ24zKNLDfW5Gy6PIG0AVedZuIrNY3I/SN8vi6lzb200Orz1Z0cLLJXAsBim+btBj+y1th6FzuIa591Jm5VR+frXbpKAbqAxu5RkltyF0RNk+pZQpclfaYUhlJGraFV8If/SldVLMhmMY72WZyn16cU4VMeUNZhxCyyMgMLlhbKj/C4Ipk9JRi7NiwbEnayIw8IPiexNjDO4Ut8nFe3oIVA1oTbmNcghZ
 39TvOZDj
 GSNqLhcx7etzniOIHx3YkB0XHFueAg8IfwDX/IVjhUcWbj/cuFcnWGWmqWbjKq7dZVZKfWarwpuSpeS6sp//ZU+zRyHTqMz3pxuHqEyluT1y1NLPgC+uWwM4IMwQkEVNqWZdOP2HyK8ofZF5VScI4QU8Xse5qEaUtSvlsI5aLrS+gJoLYtZmyh1Glhbe5EoAT60E846xwdFa96VNwWDOKsXUfCQ+bjPMxwuOQs53TrqQRwci9FQ9VaEw+1Z2l9YL13W0EIru0T614fYKoMB38j34krA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/08/31 09:52AM, Andi Kleen wrote:
> > 
> > Did you check this with lockdep?
> 
> Yes all tests were running with lockdep, and it didn't trigger.
> 
> > 
> > Any access to the maple tree without holding the write lock or the rcu
> > read lock will cause lockdep to complain.
> 
> Hmm, seems that's not working for some reason?
> 
> The VM callers of for_each_vma clearly don't take rcu read locks.

I can't say why it's not triggering for you, but I can tell you that
lockdep detects incorrect locking for me and others using the maple
tree.

You even pointed to a syzbot example of a report of an rcu locking issue
- which is resolved.  No unresolved issues by syzbot (which has lockdep
 working..) has been reported in any of the functions you have patched.

It is okay to not hold the rcu lock if you hold the write lock.

> 
> > 
> > Likewise, any sleeping while holding the rcu read lock would produce
> > warnings.
> 
> Right but the walkers don't use the read lock.

Every walker either holds the read or the write lock, please recheck the
code.

> > Note that you do not need to hold the rcu read lock on the vma maple
> > tree if you have the write lock.  This looks to be the case for most (or
> > all?) of the cases you have below.
> 
> Yes the write lock is hold (like I discussed).  The problem isn't parallel
> modification but that splitting during the walk invalidates the
> iterator caching if you sleep too. That's all purely on the local
> thread. The only contribution from others is to cause more sleeping
> due to memory pressure or rescheduling.

I'm going to state some things that will hopefully help us understand
our disconnect.

Parallel modifications are not possible.

Splits are writes.

Writes update the maple state.

Sleeping with the write lock means nothing writes.

Writers replace the nodes in the tree before marking old nodes as dead.

Writers mark the nodes dead before they are added to the rcu free list.

Writers return pointing to the new node, not the dead node.

Readers cannot sleep.

Readers that see a dead node restart the walk from the top of the tree
into a new node that is not dead.

Nodes cannot be freed until all readers which could have had a reference
have dropped the rcu read lock.

I am very confident you are doing something wrong in the code that is
not upstream.  If you have a reproducer with the upstream kernel, then I
can help you.

Thanks,
Liam


