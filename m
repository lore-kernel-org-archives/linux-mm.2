Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82E2EC9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65A456B0098; Tue, 29 Sep 2026 03:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633256B0099; Tue, 29 Sep 2026 03:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 549046B009E; Tue, 29 Sep 2026 03:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D7936B0098
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:47:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD7FE1C2CE4
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:47:44 +0000 (UTC)
X-FDA: 85266020448.21.80D58C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E0E8480002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:47:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gg5xZePM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668063;
	b=Twd3mQA5l79mvvAyZKQ+U+75JkQed/Vl4LV4hG87TVICvEh3G8nUM2laJ43roDMYsktgc6
	anDfPFQK6zq9WeVWob5+EP2EtaFw8hVGnw7+zq/ekdmtquJk1/FwacIEdQsS4wopFFKPq/
	4op5FYlrF8TXRknnUoMNgnTjgIIcoJQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gg5xZePM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mLNdmFrM1t3FQWmwFYe8TkIte1jls2u/1QCzj1F20EY=;
	b=M2nj/D5Bh2rro/k7nmGTHG9s9MRbCbS/sUuc36/W85ffXspA8n7dscjxHfqAt5KEPgCc5g
	qKR5FQHvxHvnpRlMXEG1MGb4sWa76YH6Cu7VZhfNwfxANgcl2jcKi/5heHzZxIhUjJl2nu
	fw6Ksx7rMPbUrI3PyuYKlLYY3BdL1Bk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 139CF401F4;
	Tue, 29 Sep 2026 07:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269FF1F000FF;
	Tue, 29 Sep 2026 07:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790668062;
	bh=mLNdmFrM1t3FQWmwFYe8TkIte1jls2u/1QCzj1F20EY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gg5xZePM0dIkrhC1PdGvJcGV+oFHBPWdh25qEyGA/kv1arZLYUnlWIg8wYuuY2JMv
	 0Cv8TB0Q443gxxo1iT1HdyRBGyaNgNImagvoVmhbTl97GAVsPW/gCeBReirTK6Gmc+
	 z3/aCs5FelgEO1RJ+5g49VeJ9Q3KDuYnWzfwdptnkL5L2UOkvG0UaHfpj2mWcFAdG+
	 oNsbmTfZzPB+ZYrpR8qZJGzzptj+mMD4CC2TNVZItnO3Lx9qH4U4ku3moBnlZ4Y5v3
	 to3Ypf7+EnuF3CDkDuLWSVKxqoXh4n7einnw7diI2GmBZ5IcyjK67gW42MUdXYEI+i
	 N0JNy58OXWQtg==
Message-ID: <92ec3966-e68c-4dda-9d8b-9462f22c9e93@kernel.org>
Date: Tue, 29 Sep 2026 09:47:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 0/9] selftests/mm: improve mremap_test
To: Kalesh Singh <kaleshsingh@google.com>,
 Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, John Hubbard <jhubbard@nvidia.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun
 <ts930@dgu.ac.kr>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
 <b8da4a73-296b-47f9-95dd-b8a74f3a0984@arm.com>
 <CAC_TJvexEaehZno0P=xsoCbLw7wgfz+22iV4fwzcuGCiu3vAAw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAC_TJvexEaehZno0P=xsoCbLw7wgfz+22iV4fwzcuGCiu3vAAw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 33rjitidrj8zkrgj6wiq1hyxuh6jkpnz
X-Rspam-User: 
X-Rspamd-Queue-Id: E0E8480002
X-HE-Tag: 1790668062-959184
X-HE-Meta: U2FsdGVkX19tIhb/PNN8G9ilMGX9kYTCrev2/abK39pB4Ac+gjDWJ1BKr3HTwxuJJ+3w27RHA0tRjMZWZPAzr1lpWbDlcq+r6qRtMZaUgZ38PkOv8yFLAWEWpbcFSwboYoQajUqJfLo8m2IdosnqMgV3iZX03kzF75xdKTI7+XUdOM3tiwaBCDiF59Hq+O8/srgnDhpkB4djKB/q+MkMC0W3KUMy+moJ7osJwGfRP0dHh2VDYqK/W4GTWsJVYYTjH3jK2gFCy75Q5IyeQLzs4wwIMy+0Ox+HfHzvJhqGrn6wkBgoUYeDEJ3UP260W1diiV72EgmaNZ4oJ1cRMHEC0GETqNy+33fkB1M3BcLrn+HYX8tBeFS0zrm41WwpObsMLTBVt/4Vz+420E7fCdK/RS40WtdHb2+JdiOxXmmXsXyZjmzQ6vqiMgFqdgvFG6DGP1rWNRuJJi6lsKmf41spGxAlOPe2Ayue4gE22QFRNb2y7WP5WRCoww7V5Wpheo2MwxQRkltyadWq2owZ9EWM238HvXb568/73sY+6JzIGkn+vJk0VeDBXBpBXfzgBhBvC7G4kHNqXD95TaWmL7F8ANNGphojI+5cZMxWBD2XzXgmS/O+jkq2lSOg6JhCaHVWK+KshDaHsyMN1mmFz4ppf73T6zECwPJhkHQ8uv55CZzRY+nbIkY5p5HoeTc4uz+3bhYgJVDBNNrUgrqN0tcybJaDABqRKp8SvsFeqfg/CXYtlhadqDvPUXnPdaiHF1zdxjrnf1N7X4pvyTIYVOvzBLvw4qch7JXzjbsNGP7qYmwQC7MRm5oiZLrFNlu5JKgDcEvgtTqQclyScM4lxd6kjf04kK1spylBVq+DaclbSOUHyBwLNcdkWwii1NYWA22IUjXaBROzHZR9fz19dvwlxmMyqzxCOFKo3C4aGlx1nDg2x3chw9ExYHYljucqzQK7cJIapEr1yP28XJmJJuL
 aFSUEkPA
 gnRDg/DBifpVKM+56D+YbO9IRAZjun2RbkCrJQOZvqBr+LmGicDdeddd6S7+IERcv1EvUWZ0anoj+/T7mix6lykdCgrc34SrKQFchwG4FIgylPVPu7ODxQuEYJzBA1Bb1wg9EPcUXxEocoAD16h5H0tvBp5N0IRVrKd1nb/bLFSWQh/kgD3tQqZleXe7t5Hao46yRHpjhyldjBMzFRX+T2WhWUAHYSRYFEJMJyNwtYtrD+V60ATNNkMXQU3/E0bRqL7/PxA/2IWCGLuN27uSe6i9QQ9mbGq4pyQGKBpWRxZrk1b8Fv3mBrNCK7dIRQOo9lpIvTUmaT/Q3Zm1HPApZ7G+Hpv2qMGF5EvTOAnsX5HlCnJ7ECmy4M1vdd84AcN6sD2tuwBWcipfJouU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/29/26 09:32, Kalesh Singh wrote:
> On Mon, Sep 28, 2026 at 10:54 PM Sarthak Sharma <sarthak.sharma@arm.com> wrote:
>>
>>
>>
>> On 9/24/26 10:30 AM, Sarthak Sharma wrote:
>>> This series fixes several correctness issues in mremap_test and
>>> simplifies and strengthens its data validation.
>>>
>>> Patch 1 converts the mremap_test to use kselftest helpers, removes
>>> manual tracking of failed tests and corrects some spelling errors.
>>>
>>> Patches 2 to 5 fix userfaultfd skipping, unexpected mremap success
>>> handling, multi-VMA data validation and failure reporting when data
>>> corruption is detected.
>>>
>>> Patch 6 removes the randomization and uses a simple pattern based approach.
>>>
>>> Patch 7 removes perf tests and timing infrastructure.
>>>
>>> Patch 8 removes validation threshold and always validates complete mappings.
>>>
>>> Patch 9 strengthens the multi VMA validation by also checking the
>>> mapping state of holes after remapping.
>>
>> Hello everyone! Just wanted to check if someone has had a chance to look
>> at the series.
>>
>> Also, Sashiko has a concern [1], and I had the same while posting the
>> series. I hope I can get some opinion from the community.
>>
>> Currently, for PUD remap tests, we allocate a source mapping of 2GB. We
>> only fault in the first threshold_mb amount of memory, remap the whole
>> region, and validate the already faulted threshold_mb amount of memory,
>> which is, by default, equal to 4MB and can be changed by the user by
>> supplying a command line option.
>>
>> Since we plan to remove all command line options from teh selftests, I
>> removed threshold_mb altogether, following some discussion on the list
>> [2]. This would now cause a 2GB source mapping, and its contents copied
>> from another 2GB buffer. This causes the process to have a 4GB RSS.

Yeah, that's a lot for small CI systems indeed.

>> Sashiko says that this can cause OOM killing in small CI machines.
>>
>> Would it be okay to keep a 4GB RSS in this case, or should we find some
>> other way of validating a part of the whole range instead?
> 
> Hi Sarthak,
> 
> IIRC when I initially introduced the test, John was concerned that
> validating the whole range would significantly increase the duration
> of the mm selftests; this is why the threshold was introduced. Please
> check how much it increases if we validate the full range (with
> David's suggestions) and if it's no longer a concern from other folks.
> I am fine with removing the threshold.

As discussed off-list, I guess it makes more sense to validate a couple of pages
at the beginning, the middle and the end?

-- 
Cheers,

David

