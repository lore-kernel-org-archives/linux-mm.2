Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8D47606A335
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 20:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dh32LNST
Received: by kanga.kvack.org (Postfix)
	id C17746B05B8; Fri,  6 Nov 2026 15:46:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF156B05B9; Fri,  6 Nov 2026 15:46:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B058E6B05BA; Fri,  6 Nov 2026 15:46:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85E546B05B8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:46:11 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2787F1C2413
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:46:11 +0000 (UTC)
X-FDA: 85405876542.08.428072A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 560B5A0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:46:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dh32LNST;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793997969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=21rPeGQN4m+gmz77llR1oP7XvKWuoASAddhYLzUcGNY=;
	b=UujYDtBPaCLAm3OM0+xyXKi8E6yq1yE5jSyYOklZo19CtwHd9fVhTboywOpn8B5NBZaKe5
	34JlBmKBMAcNHB9OCqAUv7BaXdeJwM++osK2P3Lj7I2oLWysCbZjiifhL9AcIHWcIC3D3l
	UzicQm86EILR/VMwFkWcQPqPDgE6jMA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793997969;
	b=ZXsVwV92Lo1hzckuiqgrM3YyFJjJazTMusmypnFavL6Jz1+DAwdr343tdMTQt+sixCzLOr
	O/audLcs+6nzX+QmyIxp56nB2neNmRj+z1YhN3yyPrJjHOo3luTmMAzSDC1XG53B/GPiZS
	hmfVkgosuE0dLbIICtJv52Jj0tmCPXs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dh32LNST;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8C826020A;
	Fri,  6 Nov 2026 20:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC371F0089F;
	Fri,  6 Nov 2026 20:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793997968;
	bh=21rPeGQN4m+gmz77llR1oP7XvKWuoASAddhYLzUcGNY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Dh32LNST0N3JC7WVundUzUbSPcEot0NuPwkkB3z4MmyPcUtS9uEbzNbhjYRrcgSb4
	 pEhVr8htSyiLzDbwlK5Zpmi+V1H7OAQSsuUaGIUD+lMDbRvd9JBiXRZC3K4cJp0rMz
	 l5jQyTnnnUNNe/TDH18fKXc5v7HLGeoYJiCdfJF1QZ6AdkwBGIZXo5Be0gviM4lRiB
	 eMNY4xCj0vApLZLhaTCmCLw04lhHTy2pRQJT1hhKItxsj67y6+A4/hLhqKHzs67pWY
	 Bc5ygmim6ocR6Yq9GUFmkaGSxuoMqoIiV6JqoJJXCApMiC3cxbvxTknS9mgqrXcN1N
	 MNBmeUVw/Aljw==
Message-ID: <25e0354e-f6b4-4d42-b5ec-1656c9df8308@kernel.org>
Date: Fri, 6 Nov 2026 21:45:54 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] mm: limit pagecache folio refcount when splicing into
 pipes
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Josef Bacik <josef@toxicpanda.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard
 <jhubbard@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 iommu@lists.linux.dev, stable@vger.kernel.org
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
 <20261105-refcount_overflow_stable-v1-2-70b9c655da3e@kernel.org>
 <n3l2cnx6d25jovloqyoxiz566mh62janclmiewjvumtmqfezo7@zmsmco5vvssn>
 <23f947e2-ff06-426d-adb7-396871304736@kernel.org>
 <20261106204310.GK663069@ziepe.ca>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261106204310.GK663069@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: u4bymetqbutpcn9tt693cumdjzampq89
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 560B5A0005
X-HE-Tag: 1793997969-937445
X-HE-Meta: U2FsdGVkX19Tm/w3fTcqshNvc5W1u5ULzv+wPDfuac5geafDGyARdho5de1CBoOvk666tgvslDFeNCJdCWqKUCxmbFDlyN6SDDtH4Xfcc5uQ//qE/08DMruiJp5faLxAhgFFAGVRhcOgvKEzJwgbrqcVLchmIxowErMFtCNwAaDapNjkIUjJLkwUqAsmyxSNisl6vu2Blbw4Umxr6a6lYt++XeJ1P/DfNDD8/T7xhfE6usqUATMgnPO0SZmjYR4BOtSi6sb+0ht9s3oNXPwEgntCVtfiV8Cuqyt4baXtqYCaY2dU0XKkr5f4+hcqATBOGGYF1ZosMU73zd5DflNN1M6azL+h/JB+m0CkP0ORXcND5MYratvQ1EWMwbvrGetz1jxxpaYo+4sPAuMUM1e7TwEoqIHZaqSpBmQa1pc7IPni1KALP7pFoRkE8UHe4icCFlKf8xU0CAQt9ypB37E7/ythgf9BVSd2EhpzTlQzvv0dtOqxreiQU39HNPQOXK131ZUaiVODN832Mi+9oy3s8LYnMgQu2GCQ2Ah/LbhfOQ8HY5IvitBROQ0GMXNveMlfkVYu3QS+RlJTBtAfdWB9ITAVGmDrCvD+ZQlF+KZ1Wvz3jLRxEXisTC6djEvcqTUpPKf9bk8/s43cgeqNnHk9yKaxDdMKjnmeejLRfaDLQzwiKtLyw80HL0nxq18ovDUwLQtX21RqPC7ATD9VO64Fw8STr9rSF7+R6rgn0XHxfL1ksszbnSbX6MZNgbz4NsKt4aG00oj/J+AA4Swq8TwZmyiUW6ZipSu6BeCTS6PLEcHVVYKDjQ9xpgg1FNgoWgYmT4X2aKR4jcZaSCoxezq01L10KUXmFETxMYp+n+j/FJV66Av+sA95wpMthdm7d5ru9JRWt4wevLtRhy9PR1ObFTPQba89QRNFFru/h92TWPoJC+Dsg+LXjcJUgjohmw4MyPVRgzZR33iMku7/YSV
 DJxMu0Qn
 DrX9kvms0zjEuQdUyHHG6oJOmPuIoQY/Hz8NeGd0OUuBZwrZrR1cef5y1Y144nL77RGjaYHRL+qgMe3tqNU24Bk4Y0Ba8veQ5GJbiJeLtnMj7FR1RaxsHkfQcmDr6FsahTyjaaR/jZjHeQYZX+ZepI9Dot5NHC7yxZ1vUrPQLb2schKFGACCZ0sSKGrkb0/LI1GWgmEhjoS46iqZQU03cK2q1V/0diT5vD9bQTwF+t9W5zY2Nrq280IKRGeJueoSHywDeL2aZGbwn3F+Mev3GAV37Df2Q4FLMCHGMEGIoJPVT5CJ7DC6UtxP48Ygl4MMt4gEXuDcSr3p16Jw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 21:43, Jason Gunthorpe wrote:
> On Fri, Nov 06, 2026 at 09:09:10PM +0100, David Hildenbrand (Arm) wrote:
>> On 11/6/26 18:58, Josef Bacik wrote:
>>>
>>> Since you're here anyway can you change this to something other than
>>> WARN_ON_ONCE, since that results in an OOPS with panic_on_warn set?
>>> Thanks,
>>
>> If it actually turns negative (or 0) with out changes, we had an overflow and
>> for sure want to know about it :)
> 
> Yeah, didn't you get Docs merged to clarify WARN_ON is fine if
> userspace can't trigger it?

Yes, I pointed Josef at it off-list.

-- 
Cheers,

David

