Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB1FCA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 10:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B18386B008C; Mon,  5 Oct 2026 06:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEEAE6B0093; Mon,  5 Oct 2026 06:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B6ED6B0095; Mon,  5 Oct 2026 06:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C06A6B008C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:43:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 008B0A4E05
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:43:57 +0000 (UTC)
X-FDA: 85288237356.26.A32ABC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 25ECF80008
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:43:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YxyjbhaK;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791197036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9YxIdWVKeJd4/bB5ayzuob5ZI8t2MLqGLq4CqLRU6E=;
	b=qXOzgon8Oeb0ldwTubMbjrmTC/Sjy+MsHgjUKvhAC/k3ERxq1vlgKebxkgaKno3dGf/ACJ
	dkDF2BOB9cYIJFYHgmH65SnzhU4tcFq4ksGqlI9S9XA8+WzpQLA8ztkyuMG6xMfJGtIMdH
	gKTYeUrdDINaS+03knnfrjYUYLMxW1M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YxyjbhaK;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791197036;
	b=h9iH7wzemHE7POjMbsTdrCS52Oz2r0Acc5IIkAViyRuPfeOfWxaLFi84kEzXEAZG0s2ThG
	dS04Zll8Lfdas8R2dGJsuz43xPDm5SxkbHrC4JBNeky4ZR+0ahPY5Mh9AXWHrJ+rlKM8Wd
	9eYGR9goskytg8wBmbu2VPTMmRNpBrM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CECB4382D;
	Mon,  5 Oct 2026 10:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6530F1F00899;
	Mon,  5 Oct 2026 10:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791197035;
	bh=I9YxIdWVKeJd4/bB5ayzuob5ZI8t2MLqGLq4CqLRU6E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YxyjbhaKV4J3KWq5yAbCj043IUW/HILXjLF0F3kkPCQ2WaUvIjK1eq76i4d4auCLp
	 /KY97mHjSMrICJPPlZd+0gIWHlBgtkFYBX2OoKJwf9/LP0Qe5Ph+XThvZ5E+h0iSqK
	 Cscwr0iirEuj04JnGdZsrnY0ROtyRGzUeLrCqG80YHmMsLm+pk0DTUxr5O1tWwS2SP
	 VQA5MkeLjX5LRrWHE3lasxUoRzxmdTB9IROC3KXUwv1kzS5QYGNe/i2V5H21pV2fpc
	 vVOsRAom5vq9ZevdHDyTHCPbeSp2a/sxNECVbqAGEBjIsUE+TLzx0TD+K2xZsxwGRz
	 A2l/wGOuFT4cg==
Message-ID: <4a24f7b1-65f7-4947-a325-7c9e9f642f2a@kernel.org>
Date: Mon, 5 Oct 2026 12:43:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] selftests/mm: add tests for UFFDIO_MOVE of a
 uffd-protected swap entry
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>, akpm@linux-foundation.org,
 rppt@kernel.org
Cc: peterx@redhat.com, surenb@google.com, aarcange@redhat.com,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, mhocko@suse.com,
 shuah@kernel.org, kas@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261003103030.63380-1-donggeunyoo.kernel@gmail.com>
 <20261003103030.63380-3-donggeunyoo.kernel@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261003103030.63380-3-donggeunyoo.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 25ECF80008
X-Rspam-User: 
X-Stat-Signature: 31y19kzbp9ih3nedxhdaepo3d9jqxjc5
X-HE-Tag: 1791197035-568109
X-HE-Meta: U2FsdGVkX1/sErFRZancR10qOB0+vuk9BpNIAQ98FGug37xjdzDT5KPEr5Oy/ZBl9tgcSIdWcQy8C8joxZuI2A+gA2/sNTaiE4l6VMaZk6zanM/VUFx1p5amUk4KfVJZtZzQrfpyN1cXOnmkzo43Q+382mC9iqvGIWdpfpy5kYR8N4Q9BnvLz7b0pkmKOORznx2siXKdQY+vaGDGGlSeUfLceeNDyKO+gv9RcLuPikpwISbA1WW5ZpPy9xP9vAPbEfnC/jUsWWHwurBQZ72tx2G+B42WiWzMMyDmpVo/TjiW0WWyYEzMxOP4DI1UXlqnwqKiizZK5+mm6kYzwvA0js/yuyqziei8NWVPkrEIm6yudHIUrXxR5djwQpaYpf/W3N/udrMMpm8dt59hmKax0ctjkAUBqga2WRa8qP2vnO0hDu7aE5/s7OFR0hkUHkK2td2gssKeHc7t/675ZEehXzrztJwTvrf1iW/jFPBc3Tosq3RlgAgiFojkwtZ73Zsi006WUbVax1YLGxV26FsFh55I+GlYFcZrDxLL8O54CK2VKojf6OW7Oulo5PJQCFTRXZ0bMugQHUM36eLLQqbfuiCfcj1MnB2WcZk/Cl005eJQaoYJKZAqLrDl/NC0xsIPUu+6/KbPW3cBmUJo5DOwNcD5rV1wB6SzVdhTFcwc66UY+ubCIQ/oNM9asHS8ozyGQeMo1tAyhhcz06HXMjpaMQdfiPIou36Dc+G5J3txNtK+QG6QGYXVOR2nlG4mFRPA3cf515MCzcS0iY6SFDui1sAm3ts0sYxm0OtK2rj1lwjvEZq7Z+DzQI19FkEePVwqwJ17IqyxGlXL5AptsWnEOQVNMfyTVZ+mf0R6mcx99t5Ivpwp+weCssO4MQVN8Aa/n07kKNPCFiQ+bH/uSuAmlrMkzEfDsUguC11phwjWIS9PE21sK042GT53+AXm+vxMxJrwUyNQEbjEEuuvs1C
 gXcIhRS6
 WCZw/N8I/FiP6EDxja+18uOzhl4GwRA6lCGD81LmYjrX6YtZefl/fXBsT8xyhNR7zXeaxVk3/n5NYbWjtlXXls90Yq0xqwizu6ciPxBzjOv86qSSFCNpyfqxThp5BvzyxeTXv9z4Y9aRCad47NhbZsc+AjKDY+R/h2SFvZgSSbHQnkV6gLQXMCM90QTsiCBqCoIrLrL9Qu3SW4pRXuHBb/uXg4Vx1oF0DjF37plhOw0UeLg6TjrIwJPv7LMqZHSjnQAyrk+wU+pjTqjwF10/+z1IUj+krSxa0KsqSbnTPwEd4kZ8MZ2RZN4lh/Wu29WGNUfNMYbsCmN0HdWbHm9BE5dcO0s+mi+WqHzAM03eqcpy1E0P04qa7t8WI6Wy+xF4ulGHIKWBZ3ZOVNJdqQKZNJEpeNb6h+Jsmzv58AhHSSN6yQSw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/3/26 12:30, Donggeun Yoo wrote:
> Move a swapped-out page out of a write-protected or RWP-protected area into
> a destination registered for missing faults only, and read pagemap bit 57
> at the destination.  The destination was never protected, so the bit must
> be clear.
> 
> Assisted-by: LLM
> Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
> ---
>  tools/testing/selftests/mm/uffd-unit-tests.c | 84 ++++++++++++++++++++

The CI complains as reply to this patch:
...
Running userfaultfd(2) test
✗ userfaultfd(2) tests failed
Running VMA merge test
# # Totals: pass:27 fail:0 xfail:0 xpass:0 skip:0 error:0
# SUMMARY: PASS=1 SKIP=0 FAIL=0
✓ VMA merge tests passed
Running vmalloc test
# SUMMARY: PASS=1 SKIP=0 FAIL=0
✓ vmalloc tests passed
==========================================
✗ userfaultfd(2) test failed:
# not ok 43 minor-collapse on shmem
------------------------------------------

Didn't look into the details / trying to reproduce.

-- 
Cheers,

David

