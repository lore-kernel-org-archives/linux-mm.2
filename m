Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC94CD10F20
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 10:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 187F36B0011; Wed, 26 Nov 2025 05:20:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1116B6B0023; Wed, 26 Nov 2025 05:20:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F421D6B0028; Wed, 26 Nov 2025 05:20:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E22BE6B0011
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 05:20:13 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9EA65B9BE3
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:20:13 +0000 (UTC)
X-FDA: 84152363106.20.5F1F07D
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7250280005
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:20:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=ivgQ76Wa;
	spf=pass (imf30.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.178 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764152411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SMlngkIvl5JGEozo1jxZDpYbFOsUahvrlyWvC/X9pBo=;
	b=cgTgaVcPlwMKD3qRUKSF9Xh5gksflO2GVGaN3S2S1AVmt4PKj6icBxSXZ3B+Zmfku1WpRI
	PQyF9X3B455M+qhEY+QaHCLdhD1n9fJji28jSgLkJ8VFb5N9wcD15q6+K5Df9yo0aj7Evo
	vSzWrhFfGB5EUYe5fDUuWqjttK78gg4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764152411; a=rsa-sha256;
	cv=none;
	b=TLZQGK4FjLC4fXF75t1+X7DE9N1oZw08zgAl6UU7cfSboZ7xwKR09UEHt6Lc6zCAzS506M
	9HKhA99s9qzngrGzhhciuBTAPJg7EF3J0iGsCHKv+3IYK0rtpGR1xywIcddEaqjXHR2PRV
	mAnw0tcmf5TWb/dNmG5qcIuxal6Emlg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=ivgQ76Wa;
	spf=pass (imf30.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.178 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4eda6a8cc12so67816341cf.0
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 02:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1764152410; x=1764757210; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SMlngkIvl5JGEozo1jxZDpYbFOsUahvrlyWvC/X9pBo=;
        b=ivgQ76WaQLEwUDEZH6IUkDugQ/DjjOREbgZWdFKHkLJuF+W3gZeRF6SpsNNwuSI2YW
         ruPtoRwnZvN/qP96xEssnVUSezfDTm7pC8gYIMYk/3N2d1egmF5eZsJi9zNb0remEcMm
         HSLdXD3lhj0fU9d/NDWVEaltEU8BgrUWL03us=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764152410; x=1764757210;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SMlngkIvl5JGEozo1jxZDpYbFOsUahvrlyWvC/X9pBo=;
        b=sY+5UYQSdy64CezrFYhTF3aAtaA8E7yK1aB5VuTfSYzyZChOzcgQC58AshkhTpfcpA
         Idfj7Xw/l5vQpgOeldtRjJViOInAebUov8Vu16fSZ13hZelT/4ShxxntyYdQS7Wsp3eh
         4GxkXipYtf4spKPOfuPw84bjSYYGoN8/unNE1jwX95PDTEdcjM1pIZnVLvbUVYslFtrJ
         W85q5CxJlx7icpQ462H/y2qPlZFtrNfHdndrKcxvyYo4y0G0Ptnk6TrfFbEAfVhNlowf
         EQDdOTOGsK0bYLZ0z2yUkhbIXFwuff7rDTr4tgnxzZxO6ShlJ16WUdv83y8UE0huerAD
         OUtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeO/0zxQ6tbFRze3ccCbVo9yBKsj4Z5WieyH+45yaQx1aBDPpklXxp+uTZx+dqKCo8C6UgO3lUAA==@kvack.org
X-Gm-Message-State: AOJu0Yzo+DEWQCEEfDgLEXXuTL425ErjWhGNdPPdjMW6tz0xOB0w73kz
	oJwR8Jfz0vqW+jZs3i8wgw9055Cb7KOQ5anYHDK4NNs3VdKrQJC2Wc4w3RRL1FghRn0nWhDdbrR
	iIZhxhOzRvYhTyYzGyIOOGSjMWfT20Rp3fbdmuqZUag==
X-Gm-Gg: ASbGnctEykfVg4Zwc2tXNoA5L44NYv6tYfMxwLCmiTBoQ8f4pA6FZT2zokv0/cc5mUA
	czo8KShur+wxeuji2jspTZxjSn2fAcbNX5QMVD2tCQudqk1UIl3HYmfWVVHciupmv3wLyN3w6Zd
	vTmu1P4On0aemd+/ZuxnWDLhmqQU5xt+z2dnvx0oEVvAQnuVlI1DfxYmMcBRSdDZwnb1VVSD5cO
	ol82c7JQfDpy26cflsgNFNWlLWAfKyGFXaKD4hKffvLIYpqgcm/dkJirDRA5KoEIh8mKA==
X-Google-Smtp-Source: AGHT+IEnogSp3RkM1aqfD2IIA6sf5bROWejdu4XbeOX5zYMUXNneObTvydXkEeizuFkGuY86XncpCAPksW/LZ6kZV48=
X-Received: by 2002:ac8:5887:0:b0:4ee:1e95:af68 with SMTP id
 d75a77b69052e-4ee58869cc8mr232624171cf.36.1764152410434; Wed, 26 Nov 2025
 02:20:10 -0800 (PST)
MIME-Version: 1.0
References: <20251120184211.2379439-1-joannelkoong@gmail.com>
 <20251120184211.2379439-3-joannelkoong@gmail.com> <5c1630ac-d304-4854-9ba6-5c9cc1f78be5@kernel.org>
 <CAJnrk1Zsdw9Uvb44ynkfWLBvs2vw7he-opVu6mzJqokphMiLSQ@mail.gmail.com>
 <f8da9ee0-f136-4366-b63a-1812fda11304@kernel.org> <CAJnrk1aJeNmQLd99PuzWVp8EycBBNBf1NZEE+sM6BY_gS64DCw@mail.gmail.com>
In-Reply-To: <CAJnrk1aJeNmQLd99PuzWVp8EycBBNBf1NZEE+sM6BY_gS64DCw@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 Nov 2025 11:19:59 +0100
X-Gm-Features: AWmQ_bnDs-zI6IGEuS8Bbkec8ad8AjyVcDCWKJHD7VX2hg0God0fyW2FOWPEJEc
Message-ID: <CAJfpegvH=5bA3B=6Mkjs_X_RtXV+=bCnGCV7Oc_-rAy38-uZ1A@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] fs/writeback: skip inodes with potential writeback
 hang in wait_sb_inodes()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	shakeel.butt@linux.dev, athul.krishna.kr@protonmail.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7250280005
X-Stat-Signature: bx665teuacwhdgp4d6p8uphp7ng7qti8
X-Rspam-User: 
X-HE-Tag: 1764152411-439885
X-HE-Meta: U2FsdGVkX1/VdSCV4nyG8uubeCQbfpOBqIyapixzS2uxWS1rZvR8BQxOdAbLs0+5JEMZUR2sVftyjBQrxhDwkUy71xcolOTJwJEtHyyxd7j+MATNSGKPmfOja7uUZqSGAXuCTYOkK2KdR1qb3VcMKopoQ/ZMBbtMxCui5t5KEIzvOno7/K+8byyw6x3esY/+a0Ah0ODTogNX+AaKqZafb0V/Wr8anuR1v2UPvUWIstkJ7x+9gba5+GV7994Mk7hd5FryGGzxLIZltAYxtCbTL6BSVD1j+g4DBMviNUZCD9dXO5Nv7l2w8X2S1VygvOiaHNBuRAB24uOXxIXvHsMUzrtTn46gsVCOVYUdsAWKdtvsCsP4w9a9LzPkuTY+mLp0MEsiIukjFob4gK6NctMWZ44Rj/YllNr1AvBCoaGQJhKWGjx/6xIwEMZgOHUZFDMMZQuQhBFl2+Hv5B12/gFSlvBqxOpJw6QebOak0FOWhDy59sD3G7RFNrbMoqLyTBIgX4R6z4WxpVK6P99SujxDSRdA1QZ2DSBPwdCZ/vfU+R4EKRrOUijHr5LT9gXEndeg6eQWHM3TEqPYcL+rQQ7MFX4qFDucfRA5rWaPNKOO1KqbB3Z1ORmUzdfouBvVhWpBfAKsHMfAlxe9YPJz8lq4UuTS4QIocm0TxWymC64VCLNnCpLsOvmfD92epZXVY65rpXpKhIiLOAXSlOCG3GQThznnDeooXv8jblydfoLg3bDbBQUVBa6pbn4TZ152kmXoOZPWRyPUlgTOKCnMjf4fwZbxXvgwpKEN5AzCcwjMA3tOUX0fyHA8XLH0NhsXkcYfkwgtNs7qGAG3A8oC1zKsodtBS13SrYE04124A4eIH8T9pwhZBXjEmwUqMTtGdpHSMpZpT8Kc/en3SATrXqz20xGJ/G2eXLs2pX1TB2XkOUNAQjJf2nyoMw+YDH8Uh838peMOmPtD7n/6Vv/c3JN
 sq31IJ4Q
 CcuOpsGJ2DPi389bHBrLAWYUe+QBA6goC24xnPc9iO+IU35HyXliFJ4VkQyjMAkG94+sIewT7A/duKVnp7QeyxqlX6pO2PQB+kAJZMH/o7z0YeUrYndbbO4sJEhMX5S5/LDjMIbBPt/AH+cCIQmLP4cyonPi/12mXxXKoKGCxT+7zHaiU0qwC9BPGBrOgdJd/Yum35RqEGAtxBuVjupWZrtvvI+2iNKg14LtAi+Aznc7CKAH3L+T3oqH1zPhdk7y+hrqNIpkqWb/yiiA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Nov 2025 at 02:10, Joanne Koong <joannelkoong@gmail.com> wrote:

> Prior to the changes added in commit 0c58a97f919c ("fuse: remove tmp
> folio for writebacks and internal rb tree"), fuse didn't ensure that
> data was written back for sync. The folio was marked as not under
> writeback anymore, even if it was still under writeback.

This is the main point.  Fuse has existed for 20 years without data
integrity guarantees.  Reverting to that behavior is *not* a
regression, it's simply a decades old bug.   And solving that bug is
darn hard, which is why it's not an option at this point.

One idea to limit the scope of this revert is to constrain it to
suspend.  I'm not sure how easy or ugly that might be.

Thanks,
Miklos

