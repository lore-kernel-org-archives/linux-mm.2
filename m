Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C0C1CD4F26
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 00:48:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495036B0088; Tue, 23 Jun 2026 20:48:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446BE6B008A; Tue, 23 Jun 2026 20:48:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 334F66B008C; Tue, 23 Jun 2026 20:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E2086B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:48:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8787B1C0F41
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 00:48:34 +0000 (UTC)
X-FDA: 84912970548.24.74073E1
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id B17B740007
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 00:48:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=WjqTrHpW;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782262113;
	b=iMRSrzvnpjZqgubM9ezJ+M2/lH0jqwGHKli8QVrJ9p1othplJvVq/sf2akCmrY4/qodY//
	0hYJRKKJwc1Cx1lUIUhhxLHpSSDIVRTKiuME84fwGmz+vj+5diwEShoSObsPoKGDLdleCe
	IcivCv/FlqocBRNaP3vMZpBXgVCi5HE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782262113;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2EYlWrDIggaFS1Cm6S9FY0dqVECZJtXN6I4L2cEQ1s=;
	b=ldRwQ5kAP9M3g0nNFJHvY45ZNmi8WLhaVynrwsevZoVLiTYDxVAbB8VqA9095jUYUgg3Xz
	lGQRAg/+L9Zgl6Ck4t2dAs9J4dwjhAA/W2IrWhc3Stzv3+H5K3gSXm4iwkmxL9BmMQd3KA
	hMTXSsD5r2VK/CiT9/Ej8b5ojMI2+PU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=WjqTrHpW;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=X2EYlWrDIggaFS1Cm6S9FY0dqVECZJtXN6I4L2cEQ1s=; b=WjqTrHpWtqnYLeJO8gl/AWhGiP
	Jj1v3S+TKScnKZyFylAt5oIXL60KtuUD9g9LHBgyQVxgSXgY3K10dhRfGjktP065GaQIaeUdXEF+e
	FvO4plR96u8zaxmefNyCBkt+K610qm097kwbe4QGinHOy0L7yI/Iov0t9FZoEXKtpU9YZTieyzAGi
	JfJSkmj2xKsajTcUAyeoV0+lC8nDomcd4wti3rlvDMLgYykXnpZDSsGejuEZAcTT6fb9f7h7zGj7x
	d5zTykfCq2IOIgwtJ5KtAUq/MGvSj+kbA/0DZIyPL8rAvlVWnrEvhX/qDzi7waRZsYHrmwsRJ5k4y
	l5svrOKg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.4 #2 (Red Hat Linux))
	id 1wcBn2-00000001S2J-26im;
	Wed, 24 Jun 2026 00:48:28 +0000
Date: Wed, 24 Jun 2026 01:48:28 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>, linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/10] kmem_cache instances with static storage
 duration
Message-ID: <20260624004828.GI2636677@ZenIV>
References: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
 <20260613050951.855141-1-viro@zeniv.linux.org.uk>
 <151b1c96-0ed5-44ce-b9d5-86a48d8ad592@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151b1c96-0ed5-44ce-b9d5-86a48d8ad592@kernel.org>
X-Rspamd-Queue-Id: B17B740007
X-Stat-Signature: jmiddm7rfu3mqfmu3gdqotherz38d1c8
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782262112-387713
X-HE-Meta: U2FsdGVkX1/aaExXAh/p7aG1tl1+ScMH9VEGQs/ihkpdz3ryEElvwCoJ7XOaNIefWTIKvhe8dMrIZisEhXZPO6bsDIaUb3lUi7pd/tMmeJTJ1oY3NIvM4yckJKaqMtbH9cBbMZ4bnLfVJ9VfkdcT9gX9lMUdNqhD74sjCJRSeQ74WfpjWS/v264c7fO7LH/eta99a7eFbsie4Xhy35jdZmj/poBA7jQSX3p5Dc0Gx6m6T5B61c3xjDrTh2/me78dKD4PWoyZ2sl+9MsBzWrobnyOFw6j7q8djiwT5h+tFiWIUrhP/5mvP3LeN+4dVt9MEk1CjfzvAboaVeKdvV2PCYFWK3oaNO+NiBTt1SK76PnWZ1aMFetqoByaUo3W+n3GI5uecmapHOX1yRuyQ+ipF7TxZiIMED6aIEWtKeVP+o4ocxocjIk4EwiqJ3x77asQcNAHUCWX7FN8RJHOvPrj62iu4Cfb9aS2uZlgQtmNRvcf8GWdLPzJd0aX7legVaWtFS7ZWk3zOK8c/fGkja6dMh2dZDU7bfKaX0E+LhuluNxZrWRSgfL0c8/EJSCjJbI1bJckU1ynOvzPiJAvfZvoKZ9u2OkcOedYMCeR96osnDe+NiqRIIU/nX553yfcC2ZLttLFJS6JUlklwaTid4SmJ7NIeGej3Ku0Cd1W3TJsAq4WfKlnAEPgM2APp0AXGCrQEdvjbW/ya/GPCMlR9s6LXaSh+l3Nj5drW0BnXpjzxUUrrqETZTlcwxMVJXwFVt+1HxW+AnJNlhGB3Vfgt+O04LgEL0AO8QebO1jbXWSS9ROLt0kdo7SK3ac6/V8N59w1QTwgJOT/cStPfzwkkkh7OfE8ft3UVZsLEyZveEY9dpU4qj2ireDAGuVChZVVZiKwGuY0TfChyZ/iRoxlMqsKSXZuNaDYVb/G/juH+WUZa19ZTeYBgNZmb3vBk9Nvtnf1FWija0sCHT0lL9OivWM
 8KfCleH6
 1kJ9jeCmxDpLNrDNbmHObAcPOGy1Lh5eFPNESrkr8BoFhnQ1Nr+mG8zrkfIXSOE437KzR8hSvRPFw1dY8jGVdhQzvn2RKZJ95ncPsc5W18imoy8nXpg+2oaHZzFvstYd1RJwmvQP6UXtjVQdIUCGIuOA3curYSIKXStQ63N+kkx7HUMHkng/Hkt2W2vpcp9M2nyZ9K4hpv21R4ojWOd8Lsuxo+rY0sZcDmcEA/u5P89/fFAXhk9zYYl8wN5ikxLWviWNPREZFY7npxjxBqEPr4ESj67fqvXxYl2rUkFckzaK+maqe/ODc1phIN3faY72GbjWWS8W/yDcw3O3qGKnW1VAZ0ogeLFA6d5NWVX9Zf0wZhmNvx+cMxzl7g0phh6uZXem9W8LULWZk+f3NZ9k38auRt7xcq7dbcHYjHvaO34ITPrLUiwa+UWfCTGlYY/SOwBt6qGLqizpZnneKj1nh22vAJ4G4VI3kVKPCce0OKHfFprI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 10:09:41AM +0200, Vlastimil Babka (SUSE) wrote:

> But the argument for doing the static duration support is that it should be
> faster, not just "not slower"? So is runtime_const equivalent or for some
> fundamental reason it's slower than plain &?

Yes, on any 64bit RISC.  And if nothing else, arm64 has enough users to care
about.  runtime_const for _shifts_ tends to be nice and easy; for pointers...
not really.

Compiler does *not* build the address of global variable in a sequence of
shifts and bitwise operations when it needs to pass it to a function.
runtime_const_ptr() must be able to handle an arbitrary address; it can't
avoid doing the general "build a 64bit value in register", which tends to
be nasty on RISC.

If you want real ugliness, take a look at riscv - AFAICS, they wanted to
avoid a long dependency chain, so they load chunks of constant into 4 registers,
then shift and combine those.  arm64 doesn't bother; IIRC, the hardware does
recognize this sequence, but I wouldn't swear on that.

> Or is the advantage that static caches can support modules and runtime_const
> can't?

Probably, but I'm not ready to give examples at the moment.  There definitely
used to be __getname() users in modules, but that stopped using names_cache.

