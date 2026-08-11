Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7ADCC5CFE7
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B67C96B0096; Tue, 11 Aug 2026 12:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19496B0099; Tue, 11 Aug 2026 12:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DFAD6B009B; Tue, 11 Aug 2026 12:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 72C856B0096
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:44:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB97C120134
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:44:26 +0000 (UTC)
X-FDA: 85089561732.16.D42AFC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 40D08180003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:44:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hHVkB6GY;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786466665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nDP2yo4Z7/8hyrcK4LHPjnUI6OonoDg03U38JzRLms=;
	b=6fHICHZxaVoadRdp9qnKtmSDMW5Lu+S2ItUybzM6LYymHqwbb6wK5YYPohPAll2kf8DulZ
	r0DNeV8myhvQqV7PZZ1vZFE3edcbb1YxP9kRTRH3q2i+bIF/0en2gDPKUhc5K7f2OML5Ie
	FpjjxtZI0PLLuZ7ICePJs81kjooBwe8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hHVkB6GY;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786466665;
	b=V9bfGaPvhxyANuot1kAQvgXexbSnHfcuTb6H8Stkl2bSVyltd82f56cGeERibAg92DCylw
	/CrOV2tghGYwaXm+qM14tr2oakbbL2FUFICXWzEqFO71DH9Ciy4FPLtlVK0tiWmA/5C3o9
	tDRRSPDG2aaBeRmaY8baX49ZMXjUNpU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CCEF4600AD;
	Tue, 11 Aug 2026 16:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955941F000E9;
	Tue, 11 Aug 2026 16:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786466664;
	bh=2nDP2yo4Z7/8hyrcK4LHPjnUI6OonoDg03U38JzRLms=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hHVkB6GYhX+6ZWhhsgZFxKzOnkGl2RYOjzFptgt0LCOOUol9ozVzcavLD6CvDQydn
	 dD7uSwc6jau6XFfSmk+IKexK6u8o6CeKGHkCuKXrrZ5ZTjQpBaNq7q2BAxRoNZpfbB
	 DFn7OzDXW1vNtKFqNmrCGSpgV8QZYUsLSUd8vGpNzrrwVHH9yLjObobUtS5Znirks1
	 g0F47R8DNocE+LgLop8peVMqvNZ90+CL5I6DyccMXHmwf3Ag+Y2iz6YFiIln1mRPt7
	 UdIgWjZ1qv52eMMvDlYKcast9now6cuY+C80b4nyZpyoCm5Lw8Zk1YHCZaDr08uci1
	 VSMkUMM/zhr7g==
Message-ID: <3a0a9aaf-20f5-4f92-b848-00ab702e8fe2@kernel.org>
Date: Tue, 11 Aug 2026 18:44:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/20] mm/vma: fix self-merge check in copy_vma()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Alex Deucher
 <alexander.deucher@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?=
 <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-perf-users@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
 <20260806-b4-scalable-cow-virt-pgoff-v4-7-ab318a350404@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260806-b4-scalable-cow-virt-pgoff-v4-7-ab318a350404@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wwaff3gi6y437f5c4fdqjs1szaunkbd4
X-Rspamd-Queue-Id: 40D08180003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786466665-253560
X-HE-Meta: U2FsdGVkX1+zv7IfshMeK6zGpbq/8wlzLv0Y5YWfTgN96nSCGVN+klKS7WU/rMPNdaTqwp8qvNr2MBLQlIsfafCXYJmTzt1Z1MvZ89+uo2XGISQrURNeRkfV/jkr7+NnxX9TvP3YQd0IGbanuoLXPwFeu5nUnysaVaB83x+HRGu65xnbqL7DMQSBmZHVGS4JPStFt1xJ9unMzxi0sJgNGpSu2iVVU5ODb5wzKvWph/ho0oa932K9KQsmU/87qQXOCTIMosygHWYFRdxoebpn4HjV8tiVvozRh33wT8vH8d5QKk9o8u95PVjqm0OfC2CIkooEJ7jLE3aArdV0MUKGsj7QXChyoHimYEUU6DTiZsoIxl8QAO/2IAeuaqyzkcarYIcZftc0gzPcbV1wh8BpBdBW6Yyx6k7oU4KBcbEvJmjVsnt4Cq1W1fBw4daH7uu0YCsQw0N2dKjCjzhNwgB/NE4jDjK6HNTvXxjL47drSq7/jMDG2OlZ5fS4ydyhBNsNbZv1nPBOdrYEQMWJOFl4xSL4KYMmaQqBetYp/kRxQ/xZQ6k/wjc8Wwp8FXV1ZHmwVEapZucGAZNv9GwINYh/+CmQk5Oedy215a6mVa0Hp7+gnME2Mpu3Oq1H2MLfRqncIrWUn5q+RSLL7nj0kdq38bz5PnjAloC9qxaSZ2uhY8xfSrXQHTSzHxOuUCYqwGqXeTDyNWfY0eTZfmQ8SzKw95VCP2cfjcF0nDog1NItVPYTtYrvrvPlHPtc+1disNh5YxhKX7YNaJHkf+Eg4dgNy2RyYNUvm3QRBM2ugHJIdWRVWcs068APR41R2UbAmcNw+rDE9ubjS5HBbt2w/cSNzKjZ0lLKQtjbHXSvxTOm0sJP9N2kvtzXNS8a70MNyrm4ccAiho4JgpDaetxGpwpqYbg+dALQ5z7lfeG145jz2hTqe5ulyoc6N9CfbAQA1ks00J4m4T0bgQklA6UF1o2
 1/ZvTbdJ
 KL+vqFDK8l1nPxNPZkh4czzGLbqE8nSHalrMKKyuNgom4mkb9ToYX8l6TxDDSVq1tSIg7uMH1elPBGifLa4FNfMbENY0g0WKt+1G5tlC8DKF5bV6s9beDgxVF7OgJ3Wbu1xaRs8FhgN7mzrMwnDEeRxFE+Nt3yXG5bPsOZndDEqXTEaU1LXxAWCwciNmIDqdQWqjZXxyWRJ6t86esCkv8EGDL6APBSdimzdbDHKQzH6cX9SRCIv+hEf2lNVvgVY0OLFbM6yCg6zlbu6a9c4pn1PL268/LlkScKYUGNBZTDCuZFqx1Q0onxnNBZrEP7eCYo+fqV7yUV0fnc6NnlSE6qzuND2PIStbNa2A22Qmc6SNelEsuSUbgHM+q+8vyh9OUexrt4qKTt90Vuq0lhVQrYiKYIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> Since copy_vma_and_data() which calls copy_vma() intends to reference the
> old VMA after the merge, it must have this pointer updated.
> 
> This kind of self-merge is not possible with a succeeding merge, as the
> merge always prefers to expand the preceding VMA if possible.
> 
> copy_vma() accounts for this by explicitly checking to see if a self-merge
> occurred and updating the vmap pointer if so. However it incorrect did so
> even for a subsequent merge (this is simply a noop so it had no impact).

Took me longer than it should to find out that this is no real fix ;)

> 
> So change this to only check for the case which matters - a backwards
> merge - and rearrange the parameters to make it clearer we're doing that -
> i.e. check new_vma->vm_start < old_vma_start (having already renamed
> vma_start to old_vma_start to make it clear this is the previous VMA).
> 
> Also update the existing wall-of-text comment to be a lot clearer.
> 
> While we're here, replace the VM_BUG_ON_VMA() with a VM_WARN_ON_ONCE_VMA()
> and update the VMA userland tests accordingly.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
I skimmed over it, looks correct, but the merging stuff is way over my head to
confidentially give a RB tag her :)

-- 
Cheers,

David

