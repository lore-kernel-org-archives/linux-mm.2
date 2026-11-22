Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C72A6606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 17:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N7iODn4q
Received: by kanga.kvack.org (Postfix)
	id D825E6B05B7; Sun, 22 Nov 2026 12:15:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D32AB6B05B8; Sun, 22 Nov 2026 12:15:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70436B05B9; Sun, 22 Nov 2026 12:15:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3B096B05B7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:15:35 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23703140718
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:15:35 +0000 (UTC)
X-FDA: 85463406630.16.40F7F66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 81E4E20009
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:15:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N7iODn4q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795367733;
	b=7rOvEhBSuVhru6NoyN0ITh/+E6aOEyq6Da5ajteboUt8stIYm6/QfYOQnLtoQoGJNaCT3N
	sztO44/xYX0V85z+A5F7u3zo/n7VHer21yjPMuGRhQAQWjoaAO1aix+37YG0kaUT+EifRx
	7xmvbixxCrMK36VyG07xIk4dUd+0aBg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795367733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pav7W9CDhzw7qErKCvygpSHTcbOi5Wufp8OZPbyFOjU=;
	b=ZCEQRXFG+r4UvCazwNLaqsRjQh+W41nT1aNXGINU5YXeP61BMpyMHW11412e7uX2jms8DE
	5dDw0cYj0s9DHkyutH1YODntISMjO9p6MArOaH6KHmoP6EMTAI+x8aTeNpY4eofRNcb5AP
	z0USUnOUtTDbsg7OBmswSBdG9K4EAZE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N7iODn4q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 91FF160218;
	Sun, 22 Nov 2026 17:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217A11F000C6;
	Sun, 22 Nov 2026 17:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795367732;
	bh=pav7W9CDhzw7qErKCvygpSHTcbOi5Wufp8OZPbyFOjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7iODn4qTc/7SJ1+BUR7bjrDPdbDNURw2c7OPecOiS5GLpFgUanB6F2FmwvLgVVQj
	 ek34s54CMmXOcgRX9n/U9tS5Ww+WB6XqqlZXpX7kARJ6kZO8SnV0tWp/XylYb1on6/
	 vNTweFJ/2xiC0jRjLVsp3O229sH8N6IBdPP+G3EhoATuj0BmvwEYqu21kHV88u++fF
	 ChA6Qgt4WgI6JQR3UCm+765xdpB2Ung9bDEfYDqmspBEqCkwwTEFvqD2d4nh/ytGLQ
	 LhZ85rUCPoV7d44m1Pn4fpjIsa2NqqAIlKiM/NBs5QaEFo4uJDCp/onkD4sYsQWbsQ
	 nDcVuwaLSyRKw==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 03/27] mm/damon/core: introduce damon_submit_report()
Date: Sun, 22 Nov 2026 09:15:24 -0800
Message-ID: <20261122171525.153150-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CANOyQmH5FX18LmMW+QwAcvOiATgUqx5VH02S5DyfTg+qPMSX+A@mail.gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 81E4E20009
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: k561ngtjwxrbfqm46h9eskrozswr9wtf
X-Rspam-User:
X-HE-Tag: 1795367733-187488
X-HE-Meta: U2FsdGVkX18aCvSSvPvi7RKKXp4So2aLyuwmWqXModi5g3VHCQUHGiIvoUqixJze1ptUC258V8rHa9dJ30xrQT91Sr/v9Uc6EUVfsHRDGcF/Ljh0iqut2xhkKpZLN1fJiYp1tBe2U3fRwhskpjpM2etNLnlIHJiaEiEKwSR73WSaWs0M2/0cHIEKykfdcML9qkauAUIfGVBaHwn19yPTGWDJ0lKcphoskOKiXY1STTO+MRZ31cOoD+DDcThgds8TTDhp+hup9CTmYEqt7td3Vnr1F9BW5CIFp8gozC+xRxImRhlHnqEBShIDmnMeaeqm2Oqf/v2RWrpR0X++WtHfR9yPl4l0PQsJTukrRsmf7TvKHajDWickvItgu8z8ZFnmbLwfKYtfUjvNDXehmnoEFLuo4DAk8MFLjOo5Qw/to1wlFHYO19yXsr+8q2o4d8GgimKQ7k+Y0sZ8c8mkM7Bwow+OlpGvGOYP/grOfW+E0LG/Fr94Czj2W1VUmahosM51p30yyflzkGZGVjrjg9ei74GtxobJneTDLl/n/ezEOsxT1k/CGg4198QMwlK+Fox95AWMrgdM/IxmSuBQeLz7QpzwWUF9yuiZJjtCGOueei9tFEDrifRBnixNmE3zk0ueNdB39PqUyWFLvXdJwQySbbuozdKFpeijm1ahhyzdzufKaYoshKIdhco8huA5WMJUy0bOf2o2T22eyfWI974eNAVBUnXohrNG9N8rGfM/wiD6wqCOniWrJUYARSuWkmlvXyI5xP2cNp1LWBlxLtkOsaIPGYN7x89FWo9ajO4BABdlMD3LsdUgKRcFAJYiKwnPOMi6f1n5up8m4hso/E9MDfCdmW7hE3O55s2pNE+ebbH0xxt1pAqWtnNFcEg2WocwDKy9zddn83l6BvlijN8yLiNRSTEfgSEGMCP0V2+7um3leb7cS2BHbti+GzDJtwK2/SYeA09KdvU1YlipShH
 7BK63ayV
 s8AuHHdTqKwdVAcghxV6j+chg1xA0isQR8Udpq+d0SCRAN+tar3c8Vhf5AVlU23CZbJBUu6rWcH2V9Nj2UC9hyXcI/pJUynSsn1IsaE6LJoXElBhwL3jKHvURFchMOm2Inl9XsMtiMAS5SrVi1poq9i7iuU4FMYV6uRAvYNADbz+cIWXz91KI4zS+AHKsovPVvmJ3uAgZCr5PSSu7LE0sc9JnFTGVJiS+f6QA2eEbI9VA9g54OHVplzymfkvFWeC2AkPqQv27SN3Easi3KRoAEzw7KAY9cT8D41Pd/Rws/IYupTvK0IrELpxpuUTaBYyuTiS4bJo+kb89+yaCCOmO1pzMMBU6vb0G/ChSsdk7DLGnycU2bptXVexKA090E7yWVjs+S0v/7brEKKM9OsHojGyYsFhvPWWRVoduzAL5+TWQ4DKNsz2x1e7oN9EBXVLExKBrjJ73BqFT44bZ8tQPaHhSmb6YyGUanJLnhUryiQ3xToeweoPYlX/5B+rrdvgZHMV9L0YTrJcZZIO2rT12u4A1YzcaCbpvoOqLnjjgOYvFKGkmdxozzNwnfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 23 Nov 2026 03:06:16 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi SJ
> 
> On Sun, Nov 22, 2026 at 8:00 AM SJ Park <sj@kernel.org> wrote:
> 
> > +       queue = &damon_report_queue;
> > +       report->jiffies = jiffies;
> > +       lock_old_val = atomic_cmpxchg(&queue->lock, 0, 1);
> 
> If a submitter is preempted between these lines, it can enqueue its
> report after one with a newer timestamp. A lookup scanning backwards
> can then stop at the older report if it's outside the window and miss
> the newer one that's still in it.

Will that frequently happen enough to be a real problem?  I think missing a few
reports is no problem.

> 
> Could we move the jiffies assignment after a successful cmpxchg()?
> That would keep timestamps in enqueue order and better fit the
> meaning of "when this report is generated".

I agree this could reduce races little bit.  But it's too little bit to expect
meaningful change, in my opinion.

I find a few downsides of your suggestion, too.  It will increase the critical
section.  Also the jiffies becomes little bit late than when the user made the
report.  These would be negligible in the real world, though.

So both the advantage and the risks of your suggestion looks not big to me.  If
you don't mind, I'd keep this as is.  What do you think?


Thanks,
SJ

[...]

