Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A81D3FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 10:44:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8A0A6B0088; Wed, 29 Apr 2026 06:44:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E61DB6B008A; Wed, 29 Apr 2026 06:44:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D778A6B008C; Wed, 29 Apr 2026 06:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C1D676B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:44:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69B9986732
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:44:49 +0000 (UTC)
X-FDA: 84711260298.15.245F3E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id B182610000B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:44:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V8KJupcy;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777459487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rc7dyVCHIWkBSe4Vtzuu8zQdNyuYPz5Ti+16myPqZTA=;
	b=je00r5QD6fIU5v8zhcRN9qqAL2BCtSIY4Ae5+ECU7OFC5Zg6ynKPINIuPfOWTrkUMzGUP+
	YTt2VC7hONRMgijmTurVUHZFuWE6FM0Ea7yYx0bHuSmtIGgMNnLkt6S6rRMRMssrb2Ti7M
	DM9T2fHvt/8I91UvyVeYxigiSyBpmxs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777459487; a=rsa-sha256;
	cv=none;
	b=rUXUnCDf6gflApJ+LwzcJTvzmwQm5bnwE+5o0cMCdCl3mLs34wql0zvtYFPMPMf7xLqYvn
	JZKDGOe5aDFqdYlNEyJ4jhASYmQw4Ijb29X1G9PsvBjRHy4zVpizRdLrCT5YbMJfiUGtlZ
	ExIHuaMOD7/flWFJhhC7ydtsVlse0kY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V8KJupcy;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C91D16012B;
	Wed, 29 Apr 2026 10:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC30C19425;
	Wed, 29 Apr 2026 10:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777459486;
	bh=iT6NzrUzIoEp6td2xLX3T9Lc0SjHWHfGf231HgdDuxg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V8KJupcysO3BhF4gu2fO2Ri0/syRIYptdVQZJxzhTcB9V71KpBWeSF6q3yxG+Pvvv
	 a7RV8sQCXkSwg3p36AeD7yk4Fh90kX6/b7eiga0KtAN1e7W5HW9VyUZem7UXhzdKVQ
	 +qRq3lR9+3mpLvlcXpU5tc3bg5lXuN7lmr1WpsGsrMjmm1jB466QpymdPpdmFcflTY
	 RR/IeLcq07ghkvGmVvN4GEtLn0rikgR9FC8GewLXquf4jN3LwlLSLrR3aFaUMhopyg
	 mhHFsC+DkMSHNB7r+HCp8fQikB4eEHMiunR90aqG4YdwZz/ts9sT4bHHGNcGwHrgSj
	 IbpcFHPcDGDuQ==
Message-ID: <b67ff3f9-8661-45cc-b408-6a7b611d31c1@kernel.org>
Date: Wed, 29 Apr 2026 12:44:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] drivers/base/memory: fix locking for poison
 accounting lookup
To: Usama Arif <usama.arif@linux.dev>, Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>, Miaohe Lin <linmiaohe@huawei.com>,
 Muchun Song <songmuchun@bytedance.com>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Ying Huang <huang.ying.caritas@gmail.com>, Dan Williams <djbw@kernel.org>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Rafael J Wysocki <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260429101134.1358607-1-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260429101134.1358607-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B182610000B
X-Stat-Signature: soqdk8g5jtnejru41g74b8jdmz9ys4r5
X-Rspam-User: 
X-HE-Tag: 1777459487-160512
X-HE-Meta: U2FsdGVkX1/5ORdqq+46hpRGlM1bjmJxTg4NUMEe/zdYzheUxpeBpqAym0N8OXJlYEKASFtHt+orQZ/6zucT9YSGBWTzOjaRdzoSIcXQb6km9UA0erDjbV8CL8p3s2zuQu0LSyDBVSf6p+K4qTJMzz8G98Fp3kbP1yZ4GEokgDB8R3YWPfyy6LzBX2lAmsa4s4peO2WW3s5GFQaaXurwc5Mw9cjkbqP5rKT6GPCi8HH6AsM16GylR3D6qS0g/SB4tx+cZJjoWNcAM1v/G5k33e/UFtDjZe+JfPN1mR7AOblf2wvP+P9AqLtQfHy7jPKpEGFvnTX9PbnDmy3ZPqrzXuEMFq6dx9JPc72ijWiVYEoNZ4O5JpIE6fp1c73BwyokH1BmYWvtbsrxH3JpIuqWd1pHH9MttyJ5vJSRSRJGwwOP3eMxU5r1bd6XC5VY6FyyNtG55gS11duBVCEfFOMVgMqr0df09xRu+Cx/6EBKo/QMBxg9tIVPhLcYlyx+CrvK+u1OynC9eCZPbn9EkyXyHrb3bo/5t5R1lLvJAQYgbGv9jQJs2RsekcPcSJZ2HK2Lye168GIhQ+nAIckPreskmRmwP35bKpeVhmdPTts5MgSjdopgYsAUhTo8zQ6NUPcczVPDu+E/pJUN0fp0MpMmD2oqSNreeMJtACPZFqVcyjT+moyCzdcT2eqV5WW171w0KEy0RCFYmpjJjRD5bsYganFs+J+qvHG1jvVtBKdIS8SwTW2xHbGgBs3kO9aqW9za+nlwMXg2w42W0/H8SXxGKowHcVnkDK+gV1RmTohYfQQ44dvvdqqgx6y4YFFm6U1aLy7Kv2s27zC4OVG91JkWawkJnH0p2c8au7gEIzQIJD4gv/yR88/D7Crv4MwmsR7bsCVXW6brdlJoByn6Bj34FZyQGcPC7T7RoRiZ6j9MsEy0kbGhPhJt7RK/bxv7hwYFyrCZ2LEPmihTTjMsyx6
 g/46zuF/
 MHnvwbbcvlJ+e9je2L+Iqj5Nrpks8MANWATfqEOuF3wGXg4jvSNcfUEVjn7Wj7jL03c6TXBOIZrxaLmwbS3jKYyFSfnYKwUw3ChQwDDrfwVzYL+uVb1j8PDDNp4Cmgpzm/Agsf/6uFR9fomZBoBgeKM/G/qGOZXVwcAL6YEldJcx2zApPEIM2PPqZN1koQ7cI195q2N6ICVqDhSCLBUqNyH2krgijQDmjIp/+0uJ2DmjwNJdW+1OcD2hkZ8E9O8G1U+z3s6MljUaxGdjFH22rC7zejZVqG1T/FoIM1wsohT+zMtYP5q+3ghO9BW6Bgg4B2vmtI4nUG97mimlEQl2wiuUjVEMbELzLAIffa/9zHJpWmnLgwguGJAMVc4bTmac0EV+7Brzts3FaD/le412j8qAg55rXRPL+i2Js
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 12:11, Usama Arif wrote:
> On Wed, 29 Apr 2026 12:18:08 +0800 Muchun Song <muchun.song@linux.dev> wrote:
> 
>>
>>
>>>
>>>
>>> lock_device_hotplug is a mutex lock, and we already take other mutex locks while
>>> holding lock_folio in other paths, so I am not sure I see what should be special
>>> in this case.
>>
>> Hi Oscar and Miaohe,
>>
>> I saw sashiko's report [1] related to folio lock and lock_device_hotplug.
>> Seems it is possible. You can correct me if I am wrong.
>>
>> [1] https://sashiko.dev/#/patchset/20260428085219.1316047-1-songmuchun%40bytedance.com
>>
>> We could fix this by calling action_result() without holding folio lock.
>> What do you think?
>>
> 
> Hello Muchun,
> 
> You could end up in memblk_nr_poison_sub() while holding hugetlb_lock spin lock
> from get_huge_page_for_hwpoison(), right?
> 
> Lockdep would flag this as sleeping while atomic when acquiring mutex I think.

Another thought would be, that we always call the inc/sub from memory failure
code while we hold a folio reference and the page is not poisoned yet.

That way, memory offlining cannot continue and the memory block cannot go away.

So we'd let out page reference keep the memory block alive.

-- 
Cheers,

David

