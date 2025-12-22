Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C1C5E6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 10:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C6A66B0088; Mon, 22 Dec 2025 05:54:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674376B0089; Mon, 22 Dec 2025 05:54:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5525B6B008A; Mon, 22 Dec 2025 05:54:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40B606B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:54:56 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D950A140A72
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:54:55 +0000 (UTC)
X-FDA: 84246799350.11.DD63D25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0D49B100007
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:54:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TBbcOWnS;
	spf=pass (imf05.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766400894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=via50+UU3zwF3j2NucBXqocVM1I/vn9/qh/wjIgtrmM=;
	b=vh3jsRqa8vMDXeFumXRzP9Z6d+AS1aZ+Y0UbZ04CbUcUXBLZ7u7opREx6juWVB8Rl/ONfW
	jbJqKZQu5vy1fJHm4Y4UPJAEcUve1D2CcDGj/85jy+briscvvvpW1MK2v1iwIRKh/eOb/K
	kfWTOO/i+DrBjTHxN5yq0rshfDGoa2w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TBbcOWnS;
	spf=pass (imf05.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766400894; a=rsa-sha256;
	cv=none;
	b=Wg6lvRyWP1+8kRjpLn5mExd6Y94cAndV67nfdoBqN1UWhFLnMQ6Irz/9T7gewXVo8Y441m
	Mutil13bNW3EpkJR41HlYzbrCAmDKDGTnzuIz+dM3iYwF3kv7lswQlgxAI7Zwa6EXW3Wz4
	ORjbK8KgnVtyYIyEG8MYSZtbnajorGs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0811B42E47;
	Mon, 22 Dec 2025 10:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6255C4CEF1;
	Mon, 22 Dec 2025 10:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766400892;
	bh=cv/VTMXLxul+HjudSJW7wkMxfJdfBr+el6AQMlItv9w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TBbcOWnSr19MwF0MKrCb2IoabYD0Nb+Hare+gEpTLzqusRx2+g7sBBoVWN7mXfVuZ
	 9g48PR844JLrnIVBXNJDcPRzZ9OqZquI7XiHNGeRwHRykZYpEycTOUpmGN0z4nW/2x
	 exNm6rPf3N4LEfbJUmfd492tMzcaecLPdXqfDuC4XviG8bw0zrKfc340q+uV2v7A31
	 tSGddRTWmUAG4XhmWs/NugkfoosrV9ks7Kz30Zoom9Se8/nzViTi1v4hjixSRy25gU
	 EU0bg8YbcDJPHiMekaav/bto5jUZ768ihhxepiBF9REEAyupmmRO5IMAzEtlO7J7ps
	 8hPuYpgjOVq+g==
Message-ID: <e97c41cd-44f7-4560-bc75-79283a438e91@kernel.org>
Date: Mon, 22 Dec 2025 11:54:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] mm/hugetlb: ignore hugepage kernel args if hugepages
 are unsupported
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Sourabh Jain <sourabhjain@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Heiko Carstens <hca@linux.ibm.com>,
 Ingo Molnar <mingo@redhat.com>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
 Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, x86@kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20251221053611.441251-1-sourabhjain@linux.ibm.com>
 <87a4zcml36.ritesh.list@gmail.com>
 <655cc605-2ce1-4ccb-8cc0-a0a31a9c89fd@kernel.org>
 <87fr93ky5i.ritesh.list@gmail.com>
 <16fef7a5-6853-4a6f-8d27-e005fa351eb7@linux.ibm.com>
 <051628be-ed70-4a56-8704-f2b8cdea1984@kernel.org>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <051628be-ed70-4a56-8704-f2b8cdea1984@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: bcdss1dyoq5gbmn6x46d35bciuohd97d
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D49B100007
X-HE-Tag: 1766400893-758892
X-HE-Meta: U2FsdGVkX18SglD9b3W9GMh/qO6+u3m6u8JVQiOJePXRIG3f1xJgLXWDkcOSPb95EIdoXixsYXEXYI1xnwwUWPLYKmENeUFlWSiIWlAogawJbu3B/Iqpb7fiULP3rvR2aU6AUz+4PbG4J2IYJrin0Y38NAwSsfiqdDk1+vjohjEvY+GPsSYjiFKxUnRloEQdzS5Gdh01VrDXXcsm6rf+8wPx0ugQsf9OIlx9f0pXBDwdL+zE/KpE8eT3HROk9KZzzwmnquBRzHQy009zVcGHXobG/owXLKis28Z/EnS2xwbGGbrJRpQ6fAKShsKS/295jb3Y0NSeONm3zVTQX/yboJ1XTyePrDnmkOhL69c3ExgERw3zowhxo4PSk6fQBWoat1pcb3o8ZdzDEsqP78dKFw74eVJbE8wwyu7Z1NRVe0lVoLp9tI87p8K/rCtQFmr2AQ5zUpT6ug6pv01jCSYJlXoRm0nbk623FTmLm2Fjn613S4zJnQiTqyVveRWLBk+hFkJY6lFDFGznVoV5yZDfXTQzzydkOTA3yR5UstWMSkw35OLnUiEdvjzdGLcVFWK6E3baga/aBSTGRt+w9KddXBggGjXEUD3CtnJP3xGmTky92zckftbibbOPSrQJzs8DvxEyObWTsGTOK0h86GnBms3QES/+tSa3TZhWLNeBrTaP6rAR/5a+c2w9qCSleY7JeGkQhl2piljrH15TU0MUTu1euRNOE4J9ZK3oMZ+xEffyEkfDHujVO5oxl/wEoDK6JFExICtyPqQI0B3YJ6GgGWXiJjja0OqfUS2mvdZJ8asiMDiGAO7frBAT2paU2B8R/7Vue59ECD509FiSjaXvzeH1tIg1VbpG8ZhVL6WGU83fuYQUtX5wBB/VBmWuQQgNoy64zA9leEyM0Dl65B70S0n5AkwrfsXP1/PIGezj5qPPV5VH777tfpB37cXKjvKbWfFvikaj5K5eqLZyuPn
 B0pFbbSS
 RRWwavC0/9JmtMWIfxfbb2M93tAG9L+j54GSS/U+rG9oLmmEC2062/5bhle5gATbkdYodKnVfaxkR/pODCBpozEr4E16AgdsyXRhJydesz4ZdzBCDAPbxqR19evpQnWtw9OENVWlRVVopnye24SsB8+tHSgP2HUENtOMiDPWIydQxfFaHFEQI/Jjag97+1Fo4AOoBXIQL0O5eAKtlrctfuSlIEjFywfBoyhk55m5FQIyBVnG2q4i1UVEqHXTbBb//nFJOgVu42dGUZPJzukU2Pq3DhX+llUegyQM1iocqvreqaa5f0nzF/CO4OlQmLGn4K93IIRQxUKUDeT+G7+2tBNmZZcXcCBrUovO7iUdtFYtkO94cCDpgyE2qGqJcnynu8w/udysar15AeDbGtsu4cK9+JZ0YR0ZWZAak9CVUk8f2yzNUnmP7vVeY20o07/KFFMuCEP+yYmwVRf7IHQOvxGt09cAxYcJdtbWcqLxWh2tnpORUij7jFYNAGTFwfJ41oksUcCFPgppG4xPwMw8kHtYso/WGMonLKUCEXGP5TNET1xI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 22/12/2025 à 11:28, David Hildenbrand (Red Hat) a écrit :
> On 12/22/25 06:57, Sourabh Jain wrote:
>>
>>
>> On 22/12/25 08:42, Ritesh Harjani (IBM) wrote:
>>> "David Hildenbrand (Red Hat)" <david@kernel.org> writes:
>>>
>>>>> Coming back to the fixes tag. I did mention a bit of a history [2] of
>>>>> whatever I could find while reviewing this patch. I am not sure 
>>>>> whether
>>>>> you have looked into the links shared in that email or not. Here [2]:
>>>>>
>>>>> [2]: https://eur01.safelinks.protection.outlook.com/? 
>>>>> url=https%3A%2F%2Flore.kernel.org%2Flinuxppc- 
>>>>> dev%2F875xa3ksz9.ritesh.list%40gmail.com%2F&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7Cfe40f4881e8441ab3ebf08de4144e747%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639019961377096292%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=Dnvzy5kJ%2ByF9GJjIw%2B12FTjaVgeAM2gA9g7hsYl7Qok%3D&reserved=0
>>>>>
>>>>> Where I am coming from is.. The current patch is acutally a partial
>>>>> revert of the patch mentioned in the fixes tag. That means if this 
>>>>> patch
>>>>> gets applied to the older stable kernels, it would end up bringing the
>>>>> same problem back, which the "Fixes" tagged patch is fixing in the 1st
>>>>> place, isnt' it? See this discussion [3]...
>>>>>
>>>>> [3]: https://eur01.safelinks.protection.outlook.com/? 
>>>>> url=https%3A%2F%2Flore.kernel.org%2Fall%2Fb1f04f9f-fa46- 
>>>>> c2a0-7693-4a0679d2a1ee%40oracle.com%2FT%2F%23m0eee87b458d93559426b8b0e78dc6ebcd26ad3ae&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7Cfe40f4881e8441ab3ebf08de4144e747%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639019961377117150%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=bOO7FGN4jAtX3jjBnJVpSurmM9rGmz8vIs1iGtbm1gU%3D&reserved=0
>>>>>
>>>>> ... So, IMO - the right fixes tag, if we have to add, it should be the
>>>>> patch which moved the hpage_shift initialization to happen early 
>>>>> i.e. in
>>>>> mmu_early_init_devtree. That would be this patch [4]:
>>>>>
>>>>> [4]: https://eur01.safelinks.protection.outlook.com/? 
>>>>> url=https%3A%2F%2Fgit.kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Ftorvalds%2Flinux.git%2Fcommit%2F%3Fid%3D2354ad252b66695be02f4acd18e37bf6264f0464&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7Cfe40f4881e8441ab3ebf08de4144e747%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639019961377133860%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=0yTuECy%2BBGDLiSNYuqYH9xGBOSxiRLxAtW%2FWTQU%2FB%2BA%3D&reserved=0
>>>>>
>>>>> Now, it's not really that the patch [4] had any issue as such. But it
>>>>> seems like, that the current fix can only be applied after patch 
>>>>> [4] is
>>>>> taken.
>>>>>
>>>>> Do we agree?
>>>> I think we should document all that in the cover letter, an describe
>>>> that this partial revert is only possible after [4],
>>> Yes, I agree. Let's add the above details in the commit msg.
>>>
>>>> and that that must
>>>> be considered when attempting any kind of stable backports.
>>> Sure. I would prefer if we change the Fixes tag to the one which I
>>> pointed in above [4] (with explaination in the commit msg). However I am
>>> still ok if we would like to retain the existing fixes tag and show [4]
>>> as a dependency.
>>
>> I think we should keep the current Fixes tag with an explanation for
>> dependency
>> on [1] in the commit message.
>>
>> Would anyone have a different view?
> 
> Whatever introduced the issue should be called out in the Fixes tag; if 
> there are dependencies for the fix through other patches that were 
> already merged, that can be documented in the patch description 
> (relevant for stable or distro backports only).
> 

We can also use the Depends-on: tag, see for exemple commit 9517b82d8d42 
("nbd: defer config put in recv_work"):

     Reported-by: syzbot+56fbf4c7ddf65e95c7cc@syzkaller.appspotmail.com
     Closes: 
https://lore.kernel.org/all/6907edce.a70a0220.37351b.0014.GAE@google.com/T/
     Fixes: 87aac3a80af5 ("nbd: make the config put is called before the 
notifying the waiter")
     Depends-on: e2daec488c57 ("nbd: Fix hungtask when nbd_config_put")
     Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
     Signed-off-by: Jens Axboe <axboe@kernel.dk>


Christophe



