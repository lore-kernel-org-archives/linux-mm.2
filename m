Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D02B6D1D492
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 20:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 278856B0088; Thu,  8 Jan 2026 15:25:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 250296B0089; Thu,  8 Jan 2026 15:25:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17DD96B0092; Thu,  8 Jan 2026 15:25:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0625D6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:25:12 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC8858B36F
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:25:11 +0000 (UTC)
X-FDA: 84309926022.29.D9F6205
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 02037140008
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:25:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ayMiNo98;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767903910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MA/2y/ntZvYGPrGoipJsdzhzol0fMpbZYSZ65gDPan8=;
	b=65wZ2GEGI4HHdv/0VQxFLzl/jgSEne/vtjxkFz2p6H3rmdmbY5E4WAFDDko60j4kS/+a5i
	p8hsngQjeqPS5wFxH1SD35B7sEdxnx2NDhhsOmWi+jsCJKZZ7lyakutCf57dpQ3RhlA3og
	U57urvEiJfnn7+OePnSuoiThc4D/M/0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ayMiNo98;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767903910; a=rsa-sha256;
	cv=none;
	b=dvb62IfsKTJLoMnlTvZtyMJFzrDg/K+COjOQ9KLG7sito9ZqPW5q9XL1jPGu6ynMiN/fLT
	y+MeYvnNgqCqGBAeoj+4zf1i5XQTNaVqAnU8zOol6z+goE2A3UJzdK0W2AitoRM53Yr0EU
	uzbUMqEG4qk4PRCUF5sqiKO02SJDY+M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0931560130;
	Thu,  8 Jan 2026 20:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D4AC116C6;
	Thu,  8 Jan 2026 20:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767903908;
	bh=XVfdVuCBvG2rp9iNO8J4pPYaLysLrDfmoMClySdA0sI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ayMiNo98qwCC+dSf1CS6jGRTFRoJdkTrajLzMKa7Wz6XAyknZD68CodPRWEpWIINd
	 x2ulKpHAzM0e+/EYYmDTtu27kPlegKjeIacNyeh13HYTMHAN4kbHRHqrq0D8ss9CK+
	 0ZwMdwNF1C7gTTiQ2lu+Ykb242+M7bcA28OE0noA=
Date: Thu, 8 Jan 2026 12:25:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: klourencodev@gmail.com, damon@lists.linux.dev, linux-mm@kvack.org, kevin
 <kevin@desktop-mu90jgd.home>
Subject: Re: [PATCH] mm/damon: fix typos in comments
Message-Id: <20260108122507.ad7e8a0520c1c58ccf4ebf36@linux-foundation.org>
In-Reply-To: <20260108051250.81675-1-sj@kernel.org>
References: <20251217222609.3355-1-sj@kernel.org>
	<20260108051250.81675-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 02037140008
X-Stat-Signature: rj7bzrttdb1irodgnkikuhht3x3dk53a
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1767903909-841814
X-HE-Meta: U2FsdGVkX19H6v25zEfGIEdFs07tUCyqWppUHv42RKhGiD+Jpb5WnQoTPUJrOZWRrRWexrg1q8wjvsGP31Aa6u8huJzPDS1OJ2cAm7JV5vxYEHlvLgiz4akOD44FxmdKLvNw4Hj2xIoh8+M9Unp2tiHSTJ6jPKpAt4lKM0b4Pf+hg6uRHSK0UWDqMIjjV45xAfyqfV2E6jTOPlMqFrimIYv8UxGc7PaoRnMt0vP7TsOIGaSnkku1KBtpQki7HoK8Hp7LeVg6o8nUhB6RDFaBgb/IK1NOTpEv/bnRChqhEdWCzgH9FfyPaoLrc9klU36GY9gZeUDyq7pQCiI5dQwhybqnpgQp4rlkJN4Q+oVqD7qv56JKQGEO9KZwKas59IYClOLslyDQMPEJqGBQBZ0o6J9+lyD+Av2g0uZbtDp57LDNA/aWnANr9qeJvm4Jwrd5IWEkf01nnk94k/eLycmc2mnd10v7RgdeHgudY2jcHVGTmhueHEp3j2jrMgRt3g7wR9+nvZF3GkLLzyzSntQFWR+enwJ5WmItHWNBz9A7qvyIkoKrLVLtqglqVCBfsa2A11yojRMak4NqcI66Y2tgNsOqZT464ewf74hJE5nJnvHJoTLJxFH4XCVhT2CywAWHm7XII2AIbjG6RItgogHDHNitD9HR+AIqkXX4srjPCrka7R9GWImrNTZ95oRSpelmMj4CtDKCpjzB93WGM7P+2Saqzj9CajMGjTIVpHWPO0CvHOqyV+7umiF9m7GH8le0sLUUCjFgHMonSEkYAeHp4e2CCuLix+GjV7QOq2QJn45Kyti5cduDk8FffwtHHAf9HjyCHs+RIlDKXkt4w3K1XMLLWVqkicF46//IeocZjJfa4+qgR/XDidyYUX4D38ZlZ4Emo4NFpf26zH7fO7L4igN5TPQN8WdQMOwheCJaBfJoM+48HE+f/X/ulKSxPosZKnagk7Pvrc2xotGn6Dc
 kC6RMMtB
 f/IHksY5uC2sMAH6MPCoSH/xms2RuNsg1zN4nJiFoKjdAUoZ0O/hz3xXm1Fdsv8LjTBvswz6TCObJCFZGc9TDRt3BqUTD9s0C8DEAyLXrJRtomffadqAa8Qrek+FdtDUKgq5hYceIo/iNSwOb48izTYpQYVr2GdInNSHX6CG4+lKFPGqfOFEc3yyzT4VF0223Ci79d1PxPMrkTReXBdq3MudpIx0BgRmA0w8VECOUjb01szYZnmihQ685rTNM1DMyRMIdvC2yu6ReFChYN1MIpJNsh25FZGV5Kh/T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  7 Jan 2026 21:12:49 -0800 SeongJae Park <sj@kernel.org> wrote:

> > 
> > Reviewed-by: SeongJae Park <sj@kernel.org>
> 
> But I just found you didn't add the above Reviewed-by: tag from mine, to the
> patch.  Sorry for catching this late, but could you please add it to the patch?

yep, thanks.

