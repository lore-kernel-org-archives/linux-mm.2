Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 428C3606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 12:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J5hXer1y
Received: by kanga.kvack.org (Postfix)
	id 4F5D46B05B8; Mon, 26 Oct 2026 08:12:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CCB66B05B9; Mon, 26 Oct 2026 08:12:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3336B05BA; Mon, 26 Oct 2026 08:12:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0BB6B05B8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:12:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81AD9C06EC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:12:37 +0000 (UTC)
X-FDA: 85364665554.07.2E65EF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B339D1C0003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:12:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J5hXer1y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793016755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sCtZvtAR22Ami4S2eIk3HMfDGlAC6il3qa+TGty4veQ=;
	b=PAzWBopS3JknT2ow1vUSreBZVoMcCV3geOzO/1lri6++PCzb2CK/K67f9IjbxPvuX+qZNK
	ydV+YREU+XQGN2lxQczRu+YzvbyEoZEx2mbzeVTAvJZuyIkNZHgGunyHmPFZeIc7GAMOaG
	ZNbQBWwi7dpTVsMuuxF1QA54FxXcmxs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J5hXer1y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793016755;
	b=IWobfIOmvTmWuubByW+vRIr/fZPoxuCnYMXvrH4QSjEr6VklBBSuJHxnIz6DQLj5O4jx3q
	krWQ1300rquEwnRMSNG1BqfXWq4TiWKS0upnTPc3qRLhG5no84bEUe42pkSHS6IfLMEYfw
	NqX4lB/gv6vYvK041d76CIFE7grd0EQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F379943D4A;
	Mon, 26 Oct 2026 12:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF3B1F01825;
	Mon, 26 Oct 2026 12:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793016754;
	bh=sCtZvtAR22Ami4S2eIk3HMfDGlAC6il3qa+TGty4veQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=J5hXer1yoooeUjppZ6vg8NVJpK4TPTZVdh9mBwO8PTZfOuoo4QYTexYN5v+PEzfkn
	 +TkbN4+MdUGit7k3nxjDNTPx8XlLTmXCOWgk0q2jT0c6clk4Y+U204lwBOg4QpKeTb
	 2GrghX99FnCH1TA4q2dZ42c0kJQsGRxKR+N71jDq5SPhPn2abEnXgHtfFFbV3dCGpJ
	 ZQby89YbBNK/CL7OkyiRCB9dXnyaZV7aCgMFQmE7ikIFxWmT3ZBZCV6pY1hl3k8x4B
	 +VChZ6FM7OBEfqPxPtdnRfDXLcbT3EA2eUVGeSOVcQT4WGvNP89jipV5fpMMyTiwEe
	 6vW1Y4+W21ACA==
Message-ID: <1398e842-db91-4482-949a-e21197a48b9c@kernel.org>
Date: Mon, 26 Oct 2026 13:12:02 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/16] mm/shmem: various (urgent?) fixes
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Gregory Price
 <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>,
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <a8f01101-7d7d-4982-9cf8-04b754ba132a@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <a8f01101-7d7d-4982-9cf8-04b754ba132a@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B339D1C0003
X-Stat-Signature: d9ktig6cjbfc3t76xunahjtjuoow9sok
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793016755-157899
X-HE-Meta: U2FsdGVkX1/5FcyEBX4/riVNR6TMlT3rRmJUIdzA/AV7QjXalcBbwgSgRNvEtNgDeA3ixOJI3n9ehsxmKv1Pz3R8lNNmmnMmVwhm3Wz785UYG9sUVeWhPm5eQZMHALGAeBzAQLkdbSsm9YrCobDa+PwSmGFfu+qw3Nj8rm0afoN7WOicOUtfzW8uTP/j9w5UMteFYNfmE+U3zq3WBejePx/ktGhxX8OZA02kEvzFPEcwj5jw7C60cqLsslVHAkbF1Jas+povXVYmL8mhMbG4tjTDCuuccZsVdt9nh5hq1LldxtWkSFvFRUNIzQjPbnPmn9aKvUw+NVkc2avvb0CgjYIpiBfNASpUOwTnsLE4JVkjVoZzYaUyFuIe9wNByh1dX+S3iD1FFi79eoGVmH+NdZhvUQpLNG1JPAGpvkMuQ4l57SgZSGpl9/aFpRvsb0OQPWm8wDQgKKvqOPOj5NPQr1u7+05zL08yzboOCmmm1QlM5+PKZeGh7MhmyVrXIT5d0iws0P0vAxnub2QYfiwNWSksahFB7TbGAyRISmYC/aRhCpOeeS4coE+g43yEYHN5shOOkVaDHru23BRldRYqWZ5FGM89spgY7aXVi3KVViSanwiGYk/ZbwYYLmOQLH3PrnsxW4d/cQ6zoWKPjQV+Ka3uc7c0nnRG3XI51B2YuWIR5BSgUZwfD8ECVyvIO3RkjlLgMzgoSlonSwBYCVTmJrsSn+edVBE5aQuC1WNKSUJHaKvqXCIv9UjC1QPRt2AZW3tGUUL8AxrK0KziOjwzFRUR6tJ7cpf1Vpn1xfZsrwMll2PWW7/09vXbQzZTQ1G/Xbs8fpuD/zDR5+pItRk0WRQoWdKNvVzls6r6OQFtfXdE7nZ5BvUKRTxk23c3DeDgGjcJqskH4awmWGFG9A0vrbM1p5QHnC+/nMiCG33HquUFURDYPQeCmdzCZ3Ig3w77xrpLwmzCFx9OWX/Xqeg
 dTWywDFx
 Gn9GyRmWk6OakfGWa/zcNAIlZa1xteASVPrNGsZDaFBilCx1l5DSVeqzP7awHZam6uXU7NZ3Y2s/7iv/adIHvYaJ+ovdAxb1rsCmx7yuW/S9mvxi5n4AL/oOjYk+BwLPLVUpCtfWV5Diz2GFnowGVsnzeGf3xHX/FTcFwFQqspV6ero2KpTV7QT8AG1/Whwvura+1tn9HjU2Hc6IOcT3YHCMaWSiO3CtFt/qw++DW6YA9aLWywdPGtJjXE7W2vPMNihNn+sqzDmMjoLSgNgrrcIuKzUDXYYqtDNInoc5dTuYacYggtq+jJmdhtq5ZXP8iYHGAMpRQQrxkM6z7IbVvUYMnONXGHc3/+1WadcMeh4HpB7ATiyn1WWoqo3RDffemuWAaIf4cMadnXbQ+qFpFSsUQMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 12:11, Baolin Wang wrote:
> 
> 
> On 10/26/26 5:40 PM, David Hildenbrand (Arm) wrote:
>> Hi,
>>
>> the fixing fun continues.
>>
>> This is a handful of fixes for shmem/tmpfs. I sneaked in a related
>> hugetlb fix that stalled upstream.
> 
> Wow, thanks David!
> 
>> Some of the stuff is more urgent (patch #1, F_SEAL_EXEC, truncation
>> hangs), others are less urgent but still rather unpleasant.
>>
>> The majority are fixes from Anthropic that I cleaned up or reworked.
>> While doing that, I found a bunch of other issues and tried to fix them
>> somewhat cleanly.
>>
>> In general, shmem + swap handling is a nightmare. shmem_undo_range() is
>> such utter garbage it makes me want to cry. I mean, really, WTF did we
>> end up creating there. Does any expert here have time to clean that up and
>> make it *actually* maintainable.
> 
> Agree. :) I'll re-read shmem_undo_range() and take a close look at the issues
> you raised, and see if I can make shmem_undo_range() more readable.
> 
>> The following things are still broken in shmem_undo_range():
>>
>> (1) Truncate/punch of a single page of a large swap-error marker
>>
>> We don't split. Consequently, read access afterwards will still fail
>> instead of returning 0s.
>>
>> I have a fix to try to split (which can fail), but I don't consider it
>> that urgent, really. So I'm not including it. Might send it later
>> separately.
>>
>> Truncate/punch of a partial page can obviously never do the right thing,
>> as we cannot poison parts of pages ...
>>
>> (2) Truncate/punch whole pages within part of a large swap entry
>>
>> We try to read the entry, but if we are out of memory that might fail.
>> Consequently, we will not free up swap space and a re-read will not give
>> us 0s but the previous content.
>>
>> AI proposed a nasty NOFAIL patch which has too many nasty side effects
>> IMHO (allowing users to force-read pages and retain them afterwards even
>> though memory.max would disallow it). This needs a proper thought. Likely,
>> support for splitting large swap entries (and large folios in the
>> swapcache, which I recall is under development  by Kairui). But splitting
>> can fail ...
>>
>> (3) Truncate/punch of a part of a base-page swap entry
>>
>> We obviously have to read the page in, in order to 0-out the parts to
>> discard. That might obviously fail.
>>
>> Maybe we should install swapin-error markers if swapping during
>> truncate/punchhole fails, to at least tell user space on later access
>> that something went wrong? We might affect unrelated data, outside the
>> requested range, though. Anyhow, these are long standing issues and
>> I don't consider them urgent.
>>
>> They need a proper solution.
>>
>> I did my best trying to test these fixes. I was able to reproduce some
>> of the things (including unkillable truncation hangs), and the fixes seemed
>> to help.
>>
>> But again, shmem_undo_range() is just an absolute mess.
>>
>> Please prioritize review of these fixes, I want to get fixes for the
>> issues in a timely manner upstream.
> 
> OK. Will review and test this serires this week.

Thanks!

If there are better simple fixes, please do suggest them. Any bigger cleanups
ideally come on top.

BTW, the next time I get a flood of these patches, would you be willing to do
the early screening+revise? But be careful, some of them are pretty, pretty awful :)

-- 
Cheers,

David

