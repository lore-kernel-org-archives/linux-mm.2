Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577BA606A33C
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B4kVC4DG
Received: by kanga.kvack.org (Postfix)
	id 935246B05B7; Mon, 26 Oct 2026 05:41:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BEE56B05B8; Mon, 26 Oct 2026 05:41:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786486B05B9; Mon, 26 Oct 2026 05:41:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF536B05B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:41:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B353D1A06BD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:11 +0000 (UTC)
X-FDA: 85364283942.19.0E78756
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E481640003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B4kVC4DG;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+02ILXuK9KfO91BQX+g4W7G7YIbtI1+HIEbgN+bzPNs=;
	b=f4JFeOJf6jrFAzaTXx8V0eofwYmF/Oh3XqbgxMTs2Gkuxw7O78Y0o0asJGxBWrYdGSbg+D
	HemwFD+zJ1qaT1pPcLvEEA+hoXN7DSXHdAiLDkSReyB3JN0SbKwqx8Z7FdOA89MHdElbIg
	+LQ22eKGz9BydEQzl3/Ane6lI9VYoYc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007670;
	b=UDF6fgxEV8E5KkAV/Pv7AqKAmzRTdl8SDY5DCV6BIiFfiNegtoXjuh7dklPbE76HwwYQji
	kzWRedMLuK/SbwaAOYkgL06UTjyDeexwmbvnVC8RulSEeBetvxQjpuM7xOfVYGh8J597bb
	uHJqV5t3Hr63sIc7FwKvyk7H4hhe98Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B4kVC4DG;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4741F43F0F;
	Mon, 26 Oct 2026 09:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55651F01825;
	Mon, 26 Oct 2026 09:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007669;
	bh=+02ILXuK9KfO91BQX+g4W7G7YIbtI1+HIEbgN+bzPNs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=B4kVC4DGdBI0nHvQd38JB3xiE9r0i4N3qGwuJUEdjHaOsRrrDZWTPYEJgHeU9YP9E
	 x5UEkksaPWu3fLn9gKPRdq9+DlZLl0tmGoNyWUTZOpghl1JA3iJtkPbRWENoHMLND0
	 8xydXSGcQL+2c4pEPRs5A5JdLRoUtySK0dNJxK8+ahLXPcv+8QCPc5omQkBWFUtcxY
	 vA7PKr/GgjLz8qst218EKOSDbH04nxpTs0Dx06ndguB6lpIkRNDlWswaSwXP9c+WET
	 C/MpOG0Myr+GqyGXVQ3kAUP5tjXu3f0N0sDBYOpKbf1s3bAHMKbcHbpeeWxIZKOy/I
	 oC0Y/U9Fj1mgA==
Message-ID: <d39e7c09-7098-4563-b5fc-dc90982facee@kernel.org>
Date: Sun, 25 Oct 2026 13:36:12 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/ksm: keep soft-dirty when merging a page
To: Andrew Morton <akpm@linux-foundation.org>,
 Samarth Narang <samarth.colleges@gmail.com>
Cc: Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Peter Xu <peterx@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261021182157.1873726-1-samarth.colleges@gmail.com>
 <20261023223352.c6de9f2b58fe999814e5bb17@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261023223352.c6de9f2b58fe999814e5bb17@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E481640003
X-Stat-Signature: kbqmncgjsq37up7eqykw6w9xbrg6oa3x
X-Rspam-User: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793007669-53337
X-HE-Meta: U2FsdGVkX18P17IbDaWSR/8/xa77susw0avET74FLNJpk9JpC22BLhbGXi4RCydl8T6Yc7QA2NQ1L3mciSVaDydttuA8Iv88CL/B4CDwaI1uhO0WEgihsIeRPuM+FvS6nnjiIHWD0T+RlbTEYj5xmS+Z5zRPZtWWpuFKJKaqjtSttwN+orNtYoGDFWkIydArhJycpxA0Zh2pvc/JBCtp82/UFpLSgn34zYWi2PFU7MAOiQs+bE2EK04Fv2Deg04aCwLOKR8RdJ8Fg7r2dHHe1wQOtLRp/18SRI+aD4+CxE3khjBhIDB/ov6sSN+Rj9m7hfCgBspFcRzPdpo/00qU21XBO1frA8VvLhqK7rWEEqWhqfJYChCtU8fiBJCPe97dyt4c/vNo1gFH0B/jKR6IG+aKvaNVyLgwqScrfpx+tw1mB02TOOymmF4Jx0HlKLmJtCu9l2AStJ4zyR7ghmyVaCfxfUULVBMp+AehPD/Uu+jM0JzIRFltBDyNRwh89Bl2/wK9s7o4AYLm8bDUm30TxAFCDmb2fYWyXz7B+xC9FuO5eD30HtpUze6979PUnmOhLbnyy3GpzyZ89KxVw1p23ZtxUqCujrnSLl4sLo7NEWHUuc9xr9NXXP2ul+w4glQaBnXo+VSoXXFXciWKQAMXd8OX5stNUJqQ303dg5MSWXAHiHctS5/flwJ5p0XKe2lsJrP8vg3+x3X0bo1sO/a+bhiGjqdpm5kTkW0L2LIS71KyrBq3atG6J8JlJx2QEh7wzSoEcD9jHqT19JjUEjg2JDlVOHyVNNIgLhTyCOkudlOHXyX71kxKb3sS2crTE2bqZRIRua2OK3cQCn/4Obi+rKLwDI4acE8hhvZMbbMXcrZ13O4vK6ltsjL+qmQYxW90C5OyJEikFebI5TNVlchGp5XbMREcWD4oBNsG2O6Z2FPZ5yLyKAg9uNmy9Zga38jcozcvn/t81PcAdQ882b6
 CjS350Om
 WHqdkSEbthCCiMITb5NxEkzx9cf8zm9ikpxC4QNjIm2aLf9u7GfSBJ80H9eJHr1+ZxhOJhwr4oBOhQ3zrdHm6z12BN9i94pHCrGyaY7euUFnDiJ6QFZ1Qc+ecw6Uw5w52Km3OM/4f3ZBbEdTmTrr1Ime05F6lG2wZhsvzNviAhcORJqDswSjVJ/1TVnQ5gpjevayv7xWrxYsOZe2M016CMJ6cr/lx2g0QqHATZXi6UBIz3mPKboQNHeBt2oWsM0xbBCLzuvWYfVpL7CnWBajbN44sL9Z/2Rk5a9I8MUkd7qV0iRMoKV3g2wmNqGQ0KFvapSY7r5iR/AcOLywZRQa0yCaXj1DDIWiklOzw2QWOoBmEjfw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/24/26 07:33, Andrew Morton wrote:
> On Wed, 21 Oct 2026 11:21:57 -0700 Samarth Narang <samarth.colleges@gmail.com> wrote:
> 
>> replace_page() maps the KSM page with a PTE built from scratch, so the
>> soft-dirty bit of the PTE it replaces is lost. A page written since
>> "clear_refs 4" then no longer shows as soft-dirty once it is merged, and
>> a soft-dirty based dumper treats it as unchanged.
>>
>> Copy the soft-dirty bit from the original PTE to the new PTE.
> 
> Thanks.  My LLM review thing says:
> 
> : There's a separate, pre-existing problem with the KSM zero-page
> : path which is worth pointing out.

Cool, more AI schlop.

TL;dr Sashiko raised this before and I commented why we don't care IIRC.

-- 
Cheers,

David

