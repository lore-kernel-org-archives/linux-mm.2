Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 497E360A2607
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 16:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QsW9leLb
Received: by kanga.kvack.org (Postfix)
	id 450726B06B0; Thu, 19 Nov 2026 11:44:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4284D6B06B1; Thu, 19 Nov 2026 11:44:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 364346B06B2; Thu, 19 Nov 2026 11:44:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08B986B06B0
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:44:09 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5CA93160B71
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:44:09 +0000 (UTC)
X-FDA: 85452441018.09.4DE0CC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id AE032100006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:44:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QsW9leLb;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795106647;
	b=KMgM+1Jc+E0fzPOpv1n892NABraRXjkmi337Fiteh/MirHxc4GG3Nmv3DfH5UckzwwA8h0
	TmaKyEEmsAlaEEKa0WFFEq6HwB3jd2nPdSFy2/liywtYa6D86jHCKbhi9nE/rH1+zSzL/7
	9rjwmJbjEHvl02J8SXA+kLzeJ8Nwg24=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795106647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xWoQbusH/Y8VjnnYyYVr0K3Xy3KNrjFcQdKBH99Yds=;
	b=7ztCK7EOn4+3zoe69aafWOrejoi2UaksMqD3n7j+2TFvE7aRIFFweMQBuV2yAZjt52s1KE
	/us+j6Lyuw8zVhCcuI9dUPoxW4tXfv0yn2apiMQTMphu6iTLp8dJbwFAoza2tl2016D1+m
	J/c8a4lbZOtUIbDsi/0uqS5FHJ1zi68=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QsW9leLb;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C1686128E;
	Thu, 19 Nov 2026 16:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF201F000C5;
	Thu, 19 Nov 2026 16:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795106646;
	bh=7xWoQbusH/Y8VjnnYyYVr0K3Xy3KNrjFcQdKBH99Yds=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=QsW9leLbkV8LZAS329LVHxGUpItBJP0N7LvKGT4sjgKn3hsERkmCmqmPw2ygtdiml
	 Vc4Zh14sCdqnThkaeyA6qe0pTyCvSFYZHewnhMSet6OgR22sXW5ijY97aPVibyrTGH
	 +I2w4gZvpicpV8n3LOer+JiUaVzXiD+dozmZ82l9rsO9LYyjkDIxAKHOGB8EQBkUqI
	 vb3rM7mym9bgs8DxkV07ZblLMnflwn99V4cv/BFl+DcKgLD01AyspKKwZP+ceaqHtN
	 Ubqx8ZlAoZhptgjBc9LFE0zC3liRqK1fUsV0LgzYBGD4qq6PluFntuDfd3r5/5o8/h
	 eXWTEfFDXLi3A==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 Alexei Starovoitov <ast@kernel.org>, Song Liu <songliubraving@fb.com>, 
 Yonghong Song <yhs@fb.com>, Ingo Molnar <mingo@kernel.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, Sashiko <sashiko-bot@kernel.org>, 
 stable@vger.kernel.org
In-Reply-To: <20261119-mm_failed_fork-v1-1-b3019f43d197@kernel.org>
References: <20261119-mm_failed_fork-v1-1-b3019f43d197@kernel.org>
Subject: Re: [PATCH] fork: clear p->mm when copy_process() fails
Message-Id: <179510663721.2987.3052403624854778254.b4-ty@b4>
Date: Thu, 19 Nov 2026 17:43:57 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User:
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AE032100006
X-Stat-Signature: 89jhytec188iegj5jru5gfoend1rubp3
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795106647-636922
X-HE-Meta: U2FsdGVkX1+xB3bj9BdPVrAJcrxjivTM8lzydN/dnFWKdVKyNMREVGJiMfifeVT18OE7d5FCjKfB5l3WHKnOTGDexzJDPVe3NA+LLvK2M7e7y6Hl2b+eE6AvNoHKegenYBurl2TNB+RJ9CM33ZFpHlU6kFglvpGv6CUh+hHJfmyl8ffaJ1YwTr6HYkHMAnbxZRsmgKNGNkyYSIS+bvk6Yq0H+Ko6CYooZuaKL3eCXTKLcfmSdPyyQQizNN3zXDpQepLkGlD25hIbXeyyQwFqZ2gyHnQhyULo7yr9+7NyEYQYx6MxSlTJzaNr/PPA58OE+knPmq1Q3ze0HEba8E25+vVWbRjJ8H/hrAIx+1E4sxn8VGrS03XvnVWsFev5mqLxB/To6vWfm1GPG+xebry0Ns/JmuzDsq8eQiRp0Z0vMQ06sk3ybtxQFBv6XBc27iiENIYlrhCe4agYIVwNPJ2KtzFfXsC8L2yQPDxdPXQP6EY2vwKblGk7T5uRmqie2GOOJO7YXBiTCPjlkyFZKMwrND5C4FAGR+G6HfHqaRsAVGr9jgSNR86D9u2/8K6ImBoFRx6ULV4c3j5DnEwBX/3GlYI9RmXuF+7WC9XXJyuYHLXwd+vARXJWJiOhrvwrL9YWKvb3om4VqE8w82S1/0GTRkjBd9jyidbGb7xuK776Hg4Bb4pIWidpdWSgx/vEE4fS2leljGFksBv8/DwChB/pIYeGclkreertpwQ+pREHNftCf5hKfjQSc/6lAk9lScNsVIs6gqPBbGaGVU0F590uFCbF4RrVJFKvAr/DCzfmOwkwUH4zBQVCwfLgAf61+d57j2M/CM2qwH06JMQ0jE+zC8i7hxyDZcC/FFRZYfehLscO78O19jUEHkV9lCa73CCMtQS0JShjGNrKjV/jrfHj6+EhndCyBlny26VxhiZZ1EhAhCHYEJcDcEWWP1aqsysBwJiCQXfPLxeMSJ0V0g3
 /pjVNe01
 TIA0qVI2KEP1lRqJzPaDEXUT4iFPBTeh6+tXY0F48E58AYefkZPezBoe5BagSWYvzZt46mBbqBjDjw8G2zZBbZwyaqPFfjlhRQ8gaFPwewjKSE/sMoid6eQGLC6U9pVyUC7+eD2FloCVVtRZqUbZdmmXWwTuEUSgsrHdI1s83HgDqFEx7sqPOezya1uzwH0NzlL1xMZaQ9khkF5IKTOYaTH8tSONzdx5Z2FtvqhMfIWeIrwLR7D5c94hrMGy13BgXntfgT6PiY8UFTmxnJ+wjQMeL32J8GOLObrH7tWBf9r6Pry2r0edVvbXRLsSyuLvW2CQy2XA9WZ3bgoK0Sm0GkNM1VYRo4IMlBu6/vYjgmT6GS/xqrcFSZxbRAdIKpEMhRSB95sp0dAd6P/8oB7zfDarAj6h0myiBX+XiUEfeLakRdueLiqtI3G4S6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 19 Nov 2026 09:04:58 +0100, David Hildenbrand (Arm) wrote:
> When copy_process() fails after copy_mm(), the error path drops the mm
> reference but leaves p->mm set. Perf and BPF can still reach the
> task, and take a reference on the already freed mm through get_task_mm()
> or bpf_find_vma(), resulting in a use-after-free:
> 
>     copy_process()               PERF_EVENT_IOC_SET_FILTER
>     ==============               =========================
>     perf_event_init_task(p)
>     copy_mm(p)
>     a later step fails
>     mmput(p->mm)
>       /* frees the mm */
>                                  perf_event_addr_filters_apply()
>                                    get_task_mm(p)
>                                      /* use-after-free */
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] fork: clear p->mm when copy_process() fails
      https://git.kernel.org/mm/core/c/c9b8c9bd

-- 
Cheers,

David


