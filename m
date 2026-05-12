Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0E1ECD484E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC4C76B0088; Tue, 12 May 2026 02:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4EBA6B008A; Tue, 12 May 2026 02:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEED36B008C; Tue, 12 May 2026 02:34:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 99C336B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:34:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 454EE1C0DD9
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:34:30 +0000 (UTC)
X-FDA: 84757803900.30.7984A9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 659DB14000D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:34:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WN/hN8op";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778567668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RbSq68NKV0CZMHEW49j5o85B9Ql4O6Gp3dbOPeNMl70=;
	b=jyPPqd7jUbbKuGZYZnRPJetx4gyMwszMVDKHQscW3rrwgYqSGqegcpHT64PtFQOhBUs7XI
	oNC4uR4cnx44+LXwpO/mYPuzk+ST63xdokhASjFc3mJeWEI44XDXszEgPJcHXSPOdeJFOK
	iKwUkFvW8KsxCU4AFHRAVw2ngC0RMT4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WN/hN8op";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778567668; a=rsa-sha256;
	cv=none;
	b=pSLmCi/k1rmm7wUlpqmx9xoOIVQaXv5IeZ1rWUOcAivUF0Ff0KhvgzhqOy/dvz38QCdDzO
	Vhh3sR1nIDu2vVRRIuQ8caOxFHFkuCkimZy3bqM94PQazOyTnT0/enfTAv8s1pDHxDjwvu
	HcCcSFX1qqIOOHHSJNdapBCXiOZQY8s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3827F41802;
	Tue, 12 May 2026 06:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10853C2BCB0;
	Tue, 12 May 2026 06:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778567667;
	bh=2Dtp3nUQYhSh8d8Ve27AoBtFKT+5FmmE8Snx2QeLqYE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WN/hN8opfQE4WzDY0qzDO/2LAWOwpx9SpPVN0H/kYGKO4gkdkG/rzO8Wh+zORALY5
	 XG/esKrshYv5C1YdL+UGQt6mDKQGpgQoQleYursPSab3D/0sUQqd9UxUty4dQti7Eh
	 0KbtNvzPG85Ja5LhQj3Zu3BMdUvKrE5lgCQXQ2ikgyWE8JimkIv+eo3P1gUpg3Ugvi
	 hTqNR76cEaOzEHwDfa/TtAf8J3BIjV3FYoWs6cJGcvOIBH6Qe3WcD1Ni0SoKhPwqFY
	 F1euq2tlUE9fH1jayXdWB3b/LOF6FZTjKjhHiinGc+ISsmd3c0fq3160o6sclvAqRM
	 RFGdUfdntKgtg==
Message-ID: <f13f56aa-fce5-4382-8998-668f2c13b84c@kernel.org>
Date: Tue, 12 May 2026 08:34:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Accelerate page migration with batch copying and
 hardware offload
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Shivank Garg <shivankg@amd.com>, akpm@linux-foundation.org,
 kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, apopple@nvidia.com, dave@stgolabs.net,
 Jonathan.Cameron@huawei.com, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, jic23@kernel.org, aneesh.kumar@kernel.org,
 nathan.lynch@amd.com, Frank.li@nxp.com, djbw@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <98a16642-35b7-4cf9-9ee2-8de15e877920@kernel.org>
 <874ikdwe21.fsf@DESKTOP-5N7EMDA>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <874ikdwe21.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 659DB14000D
X-Stat-Signature: artfiqjyh4bu1sby9jbhwtpnfbygfgoi
X-HE-Tag: 1778567668-155075
X-HE-Meta: U2FsdGVkX1+nl6lKuWzgHKgyePhnLDs3NECC7Wn43dsGPCw8zXblnmpY9vbTP3I5woANsjdAbJVvO2HSV2mhM3XsiyI2nhqy5aqhkZWPHzFp2oZA2urzD40qgYuaVSJTxCvaIP8hKbqCcAmGG1lO0Rl7tLnaa0miwtZsfk/M5wmUh0pnM4YWACRiLIUn1nPdRUz7I6ZpSRQbVlPVZsQGdaIZ1M9K7k0IQm5f/CgueM5jeTq5NdS8vhgbN2D/D5k0ARF46f/MdHMb6atOOh6ko00HjQHD44/G7zmVlm6N3FCCH0DZpz8FqGqG52C7iUfpcnEuhSt/2xjg8q7zEDcnauVEp77eRTFzq7rqt7doWSlrKPhh4ENV+x+L64RgKESMQoSuMCQDosMMj+oyTjhjBmpjU0du8i4eNKCOQXu6QsLis/wH0myiOMUb0RhnbPF75FcGEIiiQWTf4U5kg4pCrFdz4H4MbVWsYg1JCYuHhsvx7l7FvAUzs0Cypa18eTZDHzOlaDmCsQh8KQmVGmb7ndYLPQG9U1/22xzZuYOJ5RQgSMG7ikeFor+kU1tTxeEgzNTMhlozYbkPjXCPNajGYVO7U2p6tEjTqntC9xjO28NrPQa0lhYzyU1FIll3uJ8kuMNcfq3g4Q9j84hQsJd4Ks/+OpdE4+gQaiq23hy16A6SZF2OLL6HV4XWUDt3nY4fear9BkaCkVjumWUwmRXEWFHXmP0nbwJqAv6C4LZW4GGKn3xAdxO1gfmFne+RSwF0bdDpW3ffSZOiOX6w10q1dCdXUF7mDcpQo6XCzhz7Qz13bItuWbgoMiR0VhCOm3V2lhr8EAHpEUoaAKEGtT6DCLf3iSDyWwVOY0FvGxSDhfTu5hGnyyxDyU18wC/XSc4w+NSpcy6foNXJ+50hGA9u4Pbf9H1UdxIb6u9EONmun6p3NYnoY3a2Aw8VMlXp7dLLtkETDC1kI50t8XdEDf4
 fiD43S52
 wMMwauFS4I+XePMkc/2m6LTf9+pd7rmrlogpRDKsHma9fCJLFx+CcmLEql+cR8r81yFdyeo9l7PRJgZTC5beYssjf+/4WAjeQSrv7dlh7dM4+uUKaDwAftD10fn1qf10c4roxzCsTPMA6cwtGP7PIPcT+Wt9e5yQLwR6btWet6X9CWUPrw2j6ACrWYrjJ8PT35jINAGDVG9HUJy4sfVJNgSg7Pesg1ZZWIUUnhp+QjoXJvhLtyTuDuPrGMntJDVinRE9ve3/JDnPMjMDPM2wlD9IFCUwZUVw2H7x6WPOPFKgVaRgRotEpvMmQ+xZia2ipRUbq5Ip0QqXJiz3gtPVUBnj0Rfk9uFxwFp+J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 04:35, Huang, Ying wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
>> On 4/28/26 17:50, Shivank Garg wrote:
>>> This is the fifth RFC of the patchset to enhance page migration by
> 
> [snip]
>>
>>>
>>> 3. Per-caller offload selection: Today eligibility is by migrate_reason
>>>    only. Some are latency-tolerant, others may be not. Is reason the
>>>    right granularity, or do we want a per-caller hint?
>>
>> Isn't it sufficient to just do it based on the #folios or sth like that?
>>
>> If someone migrates a handful of folios, latency is likely more important (and
>> batching less beneficial).
>>
>> I'd assume when migrating many folios, batching could just always be done. Or
>> what's the concern?
> 
> IIUC, for callers like migrate_pages syscall, it's possible that almost all
> folios of a process are passed to migrate_pages().  However, I think that
> we still need to keep the folio inaccessible time reasonable.

Wouldn't we still want to process them in batches, only affecting folios in a
batch at one point in time, not the whole address space?

-- 
Cheers,

David

