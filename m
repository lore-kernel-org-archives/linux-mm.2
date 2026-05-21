Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45BB8CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 04:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B24B6B00A9; Thu, 21 May 2026 00:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83B7A6B00AA; Thu, 21 May 2026 00:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DBBC6B00AC; Thu, 21 May 2026 00:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 551F46B00A9
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:19:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DED45404BE
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:19:34 +0000 (UTC)
X-FDA: 84790123068.09.A6C5D47
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id E8CA2100009
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:19:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b=l6SPr+9x;
	spf=pass (imf14.hostedemail.com: domain of emil@etsalapatis.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=emil@etsalapatis.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779337173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Et0bGEjjWdmJXg1QKS6BT27sCw0OJSCkjTf2JeHVHR8=;
	b=e5t85NUSTklWfaqehhsnARzTM0+ccRtHfJUOCIn6QlfZzbnxh5fo9b6yxCAwf+MCJtjiTG
	4ftD3WOABcdEOmw2sIEubKXXjUHdHw4DvvI+noUbCyzaOue71pBXM6KXzz0SG/vJ6JLNb0
	MGpI+HFS736sQyWypxjojuEw6/ip6Fg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b=l6SPr+9x;
	spf=pass (imf14.hostedemail.com: domain of emil@etsalapatis.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=emil@etsalapatis.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779337173; a=rsa-sha256;
	cv=none;
	b=riXKlW/x1ARNcaCwqpiY4omyu7ahvYzCZm6VoCI8t16FbCus+LEbsRLQTi93l7DE2SQEpt
	mLrbHxuKbyfC5W9BcXFF+VlBa3btoitjjqG6ko9KBlwMeBnt+dJiOCUic+K3fb1+lUltGX
	hM4cFss79hcy1gaORsd2j70ESM/a5G8=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2b788a98557so34150905ad.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 21:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis-com.20251104.gappssmtp.com; s=20251104; t=1779337172; x=1779941972; darn=kvack.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Et0bGEjjWdmJXg1QKS6BT27sCw0OJSCkjTf2JeHVHR8=;
        b=l6SPr+9x2u3JZYCm3THXJ4B1kIU3v0afnop3J2SHdmBIVl9y6h0ORzbfiRzAHRi44/
         NYxBbf1z+PCWyUw7i6ZjN2NW4ImbtO8S9m0j20Fel0qNV5b0kns4qP28AKk5eSgXuobc
         ncgMUqmcypjFTjb7YeS/NW43rwAzQFVb2hrCV6AU0HbX4eJCaDFr6iZhr8ocr4DKcxXr
         O5/7cCLf1W8svR7JFHMWgpEbgONI/v3pLG8FpDwUD63T0CzdZ62Ml2DexS3jkCcaD4ru
         aiIvXFBC4fE/ySlXz+2kJ1T4wBogRujF8HYtmVTMzdPY9PXlmPWLAipqPDfJQcTjYlQH
         SraA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779337172; x=1779941972;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Et0bGEjjWdmJXg1QKS6BT27sCw0OJSCkjTf2JeHVHR8=;
        b=HsSRhSYq5oZopEdHo4oDUqmNosZEbsB23CKzQ10Ywvh778C2cbWslmJ4L7DMhqa5lL
         Bxls3njZygM9SMNOLPMPZPYFUfky3LZPsGX5hDnnSyou/qnXU1IxFX1DsI6av49rvL0B
         w9JNr1Q3eEqP6TokTm/VovRjMmD85NHIy9bXZCY0iGnJCuZAuuiIyP8Dn0JrNZtiTrfk
         58FbDvpuZIniNIEY5VjtUruRC5qnP/OPrwLKZtSWw68KP9Mi7rpbj7oXHuGhapDskMMF
         Ke9mukFzJRTJFzyf+DTuplwyT9GwzQW6bswLZKhN0EeVvbn0tAGQNeDTuJt7WpPQXIaY
         Xzbw==
X-Forwarded-Encrypted: i=1; AFNElJ+BqIDOQ/3VpfPFiiB8sC1TF8Ue6lczKLQJSZRWQtqrjQB7WMniio1jjbzBM9AE/YvBEszLLNbyeQ==@kvack.org
X-Gm-Message-State: AOJu0Ywu5l1Mfxg14NvMijPtbcAmRrOGIprQkRWSt4vIzKaAiNc2caCA
	8GY3fY21bL2UHKPSM9yyOSssi1w829vz0rvoDvx/+q31r1WFj9XkmCv4eIkSu8pX2uY=
X-Gm-Gg: Acq92OFO7gWenGO6MimYKdD+TYQQmdOmtHsterKOHKFq49s/IReMC5hcRGZeFzw4TX5
	+/otb5h7fppS32cJ/h/fRRkcP4VLkoW3UvKvrrGA/58wmBHobpPZW9jiHxaHPheOW7mWDD3evoI
	oqKNNv6IU/wNmQSmVrmPYIPq6jZt9Q6CZ6cURrasYxDS58vz2v2l4yaatar+YJiltkpZ78s3oRi
	MhodyJ8hGxCxdQoiDFUmn7qKjGwcrMizGmK+0zsR/i78wskTBUONeY8iKP7h6zasHpDRL5J4xBL
	Pk3NYsirIz6MlM6NK7v3WbAFOGYmNNXESUzozKHvvpATA73mQrvcYSgKnlKYuo/WfyAfSA56xbz
	DfMI5fdgk89gNTOcAfkDEnMrHpLDxmuVMCJsGpF2L9mrgekVqaLv4SYJekKrtlBTsynCfaNRQIs
	e8FrptUSBinhtnMXRBWO3r4JMt
X-Received: by 2002:a17:903:1b06:b0:2ba:5e44:ce8f with SMTP id d9443c01a7336-2bea2f89c83mr11555725ad.0.1779337171498;
        Wed, 20 May 2026 21:19:31 -0700 (PDT)
Received: from localhost ([2001:569:58a0:da00:a5c8:c4ce:f7c1:40c1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5c05fcb3sm243627525ad.26.2026.05.20.21.19.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 21:19:31 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 21 May 2026 00:19:30 -0400
Message-Id: <DIO2DVGYRBUN.1QPC47NPPWTZ9@etsalapatis.com>
Subject: Re: [PATCH 8/8] sched_ext: Convert ops.set_cmask() to
 arena-resident cmask
From: "Emil Tsalapatis" <emil@etsalapatis.com>
To: "Tejun Heo" <tj@kernel.org>, "David Vernet" <void@manifault.com>,
 "Andrea Righi" <arighi@nvidia.com>, "Changwoo Min" <changwoo@igalia.com>,
 "Alexei Starovoitov" <ast@kernel.org>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "Martin
 KaFai Lau" <martin.lau@linux.dev>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Catalin Marinas"
 <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Emil Tsalapatis"
 <emil@etsalapatis.com>, <sched-ext@lists.linux.dev>, <bpf@vger.kernel.org>,
 <x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260520235052.4180316-1-tj@kernel.org>
 <20260520235052.4180316-9-tj@kernel.org>
In-Reply-To: <20260520235052.4180316-9-tj@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E8CA2100009
X-Rspam-User: 
X-Stat-Signature: 7t43ccatj6i9npe9yqizrmabcz9w4jtn
X-HE-Tag: 1779337172-667126
X-HE-Meta: U2FsdGVkX1+aAv3Vw1OiH7+1BIJonP8Hh07e2fPDaTuvXU72t1SX4dlrrLY9nrKhdstS2QrhLsCt2OnwtkffnhvP+2B5cOy8lZX5B5McZwmI4akOf/aRrKviHLLHP7JKtMK1Qnx8niBnfoWCpK1fPIf1WFCIUaBfcWGfFPoSBNyE2e0QrVcc83lif/KuXXniiRu7W0oVdjxvppM2N58U9CiSXmRckgpLJ07CSW/ksX7Sg3oa+yEjRZ8A4ljCP5w37jkKmiuqxgGNLzofbvoJPypcTS9024vBjpbeA+ePvHcHwA6uypsDhm+jZHfn9OM5VAxHZltaOJYVST+9yQt988cxHLhS7QNJvvEyuDbrvZoV5aV+a/rrMmFAVvL+hmu9UslVJGi4pxjnWx1V6Q1l707v9L0WsPb91QCCNDJMMMhALP2Y4cwOQxYzfOO8Gz2KbuZfg07JY2RrZafblDJgK2+fNQZEZr8RneXyJ1HjM8Yao4mPb3qEp/p4w2zM14VFgvJUUPCemICHuv+Z7+xRuYUgjQnVQCAei1Cx+XU4eeuTaP6gdIPzmF97CiEsCz5Jd47EEt92uKeHDJoySZnoY4qGoQE6PMGM45t2FOCrDZLVKgcsiIv3G9wufUIMoyULRS8MmBLUygaseVxA14gOmALnqjqbRRdXH0JBlezK0gGi42tiS5KLk9ORJqrSH52Z+tltjpopJEplg/GnU7f6G5auISBLAcR5E3d4Kp+SVYEH0K4FcMDNIooHTVWsl1TdzuL3h601kbZHyn2L1NhieZJblJmqh4Ry9/qrFKrRrSGFFe64PTD6I+2Bb3RhhSAZlu7hy82kb4qMK37Iu/Deuwio3Z++cNzquuN/f670BIOHAk/aoAFU/n4gCvHziLjpIrhKijw8LyRkNXF0iQQwTlQgZhNWLfD7sjKNb6vL6Wql/dgpfUdKgt6TWxTa4Uj+1Sucg6dLLP/7eJfjKE0
 U4KWf3W6
 +A3rPRTeevZ90URvngoHwcFA7c5HYn0S0UeWhhQwqJwhHztINWpoiBW7tOma0S2kohqiHPLMdwGreQI/dSzheKTh1hKHmKlsg6RI3QhURhNBFijn/LT9wyi28l1lJKpw9pmVodFrJQnqa/qsd6tlHZZwpnFaAG/tuyJLQMqA4r4LiDz7RJPl4D8eFSgvRVpL9yJ9/bnA1342ObaOTymOUDiOyLg06O3NkYr5WkfJQppsG6nMK4MdwqR3rgPhLuPsNABW6oZW1+W1jZEd+j5yfWxNm1GgwANls/CDwJLGp2HDbC9V+KvghOKb7IrLtDe6ffcS/VfifCGFn/55rOWEawlWFnWZb/plsd5wqHQNwcYD6XsugMAd0cy2KK1daszNCyM6eO40TK32UUBo0/OW1X3xRLE7lMuTDsiaQi1fxixye53l1akwBsABaCDUO38jQWMfJiJxL8TD5rzUySx6qR5opKws7hyhqX4kw+0+rdmPcRhgM4pYS6fr2rSSVQctp9DPTIozgLfRPqfw3jf/1gzQlHl+6wIpp9CYV/cMUVwDmv4QWx/9et6Ji7rOCbyPXy2f230qS0EQiqRSUeezTrZWdfCgwA01eMCPtXnVLzSIkqPBKx4CO7PMBRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed May 20, 2026 at 7:50 PM EDT, Tejun Heo wrote:
> ops_cid.set_cmask() expects a cmask. The kernel couldn't write into the
> arena, so it translated cpumask -> cmask in kernel memory and passed the
> result as a trusted pointer. The BPF cmask helpers all operate on arena
> cmasks though, so the BPF side had to word-by-word probe-read the kernel
> cmask into an arena cmask via cmask_copy_from_kernel() before any helper
> could touch it. It works, but is clumsy.
>
> With direct kernel-side arena access now in place, build the cmask in the
> arena. The kernel writes to it through the kern_va side of the dual mappi=
ng;
> BPF directly dereferences it via an __arena pointer like any other arena
> struct.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>

> ---
>  kernel/sched/ext.c                    | 68 +++++++++++++++++++++++++--
>  kernel/sched/ext_cid.c                | 20 +-------
>  kernel/sched/ext_internal.h           | 10 +++-
>  tools/sched_ext/include/scx/cid.bpf.h | 52 --------------------
>  tools/sched_ext/scx_qmap.bpf.c        |  5 +-
>  5 files changed, 75 insertions(+), 80 deletions(-)
>
> diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
> index fb91079c1244..94562e3350c6 100644
> --- a/kernel/sched/ext.c
> +++ b/kernel/sched/ext.c
> @@ -621,11 +621,16 @@ static inline void scx_call_op_set_cpumask(struct s=
cx_sched *sch, struct rq *rq,
>  		update_locked_rq(rq);
> =20
>  	if (scx_is_cid_type()) {
> -		struct scx_cmask *cmask =3D this_cpu_ptr(scx_set_cmask_scratch);
> -
> -		lockdep_assert_irqs_disabled();
> -		scx_cpumask_to_cmask(cpumask, cmask);
> -		sch->ops_cid.set_cmask(task, cmask);
> +		struct scx_cmask *kern_va =3D *this_cpu_ptr(sch->set_cmask_scratch);
> +		unsigned long uaddr =3D (unsigned long)kern_va -
> +			bpf_arena_map_kern_vm_start(sch->arena_map);
> +		/*
> +		 * Build the per-CPU arena cmask and hand BPF the uaddr. Caller
> +		 * holds the rq lock with IRQs disabled, which makes us the sole
> +		 * user of the scratch area.
> +		 */
> +		scx_cpumask_to_cmask(cpumask, kern_va);
> +		sch->ops_cid.set_cmask(task, (struct scx_cmask *)uaddr);
>  	} else {
>  		sch->ops.set_cpumask(task, cpumask);
>  	}
> @@ -4949,6 +4954,48 @@ static const struct attribute_group scx_global_att=
r_group =3D {
>  static void free_pnode(struct scx_sched_pnode *pnode);
>  static void free_exit_info(struct scx_exit_info *ei);
> =20
> +static s32 scx_set_cmask_scratch_alloc(struct scx_sched *sch)
> +{
> +	size_t size =3D struct_size_t(struct scx_cmask, bits,
> +				    SCX_CMASK_NR_WORDS(num_possible_cpus()));
> +	int cpu;
> +
> +	if (!sch->is_cid_type || !sch->arena_pool)
> +		return 0;
> +
> +	sch->set_cmask_scratch =3D alloc_percpu(struct scx_cmask *);
> +	if (!sch->set_cmask_scratch)
> +		return -ENOMEM;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct scx_cmask **slot =3D per_cpu_ptr(sch->set_cmask_scratch, cpu);
> +
> +		*slot =3D scx_arena_alloc(sch, size);
> +		if (!*slot)
> +			return -ENOMEM;
> +		scx_cmask_init(*slot, 0, num_possible_cpus());
> +	}
> +	return 0;
> +}
> +
> +static void scx_set_cmask_scratch_free(struct scx_sched *sch)
> +{
> +	size_t size =3D struct_size_t(struct scx_cmask, bits,
> +				    SCX_CMASK_NR_WORDS(num_possible_cpus()));
> +	int cpu;
> +
> +	if (!sch->set_cmask_scratch)
> +		return;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct scx_cmask **slot =3D per_cpu_ptr(sch->set_cmask_scratch, cpu);
> +
> +		scx_arena_free(sch, *slot, size);
> +	}
> +	free_percpu(sch->set_cmask_scratch);
> +	sch->set_cmask_scratch =3D NULL;
> +}
> +
>  static void scx_sched_free_rcu_work(struct work_struct *work)
>  {
>  	struct rcu_work *rcu_work =3D to_rcu_work(work);
> @@ -5003,6 +5050,7 @@ static void scx_sched_free_rcu_work(struct work_str=
uct *work)
> =20
>  	rhashtable_free_and_destroy(&sch->dsq_hash, NULL, NULL);
>  	free_exit_info(sch->exit_info);
> +	scx_set_cmask_scratch_free(sch);
>  	scx_arena_pool_destroy(sch);
>  	if (sch->arena_map)
>  		bpf_map_put(sch->arena_map);
> @@ -7162,6 +7210,12 @@ static void scx_root_enable_workfn(struct kthread_=
work *work)
>  		goto err_disable;
>  	}
> =20
> +	ret =3D scx_set_cmask_scratch_alloc(sch);
> +	if (ret) {
> +		cpus_read_unlock();
> +		goto err_disable;
> +	}
> +
>  	for (i =3D SCX_OPI_CPU_HOTPLUG_BEGIN; i < SCX_OPI_CPU_HOTPLUG_END; i++)
>  		if (((void (**)(void))ops)[i])
>  			set_bit(i, sch->has_op);
> @@ -7484,6 +7538,10 @@ static void scx_sub_enable_workfn(struct kthread_w=
ork *work)
>  	if (ret)
>  		goto err_disable;
> =20
> +	ret =3D scx_set_cmask_scratch_alloc(sch);
> +	if (ret)
> +		goto err_disable;
> +
>  	if (validate_ops(sch, ops))
>  		goto err_disable;
> =20
> diff --git a/kernel/sched/ext_cid.c b/kernel/sched/ext_cid.c
> index 0c91b951fd33..808c6390da5a 100644
> --- a/kernel/sched/ext_cid.c
> +++ b/kernel/sched/ext_cid.c
> @@ -7,14 +7,6 @@
>   */
>  #include <linux/cacheinfo.h>
> =20
> -/*
> - * Per-cpu scratch cmask used by scx_call_op_set_cpumask() to synthesize=
 a
> - * cmask from a cpumask. Allocated alongside the cid arrays on first ena=
ble
> - * and never freed. Sized to the full cid space. Caller holds rq lock so
> - * this_cpu_ptr is safe.
> - */
> -struct scx_cmask __percpu *scx_set_cmask_scratch;
> -
>  /*
>   * cid tables.
>   *
> @@ -54,8 +46,6 @@ static s32 scx_cid_arrays_alloc(void)
>  	u32 npossible =3D num_possible_cpus();
>  	s16 *cid_to_cpu, *cpu_to_cid;
>  	struct scx_cid_topo *cid_topo;
> -	struct scx_cmask __percpu *set_cmask_scratch;
> -	s32 cpu;
> =20
>  	if (scx_cid_to_cpu_tbl)
>  		return 0;
> @@ -63,25 +53,17 @@ static s32 scx_cid_arrays_alloc(void)
>  	cid_to_cpu =3D kzalloc_objs(*scx_cid_to_cpu_tbl, npossible, GFP_KERNEL)=
;
>  	cpu_to_cid =3D kzalloc_objs(*scx_cpu_to_cid_tbl, nr_cpu_ids, GFP_KERNEL=
);
>  	cid_topo =3D kmalloc_objs(*scx_cid_topo, npossible, GFP_KERNEL);
> -	set_cmask_scratch =3D __alloc_percpu(struct_size(set_cmask_scratch, bit=
s,
> -						       SCX_CMASK_NR_WORDS(npossible)),
> -					   sizeof(u64));
> =20
> -	if (!cid_to_cpu || !cpu_to_cid || !cid_topo || !set_cmask_scratch) {
> +	if (!cid_to_cpu || !cpu_to_cid || !cid_topo) {
>  		kfree(cid_to_cpu);
>  		kfree(cpu_to_cid);
>  		kfree(cid_topo);
> -		free_percpu(set_cmask_scratch);
>  		return -ENOMEM;
>  	}
> =20
>  	WRITE_ONCE(scx_cid_to_cpu_tbl, cid_to_cpu);
>  	WRITE_ONCE(scx_cpu_to_cid_tbl, cpu_to_cid);
>  	WRITE_ONCE(scx_cid_topo, cid_topo);
> -	for_each_possible_cpu(cpu)
> -		scx_cmask_init(per_cpu_ptr(set_cmask_scratch, cpu),
> -			       0, npossible);
> -	WRITE_ONCE(scx_set_cmask_scratch, set_cmask_scratch);
>  	return 0;
>  }
> =20
> diff --git a/kernel/sched/ext_internal.h b/kernel/sched/ext_internal.h
> index ff7e882bd67a..9bb65367f510 100644
> --- a/kernel/sched/ext_internal.h
> +++ b/kernel/sched/ext_internal.h
> @@ -1124,6 +1124,14 @@ struct scx_sched {
>  	struct bpf_map		*arena_map;
>  	struct gen_pool		*arena_pool;
> =20
> +	/*
> +	 * Per-CPU arena cmask used by scx_call_op_set_cpumask() to hand a cmas=
k
> +	 * to ops_cid.set_cmask(). The kernel writes through the stored kern_va=
;
> +	 * the BPF-arena uaddr handed to BPF is recovered by subtracting the
> +	 * arena's kern_vm_start.
> +	 */
> +	struct scx_cmask * __percpu *set_cmask_scratch;
> +
>  	DECLARE_BITMAP(has_op, SCX_OPI_END);
> =20
>  	/*
> @@ -1480,8 +1488,6 @@ enum scx_ops_state {
>  extern struct scx_sched __rcu *scx_root;
>  DECLARE_PER_CPU(struct rq *, scx_locked_rq_state);
> =20
> -extern struct scx_cmask __percpu *scx_set_cmask_scratch;
> -
>  /*
>   * True when the currently loaded scheduler hierarchy is cid-form. All s=
cheds
>   * in a hierarchy share one form, so this single key tells callsites whi=
ch
> diff --git a/tools/sched_ext/include/scx/cid.bpf.h b/tools/sched_ext/incl=
ude/scx/cid.bpf.h
> index e281c88fa824..70f2a3829af4 100644
> --- a/tools/sched_ext/include/scx/cid.bpf.h
> +++ b/tools/sched_ext/include/scx/cid.bpf.h
> @@ -675,56 +675,4 @@ static __always_inline void cmask_from_cpumask(struc=
t scx_cmask __arena *m,
>  	}
>  }
> =20
> -/**
> - * cmask_copy_from_kernel - probe-read a kernel cmask into an arena cmas=
k
> - * @dst: arena cmask to fill; must have @dst->base =3D=3D 0 and be sized=
 for @src.
> - * @src: kernel-memory cmask (e.g. ops.set_cmask() arg); @src->base must=
 be 0.
> - *
> - * Word-for-word copy; @src and @dst must share base 0 alignment. Trigge=
rs
> - * scx_bpf_error() on probe failure or precondition violation.
> - */
> -static __always_inline void cmask_copy_from_kernel(struct scx_cmask __ar=
ena *dst,
> -						   const struct scx_cmask *src)
> -{
> -	u32 base =3D 0, nr_cids =3D 0, nr_words, wi;
> -
> -	if (dst->base !=3D 0) {
> -		scx_bpf_error("cmask_copy_from_kernel requires dst->base =3D=3D 0");
> -		return;
> -	}
> -
> -	if (bpf_probe_read_kernel(&base, sizeof(base), &src->base)) {
> -		scx_bpf_error("probe-read cmask->base failed");
> -		return;
> -	}
> -	if (base !=3D 0) {
> -		scx_bpf_error("cmask_copy_from_kernel requires src->base =3D=3D 0");
> -		return;
> -	}
> -
> -	if (bpf_probe_read_kernel(&nr_cids, sizeof(nr_cids), &src->nr_cids)) {
> -		scx_bpf_error("probe-read cmask->nr_cids failed");
> -		return;
> -	}
> -
> -	if (nr_cids > dst->nr_cids) {
> -		scx_bpf_error("src cmask nr_cids=3D%u exceeds dst nr_cids=3D%u",
> -			      nr_cids, dst->nr_cids);
> -		return;
> -	}
> -
> -	nr_words =3D CMASK_NR_WORDS(nr_cids);
> -	cmask_zero(dst);
> -	bpf_for(wi, 0, CMASK_MAX_WORDS) {
> -		u64 word =3D 0;
> -		if (wi >=3D nr_words)
> -			break;
> -		if (bpf_probe_read_kernel(&word, sizeof(u64), &src->bits[wi])) {
> -			scx_bpf_error("probe-read cmask->bits[%u] failed", wi);
> -			return;
> -		}
> -		dst->bits[wi] =3D word;
> -	}
> -}
> -
>  #endif /* __SCX_CID_BPF_H */
> diff --git a/tools/sched_ext/scx_qmap.bpf.c b/tools/sched_ext/scx_qmap.bp=
f.c
> index 7e77f22674ea..8a2d6a8ebd8e 100644
> --- a/tools/sched_ext/scx_qmap.bpf.c
> +++ b/tools/sched_ext/scx_qmap.bpf.c
> @@ -919,14 +919,15 @@ void BPF_STRUCT_OPS(qmap_update_idle, s32 cid, bool=
 idle)
>  }
> =20
>  void BPF_STRUCT_OPS(qmap_set_cmask, struct task_struct *p,
> -		    const struct scx_cmask *cmask)
> +		    const struct scx_cmask *cmask_in)
>  {
> +	struct scx_cmask __arena *cmask =3D (struct scx_cmask __arena *)(long)c=
mask_in;
>  	task_ctx_t *taskc;
> =20
>  	taskc =3D lookup_task_ctx(p);
>  	if (!taskc)
>  		return;
> -	cmask_copy_from_kernel(&taskc->cpus_allowed, cmask);
> +	cmask_copy(&taskc->cpus_allowed, cmask);
>  }
> =20
>  struct monitor_timer {


