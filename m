Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C08A109B461
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 13:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64BB06B0095; Tue, 31 Mar 2026 09:05:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 622D16B0096; Tue, 31 Mar 2026 09:05:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5384B6B0098; Tue, 31 Mar 2026 09:05:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43D346B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:05:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF43A88517
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:05:00 +0000 (UTC)
X-FDA: 84606378360.12.3DA0B89
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id 614E9C0027
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:04:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="MGzD/bDm";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774962298; a=rsa-sha256;
	cv=pass;
	b=a3wCY5kyjDpAJ/GQ2oAraqDrdGGYC2MyCax2N3bkAc7zdzUSKY+izLHskY7AZC9ZOvdzuL
	bfi3GeJ5S/8MY8ggkmg/o5uVW8vKTEYuJfxG5QvtW0VBQdq8jmNp1RIS6A6+8VEtVk6U06
	EiJzpBAa0aBl1JE1N1Yau88D5wcwV9U=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="MGzD/bDm";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774962298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EXe6ByVFgqHK9ot4yGzQ91DO+cEJ7cxXfss2LYdxr0o=;
	b=T734qOhe4tEmIodUCWQqh0Iqeksc7S9ZcrjgKooln8scQT7jr0nTTxffN26XsLSTCaWgVO
	Bindw+2rrKS92b7ed37ygogFEveX69A53nC7cPoB0HwDHUJAXVhtGonPZ2x57IOOhLEv8H
	cHQ3REsWn6iCkayKxmment+ZRD/c+9E=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48700b1ba53so52005545e9.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:04:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774962296; cv=none;
        d=google.com; s=arc-20240605;
        b=fv7WgjPr4h92EonfMyPSx4kx+71pKNNEfYsPe54qdx8unk3RoGNFe50HZfz/EoySP6
         ShOkNhN/5YlcIp6eJf5SUZ88qk21I8v4g9Uy0nRvyKMhxiZ/xUskawy6B4rMNZGPpHXl
         f4ZQW9/mTJFZ9pQ14G3icnXZbibhIL3rvh4taOfcGWdtDIAZk3nrYxHwlc1ubIa7q9on
         YLPB+JSN2WbwWfuzqKubTsf1ofp7Wd234VlftxnNGtuhdtSM9YxVYVmixi64CS3C/Ec5
         dhr2NaqJs1qOaPJGNDNVeix7vHbLICK9AroJUx9rTV4EZhnEi0NDNwFXlaRmPkYHwXta
         N9Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EXe6ByVFgqHK9ot4yGzQ91DO+cEJ7cxXfss2LYdxr0o=;
        fh=JM3PFNMZM4P3znJT8pOSMF9iX9Kdu/y54dWYrR0x4kk=;
        b=Z5nQaVzJ+ZJw9p8B02Tk3rGfqiklu76pgAm3MXopQqsDnnNntaSQh8TpB6dph92uah
         VKS1r5ZpcU585JYN+86rFQKK8OTNtHZBSXRsvmUid6BngG+dOS43U5jyVKuMSnubdH95
         t2eyd43Rr/0fxSh29zCCQpdJQr3Ed60GK8Ho492d2afaq8MDDua/mhFmccsr/7/4nuiT
         u2qKDEPc/qHBgWj6uTGMZ1uQM87conqAoiY0UWVvbLu75MrVFogfia1QHx9WQttcVG6l
         kJOAAAyhgPxVEqVwUBtWP6NkQxbAviUiW5rw+puBVwS3K2EKXM/H8okZ+gxwRpO3/vsE
         Hxgw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774962296; x=1775567096; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EXe6ByVFgqHK9ot4yGzQ91DO+cEJ7cxXfss2LYdxr0o=;
        b=MGzD/bDmv72WdcHAej7nIhP/uPrryjp/tTpmhCcEeCH7t/mhL48Rh1QR8gdic6Q+Al
         QYLFSOxCtXrYpHo0LwGFyKu0E6Ok5FJw9avTKzAjCTMD8h0PxuLlWXAMpmwiU1PXAix1
         ZeqidKF8Iv9fHpdVWlZl7/g3WWbJcH4a/chtJL60wAkxXfTOJv9Mp/4e7/pvySd5rUug
         8zx8jkRrmfnhdSQDhewDg0sJ3gVutU2L+LDI7SxrbZZdmMi7rW77eWR/dw8WWnfv4PKv
         eQspPasbYDQsDMz5AtflD+YpSCGFsoSWiK6UcbfAGSfbtZjMX4FPI2po8WbpHjzJKXwC
         ANGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774962296; x=1775567096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EXe6ByVFgqHK9ot4yGzQ91DO+cEJ7cxXfss2LYdxr0o=;
        b=N6qAh5TJ+NbmvihDSrlPmou+gEL7jejpd5X3GrxO72Rejp+rpDG7gnRxT+n6w2xTny
         qps3J3TZg2bZDldEdEclFxlonHX8xk4WL30mGs8qr8CXqQ+YX0CqerN1Tpue+5uh+pUO
         VjkTBxmuT8+78TFGapLlZSb/CAKm/YsFQNsY1f2vWkr73UJMF5W/tczaSvIGeht+Q15e
         1tOHyJqZ8gCGSV/uSG2mz0gViuveCUFHqvSSZ/Hm6nKpeK4Agu5c3R6S65+EcAH1mOD/
         AypV188bDMOwFEA8ODSIsw7jM7VkymT4tPJZXg+FNpXLzhifhFWcHkP0k3BgMflLnNqb
         HzsA==
X-Forwarded-Encrypted: i=1; AJvYcCX1RZPauUIBvW680uC7Vphqls4d4oBLXWTxm13UtMotQYy3W7fMGkElAkYuutTMDS57LvzbakIBVg==@kvack.org
X-Gm-Message-State: AOJu0Yw0sNukKQjKLJ84vze3W5lWo8tEfLERJiGLH8Soc9PCblJRxnnI
	CD6GQzQu8ggRNRaoQTfwKP24iTLcEJBw6R/ub+zzNkitQUflVQUutAqxuBsy/WbWtSeWg+vWP68
	f2scx6Lxj4oqN2+IGNaI+v6ZBrIXb+FwXhCNSRjv0
X-Gm-Gg: ATEYQzwdb2zs+5I9pL+9nS6md8HDubVOZz7QRS6sGxvySjEUKPtCdwHuJG8ygiqdsPx
	36RMYjDRG3x1hj7xuAFbPtliIqotuQZO9BTAk96VZKhPnZb5YPrlsNiZI5VruD8ZJkU1MxdfM0+
	6/GTKTESmkQRgBT7zCVKbZYTuqJU92pKL3VIAD1EYkJ6e43wEOmK1YVvxtP4iHEY1s+fplngi+f
	rDHorhSV0sxWy2eNp2oym3Syg/QgEWcxHuz+6FfSQ4NwtZf0tIwlU57OHIPTcWU7T9RQatPclQ2
	a6SXuagsovQvuU8etVJDfCuA77JigvZF+VsXqQ==
X-Received: by 2002:a05:600c:c493:b0:486:fd3a:fd22 with SMTP id
 5b1f17b1804b1-48727ef163bmr265057995e9.4.1774962296021; Tue, 31 Mar 2026
 06:04:56 -0700 (PDT)
MIME-Version: 1.0
References: <202603121235.tpnRxFKO-lkp@intel.com> <20260313213638.GA147391@ax162>
 <CANiq72mzEzjNg7O_2dWT_6QOJvJ3TwV+HyxNd_F4j6v9C+pc7A@mail.gmail.com>
 <2026031422-catsup-rectal-f886@gregkh> <CAH5fLgixE9MGXxNEnU5b0EXdgLQoTs5CMv_0OdnfCX3v=coUpw@mail.gmail.com>
 <abVG0JypVhDxx1Tt@google.com> <2026031444-wriggle-tradition-245f@gregkh>
 <CAH5fLggMZM3kYWO3xqb4o-mQG27aCYOmiiODW67CKLTstkB-PQ@mail.gmail.com> <2026033142-distinct-tanned-f749@gregkh>
In-Reply-To: <2026033142-distinct-tanned-f749@gregkh>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 31 Mar 2026 15:04:41 +0200
X-Gm-Features: AQROBzCLOGQX2tSfSkAhkWuzSolMKQYyl-U7kjRDRXWr57ayx_jzC1qnpjdIn-Q
Message-ID: <CAH5fLgg63SYHQ34yqy7o2cA5f2Gh0aNTwTeQkzbWb+kV4Rr3Qw@mail.gmail.com>
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
X-Stat-Signature: nxdfsdy9p71eyahfao18nzmmurcdyg36
X-Rspamd-Queue-Id: 614E9C0027
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774962298-299042
X-HE-Meta: U2FsdGVkX1999tmDyxPe7BCmmyXuAZc5Il05+nugE7mpYPZL23xC6yfBCZxJSoLwPI1SGHtljtvygfjiORTx/pVHDlysaKouzM0ezqmDO1iG3XZDrT/8sZ/KNAWQ2dVAJ8zOicSntvWTuAWJL2PMptoZdbxuQSR5NwEzrPRzfzan1JIFwcrtUHnby4KYfSKBopQMRZPc2T3LEt6HKpA6dAR+O5evAksj5hp7ZSQOxu6/6bfBBfyBjZaajq5GxplVSEDlcbtUuqHz8INoRN04S7iafEwsRE7161+fk1QhFM7/GOOqplFobi/f9Ut3Q+ue3wzQ4qd42uRm2P0c6R+fbyvFGBm5Nwxaz+/HG7UDV/ZPe9sp1WMmgWCVmRa2rwLW7rGrJb42Y71fl4Pt1bYHTSOocD4ne+BEe1kJPMUvEd4d29dBT1nF/UQ5EuumSDu2wbj5URr05TrXfy2eDlisOGxinhXrxmt6/Ijew/+AZL3N66zi+krZaaB32vuzvuQDHGWVkPVxp+SbhYIE3mTmLhHgBnOhOqGJaAH2DosiYay1HOn2wXpElwUmapEFzhSIy9+9n9g5wrsEzsfPcshQ8yIzIu72WLOSgLy1UJA9W+BLK8hqapMdrGAKJ64Zc8Q7FdL6Qqzm5l3QLSN9j9pHV8tiP0w1/7EvJSCnKSD1PKEvlmpqJZvj6Z6L+Vgh8PoKVoXnk4WEzKhHFAVK5Dqn8/66VTPZOP6QH/VFvh86l/VeMMKSxeHnDG5uzzxdtnzzTHUrSKn/wsr0HNfveTfDhiqhfEn+66Km7lml3kzTQWFR3gmlbf6J55VLfArtl3TFdzBwVjDNWYOYazftnfefsG9CVYlru+2rEvT/C0Z50q21R526HWzUKinxoJP+7G/v0kBFAen+pFtGzER0wsdKGtLj91QQz557ZTzP/4deS7Y8B9NbpoXX7tTcRelrwTQa7LFI7w6OQ/xnVeuWhi1
 zUNS/+CJ
 ius3bBrFY92d1Va5YuqMIWpPs8/yfhhAC0fyJ//pChl+p4IGnLp7z4rHmtCjLNuQpzWDejObLaktvOme9shhNwrlbhQstYKtOEDyKkK5El5Szae+lSESVWDvLIvQ3VMKoGsWi8i+C4cHUJpHwOSCMs2qW3YByIbJ6bu6dkyL9b9pHokoesGTCTOfOYVLRQFxIgcWUx9WxSDl/QkgjeSnR3sipExWL/lEBXgmJFNeQayXqXZ68ddZOCke1LhMB5KIT+Gn9IyOGbOsQcKEtdF9aNpuZgNh9Wp85xqX5Y6GHFVFkOyVcVPShia365efQXoURJzjcA6OzO+30/6ZMBP743JAzJzbZb67MMOshfBOI0Dds2E5ELrzlZ2Lxl97PgpsCZfLSZnjffmTXuLIwOJGOJaEVAGBBl8+ebO1cXAA7ZlnPllWs3GR8ZEQqdyLekH7HWErJYavv1kkKmK4N334RyN0x4dCFdFGuI3IMbr+m+WBejpTUU+QT1xnqFBJuJ46LyAEzU1DT9bjzF8c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 2:59=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Mar 31, 2026 at 01:32:03PM +0200, Alice Ryhl wrote:
> > On Sat, Mar 14, 2026 at 12:53=E2=80=AFPM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Sat, Mar 14, 2026 at 11:30:24AM +0000, Alice Ryhl wrote:
> > > > On Sat, Mar 14, 2026 at 12:15:30PM +0100, Alice Ryhl wrote:
> > > > > On Sat, Mar 14, 2026 at 12:13=E2=80=AFPM Greg Kroah-Hartman
> > > > > <gregkh@linuxfoundation.org> wrote:
> > > > > >
> > > > > > On Fri, Mar 13, 2026 at 11:39:14PM +0100, Miguel Ojeda wrote:
> > > > > > > On Fri, Mar 13, 2026 at 10:36=E2=80=AFPM Nathan Chancellor <n=
athan@kernel.org> wrote:
> > > > > > > >
> > > > > > > > It looks like this is a conflict between Alice's "rust_bind=
er: check ownership
> > > > > > > > before using vma" [1] (currently in char-misc-linus [2]) an=
d Mike's
> > > > > > > > "userfaultfd: introduce vm_uffd_ops" [3] (currently in mm-u=
nstable [4]),
> > > > > > > > hence why it was bisected to the -next merge commit.
> > > > > > >
> > > > > > > Thanks Nathan, yeah, adding a raw pointer (not function point=
er) to
> > > > > > > the struct makes the type `!Sync` in Rust.
> > > > > > >
> > > > > > > I assume this is best handled with a patch on top of char-mis=
c-linus.
> > > > > > > Perhaps creating a wrapper to assert it is `Sync`, since the
> > > > > > > `BINDER_VM_OPS` contents are unused (so far).
> > > > > > >
> > > > > > > Cc'ing more folks related to the commit.
> > > > > >
> > > > > > char-misc-linus should get merged into Linus's tree "soon" and =
then we
> > > > > > can fix up the mm-unstable change for this.
> > > > >
> > > > > I'm working on the fix as we speak. It would be ideal if it went =
into
> > > > > char-misc-linus, because the commit that is wrong is mine, not th=
e one
> > > > > in mm.
> > > >
> > > > To clarify, to avoid breaking bisection, the commit needs to land
> > > > somewhere that is on top of commit 8ef2c15aeae0 ("rust_binder: chec=
k
> > > > ownership before using vma"), and before the mm commit. But I guess
> > > > there are several options for how to do that other than landing it
> > > > through char-misc-linus right now.
> > >
> > > I've sent off a pull request for the char-misc-linus branch now, and
> > > after -rc4 is out I'll queue this up on top of that to get merged for
> > > -rc5 to make this all work out ok.
> >
> > Friendly ping on this. I don't see this applied yet.
>
> Sorry for the delay, now queued up.

Thanks!

Alice

