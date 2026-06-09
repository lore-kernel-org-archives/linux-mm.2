Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C239BCD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E474F6B0005; Tue,  9 Jun 2026 06:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF8156B0088; Tue,  9 Jun 2026 06:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE71B6B008A; Tue,  9 Jun 2026 06:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B86E86B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:21:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 482801404D5
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:21:39 +0000 (UTC)
X-FDA: 84859982718.10.592A938
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 836B42000B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:21:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R12gHDtd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781000497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4Ph1widB3Uasbx8UfjADsWm4gH4OeEO4rKw81THVzo=;
	b=8m2XFowLYSanCxnjUVzt6ShzaVUdnssoqBC2alO7ycRR6x6yGbHamEYkY8FimJRobRmvvx
	+VPGU3cm5l2X3wiEEoUyjc7AnJ417cjc0Lz3tz40aUEYS/+y6ixCake5IXoLUjwXUkWJyg
	RkExVi0nBeXA2KyveWurHA9PA3j/ykA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R12gHDtd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781000497;
	b=jHS8DytJqWEHgiOv11/n0GRXP16UDal2q5ZfkNlaKRCGIHka7A/qSobacmK5I6Z3wn3HLq
	oKRpuHPjX1OtcujA8zqcBNCIWDex0vDrKTbB8McH8nzKfWRwvvdEexZergXLnnw523vw2S
	Vt1O19w3qPaYOX2I9BISFKeQpyGE6ik=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D67A60172;
	Tue,  9 Jun 2026 10:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78C91F00893;
	Tue,  9 Jun 2026 10:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781000496;
	bh=V4Ph1widB3Uasbx8UfjADsWm4gH4OeEO4rKw81THVzo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R12gHDtdlxbeRxELb6SDgKRtfj+fwZDLOVEpZbQePGw/nOQkWaIQmCuDI88nfJzjA
	 IvoPuBSlLHbh51k40ngxIIwP5OZdeneUpOoMHc67EXoAwGqsqgO91UO5zMToC3iRCx
	 os6a4JKHG09hrtwLjQ0sBr103Tb+FDBljP9trJsDylI8qBKsBcFpgEM06fPZIBnK+m
	 Z1PfibgbcUoBPJ2c2tVtio6byjaWZeRjA7L/5NWRom4Xuq/UjoamHHyhW6pc4NTJ7c
	 eoatT3argSs6R56MGCPFYQf8u6vroYxOzLuldNUHRCxSN9gkAHhdYYEA/zQ6JKI13W
	 vC3sEOjH4p1Kw==
Message-ID: <878faef6-bbd3-43ec-af82-6da675a5f8fe@kernel.org>
Date: Tue, 9 Jun 2026 12:21:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/9] dax: plumb hotplug online_type through dax
To: Gregory Price <gourry@gourry.net>, sashiko-reviews@lists.linux.dev
Cc: linux-mm@kvack.org
References: <20260605211911.2160954-7-gourry@gourry.net>
 <20260605213143.A18F01F00893@smtp.kernel.org>
 <aiNFezMarbvIZNa0@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aiNFezMarbvIZNa0@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 836B42000B
X-Stat-Signature: 179mtpqkr7ejxa3r36temxgi3ytkqy8e
X-HE-Tag: 1781000497-370840
X-HE-Meta: U2FsdGVkX1+HGnmtd0GjdE7t23+xKcsVvnJoSNbUkaGjbk8RNTaTxHWCvTLPBsSUAmNpN9Y9Wx6FLHE9CzOuMez7PaGM5axiWeh0CnZgpxrD6NJZ7T/21loRSBwrgqnd1rzaIkhU9gMQb69Vnc/lC9GMuKIBWwnzAXT5/Fvth5oyZ9aG6Sb3shPerim+DzhUiqE4AihZoy2SoUZTqUOf/cfBFyIGGq3CIRg7PlGveP1C1A6Zfvs+SL+FuqXmCt9doAoTIxQ+LbWjlaMrZzIwkgKWcNnCn2MOwL2tHsA0wqnNEct2hbbxWPlgmR5sW5ocnqPzqc8HC/s7vtuTKSRufyH/aBWxlqJFpaN21EE3XhaY7th9XgvhvmSPe/7qnQ/ynilk/sBsJm1hQGX8FNr2wofEOhmuj25Edpqr7GktbCSujhmABkjjdNy0XRSwcz0NEOgE/5od7H3JifLKq4TekLE23Jxyk0GMVfKVbd7Zy4mwfY2sZYjsOUDRonh6wJ5DOs6HDmwZ2H/nl4tGn9dT7bnYFPuZgsEX9/5FWhGDeRQID30lEECP9iGvNMUoDEgw0IF7vjTTVIYbw4QgsMCaaDkPs2KMnUMF2cDD9SuG7ntxrb0xxgF4jyItJunKWrxLwzz8xggR2lNCrnrAwQuASRqOqPteqgM10SkRUbaI+TGsP5JuXoHA1ADTloEAqu15w+h6w0QiZMpnV+kyRB1tfq2gRYKPMnvISEvmrIJyISV7TsxWp/OqLTFihzOuQIFmZYX1iAhFgtf1DHId31zp9A1DhD8kQODJFxgxEdU3YJ5aVQibEBZl/YY1WSuBKoo/x5Y/7o5TFTQfOz07tK6ej02ODVCAf1JRkKkqiiF5rBvVP/4FxSJJpdbozIoldDG8HRHXriNo79H4fQNvGjubYWXfKj1azbvPhrPT0Mr4LOMJCKxZmaD0K0qC5rI5bo2Lvkxqtmijqo0PlXivvh7
 QiFqN7mv
 GXLwtzFf/K6uOsf/Oqff6A9eZ/OsnvVrPliIUxBoFz23Mw7P8uU0P9qIXNwYL9uILHyFU79YHE+R7Kbuu/78XScCrODvSXH7cOdWz7seDxW+xoBq7gQCTDBVjnSFj+0THu6KtJMocTadYQNNXF2LJ5JaUimCfg6vFSVn6fsp9Cgy6HPDDYILNKYTbijFC2Bv0IO+gi/nJYcgDBVMi7+08aB8oxsyL7GNlZ59Yhx7VtAm3Ye1Apcj4mYoJRGCTxhfWDKXKkoFUi3LtKMzhHZHun9U7M8W1SSPaGKaX+8ubuDQMjEukECwCJuNTkxSBRQPNKrzUVrtz2n5bFv9nFFkoveOLNlDWmXhPLyRvDzdw0WzO7q2Nrr+wmW/ztDD4YT2wA6VF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/5/26 23:54, Gregory Price wrote:
> On Fri, Jun 05, 2026 at 09:31:43PM +0000, sashiko-bot@kernel.org wrote:
>>
>>> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
>>> index 592171ec10f49..41ccb618a1464 100644
>>> --- a/drivers/dax/kmem.c
>>> +++ b/drivers/dax/kmem.c
>>> @@ -172,8 +172,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>>>  		 * Ensure that future kexec'd kernels will not treat
>>>  		 * this as RAM automatically.
>>>  		 */
>>> -		rc = add_memory_driver_managed(data->mgid, range.start,
>>> -				range_len(&range), kmem_name, mhp_flags);
>>> +		rc = __add_memory_driver_managed(data->mgid, range.start,
>>> +				range_len(&range), kmem_name, mhp_flags,
>>> +				dev_dax->online_type);
>>
>> [Severity: High]
>> Does capturing the auto-online policy at device creation time break dynamic
>> sysfs policy changes?
>>
> 
> @David - we talked about this ~6+ mo ago at this point, i originally
> proposed something like MMOP_SYSTEM_DEFAULT
> 
> https://lore.kernel.org/linux-mm/20260114085201.3222597-3-gourry@gourry.net/
> 
> https://lore.kernel.org/linux-mm/c4ed9675-269c-4764-86d5-87f4f83fc74d@kernel.org/
> 
> '''
>    I don't like having fake options as part of this interface.
> 
>    Why can't we let selected users use mhp_get_default_online_type() 
>    instead? Like add_memory_resource(). We can export that function.
> '''
> 
> I guess the argument here is that the value can't be cached?
> 
> But we can't really enforce that.
> 
> This is a behavioral change we have to agree on (either we change it or
> carry something like MMOP_SYSTEM_DEFAULT for this).

I don't think we'd need a generic MMOP_* for that purpose (the core cannot
really do a lot with that AFAIKS, and the scenario "unspecified" doesn't really
occur in memory hotplug core).

I guess you could have some indication whether the user already configured it
manually (bool online_type_specified), and handle that in the handful of places.

if (dev_dax->online_type_specified)
	online_type = dev_dax->online_type;
else
	online_type = mhp_get_default_online_type();

Of course, you could also just call the old interface when adding without a
preference.

A negative online_type could also be used as "unspecified" in your code (MMOP_
starts at 0).

But the question really is which semantics we would want? is that exposed to
user-space somehow, such that the user could query it ("default")? or how does
this get set, and how does it later get used while it could have changed
system-wide?

-- 
Cheers,

David

