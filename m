Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E085F506D2
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11A36B02AE; Mon, 16 Mar 2026 10:11:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD35A6B02B0; Mon, 16 Mar 2026 10:11:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5706B02B1; Mon, 16 Mar 2026 10:11:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDEB16B02AE
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:11:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 71FB1579C3
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:11:15 +0000 (UTC)
X-FDA: 84552113310.30.F2FF9D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B2C58C0012
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:11:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UW/pLckC";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773670273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ouCypcL1+siIYaers+ALMVHTuOx48YXnAxdQiXYVowg=;
	b=DudqSTxDN+XkwB32qIEDNfTbReY4s2+qEI1+eOPHpMPitZb+k1p3x3ngM0j2WVCBpVWdKg
	SPYZ5a/KguzHdYgkab4p3OMJ77LPMfjEB8XHmWLt/oyGum9+i1oyAt/MBPWSjHEpVEFxUc
	Vwne7Z74uEM+r2kOUJH5C4PtA/GmIJs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UW/pLckC";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773670273; a=rsa-sha256;
	cv=none;
	b=G34O6DjoWacbNrux4a8fubgphbHoL/SdINrLA16cTfW90ZeGa2zRjPjsnMNGpCn3y1smfr
	hufnTveY3q0kEQ8WcVQY9bU5g5Ij5BE0U3v2qZwcGohgOQVzqOnPPvFbO7jBctmVRFNLiA
	e/+RZ3tul3nKvoMFOkZ/WRt+6xs/6Vo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1438B60018;
	Mon, 16 Mar 2026 14:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1999DC2BC87;
	Mon, 16 Mar 2026 14:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773670272;
	bh=mObWySh6ftg/C/Y5QydTHOsnluUnNsUQ7L5CnYVEA60=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UW/pLckCxaNKin2wiipk5x1+dQXwPfHhssQ3QmeQq4QXVJQ3y5OXuHSa1pZlhFR1M
	 qEnCL5rs4a6xAWe+FdiyNnqHfAeN90322g4aAl4VOzQKIdM4VfbTDb3ZqQWxdaqg4A
	 oJoExQipZkyEKvzOi6uoLmLS/3GoH0scWeQjvj4vt2SCicfw60c5iB+snAR5g5dqyL
	 15WD6qT/QL8wFr1KIz3SuFnvVuZETuxZlx+ZqwRifMnssSuMamHfBs0P+F8URMkht/
	 XsF+v5W82wbBbBI/mVpEtgxVlUUFiGYbUzmKLm1zVGEgaeWqcp7sfv4Jo2oEIaTRyz
	 WM6aXYuiqBIXA==
Message-ID: <5724ac10-70bc-4259-a69c-1c0efaf28d02@kernel.org>
Date: Mon, 16 Mar 2026 15:11:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] selftests/mm: transhuge_stress: skip the test when
 thp not available
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 Li Wang <liwang@redhat.com>
References: <20260316044335.1390608-1-chuhu@redhat.com>
 <20260316044335.1390608-6-chuhu@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260316044335.1390608-6-chuhu@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B2C58C0012
X-Stat-Signature: aquhy9yb1fkujryjk9711hepm1pm1haa
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773670273-894743
X-HE-Meta: U2FsdGVkX19PPJ9glXKwRC8zFtvaWKpB/EGIa30cfAbcttb5VTILPTdEiLOfItQeSSlRc9/7FOvt3AcXii/bqoIZPUjAvp5J5chKlB2pL4j/3q55NdBnC5FbLPVNfKwklzoSqb6C1AyrRtN/4reXm5HAZIfoCCiGWShJAbRoN8ELawGOAnWVM4A5ivIOR3YZRbbhC7j7GwdAkQjt5lhRYeQ+LKuLpVT9FpkGZqZAyNy8QiusxEJA6CNOCODs8W+AkF0EEWNXpCYbAW0O3W3PFIJ4jMG8/RETCasYd7my1S6mroYmkvLOe5NldyWfISvT+FHBAyOtl3rvkxW5wqBpogSo8JGLtl3oCmYhrvFerNtBtEnCEq+m5mfaBR/5VWEartb1URGIiJ6+QGkQZ78B78XZfaQ9B3cMUxDFRUgvbAEQdPG1oM93d9isFu0h9g8ciuC7tMqz9dnGX8Vay+cJK5yvKJhwW3d9rzhc16PIqRUXPdfOKViD0s+6tYx2xH1mReyIqxoZSjrnPjqbUmhs2yKKU3iZv5SENuS/ZNXjoRfkaPUbaEpc6kZCtsTFmNJeQ7mZbS5APIk+z4hZJHWS9MWvSPlWi/d8RRgQJu8zlSP+qfLfyGH+0gRdcVn1Tee/p2FrYyAHgKL6Wy9TERSGMGzpRkLEtS1ZbrPnHapONp2qrWPBr00/REWgcqa0dXOv0Mwi0KzedffB/szkevc0v3qd47Uhv289tuqMrsczuiK5UlG54+RHMjqQY/Zh+7ll9ZYdzyXTVt/4Gi+oM+9MYRUOyDB5x4O00uFnvzMCeHgLX3a7LsbTrXGbO+r0zwjd3JbWTwCTIYGQ4lnBGocr3jGkDW83Tjj9ZWPi6+pdaWw+2QV7p75qybitBgLGuE8CvhvB8lV2tKKvmuLz6YAmZf5lzd2qoaHmwncfCFVY61uPr9ALYZZt4CIKn2OBNY7DrBLQs8YZh8OqfLNhtkU
 qQPR59rZ
 tzjon6dfbZaJQZOKtHuvHmChPDwg8eWVmo2aWCW2R3Bfc9GD5+Yd3cXOtrHVrISjlOHOQ38L9h6NZ+MYDr8fHOjyzwneqKiAUwAbcr5nlURBG27Cijrqu7p5Z5zBvSmkMtRe3LjeqWZdQQFUyEa2idGus6N8oCnBik06bY3mKjrv5PgrIM0nGiEcehv8AAcdbj9dAgDzfRS6IiYGuLWdVhWOiLoU+HN3LBpZwFGbBMASZBOEPQmSjqh8fdUBZWRGowvrA3l4iVSkEYnePYa2pGMyInGJdNBWQaCphmdaR8PS1p+cz9pzVQ7czpUhpz+v45ik7WOwd5JWdoDiBOJusNrL4wi2KIXOu8HNn/OQgn+hjduUHUzEtJMANEHQlSeIE3cLE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/16/26 05:43, Chunyu Hu wrote:
> The test requires thp, skip the test when thp is not available to avoid
> false positive.
> 
> Tested with thp disabled kernel.
> Before the fix:
>   # --------------------------------
>   # running ./transhuge-stress -d 20
>   # --------------------------------
>   # TAP version 13
>   # 1..1
>   # transhuge-stress: allocate 1453 transhuge pages, using 2907 MiB virtual memory and 11 MiB of ram
>   # Bail out! MADV_HUGEPAGE# Planned tests != run tests (1 != 0)
>   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>   # [FAIL]
>   not ok 60 transhuge-stress -d 20 # exit=1
> 
> After the fix:
>   # --------------------------------
>   # running ./transhuge-stress -d 20
>   # --------------------------------
>   # TAP version 13
>   # 1..0 # SKIP Transparent Hugepages not available
>   # [SKIP]
>   ok 5 transhuge-stress -d 20 # SKIP
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> CC: Li Wang <liwang@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

