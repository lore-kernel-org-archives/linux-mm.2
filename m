Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77B50606A964
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NRWBHAMw
Received: by kanga.kvack.org (Postfix)
	id 961EC6B05C4; Tue,  3 Nov 2026 03:46:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9128A6B05CA; Tue,  3 Nov 2026 03:46:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828646B05CB; Tue,  3 Nov 2026 03:46:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A03C6B05C4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:46:03 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0149980352
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:46:02 +0000 (UTC)
X-FDA: 85393175406.08.7DFD8B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4BE3E160003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:46:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NRWBHAMw;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793695561;
	b=l0ppH48nr5cYQEyhRtSjmfAt8pxi33WgfesfooCn0Urg1ItfC1gOsNc53+KTaENTSXbmJc
	V/wtmYh7TrWqMCKXmbBYXdnE9xnEN6DV8fF9z2dJJJK2RTJa2cBUECDOadkeghijUeTPmU
	fnZc6NUTzwS60RlhHuwJWCY+/m4BilI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NRWBHAMw;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793695561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uthpy/hkvB+/WO3JI8k62Lhmq1ZdhnbKep8CtaaaC1I=;
	b=rRLywsLhq6KmqTkZaFGpwch1X4ommt/BBm3Of8ciaWok6b7kNrMIUA0SZ8/MSq/A5lH3Kp
	eZqbWuyp6gPQpaluMzmFszEjwew+I5TQfa6udBary7x0nmXaJ9fQ3HcKgx5O7/XOjymKKu
	6xKsb9sc1Hl12fUvWHDK4hNt3m2MCXY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DDA816021D;
	Tue,  3 Nov 2026 08:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4661F000C1;
	Tue,  3 Nov 2026 08:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793695560;
	bh=uthpy/hkvB+/WO3JI8k62Lhmq1ZdhnbKep8CtaaaC1I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NRWBHAMwsb19PzRi6HMKOk5UUKd7gUz27j+h5kkmmo+BVqrta8jE2LhRWnPPEKKuo
	 vUbwvt7PWLjvVahbmZKXoa9e4taKfUwLQIAUdzyxCsWMTfRZpaRyYbA8ErRHg4Foqn
	 tyCLmm7Q8W5Vn5xf7mJ/F2nMZMY302o8ABOKA5agEBA+i0Q8dFMjjDAuHzZbTqQJb3
	 ejaJAuivC8qZbvkGOAK/ojQQs49LNXMNNaThLRk3suNvTigPnY4VG0jriy+xMjefMr
	 FRP9hYUuWI8BMwTIKM2sf7gBmt7G+WxIA70jPT0rn1egD3UMIoeHEuVWKDbig1pMzh
	 nySi2+T6izcTQ==
Message-ID: <3d2ab12a-741f-4b93-8f9c-e030cf9b9b90@kernel.org>
Date: Tue, 3 Nov 2026 09:45:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] mm: remove newly-unused page wrapper APIs
To: Andrew Morton <akpm@linux-foundation.org>,
 Tal Zussman <tz2294@columbia.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
 <20261102175605.a0d9caee8279ffb5f6fdf15f@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261102175605.a0d9caee8279ffb5f6fdf15f@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d1nz838go8caq7zbnc6nanc6f3tjdubg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4BE3E160003
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793695561-659877
X-HE-Meta: U2FsdGVkX19RkQEl+8MSnpvycO0l2bH2WOqZpJL1KwwanDL57zgrQOuZxP0lIYUNv7rv+qPYRBr1KQt4aF1HEI3uGr/KjMXKCa0X5h5eek0/t1vafkIzsUSIF6EO+AXPrJxFjec/jkikdrsSx0OOOJ29scfhkn9WJrEVV4doDVvRE+ym8bEGsWE75qxsY82yfXM6zJXeHQ+5/fTWIy6up2aOwckSpe64mnGZAt/lydjaNEG/h49IvfPhOSUMVOcUWRzC6srmfZV2gzWV3J0hKSzJKcaf9gcMyP+/7b3NaUYysEALaudnAJNV1iVEcPQFkYCiKfNISk7GLaOGD9MWLoRW/e5CA2P7boyLmtlQvp8SnZ+1bdtmtll/T9rgd31GwvWE9YaSbx+tEtaWV3j3vXtGH7muF9rloKH2YeP3d97kG+UOM6EpK9dtFFCOh4dnJmGworTuPxF/8VHPFHdBDkmORLTiS1VV6nvkTKE2r3bKRKEpK6xU7QOBF3axgvdp9ygVK6YMtZobg7brmUT3HRxhwGKPCsg6fIClbKG5QsV5VhQHRIy1y0uXSIbS+y+eJcpgrR2zR+zRVf3An1JfacUaPMTuDyFSPIIs4Oxqpq7S8ReiEZXGpXxcr7M+gMyICy5RvS2tQbK346EH2pJufjScZK0qwSSCXxVqL/ffMMB5hf69b7rK9zccWxwABFvkLwVAJNlVfQ7vcuHVA5c7+gxEaL3J/hnbs+Q9qf8wQ4A4Xgsj4Qh+sgPHdePT6v53cLwBf3sdxlvPpwB3GbR0Xs2Jt+xYX+kA3/qQOHkNdAgicrdkSRhepwOyPqYEMSAfWfk/PnVyD3w8Laq/NKk9qFYSFnANA4KCBqlXC9/i+K3x7J7hgXRIlo6ob9GnloR8nQbMYUJIUtoEfnmyQeLOJKCRZ1kSLUmnFLxWhyZmbUf2kQidsBNXBEDUfSSeNrAzMRP/CW44lTpyYoZV/WX
 GHMpZmlm
 KvXdhtTX5mtss0ZoHfcf1kq1earGFJagCs7HLfMg7TOKe57GMrSPi3XfrDE9NaBwl8ROP/0A/A+QIGNQOCNTZteDsmo4Ixf9wgxipQascYxS/YPMructolbQBzbxBaUvOexUavwGhaQENj5g7nWfYJFBMfFCpf7FHy5D0udBup/KYNhdPdinglzv/ZVvDVBz/sB3yHych/bSoMiveu8wtk19Bu5t/3CuRoNJPmMd9fjFKzYFTFy950edu3M1EozzWjz8STw2S4pHYMDi4kHsJN860QiKrbvFYYMFoGdgBy3LXHm5/SbwKBxgl23tIBEP1IjDPHDC+yfcRyDg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 02:56, Andrew Morton wrote:
> On Mon, 02 Nov 2026 17:54:05 -0500 Tal Zussman <tz2294@columbia.edu> wrote:
> 
>> After some folio conversions done last cycle (namely ceph, f2fs, btrfs,
>> fuse, and page_io.c), there are a number of newly-unused page APIs.
>> Let's remove them and update comments as necessary.
>>
>> Patches 1 and 8 are taken from the ceph writeback folio series [1],
>> along with tags.
> 
> Thanks.
> 
>>  9 files changed, 8 insertions(+), 110 deletions(-)
> 
> Tal, you obviously haven't been following along ;)
> 
> 

I would pick this up after giving it a little bit more time for review.

> This development cycle is not the one for cleanups and new features,
> but this one sneaks through!

Yeah, the focus will be on fixes. But smaller stuff like this or some other
things we wanted to get finished for a while that are easy to handle can go in.

All bigger work likely has to wait.

-- 
Cheers,

David

