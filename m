Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A84606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 09:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=v+0qIXZ/
Received: by kanga.kvack.org (Postfix)
	id 7F1DE6B0682; Wed, 21 Oct 2026 05:06:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9816B0684; Wed, 21 Oct 2026 05:06:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E05D6B0685; Wed, 21 Oct 2026 05:06:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 354C76B0682
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:06:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D082C01F7
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:06:57 +0000 (UTC)
X-FDA: 85346053674.01.210A22A
Received: from mta0.migadu.com (out-230.mta0.migadu.com [91.218.175.230])
	by imf23.hostedemail.com (Postfix) with ESMTP id 250D2140006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:06:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="v+0qIXZ/";
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.230 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792573615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uwQSFZ3FSogyaone7anL8mKsD0j7h3eCsLGxjb5kG8A=;
	b=i30hkNIT/KY7daXVNOzEDyZWjVCohIupNnUFuQAGOimUOIzSuixAP89FBKQ4/CKmsUX6Ax
	vWHS2+m0xjTh8f0g7TGO4f34zAcUAPGVj04GTvHLSZ/UEZMyY47wThZRyZzkILEcZieckb
	Pc4JGyKgRp+o60g+KhOHg7GpV+95Ix8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792573615;
	b=yZpPEdTb7OugoGzfwLo7dOEIbjc7/DbN+HNCsG+GP8Kol1WqGPA5uR+OEpy5+/gBc/ZbxY
	tPDfgPUm4qpeSG61UQdkFXQM80k6fkajGSsgaGrm9k50dF3QYJCzQeHt51W9twyCV+1/Ak
	ZN/0zmvfd76BMeYQyaxz/ssUT9qOWxU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="v+0qIXZ/";
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.230 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Po7qkO1SjHqn4Bxa+MKkPPqkGbMVv052HeJ8cSEw26c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792573613; v=1; x=1793178413;
 b=v+0qIXZ/fyvbcF5DEGvAHUQqdC8Vl7VnleFjNNvwB8O5CT5ZoXIXYrNJIy831Jz/dY05pH7l
 QgOs/T/9Y0sIOi05TSaiQ1zfjYdvLp3Yo4cjFeizd4mzNhRxuwox8qePnGLTSoh5xpkJJjDvRKC
 +KxplTTdY6JdWL+MCk/Jy3oM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 6eab166210853d46;
	Wed, 21 Oct 2026 09:06:52 +0000
X-Mizu-Trace-ID: 6eab166210853d46
X-Migadu-Flow: FLOW_OUT
Date: Wed, 21 Oct 2026 17:06:44 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
	Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <ryncsn@gmail.com>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <atiApNwSTKejgcor@fedora>
References: <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
 <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org>
 <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
 <CACePvbVbMPZTrD5y=--XgBS+sa4CHb7e4RFTYCbWfzHzVc3vXA@mail.gmail.com>
 <7e998cd5-57e0-432b-a8e0-676a5b773436@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7e998cd5-57e0-432b-a8e0-676a5b773436@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 250D2140006
X-Stat-Signature: er73zuq18h6b1wrhexymm8bcz4h7it38
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792573614-693463
X-HE-Meta: U2FsdGVkX19tVvuS+6i2D+ERq+vAJmdn2aU/atlNztoL9oHppttLAPisjRHJ/4GW5Si7FWgiZutEOzivsiXg9YB3sdE0aVrYMC+6+thnHFtqPmexwTAiaYwV87vzGAi1qjXd2Mkqdy1foMs1luNT5unT+4l9qyUrZM8r82RwFb0CgC4yOw8kaw+/NfAd/kbeCJWnQr62swttU0TG2+lnD6S2mzTMKCTgMCcT0dkOwHIsyxhjWZVoaSewVHiZQ9N3li8KyCw4FfxPnUs89aHPh6OG1Rg2WvOLXj1QnL17v8Xx1AD4F+J1j0T4hFnrHjLMvUEAafnbLYbYu66XNUK2hPj3Mrvus7y3PSpXPRYAO0m3O+hC13ZKbl+FYrNo1aC76KOKXDQsSUYzDM1WeImgUnw0kw6PlK70xhrEFqzs9UE+P+y2+2wb1oS9wY5luvEWn/eQ6pqzNfVFOAulIidGRS11zO8SU+QHAX3O9upwgFUW+GKYpFRHQ6Aj3c/avDYllWW3BEiDTszpc8KM7v4s8FI2s6iQhYUHzLGI3mu8mIzmU3++aFojL6bCh60yEQAGfl9mXqKerZBz+2k4py5GLUdmcAGQvHPTIbmy+G8tJ1jWAJACtgmDV0lkD+RFtfma2UfR7HtGDDyrWyzw7Bv/ifGlIqM1krmMAOh9dJoe3jTubFa77JzSG7PPH+FRHNX+oh7C7aHB9+/EA1GQGH8u4V0Ztup5jXf+NFFJoddF3sLYSdF6TteaF+5c4rntFlzSIPvA+gUZw4kpf9Mdt0R/mCmI0D6G9IVtCAxwcHwGubshqxtD1fVExuhMcTxoA950+oG01PQoJxMntdFuw85BZoJcbhYunpIqng75IZ/Slmr6x4HdfRBVGusQEk9PQEg435CuirwhG2DmSmU/fpgNxJjVuLpVg70FIGT5ChTHRadSjhO1wneq7sh6xEC9Kf0edtscjey8hwKMKBKSwUc
 VgJdnXhN
 bv+GGzhOPI10EJJWF9Zy1XCHwXBXNZrejuZSi9bLUnMGr1hbnCoNh1fo5p2QVqmSL3IFz+RQHv0PEzXbRBjaqlhRsKD9sRhvIzALfL4HS653GOdXjseNFR/gayRtZTGX8X67JQGCA2r2L9APEA52RboME9kC3i4wDIckiOEuRYoYumgPn18HS+NC8LX66M6T4U+vGd8orA6kbM9/kBw8kYL93bHgzM4xXway8e+xTaaaOu4inHctuGsU4kO4/2x9wJs3gXtsXmmuMMp8YaZBxxLCHUYQ/O/mvxxetE2si/uh/F94XCJncK1d/tzeKQ8WCSZx84d2wlbNUyTIKRkesyq4AC+/B/T1mBUOVGJ7hVF4d12dlufC1YmOoiFkHpgZhVUC1V0KoG8IbS1zO7XJLlS+DBpVlH9HpBMSoav63vICqzIGFvPYh5H3FIE8e3vBv0Df9l1k4atOZAKG6LCZHNxVdEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/26 at 10:18am, David Hildenbrand (Arm) wrote:
> On 10/21/26 09:41, Chris Li wrote:
> > On Mon, Oct 19, 2026 at 5:35 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >>
> >> On Mon, Oct 19, 2026 at 5:28 AM David Hildenbrand (Arm)
> >> <david@kernel.org> wrote:
> >>>
> >>>
> >>> I'm traveling this week, so it's a bit tricky. I cannot make Thursday morning.
> >>>
> >>> On Thursday I'll be traveling back from Cambridge. But hang on.
> >>>
> >>> My plan lands on Oct 22, 11:10 PM. I should be home around Friday 1.30am - 2am.
> >>>
> >>> I could just naturally join that day.
> >>>
> >>> So one day later would work for me.
> >>
> >> Would that be too rushed for you? :)
> >>
> >> For everyone's convenience, this would be the time slot:
> >>
> >> PDT: Thu Oct 22, 5:00 PM
> > 
> > Works for me :-)
> > 
> >> EDT: Thu Oct 22, 8:00 PM
> >> Europe: Fri Oct 23, 2:00 AM
> > 
> > Ouch, David. If you commit to that, I understand it is very
> > challenging. Thank you for taking one for the team.
> > 
> >> China: Fri Oct 23, 8:00 AM
> > 
> > Other swap developers: Kairui, Baoquan, YoungJun and Barry, when you
> > have time, please comment on whether you can make the meeting as well.
> 
> I took the liberty to schedule the meeting and send out google calendar
> invitations to everyone on the CC list (to keep it simple on my end ;) ).

Thanks, David, I received the gmeet invite. I will join the meeting.

> 
> If anybody did not receive an invite but wants to join, please let me know.
> 
> If anybody received an invite and does not want to join, just ignore :)
> 
> -- 
> Cheers,
> 
> David

