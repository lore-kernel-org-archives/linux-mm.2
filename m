Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DE401112246
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 01:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C982D6B0089; Wed,  1 Apr 2026 21:14:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6F646B008A; Wed,  1 Apr 2026 21:14:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAC176B008C; Wed,  1 Apr 2026 21:14:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AD2256B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:14:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40908E0628
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:14:08 +0000 (UTC)
X-FDA: 84611844576.23.0108480
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2B0BBC0008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:14:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AxXGZbst;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775092446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1BrIuh4JRk9mChsYnd7IZf+UTRPtmSlQTkGsjvBknE=;
	b=n9wye9YdDKK7VW3A1VZao9+tnMT+WTwVj3sqyGEvhVMXFqTpe4kNaJhf16nBdeILKIewDF
	u7LC7CaKimJI2hCMysOQWItoMxWGvVuSP3s2uekpTi7Fe+39XSrQxAJ/RDPsFvxno2tOmj
	+ZUT1Av16iNOmnHqQF7kQQl8JpX65Hs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775092446; a=rsa-sha256;
	cv=none;
	b=hjjew85xKU3tIoAfQW34mu4DdPDkZ1CmBLsVOC9pPRfYqCZvGCpaYTbO7XxPAf1urjDckC
	IPeQ5zYRKOVIVi+JhYkaBeIEt7UXt6M4qMSzqTBavBzS5p5aj6GMl5GHq2318XijhbNZYJ
	UojXJoltYRLDBJEIt+3IhDm8J3oh9EM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AxXGZbst;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775092445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b1BrIuh4JRk9mChsYnd7IZf+UTRPtmSlQTkGsjvBknE=;
	b=AxXGZbstqJfgejh9XjIA7kLMC2aTW2hZoITYdbvtWpQ5Uc1FG8p/mkbX8G1iVt7WBTi6XY
	D7fFi5Afb5jA09jZUgUxd94Hhz8XknCx0+g7pnbltR2rDvXK16knbIzcwceFuBslK4JBc2
	h3iAI6pgrB9BUOCHUDy6LfhuboavSpQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-304-RM-cyG3sMXiA47fcz3YQsQ-1; Wed,
 01 Apr 2026 21:14:04 -0400
X-MC-Unique: RM-cyG3sMXiA47fcz3YQsQ-1
X-Mimecast-MFC-AGG-ID: RM-cyG3sMXiA47fcz3YQsQ_1775092443
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1AC181800464;
	Thu,  2 Apr 2026 01:14:03 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.80])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E57B319560AB;
	Thu,  2 Apr 2026 01:13:59 +0000 (UTC)
Date: Thu, 2 Apr 2026 09:13:54 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [PATCH v7 4/7] selftests: ksft_exit_fail_perror: support printf
 style arguments
Message-ID: <ac3C0iozW_xgS40r@gmail.com>
References: <20260330151503.670415-1-chuhu@redhat.com>
 <20260330151503.670415-5-chuhu@redhat.com>
 <efbad6c5-8d5e-4774-8d0a-d455e6e2c182@sirena.org.uk>
 <ac0huDc_GH2uSgsZ@gmail.com>
 <20260401143831.31f40405758f78d7955ff6db@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260401143831.31f40405758f78d7955ff6db@linux-foundation.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 1gBcZ7tLvm6DDT00hM4ud3sftSLqvyKDgYLk15BFONM_1775092443
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 2B0BBC0008
X-Stat-Signature: ny3ocmodi75q9skhjbwwf997d3p6fgek
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775092446-600516
X-HE-Meta: U2FsdGVkX1+P3UuyLSVifmRr+qXG7d7bbaajSUQZWiNzVbLBo9uorHwBR/aQSIfz4DRqmN67qJ3iDLwV8tqHWmgWq8JkPViQVfMX9dz3ESfMCKc/vTDrpT9lV61LbiezoYMOxrnstvdLlF/UHoesIzdWLV64/fzH2EuA933KI0HvX5k0xN4xkVv6WGZeh/gymptsU+44MGLojS7DoormMi30mMblRU5pa589SizU/swm5XHn+V4HaDV/FwRq+BbVnNcc4TWdZIbwJVxwx4ayoEAhNmFpj1nFcTb4wHPgNJhZlNI2rbR1cfFjUY90GKp5m4n3ykKIkF8N2iae53//oS+9wUCNlEJhtZkfyH1K8WGr4WrBh4RXBAF49gXYJn55fMk3GD7HubLK2/7Wd7JLg5dMgufuQ+Dm3a4RVRBsnb+uX+fgcSAo0+H3EkYhIM0viywFVqKT2CGDOO3dynU8VZZLHS9HJhxnKHr+2CDwjjtpgVrkQqKAebL9HgPXOiaR4ty+/m9MkfWS6Wsv9IPWlVeHSKjapUGOE9O+BO4oBk31MACo3qz5pIJqZElgdxyXjww8Z1Ckr4hl/yJe+T8hnXz0Zf8Oc/isrHIPt3wJ/IpT+YXiDwm4YUIRCjYtzKkI/y8ZRkddS4jFmGZZoZgFFDO54Gy2kw8YbUAlXcqpxc5/5RCMXuBCKexPW5D3t/fg9umOLSQN22ug7yt1zt32oyZeiyki/X+WyOSnx3nJy50IUAUEwZTjD0OoR7qd64zYp3pX7pTxcwe+z8ZAGYepZ1dvhTaDI1EV4xUmt0/rtFgS3PjV2vV8dRVZ+tUfTH3SzTaB7jMY0On3VGohdwWGBmDMVbC7IOw7TRx3a8xm+K4pAEDLDf1CHv+oLDSqrsTdThWtOgJWwGNjRyw5GvwN+wZ2hvTqdAU94lzGLD9UY6PXmGWoP+XKY6D06R3CbYCOV7E8fny+cS7EzrxLXjb
 ymRTVbFm
 oSFwhlageElBmjqFqgoirzWVLIugC9AUJGPSuxLwo1ag0EDmfeewK4u1pvIGybZQJADgiz14AlK+q9PVhNdBiXAXJ9ywNRVGnIYbraLiUiP1BRe4jWUEEbLhNoy50SUZv/M7EMWsDrflUoS6umFdvInvXr83tkzCOtHzbO6FMdeWVBpUaWx69wiKFZruBveRlkL8lQIed3PvUp0srbpyiSXMVun2hHzE/2r2O/zsS9PkmSpajL4ZxpVdBRzqQQJy7nXesAMbaH9h5bj/B787v5B8+z1MuadqMYoxFOtzIlHdDMS2Eq3JnLPbldD46IFMbWVmAbiJE0FoX/r/JdAZs+MQMwyzy3+418R68
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 02:38:31PM -0700, Andrew Morton wrote:
> On Wed, 1 Apr 2026 21:46:32 +0800 Chunyu Hu <chuhu@redhat.com> wrote:
> 
> > > I need to look at why this managed to pass the build testing I do in
> > > -next...
> > 
> > I can reproduce this issue with nolibc compile. Thanks for the
> > debugging. It's great if we have that definition in nolibc lib.
> > 
> > For thsi series, because according to man page, vasprintf()
> > requires _GNU_SOURCE, and implemeted it in kselftest.h will
> > add the burden to all c files, or fore a _GNU_SOURCE to
> > all c files included, I tend to go back to ksft_exit_fail_msg.
> > ;)
> 
> Thanks.
> 
> Can we please get this sorted out fairly soon?  It's not good
> to be breaking -next for others.

Sure. Will post v8 soon. Added back two mail lists.

> 
> I would prefer to retain the series - all those false negatives
> on no-THP kernels are undesirable!
> 

Thanks! 


