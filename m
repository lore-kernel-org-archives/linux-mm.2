Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A520606A884
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CrUGS9BU
Received: by kanga.kvack.org (Postfix)
	id F12556B0692; Fri, 13 Nov 2026 05:32:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC35F6B06AA; Fri, 13 Nov 2026 05:32:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8DB6B06AB; Fri, 13 Nov 2026 05:32:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A99D66B0692
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:32:04 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3000D16023F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:32:04 +0000 (UTC)
X-FDA: 85429730568.13.CC3DD80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 689821C0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:32:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CrUGS9BU;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794565922;
	b=relVGejW1wXKO1KGy895LhmVZRNcWmKnU4btvv7XFC/uzhJspUHt+MqIP1OVKkE+2RHcQT
	lGio5qxhIhiJ/nqofS3QFEzVG50OcXHYVnK3IEYZ9pcvB3AqwyqP0QIeUjnpQNQ6FIVwAB
	2XxUr4vbR5GoL/snmJGLM5uB/0w6h9I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CrUGS9BU;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794565922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0AOvM1AEHayqB8TEve3c63OyRu4aFfrBPOIl8gQUPrM=;
	b=24kXDt6KJdu9oas49FPZD6BuvBZT2RnzG21QB+q25lP83CzaKfx9Grixdnh6Ht+6nDCi0B
	j90R/Q1asLx3hPbcIYI5wG4L+jEAoArlVpl6tr/BvnVIUo0Jl8VkuIwYJwhaZy1KyPH1HQ
	Kb7H6Qt8XHH7yg6dqzcc9y0YW5Jyo/4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A253E40250;
	Fri, 13 Nov 2026 10:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCF51F000C4;
	Fri, 13 Nov 2026 10:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794565921;
	bh=0AOvM1AEHayqB8TEve3c63OyRu4aFfrBPOIl8gQUPrM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CrUGS9BU/rUrnPB5AROWajb/swnZej+tX2vIYgZgcX2f0j3R9J0BkjIeEwaPdyr35
	 wmmgqH0VIu0f13VCTImEDpD1yQ1bnx4NmM9z6T8IabvC+Wv2iZbR0ilp4QD0cakaJ/
	 EsdC7vzhAQKWOOJV4qwqNUAw3zbXARRN0RSWA/WKzZFPkanR1+4C6umTyq0TinwUZk
	 nRlYW1AHFW6fLG0ykKeuo92lbe9HjQiF5BFwqaJ4j3tNMmiVKmvxgASvU1Jja0kT8h
	 dTS5fsufpyYrnW3hKQSwuntHkyjcyRl1LpiQrXFEY+kZjqhkaIE2V++kev6/2mY/dy
	 xRwofyWVsRasA==
Message-ID: <fb5ebeaf-2e3a-4d5a-9fb1-e86c1f10252f@kernel.org>
Date: Fri, 13 Nov 2026 11:31:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: mlock2-tests: fix fclose(NULL) in
 is_vmflag_set()
To: Hongfu Li <lihongfu@kylinos.cn>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: hongfu.li@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261113-for-mlock2-v2-1-f62195fc8394@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261113-for-mlock2-v2-1-f62195fc8394@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rb1sgi1gozc3qs1iqw6ujmkhx7e4fzpj
X-Rspamd-Queue-Id: 689821C0002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794565922-387320
X-HE-Meta: U2FsdGVkX18B0hOcH2E6UnCh5kWt6GjKVLaMVwgbqvYiYvf+VzHwHZB8lI3YuxGZK9rsOTi1ViJ3p8HBnEjUMCwIrsHuGro9/SoesN98QpXdhGTAb8+5bGQ73ai40ANjAxTJvGudvphLR2s7bJjCq0OIYdDPo1AlYGnAJvPqveF1gsPChrPAPcn+A2FaSyXaARWa52bdwsgTgaoIc0chd7jt+Vw1u/772ieugk/0RfnY7iCTXxvoKBI4yJD/tTlFzgjwVZqIGiwVsYbXzXpzxqcluawWofKzgPSSSb7quh6WrCyAkB3ojSYu8QE4rMXxaNk/YJXlWvld58SUfijkwk0QKSI0GH2AfEMGsqJoexOHk35IgrVKe+9nakpmYtLLtRJ/2yk3wzbU29sQ/2p4bRMgxzD6br/B9HSfw6ZPCKx6UnXC2FnxZ7OgFnPeAZS9UMXcCp8OsJDWEDw74FWlYxK8X8U5IVwfqRRQWdc6klUNjAgxG1CxgzaUXyKe7A+KAxMS1uYJ54CdItrqqkqMCipyYcYNyNMEblN9Umat7CdnFr8VEzHmDNlCB5inDVVlxGZsPaKQ1+hokqXUL4Yu1OvX3MJBhFecjpMRUzceoZVrNBoJaa4ZYp5jNWOQgdw0uKd5PGwkfdiVMMInsqI074Zur51cmjWu6kGnATpWoeI/1nh/ECxivP+g/CDRhE8V/iuksY7ezZqeO+6E+A9kxhl7zDRoL0xC39XXo0Yb2HW9krzZIgeCuDUEf/KGcYGz/OaXRqZ629PG/ZrIrQ7ormXJNd//elBHYSmtNemfIdqXPxo3HYCzAksAD+G4IiYIobjgtrsMqa0pmtnhgGSQWiDIbT+29vRs/r9qg2pIw7qLZIT5tnlwXuncwKmnK8OjHM2+SD51+Za7dWz0RUq47BSmd0JWyDtXiabXxtxAQaStkXvLgq01G81d8BSclm9EuAUgiXeskYZeZG79wpE
 qIEcIORW
 WeIXvtfZcpW3Vlsfpe4bc7hsy/nKQS2GH+gTIsWBPEdVY2k0mUfSJcYVaJV+WBusZNoQLlkMw2UUk6UXO8zQ37Hl7pjpWRpywS2F/bMXcFKy+J3WaghlzxXUQZaLQ5mnDrrFhQWCYvNVHVdo9mioDKPgem7cgwZLglTOh7F2xay/jBlHrz6rM1a8Fd7Gjrr9zwGpiQ9ueGVkm9RuL9VeccQjHLsZJrEbzFs8TjI0Z9eg5u+fFMR3EPVR1A2rSgszBapaeZQhRX5ocQLSYj31gDZWxriSI4KAMJhthzA5CIbuvpqIli5LnUkOlBsFFV6KE/EvkOhpsWZhSB1g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 03:52, Hongfu Li wrote:
> is_vmflag_set() jumps to the shared 'out' label when
> seek_to_smaps_entry() fails. smaps is NULL on that path, and the
> code at the 'out' label calls fclose(smaps) unconditionally.
> fclose(NULL) is undefined behaviour, so the test crashes before
> it can report a test result.

I was briefly confuses staring at get_value_for_name() diff below. WHich is
clarified below.

> 
> Return early on that error path instead, so smaps is always valid
> at the 'out' label.
> 
> get_value_for_name() follows the same pattern. Return early on the
> seek_to_smaps_entry() error path there as well, and drop the now
> redundant 'if (smaps)' guard on the fclose().
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Fixes: tag? :)

Apart form that LGTM

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

