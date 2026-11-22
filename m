Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EC4B606A33D
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 14:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HTGNS4xt
Received: by kanga.kvack.org (Postfix)
	id 78A7E6B00EF; Sun, 22 Nov 2026 09:30:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73BA86B05B0; Sun, 22 Nov 2026 09:30:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629C06B05B1; Sun, 22 Nov 2026 09:30:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33B3C6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 09:30:33 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5467CC0579
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:30:32 +0000 (UTC)
X-FDA: 85462990704.18.31CDCB1
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8118C140009
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:30:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=HTGNS4xt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795357830;
	b=oLRW8D1ns4LvGdc2BmV8uFKmZo/6t5rxMl7mI/GDy39bOHMUpq65J/lFwunnP89iGEoxzy
	SlkTGZe/PIwWNd2gC6DVY0jr+3QtUprFr9hBK9GT3IK78dIhq8gfesrwJQ2Nl2eOD2BfuH
	N77r8pkZHn7x6tV8a8bpFmPiimFpRKk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795357830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QBjN2nkZH7Gcj/ZwiauxMt+VX48sTrjkI/4AB/9s0ZI=;
	b=EOoHfpYvmtDbk03it0FFNu6+UOu+5Cb2JCITb+1chhRRZylE4JrKBjEgGVBtgeyXDM3EXx
	nlF4y18L4KGPI/guqcsrczvWzgMMRMrKISeZkMu2csvMWz0RASTylTw0/TgvfBNAtoKgqh
	D2SZjCKz4Ig8eBwA1nmUMh+KGVxc5qA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=HTGNS4xt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-3866a784546so2954457eec.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 06:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795357829; x=1795962629; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QBjN2nkZH7Gcj/ZwiauxMt+VX48sTrjkI/4AB/9s0ZI=;
        b=HTGNS4xt7K2qL4ncWexLl2pf1qpP3vSetyed7UAAJQ3DI47n7wwBRZ55jEHxq0P34b
         QDgS/nGrT+A2+C/1F0sizMBHmyOUbnEUySQ+s7+qylDrOBV/sXqHsN5NZp5NiSdP6N4X
         B/6N+iBWxGyjRKZE9NZf89InMdNg02Ya4Ckpv+IQMOwSngsuDVvv/K1DBE6oeCNs8etj
         nqlbpQL8RPxSNnt/vROfKGDiIwwGNJ1uCAkqiqKmL/q3z9pTW9uqzlzg4qMiie/rn7yt
         FYi1DEDYP/nCZkXWq28G/5wChBAzwNJYQrfhoU/pVINbzUl6NsTAzVjp2wIAbjUGe67q
         YssQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795357829; x=1795962629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QBjN2nkZH7Gcj/ZwiauxMt+VX48sTrjkI/4AB/9s0ZI=;
        b=bu9bKbbSx08uwszpBr5/U3W2c+U5lGXZz2VULWbMN2+KMjM0Qo3jXw5DI4K5WTW4fx
         86P5c6FJvnS/b5b1U+v4XRf+aC9GWOjGrxq2uhW2XP03r292yyc/MFYZK6Y5qzFpVoVa
         fmhMupn1QFF6SAo4XdM8GuLx1H+jSgWIdhoOuhlbB/zWNxr2WHEg3qQjtXlYKO9QnW5G
         diLKvcM5j9maHCTxJzMMeKCFDQ9xtKfEY1g6VRd0ow6gLWnSGNM9fUR2j92Jzk1jpAVO
         LCOxoCdkMhn8CIFH49MIe6MPxActWCfEBh1z8HZbPj4Hsz2o4Ty+RgsMKSQP8HgW+KUg
         HB2g==
X-Forwarded-Encrypted: i=1; AL+hErFJlij2RT+fSQyLloZZF8APtXeZ6u3RfJVOltKE3FN5pgVsa72ZfVnuE17znInaPv/RGzQXu3PZVA==@kvack.org
X-Gm-Message-State: APuU4Z+U8aBjnfXc0Hu2TnWGw8B2b4zuPkE4liRACsMo4wHIvSkgwa5E
	Fk2TlLxofHB8cNDhZa9EMouXRUHOV7UkmuIU2f0+1oqxTIoNUt5qKbguRJ4FkCnmf54=
X-Gm-Gg: AZFdTZdFYicLEzAKThrmVo/tiC/ONJd/4lgWzc5txjcL963ol83U5icVUd/0wJKnot/
	mDUISeNqopPfazb1jnk5J8hh2fJToN49L/5Q9afoIVSPSXEChZFwFj1pkmu+ALQRMqlfcxFgSfF
	PTxzRlY8rHXjQSM1n/M4kR8d/m7tTFGS0iAe7sHm+QVDTvKSAtLukH/F1GSqUl2eD6YFAN/17fS
	vVVsiwii4BlVR6wR7OTedbnDd279BovrMPXqya4XzAv/+nlpHHDsJfAKwHZLocGkk3YNHI1WPdr
	OGsuiBopTfnlhEE7/T5gCW2Q/wEIgJyxIm/4QDmjIr7Lo/bGhCWJ9zLbxxLvsM5PvOfg0yHfUi+
	PnK8nSP8q4sdqA/Ld8VzRgFbOit9V8E9xlfu9dZiqmYmcpnUI/J+1K+BsMD2lMmoRRU1+vuCaEA
	b3QYDB5fHmqmw3Ek8uwTyWlFnBmft13KvD5fAPkmGXhRy0P8yHTOSOrHIcuGdqbW7gvjE+YxE3r
	WpRw817/YVEQFb9zNa0tX1awX0EUNXpV+zaiRXH3VCb6aTDVRxl3Sj0NZu0zPyce2UHA+KDt7kz
	VUpgttJ+xo1tZ3oMfXHB36PXUo2SoG7r/aLUSxUUnrtlm5NgzrhEjjVezG2YRfOtW90gp1iDnJh
	k5BwXbK6IGmQWpg==
X-Received: by 2002:a05:7300:e9ce:20b0:36d:5102:9974 with SMTP id 5a478bee46e88-3856c2c2123mr11231914eec.2.1795357829128;
        Sun, 22 Nov 2026 06:30:29 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385667decc2sm27877901eec.9.2026.11.22.06.30.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Nov 2026 06:30:28 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 00/27] mm/damon: let users report their data attribute findings
Date: Sun, 22 Nov 2026 22:29:52 +0800
Message-ID: <20261122143011.85844-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8118C140009
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: oe6fpmkhcaompkqist38s1hhx89j49i3
X-Rspam-User:
X-HE-Tag: 1795357830-667940
X-HE-Meta: U2FsdGVkX1/JXKJtvnkahlMti5hMHekx33Pr2pN03+DRd0rvuUg71q8nMPO8G9U0jemKVz/t/ojgYCfxNmzz8EswnsSZmZqnbVZ8Gs15DkCZ8R9YcDCdxviLJXpttRENIomivCdESYBdaARGoY4uqXOJWKGVkgbLbCtvvERwptqarmmSqkqKRS9HtOWM6X5g88yH+xVkZN7XAwXSadD5cqSGWcIVThkCMUIU5bW+mcLcmqymCy7X5+4QhFjjs8Gn+GRcJqEPxWNmvJhPehj9XT0h/mL0w7bzslVnBAb3NiJd/HiHjkmRAciKQ6DKyqSUTlnODLNntQpeExOBLzh15UKSxLA9kQRJD/BiRE1QYKzzw1dHV9Evww3qCgbQnBVheh+oGfHwGppYUpGXg3cXVtEakVN9asp0GIUl7+9OrsyBD9WmNja0zFccfFxko/sWd++kxZ+X2OSL92dxSSjQtvCqZK/ZlMJobWRjY47OBGnSE0WfkZhyezQFO0riZwO0dcoqq6WXprnbhUVjqlVhZSiVuHRgBQAEzGUgpVfdJNz1XLMcFip+y+agS5YLBLT8BcbsndQ/D8IpzPihtQYTtgLw11Aq2/0ET62oigyKH5ELsOYMm9pNHnJPuZsTxrrdw38uC3slFO9tG57LK+F6X+andrvRkab85V3X1ka8xClgfVJdEiAAHPvBEA3tgxPC1tP/kqHe64eoEkpNMFG2TD+9iX2KUTo6tXeHAqyI+NxfDjywkohhB9sATx+keNapHPdLz1bNLvxW0zy//jQPnn73qNh0JCG8GEHGIP73ioXa1ISpRTx3knOUdAdGE9C4meG2xhke9rZpI+3cfZ70i34AjSurFVR8Xb8ml4mgRL1trsqAPYHvHcy54GABq36a2sPkrzNuwj15E3wWGkSNG5RlyqvCnjD6YSFyxCBWXbtpVcIl/xDzdKl/ZSdBtK3mQwt5toLKMwTwSAvqzNH
 30h4MKyX
 kOwUWLJJyDeJwTCTaBX09Mx4nHOA2iM9ViLeBP4UVlX4QDW6/GdGaFK6IwSOcEEg+VftouDdvKPBpc0x6sWgdu/C0zGDC1jPfOg1QaXNHbt08HHfcUd23PFfZQ9aKQxVooQpN6ytyYCwRXpQ1Jr2bsbUyoagX5WWj/DFtDos/6tYyg36mkMsxhV7d7NSD5rW29/QtRIrT+PgZbEXmSs9+D4j3RknGi/4kE9CVPgDbbSLez9s4x3hA3o7+52Vm5FhGWhzvSnuiSCG+vLtag/G2BCLn2ENqHJ/42UwBRC7EpYuREQCjBc1dix0Z2YOPFxuaidN6ifcWTgKMkXClme1PTqKVY53vugrLMKHTgp8K31koFx0CVDJmRgCif3IsUr8fGl1NRwZL3ZKGbeItlCk3SjMab4+W4OOUSF+xVC+1Y+tRYX/8taExrNW00rvlIySF1NosJM/OHrBCbf2FODfyXD+61KI3vSJQCrGVK2Okbl0dTM3AplSPj3pIJsef8QF0fwcpZiYUXbeBW+ePs6ctM+EE/lsxxnMqoKbRH6u1b80IUJEsQHLIqpdCbOsuMJrkMtXMWfgqqs6dDSQd7jO/QpKk8bzinj+/MTrM+mShjdDmWAPz371jKVGXSfntAPg0w+RNAJUDOk4PsBJbti+egOjOpcRY6+SPDOs7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 12:59:44 -0800 SJ Park <sj@kernel.org> wrote:

> Build a system for letting DAMON-external entities report their data
> attribute findings to DAMON.  Let users report their data attribute
> findings to DAMON using the report system.

Hi SJ,

I'm reviewing the series and setting up the tests. I'm also working on
follow-up test patches for the report queue and its sysfs interface.

My schedule may be a bit tight this week, but I'll follow up here as
soon as I find any issues.

Thanks,
Lian

