Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 191E1D39406
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 10:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 282586B0088; Thu,  2 Apr 2026 06:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233976B0089; Thu,  2 Apr 2026 06:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 122556B008A; Thu,  2 Apr 2026 06:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 02B466B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:20:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 71D5859BF0
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:20:06 +0000 (UTC)
X-FDA: 84613220412.17.26AC2E0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 009F44000F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:20:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UrT0u4aJ;
	spf=pass (imf07.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775125204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9FNAq6JXxyYmLFJe3V/l1GPxm6IdqNxZH3xpVlwE3k=;
	b=psR8jrwA8BYZ2VsswxdrH3XxPbPw9DhByJpiGgbOpMqpjt2t+2iFDh9bGjsnY9CqzcA2fD
	rgEyWYKKxy0/y7hmpJZ9pdjV3hj8pFemSGgvPv0jfXf/csfvpxkEwU/nxAvwMwFo8UW5uE
	8XMn6fMhkURLC9Xwfd0k9fZ49t4W/qk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775125204; a=rsa-sha256;
	cv=none;
	b=NcjAKRrWXG5A9Ax8WOmemzEm1AAEtmv0lQ7WMFhChZoERhNKvGsO8S3USgmHiiGP8xs8fi
	h7DrLCP4vS98rN7paYQ5CvorAKyC0Y6DyhBvvATo9zHrGsN6j+VfNBVQcTE4X0PegqdB09
	k4Ngd7TSl6b9daBWh515TwquNz7TxUQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UrT0u4aJ;
	spf=pass (imf07.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775125203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R9FNAq6JXxyYmLFJe3V/l1GPxm6IdqNxZH3xpVlwE3k=;
	b=UrT0u4aJcIEPHUOf9domdQgQG91IqHo2qLmEA3CoKX8d12wCdO0bxHz8OnvSxU/HF60B6H
	evRU6gJsHS7haYKMymEiXceMM4bsJcQQIerYf6gAMXL/rTS3oEe+uReMvCqfBTEZDlDNex
	dsl8e8CZqqcBXhoCOPuqoaT1L0XYSVA=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-SIwnMoKWO3mc5Vju_HBiHg-1; Thu, 02 Apr 2026 06:20:02 -0400
X-MC-Unique: SIwnMoKWO3mc5Vju_HBiHg-1
X-Mimecast-MFC-AGG-ID: SIwnMoKWO3mc5Vju_HBiHg_1775125201
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b2523e0299so19858975ad.3
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 03:20:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775125201; x=1775730001;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R9FNAq6JXxyYmLFJe3V/l1GPxm6IdqNxZH3xpVlwE3k=;
        b=C6PZWUJsbZFHWBu5T7D7Aajf6bybYGWXmF+4kscWnQuau3wsZfCsVNgw6/Ro+f4DFq
         PcnJ+3LeyLk1DGEhHNBasMWgS1ysl2E/LhrgwJ9prMKsGzrjkh7f7SAL+ic+XKBGvuOA
         eo8w7yhri88fOva2gCl2eHNUlFjamB/S6iOSNop7a7V0/yFPUWfnfpZ4TcGhFgVKZ/n9
         ruJ7b1mz/ahLbtXn7tVY+pk9EHTr1ZY9MpEHsIaW6w5ftXSAX2Azwx+AnU3gu9/5SMzu
         6WSVlTH6DAxdVhxI3/YdhOdKMjRvsA1QRvx2RZigA87n+9vrG8nerLPuDAe4FnOjZhSK
         Gzmw==
X-Forwarded-Encrypted: i=1; AJvYcCWF2eD243OHfyZjAJYGz6kURCoDurISfQPfkOnKEiIrYrpPYrQ1w1e+5IUP6ZfJAGi5pv4dg+akLA==@kvack.org
X-Gm-Message-State: AOJu0YzSEPWc+pHFdGVMOUyaaFL1cfRCX3XNQSsUrEZIxxEO0cF/+51J
	TkP2fSUP6WYA6VT6pqzfa6jQEan182H4VCGLnPsa4jhbu4hq59RXvfMXyxJfFa97LFtc6oGShgi
	GPtDsG/LdZhfW5l1V6j6565vYOLzSZkiwlCd+gMgrfp9/mijyNuIo
X-Gm-Gg: AeBDievdwqt0cbxYiZ+dqgLa4hGsBN6pb1n+HFXricH/RZ+KQzfDCggU9cvXok9sKq2
	hDmtUYh4WmpuQjfZ81QO7q5d0HA32q+CYeIZCEZblH/6fgyAqHWxEs/uTtNm1KpThjv8mO4KjjL
	hvnk014AoTjDXp20d0IxQGIp1eyl4Busi6ejMfVSMTY+3ABi94ZjmCNRn6iC6gWJSFvtc7b407F
	l5fiVLn9ugXescq/BtW3vqvqY0Rj9YcWmq1YZHn2YBEU1im502r14Q4ogfkyHVYOOBsmlMd+TDI
	y75Ska5lsLMLxJ/LuDmJo8FXryXVqpUVK8ILor//zjXy56mA44cHYABlGhPKo9P15B2v5IpEFyu
	Bq3haNJ1AcmvAN9XCDA==
X-Received: by 2002:a17:903:248:b0:2b0:af2f:b26a with SMTP id d9443c01a7336-2b269ce75dfmr68411205ad.48.1775125200954;
        Thu, 02 Apr 2026 03:20:00 -0700 (PDT)
X-Received: by 2002:a17:903:248:b0:2b0:af2f:b26a with SMTP id d9443c01a7336-2b269ce75dfmr68410865ad.48.1775125200433;
        Thu, 02 Apr 2026 03:20:00 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749cada2sm22687075ad.71.2026.04.02.03.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 03:19:59 -0700 (PDT)
Date: Thu, 2 Apr 2026 18:19:56 +0800
From: Li Wang <liwang@redhat.com>
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Sebastian Chlad <sebastianchlad@gmail.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>, Li Wang <liwan@redhat.com>
Subject: Re: [PATCH v2 1/7] memcg: Scale up vmstats flush threshold with
 int_sqrt(nr_cpus+2)
Message-ID: <ac5CzJ5S0kp71rrs@redhat.com>
References: <20260320204241.1613861-1-longman@redhat.com>
 <20260320204241.1613861-2-longman@redhat.com>
 <n6mhkjsxsami3qmczkdh57eep4lmcgbtyl7ox3ajzveke44yf6@m4bjevvsr47k>
 <ac42aIDVaGim5moO@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ac42aIDVaGim5moO@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tvS1TQ-a8UCaJDG0-CN9XEpbss7fb_qy2m6kLdUPRDI_1775125201
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ecc9ttumctc61cnice5h8jefyotnwk96
X-Rspamd-Queue-Id: 009F44000F
X-Rspam-User: 
X-HE-Tag: 1775125203-837390
X-HE-Meta: U2FsdGVkX1/s6P8fGWjZP9w0jE7I5SdeqoLZxy9z+z8nhx6RNz4pMbxf7HTdquuLOR5BNG+jc3DjEkz7nQPi/xM818KfqcajtPkM/WtM30koKf1SmX5hpCa0m/xWzDsRK0cFzIBMUu9WnbISxbc9cAdm3JQzm7tE9sVmpwN9DO1fTxa1ppSgbDy+JIiciTIaDDEaX5DWntzv7PaBDS7o++qn3nQJsg2Sh5s0ODnoR/3xzku8ZNwE84c83Usbgnv6ZtjUSxyABHMZm0Nm3Jg2kXeSiUGVrYemJOa9oejkb6B2WcuyxKMO46BhtttNeBdTYOv4p36lmapC90vr3FkTXC/YdK4wwEqNdD6ZsfDSO7SrtyN63uYpsbJNAAwsDeE5DTWqi3/wg9231gE6e3EdnMfQypU3F1W3jXmF3ybU/49t47UiTGi8z4ijyAVbMN2qPqa5oW7wJjur9Qbid4a7PfJe+fiCBlMO88wnB7gT6Agj9UeB3g1HlPExE/P5/jORqbddGVKwBqCHNzQW+5YpAjXqw6FphKJ1LRklgL4A98VoYWGwMsjTYctujgTkmzZKc6DC17tA9HFmbwKkIj3kBgOr6WwLOAqNeCwMH9C+1R6/4la8A/P4y1BwKPKy9t9KFoZBxe+2NV+BdabLy99R/cpkNgYmz1BJYTMPVT8UrpsJfrwNxN55tT19yDJVr7qb4I1wG/dykXFpFEbtsMacjdq7m9OfhNvohX8s80+LxruerARYDdvLt1+OyQGToNqvmwaSx5/003KdWFswmEhf4ANUEF5rzc4ytmFOpGts7YhMqh/sQrvJ0yTLpI08UQ1nfUTjHtk1L1gkDdMezdvmKxA6+fXlNA1/W+HH+mwp7IaqaANvcy70St9biNE7YdWCI0VA4fzh4Oo+yvPgtNz5H5fDYNywHnYX18zeMJ9YyV0A7Gt36c9WG0JD7LDsSTWhplYqdR20LlH40Yv1zQq
 +zSRyXEW
 hnWZDNxG3igIPAU6M4Ylmwx3laTuVBtaOHjDTxp+a1kAvJQrcCLLb/t4tGnJhITBSrPxo+f54awm9OeCNSAyvA0ZJAAX4tP85JTVOkEr9htBQwvLXB3NiAy17M30tzLjnoZT3GI+5BaVxzK5W6gsrXhZyu7yGejfBzNLyuGmMufiB3BilCTnKarIUDHeBbrXUuDjzWCmQDOb5wNbI/G/b7xjtJkmGj+7Z8jVmnX9QKf9UsbNb71Yo6E2pHcechCUcIJMFVUSqan6fDul+tM11r69gdVqz4hRJ+0zFbbRVILs3raAVVYjQWDitV4QwghRnmGJnsscKuBNSVwCgn/KKK9q58xBrIpCRMvZ5m8QJTjxtCDOHkw26YVPiWSU0TwkKYMTl9siLQXGMl34PgKzB8ngh9wR8y9GDxIfWDByaXFDFOfe4rAfDCeBNC1dZWUF/0ghvnBLbBBqj6Br6iU+R4HeOBq8m2Vlept1fI+/Yk6dMPXh/4rpPcbL1eA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > with kernel functions:
> > 	var1 = 65536*nr_cpus / (45426 * ilog2(nr_cpus) + 65536)
> > 	var2 = DIV_ROUND_UP(65536*nr_cpus, 45426 * ilog2(nr_cpus) + 65536)
> > 	var3 = roundup_pow_of_two(var2)


Consider a 1024-CPU machine with a cpuset-constrained cgroup using only 2 CPUs.

Its unavoidable batching error is just 2MB, yet the global threshold imposes
256MB (harmonic-mean) or 32MB (sqrt) of additional error — 128x and 16x
overprovisioning respectively. Both overshoot, but sqrt stays bit closer to
the ideal.

-- 
Regards,
Li Wang


