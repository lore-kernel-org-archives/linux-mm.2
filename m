Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59B4DCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 21:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3A146B0005; Thu, 28 May 2026 17:09:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EAE46B0088; Thu, 28 May 2026 17:09:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9273A6B008A; Thu, 28 May 2026 17:09:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E60C6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:09:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 208421C086E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:09:46 +0000 (UTC)
X-FDA: 84818070372.26.324066F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 70F3EC000C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:09:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QdVKGUMq;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780002584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ttjnkg846TiOVQr/VBhwCx0vrR70Kt1d8MiwRlUR7wY=;
	b=h7DE1Hjwr6aQJUxuCvWx2/5Np2VjB1x3du7/lRESpM/QCY2knNZcUdDrRhsPSlJWbXld0R
	PmQfHbidAlfFW7UKKonISvZbOQoQTfTSNUKDmoNsPQp/YbVv/bd68F0zXH1bGMN4yWz9x4
	K2PWNpXHjpT4xeeirHxwS+X9faCcHBQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QdVKGUMq;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780002584; a=rsa-sha256;
	cv=none;
	b=ec2RhoxZv61eEtREZwyN5YWP61siuASyTVQI5P1zzcuzyYTMWgQfup+vBldu4qaQSiJxZI
	pP6j5su3IVo1MyIa9IJ2KEL0hZC77lgJTV6QYmC/g934yEGpRylGqCX7a5HqENf+eeI9pV
	wF1W3ck/IdR/KFZQUHDxOkigILe0Vvk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE19F6020A;
	Thu, 28 May 2026 21:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E00A1F000E9;
	Thu, 28 May 2026 21:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780002583;
	bh=ttjnkg846TiOVQr/VBhwCx0vrR70Kt1d8MiwRlUR7wY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QdVKGUMqHsnanE2JOFLtHGkjdR91mWePXCqK2pDbgCxlpstZzRHYENHkhHEpk4oDn
	 47EIDjyV24mdhXCvfS3nIvxYaKltabtAscC/O4DpYdaLUQ/2hp5EovwTE5mgQTpOF9
	 EnqF2oHGxy+4tZqpEpHrOfIxpXiF6mL0LuIVoTes=
Date: Thu, 28 May 2026 14:09:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org, mhocko@suse.com,
 vbabka@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev
Subject: Re: [PATCH 0/2] mm/percpu: Fix possible NOFS/NOIO reclaim recursion
Message-Id: <20260528140942.a0e9a82aa6f98430266ce8ea@linux-foundation.org>
In-Reply-To: <20260528132917.81123-1-kaitao.cheng@linux.dev>
References: <20260528132917.81123-1-kaitao.cheng@linux.dev>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 70F3EC000C
X-Stat-Signature: 8p9xh9f75tstzqeshxwedjupfg4s68ac
X-HE-Tag: 1780002584-347164
X-HE-Meta: U2FsdGVkX1/lL/EnsclvE/1PcV3PIVL4xaPmkd2MbrkRgCftjPYqeDERq/o0lTX1OEJW/0bAer+FozPavOxT7pigfIXTlqDADcldTdpVgWaT2LqZ2aaIpczMUeluZ0V0aG1ZTkrQZL1o3cU2O4FO2l76ObVe7/RMB1OPGel5vNSIw7F0Zp5rjZADgAlYQ0B5BN/dCbk4qvj9yegqawdnnEksiCB+BOlTWpHjXRlCRsVqknYjxRV5iZ0b+EoigZf3abtCSZ5ZmKfLrEoI3eYdQ1VglcNtuo5I80u9UP/EhbTlxtcsgvlbgyJCHdmYAdPUfyf2CR4kkxD9V6Wq4GZx1vix0IGEKcARq+N/dstpEUm0mF0j4qUOGVNyku03voX27jnZfw+wuNSkEZq+fonkTp4IF7BXkHtc6sb1ymO+WNDK60vV1uI0NnO29o9EGmOZEIidByDcbaX5V8Vm43Aywh/XPlwY6L1gJTHwaHG5VCNaL0VvDGWxNLx5qpQNjfTCwJ33mJcfmPK0m6W3SYbDw3f1lsW18lFfGTY0SizYpq91BlGfj0dRNFa7jF5HmhYcIWFvsem8XUPoU/LQ8fPvbd1Z1evQC5McR3rUD0HVYbbb8WVXECHSiSWlm5iDvJ7fxQgNt6xBZDTGCKMgugLDNImYIZGhr6W8b5BJ0mdgeefbXFelgSEnKYrQ2Jw4lhvykpOLTGKRK+tRo4JnuAsbhZDyEsc5GUb+6l96nPX55jER4lC8FnELDNCVPakpDRmOejN7UBE2JYu01m763fMkdiDHYscG27aH9XH+AO8v0rwYNrg1aa9J4wTpqIRwjCazEix1v+v0161Xok6wA1VZj7ZAPTA9xP6lB0zFB6UeAjm47PJMEjcV7iANZp3hbGGNyeXMdiksA1GkQDghg3UWt9KkXcKP/gLipZ0i2WvKPJOQUn1xjOXXepYZKrJpRZBEkyl6+dmEkHCA1i4Ub+r
 9+nlaaLV
 1tINARE+AYVnHnZSgEZ4kl5nu8M2Pi7BD8JutuMh4oGgrb8S5MsK3nqinRG8XZVzRc8qAK6QqAhdXksH+NACBMZSgsUa93SkGjujno60K9cTo8YJVzQIM+KAkFdG6j++x3JKZBY1tWgIHRCYP+pgrDoARg+Wnm5rPo/Xr2EmG6a3ZBON0xn9usRwdzeRGeGQ2Gl30jFBxcxcUOylAoiZCycgSnrXln0hweOZPzNyXqjt8+Gs4jfzi26HrzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 May 2026 21:29:15 +0800 Kaitao Cheng <kaitao.cheng@linux.dev> wrote:

> Commit 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations
> atomic") allowed GFP_NOFS and GFP_NOIO percpu allocations to use
> pcpu_alloc_mutex and the chunk creation slow path. This restored the
> allocation capability that was lost when those constrained allocations
> were treated as atomic, but it also opens two possible reclaim recursion
> problems.
> 
> The first problem is that the create and populate slow paths do not fully
> preserve the caller's allocation constraints. pcpu_alloc_noprof() derives
> pcpu_gfp from the caller supplied GFP mask and passes it to the backing
> page allocator. However, pcpu_create_chunk() calls pcpu_get_vm_areas(),
> and population can allocate temporary metadata or page tables while mapping
> backing pages. Those internal allocations can use GFP_KERNEL. A caller
> using GFP_NOFS or GFP_NOIO can therefore still enter unconstrained FS or
> IO reclaim while holding pcpu_alloc_mutex. This defeats the caller's
> allocation context.
> 
> The second problem is a possible pcpu_alloc_mutex recursion from reclaim.
> If reclaim is entered while pcpu_alloc_mutex is already held, and reclaim
> reaches a path which allocates percpu memory with GFP_NOFS or GFP_NOIO,
> the nested allocation can now try to take pcpu_alloc_mutex again because
> 9a5b183941b5 no longer treats those masks as atomic.
> 
> Another possible way to avoid these issues is to revert 9a5b183941b5.
> However, that would also bring back the premature allocation failures for
> sleepable GFP_NOFS/GFP_NOIO percpu users that 9a5b183941b5 was intended
> to fix.

Thanks.

9a5b183941b5 has been in there for a year.  How are you observing/triggering this bug
and what are the userspace-visible effects?

We might choose to backport fixes into -stable kernels, but this additional info
is needed to make that determination.

