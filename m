Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4F87CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 21:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27A4E8E000A; Tue,  9 Sep 2025 17:32:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252288E0002; Tue,  9 Sep 2025 17:32:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1679A8E000A; Tue,  9 Sep 2025 17:32:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 068818E0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 17:32:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99B6913B9D6
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:32:37 +0000 (UTC)
X-FDA: 83871011154.22.2967E66
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 90EA340003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:32:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=LmBN2UjM;
	spf=pass (imf07.hostedemail.com: domain of paul@paul-moore.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757453555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=asYCnis4mSt6CdqmJGzu+Uw5kUXiEII09UvJhb2qu+8=;
	b=YeHxdBskrpCr7KtR7evRFB192zLggAAU4FOO00A01efSYlKNGQ6Ch+Ns1LwKKGHE1gr9js
	o0UU1TpWoPoZp8JakLVOMjZ4HmlaCdo+G0zYcZmsWYAo5izrT49KxDHSdK+dBPcfPZwEoz
	kfpKu/kZy8gdzok5FW0+IGCz0FXiYjM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=LmBN2UjM;
	spf=pass (imf07.hostedemail.com: domain of paul@paul-moore.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757453555; a=rsa-sha256;
	cv=none;
	b=roATeOul1sPLXIWm3in/Ao4BK91NPPV8uXFrskw6XbZKs+s4Ofu7RDJBiueauWwdreckGk
	As7cqc0lnnhgqOabkwOb7S4aUGBn/H3GS0Ru5qxPw3U+cA9JSHaDTPSTGH2N3X/DxA2+6t
	uVRD43F+adJhaZKUq7DVWSJ8tkkR/Wk=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b523af71683so1868240a12.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 14:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1757453554; x=1758058354; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=asYCnis4mSt6CdqmJGzu+Uw5kUXiEII09UvJhb2qu+8=;
        b=LmBN2UjMIlGCx1VS/1H3K1QFfhJ2ycSoRiAFHbtvMayJ7Cqic39lw4NKfnBeu30LYA
         xCJRV7wiAFJJqWAe4YNlIdPMLRoRPSodLlOvTSKkFIjH/xkk7ZkGcPllnwzZwsgRUQ7O
         MZfPZqGL62qDObD8ODOhLglUWIxjMUfzoe9yeXDs4KXRtyzmo4Gu6uxRjCJOo1aS5ZsS
         FcYuJDvRcbdA5cC4fY/cuNIB6ytHnBok4cDmImScr98ULiVp4HVbhIqV5a+DScPlQfE3
         t54Ldh/B+rUwvTSzNRJpLKZk0qJF54vkJwgIpaWWimQOqNr3V9cyErKtDQvX12kWylyC
         jsiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757453554; x=1758058354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=asYCnis4mSt6CdqmJGzu+Uw5kUXiEII09UvJhb2qu+8=;
        b=j1lSrmnAKqzr9vm/+ZVKKs8ffUISLZW4FHm6mVk4/cgrDb5ylYvvFITYky+77SIuAY
         MYhJ3vT27mRrw76D+F7P/ly5O4aa3v2WSDAQ1xDm2z/qz0sK7IMF32DbIklwZIMwEuSX
         ALuk7NN/gqln8CKFv9HhBBoNRtNUsB4gxXwFKzdHdZRrdzL8SKZmYsV42RIzC6zK7azB
         HVbpteFXRp7r0d+gxztfzi4FPwexRWd6FcMoxJaUnk5ed7WQW3TNvD+ihO4JB5rqBI8z
         gsqjhFVp0RxdXb5hvSAbd+vcPhPHHQmDwvsqedBMm9npIPQ3cTDTY6zaz6+FocfH7sO2
         wxjg==
X-Forwarded-Encrypted: i=1; AJvYcCXeY3TEKlEIJe29OsT+GvEFsmsethW00/jByDsawQwwmrKTdRNBmm6ueHG/B4StFabh0JIscV2gNA==@kvack.org
X-Gm-Message-State: AOJu0YwxTWkYamy8PdtkKE2rPdSQD0cPOjvFa6/h7EiaAVMNFrRNpxVM
	pbS76V+kOqM7A27b7zcwDZKhZCX+JMP34orXlDpYYbtQjAc4Ovb8QZSxcKxShaITJbcBYJHG/Dk
	o5er1n4Hgp9e7/13oiwZRstUFoDhyPV8MHN+ibNyr
X-Gm-Gg: ASbGncsEnO5c2+aqVYQYq/gg+pH37TUUZCDEvhoWCb08Eq0xMtc1CW7p/dKq/2cOw4Q
	+FRb490fwfY3gbdJdNeDxIQ096BQ0xAYWmdIwEasu1GQhZ9BOodo7vRdJKTZFjXMtsHcXj/gh4I
	gKRpzNSSnyuIcv8LJMGBgw41pUb5u2MHYozA2u3lO+kHdkMi3MoYmw3ias+ID9XLeFFhxeYIUGi
	n1TSZHep8WBHBzs4A==
X-Google-Smtp-Source: AGHT+IFpFxNo6dxCBm0dGcRZj8ObBT0pFbtG/sSiVCHxphai4thKxc4JU3AVtrF10UeYjdGdH9PqFYTQ3Uv4NlDmlp8=
X-Received: by 2002:a17:90b:1d0b:b0:32b:df0e:9284 with SMTP id
 98e67ed59e1d1-32d43f45856mr17772256a91.10.1757453554206; Tue, 09 Sep 2025
 14:32:34 -0700 (PDT)
MIME-Version: 1.0
References: <20250908013419.4186627-1-tweek@google.com> <CAEjxPJ5q0eriGjo1tdfN+pzBBN5OeyfMaYp_sNQcOg-rDaXVCA@mail.gmail.com>
 <CAHC9VhR1pEFYzSFaqqWsU8C6vDaH_E8uZZ5g=KyK6TJvA7a8MQ@mail.gmail.com>
In-Reply-To: <CAHC9VhR1pEFYzSFaqqWsU8C6vDaH_E8uZZ5g=KyK6TJvA7a8MQ@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 9 Sep 2025 17:32:22 -0400
X-Gm-Features: Ac12FXyL7eL3X_jCKFwoxMjKs2tue0NW6-1wqyMzPYDoAVXjw8OY2Gb7ih30uV4
Message-ID: <CAHC9VhQLZ+mWS77OG6cDddXYfJy+eTqkKSZ28PJNEjLigsNGhg@mail.gmail.com>
Subject: Re: [PATCH v2] memfd,selinux: call security_inode_init_security_anon
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	James Morris <jmorris@namei.org>, Hugh Dickins <hughd@google.com>, 
	Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, Jeff Xu <jeffxu@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Isaac Manjarres <isaacmanjarres@google.com>, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 90EA340003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: tyzqzn3etww6syhja9kka5nm3b3wbcar
X-HE-Tag: 1757453555-595628
X-HE-Meta: U2FsdGVkX19uJRv4Pz/FNgN9OoHb6kJ75ly7ouzDFUOgCJ9kPlCbynOeG/n9/oZQjtvxDkpcYQjSqAPedNsw9SrHMuATmBtV7Pu14I0AyuKmF0X3GPTpxkcKPjy7DDtByJwruUwrOV2mVopZfi90IGAZjMBMxsOiwqiLw/pY+w1cmo2fErMJwh6GVDT78lA2xh7qWBKkL/1eJyjDxFdZG+MrmNfhhVLfnhHd35800uH0GbyI5hjuM6MzuiDpr/IdPjZFXg3DAfekO6W5LmNR78Gof3je76WgnjAayuYrIznD56iFxOG2XxKfsBRIZLlGmB22tVvq9POZnktDjooc1EL/6x70YdUwoHJSaz7rgHY0GPBJICdOgQPZsuR2IMNoeKpKf2EcDV1kpi/Ly51xJjR6UhjVK7JohiorxJ2kDUzTZlzz7p8wTCQqEUuSQZj81tu8BLJoQ6RLSeBYxTp86Wa6KUxIw+hTOnnd9G0TLKZoiQpMRZlX2i/dy0C1LD//fAdkbsgcdfB+nGE1IVFTnTzDfPDdMN/lugbLRsnHXhlQGjWIl+QEpMvr5ac5L0P3cH6DUEAPkj9dY151iRF6goH/KEQlL5GrJppdJmYNJfHY70XedXTy63NoeOHWBr4uqMGcWLwkY4D6y61kySAkVi+cfwEBS+Uy+9BSpbN2CDsfJusM2KEjBUxfZliDKhsDnFyy9IHRyScR0przsNIyT7cNaSsV45+hg5iJZAlilpbY5O1G882n3nOdou/zYYtElVyM/5pj27MbLyJlq8Vbq+yGhMPv9LTQtWzvSYDnh17UGooCm3SEAFUjWgeuPrhQ/gFO4/iE0Wvij3Fa9ihxWcHz3MwbOuB6fzLEs2S7KFsNyF67lvgWb1SjAalsyNB9GWZDd/KG7E678sLV8NU3cCT2do8FoSCtNz0Reh+QqPUs+PXKYCaQpzb2tjgFg5Pp+2EmMREBdPHOTthk+8f
 eaIDn741
 0wpO+mKAEX3us2vUoRiwSEoCBLOl+bRjNyw6PpVdMaeQ/yUF4t97l8Iox26jWd5/Uc2VaVGUGf8OENGI+qpyU0aSoBp1AVi8GMpTPMDOAllkqGZ7NJF7gTDsfAPHbPA71hLb8I6UpMSBBwepGplEyQ4Jo85kjGVpn79WpLCfA9vH46zE7agCk3JpjgsBHP6OTaeIZ6csa0ZOWRvJti1BiQxPdB0UEkGqJTkv/ClObXle0b+HHsw582XdfAYE/FPfNgrJRnf9eIZpITa04D6AsZv3/mmcZmq2hu15m5h0v9ebmmJV+rs7+Sye2CEK9Hu+HiKs0IqDFKz6YhGrP6kg2FMZAkjHWTS447HXpQRz/DzmCZLFP9g1TvJHGp/PpXL+Lr+KKPgYQ6Oe2v5ojgEVnE3lV4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 5:10=E2=80=AFPM Paul Moore <paul@paul-moore.com> wro=
te:
>
> Considering that we are at -rc5 right now, we only have a few more
> days left in the current dev cycle, I'm going to merge this now (with
> a subject line tweak and some unnecessary vertical whitespace
> removed), and I'll put together a quick little patch to do the
> WARN_ON()/EACCES conversion which you'll see on list shortly ...

The patch can be found at the link below.

https://lore.kernel.org/selinux/20250909213020.343501-2-paul@paul-moore.com=
/

--=20
paul-moore.com

