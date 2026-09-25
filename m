Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4C66C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 10:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1059B6B008C; Fri, 25 Sep 2026 06:05:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B75E6B0092; Fri, 25 Sep 2026 06:05:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE87B6B0093; Fri, 25 Sep 2026 06:05:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C72F96B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:05:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5798740550
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:05:04 +0000 (UTC)
X-FDA: 85251851328.15.D601281
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7A3B9C0002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:05:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PQeO386u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790330702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dU7q1crf5ei7yINWaJIj4cP+u6OplpVTF9BgULui5xU=;
	b=TKGkuHTB/lyHSC4eO4sq9uOt6FIYD1G3Fu91WAMQJartose6wB2b5AHN2uPIysXBwOXhiX
	0PYhHMV1pLM5DMnmB4k3SZx0AOHiL0igGRSTMpD0Dy7V2xS9ZcJ7mTqCimZGJ8qyJtfWkN
	1QTscD2KwlZX6Y9dXSmjFzTaka7J4wc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PQeO386u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790330702;
	b=40e6kGwl3DrI/tqB5XyXN/ggozb3MNPk2k29Y0EQTwTkct5xPuFpV5EYRRi2G/q3jfwQx4
	uMi6r/Ioj88dxtqsckoqrjU5jbOlJwwPbtT8S2n40MOPZA3Xzvtz4aIHqAHDvM8JfjgbDx
	qnk4KDECxzzilm0w13R+jjxLBCR83r4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FFC2423CE;
	Fri, 25 Sep 2026 10:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027D41F000FF;
	Fri, 25 Sep 2026 10:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790330701;
	bh=dU7q1crf5ei7yINWaJIj4cP+u6OplpVTF9BgULui5xU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PQeO386uyq9Zj2RmPUhbQTxwDLMrNSLyuDhakS4xEaOiKPurJ2glp05GW5UwOZrCk
	 7TngOd0Gikg+O1G+TqsvpMVOXIcGVyukDWeHmwY8gS08SrfGNLrw9Os8XkmTWIoRKR
	 bCxPIS2z7J1BbZsi0kOOJhy2hiXDY3Qo03xpvRCmsFxKvoGFVy/YEDtuSMuCpASoEW
	 aTI9QuC8ycfqG9G6cytqg3Y6UybPQA2IC0SuCKL0+Kaen97+8XntUuFNzfSTg8tvEF
	 mt8eDIUcjq1YzgVdgfQSb+CspLnRZG296mAoj2yxBh/Uo6wI+gaqW6VduGfwTZHkFt
	 7MVY02NaRdCVA==
Message-ID: <75358469-e4b1-4c11-89a2-61773c89132c@kernel.org>
Date: Fri, 25 Sep 2026 12:04:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] sched/numa: scan read-only file mappings in
 tiering mode
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, hannes@cmpxchg.org,
 shy828301@gmail.com, raghavendra.kt@amd.com, stable@vger.kernel.org
References: <20260922182928.2199090-1-gourry@gourry.net>
 <20260922182928.2199090-4-gourry@gourry.net>
 <c73021d4-60c8-4446-9c08-f9d7807a3a0f@kernel.org>
 <arXBari1QNJ-aIW8@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arXBari1QNJ-aIW8@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7A3B9C0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: czw3sanzjnaw6fhpas1pinwftgc7urte
X-HE-Tag: 1790330702-523706
X-HE-Meta: U2FsdGVkX1+K/+g3VHrS8wt66ObcXRBdT9vN/7dmhkwT5vM4l4IJLROt7SkmpJlKOEXnjUZzsYhUVL2p+e9TtjDoR72o0o+GVeIeH6SryKY8QQIiBWDq8J0JvU183mbw+6cuWLQUqCOwbjAKPY3gbHZZRZ9gjmAIWmQK2XmHtGFceczVB3T2+kOfuGEbL8U8x2ss6mEFps+TRnS5OTYeAkSYBDljYhlpiffv426O9zFq76iu/SFRNGTWNe1d4aeIlGkTrMy+ZXK6VWBhhT3/1OJpcXdHGoW46pUn+wVlvIbrFN8JUsSR2YEXrao07Ul9+IBAeiDlFSdbMJJ/GJCEFhImBMDfk6QmvNBvrdyyQxNcSvTImjf/af9ptOdBBWOmT0ifB7ofIaXdJ00sQna5obu7yUVL0NVwK5ZbTBsx2fOcsetm7Ma9p+eFOzMs9fn4mp9A5Ss/DeQIyO5+9Iqxa//3i2JTXIzprs0Z1eOK/D/8m3P4P2yJTAtNFvWrfTaG+URU+KZeHJ8G+B3PClil8pZlk9+Y6wm3/4jXBHXFCzTSAqAxLdODPfou4HuBAvhScxPd9zxvetDdxDGdanKsHT+gLOsI+RIVuG4RwhKPkHZKho5g8HI7Gc2CamfNwhsjcV72OZdMPYGLv/PPW/ncsmssLY5yMc4To3S5GxHUGw8Fuw0p2m4K3IUgpukrsoaAX/7uSYYnJK3uNZ8OXj1xycUz9maBVDSAVVUa40NDUNf+Pg7pmY5ptxutZ81AT6O/Do5tBFhr5E+5jgLYc+wG8z0bzTbLo+HJGILbXHnZC3twoD+1y0mFBf5CvdDH2GeqsR0XkGCFkW43IdihwZRC841IQyBLSCXW5/3mFkx+eqlUaFxPsr8hAsGBbJPGADkr9rj0LNa32qtCIKKhOjiVNC5AMfMZ+a4cnzDh1Y2/Jsww/U+Y4kckexe0k2qnbA6/3CWsyVTJAiS2VDKLqZD
 uLEJg/dR
 TSStxc1X+WTOMo9qVYdugakTufMG27HX/bsp0qg46S3kPZCj16XJduSy6EXiR4QzU6aADgkOnZ1qZJGlxetfAP1yOgslUvWee1FsMFPTOj8LE1JtAZNMWtJd9k65YbrZMCVnQ395pBie3JSUuIt6BzK7KytBIiqUgYLh7kp62csBOhIW+QNT4NCTiY+cPB0ZaENfN74dSVsXxoiMHHSQGxiYaCuevdE4N76i7KKvu4/02LF/sLLOyJ1GMcN2a04vtQCllmBfgdP1TQiLk0UrrtzQm1+bbVu5Z3tY/gBtF2cX0o1NLbmJ/Zzg3rmO1BM5hHQE0XS4NYLGv5n8rN96aZkuZow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/26 02:35, Gregory Price wrote:
> On Thu, Sep 24, 2026 at 10:53:56PM +0200, David Hildenbrand (Arm) wrote:
>>> +		placement_scan &= numab_mode & NUMA_BALANCING_NORMAL;
>>
>> Do we have to update placement_scan at all?
> 
> in the following commits this composes:
> 
> 	placement_scan &= numab_mode & NUMA_BALANCING_NORMAL;
> 	if (scan_started)
> 		placement_scan &= vma->numab_state->placement_scan;
> 	else if (tiering)
> 		placement_scan &= placement_due;
> 
if (scan_started && !vma->numab_state->placement_scan)
	placement_scan = false;
else if (tiering && !placement_due)
	placement_scan = false;

Is more pleasing to the eye ;)

-- 
Cheers,

David

