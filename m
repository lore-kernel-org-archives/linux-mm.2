Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8A7CCAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 14:12:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28FFC8E0014; Mon, 29 Sep 2025 10:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 240F88E0002; Mon, 29 Sep 2025 10:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17DE08E0014; Mon, 29 Sep 2025 10:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 052F28E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:12:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9459119D82
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 14:12:28 +0000 (UTC)
X-FDA: 83942477976.03.7111938
Received: from sendmail.purelymail.com (sendmail.purelymail.com [34.202.193.197])
	by imf30.hostedemail.com (Postfix) with ESMTP id C66D580013
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 14:12:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=elijahs.space header.s=purelymail2 header.b=ZBNhyTNk;
	dkim=pass header.d=purelymail.com header.s=purelymail2 header.b=DzMH1a8p;
	dmarc=pass (policy=reject) header.from=elijahs.space;
	spf=pass (imf30.hostedemail.com: domain of me@elijahs.space designates 34.202.193.197 as permitted sender) smtp.mailfrom=me@elijahs.space
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759155146; a=rsa-sha256;
	cv=none;
	b=AOWJ23bjjA3MFg89RQpAq5/JGI/uk6ZVNKB3rVxBeE6qVXz6IwZfYter+mYoYqgW5bBSq/
	u0knZOMxlLIwc0c22DQ4Gc6cKqQ4JOJDmKhQZonkJXe2JMKVmRh4/qUazeT0IVqWfBmagW
	jnNxKIPHpjhbQuGYZ4UdEOSCXoP6ftQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=elijahs.space header.s=purelymail2 header.b=ZBNhyTNk;
	dkim=pass header.d=purelymail.com header.s=purelymail2 header.b=DzMH1a8p;
	dmarc=pass (policy=reject) header.from=elijahs.space;
	spf=pass (imf30.hostedemail.com: domain of me@elijahs.space designates 34.202.193.197 as permitted sender) smtp.mailfrom=me@elijahs.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759155146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QxavRRK5ToUbJF+iVQrLqhv2/aVrny6rjU/8xeofgPw=;
	b=4VAIpJdS5XMxmThnAPTCjaJ340hukAtLZiBh0Zgx0FUtnh96dT9pYVuCUtU6LxkdPLEgFl
	hdjR/fVb+vJYIFDWE2kX89uExfwxnnNaMOyyv590oIu97Q1mAJOWzMlTNdynab9G/5TT6i
	1ZRLDm9AllEkgfTybcMbu/Eg+jxBnUA=
DKIM-Signature: a=rsa-sha256; b=ZBNhyTNkuQMTegPV7L9ZxWlmdqbNIbmsbP509jKVcEC4f6WQLi1bUfZ86iQ1DLmPDO4GH+5Ix4ut3bqnQUrLtbqPb979pfp+h0GJ42ltT9YhFz9qppYvL2tMJs1C3VzTdsplFVzMoaxHBmNS0aChvwYlcoWXizR9yAIXbPezsdUIuwAdG3GAhpO4R14Ex7tafSOJW/Ga7SD7uo9JMOQ1otw1ApYN0DqwxplZSB3dys/WDFMi3/aKnES6tr7WAsrRxz++gUzA1KL1NbLKCHXH8O0HtCnGiL6D5Raat16dH48Usk04oAVM1upMBCFj/369iEj/U4ukOIoKxD16ysZg1Q==; s=purelymail2; d=elijahs.space; v=1; bh=oPuZYF/E5DhWp+sFZmQbp9zye2zGWxCQpyMYGTjp80o=; h=Received:Date:From:Subject:To;
DKIM-Signature: a=rsa-sha256; b=DzMH1a8pbkVGIJmZgQzHmD+W6VUh3NiLYZ/TfIE2zxrr8+MEH8dioIoJfCywn8fIhmRP8nArhafZd7v7imSDZuDbRkokQfx8bQfQx2C+W32k0bFrWTcsf7z9QMQ6FlQCFSJu6myx8wiWrhEIiDeUhy/WfhYdiLycZQ1b6v0u3mGRcSxZ6IrSWSxIUFOCYAqC9ZgkiyvLdEfFebXzrlpxGEnBKbZ9JcC3NcBIUj+LTNmwli5Cy9ugNonPswOAHOXkhYoY94etT9fbTQW5jIDeAh29ad+eyZJbXFm85WUh+SUewdQtWzC8JdDge33Qn0LJ8uHgVFq/fJ8XV5O3wPYR4Q==; s=purelymail2; d=purelymail.com; v=1; bh=oPuZYF/E5DhWp+sFZmQbp9zye2zGWxCQpyMYGTjp80o=; h=Feedback-ID:Received:Date:From:Subject:To;
Feedback-ID: 26912:4866:null:purelymail
X-Pm-Original-To: linux-mm@kvack.org
Received: by smtp.purelymail.com (Purelymail SMTP) with ESMTPSA id -1169688956;
          (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
          Mon, 29 Sep 2025 14:11:37 +0000 (UTC)
Message-ID: <f6b874f7-0031-4a7e-b781-f888249f25af@elijahs.space>
Date: Mon, 29 Sep 2025 07:11:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Elijah <me@elijahs.space>
Subject: Re: [PATCH] rust: slab: add basic slab module
To: Danilo Krummrich <dakr@kernel.org>, Elijah Wright <git@elijahs.space>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
 linux-mm@kvack.org
References: <20250924193643.4001-1-git@elijahs.space>
 <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
 <DD4IKU7O94WN.2VALE9M80XGQ7@kernel.org>
Content-Language: en-US
In-Reply-To: <DD4IKU7O94WN.2VALE9M80XGQ7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C66D580013
X-Stat-Signature: 1susy9op6smse5jp5kyqqyoqa7kzun1a
X-Rspam-User: 
X-HE-Tag: 1759155146-875237
X-HE-Meta: U2FsdGVkX1/torvlz1D/ZsvNj78EyZP8N2vOYwydLjwBebw4v94oYaV/SQ4reQcWYx06uA5xKXM+Ukrns9ganz6dU0j3QmIhJSBv8u2hlv38YqqY/EqUpknxGSZp2G5VA2riklO8XwLBThDFVdK5lTe0e/Rl0G65yx2xgAiMwAsBjSAhmEiRoTc5Yl+/wf6u+uq51XGA0MX3QD6JpD+NUIC84diLtFVC3Ls/elf2bZFzY5VLu5dcq4ahw7xlM3fg/oyG/ZECFeKl8XuSA5FOSbhV5SQMqnzB88ph1a6d6iYwRuJZOnOV4P4Z2ckAKlsJ1n1WEbhgLq/CBhw7PRqR6f+C/vo7Kj1YJ+oGqcfmo47Jpyv8og02nMTePNzJmbGDLyCSsDwl997hQfiAbFzwaRUXbDiTJ7lSx0m/VSZxWZORwDxTNuObCvI+QZqkbklnxw2c2LysmpVBkNVEpO+xjI38xv63Am8ddg81OhtUivea69gSAmnuZc30m+vrFOrZ4ObOfvKL9M3I2P0Ng0sf8Ra9y/deMRX1F1LsChBmUEMm35TlwL+iHSlercwn//vKVB+VgAdnHK3sDlzKOTHxCGpsqpN8eJiGqe1pAIScyak5kOKxei6DarRyYpRuxKEviYHUvLN1AMLcYUnm6AM+qg8DqXrx0ixTn1U0QW3vNpN0rswUKLCeB9nxJUIVKAgqJ+YOY1Ofr+b8DoioYonR/l8WuRn2Pv21bZPUOeAJu3zbPdM4obGOeMWHMLzoMLSEb0+FzO6VDQhdkgoD6tjNWwzUboqtWXXS8LwWpCD+agmkCpboxXXG1WcirtIFXjVES9WKpw1dnr6oMx345ZrxhUvawJfl5p7AIrXWCeWhMA4hsyj3gdI3VUspDrJZnmlM1ZS8UN/hciBKk01WlYzQKNfwuMy467BPjbmjCV7XYex29mIIZSQv3t5w5PIprCGipBc9A/gztWJ0/2o5mV6
 HUFxNGMj
 w50LhNHTrs0YjlQBEoj9ex3ddiRemP0W4J7czsCLtIhXZFbKXu6YFdMjAcVqxmExAiF+iTIaZ6IfblZ7SHD97zuyqqgwQvY41H1OwVbRo81VtBUVrCA9de5Z3z4TQYyRmGQ3ds25AgHETvXQ3bWG5kYTEfq56JVmGS/9AbLaEhg1IhUjmzE+vCIqbI9MoLLeik7yXJ5ksPFCHCxQM/qMfznlaeKutiYWYFFWHgaAKbe2J2CuUavj2bgzcf3XFxg7X6Gc0huF3ayS2s+NO2Wnje48Za/tLBDbTfvKgo1/FuOZCzhbZa7EmvlXeZWpwSIAclPD2xN5YWzPGkoqEoAVxgZjkt8xcYSFN71rUOuZdo/nJxeVJGpJkmRx/Cov2unz6caGoUDcCPcaJK6MDo80tlqdPnodPgYUMcH7Xcegz44MfK/bvZJ2N/XX2MTkWBV2NPWHjF0H9WixVJW0YLz815OgiWkv1a4CsnHsSv6sH9rYIlGOceouCOuszuq7YvCGQgubnig6u49z8HwKdYMc+3PuajCzoWPjKqGlh9DNy+A4N2zojJ6JV9GzeOth1Tb9pm+XeymCKpjRXIc3FbE4zmz3YTkaPqk059Anc9Ni/E94nE105gqdmkAyqzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/2025 7:47 AM, Danilo Krummrich wrote:
> On Thu Sep 25, 2025 at 11:54 AM CEST, Danilo Krummrich wrote:
>>    (3) Implement a macro to generate a custom KmemCache Allocator trait
>>        implementation for every KmemCache instance with a static lifetime.
> 
> Thinking about it a bit more, I think we should go with option (3) for now.

do you want me to implement that now? if so I can take a look in a few hours

