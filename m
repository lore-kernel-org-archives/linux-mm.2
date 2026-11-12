Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BDCA606A882
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NbgThZtq
Received: by kanga.kvack.org (Postfix)
	id ADFF56B00EF; Thu, 12 Nov 2026 12:02:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A90F96B05B0; Thu, 12 Nov 2026 12:02:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97F346B05B1; Thu, 12 Nov 2026 12:02:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 714856B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:02:07 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0B48C804EB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:02:07 +0000 (UTC)
X-FDA: 85427084694.25.03FB2D9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8C98E2000D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:02:04 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NbgThZtq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf31.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794502924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DmDJ9JjueJiTO4ILc4vU5r+iyjWb6VUgLE0oIyUYePo=;
	b=lbYGb0f3gJAjb0bmaN5rpcNFAES6AmReaztS9U+hjRl6Y5fvt/n5BSMtK8FEyNyH3/RhkZ
	R4ADmcsvCSNwIsqv2o8l/oa7tYx5/8XlHdmudwsq+8YQyIib3shD7gB46PeHbYyzvela+3
	IP5RrTyCULE2UPLd4R/iDReFks3juOE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794502924;
	b=6OlOMhypSYMYdmfdJks+1TGEHaoiHzXOf/PdVAeFWwSWbKuIjOlzVaEx1L8s8D6SVIlWKX
	O5FG1PAOV5G78pjySJHCVJfHmUXqIkGSXhlBkc83Iz9y9A6v6BIHtq5sgSxOO/2hKAI6im
	wFoht6N+zHwRXVe7ir8CP5wa53lXFAo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NbgThZtq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf31.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794502923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DmDJ9JjueJiTO4ILc4vU5r+iyjWb6VUgLE0oIyUYePo=;
	b=NbgThZtqeFV9bx4CyRB1XE7qvaI5ffj8VnlmJRSQyIOkZpqST/MEjNnesHF+mWyarNagVM
	nb+AxKQZAnRCZWuFSMIoC7Cm153N6Mhzk+YvNFFqfdu+HxhvESgHTCsehIlUukaU9/zDss
	BJZYl6pvFoQFsmhJknXEQs28gSl9kH4=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-oOLb6kVuM_KGeRJVW6DTog-1; Thu, 12 Nov 2026 12:02:02 -0500
X-MC-Unique: oOLb6kVuM_KGeRJVW6DTog-1
X-Mimecast-MFC-AGG-ID: oOLb6kVuM_KGeRJVW6DTog_1794502921
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5c157d39385so6295e87.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:02:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794502920; x=1795107720;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DmDJ9JjueJiTO4ILc4vU5r+iyjWb6VUgLE0oIyUYePo=;
        b=JJ335doHm9W20urQhnOs7beg3bLF/XJooxu9ah3dLlPR9/fNQkcJ/Td1T9KIMppzZE
         1jFv8S9Hx8P7vVpQ+TOpfUNMQfAzPKXzilxGGOoIXLKogqwLDgh3kU4l2BYiS82G0EI6
         JRqlATcLaGGAZp1uXLXhInNOT+1w3G30NxbLQOODj6gexjk08enc2vBeA3GknIbUSAcl
         ITuOIUyUDsIiMC//NgtYakJ/YLSmevIp/lScS2zkxs9AfGn8NAb2TtiO86SL/dwF0jkB
         YHa0iAXUZq4TWNc3QZ609mvs1Al+u0Ha1JaYNx5ySH7ofshPMJziTz25FuYfAxAjJ/wX
         6EAA==
X-Gm-Message-State: APuU4Z8P95Gi/O/SqEfn51xwaY45O6tl49iDgNCuFlBrZZ0taqb6liJi
	/L7SxrrON3UuYp5zD8L3roQ6+jBr1MOlB+KqQP7tN71n99Ekl20xmDa361s2bKMhmEnZri+59o0
	wZj8KW9ZP69JOvAzEQl4bIZx+bI6JWxIgsEi7ASrYGkr/Vv46ATM=
X-Gm-Gg: AYBFou0iEwOCu3dxcgR9RDWo9eWkPy6q8pKEbA3J3T6W2843sI9CxX2xssEE1qkbMId
	MSXSMRR/pbCyWTePaq8xVR5YaO5lbsQTyaaeKCfJI3Bh8mCyd6g/bnyaTxZaCZLuf9Qoi9v7mMC
	cFPXyMuaXyMmoCPCN58zFysqYDkdixxXzSOliuGu3N7T40oG+h35IPlvjxEae/6Tlrql94MA3DC
	wsvAVK5cZnmDLiBCEQYCWSqzDONXh7ek/GgcyR67yIhLZOyNZRWlriI2PQlIfabek0qFiHOSPs4
	Ue4cxu8bXKj6hlDII+sTdyLEXVMri+M495JlXdIX7KB3AqXp/ueewezCpWHIfQKcXSxeAvxtvH/
	A36uHx9Zq3dgdd1gj8gKPhAqIwHE3fnLqKrs7rD9hCMvDU4qnmls1nx5jWrbycnEvoiiFPgHQ+o
	h98lQX
X-Received: by 2002:a05:6512:398b:b0:5c1:4e2d:58ea with SMTP id 2adb3069b0e04-5c15d5f1e4emr2155726e87.53.1794502920594;
        Thu, 12 Nov 2026 09:02:00 -0800 (PST)
X-Received: by 2002:a05:6512:398b:b0:5c1:4e2d:58ea with SMTP id 2adb3069b0e04-5c15d5f1e4emr2155701e87.53.1794502920105;
        Thu, 12 Nov 2026 09:02:00 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c157bab834sm1779330e87.45.2026.11.12.09.01.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 09:01:59 -0800 (PST)
Message-ID: <ec4431f1-e70d-477c-b09a-eedc35d97691@redhat.com>
Date: Thu, 12 Nov 2026 19:01:58 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 00/12] migrate on fault for device pages
To: Jason Gunthorpe <jgg@nvidia.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>
References: <20261103061629.972669-1-mpenttil@redhat.com>
 <avWpWBl1nPcRVmpQ@raptor> <79f33ab0-2e43-4efb-94d0-addaf40745ec@redhat.com>
 <avXoJSGh5xjGFgod@raptor> <20261112164752.GA3692174@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20261112164752.GA3692174@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4ErMtRLfJG77k5sTzeaEM1UXOLlRYjqkLJ6S4gIIykk_1794502921
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5pfy19rodf4a9kkcdcg71grqqi5ooyxb
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8C98E2000D
X-HE-Tag: 1794502924-923644
X-HE-Meta: U2FsdGVkX1/F2yIoWG8oeyseGggYMiNhytU8kd6iilRWHTbSdjgZoaF2U5Q5PRlTG9BA9v67EcJYyVKrictIryRueqKxoXySQfRB0mWBkFqO1vYi4o+KpiKmBCJx+RMo9GxJxkW3qgZt5Va6s70O9xqc/ujeTpPo8WrcErdydqdTX37lNTkBBvVCT3Y2OoIfZYTXp1CaPc+Wl+nR3VZqCA6qAtg5NxbnxpURJebeNlg0rs2L5gumxz5kA5NmVzKCKq1qOIYURMdMXH19tnysn3K8bb/KgWo4ypHlNembwbyvJXvhyPGhntQVP8F2ogRA9qHhwSSl4HVAJ25lfrhSD5Pj4pEldjRtNkRo2pyIUglAL0tdXhLISZxE58clPYJ/vn6TfBUipsfJj8XFEk3a6sfIRT4dagJOHyVm60OnLkZ7Mv10qT5au7JzUIRDYfBPEns4oCOc0mLkKQRibW7/PqMFgsLgJrF+JpZHMFtBtONmU9dKNIMhgCn5z44tn0wITDicc+Y3BPQmh2r1kj6Jlb1hxWlhUvRbOB4IAgNcCMPX6WSeUAWp5FRsuGHiFm8Q5E7kRVtO8so9h7rj2WzeB66CC1UeX3FrbXRsa77vjYvAM2P0dEcu4RgauIujAbu50cjteowYG/ytrz7HVU4YtSyboxRvctV+IdHTd/WpIIPtfF0bbTTSasqVqhgJphyw14TY/T+Tdc0kKwyoBBk2sMSk89LT2ezkqKpGrrX954eaTDpBANzi5t2zRixFn6I2LkxKEgSXe8D2i5SacgyRZok3uSrVI21bUPeHbFUBBxRluYSqEqVmh6BCbMYeB3rKnNFqK0MTCtXGeh3XwM+s8XY0mwVxXGbbqQN6NFoWsOD2968iMbhfGRptOf+zil9l7zMgusQqBx0RyHf1XlFH1/A0E1zAiGbmYXNt0aT8LIYAnBk2rh7rcpnQ7WB5Vs3wZ9mbCnsuSGqGtS2Gxgg
 INQmW/TD
 nKRAJk+vKrGbInfo24hngjYoALuATymlsi8/8SH63IkCY3Gczo61sgwJ299v8Ti/Sppicdj8fLYAlmciEayIExF4aVbVLaajwLmaeoesYjZrVhVTFUY7ERuR5X4kzSSlwzZTEtzQSxakYhZWLPjeLnMXDltZzWn2K2/kQkct4U8qj6kI1WJVA0W5XFmRHVI3OrKjNUS3g82VPb4pe8NKtHuIm7IXzXXsMSEWH48qNiAgOVd3xd0kWF3pSfbRc7Y9E2yNgZm2s7CS1TYAdVlw6Tapifhfdna2ROrOXGrq84X6nWGvCS6uVp8bo+xPQb4mnI93Z0h8aScWWYNF9ADguqOI3TZGNNFK9N4Bck+ULbm8WLz8/lT5EjG5PBcNQuCQvmUaQqzTPnlKufHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 11/12/26 18:47, Jason Gunthorpe wrote:
> On Thu, Nov 12, 2026 at 04:24:05PM +0000, Alexandru Elisei wrote:
>> Hi Mika,
>>
>> On Thu, Nov 12, 2026 at 04:00:09PM +0200, Mika Penttilä wrote:
>>> Hi Alexandru!
>>>
>>> On 11/12/26 13:56, Alexandru Elisei wrote:
>>>> Hi Mika,
>>>>
>>>> I want to help getting this series merged, and I've been familiarizing myself
>>>> with hmm and device migration, please bare with me if the questions I'm asking
>>>> are obvious or downright silly.
>>> Thanks for the interest and willing to help! I am preparing a v18 of the
>>> series and plan to post it early next week.
>> The series is big, and as far as I can tell the MM people are hard at work
>> reviewing bug fixes. It might be better to wait a while, to give people a
>> chance to have a look? I know that if I see a series being reposted often,
>> I am less inclined to review the patches since probably a new iteration
>> will be posted soon. But I can only speak for myself, you know best.
> It is at v17 and it is still getting high severity sashiko errors
v14 was first that sashiko managed to review. There was a regression in
last posting, but also false potsitives, and sashiko reports same issue
then 3-4 times, so the reality is not that bad. 
>
> I've been ignoring it until this improves..
>
> You really need to run sashiko locally and not rely on the upstream one.
>
> Jason

--Mika



