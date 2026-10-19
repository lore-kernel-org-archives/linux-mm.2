Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95024606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 18:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LI6AvmA2
Received: by kanga.kvack.org (Postfix)
	id 5FC5E6B032E; Mon, 19 Oct 2026 14:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3C96B0330; Mon, 19 Oct 2026 14:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512856B0331; Mon, 19 Oct 2026 14:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9EF6B032E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:00:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A6CB1C4175
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:00:16 +0000 (UTC)
X-FDA: 85340140032.03.1698052
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5E02B1C0018
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:00:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LI6AvmA2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792432814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4bJEDi3AXLshK4RTkURtSxS9+G3AZ/xwr8RL41kF5zE=;
	b=lTjH6UmaDuZ7EjmW3nEk2XrkZxwWeSi3TvyOdQl+FTs+NH4p5YzhL38Q2blhgNBYCUD170
	MMcDJQotaSUfHJR1a6Tyl5o7a22gcmJ/NC/UDOhRflymPryJx/WjCUHj2VVS4+m8P4+k4Y
	/Mg+5C5F5AKGjUkfR34w5o00mbl7SHY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LI6AvmA2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792432814;
	b=FjNrn/EMcbAZyj+Gc1VZ1k1KtwpTehOiBS4FZSMGzDUZmS0mlBwEkiE1tsC3DSvF9mFrsV
	VguYfy6c/867sUdmztrTX9HAW/3RxvV0XJpqju19hS1AIfabipFA6DIo/iXkH/zUHh93a2
	+ZiwD70eLy7xn/+2TIeWgjS607KqXpg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A0CB643E64
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836301F000D4
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792432813;
	bh=4bJEDi3AXLshK4RTkURtSxS9+G3AZ/xwr8RL41kF5zE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LI6AvmA2ClqE/va9oUVk3ADxFMiq9Q3iZF0bmDLF4k9dZEfrNRKHNOfsj7epqdZiW
	 2hxjLa6X+ehUAd32EoCm1+4x1jYjJKCI64bcyC38t47bANuS4MZ7CDhxE2aXd18zVl
	 eRdLvE6+Gs91p6E3S3TXCkcDf1BUpRYMgl22ldSuUrkV+WkW6JkoPfWLKbkQ4sobBS
	 ayCpYUOCbNdfx5z7uVJeSL/XGjNgsims3nlx+FSxpOVejTvfWOFc7JoKBrqzzYSrrH
	 kMqd1mWtIgEhJ6DVfop54r1cGIm/2aQwVK7CYxhKhR5HO3msKXR4BvLsdUHOf519qG
	 x0vkOMw/JEvtw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c413dea9ca6so377668766b.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:00:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzm0DkpDL6IJkohKBFFOhIEpfwORYTr0CPlv3zjCux0GEs9AwjfAro1hA/7OwLtxeIK9h8Mw3y2tw==@kvack.org
X-Gm-Message-State: AFq9FYIRnWrH1PAn78Xr37rm6NRTr3CKcwTRH2Yuo0yyVDpBv4jfBt5h
	6BQS9fWYKVX6l6jFXmsh93Sz8esG7JVhOhHQ0HjNy/d411Qp2ppx3R2ZONPuiu/i1RMyXpdJFMU
	hfF/+0ccfccVZFngYs71jd09rshdtkY8=
X-Received: by 2002:a17:906:1012:20b0:c41:b4e4:7958 with SMTP id
 a640c23a62f3a-c41b4e47ad3mr368689266b.0.1792432812277; Mon, 19 Oct 2026
 11:00:12 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <aszH4vpXFAOQP1WG@pcnci.linuxbox.cz> <20261014235736.GCatAW8GD0GlYumL4l@fat_crate.local>
 <20261015172820.7961d2c0def74d41cc6c4b0c@linux-foundation.org>
 <20261016031242.GDatGWKo98YSOhEOOn@fat_crate.local> <20261015211832.45d87fab15bb3e0bbc2f47cb@linux-foundation.org>
 <20261016054954.GEatG7AgMNFRkiTo1H@fat_crate.local> <atI_yuCc4BiweBQP@google.com>
 <atT5TYyLapHO5ZoX@pcnci.linuxbox.cz> <20261018201538.d0957878f378a9821852836f@linux-foundation.org>
 <atXXma5NXxoSWJO0@pcnci.linuxbox.cz> <atY1vWRBRUwpISKb@pcnci.linuxbox.cz>
 <20261019083529.a81910ac0976c1a5687d4c6a@linux-foundation.org>
 <CAO9r8zO41EromgLGhKv8H0aKXjrffH+t4CFGU6cLo59JJ3CEuA@mail.gmail.com> <20261019105844.02d4623b7063fec25ebd34ad@linux-foundation.org>
In-Reply-To: <20261019105844.02d4623b7063fec25ebd34ad@linux-foundation.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 19 Oct 2026 11:00:00 -0700
X-Gmail-Original-Message-ID: <CAO9r8zN1dTJmULsKCwNrNr_vKyrV+vMfD7wifQ05uAti7E-yDw@mail.gmail.com>
X-Gm-Features: AclHuK8kQ02N6lgb1bN98-Mh0znyAWQVD9WRag9FmdXyATJ4w1AyP1Rrsu2EOIQ
Message-ID: <CAO9r8zN1dTJmULsKCwNrNr_vKyrV+vMfD7wifQ05uAti7E-yDw@mail.gmail.com>
Subject: Re: hunting memory corruption bug in 6.18.x
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>, Sean Christopherson <seanjc@google.com>, 
	Borislav Petkov <bp@alien8.de>, David Laight <david.laight.linux@gmail.com>, 
	Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, 
	Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>, luizcap@redhat.com, 
	pbonzini@redhat.com, Tal Zussman <tz2294@columbia.edu>, 
	Matt Fleming <matt@readmodwrite.com>, gregkh@linuxfoundation.org, sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5E02B1C0018
X-Stat-Signature: co36qcdbqmnma39mdkydsj97ocn71omd
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792432814-752102
X-HE-Meta: U2FsdGVkX18Pit6+VCq0ZfoxiR2B0EDLQ7t59uqhR/fTcQOfTdy+znD9d5HZVmgvkZF5EIg9lgKtyw8gi1DhkWSXloMgGwZvUOnblfiRA22HgGMzEwP3APhBUP4Mrwam0k2hLsJ023iL66ja54Gs7WBZuJCWYNrjVn8v0g94Ny5VFZuz98TT8IasgRAPGIFSnKXmyQo2z6Vvayd9jobe/qaPVJDFMXvsqDTCFBVswxb/Lbgd/nTtBYQ9IWXa5QdHliDLgT/3Aywuzvj9Ln/+wyZL1JpTTFPLOr6WQHDySWaGlJDimFv/Wj9yvJKPRe5dxzZpxa6smkPsS+H17ZJbnlCC9PAY74dJHnT/fkFHwpvx7Sp9SGCzN2YkYL49XT58sUEJ8HAf0cE45C/zTFkzt3PvhHjB2uuBZxIhiWVZDNF75q7GBkE1uCxBlDSgD0jcb2L5X/KdqisTavSJGYCD6nJOa2ArC8uiRZtuuJvDS59sCuVDP5r5G+FT9yaiqxOJHydwE2SMZjOUpRdwZdubrPY1nbvoDP/uLuGkaK9utriC2EnMGEetoEzriP2EPPkVpNRiA6H6GGT7rE6tspvLSg0u+OgI/3GzPkO4oYygbrVdZ0MPFBcq8KuyWEmltI8jgjDUJI3lerYQAPSzrnFeoICd7h4r2tToM2BT+MFEVXlpZLIPVGRUNiOsmtrmjEZzb9xH8eT+Q8OyMVbX/1sl7IYeCk6EunvVm+SIFZXc31LKTcBjRCqwtuQplzdhZ3UzjQsaF8sOWuHKC4pZY01ZmIVqonjf8E+eDCqjOwQgQMAgVALWmyLNt7nMulQhMTqO51lVbZshJ4IqF6kPmJ/HZxM4KUktenbceoZwGQMgDPWFuRm7WmliwLeJ6hqLxzqul4MBNHMZeDHKHE96RmTUa+zoKk6YhcNV2W/YyNujsBGDN+InPv2vHqc4Va60qxzowhKb7TxHB/z3Nfb5RZU
 2N67Mp0E
 OI/J05/S0tpQhTxL2bwY15uiNni4805AmmHpKgbpZwxdsnwyOqyiKuGBLKv5fosNEAwXGSB0NW9wwjRZCgQHZgF9M3YSv1nqesXefk7quPd2eLU/RxPt9tQRGUG9cmPiEW9BVlgSPu33NTx/5sL8MFDVF5GHgBaBSi6ErSqcWi0WfZgI9IvtQnqf64bpHrAw3w7ZgeZL+HNZAjQ8VCYaVOFcIbnMJToNIhDOO1oX5RgdNCs4Ft51ok2DVMPOWQwFw6d+TJ9Lksc1j7NC4CeVoB0ueCzpH7QGxYzaNnNxX4gyeTItgdW7VjOyDJwpK4/xM2kdQxg+VM7pgC6r+yWn9aYQC4EVRUTpQ7TMEhE4txL250SEUNwa9XZHh0jPVTBpCzrMDP6EWJFGluEQ0ynq4kBuvO1HiJQCG3p/4qK5FKC3JudDNlTrrqgzqALETqf20otla
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 10:58=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Mon, 19 Oct 2026 10:39:30 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
>
> > I am glad the commit fixed your problem!
> >
> > >
> > > Great, thanks.
> > >
> > > oops, we haven't been cc'ing Yosry.
> > >
> > > > Definitely a -stable candidate. Andrew, will you send it to Greg, o=
r shall I?
> > >
> > > I volunteer Yosry or Sean ;)
> > >
> > > I think 55780d8a1dcc should be repackaged before sending over to the
> > > -stable people.  Its changelog is very wrong: "The bug is benign
> > > though".  Update the changelog to explain that the bug is in fact evi=
l.
> > > Otherwise -stable and further downstream won't understand why we sent
> > > it to them and won't understand the impact.
> >
> > It was found through code inspection, there weren't any symptoms, and
> > I think I know why my analysis was incomplete. It assumes that
> > svm_recalc_instruction_intercepts() already ran at least once for L1
> > (vmcb01) to configure its intercepts, which generally must be the case
> > (L1 must start L2), except during migration :')
> >
> > About repackaging, yeah we can add a note about the new finding and
> > the necessity of the backport. One question tho, is there a way to
> > send a patch to "all" stable branch (the same effect as adding Cc:
> > stable retroactively), or do I need to send separate backports to all
> > open stable branches?
>
> As far as I understand, a cc:stable and a Fixes: will result in it
> being backported into every tree which has the Fixes: target commit.

Right, but this is for new patches that get merged into Linus's tree,
what about existing patches? Any way to retrigger that workflow?

>
> > >
> > > And that repackaging would be an opportunity to add
> > > Reported-by:/Closes:/Tested-by: you, which is the least we can do to
> > > thank you for all this diligent work!
> >
> > Will do.
>
> Thanks.

