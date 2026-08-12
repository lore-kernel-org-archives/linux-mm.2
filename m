Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB81EC5CFCF
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 17:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90E5E6B0105; Wed, 12 Aug 2026 13:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BE9C6B02D7; Wed, 12 Aug 2026 13:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ADA66B02D9; Wed, 12 Aug 2026 13:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51FD76B0105
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:25:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DEE801603B2
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 17:25:04 +0000 (UTC)
X-FDA: 85093292928.28.21ABB1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id F3606C0008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 17:25:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=okENkuhg;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786555503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4oSNzFjHuzTOgbEhKYNA4ws0ltCJrHAzS2GU8pXVakw=;
	b=RNCEuhQSMvqcfiVCZ+sPYdOLK4b/8NXkJaaVRqGWraYLPsKZov5pitHeRxY8ppaTNqC+94
	ZS7yMAG+33KlWW9jBC6yZ/yFnF995j69fw0RQ7Ce38nz7bULDORG5dYBPxyqFqZavx8ToG
	LmjkcwhPRf0tf9sOFojtJshUL2K9SGA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=okENkuhg;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786555503;
	b=b7YhFvx9C4hxBB6wY9lAKTV6mVj9zKugF8BOKejhsHK/Ef9R5qiSrSspQaYlOVCHCpVAHe
	7GO88q/jxU2bSVIiSawL5P4M+a83dPnL4B2Tb96WOi6NzCvG9lw5CumCd2vM+jsi/j7iv0
	N1RTJFWKVolCn0ty6eG2f7pwjIKuxQk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 284A760A7D;
	Wed, 12 Aug 2026 17:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078981F000E9;
	Wed, 12 Aug 2026 17:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786555501;
	bh=4oSNzFjHuzTOgbEhKYNA4ws0ltCJrHAzS2GU8pXVakw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=okENkuhgzJjXS2UaQaKvB9ybQ+m9ds7pwF4/b8z12pNVDtXC7HNFGnfr3MAVGjum9
	 OvD/UR/LQA7302JY5sAzT40e1zQDjEK91x2GZsHTbymznhWHeWiZDz7hwLCqiSn6HJ
	 dVm/gtD6dBtUo5Ozo/Ni81ygCihwBpcTeoM/4Oqf/oGFAhL3/gVP1qSTk3tipcc1f9
	 u+sOr4XyXy7FN4TCvoZtjmKo0V0yvHBm/1K/pWlH7wTBTxGJ51f5FevBzvXtye5VVe
	 yrp075F1nLy9NekTz0yx4F7BHc6yPEj13/zVnbG0vx+U8pYkCM5NqOG4MzgR1FeG48
	 OfkGs+4EOKBuA==
Date: Wed, 12 Aug 2026 18:24:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Steven Price <steven.price@arm.com>, 
	Liviu Dudau <liviu.dudau@arm.com>, Huang Rui <ray.huang@amd.com>, 
	Matthew Auld <matthew.auld@intel.com>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	intel-xe@lists.freedesktop.org, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v4 16/20] tools/testing/selftests/mm: test anonymous page
 offset merge behaviour
Message-ID: <anysQa1hC83cdX_7@lucifer>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
 <20260806-b4-scalable-cow-virt-pgoff-v4-16-ab318a350404@kernel.org>
 <cf70ce8f-cdde-43ec-a50e-796d4e390f3f@kernel.org>
 <antWw3a0iEv4l1Yd@gremlin>
 <20260811130832.3f18d4326a5ebe6eb18cfb5f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811130832.3f18d4326a5ebe6eb18cfb5f@linux-foundation.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F3606C0008
X-Stat-Signature: wf85m8qwud8zaf9pubj39gjciq9tm1u7
X-Rspam-User: 
X-HE-Tag: 1786555502-707370
X-HE-Meta: U2FsdGVkX1/2A8PNnJ0EJgrf+2BOycHb/AmdqyNFyrfI2jxcbDx1cxGWIXT8ezNj7+sGeSjVQFfcwuoW/YvXUFr8Z1DdQ2cdByt0l5WPIBnHuhQeC5YRbzgWBb6jUZsXvq3LLcHLyLtpcqCPDGMuIFFmFwTXRqyabt/gJXSWejhC4vp3X7U89CzEMF05+oidsbcOOvPvcgHsm5wTfFjKGG1kkD5YE9gTGktRNJRJLsjh+7a6FL0plm3msePS4zQzmQmqsqcNgSNbiH6waaVOTewEVs0rBtXLxoXVjZ01lkIHqbAPQC1hI+M+Ov+TFF/6yrNSIog+pRyYngeg7NWSp6Dp4t+uK/CgzQ7RWVU812tR2JAOmaDrQw83fmPsNme1Mz4vhfmuaGKBv8DWC2mWCMKb2joMl6bRrQwldRXSetXOF4/SaRAs0DfUZX3yqva2y0tSmKL453J9UuLNSxQNKFWFm0C1DxY8ADSR4qFYKSvQYeyEnQpQD51gUL2T9c1n7cSlAHkH3VssnCuidA0czMq1WjERIEHTxDWxYGqNE95NEOs1r90qvjHhOVArcWhn3ovrzlK0Gdwp6LJ2Pspo3wJQjtdlMu6+PjL6AjC7hfDbTFhKT1T5Cf4DMGpHuT/WkmeOekjDxHdRypqlREok2M1ej2zhpluJ6Zq7QxpVqQ+YFFkk5HpNdxrDmRNs1TlVrmWfPjBEZn/ptcHKB+Y050d9MSunYoHYOCO8FgaowHv0IjAZiTQ4SLxDSk5gcZAhcPS8yUSdb0HP5zePyR1h0z5VN2er8Iz5SwJ5+fq8hfnhrOO6fzZoC5R4vZ9HnqBwbN7wByJvt/BK5pLAd9AXShkSXhoByhqyjz9djCwQR1sbDicwT55i6dbziR1u78accgaQBKt14vhDO2ZCvW24cHYz4fZYtE7fSrOjrrj+XMK+v8hYs8wDgFXAQr0zvNf7nkc+vnwj+e2A/pseKqC
 KqoThsL+
 8zwtP5LjOSi7X8r20J8BXlY3EsEgQ+t7sCf82zwZwSIUgTw00AQpksqQYIDjWPNMr4iBspGV3Oz4WZ6VH++Om/uQh9zLI7ra0QkalWafy0lT+9alDpOGS7yEzp0I4T47g4aSCwQ0PRGgOK+T3+irzlss7kymyvcBTnuhXYeydX7Ewem/vZgiRNNoW7fzDZQJX/1io79CAAJcLEkvqi9jiqhUsM7+TGuN8t6faTcANoyYF7dbigpanCx2dnOZI7rbzPnmeKqfFCrbrTVIZz7JVx4zyrqQ+nyfzZjTUS2YHgKca8rkGFlo4feCiN0AfE4ugNb+2iiJehFHmIyMGJ4sGUa94QEtWLVLxbJQ5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 01:08:32PM -0700, Andrew Morton wrote:
> On Tue, 11 Aug 2026 18:07:36 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > > "Fault in" is imprecise, as a read-fault won't do. "Trigger a CoW fault." might
> > > be better.
> >
> > Andrew - could you fix up? Thanks :)
>
> np.
>
> --- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour-fix
> +++ a/tools/testing/selftests/mm/merge.c
> @@ -1324,7 +1324,7 @@ TEST_F(merge, anon_and_page_offset_misma
>  	ASSERT_NE(ptr, MAP_FAILED);
>
>  	/*
> -	 * Map another separately, and fault in, at page offset 5:
> +	 * Map another separately and trigger a CoW fault, at page offset 5:
>  	 *
>  	 * |-----------|           |---------|
>  	 * | unfaulted |           | faulted |
> _
>

LGTM thanks very much! :)

--
Cheers, Lorenzo

