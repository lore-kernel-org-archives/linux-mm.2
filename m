Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71945C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 199426B0092; Wed, 26 Aug 2026 12:43:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123916B0095; Wed, 26 Aug 2026 12:43:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2CA16B0096; Wed, 26 Aug 2026 12:43:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7FB66B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:43:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 516C31601B6
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:43:29 +0000 (UTC)
X-FDA: 85143991338.05.21D4A55
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf29.hostedemail.com (Postfix) with ESMTP id 40FE6120007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:43:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="X 9w7/3k";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=iybq9esv;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787762607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NqES8EslKG0OtV6wDajYOfZeNHZies9zz1BZlvW2T2E=;
	b=bRrkxMbrmcgFV7URO+Rwi/i9rP6RKoslIsardNOoArIXac8X045QiCyJmiPvrp1gZqR7rP
	AWaXFOPh6u3/VNhiR01Vc33S9NeOx1pD/Ag1aUr8HA9K63lQbgpdzEU350gu2ukdlx9n0G
	4kIXmRXHQc1/XR0W2I2Wn0kqN5ZS+Wc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787762607;
	b=kw7kxX9yLl2yLmFFmWJ+jNnqwvKaiaHYlJ7lm2Oydm4t6LGt93D0ATR+pykTaMvLr6qTdF
	yNevLorkr2BSW2w3iBcwzYg0550FOMytftGzrgv/aspbyLbACw1xz2/kF+4WVTzbR5jDVM
	npKdFQKaAgjI4gTx1KobXJmTeBL4RJE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="X 9w7/3k";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=iybq9esv;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id A43DAEC00DA;
	Wed, 26 Aug 2026 12:43:26 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 26 Aug 2026 12:43:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787762606; x=
	1787849006; bh=NqES8EslKG0OtV6wDajYOfZeNHZies9zz1BZlvW2T2E=; b=X
	9w7/3kIe4u49OroNplXwQrcjIKDx6X0uY9+BEq1HPhnAzXbzAVaKgZrBKGellSwV
	Io9MMhlJTg8DAQIUeZjK1hAIr/OWSjbeHs800drepppCvcsKn4T+JAfhNDnuHfho
	u91E+jkGFBCZ38eCaaCCyIIN5G9N5NkcJLIXTYc/1ALRrApchcI3fEB1/5niJes0
	tpg1vu1bphFRZF1V7saPBNl2g9vJwNFr5FK7drR2kNAczI4InJ1VJcxFr7+w4O4T
	0oWFmHiUvYOoQCU5L62e0yX2ucVQ9ILTL/ro8N4ny41CSpnjZNcZcu9MMDhDCzWI
	4BJ2tVr/U6uBvtleuhvcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787762606; x=1787849006; bh=NqES8EslKG0OtV6wDajYOfZeNHZies9zz1B
	ZlvW2T2E=; b=iybq9esvEteIZgsyzUxcuncFt2ZsnTbNmulFF74pkucgBhLbCWY
	+BktZdtFgpj5dgOjIUFCPTMWiGk7tpri4wZtbe6hRUYYHR/I5a75T2q8iX9Nykrb
	mXFnrK2gPrMn619zrpd/6szWCrE6Eh4hqCiv+rtqOfWnomO7eV8qmCCJpjW8Ouky
	R4hV8CdBnVFmh/YU8nQy+hOAmBpNuDM3LFZ5o721QrhOy/ZNwPRj5HT/d9BEWgfc
	xmrTlJGmdrDG4+ehI1GE/WH4Cyk7OAyO0IabED5o9jmDn9eWC1Pdp5wuWlAoxnGL
	P24gBLdHAg+GeGTXWuaLcsFiir+R3gIJ/uA==
X-ME-Sender: <xms:rRePar2oX-1HOva128EPdIT1yKLEM1YcwDYbEg1U06eCA7onFadQLA>
    <xme:rRePag4MsRutS2Xu7mzz5L1QJroPpoRnYBYweSvjYCKQsW24S2gRQUeIUz9S36EMC
    KO-IKIx2YqIB-3W3NpNrON1iRdPlnnpLqCZcnL3pTRJ06w5t7fvTBBC>
X-ME-Received: <xmr:rRePak1MrPnmTLcJww1cMjKgJARkw2CCZQQTY0zSXsSLYzQSOj4OMS7FGdU>
X-ME-Proxy-Cause: dmFkZTF1T3n4WYvbpk7ULqXIBzlz3ulhLrqWxztDjzS2yQyqiQ5hvVHI/6p8UOsl/I5HMu
    /ymmwbatakciZMvV6IpDSgzgRHOejfz5rqJe3BSdWMcbRMceq5JqW2sSSYDGox0WT/xhC2
    uqeJRqn6eV6SZjbB93JurF2D+eRRPSsZTdv2HWN52G7sG0pkPhZ8359cEQS6IIvuKtKNKu
    pGAUFEPIZjdsFB01GaT8fOjkMQr83e7hST/JkiYnZn22V59QNGBvXczypQwLMgedgR4lkI
    Lkkw6F/9WBpdtdlcolpDGsmUCWMu/kGOnCluhfa8lk1QxiqdndPtafItolK3gx35Du4LDW
    B2HbXeck7Sk7hGb/BC1P7fcTXWbvObvVPHs+Z2I3TwuBlcvwu7IomndUwr16tQE+T7aXkO
    PyTpu2SUpScjaP+qtuTpFkQTbsEPCw+Bp1aJNXbIN5neFmd/HC4bQkhzNk+OZzmKWAVXfD
    UcHrTOqf4XpnK2IjnJjeShj6txWBM9Z6WVh1GggdQc4c80glbcPr4pRbh38xtl3Cx+bHjx
    Q3Q6oLk2cG2UOGI/P6kmD3RegQIeCJLwkLcl2owp1t+VECos8UCdUBJGuwlSDwnDkcC7vf
    GV8HFZ5TGlYORtcWYK7LvOe19Wf1Gn4990K056bwdv7pt3XslQwHc+wkCj/Q
X-ME-Proxy: <xmx:rRePajp250_enFyiT5-JD2hJf5TvojCuRohRHvmLrWZFPhfwotopRA>
    <xmx:rRePaiX27WIuTkOKnDrKq3mzENVt3Fzc5D6QWc6QSyaj1VteinnGLw>
    <xmx:rRePagd0gU3Nhn-wMBbX6mqZnlIzEMxBwwDZCloEMSO6Atd0nUsOIQ>
    <xmx:rReParDtkGG-GcSJs8icV6W5no7zCINcOvcsaIu6dp7oJwQQz9Cy6g>
    <xmx:rhePanXkWjorwItYaUIPp69k5WhMKAQuFfutyj35qnZc_-1XOeuc9ogF>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 12:43:24 -0400 (EDT)
Date: Wed, 26 Aug 2026 17:43:23 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hannes@cmpxchg.org, usama.arif@linux.dev, Kairui Song <kasong@tencent.com>, 
	lance.yang@linux.dev, hughd@google.com, baolin.wang@linux.alibaba.com, 
	baohua@kernel.org, liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com, 
	ryan.roberts@arm.com, balbirs@nvidia.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] mm/huge_memory: reduce indent level in
 __folio_freeze_and_split_unmapped()
Message-ID: <ao8Xaa4vGcAGPzCK@thinkstation>
References: <20260826162101.1314941-1-kirill@shutemov.name>
 <20260826162101.1314941-4-kirill@shutemov.name>
 <DKZ0RP174ZWV.1DP8KKRE1LQ6Y@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKZ0RP174ZWV.1DP8KKRE1LQ6Y@nvidia.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 40FE6120007
X-Stat-Signature: 5cuyiiy3ys664xi65s6fobx9pkfcspq7
X-Rspam-User: 
X-HE-Tag: 1787762607-373342
X-HE-Meta: U2FsdGVkX18LjuHBygy0g89s6jveFRVew8Uc5jtuBh61tVxwyrzGgbgxhf9Xs8KPd/c9BtdRoC4aGfJ43Oc9apP+uHq+d9bo1QO2eJfTX4S/AjCeqtdXX7QYwSF09sWsS5BOZ1l2fFR7Jr9d1oxQB8VnmJfk+HDAtUfbQR7pTupQTggH5QqmTkPStfD5lJIcnmEa9KVszePN0J4sU189iXhQ4ltIrKIN4vRyj3lkgkuoGTtTEZMjNiYJAlYtNTioxG+HJuOWxSSNN4mWrXyU5loxckrKjmowV/CuUoxgBJU/mWnz9UfVQpO/omlAgpX9JRAdnK3DPiEkwSN0Gbln6apmnrz/MrTt0mQO67CVf/03FPb6e+sycAqmUaMuXAgoY+xECDYDYo3Q1LttKRsY8bNEDxmVf3KcC9jAndRDgSt7pcX282kJhQVkj2TzhOVYkTUXIzWXGJM9ugW8widGTcNiP3twV+OaDQbv3DO9XDcTXZ2NHhUJMXE+DnuzOgFvTSmU6JIZkXu046C8/Ss5eKQbVeiGrNnOoKU5ODKS+3C5Vl8TXqGuRzo9winwSv2+pVnB5WsiwH6PucUH5x3lGHPMsRaFChVh4yBZC0q6sZsWX3F3FVa5YOGIAZg3huWedydcHB6hzvAzAWTiqlexiaAQGZFEvFCpqA0IK9NRMkFxT0F8IQoBqMXB/p4mY2LN6H85QTknBYt1zgrz4nWeDCF27rnlQXOMWxURCxyK+DKnOK5OI8lWuk0z1oWJF7142fvx3qWt9r4WvBJFn6zQPWRpwUbJYpzMBr+HISfIBttemx1dnwegRgZBgNQKaxZE8eYpPbsVFPoftZMX6Tbs4eiU5ngMmU+djQmOuRceYhJtBvsMR/AFZUrphyfY2J8AobwrXHtgmVx1l0CDmoBlj7HrCDvvHZRF+FmyDluTqXv3xRCJ5lRpV49GhZE4g3dV8fXQ38NyqDEKPMrWiXH
 xwz96lKn
 w8VS+nMJ7WPlgkkG487j04PmcHLee8bi+R/E8E1fkhM4BRDnqB9K7rfv/AhNHy284gzspzwZq5ue+u5k0eb6RM2Rb/h+viBZ3PMK0c7FLPHmQFS1qWSd/ywJazOvt14uXv+HIiIvzjLOVNDBCH2nUqtzACHUq2bcHXdJH9Tb/QGlMWfo+SH4mMnVQ9ciPR0j4wp5mz7F5ww8gJvmxEgyNu06BJ1eWP8VHoeQDZj+FrwfN1IdNIydkpz5NrCxCq4P4N3SEiqDbPxfwkMUyXdLvMzI/n8qhctw1eK89gWnMorFFR+FRQtSEusalHMCGTC2bJ3mVZgGmGz1aVDvd/Uw98wg+YbplU+56/UG08H2qYjhGUhuh20YbVnM0JRnYYieSNZSJa/raJMOUeiHhC9UBPC8wOKm5MTz6sN1VzkjIHm02XhtQB+U1x6Y9kMVCBN0KlWDkKosZU2+j4OQsE+bs19wEeqFszQPxuyFo1Gw1/T5gCh4HViauRhMFdp17WxfKLd2dokw4D3XdBt0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 12:34:47PM -0400, Zi Yan wrote:
> On Wed Aug 26, 2026 at 12:20 PM EDT, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> >
> > Trivial cleanup: short-circuit the function if folio_ref_freeze() fails.
> > It save an indent level for the whole function.
> >
> > No functional change intended.
> >
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> >  mm/huge_memory.c | 233 +++++++++++++++++++++++------------------------
> >  1 file changed, 115 insertions(+), 118 deletions(-)
> >
> 
> Kairui has a series that cleans up __folio_split()[1]. It seems that your
> patch 3, 4, and 5 overlap with his changes (e.g., your patch 3 is the
> same as his patch 3).

Ah, okay. Ignore 3-5 then.

I will review Kairui's patchset instead.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

