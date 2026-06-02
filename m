Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEBF1CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 09:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA6946B03B8; Tue,  2 Jun 2026 05:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30DA6B03BA; Tue,  2 Jun 2026 05:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8B16B03BB; Tue,  2 Jun 2026 05:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA8676B03B8
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 05:54:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B64E925A9
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:54:26 +0000 (UTC)
X-FDA: 84834512532.30.59DD441
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2F69040012
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:54:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Tyju3hJu;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780394064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLkbX1HVnS/So1qJRm5FqYtfb6XONO20D/jzobgweiY=;
	b=HFnXXS1Ax8z+VRoQFXs9RUR+gVcnxjTK6BlZXUKLPcXcMOayaC4VmpyiifqmI6d3ymba33
	hkw1hnA3LTkyZeZuHXvN3ggDpQf/bGvCPhwa4IrwU84owUARF3p5NOMrbxniw+SZhAgMRT
	yvC3N/fuFiGTXetqUDAz1xv3Qfcfdkw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Tyju3hJu;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780394064;
	b=e/Qivtl41CJTGb+7rHjSWarhAwaeCxOWXEROfLFBBn5pXxg0lkSmoWZaswkotXe1HzyKnY
	DOpIZB82Vizq2bm/2+G/pisAGotTPRFZ7/+oUuupzXvD5oESyM9SGBXjfMBNyfyXJqgz7U
	JSIgty7XpEQ3HnraymixsEp1UQBwdb0=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490b2b037d2so3002085e9.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 02:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780394062; x=1780998862; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PLkbX1HVnS/So1qJRm5FqYtfb6XONO20D/jzobgweiY=;
        b=Tyju3hJuTEVmVGQCYza/Z3gbxiHmxun8J4kLTwPH2WhhrNghUqKOwiU3kyoVuZDrZ/
         AxbWaT6jQ4gE2kEmBvphwgFtZSi8PFObI0dHOPTI2CQulq3klU7/TZWHShXsmbS5GDW2
         fsTZ1Atd3RFjFLkr82MNIzxxMnxTPgFcR3GuvUdpA4+La5H9Id7ZwqbmtjoHuylYtE01
         xp3asJmEdfBJBj+QKXYW11FXp/Ri7a03e6tyMorPxlP7CJ6gD5KhjkgtzB3ry75KfeSK
         DgVBWUbFzyohFnRA11FpR1W8zJ/USp4+IEsrRh65yWbTVBvoQzBzPEJ202PgCtdyilvV
         N/TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780394062; x=1780998862;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PLkbX1HVnS/So1qJRm5FqYtfb6XONO20D/jzobgweiY=;
        b=b2Fclhq7eNr0mUkqfx1Q+76clNe/fZp6y9pAZKO4rZfPAL4XVXAMRQfRfVPpVRKZ0i
         GHyd3C9fJIrk6LrKwN2eeEwAO6c7K2k0hzC3YlC6mFaJZM3gMmz4GyqAXYpJtnPaLFRK
         E1ax/5SRdULzvCFwz1p0X33wdZh7l92uN7WtZ1Ca1f1JpRJHsxKYrQitjtVNhD/m1zcG
         eOBWyHZNPGBgQfTANmgpDP7chS3vfzBOMd4Uak64quV6fk4DCgkBpZ0DWpz5A9cS2pCi
         JwbXnpB4oHg1mM7wTdFDF1Abe2V8P/6E2wr4/LOWyDkc21nst/jP8KT8Bywx0DGSHrOi
         rlpg==
X-Forwarded-Encrypted: i=1; AFNElJ/LID0imxQId2uEjpb7q4HzQ0euUAbivfar7I5QVfNHWMijUql7WWH6Vl/hvZgKIyzI0JML+PNjMg==@kvack.org
X-Gm-Message-State: AOJu0YzqrYApMDojxfPgX+bSPyW3CAV1kqMm62MQge13Kgb8FPGMwjpy
	BpTjV47tMfu5Apz/A+5B2FgwqiH7ciWnv81Tk50rnYjlSDc4DepqO/jhAolQ3oJ8aTA=
X-Gm-Gg: Acq92OEVvbQJyz2UWRHigV3DHQ+G8mh+WRMqfv/i8cTZPV6Pf6b4FB5Ehc8RLSvADM/
	WmopJhhX5F7XsMbyvH9IC1h6vwZbh1yOgT9o97tZyTXR5d79T8KV3nlMRsfllWGS7Vja6TL+LDO
	GmzAVvnQk2zPvKK+6HotAEaoqTnLa7kfLR/nH3XQjZ7yL1Wa/e49lKo+7ReVFcCs2vWfP9zrEqN
	Qz17SWz6/B2ZdeVbqZg9SoX7r51I6V2IEKTQFSIuO4tW9rECMFUHPomzyuOyM30S3piZeujBhlE
	Gd+ircDY60As5BfiKd7CfVAcvjOUvRHJ2/9pBfqWl1OZdASKMT19ICmUut6H6zkRlPt7rK7slcG
	coDbrXJmwniBZJslV/Klj/w+fQ/rt3GhiHpjqDLxvHU0YkMHF+7PKnKkRJU9JI19uN+CE7mOGG9
	8IGyjLXZ54w37gAnrbIyYs+PPwhWtm6wc=
X-Received: by 2002:a05:600d:848a:b0:490:9d1b:f06b with SMTP id 5b1f17b1804b1-490a2943afamr189761525e9.26.1780394062160;
        Tue, 02 Jun 2026 02:54:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::6:2ad2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ab55d39csm35194975e9.35.2026.06.02.02.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 02:54:21 -0700 (PDT)
Date: Tue, 2 Jun 2026 10:54:19 +0100
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Waiman Long <longman@redhat.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: don't allow empty relative nodemask in
 mpol_relative_nodemask()
Message-ID: <ah6oS7wiGB4u4-eR@gourry-fedora-PF4VCD3F>
References: <20260528124133.c88c27b11a8ea0ef05e494f7@linux-foundation.org>
 <20260529152616.2308736-1-joshua.hahnjy@gmail.com>
 <ahnRIDBk4bQ3xX2q@yury>
 <fe33c767-ea11-43e2-8732-f752c9c1205c@kernel.org>
 <ah6X-RtVX75YP7VX@gourry-fedora-PF4VCD3F>
 <c98eb14d-b878-4eeb-91f0-d2b1d4407e1e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c98eb14d-b878-4eeb-91f0-d2b1d4407e1e@kernel.org>
X-Rspamd-Queue-Id: 2F69040012
X-Stat-Signature: hxbidqhuj6scmtdtt9fm5cqmkm3iyw6q
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780394063-434314
X-HE-Meta: U2FsdGVkX18oHSACyXQ7+QJZPYC9BvwJ1oNU2/+u53cWajU2ucind50C+TgWiQ9F+LDryG52PwEWkRDP64ew68TiWBVz/EfHGV7dtOyDe/87pNVNuRJLHuVpcR26YXRWB6ErM0uoPp2cIMJOS182xFFy5CGzaOZmlsmpitPCrevhr6Q7pwzQG+5UdeUiegVI7OCLv6EH+9H3MgP6iN11JqpralZjX69Z9B54KYdluf3Krtdzmi/MnLsekmbBA0z8+Y51QdMeP7QLa6Fpda/efmWTVEK+yWY0Jn4fFoywknr8Fmt/Rr9AktheAUXMnQ9dZ5K87ocN/xMTBtf1DXYaWPaXrQf+3jyOE+rCzuT4vz+9y/Fjy/Y1WiWPTdL2sxtmBCb/UKMQrZbuArxBgmLkwOS3bM263DlZtDMtN9r2mmlgXrxQCkF8RF52lfeRhfvWK1MGJrItDPCQkhrTzzKa9GRkdD4Uh6F15N5K8tcr/JppG3EVky7Fbm3X1wxTqtHd5HNflwiJha3WpF+p1jPgOitYqhTlR8cIgps+q+JRKmXATeyeAPIcBTam/dCUx4ZW9B7pb3JNbIv7a6ix+NRoUEgEn5gLU1Ih+I0pZ2S/Ukg5y01SSipGQvCIJcfTZPwfTgQNFzxcDLFt3MG+OcrkY0fNdU2aaBkLI2C/SOpYCQGfetIwTzJa8/vlvpM1WTS3Q7jwCaVE+ftv/kWHx71kDzkvDK/d5hroGXHttRekZoUZYIMYXkA2c7mc5xNunaKzP12G4exbzLwYUigGxTeuJrfqzx6wqfsHlL2H06FVZO1qxPhV6mlFSsAZcrx/YEl7IYm3dTF4rJxPyWuv569OofgTOOR0d+0m8AWj0UydEIr973YSMF8hVTnG425Zp78VkMBA4bspLk01tMm6o+8XkyOVCpNlbR+TeeERmMzTIlG5yfp+nUzk2KPnZ77BlIW/MIEj9Ifv8+JMuWmvZGo
 XUv/+kQs
 EwwxojqAiHd64e5/UKenzGImysG+ktqOZGayTD4Qb5tre8q8H+niXVVuCr5/Je56P/bbaGwrkmDcylPk0QrP6dzaYzD4c24mVgkG7I56csPBqNCuQOLOG5STKtE7apkD/FzMDQUKrJcBuE4v9NDerDePPwziWsXTHJRJ6kHe+Ekn4pisEtl0S8Le1szS0IIc4Oo4DBVpPUNd2mHLjjlyK1qkghNbp4OZT8qPQncOYJb7eqLSsKx2ecf60e9vnyDIUgvUFvurV2yQ4ZtsIbJgzbzMnzJ+LcOJAztSpAcaMdKvjI1XLPGSrjDNq1egI6U5Iee0d0TuRyFDraLQ5oKSBjapL07nIbCVhDZ53fYLJBuo/4GT7D4Qs68LnbrxGbMu78gqv3Y2N2CgH3kHrRDdW0a25tlotZClnPp5D21nzHBW2O1loS1oWl9JtMYH1v15DB7cGFrvskX6EPA0cDuHIAtCRoQwLdPGm1zPmC2bxyW193xjCC0gHlUYq+IytJvadH8CS84E8GsAFiClX1+Sz8hq4rcWA99ldLD/v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 11:19:49AM +0200, David Hildenbrand (Arm) wrote:
> 
> According to the report [1] syzkaller can trigger it. There is no reproducer,
> though.
> 
> [1]
> https://lore.kernel.org/all/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
>

The actual implication of this report is that there is a bug in cpuset,
not mempolicy.  

  mpol_rebind_mm+0x3ab/0x680 mm/mempolicy.c:569
      ^^^ should never receive a 0-node nodemask ^^^
  ...snip...
  cpuset_update_tasks_nodemask+0x22e/0x340 kernel/cgroup/cpuset.c:2777
      ^^^ calls guarantee_online_mems ^^^
  ...snip...
  hotplug_update_tasks kernel/cgroup/cpuset.c:3882 [inline]
  cpuset_hotplug_update_tasks kernel/cgroup/cpuset.c:3985 [inline]

Relevant code:

void cpuset_update_tasks_nodemask(struct cpuset *cs)
{
... snip ...
        guarantee_online_mems(cs, &newmems); <<< critical call
... snip ...
        while ((task = css_task_iter_next(&it))) {
... snip ...
                mpol_rebind_mm(mm, &cs->mems_allowed);

Seems like maybe mpol_rebind_mm should be called with newmems, not
cs->mems_allowed, though cs->mems_allowed should never be allowed to be
empty, because that makes no sense.

Just eyeballing it, I can't say whether calling with newmems is the
right thing, or if mems_allowed should not be allowed to be empty, would
have to dig in a little further.

~Gregory

