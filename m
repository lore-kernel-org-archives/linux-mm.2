Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D9DF531C3
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F67A6B00AD; Mon, 13 Apr 2026 15:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A70D6B00AF; Mon, 13 Apr 2026 15:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BDAA6B00B0; Mon, 13 Apr 2026 15:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2ABEC6B00AD
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:18:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB05613A364
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:18:50 +0000 (UTC)
X-FDA: 84654494820.18.7B772F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 04F0220013
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:18:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g37SLZ0d;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776107929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zIokbzTNtWp8GkRHFZOrDuV7xF8pvhxSyEf5O1Ygezw=;
	b=FPXBmal2chM0GPziin2erfGR2Plv63N1I+Iqwr2mDoFp9YABwuck0R4TUYRSMF1P8ZYQF4
	a5zxGJvTF/j/18I9TLeLZjr7iIkf5MI2U19wou4SRTOkJ2j7fkkxMzxbIPxLDmzWx5dBa3
	6tcbe2rCBxBzDmJVAMTIr7meCe42XQE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776107929; a=rsa-sha256;
	cv=none;
	b=I2EeIciuxmmrRsqwdu7U8pSBlWVBO7YHYUDH9gF+dPvJgHIYUJf9AdGIsoyDeavyVyTpq1
	hBnF7H4rb1qFPwHmzibhDseAHNDnDRVSx8G6d7CqpIH46soqu6FBQTJTNx9WYtzkwjVsRC
	0CthQjuKgHbIn9XZjICB4gM/IoPZX3o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g37SLZ0d;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 497976183C;
	Mon, 13 Apr 2026 19:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A59C2BCB0;
	Mon, 13 Apr 2026 19:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776107928;
	bh=AcZH5y/sksxfUnjFv2/7/AY+KkFJTJM+xr4WzntFVR4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=g37SLZ0dd5wJ9W9WB+ULAMRBgiYRuHKKy5ZZHMO2KlCtIfk9/PlL+95LjkW6D4YWb
	 SFOM9wikoNG78Z9IgQ7FF3sxX/REtFYNeVKHulN9mslS8BIDPAvQgF43JlxefN9HdX
	 YMwozu+vWdYGX7IK8soLAOjKAooqLKTll4laE/seKTvNKvSIuGlEALCwQt3t0C/zy1
	 AGIOD3SkQLT9WujGNEWD5rTHsax/Uf6o6g9nOur+EQSEMPy5wwmBhG2t1UzabFV8dU
	 Hkyd8ixDo67Osd9c3J7g8biTLeAJauSkWTL0vsImyTnaXI0yfZ19h+Rimd+u6/VxJr
	 4dUEAzVvLkrSw==
Message-ID: <4ecb45e4-0501-4e12-9a1d-ad1218f5910b@kernel.org>
Date: Mon, 13 Apr 2026 21:18:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 0/7] mm: Fix MF_DELAYED handling on memory failure
To: Lisa Wang <wyihan@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com,
 vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com,
 tabba@google.com, dave.hansen@linux.intel.com
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 04F0220013
X-Stat-Signature: whnixo1hhu4oe9yohbfgsb7z6cgxox45
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776107928-663967
X-HE-Meta: U2FsdGVkX1+eoBNfQpF3TRxKl2UUCCAk5c2oD07ycyR2otM1xuGB8MhGnK+5s0cFReXxYkkkKWt7bTDnE7tT87byUJB4ius0i3r+UO46ZY8rJEPzDnFIL/x2FfUGaAmMAjx0RZo2e6tlNGITzlnEMW4HH3OXHJ3674q3R1aUCREbOeYZXs7lgwhY+CK/cwcBneSe/BcNFeHXRLSb3UmHYJ+mm2IME/FFB0F0b/rXQdklpL2vDrPXFpObOhU385LPOp0+eJiWAdbNRWg971SH4fiwZgeq2yW1HNb0tJFOMBhHBpu8tJdWN6cAiJtDECeczzs6FLKof5FQ2/XECxNdBe+7KdrDKUAC8vDnA/4nVJZZ2Cdw7YrMrysAo8nWmza7+upQ3IfsGl1T3fWQ2TuTkTuwZAoab7ZaFGdzxEFtZHp6NZ1WnlUkdSysVZFpv+nRCVsms0sG7jDFyaKAYZpIlrsvNwR/vVANLmfRt6HvFLCptpuwApf/sPWFbAlA4nBkcwCb3MTdqfJsv5V+kN15AANN1mb/+ljeUl6z5C1fVh5E5oaPQeHD2/P8VCktGUZx65cIE8mAgIhK3Z7ys4fBKgNdC7wM+LI66hwGYx3eSyI1VXxEkYLXlCqzO1xPdsCCFflbFJddK772XXNP8Em84Dz1/aDvSpl+ViGDzu7tg3V8E1EWFKdYwkTFwThsggNrNas32mCWkT38afmatDBVi7Cdq9+E2AQ/0jQNa1vP+PgIBRUd2ItC/FaZNW6nLndR8qEHY1qqN7jyTDaLwBKkazZXm/Pw8fQ+3cARYzfm3b7hPhe6TTC5tMP+18viXzsJ9Cr7dE6nthQufVZOSwYslSTDaV5NoM2J3nKp1jNA7ieIc4EHJdnHSBjgTOvW3jxr9q1e2oZxUUt1hjz2u2+5MPIdYoriVzu+jYXdJwuKEF6sq/YyH4GYW9I0UNsOPav4paoJMH3RQLmpPtkm+od
 qoXaJXwt
 ytK4dTzgTkVl+r4KN+W65ggJ+3R8kgGt1h4RZUPoJ7YhmrtrjMZC/IluArxIstGkkWgxs1zAxAJsgyKWxdD9f4vHykw/pRDf4srfBOeQseY3QgGuERhlAt55hQwLI6jt5YZvfx3OLVUq3Ybga2AR+xgaZenkgEvXHAMOVxay0qzLlpXvYqAK9E0gYsbN2PiQ8PAJOCM+CTc6L5QtsHjnIKnC1KFBfP6lVkoUdxU0mtWUP3Zhb3q3MLvS27QokdE4RwUC+fAd6jrQ7gxPFyD2vQRpVb/E3Kp3qlogt0oGYyPPJ0rG4T0mzNSbEDB9TB6bB6s1fB5eE/T14EIbj+cw6JNwzYZvz7n4jstswntRT7jBPKW6QILC8MEI6Sdh80hEHntipHRBw64pkOUWR1HTVbxQc5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 00:30, Lisa Wang wrote:
> Here's a second revision to fix MF_DELAYED handling on memory failure.
> 
> This patch series addresses an issue in the memory failure handling path
> where MF_DELAYED is incorrectly treated as an error. This issue was
> discovered while testing memory failure handling for guest_memfd.
> 
> The proposed solution involves -
> 1. Clarifying the definition of MF_DELAYED to mean that memory failure
>    handling is only partially completed, and that the metadata for the
>    memory that failed (as in struct page/folio) is still referenced.
> 2. Updating shmem’s handling to align with the clarified definition.
> 3. Updating how the result of .error_remove_folio() is interpreted.
> 
> RFC v2 is a more complete solution that includes parts 1 and 2 above to
> address David’s comment [1]. Selftests are included for all the above.

Skimmed over 2 -> 4 and they LGTM.

-- 
Cheers,

David

