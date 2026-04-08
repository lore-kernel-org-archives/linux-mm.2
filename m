Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E1291073CBE
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 13:54:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A29F6B0005; Wed,  8 Apr 2026 09:54:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67AA26B0089; Wed,  8 Apr 2026 09:54:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B77E6B008A; Wed,  8 Apr 2026 09:54:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7416B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:54:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F3CB51A0120
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:54:52 +0000 (UTC)
X-FDA: 84635534424.23.B7AE9CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 48ED41C0003
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:54:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QRa67WlT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775656491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROsaxkUmsK9dQT8Wi+iwtU1tPZYRdlLs0Vtp0MHNi/s=;
	b=dQRyg2jduNm6mtDRUfknsaOO20yU2fK5HLSGLWRfqDUCf6MdiWYFEZKKbfR0xeXsnuByE+
	Odr70zVV2JVggBCI2uFsFPXct7r2+tQui3w/WwrLSQrjPc1iCmE4NwHdoPA89R4KJYtzjj
	fqfh5RbXMQhqDjucdaEvVy6Z/bFv3sI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775656491; a=rsa-sha256;
	cv=none;
	b=C40D37l924WyFb4f/rG1bnxZi31kDBWJ0qhTiTLuII6U+mRLW4GHVxSARWEKOoMgA6cuWp
	KCW7Tcsr0wckwOXfIzbW+zCw03T/wwBwE4fBItpFNdzv1LCg0JyKxS8VNLEZg0fP3uAnhx
	sgEwSbMOn6aCUVOpKB8WPJPf+gBBcl0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QRa67WlT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B661A600AD;
	Wed,  8 Apr 2026 13:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B89C19421;
	Wed,  8 Apr 2026 13:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775656490;
	bh=ROsaxkUmsK9dQT8Wi+iwtU1tPZYRdlLs0Vtp0MHNi/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRa67WlTM5SuiVWoEOlaqi06yAIr+JapoBgqqErFeWIq66QdFKiC+C784fxuuzHvd
	 HCeLxllrOAR62N7GZEYynFMLkxyIarc+6APAOml+UoJPiugNPy9WZVmbMaMmgp9yFc
	 I2x/YXVZQvPEpB6xgU3YbHTvl5U309py8okXl+l9bLc61l7M64uzbA7/nNTaHvSlTd
	 qmTsf70+/7ka/96rvClfbcrFVy090CAETx0FoQws3OxoPWtFchQ3EGpSrMNH+E1U2o
	 GagdUFNtJ8uwaOK5rqX354Ybp5N1P1NfjuBf7Os417JnMR+iOhoK4ggBHtZdSeFDom
	 grp94QcXnoyVw==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: (sashiko review) [PATCH v6 1/1] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Wed,  8 Apr 2026 06:54:32 -0700
Message-ID: <20260408135440.88978-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y17YnrOe=UXWBMKJ1U6seKJuauDqAdTDYo1cCYnrP_vSFg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 48ED41C0003
X-Stat-Signature: dhx5bfsefo88r7xigx6y1i6iacqmqnme
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775656491-205390
X-HE-Meta: U2FsdGVkX1+bJMISY47AEsTd8KY1y1vjTYs2zUKEdbO4PrE0xfNJQ4xVCzkywSMJw18vigs9/A6GkyzW1Uin4mEWivn+Kck0MfFui3zFKmJ3a3qU9OfiDysqGwZYQcJt0jINzaxKmBrCRgkvgC+orUcC2w3FuXORnV8tURlY4X/IcINYIg5FVIcnX0QM/W22YFtl9SPSWuIBQ/NoLi7HtRHVeW3xpKfV2Avgm3NL3C/WSdnGgkop3pTKSeJ0AJSzibNgzQp7sLnLKUWfReGc4nwORbkhn0EkYjQGch3Yj4F1sNAGc24y2AutROEp7QsNJmxdvlQraEPkoy7x5+OaTTDH8dgtn44kbkpE9QUGg2NA6R1tUBNsnCEFmr85saymZN5lENYRFyXydCEK+1OdLTTD68I4FReLs5uMPWtdX2Q+yvjo833OFZBV0uyGhQobdAn4nlDvZWaw+0nLyKHbzPscXnPWRSRMKlQnC6iGuUZs5pXqssqP+EhbSMb1rq1Jquy0D75BhTmf/Dt1YY6XKFum39Vc4nwOiIy1Beuc/GLcSweitTNHrj9ymIlcySp8uqknlbRy850l/iEGYvB9M90cgrfW7zKpvDcqFStaQEaBHVtyWfvdF7thGTY+TFgle1KeDknYhfdaXh1n5N41+ET44wyNJUQN+ojkHTAEy9U/XvpveLNunir/Q5epnR70wmannZi4QUeWgXbQF1OEYbef8vsJCnf/4pi/+NcTqImCHUhK/PvMiAFfDyacZKxJtQyU7AZi0XCSkqq3R8TxhrojG1tsvEgpKml9xf+6zMCwNIzguCO8P2b4CCDY/K0Dd156+nFFO4v4xVMf3riVOK1PjsG5ku0IyLNm8ub/OfLubYHtOfZt97dOayZ4dtuvDWZ65MCbqGD3NI1w197TkS59OHOgR1H+0ULVhNnttmSKnxiS+h0nXJooEyZJjy0GjmgVcq/rhFd8FaPY3OL
 dX5URUyv
 e9xrAsfvukRPdo2ikI9gFcIh3+3Rvmzy/ZWpcT6Yi5EG74el0Gbp2PjiGgYZ8gE0tH77I5WavIGBVVptxrbbhrMVAfyKYBzPLfIQ9CWXWzcpigUVvkLeWh/kqSvazWryX4ACVO1arklr9r8chW3QCf732FcmGyPmwgzYQyFkZMoemYzVum2sAX82ElKjozQebz9aKIdU47jZpz2MR3SimJenrZ/AhVGLgF5TkwRPL8CyAQd+kv/UCv6jPGxfeGEE9BGMt+T8qkXSyGNZ2VWJHXdScN+aaSMX6aWAPTFWSSZLaqQV7JIJ8YnL8Ww17bRSnefxZReCTeGvXcJ6LyrP8+0sjX9YGUNvKzA1/bd4QnD5wDTJ7T4tout4WebbtR5v/gH89GvyoP6WpuntjJM7IwXudvylzVnVhx8gv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Apr 2026 19:33:43 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Tue, Apr 7, 2026 at 9:05 AM SeongJae Park <sj@kernel.org> wrote:
[...]
> Yes SJ. I think we can make it work with single goal now that the
> below commit is part of mainline. will give it a try and post an
> update.

Sounds good, please don't hesitate asking any questions.


Thanks,
SJ

[...]

