Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96B85C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 15:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C59BC6B00D6; Mon,  5 Jan 2026 10:06:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C31586B0153; Mon,  5 Jan 2026 10:06:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B05E26B0154; Mon,  5 Jan 2026 10:06:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9B46B00D6
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:06:46 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2814C1401AB
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:06:46 +0000 (UTC)
X-FDA: 84298237212.16.D69A21D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 35C5280006
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:06:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fZWtkTAM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767625604; a=rsa-sha256;
	cv=none;
	b=cdjkcxn2xCY8cYV9q0zPGx3sQix3khg/kJGNJAatrJ1SXcO2WivgxMXEvgbUelS+J3CV5Q
	85XFtnbPgm3P7QSRABO2b5i83+P9nrKVDcZzH7cF97IPWh5003cIYuGPtQq1AhTNgO3Aby
	oRFiDYOOEHctfmAAcLb6UK3AACU/nag=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fZWtkTAM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767625604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbfGwul+cexXY5H5Xt3IBA+ZGamwHltt6W4IGFP+ZBk=;
	b=G3jZyf6ErDAihyRpHHBTkC3OsxLKjueTtoG3f1PHwbRQRrnpXcVN1Ht345sdW8cW4COGWh
	fnxX5OSdnkyD+TNPwGT5dYBaYMVaMfzms2rpsiYxc6duHO+/YImqkzJqwna4ow1g1+b5ge
	IWZmcQo7SO2MSoL9zhxY7QWNyNkUcws=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0186A43994;
	Mon,  5 Jan 2026 15:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546C0C116D0;
	Mon,  5 Jan 2026 15:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767625602;
	bh=fx8ZhQ/yGoZ5PjsxBzkEPzA8LpXMhXOLgH4Ybr9g5bQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fZWtkTAMhJu3YNah+zkNQDcOVJbRI2oDb5gMqdaW8o09xX1g8lPo4TNhjuCjF3kCn
	 n2Gyv7L3opBycDL6N3T9PYZbMQ+IJgoVc+eIXVrSdWr64MwQOmRs6yGqxxUj6gxm0V
	 joayYh1rE6tQFjzd7otqOZWkoET0kiTxKL9/ROnEEGtVUx9FTwPktQl6YHKiIUh+xd
	 K8bv1SOxUjnjHe3yYtVpgvgfxJXCDY4pWT/F+6PjmEew6bLTDLP4UdU4qqJEcSoryR
	 32D5gGUYdqpliv0uLwuMGh8GsdtsbwTbxKoOb+MxwEFej1Llox4d9X4I+pxLfLz7VH
	 d743iimiAEAPQ==
Message-ID: <7014fb92-0d46-4c64-b3ae-0eb9d6b81878@kernel.org>
Date: Mon, 5 Jan 2026 16:06:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] tools/testing/vma/vma_internal.h: provide
 fatal_signal_pending
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>, amd-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <45dd9b02-7867-6e5a-4a64-02c4d43c9b68@redhat.com>
 <18f7f4ff-67f8-4a39-b6c4-893bfbed4955@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <18f7f4ff-67f8-4a39-b6c4-893bfbed4955@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 35C5280006
X-Stat-Signature: 6rmwosapor4owstdh4hzpqoefxbt89bm
X-HE-Tag: 1767625604-992330
X-HE-Meta: U2FsdGVkX19hvJgpI6NdQT/F5ohk4PxMkITGurmwqDWw9zCWV7e+1OjnP4hp/CsNH6hWntfKz9fSrqcHMs3Px7rb8XRiEnPjBr/mo5Tzz2faBAfZbljS/8JIr5yjjyiV2R/EuS3nWsXm+tvVAkZawXV+dyvimnmOtRlYt5zDOzOiagj38O/lA75KCe+3RJIk0XnwXS9jVIC0vHwh04qCzqRW1HlQkCpFyTl7hQd8GClx+YHdYTHaX95FJRjuKcmfAdmJKSu+Q9RdzeXEhkV6qjJEfbH6j16VnOWGuF2tnazdn6MwtCACBBNCejlL9rUoT9ImShqqEVczzxrGOf43EAbkvJRMm19Ft6TfKtKOUsfrJNTFxIqIvXFMRMMEUgPrJY+sS5J1N1KNYufLhI6CGuoRcez8Kc107izGP5FgDxtLjrQ/M/HnuUuqCJhmp/xkkGb344q/fjwFV1S8zamSSM37nBMBELOx/YYUl2IFqBEgrgLQDl0hFzwZiGls2mPsbaW1PblWBaMqFXrK/8K9S+qJt2HQDNXIXGGtaq2k9Cv7nTozyCWGUZ9OVonGcfyw5EMHC8988SjZrlqx9G8kdrtlyGpMWZ8UXrGm82RSSeGbfyg9ddsTaiUpsxOS3AqwsIy29mMePxUUJaeosWlC729EXtNxtgkkZ0rGB1qsPLOHNN9a0jnfGxF+oqcX2pdGmMHM2ks0SrwtNKZMwk5d3paNSxYXFSDrVpHkilmEHP7jYlh+JGntc0AhGKxIILVlu5wpbBQbeamzjk9Bk/mryWqrQGp4vgLwmNJRnWR5I+2/yw5eI97e6hQ2cW7WiPEng4RaP4eA8LjsVV/i9+W2Kd9zjXOQ8vZV/ogpEpWCslDWBkOHcqTBQXA3BPFBvZzHhd7FxH9JQEmhvAp0w6iFEZgQOwxvJsGJZKkpjJfTeC/BZYg9K9IbgiItNNSOLfwe6jaQfHKJFrIe7ihF5Yy
 2dT1JjAU
 d7U48N/4rj9ytPxzf5zJrHN7REkyqdflJNG4LJ1nUOmS+WGX1oK6EzNPrLkKueNH/YVxxBDoZ+BMaL6DC9AfS+ufrYwY0PyPQTEZGZERELRZ0lFPj2NIEz6NOJSbOx44O+Hg/tduHL+wM4jpzSDKXt/rZmec7GPNVkI4eP2Hdb15W1I0onUlzMdHP1j617MFPja1LmkjhNCUN2ZXzygN82qTMtjsCqX2iGDn9JtPDjtKiH5ijgMjqxHrj9nbCEjBRnXqF0S2Z88VLBMldXzh244yZEvtfVlPdSh/n/YaEpXdrb2Uo+x5Hne51XdqAILcuCqluGe5kzC2FUoZjxi5cbWf9xDPVA9dCLVV5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/5/26 13:18, Lorenzo Stoakes wrote:
> On Sun, Jan 04, 2026 at 10:15:36PM +0100, Mikulas Patocka wrote:
>> Provide a dummy function fatal_signal_pending, because it will be used in
>> the following patch in the function mm_take_all_locks.
>>
>> This commit avoids a test failure when the following patch will be apllied.
>>
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>> Cc: stable@vger.kernel.org
> 
> No, please don't cc stable. Also don't cc stable without a Fixes tag.
> 
> This isn't backportable given you now need to backport to 5.10, 5.15, 6.1, 6.6,
> 6.12, 6.17.
> 
> I'm not sure how Andrew deals with a mix of Cc: stable and not-cc-stable patches
> in a series, think he generally doesn't like, but I'm not sure how exactly we
> are supposed to express order here otherwise. Andrew?

Can't we just have this hunk here as part of patch #2?

Backporting should be rather simple, just drop the hunk on kernels where 
it doesn't apply. Sure, a bit of manual work, but better than making our 
life more complicated here.

But maybe I am missing something.

-- 
Cheers

David

