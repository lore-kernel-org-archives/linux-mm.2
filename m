Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED506EFCE37
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 19:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 349446B0005; Wed,  4 Mar 2026 14:20:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F7416B0088; Wed,  4 Mar 2026 14:20:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D87E6B0089; Wed,  4 Mar 2026 14:20:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B15F6B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:20:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A0E2B1A066A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 19:20:45 +0000 (UTC)
X-FDA: 84509347650.18.9F1B913
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id DD8AC20013
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 19:20:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gl5jUuUj;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772652043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCVcUnxINteFmLWKvYSmT5cJR9OP3xS6KDkDKQXCKJQ=;
	b=auYoC/BD4yxVmxbxHnP58Nk7zV2iIX/IG0/jdnzH4o4jt5irjzsdck8DXqpnNUshkqddNR
	eRIUC1J+BGPP3ez982qKFOKnQ3vq9Eh82c2KpAzvgX41J9+goLNOXJp7slPpd405pl9zfy
	rbeYFSV47mHuXz/NVa1oRBhT3+5kP2s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gl5jUuUj;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772652043; a=rsa-sha256;
	cv=none;
	b=R3+S7Dmc49/QJY4fAqG1S/JmV1VCPNkyeTPPMR7beLPiUYAYOFg3PY8t/cBYvz7w9KSPi5
	9c9axZbiJNW0tdOUqsgVjmvdDLx5qGpnFb99qoPQTvdhGWgk8kGteMLTwVabV3cuvOG8Yk
	qmtgOK/EK0mQR8R2SwlwVTw7FnJttyo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CAEC600AE;
	Wed,  4 Mar 2026 19:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D89C4CEF7;
	Wed,  4 Mar 2026 19:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772652042;
	bh=p/aQzVBNQUFkq8yp1+UHSrMnCHVB5fOZ2fi9Yum0+RA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Gl5jUuUjHwEGrHWZYD3Q0KT2Fc4G5Ll66HMjR10aMlXKF7y+R2G/693pSAQ7mvd+q
	 z4jRGCXA4LVvggiZJADrQbPsud/SpCIWCrCSBNBTAoWVtwVmVFUwzC/LHZkkrLrvln
	 0rGZrE5jK1I7Y7IGcD+3Scsa2i6b25Okkfnq49NvNTDzprKWjKJ/70lEvADFvADxc+
	 Cnk2UtrBVtxffbZi4UvK5FBT9E85fjIauIWrGIMe2/CF4ABmPCSizBDNiiQKWsOK7C
	 PuSmXGp+7A8oUMIdCrhY7eMA7wmM82jK7wN4gOoFXw78z7XKE652w8jZkK47gN3Fa/
	 +ijOnEhPHzEhA==
Message-ID: <f03ac28b-a2f8-4182-9f11-bafd6309cee0@kernel.org>
Date: Wed, 4 Mar 2026 20:20:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] smaps: Report PMD page size for pure PMD mappings
To: Vlastimil Babka <vbabka@suse.com>, Andi Kleen <ak@linux.intel.com>,
 linux-mm@kvack.org
Cc: akpm@linux-foundation.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20260303201556.107960-1-ak@linux.intel.com>
 <101ac423-252d-4ef8-a07c-34f5d59820f5@suse.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <101ac423-252d-4ef8-a07c-34f5d59820f5@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DD8AC20013
X-Stat-Signature: d7uqcqmcu4ycsawrx66fmwe17bx4mdgn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772652043-963060
X-HE-Meta: U2FsdGVkX19p7zLhBtMhpPS9/pQiCze8h7VWv8vtW3Fh7Sfsq8x4la4ppvKRc06USKP28l5F/xLhgvni0GbpJY8yY5T3ApHr6bA/vc7xTLqvufQwdMSCT8foAv7s27Hb5794YrR+23/IrnDkBpaQ5aIq/L3Dh+CDCmP8u34cSq1316D5rjmsZslZq3LruKLPzfxBHYArUZRrlZbNtgI+9RHe3Pi+XR4O7sKbm4dcRfwwLYdtErhI5J9eqCI6+9XKmB6Ev1azItItZ0otU88MwLiCJcdUqUbzHFq6DmFQhkjdEsbfN404L2hwoPhSaZDEweil0oqHAoBBoVmNm85cXJT6O+YE8FiU0K9FhNS6obex8U7uimvQxab+bdHSua9IVe7zf8Bcf/do+OUp1dbURGNWmkEuq/6N7u4zk/zSk2YRFWNWJDPHoJcErpR1DlhYhx4ieLx4LCyoHMSEuPNpFhuSSAQtzg+87n6zrxSu5bx1eoO346WkMbw2wihUf2bxaesGqoNH6/Tfbzl7CAf/Mcjkn9GfyJDrKaXA2mYpKSnlUabnHAR05cnuJTi4q0kDALwLcs5QdxiLCWCB3/nJ5QGacNDpMMjF9fA8JJy36Rc9o0odHrchfF59CVc45+mERN8WicyWEEuprECGvZ/9jSjpN7IiL65W/VIhKESznZ6UBuCoTqU+zdac5zc8nhDHDhT8IvhXjt/fzGZIv4RGo2OeEwxZvVSb4P3joFPbwKM/bTNQJsNvVmjNCHdv4YuEBSaq/uVevKpe2fSkDme9vN+bz477/GVROr2FaVSnHk0qx85CGJ4sG1QVWFGtJB7X5QcTLiYVLb0QeiUb8fyz7R02IX28m5m9JhAOlQkQo3L9Lj58aXpvrON501ry+lWlFQIJxnsn6QehADxNPVpqL1HaxF8hppoEt4qxrElVezYeqVwiMNhVNuxJ/mgMnVNSuTelmaXtJ0jn+P6mJHK
 Lj439yk7
 2BFmUtfVb0bb6GfpP+oS+wWi3GM9ryNDH7xViZXTq5JMg8IePbCEdrNYfxB8Ru2u2JS7wBuv72t2ykxi1Fz63Mb+6msqclrOpm00BKWpsauUYtAWeVYcei5eWIYDziOHTxIFa8q2ZolD8AP505vLarPpfAwoUTSH3id1QxUiMoyfA1QT26o5kOxa1UGlUiwWY8wE/w9OBdPxHQDcutCIX7da1XYkb57JTcE7FdxtsRWD+sAqC2V4LGtPBo3n1hm4rIqbPD9+Ku2KefzOITxw0xiWSzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/4/26 18:29, Vlastimil Babka wrote:
> Why do you keep not CCing people from v1/v2 discussions? David said that
> already on v2. It seems rather rude to me.
> 
> On 3/3/26 9:15 PM, Andi Kleen wrote:
>> When a smaps mapping is only PMD mappings report the
>> PMD page size for MMUPageSize instead of the base page size.
>>
>> This is a revised version of an earlier patch that tried
>> to report multiple page sizes, but there were many objections
>> mainly centered around compatibility for mixed page size
>> reporting. This patch side steps all of this by
>> only handling the non mixed case in the simplest possible way.
>> It also avoids a problem introduced with v2 that page sizes
>> for mappings with no pages were incorrectly reported.
>>
>> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> Will this be useful in practice or just confusing? There can be e.g.
> misaligned mappings, or other reasons why there won't be 100% THP
> coverage. This all or nothing value (IIUC) seems inferior to the
> counters we have that say how much is pmd mapped, so I'm not really sure
> it's worth changing this.

My opinion on this remains unchanged.

Not CCing me once more is questionable and makes me want to recommend
Andi to work on different parts of the kernel.

I sent a doc update to clarify this. Won't make everybody happy, but we
can't turn back time.

-- 
Cheers,

David

