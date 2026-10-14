Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14E64CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E6F06B00A9; Wed, 14 Oct 2026 13:15:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 197A46B00AA; Wed, 14 Oct 2026 13:15:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0870C6B00AB; Wed, 14 Oct 2026 13:15:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DAF216B00A9
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:15:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76BC71206CC
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:15:50 +0000 (UTC)
X-FDA: 85321884060.18.672F255
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id 397CF4000B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:15:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Fi0yKl61;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791998148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMIXwI+O28aTWWq9S70Hh5SSta/yBvY/YtBDSjKEcWQ=;
	b=vWTAHDhpPACk6eQciTMD38oyKyetFwwOj73lNgtJfCmqHJG6Hpm7iZtYDqUzzz/9wRrOyK
	K/2Bdp+KbUNuo/LmsTIThjWuqEaqk8d7hZ8ik7oOHDoXvxfLhfU1OknAvGq1T/LIMXmcJR
	z44dfX2gcWXtK5S3kH+Dldb4EYY+26E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791998148;
	b=76zQWNprgddqJG491O/ZDiqWJtNV+lV1TESlGT+3wCSSI1SNbMu5y6EUQ18cGlwdRHOrnW
	vcmVOP3+RILFx2pCpu1/cGxka0aSP1+gz1B4Q+a8r+h79aJEaY/vQVJiadnV7XjbTT9GWs
	Rgozqs3RVTpwuf71GBPdfYLZExiISm4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Fi0yKl61;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6a0a4aa99bdso5565025a12.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1791998147; x=1792602947; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IMIXwI+O28aTWWq9S70Hh5SSta/yBvY/YtBDSjKEcWQ=;
        b=Fi0yKl61reIlwdxj+LP+qQKXK2ezgfSdY38RI0sdLHBjZA8SBwsjbjSWla4CMmMzqj
         dQqnVH+hvZaaboJPo/LDGIUXX9awIw/S5vYnyH/CENuV8DnkffPO9QvhnP5sf4wjrMaJ
         xbQa5N89GZYXkgOnASN94ytOB4YyODT/NR14I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791998147; x=1792602947;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IMIXwI+O28aTWWq9S70Hh5SSta/yBvY/YtBDSjKEcWQ=;
        b=U0vnOEjL15ZzdCZq3iFzQHQ2CkX0Sk539CUcPMqOK0zbvGmpuuXOFaKPa8cm5tf5lx
         T79Ni/U1tJN2EoTB3Y3OwlLT6NQvvnjcRzAqttxmD3g48Fyn9jjsAWnIGLByJ58dpRdj
         exRESS5vNfJD0VYrfOaDjCopfXj092QJW89oyPSgnAoeDQzNl2vjUdDaiY4EPc6GtWeL
         Z4mBHXeW8ahiDcK5y/sRLxLdOm1RkTR9Vho8v0MLYid21iXmEVpcuLGmu+y4zwvjUns5
         j0MuaQagSkrPH0voP65L555y9kdIKoQwb5sa3p/O0rq+pDMQCUmU+pRLg0COO9rVq8l8
         7J8A==
X-Forwarded-Encrypted: i=1; AKwUvBypZ0ZaqWUQOjRkmwbUaGAI84R4iJ7V6nUKlepx9lsbmPsw6ixi092QKXysfeKAe4ztDH+81OXq5Q==@kvack.org
X-Gm-Message-State: AFq9FYJ473fp2TzGBFZK171QiGYqAYux2VosgJZp5myMOKpQeNi+Dkff
	cJhBWMHjVGwkpFFX4byE2QOCUji4FDF6E6UYrTHEKS8hIlXEmPefMh13wVJ2gBSWLH/p2OjYmAP
	mBkYgF/R6vQ==
X-Gm-Gg: AYBFou3+d4hVGXsyrAAvdrf7VoNUNZHXqFMkhJgPaj5/txCTImwDqOQBNBloIvJ7ZPS
	xJRHV2owWVUe5IowjL4gT5VtFnPrHTBVEXr9QKmyjuKFF1Oq+zaIpFidW0jkLcB5inb4n0/Qak+
	4XNpXSJAk7iC0isAlY4FIQ7S0a2aLh4bF1WVyWu79XhamY4MntQh8eqZjdRapqdzJJbV/VkMpVd
	xu/5rnpfzts3rDtuTieQk3roUF5SfBPp149pfKTT2QdrzsTwtS/SZ/WdLTyZIUBF3RRoOYwYYs/
	qXF9qQIyeRD0m4PBdYNmKZWTkRje9wB4Isbhh1vM91XxIxsP/1/HD0dXCQLrcWRRms9N8RHC/Lh
	4dNh3btFjNb1Qokkw542uh6H0q7gzZFhL7uaw9czrhEymgwybay3lQWjbvQ5GrSewsbEYXwN9Q/
	F8x/TA7jUaJdaXTrRIv8QomOjJE8CsY5OiN5PUCSBco8s5ZhY7QpkO7eFXLctfYbqBYU/XXU7sY
	t8CADX4HTavbTDYu7XNFPPxCAP9f31sUc/PXXdTj25fBc6Y
X-Received: by 2002:a05:6402:5107:b0:6aa:f76d:3727 with SMTP id 4fb4d7f45d1cf-6b17c1de7a4mr13076726a12.1.1791998146781;
        Wed, 14 Oct 2026 10:15:46 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b203862fc2sm1364491a12.14.2026.10.14.10.15.44
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 10:15:46 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c2e8e738ae0so777636766b.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:15:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy4IPm1yzfgOEq30EoWHx3tQhr7R/OUUU62C8LpQqxLwD9GvR53kFbVRYf+HQncg9nxDptkI4aqwA==@kvack.org
X-Received: by 2002:a17:907:9690:b0:c29:f0a4:a4f8 with SMTP id
 a640c23a62f3a-c31a96e4d7fmr1484999866b.0.1791998144070; Wed, 14 Oct 2026
 10:15:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
 <as690Xcu7FxIDYjf@thinkpad> <CAHk-=wiak+h+d2tZ5W_MwRzatUP=hJKn7cpGjDxArG-gwgHLXg@mail.gmail.com>
 <as9-2cIuGuXwE2Oa@pedro-suse.tail5790ac.ts.net> <CAHk-=wgkoAuxNXga29nQ8w7GxdqR+4vPAUhPsbfp+gzKrb9EgA@mail.gmail.com>
 <CAHk-=whzkNzkBmCspHYd80D1Z=krDc4SgVC32=pJ5PtEgqSDrw@mail.gmail.com>
In-Reply-To: <CAHk-=whzkNzkBmCspHYd80D1Z=krDc4SgVC32=pJ5PtEgqSDrw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 14 Oct 2026 10:15:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wicpT0MJ7hFmpj3NiyobL6ErT=Q690Sod4iD7HT=bQRZg@mail.gmail.com>
X-Gm-Features: AclHuK9HqoL5WYsSIywkBsAxV0TH7_OPcbKjG6NH4NO6Sxx0TiFKxKFMs6FyK_8
Message-ID: <CAHk-=wicpT0MJ7hFmpj3NiyobL6ErT=Q690Sod4iD7HT=bQRZg@mail.gmail.com>
Subject: Re: Improve page refcount scalability
To: Pedro Falcato <pfalcato@suse.de>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, Harry Yoo <harry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 397CF4000B
X-Rspam-User: 
X-Stat-Signature: 3prfuys4h6hjo1tyzw59ifitjs97hndh
X-HE-Tag: 1791998148-346628
X-HE-Meta: U2FsdGVkX18VQbdXNLerM1MpmqAVYGTQNJRHnNM5BrAFDLljt7LUTR6KlGJlm/XO0JI0I+74RMq/Nb42/jeLsRJen5/wEtRY0jzfDRVRFBNEyum5r7P0+dqTZXzV6AaP/NuWVUd9dUeZbPL9YucEiKuffTXvMjMkD+62onMutVe0Pw9Wstad270nZbQnlxMmGp8j7tE31+IEOs35EucUYoaIEQrW5pyllFRXN46rZw2C/oQMGB/OhX9yAJB0UIwbgwF/GqNCd+IIByjqxMFFV8OqFKkCsWWihcJVDfVPumIRO0u+DBsQXLvfKR2YyznGR1n+x862t5oltGP6f/bz/GDyI5F7so5xfsGEqNu2hYl7NQKjBt/99zgBRXsYBT1OWcC9Zj0cbyNz8iwub29AYSQLOgDbDsBh6zyeHplSjfAFbTth9+QXoutHfBxPPhHwQkXhDnLd3Tqu7gwX+OTMU9fMUs8DXCck8tG2HwRtCX6K+9VYJ7dLDif3JzDzlZnUHa/gC+fXw4r7YMkO/+ilSSwOU8WbG61RI3i6xgan4zqgkF3M4MCDn4Jitf12dyibkOqveqdTBJE4FsX2XVDegbTxzmrN2DT77VHgN4990ZG/naIY7P5qmjA4Q374shoqQWBneVEkZ/AoSR1NVjfm39v7Alvjbc2KxBCzlFvbnKjwpsH0R2I+7v/Jt/mv5FyouwCYoVwO5HY2rUatvqIRLGwBcNE4md9ROwMUL5+o1tsnDawAfc+WPEKnEPg8kkiHW49ZFujRek8DVOHH2HCcbAo0Tv96Lk+LMJ+IzW0Au+wFAAiQ+9yElc06NxbjQXxm6kyR7S8ZlmgT4WXEcbDBF9FK0t5NEwlaiuL9O4Hi5mLrmeyKF+zh0quMyBslu120NjlCxQZ8QIs1aePlT5OPGDp8wnCbC85W75pNcyDvqr8oJpvuPkhtVYz2SiJhHF6IK3ftpn3D29dM4nUme2l
 /I5Rk1aZ
 P/Yut1UHlWpcT29+ZS7MX0BCKtvS8Aq74LkZIzXByyB5VvPhfJq+PzfPF7oo+7le5D2TM5efZnGhuaSABU4bZMvn/uoCa8q2bcycMKoPbKavvnDsGS9AjuKOiPTqQ2XcQbPrwaEvUsr0qv2RVZFLEA6M+rkMvprriY+3GmFra1duJPVq72IjTWFJlhq2IMWnUsnlymrkf/tUswCBxY9snwU3pnlUttswX3OM/Pp036/qziPAZJcDoes1aQd/9T0HKB/Ekrox23IpdjLbhdd6k8RyFze0thXzmeNpteKIWKkO/DzBhvMLilQJucLpSncS3x9Kw+S8Jl7JKcuQ9k4iqXHnERDGYmXAaQqQcH2n5lEIL6eVGsSd5STA8E8j5M4CoNOnmnxzSM1ymSnIfstK/GR59RYpmbs21Lyfx+jvz8dMgyTiE21wqJ/l9B2EIaTQOsvaCa0VaNj1SEiNjQIY3NTgRsbxl+ixpgWWV8+b5KluEjyghE4Sag1zCZd5pb+21JxwhoatKmiusPjXINjr6JjeE7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Oct 2026 at 09:59, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> That actually makes me think I should go back and clear PG_rcu_free on
> unlink - at that point the folio can no longer be read. I used to
> treat unlink differently from truncate/hole punch because of this [..]

From a quick read, that worked exactly _because_ the marking was done
at folio removal time, and then it was easy to just say "if the folio
was removed because of a unlink, don't bother marking it for RCU
delay, because there can be no RCU readers any more".

But now that we mark it at read time, actively clearing the bit at
unlink time looks a lot more iffy.

Not worth the pain unless somebody actually hits this as an issue.
Right now it feels to me like a "numbers go up" kind of thing rather
than a problem.

              Linus

