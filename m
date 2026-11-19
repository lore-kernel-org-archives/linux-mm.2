Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA63E60A2607
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 17:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O8Uodhrb
Received: by kanga.kvack.org (Postfix)
	id D56E66B0696; Thu, 19 Nov 2026 12:06:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2E5C6B06C9; Thu, 19 Nov 2026 12:06:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1CCC6B06CA; Thu, 19 Nov 2026 12:06:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9828D6B0696
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:06:12 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 320CC120BAA
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:06:11 +0000 (UTC)
X-FDA: 85452496542.03.13610A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 323631A000C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:06:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O8Uodhrb;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795107969;
	b=jc5WHVt3o3+mSoipStjSbC8gDn1+GEmCddUVmqy3v+sp7SZ/YtoPRYMce2SOKGZnWAoe7b
	TaRtPRU/8KhpLHEAd9GdqTY1nnt5apnECECYixb3tgjjxbuniH1sCKre8Mwb+UxBpjvqfa
	4Po5ZxTzPehSe05R5yAhC7M2AdCzGck=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795107969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M118Bq4qG+fvAk7cRNW6vz/xHAeyvgF0gxIP/5adlFc=;
	b=Btv/IKq8SEgMky+jAC/D8ORk8s46BBAfra/zgueGF05VmjlBuJ+Bo7j8k2XgJkFIV+1f0Q
	z4lPO6/4nFFz+THA5DIygbph7D+5QyVSNlDyCLHSzi4uf/rCwt8uGYqGGn/3IAS4kumOol
	7GQQZ/sAkgiLTnK2s5wm5qOIHQY2kt0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O8Uodhrb;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C2C140264;
	Thu, 19 Nov 2026 17:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACDB1F000C8;
	Thu, 19 Nov 2026 17:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795107968;
	bh=M118Bq4qG+fvAk7cRNW6vz/xHAeyvgF0gxIP/5adlFc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O8UodhrbFFlwGqaHVvd5Mvauk7njRUBxMaON7Wa0SpioC6+vdgy9M8tQ09zxHhrxF
	 lGofD0WoVkRPFhrZ+70sM/v0SFGRsPjPQsjkDh2pJZyG6N+GcZIrnWb8JBLaXEgMRx
	 k8AMraCYCQvtFzG0EWI+y2JIeTphuc7Kt4Jcv4GtahwBvy90TzDyCqkBBRok3vypkh
	 rYYkrEOrK4iYz2mTvRVLRkoOqPst6PUO+v3qo4HW7PoMiBec5/RWn7lr7VqWw3omiG
	 7MkFV9Pcao3uFEiV+ggPB+wskYUMo1FcsozEWmnIi8WkphujmlbodFngsf1Eo++QvQ
	 c+tL523KvvSMQ==
Message-ID: <e4c0fcf1-b70e-4d22-9c4a-5829e1438ce5@kernel.org>
Date: Thu, 19 Nov 2026 18:06:03 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/shmem: avoid zeroing new folios twice with
 init_on_alloc=1
To: samridh@modal.com, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261118-samridh-shmem-send-v2-1-f2ea01bfc178@modal.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261118-samridh-shmem-send-v2-1-f2ea01bfc178@modal.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 323631A000C
X-Stat-Signature: pfacq85f9a64gxr4fi8yck8kkqim67oj
X-Rspam-User:
X-HE-Tag: 1795107969-553392
X-HE-Meta: U2FsdGVkX1948w2NH6sliDxZiVHZX0L/FRb3D39DRbTT1PST48ktxngDGPyzbHhJ45hlvJk3246ydzHcBZI5zuJVqq0X9MeXa2tVbw3O0AJ95p/IwCiedL9Gj2hV/VqaMAqBOUFid+9Jp0AqiglnoT633YXIlf8/tFHPnJPQAP0TosO0IdqUiCs5P2pqkqv0Y4nnVVJYcb3L1WtaEkAGXfhGGrACam8WUqyd65b7qSdLARDBsoqgTzOuD8Fo4+4XE2JRyYafH9wYu1dhIwoSZjwVnatzrTSjz49hJOfLq2OBAnhYhrbINYmzF+fitThY61jZzuikg6FgRJ+Ouaj3sxpuEMBL96/dI4sI9+kAPO8D7K9OZ824gSyUwRPOsCPt+f6LfGsUj1E88mFwHwG7Sprfp2K20q3n85igEj7SJ7TO5Ut0he86VyL/U8HuRwIZzCpV30ff1AzwW7d+IUp+53aWvCBMpFzyMFOh0/AfG0hTy6FaHxwmChCawHR4l+Jgu147VJC9AWOhm/CsCOXrMhfywnpSVBeN65DQ9KEaI3P//ZkBCHmO13g3H2xzrUkq/2UlMeI5HD47C+MmBlYI4eutk3yUs2f+BvJS2FYHys0nMfLsBj22MB2sr1AyzybVbw+v3dYD+IT3Cc3EbaXZ1l7LQ2lm12+KJFJx0yvfVV7JYq4TOTKXd2BiE6JUE3RzZnrnhThxZrshvGXwCqg7Sjfz9y/LtVJ7EnWnT7NAvcGF1RJbD3o3czIlra7/eDgxaLXxIRxbfA1jwX6DorJDK+2124hfqqeobOU42GDCSD/Dl1Rm3q1JnsT32uwIwkk1qBVq7bj8dJk2xzKwwyxfhtMR3W59FkR49nNe77+R8xeO2McpbRcwErOaZJZNGlHTNmtnitDNRz/nowxE6Y2mhAT8ontlGHtK0dbJLFfJX9Pcb+fiZ4N5KKIlnMC8/kPK5ny2Dm37bfxjjEtqxPh
 5L4piLbT
 PvLVJmOFzXysSAdpc3tqXeWfZShrNcdB1E96s4kQaRVfb0QSyBL7dKXDpZO4dd4+mC2tFpboXjdfwWG793UhmCYCb++hTroc5PEYqnlXnxZfBj3o5NKGI0i7JuST+uFDBN2ghORfdxs+cj3jw12uPWvSYFCvTGJc8Ham5kEq+DgF/jV8TNqkP3emoKDW+iZGZsAB+3LBus8ujrmUcvGtHClb6pbNfnDprwYsT+lldEvZKq9KPdDuqrAdLFlWd1vWYb275gpQPPy4lejnVEgFssy0TRFwFL1GxDgVEk642ngx4xszQnbZJPHiF6rP+jrm5YjrBKGA56QtPO+NBJRzSeNzYeXkPzHlEaqP1cn/VsNE3POF4VGWGEC9Ta6EN2nYF70wt8B0dS6zcRznFH7yhy9LhEbFpZeI0YaconI7UaOUCNCKauWb4fgw6tGcW+WB7iAhfMwslUQhvQa0pTIawa/d9Tfza8SOxEf2IU9FMAYvwqi2Pkr3vxH4USS9FexAprjSa71ehJMUgyGie375PbaljOQ8DuJu3CkYCB5aQ5xU64/hq50nLymk0MKfOyrhFKbfzNIze6ZbD/itEcswxERsV6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 21:28, Samridh via B4 Relay wrote:
> From: Samridh <samridh@modal.com>
> 
> shmem_get_folio_gfp() clears a new folio before marking it uptodate.
> With init_on_alloc=1 the page allocator has already zeroed it, so the
> folio ends up being zeroed twice.
> 
> Skip the clear for a folio that was just allocated when
> user_alloc_needs_zeroing() says it is not needed, like anonymous memory
> does. Folios that are already in the page cache but not uptodate, such
> as those left by fallocate(), are still cleared, and so is every folio
> on CPUs with cache aliasing.
> 
> Time to write one byte to each page of a new 4 GiB memfd mapping, with
> shmem_enabled=always and init_on_alloc=1 (median of 24 runs on 6.18.55,
> x86_64 VMs):
> 
>                   before   after
>   Xeon 6975P-C    0.625s   0.420s
>   EPYC 9R14       0.216s   0.160s
> 
> With 4K folios the times change by 3% or less, and init_on_alloc=0 is
> not affected. We found this while running gVisor, which keeps sandbox
> memory in a memfd.
> 
> I wrote this patch with help from an AI coding assistant (Claude Code),
> then reviewed and tested it.
> 
> Signed-off-by: Samridh <samridh@modal.com>
> ---
> Tested on 6.18.55 with this change backported, on Intel and AMD x86_64
> VMs, and build-tested on mm/core for-next. A simple test fills memory
> with data, frees it, and then checks that new memfd pages read as zero,
> with MADV_HUGEPAGE and MADV_NOHUGEPAGE on the fault and fallocate paths.
> It passes on both machines with init_on_alloc=1.
> ---
> Changes in v2:
> - Use user_alloc_needs_zeroing() instead of __GFP_ZERO (Baolin).
> - Link to v1: https://patch.msgid.link/20261117-samridh-shmem-send-v1-1-1b897ff562d9@modal.com
> ---
>  mm/shmem.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index c769d0bc7df9..1a78d15a768e 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2810,8 +2810,11 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>  	if (sgp != SGP_WRITE && !folio_test_uptodate(folio)) {
>  		long i, n = folio_nr_pages(folio);
>  
> -		for (i = 0; i < n; i++)
> -			clear_highpage(folio_page(folio, i));
> +		/* init_on_alloc already zeroed a new folio. */
> +		if (!alloced || user_alloc_needs_zeroing()) {
> +			for (i = 0; i < n; i++)
> +				clear_highpage(folio_page(folio, i));
> +		}
>  		flush_dcache_folio(folio);

I do wonder whether that could go into the loop, because I faintly remember that
user_alloc_needs_zeroing() is disabled when CPUs have dcache aliasing.

In general LGTM, but I'll wait for more feedback from shmem maintainers.

-- 
Cheers,

David

