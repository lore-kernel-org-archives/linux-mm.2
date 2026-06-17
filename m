Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F621CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 22:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 140D86B0088; Wed, 17 Jun 2026 18:07:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2E66B008A; Wed, 17 Jun 2026 18:07:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F22BA6B008C; Wed, 17 Jun 2026 18:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C65306B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:07:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 34C0C1A05A9
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 22:07:44 +0000 (UTC)
X-FDA: 84890792448.15.D6B950A
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id 303B540006
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 22:07:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pxdqbL3x;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781734062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dxvS3kwOW4bWC0xsZqNZINpijY+mWNOP8Io4oLdd84w=;
	b=Bw0aa1bVar9rDREEMNyt20qUkxlhWWOTW6prie/dPWetXLPTWtnR+5aIDU6YoXydlunv1e
	zd2w4DTtGfOGYJIK/8PwCpGggiwpHY+sJZYxGhsST/5wHXJzXrs2IvMiV/O3Mg9SpiOO4u
	4YFvdGYyXmz8FlFEMGJFJEB9DNgGaU8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pxdqbL3x;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781734062;
	b=Se4cVv7KWwQe8DeqoskJDhgrwdpnBNgsjrSFHL6jQmmJoe29YgF87TaqWUu+TSAqE8OpvM
	e3up9WjafCz4YR8FuhAhNkj8sJLrZGtgy5CQz8yU2nS2gevDR8QJP16xINvnozosTTVZKV
	9BWMzzu2VU4QGNRmY9ltRGIqhV0oE44=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1390f75d8bbso685638c88.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:07:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781734061; cv=none;
        d=google.com; s=arc-20240605;
        b=EOa39gRwfyg4+vRqobYybFhavS8j9Z9f+IAzkmQRpa8UcCl2cPKNr6NYjn/f6BAI9I
         DMJhpm+L4dU05cbxfNClmeJGyjckw21Ryg5v4Ubj50jxfp5Xib8G1Ntgc4HCNPzLwdri
         qNfVdgC2qhjh2ECDV/rAs9XyLg+6SczDAb9FKCnGNGR2UXb7PPppkJdsLkdeVSSNkJMq
         X7WKXRSY0LUhUv1hzJ2ThNxlLA3KDRUSTyze3b6QCnHtlsZWVRrUmTuxyZlYjZm6BNEr
         Ev/6PPsoOw2w1TKjbKrhOfPL/xBgOiRD9JZLIk/WDYBRk62MCAmUbLsILzadCPA+Tvgo
         zTOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dxvS3kwOW4bWC0xsZqNZINpijY+mWNOP8Io4oLdd84w=;
        fh=r9A2OBiQUlQipiHN7oOSbRjfIPJgxdyS9QGzLNLkYo4=;
        b=aMQE54jHMD+gN4tpRT8NSDvgIScii5AnMCl2TZU3TLWT5aCxk2FGbiwFCC7STDhIH4
         89TNqFZV1eF7dhSpaXrio0w4LvBqFslVJqLOYWR7AJAQqZpe+Y9p/VbSLNcVZx7SrGow
         tZXZDljovJdetAPY9vcyioqVlkSNqJJxkhAfPW73CbF/C4H26jZAZCRk4tBmYJpStZu2
         xRJKFLm85cAWpO/C1WtAsb1GDM1vSHvZIWam2MnHQ7PrP1VEcEIcQLjohzaSb5RI/F5r
         XSQoBl9LT1J4TCoWDVUJnWyY0A9pug+rTecAm2PlzljKm+P5h6O8rCMu4R2fTy+D+70N
         cNAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781734061; x=1782338861; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dxvS3kwOW4bWC0xsZqNZINpijY+mWNOP8Io4oLdd84w=;
        b=pxdqbL3xK0zXOMAJo8ege2R1D2GKVMgAF3oJ8oGnOhGisv/cctmpeDHseP8MbxT03V
         zQEdy3ruaomfMSxRtb9bFrFh57rt84WYPafm9ehajlZD6dqRZ/eR+HBnioGG5VlHrv3h
         M3SHgB5x2avq2h2g5BOW4+fb1ep1ILkeP0KTXkWghbJsNRcpI+g68y1eEbAhS+kqpeQs
         bNb+BD1P8DOkzulbfOOGXANIkstiBcOc5XBjt/6oK+/V7QWbyu62rY5mVyYRE7X+/RzE
         Js/PpLBHGNj9t7qmEAhSVaiRl+xU/Hoe1n2+LcUinXm4GPRYEEewGw8gryUW47vqs5b6
         Gwhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781734061; x=1782338861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dxvS3kwOW4bWC0xsZqNZINpijY+mWNOP8Io4oLdd84w=;
        b=bLrMMtwxzuTwS4td8gu27nSMHmUfhishMHOaR4QGP7r0+23DiNqs3P7oovAWskVRbF
         zGaGnatQAnDtkpxB0Y3DgbIDbtbRVgARUKKZkaRPuLkqLJwztqO4z3Jm4/Jq/pf5pYLs
         SxTkG1kbdYVhonSHBI/G27u6Rp7j2ztiJBaBaXV3U7zL04yfwHP8WwuIK/IJ6C33Ye/5
         H0osm1wa+jwg5/tjprH4Yl0QU/8hfraSumDj1pGsMqD3DE+C3Skkis9UImN5DAJQwP1c
         5UnDS6SlfDFKm1S/DBb6T9aiS1ak51cnLjTExQXKohfwDgKo1zyMIaSZDKvFJxU8LwPI
         HTjw==
X-Forwarded-Encrypted: i=1; AFNElJ89nbkCqcK5BfHs2CS16cPIssJQyC7RMIXI7EU2lRB/yt+YUr8NG9+jYqNbdQJyqmGYRDVYu1jYDg==@kvack.org
X-Gm-Message-State: AOJu0YyANBcN3yXqyuV/ceA4mfleu/Gi6xnqUbpxqIGGxik1UW0Py+Zt
	jjAor44PYbbB2GyIPwqi3aGOZf2T4PeCONvCD0iiWcN/Le/Ujx8kNNhBkJwx7S4WKtA3yo9hR6n
	luRXL6wzMS+cr+6r1m8Ma2H5fJ4djzuoWlV/G1GFl
X-Gm-Gg: Acq92OGDtjRzDOT4cXvxo3lCl7I1SFHPoZ4JOp6hZO+ZYBk+yM9T2Jzy5GixpRauZni
	Vcg/hatMlsucHpPAGUE0VQRzFk2kSOqJpbm5kKsyLL9c/c56csK+sWz2GvUetQAh3wBf5Eg3F9i
	TY2+xoFLli6e5KG+K/be3RR1Z0ijMqh05jcoEfnwAd8IQe7ny1REiuVEFbEO4F7jl95axMH+puD
	ygyhmTxAAdim1s9ZPQDr7I1eulLCD9KTNjpRdhmKIuWfAYlJDvUxZMe7aZ+5EWkDRkcogGFUxQc
	e8KFNfU=
X-Received: by 2002:a05:7022:68a2:b0:130:6c8f:5a87 with SMTP id
 a92af1059eb24-1398f676be1mr2746710c88.13.1781734060068; Wed, 17 Jun 2026
 15:07:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260522202410.3104264-1-dmatlack@google.com> <20260522202410.3104264-4-dmatlack@google.com>
 <178144432039.1257322.9644414453415904478.b4-review@b4> <ajBgj_aSuzMZG47e@google.com>
In-Reply-To: <ajBgj_aSuzMZG47e@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 17 Jun 2026 15:07:13 -0700
X-Gm-Features: AVVi8CfIvfIjd2Q6o3VPNKmTcz60wFd9tOmavE8DEafzVsI6S2ukw3P-Cv2hKdA
Message-ID: <CALzav=cGZs6sUcGFu854fTdH_rKTMBF0NK=+jKE-yE+N64XBPg@mail.gmail.com>
Subject: Re: [PATCH v6 03/12] PCI: liveupdate: Track incoming preserved PCI devices
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 303B540006
X-Rspam-User: 
X-Stat-Signature: od59ofkhgm37jzis3u3oa83gxz9muh1y
X-Rspamd-Server: rspam09
X-HE-Tag: 1781734061-476238
X-HE-Meta: U2FsdGVkX1+zihxgqc3jI2sETpbDp+Fu/wVHha1cQRXA7X5rFxJZalOf3afssIHKxUXzfnAl+twspvCPJ7T1siOMqq9/9tAvJ2auyomIre0TwgchvPno3YDVusjOPiQt6gxRKb+9KbRakrcyTJ929e6NM9CfwH+jBCchlFpGUMU6JxSKFvL3dvs4W4dyj6O4FdLNeTA4I/QYa1Utch/fKK28IFTC0UZibI0QypLxpJyfthoCkM2yrwDxXM8hYCVh8QRVK67KewEMpwtqqJmcyAv2o/G/KTC+VUJ4J03J/lMAkRIY/npxOjZaqlt1MnvQSh9rditsy/g3Eg+A5I7QDm4bwf6ZYWNJnQGXPXI7xRUMZ8r2FB2JjQCK/tjMyluAL1N02U+k7zkhbmWwuheZrtvBreAASmmVEBA/84Ha/ZFSjmGHO6BVQRGw5nNG43SdO70OGT3gY5b6/7MeUaODeHo6xvJkvXELOa1pZoUU/rzda/uI6G1mLzKnwKWYuyJyYEny7EaYirl6Z8psxxh6Q4HtmC7+iQLeyRV/RCK0HXcH/0OcHdvjjLeHaTGCdA8p7oQ6jg2Fg9DOlJJgmFtvvwmjy85gQ0dIU1QeMM1ImuAxhu4fk5v/fMD0otb1HVFHb7LPDQXU7v34K/phkOIPePHFV3R5GFqxyZpzujNE0JxxBQ5ZKpxhnWruno+ug+F3yO/38Vh6XrOaIRte505SW4bD5zmMvzuXVl7kMIr+oHVQ1hOMiTb8GxiKzv+hKbO9yORvu5zqt89pbUdrrat/HZ1OpVjEcBy020u2OQNW2zqrMqsuOcL9BDX85u5pkd7O+IZKRBhpwplW2t4GHp7/fLyOZcVUPWPbfCmCldZFa3xsnFR8oOW8AMg2Cq54Hyw7ILdTCnn9eG7/0rVVwUH1fFaWTrj6G1CUzdgvVrbXkMEwvhmKEeTRgHtlmojwC7TFsZDwBEeF4rJCnbZCiTB
 rQD5kbzd
 GtEplYTqFiOtQ0kou7EbZ2XBiAUk1mAgN08wWUbmtaEF5lEcGQ9KbpMRNNCYENM0tshYyOh6PYUHjKD/X3zY99UwDk81VD6URjBkX9m2y4OyXDllVnD5mikNIVJdrTUV0O0QovsL+rSd2tNpG3ppQvu9sw+jw19QrYSxLBUEslonsyDK92Ey2isYn8GdbxcYyW3kHQ7HqrfL8GjNoimlEOXa3+9TQlc6CIMVp/u6DLD7NFz27NqLsgSs+fcaqAUlXZ2amkWvLWVDa39/iqIUYWJ/9aL9qOgGrHSTC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 1:29=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
> On 2026-06-14 01:38 PM, Pasha Tatashin wrote:
> > On Fri, 22 May 2026 20:24:01 +0000, David Matlack <dmatlack@google.com>=
 wrote:

> > > +static struct pci_flb_incoming *pci_liveupdate_flb_get_incoming(void=
)
> > > +{
> > > +   struct pci_flb_incoming *incoming =3D NULL;
> > > +   int ret;
> >
> > Maybe make the error return static, and avoid another search through co=
mpatible
> > FLBs if it failed before?
>
> Good idea, will do.

Actually I'm not so sure this should be handled her. I would have to
create a statically allocated variable to cache the result, like you
said, and I would also have to invalidate it during FLB finish to
avoid use-after-free. That defeats one of the main benefits of FLB
which is that we don't have to manage global variables.

Can this be handled by LUO instead?

