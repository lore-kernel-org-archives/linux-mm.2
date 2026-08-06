Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BAE9C55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 07:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FF226B007B; Thu,  6 Aug 2026 03:58:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AF606B0088; Thu,  6 Aug 2026 03:58:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89EB06B0093; Thu,  6 Aug 2026 03:58:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 688EC6B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:58:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C6BE41C12E0
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:58:52 +0000 (UTC)
X-FDA: 85070093304.19.CE0A192
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3825A1A0003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:58:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J8YD+Krb;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786003131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Qdw3rPKOE/bqfzieoBLsN+JJCKDj8Yo0JXPMaKeuak=;
	b=ZJtP0b5EClOp8/leUdzRaeqk1HOFVz619ne28XGnjobZG5UA0ZJLqe7uzi6boxPONbE5dv
	oJ+1JlDNidiJ83Pqoyt14Rp+yWpqwMNXhZTbYdfOadXPPOx/I6A4wDrbKzCQQDAU9LudQ4
	TecmXhrhvIirla9J0XvFg5qHoPTtXyE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J8YD+Krb;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786003131;
	b=fCMk8fqMR3K/N0dVRm/gIoyUiqXZseRAv4ozHuf9Q/lHh9DBBvAvGCFvDCEl0SVlLK4C7Y
	mDC/nC4PpaMnRKFrsdiRfXwHWt3l8gQMDWfaDoLOCJLjFlxNRSDMOcmyYKPM1J0470Xf5F
	V+RffRM/6KtgIDskVBISfAnVqYNOMZs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B7C0A60A8C;
	Thu,  6 Aug 2026 07:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0881F000E9;
	Thu,  6 Aug 2026 07:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786003130;
	bh=6Qdw3rPKOE/bqfzieoBLsN+JJCKDj8Yo0JXPMaKeuak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J8YD+KrbFok+1fwrI0iVh4vH26ewld4lv4yE4DFBk81pY0lZdIVyTtOduja1KQ1L3
	 BV958JiLuPY/ayW+tVLF8iavvaLcHpcaNd+5HKEnzG/wxP5fw0xcGz5ZrCF96Ga3rQ
	 ckARtxPyCWzm/OG4zer/hsYuw61JO3TxKyA3pb1bv+sVmLiolZQc9VE6T8be16/0Lj
	 pxPY2tkmJr0KqCi8N0/leBGXsiRewNbRPX/Jt8LHaJlHqqSX8Ocp0sZRGKAA/snYwu
	 kWb5phclr88l1FQHh0l1AcAt9lBb+HtlHoWI3czYHgwuZFMhavmOxmga44ZQ7ZyAHq
	 m/0hJeUVeZY+Q==
Date: Thu, 6 Aug 2026 08:58:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: linux-riscv@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, kasan-dev@googlegroups.com, David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH v2 00/15] riscv: add Svnapot PTE folding support
Message-ID: <anQ-GfzFl-thu3q8@lucifer>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1784201104.git.cuiyunhui@bytedance.com>
X-Stat-Signature: 4wtqa4gtfiuxk1gtuxfe3yxgmyfohb3f
X-Rspamd-Queue-Id: 3825A1A0003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786003131-883182
X-HE-Meta: U2FsdGVkX18iv0ves9AQfZRn9TAXnn6/YzHaGJIMr+uQi92NJRfisWggooagAsMImCdhdr2/8Yx/QyjyNNFo74C4PRZdpOpaz9ShM8tkzf36LZxpJObxuXuJujH/LzHDsjXoDUDnLQSojRMNu5foJZ+QTn+nqr+TmC2PM7gbNCxHxP7I5tLnvk4zyNBeiG/e43Ufv9OaaJJhTs96C2UgWe2HWHSmnCX0n9h7PZVGocz2f9C7C05UVUcL8SxKOpmoQoyHSDLEClMFMFWMWt+IBJoD7OzUa2SchmxR9ld8PIU3K7wdy3/6ThEBMx4e5Xv/o69pdzHu6TcSZhbbhzr8QxyWalm0lNHYWLS+Z8V6QeI3sAa4O/QgVXZ3peXTLThYxUeANWd5nRFmpW7C7lCGIOJOjwZ99AOOr1RO9+F7144K8ZwVEjbSjbKTziXps7XEVBwLFixV5Ih5FIprEgOfRlusl/lIsQW+Cr1M7hqr2NMBY3UQ2+rmfPkD7+sAFCC7UtkXrIEQWjfzMLY61RbuzhB3EKfFbIi/OXIn3EH5CZ6XIbHLuF++ngZIDuj2Yup0K555OlKfzH+H7Xj0APYQDdR7ni38oq9/RCHb4sKeO9RLGUu/sTVrANR9DfYgGkVaQ7YlFLoi+RZLw/UHj6iY/YEfhpBXr3DcWTxpKfT8EjbRf+TJ+WtlKnYJx1tLazvO3mvTre0Oz7FfRaWJgx/7kg4vaAp/TpY1xxqRZfrWs3vKnNFv0SvGmSau5YgnJpPHERlAeofkWfsZSYwSa7XXBkDkJIMtKihJ2N7M1Wa7vqFshu2I9PGUnBMaGJFV+ez+0VctUVGwMgVOSxqdy/yA1hTP9j+QD54ZWr8qzSVv/FDrWbysjgHmkXtCfHDrfT6CYOVdz9ilhkGrSqfuqk+znuzq8OORMyRd3UEMFHWWUYyA54QU2Y6XeAn5z05Eyt2zAGmCb0T2pMV9kFyGtmU
 BFnw2CTh
 gGJHBSKWE5pAISKeeY2mrDZfqvGO51xx7mwjyoQ7HpeZcdsNs9hBzEOtsgiNQzkTO63dFco8uXGPjN5oUmhqkeMNbUN+EQGMv3yta4Ijn+jhqkwRVqsSEpk7PN+DYcC2lsgFE8ucftuu2mezZjAOhlprWQweXyDkR0X/lOKTFpJ784UOFzaXDbf+TQ6c6Q6/2xoCiDSuSOXHue81sv1iMVsZ4FoRGwnRyvkls/t0B+pC9NcVGFTKM+1/85tiI8MIVom1w2gforL1A/yLHJzAU/RyqMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I already commented on you failing to cc- anybody here (!)

I am guessing you did the core bits in response to David's request ([0]), but in
general - if you're changing core mm to suit an arch change, you really need to
send it as an RFC and then it'd make sense to send the core mm changes
separately as an RFC with an explanation as to why you need them.

[0]:https://lore.kernel.org/all/62c418bc-082b-4ae2-a889-f63dd2b7f503@kernel.org/

Thanks, Lorenzo

