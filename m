Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB775CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 17:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93C936B0093; Thu, 18 Jun 2026 13:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ED846B0095; Thu, 18 Jun 2026 13:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DBDA6B0096; Thu, 18 Jun 2026 13:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5274E6B0093
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:02:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B5BCB1401E4
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:02:13 +0000 (UTC)
X-FDA: 84893651346.13.B767BE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 15AD7C0022
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:02:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bd2wyNwM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781802132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ml4NCZd/0okjptN2eYGxs96jTaTIlMkwVPtC7PdYyns=;
	b=KVcqPKcRolry8Mu9V/CX4oUz+YaTpKZc55QmiuulaN74VeDm19j8SFt+Nh8+6wRpG/uLHa
	YdKwmLAlhSAVwfjg7+K8kt5tl9aJF2K3DAfez/nUi9LD7rwgR36BZqLRvWWaViFo+sGUif
	B7QQPjXXDpLJHKE4WRQQql1KiqZXbis=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781802132;
	b=vYdtB3Bze8fvgK7nLJ4hEg4uavRkDGysFgLrA+NdEOpjnfu1n40om4CQfe//siRApSwd5u
	UoJTr2qqCIdgn3yDJ9MlAvYcAq42SmJjfAFMCgEPFzPN2pTl/vRw5yd84WVshPfRD1Coy1
	rnB3f8/ZTfwAVaUDYDdd4wRCz/m3gM0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bd2wyNwM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 839F0601D6;
	Thu, 18 Jun 2026 17:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45321F000E9;
	Thu, 18 Jun 2026 17:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781802131;
	bh=Ml4NCZd/0okjptN2eYGxs96jTaTIlMkwVPtC7PdYyns=;
	h=Date:From:Subject:To;
	b=Bd2wyNwMT8mEeV2yh9b3GLLe0CPKlRMhfbPhH9z1ABPqD5ZdynqZU6+4ccAb4SoJj
	 1ez+8e7Liueihck1/3rFFfCRo0PSpNiy30kGYO+RpYbxePDsjXcXux2Eo0qATZXZO8
	 u5LSwjvwspZPq9sm5cr+sECYUDkeiK26stGEDR/IzR60agHGv2oXawpr5JYwaF4hJy
	 LPRi+OnVlxhNxRwuKF/svodEbchq7dA3pjIvgsIgKBFPSeypNeyjn1q+12sihCLMZp
	 O6k87Xs3+oKWH+WocSNk6jdkCVlKuCnErNRq3sTw/pf8yfEnCvqf6wAlGv48XjnYfP
	 0T9UhCbHz2mlQ==
Message-ID: <3166fcdd-5f08-4f7c-a743-192d0e0207d1@kernel.org>
Date: Thu, 18 Jun 2026 19:02:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Subject: [Invitation] bi-weekly mm-next call on 2026-06-24
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 15AD7C0022
X-Stat-Signature: xink78tbm6at1ebt3t595qmkwsujophe
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781802131-58390
X-HE-Meta: U2FsdGVkX19FRF1Oe72mCcAd0ldBQPU6stwQDvdTD0IT70nbswgf39t4jom7fNWz9GbSsNrLHA6ML2BLeEN68gGqg5NdZ4ur1jk/fMOnIbgb+8nVqVwYs2gJNhlT4X2WjfgiFNifJqNReKOK/Ee+Ggg1sW0VlAuGdJIGfDYbQU8WIP61KJL/vX9376GpdpE8fAcDZcTPIE6OGWMIjGk33B/XLqSXAlQGBcA3gtEAHJQXxzJp+HX/fk+UHtso2ApIRpTRd/NcRH98rI8bPShHf79NkW+4UEikYPoh0lvJn+paK2loieelfrnHrZXwYTS3r8L3obvWX+RT1LtK/fIsv2MZmjHTHcNFk+elFw41yLZN5bxZDCln8Nu0Az0BwWUYTnZhqO5TEarOM2cwGiqHEgxYCbF36hfQGV+XRx61ngwYHnyBsd+nPMud08w+9qrU8bkJPHYTT9jIEgirHH04zG6VVqr2xG2Xc9jZc0ohbb7NfM017O/jVrnQfPFFFd9XVE6mXpUgVb7iZ40cIGZyGohfN6qyc4lCh6LtKGHb3zst1faH4I//9ZkjmyRC9cdnMuTdNCq8BEQ4Cr1QcTolhdbultpnmVjmVR6rpvvlRbwnFKr5J/96z0bhDvO0SjUNjnUyScdeq4/LyAMXI9cKgt5giiEn6N3V3PT6fV1/jLJBiRA6TnpwTgGPM/cEGKs10RKWTLMbYrVHki5bPPPBxJGkTSV/Gb2GOcnvLEvkZ5gDg7EDvv2VQKRNz1Y5ICMTBk6JJV9X07nGMmiyFRsUSyQSfvPs/2WnNkqscS/S6aFLDRHChRlF4UndwCp8FYzns4VmdRahgBaOqVepP6piS+ZGOcXiMdKK+xHjZmperEkdOZLS3NcEKdFPg1q004VNCn9nnUKkGQ0ZntMh6lukgEtt/+qL0z2F/OOKFiS5jZDo+AdjE/nD16SdO+aslR9Hya3O/mLTayzrf1qsU2s
 gCB47knL
 slJ6QawQ8aS/02v5tmbuiURz3SMX3OjVNDmg/aX3hGFVOovsvAdbMzqfQPIX4N0vVNkMrMHnvQpbWKrM02CatEIGWrUBp6/LuwEYtkAnxsC+JMqOtEH2ngGnDLtNILfJb9rXmXArHsKQjANXMisvAPPS1z3f3AZQ7ukxAZTmI+NqEG1shx521412kN25q7YrCrOmEenhrGHa/r8ShP0wBa0/9eWaZSHA1Ymrk91D26iAF3suJ5MwFqPxzB0EfttfGngD/ZyWhXPlgjTgd61YZTXQfD2JTvHHGmfjV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

As promised at LSF/MM, there are plenty of things to figure out for the upcoming
MM transition.

I already talked to tip, arm64, and KVM maintainers, and will talk to Christian
Brauner from VFS this week, to get a rough idea of what can be done and what
probably should not be done.

So let’s have bi-weekly meetings as long as there is plenty to discuss, and then
switch to more ad-hoc meetings once we’ve clarified the core pieces and know how
to implement them.

The goal is to align on how MM patches will flow to -next and upstream once the
current model of Andrew picking up most MM patches changes, so he can spend more
time sitting on the beach sipping cocktails.


In our first meeting, we’ll start with the basics: tree and branch management.

The meeting will be Wednesday, 2026-06-24, 10:00am-11:00am Pacific Time /
5:00pm-6:00pm UTC / 7:00pm-8:00pm CEST.


Other topics on the todo list include pull request handling, conflict handling,
testing, maintainer profile, mailing lists, fixes flow, and more.

This meeting is primarily targeted at current and future MM component
maintainers, with a focus on relatively self-contained, high-volume components
where component maintainers will, or already do, pick up patches themselves in
the near future.

For small, tightly coupled, or inactive components where another maintainer will
likely pick up patches in the future, this is probably less relevant.

In the near future, I expect this to affect roughly the following components,
excluding stuff I co-maintain, such as core/misc/THP/etc.:

- DAMON (SJ)
- HUGETLB SUBSYSTEM (Muchun, Oscar)
- MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION (Mike)
- MEMORY MANAGEMENT - PAGE ALLOCATOR (Vlastimil)
- MEMORY MANAGEMENT - RECLAIM (Johannes)
- MEMORY MAPPING (Liam, Lorenzo)
- MEMORY RESOURCE CONTROLLER (MEMCG) (Johannes, Michal, Roman, Shakeel)
- PAGE CACHE (Willy)
- SLAB ALLOCATOR (Vlastimil, Harry)

Andrew is included as well, of course.

If you find yourself on the list and you or your co-maintainers really do not /
cannot pick up patches yourselves (i.e., workload, responsibilities,
availability, whatever), please talk to me! :)

That said, everyone interested in the transition is, of course, welcome to join!

If you want to join the meeting, send me an email and I’ll add you to a calendar
invitation that contains the meeting link.

--
Cheers,

David

