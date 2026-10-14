Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DDE0CC6B2C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 20:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5B56B0096; Wed, 14 Oct 2026 16:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CD536B0098; Wed, 14 Oct 2026 16:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BCC36B0099; Wed, 14 Oct 2026 16:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09DD96B0096
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:32:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 978CB1C3FB2
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:32:18 +0000 (UTC)
X-FDA: 85322379156.07.D7408CC
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id A425540005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:32:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="El/rYnZ6";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792009936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FxWsMrxZQ6m0iiQC2ennCbyhDPNK9cewi7MvMPPF8GE=;
	b=L8qJcL9jFe6+gX7+1kmHn3n919zyi6YmyaJKduhJRXVvBV+PQlUkIvQ7h6k8CK0ALFPgTW
	toqqr2g4flJk+g5qRaSZVxV9gLK7KG20yvYmUY5/HGSg+Vtb+2Q76biG15y3WdagiiMFWj
	4MnXMoJ00V9CiQM6HNTz3yLzcxVIAko=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="El/rYnZ6";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792009936;
	b=CxrJ1sQifsx7npjvDvjzsNGkLlVlTuhIwDNzdoq1MOzjEIFhIow6VqDIAp1sH1ncV9w7hH
	FhljRJeCFe5pfa8Bs/ASEPHn2i712nW0cgPyahJhBnCsJhWkfz81vzsQXgp4PROrxDrIOF
	F+ONzew0hmtJ4sI7c7GGFIbdEV31Ecs=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-53512cd2f85so57665231cf.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1792009936; x=1792614736; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FxWsMrxZQ6m0iiQC2ennCbyhDPNK9cewi7MvMPPF8GE=;
        b=El/rYnZ6Yf9jiODiPEY7vRpnv0+NhuZLVaLhd7kdyyzSapaTQwgEiipC+y7UvbxOjH
         IMjWUxeoYHiPpVwijVhAAuj0PBX4v+9Iph5A1vOl5ifb4FXtclkdG8Y4OAk+aAt2jzFN
         0agVQselvjjcbUfycApRStRLCZxdKDKoTNpSAuM6g+W5RktZ4S3o8unwOk7oXVRj2faq
         4ZWJDEggnLkElwpTyFtOcnyhRxu+2fwigPCmxihN6ZVdDSql/s9XEkpqn0/bGgUuu5Xf
         r25Tm0kkPuAawR9bJnTq2L69Is5bwztZcNPrpE0YEOy4/mLe4A/esq2IlAHOovXNKx/V
         tHaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792009936; x=1792614736;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FxWsMrxZQ6m0iiQC2ennCbyhDPNK9cewi7MvMPPF8GE=;
        b=OXG526oYmkV/gS1ageq2092FrPQv46GpEJiVtk+aNSQb1QC9IpcaMcILpzbN7Hjmi6
         ukGmMtYP5rYWDKrr5l98RQrnBihTNGbC3wLw5LSdru4dCgm/+IIODS2bGEmjoJ7An1ao
         mBxmSwhNpNaJeJNfh0fXF0PyMEFkJX/gxjR/bVSxEIB7YMIS4zu2xTzLAmeS7Uq11747
         NFL2n0JIagOfptoEIFd94AvtZT5VDOfXhXE/GbAkVc4/or1XbdYPUUTnyQBXndVCtUQJ
         qF6BEur1vxPmgoQwpdy4occmu10SK+3zuXw2JNj4Ya4jayZVzx4qQvjOdhLQQKWwk+mP
         MO5w==
X-Forwarded-Encrypted: i=1; AKwUvBxTs+suXLkw2CnKIVaJBI3GRr0bKX4xVtg5et0Bv7QfKIme2vXsR1iyHR9B2Yb3Uulr8mTSXJo0aw==@kvack.org
X-Gm-Message-State: AFq9FYLhEkMKi/mcht48e7JeDg2ytn4TsENsJDJwo4PfbcOimWs13BOH
	4cunvndWFhT6JG857Gehbn+xROOXqQEzM/SpqVD6OvtqkW5lTlyBvbXsWV0RJWHMMe0=
X-Gm-Gg: AYBFou1TW+hueDoRpZNEvJfjz4puhGxK8Fr5yqcjWt9TjDV4orL9NNaaNtlR0urdons
	Ic7uotmgnktlWqk4VN1NZvksL8azFDsTnD3u5UsCQZYis5Gqo5e2WaJ47sTFsNdwgJzpKjPMCWh
	qBkkyiDfZLI2uPQNgeqOXCbt2uWMq+HI0OZToVp/WhcRM8N76U3tT/fUHgxv/+DVQSXHdntrPDw
	8ZisH6/bUz/m/khJZjaYgATNzaWrQ4/AXwVHMXgoSvizBEunDraWK7TI827Myu+jfstHLc9YRaZ
	bQ20pehqpzaNOPO6C3+E398s2m4OcbTvwSKFi6XXVju/+J9LSmg9+h7Wql/7nO/7Tpyp2hAPKQW
	i4LcvulJ74oAFRxZfYx5NslN3ZfMvw62CEexqOAPxFRtUyuQe2Ozp/ZCUXgwRI7VCyNOLQhvLjh
	fUXz6cg6cS06xtrWgEP4/ON84eeQ+MJQgYQzj6MYjHU43aptMJD+83cQBz+fAfU87dvrgD
X-Received: by 2002:a05:622a:130c:b0:532:e4bc:b80f with SMTP id d75a77b69052e-5359fdf65efmr280266751cf.60.1792009935766;
        Wed, 14 Oct 2026 13:32:15 -0700 (PDT)
Received: from localhost ([2603:7001:f100:5081:9526:3c0:45cc:5ac6])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536127b29desm6136881cf.11.2026.10.14.13.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 13:32:15 -0700 (PDT)
Date: Wed, 14 Oct 2026 22:32:14 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Nimrod Oren <noren@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: stop recalculating min_free_kbytes once set by
 userspace
Message-ID: <20261014203214.GF371161@cmpxchg.org>
References: <20261014140859.1006967-1-noren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014140859.1006967-1-noren@nvidia.com>
X-Rspamd-Queue-Id: A425540005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: ei6941zm3ctd7efruxz6wxaau5qimck1
X-HE-Tag: 1792009936-444362
X-HE-Meta: U2FsdGVkX19PyYmbKvCSKrv1kZl8USPgt9qUbMz71jL8FxNC7Nt2SvO0VMRDMFJFb6jj/HWd94ApBvEcxXT4nvtR//ou0RhixhnAYgdQbROIiF9IdvOXLliLGGCYp8zKT5990Dgb1KmCjmYH1zSZALc+s9hTeGPn+dwUZ8tRf03m4PHpjLag6if4wJ6Ubjg0ZxwoFretejMaY2S7+VgVN6fjQ18HwVkLmCDsLOZS0lqdcESf77PLUztf1bgXgix0+KwPiIzcOGWwJYuq95Y1FmprBVMhDp+p9RD4ecQcjcmpPk/nv1Oxm8zD5+HmsftnNfKGZerGPSpDwRnUKmP4QWxRKc3+SIvb6trBYflyIwegjBQ660PDR6WYomu1SAmGzhzGGdfZu1OI+UBpIn0dizEvYoV0Hq25y8bwKCAV1J3nMwcdhHtNU/xlnJYUWPRKVsUd+cnOFaeundnkDti/WRl5VypBE3M+MKzPYmBf39v4ZduOS6GppXr98iRIBGAGqkdIOcf7DELvOjbEzbB5mALf2APl4Eff1K7h8wG6cCtSJd7GUXcVxHToS3OH9F60JVC8J4LC7gJDIHpRxltsJZfrvmKiDLoQrg5gXP3PCF4MC6TwH4GUZxDoKGB2RBEBMQKqCCvyt6OBh/CEHXOeMjZW3RigSYPdP/RvpPrC+Ek3C5fpYX85a5FbcutkZpJGsYcg6F3Hmh4QVtuPI26sajD0P+v5Yp/EgKYD8vPe/GvjL76s5+Lp4CGdIkbkSUwGQNg8nzyqHl331FE6+71d+hrkMR4Qot03duvcA53s4V2pi/CIqrtNrh4fMICoW/nShcjLvNO5x/1q0s0seWfQ/jHt1985Psp8aXuA2YgAZ1kFdgCA5qCuVk/OtJxtBhV0gyEbVKfjRqyNvozJPHflp6xU7nq5TEGLznvXywUgVHo8EjdFDftCn1TltFEhgYk2cE9DfP1o6D4Z/S0h2G8
 tSdryZfx
 2jOnTx2xtCPfd/hy0BblqqTax6lFGxi3i+hpaAymewp2BTxxvFq1gcCxFZXADaoULRXeJLWUyoWIdb7QdeNoL7QSZcl0aNuun6Y93DCA6i8u01RwW8YzuFw+E1QF0Jeje237fp1r+CmqpifFhr1cuEt6y7+T8lZXB631nsh2h9mTw5T56JUOHJz9yO8MBS+q0W04dHNRvuemgsK90zmkMwBrCorkCZUL9Oh9xZhyeDzB6MlQNUsDhXP4wk5H2xw8LUvc8M1URvzfLAXgz2N2LFNWbrwUGZbn0FhiKOOCuQYVA9ZnphKix+klzYi6JrLpSGBv4G5VEPJBV7DkwSRM2Q5FEVoFC+4UVF6ErpEVTDGgBUk569UJwWjKHcWnUbeLPz+dR9zBAxj9yR7OEFM7yYZ1iibR8mZKereRxBQmJ0TjWEtOUw8mPEDlErurvrq4t2p+LMbGWa4rosFnacTnaujQSzfmn5r2IfRDo4X515PzcmJWtXOrr22lWjkf4jmo6W/DufAY8bXL7W0SodX/PnyEZGkAowqj7QixL6hTh6ErlHX/2ngeMVC/u9eLTHE+yGnfXjcCet7ZFWfogLQCNHMvk41VDBBzhhDgs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 05:08:59PM +0300, Nimrod Oren wrote:
> min_free_kbytes is recalculated on memory hotplug and on THP sysfs
> writes. The new value comes from calculate_min_free_kbytes() or, while
> THP is enabled, from set_recommended_min_free_kbytes(). A value written
> to the vm.min_free_kbytes sysctl is replaced whenever the new value is
> higher, so a lower value does not stick. This matters most when THP is
> enabled on configurations with large pageblocks, where the new value
> can be excessive [1].
> 
> Stop recalculating min_free_kbytes once a value has been written to the
> sysctl. Systems where the sysctl is never written keep the current
> behavior.
> 
> Link: https://lore.kernel.org/r/20260716173504.760369-1-noren@nvidia.com/ [1]
> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Link: https://lore.kernel.org/r/d202dcc3-d7d7-4e98-a9a5-3137cfbfd041@kernel.org/
> Signed-off-by: Nimrod Oren <noren@nvidia.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

