Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE8F7CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9B456B0088; Mon, 11 May 2026 04:01:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E71786B008A; Mon, 11 May 2026 04:01:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAF436B008C; Mon, 11 May 2026 04:01:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCE4D6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:01:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1017840640
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:01:46 +0000 (UTC)
X-FDA: 84754395012.15.CCDA4DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5A7FB14000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:01:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fnT5B7rZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778486504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwXHU6Hm7UnWVirqqIpEpPRFDWTE1FQw1FZtYdfbJQ4=;
	b=kwwfd8YBEDtmoYVoCY39yK8Z4RoaBRz/LKKAdXRsA35UQPtAO1ZvJ6Lg36VnsXE2FUpKoP
	DzDay068BokS4eaJDmMD0Angur4BYUoz93w77CW2JfKj8UCXIRWJBoa2G+PBLvkiF+EIQC
	LpKCbNxqdtub+/mWVEzt31Kg3+GmBbE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778486504; a=rsa-sha256;
	cv=none;
	b=UG0qANZ7vY22HXx5RwJ/eWieZ8iioSVYs8C2pa7h+cW8AuezGiiE+T34nKcIuNViZyAX/6
	J5itgV+e8DnCVDtzA7zytqgHxkefR7o4gjwne1dJqm6FMA9oDK0rzfmWio7060Rh3ER0Xp
	A6JMQhfaiApp6TXmV4U6ErcI6UXOJyc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fnT5B7rZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B6A4B60120;
	Mon, 11 May 2026 08:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B48C2BCF5;
	Mon, 11 May 2026 08:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778486503;
	bh=lSawh0Qeo2Q0Kg6mlGkaK9imbmsRVOeC7kHwBRI8ko4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fnT5B7rZs+/H+B2XxDgLdwpnqBsdgLJlW6caGO6+uMkQcnOB7sEv4sGYteVV2ZS0j
	 TNZYFD4PxI+3UfK2iUx+3OO8wICEXJvBLcO13EioFdbCr6OL93dyPE7+NYf9XJamU8
	 VqYo4chwV4Ih4OM5rR6+FrlC1O5u6y+mHV79Rwo7ET8RNSBTG/c15Xbya4S+Axj3VN
	 jUl9GoHg8MzZWHSVnoZRdfv/14gGEDs//AvyyqGL5T7RnVc+K/Qdk0FS0Du8uBfLIm
	 MWmhAkFP+NmSzgHj134/5Sa+1R836FR1DFmjtROiQdB7nIr0PnXQf8E8M2A7P4TESJ
	 IN0A2a9fPYQuw==
Message-ID: <0a860f74-b2fc-4ea7-9f13-1879c2c8c168@kernel.org>
Date: Mon, 11 May 2026 10:01:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/khugepaged: avoid underflow in madvise_collapse for
 sub-PMD MADV_COLLAPSE
To: Wandun <chenwandun1@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev
References: <20260511065701.799006-1-chenwandun@lixiang.com>
 <cff99673-ba36-41d0-add1-e2738f95bc4a@kernel.org>
 <4e3d0c1b-af33-470d-acb0-1e6540ba312a@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4e3d0c1b-af33-470d-acb0-1e6540ba312a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A7FB14000F
X-Rspamd-Server: rspam04
X-Stat-Signature: 57xsrekfojfy9e4qrcf55nquchr7jf4f
X-HE-Tag: 1778486504-760878
X-HE-Meta: U2FsdGVkX18DsHx9eRLFoPp2fSQ1T3O8/mL2aGARNXyQ1GGrUNe6IORqBzTvFMklWi+wVTFt8abCo2zbiWm/3ns6YsAF3hD624PUO7Ip1EG3VESTJNCcEOCSe6EjHOrQkXYRV4bzI/hZZaJHlEM4nJaFVcBRfujXs6LF5/fX+1wxTEhDYlUvZK3gHR+SaShCNMJJW35b36fyrnm1WB5A3nuCk6K/53P31GVMiebtpqxdqcB6zazJf1WXRszBztC3fmuoUnV9RuFuxMzR8Effo4rjlYtkMujjyU875LyOVX+fMvu5jHWpn3GeHfkDon0tQFpU8+sOmRujqeoVj4PVLtzspONEB5ff1HnJmZkbiogAzFubNdSdB7FxpKISATvmNzKRsDu2Po5FRzAPtU8iRT2W9wjPPsdksdQf0ETI59ZcJkHvh8JkUuAMexwr/Uxg0TsNrHfwSWT61Wi9ZTxgeOQnYeUUCMH6b8RGfWC0E0XTLzkSxyHNYK6nVFGJqYaGj1YJ9mzHmzHd77yreMPVkcMLqyOxV8bhXL6sm82936Hy0rEHByO99KjaqfJob2drhNbGa08nY+KyR+nQFKI9qu0ntKmaCsgpNKop1aF181gK3lNR/5Qc1Z0WY5gM31UriCsiC9k+gcvxvOWyxi+WqoMpLLpkwOKO0UpEHT65A/N6l7FOt+3X7HrLwmyQQGSV8vAGPP55xEEmovm6dyQNBAuT93ZIxTrafrsWbyoj0/yhybLG3MLu5CyDUkOzuJ7o3+VuYrIy3AS0aRgCxs7+1oTkbqLe7stPf6nzSrjFPWXrG3dEFnwlipXX18alkWUygHmHrfR5YcAHfp5fV0/hSa0YYMm0KAPEs4RkCa/0lucYbXeSTEiS5EQgjrwYVspg+VZezeDGPor5S9viTw5iq40rH5uZavUsv/lKkbf55UhLK5aVhPXb24yw9NrQGVE66tOPvA5jHbn/ZB42LjK
 p3MpA+R5
 Qgk6nPB7uLuG9TtId8ehOJhIqvebOwCSDIonVckNtoYU6qSfnfss+uuwKnrEkfMgIFNg2XdrbqVQAuBWb/dn87nRtCvM67n8GlwnxiKTEytfc6BDJhAt38L6eRmIQRu1p7EszA2tYwyr8DhX1iWf1fmaXsaL93dVlIybbKHHQGaGCQJcJbz7kZQwoXUgtEHN3uOqoUKof2jqIptUJvHWtd0woowoxb73ub/lL3yjTYQduaDvDDmPIBWOeQuFklwGqU85OKzgGaBRolFdjBJESOkE0wXtPNT4JB1xy3I7Dmk2THGXg6OMaKHs17ZroWfZ4qbPFw2+l9LgfHOHQ8sNBKOG7cy6SQr0PdlbZuJOMyJHgcYuSyrkawvI4y1Bo7eSP/zOXDpBXrj7byaI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 09:35, Wandun wrote:
> 
> 
> On 5/11/26 15:17, David Hildenbrand (Arm) wrote:
>> On 5/11/26 08:57, Wandun Chen wrote:
>>> From: Chen Wandun <chenwandun@lixiang.com>
>>>
>>> madvise_collapse() computes the THP-aligned window:
>>>
>>>      hstart = ALIGN(start, HPAGE_PMD_SIZE);     /* round up */
>>>      hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);    /* round down */
>>>
>>> The following case will cause hstart > hend, and result in underflow
>>> in the return statement, avoid it by returning -EINVAL early when
>>> hstart > hend.
>>>
>>>      madvise(PMD-aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE);
>> Ok, so providing a PMD-aligned address as start will result in 0 and a
>> non-aligned address will result in -EINVAL.
>>
>> Didn't Lorenzo agree that just returning 0 in both cases would be clearer? But I
>> might have misunderstood it.
> Lorenzo suggested retuern -EINVAL for both case at the beginning,
> Later, Lorenzo add an correction, suggested should return 0 for
> compatibilty reasons for hstart == hend case.
> (If I haven't missed any information)

Let's wait for Lorenzo's confirmation.

I think the important part is that we cannot have a situation where start < end
(given that madvise() consumes a length). Because, there we really should have
returned -EINVAL.

For start <= end, if there is nothing suitable to collapse, I'd say we'd just
consistently return 0.

-- 
Cheers,

David

