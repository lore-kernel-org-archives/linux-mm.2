Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB4CBC98315
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 02:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB09E6B00E6; Sun, 18 Jan 2026 21:34:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87DB6B00E7; Sun, 18 Jan 2026 21:34:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB4206B00E8; Sun, 18 Jan 2026 21:34:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BD5576B00E6
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 21:34:41 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 529DF59363
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 02:34:41 +0000 (UTC)
X-FDA: 84347145162.30.8EECF37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id CE7F5A0007
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 02:34:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZKGhiebf;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768790079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5pPsugx0wKQdM6AAg+KjCA8yYX0qEeWPKN2pW2ZYMEM=;
	b=mLrLxid+9uatuUV3fG5MDqN1zK4nFEI2y5P/gl+c3sWUPiZ6Hb8vsAsd7ZScFdJ6qYyBFd
	hKSFYhPCFEz5OvnWOZbyjNzOdTtTJ84aov1HvU9dCGo9sq7foknQmNBasaN7Nujk3tKi+0
	klMYsKQNEsCJqltIqIZG62rCYB3h0XA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768790079; a=rsa-sha256;
	cv=none;
	b=l2qJ79eeswryRfzvpnyOLpOdX2vWJZnl8zwBykLX6SVCgTd4/Jdk1yXHW1SM5e8xUgMLKy
	ehOmKorDQ093mmYOjTrS/YzIAgaMsUNgCYbqwW+CcAZmuuCQUyRU3umWoZcNXw7iY0AFc8
	i2C/3/6/OywcPjU5SXm9cDxTcsKSQ8k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZKGhiebf;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 01CD660018;
	Mon, 19 Jan 2026 02:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68ED4C116D0;
	Mon, 19 Jan 2026 02:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768790078;
	bh=YVy/1y+q+QVasfuOK09hlzjhuU7NPNg3Wonyo/pdW/s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZKGhiebfTjbjAZzdeRmF2R9ic4BcynR0XIZ3LeGjkdjM5rECcyFPeIdQZFRD/WQZ1
	 WF5lIJx1xVmKmmB5lEseKryywNtXQ3ZtBhMt9sAzh9f8sqEUrDpa4PwdYAT6XNpRi8
	 2gzvF6+uuF9z1WX77IvNBChBpauX6F0NIam0igDc=
Date: Sun, 18 Jan 2026 18:34:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Richard Chang <richardycc@google.com>, Minchan Kim <minchan@kernel.org>,
 Brian Geffon <bgeffon@google.com>, David Stevens <stevensd@google.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-block@vger.kernel.org
Subject: Re: [PATCHv2 0/7] zram: introduce compressed data writeback
Message-Id: <20260118183437.6b11e6c43c7701759b73d22c@linux-foundation.org>
In-Reply-To: <20251201094754.4149975-1-senozhatsky@chromium.org>
References: <20251201094754.4149975-1-senozhatsky@chromium.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CE7F5A0007
X-Rspam-User: 
X-Stat-Signature: 1cgnjabisreh3mfff6mh1g181yso9zgz
X-HE-Tag: 1768790079-24506
X-HE-Meta: U2FsdGVkX19zyrw8x7Gbb49S0PEbm9G7ayJSQW8JG6RuXI5YgPqWhtn89/qBjx3YMtxkYX+aNJE7Gs7A/+L7sSJeNCjWcVRM1Oe1QpcxQ25ChzE7MbvL6gMHZsnObTrbdJovLpXb3PWPVbNzBpo83F+vpBzVZFGUUYffJu3G69WH6RsBu05hxM/oUJgC654IyJcA6cEj6IUfzwtGPjr8KEex9MrLvEBrfas40u+Jlv4ZtXVsbPmeed9XYQbWt/tK20edFy8kTTRdA86G6oB0V0QpGIn4yRfdOXVyqoPj4+CzgQgOrNRSw5j32g9/QbakuwGun5Zov7feVu/oKHXcdkQNYYxH1PhxKppv9mxaCZh9BVRJatt0UxqUJsweBC8EDYROxJR8ipXSwa9HXmZNlw+CLX5Gx3OtSMY1MnXxXbRaTLd0dHE7TzMUH43hCR2aWm/50iJU48P8Wn+LmpmpVyWDvm0F4vw+e/eiDoa3395q3yb8OMKd3vbCw46pT6PDSqIkRf4WKGhILPZh5oMwNaYybGAARt5m+L6h+3QwBsmR/CymRXhmGQDGvbdhG3Yl4UTsjCHq45ij7UmXN3z7t/n68eeAiz/mrOJVAAuue5eFu7+Q2iB22sUWS8vvtTnie1MWA5RmjmBJ/zf7TFeP3Uo5d9F0r9J+xPbWZhnsCPIirq13AiGTO+HbXBkTVtsoZmbiMnD1oMCx0xrzlmzZ92jytUCIN7+yPBdpEPHBKr7xDWuP8/q4jmFV/A+RqofLKCdeYz9lyFhQvgZ+XtrnXDvdzk27L1qgl4r4bzMf0SJQMA4lleedvKEvcaOskb2fr5es4G2lm8TthQebtAuJSU9Brse8S/pl/A08I+I4eUi3zFYdX9sPTaehaKtkRB1esPeDvX23jVjEbe/IBSurTTwfu4uBjpadFt/QNa84Hd4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Dec 2025 18:47:47 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> As writeback becomes more common there is another shortcoming
> that needs to be addressed - compressed data writeback.  Currently
> zram does uncompressed data writeback which is not optimal due to
> potential CPU and battery wastage.  This series changes suboptimal
> uncompressed writeback to a more optimal compressed data writeback.

I'll move this series and the "zram: use u32 for entry ac_time
tracking" series into mm-stable soon, but the review coverage is thin.

It would be good to get some more reviewer input on these zram/zsmalloc
changes.  We haven't heard from Minchan for a couple of months.  Is
there someone else who can step up and help out?

Thanks.

