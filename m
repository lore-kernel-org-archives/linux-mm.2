Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B44EFB44C4
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 07:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 825D86B008A; Fri, 24 Apr 2026 03:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D6696B008C; Fri, 24 Apr 2026 03:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6246B0092; Fri, 24 Apr 2026 03:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF3D6B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:28:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BE203A0769
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:28:52 +0000 (UTC)
X-FDA: 84692622504.06.ACE57D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E654E40007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:28:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s3cWFCHb;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777015731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9J5YHddFzzYnJDgh4WXjnm+KmA+EDV2qWWdAasFJsys=;
	b=ok3x5Oz36sy2l7jWuE/gH3082Z5bDUpvRbgNqrCFBFo6WfLOHm0fdJrUf0AftjAdCNQdTk
	srFqCOlca5Ebstah2CaREjk2KoquzslYN5+FEEF87EIggEn03CDrtVHo6Vu3xM3fzXtxlx
	dl55W3ga50zeNY266aWFBTfHMzBItXg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777015731; a=rsa-sha256;
	cv=none;
	b=igCUCOftmsHwG4XOiDavIUBg9Dea4dIKG+6Huxx31NCAQurCa/UaZbRluZ8RGi40RBWn82
	vUSAwtd5mNJ+vpPhfepszrcmvoQeg8NcYGGWld1ZWtpjzNdVYRH9416EMvPn7YKg1o5/tb
	rjM3+0jncKubGyDKqcKJlXSGVoTnIZ4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s3cWFCHb;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B0AA540A66;
	Fri, 24 Apr 2026 07:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449D1C19425;
	Fri, 24 Apr 2026 07:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777015729;
	bh=D5WTkAG67DCeRIXXL7QTaoWz4jtq3LR9v34sTXeVWX8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=s3cWFCHbvARap4MiTOiZhdctXelw9CweptCYFnW+h/atSINq5YTY3xRoxZwJKlbTM
	 A6tmoD4Qb+0YU4vYTzSFsqwfLtKy1AQIF19Zgt+4qLLHblg4j/MdJrY4OyBkQmzgl+
	 C/HUcHHz725Z4v7OIdL1eSqmQ9VtLWoMWOj44AgdQj85j+Hi2gGiWtkkkJx9Cnz3uM
	 Go8Jk7fc+gcSdR53WBvrvLND0M9EA0NYDystm2T0ulfYZttqGKi8MgXFa4Ce6AQPeX
	 2+piW6vCAARfbJ3PWJ8j4iXltKDT3qy+JFzCWsvynZX/7r16t8jYNrc1qaGxQxe9sy
	 kMBAp8IQ2hOww==
Message-ID: <016cc5e5-044c-46c6-a668-200f90a64d85@kernel.org>
Date: Fri, 24 Apr 2026 09:28:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
To: Gregory Price <gourry@gourry.net>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, linux-fsdevel@vger.kernel.org
References: <cover.1776808209.git.mst@redhat.com>
 <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
 <aekluxNPxF8CN8fL@gourry-fedora-PF4VCD3F>
 <20260422171315-mutt-send-email-mst@kernel.org>
 <aemglPlcwFFHNj1A@gourry-fedora-PF4VCD3F>
 <c165d6af-4a35-4a41-9086-ee307640c044@kernel.org>
 <20260423074433-mutt-send-email-mst@kernel.org>
 <aeohzbmhQAoOODPm@gourry-fedora-PF4VCD3F>
 <88b0765f-7cfc-4e44-83d2-c01a1755c842@kernel.org>
 <aeozRZ9AvW2jTQkX@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aeozRZ9AvW2jTQkX@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ftxdnsth58mkanxzq7yoe718ts4dn48k
X-Rspam-User: 
X-Rspamd-Queue-Id: E654E40007
X-Rspamd-Server: rspam05
X-HE-Tag: 1777015730-794547
X-HE-Meta: U2FsdGVkX19mYK0vFgf12vIq+1CNv6ZbzU9lfIuzS7YQ3c+WAnjJCHS21zEDPJ74J3NLwmJ5ywBwV+Gv74cr7Op/XXcj2J8IhM6XOFLpuD24dGCQMy6fTVPTLCshNtZjA3fjwkZs6mveVQSG2kOY9XDKbeAl73QsB05ExmoQDAs5diRFFkzI+LwFg38doz/v5mE9b6ZqPHY+8qf/65IFNP3XxT4sc+j27nO7r80B4FSgMdaxiNUWmF7Nkr59pruoN8Z/IEHwyzy4EYxQcYDfKM1xB/h9/IElNb1xOgFWxXoBysLM6kF8uSVYQx+tvqk5KSNROEjjrJxAMFs9y5o4EJnWbuQbaTtVLEG+w9IsMAjSzs1BX+p76smRACVu6oDQix6NZuCXbpKOrq0Ldjo3rX23qGnuPLIMrAPnj+10DRLQbIblr6ofBRIfA7nwWkyhmXTNbZvB7WDnznTlPaM667jD/b8Vh0sQ0NhrXRmoh09UcqXDBm7fTmTZpCEOJa3MCqRD+x1JDbgijj2upvuj3CnXv8tFui6SEEeyY1pwA3DKUfHin2xM/ytY7bHV2te9Y/3JobhFK2JWOde/ePEoO17kpLYZJQ+A0n5Rkj/n+v0f1XNOp/T5PGpih3g6JpC81DSQoDV/k0SmlzLqQEzH5Z3gRSWHw0f2ckGkYfZM/46/oeTT+ypmuDFrxNHpttl3ciG0BtgxdG5zoL2PW+2AErrQjxqMmOEK+3n5JDdKVWlThL0l5kJFIfxRD+Y95SyxunFlO+mVtuP3SxNcpFS1IRUDfEyRudo+/l8L5joT1ZVUY/nnBms+rOO7aEdByk9avskKEIgkO5AicRY8SKN0f59SRcpqsRn+JqVwMxptMMRQtJn6wlbxZ+J55WQwxE05FeRAPXkH7F1m6AgbOW78wWci+MdzLJIsbp2tKiq3zJl6S7eDDzTtJwvgPet/yF4xhNaWqbhsfx87OtNMfbW
 XAknavgP
 RMa9VBswDOaxJvpesgIAMfx59EzYg/CY+WQEazTolrddCKTepvxHeAk6oU4tDOVZ6q+MtNmKM3AtDLTu3HQIVviJZ0EMOmLd4HEdP3tpSKGUWhQx6moSeLF+5aNiu5IveIkSYlVrrOUOTIIROJURQEq9sjpXBv7qfdCcGQSL5VIFKoUAU+fx6woc1R9Mc3pIXf4iwXnheYuNuUSn03mO8+og+R/XtgsNsKIG9JbT63sjc3+RdmrRXEgXv2cxg4Ko4ZbHzVNqb1a55i2erU1V8vdGJUsrTW1O39vwcEplfMgA/K98wtSQyt2f6yPSTp7QvQiLd0TGq2IQm2tf8hNKH+QvZa/sxVQWnGKHJ5GQyGDuFPGeS/L2W1hLUCczDNfcnhYk0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 16:57, Gregory Price wrote:
> On Thu, Apr 23, 2026 at 04:13:50PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/23/26 15:42, Gregory Price wrote:
>>
>> Maybe we could forward the vma+addr here and call a vma_alloc_froze_folio() if
>> we have a VMA+addr to have a clean interface.
>>
>> But really, that hugetlb code is rather messy. I'd vote for leaving hugetlb
>> alone on a v1, and focusing on non-hugetlb first.
>>
> 
> If we're ok increasing the buddy surface this way, then I'd vote for
> only updating the exact interfaces that MST needs to update for his use
> case in a base set of patches, and then have each additional updated
> location (or logical set of locations) updated in follow-ups.
> 
> My initial go around with this - the patch was hard to read at best.
> 
> But I also think we should also seriously consider not increasing the
> surface of the buddy. 

Exactly, that's why I am saying that vma_alloc_folio() is the only external
interface people should be using with a user address. all other _noprof helpers
are supposed to be internal.

For hugetlb, we might need another interface for frozen folios later, which is
why I suggest to defer that.

-- 
Cheers,

David

