Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45060C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 474DE6B008A; Fri, 18 Sep 2026 08:15:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425596B008C; Fri, 18 Sep 2026 08:15:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33B436B0093; Fri, 18 Sep 2026 08:15:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02CBB6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:15:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75B911205BA
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:15:48 +0000 (UTC)
X-FDA: 85226779176.11.0F40189
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id C2A492000F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:15:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b0tjc5YK;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789733746;
	b=w0HXOv0afOkKjErU0/8RT71BfTXt7yZ4E8N8kgnbSTXN5Tn1memBqvq0hQvp+0J/NblLXl
	VP5QVzV45C1WvCF5lBnedLidrYT6G/+515CGCa1rtHnP3zmtTCupdNe93oFnDjd5Dg8DNK
	aRkUioCrFAWP1grQmbCKx8k47WvCEtg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b0tjc5YK;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789733746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NrjzlvBlcAthqMoY0nUVtb7DfpEhHoAJ1WT5vLNBdqU=;
	b=q7CUfRAbg9BX3NeJLkAkHPmZEtURfsntaFkimBQ3jaXrjfDFfYpXkU0BVgYnY/gTb0tQzq
	ZNz/h1S7Hw0o3qcw930j/9WjS+4bk0Hv54mA8rxIqhrCntPwNu13Yg1ZHeOJdW8Vn3aKvv
	AtnFRKh0rm6quXf/vVgxJE81i/AFXA0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F0D560A82;
	Fri, 18 Sep 2026 12:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA3B1F000FF;
	Fri, 18 Sep 2026 12:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789733746;
	bh=NrjzlvBlcAthqMoY0nUVtb7DfpEhHoAJ1WT5vLNBdqU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b0tjc5YKb5z/mOo26YG2o/5X179Uj+KYWyXsu3iTwmy38EFVW2xTdSCsY7VFz25sX
	 uDnKdJK2P0j0TlQ3ByPsfIIbcoezS/dPVZRNWXmv7Q40EnGOPHtmPtYI3Gqr1sZ3Ma
	 IwPuxefaqX+K9SJlDlz39mpeJ9sC3Z1PJvdBRxjG1j2lG6eIo8DRUBWB2twm3Uql8K
	 EmWrKZOPRO4/0hikl3b3vn3ZeOuA1RFeug4pnSZs6wOe9/aP5m5nSLKSAEyqJZhkRc
	 WHABB+17IQX5TjGX+SWBYc4B6UcJJJmYV7xeBHn8IJx0gvrGHtJOzUp9K03xVGyksr
	 vX9+IXrQ4tIIA==
Message-ID: <37e9fc88-4896-482f-bc6b-9023d4419783@kernel.org>
Date: Fri, 18 Sep 2026 14:15:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
To: "Liu, Yuan1" <yuan1.liu@intel.com>, Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "Zou, Nanhai"
 <nanhai.zou@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 "Zeng, Jason" <jason.zeng@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
 "Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260914072929.1883794-1-yuan1.liu@intel.com>
 <20260914072929.1883794-3-yuan1.liu@intel.com> <aqjfyGeQaL4g2EcA@kernel.org>
 <209de483-a9a5-4d98-bda4-7998e8fdc7da@kernel.org>
 <aqmVQeETYhbsl79A@kernel.org>
 <PH7PR11MB69324C2F3079B23F8E20C489A3872@PH7PR11MB6932.namprd11.prod.outlook.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <PH7PR11MB69324C2F3079B23F8E20C489A3872@PH7PR11MB6932.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C2A492000F
X-Stat-Signature: nouhnmqeqr4mw9y7tre66gqk5mz349gz
X-Rspam-User: 
X-HE-Tag: 1789733746-997654
X-HE-Meta: U2FsdGVkX18fG8NYrSWgnoHsU3l2wDHzvj27G45z9k1unjXGKyYLg0prHheV6qv/LN5lxSujK6RCQX3jZw7ksjxSI53VCk9frP/+L1H0JxL4GbMhpuZQvvwG06fnUm3zUi5SMWFZ2dvBwCccSU6phXB/0N5kaBl7XoHcrmbqDLa72AM7VMPbJLrxfXkEM6kQY/NIyrTukL0+/WPv+GXOe66jWBcaikBCfE13Qv5PS/Rab6czpbG0cye3JdMMxDlDAkKhWyF4Y1jYFtkr8o1L6yt1EIE3U6cmTKQ8siYeAt9YlW1kaZcEHd2RwV2gHPyRExnkRyChBNrVe4DqETtSYp+9AMPO0EbGAIRYyf8W1SkBKricsJwwinvf3ukM5iVrJt40xTDTw2Htbd3z0VHxUv9mhc6LmYP1/1ZUJ0RNSsV864Mv2TDMdjHOrroKRWS6Ol1BPp1p+4Ds1EoC63mLUeTTzmHttUHdBjjTme0ouYo1T26O5OHRfgWi1N53qAMJy3W38J5A9VTMDgWdi27vr9IeA9a/Gg+V23Jk+iiOFt3qEi5jX97ATkIT0+rfJrOUfdF8lVQvkYa//AJN74znDW1cH5+MVzMVwfNxiLDqgTSB2DyvrdUQJ0RqAeWy9xbIC3MYpVsznyLkjXqbAEtyP1YAiQUkgLO7pH/QA4vTz7TJrYI6D8pQKZ3ICe9rSneMGNa7nt4Fs7VoDVHbVky63pnd9NfLyfxs5ZSsFJ3ZKZNqVrGOThmF+8gEynWFnIFAMidu2oMRYUsfeB9Z4/vpYEXf4K0lcJYvSI8nAG7uHGD43Pue7Hoo34T2sryvXBrupsTX7/AIXB/i/tqcDSYjnizjgFVeKH+vTPbHD7aioiFGbS8KuVjNQbTWM32JV17jxofWhYOohcNwGrm3pjfEmUW1+aCtZouZ8br5/KcFCvi54Ko/4JQ8SF9PWKVDhnzgGRIHZ6iR8G8Xd0Jw50P
 BPbzekab
 Pk9Vi/BYQ690mqVEb/1jj1o8HPWaS62Y3yN8IC7/3zIkLb8WrCYkQDdBweNeHCS6lZ7mJfQqJh16hlamxqBECHAtQ9npE/p86wn+37lSm6Tzsqei3NLYXkpwC05ZMRYXYDLJNESBMhnJh5S08gyZcAF5qmsFR2qQnNpFQ1WgavqD1EEzLs5NAQ4BdoNFiOd2Ps8XE+doa0ZdpHaBaxhiwUgi7uJqQ8FxPVoZdDvSho1TF8Izid8WqncHtgI4wZINOA+J6/b1/iDRCe3rzmSo9ZMGWZ5q+NLBC4Z6KnCz8SzPnsIoMqjIk8pUkkbS/CzpA3a0ZvE+YGlVhaQchqxXFzjn9z3dVTrS2+Boger7TZgWLgZFDZFw0N40Q63PRYI7/95Gct6Pk70omh8ytsyKEhAF/7Sek3m7899dm5m5svOhN3oOTj8c+O+CkVgMLI8oQtxT+U3Owxj5lhORutrsxPpKxptWzqrWxr5l3cxd8Yj190I72pIf2V3dfxbJUHwbTb1+ZYycjjb6KLPGNNrn/Ycg5s+lMbcoPfaOaLiOH2ehj8ry1QD6kpge3L7nypQ3242Tk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 04:08, Liu, Yuan1 wrote:
>> -----Original Message-----
>> From: Mike Rapoport <rppt@kernel.org>
>> Sent: Wednesday, September 16, 2026 2:58 AM
>> To: David Hildenbrand (Arm) <david@kernel.org>
>> Cc: Liu, Yuan1 <yuan1.liu@intel.com>; Oscar Salvador <osalvador@suse.de>;
>> Wei Yang <richard.weiyang@gmail.com>; linux-mm@kvack.org; Zou, Nanhai
>> <nanhai.zou@intel.com>; Chen Zhang <zhangchen.kidd@jd.com>; Zeng, Jason
>> <jason.zeng@intel.com>; Chen, Yu C <yu.c.chen@intel.com>; Deng, Pan
>> <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH v9 2/2] mm/memory_hotplug: optimize zone contiguous
>> check when changing pfn range
>>
>> On Tue, Sep 15, 2026 at 05:20:07PM +0200, David Hildenbrand (Arm) wrote:
>> a
>> pageblock
>> cost
>> pfn, int nid)
>> last
>> spfn,
>> section
>> However, only
>> online.
>>>
>>>
>>> Maybe extending that a bit we could do
>>>
>>> "With CONFIG_SPARSEMEM_VMEMMAP, early sections have a valid memmap for
>> all PFNs
>>> and the sections are marked online. However, we might have offline
>> subsections
>>> in such early sections, indicated by the subsection map. While we must
>>> initialize the entire valid memmap, account only the online pages
>> according to
>>> the subsection map as online (see pfn_to_online_page())."
>>
>> init_unavailable_range() already has large comment on top, adding
>> something
>> like that there makes perfect sense to me :)
>>
>> How about a bit different version:
>>
>>  * The function counts pages that should be added to
>>  * zone->pages_with_online_memmap.
>>  * With CONFIG_SPARSEMEM_VMEMMAP there could be offline subsections even
>> though
>>  * the entire memory map is valid and all the early sections are online.
>>  * Count only pages in online subsections (see pfn_to_online_page()).
> 
> Hi David
> 
> Should I prepare and send a new version based on Mike's latest suggested changes?

Yes please. I guess this comment is the final bit before this should be good to go.

-- 
Cheers,

David

