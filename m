Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABFA6F3D315
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 16:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC1746B0005; Thu,  5 Mar 2026 11:06:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44816B0089; Thu,  5 Mar 2026 11:06:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50C16B008C; Thu,  5 Mar 2026 11:06:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B4F4D6B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:06:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C290C0BA4
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:06:09 +0000 (UTC)
X-FDA: 84512486058.30.490070E
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf24.hostedemail.com (Postfix) with ESMTP id D95A3180003
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:06:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="G48/mJtC";
	spf=none (imf24.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772726767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yoXLVExaeD40rMm6BLEsNzbF/cVQ2Kh2LQ9L0d5YO00=;
	b=vy5hHNY8tLCvH8Ym1vMba3J+iKyEJJsfeC+9DuV8rLWtos4vtAvAA2J2GsY7Gr7sfUNPbp
	6ZqIrjx7J7Mx4MgjYZhM9GAtqJWZT9C3qHg7ehtQ6sQNubh2AiRC4aguTO7nT2wrwEn49e
	ZE1R0rzQWYT+1jnLlXxE7h3n+AoXhxo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="G48/mJtC";
	spf=none (imf24.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772726767; a=rsa-sha256;
	cv=none;
	b=n6gCDmeS/gPY41IAqkRr6wxb+m9qkBjXhgC6xCA5Dws0q2CyKFAJlPEvcrICzy66H54w0g
	d+ul9+IUnV4PZu6B+cmb8zFVQaoNxwh0FY8HYDmV+kZQx+bLp5HxGKydzp+uGxnA7Wh7XZ
	87/y5eFP9VmKjIdfB8y/hUEJieWPhhw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yoXLVExaeD40rMm6BLEsNzbF/cVQ2Kh2LQ9L0d5YO00=; b=G48/mJtCY4pqf4sNMBVKTL4lmv
	LbtVcnZiyUmaBFfgSm6dkg7BW7aG+WGFTW2qN2xc/0+Qch05f4jp/nzx+N8dKAM2Q56QErHm63Yym
	jXoeQQu3Lx+HUMsyF/kknumyDtn3MaLldp1kF9wqQoB8SEzZeO8VtpzocDTC8f8JUPGc0zd9PQPFs
	BTBPAk4HV3x7SEI+FRhEO7DJtEXVPr50Qdv7cx3S+TVPoXb7VO98ursViRK/1xiTfwDz3b2GFCaWl
	8xwyr4LAmRRPc6u72ab28Ni5FJjOlhqeRd3BTZhNsbLAJiDeLm1ceXTDPHbaCwHI09XM2IcKuylBK
	MpJNh4JA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vyBD5-00000007A4B-0rha;
	Thu, 05 Mar 2026 16:05:59 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 97952300182; Thu, 05 Mar 2026 17:05:58 +0100 (CET)
Date: Thu, 5 Mar 2026 17:05:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 2/3] locking/percpu-rwsem: Extract
 __percpu_up_read_slowpath()
Message-ID: <20260305160558.GD2277644@noisy.programming.kicks-ass.net>
References: <cover.1772642407.git.d@ilvokhin.com>
 <6b1f1521ca186d5c402a65619d8f30fe83b93bf6.1772642407.git.d@ilvokhin.com>
 <20260304220223.GS606826@noisy.programming.kicks-ass.net>
 <20260305104703.2a1e8151@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305104703.2a1e8151@gandalf.local.home>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D95A3180003
X-Stat-Signature: otsptj8wm8rkh5ug417axh8ytq3rsgqk
X-Rspam-User: 
X-HE-Tag: 1772726766-514373
X-HE-Meta: U2FsdGVkX18Sh1IHp2Vq8BxS7zN7pTq3J2PR0+E8O3U6W2ljnMNVXUD3xQKHS0sVW0ty2BE5rzzQSH27IbAtH/pRyywUgZPhs/E9U/GDmW1Qvs8NE5GvqYpw4URUU226//WzKdPDsdV4WLs1Fziqz1GFm48pOpcqBTEPWQgvCMnqu0bWE6dy+sMVc6g8yBZRJUtFF6etRIuKuABKTRHAzc2EgtzT5zokChFkwTn3PdHLzh3BDIV6x7/H4tLPdsD/vVU4inMVCq2CtZL0LdgzczMUDlMUOzluJ8zwowACBZlQd40xt/mN6nwuahpEix2I0QEAuTSnp4Mulk9Zh4OMmLbDe2nUL+Z1qc8vrlcUWQ9D6eSzFK4TwMu2JsRTsQXGS+uIvHF4MuPfA4fdOoN1d5qf4LoOu1DVfHJoH3EYX6iVu/K17o8P/juaJBr4b5rc4E+6BuQb8i3xYJzh8yOghh08Jtqhm+ARIzH9k8LMunJV17A+TLPSiaCwGfHIBv5r7YLKOl7xchhpyhAOQJV3BRUh1MGJ0zGEtCPT94IvCiF0HaiuHy5v94YrmR01tZEG8f4oWmReSa1sXe9eIKcwFBCe3w19k0vZb7ZqE2oVC5Edudd4j3KxAzpGiXasRPcQRke56GNrSwnLjD37CHHVyTGsM774owzYAYDNbhID31DnS/KT7EmlPWK6uVCfueLnO1ohJ/527hIMNAMqHpKxvWUd2zURyUcZK2gWDW9q5OUryHNqAwY82yruL0Fk57FQZLEe0f4yyt6YLVm2wilWzm6sdBtono5Ft8SyYx7lFU9COTvR/lw+0Ek2SEqTsG7wnex7khm20mnVwQb2MOr56h+Er/D7ToU7XMIP1ivz6vuG84HKvbUMosUDb/K1y52QZ7tpr7pfb4xU18uyl1m3x2gcwkl6Q1xJVuLgQUmdDWSScPaWwecxkB9eUqzkENqGsppm1Cv6MRVC1lhgB3k
 Y3W2vzKC
 0KYJQh6+6HPuX0cTd2l4OIs+9JDALr1R3morjQy2xNFRmIxrGdj+MFoGjT59znGxkaTU/p2r02S7h9ThjHBFpTa86+1yknke8DbPVop2Qslm5jsdmPkYQbDTezVIKsPRNxNbZsEydromxAwXvPVWPvSgm4FzaT//UCkzaDITBk/EmzokgBNfbpUNqqaUD9AD5spBjZTa7hjlYW0Y7jOxPX86Uk0XE2QaBGNL4KmiUcm5GRg9xl51d2Ec9xXREhoDaQ78pecmh0pZRw/PCYX2RVIBe+z8cp4Te0RpBrmcFTCOL5Fs81zLv93heAW65oRFipuTp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 10:47:03AM -0500, Steven Rostedt wrote:
> On Wed, 4 Mar 2026 23:02:23 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
> > > index c8cb010d655e..89506895365c 100644
> > > --- a/include/linux/percpu-rwsem.h
> > > +++ b/include/linux/percpu-rwsem.h
> > > @@ -107,6 +107,8 @@ static inline bool percpu_down_read_trylock(struct percpu_rw_semaphore *sem)
> > >  	return ret;
> > >  }
> > >  
> > > +void __percpu_up_read_slowpath(struct percpu_rw_semaphore *sem);
> > > +  
> > 
> > extern for consistency with all the other declarations in this header.
> 
> I wonder if a cleanup patch should be added to remove the "extern" from the
> other functions, as that tends to be the way things are going (hch just
> recommended it elsewhere).

Well, I rather like the extern. But yeah, I know hch does not agree.

> > 
> > s/_slowpath//, the corresponding down function also doesn't have
> > _slowpath on.
> > 
> > >  static inline void percpu_up_read(struct percpu_rw_semaphore *sem)
> > >  {
> > >  	rwsem_release(&sem->dep_map, _RET_IP_);  
> 
> And since "slowpath" is more descriptive (and used in the rtmutex code),
> should that be added too?

It already has __ prefix, no point in making the name even longer for no
real benefit.

