Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38611108B8F7
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 423656B0005; Fri, 20 Mar 2026 07:26:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4106B0088; Fri, 20 Mar 2026 07:26:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C25E6B0089; Fri, 20 Mar 2026 07:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3126B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:26:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B285D140162
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:26:20 +0000 (UTC)
X-FDA: 84566212920.14.C66185F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9297C40009
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:26:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X/VPIP/u";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774005978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sw/BFdoRDz/kwV1Lq1g5a7lIWwY3pXrRBNNHoMNS1Eg=;
	b=z1TPHYqZH6IGpxRZiBHtZtcUAt1NbjGp3Rhn62AEJuV3ERajyK0q52s+UhJ+ntGJiJETsP
	QOYFvUyUjdGPJBIo4WLS7MzO/+Slpfd3JQV+B6aWZpujHbxC0hKhSuC7Gn7r//jBmJslAK
	7q8lBImtAWiiWh1y7lWRhPNbPUjdi0I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774005978; a=rsa-sha256;
	cv=none;
	b=ihfgTlUXFCL9y34dCUhEFV1cKlt6kNTvplmg2G60hFIpe1Zp8Tim4j99fv8bA1ouKhhFoM
	JNLESHy5ETvnmm0AWJaeIhXaXbUiyuj1ypiE4ROisfQS0bNNoaVGGg86SmbBBLvDkrDJD8
	xTAi3rM+6bX7eNtIuzzbO18fLWEHvOQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X/VPIP/u";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774005977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sw/BFdoRDz/kwV1Lq1g5a7lIWwY3pXrRBNNHoMNS1Eg=;
	b=X/VPIP/u9egaypO4Utn3+J9obhHKXZPvb7h1IVLeSPUM0MY226ovRkot2RjjlAUwFF1JYV
	LyS38Nu94qUkVpnv5ZD3cTK8UGk+X5Y7C+y/0Kt8A+qIlK9GPoDIfFauIqdp18gSNshCWY
	xKXyTX2J7N/Xd51u4oS2rWjA+8zapdA=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-DWbglTFJN6OfeCaURXacyg-1; Fri, 20 Mar 2026 07:26:14 -0400
X-MC-Unique: DWbglTFJN6OfeCaURXacyg-1
X-Mimecast-MFC-AGG-ID: DWbglTFJN6OfeCaURXacyg_1774005974
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-354c0234c1fso398009a91.2
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:26:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774005974; x=1774610774;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sw/BFdoRDz/kwV1Lq1g5a7lIWwY3pXrRBNNHoMNS1Eg=;
        b=rNShQZBnjHxVnjDuE1eGwcp2DsvGXKAhIRS43XrhYJ4Tsf3I8+6IrOg4U4R8PqpvhA
         ZYUYkJznUntLiMeGcjQ8XEKeUit2WDJhrmwheZALWabAwTRnrcebfmbrme3LIf9Pz/rY
         Q9kvxxLADTr8Cdx6aH9cunUZTpNKPyXigEyWPf7GPOZjqlfzBM51swuokx5SxhZSg6xC
         LPcS2EWptTavBHjTFP9SIKXj7l7bTKGT5YDVdbHapBaZY5KxADRGXmVfpbQmaKe6eWnu
         3x6OUQ3SIKaPSbWKKQUWn0MW1DU/zdMGwbCRe+/eSrhJDHQ7r9ZDGZoywN/g8s+QA/0U
         RkXw==
X-Forwarded-Encrypted: i=1; AJvYcCU/oIkbr8E6mWq+baghCM2avkFnJXV9a/YU5vkvOJQbrp5CFoP8b7NN/bTeTVqc9viNH3XDufeYMw==@kvack.org
X-Gm-Message-State: AOJu0YyWFRcO8FyCBhoKQNqYZy1d4XCZODSXdLSpZ7CEmruAwXoS6QYX
	DchWpuBaJ6bjRUv97dVdor7q4Q+JNYaKeCWhox2jrT1I5zfRnF+lqX7MXQ3wENJpBRvUX9r2pEt
	qYiHY1OwNhYXNjAawtPwJkt/Rs3Pr0DnS+d2JjdhhhZcw3hM2QWDi
X-Gm-Gg: ATEYQzyYX6twL7+jyE+d3jpwU7mmQqPdBcIWyuM+7w3xtnS0dwEbipHxa6rqcWrmT0/
	984wQD24DuHxBWD1Em4H3wuGRyxK3y1v2TQL//hkSRe74uT42ICphN9fbSelc8/6UBXxBvP4YGR
	iqf3b29MX2MFgC9LI9uVAEvE9OlqghkNarKnLFoyNYUYIXgqa4sHpp/lWTrdHJ4Zu5bsC5Qfu2N
	OJJ9EGd7G3HWBtSpNrvqh1MO8VNQMBe44aXUdcgifOtejanOlo6XiRksUYPyrnUed3kcgE/b3eN
	oiGDUFv7ARJUayc0hxnD/NqvYyBiBrO5kWK8AJ6FU3nKoKfgAFs74zO3ryMItTn8TBZ7VMMc5Mw
	rxzRxFg5WXr2+YvZ3kg==
X-Received: by 2002:a17:90b:4a50:b0:359:fc88:fa99 with SMTP id 98e67ed59e1d1-35bd2d39c11mr2044014a91.26.1774005973755;
        Fri, 20 Mar 2026 04:26:13 -0700 (PDT)
X-Received: by 2002:a17:90b:4a50:b0:359:fc88:fa99 with SMTP id 98e67ed59e1d1-35bd2d39c11mr2043977a91.26.1774005973145;
        Fri, 20 Mar 2026 04:26:13 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd40e4bf2sm1655907a91.11.2026.03.20.04.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 04:26:12 -0700 (PDT)
Date: Fri, 20 Mar 2026 19:26:09 +0800
From: Li Wang <liwang@redhat.com>
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Sebastian Chlad <sebastianchlad@gmail.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>, Li Wang <liwan@redhat.com>
Subject: Re: [PATCH 2/7] memcg: Scale down MEMCG_CHARGE_BATCH with increase
 in PAGE_SIZE
Message-ID: <ab0u0XCi9xBefrhJ@redhat.com>
References: <20260319173752.1472864-1-longman@redhat.com>
 <20260319173752.1472864-3-longman@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20260319173752.1472864-3-longman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AMONDRQaYTg3RI1Jj0Evwz-o0zgOULRpx_SZRSz_DKo_1774005974
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9297C40009
X-Stat-Signature: xmf8aruh1kcqm9hrte7ctfoa8qtko7mb
X-Rspam-User: 
X-HE-Tag: 1774005978-493100
X-HE-Meta: U2FsdGVkX1/C2n+y1Pes+kMV8snA/2rfGPPEvMPIHVXa8bbEHRNWPQCZbi7b0SRWE/4PYZPN5HwzjabmGrZrtl64LQAWnRsus9DiABZGOluQhKRh3woi2AwLP7y5MrchYLkhH2vVO643ej0qzu0F5NgjIQjEXuZVbY4SfXCHA+j3/TTRj/yJdZ2X/hQ5+m0psGMBH1HZHdDJwLPw2sOefTOQQhHtfoiG9RbwXokGUK9orS7Fmu+xtV3d/OmiR6KYPK5JQdp5l6nwDPEh+Guna5v7qIW324oA9539Yflh518p0j125HqXz3eqMU6FRiYCHopgZKepdk6/vxF/iw0cMjWgZQcdRidYIJ3mTkO3/1kT4OUCEzUVXULkHQgz97/9nljE/0kjuU86DnPD0nZpUJkwIroBy8g9+/AGRumteucUCN+h2IXjLgfeHCl4I0EeTL+++yTuGorS286OGGFRxNwTNw1f1g13eMjnKVUEQUhqivdUYBCGij2yG/I36aLwFpQ8xVNeDDA5lz9TSNfXerZu2Z0TpO71G+s5EAlCZ+a4E2ZKJo0SSBBaDA9mupwvKxn/jrEhdPuxpirgtUEMZg7DpSVkWKpLRX1kpfXrF7rsjpiFqaDlSG8CgmSDwtYGsgeeOJ56CD3Syid7x70Z/ViXJUjk8JjX5cFG93aoOmicNhSuNNp9e/8tksR83eQWR91yGTjXhiFtQbhSI3/W0b5GpuvpgCPthnr3L8DnuK8ijE27JxUcarQVSZAFDDIr7Opk1kBZDyKc5KZm+q7WFHIcDEfk4xCZddKh+Dnyo7hKXDx6KqfKCJe+dyQCd1q5sq/Y/OPyzKekRf1KKJjkMHdAnbtpOMa8gbjnQI1DPQ8k/ojU9cd1e94LnuLF4XWNNIefJvzoqebDz+TpjVHpLzxQ0C4vn9v0rbmB3mCcNvYEEYLg8NB1ssG9jipoPfukufmiBbsZUBme2m1iVbO
 5gTDRkh+
 nMVCZfcW4kM1SQhgVEarY6uB4j606fdwnQikO87Q+QXJGJo6xLzNLBLCrkdQbvUPJOp4XaWoH3bJkC7cqa9LbFlX42Xy2qLT4oYlA16q9sDk6SD1vOWPHDajReMioxXD7CcfqxnqUfmDHWHQfhaLhKillljcSZt94/Wktk1I98qCMsj0A6LA7UrQ5Fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Waiman Long wrote:

> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -328,8 +328,14 @@ struct mem_cgroup {
>   * size of first charge trial.
>   * TODO: maybe necessary to use big numbers in big irons or dynamic based of the
>   * workload.
> + *
> + * There are 3 common base page sizes - 4k, 16k & 64k. In order to limit the
> + * amount of memory that can be hidden in each percpu memcg_stock for a given
> + * memcg, we scale down MEMCG_CHARGE_BATCH by 2 for 16k and 4 for 64k.
>   */
> -#define MEMCG_CHARGE_BATCH 64U
> +#define MEMCG_CHARGE_BATCH_BASE  64U
> +#define MEMCG_CHARGE_BATCH_SHIFT ((PAGE_SHIFT <= 16) ? (PAGE_SHIFT - 12)/2 : 2)
> +#define MEMCG_CHARGE_BATCH	 (MEMCG_CHARGE_BATCH_BASE >> MEMCG_CHARGE_BATCH_SHIFT)

This is a good complement to the first patch. With this change,
I got a chart to compare the three methods (linear, log2, sqrt)
in the count threshold:

4k page size (BATCH=64):
  
  CPUs    linear    log2     sqrt
  --------------------------------
  1       256KB     256KB    256KB
  8       2MB       1MB      512KB
  128     32MB      2MB      2.75MB
  1024    256MB     2.75MB   8MB
	
64k page size (BATCH=16):

  CPUs    linear    log2     sqrt
  -------------------------------
  1       1MB       1MB      1MB
  8       8MB       4MB      2MB
  128     128MB     8MB      11MB
  1024    1GB       11MB     32MB


Both are huge improvements.

log2 flushes more aggressively on large systems, which gives more accurate
stats but at the cost of more frequent synchronous flushes.

sqrt is more conservative, still a massive reduction from linear but gives
more breathing room on large systems, which may be better for performance.

I would leave this choice to you, Waiman, and the data is for reference.

-- 
Regards,
Li Wang


