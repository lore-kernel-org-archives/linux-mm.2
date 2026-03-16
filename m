Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59523F506E0
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FC906B02BC; Mon, 16 Mar 2026 10:44:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AA136B02BE; Mon, 16 Mar 2026 10:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581E16B02BF; Mon, 16 Mar 2026 10:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 449516B02BC
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:44:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B766957D13
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:44:22 +0000 (UTC)
X-FDA: 84552196764.02.22825D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 062221C000A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:44:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ptk4SxbE;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773672261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=65zTm6Esy8oJajm+TqC/L370RVf+WyjaPSPspMQzmYA=;
	b=34bpXFDVwtqnvKq8tnvDzO88+bmb5dx5Ib04cPwjWbbSXpji+FHAkG1iTO2UsPOxMLNWKk
	Ickck/Gu+GRyuj7UZL0exPl8RgmGxuLzLzwkUzzCrwo4MA6B/C89MaadkPUBV3QSE2yczs
	JYkt3nkjeVqnBEHzaYDIVtmN6Y7TZHQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773672261; a=rsa-sha256;
	cv=none;
	b=MwvGTetgnVflPR+PxeU7iW2CczfiNzZfHry7YPeyIWIRiZNRzJoxiNf4TWPUWJ7Z8aoc8F
	a9SFKGQ2aPAGKpFl5LQMm5lCdl/DQMecAp1w4YAyuB+j/9mFhDqLt+Y6TgC/I1CfqniucQ
	4r/OtEHosJb+3W9dacbKdxzgJJkLB6o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ptk4SxbE;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CB9D60097;
	Mon, 16 Mar 2026 14:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AC9C19425;
	Mon, 16 Mar 2026 14:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773672260;
	bh=RWDptXH394kez7vsWxAJNKfiKtyiFebfEXRYauFWPxI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ptk4SxbEo4/hvLxqc1tWPJDZbTxCRLIRsmnGkN8VQMVTkGr6+aCK1Gmqqj5BozWSN
	 kYQPpn7kArWkvxepUN4mFOPeJ0jwMeYDhjYa67KOU/HrXR60iYkFxSZS93j4CEs+fV
	 uttyyH7XuLlDkBbFKRPLYSwjhZP07y6PRSD8O1TYo2kSw0DzMH9h4RxEi9VSVNPVjw
	 QZiZvabmugwgBKxxxH8W6SfJ6W3jaVQmwP82QUiS1xA9h/7XOJk57yRLiu9cyhY9qN
	 xJWkPWqwULrWsTC6Q8/5uUJE4gHj0lRbXsvDMGlDZijYwyWUIeek8nfugLJrPfQ/US
	 1uwRM+y+EgKKA==
Message-ID: <be860d86-75be-4c75-95ea-03bf79524be2@kernel.org>
Date: Mon, 16 Mar 2026 15:44:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: add THP sysfs interface test
To: Breno Leitao <leitao@debian.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, kernel-team@meta.com
References: <20260309-thp_selftest_v2-v1-1-a00cef41da44@debian.org>
 <9cb63c24-eaff-4954-97d5-2a422a0401fc@lucifer.local>
 <abgJtJYQsGMPsTHr@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <abgJtJYQsGMPsTHr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c5pq8fo5ic57rysb93dk8d6kgp4617f8
X-Rspam-User: 
X-Rspamd-Queue-Id: 062221C000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1773672260-107376
X-HE-Meta: U2FsdGVkX19Aas6A8Px+XIVz0a+Phy/MuqmAWWJNZkwP88cVaNp9UrW4SRTyknYAQYmVv2UnFqzVC5yG17//ADrpq1PBQKONFu0v6fhXtmPzUCXUo7Yye+6ZrOKN9uBYbbm8v5rpRT8PwRUZUflTj5lu8gWoUYh9JIFrW59u8Yx0fQwPKI5WJWr3TGF4o+eQ+RT7EnS+uOdGyMiue9iqrAPZInKtvCOutKnfNV14NaYDR5X12ZpdtMCdImfyack59qQ/VCJU39hJvBcAY+cTjKM3ZL+DozEeLNDsJjriB6TSbkNdPVcLTORu/qjdI0NloLFBciLYwlTNpsei8BrwnkRHMyewXLAZ5UX/J7XPmvdafQGumd39Em8LdrbZWcoKN8xS3tFOn4zWTWrCD1xW72h7xmWCC5RIDtmDXPF5qr6CpnfW9Lit9sgrXh+rTgdOyp8Jw09+NcXmndHPicYnA3BdSA0Z5IluxCqu8zBcI8ys83NNtU+o1IJ1hi7sDZVtQ3oFtAt85MjpeKuYfEEUiA+wUepwZxgnaYXWkjn6IW5QM6cp0szOw86JJ+IEqbaCSgKtSUeBKS0snygIqe+3NWi/DcKspI+WHeLNVRlWXj+o1LDu+tiyYnEQvKNRSyXYmSYD0OTQlrkAKhZB1MhcOI5UD7CGIt2K9zU/2zyP6qgdT84+RcBJs+7Eonm8qK9XefbNoTHfPMMpfreg6INZLgMse3uJ4R9mOEOlb/vkVoN40fnzSA/S707Neh3tNkxgN0HCfeG6jnzPe3AEt+gB1ONuzpogVTrOeYuGzdJNwfNkhUrWRqeUWb1dJgZIZ7KG+1bUKkAkRMuzBVRKQnyGQnaTJ9Te68UCEMxmUVxgrCS/U+A2LsV7AgufdVaxybr691Pqpk5YMSLm0Ejn2F2U0duG9fKPA1WjpHbZK9+jNcShKZdfpp71emwI3Cv9PIxjBn5RTBj1zf/q/aPCYcL
 mzPm64gh
 ud8VQd0jAl/QIGSQtvqDZJ/j52f9ggzbJtiSqYeQkCjaHu6c8mAxghNyJdIa15nW62I3HLdJgs+tfIxzPwwoRWa6BAnAeAmOVG09KSCLWUKXoIhz6qGgzzl0r2t7Ycmf3m0s0z2iHaBgDoARxML2dRW7Ds1uMoWnrc3iLZHfyqsXYTP9oKHYfUvxqeiQ0Cef/0vPCn91gT0Za7qQWOK3xiRguUClTlp4UGbVxkEIDtOzrmwzLkfkkgy2ffUKmiP6qTnE1B37vUZ3GgB5en82uEb57hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/16/26 14:47, Breno Leitao wrote:
> On Mon, Mar 16, 2026 at 12:55:13PM +0000, Lorenzo Stoakes (Oracle) wrote:
>> On Mon, Mar 09, 2026 at 05:00:34AM -0700, Breno Leitao wrote:
>>> Add a shell-based selftest that exercises the full set of THP sysfs
>>> knobs: enabled (global and per-size anon), defrag, use_zero_page,
>>> hpage_pmd_size, shmem_enabled (global and per-size), shrink_underused,
>>> khugepaged/ tunables, and per-size stats files.
>>>
>>> Each writable knob is tested for valid writes, invalid-input rejection,
>>> idempotent writes, and mode transitions where applicable. All original
>>> values are saved before testing and restored afterwards.
>>>
>>> The test uses the kselftest KTAP framework (ktap_helpers.sh) for
>>> structured TAP 13 output, making results parseable by the kselftest
>>> harness. The test plan is printed at the end since the number of test
>>> points is dynamic (depends on available hugepage sizes and sysfs files).
>>>
>>> This is particularly useful for validating the refactoring of
>>> enabled_store() and anon_enabled_store() to use sysfs_match_string()
>>> and the new change_enabled()/change_anon_orders() helpers.
>>>
>>> Signed-off-by: Breno Leitao <leitao@debian.org>
>>
>> The test is broken locally for me, returning error code 127.
>>
>> I do appreciate the effort here, so I'm sorry to push back negatively, but I
>> feel a bash script here is pretty janky, and frankly if any of these interfaces
>> were as broken as this it'd be a major failure that would surely get picked up
>> far sooner elsewhere.
>>
>> So while I think this might be useful as a local test for your sysfs interface
>> changes, I don't think this is really suited to the mm selftests.
> 
> That is totally fine. This test is what I have been using to test the
> changes, and I decide to share it in case someone find it useful.
> 
> Let's drop it.

Out of interest, to we know why the test is failing for Lorenzo?

I agree that the test is a bit excessive, in particular when it comes to
invalid/idempotent values etc. I could see some value for testing
whether setting the modes keeps working, but also then I wonder if that
is really something we'll be changing frequently (and that breaks easily).

-- 
Cheers,

David

