Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B1CEEEA845
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 19:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 020DB6B0088; Thu, 12 Feb 2026 14:01:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11286B0089; Thu, 12 Feb 2026 14:01:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE5F36B008A; Thu, 12 Feb 2026 14:01:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C60576B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:01:51 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 77AC31A02D3
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:01:51 +0000 (UTC)
X-FDA: 84436724022.16.93A2A67
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id 536E91C000F
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:01:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="l/7hh7Wq";
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770922909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9mXBGp+um/Yb1Ww5LCp73Epu3ERje+tHvFzXQeiYHo=;
	b=aHLxln1CJmQOg1Ix1blnApRfqImnknQzYq//Y7gKAKXvGMm5Ugwz96ie+Nb8+tgPPm2U3r
	GK9j1QUz369cr+2kStCNUOivSRvzJ72XGC+hw5towaE4PBnI2H+NbNQDb3z1Sp9voUtwbQ
	V0PjB1HCFBRG2aZEcy8UhvP0yStDsi0=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="l/7hh7Wq";
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770922909; a=rsa-sha256;
	cv=pass;
	b=yzB/X5MsEADMnxVQ1FynCFEmJjqnd1EOygKpMw5J4+IZ/GL3hWtgTDUGgg5Yf4HYDZOmG9
	3JUEGily+j2abzcbNpwAQlCWegjTO6FUboIOTYqqRan70EDS0vJYC8XWXGn8JiOTUVx2zl
	ddCgpX3pvH61/JP7NfL0cZIiIMlpoIk=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-65a36583ef9so319563a12.0
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:01:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770922908; cv=none;
        d=google.com; s=arc-20240605;
        b=GS6BxIAN00DKBEVRRBqxXLGGU5wXt+hIyPdxczS/MS/xzAmig9q5nFpBxteTl5iu1i
         GKGFes/46S+9kM+Rig+k1YVphH3hjQYNYgSeSFHd3hwgpNe26etKA0Ii3J3kNbXBUXXS
         I1k2wS0qlbkYPhM8ou0oBMMNGb+rFFFo2PqclVgnPkm0S2lYHhbylMdOY/GiKtc45gJ7
         fohkGwQsAU7tCF7BK14kH2CJ82wwQPHjw36r4UPHk6UE6qrAeheBZ7PCeYS7pdhvdnYl
         ky8ZJcqEtS5sUKUlisQWMqn2eInwEmkvZ/042NhMVuXTLWm6/7Rj5/cWq5d+z094ks8p
         unBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=J9mXBGp+um/Yb1Ww5LCp73Epu3ERje+tHvFzXQeiYHo=;
        fh=3iH5wrJHc4LJ73c1RepWOkcdrX2u7miYVdQPQjPyAWA=;
        b=D+wF/dHPd8Lpkks8lUat11ZE4Xpz/Me4nuCEHqXYl8mfr1F01/+ZlghvrApjlauaqJ
         BLF96Mh1u4WKfiaDfop7M4Tc0ong/Hry7mv3klf8LV1Yfr/KskN/+WBTZs5ReL2mYy7n
         kyXci6kWpj9vJqA9V382g8hvRdifTGi35dSWKIBwIgyi+8HoNeQSaUZzzClx06p1th4H
         9JR1pYFeZcTutc1BTQwBspdw/tYC4G2TOOTFPtHb3jIZphm0rt4RvtVtpyU38fYsRIDq
         kqvqkUavHVWJIf7iAHU8vNvD8tmywJal++VsAr2qyKiN631b0j2lCUiUt4Se0fU+4apw
         d7aw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770922907; x=1771527707; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J9mXBGp+um/Yb1Ww5LCp73Epu3ERje+tHvFzXQeiYHo=;
        b=l/7hh7WqRASsf3WS7KAieXz1gmqofWvjRH4HJFRAvXXEvUs2V/VEl953Oi5Ts6T4qF
         pDHaG7W8+hkJsXJmsssQPN1EdS/C/cEPHW7q8ofpDzah7zqc2jo0JCJtOVGbc4J+fhOY
         e5AvxkOcSs7Kz+4aFqmAHoNvdDYB6ze759lO/VQMjigqBAcIJSKCODojni23yNvyhgd8
         JPTChtlM7K5GvaD3mmIqmjImg+oU895/bWM2ZN0TvJ1rebSBE7bH1NCP9S08ekyL2Ba/
         V1b9gC7rEokdIcwCVA2v0wU9D0uZLdDlJ5A3q4eGdHz4CXpGnUAbq4NYvfUSET/aLD4W
         QlVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770922908; x=1771527708;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J9mXBGp+um/Yb1Ww5LCp73Epu3ERje+tHvFzXQeiYHo=;
        b=W/vehUWme/Ed+iDzrt2OAcJ908cAWi/r+iXOIMdpU5mdD6pCu24uwqX72mC/FEQh2/
         p9GkR3fYBoHlWtD71fH/oWQhDzG/qr1yn7kV05HWnfgaYb0bN/Hu/IqIv3grbSKe+leB
         c8dF8kc820OaPSfpPCb0It8PEAcZe0ePCgXF0/+CffL1NglOcpCvcxk6hkPk+b720uW3
         ov+NcfpjfVPyj/hgIjhvyeJEONtEN5f8UC7hTImtVNO9MWW3CLYJ7iXQNSZJUyG6tdwv
         Ts5/2piGYwh/q8lY3wCRZEGSYXMnQzXw2aph/laVs7NmeTvQA9kOGDHYITPIOgrux3mT
         lCFQ==
X-Forwarded-Encrypted: i=1; AJvYcCURo9zC7p+nExJthIJLSBpTC7TxdL9BFm7a0EjYT/T4nhBt9sevBu0b9pBJmWrF74e6BZK4tGaElg==@kvack.org
X-Gm-Message-State: AOJu0YwsE2kgm590P1r4ge+FJ7a9bJBlTWiBWIFxKGh/utApwqlh/Tfk
	EUcg64m3XAWHwh+u+1iIAo9Q8m5OE/+FuOAW1tC4JRlMCg1oMU/OzbI+CYG8VnRb7VU+YE/sSvV
	QwwL4Y4MhGGzYKCAW0VsubS0imubdJjA=
X-Gm-Gg: AZuq6aJDPWSolHKL6orbJDJvYQekwQWlSYLBlp7IrUDlAxagCOUdvM5GLU5NY8otGAm
	uotGm9bjR8TePzOt0p1O2Bs4pHUpLzK7asMCtDSlCSB8X55nnG/4T5CSBWVsb+1m88rqaxnI5pt
	G+ZvkDVg8LX4EFZggER5Onj0vGMLpjYlIHfiadTaLg+vY5Ww/U/ezs5wUWm7OfOghnNIY+AyPAD
	FFPtHuiM4YUWrzmJTKTb3mHPt/m3FuLM+ueyLIqCrsBVD3xVtOOW4UnElNlRBdBiwQzPKzaA0wn
	Gfip9PFIp2W3tz7v4Er/DfT3e1fLfi0PpScljzpa
X-Received: by 2002:a05:6402:3054:20b0:659:9068:9786 with SMTP id
 4fb4d7f45d1cf-65b9bb491c7mr1803195a12.10.1770922907328; Thu, 12 Feb 2026
 11:01:47 -0800 (PST)
MIME-Version: 1.0
References: <bug-221055-27@https.bugzilla.kernel.org/> <20260206121151.dea3633d1f0ded7bbf49c22e@linux-foundation.org>
 <aYt4RwxqH1W_zHez@KASONG-MC4>
In-Reply-To: <aYt4RwxqH1W_zHez@KASONG-MC4>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 13 Feb 2026 03:01:10 +0800
X-Gm-Features: AZwV_QjLW2rjpo5cpVWKo-5GFgV-h1DxqnRj9thOJrUrzkKnRdq5wJABlCYhQuo
Message-ID: <CAMgjq7By=prRMh2T=i-T2cV3fZX+oE+YM0H4zHMXwSscnhbZmg@mail.gmail.com>
Subject: Re: [Bug 221055] New: Hibernate image write 10x slower since commit
 0ff67f990bd4 ("mm, swap: remove swap slot cache")
To: carstengrohmann@gmx.de, Andrew Morton <akpm@linux-foundation.org>
Cc: bugzilla-daemon@kernel.org, Baoquan He <bhe@redhat.com>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosryahmed@google.com>, linux-mm@kvack.org
Content-Type: multipart/mixed; boundary="000000000000d132d3064aa51ef8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 536E91C000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 4gbpcy1kpx95abuj5afin1saaygegp6w
X-HE-Tag: 1770922909-926463
X-HE-Meta: U2FsdGVkX1/TbldPq8KX+ICvhxeYEg48DRO5kNLJXc5dzZSZvW9tmcZo6OzZaoa5Cs6n8DYQ1BgOCpE/0HLg5V4f2WBTi1u7x5ov2UKLfYyRoNdumwzRsLIvhkeb+7KLZoPz8w5250sXo01e+e1IV+S63oKQOS/2DqXzlWaEqBAygDb/4L9pWqkCfWlUcucbiMB8CDVGjVlCoPgKj8jN2jPS+xni6boRj3OFU9IjJA0MHNn1h6jRBWUJ+o0W6y8NIa7OZmxUaIYu4Ezfuz0Cmed0dDFK5XhDLO8ZTb45VhOBDENc9LFi8d11f2tjuaF73GqNdEu0r6QXS7p7/bMyfAWlbr6cE/RReJ8MvItkrCBXSMCXn+aGWqJUWrz+CQDWE3dq2kWuSVAChn3I1QvwWSeFSn4KzjuZmRUD2WBnyBnCFRhzZzoZGcbOZZ4f3t8pxSYf4D549giwMAbXIZ5er7t2h+HsXB4QhwpRXsj2fyS6Szp/5Nff1Sg/A2AiyHwzbeMnMXcMJASv1qx/COeAuyCUt678yNBd9nB4g4mu/iswI8WY12LW2yhrjFayE5aBL0pprW4PE95OCNouRet9SPqt23ZJST0clXB2RYVQ8Q/USs7yxL4YtEOg8IhlZ2yS87uKvpZqAN0DVCfQJPYF3rmkV0Tjw1gXbtc8ULGof+vzJaqipt+YrO5LTnsz9FZhfW/bBX9YQKPzQ93dXsOFBt9uYP0ROT7FbqndGaSQMHo8mCE4k6j/JNaM+n0Mwno3XbiFQw5L3r/87dmAtsn+6pSESofh6R/mC9+SkjqVLJTDXR5D937lxOozflT1UajST5jrag5Bl79yK2FboTGDFM5eRxKHCvp+AJef3TltF5CwAaBiJ21adrhtib273Ap7AH6MyaJqFTVGFasWTQpk240egBj02jN/eTZV6axD3JImkFZn5M4lOJDQjQ8auwTdtIrY4xlfJvuVKvGNAfR
 0W43jcvg
 zRcbkxANXDFSU3qJ3HERPnthVgbf/2A73iln/BmEX3kdJVkl1NyIWxWLA0NCzyTFwOpkBWY+1ThokLAMzYxPOm/5+JyY4HFStvG8u0g+kfwRZO8yYbPK/hfaImykYCkQJZDrGFr+qI+isRcMucUsfjhxGnv3gq9nQD+xaGt8cjt/kZveXOCARN9QMXd3BvgoYZuDIHmLp+bKlOurug+FntanrVqYZ6qPh7SEyWPGQj99idZXluVDBGaxNU57UjG1AG7fmc0L/5ph75dL3FkR5UBQs1E9hmIwM1OZ+8NWjlOqEmJFxkmB9YJktSMXXkoqseSDA5dh4HDJ74XiF/SJBSb0TVUgsCrT/XVrvVMoFoNV3lNi6tm+seAi6LaoEvODciiq9ecWZ4GcdFHCdp5PJtQJW8r0rbj54lCuIfJF23yegzuH3jCZohE+w3mqP5HKR8dKcgYyIxpcP99XlhN2ePoKmlWNUaDIqXi0gbpw7fx/+yeaKD817hWfH1L956HCNwmbP7wwfWyGgq+h4xveSeWFsoWXvCckxOFMd5PO3CMfVrrrVFIaK5aQl5pjR1BKEZGDXtyOZI0MEIJsxr9+LsZr7VsaeV1gg5jwlf6bKJQ32x0DM53kM8+9uhfTPANgpU5kZRbNirSBKZoUeJQ+cPeYqFOP7EuEWS4+pUzM/rpzjKpvJo843D8bdsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000d132d3064aa51ef8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 11, 2026 at 2:39=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Fri, Feb 06, 2026 at 12:11:51PM +0800, Andrew Morton wrote:
> > On Fri, 06 Feb 2026 19:51:38 +0000 bugzilla-daemon@kernel.org wrote:
> >
> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D221055
> >
> > > =3D=3D=3D Summary =3D=3D=3D
> > >
> > > Hibernate image write 10x slower since commit 0ff67f990bd4 ("mm,
> > > swap: remove swap slot cache")
> >
> > Thanks for all the work you put into this.
>
> > > =3D=3D=3D Bisect Result =3D=3D=3D
> > >
> > > A full git bisect on the vanilla kernel repository
> > > (git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git)
> > > between v6.14 (good) and v6.15 (bad) with 14 iterations
> > > consistently identified this commit:
> > >
> > >   # first bad commit: [0ff67f990bd45726e0d9e91111d998e7a3595b32]
> > >   #   mm, swap: remove swap slot cache
>
> Both are not too hard to fix. Is that's SSD only issue? And
> should we fix this in every LTS or just mainline? It could
> be a bit trouble some if every LTS needs a fix.

Hi All,

After many attempts, I haven't (fully) reproduced it yet. But I do
have a patch, see attachment.

After this patch:
PM: hibernation: Wrote 1559088 kbytes in 0.55 seconds (2834.70 MB/s) - NVME
PM: hibernation: Wrote 2038748 kbytes in 4.04 seconds (504.64 MB/s) - SATA

After 0ff67f990bd4 (the regression commit):
PM: hibernation: Wrote 2224184 kbytes in 0.90 seconds (2471.31 MB/s) - NVME
PM: hibernation: Wrote 2215472 kbytes in 4.44 seconds (498.98 MB/s) - SATA

Before 0ff67f990bd4:
PM: hibernation: Wrote 2222772 kbytes in 0.84 seconds (2646.15 MB/s) - NVME
PM: hibernation: Wrote 2230700 kbytes in 4.47 seconds (499.03 MB/s) - SATA

It seems a bit faster / slower indeed, or maybe just noise. On my
machines 0ff67f990bd4 is not causing an major issue like the one
described in the bugzilla link. I'll try to see if there are more detailed
issues with the test setup.

And can anyone help verify this fix? I'll also try some other SSD later
maybe that's only reproducible with SSD that have very poor 4K performance.

HDD should not be affected because the allocator has a special
way to do HDD allocation.

--000000000000d132d3064aa51ef8
Content-Type: application/x-patch; name="hibernate-perf.patch"
Content-Disposition: attachment; filename="hibernate-perf.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mljtok8k0>
X-Attachment-Id: f_mljtok8k0

RnJvbSBmNDBhYWQwMTM2Yzg3MGQ1YjUzNWZkMzdhMmVmMjAxNTNhN2Y3NjgwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBLYWlydWkgU29uZyA8a2Fzb25nQHRlbmNlbnQuY29tPgpEYXRl
OiBUaHUsIDEyIEZlYiAyMDI2IDE3OjA1OjQ3ICswODAwClN1YmplY3Q6IFtQQVRDSCAxLzJdIG1t
LCBzd2FwOiBzcGVlZCB1cCBoaWJlcm5hdGlvbiBhbGxvY2F0aW9uCgpTaW5jZSBjb21taXQgMGZm
NjdmOTkwYmQ0ICgibW0sIHN3YXA6IHJlbW92ZSBzd2FwIHNsb3QgY2FjaGUiKSwKaGliZXJuYXRp
b24gaGFzIGJlZW4gdXNpbmcgdGhlIHN3YXAgc2xvdCBzbG93IGFsbG9jYXRpb24gcGF0aApmb3Ig
c2ltcGxpZmljYXRpb24sIHdoaWNoIHR1cm5zIG91dCB0byBiZSB0b28gc2xvdyBmb3Igc29tZSBk
ZXZpY2VzLgoKRmFzdCBhbGxvY2F0aW9uIGlzIG5vdCBjb21wbGV4LCBzbyBpbXBsZW1lbnQgaGli
ZXJuYXRpb24gc3VwcG9ydCBhcwp3ZWxsLgoKQW5kIHJlZHVjZSB0aGUgaW5kZW50IG9mIHRoZSBj
b2RlIHRvbyB3aGlsZSBhdCBpdC4gSXQgZG9lc24ndCBoYXZlIHRvCmNoZWNrIHRoZSBkZXZpY2Ug
ZmxhZyBhcyB0aGUgYWxsb2NhdG9yIHdpbGwgYWxzbyBjaGVjayB0aGUgZGV2aWNlIGZsYWcKYW5k
IHJlZnVzZSB0byBhbGxvY2F0ZSBpZiB0aGUgZGV2aWNlIGlzIG5vdCB3cml0YWJsZS4KCkZpeGVz
OiBjb21taXQgMGZmNjdmOTkwYmQ0ICgibW0sIHN3YXA6IHJlbW92ZSBzd2FwIHNsb3QgY2FjaGUi
KQpSZXBvcnRlZC1ieTogQ2Fyc3RlbiBHcm9obWFubiA8Y2Fyc3Rlbmdyb2htYW5uQGdteC5kZT4K
Q2xvc2VzOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1tbS8yMDI2MDIwNjEyMTE1MS5k
ZWEzNjMzZDFmMGRlZDdiYmY0OWMyMmVAbGludXgtZm91bmRhdGlvbi5vcmcvClNpZ25lZC1vZmYt
Ynk6IEthaXJ1aSBTb25nIDxrYXNvbmdAdGVuY2VudC5jb20+Ci0tLQogbW0vc3dhcGZpbGUuYyB8
IDM0ICsrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAy
MiBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9tbS9zd2FwZmls
ZS5jIGIvbW0vc3dhcGZpbGUuYwppbmRleCBjNjg2M2ZmNzE1MmMuLmJjYWMxMGQ5NmZiNSAxMDA2
NDQKLS0tIGEvbW0vc3dhcGZpbGUuYworKysgYi9tbS9zd2FwZmlsZS5jCkBAIC0xOTI2LDggKzE5
MjYsOSBAQCB2b2lkIHN3YXBfcHV0X2VudHJpZXNfZGlyZWN0KHN3cF9lbnRyeV90IGVudHJ5LCBp
bnQgbnIpCiAvKiBBbGxvY2F0ZSBhIHNsb3QgZm9yIGhpYmVybmF0aW9uICovCiBzd3BfZW50cnlf
dCBzd2FwX2FsbG9jX2hpYmVybmF0aW9uX3Nsb3QoaW50IHR5cGUpCiB7Ci0Jc3RydWN0IHN3YXBf
aW5mb19zdHJ1Y3QgKnNpID0gc3dhcF90eXBlX3RvX2luZm8odHlwZSk7Ci0JdW5zaWduZWQgbG9u
ZyBvZmZzZXQ7CisJc3RydWN0IHN3YXBfaW5mb19zdHJ1Y3QgKnBjcF9zaSwgKnNpID0gc3dhcF90
eXBlX3RvX2luZm8odHlwZSk7CisJdW5zaWduZWQgbG9uZyBwY3Bfb2Zmc2V0LCBvZmZzZXQgPSBT
V0FQX0VOVFJZX0lOVkFMSUQ7CisJc3RydWN0IHN3YXBfY2x1c3Rlcl9pbmZvICpjaTsKIAlzd3Bf
ZW50cnlfdCBlbnRyeSA9IHswfTsKIAogCWlmICghc2kpCkBAIC0xOTM1LDE3ICsxOTM2LDI2IEBA
IHN3cF9lbnRyeV90IHN3YXBfYWxsb2NfaGliZXJuYXRpb25fc2xvdChpbnQgdHlwZSkKIAogCS8q
IFRoaXMgaXMgY2FsbGVkIGZvciBhbGxvY2F0aW5nIHN3YXAgZW50cnksIG5vdCBjYWNoZSAqLwog
CWlmIChnZXRfc3dhcF9kZXZpY2VfaW5mbyhzaSkpIHsKLQkJaWYgKHNpLT5mbGFncyAmIFNXUF9X
UklURU9LKSB7Ci0JCQkvKgotCQkJICogR3JhYiB0aGUgbG9jYWwgbG9jayB0byBiZSBjb21wbGlh
bnQKLQkJCSAqIHdpdGggc3dhcCB0YWJsZSBhbGxvY2F0aW9uLgotCQkJICovCi0JCQlsb2NhbF9s
b2NrKCZwZXJjcHVfc3dhcF9jbHVzdGVyLmxvY2spOwotCQkJb2Zmc2V0ID0gY2x1c3Rlcl9hbGxv
Y19zd2FwX2VudHJ5KHNpLCBOVUxMKTsKLQkJCWxvY2FsX3VubG9jaygmcGVyY3B1X3N3YXBfY2x1
c3Rlci5sb2NrKTsKLQkJCWlmIChvZmZzZXQpCi0JCQkJZW50cnkgPSBzd3BfZW50cnkoc2ktPnR5
cGUsIG9mZnNldCk7CisJCS8qCisJCSAqIFRyeSB0aGUgbG9jYWwgY2x1c3RlciBmaXJzdCBpZiBp
dCBtYXRjaGVzIHRoZSBkZXZpY2UuIElmCisJCSAqIG5vdCwgdHJ5IGdyYWIgYSBuZXcgY2x1c3Rl
ciBhbmQgb3ZlcnJpZGUgbG9jYWwgY2x1c3Rlci4KKwkJICovCisJCWxvY2FsX2xvY2soJnBlcmNw
dV9zd2FwX2NsdXN0ZXIubG9jayk7CisJCXBjcF9zaSA9IHRoaXNfY3B1X3JlYWQocGVyY3B1X3N3
YXBfY2x1c3Rlci5zaVswXSk7CisJCXBjcF9vZmZzZXQgPSB0aGlzX2NwdV9yZWFkKHBlcmNwdV9z
d2FwX2NsdXN0ZXIub2Zmc2V0WzBdKTsKKwkJaWYgKHBjcF9zaSA9PSBzaSAmJiBwY3Bfb2Zmc2V0
KSB7CisJCQljaSA9IHN3YXBfY2x1c3Rlcl9sb2NrKHNpLCBwY3Bfb2Zmc2V0KTsKKwkJCWlmIChj
bHVzdGVyX2lzX3VzYWJsZShjaSwgMCkpCisJCQkJb2Zmc2V0ID0gYWxsb2Nfc3dhcF9zY2FuX2Ns
dXN0ZXIoc2ksIGNpLCBOVUxMLCBwY3Bfb2Zmc2V0KTsKKwkJCWVsc2UKKwkJCQlzd2FwX2NsdXN0
ZXJfdW5sb2NrKGNpKTsKIAkJfQorCQlpZiAoIW9mZnNldCkKKwkJCW9mZnNldCA9IGNsdXN0ZXJf
YWxsb2Nfc3dhcF9lbnRyeShzaSwgTlVMTCk7CisJCWlmIChvZmZzZXQpCisJCQllbnRyeSA9IHN3
cF9lbnRyeShzaS0+dHlwZSwgb2Zmc2V0KTsKKwkJbG9jYWxfdW5sb2NrKCZwZXJjcHVfc3dhcF9j
bHVzdGVyLmxvY2spOworCiAJCXB1dF9zd2FwX2RldmljZShzaSk7CiAJfQogZmFpbDoKLS0gCjIu
NTIuMAoKCkZyb20gNDQ1NTJkMTBmM2Y4MDc0N2JkNmI2OTU4OGQ5NmRjYWU0NDAwZjAxNiBNb24g
U2VwIDE3IDAwOjAwOjAwIDIwMDEKRnJvbTogS2FpcnVpIFNvbmcgPGthc29uZ0B0ZW5jZW50LmNv
bT4KRGF0ZTogVGh1LCAxMiBGZWIgMjAyNiAxNzo0ODowNiArMDgwMApTdWJqZWN0OiBbUEFUQ0gg
Mi8yXSBtbSwgc3dhcDogbWVyZ2UgY29tbW9uIGNvbnZlbnRpb24gYW5kIHNpbXBsaWZ5IGFsbG9j
YXRpb24KIHNjYW4gaGVscGVyCgpBbG1vc3QgYWxsIGNhbGxlciBvZiB0aGUgY2x1c3RlciBzY2Fu
IGhlbHBlciByZXF1aXJlcyB0aGU6IGxvY2sgLT4gY2hlY2sKdXNlZnVsbmVzcyAvIGVtcHRpbmVz
cyAtPiB1bmxvY2sgcm91dGluZS4gU28gbWVyZ2UgdGhlbSBpbnRvIHRoZSBzYW1lCmhlbHBlciB0
byBzaW1wbGlmeSB0aGUgY29kZS4KClRoaXMgc2hvdWxkIGFsc28gaW1wcm92ZSB0aGUgc2NhbiBz
bGlnaHRseSwgYXMgYSBmZXcgY2FsbGVycyBkaWRuJ3QKY2hlY2sgdGhlIGVtcHRpbmVzcywgd2hp
Y2ggbWlnaHQgaGVscCByZWR1Y2UgZnJhZ21lbnRhdGlvbiBpbiByYXJlCmNhc2VzLgoKU2lnbmVk
LW9mZi1ieTogS2FpcnVpIFNvbmcgPGthc29uZ0B0ZW5jZW50LmNvbT4KLS0tCiBtbS9zd2FwZmls
ZS5jIHwgMzAgKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwg
OCBpbnNlcnRpb25zKCspLCAyMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9tbS9zd2FwZmls
ZS5jIGIvbW0vc3dhcGZpbGUuYwppbmRleCBiY2FjMTBkOTZmYjUuLjAzY2MwZmY0ZGM4YyAxMDA2
NDQKLS0tIGEvbW0vc3dhcGZpbGUuYworKysgYi9tbS9zd2FwZmlsZS5jCkBAIC05MjMsMTEgKzky
MywxNCBAQCBzdGF0aWMgdW5zaWduZWQgaW50IGFsbG9jX3N3YXBfc2Nhbl9jbHVzdGVyKHN0cnVj
dCBzd2FwX2luZm9fc3RydWN0ICpzaSwKIAlib29sIG5lZWRfcmVjbGFpbSwgcmV0LCB1c2FibGU7
CiAKIAlsb2NrZGVwX2Fzc2VydF9oZWxkKCZjaS0+bG9jayk7Ci0JVk1fV0FSTl9PTighY2x1c3Rl
cl9pc191c2FibGUoY2ksIG9yZGVyKSk7CiAKLQlpZiAoZW5kIDwgbnJfcGFnZXMgfHwgY2ktPmNv
dW50ICsgbnJfcGFnZXMgPiBTV0FQRklMRV9DTFVTVEVSKQorCWlmICghY2x1c3Rlcl9pc191c2Fi
bGUoY2ksIG9yZGVyKSB8fCBlbmQgPCBucl9wYWdlcyB8fAorCSAgICBjaS0+Y291bnQgKyBucl9w
YWdlcyA+IFNXQVBGSUxFX0NMVVNURVIpCiAJCWdvdG8gb3V0OwogCisJaWYgKGNsdXN0ZXJfaXNf
ZW1wdHkoY2kpKQorCQlvZmZzZXQgPSBjbHVzdGVyX29mZnNldChzaSwgY2kpOworCiAJZm9yIChl
bmQgLT0gbnJfcGFnZXM7IG9mZnNldCA8PSBlbmQ7IG9mZnNldCArPSBucl9wYWdlcykgewogCQlu
ZWVkX3JlY2xhaW0gPSBmYWxzZTsKIAkJaWYgKCFjbHVzdGVyX3NjYW5fcmFuZ2Uoc2ksIGNpLCBv
ZmZzZXQsIG5yX3BhZ2VzLCAmbmVlZF9yZWNsYWltKSkKQEAgLTEwNjAsMTQgKzEwNjMsNyBAQCBz
dGF0aWMgdW5zaWduZWQgbG9uZyBjbHVzdGVyX2FsbG9jX3N3YXBfZW50cnkoc3RydWN0IHN3YXBf
aW5mb19zdHJ1Y3QgKnNpLAogCQkJZ290byBuZXdfY2x1c3RlcjsKIAogCQljaSA9IHN3YXBfY2x1
c3Rlcl9sb2NrKHNpLCBvZmZzZXQpOwotCQkvKiBDbHVzdGVyIGNvdWxkIGhhdmUgYmVlbiB1c2Vk
IGJ5IGFub3RoZXIgb3JkZXIgKi8KLQkJaWYgKGNsdXN0ZXJfaXNfdXNhYmxlKGNpLCBvcmRlcikp
IHsKLQkJCWlmIChjbHVzdGVyX2lzX2VtcHR5KGNpKSkKLQkJCQlvZmZzZXQgPSBjbHVzdGVyX29m
ZnNldChzaSwgY2kpOwotCQkJZm91bmQgPSBhbGxvY19zd2FwX3NjYW5fY2x1c3RlcihzaSwgY2ks
IGZvbGlvLCBvZmZzZXQpOwotCQl9IGVsc2UgewotCQkJc3dhcF9jbHVzdGVyX3VubG9jayhjaSk7
Ci0JCX0KKwkJZm91bmQgPSBhbGxvY19zd2FwX3NjYW5fY2x1c3RlcihzaSwgY2ksIGZvbGlvLCBv
ZmZzZXQpOwogCQlpZiAoZm91bmQpCiAJCQlnb3RvIGRvbmU7CiAJfQpAQCAtMTMzMiwxNCArMTMy
OCw3IEBAIHN0YXRpYyBib29sIHN3YXBfYWxsb2NfZmFzdChzdHJ1Y3QgZm9saW8gKmZvbGlvKQog
CQlyZXR1cm4gZmFsc2U7CiAKIAljaSA9IHN3YXBfY2x1c3Rlcl9sb2NrKHNpLCBvZmZzZXQpOwot
CWlmIChjbHVzdGVyX2lzX3VzYWJsZShjaSwgb3JkZXIpKSB7Ci0JCWlmIChjbHVzdGVyX2lzX2Vt
cHR5KGNpKSkKLQkJCW9mZnNldCA9IGNsdXN0ZXJfb2Zmc2V0KHNpLCBjaSk7Ci0JCWFsbG9jX3N3
YXBfc2Nhbl9jbHVzdGVyKHNpLCBjaSwgZm9saW8sIG9mZnNldCk7Ci0JfSBlbHNlIHsKLQkJc3dh
cF9jbHVzdGVyX3VubG9jayhjaSk7Ci0JfQotCisJYWxsb2Nfc3dhcF9zY2FuX2NsdXN0ZXIoc2ks
IGNpLCBmb2xpbywgb2Zmc2V0KTsKIAlwdXRfc3dhcF9kZXZpY2Uoc2kpOwogCXJldHVybiBmb2xp
b190ZXN0X3N3YXBjYWNoZShmb2xpbyk7CiB9CkBAIC0xOTQ1LDEwICsxOTM0LDcgQEAgc3dwX2Vu
dHJ5X3Qgc3dhcF9hbGxvY19oaWJlcm5hdGlvbl9zbG90KGludCB0eXBlKQogCQlwY3Bfb2Zmc2V0
ID0gdGhpc19jcHVfcmVhZChwZXJjcHVfc3dhcF9jbHVzdGVyLm9mZnNldFswXSk7CiAJCWlmIChw
Y3Bfc2kgPT0gc2kgJiYgcGNwX29mZnNldCkgewogCQkJY2kgPSBzd2FwX2NsdXN0ZXJfbG9jayhz
aSwgcGNwX29mZnNldCk7Ci0JCQlpZiAoY2x1c3Rlcl9pc191c2FibGUoY2ksIDApKQotCQkJCW9m
ZnNldCA9IGFsbG9jX3N3YXBfc2Nhbl9jbHVzdGVyKHNpLCBjaSwgTlVMTCwgcGNwX29mZnNldCk7
Ci0JCQllbHNlCi0JCQkJc3dhcF9jbHVzdGVyX3VubG9jayhjaSk7CisJCQlvZmZzZXQgPSBhbGxv
Y19zd2FwX3NjYW5fY2x1c3RlcihzaSwgY2ksIE5VTEwsIHBjcF9vZmZzZXQpOwogCQl9CiAJCWlm
ICghb2Zmc2V0KQogCQkJb2Zmc2V0ID0gY2x1c3Rlcl9hbGxvY19zd2FwX2VudHJ5KHNpLCBOVUxM
KTsKLS0gCjIuNTIuMAoK
--000000000000d132d3064aa51ef8--

