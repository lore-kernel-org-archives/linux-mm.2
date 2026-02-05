Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C4BEEC1EA5
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC376B0005; Thu,  5 Feb 2026 07:06:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB46C6B0088; Thu,  5 Feb 2026 07:06:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC01A6B0089; Thu,  5 Feb 2026 07:06:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C46086B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:06:24 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 689701404B2
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:06:24 +0000 (UTC)
X-FDA: 84410275488.14.A5CEAF7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9D06540010
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:06:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hJwEqcWj;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770293182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aCpZAnntu1DbkqF6o0273cCfLEzryMw+IOLqq4jGoQ8=;
	b=JpiCBf394tCS7o9W1jC7yldRe/M8umzedgBSDFSUwSSEWXtU6UuS9L/j71vXIW4T2Hwc2a
	U22ENtK62yKZt2nQIdvSDvP+eiybrXDrZ6gJjweXpfXKvmkBmprrVQWtv1/ZbCNhL4Qt1S
	9MnEocnjCHxeIwlvAuBOdvp443ubRtM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hJwEqcWj;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770293182; a=rsa-sha256;
	cv=none;
	b=B/782AZIX9+YrkQVdOHHmBaYqz4Bo3hqV1yn/f7Q8w9SBz7mNZGFRpqc5r/6bOitsmaWjB
	/Wl6dGXeWuKsN9CpKmI0v+yhzbGN+ykj7yOS4ey3ObPMrql92teEUoCiNq38aaVSkbiRFf
	K1yj9m72gGA7qs+c80gNNLOMAEc3hoE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1267860128;
	Thu,  5 Feb 2026 12:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7DAC4CEF7;
	Thu,  5 Feb 2026 12:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770293181;
	bh=Ts8Bruh1Flf8jwX9Vrdlbnz85maJtke/C0sk6jffhuQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hJwEqcWjgpIb9N7DaK1KxzXaJqv+iveC1urcCbK9WJQo/ywqLOFtFyxvoJwZ4qH6D
	 O03Z5w5uTQFMbE55VHm6fADsSrE/Ax/aX80tm8VM8w/5DwWlWTYjCjbIBPoO3w0CY2
	 DK6fXoR+SZo6e7pim46CQ7vS6qCviXy3FUX0+hjgxxmqq5w3n1kB02WsMzmYHT+Pkk
	 OWHfVm+2zvxLtO06jnE58eX52YaIDuUTopkNy9p+KnJYDHUyl4qeYVByLeoVzgOYhE
	 NIRPzS4QIscihiH5UFr/4tHYujOv0jlUfsd0qOj2IX+Mjz7jWQQC2RdqKeYBzqH20e
	 hzpEM0sHbMjow==
Message-ID: <d309b3f6-8959-4767-b262-7fdb957669aa@kernel.org>
Date: Thu, 5 Feb 2026 13:06:10 +0100
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
 rust-for-linux@vger.kernel.org
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com>
 <02801464-f4cb-4e38-8269-f8b9cf0a5965@lucifer.local>
 <21d90844-1cb1-46ab-a2bb-62f2478b7dfb@kernel.org>
 <d122f9be-48d6-40b1-9da8-cec445bd8daf@kernel.org>
 <4a36c1e7-e51a-4c06-8f7c-728b278af972@lucifer.local>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4a36c1e7-e51a-4c06-8f7c-728b278af972@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9D06540010
X-Stat-Signature: pkqurofuy7waytoh34ziko6feje5bzbn
X-Rspam-User: 
X-HE-Tag: 1770293182-172771
X-HE-Meta: U2FsdGVkX1//Af8uxMxIfStMO9F/mNiUqIlDnJ0dUocN6iGU5kftMt4BBpFxakwhFaTox3Vmjd6uUNGlKxsnAho9sl1TKISFyXaeYs9fbk6YfloDx+OdG8jA8HkdulCP/AUelgNEWbPnxUXYfm8ljnFOLuD+defJCZN8G2arv/n2GkDnMEbZan16pnEFIAc5VtdE/rfEBYIV9biUQkv7OHwygx+1/oo6uC8U6IDWg2GeBI6QFq/nzJDm8dTwA5mUlzks1biDPDVPmvioUeqP96SN3srd4+Ycv6EzKxqp0QfePyttIckaK5TfwVaX5tNCkft0q8M0nX2yyLhndVx5ftRNkndDDtEM5SxuRPpc74eBoyw7Zb3mzOC8p77/SozBEgZRKVPaNU3RAatRQ7mjH7KVGrbtGw4b3QY7a3IM1Ell8flZVoWQboz6N485BrrITOfPNzmTvQw2hsZ9KGrbJdRZPCMqlWJsdzoHUIsBpdVh09hiJh6sGX6cCJeLs6UuyzA0nfbteudBfTUfJao8Y2V76xotRssz2/MS+uRbFhiUABzTZLSvbt2zagkdOPxJcujV7EyGcm67Pc4Za9GHggAm4kbWKy+s59H/QYPRnNP6cQA8+2VExGedFXYjoHthgn/AzG674hxvdypIWmgeWW8sBn8cvISS6Ut61MP6uLNSC1lmPevlChmkeSz1kLmObQYU9HJWywAM33VUiNwfqPCJ+2OP+4UAxyHs5/2vNV005fQUJOqC9YPCDju6u1HJ0T4lwDEIWBRNQSJ4n8//5Gg/0st51/VNBjByXeO3OC0kPIYlUexb/CnsGCywigAiz+hWhgp4APa+dssJmDYgHKlNnQtNHS1eBLZArQgXZJnuLUcMBUi8sq3qVN6SGHjyo/t/qGH3oq1bOqcHQuOok61jSq7qvSTXthU4rDzSrFZLDm/uCWM42uM2Za/DfsBc9nDwWRcvkdOxHkYtPGk
 NQwRzedf
 WdptGa/Day00ql2RE6Md6CBSrdWkp0z9wSKAzT/E9BG9f+AC/BKk+e9p4/O9x47Nf2P1fqts+i6wIpxF6dXzJJ9SbyQYuvIbDIY4oqUJCFvakpeMle+v8GUvHmSzYxkJ0ZVP6GIOTFdSorZ5QWui/kIBf48YKE6BnTjdc2zt/ywPlgkz/DtVCgDbAELTYbdQu2be+ARLi2BBwrZcyXAvYV0s3sRcCNGlq4AwiZ8+dL7wZQqw5U12uEKW1RiIRBGvukJsKEf4IFkSHnxfNB20BkDXjwePgzQbaFdSiZwAYqtMInHT3nP11nQJSVA3qVqTdLPbxUfOVRKggz2D8W7oXV7hZ9T2wQaCbT999bUI0/71GooBcR4/RAbAdZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 13:01, Lorenzo Stoakes wrote:
> On Thu, Feb 05, 2026 at 12:57:04PM +0100, David Hildenbrand (arm) wrote:
> 
> Dude you have to capitalise that 'a' in Arm it's driving me crazy ;)
> 
> Then again should it be ARM? OK this is tricky

Yeah, I should likely adjust that at some point. For the time being, I 
enjoy driving you crazy :P

> 
> [snip]
> 
>>
>> The following should compile :)
> 
> Err... yeah. OK my R-b obviously depends on the code being compiling + working
> :P But still feel free to add when you break it out + _test_ it ;)

Better to add your R-b when I send it out officially :)

-- 
Cheers,

David

