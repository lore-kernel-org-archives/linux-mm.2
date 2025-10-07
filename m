Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42DFACCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 07:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89D728E000C; Tue,  7 Oct 2025 03:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875188E0005; Tue,  7 Oct 2025 03:15:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78B118E000C; Tue,  7 Oct 2025 03:15:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 66FA98E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:15:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 038C01A0815
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 07:15:53 +0000 (UTC)
X-FDA: 83970458628.02.7457768
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id 11609140017
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 07:15:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=211Bibk7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759821352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lEDZ0FsctXTT25PdUb7+D7imSwt4Fuc+97g/5BQFmmw=;
	b=8CHaX8s8Nn8cZIECLgpAPKj9suV2TRl8xKCR+o8RZUed7YkidK97XVlc/s4ruqlzE8Juw9
	D0R1I8RcL78SNgEEHVS9tIkE9fbQY9HsW6tgVGB4dR1LMgYv6D97t3vtFoQq2xQtETCRdH
	rsb6d09yXkvUsS29qiG24qoxjZ2qg8E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759821352; a=rsa-sha256;
	cv=none;
	b=s0HmDIzVN0W2Ffc1ZSH+WAvc12sD9tQyu/8/dEB1UwQ1QtPGiYif5TI2ExxuZ3XPcwQED9
	ORxqwtPSP7EGvL0vfpOpdkQAQBpupxFXyJ2kCI5dozSEmfe0hDIL3WEAgq1/gQispkQoUw
	7u1PnKo5wPHBeqLmBTZN6BXbNOLtmOI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=211Bibk7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=aliceryhl@google.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-46e2c3b6d4cso47339815e9.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 00:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759821350; x=1760426150; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lEDZ0FsctXTT25PdUb7+D7imSwt4Fuc+97g/5BQFmmw=;
        b=211Bibk7ffdPnMgtcSe6SibeGhMdlbb8lofatXdeU/i3objvIPB37IN/w1PvgKEZxx
         XldfWkkhrfWCDOCvPLK+YPaoVYRKEIC8CJc28v0YtvTMZQzsQcgFoqkzQEp6SzuNvi7F
         HyHtTLRBA4DO71dsiqhWYttetTQ+M9tEp7O1+m+D2WJFevneOGJBr8q0bbGbAgUr7Tvn
         RSO3tUst8ivU4m8uQizSolyNnwTxSW4oc9DhQAIi+5UjurcLElU5TIJQ0u7f+KKSbRhO
         uqbc45EbJNghAi98Yyh72iuOW/SWkViq5aeV96rcpNNKKPaeB7R1dRFvUXDV0VG1HGEd
         UiMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759821350; x=1760426150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lEDZ0FsctXTT25PdUb7+D7imSwt4Fuc+97g/5BQFmmw=;
        b=CguyOcj1UJETYBUQZxB0T+3zGHc5fDMsMc5YtQfrzlmA6F5f8y9tx/7Uh7II/XaQu3
         f99vzvhu95tw6oGFnOArd25f+JrcsvfvR807sjH1mwJg5am6pHSlvQ8McSHGmQCKE3QH
         +DXLzdtq5rQH3ZofkA4+Xz83NsOPnCJo4/2gVuIpFUQTab60EiTwTJUhssnhmklgBpcp
         6MhVziRh7+56mtoymmmftUshsyMf+yucDDTMFgFID4lJBfmoV7fBt7mDD57Y+Ru6C1HG
         FsQc2n3Gx9D2zhz/I3U0m3qbNtpT4ZWjMrXZn5MIBvqDKDaVgYT2Q2gEDrx6/nL7LG8k
         A3/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWLKhAWtCe5o2KOU5AEHz8rFPbGIJMWk4JINa59jvD8AFYXhm2OpF5UMS1XUGEjAA6c1klj6FGO3g==@kvack.org
X-Gm-Message-State: AOJu0Yxh4sr3TMnNBLwuCY0YmWYQd1NNHz+4fTj4DLVPrAU0n6ae5ohZ
	ah9eyG+kRu1XRhuilENWqTcA8MVQE5f1A/js846PLW1JNTIkRbnIOlXJIYISPkj+dzsiVi7WAiG
	xV0TL+2CtSweUq/WxHSMVW06qtffgnJedIJD9NQPL
X-Gm-Gg: ASbGncvpiIyDIf96reDqn02p13/DyNk0ZnqVo7a4zaKBY/wr3YFRBd7yBrtAJ5hpPkz
	i1EE1U8zHN+GBUBx1bP4wPgy6kzFMYKhMRgPIaX46VAxo1wYA6MZ1BxRnxU/r6HBd156D4aC9st
	8GzjeuIzjtw3UNV+qKCVndWPuistLXaPkLd8vFfIzj2LhaMFAMv9HWY4L7KnPRH0kcoNJ28yY+O
	hmfX0jv4xsN2Pju/GPQdl1uXTYo3o/nAX3niAXzHtGHQjLavyJFR2+zuKvFbVqHAkdKcLpCVHgB
	gw==
X-Google-Smtp-Source: AGHT+IHN82I6u9PV3m3T4AyeGxqQDcrMtP+2C7gcRrU3bk8X8rWbSiECp23jl+rfoqveFg745pQlgqV3AFCycsCdTp4=
X-Received: by 2002:a05:600c:1f8d:b0:46e:4581:6634 with SMTP id
 5b1f17b1804b1-46e7114684bmr95963215e9.29.1759821350287; Tue, 07 Oct 2025
 00:15:50 -0700 (PDT)
MIME-Version: 1.0
References: <202510030449.VfSaAjvd-lkp@intel.com> <20251002141925.ab86656b1d50f6e27f216209@linux-foundation.org>
 <CANiq72kOhRdGtQe2UVYmDLdbw6VNkiMtdFzkQizsfQV0gLY1Hg@mail.gmail.com>
 <20251002152753.c756678dfdcf739e2fbf74f7@linux-foundation.org>
 <CANiq72kWWPAZ3gq2ktMpVeMKpWOU1nAmYi-4d-BgbuDti77ggg@mail.gmail.com>
 <20251002154323.ca15e98421255ae2978e8d6b@linux-foundation.org>
 <cd2ea7d4-6b12-4933-b1ae-cd4db18d3671@nvidia.com> <20251007070611.GA88971@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com>
In-Reply-To: <20251007070611.GA88971@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 7 Oct 2025 09:15:37 +0200
X-Gm-Features: AS18NWAypYnO3FSMvWWPHzph4WyVFTzlcHH5O53Vehnkv-a0YVg6GpPRGHeldOA
Message-ID: <CAH5fLghTu-Zcm9e3Hy07nNtvB_-hRjojAWDoq-hhBYGE7LPEbQ@mail.gmail.com>
Subject: Re: [linux-next:master 13069/13300] error[E0425]: cannot find value
 `VM_MERGEABLE` in crate `bindings`
To: Jakub Acs <acsjakub@amazon.de>
Cc: John Hubbard <jhubbard@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, kernel test robot <lkp@intel.com>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: pa4fdwr1izbd4kp5nyrsxuwogkxbngix
X-Rspam-User: 
X-Rspamd-Queue-Id: 11609140017
X-HE-Tag: 1759821351-643077
X-HE-Meta: U2FsdGVkX1+7hrwYtq/k4p+kmsOcZmdBGGgtaWpR6Ogcnph3OD8VW2IfSLztIciw47cZyaP+WWKuFDGPe9uwNj3HkiHML2Vp40WYrgVRqg3h/QuvaYpsTHOQY+L3vuyxqNKQbS4P+eyY1G2aTp1TKGLrf/j61Jgx1jgC1ORMuCYqZ3qVvpjMQ7YSnAHvkuZKAgzYpJn5ZHbolfNUB7XwPAG4MNDH1yOs6UnmcEA1gErlnQ3gtZx18fmtcTloCujbAIdctFj6i5k8y2r+iQhdZ3JP15dwvbw3xZgIMGwLbSVhTufEn//0YL9lN9OVDqVvmm7EH2Z9ed/2POGVcM/Bamq1/5eDd8Nda84yK71Yz/TMQGUEf8Zx3/9tAdRh1RSZkLaudpbMiwOIdDnGGeIU16c2oAMZHMN/oDiY5d4XKAK8eCDMjDjQVg8qmihBnQ90oO/p0X3pIOvUJteldPy2yXOz+yr7wG+eVNGTjvQxEw2RlfILLBAeJQG8L3OW2YlnG791VFqeqSoKAEA1j9wdeVkHs6u0/F852yTtLsRSoWHJHzOLMsuz5xIcmfCwo/6IOnT121Cpl1GVsDYvgBPvFkXzilzm1gWl8wr9ONtUYTfkN6/liuiQ88q9FP66VjvvVkx86CrFfzSXDzIquc32b9/z0l8CVlRa9vo6XTftm+CGF7AA7sgmUmB3Q3rIuciSo5UMsJbqKlG/I6Jb0joGkAmhY5TLjrjMKPqOriS18dJrDwfgIxoa9hSMyhVbkhjGCPzQyjmAWu+1c0fnMneC4L9ws6Hou2nCMpknQIUZ1knPHM3GopHuR667jkDeR3QBWmGqgSQlEKZZNDz5uJSx6PYwwgVTUbtTMvzINUouNrh3iziwU3NUUdwbqyjeSM48/e9Y662efENNLoCFnboqQtHLtmOXp1i3HoTvCtTmAe0BizvhqH/sPUkWYW99BnmeZ4LCkXC9LmcfGf2rNGg
 Vopbwugg
 hf74+tmn+nQCTyGu9QffGENfWnEz1KGF1UYG3cQt9qJCrRMPVFSjTVlCQ4BBvefc4vNbXzmcnHCIMjaqgGWYAXUP4S7nsBwd5BJuQ4+UItBUXS2BqGzRkQke1wu2qRe/PlrezEX2r2qkQoO19O5QbY0g1xH5f2Y76nB9FaNanO07TDfkKVDkQuL92BYv4RIJ3DzW6iuzFrcZ704hbirsu/1zyi7KpjGpNYd6ljJzRI9y9SBy01ctCeWi7y/WpmZZftxq0PYNCo7WwOX1Cn55ejPwceqn8xaWifvETAV9/XdCO1XbpKs55kEMAUKokie9f1Xwc3hX0NSBZQktR6wuTtc89BVp0V/eKCFw+DF8+WtyeXeu5g3wVv2aPsYtDK1YP08QlCnH9mRY4Klza+JIsCKaaeiZJzXWU5s1hdDbP4ktRslzA5LpBBRdJIlIFN37NqKSOuUJ/uVGr2VZlB1tLmGsWDRhApivB6yt3Tf9h29pX8MoGymeHbW9Eu1K9Np8NK947u6F/GhzYKyQQ4wBF22MZQXb6NdFD7IejprvRzxnhFeaidoMq9n1u2i7NIjoItFDB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 7, 2025 at 9:07=E2=80=AFAM Jakub Acs <acsjakub@amazon.de> wrote=
:
>
> On Thu, Oct 02, 2025 at 05:24:48PM -0700, John Hubbard wrote:
> > On 10/2/25 3:43 PM, Andrew Morton wrote:
> > > On Fri, 3 Oct 2025 00:39:16 +0200 Miguel Ojeda <miguel.ojeda.sandonis=
@gmail.com> wrote:
> > >> On Fri, Oct 3, 2025 at 12:27=E2=80=AFAM Andrew Morton <akpm@linux-fo=
undation.org> wrote:
> > ...
> > > From: Andrew Morton <akpm@linux-foundation.org>
> > > Subject: mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix
> > > Date: Thu Oct  2 03:37:47 PM PDT 2025
> > >
> > > Rust bindgen wasn't able to handle the BIT() macro.  Add a helper (fr=
om
> > > Miguel) to fix this.
> > >
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Closes: https://lore.kernel.org/oe-kbuild-all/202510030449.VfSaAjvd-l=
kp@intel.com/
> > > Cc: Axel Rasmussen <axelrasmussen@google.com>
> > > Cc: Chengming Zhou <chengming.zhou@linux.dev>
> > > Cc: David Hildenbrand <david@redhat.com>
> > > Cc: Jakub Acs <acsjakub@amazon.de>
> > > Cc: Peter Xu <peterx@redhat.com>
> > > Cc: SeongJae Park <sj@kernel.org>
> > > Cc: Xu Xin <xu.xin16@zte.com.cn>
> > > Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> > > Cc: Alice Ryhl <aliceryhl@google.com>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > ---
> > >
> > >  rust/bindings/bindings_helper.h |    1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > --- a/rust/bindings/bindings_helper.h~mm-ksm-fix-flag-dropping-behavi=
or-in-ksm_madvise-fix
> > > +++ a/rust/bindings/bindings_helper.h
> > > @@ -99,3 +99,4 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRE
> > >
> > >  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC =3D XA_FLAGS_ALLOC;
> > >  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 =3D XA_FLAGS_ALLOC1;
> > > +const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE =3D VM_MERGEABLE;
> > > _
> >
> > Yes, this fixes the build on my system too, so:
> >
> > Tested-by: John Hubbard <jhubbard@nvidia.com>
> >
> > ...of course, we'll have to undo this later, as part of the fix
> > for the Rust for Linux build system, to handle BIT() and similar
> > macros in bindgen.
> >
>
> Hi,
>
> sorry for the issues this has caused. We're also changing the other
> defines to BIT() for consistency, it was applied to mm-new in [1]. I
> assume this will have the same breaking effect. Not sure what is the
> solution - whether to wait for the fix mentioned by John or add similar
> defintions to a/rust/bindings/bindings_helper.h for all consts?
>
> [1]: https://lore.kernel.org/all/20251002202112.C2293C4CEF4@smtp.kernel.o=
rg/

You have two options: either add all of the constants to
bindings_helper.h, or use an enum similar to commit 3634783be125
("binder: use enum for binder ioctls").

Regarding John's mention, don't expect that for a while. It requires
support in bindgen, which is shipped by your distribution, not Linux.
Therefore, it takes time for improvements to become available to
everyone.

Alice

