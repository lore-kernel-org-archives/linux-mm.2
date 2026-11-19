Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 045BD606A334
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 08:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=aWzX7qvR
Received: by kanga.kvack.org (Postfix)
	id 059BA6B05BA; Thu, 19 Nov 2026 03:29:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00ACC6B05BC; Thu, 19 Nov 2026 03:29:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3CC96B05C9; Thu, 19 Nov 2026 03:29:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A98226B05BA
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:29:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D74BFA8767
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:29:22 +0000 (UTC)
X-FDA: 85451194164.02.7089626
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id C499320004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:29:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=aWzX7qvR;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795076961;
	b=rEwnwPWhoLtCaxFMvf91xUz1Ar17/fDJxJZ+MokxD+DS5rgERYXt0v4hSzukNP3xcfryKn
	6bg44CjW5AWcmBAaDXePHGf/ugir1slNc/Tc2BHkD3R6sZBXODRnauLcoGF9SkbeWEkr7X
	+Rpfbd8a7EOWpL4xvopXd+EBjYkgo7k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795076961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5EhIH0GsNWo/xExkiXtvhKm+Q3j5FK0DSxcIP+QAZxE=;
	b=KkSsdL3/wHyRiWwH8ORSJL9rKuMySke2/Fkwk3vhTWY1Bna6nE6R51VOjnZgRS7L4qTS9q
	5PCkaU8Sog4dM6OzCapeDWdCehG5KXGbaUqEABWB56WoLyjukBhxR14MLUPn0IoXwf5gMx
	+DUE5KzxvU9iUAZt+8059KOu6amFLj8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=aWzX7qvR;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb61185057so15332715e9.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795076959; x=1795681759; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5EhIH0GsNWo/xExkiXtvhKm+Q3j5FK0DSxcIP+QAZxE=;
        b=aWzX7qvR0C18degsqZtHns2VKgmy06Dic/5HbTLcSNqx4zjY5Go71PCQNLli99PqWk
         uNHnQIHyfX097GfneCUqzeOHqGD6t36BqO0lEaZ0DtaAGVbmKYORrYaF21BwsxprLGgM
         FlDAOkZQvkQ0FxmHUQ3Ds7pmDqxQDHuOLl5PbpWwJZmoc/UG7NDdZ1FexkG86nC7H3HA
         5Q+akuqi0ZuJ7rcns7juiOZyRb9oK/0RQnZ9ddCb2SWOFGIeyunvTw5Ur8wZnj9CIBqP
         7ZxAxUqMf1xSipB4WHa2HflHeqaST7DbFHcsv518gEmJ1DQBYgk8GVgVUoe7hKp9GMdn
         oMBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795076959; x=1795681759;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5EhIH0GsNWo/xExkiXtvhKm+Q3j5FK0DSxcIP+QAZxE=;
        b=ZC5o+XYlnBzyOejqiAj+3Yz1kAMi8hl/NpSh64cWIKQnLWjCiAm+2TbTDBGITOXNVa
         G4GAZQJ73jNrV/7c9oxaKX/s5mvg2zszuwuYQsK/6acIo649VoCOKGlt8NuOlrbut98G
         XUlpzJkUfRsGxFBIZO8MVasHQsS9YSqJh6OYXbed2z8mdvIFFLWuh4nC1MeRko8DsYGj
         0I2yvVqdOFALPdtW+3Vggigq1R+bZYgu3Z6d4CISz24ovRgN87Y65SEU+BYu7hPepIF0
         cC5+o+hO8tahxjDlDoYU4ceTgImvlqVMiBvN+ZZhKre9Gdr7ti7ka9kZnQFWueW+unZG
         ggIQ==
X-Forwarded-Encrypted: i=1; AL+hErFX7IvAwT4AmgVxqT/4RwN8XRCTHoSQ/74KcgWtQ3/WjW/rKy+orgmGc9NG+Wxpm+oDc3a/+GX6pQ==@kvack.org
X-Gm-Message-State: APuU4Z/smU/fWA/ViqzrmJ4Fl1cTWpn6Wjmz9tN7lmQg6OTkMOCs1h8c
	o7wCsbRUgNKmjT05EovXUU82CXoAu/0sNIZw2JAKwWRz2ushDyQb8SJcfKmir8TkOzQ=
X-Gm-Gg: AYBFou01YBxVjz4eF+J9VQxyYbIC7lMhuXG1UPvz0RZQUk7nygJVyoQTkuQbXMMgS83
	VeRdx2M4qUpLNLxXC738O63StkRZdKfJvB6tfnb1w30K8iNClINoTgjPrqOQTbMHBTTUZ5EaWlE
	Vhg1qsGrga5BpypBIB47sviyNOF4EC0oGd/HxIHhN0kzdSJ8Xc2CowNwjRflOHVaeh4xSm8BoVT
	w3cMu5cR0CEb9pjdm0pzecc5c/Th84yhLKqRp6PmeRi5Nw+yChdArmu5n+D3iLqoMMIrtoUqB/Z
	/01HjV55hbo4y3NVNljaAcsB7fSrGLyKh7rNJgtwdM2b0zZ09vMLgx292xC4cWH7DhH/yefvjbM
	6FfFqDtKgcJ8+5eSD4AZKxyrWSkGwyrhQNE3hgDmFS15TjiYbbPqBDxpa6NxL8aueKaL7ulR8B9
	4RdcbjP1LdNhTwDjyo+0pLIepf0GXo/UVMdXviOda0WEdj4R8wuXsBZ/5HuUPEB3bZsMCTBLu3V
	/iZtjuVxSfb8aKxR7qRSUy1yzoeSR2pXOkCZa779Km5AdCb4jdPXM7NwDGX6asSJxU9K6vD0TxF
	zWujBJsLGlXiC9w7ccwC4Mqyp237v2ygIJM77TLv50w=
X-Received: by 2002:a05:600c:1d9c:b0:4a9:2a92:231f with SMTP id 5b1f17b1804b1-4bb7da21ffcmr108691355e9.7.1795076959257;
        Thu, 19 Nov 2026 00:29:19 -0800 (PST)
Received: from localhost (109-81-80-145.rct.o2.cz. [109.81.80.145])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb84e5edf5sm11159705e9.4.2026.11.19.00.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 00:29:18 -0800 (PST)
Date: Thu, 19 Nov 2026 09:29:17 +0100
From: Michal Hocko <mhocko@suse.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
	Ingo Molnar <mingo@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	Chris Mason <mason@kernel.org>, Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH] fork: clear p->mm when copy_process() fails
Message-ID: <av6zXTxe0fAaHrzb@tiehlicka>
References: <20261119-mm_failed_fork-v1-1-b3019f43d197@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119-mm_failed_fork-v1-1-b3019f43d197@kernel.org>
X-Stat-Signature: 1q8uzpmd1enydatrtshtqnz7y6rcdixp
X-Rspam-User:
X-Rspamd-Queue-Id: C499320004
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795076960-49540
X-HE-Meta: U2FsdGVkX1/Sx5Re9E4+Wf0IJt+JYpLgvvQmqSF3ANsRMUdsql1LH2vLyofXcdi+omKsjw2ZzNcpcgyhTW1P0HUw1gYoTwybkwhkhULeo9hzz3gTJBaNr/eyl5ye2hQ7yGZVg1GGrP4nml/ncBq4yAfeBk1TzMSqVdwOugCTQNLYL6qOZoFp7AZW6xD7bJtDst0HgG0YwdI7Mmay1yyzCM0bky+qaAE1q3BeQi6EQPouIq6Aj4SF0mjfuF/blDsM7RGVl5LaDIabR6n75XGkGHcq8uGCW+N8tWC20JgnID/Agq4XEeN+Y3FmXr9LeGdmvDUhtzHPIwWHHKp55rbi9whiZGN0e5okt9temgPY9bN/cYxROCBopI8fTPs9Nb8zPWR6CjOnbPIXU+uAYORFXkHvn0LllcjpUIa/ibtSmcHDqdjQ0kH12HEbwu9iXPtvM4cD3fKNiqZZcc6YwtlMoHRJv1H56SkwkXqgVRJiwsxPnTzck4fA2r/0lDpICRUW6471MUR/Y2k+HO9r6VaL0hJ8nddd66BmFL3mN9JJRuew/n+HSVJaP02ma8KxWBV76/MVzx8XISAumtnMC/eEeDZUPv5z08XNpSsmcpo2B/gd+2wFH0Z6b4KvhazQqzEPFYh/JxeSyFsLyKZMA0p0bhtXU7J1O3+QF3CIAwHkmBnRutH+zA83pZ+sn65QB1qbEloSWcxHDtcb3FoY27md+xzDzapkvBbLI79WIcEhvO+Tx13Rxx2k1BxDs/IsCIzwKwKPNtAvUru6NIDXYymmyh/omjJzYRjjWyn9/XkzWPNPGlYT7L8ISLbSam0gPzBfEadO4DfE8a00YdZ3ckMDWqPBLgiXMiS8lVzxAxD/b8c5//4ThYz6Qxkkkogvs2hw1IViqnjbtS25i9aQ07t7Z0qG6eIVMhR3qUpXgZi0mkXLw9FSzvEDyeffRiCao+sQ/G+wPiaCZrmK0Js03LU
 bzyFMG6I
 JIMR4y8xEJTGDHs3jEworKsPb0qg2vkalgFCI6YrHIiG6VmRKLM3Y8jPSMtyQmpAj6CHjoZ03ozPoJ91axzrBzHnvPP9w6Ofxfi+7UKss/GMlqTHWTuGpG/F40TSvE65y7Ncsn60gIaOoRK3NCN9fLZUlldaSffMRjwOMvWUTtvv+rDlSoxREN3p+KjY95DurMRgTpfa9pvhbKxIX+vrA0lNW4RBgmF1M3Y+s1x7O8d6KagDbOhNciZ09gQ7QdrH4T7ITSGqhrOKVTYwSCOYOPDV45q+nqPWL8jdVtEo2RFckEgMcSZVqN+bImjbW3Q/NAd1mfUewTY19iwAf/zgMbd6cYsrWwscMgGIG8r/tdfqIuznbsfl+V97mGAhFp5Xera6W3VsEGAepLDW7vm7MLNfCvWtjhIRKNZPSLMovbRZTvctBXyNmUe8chzxq5PE6+p2zsMZxG8OfGF4v2iIx7bVjHRpHA5k/yd4rplioIrBu/b+t+TMoyPpqVeodRl1JSeMNRyWMiUKlGa/trs2Z0VdCxWq0xBl0ji7eGDC8k6FDVE60w3CcuAdZLfYQQYNEOKg1D8IicuydUEVzHF3ztcAUkzzHaOab1wMT6grnNDZpCTUTneO1QWAStLTDCFNaCsD4m0QiIIbkD1F0THUk2WjZtVygR2qwBEducZBHCH/mHcjEtM3gMNkOW39iMD3/6XCIgXw7fXLBGcA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 19-11-26 09:04:58, David Hildenbrand wrote:
> From: Chris Mason <mason@kernel.org>
> 
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
> Similarly, a BPF program on the task_free LSM hook can call bpf_find_vma(p)
> before the task is freed.
> 
> Fix it by clearing p->mm under task_lock() before dropping the reference,
> just like exit_mm() does.
> 
> Further, if copy_process() fails before copy_mm(), p->mm is still the
> parent's mm pointer copied by dup_task_struct(), without having taken a
> reference. While nobody can access it concurrently, there is the
> chance that it might get accessed later when a BPF program is attached
> to free_task().
> 
> With CONFIG_MEMCG the task is freed after an RCU grace period, so the
> parent might already be gone and p->mm in the child points at something
> that was already freed. So let's just clear p->mm before freeing the
> task. No lock is required as there cannot be concurrent access (and we
> might not even have the lock initialized yet).
> 
> This has medium urgency.
> 
> Fixes: 375637bc5249 ("perf/core: Introduce address range filtering")
> Fixes: 7c7e3d31e785 ("bpf: Introduce helper bpf_find_vma")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/sashiko-outbox-180866@kernel.org/
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify description and comments ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
> I can take this through my tree (rather soonish) unless someone else
> wants to pick this up.
> ---
>  kernel/fork.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 5efceb8d58a78..77d6c8fc38c66 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2628,8 +2628,14 @@ __latent_entropy struct task_struct *copy_process(
>  bad_fork_cleanup_mm:
>  	sched_cache_fork_cleanup(p);
>  	if (p->mm) {
> -		mm_clear_owner(p->mm, p);
> -		mmput(p->mm);
> +		struct mm_struct *mm = p->mm;
> +
> +		/* Perf events and BPF programs can still reach p. */
> +		task_lock(p);
> +		p->mm = NULL;
> +		task_unlock(p);
> +		mm_clear_owner(mm, p);
> +		mmput(mm);
>  	}
>  bad_fork_cleanup_signal:
>  	if (!(clone_flags & CLONE_THREAD))
> @@ -2663,6 +2669,11 @@ __latent_entropy struct task_struct *copy_process(
>  	exit_cred_namespaces(p);
>  	exit_creds(p);
>  bad_fork_free:
> +	/*
> +	 * If set, p->mm points at the parent's mm without a reference. Nobody
> +	 * can access it concurrently anymore, but prevent later access.
> +	 */
> +	p->mm = NULL;
>  	WRITE_ONCE(p->__state, TASK_DEAD);
>  	exit_task_stack_account(p);
>  	put_task_stack(p);
> 
> ---
> base-commit: 4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd
> change-id: 20261119-mm_failed_fork-a46141b503d0
> 
> Best regards,
> --  
> David Hildenbrand (Arm) <david@kernel.org>

-- 
Michal Hocko
SUSE Labs

