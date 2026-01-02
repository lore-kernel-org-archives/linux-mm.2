Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81CC7FA374B
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 14:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A07E36B0088; Fri,  2 Jan 2026 09:24:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B5E16B0089; Fri,  2 Jan 2026 09:24:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7AA6B008A; Fri,  2 Jan 2026 09:24:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77B696B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 09:24:27 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 25F8C1A8A53
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 14:24:27 +0000 (UTC)
X-FDA: 84287244174.13.23DCA46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 808B240002
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 14:24:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L0we59nD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767363865; a=rsa-sha256;
	cv=none;
	b=WyLSnFSQ/0+JEKZ+OC9nRPqOZXO75MMaz9PctpPwtdniZ/pKwWwuWE/3JKAcA1v+bNMuXh
	nBB6CIEPS4U0dAf1foOGKfpA+c6ZiXpyrQ6BqN6WR7ThbLPjpPgv9EcZGaX/V4t5+jt4ys
	29pzwpDH9fZonai1D21G7mR8wFO3bhM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L0we59nD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767363865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fAtafWg1sFBzBjGB7d+SGUoSzDz5D9BUwo+weGX2YLg=;
	b=sEsaJiDzMm0UFY7HD9dmvftWUDjGWVZYI5CzsRIpTxDAK39DkLP9sLO/Mjb8KM/nSju6nU
	QSKPXf4q+DmYcTyly+M4lDl7LBt2y92k1QAK68PYAIqJRpZJXaIVrq2ngFxBOsyc4MPHP3
	mTRo1wPvZskxxVPcfsTS4jeNH6cUWeA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8073E60017;
	Fri,  2 Jan 2026 14:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42226C116B1;
	Fri,  2 Jan 2026 14:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767363864;
	bh=fAtafWg1sFBzBjGB7d+SGUoSzDz5D9BUwo+weGX2YLg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=L0we59nDG+Q3GO+jsNtxGY9fMPViX52grgVcLoYYogLiRu0tpcWBslFf5vCdovms0
	 jAZGfkNETBQOZJyw03RwzQyCxjmF8CGIzfhFKihnFxTSondniZaSRsC6aNtytG2pJ9
	 laaVkcVXzn9NczWdabf8Rk3cUuuKSPVQmn8DVlvBbHXT3ee944ykDzxaOkHpbMPzFg
	 24mwMcVKhvB5rCloyErmB8LjDtfa8jvARawIIlSwcy1AHh5JXL+NiGEDrHi1PdVf1k
	 19DmldnbzoIsY/IYkz5W4aGv8oRimtMl33ZnaW4baB3T96NBSCJz69fNwuQSfj4TTW
	 BN/2JbRLlBlFw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  Evangelos Petrongonas <epetron@amazon.de>,
  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  nh-open-source@amazon.com
Subject: Re: [PATCH] kho: add support for deferred struct page init
In-Reply-To: <aVTw_08W7zXR7Y0F@kernel.org> (Mike Rapoport's message of "Wed,
	31 Dec 2025 11:46:39 +0200")
References: <86jyyecyzh.fsf@kernel.org>
	<CA+CK2bDxnTEe9Ohq5zLuyF-jqgD0DPhfdq6z=yztUsXU5p5fSQ@mail.gmail.com>
	<863452cwns.fsf@kernel.org>
	<CA+CK2bCjJWZG_rPoPsHWSxirmUCTOuFQzTCss2AKf9UqpThrdw@mail.gmail.com>
	<864ip99f1a.fsf@kernel.org>
	<CA+CK2bDDEZ5a+LJNDVMtKFtQ1D9rP6rJqU064eoru=a9eHpaAQ@mail.gmail.com>
	<aVP6wBYoHJQsplIl@kernel.org>
	<CA+CK2bDZPwYpUhksDLSbfVdVm5TYbh0XrOKRV=q4YjGpqH+Fwg@mail.gmail.com>
	<aVQJUPOn85WlJaM9@kernel.org>
	<CA+CK2bCm=AGDSLTbs6etbqveFUHU80okE-bCT2zg20nrHXgHRQ@mail.gmail.com>
	<aVTw_08W7zXR7Y0F@kernel.org>
Date: Fri, 02 Jan 2026 15:24:18 +0100
Message-ID: <86wm206qjx.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 808B240002
X-Rspamd-Server: rspam10
X-Stat-Signature: th343fqdd7sw5bnqirrnau9mkyp3uj7m
X-HE-Tag: 1767363865-285651
X-HE-Meta: U2FsdGVkX1/J/3xB6wo3hr+1jPqBieqKxt+One819OTC2Cr3Ka1gUBw7rnCNWhCKyRIt5vMA/JkrcpzaAKWZy+hCnQeVYa1bgcMhiVoO7X2mVCCsTviSzjQkA0gDD7rWjHzkRNPdai0nB3vtx9y7aWkc9l6TP+tUmxG/dgGzl/RZtYZWdzliPbZ4ans/ALXlNkegUGy88ld9EN8g4lVUCQO7jrt7ENAeMBo9J5y3hJpMIgIouB6/FE1iSJemQSBhwXmXFiaOv8x4TJwXjHRSQ/qeKYyovi6wfUCybqqfDSXiEqKJbIOBY65dCGEJi3iBsJ1RBQC6sbgECQvW7xnYuwS8kea3J/IMHa3tkMPpXhsGAXCoGicuyIGIovrLmYFs/lz1xCJadOgKYuDgp+DjIamZjw9Idc9IRnPWOmzPilUYcx7b5M1YZakqdYX+kCwYjWvSofWz1Ry6JMdodk8gLWrdcKWgomclJoncOerI1puJEAsC4LHOT9YzzLBCOS0kjaP6D4C+BkbnU4MniI/x4eFlVmv7C2+xArf8lkhIjW2tkzVcm0gN62wZSKBQn/HnbKU4027/1/Ef4p4jzc/en2m0xEkjMEHjMh9TyznbEF2V1d5woYxVhRDChdUnqiYNqVORtSeW1FLq+8n0hi5+aKxOh9Fktv34sNXb/FzcH45iSwHvezgz8xhIV7+2nGtUBqRzr6bTOgHrqu934lCxb3sMHOL0Mb+VE5xBX0GHHr8bOmd2Sw4kJQHOBfOa5/3nvCfTv0LD29cTG17A9KNQBvXEHqDP7ms6A6W2eNo3NPBM/Eam7M0gOGdUVci5cbj5X+Be9sssPLK9Dd9t6ZaRs74OKzFidJ62nxA0PVjoGzvEfQfwNSGTBMdvZxEMd2NPHXYzn+ak/MZfKXui4zQyD22vBo3TOzBJBOsAH3NekKGg9AO8lLrZRYWkUDcB/aQS4LMtUBsEXrnTpxnpaTQ
 hPj8nGzT
 vsm7OvWMnhcC3xwHk241rdKy4PfF/2Z0nmQfRmbyauM78+IoXWEQarSKhi4tvQ5CkIjnAeQRfn1MROcI7mwIsoKx4E85TgLX1v+iqaGhhde933oFbY5X2zGngkrIB1iz1iWLNcMjdjP+xYlIwFCJ5bxrhXOiT3CtTrMEt66b68pjdp+fZrryV6AY4fYvrXulFGmX09X2ouS6vKoWlh552z8OV3PbUl2jKkvufZYd+50xBO7aZvNdaGNNnmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 31 2025, Mike Rapoport wrote:

> On Tue, Dec 30, 2025 at 01:21:31PM -0500, Pasha Tatashin wrote:
>> On Tue, Dec 30, 2025 at 12:18=E2=80=AFPM Mike Rapoport <rppt@kernel.org>=
 wrote:
>> >
>> > On Tue, Dec 30, 2025 at 11:18:12AM -0500, Pasha Tatashin wrote:
>> > > On Tue, Dec 30, 2025 at 11:16=E2=80=AFAM Mike Rapoport <rppt@kernel.=
org> wrote:
>> > > >
>> > > > On Tue, Dec 30, 2025 at 11:05:05AM -0500, Pasha Tatashin wrote:
>> > > > > On Mon, Dec 29, 2025 at 4:03=E2=80=AFPM Pratyush Yadav <pratyush=
@kernel.org> wrote:
>> > > > > >
>> > > > > > The magic is purely sanity checking. It is not used to decide =
anything
>> > > > > > other than to make sure this is actually a KHO page. I don't i=
ntend to
>> > > > > > change that. My point is, if we make sure the KHO pages are pr=
operly
>> > > > > > initialized during MM init, then restoring can actually be a v=
ery cheap
>> > > > > > operation, where you only do the sanity checking. You can even=
 put the
>> > > > > > magic check behind CONFIG_KEXEC_HANDOVER_DEBUG if you want, bu=
t I think
>> > > > > > it is useful enough to keep in production systems too.
>> > > > >
>> > > > > It is part of a critical hotpath during blackout, should really =
be
>> > > > > behind CONFIG_KEXEC_HANDOVER_DEBUG
>> > > >
>> > > > Do you have the numbers? ;-)
>> > >
>> > > The fastest reboot we can achieve is ~0.4s on ARM
>> >
>> > I meant the difference between assigning info.magic and skipping it.
>>=20
>> It is proportional to the amount of preserved memory. Extra assignment
>> for each page. In our fleet we have observed IOMMU page tables to be
>> 20G in size. So, let's just assume it is 20G. That is: 20 * 1024^3 /

The magic check is done for each preservation, not for each page. So if
the 20G of preserved memory is 1G huge pages, then you only need 20 to
check the magic 20 times.

>
> Do you see 400ms reboot times on machines that have 20G of IOMMU page
> tables? That's impressive presuming the overall size of those machines.=20
>
>> 4096 =3D 5.24 million pages. If we access "struct page" only for the
>> magic purpose, we fetch full 64-byte cacheline, which is 5.24 million
>> * 64 bytes =3D 335 M, that is ~13ms with ~25G/s DRAM; and also each TLB
>> miss will add some latency, 5.2M * 10ns =3D ~50ms. In total we can get
>> 15ms ~ 50ms regression compared to 400ms, that is 4-12%. It will be
>> less if we also access "struct page" for another reason at the same
>> time, but still it adds up.
>
> Your overhead calculations are based on the assumption that we don't
> access struct page, but we do. We assign page->private during
> deserialization and then initialize struct page during restore.
> We get the hit of cache fetches and TLB misses anyway.

Exactly. The cache line will be fetched anyway. So I think the real
overhead is a fetch and compare.

>
> It would be interesting to see the difference *measured* on those large
> systems.
>
[...]

--=20
Regards,
Pratyush Yadav

