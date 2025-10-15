Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64192CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D9268E0015; Wed, 15 Oct 2025 02:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8891E8E0003; Wed, 15 Oct 2025 02:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72B518E0015; Wed, 15 Oct 2025 02:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 583208E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:25:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12FA613C186
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:25:04 +0000 (UTC)
X-FDA: 83999360928.26.66E691F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id F37D84000D
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:25:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PiKtZFpZ;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760509502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phKXfFaSXLYB4NYCAiBwYVIyNT5jg6GRG3p05HxUauk=;
	b=NYiED2de/22SQ8VLDxLhd6x0m7Gz9Xm5A/w2LGe+mh8jEsCeo3ZCu3BxJT2lYNr9m0DKKS
	+HCwFtr9fMJ2+hDvW8IZ7LdSlwzlztL0vP3H5Z/ONfNufk0Eoxmac2//hrQ37n3EX0ximt
	jfjC97EII5S4L2Gdz8Xxh6TDXgmujVU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PiKtZFpZ;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760509502; a=rsa-sha256;
	cv=none;
	b=q5P5Olw8hfVPOZEA6uEamxKQYj4wAZqjySCffSnU9fS/p1Njr84t8/9ETFP0q4abJRY5Ro
	wMcW5urvx2DeAcw21cB61zkOdeGYrugHcNKBSQtyKfyxB+HB40NAiwUpd++jxjBRKSIyB7
	BIhrQil9cDP/8skFFF78fun+3EFZ6Z8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 20BAC4042F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BF7C4CEF8
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760509501;
	bh=pZJuh4u+Wckc3opz74s9rjUH1iok0eEmafSlcovrAVA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PiKtZFpZ/G/Z1nWNPZTP8D4QBQPDY8JfodapEsRHdXEKRUmrVDwYjTHYzCnN1qcmH
	 5D4mAdG/euHtgNYRCs3r5W2irDzmxn8OznW2H1QJ4Mjn1EY1d54Mg99P0Ah/hmaSwz
	 icjV0mPv89yBwkBd3vmVICM6yk0kM8bFHeYn9ePqENnOeA/FVjqn0vjjO+QTir7pou
	 4l4G1wT5q+v6KKolug28q05W7+iyp90zmb7AdBlx/vZZTEW021IY8GZYHhUrzjLKLt
	 76xy+YuIRqBnWv/+x65CuB9IiHMJkYjAc/wClrezxeSU+ynMTj3IcbY7Z0kn/SOztl
	 o8swyYZEEn1yQ==
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-63bbf5f77daso6063415d50.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:25:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWsjHqnsZVKAA9Y8ZylSg00wQAxHjkbrKjiHl4Vy+jRDltMqgTSdDhElJCU+1BpVKKHsy14phaknw==@kvack.org
X-Gm-Message-State: AOJu0YwQBssMBAUDZtS1A6COAtKb1QW/va+ZoXuTsIJR9WS1doKNkqJB
	yHrbZA6ZOEZ2tFEd1ZdoSBqIjpN89OAtiD2JQtDLrXz0jiLNg8eaAbOrUaGU14n78ngNXkd/UnK
	5ScEYxmoVCaCS+Ogrj5ed9L5mzttzFvWsqAgV5ABALg==
X-Google-Smtp-Source: AGHT+IGfF19z5Nt3Q//yRr5siPm4gefBEudTCYAcnLeqioDlOfjCLmxp0vCQa7BF9yVdHGAgnf5gopzxje6xAtkMqlw=
X-Received: by 2002:a53:dcc6:0:b0:636:1f9f:3071 with SMTP id
 956f58d0204a3-63ccb845082mr19939654d50.15.1760509499741; Tue, 14 Oct 2025
 23:24:59 -0700 (PDT)
MIME-Version: 1.0
References: <20251011081624.224202-1-bhe@redhat.com> <20251011081624.224202-3-bhe@redhat.com>
 <CAGsJ_4y4CLu7qeHijhJtL+NDrehfiWpu9mtsVGxmn5rBy03v0w@mail.gmail.com>
 <aOx42iLkuyYqXBMW@MiWiFi-R3L-srv> <CAGsJ_4zSeMfiy=9Pa3A3UtdNigOc=w4eWc1KQpkBbD4AdvmPTA@mail.gmail.com>
 <CACePvbVfRCdGaqu4SgB0MnZWUgBRDH7VJxs=XxrLfdqjU4z4Dw@mail.gmail.com> <CAGsJ_4zzLYyGDuZbMU2j2nqatjLi1kP_eJ8XA3eA1UqN3JgWvw@mail.gmail.com>
In-Reply-To: <CAGsJ_4zzLYyGDuZbMU2j2nqatjLi1kP_eJ8XA3eA1UqN3JgWvw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 14 Oct 2025 23:24:48 -0700
X-Gmail-Original-Message-ID: <CACePvbUa6T=gEpY7yCOwTL0m7Jum6eiBh-OAmdq2+BPjo-YSoA@mail.gmail.com>
X-Gm-Features: AS18NWD2r5aWPgxZPePPjYZ0hw-2QuukOiDyfrgEJ5RTtkjBEK25rS-ASWBrEqg
Message-ID: <CACePvbUa6T=gEpY7yCOwTL0m7Jum6eiBh-OAmdq2+BPjo-YSoA@mail.gmail.com>
Subject: Re: [PATCH v4 mm-new 2/2] mm/swap: select swap device with default
 priority round robin
To: Barry Song <21cnbao@gmail.com>
Cc: Baoquan He <bhe@redhat.com>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, youngjun.park@lge.com, aaron.lu@intel.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F37D84000D
X-Stat-Signature: jr4cuukdnc8mafaejuipn9unatbf1jg3
X-Rspam-User: 
X-HE-Tag: 1760509501-448113
X-HE-Meta: U2FsdGVkX19AE0mYAILg2BxgMfOuGG+EcpZ4CRo0oruBjGc3w43HxBcs8bEf53QYcfyJcEM+GgkIkGDc7gVhtbrE4h4W2hVnY1EyXCA/BHNNnVCC7ecZ/SWeZJ/aj1rcQzm72COhLla2QswqtxYuXxSrNJt6B3OIuvxuShbAdRbMUMm633Haz9BvCZIKGYj7rAV0/Ys++6SkxvsQ9qPQehhpWSBfbW5WD2hqh63mLhiSNMbokfoSe7JklRe0shlp6aHerh9tUQh/hP3N1bhIahVviINpGTSMSjVduHjmo6RY9TDwyE/4WVwnCtx111mbAELU57GB058DEPNxzs1MBSIz43c5VRhyxk/qGSv0ZH7JovriZLSAhqh+jjcd0pjZE2XkGFd0gyrLj4MULsjkVossGisOpbbdJdcwo8/YSFSWSO0cjyVzWvWQtwxuIk6Jcxrtv4rHGZBKUvjxb3mMglJnyKHA67H/UyZ0//njGzsQeOoxe2BfyvXEpiZY9yChiG+riylI9mhWOZN6GN6XiFy4aozrJsDHKpK5JLAT2qznWvEWP07/0KY90O7ajOcVy50Q5GWKOUA7rVPJ6vmMeV9hU46T1rTAnEn1WAJ51ICnSeDyf04TdbMau6287NGSt3jqbUDsYoJwDIAI2ZoB6q8ZS0wr2ntDPPdREcOQWR4P2UpuVIi2gm5Jq1Y01TX53xGJKA8tdUe7XFLuTQ+7uFQpLjncxQ0mnYYiZxOffbzs9uzxmttFDihQ0Tz80U/bI9XjQ2MBhqKmSTKs7DG3yCWlrPINsajyZMcHT9Svx0pvs1XGCdCxWzQB8TyMiTWR8ta6VbpSCegRUfeQ61gIGY8TwsDMcL5LOm7mIH6Qai0FATHY03HL6uZRb67BH2dKfqiW1wEgsqh31hTyGsbSqWQ/6/9UkND/T1TwenaQMfqGHEH/6n0i6fUSiCceGw0N5QQIpyUpX1jsvy14gVB
 q0h2TxCc
 nzlJqNHgQKfIErlfF+KODhSZt1SxyMz1JXEPoFbAemYH0R9fyP+DlkUcxKC3ZnNDVCr5B66EEQXdPDL6ENF1GNy1A9xO0o9IU2ot4cIto5Luh4dlgjUXWLFAFUYue2phtyQkQQ5xT/A1kl9OkTBPnEsG9Ti27CGXoX8426r50d3lP6CBr2PdUz6z0sGq6JrYuWqEmzwgEzQpGMnnAPXGlKsxcmL+TJXI9LbV9jltVMJBqSeu1oKCyrbDJwk7YysP8k+6qZDeRouKiPZPwZKqxv901v9I14Y1Sp3o3Pr7tufyPWOaVJRCrbaENnGztCqMT6AqaYu60yAw4vIE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 9:29=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Wed, Oct 15, 2025 at 6:49=E2=80=AFAM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > On Sun, Oct 12, 2025 at 11:17=E2=80=AFPM Barry Song <21cnbao@gmail.com>=
 wrote:
> > > >
> > > > However, after commit a2468cc9bfdf applied, above behaviour had bee=
n
> > > > changed. I can give an extreme example, imagine on a system with on=
e
> > > > NUMA Node, node_id is 0. Then I swapon several swap devices w/o nod=
e_id
> > > > value (namely node_id is -1), at last I swapon one device with node=
_id
> > > > 0. You can see the last one will have the highest priority to be ch=
osen,
> > > > then other swap devices.
> > >
> > > I assume this adds logic to prefer swapping to the closer swapfile fi=
rst,
> > > while still maintaining the old behavior for non-NUMA cases.
> >
> > That commit a2468cc9bfdf changes the default behavior of the swapon
> > which does not specify a priority.
> > If you claim the revert breaks the user behavior, that commit also
> > breaks the user behavior as well.
> >
> > > > So I would argue that if people realy care about the default priori=
ty,
> > > > it has been broken since 2017 when commit a2468cc9bfdf was introduc=
e,
> > > > and complaint would be heard since long before. While we didn't hea=
r
> > > > complaint, means the default priority doesn't really matter?
> > > > >
> > > > > Or if someone sets up Linux assuming that a newer swap file will =
only be
> > > > > used after the older one is full, then this change would break th=
ose cases?
> > > >
> > > > Hmm, it could happen, but I doubt people really count on that. I wo=
uld use
> > > > 'swapon -p xx' to specify explicit priority to make sure it. In the=
 case you
> > > > said, swapped out pages will be swapped in, it's either not guarant=
eed.
> > >
> > > Personally, I also dislike the behavior where a newer swap file
> > > automatically gets a lower priority than an older one. However, since
> > > we have a rule to never break userspace, is this considered such a
> > > case? Or at least, do we need to update the man page as well?
> >
> > See above, we should update the man page as well.
> >
> > If the a2468cc9bfdf can break user default swapon behavior by
> > introducing node_id in the first place. It is totally justifiable to
> > break it again to revert it. I fail to see the logic why the breaking
> > rule only applies to the revert but not the commit introducing it in
> > the first place.
>
> I=E2=80=99m actually referring to the part below, which changes the defau=
lt priority
> to -1 for all swapfiles while it used to be -n, -n -1, -n -2 , -n -3....
>
> -       if (prio >=3D 0)
> -               si->prio =3D prio;
> -       else
> -               si->prio =3D --least_priority;
>
> I agree the NUMA-ID swap patch (a2468cc9bfdf) has partially broken the ma=
n
> page, but only for very rare hardware whose block device has a NUMA node =
ID
> (yes, the man page should have been updated back then). Now we=E2=80=99re=
 breaking
> the man page for all hardware, so I think it=E2=80=99s even more importan=
t to
> highlight that in the man page at this point.

Right, I think we are in agreement that the man page needs to be
updated as well. Thanks for catching that.

Chris

