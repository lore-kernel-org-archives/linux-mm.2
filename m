Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8881BFB44C1
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 06:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4B9B6B0005; Fri, 24 Apr 2026 02:54:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFCB96B008A; Fri, 24 Apr 2026 02:54:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EAFA6B008C; Fri, 24 Apr 2026 02:54:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C8B86B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:54:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2BCB9C32F7
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:54:32 +0000 (UTC)
X-FDA: 84692535984.18.FD05F91
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 378531A0006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:54:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="l8QA/7IL";
	spf=pass (imf19.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777013670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PY6x0drsie9DTFRy/FzyM357y9cc2vXO6VzIJJ4fYUA=;
	b=3plE2peMVU0bSpu8z8ysY0H2km/lisUP7/UpnFg+oe73dnk4XxvajHMktSpVxji8teC/1K
	a86giwd4wBGPur5yryY5NhY1/g3B0KfCzz9QRen6m3CILyhkk8SC21HT2usfZehLz02vQs
	OL8QeL6O8FhgQhOlqRtX+YqHFi8aox8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="l8QA/7IL";
	spf=pass (imf19.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777013670; a=rsa-sha256;
	cv=pass;
	b=ZQ810ItroruR+eUdhesc9LAeFrl7QHIeu9MwPUodj5vohfnv034NKzssY0WNmX7KCx04ue
	bcEa7qknVEwpXicILpKd9W3CW8y+K7I3hsbDxsClpprATAujl26wDJmzHgCjv6cA64eJwS
	rnvzd8NKhjyUetxfeQYt7JNFuGTFMVM=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8a3342d301aso74044426d6.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:54:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777013669; cv=none;
        d=google.com; s=arc-20240605;
        b=PBWFYT7efUJ4uBWFeErLdlRx4cQSDcifnnBvl8+cNcYWeViacjGuy8iGqoQD2rxsYF
         s3M2fkO3MtJKJPKPS6yTwKS6wzaEGybH+ORxGHYlJNWkQ3We19pfekOzAcB9A3qdxTsY
         b2cPDijQycvNPU+zFxHKb0A0RkIn3E3DrhvEQljAbM1SEWQKdsy0/lhu/T0hJEVlP971
         CeCl19t3EihZ3MdwE0s8HrB/Ws3z5+dohSQ5+d7bXA1RzWgWCW6MMpM8J91JAyvslNwj
         tToGGCbZE1RSZHyfyGDCo/Qgaa1kcRWXmJ00B8ZQo4O3tLld6T1RKVwhnGOq+eOQJTSw
         FYcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PY6x0drsie9DTFRy/FzyM357y9cc2vXO6VzIJJ4fYUA=;
        fh=btiWCNtYmqUv72kXk1lJMEN/LDyBC6jrn8oS/w3zx8Y=;
        b=WOBoQk/ZUAtpwC9i7+6bVrMTuIUxvBzZ7MZCKznJx4N6ui26iPk0q09YmXqCZM5YEP
         4KIBKq16k01Al1hhxpvRwh18MibDGEDyzVewN6ZL7SwbLM2ugJwYuQpojBB/bqIQ+BHb
         F13If1aO7hZEbxBc4Kfd5J6ajtzJhwgOQY0m/IzfC3xgHLveR/UghE4SLuxh9YLuzhwc
         5Kio76qgOa+hHuChzRw7HKZK4AnmGZtjXYGe6CSsAn5VSWpBpu2387Dyj/uV2Y+ej9kS
         xQ0e99+5mANJc/lDbBPmNocw6HB+XeQZUhjJTtb5WX5vrOIk68yu/pxgWppadIkWikgS
         1vJA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777013669; x=1777618469; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PY6x0drsie9DTFRy/FzyM357y9cc2vXO6VzIJJ4fYUA=;
        b=l8QA/7ILGcdeY/px7jUnxfnMzrJLRiv+vCgw1D2MXYAs8Vf7eICGjv4N6HoDLfSHBY
         ElR3Tv3oNN/8qiVbBc8A1A/XH8yL//JDG8IvMiFrno3sIJ4nUBsnNsOZ0bYW316vbmkB
         VQyW2/snxy3lbxTHGjdHlRQr+8mZonuyNrj+KTBw5rlOSxJG7IE55JSf/ZpW0eiQaZg3
         DHIEyTngDihBdhE5Hr0ZDo0MQwKdLoB2hmhaLhideOVrP7om6up7H5dQYxXYmMxUq6gk
         k1Nw6DE0GGH8AHtnAU7psRCUliuoF1EQYyncz7Ki+EufCOUsEgroflyIqxUrvFr6XofZ
         HLGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777013669; x=1777618469;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PY6x0drsie9DTFRy/FzyM357y9cc2vXO6VzIJJ4fYUA=;
        b=cTW4ChYPF21kRblurWQYneKawLNbO9XU7UllNDlLucb1Y9izUFRMmzo60kJiRFTcr0
         nHET9Q4X5z9CFcmsQpL1NSf8RCdTNWqPzKGmqef9fvyZ9YpXfLphYgFpjeFYnzlsdQzR
         msp3i7pE6Ul4Ru9kgg6CYJJE0THjJGHJgt2QYwmnEMPtycvGnkceLrcGJdtGbiJXZtV+
         IG/veqeoQMamd4U91KRMF85nx/1k0KD/eSQ1EH/qouGkG+hAgnDZoJw9c6fhEzw7+MmS
         AhphKVhIf4pztSMExtWO+f2zEWPS5MY+uqG0XnA2yRq5y+TvbwePUNioupSzLtqbXvf5
         HhnA==
X-Forwarded-Encrypted: i=1; AFNElJ9Wx3bsSp8LbOe4eTfjhEqwq2gcLOWByZwItcBJQk/HD+jw65PZ67HD+rrsJOahwKun79YA4bViHg==@kvack.org
X-Gm-Message-State: AOJu0YxtW0NDbWXM9WWWQvV0OQ3Q0L8SMmqWNz0lz1vNnARqxg1E7p4p
	manVU+EAFVrK0V3uFXWPMghqU5EE4CGCpYRjb0jDIyTW+TmyiO7iMeHiqzYBoIcYXDo3XXCrmON
	QaA3MbyozawJ5ltPuMVQygxgYEy2oTnU=
X-Gm-Gg: AeBDiesYGaEwDy2h3Ih+gk6mrtjQEcMrJCNFNngx1VTCkQFLtJW66cY2itOwdHBVMrk
	di02eXkSDJLj5fokEAVRYmvnACQ8Q/0G8HJxt3y0kZ9YaN1kIFO2FEnwvaUtCQXCKgXGj8LAUPM
	mFdBchYFDK70NqD/tj+iYcSbuL+WnoIq1II9OW7oJKEw7Y2uAvZk163XdMhdA7nmAZWTnpQf0YT
	JdbQpbv0o7WQY67L0eg2CaOoqZpZgRqwGhvDY45uIv7MVc0HZUlnVb/n3tLyDRkrcDk7TslOAvU
	PBH7EXiB2Z64HxVFGRlTLroyP/UuzcGO6WQw63yaM94sq6UZDA==
X-Received: by 2002:a05:6214:20a8:b0:89c:5f6e:451a with SMTP id
 6a1803df08f44-8b028080052mr492516496d6.21.1777013669182; Thu, 23 Apr 2026
 23:54:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260421020932.3212532-1-liuyibin@hygon.cn> <aeikm2e5Gh5reJ30@lucifer>
 <bc514883d6154420b3cfde4ab25a20c7@hygon.cn> <aejzSsiXZBK1emv7@lucifer>
 <a96c20b74b874248bc0cdc2b926a43fe@hygon.cn> <aerhh_tzSs5XapUz@casper.infradead.org>
 <CAGudoHGnOMj7O0P0pttdgdhGnJq8+Nv3_91x8kEAT5wR_xDmgQ@mail.gmail.com>
In-Reply-To: <CAGudoHGnOMj7O0P0pttdgdhGnJq8+Nv3_91x8kEAT5wR_xDmgQ@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 24 Apr 2026 08:54:14 +0200
X-Gm-Features: AQROBzA2h81VNcq2jOAQe_t2FwlCVNTmWCUZPO4gDdP4xuiwSERS1JEXtZu_oiw
Message-ID: <CAGudoHHC0wy9YrkTF4OZanjNPA2HKnzZQDv-Cv6_NnUChb_p8A@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOetlOWkjTog562U5aSNOiBbUEFUQ0hdIG1tOiBBZGQgUldIX1JNQVBfRVhDTFVERQ==?=
	=?UTF-8?B?IGZsYWcgdG8gZXhjbHVkZSBmaWxlcyBmcm9tIHJtYXAgc2hhcmluZw==?=
To: Matthew Wilcox <willy@infradead.org>
Cc: Yibin Liu <liuyibin@hygon.cn>, Lorenzo Stoakes <ljs@kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "brauner@kernel.org" <brauner@kernel.org>, 
	Jianyong Wu <wujianyong@hygon.cn>, Huangsj <huangsj@hygon.cn>, Yuan Zhong <zhongyuan@hygon.cn>, 
	"jack@suse.cz" <jack@suse.cz>, "jlayton@kernel.org" <jlayton@kernel.org>, 
	"chuck.lever@oracle.com" <chuck.lever@oracle.com>, "alex.aring@gmail.com" <alex.aring@gmail.com>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "jannh@google.com" <jannh@google.com>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 378531A0006
X-Stat-Signature: 9hwz94fckoq1uamytgfg5xjojp9kw6kk
X-Rspam-User: 
X-HE-Tag: 1777013670-529138
X-HE-Meta: U2FsdGVkX1+TWSiJB3H5kciB8pWpPoECewuJZAUyVdjcu31WlCPb3CSnFwPgnEl5xHSuLNPtf5fy6nEWYyA2cM81TW1ZEdWru/1hsgo6jlr51S3JM9mCQEUjdsMm1yv7ElHbKpcMD1n8Ri0TyI0eP5XorMdIUyplpMwti8W/f6DHO0Src71Ud7yTQbqwQDJ8+zit8EAwtApvZKJyf6oBkxtt1MXxS7JncSo+2Mdsn8/Sg23/6LKZukA0GGNWXuCyrcwGSpsmdn/lrNgusQGO6tQVz8rwBK9cYdTR60HKlzqaRK+So6dB+IJnsjRI7oqryl5XLnk8VrpKHH6z3MpYbDiPf14sZqj2TBFrbyz+dxf48OJXuKceDsVfSB4VfOvY8hHSHKjJAarDd4KtJZ58FYFrFgD49nAGZK+HTsOtUwh8T7k45ZfHiqzUKLC59swwh81tw8ylhuJ/V/kW29pygTG4DF2vC5ErJAydGyunXAGvZD3y6azpAA2dS/6QUsqchynIe93kOrLNBbFMKzFiBSX+cyqKLQPqCbRDIox5cnkjxtKzyJV7zTPc0hkvMBTZkO+q4IpvuT6A3u587mQ6gYWWkAd9M/EVq7nmNjrisjtUHXznHktjexl1fiT4tCuXKr2ltfi3piSuAToo/HL54+QO+0ajfJwoFKybk+vPTmVRREYf2WBAGagoEVmd+7ONqPcJjvA1QvIsGD/l2O4oM69NuxpU5sifWmPSc879iO18jUXQtwb5lLnuq+4gij7RYax4nhgSULRbONXhhOFAMjerJhtdjrUWDsTHdm83yKz7T0/CzpOKO8jLctwnQ8rZOoBe6irky+VFmNCym7WLdyP/2QgCR3QmTaEH/UXs1TZAFOtd1F7SoV9TJ/9TE588mVrHIJ3+rmbj7nrbRUvIk6XAsxT+1V5xTDbm5+mF4IOBEQAzbkpd2RflOub3S2sYUz+2qsimknn4X03CUXa
 WJPduOc5
 IBtjjHVPRCoMMAl6pHAQ8NMbIrOvtnb7kRvi027ePw74O2SGLIum4+CGAB1DncS5e8ttnHFIMqsGgx882U8Nq80ZoNi4diDzJXMoJom94CoGGJfj2cEtwc5zkDYUPKiIrnMpubeu8dRu7p+FJ0aRc8IFD49w9O2j43sGM655Tmm7F6n/+nxz25Y4+3VD1gLKjvPCvIWukMO2APpdw4fE3MMoCYnVem7nqlHY59u4MDCLizY+wQ2fcZkdwCRk6zWOuooU29SfhRUS4PeXtAfLdykN2ujZSYvCPA4pFmKSMCRwwAyDzR28smtLcapnT6Y7Ihul8ZdEy2ipMBVOlMCIwOrJY7wolVS2jx4cd3oDHtk6jpWEVd1I0DhaI2Us3VVxjjMGg9oOSvBo9+S+heLWQM7me2f9g5UkF4/6Rlb4EwdatxYTvnIR5URq3s7Q1L8kX5P7/UmfN4C/o6/NdLuY2X5bC6vgIgKcbi8LssvziKr+W8IsgOvyCqEKn9BEj6D65IIwypyqUXkZmrj7ewTfVeyEdTOHLCXm++kTkGiF6m27+H1qm/FueKf8PSI0B3T6fUDWR+7bmbdnkMOIZ3o/tEXfAQcJS02S8JPzTHFvEz9QfbqMBBBq3Vs2rIMmewjB4WGehezq7NAf1jxjwdGlARwNgQH7jO3OaFf5g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 8:20=E2=80=AFAM Mateusz Guzik <mjguzik@gmail.com> w=
rote:
>
> On Fri, Apr 24, 2026 at 5:20=E2=80=AFAM Matthew Wilcox <willy@infradead.o=
rg> wrote:
> >
> > On Fri, Apr 24, 2026 at 01:08:35AM +0000, Yibin Liu wrote:
> > > On an Intel Emerald Rapids server (112 cores), run the execl benchmar=
k from
> > > UnixBench with the command: ./Run -c 220 execl
> > > Then perf top shows:
> > >
> > >   91.53%  [kernel]                    [k] osq_lock
> > >    0.50%  [kernel]                    [k] rwsem_spin_on_owner
> >
> > OK, but does this represent a realistic workload?  It's pretty easy to
> > construct workloads that hammer on particular locks; the question is
> > whether it's a relevant performance bottleneck that customers care abou=
t.
>
> This is a genuine problem when doing large-scale package building.
> I'll say upfront I have extensive experience with this crap on
> FreeBSD, I did not run it on Linux myself, but bear with me here --
> while FreeBSD is in doubt a less scalable kernel, Linux demonstrated
> to be suffering from the same problems.
>
> Say you have a box with a core count of 100 and get it to work
> building up to 100 packages at a time. Further, even if you use some
> form of separation from file-system standpoint on userspace level, you
> still want to share the common binaries to reduce memory + cache
> footprint so you at least --bind them. Then you are susceptible to
> contention issues at least on paper.
>
> Granted, building a pig like chromium scales great because it is
> written in c++ and almost all of the time is spent in userspace, with
> forks and execs of the compiler highly spread out in time, in turn
> putting very little pressure on the locks.
>
> However, vast majority of packages is very tiny in comparison
> (literally a few .c files) and this is where things go south as they
> engage in exec frenzy, looking like a borderline microbenchmark. The
> primary culprit is configure scripts, issuing an idiotic number of
> back-to-back execs of short-lived processes (notably sed, but also
> grep, rm and others). There is a lot of evil in makefiles as well.
>
> I don't have numbers handy, but in case of the FreeBSD ports tree we
> are talking about over 10 000 ports which on their own take few
> seconds to build. Since these are largely single-threaded, if you have
> package-building machinery which can saturate the box, you easily end
> up with parallel builds matching your core count. And when they engage
> in exec-frenzy for the duration, you may as well be microbenchmarking
> it.
>
> A sufficiently pessimized workload is indistinguishable from a
> microbenchmark and this here is an example of one.
>
> iow this is a real problem, but I don't have specific numbers for Linux.

I had gcc handy on Linux, so I ran configure on it by hand. This is
all autotools generated, so general theme matches the small programs
as well.

I ended up with the following execs:
    285 /usr/bin/sed
     95 /usr/bin/rm
     88 /usr/bin/grep
     77 /usr/bin/cat
     30 /usr/bin/gcc
     27 /usr/bin/expr
     23 /usr/libexec/gcc/x86_64-linux-gnu/15/cc1
     21 /usr/bin/as
     10 /usr/bin/uname
      8 /usr/libexec/gcc/x86_64-linux-gnu/15/collect2
      8 /usr/bin/ld
      8 /bin/bash
      7 /usr/bin/mv
      7 /usr/bin/c++
      6 /usr/bin/mkdir
      6 /usr/bin/basename
      5 /usr/bin/ln
      5 /usr/bin/cmp
      4 /usr/bin/sort
      4 /usr/bin/dirname
      3 /usr/bin/rmdir
      3 /usr/bin/hostname
      3 /usr/bin/gawk
      3 /usr/bin/cc
      2 /usr/bin/strip
      2 /usr/bin/mktemp
      2 /usr/bin/ls
      2 /usr/bin/egrep
      2 /usr/bin/cp
      2 /usr/bin/ar
      2 /bin/sh
      1 /usr/lib/llvm-20/bin/clang
      1 /usr/bin/tr
      1 /usr/bin/touch
      1 /usr/bin/ranlib
      1 /usr/bin/install
      1 /usr/bin/diff
      1 /usr/bin/chmod
      1 /usr/bin/arch
      1 /home/mjg/repos/gcc/missing
      1 /bin/uname
      1 /bin/arch
      1 ./contrib/compare-debug
      1 ./conftest
      1 ./configure

It spent almost half of the runtime in the kernel, all while there was
no contention.

So imagine all that to compile a few .c files & rinse & repeat
thousands of times in parallel on 100+ cores.

