Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1492FCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 02:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CEA96B01F9; Sun, 31 May 2026 22:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5B86B01FA; Sun, 31 May 2026 22:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3276B01FB; Sun, 31 May 2026 22:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BC736B01F9
	for <linux-mm@kvack.org>; Sun, 31 May 2026 22:39:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB0C21A04D3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:39:03 +0000 (UTC)
X-FDA: 84829786566.19.70BFD81
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1F657100009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:39:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TDDX08vn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780281542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMfLFxpky3lTG4VESTITwc7VxCTjEnXZROlAXcq5Ry8=;
	b=0iS+XyslwLPO1whRtXKLrjloAWx19y+FIznEFIpFlwQZ/LYnMraO3/hDp8eZVwew/qP47Y
	XYqlelMPewGyd0g+yLtso6fmA44sl6Kfp6OREtq9tYrhkkIUtE3WN5N7Q16gvp0M6Yq4qa
	i6UuZQgd9g8nBZ064pEGy8yEPtvo7NY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TDDX08vn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780281542; a=rsa-sha256;
	cv=none;
	b=1vDS6Y/58vGLzyDOAqTO1OiQ0oKLML4ksvmaJjtuI6wOScv1NPtsbL1vpjFZqIq0bILW5D
	V0eYAqtgOfW+25e4agfGdmGCYxQCmMHwhx3iVMghcWJtXAeKFiHiCIhQVFEiAfZxXpj3pg
	0s1qxUNJ7S9FlMvrlAg3rr8O8rh0j5U=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780281540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wMfLFxpky3lTG4VESTITwc7VxCTjEnXZROlAXcq5Ry8=;
	b=TDDX08vnWpAHdaPWUgxv4HK+ImGI1p1k1QKOb38Vudzh3N3QUM5v/eX5xFmmhtIefELXju
	4UZ7Wl5j/ebLQd7Gin6uOtLZ4fDy2pa/u+IMWqvr9PRgOHn7YoCZTPC+H+lL2KVr98cOx3
	LF3RH+R9aTXdXh5/jHt3YmodWU+F+W4=
Date: Mon, 01 Jun 2026 02:38:58 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <3353788b10ec296dcb549abfeaf29fe845574dc8@linux.dev>
TLS-Required: No
Subject: Re: [PATCH 0/5] selftests/damon: misc fixes for test bugs
To: "SeongJae Park" <sj@kernel.org>
Cc: "SeongJae Park" <sj@kernel.org>, shuah@kernel.org, damon@lists.linux.dev,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, "Kunwu Chan" <kunwu.chan@gmail.com>
In-Reply-To: <20260531170807.99856-1-sj@kernel.org>
References: <20260531170807.99856-1-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: agywtzfq315bdqwdndghoj3qau67nywr
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1F657100009
X-Rspam-User: 
X-HE-Tag: 1780281541-849224
X-HE-Meta: U2FsdGVkX189/+4haUmgzsTalQrW+Hws88n0i/lWPdP9xQOX7hiDKHP4hnUbfcY7Kp7eZEtQtV6/fp9dhOi3mWh8mEkF0h4TJ61+mzZcZlnNs5pkcbhn0WCc2DMtLPb/5pPJelsv+zD8Y5VXrpewAO2C4TOIFJfJsIwM2tmmi6SM5xYwV96ojc+c9QxMzkiNPD2DCY75+GiGk9a0AHEQgIEgB3qnZzI6+U8S7lro3N6rmE2MNw/Csbxg961d7D9ltnrEm5rFHgEIvWGrUPl2C+EPa85Os7TRMjYKWLzPMhnPQcC+3K1J9jG7yIKISkKoaCOfPmI3/etJnzm//bFkp1PkeG3/CWbIAIdY69xuI1A+uWXRQHbnVZdbSbPwp6zbk99go2NvjJJrWciaUE+70WQLD+anfr+0TtRYvkBlKLJyR8NN2DZ9d8wQCiIajFL5bVPBbp50PEYtRiI1N+mQe+wPVzvEs+hae3s7vYS5aqXj4PTwu/DrO1DUKYPev/qXPIRU9XzBC3bHuAnoUbW+iKgu28fOVirI6nMfRwFcOFyQ+Ns1ru1KbJeJxnbTKpEV77AUx1v5K0skA0oTwuDgWBtAs6a2HRdgWVUq4Wvc+LnQIvCed4vAoKqQuVzS8/fCUyzr4/9EzBh45AdRXIhxuzF6vxXrmDSIcSSQTs70gLjZdi/IJAt7ctDtoY9uDY49a86SFpF4xcPDF91tLON5BElKVMVOcMPnisOL258zZMvJ3rylVplBjgGqM5trEINfmlJLumjvWKCRQC809v3ta8LCdOBmyvUbgiEIObkalJj20SoS9KaYuHF8L9BzTPLmnP/miPP92QkiXR61WvzjAzLsFQIeG4ii0TpsK0LWCaOkwz3qfZFMADk+Lnc0UPkGvJLXdSBd/S2a0fie+FGoH2X2k5fQ1TO6Pqe3qjVHB/llR/daYw7ULnIbvGoKgEzLXG9pPtxNtRqqlh88KDV
 Uw7l2IlS
 PJMAMRxuoC0RbrpB6Epx12FE1u/JCyHUly3Lqvdz80fiuqv4prxpmEkfYdpdCmj1qgHOBDdbxT5YQyzAf8DqycI0WbdZ8ZIDy+FT1m2FjjXnd3xi6o1TAJLrXDrxBr1lDwdJAIZIzFbJYpmLLBU1zmrCpIFx0H5SIZhZDZH2EDii+UPsJbmRu5OjF7A1VNVjNaDT4oEc490DgKSxdM0BcxPdftKqTCMcyNzVga7JJ0Cf6XghK1dp2YlcgmbUIjlFANjMlkCPF6+kd+tqDAAt9P+2kCAouUpcSrP5Xl91sG+JeJgm/KMRmBJfADaXBDP3kpnF8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

June 1, 2026 at 1:08 AM, "SeongJae Park" <sj@kernel.org mailto:sj@kernel.=
org?to=3D%22SeongJae%20Park%22%20%3Csj%40kernel.org%3E > wrote:


>=20
>=20On Sun, 31 May 2026 16:56:28 +0800 Kunwu Chan <kunwu.chan@linux.dev> =
wrote:
>=20
>=20>=20
>=20> From: Kunwu Chan <kunwu.chan@gmail.com>
> >=20=20
>=20>  This series fixes several bugs in the DAMON selftests. Most are
> >  trivial but cause tests to silently pass when they shouldn't, or
> >  fail prematurely on slow machines.
> >=20
>=20Thank you for sharing these great changes, Kunwu and Lian!
>=20
>=20>=20
>=20> Patch 1 fixes mutable default arguments in DamonCtx.__init__()
> >  that cause state to leak between test instances.
> >=20=20
>=20>  Patch 2 fixes a trailing comma in DamosFilter that turns
> >  memcg_path from a string into a tuple, silently breaking memcg
> >  filter setup.
> >=20=20
>=20>  Patch 3-4 fix bugs in damos_tried_regions.py: wrong operator
> >  precedence drops the "not met" prefix from failure output, and
> >  empty early aggregation cycles cause premature test failure.
> >=20=20
>=20>  Patch 5 fixes several wrong strings that produce dead elif
> >  branches, skipped file existence checks, and broken dict key
> >  lookups.
> >=20
>=20I left comments to each patch. To summarize,
>=20
>=20Patches 1, 3 and 5 look good except signer/author info mismatch.
>=20
>=20For patches 2 and 4, I think we need more discussions.
>=20
Thanks,=20SJ.

Noted. I'll fix the signer/author mismatch in v2. As discussed in the
individual replies, I'll drop patches 2 and 4 for now and revisit 4
once the underlying issues are better understood.

Thanks,
Kunwu

> Thanks,
> SJ
>=20
>=20[...]
>

