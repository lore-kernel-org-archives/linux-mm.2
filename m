Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9099ECCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC99A8E0016; Tue, 21 Oct 2025 05:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA10A8E0002; Tue, 21 Oct 2025 05:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB6C78E0016; Tue, 21 Oct 2025 05:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C823E8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:42:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 86F6D4817F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:42:41 +0000 (UTC)
X-FDA: 84021631722.19.109544E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id B06171C000C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:42:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cYxy82pA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761039759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UHjS/qyeeKcJ3eN+7yFgpurORtwwe8MoT2GpgobO51M=;
	b=CNO/7I1mZJIvsgyxLtKOyJv5r9oujcSNqmzES56dXZbZZqcAJ+uKc1ktmTR9xNSA78NavJ
	jGSTgkSx7GIn5skNu/E5A+tZ2Wtjb/LeEJhReumNnL30V9pFh0ZQOCDynz72vkpzziwOIv
	s9zBH+kUi6kV2z1TyWcKkUvBJvv+Vt0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cYxy82pA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761039759; a=rsa-sha256;
	cv=none;
	b=tFIBykm2vdRcJEI02T7SkUb09M+93IvLbN9qjY+u5zE2YO2QKuH4ZVlUPvgs70DaVyLvRv
	x3j8YpM/jAcn5BGw96O4zaLiI3AIvsBoqWFOo/kuPKeYgldOHJSQq9Mypuyh24CxilPo4X
	9GST3giy+iFNeEnPMujawsI9CASrLbE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761039757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UHjS/qyeeKcJ3eN+7yFgpurORtwwe8MoT2GpgobO51M=;
	b=cYxy82pA+fjtnSs8kfgHcNsl0wGBbBsMQRBG41ACA+7CSNb/OBrgqAsEvNwLN+uFxeSpKC
	vYQaljoIpmyKo7wWCx5axfcPv0WBde3JufWEFIttmhBsoZCjqcgvTBdiXpvwMOo+2s6ojQ
	47yTjQROpASezdVVcLzBmaTKGKh7+bw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-Dhy_ZhKlN6e6oExj1gLi8g-1; Tue, 21 Oct 2025 05:42:35 -0400
X-MC-Unique: Dhy_ZhKlN6e6oExj1gLi8g-1
X-Mimecast-MFC-AGG-ID: Dhy_ZhKlN6e6oExj1gLi8g_1761039755
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-87c1f435bd6so191992796d6.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:42:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761039755; x=1761644555;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UHjS/qyeeKcJ3eN+7yFgpurORtwwe8MoT2GpgobO51M=;
        b=Ui99WG/lhtbdC8ngUG666DOQ8OvdvFeph1UWgRaN36bYcUAwuwss3Epe78lfkdsf3r
         9asGdZzXTTjZ/twJaDoMsefe6rWpLttQfDXsW5PRh1BbDP8EjUr5x/zshpdJzJc04ken
         T4SbaWPB5Uk95nMaJvjJrPZ23qwY9rYGSEcWVVJ5/8XC83wWLcFN8L9+GU072671grkw
         hT/2+kbXMfuEkE8bM2zYYhLpFq3UcpZoJS38HVK/Wyuk/jgTbnkvGc1XmtJM7JhmfdFX
         /hojHRDBHM8fzcWWodvo5voMoPy/bWUa015wT1bL5tZz6ecJJkRIKLwvCsqQuW//3n6u
         UUxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzpmjV/CfKc1uD5Zw39YhBcYrQyG7q5kDeL3Guf6d/qMhLuOYLlixFV/Uf7NCTmRTO1nKupMf+fQ==@kvack.org
X-Gm-Message-State: AOJu0YzI20r228ti6OCEKmyhgbr7jMd3/XAlbk/ImkDAEKPtjGItgZGI
	rARrlCRDtt4NxIbsWRfKhFqSnySKvCasLts+oUAoR9pvoO/4YhF44uMbBUkhb1B+pGudrqB2DXW
	AFkqUtJMIimhIpZmUyOFtd16X7Th3KnSx1lOygtcnuqCQkeXlAm++RMvyG4/1GpN8plBqcnzJtY
	oXFSDEo/YXk0B6RamcOaxL/OiTlnY=
X-Gm-Gg: ASbGncsu1KOBSIYiIt+DAaYtGGvDHKlRMiGppuJ+paRB8hlqjHWxaVvC7rxXGvBRXKT
	GGywfgczJVncnA9Sg6qyAz+T0TsSR83X1d+0/Z9gScjGDFsiM/epHoBQ0e2R0PX+0JRcJdgKxRI
	N4icgZUuiAEmjB1owxZJ77jCJt2kcqhHVhPzraTYGmvrFUJ+T6xisIlXKXbwr1Xqo0wRgWw4tx6
	hjzVL0cNP0qi3CU
X-Received: by 2002:ac8:5712:0:b0:4b0:6205:d22b with SMTP id d75a77b69052e-4e8b679b7a2mr115979271cf.52.1761039755352;
        Tue, 21 Oct 2025 02:42:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtJWXOjke0RTmK0/xZXoqnt4Ou0KacBj/M07aRFHuZEpUI1vDSqa7DdT8a6/Yrxfq2QlaYBVOMZ0kPdqztzzI=
X-Received: by 2002:ac8:5712:0:b0:4b0:6205:d22b with SMTP id
 d75a77b69052e-4e8b679b7a2mr115979131cf.52.1761039755012; Tue, 21 Oct 2025
 02:42:35 -0700 (PDT)
MIME-Version: 1.0
References: <20250910170000.6475-1-gpaoloni@redhat.com> <2025102111-facility-dismay-322e@gregkh>
In-Reply-To: <2025102111-facility-dismay-322e@gregkh>
From: Gabriele Paoloni <gpaoloni@redhat.com>
Date: Tue, 21 Oct 2025 11:42:24 +0200
X-Gm-Features: AS18NWBpQWaCgTUPFKBGe-mp83ffIdDKrAgAWm46CipP2yYr5wYthLbhuHqwos0
Message-ID: <CA+wEVJZEho_9kvaGYstc=5f6iHGi69x=_0zT+jrC2EqSFUQMWQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/3] Add testable code specifications
To: Greg KH <gregkh@linuxfoundation.org>
Cc: shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, safety-architecture@lists.elisa.tech, acarmina@redhat.com, 
	kstewart@linuxfoundation.org, chuckwolber@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ndjKA9U37xsGxLKSswO1vHy5DKW0b_22X03sDNaywnU_1761039755
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: B06171C000C
X-Rspamd-Server: rspam03
X-Stat-Signature: hmatusa8xco4gnsgcds491cw5f8fnk1j
X-HE-Tag: 1761039757-980279
X-HE-Meta: U2FsdGVkX19TVcy2DQtwXcDPli6BENrXE3q8p0Y0tPvgc2runWj1iVVSgWlHjOzPv4du/3qudKzptzyq0tYgnbveb/q/7aVkztB3NX1yXeEdV5hdPnjjG4M00yKTQiWp5ZQYMSJeTrgskj6h/YmXvpo5Uh2ALVkwQKLTJWeuWet9P5AceRe0VQBZPOxi8ddCqo5mtHCfUorB8NKUeGdsdnpn7elvPOi+8j71FT8jvYK6PQO+lEN2BDOu682B+MeWIi610Ibs8AA7ZgjmDDHRJMkR6RcKR1uZLvqen8IKz1cONgzdDmtodU+8Z7gfLcJPpY+XTdyhoY3vj2U7EDN+R3VXfwTeNgl6W19a+Cu1X+esFUFA55KMlaLSVCit5CrbSiyeytBYHyQ8S6BqzOsDlJrpx9Vgu8Eox+Y8llpFBpL989N9FqyOuvVaq7TxE5BlwVqcBK1nMh6ERgBu8OZxa877vUXE5Dz4aCXn+s1HanrEoBTv7ma9PduwSwKq3Inb9LRKc73Y1R6bvddqyBrEsSHtfWsxAauffJvN9mgjkfnfEM07brJc+omwDxUK18oe264vKj4/vDrIILzK+yORe9L1S+cWhl11rk64eH0f6WY+wu42XTu/HLCorvBDuDUpgrgK9JXRwfq7r7NYWzd/V0im2GBfg0kcmroCB1dl9n09ytPlZtZLLDwHjBl5C3k1xUcwRQlR8x/re0WFC7xsxVo/Z3RPbLcR+yFL/G2GsWnJNrGmaTkZ35VRqXVkWA7xrUSwRxVo5xHrMhXIodrXH9CyYrE4mtDtT1xyZOBJg/aNVUwPGSPn/4xxMYC94rpMpMBtUcvG9kY1Fw0jftTD70wEcDaY5n5JmHbk9SXj2qycXhnU23xRZnE85tOAbvXiEL1iT5/SP9zH8MQaWIyLDa3y9ak+ok7pGMaJAVn6VWCLy5Adad7jhCUPa98HYG+JCNC5O2MAsAkV77QbUYN
 O9vNoF20
 +GnGCWHE/fE8iqVgfmhb5Fac+De5p19KcugAhitwJhoOvgDy2xjEdbvfTyHIdQ9EMpqp/fO4OrSoIm2u9OSYzomvL3ZLlNFPIgUAu7MOZwtHiWmVDzaMH+eQSyPbMqDWdJLqCshsE5QyEbjp1DSH6DELa7GLChmNGRomdKdZWOfzcurX+HYVl5Sv4XdZTJjcU8OeWPG3PZbE5w1oyxoLdyYkdCeCD4I0Fs9YlzaosaKoG84ma7+3nBA0yDx9+3rtfY5uEUxzDxR+Un9Q/yn5QmPz9YoEctohGQIWZ4nW3cd7btLpO0YS0J/rJ75plSqmnDUDnL8+fkQ3ck6HPRhyGumrZ+xdMtdgpF1CfVyy3r0bukIubhVgb3smUtsGDeTieFbiCcKZPMR59gWAhUrUJOX+bovmmEDDzRuZMiQqPDXYqTQ9cFo4qRy1IOP804uIZkynuGyIligms72w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Greg

On Tue, Oct 21, 2025 at 9:35=E2=80=AFAM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Wed, Sep 10, 2025 at 06:59:57PM +0200, Gabriele Paoloni wrote:
> > [1] was an initial proposal defining testable code specifications for
> > some functions in /drivers/char/mem.c.
> > However a Guideline to write such specifications was missing and test
> > cases tracing to such specifications were missing.
> > This patchset represents a next step and is organised as follows:
> > - patch 1/3 contains the Guideline for writing code specifications
> > - patch 2/3 contains examples of code specfications defined for some
> >   functions of drivers/char/mem.c
> > - patch 3/3 contains examples of selftests that map to some code
> >   specifications of patch 2/3
> >
> > [1] https://lore.kernel.org/all/20250821170419.70668-1-gpaoloni@redhat.=
com/
>
> "RFC" implies there is a request.  I don't see that here, am I missing
> that?  Or is this "good to go" and want us to seriously consider
> accepting this?

I assumed that an RFC (as in request for comments) that comes with proposed
changes to upstream files would be interpreted as a request for feedbacks
associated with the proposed changes (what is wrong or what is missing);
next time I will communicate the request explicitly.

WRT this specific patchset, the intent is to introduce formalism in specify=
ing
code behavior (so that the same formalism can also be used to write and
review test cases), so my high level asks would be:

1) In the first part of patch 1/3 we explain why we are doing this and the =
high
level goals. Do you agree with these? Are these clear?

2) In the rest of the patchset we introduce the formalism, we propose some
specs (in patch 2) and associated selftests (in patch 3). Please let us kno=
w
if there is something wrong, missing or to be improved.

Thanks and kind regards
Gab

>
> thanks,
>
> greg k-h
>


