Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A6DAEB271F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 23:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D88466B0088; Tue, 10 Feb 2026 18:23:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D361E6B0089; Tue, 10 Feb 2026 18:23:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C42296B008A; Tue, 10 Feb 2026 18:23:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B130F6B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:23:20 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F70E87E16
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 23:23:20 +0000 (UTC)
X-FDA: 84430125360.21.F85D5B3
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2A00140010
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 23:23:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770765798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LIMenEdP5Y0kKO7AWQzH4PeeohZ/qQINRuv3+h3a+7w=;
	b=8YrEHLl+fbj757zn5mRClni00XBGX4ap1fASVp0uMVA6VjtIp9S5ouHMgE6xPnObygOFFv
	z1Enoq4K3cvrwdKqTSY7R4w+SlyJXM8iYMrKaeF76RBsXiYF4wQw28vkBQvdqk3rPMR0w0
	c/c5tns3GZH/2oxS18tTPgcjgErAn2Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770765798; a=rsa-sha256;
	cv=none;
	b=634lFjyuwfiAnrIbMoLc7HiecPuYMXawKA/B/wQoHdGrirv5fbARrgl74Ifa8kj4sKmeHI
	6nIvz+1UaJFXKsHkpu6vlf/NJrASaongYsfwH4Vmy/8IZXgX/t843P7z5ehzoyO6xgqhjC
	nWFOWBwg7YzerDDm8MMjjUBAOLhFTEA=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61ANN6xi006521;
	Tue, 10 Feb 2026 17:23:07 -0600
Message-ID: <684d84272e7dcd2ead0770843a7e0afc625c87c9.camel@kernel.crashing.org>
Subject: Re: [PATCH] mm: Fix memblock_free_late() when using deferred struct
 page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Alexander Potapenko <glider@google.com>,
        Marco Elver
	 <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 11 Feb 2026 10:23:06 +1100
In-Reply-To: <aYtBctm4TlHGnzXV@kernel.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <aYJBBs17B-SQXFqq@kernel.org>
	 <279931074239b7f3812c4cb3969f887303c8cc26.camel@kernel.crashing.org>
	 <aYL3zxuTLT8N7C8-@kernel.org>
	 <c3769af482913dd7ee9d5302c8afa990255691a5.camel@kernel.crashing.org>
	 <aYXDeN0WGQG8-cxe@kernel.org>
	 <bf0231accb89709968efb4d8e1be9970aeb716f8.camel@kernel.crashing.org>
	 <e5d5a1105d90ee1e7fe7eafaed2ed03bbad0c46b.camel@kernel.crashing.org>
	 <5a44609fe992624573a3ca0a293888bd623e2a06.camel@kernel.crashing.org>
	 <0344bfbeb017cafc0f7bd4433eeacd9bc802d9c9.camel@kernel.crashing.org>
	 <aYtBctm4TlHGnzXV@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A00140010
X-Rspamd-Server: rspam07
X-Stat-Signature: t5pw6p1n8w1m4cgft7ckrgpnu1mgmnka
X-HE-Tag: 1770765796-500610
X-HE-Meta: U2FsdGVkX19A3AGxfNwjYMBPeVonVlO9m16kURq2o0BOmbsUKFd8mfJZZAETyugW9rGMEx+GaMe4cj1oXqjEG8573VRwq5GkNDwDFCSOUjR/ck6L3+qWS66Z73gAmx+PWsnQC+4p6y8V2cU/exPotKMj/cjC3ANgtc3blz0tWHWYrI+1Fjdu+mKggiBfjPXjYUuBBAiwHRO7LS2IdopUjdQZidVGE8OORFD7zGIXR+XEKETp/UkVN4bL3SV1k30JZ3kooX2I7gl/ij07LxkAHEjWUGLA+j+Jg72ZooW7vexiLx6JU4dT6HMFkycZSDpmn7HgptfFmSaZsN11rClh44Ux+Ddhkte5NqoXwibBRfqkPXDkEshT9TJWWr3tGtrUPSOGNH73L80BhCkG+bOKzc9GeQRYkgsKBRBqESqP/6jALYKjnvRDV72SGpFl1VESqLzO367Qe+hHeRwDoaFFn6mhSHPzK+dlYL4dvelIcwzVEPgV6m0Ovlm3u+KNp7PVjBeebt9AC55L66R2Ed17fWUAzL7iYYeejx2mjpuJLs7aTaUjnbXNd7CYAeOoqbjFRvCX0MsJc96P6wb4SijrmCIYymiDQiHLvUkusmKakREEyk82UeIiLxSneffhsBi6yDdD01hXiy5BkN/M+i7vgf+LyOB9EZFJq75VKiyCX4/8NyC7g3SKskJwK/wnrhAy1vJIQ6glUO/+b+PqGg8hynLVW5y40Szkum61CoRS74lBDFHYYWF2vVsal7Iqbv2TKpqFlpTUjFIpehz77+oyYnvn/JIVcmcdCKF+f9bdLEAHHtDHMbN1Uuq+1G9aNRPCtheB6M4T23FaSuTm5fwWBBgKAc/i5MGVcky7sg7eO2E9RxkNQQ/d+9vbGXZwCSwv/urv8oxfpRz10zwFTrED5lwgF7epayfBRaPe0SrTHZTdmAUYNOgt0/CSumP2Qcviq3e54Ko2GKYt01WZDI9
 Ujm7kU62
 heoX2B3Hb9qKznAEGjCQ5F4xBkegYqF9Nltemup1U/WWJ2BA8sg/3YtgKguZAMiiLP71LCWrqjrWtFdqG1SUTl5D+VrcyLlQoI+BV2+fS2Zcbg9oiU0c+om4iYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-02-10 at 16:32 +0200, Mike Rapoport wrote:
> Hi Ben,
>=20
> On Tue, Feb 10, 2026 at 07:34:15PM +1100, Benjamin Herrenschmidt wrote:
> > On Tue, 2026-02-10 at 17:17 +1100, Benjamin Herrenschmidt wrote:
> > >=20
> > > So ... that was a backport to 6.12.68 and my original patch is
> > > crashing
> > > the same way ! (it was working last week interestingly enough,
> > > something else got backported that gets in the way maybe ?).
> > >=20
> > > I'm going to have to go back to digging :-(
> > >=20
> > > I suspect the pages aren't reserved. I swear this was working :-)
> >=20
> > So I rebuilt with a bit of extra debug prints, CONFIG_DEBUG_VM on, and
> > memblock=3Ddebug ... it's not hitting the reserved check, but it's also
> > not crashing the same way (still 6.12, I'll play with upstream again
> > later):
> >=20
> > =C2=A0 .../...
>=20
> Do you mind sending the entire log?

I misplaced it, but give me a few days to dig see if I can find what's goin=
g on.

Cheers
Ben.

