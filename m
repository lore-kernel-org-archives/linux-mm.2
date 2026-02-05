Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48AE5EC1EA2
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 11:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B46EA6B0096; Thu,  5 Feb 2026 06:30:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFD576B0098; Thu,  5 Feb 2026 06:30:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00366B0099; Thu,  5 Feb 2026 06:30:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8FB206B0096
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:30:14 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4628713B144
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:30:14 +0000 (UTC)
X-FDA: 84410184348.13.7054669
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 62F9B1A000C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:30:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GusXm/XQ";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770291012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARu9RWKTWaeuNCD+m4jsLFTfRNQBaUfovGQzI8Lt+FU=;
	b=e2v66Ul8muDW+32/330PMgvcwyfLnmnxgDJxq6/m84QvgM9l75lA8q1PBpVm1UfPBJY8B3
	Ur0uz3AG2p6Y0H7RUnQ83T9hmCjZyHWb5zc5TN4cYp96E8seXCqAB2qOZl/nG9YMtZZf25
	WR/nIHFrrKwGgLQvM35U0voiF3PblMk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GusXm/XQ";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770291012; a=rsa-sha256;
	cv=none;
	b=11nK+JwuJMH4AP/0tjR+uhhJ4KTmcM11C4ahQCVO6B/1sNAoJi5thdYy3TRj/Luo1VgAN8
	5WHMw35g6eJDJBo3DE6TlLGAJ3ZWtu+PlGnL9oQ3T/ODyOQXg/hg11X+Gw918WUar3H+iW
	2rpthUL6V6dHzo7YVwNITzMS0NHTOL4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 60E5D41B17;
	Thu,  5 Feb 2026 11:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA44FC4CEF7;
	Thu,  5 Feb 2026 11:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770291011;
	bh=yjFfDiB7QvVAJoCDOQq8yDVm0dFkzkNT9LWYVXaMiw8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GusXm/XQXMYNEE8V9qfy467zcRRIl20Ron/g898A0cBPw6UR47h4i09RH5qW7Ar2z
	 u6/AVzVpdZAuSayP+cp4BmCATJ829mX6n8SK2T4JNBDzVfPbqVep8l4CGAqdJQ9ph+
	 3zUEMyrIOfZ18W9Azb+RuaAY+6TxQg8VLzZ/jjbGhLFZvSi2RxQzt/kTrahDeKhTQm
	 slAlJqqZfNTXSptHNdzbIbOGljsLvfjjUd4wLI311cE40a6lj0uDZCi+jyedb2i/KJ
	 Z0yUKDK6WcSgD2YLh8MjFpXJHKhm+X3Eyyn/U6SAnJxNfYDaD5ujeaPJ6DWGatM17c
	 LZwiQu/kA5TaA==
Message-ID: <17e3e758-39d2-49b4-8665-2aeeb6b266de@kernel.org>
Date: Thu, 5 Feb 2026 12:30:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
To: Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Carlos Llamas <cmllamas@google.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
 rust-for-linux@vger.kernel.org
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com>
 <d3dca137-2e4c-4a1a-bdec-63cc2477bfda@kernel.org>
 <aYR5J0ip2MdD3nMP@google.com>
 <2f908340-a983-42c7-bb59-2d6f3a80c834@kernel.org>
 <aYR8a09XUh74tg8l@google.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aYR8a09XUh74tg8l@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 62F9B1A000C
X-Rspamd-Server: rspam07
X-Stat-Signature: tpqdpxhoprwbwbamosu5x57op9fqinie
X-HE-Tag: 1770291012-506562
X-HE-Meta: U2FsdGVkX1/wlapEOS+OCGdEAnMra3w8adODbTtmZDwTi4Ep8ZraigEIgf6C0hiYEOU8HEtzREdl5YJ7aoIXlcUJJi7KlNeMiv/AWx+Aa/RUXnf+8/Pn/lhlHHtKv+fufrxeu75BYvcUz+OZvKbkh1yM/t41BD9XqHwBWcjwNpq0cB1KazscNeupJTJcVginDUTeziw9wI8nDkERTmh1B3kKTELtDBiFpisf+nV1UBmpVeCuiR2ZjMEDbGwRg2AaUPFL172tWueztD2yhBR6shXRH3XCjiu9HKpql7kAmleKgQm0+eIMOO2QBMTE8PV69HUvBB/MCuFTJJYmmNiJgEKA7tvargmy9AkzvtCr8OmB3ax7YEwYW2ilZb6XLGfCIfRCyyAGwPcUeqdbZ9F/ZUkPZnvv61KPR13CVZ4OxHTSbSWyuD2HMtjLsMGZepFpdgCStFHeOPZlDGolem4xmxCWp2QFQRWMEfD4ZtksjA7oZMYjU+g1SfiEPVadIMcKCP+OgvFUzVq5o3HGwzwzcdba1/8Dm1CVo4D9NXJCsRDNouO1IFmpV6YZnq8WwEawu1SfvSil2ooD1msMdl1P4iyxo8zTRa4kYhhWHFl/uGfnpyaiXnkpm69voQuT+N5udObEa135OxcBCA/meIivTa3Dw+sFxgzVHIYPGhzlBAd5ahA99iGu+57ig1zuOyfplf/ZaF679QnrYm5Vv0QmEvuU0fy/yT2T8YuHD8rmqWnuNzefvFynrjYbWH5j9IGiAwZlTX9wXc0sw33zaXhzRumNYVPMX8Jo1HHxVPRdqwJI4y8dAmVpoSQ/PjuhO5eATfTspJAeXqkpz6FjCrvDfsnJqIgSGzCSW4xB6L35n2GcDzqJXRj/6iPP5nngIpO1I7Lg3PpdPoVlX78R7uCbjGOY61xWrsChE1LSHL4dL+1iaD8bXT3hd9DDaRD5ekTfawjqSCCY1/nt691HSZe
 YMzTExJI
 opncXFQ1nR8qAJTojMccHoqzbOqr9fmE7pSJk70/WETC83w9uutzDP0wUdlwY6xHAcPbhZhWTJ6EzStet2CxVJo7dJdKFQEGGPXRwdK0YsXwFYOxxUR7pZ56gyjcL1b1J4D7jot7xFzC8tPKfS78p1hj2BVG8zn4HjsZ8iZdxOl4Oohne5byuVAmRUFW+vlcNjie9FiTh49+m3xXkoUNcyV3IB/NANCfmGYkbAwWiMGIjdIvsDx6pHyTjGumsqG7Vw4BpZrhvl0nlUa0nVxRl1yLr+fXTwZuJSrQhA1XFP6avbXkxf+LYOG9I5xikjN8Bk1rMHr2EwE0/AAteiT6nn3Beb7FNzE4/j/A5wjcOG+lvC9FraHrjRtmMDRL4HRkqvUhAa+IpACI2sSRzBgOuq0lU0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 12:18, Alice Ryhl wrote:
> On Thu, Feb 05, 2026 at 12:12:23PM +0100, David Hildenbrand (arm) wrote:
>> On 2/5/26 12:04, Alice Ryhl wrote:
>>>
>>> I just tried to match other symbols in the same file.
>>
>> We were probably a bit too sloppy with some of these in the past. But:
>>
>> davhil01@e142025:~/git/linux$ grep -c "EXPORT_SYMBOL(" mm/memory.c
>> 12
>> davhil01@e142025:~/git/linux$ grep -c "EXPORT_SYMBOL_GPL(" mm/memory.c
>> 10
>>
>> So just go with EXPORT_SYMBOL_GPL unless there is a good reason why not.
> 
> Sounds good, I'll do that in the next version.

Feel free to add my

Acked-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers,

David

