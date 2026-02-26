Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8970AFD8FE0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 17:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF07B6B0187; Thu, 26 Feb 2026 12:15:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90216B0188; Thu, 26 Feb 2026 12:15:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D92AA6B0189; Thu, 26 Feb 2026 12:15:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C69A46B0187
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:15:42 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E9ED1B708F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:15:42 +0000 (UTC)
X-FDA: 84487259724.08.3C699F7
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4A08940007
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:15:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U1FamnLz;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772126140; a=rsa-sha256;
	cv=pass;
	b=V+qoXu4+t2NNRzw5d86V7+Dz7ONTAf7/Kx7RsqDpdxoJvo5n3lcBw3Fc7Fs0pesrute0Sf
	pI/rjnpmqFGa/D4YgR4dKOciKKF21cWt1ZYT14eD6PwauWSkKF2dWY4rz58iTl7B9NW5fx
	GcLW9OsUJBxDuf6q4FTC3OitbsevIyI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U1FamnLz;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772126140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/iQpjEBm+7t1aXXwsPxPn4AYVoqxecvtnU941+hkiWg=;
	b=u0RUlxOZKK7KHpV8SV12AGRS/ugAn0gY5USGOktl7qI3P/hWk6TCaAWXtcB6kGwrEV8sxg
	P5tvBUkp/eNQy1XZrp6rlmFA6RW1I7tvKpy8ae8fjGHokwHKlejjDUIVl9NLlRu9zmgu8b
	mVXuaPKiRNmQavr0ovvSl4j6B307bxc=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-59e5bfa4f33so918910e87.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:15:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772126138; cv=none;
        d=google.com; s=arc-20240605;
        b=LO3tMQijRAf6vJ8pZcyWIpeTL6pjkdRysFSnEeQKqKYrhDs3b3Fz1LYIVh8Cakiq2o
         llNmSmPGltid6W3uveHdDyvFIBFQfsniDZlYErO3i93eVu4m18ZH8Y6bdf9KbVEVqLOA
         T6loJbTrkjypC6iglB7Zbx8s2KR1jVjRc37TK3Uc3Y6jY5mPdYlxrk4338kd3igVBqUW
         pecjTmJ124Hka8zqngWt1ZZ4pHDO4u9tPrIvMSzZo2F5EGMhkbiiKaGqfQhxdXJYWnce
         2JrPTzdW4uacgAyTBX7YfPZHXirKAzJZV6IeDgJw832i3uApaTbHe0tkHx3bwF1P31lA
         4ExQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/iQpjEBm+7t1aXXwsPxPn4AYVoqxecvtnU941+hkiWg=;
        fh=tnQdkbHfdlhtjTzSn3/5u8tWaxUhJOKGhrntTzWNZDI=;
        b=ZUzp6Nhap9lnOI+ezFMPy9XKlO+dJLXcBHqs5P1xwWmvVhzsTr/xNd8Fih93EvrCWx
         wzoFIow2QylhMrYoSFyFFzaJOz1GgSHLH1MxNamtIqI8w9wf1Gqha0NN8carEjJuzsRL
         H9CIQWMAemv8C/VKTVsYDQI+XAElAJphoEfZeE4cPMxgmy/qt5usGCEwTymIgejaeRyW
         S9v+GRz6+XK3sSYBtc+uyjVxUBocQc40V+oCvnQ/iS17AlrU0X73suFDiwPdamD+4VKx
         c++X4tUBTWGvs8BLhK8Ddes7KATL1mv0wJNU56s8iS7Y/3gKwqmBuRaMhk+It5ch641u
         GEaA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772126138; x=1772730938; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/iQpjEBm+7t1aXXwsPxPn4AYVoqxecvtnU941+hkiWg=;
        b=U1FamnLzf03gDb7AKYnfPvN2R/8EvMuNy9gpael+tfTEVA2ky/dP4ukQpfKPPnldm2
         AfNPZemNcH4LKGh2SixQt4RIZlFsM7t+A/+36o+fFjZeJfJ+wKw0rzQaCE/ii5p+dooQ
         9jQyohx70ed5ugns0uTuwdpzqjwHd0v3PbgLxRFEnQqfeiL7p8F1osZyOv1kl4pO841m
         G1yXfSjtxIfmFZ3luCtzBalTQmaKX7Kdcj6F6LydWJj5E+hOG/XnEIkQ6VjMMtwfI3aQ
         H59Sdb/dWDWClhJx3om2s2HdBhbyWEfzAgeLiQkYH4/QOXvUvfEwUqVnZA6r+Fs5Tvjm
         beIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772126138; x=1772730938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/iQpjEBm+7t1aXXwsPxPn4AYVoqxecvtnU941+hkiWg=;
        b=jKORcP+Vc4is+T1G9YWwtcrwEtddHoyYB0bSaXa4Wy08KGwESf+bcq4Mq9M13EvT+S
         xVBMB7JsvnaFptGN+Ukq4Upyxt6rkg4DJMioptUd/SMras3uGI5D64kKTJf3n3NJT0L1
         bSRlnAAjJdKWCtoiTfLJfkrte/x9eak5p7zq9hkjqzEChhLdOF0+7rGFgu3JcbKZa+DE
         8P3YNabCZTqXKA4nHXAgqlHZx6d2d+PduIDjbYRsJDEXnDzxi7SoTHx85RXA7UKEsEPc
         Ff5qZgZzV3miqMlfPGvhC2qbrVefQj9cbpRc7nPB1A4D0lGUdDDOfKLkYn7DCEqNegry
         rZ9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXcZ01/gJ0/yBnmssfvU72cpXf+JDouJHinr0vojx3FVP2qjMo1CRqUpjkgNXJLViD2PkkAe2foSA==@kvack.org
X-Gm-Message-State: AOJu0YyMoB90uR5W1EgEQrp0qtnUBACysF0AGJAKPbi63ZVi9WmSvWI8
	hfNolFEb8KlyV/yFg4gF1dK3oE6LHYe5c7U+sn9d6bQ+MeJ3b9pNAv5DJxGRJ+jQRvWunGlt9Wr
	etK7tWBsKDgChr0olSbFbwSnIVfPvSvw=
X-Gm-Gg: ATEYQzwbzJIwz7Cm5Xa2RkvSjjD7m7r+cQvjmPBQP6MuUO3zD57xvV+fDJ9cfbLGrdD
	Jxnn5OYWzUVqkTUVfNRAxJwToSnA/vGISmoJM2/Ol0PXKG9vGIs4krESyRuYD0d/LLV8PBCYfuO
	MQTyiUcTxYFG6nuf5Shlzx/v7dPrl8ZemrOpeNdQ3w6Yvtjqv0zXjjSpm5m0Qu2t7gEslltuiid
	aQcpfRYORMW46QWq6UPMldavFGmRZhpfuZAqIgUyfp4Z8ZnsJazrOTb03JkUVelW8zbLtSoMV93
	1IoLvTY=
X-Received: by 2002:a05:6512:234e:b0:5a0:efe2:e8f7 with SMTP id
 2adb3069b0e04-5a105d85002mr1714014e87.5.1772126138043; Thu, 26 Feb 2026
 09:15:38 -0800 (PST)
MIME-Version: 1.0
References: <20260221093918.1456187-1-vernon2gm@gmail.com> <20260221093918.1456187-3-vernon2gm@gmail.com>
 <20260224035247.r6mxsfcpiev4wnce@master> <zo2o25tesjzdvxdbjo6rc7crqmf76z5zwlykrnvhydaowgngya@hv3vgfa7zcgi>
 <1da56bbb-9211-42d7-9b08-3ee56d2b538d@kernel.org> <hbftflvdmnranprul4zkq3d2iymqm7ta2a7fwiphggsmt36gt7@bihvv5jg2ko5>
 <8a5277e0-d70e-4849-9763-ed90e350a118@kernel.org>
In-Reply-To: <8a5277e0-d70e-4849-9763-ed90e350a118@kernel.org>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Fri, 27 Feb 2026 01:15:24 +0800
X-Gm-Features: AaiRm52legzJffa10RBFBIh85WSfEvEU71Jrj2lWEGgvnh79Lw3Jee2w-b-MZT4
Message-ID: <CACZaFFPfx=y5Fy+nwT8o8TA=W0QBfOvTqbJnhVPn8B95SFxijg@mail.gmail.com>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, Wei Yang <richard.weiyang@gmail.com>, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4A08940007
X-Stat-Signature: dwgsp5ix5bbbhukj7cz3wao7gbjr7smj
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1772126140-506386
X-HE-Meta: U2FsdGVkX18jS7yR/Eeyrvxs/nRz71bdqKR52+HxkZYdv4ZUB/4k0EfslJsLqsy/I/mb6ekmWbkdoK9L6fPVnwwWpfyFzSRJUASVbsFyf6cZBz87nucPhZENzStIiPsCGlHsZSXYpOTezGN6jnSHMEEs4waPUx8CoqQW5ehzvOda2IH2YnBtd2wd2wo7cf6YUsO6shk9Hf5QfcaZqkDz0R4eriWDKDbsbVgq5t6g0cZy8YU/ywHNm3qoZ/XVPU/g8Yr4tl1VN7nEOn2eB/jho5MvzPZ2xuutJVW3nSsSASPlrOw28o4oqkIMA/KLBgVAzJtfSUOB2eLMrXJTHTllBJKuHNhNqLspyjV4CVJQxChfEVD9s91FIu0RRpH90qyCIxRK+jpTCuXOn8s57RpzDVNh02ASx1waaFQjJxzHa2MRLAL0fltj4FPHGn4cPNRXREqznux8l93Up3+GsIR8eccZyTuZTL68pzg34s9Z2sIiNG5DjbCsoXB4gC+pmvS7LRVuvgvHS49wlQSk+279CcSji/tZLzp37NR++U5WuhlPVLGwmzVs2CF6ptJMGgJ2LwGwahDXYvmTfLGca6YZ7zQcYYL1kN9UFabYuIA5qoKiRlrxx47rz/58VfXGddabVW2iyihwflxcwIS90hd74LNYThKNFqXgnI+HkgqrlH9rbo34MhkDhTc77cot4P/FZKPe7wz4ESEy0ipxXuuzx1SuP8yABMTTEEWtGH91tC3KYBAeD8u/OodXgutuKLbOpYh8CvXRCEveddkeT8gsswkLaiMyZNpE5r6f7U0EbcrItBpbNQZYv/+dNmomDiXEWFdBRbvg9BehMiG+vtO5BefVMBT1GmYPgTfhXRiLcEDnHzxkRN2E9mllmlCE/0btwsKBJtPCr/dYHxpggFq3Ttn0eRjR2U/1rSA+3rPoqysvMcFU5bfNn7nylqpM8ena8aMXK4VxazxIIpo+5ob
 fKcEljJL
 bsdkWrxsJvatmVYK+F0Rc//laHcvL5WACU/KqL9vdLF1exb7YYLDPSX0/kU8wmX8Bzh5DQPoGgflTRd0YI9cSqwr7v2un+A86W44VTnY+heDUgWYBFkt3OWsfBvjNh8eJoLdTXtmZTdnsUHFGpPDgBNGKdVOdMZ23j01aYqh+sbSLd7afzkOVHezb4cYVteELyFi8DqVAaclgsIxkE1kLF6x1PzFu8mCXi5BJxrZu3cc7JUFiMwwJ1QgEO9PWzK7cRo+Bm2XoZ1fpRpc3VmHbkhMLWufkyiu9Dy/KjQk5GsILcMbKYKOwpgulMx0JBodzlAsZ+uI1VkJ90wjM0YgNB0h8ytjIKCrRwpE1hblwqVA6Tie8TClB/uNmmCE4plZNZOdTeSZbpg2bjipdFH18xWVovOWUjcGlznGHOuymjynwlgn+NMDJOFUPxRbiKiiRSJqvmqluwxHJ+P00iV9LVJj9lr8cgnvKYVd0YWebSszHbLg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 11:45=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/26/26 15:31, Vernon Yang wrote:
> > On Wed, Feb 25, 2026 at 03:29:05PM +0100, David Hildenbrand (Arm) wrote=
:
> >> On 2/25/26 15:25, Vernon Yang wrote:
> >>>
> >>> Thank you for suggestion.
> >>>
> >>> Placing it inside "struct collapse_control" makes the overall code
> >>> simpler, there also coincidentally has a 4-bytes hole, as shown below=
:
> >>>
> >>> struct collapse_control {
> >>>         bool                       is_khugepaged;        /*     0    =
 1 */
> >>>
> >>>         /* XXX 3 bytes hole, try to pack */
> >>>
> >>>         u32                        node_load[64];        /*     4   2=
56 */
> >>>
> >>>         /* XXX 4 bytes hole, try to pack */
> >>>
> >>>         /* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- *=
/
> >>>         nodemask_t                 alloc_nmask;          /*   264    =
 8 */
> >>>
> >>>         /* size: 272, cachelines: 5, members: 3 */
> >>>         /* sum members: 265, holes: 2, sum holes: 7 */
> >>>         /* last cacheline: 16 bytes */
> >>> };
> >>>
> >>> But regardless of khugepaged or madvise(MADV_COLLAPSE), "cur_progress=
"
> >>> will be counted, while madvise(MADV_COLLAPSE) actually does not need =
to
> >>> be counted.
> >>>
> >>> David, do we want to place "cur_progress" inside the "struct collapse=
_control"?
> >>
> >> Might end up looking nicer code-wise. But the reset semantics (within =
a
> >> pmd) are a bit weird.
> >>
> >>> If Yes, it would be better to rename "cur_progress" to "pmd_progress"=
,
> >>> as show below:
> >>>
> >>
> >> "pmd_progress" is misleading. "progress_in_pmd" might be clearer.
> >>
> >> Play with it to see if it looks better :)
> >
> > Hi Andrew, David,
> >
> > Based on previous discussions [1], v2 as follow, and testing shows the
> > same performance benefits. Just make code cleaner, no function changes.
> >
> > If David has no further revisions, Andrew, could you please squash the
> > following clean into this patch? If you prefer a new version, please le=
t
> > me know. Thanks.
>
> Do we also have to update the resulting patch description? Patch itself
> LGTM.

No need to update the patch description.

--
Cheers,
Vernon

