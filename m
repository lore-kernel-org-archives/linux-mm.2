Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FD1EC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:14:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBEDA6B0093; Fri, 18 Sep 2026 05:14:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70236B00A6; Fri, 18 Sep 2026 05:14:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37A76B00A7; Fri, 18 Sep 2026 05:14:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D6B56B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:14:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04F411605B1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:14:23 +0000 (UTC)
X-FDA: 85226322048.16.13149D2
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf15.hostedemail.com (Postfix) with ESMTP id 342E0A0004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:14:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gWQJ0925;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gWQJ0925;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789722862;
	b=IDUVUvSWn+H2u9/wW/ttXpOOzJHDZa5/UmLX8dcL/EIg7N3OYbo6un0rR+VufEvBxqwfTy
	ymLljMFGCn3Gw0u97wYpqwRXDIvVaqMLm6AqDB5FUIAwW9JfmGh/7M8sGlO/i8cDzCRFC4
	6BM1HrpKvhRlp1w1UqrxqrfyHtb+U/8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789722862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SfKpB6hUtfeLMQ4pzuFq7L7CWOsyj3Ko5MJ4c1BBJiY=;
	b=u/EaD87Y4nq5DAsuf9d8EuTocGxbag4QhlUy7yneUrnT6zDnG438ghz5bPPDfbmmuroya3
	xjqZJvUnsyNlSBj/3IHWot25/++MoLrFF9nuOoJdHeRe3kImIvGOkJzMMj1h41MnGUCqyQ
	ddmqPMEoIzbXagLAXQhANnDe7Wo1dFU=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485933b2522so330389f8f.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789722861; x=1790327661; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SfKpB6hUtfeLMQ4pzuFq7L7CWOsyj3Ko5MJ4c1BBJiY=;
        b=gWQJ0925CO8d/uSOErkWYLSWJFDA1mMgPQcBcVPKHY6SWUijNYOXpxLrszPeXDqOfc
         +zAPnbkjWmSpmxBu9Hu6OraaYM0gWXg6w3+IDz4Vbpx6yFzdsWy1s/WFfmw0OWVNFmlv
         9EwbUXpY6k/xkbI31yGbWTHQ9tIw6U3RLx2C41dZZot6ER6hwT+qX8JJExXll44+Rh6H
         t0hB9Qqu43iaHkzP925vrOTNp0qxZcmHtjbIjqSD4/pP5bao3dai/2DSPpV7d7CYY4Pu
         0tzzcPSn4IKMn1Bv25mQsnbkZMAkACcGP/uyToWGN2/cYrZSpQv0uDw1Fm4OUqRwac3Q
         pG7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789722861; x=1790327661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SfKpB6hUtfeLMQ4pzuFq7L7CWOsyj3Ko5MJ4c1BBJiY=;
        b=yI6WEJAGAaHlOfTyy/wZXGO8+zg9c6zsDPxWaFk36GUieyr4ltc0MZ57mIXuYFiQEk
         DWC3rD4XoRiTtFNgzAYhD8cIiTAvoX3AXFcIrYnWdymvruerIvsutKzhk0nlGVYpZAsD
         durFzFBetAmMFdfvLrkC5VRiB8h3AtYNmEktuwfDa4XUVrtGes8Zd+SMHCJeNcGWZv12
         QH36F2dhwwsRjgHXM1zSRCj/gl9XCpcs4ESSmV1IInarKIwmLU5Zevg/sstHknixdDh+
         EmuPwISAt9FS50nKvGq3QCeA6LmfblhwvjlGAhG1DEmaaWPCEbkEKRIo7szloKMzUGbW
         7d4A==
X-Forwarded-Encrypted: i=1; AKwUvByYECPWx8yAhTcpqd7UyXGFeoqnfK3UAIH31CY5kfAhYeC/7BLBJFAx0O1FNot+/kRSQTj/cIWt0w==@kvack.org
X-Gm-Message-State: AFuF++ke2uzyb98jQxG6ZiWi0v6WFYVbjs+Z6VvkCMpnLTg0caLGhW0C
	LQZX/aOaujz57xWX5Z/nNx2oJTpWhHGzSFen1CBPTCMDkCQEw89K8kEz
X-Gm-Gg: AYBFou0/uWsBMqQYHTQJMUBhMx0r2Lou854JbBqETNY0ahtxOS2o1glb1Q+51Ykzuwd
	4gjI4ME3K0rfL1Yhk/FBJks9h4DZxF6MINEkTFQXo4MOMweBcUP+fnqUqiGuNFYTmodErT2BAEO
	L722hfZaM/hTouvj6BQEAtqQeT46byFfrTNqK3rZub67RP9rMkaOpNBLQwQkv0WftLdV8TvkmRn
	Lnvo1xici4ZXrXT6LNAuY8Sxpv8wxkXZMcsUpOn1CfvWWDFFotkb9GogmdEvwOuN2DrXhvlh8gt
	78+SKCJzz1GqvS8lPbPM32McEDUlgP+OoV3J6datFve9LSgxXYudEMWfSIY51ijWq2102NfBcDe
	GcYGUTmCF0cj8tHf2vWNJq2XpK00S4xafliCt7S2+ge0fXuRMrlxmpi1poDvn0BVRO5UK55zzal
	EDvGYqVd/8lBRbHHROE9dRDwacHfxWeGIhgJfn+n4pNHL3LuA2Vix6wTb5V9tgAJR+mXKq0pZhX
	fGrKt/t93Y311pu/dwj6wPMDw==
X-Received: by 2002:a05:6000:990:b0:485:ad55:208d with SMTP id ffacd0b85a97d-4871e263f69mr5184001f8f.18.1789722860820;
        Fri, 18 Sep 2026 02:14:20 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4872008fe3csm2583357f8f.37.2026.09.18.02.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 02:14:20 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: andrii.nakryiko@gmail.com,
	david@kernel.org,
	ljs@kernel.org
Cc: akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	bpf@vger.kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	sun.jian.kdev@gmail.com,
	tasos.papagiannnis@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH bpf-next v7 1/5] mm: Add copy_remote_mm_str()
Date: Fri, 18 Sep 2026 12:13:59 +0300
Message-ID: <20260918091359.297923-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAEf4BzaH=PJh7QUhh7szGL+gCieYLOSbhriFWaZG92xFWDeGig@mail.gmail.com>
References: <CAEf4BzaH=PJh7QUhh7szGL+gCieYLOSbhriFWaZG92xFWDeGig@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 342E0A0004
X-Stat-Signature: 61i8khw1qd8mctupf377y741tp1kx589
X-Rspamd-Server: rspam01
X-HE-Tag: 1789722862-98383
X-HE-Meta: U2FsdGVkX1+old9dWnfnrP1HKfu7eAALcMCK+KPEdPfUxdTc25+ue4nrowOQrBD4qull2y3s7M8KOZL32ZQw+cBBrkXTIC1aP3TYyeRFzhhnBpAehKH0yztOKBYCf/4YneId0yHachhT9baD2Eoz/zK+Rwklx625se4TjQbx7sdy6LQDgRZE8FzGZ1I5VOFtwpnLOKGDWY7AtDFhhQNDVNVjnQhP7OTYZZYtXWUHRVu/gqm22WunfNlntklrv4saAXQaS4F/IrmR1b02864qROvwdbq5NbqrDGrJPTPB5SV4Le1j2a0DGcYUGv3ew4oSTcX/6ud6Q4i+jnsn+pEYUZEt0SpP5cWH+V9F3zlpivkCQNlv0gBVH+fsCA32wDiTqONsQBvjrIUzFgS+nKR6fEDl0cJPqyorCnSo1A8tCIhEEmK+vDXYIejTf7O+1RAufBncEJyjMCKkFucB9RveKpQzSg2pKaNEN7Mwfz35hwRdyUjfSA1YCyLLzaE1I/OhmHIyIC+cdOVoz0CvCqwJMuETCy9Y5fyrZD5j0oRWfnhgiJ0L9Sm0i7idXwR7hd1vs2A4oy84GiBRkzmseD5vgS170lHCF5h7WP3nG7AbOwli0+C0FRmFnvrxqrXqGnn61wWn4N96/G3vqPwdH0dz6E8opQR6d/dOxcV8LiYeREduIvVxw5eT193JMgOvaG7UausNOf6VcHubVFE4fZCZ//LIv/Ye9LY1kNqMrxMhiyTD2et3oLsV151OH1bBixGpr3Rn129KsifZxPgu06QaE2Hm7cffhauBqi/MhiM2KuAp29uKGvWuEbK/wxDSw1/jmbTwmgVXqC4wjoQXqsl0djSON+ih5j59ORk8ajBbnqpwX9MZs/RzM/8ORIJVyIAtlBVkh2HEYK7PuOdWjYLBrCAKyuexAb7bgNRy4o3IcM+F17K09J86hhmrsuHyDFsyh7qAr8PZfj7IfNx55zB
 wd+fM5rx
 12HDfAQVF0lVsSBbqdfRmoBL7miH/saCev25Knxm6h3iq88b06E0CcxwW9GdfhO8rHFc4QkjOosPuSCYNxmFcg6+V8suZslYVk/L/i/WMxsNMpV15LTj3NK1qel7edDuwWbyYp2uKyWMSSW7oZkx9E0g/QZIzsKqdbdEHNktvu6YFb2KSEQPNJcomkppAFUYFQ1so8N0L2DpuLXsz3VDjKrvzuC6hZ8Z3vZS8OoPaM3DjyM74xvDC2JIUyBRMkIkqlXVrkJTLTs85vs7xyIMEeBtHYJ7I3tcriF2atHBvKoQQRBjZGp6gh00rtFI67JFTb8id1/jr6HYglQSVHWQsbm4P7Eq3NyrxjCTu15Y9Rw2H8ED4eIAzAtzLXfbLJ6JJxAiv1AJiJUgNaRjq0SI6B9dJBsAZgSX/20rKnx7CLd+/uAxm6SwT+jaNFHBd12gG6JHWytGK+nOI0QlFO1gcTBef4iZpIpzOe+1bxUKe31lCtu1P9pVQq9QAONrjCf0mQZcmsgiw+tJ0kCSWt2LCPvgo2XrYh6BaP6LaAVA8MltfCFzpiJ04LGX92xaO/5PjrOMD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> AI has a point, declarations in mm.h are not guarded by #ifdef
> CONFIG_BPF_SYSCALL, no? These look generic, I'd remove BPF_SYSCALL
> guard

Yes, this sounds reasonable. I have removed the #ifdefs in v8 [1].

CC David, who proposed removing the #ifdefs from the header file in [2],
and Lorenzo, who has already acked the patch.

[1] https://lore.kernel.org/bpf/20260918091058.297740-1-tasos.papagiannnis@gmail.com/
[2] https://lore.kernel.org/bpf/daeab5a8-44b8-4933-80c5-e4145b01a0a1@kernel.org/

