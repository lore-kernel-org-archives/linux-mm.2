Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 146DCD10F22
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 11:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E97B6B0008; Wed, 26 Nov 2025 06:32:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29A796B0023; Wed, 26 Nov 2025 06:32:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AFA66B0026; Wed, 26 Nov 2025 06:32:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09BD66B0008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 06:32:14 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A064789832
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:32:13 +0000 (UTC)
X-FDA: 84152544546.12.25432AA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 858241C0006
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:32:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764156732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TfuoH9Xgl+vTZlIkPCsReAqYYQoglEg4CjiwE8eID+A=;
	b=6GCTsJyeBMGCBEGRvRIEtjFD/BY9ppOvTyCzYPnh2a72z6gpjOxyCHVCmlhCMAAQb0GRsL
	yMrNZITU93hTCNhc4TmpRL8PvFb0qgb6+C45FPosHB1dD0BDubn4D4g9QDY8V/bC96Jsj4
	lrIGf5sGAOs1Z8uAgJ8Xc/JofRV1y8A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764156732; a=rsa-sha256;
	cv=none;
	b=Dzb2KJMb6UfALsgoQC6XPr7cpzzoj+No+4Syy4QlBOjo18+PFdEU5hzEghfitU2h36JVOY
	I8t1iirxSG/RcFrOVBF69kI0cLG4dPCFHOJ5WAJ9YTiVPtl9NNF3SVMxk4voH1rPKc4hP9
	AQCyblhe/k2bIHrn5kIzhUyglzuQFG0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 065BF168F;
	Wed, 26 Nov 2025 03:32:03 -0800 (PST)
Received: from [10.1.33.153] (unknown [10.1.33.153])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7E4543F66E;
	Wed, 26 Nov 2025 03:32:08 -0800 (PST)
Message-ID: <a52ce72a-f762-402b-b353-7c3f69e4d28c@arm.com>
Date: Wed, 26 Nov 2025 11:32:07 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: use standard page table accessors
Content-Language: en-GB
From: Ryan Roberts <ryan.roberts@arm.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev,
 Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org
References: <20251126064723.4053-1-richard.weiyang@gmail.com>
 <506e7a41-a199-461e-91b1-035ebd5d5527@kernel.org>
 <323987c5-aecc-40c2-9837-9630186367b6@arm.com>
In-Reply-To: <323987c5-aecc-40c2-9837-9630186367b6@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qu9yd9rfwoxq1wqfgj7nt895rbtbcn3e
X-Rspam-User: 
X-Rspamd-Queue-Id: 858241C0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1764156731-676663
X-HE-Meta: U2FsdGVkX18Mzbu7NXs0I2f9JmEpNAfortc5Z+WAo8Z2ZYGYO0F4H2YMi+tbLPgZQygnhQp1UaAW16IjGLKyts9JVH58sjOpJiF9lmaBd/2yaR2jlrU9LZLMy+IEvvuJLsSF01D1Q1FWMPvkjrar40GaJYMkHYtLuYY5ElhbXvGdCCkqIlHlLLlOhI8ETQt+T/OXFavsC6oPSZGiofqvtNisIdHcLchXCfY1lXE2yb7pXsSE8xYvaS3jjyJduV3WXZ0edl4hNzoxo5rR8svQWMCbss7gqu4ZXjp8hlYcYkB2I/4noMODrHVwpao4RgiK4xbBFqlCQWNWz28vUIVHJgximpPXM8laV5WLxFRgH8bJ6YNiW3M2qjGhB20y3IncL8eOWk3GeoKBmrabEW7Sas+KTLGYbxqayklDOstAeNpU9N6P2XtZ/XeeU8UEjqXbcXOlMgJ8TbxYt7C/DJBawD0fmP/zn8H9pt+Vueivc6rIZN/gA8B0pdTj496v3Eup1+iQQMnfyoikzG0goUPc/SfbSSsrmIJQo6dLxNGPjcCiT9fMKLk+uT+6ii5KBNpbT7RMfKvSpQBA4ILxocSNS8bDGPuzKJITGRR/qNTaja9e95w8huPtDCzCZYY54Li/wgssOtw/im1BOHclrtLgUtvrrsk0Bh3R2qcWmtk1O0W7n6SXPnPRK0hcxASVp8mKG35xXmDT+KCeRrP9n13cL4uzTpdx0HQrA6XPaTFxXcoSibmCRl8P1C66d29x3vJLx9bjbzqDguzNwvGYS7S87jA2fDbf2AMtoYtRk7H+/mbbmn6+UIUFuGaTRCNE/6zMybs7KjSQwzeQly7A59/d56ppNUKyrRERGIFSKKvnq5G4n/YOFqjPgED34WFH+GuoLGwdRxna0bIPlSBmRjuL4Qg/IlZDfREkiZnTIW6CDcpLUvjO9r/j9BvZy14+Dlg+p1yvbkDZ7nZQDx6vu/Q
 a7mQo7lL
 UtbkEjv7xZhaqd+xsZ2QnNG7FZQYJxOoygwholhBS31T4aAuQ+KXO5Ox35Bu175d/fqzZsuieebhpeQ4KMXqP4lBU1mJbu73GAgS3a+VuZOe0SrJa3iLfCN3KYgixnHeef+TVDqFhY5mVxfJXzths4wd/FNj5Amj3jK6q81geKWa5EDg7Rktd5xGkAnQpdHEoRWW2vu6MTfkOZf/kqwjOUy4fq+gnO+kLMts1Ge3i9T4RcBxkbHxjbX0iCof4u+bAfGnMvdUY277hrfcUW7V4J6OlSCytWLniRibuozvTtOI5CW4EQDLnXAn/oGxKZqqSTiwp0DefcCuzlbPQVTAVwUhvy7mXtIWy/TTDdpRk+VNpYTYRekeeeyLmZgeQSnpmt9QKhXLZOQa6vYPJ2dbC/nEk0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/11/2025 10:19, Ryan Roberts wrote:
> + Anshuman
> 
> On 26/11/2025 09:09, David Hildenbrand (Red Hat) wrote:
>> On 11/26/25 07:47, Wei Yang wrote:
>>> Use standard page table accessors i.e pxdp_get() to get the value of
>>> pxdp.
>>>
>>
>> Isn't this covered by
>>
>> https://lkml.kernel.org/r/20251113014656.2605447-1-samuel.holland@sifive.com
>>
>> In particular
>>
>> https://lkml.kernel.org/r/20251113014656.2605447-7-samuel.holland@sifive.com
>>
>> ?
> 
> Ahh this is very interesting - I wasn't aware of this new attempt! We could
> benefit from this on arm64 too.
> 
> We have some experience and opinions about this; I'll reply to the patch with
> some details...

https://lore.kernel.org/all/02e3b3bd-ae6a-4db4-b4a1-8cbc1bc0a1c8@arm.com/

> 
> But as for this patch, I don't see the value in changing just a few instances.
> I'd prefer to see it converted systematically, taking into consideration all the
> complexities.
> 
> Thanks,
> Ryan
> 


