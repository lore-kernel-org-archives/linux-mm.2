Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6FB6CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15B2D6B0439; Mon,  1 Jun 2026 11:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10C7D6B043B; Mon,  1 Jun 2026 11:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3D966B043C; Mon,  1 Jun 2026 11:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF7E06B0439
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:47:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 92AD61A061D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:47:57 +0000 (UTC)
X-FDA: 84831774594.05.3C67F63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id EB0DD1C000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:47:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=It9Dcf7K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780328876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qha978NEHgz7xh7UWTrfd7Bjy8V76zrJKNnrotIFLtM=;
	b=hAMK+hQLwOVolg+d5AhgSbQNZdFJCAnZmR5DgXueSmc0bWs3/NmA6k83L79tW4JNrPPM4O
	SE84dlsPwjaui1zKhjeC1QIRPWHAjK8135itvomn1LWTUPmAXScMwv2AyUDl6rl2Y68N3t
	axWWPWHME/8WhDKRjCmBxZDaLf2JUnw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=It9Dcf7K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780328876;
	b=anw/TkTBNG23dguRoFkU5uf6EOT+cdjrrHMqF3jH8fxxkWCXAlnF34npOPWZHTu+KJDu0j
	ZKL6sX+QrWg29ZZtrbIYrtJEZk1fRIutDPNC25hf/vnLOf74c1nWJAuAlN7as4ezJEodYY
	HrHONK0pp5UDcnz1F16Q9agyLconn5c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D3CD40193;
	Mon,  1 Jun 2026 15:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5549D1F00898;
	Mon,  1 Jun 2026 15:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780328875;
	bh=qha978NEHgz7xh7UWTrfd7Bjy8V76zrJKNnrotIFLtM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=It9Dcf7Kfslfw6/YwnFy8lAUZRxSFXJnGL78NChqQb2P8uRF0c383JRl90uhrYggp
	 cVEvILD6Y+CTt1XploB2rvs7RenBocL/CYfMzTZN47O64OmwjlOANMdlux8NksDs0o
	 81LBkyJoZGVFlC8RXXqUoLlYwi5G/Rbf3wUPN9PexzulwcItNPYQvQFLvcCefF0Q9Q
	 5rfMyqbYdtLJ/2CASqvNEOKpbaSnL0CkLlfItEkb2/fTxxaILP1fodCgzv0rMBfzVQ
	 uDf0ZQXV46Co0AKyKTIHAzmVbdQPWCRFwX4UXTyRgVs0kRStdnLdCwGwlKyvpL750A
	 /pbRJsGPAPzJQ==
Date: Mon, 1 Jun 2026 16:47:50 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Nico Pache <npache@redhat.com>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	vbabka@suse.cz, willy@infradead.org
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
Message-ID: <ah2pbAnz1pwNcW-U@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
 <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org>
 <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
 <ah2fG9fSqbocqUlE@lucifer>
 <f7737b9c-42ba-46d1-b69e-53ac2bda59a6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7737b9c-42ba-46d1-b69e-53ac2bda59a6@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: jticxgizyp5zkh18bjm7pthwbxxqzm91
X-Rspamd-Queue-Id: EB0DD1C000C
X-HE-Tag: 1780328875-899047
X-HE-Meta: U2FsdGVkX19GFwN9mM/elC1cCDuCm4w5L37cWTdy01T6bxHwQxGRyIj6VPVTekHc4cdegNRVGzm40My58weOn5iBvVJa8HBFL/mo67/qeVgxeWnf1a4f7daW1EmN7WfiIBye3ljxWmg4cr5DjIOQQqJ82ohFKMj/lKUH0V4jNtoZEVdwOdKBRwjDzfEwoI6D7M3qTouWhXJArcZYIZV7IfNYSjWXnDTjin09dXpR6Pgj5NIVlZCaGEd+FohyPU29AUlur2UK61+mJsgGA9rMvOe7fSGTnWX2pOTlkexWZXcQOZmDt/uD7sBD4Wob9ay+fwHugi5huBZ07Z65ti51QHkNrdNMzkyK+lJdw5f+BylEdIRJ+u1BsZ60SPT0RyQEsjLgSvFUliYjfeexUs2Ib9ZuCQ7heI20BddD5GObifjiPl0Z8yUlh6ki1OpmBTUUHtNucXq+quCEYNxftnlOkziA4+VArBfqbJV3B/h+e3CF7KJqd5zXiFrrzNTL2WG3xdY+yapCMLeh992cyPT5CbpS1D88yuSQsQYGcPlxJCcPOipttAVStYA5OnTjDvrNReHh06spSLfufuJHZ+cMowObc+R+m698dZvuHyY16jqjYIeexfW+Rr3qvGIk74b0QNTaVbpDjcsAswAL0qQ5UrsilraLMwBVqVIuSRQJsX8o2UoexwIC25n/FTkWQyFhIoeRZ24HIrcd3FVImmewgffY1qiowKll/avwfMwismBJ0fx3RywddKzDjCS8TiB0XbdbuFu5yvJZ00X6GuULGdkd2CR+KkvmGMRtynpwtDvKsRc9VmvhYKqCrxFEqz3XUEJnIYbiePwHVfAKlkXbJWR1EbPx7hZPjU6vy+jjLoBtBJml/CBTR4PjE4UyWmiOnJtCf/9udAUqagHyZ9OjB6MNrsO/M1XvxprNplnxux+JtIMZ1Rx/yrDrcp2hmTBwk1TuhE2owswf3CtuHil
 TvQWt4vD
 LadZD/sCuUsAQLX61x9rGLv0iBpcTgsBq/tbjt1vhUhMmYsZfAUX/vcmyC2EPPqw3XW3pJuSaUcJ2olleRHcw0M5SOYbc6eOURaWyv5nXGnN51tpO5k4NKM9cTyhoxj3hRd5GC1fw7nnaoKeUXz0pFRQJqgBJwo996tdqaCZeZKGpVUV9vGjfVnxS4oIp1+Ar09poTH3v2+p3nmN3j4sVUrCaIt6FkqIDLfP2Dj0LU1A9OOHExlz/2TEQy6CIIHuccBXX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 05:43:11PM +0200, David Hildenbrand (Arm) wrote:
> >>> and have people
> >>> base work against that?
> >>
> >> This I'm not so sure how it would work. Assuming we have submaintainers with
> >> their trees and branches, the final "stable branch" is merged from those.
> >
> > I feel like it could get hairy pretty quick, but I guess the key thing here is -
> > maintainers resolve merge conflicts.
> >
> > As long as we have a specific _solid_ basis for work.
> >
> > I think actually this speaks to it being sensible for each submaintainer with a
> > separate tree to maintain their own repos rather than branches.
> >
> > We need to determine what this baseline would be for each tree though.
> >
> > So perhaps each submaintainer tree has for-mm-next that's the stable branch from
> > mm-next + any stabliised local changes.
> >
> > And each week this gets merged to mm-next, and everybody resets to mm-next
> > stable branch?
>
> I think it gets way more complicated than that once we involve hotfix branches,
> and dependencies between hotfixes, topic branches and all of that. And in
> particular, if we have to drop a topic branch in some circumstances.
>
> My first step will be to understand "how would it look like without
> submaintainers" when only having topic branches.
>
> Then, add a complexity level on top with subcomonent maintainers :)
>
> I'll probably schedule a session in 2 weeks.
>
> Whom to invite?

I guess can look at the list of current, active, involved submaintainers?

Can also send a general mail to linux-mm about it too?

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

