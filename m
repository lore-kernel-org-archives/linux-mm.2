Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01C28C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 02:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE0A6B02DD; Thu, 13 Aug 2026 22:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6B36B02DF; Thu, 13 Aug 2026 22:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBC6A6B02E1; Thu, 13 Aug 2026 22:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A4A776B02DD
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:25:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95BFA1201B6
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:25:39 +0000 (UTC)
X-FDA: 85098283998.30.B3F9BD1
Received: from mta0.migadu.com (out-163.mta0.migadu.com [91.218.175.163])
	by imf08.hostedemail.com (Postfix) with ESMTP id 99880160003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:25:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h0ZEm4gs;
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.163 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786674337;
	b=rpbJnhiEua/n7PdnYAvIDRQ+pywo3R7BDuGxDQpkps4Vz5Hg1DNvOZxVtVbYSHV0t+Dwqz
	B8f+leR2+niKI1cI4skhb08bjkw8UddhgSXYBE8m+ttwIrFUmoG1oCIEQvW0CPW+R5XGWs
	fPVHQgP+KWqo4BmzzZX2wxz12sXQaPA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h0ZEm4gs;
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.163 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786674337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H/D1HP5XDpK1D64pbuWTBmEu5A9T9P1kMiv6NarRSTo=;
	b=dn44azWx1wyCHjPEFwYMl6cWXIAoOBKpvJfFOrGejU4A0BdD/pD/GfU67rFPDDmvFFNf50
	vIGx1fYPXN/7Mf6nrc3k1JNE3YVlfiIWiajynXFN7vn935tSlxhRL0CMLX8ztQSDZst2eP
	Y/klRWabZo+F8U2ezboLRFZ/jDXwyAU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5zVwaIiED/lldV1BAfSynde5Phrd17ahcbOlsOuj4XM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786674336; v=1; x=1787279136;
 b=h0ZEm4gsoqsoGhGG6E9HCvBkjOWTJok+wfj8w1/WjcxHjuubTMdNR1rYt5V6RZ8M6NNXoHHZ
 HwmgXCeZ+LebfzG0ZSwKg9MYIlaDMbWwaybEWHz2H9VKBv9OM/Rnxn7BoyUt8ul7SFjFMcK2sU6
 nTCF1gVX47QG3V3aMH7imLH0=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.123.245] (14.29.108.90)
	by smtp.migadu.com with ESMTPS id 736a32a2e0ccae00;
	Fri, 14 Aug 2026 02:25:35 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <3c487b6d-c510-473f-b708-0fc699a23459@linux.dev>
Date: Fri, 14 Aug 2026 10:25:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] memcg: acquire peaks_lock when reading memory.peak
To: Muchun Song <muchun.song@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
 David Finkel <davidf@vimeo.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>, Ridong Chen <chenridong@xiaomi.com>
References: <20260814012924.2388613-1-ridong.chen@linux.dev>
 <20260814012924.2388613-2-ridong.chen@linux.dev>
 <811C3A33-6B05-40D5-8448-19D5BE882A83@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <811C3A33-6B05-40D5-8448-19D5BE882A83@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 99880160003
X-Rspam-User: 
X-Stat-Signature: g1bzc59jpacn3wgj8cfqojdkbe6aoie6
X-Rspamd-Server: rspam06
X-HE-Tag: 1786674337-475792
X-HE-Meta: U2FsdGVkX1+fqBHRFS+SCcrR0zOopM8Jn1/Xng97Cn0BNJqDZdyomp0zLpPGSt7x5fuQZtfxTOwqdJszlIjOLApptT/DLweuvnMs1VTXYQA8O4YJ83qrfZYvx9U3Z669O9/vioT/GlpDDspmP024Tkpy5CF4J9qB0xCCstoEGHapiXnLFOHA2Hpic3Wk5N/5MahduMn6CV452pZhi6jZp8Enqvm7b+KNDr9DJCBZ4m6B7Gmgeq+2pr2sp52TmcxV2HnP04i4U+DEVJa/Ub1ND9xiTfDYHTxDYVr0LfdPRMi9Zgc6k9DHDJ8ziSFRZmAg+1xrmIGStIMyVDOHfRbVOH83Dem2MD61R8Zpawpa2AssO/95m8ZLHAYa8CqKomRhsFYmIz74Bzo250/RmVCFRNpp/O11dtzYbvCRQJKQbGXcz3p0Nx3GF4hAyuBSMkfm8YAYwcZcAi5dpGsrZM8OwufQuhitEUJNXXgX0tHg9r4bE85HjdzGZ0MWP1HSkW7TJIvi35LvDCX8zcw9qhjUkqbqFiH564B2Y2eYADi6kepnU8TC4bNfazCo0kF48F3DPmJfZvVSuPRm1VvVbVV0VO6lAQhzzRxk7XCdGAgwdl0xa+GuNJYVaIYD3/ayH6sTszIX5f8V6eRCi2QqscHGxAfmjnrmgI/GhAiOFfJ5/QDliNWGIujyZf13u6gf018p/JeOF2mjVyeolfoB4/Oy9fL4l0Wn7p3mpBnXBt06VjvPRUuNUOsBjrZ8GFdiPqUdOnSMg+VYI+cHjAVYnRGpNp3Prnx3PjuFHjUSkvJSXGdYGwXYzIQxN7b2JH5tBPbvjUGJhc8k3i+PXjqqQu4XYKUQfZX4lKTzKD7XLLR7x001oMIjV2w7yGq69jzzPBcSajFPNcTmRQzN3+pjvgwo9S3LqbkzPmxaYW5xjna7EPwNGSwmzosDJdXWkrj6Hk9IZWDO6Kw9u+5hNsCrPlR
 5b1Djrlm
 haQH2GiHNwDRGnxKm6bxzP0KkiBRDidXnRo9/USfHeEGxE6jOIh66ebwUBPjOkA8vmD97MqXiVYW2QfWbA2mL1gQptzn/qfHr+hnX+CjPS6s/tfsFPSbKUOSvwsdxh8m/awMvGjAy9aHmOr96hQOpvSVdy7KQCt8YuRTITifcmY1IPwCkLmy5Em5lPtNhoABRcfwbMgy7SXUaHDPqdt9+OKYAOUQAOy1HF2x2v5BfTOqO6G4l5uRsgreVC0eNJH8LKJgn1edUNla6Db34V9xK9g6vYX3dGvPVUd3AvlY1mtfgUeGqe6R+1Jwce3JZxviQYysPMzGlU5rUCTOVb6ABNNRC/OLrzuXLLwPccNBwZ+JVx1k+Ue70K6PFw7L9KhjwNngDngWW1gSHsvMX0R6nWo0g50SgC3DwtshUhUam8JZoSmdDp+QDF3BKmH3kiCAebFprZ/qOh1Z6r4vTFuwUMCBLrj/t8YGsEuhAzMiQzm2d34I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/14/2026 10:12 AM, Muchun Song wrote:
> 
> 
>> On Aug 14, 2026, at 09:29, Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Sashiko reported that a reader can transiently observe a lower peak
>> within a race window [1]. peak_show() returns
>> max(local_watermark, ofp->value), but peak_write() updates those two
>> under peaks_lock while the reader takes no lock. The interleaving is:
>>
>>   writer (reset on fd A)                 reader (fd B)
>>   ----------------------                 -------------
>>   usage = page_counter_read(pc)
>>   WRITE_ONCE(local_watermark, usage)
>>   // watermark lowered to usage
>>                                          lw  = READ_ONCE(local_watermark)
>>                                          // sees the lowered usage
>>                                          val = READ_ONCE(ofp->value)
>>                                          // B's value not updated yet
>>                                          return max(lw, val)
>>                                          // both low -> low peak
>>   WRITE_ONCE(peer_ctx->value, usage)
>>   // B updated, but too late
>>
>> Fix it by acquiring peaks_lock when reading the peak, so the reader sees
>> a consistent snapshot of local_watermark and the per-fd values. The same
>> race applies to memory.swap.peak, which shares peaks_lock and the
>> peak_write() path, so take the lock there as well.
>>
>> [1] https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.dev?part=1
>> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>> ---
>> mm/memcontrol.c | 14 ++++++++++++--
>> 1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 17da1f43b7d3..6dd8756870ff 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4713,8 +4713,13 @@ static int peak_show(struct seq_file *sf, void *v, struct page_counter *pc)
>> static int memory_peak_show(struct seq_file *sf, void *v)
>> {
>> 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
>> + 	int ret;
>>
>> - 	return peak_show(sf, v, &memcg->memory);
>> + 	spin_lock(&memcg->peaks_lock);
> 
> Why not to use guard(spinlock)(&memcg->peaks_lock) to simplify the code.
> 
> Muchun,
> Thanks.
> 

Good idea. Will update.

>> + 	ret = peak_show(sf, v, &memcg->memory);
>> + 	spin_unlock(&memcg->peaks_lock);
>> +
>> + 	return ret;
>> }
>>
>> static int peak_open(struct kernfs_open_file *of)
>> @@ -5858,8 +5863,13 @@ static u64 swap_current_read(struct cgroup_subsys_state *css,
>> static int swap_peak_show(struct seq_file *sf, void *v)
>> {
>> 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
>> + 	int ret;
>>
>> - 	return peak_show(sf, v, &memcg->swap);
>> + 	spin_lock(&memcg->peaks_lock);
>> + 	ret = peak_show(sf, v, &memcg->swap);
>> + 	spin_unlock(&memcg->peaks_lock);
>> +
>> + 	return ret;
>> }
>>
>> static ssize_t swap_peak_write(struct kernfs_open_file *of, char *buf,
>> -- 
>> 2.34.1
>>
> 

-- 
Best regards
Ridong


