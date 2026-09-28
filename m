Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE99CCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 16:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA4DB6B0088; Mon, 28 Sep 2026 12:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C82896B008A; Mon, 28 Sep 2026 12:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93136B008C; Mon, 28 Sep 2026 12:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 996286B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:23:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1704CA6235
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 16:23:19 +0000 (UTC)
X-FDA: 85263690918.27.A1C07BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7C99C20004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 16:23:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AdKe3Puz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790612597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dNDAcGHNy09VRA5c5vXMv5G1dwyTJJ5okykDl+SczM8=;
	b=2YmOp6FEdsbq+tsHGm8KYqGnE7TQVE/ahsEkohPXnOU3bg2KhWn/AmgknP8TaZ3LnIHX8V
	gQw0DgXPA9mTJOUb4DH5A7dYUYX6aDcYr+s2VHgUN2QCYapCvRepTzk1+4SCAu3gI+ut8Z
	JhRwLUOWOpbtY4a+asOExf/lTkduVqs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AdKe3Puz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790612597;
	b=wVC5hEUgzO+T329uqlAYYcV8hYBlIJvfU5eXr0Y6JJ4Jp2b1V6ktOQmcmXlqzGsNy5EORt
	pBXwxM64t9TEpRgM1PqlUKYnSCWCkw+J9BZSljUEoZxKPRES0WAd1pDyVcZcXw0renLAxu
	GqcNfZMgovmj0Ia6VTJHdBe/nj2qt70=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC3A9601EF;
	Mon, 28 Sep 2026 16:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C8B1F0089A;
	Mon, 28 Sep 2026 16:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790612596;
	bh=dNDAcGHNy09VRA5c5vXMv5G1dwyTJJ5okykDl+SczM8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AdKe3PuzxBeIfMRzAElN7KJNlKqTeYxTv3RiLkw/Qz7zSVjL8rh3hz+brQG9Rl0bw
	 4FC4Y6iUVl8feOfDgHg3UMd8MhU6S6JawTo5suISocRvxaMFCN044OBdhh8q4QSPzm
	 +84ocNwkhgBfQ1aDLsOl181/6k8blbWN99FN7JDQx3AGzlJNTzWmITGFdRp4WIzIu4
	 jYZICQBD3DbSAThjkRuJHvNzQorEuRquCsQq8bHfEy+9Eo49vSzkuMj34fUFRYF0ow
	 SlysURxuHxAAvgD/PtsHtPh4xlw2nSGiLzbixrt35t5zyhNs9HZSuzvytQul8CXo5P
	 asQRSILi8GvMg==
Date: Mon, 28 Sep 2026 17:23:08 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org, 
	liam@infradead.org, rbm@suse.com, akpm@linux-foundation.org, luto@amacapital.net, 
	brendan.jackman@linux.dev, david@kernel.org, liuhangbin@gmail.com, corbet@lwn.net, 
	kees@kernel.org, broonie@kernel.org, mhocko@suse.com, rppt@kernel.org, 
	shuah@kernel.org, surenb@google.com, vbabka@kernel.org, wad@chromium.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org, 
	geert@linux-m68k.org, daniel@thingy.jp
Subject: Re: [PATCH v3 2/3] selftests: run tests on nommu architecture
Message-ID: <arqUVCrA0rC7-c0b@gremlin>
References: <20260926010819.604346-1-thehajime@gmail.com>
 <20260926010819.604346-3-thehajime@gmail.com>
 <04259a99ed91f8a527b255951a6f626310728170.camel@sipsolutions.net>
 <arpIi5QBG1_MuZzJ@gremlin>
 <8dfc0ec9ed660e373451c96b6fcc352c35a6a004.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8dfc0ec9ed660e373451c96b6fcc352c35a6a004.camel@sipsolutions.net>
X-Rspamd-Queue-Id: 7C99C20004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ahhm3rc9nraoxxiu6kmjnjiouzdywqjg
X-HE-Tag: 1790612597-100276
X-HE-Meta: U2FsdGVkX1+5WJx6TtI7E08nrZtMFJ6smEvCj7qY45W79eCg/qcjkNHNgRgFTlcPvXsutqx5sYQIId6eBz4vBDnm2BdJ4pbelpzXyIFz6+II2uuuGsH7LmK7VT7WUb8r8MELYGCyX+uIH1L7pyUkBmkOsnCwiqy5eClXpoTOlDYjw9nLZcLI7+oD+0c8icmvbVIuJNddNmbQG8lXY5ocQaDNMzLStn5kQOczXFBDPoqeCMOab//mU5wxXUeVdijN59r/0rOM+YJdUxfs3Ga2WsALTDpLUizdNvTjre+mM2T4GDpdAaII90btU12ouf38BtIkZ0ZvWb7leaw/tjp6tkjLqLaLeXWE69dUa/FgaHXeUdB7VBREY2j+bm7VIMGi7vJrc6g3nQL0egDqLkAOhNZi5yIJKS79OO/+j1PK/oXqvaeCHwYtYxsZQDetO+BeBwu4oI0q/RF4E2Rix0oqNz5/IxZ5mxn/sUiZRwYjHSWm2CpCll/8QITxWFaH29j+Ydrjka6J/QlYJSlZCSIlr/nkzyIeitu2JNzycWRtXlpegnJej8ZHuB8tu28tqanRgYusVVHsCpVY8RE/rfGQ+/jyaegm+vDdgsm4QNfwO1SLgrx6y15PAos9e4kNkX1e6f19/mFqf6hFfruWWaX0lGOisjuZ1g3igUqgu/pn+EQSfllFiCdsdffWDqH5uRBfUEfJ2UTplX2ZZ5s+SoutH0s5fSUPd4LEzFqRzGR8WB0VkkaPrJdNq+BOJ26yfGabQ2tVxjd5IZiID9Bd195aAoDEWZfFcumBoHSLKfe99w6sQnUqHNR9jMtywumyqXh2URJdiUN4JApugShyI6DnOb7jAebiAeZVDA2pV/oIn+6RfJT1bFvHNYx/zX2gtHO+ABE/uEHYgCCyXCCJh2aYVu92bOpYvM9TsI2TmrwSeIZPhyNQFTGNBcNX/m8kUQ0KGMJYAq1zRPqSRpYUOPn
 aqHbiWjL
 sv8eKsA0ISCqDXJUL+Pnj49c8cS70POC/3DKLY/KA0Fzw2qA9DQOx5wYH0r4tc7zxfAi417chkkQ6+GyA6YVDWjYj9TVEEPfNxUuZTme2Ot9W9gpy95h1WTEuk6+0qE9DkctEA41398EUkSO44+V+IeFhy6pcY42bvLDUzrWFaIy85G14DaHtQg17JoUzWVUi35XlBuvpWyOxZRW3WZATEh3yEDhRY3hZou8h3LVEl11yX5lbrvl5dKHBVu1qzX5U12dk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 02:32:50PM +0200, Johannes Berg wrote:
> On Mon, 2026-09-28 at 12:00 +0100, Lorenzo Stoakes (ARM) wrote:
> > > Not sure where this should be merged? I guess selftests would make most
> > > sense, but you can't actually test it out before the UML nommu changes,
> > > so that doesn't work too well right now?
> >
> > I seem to recall Hajime saying he tested this on an actual nommu
> > device/virtualised equivalent so nommu UML isn't strictly necessary (though very
> > nice to have!)
>
> Oh, I don't recall, but I guess that's plausibe.
>
> > I think I saw something fly by that implied it might be coming in 7.4 is that
> > so? :)
>
> I did end up merging just about everything that was pending for
> uml/next, so if we don't forget to send a pull request in the merge
> window, or something equally catastrophic happens, yes ;-)

Awesome, thanks! :)

>
> Sorry for the delay. The onslaught of LLMs means priority is elsewhere,
> sadly.

Yeah understood, onslaught has reached all areas of the kernel it seems...

>
> johannes

--
Cheers, Lorenzo

