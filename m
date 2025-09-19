Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3647CCAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 06:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B9B494000E; Fri, 19 Sep 2025 02:59:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A6A940009; Fri, 19 Sep 2025 02:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758CC94000E; Fri, 19 Sep 2025 02:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D292940009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:59:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2094B86D0F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:59:02 +0000 (UTC)
X-FDA: 83905097724.24.E28FD2B
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	by imf19.hostedemail.com (Postfix) with ESMTP id 484DB1A0009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:59:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4WPsI92H;
	spf=pass (imf19.hostedemail.com: domain of jasonmiu@google.com designates 209.85.217.45 as permitted sender) smtp.mailfrom=jasonmiu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758265140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xtcgVCi+G898H3JycH7loc6tUgEzYyu4N3/qLFW16pM=;
	b=NjYzqUKE34yyv5OtrOnQQbpjYcONWXtt9ShBwv1PGQSCvSgDuJDegr3NbYsyY9wOiPoZpI
	KRRxTWoyzn7LNAsrKCTnS7EVMi7S9IKMbTbIdMgkvhz+6DtO+jRYu58K2Ojjt/GwPHgVXY
	m+xbAYh8bLCYsd96gfKv3PAwro6bt8w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4WPsI92H;
	spf=pass (imf19.hostedemail.com: domain of jasonmiu@google.com designates 209.85.217.45 as permitted sender) smtp.mailfrom=jasonmiu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758265140; a=rsa-sha256;
	cv=none;
	b=jx12aYVkDEG8cXYCfvp8M6ALk1sBXUmbPuKr8237k+Se8KLfab2P9K4PGBgAHX8YXrr/b4
	LV1OfgaDHfLM1MfaCrTLXI3+v9i3aCi+cGD1kNNBvjUPZwBk4iFHnsZkoZ9s6uaN+mJcE2
	YrgkU1zV8dXfFqlLt3AsuY0ARixbHrI=
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-5570a77eabcso1122588137.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 23:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758265139; x=1758869939; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xtcgVCi+G898H3JycH7loc6tUgEzYyu4N3/qLFW16pM=;
        b=4WPsI92HaPvVAUmiGSGparNjXlIXdBzJumvbE6OUJjXyFzP9tJVi9hIXMPYg67CfCA
         IcASHov94yorI9M9mW9F2m4BbbTe70+GXHXTW971hVpUu53SOyA6aHe+vFewjXbMLvWP
         dMia2QQDs76Z1WqvxgBpPQqF+aG9uSRcs/LspAWdJ+5vgxyjtEOSfZ5fesHBTFUC7g8A
         uMM1+daQ1NbapS3GejCr7biSYtkc9CTN4KECf+jGs9a2liUcyu7zuE9hWG2MDylS2bUY
         NKbJo7tBRDfwRZJIjvM6exnCG68M03b1qcSTqhW4UHmAvSIO+9qp+rnPhbI4z6Hmr4XS
         gPfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758265139; x=1758869939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xtcgVCi+G898H3JycH7loc6tUgEzYyu4N3/qLFW16pM=;
        b=NaVjo3Ttn/k0qpSDCuL8/UKJpnDv6I8/guzt1irsmHTgwPRX7km4vnaKPi8uyM+nza
         xkOX9LlzlPffPtEFAU0pHndcqaDbX+jZLnbON6boMAyPA/QBq/HHZSDLw+NBGUdsObwW
         Wcpexpdk46xsuFNacfKx78AqJYDA/est4yPukeeNYJCFyY9QIrd0WJbY3GxlNC8IzJYK
         NEAmMqjeCEBxQnGQIwdbSgQqnftDPq8CD3lr5o+d+ahQsX4WbCnDib1K9cmDyWam6I0w
         1nXqCVYcXr2u24N7lKiy62Dbnesx44ASbA4Xwm0FVyqHfhIMlu7yjvJfgw2uRq6MTfJS
         MSEA==
X-Forwarded-Encrypted: i=1; AJvYcCWUH/qMQeDmLbl8up65ZgU0p8wbdqLuN3diQFWQs/yMOW/WONZsy+CZCsjXIt/wcAuoyUmO0hRkwA==@kvack.org
X-Gm-Message-State: AOJu0Yy3emW8KVxGb0IbFWgL6IjqrEahA/P/iCv73/TGEXgPwwlrHdxZ
	/8i4dB7ojiHiHxIWxury8cGkVeyAPZUjwukvXEnzNsoCxkY+zMQaYgJBd2mEL5v90uMyGx+IYVP
	UmEDm8AJXWaS02ir6nNyWT1ZTO9tAq1aTBcGd89fO
X-Gm-Gg: ASbGncuWDk4iCmx5deC+a/aLBhtPT++LwmIUUyjftF53Jhm3N/bt/UKU7dmPNPTXOks
	LNS/K0OFKg02L4tVjAO5RJqpup05trtqeDwmJ5pB58tsmH0q+gjv729QTdwdN/We4ANpHQ+drPI
	DzlHxcFndNeJciuxcG3T4USo93gWn88Xgut4Yt8e0qJ20AQGEv/0r8Q9M729tB6OQVH2akRFako
	sblk9LwNFwqHhb5Ku+Mr155LRQsujRdczNsyw==
X-Google-Smtp-Source: AGHT+IHk3HVC3jvHLLDRmh37Xu/EchCNrhbpXqT1eVIU2RepMDaci0Ybt3B7Crf5TYbbvxxQhcjhhhXUFlwv46zm7xc=
X-Received: by 2002:a05:6102:3347:b0:529:4cf5:8aec with SMTP id
 ada2fe7eead31-588ec1dd609mr784951137.16.1758265139130; Thu, 18 Sep 2025
 23:58:59 -0700 (PDT)
MIME-Version: 1.0
References: <20250917025019.1585041-1-jasonmiu@google.com> <20250917025019.1585041-3-jasonmiu@google.com>
 <aMr1XAKmyfzM8RCc@kernel.org>
In-Reply-To: <aMr1XAKmyfzM8RCc@kernel.org>
From: Jason Miu <jasonmiu@google.com>
Date: Thu, 18 Sep 2025 23:58:47 -0700
X-Gm-Features: AS18NWA-W3pRg8J4Q0PVvMgsoADaqk7Awe1gJKAjZHyCKtolHE0_0MrSoYHTlwM
Message-ID: <CAHN2nPL6SV_Y6Sxqy4o-mOPZoGYMoWow=KevUTX6=c8JkO_g8g@mail.gmail.com>
Subject: Re: [RFC v1 2/4] kho: Adopt KHO page tables and remove serialization
To: Mike Rapoport <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joel Granados <joel.granados@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Mario Limonciello <mario.limonciello@amd.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Petr Mladek <pmladek@suse.com>, 
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Steven Chen <chenste@linux.microsoft.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 484DB1A0009
X-Stat-Signature: w9cbjo9hx1mzgrqzjc9hpadz38om3xqy
X-HE-Tag: 1758265140-71570
X-HE-Meta: U2FsdGVkX1+pLoL5KHMYMAUItO3C/ZwGjn5ATwjG0/6HKa6YWSEo+PfhTQ7iGBJD+Q9WLubDGRwFSsiNnGhqi5P+WGrCU116ZQYz+GFFc16U4I0/HFJegGXo6wYFkc9iCjY2WS9dpbgx+oJTTvyc6xe2UlS+KRRnuIz7nkzDTJ7oMipBRh4VZTzSzqNWGnIs6Myv5dYAiv79QaMbXguKtNgCr2PrBfDwrxbmFBeapB3k4QwlDz8eBdbIX8FdT3vMnadD80qd2gKocOUHmBjVgOWQ/DiM7RZ8rld72SqJym1YI+ZYmLSM1vmyd1XWMIyHV6Yk++xRN9BCivMUjy/Mo4P0iFjrbdcXE+HX+1sTxvNV4r2W98PStKyK1KF0ostU3MGfWOrb5woedgF6sQsOM8Ka+sh3z/ssS3ah12rFU6FBMecwrfmvLDS3wZJmvXOvLWYHdM7vQPaQMhiv6smI9cQldFn7tT3hc5Bd5q0vO7Ok2wJAtDmBBAr5QMJrXDpvgLJCBreL4gaVbBeEJDSVYwyukNV7Dsf9yXe2r0Els9e9yi5/oWAO2okofMBV9JVZs6ig7wnPa4W97n6U2+E14gnuQWTVyXltRjJNkV8IqvyYK4125NCKr39dz/AknJ4q2MKYVHTrS4ha4nR3M1nx/ne/WX/LsSCAm8Wyn64vDnwU/5MI92gw4hLKdw8Owmaq2A5tEhCUhfALuyEQlXAwO02ehpjXeVrkbsj1+wVdQ4XRPSwAKPQNulrpcv8+xEWWPHinMZGDeI7QcT2IDG07J7iP6WoxRdo2kT9cTEyAz3nAbbTRL/2gJESX9XB8f2B+3NFiVnozMJxd7m+P0aF+8HUUPQ1EymIk3E1eraxb3UtlslemZx3q/KwLTCt5cOrpOzKFK1GQ7kG/B+dv8o9Of6YCqsBCbsZI1Hwtmr1CB4xUWB7fWop77+SlfP7hURcllA6rk98eT1X7jjHEsbP
 FEp9KWR5
 CWZnvA5rWDd3jiwmFmJ6QrTx0+im8h7lkYWHTYq/psdkMelGgkwU585PJjmmTt63oMSBN6DBl35CHBtKq19YBubBQveDbggfN8cdpduORGJeU5/IEjgbah1lINOjpQwBaUqPbiwx+RWS2EueDS9OwqVpUTczh3QsPEhjHkV/UqLjQfL222NkuVN87SBG7npjwu8HTBPlQ9dMeTY7N9isQF0sK+ys3qMLDiB1d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

Thank you very much for your comments!

On Wed, Sep 17, 2025 at 10:52=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:
> > -/*
> > - * TODO: __maybe_unused is added to the functions:
> > - * kho_preserve_page_table()
> > - * kho_walk_tables()
> > - * kho_memblock_reserve()
> > - * since they are not actually being called in this change.
> > - * __maybe_unused will be removed in the next patch.
> > - */
> > -static __maybe_unused int kho_preserve_page_table(unsigned long pfn, i=
nt order)
> > +static int kho_preserve_page_table(unsigned long pfn, int order)
>
> Just merge this and the previous patch so that the patch will replace the
> current preservation mechanism with a new one.

Sure I can do this.

> > @@ -1023,12 +752,8 @@ int kho_preserve_folio(struct folio *folio)
> >  {
> >       const unsigned long pfn =3D folio_pfn(folio);
> >       const unsigned int order =3D folio_order(folio);
> > -     struct kho_mem_track *track =3D &kho_out.ser.track;
> > -
> > -     if (kho_out.finalized)
> > -             return -EBUSY;
> >
> > -     return __kho_preserve_order(track, pfn, order);
> > +     return kho_preserve_page_table(pfn, order);
>
> I don't think we should "rename" __kho_preserve_order() to
> kho_preserve_page_table(). __kho_preserve_order() could use the new data
> structure, or call the new implementation, but I don't see a reason to
> replace it.
>

Ok, I prefer calling the new implementation, so it will look like:

kho_preserve_folio() -> __kho_preserve_order() -> __kho_preserve_page_table=
()

 __kho_preserve_page_table() is the internal implementation of
kho_preserve_page_table() and we can remove the
kho_preserve_page_table().

--
Jason Miu

