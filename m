Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4F0F1061B0F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 15:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6D426B008C; Mon, 30 Mar 2026 11:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44286B0096; Mon, 30 Mar 2026 11:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5A656B00A6; Mon, 30 Mar 2026 11:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B47026B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:21:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E21E1A0813
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:21:11 +0000 (UTC)
X-FDA: 84603092742.19.751E019
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id CA6EB100010
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:21:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hDSIuCfk;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774884069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NlKOpEqTNqEje3Zul4sX6LmrcIe/qmPERaPYlzjTE9Q=;
	b=NGYkMuabQ93zHMufT3F1SuoBrk0M9lNH5IgEX+pVI9pDxrGO4aIVy3/6Ts1xpOEaEklth4
	+AYkm6irxFAUGZBzTiYq4AZwNU2aXXujVUuQjZesOIJYUrFE4UGKjB3IYGvVolrR6sHgx5
	MEV2/8+vSYghFsiGfl1NnazEi3ae6p8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hDSIuCfk;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774884069; a=rsa-sha256;
	cv=none;
	b=dT3F2HIp0ec07fjwS1o7venRuklZdqYrxt28mcNeZl9ivP5cmnxbtn3RT4YGCVSpGgBwqO
	p0jG5p3GAj5JbRwHCoia3d2H4ip0wGpkcvu+iXE1BeMsG3NmY3MrlhF1C2mFQ0Nc6n+qxM
	DkTTK+dSR/OE2qKa8SzHVs9hB8d2REE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E8DAD600CB;
	Mon, 30 Mar 2026 15:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0173C2BCB5;
	Mon, 30 Mar 2026 15:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774884068;
	bh=8Mr8LmbAQHXIw91kkQv6DoQKiLML90z4qt/OEn+Vo/Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hDSIuCfkSqhjKhIj/dIr+M6EyMKTrX82OkMVJd7LReC5gL+tGgHmHlwQTNovr6VRO
	 2HwJ9MoliLxoCjUXSfvX/91kp+lLD0bDAWT3m9HosmJNQgVALQSbbjR9WoPexRhJ1Z
	 7+MAJFO4OH2aHy1msrMz80VqCiOLqhYcbx+1MaX+GWeskzcUL1kYFpInDf6wV5MvSk
	 Eep/NXo6778WW7/AoV5viV/tthbWxGrcfYFjo6aodh2Dh/oXmQlqjCCPKjKbuwif4d
	 dEyog/eUXkwJh/t1G3n92bLCZtAmtxBZytaKzDvwiItqQkP9aQeT0BfrzpAYOZtjWu
	 7QbiMW/OAqrIA==
Message-ID: <1ef9ed2a-ee3e-4b3e-9fa6-58875f96fb1d@kernel.org>
Date: Mon, 30 Mar 2026 17:21:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/15] userfaultfd: introduce mfill_get_pmd() helper.
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, James Houghton <jthoughton@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Nikita Kalyazin <kalyazin@amazon.com>, Oscar Salvador <osalvador@suse.de>,
 Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260306171815.3160826-1-rppt@kernel.org>
 <20260306171815.3160826-4-rppt@kernel.org>
 <ac39f02d-ed00-4b8d-8156-1e999f5b0af3@kernel.org>
 <ab_C2enJ5DTIH5aH@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ab_C2enJ5DTIH5aH@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CA6EB100010
X-Stat-Signature: cfupny1pyaozzsnfk8fpmat85s9gyoxf
X-Rspam-User: 
X-HE-Tag: 1774884069-174685
X-HE-Meta: U2FsdGVkX18LGMDza2OT0MnrvnxwuSgeAVFNT9gf2na3KVboRwR9TOkacout4bsl3wy87xoq2FrNJA0NwtYuuM6rS0FvyDcNGKfvY5zE2WdJNkvnD1aqa6J+rpr108TVv+Eqimw+CclKAxM7yHDNhG/4V5ZiAUrdp2Xpyl7fYOoRy1Pih2/3iDqIBz0DGrNuQO+OVhQjB07Fyzr653MnaD1Elv04r7mLYCd+IfIgBVmxAP/Fg6agw3KExde6NE/us5VsqKp1r+FWBmOLx/pxuWWJqRRcAQmTEQ846jsMNdDwBI2qpg2wzsYkrORtXonOUXQbc22xPlvFMdh8m9ir77gSoh1E9LoLyh2g7qNqNihQbPx0a8GJK1Sz3uyskrdVyCZ76bCOVvMYj803TOlBrsksKBpDRnZ7bntn9SqLoL6YxQYw4hjXn6oklbg7WTjQ067XEE/onXgRdFlkTw4ysTg7pjSQTGNJG/DN7lQu7KJRXMGByZicPeegsvz0h3PeH6zZ8HVTAHZrQQzrTd8iWHDPcbU3ReXrkZBRtgo9L+H6QgSMoKFozj7jh1Ni0A/sTRgdOAlKPbvBXYnmJjsyBd963pbWnYcmJnnZzKCpPXGtkg4oq65Si3hxVZA470g5wwM+tN7r19Ln5vEt+ImuwjEwPSDPEpPR/p48efGlGNGUkuPbdYx2mf9T6/gxnFCerHA5gD/VSKiekjH56nIlY37DVeTh/ADNap2yG56AC1WroQDoIGPRzKJ4V4ZrKclGFRTgA/r+rd8jg5imx1Jn09d7cxqjK7MtlR9Oce/+fDZXukUPm5G+IqYdbkw4/XQWCy/kLxPqrc5JhXs8Ke2ZA3f8OXviFmDnDFutA0pH1i/jDM2zdCc9gHtvq4UAVs4hE1CdJ5oyj+zLZjoLSCbkmPqvVtRSXaTrmQS75xjWEKFeRWMEIJlyBDWvxfCOzId1iZNttD0Yf39cCutX190
 4pk5Pjr1
 cbLoYyzRJtxgGXR3BPvZdqI5Jm/AOoglocn8DXWJY3NxMr1h2l+zcBAksWO3x1qhKepp+t45/yRBKhc6VJDFMj3gV5pVu178RHFgfIaSzAehHGYSQhj78HZSTVO6Aqy7ETRA0sPhU8tw1YmXJ2ucRqldPezAyw1bD8XRjsg3aY39rkUHZ/uSy9KlkW+nhiC1j+ekWSYWhpOEs2yry+++BFndWfGZ2OEN2X6kgo0jJ8ky7WPPjZt7ru+Ktu27UvOg/7nOl+UGCn46KGRj+HmYNoJi9Mrbs7dCOBH8sLaWgLC/9QiZcEZ3PJlQ2DA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> mfill_prepare_pte_table() or alternatively mfill_alloc_pte_table() /
>> mfill_alloc_dst_pte_table()
> 
> As it actually allocates the pte table once in 512 times, I'd prefer
> mfill_establish_pmd().

Replying only now (spotted v3 in my inbox)m sounds good to me.

-- 
Cheers,

David

