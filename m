Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E03CCD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 06:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 714E66B008A; Tue,  9 Jun 2026 02:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EBD26B008C; Tue,  9 Jun 2026 02:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 628F26B0092; Tue,  9 Jun 2026 02:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 52D3A6B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 02:24:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7E47120453
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:24:11 +0000 (UTC)
X-FDA: 84859384302.08.4C0C053
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 920A81C000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:24:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="bp/VExPX";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780986250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ScfCtB9gJSqjT3aHjMZIF7b9QtPTTVQlfhkDlYe/Ygg=;
	b=O9vCqDtgHovLqBC8bPIMvHVJoWjj502Iv26mXl92Xz+Er0Qm7gBlPDJZAAMQc8BmxURX1u
	sC67o5SEBxKQf9/iRMZBbpxRJrY8plcGc1yFiyQKVUSIFvbwl19TYvc4gtnNMc1QFWmNm6
	yX6N8Skk0QaIT/nB1JnRWPQvl7IxuSc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="bp/VExPX";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780986250;
	b=wySw1+J2wWCysJiHEVwIxpTXKbpQZeq3aOTwikQ5p5Vxs0UPSXA1gX/So8YdQVZI77puhB
	fGQUzMSR8HGgWwbJW3g3nNL9eV+wmd/BK7AXdkCHCakcgMCOeS4A1tyu6DrOkaM3qaw0OK
	I+1otYKyrdXtFrxpMSxCZHl+m4OEhmM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C91E2681;
	Mon,  8 Jun 2026 23:24:03 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 84F203FE49;
	Mon,  8 Jun 2026 23:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780986248; bh=WI1agJF/teXocr4B5URHwywqiMGEjj8CNnx9ZfsdybM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bp/VExPX/M1qIM7wGLdluxnKwB/YC/xUZUj0DqvPv2zi8A4mdjRy92b1+zbQAMRav
	 Mw7+ooj/Sxwhy44NBfOdCIc427QCgxUIOfOB7/7YzI0HssLcBwFx37zPACdRgkw9gi
	 jbV0UvlaCmSwtnsfksLCVYvB+hBEU2r6RnCtb2Yk=
Message-ID: <2cb76a09-6ceb-4e16-95ac-e6a63007cc20@arm.com>
Date: Tue, 9 Jun 2026 11:53:51 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] mm/migrate: rename PAGE_ migration flags to FOLIO_
To: "Garg, Shivank" <shivankg@amd.com>, akpm@linux-foundation.org,
 david@kernel.org
Cc: kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
 rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
 rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
 peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
 stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
 aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-4-shivankg@amd.com>
 <996a1f61-3b59-40ef-9508-ef339cc0c931@arm.com>
 <d80edae4-a29e-4060-81dd-b95b3f945a6f@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <d80edae4-a29e-4060-81dd-b95b3f945a6f@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 920A81C000A
X-Stat-Signature: bfby1iyy3r3yttg4fcgmxtqj7af5rk6a
X-Rspam-User: 
X-HE-Tag: 1780986249-956386
X-HE-Meta: U2FsdGVkX18xo9hXscsnYJLLwEKblctaoueftOL8f1UoHKh0G7OZPBUIbKvMQfbPsOuiVmuw9NRdw07n7AjOkgTeiNogxoG34frts0bKjMt79zNmk7r5TiKPNUrukAvgbwMpYb4SLj7j6YDnRH00kkzrbqS0AVVHsJ31kaHh7GiaApmbBLJ/HBAfNCB3qJagvpSsknAo4MbLuTaGVln2CafvCqJUZ/K2s/ONRt4uE2uwU6yBhGopJm2+Uf3SRtuTlpH4+2B4WqBeZti3WC0HGkZIygexOTz18pL/pROhx/RgZhQwZFMIq3wwsAejzLna3g6j46DBVShTIxDCs7XGwvnagV4/ruCutrxls49OnOvnpvdR93YcJMiOTKhztkf1J8WrldlUStD3QghdhUjPoanQSGxlB2/fjnrtLPs1Y4OXNs53rEwk6GWi77HSNs+fP7Yf9g6SnMC6fibQL5jV6ePq/UgogQaGzpuMchZSsjvMRbkRp7WZiSg/y66nPXIloWRM7YgN/t9ogBZZngy9NijiBU48L2p7ZngvAxk6uBPBb8VGwQ3qtXbD6oeVaq6W8HQYhKGSESL41o0HFa2KpMubY6BYsfU48NPMAhDW0j0Pfpzey0u2qL/1EhEVDSy0XAMZCDyqNyVZWfKDTm+U78DowCMqKAWH+3siUMyvCrbpx8ET+0cMGqoSj7KFfkK6QkerEjicGpLoQw84mTBOH0XMB+6mFUrRNhXCqvefnjWVrvDAhKk1PXji2+ewJjGkH9EA07Ay6xb8b2uOWxCHZfpjFmU4m1cRQD7Klken4E7SBDHEEP3csp5sy4OI+7a0oQN0sjeHNfwtpTmfZz0qZZs0D6ojTNf+Ce6/RHpXxeVgl2KQBAVVDfbZNFpBDWlJHzcJZO4y3/j93QvrZ7KJMRci8P6SsGjI64sKe19fpTQ3hdtIr+rk21MLrjybkVCx9EaTmbhRz/f297INOAQ
 /X9ZHLcB
 2lbJ9UiJSaZUs6r2xu8AdH4kbu5GSsL+du72zQrManM0Owi6XZAMm5gb4iizuvVPZa3wQOiGWzb+6Mqg/OSLW9OZAS4oEMbnXyzVxNzt6B2RKU9gqaLHqk6bONL4OAYpfMdA1qzyEP2smH9q9BwnfL2/g6SFwMZjfBBqzLYqyBTJTYf8ahZG/17Lb3MFQsIZOA8UBQCdpLhXA/TNX05M413IQiX8MeHMxwPtmylKqqc3r55Ou7gAX0rhO5TkH4K8esDsjGzVIqwS2HlIqwEYBrhUQvRn2Qi/g7PoBaSXGVd2PqNhVS3lfHizuYh39523bSdgO9AIIemjMG9spJSvbg2ggNt0R8q8C0prMB2AIdCSVj1ofxUitk7f/nT8xoJZv6r59cJyDnqtgr80vA5KX3lXlXdu2YmYWWTff4kFYlcu14zC54cMhhwoWiOORaEuIxq/jtrcR/QEUoug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/06/26 11:47 am, Garg, Shivank wrote:
> 
> 
> On 6/9/2026 11:04 AM, Dev Jain wrote:
>>
>>
>> On 28/04/26 9:20 pm, Shivank Garg wrote:
>>> These flags only track folio-specific state during migration and are
>>> not used for movable_ops pages. Rename the enum values and the
>>> old_page_state variable to match.
>>>
>>> No functional change.
>>>
>>> Suggested-by: David Hildenbrand <david@kernel.org>
>>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>> ---
>>
>> migrate_folio_undo_src() has a parameter "page_was_mapped", change that
>> too?
>>
>>
> 
> Thanks, Dev. Right.
> 
> This patch is already in mm-stable tree and it's fairly late in this cycle.
> So, not sure if the last minute changes are okay for this?

Oh I didn't realize this is already in. No worries then, it can be sent later
too.

> 
> Given this, I'll leave the timing to the maintainers:
> I can fold this and resend now, or send it early next cycle?
> 
> Best Regards,
> Shivank
> ---
>  mm/migrate.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 0c6a0ab6ecce..fd524f9e6fae 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1157,13 +1157,10 @@ static void __migrate_folio_extract(struct folio *dst,
>  }
>  
>  /* Restore the source folio to the original state upon failure */
> -static void migrate_folio_undo_src(struct folio *src,
> -				   int page_was_mapped,
> -				   struct anon_vma *anon_vma,
> -				   bool locked,
> -				   struct list_head *ret)
> +static void migrate_folio_undo_src(struct folio *src, int folio_was_mapped,
> +		struct anon_vma *anon_vma, bool locked, struct list_head *ret)
>  {
> -	if (page_was_mapped)
> +	if (folio_was_mapped)
>  		remove_migration_ptes(src, src, 0);
>  	/* Drop an anon_vma reference if we took one */
>  	if (anon_vma)


