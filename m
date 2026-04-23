Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE07F589B0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA10C6B008C; Thu, 23 Apr 2026 08:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78476B0092; Thu, 23 Apr 2026 08:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB5506B0093; Thu, 23 Apr 2026 08:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD2E46B008C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:48:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5DA25C0506
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:48:12 +0000 (UTC)
X-FDA: 84689798424.30.BBC05E7
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 73B10140008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:48:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eCIMj6Zf;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776948490; a=rsa-sha256;
	cv=none;
	b=UWy1UMTyrC+yf0Wsmcox4MdZlNOD1YRbYtXqU7D5Ve/H2d/Q/ajmlCuZuGWWV4+BS1e5An
	vA5N+DVmA1OYgqaoCoBQRtOiylr75imFi2JnGLb8871teNaRRyDWeOuYYhurRumKeseZJA
	rm/JngWmKWSTP/uYFTt3aRMP8vWHHRw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eCIMj6Zf;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776948490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mzyqTkwD3Tq3eWJj43nY/4NCn6uElngPKF2N7BctSd4=;
	b=dvmSyU1Udy8Tj/xQpM5Wj+9kCNRYtGp/X/ft8xUPfqHgaWIRTm9adlvRBl+7CtfMgxQjra
	x1KD1QQFfO0UuNLFDb2lgfLeqMeeVM9o6dZqrF1amBpQwhFH54VppA5wbgdge19J2mOb87
	Fr0ZdX8SmtSmpd9lhSbbYn8J7EVY360=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776948488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mzyqTkwD3Tq3eWJj43nY/4NCn6uElngPKF2N7BctSd4=;
	b=eCIMj6ZffdfaEQ/eCdUmx55xZEnSNjMOWnXKRPikt4j4906Q1SttxKiVjKU8rlNbvJpCby
	erUQIBtSxfqPziAXNQuEfEecz4uegx50F+rqJgqHbsujB4xw/yqILQ/i2jg0Vq6Ad0Vpcj
	qd6Rxnai0Y+qvbwrtDxUe9CV+iyEcm4=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v5 v5 4/6] mm/sparse-vmemmap: Fix DAX vmemmap accounting
 with optimization
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260423053237.a44b68034673bb35a1e042cd@linux-foundation.org>
Date: Thu, 23 Apr 2026 20:43:02 +0800
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D642D89B-CC3C-46A0-B1D6-3DC2C4DDB874@linux.dev>
References: <20260423071911.1962859-1-songmuchun@bytedance.com>
 <20260423071911.1962859-5-songmuchun@bytedance.com>
 <1cbae635-a115-4270-bae2-64145d16f936@kernel.org>
 <1ADE7CE5-F02D-42B2-B7AC-FE0D6E86042D@linux.dev>
 <20260423053237.a44b68034673bb35a1e042cd@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 73B10140008
X-Stat-Signature: zdfsyqaggfqsrn9h5brkwidseyuhkk1d
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776948490-334425
X-HE-Meta: U2FsdGVkX1/YTZxb/ckoYOvYfYfvzYDzet8C2RYBn64VVTgzpfXRSlOuSeddFofH4l0O4Lv2phibmaiCE0KBB58ZldVAs9S7FxsI8AtrnB+rWPhhqPr67JMXphVkWtOPfli6IdNdDkFWvSs1Yr1oIHqTCwyh0Otu89zKoTr/7/0slk+MLnSiYH/VxswyaQZ7ZsvZzOQBIKzvq7Mhe9u0lL95B4TCRm1mb3XY0FTGz4QiCgwSVDxaWtwFIsqr0PYs0AekqYZuM+x3f5VB8taafIlNwE+8H7rkrrr185jzyLsnkwhJPmspwowM3A6EtEYvsUwj38rC8an+Wmns2aE/cegcAZZBKK7yolhelQHI69wxejENJS/nStRAJl9PDZ67ZnahWfGZTjCbE5tInS0b+bCmzxs3eBud0iTDnWzVFLbTymeN8LeNGXopybJSr6S5SH9bqU/mh2BxmNntgNIWLzRQgS9Ntbfkb+OJ/FCWxQOOJSAevqpQwj9Fn8rZBPNP+vAImff/ZLX9LjCg7OxDtNrrm9jvZv4w4Q43Lf7fvx8lf+rHAsX0XV7DO+AnTtt94BS2v/NuoIW9oWmuGAXBVbhPE4oya6QRSjLO2xNYUe14C9/5S5Q24uiNF4YETcQObE0NBCsy4Zeh/qeLqKH1yrkRiDdlEukZV10lhCOKz3roV1fNK0Ch0PPYQiKJCKSq0mrpLefwOECDeAcVfMLAvlBt27WHDCfOREzgC7kdKJ0nrGqM5MRSN7FDMOqNhOjCNTukjy4veXDcKTkRzeP5sTpHwpoH0fmvk2wsTUUL9rNq/IZk9OFnjhcyMbsk5/rAlb3kyFoDlg6u9q3Af1Somfjqm91ZZvo/eyk0UTkJaapmSTgi417OLOTD4SJjiHyPksX3311nmseGEC3609gP74AhiKyLOL+Ks212wTwhaM1+MotusSUPLpnE8eqLIHH4KeFNjezUdJ0JPyc0RRQ
 W+ZJ6329
 uY4xgQzHc5pvYs2SsHvmSnC76iEQEmPw6mMxIz2JjlMUeAcX3ngC/8/xYX/J+XeJpcrLe71lmmC/HsHTTm4yoClyQsQomH8bPu+i9H35xFhul6+iMfXetZBtLyjFQq2f+Kf4kYmjf1FF3b1bxA5UUKqFpawOvVmjG7kqivZ0PIqhTpKbdvohmQhmuS9EZxeGQlXpribdqgEFEkvOao5F8oMz7eKsXZLTlXMVuhiP5CCWu/tiThiAQo1fixEyxGv+e6w7YjdwmDLkyBZxONZG6N0Rh2ZQ4jDPiKk6zplfyNN7MkfU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 23, 2026, at 20:32, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Thu, 23 Apr 2026 20:04:21 +0800 Muchun Song <muchun.song@linux.dev> =
wrote:
>=20
>> Ah, looks like I need to update the patch to fix this.
>=20
> OK.  Please have a think about which patches we should backport into
> -stable.  Possibly all 6!  And the timing of this backport.

In theory, I think all of these require backporting, and each carries a =
certain
level of potential impact.

>=20
> Ideally, split the series up into one series for 7.1-rcX+stable, =
another
> series for 7.2.rc1.

Given that these issues have existed for a long time and the trigger
frequency is very low, I suggest we take a more conservative timing.

We can prioritize getting the series into 7.2-rc1 first. Once they have
'baked' in the mainline for a while without issues, we can then proceed
with the backport to -stable (7.1.x). This avoids rushing risky changes
into stable branches.

Thanks,
Muchun




