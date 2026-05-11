Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B711CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 763A56B00FB; Mon, 11 May 2026 11:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73B546B00FC; Mon, 11 May 2026 11:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6518D6B00FD; Mon, 11 May 2026 11:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A8936B00FB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:19:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED9C6120197
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:19:29 +0000 (UTC)
X-FDA: 84755498058.05.F4B0F80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 139AD18000E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:19:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RhNOpg/u";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778512768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DjbN/z5yBeTZXQK+wjUkrgjtk6tj+9KLkVYcPDjZzQA=;
	b=JavRfM6ucIJiq5FVw4NTwMXCPdwHTxJdC4OUa8rMhANsb4jfnFkRtm/0OvCJetVB3tV7ZX
	cq3Fv8/Gi4V0J3U66hzc/Bcf4DDd5sqOofS0+6EvhSkHXFzIQEKnoymuR/YELAxKiL1bo9
	LL5WroDIs7vMcIzqPHgWnbSt79IahuQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778512768; a=rsa-sha256;
	cv=none;
	b=wgJNuihbomwj2B3znI36odsjw+M8pjy77PNiaZTuJNob2MKy9CBQKQWsFK1mdp61vMCs4k
	zg89AIcpYddwJhaH1E1kz+e3KRAtOJeDH7mVdExjCc8dcxxm0L/xXqPBXQygXw7yk4aYJK
	mf4inRe1jLfdvylqFMJhpvYHTc+n13U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RhNOpg/u";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 247EE40ADF;
	Mon, 11 May 2026 15:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2AFC2BCB0;
	Mon, 11 May 2026 15:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778512767;
	bh=Dl4Uqm2XNU3q1Dm3o3ug6F0HtJwhXQM1Iqs2qMdt8AY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RhNOpg/uboJo8mSSDhE30GhoMUuRfEzOHJED85FblRCqbqREpxN+BVu5OEn/lRohF
	 ydvcORhId7WwWS3mbfayalOvKwMJodNo8NmKuh2rSmb7a5LWzdDDbSLbCJ4RkAb9fz
	 /76TdIkuujQo3T7nVFOW+wA/pcuuSkvlAPzZ8dyOd6MZSXM7txWlFzRcV1zOSZjh+I
	 OUA0fjm++4aTzvtk5J7Ubx2MB73awPpHTyduFWQfHldrkYbdEOt/Uahtyy+Y2B1VEO
	 tmsliiASI6OJiYPwU1JKURhYN5sE1x41Xa3VIcKqqc63yRbRyMHNSgu3Otxpt6uvJF
	 txby6BBijCyUg==
Message-ID: <088ded16-09ca-4c40-ab23-62108c342588@kernel.org>
Date: Mon, 11 May 2026 17:19:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Accelerate page migration with batch copying and
 hardware offload
To: "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Shivank Garg <shivankg@amd.com>
Cc: akpm@linux-foundation.org, kinseyho@google.com, weixugc@google.com,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 willy@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, apopple@nvidia.com,
 dave@stgolabs.net, Jonathan.Cameron@huawei.com, rkodsara@amd.com,
 vkoul@kernel.org, bharata@amd.com, sj@kernel.org, rientjes@google.com,
 xuezhengchu@huawei.com, yiannis@zptcorp.com, dave.hansen@intel.com,
 hannes@cmpxchg.org, jhubbard@nvidia.com, peterx@redhat.com,
 riel@surriel.com, shakeel.butt@linux.dev, stalexan@redhat.com,
 tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
 aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <87a4ub35ja.fsf@DESKTOP-5N7EMDA>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <87a4ub35ja.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 139AD18000E
X-Rspamd-Server: rspam04
X-Stat-Signature: 73psyau4z5hb9ww99httdaok8pr46nmf
X-HE-Tag: 1778512767-823553
X-HE-Meta: U2FsdGVkX18rUQ6rvaTtXg46YBrZUz4kEOJLu+UYazvKSYakNVP8ADSbGWFjRJKoCxmzu/0TeQPHdCE0MMeCk+QMCwyU41ZqlcKBCR+cheL0CoeXU53R1Z44bjwnA1ClpkrOC0yfuD7y1FNqvlZJpI22TdRt+KcBPupGqQYH+gOV6xFR7NEKDWZF7jCSWVoxbhVCyHBwmIfjEzVGVoGdZ6McYjmrr/9zIT2p05/m78CC5ZaonhJxP4+9g76U/oTLeunEi/HrsYgjLRylk35KorFk8kCrLKp7/5l8j74CYZO2Lwic8QqG2i5v8g1SYH00eN5i+PZf41WD5QRuenlu/05aRnPORHw/mYjcflwTXv1V+G18DGf/gFwiVkfFixdgeh1YNiE7if6BmgT6jHMroY+mx6VmAz2J8gax+ue+YScVmndbtLmK7TXYt+6/n7qEltSq3IezKdKUk8gEoEqUGhrtUXgwuwEoOYolEvb9nEh4PA4+6wlpKAEgVf+xxfNtqhaLFV5PPHpd4ZLzvsNLFSZoSy/AXL5Hm7EmhGe83EzPE46IQCX4XWyVrwIjt56U7AMsJEOSa904rVn8tebNIHieFzk+2DalUzX12n8OsZSMih6sHMuup4zruUvylzpsOXfVetoGrW6Ow+rxrdVxcBeekUoxDhuCNnTxjzQeRF7YmiyyqVCn+KHJUFOiXc92/98GjDVw5oKdG3S55gbzwv+jrYsh/3qOJ0yMbeH/TiAR/Las7C4YlwUSPUGRkU910XSUjIGCbGldtnWIM3rNyLOBfsRODAb4gyTSnxHXD6sn85oBjCdmHKeeOZuPad+VvqGd5/kGh8MfvdyJ1S5yXtV5vYDKKNrRGtuWdnwubpGERl/AA3Jtt30VsKGiWUjGwp2DOt7Pqm02WQTO4q1p5YpswGFLq4q9GPgxNAHIi+GWUXHKVVe9TJgzNuqsO8hxuRVXh4cItiKQCbN9aAJ
 v3SX302n
 RMByk4rG+KddVQdgCF1YJ7g2qPrYp+fnU7YSlpBK6QVrHsmf8vk2ftfd2OSgW2IvM8VirCuwkQSHBZDvYPVlICt+1bwtaqpuRseSmQOpzIlmu0AQJVHiE5fzFqFtIh+mFrPCeWw9NAERcolhuZLoEZoLqYyfhraSE+XGN8q8hBqeo/Ae72SW3GL9GeBklhFOG3M6lNOnG3CUIq9f1hxLTsRLqHCiKuTY+jjIKjPe1+8m5Vg2Wn5yEr/cD/leuUPpsLUn4lmX8A73qcF0z8LtVod7PFzNkiO/cSuhSbOkt1JCAG1Fbppo7IHrLUqcJSqBgjeVJqkFjzg95jZsUYE/1R1l2fCIoIYEy1C7S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> ---------------
>>
>> 1. Should the batch path run without a registered migrator? Patches 1-4
>>    are self-contained and use folios_mc_copy() (CPU). I have several
>>    options like making batch path always-on for eligible folios, or
>>    giving admin an option to flip the static branch, or keep the gate.
>>    I'm leaning toward always-on.
>>
>> 2. Carrying already_copied via folio->migrate_info vs changing the
>>    migrate_folio() callback signature (Huang, Ying). I went with the
>>    field for now to avoid touching every fs callback before the design
>>    settles. Happy to revisit.
> 
> Personally, I still prefer to change migrate_folio() callbacks for
> better readability.

Can that be added as a cleanup on top?

-- 
Cheers,

David

