Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC221D4114C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C13F6B00B6; Thu, 15 Jan 2026 04:37:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F146B00B8; Thu, 15 Jan 2026 04:37:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 499326B00BA; Thu, 15 Jan 2026 04:37:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3800F6B00B6
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:37:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9F1CB7848
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:37:08 +0000 (UTC)
X-FDA: 84333694536.30.E68ACC2
Received: from sg-1-105.ptr.blmpb.com (sg-1-105.ptr.blmpb.com [118.26.132.105])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5D1F880005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:37:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ld4zvJrM;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.105 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768469827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fk2RJ3eO3k5qQ8Xkg0gzN5tmD8UXjDhhHfjptuDS4jI=;
	b=apU9gDs19E1IDxR5voHuwYvuNoygp4B0fU8OjPXVjNc417I20+F0Oc0Ab+l0qrrxhnajuv
	PNa5MQMHPCW5stS9P0PmUOHfru7Xo5rAtzyc1DBUYRuT2PjsDaQoRbK2s1Q5Mef0bZtxo2
	tFkVnla8J5sa6r7qPtOBQ/W0p+IIAFc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ld4zvJrM;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.105 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768469827; a=rsa-sha256;
	cv=none;
	b=yeANniB6/kbDqwKdm6xzjSLlltuIvT2RJ0T3xzJCPqroFd5Hh+4x6wzhAzbh7n0gbQIqg2
	XlpQWxggRqJ3CJdekK2oyQoYGxSTmnwt21YsJtWqmpZArlET2tj6I1o+F2FQPTAZxT6hop
	kKZBSgTHXEvxJt/e6Z3f0TRWevY6Qxk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1768469818; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=fk2RJ3eO3k5qQ8Xkg0gzN5tmD8UXjDhhHfjptuDS4jI=;
 b=ld4zvJrMjLJtXzTom3TIhTkjQd7jcCWIcFEXAysIX4bkry1kq3/7xm+p4pwiHc2zEoHfZP
 Yy1Nh6DAn8sFYYs7xeM0r0HXtwKvuFa78WazZ8DX6FefVwQl/yvpvs/cotrgNkuoBrIaP6
 eKumNkYbQWkGPVpoWEWwmDDFo4ml5JIbvgkK3jpPazl+Oc6A3sRrZX9+gvYrgGBTMRm6DK
 9lP5HXg6lXX0EUDdK/2NHuZUzVZCV2nu2/LS5qHr4XLj+DZ+FzIhGsiHcI3xNL570tiYce
 u+6C4YMdGtvchBN4Al1j2a7PxPaHvGJD9Mr2Ho3v8jLsV4jr87xsY2aaEwlVtQ==
X-Mailer: git-send-email 2.45.2
References: <9daa39e6-9653-45cc-8c00-abf5f3bae974@kernel.org>
In-Reply-To: <9daa39e6-9653-45cc-8c00-abf5f3bae974@kernel.org>
X-Lms-Return-Path: <lba+26968b538+ecdba2+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <akpm@linux-foundation.org>, <ankur.a.arora@oracle.com>, 
	<fvdl@google.com>, <joao.m.martins@oracle.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mhocko@suse.com>, <mjguzik@gmail.com>, 
	<muchun.song@linux.dev>, <osalvador@suse.de>, <raghavendra.kt@amd.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
Message-Id: <20260115093641.44404-1-lizhe.67@bytedance.com>
To: <david@kernel.org>
Date: Thu, 15 Jan 2026 17:36:41 +0800
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5D1F880005
X-Stat-Signature: omi8qdasg5j4u6ydj43dotur8bw1qrzx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768469824-897995
X-HE-Meta: U2FsdGVkX1/Ugbps8c41eNl7DORje8niL0dZlBhp76+SunEWqzYD3DEP/ac39pHB2gVjL/3CWKSC+6mM5MVhVH47fxXNMVtF7H6BEfMEDkVGi+nrYljLdp2F2PwZVIS8mAYywQ2cjxV+/OrHSB/b9UOZ1SDZX7F6ZK974tyWBPE6S0+Prz4Cm4hPKcPq8IhlH51hQtltlwuiWobrBxuzc08+qAurtRzVN2U8UE0HpOcb1wksStVQbkKE9KMqByjQ22GS9zJjsNFHxcoKWmPP+1nB2a7+I1VrMlVd0EtHRIsGsUiB45G0UBxLz7PYvpvccou5X3e/99ibzcgWOkV7EUmfcGx8k3SStmf/RI8YvDKlz8n27l1c7rHQEC1KxaZyzF0Skbxdg0yzlx5EafRYtHQUXIcdgd0ltm5kZgeLdl+mRbVD1as3S2tEoAsPQBMmJci2SmTxoKHWr7uXUQSNp3Lq195e7Dej/dsl+lyJavEJHXbiUa8EMXXI/V0SH7w7Dn+Ed3K49qM5OtVLkL+JpiT8N/yHzARVq60TH8hoTn246hzT7orheexHm3EOczpJ4ELktcazJW7d+2e26ltf6O9k5alkAE1HcG6VG8IylDN0jPAiCIq7YzWSwUeMUyf6wmWzrOVGGdiDJ72jFWb6ffWFvrPYt7INAcQVjaK5X/xra4FKME3ZDhsmTlP752w1XGNaZVkmt/2Lv3BwsbC9iac/IKuCMW0oNe7iPIjqggtmodgECbQutmi+X7ogbDCqYCVYRHmTAZ4whlX78Cc5t26r/WL59fAQ3hd+gcXFc2BWMLTKIM8Eu7nGRCfXUUyAPkGu5hsnhdDEcLEEYUpx5Ob+Jpjk8KriG94J/I97HXMkQnwz9qynWmU+4g581JuMaLm0Rmik054LP3t8JdeE/3RoTCnQU4XgjTSurwXLMKywevERNnwqlGGjbmgKM9v2fupuJ7qEB2qInOPR1oT
 uNT2sdzF
 d9PMR6w7fRTwKcWYU0APXOPruxRLttGzPxWLFoUhAy9LU0ItaNFswYzyxwRiAqnhDj8CTROh9WuI2Vtwa6ovUtK3O9TXs7TygxBPw/FDt0vd+lE4UQmkuSxdDrfJuUMeb01LG4+JZzWqwKERjiCWhQlaVXY/ceeg4XlJVCjnJQpmBzc8oca8B27hrU6ez0CZWQVLw3LNajAw3/KL40u66JtuS5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 18:21:08 +0100, david@kernel.org wrote:
  
> >> But again, I think the main motivation here is "increase application
> >> startup", not optimize that the zeroing happens at specific points in
> >> time during system operation (e.g., when idle etc).
> >>
> > 
> > Framing this as "increase application startup" and merely shifting the
> > overhead to shutdown seems like gaming the problem statement to me.
> > The real problem is total real time spent on it while pages are
> > needed.
> > 
> > Support for background zeroing can give you more usable pages provided
> > it has the cpu + ram to do it. If it does not, you are in the worst
> > case in the same spot as with zeroing on free.
> > 
> > Let's take a look at some examples.
> > 
> > Say there are no free huge pages and you kill a vm + start a new one.
> > On top of that all CPUs are pegged as is. In this case total time is
> > the same for "zero on free" as it is for background zeroing.
> 
> Right. If the pages get freed to immediately get allocated again, it 
> doesn't really matter who does the freeing. There might be some details, 
> of course.
> 
> > 
> > Say the system is freshly booted and you start up a vm. There are no
> > pre-zeroed pages available so it suffers at start time no matter what.
> > However, with some support for background zeroing, the machinery could
> > respond to demand and do it in parallel in some capacity, shortening
> > the real time needed.
> 
> Just like for init_on_free, I would start with zeroing these pages 
> during boot.
> 
> init_on_free assures that all pages in the buddy were zeroed out. Which 
> greatly simplifies the implementation, because there is no need to track 
> what was initialized and what was not.
> 
> It's a good question if initialization during that should be done in 
> parallel, possibly asynchronously during boot. Reminds me a bit of 
> deferred page initialization during boot. But that is rather an 
> extension that could be added somewhat transparently on top later.
> 
> If ever required we could dynamically enable this setting for a running 
> system. Whoever would enable it (flips the magic toggle) would zero out 
> all hugetlb pages that are already in the hugetlb allocator as free, but 
> not initialized yet.
> 
> But again, these are extensions on top of the basic design of having all 
> free hugetlb folios be zeroed.
> 
> > 
> > Say a little bit of real time passes and you start another vm. With
> > merely zeroing on free there are still no pre-zeroed pages available
> > so it again suffers the overhead. With background zeroing some of the
> > that memory would be already sorted out, speeding up said startup.
> 
> The moment they end up in the hugetlb allocator as free folios they 
> would have to get initialized.
> 
> Now, I am sure there are downsides to this approach (how to speedup 
> process exit by parallelizing zeroing, if ever required)? But it sounds 
> like being a bit ... simpler without user space changes required. In 
> theory :)

I strongly agree that init_on_free strategy effectively eliminates the
latency incurred during VM creation. However, it appears to introduce
two new issues.

First, the process that later allocates a page may not be the one that
freed it, raising the question of which process should bear the cost
of zeroing.

Second, put_page() is executed atomically, making it inappropriate to
invoke clear_page() within that context; off-loading the zeroing to a
workqueue merely reopens the same accounting problem.

Do you have any recommendations regarding these issues?

Thanks,
Zhe

