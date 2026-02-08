Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A7A9EF06EC
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 20:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637AB6B0089; Sun,  8 Feb 2026 15:10:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EEA56B0092; Sun,  8 Feb 2026 15:10:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 542976B0093; Sun,  8 Feb 2026 15:10:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41BF06B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 15:10:55 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF2121B313E
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 20:10:54 +0000 (UTC)
X-FDA: 84422382828.18.29CC5AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2CC5540009
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 20:10:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JvgnHRju;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770581453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S6Q4sf0nR9O3m/0VWZhSWmvFNa5IMfKLO0SAa1Kq3Mk=;
	b=gzRiW90gfdhmlL5nuoVcaIhtJkQGiSOLHIfJsW/TXj98dKCp/eo6z2U1zoN24Vd0dhn8ID
	v3mGF7slQJWvQmdz9gIqforU+P2MqGpOK2pKZkIRtxfo9f1tvkVxHWtYRC8clHVUXcDBsl
	bAErM73uR8i5qy+yv5LzqB/fK99kxgs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JvgnHRju;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770581453; a=rsa-sha256;
	cv=none;
	b=I/R/gaDPGoZMz3Lm+GhwnLVRha3Ew1cVN8squjMGPogQa6HHQG2Wfq3BwbxJfa3VedOkQw
	co941ePILefbB8ebjZ32yRn1oxp/jJ2ttydwfdtC02uax3BA0u2Bkc1HRuwflq8JO3rWH+
	12jEf1vbZsPG/NkTUWyicx/AMOKP2jI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0ABD5439B7;
	Sun,  8 Feb 2026 20:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8E6C4CEF7;
	Sun,  8 Feb 2026 20:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770581451;
	bh=DFG7MTacCxxa3rwiJNM3woJ5ozn3NWsjEekdd4Rw5s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvgnHRjuSjpDFg+Dm/lrxtD9HyHYHfIcIMIHGAKZnf2R7XPJx1+XJNzPfA2O3odbh
	 YWUmzgYG6qcGd5vTsv/EcTM0EnSDf/bN43365x+sVotl2CkT//x18ZATuQwG98H5Kh
	 +YqJmXsiDMNSuqMQDs3SAStISC93UOVHmHonCFDYPVYnyY1TgxHA7KLvTt9TEsgI0J
	 26wVEE/BlmRYt5vqGYIe1VVHErSdChLWj1Nu+s4/TVAYEJMncVTr2aNtEbJ+6yKPxO
	 wSVDOhM30Jsab9AwKulRKChXl79awII/30pW4XEujUmuAFwgO7mAULVAuIQtdpYZXO
	 6CoeeAqez0Emg==
From: SeongJae Park <sj@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kees Cook <kees@kernel.org>,
	Christopher Bazley <chris.bazley.wg14@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Marco Elver <elver@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Jann Horn <jannh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: Re: [PATCH v6 4/4] mm: Use ARRAY_END() instead of open-coding it
Date: Sun,  8 Feb 2026 12:10:46 -0800
Message-ID: <20260208201047.104667-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2335917d123891fec074ab1b3acfb517cf14b5a7.1765449750.git.alx@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2CC5540009
X-Stat-Signature: 5ejxpihnpszsh5mrjuxzi4fmkaknyjdr
X-Rspam-User: 
X-HE-Tag: 1770581452-667318
X-HE-Meta: U2FsdGVkX18CSOFhACm3/4KRSP4xr3mbMcwv8eJqUKsYU5p3QJ834EPg5DocIyEBI+kOofmKzGFeH8CdE65B83nhHjseNj1juAmeWZYicKyx1C3ikX+vlezKYFCU7+mAYhpEbxUdHJVimH/PJhhm5aL6c35Z5yLRTNx+Px/yryxBP64DplbLGnI5kzL+Lmj1FnHslNPeUJHItUufv9XC2t3EI4LaspdhHYbV3pfY7q0rJzROEJvZeYbB+dBD3QxRxpt0u1SG+KehV/ckn4C5UJDf6aWwcaT+f3yI5R4PPjqpCSRZCZXwoRtw1nNKmwW6gUzgokARJr8FW4AKMqf/ZNBydLM4p3vQXAmnqBmhti4Af/uXsN2tbdC/wK3RNOSzxzi1Y724RVPe22ix8knfzajk0Nh1ZL0UuaILxFGViTaujJ3wYx8tEJMQdiomhREY0i/82mpI35YM98KyQ4EwoMnw17+oYobsZ08vKqe4sOVqdjuwC+kGmseO4KJdmUrhNxspBLBnMQQ773oC+0lODKazd5yewgV35GxlzybkyCdHwsBbpGHZN25BxKwLQNNuMwOO7GbMq/ZczPSwp2jiYyWdvaYH9WIKKuT34zSYuBixxQNVQQPoRC7gN3Pzv3Y/dVIL165ZUyF1RB+ESk+2aRkdneCckTwzrQawq+FHUhTPx9dboRHBlDjJbOYCPj/frmVgjb1839dnwA4J5md8AKoQlbi+WnyGjSCNOz07cNxeVGT2TAiA0Hdd38mjAWZ+EyYtodkZXbQydHq8HzVr8Y9f5WXEwP46K43jyIfU0LVEi2o5BcuJ1R7Qwl/e2xHh2DrbyKC+hWNwAgq6Me9nhxP/EK5q8aTxTk1xF1NNpX6qX/UDp3nqFFPLvn3cM+/0VvV/MQzqGJzgUtrdI0IDBxx8cGqWcuGYoVe3PpxRxbHOvZfdPZROG1qwxHJx/GL3taZB6a6GK75WlC0RPPd
 AbaSNPkl
 3qnWnW2vMHmGTjoaskcJuMkPvYAZ/YhNL/H7VHmzc0n7kxD7MGqMSoB52g3e+eU1a21TtuO6tWWQTkar1j5M2nRhtP1i4Vw79JpLsSRROhE1rLNhsAVWDjMActEz0kaiOJkHjerHCGDEBnGsgql0by1tAxd7pjr06STARzvsysVlfGM9tgZ+cHsTgQEfhajUbLFcgY8OFVbeQn6rRPJyoeiJIKfY5J01onZ5IT4yPiZj17nCEYexrMtiZIh+su4LAu+URUGedlAqem/WF9ahR9mY50en/85XFUjBaZPGxV/TFRUeakZQUnqkCBOw2bKSuF7odaNcNjQ41NiHl3CGvK6sXfF2PfepSPvLhwwW29omW2yIehQtV7JC7F3Sxr6W8bqoz9jqNBObrI1regCVk53SgB/TYyzptbrWH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025 11:44:04 +0100 Alejandro Colomar <alx@kernel.org> wrote:

> There aren't any bugs in this code; it's purely cosmetic.
> 
> By using ARRAY_END(), we prevent future issues, in case the code is
> modified; it has less moving parts.  Also, it should be more readable
> (and perhaps more importantly, greppable), as there are several ways of
> writing an expression that gets the end of an array, which are unified
> by this API name.
> 
> Cc: Kees Cook <kees@kernel.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Alejandro Colomar <alx@kernel.org>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

