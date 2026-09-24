Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2CBCC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 14:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDC6C6B0088; Thu, 24 Sep 2026 10:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65C86B008A; Thu, 24 Sep 2026 10:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55636B008C; Thu, 24 Sep 2026 10:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80F8D6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:08:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1917540345
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:08:20 +0000 (UTC)
X-FDA: 85248835560.14.D9095BE
Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3148920012
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:08:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TYgqgnus;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 74.125.224.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790258898;
	b=2YWKFDRMo4Fp7w8/YEjNrmpFd2zNAxyGeoW/ECStyp3ENGnZ9uMhq5kwFbwVrtHGnVBx32
	bQhdxwnyqVxoKVP8KxctlvJiaVujOCpjorqRE5w9c4XvkOdRFBbi4DdAb5CpY1FMyDwkNv
	rD7jY28bg/HjiqrHmM8gHrAo6H+S60w=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TYgqgnus;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 74.125.224.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790258898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vfI1NR8Tep8AKRWcGdJ4Ave6RFunEN3KZDqYuNUnkYI=;
	b=FEdoU7fY9zvgQjLstR5T6849bMPK4+P2tmz5kHRCnbe5+j8WGtWu8ICb8F9Isv4erm4S/0
	lL0Ncnh3p+amZf/uWJSdRGGfa0Yoq4QQ3rCPffJJ7UY9eZHnhIRWwALHpAej0k+zpx39ej
	8p4PSVwDkV/i1Nl8kOU2i5RY0i6jT8g=
Received: by mail-yx2-f43.google.com with SMTP id 956f58d0204a3-66f943b286fso1955473d50.2
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790258897; x=1790863697; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vfI1NR8Tep8AKRWcGdJ4Ave6RFunEN3KZDqYuNUnkYI=;
        b=TYgqgnusYlVyg+0dv2poxCCViSXZjhKGw/C7NzUvNj69srqa2oBdBe6rDlWVXI8FzR
         jN69NVLQJWszzIBxttyJs/3XyKXcJqr4x/A98dIuZRz0HgwO9i9aghWa7jGNYOGctf1f
         LRTxAC2qiPIrDQa/SoA9JSK4/j07SwxLRptdSRjpMQWSpmriRfXs+mIzS/quOtC7uW+Y
         A0ijZHKts3LhfL6GObY6VoqaA81gJGdvrxEXNrVKdARJbRlFjfGeh472TB47eT7T5eC6
         e6XGIh+kIqe+SRdpeyYPxfqbQYj3+SqBJvIJ6RwZ23xEtn8bcOnhir8A6FmL+pSYfU6F
         6e/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790258897; x=1790863697;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vfI1NR8Tep8AKRWcGdJ4Ave6RFunEN3KZDqYuNUnkYI=;
        b=q03r4PWuDQd898yf4g8cJXLqWR/2HzrZZ1suzU3w5qS3GyMt5QtbnagBA0IRwSlGaB
         i+mHHLRWMVNd4DvIvGnXdNC2sTsUEADPmZrOZZYvemruD2XGNxMl8dxCz0CeSVWZsoTB
         N4WWMPSpDlzXnAgnySQensIuTatOUp8XlJU7FVwKJsVyXuGErRAkrU2MZN5iKn4XibLn
         D4j73Z8GkgIbEjQQVx2N3CwQDAGUhgBzTAtgTG1cmS4efyhrheiIVEZrMbDsKXI/1iRJ
         rB9ZJluFw5q/B32tZaa2HRT1Bxv9HVrDNKnN7T4n0ATpt5k9qy8fBKFJdJfaxYWH8j9n
         r3cQ==
X-Gm-Message-State: AFuF++klijkesuZF//pJ9ShdBYBP+5dNQxHub1P33NP5yoRsAOeI2qeL
	SkvvIepTHpBwUv/ct1MAJgtu9/TxAqZMwQAPwvT0nqUC6Z5dA71fiXH7j+WvXvukH9k=
X-Gm-Gg: AYBFou1+JiHeUabHHr+xBj3KjsSfdsqHxrOzl9xKRY59qhywX+3DZT3zqJy1KOz3cxT
	otmkQKt1oPwaHTwunG4ay7R8iKY+SsEMmRJvzvzKFV/T+PQl/KnTv7SO156/QYlBneNhgsgsNtn
	YC6K2MthFFeQ5gRto2JpyyTTJ8lutLd+nJ1+SCA74H8eh/uomfmEXow6515ysP84rynZ9hSTFm4
	m7Q8NKhxjejDVzOfygS7wkDUHpLkFr7hVAU2s5RnJjgU5X6EMv6ivBPL9BbdI7cSrWQ7jT5pDnp
	bQ0lnrUoiEhPTP8t+8Ff0EoQkNn6YnP00eGF4LCKe4sDIW7LLw9L9Am7LtyBWgfAl5casFf5k0t
	i7BY6Ir8/MUxj/pnZWX2E3PVGQwE9/DU0u024oh4Q7EzdswEXsm+BRxBDnCpmlQXf+z6ZnDfJDl
	qMQRgTjEKB2qgp+xzfMuXWoCcQW6VCzM0J1S/cKOxoKVmCRpeDRB4XkC+qKWx8kG/Pg9j4Hn7cR
	fpUap1hzDf86n9Csy7AO6La7B0YcL15/8AeewMFQVqdg/PNO9KDA6Bj
X-Received: by 2002:a05:690e:169e:b0:667:b503:4d2e with SMTP id 956f58d0204a3-672ed1d4e4bmr1602236d50.37.1790258897201;
        Thu, 24 Sep 2026 07:08:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9141e217944sm17455606d6.9.2026.09.24.07.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 07:08:16 -0700 (PDT)
Date: Thu, 24 Sep 2026 10:08:14 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, 
	hannes@cmpxchg.org, shy828301@gmail.com, raghavendra.kt@amd.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH v3 1/7] mm: support promotion-only NUMA hinting scans
Message-ID: <arUum9WcKl8qF0UC@gourry-fedora-PF4VCD3F>
References: <20260922182928.2199090-1-gourry@gourry.net>
 <20260922182928.2199090-2-gourry@gourry.net>
 <8699eba1-21cd-420e-a992-51a90ba62b71@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8699eba1-21cd-420e-a992-51a90ba62b71@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: i1hofmi9kgux89u58k4ueb8u4g54464e
X-Rspam-User: 
X-Rspamd-Queue-Id: 3148920012
X-HE-Tag: 1790258898-102953
X-HE-Meta: U2FsdGVkX19D6DK4Ax0ExWNRPP9AG5s8i1nWEjBHaoY3WxsNydRTvFmYFlkozoHB66oKbvnRjLJBYN+r2jTwgkTkSlIDQ92KSQVIHWv+lK2I5cv1cXIVWZkN8QuhqXxxR3XaLFMEJQSDGFMQLST1EW19dzom2OtM5JvmqrOjOWW0kRJQQOLOI84exr9TDVwyE04m4lYKZRGlv53XbgQgXPaX73qT1Zv4fJZUrVaWdANgy+AJh1JXpd7/A9Qy7YYCMLyAIYLe9BU2s2BkwgNjDsDMjdN+Wpx8dg259RUW/TCmoh7zcsHksNQyiYC63eW8GhAdXpKDGSPUe+C95XVzLzptrIeSq3xDPN0aBFYdnQckc30pgsDGVIs/WzN5CbY61QD5wLdVzy1yfliBpQnH0LiQSNV8PlbuX7bvtpR+SVjSzvSjeNMnfoGMqlq4+lsFEmBJ+RtEnSInBfX5FrdYMJMt6I61p90N44pdcDj2FPDdnO9w7gkixZpnp/xEDE2s7q3sGPYjMbpuQdrZhbiRcgh4tc+vmpqpvoP149HV9TChMKeETnsxWoNH1m2AyerAOYOUl+9xINQ62tEQQdvtJgLN0YKlO+tR5IxomGPbMMnk+Bf/Pfvuxs3E8lttKTk0pYt0/qn4WwsuExB+sppmP/AcO/lnRLFD9bktuzixEQdnWrkROBEZ3Yc+EiTVAmQEejNOIsljeUmhhuqXJ+QGGdyYQQh/1lODHvtk+FAqRP7VdXAplAGKsJSD/mYhJNsq5jfzj0A+ighN0789tHbev+966RqaxDcqBUaIjSItWpQp6jI416AJim5I4xzcg5bUpIyEhbH5o9zojlLbhAiLv3q+Wti1Tc7sRQ1gubi+yyICHh0kXiCWFuLghib6kPoPnip3UaX0cbVbWcTW0ILi9dUkIwsbSfk5m04h4tlabso7NaLz/zpwQmySnM0bRLKoyp3r0EGpvoEdtP0a1N3
 m2F8eZSU
 ttc79xvnKIM2i38JluKrZqQP9SQ6CEZA8DbRe3jFcw7CekNMFGdRIXkXeABNGjQCTpWfBdDY7eHXPoflZpAnab9CwRAomzWNJ719esbtM0kCw14BGkFMj6hhG54n0IYT/pcCByR8ou4SauLOo7c+CoaDTpfyceRzjAQ9U635A92cZ0wfLrC+sImzzu5C+y4w2p00qDUpnIeu25zgi/O+BxFcHkWcBycJMn2lVwHCfj3gd1zLbnOqEccM2LTYBwOJjTG/FoUbblLngSj7ITv7xt5RRcGRLiKfZBnQIRfx3iRmcVzd23ABdYQnAzRUe22tuUD6T9mb5rAwmkkK8Dob5N9sCtuMtqI53Vi7nIaLTS1P89KXpg96AM1tFjIRO/ALtQQB6tryW1iSAcxnvVR5eiq3FuyoeqyZg+1UzVnZy035w0kiSKBKtg+gNMgFVL+RcuVKJ9H4i6VxMZxO5GSfQNFftqwJk3CYEF2G9ypA6lAwW2iI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 01:45:24PM +0200, David Hildenbrand (Arm) wrote:
> >  - Opting VMAs out of scanning because they became inactive obviously
> >    breaks tiering - because the intent is to identify when a VMA
> >    becomes active.  Applying it in tiering modes causes
> 
> Incomplete sentence.
>

oi

Applying it in tiering modes causes VMAs to become permanently stranded
on lower tiers.

> > 
> >  - Opting Read-only file VMAs out of scanning is just incorrect for
> >    tiering modes because its intent is to prevent bouncing between
> >    sockets (east-west), while tiering controls tier migration
> >    (north-south).  The result is hot read-only files can overload
> >    lower tier bandwidth.
> > 
> > Add MM_CP_PROT_NUMA_PROMO_ONLY and let task_numa_work() select the type
> > of walk. Build the change-protection flags there and pass them unchanged
> > through change_prot_numa() so its PTE/PMD paths use the same decision.
> > 
> > Have folio_can_map_prot_numa() derive the single-threaded private state at
> > the point of use instead of adding another precomputed boolean to the
> > protection-walk interface. This keeps the interface focused on scan intent
> > and avoids plumbing VMA-derived state beside cp_flags.
> > 
> > The tradeoff for the cleaner interface is an atomic mm_users read for each
> > folio, rather than once per PTE range. Check the promotion-only top-tier
> > exclusion bit first as a mild optimization.
> > 
> > The scan-intent interface is required by the following memory-tiering
> > fixes and must accompany them when backported.
> > 
> > Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
> > Cc: stable@vger.kernel.org
> > Suggested-by: David Hildenbrand <david@kernel.org>
> > Link: https://lore.kernel.org/r/4d2853c9-edf4-4685-b186-7214ed6abd84@kernel.org
> > Assisted-by: LLM
> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> > ---
> 
> LGTM
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> -- 
> Cheers,
> 
> David

