Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A294FB5E81
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 22:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F24A36B03B4; Mon, 16 Mar 2026 18:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF2E6B03B7; Mon, 16 Mar 2026 18:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA8D76B03B4; Mon, 16 Mar 2026 18:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C3D8A6B03B4
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:30:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BA081403C6
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:30:36 +0000 (UTC)
X-FDA: 84553371672.29.8B8762C
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3F3EDC000B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:30:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kmtKx20c;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773700234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHBApg3dIEw9R1t5Yh73owWQt2Uh584izEOKgKc7ZzQ=;
	b=yO+bVcVtPFgdN7GE3bVapdC7DEQdjBa7bvbNZy1UBpl1GZftEfvtdDgkMFAu9HiyxPytsi
	1EiD5d4WD+phn+4PKuOg+jFXOW3MWR3B//7FKe/QUjSOw0ISTvztflTejnqrqBtdPRtcON
	dz6D8DMeZRf+BzDa5idQWoGmdXTTUf0=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kmtKx20c;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773700234; a=rsa-sha256;
	cv=pass;
	b=PQjCRYtw8YPXCXayX1HL4tY+Qs6jnHRhJTdUginJkmkrtewpdwxUIxPTZlAh+lHmsiywoU
	b0kPmvMYoRejUaXnXMs3wSi62FlhtCEwQQOnj8HJ7xNeDETvI5qJEcXWeKx1kxzcyCqLzX
	lCZVrY7QwWIkInvkyr12CZJqfIbEKe0=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5a12c310e8aso5298141e87.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:30:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773700232; cv=none;
        d=google.com; s=arc-20240605;
        b=dNd//FOSkPv9xzs3UbcJFoyCCTrNnlMjhZ4jM/Y/Jd9Letp8s9Tcmtj8HuKo1Lt5pw
         SDGaGOeW9lJSLI3S9flIgwXB8QJ9Skf/T+l6vTCXX3kKs1HAdOX+jGmlxrAbsZvFzUtu
         FlsLJAI7G+9Qfz3QPbS7TlaCTVIy7kUuoN/htzmrv0d39nPpPYg8U6Ulv1+14/3r6LyC
         Yzh+rgY9Vf+0fbFU3Pe1kOlEgHTt/D2yU1290NSwegMgvHLroFEc3dJmCSiaozHUCE5J
         Zr1hliNeFWh7vptqrDTK1Od/eyqszYuq5O44TWOJIZWj4qAWlZ3rZk/rFyGyS8rug2Y1
         Z/DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NHBApg3dIEw9R1t5Yh73owWQt2Uh584izEOKgKc7ZzQ=;
        fh=hUBjoy3Nz3dAtMHgAXJ1+z0e4wwg+W8+AocI1yo48C8=;
        b=Vyp4O3UV1QgsrQ2MNotpv+bFCXxjOrWnIfSVytngG4bd61FjZsJ43amfKnlJ5hCbr2
         mSlcs+hqyTcRoRO1j8ST9nzqKgOnlatS3pm58Xvtuzf8EZTzgBzoduda6FKUQi5F/Pb6
         D925uvdw2yQSkHtY5PIMfgou63UpnkddzMotwC0bDvmAAwfUc1M+rkBe5kn/Xkrlb3om
         4Mz6IUagTlRjtX9I3DgpgRWrv+XtBvd0kMFMXiqrTs5AuNc6to48U5MULxwpS0xcCkUG
         qWAN0Rb2tMlsevteK2VfOFXgwHsTKEfK/Ryd6aNnBmjG5XOem7YCHDcxemi8fOK0Syko
         sWSA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773700232; x=1774305032; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NHBApg3dIEw9R1t5Yh73owWQt2Uh584izEOKgKc7ZzQ=;
        b=kmtKx20cfRt21Gvu9WfRH5scFycEAqCKpcE6deinGJhgqZi9yy3ACYXd56PLFSyJeE
         JUd7kFl+hOrG+F/quK3S0VOAFPjdKVsw3cU6G69BNMRs3arz8uI6+kRhkDmtm7t5M4hB
         jfb2rec1kMoQIOHQlOq1vnLB1C/nTHXqEgY78zR1/Xh0Sv8/zz5A3JCG/04Q+5rFKb+2
         koVMtYRlw/6x1Q2bAifHE3tQA3hSzlYcewZJf0TYrAHfTRyScSpRAIW6d+5RMqSk3MYy
         kwAyXoU+sPzPM+xAz/eRyA9Vb9//bMsAbkTPUhcQdPYjCd5JiAfKld6upnGj5FqbWDAv
         DDKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773700232; x=1774305032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NHBApg3dIEw9R1t5Yh73owWQt2Uh584izEOKgKc7ZzQ=;
        b=Fy6nBEcHXfWsbX+/HnBEeXEXw5xiP3U+nro+UQAaKbFm12m1Ce4a2tFYp8pIjVIFyZ
         AvqCL+dcGbJoarcnmhZw66IhCharCGh9xzoECTzD5yg1I1l6lepI1XRNloz5PI1W4u9t
         cJv62FPy/QdyoKXUstKU/oIPJXD/PUrmKW1iY/RBkCgCp5obEMNRuxKr4PhiGEEKFXJk
         X3BunBcqif+6aKJphw0YFmsxkSx2cPAkBBpWoHTU2uYfwcX1/EbouFeRaXV5oq37THGo
         EJh4DJalE3xwIpC8lf3I4yykAUAfgoqHkqODwFNj7c6iLCkSxDaLZe9Tz2wXBllMp5Ti
         674A==
X-Forwarded-Encrypted: i=1; AJvYcCW5EjM38OqRJ50hg9u1DNdaKHvngHGuSVB5B3K5I3AArx1wf1I1T5L8UFvqoYEkx+xdoBCLqpHCQA==@kvack.org
X-Gm-Message-State: AOJu0YzswXADuDIMlAdY6mTIHlUD7Oucm0X2MaMH5FdfTMJ0qbqRih6s
	VNxBjKEEdDhVsElt6eqsOiJxRC8CbcJiPhmAQPlj1IPrr5yibVLs/cyWZ/nG1lJdXM5VrtFROj+
	0x1fguck7tPc43QE4t0HscC+Lyr0MNS7FRrY/dQcc
X-Gm-Gg: ATEYQzyVlwdcv6u+yQmTwmrQ4cgN82T7SOsGtkkiPGHNlFv1CEgr3AKZa36GNGm+92b
	EGdGHNFcJXePPmXurP56bLVR5Y6xDQsRyAC2sQ6LmtLYkwKZPm7R4Bov97a0d3arG9/HmgnQCab
	UvcQ8oyHvD0lpCCmFjlnLuMq2ZDeHb/5mXp2zmMCm4PH2qeMu0IB/XHSX2ihOOx46W+q4kMiCih
	k1LXkgxEhwqh17gBo5LPxV1Ox8TEdhdFNY4epDV0L8dQAfYAp2ChjuOUikxD8orlDGM7KK8NSN7
	EiubV4b8pq+2sl6dGRE=
X-Received: by 2002:a05:6512:38a4:b0:5a1:2a64:202a with SMTP id
 2adb3069b0e04-5a162706bf5mr4418611e87.18.1773700231818; Mon, 16 Mar 2026
 15:30:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-12-dmatlack@google.com>
 <20260316215056.GC1846904.vipinsh@google.com>
In-Reply-To: <20260316215056.GC1846904.vipinsh@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 16 Mar 2026 15:30:04 -0700
X-Gm-Features: AaiRm51TsPFqmaxXeg5vtHycDWCNAMtrDhfsa1Ts3dgQ-gFDNbzitmE0jWYnMy4
Message-ID: <CALzav=eKbTiJYz4mCWTmVghnwFLHZOY096Pf=1GYpO_UBixozA@mail.gmail.com>
Subject: Re: [PATCH v2 11/22] docs: liveupdate: Document VFIO device file preservation
To: Vipin Sharma <vipinsh@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3F3EDC000B
X-Stat-Signature: 9m6xstt3zgyhjeuaqxtiyo1riygdgeo7
X-Rspam-User: 
X-HE-Tag: 1773700234-853097
X-HE-Meta: U2FsdGVkX1/sHs8vRDgcfy2EJ3fmvW7ikLT2n9epM+375rviNIA4f9hjEH8ujnK5yfO9GpxRi5lM3N/l/DCHX4OgEoBHqFiNEfM+OQ4gSW2PSx1UrfKKxajuIq1V5kNvfG0QtkamoqIfW4Ge/K0vfvPd9l2GRkliKDOso2yVBAc1/tGl1L6fP8uO/pzs7fEA7/PDtG9OhNsm/ulkChApxZubNg1PwAMI4eJy/BOmD5nGA+0q1rmSii89ODmBFC6EIhqAmbpXvxiotDYLatMaLN9rALwg66oSValsfG4I2nPRBCMZky633uxkzvjlsoqwPQX5scGgdigUvZ66Z7+NJ2tglu9J5WBObu7jrtLsFPiYMy1FT4upuC7WuOHQtG4yOw+Isxzsbth8u9w/M7KxIgDiXRqPluTFyJSUXBMOVWQEPLX1DjmWm7efmL5v/f+54edYJx55fGy8O+Dn/8cVZoIfl4052tvFRBOdJ+EBonaEfpV7t/YUzM+BUiibDBz5SXCHzc2uDzSusfgqFTfHr850NtzGvX06HUgtd9DvvOXeFTBuds7T9mfWnwkrIPLMqKqxd1dMOKJYEfChvXQKkep/PH6RzMZ9xACACwrymsLdFd5ZwbYN5yUzk55pV1e/wgrbKxCZfWYb/M0zwPhYWxO0Z8vYcWbFbKrd+34YHrrlUTS/s6HdM5ouAtw1O2JyuB0FIlVECFNSeuMVTIFb8icOglIhfL/PVinCOQk6dF/J+++R+LhR4bAmDInqTkexbVUjkWQowTuglM1J59QJmT935E8D65NKcn2o6HsTbPq8DI6e+/qnaquNxCR3m+ttx0rLmEyqFVALJw0TEUuNZGoXOxAUp26fmNqIhzrXwkX+MIyLdwM8MHd4WQ0LzKCm4CyJ5UVbqapXcVGP7dzWUbltBHoqdmpwJBJpsyWoOBU87ZxzGBD7ALSoBRJjgPQAHzKvvjO6ctypvHTskOF
 cuc5Mx18
 2cK/6k/g3igLI3y3fmJ72e3M1vOqcyMV38orxXzpUNpKnkGCgc1ynGlh2+oZQnSxUIShaHbxc0azfms4s2nAQvjLv/TyNeD0kQUGQrlpzQWana2FK49xmRrrLlV6MNGk5YbLfXSqaHK1lbysV54B9uZy0D1Ut6pObA0OO41KknFUrbJzHyBNA7iPTnQsCmVOIiSrItucceYDPSBK+5S6qR5gGxlw0eCVMwv4WveT+c6aTUSOYyvTL9uCvmWmDXHtWS5ivBpfj7XWxw4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 2:55=E2=80=AFPM Vipin Sharma <vipinsh@google.com> w=
rote:
>
> On Thu, Jan 29, 2026 at 09:24:58PM +0000, David Matlack wrote:
> > Add documentation for preserving VFIO device files across a Live Update=
,
> > as well as some generic file preservation documentation. This
> > documentation will be extended in the future as new types of files are
> > supported and new dependency/ordering requirements are added.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  Documentation/userspace-api/liveupdate.rst | 144 +++++++++++++++++++++
> >  1 file changed, 144 insertions(+)
> >
> > diff --git a/Documentation/userspace-api/liveupdate.rst b/Documentation=
/userspace-api/liveupdate.rst
> > index 41c0473e4f16..dbf1e4aeddd7 100644
> > --- a/Documentation/userspace-api/liveupdate.rst
> > +++ b/Documentation/userspace-api/liveupdate.rst
> > @@ -14,6 +14,150 @@ ioctl uAPI
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >  .. kernel-doc:: include/uapi/linux/liveupdate.h
> >
> > +File Preservation
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Should we use the existing way where documentation is written in code
> files and referenced here? Maybe luo_file.c for this?

Good idea. I will look into that. It would be nice to also have this
documentation in the code.

