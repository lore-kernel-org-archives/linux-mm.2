Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28326C982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 22:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7EEB6B0088; Wed, 16 Sep 2026 18:10:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31976B008C; Wed, 16 Sep 2026 18:10:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46A66B0092; Wed, 16 Sep 2026 18:10:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8032A6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:10:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AECE2A012D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:10:16 +0000 (UTC)
X-FDA: 85221019632.09.7AA6439
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2D4EC80009
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:10:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VhawZNoB;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789596615;
	b=FwyUx7q5URpd/1JtJiEYaa92fYnn1ARP3dXSeEzZwTNAHwQebCmI+KTP6zgpVdD4gX6VJS
	hqKZ2RUrWDxje+iG89HSDJV4MHgq8H/NeNu+ll/KXzA3Z4mss15YpUQaLDUzI7EJKpDuGP
	D2GonfstTfaYVscnq4fRx0hmlXXAb+A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VhawZNoB;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789596615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=woRF4U7BLisY6PTyIk1Ijf+XxzogYfb21SXAKp3A0dw=;
	b=oABD1r7Akikor36g31lNxHY0BGNYYNHxvtSimw9wM64HBysdGXxwsqGlvp6SebNUEfPAXv
	EPhpd1XOdQbTTCHJbHZDPK9S4rpiMZAUK8jZQN9Cmr/tPVuzCFp9C7Db9nQMt+/mJi95z4
	cfYCqQ/e2bQPllcy+FdSdIF2mhrbC6A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 89E21601FD;
	Wed, 16 Sep 2026 22:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DC31F000FF;
	Wed, 16 Sep 2026 22:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789596614;
	bh=woRF4U7BLisY6PTyIk1Ijf+XxzogYfb21SXAKp3A0dw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VhawZNoB5UJHRilP1LPvfF5h0tTPz+8hESGYkVJCxAOesduiF/LJzfWdU3OnHeFNb
	 THRUJTnD4lFjt0mpkkegHFhLgu6kni9ewoB76ysHNbbjKDtZ0Z6E6DZMywGVWUIYAv
	 RBgxvoTCu3ayVwIBsDF9Cn0DAEaVphWiINL+tNSzTix43KR2gFDXe+eyXgRGAyYXAO
	 bbFaOMVmFPgGbkQCxUq7O7ImfLXEKYzS9ZP6bNrzq2CckMsE1HNqOQpgyuMz6Q4+lR
	 IRdalDVp6/HXW206F0NP31qqZOR/HBCG+iYDvsHb3iotj8X34pSHgcHNncfpiFHsko
	 lmmTYVbPTWUJQ==
Date: Thu, 17 Sep 2026 00:10:09 +0200
From: Christian Brauner <brauner@kernel.org>
To: Chris Mason <mason@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
	linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 1/6] coredump: don't switch a dumper that has no files
 table
Message-ID: <20260917-staunen-sparsam-infusion-83238c68d21f@brauner>
References: <20260915-work-coredump-fixes-v1-1-f354ca41780c@kernel.org>
 <20260916194837.3732307-1-mason@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260916194837.3732307-1-mason@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2D4EC80009
X-Stat-Signature: kxdfmnz89z3qihdexpbeeg791bbi4d7r
X-Rspam-User: 
X-HE-Tag: 1789596615-195104
X-HE-Meta: U2FsdGVkX19lOhRge8mamkU5M5jC3vnhAbRx2Cd7zjTCvLGXQgT53H71ecEovvyJJEe2BLpnKrHw9/+nsXU0WpL+YdeC9Zr4l79r4qzDuMZTX7v4yYH4T9tSmbFOynLt1MYyxkj6N7GkawqgWZZYgsOys2bLkuEmhT4q+HUszLIOTSG7ISFypeGwIOtlw/PLgcwUh94uG4odJpj7u+7iISGmc5t5F2UCQCengQxC/2EMdCwl9p+aHEeeroHm2XDWvZDziMTcFp0hkyoa/j1gl965ooRlpkjiOEZUKsHmM2In/+owJEnPcBphqSOKEkXxABUZYyygnMt92VY7e5CvOGMvPmrjxWuMakD7YNznfYhuSuZVEfaBred/O8GF258Ae20RIfBCki3LPtMgelEKFpHrctNJis9bQc5crHh6DdhAzJ0O1VY8YMDdhvqVObm/6dNFWa6q5yenuRNYIXY8kuOapKtHun77wPJGz/E1BM5ysBnb0bmYG3CvQQOEeGw/+FUHqynwZ1zodAhNV0ZHM0KFjfQcJ4Prcw/U940z2dYxO8VdicWX3sYiU0rypyr/LGrdhvMRS+IBNNgRiBDAyOK205OiIb9/bY1JwggLPmJw97lzcKV7UD6Z+jxCl+rw7TV6kSQ45YSeGQ3Kj05BBii9TbJQlZnXtxySvdJNtQP/j5kTEWSLf2GYpi3o7fpGHnjTvOkhxwyRismJD70XfJvG7qfdHKKmBcvOdABFf+llBu7XGxAC2GggY4euI7Qr2z8c/tluOdlcv1ynqDpsiDTYtPVHBCdpv3njFc/4hEGGGcuAVLYzIdsv32I8kCsjKtw6JqwbETPw9SCkpNTf2in2vZGYBkY5XaUXZI0oscu8f5mkja9DhFOafUMNU19CiwJZx/oPt/UUVFYtcIzYPYDI14fuTY/W/sHMZf2PH73dtU3+drMz0zJJglwAiNnsbIloVuuqoSy0EV0U6rL
 EJdbXlE9
 CnoYejzItcUWVHvVZSKqFMtjmVM3JQLjt720meraaGuQhjUVsfjrdcJxN7cp5aR2ftgCbz0FRBz5Nho7hwNwXTjhajGZTVgohJ0qZrmofrx6fo0evuTxssOLLZqPRME6My49RcwAyOhKPQfhOFazL8tO+MpyHOsRjNmvtzJ4A2waYAsLrbX6nhG1asVAUBVEXGrUIFkF35gbueIOqmT0C0XrEJx/fMNiLW47dt6WMmfJEYLyrf3OjlPRXVaqQ98l47j17svAJ8mOMDV9CHHGk0XLgOSkOGZDaoID5F8w8sPYLLqE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> When I reproduced this one, it ended up deadlocking with the fix applied.
> 
> vhost worker (the dumper)          sibling thread
> =========================          ==============
> get_signal() -> vfs_coredump()
>   coredump_close_files()
>     hands sibling a new table ---> switch_files_struct()
>     coredump_wait_inactive()         put_files_struct(old table)
>       waits for sibling's switch       last close of the vhost fd
>                                      vhost_net_release()
>                                        __vhost_worker_flush(): waits
> 
> AI suggests making the vhost thread requeue the signal for someone more
> suitable?

Afaict, this is conceptually a generic problem with letting coredump
close files for any type of user worker where the worker is the dumper
and the sibling thread closes the fd that causes it to be stopped and
waits for it to exit. So this needs thinking and we should drop coredump
closing files for now.

