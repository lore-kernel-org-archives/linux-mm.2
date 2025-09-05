Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D284CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 21:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C4E8E000B; Fri,  5 Sep 2025 17:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C9E8E0001; Fri,  5 Sep 2025 17:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B595B8E000B; Fri,  5 Sep 2025 17:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A0A658E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:31:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B622C034E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:31:23 +0000 (UTC)
X-FDA: 83856492846.15.DD40EF5
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7933640007
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:31:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=voEmRble;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757107881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RFQUguBVJMx+l4CUkTr7CK43jPG6OXp0+p67IT5nXMo=;
	b=72Pe07zcVjVBDtg5uIkTSxL6vZRbxUa3lAONpDBEcNW6hwLqG//dAERtS9l5qYpK2MdY76
	+Omrq0iGkTRFt9JSIPd/XZtqe+GVnL+YOO09InEwGNR4m6GOgZ0chkG0X7iDWqc/k/R5gz
	fQGlg2CN3H1aJ/acIOOhCW0mm958D+0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=voEmRble;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757107881; a=rsa-sha256;
	cv=none;
	b=BmJ0zQLCK6QqIb3NjbGANUuf46OLFKrFqON51XgMjvFk382TJ3HWS2Yevc1QdJUsu0zXEK
	L5sVrhzfMnjqxooHb6NmExaVPbmx355MQ3DwdwDEcN9aZyfu7EQ+F17CryxmnoXG9w3nOO
	apkZ9o+XUqo1ODYK+stlQETeRSTlox8=
Date: Fri, 5 Sep 2025 14:31:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757107879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RFQUguBVJMx+l4CUkTr7CK43jPG6OXp0+p67IT5nXMo=;
	b=voEmRblefBXMxz3/aRw61YL39gF+K4+3bqkAdIgzpUcJeINfDp+Ef2SjC/9GndUwbRNl3I
	3GjnzzdPeWH0FaYq7EoXMcvDWPFesvQ9XHU/tJMv7wB1CZ3hXohp3VPsJ4nxtBGhwae0pY
	KQyV7A0uv54NDMEhzag/JNNs22cMcSs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Peilin Ye <yepeilin@google.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
Message-ID: <mai3ndkvqrpkfpblkazbyejvpkizrp7dh22374tpkmepfji32o@3troawzsuvqe>
References: <20250905201606.66198-1-shakeel.butt@linux.dev>
 <87y0qsa95d.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y0qsa95d.fsf@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7933640007
X-Rspam-User: 
X-Stat-Signature: 6miaux9oawjyut7i8zdkphh1jixjhgq6
X-Rspamd-Server: rspam09
X-HE-Tag: 1757107881-555070
X-HE-Meta: U2FsdGVkX1/QP5v+bqbHA/JyB/C1q/DqDlJzFY/a/8kb681Q2TwhwtO/Y5FVC2M/wajq4rcDzqyzjwA3UatgWhdtFrsn12Gv2bSIqXbocmmc3n/KGrtKQC5RKpdyOqprW6mMymHZoOZBzyvghPY1CLL7/yfqwZI8saiK3mLgseWycB9UDOZoIUCDLgzFvsTqJDwoyVxGCJ60yj1hx/0pooFZq3hxdQ4FWRqtYRybRX3aR0MPtx4FmorZSGtJJbUJEIRpUTA9T6vydBYUNCPOvl0MR/ZzH3I/OTfMjREnGk6xXkNkvTMLIfyV1CK3ARBo9zsNv3bR157h8U+lZEptoZ3y7Fg/l8Vj2WCGlXVsusjbDtkxF334OT7rDHVwC5GP7aBnriRLIHF7jkaBpTbTJNyJnvrEsBE2gcy2+WPe+QCupmdY0W+NFr4XS7pEnnB9aQQvGwH54VMiIbFeZNWc5U0SpRV4JFS7zzjvUDx/PHbUCF6ScrfNKuDhAf/rQxMs0EVoZG3/CI0SSbkrHEaYXjxQxXRqeCPnl7UkGgyihNvJoSvlBHzxRGeVzTjsactTABHZqdUKYo6OAat0m77lHWdpHpDvuahzyMSpcReivWZj5K4SlZGxjeg8FU9F/9rAM0+cDPivTx/K1nb/mnICL4kw5enQLSanLW4Df9+4Gr3lcO6qRDLT/yUN1w4mofrLKBnrmnFQOe7HXNvS8cAnQ6xDm5Rg4bywazHcBA+H2dqmGJDjNkcWpNh9ofTdRP7BipFS4ATa6AaKntWij9akaVvT7MOHNOO8Affxz4SzELp5C5gQ/jijc4jySADHSoCTX7py3v9RlxXl6HKZD/6cFx/Adgf+5bCJWcubvT71xr2GXxCxHDzR+599BF7S3ETdTLPEuj4JHz6l8bg/WWu3MO+Gys6IOl1rZd8Ce8w/aYeEkg+NTGEwzterrUAwL+vGYaZMlmJEtCTS8bnkm81
 +74bN9rM
 M+g/4gFSAM4HLunqhBg2KidNhMj7aV/qTFzKlY4LS+3mzXG7vghsThdBBfw7qoGEZeNof8zcY9yPXM1wNVoWkU23u5zm15Z2gjFYTxKw7ptE8RAxz0veN3TBn3l0/RugWZX1UkTk8L75wWMpi7jT6tkr9vpKoz60GZiyVyH3geEsRMUWaR2w0Ln3xRGAtaU7FZWZVo2HWibV+J2paJU4et8qZBcgk/UPK0ebHn+xV1pzRPzrRWlSchX/hbQ7KUk7pWZ1j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 02:20:46PM -0700, Roman Gushchin wrote:
> Shakeel Butt <shakeel.butt@linux.dev> writes:
> 
> > Generally memcg charging is allowed from all the contexts including NMI
> > where even spinning on spinlock can cause locking issues. However one
> > call chain was missed during the addition of memcg charging from any
> > context support. That is try_charge_memcg() -> memcg_memory_event() ->
> > cgroup_file_notify().
> >
> > The possible function call tree under cgroup_file_notify() can acquire
> > many different spin locks in spinning mode. Some of them are
> > cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
> > just skip cgroup_file_notify() from memcg charging if the context does
> > not allow spinning.
> 
> Hmm, what about OOM events? Losing something like MEMCG_LOW doesn't look
> like a bit deal, but OOM events can be way more important.
> 
> Should we instead preserve the event (e.g. as a pending_event_mask) and
> raise it on the next occasion / from a different context?
>

Thanks for the review. For now only MAX can happen in non-spinning
context. All others only happen in process context. Maybe with BPF OOM,
OOM might be possible in a different context (is that what you are
thinking?). I think we can add the complexity of preserving the event
when the actual need arise.

