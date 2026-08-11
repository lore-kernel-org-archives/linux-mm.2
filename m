Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43282C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 18:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21FA06B009B; Tue, 11 Aug 2026 14:55:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6B96B009F; Tue, 11 Aug 2026 14:55:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10E106B00A4; Tue, 11 Aug 2026 14:55:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEC8B6B009B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:55:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 497881601C7
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:55:44 +0000 (UTC)
X-FDA: 85089892608.24.6731E76
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8FCE71C0019
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:55:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UpctiIre;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786474542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u5nJfoWmHI/wV6IK8v6+KP1yBbtjszQXsbYvY+zGdl0=;
	b=52QYop9j1iDEAL6rDfngUm6f8BzBFQC4mxrj2Q8m4hfarj5+cy5qiMhwwgAdZfcvTslImv
	3FzVAQiERtor1X3AcliYIYFWP23/kwyQCoCY7oUeU0RLDdpvctHficnkS2J21hgp+GMnaW
	QZvaopd9chvw64sUyivHFfBZ/5y/HTQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786474542;
	b=NIoS/jXHsdOrIUyNgg55JmA1vJLQa7aEHxP0+zKB//sSYRztaexhGz0YiWy+/fhVg2ZPZH
	CQgkQsQ9mq0HQbZzZ2CmEwjNCFZLjiAo2pIvDwyDI1e2RQbCOuKVrFbKRbOWjQ0NBURvlg
	a/UykxVcqxCMl4sPPp/tjvspqoIblhE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UpctiIre;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27808600AF;
	Tue, 11 Aug 2026 18:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C407E1F000E9;
	Tue, 11 Aug 2026 18:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786474541;
	bh=u5nJfoWmHI/wV6IK8v6+KP1yBbtjszQXsbYvY+zGdl0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UpctiIreX8Twxi2Eg3/JBOZXEH1E7dz+aJfKrumvHa89kHexdFz/c/4+as7qzXNqy
	 BtMQadXvsXSs/GNZphEZCsSSByyEZHkQBLJWEV1JGDZld6RV0GCeJ7Ewj7zHzS2rZm
	 pCVsdQaENvlT/tLgBYpk0WHBg/flJXrqmw63bbiZmcdC+Ep0KA1x0NnZoaP74JqoLl
	 qNVZkPLXBVFy2WArXPSHNS5jUaEuRA5mKC3wZX5jH03PV+256iw/F4EfW+eCw8rVrG
	 CDae1gdtY2SzSj61VIwgKicQ1R5vNnqTW6twsx3q2CLmB5030LByKv1zIsGh1rnXqA
	 gJ4DRAN5aCITA==
Message-ID: <4968059f-5e59-4c77-a631-9a4039703645@kernel.org>
Date: Tue, 11 Aug 2026 20:55:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/7] mm/khugepaged: several cleanups
To: Andrew Morton <akpm@linux-foundation.org>,
 "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811112347.aeb004e62daaeeaae98b6502@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260811112347.aeb004e62daaeeaae98b6502@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: c7zptwhaen1w5nef5dx6it9t69knnud5
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8FCE71C0019
X-HE-Tag: 1786474542-783945
X-HE-Meta: U2FsdGVkX1+sSmpPAOLKXss+N21s3dYBefvQ7Jo7FdGRnOtpEFXFclZcKq+2cg9579J7IeZ+5tlC1mJ5vcQ4Q9+BxddFGPSnYeffRX0M5k0N0dVYrWtKWd6RZYwO2Rya1Wh/z1ABn6P1uDlhGF5pEyWaZGb/AuYNAtAq3FlNS+zoU76BjFOloemlysMEBTS2ZA7a44n1U7uCtSsw7//oTqJCcoWP4UjBgN1Fn9U6qKbRZaF5sXJjHucaW2kmXPmqPT9OE+DHVF7VIjkaGASEBB+NgK7YCpZLhKJVSvpY2pXwIE2AunynCSjjmtqVC8dmrXM1tHCpo8G5joXrjcqfe5O08JJ+NmcwChZ8vG+9q+BsPrj+byMNG0TMGFXiwoCUKE/nsuu4QsqSzCt/5IFtSnnYXtzy0m+MAv3LhFNlpT8bErmTFHHW5Q7bQIUtcAVbt1CeN40ASGp2VXOoBVx8Z/gjZWBqH437lMV5SzT3dgLBULtYNeqhJWewyoqi71UrnOIuKgMZwc0bENsn4w9rmki8xxLJzd+FztvknJ8iRwX0AS7fS4Vwjg8g7StZu1zYRnOb8vMHaCKily1fsIsRR1xfZl7qj8yUpaMHPkQBr66aAI9tPeu534Pvf2ckFkZjzx6e+UO9v2O7J8AW2P98zT+8hTCrXZqxlTL+7QGZ908gHqKia1hyFJ8BfmEQO8pOVMZJkFiAbzqvrXvIA/2BFJLnWpwdVgfVTTQuaPOsGi6e70PQ4XZ90+IHKEsvAOBigTQjwFZxQldywJ4Yao+pWy760diysKshF7XSONWq5XR0wSQjLFSDOF0vIhM2mBPTHaznLcXtJdKeqim/+G6j6K3F0ApXnwfSCRvTgVjpXm0T1xkGTVDcOBFvkQ6uVqNgAE1WFfiBTi9NjwhtLdB2MUiskA8S6R/YQsbEXCksIBbiHZAHXWOAgbsjpfwjhtLqUs1WRBOhtk7lYKs9W/B
 KGR5lrwJ
 TwkAx/gOLO7b7O2Dxjx+BtQ5KVCLURTqE67CPT+f8wUjKDKXu32tX1GLdWSo+8Gv6PH8H5ZkZ5te8pRXyfoe+dDFUOlEA9PLHnLSZM4Y8ve5KiFmJezDlkk9jb5l/s9aRzGpK6r0dYfhRDlojGcNGQtZS8dNYhN+HcjzRxoUP+YolELF/c0+0ls4vTlJeBm0K4TGuEK9cBafE6ELVu8R/dgYVKwArIoEf8BDyLKzTBx1mB7u68aR7niLf5MVLDkWUf8zY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 20:23, Andrew Morton wrote:
> On Tue, 11 Aug 2026 06:48:32 -0600 "Nico Pache (Red Hat)" <nico.pache@linux.dev> wrote:
> 
>> The following changes stem from a number of reviews during my khugepaged
>> mTHP support series [1]. Some of these are minor code cleanups, issues or
>> reviews that we decided to deferred to a followup series, or in the case
>> of the more major patch of the series, changes [2] Lance Yang attempted
>> while my series was in-flight and we decided to wait till later to try.
> 
> Thanks, I've updated mm.git's mm-unstable branch to this version.
> 
>> Changes in v4:
>>  - Add Acks/RB tags
>>  - [patch2] rename pte_is_referenced() to folio_pte_referenced()
>>  - [patch2] keep cc->is_khugepaged out of the helper gate
>>  - [patch2] simplify/clarify the helper comment
> 
> Here's how v4 altered mm.git:

I want to review #5 before this goes upstream. Will try getting it done tomorrow.

-- 
Cheers,

David

