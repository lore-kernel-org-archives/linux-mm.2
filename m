Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A017D109C058
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 19:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D33676B0005; Wed, 25 Mar 2026 15:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4A86B0089; Wed, 25 Mar 2026 15:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFA686B008A; Wed, 25 Mar 2026 15:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B02866B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:15:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4CCA51B8B23
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:15:50 +0000 (UTC)
X-FDA: 84585540060.14.0A3B5FB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id D0DFF40012
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:15:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PXjNBZR7;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774466148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Ws0zxo76Oq8skurR4/Ct4jTfvOy+YmWkHbAMtBNRQw=;
	b=N+vjRwK0fCf4OgAKiLQpkgG5uulYiyYAtp3wrt64c65d0UXpN4btl51HjRi/RxJpZ5QEJd
	vtjz2fgGlYvQSNygorcLBoOapE1EHQoAqN/oKYOwnD8rukgJY+FamtRRhoLRz5d5jiKbP2
	Q5SW8aODOfjiSTVBOTe6xkrLvyJ7qjY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PXjNBZR7;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774466148; a=rsa-sha256;
	cv=none;
	b=zu1bq2V96xvXa5eUzdcR1aeSgFbFHQWr9mp1kujUogh8Q2l6mxXKc/LVsSip7GEyCKz+bv
	9Fflu5w4vx+kYHZm3YCxBxkuWtdwrP5iKJ14vW5R+v8P+rCJnjzACUqWYoQTbQqVLij75O
	ecbeRcUEwhQjUrip4PpK+/y7nloCVxQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4Ws0zxo76Oq8skurR4/Ct4jTfvOy+YmWkHbAMtBNRQw=; b=PXjNBZR7aTHA6Hz9FBJJqjN7Db
	wIRsfz3JuwEYANUB9AaDi11hn6nh6/M8Yt1u2lh7xZ74+k10CalBjr8MrK+Nrwx21n4+aIKk2lPhW
	ftJeYNMO2w0SOI46yedcw1nWwUzdRM7VeeL1Q4JkPGsR8iX3lFOynw+O8RZB1eESxJPw/e0kSAQ5O
	B2aZiC14kT+lKYFCczKzfaugpqeSu3M88yANRuxYn6kzyfKCynn3AJ6nAs+i7GXfgOEixHdNBEAd3
	+szXGpZFnv0gnrSxgaDNNjBGPuo9f3lOBbVoxNyvchKNAJNbxK3Bp2Oq/e0zo5Ry9iBIkvy4osERr
	wmEZlTjg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5Thh-0000000GQBU-13Lr;
	Wed, 25 Mar 2026 19:15:45 +0000
Date: Wed, 25 Mar 2026 19:15:45 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Rushil Patel <rushil.patel@gsacapital.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>
Subject: Re: [RFC PATCH 0/1] mm/filemap: make writeback wait killable in
 __filemap_fdatawait_range()
Message-ID: <acQ0YRLM_SxYfjfI@casper.infradead.org>
References: <20260325113616.785496-1-rushil.patel@gsacapital.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325113616.785496-1-rushil.patel@gsacapital.com>
X-Rspamd-Queue-Id: D0DFF40012
X-Stat-Signature: 8iybbj1bcw1kna43prscgx6cu9xxfgu6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774466147-260932
X-HE-Meta: U2FsdGVkX1+YlDcXxslrzk1xoQue7Z4rEv7FgSJXlJcxbSSVcTc0/ytjo6OEsIsHfF+pD+3oqGNRzl3HzAtSZJ2u+B2DYvp9TTrZCaer/cOuaYq5mEb1ymzXs/51uaes6H+cFX0XiJ2ejDmcxl5a0k2l64FqSDgbJE0vLMUFjLlmuaYcoBC64jPtY/1z8wRZAyVDUrTRUJPMxWE1KNfO3vqlZ8iaegrPU9UOAzEa3ZAEmRQQvFJSFEXYjcy97fzKzLsxXQaV1NeBxkrIeSBp4GvwFbLINKE757XuRH5PJD5Wj2gvtpXVt1tGyNaXF1sG45AY8WuSn7J7v1tTLLWKZ9vtjEqeX7PuC06Zgbl0SE6H0KhrW3zu84iCZYYG1vqICBWeZhxKL/KtQdseVeZLbuAjScMA1J6Opnxko9rgvTv60kzAKMEl4Uoq7FAgHerjWwqM8BZTSNOale0NiXOeuxpBCf12XWIUe7lSK9NUtBAbE0RHtv2qZKoXydS9feI77+ZlZNMnnW6Rd/ac9c44ygAoYzXLGiIDwXLOJzGss2dILT79MV9DgtdYs3a4M8Y1mjFqf30/KhGRXrEAO+IDEWSNuneMLkfQvGR+q9qmD12H8PVsyu0eYxJUIZ1mPei6v3TAO8VN0PzNfQNMsKWjHkMZBzgC7YjQJad2oKhJjs4Qfku+G6FCtiYJqiFaCZBUdhmMoS+Fvh9bivTaJQVDtGmJ0THDT0oKJoFlMWbUtOoWdBGvxVWy0gXrNJO/Gumz6XGCoJGWgIW1Ltt5q+bwpsN3NEFGa9LuE3X9aC550lxQsUzYiGcQCLA907/7pBS3idNcXV0qgCXW0ifUy/rPGJlcT+5r/7x7NgyxdsIGptARfSVDupDGIc0756PziDmlpymtE4BfnaA/GNBX5AXJXr9Z6VocqMvd4KoBwgUo2aQvwoVpZM3BExP5xNtK8SHJWbBmcCbN1ABnXf8ZlOm
 Ww+yIgaD
 TWoN+NkYcznlkkSnnULw472gpAnOOgrWgKudFnQKDbe7LbA6GmUEq2BBSZ45nGi4wgBSvBNNZx46cJ8e4PdY3EutwLGRKG31B6Ezx4Yrng+/oyMys+B910y6wBa5c8UugYi37d9HyxXpcZp54nCoo9PlGGQWvMdXI/BQLHEqEYTy29us0ftDZq4AacZ5OuHqlcrkry6m6XGD6oWuZ977Azbixpq56XWFNdUpcYja0FMtRcwHVe8WRaUtdjBow2u+lhlVfQ/1MqFvFUgbgi3uS6NAbPbk7oE1IDpPuTKVd1QeFofQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 11:36:15AM +0000, Rushil Patel wrote:
> We run Slurm on compute nodes with NFS mounts (NFSv4.1, NetApp).
> When a job is cancelled, processes with dirty NFS pages get stuck
> in D-state inside folio_wait_bit_common() because
> __filemap_fdatawait_range() uses folio_wait_writeback(), which is
> TASK_UNINTERRUPTIBLE. If the filer is slow to respond these processes are
> unkillable - we've found the only recovery in practice is rebooting
> the node.

Hi Rushil.  Thanks for the patch!  I have a lot of sympathy for the
problem you're trying to solve.  It was something similar which led
to me introducing the TASK_KILLABLE infrastructure back in 2007.
My problem was read-only though, and while I had an initial attempt
to also handle write workloads, it didn't work and I didn't have a
personal need for it, so I abandoned it.  Now you have a real need, so
let's make it work.

> The patch switches to folio_wait_writeback_killable() so SIGKILL can
> interrupt the wait. Writeback itself continues on the server, we just stop
> waiting for the ack. All 6 callers of __filemap_fdatawait_range() detect
> errors independently via errseq_t / filemap_check_errors(), so the early
> return doesn't suppress error reporting.

Well ... I'm not entirely sure it doesn't suppress error reporting.
But I think I see what you're trying to say, and I think the change
of behaviour is one that was never guaranteed anyway.

> The tricky part is a re-entry through do_exit(). Making the wait killable
> alone isn't enough - we hit this in testing:
> 
>   1. SIGKILL wakes the killable wait, signal is consumed by get_signal()
>   2. do_exit() -> exit_signals() sets PF_EXITING
>   3. do_exit() -> exit_files() -> nfs4_file_flush() -> nfs_wb_all()
>      re-enters __filemap_fdatawait_range()
>   4. wants_signal() checks PF_EXITING *before* the SIGKILL special case
>      (kernel/signal.c:951 vs 954), so it returns false
>   5. No signal can wake the second wait -> stuck in D-state again

Yes, this was where I got stuck too!

> The PF_EXITING check at the top of the function avoids re-entering the
> wait entirely. This is the same pattern used in mm/oom_kill.c,
> mm/memcontrol.c, block/blk-ioc.c, and io_uring/.

I'm not entirely comfortable with the location of the check.  I feel
that __filemap_fdatawait_range() is a bit too low level for a check
of PF_EXITING.  I could see there being other places
which really do want to wait, even in the presence of an exiting task.
Maybe I'm being overly paranoid there, but I would suppress the call
from nfs_wb_all().  Maybe something like this?

-	ret = filemap_write_and_wait(inode->i_mapping);
+	if (current->flags & PF_EXITING)
+		ret = filemap_fdatawrite(inode->i_mapping);
+	else
+		ret = filemap_write_and_wait(inode->i_mapping);

What held me up from doing this though was the next part of
nfs_wb_all():

        ret = nfs_commit_inode(inode, FLUSH_SYNC);

I didn't trace through exactly what this would do, but I inferred from
the FLUSH_SYNC that it would also wait for the file server to finish
the write of the inode ...

> Reproduced with iptables DROP on port 2049, confirmed the killable-only
> revision gets stuck on re-entry, and the PF_EXITING + killable revision
> kills cleanly.

... but if your testing shows that it works, I must be mistaken about
that.

> Sending as RFC because this touches the generic writeback sync path in
> mm/filemap.c rather than being NFS-specific. NFS can't really fix this on
> its own - it reaches __filemap_fdatawait_range() through
> filemap_write_and_wait() and doesn't own the wait. But I wanted to get
> guidance on whether this is the right place for the fix, or if you'd prefer
> a different approach.

Appreciate your flexibillity on this ... sounds like you considered
doing it this way, but didn't know about filemap_fdatawrite()?

Anyway, adding the NFS people for their opinions.  Other filesystems
don't do this flush-on-close behaviour (for various reasons, but
basically NFS has a close-to-open consistency model).  I believe
we can break this guarantee in this case as it's not an orderly close
but an involuntary termination of the process.

