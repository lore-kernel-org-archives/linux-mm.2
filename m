Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDB11606A329
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=lAXCbGu5
Received: by kanga.kvack.org (Postfix)
	id C97D26B05B0; Tue, 17 Nov 2026 00:07:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFAA36B05B1; Tue, 17 Nov 2026 00:07:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B115E6B05B2; Tue, 17 Nov 2026 00:07:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA0B06B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:07:39 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 204BD40317
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:07:39 +0000 (UTC)
X-FDA: 85443428238.26.04985BA
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3C07E1A0008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:07:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=lAXCbGu5;
	spf=pass (imf19.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.175 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794892057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pSTje/Yh5JU+r8doUCnbpH2HQ4u+A7cqXKEYIOCxoqE=;
	b=jz3FqZZZ6I/BNuDWrotNwDtXDZoEyvuiQVAIiYFAEHE1V36I2Oln7zbCtPGMHuZ3KiyKOC
	QjVRyoqIylJm4C7topl+NHkARXs/wAvqp0hmpuoVP51+31fw1EHQDu67w5Z9x95g5LeL2n
	G4SCRpzFF0t0V8cYcMMTRSszrr5ZZSs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794892057;
	b=qoHKWuNUAD5VxhrOSeJCIpTaKuQXcZYevpiKM9HZdfVUIW+Hq2KmbaZv/KfTxpBFhVI4fM
	ekUen3CzoM9HyhB6EsQtubJGf9kIIZOcDDkK24/4k+9HPOXyuAQd1DHilKozAH3LR29bdD
	UepJqtmkEiICOGDD+LZEqrN0wZfCK6I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=lAXCbGu5;
	spf=pass (imf19.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.175 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3791619605cso7800841eec.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794892056; x=1795496856; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pSTje/Yh5JU+r8doUCnbpH2HQ4u+A7cqXKEYIOCxoqE=;
        b=lAXCbGu51FO4erPR6XZMmG8Kpmg4CKzDVc4K9Qi3WqeabV4VfQ5jfA7Gv1ySeMHCvp
         6SSqMmkC1AIdtj7KjTDyHiY1Ma5r3Exk2n8KY+h0q0n6i9UD/cFrfre8CdL2NNLZODbb
         HcY3k4bentjpo2EPhLwQ9EBGDBkWubtL3YvkU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794892056; x=1795496856;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pSTje/Yh5JU+r8doUCnbpH2HQ4u+A7cqXKEYIOCxoqE=;
        b=aa5wrpJiyTnZi7BMbLzw9jIciuN7mDu5GuE5s87dEAfPSXoXe46hM+wbTEbImZ9bwZ
         mFhUuvErZVMd4DKHfWGU/fX5L1TlphPHholhan54BGjdh+us0/E4tOXxuS5OlSth9dv3
         T5JVr9nCy2KHmz7/4dSOkS1kiY3U4FAzX592/Wl5v6OAIfUBvD/ymJKhlXnE8naxXcmw
         Ltc7OcZRM4GsBWrXcUY02Kn2gwG7MDDvcYT7XvCNDBPl4kdrLtsBEnro2Nvc5gyHIeQ5
         1O1UrRG0Xs4SYfMsOEcBfpSPgaj0ebL0LiIls9bTQj783lDmnydEPPwOQsV0SmA4SrKF
         2rXQ==
X-Forwarded-Encrypted: i=1; AL+hErGtB1rQCVKHS4PPMltZPZ8wU74cHoC+BnPxHSzLRqEc8T3eFoLHAbVaZDCRhg/Snm7jzhdeZxjVMw==@kvack.org
X-Gm-Message-State: APuU4Z8Ghb8oFMXEhftJey6aCTzQxomixLtATjvAjzEij6dE6rn6G35c
	JOFD83oJXuZoRZ2RiLl3iOUT+2GZeAPNQwER2AO5iYeV65mXMnk0r3/9EywAngY1db4=
X-Gm-Gg: AZFdTZfZ8LB9FEM8Ry0UPmJ7NlRijtf35mb9J9F97Oy59hCddTTAJAnw/98fa5N+bQN
	idXhwf55ZDi/caM7TW4BvN036CjfZfsi8OUv4D5yNLIN0SWhaKAyHhqguFBwQCUoWwS5bNHP4A4
	3b7A4nty8TdcV3OQMfXgPlOiQszqbVYH0IJKtzF7UPXZlGtgUpEB9q+m5WX9hUEDWP7jwS9JZSX
	LV1dIaP2yw0chQlbo1WpoE6P7qpLGc/pRU/sNBW4ff639Du1RDURw53v5cSwh+kLpWzOr47jhrG
	06FHPC7b261P0gaZ5kwpkOGkZEz8gKJSY9VUU+Cx+nJFdupjWoh/y+Ofl98iDTV4mWt07FuEtb9
	/pUUIbXZh+7fw44/kFIFTvjM3cyyxHo9TJ3d6OgzLIyC7/BNcPS0tuJUeomGutj4eBV2r0JvW7E
	+YaLVl/m1JwGYc+ttDqy/g+6cAnjZiu85sRzSp5D1msPfzerLpTHviP2BWleJFpq2GDrHA6kYBE
	SAPeHbRIYn92uPN8NokcTQsps9l1FPaI/z9N2hBGJqWm1+4Mmhzh0zX/OkkixyccXvicDZyWsx7
	AngYlaVQ34YokhffgIzpkfT3wPDAnRneqVkvX76mT4X4Ti0P1XGZxZASrx784vz3iHDhi6oI7za
	tpsjcmq8mlnKhZ7rB+j3YemGQHmDBbov4QUab/EKIiuSUhhuLuHSo9huvWBF7OqK5XfFAiNXaUi
	5/uQ52p7l0S8whGApkC1+2XrcNpa4DJU+9diqoQodD5IlxqOwDUfupBVm1CFXEKOFQ
X-Received: by 2002:a05:693c:2a16:b0:369:fa21:ba0b with SMTP id 5a478bee46e88-3796721cfc1mr11998596eec.33.1794892055979;
        Mon, 16 Nov 2026 21:07:35 -0800 (PST)
Received: from [172.20.0.3] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3797f98b9b2sm37051807eec.6.2026.11.16.21.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 21:07:35 -0800 (PST)
Date: Mon, 16 Nov 2026 21:07:32 -0800
From: Chris Down <chris@chrisdown.name>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, yosry@kernel.org,
	mkoutny@suse.com, shakeel.butt@linux.dev, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, ljs@kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v3 2/4] mm: memcg: read root lruvec stats from the node
	counters
In-Reply-To: <20261114002822.1043378-3-joannelkoong@gmail.com>
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
	<20261114002822.1043378-3-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <avvhFAxBcPk5Q6pW@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3C07E1A0008
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 141r4iyb4a8tdi556fhrxs51uxotxs5c
X-HE-Tag: 1794892057-48003
X-HE-Meta: U2FsdGVkX18WGwXkUw+1GJiS0YSqZ6ef8DanHyyR/9eYx/DNYHiNky8pjyHXqd+PXUzbokDOKn/zoguz2MESueVZZOPnZeZQQ457aomGefTlqk2jB5IsOcRxAI3XAiB9lgBGbmMalGoEHdZP4uhsTivnuxvLdgOl5U95igyYJbGXZJ8zEw6xwZIUXtovSceB6bpxb0J07QHnrtIavdUSiJGE9CoGAv/O2SB29R0iaIhBTj0aRSbR/u7GPqyyw1PV0baAL5CSFwGzUxIk+BDNHVXEdktwhWNGUlXmeiQIy4Vjyt9WmG2oEDQcC9vrfIUR4DL/5qK+IvnS03NwTklACmWOPK+JZbJ9ozqLnFOv3mbiYofEnQ5O1G9coQp9Gy3QKaLzBA4afo0f2fSbhLiwC0SY8WoJZt1zRcJL5vIowaQ29OxdNosz2Z/qXcQr34uXo0ZM6RpaAB9JdCTXfR98CXcAONprFD85GrF5d8oyXmuLeqaEMlsHxtSGveZ6j5hMBq0cAXG5qgO733vNzbkjPgWFTGGHcpRJjXsHTGpEMC8HVIKxU3wRGAtYeK7tv5OHtbRX0AHKn63etpy4Pk0CvowaMweHHKt9ZOI8NysaZpHCVmio1d6XHI64X/JKyUUsMAprsxIvktiX2gUA8S1cPj0Kappl7N1fxl0dJeJ3YpU/q7opE5L90M8Z8ZRIYOT2ZVcqjq6p4uyBqyGeVNRo/WQshuecB1RYJFfR2IZjWOwikjgJUXunVZ9/HlruLQ7kd8apYxsbMuilH3aMAmXVB3RB5nS9PtG7u3VyzBM5n3ON5eyYwiyWX5fQ/Iku5Boc+JSwb+CnmOFDiTkM77ZHpucakmBZEvKABlsV0XlgEixPN1rsSpj8vdpPYJVdWTxV/4z0+Ke7IU65mVkrghTuojHitEQLYd9XZ3QZrsigJ2xbrH6ymkN/9BgNgSX/gLXV6YmTjmqYxQfoUqAUTXx
 mAV24lYw
 b9cZFEO4IwcQWpvEFnfVPH3nyX0bnUPQIwCmW4h821hslp2TwIFJ/Fj/JPILF8U5RJ3UXhqDio839avcqQsaypmYqEsH1m909y0BUflP4yz46f7j8WkGV+WBkhHzfJfUyb5BeLwi5UAGhD05XaqbSn2bzULnPDOcTEVO14QezlBJ50clie9PkHrzn4XU292xmRv2VOsI5sNPyRP6CxBgQmmdxaZ6e3yyuA1zwKvNuHXWk0H2wzkpD661sJOVPJf+7C2421hGWM7tkCgQMG/JwJdNyS79ZCsyja7nZ/13SbXPdeZL04VsFkVUT0RPXASq0lFTNnVcJI802zH3z6E3sBEDYP6hWnhIE74phwBPayLTiY9JMhLYlGXaxI+TFvJSDeQWVsgi0xINePRuzDvgXRBRtMWtsWKvwqjyMAWpe7g+m3SM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Joanne,

Joanne Koong writes:
>The exceptions are the kernel memory stats (slab, kernel stack, page
>tables, secondary page tables and vmalloc), hugetlb, and
>WORKINGSET_NODERECLAIM, which counts reclaimed xarray nodes (slab
>objects). Their node counters also count memory that isn't charged to a
>memcg, which falls into two categories:

This still describes the v2 denylist. With the allowlist, the root memcg
also keeps reading rstat for NR_ANON_MAPPED, NR_FILE_MAPPED, NR_SHMEM et
al, and some of those differ for reasons outside the two categories here,
like swapcache being counted differently in the node counter, for
example. Could the changelog say what is on the list instead? So that
would be the stats that only change through mod_lruvec_state(), with
everything else still reading rstat.

>+	case PGROTATE_ANON:
>+	case PGROTATE_FILE:
>+	case PGREFILL:
>+		return true;

NR_VMSCAN_WRITE isn't on the list, but prepare_scan_control() adds it to
WORKINGSET_RESTORE_ANON, so once the root flush in reclaim goes away,
root reclaim would mix a live node counter with a stale rstat value.
Unless I'm mistaken it should go here as well.

Once those are fixed, please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>

Thanks!

Chris

