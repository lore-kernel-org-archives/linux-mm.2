Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04AA0FDEE3F
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 19:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 342216B0088; Thu, 23 Apr 2026 15:20:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F2C16B008A; Thu, 23 Apr 2026 15:20:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BB146B008C; Thu, 23 Apr 2026 15:20:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07A1A6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:20:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 92B491A0446
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:20:15 +0000 (UTC)
X-FDA: 84690786390.27.69A3988
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CD5A9180003
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:20:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PVYYDo/T";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776972013; a=rsa-sha256;
	cv=none;
	b=ve92ueAbucxIgvseLNQYuyhy4A/8xyZfZaKBdsUuVO8qNcSy+l416rZMIkaDhE9rDUV/wn
	fcd3Zn97ZClTrDo2jXSB42FDho2OboqslqD/Haoj+hwj6XuIEh8N8iteiSHzh6nvtiT8hi
	O8b2XsJkTRaIQOSq539g/fFkKSnKZ/Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PVYYDo/T";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776972013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYW0UvndayrnB/Ia7/iuCZZtIekAGUn7JRBSVI/hQUw=;
	b=3npckrSCv3HF1G/QSMMcHOQnnfHTUPwbwL2rLmabvd2JA5QLG2AKwDwN852pDiBmJRpV5f
	Jwi45QA4gsMA1Xt9A8fFPiwlcQAf7Ux3SVsYRkoFsAUTPdQh/L45hEpWTSx7BLBUKtOnTX
	pvCLjpIzRvRzfqcAbogPNLQN9yZ40iU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BE9EC60139;
	Thu, 23 Apr 2026 19:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4273BC2BCB2;
	Thu, 23 Apr 2026 19:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776972012;
	bh=xDpjgs6trw+XVBMmMh/8qNAe4LLnv+dZ0MXpsyU5vwA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PVYYDo/TB71RaCoX8mmIylB9BiXitmd/vpjs+3IijJPim41nVmNrOY/8qgGAdh0Vx
	 cuDpiM4C7CP3PskNAkudmsxRwzZOGs4snyv8ot3jTvsCShYzdWK/lypijTaeiFtmFA
	 LKP76Op5OyE5PGxuJu5IvXtMPktrG6vqXz4rtuCC4B234QvDd3eCPejM+X6lJbLPJ1
	 5Ls7MFOprRE2m8ugfHfapP9Qss8MHxMCdDei0Ltf+Y9QVrDEYBf3MoWpV5s1mBiFZ7
	 S5U2zYI20T9YCFBbGGqpHwt6OjKGV0uxNGYNu7pcjOZLxAnPXdb0ut4bNVL6KTBsL3
	 hq2etIWe6/tEA==
Message-ID: <12346cd9-25c7-4907-9be4-1bd3f56719e3@kernel.org>
Date: Thu, 23 Apr 2026 21:20:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm: implement page refcount locking via dedicated
 bit
To: Matthew Wilcox <willy@infradead.org>,
 Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, apopple@nvidia.com,
 baolin.wang@linux.alibaba.com, gladyshev.ilya1@h-partners.com,
 harry.yoo@oracle.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
 muchun.song@linux.dev, rppt@kernel.org, surenb@google.com,
 torvalds@linuxfoundation.org, vbabka@suse.cz, yuzhao@google.com,
 ziy@nvidia.com, artem.kuzin@huawei.com
References: <cover.1776350895.git.gorbunov.ivan@h-partners.com>
 <9936cc799ac8b637ee58ae3bf6ec0e5eeb5306e9.1776350895.git.gorbunov.ivan@h-partners.com>
 <aepj9_v_1dYJ_tRu@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aepj9_v_1dYJ_tRu@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CD5A9180003
X-Rspamd-Server: rspam12
X-Stat-Signature: ionsy577uaxgktgywcxba5dpoia4mtdb
X-Rspam-User: 
X-HE-Tag: 1776972013-337349
X-HE-Meta: U2FsdGVkX1+E5Fqc1sMSM2RarM9wC8zyWh44IpwFxk+EMK1H9lTBhkyb6SyMibftSj08oIoBGXlktwOFkYk4T1lhEeAmpJM2iPAwU8+AO37smaUqcmBWPzvzvUlz9YR4gZOe9Cs8qRL7XtBnPmiFMQVBXdwdgt+xP8kdlLRe5biY3x0aRoWhFbioEeY8W89aM48oXzXUthEnBbRaUqlbCh3Um77fqNgi1EdDOYcncN+sF9Cx0oxHR8m94fEgJib6Cug2gYRqA9hyh2tJEBikrJ5byhjatX4wJLc1Kmaan7Cptmy53LDjDU9y2NobQr5sSEM3GTQAl8SjgjeJGetBltqzEX42qYm7l05pHXXWflnCW5A9qo1BjVeqIt1Humu2MKu82DT2wQU8XPSXzcI6RCtLGKh9aXJB1g680CtEzw/6T6Sqqh0Pv1iyHL/F/gWaISh2W9WDUvv27+uqXCNnYAMY6xvdKHl6KFOKJwfiPPNtUPvYYy+Y2uYQUkcd07tZXx69Rd+zg4R/Ss3UDbjNKbRDKhR54aLreOGwZStJAZeTes5AvuNr+rJgpl9UH2gBJSXISeQgtBwqI+Zn+ZVHBanrV09wq/YIppKanJ49czCBr2NlnUVZQHyxekrjmy1Q/X2wnwpl+vfJ1QLpZz72iPrrY1LO4JgHqgn9fcXlqGa7BYX/JzQmj0unpTBxyx49/zP8IJjN+9Mns1OMvQabFPODKVkgL3k0X22FegiC9EOCCcLksk4enTmgoJ7avhYBWNWf4hE+fmkSnWRJK8xMx4G6iQ4eojAdRXu6XjKMBxs62D0pHdKg3B7U0I5dTQEDXx9t2ca0BArjiACQUvAbrSOFt5ik82DWg6ugnffcv7ZzTrctMTEXsCC5aeZrwaMZwOIaI8XMtD3hfXtikNDE1ZZdva1Q71TLw4jnMRXOl0fa3mBcJfvmCiRIHNaE4Im+qk9pByG3DF5pcq3+GL0
 OOhDQ9Wd
 EUB9Kp+W4rdP7h8d8rzSgCNSdhgfh7WceivPSg7W6PHJdX5uBEUvXvIZs/PFZWVq4t/tUgUWOP8c34jaxa6tHM98LdC9ofKPwtHnrquudTrXSdvNY3Qtf0yxaOZ3KzDMz00Vw3R/JlXF0F+xUMZbpJNIQ6DeGatUHMInqDqwUAecYhIx7WYQFwbKP9vQjoraP/1aj2V5NjDbvosmtnObcwNxt7kZZFJHKha80vNprfXGVBKhqy+EPS9cX1eMxLAqvsT+jGlk3JWDFa2Nu4okaF/5ACA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 20:24, Matthew Wilcox wrote:
> On Mon, Apr 20, 2026 at 08:01:19AM +0000, Gorbunov Ivan wrote:
>> The current atomic-based page refcount implementation treats zero
>> counter as dead and requires a compare-and-swap loop in folio_try_get()
>> to prevent incrementing a dead refcount. This CAS loop acts as a
>> serialization point and can become a significant bottleneck during
>> high-frequency file read operations.
> 
> If the file read is high-frequency, then for the page refcount to be
> the bottleneck, they must be small reads?  Have you looked at this
> patch?
> 
> https://lore.kernel.org/all/20251017141536.577466-1-kirill@shutemov.name/

I hate that with passion. It reminds me of load_unaligned_zeropad(). Which I
hate with passion.

(somewhere on my todo list is investigating hot to get rid of that whole
load_unaligned_zeropad machinery)

-- 
Cheers,

David

