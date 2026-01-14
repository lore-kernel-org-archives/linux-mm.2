Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 960C4D38FF2
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69B46B008C; Wed, 14 Jan 2026 12:30:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E183E6B0093; Wed, 14 Jan 2026 12:30:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1A2E6B0096; Wed, 14 Jan 2026 12:30:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C02E66B008C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:30:33 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75FFDBA235
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:30:33 +0000 (UTC)
X-FDA: 84331258746.19.F101B99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id BE0B6C0015
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:30:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XM81uToJ;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768411831; a=rsa-sha256;
	cv=none;
	b=u5D+TnfsGduu/1QNinII3SWqD9pB4eBYc5CJyRA/+3aDBPqhWrZFq9fc2mQBRmlso3ppVe
	Jp/vCHqiYyLAYG8uB0zLDNK8qjYQH3T6RQf1MzsnsSi8FRo2iAKi1rCw6n6JDpxiZ43Vlz
	iZa8Jxu5PuvPaYzjQ/P+7iMoRwP02FQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XM81uToJ;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768411831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zOHLChz2LwrbaZTPyfem0BlhRzOqzHmBPgYZf9Hqr9Q=;
	b=MGvi1Zx/KgFYjcXQP3fL3YycBld7Xp+/DPdAEQXaiej4KmweygE4cRwjDYjxEVBAlVv3W9
	wJCtQfSamwjSB0inD8r+5KV9tN7N55I1bnw1d/BzLzJctpNfm0gtVwrjhrz4jjlo6JJFVO
	8BVWYtnxFBgTrotiusil0zJ1qA/31kM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0064C60052;
	Wed, 14 Jan 2026 17:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DC8C4CEF7;
	Wed, 14 Jan 2026 17:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768411830;
	bh=hwNrqKA8AlHPcVAA3NPkwsp4ijTzIp4nlEDnDkoEX8M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XM81uToJyiYMw/1XFamfWLJfbjbhZq4H+WDl1MDE4XJ/V6c7SW8xH8G1t38NSD3I4
	 DDTX+mdio9NVjVitwYe+jDKUEgRKwU6oGzlGHIxpZ7GVPVZ9LDpWLi9vY3N4RgHjXD
	 Il0TXIbcrRpESIc7ozCshMH+IbH52UibSOsnUVrbRYrK+vyrcjQind9V7GHTCB8vAW
	 WtLU/9wbAm+9Dqg9Y1U3u3Q+pGy9gv+nsvKIUvRN0M0zkr0PcZzA3MuxG6YhDOIekV
	 8r8LdsupZ3UWycZ7Rxjz8GiLwg3gpJrSe3fjeMJJeh7n/KVktkp06CcST6d7eRWkHD
	 CCO5b62lO+g/A==
Message-ID: <f239e391-ac7c-4d26-ab82-4024a77ec3d3@kernel.org>
Date: Wed, 14 Jan 2026 18:30:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/4] iommu: debug-pagealloc: Track IOMMU pages
To: Jason Gunthorpe <jgg@ziepe.ca>, Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org, will@kernel.org,
 robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, xiaqinxin@huawei.com, baolu.lu@linux.intel.com,
 rdunlap@infradead.org, Samiullah Khawaja <skhawaja@google.com>
References: <20260109195111.GQ545276@ziepe.ca>
 <CAFgf54r_au6isA10Nrve=MHL455X=tKhNsSwH1ej-TX08J3xLA@mail.gmail.com>
 <20260112133256.GB745888@ziepe.ca>
 <CAFgf54psxPrsvujStPNtrzxiKOsJF+aVrN7BcNxxmAF4wDmRXA@mail.gmail.com>
 <20260112135208.GD745888@ziepe.ca>
 <CAFgf54q+9Y5TtGJDB=8q_BW-0F=TM7zBbCcMzvtvr_N2WMnd-w@mail.gmail.com>
 <746f5adb-1d91-4ca2-8ae0-a2d171203b66@kernel.org>
 <CAFgf54pbkfdFr6biE8BiNKBnTBFWxXGmvxsZ0E+C1C44c9AW_g@mail.gmail.com>
 <482f2f36-e906-492a-a80c-987bf7359d83@kernel.org>
 <CAFgf54ovfnTHmMuZGk73SEEKsP3k-_exR1wqUE4W9tLYKv_iDw@mail.gmail.com>
 <20260113150828.GP745888@ziepe.ca>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260113150828.GP745888@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BE0B6C0015
X-Stat-Signature: qdsz6wd1c6sfao3geumjbbsxtyxbi75i
X-Rspam-User: 
X-HE-Tag: 1768411831-912677
X-HE-Meta: U2FsdGVkX1+hD/ZZHifnrtQ4N2BuhEo+l10GsrAfjE22kVBGpTTj2RDV8i2tPL3RaMkA46hyjlK4V6nzDRuRNwA8qORG+X7YuldWGUMP+imIEBOHNavfOteJUpposorWuNmq0R3364bhE4r2Oopwz7/FDg5izFwOXwFiS98/ntQsVKs23UPyVrUViPJEgl8arD71T6GNJjlpc12jpNqXneGuMSU3/RTAltsqnYU7TFyNInC5IHxknce1kWIvp/wlBbrvP+ew4q6GS6f+7ZXAKUFEU7odfMbKi6y4fuicMEAcEKb4zihUn8t4Y7WHZ1GSs+zWoqklV20CcW+NNpNw4/CXveCsmGIPpA3wpzA5VJ57LBs25U0e+GdpO85qIb+xG1wMr9PasWarcPzd/PncUTmV9FWEAWjP3wiYlGcEXW0sn+2cz14UC54t/W1Zv3ROksuvwhLFOpapbeXEK6lZSClpDORwRTJtsmZaTDttACJyyGJRDFVNNvNPGnH0t05qYVPxZKYHo9YUBynkURRE4dVdfQrdZZcfc5Z5x2iQZBDIo90hVInhEQAj/JTvjGer5Ca0YElBavmv8ZUBd6vX6mocitqrU5puGAfadvGl4RTSsS2QkdOzbQa6iOaVPzs2T6f/VJl+Dd5Vzpqo5GWACj3yvX0clES/6UNUJR9KWtHIE432armgZDxvFslXqXK8Un89Ef/C1a3bNxEtEHAe95/xcu2cgI4i4ZtNcN8AghVPL9Z22jxD65YcZrS5ho0E+OMDidF22Vtp/gJ2TJbBFz9h2QJQmfEwBQU5JikGOi1G7vEx+slY4HZOP5wJdvbzJdlHWhRp9gKyOGqQt/a/1Lg+SrTNWQ6SuFIDlnEHZ9umJBN4kBwT2MaEPqHZRHv7dYDCKZtFFt+qDiRO8nregRhRGs6zdzyxonWrZr5PzdxVpWZEgORHmIpBtM0HQlBFAmcs7kt1pwc8gMUNUeN
 Y/6IPswp
 Qw5SFTfOO0dxT5Aj4OkVaIyhkQ6KR7wXaZsS1YpX0737iVqmSAsNimwNZ3IBksc/GEY8uKTlvDKrknU4RaQmc2VI3UBU3u0XhYh7OEf8EXXt72KlY6kZe0flBMxI3KtBbahZAW0ooMec97PHQZ4whol7F+QcAYnSALF0CUPasj4mXYPSJjUNwTpwB6qiSNPhEKWiMUOqi9+gJ7P5A4EM7ijQVsRxTZjBeUcnV0e7frdZpYsBaNdltVt8sKXvbrLsgDYVu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 16:08, Jason Gunthorpe wrote:
> On Tue, Jan 13, 2026 at 10:49:28AM +0000, Mostafa Saleh wrote:
>> Would you have a problem if we added a new function in page_ext
>> "page_ext_from_phys()" as Jason suggested?
> 
> Given the hidden complexity that David just pointed out I think this
> is essential to encapsulate it in a function.
> 
> The function must be able to accept any phys_addr_t and safely returns
> NULL if page_ext cannot be used for some reason.

Right. I think pfn_to_online_page() is the appropriate check.

@Mostafa, I saw you already sent a v7, is the pfn_to_online_page() stuff 
handled in there?

-- 
Cheers

David

