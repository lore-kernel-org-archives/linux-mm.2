Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2841C606A323
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 10:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iXNXvAzg
Received: by kanga.kvack.org (Postfix)
	id 251786B05B0; Mon,  9 Nov 2026 05:25:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DBF56B05B1; Mon,  9 Nov 2026 05:25:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07C156B05B2; Mon,  9 Nov 2026 05:25:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C81CB6B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:25:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 47C191C3F51
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:25:39 +0000 (UTC)
X-FDA: 85415199198.27.AC2414D
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5822414000A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:25:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iXNXvAzg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794219937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+EuBSGaK4YOu+FEw+Tb1D5cwuOQcvEDWrfjmQfxZFs=;
	b=vqXyLJEkHrx1Sckdh1WykEt0YJ+hH27jHqQvJDY0cw6wtLhNAAvOtlgT8DcD+mzMGdUY/R
	sKafPwgSg/AfLiVqoPfpXO/3PCplQrHbEc0XDbEbjjLR31DlAU626wz8ApAKX9OBeiojd4
	+Qm5X58UKmRhNfpROKVdxiP1zJ0HDVo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iXNXvAzg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794219937;
	b=FzWt9VZqD4qQfs+1wgtSeTAcDg59FQP/eNlMb0Ak7ZYzEAdB3qTJye8cJ7mKTJj7S9Mcc6
	wVq6zWsdXL9Id6BEBbbWMyKardC7Rj1DpJ76Ar9ht1+JSTdU2sR4r43rBmHgV3n1WayQVO
	XGEN3CnvpLqPN8GclDfr/mnItsaRkfQ=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-490f38e9688so539336f8f.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 02:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794219936; x=1794824736; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S+EuBSGaK4YOu+FEw+Tb1D5cwuOQcvEDWrfjmQfxZFs=;
        b=iXNXvAzghrpCPusj3s+xd+GtXuzWuwmjetwDvs+2ewWwFnddoKHVW4rr7ri1hNjb2F
         1m16B3h9e+4uWA2LSs2FAKhmKWL25WjGIpBsS5kVQLPWfZTfk53If4bCfJOTGb6jFnmK
         i/eMZBGB07LeiCskmpNhpvhVaEtopynre0WOdl0l4dOX5jB9+fTdToSBvby6yxrR4mFh
         ux1MSCVMmex8BqN0QDF2foz9QAMon9/q9w6HL2kV7utBx2dfP6ri6renpLEv5/yOAvSP
         IQiXw5jdv89yXILYc6gwJBu1n+vKBDY9JOOHH8q2aOagKRLa33k50eQZEox1yeByaoWs
         K1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794219936; x=1794824736;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S+EuBSGaK4YOu+FEw+Tb1D5cwuOQcvEDWrfjmQfxZFs=;
        b=1vyfgVrn/gZVUPh9jGHHnyZD1Yjbwl3txDHjLDb36A/8vnJrVl2cbN9Q0ihntl9RQr
         EQbGSbVTUtXmvBnJXsWlPbsdjjSZyCIRPH9aA/P7eLeNVddyUVPAz3oMXWLItDlOwDo0
         GrwTX7r5bUU2c61tlmAgCAnGaZYVAIyQq0zoFgWJgRKA4MZLgBFlef7HLbLfHay1VUqW
         6SKkUVkTJvuPeZpH4Mc+idZ5OZ0YVIDmlcbWF0wtxh4FF4ukyZWpoWtrC7Y78MqinxtL
         a+tgdo2xAuoQc9i/BKBj0w43oeLjVOj0gwe/ddi6ZjC9AD/0C8pGeJ0slGaEF1T6fxuF
         MXCQ==
X-Gm-Message-State: APuU4Z9MgobX7cqkW97viw/Ts2uCGhgBweXvJQRlIgpehkyoi0RLDFlx
	W/tY3ByTltSmGp2ekZKc2gsK8JRu/o5ltwDGpp0chilPI0LzvVn67Gcw
X-Gm-Gg: AYBFou1tY52JkbmamZ/ZJvyPwHZSDwq2hSzJ6rq5AyQlKL8VRuO+iifQkayrwbCOzAn
	1GPbJfDBOnjn+QWKPGI/MQdbXuCBSdzx5dwnial/N0bdX1zNEJZieyTHxu09hdI6G2Tn5GD9SF3
	Rk/RoDqbr2ebdR+nBwF3o4UPmzNB7Bh6iUWTAA4vyX0TNRH9gtGGxck/93yDm8tfG5opEWeQb8l
	Sg9WSssxHiTrYLLpPYO9urezN6qCicNz6IbcBYGQRtdxt66EOggNdrzCtoY+NKk6gCVSRp/vSoD
	afqZqTQyy2TgxkPtkCpxilSdOc5WCeXPpN01CVa5ymfXoqgbZUMlxsG8AN+9+4TsOEldXZ1L13z
	WXBjFc8tTIWmfGdmRmGXfPTRqbmWJs/X2+11Y1FITuh0pS25SWUTY2LmxLJKYqO83z328RBrAkG
	8oVHGrZ4dHeqHkAsHNaHhXfYAPC+dU+t2AnDUmJdN08+qrH7pZ6PbnIuYERiUUhKN1qDh14EkOh
	O1Xz385WgFcWManePMuMsxkL/UC4K2UOQaKn9FvN4g/wQt0SQFXuuoKfKTxmQ0Ia9DoZreJp+EY
	pQf1KC1sgREtEhlDJ9BYCpQ=
X-Received: by 2002:a05:6000:41d3:b0:491:632f:2c8f with SMTP id ffacd0b85a97d-4941f75cac1mr12200348f8f.2.1794219935759;
        Mon, 09 Nov 2026 02:25:35 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49597371cc4sm8791060f8f.36.2026.11.09.02.25.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 02:25:35 -0800 (PST)
Message-ID: <ad09d3f5-986b-4337-9e32-1de4e5b18d71@gmail.com>
Date: Mon, 9 Nov 2026 11:25:32 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] mm: limit pagecache folio refcount when splicing
 into pipes
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
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
 Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard
 <jhubbard@nvidia.com>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-arch@vger.kernel.org, iommu@lists.linux.dev, stable@vger.kernel.org
References: <20261107-refcount_overflow_stable-v2-0-c38f6809b106@kernel.org>
 <20261107-refcount_overflow_stable-v2-2-c38f6809b106@kernel.org>
 <a9fb2d3c-d518-49d3-9479-a25fa2cfc5b3@gmail.com>
 <8d23b1eb-72aa-479d-9486-dbfd86d8414c@kernel.org>
 <43fc45ff-8636-4961-a80a-29844c15d7a1@kernel.org>
 <aa6ea9df-f767-4092-ad8f-f10305e27c3e@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <aa6ea9df-f767-4092-ad8f-f10305e27c3e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5822414000A
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3mj1f6jqqj7dhayhh53nwg8i91uft4b8
X-HE-Tag: 1794219937-692949
X-HE-Meta: U2FsdGVkX1/lyS5fXY7vyGTFbRyO76+R0lFwfKtf5GKTpcRta+dS3dZaIJZz1lxAzY76VaeEcAn0y3aOCWEoplqw/N6Qfj01Bf1uwmCrrqZBnYXNqK0BrJhChUQsqEdt76uSuRU0YVxifPF6MSu1Zqn4g9XAXS5fooC1iArjog2CHyvXeH/2ZF6aZ+IaHwww/FO6Hy5mSasJwxLQQqbRaQYWilabcZIh5OcWtPsC4SyQMSdqW3DiG6/1bro7OzfR9w2pU8MrMCoGCu+v9azdksiJDtYV57G6Kib3ATvZZJYZ7FENfzCqv6KU+wo/u1otY06+Xo8yDIhOr4zf6mTZ7jtXtRYVbb12nUfjp9MvwRHC+nomVUzAnkYgjDQNF4ytE2spResQAggXJreL9VbGX0pXFiCoe5fUjBWAz9w48UK09Q4Prj7cOUGfUdaGLu3ggoPtD9FU5/TQd9q0EYIu1t0qZVl9aeB5R1K4Zy+CQgirH7WKGn0t3IK45T2rs+d4B2AQEfr3ibZXRQCkKFF6afiAOvxCyFAfeVOHTBtXprKVaZ7sOsrZEqV3sWM98nbkvRQnC10aMQkInw9CsOzhAWjsNvGigvzb9tSBi9UGYuISxO1qxUxmwKFe3ssd5drnUgPGq23gUoT3vYCXap+mXoiMnuDa5wpsvqDCzpSG0oVBJvdTnFfPv1Ge7NxSpf0cW/TjS3v2/t2KyxjZWcjZ7jHYkvMWYu6a6JQYVy+FQxUjXpOgn/dxAXfF39Y8XqkIt/rTkUVwVDjcRVLb10iVutgsMV5gA0KLR5QUHOyIqpxRMejfPRfZc/oGhl1aqkRqqIdrwm8o3Zle0GmFHevVOzt8mq9HIq43aF9f7DhFu6Vm2V26RKFKwuDFm3YkGKBHdhTfdsMJaiwD9VLutZ+q+jezQZEUeqjEJAXa8YCsQ6gQK/KA3+sw0wEv3/7Kw2nm9NCkkZaLS4RV2Nntq54
 Nj0HkWaJ
 TULvhdcxaTFIVYCptEdkmD7TMym/B6mOPTar7mRfGLkXNHcrVOhdcvr0RNBCQsJ7PCMczIQznv8T04VjZCrLqoD1CUayNCL3cIrjSGV8MZM7wM7QxvyROPeBJtjntx/ZVb+DThW0Y5NbEpdnu+tq2xgKIZAFd/DALgIzlB58ZbflMzG4HSiaIEFYFgKf2RAKJ9/GBpaD6OuKzXf1UUmCATtxTmMsYbPTDlsxdtDRZ7sJQEi5XsRXzspclTaI7WWqipfWYFsPKg5SlUTHpoudK/mQFneHQzfuLgCMflBlpT5OA35YSxjumkXJDAVKTYXVdOAbayNi8wvwRh2ou9Znbi3QrJye7hSkeaPsxfSz+TK7FlmBRnzy1yyZIMJEN7nxNG8Ah0xEfUTm4L3DrO8j3YNhKwSh3RVD6J6Dt8/w7/aATQclRydK2NM5tqfSVOdfC7qfs3aCCjrXoAvmQP1RXMbRoD8iij4283Ph1nvv35dJne0aZfRb9ev4q0dA8SoEGtiJMNlOf3JS1hZOAyfiVYZ4nd+8WmwMEF9Lr7suBbgCslYeLj4q5o/0abA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 11:08 AM, David Hildenbrand (Arm) wrote:
> On 11/9/26 10:49, David Hildenbrand (Arm) wrote:
>> On 11/9/26 10:30, David Hildenbrand (Arm) wrote:
>>> On 11/9/26 09:57, Jose A. Perez de Azpillaga wrote:
>>>>
>>>> here it can't tell where the -EOVERFLOW came from, if another file
>>>> returns -EOVERFLOW (i.e. tty_fops uses copy_splice_read, and
>>>> n_hdlc_tty_read() returns -EOVERFLOW after dropping the frame), it now
>>>> gets a second read.
>>>
>>>
>>> That's what claude told me during review, and when asked whether that actually
>>> happened in practice it said no ;)
>>>
>>> So is that actually a problem?
>>
>> Double checked, claude managed to confuse itself.
>>
>> n_hdlc_tty_read() can indeed return -EOVERFLOW.
>>
>> I should just have let splice keep failing, dealing with copy fallback starts to
>> get annoying.
>>
>> I guess switching to -ETOOMANYREFS should work (and might be a better fitting error)
> 
> Yeah, the following should do I think, please double check:
> 
> From 7ce030711737e8c26fb5500f2705940e93da0d44 Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Wed, 4 Nov 2026 19:02:48 +0100
> Subject: [PATCH] mm: limit pagecache folio refcount when splicing into pipes
> 
> Similar to mapping pagecache folios into page tables, let's reject
> additional references when splicing folios into a pipe if the refcount
> is at its limit, similar to how we handle it during GUP.
> 
> This will prevent more cases of possible folio refcount overflows with
> large pagecache folios.
> 
> Let's keep it simple and check in the two callers of
> splice_folio_into_pipe(). Return -ETOOMANYREFS if the limit prevents any
> progress, so do_splice_read() can fall back to copy_splice_read() when
> read_iter is available. This keeps sendfile() and other splice users
> working when ordinary reads would still succeed.
> 
> Also fall back to copying in FUSE when taking another reference through
> fuse_ref_folio() would exceed the limit.
> 
> Also check in try_get_page() to cover pipe-buffer duplication by tee()
> and partial pipe-to-pipe splicing.
> 
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  fs/fuse/dev.c      |  5 +++--
>  fs/splice.c        |  8 +++++++-
>  include/linux/mm.h |  9 ++++++---
>  mm/filemap.c       | 11 ++++++++---
>  mm/shmem.c         |  4 ++++
>  5 files changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 3641abb90d6bb..4f6b7b42bfd3e 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -1265,9 +1265,10 @@ int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
>  		if (cs->write && cs->pipebufs && folio) {
>  			/*
>  			 * Can't control lifetime of pipe buffers, so always
> -			 * copy user pages.
> +			 * copy user pages. Also copy folios at their refcount limit.
>  			 */
> -			if (cs->req->args->user_pages) {
> +			if (cs->req->args->user_pages ||
> +			    unlikely(folio_ref_count_over_limit(folio))) {
>  				err = fuse_copy_fill(cs);
>  				if (err)
>  					return err;
> diff --git a/fs/splice.c b/fs/splice.c
> index e6d43329ed3f0..2fc1279628af5 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -956,6 +956,7 @@ static ssize_t do_splice_read(struct file *in, loff_t *ppos,
>  			      unsigned int flags)
>  {
>  	unsigned int p_space;
> +	ssize_t ret;
>  
>  	if (unlikely(!(in->f_mode & FMODE_READ)))
>  		return -EBADF;
> @@ -977,7 +978,12 @@ static ssize_t do_splice_read(struct file *in, loff_t *ppos,
>  	 */
>  	if ((in->f_flags & O_DIRECT) || IS_DAX(in->f_mapping->host))
>  		return copy_splice_read(in, ppos, pipe, len, flags);
> -	return in->f_op->splice_read(in, ppos, pipe, len, flags);
> +	ret = in->f_op->splice_read(in, ppos, pipe, len, flags);
> +
> +	/* Fallback to copying when hitting folio refcount limits. */
> +	if (unlikely(ret == -ETOOMANYREFS) && in->f_op->read_iter)
> +		ret = copy_splice_read(in, ppos, pipe, len, flags);
> +	return ret;
>  }
>  
>  /**
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 3356f7a670d1e..dd50262a70758 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2288,10 +2288,13 @@ static inline void get_page(struct page *page)
>  
>  static inline __must_check bool try_get_page(struct page *page)
>  {
> -	page = compound_head(page);
> -	if (WARN_ON_ONCE(page_ref_count(page) <= 0))
> +	struct folio *folio = page_folio(page);
> +
> +	if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
>  		return false;
> -	page_ref_inc(page);
> +	if (unlikely(folio_ref_count_over_limit(folio)))
> +		return false;
> +	folio_ref_inc(folio);
>  	return true;
>  }
>  
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 920bbf86dfdff..44b23c51ea45f 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3094,9 +3094,10 @@ size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
>   * Return: On success, the number of bytes read will be returned and *@ppos
>   * will be updated if appropriate; 0 will be returned if there is no more data
>   * to be read; -EAGAIN will be returned if the pipe had no space, and some
> - * other negative error code will be returned on error.  A short read may occur
> - * if the pipe has insufficient space, we reach the end of the data or we hit a
> - * hole.
> + * other negative error code will be returned on error; -ETOOMANYREFS will be
> + * returned if the folio's refcount is too high and the caller can fall back to
> + * copying.  A short read may occur if the pipe has insufficient space, we reach
> + * the end of the data or we hit a hole.
>   */
>  ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
>  			    struct pipe_inode_info *pipe,
> @@ -3168,6 +3169,10 @@ ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
>  			if (writably_mapped)
>  				flush_dcache_folio(folio);
>  
> +			if (unlikely(folio_ref_count_over_limit(folio))) {
> +				error = -ETOOMANYREFS;
> +				goto out;
> +			}
>  			n = min_t(loff_t, len, isize - *ppos);
>  			n = splice_folio_into_pipe(pipe, folio, *ppos, n);
>  			if (!n)
> diff --git a/mm/shmem.c b/mm/shmem.c
> index be4ab228cf67c..0b30b1de81a7c 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3830,6 +3830,10 @@ static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
>  			 * Ok, we have the page, and it's up-to-date, so we can
>  			 * now splice it into the pipe.
>  			 */
> +			if (unlikely(folio_ref_count_over_limit(folio))) {
> +				error = -ETOOMANYREFS;
> +				break;
> +			}
>  			n = splice_folio_into_pipe(pipe, folio, *ppos, part);
>  			folio_put(folio);
>  			folio = NULL;

this LGTM :)

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

