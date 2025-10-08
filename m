Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22D4ECAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 23:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67D498E0008; Wed,  8 Oct 2025 19:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654AA8E0002; Wed,  8 Oct 2025 19:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543928E0008; Wed,  8 Oct 2025 19:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C63A8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:14:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B192F13BCBE
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 23:14:45 +0000 (UTC)
X-FDA: 83976503730.28.5ED7A86
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id D535CA0008
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 23:14:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="RN/nwAXG";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of jpewhacker@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=jpewhacker@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759965283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SFbI6yfd+yg4dKJ49IX+g9zgZu5r7fNCwf9LHJwcps4=;
	b=CTlYqojadtnxmndYp1RTAXjEqnndWTu2jeHSov7fA4cqjlbEClH0E5chOBCkXmU5CkLgCQ
	Ev8s8tyIrBGU/o6m1Kcy/hlT2WcUzGrAwoWuv3fLTBE9dwhAzd9EcBMoshOHW0WNpVufND
	c8UgHX92xbI8MOaZUH+nYW2CzFyZqJA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759965283; a=rsa-sha256;
	cv=none;
	b=cMnmxx5CVCQCtfXMGR/ySAd+Q4lPavXh7HGA3EKTHztaHBCyaqTfD2gOnZk39o4M2NiLF4
	UbpOOVpaZ7lnRE5QpOwRh3kmm986SP5AfZWVcwKkVWqGVWkH8FawfN8QnRKfoYhTrzoXj4
	Ib20QyPle4s0fuSSaHqDHbH6irzanyU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="RN/nwAXG";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of jpewhacker@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=jpewhacker@gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-71d60504bf8so3874447b3.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 16:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759965283; x=1760570083; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SFbI6yfd+yg4dKJ49IX+g9zgZu5r7fNCwf9LHJwcps4=;
        b=RN/nwAXGfhXHAXQ0cbDPaghy6/oxJkvdbQXEg10KBRSq7xhntYJjuknYBW04parPti
         M0aMaziiSfMjh2j8QmAc9BcdQGsZSvh7MHURaePo9neHNr/cJILpFD95XLmqdtQ8/Gug
         hfCb2f8WYxDfREL1pB4hBW6Clq6kLpAM3q4fYc93RW0YRsvgjwJP/BG/TZGSTr4mjvLX
         HpHNyZz7Ob20oxeB/xAjbjJhHunk+wwZb/g6EowbYd/hAs4/0IM0v5YSpjcNy5UovrIQ
         qG01duYT7FFoUIjp/QjyowyJX5ZUDw89q3v3/1WPNPPMjJiOsm0znoSjn6S09z6Glwjo
         SfUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759965283; x=1760570083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SFbI6yfd+yg4dKJ49IX+g9zgZu5r7fNCwf9LHJwcps4=;
        b=n91VDWujmiFvh50ZVniBmECLI9Oor2JYzajHeAlsGgmbgfr7L/S761BTKKJlCcEMPI
         iBQIRpxLHf5UBuT2ZSKX7GOwj0ss75R0Gsaf5NFSCvO0X3lSljH6vlDxYFE8jzCvWOwi
         JWqSllmAhQPOtYHNJQ4qNoDVX3AeqgzegaHPSZmIoqwDTQK1AHyq6YNSa4+YvuFJAGpH
         hDu+UcS+vgBdc4i/4+WvBpNr6UALv8Wf3faBmqqfAW6BUgL6Ut10fyY0v5Vzx8qC9taW
         EuqlOJ1gFYLb4lv4CWcOw4PRq3fr/cydXRn3Mu0ptLRhOkBmVHM0ZuLV9OBi0bJdY94F
         z/nQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhxsbq0WtUeiRHxQQkniewsFjn+dcpIeYACI8rYnIaAevOT2x66kc4nI4dK0XbNtsHuP+U6xaO5g==@kvack.org
X-Gm-Message-State: AOJu0Yxhe9e0qS7es5hij5Z5bpSEL8EhQf3kZyebyl6SEdSP4yF6F+eV
	sc+Yx6+yeCRxL67BbVFCoiYqEn/xPYc8sI479bdtwyGaI8zk155sK1MgCMNylxw+EJK7WUQqqXr
	Rcxp6K2eUOJ1A2BFuWYs9B2XhTRF5/YQ=
X-Gm-Gg: ASbGnct/TVJ3b0kKfqT2qMAkjQ2BEKZE0gjMDjYu4UonDjFnDxDChY+MqO2r2mOYG91
	x8LjHB9TiCuSnzV2L3bhTvOQYnlMqU2hiQlm4fMv1Q9+lvpFJ0JpoxzEJ10OAMslKj7fyBt3WNK
	JPzS4vNCCXRxZYEus1NPAn/6MXyHPLKUBgFUo2BHOSb0RquI0a2uY0T3UEv8/gCkLQO4h3c2vhn
	vvC/bTeR4GUMyDE27LZm1DMUguXvA1MjE7tWKqu7lOkVfF3EV3X8TFh1IkFK3z46+g=
X-Google-Smtp-Source: AGHT+IFCEYGN+m/q1FKnlQZmsAbbOkqHlLXzoklzuXn/5KxWd8KUCLsi/0JemznMrYIDBz4LiBajWdwhGS2HtwHJwdw=
X-Received: by 2002:a05:690e:5ce:b0:62a:38ab:fc31 with SMTP id
 956f58d0204a3-63ccb884e07mr3868762d50.14.1759965282757; Wed, 08 Oct 2025
 16:14:42 -0700 (PDT)
MIME-Version: 1.0
References: <20241121100539.605818-1-jimzhao.ai@gmail.com> <20251007161711.468149-1-JPEWhacker@gmail.com>
 <ywwhwyc4el6vikghnd5yoejteld6dudemta7lsrtacvecshst5@avvpac27felp> <CAJdd5GY1mmi83V8DyiUJSZoLRVhUz_hY=qR-SjZ8Ss9bxQ002w@mail.gmail.com>
In-Reply-To: <CAJdd5GY1mmi83V8DyiUJSZoLRVhUz_hY=qR-SjZ8Ss9bxQ002w@mail.gmail.com>
From: Joshua Watt <jpewhacker@gmail.com>
Date: Wed, 8 Oct 2025 17:14:31 -0600
X-Gm-Features: AS18NWAhRXVS4bQVIwtYDJ5b-jz2OHqNOhjsxYSwMfqqDJlxC7ftCg-fC_O8rrU
Message-ID: <CAJdd5GaQ1LdS=n52AWQwZ=Q9woSjFYiVD9E_1SkEeDPoT=bmjw@mail.gmail.com>
Subject: Re: [PATCH] mm/page-writeback: Consolidate wb_thresh bumping logic
 into __wb_calc_thresh
To: Jan Kara <jack@suse.cz>
Cc: jimzhao.ai@gmail.com, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, willy@infradead.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: jdbokjso8xaqdxdhiqfac8a1cnnsg5c9
X-Rspam-User: 
X-Rspamd-Queue-Id: D535CA0008
X-HE-Tag: 1759965283-399588
X-HE-Meta: U2FsdGVkX1+9ImUhLH7RA2wWJ1BGRjnPdX+D4Lb2phs0ffZSfRWx/ZZja1v1777Nmn63TWwnECqip4omL8OzTN0IsMf4pINon20f71RYkowj6h3mTqByDmRfudWsV7NS6BME1XgKkDqOpbEmWn/96TeW9SFVYwBGgb7+YDFDr5ou5AlfS/2tIfMe0IVLEQWQEYEVcvq+WYCKbe2u+Wd7uoEcpG+e3sBX1JBClWQQhEOtfhdLBk6WrbhCYpi3Qc0NVMpqRlpQpOrY/7hqYNZtrwCDtgScQjwpS+QV74D9cH4I7dDBN0+7hokulL/nKUaYxX0r8WAp7uNqUMNCmlPsI4JjRmjZ+b+IENwO9TkzVj8fmrLq2fDnSGB10CxARubcaSaNB5gsw6mOIW4Dh/NMIngugAwWnt/knEyV6C3dtHwe4ccJIjvVbRAhdx2kwVdrrz8SRGI+z0o2S6LKoIuMF8x2l6mL8DOiYgw9V1rwCZZ2LuPmAChB2q3JLT1UVDiy6xserV00t5a5ClhOd63NnVuW+WrOky7E1aBkx74W2pSPgogQZfUCm5H3SZ8zg15lYDfb3UIYDRpVX27cdo3sgVTcqAHrD7DfEZhDfCvBq663XKYD/BjxrGoX3RlRTh7ewDFBGoOTOTItFgDOxCa6Z0AJbqDIwHJ9ojJIt47iFhXiRTmplfMvL1PNuoHtuEQyg7bqRlQbR1TnkA7gbI5WiDUSEW/wuI/XzpSau65VervL5cfOY3aOo5a5gkk7P4YKwya+ZlrpbhuuAt1BaHNhZ8Mh0CdVVFFg8CoOgudO9VnI68A6RxV7U+53k2m8ecZJ3OCfs7lpqbxeuC7uLZA5ZJgNiAm6Aa4etT7jbcqyulx4X4VVIuvD4CgaMeKaCeBe2VUivb6o2S75QGvfu6JaEE6/9GpFcjqZA2uivkXFUkKyQcCI2TN7mlo+McD4cLjw1cPnFKpg2iN1PlYTRI8
 tyCac2g1
 CwuqnEqKjnfH9F7CzMryBD+39R+0E9pp5FCrd5gUj6esJr7c2Y04kQKZRw/w+PtSyyTSNyItGe8C6+GiWVJn+9J+kpWADtFFRjoFhxO9Gus6CJmbJNg6dvnITuMXz/ET6dfLglF4z7rid0uF/bxo25gx/gtihP2D+3iRYmC9gxQXo2bV3rac2g0+3yW2Zwuty7Axt3xkh6ALPzwbJbgrwzC1U6a60/OkmB4iXrR2wkcMxaozFw6xk81NbP1MjmgIPUMfz2S9Mk9BRNZfDTJv6n9nXfVDxS4lnmog+Snbtn1xktrjF5qCFQ4Dy22RbX501K1n9awj/6WlnthDmMb0VvV+Dr3UBUWQ+AWu0yGNszh7sYrS3AWRtnRW7/jwx5VLKlhXedi6jF22ZOwlfaYFDGLv9clZwcXgN+IYv+ZRZO54YpSLVNW/mJWu/O3leqUOi+QAUMysdIa7u6OFhycfUppypmsubMeGOvfIpgTHpfp+RiYKBB+/7/vdr0VgzjINMn1MxYi8pRgXasof7FXA1UBz2x/+91LUzt5S6H7KFuZJ4WVtTjlVT9oPXqH7vPliZlVWOsU5Vu3i9XL0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 8, 2025 at 8:49=E2=80=AFAM Joshua Watt <jpewhacker@gmail.com> w=
rote:
>
> On Wed, Oct 8, 2025 at 5:14=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
> >
> > Hello!
> >
> > On Tue 07-10-25 10:17:11, Joshua Watt wrote:
> > > From: Joshua Watt <jpewhacker@gmail.com>
> > >
> > > This patch strangely breaks NFS 4 clients for me. The behavior is tha=
t a
> > > client will start getting an I/O error which in turn is caused by the=
 client
> > > getting a NFS3ERR_BADSESSION when attempting to write data to the ser=
ver. I
> > > bisected the kernel from the latest master
> > > (9029dc666353504ea7c1ebfdf09bc1aab40f6147) to this commit (log below)=
. Also,
> > > when I revert this commit on master the bug disappears.
> > >
> > > The server is running kernel 5.4.161, and the client that exhibits th=
e
> > > behavior is running in qemux86, and has mounted the server with the o=
ptions
> > > rw,relatime,vers=3D4.1,rsize=3D1048576,wsize=3D1048576,namlen=3D255,s=
oft,proto=3Dtcp,port=3D52049,timeo=3D600,retrans=3D2,sec=3Dnull,clientaddr=
=3D172.16.6.90,local_lock=3Dnone,addr=3D172.16.6.0
> > >
> > > The program that I wrote to reproduce this is pretty simple; it does =
a file
> > > lock over NFS, then writes data to the file once per second. After ab=
out 32
> > > seconds, it receives the I/O error, and this reproduced every time. I=
 can
> > > provide the sample program if necessary.
> >
> > This is indeed rather curious.
> >
> > > I also captured the NFS traffic both in the passing case and the fail=
ure case,
> > > and can provide them if useful.
> > >
> > > I did look at the two dumps and I'm not exactly sure what the differe=
nce is,
> > > other than with this patch the client tries to write every 30 seconds=
 (and
> > > fails), where as without it attempts to write back every 5 seconds. I=
 have no
> > > idea why this patch would cause this problem.
> >
> > So the change in writeback behavior is not surprising. The commit does
> > modify the logic computing dirty limits in some corner cases and your
> > description matches the fact that previously the computed limits were l=
ower
> > so we've started writeback after 5s (dirty_writeback_interval) while wi=
th
> > the patch we didn't cross the threshold and thus started writeback only
> > once the dirty data was old enough, which is 30s (dirty_expire_interval=
).
> >
> > But that's all, you should be able to observe exactly the same writebac=
k
> > behavior if you write less even without this patch. So I suspect that t=
he
> > different writeback behavior is just triggering some bug in the NFS (ei=
ther
> > on the client or the server side). The NFS3ERR_BADSESSION error you're
> > getting back sounds like something times out somewhere, falls out of ca=
che
> > and reports this error (which doesn't happen if we writeback after 5s
> > instead of 30s). NFS guys maybe have better idea what's going on here.
> >
> > You could possibly workaround this problem (and verify my theory) by tu=
ning
> > /proc/sys/vm/dirty_expire_centisecs to a lower value (say 500). This wi=
ll
> > make inode writeback start earlier and thus should effectively mask the
> > problem again.
>
> Changing /proc/sys/vm/dirty_expire_centisecs did indeed prevent the
> issue from occurring. As an experiment, I tried to see what the lowest
> value I could use that worked, and it was also 500. Even setting it to
> 600 would cause it to error out eventually. This would indicate to me
> a server problem (which is unfortunate because that's much harder for
> me to debug), but perhaps the NFS folks could weigh in.

I figured out the problem. There was a bug in the NFS client where it
would not send state renewals within the first 5 minutes after
booting; prior to this change, that was masked in my test case because
the 5 second dirty writeback interval would keep the connection alive
without needing the state renewals (and my test always did a reboot).
I've submitted a patch to fix the NFS client to the mailing list [1].

Sorry for the noise, and thanks for your help.

[1]: https://lore.kernel.org/linux-nfs/20251008230935.738405-1-JPEWhacker@g=
mail.com/T/#u
>
> >
> >                                                                 Honza
> > --
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR

