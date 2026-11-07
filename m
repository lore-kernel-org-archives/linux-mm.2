Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18DE1606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 19:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XPjXjKD8
Received: by kanga.kvack.org (Postfix)
	id 29D3E6B05B4; Sat,  7 Nov 2026 14:55:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D826B05B5; Sat,  7 Nov 2026 14:55:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E816B05B6; Sat,  7 Nov 2026 14:55:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D8C616B05B4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 14:55:14 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A7481203EA
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:55:14 +0000 (UTC)
X-FDA: 85409376948.06.26B4A31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9181940004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:55:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XPjXjKD8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794081312;
	b=XtEPFlIv/+qaupxg6Ysj7T8LJGhywtReTi+XmiNKIeVIY547wjIyaUmJlrEu2kjG+5fUuk
	dILcs1GBy6BHtEmIecY7TaX2SWmRkMyMfQ9CUo0aCsPj4nh5e5GoKC29+I03Xv+7qM6/uO
	YtQq1o+4j5kJipwpGRy5fUNh+6G4e30=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794081312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=39+TUkTn71HtHvq6NpbancWTbHR1aQMzi3+k/eHDkII=;
	b=GWVDFRpp9yR0cT49mIqPZza74oUjVXng+E0O2Tkf7wb2pob6vyBPi8Maqcc8jCaa3G9I/q
	pQjgCJCVp+ou4m2lx8Sa0GrA0d3D23/1muRfkwRUVFbl2BVealEhUr88uw71ysbW2rDIup
	uTEYqR0s8krg7ks8IvyjFbDE0kOEszU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XPjXjKD8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF1D041A53;
	Sat,  7 Nov 2026 19:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D291F0089F;
	Sat,  7 Nov 2026 19:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794081311;
	bh=39+TUkTn71HtHvq6NpbancWTbHR1aQMzi3+k/eHDkII=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XPjXjKD824HOWovf8zZKb5c7Cb7I3D6NAD/lB0a8I4g19WeIXtgm5YZyMR/Kiu++6
	 B4OWZfuSb0TuEbG5bmrG2bK+f6320HjkTn4eSxLkhPYPhJuAPI/Jh8ChZpPIFGLunD
	 0gzKkwqLlZI/nC5lfdscz6x4B0dc48SJXcDriiVIugJYxUjUYpWFyBPVUqiU7J53nT
	 qFp9AzFPMSyoVTRSUkTWQiQs+YzS5oVk6erZmbjDuwzJEDle3ZhX+A1fth88v9z5+2
	 egk4SzjImL8w9uEXb6v3D2msUKCRpiL66AJ6Xjc38rUj2CfFgXhL+hTpCJYEeJMPhT
	 2gHXaIkgPZbVA==
Message-ID: <f0935e4c-4165-433f-b454-069e68c61a92@kernel.org>
Date: Sat, 7 Nov 2026 20:55:01 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/4] mm/ksm: keep smart scan from losing duplicate
 pages
To: Qiliang Yuan <odys.yuan@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
References: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-0-16d5ce8b5fd6@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-0-16d5ce8b5fd6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9181940004
X-Rspamd-Server: rspam12
X-Stat-Signature: rwe41zu83enurbzoq7ktztnqukaymkxn
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794081312-305606
X-HE-Meta: U2FsdGVkX1+7gFJieAtlCad2NXK+lrmt+Wtw2vk/WXz3m1pkJHhMOe3P6izosUGQk1r4cGgv4xqz4gYmK6i4nn1e+3Y9XyK2Gvep7LhtTghOaelltUvhreGCgp/SeaINu7yxy8LcU42v7muLtBGQALbmzzYRPWJnAKM1iIaM4p45gqAig3mdGsyA620LYVuPq6SyvIWo/dX3vZoiRgpsUVq7W8KuGIl1LubzE5keGUbY2ULTVrRT/KblaELyxr/N3XZ3/lw1wSz0faIQN88jgIrBUNbbsfMZYW1EgG07sNP5vRax/4Ys83Dx7N0MgwQRSoWDW7w8ENlp+R7euhm3K02ZzfpjBCUi8FuhRneWAmZyHsB3278+Hfjf6JWhImuI71UYGslqL/yBd7t+2byUMJ4lVoh92hdktMQ9Pt0zc6/LmsCc/mIbMNaARUHQCqVLoVQwUwoSWzAtIM5Ac3Luf7Ks7VRQkAljlpjkGBQr/hPxuxb0LEOWxJZdyARBwYSgceI47e9w5+qIjFtJFSu38MA/xdKjoHrmxq02nVBmHREpS+xG/oiSfEKdpTfmFUohGcizyy0vawHIpsmf6l7U97f7twaXwr04rkhuoTZZ9I+lCKW1BSQ66GuRqW0aFXgyWhM+cefW0olIiabwQseTraBhW7xeihR2349hUwMABU1vlJwkAENE0ZVq9xpC6QR9BtwFe7IjaVGtxfNTvw+oFOz1G3NnI8OgPF0S+x5RS3Ah3cZAhPruwYvuEKnPeQMEikNjoEBPg61B1gARUjqQX7gei0zxMGrNZD4uKXJ42NgTz8q230bx0jUP2OwLQeImfRBOITL7ste1O2TYN6JHLR0/zUaanYauRsa8guhmq70uIYCPeLAYykgUgBtwt0FzWR3Ti1QASmjlYfPFKxvVIhFg84PDk8PpWAeXCAwSZdobUeiKbB5XBhriHkTrSkO88DseyMZJ2d1HQOJtz07
 uNyWvf+Y
 uuvFujPjYJGFxvumcIuoDSAE8yzV5QIdpUxCJvec5Y6llO4urJ9dyGAbh0JlhRzeq8+9i/K3ydd4GA78zzE/n7Attml9Oso+cj2Y8iDtJtIVC8t2rLSD11wvoknmdOJ+othGozQ+dp+6docihnILrRooE3VQ+Tt2Fj/x7/y0dZW4+ySDtOaNMnppzGwxsae2JzNDII7pRptiPUOvmr4VLZ/FM9iX0of634iys9/dTV13xDxtDMWFxvi4079u2+Kssyoim+Ns8kUfGJ2B8Bdo9bqsWtF4Mk6jpTV9zOWOlAhVDIiSRb1ymsPqWGUyuQp14nCiV9Lcxj1hj13nljfAmSAdatjaM4Q7xaGgsaafYF1VSCXqH0Lhw+pP4xaH9+y95utJ6B2RzOemVBq1D7TXifM/KhNz0Oor3P/AUr+lUpJDiQKBwUvR/Kzgb6gAWD4s4y/JcDXJfFcra4V5HCT0U7wE6vgjBWTKhjwuI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 17:56, Qiliang Yuan wrote:
> With smart scan, which is on by default, two identical pages that become
> mergeable some scans apart can stay unmerged for as long as they live:
> each page times its skipped scans on its own, and once both are old they
> may never be looked at in the same scan, which merging through the
> unstable tree requires. This was first noticed as intermittent failures
> of ksm_tests "KSM NUMA merging" in run_vmtests.sh.
> 
> Patch 1 picks the skipped scans by the global scan number, so all old
> pages are looked at together every eighth scan. Over 420 pairs made
> mergeable 0 to 20 scans apart, 361 and 334 merged before on two boots
> and all of them after, at the cost of about 10% more ksmd time on memory
> that never merges.
> 
> Patch 2 documents how smart scan picks the scans to skip.
> 
> Patch 3 moves waiting for KSM full scans into a vm_util helper, and
> patch 4 adds a ksm_functional_tests case that fails 20/20 without patch
> 1 and 0/20 with it, on both boots.
> 
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> ---

I'll wait a bit for more review before I queue this, thanks.

-- 
Cheers,

David

