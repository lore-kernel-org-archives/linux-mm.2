Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13C82108B8FF
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 04:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230AB6B0005; Sat, 21 Mar 2026 00:04:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0FA6B0088; Sat, 21 Mar 2026 00:04:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CFCD6B0089; Sat, 21 Mar 2026 00:04:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EE9AF6B0005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:04:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 71A0313A7FC
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 04:04:56 +0000 (UTC)
X-FDA: 84568729392.19.1E95E6C
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id A63914000B
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 04:04:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vrHObXMu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=bingjiao@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774065894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vb0hgyyRQxiEoRD57QPoNnifO28j8YAw05wFPmEsgvQ=;
	b=NWNG4sGeud0p7xCsdx6GZnVkbuccXvKraKU7Vqj4N1lOscNnSPc79gn+jJ6hqNmdA7Pfrs
	Qe1TiKdsIVS3H2TBsNmvmNTc+u2CbopWE0JDL93lzBjILgfyl/K5sgX+dalu70DEF6E3Ok
	kFP12bM8aq95hM5N9ZBkVEt7RvGIa+U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vrHObXMu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=bingjiao@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774065894; a=rsa-sha256;
	cv=none;
	b=BqOk5LjA6MRCYl7wlxryHWfWSm60od6Jqrw+px0WlR6V13X3y6LMPL4oNFC7nIgRxrai0v
	NtuhAPngtqD/0VhYEtt/p6Mtld0P1aTEc5t0cXChDTZASR9XWuVKYYq3D6++QOuqqLWrDr
	QnF8E6Jt1T5u6UFAkKdGgX+lgyDSj8c=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2b052562254so55695ad.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 21:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774065893; x=1774670693; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vb0hgyyRQxiEoRD57QPoNnifO28j8YAw05wFPmEsgvQ=;
        b=vrHObXMu+HvaAIvCI3GLaMTqS6g9VBnQ+WJ+QSAH7CMfx1Rjdf9UIR6MyAUn72NxsB
         SuKMbe2Hnq+V/o1UC7C6T5ZsauHMV80ss0HaVQTKHyBoPtT6LKZCXTi6AsbBhgRyLdD/
         +nKSjEURqPs83WxPGD9gBxKwpso3WLrqaTEdvwWaRqI3f1EDj7OYrJqRXfmxk4wU1Qyy
         46MEewMJefQ6Pr68tVTt91M2henmD1GWqYlSX0pKLZvO9V+TRHdJ6kYbaE7ZydvzRGvS
         zM6XhX1y4JPxT4W+8sSomGqdNIU1pRHczZqyC4e+0evWB1ShW1s+VlY+r/9bFht66Bl3
         6hVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774065893; x=1774670693;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vb0hgyyRQxiEoRD57QPoNnifO28j8YAw05wFPmEsgvQ=;
        b=jbQmc4o3QyhgU2dVtXIS+zA++OHplHtgh1Pn66rM2nCRzKoegZwhJFSG7ktlEeF5MW
         eTzl5PO2qEmGf1XYOWliWFEfDJDdAgRRP60rfGHP8dGCDmkpDGuiIwp3edVA23j6xL+M
         Qn3bkTd3e3v5Ihiyf/jNK2GUu/gju3gsqEzEHxegJibuBljx5/KgSf/5QXjtiPj+CJZX
         80YGiL+ONPs+w/wRkdl6Cb0Dc+rBrEXMr0WfkoSLQaTJiaJ+edA11FTKqfhA5wOHOJWO
         vmklcOgk8N6LqegOnlYs6L8OoE7scPN4DDwtiRnrTz5jG7CY+ts1KMLpVn2QX5Y29zzA
         cIfQ==
X-Gm-Message-State: AOJu0Ywudg9zcCq0c5S2rhbKQIMPPQsMYvWTbdRdNna4n0g4U1W3gdvp
	0pqVR59nhJ6HAKmfzs05Mtd8apUWpIa8FvmmRqKhwCOYIu2sZhnZbEVWpt0k9UOE5A==
X-Gm-Gg: ATEYQzycy42uw5TLKAMULf+GtkV8SoyA7HDbkYas+9IH8ZYpHvVRr2o4d1HKAXLawJa
	6WcetQ+WW5Tuj9AaFtMtZDgj1Rw8sGxhMLLDSMWjhli+TZRZTE+u6DsQ1BpFi1Rm6NFB6ecZIkI
	sfsABueKWkdWgQXBoO+GzLM48K3gPNMviTCttXqTM1vWxglevf8HLTWeH0HksqKeU/V9qy2dbV1
	TzyrQC9pXsbv20rNq5H/REDLpQrhwGssvda6OlB+zc4Hk625xlfrm1K5weHf9I8W7Hi6r/1+Ea1
	+gXpNvSz4gWnVF6Atn6n7HgoOx7A1tJXx1Z0lxYaZQe98CMRFE6FHJ8twTX7VWaPYj2ckg+dyJa
	1yhLCqHnGe1Tsa9d7zu6ys1qUzqqqGzIBeluDHAZa8g+g/JV6G8OZozjWE8tY6udRQoxpJWheFE
	0w6TRF2SfBsKOyV/vZL1mGG3Ph4i9zmcgKA7vofQSaM3hdwkWw0NnGq3eDI1Z5OdkN
X-Received: by 2002:a17:902:ebc5:b0:2ae:7fa2:6bda with SMTP id d9443c01a7336-2b08c38a9b3mr1002905ad.1.1774065892911;
        Fri, 20 Mar 2026 21:04:52 -0700 (PDT)
Received: from google.com (206.238.125.34.bc.googleusercontent.com. [34.125.238.206])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b0409f582sm3411460b3a.33.2026.03.20.21.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 21:04:52 -0700 (PDT)
Date: Sat, 21 Mar 2026 04:04:47 +0000
From: Bing Jiao <bingjiao@google.com>
To: Donet Tom <donettom@linux.ibm.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH 2/3] mm/memcontrol: disable demotion in memcg direct
 reclaim
Message-ID: <ab4Y33lBuYiOTGx7@google.com>
References: <20260317230720.990329-1-bingjiao@google.com>
 <20260317230720.990329-3-bingjiao@google.com>
 <380c52cb-fc8d-4fbe-8d2a-f153bd179816@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <380c52cb-fc8d-4fbe-8d2a-f153bd179816@linux.ibm.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A63914000B
X-Stat-Signature: pyenboew55yc9adbaqarjzxayhbubwkm
X-Rspam-User: 
X-HE-Tag: 1774065894-560516
X-HE-Meta: U2FsdGVkX19Yc0CXukHpAY0Fs67gFSh90UejPANXR0GBlSIzWrc4i3IzQIifQnVqjQ4u6o3juEkTUPuyzUYvo8h1bap8iBoqa1kMzwjRg7Cmd+I0YtHZjp9j14n23I8cnFXDminE3aCWHVH+ja1/oHvqQLhkjjdNO9FNHbnaHjB6pmVFP9qDyQkAtPFAF7lsp2g+LcBb4wORmRW03gWWjdfCBf+E4r/1TRwhUup4w8US3QS9XEQDTSMKiPqWRgvd2f+JkmLdJS1bKUorXd5N7wVRj6OmXCL9uOlHO0AbFI9Yg86/+7f2GfXJgjJFX7epNr1ACqftUTDN9DyvLaO0hbHba3ij/T4/wg6cwYFNWG7kY8elEA8UEAUFD1OJsXv6JplWMv45BB/Dw5cLG1SnynBXxoFbfnf0Dm+MYvLwD4ng/MBD8qZFGYyTvkJCBN+xL6ugA6zLq2JpPMPBo2I1oNxROEHyaF1Eq9e0T+sLuriF1JMpErTotIZD5qJ0A9iv3zGnIA6W8ywZ6KLkFkj5KiGi0QO246n/4CilOPgN0XF+RbO4OWWr/ZUkpNDnqmnJNuB+9iDVwy6sB6c5XfruSldZY6HmG0pNhDPHefVKKq820ia+dHDfBgpH3jaLgCE6iW5ZDRTZO6COTHaDd0Gp/o90BLtf9CbjWOmxruC7fm/UgXPcm2boGyuQMC1Z5CDdF9wJ9QZnVqPjJkYanIdwYeoPQTQiMz4VGDr8E/CnCihuOa6fiSquXtUyVPuKMkAfp2TCS7BDzj13GJNhFKkTc82AwrXDzawlUWnt/KPTMPEkX56uPoZKIrPnoF3y9wnL66LXuEpu/RrfDqdQbf28c6Jo1xkZ5HO07KGRzncHWNQndVEdJzuDfY9Nqa74DiFJj8rZQXLfjNVteRkEuSw7tmW9TzbZZzNAuZnZp4zpCnm3BdEYNzjERaKVSMoXvLN37tPCBkWBBweXL01JyhP
 /0AYhuK4
 phw85A2J/WoT4slWGoh1YcBmj3qTozLaiuHf7lXV8DoTmZ5aS6UIVvp8YhLBhRRJKxufkHBtLM9NC7Zs7wXH6Q3DcRrM8AH7t9Y0Ic7Hv251nAaCjA9tSwjFmkEoR9ZdtpT9DZBgCxuonAVju6+dwKhTVOy3ooUFVdez7KcKWM3JCMMZ77fpnO+/DZmUgTXc/e5CuPiCtkMp6KhkPCzAWlY3YhJ4q+YZOaTqSYC+pOh57nWknu+aog8AKzEI1RdjWADRo+ovJurj/De2MUi75v7uRvkHDFtjJUHebVfexM0eY3edtBm5ZmdyLyFXhV0OpJJ6dvs3m8yqtIDYE8cEBX+rNlaux9EuN7jMXb/WSNGqqKkvb1Ea+m0I2uWmfMaujv9VS+ShGU7mhBwzbatrDIcOhDY+KpV099P/xgV+3dYv4jh+rFWhB4oTyooH/iTggVY2YsEJsl/0AduT3J0eXx45addggRExj8TgQIBjZzwtMD8paMZ8uJqMzXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 06:47:14PM +0530, Donet Tom wrote:
> Hi Bing
>
> On 3/18/26 4:37 AM, Bing Jiao wrote:
> > NUMA demotion counts towards reclaim targets in shrink_folio_list(), but
> > it does not reduce the total memory usage of a memcg. In memcg direct
> > reclaim paths (e.g., charge-triggered or manual limit writes), where
> > demotion is allowed, this leads to "fake progress" where the reclaim
> > loop concludes it has satisfied the memory request without actually
> > reducing the cgroup's charge.
> >
> > This could result in inefficient reclaim loops, CPU waste, moving all
> > pages to far-tier nodes, and potentially premature OOM kills when the
> > cgroup is under memory pressure but demotion is still possible.
> >
> > Introduce the MEMCG_RECLAIM_NO_DEMOTION flag to disable demotion in
> > these memcg-specific reclaim paths. This ensures that reclaim
> > progress is only counted when memory is actually freed or swapped out.

Hi, Donet,

Thank you for the feedback and reviewing the patch.

> Thanks for the patch. With this change, are we completely disabling memory
> tiering in memcg?

Yes, this change will completely disable demotion from memcg
directly reclaim, as demotion does not help to reduce memory usage.

>
> Did you run any performance benchmarks with this patch?
>
>
> This patch looks good to me. Feel free to add
>
> Reviewed by: Donet Tom <donettom@linux.ibm.com>

Thanks again for the review!

Following a discussion with Yosry regarding demotion as an aging process,
I have decided to drop patches 2 and 3 from this series for now.

Additionally, Joshua Hahn's RFC ('Make memcg limits tier-aware') [1]
introduces a mechanism to scale memcg limits based on the ratio of
top-tier to total memory. This approach or similar approaches might
provide a more comprehensive way to resolve 'fake progress' in memcg
direct reclaim or establish a better framework for addressing such
issues in the future.

Hope you have great weekend!

Best regards,
Bing

[1] https://lore.kernel.org/linux-mm/20260223223830.586018-1-joshua.hahnjy@gmail.com/

