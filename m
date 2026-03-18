Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D4A2FCD0C6
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 07:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 837EE6B0107; Wed, 18 Mar 2026 03:39:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E8C66B0109; Wed, 18 Mar 2026 03:39:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7BA6B010A; Wed, 18 Mar 2026 03:39:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CA706B0107
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:39:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 304761B82BC
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:39:06 +0000 (UTC)
X-FDA: 84558382692.30.997C722
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 596FC4000F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:39:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t6iBdeFX;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773819544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kcmyer42+YoDVl4pl/KmgE42Up2/TQolBVndvcfc71I=;
	b=6jG1ntM1zTeKkItp9M/s3y4tuZVW5k74yj7nxxSsnhUiqUy/3Z2axoX6HiBqDXNqYmOPHH
	gWleb9J8mfjv/YFsOk4XbdGWFfg/TdEg1BB9VXUAQYBF9WvWWiHMjtXY6fdPfLCZa2mOX/
	zi1cxC/WvT4D3s7MCsquyaDIk6owZeE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t6iBdeFX;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773819544; a=rsa-sha256;
	cv=none;
	b=az7oqlEnjVoK06iMT+Ra4OWvBjWnwSyegRAnpV3C4q4I3d7Si0uLiExURIAOu9KBqugS4d
	XzUxpehxs1VC6qZEt59Ydb6STBqF8k40aOWGQdE1mAfllLa1de/XkwIrxpDw7TCmvRJYSM
	bjwB3NMOolb8hTQy7zW0jjXxJtehCcA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FB824037C;
	Wed, 18 Mar 2026 07:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B12C19421;
	Wed, 18 Mar 2026 07:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773819543;
	bh=zAzMUNn/kPLxwCHXe0I/zwTQQojBCM3qQBBRcS01Yi4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=t6iBdeFXKEMsoCQ85CIhXZVeL3QEMhTiEWy82sD9FBsTjxV+jPEgdxqlfrxK7HeFP
	 +LJOJzR+xrHPphxVclFmGJruJnqnUMN2CA2frfTCbiNKJhKThV5X++tcio8ErMs2fu
	 SPGEauRzmkyJH6lLSbkoF0lKYJwmUEmJA6Sqv76cd97mIF5HiiNlM+IRCiRTSF7HrR
	 q98S1YidFUmflFlstLTnVZ/KHduB3PvJga0N6CJhO11ZZAbjSlJ11nceirWEXKyQHH
	 k0RGwUfskdyrmzQZVKv344W5yGcGcZYy4nonpUdUgTxkD9CbOj1ksqQdiAl3veab2X
	 8tG8zgNl3mktw==
Message-ID: <13624f64-a624-48ac-94b9-f43689441316@kernel.org>
Date: Wed, 18 Mar 2026 08:38:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/pagewalk: fix race between concurrent split and
 refault
To: Qi Zheng <qi.zheng@linux.dev>, mboone@akamai.com,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 stable@vger.kernel.org
References: <20260317-pagewalk-check-pmd-refault-v1-1-f699a010f2b3@akamai.com>
 <268abf39-9cd6-412e-b3ec-32fb8fea1684@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <268abf39-9cd6-412e-b3ec-32fb8fea1684@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 596FC4000F
X-Stat-Signature: ixux7p3xqfdsnguu1e7myirb1j9i9boz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773819544-56490
X-HE-Meta: U2FsdGVkX1+Bsho4TWUcSyaz1ALfw7lTX9sY6psnjy05R5SDmSFfpBi8l/o/G65N1G3z+IRUKU0Kh/Upesfcf0h0VJXaE+yVTQ9d27nUWefaRyA1cLZ7hhNsMrzdaTSDndCCcW6/DxOWWwcw9gmDpO3nGY2kgcG+3xax1FsusD5JeGv8whHYB3ePFPp0kt5Z03DpQppfcuD7UvCdRlhFwHhoUWYy2Czv2dQm8VJJiDoFSiTys5+lRUDdO1FMXROQj19sD3/kE1pIAqsvDHdw+sOZ/6CNjomh4d5NkEPxnJoyOfsYlMZMRcGY4UOESYNvURiAOd3eKPOlaD1ZrYYAt9jQyXJHE5wLddi61KUnfbyF70QKD5J8Wp8uMtGq0RmYYHRPCyDKuOBSBFnZKDevb6fec7PVIfB89j3et/hILEEvPtnzh88JtkRuImXRobrW3XfbklI91DSE1AsTGFvbyzuc3RepfPWmU1JQ7LhqcD7V9yWRIXzjX+oVf0+k+V0FVx3Sm7l+qVDBntR259DJQrsDQAKXEn2NBEyCS7OH0vup8r9+9/TF/2QlfitqwirqrVAlH302lP/WirqaJ5wBOOBhtc7rhhM9gbRSpoDhqms4tuzoQuzr+Al69/OMelyIRBGaFgQKrBeoTWhn/qbQ9dfgUH2O5NLH7P5gImUpKGQ4RchZFiU4DWjzwDL356q7RNmyyCI5tR6XMNm4BMlVC8QmwTnqUjxrKfSIwnX+GwN2qFNshEkyglfWuZAkHhKaFsYFnSLoci/yoKyTY3MPYhJrN2jriPzusJ7mSab+Nd40wbfP2T7henJOK+Yn0HsBwXBIAt5xhBN5HJmxexvyhYtozmhBAfcbskSTaWrmiZuc0Ey3zXIdz5/HfaHc0/eqHgAP1WJOL+D/GJCq9TEQ90kxxUiubdkJsjpl5K6853GJCGq+qPVcptzztSe2nB8EQSNtwv1hkmWyo76tdqe
 rCVK1P9o
 qy27AN/oEeOwlJqQ3RXhKII9vpURAQuM5kwHi3uFr9ck0Ufl3WVv8rM74idZd3zGmy+uV3UX7AUaWKTolEP3LoiygJRfr2nXG+KeluDRBH3lBMh2naRh1LN3cfcS9GKNLf9nydE2HgOZLX/wbL8EmXb3VRh1cxoqGUFr+ogjFG/ViBHwXwgssTK1u26rYqXA4TUi49O2suaBVkPkovtAO4LVkmcDAQtsJnnfmAwmtk3gWwah9Ci8LQnfLToe7qV4iMDmEv/w//TVz5IJOjcAQBDLFKTQCoQiA9sJBDwauNWgsvCPPD5jcyxNgFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> +
>>       pmd = pmd_offset(pud, addr);
>>       do {
>>   again:
>> @@ -218,12 +231,13 @@ static int walk_pud_range(p4d_t *p4d, unsigned
>> long addr, unsigned long end,
>>           else if (pud_leaf(*pud) || !pud_present(*pud))
>>               continue; /* Nothing to do. */
> 
> Why not check pudval directly here? Like the following:
> 

As the patch description states: "This mirrors the
retry logic in walk_pmd_range()."

-- 
Cheers,

David

