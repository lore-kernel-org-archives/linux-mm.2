Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4545710BA429
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 05:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71B656B0092; Fri, 27 Mar 2026 01:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CBE86B0093; Fri, 27 Mar 2026 01:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E1B56B0095; Fri, 27 Mar 2026 01:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC1A6B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:08:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED54013C397
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:08:27 +0000 (UTC)
X-FDA: 84590662254.11.B3BE462
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 51FDB20003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:08:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ib2cxLuX;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774588106; a=rsa-sha256;
	cv=none;
	b=Nghkh8TI2qtYxQb53d4lQDylPAoJFMMBhrO5u1FL8k8tAv6r1QqjKkixAP9cTPpX4/fAIG
	ry9MKw5WJzf/oRRX0QHvgSMavenl1zninbxfOp61+vTu/4nHPWxcUziBvzDfuLedyLSegQ
	P+vO8BfhZKNjrG2e3LvFKpeNZ3ma2+c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774588106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LBkeqJLOc8y50T4AI7R1K4jcdLaMg2HoiqNTX4za/zo=;
	b=zYVKjQ7pqpIQ/XmL94c2RneB0HbcBbtcp/dGzXkY/Vr7ccqJnL1iXDzPupzmPE/1+/SVtj
	HvDz2ibbV1lByYMZ+jkSoNqf1HVCy7+cHD2tFiAWEgLpmnsAiTSO9AOObVwrMFHHAz8CKa
	kKPDud4mjqb6FsvSTyrdUkuNICU9HAw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ib2cxLuX;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CD6B40303;
	Fri, 27 Mar 2026 05:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3256BC19423;
	Fri, 27 Mar 2026 05:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774588105;
	bh=jLVZdGJLJNiTat3VGSwLzz+NckJVPWrBPPP0mEtDVtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ib2cxLuXrQb5riivetrfLXV+NLae0rUW28MkCQgXBjGZAN3Ny6KTDfiLSCQ+4DxD7
	 xH5XfAR6Mfcq1cMXeFUuBnqmRaHkqUo6xBwQ1tHRaj7sYnf7Uv0UsXyCWg1ry9Z5LQ
	 /j10FjDAyzGUBwxauWd1pNAp/F978uroKinpw4khWxsTA3bgFTUVs069ekgs4ka+0t
	 +jkIulvwALUR93wJSxRmx84ZFz3RJk3KyOXQJvgpbkRpIw4yBsrkre6wLx3DrBqoah
	 JNwK+LFmWQgEaGo6dw5FUftiKyGGrltpDZFLHzjRuYYP22Z2wJRrCDshFS2FKI8rOq
	 Lx+bheL4V2HuA==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC v5] mm/damon: add synchronous commit for commit_inputs
Date: Thu, 26 Mar 2026 22:08:22 -0700
Message-ID: <20260327050823.43382-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326061554.20466-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 51FDB20003
X-Stat-Signature: fz7zdtnmcupbynaaw6a8o84898oo1wie
X-HE-Tag: 1774588106-365308
X-HE-Meta: U2FsdGVkX19KbmH7nQ9JlHLaGUaxOucYze/dwA4BBUu1ZhtX/ZaNMHikzNkxZSHU+k4rDu8HbRCpRRtiGWwWrhZMVYSu5Y3ZmRqbqvQsy9n7nAR0pDyvMysd0OJdNA1MI7AH0nDcLEqPlinMEi/8pt3wWQsbu3LVurgabAmnE+rOMt3nnSbHmzsCAoW8xWRXPhDcV0HlxZpd0vWMqNc8BvIMUGORGWff3XavXYZCnk0ZKMe2tN5ilIyNPK1dSRIcNtJljTWCzA5YAfiGk3JHCVok38U+sXeIy6F+ipBBUlS1dYyVAvrD5aVFUVpcpIssfndL/8mBP0j/cIYQSoWGVItlLeqIJ8uVBf6t8xRdTCpaqNe6gUp1dCN9LbpjPzkpLpr3fu2BMmiWtOPMQvZuLon0nrPAgJY2QFpzXac9PRtUyFw/rpBW8wxRZ7qJtw62cl7k//pDF7hOGHXCuIwrBjEIpI3MsYjqiVbkSpAOc6sfRsYSSb+x6kkjKhG0kEz/Vui4K+3PmcMnj8I8w6/G5TupOZMzA8t4sqbqQbV6CO5f3V09TLkWZeMgt4XmMJd6GYKqfc8nnx1tPNXlkYtxVlyAYzRRESe7gWPZXSdIGFP2llWXi4oQkfvN/s9ZmfFXy18rmHCqEUBozxefNqzXicZA09J47wR8AJ6J/ulU+E2nv1kpc13a/P/RTxCMnQO85tK/mmi4CakGfopsC2H2nmotNaIbUYGyyEo0njybkKFaucieoYkIGiiOd4ksLe0vcugKa7zOrNiZG3/Zb4ymQsoMcjeGfcBsgJDj78oSocaQjI4XtIb8Ihv+XsN1NMJxK670OP+Yz30p4FN5qiRM5S+n8X2gMa7CiCRaaLFwnC2YGuzG05COgzK3IZBWK1tgnNxjmYmVblF2fi4ksq0l+zQzjuEnFZK4QCA+7l3eyVMg4szzwtLPezisMZZga31CgeFTkjH5FlkDhnqUgXT
 JN5PfUoT
 W1k90MKwxpaTIurwn/XTEX17GN+IuegHzcGlJ9ZNJ8kSK/xmALpm7ERggpYzGpdBJF9/k8izd/FC7+XgEebh6h+6L26gV3fk9EkdnrEAUOihFT3sKyX7Gugeu+8tklJCK0NsYWJQb0vHm0orMO7+0xGnNgo34Ji+/WC6v2SMk9jz9Uwt/Ja0GngnuNagN+DuuosOrFUxb+vIb+viOJgpMhZQ5YcDpsbm3CN7VpUSDuqlDj/ssXW7PdehVl6E+J6W+3lLRWuDsFVgjBYphIoA0qQQtOF6ZmOduhRRFePJOC7WHTFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 14:15:54 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> On Wed, 25 Mar 2026 07:19:56 -0700, SeongJae Park <sj@kernel.org> wrote:
> 
> > Hi Liew,
> > 
> > On Wed, 25 Mar 2026 15:17:09 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
[...]
> > > I will add a patch in v6 to validate 'addr_unit' in addr_unit_store() to
> > > reject non-power-of-2 inputs immediately.
> > 
> > That's because kdamond_fn() has recently changed to exit the loop if
> > damon_commit_ctx() fails in the loop for any reason.  Refer to commit
> > 26f775a054c3 ("mm/damon/core: avoid use of half-online-committed context") for
> > more details.
> > 
> > Adding the validation in addr_unit_store() would work, but it could be a kind
> > of whack-a-mole game.  I'd prefer doing the validation of all inputs in one
> > place, just before the last damon_commit_ctx() call.  DAMON_SYSFS is doing so,
> > by making a test context and try committing user input to the test context
> > before doing that to the running context.  How about doing so here, too?
> 
> Thank you for the suggestion. I have now added the check
> '!src->addr_unit || ! is_power_of_2(src->addr_unit)' to
> damon_commit_ctx().

No, what I'm suggesting is not adding more checks, but reusing the existing
checks in damon_commit_ctx().

And, now I think bit differently.  Given the purpose of this patch is making
commit_inputs synchronous, I think making more complete validation check is
somewhat that can be done separately.  So my suggestion now is just keeping
this part just as is.

[...]
> > So the issue already exists.  But let's ensure the fix is merged before this
> > patch, since this patch adds another exploitable path that can consequence in
> > whole param_lock deadlock.
> 
> Should I wait for your fix to be merged into damon/next before I post
> the next version?

As long as you agree about the mainline merge order, I think you don't need to
wait for my fix.  Please feel free to post next version.

FYI, the latest version of my fix is available [1] on the mailing list.

[1] https://lore.kernel.org/20260327004952.58266-1-sj@kernel.org


Thanks,
SJ

[...]

