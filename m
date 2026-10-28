Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 089D6606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V+mJMXhQ
Received: by kanga.kvack.org (Postfix)
	id 295C56B05B0; Wed, 28 Oct 2026 11:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26D956B05B3; Wed, 28 Oct 2026 11:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AA936B05B4; Wed, 28 Oct 2026 11:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E93856B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:00:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7EFD12012C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:00:22 +0000 (UTC)
X-FDA: 85372345884.08.D32E3EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 079D612000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:00:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V+mJMXhQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793199621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNhjsUB7XcU5gCjg2sVzpbrcZZ9or5ow9SLiudtkXCY=;
	b=oQsqqF0D1g+phY6B+JxT/g9fK5vv7ZR1jc195GHNsWe1s2llcSOmT7HWHUqeiVwMPTay7K
	V3wXOgDjE0cLaryNWfc4eHiiDYlORhFwaL3LtzTXj75ywswh01QgS4ugPbohzbP+xzKvaZ
	B2IyHcBq+R6Cj4F79eYbwDP3q0VCDDA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V+mJMXhQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793199621;
	b=LWtpYHpqq9S+xFLqWXJEVoLKNpITAQRewMh3xGTAoCVD9kf8XU6sALzzCigHUPKHCO/znh
	xwl7H2oe76rDuGd+x1ZYdU7wjkBpNvjm4tN99dG15kDnUEuBr0rwMBq2eDkf6FTUNri6bX
	N5U1/wEmsiUbqMnROs07D2nD4V4KoR8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2330542D75;
	Wed, 28 Oct 2026 15:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960A91F01829;
	Wed, 28 Oct 2026 15:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793199620;
	bh=wNhjsUB7XcU5gCjg2sVzpbrcZZ9or5ow9SLiudtkXCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V+mJMXhQw6wIsVsBJjw9kHY6bX6+1owDJ1lCzj8wYPMRythrhVkw1Rf9bJrM1A+vC
	 PAlT5Mf3SeY18Oz75FdJo42kmBsoV8vXyVQ3OjlaLjCWzEtQkniG+MQdBIxm/NMCeS
	 iRyfijheRwoEVH1lpGddSBiFTeB4gN8CKaGrjlXYdlq/NiJjl2iqjBSGk0OtPd3MJh
	 un6yKF95PfXlcRqGKwOoDStOeumVIOEzrScLWp0cDfr+6chvmDnahtccfXqyneuoZj
	 /YtZeptlPISGaJYoMo1ZWR+0HZ7Kv+ymNUZVMIf5awiBvPMk0PBkuYSQRODgx46MeT
	 8pXJwufDJx4Ww==
From: SJ Park <sj@kernel.org>
To: CharSyam <charsyam@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	bijantabatab@micron.com,
	ravis.opensrc@micron.com,
	bijan311@gmail.com
Subject: Re: [PATCH] mm/damon/vaddr: preserve migration weights above UINT_MAX
Date: Wed, 28 Oct 2026 08:00:07 -0700
Message-ID: <20261028150007.163381-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAMrLSE7U92fKTBzRYL+hiSMzoMXO2=ZcQYVpV-90CF=193Khpg@mail.gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 079D612000D
X-Stat-Signature: tbqyii995mf8ssn86j4k5chgbywjnstx
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793199620-505544
X-HE-Meta: U2FsdGVkX19ogico1TRSmsj+dJjcJtPupj/r2UBUc3bzQ8VenfzgTPnyvpmd6753D5M7jLzIz1Fh3CMI1BwwiDyP6+mClDClNUKh/UGUyDMav22UT+EyK11wt5Nnx2pS/Yi5gcLu6Htc3H0PoHr5Wny7UtgQ8zNs7Hz35XpOp+mf8Podd/bf4V8jjQic+wGQ+fj6/pY3ph2v6zKeYugFAkgN6nJvGj+auzTjW+IYdI2rtxG3KqQIBLWsYmZf/FDPMdoq3LLq3F+IaqvRnDCU+f8xe1eRo9ONfzqRsJ4443STSygogerQ4RPtSG/DcGbJWADEwX+bpaiwcBaxgv3ey2esghrlj7JLbzjTXWtJMYG6n1ztNClBfcfrfZdg2e5svCD+D/kYuCewbxGdGwQH5sAgNr5VlQfBqazzMUxmGXVh0xggdeNo4thaIf8Vn+MPB9RpP3oc3uW8AY27kEpYDcaXr38H14DDKs2f5gDsFYjgsfykDZUu3MpkgRuNJE5JvjYdWN10mHkO7SF2uRmLJFC9HK0pG6fn9v6/KrTqIok21hLXXKdQhlhwpAex54EDvjV/+s2z1CgXQoqzSAvzUvjK/LM7j29ul6QVLwdWd7+uIF3JRcmONZvIXm8v904NGLPNcsMiC6Gk8TjGVuqqVIyNVAyncywcOnbAEHv3HOmh+fLVqFjp9H6r+one68Ghhm1saSHZp/Z+PWfS7TKNcu18YOhMHNxY71+HU4Ab/q3eDVeoTIc2KsTzjVZqKuHXRlYZIYXduQk9PiODiJgngHEUl3Fyh04D5DAjjY+b60jc6weacfs9EvMCC866xFcih3qrz3mhpVu2b8PO5Yi710hGbEdkFUmquWE1sGyzwhx1bPvE0h+kGMioat7BW6UIgbeUv/CJp5MSJPxpPW0uyvvsBoSz+UzLfx564tvmU0ltRHEIiPl0coSNOTD/E2EnRUjStz93MISFLx9ePQ7
 JMyLP+33
 Feo0zqyR8KTpdq0SP2ObQIgTFRH5AQVAQyuvbTfdVe4ple+loxVtPW+E/vYb1UXjTQW53+FK9OkgJaCME/+/BD+gLmoD2fGpD7aYpXHKna2hJrix9GqOWzfSxKNTaYjCvziO92zFmBKaFONj9X/Q1ILscLOL6hj7GHBzBad7oBasoSVUZObplxkTcHWJZDGdlDCOzQHiod8LPQlKdyhaznYpknfkwM0jbl143jYju0bOi13MzvZ8ek+wkbLr9GR2WozSivXlsL+LIan85tFbPeJqu/vuJYYCvHJUnA+VCfzFyTOcpUFRsGLrzNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 23:44:28 +0900 CharSyam <charsyam@gmail.com> wrote:

> Hi, SJ
> 
> > Even just keeping the current behavior looks not really bad to me, as long as
> > it is easy to test and only shoot the foot of users who didn't run test for
> > their weird inputs.  We can revisit after a real issue report is delivered.
> >
> > What do you think?
> 
>  I agree. This is a correctness issue, but I am not aware of any
> real-world impact,
> so I do not think it needs to be fixed now. We can revisit it if a
> user reports a problem.

I agree, let's do so.  I will consider adding the input validity check with low
priority, since it might help us getting a real issue report sooner.

> 
> > Please avoid top-posting [1] from the next time.
> 
> Sorry about that. I will reply inline from now on.

No worries!


Thanks,
SJ

[...]

