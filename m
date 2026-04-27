Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DA99FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:49:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 956A86B0088; Mon, 27 Apr 2026 07:49:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E4B6B00B8; Mon, 27 Apr 2026 07:49:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 844916B00BA; Mon, 27 Apr 2026 07:49:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 74A266B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:49:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E44D1A017F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:49:56 +0000 (UTC)
X-FDA: 84704166792.25.0886736
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5E0EB140002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:49:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C1e0ZbDt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777290594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gh6nuu8gfQ7tiyV8Yv/7f64CF2bkxWSkU/9+lRnov/w=;
	b=tFVYIfi6KTXwEPzDlSAVbct/EleBfaa8pGyIwGpjd0XruBQxM1+LK3ebE6MxwUsux/SXWN
	QH9EVpvRBnNIZ22iidSnpnaP+O2FUoj883mwei3sIHcPnl1LscHBb2xG7Ijl5JebSfgdKA
	N1YYxtzPDt4SwsQmPAmplas2Gmr2KjY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777290594; a=rsa-sha256;
	cv=none;
	b=7uGJLIXfjYwYnqH6ZNf09m5fSKyLnNiSO0RWk39e3JW4bTie5k3DpSiHY8ODME22robHQj
	f1ifHAJr3zQluv5Mc29Dhhfkp55IDU8445wkwqGWBHwURbvMa/24YBn9dKSd8erAbZVhZU
	eTTD9mqEfmqQqU20WR2u1kjEF2HSmzU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C1e0ZbDt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 321E5437FA;
	Mon, 27 Apr 2026 11:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5295DC19425;
	Mon, 27 Apr 2026 11:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777290593;
	bh=h4RtLE2GTrmG08WRedfHVuo+NevXKWADv6QUE5vTSQ0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=C1e0ZbDtfdDMmzgWis7h00VaPDuggVvJ4e27JnUKpmrh23UbvWZ1xNaW5R6Rh127H
	 XUmSu990YzoZYeUGwZNuRpYsW0pXXN/6YigfOp/DyEUei3VQPRkAj5n1A2mu5L3viS
	 nlUoWBmOUeO7T0lU9Rr9qyxujVTahsYj7+HdomUX0F4tzjfEvWgwRWiCBassFuYJ3p
	 sK0Y81OXb+3wETAcxOS+SAMYlq61x/ggC7NggHql2Gq137Zli+DvhJvlcPOiyPGB9Y
	 jaeizvrOtKumcSKItYo6Cb6F+GWpY0zM+WoxE4CqNHKzwgUl7M92y9ZJn+sfb0udMA
	 2B/vxrvAVKIow==
Message-ID: <637208e9-9d1c-4e7c-8428-9c3d36e2b7da@kernel.org>
Date: Mon, 27 Apr 2026 13:49:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/madvise: reject invalid process_madvise() advice
 for zero-length vectors
To: fujunjie <fujunjie1@qq.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Shuah Khan <shuah@kernel.org>,
 Christian Brauner <brauner@kernel.org>, SeongJae Park <sj@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <tencent_98F3571EF9236437E5165F5C08CF258A9E08@qq.com>
 <tencent_BB588C2CDED859A873093DAF28B2CC1F7B0A@qq.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <tencent_BB588C2CDED859A873093DAF28B2CC1F7B0A@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E0EB140002
X-Stat-Signature: rjo95gff9x8ekshqt5k38zrptx8ym8wp
X-Rspam-User: 
X-HE-Tag: 1777290594-894132
X-HE-Meta: U2FsdGVkX18aEjJKiX/2S/dSA+TeW5dMhThrF9TP1IT2uZ3AzrC+8uVLUdcLgMX7VcLruvjj87nUv2p2tItARPMUvyMGw4yaR2deX9a71mQlaZDbIypYo1d5uQCgW2oCO1g5UAwrwHA1dxeQ2EsBaWVv8UPdsbRygWMGG2Hu8zEck5TVCtMDR+OeAW8Ok3H+X3JfMY9rRwb4Wzt8gMVLTDRsDnbozSJQ6n14TlVjXjWZSDLCJs3IWb+m5YkUEaCT+LTP8sXHswN7fE+jec5YUqbBFhjh+E1mQj5Em8BqlNijoOWuG/lTFPJhTg/q9mm8mryVBHhOv8xIXTFy1rtKYSSzSORpFdLMEPv9o2z7Q4J40ngGDoZVMfubJRtkrVFPKTkYj17HRKkrHk3W/dxws36N9FZiUH+4wQRtPXb+XiBMBN4Uk5d9uW2coRqUZFxtbXK7JV/qHmZyynk/afIm5ichvqFY5iWH/g/JfcRXmJn4j91Xapeolxx6QIg2eUWtCX7YiC5Hn/Q0rxvyoptPas/TBjRi+rpLJqU/L/ujnNxRUoRD+WK5OgaZI9fDkbFbD5pXujs78kO/QJwqHVaiGuPeSBsNL9gZNdRgAMI6ovCV8qH2vO7UdQvgeX4WCu4D6MKtl1k6EqM2Rfl9asy9UZ8vYTAVNUhslsrM92gPfEOMiDo8Yp88TWJ/V8EAyji1LBV3dFEjjF/r1TF/hsimLUn4KY+xSyN2wRmIZTuRWnNq2xEe2QHiqRAju2tK0HThaOnjyPNodLrLX+KOs8DOEAtscPSk61H5vSLcuKy9DSEckWvxiX8aae2Jn0F5+SH9W1k0n6kuBWLXftoGz0Onmpl8tRoPZEHct29Wlnny11L8UHdH3FbtF/xbKqNERIpsBCbO9TraZAriOySx3AzDc6+GRt9EC5rSzVTm9kePNmXSy8lrj0QH87W0f98fH5vTArekZ26tXOwqPZYDzBB
 8PNvf4xK
 Fh2M/xXQN05jiznPAjBp6gtCHf2YTA6j6iCx0cwKw/PPRsY1oY2aVihf7eDO6VD0yHitADYXiKDPNK4rjW5N1/LaiVqj9s5ROs34XsSAH2Y5nvQaNBwOy/GtzCBlk5FcXsunMNHsySF8iUnQ4JONyQIJ5ySFQlaBYyHxNTtVh0ysDKJUFoO2rvTBPM/STRRk0qM1sojAud+16JurkGjoHtlx/6bRjgOpTcBlEV7zuZ1NqTcAl59faTxzCuSYSHMpa+5OSKPAPQTiLiZ8QyGsGw5aUdMD3rkHibG144uaSWCVYR2Zb5gXdYfVhYhpDQQlbpDJ0eou3OjiD3i96IotUlfFdcjjyANsbnP+i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 11:43, fujunjie wrote:
> process_madvise() used to validate the advice while walking each
> imported iovec. If the vector has zero total length, vector_madvise()
> does not enter the loop and can return success without checking whether
> the advice value is valid.
> 
> For a local mm, such as process_madvise(PIDFD_SELF, ...), the remote-only
> process_madvise_remote_valid() check is skipped. As a result, an invalid
> advice can be reported as success when the vector has zero total length.
> This differs from madvise(), which rejects an invalid advice before
> returning success for a zero-length range.
> 
> Validate the generic madvise behavior at the syscall-facing entry points
> before any vector walk. In process_madvise(), do this before the
> remote-only advice restriction so unsupported advice is rejected with the
> same priority for local and remote mm. Then keep the per-range helper
> focused on address/length validation, avoiding repeated behavior checks
> for every iovec.
> 
> Valid zero-length requests remain no-ops and continue to return 0. Add a
> selftest that covers invalid advice with a zero-length iovec and an empty
> vector, while also checking that a valid zero-length request still
> succeeds.
> 
> Fixes: 021781b01275 ("mm/madvise: unrestrict process_madvise() for current process")
> Signed-off-by: fujunjie <fujunjie1@qq.com>
> ---


Next time, please don't send new revisions as reply to previous submissions.

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

