Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD649D4117D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 12:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340CA6B008A; Thu, 15 Jan 2026 07:26:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EB286B008C; Thu, 15 Jan 2026 07:26:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EDFD6B0092; Thu, 15 Jan 2026 07:26:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 117FB6B008A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:26:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA34A1B7DD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:26:38 +0000 (UTC)
X-FDA: 84334121676.05.4E74BE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0BAB9C0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:26:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Krsrrt2T;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768479997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9pwTSCb9mZ62hOpkpEAWZHglZeqde3vTa2IV6UY5uN0=;
	b=VxeSOVviEAmQ/Jt0kKFNnsKrWQ6Uc6sKADflJpCvJ6aHroRcdy26pHnaQhA/Gj88Uu6wCd
	Srm08eIZ7aI9qULTvfIEkH2DhzVClrQ/f4eb4R0OGTtzn7zuBKM1+k9zQRjViHO/wNL/m7
	4grsRUalrJ9NYbvarSMIbIrajrMFSaU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Krsrrt2T;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768479997; a=rsa-sha256;
	cv=none;
	b=tb83UT9mGoTKsLRpNPw7Q0l5MXGpkVqUuQjx3900MXWvFShAsI+vItykhft4w8bG4cgfXJ
	7gfxFs7JjMCm3S+oNctfoweJGWjtfv6Hedvgj3brDf4GcWumm4J1QVEmnPa3sD0Or8Ia6l
	HWjtgymaFVVj6uMN07w7faDhknvrAJM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BD77F40C11;
	Thu, 15 Jan 2026 12:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A6CC116D0;
	Thu, 15 Jan 2026 12:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768479995;
	bh=X8/pCAs66ggv6ENS8H26d1g/G25IXDu4xUO0dYzXMws=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Krsrrt2TKqKr/2bkYcwqpeaCU8oYMKKaaYd/Dtrr67u9JchOjn6yTM2GXM8+/CtZP
	 n4umKPSRWS1jliRAeNF0S1JdXjFFXFdyais30WLQVd52q5ayGaxK9ThquHkdLZfOax
	 TlTjBVbcdlOGV64erSorrMg01SrF47Dr1ihRndXB6HVaOikgWXeLN7nMUVqw99ycaG
	 ZMiFwYWnWUfOIkYvzrYbsT8MvXkhXG188vmsOYzhtYCjhIkgX3J+vpvMY/Gz/GOck5
	 uMrzvlTMRS6pjbuBSUpR9X3uqD0Ztsy7pmrVFm0naI7pBJoM+VSNo1ECsHRAbyT0ap
	 EzNYV00SKXuxQ==
Message-ID: <274eb8e9-88da-41cb-bf77-9571f05b81fb@kernel.org>
Date: Thu, 15 Jan 2026 13:26:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/23] vmw_balloon: stop using the balloon_dev_info
 lock
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann
 <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-7-david@kernel.org>
 <689941ab-696b-43d5-b14e-5cf2c8639861@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <689941ab-696b-43d5-b14e-5cf2c8639861@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x7i5hwu7dp5mxyg6dpzj15dwzc75iwqq
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BAB9C0005
X-Rspamd-Server: rspam08
X-HE-Tag: 1768479996-809054
X-HE-Meta: U2FsdGVkX1/oGjUXeJ1dK6YTt5PJANtGqkki7bGAHtFC2mTnfN0/NLRbO8bWjERZnentXuMQDLTPGvQjhzg976SHGevWQpcJq37iUaWIHFEjt8omQ6BnfmDXfVOAdjoRMfTahhtYClhTRcKSl64v+HSOMi6i4MR1yVaKNnydcZCOr34DFiM+rnDt9Dm+F5OeKBir6R8yWbVcL91rQ3E1bxD3BUNisdmdZ36Xvq5fQ4j2IAJQsomm0F8+F0CD49mvXgZofUZ7p0Je863Ffwfpootw/kJK4W+eeeCyw9GdU/o30+SK8Z7relsBMIM0EADc6EF2+yxCQWFOOLAaQPaduEFXz9H8MXdfld9UDFbvLHfIWaQLE14l9BkrbkktMBNkX0WSpaQNW9PDbH3FKq16BLGp8DIGKRwVfBU1hwackYqnAk/+4z1xqd9ZzrpOa/hAofEDQ8l6oSRM7dK7AkDCs2B0bsPmfXEPLYKvnOt/OPvmwR0eemCcYadBMCnvZkSHsP1l0a83Gusr4TV8ohpwJOk/QW7VW/Az5nkGL/3y9QZpfAdBNqDoqCir9d9kNge/N4Q+tINQI0nXjXPu+RF/9JH02NBd/5CzE34PupCow/3HqjjlqYYL5GHoqtqIdSSJuMZ4sDnrrMm86o7bGffSMa97H+5EYqrq5oDlP04PphmKxbakmyyK7Mmmpa+hqeLElfHGbNopsXZcJVdR7wZOjOsu4w9eRfKHkalw3IXqwoO3Hqp+QRY/XQgh/rfuCtQDqLaCAP4AnZ89kV6sHR1NFX6n50hdwPNDQZMei1KCDDW16tNgIT5t6qyKiw2trzbgeGJcWN7jibXlX//Oj7lRvs4WaKPZHJSVHLyz5TmYuSitGozqSVUyX5wIAiCxBkLmUBp6Lmwbcip27nVhrl4eHh1JLSVhYu2X9EeFKiciIoEKBjuVi6PUFdChqmNPWuDQqclQJQJa93hQZTRR6Ig
 8HOg2GKv
 Dnh6TCLbv1PXaYzWFR3vv/7XkELmK3E7Lv/in7P1vDo8KXlbMyC6r83v0hFn7E+oB6yzPQ5G7aEYTm9WZ+VLXya7lJQqvun9mGtOwa1YEbU5DimA7wv7u4uLhughMFnPtYjPr6YdiKmFGs6t7VU0xTOempK6y/sy3TT5iJQ/aVLjTwyjqRclM1IAllVgvvi+bvg/HnQEbdpgOcJzRj2+BTlo3kKcD+FfHHunQWbRBPy18YKeWiFBOx5BgS6V4KXSKy2qp3z5w7Wk1fv3yqejTsEInKqRwnCJqNC+Ei+uTGntGKYL73iMrCiK7A3D1cc/Fi8HHqB9X3ReiXMc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 13:21, Lorenzo Stoakes wrote:
> On Thu, Jan 15, 2026 at 10:19:56AM +0100, David Hildenbrand (Red Hat) wrote:
>> Let's not piggy-back on the existing lock and use a separate lock for the
>> huge page list. Now that we use a separate lock, there is no need to
>> disable interrupts, so use the non-irqsave variants.
> 
> Why can we avoid disabling interrupts in this case?

It's a leftover from using the old lock that required this.

Thanks!

-- 
Cheers

David

