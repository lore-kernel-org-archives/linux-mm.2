Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F0D0606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 21:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lQZgqdUp
Received: by kanga.kvack.org (Postfix)
	id 312356B03A2; Mon, 19 Oct 2026 17:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E9F06B03A4; Mon, 19 Oct 2026 17:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC5E6B03A5; Mon, 19 Oct 2026 17:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED9066B03A2
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:47:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F19540810
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:47:42 +0000 (UTC)
X-FDA: 85340713164.06.267C0DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 61D428000B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:47:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lQZgqdUp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792446460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y01ZFxKnej6mlURbS/x8BLwV+C7jNkm78zIZtDfVDp0=;
	b=KGKQLaOAggJlifu0j7eMXhRM1n4JBsy6U1p+wSytl7qT+OgenLV5+IgJqvk5VK7nURrhbZ
	sFwtCXUT9bcotSxWJpxE7GJLPAalBJ8E5YQN76Fi4UKFvd/MGpZE0EiuSqC2QrezGR6voC
	F4HHFKVMU1hRXTnq6iFSXxBtkgh8lA4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lQZgqdUp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792446460;
	b=k9PECsZ6x7lQAiOAs0R9fhrVsReGZ1hYsq+slXnPR32BJTPg/meJxLluoEH6CgI35wlTEd
	IEnLikwd6CT/L33soEgQQ5Ja2jzS0T+I6o99P/k8BZW/kQeqq4uqJExRg2lPlYQawkjFQn
	2dH8Oi/7e2AWWTlbrLNQioi6I2lpJy4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CCD5C44042
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B361F000CA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792446458;
	bh=Y01ZFxKnej6mlURbS/x8BLwV+C7jNkm78zIZtDfVDp0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lQZgqdUp0zhIV+HXrQx5g7nOPWsoMxtLqnTsHtXZlQCwNWMUSIOC7WxV680SQyNMX
	 sTdeatBIAD4itaMEkXk7aWS7vdcUtIKLVTIiA4qBID8nKENcCHY6qNgM5jI9vR2Czq
	 HFTVWnGcBeWQxlzclhq3lp67FAWDRV8FhAJxsU/kECVxxVnIFLMEi6WIyoQI4QGnE1
	 cIimnS27lGSjRknOtwBK9V1MFJxiauAA6JE8G8YwLzTl89jtgJczRe7bza/Q1fKAMa
	 xvMiSWUK3NiuwFH8k3m1jMV6LKMNACiaQg5MZp5RhQOCb7divTCTqibkDlFSnl5Mvr
	 II97sRUECqtDw==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c3f8d72d7ceso444458266b.3
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:47:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzk6Vpk9L7QwLBEHyCEVGMGz9yF7F+qNau1/Q2xN1SVNqiZjZ8Br2xh71cnHfkzhO1ELh/bvRSgBQ==@kvack.org
X-Gm-Message-State: AFq9FYJ+fiWMF0wu8uR1lxMgsWQ753An1jcDdXM0BiC1O3DgWLAdegED
	HKduIJcALv5ixwyoWu9CQsdSvcHwCJ/b72uD30gSJOqV0k2Qjj/uWyUhOK1blXdBzAid85cxJMI
	ZP+Le0uG5wULWtAe9JpzbY/EjPYTeSgg=
X-Received: by 2002:a17:907:d385:b0:c41:5a0e:3356 with SMTP id
 a640c23a62f3a-c419ff0269amr587261666b.41.1792446457458; Mon, 19 Oct 2026
 14:47:37 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261016054954.GEatG7AgMNFRkiTo1H@fat_crate.local>
 <atI_yuCc4BiweBQP@google.com> <atT5TYyLapHO5ZoX@pcnci.linuxbox.cz>
 <20261018201538.d0957878f378a9821852836f@linux-foundation.org>
 <atXXma5NXxoSWJO0@pcnci.linuxbox.cz> <atY1vWRBRUwpISKb@pcnci.linuxbox.cz>
 <20261019083529.a81910ac0976c1a5687d4c6a@linux-foundation.org>
 <CAO9r8zO41EromgLGhKv8H0aKXjrffH+t4CFGU6cLo59JJ3CEuA@mail.gmail.com>
 <20261019105844.02d4623b7063fec25ebd34ad@linux-foundation.org>
 <CAO9r8zN1dTJmULsKCwNrNr_vKyrV+vMfD7wifQ05uAti7E-yDw@mail.gmail.com>
 <20261019181510.GAatZeLtUmU3Zy9VZt@fat_crate.local> <CAO9r8zMdLN+wms164bs_c5BfnrYZoNAPz6b6hcODt1JnUMniVQ@mail.gmail.com>
In-Reply-To: <CAO9r8zMdLN+wms164bs_c5BfnrYZoNAPz6b6hcODt1JnUMniVQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 19 Oct 2026 14:47:25 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOq16mMpRsg_83wfYX8HQQziJLFtjVGuUu_j0doCBVgZQ@mail.gmail.com>
X-Gm-Features: AclHuK_Usd8FmnB_Y9RQuzU--fW4ljIz5k0wB473gNs2RDhEXbyVkZbgYbBQPGY
Message-ID: <CAO9r8zOq16mMpRsg_83wfYX8HQQziJLFtjVGuUu_j0doCBVgZQ@mail.gmail.com>
Subject: Re: hunting memory corruption bug in 6.18.x
To: Borislav Petkov <bp@alien8.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nikola Ciprich <nikola.ciprich@linuxbox.cz>, 
	Sean Christopherson <seanjc@google.com>, David Laight <david.laight.linux@gmail.com>, 
	Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, 
	Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>, luizcap@redhat.com, 
	pbonzini@redhat.com, Tal Zussman <tz2294@columbia.edu>, 
	Matt Fleming <matt@readmodwrite.com>, gregkh@linuxfoundation.org, sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 61D428000B
X-Stat-Signature: 6gzjnwzmu3h499dbfn7munuy1es4f8e3
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792446460-370044
X-HE-Meta: U2FsdGVkX19oDvhyd1r6Y2tLcYsE/aq/9erNAucO2aVP2LaoLrGGjqmbohGxRyK/3uvc936hNXS6wbl7A514CMagcnY7L/JstrXNFyW//GdF5LcpQz9uxjlTVur9qqL8xLOkONoZuk6P6ReF42lPeVBPKhFZbkMCficeDZVSiECGaBH1iz6lqrEP0+DEynxrwqod7zirst9j5/DX75LuS7+Pi7FtuLNh2lOD7S/YFCehGR6/YodACHb1upxQ7OrvQTTLo9mZcC+j8cXqXJHNIL7SDL/0jHzdZq/iU0OSiFGR1abpNzu+vCDaPK3MdDZ4Z6eJZhn0XtIBNCENSETm8NYwxT0lPs42bVPl9MfrT8R5gEM9MFcWbmAdp/nNrZF4VVMoTZyNUFN4iDtbFQaiI+7B28gfxbzKsCzuy0FI/5Oz9/g8rjYAwGJD6Shh6U4OXvirCX7lN89OxE+brE3Pjki7AInH/32b49Ok3EkxD/vO6SA2LTL5sUhqmOqQewIynpH6WRvkcP96nrX3d3NxKx4u5xFLh53wHT7cmFvVAxaKHM7tHGyB+ZG9Tf11odtlLRIFgiZZHsKKYJ63jVA7PhC0WhXwP5/R2MvoPzmIWsunhCV297UD2G9NoWjy7XQGVUrXDupW1e884jS8riUUqXKvJY61Njvb8g1elsJOPzE7zfZMTkMSGsTVNf5QbAujwI4NLdLd0HYC2tQ9x6SrGZLr8+mii81ifreK6Yw2PCAGq6OL0vYm8FMb+07wRzPyJYz62TcHVW1mkmo4fdexOdAy8i+w9D3kzAO+lbntN/Kog8I2WU2C3alYgiOQY1prhYICK30Alz/seVp1ErAdy4GloUnhF7kWqoY44909Llv2DFSbgZtWDIUostaHq3KZNzIazrWhV4qqzDsHQ6b/YSA5Es3MZKrbscGjblEVX7nrhWoHmAVjaWlCjfWPzUp2adcCrDKdhz2GxqDe1ZW
 jwcRq05L
 Ngjr7zt8g5aZmdyFMeuB5C0eGiNE8b4bXrZLxxw1zSd+KcO8Y10k8tzbwMpJWzMEG4nYII1sdg39rXHGTrQnGxi5A9ZajCe79YbuhpkgsyzBPAaO2VJAxxgYju7d0cJ1O2pcf0o5g2PQeOcQCYDM2X5T+JR/n9lcsfslch+pwGGwQxJbCTqHxOFk5zq/vlzSuWIKw2sL80IPS/2MFSY+dzNlLSZhIEU4Tnj+vS28n7AlX+JKzBtmo5zfvv/zNDWM+qqs34U04uDGg1rbKXoSNgjgNcivxvEp2q/shJvyJ9T71FL0t4PVWfcLO1txZu+v3Di3u86U7L7EKbv+PkhzwH8ISDOAmFlY1Wvd0yvDZTHZ+3rooGLroZi05yByHKBvz8KJx50je6MSs8ohi78nuYPMAAqMe22U4McMEkDgHGbc4Mwb24nknuW6M6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 12:53=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Mon, Oct 19, 2026 at 11:15=E2=80=AFAM Borislav Petkov <bp@alien8.de> w=
rote:
> >
> > On Mon, Oct 19, 2026 at 11:00:00AM -0700, Yosry Ahmed wrote:
> > > Right, but this is for new patches that get merged into Linus's tree,
> > > what about existing patches? Any way to retrigger that workflow?
> >
> > You take your patch, apply it to the stable trees here:
> >
> > https://www.kernel.org/category/releases.html
> >
> > and send the applied and tested version it to <stable@kernel.org>.
> >
> > I.e., you backport it yourself. :)
>
> Will do, I have done manual backports before but only for conflicts. I
> was more asking if I need to send the patch to all branches or if it
> will be automatically backported to the others if there are no
> conflicts.

Actually, it doesn't matter. I think only v6.18 is affected. I think
the problem was introduced in 5a1a726e68ff ("KVM: x86: Use
KVM_REQ_RECALC_INTERCEPTS to react to CPUID updates"). This commit
deferred the initial intercepts calculation to the first KVM_RUN,
making it possible to calculate the intercepts while L2/vmcb02 is
active without calculating the intercepts in L1. Before that, I
believe the bug was indeed benign in practice (I think a VMM can still
trigger it by going from an Intel CPUID to an AMD CPUID after
restoring into L2 but before KVM_RUN).

