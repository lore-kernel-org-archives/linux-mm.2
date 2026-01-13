Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1F4DD2F35E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 18:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638906B0093; Tue, 13 Jan 2026 13:52:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6066A6B0096; Tue, 13 Jan 2026 13:52:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DEA06B0098; Tue, 13 Jan 2026 13:52:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3AE196B0093
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:52:47 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DDF1E8A87B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:52:46 +0000 (UTC)
X-FDA: 84327837132.16.D614B4E
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf23.hostedemail.com (Postfix) with ESMTP id D0FA1140009
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:52:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=LgBmokvl;
	spf=pass (imf23.hostedemail.com: domain of "prvs=9473463a0e=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=9473463a0e=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768330365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rwGnK0XG1cMO3SiCMi3ybbWXWNI7uUNJrpNbOpDI9KA=;
	b=Mo4Vq9au7+a6r81WJsCWiAEfk83nuSOZi0eL5UZ1/UeMcjb+dlIuQBcMAlOk3ihjYJKFB8
	N5/8SwAQkO7kLQnY7IttmwnRRpGirJHK+ufDYWa74iQYSImXEUzYprKg4GYa/1R+QTNO30
	9s93MvF/XrPQbZPt/oWa7dQrEN5YHwA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=LgBmokvl;
	spf=pass (imf23.hostedemail.com: domain of "prvs=9473463a0e=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=9473463a0e=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768330365; a=rsa-sha256;
	cv=none;
	b=b+VVYSUz97AxL/9uzo+YbD37lM8adtCUXAlRzWpDNBOsHENWR+Dt0Mr9qlzcagrRRX54nR
	QVYB2OmmXXVt0WqL7KlnXt0sFhMhGH0U9u7VK3ZCFFyUYS0qbqr2lq3JuhIi8wtw37xT5q
	yx35cd3Dnik4tTuo2DPofhVgeYPFp4A=
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60DEN6j92410604;
	Tue, 13 Jan 2026 10:52:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=rwGnK0XG1cMO3SiCMi3ybbWXWNI7uUNJrpNbOpDI9KA=; b=LgBmokvlFzSD
	JbLJk9k2UhGnXkQ0PYNUN4/xnhQadwbQiPtX3bGJGssuI8U7AhzmP1+c8wXeH/R2
	BZnKgeDNB0Hmmydip/hXDpKK0wZ+taf8nLR/ahSYcVIXEhdTzyqlJuQFRv8epZnl
	LBcnevOLhJQcsJdRjnrq+cjzVZeg1eim/RWDRvguCs1DkG8UCTs/NWUi8o7BRtK7
	QYlYj9XfjEHVUxLu3BW1qw1X95/EVyxDe37eh/HJY+61z5lDhqVIG9dz9ErpvfAF
	Cj1HF1c/zJcKpOUPlVYvgsXsIjIQDgT5LvZ8E9HDgtAbIU7Cn0uahpsjIJgFIizq
	8LLBExl2Sw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4bnqs2afpg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 13 Jan 2026 10:52:00 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Tue, 13 Jan 2026 18:51:55 +0000
From: Chris Mason <clm@meta.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka
	<vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan
	<surenb@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Axel Rasmussen
	<axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu
	<weixugc@google.com>,
        Peter Xu <peterx@redhat.com>, Ingo Molnar
	<mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli
	<juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt
	<rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman
	<mgorman@suse.de>,
        Valentin Schneider <vschneid@redhat.com>, Kees Cook
	<kees@kernel.org>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe
	<jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Xu Xin
	<xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Jann Horn
	<jannh@google.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang
	<ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        "Pedro
 Falcato" <pfalcato@suse.de>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        "David
 Rientjes" <rientjes@google.com>,
        Rik van Riel <riel@surriel.com>, Harry Yoo
	<harry.yoo@oracle.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Kairui Song
	<kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He
	<bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
        Johannes Weiner
	<hannes@cmpxchg.org>,
        Qi Zheng <zhengqi.arch@bytedance.com>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
        Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor
	<alex.gaynor@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo
	<gary@garyguo.net>,
        Bjorn Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin
	<lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Alice Ryhl
	<aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
        Danilo Krummrich
	<dakr@kernel.org>, <rust-for-linux@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] mm: declare VMA flags by bit
Date: Tue, 13 Jan 2026 10:51:37 -0800
Message-ID: <20260113185142.254821-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <3a35e5a0bcfa00e84af24cbafc0653e74deda64a.1764064556.git.lorenzo.stoakes@oracle.com>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:208::7cb7]
X-Authority-Analysis: v=2.4 cv=HewZjyE8 c=1 sm=1 tr=0 ts=69669450 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=2wkDwbBoJs5KUjAQhisA:9
X-Proofpoint-ORIG-GUID: BS8X5kMHAv_lmQbWyESwWfjaYTVAoeoM
X-Proofpoint-GUID: BS8X5kMHAv_lmQbWyESwWfjaYTVAoeoM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDE1NyBTYWx0ZWRfX3M0NHs1kukO+
 c1d5VmTZ+cKzVKyCoJevB8QxR3unXWf5zPurMIxcyuLcr82OOTuasFBakmFJxUV6pamhFlFUUTh
 9CzQ2jQRm0lD7xjIUQIMLkEkb0QBsN4EsfOzy8guhq+TNKO+NtjdaASgx3JrH2EemdhOAWH743o
 zQPezwfPQ7Ut2lBt4f5mtIlc9ty1guUb/kopR0ke9tNXNRKqVpug6r5quhJOjB1xWwejsudNid5
 0U0aq2rA/WuKbCItGhtViZEoQvXxM8L/Uf9Q6lLbe8kcAk7QgzLQGPV/80NfbtA8dqhXkSF2r6v
 aw8k01O82636geuSjjF5WZa4RC9nHmbJzQLwfSQ1fcwgrX5negm0JDyy9oNQodlP+nv11/0mi3d
 ebMMAZNNygtXtURpxOtLjeP5D/1HUu9OPD7B53VoB0xOr49/QSd+Ij/DqsfAo5zfjdETdF/+f7I
 XP21uI1d3Kf7dKVxvRw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D0FA1140009
X-Stat-Signature: 7c98ozykanfa5a3bbsgraob3u1d7a9ad
X-HE-Tag: 1768330364-866731
X-HE-Meta: U2FsdGVkX1+jNa+Uugd4mvDXux+0jOUmuRauobDlh5+bSwBKQdITDdH6BqTKPovecZsbGGMrit8OgB5By2EYz86ryMXttDcUmzOnj4JAf5TyPPRRuqcN60mQ915MKuo5A+c83mSer2SCQxrzHgJ7wxltmFFRUKqd5HHC9vi5OpCG3OQKR0nQztFFy32TSjuM2eF6RmGPOwMvq8uVXua056WFvhTgFRLaiywOvuaWh+3W58bVm7l7mSnn1VTyoPKyyTvBIHLaa+bTYx6wFqoixQ6gaUAdxASQ4S/W9ZEGeJHJoGnfkwruLXL5H6kiBw9cEpUrJKjatPSItcmprtScae7hrypLGpK4NSwWK9dVRvdf9pVccn1+yr7XYjfnY4RXkQSdL9OY8GOfNULHfEjGosYLLFvK5kqL2H+Ng5Nz55xbWk9cOwaHT68mp5zwxiO9HjUN6yJst5mUJQQV+13ueG4yio0/nprGQV05K8kmoP6Sw7qXxKaDZ+U9pVruZHqbUu+p6GWIeypYVYBkghc7/2r4jmPU0d+okoVxznryzE0bxTvt88CIrn7oYXIcD8EqD8bF1KonRMCLnX4Gu0P5KyDmXB5rEBwr55UYV9Hw5Gd6XUiKHb/6tU+fxGHn6sTvDr7Q6LBhawj8YcQOMOrIJWGm9WrS3wgesiWNpGbTql4549gDPymY7XcA5+lPchdrEuHg3pICoJZ3ilMv4aAFqVDqYM+tYXG9UkUZlKDFyofVKFhqgoLHNXDlpQUYiTWG7BHsWZURbg+qoKKkbnlgWzdRzY17gLmhL2g+YSebUPIQTNm0p+xvjT37lPXf+9e2h/BEbAnmOYyqlzpTSys1fsrJT3JPyHwoAQO6AkcVWhOC1klX1BRIkizcD6RAmQG4k0gKcwUjYsVhL0pxp01P5Pmdlzgb1nx7IdT4h2APZbUZYmk7qn9tgng7DodawHCxWF6b0VGJ+eQ60agNW6C
 oQqaNn51
 8/ZvgZiLNg3a373hADzKCuXdcj3otX83uFofxWOUnfvji6rezLGIZDAqpvaXKsW+2TeoE96FaWqih07/Z8HasyR7kGGKeha1HC/Fq6zw/O+oeC6bnlmjzyZ/XFYE5ZPGhc4hAgANWN26JDvOJlgLPGE0UtzMvn6rIvcra7Ldc6fjPztlFPNMRLGU8Cy82KD/C07obFNeyQI1PtQks1O58eYHy3KPRYbNTXWUo+kx7HD+TAp800XRUTnsVi7u3ZZHgneuOmklzpyZ4dxoEFELAWYUz8y1tYTk1wopyPgS7Y7ZvqbtMt+Ogfzl3hRf9zfk36cDZrRUVOS/YjdLz6yqZnYGFp9DshtL0j9RI1owct5azE3d86Uq2IXafJM765KEFFJerv5W5g+w76GE+4UXQmR4NmGtsqjjwF6KiVVCKcIR98Q4HIpYs8QRjW+JII3ftPQf+M34pfaVx3G07yS+PXwApig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Nov 2025 10:00:59 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

[ ... ]
> 
> Finally, we update the rust binding helper as now it cannot auto-detect the
> flags at all.
> 

I did a run of all the MM commits from 6.18 to today's linus, and this one
had a copy/paste error.   I'd normally just send a patch for this, but in
terms of showing the review output:

> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
> index 2e43c66635a2c..4c327db01ca03 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -108,7 +108,32 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;

[ ... ]

> +const vm_flags_t RUST_CONST_HELPER_VM_MAYREAD = VM_MAYREAD;
> +const vm_flags_t RUST_CONST_HELPER_VM_MAYWRITE = VM_MAYWRITE;
> +const vm_flags_t RUST_CONST_HELPER_VM_MAYEXEC = VM_MAYEXEC;
> +const vm_flags_t RUST_CONST_HELPER_VM_MAYSHARE = VM_MAYEXEC;
                                                   ^^^^^^^^^^

Should this be VM_MAYSHARE instead of VM_MAYEXEC? This appears to be a
copy-paste error that would cause Rust code using VmFlags::MAYSHARE to
get bit 6 (VM_MAYEXEC) instead of bit 7 (VM_MAYSHARE).

The pattern of the preceding lines shows each constant should reference
its matching flag:

    RUST_CONST_HELPER_VM_MAYREAD  = VM_MAYREAD
    RUST_CONST_HELPER_VM_MAYWRITE = VM_MAYWRITE
    RUST_CONST_HELPER_VM_MAYEXEC  = VM_MAYEXEC
    RUST_CONST_HELPER_VM_MAYSHARE = VM_MAYSHARE  <- expected

> +const vm_flags_t RUST_CONST_HELPER_VM_PFNMAP = VM_PFNMAP;

[ ... ]



