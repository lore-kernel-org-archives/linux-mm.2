Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64E1D606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 05:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jPl6cncC
Received: by kanga.kvack.org (Postfix)
	id 492FA6B065E; Fri, 13 Nov 2026 00:01:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B8C6B0662; Fri, 13 Nov 2026 00:01:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 332B96B0665; Fri, 13 Nov 2026 00:01:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C9856B065E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:01:50 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E1F140829
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:01:49 +0000 (UTC)
X-FDA: 85428898338.11.6DD1809
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9C7BFC0008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:01:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jPl6cncC;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794546107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9AW9CjsrWOUjN/UAvPMW3aqbxmgaglM7A1wQ9TO+c4w=;
	b=l97Kuy5FH+HZNfgBtKpuXlvHuKpXSY0EAUtmiFkE6w+NOu+miu70CENMpbRBQDHc1GdOiA
	SYk6MGcMXJmkVYmy5HZpHXzq+C/WHkqlG1AHQ5tIR23JmVdyw7yYdonWlmHsFS7NQ3y/Y2
	DgLu6/GasO67rH6YvdHJdtMmHzO9ZTo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jPl6cncC;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794546107;
	b=dhRU8KHBDBIUUzcQgTQ61tzIrCOLVWGsNz4VLhGXoJvr3WSF8zvcWJ3fPnvr2CYlu5vU2S
	t54GQ01OSXLfVay7gpbnbjDf4Gw1UvSGMjeqMvOrAOT0hYqemJFHSSFwk/vu9I3gd5GIvw
	sKbvFLJdcfnUu8JatswlYhb09i9h6VI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C255A45A40
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831301F000CC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794546106;
	bh=9AW9CjsrWOUjN/UAvPMW3aqbxmgaglM7A1wQ9TO+c4w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jPl6cncCx4PXs8iU+t7ZVtchhZkYOtmMuTjAD+cAubn9jIf2CF3giYVgp8+H2N3z1
	 Fli14Cp4kTr5cA2XRNs25VeNNisaEsbSBjiDY9EgA0BAIQ+20AksXrQT0qhTiS3LK6
	 moG8hP5OCl32TUDVHp4P0N6SAIhb1zJXq8HyM3mINwukfQzuQJQPATqeBsZUAkPRv8
	 ZUSjKMgrg27trBFQ8/sKK1kDbTOATfT/+7tLzNbP3mK1G2EEg6+acJqB832r0L3Eoo
	 YticRoSc5dgIYp1Pff3CD+Qom5ik5mQ1APsCCm2vt2Gl9q4ltUWNgkTS04w/TAAx9L
	 tvewe9MBFaLpA==
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91f1324a134so8785266d6.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:01:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEnIPLdPpUys/8Yw11NrCCxf6E7ctmOKV3AxrbqCNDcHK7+b22Q5qYwfWi0iwMbyl4GrxVhqdE9Ow==@kvack.org
X-Gm-Message-State: APuU4Z/Nh/Jfgp+IBy9K0jJ2gUuZzJMr0w4vhRQT1C0WsHeloaU5tFTk
	cLwXoivE0Hk4xHduST5RkIiYPjn3CfQrwdBW+WJpT/Z5wmD2XfgDvQvvU2z/AvwJfWxwvrhK5UD
	lD2kxFwcuCkcKnjRZss8CHFck+fZ0L+M=
X-Received: by 2002:a05:620a:2903:b0:944:1f6b:37e1 with SMTP id
 af79cd13be357-9494bad0b65mr255979885a.33.1794546105743; Thu, 12 Nov 2026
 21:01:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <b2386c5da61f9a15e60daa421b033bc1e0bcdd41.1794481498.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <b2386c5da61f9a15e60daa421b033bc1e0bcdd41.1794481498.git.baolin.wang@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 13 Nov 2026 13:01:34 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y82CKoLx=HC8zUpHz+qwT8sNHjqT0bbrfLuCRYrWR1iQ@mail.gmail.com>
X-Gm-Features: AclHuK8HdvCcqCC5av5V-jbmYvBsxzAXNNzsR_76rBkzpQcdIzOCeoFv-Xbo6SY
Message-ID: <CAGsJ_4y82CKoLx=HC8zUpHz+qwT8sNHjqT0bbrfLuCRYrWR1iQ@mail.gmail.com>
Subject: Re: [PATCH] mm: mglru: use pte_table_clamped_end() helper to
 calculate the end
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, hannes@cmpxchg.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, mhocko@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hnn1zhbymp9pfj9xu3eqqi1ep4p7hr9b
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9C7BFC0008
X-HE-Tag: 1794546107-489274
X-HE-Meta: U2FsdGVkX1+agYYjsOvNepIl8+udyC5zk9awxsJJR0nhZ4SsystlxZ9rWy/jWBQmBrQwq0lyIea5oHK6Z/L1y6rhQBfxLi8f4dRX/pSiRLEDnUy60Vk+o9GYV2BrvXUrpqbNAhDLAdpogB2m/RwaeOEgFpkURa/Q+LDk4IftJwej5T1BBH5lSRlEfbul6/f75GhYI93QZtQYvamtK2jfDPOgOd0AfMHdwlx3gOrAAZFk3FlTAdm2ZQylNvHt9GlWPM4EclRBARov7mesPszXtnSwXexP8rd7rbEKwdXpavHsLI54Qs3K3vwADhfAB2zfG0LqPVZ3tFdxoSaG/4OIfi3PhiVpIJApMbJQT1e63axtXKERVO9kpysO6cuQsZHOve7FAVGjzy19RrTz+AD0M7lCx4/AifOPxc2e1WqwXdZYc+1Z2pnZYNrJJqihoMTGPpiAiZ3PulVUqFdxeV1Ywxb8qIJxzInaozlWoiLXuKYNkXJFPT+HIA75zt+vXBVzuR3A500KtBSE4cflP/lZ2AQ5NJVTiXQ0eftFsiqvD5KJVIkIkaaRTeAxYngURmtYhKLQAahqEqm2GS8Ne85LgE3l36ygJBOe6fFPEBSUIrpXW2nMCU5yctmAsjD+B7wAOs/uhvopLyb3q90MaZC+7JJZEtwYxzKnuwEprsc0zIZTlSq+966uwjC/s5VIloLNsoT+46350nSkAvHkW2+eHE8qmIBVUNWGoKBvs5bQFsUeNF9m/NsufWB+LCctUhGMj+Tl6BhpZTGMoKbdHdawwcWVUHZYnvJCeOSFNu+rsNAh3HqYPcHi6n5KRsIuI+l4ryNks/qPIO56zLzAb45jk1bcjNliCLOLnNgomZV1UJWHjM6+TY0pl2SkrvYAPFFPWEEyoEzIFFnj0e9oTjm+I7ZhgKJrf/fYcWcKLLgVFNSfxAq+WdBJ2eao/BPGm2hR4JQOVP+2Dkb8MyXM6i+
 CyQ9Soj8
 jef6HUKnTNQHhyTvNZ+CQK42jry3FaHLBc7EeT2bvZCWIBSrNzKZujOpSO5AJee/9WRmfohZfaWyeqOER5Qlp2eiJDdLGMFnE6JryjchETRRpDzH7iirgoAYi/F8WpS9zQJcxgHzz7sBwgE2iVbNQ4HsCVQuIEZk1joY7HsYQTd8Ko+opnsGFxrVXCWmrA5OcdfNag3t3/uDR50i3MrIEqqwMCdm51JyPun1s9I8NQgE+oJfydngYUKhOFAVWF0WNrNN323iPm3g+dXHsqj4mZvIQqjX5NIfj1Mh4jqh+ypCwMV2bdQWT5pom3r52jYnqUREq8ffD7r5xxv79UyO1oGU0g/jVpnjI7KsLx0T+rk6BOD8HpuSUjF8MpaY4voI57whu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 7:13=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Use pte_table_clamped_end() to clamp the range to the PTE table and VMA
> boundaries when batch-checking young flags, making the code more readable=
.
>
> No functional changes intended.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Based on mm/core.git for-next branch.
>
> Note that this was found while reviewing David's series:
> https://lore.kernel.org/all/c31cc8a0-c098-4784-a843-f13f51914094@linux.al=
ibaba.com/
> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 5495d9be90e8..804d4188e7b4 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4470,7 +4470,7 @@ bool lru_gen_look_around(struct page_vma_mapped_wal=
k *pvmw, unsigned int nr)
>         walk =3D current->reclaim_state ? current->reclaim_state->mm_walk=
 : NULL;
>
>         start =3D max(addr & PMD_MASK, vma->vm_start);
> -       end =3D min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
> +       end =3D pte_table_clamped_end(addr, vma->vm_end);


We don't have pte_table_clamped_end() in Andrew's tree yet;
it's part of David's patch:

https://lore.kernel.org/all/20261111-pte_table_clamped_end-v1-1-2dbe339c487=
a@kernel.org/

So we're not going through Andrew's tree for this patch, right?

>
>         if (end - start =3D=3D PAGE_SIZE)
>                 return true;
> --
> 2.47.3
>

Thanks,
Barry

