Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2D3DC4450D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 12:05:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15B076B0089; Wed, 21 Jan 2026 07:05:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11C266B008A; Wed, 21 Jan 2026 07:05:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02BD66B008C; Wed, 21 Jan 2026 07:05:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E7E2C6B0089
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 07:05:44 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1EEE1B0286
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:05:44 +0000 (UTC)
X-FDA: 84355841808.04.7D2FC64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0A1561A0012
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:05:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UEBdEF8x;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768997143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wF2c4bbbn8KGgMSmxUlS5htoK6Nrgw4D+6fvQ26xhQI=;
	b=Z8J8/JETViiYgo+14qXUa787tZri3dWOerRso6EKhg2Pyat9DzC2F/58xBGkj3mveVIzjw
	3zQhbaXksHPIrn95MdOa8BPBK0g5hqGqNx25DFNJP4S3VhGj/AMdYYm+b9ZN2fU8WnV3Ow
	ms75AQmZZUiS+hFZ6NC1dGe5eVxvVOg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UEBdEF8x;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768997143; a=rsa-sha256;
	cv=none;
	b=XdEu0kuXND4MleiF628Dj/Mw5ASg/HSDAUIkjDbObYTrW/K69V0D0+D5DDfBu8vpI3nJwv
	J0N1/uXcxJ5XyLrDMuXTb5Ukdjya6/udl9L2UiLGnoiSUMZH4M0xa6T9OxQAjuRqgHZX9Q
	hdC54rYlIB+XjrYzHaS4q+2YR98tADI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F6B5600AD;
	Wed, 21 Jan 2026 12:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3CEC116D0;
	Wed, 21 Jan 2026 12:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768997142;
	bh=YxxKP2xdVcpV/4c48pK90RgKaoPrMTMyK21rhMCrMyg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UEBdEF8xOj6SZnXDosEKklPeckjiET3n9GqbmRelhrSWCfuGR/PNuIT8HclMeuDUY
	 ScszL4n+Wm8xZhj0R9jhVoyuGMe9cuH7W+P5gRIepzSzPsXN07MzuZs8t/lcSIwzaS
	 fJai5alJzpWbb9l6rvnjDPVxT3mtN2AlqPSp1raTQJwO8K5KSYO4jIHNVTkbEXaUSx
	 SR/CiNMxp+ThAe6kGPMK1hhk1gTzfPgBO7v9NdSQBxZajMWQAH2Bp8a+g4Uhq2KH0W
	 MZDLZ4RiQ9Ds/zsjHJe1BeYL5ne7IIRCYvtVrqu6drx+lWk3HdZ2uQe589mJOvRVJF
	 A01mklmx1hfNA==
Message-ID: <39f4490a-d713-44a8-a1d7-3568b01b3dc2@kernel.org>
Date: Wed, 21 Jan 2026 13:05:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/pagewalk: use min() to simplify the code
To: zenghongling <zenghongling@kylinos.cn>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, zhongling0719@126.com,
 Sahil Chandna <chandna.sahil@gmail.com>
References: <20260120094932.183697-1-zenghongling@kylinos.cn>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260120094932.183697-1-zenghongling@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0A1561A0012
X-Stat-Signature: rfj9y5thz3o7i43wiocq68iz8wimdski
X-Rspam-User: 
X-HE-Tag: 1768997142-317062
X-HE-Meta: U2FsdGVkX1+0gnQS5gNZnapADWlqn/488donOd/hfPcHjVodj9WukAfmHmm/2j3YqbdTF5TdE5oSWHQWOkrbp/Dvu33VrNygZoesJhk81KMlxB7BD9pvOj/jeV0jN19z3ibEN6DUPSVwfW306qZpYgoz7jvLhyjSBMr9XkqyTQbm/AitP3DmsDhyLw+5KSZhoaoRbDAxEfLL1RZy6bCyM+WiV8nYrPSB3E42FL3s1Q68dwjucSE81Ck3baSr92oYLdz9XOcrRl0udl+qichqZmwa9822SY66s5lZC/omzHVhOaLN9/XX2kH6U4zvPLEKTjUeIGqPqwXK2yJoXtdN4UcbHt7bBuFUPQZC8iBWKkgtEHg0iAOIvn2G47KyqrZj1Wrd3FsTsnn1FyGR8jZ1jww7zo3EDFaknCSr+Nu5lYLOdH4qdZ6Gs372tKAZEf2QNcdTgDTqXig0kvkpo8NXdFPoy/EmOftJMC/q9QiyoqsoHPB3RcEWWtu74d+40K2Uk68GxC7hZEoGjW47YxhcXy8EvfHbs6YC2gifGkSeQtXy4mIY5z5BOhaCFbnPmZfZlTlZoOOpllrPsghMYVKdY8gRL35x7O3knvZExZDIUkJTAGWQMJlRfeUyN2wxTAq71BcRMilOh0JmEja4zZCz3007+aLa3LydVecdji1CQcYRIUO9p/UhsZURava5maU/C4IF6nsrfqM2r3sVk9/+DYQBXNf+9eDs+H7jwwFlTuQeuT5iYV4QicIFBpckXzhG6rrxDYlRN2CotIwfwDd+kXkFq7PLM+d8vOW4mwH0BZ1zhNheb/W5I5GartMuhEOFu/ZzHI+cEZumBqUYFhJT8AMMA4MvvS1jSfdpadrTiLntEGHfloLq3bggCOazlvQqoEnqduKhBZkn2OSvySbTU9hGPEysjS+3n7NjRK0kWZ9Slz7TN5dT+L9LCV9XnTdgRkukXN5HFGLrrcO5BJI
 iMj2yNN1
 9e5B2OA/Zpcm709RoSiVOYfeXdLlgCY3/X807sZHWCIEWfPchl+/NBhH02gXhzIxMUqxEsXYB98gJUkaAy7m4YG0FnLUebjy+O1Ldl5qgf0+wSJOSvBf2nwZbivS5sDNdBfVm3VbFdACQbMXKT3iThGdRpMpZYAEXu2Dv+0A3dwbZ5VXEMTEHbSkrmSxV8rfcKAf60dgJkh3HqR4APv8ut8zchj+vaoES/kWxOJG9z8BdcMj0XxpiJsFz8pqBD+0AUbkhFJgiO7SKF/6FqY5aWPijQkwrLbBYjKL7hgtuawfuUqrtZhLfHEqWs9dzdfvPC8cNz6qWCZ4/9fAEH9uxMeZmMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/20/26 10:49, zenghongling wrote:
> Use the min() macro to simplify the function and improve
> its readability.
> 
> Signed-off-by: zenghongling <zenghongling@kylinos.cn>
> ---
>   mm/pagewalk.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 9f91cf85a5be..82db421b5b34 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -313,7 +313,7 @@ static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
>   				       unsigned long end)
>   {
>   	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
> -	return boundary < end ? boundary : end;
> +	return min(boundary, end);

There was a length discussion recently about changing this code:

https://lore.kernel.org/linux-mm/35ab82f052d248c0047c10bf01853e37e4f9b4e4.1764312627.git.chandna.sahil@gmail.com/

Changing the min only LGTM.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

