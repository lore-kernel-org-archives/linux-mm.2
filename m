Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11188C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 00:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 219226B0123; Mon, 17 Aug 2026 20:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A2676B0124; Mon, 17 Aug 2026 20:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 092696B0125; Mon, 17 Aug 2026 20:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAC206B0123
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:54:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 64C56140841
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:54:34 +0000 (UTC)
X-FDA: 85112569668.27.DBF811E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id C71CB20004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:54:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RdH71YcY;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787014472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYxkamxtO++QzU30BmbUy5M+CCOHMm+4XKO25ln20BE=;
	b=Y1pN2lH4Nfmm8E8Otc3TM4spYGMvbM1frvjvaAhpzfPdFVis/ojismDPUXGUJpfgm6Cqdr
	aKGKv+eC2/000TcUYB6UCUyheJuikOvXbECkWPxaX5VZqUJxRkoaYLR6fOXTxD9MO8x4Qk
	q8qWpo7f6DIw9qgT/FqBLqTvfXUm2hU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RdH71YcY;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787014472;
	b=59+91/kn8p1ZFloaFdKMc5DbxWvqSuIRB0OM/Ruoeorlz/coVq5J2AUQuwD+OuFAtK8XDI
	GbWD5hdSTVpojS9RYmMtE2EF7ERH9LcXyeQe1lhgtR6XQ/knWJygArpeFxI3/ZPUcJX3xV
	sVv44FyFVSg8qZkW0k0nZjA6964M/YI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 49F99600C8
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71391F000E9;
	Tue, 18 Aug 2026 00:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787014472;
	bh=kYxkamxtO++QzU30BmbUy5M+CCOHMm+4XKO25ln20BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RdH71YcYgdqd9Sw7OT7AXDe5CrF3JW1Z5XkAA3ojRPCD0tk3ZbeXp5KwLbf7Z/FR+
	 fj2PeYU3EZprURD/X87BBxyDP2eNov6CUazX2UqyTSZVDgTZErEjUExEvJCB5zKH7D
	 EQPswksBr0e04vuokPNXb3NP3H06juZXu1equnq7p5t9PD9CC65KsrojulnHpypwWr
	 tsbBF3iSwqE3olfyLBdE3huLtlmRloZwc1iXmWzl7V7T2ayZ/xzHegZEe38w6u4zLA
	 7vug4Xg9FTSFCVwzS8VZf9jZ/FYSzYcQps+KO+mPjtBhQW1tvwydwPTcz7QpL4Gkee
	 HghZ44N0OyrUA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON (nano) Conference Schedule (was: "Re: [CFP] DAMON Nanoconference (aka BoF) at LPC'26")
Date: Mon, 17 Aug 2026 17:54:24 -0700
Message-ID: <20260818005425.88087-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260808162724.92408-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y9jphnusk7b76j46rsa84bqrbswk5wzs
X-Rspamd-Queue-Id: C71CB20004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787014472-978677
X-HE-Meta: U2FsdGVkX19RJW+UppWiVB8to6vtU4jt5+PWEYf9zJH84FTXA/GJwpZjJi+NEGkuhpdNHWjYkDy+3jZXf11hxvj6N+IiD93KPVov1fxuLXuvlt1rkanGOTwH/Fi60ZFsJ+jVGYMPrn/ltoxUYI5K0BDkecbVlg5kCdK1Ti0IM8uJ6kCO2Iyx0hljaVtriMb3Xc+J95roBAQW7wwtqGfc12W+hZ2w+TFdY9HzDsXLatlTbFmiA2NZ9SDRGrU3k8VK4hu12S+MCB1BFYDSAkUG4OO4jma9ooEN7pJI5wj3FRTXX4NLCVhBPkQdiut9Y3iE8mdSGkfRhOT8+RkMGU5y0fgPMCVje56QxfYFcPekY9XkuT99Ga+Ux6BZdbaM2f1soxOmJkYNcWUnFwlw02G3c1ivRJ6br7agPYQZlS2ayGhJnHm4Vzt1jE96UM/7/EoANZ3QK2FQ3PWzlD3FZKmtRH1Cvi6BBWKgrqCARW8WL2Rc3hSHWr8XfT3GP9PqNYEpdq0zCINejFK9o0FvAdjufmM8jns/EnsDwZAvIua9sXS+4l3hQD1hGeJv5sFF4q5BIWEafxQmVY3oCCAErqRj3bdPldICXqVV1U2EjmQBdhhFuAnpvYPUP8+kvu2RF9e7M4S1DpjUUEoSFEGpcbWVerG5cEBpR2dWpQ6+/hyiNK//qeuUCsANQ24yND/57nhkvQkzdoj158209vOY4gKPOgmfrh9vTOMH8MxhsqmuH8Qp6NlFf2d+t94xDl9dt+n4SHBEwEqwHLpPLMqCUBnakChzYYqIC1blCbkO7OLvOh7GDhof+xQDsWH5riWJopdUO6AXmhQ3hp0AbSCWC3CKln/1DI2pJIvmpF+NjAgmzUA23ptVriyWyB75Lc0agGARmvQ5uQ9tkfCXcF4yyaX+l/Aexcd+QwqgIWhwSHDjaKkoHuR242XoHSewHoFVJEmUZmo3ym3S7KKcj2/dJ/1
 /LBqRr6G
 kWt+sWEribi6FH9CJkPwKNOi9/Oj0b1XqfkY+pNNXd8WLW6GE9LzPkKLD/frFRzR70of22ZCFWd/d3h6jkMwaVniqvYaJB5Qp5EWxCzzv9Wto/DDWzbGzcbAyX4aGRvY5QzMkqyJNYlmwNt1PLuNybiXIdVi+jjUB7Bp2BNYiqWT6hw3ku+QXHOi/oRuMO5VRh54zZSlKIYPQbax95z6iO6qDzpRK6rJ4VMbzzwQeBFD3ssgK7UnjzkdZMxylPophbhXl4kNODBp3wMRhTv9YJgKw1Q6mXVDj+u8iLtyops+fbVC+L9pEkagzYio4fN+Oem69WKpOKXnSETkH21DEm8jGhbefjDTp4y5dKCyE8EakGyB0BJUXVn4AUwRIzo5E0q5F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  8 Aug 2026 09:27:24 -0700 SJ Park <sj@kernel.org> wrote:

> On Wed,  5 Aug 2026 17:33:57 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > Hello community,
> > 
> > 
> > We will have a DAMON BoF session [1] at LPC'26.  Because it is a BoF, I want to
> > make it as casual as possible with many voices.  Hence inviting you.  You could
> > think this as yet another version of our bi-weekly Beer/Coffee/Tea chat meeting
> > series [2], or the first Nano-sized DAMON conference.
> > 
> > If you have any topics about DAMON that you want to present and discuss in the
> > session, please send an email to me.
> > 
> > Example of topics include but not limited to:
> > 
> > - Your DAMON work that is recently landed, in progress/plan
> > - Your DAMON usage and success/failure stories
> > 
> > Depending on the topic and number of proposals, I will try to give each topic
> > 5-15 minutes.
> 
> We already got plenty number of proposals.  I'm closing the CFP.  Sorry for not
> announcing an official proposal deadline in advance.  Please feel free to send
> any DAMON topic, though.  We could extend the session to hallway track, evening
> event or a later DAMON Beer/Coffee/Tea chat.  Also that will be helpful for
> planning the next DAMON Conference.

Now the complete schedule of the nano conference is avaialble [1] at the web
site.  Let me copy-paste it here for your convenience.

17:45-17:48
Opening

17:48-17:55
Breaking through Accessed Bit Limits of DAMON - SJ Park, Ravi Jonnalagadda,
Akinobu Mita

17:55-18:05
Beyond Weighted Interleaving: Bandwidth-Driven Memory Tiering with DAMON
- Ravi Jonnalagadda

18:05-18:15
DAMON for Huge Pages

Guiding THP Decisions with DAMON Memory Monitoring - Asier Gutierrez

Host-side DAMON Hotness under KVM/THP: Granularity Gaps and Evidence for
Demotion - Lian Wang, Kunwu Chan

18:15-18:25
DAMON in the AI Cloud: Monitoring Real-World GPU Workloads - Krishna Iyer

18:25-18:30
Joint QnA and Closing

Looking forward to meet you all at the first DAMON (nano) Conference in Prague!

[1] https://lpc.events/event/20/contributions/2453/


Thanks,
SJ

[...]

