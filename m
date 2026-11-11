Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF3EF606A33A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XUpiXuE8
Received: by kanga.kvack.org (Postfix)
	id C29416B00EF; Wed, 11 Nov 2026 02:30:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C08566B05B0; Wed, 11 Nov 2026 02:30:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16AA6B05B1; Wed, 11 Nov 2026 02:30:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 79C7E6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:30:02 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E35C412019C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:30:01 +0000 (UTC)
X-FDA: 85422014202.30.5E34D8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 254BC20004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:30:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XUpiXuE8;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794382200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AboEUDy+0XQ7R2YYo0S+EhzsgQLMIlJ5QVM52GjU8mw=;
	b=Q7PL83xQcTSRb+UmfsIf99GOjBvl5a2PmtZmTSKGp+2JU1SdiA1EkQAN3L0g4a9D49xTT2
	6mCMv0vGZSrTqN/LaxyvCPW5FZw+h5+g4lb2V8uTViaHHUklPi2/zs/ikM/RJS71fup6xV
	fFeTL1ncLet+MQX59V027YHCKMUNvDE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794382200;
	b=aFMPnWm/s9YvDkP+8myQo2mk00Y3pvXMZ7gJxP2q4QvW57eNuo6T0ISQZjJTA9ZP6yn3Tg
	MMS3GSVM/gaU2rrQp6AcO/9d8lu9crbjrEyG07ntgE3/iVWqYkAAclRIGhtvhmVUna5EmR
	WumMHyASXgKFVPYsrl99HQuCglksypc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XUpiXuE8;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B86B44000;
	Wed, 11 Nov 2026 07:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2F01F00A05;
	Wed, 11 Nov 2026 07:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794382199;
	bh=AboEUDy+0XQ7R2YYo0S+EhzsgQLMIlJ5QVM52GjU8mw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XUpiXuE8rXjiH2ua6oHyBD487MrqG8UJeaDGf40ZXo/8ioaryGV/lvoSsT3CE9jdg
	 d5Re3OgWK+IQwmV4HuF2KHYqjINbC9OFaZM0JLlbhYUw5JBaAXHEoUrKQDl6hEyxL5
	 S96+rq0QgC+Mr7Bv46sea7cDoxBo+QWn+U4qIhp4d9GZZoszGJwV7ArxXKanNchnDb
	 pCj2Em/2pNRuWnS4qJ7WXOLl6i9BGKsXi3TnPUtDUpEl6XnPEZqmT1dhojVuAi1CH1
	 OYClegvaB7BTlPC6PuybmOtxsLfoxKC2J7PnCn1MBtsK3rvwIwIVFztWKdhcJ4M7s8
	 Opavd4+j83fLA==
Message-ID: <856cdf21-7982-475a-b244-a7ceff4eb6aa@kernel.org>
Date: Wed, 11 Nov 2026 08:29:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [SECURITY] mm: khugepaged collapse_file() drops RWP PTE markers
To: Tal Zussman <tz2294@columbia.edu>, n3rd <18670333770@163.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "ljs@kernel.org" <ljs@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
 "ziy@nvidia.com" <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>,
 "peterx@redhat.com" <peterx@redhat.com>,
 "security@kernel.org" <security@kernel.org>,
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
References: <606cae9e.bbec5.1a1c54f4f9f.Coremail.18670333770@163.com>
 <60541e98-b1f0-4f92-a155-8a29c0bb17dc@kernel.org>
 <44abb8ef-7711-4ad0-be9f-ca47206892a3@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <44abb8ef-7711-4ad0-be9f-ca47206892a3@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 254BC20004
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 9n3m1cju53yffuzbir3fttfkjctzaeuq
X-Rspam-User: 
X-HE-Tag: 1794382200-435724
X-HE-Meta: U2FsdGVkX1/0VN5r1FUDp/vI1IKgVssRKQRsi/fsuSl2IQBcbEfZfGDU3LY0iwCxqnjMByflheZPCiAVP++8DKFYJSSaI+ZwmJg3SJQgZe5MWHt8HyY8cQCO9cUV8hwxS9qNwyPXsy16qN7zL905m8GYRl/qzWLDZBA48XiquLuZ480rBfUf9stMUg9xv3BaNWyc5zNF2MZMiv5g3VKpVR7XpBMWtyisW6z22DEMpXBtxZB29IpZmwqDWc4zQZVk5lMnB9jQC/u8pbahb5noma3YBvaPOh4eXOBdRWuLYyeo9utpZ69vL2jcYQexiKaMuFysGSvskt3mTB6fR/PAB86yh4YsaGGN5qlRwDGIJWdAj3+tpwnxgWOeYlOAIVrHitqXBDT7HQEtXlPn93QJv87jrGQr5O/7ea5cmx5/ymbtf4+wd1tOQyZ5kOd0l2b4p7gWPznfvZVD4en/v8OaMp7KkQPVtvihGg+t4uPTZ4UIDZueqy9fZqSM/QGoUH+40VItseT7AJPeY6YcM9MQ9H4Uig35I/MBbSdUorMNumxEaZsnHDswdDUs/76SiMzrJcabfmg6jxzDzmZ8MRRD+mfGfdI+35bQU9dFfs2cWK+slmD2biIT2zTAiVmvaXbVE/HR4o4QSHebKqFhU/4uUHuVXWRf+391AzWZSVku0MwsEuvpKUbhUhlNdGdpZN+UQMlC6vu/9KclBscx2lvxXmu/j/KVVc1rlGFY9b+Jw2qhmR+cYvElx/4EcHd2QeEL7LBSvE0L8Xz5pHiLjwJYg7fqYDf/wXQcN5Af8FUE9ncCiA0nTuN/7IPwGh68WMrcqWkMeugW2evJrw0Lm7jlC3+AvWMkBp9WMIeUTIod4o8yBLcAY3iWjoCURwAwMWLppQHOxxk71FYzX9LgaYGLu0xVg9oJzkZGa3Vsge4jMHGFhgJGrHHP6mRnZgtYj05s5hXOQYJQgmQeOOLdOSY
 aO5SL9DY
 KH4lQzbA+gZzvkJZADUHDKMhmuA5WPlwnuNAXczx1X0s34zTfyH8EX2i6UvrVmT5t1/HuqhFxYmbhXcoul8qG6DPR8aCgxhXJKrvQItJO/m8bidpsKGiQtcFzWHlAP0+VUxgoLjNuvNBumG0EpEQA97k4P74FropNJ4UvHV2LhInm0qvNDbL60cK9c5klZk1/b/HvvfT5jm6R1MovHlgiHFwrtTS5Ug7kWfdDy1IdvFu7EZ8aB7OvYeLjzGjKk09Up4KsUZjy1GpMu+eRuLNjXFq2pQ6wfYmLsJAmfk08fFD/dgKFi1Vo43pbb7NWtxAMbZLDoxLhH19++p5ShzW3je7le8EkSvwBvNv3amo09m09P+ikQSRa5z3noamNnKypwjClmbREZoLoJNDMnYRjDvJbG//60gqVEl/FeUND/KPMFFPpOvtLbMpopfOrsQrt0/u4LXyZLWevyys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 04:19, Tal Zussman wrote:
> On 11/10/26 6:55 AM, David Hildenbrand (Arm) wrote:
>> On 11/10/26 12:54, n3rd wrote:
>>>
>>> Hello,
>>>
>>> I am reporting a security bug in the Linux kernel.
>>
>> Stop sending uffd problems as security bugs. STOP IT NOW.
>>
>> Tal has a long list of uffd-related fixes he is about to send out. CCing him.
>>
> So this issue was originally on my list and I had a fix for it... but it was
> REALLY ugly and a band-aid, so I dropped it.

Yeah, RWP is a mess.

> 
> I think the real solution is to just add actual markers for RWP and solve
> all of these issues at once... but that should be a separate series from my
> batch of fixes (which I'll be sending shortly). Is there a reason RWP
> markers weren't done in the first place that I'm missing?

Let's ask kiryl: why is it ok to drop RWP PTE bits during swapout, zap, collapse
etc?

https://kernel.org/doc/html/latest/admin-guide/mm/userfaultfd.html?utm_source=chatgpt.com

states "Unlike WP (which persists via PTE_MARKER_UFFD_WP), there is no
persistent RWP marker today. The user needs to re-arm the range with
UFFDIO_RWPROTECT after any operation that explicitly frees PTEs."

But requiring the user to re-arm is rather questionable design if the kernel can
just zap these page table entries.

@Jose, maybe you want to look into marker support for RWP to make RWP a bit less
horrible?


-- 
Cheers,

David

