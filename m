Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AFBACD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:02:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E3296B008A; Tue, 12 May 2026 04:02:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 692E16B0092; Tue, 12 May 2026 04:02:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581E56B0093; Tue, 12 May 2026 04:02:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 430216B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:02:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 108981A03BE
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:02:24 +0000 (UTC)
X-FDA: 84758025408.17.068B093
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	by imf23.hostedemail.com (Postfix) with ESMTP id 513CF140005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:02:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=txM1hkq3;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf23.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.58.211 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778572942; a=rsa-sha256;
	cv=none;
	b=6jQNhTZBDj0139WJImSmY5LztF279SL+7+tEX9bNroIURz+oQ0HW878Dl7Iyw2QjvmvG5c
	G3gbNvwLQW7SM8jbtq8hY/MNzEXY+i6+BMHh6LFgqUtjU/K6RemH1ZJVUzz4YfjQXz5cGW
	O321u+n3aUNIcuHGkW+h/OazR/aN78c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=txM1hkq3;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf23.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.58.211 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778572942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tI1r0mwk0o7G6xaiL3mOxJQ01p5jhRB3ZUeK6emnYJE=;
	b=yxMVUmCaALrIh7BDFJsRqwo1PrzPx7qYI64+PCH02H4z/mK7QRNl8x6Wlk0jMSw9Uyc+UJ
	vpsfulooNr0q6dnU9yXIbSbnhSMpU2GJIz4q8wfl6+PW0Wzsh08lw2WXhaTfQ5fZ57ZEQd
	GzehlMqwrs01dDsfQ0iOp+m7+aYdMF8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778572935; bh=tI1r0mwk0o7G6xaiL3mOxJQ01p5jhRB3ZUeK6emnYJE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=txM1hkq3iQo07sbYvSaTjXDac1LsMK2Is6/uSYCvEZGOHCQv3DTqLe38xCw4UqqLo
	 hIQFjT6tXRdfuaSF6UDQ+ioyxYrUf1qzPsSnEZgJzOTQtUhlTS0hMpPHVr1UaoVffl
	 JZ9ylPDm+dcNU5x56nGNOXzKV6S5gjbZ9KtIRQ3w=
Received: from [10.46.141.45] ([36.112.3.68])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 8C17A06; Tue, 12 May 2026 16:02:12 +0800
X-QQ-mid: xmsmtpt1778572932t62l8p1ed
Message-ID: <tencent_97B6CE6F79248F14DD48584071DD3C97290A@qq.com>
X-QQ-XMAILINFO: No7DFzN00JnRebaFL0JIYufn4HBmABsd5tv0m3aN5HXehIHsfO4GJcODnhgaW8
	 A+K0fcrKpa5YOW5APgeyhgcGpTFq8Pr5E7uleKtdzBFR5RWV4ihV3Hv/Zj62QgWVdzdoJMM779Va
	 6rPGzAzUl87GFwx4OLBFp1q2IJUtwLyUBnMl9i7FgsEXxuNN6MfP4J6qy1pGzBSQ4RfbXJVr+tKe
	 7KCGwErybID/Nnjv8qMBCwSwAk4bYQsdwIz5kHo3R7uRA9oUpvIDayFONHyDlwYKtgyDjXRMedWl
	 Q6IKDVgGUSsoBzXCXD0WpuioqUhmvW+a7E/DAhG5jvunbPia8Mj2Dnh1nFjZjP7rTPVPZbBk8qe0
	 Ybz4RNOjTOjPTAA+LKoXBZ6vpv2yTcx0ZJtm5S1UG131ffUcL1B4xKL4vB07STSU5hz/OxdYgC4T
	 OovPjjICMsuqe/HP7J9W0iLqB/nBIDdHccrnUvqjIxQu+rVoIq47O+9JeQ8+4P7P1JRi/0jLRb7C
	 9PTggqiBXdFHXmEk/tkC+Qqq7NY74aj7oGtIO4xe77MHdkfrEBOqL1RG2bLcPf1PrFyR58wl3OyR
	 sLufsMUTrseuvbWBs2uM0yTYj7rQ7BYPQJQPkmTgw0OrkxHaEJWij3uAGfp8GAQPygXdCz+Nqvp5
	 MJL4jJ9zIwGLuqsnEsMCPmATA4QTr+7CIDAeqdyFLfluv88An2RzkXgglAYj6NubkVDM1qtH1t++
	 E4Uf/7QZQcaayltoJ3efpcE69sTuNbaLhrxLlRQPDIqsVVVJdXr3sFYsR9kFQ/30j5Q9IC273ySY
	 Gl/Wh7T8DL9/ujp99PXBLhm9se342WuDkIgyeiLnMHlcSNYndWAT+KxacqNaSk15kefwY0TZEFep
	 U+rgr8ASWTS5s3Cmc+XcvVCtDUGC/eDa334xzowl6FMPKCtQYY4NGvKDfb07PRzVfZu6zBVE5OuK
	 I8cfLVYtptNbyN66qzULdaKk0CNSMOByucQq9zaSPFyqSQgIsPhcGkR01lta/jY4EHcATFcdrTbl
	 DrkOSuE/KJEtwHLW7QSdjk4p34CzYZHyEabdj4PlSrRbvTCYCo4K3inG+F190=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-OQ-MSGID: <a7a05e33-d10e-4991-8991-04597de38b3b@qq.com>
Date: Tue, 12 May 2026 16:02:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] mm: support zswap-backed anonymous large folio
 swapin
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chengming Zhou <chengming.zhou@linux.dev>, Baoquan He <bhe@redhat.com>,
 Lorenzo Stoakes <ljs@kernel.org>
References: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
 <agJT6D5zaUD6FpwQ@google.com>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <agJT6D5zaUD6FpwQ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 93rcekukapkgfz9mmp8395y9qqncu3q3
X-Rspam-User: 
X-Rspamd-Queue-Id: 513CF140005
X-Rspamd-Server: rspam07
X-HE-Tag: 1778572940-41647
X-HE-Meta: U2FsdGVkX18U6VHwIhkpgs/IxNckjSIXAPagTg1VwiD4aJngClm8VpAVS5tNdZDU4yUPke4SY7gVVvEVG6Anx+QBNYSMdPveIF1LJvRd9cvsqf4e0ipkXuOX59guSP+UADnV3Du+co9d9KJ94uKFVahY2lY3iSPCPgNj/bDrkdzltVRYLb1p2INTGe2ii+NBrOcXrqTFF623NiTZ7qQaW/gOfFwy3qHrI/v0qHc9gZpIy/c77Hy3VjBB+iqKaZurO6DNoEDAMo24godOVPdGc/qps7QDgMVbjecNr1GNvSzTee7dcmuf6TWOSLF1CY7g04qbyagQV1vQ97WMAl4fsW/gcR/0e1T5DcA4QDvOQnp2wEn/PTRYgSa2uIg21/6q5ukSFeICbECjqY/IvUM/zCSVnvMJtp+cbdAWorkCQZ2zMF2L+c7lue/IjxA+PzkYfZFTaneDeINia/l5P39kGeW7gEp41LykC1aiUJ+Nqzf1rK0K4D9sRW293u3J/LltzC+sRwtmBVzKFMGO1IJwGvBBDH2JrSz3kwxbSLYjAY/pdBdRFFOptQbYceN/2LqwJFn8pCaoFOfZTr0YVcJmigOSw/QHG566r03PkGaB24Z+DLwUDH8nmP6rDiZ0JN7LrcdmOwHPawDZTE+ERjHTDD/chEKSp5oubv4P4/T/6z4LDt77axcarAkagVSsk87yWSDbmSR0sB21rrgDb6hEsEMUzak2SWqjqQZlkfKqxsEzM8ROdmiFTTVxzmrLzEpuyjEMq7ItoP6i6/zDV6RGyyxogE2tDG0h49pBOhCY5KGvbipmZ1aBYYsmj2YFkkYt6ndnKIOCAL6+LySC74S8BtuDpFji96hq4tmjnJHQmBBYCOtMvpk1uuHbausTXIRW1GOYEDUNmCDoTfoETTQnXPnlNhsORkYwiVZ9IVfJXEUmwspChjzp/nlQXscBYsY/qCr+wamoaHeYfgT3H1J
 HZQHyqQX
 dXJtbixakRZ8z+fHOX3z7hq8Vy+nOoEQuCtFH043bBQ1vl5a91FAMUC1P4jupPCueF6+lqbBmGm8nZk/MUCTtdn/1djxFxtPfAQ0bHoBtMhsr8Lethb8VQvd3mksPuyyVjiceQ8J+TReSN2k32+8W6Bze6JOlwvlpMyDgsqky/I7RdOllCBJr+E5YBsZKt1/M09fJyXA22rcdHGr7TSylExQ49LtxDJMmxBMYDbUVpDV9nU2k9uZSSlFZdJaXRIiRgbH/+SHNd8IAmm0/5W3u7v1JYvb5fhR6kKZ8KUQpL86DO2TWpaZAbTRI5A3owslnB+3EpVcH4Xi76IsmUT5Zh59P4FPBPG+U5lmN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/12/2026 6:13 AM, Yosry Ahmed wrote:
>> Feedback would be especially helpful on:
>>
>> 1. whether it makes sense to support all-zswap large folio swapin first,
>>    while keeping mixed zswap/disk ranges on the order-0 fallback path
> 
> I think so, yes, but based on my read of the code this RFC only affects
> synchornous swapin, which is more-or-less zram+zswap. This is an
> uncommon setup outside of testing.
> 
>> 2. whether a follow-up for mixed zswap/disk large folio swapin would be
>>    useful after this RFC
> 
> That's a heavier lift and I think we should consider this in the
> longer-term, once the virtual swap work settles down. This is
> conceptually not a zswap thing, you can have parts of a folio on disk,
> in zswap, in the zeromap, etc. So it needs to be handled at a higher
> layer (virtual swap for example).
>
Thanks Yosry.

That makes sense. I agree that the mixed zswap/disk/zeromap case is not
really zswap-specific and should be handled at a higher layer, likely
after the virtual swap work settles.

Given the feedback on the swapin path structure and Alexandre's ongoing
work in this area, I will pause this RFC in its current form and follow
those series first.

Thanks


