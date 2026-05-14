Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4BD3CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 02:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497716B008C; Wed, 13 May 2026 22:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 448B56B0092; Wed, 13 May 2026 22:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 385936B0093; Wed, 13 May 2026 22:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 289826B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 22:38:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DA7761C013D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:38:15 +0000 (UTC)
X-FDA: 84764466150.25.5CEC00C
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0FBA280002
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:38:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YJ8Tnuzx;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778726294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8mMFd2ZuPeB5whmvIjvKFCtK7Zo6oHHV9ZAT05XKL+g=;
	b=dw62kg37raiNwkj1hEbdFWiRlZ7EKHiHeV4s7Y680AP43y+Pfb/2bACUeCFDWJkPGNuOW8
	FJqZ815t2AaHpXcxlaoRvWww+1kz8P3kR+ty3NqSvelJ8Wc+QvVZxBjNeSli4MKB4jy0F3
	O3JAXbCR5ETjdniKBQP88P447sggshQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778726294; a=rsa-sha256;
	cv=none;
	b=kkX7GFdfDbICgwD5ajhfP7g9BHhfDSguC3LDZGqgub8EsyR2ECCAsOGU44sRmLTs+9xVm0
	onPtvU2l7KEA/V2oIJWnpKfR+n5piy9Qqf721oI2eHLfy6mpb0KqSWtvP7yEWFDETAjUCR
	poVBMU9gEQmdVYqdJgkQo07yHDKyInI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YJ8Tnuzx;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778726291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8mMFd2ZuPeB5whmvIjvKFCtK7Zo6oHHV9ZAT05XKL+g=;
	b=YJ8TnuzxHEEH6IGA816hfhYy2ZuUWTHbBFnfRTdtiCoL2PJPGBTdMLmLT8GaRMx02Xg+qZ
	te5f6Nmt3sPS6YWm2KBMMpFXE0NIapbu4pT7jl9Ixrk9Ly+k8DbJyT6zRyGENmh2GdbFc0
	MqH0D+Ve2tIwNA+2eTcykwWQdcbdS3c=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2 00/69] mm: Generalize HVO for HugeTLB and device DAX
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <agTCbglgY23ydrDx@localhost.localdomain>
Date: Thu, 14 May 2026 10:37:28 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>,
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
 Ackerley Tng <ackerleytng@google.com>,
 Frank van der Linden <fvdl@google.com>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <FF9B5F01-7EAB-4655-A6DB-E0594201DE72@linux.dev>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513104640.b0f02b844c57f92bc954878e@linux-foundation.org>
 <agTCbglgY23ydrDx@localhost.localdomain>
To: Oscar Salvador <osalvador@suse.de>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0FBA280002
X-Stat-Signature: q6usf8orw7fw9x43honoorwspup6pfhf
X-Rspam-User: 
X-HE-Tag: 1778726293-945438
X-HE-Meta: U2FsdGVkX19j+mc/9XCxo8fwW+H5N6X9m/mYuPq+smh/2mqkVE+SfGjQxF8OzLon7gtD2HMRMtvgbXxz7uxzzQ0YnoynXB0cfeHO5CEgq/UgG5BbzR/Nd/Kl89SW3BLXStcBnQejt1HASmjzpVua4qiVZWMa5JUHJC5VP5C61MEMUBd5fP026ib33iiXGGOxLqNmVPNuvH1tEP46sCcBBYpvmhi4k7hhxm/EQueBth9OVQxDDVv8jE/Jny6+4O2PcAYEuZ5evaoGqCx+bIg7XB1qThunW+5/BUTm8ZdOt5I+iAqBlPaD3lQKOIQ2HAUZK7VOdYKYizL00uMYRMfTB7ARjuyep0tP+t4hW9AzB1kmIDgQC9qM+IHVQoKiDXqm1u912xREXWTMj9LoXf9P2fXVkW78PyVFxG4L+TqccH/9pAQTzhMeySlsbeOahLuwY46USRBp00vb6vbQzIrsh79+ldjAxyS9P4zhsLls1ppg+toh3uFbeEW8X3d0VB59PVux3+LbmTul5mlaIFMHdlNhV2ma3hxa1qhi6ximOi7aXWlu5fbRwMP28/jR7RXzo/RUicBj0HY34GwpZPmRzEK4Ehm4rvowQL++Lz5vc3LT4qcNS5+4v8/LogdxBuaOLa+ohc+o1CvshLP4mRI7/Uk0mrz89oNMc3aEM0xW/5R3Fslp8tM7OBckZ2o4pXgVVmBqaBqDF6JGhpN3O6AHrUAXFLlCocOlTZwMBtGbuJhYJiRkC4wNgmxO20HfVnsxawf/MySmDLd52P1iWWJM+rwz512O+9ullDUPwkrVZFMNGHVP4oOdmGfv5vVFkAOPp6QELG7OPux2twRb53Heq0dMigV672rmikHadhXN9zBBG4rPw41aRyDI+Ue0C62ihwiUiDGozTORsUtoSGXzXIU3hvmarRqKPjkc/2hLN67/tCx0sAk0yPaaTZvM+8q4K5AAvz1NxhVo9FwCZ1q
 r0ub6ve1
 CSIE1UvMaJZTSW0/86KswdwI0RMxVonjhp2BZzrOw1uGDL28+uHkz2AVr95M4dawAsK0VngfjUjyaNNVMEm5G7c/INr31I6kh2uR59nat4Ac1fUTHgL18YELAZ003zx1652XEb9dXpxk5xx+UILrogxIdGiDiJ2Oem4elQwlEpJM5ZMJk/RKsUslW33P0JHNpznhQy7GDzjLbTycf6mnOPVKRYqsankcGF/siQlPnQVydEJk+kB/GvU8FXOm+DljbiWrv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 14, 2026, at 02:26, Oscar Salvador <osalvador@suse.de> wrote:
>=20
> On Wed, May 13, 2026 at 10:46:40AM -0700, Andrew Morton wrote:
>> On Wed, 13 May 2026 21:04:28 +0800 Muchun Song =
<songmuchun@bytedance.com> wrote:
>>=20
>>> In this series, HVO is redefined as Hugepage Vmemmap Optimization: a
>>> general vmemmap optimization model for large hugepage-backed =
mappings,
>>> rather than a HugeTLB-only implementation detail.
>>>=20
>>> The existing code grew around the original HugeTLB-specific HVO =
path,
>>> while device DAX developed similar but separate vmemmap optimization
>>> handling. As a result, the current implementation carries duplicated
>>> logic, boot-time special cases, and subsystem-specific interfaces =
around
>>> what is fundamentally the same sparse-vmemmap optimization.
>>>=20
>>> This series generalizes that optimization into a common framework =
used
>>> by both HugeTLB and device DAX.
>>>=20
>>> The first few patches include some minor bug fixes found during =
AI-aided
>>> review of the current code. These fixes are not the main goal of the
>>> series, but the later refactoring and unification work depends on =
them,
>>> so they are included here as preparatory changes.
>>>=20
>>> The series then reworks the relevant early boot and sparse
>>> initialization paths, introduces a generic section-based =
sparse-vmemmap
>>> optimization infrastructure, switches HugeTLB and device DAX over to =
the
>>> shared implementation, and removes the old special-case code.
>>>=20
>>> ...
>>>=20
>>> 46 files changed, 743 insertions(+), 1812 deletions(-)
>>=20
>> Gulp.
>>=20
>> I think the first 15ish patches (little fixes and cleanups and
>> refactorings) are ready to go in immediately?
>=20
> I plan to have a (partial ) look at this tomorrow/Friday, but =
splitting

Thanks.

> this series in fixes-that-can-go-straight-away and the feature itself =
would make more
> sense and help ease the review.

Yes.

> Head tends to spin a bit when the patchset grows beyond certain number =
of patches :-D.
>=20
> Would that be possible Munchun?

I'd prefer to group the first 19 patches into a single series (titled
"Refactor bootmem gigantic hugepage allocation"). Therefore, waiting
for your review. :)

Once patches 13-19 pass review, I will send them out as a standalone
series.

Muchun,
Thanks.

>=20
>=20
>=20
> --=20
> Oscar Salvador
> SUSE Labs



