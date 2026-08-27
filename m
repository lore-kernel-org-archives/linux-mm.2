Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21513C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 10:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6DB26B008A; Thu, 27 Aug 2026 06:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1ECE6B008C; Thu, 27 Aug 2026 06:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35AB6B0092; Thu, 27 Aug 2026 06:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 84F6B6B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:53:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D9441C0CBE
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:53:57 +0000 (UTC)
X-FDA: 85146739314.15.FE3454F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 64139100003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:53:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dq2ilIQl;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787828035;
	b=bVmZ34jw2vQjgfkU4bEjf/24qOulNxg37jflmHa44/TxZIp2UTO6emzTV3ls9k/4issv2R
	cORhV/MNHoxxqfMyzkfXgLq4+CX5aF1cyu/NAwNXYEcKqCFqwfODr/m3nI31pzTJMkIQOV
	T/k0dYz5mCWHWwpV3C41Oelmn6NoRPQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dq2ilIQl;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787828035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9vQG6xXxfOtXuXsofA+kkyyannhlls6a3LQ3r9TEV5E=;
	b=A4YzEh2UoH4garu+XzPzzqSO4ZnI1CPicCQ1WJK7zf6VgaacgwVl/oxHcxxhwRe4QcGcSX
	BOsRqenMIOnXIVvXdoOGp6MWs5wINkpHmc0xqJDqoIk1fvNW6BH1YY9M9gquLtq5LNm62H
	PHnI2Xzucz8KBDPTEWlKt7EdxiNITG8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 858F2600D0;
	Thu, 27 Aug 2026 10:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F361F000E9;
	Thu, 27 Aug 2026 10:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787828034;
	bh=9vQG6xXxfOtXuXsofA+kkyyannhlls6a3LQ3r9TEV5E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Dq2ilIQl9pLfI4ZKlrAVpdIx97PgF67u1GnoyEECTpvO3pup2fvbV1LWjYlItdFFW
	 wjkfrvcXgBJoY6PHApAXBcnmdTAfk9XHjmXBYdhmYH6wmjDJX50EITBE0PwK1/C3oI
	 EEmsAHrl5P2nwLn8tUnyt9a0zjUoTFNOKN80dgzwFvMhHOK4Y5dzFjdjmid9E2FPNy
	 nDui3Q/5SWc9NFmGLZeWAvNBbX42IMBFrsN0cM9RWC3wT7yTzILXjEDcLBzAeEtCb9
	 pajS6TRs+zYGuskxAeKy/fJvgFHYYLimEmdHlDZW5uom8d1lu+3lCChQM1FvqcTS8X
	 tkOSInoj3tN5w==
Message-ID: <132e7e08-2387-475c-b700-eacaf47f170c@kernel.org>
Date: Thu, 27 Aug 2026 12:53:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add myself as a THP reviewer
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260827103435.1371882-1-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260827103435.1371882-1-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 64139100003
X-Stat-Signature: etsz64saxden7itmkah3d3koxxeytfd6
X-Rspam-User: 
X-HE-Tag: 1787828035-562022
X-HE-Meta: U2FsdGVkX184x7m8EhirIy6YdSlpVBUHWLL86NriBgZmfUX4aRqY+59NXxLOOsJdOmsXo7mAJRkgoIh5R/IjjCHOuy1+/x1isVkwZu/R1yOgmWSh2rzqJAhLveCcd1+TSENg6WeYVv3RgpLjgiCtmEJlewtQ4wJUvFOJn9LmgKO32gGlig1GNCAV2SA+4n9vHsG/m84yMsZ0N9xMnBKCoEtNa7j2Uhn1VSEN1rnEkmqqzDpvyNhs3pWW/mF3lTPFDMKHgY8eUPmbxn2VRjq0wfUXStBa6rJIQKpONddR/FVd2theV8KRfuWf8S2kZQVnuEEBWS8vc+LzeMFqqpQJWId599bzrDNkAEaGw2uGVKMey/Ky1l63B3nIh+AQX2wlrFMlZg/kih/SNK5ktgusnpddvEQPw3/oGCEv5euuaeWP7D9U7JjidqSV8sw89iCjX2jb0Cwi4gYSpjFfXXCH+vZzhe0afUk3etpB6DBnx8BMXyvQQpKznB4gDNkkavvkhgWX1PwTv+n0YMbjGi2wd/ErdnWVrGViC6DrEbDEWA5LnSm8CZP0MbuNrrmf/73wHAEGb3tn52Ry2rZVeHUPx1baa5ilGVGxjoHngs8wF7bA4B6ahmT0hmob638RJ+OQdLxk1hgHogzqEU+tvHDHJyn39/UNx8OqcthatLy97SL/N0Hqo5LhW+Qsr7bROz6tVj5NWUgGg/vz13i7GovO9M5pvpwb+Pkcw8hpHv2P6NYncrmErPFAlvxy11+B+Dv+mJRqYwl+650W5EbiHHHa28m0twk+UiEaWLyeS4tFF++I+Zb8ZTYIDC3mKTSB4XKDlIAbOcfsl1uDZKo0op3lMztU4qDx+j/ac+0a937dCl7Tw2iFGwss63lEk//PBI8A4QUYWR5lm3V+IYyjciiqfYV8pdS5R+AoLYVXzCS3atsWLAmn2PrRRHrCH1CvkxEm0hX2tzGU2UqwrugKRt8
 q7cDudlq
 qPjqREsc5jHvcwKmTpTzEbhvrdkbOqcpI1HRLs38xI37ftLSRLXsDcs9TnPXovm+xN0lQSQQxQmZa1dTOV4zSc6KUWIbrsUDPTMTd4gSJtdvev+ctGdnGfQD5LgW0yBm1P2M0kqBqsYwwalIsuPEqx4bsGeCQ0e034shP6Y8pWEJ8EOJdd2xFp2zmk1tEwSLu3T43MVFzzGXt20wGiOVzrqvIi7gZseYOJRxdl8db1SmhrrIGSPdx6/CH2EELl8rfY3Tv75suD1rL5KTFu0CYLxBixd7JlSImcXH41LPCLgb1obXS5Qhb3CpLb+x5Dzf3pY4jlo8SeBv3UDcy3yCc01zvfwHWm5l4Pwwh9J2f0Jl2tPaZ4lO2P7SInCfxUzdSuLr2AiKifZiv50eqfcYq5uNAEYtNMgRO+Y/31c6UhhAyBbyP2NK6nUdm+CGiRYZL40TupjoPCm7ACOc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 12:34, Kiryl Shutsemau (Meta) wrote:
> I have been working on transparent hugepages since 2012, starting with
> the huge zero page and file-backed THP.  A lot of the code that causes
> pain now traces back to me.  It is only fair if I share the review load
> for THP.
> 
> Add myself to the reviewer list so get_maintainer.pl puts me on Cc: as
> well.  It is also my commitment to be more active in reviewing this
> code.
> 
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1be7da9b6e2e..f5bb29ba41c5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17264,6 +17264,7 @@ R:	Dev Jain <dev.jain@arm.com>
>  R:	Barry Song <baohua@kernel.org>
>  R:	Lance Yang <lance.yang@linux.dev>
>  R:	Usama Arif <usama.arif@linux.dev>
> +R:	Kiryl Shutsemau <kas@kernel.org>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  W:	http://www.linux-mm.org

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

