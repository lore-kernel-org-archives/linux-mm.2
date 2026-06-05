Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C070FCD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 09:37:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01E36B0088; Fri,  5 Jun 2026 05:37:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2606B008A; Fri,  5 Jun 2026 05:37:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC8376B008C; Fri,  5 Jun 2026 05:37:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BBEE6B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:37:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 607B992413
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:37:49 +0000 (UTC)
X-FDA: 84845357058.24.29CACB0
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id AD52B1C0007
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:37:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=HoAyQpAd;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780652267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e84QUmeJSE8evcwDBPyvsbmrCzkZyJlvZDf/jrq/0lM=;
	b=5cvDQyq2GuAi4cD0JaV2rMoRfDfuh0BFxyIt8e9FLaJ70BXmFuCG6kmw2s/eGtcYfqcCuH
	e/+HeMRC/qRv1Z4B4bpXBLusVIT213PygnQjPs3DapG5t4uZ38yHVcGKZSdDaI7pFkzRVm
	/+fNKQsz/QpIGOIlj0k1d8J5W0/dhP8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=HoAyQpAd;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780652267;
	b=3VVXIfFZXuSqxBEravS1200vZ+3oqOLoL3WZ1eMUAfzi8mfT5hJai/JyVZrBNWwhxvcRvl
	mh4xFRWtp3f9rrJHyC/aT5TDwnOhRe/wRx6WMQCZs6PWBeSOSu7YJSjC1yHV5k/CXivY18
	pFMogqiQ3ztvLXYmxsgqS//LiYaR0BA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=e84QUmeJSE8evcwDBPyvsbmrCzkZyJlvZDf/jrq/0lM=; b=HoAyQpAdz43G5JIm3qfXgiGA3Q
	RYaencs/IDR9pJlLxEGrRRDs173Cg4cS/7hlFAerKRcguaUaCB13UwA6hdU3k09h4dZkpZ+zTSSk6
	d+fvwerT20b4PIpYFiUo6EQEBffvAaH6beBEAxta39svbOoFjCliJI+iqak/C2QBVe/UGc+yNss4o
	LmTQ/KEiaCWG9YhPbkmpfE+vOEcLSe0ijpMECaL8OjByFPPTUJPT6s8jtme/wyeLDGeP3jHt5YpPZ
	ClIYaScB1wv+RbOHgVXcSpCZuYlwlZT+pODdxZ78rFL4HJwmpB29pIjz1IF3QVtf2aziL/dmZDruT
	3LT1WHxg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wVQzo-005CGM-1M;
	Fri, 05 Jun 2026 09:37:44 +0000
Date: Fri, 5 Jun 2026 02:37:38 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH v8 4/6] mm/memory-failure: add panic option for
 unrecoverable pages
Message-ID: <aiKYvU0BpClpykCa@gmail.com>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
 <20260527-ecc_panic-v8-4-9ea0cfa16bb0@debian.org>
 <4d7b720a-7975-8a4d-a00e-e888d63812a0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d7b720a-7975-8a4d-a00e-e888d63812a0@huawei.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wwy56p3kaq1i95q6zb7r7h9fxpkxjofg
X-Rspamd-Queue-Id: AD52B1C0007
X-HE-Tag: 1780652267-69807
X-HE-Meta: U2FsdGVkX19OqBD6QIH8jKm19dk9+Y/GaJhVmxD63jd6CDHzxG+hi3UzejHpX9MDMwrxfeVzA2X5a9aX+iRq8WjAeeEai/r1NKu0EnuUmEgTXhXX3su4UVlHKZYUtESaBhhCrq5gKezFCEqDx26wFqidLvERMDJVUw6jHIfvuAbrH6/4GwAtA2SNVgjxTNtM9tNbkFoYJGD+nrX5MEl4BNbMQyD403oUbAdSKcgbjZjZTo2VLwXOyVbH69irN3GY/BsRF3zzQ++SV4yO9wMpwkdcFVL+uLbW36j/XHcljIwd9+gLrLEs9lG2v9d555Ll0nxFGfyQwIkNSzoK8FnYA1RQlY97hWG9RBycKuwqGEfN97/PZnUALe3h5qhR3uFZFXDalzHmr+EF2DQuxv73GuxfyhWpQN7sW9GYpMmFRc6xP8wPbrD+zlBUPdgrSkxxf0zJWSzyhRhpaHFGchQXjrtVMOm8j5kYH334PIciM76IK5a8UftAfesskmhdmq7lUPwGM8RQ8tPSWclFiae1s74E0elfzbS5r2DlKiKzD+eJ3mIj+wLWWkvt6hB9hKysseyKYShtkbv5WQG/M7RoBGNwWibp8iPE2FI7sbJ0KaNKnAjAD/yhvYGqyN2AKu6mZ/ALRckzHcCxMsR8/UYSqZmMLWEAt136uSS87yPg0r4qMlPgGvvh4E2EGh+Zc0rk0zmMtRD96TYTEYt/a58JPgq6TXcbyacSnYWTEQ8jqcZHnH9J3lIpkQammDom0bRTA0im8GIF4mUJhqbwAIh09RHbDmqtJyYXeEYv0posHcETRlhprjesftWv3pz2jO1AbafuQBDtMx0ySnrhzvYKfQc/lqPc/V8u8SX9r/qDlwDQKH2RtlATuUrC/w6fgMVWD2WM0hxTFFodMJlH50paUjCF+14lr1+96Kev7vpgbKnej0XIUUbM4KAfiuy3ye6Abq/304g3WqtWiFnokkf
 uliOn1w7
 +8z2dn/yT9704Tzo0N/8r9IlcTN++fzSKuPIhV08bjMXY3gC+Z1barvxL30rgFIGjGctmvPkTtk9aud/mLS9q8awSs2ju1U+WhHRwEaoDVxpwzxYcLkTxIjFkoRlrDQ+muwWrrfN5xUBUSNNlMNUz+1usy1IiNhu6Qa2uPKRUIPomF6RSDCicg0NDUgAyDPT68+DQBE9DOhX3mQBa6x7oxQKyJVQvbjenKcT99e/IduEechg7HdKAhd5CVAeEK62NuiZAJIrl4C14H2CmFRVrVoIgYCXrQQwkHxeiaUpIpa0easGjL9OEPJXFmOwkg2UPhM14Ovo30x7NMf3RMv5TVTMCJccgWbd7Sk+Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 03:05:32PM +0800, Miaohe Lin wrote:
> On 2026/5/27 22:06, Breno Leitao wrote:
> > Add a sysctl panic_on_unrecoverable_memory_failure (disabled by
> > default) that triggers a kernel panic when memory_failure()
> > encounters pages that cannot be recovered.  This provides a clean
> > crash with useful debug information rather than allowing silent
> > data corruption or a delayed crash at an unrelated code path.
> > 
> > Panic eligibility is intentionally narrow: only MF_MSG_KERNEL with
> > result == MF_IGNORED panics.  After the previous patch, MF_MSG_KERNEL
> > covers PG_reserved pages and the kernel-owned pages promoted from
> > get_hwpoison_page() via -ENOTRECOVERABLE (slab, page tables,
> > large-kmalloc).
> > 
> > All other action types are excluded:
> > 
> > - MF_MSG_GET_HWPOISON and MF_MSG_KERNEL_HIGH_ORDER can be reached by
> >   transient refcount races with the page allocator (an in-flight buddy
> >   allocation has refcount 0 and is no longer on the buddy free list,
> >   briefly), and panicking on them would risk killing the box for what
> >   is actually a recoverable userspace page.
> > 
> > - MF_MSG_UNKNOWN means identify_page_state() could not classify the
> >   page; that is precisely the wrong basis for a panic decision.
> > 
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> >  mm/memory-failure.c | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> > 
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index 14c0a958638c..dcd53dbc6aec 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -74,6 +74,8 @@ static int sysctl_memory_failure_recovery __read_mostly = 1;
> >  
> >  static int sysctl_enable_soft_offline __read_mostly = 1;
> >  
> > +static int sysctl_panic_on_unrecoverable_mf __read_mostly;
> > +
> >  atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
> >  
> >  static bool hw_memory_failure __read_mostly = false;
> > @@ -155,6 +157,15 @@ static const struct ctl_table memory_failure_table[] = {
> >  		.proc_handler	= proc_dointvec_minmax,
> >  		.extra1		= SYSCTL_ZERO,
> >  		.extra2		= SYSCTL_ONE,
> > +	},
> > +	{
> > +		.procname	= "panic_on_unrecoverable_memory_failure",
> > +		.data		= &sysctl_panic_on_unrecoverable_mf,
> > +		.maxlen		= sizeof(sysctl_panic_on_unrecoverable_mf),
> > +		.mode		= 0644,
> > +		.proc_handler	= proc_dointvec_minmax,
> > +		.extra1		= SYSCTL_ZERO,
> > +		.extra2		= SYSCTL_ONE,
> >  	}
> >  };
> >  
> > @@ -1255,6 +1266,15 @@ static void update_per_node_mf_stats(unsigned long pfn,
> >  	++mf_stats->total;
> >  }
> >  
> > +static bool panic_on_unrecoverable_mf(enum mf_action_page_type type,
> > +				      enum mf_result result)
> > +{
> > +	if (!sysctl_panic_on_unrecoverable_mf || result != MF_IGNORED)
> > +		return false;
> > +
> > +	return type == MF_MSG_KERNEL;
> 
> Would it be more straightforward to write as something like:
> 
> if (!sysctl_panic_on_unrecoverable_mf)
> 	return false;
> 
> return (type == MF_MSG_KERNEL && result == MF_IGNORED);

Sure, that reads better.  I'll fold the MF_IGNORED check into the return for
the next revision. 


        static bool panic_on_unrecoverable_mf(enum mf_action_page_type type,
                                              enum mf_result result)
        {
                if (!sysctl_panic_on_unrecoverable_mf)
                        return false;

                return type == MF_MSG_KERNEL && result == MF_IGNORED;
        }

