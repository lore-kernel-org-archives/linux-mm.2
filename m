Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6051C606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 12:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=AA317Jo+
Received: by kanga.kvack.org (Postfix)
	id 0A2506B00EF; Sat, 14 Nov 2026 07:38:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052656B05B0; Sat, 14 Nov 2026 07:38:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB756B05B1; Sat, 14 Nov 2026 07:38:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC4B76B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:38:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 594B7803C4
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:38:04 +0000 (UTC)
X-FDA: 85433676888.21.127E409
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2399714000B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:38:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AA317Jo+;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794659882;
	b=ViA3JuGX5USuV+NXU+yjSm2wDVdM0DZwq4eXrTdZCMkd4QJMRNKTsj24ECJmYZTaoNBOM8
	UJDYZPeSvgWArhcosqgaP3+hivXT1SMTFi2GWQbXlJbwiRStfXxeWpissiP5J4AWn0ZwDa
	t39tCEVk5eqUwygCxR7d9111Z3dknhk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794659882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UzVGxU4MW62VeR80v0cSXY3TrPWVP7dGkSQALMLtfec=;
	b=C95BsFlsgqvgGXI3u4cxNoaTHAIO3pEOLFGGYpqfy3+KwQi2HZlUfLsubAxBJdLbTopls3
	e2f/FTFIv4+gcKAq3/SoiaCuQCzHDYoA1Rniw1J+hupASCj5CDYS6kqhVZQgkIBjfg9MiU
	DdzQMQyvWsRbT8pCGYX3/m9sqHV+RyI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AA317Jo+;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C73201516;
	Sat, 14 Nov 2026 04:37:57 -0800 (PST)
Received: from [10.163.159.227] (unknown [10.163.159.227])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB0F73F632;
	Sat, 14 Nov 2026 04:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794659880; bh=VZwlqyk/0X7EMW4/W5ZH00FGZKTMqa/W1AB43sYEXDk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AA317Jo+BG0PVX+zpc3wReQawZ4z6+3EkeKUwuHZSpCwd8RnNYmuGr3KGZtt8ziaC
	 evp3GfOCJj2imiJeW2gD2EeRZuvZgeXcUK2tyqPEH9U0ISg5xcknH4RHwfPaksLdBZ
	 6F4ajfnCZ/zsi51R7YBArbkNHQ0vHUXnXDSGXCyQ=
Message-ID: <09e19be5-933c-4921-9d68-ae22f5a27e75@arm.com>
Date: Sat, 14 Nov 2026 18:07:46 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] MAINTAINERS: remove my reviewerships, add CREDITS
 entry for THP
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>,
 Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot
 <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Cc: "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Uladzislau Rezki <urezki@gmail.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org
References: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2399714000B
X-Rspamd-Server: rspam12
X-Stat-Signature: fqog87ba41ek9c7pxynrpthrasgmtuuu
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794659882-855136
X-HE-Meta: U2FsdGVkX187pvmxd5j9dclj6s/tXMljUCBvmb5l2tvigq2ceFwsrWOep9yRaS/bsRqj/CodFZ10jxTQSHCK5wG2feYtgT2Gzwqpa6uUCofFCsi9BSljBxDLemXDYcUwaUbl82oqI/TXsEIhTXSVGvrXAiSGjpydzx3ISsQW9T+r5qRVjVYDj3iX9dVL9H0bj5OW9N5kA7NOZyBRBzm5UZRFEaYPGp9mPiNsj+/zixd1DB4t/R6n1wl0M7sgLCqDVBsn87Z5YJqAkoZex66DgBYNnJ3hYhj3klX//ZG86uz/+zcsu/TwefjMnQM2IHOOBm1cUIzJv9qq3J5kB7TS2Pu47UzCXl5u4MzHU7YU23t/hsniQQQE73PeZIBramJsy53lNXEOn9Z+BuNWppEwBEK7aBqJlXDrg22ivp+1H5f9XSYXb2PKZIS1aeKYK067uh2l62Y8hdxdX9lMZT1G94xWkG884mTLEzss5AIKeyLrfXNdneLta8r61Q6g+nyNNsMGBJ9OlRgXGn0weK5UERCGevbsP736Ju0uqIKncPchDbdNT6pKOpdLPebslagtTB9+Q7207B1LLvqzRbA40qZMuPhsDNuxmM4HJ+9oeSI7mCQSUoT2RPbq7HEgeeOesVMw3kfaROgHVsDvxrYjq8onXjwsjsjcKtFxmAorlJ9RUzbvJGMXvRdhHIwHLs20ZKuKHKw3b61CCQH7KmpQ4nP7QpGV9lyWrht47DwGTseqGMq6gTxKI5B6VMY2fG69yoDHv/bc1sMXgkoqet/ILAIfYs6i81A+0+wZMEu8m7t272yn8lCoUpirH0zyoISauEo5oA3EqKDJiI5XAR/Ezyc/b7hjKBXRFzzIJAaPpo8/UnyPg4wVOy0YSyPPg996CCtwf+z7TQ2y+MYUs80XAPsVPs4OaJWa0HA/qhtjK00o721cXdh2GuDl38jQjUI/riydXWUSXI0faST92HY
 YXUuX7F+
 ZrYqEhMyYF4A0YASLs85zFZ9X/4T49CkMBJnT4RAO9Otdlv+H7a1o5vhxKmvC19WN6a04OrS1XaEVU2hdyda5yFKC+C5IatbSchRp7/RD8HAAAnxYUbkJqnkrV6ZIjAAi9B/UhS7YGiItoFIqDjrHqX++n6YxwYUF9xyN/Mog2LeFoBxbrfZapTZUsS84zTux1rrjZkZLmY+03ojkjn0vAoS3BDnZkhJtZHxRmVXjQ3Tosda4coseafFM8miBL6weWWSdlT0YaWREQiK2+nemeZP9XPNlT3ob/zkUom0zArnpMbx/mVi8daaZ/2BO5n9Cw+6caIcTGBGlb9+Z6rO5IAhgGSugy6tZ/7UR2pjTlkWwbvk6p0G+CfsPTFszm+nQK9cRWXA6zabk0CFMK8IwRpYoedtU3Epr7m+s1/xYqEOh+UiFq8x6Vw11j74c1mX1zVTvqDV7dOKHyAZdlK3Fa45lCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/11/26 5:33 pm, Lorenzo Stoakes (ARM) wrote:
> Given the current throughput in the kernel resulting from AI-generated
> series, I unfortunately lack the bandwidth to generally be able to offer
> review except in those areas I maintain.
> 
> I have separated the patches into areas maintained by David, Andrew, and
> Alice + Danilo, so each can take the patches relevant to the subsystems,
> for convenience.
> 
> Apologies for doing this, but given the current trends I'd like to do
> something to make my inbox a little more manageable :)

Yeah even when I know I am going to simply ignore a patchset, it is
frustrating to see it in my inbox nonetheless.


> 
> Also add a CREDITS entry for THP, as, since Zi's rightful and well-earned
> appointment as co-maintainer there, I have no fear of needing to step in
> there, and so would like to record my time in that role.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: Dev Jain <dev.jain@arm.com>


> Lorenzo Stoakes (ARM) (4):
>       MAINTAINERS: Remove myself from MM core reviewership
>       MAINTAINERS: Remove myself from MM misc, reclaim reviewership
>       MAINTAINERS: Remove myself from MM rust reviewerships
>       CREDITS: add entry for THP maintenance
> 
>  CREDITS     | 6 ++++++
>  MAINTAINERS | 5 -----
>  2 files changed, 6 insertions(+), 5 deletions(-)
> ---
> base-commit: b3dfbde62cf1981c4638939c159dfd087b7a72e9
> change-id: 20261110-drop-reviewerships-264c745b11b5
> 
> Cheers,


