Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECECBF588C2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BE7B6B0088; Mon, 20 Apr 2026 08:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348546B0089; Mon, 20 Apr 2026 08:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25E8F6B008A; Mon, 20 Apr 2026 08:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1248E6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:21:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D36441A09BA
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:21:52 +0000 (UTC)
X-FDA: 84678845664.22.E0A2277
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 32DFCA0011
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:21:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jh7qhv4G;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776687711; a=rsa-sha256;
	cv=none;
	b=qZ+TQiq1CQOlFLWhp/3uZT6b/CTM1e+3LhT3rhbUScoo8g1V7+M5tFGWR7thK2SVJ5vb5c
	9X4G7OhD82nHuoIz0QqNBbh1gC/FDnOZ7aVcl3LEGtF6d+xg2HlHzUrXEEI5LKmhKtPlG+
	DYsbYM84DFpaBICdBgjbDEmvRcepmEQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jh7qhv4G;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776687711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MywGQWFzkhKz+Znk569VnJbYqhHYfuSPF/UhZaxfcYE=;
	b=XkaDGKF85Y3K2gKlYYQusQf8yaKJRUy7Z23E9pg0nSeGbRwn764sa/Iizovy8jWE3IZnq/
	jK0lxj5pUeUO4I0zUEB8O5QcZTRgM7C+eZgYD1X3i+ZJNfN9Rmep8mXerFL5YzcFYA1VRi
	I9lzlmb5cbSyYit1y7UssX9aSq1HvHY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 369236012B;
	Mon, 20 Apr 2026 12:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F210C19425;
	Mon, 20 Apr 2026 12:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776687709;
	bh=L9LDa8lva8DgET9ePF+xNKbKYxtkERL5knvaO3eD5ow=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Jh7qhv4G9ma5b299TRCbRaf/U2VwkpsUFEASRJy8uTasa1Ucnz/iiEOWzpNCxm1S2
	 cngaXjod2Dl5o3xyzEp1AoTOzlfzbZ24otCFDkPHm4pS/YkwrRdp2nemgNYk89dEn2
	 o0mtRwcpHxBvtdlGPscE9dLHEWwSUgvQL5R+yNdBVcKTcYbt7H+BRbvJd7MCKPZgcL
	 6AiyfYluWuGLhWzJAg4WBmRaUjzYLy4VTaguXgVJxiYkGi6aRc5TNohGq/WnR8AFjX
	 uq05qdMTAOnm2HAOV7IFPqW+iCijNiC+EBG4ehhlPBsp8rX25qvnOqF9krzJZtFd3N
	 Wk/JHNo9NE2Xw==
Message-ID: <759ccf04-345b-4264-a222-3049a20b0263@kernel.org>
Date: Mon, 20 Apr 2026 14:21:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vmalloc: fix buffer overflow in vrealloc_node_align()
Content-Language: en-US
To: Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
 Vitaly Wool <vitaly.wool@konsulko.se>, stable@vger.kernel.org,
 "Harry Yoo (Oracle)" <harry@kernel.org>
References: <20260420114805.3572606-2-elver@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260420114805.3572606-2-elver@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 32DFCA0011
X-Stat-Signature: 741opg9atucbjs88sgt7xbosq6z6onqd
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776687711-550858
X-HE-Meta: U2FsdGVkX1/V/cBf9DqsTHA4ruAnkrNlewxpuC+RDSwjdc3YNotjciNW3vQtNCUIOlNxVKbwxeseBnlLtNhVl5l4KmW9yhwbsP/SVJ3cEWb18UPf1yip3yFIh6wkKS9aMKe8VicNHZcHpkKN5owBzkCFtWZl2sal0whJXZS/NAoY9pp1F04LwkchZcgpn2FH4iS47l+3u7+Hv/WxAEF/Ld7bMTUTeHN9TA67vVs6xoy2uLP2+m0BT7BOlO+3bL5FIDRHdKKrEBnvthhYQEsNfefbZaOva5pE6ctcdqR8c09S3oPzyuQW3+KbIphP0ssZ+HNh5LTArtXRndUtyVPwl4rgX32qtqf7GS6W2qmUYgIBWtKWHdl/U4wGiz4X4MFgezSDVBOyCBOPZU/j/dqw56dNVGuIHzRQCeKfd3iPTVOm6fEajUlR1rJ01hhLxc5JzfYCCe03nPV0X62W7KuCT1uN+3LghfUIvncQCo7GbCikwDIG7L9J5DzIj7/6OFD93m84rswpGkhiwRMNJce/rDd5YTPBfJA8tCg0I8l0tNwjwUNlKgK4BGk0LtbILVZNmyAyYGFVb74aH0PqdPHJ38ox0nxjrlAGGT5pwTh1apcfktZk7NTaJ5jE8hT7FA1oCi1sA0w4Pc+M4POc3YwEufRm85c4itBXgwbkCHM4nR/p3Wj3O3oiumZcZ15gJgG22Mruid6nOn9br5b030rinOn7zbdA1RMX4lt2gzRmA/jBw6yU5vtIo1bwHqo1XyyshlMv0E857jDK7OWb+v3Sy7n363awUjrkfG1UT8C8KSnBRUsUQywNXwyF+McHgIdyQynd0bc0diQjwcsgAt37irBJrlzoCbS0elh/vhovCW4hT2igGKrAyv8R/KfLLhK+dcXVTxEZropbvTGwdClLuddtPM62hgsqWtfsWjiGhgGz3mk2a7jFIfSA7HI0caljIujYpH1LbP9OFm8ZedV
 E1OU3VY6
 rBXFBTkJSyARPXLzdaQdeFsU/2JSq/acVJJDfapC5HVqji6+4hz2qiWHD8R3huvEneLfr+pLx021k/W2PfOJvWxGIraQxPQ58my7BEYL10IO2OWeLxfYVkA5QRicBRr47hkbyj05V5J6oXTp2TCjNC8eZRmaKZCwxz8kekHe0RiofKYEgVf0jXoUISqR8ivzXlJnzvfWtLkKg2xyWSF7m3crixVkjsXFGvlSU32W1NAXYW8rV1w400EAz7CJ0nEI84jV1uhhZRzFivpyHVDn7OfPUuaWo5ph9sSxYFxM0P7RkC/8DE51NE3B4xZltFDeG24ylQ5R7qE7KKBBMpTX2dYx2JjijnPixzS8UWlyosdvzjhEFiTJxZG+J/PjrM2pc8xKj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/20/26 13:47, Marco Elver wrote:
> Commit 4c5d3365882d ("mm/vmalloc: allow to set node and align in
> vrealloc") added the ability to force a new allocation if the current
> pointer is on the wrong NUMA node, or if an alignment constraint is not
> met, even if the user is shrinking the allocation.
> 
> On this path (need_realloc), the code allocates a new object of 'size'
> bytes and then memcpy()s 'old_size' bytes into it. If the request is to
> shrink the object (size < old_size), this results in an out-of-bounds
> write on the new buffer.
> 
> Fix this by bounding the copy length by the new allocation size.
> 
> Fixes: 4c5d3365882d ("mm/vmalloc: allow to set node and align in vrealloc")
> Cc: <stable@vger.kernel.org>
> Reported-by: Harry Yoo (Oracle) <harry@kernel.org>
> Signed-off-by: Marco Elver <elver@google.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/vmalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 61caa55a4402..8b1124158f54 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4361,7 +4361,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  		return NULL;
>  
>  	if (p) {
> -		memcpy(n, p, old_size);
> +		memcpy(n, p, min(size, old_size));
>  		vfree(p);
>  	}
>  


