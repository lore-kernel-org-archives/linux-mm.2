Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0AB0D29FEC
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:28:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24B646B009F; Wed, 14 Jan 2026 06:28:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CC026B00A1; Wed, 14 Jan 2026 06:28:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2BA6B00A2; Wed, 14 Jan 2026 06:28:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F0A2D6B009F
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:28:57 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8CD3913B11D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:28:57 +0000 (UTC)
X-FDA: 84330347514.03.BDC4608
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C361D1C0007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:28:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HcZrx2/s";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390135; a=rsa-sha256;
	cv=none;
	b=vzfoX5SUhJCYZo+5ZdquNAYP7sM88pAYLoOlqSU7f6xOh1lGZiBC0pgC8vyfNEzhBzoLEC
	nwm6b+aI3qIQKeRnYk+dMCaHfw00v3NjyS/aXEwCsmOdqwvVxvdKwoLSR+3GE8D+a4Lq8C
	uIXLG2VLpSQPmFHlPGAaO0jNI9C4w4I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HcZrx2/s";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FeO3uqtx0I3UHnhY0wHypX4nrhT/52bAWhNQHxUsvAk=;
	b=5Q4uoqSfgNX2UhPJDJQu2evnzKL21S8hRL4D4kltMJ5hEqPfZu3M/V+WTX9ymTdmR5jzif
	+Z3FjiA1A/OAQfeVIWnLIlMb9iPVdz9aaai88rtugl2uXLjAgP8F093cA/6jsVlP8iQ7G8
	rZPZlTgqZyn3UR+Llv9cO6q8ZtbBkNU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D779143C74;
	Wed, 14 Jan 2026 11:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB8BC19423;
	Wed, 14 Jan 2026 11:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768390134;
	bh=Wsx+UFmwpbFfSr9xSBLwX0nPnQVJ1Ap3tIPbkj75udw=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=HcZrx2/sXYiGP/VB0aWWLCmaHeEwgSeAivcJRdBO+6UJTB7TTVeONtF0QbtjbHLOw
	 8QiSXSznHHiXmdf2woTqyuMXkj22sHxpTNyE/lgiRG1dEcDbHdJoEYpnqt3jEcTcFR
	 EbNO2PgOPxDm5Vlp37iNA9NVonQVKxP2YSZ+h9SxyR1e+bAuiEZhbLkSWAeE2fLH3p
	 wLyEh6PRaDSGJXlni9U9etJaT3VUoC22gs4ghRblocXJl6azIGiK/rMc91vGXBU2yo
	 vTPfoMBwWkOebeBykBktFrRcQk5O2uyO0qO3ogEMbCQUPQqImSRWrgpCz7JD2rqN4G
	 eOlJnXz5MDOhg==
Message-ID: <1301b853-992d-4299-9cc3-32edbf2f078f@kernel.org>
Date: Wed, 14 Jan 2026 12:28:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v4 2/6] mm: khugepaged: refine scan progress number
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
 <20260111121909.8410-3-yanglincheng@kylinos.cn>
 <a3d54ed9-773d-4369-801b-f9729772d6a5@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <a3d54ed9-773d-4369-801b-f9729772d6a5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: swezua7u9g44m91bneiq7sx8cctumqrk
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C361D1C0007
X-HE-Tag: 1768390135-369912
X-HE-Meta: U2FsdGVkX193YV6i0GR9JRUFSgwWc6Kfr7B+Vb2RguV30RWtRMQq17GIO98PPBrzoEbr+vJ9WoQ8H2FN80tKTT1ymjHtEIZsElJCNcvJBE8LGuDL+p9xLIec8RPuc0cvs4YC470XNrAzE+ia5pV/H5I6EqOdgdyisOD7W5SWc0yQf0D6kYGnFriDI49hrsf2gnzAzHgfzgmjlm2olKsDPnEmE1VhVOtxFBzyO5hDHSpgq7hlqB4f/CL6kWyJVKwzLiHac5aD6FktLUbR4omTpaxdK1o0jhOxJJ82sU3dgSH+mHhWrMtDf2tBfFxqQmDygyOAMB+9tZuOu12nrFrXk8XJH2L7Da4nuxdu4yGQF1B5Oc8zOept7zlRxLZqOYd6iRf4g8hWA1LEgxRfHsalZTPDpcfdep1QJmRSNoOZaUymGGm6lL/cUN4ZmDdoAucdYUv8cY2RUbp0s7k24gNcD0hK+Ou635d8RrQjRrSP5byukml94XOt5zsbjO4qXxXGiNz+pwDsyvIIqLSjLPnQV78qT25FXEBJrfmTdczUnXj5rPPk3DjEC5Rz5O4f14Gtk/Yu38JYmVgW78Y8cBGZeghJl1D9ETEmVa5sxnRko4xUx911FTdKqI9O3jZrzZ7cxHGgz4MAIeDqI+gWkKVy+DCnb005epsIchZy/6leFt1QyJ1t/GcLIihDDaYZrYQownQ6y++wnYmfumsdB0ifzzMu6K2UE2hq++VYMifcGbHo0PPhMTAZlVh9p9uTc2iHx2KjxQaRvsS2+pQxBaj/8s8+9n3JtLqpI8nwvfQJSGgTyG5nwv/X411MU67DGgANuXxPU2Zryp5aG7jU//0i0ra/LUSz7CSeQkX9/hlIq7quwGkLEQIldbHOjbjbCFxXJfwnMYSyeLaUyK+HTHVSUMY/d6bUcrKB8XhYTlrLewV0CjpzP+ZyZhrrzBhugbe3itdbLkcbfPQp5q8U2+4
 M/l7+0Ox
 8fiG7Xw6h5U9+E0+EdxAsm4pdQ3Yhk6c99iDGvlUbICPeRR8t5mlB+OODnEThjfftlY7F1PFSAGKYUZAZEzh4HOkmOhTLpml7GQ7b2Ui1e+nPlPWCPbjEkvst3H8Lgv9EkookgDFmuK3jhN7TpxQ0ZUS9CVuhJ/4jFkdkqSnxygwniYvKsp8pnxdA2I4CnoHWcCdgUEWP7KCBxs8cAaFsyCt/A3apolQXkZKShhDb93mmirIYkDPXhzfR9AB3oYHWoCnvWSXCdkwgdjpyeHh4zt4mqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 12:23, David Hildenbrand (Red Hat) wrote:
> 
>>    			mmap_locked = false;
>>    			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
>> -							  cc);
>> +							  NULL, cc);
>>    			fput(file);
>>    		} else {
>>    			result = hpage_collapse_scan_pmd(mm, vma, addr,
>> -							 &mmap_locked, cc);
>> +							 &mmap_locked, NULL, cc);
>>    		}
>>    		if (!mmap_locked)
>>    			*lock_dropped = true;
> 
> Seeing the "NULL" tells me that this patch does effectively nothing and
> should likely get squashed into #3 ?

Ah, sorry, I missed the other instanced where you pass something.

 From another glimpse, LGTM (although I think the end result might look 
better when both patches are squashed; anyhow, patch #3 fixes these 
instances up)

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

