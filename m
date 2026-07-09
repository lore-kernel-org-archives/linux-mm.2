Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7525C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:15:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 521676B008A; Thu,  9 Jul 2026 02:15:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2376B008C; Thu,  9 Jul 2026 02:15:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3726C6B0092; Thu,  9 Jul 2026 02:15:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E94496B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:15:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 461241403D6
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:15:18 +0000 (UTC)
X-FDA: 84968225916.29.F5EFC1E
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 48D494000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:15:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DzTmhuKJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783577716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nDhfXy+JFjOkSTFePIfLU/zhbaeABDCklVisKt6pztc=;
	b=QnmpLYjtWrt/P+e9SHeLD5J1z4TbsuzNoXNd1oZDXBzlscUpafpEV9FLM1uLTQpT7ZQBA7
	TkqX+/yS2mg3SjpWJEXnRwX+HvV4b/ceCq3FiXzyYZF7O5TRS81slMIN5Vgc0CvYd7gmEm
	kuhSIrYg2gfcaPfombCWbedAaHeqm4I=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DzTmhuKJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783577716;
	b=cTjTv0bT6B36nIpOhELEJpj9CtkVWvPgHiY4XNOvaNpLTJbjUQnU2Bx6AaZ3bPLJlYupRS
	C+HbaRY2kallaDjvNXRszTwyu6yrmIpM6W6VuyJ3wE/54PUa7J2rmsVq9XnIKwV/HqcruU
	9uXWiGTrJ8oGvokFvQfaWjUzVPZ5VWo=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5b0077d7053so3591e87.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 23:15:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783577714; cv=none;
        d=google.com; s=arc-20260327;
        b=fKPFquggPnL3O3N9IanGaxtTOgj47AYkgMdGyFPhZkS/8gqpHLALQRDbZWl6ePecIJ
         YIaDd5I+vrAugYk60kzbA/i9gFANCG/uv5p5KCDrPg/YwGi+w+vevhtkEzYYAPWh5FAx
         XmiMYf0FykJTTemnehOqBToCdCZDYcJBInnj6/8uQ3klcPVPt83A2d9G0kOPEjy1wLse
         2N9C6Q/XbdNntZV/Pt8ZerPUXFB+Z7r2hmHVv3FGoq6QAg+MoFGEuKTEV+YUWUghWNe2
         IFHrTKgbTZOefmERhkveQSSmriYQN+tZESpRNM/WDBWQzMv1Q/ZGO1tctacJ/W92wuXj
         ygpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nDhfXy+JFjOkSTFePIfLU/zhbaeABDCklVisKt6pztc=;
        fh=0cBERO7sJEpu/p9ya7iTKwQFfi+yNDWcHADXE2K2vKQ=;
        b=REy/sCzwDumi2921gwovclnc6tdF8B25O+mHU6f4VwVBGW22N8Uw362zY/5mtpoCP2
         D4fVjnwfh6UjCkR6kRj7fXn/iUL2+JPC1twAl/9J8YRsI/XoCSnLJH3HYjmdr4sM4ORw
         XuAQblV3XoeszE9Xf6ZNJRC91aExEMDHW3UxkDXRWUdQUoYsMki1VAYGQWqo+VY+yatu
         aD71vyIpchsfKbjq6qfmQZTW7uX7MRzgCGBrklplWR2eeUX54BcUEwJulfsfNPobhY94
         pqzdrBOt33Ig+54ohYBJV0D4feYwbEY+DA7bQT5E4AJ5aMXW8WDTtcPptp9+2gPHqj6j
         /lpA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783577714; x=1784182514; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nDhfXy+JFjOkSTFePIfLU/zhbaeABDCklVisKt6pztc=;
        b=DzTmhuKJDLzW22TGCztmOFCrGGl/QYF7DRzbMg0Ld2j0Vyi/b6K7SKzLb2ZG+bE93X
         LDRuvr8zwE1C2Ky8Bmw0ne/Iv9D4HbGKqzdaZeJjgn7Uc/hC/Hxz/zxBvZxxAfdz0hiP
         EskgZQDXuguZ78N/gT5Ux+v1lpkIutYog2Kd0w2RCGEpJity+Rpjr6rftIaQM+22JdQJ
         /6WpRJ+bAPfhpG55dOFNKHIzoZLvcxnmNXvKvQtRuJrFc8KUcH9DH3N/x46fPmwBj9pG
         bXlfIk+QLQnzpzKKOCgkxuNHctZd+1UkkZ+SMJHAPaoGB+72rm++mNL4IFllyb6M77K3
         +10Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783577714; x=1784182514;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nDhfXy+JFjOkSTFePIfLU/zhbaeABDCklVisKt6pztc=;
        b=qaoIdo7zP24jN9XgFBJPRBu1gAH3fJqJnjB9bE6xIfaSOJHGaocshdsnYBrNFFC1Ct
         5hfRV6OUhuldIZ09oOqepUDMhi1a3g7EGvpEhQHigAOWSs1yfE3Q4/6rFbZefCAYwKW7
         cmvMDxof2+0XsGHgGUe9lW+sZHf7b4PMqgoGdktgK7iEeM4d6CjrSQJ7zmqAiIYa7ift
         o56HP3R5ndYYnoziUILIUsPuzU3ONrmeuhSoIF4/1e15nglliMjxPTWyt0FO4zlY+Clz
         nD4kzGkgW6VQtQZoc2Sr+IrG9A2P9JKnEUxg094+/3+XlS2E/43KjdWU76uxpCgpNFeb
         M2Pg==
X-Forwarded-Encrypted: i=1; AHgh+Rp0H/lJ3oXGxD5z85x1w69Xss38G+QwEuZSzICXSbyI+vNvZM4OGacn0+7waegq5rZ0t5tqS44zqA==@kvack.org
X-Gm-Message-State: AOJu0YxrMhgS/VXOJPLVjT/B57PkYVQkHJu5VwPVUv07xGMwHTXP7HXw
	c8Hfvl9rkQ6BoWa/hU8K47YtQ4QLpffpCsuBwXpXvFiNpbFW2VYNu2Y9urDcmqlYQgv9Q4JVUux
	MarPR2NPoSW0mYHDpQclWr7WGZUp8OdU6puwKg2Yc
X-Gm-Gg: AfdE7cm9Kd/91EM9GDquNK8IUJexYLpjldxF9mHAqv+/UB0qC4/7GL1xFnEr9HTVlnq
	ReFN/zNm9uWFCXIw8uE7kmmYSZsdXN63PjzXZXaXoYUxMFCduAkNFgCRjCN/r1c/6gpTYK1K+pP
	vwvDpNwflrtsOs6gGgoSFODlfx3Xj+U7OXlxHUzGe0EKqkLhhUFDo0g5L966tOvFZtFuDKRD1H0
	Y7vwKxHQxeauCtUKvW8M2L2BvOnpvD2l67eEsp8bsuLVHk2Ip9U9j+NRSaRp3Bv0ILDC5g1Bwz8
	OqXjglCXI/vtPyDxjZVvT0ysGFmNRv8aKZXQyts4Lwlj9sbdzTq5CrZEqFnEEPtW0oLaektX
X-Received: by 2002:a05:6512:3d8f:b0:5ae:ba90:8a21 with SMTP id
 2adb3069b0e04-5b0163a0071mr87384e87.0.1783577714119; Wed, 08 Jul 2026
 23:15:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260707064235.1386552-1-souravpanda@google.com>
 <9624988a-366e-4884-9408-3f3b88c27290@kernel.org> <20260707062428-mutt-send-email-mst@kernel.org>
 <b9a48d89-74f1-43d4-b7bb-be988b6855c9@kernel.org> <akzZr2jfJ0J8zox4@lucifer>
 <20260707095843-mutt-send-email-mst@kernel.org> <ak0xWgpJPSaNWPsl@lucifer>
 <20260707152755-mutt-send-email-mst@kernel.org> <f9bad4b3-93ee-4daf-84d5-97f6ca305240@kernel.org>
 <ak4JiBcvi29sYx0v@lucifer> <20260708050547-mutt-send-email-mst@kernel.org>
In-Reply-To: <20260708050547-mutt-send-email-mst@kernel.org>
From: Sourav Panda <souravpanda@google.com>
Date: Wed, 8 Jul 2026 23:15:02 -0700
X-Gm-Features: AVVi8Ce9AmF7X4hV5ixsxIF5PZt3E2eW-xAowBuyJMbKi0GinxpYNGmtl7bX_VY
Message-ID: <CANruzcTQbfnsx6dMxbc8=2tQVF2gK1ROm3LOKiHc-sdT3xV2Ww@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] mm/hugetlb: Dynamic, NUMA-aware HugePage Cache &
 Free Page Reporting
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "David Hildenbrand (Arm)" <david@kernel.org>, muchun.song@linux.dev, 
	osalvador@suse.de, akpm@linux-foundation.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	mhklinux@outlook.com, fvdl@google.com, gthelen@google.com, 
	mike.kravetz@oracle.com, pasha.tatashin@soleen.com, rientjes@google.com, 
	riel@surriel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zyza91ajoo59a8pc3gi5qnhcddhbanpq
X-Rspamd-Queue-Id: 48D494000A
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783577716-763725
X-HE-Meta: U2FsdGVkX1/1eJReMZMsfEH471uLcITpf/fqIQuhAWAv+rx5nrdzW5cWa3wt3r/i/1BmjRsr2x2BpvvzeGSgBX0ljpCTAXhqyAWhYnlv6GBJumcAXoNqfFqPoKKKTad73IEakOoEA+mfm3OnSrn5Z1VvBqUxnE+szgzlT0+F28cFe4do4Nl2H09RHfFRPHZXVt1Ep7od0IjgVOYdZhtHWjoV8EEejsSkvhJDDkjM7hvIfNocfhyXODNU3sK3u+twltAuwZUtbuQ7KSQ/6vyT2wKBPy8LR7DK+hjGsVInAvJbVdmqPC1bltbcTHLfRkMEk3ttVdmT1P8sI8BLa8IoPwjMkhB+eQz6ywFzsUgNYfGsVDC2kE8KkcgRafy3sF20M1glcOaj63zbuENrui0VuM/Wl0BlHPBXNRe9qxxBu69KZEOTIAlLp4XJJSp/mTmqRUx+Zp3+1VDO9vAo/9jox4annMQ72CMHH1aR5NagOhnpxdwJpLmjsE8sd5Cro2eUsRe4+FbhjgXD0pgPudKkqx7jNfyVPPIUc9kKF/9nbqfpUsi7OTUpPCmnlQ6THFX5f4kNK2clgAc7eOh5CV69p15KalMEsG1gdpALoM+UqyLZOFBV10xf5SSx3/v/QRp3fwsuIB413G44VLEKTfybhtZ8RhKIAGJ35L65GVWOx2xUS2gokEdJmcixJbvdr5dqJCSdtnK/6Zo7iVQFrd2WEjzin6xAvswapdibCJLV2Cc54HFxguXy1WbNFTJFX5Q4L3+Nndj8TfKco8ExbbuBUv9keZOTjK5avT5vQW1ml7prxYWYX/9NjPZyRDmKcXYggPPdSqmR0H1MGjjUjFseNSAg4uvDMdXHhzpnO5rNnU6xUxC3x2SKka7NkZQsaS8ddiphB3bHC06kw0aWQYphB0F3yKSF8MOpkH0D/F9Hin8F3usYC/RpDfTMIHIygSIsSdTHAD5wEWxWyTT1APc
 udd7DCle
 GiobsDuqzc/UcJ11L4xTgLrr/FY8ep7TBxENJC9xU4Br7ldAFLoRlg6ui28OF1UfKqzk1PfxnkD2B/P2/nqfhtLcRS3GrtWl42bi6/zJCOjvWri9YEIkIDrE/EEeDvZ5BSHN6B28hTB4PkuxBcAHBr4HGB1VWc8NXskLgUf/I+AO2i0P7ME0jduAUjHPqhIoEfJrknT1aWfxOJcIVcR8b3mgD4xRAQW3lWQ1ov3U3Xa/kv39Boep6ks+BgvCyPOtevnSSIR90lHRzrGw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 8, 2026 at 2:16=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com> =
wrote:
>
> On Wed, Jul 08, 2026 at 09:26:18AM +0100, Lorenzo Stoakes wrote:
> > On Tue, Jul 07, 2026 at 09:46:14PM +0200, David Hildenbrand (Arm) wrote=
:
> > > On 7/7/26 21:32, Michael S. Tsirkin wrote:
> > > > On Tue, Jul 07, 2026 at 07:46:28PM +0100, Lorenzo Stoakes wrote:
> > > >> On Tue, Jul 07, 2026 at 10:01:55AM -0400, Michael S. Tsirkin wrote=
:
> > > >>>
> > > >>> Fair enough.
> > > >>>
> > > >>>
> > > >>> Lorenzo, do you know *how* you want it reworked? Could you write =
it up
> > > >>> at a high level?
> > > >>> Because if not, it's not really practical to make it the asking p=
rice.
> > > >>
> > > >> Michael, you're an experienced maintainer, I'm surprised I have to=
 tell you that
> > > >> the burden for that lands on the submitter.
> > > >
> > > > Oh sure, "fix bugs A,B,C before you add to this mess" is a classic =
way
> > > > to actually not end up with even more of a mess.  But I usually do =
try
> > > > to be explicit of what are specific issues I want submitter to addr=
ess.
> > > > I don't really feel figuring that out lands on the submitter.
> > >
> > > Sometimes it's certainly easier. With things like hugetlb there often=
 just isn't
> > > a feasible way to integrate it nicely into core-mm. It's just too spe=
cial.
> >
> > Yeah exactly :) once you reach a certain level of 'specialness' it is m=
ore like
> > pointing at a flaming trash pile and crying ;)
> >
> > >
> > > --
> > > Cheers,
> > >
> > > David
> >
> > Cheers, Lorenzo
>
> Well as long as I'm not the one being asked to put it out ... it is just
> hard for me to get motivated to do cleanups if there's no actual bug to
> fix, or a feature to develop somewhat proportional in size to the
> cleanup.  But for example, and without calling anything trash, after poki=
ng
> at memory-failure.c, *I* want to cry, because either there's multiple
> races, or I just don't understand the code.  Some of these we discussed
> here already.
>
> It seems to boil down to the fact that when people start getting lots of
> these errors they rush out and buy a new system, so hey. But maybe with
> RAM prices spiking it will become less practical. I'll put together an
> email with a list later, maybe.
>

Hi Lorenzo, David, Muchun, and Michael,

Thank you all for the candid feedback :)

Lorenzo, David, Muchun, your points are well taken. I agree that
adding hugetlb caching and shrinker logic to hugetlb goes against your
long-term goal of integrating with core-mm and reducing special
casing.

Michael, taking your advice, I will strictly focus on Free Page
Reporting for Hugepages as that is a regression in the page reporting
infrastructure.

I will send a single, isolated patch that wires up the standard
hugepage_freelists to page reporting.

Let me know if there are any objections to that!

With regards,
Sourav Panda

> --
> MST
>

