Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EDFBC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 17:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2BB16B009E; Mon, 27 Jul 2026 13:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F02A26B009F; Mon, 27 Jul 2026 13:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1BFC6B00A1; Mon, 27 Jul 2026 13:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B30616B009E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:14:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B9A54014F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:14:18 +0000 (UTC)
X-FDA: 85035204996.13.A4E94EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5D5A8100005
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:14:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f7Bkg5ut;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785172456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PXZYw8Gybe5LquYB2iCkcrbQKyfpfUQ9febyZUXV6Dk=;
	b=dyqrE5knNv/TDvL4934dX3MA26LngXA2vLwGA65cm9ahux8rJhubKPzL5+1jGzSB8G5GcW
	OUk9Yuslm9k98aRAQQB4k++BaLkO/hbDJwhkZv+Z8v3qnnnaRykDpzdYUr6L973BL7eIUY
	w6sZOs/5ho43sCEDkQ+faML6Sj12H6c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785172456;
	b=spiv4l1Nrps0b1Jt0KLvC7GjILUAjGCVOWDo1VazCkQqO1br9lN70CF4NKjfYjYGl/5+yt
	Yp02f79hxUu1jXCjNMrd1qcFjRjutNRSxEuQcIStjmBCUTnQHs9qZuGlo13ktaWB4TCsO+
	6QqsBoCqon7vEwM/wp5xiTgQfcCctGk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f7Bkg5ut;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6AB42415D1;
	Mon, 27 Jul 2026 17:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F211F000E9;
	Mon, 27 Jul 2026 17:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785172455;
	bh=PXZYw8Gybe5LquYB2iCkcrbQKyfpfUQ9febyZUXV6Dk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=f7Bkg5utQljnDHBFVOvkdXOv86n/OfFwbNA/Th0W8iRELhHjfM8tEVistbMpHpchL
	 KPiZ0CKVo8BfPa1cvE0nwZNdA5fegYghyTotPvMnZnSp1mfN6OC53drv20rTlk8dnm
	 DS+dV7bmrqwjwS1Tu7eRSNBYC8AUUNpdzyQv6e18y+f1frUrJGp4jQmAA+HFpzRaoU
	 pXX0hDi9F+EA8VBh+v9N5jfgIAdT5DDwS0s8oVJt0VVbCZOxNDH8/7Te9q6CrTyrzt
	 +YVazGJMT7lUpxxi2/MwBfMc04ETlSURVmSQE15j62QVx9RBQNM1QUn8tA+rnt/2aE
	 IZSBNJUTefHAA==
Message-ID: <e462a3f2-1a29-435c-b64c-2876f98059bf@kernel.org>
Date: Mon, 27 Jul 2026 19:14:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/14] s390: move has_transparent_hugepage() out of THP
 guard
To: Luiz Capitulino <luizcap@redhat.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev,
 corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, ira.weiny@intel.com, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 ljs@kernel.org, dev.jain@arm.com
References: <cover.1784856856.git.luizcap@redhat.com>
 <3ab69c6a9210d2764f714a093eff731dcb55ed14.1784856856.git.luizcap@redhat.com>
 <a0be91ef-7e19-475f-ad0c-0f0bd14d3f1d-agordeev@linux.ibm.com>
 <cab6b125-f028-4d71-8500-5f7a6b9ab646@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cab6b125-f028-4d71-8500-5f7a6b9ab646@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5D5A8100005
X-Stat-Signature: ukofg8fcnpnqgc8uzdgz4ijjyxk8wgcm
X-Rspam-User: 
X-HE-Tag: 1785172456-351445
X-HE-Meta: U2FsdGVkX1/rFvMVxagbCUjb41VRiCn9pUQhxMbEwWN7ve0nobWRdolFT28uaWjFnKe1xZoEeeByApSPYAINL4gFAY9c9CRlEWgwWVRoK5Q5H3YQC6MkuRvDMhHJ+WoAz6aWuhWvHpieLbPD2kGdCTMe1M4muJDVOHPo5WDJe4bKnIyBGQ6JstLkCJr78J/gEB9oqE44LrDhaOWJ5eUrDj+GxRqva/rrALAL0paI855qQfBzz/UDND6287pS2tVPGn4x9blDiCeGa01FroXw5+J0iibg4t9lCnM8QjKYKdpecHh6ALc71EoBsztc51tR/mGObsTGQ6uUuUaJCwG0PxykzHwjO51fsO76WwcNJ7nRNneb943jtdHoOHINPCn1SD78uOZlw/cpKkvwwMg40dk3v5Maqu+FHkmXRKZXklTG6LAp7IznA0E+CNIQJS/AnyT4gAaJWqYGiSrgqMv5FUfCl3lreafRGIENCKSFofoy0kRgSl9LvBYIFhYn3BW0ph40GHZxnn4BEBWnXV31fewoKN5+jo4z60SHvtLgv6m1PTWZCSXCDBxWz3oPbPzXOfU2cwYvXvos4yJAKJxBRlUpnJz/MBhRKOYhW7ssG2DOltg3zrRQgaVXJ0mmJxVVmlpibgH+QbYJqTqqlOB5C3rIuub9A2gri7s1RK8LtosCZ9n04chKCI0GbC5j/rTXn+HygM9L/nI9fhLDVUdc1IKvz34G01TvEpwKH4hqshYwO2pkzPZe2qY6fr17mqmblo5zn3e5x2Xof3+BuMMPxgEdjx7FZ5aI65lz28k5rEozYOSMqlctjZXtbXyvib02mUjry1IoBKUyrDLrEwwGs3QLVD/e/PJvWnouIGlm51glE3a3fMnwIx1FXh3RXcsBBOVsLxE/b6kT3m+AkYbebgZFrnnJC8tBqLMeeCL2N5Npo78uHGcIKQvxPO/KT1HKlq6d5uXaarLgRzIAw5G
 TOFNtfmt
 XEHwKU2plbPXxTCsyDjOE557FeNCV1rKm8wnSiUUUy6Xp0u4s3CSpHhwi1vkTfvew9zzZeBaWaDX7N2hQE/bnCE8j/7EHt3S3uWeMiDa4duJesVw/m4JiIhgxYtPnpbzIWAHDIdEtN2z+DcCz22FY7CS9S6VSbeabm8kLqu3lE0khKf/AEEWrCf+y3ylLllHS/QAdimqqYOTYRmJPa7aJC4ZB2oFLnKit5OJU1a46ywOhtZJaO2qGVgRd+pcIjjeaAaDnHMIwD1WxNAC0ipvUBOnsp0xnZUwc2cq7fcK+vXikjcziIfgcd6QyNHkqbS8/+pa4WCmBvA9ac/U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 19:06, Luiz Capitulino wrote:
> On 2026-07-27 11:41, Alexander Gordeev wrote:
>> On Thu, Jul 23, 2026 at 09:34:12PM -0400, Luiz Capitulino wrote:
>>> has_transparent_hugepage() definition is guarded by
>>> CONFIG_TRANSPARENT_HUGEPAGE, but there's a need to use it when
>>                                     ^^^^^^^^^^^^^^
>> What need? The commit message needs to be self-sufficient or
>> at least explain why that it is a pre-requisite.
> 
> This series is adding a new API, based on has_transparent_hugepage(), to
> check if a CPU supports PMD-sized pages. The new API is orthogonal to
> THP and must work when CONFIG_TRANSPARENT_HUGEPAGE=n.

Alexander is asking for that to be incorporated into the patch description :)

-- 
Cheers,

David

