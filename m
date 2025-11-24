Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57138CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 18:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A40226B0029; Mon, 24 Nov 2025 13:25:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0D06B002A; Mon, 24 Nov 2025 13:25:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92DCF6B002B; Mon, 24 Nov 2025 13:25:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 82A476B0029
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:25:29 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 24E371A04EE
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:25:29 +0000 (UTC)
X-FDA: 84146328378.15.112EF01
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 19B14180016
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:25:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IsawYECe;
	spf=pass (imf06.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764008727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=71o+PC47JuSXVbd2aeyANpOeKyMFPrn2rAw5uI8OTCw=;
	b=CTiT4xHyHcqB7NXG8g5Gvwf+baD27BG8txsK8APUtQ5pY3iuW05clvVuB2pm923N/5IAnm
	ro062vv7JFbzbMWcSe8t9i2MAZirs17b3erMz9uiXVrHmRvyw1vpJ4vK885xpBulaiWbkJ
	ERKowVFVkcY0SzvKudXuu9/63F+hWwc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IsawYECe;
	spf=pass (imf06.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764008727; a=rsa-sha256;
	cv=none;
	b=P5HD0MqABCOuRDrrj36mA6XEHlJkk5BPYFcWOCPej+/Yo3jGOmUz+Cqrp/wZu2FVnvaxXl
	/+SjjBv1wUsfai6JIr9xgCfi9ZJ8Ss2adceXfp/BculR4QvmHAdCqy/WdBE3qm4IFJMiSS
	8DuPF3CbFLmH3QP0JcCS0UUIwaQl3fU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764008726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=71o+PC47JuSXVbd2aeyANpOeKyMFPrn2rAw5uI8OTCw=;
	b=IsawYECeFryRg/j3eeXnXY5gmGDs8Ib8MM3unlrN7n8kfg1ThfXonR8sdakZpQPtmH+10Y
	Gc4sFdtZXbk7s3OTZgVdyDdt9bMTtlEEFhxjwvplJhZeSdEPmrZ1CspkZRAxebiFSkstFJ
	ELbDnoc4037kmpA5c5fhe12D/ePef1k=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-398-02jQGE2dMku_MVsE_7IE3Q-1; Mon,
 24 Nov 2025 13:25:22 -0500
X-MC-Unique: 02jQGE2dMku_MVsE_7IE3Q-1
X-Mimecast-MFC-AGG-ID: 02jQGE2dMku_MVsE_7IE3Q_1764008721
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 345C6195608D;
	Mon, 24 Nov 2025 18:25:21 +0000 (UTC)
Received: from fedora (unknown [10.45.224.27])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 223621800451;
	Mon, 24 Nov 2025 18:25:18 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 24 Nov 2025 19:25:20 +0100 (CET)
Date: Mon, 24 Nov 2025 19:25:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] ns: pad refcount
Message-ID: <aSSjDf_qQMvCteXY@redhat.com>
References: <20251123063054.3502938-1-mjguzik@gmail.com>
 <20251123063054.3502938-3-mjguzik@gmail.com>
 <aSNZVv6BZCZcRsgs@redhat.com>
 <CAGudoHEsUV+fe4vY7G0FF3T_bki=Nh-QxmLk29+s6ySMqyf-Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGudoHEsUV+fe4vY7G0FF3T_bki=Nh-QxmLk29+s6ySMqyf-Eg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 19B14180016
X-Stat-Signature: kqwf164igrcf54fyenn1fqcedoisf4rm
X-Rspam-User: 
X-HE-Tag: 1764008726-21197
X-HE-Meta: U2FsdGVkX1/329UEemV6HE56kzm+LXM04npMfUzwPzcU6cydkg0b10hV8MSUNh5evDuzH6qcGMMLldoLsvcYxUSmVN3GCAOwgICbnR4FfHQMLvWQ8EycDLUkUF4B6xixTkZw5sCrq2TaSXrnIamrE19Wf0baiAS6jAwc5W7Tgbf3K8UIXIZD+WQBzykr6cTrP6EPHhPlDyphYyebII4RpwAfGhjpVC/PXYmhPXxvd6gG856dSDvKtK57n+eCshKJ+0q8KNb0YH6955XkWyKamOeACkQeD3NMJqOGhWzCEt7SCMNqMjsRo7Wl2R99z7mY1mWF9Pyzz0TEOP1mj2XYiSRXxGrYMW9UjsT9jv1RuIGxTeb629eV4Uyc1Hhl8ZaINLxL4xFmgi+fYoHumAjHZFG3+RnkMC7xUndQjBLySTV4iGt5joWLPHUgng1Ozt4C9OXjLeTtX2CJ+DM6UnBeb990HHfOpug8uVSD6kFruVFESFtlgv9KtfPsRfOnG8FZN7igQ2HxmURoXHtpspnCajZbRkiOxMzZh91C7geJ42QePJ6olCu1X2Ap/N2prgZPx4qZxDxChvBFV/wbbgZW9xgYJhnm4puNo2V2qmTux5hu/M7ruSK17gFTvt1nheeIPjX6y7v9imcA75zw1T95gt4S/uwWmryPkSI8A/ZoSYINnfomQAzUPvOHtS/zaWZX0cJH7sFDLjA3SDghR+ceSwBPqEKRDxK3SxsqFeycwQTegQjXFju52BcS77PJCKgQto3nvoRR3zaWkdBd+IlLkmzxYTCCJygIKEyA82L9rEczPGowxKsRXpC/SlFMVvQNk2A+A9VVN0x9o2dYjU7W1CxZBr2buvmHvU3xXdUM+N7BVFue/IdsHSuxovBgmFPBIrLCwG6j8wDKH8FUMgP6D1KHPjDMO9HvMmw6c250Eee/dB1vBx6UQs2Toj7grJIR/PUQwAhBRIEaSpA+o61
 TEuoqhln
 N0pF46Z/04k8HvHHzY2groLnBuCW7i5JaE52dsktkUcMAhfWGIzzKpliU1EAtZqBOApvSEWHYwIlmDfT2VVFkgx13svZM28Fr0uicuk//2CF+50fboWpW7rXciCXCCh/QfrkX5R+ZYR7gaYVBm0WlD28D1xT+BPmSIM1z1LsElhoasBeUJLTzk98G1J2G+c6iNoyL/KLl1lz6p7zVkGFp5E0E2JpL5vz9otWXHAfSHTBjdD958SRVI4n217WsMeDBSx8pSSCLTAfmm0ryuBEF10vpystKEVmFA7S6+WbuzdtCuz1YmxKHC977ABaB+/b59H25cyKg9SuAAR6RXdoMWFQ27KoBc1IsvaFMosCe0+LHCqIvy7CxdRGV71pypTzukaxkf5u9nhgy5Vs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/23, Mateusz Guzik wrote:
>
> On Sun, Nov 23, 2025 at 7:58 PM Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > On 11/23, Mateusz Guzik wrote:
> > >
> > >  struct ns_common {
> > > +     struct {
> > > +             refcount_t __ns_ref; /* do not use directly */
> > > +     } ____cacheline_aligned_in_smp;
> >
> > Cough... stupid question. Why not just
> >
> >         refcount_t __ns_ref ____cacheline_aligned_in_smp;
> >
> > ? why do we need the anonymous struct?
> >
>
> This would merely align the offset of the field, with the rest
> directly following.

Ah. I didn't bother to read the changelog and misunderstood the intent.

OK, thanks. At least I have warned you that my question is stupid ;)

Oleg.


