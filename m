Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26929CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 11:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173226B0099; Mon, 28 Sep 2026 07:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 124366B009B; Mon, 28 Sep 2026 07:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03A486B009D; Mon, 28 Sep 2026 07:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CBBDD6B0099
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:00:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E940120174
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:00:30 +0000 (UTC)
X-FDA: 85262877420.14.1C5FBC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C75C24000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:00:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCMQw9cX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790593228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W/VZm44XzSsz564iDu6yls171Wz+1fQyfbWB7NPC/qE=;
	b=xqhVyLN53Xl7DxwJvw8OU7uDwgZV4SE5Yr0ryJKKQ3iN2cNwXzJR7rfflyt7W17Ol4rnYD
	n+6HSG+yQn0rIfxdRDytS1SFt7PEQdsbq6jziVhR6XAo7JzC4bqYYPq4r6yOst9+NnjSdg
	OWyPqs8A69y6cbjL/fSufwdfTZNC46Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCMQw9cX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790593228;
	b=1Ib02KW0udqOss7zkK4CM+M340bi+bHg3BrG7yV0SHv8AggfFCLV8VJ1dd81ZLV/y+S86k
	dv1LYYs68FfwyB89tF3G/efLgCN7bPsqdh2SzK3DuQvHFPY1Q1KJ0mvgSptkoNQB1gg78e
	ZEPlQbU4z6WCzVeGf/UMAYkLcYEL0WM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 39D83600D1;
	Mon, 28 Sep 2026 11:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852161F000FF;
	Mon, 28 Sep 2026 11:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790593227;
	bh=W/VZm44XzSsz564iDu6yls171Wz+1fQyfbWB7NPC/qE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YCMQw9cX13xqhIwBzSMliTFI1BR50NKpER6op4F/axoQCrr9l0XXf6aKT61a2MYnZ
	 5capFidkNb48gSEu2nhvuhjUmkOoDQEfunJtlKE33rLoPt/132APCimNjZZlyAnfGo
	 BgCXLAb9ZOJGA+56e3kydME3r/Rqy83Tazx1Hgk12gMgLAooFzIbdO92+wgszDwoI7
	 0wcOm97VS0aIQkcxex3zRx0W1YJhM3LnzW3wvpPufqpPdX1MU9kssrpgnzzKDjtoez
	 tU76c1ClWcl1zqN9EOl4Ujjk7ElqmJTjv6Z92YxS/B01A0Me3ruXGE38icwJuqHZhX
	 mysf0URYpxqRw==
Date: Mon, 28 Sep 2026 12:00:19 +0100
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
Message-ID: <arpIi5QBG1_MuZzJ@gremlin>
References: <20260926010819.604346-1-thehajime@gmail.com>
 <20260926010819.604346-3-thehajime@gmail.com>
 <04259a99ed91f8a527b255951a6f626310728170.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04259a99ed91f8a527b255951a6f626310728170.camel@sipsolutions.net>
X-Stat-Signature: kj5bio4ocdy6a5u447fjh3s9j6rizguo
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C75C24000B
X-HE-Tag: 1790593228-530726
X-HE-Meta: U2FsdGVkX1/RydyUryGH+09ebK8MQbY1FJnkAluGXL61yyTzT13OEuPLVUVAXsXjM+CjE/HuhZ7f1kSimruBq1Z4j3V05RLAXfrN/nwThTVNgSngx2IcKU7uCeU1XJYggetn3o+EPGUuqaZZ6po7YlWxCdOmyRfTPGSPTWYCEo5VjSim8KVG7wVzHxF7uhDX6pC9EL43229r66hgLEYlbdLDrJs9XYLQVLofzLVR4/Evby/6jCNkDJ5nBBG6KhZQPaJFCxw4+6mrLQSsxEC7f7l49KXHNWGvvuPqu8rZc/v7Jzo+ksSooqB/1HrHLnL7+ReYUNUVcQTQF1wtrzx3mXtqQehWVj9vY18muKANpRvsctY/JZx530kU3TInAsAPoUTQu3GNsAZZhylfamxM1FTsldpI81YXSyH39fIUcfSeRXMyR7czX3YmF5nkJA63+dxXtpqPJmJ81QMaUTTVsLb5AFbx0BGBC1yIMu1kIu/eSHH8QAzk26SCFmN7SFI5CMhajI6edaVN3JPihxQ8/na/bYMdFcStDFAewEyaODsZIVCekgY2BoH42LSjI/gp5GdLq202iQ/Vr3O76yEFUSleKQhGTHmCw4GXq9tGASwsK87B5J31SX2a71NpueiVjiUVZ15K8c3Wgx8SLwvYCIlt5E8Dj70SBL4EI+lf9rySe2UCS8gznZQMy4EmL3JKSNCKjuO2F0MYClOiQsuSyqUoK7sAgJeVoILMi1dKiBZDi0jg6acuCQv8mv1kwamRfxn2JFPagJmmy5LTTHS/KujpYeBdygAkrR54mpaKQ/dLiz04avM/IT7moLGNsa8ZeU5KSElo5MEAYB/iSIQFwkizm8JuTAHn0+uzAYKVnZ9ri86Jgp07U4fRWFhHlSzk52XuQ1MxwXxq9qc9q7lFynVAmmIBWOOQQWoJPI+A10xOKbjJOuyWWtyFiFLgPcVKQ5U167VJ7La8kg6a4Fh
 53YmVJhe
 LuPyqC/TvgxO4qJhEiC/e4X2I1X9QkBCPzI+mSHxYbscQcCLudZ0YEuCNgDc9G1kIZggn0uWwUYldQ0Jfo9ipWS/24DSq6BF/EhnPXkkUxRzR3T51ApjKJkDnA4zDeGYrHoT/QTkdmkgh559ALNNtXzuCtT0ktM0suyM18JC6Ac5z1aZ7MViLVbNi1wGjdAtn4BS2YCSVsweHjDrFobDsKtnxkeOOS3WF0PPfVaaeyygDXr/7zhF0gmAXDk0BQ2XIqTbr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 09:44:49AM +0200, Johannes Berg wrote:
> On Sat, 2026-09-26 at 10:08 +0900, Hajime Tazaki wrote:
> > Architectures lacks MMU doesn't support fork(2) syscall and only
>
> nit: Architectures lacking MMU don't support the fork(2) syscall ...
>
> Not sure where this should be merged? I guess selftests would make most
> sense, but you can't actually test it out before the UML nommu changes,
> so that doesn't work too well right now?

I seem to recall Hajime saying he tested this on an actual nommu
device/virtualised equivalent so nommu UML isn't strictly necessary (though very
nice to have!)

I think I saw something fly by that implied it might be coming in 7.4 is that
so? :)

>
> johannes

--
Cheers, Lorenzo

