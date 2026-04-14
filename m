Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1FF2ED7B93
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43BD46B008A; Tue, 14 Apr 2026 05:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EDA56B0092; Tue, 14 Apr 2026 05:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 302936B0093; Tue, 14 Apr 2026 05:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21E636B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:46:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C1DCB59031
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:46:41 +0000 (UTC)
X-FDA: 84656681802.20.DAB254E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1219DC000D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:46:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kIdLQ3ob;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776160000; a=rsa-sha256;
	cv=none;
	b=COxQq43hdg6EZMRL3Th6r8S5G0qAaZDkCviryZiI0OMoMHSTHTczLvLLbn1NsrorTfqP5A
	jUKbLPg540QqBzeOz09H9OT5ueNmTB5775FgDhFskIgZ6IAGWqODexp4ZFTwnXU6AKa2cX
	0DftC+TTSnhZ8GGKPYb/eEGhiAXUeNo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kIdLQ3ob;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776160000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+ojrvB4BTWWqh51OvtYEnWfG/Msa2Gmxn3VW4+W8AY=;
	b=N1RzC0nunOIfSL09Crtu4ozI7R0WNLQoyitN+ehyWJ1jJSeKuC1Q2DbgmYx/gNmftqfoVa
	xz273xdkRLM0NtONEWIUMSBXoo+Mmo0vqnulQh351gGXDxC5MPKn2yA11MrQVWTb7Xw/IB
	Lu1VgVZVJXGUKsnd93LJ8xVX6ro6Vno=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C10F60018;
	Tue, 14 Apr 2026 09:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C87FC2BCB4;
	Tue, 14 Apr 2026 09:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776159999;
	bh=6sEhxOOE1Aj7pCDiLrWqUUaqum3nPTJ8S4/1FTOMZ/k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kIdLQ3obujLEplnrv+jkqgccCFd1D+wekSsoKKeRVxq80FUf2iFHPBipViZo/dXW9
	 y1ET3yZgrUSmUaN8Bb/Qypty2L5rzXf8S68UhZgJLjqxgEUlotzWXrqV9XsrdvQWT5
	 FHynNmxIcfiCL9HnuUa/UCKSCVr6RMPptdukwKOl94rN0ISUMn1xrTu7CkvQ8Hom+N
	 MNQKqJzaAhs2WZDHpV1Q+JQKAy3CZxghj04bLBcb2PkWq9g0xX1EZxZscGHZbNfRv+
	 w+HHVNvNG7qir8DdWuko87cWdFx/G8hJMMU1Ws792PDSQEBXlleqDsRvJn0yfFF2kV
	 MHWV6y0Q8A81w==
Message-ID: <e9db5e85-1f8c-4713-9a2b-91bfd20a50c3@kernel.org>
Date: Tue, 14 Apr 2026 11:46:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: fix double unlock and remove dead code
To: Matthew Brost <matthew.brost@intel.com>,
 Sunny Patel <nueralspacetech@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260413130927.13263-1-nueralspacetech@gmail.com>
 <ad18sckPDwMDUtIo@gsse-cloud1.jf.intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ad18sckPDwMDUtIo@gsse-cloud1.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sx3akh7wy1dnasohfn4j6mcd43911b6d
X-Rspamd-Queue-Id: 1219DC000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776159999-52385
X-HE-Meta: U2FsdGVkX19ac0MkrXVOoXeU9URKt4Iq9WxCabXdVyj4MwKXc/OfzPU4suiZj5Bdlsus+qhhoDm+2nLFEhc7kF+A4UfABIkX/71075C0c6JuqqX3rLhqs/kzSIZ0BMSJ4/xyAumXSasZeGUfLmzEghdyjkgC/nvHBR/8BR83DeUAmITqPVhiZtFo8j33GyMB2dX5Ek9xUvW0BNuk2oPzKh9V0jCUO2FWnnGHFUjWFd9kXqtozANtlLDf/uPSkEo7AB5Es8BxYU0x82THpCCX2Ungjh8WJyiBGDTvOakxHM3rTz99nSSnKi1lgJljR4n8mG6FXnn49sZTN8T2+2ykwqv+6S57oOLl/b2C4B92QmJ4RwI6FP4ET7ciw29Y+bP/JUzVtGofkZKgXleZYg/sXLIk3dEGap1+CSSbnr/CmAdnspQWLFZQVPEsJLUUguh+blYDhpo2cWk4p1F9C/uNiADm3lghMCN52xAFek4PBo3lPYoTkx6ZqxBCGl2/oFnpS2XpoXokmGHGGml+macbUT3hYUVRSvur8Gat3iICTfkMEC38oy32khqzYLiY8o8DnG8HWFloXA83t+C0R84GPAV8gLIwaLGM6ef0AZvA0PgNQ5UKlZZSu/Ilczh/CiWrabC7adyrY0BDrUcanqvlgDJSyCiJnuyFH885dolovsJg7BqZaOQOw+oO4YTcWiMxnWuxtCVK1OyqZw9OjIXPvbNcoT3WfySwVqaXnaBhF3oV+gBwalEgWvCeo8qHJuciG1LlpIpTNyyf+8LwOKz+czSQlmieRmioZMkWKrE+dJ+GFvdgaKlbS2H/gGKgo135F0/y45V8xKC+mxNmd7PVKvEvrmmcZI0l/rympgr9uXN+mMrwyTfIQwFEM6N+9h+P9++MAiOLF6ClQQZl97Gix/np4gzkuNrau/aXyc9yckGnD6dBa95vQTNI+I9j7TQmB2lB1WbvbVlsQDCDcmh
 jubdImuw
 wLXdeBDbtKuWbEaijmp7nyV9UjBA1btprgDQMULz31frZJYuO1cg3ExE7mpCv4IePTW5j8u8PbytTR8hZoXjF2sM4ter8lXANoXpSAvSU8W3gQkkmeOvWg+paPsq8PjrbCjvyEVxyZ3xjUteeOPAT7zTfOfBV0Gk3tk5KmuBpwTs//rynBD1B7SpM3IRfjRztwxa2HmHICpr5noyQE+pdZ0axJGzh3bfuOKJKwngvnMl/33ERmS6HpwodbifCsZQatzqp5SQyANabKkbZQ4QWfBiMOl0u48EmAsnr+NqWYxJcYWJtf3Zrj/srVT1f50Hgt7OKxe5J2+JhsMYslpSTxWJXD1XJSdL8XwJI1WgQe2HWpHxLqPjm5N0lOqdhNgpJxa/z6FS3FTJZ5SYHh/gg7HFnEMpcfXHo92bPLSMQeoRiNQFfrCbUTIQnIPJft9y4o+K2Qg9ztFAL33U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 01:30, Matthew Brost wrote:
> On Mon, Apr 13, 2026 at 06:39:23PM +0530, Sunny Patel wrote:
>> Fix two bugs in device migration paths:
>>
>> 1) migrate_vma_collect_huge_pmd() calls spin_unlock after
>>    softleaf_entry_wait_on_locked(), which already releases the ptl.
>>
>> 2) migrate_vma_insert_huge_pmd_page() has a dead else-if branch and this
>>    branch is always unreachable.
>>
>> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
>> ---
>>  mm/migrate_device.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 8079676c8f1f..0e005c26ee88 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -177,7 +177,6 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>>  
>>  		if (softleaf_is_migration(entry)) {
>>  			softleaf_entry_wait_on_locked(entry, ptl);
>> -			spin_unlock(ptl);
>>  			return -EAGAIN;
>>  		}
> 
> This entire if statement is dead code, since we bail out and collect a
> skip on !softleaf_is_device_private immediately above. I thought we
> already had a patch from Davidlohr Bueso 'mm/migrate_device: remove dead
> migration entry check in migrate_vma_collect_huge_pmd()' that removed
> this whole if statement. I even have an email from Andrew pulling this
> patch, but it looks like the code is still present in 7.0.
> 
> I found this link via a google search which contains the above patch
> too:
> 
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/25-new/+/f405e7bc5d93a541cf11663b2424baf0a03b496f%5E%21/
> 
> Look like this change got lost somehow?

Oh, even better, then we don't even need a Fixes:

-- 
Cheers,

David

