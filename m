Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95BBFEC1EA5
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:03:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D23116B0092; Thu,  5 Feb 2026 07:03:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CECEB6B0096; Thu,  5 Feb 2026 07:03:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCDFC6B0098; Thu,  5 Feb 2026 07:03:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA5556B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:03:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73CA81A04C4
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:03:49 +0000 (UTC)
X-FDA: 84410268978.15.9383769
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A4A761C0016
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:03:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iB8TpwPL;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770293027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TSmccwCr2v8xONKj0ZP+Ky8HW/JEHiLLtBGkMWBdx10=;
	b=LF6E8CR9i/5dW3ozWhuxCOb931BSS+Od0Vepq2YL4/5nzmbSQX8lzPMgaLM8qQk6d6pG65
	vDRYB0KPc0VYqadvJGcAUk6kINmQc1+EKWplfUrDK6mjpq6kiH/hDfjoWg1SGNGFdK/xhH
	YfvZH5togZz9SoBeJbKbwgfstuX9t38=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iB8TpwPL;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770293027; a=rsa-sha256;
	cv=none;
	b=5CkSqZdYkjVCPmHHgPev2V3JRxM+wwbVulq9Iek71t2RoRlEl7zhKZC581mTlh3SzoFR/H
	gUAF3wIDos+62l2RX+AHVwIxjPdIaCLIXy7RC+ZZobD69x0xjVwu9VKZuTinEn0npuCfLX
	+vQOwY350EOW6F35WCzndF9hV4Q+u+o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F78560129;
	Thu,  5 Feb 2026 12:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E33C4CEF7;
	Thu,  5 Feb 2026 12:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770293026;
	bh=zfq4qj3iLBvccfTblZ0Z7fVCeUnHgrtGgZzNA+DYoQM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iB8TpwPLF4c34Fd7ZWYKxYeEbiCxrIVVcxOPLVTsfHfQlx9RqDu3pkZ+svMudOkJl
	 JIqjXaGWmlIgLmVjhUr5CqiT7Q/IYIoeTzvwWMXSBAcFWdnucJo0PizFhrvpMkckMj
	 V43itHLCt7VRR2G/zLMOxyeZFlRS1cRuEvxe8R7U2hLXZx6UxRR9UyTt2R90gwO9u0
	 hN5L2f3nQDQn+Bo8fr1gEmqRPx0DxdGx4GG1Bhlbk4wvF/RHqN1iYnxy1jLJZUtnkw
	 dJ/VM2dGHy8E+dRe46y7O9OE/E7ABjsMQ9UAnjt4bdDzz98ddGyr/UOA9g4jImZT86
	 sh6RW+WFrHaiA==
Message-ID: <507d24e0-4563-4b33-864c-cd1a499fe517@kernel.org>
Date: Thu, 5 Feb 2026 13:03:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alice Ryhl <aliceryhl@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Carlos Llamas <cmllamas@google.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com>
 <02801464-f4cb-4e38-8269-f8b9cf0a5965@lucifer.local>
 <21d90844-1cb1-46ab-a2bb-62f2478b7dfb@kernel.org>
 <ab63390c-9e75-4a45-9bf4-4ceb112ef07f@lucifer.local>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ab63390c-9e75-4a45-9bf4-4ceb112ef07f@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: on7atqmd9gurwspq1ucuabhpcut3wsip
X-Rspamd-Queue-Id: A4A761C0016
X-Rspam-User: 
X-HE-Tag: 1770293027-897245
X-HE-Meta: U2FsdGVkX1+bRp/pAWO3aeBy8CsNq9tEzPM8l/aoWDEfIkzkO93Z9BYLuzxA/QOpO2DK+5mUnNUBF7ES9CcVCufcgd1SvAQrBSv6wz1tbtId70oMMUhjvLa4KG7KfXt6ssVuzsHzLe9LctKMQc3AtLCvZEayBYjQNAjsmKhV1ZympCFcaAVJZl8VxigTOOQ2QI1Okfl2CAeyFu8F9ccSCkTEYB5ReJGsQ9vP+ta6jlSn1J4dXyWGjDt3aL6ImB2s7eXN8vrrMshitPMNtP1nVopt+c2V7aJoo2r6zcRSCSJ3bpCJByfjYnG7h+/eL0Wx3XULu0EnXsKHMDwcs6QQWUCtKDrV3/ihbJJ0ab+Jb5fyb/n5XdgJCij4Elg3Z5K/g0YNltu1UNhZY/5V+WI1JQ0MRmKRM/KlOiBqg7ejdSQwhYYoRElCGQsCfmFgpIVfHW06nFTydGXlBtWbx281/2yMqeEgDXi7eRBYeL7lZ0AT0ofjNvyAk7Il+OZr/iS8YkKMO7rZq704qXFJvavKJrHXsB+b1sFflMZZccZxJJXGCXTZyVIPm5PFvHcw/+GHdXE4A4wsAhNN6oL1JhbD6tc8NAlNzWXTyVwBDOUN+/r/IBBoKK1w9woa8Ql6Xr2Rw8szQ3uNnf3A63p4qQwNGYhN5njTg5NisjbS1sLPxKsKdBhQxbfJFMR2riU3+rKKwAbFrNoy/7vwxQEd9FfaLXGoeIX98KqRihiL9OiXcLvOt+OwF4hcozHYwPRQVJ2sDlr+kpI30UKRUsRR884H1N0tNrdaOEp1H0Cm1EPrNor5XRYuA7n4vkIPQtH+hmis/cgmYqRsVxJ0LsC2ouTKRLnRtDWrfvKSbfkx6ix6It6+vCvD+Biqvm6dDW5+JR2agmF6QcbJ1LmNQkTjN+aXTYLRgoLxNm6i3WuFzZCy/fVTaZQJgg3r/6jcH4cYvdkhKWYUGG5JA62+Bw58Gn+
 /eb+BzKC
 JDIeF6qQ9YHV2NxJPIcWP08N5uJxXLpNCCNyW5Ho+aYkHTghAY1ddeOFlWpVIfWyBaTxBtTtZboIGmUsHC1FNXzr11eFXAxhmWNHu25lGW0gBfWhbturVPKQ8t7FpvQ8dC+1GBA+BWM6fcriGkT7dAZ5L3quliou7f8f8nG3sAIQrdJIEjgWH7Rye5GlyQDrVwiLYBB38yAEsim0owwEdK8SLVfLUdDx6GUPE2PU5WBPPlpy6V4hSGuMgh1osHxlklBUUzNLPQpyjb8ffJu1bKadvRovCLN32g7YNp2ECdXCVbSGTWxcks4bPDxENobFTNXRsdjLxD9CkHZYAUrCmKPxe9cLbm9rtiGlXd3ENN94ZGD1wBleH5ZFNmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 12:57, Lorenzo Stoakes wrote:
> +cc Christoph for his input on exports here.
> 
> On Thu, Feb 05, 2026 at 12:43:03PM +0100, David Hildenbrand (arm) wrote:
>> On 2/5/26 12:29, Lorenzo Stoakes wrote:
>>>
>>> Same point as before about exporting symbols, but given the _obj variants are
>>> exported already this one is more valid.
>>>
>>>
>>> Sorry but I don't want this exported at all.
>>>
>>> This is an internal implementation detail which allows fine-grained control of
>>> behaviour via struct zap_details (which binder doesn't use, of course :)
>>
>> I don't expect anybody to set zap_details, but yeah, it could be abused.
>> It could be abused right now from anywhere else in the kernel
>> where we don't build as a module :)
>>
>> Apparently we export a similar function in rust where we just removed the last parameter.
> 
> What??
> 
> Alice - can you confirm rust isn't exporting stuff that isn't explicitly marked
> EXPORT_SYMBOL*() for use by other rust modules?
> 
> It's important we keep this in sync, otherwise rust is overriding kernel policy.
> 
>>
>> I think zap_page_range_single() is only called with non-NULL from mm/memory.c.
>>
>> So the following makes likely sense even outside of the context of this series:
>>
> 
> Yeah this looks good so feel free to add a R-b from me tag when you send it
> BUT...
> 
> I'm still _very_ uncomfortable with exporting this just for binder which seems
> to be doing effectively mm tasks itself in a way that makes me think it needs a
> rework to not be doing that and to update core mm to add functionality if it's
> needed.
> 
> In any case, if we _do_ export this I think I'm going to insist on this being
> EXPORT_SYMBOL_FOR_MODULES() _only_ for the binder in-tree module.

Works for me.

Staring at it again, I think I landed in cleanup land.

zap_vma_ptes() is exported and does the same thing as 
zap_page_range_single(), just with some additional safety checks.

Fun.


Let me cleanup. Good finger exercise after one month of almost-not coding :)

-- 
Cheers,

David

