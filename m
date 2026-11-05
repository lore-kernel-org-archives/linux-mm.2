Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4989606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=chIX2RQM
Received: by kanga.kvack.org (Postfix)
	id BAC266B05B5; Thu,  5 Nov 2026 11:24:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84246B05B6; Thu,  5 Nov 2026 11:24:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4D0D6B05B7; Thu,  5 Nov 2026 11:24:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8003B6B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:24:03 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25E581A0AFA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:24:03 +0000 (UTC)
X-FDA: 85401587166.07.33CB20A
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 63752180006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:24:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=chIX2RQM;
	spf=pass (imf06.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793895841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vEatsYln1JH/NSaGPfeQTStpuozS299aWgZQYhTiFGE=;
	b=JIctfwIgLW5mMAO4aTp+5HAZq0c53dRXs7AtKsNj8S7aV6Ga67nx6qkDBY2xfLPjxhdJ8f
	SvzvwxzU/OiOvI+xv42Vz+rEWYSXY/y7ilLvZCsVEceVHAq3cpgHVbBH7ISLx4j/gwJIP1
	ehMm5YLTFBednWLBkNpMrkeeKssQoPE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793895841;
	b=Sfp05+PR8k/HNafOyc+wfIbMnynxTp+NOQIhNVe+DB31GiDgwDHwE3meTRh0DcXSy2Z2j7
	ewreXE4p8A15DRurp7A1EYA7fJeBabotp+cPEVyIoAnomXJd+eM565q8QU2nLrzXR93UR+
	GrbnbaU+ShlZo3Gz88dTAXGYyXHixLM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=chIX2RQM;
	spf=pass (imf06.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8a06e79e152so1276621b3a.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 08:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793895840; x=1794500640; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:from
         :subject:cc:to:message-id:date:content-type:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vEatsYln1JH/NSaGPfeQTStpuozS299aWgZQYhTiFGE=;
        b=chIX2RQMIx8dpYAU9qf6hayEWLLf6bW1iMjEazCz3Max82VhVZlk1tsxVenWLNJpiU
         FPFZQ3ZU/3uTmndzQhlDTdRZBYs6r9B0J09nb8BQKYpSNXO8sbE/sQlKTV9Y+JJmhlym
         8niJoS5lx+UL2Bq0BmgRNKP8aFkbdeZhQShcvbX+Hu9azfm1ODQizcI3G/HdNHiHokne
         i+eSudZEKbmji3sR0rQcxBBxvvIRBstD9Tif3TCcema8iEZV97bAkMdqBSDS+j/0eFmN
         p2lAGNQxMM2AvVcL5UhBQjCPXnTJcDdeSl5uHcl/at6PvRwpjwaaZ+gvcHVminhhYwcr
         n4OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793895840; x=1794500640;
        h=mime-version:content-transfer-encoding:references:in-reply-to:from
         :subject:cc:to:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vEatsYln1JH/NSaGPfeQTStpuozS299aWgZQYhTiFGE=;
        b=fDvFaabKFi0sx4XkMtrurGsfkfR+LHQtWhLKkWst00TYi5VPB3KGfL5jgwgOv89Rlh
         CAvkO+AWuzSNvkEO8sfRWD42OdgasUwyg/OmHx4YekfEp5601DhoNAv5w5CszMEVZuky
         2dcqBDeWFXDZWhfQk9tQp/zCVVh0WswP8o463ZSZ7OkwrMdtXBkYttQredDUn46/NU9z
         motfkOGvAdekrR1RPcFsUQVPMKoq7CL7EDI7vdwiNLS9U2CEz6Z2i3ep5dHH35qh60sX
         bmg4pY7/qW/lJSnyvZaC+eL7kN+IGfJvnsT0h+A4R20lxJwEHrqsZiXYl/wx2VsQwoy8
         vA1g==
X-Gm-Message-State: APuU4Z8MQBtlSxpEThftrPd3ZPyypUQyE+oJ8uPPkOqpiukqIEtMxSwY
	TOYqX1AP02DNGZc5hpWYa/tPsFPdWFmR/+q67ue2Wpt6Y1IRpWwRxAOa
X-Gm-Gg: AYBFou2ybN7KF01oN2piVICaw6yfbA/W4trwX4pUduZIRo5FDWuuWPRrcphITzH788j
	zNDwe/uKpyi3DFIg3I72Het6LXW+/1Xg/pnUoY6dh3wnX9cVK3UUlReUL2JbEb94iYHXhEV8pzY
	3+54L7szaxYKliavj3cSTelL1Svbvs0NdQzeasqc0kIHnzlHKihr07BZbwmk3oGyFhreH939cd8
	4DEc+nQFbqIsJUxinVUWTakudnBqfZMHjd5sQgAeJn5/boQgiATXltBFCl6MweOTnO8x88iEM1z
	+uaM/qjtMgJQuEaKw/WdNkXctrDidsl7JJzos/6jDjo+qhIQFXitbK1D40l2JtXT8+Er78Lajv5
	pxqlB+0T8fCwAC/z2rOyPxEGaOvp6ZjSV9D0SfrPVHhGpFcPON5SDB0bTSks+igp+YyHCr89p95
	tkDape+oy4qq0611Q6kUOrV6Bnl/C/hLpo/z2nmK6GQ4GvC+V4Suut4Ix151X2CpVBJXe0t2P5D
	91JjGWD4lTF4D1wxrgHRLBN9w3SqLLGZ1oW/iw8zqtKFovOyvyytuP/2X9ciVYErisatHA5dHLZ
	3hMEOYiiA9nAEX4aJJT6/SMpKUJIXcDTQKUhJ8qKpl/HdpPRXwWBZt/3b1mPm3hqhq6E0IDHMzO
	LYcS9+HMz41nk1uQYolE7as/5DlEM9WpAfIGcLCQBELh0LydFTAczTxNIGA==
X-Received: by 2002:a05:6a00:1911:b0:874:705d:f649 with SMTP id d2e1a72fcca58-8a9bf90a9a8mr16161273b3a.43.1793895839850;
        Thu, 05 Nov 2026 08:23:59 -0800 (PST)
Received: from localhost ([153.61.198.248])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b097fe12f6sm2215796b3a.4.2026.11.05.08.23.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 08:23:59 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Thu, 05 Nov 2026 16:23:58 +0000
Message-Id: <DMNF03AQLNXY.27PRD8XBEYX77@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Will Deacon" <will@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Waiman
 Long" <longman@redhat.com>, "Suren Baghdasaryan" <surenb@google.com>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Yonghong Song" <yonghong.song@linux.dev>,
 "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Martin KaFai Lau"
 <martin.lau@linux.dev>, "Song Liu" <song@kernel.org>, "Jiri Olsa"
 <jolsa@kernel.org>, "Emil Tsalapatis" <emil@etsalapatis.com>, "Ihor
 Solodrai" <ihor.solodrai@linux.dev>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <bpf@vger.kernel.org>
Subject: Re: [PATCH 4/5] mm: add and use mmap_read_lock[_killable]_nosteal()
 on contention
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
In-Reply-To: <3a77219e-39e5-4e98-8f88-6f90bccf69f0@kernel.org>
References: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org> <20261103-khugepaged-latency-fix-v1-4-a07ab16ac860@kernel.org> <3a77219e-39e5-4e98-8f88-6f90bccf69f0@kernel.org>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: th19hc5b9zr8n8pwj89qnufcuffo8ocm
X-Rspamd-Queue-Id: 63752180006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793895841-806182
X-HE-Meta: U2FsdGVkX1+Rb3j8G2dd6CYchlCcnHYierP4U393iAyzGzi2VIiKPXMrhOw3+fJan7wiHBsAh064jZ5qUpUDlDAUzPhG7vy03ea71zjTmm974ZS2X+uddK6w8BCBa/hHTBSkY0k5SeLOh6SMIx8Jbc7DVeSxPRuAM9rTRiMhRfNzmE9d4YfZob6GR7Lvx03YzpB3eG2LqGpNk3zJhj7JDq8VGRR659w0GI8CesPMf0pBtevETpi16hJ3q3Yk5WyUq3AbnfEAbeXcH6cSVBEn6UmrRz1DEFMbb6F4GqFCqMNT+zqAYdrC1oqz+lEFpUQiMvGVZqWmZw7PXF21/Gl+casTWSU5IAlT8uhqdIYdQrrJSAPX+zgKGsOUhQvKGvNjsAfs/qP71oMpGpXBFX/BMjtK0o8HSGoGdOODZDaRJ4cXitg0wvDMbvu5U5/sL8lKo7CP+/q9gYOvwp00NAk5UQ/6Fv63MJtnAfwUEnsXqvyOAPw/ev2W1mirS7zRR8nO7EV6k2x/nhki2EhYY3U1SThJouPu5/Yqz8vvI/xi719GlDntSwfhSVZCxGo1umFMKkm5eVMM1hbVRlJVJO3YfN8ABsoLkoJOobeXLkI5shbx5Txqdk7+8DG7snYXIRuARRxxNvjPo3Wklh0M1POBDI5S0CJ5FzRQs/AkYG0QQcz06vheP4d8yhTgYDkNU0kKyYuMITK+0SEBP/uOZ8IxolaLZcO3SH9cOFvyjjhaL3w8Z4wEzr1MRL9uH2CHzq/chihzqRIbQLYQ1WpB4OP25rQEgEFW+DI0Pvy4uBk8UY+2B+mTNdYISteZ0/gjiXOGaQkdGVvnWb8tDdIj/OHuJj14QEsf7aWy0vv2MFks733mR8vj8RgRVk1x3Idjn+v2tpW906NFtPqUqX2wE1DzuzDlYSr+1kk1HjBE+ZUjafwvB5/b0W09W2yE23wNyLcQIObttmsKv0VQiNhQ/i1
 6SB6FAUb
 rSRMtzoFLI7jTJazENgCPrIVpwrbvmtDUPqi57cQ1jVdG2W/mrgSAuCqEetmGJbEku1bSQnuzQ/mhxJA02diWq+PnvWIZlU39ENRj0u1x6jzeYd7SETJ61Mah0mKsKVqyNgB5jqs9V5HKoDEGNCpzzZYsRV3zQfzCr1OA5FUl9RMqqVIMFw35aVCLC0Pi5qCryX9tUg1EmsYpDRJPLpZ0uo+tzoTKUsmJzagZi1fDafgxMaYteFPe38aoS+jSzQf8UcY7Pv3W2jcJLvTnjZ9ln12QockP+9QRtGhBfME4tPi5R4YqHkHF5ewL3CHOknQrzGwp0CM57a7K2TzOfM9k1+4pQQJjMi1D9tOvviDRrjk8YkhsqfMav4yHdQIIsugV4shqLVNPdMIKckZLf7ZnofFYKQz0vcluG4C3io0B/oXFvbcalnFk6Nvg8cNSH5tHbpKZl8W5ZL9QEeKkIdS/BmHAfZjibUG0kRTHTHGpGR/jF/JkSb02a2nbXVcahKvxSqERYdiHgU4c3MwKZQ7jP995ObR3Swfit9lFEFUArlN7qCa5Euz550WVWZk8fxLvcJVMsl30Mt6egRe3+zN6fFE26g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 02:16 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
> On 11/3/26 09:27, Lorenzo Stoakes (ARM) wrote:
>> With down_read[_killable]_nosteal() available, it becomes possible to
>> release the mmap read lock in such a way that a queued write lock always
>> takes precedence.
>>
>> Expose this to mm through two new wrappers - mmap_read_lock_nosteal() and
>> mmap_read_lock_killable_nosteal().
>>
>> Make use of this in scenarios where the mmap read lock is dropped
>> explicitly for the purposes of relieving mmap_lock contention - the BPF
>> task VMA iterator, and lock_next_vma_under_mmap_lock(), which is where
>> /proc/$pid/smaps_rollup re-acquires the mmap lock after dropping it on
>> contention and falling back from per-VMA locking.
>>
>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> ---
>>  include/linux/mmap_lock.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
>>  kernel/bpf/task_iter.c    |  2 +-
>
>
> I'd appreciate an ack from BPF folks and a confirmation that I could take this
> through my tree :)

Sure. Pls take it through your tree.
No conflicts with bpf and bpf-next.

Acked-by: Alexei Starovoitov <ast@kernel.org>

