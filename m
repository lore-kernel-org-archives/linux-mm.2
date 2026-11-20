Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4985960A2616
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IZ4SaAZ3
Received: by kanga.kvack.org (Postfix)
	id 5C0C46B05B0; Fri, 20 Nov 2026 13:35:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 570C06B05B1; Fri, 20 Nov 2026 13:35:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4603C6B05B2; Fri, 20 Nov 2026 13:35:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 109C56B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:35:19 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E6C4A0142
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:35:18 +0000 (UTC)
X-FDA: 85456349916.27.6A1A01B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E6AE2C0003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:35:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IZ4SaAZ3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795199717;
	b=0GqPbDK7FrqqZ6A+mmkoVF0cmvikPeixAf/UoE4+RJmZV83JNRZP30uviU3fFe9cILA/Zr
	W2WoeMS7JXadpyeUbgKiOQ2nssEXC8n9JnJzHRflfLb1ikwIY7GoGI42TldfnURhBT+VNJ
	FBrGGn8StULbGU+JiQr3R5yaFPojyj8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795199717;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bIIG4zl8TPynaHSoT/O3ZoKJ4B6crfr5G2QFKKsC6Lk=;
	b=cJbUoEbSAiLnc07CSK1RtAqr/fsBjuVLRrn0yeEfJy6CCm/IrP8txOYXVClugm4DmjRRo/
	lntHdIq0BTascmbzOi3DpEvwBX1Kqem7RaM0x6Lf/hPxOu/o9Ql0ZW4TuU2rjENZYiAWU1
	rvQwLtI3aaJuf+22UH2d/mlByL+ITSU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IZ4SaAZ3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D044246241;
	Fri, 20 Nov 2026 18:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA14E1F000C4;
	Fri, 20 Nov 2026 18:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795199715;
	bh=bIIG4zl8TPynaHSoT/O3ZoKJ4B6crfr5G2QFKKsC6Lk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IZ4SaAZ3xCf9fmTzel7z2Tk9TIFRfoUGZSYfC98iVbTeiiyblv4aoaef4r+xwtRVO
	 hr8lvDMwLdArT5DPO89KcmvYqzd2RAC0i9MxQYF5nrlX2LgRoPgNs8u7Nqm1LK6S+N
	 1akWRflhMNPGcsxRoSBIJCmgk3+OdoOiVcFQMQlR7tzbD2g00JM81GXtoqVrGt9ThA
	 u/UsasALhuwwYALzSlsje+JOrdGzsRW2mHN1ySOdF7Fo8zfmEmHHZELgU4a70worZk
	 Bk9O4BUe3w8OQZuX+ARs60ZjwbBHLFG6PuGDW9cPWEfvy3X7ICNYeaotlqi78nr5/a
	 VOI5jPwkAyOYA==
Message-ID: <sashiko-outbox-225846@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 59/60] selftests/dax: test cpuset interaction with
 private nodes
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?R3JlZ29yeSBQcmljZSAoTWV0YSk=?= <gourry@gourry.net>, "Yury
 Norov" <yury.norov@gmail.com>, "Rasmus Villemoes" <linux@rasmusvillemoes.dk>, "David
 Hildenbrand" <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Oscar
 Salvador" <osalvador@suse.de>, "Johannes Weiner" <hannes@cmpxchg.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Danilo Krummrich" <dakr@kernel.org>, "Johan
 Hovold" <johan@kernel.org>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie
 Kim" <rakie.kim@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Matthew
 Brost" <matthew.brost@intel.com>, "Byungchul Park" <byungchul@sk.com>, "Alistair
 Popple" <apopple@nvidia.com>, "SJ Park" <sj@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Ben Segall" <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, "Valentin Schneider" <vschneid@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, "Kees Cook" <kees@kernel.org>, "Kairui
 Song" <kasong@tencent.com>, "Barry Song" <baohua@kernel.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Michal Hocko" <mhocko@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "Pavel Machek" <pavel@kernel.org>, "Len
 Brown" <lenb@kernel.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Xu Xin" <xu.xin@linux.dev>, "Chengming
 Zhou" <chengming.zhou@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Pedro
 Falcato" <pfalcato@suse.de>, "Jann Horn" <jannh@google.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Youngjun
 Park" <youngjun.park@lge.com>, =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNs?=
 =?utf-8?b?ZSk=?= <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Waiman
 Long" <longman@redhat.com>, "Ridong Chen" <ridong.chen@linux.dev>, "Tejun
 Heo" <tj@kernel.org>, =?utf-8?b?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>, "Dan
 Williams" <djbw@kernel.org>, "Vishal Verma" <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, "Alison Schofield" <alison.schofield@intel.com>, "Shuah
 Khan" <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, damon@lists.linux.dev, nvdimm@lists.linux.dev
In-Reply-To: <20261120-private_nodes_v6-v1-59-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-59-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 18:35:11 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E6AE2C0003
X-Stat-Signature: bjrp79grugsip649erh3c5h1jg6sfze7
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795199716-207802
X-HE-Meta: U2FsdGVkX18wL1tF0E0KmXmOzDCpMn+eHbTBDG/lFTvlzrjBRq3edH1I+xK1nJY2C22OLI+D5SR8NLB/RJZBDhCGC7ILo4O49xsAfUAmtiZnuV2xX9z3fu1dL1L+2sct+t/T1y2gSOKg57TFKlotkJXFJV5a1nNJH6imvbTbu/jo948lvy4o+j9aOUJYCNdn9C/L4GsGchFOoDwF7JQD+4LcLqr7RqAxD4zRsnUlkpP+fuI0zqd0NNDN918e2Q5MN9B2dXIP+ONlzepjv++xL0Lv7hVJ2v0p4F/XvVxNpgErqag2HRkcZzqHf714kAmd6A7MXfn+1Jb2gbknuwE52h/glPDnqrxjILQxwlgZ04xV+XALVlRtaQrBWefK37RNWxDbEElkMk9Pah8nwVQ/yOygU8iLQWCvFjNwa3oyN9FirKu52sWoHG3wZEkfE61ITi/K6RwvimcqA4uk4XhmtQ1VMYjKj1mee+0o5ZQstulfXZitAvHkg1uuQavlTEdyB6Shk6Ra5SqP2r+MiORDmP9QUXXAwnhPcikDlH2FEoBNfNtrqxvYbholE4Ya8TM2POt8uVWHJMTl8dNfng/ESMLeq67+Qd/p1EgScQgWo6jFxGsDe6/Fs5oqfEg5mY3TfCYB+lMjZdcV/bjf0W/pGY12nAFsjVBu2apwcnh0TiyM6RvntznKv0/s9Guu8JOcOKOtAln035o/RW/nuOnvQZXfLieJTOqtzlHvFLf5hrpbyfocO7UWug3KLDbwp8GwOPxcz00su6ip2RflO50jfZP77sN32NK970YLBrEC9yD8YuGK8zzVCohiqrv+pMr/EZk4p69fPq8f+pvZaXVkCeCxSHTZCgs+hOleSvTdWmAD8ZNxILEQp+ebADLTxNxVG+va7KNWEaOHyS+P0jzMaCUPon7Ql2XqlLFSwvZvhEzHhE1PSS5fHkR/0GTZ5dOHXynB5S9UFSXJ1N06fI+
 SrcqSAAU
 mK4u/BOKVua5QbCq4kkMb8L4N/HdW/jeXnNbUyjz5MhDzcxjAL0Qvl/gOyrxgsz34DY0XFgqU7ADXLLrNqbNoykSLxp3E0fAnu5PRXDywb766yP9NeYZ4qz4Xdaa/Lpuipb8Efq5vxQJzdQjHVbWECtf/BqFiOuwJCDxyUGrWW4KDTAuPWWes9WNtp70a61ulId5DlOe9ORoCT+sHr8B9T0/WhjUPJm7Svb1OiQGOGPI6PSgK+FrqOX6LdZ+no9B1Sp1Ugi7PJJBpmVZVuojD0MsyL9Qyg4V7gseYflqXbZBDQKFsw+dfBHco6GhXNv14moBURdNd5Fs/MI0BYaeFRJu3OzX7+xcgsk7A1QpyexA+6wKQKl+WPtM+Gs1bg1kyPOCQFGRD1aw7ze5CudcB9GnjM5czfj8VkBUrs2JttnrjkzRXqEQShGplsPZM0eIZ/9H/QjZyYNYKOJb5xHEM57RFP5pRaXhBfKnWh5fuGM5ZAZ9npDZK/ue4VLvNg8bSbOLiadauUZw13kY+O7q3QHH5NQXlPxSyQoHNWAFpphHzm6sjbuO8qJCG3nfgwKRj6fIUt/tH4qqcI2Q0/uJSWB8wlcQxJ6TUvI4JVBabufCirPyky2KLVMUbK32Y6J5uR80MPsWMgHHyjFDKwA4WvUZ7cDNHWdm/LQUhC5/JZkzWl1quVrNOnj+m1YdoDxLfqhZS+Sfyjb45xonOOtkq5bb3mkYnD1OH6wg3Vv7EFseGOCHYfYfL8AaB/k8MOpBLkqn68+eHIvsatNrz8jNKifakHCFM9dHv71NXohEoF1YZha4QwqC1UQjhO5G8O+eL6fhjmkkuHHyq9mgxAD5AopBs7sZei0ZTwps/SeFrxhxjNPDfnw/SqYw5FHUm22sf2BujktpzBaoPqbToKZ87aCIEfZksP/0zQ2SI4lJDCIkYQX0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] selftests/dax: stage desync and wait hang in
  run_private_transitions()
--

commit 86268e0cbec65176c860c84e90fc221fb5d0e80c
Author: Gregory Price (Meta) <gourry@gourry.net>

selftests/dax: test cpuset interaction with private nodes

This commit adds selftests and a C helper tool to verify cgroup-v2 cpuset
interactions with private kmem nodes across cpuset.mems changes, task
attachment, and node hotplug/retyping.

> diff --git a/tools/testing/selftests/dax/kmem_private_rebind.sh b/tools/t=
esting/selftests/dax/kmem_private_rebind.sh
> new file mode 100755
> index 0000000000000..5d39be04f1795
> --- /dev/null
> +++ b/tools/testing/selftests/dax/kmem_private_rebind.sh
> @@ -0,0 +1,301 @@

[ ... ]

> +run_private_transitions()
> +{
> +	local mode=3D$1 label=3D$2 action=3D${3:-reshape}
> +	local stage mask title cg=3D
> +	local titles=3D("keeps private pages and placement while the node stays=
 allowed"
> +		"evacuates private pages and uses common placement when access is revo=
ked"
> +		"restores the original private request when access returns")
> +
> +	echo "${COMMON[0]},$PN" > "$CG/cpuset.mems"
> +	if [ "$action" =3D attach ]; then
> +		echo "${COMMON[1]},$PN" > "$CG/cpuset.mems"
> +	fi
> +	# Shared-policy parents and task-attachment tools start at the root.
> +	if [ "$mode" =3D private-anon ] && [ "$action" =3D reshape ]; then
> +		cg=3D$CG
> +	fi
> +	if ! start_tool "$mode" "$cg"; then
> +		ktap_print_msg "tool setup failed"
> +		for title in "${titles[@]}"; do
> +			ktap_test_fail "$label $title"
> +		done
> +		stop_tool
> +		return
> +	fi
> +	if [ "$mode" =3D private-shared ] && [ "$action" =3D reshape ]; then
> +		echo "$TARGET" > "$CG/cgroup.procs"
> +	fi
> +	for stage in 0 1 2; do
> +		mask=3D${COMMON[1]}
> +		[ "$stage" =3D 1 ] || mask+=3D",$PN"
> +		if ! transition_cpuset "$action" "$stage" "$mask"; then
> +			ktap_print_msg "cannot change the cpuset"
> +			ktap_test_fail "$label ${titles[$stage]}"
> +			continue
> +		fi
> +		report_stage "$stage" "$label ${titles[$stage]}"
> +	done
> +	wait "$CHILD"
> +	CHILD=3D
> +	TARGET=3D
> +}

[Severity: Low]
Does continuing on a transition_cpuset() failure desynchronize the stage
loop from kmem_private_rebind_tool and leave wait "$CHILD" blocked until
the 60-second timeout expires?

In private_rebind(), the helper tool loops for stage =3D 0, 1, 2 and blocks
in sigwait() for one SIGUSR1 per stage.  Skipping report_stage() with
continue omits sending SIGUSR1 for the failed stage, so subsequent
iterations wait for a stage number the tool has not reached yet, and after
the loop the tool remains blocked in sigwait() because it received fewer
than three signals.  Handling this like run_private_retype() by tracking
tool readiness and calling stop_tool at the end would avoid the hang.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-private_no=
des_v6-v1-0-74f5f9a115c2@gourry.net?part=3D59

