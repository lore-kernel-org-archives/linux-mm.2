Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50403CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 11:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 599D16B0088; Mon, 12 Oct 2026 07:08:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54A3A6B008A; Mon, 12 Oct 2026 07:08:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4874C6B0095; Mon, 12 Oct 2026 07:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D94F6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:08:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78C6880B6D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:08:56 +0000 (UTC)
X-FDA: 85313701872.17.E4EE224
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 90BC54000A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:08:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="qcB4a4H/";
	spf=pass (imf01.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791803334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b0fc1ZlrBilmls4Eb3KQH2Vlf4XqPBNZuwkuQ6G4/sU=;
	b=DjVsPSQYiH9bHqhAKcsdAz+5q1helKLuD6Q8CSI87Mh0gyky6GUNMww+Ut/vKRbj6lWcRp
	68+Fo1twAafTjsAFESiNGWoyFyH8xC2PMYgVrfES98UJcmQo2Z/i+dJuO6l+uSc+XnKCMd
	+rprXIoHiObThH1qPdQTIbmLjk33WfM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="qcB4a4H/";
	spf=pass (imf01.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791803334;
	b=ZIZh9JWlQDRAr1LDnaQ8t1jY3+ilNucBcIniNOx/JJGV8DfmpYKS0zKC7TG5cy/oXYCjxs
	KHHLH3LHvIuQlGVTFZqDMMgR17fKDNfUN4BjN7nB2dnChOeEGrJdD1aaq3ENmI9alC2S8O
	VCvqqzL0UwD+S0hZz9vT90iEjXzISB8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5510E1655;
	Mon, 12 Oct 2026 04:08:50 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C4EB93F882;
	Mon, 12 Oct 2026 04:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791803333; bh=1Hcxmhs7YzpUmvxySV5KGDi41fGrFGMMIIK6BavKtUw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qcB4a4H/e3/zyLeuwjBKRzIOz4KxK8O9Pd/mFnszBix80X4+DM9h5gXTQz46PIE2D
	 651GcNke9l8jveaCHusuOFxFKeF58ksUFNEKrLgjZwKzSEFzYqvOyW4gNDMCICpMjF
	 4EDe/ST+m/BnWzEW7xfx0XwwZ7y4TdR597OBef9M=
Message-ID: <68905ee7-83b1-4d5f-a1e6-8ddd2ae291d1@arm.com>
Date: Mon, 12 Oct 2026 16:38:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/12] selftests/mm: improve mremap_test
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org,
 vbabka@suse.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, jhubbard@nvidia.com, kaleshsingh@google.com,
 anshuman.khandual@arm.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261006092511.145776-1-sarthak.sharma@arm.com>
 <3a0673a6-744b-45a1-80fd-737a366fafc4@arm.com> <asyxQbp8EfVE9yQs@gremlin>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <asyxQbp8EfVE9yQs@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 90BC54000A
X-Stat-Signature: ksypn1hc3yk6jpr4m3ngpn7eiujch9pc
X-HE-Tag: 1791803334-506544
X-HE-Meta: U2FsdGVkX1+pYbJsif4nk6pAWNwUNaVnAVvL5hlghEYoyGNPu2FYrkvWuFMFOQtToc3A4b7cWJs8Xm2eTVpB6dVX/5N8N8RTYje3ZxAw/CDRazId6F3RtUgkdJl3biKKxnGVqsTRN/6LKWvPll4y3e3sW/m5X3vjjgVSDmjNXrjOGuhb+y/iv+isvWubFxhUaOBhzmhTOeWP9tlChceUpl3G6HROkERJxeadK3Rt4yUXPtcJ0XUYmkprC+ioiZqk5ovTV1scH/KgkXduFaUArRONrHsBjRTyUBVnCsGeJI1QSh2AtCFKWmqsyPNJg/l5u8Ir0rKEszADkAnAi+WnNbHrzJK6Al/PgiZU3hVzgFx/SyYZmXqDcLZpX3tH6xmRBYiO9ODRTPzKUD26mioYPhUDk31wOKyht62zCb3BxxtIQWj+Ld4YQVkpU5/AyPTuzzzbAjwuisXJpp/pnbg+2Fp7xg7BHwPPX6LHAon6l8GWsYEbTaQ520o28+pkqv9mW513tvtxLgEaUastPnzrgrsSZXZhuXc9LE3Eic13OzbcNFK+esq/RWmT5ff2Y7PHQJeTsqYlVesIwrDQep8W+LQd6Z7iLNME/IIyM2Z9tw/0kmnrQ90dOPsjpI4RyoX0xMZZYBaV0vmeai+Vzf7ZcRHjV6cm2t2pZJHmR5pYojVuM/ZL/+K3QtApr+XgGVe2kbNO4i3jqKKLZI/ZCksMzjP7nJzitbmt77Cw7J2G3E2iyRTvILd92i6425t6dfxEHnmxxahr5r6yD713/oYIHS8jmcN/DpWbJdH7R4bO6s62j7oLHIcSsM9s2MolJrKP7XAB0mHO77pqQHt9RNAeXGEW8gu9TL7b1PR6uk+sOdj7IzswoUf+LrWiYfoFrnirW9Fjy70cdXry/uCA/UE574lKY6MdaxrAHc860obixeqCurzvt3Hl/K7JBxKc7xHhGPPHGUbs+vd3qaVm19S
 0QTQidbX
 oud/0coz7qx6TFEfPdjH752uQcpfdpgL686DQVu8vMAk4mIMbV60iaAxxpOX1hP0dv4Nxoai0WPJ2Z5I5mRRosVvGxmTN8NjILIvCmSSUe/18O+HM9pBKwGui9QNxKaWXu8xQECW2E5WJUesiYDpOLGYRwQ/8IGp3DZxA+AfFleZm+7hFn6n4pVZkLr6+G0Go35rvqHL2XnwrlKUPTP3i361Vdl3GSSzCZG/4PAaLoLR0c5Nt/x98aBBHybM7Tqzhq9YPvVZmJ5HnF8QrTGL7Hz4jyh4KSuI0O5Q96QbZOhSlvTcxW2hRuFGZZCFv2b1KuZVOxDlKLlVOZ8NKj7m3oXoyBU8oxznzEh6i6ynZGVOLisIJ/1e1gUTeUVBSFY+LMa+MFHdmPgF32f/eSaV0stsVogJI9wiWjuxmaFJ4IDKbNJI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo!

On 10/12/26 3:43 PM, Lorenzo Stoakes (ARM) wrote:
> On Mon, Oct 12, 2026 at 10:20:45AM +0530, Sarthak Sharma wrote:
>> On 10/6/26 2:54 PM, Sarthak Sharma wrote:
>>> This series fixes correctness issues in mremap_test, simplifies its
>>> test infrastructure and strengthens validation of remapped mappings.
>>>
>>> Patches 1-3 remove unused command line handling, unnecessary cleanup
>>> checks and redundant errno handling. Patch 4 converts the test to use
>>> kselftest helpers and removes manual failure tracking.
>>>
>>> Patches 5-8 fix handling of unavailable userfaultfd support, unexpected
>>> mremap() successes, data-corruption failures and cleanup after mmap()
>>> failures. Patch 9 removes perf tests and timing infrastructure.
>>>
>>> Patches 10 and 11 replace threshold-based random-data validation with
>>> sampled validation and a deterministic data pattern. Patch 12
>>> strengthens multi VMA validation by also checking the mapping state
>>> of holes after remapping.
>>
>> [...]
>>
>>> ---
>>> Sarthak Sharma (12):
>>>   selftests/mm: mremap_test: remove command line options
>>>   selftests/mm: mremap_test: drop munmap() checks from cleanup paths
>>>   selftests/mm: mremap_test: simplify errno handling
>>>   selftests/mm: mremap_test: use kselftest helpers
>>>   selftests/mm: mremap_test: skip test when userfaultfd is unavailable
>>>   selftests/mm: mremap_test: fail unexpected mremap successes
>>>   selftests/mm: mremap_test: fail on data corruption
>>>   selftests/mm: mremap_test: handle cleanup after mmap failures
>>>   selftests/mm: mremap_test: remove perf tests and timing
>>>   selftests/mm: mremap_test: replace validation threshold with sampled
>>>     checks
>>>   selftests/mm: mremap_test: replace random data with deterministic
>>>     pattern
>>>   selftests/mm: mremap_test: strengthen multi VMA validation
>>>
>>>  tools/testing/selftests/mm/mremap_test.c | 701 ++++++++++-------------
>>>  1 file changed, 291 insertions(+), 410 deletions(-)
>>>
>>
>> I wanted to address the concern Sashiko has over this patch series [1].
>> It says that mremap(..., MAP_FIXED) over a range containing multiple
>> VMAs should unmap the whole range first and then map the VMAs.
> 
> I don't think you need to spend time worrying about sashiko stuff about
> mremap() behaviour in a test series :)

:)

> 
>>
>> But this is not the case, as was discussed on the list earlier as well.
>> We iterate over the VMAs in the range and only unmap and then map the
>> region that the VMAs occupy. IOW, as quoted by Lorenzo [2], "the
>> sematics are such that gaps are not propagated (i.e. it is as if you
>> mremap()'d each individually)". So if we remap over an existing mapping,
>> the mapping region on which a hole is remapped should not be affected at
>> all. So this is a false positive.
> 
> I will be removing the gaps stuff in any case (as discussed elsewhere
> too).
> 
> It's problematic, more so for the fact stuff can get mapped in gaps before
> the mremap() operation.

Yup, makes sense.

> 
>>
>> While here, requesting for some feedback on this series, if anyone has
>> had a chance to look at it :).
> 
> Thanks for the series, this cycle has been very busy so I think this is one
> for the next cycle (i.e. targeting 7.5).
> 
> So I'd recommend resending at 7.4-rc1?

Sure, I'll resend around that time.

> 
>>
>> [1]
>> https://sashiko.dev/#/patchset/20261006092511.145776-1-sarthak.sharma%40arm.com
>>
>> [2] https://lore.kernel.org/linux-mm/agH1ZSdX_7QF8P_I@lucifer/
>>
> 
> --
> Cheers, Lorenzo


