Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4D5BC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADEFB6B00A4; Mon,  7 Sep 2026 11:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB66E6B00A5; Mon,  7 Sep 2026 11:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CC646B00A6; Mon,  7 Sep 2026 11:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4A16B00A4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:49:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 110F81A01B9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:49:21 +0000 (UTC)
X-FDA: 85187400522.02.26E090A
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf31.hostedemail.com (Postfix) with ESMTP id 42C7C20006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:49:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VF9STM6A;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788796159;
	b=jMACxxSynSEliOspuFMixsODGAIT+gA2QPZMR8deVSe8I3JipsRcNj2BwHSkCUTDLYzOou
	8Ua9WrXFdshb+tqKx8W3S/QRcgnUSB96+GG+cWuJbtDsDGErR81auGcM1w71owxjUPvI90
	/GrZ9Kaqp1zVE+YJX7abW+pFq3qyRtg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788796159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7bstaN9ALzEM6FurB5GuElbXVvDphHV4J4gPI6CtdWg=;
	b=Ac7D4frghFdShJLnrCT5uKzH6ocMggJnyUkdoO+yd2BPbZvCReDtDvFYHPqfxbWJXxOis+
	RYGaeQ3quKk4BXtba9EN1QJ/Xr3VQ3HQ9wH6ZkfoYhvIEUpUlk5rnCqCdcfkTOiK6SlWse
	0xDl+t1NgAqDC8Ap1aD/+I/9XwB1qNQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VF9STM6A;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-90e8535619bso58620666d6.2
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 08:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788796158; x=1789400958; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7bstaN9ALzEM6FurB5GuElbXVvDphHV4J4gPI6CtdWg=;
        b=VF9STM6Aqe1APErDTys14ssTaEz895h3N/dRLCnG3L1W5g5iixFCnNfkEN0NSavoVu
         6XQ6F4xNoKnmIIBqFxGscuH2w4O083++3bwX8rRNODuxXhCu1UfH9wk6rF3RzxpfVKbb
         sKoeJNN226b4w/clHtLhxnfAah8CtOsP1cnRB6Qi8fyttNXnLZffCyp6SRLR8Oj0IjJ7
         7e7eQ9ZUNztSeApUUjg0WR6KDgvpQnJLTw7gqAo4sijN1XagZ7Ev4F/kupEA2BGx3Zab
         d2e+vO2+rtokB45Rn4fh5KiJKsRpBJNruqDyc12OpEOuRSc3z58NWLXutxwtOTWAlj4j
         QZ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788796158; x=1789400958;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7bstaN9ALzEM6FurB5GuElbXVvDphHV4J4gPI6CtdWg=;
        b=nD61ID25a1mBGc7/MZkdSXeCT1Py7puR+iFk8QpLpVHsEsKldcZlhlhc2LMnYPDAXM
         GoDMsePU8SIY2WLZftoGRMgusCsRwf6gQUzaABAszaVZ+HondSFmFNvUX4aj7+H5LBMx
         i98oHohiuQlClhJtx0UP8a0eLZ18/vvBldx5gXYuzZfqWJnkP2rHOfGv9kY5DuxvNAD7
         UBCY4By2qh23UbC39ErzUwKANs7DCQbwrOj50a/x3MgVwq0EKrcgjHc3EnNzS9xwQwKS
         djqwIMgBu/bKeCAzyKpfwV0Dl1aEOfqtQu1MhiuXdzQ9RGSmEN2BEbz635uElumM6Y1P
         K6nw==
X-Forwarded-Encrypted: i=1; AKwUvBxXQOfq9f66j08mvkYDPLKmocF0cqkow2uHOVBv2c705gz9RZWyhX1QAIR4GudhO9W9PvAGaatIRg==@kvack.org
X-Gm-Message-State: AFuF++mVvV9iHCDxc9D/LouXpdmgJojTTKN7nX+Uf5LBniajjemZ1L3f
	sW0ZvJsf6bI/ivI2OQge5Cu+71GuCqpH5j3v1SBiCXL/fXUYoO2OZ1w99BJJNzWwWxg=
X-Gm-Gg: AYBFou2t0b4uwufdat2Ryu7AcHaCpE2JnY4fexAZVyrYD1hqoJ6578GNxVDvIeXkbE8
	4w8Bz9StOhyKwzGdVrbqBJNd0vaBwAZudwSY3U10rdR4lnsIiwOxtVsrlE+rXRx7H/RBT1U84fV
	irbqETaUnrjJL/yj8iyBdNgSy7kZomUM2ryukww0HAwk3jdEVyW06WWJhTWkOS4BSkogQgwruSk
	j0UDcxFA5NaOW0kGMu3f+sVeoIAq9Z0rIZi7qNRZQZe7WG4xv3In3w9ELpZAxAWh/gVcpd3VCcD
	6lKjUdLFLUk1URAPrJQMX5wz7RCVO8L6tD+bVY+HPLKxSWJPgFlfHSUb80Yt28Sr3Rgx+yeVdXn
	UZhGLWYeD6OBe95NnoU+VQiY4o8spjw4Oik4CojU6G6Xy3LtVmMztAcblTDsXSL5MYOyLMjDOHg
	doN3l84Nar5X/BJddsTN3SKm8rn8SVmSndNl/z1OyY6vgDYapk155CSOTJTsAP2q3rr6mf/jxv9
	A+eNb+qLjxG2slG2l//iHDb+O8u8Vp6cfmHkORjggGy
X-Received: by 2002:a05:6214:2584:b0:8f0:3b98:d6af with SMTP id 6a1803df08f44-9103f06f338mr298091046d6.26.1788796158337;
        Mon, 07 Sep 2026 08:49:18 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91043b54cd6sm83510576d6.34.2026.09.07.08.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 08:49:17 -0700 (PDT)
Date: Mon, 7 Sep 2026 11:49:15 -0400
From: Gregory Price <gourry@gourry.net>
To: Ye Liu <ye.liu@linux.dev>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Ye Liu <liuye@kylinos.cn>, 
	Justin Suess <utilityemal77@gmail.com>, =?utf-8?Q?G=C3=BCnther?= Noack <gnoack3000@gmail.com>, 
	mhocko@suse.com, peterz@infradead.org, paulmck@kernel.org, mingo@redhat.com, 
	rostedt@goodmis.org, jpoimboe@kernel.org, oleg@redhat.com, tglx@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com, 
	rafael@kernel.org, ljs@kernel.org, sj@kernel.org, rientjes@google.com, 
	shakeel.butt@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev, will@kernel.org, 
	boqun@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org, 
	joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, tony.luck@intel.com, reinette.chatre@intel.com, x86@kernel.org, 
	pavel@kernel.org, lance.yang@linux.dev, mhiramat@kernel.org, pmladek@suse.com, 
	longman@redhat.com, mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com, 
	qiang.zhang@linux.dev, dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, mark.rutland@arm.com, 
	Dave.Martin@arm.com, james.morse@arm.com, babu.moger@amd.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, rcu@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 8/8] security/landlock: convert thread iterator to
 for_each_thread_rculock
Message-ID: <ap7c7wGbJqOVZonN@gourry-fedora-PF4VCD3F>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-9-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260907081334.1152889-9-ye.liu@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 42C7C20006
X-Stat-Signature: fa5jsm5dx1dbj4dw5xx1ui7gfkbpk55s
X-HE-Tag: 1788796159-788828
X-HE-Meta: U2FsdGVkX1/jIG0JySPpoTMxP4Pg+gCp8VSqH4wqyhXCWTGVJYnSItG5rH82VN5/tGGFXoMUUyPbJB9l/inDKkUiY5/irMV2RaVTHiq1t4iZ7iEOnk0D99U/LYygtEXen/Icv89/54wtkvm15xxYBkCpT3ntVh1dxD/JB96Rh5JnOVz7sNkYpAl7UVgwGQXeMx9gud9MKumoYI9ToBoCzISYQCHaNi//e533Cu6/UsdAkmRmiGOIONDPgg9tNojycXWVVOMQKo1ZGfOkYNKNqNB1IbpSYip7OIiPoHvOX2Sg8vG3OxwQjymHUtLrmAUFA17QRL+oHyrOP9KUKrAypIQcub2c6bJ9YLxrc6ihbhjpQcEQl+/Dv8dFmubhPIi4v9Jn91FqlEd0MOGQsesMrs59k0ukuutP7XEbpZsH9YBBRE5E9iA0F8MFkMG8oUUJm9o16vmReshpDpJpdTFfcFnDwyupEl9fotmOHS0ysNFAgW/VuozfshDZlwTUAwEUqBwQMdrMWbXTdcaH5nwY/Tpjvu+kn6XoG+NRP32PMZ0hODDhIphp6IYhIQZMquAX+C0rC9TZf7IV11DfrGmEs8r8q5t2mBnYTbViQyKO3cEgjQu7r53kNGqugw7wSi4VawgVD2EAXOuey7JZ8CdC7o77zZNDyhxS8hA3aVfetH8yldnGGEAowKjF0OAB1/udQYJnXlccly0T1s8UDKK3C+SKDphf5bW4fjirL/3gsH0MGQnxY7KpF1UywEf2SHJxHT8dTB8s5f55PiG6QCDPOskElKTARoqA44FiATTmQ2n1fA+pRaAofXBEmZ1Kp6Q6K/GIIndXjMB0kg2Qnib4ok2+F4UhK008GcIhdYQaI3Dbd5cPcWumsK+FY2DtzR3ePhvDF7nlMkralSKXeDuS0DrJqFOVpnJo1l+lfReKeRRV396uwmAISerVCWTf5RHU2B1+NJ2bHkbX8zqRhHG
 xnvCqhhn
 s4ioG92hJxU8YU73GHkj5AePhQxx6cUyNJKm2hsIRkt8RkU4KBsH14bxKiUcLj1jgG45Xnr3xY6/hiIsfxaGq8KqiunRfFV+gLpZMcewDHKxfGK60KucDA6UDOe841OOV6nh7dzZGvFOEU5aEpDcfoQ1aHHQWOXHC1/8nLZCJVqH9YbIfF/j/xzdEKYTQYayhr/LNLi5/qfEh6d1fspobFbo1RpnCTj4/loJ1XzwWa88m9sBhLDX96ieTBhQmF4gTQB/mGKZ7pU7e8KPrCZQiGed2QBWxH8F8LrQHTkXYlxgQWZ5zvB4/s7WEsJBEGbSQNKWq+D8P9HSVvkXp2zI33m6J4xMjl3v6BkgjOuqAYTkLmuuj/cc7jeK9Li2M7/Bni/wOvnKhGqF970a4dm3uX3eWy6rFcBqQQyDKdE3zaBEdozEN8H1XoxR7SVQt+Oouk1LHqIA1xkIuzZZTVl5D7qm1iIb9jNrnjvxDpPTkyFeKBQRDne7gjrXXSViJ/8Zr6iHtqNJ8J24DPi/tNVcTDL/d5Lt/Cs0w8WZj3NNLJK+hwhGhoRhVL2g2jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:13:34PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace guard(rcu)() + for_each_thread() with for_each_thread_rculock(),
> which scopes the RCU read lock to the loop body via scoped_guard(rcu).
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Reviewed-by: Justin Suess <utilityemal77@gmail.com>
> Reviewed-by: Günther Noack <gnoack3000@gmail.com>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

