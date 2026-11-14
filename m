Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAC50606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XubAwCv6
Received: by kanga.kvack.org (Postfix)
	id B034A6B05B3; Sat, 14 Nov 2026 12:31:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB51D6B05B4; Sat, 14 Nov 2026 12:31:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CAA76B05B5; Sat, 14 Nov 2026 12:31:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 792076B05B3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:31:37 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0197F120277
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:31:36 +0000 (UTC)
X-FDA: 85434416634.19.8BA2B6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5A2931C0007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:31:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XubAwCv6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794677495;
	b=PBT2I2VpS6xg388r1FnG6l7XJYInsL9D4M0hOPFGWr2hoCH5OGYTbNaMZigkUfxUvgxyFP
	mmNKYq67Jl29cxbB5IucCDfBdTbmTDV8DMLXqob0TQNerxfP93rC3tW12GrtWLUijzAiC3
	8ityHVXEG8f5VBCXUaGhiGYAsJIkbWg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794677495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xu6Ta+VGcVrBTjJvTLtQRPi6ZkVQp0lKmr8llfO95ro=;
	b=o3W3Lo7AMQ2il9GnaYg6yxnrVHeGh8V4fxewB3HIwcnMetNXIfgPGqqCbFpcs7FRSsMbqD
	+UVRuMG29I77YH0Ua3uDDMggyA4cgcHI6dat2swNaG5OD01f+lbipELqwMkP5BIKdRAmMm
	yg4GiGfsYueOHOb2kO+hF0T7YbHnuSo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XubAwCv6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89B7E40E10;
	Sat, 14 Nov 2026 17:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973541F000C4;
	Sat, 14 Nov 2026 17:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794677494;
	bh=xu6Ta+VGcVrBTjJvTLtQRPi6ZkVQp0lKmr8llfO95ro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XubAwCv6+ETbPYyk95JCbkpKK5A+JFqtao9ua+CADY8vxNic4QukZaRvgMbdbueZu
	 dEGJTBnNmnjXvWBuiPPxvJZXK1r8ot6BynZQ9rO+SyX/AqRObbBLAdsEnojlAUFntr
	 eQmCxpQVq8bKZd5U4lRQqIPvhS42ofy3tE3U4slpb49itS3F7tCAyTqKVMTPx0/3ab
	 amZ40UQLximBy+DKck5n90zX4/5rVfbMCYf2K3XyUsGcbOX3L5Z1kc80rD9YoAKJlH
	 nJD3FdjWxo2PJvuWcRJjJlxz60fgVH9bbJPUn9+jN23fDkFwzcQ1N2CB7DlEH8ENUk
	 wfJQFPEc+672w==
Date: Sat, 14 Nov 2026 17:31:29 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: shao.mingyin@zte.com.cn
Cc: surenb@google.com, akpm@linux-foundation.org, linux-mm@kvack.org, 
	hao.ge@linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: snapshot alloc tags in alloc_tag_top_users() to
 avoid UAF
Message-ID: <aviaKvQu1QqlMvNB@gremlin>
References: <20261115004711126EXlXUnHk7NZz7rkWhDkyP@zte.com.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115004711126EXlXUnHk7NZz7rkWhDkyP@zte.com.cn>
X-Rspamd-Queue-Id: 5A2931C0007
X-Rspamd-Server: rspam12
X-Stat-Signature: 9wy758drns4zfu5s3fzq6uuhnyddwzdu
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794677495-581456
X-HE-Meta: U2FsdGVkX1/SGlTRW6LSXtSgCT0btZU7E1tDcWJAtnufoCA2NV0K51KEEsPENgLqJwiL4FHc9afTbSda1a9h6mf1OM6CtL+LaGDtauKDQYSLy5NSQfxDRLcp01/BjfPNv0AE2UWcRLo72XSnZ9PH1D7mzLUOZjMlmru+oZ6jm2jc7msdykx3aIb1axx3awdbW/7fqjE60z3jfqSiznpJRHcz0ATreDRwokXMAzpCphPZgyYJT7+1QuDfMjDTetITJRlrCC3Ry7d13bIl4LYm8LEbbM5Q6xkaArczkWgp+7uK0p8rJbs9XftqIOPYZwLoeFJ9qzL4RhvTfTfetPmLlSJ1bjlcgSmK627+akaq79y3vVaT+ZzqgdfA+i8oEqVxOQAZtPBLCY+fsLFz414Dzlb2PwAzwvXskbpLrkyaG0jLhDcVTkxbRm4tdCyvS9me7dG+IS+l4+5cwc/OWyzyrhRlQWRPECEeXgwnAgiUCHfqZN81WJfFsnPfFCG3m9jc41jse+PzLf0UWWxrfPTFXPqmbB3iSTyxgqmuIlVdxE7wIbYSDjUzkI6PECKryT7vsQ00HM9cVJP0lCiH4IzHRBYLrsOcxGJgGGRrgn5Wlprj9zFG8IzRmXtFexRuAYnEv3yi+shDiatJBnwpNuW3jIFxhuZkZF/L1Hm01kpIga6YyiM7SG6Hgfp8c3kjRsxiAAtjTW68TiSCpfijqH0XJ9raIh4QdSsv8beEk9+tWBSZXzDuhi0v204xMPOdmizmEVqxxDTBEUSTBTf0kWj05Xgp/J4pE9Eh8GisDShSFiWz8Bcf8Q9bnlLpWvZeBEgef5jMuoYnUz/ZwVKiQdCtlWjhXD2el3K3Rm1/vASLEjKj3QO0Jq5uZmGfZWApnhy8HZcjmNxb3jlGbwYC+ACrJmmsF5jyiqmsNSodpHumVkT8SWuo3AphnmxhVpr/yQRoy6IHarUq+JAMuh6QC9Y
 H7EOspWH
 jg+XDFKm6972r5ACMGyGzBVJGmorlkEy4DUdjxahHMLVqfFbMTJ1gr1I41v3kJTtXTBavuGAejBaZwKEdb9sW5A/IFKN2bOx7wv5pRf41tHvRPmkKcUwwWSzQhbHr0VL2D43vc6Y6J+ja5vTRZTiUyiAHoLerJLUj8o0cdPwTKgPDBibH31eSdySGHYu5wvQnx8wQmWoV6a1xAwU0fwnQeIL4SXtnJ1ekeDX7Qa7HGLdUnaituhv9IIzvnSiEI9OUxKSaiItNBo93c+7b1/TzqHTvTvIdF6NVEhDTKGQCw9XOBQE6kkfk9HZhpBdMBX8qRPPkx/VfstvZ+aLYrJ0Jjng4MnNbZxwqjrxcn5kW9CRmC66G8qdXXZ40VVAzRocaWVzrlHuDekJEEYM/ZOERwFz1UHAC1UPaDsie/5GGr9InYUk2RHGfLdnjQMCTJeFkU6T2OVsBmfc0GfRVMf9db8+EEmVk6QUj3VY+jFUqvVBRdFHI+LB+kQWb4IViLp+Saox9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 12:47:11AM +0800, shao.mingyin@zte.com.cn wrote:
> From: Shao Mingyin <shao.mingyin@zte.com.cn>
>
> mm: snapshot alloc tags in alloc_tag_top_users() to avoid UAF
>
> alloc_tag_top_users() selects tags under the codetag module-list lock,
> then returns raw codetag pointers. __show_mem() dereferences the tags,
> their strings and per-CPU counters after that lock has been released.
> Concurrent module unloading can invalidate those objects before they
> are printed in the OOM or SysRq-m report.
>
> Copy the selected tags and counters while holding the module-list lock,
> and print only the copies. Reuse allocinfo_to_params(), which copies
> names into fixed-size buffers and retains at most their last 63
> characters. Preserve the signed comparison used to select the top tags.
>
> Keep the larger output array static under the existing show_mem lock
> to avoid increasing the stack frame. The counters remain approximate
> lockless per-CPU observations; the copy protects object lifetime.
>
> Fixes: 1438d349d16b ("lib: add memory allocations report in show_mem()")
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>

NAK.

this is generated by some AI slopper's script, spamming the kernel. The
patches I looked at were wrong/broken, so no to anything from this person.

They've sent 300 mails in under four weeks spanniing: ata, scsi, target,
ufs, nvme/nvmet, ubifs, ublk, zloop, dm, md, mmc, virtio-blk, mfd, gpio,
pwm, spi, PCI, ASoC, ACPI, net, vfs mount, block partitions, and now mm.

and 17 series across 7 subsystems over the past 23 hours.

We need a way to ban emails from people like this...

--
Cheers, Lorenzo

