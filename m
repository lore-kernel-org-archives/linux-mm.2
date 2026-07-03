Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 615D9C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B540A6B00B5; Fri,  3 Jul 2026 09:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05576B00B6; Fri,  3 Jul 2026 09:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A3B6B00B7; Fri,  3 Jul 2026 09:20:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 752B56B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:20:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EFA6F1C07C2
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:20:47 +0000 (UTC)
X-FDA: 84947525334.02.48EA3B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5E099C0007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:20:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=COLcWCYB;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783084846;
	b=6Jbc7nHWWXCs841ox4ZXa2BEh4y67DwGvbmlFnrja1g3q4l6zMNNm6BtVSA+uLzPciWFBR
	C0j2Oylumzo7zBkSLvoeJGqDxlN0/Wph7L+9/b6hnXoCD61p4IRznazH3MyfXlLqso2NYc
	boNzPDc08leSLdmgJOFckSAOw9zpcPk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783084846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DMtNEtbh86PE/0OtSHafNiiMNiX2mMRVhXm4LGea/eE=;
	b=Oolh9qLaOcZ3HB6A1xEluYKO7LtvpYrxv5Q2O5gfQfaqTepdBJV2zthGkIh8S76HqK4l9C
	xEyRwXoS2zfXNqthuzLTshqGe/KbE9xNX4sPwBC6T+7JrshNP8q+WV1E08whzq4hiQFoxD
	5/QL55PpTjl7ZAEqfq5GIGWdM5fcVCg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=COLcWCYB;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 28FE841605;
	Fri,  3 Jul 2026 13:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC53E1F000E9;
	Fri,  3 Jul 2026 13:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783084845;
	bh=DMtNEtbh86PE/0OtSHafNiiMNiX2mMRVhXm4LGea/eE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=COLcWCYBFT9dd93pF5q2QEyFgZQkzG1MIG1pbKLA7Iqufd1ueWiJhww7kRKP1/Us1
	 7jZQ3FGx35azOG0U/OqArHOXVUnQo3ZbamsNIryLfGzHDK/A4RNwcjMtuiY/y3XyhM
	 PJwSPxZxHNLbOAmD59sbkzC9BCcuiN3o0tGsX//fnW50q4TueRw/LsGJ4a5mrT0pmD
	 aeUEpglPCCvC0AQLzRWBn66GHeWX98d5Wmw36HEdFxXRmKemLZA2/9Jdiw1lUnFYMR
	 B+45sMK7yABG6VQh4p6AHeUHilH+1lpYA3VdApKKwBTyN90fxFYkkeUWLmE04v6qAs
	 V9jXfSdWfX0tg==
Date: Fri, 3 Jul 2026 16:20:37 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Oleg Nesterov <oleg@redhat.com>, Peter Xu <peterx@redhat.com>,
	vova tokarev <vladimirelitokarev@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: prevent registration of special VMAs
Message-ID: <ake3JZJPYHP-0N7n@kernel.org>
References: <20260617194059.2529406-1-rppt@kernel.org>
 <5a993689-f730-406d-8515-8bb6025cc851@kernel.org>
 <ajOtfdGgFQYL-T6f@kernel.org>
 <ajOvwGs5xhnfBu-k@kernel.org>
 <41ef0dce-e973-4947-b5e3-150fdb07f1a6@kernel.org>
 <ajO4sLq2UBciSgOn@kernel.org>
 <dd2ae577-9b7d-4e40-81d0-fa9fcd7e0767@kernel.org>
 <ajO7yI541hphWRb8@kernel.org>
 <11bae87d-73e6-4946-a41f-c5542fb40b75@kernel.org>
 <akeJdxdZXAFb8XCr@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akeJdxdZXAFb8XCr@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5E099C0007
X-Stat-Signature: gscgo3otzici3cyw3he3k3dm5bx8yqrg
X-HE-Tag: 1783084846-300418
X-HE-Meta: U2FsdGVkX1/SIirCVawM55dGubnohhBb6SitIPDKFO/+WjvIxTm8rASn0KNr7PY2RUhKaavEMh6wI/Jt3IesbE4gQ9xED/DKIsV/tTouIE+5Hk4sxtdD6i2OzS0dvzK4lcDUx92C4C1dcF8n90MSkIk90IS2jeVuAOFJrjzckvQk06QpzQUt3es0S/dumkCGaG4ynFNBhghwAPKm/Eg7K3ypz7VIhTBa9o6Qoa8aUOUMpIO9Z8q0mARQ21O3aFunujXRRiXRKUP5O8Z+b7S/TYyvIqC4Sq7evkEwSxEek0vgmptu3UmxWQQHdKGctMplET1P0hbbJw+mVQlmIso57QpgIt6rcRBKa7CtdOLisg79bKRMvAbDiUnQwS3jevhgqm1TwmnVbFeRv4oVLo5TbYEQ4yY/OrA6yaSjb7NSjvPOY0iLk1X/5cK95nNEkNIF/dCNyb/qIpgSjKexGYCW1LbynwmDDQDdekN+bFTE4MvUcXdo5iYxLHywv1/+zi8InbVbdeFfoQKXHLlxZeDMEkTIhPQpzpDfcEIrg8O+QyoHuvTPU8UeRnvsdp9BGAzx4QDDVzgFTlBqczzwAG9rRbSPqAEy22sK7Y7xByVi9WeZ/e8sHbltb9Do70XZVKOmiHFoDmZRCM+WeXkkmyCzLV0Hyza2Arj+etZKwuCy3Pa1673Y2FLmDLTUgrYXCAw9ETy+QUSc6IPsd7vH/JEb5VwV6Y/TfGF02Q8RJVYedlLyTBbDkC1Mr3N4LvPII25okUUIgYtLMpohcWoHaI/ZC53gVBWeZqGuEhm6VPqLQCiz/MaO1jeMzVYkmVn0ns4fl1xGN99iav4QlHnUz8WOPG3zjnLaUr1TALdLdODIcvoyV3p2N9Gyo8M4bOczx6ebBPOdueu3MrjOqeBgh1rayHoV2RwLoJam/EFeYWnG7gxS8mBhfGqmGTdc2phAY0zx+lashcyibm9Z5Ro3zZB
 u1xAnFnl
 iyzWDeq1KAGOem6xI5xaTZy84MtGm89ZQPRNplWISTvjH+8VjiKp1+1Xpcso9Ciz8qkw7AJ9gosL1Df3ML00pTDjusrMYQZqXO8ZADwF/qQyT3aqdk8UwIQwr4qVnDDtdZQDsbRwUHsvMuWspJkP54aLxJLvlkiM7t3/1Ft/C088xs/HqiNF+afsEUxGXnmDINcnPD6A1icWdaeINbms7KTZQ1lis2tL35QNqwOJGd3HWkf+Jn1tkcAW/zBf3prQ3i4rev+XirhLFp/7b0kGT5Gqn1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 11:11:14AM +0100, Lorenzo Stoakes wrote:
> On Thu, Jun 18, 2026 at 11:37:10AM +0200, David Hildenbrand (Arm) wrote:
> > > In a way that's an extra check for hugetlb, but it will work.
> >
> > My point would be that we exclude all special VMAs, except hugetlb (which is
> > special but supported ... in its special way).
> 
> Mike - you said you were respinning, it'd help my series if you respan the above
> quickly so I could base my change on that :).

I sent it already:

https://lore.kernel.org/all/20260618095017.2553004-1-rppt@kernel.org

and Andrew apparently ook it:

https://lore.kernel.org/all/20260618183442.BBCD71F000E9@smtp.kernel.org

> I can send a quick patch if you're tied up also!
> 
> Thanks, Lorenzo

-- 
Sincerely yours,
Mike.

