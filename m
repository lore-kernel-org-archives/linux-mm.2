Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 940CD60A3813
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=Bf5BsZQm
Received: by kanga.kvack.org (Postfix)
	id A89CC6B05B7; Mon,  9 Nov 2026 11:44:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3B946B05C0; Mon,  9 Nov 2026 11:44:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92A236B05C1; Mon,  9 Nov 2026 11:44:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 69FA06B05B7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:44:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01370120732
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:44:48 +0000 (UTC)
X-FDA: 85416154698.16.1ED942F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3EF5A1C0002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:44:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Bf5BsZQm;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794242687;
	b=T9XKQE/vzzoAD6xy4afFQQtBRmXQVv7tgWtnWX/dOxRg+af9X7C789QAdLldwq2hwQJq7i
	G0TUOsGRxI+9fSbCVCHfVPRY8rdZTfooIvBfB3qiv/2/zafX1LJC7NhNZ5layiBFvDZqL8
	LRbY4C2A9qWPQepvdXEG5V+kTU6qDek=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Bf5BsZQm;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794242687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7vmLERfGD76whB6hILQUqqQo9S4q4ZlcNJ1AUlRZ+Ms=;
	b=l9InJIdbt2ZUEmSVxsgQ+BAYjWTi1POur7VONkiH0H/F0sNzKg20wsJ0tB0cmfq8iaojcw
	YdKaLXWTi87UiL2PZ24B6nn1T84JGcw2sB2ZujgaCRuhJMG+N3YH3mZEt5BNc/NAWxk2i5
	1p+9WN2jmqkOiTXe5O33thB7lA2C74Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7vmLERfGD76whB6hILQUqqQo9S4q4ZlcNJ1AUlRZ+Ms=; b=Bf5BsZQmw7kqkyNLaJy36LCu6O
	DuhqQq7rkrdUnaBAunpnrOgxBv0C9mefE+kILiW6fL//AERC4l6xRx6Ba6r8SXrSjRRekPdlIFNZ2
	SDsQsGKykzUAWSke3vbYsnUlX5d1s9cqi7kAYXbzDvQ4E4E87HA1wicoTm/AbIlgncEXt8r5GOhko
	hTfkMTLUCBJJwdBTiv1gLH1xWheXezX+xSXJ4Ub6kneYYRaxmZWrIyRZgWBakyuBaEZtBhA6HdwFV
	wBiuwgR2QKGQyrEfeeLR4phfZwK4JAXGDAAB/64pZacvnNmiB6IfGcpXKz8ukSibwZ0aMl8rWEnj2
	YQ1YssTg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xQSTo-00BlId-2m;
	Mon, 09 Nov 2026 16:44:25 +0000
Date: Mon, 9 Nov 2026 08:44:17 -0800
From: Breno Leitao <leitao@debian.org>
To: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Julian Sun <sunjunchao@bytedance.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 4/4] writeback: report a slow writeback wait once per
 timeout
Message-ID: <avH2FWw6-N8s03Zb@gmail.com>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
 <20261106-writeback_stall_report-v1-4-bf0c3b9023a5@debian.org>
 <ysxh2sfvjikoh6cw2qmk2i6p7xripwnqxkx43jj7unxop5tkiw@gws5wezjt34g>
 <au3w4xiaYbEYLTru@gmail.com>
 <xehz3f62chf5ivwbh7f5chapypp5md5vasdtsnxfwzsebontf3@roqs5cwjk2va>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xehz3f62chf5ivwbh7f5chapypp5md5vasdtsnxfwzsebontf3@roqs5cwjk2va>
X-Debian-User: leitao
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3EF5A1C0002
X-Stat-Signature: wpmci1p3qpr9p8cidta7pzwespcgpowz
X-Rspam-User: 
X-HE-Tag: 1794242687-808968
X-HE-Meta: U2FsdGVkX1+MrjOBmSGA1svMlT6npbCrzHwOPGM8+LTkCtcQMzgBJ17C/Sq1Se/HFk4c0uz6ZJ0RAJf9ikphrBR5jaOGdxMkl/XcUID5gFaI4kUJVSBkL5EHbKBA17wAkudmN6oi2URSFiHA+vLx18aksXCR5Q0g45bIOxykvlxfbd4orJvpjS3njX7wy6IYjfWfUEQebBqThGpZqVdoaTy/BL23q0n6m4Vm/8eaJBEUt9LrfrrMQe/tWvXDEslpOPrwSwSaNYnt+fg6MDlvaPi4cTXGAAX0vYbg+q9qOySjgCuIiOecg2B147cP/uV4HS/K2BC2Y3NNna/1HS/OT49pBQ4NR4Q+ByFxnb7cGYZT0lKkDpWSIxlP6nxNXCgQDBzxbYGxMmFogqsJS37WjtdKvTngDD6fs5MkdwE4Wf7Lc01HKdtZcFxKXCKiJZ8EYrNyL8mTme7RS9pu+lRrAS4SXkwtbFy4G+KEOD2kG4pOLnO9nNOZlzY1MJuRAj4mKHxb3TXO0/UIigadyR+BDwRxn3W/X3k0icMe/SA24T7UT0J6qO8+BE8cXJhrrqXNi486felA7Pgz3lZ5WUHnYGPOO3x+7NDKZGsJJoEYELcBLMGD6bDRmrcuPK1JPN27fu3Y66xxG129jfD/xtXKKLyPjcgOMHPgmV5oqRXSEb5DsZn6u1n1I8veTp2C+68GPNsFo3Ob2F5YPIXbjR0vB1vX9WVcZ0S1xV4C+le75GslP6sgl5xpFohKzt7Kf38vz64cFA4TbR5jFM1/d2oO8LSJWcvHdavnQvROhvbQA5/tapQfEilbLe5dewepa0fGyTXLh1Jzi3F8rxORVgXeC6a5fWu9XM3l28F+nNbKf61KgwHqlX2FSnHuA7LW7zpYk0xeIwt8D69x4ok4eUV86OfDkNkdus5EJUohrC9yny2MrKdtZoIcVMnqBEEmfbqbVD0VwFq0MG0uVICx5Sr
 l2eQNy3y
 sjeQtEZgoJD1dwKGszJG9M3jRyCLbSp2TFDBhiLOjLYxXOpUNEA4IfJryPEipHJp/GnSkdsRTDJXJEOsjvm7+NSE1HD/wwgctFSwpcl9GRnCp1ltVO7gs2eq/8iYVYgJtqQlzJHc4N5GFK37bep9aW0k3aFpQPhCeXd3Nzq+p9FhAT6BDoRr7iGIFATjeCU0tMMXiM7STl49jO2TURWcmSnwFDC6pbMT0JfjEo7GkKhoAKMxpTVK7JfdBsyr/7JEpSLod
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Jan,

On Mon, Nov 09, 2026 at 03:12:16PM +0100, Jan Kara wrote:
> > Once per timeout is also how often the hung task detector checks by
> > default, and patch 3 logs the total once the wait ends, so maybe that is
> > exactly what people need? Not sure.
> 
> I was mostly making jokes here. I agree reporting once per hung-task
> timeout makes more sense.

you got me here. ;-P

> > > Is this change substantially different from
> > > writeback_sb_inodes() waking up done->waitq less frequently?
> > 
> > You mean the ->progress_stamp field? That is not used for reporting
> > purposes, right? Should it be?
> 
> So my thinking was: If we change the wake up condition in
> writeback_sb_inodes() to use HZ * timeout as a limit instead of HZ *
> timeout / 2, then we should get one report per timeout, shouldn't we?

I think so. Let me hack it up and respin.

> > It could drop the duplicates: a wakeup with work left runs the
> > wait_event() condition twice (since 84654c7f4730, it is checked right
> > after schedule() and again after prepare_to_wait_event()), and the
> > second check would find ->progress_stamp just refreshed by the first.
> > 
> > But the waiter refreshes ->progress_stamp on every wakeup, so it cannot
> > space the reports further apart than the wakeups, and those have to
> > come more often than the hung task timeout.
> 
> Why do we want to wake up more often than hung task timeout? We evaluate
> the condition after each inode so the error shouldn't be that big?

Yeah, I don't think we want to wake up more often than the hung task
timeout. That should be enough here, honestly.

Thanks for the review,
--breno

