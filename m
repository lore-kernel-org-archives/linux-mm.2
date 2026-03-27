Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1213710AB82D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 00:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E9D16B00B2; Thu, 26 Mar 2026 20:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074FA6B00B3; Thu, 26 Mar 2026 20:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA45D6B00B4; Thu, 26 Mar 2026 20:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D672F6B00B2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:02:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 70174160F21
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:02:43 +0000 (UTC)
X-FDA: 84589891806.29.96BE36C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id CAFEF4000C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:02:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gMSZvtlW;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774569761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xNWGqjWEtr899amJEvUjdoQWqiA9GVsA/+16/D2ZsTU=;
	b=wrZS4dWDijwF7BgSYABqcsoiAB7SfZ6Xa4PQhK9CW0zbc9Tzhsza19sxMVlOk0waWZco6z
	Vs7zEY+H3/9h2SG6HWAUO5LN9SjPbpJqY8iNzwX8Vy2FRKFCcplkaysL3FSjMj3kBZCXHk
	/OWBuVpjSBq/OoW55N1q3HoTpU5Vdeg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774569761; a=rsa-sha256;
	cv=none;
	b=guIVZsIYJPfoOhCNZsPY2MCzPwhrPdVEITNDjfiAD3J1C7s56yvkvLvCv5esJR7W4C+RfY
	HHCmY4r+yN1cUqDpFR0TUSgU8ZeOyIELRxpxO+ypI5jc8OY4WGPBKKIvoivL8607wrFSrH
	lTf2/pU9sQ1lwZY6jBoNooo7K0RBFss=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gMSZvtlW;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 36DDE60054;
	Fri, 27 Mar 2026 00:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57710C116C6;
	Fri, 27 Mar 2026 00:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774569760;
	bh=aYUPtuvMBzXSCiy+k3UnSXW3v+JD5w8qcio9xeiJy8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMSZvtlW1uXt12QYrnmX8XZKlz+LtzxEQk2EeQP0ZIa4UFm5WViL1RRga83TrXdEE
	 JUxILBd/Ux5t5MLaR6BQu17lNlXtCR5a2rI8MLudK28kTV6vQTs+uStlng/3x75O34
	 StD3q+IdjfrYyVUW/VEHXwCMQJPZqqhEHopMNhnPK02VDdoNejvl9hQdcN+u3fj1/+
	 TINXgxbMNnJreR9KreoERzbqTH4bluYQ9JIpgU7KSlpDRSII5ruVNoJKNv3oL8pgbn
	 R8B/b4zqOwAwvVm20GKEoQ1fOVkpRfn1aSFHxZty5dvyHiWdEk+CNbQeHNzEfdta1M
	 /HJMyE9fuoS4Q==
From: SeongJae Park <sj@kernel.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update MGLRU entry to reflect current status
Date: Thu, 26 Mar 2026 17:02:37 -0700
Message-ID: <20260327000238.54525-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326185629.355476-1-ljs@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: cqrinnykmpc7pdcqu59wbmjjoj5raenm
X-Rspamd-Queue-Id: CAFEF4000C
X-Rspam-User: 
X-HE-Tag: 1774569761-762434
X-HE-Meta: U2FsdGVkX18Dqr0DrftPaXsFXtagMdbTICiMQFH3zdDws654LKnGxd+XjA3h52sWaJRe9B+No6vg5G00p5xQ/RUwVtEBmB1fNFU4TY5gyzx9+AIP5i+1/QsHt7VhB/CrEgbp7x6MsBvsr4NGseHU7Io1wjFlcrRA5BapP/GuMkaGPEAVAmSw8VEmr1jrROLvfi1mLYMffzcpOM1KCIxYgx7JkD/NUmNwZLX/MC6rvKZuhJqtAlk1Np8k1rD2xeAZF5iSHzNDIr0eU5cAX0DwBHJM5lulZy4cXs6RGEUO1OVtqy4SZiWgMn0YHRJvIdnr5LLfRm4nZITGwQ4y54T8tbReQ25E+6ITOWmhs1on5Y6FhXgYXbJzQDDT3QQ7fEOQIbmRnjJnEyipyv+W73rWvuS/eZsbMCIj89QTgAwvFshC/Gcnzw5aj6Pr6bhtnriWMBQ0tCbPGEcLhfabBv+WTH6DluEqKgxhnGCziBJkx2dtMIksZTgy+1Jqat1B5Rmb4Gewddz06sFjYpVqDTlFNykVytKkeN+Q/WQ0O2crNS6X+igVZmgvb0cJPkSi85fLbe+l1YtDdcyFtyKhrcFC4awuMuYAWmPenuCtn6JXaR2paupAbOC7Gmxdmi9Sl7wMzgBKKfDksOaeAmgg8pw6tRGFkU3vr1ZzTGVCdTeAz2KRL6B3yT4TbLH7Fe44Kt+1F36DjoNs+sgufY7Gpt0/D7r5kwq5GBQPk5u3U+WcqQFDUXmF404w+t1uvOBFcTkyxr6CwZCNxdjNz3LUykcaT1aqeizW07/2qHDo42d/AZwertJpAYZ7MijpZJK/AEyQXe1JlJKzxtRCUSFNZ2o1mdxY+yZ1wG+UASYkc2odepyjnthtNfSkLOoTyaaDZ+ASoROFe1s+KVMJepSNFeoQPRWcFJ+Gi4DKu4BGSTM48lrzTsqJJ8btl7lMA/fzmjkM4i8C8SblLH18hjpJrV+
 pqWRMP9P
 1vtT1wIHBnlgnqh0102PsaxUn9FjSRX7nyExAEEiZfURnwykfdEPl1+KyX0ks8Bohmv5+W7pRTdG7zpOiBgdH7qGMVxWOqn7jEbsMEmt4hDZfvZVWCN8gCOiv4bjt1YyIMRS+o4Sm0JJcq3O/RmwFIwY11Dhx7aoFh9nn00F20qaiDJoOdjsjQ90IIyGTZvw0suDHoWulVDMxxAVl+MRmQMfFY0lisAoVu6owUAN+H9oPbI4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 18:56:29 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> We are moving to a far more proactive model of maintainership within mm and
> thus put a great deal of emphasis on sub-maintainers being active within
> the community both in terms of code contributions and review.
> 
> The MGLRU has not had much activity since being added to the kernel and the
> current maintainers who kindly stepped up have unfortunately not been able
> to contribute a great deal to it for over a year, nor engage all that
> heavily in review.
> 
> As a result, and within no negative connotations implied whatsoever, it
> seems appropriate to downgrade the current maintainers to reviewers.
> 
> At this time nobody is quite exercising the maintainer role in this area of
> the kernel, but there is encouraging activity from a number of people who
> are trusted elsewhere in the kernel, and who have contributed relevant work
> or review.
> 
> Therefore add further reviewers, and at this stage - to reflect the reality
> on the ground - we will not have any sub-maintainers listed at all.
> 
> Each of the files listed are shared with other sections in MAINTAINERS, so
> this doesn't reduce sub-maintainer coverage.

All make sense to me.

> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

