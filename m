Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45207C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55AE66B00D9; Tue, 25 Aug 2026 08:53:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50BE16B00E6; Tue, 25 Aug 2026 08:53:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449C86B00E8; Tue, 25 Aug 2026 08:53:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 270556B00D9
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:53:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A63E2120191
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:53:41 +0000 (UTC)
X-FDA: 85139783442.13.5A08F3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 175C316000A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:53:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WMgPGuE4;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787662420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFqy0iZQM8tBm4oUMpoq1Y2sfynDkv1QLYRiCrkswLE=;
	b=35XfhCKysOxbltZzOO1zU8xDtgVhiUyxMRcgdkboLo3JVi9XDFZkLObciEII4KnLJc2sC8
	pXSYoS1vk835fQhXqCVHC2c4AvVhrhUSWqsvMhVte48RXQ/zHYQToIBpUY34v9eAv2b4kS
	yGbQuexlm8LwQwpr/FdeI4YNoj+AjlE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787662420;
	b=btDhiGPogIT/wPtaiWSHKCtjzBVOlJfAqHfYOtMT+1kZE0f1ob+ew5Fc/4nOIlMsefVPOZ
	5G4d8yWGADVgJCT0v7uyGa1NF4YBtE3jLJ1lZSU38WWwdYrq04CWWwZ68deh/otdPUev6r
	cEWca196gxF3oUfTk9ibg3UCQz49s+8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WMgPGuE4;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 85CCF6011F;
	Tue, 25 Aug 2026 12:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08231F000E9;
	Tue, 25 Aug 2026 12:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787662419;
	bh=cFqy0iZQM8tBm4oUMpoq1Y2sfynDkv1QLYRiCrkswLE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WMgPGuE4HqraYVZGzhXNVOSIgDO27+l8s/aPGUiNZT7UtGArJEBzBt5UmUmrn1Idb
	 0K5L304bw1C63sT/dJSsF0cxthKDnjDYybwwjzycNEsdHTbWw2nsbS/b4byRYN3ff8
	 aRskB3LruXllKqarOjnhf0f9e30uW1iBL7+ldqlrBswwLd5gCOQAebG3vnqFUjffQT
	 lDlDh97OrbS/guxsqzeCCDv2IxUTChh3+TA8GsydTD94ZuVY2DYa9+8KLVHFHb+zID
	 wObzsX+sqlT8iqky78FYjLsbrgVJxEQcXouLZREpgCR6O87MEMDjmo0wWf2Apya0Yb
	 pVMDPFjhTcjjA==
Date: Tue, 25 Aug 2026 14:53:34 +0200
From: Christian Brauner <brauner@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Laurent Vivier <laurent@vivier.eu>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] ovl: don't warn when the mount is completed from
 another user namespace
Message-ID: <20260825-ganoven-waldweg-lappalie-3252be210162@brauner>
References: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org>
 <20260802-work-fill_super-warn-v1-1-4e987911a39a@kernel.org>
 <CAJfpegtXbdpFZmV2dYSbp6eL0DBGmZin98TFr42nxJCfuryfrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJfpegtXbdpFZmV2dYSbp6eL0DBGmZin98TFr42nxJCfuryfrw@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: rizm6afqegmk49fk56kme6si9g7fga3f
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 175C316000A
X-HE-Tag: 1787662419-561110
X-HE-Meta: U2FsdGVkX1+hg4P2Ob8JEXuBX3bPdmN9dr1ZLuz7XEL+RRWYwcdUvvx73q+/MKwZqZ8EfKEYv/cOCOAu0wtMplfjeFjQ/a0QVjYwR5uOQMqZnuapJfqnv3pJOXfqIcXrIVbGsPiQQc5n5JfBqlEQqSfKBvjEZsRkQZ4Jl2/9vLQo71QUbPasMtPzyCjsm+5LF2dr3QGCGAu4Z5RHgAvp/X3W0xw+pRhZYuEW+0GhIBwU+mLC3QwPQJusUPeBd0Ca6rZMOzPxdbC8tT1fc4zbCd31T6+/czERHijih/BVYiglUZFgKiRzEetCRvX0r9sD3tC5Mj97IMDGskYqIp2UadgbEAxOLoJpOlrs+f6ajT/SGIdJ2T2NWT9QbN32ksZEZ+URgPzmgvcXOdRcjzKw+oy9Lur9GW7ngvBpGbF/ZglIeELH+wWoSlpWT9x9EejtDFbhoODmpYsw3Cd+kGxWARMV/cLQr5g24F7tuIpQMzA+6Sc3WjMj79Hj4zBOQ4mOVAdN5DLRyNHA3+BUQ8nTBeq3wEZCsd+OsE2COIApZwYsYYtFJ8ED/18fQD+wrFFvYqEzlf1fR+PTIdJTybYWnNHzyxJbraXJxw3jMhktDtcWD05Wrumq4cqB9rEK6NDIAyeZvVkItRoa/IZ+pPxphFhbDJ9aL0BZXYdSOsreIqsQqV67v0d8Hn0yS07bsa5b4tQ1195stLUtc+9D71xgqXqPPR+vaN3XacGJFPkabjry1Nr+VORqzTak369toqDwx9EYFgyNQVQncbScPFBrMeDb9We8EdHrTByKHHCesh7PIecMORIHR8XxTN5+2ekGHDo+XnaVfzpDWP4F0dhZNwheKcWrFTlsSUujQPeb6hdTVCmBu7dUJCSF5+BUpUWkY+UrX+RzgeHGDeQ0cTiMPaQ8fqrZ8AMqQ5YL049ZQLhByzg5yi03W1COGUNQWazOTGSzBMpaQ0M4UdRdPI2
 s2Wf+Om8
 0pDfmKQJ3toHieqNMh5jfRRh0VhlWFnjahI2NT3g3YiJtY3zoIXo2EB4TMABsAZdpe6RNhZIYQwcl9Sz2cJw9AzTa4kVeHA11wGqN6As8/0In0xG3yBda6rKxIJdZriMpIEXL413Rn3fCAL2cPw1vhy7JKqbvfsz414IppjgS6mZYIjPVAIpG7Bi4WEfcVgnF4i/jXVuyp/U/frjt6hiKmgwEZEo8XXSq42yKb8/3qVcdSlZVKqKhCkzCZcnJ4KT/6IwhkZuX1dXoraJXMrDrbPPQOszwtVBnhG7q1/V8tgtqnyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Just one comment on this (I know it's been merged, will do a fixup
> patch):  EIO should be turned into EINVAL.
> 
> The EIO was used to signal an internal error (commit 9efb069de4ba
> ("ovl: add warning on user_ns mismatch")) , which is no longer the
> case.

Sounds good, thanks!

