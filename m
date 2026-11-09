Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7711606A335
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 17:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OXe4ayyk
Received: by kanga.kvack.org (Postfix)
	id EC9086B05B4; Mon,  9 Nov 2026 12:01:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E52676B05B5; Mon,  9 Nov 2026 12:01:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1A666B05B7; Mon,  9 Nov 2026 12:01:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A14AA6B05B4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:01:39 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7815E8070E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:01:37 +0000 (UTC)
X-FDA: 85416197034.14.665B7B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id AB54980003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:01:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OXe4ayyk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794243694;
	b=pDaZAL/F0PK5w9nsMfxVoNBp3kd3+UIPVbQ1dxrAMYkKyY8zmRR+BDAoqwg8fE4ept2PYK
	xgcPPgihhmd6iO4tzLZZO118YfdPM+JRqTg0cMXGUnoMO4zS8lYRdZ/bLp2bfx6Dt2Zd7z
	/+ps7daw3klGQVE87+yThKdCIPNba4g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794243694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJJA/oulexA9Wi8BzNg299HmiKK85/J/7UwO2YuuFAE=;
	b=DUm7qTwJCKYFGi1epk/JpvICGOW0r7L9ZPMw2Kx1+wMhQPdmcv28bfmaw2AND4RmNdoQgl
	qDtmXhK9bgz6J1RmSnAWyl8T9CZZyq7iHDIfgper6jdBmqX7N8rfI7RpWe0TyP9P9oHmX/
	d4jQY6+LhAwlb7J3r8dfM9IU4AgoPC4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OXe4ayyk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE79961918;
	Mon,  9 Nov 2026 17:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE241F008A1;
	Mon,  9 Nov 2026 17:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243693;
	bh=IJJA/oulexA9Wi8BzNg299HmiKK85/J/7UwO2YuuFAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OXe4ayykX8PUhC/4mrNJvncbfHA3iL/5BrhRULUfvCb//HukvqL4y9L8+ZI2+vW9+
	 doj8jdAoDBms4Y/TX9s9GeRGv6bI1Ltpt/Lu8J5o8F0yXtKHYH960N4EPGuHQUuiS/
	 B22zxkwtnpfjOTfPuxCsPIbzylf0Elc7CEBHgMSoo+UQXgyzRCL+P50xk8E142A+WV
	 j64x0q5W0uSDp/Hk2Xq4WbWA/NCM/42wyA2jcpJB/sy6XhQedT2XBt20lZtmVJqQ2t
	 K4ASDB/NlEAdIJVJoGnNwe0XMIyt/1Qbr/6ykjLENJ/RenFPKeiz7rH3eSvw6S5CQS
	 hlY+XwYPl3T9g==
Date: Mon, 9 Nov 2026 17:01:17 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, SJ Park <sj@kernel.org>, 
	Rakie Kim <rakie.kim@sk.com>, David Rientjes <rientjes@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	John Johansen <john.johansen@canonical.com>, Georgia Garcia <georgia.garcia@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, damon@lists.linux.dev, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH 07/13] mm/madvise: convert madvise_vma_behavior() to use
 vma_flags_t
Message-ID: <avH8PeBwpa2K5vK6@gremlin>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
 <20261105-late-2026-vma-flags-v1-7-0d3cd15ab75f@kernel.org>
 <65038fdc-f4a1-461d-b7b9-669885f15c3c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65038fdc-f4a1-461d-b7b9-669885f15c3c@kernel.org>
X-Rspamd-Queue-Id: AB54980003
X-Rspamd-Server: rspam12
X-Stat-Signature: wdcotjnkczsrdt536jgwn8b5ohgfrq43
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794243694-896229
X-HE-Meta: U2FsdGVkX1+RGuMcRWgtS5TDehWzOcBpBx5X/q0pssacjEhMXpBAUIr+2L5lUh8nPb3L+4RRVqdBRvxrvgv7OabWdsk4mjgvDMPPtxJxxk70xEo/UHw3TYdoZqJo/qY71kGMpuls2RtdCgmTV5pOWf9XZjha+yGLcPF9OVvVS9+UWMnYhJ2JYbIpXL+2ktxKMsH0T+/VUvAIGye4sJfw5bON6/jA4yGAGAzLTDhCjDR2s/qZ5FXmijgxgm68xYq/0s6sW+Z38ziGP1IekyJeipm5kkOOcUn4gJ7sERwZPjTVPxG98yfdoy2t/ZlLrRFX6uy4rAUSQHDVmd28EumV1kGK/SUFASAAnZJvAv5Y7PYuM09vB4bjQ+YFtxpcqYap7Ip3uP1/k/NSvzNJfOUrNhMUgGLR5pusUlFmN2eI13/BUMRi3MT67JOKxuUKzRAvZfsBTjfsPLXG/r17KMADB9U1qnbxwFdUnR755tmYuILbQN5SZDkjtdjARAj0eYhdAGDV1TXJ6Ju49EGuaqpvuKCDfQbohZH0jd6K+ePUk7ON26/1Dw2Rhfk0tO3U2//jci8XvDZP35nIkSc4ob+2pRwVippMCEdS2iLpGMqfB0o2xZt9InSsOLJ6adgQk2oVM3Bbuy4U7+AmAl6j71B4gdPXnxbhcKVyS5HFhXVkMywf0t68pHLQGz9B7CsaOMvEfYSE7J7t08a2m3bkL1pjDvxeXybM8+59b3CDlHuxD+0XQ3ncBA3DVhnT7Cg/uPWkopV/XTx5FIt1iqriaE5s2aFB9/dkZxp51T83UjU3BsGjyTuqc3ujVCAeOFxxSShE71FRpSiK5LHMisK14Q64tyzgcKsrSc5gBs1hArmwGCzkBpIOKXDJ6o+92njiBhsEacuVPWbQw/MFUJzA4rCJJAt/R74SHT/lQpSKD3SkEMlcKOwb3TB/q63bIP5QWxtMu4ShRqhR11WHnSiHqL4
 I6Zsu80v
 6YCzTxrARZyIFouKFKhP6+YsdVwE9BiRZIbZlOMcHeFsJaERg2YhLNqhdaiABKe69Gy316dEp5DzI+FcIFj0KPXtbrUkcBaCv3QRR4J/ZZhmSoWHmUlXklxlUisD1wYB7s1CJn0GV8evNdI8U5IsXutyw4dLiNqeSrfyKsZjeUMeHuLT3Sg3AGOrR95l+GJMmHdPP9IWShsaznIBss+Y/iy8OX/4JiEfl/pC+irhH7ZvGFK1zjaQbF7ufeE+2MlMmi8fivguIQLX2V7mF0eUbdX+pQ6rIdiO2mcJ7SiwmWUXoXVNnqD1DnqDg2Gdj1ubbhzeCds7/iwGM23jkOtq3c+rLpH17j+A2aTB8TcUmP5WEUMW99rBGBrTrrVW76C86jjWhTz669KsWhHgoEpB0g4toJ4/APxkulTng1p1bEZL57tIxt4xMjStKm4weUIkgwIskwtBsUAhUkHuHQoQ0170OglbHGbxeVO5RbqsjXvTP+O8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 03:10:12PM +0100, David Hildenbrand (Arm) wrote:
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -779,7 +779,8 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
> >  	if (ksm_test_exit(mm))
> >  		return NULL;
> >  	vma = vma_lookup(mm, addr);
> > -	if (!vma || !vma_test(vma, VMA_MERGEABLE_BIT) || !vma_has_anon_rmap(vma))
> > +	if (!vma || !vma_test(vma, VMA_MERGEABLE_BIT) ||
> > +	    !vma_has_anon_rmap(vma))
>
> This change should be dropped form this patch IIUC.
>
> It would have to go into the previous one (that I applied) but it's not actually
> required.
>
> Unless I am missing something :)

Yup I'm not bothered by whitespace-only changes :P Feel free to drop this bit!

--
Cheers, Lorenzo

