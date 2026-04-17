Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 181CBF43693
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 11:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4105D6B00E6; Fri, 17 Apr 2026 07:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C17F6B00E7; Fri, 17 Apr 2026 07:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D75A6B00E8; Fri, 17 Apr 2026 07:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A2626B00E6
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 07:57:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1745AA720
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:57:06 +0000 (UTC)
X-FDA: 84667896852.06.EB3DCA4
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id C297040006
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:57:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nGR66OsI;
	spf=pass (imf12.hostedemail.com: domain of alvin.sun@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776427025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VocBKMQd24k2utfjrgbZaZRKOSSRYHwNHI+4XQHY0Cc=;
	b=ATIQiWL0dPrXnpEDXKapmnqeQjFzJKkbzrvJ4M2FH4DHnZjh/j7o9nlSwlYJLL1/6r6bkZ
	xpQZ1T2JBh/296V3Opq2dgCfZetxeRbniN08bJldQArW0UJZC4LlEHSDt9ycAKOxP1EegY
	n7n+ILXb5DZ5WY7G3/UrE+3JS6aBl94=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nGR66OsI;
	spf=pass (imf12.hostedemail.com: domain of alvin.sun@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776427025; a=rsa-sha256;
	cv=none;
	b=NqdsFBCCXk8n3X7sF6tPvIV5ORP0E9PBt/1fN+UX98L58FWQ4j5WHr+mBaQOfR7dqWjEep
	I0zIPdsrcMtt584XB3nCnAF5NiAnTO9xUU+sEdvnMEWdPBchM5eeP58n8JV50Ia/jXkVRD
	PKAsS5NRAB53YtJPGjbhKYSPYE6zZSc=
Message-ID: <cb3dd598-04f8-486c-ba6b-9965d93170a0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776427022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VocBKMQd24k2utfjrgbZaZRKOSSRYHwNHI+4XQHY0Cc=;
	b=nGR66OsIEtPjvlGMeDVhIadGArVE5v36orOS2xMsH1Y+xkcnaN6NELOR5DGOCNLWd/KEe+
	baQbnrRGWrVBFEurFGxgCMpMzVagO66B75ZU1/7W/v22C4lJnUXX9GmscKoXsVxV2kkoAL
	npIlDr8vfP6YU+9ujdyy8R118Q5F0eg=
Date: Fri, 17 Apr 2026 19:56:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] rust: sizes: add SZ_4G constant
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Tamir Duberstein <tamird@kernel.org>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
 <20260417-tyr-ioctls-deps-v1-1-41c6e9bb061c@linux.dev>
 <DHV3SQ191564.3FMK513OJUMKV@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Alvin Sun <alvin.sun@linux.dev>
In-Reply-To: <DHV3SQ191564.3FMK513OJUMKV@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C297040006
X-Stat-Signature: cge4hxs6fjoxupzhywdwdrso8rmgtmw5
X-Rspam-User: 
X-HE-Tag: 1776427024-644224
X-HE-Meta: U2FsdGVkX1+/6wVAKCRh4DB6vkAIrZ4JoRQD+KcoiUA8fyCFjVGvxkJfgjnJKOPZggVExJaadx76C+s3AMaps/gKef4TXOslmfbYD8aYi0+umAvW8LV5Icw41lbVukfdXAXzVlvvCo9wCNBif7ySHdx+7Y8nv85ue7zeUcHnnzHkIIwFfB6PKP6JIuGCUddYp2lISjGZll2y9S0dX2PlTUZM57S46fRyGD9HT5MDVK9lIQ2gZkacIMZ3t/mji33daBA9kJr88tENCaUNdzzJAmjnl3DL+9D1gc1DexHm7HAg7Z57GDwtVoh/ccfzAMj0AM6F8j3xG/5CNAy4+35/VtJWq3UM2MwFGjHe3TYezRCLeQ0Z3iaZYUwdqXWssU9lLvmRzkIFC2RyPvzHV6J8LEqHG+IaADRNwfhhfX9sJuzvNeRE/WWla/XEXAIvmTClAErO+YCuVdn783o8Lxzq05vUHJw8kj7vhRnxPrXXZbO7s/7L7qH+Uq2GJioIHdBPtJ1GFP1v0GTycPdcZ9R8tlU+nnKUPK5AUxjpoPdtv74wvKYrJY10AMbQ4qPHVoqbI6XfLjdfplODXFn8qWaZFT0i+g7/KpNBId5SQ1dt0oYs9mqM6qV2NIROOYSOMdi9mAu8cOHa5GY2TkuDRSyVEmcgz1uaSwt4vqerLzVkuCpKaCUNgghf5lVB1amOeNN/mKWQegz3nnj+cbsbGebS9nTqRiOeGPFtdYhZu6OR15V1uay0JeD+4lNctx+YqqHl1mSepQwGOiQUtbbfeUFHX88AXnvJnG2roBQRPX61ip7zBD7HlLvVEcO1LGeaGfpbx51BRJGrxuaObjLogJrYqGjhFzoDxnYodZn46p1XoKE9G+Uob0lBFIQwYmuUhgby//twapjij4Bizz9yUBSG6rcfDaaN8dc+yDrsWWYQOUZF+v/0tpqSFEJZNL6KvnKIWtwuvrUmQBlIQN6/a2C
 Uw3nItre
 At6tNgjSjs9aRpygqwprxWsnWvAwLpB91GDVW1t0rXEcw52wh9PkXl+2OdkpQ0njXHhIDmmEj41qnRklvVYnD5x2Vns/1Q+9jy7hSZF+McUIBumW0vRiqHjgQT9ct0phbu/Nra6artOnWU5kotzjXBGBXOKyzJM0OimURTHhsopI9ZXhx9ph8QUCuDE+w9684EPf3agYXB4oqnbfEaTJOWjnKgdlWnpszfKUU/03JVupBNe8ToEL2rTyiwctT2AWaUEmxpgRjAQDUg4DYx1fzYRNz//fJvl7ecpOyM/pCnoiIY0w6GAMkACsFSug+bDckZzTE5QnHVFDxLDDxJajHaefSQ+optg0KRceIeUKJH2T2f+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alexandre,

On 4/17/26 11:18, Alexandre Courbot wrote:
> Hi Alvin,
>
> On Fri Apr 17, 2026 at 10:05 AM JST, Alvin Sun wrote:
>> Add SZ_4G constant defined as SZ_2G * 2. This constant will be used by
>> the Tyr driver for calculating user and kernel VA layout.
>>
>> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
>> ---
>>   rust/kernel/sizes.rs | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/rust/kernel/sizes.rs b/rust/kernel/sizes.rs
>> index 661e680d93306..872f5bb181ecf 100644
>> --- a/rust/kernel/sizes.rs
>> +++ b/rust/kernel/sizes.rs
>> @@ -48,3 +48,5 @@
>>   pub const SZ_1G: usize = bindings::SZ_1G as usize;
>>   /// 0x80000000
>>   pub const SZ_2G: usize = bindings::SZ_2G as usize;
>> +/// 0x100000000
>> +pub const SZ_4G: usize = SZ_2G * 2;
> Note that the way size constants are defined has changed in `master` -
> you will probably want to update this patch accordingly.
I just noticed that my development baseline is based on the stable
repository.
>
> Also there is a `SZ_4G` define in `include/linux/sizes.h`; I am not sure
> why it is not in the bindings, but we should probably add it and get our
> value from that.
SZ_4G is a complex macro that internally uses the _AC macro, which bindgen
cannot handle by default. I found a similar issue that Miguel replied to in
October 2025 [1], where adding --clang-macro-fallback to bindgen can solve
this problem.

I tried adding this parameter to bindgen_parameters, but SZ_4G still
doesn't appear in bindings_generated.rs. However, when using
--clang-macro-fallback with just sizes.h alone, I can successfully generate
the bindings.
>
> Finally, maybe I missed something but the new value doesn't appear to be
> used by this series?
This patchset is a prerequisite for the Tyr ioctls patchset [2] that I'm
currently developing, which hasn't been submitted to the list yet.
[1]: 
https://lore.kernel.org/rust-for-linux/CANiq72m20pom+B9EmWO+91E8fjbMEob3JmvHRQ6UaXe_JmatfA@mail.gmail.com/
[2]: https://gitlab.freedesktop.org/panfrost/linux/-/merge_requests/64

