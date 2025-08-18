Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BB3CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 16:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA8776B011F; Mon, 18 Aug 2025 12:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7FCE6B0120; Mon, 18 Aug 2025 12:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBCDA6B0121; Mon, 18 Aug 2025 12:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A91A56B011F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:42:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 514A6840EA
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:42:59 +0000 (UTC)
X-FDA: 83790447678.21.1963E14
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf02.hostedemail.com (Postfix) with ESMTP id A91DD8000C
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:42:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=maw53CTF;
	spf=none (imf02.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.16) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755535377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FFRgUjm1Gro1I+69P/TMbAic2wfSm8DMVKGUgEm0vxw=;
	b=qB6BcaLtDOUlAHAjAJddm1toZ/4gdfoVDsy8t5Evcl8JQrf2Nkq5Pc7Eo8gmUbhUYGyiza
	u7yYscpGRTYWBmo6HVa2sEruWI5DCOSxSTOIAms09Ii6P6k1cCHvWkTadxoByPlAJ677EP
	u1x1BKnCJGwIbnJjeBvDDPp+L8x7kgg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=maw53CTF;
	spf=none (imf02.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.16) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755535377; a=rsa-sha256;
	cv=none;
	b=vfvn3fWpXc92YUVtKrpogJr9VK45l/OjiTzOmz6zYo8wU0K3e2nI1lJY8DhCNSgQTSQqYO
	ZBnX056OWHZRnPqfD1g3kRAKC5M+JQKd318juLX24HZoH5CfrGMIW5pvAYD3dkEsC0gLG7
	sFqUDdQlrb1xRqH4oWn+iQXFkG+jhyg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755535376; x=1787071376;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=FFRgUjm1Gro1I+69P/TMbAic2wfSm8DMVKGUgEm0vxw=;
  b=maw53CTFmkrYF7Mg2LCtKnBqlqr8Sbb/RPP+EJm8zmWfSaT61XZZBXU4
   uzUuM5YsNnH+h+v7ZK2E5iaxwGN9IGdPDYPcGPPUZyQ3xiomveY7MClfu
   7sYS5OlRprSH/q6PfqA9/6d2YfZccjDsYHpsyBGjuDnECsNO8tiQD+I9G
   PG37JQjHebWFMh+uv5D9G4QDnzxsd31LStvFS4sLEbNDSsJIphrk85nxu
   dpvQV9IumKLY1V0UCPLJ+nXtr3dSoGLgIIGaSPz9Qqm3LeuTkE45XtypK
   67Pv6n04/Bs0NVO+8EZFmYZxGBhnFsekTItkbygwPN7UcXvkI+TsUfWsA
   g==;
X-CSE-ConnectionGUID: hXks+cyHQfSUHRQx4jh90w==
X-CSE-MsgGUID: +aHYkbUQRIymd9m+9xxiHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11526"; a="57913907"
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="57913907"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 09:42:55 -0700
X-CSE-ConnectionGUID: hg58vD3gT1C5B79/FUkiiQ==
X-CSE-MsgGUID: wD+yurJLT02ZIM7X6sfNmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="167863384"
Received: from abityuts-desk.ger.corp.intel.com (HELO [10.245.244.38]) ([10.245.244.38])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 09:42:52 -0700
Message-ID: <d34ba6c8c68a2fa85f052bdb4d27be15561f4861.camel@linux.intel.com>
Subject: Re: [RFC PATCH 1/6] mm/mmu_notifier: Allow multiple struct
 mmu_interval_notifier passes
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org, Andrew Morton
 <akpm@linux-foundation.org>,  Simona Vetter <simona.vetter@ffwll.ch>, Dave
 Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Christian
 =?ISO-8859-1?Q?K=F6nig?=	 <christian.koenig@amd.com>
Date: Mon, 18 Aug 2025 18:42:36 +0200
In-Reply-To: <20250818163617.GI599331@ziepe.ca>
References: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
	 <20250809135137.259427-2-thomas.hellstrom@linux.intel.com>
	 <20250818160726.GH599331@ziepe.ca>
	 <aKNT8GUu0r3i4Ikq@lstrano-desk.jf.intel.com>
	 <20250818163617.GI599331@ziepe.ca>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: A91DD8000C
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ucgygskke1au4c3qhkf8u5prb74zx78c
X-HE-Tag: 1755535376-151453
X-HE-Meta: U2FsdGVkX18eh5bSCwd9tDC3f8uKJORaNR48xEQTAES9ONRF+HylPiAAisptgryetv0tOcMjmvjonEBEt3SlsckdrqNYiehjPf7iJMJgtccDENj5YBvJYrNxf8rlWDirWq2h3SaMwMLIaIRBiu7/Ihi8S8n9oGKWWyZ5hc9h0SnW4pgxTGpwDVcrwGVMRFheGy77IzMY3GcOoagBNFXd7rxeI/5OMPng62QA1E/zk4/OkyQcll3EyTBQnsr/zefb+k/M+D1SjLoLmRFD6dmCrlI124kO6fnFaD3xuRa4I61lVC6mdzqyJbuo+9QYUbual6kYIuaC8jHpTmVB8ZtvrG3uH01hu+EZHgiGPDlSOQIcxPMg+CnOvzKF/u1LnDTUpyPHXXKTyX7N/iHxNK1Dsj3bYkjhNMdRBkxO9ipdnVHdYIA+kqLcBGEjp2hfediSZwmbgydd22+zkadhBG4rgk4WF5qaAxsZpsy5mmBHf4254B7eFSjy+uYuDWT+HXs2xBJIdQSxrsyg4CKLB34tsPw4XXh6ufhpQSqqo9l8ikIN6NzOM/qCIlPspI7zMrdPFwELuaAhZNAZowTHfB3b1PhK/Ut4k1eUNJj/g/2J7LkIzpoZiQbN4MmmvLv34GNPq8SWwMdkRoHgQ5aLxNDOPn/0gvn64bnAfp5Fgd5AX6Uzh9wGlvabLnczMf6aWqYbNje/czrPFF0i7l1ARVavQ66H7rPrUCDSB1lFPcqDq6kfSdAMeFN10upbNicstXmW2wCIqiml7PP1bIxm/TbW94avSpzW5kIdYAkaOhemMI52XD/CM5f6Z5/UkXCoGQDPoyIoLDulec9IM3SvK6nKJr1C18HcG3nutQGkO+m3ImFjwOqEPR3ydUcTHG98N8AXPYEX7aS73IuKNqyhOdjQSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-08-18 at 13:36 -0300, Jason Gunthorpe wrote:
> On Mon, Aug 18, 2025 at 09:25:20AM -0700, Matthew Brost wrote:
> > I think this choice makes sense: it allows embedding the wait state
> > from
> > the initial notifier call into the pass structure. Patch [6] shows
> > this
> > by attaching the issued TLB invalidation fences to the pass. Since
> > a
> > single notifier may be invoked multiple times with different ranges
> > but
> > the same seqno,
>=20
> That should be explained, but also seems to be a bit of a different
> issue..
>=20
> If the design is really to only have two passes and this linked list
> is about retaining state then there should not be so much freedom to
> have more passes.

Actually the initial suggestion was two passes only. Then I thought I
saw a use-case for even three passes and added the multi-pass thing,
but I think it turned out we didn't have such a use-case. IMO we could
restrict it to two-pass. Matthew, that should be completely OK for the
SVM use-case, right?

/Thomas


>=20
> Jason


