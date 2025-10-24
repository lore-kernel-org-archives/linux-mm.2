Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F14ACCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBD498E00A1; Fri, 24 Oct 2025 10:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C45708E0042; Fri, 24 Oct 2025 10:29:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABFDF8E00A1; Fri, 24 Oct 2025 10:29:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9353A8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:29:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F33FBE640
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:29:54 +0000 (UTC)
X-FDA: 84033241908.29.33A770D
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 21C9EC0007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:29:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=lNiDEF6C;
	spf=pass (imf28.hostedemail.com: domain of "prvs=63920b99c4=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=63920b99c4=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761316192; a=rsa-sha256;
	cv=none;
	b=mtn75pChvh9/1xRXq62RgFz8SRiBrqqnEABb3onKAju0pua955ehU+jAfv73DNV+i77AYS
	uMxFr4yG0dVXgmme548B2JRktCw0+4K1xJu78VZ5N7Mbrts6IMWg74hzAOd8ZviKP05jhD
	W5+vC7tr7pUY1dWaFJblwp2hm1a9aR8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=lNiDEF6C;
	spf=pass (imf28.hostedemail.com: domain of "prvs=63920b99c4=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=63920b99c4=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761316192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/h0G3p+CogW+KUD4A3h3rSaunnYLJugMgdAj9+txKM=;
	b=5v+AlVn9/RKwbxMrjjhVel92ruFMxAGKVQJWbun5Rz58iIo1F8NFBHIfe0yYMY2WU6t0F8
	Y2FxBfu+5O+pJKKw+NPToBOM+WCNWnj6PoigsRS5okRl1jJI/6llK6bAtLjZO0zgqsik+I
	C6ZNYzinCTgpVEAtAUuu01hVzJSo2cQ=
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59O2UEjG1836665;
	Fri, 24 Oct 2025 07:29:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=6/h0G3p+CogW+KUD4A3h3rSaunnYLJugMgdAj9+txKM=; b=lNiDEF6CSP20
	iTsKdShjwOWG080Ql4m0WuuhKTv/PnaxXYtx2oBXzSdEmmHN7jcBUwvLpsJ0l19i
	2pN7xUXlwxalCx8zy3oAclMDLf2a059pw1umjoGUI1AgU+a0ybhiKuP4g6gRBzfB
	L+k3vdZxzdnpzDjAMGaF8dQgxXkmg6C0sgUroTyp/7DXOvXQwxICSzLS6CXdk1XR
	kgWoLESaE3lsZEq28cnhZibtC0cya778ashO/hCetb0FJPb2O0jFYSQKcKKDr0Fa
	Yu0eoA8r6/MNE7kizbFCOCj9p1vhSMYZCMshku3Yz6hOLBoRoNX6W98joaTZs8QU
	eq2VFCVJDQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a00qr3bp6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 24 Oct 2025 07:29:45 -0700 (PDT)
Received: from devbig091.ldc1.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Fri, 24 Oct 2025 14:29:44 +0000
From: Chris Mason <clm@meta.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett"
	<Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        "Sebastian
 Andrzej Siewior" <bigeasy@linutronix.de>,
        Alexei Starovoitov
	<ast@kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>,
        <bpf@vger.kernel.org>, <kasan-dev@googlegroups.com>
Subject: Re: [PATCH RFC 10/19] slab: remove cpu (partial) slabs usage from allocation paths
Date: Fri, 24 Oct 2025 07:29:20 -0700
Message-ID: <20251024142927.780367-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251023-sheaves-for-all-v1-10-6ffa2c9941c0@suse.cz>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::8e35]
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI0MDEyOSBTYWx0ZWRfXzo7mh/+QEEto
 lN48tJt90rZ0v9oBAvXPrAsfwe+CenqqyK68LR7o0BOfvJujTaqFIdwroPduE2PBMa7VnKqUE/B
 hR/lbf4iinufGfA1AoIc8lE3vKY7y4Hw5m21adIOtvFfDgLbh7c/rKrhMA+6RLDywjI9qT/AoPU
 QMz8k7g4r2r6F7d78Ky9USlLG/pqBLtW9jbItBaZRSJncw/ge9eg3eKLxO5qPcfnkt2yRAOGPDZ
 0oDHjSRBppMO5yVVZV2peChq0H2i7zjAjvg8Sie6K49tWvOlXv5+AOIWEC9CFAuuk3C2lzCpqtT
 +WAgDcHMs2kxxD4qDJk65eXaVVatHMy1wdEZjZIXRWbu9DTaF8gSAizL8JMHUtenNSM7KaKQCvX
 uRzKVvQvjM8o8dsWfoKrJwWlFoOyMA==
X-Authority-Analysis: v=2.4 cv=YfWwJgRf c=1 sm=1 tr=0 ts=68fb8d59 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Qud2Co-4zkO9aUnGrzwA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: whmAAHXeJ-9g96VK63zLv5mAQoKsaiQB
X-Proofpoint-ORIG-GUID: whmAAHXeJ-9g96VK63zLv5mAQoKsaiQB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_02,2025-10-22_01,2025-03-28_01
X-Rspam-User: 
X-Stat-Signature: fg61cksri4wtae6p8qfw1p4tr9rubgbc
X-Rspamd-Queue-Id: 21C9EC0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1761316191-724826
X-HE-Meta: U2FsdGVkX19rNfQAZ962i6oMz9arlLY+yD5E9gHcKW6nGDJs7FIGNevNlQmMKm6bfiLe0Cg+Ok5heUxJ/iegAJU7mniPybZWcm6mF7a5F4b1qgurdTxDB5LFwyP5MujGhtibkwjGKQu2B0Wy1KCPhjtXgNYXP5UuSCni0OnCfrlpklreg3iMgufl+JXUcxA3+mmS/40OGkhbpgLYzqavdVjrXHcDsPwbPmEkdH9oKKsqWVY4yD2g2xgGcTvXxnn67m9yjMo4DyS7gTwsnNyEJsvvO79u2DBUJariuzxJ703KdD/EEasN0Zs6RlvHOI5HarePfFBMnlVGQAs8LK9Ke1Ikj1Xe0lST9bLk3VBvrMtdve/jmktUBQSUstvN6gUBm6xi75xglFyY8Hk9ZdB6xNTR/y+oDQtIKsDfCnS/D/P4i5ibLc5XjDKFfQSmh//MYmM1hRNsXYs67sSMwBZvoSWxkAxq7y3ejRjPafOQoR6AOQrXVxKm0ljmXgPrR+kUMKCTjCXsmnjh/pk6jAM8cJsWsytGCVfRN3AaOkWePTgriT8VtLmIL2ypy6pVRuH/OXRvTfFV9e6ECT84Z2saVxV3e2yvflCGJ5Q9eT6NMeUwtRuhai52LFy75KDbMKHVtS/YKx5RFWTRzPmzB7JZXLYmCDIwK62wPaZ/n+MWPyNUP+2cmVT0RvKrmmJfZmW0477eRqK6d1RXnmU0PzKvxSvfd7+KoTMDSNV9aXexvZjq0wsjD8T4wnaEVTsVX7/NAzrj7tFd6cQgEMa0c64C/duDZqT1Jibv4YbqXAIZ1PYBx4zsAEofuqR4P/ye/KyZkUT4XyQJKV5X4wK+p6KIerRXU4P4zUdbINE14HFWlmWxr0vMrLmIlLh/1fxzxORWOmwEcv//aBCV0qAT+ZR7BtBT4HWQWEHb0FnqYBjVV4eaZBJcxR3FIYi0BLZhw/G6gWuHP4IWepyOQT8vliE
 +tX1Q65S
 DrwlAu9uEIviS8LHFO1/jibJOuvQOuMwL9qtrkvwvDAiTlb1WoBq8r5XIykTH+Zzl6sEpNQ5qlkboRVfL3fbt5aCEBAvxUWJ4rXV1MyRvBV6UB3AzmTAhlwOUhN8D50lhdfdD2EH7rxE5ZbmT4v3cyniE3AdClVMXtSH8vynY0tFlkAbYO/3y4ujMPQLsp2DQhnHq1rYOq/tTq9AslMWESH+Msqz5XtUDfzVeaT7rd4Nvb6PQcxHw4Tvw3n1+4ZuiGTAZd68s5TiFKZtyx1jFVEwGuLVmSrU2KAAHgywBJuzEw5axtzmSh/pb7X2IfFRBCMYVx3DUd0dhbHCasm5x/Q8xjKG9ng9sr7EU2SK5KFJEO6VLfVua+Qihzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Oct 2025 15:52:32 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> We now rely on sheaves as the percpu caching layer and can refill them
> directly from partial or newly allocated slabs. Start removing the cpu
> (partial) slabs code, first from allocation paths.
> 
> This means that any allocation not satisfied from percpu sheaves will
> end up in ___slab_alloc(), where we remove the usage of cpu (partial)
> slabs, so it will only perform get_partial() or new_slab().
> 
> In get_partial_node() we used to return a slab for freezing as the cpu
> slab and to refill the partial slab. Now we only want to return a single
> object and leave the slab on the list (unless it became full). We can't
> simply reuse alloc_single_from_partial() as that assumes freeing uses
> free_to_partial_list(). Instead we need to use __slab_update_freelist()
> to work properly against a racing __slab_free().
> 
> The rest of the changes is removing functions that no longer have any
> callers.
>

Hi Vlastimil,

We're trying out the AI patch review automation on the BPF commits and it had
some questions about a few of these.  Since the goal is to actually test the
automation, I'm putting them in unedited, but I did try and make sure they
were valid before sending.

This one seems pretty unlikely but still worth fixing:

>
> diff --git a/mm/slub.c b/mm/slub.c
> index e2b052657d11..bd67336e7c1f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c

[ ... ]

> @@ -3575,15 +3532,15 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
>  }
>
>  /*
> - * Try to allocate a partial slab from a specific node.
> + * Try to allocate object from a partial slab on a specific node.
>   */
> -static struct slab *get_partial_node(struct kmem_cache *s,
> -				     struct kmem_cache_node *n,
> -				     struct partial_context *pc)
> +static void *get_partial_node(struct kmem_cache *s,
> +			      struct kmem_cache_node *n,
> +			      struct partial_context *pc)
>  {
> -	struct slab *slab, *slab2, *partial = NULL;
> +	struct slab *slab, *slab2;
>  	unsigned long flags;
> -	unsigned int partial_slabs = 0;
> +	void *object;
>
>  	/*
>  	 * Racy check. If we mistakenly see no partial slabs then we
> @@ -3599,54 +3556,54 @@ static struct slab *get_partial_node(struct kmem_cache *s,
>  	else if (!spin_trylock_irqsave(&n->list_lock, flags))
>  		return NULL;
>  	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
> +
> +		unsigned long counters;
> +		struct slab new;
> +
>  		if (!pfmemalloc_match(slab, pc->flags))
>  			continue;

Can get_partial_node() return an uninitialized pointer? The variable
'object' is declared but never initialized. If all slabs in the partial
list fail the pfmemalloc_match() check, the loop completes without
setting 'object', then returns it at the end of the function.

In the previous version, the equivalent 'partial' variable was explicitly
initialized to NULL. When all slabs were skipped, NULL was returned.

>
>  		if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
> -			void *object = alloc_single_from_partial(s, n, slab,
> +			object = alloc_single_from_partial(s, n, slab,
>  							pc->orig_size);
> -			if (object) {
> -				partial = slab;
> -				pc->object = object;
> +			if (object)
>  				break;
> -			}
>  			continue;
>  		}
>
> -		remove_partial(n, slab);
> -
> -		if (!partial) {
> -			partial = slab;
> -			stat(s, ALLOC_FROM_PARTIAL);
> -
> -			if ((slub_get_cpu_partial(s) == 0)) {
> -				break;
> -			}
> -		} else {
> -			put_cpu_partial(s, slab, 0);
> -			stat(s, CPU_PARTIAL_NODE);
> -
> -			if (++partial_slabs > slub_get_cpu_partial(s) / 2) {
> -				break;
> -			}
> -		}
> +		/*
> +		 * get a single object from the slab. This might race against
> +		 * __slab_free(), which however has to take the list_lock if
> +		 * it's about to make the slab fully free.
> +		 */
> +		do {
> +			object = slab->freelist;
> +			counters = slab->counters;
> +			new.freelist = get_freepointer(s, object);
> +			new.counters = counters;
> +			new.inuse++;
> +		} while (!__slab_update_freelist(s, slab,
> +			object, counters,
> +			new.freelist, new.counters,
> +			"get_partial_node"));
> +
> +		if (!new.freelist)
> +			remove_partial(n, slab);
>  	}
>  	spin_unlock_irqrestore(&n->list_lock, flags);
> -	return partial;
> +	return object;
>  }

[ ... ]



