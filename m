Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AE4F105D986
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 22:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 508EC6B0088; Tue,  7 Apr 2026 18:05:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B98A6B0089; Tue,  7 Apr 2026 18:05:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A84C6B008A; Tue,  7 Apr 2026 18:05:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 27A7F6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 18:05:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D60AC22AA
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:05:36 +0000 (UTC)
X-FDA: 84633142272.19.23235C9
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 708821C0003
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:05:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gkpYz6zM;
	spf=pass (imf20.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775599534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MG6irsax2dWjsgBAdF5tVJt+HiAYcnDKOtc9l26Py+M=;
	b=hYMnK/RijSqHsNthMGm/jGoffzYrrgf18hDDyalaLU20NlmyIljefcvMom0dTDLqrAQZ3j
	ihO9a3Y8SSQWaJcbIsCTqY4NYqPJx9TIFPowBPW3KhJ3jd2GfxTtz5WrXEZheqA1t0cohc
	XTBsX25tQEYz23mACuVcDbWICPbVJtI=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gkpYz6zM;
	spf=pass (imf20.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775599534; a=rsa-sha256;
	cv=pass;
	b=vjY98hYAvP+x0l8kjmk8c7wVIhvK3+PUO6q0oDBq/bOej54uvBd2X+DooOIeM/iag06XmG
	9yhbra31pxjdwevscrVK0hVhMrLX1dkwjxINQ+ochr2yO2Gh75M2v16RuQMBpEGSb8hhEj
	RNv+It1/IRxSrpv95/hIbaVW3YYeiOI=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43cfce3a195so3423514f8f.2
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 15:05:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775599533; cv=none;
        d=google.com; s=arc-20240605;
        b=Ybzdul9yJ7wSrP3FxCMEJ0VpH+ftE4jfS6/iRTQSnmy3zePGXDJChflKC3cPbgjQlj
         O/8Xd4RWtoCqyGYyvdYu1enZMHejs9J/V6JsJ2SFDVJjFR/RdCol3XBf2pqlKMPEEUtq
         05jbIKVDxEYfG7WE4b9KdpiocK5a1HzSUNgVGnx5q9k7UzlCSsUwOXxMwmC07zVnPsYe
         Ad0L4AM9DtgchP8iqohW93kgxdTvoZ4TqFdaKWfWOv0q0E/9d/Afh8oiAAKyozNfFktj
         bWAZ5Ol9R0ayS2NCTDr+aG59g6UpHGr3x62QfLb85Sau09K8TU/9fEbWY8/bj4J0Uvfi
         BnjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MG6irsax2dWjsgBAdF5tVJt+HiAYcnDKOtc9l26Py+M=;
        fh=gan0u/KFm735/4j8VvdjF9eUmX/U+5lbSxrrYN7Agao=;
        b=UPfMLkpn7B30/6CrjPcuyU7UFcF2D580BiawMHsRkiYQrMPdijlQCdjvDw+Xlew/m5
         1RdJ6We8kbE/QUZnttCL/A2YgdwQMS0tn5TSwyg6P75VyaTU34BFlK9gyVkzXqZRDA4W
         2k9UbEsM12h4yCQBsMlNDrKML799JXdw133TOf42OFMtSCQNTH3WCbOY16ArvdbC4du2
         UPERCVC/78ynJXwO13b6A2HsSUQG5SxyIM0vS+wlZHp3JFtUlfWI48mvGtRKXLYPLaJO
         aCz8ZSUqG5bptE61cigOyIkhB15gj3jtPS5hJ3ONHqpEywTVVPxwpNcwyEgU+Bvg/DE4
         +i9Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775599533; x=1776204333; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MG6irsax2dWjsgBAdF5tVJt+HiAYcnDKOtc9l26Py+M=;
        b=gkpYz6zM2m0qyel2+NRqxwb2niRTptiNyzd8locs+avVkDGoJWcHfvgDR50UiJrSs+
         Rddpwpo6S7XDk6oLO5qWc5fOxIPfFOC4TObYmLlzRNKk00aIe81wyJullbNw26A7iPJg
         1WrbuPbyqqhQvK1hpM1ajznIuvy/hxfDMX0l5NYa8j+UQk8u2yDoU8VCVoJEHOY+hU5+
         TBZFAeRhIchJ/jgQQcJcoWzpnM1osEd3tH1JNTclwWh7S9q1pE5PCxGEJgl3349C2OQF
         SGA/K0vSRvzj4tvMrJFHNR4070nGrrGmumY3hSoxKzNl5wJhBKVpbEztcWttnaX8IZCZ
         eVKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775599533; x=1776204333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MG6irsax2dWjsgBAdF5tVJt+HiAYcnDKOtc9l26Py+M=;
        b=QwgxCbuLbBUkh0EmZPqP7VjA6cYGMACUJQr2/B5mqsXQOheVa7e9vnmWYc7L0jDDsm
         YH7LunxbNrCwFpFwWGiYTKXSqNn1BGvX97j4xiGBmw/fz19sCkt/t5blwfLv8+z13Z7+
         jaBqIBrXLWs3H9Pg+8rVE3s9Kb98Yyt6xJgh/GhaSm7db0h453S7RIVeDFvS026AntLs
         uhvXh43ik9cgXn3PGmSYDHAxDNcKtZA7eiiQj4yRYTZKF8F60jGWaHnpCVh+uwUHHj9M
         DdlXbnITcZiLuYl+42jkMCmfPI8gkqdBCd6W0/6fQR4pZsXJ0NwDO7UkCqn81A5092WT
         /7RQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPURN1m0GAjoJuvFdxJW/K5yn6TY3VoP/1zDcYIwrjy8uMuhldQXEXSgZpqYG+04i1GF1ljHdnyQ==@kvack.org
X-Gm-Message-State: AOJu0YzclXHo6kRH9zIRyjM2lBnfEwE0Noep8QbO3+5/ilb/DRxSpsJu
	PFTD4p+I0Amv5ETicJZP7v87CmnqP8fMoW5S1eSY/bXUvpVy65gr/i3nwdjF6r1mJdzePvqq2HF
	/QR4PITJG5oFJ4mBCH1Mw9OSReKP3y3riJPmfQjyQ
X-Gm-Gg: AeBDiesc0OivZlA/QPM2hCWtLXuHvn2fWsIw9YSzQwLP9FVos/R73B00BcC3JeYpsMx
	fN4FLexu1JAi8Sq5Cd6Fqs/TsooPHsxytHBjOsOHPaWsjwjNY6Cd4YEKFV8iCaYYNqhv6e+O7Kv
	jLH9d5wSKYZiKGMVTaZzD8YNovBQabz1etR8rDuck5SfAoAiwFxfFTMp/wd1gP06mb5lokK/NZg
	AfW8QuWT+8r3k92avKv7DF5kpCiKGeTRnuopICNQAtTUcjkwys1uyTp0aVYHMrIBsNuVZWSPa0Q
	ojVnA931rg0dkYYypiZORr6KXBwfzl/VzMWPMF+8vf4LDEfp
X-Received: by 2002:a05:6000:22c8:b0:439:a95b:3c43 with SMTP id
 ffacd0b85a97d-43d292c6b32mr27982031f8f.21.1775599532335; Tue, 07 Apr 2026
 15:05:32 -0700 (PDT)
MIME-Version: 1.0
References: <202604071509.y5vLetYd-lkp@intel.com> <20260407145902.057044dc19e7313b21418ff4@linux-foundation.org>
In-Reply-To: <20260407145902.057044dc19e7313b21418ff4@linux-foundation.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 8 Apr 2026 00:05:20 +0200
X-Gm-Features: AQROBzBS8AAmv7_Gd4m6Vdm8r3Fj8wyDr1G_Q3blKHwyOYaH046KJHSKTcfAdPg
Message-ID: <CAH5fLgjuFLXRgiHD27ErSRgxu7-uzqjf8z3H9Bj0=xKSaCHW_Q@mail.gmail.com>
Subject: Re: [akpm-mm:mm-unstable 113/133] error[E0277]: `*const
 kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, Miguel Ojeda <ojeda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 708821C0003
X-Stat-Signature: i7om4coinugpecc9uuons4i7fpncdgu4
X-Rspam-User: 
X-HE-Tag: 1775599534-443253
X-HE-Meta: U2FsdGVkX1/jMKP33TnfcPglNByjqXw/dzSXiyjn/ZY/LOfqTXOQl1NMt9Bsx5b4xWJX8UdRRcHw1++x1dA8iKNxzl4ohT+gWGal+OMXMq0QXnvx2WUXpH/j2JXZdKvynBvwiHkXjO8DKoiWctz9HzXLSx4TI0S1diV3HaKHiedAD3bKoydLa7QhVCvpnrIHMCdlAws+WBKYqPTV6DvqQeLrXD4NuviXZOn66ITP0qh3w9wX0/pqfdbh3aK3hC03TnJhw8i5tybEMAdRej+D5VuUtQCQS2p9MoujCGJ8+nwhwSdUXo40Yxf8OSrpn6+klPzDjyJGr1c8PHMqmmZzTu0fihfNAaY/GX6wxQCkDJ9hArg2uIfv0aAA9C7wwZMgux9Sq3msxt8bxULaZEBeY0/c3gFiNuqd8RhzzMuTbjeLxlqkgKvrBNOQuXz+HJ3vGZE4miSOFcRBQf0NPQUyOm0isRvLrFavhZWkN+KK8zeku88SjVGIKdksdctiy/6a0r5zvT/5RpZXMX6LtpiZuxO7Iwu1cF0c5a0bTz+w4aAu/sJbLxMeBm/hHJ7wugSfapVCwsef7mmsI6+DebVYJenDQptCV7XvVQeknzHsolihEgcACcugb0TunhUU+7H66C/rQzGstgh7ecWQ0Q5i1GqAoCGBtpVzqNZMwMuy7TsSa++jlZmjjrmBR7P+1aMs7Mppn8qEXU7gy9o5K+j6+2Rzzh5Hh2hJy00SC2hP5lzd+Ax+KrcOjcz7ifz0kWi2XsO3dmI6ukeC+arVOjaIXYMDlaepkavcHDrSMwqlHgAKEvE5jEF8eh6kXIUCHgUI+a4Ucw9AnosrVJvOs4m/d0qYu+AaKWl5JxfprabEUW0xCFuaktoCKWbBIkl2mNJ3qYhglo6o923wqmkeTQU/RKB45cU8G1OHJYZpahDL/3rcsQE7qz0uJHQdKFhrE3ak/OW7PqLCASF1muS7i3C
 RRutIJdD
 wL53wx2hHJ9Y1eihvPE3T5jZ9X70mcqMJeSFyli/tl4wgrBWJ30ptgci3xu1qKBA9z8vsPRPHwaWPGZpGsNtHqKfm0g1LnhvAZ104mHMX5Xq+3YCxyckHVRTzaNV8H0lLYkFeqZBJjOdWHhVbUB9Xw1Yndk4BbbE8xVFWjIahMSmt6zL0n9WOucLAwWe0MGlZ+QeYn12fiqsnJFyuQaw6uG7Q9epq1EPeMpNvBQD4KCAIZXsI59SRsHtgbXnK6bKuqpTsQHrhBJ5STNe1qUX5QYJ1x02RNll53Z/RndcPWYxRN9svOkBvseOknKTqYb3mdSA4tK4/jMM/kxXF2w5NdXxyUBm+avj8I05Fb7rDkF9ee5nUz4pCfogav0c116+CsFTKgwkJykGDFARseMO+8h6YDGHT/6H2GVispjMDy1RqIqBt6lzS1R0Ab0f/G1Chezb1LbJLbaJBN3iPHWajHMPcxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 7, 2026 at 11:59=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 07 Apr 2026 15:58:09 +0800 kernel test robot <lkp@intel.com> wrot=
e:
>
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-=
unstable
> > head:   3fa44141e0bbd5062f2ef0c5cdddd98275d3223e
> > commit: 694fc0bd3ca5420f4e1105d2dec02327cfc5d64b [113/133] userfaultfd:=
 introduce vm_uffd_ops
> > config: x86_64-randconfig-074-20260407 (https://download.01.org/0day-ci=
/archive/20260407/202604071509.y5vLetYd-lkp@intel.com/config)
> > compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87=
f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> > rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20260407/202604071509.y5vLetYd-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202604071509.y5vLetYd-l=
kp@intel.com/
>
> Various forms of "userfaultfd: introduce vm_uffd_ops" have been in
> mm.git since March 6.  Thanks (much), but is it possible to get more
> timely notifications?
>
> > All errors (new ones prefixed by >>):
> >
> > >> error[E0277]: `*const kernel::bindings::vm_uffd_ops` cannot be share=
d between threads safely
> >    --> drivers/android/binder/page_range.rs:146:23
> >    |
> >    146   | static BINDER_VM_OPS: bindings::vm_operations_struct =3D pin=
_init::zeroed();
> >    |                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `*const kerne=
l::bindings::vm_uffd_ops` cannot be shared between threads safely
> >    |
> >    =3D help: within `kernel::bindings::vm_operations_struct`, the trait=
 `Sync` is not implemented for `*const kernel::bindings::vm_uffd_ops`
> >    note: required because it appears within the type `kernel::bindings:=
:vm_operations_struct`
> >    --> rust/bindings/bindings_generated.rs:74703:12
> >    |
> >    74703 | pub struct vm_operations_struct {
> >    |            ^^^^^^^^^^^^^^^^^^^^
> >    =3D note: shared static variables must have a type that implements `=
Sync`
>
> We've seen this one before.  Sorry, I'm (still) not set up for
> build-testing rusty things and I suspect I'm not the only one.
>
> Alice, Miguel: please can you help us here?

Hi Andrew,

I introduced this bug in commit 8ef2c15aeae0 ("rust_binder: check
ownership before using vma") and fixed it again in commit ec327abae5ed
("rust_binder: use AssertSync for BINDER_VM_OPS"). This means that the
bug is present from v7.0-rc4 and was fixed as of v7.0-rc7. To avoid
this build failure, the "userfaultfd: introduce vm_uffd_ops" commit
must either be on top of v7.0-rc7, or it must be on a base that does
not include v7.0-rc4.

Alice

