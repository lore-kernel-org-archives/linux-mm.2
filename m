Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9528CC5DF9B
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60B86B009D; Mon, 24 Aug 2026 08:27:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38B76B009F; Mon, 24 Aug 2026 08:27:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4F576B00A0; Mon, 24 Aug 2026 08:27:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 781736B009D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:27:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0FA4DC011D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:27:22 +0000 (UTC)
X-FDA: 85136088324.24.135CA9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4027AA0004
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:27:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AfTqi6Wq;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787574440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XK6BMX/K8bxWE6uT077ZbVDAn0hz/OBQnd7y6m4pTRM=;
	b=Ta7XSDw4XmR8xTWpv3IWmhx+A4c+TXQuRcVE/MILXTkxVEvQcUeDT7JVUnoRkNfUD+KUSA
	ewObycnP7uK5BrRfe2HJJoYAcaf1lpwoLe1oLL6uSn4GwrePxxjy7zaON3IA/BAeanUMer
	n6ZcX079IvlOMAuw+Sioaf8wzw4USWs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AfTqi6Wq;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787574440;
	b=WtVff8/ivHaXbcyTXOmXmTt7Ptn2d1p19CAVxu17uEqwRg9shSNlsd954lzJ192CD5Kicx
	q5SZHxXL2Ku2moeNhHVc6VWQI4V63XMbEAdecumJsW70NRfELSCTGUap3AcqDKLwfxXsNC
	KjaLphrN8lKs9z9s4K+lKQFRhK1g0WU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3011343288;
	Mon, 24 Aug 2026 12:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111611F00A3D;
	Mon, 24 Aug 2026 12:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787574439;
	bh=XK6BMX/K8bxWE6uT077ZbVDAn0hz/OBQnd7y6m4pTRM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AfTqi6Wqzpx/tredHEiHgdezpxu/atudamHaXRBHm6NRUgIafPwPQ+Wz/NrD6ifsw
	 0umR0r04gOvd39aSEmPyI92xnc1gZihFKl1NKCqr3apDZSLuJfr/1YoqQI4/m5Y9a8
	 129+oTQW5is/Ki8RJqqaBmD3LgbLGefHU9iaYxNeqp5/FPpZlxilxKGRlV3dkR0q/O
	 NqDlo0rVST5z6rF9E9EfXhIxNhlubV9AdhNU/a+rHyVLAbitEUVwxCLMI5bY43UhtW
	 sh6cLagp/XihceuN5GwlhiAE0NcQSOLEcqU0nXs3uuPRHRltE+ZwuCfglPO5zFrbTF
	 NMGmMSXxFPBjg==
Message-ID: <ad6296f2-dae7-4be9-89ce-78a974b94c82@kernel.org>
Date: Mon, 24 Aug 2026 14:27:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/6] tools/lib/mm: add shared file helpers
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
 <20260813181230.483746-3-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260813181230.483746-3-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pwzygdzduqq39f3k9zxco61xqxt5owxw
X-Rspamd-Queue-Id: 4027AA0004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787574440-99277
X-HE-Meta: U2FsdGVkX1/i9GsfPE0NUPzdpFp1BO35JiOGjMMFsa561A61dmIKmDoKf/Q1vjUcrNfISKwZ8G9aL2rI3ADWue3vvlHxdIbjVTHS1I3UwukgHMHxZu6ykaR0cZ3WTwt+0zcU87B6MRZ/HSMf3JWvMSNOUl+ZOhD/v2EVJHH8SKDwQDSvPSn5PBBQe5CDnbztvEYxnzKrE4hdVPAQItyYdH6OFDbTa387EZuC47ZVbIYZkzXNkxh3dC9lImqbwU0REJz6ZUPboedCm64uFKLUa/z6IIeVeoTMXZvoAgx2qbdX3a3FcwF+qGeJVObCLtaT/346sYoa+th1WYASj9zc2EoBsshzyX9VNE1PLAg0f60SfYNDMH34et+FOW6Cc0S3b2/G9VyP97KFYeYwMTZkWEzNUwb5+eeQcgeAliOAreK7jzKA5ZJ1dSsOBKNdVarm4iKmYytfoRP63/+0iCltu5OX5ZiSXcrSO7qW1u3SW+9M48h3BRlU7/5f3Wf1p0p8TR751Rce1JUMD8QDYxJP1UYz0lANYzxENN2YJmhQ1GOCQMTwz5sQyQ8ig0MKEYu2VItyA+kJsqdHbjETpQ+I9aYBvqmU6iXHJS0zaeYBcFEPShJEyIBHBJDEFdLhsKCA0DiXZ8bxKKr9j7wqAbISJkqWDV5mqfMqsBuxWMCzezz5iUs3xvqdzPx76a7in1EANw8whyLQZtEshzlT5ed1ZYt2UHn6oPpMyhIYMHAhMbfyCEp8wi4ccwf0oJ/Xf+rNZ1byCg9dx6QITeETvIWL+r6BRjbS9D5GJg3gMJLxQNyAbbtPR7GxDRQLRuOSuNZfcw+mdTPjx3Y5nbq5yXseQFzddJWwSj8Bkf0kfSZtuMVKPs0c94FKoyWVVVol7qqd1Cu8dAbRU8vxJZqYbjkmFKshqAOR9m3X2136OG4WqYnw/g76dJaF2QRFQSpKqPd5l2C20NPdGGy0lIVzZTa
 SAP1ajBZ
 Bd9m9k3+OYY09qU8fk9vA7wwBXQ/RurqKnYHyfKVXEoEczGP05Qw4rw49TCGxI8gg11xDoiHX9/CeRPXcFudHwgKk3Wcwfb+o288V4zPW9paWJdnn7wPCuMUizfTZ2BUpGt+oytYIVNFskWnod4pVtC3GMPFKF9UK1oZTvNc2W0iOlgWFrUBV1OzWaBetjiyz77qvC4yLhWzAjS6YhPnAngvtpI0AjQLS70FoKs0xt9T79Mn5DgAlZCD8Pw0K9LIVWraKXibY0jzWSQ3Oqxh01DZgl5BkvS2EAqG2uWt0lx48eLmateCQMyZXal7gLf2BaAV9kY28XORXQsz1oqqS1/9uLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/26 20:12, Sarthak Sharma wrote:
> Move read_file(), write_file(), read_num(), write_num() and
> write_num_ignore_einval() out of tools/testing/selftests/mm/vm_util.c
> into a new shared helper under tools/lib/mm/.
> 
> These helpers are used by mm selftests today and will also be needed by
> shared hugepage helpers in subsequent patches. Move them to a generic
> location so they can be reused outside selftests as well.
> 
> Keep the helpers exposed to mm selftests through vm_util.h by including
> the new shared header there, and link the new helper into the
> selftests/mm build.
> 
> Update the explicit x86 protection_keys 32-bit and 64-bit build rules
> to preserve prerequisite paths, now that file_utils.c is built from
> tools/lib/mm.
> 
> Add tools/lib/mm/ to the MEMORY MANAGEMENT - MISC entry in MAINTAINERS.
> 
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

