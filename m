Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52D54606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OGWsLmku
Received: by kanga.kvack.org (Postfix)
	id 68DCF6B05CD; Mon, 26 Oct 2026 05:54:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63E6B6B05CE; Mon, 26 Oct 2026 05:54:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553BE6B05CF; Mon, 26 Oct 2026 05:54:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 246D36B05CD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:54:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A3494806D1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:54:00 +0000 (UTC)
X-FDA: 85364316240.10.2657D1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id EE88A80008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:53:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OGWsLmku;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793008439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slLtyZO10w1Agq5+WTU12Vy8+fAIdVvdd23Nhz33tbg=;
	b=i1S0B79bvjwvuyqZbneD7C2LRH7PHXY5hi6fa0jO0g3HrV245MaE8TWbb92ssTl2suhjXR
	f34yAGtOWLkHW5+w0YmWZMIsqFE1etAk7rVvkjkQrswAkp3xLp9AqglO8zICVP9hB7UPYn
	9ozwEpGDic6eZn8rRc+oNVd8orCvalI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OGWsLmku;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793008439;
	b=prcbAnYzxgPFRBUYNwLn1kB7MEMS0hauwQDzGCJB+oXg48MXeZ3oNS37AYgPFeDdEFs4Lq
	5SUCrhCv3INtMmgs/I3N6Ee56pNNczjU1gSf9W/2Ofg8vIZY0wFrBpKmlE2OUIkWGSLBLm
	avtDXLAv8S8LQItllyYtkBZoQ914IZw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 74E326022B;
	Mon, 26 Oct 2026 09:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088A81F01825;
	Mon, 26 Oct 2026 09:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793008438;
	bh=slLtyZO10w1Agq5+WTU12Vy8+fAIdVvdd23Nhz33tbg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OGWsLmku8ODdB37K8iQi0trNYZrXne6AjZhuAAh1Smvl++2TW1xnw9hm+QSCUjUv9
	 Ude+atIpxUC1dJPKRFZzEZT/bKs3DEIjrieG6f6SD5YuqC2NoO7Bf489V2K7g/XEP+
	 8dhbC0dEM0bQLNWD6Z/8C9hSxJvqLHhYRRUOCwIe6iG7Nj8RWzRj/3YP7RY6Zog0bp
	 8UMWp70aX12dXlePnzU7H8GOP+Iwr9SFIUC2J0Af0Qq0c9d7t8Mx6zSbBb09Ztnv4t
	 h1e9l/qdchOUutNDko/jz4cPB0CTDyZf2ewusmvWeFR7+79ApnHIh2SCPlp+J1ZN63
	 icDzHLvEiqqOw==
Message-ID: <384f2307-8531-43f2-8ec4-4b2dedc31e36@kernel.org>
Date: Mon, 26 Oct 2026 10:53:53 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] docs: hugetlbpage.rst: clarify HugePages_Total in
 hugetlbpage.rst
To: Enze Li <lienze@kylinos.cn>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, corbet@lwn.net, danielmaraboo@gmail.com
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org
References: <20261026080856.76175-1-lienze@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261026080856.76175-1-lienze@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EE88A80008
X-Stat-Signature: 4e6wn8pypr5fjkgg5gnggk9x4eaa5755
X-Rspam-User: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793008438-494122
X-HE-Meta: U2FsdGVkX18BNWL96Tp1Rgo+azv0YkMfmQTVonMP6F0R8Sob+xpR8/Jl19IIrriKk1WpaDH8ldI/xuYDGrLDEpgX0Vzl018fvlmwES0GP25UndRQ8Q/3jBF+ZGA2yEyRW1R+gYzm1ytymFzZ0BISdMVduIgFvr3KO9jWZd2tswn8TvP+fuhiGa/QTDKTmgWScgBA8DKDfY6Offu7hH7X/h0mgbFjvqWZF6lcagC8sq1yU3QgkZdFzq45l2FBpLxh38WiDdTmLj7QG50QA+Ajlv8Oa/RvEVFQdt08q3HB649iXeaERm8JuAAXfSyceE7hco/sz4tkS6d+5bl9szA5FIHp/JcZTYuJPZpYNWfOZicdcce/z23mjp+Up+sXAoZD0d/8FQA4xmusc+IifPatKtAuQ4E+g2ubJJSkl9IgeR32svmQVfM461PmOGvM/G0ZKILoUrw9gBIjPvHrYy0xbPdGjq17J5AHmfcy8kGc9I/2HDoINMaNOD9qVm4M/85KUJ0WmGDdBYwyhgHo3EClSs3ZRkX6kxYKCv+jXZGUmlpP8xXRugUxu/nyAMyD0iQUgTI+d9F44mubc2xEB8NI1Owzm5R8X+9TyQk3cW8G4KM9vITye9stc3uurUVUbM/vc6RRmCnP099vEDMyID5UdHXkFR8SYHEx22yZomSOET0MPDn3DkuIYkWuM2hiRedw6vxXWvi6Sg25+P436BSrft+g+rr9H+COUbsoRZT+CudiJXQIXJwLyj8dIboQxoDjFmeOMaYLtp6vlQp5a4a3skHxVaIAyvvdUhUeZWgZAcdQsAybK3cwmYoKbWejjNcaVWekFdyX3J3j/qgg9Fe4dPoAwF7R1SVBBqTLpkSoyniJqOKNAPrTIhapsE7F1mVPFCqceHgmvL+r+iNE0u/YjP2uzt46aiTqCXr3e0gZtZS5/Ux+KxVhagrUA+LTbX1iPmIib0yJ9uaallRaK7B
 AFTMDArb
 6PU4+LetgI59AO/NFNIh6ADwg9/R5o5pQKEI471z8tUFdWAZkIX2R83Nqwp2PAIbCjdseZS7uMitdSp5Wfns+UB54EeG4MvaLKhp9Vg+bMblHdCDEhOP5bVmVMuLELFwFox5KPYEXEoTtuTVfZsodhiwiik8pxbNlPNDXvhuSWX0MdwxyP3teJGvTqcLo9fR0KrMkh+Y/ZpPIvU1i7AYdfvzmAcGITFmIk9C4+HLsNds/tJ+U+HnsdWhwNe+8MT6zIupTdyDgmReg/6iZVqqu4OiU/8A3AMkHPVAcn+tK394XflWEYlCWDuDy/9SeDSMbN4TYkeeR03511hGgPYv7AQ4FcO0ZQe2xPZCB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 09:08, Enze Li wrote:
> "the size of the pool of huge pages" confused me, since it sounds like
> a size in bytes.  It's actually the number of huge pages of the default
> size in the pool, surplus pages included.  Reword it and point to
> /sys/kernel/mm/hugepages for the other huge page sizes.
> 
> Suggested-by: Daniel Pereira <danielmaraboo@gmail.com>
> Signed-off-by: Enze Li <lienze@kylinos.cn>
> ---
> Changes in v2:
> - Drop "persistent" from the description
> - Reward the note on other sizes.
> 
>  Documentation/admin-guide/mm/hugetlbpage.rst | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/mm/hugetlbpage.rst b/Documentation/admin-guide/mm/hugetlbpage.rst
> index 2075f1f14a42..282bc420d97b 100644
> --- a/Documentation/admin-guide/mm/hugetlbpage.rst
> +++ b/Documentation/admin-guide/mm/hugetlbpage.rst
> @@ -43,7 +43,10 @@ The output of ``cat /proc/meminfo`` will include lines like::
>  where:
>  
>  HugePages_Total
> -	is the size of the pool of huge pages.
> +	is the number of huge pages of the default size in the pool,
> +	both persistent and surplus.  Counts for the other huge page
> +	sizes are available in ``/sys/kernel/mm/hugepages`` (described
> +	below).

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

