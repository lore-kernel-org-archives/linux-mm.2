Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CE74F3D331
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 16:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1C976B0089; Thu,  5 Mar 2026 11:52:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9FEC6B008C; Thu,  5 Mar 2026 11:52:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E566B0092; Thu,  5 Mar 2026 11:52:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B90266B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:52:16 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 707201C19C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:52:16 +0000 (UTC)
X-FDA: 84512602272.26.CB9F145
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id C7BEB120013
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:52:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772729534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Elu10pjRX/n/ntoklfXyDLgSHc0UZUnQNgGQmmBty80=;
	b=SzL6ja+MhSzKZqz+b/3R5AXB1i6xAAnJ8+TzJ5Dv7R5m1jXhvn1DQS+iEnbIfgL3k+pLEb
	J3n7Ezpttec2taX/Kfzq80FN+WxYogPzRpA5zfqxXW4KEg295TVC/1qqArl6CXIVuqxvLv
	Ee15E0egEtKDPBHguTuiKM25XOur87w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772729534; a=rsa-sha256;
	cv=none;
	b=wopuVCE7J2+PYHzB3r6YbfbRnI8BM7dGp6TJUZoxdK2IH8Jj7Krn22WQ1+Aeq+EDEz5gRh
	MyuMcHFc3m3sQ9VAAgei8psVWZPN4vexdh5iAu5jjrbrQjfKwhBttNtKKaK81OLROatYLB
	fCk1k3Jjo30+L0cs0q6V50kB5aynlaQ=
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D199C0D6B;
	Thu,  5 Mar 2026 16:52:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id D550C2F;
	Thu,  5 Mar 2026 16:52:09 +0000 (UTC)
Date: Thu, 5 Mar 2026 11:52:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Huiwen He
 <hehuiwen@kylinos.cn>, Jerome Marchand <jmarchan@redhat.com>, Qing Wang
 <wangqing7171@gmail.com>, Shengming Hu <hu.shengming@zte.com.cn>, Linux-MM
 <linux-mm@kvack.org>, linux-rdma <linux-rdma@vger.kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [GIT PULL] tracing: Fixes for 7.0
Message-ID: <20260305115248.4d972cc7@gandalf.local.home>
In-Reply-To: <CAHk-=wggaToeRYv6B5L9ob=wBdVW9_gFudYxH_WJDTuhyX_Ueg@mail.gmail.com>
References: <20260305103941.11f1b27d@gandalf.local.home>
	<CAHk-=wggaToeRYv6B5L9ob=wBdVW9_gFudYxH_WJDTuhyX_Ueg@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19DxIVoLQN9GFaheguLVMQZrUVvPMJITzc=
X-HE-Meta: U2FsdGVkX18MbU/JoVVgZNbLoBDmliBGM31YSsjELhjzdBmBN42BiwmaKnYsUaYYjXlryTqwysB16K2eNG0YW+TNHoJBc9Ie/8JCb48qtN69ykGy7jHH5/0pB+yAcEq3PAhQbiv1f2pmgoRFgq5c/6sn1DvNhWVdRTmIL2gd7BbzcVhRDgYjbIghpfKgXw1RqkrfZIfw2bbazYVIq1EI5+7CxgRobihk5en2I2Lp76u+FFVk5u1uR5AG/H2uochhxQ/yE5aPJodeGu6lfPM5DjmZ2qxZTdxHQvnYYGLE/FkuQmMPr6GwoertxbHDuJ5oCqpgQs4/FI5CnLqqZbZ6n5IATw5TBP7Pj0Y2GehtUO2+hcOZF/qIPVIhb7J+zOyvCWxyHfX8PIMssaocfTxepEAEZufPlF8UVe8AjDfg2ZSZcUuK+r0tRI5yczwDDtxLi+RmaXVXMx5s0//FHwjtQA==
X-Rspamd-Queue-Id: C7BEB120013
X-Rspamd-Server: rspam07
X-Stat-Signature: 916ur3gh9jpexos1z3hb4os1bqqobcq5
X-Rspam-User: 
X-HE-Tag-Orig: 1772729529-584749
X-HE-Tag: 1772729534-171373
X-HE-Meta: U2FsdGVkX19L2cM+LFRS3W1Kfdg7eDtM2fCEYCR+8jx+yOaxBFaY3Nz2FeYHbWw1uNbipqevuIXjAk/Q47yc7qHCwbZh13mVNvaJ2+SapkcuWHMAw8fMt49LjocUkrmkDoDNyTiDFrfs1buZ3tiOUlUa9ynFHN5qbb9hBxtrvZGHo3b3otYPyZSa264S9YEb9J08u75MLbKuSCjF49LpolUwTbpZlMG8kkrtNO30/KFTaZNiNqAKsvqjdtwp7YJmtFiVdsZBj0hpp54tsfiV+8LvtFgS7F88meluD0a9ypv7fScEW/fg5LINuowovKKFitVuAthUhT8AVkKyPSD5Kg5srU4cvdl3N5KwBJoF2ewrBhUBwY2ll4BC9m/K8U4u9hFYz2I/4sSIN+hKOf/FRdaMOHFnecCijjeJRfpZSFhWhgT7jkDxEVxtdU97wcPG5DMRR83H4APkGFx7a7eboqbyRf4//gUd5Id77MzO6F7iDINs20QaTkCpQywZ/ws8lU4lHaWvYOGKXvuuLmeTHigDP9p/AL/GcU6mJNBzTs8g1pDDAC18eieXcaS+kuEm8r7w7NbkbYf1cnVeDmZMwmkWZ1Vi40VVsRdCeQ9X8kxZWGjr7Hex/4d1I1Chn//47D/4fU9/x92OQpdlq2w2IcQSbJC/02XnQlNCjib6Hdo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 5 Mar 2026 08:44:27 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> [ Adding linux-mm and the rdma people ]
> 
> On Thu, 5 Mar 2026 at 07:39, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > - Fix accounting of the memory mapped ring buffer on fork
> >
> >   Memory mapping the ftrace ring buffer sets the vm_flags to DONTCOPY. But
> >   this does not prevent the application from calling madvise(MADVISE_DOFORK).  
> 
> I wonder how many other things have this assumption.
> 
> Now, many (most?) of the VM_DONTCOPY users set VM_IO too, because the
> most common reason they don't want to be copied is that it's a special
> mapping.
> 
> And then madvise() does nothing.
> 
> But I also get the feeling that the whole *reason* for MADV_DOFORK
> existing in the first place simply doesn't exist any more.
> 
> It was added two decades ago when as a hack for the rdma people who
> wanted to mix fork (with COW) and concurrent DMA, which just didn't
> work reliably because the COW would break either way.
> 
> See commit f822566165dd ("[PATCH] madvise MADV_DONTFORK/MADV_DOFORK").
> 
> And that should just not be an issue any more thanks to how it's now
> done with page pinning rather than with the old GUP interfaces.
> 
> So while I've pulled the tracing fix, I get the feeling that people
> should at least think about just making MADV_{DO,DONT}FORK go away.
> 
> Now, Debian code search does show some users (libfabric, libibverbs),
> and maybe they actually want the forking behavior for other reasons
> too.
> 
> But I get the feeling that maybe we should at least limit MADV_DOFORK
> only to the case where the *source* of the DONTFORK was the user, not
> some kernel mapping.

Right, I was a bit confused when I saw this too. I asked the memory folks
about adding the VM_IO, and Lorenzo suggested against it. You can read the
discussion here:

   https://lore.kernel.org/all/e4deff21-2fb5-4f37-a7d3-ede5f69a4489@lucifer.local/

-- Steve

