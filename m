Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C431FCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04C126B00C3; Tue, 26 May 2026 07:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3F646B00C7; Tue, 26 May 2026 07:56:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2DB86B00CB; Tue, 26 May 2026 07:56:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D05C36B00C3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:56:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D309A040A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:56:41 +0000 (UTC)
X-FDA: 84809419002.25.CAA8171
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id A8F65180007
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:56:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bqNFePwh;
	spf=pass (imf16.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779796599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e8JaNo1vOaK+r4fFp4lVpergJl5Sjg03Po9hQ9chJkg=;
	b=fJXCWCWUEfD/oaDBY7lbG02Mf3+xBZGwieIyzmUXRWx7dnRFqAKkSXXTWlruVG2IpPkohe
	xYWJGJgoD8WX8gL/VKQ/3w4rTpBzOMxLanCrQ2uzYo7tAnP/uyjPtDfWZgHnI1gS+IFwNL
	mk9DrC+7KWPo24J6UgSLx7r88KcWeV4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779796599; a=rsa-sha256;
	cv=none;
	b=L5mh8dseLYF+fn0HEL4bHCFVfZyXSPT5FSFplmmxb2SD2rU0qRm301+AnbpGqQgXJqBfeO
	KSnB3bt1KLu7/xktLg9cLn/nN3jK/VQUotAf9VPNZNylhG0fzW1TPymHW/DjoZfiYFbpuC
	RWIM81hwsNuUSCOEiETUFVlwD236+q8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bqNFePwh;
	spf=pass (imf16.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ba17c8cfacso109870665ad.2
        for <linux-mm@kvack.org>; Tue, 26 May 2026 04:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779796598; x=1780401398; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e8JaNo1vOaK+r4fFp4lVpergJl5Sjg03Po9hQ9chJkg=;
        b=bqNFePwhlI5IYOg2J6xDq7Cr1iJcpY19FvkxnQ4v2QdtDYw/LX8E9rhzcsuE7bfJjZ
         4JxQ+9PYyYgJrBQni5QRsZcqagf1J4LgFNDdtKx1H2dez9k8WlFR8OnOtqA7paypssPF
         eBMA8Seh3h6/C3wQsFppbN04NvvB/9HlJFj8ZOUuTp+Olx4rEPofApGTLIhNvjuQj2Qu
         7sMVabUpSc1rjawjWcIdd6fXlUIbKF8lHCI5JwuduD0B9WJNpH04O2BVK0elc5CXCQlF
         W2XVG9kHuomV2J+SDW7IcFohS9vz0njQNXlerv6T4oUxylHFZ3w57wbtNLbEv/oQJVAn
         wx8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779796598; x=1780401398;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e8JaNo1vOaK+r4fFp4lVpergJl5Sjg03Po9hQ9chJkg=;
        b=qtjgqGN4U2CLoFuKrewUJZ8yEgDgJfeuiLYao6iWEaIOs4wM8nZ8935FTuAHCgljkt
         Db/NiM0OQ7H//zlHCDchjbJs4VfFLF40tFKCMHFwajKgW3/PFvn+ll0HW29Sz0peJPri
         0mYxiNmmRSZt1ibOIETHQReeKD+IOufNN9LtYrhq0MqUBzfx4bIpwyvntXq1d+QCH7pO
         VizRfx9WDBxXf0P8reNqJrNK06dQ1mp5vU/P7Om9gn0eAxpGfAITOZGDQp188zwgPCT5
         AVsNverHbx/JepxvwnyuKSBrRGdj9K+HSqT32Ojd29loGg6pn6TegVIrYneBqrM2GUn4
         Ibsw==
X-Forwarded-Encrypted: i=1; AFNElJ8ON1p7E8M/LewNiNpdFJHkjePMlKkcS3XyQqfJ78ne2SdiNgGtn3HXTU/uQOLLwdaJPdSqnHAShA==@kvack.org
X-Gm-Message-State: AOJu0Yxf/e458mvooLCEM2fO6p5AhbMGrj5xf+cZv73ZsRIkej2EWtKD
	NB73UvQTCZ8iBBL+WlBZ/pRvl5V172kbtAziC+7BVXpzEA65PSkxVaf4
X-Gm-Gg: Acq92OEqJLVfAdTZ4x1Y4PJqtfTmeJAqU4L7HYLV+P6KSOxghjcKfAIEO4Gz8L6OnN6
	HvPXTcqhLGlDrw0Y3tUoPe06biouidcAFDNO53K87PiI9CJI26mgG27Wyx0YbJquj+eKOgwk/tZ
	/yK/N/GCyFzu11pfUAOWVLlaqHobdtcBiYQwMaYN6k1Xod5kvEq0bjCn2PtFU+5czoclT+/9b+E
	X9YisjFwXSmPEcB1rlAdea2tiJixfmERatYNulHyYePohymN9s1ARdVHby1CbQyXGkQA+QQuLiy
	DI+w9yY7js8yig+kehllR9MRdxzEJxUfq4dP0Bbg01ec8r00M83aIqgIJjo0+J4xbXxIW1xO9Wi
	HCP4km+1QLwkeFlEDoPXbgtXNTM8zheJ+6RsNKhL/jzavMoJxeveSb0gqSMJrizilcaZ9OLFkDR
	Qti7F6oFpu4xRFzm/+UFzyqG0s1V4mfr6xGfUXAbYajZ5S+2M1MdU4NeY=
X-Received: by 2002:a17:903:350d:b0:2b2:4cd2:e162 with SMTP id d9443c01a7336-2beb065aa18mr205863945ad.34.1779796598367;
        Tue, 26 May 2026 04:56:38 -0700 (PDT)
Received: from [10.125.192.130] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58b2cd6sm126864375ad.52.2026.05.26.04.56.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 04:56:37 -0700 (PDT)
Message-ID: <9b2ac88c-a67f-2512-d898-3dadd50ec03e@gmail.com>
Date: Tue, 26 May 2026 19:56:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v2 0/4] mm/zswap: Implement per-cgroup proactive writeback
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tj@kernel.org, hannes@cmpxchg.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, yosry@kernel.org, mkoutny@suse.com, nphamcs@gmail.com,
 chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
References: <20260525122242.36127-1-jiahao.kernel@gmail.com>
 <20260525122424.3b2818f06832d9d55da8d69b@linux-foundation.org>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <20260525122424.3b2818f06832d9d55da8d69b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A8F65180007
X-Stat-Signature: oqxfg96k7k9ktbyipi7atyyt77znnj3t
X-Rspamd-Server: rspam06
X-HE-Tag: 1779796599-999689
X-HE-Meta: U2FsdGVkX19gdNSXU4H8wwaCgWaZnKo0AEFQuRv9XgL3iQhq0ywxyRYZqLPnY+u/ZzFaKu2H5HtJDCXnj/I3Nb02VEsdtFSszO54S/efEBhrPVWAf2BJS19dCt4edev+cSnTX9XWAcWvID79YA10SkVF208UhvFunDIpfZ2fQvo5sRcaN6PegbcAYuYzjRrbighOh7z4Wj1baJKR+DXBaH6dvRmN9hY5PD1UAcWK7edvJYS3vgnMThsKZ6mmIgJI//6VbazOm4uGGOJ9JruIpd75J9Fq1Is1BMXixAGCr27lf4nwEjt1AhDpwIN4pbbR+vTcJJFO/8rIO4rXGwQR43LPNA8tbZ2Ga1KZQ+HDkTCIHCGupJ2AvVGeVGmKqoFZIKwG2Hu8YsIPw6ljGzw1egn06utPVdJXMmhLPBx7b0rJMO/lKny7zMJtrBkK8wlHKJ7W+EP2uyEXfYISy7oZeb4LLSExudYJ8yBR1Xg+j3B2FfbgD5ouHKanLdQgWhMOY+INTHB6sabso7yyCW2IQxo9ToNAwNLea2KEML73KIdg7gQNymZNkmwvBrMTzw/m+FqwZpzR8Ih2DtmlEHvVOUefKyRvxUjt5LrqV0pfNjcxA/yve/t1cYyNom72LvVPG6imuex3vex7gWX437tylddEHABI4NXSXOiCYxoauH8LvxStyrC+AFKQ/Tb1YYyJ5jTjyo94fRKn9YkZyB0a/fzZPuwfEeX+4ELuZ8+G4uv8rUGFE/S7zfJa4yHK5R6ukAYrnfmbiRqZKbu07dEbPcdk+4EAdVaWSPKGAUwzyYKccyPM42E3Q/lPoub4uhQnxj9MhU7lYn+jG+Qpw9pd+ERuRYMZjxRV2yqhnpAHP8EVtYxeGyZX6NXbFLyXuwVdTBuen6ZTe20tmcliq6VuebKF/Pib306BpR3TV8GD/Z/Q+PJkO+8/gS3YOanrvXsNJpstbypZ4VdBjXWnVw7
 KKw+dn1x
 Y/u7ia1szYdFuP5nJb5N9f7xgastSGLwa45IZlN0gXpYdNEw7oJJShPl+bqrKI0ltfH1W367uEOPgZe8nmb1lL1BZlIbAT9EN1LLmOLezNR/D1g/EslgZkK9nCDOX2gZVhv4aPTt+094ai3YOLp6Mkga9RxURHrD+O3yWkSmaYqNDmHdsz83nQ/eWfWmon7xRK3hlJT8EnyDXpIO4kdMVfv4QTZIxzzvUhLi4bSPDGodoVRoWw6aill63NuI+pbD6DG4L7wdEGK3X1LnIKwoWWq6MBYuBItw09VpiC5XYnJpcFotwWEsZzv2nVJ6/vt+OqMN7jM6zzpR/MTcsgOq74HANpETRyDzn/ZtFa4K++RLfnayAR6/Ur3QuK6WJlb0YqJ/j8IFYhCHj0WXPb+ioVBjdKYwslZpDxSrgwCly7pEI9CFK7k6d2z3VCI78dXn+DHfHBq2KQd+tn4RhZM5GIyEs/r2bj+iGegI7jiNcY79FexbUM5pp5vroO85KDvcZgtDFX1SuQVWmmvGRTz13BZ06gRQIQdYE2FAzihKGCGCxhADB2JlTg15bExIFB55Css+x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/26 03:24, Andrew Morton wrote:
> On Mon, 25 May 2026 20:22:38 +0800 Hao Jia <jiahao.kernel@gmail.com> wrote:
> 
>> Zswap currently writes back pages to backing swap reactively, triggered
>> either by the shrinker or by the pool reaching its size limit. Although
>> proactive memory reclaim can automatically write back a portion of zswap
>> pages via the shrinker, it cannot explicitly control the amount of
>> writeback for a specific memory cgroup. Moreover, proactive memory reclaim
>> may not always be triggered during a steady state.
>>
>> In certain scenarios, it is desirable to trigger writeback in advance to
>> free up memory. For example, users may want to prepare for an upcoming
>> memory-intensive workload by flushing cold memory to the backing storage
>> when the system is relatively idle.
>>
>> This patch series introduces a "zswap_writeback_only" key to memory.reclaim
>> cgroup interface, allowing users to proactively write back cold compressed
>> pages from zswap to the backing swap device. When specified, this key
>> bypasses standard memory reclaim and exclusively performs proactive zswap
>> writeback up to the requested budget. If omitted, the default reclaim
>> behavior remains unchanged.
> 
> Thanks.  AI review found a few things to complain about, one of them
> described as "preexisting".
> 

Thanks Andrew.  I have replied to the AI's review comments in a separate 
email and posted v3.
https://lore.kernel.org/all/20260526114601.67041-1-jiahao.kernel@gmail.com

Thanks,
Hao

