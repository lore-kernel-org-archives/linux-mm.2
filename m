Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14FBAD3C912
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 15:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A4316B0005; Wed, 10 Dec 2025 10:09:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7547D6B0006; Wed, 10 Dec 2025 10:09:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F52E6B0008; Wed, 10 Dec 2025 10:09:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 48A356B0005
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 10:09:38 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CEAAD134C0B
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:09:37 +0000 (UTC)
X-FDA: 84203895594.02.CF5684B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2CF8C4000B
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:09:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LzY+YMpn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765379376; a=rsa-sha256;
	cv=none;
	b=cUKZ8mWTu7zdoni8HhKF0iMzuPlSGJhlHK1Feiio+ctwWscdxV9PCENsx2sd1vAj7YSu4c
	GpujolSfyV8eav+lVuW5Lx88oMuG0GrTuoXBdfGt+Mmv2LyrOJL1CKfeVe+Nb7GgOEBtML
	BgrOLRFmSgUZphhdeWsxelMSXmjnqgs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LzY+YMpn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765379376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uVGDaiD0TiExYwNhXm+onvkY2c03m4JR/cAis24y35o=;
	b=W/XIC2yS+EBGM2VmS5Lc/4Im7v1H/ovCOIGKyMp6OtLJEIhv99qbCCmHc6gciGM+3Pqs3+
	GfY2t9Tfe/WseRLgYqOh+/ORvz5vHY7INnqvcZsXqX+95/bvuHln0+5fnd0DcInbfyi/HC
	Ducg5V26HeISie/i8y/rYVNmPD2kjKI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 38BBF6013B;
	Wed, 10 Dec 2025 15:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B604C4CEF1;
	Wed, 10 Dec 2025 15:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765379374;
	bh=RNmnMRCESvvHPFXhuXOJd3zbdNDnT+Lv6azVvJPG2UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LzY+YMpnkL8T8+6BMETspq6d93c5ln9SEAyW+/EtA/UfdcxDc7MhLz8KhjGcSMb/A
	 ITPaTW92f0vl1ze5oJ28cNk++oEn62ZQU1wCXI2efEUgzwkUVB4q9bJ+TWSok5h6De
	 e8y19U+jU2WogiOYUQvAKa5W6L/+GvB781OKQqPdGJ8jI7MAnjpXLQ9tU7RcabHNl1
	 hVoWcOKjcBx90H1OxPaWR1jT/RXbCAK/o6DJTkGFZHS/vpojXUsemeqHEIK8M+ItvI
	 wHi5lQiJwcNz+H4pdyU4vsYFRMDM+V8WjOnlfbetvCH3BeXIzSSv+hbQgsKMrrFK5O
	 H/aeQRzK234uQ==
From: SeongJae Park <sj@kernel.org>
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev (open list:DAMON),
	linux-mm@kvack.org (open list:DAMON),
	linux-kernel@vger.kernel.org (open list),
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com
Subject: Re: [PATCH] mm/damon/sysfs: check for online node in target_nid_store
Date: Wed, 10 Dec 2025 07:09:30 -0800
Message-ID: <20251210150930.57679-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251210111708.46959-1-swarajgaikwad1925@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2CF8C4000B
X-Rspamd-Server: rspam10
X-Stat-Signature: nc874bdrhjuhg15d66efhbrrjs8khrtm
X-HE-Tag: 1765379375-514856
X-HE-Meta: U2FsdGVkX19WfMJHN0yDm8pAXBc1jWPZAKnUdozOKog5lH0zkdzA4W9zsHH0idW/uJC9W2urLpYbL4FqcGJfUIUsKzkfmFXLyPehYz93r6ffwoZavOUHAjL470TfVYmS9d9epLpDQAY2nuct/D1aCRXTlH3S0o4UMMRAjI5f4rejUdtMe51/kPa7yHLyA3CC67hexso/NU0HQi3k8hb35D5K4g9CgWL0LR3IfSkiDNLsMNKDM4sqVfD+bZOweI3o4ZV0AxK0+UXFAGVOH5ljZYtwX7tg0I3HamlCiwpdErEEuceg9dsnpQW7n8JzcbPW6PWkUmr9TxkDv/GLxCdWUXOV6RNzv3kVuSByC9loskyESG7EdbmNxgC1fcY1viUAfCDQRcn5kgfchiXMDZJ2xTEcmbmxJTjdAOy0g1A6VgtyeOkQDQl0P+5vcs1C48DH+kFP9Fr7yCXCGFsLXCPPRLu+nHu9teBd50ZDb4oVriwKn/MPIu4LksUxDMhbUSCRNQj5tcQkqNo2jZiFAG6Xk9ZUbhKTQxB3OosRwTxDkW58LM8mZyXqDZrW4nl9d49rGdKJIu1Zi1dkl8dqgjkdhQO2Vq7nl49bg5DU5FmXVz59h8YdFtg9Q9CXqcqNxRUn0DfeZQ2/OI7DCtGwFcI2y4C8zMKR4JdKqKckfHw79vQFGY1nC9P/2MZRyxXiPN6HY2Jmwp7ikV9RlE3H67FK3xxJHjrGZh5nL5Yj/j8tBh45cWeqgbmV3Itic9CKPmllup/SN4LXO/FqS/NEuGoNNSH+nK8LjFhLsHgQPn4ayRn75j0Ex+TmYm4IspWCMpgPWM5n4BDUt9/38Lwa9ibMR7M0ypwVvxm/+qUxuokSymZA2My+EuBg3NZtfKmO4df8UailOcx4MpKIRSx32BEZ4GZtwsk39kdQ2kqBRyw+CoCQ9nBawW3/jwYhlQZk2iByWgOq6oRkUVHAotbf0Qm
 kqwApu49
 Iq4rZnetaKiBAw6kQ77WENe3/sqcRSoYhcuWOvi8HZKHXXqj1wmltYDYP+7wETitNFV9f+HIWItCjzq1jvc0Xs1W3WI9q5MDnXKflXbzDPVZdN0cb9r0YpkVAChAO/f5f74dg7L5qSH7+66rv1KJUDx9+IGJ0XZCTDb0BSUkldBs2psVAPRJOOHoo+lRrgBynmqC5WEZ8HmF/gewPgn2dhwZXf235ju0KGiO4USpPIy64k4q+IYUdMhgD0csMydG09Rl2XIkZY4eZBRnWr8970VHi999sCXs8BIlGgRJxkZaTCH8aGKZmF1zRp7TTi9T5JycG1DPFOKK6K82juHkEykkcIXBzwrgYz0rj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Swaraj,

On Wed, 10 Dec 2025 11:17:07 +0000 Swaraj Gaikwad <swarajgaikwad1925@gmail.com> wrote:

> The 'target_nid_store' function previously accepted any integer value
> written to the 'target_nid' sysfs file without validation. This allowed
> users to set invalid Node IDs (e.g., -1 or 9999).

Nice catch!  Actually this was even able to trigger kernel BUG, as commit
7e6c3130690a ("mm/damon/ops-common: ignore migration request to invalid nodes")
explains.  And the commit fixed the issue by avoiding only the kernel BUG,
while still allowing the invalid input.  The intention was to make the
interface as simple as possible unless it causes real issues.  It is for both
maiking the maintenance easy and allowing flexible usages of the interface.  It
is a king of consistent deisgn philosophy of the DAMON sysfs interface.  For
this particular case, the current behavior allows flexible usages regardless of
possible hot [un]plug of NUMA nodes.  IOW, I'd argue this is not a bug but an
intended behavior.

Maybe the commit message should have more clearly explained the intention.  As
the author of the commit, I apology for not making the intention clear.

> 
> This patch adds a check using 'node_online(nid)' to ensure the input
> is a valid, online node. If the node is invalid, it returns
> -EINVAL.

I'm sadly have to say that I'm not very convinced with this change because it
makes a behavioral change.  Making behavioral changes is ok as long as the
changes are obvious improvements.  I don't feel this change is an obvious
improvement for following reasons.  After all, it is making the interface bit
more complicated, in terms of its maintenance.  Seond, and more importantly, it
makes it less flexible in case of possible hot [un]plugging of NUMA nodes.
Suppose the user knows they will hot-plug a NUMA node and wants to set the
target NUMA node before doing the hotplug.

> This change also resolves the TODO comment "error handling
> for target_nid range".

Thank you for mentioning this!  Seems the comment was intended to be addressed
before the code be upstreamed, and I missed it, sorry.  That's also why I'm
saying thank you :)  I think we should just remove the comment.

So, I'd suggest you to send a new version of this patch for such comment
removal only.  Of course, further documentation improvements woudl be nice,
though I wouldn't insist you should do that as a part of the next version of
this patch.  What do you think?

Please let me know if I'm missing something.


Thank,
SJ

[...]

