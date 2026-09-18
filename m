Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA68DC982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3C806B0092; Fri, 18 Sep 2026 06:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14646B0093; Fri, 18 Sep 2026 06:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D514F6B0095; Fri, 18 Sep 2026 06:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B07706B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:34:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C6A61405EC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:34:17 +0000 (UTC)
X-FDA: 85226523354.29.D59AAEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 759E2180005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:34:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UQiwVwcr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UQiwVwcr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789727655;
	b=Dnf9OLRgzAr/EyBysLYRBrRmpqvSPq0aVQIqNxx5x9459YatOtcLZmI6GK1sVV7+lbG3Qa
	yXacLxCEjDcXynChdEI8lNy7ZPYh7NxKZD+y3AdaqXJMmDUZ1Im2qUmwtFzM01QHx0tSOB
	XqD57QaQYPWlZoD8dPmzA4bC9GP+0Mg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789727655;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=71jFtym32R/pNn5C3yPgZDDzaq5qZS8JIIHmgqqBkfY=;
	b=3NyZrjAoOzvSSPsgxa7iFTMYaU54C2h9sluU5me3SuHN1ZL6qC/z6Q3H6UQGiwSID2gGXC
	mawuC5e6E/Fa62X2fJsOK0GwHtmKazcx9IY+SpnWsvgXwDfcgjbVfEPL4jLD865jGxO7wB
	I5s8JfMqSfBO49A2w+y1ZKXE/9lcJlI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1DB840524;
	Fri, 18 Sep 2026 10:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8601F000FF;
	Fri, 18 Sep 2026 10:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789727654;
	bh=71jFtym32R/pNn5C3yPgZDDzaq5qZS8JIIHmgqqBkfY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UQiwVwcrQYLLOMOj+NzO2JrLYChumnio/fc/mR5O1sf+FXz56jqfp8xu3Zrn/AQ+s
	 UPQyFX9daLLzA6NyhjGsoN+Am67E0Plu3Mfyd5MMPIetvbNA9eZOvvUVUwHG4KkIpd
	 Hm/jAvYbKzwaavhWLnLyf8e6cQcV9SfiClrlMIomraUmmkXu7tWNmkMAxTVqQ1kGvu
	 3PA8y2MCJUX2uWkWgRxGYr4d1uKTFqRc5E5X8XQb4BwZPPMAW4GtRKnetdW/5jxo5v
	 HIf7SrFWALwipQXYaKiwGiTgnED/7M//LvvFLI5CfiI/ADJfkSN8KaNbw2mngKa4Vn
	 EsC+2NfERzkuw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 12/17] crash: Fix TOCTOU race in crash memory range
 collection
Reply-To: sashiko-reviews@lists.linux.dev
To: vishal.l.verma@intel.com, linux-fsdevel@vger.kernel.org, jbouron@amazon.com, linux-mm@kvack.org, sshegde@linux.ibm.com, bp@alien8.de, maqianga@uniontech.com, mpe@ellerman.id.au, kas@kernel.org, gregkh@linuxfoundation.org, chao.gao@intel.com, mingo@redhat.com, kernel@xen0n.name, "Jinjie
 Ruan" <ruanjinjie@huawei.com>, chenhuacai@kernel.org, seanjc@google.com, ritesh.list@gmail.com, pratyush@kernel.org, tglx@kernel.org, pasha.tatashin@soleen.com, yeoreum.yun@arm.com, gshan@redhat.com, chleroy@kernel.org, liukexin@kylinos.cn, thuth@redhat.com, eric.devolder@oracle.com, linux-kernel@vger.kernel.org, kees@kernel.org, dakr@kernel.org, mark.rutland@arm.com, x86@kernel.org, leitao@debian.org, blum@kernel.org, catalin.marinas@arm.com, zhangtianyang@loongson.cn, me@linux.beauty, mclapinski@google.com, palmer@rivosinc.com, loongarch@lists.linux.dev, ruanjinjie@huawei.com, rafael@kernel.org, will@kernel.org, npiggin@gmail.com, dave.hansen@linux.intel.com, rppt@kernel.org, hpa@zytor.com, james.morse@arm.com, tangyouling@kylinos.cn, linuxppc-dev@lists.ozlabs.org, takahiro.akashi@linaro.org, baoquan.he@linux.dev, lizhengyu3@huawei.com, maddy@linux.ibm.com, coxu@redhat.com, linux-arm-kernel@lists.infradead.org, guodongtai@kylinos.cn, hbathini@linux.ibm.com, ruirui.yang@lin
 ux.dev, 
 adityag@linux.ibm.com, graf@amazon.com, akpm@linux-foundation.org, sourabhjain@linux.ibm.com, driver-core@lists.linux.dev, piliu@redhat.com, ardb@kernel.org, robh@kernel.org, bgwin@google.com
Cc: kexec@lists.infradead.org
In-Reply-To: <20260918100442.3841135-13-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <20260918100442.3841135-13-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 10:34:10 +0000
Message-Id: <20260918103411.5E8601F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 759E2180005
X-Stat-Signature: jptaj9womx4u3hbmp4rmmpwyfh83xm9o
X-Rspamd-Server: rspam01
X-HE-Tag: 1789727655-163105
X-HE-Meta: U2FsdGVkX18Xr1vNJ2yLZsMVzzZc2qIecc88pKxyLw1wHhpF10QMfmzJ9qlwpFukVU5XmuvHvtPX+ZSgbtfB2P1sckI/amEHDSJ15e1yFWt7uDTpgzjO5HCDD7yN+P2JCkD1UoCf1pbD/t3OnzNM/fWDLQRzsW+eIH7zZoR2D4I+zHMG1iwslp9J64qKGMEIcQWtCCD8HCbqILAZ/HrftaEwHSNgHsAbeX0VKrWibV5/yEJ4wfZtDmFSoRPiQjYMI1enfC6sgSKdxkGg96Ieuq6MXRuqk65jYXkV2ihRuwx9COq8WhF5+oB7ljd/a1/bcbbBEX0j2oCDn/xMUeZpy8H7rTWQXralrzDg5o8GtCwhdl3/clNkyx2YYvv8lvveWNn+N2RlvDVx3HoUJa2LN7lNoTuBhem6sKd0A9zD4q4iiGrmkGpZuYypfH1gqY1ayYOGdDvl9c3zGoyRDWprXN60zmZQWxLZNdY0vrkqLTG0zrdCmXm7GwO114hQUXKDl2hUR7hihq+9rV5SPWJ7U38OHheipFfTeadJrkbeJGGtba5WtnLETfwQmUU0mZtNBNjzBGH3hNKBWdK1u1MKF4OXgBzMUYs1O5e4Q0R6TeRWezNwLg1rZam3U9AydhzRbvqlZRUBP4PGVfcxb319poB9b1lf73yDHwwkJ18NWZcJ51B9xBNQjB0ONRrpqyjaCEQDwGnqRcXpDqlcqH/6jtp5vVy14saEURBuCSzVJVPXM9Zognkd4xkh1ce7KoTVIkQdtiEYNKyKQnPG12ErR1jPa7IcQkM9xGz1FvkEZEIIfCBKOwsepurKnExgFcRtMxGZwLRXetzb0IfTBbz5KC/QHVF7QtB9iMeS82x5/KxC14KO9IMbzS5BV1F9Em+7wb8JGCAdU6ItIGsTtvQnyjNk5IQYhSH+HKcGI6lEDCOXzFCTX2oBxD9u4HV84I30V6CdJc1/q4JBOTCyRq/
 3A2A6jvB
 Ri+IX0KyHwko0zDhnYtEljM7rwVxtlnEVvRG7r6SoBEeboIqMr2DHQfI4tJJT0pxFHYKd4qym/hj7j9Tlq+KVNTjD/zXPxoI/lvK99RuA65RCAOuz7xy9Dmq6hLKT8u8c+tEvYCkg4P3vjYa8Ke50eTs2R911jqRoeaCn09oalQbsQcfA4InYsMFyixZTva95r+aGIe8Cp7iD5RKdbTBFWTzn0rYaHzLae0i/tsXw8psQb25O19WsJrdTOfz0g1dRAWXc+AEE/UraXpeqkKYaIn0qaMRy3U73FhltDwRlpDSr/+M/lJ2MDFU7bRvZDYVPVxzcPX7ojqdr2y2zRQPUySQXTiKsUUpRCP4wFMs5mcaMZFnJUv2JX1eNsZWTO81U9UhuNtvSBIQX3NOWjYTxvW43/S47x6rfEFthpWiNC3CaluheUFNp+Rz2GFmOkTHWsngec8yQy5vmEeyGsF2ffMkARhP7XZCR18MYEh82sBFV5sJ5Wgj9Kzzjl7GocW0rORSyHebs/IrdY2brIFBRIriRd9r2VoNHj41CdBISDl5rlOorKunFiBZHMYiKw3/I7VBjA9tXaLExUId1OTrK8iBpcZavQx/gVFT/Yak/srmxt0n/AFnVeJ5TLeawso6glS4o9OfK1jH/5tqBS53fDX7KSFIVGZ7f+pqL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The crash kernel ELF core header construction counts system memory
> ranges via `arch_get_system_nr_ranges()`, allocates the crash_mem
> buffer, and then populates it via `arch_crash_populate_cmem()`.
> This sequence has a time-of-check-to-time-of-use (TOCTOU) race with
> memory hotplug: a concurrent hotplug event between the count
> and populate steps can increase the number of ranges beyond the allocated
> capacity, causing an out-of-bounds write. If the event triggers
> memblock_double_array(), the memblock array can be freed and reallocated
> during iteration, leading to a use-after-free.
>=20
> Protect the entire range collection with device_hotplug_lock. Since
> the hotplug notification path already holds that lock, add a lockless
> helper, crash_get_memory_ranges_nolock(), for use there. The regular
> crash_get_memory_ranges() acquires the lock and calls the helper.
>=20
> [ ... ]
> Fixes: 3751e728cef2 ("arm64: kexec_file: add crash dump support")
> Fixes: 8acea455fafa ("RISC-V: Support for kexec_file on panic")
> Fixes: 1bcca8620a91 ("LoongArch: Add crash dump support for kexec_file")
> Link: https://sashiko.dev/#/patchset/20260729031235.2840255-1-ruanjinjie%=
40huawei.com
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918100442.3841=
135-1-ruanjinjie@huawei.com?part=3D12


