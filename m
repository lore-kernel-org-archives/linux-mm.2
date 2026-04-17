Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C9BAF8E498
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 00:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B1136B0088; Thu, 16 Apr 2026 20:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 560756B0089; Thu, 16 Apr 2026 20:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49DFD6B008A; Thu, 16 Apr 2026 20:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8BF6B0088
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 20:06:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0212C3167
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 00:06:36 +0000 (UTC)
X-FDA: 84666106392.09.AC4B1B8
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id D7B331C0010
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 00:06:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y6pQ4Y+B;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776384395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V8F1R4eVasWf3DAqLULgBfCtwL2rJDNgXQD8L8Jsnkg=;
	b=RUHzxNWDp6kvlkjA7tUa+2O2Vr8/6N7X5NqsKoQwcePsXY+D3dpWd7XUnp7GejPtm37gLn
	4iwDm7PeuNVtIQHzIikz3VoM36VBcOzHWyF9wa81hwjnguTa5JGXfoZtim7poahEm9ninV
	3QVcgxBWMNYrOozP+tqxCbL3FIN6Fik=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y6pQ4Y+B;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776384395; a=rsa-sha256;
	cv=none;
	b=AiclhR7FPippwT+tdhvZrwt+qR3evd9huSZDYJtDHkZY25D5IgzHSJP/UvLkCtFX7pM3Hv
	2isCVvptIRywxRc/PH05dZC54nDgOWYmIYld6eG1l5FSBrpkpLPBnCB6RQ0sd9evd7Rdzx
	4KNmMTbG0eh6L842/lcxfxpfo1C7LIs=
Date: Thu, 16 Apr 2026 17:06:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776384392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V8F1R4eVasWf3DAqLULgBfCtwL2rJDNgXQD8L8Jsnkg=;
	b=Y6pQ4Y+BYl5PmdPhBOheuK9aAmDqNs2BBZ6O8/WtFuKtXUx/Dile0YrKnglYhtN7TZVl1N
	Y7T4UoqyliTyAzsqJire5kndvVpMznvdL39EJrwlB8noOOCWrZwElEkso+W/rr6zq2EAHu
	NDU3jqvRNaLcmMK/1jBxXXDeLAR1oW4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Matthew Wilcox <willy@infradead.org>, lsf-pc@lists.linux-foundation.org
Subject: Re: [LSF/MM/BPF TOPIC] Filesystem inode reclaim
Message-ID: <aeF3UFzvTmapn2yh@linux.dev>
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
 <ad1QfUWEPSCDUDYv@linux.dev>
 <z6m4h2yamlckbyzh2ey2ixa7t7s6hlzg5jcle4qyebkopkvujw@pcrzrkuycg4g>
 <ad_Eo7iQVT-HUkx1@linux.dev>
 <i67kqas5wx2a25tzoleygwpeyunx6ovvf3t2e25yab3myxbazh@h7hctwxddhq4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <i67kqas5wx2a25tzoleygwpeyunx6ovvf3t2e25yab3myxbazh@h7hctwxddhq4>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 6c4ef6rcc4qf3ysdy6zpsy6nicdi6pj7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D7B331C0010
X-HE-Tag: 1776384394-144925
X-HE-Meta: U2FsdGVkX18g+aNZZXO5ee3RpJgNyR22kkeR504JCuKLUujwc1JG3Cq2sLaIiY2cDKoMvH4P/0PkzDVB5DKZz6UStXFZ8XWuybhz83mWCinIC0DuR/g6yYLakFS4WhAJyAJrElfYMl9nZKu2gnszFXAMilgHmDVcyWjX4LMLUueAVtVNEbW7qF+aG4uD+fKgcApeaMJl0NsGBkwGtn9A9NjsQC+scVadO+XntnXirFdlTJvOexP30CK5j0Oe1MKSNKYGzUuh8WOV5NapEkcL9UE/h9p3WvcgBw4amv49QwQQomkw3oo9YuDi+D0MppuxYnmtgpKUQFDwO8yhjnjNyNPvSx1JX1c4DOC/kq/HKGFpkAUVVfzZMKAUODciTAK7fbPgwRNkoRd1whvgL6ny6/1EYu+IYt0FaWDyIzoNHu9VDDXmgATRwedH8bqTqPqUWvcusKSNxkc3Ao/QPlflYGYswYpLA7ogNEmO+fKiOMRUsv5ZsrB+A5IzorDvbDPgqRDpx8mvLUa65uhApVNizn2Ywn0CkqkwR7TAdRr8XuuFiBglFFydMJXOcHHFYfvqvN1r7qwKr0ev+en5nVZFvEyrIucaM8B04AflCvFbh9CE8eCZR+N9teRbbVIA6vliLoyQ4I8egQzJJ5ojMWN5G13WIQhvalwLfJcHpVZxrVNqPI8RW/ZJ1Xv5n/hTB2rogv5H2E7uYJyhRthGdF912bO5JyF/cIuSIYMTDeZDhfdN2A7rT0gpXZLwc375VjGgRLIs89HFn4xzWT72YFr0y1EICG/B60o02WSgGtDLHWkvUIDsSdkIKp3j5TxxlKCj2tfPDbXNZO8Lmw5TKH1KBJANIpI9NC6PTr6VZam3jb4tIn0MwXKg8PHKgSSx6FTSglIQNWqkvhJJ2VXo4xib2qmIcnetOezJD/Bfye/2fM7y6mFwUpBlqaU1KkWs5OS2QTJNF+dwY0tEyMGE/59
 ID0mb39F
 +0ktzu0qWO6YzRBg/wm7LayvMc7L4vaLqM+2PJNNB7IUyLu1FM5b/frH8PN6OUOjXhbSy4y7jfGSJl5sPjfZ3vP7zJvuz4wi3TtbmDsQ3JHdzjodKJTgyZ52OcVKqenWWx8/gTGWX0XIIUFxnAAsTn4Xm86kTR2zdgv+zyYfbkvCUV7iy1nTr5i9X3KhOo7YAPytGrTNKPov4zfY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 12:06:59PM +0200, Jan Kara wrote:
> On Wed 15-04-26 10:45:11, Shakeel Butt wrote:
> > On Tue, Apr 14, 2026 at 11:15:48AM +0200, Jan Kara wrote:

[...]

> > One more question, I assume it is fs-dependent but is it possible to avoid
> > allocations (and thus reclaim) under fs-wide locks? One challenge/issue we at
> > Meta are seeing is (btrfs) lock holders getting stuck in reclaim causing
> > isolation issues.
> 
> I don't think it is practically feasible. Often before you acquire locks
> and start working, you don't know how much memory you'll need. For simple
> operations you can go with worst case estimates and preallocation before
> acquiring locks (like we do e.g. with radix tree manipulations) but for
> complex mutations of data structures involving journalling etc. it isn't
> really practical anymore - too much code to execute, too many possibilities
> to consider, too many interactions with other parts of the system.

Thanks for the explanation and yes I am on the same page that moving memory
allocations out of lock scope is not practical. (I am working on an idea to avoid
(specific) lock holders to not get stuck in reclaim but it is orthogonal to your
topic, so, don't want to divert the discussion. I will add more info in Boris's
proposal)

