Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B58B7D3942C
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 13:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28FAA6B0089; Thu,  2 Apr 2026 09:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23FF86B008A; Thu,  2 Apr 2026 09:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12ED86B008C; Thu,  2 Apr 2026 09:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 005116B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:55:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A49DE1B8816
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:55:29 +0000 (UTC)
X-FDA: 84613763178.07.4968F0A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5C28A40008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:55:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c5FAMHWb;
	spf=pass (imf17.hostedemail.com: domain of luyang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luyang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775138127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FeIbfN/s6PXb3NeX5Bb/Ugx+YZHVHhzx7Yq3Hex0Bdw=;
	b=pGiVZHg4M2VONJcQQdpbm1iLdJ5w/t83UGQ1zV0Qj9PIR37tNOphKbsQNIFwXuXXH6koZP
	Td8k31bqWjHm6LBxC5js/HAhxkCvmYFzoDs85ZheyKrv6j1TzpD0XNI/YWwLAhpkfEIYaA
	rAUyUA/E89QBPSL3IAnm1Xt+Q5BJ+L8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c5FAMHWb;
	spf=pass (imf17.hostedemail.com: domain of luyang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luyang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775138127; a=rsa-sha256;
	cv=none;
	b=srveaS/CKVDl1VZ0znAz5gx2BC+sQsOvddbBzAIhsDBI58sx4vFn45tXvYchEw7VmZK7ty
	Rz29CVq/oOrBwMKBZtsHF49UwYKS6KgZkJv+pNYdIkmi3PfRL8pUjaX9YfHSf3vzHjUU7Y
	8yI6dNsrYhfJYbE6KN4oIzMbk4PPk6U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775138126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FeIbfN/s6PXb3NeX5Bb/Ugx+YZHVHhzx7Yq3Hex0Bdw=;
	b=c5FAMHWbsQzUO3fOKh7nAnjIF6azVpMggri6HiPT6opUSC+FmJUoS15+d7chri1dkYye8l
	MwmD5+XiqceQ7yjv+sZyTfd2SlS+gUnZdOek8gj/K9vXZEEkT9t/0Bo+vZguod6yr9Vs/5
	SUbmm9cY7nE1BHGXeB+uARFAPcBSL4s=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-sx-phgEYMCKf09AsAeRg9A-1; Thu, 02 Apr 2026 09:55:23 -0400
X-MC-Unique: sx-phgEYMCKf09AsAeRg9A-1
X-Mimecast-MFC-AGG-ID: sx-phgEYMCKf09AsAeRg9A_1775138123
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-799003e8a77so16233847b3.2
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 06:55:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775138123; x=1775742923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FeIbfN/s6PXb3NeX5Bb/Ugx+YZHVHhzx7Yq3Hex0Bdw=;
        b=DVzzRzW584Xfi1SaBIl3mWLxaJpxdyGs3p8Ez36MYUYHxxKG2NzUt+LfNat6zjz0jb
         1Y1MY+ugx3eaW5gcXlqjpH6d8mF7bZ93armWHM8+03+mGi344ptg/eOB4dhB6Z/6Xncn
         hhC3z07cmEbTljs65VMiiMSUyHR0QYFG2318zpguqk9lDwpbbaT6Ptci+vD1kPBOObPf
         TEyj7ko9V5cBkLREjSHRBa7B4xsvueVvBV3rqECJudN4Bo7mOOqT/HlGbCP+1HGX3lMZ
         82J5WXEBy4+gUjAeBMCzgEEG6SHuw9Jk1AeCck2AfEG9/UNBFRihl9ictNy9984s1KY3
         sPxw==
X-Forwarded-Encrypted: i=1; AJvYcCVolYxlh5LIDjEWCrcy7NYqMtwXTbUOaajoklVMfygkwY/kCZxebnc+RGFa3hqEvT4dPfBYWDhMeA==@kvack.org
X-Gm-Message-State: AOJu0YxXpebIE+15VBjm9MnYCpkpGDeG+ZWX44MQ1+Bwimxv2MY3MpLa
	g130tOYkTtsQe+fGF4nDAJLiK7NnTaUKtnXLw260eKlXW5/lwURl8bz74bw+buyucTmRy3JGJwT
	B7MYOyRPyx4m+P2ScHU5Ieg23mA4FLB8aHeLGt8G1JD9WTL09VMigKff+1W81gF4+pQfD870RwY
	j8r0/IWnm6I7iPcvMzm2yTMsuB3NQ=
X-Gm-Gg: AeBDieusenEelZmwrrFVl4W8CgCOD5dnAl5q50khmvQkrmIIxuJdD3ergjg3dYjWOqt
	sqUhH1mw3DmE9jTkzyagY9t266POwaMBafq+6zE5Fe5qhT1vo471jCtd+uIAHjCianEe9EV2VDk
	p8C3QNmqMk+3Drvc81bjmry8FG0cEXqDF2A6/dT+Imewek6mhu6yB6ZrEPCee1mvZa4vLYYgGyn
	ABmkdo=
X-Received: by 2002:a05:690c:83:b0:79f:4a72:ebd2 with SMTP id 00721157ae682-7a211943d68mr82211037b3.28.1775138122986;
        Thu, 02 Apr 2026 06:55:22 -0700 (PDT)
X-Received: by 2002:a05:690c:83:b0:79f:4a72:ebd2 with SMTP id
 00721157ae682-7a211943d68mr82210707b3.28.1775138122529; Thu, 02 Apr 2026
 06:55:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260324154342.156640-1-pfalcato@suse.de> <CAL2CeBxT4jtJ+LxYb6=BNxNMGinpgD_HYH5gGxOP-45Q2OncqQ@mail.gmail.com>
 <vss5mbyhbf756jieb227fh6yu6vvvsggagll3ru4cmlhbbwo25@xv54cwfx7klf>
In-Reply-To: <vss5mbyhbf756jieb227fh6yu6vvvsggagll3ru4cmlhbbwo25@xv54cwfx7klf>
From: Luke Yang <luyang@redhat.com>
Date: Thu, 2 Apr 2026 09:55:11 -0400
X-Gm-Features: AQROBzAYJ8nuWHjSXu2gfqWWatebXCy0HhbCcLYyR1Tc9RoS0Iy2RujMAH5VB2I
Message-ID: <CAL2CeBxOa8ETNw-uP7vX7dikCty0QrFSUpdTSrmF6oAKkLk-ZA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] mm/mprotect: micro-optimization work
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>, jhladky@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Nico Pache <npache@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7PbjuEEufCIoq5mrK2RNOIXlErLVpUKpJmEv766KXb8_1775138123
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5C28A40008
X-Stat-Signature: syaxipkwomi361fcb1ogxmg5qgko9aba
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775138127-986277
X-HE-Meta: U2FsdGVkX1+PwfDDCIUwhh28wE0UMYGuOkXl2I6wxBpKAsWaVuFfSjihAGXcPWNfoITHlcLV/GChMGgTMZke7l4MSUDegMm7HTWZDRdDJeZdlq1qCuypzaEsSC17EZgGEJh9XFruQHvYGES8u0TseBLazs0RR+XO7UnKlxZ3uJaEmrZFi7saFLv1sZYcXgAM/vu70e5cpffNwQd6TP1UVdItJqgWxQOzqdPYlO2YA17cMIvUarUOV3J/gGLa7dnuHAju5w1S/apJJB+b6TaYxn+O53H/xkKfVEyeS12Lshxh8N+CjcMulo4Pz12gLPu/LerzYcJ0GTp9NGhNa3nMJKmuilYftRP/svpVeKTJFH53sWgNAvB9W9GPB46y/qdA2N5r+c+IhjIzLzJoucbAjmkWSf//SLTrscaaGsxdi8zQ0KQ1NxNaq55Up2sFydqHPXtQmNK1sNIp3qUpl99ySyr61zaomeeux4g4BCz/TEWjARP8aRfcYVaG03rEOOfexq45sdbgh5RjNtp4HkmJbvvdxdIEDfgy5X+/jdaGE++h/Wq+ef8kfqLk58RI8+h7VTQqPQqJHlT1IXECjEdjBcQ74MBYQb6kaJdErXMOfgQaS+TUg6UrkiCYEuesJl3EHdyzuQwZBJv5ZLR9kMKxHq32IUZnwLx20Ci+MJh1Eyd8v0WUZwrHP11Hx3JRBM0uesMEKAxiXBw89p2a3wcXcVHQhxBm0vRPyn9ukpZHid6wIHYd6t8JhqyMzKobsmQVqZjioOTmYjznebsX7mIImigOHtJ7ILG2uCFMZoi+g3CeY5XdxT9N3uB7j0czUM1Al2ZWKVDsROkKYZkGGdMbcZHMPCsEnyOhGszjNLpcEyvkPJMlf8jCYl/4Bg7qlYV5TC7C4Jdtpa+owSWYiIq+fpA3XjrsAh7NeZgHs0eYmXg9oMILr94tJhRAghy3IS82faJ40qyLtXBQHvdsenP
 bd/pN2IF
 2cuD4HHMudVCJoTNicH9XomMUuRD/91njmWXJ/iNKJtzUXpPGOr5P0XLDtFkeAI2cpyWJAnCKEdzQBUAsJc19a6A+jZgEyfjWFO+DD5gR85eQbqcCcQnRn4ffL18aCqGXzDOd/XnFpGymB8WV/EVhDxhQi/+s4aILm9Wz6wzCwUx1MYpP1qtA+nWBvYfsYCxyK8L2KpSFi7IJlacsdqEEY9DglvdIdpxDesNC16p0syGiS8T48+hTdtirIjj5ZjXmXhoIgz0+3+ezQtA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 1, 2026 at 10:11=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> On Mon, Mar 30, 2026 at 03:55:51PM -0400, Luke Yang wrote:
> > Hi Pedro,
> >
> > Thanks for working on this. I just wanted to share that we've created a
> > test kernel with your patches and tested on the following CPUs:
> >
> > --- aarch64 ---
> > Ampere Altra
> > Ampere Altra Max
> >
> > --- x86_64 ---
> > AMD EPYC 7713
> > AMD EPYC 7351
> > AMD EPYC 7542
> > AMD EPYC 7573X
> > AMD EPYC 7702
> > AMD EPYC 9754
> > Intel Xeon Gold 6126
> > Into Xeon Gold 6330
> > Intel Xeon Gold 6530
> > Intel Xeon Platinum 8351N
> > Intel Core i7-6820HQ
> >
> > --- ppc64le ---
> > IBM Power 10
> >
> > On average, we see improvements ranging from a minimum of 5% to a
> > maximum of 55%, with most improvements showing around a 25% speed up in
> > the libmicro/mprot_tw4m micro benchmark.
>
> Nice! Thanks for the tests. I'm wondering, what CPU saw 5% and what CPU
> saw 55%? Or was it just inter-run variance?
>
> --
> Pedro
>

5% -> Ampere Altra Max
55% -> Ampere Altra

Personally, I can't conclude at the moment if this is just inter-run
variance. However, let me re-run the tests a few times on these two
machines to see if this is consistent.

Luke


