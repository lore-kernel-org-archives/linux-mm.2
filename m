Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB06CC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C48A96B009E; Mon,  6 Jul 2026 02:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF92D6B009F; Mon,  6 Jul 2026 02:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7886B00B6; Mon,  6 Jul 2026 02:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EE316B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:49:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC64514028F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:49:41 +0000 (UTC)
X-FDA: 84957426162.23.14CA830
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id F198F40009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:49:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UZp7lfRv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783320580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZtCnYnyv7Hmpt8mLmtELq780NxRlJZLQ0qZI2absRDw=;
	b=ntDrUYA5ppAUtqJwa8SPA9az0P45tITEpF0Wkm37XvRhVrru/3hpwAcwfAfVQqaVnZX9sX
	jikauWWqSgrBUZyk+g/KaDcFl1hX2oE7PjuxFwKo3qEJ8Xf98TJzhp/UIpCkGTMTN4V8SU
	u/I3qmvfNSJn0xBCk1PBA9zkAOiOExs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UZp7lfRv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783320580;
	b=DUeCl0GRUSeXXvmBAIFWjTCHY/ZINxawyPDd/nwlbxBd1w2YZl7v4FE5EhOwDIcVE51X0D
	CjTZ2CITGiSlKDiB13X2lBvNeij8bveLVa0nC32SbY+uzLFxXjpxMan9EybXPYA0ZmR4tG
	ygscgy+fCoAzfk4Xap4gFea1UL+FnJE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE29F43832;
	Mon,  6 Jul 2026 06:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B2E1F000E9;
	Mon,  6 Jul 2026 06:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783320578;
	bh=ZtCnYnyv7Hmpt8mLmtELq780NxRlJZLQ0qZI2absRDw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UZp7lfRv15shr5/jiCnRRh8gt6f7FZR2Voy9nBq1Wf7WL/bVFyoFGFdtnLtFZT/RW
	 VlvsDgVXq1HJCUsIBprHl+OZ4v7RpuZmSGSgUXuJkExqqTQzP8wEri/PN+o6bct97h
	 qFP4NRemhz/tESWdlkezBlOrw+I4SCdpLSWFkH6b8uXt2SWOCMhIuuhIm7d7aMIc9p
	 KXEhTP01uiDoHqSd3QcZPkLToisJ6pOh0QzrjvR/VXWaDZZvF9qCpjvW4ug5Y88boy
	 88PB0wis58ArZBogah1C8iHnAGH8zDzCWCr75+deippDfJhEupejKo3Oe5xSmnsXgZ
	 eMji33rOSG36w==
Message-ID: <f986205b-1792-497e-aacb-2789e87a4483@kernel.org>
Date: Mon, 6 Jul 2026 08:49:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 0/3] KSM: performance optimizations for rmap_walk_ksm
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org
References: <20260706124039747M7gtCsrOvuzDyfLMXIJ2B@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260706124039747M7gtCsrOvuzDyfLMXIJ2B@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F198F40009
X-Stat-Signature: i3kf9ih3oi4nez41jzwgszf98or3wu5w
X-HE-Tag: 1783320579-887698
X-HE-Meta: U2FsdGVkX18icLeW52bvB5wzTi+1fMPeBk+z16s/Rf+rbSfgm907FOvYYVwANfqpBvlRylLbJw3SRzMyGNOqtVqKOGveN1yQ7w0Tp/ypHSq74SxitRIHx9Tt7oXJZrIXjwI1xK4myTAUSpc96It8rPHyZK3xyFOwkaxjVlQrN41xs2smuuEOMC0hhnoeUzKZ6Wr2K08Vu83KXDRdbOgQwb8b/MRkAlbZaknGHKvwpFP2wZp26V0sOsZ1iGpLDqTuV5183KuazTrccZpu4ohN4umSyx1cEYc4PzX37x3/FzWaKc2LttVVAY6SVNzL5i94vAQ2ll3b/9NZ3alslWxwdWRD4F+cEGJor78VL00eZkZzTL0IUNkakzfqibPEaXAyLgMaLvhZqiQtfXr2lLOTloS+czJMNmAfHSmnB8rdceDJt+JwUs/ORhAs9zd488PZyzirIV1BjFsUEBKyBeI9rjZn9Em29KcOsPLvOlob3TmVB+wO0xKP2t2l9YccMK6UAsX0ts3p7Vs+1WO6mq7VFgaXLrJYeBxPbtGSlK2UyT2wWhcfsppwKQkQC54y16Gqtp9Sm0txLX9g5pkmLjgz5WtQ7ml4ZcgUNjh0v6TZm5ddHVCzNw4KBVE3M/XOQBJBr9gcftAbwQJQo/rRdTAKKZ+bpIN6tM6Dp971EX21QsbcfbuyQlNE4tGUfGuG4ffPxcYpTZJHq5TwzeDmTEAqRPRWvrawyCXCFGs5oJHqCmvlEXw5e8mIAWsTyv3WZuIh4zyPxPxDeEgle6OiAuOLI2nqvph3CHOzK6tpFg9QfR8c1BW6uPRIOJyxAFAIup6zkc5QnvOvf9p4Gai/PmjbDJb7/oLTrHErLc5BvpYjG1o9iwkXptBXmvZC5vPr/30177PWrnZbqXHE8dN5QOAarL7XJYyv2P43sCJWqZdVJVMx60FNfX+pTh3mn68VAgsYMTblH4PmbwJDJUJL8H+
 JJgGZ0Rr
 r8JwUJVlLF1EVfosfgE5RCz4lmtsGfXwmgamqb7ORW7+OaxJlbBFVhQOyT0nPqYrhvXhcqQKRtHlsnYGpNwsX1CzaeIRTEE9ulbkt2tIzMtrnXsoFmbeGqr0dAjMi3482sCiOEIsLBuGPV7NU4pIaVYYwt+O8uePvS0APxGt4dSj8SZh4lzxzYs4ankm2+Vlf/r/UE7+HNVy7HUUNWBspJaJwRikWh4V0iw8r16NtfwMxnxcwDeCKtl4HPgegFBD844L6IuUbc4OPKSLT9X1vouMZPncGxGnC8KuEMoUWkbmootEuav+ieNArudT0uDRWD6a0Rf59WGn0GpT1Gwuf9ztrZGXed1uxyZuzlrgDqfS4NL+sZpdUjI3qTF9rMeuznVJ+dwPpMR2KBQ4WNtLH9GBwj7DLFvBAa86kEB01VhsraUM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/6/26 06:40, xu.xin16@zte.com.cn wrote:
>> Again, thanks for persisting with this.  Great improvement and I'd love
>> to see us get this finished off.
>>
>> Please have a look through the AI review:
>>
>> 	https://sashiko.dev/#/patchset/20260703162253688u8Str9eFLR8TGCmo7nIOF@zte.com.cn
>>
>> That 32-bit thing looks legit, kinda fatal but easy to address.
>>
> 
> Hi, Andrew, This is not a major issue. I think it's acceptable and detailed
> analysis is as follows:
> 
> The sashiko said:
> "
>> Looking at struct ksm_rmap_item in mm/ksm.c, the linear_page_index (unsigned
>> long) is placed in a union with an anonymous struct containing oldchecksum
>> (unsigned int), age (rmap_age_t, 1 byte), and remaining_skips (rmap_age_t,
>> 1 byte).
>> On 32-bit platforms, an unsigned long is only 4 bytes, while the anonymous
>> struct is at least 6 bytes. When break_cow(), remove_node_from_stable_tree(),
>> and remove_rmap_item_from_tree() assign rmap_item->linear_page_index = 0 to
>> reset the age-related information, it appears this will only zero the first 4
>> bytes (clearing oldchecksum). The age and remaining_skips fields would retain
>> their stale historical values from before the page was originally merged.
> 
> Indeed, on 32-bit CPU, that patch doesn't clear age-related information, but it
> doesn't introduce any issue because at this point the linear_page_index and
> age-related information do not overlap, and there is no conflict between them.
> This is clearly consistent with the logic before applying the patch, so there
> won't be any problem.

It keeps bringing that up, and we clearly document "might overlay age-related
information". So just ignore this.

-- 
Cheers,

David

