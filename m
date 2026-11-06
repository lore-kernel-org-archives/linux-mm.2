Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C73C0606A33C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CcQjhvE3
Received: by kanga.kvack.org (Postfix)
	id D61BC6B05B4; Fri,  6 Nov 2026 17:42:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13336B05B5; Fri,  6 Nov 2026 17:42:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C042A6B05B6; Fri,  6 Nov 2026 17:42:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC6F6B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:42:36 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0D207A01D3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:42:33 +0000 (UTC)
X-FDA: 85406169786.11.223F525
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2C1268000B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:42:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CcQjhvE3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794004951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9kJmn9kMaUsIxseYi41rabItJ7bLsBpd/nnhZbIok0=;
	b=IWT6yLwyBet6pwF8FuRlSLDSHzHwP2TGyNoAxNuTfdO4/gAUs2ZxbO80ZC0+Lgn3m8qpM0
	F2CIP9RdEnSJGd0PqMUT+tX/h3o1TFkOuZhPrNVTa16dLAwxhgy1BptovzfH+4DxZwQpGN
	e6MyT8UfD7crwhgJ6i5viu5KpOUl1xg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CcQjhvE3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794004951;
	b=PbhSQBf1vHqSPcrgMlavfE96hwGhgrcJq6/H6nBukbP4Jyb4g1nJurfPTyrvTWZzEqEAwC
	IZlcTSl2EsYN8fBVojhSmB7RwggL5tSybC16KtJdhPuxMyc2E1w2tmfPuPgafBHlDqDXZd
	I9iINgqpHYevbhPOo6C0aFSdmqC5i4I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A4AEC601BF;
	Fri,  6 Nov 2026 22:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461341F0089F;
	Fri,  6 Nov 2026 22:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794004950;
	bh=r9kJmn9kMaUsIxseYi41rabItJ7bLsBpd/nnhZbIok0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CcQjhvE3LihkZTfRpe4GaGxaNniXCyBTPnv6vcJX3sBVZApH/MsbvbydsSZ81zFxR
	 NSKD4z99+2BdoVaotgWuzYmPU8/Er/qPZuRp+cR9arHo9nWwaJZsFTQfzKjEiuudWe
	 GfkE+8H9wzKx47fQqMgmGvK5vqVukLysoqIE04NdjiWlapD5RSVtbBjw220dY6v/XR
	 2S0LJ0WX1+Re7Cb9Gp4E1HSpQnf+y3V6McY5i1ZNbYXDBfYl2js6+Ip5zOiSar4N8O
	 X7W9UXU9bMPkJA1+c2nsq9IZoYHe8ZCDYLfGNeNFjembLaMhHYk4LCktt1+0S25TrV
	 d13VE0RJJZy0Q==
Message-ID: <20e54cbc-dd5b-4094-856f-2e63f8e19001@kernel.org>
Date: Fri, 6 Nov 2026 22:23:26 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] mm: limit pagecache folio refcount when mapping pages
To: Lance Yang <lance.yang@linux.dev>, azpijr@gmail.com
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 willy@infradead.org, jack@suse.cz, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 peterx@redhat.com, hannes@cmpxchg.org, songliubraving@fb.com,
 riel@surriel.com, hughd@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
 jgg@ziepe.ca, kevin.tian@intel.com, joro@8bytes.org, robin.murphy@arm.com,
 steven.sistare@oracle.com, jhubbard@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, iommu@lists.linux.dev, mason@kernel.org,
 stable@vger.kernel.org
References: <528e3a0e-04fb-427f-88c7-63a7f4bbc505@gmail.com>
 <20261106100645.77296-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261106100645.77296-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2C1268000B
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: j3pqkrfcd5zwg8kbayc7pmamnfhgj8cx
X-HE-Tag: 1794004951-663289
X-HE-Meta: U2FsdGVkX18nERhgl1AWRmjvlqnMoMTHW3IRuermM8LKziL0JfuxjlGX66S/4BXYHyGwBshSgaEy01iwnZgXc5r7qAzozwMzs0QGiokxbJuhZiIHAPBWr5g6/pJq0oMKc205fdbFA2CXIgUdc9m8ZqwV0/n2i6NB6QGsBW1eUXQSEtfx/KnknOIlopuJT8XGTmqSMIOTOK8QE0PJBFLcBw9hkJDmziYkjbYKSEEyYGprAxDrsW/bpS23qXIRwGwNM4ob9+EXTQI3/8hCZYShjp+4jiiA8bzQ39EPFDmincjbqsSFRjmNZqgPJAUk/xccEC9S15vDWw7aII6vyzebrJu1sA7pMi6WFkJ/EB6qETreApYwDsWUyEA07FwQJwTt1O6dZhms3XYqLaDi5yEQJFuqq6QUt21jFZ8oAKHRqawgKVqU8Q02/5rUl3YoCciVYrA7C+7zLp7XfzktXvyMPFxwl6DaS6DOaXr0TJ5K29UbzSggSrv3dOX7p5YPHZ/lghiuMsZwYTBC8p5cM/zlYR409ye0nMRmcqmxOoRqRdw8EWSEgkthdvzEwyrhQESfwFvXWBKAqBBeRnXBEyGOQtuyyIR52Dgdm++VKudm3kqedTTnAJL9QwE9TbxKBWvmGeyXFYJJ3YBtfHjyNxhNeYZ8mW1CMuYbaqjJCAmjlKEfRtVfRLPtZHt2UzBc0qE5F6GTJ6sTTiT/1bM48nu917wvuWYPUQJmEG4fULYl6tTccMciYCMNhFB2F1GrnbNCybnbHtGdQJZf0nrIowTilEJT91JAMHYxeL+NIQXNiDPcsQVo5HZMy4pyp9lpE1W25CsM5ESBE9uAeU/oDJaoWekaumSrxNGU0wFnjcIqJ3gdyeghnUQ5otW2W/iV4PlW32lFJrHCP1HuM4ogyskgfjvUTBYLjCpG/vv6P+2WP2lKKgzbppjwliPH+Kd6tzk03iwIoPQloscU6UEIfkO
 NOULExD0
 P2km7axhmkrBYww+HF0DkNEX5jNtVT734QIJGs3fz9sAB3CvXWw/LWzeSoPGI2kR+l/H6du41kJIlB8rvWTQ7scrpsgHqopAxzio7Ch1+7XcVOeDcbD47zyPEDuHqNVRJUWLu00KR5LOB+BA67iouWNDIJ46VPRiSQtoZQQDnSop5Z2AEx1XZf7EhYpXJDtCyhS0MOXRb4L5h5j7RSWMYU52Jqg8U4Or83enM2S23naskKK+NMOcbhqyyXdzFSwkzxdpGTuut4smbqRTmIxEtfAGPxCzCxVH+tGPu7sWfbi/L6utIX2uJsISbZppPFC3yqAIVTteHWglXM34=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 11:06, Lance Yang wrote:
> 
> On Fri, Nov 06, 2026 at 10:42:17AM +0100, Jose A. Perez de Azpillaga wrote:
>> On 11/5/26 2:10 PM, David Hildenbrand (Arm) wrote:
>>> With large file folios, overflowing the folio mapcount and refcount
>>> became possible. For anon folios it is currently not really an issue:
>>> each large anon folio can only be mapped once into a process.
>>>
>>> That's not really big news, but it's about time that we do something
>>> about it because some modern technology might find ways to abuse it :)
>>>
>>> One of the enablers for that was commit ddc58f27f9ee ("mm: drop tail page
>>> refcounting"), however, file thp support was added later.
>>>
>>> File folios can be mapped multiple times into the same process, allowing
>>> for processes to hold many references to the same folio.
>>>
>>> As a short-term solution, let's introduce two folio refcount limits:
>>> one for ordinary consumers and one for admins. Leave some headroom
>>> before the refcount goes negative, which we really don't want (having
>>> the mapcount go negative is also not expected).
>>>
>>> Start reporting SIGBUS if we run into limits. When restoring mappings
>>> from migration entries, instead zap the pte/pmd entry. We allow for
>>> slightly exceeding the limit to keep things simpler.
>>>
>>> This is far from ideal, but better than all easy alternatives we can
>>> backport comfortably. For now it fixes the big problem: letting
>>> the refcount (+mapcount) go negative and cause trouble.
>>>
>>> This is only a temporary fix, we'll follow up with something better.
>>>
>>> While the refcount checks are not required for order 0 folios, let's
>>> just add them for consistency: each folio_add_file_rmap*() and
>>> folio_dup_file_rmap*() needs a prior check.
>> in mm-new copy_huge_pmd() now does a folio_dup_file_rmap_pmd() at fork,
>> since Konstantin's "mm/huge_memory: copy file THPs at fork like
>> copy_present_ptes() does". doesn't that one need the check too?
> 
> Ah, good catch! My local tree didn't have Konstantin's series [1] yet. And
> right, that path needs a check too I guess :)

So, likely my series will go in first, it fixes a way older problem. I'll tell
Andrew to hold that one off and let me handle it.

-- 
Cheers,

David

