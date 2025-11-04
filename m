Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 301F4CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 13:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E9118E013F; Tue,  4 Nov 2025 08:31:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899F28E0124; Tue,  4 Nov 2025 08:31:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D67D8E013F; Tue,  4 Nov 2025 08:31:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7009A8E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:31:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 01476160554
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:31:15 +0000 (UTC)
X-FDA: 84073010952.23.38B03A8
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 01FB6140015
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:31:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MLp5hTGv;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762263074;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjeVx5upmGvDCvd/D/8HOQiG/+YWUuqWjTBQNk80PvU=;
	b=zwHJ3qjncgeO3C5Jy2W1YqJdCTcQGvP77S0Q8qkhNdb+KMV8loTRquOtIVsRzRk5Ejz1c6
	BvgUmy2QcHaDu1PZh4levSKxexaQEY5jz31twNj2xUVrSD+0BIxYJCoxNS51bYnQpQHkJB
	xX7ZPvEHR/rzL1OIUGBSr3aDZlvCSdI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762263074; a=rsa-sha256;
	cv=none;
	b=LDlxiPnyFPfONb5XLrea7u5PDiuDQHT6dYjmMgkYBY3kWkO72gwjZIp/v8Fsk2VAx8NGFJ
	0yK0u7KRkr0asJLdQJFfJksjeeajhjGaX71HEQuKP263Ml839cB8Acg9dBei7Z4T8OPtyj
	wUg8/Gj9S62KFpDIIJvLlABNODOQfWQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MLp5hTGv;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-640f0f82da9so736593a12.1
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 05:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762263072; x=1762867872; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TjeVx5upmGvDCvd/D/8HOQiG/+YWUuqWjTBQNk80PvU=;
        b=MLp5hTGv9Aowvu1oWx0+TsFmTTc+wv6OcAf8T3MrDYzDwOv1+wAWkplgLeSxuPevgZ
         Eqji64n7osKuEFXuwrBy1mz0Nf//ONO1h0XD9q1AajhZIE6RX1yY2eDeb58UI7+7VbFR
         kvLRBKdXSBYDhOM5RwUvxpWmJNCJ5cSS3Sju5pvbUwW3cUyq7mmExZ+MLUL4LiQjjYAe
         nRSr0wHYit1v07/EdNfEARccBxe48pCnZtcx6BJZy9eEY/5DrCC6oFgGg1AldHK6rEIU
         ejNUsK2Mhay34IFSDicJ36tdo9HtgfiOav+c18gNDXizDMpU/BrtqNyn6uQiIeT0mM9T
         iloQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762263072; x=1762867872;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TjeVx5upmGvDCvd/D/8HOQiG/+YWUuqWjTBQNk80PvU=;
        b=YFcgfEzTuDHh9dUTm1P0ASusZfS0OzZjNQ7QnDYBbkgLb/1NinBQHCvsf86NrsvoTD
         2YqqQKKdS+mpyBrkbGDDgweqk+if2uE0lOOnUlt7RSpLp4gnCtI7fCC5R6SMRxEvMD2D
         5+shyNQJ1F8dc2B5pofpvWY07vXApHKX+6JTO8fOKBYz9moATEbf3IElWl29eH/iiAdo
         mnC/o8qMeHS+qTS0S/upp2KweiC/OFzWQiqcbjZAWcGjybAC1qG+YsoKamn9c+wNQFK9
         ckx7sy4j19CHm5MchcknbzHvwlbpCl/y5t/fiyFLtb8DrHk3WZl0DGC3rwtH3EfyJ0R3
         WY6g==
X-Forwarded-Encrypted: i=1; AJvYcCUJol+XrqtUVAzIxDszerjtepYYKkA59Ntc3uu5ZRtYQ89aJmzqKIXAnQHyAajKnhkf1CUfC6Dj4A==@kvack.org
X-Gm-Message-State: AOJu0YyoiW+Hcq1w3gmbFZtFux5bV06c45RWF53pfN71UjfZZpL2Y/tz
	0NaYc/SXcff8lkHLQhVIXTQFDLZ22TX7Y87xLPIfzus6X30IXipBBUs/
X-Gm-Gg: ASbGncvbLBUf1IHJl+xFwkGA5jmGpBwNXuZHG5ZUG7L5SwdrfpmEYBHCwkPNIncpdcq
	VF2E5Q1lNdOAGRpgCyZVzH3zZLEt35Fv/w91XpOyCnxe/jqRuwvducD4zdGtOSpItIoPeTNosU1
	m/RKN3yzdtm+QyokRizw1d3IgUT7XvAhkQRDYqN3M1iqIrCeVobZoNcm1fy5MybPWOtTFJ0NA3u
	6fuvjxme6m/6sEHINTmn6j9j5gEyPFUmJPfP5EeifNbro1cBkpIBSjl61152ALyWfPdSheL0sau
	L3wpf0XxajaHxlV6y63vJC4LmyNEvpDsffMaoFlWA5yCobuILtm5NnZkLg95Fl8TZL2ioHYt6k5
	Qd1BfpbdcsAW+PI3VNecX5rYVC+3AbkNY12OI1rJp+q1+lxbMTultuNo23obbFokfnglQ3UAXxX
	dWzfovCpjo0w==
X-Google-Smtp-Source: AGHT+IFSk6+I8oa7dJTSs5j4X5CmrPoNFKvqmV9FgrNX/uZNvFhStP4Ua5YQ/uH1ZCluwLIOcj9aJw==
X-Received: by 2002:a17:907:c0f:b0:b70:bbea:79e3 with SMTP id a640c23a62f3a-b70bbea7aa0mr662762966b.65.1762263072480;
        Tue, 04 Nov 2025 05:31:12 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723f6e06f8sm227427466b.38.2025.11.04.05.31.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Nov 2025 05:31:11 -0800 (PST)
Date: Tue, 4 Nov 2025 13:31:11 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: merge uniform_split_supported() and
 non_uniform_split_supported()
Message-ID: <20251104133111.doxytllwmxbjd7y2@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251101021145.3676-1-richard.weiyang@gmail.com>
 <f0fa3ed5-9cc4-4bce-b22f-883db9135a84@kernel.org>
 <20251104004111.3h5uwrwhoifshss2@master>
 <e2c1f4c6-6573-4155-8da2-689678fec697@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2c1f4c6-6573-4155-8da2-689678fec697@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 01FB6140015
X-Stat-Signature: 6fpj1xnht1z1yq414a9mxcy5zw1crsaq
X-HE-Tag: 1762263073-390027
X-HE-Meta: U2FsdGVkX18ydkZm+McUgg6ohANBI37vGvi18h9Zs/8OgZx3XH/5UnoxStY91fdh/0/CkXr13wPN8tSlW7zRkybIKUNTWkXg/fluS0SmtlP1gWVQvEWV7ZunlM21GCIGzQ8fnHp2Rx1XaZEfa44ZZnAusdr7Vq+3bMDXZ0GOzx9lU/+GIk3GzFnlMWM24Ws9S8eztRVKuHOSWEbQeLnGuBlLoLl9X8fVcek/w0WljNRQJ5dpDk9RdemSRTMoJpk7p2NRFPUoDEhHqpGusZKaJdAU03yBev4G7dfHMo5l1S7UaVeBVyg8eCnf1L2tL88ELA/V/YJJIbiL1nQDB310FVpOge4ZwLuwZN4VMCte49Wbi4JPR3OVjUqpOSoRRGIg2ZUEbMnECAcxgMNaAVb6g1K8AK3ZiNlEXDOpWH+bgj/0czEVX20SYD2xiDKhqnLwqkqQRt68yIiSbBNyz6McL0RbyChyN7AoGxmRMylEY4WalcGhuPIjIYtOMEmzVI2uPRYG2SY6sZprU7wvgTuTDl6EMOJTacqWO/ZmKWUDFfyZiDtD+HcK97V8Ea3rsEexiwPHZSLKXx+fc1H9i/9W4aB8Poggibd/ayDM5QJtn0Q/O02tqtgQnb++/QtMhYod3KnxW7JX7VEXcjzlHCA2OZGuzA8PzE1PIvBoA/fGwfggKHxLtCtOSkyMFRSWID5L3wjCE6wPxKxdJy6ZbQoktWu9+j3fR+FseopwYx9RJnmUZoEpYxcIB5IG41en3P9qXx6ahIFxTBU0IsMktM5Zz7h7vEaj4hSGayi6FcDnjLBOGiGryBdD//RfFFMFkBZOrmyP6ejo9/0FwDQ5DM7R1REMkbqH9X3ttAS7kA6x14b0vAEZKr70tUWuBCES6+AZyPF6uYzsxaxAeM6iUriiLhJGIEmdyrQcaxnP0Vt9pPmmiFqgBH6Y1zUw3gowFMie6BGXLoOT8KRWtbAvYFb
 t/dWprcr
 oo8Pp+dCCg4c+2zNscX23U6Qqbe1O6xkBHqDRLH6m67lb5PefwBCz4FnyofeLTk7duVMgBrrWYFV6Yklb5GAYo2gOeB9+wj1hcSAsN6lu4ybKRcqr7UnkGv3S+hUcYXA5VIb8vDcAb+Z9cQg3FgfIuR07BGCBkDJ9xr4ofKCEIJ3y81QMSSW/khpDY9leYzLR1AgwbDc8LewG+OOY68rXCrffcVB9gaOSBFeprSea+TKmlIHUOMVG7s/7Z26mFSWUcP1Stx/yb5g3t5+yuMyoasvfURn8iNGHYUZjgX2Uf4UrNjL24GmMa4pvIVdR8G1as1BdFcD+WurmQIw4jes8V+Xq5YQ0OhSWtgvBchBqRbvrSstzE058BdsnDsYXFHFLdq+xil8M2GVd3fWO5mnUtirA1N/2nrZnjwG3cz39D0QMfY49TeYRp+/wPQ1HD3sfgv0v/dT43CD7FnatoQNZzbOiL5CeUXYlaWBeNZyMva8bEP2V+aUK0DSnDNWiAUJC/SoVBMu+5xdqyanJOuLEUx+82EGOee57HVmzDSdP+3jTKErBjF3pIxm6mvQ0IiJLDftaxYgwpsz6Ak50Z/KYw4qiftRULxThjgDH2ryQ7zskugLdnfCI9+ZRvN/sneckjTzokQLbfRCvT1yssy/e6/L82CsxCJLUkjd1l92RAP2YY3E8gOqRSSH24wIRGytkMU6jYk92ya8a4TG/k3nvWuEqyRX/a7RkpSf0Bvj8Yrr8bKa/GUglBq74zIfGVTRkYV1N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04, 2025 at 10:05:49AM +0100, David Hildenbrand (Red Hat) wrote:
>> > Likely a simple
>> > 
>> > enum split_type {
>> > 	SPLIT_TYPE_UNIFORM,
>> > 	SPLIT_TYPE_NON_UNIFORM, // or SPLIT_TYPE_BUDDY?
>> > };
>> > 
>> > Could make invocations easier to read.
>> > 
>> 
>> Hmm... if so we may need to change the caller too.
>
>Probably worth a separate cleanup patch instead of doing it in this patch.
>

Got it.

>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

