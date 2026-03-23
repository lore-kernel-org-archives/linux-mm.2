Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2107F4613C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:16:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500016B0005; Mon, 23 Mar 2026 11:16:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1126B0088; Mon, 23 Mar 2026 11:16:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EE1E6B008C; Mon, 23 Mar 2026 11:16:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 303316B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:16:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD7E48CD36
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:16:16 +0000 (UTC)
X-FDA: 84577678752.19.4617396
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3D8601C001B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:16:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NuBfxsmj;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774278975; a=rsa-sha256;
	cv=none;
	b=vgQ3jqm3TC/W5dU9aDgEBJnp+5kFyee7vSMeFq9pv0csA4UOwwwQkVFt6tlTOOggL8jXjm
	49XlBS+l1KeoiZldIB/+BdgQlbLQi8a1G4n5CDMfkc40lpMF6iDorfImDywEcLYvgvEPhw
	9tC6euMvYRzkxOIlwcZgwNH0TBcg+lQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774278975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MgLBSHEh8UXx8Lwl0jotaSYPe2tp0FAANULSTsLkn3Q=;
	b=AbOvEgbLYTnzXztzVAJoGre9X7JkZrE8MfnDKf+2NMu76vlbazen2ylTiENXGAl0PKNHkL
	j15LF8wDG5Hg7JQznD16Sry3NUI89CqhFO3P3ytfi8tyPX6vbo7B0MErcKOqXFac1d54oI
	B2d3NbkVZZEmSebf/QfyL0HPsDNyajk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NuBfxsmj;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 99D636111A;
	Mon, 23 Mar 2026 15:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324B7C2BCB1;
	Mon, 23 Mar 2026 15:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774278974;
	bh=rdbRhrKbHgPbTB2eBO7rPqqHzWm6kls466VYWyJawKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NuBfxsmjLxbFgFWYVtf/btgoy7qNqLJvpYKEUxhbxEREXuWedtGIOvofsBVEtuuAE
	 p1WGwzHpb6B1c0wjTr2tegrC0uJ7OF7JLXuLTQeo5YAHbCpUmRpuZJm+JhMBMV3ymQ
	 mErs2aF9RDwVEeAevgSwC+IDsUcM4frXP9tUYbcz+ZxgI4kpztC94TIEvaNoKoaM0h
	 SwpUX8J7m/XFs8FspLbulnkAorpu6iMxX1rfm5XftzB48jcyIb3UNjRmoB0uB52UMC
	 3/k78opIpuZZSrKHp+kNtSlj6fEhg0xwqalyYTz6oS6JK42BP+KIy0AJrSg34j42Rp
	 E59DZqMhjRrlg==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC v4] mm/damon: add synchronous commit for commit_inputs
Date: Mon, 23 Mar 2026 08:16:10 -0700
Message-ID: <20260323151611.81358-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323141955.20535-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3D8601C001B
X-Stat-Signature: tiwu1i18cj5xw3xmot3si4jioi6jnbnd
X-HE-Tag: 1774278975-928196
X-HE-Meta: U2FsdGVkX18vF6zdqfTcizZzz50m9vnA/L+l8rO90c8h+Tk7r6P6z4lvu4BB6WlJsFkVMzSH8u/OWectgpPsfC8rDzBsCyOSfyyzML+xvxSKZE/VHBooHDNIQNiFRKMM5Mn/1Tv4rhFkta9waaFNM7VJsSPKD55f4Fel/pYvjS6zuk3Dq57wA8kZo5FoIBI5BywY42g25S5ufhy5g3hZOUT0GCdOz87oKdduPVyY+2fMEuCYZl98DAFl2kA6afGH+4TDmSxxX7P7cr+LL5a+zy9WuFiv+M0aBIuM15Lyxbd2qlAasc7cJ96o5/RDsFGbW/MFY3y8n6vc7uI4rcSX/fcDMfi41l2vZKwE0BHWdFU9NDrpchZ0ZUHIekkAJjLdWU/akVEEO85fSz9Tc87flLLExVDlbP+uQ/dot9z3bLPO9IC5PYHEXym9fPJgSfFErEg/kQl3cXS72ZLa1vE12DxLCfRYydcnTr7Ya+s5SgFfPHqRwVdMHXr0nmVbRF/Li35WuiUACDxmv7U588/Szyzqx3VOk5Trw/8SqRS6kpsrLR06xiqsQLxWpDyUX4MVigSGxPorqatA5gzmCOYVWuL/iY+uwHNjBdlegSOdEyCVjri23EzaIT7Wq/5ni2gBHjNx9LGws8iOWNMvndV8k+mqxATMol467iJy+JIvNpOgDqdO4U7bNytjk8C62l7JnxwxsftxA5jwGl8/ENQlss80Rao2NlY1/jXJ0bPcK9CZjcb1bCafIH9UVpO2Fv3IwX28ZGS90hlWKuIKaAE6w9UZea2rm3+1PQsQjs8Ez7QsBGdYarP81U3wj6W5iCqDyqvKoO+48Fke58lIJjuzlKQi0PigXqUWnnTABCCoLNzhC3IFY0ZUAK9a4O6e8HI6cOUocPgmvHwohudiHbSVuO7ynfYk9g9zKIbqs4FzKsnuVSrYJ6gqBcCkVzpmKRuqi/LqHLgVudtnFYIjRKj
 ty1XkZI6
 e7uGZX+epfAG/77ybjmgCA9gqzp1mbF0/MedFRsXtlrZnQDxUVFrtgdxX33UTCr5nqkXWIvFK11AQvHqxcIMyVH13qs+TNC/g0dFiKz82LNBW+xy76MksHr0I9Ptn3wdYFMWwqIm9CkoZnJOl3QwYyz1yWPe0h8Mz8I5wrA1tXmdHAYCk7DmRJll4HQ9CvN+aE/kiKnuVRa17ZYZrziwAwYDuiWQbM9yUayYa+flmTmEGbu5DFCGj513b9Qdg7qPABlgpYk+qXTBjE76IB4+m8cg0Cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 22:19:55 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> Follow-up on my previous email regarding the locking concerns.
> 
> > I admit I don't have an elegant solution yet. Here are my current
> > thought:
> > 
> > Add a timeout to wait_for_completion() (e.g.,
> > wait_for_completion_timeout()), using 'damos_watermarks.interval' as the
> > upper bound. This prevents indefinite blocking of 'param_lock', though
> > it still holds the global lock for up to several seconds.
> 
> After further analysis, I realized that since both 'commit_inputs' and
> 'enabled' module parameters are protected by the global 'param_lock',
> stopping kdamond gracefully (via enabled=N) is serialized with
> 'commit_inputs' writes. Therefore, a classic deadlock scenario should
> not occur in normal operation.
> 
> However, I'm considering edge cases where kdamond might terminate
> unexpectedly. In such cases, commit_inputs_store() could hold
> 'param_lock' indefinitely, blocking other module parameter updates
> system-wide.
> 
> To mitigate this risk defensively, would you accept adding a timeout to
> wait_for_completion()? This ensures 'param_lock' is eventually released
> even if kdamond fails unexpectedly.
> 
> Please let me know your preference. :>

As I mentioned on the reply to the original mail of this mail, I think such
infinite wait will not happen because damon_call() is aware of the kdamond
stop, and therefore the timeout is not needed.  Please double check and let me
know if I'm missing something, though, as a reply to my reply.


Thanks,
SJ

[...]

