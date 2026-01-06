Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8D62CD042A
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 01:33:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15F576B008A; Mon,  5 Jan 2026 20:33:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127866B0093; Mon,  5 Jan 2026 20:33:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 036DD6B0095; Mon,  5 Jan 2026 20:33:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E597D6B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 20:33:53 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B58358B1FF
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 01:33:53 +0000 (UTC)
X-FDA: 84299817546.13.40D5FF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 206FCC0011
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 01:33:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QVX+WWXE;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767663232; a=rsa-sha256;
	cv=none;
	b=Ktq+AEvqIBhLSVGDTlp4azDaVhUFalQxuJsxqaQNiMMq4KMNp5IaYQ5wm7EncbYUZmMPuo
	sewWg/fq3kMGEofiYPLnwjqk2uga+eRUGZdZ698OnhQ8ZBHYadc1a7mfp8th8VA8RauMfy
	0kgogKTRkLJ9G4qcbZfPY8c06hqcanQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QVX+WWXE;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767663232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e85+orfxznIJ91K7ACameJHjRWd2J/Wr8MmAI4A/JiU=;
	b=ERfSdy9WGJFQhRaT+Su/iWL2A3PSpehPO+9EW9il57Y0kHaa+nYwFtqXR8Sc3415rm8iDj
	S0S08T6FATTNRbb+Ugqi/RvcAifBuRYfUrWsabu6bLvDjTDkHsMPRhX6F7wo/X79RN92+9
	6GKeeaFSbP7m5lVmWOhKU7ldeB6FOhE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7215260144;
	Tue,  6 Jan 2026 01:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0131C116D0;
	Tue,  6 Jan 2026 01:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767663231;
	bh=xiYjh6ohs22w6pJx8rkfnuaEn5oxOp5Q7Pkvbyedzfs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QVX+WWXE6zEqxs0zz1N0PBYW+A5xucJYleKHMzCi6AU0/y/0Kn5ZXQ/FTpLI8xXJ7
	 MRxujhIdYu7eyfCd5tYvSnON7rQsVACAvmJDld1hAfseH5g+IepJrf4VVs96PnumHE
	 Dlk9kdPsNhdAnJjotpdw46uMfBM+IyRpVSGLcf/A=
Date: Mon, 5 Jan 2026 17:33:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Boudewijn van der Heide <boudewijn@delta-utec.com>
Cc: Liam.Howlett@oracle.com, aliceryhl@google.com,
 andrewjballance@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, maple-tree@lists.infradead.org
Subject: Re: [PATCH] maple_tree: Add dead node check in mas_dup_alloc()
Message-Id: <20260105173350.d8ad7d630be1f0a581dfd565@linux-foundation.org>
In-Reply-To: <20260103200633.246006-1-boudewijn@delta-utec.com>
References: <20260103103247.9140cb2556280927b09f59d3@linux-foundation.org>
	<20260103200633.246006-1-boudewijn@delta-utec.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 206FCC0011
X-Stat-Signature: qmfxu5g5y5dexs61a387ktnwoz16qep8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767663232-590138
X-HE-Meta: U2FsdGVkX19UDtgtN8DKkqcRBnVDnON71enuuKJi4A2bBzUP4zFinVaefwGwBaxUGIXMZvH9AqIdMlBtzmiC8aZxEslHFuHfDhAdxRlSTYhXxV51HpGqiXa7AJ+zanhqshE7Myq4MesaEjd4cnU8cXXLsXS+ilFIslawo3rQZVO3zTy3Ipuuit8mTbFoYgR3ZkH1JC6Urgawl9vxb4Yd9i6MorlXsoqq7I1mhMJOJYd87GJkinWvExIRDlf3jl8cIhAzy7tFHq8Gf6aM5cMPTchiH0Q0t2FAldM3PXun3kl8z8d20utFpmxrQh2k+5J6WayhJZ4KRAZbJSyfU3SNEi+YMTB4g+eJBBpjm++m9iLtNQMSZjbEZmlMEcriuNoa+PyNamauUFwZceQMkU3vIMz8FvqEWMpjRmm2c9WgAogphG8Dz3+RFaN9XIdgiUUS7IbU4zOC4eriqCmqIQNewF95sGNwlx7RYnJl7TPXNcnDeCYEcNAosViwIsPlpL4znGtETMMpnzkG6UGa3CoeQfAARvLJ6+V2zcp8Ca22W9R6Mop8jLwLvFdPDgpOESvTjFmA/ERjUUeK0PHIyUg1ur8KG6rckqfLxoKoy1HeQh5Q9ngcgPTN8XRH29DGtJ51VlqRSLnWY+NWCT0/UABRPoy/cxt7S2q9blwTKVGoiWKI0G7YK0GKxOS67qK3H7SRph9/5TvAjOyjyTa38cPrqPay6vmKK2Rz0AaeR9ZGWQp7qnTADWCnXwT9jHI+vtmh9O4WrSgyvPrpEPvGuc53C8xQm6BomaghvLcQ4+LL6t4sgFFJYG0TyGOL0p7aa+hmBCl0yWjv7LyHKLHEi98NqWlo4e7WRJ6hfxbUR5H2JVwv/0D40XTVJxef3r+CkXYt+7eyM2rIo+xylzUiCIJO2Oen85n8oyRg9x/AGbDiLNVutedjb3alLH45ZrU6Ph6RKtawHuar414pToti4VL
 XISPXgte
 FL7N8Yc0r7WtV2ci56MBKwrL+H1HHhGWB+XWEzZ4JMBNkD8kUhgm4AENrfDWCn0RAVa6mjnXElXc/hHYK7uOR8ygpKnnPAah2jWrtJr+k/3ieWC9VserNYMaa/D/L4JN62m6FX6ILDxzj/wpt8KFA/JXmVEbKF1YZxa5Fr9aO11Ehij2Zax4fhwqewpxKGY59MIMG8Xe1RDwr3HJ8ypXVTCoTcJr8FUZsAlHPV0lo8a16LXUgv3Jp33Y5SPFzJbUlkNg9JkZryAJopQ+tRCLVGrKUKzsjz4RMbRhX/tpZbnp5nqdwzCHXLsZk2NSeFhHqfGEIJyfMX3tt3+C5mxJ256nvpCZyiTCAGxHHa1FksvNXHwhm0RdALQAVFn7GchDp0fMnt2D0N9HsZ44BG/V5OJDSrpQCOjGvn4olwqXuYjIqa1Qy8F9uKyB63Q/0+vjTA2SQfdmbV4XJES3uuVauppZD+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  3 Jan 2026 21:06:31 +0100 Boudewijn van der Heide <boudewijn@delta-utec.com> wrote:

> On Sat, 3 Jan 2026, Andrew Morton <akpm@linux-foundation.org> wrote:
> > What are the worst-case userspace-visible runtime effects when this
> > happens?
> 
> Worst case: if __mt_dup() is invoked without the required external
> locking and the source tree is concurrently modified, a node can
> transition to the “dead” RCU layout while mas_dup_alloc() is still
> traversing it. In that case the code may interpret the rcu_head contents
> as slot pointers.
> 
> Practically, this could lead to invalid pointer dereferences (kernel
> oops) or corruption of the duplicated tree. Depending on how that
> duplicated tree is later used (e.g. in mm/VMA paths), the effects could
> be userspace-visible, such as fork() failures, process crashes, or
> broader system instability.
> 
> My understanding is that current in-tree users hold the appropriate
> locks and should not hit this, as triggering it requires violating the
> __mt_dup() synchronization contract. The risk primarily comes from the
> fact that __mt_dup() is exported (EXPORT_SYMBOL), making it reachable by
> out-of-tree modules or future callers which may not follow the locking
> rules.
> 
> > If they're bad then presumably we'll want to backport this fix into
> > earlier kernels with a Cc: <stable@vger.kernel.org> and, very
> > preferably a Fixes: line.
> 
> The function was introduced without the check here:
> 
>   Fixes: fd32e4e9b764 ("maple_tree: introduce interfaces __mt_dup() and mtree_dup()")
> 

Great, thanks, I added all that to the changelog and queued this in
mm.git as a hotfix, for runtime testing and pending reviewer input.

