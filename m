Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0064C98307
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 11:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFBC66B0095; Wed, 23 Sep 2026 07:53:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3AB6B0096; Wed, 23 Sep 2026 07:53:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9F46B0098; Wed, 23 Sep 2026 07:53:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEEC16B0095
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:53:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B97814078C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:53:03 +0000 (UTC)
X-FDA: 85244865846.12.10BF2D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9DE3E160012
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:53:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YVFSquBo;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790164381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3gvEH4PZe13Dib9FXDOeLGOf/kDxMjwupk+1LhCdBq8=;
	b=X0hBWOfpn86c0v0aPlJ6sLY6KLJi0m2UoWAmbiZF1MLWsgwRXfDsSeR+mWCbJ3CRNMzZTs
	xcxFCr72cKPrhTFBzwTXjvO4gqYcB1/4SDDz3b8VaxwuhDm+LqUNy/vM++VF9qqjemNmhL
	sq/0WjSBoNLivNxYqXtrmk3RoZmoW04=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YVFSquBo;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790164381;
	b=4HXRxeMuKoQ5fhFBow2iYPrm8DtCKQWFZnmFNutBJqRxfOfIwkbdG/5oMz3NjylsYPsTM6
	Ul/w+ZUXLo6T5vSTArSCjPdFUGgeP3ZEKXr+uim6ECbbFDeQrmb5hlkrMvLgMfmVk7bLWh
	Z9Z4BQmqP+zNMMa7fDlEnY5/NPgM5A0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6375E60200;
	Wed, 23 Sep 2026 11:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EEF1F000FF;
	Wed, 23 Sep 2026 11:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790164380;
	bh=3gvEH4PZe13Dib9FXDOeLGOf/kDxMjwupk+1LhCdBq8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YVFSquBo9HtDomGw223Xmsup2p9f/dYix+XoUNIJHHR4DvN7y5dPy+o4Y4VCY3OXl
	 xq9g51WvZMgwndo+avzJomPY3QlQBZ4+EmTI35+axGNL95H7sUmik6HUykMznOw6+H
	 OkPTdCCPcCRm5+0BMMNpNC21j7faGXDCsTxMkwkB5s7zIsXH+VLECvkt5MWNlqcByZ
	 TaJD1RPTAT5ePVguaIDPVgSDTGeegPR8HJOmg1y8mhheOLiVpMBjtngEDsEzyPaErO
	 Vq2zxV4UTLzd6dCy0PU8hb8ltpsyqUB1o5lTQQZbJM6/WLqmh+in8zmrTMbVVxetyM
	 86Gj6R7sageKg==
Message-ID: <1acb0ac4-d2bd-4270-9a82-1747b3c62832@kernel.org>
Date: Wed, 23 Sep 2026 13:52:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/12] mm/khugepaged: rename mthp_present_ptes bitmap
 to eligible_ptes
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916093145.4022188-4-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260916093145.4022188-4-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5z6t7o3bedkrjcsbyyk5y5busc6e1h77
X-Rspamd-Queue-Id: 9DE3E160012
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790164381-751827
X-HE-Meta: U2FsdGVkX1+dMdrHR/yLsAzytu7p9OEch1pKwnIxf7JoAlll+sLUsZ+m5mtKpGeDhAKEiZyODFTLVwNrSLrHyqslSAbGn3IDQ7Y2O/hR9Kgfyistvv8XtRnj03WQ0t/AfcE15WxeWJxqMebTHc6/RL/AMjz9mrq9zq4lps+J0PsWrFMqRcM6+cnBsFDnIWXY5UquYZSSqsCFZMWo1XMp17r6saplBrNAtdyCLswV+dO7nMxqYD7eYAKES1hamGledj1NAwMuYxQV3sLWq4csgLn5y8ODY05nKweOWP7POMykgslXPaL9B3a88Cp6mMBJ4dxuYIxxmFh8OplIa8BeZLtv/m0gLAqKr59WMoBKgNdBdmwNY3K5d9sff+U/h3ftr4r+4POQDeX4x4hegtfsW8yAi9QAhiNwfqWmJr6H26AgWrXGBnvLcsmUP+vdk7BP6Sl1LJCbH4g7gWWvyjRPih1nBGcekJPM0bQvLi2WdAdHSB1J2QXYmu2roVPf+6zESnf9leG1JfrEyeSBKvrl9e2+jeenp+3W9AKq0XGwiZ+rN2pAimcFcK1QNIQjUEopqsa51/EzcLNzcA9DLXkOc3c5LcEIJHADFm14qpveSy6nookK6oGxOJqdFTMCr9X8TViF9RRNLi9A2s5JaqmN/VR87VtVY9Lw9B69BBK7WPnAxHrnsZYgCJxpekBEALfCczLamSJ57Yz7C64l9YbRHm7KUs8dAXZHsNQqoX+bYLj0AEszut1XGISSC29aBiD7WtPFBhMhx6v+KyAW2UwZsKD9CeR7ZKns7q3IWf0Cdt8tk4x3qoEpf+lREt3k++fvlyBzTmWF7EONtK1/Ymw4gr02IN7BwKDxYBNCLzovIrp3Avu5GZf9PgsCEpi1UYlW0pOyer+I8yWqlkNy7MnV7OA7rBVqdXDmKpvz3jxtSqtTZmhcjy9QGJMqWtqack93LSypTbK0WK9qhyDU+8y
 cPZGR73/
 HEwh1zJ6qbkXSAy55vTAN2BV0xSwfMeC/+zSwDJhTfqN8V5lwjId87bndAEv+qZ6rezSfm3rkwjEMQwDf0Xnxi/ifSQbxxXkJHknLwxGWmnSH9Oii2wZOwE5A5W3yRxmb1d4rA8w3uw7BeNDg9v+5vbxiZk3SBykUWqoi4hdbMOnb3a7Sm7n1pqxS8Y0LFOpPrLhhOyfEbc7ZcjhcVyAl14Zgd8Q/ccicHmr8UVZYzgwLld39xXrDpq4bLyIgmknbEM5UMbW0/GosQfIpiS6T5kNoZQyYRXr8PObwMVbhA4/j6alUlDrA4/RE+kKYLa+7q7QRNLUU8vnMj/9sqUFqjUovhxV2kdf5JDbU7tiifiTwsb/FMyuNl0ZYtb9NtzEJAVAc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 11:31, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> The name says less than the bit means.  A set bit means not only that the
> PTE is present, but also that it passed the other checks: uffd,
> lazyfree, anonymity, sharing.  The PTE can be considered a collapse
> source.
> 
> mthp_collapse() then reads the bitmap starting at the PMD order, so the
> bitmap is not specific to mTHP either.
> 
> Name it for what a set bit means, and update the comments that named it.
> 
> No functional change.
> 
> Assisted-by: LLM
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

