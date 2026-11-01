Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F277606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 07:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HmjRhNtF
Received: by kanga.kvack.org (Postfix)
	id 8A4B56B05B2; Sun,  1 Nov 2026 02:03:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 855F86B05B3; Sun,  1 Nov 2026 02:03:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744916B05B4; Sun,  1 Nov 2026 02:03:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 48F676B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:03:24 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2FA44160A20
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:03:23 +0000 (UTC)
X-FDA: 85385659086.21.0DEEC86
Received: from mta0.migadu.com (out-220.mta0.migadu.com [91.218.175.220])
	by imf03.hostedemail.com (Postfix) with ESMTP id 98EDC20008
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:03:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HmjRhNtF;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.220 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793516601;
	b=jfffiOWz7lHBG2eEo4gRpcEsBCrGwzLWzd2i653c07vc1mxsXFWdFwmROnmCtcTKlRc7XT
	FXImf4XVYtI/kPOEMHcz0Wz+ycn61gTA9ln2C7rZMWGda7/8lQ8dMMlrtTUOru69E6+Cpr
	8kU2bLRauEHgkiKHlrkl1kuYy+e4e4s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793516601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nl7Y0ltmyhqsbFrqqW2pUAR4nkRi9ta+ZSmouMpNStM=;
	b=zqytjQF8ZP4t14tZMLc9xoeTEeIwrfRGb3168oZDb2lmRaJecZhL2BmL9ER+3mlgvTQtv3
	BE5p+HfTrHAYILfcR4/djSPfj/KXeSiOZ2TCbcOmd4HWgtrLmQA+SOk+biFFE2MSrRbDDB
	qVQUfGlyNo863r2GQfa83QWJit6HpAQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HmjRhNtF;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.220 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NgTxkg5an6zNGb4TVDESTT1yytc+uqZLeNaP03K8SIs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793516593; v=1; x=1794121393;
 b=HmjRhNtFP9MTztqwBXEtL95Ec+JUIBP8UAMMaDh9y+UYyL9u4Pl9plQG65BKci3WldEU1R7e
 38MrqN3TYft4fUXWOhuEtvpaOe01NmvNWLXim9Q21guiaevNuUNrLQTwrnWOV8HuxzQ4QVTtRSp
 iYioR48rRW07brpc70Y4Qdc0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 221077d0a1b97b8f;
	Sun, 01 Nov 2026 07:03:13 +0000
X-Mizu-Trace-ID: 221077d0a1b97b8f
X-Migadu-Flow: FLOW_OUT
Message-ID: <c0201c6a-be33-4ebf-b190-f819d4605363@linux.dev>
Date: Sun, 1 Nov 2026 15:03:08 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/12] mm: hugetlb_vmemmap: simplify shared tail page
 handling
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, James Houghton
 <jthoughton@google.com>, David Hildenbrand <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
 <20261020115824.823278-6-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261020115824.823278-6-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1jwysf8kfe1fiujj9i7smhertd5ukn6f
X-Rspamd-Queue-Id: 98EDC20008
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793516599-469893
X-HE-Meta: U2FsdGVkX183VxJ+9BCcdXqijY+NH9YrVdNeITD9628dGHC8S4uc3VqYW6DEHAfFTg9++vPGC6gK0xMz7c6Ws/kb7fAASByIB3P+Id1HxFQjtcRHjgsUKKdbP7gMKL5JD+Wt/i2DuSKBtHQX68uetyTRSmyF/euEPgF/bMVh9agi0jbB9ulwLsxGyBOFL+90oxxVV0LwvAerJ2kr4ckfCaCa8BPjwLJgxkXbk+jAemyBuELXchefZiS/dXP4uhM/xYEgCf0NU1Al/x6XROBBGbz39PDLUDqRMzGwNqdKBLaRkFhAekt+ikQu9rdEooEkTtjGNfNy1kwEhyp79hzxZc3m+rGlHZsa0VIxwyZlOEtD4z9wQ1iS0CSNHcn2dUD4DCFf/HteyvQ2O9B9nHJVh9xl1wPoJjJ1GNNgqKZHHyOVQ/dVmnSpqiVAmhCVcUGNhD9Pf8jg2MGzbI/w0Vs5pySn21p4v55E+i9LZROK3V9l412bmhO6RoH6KmRKVhVpFN8LMSGfYwpnbbUP53i4ktnzu4os6WyUNxRazDpkhKy5ehsvGEqfU7HtDsbF4X596rM0EHOtIFI/1R7cCx/pHCYJQUi+gVd55ZFOJaxk3SgH3nU7m+5+wD18FzuNhdK0k5NUkOhT6A543+LNdVHCBQGL2+mBj9x556LjE96VKk8Cyn2VEe5MzJSSHPk4VixsDL/Q9T1zmTqjIGCsPu/zXjge1XehmK5sH3zKx/6FIzMIX/ESGfNiTIWKdp1TaMNKrf8vna999dMS1eWWOk5DMimyPw5K/hR89c4H7b+MJFXE5oMmqpNWGsGoj3aMO3Cq93VIDLD7tads4yhKHCgn5uJD9+sf1wR1cncdT/Lw2IbgkbclwlqO2Tj77dLVg7VkWVrd2i2YZufGlwzve2qy2mk/B7Ju3ydADQzNzWS1TCxAMdrYPd3gyuuGO+cUEMBhqeQwbws4qD6+U9XM4ml
 NVCTkUZP
 M/aypB5LjRXYlLXPoec1qMSlW/xqkaHskdfHcdNhiIbBxfNcGG24XjZlKj2CcdKmj2f0e+6hKWkghgbsM7cMSXHLiTqnyYbUuW1B6UPb6ha0DOJSE/LnceR9rSXA6dz1GMvjfDvWbpj+HfX5Y7cVuJA16KW3E32d6jkLGLNciPuo4B/7w6/un2OCxWnvCgZ838BhN9g0F5e07z/9nOwd2u+kLxonqttJHwDE1vb6HnqNOAVbJSrWwfiozW/lm2npetqdxSh2hTrL9U6Iz1e0vFSXSD5CE+oAu91dC6Iwn9Nvnwxbd8YYqWOc2T2UBFbOrbo4n4+jfG9njawTLa5QktHv/Nd3KGzh7MnvXEPbwR8qxNgQgVw2nN6eimVqaXI1zIlETA6s42jQxh9HaLeGKDIZaa0YHFhi3wn2gDBAl9JOXn1BnrISXrXVULZkwwXNci+dR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/20/26 7:58 PM, Muchun Song wrote:
> The remap walker currently carries a shared tail page selected by its
> caller, even though the optimize and restore callbacks can derive the
> same information from the folio being processed.  This adds redundant
> state to the walker and couples its interface to caller-side preparation.
> 
> Derive the shared mapping state in the callbacks instead, keeping the
> mapping policy with the PTE being processed and simplifying the remap
> interface.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   include/linux/vmemmap-optimization.h |  6 +-
>   mm/hugetlb_vmemmap.c                 | 89 ++++++++++++----------------
>   mm/mm_init.c                         |  6 +-
>   mm/sparse-vmemmap.c                  |  5 +-
>   4 files changed, 49 insertions(+), 57 deletions(-)
> 

LGTM, so:

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


