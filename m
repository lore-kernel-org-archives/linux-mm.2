Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F407C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:59:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 918F36B0095; Mon, 14 Sep 2026 09:59:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2B26B00A1; Mon, 14 Sep 2026 09:59:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75BDA6B00A2; Mon, 14 Sep 2026 09:59:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9EA6B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:59:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D78091A015E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:59:09 +0000 (UTC)
X-FDA: 85212524418.29.E96D59C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 228B01C0002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:59:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CibaVAqP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789394348;
	b=PDkZavyGB4NzwIv+mTCwbZsyNsOp7tvvln1aVDJVp5+bZbVhnNpr2Rzm/IdaavwPrwI47i
	z1S1s9L6GKFDThTlX8RmoNfw03IuVrPG/RvM1aBANxuuEvHTelyPBiEMhI6nQn0pjXIbuu
	1pcM6lRURXlARrEi4Zh0oGSFFbv4pfw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CibaVAqP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789394348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9DEU6QsyXChy/GNzbkJuNaSb8Hkm06ZCmsscDaeUHKc=;
	b=nEWUQGYh4LeBlqe9SbcW6Lye/i5en8qMxsnNO0GOHwtDv2/TmIyOs8s5WAOKHdLxTOCMgX
	LXo3pw73OUyXH6mgSIVkIatNnjgUlzj+1xMGXWuYUxEzz+ywlI22NfaJmzXSclwoCmaRli
	3foYJbpY6kqPz5HTEsgmjgv+GoL/twI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 63A7860120;
	Mon, 14 Sep 2026 13:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DA81F000FF;
	Mon, 14 Sep 2026 13:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789394347;
	bh=9DEU6QsyXChy/GNzbkJuNaSb8Hkm06ZCmsscDaeUHKc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CibaVAqPIiF/6RRTs79s4K8eiz9mDHOvYrBjBHoXQXg8uD7COKeiH4kxt+ve1ygC4
	 3FLhWybNVg2rVs2eI1XbR4YbzHvFgLPoMDvZrVtj9NVzbW0RXnza0/gpGUUFo1rt6b
	 v1JwZn4gW4Lk1DCw7J94hAR4e3GdJwqi1OJ784ONbUCMH1n+fvFmG6h2BqoQBWjEDm
	 szq3ulHIdtoVvM+L74W4URViePKeV6PCkoFHEQwqrQX7nM+gr8HRq0H4LwIbHzthNe
	 CBZU4qXHOZKE9nkzph7NzQ0e/3PbYeJrBJibvyglzdMJ/pr781zvji8od5RYSUIeq5
	 /pB1vNK2fpVsQ==
Message-ID: <56f1171f-b7c3-47f5-8fee-0320eafcfd2d@kernel.org>
Date: Mon, 14 Sep 2026 15:58:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/12] mm/sparse: remove SECTION_MARKED_PRESENT and
 further cleanups
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <178937914266.4188640.7965323974267420342.b4-review@b4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <178937914266.4188640.7965323974267420342.b4-review@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 228B01C0002
X-Stat-Signature: 6bsb81f43tuhyq5x4js1r8tgqk3xzzas
X-HE-Tag: 1789394347-688029
X-HE-Meta: U2FsdGVkX1/XPeXTds2NSf/jk7kAmcK+pT3yQ86cAfIMa8h9sbJV7mp94Mwma+XfgVS8lAZgJ6uVBoHuaxG2UpQ1HuOKTvSnN3jfVF0HtS41VgFgrn26TY05zl7URmTTen7vfGUrixe54wKe4ciy3Lio0rwx5Gbq00nIj1gsQuZrdhr45sJWHo23ZvTYIzK+eofnj/jH46s2RYEyWuztuGRZbncm/0tSi3tItej5LKmBHxp0IsasXrkEupPc9L1wTO8Fy0GR6p4zrl4N2wvRad/FfWpbWSnZ631XBa3WrvOk7xAvDyWKF6DcXojhCpVYETE9OOlVk4QAktrggHjODFUc5T8lkwm5dMyVbaf6viRw2n3BlJom8tFZf6qVP4owaMsLhbK92lYT89TDm62xlAe4wUnGaR1e57COTqeCZzLJzD5YUrJOymL1gB87IZwro7mrsNVQ1idlsTndOK575FLGPrvAulqRMx2Vw2lo5isQLNlB+sOCJByuyYIgUZzm2aOQpcfLaKnfRiorYWwDv7BLlIw/1xrqlTuIWP0UAVsdVCN9XpQnTJ7I1FejQAZOWX67ibYR8J3xmHRU0zpOIZX4Xl/hvXfUKAKqJuhwlCqgxznrWdY1n4xHquz9N0fk78atPVc1PuQ3JcHo4Cgb9bYl7aNC/Dhm/Z5PVp8eP6uICrygYjogQMmzBaBN/QLPnaTpglbBz5WGZI6HC6pr6TGG1PE5sc+X0BVyl6j7riqcKXqjcOJ3LUDzAOtcPEHzjTBQHnxHGND4dDsZWS+LbAiKvZA0l/eUQXOf5ept4rPctQZjctrkWVluP2uBpXQp+eK95Ihd+JfxtADPYx4Mo1+gmXj+QHS0DYwi4DQ+nJOo4m1r+q2qSpbLpKswsleoLSIKdSK0tA5Qs9HR+QsAGS32JNr/j+mlc1XoYLDZ3MhpqlDMy1Juy/hKQcftMdvxustXi/dFpSzyS+yg3ge
 L1xA0GPb
 BHhD0DeMahVck6dN+t+0RAJAaTA5fUMOIYVcvnAwSrdbqP+4cH7GGUJ5eX4eBBtn989utWlGAtbLIciXRQqPN4GWBO6Mt5Jo3+gj7BBqZzBQOuuTp9CN41g6yXGG8DeMPUzEQi+2Z7BZxV6tf6UV4tZ/erS8DRxfGQ9ueS+90Gcx0b5MspAbDNukil/bWT8cplfdqlJtGlngt8MD+JDw2UtXs1XFiTlKqqDTkKMTOOHjnPPOHcZLb/oPM0aYc7Kc2G2WxAcgwg5jlwQQlNFEosihC4OhuAVfdlxARNcR1nFteR+EFxwvyEOnMUa9QQJ6uWwXfiiJfR85+PT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 11:45, Mike Rapoport wrote:
> On Wed, 09 Sep 2026 15:32:53 +0200, David Hildenbrand (Arm) <david@kernel.org> wrote:
>> mm/sparse: remove SECTION_MARKED_PRESENT and further cleanups
>>
>> SECTION_MARKED_PRESENT is really only needed during boot, where we
>> can instead just rely on SECTION_IS_EARLY_BIT by setting that flag
>> earlier.
>>
>> Some preparations for doing that conversion and some cleanups in the same
>> (sparse) area.
>>
>> [...]
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 

Thanks for the review!

-- 
Cheers,

David

