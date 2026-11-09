Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 541A0606A323
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 13:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mq/IF6nA
Received: by kanga.kvack.org (Postfix)
	id 30AC56B05B3; Mon,  9 Nov 2026 08:32:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BA776B05B4; Mon,  9 Nov 2026 08:32:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AA906B05B5; Mon,  9 Nov 2026 08:32:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E39F66B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:32:20 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 73927806B8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:32:20 +0000 (UTC)
X-FDA: 85415669640.22.3E70C76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A685040006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:32:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mq/IF6nA";
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794231138;
	b=2Wobu01n3y/toh+40LaSe2GxoT4Ryj+ogVpRJDNIwohnBO+FfcgFWpeaMxqSEG7HCFceXQ
	2hBhuK9AYukRJDdfo+xRLftytNOB3lYXnobdDoaJkjc3nyw/DamdOcxiFVcq+c3QLA8iJM
	m4uopyRyu8Bxi87dAhL4FBB/uLM7fyI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mq/IF6nA";
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794231138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iEcip7tPdDxBNKjDoqV1dnIj6BkMr6G9KqwvTKyQBlY=;
	b=TJufspXqMK6cr1JteCo+mSC08Kr+lE4oIIdGd0dzLC2X3utPej59fyyws1Iby9RtGPJU08
	RHgltrW6asAb8jJTDazuH412J4w6JM5mz4OsiaCrkagUNi3FgQWmDQPR6nbR5peQkY9mg2
	G+1cDcycG9n73RjSAf4xOwWCs6bVi0g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FAD54173F;
	Mon,  9 Nov 2026 13:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE501F008A1;
	Mon,  9 Nov 2026 13:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794231137;
	bh=iEcip7tPdDxBNKjDoqV1dnIj6BkMr6G9KqwvTKyQBlY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Mq/IF6nAMfmH60nLPc54eDBG30/vFlV8Nc7Dg4Qdvt7otaTrZadQW+QyVbbqiu8gY
	 4wjvjbmFJe+KDJBHvPARyW3uVLXiix0Voc6pD380sc/TmGQR5tS8AC9B38beKlP/8e
	 PQZ0OYnhYWGq55QhIxMvUrgcxbFkd0ZgwHoskTOXv5H640Dc2YEhrpmGX3a2SahkiK
	 AhcKF6Ohn3DW5vnYoz7WjPduA9doZ/6OPl7rEKgwB+xIKz4DGTBJFBL0wGwe8D6ANH
	 Qb4+q0i1Vi/h/SL2PgYtGHx57LE3bgVc37ngC0JaZNjvsDC5VMDtJUmD9dxhJvp3mQ
	 mSjPAtwc28pfw==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, 
 SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
 David Rientjes <rientjes@google.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
 Roberto Sassu <roberto.sassu@huawei.com>, 
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, damon@lists.linux.dev, 
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org
In-Reply-To: <20261105-late-2026-vma-flags-v1-3-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-3-0d3cd15ab75f@kernel.org>
Subject: Re: [PATCH 03/13] mm/rmap: convert remaining VMA flag tests to use
 vma_flags_t
Message-Id: <179423111633.12539.3540482164681335432.b4-ty@b4>
Date: Mon, 09 Nov 2026 14:31:56 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: xmbpprjg87ipg3k9xrugmminr34z5zny
X-Rspamd-Queue-Id: A685040006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794231138-410081
X-HE-Meta: U2FsdGVkX1+g1rL0YOcCWt7E8O9gIQ2cayhvMa3/pXX6TyyygD9qi7E5WkKk9HP85YPUGcR/YFqyhllIXxADAyGhxyH+evmqO76fLveQNrEpzPWEtcYjpowXXBFHeqrCzJYPOyEiPfeK1Y8LRnvg8gvbPY64hP8bx81u0vraGUaNCQrYnwrp5yDzt2VV/TfrR2al24Oc+JLnXPoDQFxGVFr9cDr8U4LHffByFKndlt6JcYYXXRfEYKVEGAxZ4APYxDpxec83I9eFbFdlKuCEp+RDiNAHIET8t8osbNu84B46d+x2XH8jPUospp3EdT4U3vEM4UYhoaHRgdZOztWI8J9p6jHz+ajWGUtreMQ2NEOKLcbfcLRwL57irSKZ55k77Pkk75g7c6NJO4dtxm/nmwiy/ccUJZqAkNKNoQ1ueGvbaYBqtTJM8PMbtePgQfu+toJF/4k7Nn4V7CeXw0bJiP3+rQf8UhZqynFwC/zAAsxbx7eaY63JxEHq8pcxHnc6wrNc31b0MZbnRSHrIlSPTlyragQIMuBKWD8nwwMHJOaQtkoWlvQz0QXLYPft3zgo70ZOjq6AZboc+2pyHMBl5kAliyFkij9bId5RS7tOhK0nSW/sPyfAfBbArW/Kg78CMkn1uefP202Pp/i9fOhZW96c4U932dERb8VyvvQ9VSUtrpQBXzFtIhdFPyUwBPmVtkr+xlNUdIDZ/CMcSLYXtox2mswf6w5kQFFF5IQhWviOv+Z9ZjPK0tFDG+UZ3iICcq4RTZFf7MWmHXN+3q5cu2iOycgz1ktN2gXoW9zBjBKFCzq5yGoGDCEjW26HmPgIyfReJWbDCUZeDGakJcZjFq8y3F6CaFXC+2ySpIThINKeuTi/mfvBmW5CTGkPKC9JoKwEYMe+Oy9lw6fq4zxNkcX05r15xw3E06pUkSt4wlU7KAOURXEd9OZmmHmVBUFHP1ZgQKgNHByryK+9pNc
 v0P3+QnT
 WSH+QCr4+CInMqqM93p8j2R1T9WIS8qYlZ5JuX3Gds0MPvBmBizlZobq64Ce1i4HKliS0kC6CJzNroyB5hZ/vEUq8H2pa6gkRCEDkM1BuJDAIsmcawEg02p12DiOHv7JuN/5GuePDFH8WAouDkWc3kWfYPxyrx66CP01obO45U/3dmuIGXaf2Us0rfBJWU8vUX3z4opVjo4NccK0dOdrw8IU9aUdFJrxGk/mr27/gmDMq6go3bCUlJZcZpMDZGn+QVtJqTIjgmpWrJ1DlhpsAl0LJmWyzvs42PsfOE6UB+qwU3MFgQMFTceJPhsfdTBqt+AzJjhgXsL37Gsyi1AnrQkL48RpIoo2ctdJgeUIzSPJ4YwE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 21:30:54 +0000, Lorenzo Stoakes (ARM) wrote:
> Replace the remaining uses of the legacy vm_flags_t flags in the rmap logic
> with vma_flags_t values.
> 
> No functional change intended.

Applied, thanks!

tree: mm/core.git
branch: rmap-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[03/13] mm/rmap: convert remaining VMA flag tests to use vma_flags_t
        https://git.kernel.org/mm/core/c/1c78523f

-- 
Cheers,

David


