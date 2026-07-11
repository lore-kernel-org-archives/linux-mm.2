Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41798C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 00:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88E116B0092; Fri, 10 Jul 2026 20:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865916B0093; Fri, 10 Jul 2026 20:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77B6E6B0095; Fri, 10 Jul 2026 20:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53EAF6B0092
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:21:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4163C3F5D
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:21:38 +0000 (UTC)
X-FDA: 84974592276.14.B57BF68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 214641C000B
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:21:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NMvgPx/T";
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783729297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYQiKMWE2mmb3f7us04De1XfSFWoZkhtk35nJAydwh8=;
	b=EBwCOnhsmEO2oJNAxGBkvRPXGzVGAJuRlM7cjy8b9naL5gowmHDFrHTugh3pFCRrQbTQTo
	jEsM+fgZ6Ci25+IkXMnV+18cnEC3zzDjUOpACJTJUDK1LamEAhJK2hCqWDCiynX7QQXLWS
	7wIMV4CcYZwHecrMokh0EPONHIOZ+Us=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NMvgPx/T";
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783729297;
	b=xWJioEZu2RJgFwwrABGaXq2wggnFD+wQt2+KWlMrTgbusV0siEKMmOll7MQlbhF8nNOF2Y
	xFOWtuHvyZU0FcJ/JcHM6wbflbFphlKLTP4r20eBgPVWtT5iIIn2BpWfMp2CXNfWM2OWY3
	AWmdEuXcwd/gzLrBpuvvKpkhN7RnO/g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A255060051;
	Sat, 11 Jul 2026 00:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DB61F000E9;
	Sat, 11 Jul 2026 00:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783729296;
	bh=qYQiKMWE2mmb3f7us04De1XfSFWoZkhtk35nJAydwh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMvgPx/TkwCOIr++tPwvI0CK5E/8JaJb/sCrDwY1I1e59hVNcVC3opeHoSr1r16OL
	 x/lEfLU0OGBCWQRNv6grEMOW6nTr97oPM12vARSoKVuU55utoMo9QIXF29ExTrU+4U
	 tD5EPWjwihpruiQknt6yh4rERnpCsjmYL048IaUIPBAyMCsASVpWbGR/boEY12ZKNA
	 cAlQOiDUHPfleNw3cHK/KiZpqp+okxYqOG/sfTarvsU4q+NkIeTCxLvivq0IO1rvgE
	 7xKwJtVrFuHcYvS+UQzktIFMrPE6HkSt2+5dE7kbtXH0l3bt/3aq4UIcnJbWsO38au
	 vTzzGpJ1EsrdQ==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Song Hu <husong@kylinos.cn>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/4] Docs/ABI/damon: fix typo in intervals_goal sysfs path
Date: Fri, 10 Jul 2026 17:21:25 -0700
Message-ID: <20260711002127.32005-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710141738.24789-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 214641C000B
X-Stat-Signature: tt3zd558zxwzkw8skw7ij96bdcuf5k9p
X-HE-Tag: 1783729297-963517
X-HE-Meta: U2FsdGVkX19svdSnasjWTzH0Jw+OvAdwLOIwIQqm4pGFkfVKXXjEivInbbeNZvcbkbQ59u5o+Dn7AT2jnRZaVPjxBTNUcSbn5ztHU5MNameor5CWi39PySLMHE+ouyzSbpt5+nZOzpuSmhXpwL37yueMZV2tSgu66rAEkHPfzZhEIsEErGr5mQ1TeVkpnL1y7l35CFuOQ9VfJdUqEemUlflNKX9WC9AcOUDTT3/dx7PbQHiu4I13DMv6uX1CYFKd/ZZOERNJJeU0bdyEgRrV3MXb8y3JiTWSVU9TNOEpCVTU3jc3KK0Y6dHYDBHIN5Z7BG22A8ycBwc61HhPDa1uwm2dsbog1f8haBhmCgh+kJBp+007POKdvlMw1O4NuryS8a7YuPdc3/DaF51mBttDHp/Vxe1b4l2RqrMhI0G/QMpsDrXkWzMoYhgmvuws01ZPzbE2tQUftFmuuBFVUajIRSvw/pyicXGwwxsr/7hd/8gqGY84uOttLeWWDDMQf1CVRbidfL+fWI/uMuibHR1/LD7WPvtklrKP1vnpGmk2Egra/Ikuup6Awckqu87np6SwKBb8QioGf+ALfCimZCbLWd/MKELZWh6Tlv3fQSQtwtmNMMgUf634t3ZFTH5SZP+UewNkZy2DxIONXjfQLke2Q7DE20YlU3A8RXrzTvNm0a+ESmqqX3RYsfXhaNh9UhSmy3TRXlDRaTRp5gzDAN0K1OgR3WYeeeZJXGp50iKuMlRoPGXfHiZ4t/DRf3qNgaeHmoi7qBZZyQgaY5mq+ltq889qEoc/M2HHJY03z4EiFXt8KfATLkDT7wgfE41LXbUnwaNakVqeepsYCLLsdoT86SZH2bf6vJszGcotbOsxyp5if6OiZdOIK8iVh7FwUu5TWaplvBQ7QUKGriy3Sy3L8CsWniQGhuMUVFMdBvywWIB4Wbgdqf6yECIBWN5odQHomyh3p1GCy6BN19YhGsb
 VujXS3Ma
 eqT92yGYQnyLvxIGH2Sm9G8rJy0RE6T8jjixS9fELaYsOyZNtLi8QAo6TzHB9kMcznHi7+j2ZP+OhUKkxZwDL8DVx/Oyu3nvEhUVrdaSt939WIsdIWnEoOAcOtQVGfGx+xzy6rZpCeV2454C0wNC0p59q1CbGoFFekGrDT4/ywQzA87GI1LgJWoY9GQPBIrOd38Q7XBOeHRUrsrBYhM/KulKiFtG5z/HSTUFX63DcDiyMykkTVQ0wC0AK4qFvK+DEoZ78gt35Uf9suSTFx08ZpxmtFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 07:17:37 -0700 SJ Park <sj@kernel.org> wrote:

> On Fri, 10 Jul 2026 12:47:34 +0800 Song Hu <husong@kylinos.cn> wrote:
> 
> > The ABI document spells the DAMON sysfs directory as "intrvals_goal"
> > (missing 'e') in four What: entries, but the kernel creates it as
> > "intervals_goal" (mm/damon/sysfs.c).  Following the documented path
> > therefore yields a non-existent directory.
> 
> Nice catch!
> 
> > 
> > Fixes: e2b23dc62369 ("Docs/ABI/damon: document intervals auto-tuning ABI")
> > Cc: stable@vger.kernel.org

By the way, hotfixes and non-hotfixes usually take different trains to the
mainline.  Having those in single series therefore makes maintainer works
difficult.  I understand this is not a hotfix but just somewhat worthy to
eventually be backported to stable kernels.  So no problem for this.

But, from the next time, please clarify or use different series for Cc: stable@
patches.


Thanks,
SJ

[...]

