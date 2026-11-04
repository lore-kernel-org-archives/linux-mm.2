Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D30D606A32C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VYe+QldW
Received: by kanga.kvack.org (Postfix)
	id 157C96B05B1; Wed,  4 Nov 2026 04:08:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131A36B05B2; Wed,  4 Nov 2026 04:08:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F3B6B05B3; Wed,  4 Nov 2026 04:08:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDBB56B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:08:32 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 602051A05A7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:08:32 +0000 (UTC)
X-FDA: 85396860864.22.A438294
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8E4BF100002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:08:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VYe+QldW;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793783310;
	b=Lveo30VHrVWJtECO1Np+f3bgbAFUQwqlEQt/f1giluBZLMjOcSLOdh/IlGGd7uBDv3SZMe
	Fq7ZBL92CyNmy8tbYSWr2lInnn+6xBGs2p44WkwkSQeudXc47nKCGGdAV1aDukX6WDCHDy
	w/6KmHz9sJCyIWvYPOVwNcZgXd2Odg8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VYe+QldW;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793783310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NYn9Sk4oUvq/RMmR/hLYOzDbKipm49pgybfm6AGhmA=;
	b=RFlVFlxtIPcDrtob37xDShYD9Qn9g6guifdEc5XEEBR3e6kx4ns4DzOgkMOEzuMboYf6lS
	A0ZnswlMENPh5NSGQEmUYDHgXfMJfqLlyMxI81kfEmgIP+WsSuspezcX//oIhnnBjYn8Mn
	YhYzYwg3tzcbJZ8EGd4vrjs+QjfxqKU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AEB0E41982;
	Wed,  4 Nov 2026 09:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162751F00A2B;
	Wed,  4 Nov 2026 09:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793783309;
	bh=+NYn9Sk4oUvq/RMmR/hLYOzDbKipm49pgybfm6AGhmA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VYe+QldWWMjvOsvqlc01rzx5B4pDG+f1Cm+nw8Pwbn8EK9cueIlJPWYrx+LxM3Gq/
	 gnnSF1Jl69zzE4NHq7IbZ4y3DIbwnSEtYVmg7P0Wip/ZRlqnVc3CEG4do9h6Fvw0UZ
	 Uz48wStqcn5WtkMTzyATnh9Kj300OWhh+lyS2EkrP3Js1kWclwEy5loXPoOAG5y/jn
	 WbmGxWwZ2gbuTBltl2OzRCY5uPgxjPaQfI4pZMNkckztmGtzcgtGijITFkzjmQWPsm
	 xujdp7OtQSL2W7n+xzvlbHYcEef6D7aBzwP5PhP+885r9+F+ajwGNhCFoHTfeytHWH
	 osB903NfBz1pA==
Message-ID: <52a78290-3e4a-4a87-9bb5-5b0e80cf0be7@kernel.org>
Date: Wed, 4 Nov 2026 10:08:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] mm/memory_hotplug: panic due to race between compaction and
 memory hot-unplug
To: Ketan Kishore <ketan.kishore@oss.qualcomm.com>,
 Wei Yang <richard.weiyang@gmail.com>
Cc: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chen Yu <yu.c.chen@intel.com>,
 Jason Zeng <jason.zeng@intel.com>, Vlastimil Babka <vbabka@kernel.org>
References: <20260903095543.3752338-1-yuan1.liu@intel.com>
 <1d625a60-9473-4f48-a384-7d756ccb7135@kernel.org>
 <20260910031609.qbn2qcxzbitau5xc@master>
 <12147238-575e-49ea-aa83-ea25c660ee38@kernel.org>
 <ae386ef8-324c-4704-bc0f-a1eca3280399@oss.qualcomm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ae386ef8-324c-4704-bc0f-a1eca3280399@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iyq1hoppyn1b8oshs1omua4zw3utz5xg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8E4BF100002
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793783310-990258
X-HE-Meta: U2FsdGVkX18owiZWexdzRAQ88D48e83pj+q2HphcJAH8jfvNY0Kwklag9Yq/cmcFRydvjbwVPVaKan7+bYPIGX1j6Xyy8sllWxjAU5dfkJI/BFQ7oupbeofBvN2VNLHTfaISm6VdMpsJWuHLC+YLSVQ6o8h4CHjBrGExFulpbygDgZ+wyUXfQDjMqO9qiOAO9+FYIBoCdRHwV7aZlCNfU1qhVfinohvjcpfWWb6YVgO3rCx1DjaHx8/8j6hnVXrMTiVn5iD3OP/Be56L66CbBq6zGn26kFHxB/AcI544gCgs+exs/jz3oUwZK8A6f7rxoEW7d4/lGRhjh1SvVNaEnQKeGg8oRzxoldnqbweamwvEwW7mlcyRQbODWY1tnHbkI6tc8ym88/GVd+xx/W36aj6wPKSFsqc8Fq2cWaTjNNoYL9MegcJjLw3t94EL8DkID5YJCwWamy45AU71nVKuFBDwBMudGObd/VEm6phqRIPoxRRSheH5wavdziDCDkU1pSQpouSfCYXQLtzx4Pxnv+6q1R2vIo9tGNMsd3bwo60NTz2/n8LU57MXBK0+GzPiul43QAr638zKW52zo8/bPl7wj7rxCiLtS6ts0IFUNnRH1lS7z00B/wzvVNPYTuuXWD2gdOi+PfaFab7X9AyuTKRdGjE+defN8+GROh83AOKWeAFmhl3K5w2wp1wFQ0iQCNFyqwD2CKPz37LOXUx2nAxRx9BGcHWI/OlY11oQaqO8fuwJ7oS9/4xck3XV0f3Ppg978ybRu/ot7FwnAlYsB86Cv2mYPWzN1qPTlOpfB1KD+zV77Vj+nLJGYtMnnTJ0WfhKAOs2FHyaaWbUqStc8FcqfUp/c3S0k3jwpEzvj/eEeahoRyOk/eHB8oefGqhCurqCIgR/eo0m4I4Ua2zqDwcwcn+eVm0tC3TjHAGrQxpFHl268TDEA2bcBp3c2u03OQakHpcPxXUitJ4fF8A
 HavrSU7j
 FX7DgN2ZCQ9T4yUeP0hyjg/UITJ5sEVkkPoK1Mcuyumj/gNAkz2NsSrq4FU7C++1z6ccOvT+EfoxzM9gUpS+FHMFwPsYEpAwfr3uHWSa9JmCb9co9RkSHpKh9JvRvAacW9FY/2yuWlJ38PjgNcPIRfMJ46vt232dEY7wrZBOHPXH7Ux1xocd7VXPEgoFsD9RZNyRcL7BhCojnw70+lzjyqcrxag4sACcPWfbl2WknP5rw4JFWi6QNM3AqJNDiBf7h/XI7S2cs5Gq93Mh09u0/d0pGH9ojfSTeuJMf1SlVCrjOKpe8rK+0sJYNCY4oU/hHrOou7phXOx109S4+VK8Aox8cCzwXynC+LH+3w85pWDkSFuca9pqVtG+JAfqIjIMCEFsFS80e8z/MSBpsXaFYjXOYRWZWpvl99x+2BybeVg88LzVHN37cGJmO6wFBSqnG/splbPL2jzNFez1mr6ZIKtIiLSAYdwMN5yQLOIAVwAnVd8oTso+9mh5M6vo5okx50wgbaxv2vfW9fHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 06:18, Ketan Kishore wrote:
> 
> 
> On 9/10/2026 1:10 PM, David Hildenbrand (Arm) wrote:
>> On 9/10/26 05:16, Wei Yang wrote:
>>>
>>> Does it mean, the combination of pfn_to_online_page() / PageBuddy(page) is not
>>> safe, when there is hot-remove, even for other users. Not only compaction.
>>
>> There is an inherent race between any
>>
>> pfn_to_online_page() user that then takes a look at the memmap (PageBuddy,
>> whatever).
>>
>> Usually, that's not really relevant, because for things to go terrible wrong
>> (instead of only being slightly suboptimal :) )
>>
>> You have to run both, memory offlining *and* memory removal.
>>
> 
> Hello
> 
> We faced similar issue internally on one of our target's guest VM run,
> where kcompactd de-referenced a vmemmap pointer for a PFN after the hot-unplug
> path had already freed that vmemmap,with no lock preventing the two from running
> simultaneously.
> Call trace:
>   suitable_migration_target+0x0/0x8c (P)
>   migrate_pages_batch+0x1b4/0xc74
>   migrate_pages+0x150/0x654
>   compact_zone+0x5bc/0xb30
>   compact_node+0xa0/0x18c
>   kcompactd+0x228/0x4d0
> 
> Would it be okay to introduce something like "try_get_online_mems" as shown
> below to try a readlock in compaction path for hot-unplug to wait
> for kcompactd to complete before freeing the vmemmap?


Likely not what we want :)

Gregory started working on some fixes:

https://lore.kernel.org/r/20261027042204.3741307-1-gourry@gourry.net

They need more discussions. They are a little bit low priority as we are
fighting bigger fires ...


-- 
Cheers,

David

