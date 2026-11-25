Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A71D60A261D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SlO3gQTD
Received: by kanga.kvack.org (Postfix)
	id 838B16B0998; Wed, 25 Nov 2026 05:19:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811446B0999; Wed, 25 Nov 2026 05:19:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726376B099A; Wed, 25 Nov 2026 05:19:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3936B0998
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:19:34 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CEE4DC0E19
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:19:33 +0000 (UTC)
X-FDA: 85473244626.16.619D9C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 11F6E40002
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:19:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SlO3gQTD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795601972;
	b=jaJ5p0gY1Cunw2slu8HiKtNAgZp+RhmpaOaqaQPmEvwzxXEOt+X8NdkWrjw6TMCC9qWrso
	Y0XLweXSFJ7BJ4ThOlE2I6kwFdYquQAAVF95EiF+Fj+FELxVP95GOv2wBrfNU0rMpF5t6M
	3fH2eq4fBGdMshJLb1MCUMw6LM+kxeE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795601972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A8K1+nUfZGzWQoYLt14zgQq+vIWgX6A19PV0LXI1Njs=;
	b=Z3ijz7Y1siCb7ouv+AqYxh3AcvjO/cUYvHCobs/+g8eN9oHAADNszBrf6+c9nnHieDbDMy
	NrqpcrMpKXkEc8FsLinZYJ7vP4zEczb3QPt4Ciywql1PMCe0hbVIsajPM+K6d5fms1YKr4
	2MNLjfFCbrjoJEsMtaNqe+9YoiBs7ew=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SlO3gQTD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E6A5609D0;
	Wed, 25 Nov 2026 10:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E540E1F000D1;
	Wed, 25 Nov 2026 10:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795601970;
	bh=A8K1+nUfZGzWQoYLt14zgQq+vIWgX6A19PV0LXI1Njs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SlO3gQTDfH/XH9oJ5c2qoNMJ9dKcJqXpVbRKfQrSwxJ6fwQY6u5CXqLbH6F9wF21w
	 5TcmLUPb/AOhs4Z2igIdzvBcj9Xi7PGyTLosQFBj4wyI4h7xSglVnMsj4psh6V2um9
	 fQDkkIJVU4+Xa1MnFp5BWj3Y5d5QJnh+p5vv+LkcPED7DvSIkkrXqfQVCekobPPrUA
	 JAWeOaWRYW/Eil2G7j+Ke7Lh9N2olb8Q+SM6gP81YztZrQRhSuLNEhB0FSmwSUT7vE
	 /G8zqW1eQZa++Xg6zUzPXer1Uvms5vGAE7lstVRwThaOjnukiUxbTSPHhq+fdoa0Q+
	 MpMSYxs/6mnOw==
Message-ID: <d088452f-1118-4a06-bc16-1942e523e0fc@kernel.org>
Date: Wed, 25 Nov 2026 11:19:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/5] mm: GUP dirty + ->release_folio() fixes
To: Christoph Hellwig <hch@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, John Hubbard <jhubbard@nvidia.com>,
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
 Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Peter Xu <peterx@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org,
 linux-nfs@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <4f096d70-6f94-4148-8f47-242b8551e5f9@nvidia.com>
 <awWNyDZT2SVu2Zp9@pedro-suse.tail5790ac.ts.net>
 <55114986-0ba1-4a80-8498-bf674d64e01b@kernel.org>
 <away88BuU8ibcTA5@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <away88BuU8ibcTA5@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: e6enr89kkrujkgexpdj7faqs7fx3b8ah
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 11F6E40002
X-Rspam-User:
X-HE-Tag: 1795601971-561014
X-HE-Meta: U2FsdGVkX1/WI4upzioL99PVW1xV6yCS9dpN0Jx8RS6WXQcIwPwy5YV9MqJX3SjmLKd+g80DV/VJ1UiVXDgs1KP+RdY/6PGcNAkHRwd+L4bz5RIw2Y7U6vwJlp75eRF5spd0LEhrJX/SiMupY+9KEixJL3NCgYw5YNFIEkTstm8AEAv7agvye0Dc2LpRBsng/A7H5crc73jnCttoiXo19vMLrCJc+OfndAAk1HCDMMaS70IEFWHjKQ4DVPmjVHt1FUkBvIq/dEuJMtw6QGxrs8yH5Mwn+8U632xfp3ja/uMvK+G4XrXK4X9X5aioGoB8izbmBH0s0jOQ+y03yVN42JZhioh9vLQdnaY5nVWGjNJpbd/bNjVtUJaK0F6N9Cg+q8O8AbL9ZhbiDEFla83/rLYg3ek1CrYfsTpUfTPje+mEmHGmRVDDSEvXdEyoBwkos4WyHZRGtCAVwD197ofAlItwZAQDHhX21AOD2uPTtwyTWO/0N+ExWOW/Rp4+QKXO+QCUeETUNOC680oeu4AQMMlL0XGpry/iLMmef9KtniMfOqrDlLtwkYS25U2jscHX6RqLXiToElg5LnPQL45hxaMc5nZBZrU2gYtNna/iuM1/OGbHeZ8msS+3kwgE+xmkwpNRtu5PQm1xpj75P2iJE88poJfltzPlLHvXobKIh1P8xeXmbOC8qwhlKiS2wXvRdon/GNcGjZtxUWhbFQQriWJDStowE39vJ5vQXvUsFrWWKv1Qyrg01cx583JehrLW2g2/ZUECHkzMMewg/4eGWL3kEF+CxlUf19MvXv6tgSNaJ/Kp30SYBdlTFU7mONXYWcb1snBoZa6hgRsranq0gTEFIcIIvFhIf9HwHMeTWbKzQjKrw+fWXjzMjIeww/kR9cquoXdhh7KjoramF9360xQTkLk2FNaMWFMRp18C61h+s1G5GjvaSdiKE0lDwLp2KA5K/8DMQ/vIbdW0FHA
 uK0x4Dcc
 aQgGxCn4MzKACKhddZVSP2/TBmuKOV18VQhhNIuT5lV5gpxx8Vieti7VOslnw2YnHM3E/S3kJyvHCJWLSt8DahRlbY5nE84R5QHnMYCIulds9yUpuHoFrmhptXmsYRMAIRsKUIAjZcDNQh4+7rpstgRubt+9SQTNolWMqAoaXbKeRtCl8OOwHQoOgIyIZSuZR9PSqlFVonak81UG0kdpJwClyoiylYFN1rChIWvsyLlE6fo8kc46g74w+TPHPiR6aG6Bz/+oo2ITilCHnfS+WI7hJr9XXDfcJz4PJVMjH/Tj6Sen8rgB/MzKTW7ptphN5jjXTQmWoFcng1+HEniS5BFHPcqzTAFcybDK2XNPjV49/+TIP88/V6nUCZqPuhNmTGhl4QTdTof4fHBhYZ0UR9zy20zZm3dusagLjSIRykjmpIskA5GJQINIALdfdW7gjvSJnnjrLeACSLGDalfHsWXbmcbbYsI6acVJrV4iG1WVlIawDWx54xGPAZOKtimDYKBXo33G2gqlAgbHpWXGxXW1lXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 11:05, Christoph Hellwig wrote:
> On Wed, Nov 25, 2026 at 10:50:42AM +0100, David Hildenbrand (Arm) wrote:
>> When I looked into this issue, there were some problematic things.
>>
>> We have some odd drivers that use FOLL_GET|FOLL_WRITE, but I am not too
>> concerned about them.
>>
>> But are ways where unprivileged users can mess with  FOLL_GET|FOLL_WRITE
>> references to trigger this.
>>
>> I think the two that stand out are:
>>
>> 1) /proc/self/mem access using mem_rw() -> access_remote_vm()
>>
>> User can write to a writable-mapped page-cache PTE. Then we can race with
>> removal of folio metadta, to then set the folio dirty afterwards.
>>
>> I remember a good reason to not convert these paths in the past (we are not
>> performing DMA).
> 
> I don't think that is a good reason.  For file system backed VMAs we
> really need the pin to be able to do someting sane, DMA or not.
> 
>> 1) We fix all such cases now where unprivileged users can trigger this,
>>    converting to FOLL_PIN.
> 
> We need to, if not for this series then for all the other outstanding
> issues with GUP writes.

Cool, and I agree (that's why I placed it at 1).

But who is "we"? Because I recall that "we" wanted to do that a while ago.

(I won't be "we" ;) Pedro, can you take a look? I'm afraid the fuse thing might
be the harder nut to crack)

-- 
Cheers,

David

