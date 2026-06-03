Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D1B0CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 17:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FD386B00B3; Wed,  3 Jun 2026 13:26:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4176B00B5; Wed,  3 Jun 2026 13:26:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311446B00B6; Wed,  3 Jun 2026 13:26:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 247D76B00B3
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:26:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6466162CDC
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:26:15 +0000 (UTC)
X-FDA: 84839279910.01.8CD0A91
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 358FA180002
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:26:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=EnMUBUXn;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf16.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780507574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DiMi2AOkr41lLQQ8lkXK5ScVvrndiW+3Zkpi2ThCMg8=;
	b=0CakgA15hZKLdRAD3kZFaD4U5kbNe1Ij5vn/a5F2XyvKKedBYWOMS1m11kSU31TWhnmLav
	0CHDyEbmfhW+kkiPVqx/Av1jy+SZHNQvLjSMnUGgmBbp1DzSf4yGIpbWLL9Uia6/8KZxfp
	WvaizUlqeSwCi/HX/1lIv3+HYFL+dN0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=EnMUBUXn;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf16.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780507574;
	b=k+YeYM0dpr2ER7omwtdYuJwa7YXgCNA/vADLgrq6AJFR8iiieAR3xVJ05XultKx/knQrcC
	X2s9grVa+KvDEWqeNZVFpa+wHP/hWW4XKTYjRY4ctMdnqvvXNBasuFhpR+CChHqc2Kk7i0
	n3zKhWHg1+/CpUDfU0paki7s+31e6qY=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id 928E120B7168; Wed,  3 Jun 2026 10:25:58 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 928E120B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1780507558;
	bh=DiMi2AOkr41lLQQ8lkXK5ScVvrndiW+3Zkpi2ThCMg8=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=EnMUBUXndkm6H+8pw74uuRu7AaBF6Y2P5UHSn671EYJ6AHspLIGBAjxTK0YnC63tg
	 a9gWzTZ1uhg3OfJ+IGfN+QTusX0nyLn1rYJxr/vxFjCDx91PproYwVJZZfVSXuq4sc
	 rr0JK382f+sPSDMf6vulEDPlcs/vBEF43JAe1mGA=
Received: from localhost (localhost [127.0.0.1])
	by linux.microsoft.com (Postfix) with ESMTP id 903BE307050F;
	Wed,  3 Jun 2026 10:25:58 -0700 (PDT)
Date: Wed, 3 Jun 2026 10:25:58 -0700 (PDT)
From: Jork Loeser <jloeser@linux.microsoft.com>
To: Mike Rapoport <rppt@kernel.org>
cc: linux-hyperv@vger.kernel.org, linux-mm@kvack.org, 
    kexec@lists.infradead.org, "K. Y. Srinivasan" <kys@microsoft.com>, 
    Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
    Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
    Pasha Tatashin <pasha.tatashin@soleen.com>, 
    Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
    Jason Miu <jasonmiu@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Baoquan He <bhe@redhat.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
    Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
    "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>, 
    Ran Xiaokai <ran.xiaokai@zte.com.cn>, 
    Justinien Bouron <jbouron@amazon.com>, 
    Sourabh Jain <sourabhjain@linux.ibm.com>, Pingfan Liu <piliu@redhat.com>, 
    "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, 
    Mario Limonciello <mario.limonciello@amd.com>, 
    linux-arm-kernel@lists.infradead.org, x86@kernel.org, 
    linux-kernel@vger.kernel.org, Michael Kelley <mhklinux@outlook.com>
Subject: Re: [RFC PATCH 00/20] mshv: enable kexec with Hyper-V donated pages
 and partitions
In-Reply-To: <ah_z3GV55RY3ZnT-@kernel.org>
Message-ID: <3197c9c9-9e4f-c592-bb7-ac422f89115@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com> <ahxrc4pTvVU20RTX@kernel.org> <f9d95fb1-ef3-d4a-19e4-afe7cdde5d1f@linux.microsoft.com> <ah_z3GV55RY3ZnT-@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Rspamd-Queue-Id: 358FA180002
X-Rspam-User: 
X-Stat-Signature: ztx81b4xxdmy5h7o99wdjs6i6ubqpon7
X-Rspamd-Server: rspam09
X-HE-Tag: 1780507573-917260
X-HE-Meta: U2FsdGVkX1/EsfezpjeV6sCH+eJpMBgrUS2IE5EsE2C0KxrqZ3kI9tEsqVY7rvF4puxX9xkLsllsfVh6JmhwShgwELSDn0oBCrr2RJkDiDsETGbfgIso9fL52zUYDvpGrjlyNkHHMi0gss67iVz6+opQFhGWeQnuKpQdYEks+0ALp0+Gn+NOvSiG1zQKox2B2RRxg8/7mzlZCLr0T2MzpfXJkhj67W+p2VRRcrQzIm2OJv6eWOTW3W8bmXQ87Txwg4wWLN+qyM9NcA57rQWS155zlo9bmSxTDq2M18+bePN8Tkc3ZSEiyqAShBsIrVP4yJHhxOLeUDb3+dIVnf323NjyM4FCjXMXmGf5BFtLQBtE1QKUWasQ/wLUIfU4iLL1LQ0YvmxaItY925ZwUTDjzQBzpRQ6WG3w+rhsG9cQqGgBZWOVTNuJtdPI2bn/jKIdrACC6CRmjAbfM+T+vNwQsD1mMWf+e4jfAHmLvFvkPRI9NTsaSJIOEezOp3O8fDx3JqzjhaLyrFNQJdTqM5aCKsq8zzPiJzCy4P1qMqLl98F5EZGxfAdUjIU1oEw0Ogd+gqZ0myp1k3VSO5DX6v8hPkvOAcRlcZsfasMFmwge95RSNh/yq1uFIYnqP4kXRHv3BoUuXddnQkKmFb9AokvoJxbSR5gjM9K8hBmdMdT7Hu2+5YYss/330xyaHJw+cr6ObwwlwxW8t5JXJZtuRhoT+CfchYR7+A13ZESEl5cLvPyCg1F6qPeMMAnvGwBmYXAthLXvw8uJ/phFWKjCvnQCmlPLUVFznzu7z3EOTj5utUZAXha+K9n348XQiGFAa5jYt5rFU3JJjI7x9WQg+EwR/VJrN2cc6D21XS6H3iKXHlubmJLd1pa67PjtAoXJQEk06MMm4w1aJ+yrIVDELJZLW1ql/VEvergnVsRUFv+t2+cbObM+h9j/Zo3ieqOsyAffqcWrCxr/FUniwrSzsvG
 ewY3TkDX
 ipBzb1hsA8Fl7uSdVxdCjYk2fWdBKZGj8ncZFkVPAE9xmwb+1wJ2PVmxDq4XM7FXQWh0/NnQ9yXDqBS5JDyemUTH6csWo0Nu7ccrSLXuuREMtQdLPOwxkLhB5zkleZwi+IByx7L+JxJKbsLiCy3DwiEp+4d1p7gJyJ3t5tJTAsaSzPBDjIYtiTCUh69t831jbgHsP/y2u8JHgGTGgqTwnK9NO/Q5LHduUYJxAp26mTiaFk9xxZ2PeAEXJXUZ5rqKc2pOgtzxW08t/dnfnOCjwQ45VzppzgjPW+LbR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Wed, 3 Jun 2026, Mike Rapoport wrote:

> On Mon, Jun 01, 2026 at 01:09:41PM -0700, Jork Loeser wrote:
>> On Sun, 31 May 2026, Mike Rapoport wrote:
>>
>>>> Patch 19:      Export kexec_in_progress for modules
>>>
>>> Isn't there another way to differentiate kexec reboot?
>
> There's that "kexec reboot" string passed as the cmd to the reboot
> notifier.
> Maybe we can make it somehow more well defined API and use it?

A string? Dear my - the compiler won't flag it on an API change then, not 
ideal clearly. What's wrong with exporting kexec_in_progress()?

Best,
Jork

