Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E72851061B32
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 11:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28B4A6B0088; Tue, 31 Mar 2026 07:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263776B0096; Tue, 31 Mar 2026 07:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1790D6B0098; Tue, 31 Mar 2026 07:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0712C6B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:32:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D040140D2B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:32:20 +0000 (UTC)
X-FDA: 84606144840.08.4D7B4D4
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8EA8940005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:32:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N0eXonQg;
	spf=pass (imf04.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774956738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M67a/b1x6rgEx0jm9LICh8Vkeoo3mKrczTQasuX51XQ=;
	b=WFyz5gOsEyN4P80QohnTpVezgc9RzPbGoimADOSPCFYf/5eJR+rAadxMXsEJ8EfQmnb7Sp
	+aS6ExQQTom95Q70sn289bOvJvBcmgifhsZvoB+pfDcGhrtxe3TuNZXjf6Nn6390udOknU
	z2nnPSDAehfhuZfajAyPwM5irrnSl+s=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N0eXonQg;
	spf=pass (imf04.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774956738; a=rsa-sha256;
	cv=pass;
	b=Gw+qfdPr48Rn4s9+DO+2LRokn3nPfV1VUae+qtPPITPlzl0jUngo709zkcPfDtKVj5FO5Y
	V6p0YL+NnXACZuCOmzRXwcR4mObfti1Jdf4bBCpfy1yYozEeGw2V3l2NjsHemVLOCUYaP7
	n/BtFZqZP3h9xncVDIj75SG+H3BXE2M=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-486507134e4so64156585e9.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:32:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774956737; cv=none;
        d=google.com; s=arc-20240605;
        b=Dp6XIriEAzw2t7NY27yav/ex9O36SGyqpNPvEYpOHzVgMF1Cy5oTFMKCp4k461bjMe
         2nqBd9doSuqPFWt8aeDncJsO7QqnU4S9vIIglX7rBdZqU3GCKSiObj6R8H1f90AR/lTF
         vcJA+CV4D2TUi9FAistsHI9ulNzipCiiOwYFDlgU7RLQs/Vg8Eks7G6xgSJNZoNA5bft
         BBk63HR/VXm3/EtVJoXI13Qiwi82i79kDUf9AH/iYPBhOLPT4wxifhsTmQESRbkQ7qra
         T4ti1mUQsha4nXzCcFOKCw0noRejQ61606O7t9LAQ/lXq12TAD5kpBCKYrtgz2V02KsN
         5mHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M67a/b1x6rgEx0jm9LICh8Vkeoo3mKrczTQasuX51XQ=;
        fh=3+swT1JSALmDsysfdFJVqdl1wubxI27VTySYRPO1FVM=;
        b=W4u6RuXmfHDK+5/Y1UGGMNWvkyklFyS+2ZqZc7YYURoaEx3pgO8c8/4LeW7+ml3wTJ
         oYXpth3v/evITZ70c1t9EZMqfCrXlZFUXG/CxKINqa0Ah/0SjQSCj91nBfPJ14A5f/nh
         RiUUY31WAbifo4AmUw1W9MWIdzAUL4Q2132xXXpW6yExL9XjN6NusMULV+E287z5GkGL
         eJ2xgaA5WGBghpuzBUQEGfLz7G0AOI03jbXqDVgjfj6rceRTUJWcA1vmvaHbCBLIHiWc
         Y+5A9BDAhG4H4cWopE/sUvuldRN7cOnB16czsEamambPbbrEGsppWE0HyEbkVIyEKrL1
         Fw5g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774956737; x=1775561537; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M67a/b1x6rgEx0jm9LICh8Vkeoo3mKrczTQasuX51XQ=;
        b=N0eXonQgaR9H6BDzrT3i7HAl+/GutpJzf5GIn8J7JiPJUpRTjvrt0I9WkBNTID3pDk
         Gx/M1HH2ut7dyxz/FqlZOck1kR1bwtCaA77PDUGspx5yMrwck1O/N9z/jPdlAB6BJO18
         p1+IzB20fkGHM/pnxupWRt4Zn5co5eA39xNmntLeBEpFfihbpmSPA+eHige9aXOhrsqq
         OHzBOs1dnqdArSSTorryL1aVMgsu1FPkobkFubpBmLbhPenDVF2pZQUA0GT2k3O/4/kT
         DJjcvstsWptqGMy4Wm3UtYE7/BEoAdFLjJ6z7/9A5em6AXvdzeuIToQ+rbh0SRoN88fG
         PhiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774956737; x=1775561537;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M67a/b1x6rgEx0jm9LICh8Vkeoo3mKrczTQasuX51XQ=;
        b=Odd81zO/ty68qd6qO3ELyRFqu14Z/nggQWhJJeBOlbmJewbKc8oOjY91dRMIkeI1k6
         Eb2coRcIhix23WUmzGriEVmZAYp7W/7jeXoqIE+PbyOphaIXcLQmfRs0ue7uO7WZufn7
         y6FiS2SLldbwIrwJ1OjbLRlCrDYQi70n+KRArxgsZVhHOrCAhtjcrdDiXQR03lbSdaZA
         s0lH9MoPisI27KtTsT57h46jSFNhz7xSwzd0S/3L9ZH8VPeETnr56t7wN0RBNDh5tAOc
         uXVNm0G65yuQxHnTALTKQEZzcZr1FPEaDTNaBFh4R2H886bHHAn/PvoULGg4tGRkO3r6
         bEew==
X-Forwarded-Encrypted: i=1; AJvYcCVE2VZhXKo8WEVug/13qlLtQ/oCUR7g6WW3BXmUVbk8STRLNG3pcOrvEBd5mGrrZVSicIMNpLKYWQ==@kvack.org
X-Gm-Message-State: AOJu0YxSlY6YnYY+X3eJmAlLJSR9rMYkRyBuf4s5BbunENGPeetYhgmg
	hTphGJtZh7sbwAyXxYoDdNuBNKwLFbjRC6iatr3Sq+3qYcK7otY6u63m/l0+SMniMbtYbcqmWBk
	UG7y/ma8vt+2ge/tYj4/bW0R5WpdyFpGZo2KdZBWO
X-Gm-Gg: ATEYQzwjLknreNfpE0TKl3CXlM+Aha+fX2yaSQ+G9HgVWmGjzSIgdkYbp0qLwCBotNW
	zxM+P+VITKcMhjGcDa4FEccD838s7dKPYaHBXToOBrC8Wtf/nmthTsVuy4D3MpEECKeVeKoAVkA
	ZQQiJNOnpiLSp+sc6jxkPUoTkX65zIHVeOZ7mfg3KOtRrqTUmG8mWQHdiB9BZf85US2HJ122Mqy
	sJpe6LhlwIE3233RkKt6r4wPyOL4mf6DfNXMcbKg1UzrSgAC0WWl+PB6DAVAYB4wv+wT5jIQRGA
	la2WwU0e/6Tuy1GlVf1J39fQD3xTIiYVi+B8DQ==
X-Received: by 2002:a05:600c:638d:b0:477:76bf:e1fb with SMTP id
 5b1f17b1804b1-48727efadcamr273504385e9.16.1774956736497; Tue, 31 Mar 2026
 04:32:16 -0700 (PDT)
MIME-Version: 1.0
References: <202603121235.tpnRxFKO-lkp@intel.com> <20260313213638.GA147391@ax162>
 <CANiq72mzEzjNg7O_2dWT_6QOJvJ3TwV+HyxNd_F4j6v9C+pc7A@mail.gmail.com>
 <2026031422-catsup-rectal-f886@gregkh> <CAH5fLgixE9MGXxNEnU5b0EXdgLQoTs5CMv_0OdnfCX3v=coUpw@mail.gmail.com>
 <abVG0JypVhDxx1Tt@google.com> <2026031444-wriggle-tradition-245f@gregkh>
In-Reply-To: <2026031444-wriggle-tradition-245f@gregkh>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 31 Mar 2026 13:32:03 +0200
X-Gm-Features: AQROBzCQEjffcE5il2ENOqxKPlkZVapSxJMQJFQeH4ua_CsBeZl83tkO6WEAH3c
Message-ID: <CAH5fLggMZM3kYWO3xqb4o-mQG27aCYOmiiODW67CKLTstkB-PQ@mail.gmail.com>
Subject: Re: [linux-next:master 5585/5731] error[E0277]: `*const
 kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, kernel test robot <lkp@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, Mark Brown <broonie@kernel.org>, rust-for-linux@vger.kernel.org, 
	Miguel Ojeda <ojeda@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jann Horn <jannh@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 8EA8940005
X-Stat-Signature: jd4fbsqtfn8ii3o9hdn7kgfyctkgj9jh
X-Rspamd-Server: rspam06
X-HE-Tag: 1774956738-788633
X-HE-Meta: U2FsdGVkX1+/ojNd8+/5B2l7G3u3yGL0BERmbE4JlFQDc0MvqMapQ5MCbOXkIB107FXzmO16cyOPBVuUZgkPVpX87cUajiZ5n5HInII6U1Co/n+FKg4XJ0gzC5+4hMYWTxyNVnR00L0CvyTrJoBDEm7CtQNuYrot2grkm1DlI2LA5lZZsQw8AZNDvnmapATxNbNGvJdY89HjEIhZjP4UZgOIpUJ8xDbQzJcEDVQ7+bwwS8Ca1d0kFYqtrk0BHQtCMYIkuXCRKACRVV/Sz/XI2rReeqa9t4aGYzpzwfCr/W/ymiavHqQ6nxW/WWtStpl/JaSbmwBV6z1IZM6BqRI51Mn6SpBwzumgqTeLtJHiGDQjmQUXSOTKxCewxW9fR9Wmwa0kVtiU+IHMjVHpap+TRO83V5jRWBquGJMJQn4sAfD3QATzd8ISwLyXbdt5T2VrGhCQwFmiFFJhEBIG+q+uny3jQMHhXs/LBeraoQa2pXCBSlYw8AC1hUSD3KRs1TPDYHFlqZT9n/eHkUoEsYOYEijGpN/maK+KP4jeTBOlHvvOWyZMVFz4D4zMrSCBacw4ePeR4LopHlX7d7DT2whIqpX3PwnDwWiWIGDSVoMG6oIzyDPCDbDH8jmnL32SYSdu8qPKAN+5NS/zIBWRXayryNZ7CjzRgoct0vtKf+WVU/VSh+aedZgUnsEWgk9GJ34VxOUGxMJymkfFSeKPPXw4bX9ukbH620bxly0IOoJZdVELSGKoDApf7yGyuGb2WL2CpXtz1StSBu/01pmxPl3bDuy2OB53lSXgnSCzxG+VtpIoY6/jKiEJt9vcVWQf+ONuKIKj/sPm9dHgUg8lU4aH5wMlrWZVKC83x8p5rMeuEJuaWIEuuIh1RUlJb1P4dslzFxzgrE21r7Yye9UD/WABK2Lb9YxOYr3651Sl3A3JN2UAW3kCaK9uRlz4KCfYtcnZqcPhBu3r9Yj3y4zMazp
 iAZbYreg
 PT+MOTJaZ/DgTFrKpRnSHbjUqfiLlGyWbMMIi/XRYsl8Mgz16z85pljDh+4QddOvvDdR+gQmb1unUXrswvqjBxyWepOSNYtA1TPcu7qWnHegWz6C0VojzgGAQqVa/Y4f69dQAg6E22nK4zmm5a7gBX8c9aauQTHvVhWXtn8rXg6NhJh7sBDCxEgGGlnKKK9S+t4lQw74VgNLzd8LgVQ8jct9usAAXojd2bOx+2GoQp+x1CNUfj1PTymSanXdXe2JFnSbIh6aIwO/CAFNGeS/zbAYVNPlScJUzUn9tXYd6pbqMhoAyYt1ZPX2RdHasxNbWI6iBu6uthHnG6jd5zfFruBkGbCSvZCFqW/nV4jI/4LyIvh3N1hZc0EglPJa/pn6h1xEOe9RetEBNS5L82nzxRAWj7uhdOPpMnx3DsfBObS9mKOsdW1lvkghMIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 14, 2026 at 12:53=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sat, Mar 14, 2026 at 11:30:24AM +0000, Alice Ryhl wrote:
> > On Sat, Mar 14, 2026 at 12:15:30PM +0100, Alice Ryhl wrote:
> > > On Sat, Mar 14, 2026 at 12:13=E2=80=AFPM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Fri, Mar 13, 2026 at 11:39:14PM +0100, Miguel Ojeda wrote:
> > > > > On Fri, Mar 13, 2026 at 10:36=E2=80=AFPM Nathan Chancellor <natha=
n@kernel.org> wrote:
> > > > > >
> > > > > > It looks like this is a conflict between Alice's "rust_binder: =
check ownership
> > > > > > before using vma" [1] (currently in char-misc-linus [2]) and Mi=
ke's
> > > > > > "userfaultfd: introduce vm_uffd_ops" [3] (currently in mm-unsta=
ble [4]),
> > > > > > hence why it was bisected to the -next merge commit.
> > > > >
> > > > > Thanks Nathan, yeah, adding a raw pointer (not function pointer) =
to
> > > > > the struct makes the type `!Sync` in Rust.
> > > > >
> > > > > I assume this is best handled with a patch on top of char-misc-li=
nus.
> > > > > Perhaps creating a wrapper to assert it is `Sync`, since the
> > > > > `BINDER_VM_OPS` contents are unused (so far).
> > > > >
> > > > > Cc'ing more folks related to the commit.
> > > >
> > > > char-misc-linus should get merged into Linus's tree "soon" and then=
 we
> > > > can fix up the mm-unstable change for this.
> > >
> > > I'm working on the fix as we speak. It would be ideal if it went into
> > > char-misc-linus, because the commit that is wrong is mine, not the on=
e
> > > in mm.
> >
> > To clarify, to avoid breaking bisection, the commit needs to land
> > somewhere that is on top of commit 8ef2c15aeae0 ("rust_binder: check
> > ownership before using vma"), and before the mm commit. But I guess
> > there are several options for how to do that other than landing it
> > through char-misc-linus right now.
>
> I've sent off a pull request for the char-misc-linus branch now, and
> after -rc4 is out I'll queue this up on top of that to get merged for
> -rc5 to make this all work out ok.

Friendly ping on this. I don't see this applied yet.

Alice

