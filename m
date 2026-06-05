Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31BCACD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D01F6B0088; Fri,  5 Jun 2026 12:06:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ADD46B0092; Fri,  5 Jun 2026 12:06:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BD9E6B0095; Fri,  5 Jun 2026 12:06:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B64B6B0092
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:06:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2966401C7
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:06:45 +0000 (UTC)
X-FDA: 84846337170.12.B885580
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id CB96518000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:06:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=CPOelvqc;
	spf=pass (imf06.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780675603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OUZ5QahFiUWTYdBZUTA5YwtlfS/dH2OxVTaDuMHjYEI=;
	b=CABEO5JoPTNc36PrPVhVt97KMOVf6vhIZbRby7HjwhjhJWEhnAF19aWustzXQGGwOwJahz
	Lue0jLyYFVWk5RAMgkVzzGshjmvj7z/4KTCvQN97bRN4Jm6V6LYRdbCVzdMz/ekUusGbH8
	BHhiJjxF8aIaptlUSZ8rimr6HGOuh4E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=CPOelvqc;
	spf=pass (imf06.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780675603;
	b=TKxSYSAJd9Xw/GCRAlIJHl7Zk8DC86T4r1OxjfVbD9S2Y2vtW5EuxteONZCDR8DJwAW+GW
	tcI5rvsXEF6DDQP4h0NTDJTR9GIXRFLCVHPEOohbDJgo3B1H8bCAGOPu2qf0FSfA3FQ9C1
	wANeYUhuWxFIw1H9m1Gsl7NjFLkOsng=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-68852b58d87so3900536a12.3
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 09:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780675602; x=1781280402; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OUZ5QahFiUWTYdBZUTA5YwtlfS/dH2OxVTaDuMHjYEI=;
        b=CPOelvqcT2qCwUZae7ZDhWlYeAKCE+OVQ0vfc6ywFxotgjEIDPW+kxyYGLaX074w79
         CW3CbRtRR6Q+jDY/U/1j/HOXUAlURlk/udHDxjy7/lar+NHbAMMSIq9sUR1R1PWIg9+O
         BQW/pQdax4W20eBW+LSuHV6u+9m/uNAZjKPzg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780675602; x=1781280402;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OUZ5QahFiUWTYdBZUTA5YwtlfS/dH2OxVTaDuMHjYEI=;
        b=oNiYfLHPb65EGjxrcWfkiSgk3G0VBTSUCxj2xydr+0HledrmXa7RVg4O4VzVJYvoKq
         CGhbRuClObM8+PGTlVhHvOfq9mz0vGX/rDEcDznunjO8YZJKK+eKtJojH01cLkeZBBn4
         luhE3kFq7Wca4Gs59pcnKsWVItyNjkGuSURPIY3tqAqlBiEnWnkyfBcdew1D0mGVmKH8
         YgiAZaN0wvK0YFWK4sKIs3cEbSOeb4J2FBgGl8XIZOBaIbSUswk79sIEmJCGnTzhM0Sn
         +Bu3QBy7dLVrOR3/IfSMySh/Wuf1rkZYWsnqeffCKI5mGT/spspJ5WOyXmwYWba+xo9q
         fQyA==
X-Forwarded-Encrypted: i=1; AFNElJ8j0lV7nZe1vBX+qwrXbs/85nREmizpSdpa63Gdx3L2vrQYYGmsp+X5sJrAVNmgJ5D6Xe0CDCd8+w==@kvack.org
X-Gm-Message-State: AOJu0YxzqrHGfjrELIGN1UalFe7C+2BAZ0iCICNfxoO07Tsnhj2ydNYh
	C2pkInz0ih3Z0ePHCvK62WjUF6G7TZnqd9GNiBv3vWMk6Wut8jD3PWdVwa+H5pkFTKa2QGZpur5
	6iTo1u54ZNQ==
X-Gm-Gg: Acq92OHSIIXMuZwRZxnyYWW5OeGaIHfDAWNql9bP9+AfAT+jDgnJsXnZbKZNxX50GvK
	J/VS3kuFDczFzFJNZVqbJvT3RMuJ6iuEdIwxChof/ZVzXQcGhCHmVp5/cn4uJozBp4t5WyjIpTd
	BjHYVse2qKfNVK2mnagY+R3PVMF4FRntwKyJ+n2NfKRCtuACIgUCvroq6FQW4utXDi5yZpf3S46
	rYKOyf7he1116BH581HW60swuY2+U2vy+azpnT1Vpl9jWLMLpqW1bz2AGlwF5tqMMi9wkDUwzSU
	t0GEVbUw0qxyaKYwWbKJ4oUBxeEYFuOZfdeFH1CKlI88SM/8IK8IwC4ULnu+We6PbzHfEaCPfK9
	ibqpWroVLRmsGSnFmW5wGJ4POOE6SdESTaAlN9UleHxpLTQFoG5mJs8YLFO1G3fozAn8fKTdY6A
	MUhLyBnuLYyrIULTQI63Xm8tzUWTULyBj6RbIumw4vfRotTriZHATeYy6+xAG7L271pY0L8qMRS
	7yHAbZmxLk=
X-Received: by 2002:a05:6402:510a:b0:66b:f0b3:42a7 with SMTP id 4fb4d7f45d1cf-68fa515323dmr2445764a12.24.1780675602179;
        Fri, 05 Jun 2026 09:06:42 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68e65851fa2sm3830134a12.18.2026.06.05.09.06.41
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 09:06:41 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-bec449d0af2so249233666b.2
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 09:06:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+dp7fgICPXBp9EYpwXEtRXoQ/0qxYWX79I6zX0lcOvbXfaQUeLEmM6iLcCr9z9kCXezMAuhnHZfw==@kvack.org
X-Received: by 2002:a17:907:a03:b0:be2:dd37:facd with SMTP id
 a640c23a62f3a-bf370e6211cmr221318066b.20.1780675135190; Fri, 05 Jun 2026
 08:58:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
 <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com>
 <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
 <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com>
 <CAHk-=wgn3QTLj+F+XccE10dXY-UGWN8+fNLEvhsLw+tik9rOmg@mail.gmail.com>
 <CALCETrXpqPMS487Bm8f8mHe8hv9DzCqoaW4UdoHetzYBUAhYLw@mail.gmail.com>
 <CAHk-=wh5bFj1a7eaGp9sixDg3UXu7xUGfU=YJo+ckpGxGAyhXQ@mail.gmail.com> <f1c7fbbf-5be1-48b0-8927-2d9b75a35816@samba.org>
In-Reply-To: <f1c7fbbf-5be1-48b0-8927-2d9b75a35816@samba.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Jun 2026 08:58:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=whL0oLvmh3FO9SapDhgrXMT_d6qkP2V3OBjysOWXod2Og@mail.gmail.com>
X-Gm-Features: AVVi8Cf0FjZlqJePEzD8bhzCDc_NK8sni3u4Z9RMJefCrCHFLhBrwtWwfg4F_Wo
Message-ID: <CAHk-=whL0oLvmh3FO9SapDhgrXMT_d6qkP2V3OBjysOWXod2Og@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Stefan Metzmacher <metze@samba.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, 
	axboe@kernel.dk, brauner@kernel.org, david@kernel.org, dhowells@redhat.com, 
	hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CB96518000A
X-Stat-Signature: agsz164nsmxrzgsdayufdmqc9w93ygpj
X-Rspam-User: 
X-HE-Tag: 1780675603-508112
X-HE-Meta: U2FsdGVkX1+w+RuTpS+YcZGQBa7gjmdtbDaHWFBD/K+81ztEpYg0uEiKxdL/CDB16aoF8NkEsK/wf4XOyietPcupO6JqXB5s+4uyGYKwct5ZDKUOvdosmRGyEfGLi6usilYC2K2QfVjPNh2FOa4Cl06ekhlIoSruVQ5ZNw76IpHujHHl4nv1ip+c0/mm0UyTqrizJY16fqnPfnqD06DKpGokxXy4mXQsb8pN8eIaNYEK5UNU1hab0TUKcUkS/BvxOr4wSiTPP/6nKAn3oDeoEYb2t/wlB2ol3Sc5TgcLvJeo2CNtYQ8YpAicKYD+p0hZNUe+RMRvSp8REDjMSrKrhDhS/8pyZmAvh1eBxgvkgvsJjnM4YW12Rhy8iuK2Sx2ySx68RxlOvRbNqH1BlnilEDp1eDDYtqrf0pGbfC2N6naYIY7bsT6g8YFcFxdfb8HCOg4N26CQaLNAsRmnRzrCab537djErH+aQtodUHcgOW0ymlYOuk2T2CfZCjyE2JDloWQkltiiCw8ed8RMZRiNAGolH4HcwwA2pxzRqTMRLviYoY5i7fzYLByVbVCMkYK5qNiwkEGzThi/UMhzbDxQlLBYsmRm59u2+iPdC59gTWfu33I8f9MLjef4wIGJax8/dV55wSXcRnnM67l66HYMXj5mnxFKAc4/QWq8uOtOkzpkJ9yeekKxG71qVc+Wj7BBqBKAsAiOrKNzCKxX+tCN2dBSTZsyulRE56W6O9NJqH8BOE7nGLzAXVnn6belOxvMFMZXl+OU7fz1X1EgGUwLHAL+7dsV6E7nd3uL9HJL6iaDV5O6303lnEWp6T5Gc5uEnt0kzIAeNPMJ1DKwthlHSSS5fYrSyM/ruGoTYq23PX6ZFC/q2jWSawIPdoZL5KFFHFIPESFtbVtGMcaMYi2DxdBAcLuWpD5fRFGG56Ar9oqe7AjxdSkDXZIvgSZyOh0r6ibRiXsDHyoDUG5F5wU
 5CTdOPvA
 DEqUZZb2gc0LkzgmtXY87cz3cTUiKV9/frxwQBx1HMpFEUvAVhKkP6xmEAAPIuwqnrMV9V+MP5nuw4xI7avees7FLcwaYZLgjjEOnu3KgZVqXh5hkmnmG/dedNzx7bbaJSh6MZHKq8qMEn8Ych7b9XktdGHzvXuxFB4QgsMN0CePYBfoNcuyXGynsSfCEnRzItid/k6Q/e4T1/tlcvREERVRFcm8MuYMaSWPfyHmOVja+HdToQyHLkgXPBrr2VMM1AjPN90fU8ltPnx++AzQ+WdfWJWgeC3Zc0kmGpNxwgwZK4D2RHCL65m3ViOPRXcRaoxBngZzYz5wU65VIojxb2/XGY56TAEW/juHbGRGX6dsbtAW7dpybFt1JTS0kHRRNo4FlWysW7yu2gNPIchC4hdmmxvSTbgjMJRrQpX5j6o2uivFYXhwX3aWMuBwHB4VNu2jukCHvvGxJzAMeI0BcuVDqLaiaBYYeQoz9kPY1/5C+hqh3sbEp8+pzLGiv32ehuAop9hAanG3bhgkkD3x3TyZmouUg+Cu93HjuI3RKTau/38trII2IRBUm+kBOvg1dgHSUDmTE3snpMG1/yRBYIW/lxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Jun 2026 at 08:15, Stefan Metzmacher <metze@samba.org> wrote:
>
> It means the most common workload, e.g. a file only opened for
> file serving (or simple opens in general) would still be able to
> be optimized.

Nope. If your web server opens files with write access, I'd be
extremely surprised.

And if you don't have write access, and you're sending out data from
files you opened just for reading - the onle sane case - you hit all
the existing problems with "I can certainly look up pages, but I damn
well shouldn't pass those pages to the networking code without copying
them".

               Linus

