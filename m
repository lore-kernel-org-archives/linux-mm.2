Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADA34C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 20:11:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A97256B008A; Wed, 23 Sep 2026 16:11:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A46EF6B0093; Wed, 23 Sep 2026 16:11:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 936836B0095; Wed, 23 Sep 2026 16:11:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71B396B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:11:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9D7C12087E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:11:11 +0000 (UTC)
X-FDA: 85246121142.28.FCADD13
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3A555120005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:11:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yw5+NtEJ;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790194270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQ6P4xeVdcBAiBVRE89MWhC4zszYJGh5Z1KGP+DvBRk=;
	b=hqfHdya+iuEjQ39TjHbhz1XwSONzUHoKD7HHIn62k9RNH08kkdb2pPlJheQHh6HXs+Gg4I
	QKiJ4IxQ2+FCGB8b+LkDODIxjG85DTvO2sCxpnt7wgXxflbY2pj9cyD++Vr/1F4ZTwTBuE
	BJETu2RLG0EDkM7HfpdcppmRjEJ0m7E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790194270;
	b=ynietBM8t4I6Wfhd4kK6E5vsSKhI+guwmr9O+ETfLD5iDEv4u+BD5lW95FS5W4YNRHF4lX
	0hE/g/lVTgrtSFbqxTpuAzFs6BgIYynz5uPU5NbmRFPlVhodBUN3dLCS2T/aSYF1+TCoDN
	n2y9N2FOQ7w6NKWWVo7iIGLXSxFEWNk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yw5+NtEJ;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A6C35601DB;
	Wed, 23 Sep 2026 20:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86FA1F00893;
	Wed, 23 Sep 2026 20:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790194269;
	bh=AQ6P4xeVdcBAiBVRE89MWhC4zszYJGh5Z1KGP+DvBRk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Yw5+NtEJTNLNCvv+hbwDVwiVuJPMeqApEGdzW7qatcbtIvqAvnKJfO6oCr1CRSpAF
	 vcZXnXgEYcXqRbLrzCIRURwQMwiRzcXuJOBCPliZyBg8t8oHzhl63lmE671mwinw+O
	 MeyszWxBwm8bv4kRdG0VjES2IpcTq+pzO/uHNbOateVQwM+sh36w5MleQx5LPqSMqy
	 VMAzt/VstWMFQXAbSh0/6NIaBHxWCUnsMKC6y7G5OdWYfr6IrFP1B/t8U2oa07jPiW
	 m0EW+ff9/9aATXWjdzGqj+hVMSCIIE6HFgRuHA/3NpiKUuZe4D4hubZjukAZQ/NV8N
	 aW72c5KnUDhzg==
Message-ID: <9bbdcace-0769-4391-9c97-e18e8a0fd207@kernel.org>
Date: Wed, 23 Sep 2026 22:11:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: Remove slab_folio()
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
References: <20260923183655.3364885-1-willy@infradead.org>
 <arQqdeTaYf08TYl0@thinkstation>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <arQqdeTaYf08TYl0@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3A555120005
X-Stat-Signature: 1x1n659h8sxd94d6cp4o1ofr4biksjc7
X-Rspam-User: 
X-HE-Tag: 1790194270-327497
X-HE-Meta: U2FsdGVkX19USpNW8cnFOvYuNLINvG8+iX7zXObBngItibFMO4FRSbDtBTayruZR0yAEOira00QjiVoC92YPEzuUXEm4lcNx7/CHeynJlMjVYZaHxrJzVAzHuw/ibZQRPagz6LQgY0d5P62exGmzeQqnJiWkdbfNKhVbcNuhL6bk0wi0tiBeCO/QVgio/yAjGHAV3Xny5m95BnGRoNgcYgd7q3d5c0PHS3llNS2poMsiWgelrFUOZR1iw4AVqHijVOyU0ww4eYtVB8GfZ45jNgFmxT2SCnvEfkq8pBpoQZtL1qT2ujCKMen2CIjGaGRTjz8aORiFM9wGaX2lqdRflDXXi4EGHdCU4W3bumAqHvfD1IYhL3LFZGuXUnm6rHdbfpryuSb6L+b2uwl2LwxXLlM6OY+FbVDHBJ/iN4WpqP5DJiPQWdjzeDhZUYT0Wfk+98Wq9Uwyc0AmpGnsgQIzU/2Ob6Dj5MeuXs6NTc8uU7QkZMn9do/ni/NYw91IkSaUuQZuyUM4shJQEyf+qZtCrVtgs9QL51znzPe7JfwwPEvOmLtyegN4X8VJKQIJXxo/avRm9WNkows4yM354QIHcckWQAC0tL+r5ll8ZAB5KoK0n7SYLtuNEVwEpYaMxChZ1OQjz/KLK3ehJ8+4SG+8sxm19AC7YVtSdS1XsHWM0ix10GVz/KfyIXQmGUYwicXDYU0X84k/HH5lolTFvCgjjCTy6UqHNdg7dqD1iyzihvXSnOSiW8oStfOToZqvv1GwDZcU6kCVABGViEJNI5Ph9Y5VF5TVlAB0YTNDbwJqrM2+PVK+Gx+DHKWadQ7hEERON+BU9g817YdQgOqCo+WRpowyjc4mCGAkSgrVRe/Tp4l1GKBWjIC0S78EZ4IoXq0l+fba/1rnEgT9ehSxq/Uybu5XcC7kbjb3HyTik1njwVEeK0oM4Dy6xGmOWhXYC61eTTodEC/qc2s1rxxFhQr
 gmzc9Xvu
 cbRwevuudbA8Iv2Sk6FtK7VaVeIkYbWxCLhCqVQf8K0kOVjwjlOJ8Z4gu8x4LNHGo9NggNjqPPmHfNcPKqAvqCgyK1/rWTkWGLG7g7VDbHhECMa/jl3TBewHXitwOkGt6BRBmRVgdKy/BSo8mBEpDa/tOZ4YRDx/klSXzrpdTYKNgzNeKJ2KxcIko9X3bvSzAm3T1h2kiNz0xaMnWPIFshVNyudMr9XViDaROnglFqD/hILA5oSlDrRtFvpMqyayDYivslPpFE2wL8xkARZ3CMIslpcDrgSCLtSr4dtBYjVHWGuTaHyvZ8tWf/VBXtLHCw62PpZ5cXThMuscH5u3RraSoT6Kgt2qhAxtXBD5xSVRCZWGXqX3EYdEmqNPCWxNRTzc9oB+XABnNgnM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 21:45, Harry Yoo wrote:
> On Wed, Sep 23, 2026 at 07:36:51PM +0100, Matthew Wilcox (Oracle) wrote:
>> This is the final step of divorcing struct slab from struct folio.
>> It's still tied to struct page, but there are no more mentions of folios
>> in the slab code.
>> 
>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>> ---
> 
> Looks good to me,
> Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
> 
> With a tiny little nit:
> 
>> @@ -184,15 +169,16 @@ static inline struct slab *page_slab(const struct page *page)
>>   * slab_page - The first struct page allocated for a slab
>>   * @s: The slab.
>>   *
>> - * A convenience wrapper for converting slab to the first struct page of the
>> - * underlying folio, to communicate with code not yet converted to folio or
>> - * struct slab.
>> + * A convenience wrapper for returning the first page allocated to this slab.
>> + * to communicate with code not yet converted to struct slab.
>     * A convenience wrapper for returning the first "struct" page allocated to this
>     * "slab" to communicate with code not yet converted to struct slab.
>>   */
> 
> Perhaps you meant this?

Yeah, and I wonder about the "code not yet converted" part, and if there's
anything we can still convert right now. What I can see among slab_page() users:

- slab_order() - we could probably add order (aliasing page's order for now)
to struct slab right now and that would be future-proof

But:
- slab_address() - I guess can only be converted once slab is divorced from
page?
- __kasan_poison_slab - same as above?
- several VM_BUG_ON_PAGE() usages - same?
- validate_slab_ptr() - same?
__free_slab() - same, obviously



