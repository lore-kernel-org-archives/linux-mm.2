Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5463910706CF
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 11:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF426B0088; Sat, 14 Mar 2026 07:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89D2A6B0089; Sat, 14 Mar 2026 07:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77E7C6B008A; Sat, 14 Mar 2026 07:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 653896B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 07:58:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A3ECBB64A
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:58:33 +0000 (UTC)
X-FDA: 84544521306.12.9420D1B
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id 180F314000E
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:58:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=F+WRPiN7;
	spf=pass (imf09.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773489510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tDUhjLbO8rNxXQmgp1rHTtbqYnNDwW9KMFRsKCA0ywM=;
	b=sYChusoMWLVGlto7WZQCfNkMdBXXAKUNqLp4p8I8FCVFJD4+BlKGmWmi9tw586akO1VodK
	2KFbD4cJoCtwrZFuC1hU6BYkotvnxH4iaM31Djc8hmFB87U+QmEpDWs0nEv8uHErNtFlp2
	z8Vhgz1xqkDbBs2gvDxrI3ioO4Py9O8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773489510; a=rsa-sha256;
	cv=pass;
	b=wqN8pHO3/FcIy+VzxwSg/t0Vm5wuDlyvYhd1+UhhlpsI2IshldBf7gB6GzXFXjLjfX7xbg
	YgrgcxobzxHnlk9XVSXcnqdMeh3YZeZeDR+JZHRl3ZmALJQEeuR591jJ9004HoHrLy7UPN
	oGzmkszaTp+cwsocXkIYvUZMULaIHEE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=F+WRPiN7;
	spf=pass (imf09.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-439b97a8a8cso3166536f8f.1
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 04:58:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773489508; cv=none;
        d=google.com; s=arc-20240605;
        b=dql1inLidHaT8WOCG8mjukh7d4dtjd9HxvlZVsjvh7CxthbMo28HZ7adNj39XjlvwW
         c/IIX3DI7/I4lfud5/jRJKATM9EKUhb51P+U/DY7eYfrNlh2cGrZCAv9mTF5YBF42P5e
         2/mC0dyLcljpVP8JRKc9nVJrEs94P5RnM6zfcvvem9W6/01SqQQhfA56xpIX/AZbS1Dj
         kUHxwyog2LZvOVnfSCrdyKPJng7he59tkLCvXDd3jMAnqH5zbS7IsadSZXK7DXkjR0tI
         lcr8VCY8zWaLmaYD7ns/rQyrFUUWEX/F+lTk4GNWy9D9NExYsjPtSR/L2yK4PSXMnxI8
         k1pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tDUhjLbO8rNxXQmgp1rHTtbqYnNDwW9KMFRsKCA0ywM=;
        fh=IF+EkhMd6sMzR+j5Se5k9ZAdqGM+XGdsCO7gwOXVqy8=;
        b=R6aJE5SA535YvBUcu1AUrPAVVE2uNRtAeCOfeV5UXGUHnfKikZ5Z7tQzSqA/bc/W48
         EvjPiWitVckv4Mhaj+CzQ1MJKaP5Sn2esuOZa+xudBjCec7DJqH7Mc4iQvIzvKTbbrBg
         cn1mgGdaK0dF3p2eVaOwL99BHVgRLefbTTDFi6DTio+o5m5mludMj3VnjuenYw72f1Ji
         HRk1dYAFxQ702Do655k986x+Wlhybz8buARkI2gjdHtvLSSkv5uhizK1nFdPSvDmT7Jq
         nUyfIcwHGf9TL4AvoFp70hPxKZ/BjgzEtfqyld38BNS3w6bOn100TcwIjC3AIinLXdy4
         x1uA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773489508; x=1774094308; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tDUhjLbO8rNxXQmgp1rHTtbqYnNDwW9KMFRsKCA0ywM=;
        b=F+WRPiN7DBVfP0kfUMCauaFleZD15y/wpRA3LN9Pmk57PFOVRIMFIZbpzKuXHvLnOw
         9sWtsW1Yl/c9PEJCed0JYmI0FWLevNEvUAq5mY91hL+d1ahBpyevERyl5H35Kpw4iD2D
         uTaCM+6TTqWyc5V1gMZ0VtKtCFbseu9dxCMMUtxuupUY0E7/s16WfcZW9P9TdAmBtdwN
         5tUklNikF+HLbfHY/4rhxEPy+5OU717IDpa7a8+n0DdWDA9qhRKcuYDtBvE3Euttw67A
         o2BnzNiuKVwT+3F1KUuTYH3q4V8FRML7qvdGxbGkmNmV5cUoVlADXwOBHxH5zEmfOitJ
         GSUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773489508; x=1774094308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tDUhjLbO8rNxXQmgp1rHTtbqYnNDwW9KMFRsKCA0ywM=;
        b=EdMh6qw4ApVe4d7jE4BZNZn3fAnKogxx6rT7+Xlztal0usQthGqL73fEJQNNU67Jln
         22Tqc5BtCyLzHSuApEbX4miMZ9Q4JXl1KkJcdCuV95f5x5WUbljoNsVGxY6LbwUzTqUQ
         EaMBlUWVNroTiBnuhmf059Fqn9IAnyzcGR3npph+IDis94ZwtK++r2dRQB4mRKJf8jR7
         IcF0/snkFhlqeAAzNCvN2oVf6dwODYnKu8MHokmxSCNqksvPVWyzbyAsiSTwvOnk7KQ7
         88NGMBaoOmJQ0dLS0fPCUPSWFOSAhA1RItcn1A79HR3/Ale6wnLcOHMoNH1ksk+d6cjq
         OJKg==
X-Forwarded-Encrypted: i=1; AJvYcCW1wdUjzrOA2kuaekJtj6YUqoaXG+gNa6JPGxWVr7YPwQpdWbHMaFJ+Wk2UBvs7GAY3c/18V8Uc0g==@kvack.org
X-Gm-Message-State: AOJu0YwWU1h6AwXtq/xytrJawqP1urAkci3LeEzmT+W5JBqdpnt9XuHx
	Mw651Y1bVPiyu8cyFNpdlw3oaX3vlZbAAy8uDxRk7eKCgWIS9QctecnZnjt2/uThCzowBTwtq94
	uTLumvMME7tf28bXH8JyHvp4Hn8jev/BRwITx+grRTvxOqXTx01XV64c4
X-Gm-Gg: ATEYQzygCd6lIq5dP1N394WzXMR9BsFZfeVtrysYBmb4Z9yjGUmVkQBQjlgd96BdTmH
	qOta52wZRH4DFsM1w1fQxlg9wwZ0E+W8OYo4NxzQ6+c1gSX0Y7uAyhxoHw/KAoVMQfOJLcMu0CC
	8N4UUol8ixtDTdqrw9YN/KVw0cdKY1Lk7BqG20eMkzGSisSuEUGwBYxZks8m40uqNpzMuYCheAt
	Kos4FWQzdwQSNYo4b4KXy1THoZBKAxnYf544zVBKyhgaeKtCUHfXT62sRL6lDpU856PfGDeB2fz
	rODBQrwKIAuW80drvwYIoDmcto3TZtFf9hobkw==
X-Received: by 2002:a05:6000:1885:b0:439:cd8c:209f with SMTP id
 ffacd0b85a97d-43a04d87c31mr12531040f8f.23.1773489508090; Sat, 14 Mar 2026
 04:58:28 -0700 (PDT)
MIME-Version: 1.0
References: <202603121235.tpnRxFKO-lkp@intel.com> <20260313213638.GA147391@ax162>
 <CANiq72mzEzjNg7O_2dWT_6QOJvJ3TwV+HyxNd_F4j6v9C+pc7A@mail.gmail.com>
 <2026031422-catsup-rectal-f886@gregkh> <CAH5fLgixE9MGXxNEnU5b0EXdgLQoTs5CMv_0OdnfCX3v=coUpw@mail.gmail.com>
 <abVG0JypVhDxx1Tt@google.com> <2026031444-wriggle-tradition-245f@gregkh>
In-Reply-To: <2026031444-wriggle-tradition-245f@gregkh>
From: Alice Ryhl <aliceryhl@google.com>
Date: Sat, 14 Mar 2026 12:58:15 +0100
X-Gm-Features: AaiRm53w--KuwJ99Osd9jUt6yvtILxF4awX5YKpSHdok6ctk4q24IRBVS1ZMNeo
Message-ID: <CAH5fLgjruspkrLagRirzfDbq=k3OEnA5JBLY-BNXMD+JsJam2w@mail.gmail.com>
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
X-Stat-Signature: 51s7i5p4qyxrzw6sn6dm5a49ncgmtky7
X-Rspam-User: 
X-Rspamd-Queue-Id: 180F314000E
X-Rspamd-Server: rspam12
X-HE-Tag: 1773489509-96587
X-HE-Meta: U2FsdGVkX1/EEYFspgNME9nZIZj1KTLBTzZK6w7fOfmfK3R5LcTUj6Ea/b1mxce6LBrFqXIkp+2k+xZ5h/veux1hZHZhxapAt4VU1LwjKmbfVlUmc9jhdyqVrIuXq6bSO0v+yPAjGp+1PzP2U0MpqW1JEzq4XVvt7SbWnT/7p1H280ueQb39N37EuGjksCxve9lc0TzEYnoxi7rY/hLsIT1x1Bm1Qbe/9v4n9lwN41i3Ow6+XTdEoVuuAdCU3tLk0ThpcfpyWIvz+6M2BNXJOwW5W7pua53l2HOLIlhZW+J+OYDbbaHOZAkaCiuJi6cxZNU1DKKW6/KOWHkjTEq+2QbxTC/dLyBrtcE+pT9f2Jt4GR8+setPCmDYM90ZuDDxWeLHMSHQvHB/RDTII7vxbraN1SZLFQxCpvxvE7xZ1gFWTZ6HBEPDiS09tL4X+OSvEisf5PfBwhCGNQEWwq5paLCc5z2G4uslEP+H/R5uqB8fgUekx+zekfqKGXpRRoRUsdWTLk7Vyv0qXqztpb4i6BmwGAmz6IU1nXk3sBa51kcVybmrPEK5jAs7xmz/0jpA77SS/7eyFqy8vYcq2NHlwui0XFfpo39M/gn+GAL7bQF4fIjE8cg+Lu4RVvc/5CPiAd4B8J5LOMrU+U9qG26xeXX9JQ6ZNlyRySj5cdhNhyPAGi8LRPQ8zYj3H287evgwQ81zcMbYSYGpQIodTjrHY9wSNkqFnk1nPutplvUKHZcliolJHiihilAX6ePwVfFWJOIbQeyYtLCdh7D5dwM/iTRghMFa2aCR8my7zpOXbIQRiNv9fB58qYbZ0S6YoTko5LUAYjN+FhXKl+RgW95WkCB3I1q2JTchRFtAxf8SGhRURdEeOuCeANw99hlHRJdUBTbaBbreYXClRgYtsP08xZB8QuOcFeknn52RDjE/OtCJcDPp6Vy5WMBieKMibHpuHG5kSmQ4ZcUEjiwieH8
 6fhK7dax
 AFmsQo9QrvhYojdqCoc4koMjpccsWkzy7NMn477BeelDb+FcAq7qNIS6Cl5XYBI7jObKlLWbQc/7X+CxxYQvU630wwtdILoTAOjEIq1pFh9zG8jfhj2825EG1A2PozW2Q0QdjgEmDRX9oEIQmxGe99+WEgvBFmyc5hok2L+eLcgT1XFzAGTO8P1sXnUVUKBxHD5ySkuZtsvikisuacoxLFTIPG2GbtzvkDHhVG16Sw+SQkmcBUwgOSVFjnGSUXXqKZDQuFTil5LABEWzjIEf2eswpiqC/wkMcuyaWE3nAUJOO0gMgiN4jHWqWR79wtjVudaxw1wFp8ktwa9UZPTSMb4WiTh6wokq5awzAxUNDLSs2Lxrawek2LF93OSh/9y5R/xSTiVJxZOlZ5KosfkQCasrOS6kJ1sVYScyw54zSGt8Dqx6+rGKAMXZheA==
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

That works, thanks!

Alice

