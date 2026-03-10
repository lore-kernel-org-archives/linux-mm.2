Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3407EB1076
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 15:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EA496B00A3; Tue, 10 Mar 2026 11:59:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A1C06B00A4; Tue, 10 Mar 2026 11:59:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9BA6B00A6; Tue, 10 Mar 2026 11:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DDDD26B00A3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:59:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96C888A9CC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:59:00 +0000 (UTC)
X-FDA: 84530612040.18.6485892
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf15.hostedemail.com (Postfix) with ESMTP id CEBE2A0009
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:58:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=QGosPnBK;
	spf=pass (imf15.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773158339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5vlJfxBBCcVrEZ7p5s6NGxIJP61hQIWzfEdRwFuO0H8=;
	b=q2+8gUyizPZMpfcdTiMqIyps6vPV9KLdJlHZsIPKLYer/skypWzLAphGRryqZg1mo+1++H
	IHVOdSyvkNJCwTwYlvJYBinva3yGmT/gL2BKo3hEI59K8z3Bz6ZyZ02NsCL66BFVnbiHg3
	ufzGZYVihzb0K8EZEI25pZCmpf1A1lc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=QGosPnBK;
	spf=pass (imf15.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773158339; a=rsa-sha256;
	cv=none;
	b=6JuiQ58jTG//souoUNLAtVxEinrV3ZHqjfVSTDwwOk0bp6lmhJiKQu+iw4eBzLjHTyrG/l
	sOQL66zCgYmoER3df6ZyZl7H8wbe8gmKfntBBcSbYpXj+DZpUb6Zqpq5i9cvjPH00tsirr
	xB+NFprQC2NNGg84Z/S1/2GqvucfQ4U=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 291DFB3809;
	Tue, 10 Mar 2026 15:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1773158337;
	bh=5vlJfxBBCcVrEZ7p5s6NGxIJP61hQIWzfEdRwFuO0H8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QGosPnBKix7V1ImVswshZCyVbOuBq5zkg71RTX/QX0u0HSH+zR5Q/eAYmW9v+h3Gc
	 A6A/rgWbh3AucUHPVdpC1XI2qDRc0rVmkkSZBbedTLD1J/IIGj9ZiaaDnKl5B/G+DV
	 7GJhF8pHm9HJI8kKn40331lLMuKWsF53tgp9s55s=
Date: Tue, 10 Mar 2026 15:58:55 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH RFC 1/3] locking: Add contended_release tracepoint
Message-ID: <abA_v9g5p-w1-1fI@shell.ilvokhin.com>
References: <cover.1772642407.git.d@ilvokhin.com>
 <f8605471fd84ebff963c011aa98f79ed17f493c7.1772642407.git.d@ilvokhin.com>
 <20260305075552.0840e6b107dd9560e09e4f86@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305075552.0840e6b107dd9560e09e4f86@kernel.org>
X-Rspamd-Queue-Id: CEBE2A0009
X-Stat-Signature: dn76kzfc7d7qg9hd1bddbgf1gpezpwuo
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773158338-432541
X-HE-Meta: U2FsdGVkX1/Ocb2aY8Pm8jr5ueVnUAb8NLQpnwofuyKZJbzG2HQUR6AyaYqTUMaolG3M+07FCYWrNgVeNgMuH+4FsZkChj29WNdKn4QWiXxCTGUB0R/NmTFBZsZpOFYKNOiDMvuVKGXd/fPqO//nqhEyvROhq0ZltFt/8Z1DZJYr1+oUQLUv+pZ2YJyDcmvg+4Hhl1ZwpiI7SmcQ4hy8Wayx/60DgBMvbg5MwLtoDVRil1QqZumIBIFkLVue9Yngdw95mGTomXhIRGAaDcikdW63jLnfBA6Y/PEWafXkBIfZA1cHjEP7zqtgkk4wYfdglsp2j0jN2ON6AdkirfdLkiBdOeldoV/GpvMBlBuUWzN5wci0qXoOeiGMVaeuI1Ng7rfpQ5k/3V5o5YuLlM6sPtZ1sjaJxTG/ERsuW4tVX3tEbYGH7/Cx6jQXSY5SHx63prEsTYkbCjM75bjAKreyJ2TcwTSc53KU1uKF3HGzr0dBtL8cFmnVpxEO1CWbh37KRLkRQnmQhR8oqIUbIG58xgUo2tQqdUoC/cVxf4RGUXLCO5PH8BczacMPylbPTHC0KoEJFgvwAzNJlr65rsdoORoyNgKBOJXdhueqmGN+bpNrefl3Qum2YMPmGkSj+coqRjYPeO/Nw6llXNVxk2FO8pZ8ilLpEsMInvQXQ2ocCpiHkuNxJa37XkhgqFQIn4l1KLBGi1oRmOAoudBE5Zzhyi8TdNGYlyAiPwphsfWteQNrGVx2vYKG56Y9Gnlz0BbH5BTGL2USEbUPQ9GUij6YEmJEI08hpcY0iWf2InFDCnR4csfmZHd6tmdKkWBiqwcujMUpIYdN760l8SN/MsX5+FFMBYnpkH2w71T07D+u9eIJLeRMNWn1ID/eVO6Tdzgt4am4NreYOLjQuJQMrjEjG9w6kA0Yy8hij4aoJUiDAXNZPTKgE+gk/cTRcFr/ph/MPnmiioVGkr7q4o7o9uG
 yMSqBXey
 xzxzYvz+yGHMgne5HZVG6N94HQ62ENffjLA9MdqnVfZg5NPtjkRPLAKUWjN01OtE8ifK0N5YWA7CvzEhfqmjkIeMZPjkhPb1U/wNtOsVisxX4WMHvEQ+J+nOBgWU1OSUzztGMUZ1aQCQOM6ESUZ+w7LOyl5hHgsS8Z9dsrrr/FXDs5VoF0a65Tw0cBktb3OuNdcOVqIeS0uQoFAjyLG2FB/QtPy30aAWldhbE3b10d1Mw+tgB8WHxUeT6cQFJ5uhr2OMbakdq1SVEgdXmQKw5umxaKR8+HmsW0WL00BdR5LcLA2xnzyqO0XdJ5q9TZdPbRydtb029ImPJLjLpgkdgYDh0YyNdWO8e6SlKkgC4TVEx9c+bgUeqZbxq/yjNhK5HToTss7yDTuME41Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 07:55:52AM +0900, Masami Hiramatsu wrote:
> On Wed,  4 Mar 2026 16:56:15 +0000
> Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > Add the contended_release trace event. This tracepoint fires on the
> > holder side when a contended lock is released, complementing the
> > existing contention_begin/contention_end tracepoints which fire on the
> > waiter side.
> > 
> > This enables correlating lock hold time under contention with waiter
> > events by lock address. Subsequent patches wire this tracepoint into
> > the individual lock implementations.
> > 
> 
> OK, but I don't recommend you to split the traceevent definition
> and its usage. Could you combine [1/3] and [3/3], so that we can
> understand why this event is introduced and where it is recorded
> by checking one commit?

Thanks, Masami, absolutely. I'll squash these commits.

