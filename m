Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB96EC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 03:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B071A6B008A; Tue,  8 Sep 2026 23:54:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7826B008C; Tue,  8 Sep 2026 23:54:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97FDD6B0092; Tue,  8 Sep 2026 23:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68B206B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 23:54:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8FA0160749
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:54:41 +0000 (UTC)
X-FDA: 85192857162.10.AC23E2E
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf12.hostedemail.com (Postfix) with ESMTP id DF1E840004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:54:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nduhh1Eq;
	spf=pass (imf12.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788926079;
	b=Tr1IHMaKpMqx4aKc5I2UU9BCUJBMSx0ifhip4eiIjRuejp2rqoGYXq8N3hjogQooGb8gRg
	jTmfiVII+pi/pau0jygBtrUzv9n30s+aahWPoNjQJ3Rrqvd5+k7SgHr0uNp5KZ57qxNijo
	pCuL5/M/PQn8LXnKj21nvdcut0hcx7c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nduhh1Eq;
	spf=pass (imf12.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788926079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVrTOgTm+0hJ1CwNzLVTB+HsMENUpTPm4cRxnxEzp5M=;
	b=wT1+cZe97AG6LagcrSEIbbfI+RFZ3yW1d+9V5PgWPrml3I2u0noqi9PJmpV3FtNwj2pYBZ
	zPMSySrirP7e2/5jLADbWemF7ywA6HaRwoAvJ9JxhFH10YJneyqRF3OrFC9UfuLny75Byy
	B6cWDOU/fQTlKnrwR3W8dKaxLKEZF6I=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccd78e6eso644397a91.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 20:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788926079; x=1789530879; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FVrTOgTm+0hJ1CwNzLVTB+HsMENUpTPm4cRxnxEzp5M=;
        b=nduhh1EqZ8P1v/+ximHKbH1ZMs7Lap4IXNaHfnkLqrRpXEEoFLztKtqiK2PAJE7EDQ
         KIEDDlHPe7XBCwg7s/RIfw3sNTzNCn6utlTxQYmuFIYGBo/hsgqboMySvixw9AnVwC6y
         dglvdXQhc/o+QDJRJPXzKTpwe5wc8g/Pt4P55gnI18Cez+FWytxYLy5iu8941UqSdzag
         9L0edT9U7sPtlXLl0G14DqItAXWYv9uD8Db19TCKiyHFsADq1O2WsISRLbw05Na0SWlx
         DnbLRtt/6Pku/YRm7KKIgB5thCniOonW/k1+4zhGxH8IHGmx1E3R8ayEggGl0la3VbJD
         g0vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788926079; x=1789530879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FVrTOgTm+0hJ1CwNzLVTB+HsMENUpTPm4cRxnxEzp5M=;
        b=Fe7ZZlTiovnXmpgB6vCvAT+ZonMJ89E0vLavhx+pd4qTo7ksQ0cXiX4LtBx0rW20N8
         uyoIlnWZpbtcPN4cQW2qbT8HHc+L3GN//IyEAD3CkYXD7l+uNU7GNBZO/uiQRMziw6+X
         TwGZu7SnTJH8cu4Vnech4KIWVGskExO2bsuH5/PkPjNxAzLOl29i2FAhoXDGDAdjGwZK
         0cDvUjOlMSyNpgkMigeOoEBttvFJDvThlm3Gscn9IINIJzEJIASgDFkItJyQQ3Gar+If
         r8tOlgsKNb3I/Nz24LwUg+J4T5Un1mck+ZqDFxvwu7HV/rxKxaV9kpDnRrxqLfmn1D/G
         /b+Q==
X-Forwarded-Encrypted: i=1; AKwUvBzR21WY4eKraeU/rCX3PJ9fseAdxcbEew7jibtCAh7YGdwJTyqy8YQxjh6ODFZH8Bk0aLbRAb6bYg==@kvack.org
X-Gm-Message-State: AFuF++lItZG3IlnYo/KerSUG0oquuTh1PGtgkZkjNRDlWocjjN1eTz8F
	nVGInt8yro61dR/HP43kWKo0weTIW7Ly8HmemUVeUIU2RIdVmgzMrJ4L
X-Gm-Gg: AYBFou3tEQR4gKfnl5IwYwnyoeVJkHuT8Wl3GtPdElxitYnTKHHt1RlOw2/VagQhDzB
	vuVg/SgCQFB11SLIyg3XuSJhBenHyBgqFJCwCLYldZPFSGHCZspY4kVurNzxuFqPzet53+1M3lH
	/CDUW5zbx/bgh9N6HAU/xkSumW3Qh9s6LOX+5dlI68HqQHAmrI5k3cOqCp6EZiodFl7NKRg8rCG
	qJcHlBc9e2xaN08PcoffJbuatjsUny3DOQGXO9BCwRP+TutnK7zmumNcpK0WP8Yo5m0IyvwBVsi
	O29BmLfBks9b8Q0hO8Id8eRMOXf7eepFz7bXsZwTpXCoEAJP4d4Jz9RhyM7nbs0ENMoMzoSlyvM
	2BIQZ2/vvQ94GHpELcncdLc9Rt9URT3aIRsP3AXuFpm1e2IumM1HqSRzo2JjMNHoLRCI3jMn+u7
	f+TXOd85pEOsB6dBJUhIl1CxbV2t4FG/Rbpbbed5es0BrkDENlEYxxChpSvsQwxxJ/cdmcvbaIq
	KVhwstQ
X-Received: by 2002:a17:90b:1c01:b0:384:927f:3db9 with SMTP id 98e67ed59e1d1-39b8bc95819mr8444097a91.1.1788926078043;
        Tue, 08 Sep 2026 20:54:38 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b07b197a9sm35037781a91.0.2026.09.08.20.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 20:54:37 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@gmail.com>,
	akpm@linux-foundation.org,
	lianux.mm@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/tests/core-kunit: improve nr_samples_per_aggr test isolation
Date: Wed,  9 Sep 2026 11:54:26 +0800
Message-ID: <20260909035430.2432886-1-kunwu.chan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908133651.96278-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DF1E840004
X-Rspam-User: 
X-Stat-Signature: oa4on3kmsfcf4dw7yh38ighptto3w6i9
X-HE-Tag: 1788926079-989819
X-HE-Meta: U2FsdGVkX19gfbMFclf1u27Dvp2U6pJMvG5w2N/rR9rKW9dwtnjsUyxW9ejl1V3q7FCqKGkrMFUY1F3BKKsIwKMA5L3EhRJXj7yGjM7dTW6zI4O7GDl6eqhQfudoGXx3NV04f777Fywwe5UNKgUAEeUA9TAPefVMh8c+4G972F5gDxYLoKlXnQjuU3jafXOJX/nQTRPgU2uu0isrHEwzRa9et4ykozRIRpWX5qqQ5NYRHJF6edWrd6U5YgmQU0gzs76cssCkaeuqEyszVeCpqekIq/6/CbKGW44HcoE2hsCrA4Jn/2ACkdPALwpyvSkwUVXR7zaqlvl79H4QEAqtvqZozpZP8oxAiiaIe1lpovD1IDp7umV+AU5/OGA1oWdF3h6JdMCWq+qZ55DDgjweDofC+WUoVHKx6EyvNC0Y8I7yycCJBq/6K5TrvQkGsfy3h/m5ETsRxG8QkrxdhqOb8dHGADRHJ/ay+hft20oKnIOIk8o+XDu1uvHefIna6b6M/tZ5wXiRxZTEUlGQOKOJTUeuF14IqBJVWdqjLbfyB2KcO4QS4/UL1MtCbQ9M1YaR9aZUm3j10btTuO1GhoDxWysXJMlAXvbZYD3hDj0ZmFpESuRa9sDxRiLaNERuWF3xLhHd+8UHAtiuQEZ2/+SGI76urm/jTKNaZxFNk3GSfck4/8qPMh5PDwqzFLzx8FNQhrEwFxSXH91Jzz8zni9A4I/axnloIewLaorUQriVsglxc79FDE+xz+m86oGaAzLCoTX1Szt+Zl/NYEsakfNFvSKX2DaF/g3nYwYqVX+06ZKb+DAqEr2JSCFgrE/QjCfDt6uW0r4c7gRrLAuCQCOP6yJZ16WVmC9osRdS6gbzgIfDJzCwx2lIEV7fb9gS/WRt36cZ9xFHm8yohjvYk1U5vNMzRZYJEotrccZkWFvDsloa28zQgeXKhi7dLYOYnevRGr11ULpMUVpDzIy5Smb
 qAVev+Ir
 0HC8wp1jaEEgczHfw1feWDEMDvMoOLsiAPlRKVESoARg7i++hRsWo4sk7xj3Kg8ss681KEFqAx6XjVE04wudSh3bJY+E2pInHSrCK3KyZ+Dtde+UoSC0y9j0+qdL3l6OpLJw5l78vCKeTRpreY5F/IjVLkQnFYVShNrff2N0YjsCitWmIYGaGyZOEOZ01veym8mwh50Zth5NRcVu1pq++l4WxliX+jJf29bwaXsW4bCCuW9EZoA/4iRbyv19OPpaFZ4Qh6GXF14XDbT/EWfgem+bDKMtqWlA+3waq5/Ipyd2naDoJ1DE3E1Fpsm910KYJZSdVPeVSc20Um6BhzLTEMXbWfEGB8NY3viOhAMQdmE23dH6xpUpfX+9Os0aXwTFDbO/VRsLWTv/LAGkJW7InNJlj3lpMx/RIZlntpWNKabKq5YKv8I7UkxwSFoGFbRYwmM3WFsAH63u+vzh28TJXQO6SF4uUT1NQvmOGs1WthCRP4VqBr+Jbv39MOT4JKPrbjGVV9CjOPg7ghe1BDJ5OIEaCVVe7dQO2Wo1b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  8 Sep 2026 06:36:50 -0700 SJ Park <sj@kernel.org> wrote:

> Hi Kunwu,
> 
> On Tue,  8 Sep 2026 14:36:35 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:
> 
> > The damon_nr_samples_per_aggr() test sets both intervals to zero,
> > which exercises two different fallback paths at once.
> > 
> > Use separate compound initializers for each case so that each case
> > tests one fallback path independently. Also make the overflow case
> > use an explicit non-zero sample interval so that it does not depend
> > on the zero sample interval fallback.
> 
> Thank you for sharing this patch!
> 
> > 
> > Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
> > ---
> >  mm/damon/tests/core-kunit.h | 19 +++++++++++++++----
> >  1 file changed, 15 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> > index c01e6a75cad..ff23208c181 100644
> > --- a/mm/damon/tests/core-kunit.h
> > +++ b/mm/damon/tests/core-kunit.h
> > @@ -627,12 +627,20 @@ static void damon_test_set_regions(struct kunit *test)
> >  
> >  static void damon_test_nr_samples_per_aggr(struct kunit *test)
> >  {
> > -	struct damon_attrs attrs = {
> > +	struct damon_attrs attrs;
> > +
> > +	/* Zero sample interval is treated as one. */
> > +	attrs = (struct damon_attrs){
> >  		.sample_interval = 0,
> > -		.aggr_interval = 0,
> > +		.aggr_interval = 5000,
> >  	};
> > +	KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs), 5000);
> 
> Thank you for adding this test case.
> 
> >  
> > -	/* Zero aggregation interval doesn't cause division by zero */
> > +	/* Zero samples per aggregation is treated as one. */
> > +	attrs = (struct damon_attrs){
> > +		.sample_interval = 5000,
> > +		.aggr_interval = 0,
> > +	};
> >  	KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs), 1);
> 
> But damon_set_attrs() disallows sample intervals that are larger than the
> aggregation intervals.  Hence this setup is somewhat unrealistic.  Should we
> set sample_interval zero?

Good point. 
I checked damon_set_attrs() as well, and the `sample_interval <= aggr_interval` 
constraint makes `0/0` the consistent boundary case here.

I'll update the second case accordingly.

Thanks,
KunWu

> 
> >  
> >  	/*
> > @@ -640,7 +648,10 @@ static void damon_test_nr_samples_per_aggr(struct kunit *test)
> >  	 * overflow
> >  	 */
> >  	if (ULONG_MAX > UINT_MAX) {
> > -		attrs.aggr_interval = (unsigned long)UINT_MAX + 1;
> > +		attrs = (struct damon_attrs){
> > +			.sample_interval = 1,
> > +			.aggr_interval = (unsigned long)UINT_MAX + 1,
> > +		};
> >  		KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs),
> >  				UINT_MAX);
> >  	}
> > 
> > base-commit: d118502628f8b673be9023db8bdf878f64a7ed45
> > -- 
> > 2.43.0
> 
> 
> Thanks,
> SJ
> 

Sent using hkml (https://github.com/sjp38/hackermail)

