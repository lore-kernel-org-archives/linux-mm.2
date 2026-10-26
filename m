Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2DF1606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EUMUGfJy
Received: by kanga.kvack.org (Postfix)
	id D22FD6B05B2; Mon, 26 Oct 2026 17:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA896B05B3; Mon, 26 Oct 2026 17:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10106B05B4; Mon, 26 Oct 2026 17:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90C576B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:33:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 820EEA84EA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:33:56 +0000 (UTC)
X-FDA: 85366080072.22.8100A08
Received: from mta1.migadu.com (out-115.mta1.migadu.com [95.215.58.115])
	by imf04.hostedemail.com (Postfix) with ESMTP id 37C5340003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:33:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EUMUGfJy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.115 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793050434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dz35/3AuvDO18S1ap1WD5Da+psq9zQUaDV9gOjeP834=;
	b=JVEMOKa+AB0VmLchANDB/Adzc1gm8A3GjxkbovVyYXseqQ/0JkniSVuY6VOZ/G/8+Nk+j6
	TXtexwSRrGVoIm3Wxw7HoKDW2NcQusc1SK2kpTIXdnIJCu1NdJn0N0ZvmxiIrA/95QofJS
	VO7uX5c5GBrmMUCzcJZ18eOQT0D+08k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EUMUGfJy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.115 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793050434;
	b=7xOQJEx7t8+d4Gk++GaoKcs5S82VwPkv1FPuFOg6fus3RO5VR0c8qaP+ng3RWkWUWX7ngD
	uYTLN76GwzTP0qXc5wlHF7v/jo0VqoJpEOttd2vlPUDZvzaaZV3y5ZUGKiTSwAHt93Tp5s
	HZbc8XmsC4w0IzClhM606gQjYuN1v4U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RhJVRUhhLZt+aePS7fCAUtL8lWa14lc3+sdZ/JP8HZw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793050432; v=1; x=1793655232;
 b=EUMUGfJytvdpOG0PIQz5BaNE7I4aLO63MuJHXueRJd0aP53cD0ZnyLnfI6Ub5CnQkHFC7l9d
 PorKV4TDXTyACJYzU8y8mJSewGi+3z2tZH9zLSrhpXzEu8nLLRnYr5gsDLvcfB3IlUG81/SjY/+
 DFO12jUjzYF+7FUrfYGV2cm8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 34d1e3635c42cd72;
	Mon, 26 Oct 2026 21:33:52 +0000
X-Mizu-Trace-ID: 34d1e3635c42cd72
X-Migadu-Flow: FLOW_OUT
Message-ID: <a4dfbe84-aaf4-4711-8eac-6455470d1e7d@linux.dev>
Date: Mon, 26 Oct 2026 15:33:46 -0600
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/huge_memory.c: skip zero-page remapping when
 underused THP shrinker is disabled
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usamaarif642@gmail.com>, aarcange@redhat.com
References: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev>
 <20261025-b4-ksm_fixv2-v2-1-8b61ad0491f1@linux.dev>
 <CAGsJ_4zUVpBJazRxc1CzN6u5XvpUaGnaf-_7JMz-rGK_ZTYMtw@mail.gmail.com>
 <e865f7f0-087c-4fe5-b729-6e6946cd20f6@linux.dev>
 <CAGsJ_4wp_jCtCeMx39nW0Z1Jm5pja7_V6XNwLB6p7zTan0c3VA@mail.gmail.com>
 <dee39669-b726-480e-8ca6-10f19512da68@linux.dev>
 <CAGsJ_4w4ozXM+=T0qGBAhC323F49Y4LxrrKKt3GFCs+en_TVCg@mail.gmail.com>
Content-Language: en-US
From: Nico Pache <nico.pache@linux.dev>
In-Reply-To: <CAGsJ_4w4ozXM+=T0qGBAhC323F49Y4LxrrKKt3GFCs+en_TVCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 37C5340003
X-Stat-Signature: exz16gsp3aey6bhc9uw9kzc588rerdap
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793050433-566686
X-HE-Meta: U2FsdGVkX19uu+M4YAEIMWaaGIu6CMBw9um18zEDUdSzfSc0vjgMUotQCKcAuxe1yKUSI5wxOtimOmfTMW1HDyJ60KyzEI0GYZCQnrVR5dLd0HSeJ6kBOS3JLhVNV7qa7IWk0fwHhzuYHJeYArw2qBVR/+vWjKOLNzohk4Hjg8a5U8fJKoaZuzF0kWwHNP46koLXwF4WugaFfANx4+7esO+kt8CVQi9W1MsLesvO2KAqfvXZpz8w9rqXGIwlp9+SGsKYdjqg30vkxPxjEfl2XjJ09kg2yIiuLZQeoOPbceePfwpnL0EkQDdrpD8O2VUlYeUXoNhMloPH9GGOHJumjmZzLKpMwPiPvajN8XYmzF4LSivOfk2osL1chatCpDbOgPAlEUIcUGYwZl1WjLegAcxxWRaCgpG9eEn02nezL2XqOjJP3VF5hFNHY1GhNSgXNp7e8sLQnlS+13kqPCzSD+UokXSc9v7+iALRZMFlYORJYIviG7QNmEhtvdYkoz23ri3F5ZAiaVDaJ2VVnVi881zNhLDP3uX2mSVyYIv91uNyjpN0UH8ZzsMCUijNuXW71d/JtXBVF8x5QmNeV13iqryZ+IOaVk2fkivrNr2H5xbcAPBReD3fOAnFySV9fBpEVw1Q+iSuNY4/z8uYRoO8uEw23tWvXOC1aHXNVLdhBqBROrf6CC+Hw2tioEgET5r/yMgh+9hupA5dgMeiq4a0I5ahF20T10OJR9rtBKgd7jIrONvinGhLyjawHb6itRj7uh2sw2Xl6KG6AJAHQ7Q5v0cFQWJgte7h4a4Rsk/A/fr/49Nvy0dY2U3sudOkacmtTy5AER5yW1XQ0AN3QaAjHTXJXfVAyT8Fj+uMQLCYJoIMA5zIl6R75W4Prx8JqYNmL1NVdF893r6S1xbIShY95H78FfxUxG0w6hBMfC2xRWvHuvzwzSwOEnn2DwNy8in/stAiv7NK4KsfsySZYw7
 s37cByiL
 eB6c9QF/TJD4sSXeN/hyJPNQ/E0Sudsqfp2jalqn5YMm72t3XXZLbm4bL7WR4Pa43tX2U1n7wyH7OSXI4qHpOpN/w/NoEgPxi/06j2n59Hj5aQFdg4DtaBrxsWR/kIXnpx6ZZgEnvLrNQgj4zqPptbsiAuv96kLa3qRrUu13N9AZF2hnb3SZDd1J2JXTvAw6fdvmxG2wAjz9Fxa9rYMZnhyCsjYpOWhz7fxODSVG7xKek5yQVFQMmgPpIwapQze81pT4oYKLAZ0ZHbkaGUkNrkUxeWlBb9OheURPkxUiO2++5ZQpeVgLlJFc8NZEKXV3KOZ86JVJzNu2NSYnt9CvhUMoJ19uiEwUshNNnO/GOlHGXs5TScLjS8TfYpjoGzBWX/H3/eNHJsvq9OhOvs70xqTrIwwgUyCE+zKLBOmlUxH5oyUjPBcqYV3sz26Mi6CDv7SD2mp8OV5Ek6m1gc9vkaZt+uUITLFYfYMm2ui725ZHbc4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/26/26 2:58 PM, Barry Song wrote:
> On Tue, Oct 27, 2026 at 4:02 AM Nico Pache <nico.pache@linux.dev> wrote:
>>
>>
>>
>> On 10/25/26 10:52 PM, Barry Song wrote:
>>> On Mon, Oct 26, 2026 at 5:48 AM Nico Pache <nico.pache@linux.dev> wrote:
>>>>
>>>>
>>>>
>>>> On 10/25/26 2:28 PM, Barry Song wrote:
>>>>> On Mon, Oct 26, 2026 at 1:40 AM Nico Pache (Red Hat)
>>>>> <nico.pache@linux.dev> wrote:
>>>>>>
>>>>>> The zero-page remapping in __folio_split() was added to support the
>>>>>> underused THP shrinker. When the shrinker is disabled via
>>>>>> shrink_underused, gate TTU_USE_SHARED_ZEROPAGE on split_underused_thp
>>>>>> to avoid scanning subpages for zero content unnecessarily.
>>>>>>
>>>>>> Suggested-by: David Hildenbrand <david@kernel.org>
>>>>>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
>>>>>> Signed-off-by: Nico Pache <nico.pache@linux.dev>
>>>>>
>>>>> is b1f202060afe a correct fixes tag? as
>>>>> commit b1f202060afe has no even "split_underused_thp" there.
>>>>
>>>> I believe so. IIUC these two series were merged together. While
>>>> 81d3ff3c6f7 introduces the toggle, b1f202060afe is where the behavior
>>>> started.
>>>>
>>>> I guess you could argue that the Fixes should include both?
>>>>
>>>> Not entirely sure!
>>>
>>> Thanks for the clarification. I guess it's fine.
>>>
>>> BTW, with the code below, we no longer add fully mapped
>>> folios to deferred_split_folio. So the scanning code only
>>> handles partially mapped folios to set up zero-page mappings
>>> for their subpages.
>>>
>>> I'm still not quite sure whether this is really harmful, though.
>>> Am I missing something, or was there some discussion I missed?
>>
>> The issue is not in the actual shrinker code or the deferred split list.
>>
>> The issue is that any split leads to this zero-page remapping
>> indiscriminate of the actual toggle. The same way this toggle is gating
>> things going on the deferred split list, we should be gating the actual
>> zero-page remapping too.
> 
> I'm not quite sure this is true. The toggle prevents fully mapped
> folios from being added to the deferred split list, so their
> subpages won't have a chance to be remapped to zero.

Correct, but the deferred split list is not the only caller of 
folio_split(); all other callers get unconditional zero page remapping.

Additionally theres a difference between being fully mapped (and zero), 
and being partially unmapped. the zero-page remapping checks the content 
of the page. We could add folios to the deferred split list that are 
fully mapped but contain mostly zeros. With shrinker_underused turned 
off we no longer do any underutilized scans on reclaim, but other 
splitters (KSM, vmscan, migration, etc) will still scan the content of 
the memory and do the remapping whether this is on or off.
  >
> For the remaining folios that are not fully mapped, or those
> that were added to deferred_split_list while the toggle was
> on and remain there after it is switched off, allowing
> remapping to zeropfn doesn't seem to violate the toggle's
> intention of preventing fully mapped folios from being added
> to deferred_split_list.
> 
> Anyway, I don't have a strong opinion on this.

I think theres a misunderstanding here, but hopefully the above clears 
it up :) if not just lmk!

Cheers,
-- Nico


> 
> Thanks!
> Barry


