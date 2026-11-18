Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28965606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 10:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HllsBS6e
Received: by kanga.kvack.org (Postfix)
	id 3DCFF6B05B3; Wed, 18 Nov 2026 05:10:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3ED6B05B7; Wed, 18 Nov 2026 05:10:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27CA26B05B8; Wed, 18 Nov 2026 05:10:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3AA86B05B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:10:53 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D74268071C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:10:52 +0000 (UTC)
X-FDA: 85447821144.24.FCFAAD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id DD507100005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:10:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HllsBS6e;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794996651;
	b=QKKkcrqIMyB936/QQ27/CJtoOqwa246YktuPL7bfy9plI1ljBEzyEVzQ2hOVSvXwdABvwk
	nXI9lcLggYyUnIUV9REALJvu1e/lYIYgWestDBl7qmoqCstj959SoKtNaMXiFO3+iZ4egi
	vY6Te2M7KEul5r+GYk/khWGWOKu/s3w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HllsBS6e;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794996651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5xQ2uInXZNMm0R6AQn2LPL3rDrnpuIT1agq9O7VBa0A=;
	b=AWutDP+r1IbX9cmyD09ozuXhZsue25kCMR5wp21TpZDBsGoDbnQ9LafaWG6Uhpk8LnCbpf
	R2pfDQoUcsLZL51yqDjEi6SsfC2aoyJMIwJOouqfleAvkebkiCy3Iv8Rj4Bda0aClKl72J
	r/0b4ylnPlocGei6Hn49UGztOXubUJM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 125E045B13;
	Wed, 18 Nov 2026 10:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBBD1F000C8;
	Wed, 18 Nov 2026 10:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794996649;
	bh=5xQ2uInXZNMm0R6AQn2LPL3rDrnpuIT1agq9O7VBa0A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HllsBS6eEh3h2hm7iSzKWXKDhZSKfZFbSOL4EvlBLLjbfVzybvCnjlX3BBbTQKv9H
	 4f5i8la0iI006jW+YPVH9Thkaj33eA5s6+rLD6IPjhtjHgQmhIF6mSRurwk1ERRY/L
	 VTKsAV8mESstu9DYLXSdG/CynNlMGVri/hOP+kYm7FutJj94HfXyTe1bnhAGHTAjx6
	 4JKIRJDezEfobxJe5bJlGNs+mU2ULYfKik3NP+Lijue0jwlMwWbjjuzHHdyKDRDAuB
	 cLQRVqWnQ6n3m9czgQM75ViKqRBAgYh/SeU9r9D2+sarp+9jKD0aHGqKiJ8efNWxiW
	 5zDD6SoLkPbHw==
Message-ID: <5541ef01-f9c0-4ce1-b77a-5bb81c6cfdd4@kernel.org>
Date: Wed, 18 Nov 2026 11:10:45 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_ext: remove unused page_ext_iter_get()
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shivank Garg <shivankg@amd.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Luiz Capitulino <luizcap@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261117-unused-sym-page-ext-v2-1-900f4c3c6856@amd.com>
 <e745f91b-3312-47b9-965c-510bf0a0b7f7@kernel.org>
 <20261117111336.ee49c0d4722a042c071c68b0@linux-foundation.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261117111336.ee49c0d4722a042c071c68b0@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tp3pufqrffoqx1q5n7kfxez41h8m3m91
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DD507100005
X-HE-Tag: 1794996650-33912
X-HE-Meta: U2FsdGVkX1/kP9o/uMoLTtWRZRYgsBAGTmt1V8WkxzJMXgLuUONiS2ehoBTSnqGfEThjx1FB4bU+Pg0Bhy7shVOJmZjL3iUdHeh3aYxdlUNeIAdOmNATsQKi5KyaB+vMwYBttcB9qtTsbfXRlGeNiBW3YXWVURkmVBD1cdQeeuC2WSPJtLROpmps9e2IcTjvOizikYqVwRwUuyrSokZm5UlecDnrdTFx5EV59CZbbhXx5EUMqT4A41p80Wd/nprmY5d1sDXfHZZg5f+vapmmBntTV+QKwh9L2DD6y/s7mCT8UFffjPoM8L087K1xD0rhTgWg6wzrQ8FkSSMLgktQzW2Ui894Nkm6awZ/thUM4XT/oLVbBHZJo45Upym/x6V92FkQFO2s4bg42p6vx+lpHaWyvNm5Y6jkNxXTvMZ6zVlPulR4ndc4FjLsEl0N1xVU0GZwwqkFkvCC9gOZHm4ONPhB8IJSN0kQkmPKLrDK6bZYAl88zQH1qsEUI4AoDnx8yt//xk8rKI+3aVj/KJP2Ch1BxXcJaF9Br9sfiRr6Syl0q0G/4qbd2rNPBt2wIvW5lm5Ur/PQmGRJSvDTZkSv17esANCkbUwq+l7UajGNyRoIWZOrQU6FNRgfY+lsuv5ZS2xQMwnKufUB2ZoRhBYmuq69xDsYaKcGVXdtUNjw35XnQxFNM0L5yNQfWSukxxw8CSumUqAwQbqV66AY5WNLBdl+2mUHP0lxq7bVHhA6wc5dtBbJIwr/2SX9hXsDu4RPrxAt6J7GfYXFTXWi8sYWSVzTVnu8lyuVugV3Z5v8eS77FL27wx9hLIfYDLHz5ppC+ZaRDjoR8fEm7U9IHoRJYrtJxhP1qhX5zTWHldZIaEqF2e5OrSFTY2mJrF1D5g00d8EpW9RZ2L1I5HNrdh73vRiHboeXmXZjhXeMF6Hl0hYUR1XQ48U7x6Chcgdz8TtP9O5yPNkjdudv9llFfGC
 ezcwnpn2
 KU9kecw3ktipcQ2ECwB+Lnjn5D5c+QsEQXzR7JOwOuRKByBTEvmHRh5JVYNMrvNAtjbVpMKbUp+hTnau+nyI3tg2bL+qvmWzZCi8JoIMwrCYiJZCFrgxnI8tnuUUBnUajsUS+pguUHmbLt8P1zZZjxF0kGvGEAo8d+IhYLg/EVOozebsajbxe8Okx1R+DcGLDxrdB2N8lHLOqm92FFGMSXm0easkZPf9icDn5XAC+P26xtYri2MMsT+pYoXPQuNQcuyeGmjyZcnMj3xQGHWsIRcyN/PMIDqP5+rxLKTXxqtlWnqnlNkQC6FBmmKRK441MOrDeATMxoRS7vInfsTmbpubiIuSqZF+H96sjy7O4L3kORBdnyHIMs3mbPcbIZzHw0UrmeUdMz0o/SSr2Vi7FyfslbRrx3hrK+Xrt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 20:13, Andrew Morton wrote:
> On Tue, 17 Nov 2026 19:50:09 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> 
>> On 11/17/26 17:26, Shivank Garg wrote:
>> > It was added in commit 9039b9096ea2 ("mm: page_ext: add an iteration API
>> > for page extensions") but has never had a caller.
>> > 
>> > Signed-off-by: Shivank Garg <shivankg@amd.com>
>> 
>> Added to page_alloc.git for-next, thanks!
> 
> Thanks.  Helps.
> 
>> Hm page_ext.h should be added to the PAGE ALLOCATOR section. Wonder if
>> Andrew's patches adding various missing bits included that too.
> 
> Nope.  I'll add the below.
> 
> A few things under mm/ include page_ext.h so perhaps more mentions are
> needed.

Thanks! Stuff that includes it are its users and not necessarily page
allocator itself. Nothing jumped at me.

> I'm presently carrying no patches which alter page_ext.h or page_ext.c
> 
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: MAINTAINERS: add page_ext.h to MEMORY MANAGEMENT - PAGE ALLOCATOR
> Date: Tue Nov 17 11:05:44 AM PST 2026
> 
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> 
>  MAINTAINERS |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/MAINTAINERS~a
> +++ a/MAINTAINERS
> @@ -17779,6 +17779,7 @@ F:	include/linux/compaction.h
>  F:	include/linux/gfp.h
>  F:	include/linux/page-isolation.h
>  F:	include/linux/pageblock-flags.h
> +F:	include/linux/page_ext.h
>  F:	include/trace/events/compaction.h
>  F:	include/trace/events/page_isolation.h
>  F:	include/trace/events/page_ref.h
> _
> 


