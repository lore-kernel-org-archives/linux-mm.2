Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1848BD2629E
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 21:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DFBA6B0005; Tue, 20 Jan 2026 16:06:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18DC46B0088; Tue, 20 Jan 2026 16:06:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061696B0089; Tue, 20 Jan 2026 16:06:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E4A096B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:06:46 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5119713B982
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:06:46 +0000 (UTC)
X-FDA: 84353576412.19.7B5B773
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id 35010C0011
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:06:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VrKaBu+F;
	spf=pass (imf22.hostedemail.com: domain of morbo@google.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=morbo@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768943204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qm6uyV8c9i4IGocHzcVQAcu7s/WbazRCpwyhACW9O4Q=;
	b=ln0rlHRCHcQOClw2ziDbuyc3sPpOTYZKxoqhiQq+UFJsO5vJ0AOdPRC+YDBZpkVLMljhD7
	5ADMhdLd5m+lotKQFtFPwP4hSHbFbnE7vjwq97fMvOtI2tPi6m1aacFCD8uPD8qbtBLE0h
	OjtM1SNO6iiA8fX2E032LnEPHpMXxSs=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VrKaBu+F;
	spf=pass (imf22.hostedemail.com: domain of morbo@google.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=morbo@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768943204; a=rsa-sha256;
	cv=pass;
	b=aYEGztWXbVSKq3pf6SMlEqViV+ySPnh5iv2eWiXmxbZme0rgUlkno/1sCiAJ1xyAUnNwtx
	Mry/XHMba6Po7LE3KhZPKKt0AZT1NFV0yczXAIdCGfBSpoiOs0YSkoEILiTmNKSUFxai3P
	CaKnarLJM4t/Q3pYDz7E2VOvBssXpgM=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b86ed375d37so767715266b.3
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:06:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768943202; cv=none;
        d=google.com; s=arc-20240605;
        b=dnJiMN8+RBnSn1QyIaTCz3pWXswZDFW5NrMcna7xeGVFtgZVufhhUmOdwPUsomJCzh
         y5LuVV0k7KEnD8m3BzEWcJxTGnmVnVizfrC05RpF/oqe7GFmBo+FMfxYcbWdr56KqPuD
         BZZG4csu1BVmcw9I9q9jtyf/sCwpRcYNFZnWxFog8tbC4gul1S04wumgDNIjtQ0+JnqE
         s34aXf9fQAdbEX05tHzhtnzQXN2Ah9oRUz4f6xzIWr7MAK6jJWOSCJVdfCETaEx9BX1e
         s686w4MP9d759Fz2GNqrAArH4yh5QMXiG/SMOSC8adE3A308PyzS4Zzd8sRQ1Gnh+IXa
         OBHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Qm6uyV8c9i4IGocHzcVQAcu7s/WbazRCpwyhACW9O4Q=;
        fh=nF3KbKNIa9WQwxL7Zs9azAqaAAa4puVlcDyAKXBUeW8=;
        b=gjB8Sk9TyBWoPrvprRX5sDEmRxNs8BwXaS+Se43GmSX1S+G5JbMHGWz31dHd9fiJnI
         LZyyoLUVLP9V3kDQ0vk1dwWahShfV6mOWuAfmg3Wl+95QrufuECNr3YoqZRBk21B7kw1
         p+SldC2fKRXZeN2Wz2ehP1vDHjZA40xu/Lp6yxS4hOeHwEzWCUAicbae5+Kss5cYit6H
         BJI+JHqUMZ5E7rMVbQSG+/nGVh/4LQSyfPmdiC4Y4Q1K6PPw7uHA3D6FvdlqVGgjtLXY
         02vNBRoF8Bs8ctD9zsOGt8mJn6YZBAd0r9wpmTHNG3q3ITLyTwGRoYEhEMz3g/MwYYgm
         b77g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768943202; x=1769548002; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qm6uyV8c9i4IGocHzcVQAcu7s/WbazRCpwyhACW9O4Q=;
        b=VrKaBu+FAqt+AtKakwuF8Cu3fFd/eVuFAXAeom705zQ54e6VpZfcYJFfdZYifTV1yb
         nkxD7MZyiZtjhGZc11uGXjht6t6U8XCRAkTEf/qSn+VhGAFXvg2uetJDUQRjgqPJ/KjN
         nKyJJOmteFuoxxvD0g28liNnZFiifpOLCemGTbzbf3aFMKYpnciscWinOjgZf5tAl/61
         N28IMrLLoqY8fUjvNyEv2p6gwbL0Tz7mVu2bU5kF5NLe0/BsN8bRyyX/aYiKXLHUvJ/N
         Sb0yrXa+9ZdFw69SIlmsf8VrWfpVR9CXIiZQjctdPbsakJKybpptqdDWZI5Jvgy78CYp
         DO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768943202; x=1769548002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Qm6uyV8c9i4IGocHzcVQAcu7s/WbazRCpwyhACW9O4Q=;
        b=ATX0E3DE1JAXjYBGaw6ruBOmALOhSli33eBJzXLEfoVN/xbOM6WxudTTNkCc4eEUPg
         Jk0HtmhE0IR/gdGqMtYX5Wexicq5hQVNExFAX8UDQmh+5PqcNkAB+I2/n/ZMIRGZfJNA
         y9y6sZOB0n2tsl3H5+LXL1W0pMSiPmj34etPYqPPnhtUeVz+NYHj322Ix+00850FSJXN
         ZL5Lnn3qev4Ikmi1wVWzpXWNfeST9M6AsOqeO5JNYeXlSWaOWBbuYLvFZCYO+kSVAfso
         kzdF/zo9w92uFPPtqhFPRZI4uecMNZOU0QQXEXGR9HOyOFAWz4MsemovBCzqd0ML82mD
         1bWQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8AG0xrX4vIhHy3Uz9JYBHUzfrzILQXbv6GF9n0u3Uvlbq1go9MtS24sCKdh/JXbOBjrZ3alWLcA==@kvack.org
X-Gm-Message-State: AOJu0YzGdzYIkEbevDpK5UqNLdmuxwmF0FvNpVYIwvh22Xb4joDoY3yD
	LujkwV+isbKqe1l5uvKlMIbk/RY682O3q2EhAR4qHVUUPTGPKoxfD1JOzvb3s2PcvzJ3gfa+Uik
	AhtP6Ktzz/q99JfvEkv2Mv0MM4CuSuV0zuDJYR08=
X-Gm-Gg: AZuq6aJaO9GzcTiP56ZdWqHir8AuGqYQElgoZXpWaH+IUX56oU+OQnO7e6u53gIPQBG
	c5+uBkA9JPAd+b9CCwblG6XuWfTr7bvYpLowZ6teAlR9F4z/HTP23+cUD1zOnhtHOMxFQBzUhFb
	Tu6ZGZZ2xv3O25vXkkeOmk+z33gzhBBH2zjsjpaIznDnpRNJo1ce8qeXFkrVVWBwf6Pon6xZEOT
	LYnrxcoB7az1XbxRmdfui+4PXdtr1UJrUak5Mr+o98wG5a0SPHZnJOXGw0+z2AP4bNClfQMa+fI
	Mi/7od9q0XDXsqs1OAo0vrOy/p9VeNO6gKfEMHzIag4VZQUJ5/m1ESJhWMf/EUCn6Lzhsl7QAde
	2BpA=
X-Received: by 2002:a17:907:9704:b0:b87:695f:d2a8 with SMTP id
 a640c23a62f3a-b88006deaafmr271902866b.55.1768943202102; Tue, 20 Jan 2026
 13:06:42 -0800 (PST)
MIME-Version: 1.0
References: <20251121193957.1655580-1-morbo@google.com> <20251121193957.1655580-3-morbo@google.com>
 <202511211525.05CB7E1AEC@keescook> <20251122141614.80f1a845cd694b1b470107ca@linux-foundation.org>
 <20260116084259.GK830755@noisy.programming.kicks-ass.net>
In-Reply-To: <20260116084259.GK830755@noisy.programming.kicks-ass.net>
From: Bill Wendling <morbo@google.com>
Date: Tue, 20 Jan 2026 13:06:25 -0800
X-Gm-Features: AZwV_QjMxUUkSA0RIc2Md-zJtLCHQ4cc9T_bOZrlgL2_PJok5McD0hSVq7Vo6co
Message-ID: <CAGG=3QXU5vvgV70Kb8-KUF7f0sE7XOqnFBijVnazSN9gdgManQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] memblock: annotate struct memblock_type with __counted_by_ptr
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>, 
	linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Justin Stitt <justinstitt@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Marc Herbert <Marc.Herbert@linux.intel.com>, 
	Uros Bizjak <ubizjak@gmail.com>, Tejun Heo <tj@kernel.org>, Jeff Xu <jeffxu@chromium.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	John Stultz <jstultz@google.com>, Christian Brauner <brauner@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Brian Gerst <brgerst@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 35010C0011
X-Stat-Signature: u4j1cdo9frcbmas1zrw8inw18rmth3ae
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768943203-573421
X-HE-Meta: U2FsdGVkX1//k+jx+Uk4HqdEPmEUkY3x5TjQCU9s7nh+9iXzokvlJOyzjOX7T5jNQZEDC52hxWTfUf18K0jP7DJcqxz89oK+Tdld5M7tCdSj/h+1mg9UoSaTOapWpeuTh4h6YrcA8Yn50XSYpEYaSvWUcN0IMSHus5SYlEv3R8wcMhQ+RNJ36mVbHPRXCK6OdTz2JMWmim7jYLfnfcGbIGESV2uZ7yJzxYx36UE4nJFNW/wRJkgoE+9qHiYp2wrcItqnw/UwlNq3ScX4djDoE/vnaJn0uP5TdTYWLEaKl9HPeN53xID/f90apKoe8tqfq3FnWW47WA8SKWBM3HydpFo6DTUBLIuiWqSxgjShaqxDyCMAv+KnlYzStSQJbGagHN7ani15fDadi2L06mT0G0xJ2D9WbNoiN1EnjWDeE7q9smGHKq4avkXYJ7XebGDGGCp7L8/x1hmckaLJTauYcX5YAO8oupSW8JexCy2QwcSykz8sUxNyZdd0fr2JzMGlO/qPRZkM0OCNepO9Jj0CI0HZiI3hO4HttpSXP2+m+qtVfC8yAVsj4td3P6ju4NodKiuX6IRe8ztRrWciEaT43+FYYlUwavsfTE/5ATBCYVhzibIpw9FOKUr8hEfJKJ8bQVGmBvYVY9M01aUvI1N8TwYOpGYZOHoGKJS0jYMSXdOq9qh+LnbwR8eS3x5qw0lUXdPc9KGKG8GRNS/motXFVAse8mbz1KqOBx0ULmVEv6tEttNaug0jM3ixkqjI7P4ZTYacilmncXJPs4ETKY0ws2EUOtM+i5oGVOTlajVJ3Ao9GO4QsvsWzcY6cTSWnBfmDgEFWuxw2o1kNo62Bt9K5QZeoDNBQey+yF+fiQHgWY4mjNz+0XKsKatBXiLX8dxeNJrGNRN994XE/oW3+2ItUGWAQ5OIG0YaZdpL6Fdo5RXVh+jt0uKQC2+DePUZEbIemTuFWwTyfBVLwTF/qzt
 pPbA/cTl
 Cn6aCapJIqB0Ldu7kXNYV1jo13ULG4oW3UyXx5sNIx/UmljQo4d78IFIzFJKP3zD4BIqRnc8CzNjfTmSqONKy1ZVcKjwEuzDMH5EU4yUs1vIx6TBhs91YKGcJe1GX4+RV9/rFy2KtODGV9SAA8IozedckyWNA0hu9VEIJypsxiALHAFbUp9QIN6OY2y87DlFnrRxfhqPxnVcEfgspjnKsQSmzmM/3kDwBrxn6zp+ob/bTVNoGY6P4uoIcQ/H9QnL+vrISojpdraxWUIae0FhQsDo2tGd2DVMZuUDXi2yNZaQAkUI8vTWHA3pLnGmp1XeKRAr5vS4NT+mKlpbwZzvoYlsKNFQHPU96dPlVgI+tLUZa3lm1uwEa0qdn7pgwYmoCSrCrYBfd2i4lLj5G/EDNTJ7xXedvHxVm2IQHKpof+jyfP7Ns25TDYYesh+1j1NY5+80ctYJoRjqKH+4TOUdBEZMmAHA1O5iC4sXN3aq/+g27GSn8KCW2H6o123k1w37xnfwiAxgufFIyMgrfKZ2DZ9Bszw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 12:43=E2=80=AFAM Peter Zijlstra <peterz@infradead.o=
rg> wrote:
>
> On Sat, Nov 22, 2025 at 02:16:14PM -0800, Andrew Morton wrote:
> > On Fri, 21 Nov 2025 16:30:43 -0800 Kees Cook <kees@kernel.org> wrote:
> >
> > > On Fri, Nov 21, 2025 at 07:39:44PM +0000, Bill Wendling wrote:
> > > > Add the '__counted_by_ptr' attribute to the 'regions' field of 'str=
uct
> > > > memblock_type'. The 'regions' field is an array of 'struct
> > > > memblock_region' and its size is tracked by the 'max' field, which
> > > > represents the total number of allocated regions.
> > >
> > > As part of any counted_by annotation patch, there needs to be discuss=
ion
> > > in the commit log about how it's been shown to be a safe annotation
> > > to make. e.g. in this case, if all allocations of "regions" have a
> > > corresponding "max" assignment, etc. If just "git grep" can't find th=
em
> > > all, using something like Coccinelle or CodeQL to search for struct
> > > memblock_type::regions assignments can work.
> >
> > How is anyone to know these things?  I can't find anything about this
> > in include/ or Documentation/ or in the relevant commits.
> >
> > There should be a comment at the __counted_by() definition site, please=
.
> >
> > And possibly write a Documentation/ file then change checkpatch to
> > direct people to that file if they add a counted_by?
>
> There is:
>
>   https://clang.llvm.org/docs/BoundsSafety.html
>
After feedback and more consideration, I think this patch was
premature. I'm going to shelve it until we can submit an improved
version and the compilers can release the feature. :-)

-bw

