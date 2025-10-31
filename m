Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 132AFCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 11:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 263F68E00F4; Fri, 31 Oct 2025 07:48:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23BD78E0042; Fri, 31 Oct 2025 07:48:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 152158E00F4; Fri, 31 Oct 2025 07:48:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F2ADA8E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:48:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9322013B14D
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:48:29 +0000 (UTC)
X-FDA: 84058236738.22.167E102
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id A62C040010
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:48:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xozfIB49;
	spf=pass (imf27.hostedemail.com: domain of gnoack@google.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=gnoack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761911307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlwS3zPH7Q41Nzo2HC1V07gN7n2rhCpo5Vfsn6GhCWs=;
	b=BhCRfgDLgLxeiH2F+3hYZp+9FdlrsZJGKRHOsOtLVkitQKYfn429I6YVrSIt+dDuRdRp1Q
	eg4/LfWINOi66YL/j4Ez6f08CNhv8+oyL7B4NXSNJ3Y3nMWBKuLKQV2EfcteG9etdEsyEe
	hKc+bOKnmUoBPxxHFDuBQ5KwaztzV9s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xozfIB49;
	spf=pass (imf27.hostedemail.com: domain of gnoack@google.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=gnoack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761911307; a=rsa-sha256;
	cv=none;
	b=M84Z8SCLzCOl99KdWsSc/cX30vejmpB+O8Ak2ib9j/v+ktoG6EZikcj5LafvBqonYSDdDh
	bHJS3IuKd36xFxt2ukxsnBBtWpC3WW7PI3pZmJje0YcUcbebl+MrOMB7eQuOZENc1qLQ6E
	09UEfkgvx7sXCsQFMqW02X+irkDQmVc=
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-44da774cc9dso1253686b6e.3
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 04:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761911306; x=1762516106; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KlwS3zPH7Q41Nzo2HC1V07gN7n2rhCpo5Vfsn6GhCWs=;
        b=xozfIB49sBQYr5ghIFycp4y76zRt/pRghOj8K9ghedbff/gp4JRZ4kUTG2CqCmQ5kW
         8BFp+vJ1U6zXwlScxVaIacoLiZCTR7KZQM153OmXkUZqzAARwOmiX0SschjHx2u7yj9M
         Q9sInrWHfxeruVzDVwqlaFRxT2xkLnodCtGIjYwxs2nOX+QNmVzi4+GiVbhCF8GMSTgo
         RgyuUP87Lz6Gcd5mtlN5TjTn4MRKjcMJP9vjMOUmNUimWL4mSIHm055Zn5vhUtQQ5GGS
         ETav9q9rd4EXTvegRYoszNEk2Nwb+41EtNh3l87jO2+9CKkIDbQQgnTVCQ+E6XjVnfZy
         Sn6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761911306; x=1762516106;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KlwS3zPH7Q41Nzo2HC1V07gN7n2rhCpo5Vfsn6GhCWs=;
        b=fF/bu1ecLVTJElM/VLndImWbdJVD6i4CC/Se5Na+oyAWnB8iQTcNvOPcT/cs+G9VNz
         X1rzboxSTLNk+RSSrMq2IriUeiIQFc+erlZv2nGb07r9Xgn46dWTKtlxzmyTzNHdii69
         u/inMnHnipCwEu5l8UrmclQdjUZhB/5mSmzHSeX360jQKKIMHV97Q/96RrdwemEzmTuJ
         N4ioGF0CkO0WBSa1GfJwp8DoW2yvQZsYpccoVAp2eLJ7NKOJ+IjtRMnYfuKsyQwb44w5
         dne8Ai1XiGar7W8Zsv8VzwY43E7YbXF7CVqCWTpIEGKdVLR7wPOFgsLDR0AM5VYsIt3A
         LLKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvjPTU5CAPQzKKwCy+k9aO6/Y/xrSEpgK2tjzDiUCWLGIF7ACIBUCkyflyx9DPrzVfxbvE/Pw/Rg==@kvack.org
X-Gm-Message-State: AOJu0Yz6aQa3iYdofgYbZjdNfTorO3nfQb+zptietnTPr5yrG3wXtvHR
	91OnKbe+1t5tUHa+/tP5hbGsqt0BIt/k1iqKxBzHJOJAuV4xbfAHp/8h9IQHRDotLyBaqHdYAtK
	YlAsklmTU1GtSK20iSGFe33f4wR7IOELTR4x/ns+M
X-Gm-Gg: ASbGncsUrE7OQd9qIAbyVSC6/jOnX2658nY6IkM7ZyWTv0Tz34iOEYqjRa0FQnNXLct
	l1cawXtC7VsNcq9TUHzfyF1Bxc4blqcwBVMi6F9gpGmu9jJSn/0ys1ASzVRRC6Xed7T91QTlgyr
	qHFL2LNO5PagesY66rmExr9/8rCc24k0UEls2Rw/212agEY/nhLwkETSRJcGs3BHH5K+xFI98Fb
	XsedasYhl1+DC0r0/UERbGpnFm2D+//S44S4GDcjZqskXQc8XHYLeAldDocym9iz+2LpqLlA78f
	y1cjI8nvZ/YnyYc=
X-Google-Smtp-Source: AGHT+IFn+kdpOaxRHChvDDCOT/IzFOqf6Yuxb5QncITiTYgJQXvWtUAPFk1/Z9bVNPh2z8gErYmDPzmHey0AxrHVefg=
X-Received: by 2002:a05:6808:218d:b0:441:8f74:f0d with SMTP id
 5614622812f47-44f95fac413mr1322392b6e.55.1761911306379; Fri, 31 Oct 2025
 04:48:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAEXGt5QeDpiHTu3K9tvjUTPqo+d-=wuCNYPa+6sWKrdQJ-ATdg@mail.gmail.com>
 <20251030183621.39ea843ebba82ae133b2b38b@linux-foundation.org>
In-Reply-To: <20251030183621.39ea843ebba82ae133b2b38b@linux-foundation.org>
From: Big Sleep <big-sleep-vuln-reports@google.com>
Date: Fri, 31 Oct 2025 12:48:15 +0100
X-Gm-Features: AWmQ_bllX8fiVQbcOAZy9XxrHCwkX9Mk1pssFOX_WeDNH-_wvRGsENq8nY9U520
Message-ID: <CAEXGt5TEr353v7waAc8N68te4xLwCRE+RB2BWs5tFwMC1mQs9Q@mail.gmail.com>
Subject: Re: Oops in secretmem_fault()
To: big-sleep-vuln-reports@google.com
Cc: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Lance Yang <lance.yang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A62C040010
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: pfnzyn97h66kz8miebbwfhzb1r5sq9aj
X-HE-Tag: 1761911307-714938
X-HE-Meta: U2FsdGVkX18/1yt0STBrqXU1aF7XrFIOwtEhXLGYZIzVRWxLg11IQudFrrnxoW97NaU973EIyDHeGoRMyTFRgtOdT9qt+Mxc1p+w+htNq91CftrAgjwmPObrmzXc+9Z4s9trSJe/CWJw60RVFm1DnIQEWF31indLTYtkT6D5hO/1rW+3KbU568kHi4MeNkvCR9WNJRdIk0JUnBcFsNi1negnj9Qt8fKxwGswkgZcCz7O3gqNYka+I6URX+6GNOM2opp3zNWlqahBHxCmytqynY/YRZZIltye9NuhPp6536vG7WrzBkkGMgTwXnXCqRDAIX9PudIk+BPBU4avAWGDgsEQGDBt3vE6zVullKix9NoDwQBC6wV4z0B92MXWJLKgCAS0zOvWDWlJAFE/BEiXSBrjnnuFJaakbm5VUuHVzL3uZYgwk1054DT+5elOT9LsK8UZyJMbOrxSyxIRIgzf1UNa0Fr9Kik2xtCD9jl0bq2FwjwQhhBQ/o2LFxhWHFaz1YuWXm/bfrWUWvGwXPkLqgvqMOq8jYNh5fc01hNT1rWIbpVKksJ5AlwSa94YBPXVBEhyDQb7UdQAvswyblfEtqCShBsZf5uPFyfldVHSn2K963uTCwnBYLc+zSArRu2ZpYRho+h3zf1FaH6zLssS9CRksFZAtdx7fUl1KMgLLQUACra//VFXbxk38s7vZ40AiUy4jkH76LgVvwyLKqrTzDTaQ6YY3nTI7t/DiyKdzAc0wXqCboKsjDyim+XIGV3VQV3c0W9tro9SslmszARlWiAAM58vtlE6Dpjb7jO+brnlEdFUCEx9xRTK/LSwwNsoFMQMHwIg/SgnfTu6RfjTgQNyuuSSJZr7yJX7xHn4sF9lC/3mE/yxFRv7w6LqFc2SgObSQmaXh1TJRf0/7IL+vJXnMBQBEasFvEuJvr853aPmdJsi1y3RYXQRSY85eWWanRrxo8ECZiMXk2lQzGn
 4RC6AHSN
 l6S9MQfgGZMfvVX6pP54evcTa835vDKPdNKAok5QKipWFc1Fb82S/Nyi6Rf7I36K6XI5DR4mu034qOTOfl7OYyDgiSmJs8AQbokgK9x0QdK+RKdF/pxYfzhfZXyzmg5q+Ste8UyjrrYscJZxJKMzodqsunoGXDeyfItx2mSpB5IVs1JAQL178857KNun7w0W3Lv6hNnPvfdTIIT83rL4cA5eXVOKWsQ30jB2AsiGsxEKbRmkHtO3jx02avTMJexqwF86UPHl+OeWTqekriVOpRx+liSDlNTuJsaVO5J1o1lmIFbiv118pZo1JkJP9nxLTRIm+VraU0Jbi/8fmy1PiZMaUoWKMNvcaCeArmxxOw/8+fkdZURZf/VypeQ4srj6k/0X8lTtjPqn0JHEzHdw5K9ABSvC6WmyERsZNe8J21t6vqZaRZ4WkiIqUHwCjMIAhuN32ei4ogxez0d3jQJZ7f90+Qm2LG20vIzU3WHKshWezgFaIt4aTxEpPev5h/QPVLbCy5YSnYfrPHqnhS+AkMC/Y6/FVb4snTbQtjOjRhtHfVcW0GrsfvPTEjCN2qojEXWroKJzyz0xrm2NqUIFtk/5c1Qcmif5WkSaUqXoztsQyNer/N1mgb5d4B0iIFBmxQSn5XM9IIXBuaT6e7VgxwS3ohRMmNYy6O2KKobdJ4DVan69h4L5X97tR9EXxGx/7ndutwZ8Zd36lifVX5A2LJ+w4Lvj1ruJLm3iTMg7JYEoI01VTdvhpOzcY0J3PuGDkPZ4pVBwor6Ti+tU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Andrew!

On Fri, Oct 31, 2025 at 2:36=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
> On Thu, 30 Oct 2025 16:34:29 +0100 Big Sleep <big-sleep-vuln-reports@goog=
le.com> wrote:
> You might want to include a token here so we (you!) can track the
> report through to its resolution.  See what the sysbot people are
> doing.  For example,
>
> https://lkml.rescloud.iu.edu/2408.2/07972.html included:
>
> : IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> : Reported-by: syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
>
> and when Dmitry fixed this he included that info in the patch metadata:
>
> https://lore.kernel.org/all/20251028101447.693289-1-dmantipov@yandex.ru/T=
/#u
>
> and that Reported-by: will be carried all the way into the mainline tree.

Thank you for the suggestion!  We are not currently tracking reports
which we categorize as having no security impact, but we will include
a tagging scheme like this for future reports to the kernel which do
have a security impact.

> btw, it would be nice to Cc some human on these reports.  One cannot
> be very confident that emails sent to big-sleep-vuln-reports@google.com
> will actually be read by someone.

We are monitoring and replying to our reports and the surrounding
conversations from our project alias.  We'll try to clarify this on
future reports.

--Google Big Sleep Team

