Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F32CEA3F2B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 09:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA54F6B0005; Tue, 10 Feb 2026 04:34:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3BFE6B0088; Tue, 10 Feb 2026 04:34:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D491E6B0089; Tue, 10 Feb 2026 04:34:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C4F046B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:34:08 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EDA7B58EB9
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:34:07 +0000 (UTC)
X-FDA: 84428035734.07.5654BC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6CAE740011
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:34:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B4HtHCRB;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770716046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A/06mJgJ45vuGrq+XesXj6Nz9yCBmfTcNU/Kk2Wzino=;
	b=zRA13QdySW6Exu/cFXRdsA/wRd1JpPpiInAk5uNvcj8zvVGvIpvRFHBUq2eJDSwZ65903O
	CJK85tggF0KQsO7PFBUAYw4T2pZf+4jztQZSwS++eo1XVEkk8er6x3eSh1XMCLPtmOUse5
	A2QrA/L9IcqBigqroB6Pnj3JnQC81P4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B4HtHCRB;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770716046; a=rsa-sha256;
	cv=none;
	b=09ynwijnmJtTo9gtaEorOcPvhZk0goS58mLllSGqOa1wJLg7kYAFlmd3MAgUmcECWY77gd
	IAeCc4OCkVVkrBGZJM+eivBll2hlhJ99PodopILQkBJn8n/U4Qi3Dn2OeNxfB/H1byOiXd
	bXX4heMEStAFiuNlyh/YmteYiTTVjEs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 027ED60123;
	Tue, 10 Feb 2026 09:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64ACC116C6;
	Tue, 10 Feb 2026 09:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770716045;
	bh=kHOevYKx92hrqdv2N/RAdoI8D2Phsjefi4Civy+4aa4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=B4HtHCRBLN7Jix6BfISAxclRX1styTbisNLFoESjhE7h67PhgXM6TQMJR4WuafMI8
	 lUkwsjc86dPizQU3zLGN55KxTC22rTFoM2rqCj1vwLnQECh+r+GcDY7wQPQa9XWz60
	 T3jvFE3KDvl2Rzz37rN2xK+ZeDBIyMip43Yge9nH9Jr30APRiR67CAiEvomhpr6OkA
	 C6ZJqQLeHsLsV6zMfS3ismOHcFqt1zlAc4yxnfAIh+fpRwVPr6czDrmkDhTGWEe7CF
	 f/YFMhGUfX1MlLiEZZWYv0UfNygbKw9FoL82+KkxGUYAE8Ms3OxemEP2Nf0tlSWg1g
	 1EL5Yz1ahiykg==
Message-ID: <d986f26c-ef14-480a-aff2-6c7fe47d1da9@kernel.org>
Date: Tue, 10 Feb 2026 10:33:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in
 file_thp_enabled()
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Ackerley Tng <ackerleytng@google.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, seanjc@google.com, pbonzini@redhat.com,
 michael.roth@amd.com, vannapurve@google.com, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
References: <20260209033558.22943-1-kartikey406@gmail.com>
 <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org>
 <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org>
 <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CADhLXY4xnf0DuOzMhS-ewmsrELgmtavG+QxQdFsLb+e_tc-09A@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CADhLXY4xnf0DuOzMhS-ewmsrELgmtavG+QxQdFsLb+e_tc-09A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xazx4bqqxgtfctqiihr4hjd4tcrpw9js
X-Rspamd-Queue-Id: 6CAE740011
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770716046-493465
X-HE-Meta: U2FsdGVkX18uMW9jzqYjcoEBUrX2tZqI0mtRtlPxqV/Ts3CGJa8zM6jAhwLEcbsPAB807wG9inm+2sTpNCyEfQCC/sDzewqarh8nygrpuYnjqp8iyu+AyT8vVsDH/5rDmXn4PfmzXCpVa/SeHSQhczUMrD3G1cKfb5SQIjbiyMX09CCDRSaD+vpEs1jdZUApqCCuvClH0SKhA/kgxxa+lIOOvQpDfQQ8tq/bY0lvDWWHZWz6/E9zVBwNwlAfxNJJoAwy4L6LzpepvxrJaL8ZCcJr/AL4aFu5IcykuYFIO8GpMYMNlfq6SnAlO8hQfykdYMr52C5e30s+b0PHYurWfczjixlc9DR00PK+I6a8SFL3LX5DASwQ4jjkhhcKdSyCXDdjXRaBRCmRaPqLIVy3cTFG4ZdveDij7dLiGZRgdPzziL3znTC8+aDv6sIr84yWcCopornlK45Sf3xsFQmhTg39b9/5AqoIbFr/m2LiG+s93Lf35wYHC4BTaTmoYGIyxgyO4IIqkBkF2lMp1KfdcgLyP085SOJP3mDVrNsGp2FdJlOOnbvdXZWphGUitim48jinwUtTZL2zeZp1YWe3BqO4V7J8RKU2JPuIP2pZwXnnwpmZzJUeGD3hD3s3AcIdxl/BLSz1Muqs6Dh0XpTme2nhug5nY4vRtoER9Z25i0xV5HSQzQgMR0ol7Qe08bewGJoiwnrcIVrxQO4rYoNwEPlkqplyJ2mAuNmkFYP6j1fODQRujcEvqoT6OtTuofHAk6KjuFJUHzwVOal60wd1cQH1bP/b3Dc2ahm7xYpC41Q6H775clbojQzM1b/GJIPpVncc73/wP30CEWG6at3Ebr5dR9yLCwyvkGfr0wy235g9dPDhwAzgejQKW4Ey6DhLYcS/LEJuJ9MguAXg0gL+OiPp/XR3pzi++mba+fBocijH50mVWdUHMZa57P/N6i3i+QrkjP/uo7+o106pANk
 InZpHtzT
 KQDFJ28LzX7eCNnhsK2JDucRgX3mUL/Za9at87fzRQ1R0Ah/X9Y2vQjIVsC8am2Py4WPdFoB3O9TQr6u7xwv5seXl/b7o5r4KpnZFQC6hYURb46c+M1qcFCDoio+5LwzQ2QiraGsiclC8Xv4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/10/26 02:51, Deepanshu Kartikey wrote:
> On Tue, Feb 10, 2026 at 1:43 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
> 
>> The following is a bit nasty as well but should do the trick until we rip
>> out the CONFIG_READ_ONLY_THP_FOR_FS stuff.
>>
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 03886d4ccecc..4ac1cb36b861 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -40,6 +40,7 @@
>>    #include <linux/pgalloc.h>
>>    #include <linux/pgalloc_tag.h>
>>    #include <linux/pagewalk.h>
>> +#include <linux/secretmem.h>
>>
>>    #include <asm/tlb.h>
>>    #include "internal.h"
>> @@ -94,6 +95,10 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>>
>>           inode = file_inode(vma->vm_file);
>>
>> +       if (mapping_inaccessible(inode->i_mapping) ||
>> +           secretmem_mapping(inode->i_mapping))
>> +               return false;
>> +
>>           return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>>    }
>>
>>
> 
> Hi David,
> 
> Agreed, using mapping_inaccessible() for guest_memfd and
> secretmem_mapping() for secretmem is much simpler than introducing a
> new AS flag. No changes needed outside of file_thp_enabled().
> 
> I will send a v2 with your suggested diff and test it on syzbot.

Let's wait a bit until we are in agreement that this is the right thing 
to do :)

-- 
Cheers,

David

