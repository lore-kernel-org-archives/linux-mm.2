Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE6CFCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 02:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21E8B8E000C; Tue,  7 Oct 2025 22:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F64A8E0002; Tue,  7 Oct 2025 22:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E5008E000C; Tue,  7 Oct 2025 22:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F15808E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:32:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 949AD1A0338
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 02:32:23 +0000 (UTC)
X-FDA: 83973372966.15.DE6CF95
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 99F7140005
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 02:32:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ym4+W1FS;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759890741;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/BUNqIvOfj9iMJCetj83vbCo747x6Wx1mviFMlMTPOs=;
	b=GlsiJhrR+2PIkOEEBFXVrcSRhfK7+YfJ3jDth5x485pwtM1oBb69iiYPtkw5KOzSiAWfoU
	IMuqDzk7vX2PBn0CypsVy5jKmGT32ScZE7Kv+dTislUXaNPBvuGcB701YIUcDc2LwyMSER
	bKzmeNdyVO5Q9lvMzzodKMEioSeoIsw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ym4+W1FS;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759890741; a=rsa-sha256;
	cv=none;
	b=f73YU6BqH99BaYEQSujJMv/Sllv5YR7tcyCu9BFdKvWq+bmeB44jkC8EsrBgSaR8YNlTjH
	hFlpPctDQHXVEGx8i5fKDE0qpgH4h9GCbdDpUQYQWTmY8urUgX+AGCtFftSJ20ZvGPujJc
	VHIWa5wDheJVbUC1j7yqed/aVzx3bGI=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b40f11a1027so1250204766b.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 19:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759890740; x=1760495540; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/BUNqIvOfj9iMJCetj83vbCo747x6Wx1mviFMlMTPOs=;
        b=Ym4+W1FSCCN/s0JTUoK7bzVjIdDDqP+2n7IHvu0FfAmJG1HxFGoI5Bf6+ArBqwbpOF
         5HEEQijcNi2bHxbiLKirc6+9k9xM6J+TYSsAG/BRtEIIWbU/saRDa/Aqz0tFzjNBQ/UW
         U+8NvrhcZpnzJRxBF6GUnw1BtdhI/7Sor0liBcWBl6egQYG+ylR+vCIWjbmPtCHNDiUv
         HwC5WZz1UEemskgT3f1mkzoBoR70tdEf/Ai9yOYimZ7BLtCEq3LQz3yYZdB48X2LbCMl
         QHBehBo+QAxDCODbd9ul6hYVsNSkeESiyuJ9lgFCT8sP4urQlbx5mNuYFmcS1GKLSVMS
         DSpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759890740; x=1760495540;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/BUNqIvOfj9iMJCetj83vbCo747x6Wx1mviFMlMTPOs=;
        b=Suqm97/8qaGuUg7YfIl73gWZ4rOK5qQyQvR6gFswJY0gydXCiI6Z6fsioIz2yL6xij
         AAVLi58py6VFasgNdLRsckA8ZUWA0nr+PQE6JLlhj1m2cJmTRRHTf6nApRtfH5cJKQD9
         +L41qMtwyYfrYSCfq91XAUgqyRqfb7Dvap8dESlOk4zr4o7wk3zzLB4MHD+XPE4dOlml
         30efd6ogidRQaos1fTIYxMj0zmSVw6pVyHVTo5KH9V61AtCv+aK0H+Q0iyqwVj+/pkZs
         diz9a+snvFoKfAK9IJ1ocWXdeAh41cDV74r4//A7b9zCkKqhW3fokboSVDYepUkvLqIO
         K8nQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQ+IsV4FnxwDYnpIJ519cMcHmTnQIMxdTg6kId8Fm3zXJlVeN7RWVebMoJ93GxWoDeabBokiyThA==@kvack.org
X-Gm-Message-State: AOJu0YwiNa+YaJN93x1jf1t8bZlmYylRlTHeaG0YVJuv/XxSdp5dNMx1
	WoaQk5JTfv4qeFyRDoIrFPJm9b7LEdNUrvn4wQq8zJmZG4iHZ/i35/It
X-Gm-Gg: ASbGncsYGCF2oBojg1FQV2Mf9FwtZYYA2SyiCu6EDBuGsYr10o+ee36qu0aLR2WjACY
	ii9ChB874jotKagmqnQBP3KxWqzz1OAIO73H0/J15SISY7jiFPYrwLkV8zfMVdWWjI4A9NBrGN5
	hnmDc7gsJZycu+rZ9ciOAgSotf0vrEkP0fdpekksZf//sg5XbDj/J2FtJ9rJTeEpLFpJKQ1u4nN
	EHmTtBWzlBWfIn2iVCjvX8umgHJOuLc9i6QmE0oQj/ycy+W+fepXRuiCJhBEkFs8qIrkhsMe0AJ
	p1eW08ztzFex1CVqvwN0DUaV9m6hSOEGyt+ILp5R7wc8+G7mPRUscHSNScEy46bQTy6h73pPrp0
	95swUjRYOB4tTH1WonSA5oFXyY873o1JZFHoaSSYTSOVYVeLjIBFVowKII2L0
X-Google-Smtp-Source: AGHT+IEpdN2mu6mCsxXNixK8+rPuXeb05HlXZV4Qc9dnyWix4k+bGFLX5GR1Oro+qfuBgaInbakILA==
X-Received: by 2002:a17:907:6e8e:b0:b04:6546:345a with SMTP id a640c23a62f3a-b50ac4db267mr179963066b.52.1759890739794;
        Tue, 07 Oct 2025 19:32:19 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4869c4e5d8sm1515624366b.82.2025.10.07.19.32.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 Oct 2025 19:32:19 -0700 (PDT)
Date: Wed, 8 Oct 2025 02:32:18 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, iamjoonsoo.kim@lge.com,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/2] mm/compaction: some fix for the range passed to
 pageblock_pfn_to_page()
Message-ID: <20251008023218.g53gm33vmrdt5nw7@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251002033140.24462-1-richard.weiyang@gmail.com>
 <20251007182922.4a254daff78633b1452bdcc3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007182922.4a254daff78633b1452bdcc3@linux-foundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: kxxgjkik6s6jou8jeo7b6pmd6p187rtc
X-Rspamd-Queue-Id: 99F7140005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759890741-108598
X-HE-Meta: U2FsdGVkX1++oiXUGmBuP6mkReuhGFL/AEeQiYIBCyk6Z+G3AeQyLlYqshdwqNHu2iQ5qKsG/J+X0CtR70JOd/05iYVCSHkhYzc5BrC5HF6n4ty4JzFkvia4y6On+7yaA79FX9d2wgOqGzBwtTtMfKi1Oh62hMo0fwN8zh78og/YKpNc7q5esoT1icI5jI28HzuMldirtYC/VxRh0+ISktc1QFlhjcCT8godcTEUknsmq+hus3Vs86dJpK4yFvF43LcNgJPPCew1NtE83x79yB1jkeslMdf74onJA1NkyyKsIYrzuJppX4w+8GmQY3fP6h62bbaeQFRdhHtVKvAvd+e+hoyxw3T85MxLMkTx9PW4PDX6b3buzVmf8xyZw2rPcXOU+aBCjtBYS454TXoBPFcxwKDuRf6E8sqUGb8sLBzjLxlfLdBbNdPEf+wjCFjGWFWjhuEUB025l9YgMVHYRwMj8O9YlWixu10QmE9EIMLwxtS8EtDsw1MLgpBMu5uN692o/QyStc4KT+cekCPoZYHNgcHW1Akzsz9CCymTIedh68gX/77H0vwhQIxIm3r7iIYsMdkfD5nfPJvmzkiooJm0pDxfX29mrnO84aFsF+yF/v8I9jwphTn/LtWNcNkMDjj1JonR8zmTxV96rBma6hSuiImHU/N3Wm/mSvlpQlejNsH2gqtsPjhW+mgBdFaQeZ92i0AMMHC3GL679ECHUzEFV+3y6a8MLSqHe5jYGwpd/c2Q+QD1rQzlz7D5F02lvNKKfqt/e6on1tJpW+IqTGJkbzZ7YKNscmOUm1ghLCwONW6jKa4kduOf3/jCJLXtJhA2dTerpRTAoHCf7aIwKL967px5VvfXcimtv6Rt3p0vFAARe2E7DS+ogTUcBgAau8EFAoh8XGNql8s3BeaDeCzfQ7clBvMEXZOnRvYFce6/p0MyII6lD1z+FzdX24LqmW8DfZOboHdNyUF99NI
 OrQVI65N
 h2n6HOMMNk4IvUrrlHT2/RA8IoG2qv6EXz4n5YQBW139U6LXKcvJOb3le0AlkH96kPttKI/KgXnr4BqNlELK7X4a2oRmq5+9QyFQVK8/3SRZ+aOCRLPjCERFHFN5vIzOYOsdV+TZBzi3SioO0eSfJPgR3NO2HpIs16CCuf8cSwVNI+an/FqPhF7ZZbkEut4l2g023vTGOgb1feLCrYMG6C0eqCt4xCrTGhpJO5LSzKiApshaeoLpVFFAA99/k0emWxZREz5L+UtIkh8tFcMPrkbauhryt7hQKLGsOXMosU1MedMAdUUh3RE+uYI3ek/bmyedsJ4zwbIj2HhAnen85hp3pJY+aGsKW+kq5m6Ka0dehizWyZP8Dvc71Fd063uWuaRChX0YAE+QoWisCsiHlceUgxEtC8IpUn1W34UrF8tIu/ttg0G3ipNf219ka9plwniPKkTa75bDtQOfGA63yNyuqWn1GC1y2DooL+Yn9pK9gh44hmQ3B6tV4DZXHqa1QcEulxNcsXqoGppAV9QDgb49rAU6onZeuM7EthrBe8SFlnIwfX/KmI2EluicHNi/Z4obbkiWlyo7TGYES2gCfFNnbHS/yhd/oNGEcmN4oYaKRcTjKqVwtJIKIzmPQ48y1qNxs00bx+4mn//BtxTyNzuRJjETk4jQKeJwRUI/QinlzilInE+4TMyXFwelJML0t/bnuJgZDYUDGlgIc3sRL8eWKaH2zrnloPCeMdMeoUKcae2DoaYpWy+HA55AOam+i2nYbYfRv5xkWY1XUxzarfZmGUgQ+IFKMGKZ04hoz8tZVLmgOZMRwPXQKSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 06:29:22PM -0700, Andrew Morton wrote:
>On Thu,  2 Oct 2025 03:31:38 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
>> During the code reading of isolate_migratepages_range(), first spot the range
>> passed to pageblock_pfn_to_page() is different from that to
>> isolate_migratepages_block().
>> 
>> This implies there is a chance that pageblock_pfn_to_page() thinks the range
>> is in the same zone, but isolate_migratepages_block() will isolate range in
>> two different zones. This is not what we expect.
>> 
>> Then I found pageblock_pfn_to_page() has an optimization if zone->contiguous,
>> this means even the range is across two different zones, it will think the
>> range is within the same zone.
>> 
>> So introduce two patches to fix it:
>
>What do you think might be the worst-case userspace-visible effects
>of the bug?

I don't see userspace-visible effect yet.

Since I lack the knowledge of the consequence of isolating cross zone range,
currently I can't tell the effect accurately.

The worst case in my mind is we put some page on a different zone's freelist.
But I don't totally understand the behavior now.

>
>Thanks.

-- 
Wei Yang
Help you, Help me

