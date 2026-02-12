Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7285FEE3686
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 14:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F1C46B0092; Thu, 12 Feb 2026 09:00:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49FDC6B0093; Thu, 12 Feb 2026 09:00:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39E2A6B0095; Thu, 12 Feb 2026 09:00:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2AEDE6B0092
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:00:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 69AEC1C039
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:00:22 +0000 (UTC)
X-FDA: 84435964284.04.FA5293D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id BA05540014
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:00:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eDxDl0wP;
	spf=pass (imf12.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770904820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fqDi3KyffDsVgAKVUvyPTS3GAkTlVPCfSZBYkz2v2U=;
	b=0d4RYWBfGawdlRijiZlvEASoepUt9qMnLc24mZNaYrZQKkRO1HqVXQ5HvzaUt7hiWIFBy0
	J7LCuWMLss6kAY9o8deIw6XFm06TktdUxS8BXbLjeiL5gcvTD/U/z8RUUzqcI7gw/HsZoD
	bfN2kvOfBrhxyeEHpNWqXz2zkWzoe+g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eDxDl0wP;
	spf=pass (imf12.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770904820; a=rsa-sha256;
	cv=none;
	b=6JPPfUSaPW5zHQ2PXCQ3U7coFiPVKixEYzpKjmk7qDBwEBfPhrOIIAfxGox1xOuxwcxoN7
	787NRsE4ZVfEcOBJavYvRqXspjJ1DtW98GJD2DkRpVlqQZHWugrzq8kJLncgpnymCquulO
	D450+2L4LMWYJnB8md3sEQ4DVj0Lbog=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770904819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6fqDi3KyffDsVgAKVUvyPTS3GAkTlVPCfSZBYkz2v2U=;
	b=eDxDl0wP8Ub8PkW4nWiosPr6B+vCenkhI+QJLow4w/xuMGP8GM0dJ2ve920cQbXL1SiWF0
	2JcviTD/WfAOT7r+gFQdNWZJWAyd+B92gRFmHwuHqZoZIhGPssypLPIRTV+W4L+wGlmhpy
	jWWd1Hf5K6fwxjacqT63XKkJj2AktJk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-tkZ00WazNN-_v0yrey8b_A-1; Thu, 12 Feb 2026 09:00:18 -0500
X-MC-Unique: tkZ00WazNN-_v0yrey8b_A-1
X-Mimecast-MFC-AGG-ID: tkZ00WazNN-_v0yrey8b_A_1770904817
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-502d38a3e39so40300191cf.3
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:00:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770904817; x=1771509617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6fqDi3KyffDsVgAKVUvyPTS3GAkTlVPCfSZBYkz2v2U=;
        b=X4fxo89aPUBzeq8xyNALsm05xmyk+micyO24EJIknN7eMg1/ROkV05PBiEyYNXuFAK
         s8dzS6O8gyQqOq/sPgqzKFzyLUtu02fvrmVVERBS5QeU3MM3hIXHASNhoHhiCic3yNZJ
         eKBSAqMhV0SRUGdsjwsetOZlu5O0iW+wx8rPNXHDBGaH0+CmpnVz9Myih/lWZiMjD6Gd
         a1WnMBshGqUnj8W88OGFxBH2MVUgeof/+MpQKoLv0sh/CwtaU6FnCjnnFq59xh5lPsJB
         iJzsyv9/tFA61kQbHZlVRxfNRuAPj/3J2UPqLpDMv3GgQarxk9xMWCkOyHcO9dx1xHCi
         HRWQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6BMZQ6TEAJ5RrI1HOTVu9OkC1yGKUs1yXWk3LGQvYVyfZZmJ7/gA5l/cXhX9jm5Yz/EYhPerNPQ==@kvack.org
X-Gm-Message-State: AOJu0YyNfWWpDEbY4hJFQoMiXa1en/oEid6Nol8GgvH+xYgQg+ZJrmD3
	fIkK4kv0m/bnK2WyDdSjg/6fdeW+FSCnpnJOCLhkFe4xSdWwZp/THKnpXPZPmelZ7ZQ8YQaQ+mA
	tTnj/qXRN2yoQ3MN8OLfMES5ODmDlfxPLJzNArRFYs09Nuipd0d6dtgOX/DpTBwS0WFo+j4kzzB
	CZzMobl6F15plBlGXZAd4oxTPCzTc=
X-Gm-Gg: AZuq6aJvQf/6W9z+sJT1fpWqH0AtmLHniFjycA/KTLXGNM2Nj71QGNGrJFL36cyvW2t
	yhxQv9Bi7auv4APsREyk31bgUhvHPnBe91A1lV3cazYc81que0TFzR/P5H2ScyrcadMNjccyMe1
	TmyGfSGAuuaCRvMF8Q+Erueoo+bTjH2J8bLFZuzqobD5FInnNT409TTg2Klr9tfjlCgqg9mV0Us
	pwAqDVM7aded/nJ9JCc0HNwXxyT0LWwV+fk8cI=
X-Received: by 2002:a05:622a:4d2:b0:506:217e:b0e5 with SMTP id d75a77b69052e-5069471b3bdmr22134851cf.0.1770904815650;
        Thu, 12 Feb 2026 06:00:15 -0800 (PST)
X-Received: by 2002:a05:622a:4d2:b0:506:217e:b0e5 with SMTP id
 d75a77b69052e-5069471b3bdmr22132021cf.0.1770904813375; Thu, 12 Feb 2026
 06:00:13 -0800 (PST)
MIME-Version: 1.0
References: <20260212124923.222484-1-gpaoloni@redhat.com> <20260212124923.222484-2-gpaoloni@redhat.com>
 <2026021221-grading-clatter-b7bf@gregkh>
In-Reply-To: <2026021221-grading-clatter-b7bf@gregkh>
From: Gabriele Paoloni <gpaoloni@redhat.com>
Date: Thu, 12 Feb 2026 15:00:01 +0100
X-Gm-Features: AZwV_QjUUvlcQ1gY_oM6dV3H03_w17i2jymN17xZ8bDIyjGg9gzhLqYbN4-NK1k
Message-ID: <CA+wEVJaFX4AE5ruKLvgYZhmNsOabovLp=2LAaLUYe5B9r51qEA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/6] Documentation: extend the 'Function
 documentation' with expected behavior and constraints of use
To: Greg KH <gregkh@linuxfoundation.org>
Cc: corbet@lwn.net, skhan@linuxfoundation.org, arnd@arndb.de, 
	brendan.higgins@linux.dev, raemoar63@gmail.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com, acarminati@nvidia.com, linux-mm@kvack.org, 
	safety-architecture@lists.elisa.tech, kstewart@linuxfoundation.org, 
	chuckwolber@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kBteszkF4HPDibY4JZ4RocSu0_5_JKMxArQt8YZkNjc_1770904817
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BA05540014
X-Stat-Signature: uumt6d13cuzwne51iuw39umd5t3yjhnu
X-Rspam-User: 
X-HE-Tag: 1770904819-661212
X-HE-Meta: U2FsdGVkX1/sJbvK6Q1fvW71+2aeI8Zh77dhAq4jtbpaZuH7bGTZ6FXk3QlI1F0nSfDO6pxyvyEvyZrMNgioyGKDr9QkHqjfamD1JEgwJNm21klJswY3AFPJHwsf29YT3QBsqCp+zer0Cnzv0ZPb9ZfLPsGDB5gpF0tps62+UIYhi2bfXd9nCrmYaykgT6W4ZGKvaWWzjzKqSFW0gNvlHEjOJCvPVy8/YKIL5EDAq5cZwiMvstRccIPikE4UPgfJTNHzgA9n5TplL/a+Yr7tnQcn5gUrIdqcn+RW4Gt7WH6dzDbROJz/WRMG1g/iSW5MEe0L3Oi04bzW5IHKsIjokDDBsO1xBPg3DtIWTtPLFRBzDhtr5q1ygfbpbjGbR8ENI0iH3Fm0erhFPIwKMCAo8CqZ9aZBkidn0oNalA7F+bRPMs1Pv8N4lpx13vI0Dpi3fyGaJQSiVPgK3ip7cWkLl+/zu5sakZVwST6QFHEeinG3qk9lvmBQhkYIGnKwWsw1r3VgHSR77uuYRFaHGB+MhmdznAWsRhiunpq2JMobXpy8JYvUaJxIvdQvo4kc+xLImbRtUrYi3AuZE4ip4vHtC9mdnuFnyKw9UXE+R8TeCUKVDwtBA64HAbRoLYrK3Dx5FrmfwsdE76Oc/9DPikgHyAwUoS/73dbPmgJnRfpKxDoEK6PX2tAdtFwzvkDuQglMgJQGruApgVkH1gHIS6DBR4Pp/Du7LmIMDzZgYJyYAzQg24FIF72C17QNvpd6Z1BKtbGHyjXlV91TFVC8iDXrl3qt0axybLXDv+pEBbRQzV2rjsXKSFuyGWEYz/r8AeKjX+d1zUsHcRN+8ddFDkr1p1EkpqZSRD1cR8PSoiZEwVVuk0yaZHgN0lOHGoMFW0VeBk4j8w5LtnOCdZ0v9dRyxivTy81ZB25xh29wvhF1pqp7EA4FH338ZPIRwAbrBhiVg7TC1QfImr1GRX2A1WU
 ClUiaM04
 LTn1fQMwrGQmT6cZa3qcZqOp3gIxQ9YWhmlprSPyF8BQxj2FbtaT7zvueLs7xAqW+iHwz5bJhz5S2NaZiAMnHilg1oFq24bTcbwDCIUrLI7wAokRgRuMI951Wky9KvfxXW/Hpkp1uSLAVn2xcmRAEjj89BEFCVNCmCOMs4haSpnAImCosH4akDpZ6Etpkbhvw6Tn1bzwCR/T9qc7ndIgMyxOl9GvA1KXx+rUrjXesNm03a29DjxsCwd75AMnaT2HynIgLw+U3ldTR7VQBp40er8kyPbsN9VMWInd6D/zpJIcnzwL5pTbyU4vGlz4X1X4MjmAd+WdUk9g77UsXGpdEB0V3wt9H+U+qlGoRWHhnePDCKTjD+wum41iZGNjQaJ2/0jYS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Greg

thanks for the quick response

On Thu, Feb 12, 2026 at 1:59=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Thu, Feb 12, 2026 at 01:49:18PM +0100, Gabriele Paoloni wrote:
> > Extend the longer description section of a function kernel-doc
> > header with an itemised list of function's behaviors and
> > constraints of use.
> > These are useful to link and trace test cases (e.g. KUnit) to
> > the different behavior IDs and define the constraints to be
> > met by the function's caller.
> >
> > Signed-off-by: Gabriele Paoloni <gpaoloni@redhat.com>
> > ---
> >  Documentation/doc-guide/kernel-doc.rst | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> >
> > diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation/doc=
-guide/kernel-doc.rst
> > index 8d2c09fb36e4..23e6c4b45b14 100644
> > --- a/Documentation/doc-guide/kernel-doc.rst
> > +++ b/Documentation/doc-guide/kernel-doc.rst
> > @@ -83,6 +83,25 @@ The general format of a function and function-like m=
acro kernel-doc comment is::
> >     *
> >     * The longer description may have multiple paragraphs.
> >     *
> > +   * When specifying testable code behaviour the longer description mu=
st contain
> > +   * a paragraph formatted as follows:
> > +   *
> > +   * function_name behavior:
> > +   * [ID1] - [expected behavior]
> > +   *
> > +   * [ID2] - [expected behavior]
> > +   *
> > +   * [...]
> > +   *
> > +   * [IDn] - [expected behavior]
> > +   *
> > +   * function_name constraints of use:
> > +   * [ID1] - [constraint to be met by the caller]
> > +   *
> > +   * [ID2] - [constraint to be met by the caller]
> > +   *
> > +   * [IDn] - [constraint to be met by the caller]
>
> So the same "id" is used for a behavior, AND a constraint?

The idea is to have a specific behaviour or constraint of use
identified by the tuple [function_name behavior][ID].
So I think we could have a problem for duplicated symbols (but
it is a sort of corner case...)

>
> And what defines an "id"?  I see in your example you use number.number,
> but is that specified?

I thought that there is no need to specify an ID format as long as the ID i=
s
unique and referenced by the kunit tests testing the symbol.
Basically I thought that in some cases it is easier to enumerate 1, 2, 3,
whereas in others a, b, c can be used or even a mix 1a, 1b, 2a, 2b etc.
So I wanted to leave such freedom to the programmer.

>
> And how is a id going to stay in sync across different files?  That
> feels impossible to maintain for any length of time, and puts a burden
> on the developer who wishes to add/remove a test or "id", AND a
> maintainer who has to remember to go and look in multiple places for
> such an id sync up.

Well given that the tested ids are defined by the tuples mentioned above,
the relation between a kunit test and the tested tuples should be not
ambiguous.
Also I thought that, when writing a kunit test, the tester should know whic=
h
behavior is being tested and hence it should be easy to define the tested
tuples in the kunit header.
So I do not see much of a burden, but maybe I am missing something here...

Gab

>
> That's just not going to work, sorry.
>
> greg k-h
>


