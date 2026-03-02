Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5768CEA4E24
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCD2C6B0098; Mon,  2 Mar 2026 10:38:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5A936B0099; Mon,  2 Mar 2026 10:38:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4AF6B009B; Mon,  2 Mar 2026 10:38:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B43F6B0098
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:38:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62FCA1601FF
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:38:48 +0000 (UTC)
X-FDA: 84501530736.05.84DF8FA
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	by imf05.hostedemail.com (Postfix) with ESMTP id A46F9100018
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:38:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=bk19kqZA;
	spf=pass (imf05.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772465926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lkos/UwEVF+f0nD+l8Noi+Rcb16prIOjHEXIGFnI3Kw=;
	b=QDTqbN33GznDTbjPcxejzO5BYCsRCh8Qe3/Op6bfvLjEWg8/tWl2hCbPvTkkIn9pGkKLT/
	8IsDRb41D2lUqGxaY/HHgdVWU8/0C3p9IeaTwAabwcqGXZEQDhcVlKWFP4QvEr9NVkwThE
	Y8HU1NTExmdAA0CQ8PEvaWafM0CrOPs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772465926; a=rsa-sha256;
	cv=none;
	b=ozFHWBojFYuIgI+QKWVqCpsdf+sMm+b+W8ezN0VZC69YmCQWxchM32y4l4ZKHpRP3QFTcA
	+TTMvp97zJhP35pQJgYLY4eNt06kITAkZFNq64bdCBl2jayhfUXjqfay3fBqH2u22Qxr+9
	qVjYTcBLbTDdCCTll6oFk5nit5dj7LY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=bk19kqZA;
	spf=pass (imf05.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=lkos/UwEVF+f0nD+l8Noi+Rcb16prIOjHEXIGFnI3Kw=;
	t=1772465926; x=1773675526; b=bk19kqZAbr5o4/opp/mBF/FZ6PDOEGqipW5JazUz2mO5dAQ
	wyHAhiczgLXT9xRkzBOlk94MpweKPnwhf2CoflZ4awrABHc3JoxQg6vA4G59HrVBcsU2lkixyw0ot
	N2tQQp9S6uEQQU2uLCYUuxGmiRxC7mkq1/K2a4ASPyQCtMH5OihQlj7RGzPDG7QrEkAsP1Qfsutd6
	yyF/O2BP84DZviGFlSe3cH+GG5c2+pOXcPMNB4/m8LcM2FDlermuanceGBDmXCNaB51dSMFmKB7ZN
	nA82E49luDFOXr1HNlxlnH/g0uISb+rD9wUTRoE+ZPDScJeZe1vIQ4QdGU2+SrDQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vx5M3-00000006DCo-0pRn;
	Mon, 02 Mar 2026 16:38:43 +0100
Message-ID: <bed9cc03d3c214b2601093f91e4b00f3715762b2.camel@sipsolutions.net>
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is
 active.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>, linux-wireless
	 <linux-wireless@vger.kernel.org>
Cc: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>, 
	linux-mm@kvack.org, Tejun Heo <tj@kernel.org>
Date: Mon, 02 Mar 2026 16:38:42 +0100
In-Reply-To: <0de6c8d1-d2fa-44ac-8025-cfcfecd87b02@candelatech.com>
References: <fa4e82ee-eb14-3930-c76c-f3bd59c5f258@candelatech.com>
	 <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com>
	 <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com>
	 <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net>
	 <0de6c8d1-d2fa-44ac-8025-cfcfecd87b02@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Stat-Signature: pougfdr87be9b498iz1sj6aobyxebk8c
X-Rspam-User: 
X-Rspamd-Queue-Id: A46F9100018
X-Rspamd-Server: rspam12
X-HE-Tag: 1772465926-779771
X-HE-Meta: U2FsdGVkX185wFulh0AO2/eevp7r6htgI0nktZIaCq+Jd+U4xF0wAJaGP5eaZk7gMMZ8zMoVmIc+p0aKBFLozMFoJG3V3vbRk9MYgwpDIyXerI+fX0tN3ElAXHdI2+tHZpJ3WcyKYwx8+U5rkKIUV/eOhr4ob/JDgkd0eTq9a/M4JoNsiAVzfZZhsU0OmSWKPBxS7yJeXPGSC8eJ96+1eUtKbdPibn/qd1KlzAM9xGQHKxLS0ku4GYovvSsw1j3dfW6zl9lPlHPOPd/FrWg9YtDDEwWYdto5RDoD1WB4XnTEIkHFOQrTfYCxMh9YQMC4VbAtvRu380Pl/JWFwOT97eYdDFgHGIrjTutxQZPYtew/IfAz/trOgHeoLub/THf1wao7zCrDtqsQGhEsPvm/zxv/j9hv3ZAW7QFfuV2BXEPJL0OpU4izkzlsoy1/9o4ojEU5o3Sxwb0SoJhppZ61N10nXY/ACgIKWJf4GWIA3LqYfRkwZdTgUvmn8OLx2EdMo1FSQ5Vt4BCE/07a1YfyzSfkaZf3OyuEIfNcCI0VD9WMUjPKx7bofwCm8dfwYKA8S9ldmSiRS3xwH6LpMwN/KFLl3Q6BRSodiH/fAUhPccvbNAHqBUmkQQoYfeCOoxk6j0EFCe1Db03YEtBNzJdOly9T12uw/z2+AdZiRHkLW8LK+1rUZEjve1fgPbPIHqMmOp7mQ0A692ki/Cd5xQ4R3UfGf0K39xhlWoGglrPLRynFaqzuB8abMlzlee7/QoCFR40/bdp+8Xc0yUJo2EcTHjMoSJZjC0+nZb/cSlA6fmaZ/NAqTr9lvCMwdKtgR6Gb640anV6POh8u4UlUv16f8molyiYKjH30jNcgO0aMSqTfoMmYufMNJV+/U1ac4eeaj14Cw+pNtEtswiWj7jYVbRnhMTd/J/PYeGu46NhGWmv4NQXrPMmaylVwynWQV/e5soAHngnHjbL1vg8tw/w
 zG+vrNiK
 sXZ5VVmhxCNxm1jl4N8gwK7+lqRr2LJWjZnrXPCVihbiT+d99I1NHs+zQGQeU3kw3/+RO4qb32FPuNPjB09kAwSxl5fQTb9VSfPob+6iML+/4JWLXr79e64cCGSgzmHGUE7Til2nlbz8DlqmM+dAxwvKZFQUXRJtel6s2qSyVfqSwlz4P89y4s9Ej9o8CFR9du8LaUiaalIpRargHl8rNWgVgNrUKmtxvZBP7qHO7UBGoxkKgrHEUOZ99anSXyCtXlQgFWg1L1E+1hFwSEg8AAsy2aL6WnMgBFGwo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-03-02 at 07:26 -0800, Ben Greear wrote:
>=20
> >=20
> > Was this with lockdep? If so, it complain about anything?
> >=20
> > I'm having a hard time seeing why it would deadlock at all when wifi
> > uses  schedule_work() and therefore the system_percpu_wq, and
> > __lru_add_drain_all() flushes lru_add_drain_work on mm_percpu_wq, and
> > lru_add_and_bh_lrus_drain() doesn't really _seem_ to do anything relate=
d
> > to RTNL etc.?
> >=20
> > I think we need a real explanation here rather than "if I randomly
> > change this, it no longer appears".
>=20
> The path where iwlwifi acquires CMA holds rtnl and/or wiphy locks before
> allocating CMA memory, as expected.
>=20
> And the CMA allocation path attempts to flush the work queues in
> at least some cases.
>=20
> If there is a work item queued that is trying to grab rtnl and/or wiphy l=
ock
> when CMA attempts to flush, then the flush work cannot complete, so it de=
adlocks.
>=20
> Lockdep doesn't warn about this.

It really should, in cases where it can actually happen, I wrote the
code myself for that... Though things have changed since, and the checks
were lost at least once (and re-added), so I suppose it's possible that
they were lost _again_, but the flushing system is far more flexible now
and it's not flushing the same workqueue anyway, so it shouldn't happen.

I stand by what I said before, need to show more precisely what depends
on what, and I'm not going to accept a random kthread into this.

johannes

