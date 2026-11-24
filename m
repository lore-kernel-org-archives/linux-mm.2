Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6959260A261F
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 09:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i16rhzZa
Received: by kanga.kvack.org (Postfix)
	id 7C2786B065D; Tue, 24 Nov 2026 04:44:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79AAA6B065F; Tue, 24 Nov 2026 04:44:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7046B0660; Tue, 24 Nov 2026 04:44:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 434AE6B065D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 04:44:52 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE831C0704
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:44:51 +0000 (UTC)
X-FDA: 85469528382.05.805E8E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 138C3C0003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:44:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i16rhzZa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795513490;
	b=JL13gMc/UG+1nvIG8VERkRKPrSxCRjXi5nyhi9Q8+fSJp+34HRjUREtItrIZ0QYDGtv2xG
	g1v9L988Fd8fp6vAIjJv3k8yiiWakMgfILFQmHk4TspemHJ3W5kcRvZnQCO993I6Su9oR9
	QC6Lt+PwSZ1ACwEpkMI3Im3U39+HdXM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795513490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HnOzN3LRaQDuRBcHI+MdzqsPJwreZ1a5NnvrvFAOgeg=;
	b=bgRjOeFZGonKaWI1G9qxCC/uAvcdJ47jjEyr0hOdWdfNx1W6S0cSkljTmIeFo0k6k+SwaL
	RfovBTeSIoN/Wq8eYDe0gWXcXP2dY73Bc9OICr0bWTOt5dm/E/uvOcjyO3CDsEhh5Skk86
	QaNA2a4K+yvVARImgxr1rC1KWTLd3Vc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i16rhzZa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B1104571F;
	Tue, 24 Nov 2026 09:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AA01F01566;
	Tue, 24 Nov 2026 09:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795513488;
	bh=HnOzN3LRaQDuRBcHI+MdzqsPJwreZ1a5NnvrvFAOgeg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i16rhzZaDOXQXkpizc4tlDKvcbJo4VByVRMpaOqLeoOQMaCjgI+O1aVoy51/KRs5K
	 D9nCmDf9T8vWCXHIH7ceQvYNVozFeB3lT9jSCgYMCl5UP9JG+2qNR2HOr/xvfuXcLU
	 0YC3CXaaM7ZLyk17cXbzdvRCR/HnHq454CLmphFbjnryChzWmkLFGqZ0Yi5u+UBGQE
	 zdipP2XVhwOUipfHoLk7U4jvpka/4KLcXI6V0Zzryr59e1FYcaoGy3OXxeSIZbO1tp
	 APAaEO2nJyQaEvdlsESW1fnlRASwKGXZrb3066fumaTPEHuHI662cCbeFPm7gK5VQd
	 nJDpxZxe3GtXQ==
Date: Tue, 24 Nov 2026 09:44:42 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, david@kernel.org, akpm@linux-foundation.org, 
	kasong@tencent.com, baohua@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	baolin.wang@linux.alibaba.com
Subject: Re: [PATCH v5 0/4] skip empty PUD subtrees during aging with a
 PUD-level Bloom filter
Message-ID: <awVcG_YxoL78TycT@gremlin>
References: <20261123085800.981256-1-baoquan.he@linux.dev>
 <awR-UsoEGg733fQA@gremlin>
 <awUuwi7Jwt0BQfJs@bogon>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awUuwi7Jwt0BQfJs@bogon>
X-Rspamd-Queue-Id: 138C3C0003
X-Stat-Signature: u3sdybatyzptjswacmged3uj3ky1z3pa
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795513489-182615
X-HE-Meta: U2FsdGVkX1/Jdh9cLx4DWpAOMliZgM8Kh9JVJKFyA57CZ76cmEDHZK1USgyUdfuACVY96hdZ2+XD9CBc0JRIFarRh64ia4rz26LxF1mPO7PDIRAKdsJXdgihvZ/7mPxVz6FfZAldlmEHeuUuqyi4K3bda0iLqZALFa9p37etxOrxhyzSHbdDS9J7SaPmj1EsRItNBfTIRsV6VU+IavzE8gzkRI3XIuLFfml72S3oZT2e4GGJBy1vQmsS4MQuxTf49Z+mTY5xMwkP4nGqfBuP0O87o8aFLyk5g3TaW3WL+FpQQ3XEnNoHHbBtKN7wnJa1YYrbxfWJy7PppMtPn/S7MX1eFlxckY3IbYPqyTq0+31K69RyLT1NTE50SjCwdx2R0b66ZgIjOcOUrfK8WtzHX5k+E7yeh3B2kwq4PsB084jZaVW41m7PPMXfglu+VcrsG+tc5043MnmvhJ7lXb/HDb1HCCRQy24f5WKq10p5h8x7brp+ZZ6di70bONgvb4ibTQmtVXnBlTcHs+ZG5NguOVz7gyYjnMPh81JnoMDNMkgSUzMcyplLcefR70jxLsqmA1XnW7UyIsF4FuFFdhEubFrWqkuh3n3ear24n+ZTV0AwZ6yRTCLiE/3tpfCrOiH5ygstVvy4XefFtABkXeClYX+W7ja7dQRG6imqpgNkarMH7FrU8+rKgOc7Ps09xr4gJHpFXtTJWOKR/1ie1WUHCp3tj+4MP4dz8dV3KXdDuoXVJSj3RL6OK6NinoJyNHRO2vKIAa3B7Rqlwqn/iWIpUAWiP1wPEAWnp57/w1QneUarsKbwk2PXTLxAtakxaI/qY6Pi9a/PU3Qjc/Ab2tnF89yBkgzXzwzq5qGR46TwfawqYHlVv0KMgWSStM5cey70I+nVyKRjabZXMNxjctfTJ6KK3A02x6z8gLRyA9yhtqobc9EPkVQRHgCYjY12IkjW8dwghqnXl30jjffi9TF
 WfKX9TRV
 sJ8kXwyT++Yejm02uQmlP0kwyEPKhQPp0flTBCFsh8V+H5DQpS36Uay/xV2HLIxdNbtl13dMDdwJZfVVtd8ylOFZJPeZSX+JNXmm/Ga2mTvA3wqH5HfFcWLS6Sm66q07GSFn1910DrbkJVHc3nQekZ937K33v5F/uw40gMnvx3pb5p6yH2JKwEl4qPo1MZ5xUeUjR4en5R4QpFYjFMDNZ/SjKgxt9ZgnPE5VjUH4HM684BAZDMD8fyhZ6Sl0MlqkpoF02FH5snxe9bKGSqF4p1XxrvOAve2D/FZ2FPUvethw0J/S/vsZUYEcO5vT6PtnXWas6TJrq9dHqIv1MHdWqj8SX+WCLIgH/Y/BQuEJSGbkULC0WJ0viumsfcqiKOpMKXAW3Emfz044/SfE72BJNLQ5w8uL340Gr6l78ResLkYgadn22M7QQdMYsICmKpAvl/tb1PPB2E1CxNXCTUYGd4Mp3hmhH53ClrIv/abZVnkN58bCiuLwp/yAOg7M2C5gCSvZR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 02:29:22PM +0800, Baoquan He wrote:
> On 11/23/26 at 05:57pm, Lorenzo Stoakes (ARM) wrote:
> > (Got a script set up to detect things not cc'd now)
> >
> > On Mon, Nov 23, 2026 at 04:57:56PM +0800, Baoquan He wrote:
> > >  mm/rmap.c              |   5 +-
> >
> > MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
> > ...
> > M:	Lorenzo Stoakes <ljs@kernel.org>
> >
> > Please cc- me on rmap stuff, thanks ;)
>
> Sure, will do next time. I should have used scripts/get_maintainer.pl to
> collect mail address, but not copying from the old thread. Thanks for
> reminding.
>

Thanks, email-for-development continues to be... fun :) though I do very much
recommend b4 (i.e. b4 prep, b4 send), I resisted it for far too long, but can't
live without it now, it just makes everything super easy.

Like:

$ b4 prep -n name-of-series
$ ... do work ...
$ b4 prep --edit-cover # Write cover letter (b4 adds a dummy commit in tree for it)
$ b4 prep --check # do checkpatch etc.
$ b4 prep --auto-to-cc # automatically figures out who to send it to
$ b4 send # and off it goes

--
Cheers, Lorenzo

