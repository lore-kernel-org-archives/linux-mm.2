Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59C9BC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3656B00D9; Mon, 21 Sep 2026 07:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29B746B00DB; Mon, 21 Sep 2026 07:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8826B00DD; Mon, 21 Sep 2026 07:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F37A46B00D9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:46:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8DE7EA1878
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:46:18 +0000 (UTC)
X-FDA: 85237591236.08.2CF3F79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id EC79C100006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:46:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a3yvm8UI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789991176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bv17kNAfr+GWReaGWxmR3kN67ZtV/gUAsC1CZBpezIk=;
	b=ug5vuQU7gDoSGj5R4PYD1ZbvkPllnnz4SX07JvSpJHAu8XawCH137QTe02eQTBIDtl6oPQ
	r2bgH7IOWpgWWq3rHKt3h5WkX1HC7AauVQM76V/q1CR37ukumKvTQDcI9qRlotoy7V00KJ
	2NvJrA7ozkcIqKPV6nVfH51+1oyhl8c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789991176;
	b=aRskaJQMK98IHfkKQbJdNPp2tnOz/Wd5MTR5jQR7Xg9sn36IDjsx1PGk8tdALcdiBBC+53
	PalEKOiuWxUhVi+r5Ew+Zo4lwPoqEBuBn3o2dgtIpVLStIqjK9ryqzbyrRWxvW5gdfCqrK
	bhdtHR61GtCC3bOuq+qp28Y577HzJ1s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a3yvm8UI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 39043600D1;
	Mon, 21 Sep 2026 11:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5401F000FF;
	Mon, 21 Sep 2026 11:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789991175;
	bh=Bv17kNAfr+GWReaGWxmR3kN67ZtV/gUAsC1CZBpezIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a3yvm8UIribTaWHkkdKkMq16EsJ9fl3TfsqIXKIPViYxYqNy9wilZlSiYc1SjT4np
	 EOsca20qg96+26UeJRSqEyShE/SYBxR4rMMT1ZfEnChNxW+1lfHQ18tzLF4hGUDS7e
	 ehMs6dPxjozJjPqfl0zKdut2mQO3kBlwPLcfI+Fc7hhiUFn0zmTWnNeZuh5oRyHzwZ
	 sIEGJL9JYq0KphlaQ0U99eQG2065/RssXY0mn0heUILEwfFImvd48pt0bvt0DivbkV
	 BcB8+7vBWYCV6DGw9iwhVz4PetdgZeWOoxZPBg1PAlgjVFDufOjZRe+RggvOTMmoR/
	 wdSGD8aIgBkmw==
Date: Mon, 21 Sep 2026 13:46:10 +0200
From: Christian Brauner <brauner@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/7] fork: refuse new threads while a coredump or an
 exec is in progress
Message-ID: <20260921-aufwiegen-festwagen-ozonkonzentration-ffe78eafa8fa@brauner>
References: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
 <20260917-work-coredump-fixes-v2-1-f3787fcda051@kernel.org>
 <aq0VLTyxNatFmLOK@redhat.com>
 <20260918-irrsinn-pickt-vermummen-d7167c397398@brauner>
 <20260918-disput-maden-parkdeck-2bc22dd90398@brauner>
 <aq0_lvHDViIpX_Mu@redhat.com>
 <20260918-elstern-potenzieren-marotten-71ebd0744753@brauner>
 <20260918-oliven-lebst-wohltat-c633868711f1@brauner>
 <arEHxPFFrRtvUSPJ@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <arEHxPFFrRtvUSPJ@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EC79C100006
X-Stat-Signature: 8xbhne3chqjju9pnikbk48oinhjwa36e
X-HE-Tag: 1789991176-265981
X-HE-Meta: U2FsdGVkX1+WJ75ME27qUvLyj3s0UFSHz2hAp/qgY/Oyn/YDBLkRl1yuphNF3CAf875YqiUGjhohNQToJEaM1cmyhJIRuKj68Dl/f9tSFaJesbmmcRJShY184K4icH/OyeF4P+Ubumo7eJgDnXL/mV072zAq2jkQHU3jhnh4RA6Loz5qDmtTbdW3f3OvoHdfrYcMX15ImNvJT0HrbpMyYyfyWvgSDFDWT33EqAncn7F2sWxhTJkM2ZrDjDcch9ObpXnpoZrG4M3fYgfjz1rqokV2pzRH1igrew9x3d5sJfqNRBLl4C+dv/t0cz+J2FBcUbynKX+bttTUSrayBm6YFLk5xMkvZ71JL1ZZL97ruvd1c48nsqyIaAf768ZMHxHp9TW0T9rlMcpMNr1oyF5/bLq0Uvuj9TA6oa5tXoTkkOvkeDsADATIJbb3DdxR/UnpFeTV1e3xIsUiHEvYezK0Y4P3ECTVVUq0LmJ7r/QPfhZjSe+wjiThGpn5I22pJmBRc7W7qEp3Cqz+o20Zm55h8vJihtX1bQH2GEbU5lywhBGDpxI0gOjF/N555RizOO55+x0ltXbxk2fxAMYNznX2C9mGm8kyvFtWa/hWFlJu9l+H6wtI5dzHFgmiaJ4nZpWb6ovmA1hqcXTgzmYBssDY9k5VcfZ0pWmbXjbLRKAjbBuen5+AL+Xaemivz08dPllqZXvwoak3vSUxgNKkgSmBy/Oz5p6vGqWxIT5DofWjpkvzLTHP8e2QI69cEuNFDNAzz5t6kvCxcJsFKn2jCvny7TKsVHygwCvthgzB9TkKUimySIpDqp6AErVjKKVsbFsC5N839F5i9GbLlhlIyxFsl5RKuci3qbf4zOgDwdf1Ek3dsGiJAYKyj/3NDbcbKxghkPRS6E405iX1sa2SU0q7aHvAGQukv8WOy3uOAwYQv0j/SSH7o/mjA1aHOiZaKayMfqAfNaC81/NBl9xqq+P
 N5yXo441
 UG30g/zvF/2dNAvU0dvfmmUWNRraWNy06ylaa8EROpcyqJZJvldanDHrM8fHtEKX33UUNleu9ftrAnGgYVdQLu9+QeJAshNVzfoPS6lJ6AWi8Y9nICtdMsnYOujUwQis0k85JDSjtFayGT6B1tNZfCuPKLBsA89n4o6+M9HjPed9tH/ay/LkzqtN+rCEgldFAitKEYxofA3B+kK4FQi7q5A9ZQrnilABt1k3uvYOTsiwI08WoYkqp84e9KMiaIG9U70YmublJcoY5i1obkj8ZIuduGN6cdYl2wuejpPTgDJFaLUk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 12:32:36PM +0200, Oleg Nesterov wrote:
> On 09/18, Christian Brauner wrote:
> >
> > zap_process() skips every thread that has PF_POSTCOREDUMP set.
> > do_exit() sets PF_POSTCOREDUMP in synchronize_group_exit() and calls
> > io_uring_files_cancel() right after that.
> >
> > That runs task work, create_worker_cb() runs and creates a new io-wq
> > worker. If a thread started a coredump rgith before that worker gets
> > created from a thread with PF_POSTCOREDUMP set which zap_processes()
> > doesn't see. So two ways of fixing this:
> 
> Christian, I got lost ;)
> 
> TBH, I don't understand why the new io worker is really bad in this case.

zap_processes() only counts threads it sends SIGKILL too. But every
thread that later finds ->core_state decrements that count. An io-wq
worker created from the exiting thread isn't counted and exits right
away because the io-wq exit bit is already set. So it decrements without
having been counted.

> But lets forget about coredump/zap_process. With the change below the
> io_uring_files_cancel() paths will no longer be able to create a new
> worker, even if coredump is not in progress.
> 
> Is it correct?

Yes.

