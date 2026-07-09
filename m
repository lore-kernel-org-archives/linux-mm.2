Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 264DFC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 09:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BCAE6B0088; Thu,  9 Jul 2026 05:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06DA66B008A; Thu,  9 Jul 2026 05:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9FCA6B008C; Thu,  9 Jul 2026 05:47:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C30DC6B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:47:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4AD8C1C39D7
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:47:52 +0000 (UTC)
X-FDA: 84968761584.20.156E2A2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf06.hostedemail.com (Postfix) with ESMTP id 78E92180003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:47:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kdCbjirh;
	spf=pass (imf06.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783590470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSuJLx9SE57A7qIxtS+wkjg1DUj+y6sjOCSXMaWQQak=;
	b=DliyNIHb63bzmqRw9zKWHV29t2KEluXFNPGgRq+xdINgOMqcnie7GHxeWRn00KrH3OlWU/
	uxHkrpiJG5gd+jPRQpratuWEtpbonN+MvA4RfdNn6VvIhCvprfBDWbpSdnX9+Gb3W8VVhH
	PjcScOK+XNfAf7lO4nRKyEv8M5eKVGU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kdCbjirh;
	spf=pass (imf06.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783590470;
	b=OpedNd/7rT1WiYVs0NdSPr3pMTRyV3/thYmJnbhep5ki6pp6mDqbP5fA0SW9NgQ2IFF4X3
	rp3l1MTy9bBtD+ClXe2ZcKxGKQoVWpG9KtfhG9BSUiyNGc56Qr2pcf4yvXXKqJunaBJ6r8
	f1EytEaXdBZWubV+fMJw7imu/kzBYtQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783590470; x=1815126470;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=SSuJLx9SE57A7qIxtS+wkjg1DUj+y6sjOCSXMaWQQak=;
  b=kdCbjirhD03ZoFSekIX0+keWLEevDkqtFmgPPZQ8w+xKUdQ9QPIpH2lZ
   g1D58CnV4aOOaW4D0GOTnTYs5fCzMLXRPegJY82+Gtdys850TZ7Uuv3+B
   YEjxrOO40JiNGWuhb3Qb+Wt4cVGWJ27RGgyFMM1WWFBMVtCtCB42EVd8h
   dydpOzViHzLLwgLzd+RGihL5Gz/bqlacUEfTTAp53oXWTQW9O0UI2v9+G
   xavOuLEO5dlVmFuXzdZ7+WdKAZOmjseWQZf2zj17Zfo9iiNC86LJ/9JV2
   EMt0lNK40j/LByQp7KiYUn5w+tkXnvVMaBqO/o+lzy+o+aNnbM4GukF4Z
   g==;
X-CSE-ConnectionGUID: H9lP/dwnQYOelfQV04zpdw==
X-CSE-MsgGUID: Y7Z8lo2DSeiplu7L2nJSVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84380020"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84380020"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 02:47:48 -0700
X-CSE-ConnectionGUID: 4ygGpAhyTYeln8kGMGST4g==
X-CSE-MsgGUID: th6FiBwhSfakI1Bu3JJT6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="258142936"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO [10.245.244.44]) ([10.245.244.44])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 02:47:41 -0700
Message-ID: <265737ad21d42a7509a8c43619975f0ef150f275.camel@linux.intel.com>
Subject: Re: [PATCH v7] cgroup/dmem: implement dmem.high soft limit with
 proactive reclaim
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Jing Wu <realwujing@gmail.com>, matthew.brost@intel.com
Cc: christian.koenig@amd.com, ray.huang@amd.com, matthew.auld@intel.com, 
	maarten.lankhorst@linux.intel.com, mripard@kernel.org, tzimmermann@suse.de,
 	airlied@gmail.com, simona@ffwll.ch, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, natalie.vock@gmx.de, mhocko@kernel.org,
 roman.gushchin@linux.dev, 	shakeel.butt@linux.dev, muchun.song@linux.dev,
 intel-xe@lists.freedesktop.org, 	dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, 	cgroups@vger.kernel.org, linux-mm@kvack.org
Date: Thu, 09 Jul 2026 11:47:38 +0200
In-Reply-To: <20260709061114.1623774-1-realwujing@gmail.com>
References: <ak81RUK6vRZaMN2D@gsse-cloud1.jf.intel.com>
	 <20260709061114.1623774-1-realwujing@gmail.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 78E92180003
X-Stat-Signature: ad6gix1kjgtptgxndtmwtb1o8f66o4ro
X-HE-Tag: 1783590469-102799
X-HE-Meta: U2FsdGVkX1/TVwHAvZ+UXP/MEq7ivti0VW8z9eO/CvGPL2U+tQM0H0uqDaS/E9fx0OMHXg7bUp4KI7fFDIi88BbiUkQ2BEHiuVbWsEqiBCNWcGD5xs9XwVEQWlMe62aDvugkmB2y/Ia8n1i+otyFW/LSwk82Yk7bGq+ebRnJ0QYoGpG/yX6VNIscKSwdE+q7sfDg/2cPtDDWVNlMlpnpnDryBrT93v2tp6fPNHcwmjgD8ERGDw13wAAXQtsa2VpivDHAFLAu4vxv4IhaibFhUaHGjut9NxjEqYy81WLvOKfpNkHf0C36fXUUGQ2hkHHNlKSgiJEQJLcXyNl2pDWdeLbQ8qbUg9d8AMiu7sarBbZ9E/snqxHAaqqG6iojfU6fs95Tr3t26Qaf5gZtzpZbDuXzyeJHe4PYh7/txnETZ3r2ag6KwdBL12b1Oq2g1Ox+Iplciil85ilT45Z6KUd5FYq2dYO55Sro4xxm1wD8PWz5vcpL+5tLXRRoUQ8Bx4AE+AzBb+9/IxbUMC1Ij28EhWkFRwCikSU+OpUSOOK8FzsErkSN7CqzGNQrw/phQek/SAqlgPbTWKxmMzjVb5LR75EI8oPiEMgKoScmgHcE6uyI3zfw6juPQEpifUJK9blKxDAZER6vRCk3rU+65aaGP0p3umtAPxtUOX26eMN2d2qSbg1jPovqdx18EhAFdOgF4UqE0YrvSKnL6FSbAJeklOFB5wLMR37TM12hyTPm521DCIqOMmmM1aOs6vwfv/R0LBS3mXUaAbquhHGJpJAZwZpggPnOS6HKhn7DnWkTxm39KSyetT9murNto1T44T30GHcY7KY4ONBGcwV7chdWJHr6kV2efPjEYVYpnDs5GvT0MiNoPRV6gvStZQfj/lKE0BH8HE/j1tO2VP5Z2AHZTQeRI7eEPCzQO0jyl2HrzulN2I7W5/S0i4oHjU7b28NL/ZFhwJccQ2LkhV4Ua7r
 dWWkb+td
 WtoTI3YSfjcmHRQftKsM2ap2f+vQxMwtEAZgyAOP7XTFQFrmEGznQUsYQlDLDAUhd+2kdteLZshZVXaAGWLmUCLS7G70R9riz7SeDbWc6EcPkkndD51sw/b+PuSS8+MtK8DX7tUJafKzrODNUISyh2DxQ+G0RqPtfkA9AyJNbkNgBQSME3LrxWrprnWiEGObpKq1hxEMjapZx3k4/6TI1BH/DqLZsmkj4wjKpN/EoU0EWkWn6DuDcwhgF5v4zxUi0jEJ0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-07-09 at 14:11 +0800, Jing Wu wrote:
> On Wed, Jul 09, 2026 at 12:44:37AM -0700, Matthew Brost wrote:
> > This looks quite similar to work Thomas is doing here [1].
>=20
> Thank you for the pointer, Matt.=C2=A0 We were not aware of Thomas's
> series
> before your mail.=C2=A0 After reviewing Thomas's v7 [1], the two series
> turn
> out to address different =E2=80=94 and complementary =E2=80=94 problems:
>=20
> =C2=A0 - Thomas's series hooks a reclaim callback into the dmem.max write
> =C2=A0=C2=A0=C2=A0 path: when an administrator lowers dmem.max below curr=
ent usage,
> the
> =C2=A0=C2=A0=C2=A0 kernel calls the driver's reclaim callback to bring de=
vice memory
> =C2=A0=C2=A0=C2=A0 usage down to the new limit.=C2=A0 This is analogous t=
o what happens
> in
> =C2=A0=C2=A0=C2=A0 memcg when memory.max is written below current usage.
>=20
> =C2=A0 - Our series adds dmem.high as a soft limit enforced in the charge
> =C2=A0=C2=A0=C2=A0 path: when a successful allocation pushes a cgroup's u=
sage above
> =C2=A0=C2=A0=C2=A0 dmem.high, TTM proactively evicts one BO from that cgr=
oup before
> =C2=A0=C2=A0=C2=A0 returning.=C2=A0 This mirrors memory.high semantics in=
 memcg, where
> =C2=A0=C2=A0=C2=A0 reclaim is triggered per-allocation to keep usage belo=
w the soft
> =C2=A0=C2=A0=C2=A0 threshold.
>=20
> Both mechanisms coexist independently in memcg and serve distinct
> purposes: the max write path handles capacity reconfiguration by
> operators, while the high-limit path provides automatic backpressure
> for workloads approaching their quota.=C2=A0 Having both in the dmem
> cgroup
> controller seems correct.
>=20
> > Are either of you two aware of this seemly overlapping work?
>=20
> We were not, until your mail.=C2=A0 Now that we are, we would like to
> coordinate with Thomas on a few interaction points:
>=20
> =C2=A0 1. API intersection: Thomas's v5+ replaces the bare u64 size
> argument
> =C2=A0=C2=A0=C2=A0=C2=A0 in dmem_cgroup_register_region() with struct dme=
m_cgroup_init
> (which
> =C2=A0=C2=A0=C2=A0=C2=A0 bundles the region size, reclaim ops, and driver=
 private data).=C2=A0
> If
> =C2=A0=C2=A0=C2=A0=C2=A0 Thomas's series lands first, we will adapt our p=
atches to the
> new
> =C2=A0=C2=A0=C2=A0=C2=A0 registration interface.
>=20
> =C2=A0 2. File-level conflicts: both series modify ttm_resource.c and
> =C2=A0=C2=A0=C2=A0=C2=A0 ttm_bo.c.=C2=A0 The changes are semantically ind=
ependent and should
> =C2=A0=C2=A0=C2=A0=C2=A0 compose cleanly after a rebase, whichever lands =
second.
>=20
> Thomas, would you be open to coordinating on merge ordering?=C2=A0 We are
> happy to rebase our dmem.high series on top of yours once it lands,
> or
> to split out any shared infrastructure as a common prerequisite if
> that
> helps.

Sure. Let's notify eachother of imminent merge plans. I will rebase my
series on yours if yours go in first. If needed let's look at a topic
branch that we can merge into drm or vice versa.

My work is stalled on lack of reviews ATM.

Thanks,
Thomas

>=20
> Thanks,
> Jing Wu

