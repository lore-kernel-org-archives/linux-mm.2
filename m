Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F56CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 09:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAB548E003F; Thu, 21 Aug 2025 05:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A83468E0002; Thu, 21 Aug 2025 05:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C0758E003F; Thu, 21 Aug 2025 05:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 895A48E0002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 05:34:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 30B8C137F02
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:34:56 +0000 (UTC)
X-FDA: 83800255392.18.649EB11
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5E15E140009
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:34:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Typ8VIxP;
	spf=none (imf23.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.17) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755768894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Vk2rNv6sQPb2ve7Pj2mP/GF1p2TJt4JFMI53lJXfL8=;
	b=H8n1Ij+Kk0i96pPK8qFWXONfedBFfoOOHUKAf8TQYb850c9v5Fo1FlJFRUfch940MLUvgq
	SqU0kN/BVSsG5mqlGkmwRN6Ng/UYIV2H3ezcjT3hqlTt22PxIpoZvv69SCXkCP6sa4dw08
	9fnaryZt7d3nUqoGyG575XAihwWLzXs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Typ8VIxP;
	spf=none (imf23.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.17) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755768894; a=rsa-sha256;
	cv=none;
	b=cg/Blqja9lqyHYrY838rWstxKbqXfJvxj7zQ/PPWEnauMN07FtDkWJIaZSfG04apFaoX2z
	qofRFz+EcYj2ujTt7f5IaDGnHt35MetBXqTirkWnIVWdLbeiN2/dipnIlx2tFiWQV6B/+K
	8MhGHpciNeSNjIzblVt9ebPwoiOZ8Ls=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755768894; x=1787304894;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=6Vk2rNv6sQPb2ve7Pj2mP/GF1p2TJt4JFMI53lJXfL8=;
  b=Typ8VIxPV3UsrB7G4rx7ApQ3hf0FEUTM2xiCJmUXQM3tLBYD8HvgeUkM
   sDLcDrx60E+ERXnplP2sM/J9OhwIS6S9941rye4TK/8BoPIEgb3TCb6x9
   KyUMFUzhD739NcuBu7EGxB4Su8WnV8xdJ3Jq/aW5tcgX6qNPw5IuABbdF
   IcQ/r16Xpt/nazuEFQwJ3snvzGiAFY/s33lmF87yaLk1uJqCAp2BNW3MV
   y92DJML0V0I/JOeEWIKFgqqVB+38h+QLlQveyniWDzjrN6SxNvm91UMhE
   Dczxa94SwOqj7LNuwIZMAF8Q3sG3MLtVyqF8b1Xt+hMosb3z0FOJZUldO
   g==;
X-CSE-ConnectionGUID: ytuuIcn7ReSZS3qrS9nJTA==
X-CSE-MsgGUID: gZS0mkMHRVqvpL3cGmYSTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57978883"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="57978883"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 02:34:52 -0700
X-CSE-ConnectionGUID: Y0heiNaWTYy4UVfXra6P2w==
X-CSE-MsgGUID: N5zt3aWDSC2Q5n+oE/9ILg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="172786862"
Received: from johunt-mobl9.ger.corp.intel.com (HELO [10.245.245.201]) ([10.245.245.201])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 02:34:31 -0700
Message-ID: <05360f1a920afe31ddd743d21f217d7bf8ff1c45.camel@linux.intel.com>
Subject: Re: [RFC PATCH 1/6] mm/mmu_notifier: Allow multiple struct
 mmu_interval_notifier passes
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	intel-xe@lists.freedesktop.org, Andrew Morton <akpm@linux-foundation.org>, 
 Simona Vetter <simona.vetter@ffwll.ch>, Dave Airlie <airlied@gmail.com>,
 dri-devel@lists.freedesktop.org, 	linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Christian =?ISO-8859-1?Q?K=F6nig?=	
 <christian.koenig@amd.com>
Date: Thu, 21 Aug 2025 11:34:25 +0200
In-Reply-To: <aKSZ1JduQwAFSFQn@lstrano-desk.jf.intel.com>
References: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
	 <20250809135137.259427-2-thomas.hellstrom@linux.intel.com>
	 <20250818160726.GH599331@ziepe.ca>
	 <aKNT8GUu0r3i4Ikq@lstrano-desk.jf.intel.com>
	 <20250818163617.GI599331@ziepe.ca>
	 <aKNYUaPS0PiRk/yj@lstrano-desk.jf.intel.com>
	 <20250818164655.GJ599331@ziepe.ca>
	 <4lsv2lcd7lssyvcjvkqe4t2foubxbhuxrt2ptzee3csymz5gg3@jwrg3xow72lm>
	 <e96dcfd4ce7c84a5b66ff9d5f082ea209266ce48.camel@linux.intel.com>
	 <aKSZ1JduQwAFSFQn@lstrano-desk.jf.intel.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 5E15E140009
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jedomhnesdw165wsor8h53opbh7b5g5c
X-HE-Tag: 1755768893-785282
X-HE-Meta: U2FsdGVkX1/D+aKy+Gtoxd2rcgY/QDY88spmwCcMh9CEW5mSdwhOf0HRB4doUHKzbonXlJc9PXjzl93TNT09H/LykXynRW4sB0FfvaWe9M6eyM+Y3ga6IXK2xELcXotTf1qezn6Hp/R5s10MSEjmhST92adu8TmAEA9xZwOZAtqSTKaf/O6FuicDtKIuQIioHgy2IRiWFamqONnf5ffwtFjsVzqjGCptMYt+xC14kVhZ1FKfUDxd2RvhWDXMIgdjqjL8QUiUdm6vVbQ6VEml9HQ1hGBPyHuUfJTGVDezC1CuyWV4jhWmDLlVM4SEi76pCDFTbK5XVm9rn+t+itQu95Lql4Q2O5EvVJ+UqFW/16Gwz44qDQf//QS8Ts07QugCweA35hCAf+uTv60xcILalm7W7MQOpQjhF2qQsDhRSSI5NtnBK+hf2kRSaatztpoIzEXC2Wiu6VnBTIDixHxBl7vdyJvxhpDhV/6+nVS+yySJwpMFGudOgkmxetPTZPBGT3bCD2TT2fEKSkuh5FGxEJ+oWzR1yCEaasX8dt30fkv4fPZkpfBtyZ8mQyRCQhRrCzMDWny8ZXSaB8NLPWa7flv1/UASHHePrjD+mmSDv0pJQ6fxO2ReNex88s+J9JIC8jqfjiqrqRYHx912QXDoF/y+XLCJcr/bf1GmkbEyEuT84lZ7lj6ua4QAVHB4Ly2Ec99ypqS47qLBe/ysXNp7WUg44+si5XNvKGEuAF8Mjmsyikij7fJ1XpcPsJAwa7L8stJzYbv7l4zJeNO+CHMagcUQmkUveSfs8EhtV9HA81iEn97qX+BVmUkOphyc4ZbRRyhLNJjST3z0mH6LgrYuZqw0FeV677wQl3EZKb4FpWUtXgfTpTUKR+1kCvnBJFNXa6yP2/gsMJYfS9OhPlFkraHJoVkzV0iaMYaydDbTK9+THjXjpD0Gx3kYq3rYQrlKM3xgiQvAYpDJU+nkxzJ
 e3gtggch
 qDyyeoX4Cji2HZQdFw6sNTxEkPMji/xqhfLvxpzq+ztj8HskOwuzvAFX+rbDaBAQ0npu0zu0KKmgT+Lf/LmWc+fu37CmUt2R8yMubyYx1tqU3IZzKI/L9EONYlnAvhfueWRtginiJEJa95+zaQ3GhwE+8KMR9b6Yrvk8BquFL+6XRCtMujztu4pCq3cz8TexIp8tnTk0s/gzoQ9HA5deyu9JCDL4uANrHLa65WJ6DQbuCKFmXfE5eaBsCRSgUXruHB9l1FauHFG4QDbnvFB95b97iZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2025-08-19 at 08:35 -0700, Matthew Brost wrote:
> On Tue, Aug 19, 2025 at 01:33:40PM +0200, Thomas Hellstr=C3=B6m wrote:
> > On Tue, 2025-08-19 at 19:55 +1000, Alistair Popple wrote:
> > > On Mon, Aug 18, 2025 at 01:46:55PM -0300, Jason Gunthorpe wrote:
> > > > On Mon, Aug 18, 2025 at 09:44:01AM -0700, Matthew Brost wrote:
> > > > > On Mon, Aug 18, 2025 at 01:36:17PM -0300, Jason Gunthorpe
> > > > > wrote:
> > > > > > On Mon, Aug 18, 2025 at 09:25:20AM -0700, Matthew Brost
> > > > > > wrote:
> > > > > > > I think this choice makes sense: it allows embedding the
> > > > > > > wait
> > > > > > > state from
> > > > > > > the initial notifier call into the pass structure. Patch
> > > > > > > [6]
> > > > > > > shows this
> > > > > > > by attaching the issued TLB invalidation fences to the
> > > > > > > pass.
> > > > > > > Since a
> > > > > > > single notifier may be invoked multiple times with
> > > > > > > different
> > > > > > > ranges but
> > > > > > > the same seqno,
> > > > > >=20
> > > > > > That should be explained, but also seems to be a bit of a
> > > > > > different
> > > > > > issue..
> > > > > >=20
> > > > > > If the design is really to only have two passes and this
> > > > > > linked
> > > > > > list
> > > > > > is about retaining state then there should not be so much
> > > > > > freedom to
> > > > > > have more passes.
> > > > >=20
> > > > > I=E2=80=99ll let Thomas weigh in on whether we really need more t=
han
> > > > > two
> > > > > passes;
> > > > > my feeling is that two passes are likely sufficient. It=E2=80=99s
> > > > > also
> > > > > worth
> > > > > noting that the linked list has an added benefit: the
> > > > > notifier
> > > > > tree only
> > > > > needs to be walked once (a small time-complexity win).
> > > >=20
> > > > You may end up keeping the linked list just with no way to add
> > > > a
> > > > third
> > > > pass.
> > >=20
> > > It seems to me though that linked list still adds unnecessary
> > > complexity. I
> > > think this would all be much easier to follow if we just added
> > > two
> > > new callbacks
> > > - invalidate_start() and invalidate_end() say.
> >=20
> > One thing that the linked list avoids, though, is traversing the
> > interval tree two times. It has O(n*log(n)) whereas the linked list
> > overhead is just O(n_2pass).
> >=20
> > >=20
> > > Admitedly that would still require the linked list (or something
> > > similar) to
> > > retain the ability to hold/pass a context between the start and
> > > end
> > > callbacks.
> > > Which is bit annoying, it's a pity we need to allocate memory in
> > > a
> > > performance
> > > sensitive path to effectively pass (at least in this case) a
> > > single
> > > pointer. I
> > > can't think of any obvious solutions to that though.
> >=20
> > One idea is for any two-pass notifier implementation to use a small
> > pool. That would also to some extent mitigate the risk of out-of-
> > memory
> > with GFP_NOWAIT.
> >=20
>=20
> I think we can attach a preallocated list entry to the driver-side
> notifier state; then you=E2=80=99d only need to allocate (or block) if th=
at
> notifier is invoked more than once while a wait action (e.g., a TLB
> invalidation) is outstanding. Multiple invocations are technically
> possible, but in practice I=E2=80=99d expect them to be rare.
>=20
> I=E2=80=99m not sure how much of a win this is, though. On Intel hardware=
,
> TLB
> invalidations are several orders of magnitude slower than the
> software
> steps our notifiers perform. Ultimately, whether to allocate or
> preallocate is a driver-side choice.

I agree we shouldn't enforce anything at this point. But if we envision
a situation where multiple subsystem two-pass notifiers subscribe, the
GFP_NOWAIT memory might be exhausted by the notifiers called first. A
greedy behavior that might eventually cause serialization anyway.

So to behave nicely towards other notifier subscriptions, an
implementation should ideally have something pre-allocated.

/Thomas


>=20
> Matt
>=20
> > /Thomas
> >=20
> >=20
> > >=20
> > > > Jason
> > > >=20
> >=20


