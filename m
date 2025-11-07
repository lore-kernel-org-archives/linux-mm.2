Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D89EDCCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 03:09:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A988E000F; Thu,  6 Nov 2025 22:09:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3268E0002; Thu,  6 Nov 2025 22:09:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2301A8E000F; Thu,  6 Nov 2025 22:09:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 137238E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 22:09:24 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCEA11DDB0C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:09:23 +0000 (UTC)
X-FDA: 84082330206.12.DABBFDC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 87DBB180015
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:09:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762484962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=csSSPXipotmOZd+1cL+1q+eeuXMMlYtQSviBWOitwSc=;
	b=k5OL2YhVqXAlLaFMw1e3tZd9WU8alm62mcImavg6bnJz+Iky0005GqCQtByS9JZk8VDhyw
	54q6+AdNe7PKTFjWmIkkIg7SZ2rSzFAj2W3I1gmZZYxWBMRcotlIeDM6nAmIVBEJ//fFAa
	FnPTQucGgJKH0mXKPMvD4BaJTdxzUro=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762484962; a=rsa-sha256;
	cv=none;
	b=ej7CtK4um+CK0k2FXPoCC6DxS5de47djQdYjpk7XHW+Bh7Jc33ecZ8DV5rSG7NPrxKzl2t
	ighvnKdnFx5grh+rDCsnf79WG/IWHZnjN80tSgdp6nu0pZuu80yKF6RV2pNtGoXRSvvpvg
	g46eM5nmSKJGW+IeZFWdfYAQ7jSVrls=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A435514BF;
	Thu,  6 Nov 2025 19:09:12 -0800 (PST)
Received: from [10.164.136.34] (unknown [10.164.136.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 316A13F63F;
	Thu,  6 Nov 2025 19:09:05 -0800 (PST)
Message-ID: <1c05c28a-a4f7-4562-8799-6f08a03bd3eb@arm.com>
Date: Fri, 7 Nov 2025 08:39:03 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 mm-new 07/15] khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-8-npache@redhat.com>
 <7b6b5c6b-0298-47c1-ae48-17d603401bac@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <7b6b5c6b-0298-47c1-ae48-17d603401bac@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mzofdp3jqgjpqftmi1tw4go1efqjuma3
X-Rspam-User: 
X-Rspamd-Queue-Id: 87DBB180015
X-Rspamd-Server: rspam10
X-HE-Tag: 1762484961-278151
X-HE-Meta: U2FsdGVkX18ImsYBHhgo4R1RucvIs1MZs6A4GpWERtOuy3VqsiXEvlnPHFVgqzl0dcZICMw8lvEfddXOgVHDWPy+aeluPPSMsYCRO8IG2R7egk1axjyDDkENMxEGNoOESDCJlAVP4xz3o61XXmk5r1iOtnlx2FYLSQ7iZ6DNsregM2DjXjv9MQFByNgbP3i/pPNMj+ZvpU3L8raXPlWoRrS9Rf9wkqmsY6fcLOrxzOXOZCU+A4ffWz4AgTmC1nbQh6zOuaC0y/RZX76DWX6/XZ4ausQVH6HzRbz7FgZnwT2emiJIxFm3sYRhmAmz53dzwO6gYJWUkOyfg+eFo3w6SHOfBIV3Tsl0rS8ORJBZ4gppsqx7k6Xo88psubtxZsnY3Pl4WQ+H+Fk9f9p4gVIfHMvbCn+rUKQKxyYEQZGFQUUb9bplIGyzAP0+Pmlhmqy/asU7bWnUAqwSxxqviB70IhQfTMPZzFkRQLxHdi17mN34EZmUOJJ+aRz4LeDnDUDiW4y5YszbVLmmazTFtLiXtNESilTuDMAIbVZnI8joW6YzvQ6ZEyRrdcfYo3G7feM39PdsRklf9x+mU38R1C8lv4ef1rv4x+zi5zRtM16+5bHP7+oIG2nmL+h1865XK3q0S1Y4VwireBuw+jbMO9KdlAOfLfTxktYX0naAO4g6sZ4bOb1FlvJpNBAaD1Quw6627eyi/ir7oMPyvVxRIBqamfJpvJvhWuht3MFiakqgngTSzHWw8WookJv4yBfoKO74uVjmXCgkuREKKb4pVzgu7qLmttK7XNlUNQgCE2U2F6kNfBToBl6wkXbqY66KrELNqZayyRftPq6bu5sT5jKj42BMjhmX8mGSwr85p4wuX5vvQK9ME7p8mlmYd8dTGvo0CjQdrnJNaYfp0efAlcIy8AIXuExdrpzGS0ytCc2cDMzs0gllkFa0JvmpjsPQLtFqrqLuIstR8XenAbJPEHe
 ES5mWRdp
 BDBsT2etIVDc6rtJpksBmwW14XJy+WxdKnB/71Ha6S3T78apQN6JUXoe7RPiN+WNkZOf0Zo8JpdWZEOokKaDd64LhOaLEQAbiOmgL2/To6bGfBgtA7PUpDlfAPoFqidupuT0xrDkhzpXXIFfXmOGnZPjeTisdnEBJw4JxBqrk6c2XcBUQBue6TFzb9TL2R2DYaG23oDvjgHv7elmeB03M92VH/yt8BPVXP05wbei2iVJW9NF3x8aAyq+o0iGwsc7m/MoTUUdXLuKWHsg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> ----------[snip]------------
>
>> +
>> +		spin_lock(pmd_ptl);
> We're duplicating this in both branches, why not do outside if/else?
>
>> +		WARN_ON_ONCE(!pmd_none(*pmd));
> Hmm so the PMD entry will still always be empty on mTHP collapse? Surely we
> could be collapsing more than one mTHP into an existing PTE table no? I may
> be missing something here/confused :)

After this code path isolates the PTE table, we don't want any other code path
doing "Hey, I see an empty PMD, let's install a PTE table here". One of the
reasons why all the heavy locking is required here.

Also, I want to ask a question about WARN vs BUG_ON: suppose that the
race I described above occurs. After khugepaged isolates the PTE table, someone
faults in a PTE table there, and eventually writes data in the underlying folios.
Then the buggy khugepaged nukes out that table and installs a new one, installing
an mTHP folio which had old data. How do we decide whether such a condition is
worthy of a BUG_ON (leading to system crash) vs letting this pass with WARN?


>
> ------------[snip]----------
>

