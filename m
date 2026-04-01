Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C5F1D35144
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 07:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A07526B0092; Wed,  1 Apr 2026 03:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8146B0093; Wed,  1 Apr 2026 03:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F51D6B0095; Wed,  1 Apr 2026 03:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE766B0092
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:30:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 31A8C1B8552
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:30:22 +0000 (UTC)
X-FDA: 84609163884.11.82600E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4414718000C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:30:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qTjlT+Z3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775028620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1dlHf8hN3ksEavwQi7uGUJ6P1K8vhWTlQBs80vW480=;
	b=GqlAfTiTGZJcVahhX/rEIbkp/hincVd8dyr8TT+pmPAxFQYb/urIvYhJGayoZ2Esfx4IIO
	RZAQek6+9pxEmgivNmzH2gH+ZrVEWAiPITa75JNFu/yVYbab7hTsxbRGhPJYRuu7ol3dBr
	R3fhXV5kA29JWuqrfjyCMtNkNqU31P8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775028620; a=rsa-sha256;
	cv=none;
	b=OKxiK3gLFAhv9WEwxZtDMr8pZmj8KJy8Uu8qlIRpRt3osJ6scLTXvlnR+/rntcEBtoQn5W
	xc2YpT7giFE0/vtp2n1ovDE+dfP+IKMGHgUz+eW0GTTouxvVRwcnm81If8ezsod8J5sbAX
	PwHtuJ6a1VuvGDUaLd23VxrH40oYA74=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qTjlT+Z3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BAC540541;
	Wed,  1 Apr 2026 07:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C40C4CEF7;
	Wed,  1 Apr 2026 07:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775028619;
	bh=f1Ngdbz7uczIY4RWfNQQvAw4tyC9TKeVNLanQ2yWR14=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qTjlT+Z33eRpwuN3qRicMSrxRdg+ybY/sOd850b1NNr7iV9YylLG1TIu7htcvWEPe
	 PHS2kK7t164uPMtgxaSJWoytBMROaoHFIA+zD1FuW6WI7vo56Y5V1f08v1GoTb7D1P
	 zVkWh+YNPmGx4lj2Azna2IfuiHOEPOs0JKJQIdQGfBOTqMU9wypeTe3piIiPUz3lCo
	 Oq3/Uv0hI5C6AoiMYKGLqQms82bvPDnkQ6Sk9sFVcq4gti7llUxibJrn3xn/uJqsKM
	 7z/6L+/LYV3TZz4Z9+7KKN6pvLtlYlu1BxruR81iDsTUsm/l5y6HJxiPLXNdgzCBGU
	 Qw4tB6QbsjKBg==
Message-ID: <f8dc6424-9f64-40aa-9b82-b7d29a46cb48@kernel.org>
Date: Wed, 1 Apr 2026 09:30:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_io: fix PSWPIN undercount for large folios in
 sio_read_complete()
To: David CARLIER <devnexen@gmail.com>, Barry Song <21cnbao@gmail.com>
Cc: Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>,
 NeilBrown <neil@brown.name>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260330071229.14614-1-devnexen@gmail.com>
 <CAGsJ_4zpre2gUcYdZxY3s57=ESf_av59L+DNCYd0hZ3UtHNvSw@mail.gmail.com>
 <CA+XhMqw59iWLPQba5WSaF5Y7HKDgf3BjjBLn_X=w=g5tAk26-Q@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CA+XhMqw59iWLPQba5WSaF5Y7HKDgf3BjjBLn_X=w=g5tAk26-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4414718000C
X-Stat-Signature: gws3ra5px1jtw4nrf6wefnhpw5yrtd3e
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775028620-392736
X-HE-Meta: U2FsdGVkX1+ZyiEUbVn/LUaX6BWtLw67tO1HdeTDrsbFBObCMBQZkQJOOs0yu1dcPCaK/+G2khpjG9HAsvzJB0nJx/iHL4ju7JY9tHrrJSvUw5FqwG7WCmgd1WtDHMf3WAcGKn3oppNZr0nlAHIvcimeiylBUmcavMsn6tqaohGZaB7cLyUkoN53FewxFgRfVR7x7gQjvpwpSeQXKpFjicS6Eoxbz3GXMBh1RKFxU3IsITl66qIaOXFoODIsC+RgHa23/TscF34AQPgc5dnfl+hCN68EJyY/MpPBSM4ZX5jhdMshS3nwbJBXN7h1n7qw56ljQMbQmYWpqSzQ4xfejpSbhAZ3vi1otkhcvrali5s5ft9PPIfiSLNqneRsogy1s9htYg3Qvm1+vVzu46kGT315WhYZZlLlmRuO4rZnktkHQxcooJDZMTIi5NmMRPZBxm+o0+eKXzqmSJzw/pwLSUuQZjDQnabSJlLSOqvood6kDFfCobRzoOlcDkPSNb7w/cvXiLND4m5hg70LthqRQotfUva4IRwDmhSb1221FYj2BtiO0LKgr5vzUPmIFxdAZndpLi0HdnlVJiZb+YKPm/8dzZk6kBUVtfm5LhVZbN5IuGcg1xGNVQDFUFZHjNSWKfB4XRewYpoE8afi+XFf6JDJVHi/RkWJHbqxMr3DFV8XWb0D3j+KJHWAtj20vwKPFFX30jB8YsXXGnL4LLi8ENVJ2wAFsbocCr5Uyy91dM/xZ69qKjwM6P+1raGGhyhMuLu9E/92JIaU8aoFhYeGZjJXtElSpoSGYwwJh5prODSJw62UuzVqIHPdjgCRbdWBSs7HKoXRKAqH9/PCvCttYXGYOBp3biWXHGjIYmMmiP60h8zIfsx/Y7ABVfn7Q2rEwxuDhCECNFMwzGT+adgln0Tji2UzYtM5/YoJ44r91TMZtHnEd7TvK8KzfPuA6m1XtBwzWVuGvq0Aa570Xjy
 vJThG5Er
 9lg9WdFIaFNwabtyl1nZCrcGRNuKZNU9Q1tADddCg0tfzPzUHmwHFW0TCo1u/6mAv8CrIBHtD7kJi6lGAaARFWvE7jfxBT0CSMyH7uoy6fD9J/8bqTFPbpH/FYFa9A2dCQz9nyQUn8Ugmft4p7cWjeOYvxO0weSciI3721EnTXYqiNdI2U/CnB165q94uDo6XKwTiSHeIAGa65VtmIVuAwDl0QN8JGgEwyiP/2RfxF8PqO61j3leAaM2OWL3rsnfuBASDaWk7sw1ksA9aJS1PIaE/kq52ePsSQT/6Pgc5c1s6B6YICrhVwCsffTd77MBHgrPUrQMvPtoiWVXwBfq3DInVYJLut1p5n/+H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 09:10, David CARLIER wrote:
> On Tue, 31 Mar 2026 at 23:33, Barry Song <21cnbao@gmail.com> wrote:
>>
>> On Mon, Mar 30, 2026 at 3:12 PM David Carlier <devnexen@gmail.com> wrote:
>>>
>>> sio_read_complete() uses sio->pages to account global PSWPIN vm events,
>>> but sio->pages tracks the number of bvec entries (folios), not base
>>> pages. For large folios this undercounts compared to the per-memcg path
>>> which correctly uses folio_nr_pages(), and compared to the bdev read
>>> paths which also use folio_nr_pages().
>>>
>>> Use sio->len >> PAGE_SHIFT instead, which gives the correct base page
>>> count since sio->len is accumulated via folio_size(folio).
>>>
>>> Fixes: a1a0dfd56f97 ("mm: handle THP in swap_*page_fs()")
>>> Signed-off-by: David Carlier <devnexen@gmail.com>
>>
>> The patch seems theoretically correct, but I’m wondering
>> where we can swap in mTHP for filesystem-based swap？
>>
>> In both do_swap_page() and shmem_swapin_folio(), we check
>> data_race(si->flags & SWP_SYNCHRONOUS_IO) before allocating
>> large folios. Am I missing something?
> 
> ▎ The patch seems theoretically correct, but I'm wondering
>   ▎ where we can swap in mTHP for filesystem-based swap?
> 
>   ▎ In both do_swap_page() and shmem_swapin_folio(), we check
>   ▎ data_race(si->flags & SWP_SYNCHRONOUS_IO) before allocating
>   ▎ large folios. Am I missing something?
> 
>   You're right, I missed that. SWP_FS_OPS is only set by NFS and
>   SMB which have no bdev, so SWP_SYNCHRONOUS_IO can never be set
>   alongside it. Large folios can't currently reach this path since
>   both do_swap_page() and shmem_swapin_folio() gate mTHP allocation
>   on SWP_SYNCHRONOUS_IO.
> 
>   That said, sio_read_complete() already calls count_mthp_stat()
>   and the per-memcg accounting uses folio_nr_pages(), so the code
>   seems written with large folios in mind even if the path is
>   currently unreachable. Using sio->pages (bvec entry count) for
>   a base-page count is still semantically wrong, but I understand
>   the practical impact is nil today.
> 
>   Happy to either drop this or keep it as a correctness cleanup,
>   whatever you and Andrew prefer.

Best to rework the patch description (clarify that it's a cleanup) and
drop the Fixes: I guess.

-- 
Cheers,

David

