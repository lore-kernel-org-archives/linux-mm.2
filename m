Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E0D3CD6E61
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 09:19:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63EB6B03D6; Tue,  2 Jun 2026 05:19:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12876B03D8; Tue,  2 Jun 2026 05:19:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B01826B03DC; Tue,  2 Jun 2026 05:19:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B5776B03D6
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 05:19:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C2C19241A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:19:56 +0000 (UTC)
X-FDA: 84834425592.29.E81E50A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A083B120008
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:19:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BNYD5hoE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780391994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7gHvCsWNZjI8QmY3pCjcEfCTWb0bSVxI5a5CZALDQ+8=;
	b=nq+peLMLMx4uuFB74BYg9bPYL3Wq/28Bzb5W+TedTenIB29b6Bxy4GjfT4KnoMUsGJUw8T
	UkQPmPSlPgx1awlMFKKZSI1I7C2cIn323qSPyqrNEvpkb6FR7v0nlhzeO5fzMfNE+F4/JT
	r+EL4rayjJdN7qYy8Ou1uM3kSrYovX8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BNYD5hoE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780391994;
	b=CNKq5dJ0F/OgcIzD78mPcC7OlXzrkI/WEPEBqwyswRPL7WJnDh9paYaSjW+AS5fij3KBy3
	uYf3LX2VXTgqzKRGpCFIlHDaq02LgAcZMIMcTkXn5nTv6VhkyaqFFLgonWRDGXW7x7a185
	vPEXjWFwofxYulXhSeeX/KP6IS+9UpM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 195AD60098;
	Tue,  2 Jun 2026 09:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0B21F00893;
	Tue,  2 Jun 2026 09:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780391993;
	bh=7gHvCsWNZjI8QmY3pCjcEfCTWb0bSVxI5a5CZALDQ+8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BNYD5hoE4FSkqlFHssT/btTtpvouwiuIF4MEjbmsn4TMfPtjYlNicclO9M+lvr+0v
	 yNdTG3Ome8V2lS8+sBYp2FQ/DkeSrsZ2HBVCu8RmdlGabr08yV/uGavdTnmZomBEtF
	 fw7Ix+1G6aR2iKF/AKvWu2yYqgQl+ttmyXHQVp3KkVn2Bm6LEWdL+qPLle9KA+DkHV
	 CkLoKBF5O3fgfytYtGMQLxVFSDhfaf6B/cRmOyWbz0AoVRjXCoIknBPNEOlqzTaIMC
	 xpmGc68YUY04wbl7XxQMYinkVjPuKxKpgbCbrDndFrxGbD8PIjym13hv/7FX69TCMd
	 APp+1CXI8dgHw==
Message-ID: <c98eb14d-b878-4eeb-91f0-d2b1d4407e1e@kernel.org>
Date: Tue, 2 Jun 2026 11:19:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: don't allow empty relative nodemask in
 mpol_relative_nodemask()
To: Gregory Price <gourry@gourry.net>
Cc: Yury Norov <ynorov@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Farhad Alemi <farhad.alemi@berkeley.edu>, Waiman Long <longman@redhat.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, cgroups@vger.kernel.org
References: <20260528124133.c88c27b11a8ea0ef05e494f7@linux-foundation.org>
 <20260529152616.2308736-1-joshua.hahnjy@gmail.com> <ahnRIDBk4bQ3xX2q@yury>
 <fe33c767-ea11-43e2-8732-f752c9c1205c@kernel.org>
 <ah6X-RtVX75YP7VX@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ah6X-RtVX75YP7VX@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A083B120008
X-Stat-Signature: p77ntbtzbiab6ptbpqnm8zf633g4urs1
X-HE-Tag: 1780391994-27276
X-HE-Meta: U2FsdGVkX1/AWRyy1KVh6DKN2wz7y22BZdO5so4tRlcN3wzJRaeBMFGIRtaVrrwFhbWPc45jetj1QGih9C4ZT3BBQ7+ylB5dPGVrWSz78xlPvSm+LhbjVREdczi8yL/MXppd38lgoxim4v5Gt+rfDux8hN0pP7yZb+KZEwyTTH0AXauNKhEArGl6m9058VOR3Xx8WoatEISA00Fyxm8LLu6dACsIl/HHrTXkpghfdh3EG2LpxS2cTqduzOyi7EuRBdlA35bGzhqjQS5NXZWBmHiHywXWY6c8JA90Dbs5nzxQIIDh69oIWpe9teq60G7tMBbzeMev7GwHOb1mpro28vCybUtzRCvTYV651oEmnWjd6xBtFPaSXcwnzEXtsLZXIgKytuVeZZ8Hp9UYLPDM5x7swOzqtl+pbeG2mhrzNQXhBqKgyfn2oJfbr9YM7Q8jQ6JkHKKMjLMT/9WD+i+W+ZZO01Edg0I0W+cuuP4sOoxTt/qVCL6vve8dsQXmtS03nNlyLF+eZFwpLyYo7mBoF8sung9IJmiHxIG1+00vOv/rFoBniIFqrgg4KwLk2NIGoP+/K1TvVmCFdVJcfXdeEP15zNsSMpQ/6QlkJQhy244YnvfXd/7KTLkj86v97TMpiKhXFNPj6iTPzd4KiJaAiep6WetC1F30W2BN220hmN5yTTRRfQa6G7/eDAG7OMyyBwqijWSRXheXidxaBquLAB6VZvlFfPfgpJRvfB266NOmmAK0xRe0Dre6XKz7DOI7tRcGQ9zW6z11Zh1d1HraOPoplMarKu9Vducq9R3BlSfFHivMv2ylSm6pnsAVPo7UUOTTCAtRrDTM6lfqneAK15pDJIm//wif9MPQfPvwn57mM/9Nen617/stuygJ9LczEpYgYeB06PwBYyaCQHfcutAhh9cmfhlEbsNIkOyCt8wWR62DEtR5931V/plkR9OnzlH/5sFc3x684jYcKUI
 MaE/cEwa
 HkGbAHP4I2Y0tC9yz4C5UWMJJnw5ehJAcJ75TcmjWcmvbRf+pds6gKGe/ds4uPiewvw0GaC9vQRj32fz+EDASggiBVvNsjH5iJZBKUNXMkDirj/xEFStTKLzeXP4FXkG74bxil2rCNNcjyS8hcgeYGCJh1u3MGppKjJ9Iwp+Uh2cQZtF6qzX+uYeUTBqeEcqExcChMM8u+1ePCZH79oDiIkV6GHKDtQ8eyYzsGhJTBguVlpQLBDBEDqEEaCQU7TanhMZSK66y/qn18s5NHHTxfqU9arNWiT0jUvRY88edfYz90zBV64WV4dlRqkngROlWTZ62C4gE7zQ6HyB6SCaU6bSO1MFpVxjdVUrtOyYDEkvB+Okk0CbqEM+nPpxDDw9rZlQPwGBiGJJMyf0cukpXySQvq66QVNEqiZvTh0oeSCLCJdw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 10:44, Gregory Price wrote:
> On Mon, Jun 01, 2026 at 04:32:25PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> Hi Joshua.
>>>
>>> Indeed, quick and dirty shot.
>>>
>>> The problem is that nodes_fold() can't work with the sz == 0. In
>>> other words, folding to a 0-bit bitmap is an error. We don't check
>>> that on bitmaps level because it's an internal helper, and it's a
>>> caller's responsibility to validate the parameters.
>>>
>>> nodes_onto(), or more specifically bitmap_onto(), is a different
>>> story. In case of empty relmap, the function actually clears all the
>>> bits in dst and returns.
>>
>> It's very weird that mpol_new_nodemask() (->create() callback) disallows empty
>> nodemasks, but mpol_rebind_nodemask() (->rebind() callback) would allow empty
>> nodemasks.
>>
> 
> Was this actually observed?
> 
> mpol_rebind_nodemask() happens when cgroup.cpuset changes, and
> cgroup.cpuset cannot be empty.
> 
> cpuset only changes with sysfs twiddles or offlining.  In either case,
> cpuset *guarantees* that cpuset.mems will never be empty.
> 
> So... is this an observed bug or just a statically discovered
> "bug" that can't actually be reached?

According to the report [1] syzkaller can trigger it. There is no reproducer,
though.


[1]
https://lore.kernel.org/all/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/

-- 
Cheers,

David

