Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63E50606A8BA
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GWlTI+fv
Received: by kanga.kvack.org (Postfix)
	id 6C3E26B05B3; Tue, 17 Nov 2026 07:59:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69B2D6B05B4; Tue, 17 Nov 2026 07:59:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8D66B05B5; Tue, 17 Nov 2026 07:59:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EACB6B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:59:00 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D18B2A03F9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:58:59 +0000 (UTC)
X-FDA: 85444615998.25.D82E82C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 47DD81A0008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:58:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GWlTI+fv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETzbJC1in5IC+3NOvYSae2SmX1J2Sy51B7KWOSdFkgY=;
	b=F9rKhIqFSCinzTCuDFAo0+BVDdc9GOB5fejeur/rAy5Fk9v3Ixk2PQzJrgNUkbKuLw7gQl
	eg51BlmXk/vYFK3RorLQyvI1LSy/9KR9cd/KZWvoWvTt8cuqFeb9WFeXu5LzEsqrdqCsLc
	MfykJr9tPZSDxHXHA2yb82Gp5RqHFq4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GWlTI+fv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920338;
	b=2twdsxGzQTkSGnJj8XqmkzY7BdRp3oYbLynbentkW1ATpdVU6O3T6yatk/w+kN3Mi4+AlQ
	ZCwAsogthzUxfRtMhFJ8SFUxdUrtZf0xOL8McuvUhhfYqd8NpLhSTWRyF14mJeEP5pph+/
	JK/CsFpL/S6xlgkymCOc2psbutC0YVs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C81716125F;
	Tue, 17 Nov 2026 12:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A998B1F000C4;
	Tue, 17 Nov 2026 12:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920337;
	bh=ETzbJC1in5IC+3NOvYSae2SmX1J2Sy51B7KWOSdFkgY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GWlTI+fvDTelDZPIAmzsRdV3Urdoqx0eju+4Y3GnlL89x+Gbtfvjm4dit4iRkqmaj
	 qmm1sGb7GTc18rJr9sUs+07VCIUml2jwFQ9p6mJcB0dXMUdWY74i5lOTlADLUJhu24
	 xmkwtHlinCcdKIavvtegVokXmj9ZakiZx60LuQLUEHPHEzo7OJqy/dGQF2sbrhim7Q
	 etzqv4qYcGHFsfVHa6sqh8iO1mGeh5fW8TUfyA+LTgnsDSwOfFItMyPInTiCEzFf6u
	 RE6253NkVC6SbL2f6qYZxxbk1lBofC+aIAubOPjNT5rREsyVSsevjk0Jr6VE8t6ajE
	 iFdcb6oZsO1bQ==
Date: Tue, 17 Nov 2026 12:58:48 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Muhammad Haris Awan <m.harisawan@icloud.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] fork: mark memcpy() in dup_mm() with data_race()
Message-ID: <avxJKzw9JLrSZTlR@gremlin>
References: <179489519663.1444496.15875846661591982934@icloud.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179489519663.1444496.15875846661591982934@icloud.com>
X-Rspamd-Queue-Id: 47DD81A0008
X-Stat-Signature: bseq57k3ngei7jyafoe913spjzkpipd3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794920338-767571
X-HE-Meta: U2FsdGVkX1/ODEnVH7KW8xpc9eAO4fJOeiNg896CkRIqEewi7OFtgwGX03H0g5AjiYwEVsOGSfLLq0h8suq/X3D+yS20Q2KiWbHJNlfZMQV5QMUdxt+KwJZd7NL91L9ZGncYyCwT7x5JHmxKbpcVu1OlBXmE121oXOn+CeUAee+2qQ1pjqsBs6XR/XtQuNXQ3Mq288PTvyJs41+2GvHCCxWyZXlDmAlKk7zXeTDueI1MwflAcCq1D3CP9iTxw+6a5MbZvizTxmksGKhmRDOr6YtByFmuQyCh42MN2Nk1+M9qlq5Mt0IACqtqZSnTup64ZLqGvuwvcRNsU4pDzmPpOG3hWRDt91w1xkB0HmjeHEAWD1HnOGTKBg5WNKofS1x0FHgESZdwVWiRpCUHPoldmyf3TRWgeatpwrbRvU9Arqx6N8p2anNweKzvFZ1c/G1lwohYb5cB24qjz6T7PgcWy93igUQTx05MHh7x3VbRSH3xc3ZCVyHxKxYIczF1j3Pf9xVkGzMUdbjy1b1RWMvVAxsgcVT1bnITXrcir/EofSnboK6Zh4iEMBHFfrumDrYQOukswnsFSEX6tfqk+d0pQuBh4nG7gpryznko1zkmHTZk8ihVPqd/34/cNPzHFuETJP3TGtMWFTM5hEk31yOLBIl95q/JvJb/NATb8y++bjLdO6C/GuJzK7IadAiSzRAFqG9G0eOrtdZ0ZEcoZWSVaamfhmgxq/jTe0FAS9M5WwFOtowypvoGm19WJiTWnmBGmHo6xaHqAEheAayBENBWTN5XA07IB8ZRoUikwDhO9aeszfP43X0kHFzTrGq1/O8XNVkLJlEmxVzSZtHs4XX22WMcMgkNQ7lHZaTYu6FGhAC4gyT4/dzEZstYxPokDe1uE0jaMa3ofXJFc/aqWibLgJ8IHUOfT9VVg6Gibb92onyCQB6jBpviV9n25yofljKzvoY9c0KvEsbjV1n0ymh
 j1j3Xetn
 IEVorSHQpmOOD2lOO6FqJ5shN0ZP2HCf2C5L3VswcPbka2XIk3kxNoTZ4SplL7OcbRjA/XioieBsaPQCKbGpbIIBtYt8+SxJ7U8fDeTNSWqNO4Y+F+eeJMs46m7fO3g37sjspPJpSLBJ8VNwHUovYbXwhV2ao4p4TX7ye1YRp2VBPZcfLZBFaH7+Uu4yuj3gAtpmHHVJ8Wz45WAid7KTokQ0N+BEqIV6Q7mLHimc0tUhLcTtAxLyCFuOmh6F7hGTTK+dXcgnnjkMQX3vB5rPclu0L30dI+RwwTQQoNNZlrpB8tBOF/dsLt9VjMdmjJEaczrW2W3/3FDnQ6hr68HiOTA4IIZh2guDCtR4E1r/poZQ4WGJKWT72ZhbT8oA20Oo9EzhnSHtOJo0n9IY+npG2q0EisL2iP2dTxfknVJqfYYFDF0F7cbI2tVWkKGa8pzZi7seoe1rEht6upksekex1BslrE53qmEP41bdyqyn9MG15oUw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 10:59:56AM +0500, Muhammad Haris Awan wrote:
> KCSAN reported a data race between dup_mm() copying oldmm via
> memcpy(mm, oldmm, sizeof(*mm)) and lru_gen_del_mm() modifying
> oldmm->lru_gen.list when an adjacent mm_struct on the shared
> mm_list->fifo is removed under mm_list->lock.
>
> oldmm->lru_gen and oldmm->mmlist are protected by mm_list->lock /
> mmlist_lock (or updated locklessly via lru_gen_use_mm()), not
> oldmm->mmap_lock. Because struct mm_struct uses __randomize_layout and

Firstly what on earth does __randomize_layout have to do with anything?

Secondly, ef694e2d2101 takes the oldmm mmap_lock so what you're saying here is
wrong.

The problem is that you end up manipulating a neighbouring mm in the list.

> mm_init() immediately reinitializes these fields on the new mm, wrap
> the memcpy() in data_race(), matching dup_vma() in mm/vma_init.c.
>
> Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> Reported-by: syzbot+c6e1b1b32ff2fc3b7d60@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c6e1b1b32ff2fc3b7d60
> Signed-off-by: Muhammad Haris Awan <m.harisawan@icloud.com>

Given you're a complete newcomer to mm I do have to ask if you used an LLM, you
should mention that somewhere in the commit message or at least below the '---'
by convention.

And it's vital that you understand everything you submit as per
https://docs.kernel.org/process/generated-content.html

So what work are you doing with regard to KCSAN, data races and mm lifetime that
led you to this? And what expertise are you coming to it with?

> ---
>  kernel/fork.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 5efceb8d5..14ac9a070 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1539,7 +1539,12 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
>  		goto fail_uprobe;
>  	}
>
> -	memcpy(mm, oldmm, sizeof(*mm));
> +	/*
> +	 * oldmm->lru_gen and oldmm->mmlist may be modified concurrently under
> +	 * mm_list->lock / mmlist_lock or locklessly via lru_gen_use_mm(),
> +	 * and mm_init() will immediately reinitialize them.
> +	 */

I really don't like this comment that is begging to bit rot.

> +	data_race(memcpy(mm, oldmm, sizeof(*mm)));

That's _really_ horrible.

That's now making it so any race that matters is ignored in a _super_ sensitive
part of mm, because MGLRU decided it was a special snowflake.

But I'm confused as to why in 4 years nobody reported a KCSAN issue with this?
Surely something increased the likelihood of this race?

In any case, this is MGLRU's fault. It's abusing the mm data structure and doing
something it shouldn't.

So any fix should be there. Similarly for other mmlist users.

Or really, given this seems to be a one-off, spurious, KCSAN report, do nothing
until it becomes clear this will be reported more than once in 4 years? :)

>
>  	if (!mm_init(mm, tsk)) {
>  		mmap_write_unlock(oldmm);
> --
> 2.56.0
>

--
Cheers, Lorenzo

