Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03228FA0C47
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 08:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 380C06B0092; Wed, 15 Apr 2026 04:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332356B0093; Wed, 15 Apr 2026 04:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247D46B0095; Wed, 15 Apr 2026 04:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 17F276B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:00:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BFC088B3F6
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:00:21 +0000 (UTC)
X-FDA: 84660042642.29.011718A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id BBF30C0008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:00:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KfxA/Ood";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776240019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NsQBjLj8krqs1WBtci0M7iLrloMzqy1peOJ3cgXRXAw=;
	b=PogN038ESRXObwfpOqcH5cabYUVocpzexugTLFp31ANP8tNtjzMU0mUXAaPv6EywcT9uxB
	vgvdPOMGIQ0VvMxoU+MoP3/jaSl8N+tV2NR8BtaDGAcBmqe4RE60UmlKvtMjONzeIS8slJ
	MnS0mKFk7iA5ChiL2sfon+TyGBXs7jM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KfxA/Ood";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776240019; a=rsa-sha256;
	cv=none;
	b=WoE8wtolYv2Lm1ii4jXtOFVNudl5tU6sTzqCvrWcl3olDLl/FSRK1gGI7lsEkSPYaV+DSz
	2FPGY9Hy3tXuzpf/PsQg6PgB1B+gxJpo9LI/9ffz/VVeNoT0UTZkNch90wtxIC3WSzfvBP
	aSxLJ2u208jylau5Hsl921mgdLxc8Nw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 14EAB600AD;
	Wed, 15 Apr 2026 08:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B568C19424;
	Wed, 15 Apr 2026 08:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776240018;
	bh=T2jntT0X/pK44/JuefmgfMlW6eFP7bkoZpA49cK9uzk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KfxA/Oodk9iFPThH9dvnsW0pNj0rSEFWsWZrrXbStx7TwcjvOfdVl6LBAMu6VMYIM
	 vZLYipHy5iDPVsZ0PV2nxvo5ApSwiDKQcSZlJka64lVYH5FrLKO8Fy3TZhlNUG9nZ5
	 txARWZhtjLkuToUr+dheN8mEai2lnDZB9dh6FydBx2pN7L2d0vfHvpLolcO1+2IJgT
	 kemlrdslr8XbMPBnBmoTDOsGK/u3KPM7Z1Rihv/RGFH46uPluCHE+XtjV9JJrweNVh
	 I0kVRIgC/CMhJmNTyk373OUVOkXwqTBLb/UJ742PWR9qFVNgPZSxUKYvhPXY6fRMh+
	 0O85NXbSjY3mg==
Message-ID: <afe0dfb9-feeb-4243-bc4b-305e5e33b581@kernel.org>
Date: Wed, 15 Apr 2026 10:00:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 05/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
To: Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>, Nico Pache <npache@redhat.com>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-6-ziy@nvidia.com>
 <ad1TMjF1L3usYIC5@casper.infradead.org>
 <05F00072-7E06-47C9-BC26-FE3736F557FC@nvidia.com>
 <a4d477a8-71d8-4219-9cb3-153f2c01e184@kernel.org>
 <84B8F641-A3DF-4219-AA57-6BA48E9B4998@nvidia.com>
 <998c02b6-2612-42c1-8099-d65ae275d1a2@kernel.org>
 <7468C68E-FB09-4714-94A3-4BED63453295@nvidia.com>
 <b7aa5515-6908-4ec6-91e9-eb79d5ef70b4@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b7aa5515-6908-4ec6-91e9-eb79d5ef70b4@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BBF30C0008
X-Stat-Signature: hdy8ap63ipnj4a1kqe3g1yi1xhchfib7
X-HE-Tag: 1776240019-805276
X-HE-Meta: U2FsdGVkX180Oro08lqNmqyN02xFsIJjajEf7ZUAgxk0YbfBLEs6orqKpw/iEzt4p02vN52ueHzLerH9QIdx68gcreEKj7jB9slQCsMLtwLhUmx4A6aDfe2x9x+L8VZSpGqZ/3QivMjCvBZPWdkVEOW5O1hUVdRE83HtYBKTJdSP+j6B7K7E006yMYuhwhyzfvLbRmxIrjME2lbnF2x99et7U8c+btURcVTMMMGQYS4O2o0cCViApiYe/fpD3j/hIi6pAqiLry0TPRo53f6UagsZ5aw5WGErtFtxaq4FLg9wslbHHf8Dw10WLiKaIX06OnPDyXYp32SzvnCvmhMzbmVwRxBmkeDTAIZ+ox+GmyoxXyX8Zx91DXMEBj9wXBlOkfD/z1Os7gDxlSwdHXmprijA2kwUdkyj+9rWGH02Bl4sjn1+kNA8db1iRFsQOY4131D/yohwBkHNIUACQVIokx/JIAcMDjwA2YLqPhcUi6tkDDmTLVFicVhr2wXvyr94tNHFBBX+sw5A6nrsz3cuTeWb6bT7G6mEwp5IU/kPgvI1Njmkrd2NmV0YWJ47m1X3CrdKh+z6qhDlrbf1y4NE3UIbT2dF7cPP25A/h4fOGBAM/ffIYM7N3bD5z/y/tUgNeara0C+ygKY/AEOOqYo3leVpAi27NbsnJ7+mZOuIj3Q68AQ34I90pIRV+WgAa5dqDLIqQT+Bchfw8Cpvhz0QDl2XOtp2e661SzG8z9sjhrcVNKTuss5ke1kIMaY9PbylIujzl4I6aTRKf7JEHn44f6+NNUtdOKyA8OFavIkQfM417g0Iy4dg8amrvOoCstuUCczrQ5Op9tcqa9XhHEVbGfA/li2/6to3nLXvRt9u1bieAGwt7JrsjQjeb1gICzaapYJOSJuyCbHbsIlp+PW48D6dAcweYqnD3mnIEZNa9uj14eb/PLV6mr07HxsCKUBwybJ1OV+4XxAZqQTIXHd
 36/Vkdsv
 TDFu9rFX8JRbQO8kMqIj02pxwJl6pOlUpnGgJgbyz1HaGEATNpIatB2ppxjVuZF8H5Omzin5JvTylRKY2+1Si6CZdqWVROOlnRpBBGk+DHyiJx/g//ZritBVaeGrF9uLDKpGyzIqznR9GCzSBiu1orgC15hruiCK1jVC0tlqLrmDfJM37+23RMaDXR5mw5AXe28HaFQVbxIrTuOHZ+Bo1Pb9uxcO/HshL+a1//4lp4uS07i/FwYXJ1QBgDYyEG3UEsEtBfKPuOr6U7VZPg/ORMQr6/XWoL+/kgG5F12Cl7ipw4dKH7LBYx48iVC74NJ5rqdrVcEPSXUH2kAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/26 08:36, Baolin Wang wrote:
> 
> 
> On 4/15/26 2:25 AM, Zi Yan wrote:
>> On 14 Apr 2026, at 14:14, David Hildenbrand (Arm) wrote:
>>
>>>
>>> Yeah, it would be better if we could avoid it. But the dependency on the
>>> global toggle as it is today is a bit weird.
>>>
>>>
>>> I don't think there is other interaction with FS and the global toggle
>>> besides this and the one you are adjusting, right?
>>>
> 
> I'm afraid not. Please also consider the per-size mTHP interfaces. It's
> possible that hugepage_global_enabled() returns false, but
> hugepages-2048kB/enabled is set to "always", which would still allow
> khugepaged to collapse folios.

The question is really which semantics we want.

Right now, there is no way to disable khugepaged for anon pages, to just
get them during page faults.

And we are now talking about the same problem for FS: to only get them
during page faults (like we did so far without CONFIG_READ_ONLY_THP_FOR_FS).

-- 
Cheers,

David

