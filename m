Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45E69D3749B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 20:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97B2A6B02E4; Fri,  5 Dec 2025 15:19:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951E06B02E5; Fri,  5 Dec 2025 15:19:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868B56B02E6; Fri,  5 Dec 2025 15:19:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 73F296B02E4
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 15:19:19 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0DCDB89342
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:19:19 +0000 (UTC)
X-FDA: 84186532038.04.BAE4CF4
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1C4B91C0013
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:19:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KmbjI72z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of avagin@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=avagin@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764965957; a=rsa-sha256;
	cv=none;
	b=Fea+Re9BSAuvLvRRUOlib52eeEdRVyeQ2zj0Eb6yfdR4idn+XzbEf7lF/ioYmF5hYvSY8X
	Leysg+Qeo1azVh896qaa5FckEm+rv5oTMbawJ/l09Cq8v3MnqtgKQUXjHM/dslOAOWSFHc
	M+8tbsWFCCrE6Ze/T+kY4iBoYa15bMM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KmbjI72z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of avagin@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=avagin@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764965957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yr12v+DMAImdfz1AowemFJusGQ0cnaEVxPJMDmqgRC0=;
	b=lqRIg0705e4mHun1B7TaPMGP9wscxzbnCFs2IK/2/SOAmKciLkR5XAExCnUXrUB+4FPGcP
	DgRleQ6ggMqtPSAnORMoEWTGi/KMPF+tUo0vxwczw/E8lzUu+oY7qHDejHys0iaClwvNyw
	5E9krzM+1L7jW3DiBU7BO1/e5BNRhpQ=
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7c6d13986f8so2354337a34.0
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 12:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764965956; x=1765570756; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yr12v+DMAImdfz1AowemFJusGQ0cnaEVxPJMDmqgRC0=;
        b=KmbjI72zmYE3JbB0vtvZN7xHGGx+yrVdflosYA1BW7gxRiw1wII9dle282CL/F4ld3
         7lEuEcEtc9xLuW3Zm1ZfggVLsQRQTGyF0LlXp1EqDSsEaHyLmxyuiLVcONWdaOs3Qkm2
         WRiSjpuFJg9spY/12kHmiOYhy1MRbEatEUciNWBii8o7NsHSDUpeHQXacWXLorYLlxSr
         uqVmY56AHCmu/KqFh5BIqHXBjlXTKnw2GSRPtEb78rtJfQssy8hbYZUsCecUxV074Ti+
         V3aRtYaNiXKf+KVU94Q21/S3OgfzODOY+WXm4pgA/YjuRN+909bn4smEZewrb5BaediU
         zZgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764965956; x=1765570756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yr12v+DMAImdfz1AowemFJusGQ0cnaEVxPJMDmqgRC0=;
        b=g6Ta07L9Lvvil+WrnIbpLADeDP6JknRAPiSteKm5hKAjXt/I+CvCbmRqbgOLTASzTy
         QkYlIpIbqppNfYVQ6M8JoZVYFDj24mL7zt/IffsSafdRMpRzjuZ2YoKFjReTBzhzmuOt
         0KlkFbYqP3v2yvqEPUcJM58VUliEvSozCUplWyqnhp4G9g2oHBRoJhmpTZNbLeIO8he/
         4WT0Kdb3X3nNhT7ZWXi440tw8ZsNtcl393XOHwYtLupDU94zAaw1UMnQa9vvX58M4q/Q
         9gxQrnPZVpWuL5hK6Hj4UkKxlo6iuvNAPhsQzXmZbZAsuDxTy6B5XZZLXpGqkG1hptlz
         5jVA==
X-Forwarded-Encrypted: i=1; AJvYcCVwidYScEEbHBOFk06rddGF4EPA6rUKXE6M9DMxvWmKUPVAIyZ0F5OjMp1qSuzv/Qt9B/1yOzgBvw==@kvack.org
X-Gm-Message-State: AOJu0Yw49FHG1OYjyoqOrN9hwIZrMWVmG1JHAzYf99rjKt/HrDCUaj6h
	MfUOvjjll1u7FMONrgZjBpoOXDwEiCiNnCfU0pzc8yNhA5imlKu5I19zAN7CduDPYX7p5iaYhhO
	7I7uzCDVLMfDRO92eiGkAPMSMK/pT/4k=
X-Gm-Gg: ASbGncvwlgnsbovMteQTIHkq8h5WP5PA3GmouEBQNHGFeGNwGqwqrTu1xl3Eoku2Mcq
	AOtT6YaSJWs1BRBWLttj9gx1m/nJtyclo0FpLDszwVjMbfEV26mHlrN/nYhWFj8WOHYwybDpSXX
	iM0QOScPUFhmiKl0cZC3GR8VkLrLWh7DKf7OJyd+DRX28npaNZdGS5UBM56vbCi2fZE+CBcUUJ1
	S0vUuIUBRTZCICkSH+Nr4vwYwAWBSDjRAMJypdBe7voGITGRQF51FJ4pXU1LYNwdyf2hQWT
X-Google-Smtp-Source: AGHT+IHwv0zV6pf0Mi0jmonA9X7SJfjx0KLsoUJL8YTZFGl2SAkAT8InplvChGboPRk86xwWowBh1fy40GkX0WBFhW0=
X-Received: by 2002:a05:6830:6aa6:b0:7c7:ad8:68b3 with SMTP id
 46e09a7af769-7c957c80e69mr5451091a34.14.1764965955996; Fri, 05 Dec 2025
 12:19:15 -0800 (PST)
MIME-Version: 1.0
References: <20251205005841.3942668-1-avagin@google.com> <57a7d8c3-a911-4729-bc39-ba3a1d810990@huaweicloud.com>
 <CANaxB-x5qVv_yYR7aYYdrd26uFRk=Zsd243+TeBWMn47wi++eA@mail.gmail.com> <bc10cdcb-840f-400e-85b8-3e8ae904f763@huaweicloud.com>
In-Reply-To: <bc10cdcb-840f-400e-85b8-3e8ae904f763@huaweicloud.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Fri, 5 Dec 2025 12:19:04 -0800
X-Gm-Features: AWmQ_blYzl1FsACJBYWFF_FwJThgem-zZm9ldZnV3CqkFL-uCbsmPxPlFX-i5Z4
Message-ID: <CANaxB-yOfS1KPZaZJ_4WG8XeZnB9M_shtWOOONTXQ2CW4mqsSA@mail.gmail.com>
Subject: Re: [PATCH 0/3] cgroup/misc: Add hwcap masks to the misc controller
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: Andrei Vagin <avagin@google.com>, Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	criu@lists.linux.dev, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Vipin Sharma <vipinsh@google.com>, Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1C4B91C0013
X-Stat-Signature: f351mt6ukepuwr3bzswa856qjwsme1gs
X-Rspam-User: 
X-HE-Tag: 1764965956-57147
X-HE-Meta: U2FsdGVkX1/1tiYnXSDpfO2Uvo5hTyyGMKmJZwl+u9Lrg1kOenPRkxgeaA/6p//AHLgEN4GK4o4NIX37NeY7N8MeTv4t2wUUYXTKdw9d2AGRqJHZ0A++qcFcdVFI8uUGfl4k6vbJduxkJg8grhoCW0A2T8C44gX8eafIB8ktOJCmhttMKElr6pWS9YIvSzM++KWC2zfl7DdrUzvQkCa+D2D2cYs5P8IQapgDyxdYDvT5+lYqeaq0Fmb8A9+nwOcsRPx7FOThwQlGwzLSi+nHXhHCsprl7spqTDIJOYpUowXYJubvOdMMn6jNFyw+nNeDdsEAG0+wzoDKwnQkKCtHEIMIN5lyV5IfI5q2EtA4AbD/1rnK+81NQgOx06DMpxtKAVkwLcMXPA4PtUoMZQyBijjY6MzjtGejOE1zlQ3XY8dw2wN8sePH+heSUN+Qo/aJwRLgkhPke2lnbu2+ZKneldFvCq0E1Tkh3BjFBp/7/VYP6RcN3OzDXh8XJazjsp8l65ZCcjg/8HCdYtJAwGnHVWDxNYEx2YwlYbr3kpaOrEg/n6uvaB0sA1jX0IzTbyMPVD/1MpTDbxUCxKYn2k2jOSdqXxSc3J6JalgT6AsSttCRLkP921ymp5posUO++IeWZlzyBcWgP35kgAm1HXvvy0f8JM6ZjekMkzcVDW9Q9Omh0LU7kf98707j94Q5VsbqOao29nqFgxcNuFXYHzLGYmzVVCA/pQ3odtxUQqxmPlER4lvKrajIihH0EmU91Nu4X4s16BwGrdolck7HKblXxMQJKXChaqldoxX5e/0la8NNC88UIW+qciHVy6rXaFrMwFqXeFQGwStnqqO2UEO6YHYjMU72YukXtEnmwUhqq5uwttyCeX1QipBqHxSzkyA6XcVrWK3s38C+c+IMZ6KbogoZbQbvAZwY/sCwvKuPRLsR6z92G8/7zsxp4yN96vsU89MGsd0/1SQcg+KUFlc
 zxoW+KeA
 NZBhTIJJEK3EaUee/nJ963SU8IuDlc5XYyOVzwlA5WD6ZyUcXoG8WeM8x/c4iJ0dWo+gtpktcCqFltW7qJVHI1B3Kmbms8rpfeiNuGjGQA1KtU6pTvJnGEQhz5ReUQD0ETY8yfT0CHx+ZfcME4Ge14RwNmiRgVn3LlaDEvwHP2OakMk8T+yj51mNXy1vmbATVbT3mp51RElPbIq9DFUCbm72qCz2M1mCPUY5J6h1MyPHWGyAB13oaqauD3conmTx5LzEJEQdbMvfa5nqgADq6cywATFWp+JxdoaARYhQ+hVUqBG/1/Jb68YOk5KUtf65dscJ+jhoETWe7gWFFgVqIH9EQyEqE7zDY/yWKxdapzVDy0yAgWXC+RtEHVezcNMFo8v2j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 5, 2025 at 2:04=E2=80=AFAM Chen Ridong <chenridong@huaweicloud.=
com> wrote:
>
>
>
> On 2025/12/5 14:39, Andrei Vagin wrote:
> > On Thu, Dec 4, 2025 at 6:52=E2=80=AFPM Chen Ridong <chenridong@huaweicl=
oud.com> wrote:
> >>
> >>
> >>
> >> On 2025/12/5 8:58, Andrei Vagin wrote:
> >>> This patch series introduces a mechanism to mask hardware capabilitie=
s
> >>> (AT_HWCAP) reported to user-space processes via the misc cgroup
> >>> controller.
> >>>
> >>> To support C/R operations (snapshots, live migration) in heterogeneou=
s
> >>> clusters, we must ensure that processes utilize CPU features availabl=
e
> >>> on all potential target nodes. To solve this, we need to advertise a
> >>> common feature set across the cluster. This patchset allows users to
> >>> configure a mask for AT_HWCAP, AT_HWCAP2. This ensures that applicati=
ons
> >>> within a container only detect and use features guaranteed to be
> >>> available on all potential target hosts.
> >>>
> >>
> >> Could you elaborate on how this mask mechanism would be used in practi=
ce?
> >>
> >> Based on my understanding of the implementation, the parent=E2=80=99s =
mask is effectively a subset of the
> >> child=E2=80=99s mask, meaning the parent does not impose any additiona=
l restrictions on its children. This
> >> behavior appears to differ from typical cgroup controllers, where chil=
dren are further constrained
> >> by their parent=E2=80=99s settings. This raises the question: is the c=
group model an appropriate fit for
> >> this functionality?
> >
> > Chen,
> >
> > Thank you for the question. I think I was not clear enough in the
> > description.
> >
> > The misc.mask file works by masking out available features; any feature
> > bit set in the mask will not be advertised to processes within that
> > cgroup. When a child cgroup is created, its effective mask is  a
> > combination of its own mask and its parent's effective mask. This means
> > any feature masked by either the parent or the child will be hidden fro=
m
> > processes in the child cgroup.
> >
> > For example:
> > - If a parent cgroup masks out feature A (mask=3D0b001), processes in i=
t
> >   won't see feature A.
> > - If we create a child cgroup under it and set its mask to hide feature
> >   B (mask=3D0b010), the effective mask for processes in the child cgrou=
p
> >   becomes 0b011. They will see neither feature A nor B.
> >
> Let me ask some basic questions:
>
> When is the misc.mask typically set? Is it only configured before startin=
g a container (e.g., before
> docker run), or can it be adjusted dynamically while processes are alread=
y running?

If we are talking about C/R use cases, it should be configured when
container is started. It can be adjusted dynamically, but all changes
will affect only new processes. The auxiliary vectors are set on execve.

>
> I'm concerned about a potential scenario: If a child process initially ha=
s access to a CPU feature,
> but then its parent cgroup masks that feature out, could the child proces=
s remain unaware of this
> change?
>
> Specifically, if a process has already cached or relied on a CPU capabili=
ty before the mask was
> applied, would it continue to assume it has that capability, leading to p=
otential issues if it
> attempts to use instructions that are now masked out?

I wouldn't classify this behavior as an issue; it's designed to function
this way. It's important to understand that this isn't enforcement, but
rather information for processes regarding which features are
"guaranteed" to them. A process can choose to utilize unexposed
features at its own risk, potentially encountering problems after
migration to a different host.

Thanks,
Andrei

