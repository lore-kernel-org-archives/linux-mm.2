Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C0C3C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D74646B008C; Mon, 14 Sep 2026 23:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D499B6B0099; Mon, 14 Sep 2026 23:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87656B009B; Mon, 14 Sep 2026 23:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A77966B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:35:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D6FB120310
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:35:37 +0000 (UTC)
X-FDA: 85214581914.04.49F7CB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 622F9180004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:35:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V1RQ4BBB;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789443335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vycjVsdvdL/Q00jPIQ1cuSnd7h6q2v9Vl0G0+pf20mU=;
	b=8aMcGbOjaMujtzpCtuVF5mfbsLfp9PHFg7gqtXbtie/VdhgJarsqu6qLG03AcguTtbDXsD
	hMJtVxiuLsxjqIaSoZsc+X65l9q6aA96tDA+s7jP298CivV3M9t1whO+LcaDs9Z1ha+w0A
	KU9rSL74tJ76HiOnk72BKlmMphj0Ofs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789443335;
	b=rbfChzIfZWC9vPdnZtZ3d0tVkedPOkuLuTRQ6qSaJAxjua3wFIohL3pFz0+jhjj+GrRcJg
	8h+w+/QNyQEOeS0+VohUpw+J1UT8skYB7IYONdV91QJWqGSWjVUH4rbJyqUoi2g68gpYqq
	yFpWuAa/fIrBALsVkv6hClV4YubhgEI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V1RQ4BBB;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 91969435E1;
	Tue, 15 Sep 2026 03:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD421F000FF;
	Tue, 15 Sep 2026 03:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789443334;
	bh=vycjVsdvdL/Q00jPIQ1cuSnd7h6q2v9Vl0G0+pf20mU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=V1RQ4BBB5iWxnvLsGmQ6REaJ5XmLOM//fRNynr/+jY9esATY0P6Tv5Kb/aLVsGn+g
	 rHa5DFQqWPXhlDvVXN1pwIZUdw5jHYYC8KDtauL1OaSKrc/as/F6otmcR5VbxXDMvD
	 +t+gpofGq6ijGYfKvzOhVyxDPb6CImZdfhtNZNv8=
Date: Mon, 14 Sep 2026 20:35:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, linux-mm@kvack.org, Jiayuan Chen
 <jiayuan.chen@shopee.com>, Zhou Yingfu <yingfu.zhou@shopee.com>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, David Rientjes <rientjes@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/oom_kill: fix hung tasks queued on mmap_lock behind
 a long reap
Message-Id: <20260914203533.3544ae8dd0903c7603b385c6@linux-foundation.org>
In-Reply-To: <aqg-oG2HDIUeK5Us@tiehlicka>
References: <20260914113239.367200-1-jiayuan.chen@linux.dev>
	<aqg-oG2HDIUeK5Us@tiehlicka>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 622F9180004
X-Stat-Signature: oskns43y9t1k9xd949f6achmeo6zkit3
X-HE-Tag: 1789443335-723945
X-HE-Meta: U2FsdGVkX1/o8kdQN6sYkxJEEz/Jp2tY3HOaFfOEBocuc37HmL7A5H+judMoXw/PnMp8MGeBrsTN/mZr4uCNIzUXlBKBWHS3gLZ7q0nxc15fMZAA05lLx8dgbwDJ1XenId9ZaXjyLD5JsR6Py/AHjN1svf5oBwJYo33Xd/WqGbds0XUxHB0DzSC3p+/kdkQyl6RhKlDSHjJW96GA5RM7zPqt69N/8jFHBHaMnIj8nCQV5c3UuIXaZf8wgNT8VMFYCMUz1RN5Pi2KfM3C4ChceAlCqB5rycgBamcq3CF3cgmSIBJu4c1F2beqmrQUlElUrWhlFa40ZkzTPg917JO4MQ4Egpbxtu6f9UG5yWaZ797dkPPHLn7XM7wYTXlgS2A37XFg0VDDg7KTBvpt+l//HmrPyLt2MmI0aAgtlJQmEPjXvYg/pqMFjaj1p60Nxapn41XTXJPEwxn7ITi9jeaMddCYEPfxcghVY8Ts+KRF7Hj/aXZgaSrpMNoh+AW356/Zu6e3ztxBB196F+HXdNi9JVXSX6JGwdZ/jBtrTRV9aZxdZuMjkf6O9iyNbRBPjR5jQgUNiiYIIaJdpGnADnIqTuW7aEbU4oA3MTFtl5LdIeD6pRWdA6Kn4RrI/AbPLj2gxZSNUffz+EPJtOUzmF40db8+h1pvuH5hUp3tjW4cCpXVZEFDk4qw6a4zV48ZUMxaGM8Lh02tQmxWTkCrceIbXmsf9G43a7aRoP3eA5GiCEyVUteAoEZzqQosPripU1q6i+fJvfdMTErGoynN2vBoFU1LuGIgaABSB9D6HMFUI55AR1FkjsWMjthGuD/RGFR8k70JWz8vRLsmDHL6qbFMBAmNE4tRroxDOBmMiUxD+9IvFDpZ3uMzH9Tt5PAuppjn0LG7vyEInEdpDTvcsDhwykr6/l5HoF1E3z1Y67lT0mOxS6HEoXWy6SfF6fcKEgTqszckJAjKBLJngoiMFmi
 FEXzYZOX
 8V8Co+M2Bm1X3OZJ8m23noZMpxrALZSTUSFQC5X+fz0IwNO31HJsi+3pX9K89hYBB9Lt5bRRQB+KCMp20jBa+lRSq/r7JgLldQ+RT/6Mb0gvJM9B2EmqC4mVTmEX88TwdgrMv/jZLcq5X3nVQL4zjmkS/tfaRbsIcu5OerL72eAKsy0UpljAaByX39U4zwfiilL3uRMpqqJefjUYRcb2GD50NaLzfwX/+ynMz7DBNHZYshm2vNTwKHmpXUbIEGEPTWPSGNO1MJf8Qq/kks8KnUBH+yAAa0GDIFdONEh1fZWfPqhEnznDGgQwIq/wGiOZ7lSjA7Umjv+msnGWnwdH5DFWunajeL5feiLdoY92TKf7mps0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 20:36:16 +0200 Michal Hocko <mhocko@suse.com> wrote:

> > Call Trace:
> >  <TASK>
> >  __schedule+0x487/0x1870
> >  schedule+0x28/0xb0
> >  schedule_preempt_disabled+0x16/0x30
> >  rwsem_down_write_slowpath+0x1d4/0x750
> >  down_write+0x60/0x70
> >  __ksm_exit+0xb4/0x230
> >  __mmput+0x12c/0x150
> >  mmput+0x1e/0x30
> >  do_exit+0x283/0xa30
> >  do_group_exit+0x34/0x90
> >  get_signal+0x952/0x960
> >  arch_do_signal_or_restart+0x41/0x250
> >  exit_to_user_mode_loop+0xd3/0x560
> >  do_syscall_64+0x385/0x470
> >  </TASK>
> > 
> > KSM is just the one LTP happened to hit: __khugepaged_exit() has the
> > same write lock cycle ahead of exit_mmap().
> 
> Why is this a practical problem we need to care about? It is kind of
> natural that the oom victim exit path might race with the oom reaper. They
> share the same lock that is mutualy exclusive. The whole point of the
> reaper is to ensure there is a forward progress achieved. So before we
> start modifying this let's talk about any practical/real life problems.

If this situation is expected, unavoidable etc then perhaps the best
change is to periodically poke the hung-task detector?

