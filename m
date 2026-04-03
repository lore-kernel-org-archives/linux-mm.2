Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DB25E7E36C
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 10:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87C966B0005; Fri,  3 Apr 2026 06:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80C5F6B0089; Fri,  3 Apr 2026 06:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6116B008A; Fri,  3 Apr 2026 06:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7B26B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:41:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05971B9FBD
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:41:45 +0000 (UTC)
X-FDA: 84616903770.22.2D5CFA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4D7CBA0002
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:41:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z4DoXENk;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775212903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2w4PGdeK7+Ke3UVn2aJ1lDy1dtsUNB97CETQSTZzgsw=;
	b=By+T6lu2A7MhRBZWp4LmISoUOtt5U2wElrxrqugjEPIhmddA4iiwPd273UG/fdayXD8+/c
	fBl+HIoCCOMM76E1U7qhweETheJmdle+dZx35sv5XLLOYkvVLDBAonjTIMPI9abfJE6cSP
	W77vtDwY/vlG5C+03dB98alfFQumjEI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z4DoXENk;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775212903; a=rsa-sha256;
	cv=none;
	b=No2tHj8Bz2LKN2lc4Q82dNC5eFYdP9feJYiVqOI4bWIMSWkJSw3C/bacDRUK7Z14uuKyS9
	VMo3eM9V94mmMoKr9b8cdyrdd0DsD20mgYf14wgN/udfQ2vhl9pnUHverHA61tRfGkU7aM
	cgjKOtoaxJ6fGQFdLCyfsYELBvgH/oU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2344E43ED7;
	Fri,  3 Apr 2026 10:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47117C4CEF7;
	Fri,  3 Apr 2026 10:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775212902;
	bh=dXwc6I3MCgb2B6MkMoWoOOmtFq9auKmn0yCFwXi1vmQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Z4DoXENklwq7aPUqZHn1E0zZ7gGp4I89MaDD8hlP9gX2Dr4MTtDxp2/0PgRtpWi5Q
	 1UrJdBo7BcHX+8TFPAIB2nvYguReYfgOsmk6ZbGTgPoHILitmMU4+lnWKLZ348LrSv
	 7dfA/5oQaCxh1QYAK1DANjyu/17A0S/IUXVP0y6hjQJyA8U4dObpIGZLAWwTyOJO3Y
	 NWu+UYHrNcCKze/eqCnqC4pFss/PKKpHI1QrN25n3XmgUwm86sJdw5TtVbZoRBH7xZ
	 pyTpiuHWsHu3s0ncwJS+XNwPXNUNaGCkmwJ+N7u/bjjouvumSP8Xkk25h03SnW1/gn
	 WGVFtqBQJDxvA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org,  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,  pratyush@kernel.org,
  skhawaja@google.com
Subject: Re: [PATCH v3 09/10] liveupdate: Make unregister functions return void
In-Reply-To: <20260327033335.696621-10-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 27 Mar 2026 03:33:33 +0000")
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
	<20260327033335.696621-10-pasha.tatashin@soleen.com>
Date: Fri, 03 Apr 2026 10:41:38 +0000
Message-ID: <2vxza4vke36l.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4D7CBA0002
X-Stat-Signature: ei11eo3xi7ho8zcbjhdxokc9769byh4z
X-Rspam-User: 
X-HE-Tag: 1775212903-235441
X-HE-Meta: U2FsdGVkX1/BJnmS5VWEqZd1XALWhVQZWecBCuLl/fkmpnuvolp2oDwCBEPYR5G2GZukwJqNVe0yMXWw4uscLRuTX+5clnCjkkIxqDxgqBQr+eAS963MvatfqyC8GZwulMPQ6jr6l+gFpUR5sgWxYDqnRj2UqEpKVx4ybfr9xYCM+4er9nMV9lBK0s0Fg3vKaQ1Wcg9wCwu3hyMLGvvkUgEAsDeQ7QEcJkJu5bu/nADiM8TeyVIpYrp0qlDvwdtsv06K/rKAckgh5MV7D8haje/LqlM26KpZRyEz8TOnEH5R4wq6rq6lF5S5zgK6a48GdHGvb4KWUONa96vsnC4rNKonQIo5dyK6pjQOMokW2/mKw3QccFCAGCw+2UHPvjXq3BZcxZssm04VFwBozzsfAoWZnjDz7PNUcre4w72zxiKqJwwZ22SZMpVAsfHZd1kqcNC+m6OQtP5dxJbaF8+TCkVG4s2oGJev0cBTgp2G+D/nuVUaduzNyBkRF/omd18R89KdsB7ic00ZdnVabeSEAXrcWEEU2pzSJ+kCTJ02p+/V1KtcoOZuFf9q0s8IyXoBo7wSl4YHtfSUIIwJkHbxKEXRySfKCtvTTpQhM3IGdwrMXsOY+9V8SO8acNAz2u4XQmIo8AEFR8SMnrzwB5XM2jLuNuPeNrxV+Vg7ZoL+wT/5rqCwW8Iqsl1py2em9f72QAOBQnvKf9UzLIGc85kRoFVLkdFKFKsntanhu6UonlQBPY9WFXZg1LUFGB9VSMospikojH0caCcraA600lTxNp4GLH8R8diWvtxC3DBkpa/UWaOFf/+hNdCFBo0eBesGF+Kh0I1lmoZLMhZbG27yZcbpC04Z1JYvpvsYpdD5gXUUvgZ3QU93CWlxhs6GepA4IZ/5q6uIo5J8AI25anyMa7fm499C5a8pe1+sdY2xtl2iK4UBCHBpcvzfZ0LKMw+qb7LKhJeJsRu3lGZCotd
 /6Nr2rBQ
 B7Kwp2FGD97PMiFzYqLqhDyffDiYMTSop0g74jFXdZQ5VoR8H7zbGLTK8YhTY7MTgWk40rSAKQnWeCmJpTCkTOfJaaQZdhTVfVyibVFodaEzvimgKyf6MuhWs4Ff6NCmF/anBztkMOi/1LF/8t1zyhPOBWsDRmBVnsYr0Rlu/uSh/BCjTGCyrz7/n7E/s0C/5LyaanlYZ+lfpwZXQSuf9zRXUJ1jXvDdoCUofkHw+9MCw6YRVNm6ckEuYC7TFeeD2zbJG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27 2026, Pasha Tatashin wrote:

> Change liveupdate_unregister_file_handler and liveupdate_unregister_flb
> to return void instead of an error code. This follows the design
> principle that unregistration during module unload should not fail,
> as the unload cannot be stopped at that point.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

