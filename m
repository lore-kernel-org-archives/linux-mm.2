Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 404E7C88E73
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 466B06B0093; Tue, 15 Sep 2026 04:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4183B6B0096; Tue, 15 Sep 2026 04:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308F46B00A4; Tue, 15 Sep 2026 04:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DE006B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:39:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8013B8036A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:39:31 +0000 (UTC)
X-FDA: 85215347742.21.D8F9D79
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 51419C0008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:39:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZQ+8sTEO;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789461569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ACD3yUszKbEn9SNvyomoKBpZdThNtSn1nMdd/duHd3c=;
	b=y6k8PpbgpTx5fZ7dJFudA3coXuv2ab4FV/GKFKqJd1yl3cmJbzI6XN2g6RkaHROgyNdqpl
	bdSnU85+PoVkVzPbOVDO9Nu3vWRHqoat/qzV+4aC4jwlqocZdgFn1udDW6bk+E3r+7V3MW
	zlE+SyiYsvFZ1prZs/bAssV2AWzGF60=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789461569;
	b=1Fg+iVWV/m7wR570/vF8+jow6FvNOhpdEGg3uMflPYKp2TngfYS4JRYvE7xM/NgcnPf/sg
	18BuMOQxe4cEXZ1s2NzVWAkQxEgsWS8Tqy8+vwCaeUSRTwnBjs6wGz5jz3DNWANsS3s4ul
	c5PxYqk0e1QrWY8au+xth48LN89A4gQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZQ+8sTEO;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 963E0169C;
	Tue, 15 Sep 2026 01:39:24 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C1D203F7B4;
	Tue, 15 Sep 2026 01:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789461568; bh=yHlIrOdPfLjj9Gu8t0QO/KBvaVLhX4WuZRnvoHBDFI8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZQ+8sTEOSXh+kPQv2ubox6sTg5+iNgLqJuOkCnT+cygDDQ9XBo7U6XJaXymP1pGJ+
	 Y0DmwYp1Zo0S2RIxo6AMwXMKi0Cw0M1zWx99eH1J1EXwt/XnrQjnJAF3bhvS8fMaz7
	 9qNmLrgH0LmpVPxUIkfIWBGKVDlRCIz9VcfSw9kU=
Message-ID: <e6caa3e6-084c-442b-8d0e-e851ba75914c@arm.com>
Date: Tue, 15 Sep 2026 14:09:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 6/6] selftests/mm: add a GUP selftest
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Rik van Riel <riel@surriel.com>
References: <20260911110950.200240-1-sarthak.sharma@arm.com>
 <20260911110950.200240-7-sarthak.sharma@arm.com>
 <891915e3-3333-45f3-81a8-1ad38fa7ee37@kernel.org>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <891915e3-3333-45f3-81a8-1ad38fa7ee37@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 51419C0008
X-Stat-Signature: iet65wfgn74kjiykz1gdnmd7apanyde3
X-HE-Tag: 1789461569-93132
X-HE-Meta: U2FsdGVkX1/BwViasT1Z15Bv89h/tjdphmstoiL6dceBapsKm3u62qWPfIhQ877ZBhr89CV8hWlqfFF2JXUwg0DjGGhxfwO2ceuT1P/PWUPsqq8JLFdLtYQXRvTx5s68P3p70jfItynDJxAmX+0hOmsKZ3+TXcE8X98xATWwoehCZlMMvKix2fP50IUkw8RsHBZdvkD1L5emnoq2lw4tfLxTnfRB8Y0EVMY2NuJeF94dhPSTNwhMYFLxJxAcWfAHtEGqcui8RR6DxuK3YM1ra4/AxIkm1lGGQpeAetsKi0JlPgoj4ck9axFpJ5SFSeN0ssAQB4NvaCiLrwLJM5oXBMdC8rNj145VyPxN1BUWlTtv4/9g02NOV2qoNDN+W6ZujQQ8mb/c985YU71UlmlLPYaO46JomgjwzzfVhIcMR1nkMyawWEM/5iX6oTAYsWEbyMXpTFWt7plZ0v0lLAd5yU6aoEjIwzxebWjCI0OVxQZmv0WRJTrjXrivnBNgdObSfO14EBFeGGF2nH5OoAWTi/MdggsQfPJNjcM3RApEhOumKUJ+V7BV7BDtEgA/tjTcBsVbWNgKTRytOxSfgJGHAehYvAaeYXCFEcoVXMPUA7rAfcwtB3BZ1LAQ8SbwjeZt3r9aBT+YwGD+fe7OtQsNB9mnK/skQJMQH1tZLwUJJ6NOn2dnHXG+XWurtsBs/CvHe7mQIq/+/LBpiANcJzEPAsYnDvttR/pFswPEhWTf/ET3MMz36D9TnWCy4nzOlDijJBWNHTHbd0OLEYUQN7Dtn+iFlLrDzX6XfygRAT9x11/n+HnPMFEAOZrJ9FNRKpTvXImi+Vy+opiQyQLknHLYM8NkeVlbRw85ZwoHk6uA6fK0aiAPz1pdp0jS4Mp5xcO8I4nq3Q7XmMYcHB5eJ1p1+ub+f5zTCHfpbBIUqrXKev2o7RYpHmQ2e9ZE45FlAZ6nlpslyq7O/2p8+O9p8s+
 YwZ3ZK7P
 ye5oypW0T4Z8xq9z5n2JrEoSnY7A5449sYo6+15FRbQe1VVEMPCX1BCdBh2LnbzRqDzYl4T4ZaYQMmm5L4WnoBv9jaUa1GQVp9huf4pU/3I0T7CSqik2EIpjyyUIUtlfazIN7sJ5abtPHSDiziTfSNhfMwt8vxW0k1qsuK8QAe7KG1zeIPmTP5bC6LyTeMH/WN/EuBHZgbCqI6Pac9PcSMfHG89KVH3hNfZ5VJcndJc9PUGhNBYYNaqrJyGvXy6+u8tS6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/11/26 9:18 PM, David Hildenbrand (Arm) wrote:

[...]

>> +
>> +/* Just the flags we need, copied from the kernel internals. */
>> +#define FOLL_WRITE	0x01	/* check pte is writable */
> 
> BTW, it's odd that we support passing GUP-flags ... we should probably switch at
> some point simpler attributes (bool write) or custom flags (but we don't seem to
> need many ...).

Agreed

> 
>> +
>> +/* Page counts exercising single, THP-batch, partial, and full-mapping GUP. */
>> +static const int nr_pages_list[] = { 1, 512, 123, -1 };
> 
> 
> Would we want to calculate 512 dynamically at runtime using the PMD pagesize?
> Could be something for a follow-up patch.

Yeah this can be done.

> 
>> +
>> +#define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
>> +#define NR_HUGE_PAGES 2
> 
> I'd call this "NR_HUGETLB_PAGES".

Okay.

[...]

>> +static void run_gup_cmd(struct __test_metadata *_metadata,
>> +			 FIXTURE_DATA(gup_test) *self,
>> +			 const FIXTURE_VARIANT(gup_test) *variant,
>> +			 unsigned long command)
> 
> We prefer two tab indents.

Okay.

> 
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < (int)ARRAY_SIZE(nr_pages_list); i++) {
>> +		struct gup_test gup = {
>> +			.addr = (unsigned long)self->addr,
>> +			.size = self->size,
>> +			.nr_pages_per_call = nr_pages_list[i] < 0 ?
>> +				self->size / psize() : nr_pages_list[i],
>> +			.gup_flags = variant->write ? FOLL_WRITE : 0,
>> +		};
>> +
>> +		TH_LOG("nr_pages_per_call=%u", gup.nr_pages_per_call);
>> +		ASSERT_EQ(ioctl(self->gup_fd, command, &gup), 0);
>> +		ASSERT_EQ(gup.size, self->size);
>> +	}
>> +}
>> +
>> +TEST_F(gup_test, get_user_pages)
>> +{
>> +	run_gup_cmd(_metadata, self, variant, GUP_BASIC_TEST);
>> +}
>> +
>> +TEST_F(gup_test, pin_user_pages)
>> +{
>> +	run_gup_cmd(_metadata, self, variant, PIN_BASIC_TEST);
>> +}
>> +
>> +TEST_F(gup_test, get_user_pages_fast)
>> +{
>> +	run_gup_cmd(_metadata, self, variant, GUP_FAST_BENCHMARK);
>> +}
>> +
>> +TEST_F(gup_test, pin_user_pages_fast)
>> +{
>> +	run_gup_cmd(_metadata, self, variant, PIN_FAST_BENCHMARK);
>> +}
>> +
>> +TEST_F(gup_test, pin_user_pages_longterm)
>> +{
>> +	run_gup_cmd(_metadata, self, variant, PIN_LONGTERM_BENCHMARK);
>> +}
> 
> Heh, is there actually a reason why these kernel things are called _BENCHMARK?
> 
> I think they are really just tests that can be used for benchmarking ... the
> measurement logic is entirely in user space.
> 
> We could consider cleaning that up as a follow-up.

Yeah this can be worked on as well.

> 
>> +
>> +int main(int argc, char **argv)
>> +{
>> +	int fd;
>> +
>> +	fd = open(GUP_TEST_FILE, O_RDWR);
> 
> Could do
> 
> const int fd = open(GUP_TEST_FILE, O_RDWR);

Okay.

> 
> 
> Thanks for doing that!
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thank you David!

> 
> 
> I think reasonable extensions will be to execute tests on all available mTHP
> sizes and all available hugetlb sizes, similar to what cow.c already does.
> 
> Can you look into that as part of some follow-up work? mTHP support will be
> interesting for testing some of the patches Rik has been working on.

Yup, I'll take that up.

Apart from the indentation, const int fd and the NR_HUGE_PAGES rename,
is there anything else I should incorporate in a respin? I think other
changes would require a separate series. If you want me to fold any
other change in a respin, please let me know.


