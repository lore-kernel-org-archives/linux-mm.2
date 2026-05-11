Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0606ECD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2112F6B00CA; Mon, 11 May 2026 11:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C1A16B00D5; Mon, 11 May 2026 11:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A276B00D6; Mon, 11 May 2026 11:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E89C16B00CA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:22:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 91AAF1C0081
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:22:21 +0000 (UTC)
X-FDA: 84755505282.12.7843A2F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A97B640014
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:22:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VJrkY+FW;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778512939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+GQ7ZZHDMKwHXa2byXJuVqDNp1xK9Y3VISyrcgs1lw=;
	b=6/Y4OxFzlEm6h5FcCCsKQ7HSTNmZCeWyVD9siiK1O/CbUeeYaJV0+YiQulPKjOalTV6M5a
	8h8xzfT+wF4JUOVxr8GJ2KRR0QbAN3rHK8n5kNh0/VonX8Sq+oUj+J34SYOhdQyLuRYiK3
	HYySSe4z59BkGfk8NKCeBvkF7AnMMvo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VJrkY+FW;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778512939; a=rsa-sha256;
	cv=none;
	b=O7TbrJNRshvcRHb+Xvrvi1Qxvrm2UO8uMN06foEhtMnGZqe1xKA8xUjo9/IVprvWoyOYks
	qzfGic/LNkTbr0WQnHzGQCDv4tyJMZ8bb3kERa3EF3RnSWnzI5OzwBw85KIVnPVB7pphZS
	DHx9jUSECF69g9jxcvQ1cAPQMDNlLAQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 080B360103;
	Mon, 11 May 2026 15:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06610C2BCC9;
	Mon, 11 May 2026 15:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778512938;
	bh=ffkSRv0otAKW7j7ojOe3tGNpaizzHKGyxFvNHsfHyFw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VJrkY+FWV2jA0Yn4Sz6PHsZzJUBhVCe9TQgSMyR+Pld9ykt7kgIQtK3yMprXd5C21
	 GaxN1aiVRx21WB+dQVC2rCVnHcaUYEwR+afEFKfGTquLuwAsph/1ib6JmKCKcFby+Z
	 rKv6am9N/yL1WPrZixFDJFr70Un/wbnZ0lDXBMFu+eI/nMn5K8yidVhZtqumR70XLp
	 d2yqKK5051vXvW6IAYOvBQ0fbj0VJ+q/yRQDB8XBg+34uLJOOBN7jXBek+E648YgIx
	 gPkSzpV6KlcjPDIy61Rl19bG9honqP+nBFpuK5/awPdkvRLJrQkrfbU86NXwGU0rRP
	 2F4BRBJaYgWJg==
Message-ID: <41193b84-1629-4751-a8ad-4f72120da31b@kernel.org>
Date: Mon, 11 May 2026 17:22:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] mm/migrate: use migrate_info field instead of private
To: Shivank Garg <shivankg@amd.com>, akpm@linux-foundation.org
Cc: kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
 rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
 rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
 peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
 stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
 aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-6-shivankg@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260428155043.39251-6-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A97B640014
X-Rspam-User: 
X-Stat-Signature: mzxdck8e5paoi8ai458me9sdywnw3shi
X-HE-Tag: 1778512939-274285
X-HE-Meta: U2FsdGVkX1/KNHG7ilpDtDljRx9LJAra3QWXBmRrVWrLVOY3VghVkahFXNhQttEJKPrCsL/d1qrKqD/T0geyoQZo/z3FoGW0Q5JF6G0VJUThKd9F8l102xFaehwO9wv5Z8MvXljaGaYPAQFjxj1vudCm6Yrt07OVkg8oHpr861+4yZhElxY70/SUud3g2iFTTBp0RxufS6uTKhmRjNvG012g1SdrMK0GAh7LNnyjL3YsO4fTq3XmjYcbTcak2rmL2Tlr/lGgZrK3xWJcYKn2h0QNaMSzbuaYiUeDEOcWukrLuGVGUKE+ZLWMXaZpuXo2EuITgalzIb6tMBrSyWgn9Q1CnLiL7mviMApTZ5Q5Esu/7RqMVp6t5DUg3NKDmfktcH+C8XS+zxbA7/FYE1QaoTbd8zWe+mZXiloLNdlEyx8ggtX3eThi925iYXuc7b1kdy1jFIVEkAQ5XQHVBJQ8YPkGN/8ZRTyjDadaQjj7Q27MbXOwo60HwTf5KcvgEGt2cbhTrbsVQuy/rCtW4qHd0zZCA07dCc7xJIyWaOeUA2ovh37k+tNdP9K47gWVgw1Q4avzfr1B+PYzcne7j88uGwjI8mJBCw68I6BQCR2aV0Q9owEDP7WgTV+gfCGlUFVTZlxZcEhENYkV7rPvSZQH64QLs6h9POLg5pL20JANJlQ0n/2Stcwmu7t/WqNyaSkJqU8H3aFrAZYkKG/BkEKl8OqRPqBQdomvsjiD2cUKTavzQX5EdeolwGaYslJZztXjaP7HdwiSWfAplg97/p4jHC9V3NptANTWjzPRQMdt3Z5mb/+C7cyBPBHzxokDfdxDOlKEIFChiqiS3QfME3KnAIM/WpQSRW1LIyeZxotyWa/ku7jZpa8OrMDC9TwdHuwdpCKGeb/zPJ4mE+LFBMWfyDzMwPYJZTvg28wHQuwvmVEWx02nPKLUA/Yl5uhwC1UTXZpZZub2ps1D0EwnqPz
 gLH92NZi
 I/SOHYnF0Vg1OQ29gCEI+Mvz4KJ6ZktLN452tWlUk7WXfhXYc3i633HZ2FknBce2WDVpK0FGI6I8i708XbOoi5xDtlVr9Tef9C0czZzmW3Lu072PhZz49pUYnc5fPyHM5wxGnTLoLg1Ze74tz1/BkDDckiVtKeeRHgf3xeDAjkbS2Oh0Ky/FkwDwCmrVcTQUTTF/NsWxQrSMt69pn9pXv+VpMemw5FDHi3oBuPjD8SleSkWO03Ev9CFqbXYAOjEQ5U4gCRXaUdupmNog87nKnFHGKaX6gVkAiQZPXhLmNsUpPY9TlhbW3K9LX9SkU/HegognysCPT0Q6KpNHc5unmqzVGgt/Qy+Vkpqq/fKoPP2nI1FeIJ9YkexGB9Bv4gpvA9REZt8QOiyr5qP36MDo0ob7obmewxcqeNj6TdzEVTouA6hg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 17:50, Shivank Garg wrote:
> Add an unsigned long migrate_info member to the struct folio union and
> use it to store migration state (anon_vma pointer and FOLIO_WAS_*
> flags) instead of using folio->private.
> 
> No functional change.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

