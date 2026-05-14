Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78D48CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 02:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBB5C6B0092; Wed, 13 May 2026 22:08:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44F96B0093; Wed, 13 May 2026 22:08:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0C406B0095; Wed, 13 May 2026 22:08:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACE036B0092
	for <linux-mm@kvack.org>; Wed, 13 May 2026 22:08:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F873404A7
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:08:24 +0000 (UTC)
X-FDA: 84764390928.24.F3764C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id B4CAB4000D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:08:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcDHKgws;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778724502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j5hl7OmobUsDwtr4Trit2xx02NAYascRtM2B1ru2fhc=;
	b=HLDs/KyaDR7izoPkVnhUeGw9GvqkG4AEmfm7uVPOfGCuHvQh3pZ3xUSZZyTEO8Lni0AA9M
	+judd6522Cx0qUsYEIdVkejdcFXzH87Vw/H4GqBQRzbOtnm0XYYYw24X+24IPxIRUqSs5j
	isdoXSk/dybCXi04A4zh+eixHkpzaJE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcDHKgws;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778724502; a=rsa-sha256;
	cv=none;
	b=bmRew5fUvqfQUf/S5FdvM5YyW05UHe+qzsQEUAlL6/Hy9MC4deRHsxkuhoqTZ28g+JM8u4
	X7AQHR64xP1m5R7+yIGzrK0oV96Om82tXFBZC2gL2sAfFKEz2tDPBDYJLS0LPvG8jvIj/F
	aiXsaj5381PleKPogEexT3FJp91n098=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0FFB9600AE;
	Thu, 14 May 2026 02:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6756CC2BCF5;
	Thu, 14 May 2026 02:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778724501;
	bh=xmsxTv55KQCamp+BbcWIA7dTWkfwnz+fL+Tk5BOdaf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcDHKgwsR1xJpgn6fXlYuN1JaRr1dqzEPzp15c05Qa+I67e8SEcomezzpwOTaEdeK
	 R2fftdQcfxVkwmRpsWyitS9WSl+yUtyD9lnf8JEzxy5yutIfz5c2ANYGiK4P07/rhW
	 /owETnOBEu3Zyi1bt9koLxaoMFzlWegzl1mCNV/Fv4hXV6zZzkCGXwewmnw5FxqBGy
	 kpsctY9kMQQi1CznF0KT5vlqXn00U8AZs8airKAYCHUUO5u0ebtFZtjhxvJTgtia8d
	 5kibv9JKQZB+wnkuhdoeeeFBcgLDqest5Tl3/5cjpGg2m9sa9g/t6SrY8FHl/sxY9D
	 Pc15ec/H4mbrA==
From: SeongJae Park <sj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 18/28] mm/damon: trace probe_hits
Date: Wed, 13 May 2026 19:08:12 -0700
Message-ID: <20260514020812.149894-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260513203237.3b1b3286@gandalf.local.home>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B4CAB4000D
X-Stat-Signature: c11mhj9a191e714gk9hdxx8jqwx8skg8
X-HE-Tag: 1778724502-919633
X-HE-Meta: U2FsdGVkX18R3ybInxepDpG9lAkEkL8H2TEWi/T7y0UaW+7v9ATGfP6JiBeEom9UrOG+ksrSiptS0f/uPLLAm7OF3o7U6pRuIGCqT08DwRS/aUXrcYg466wIpYnVYRpywZrokjcDbEYcc7uPq63bhNdZkA4J72TyCfKv8v2AwbASiXPJSQmmX+8RQHVuqNY6NGLGBexxblmeMthOZ/f8s2wpKB8+lb7PBMpEZvWcIJlQ0uaV1bgzoNEacmWoqHajfYCW2zDR9i4m2Gn/bNQWfYrizrQFZMzYMtl+GjlrXtoDIr1H14IGDFdxdpZEUtUx+TJREDNnJyD7DITHs5ohuRQrKaoHEFh84ItSPOtlEkvdN9fzGT9KphDNaFBMFxRYFaIKB3zBgemG6WXig6S8qmrrHsdvsKI6NCYcNmLihX07m3Vd036vFSdYqS2xSGlXQPwKBWgc+8jZal6gHyL57UGNEnNuMKzk0TLg9sDZ1xCgKI0ZyVeqbsCY14otGrG6BBCIrPmNjQhSlUW1DzJZBrUl99nsTl3y7+hryickTQItJ+5Uh8M6gRJuP460Z+gfjrfzmT8npoR7+6D17OAVcyxIIRY0hUrQQJZdm9vKcjCyTed9iM5UPeiAuN8nOZTqoefo90k6raAAIRqHT87Ct62QPHtGh/uoACAMdEDFg6+eLYL5Zrjdnoc43990EPjBcV3fFd6DuAHpi8TXVo2F41IhkAo95e7/QNh54gsEoD4vGiDqJYAcX5g6BxYOseRhGOOsdKWsgh1cCcFf3a9qXqgb88X8Opi64M9SGSBLj4s+N4hFtAeYqxBpgSqkmUM3PyRb/IY8UzR0lhWgODTxbKuavUx8QSw/5tEUwpszhssIIO7WivBjKlgfnydByOIuFmSEn8iiqz2q6By+WDOuFeiZqeoFwpfjOS6WiaoGvKECkGjYcRftxUoGdMkBhaTyclBmXXguz8SrdbDcoIn
 E1My1MMy
 Z0d3hAOpcpZgQcsvZzDOPsxp4jRp4DkHXSp3JIwHlzlJ6R45vsL8sQ0tMNuDCDOiTEEQmVXR9XUFr2Euw6LbDzFdCcZ2q0HraYhU9HzNaIxRF8g+lG4PJt6lzIJ7qP433G+y+uP8Z6Sf8Urio/7n+2O2lmmLTsIG78x11hDn643xwWBSVYDtvfk5J5aL4H51ot1PrYpzy6E8sg2ZzQ3ldXiSpbj9b14PcWYAJIo+zSjYhBtCsnMffDKWv4ymVjiNV4Hq2s3K7Jvx8wakVwvFvKpmto2DairCuwW/AAUSPtduUPQNgAgr0BtT4Mx5zKaZFph6ZHN0/use8W4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 May 2026 20:32:37 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 13 May 2026 17:06:10 -0700
> SeongJae Park <sj@kernel.org> wrote:
> 
> > Btw, if you don't mind, may I ask your opinion about the name having '_v2'
> > suffix?  I chose that as an RFC phase temporal name that doesn't break the
> > compatibility, planning to give it a better name later.  But I start feeling
> > just extending the original one might be another option because tracepoints are
> > not strict stable ABI to my understanding, and the change of the TP_prink
> > format should be simple enough (append the probe_hits= part) that the user
> > space could reasonably deal with.
> 
> It's only a stable ABI if some useful userspace tooling depends on it.
> Otherwise, feel free to change.

Makes perfect sense, thank you Steven!

> 
> Nothing really should be parsing the TP_printk() format part as it is
> really inefficient to do so. That's why I created libtraceevent and
> libtracefs to do the parsing of the raw data for you.

I will try to make DAMON user-space tool directly uses those.  At the moment,
it is lazily parsing trace-cmd or perf outputs.


Thanks,
SJ

[...]

