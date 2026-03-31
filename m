Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E5931061B21
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:38:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFA666B009E; Tue, 31 Mar 2026 06:38:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAAE36B009F; Tue, 31 Mar 2026 06:38:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7706B00A0; Tue, 31 Mar 2026 06:38:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BFD1D6B009E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:38:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63C39C2E31
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:38:19 +0000 (UTC)
X-FDA: 84606008718.14.37E037D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9A035100004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:38:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GDJCvsb5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774953497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFAhFVrzyQ++LLoiqk6KXIUWVbdtbfBzA2weOzg4xvg=;
	b=u6qZqvIP3pNMkeGgFXkMkt6sj2H80koyi4cdRfnqswDwIXo2huM6JW+PVSh11L1tcK3Bkp
	BezaHMPZXX83uuNOHXrnaRWG+XwetubBzMowtruYvP4IuR9JZva1fca3iruBxezF90mFzl
	Y9KBjtSE2LVBWDI6/MqgA0UJA+MvVVk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774953497; a=rsa-sha256;
	cv=none;
	b=gajhczQ0ytwDPSlcenbaAw8I1ydELb61+9NpYiZ2MHt0NXgSBA/3VUDU8gFrjLU9FvhnxR
	phmXVJbDNbXjVlgUG4t8DfS4H75Y6qNHXe64LS8cABQkcWZnTMaObOxpwzF53Y0WsxQ/TC
	GgfBXPZ/E6GmmJmLxwxVD6sLVKck/GY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GDJCvsb5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4705C41B51;
	Tue, 31 Mar 2026 10:38:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EDBC19423;
	Tue, 31 Mar 2026 10:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774953496;
	bh=NJqJwlXRBGRb+UTLLKfcHb2qxyqwNaawxNGCqJYZQwk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=GDJCvsb59yNSCzj2fnsZ7US1xTmRV/TBed8SYWPpTWVcGQ2xxUj1YnDNzXxzPG8Z4
	 JTeqhvVnUdcjyNaZieLaCr09B12zYUzam2xNWtM0ES//rovy0Vpl9gkb8HZW2HTK8K
	 lu6HPajYMyVyXqrK1w6VPI3zJqRUEYG4/ZWalaStA1p+urtYyduQw9g6B5+3s/HoQz
	 XFhs1I8d+VI485wDpL0OLs0BT5JAwH/+z4s5Fj5/mc59cMJgqf/xxf1cfhGJ7FiGSh
	 1Ep2q2dttFz5a5M//OABnAcPG7F42bZKySMdudqlI1SgmPg+wEsmUlbgcQO0CVoBJE
	 5bKJ8klCoxhmA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org,  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,  pratyush@kernel.org,
  skhawaja@google.com
Subject: Re: [PATCH v3 02/10] liveupdate: Synchronize lazy initialization of
 FLB private state
In-Reply-To: <20260327033335.696621-3-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 27 Mar 2026 03:33:26 +0000")
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
	<20260327033335.696621-3-pasha.tatashin@soleen.com>
Date: Tue, 31 Mar 2026 10:38:12 +0000
Message-ID: <2vxzecl0i8rv.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 9A035100004
X-Stat-Signature: r5zayr9n7jnduqda6mwmwf18zz6ci7a8
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774953497-440196
X-HE-Meta: U2FsdGVkX1+4M9n8uor9lV5y+SbljXRGOJonEVeZoExlxkcJUQ084cfizl1Poxqn6WHG8V7IXLB5U8rY1r8Czd9tUG1vCMVOkJWKQWaZLXph/1KHfzoMF2RyGOVpspf+onYCy4+ddGuUg9XzQXVK1Dh5EdkSTwQu8Gq61/1MWUj/qGnIVckAyfh0SWTA3tatamjseA5DpfKpq8Mv2wahKOgBKIlwH9CCtD9U4HW1M4zD6PK0pG60oRBLvhopqLcd4lYRbHvySSaplLYO6rcp9+FOynH33oP6dfal5UDpDATeF5Aqd1hzYpWMq+LriQrPcNW2EMhGikf9nrQeFO47FxLxW6BFb5UrZJiv1hehTnYECXDR6qoJtdvvlcCow4h6QwIuGdysGo1Aia3ecoND1mYcwfDTK7nNdS7FWR0kHsKqCWMrjHHpBPs6nUsQkgUrzYOqCAV7wvQEZha+gMLordHEVK/C9FidmY3J/kswZYs8r+TT3VfMDeV2MSLleMpam4epwiBdvRGyOdU59CXEjurRrfPGx90mdW9WtDMSKlAVE/8B4Be7ZMOI2dp3vGgWAbTiriICkJ6d8+Rpx5bZX/8JEm/IjlKV1/vl66EFPzxG+FVz1wqBZ5atCk8xrpycwhfH22NVdYe1Gt0+4yrZ4X1CQ/mUzZZrZ7qEwISb5QFopWUSnMJ1ie2yL7RZm2WVMdN1eeZn2DW8z/QBS3jRP985Puek2Yn3Az2iFf3ooDfMuRGZ2ye+Ab4TnUq4LsSYWjZOTMkscSCOFCf0A4G54+/lUd5kXPmHqcqeRDKCDJPojBI0PHPJ/icqT73kks+RFJ1DmayzIhAaVxCux+wl2XnJZ/WJBBlWh7UNhPOfAizt/nzb27cC6TvXG/ygjeNZ9M7WrrCKMVHeqPAb3f+LMcLvKqysMSRmGKtjaIP07brnhuaZeUMPfAQZt526AMd2b+3EcnSQkItvZg/w+RV
 8YHdvqaM
 VAW03OhxDAh0+r9gzrr+rtDxfjIq13VEjMionLV0gdngbwu+N3QRh36/5bfAJEKaNo1JYKt1jiIaCf/4LPRz5lNsBoUswyVGQuMzPolpKemSUNfmbzGr8RJ5alfPVvZFE4BSK7NRbNAy13px6ncYkBMD0VVTZPvX+/VfaAYL0MdltzXBzgQeC9DWJEXv4stit/RJVa8LH0QMtzZCdzDxO2V6M92eBmdxxzI3NkxsVN1AloPHkiqtaEYMFLxszIgScWx1m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27 2026, Pasha Tatashin wrote:

> The luo_flb_get_private() function, which is responsible for lazily
> initializing the private state of FLB objects, can be called
> concurrently from multiple threads. This creates a data
> race on the 'initialized' flag and can lead to multiple executions of
> mutex_init() and INIT_LIST_HEAD() on the same memory.
>
> Introduce a static spinlock (luo_flb_init_lock) local to the function
> to synchronize the initialization path. Use smp_load_acquire() and
> smp_store_release() for memory ordering between the fast path and the
> slow path.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

But... wouldn't it be a whole lot simpler if we introduce a
DEFINE_LUO_FLB() and get rid of luo_flb_get_private() entirely:

#define DEFINE_LUO_FLB(_name, _ops, _compatible)			\
	struct liveupdate_flb _name = {					\
		.ops = _ops,						\
		.compatible = _compatible,				\
		.private = {						\
			.list = LIST_HEAD_INIT(_name.private.list),	\
			.list = LIST_HEAD_INIT(_name.private.list),	\
			/ ...
		},							\
	}

I can't get sparse to work so not sure if I need some special syntax to
initialize stuff in .private, but I reckon we can get something working.

[...]

-- 
Regards,
Pratyush Yadav

