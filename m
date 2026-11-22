Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB519606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 03:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=O01che8b
Received: by kanga.kvack.org (Postfix)
	id 8C2A26B05B1; Sat, 21 Nov 2026 22:47:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0616B05B2; Sat, 21 Nov 2026 22:47:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B4386B05B3; Sat, 21 Nov 2026 22:47:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 520BE6B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:47:16 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 576E6120640
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:47:15 +0000 (UTC)
X-FDA: 85461369630.15.FEF914D
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 49B89100002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:47:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=O01che8b;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795319232;
	b=3hbvqT1gIZtAkVSNU72xU3D57OgXsKgiOF1hN+XqYzQtKP/uJe5KJk8qvHR9hqmYfQSoWa
	pTE2KVljyn4vINNHsVZecc+K+muD46edqDnQcxk+na8sBd/MeGz0rnPnE+Tvqc0sfdM2Fb
	FoeJKKHcpKFRdygK0GWWRyF6kIC4SQk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795319232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSIBbpZulKz0qZ/96WfJSlY3MPGSVqJv3vdaPI2YYro=;
	b=U5SUk4jpy3lwvQkJ53dJR+QBuYL/KU/nKQXbxUcTPd6AKgak65UDK4VznX9cR1RrAIw6g6
	TaSTLjJKDEmdDiLX1gCIpqxoMUofGJAtiiOuUolxT2LKyGNdU9bXIN17mTC4odKNIR1877
	06bWH1Hyj9XkDNjumSRKfwbzGkLQ9OQ=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=O01che8b;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-533202fe429so207271cf.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:47:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795319231; cv=none;
        d=google.com; s=arc-20260327;
        b=W4daAnrMNU6wRlzJB6EhZMNBRciOW396KqmMNvWaUQuAYqzipNagqNqgiFmruvHeWj
         C7P4nR7GPT362X1KO3g9d3IG2laFCpBxGYMNhiZpnUDfyZaZU139Z3HKnvU7bXkq6mAs
         LhIetPJstraE8xwqoSsgETxZzldx7zcNRMccf/Pm2THTmi00TJlg9JVk+c06mWB0sA0v
         +YhlQKpl57XRUXHLAWLyp7O9xj3yhQjuuFFgpmf6IOlJM7yRhp6esb2HM6v7Fj9VNpzB
         U0zK/7G2JL0gczGPPK5b+ccQXgWDe3+WdlU97kHU+gbuKsX2zEFXnK2GomJ61c+WAguc
         4/zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WSIBbpZulKz0qZ/96WfJSlY3MPGSVqJv3vdaPI2YYro=;
        fh=TG1zsfifY//iTHaGUyuwxwe1GcqJ+HPI7etHqqJrnnw=;
        b=PJxJ5zp2URM7hWcKFVIzYS2c6ZRmttOwTLanYvGrQh0jXTANTGm2tbZ3lx7XuRc5qT
         sYt6lHl8xqgM7kUcwxb814OxPREntC7MVp/5psks85gwk3tl2nXohxh509xaPG/PABIj
         Hrxx+4sNT4z5fGk/3AxTHlbAvOaHC5aaUgrg6PyNMPZpvew72FFuFaXCcChgB5hgxRUT
         hVRbIqmuCOJjeUkSRxxUPQ4dZx4qn8sYYGdwX8/rrjJ8twEh+9182D13OTfaRamegGbF
         XanYZLjj4I4VVbpyuZ9CvhrgJzvzWeIm/qTOOj9dt0dIhYODfsm2PiXq9UFzW6uXREsB
         ilsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795319231; x=1795924031; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WSIBbpZulKz0qZ/96WfJSlY3MPGSVqJv3vdaPI2YYro=;
        b=O01che8bVQUqmiAXLR/3z7LFYw8HOhxMyul7N09/beo9IOcKRjyahDaApJDci798iU
         6YHnd4LFHmTO4HanbSFCGpEvuLywWIid4TYxjgAW87eZBIealnjQOwYSLepvSHIMDJPY
         LqaXTV5MotJRcCBs/IGzEOuF9CF8VZgTWs0AAD/yrbZvOGbFkjxvDxmPoEcYvdyDSlFk
         WSf3s9aGIHZsqSZkdZjsIZEcf8nARjhR9cFwW9cMeTxxzsOYQuWI4Dfb48nSi1dU60T0
         c1c0+Zi9AsB+9+eWx9f9wJKYLJeu0aYN4HTEFW7MN9MLkaClF/uo+T+UQhbLgvUd79ME
         cj+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795319231; x=1795924031;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WSIBbpZulKz0qZ/96WfJSlY3MPGSVqJv3vdaPI2YYro=;
        b=Osop19eSPuqOUk67haBMca8IoLc2BxFIYOOrol4dispVmDmiYgZYJ7lS2SA6+jynVs
         6P5wZQUarvP+cxZMOgKfEwEfPd17M50P45jXroI1mkRWHxfVYP7w0FyMsmmQk0SvVPBG
         2CGpd+5aMlFFVj1PHYji90aTn5Oa/WoXo6ne3BGV+LCHJB9WQvXwZzt+j/fmaf6xcldZ
         BvXjBWCzHbVfumPib4SRrv9yxSHw88/UdCPjOpC5Si6K+zoGy7macvDU3y611FHHG1t7
         pSixwMi2unHNZ10KFgx2eRcEkI4s57F9JdeuFdYSK1m+oz5uz5jgyCS83LaZ4EhqEYgS
         G7TA==
X-Forwarded-Encrypted: i=1; AL+hErEmP0nX4xFbVqitd+M+YSVzTHeZgMBfO17ZRa6CGR/MrpSOwVoNuLwJAZH0P5DLUHSOsqqdZVhmfw==@kvack.org
X-Gm-Message-State: APuU4Z+shi08ieMpQzU4pnN2ebToFhycaRFNypbO1cAA2wZsdO+jp+e0
	Zqk1K7MOvOKwDdfHsj5KVThR1pv77W4SnJwwXz9qMYNvorOZnIpALR3i3PHE1wkw4zendk1D+gv
	T3zlyu4nIw/Ax2LETZPqiwlke92PJXKafnimwqhUeyizyMUluuas2j4OIQts=
X-Gm-Gg: AZFdTZdFpuIahWFUoXQuo0an17dSm5xqsxJv6gNRt/9VK5Ub711jEfgZdbIS5p5jfNT
	urIiUjaMC1jYSopCssbsJPOj8HbOt1va+E0HaeLtTA6Mh1UKgXXKt+R9K/1k6wYxX1N1oHuQ1nm
	LtFPekm/0LQauZr/sjWfnX0X0vUh7jR7ioqU0WELq7KE2qB+I2sKDhZm63rAhZhN5ecpZKfZ7dj
	SJ+aqR5jJqmGlaUAhDURLefHTJl9tPns8+YqOD6mWX3D+bO6nKEaa/nLz1jVaNxkmRq8MDAH6YA
	KlkIPpe+725ToehjiO9JnCCXrSvzvu073evS+r4hRnSnpOBEQ19UcimFFCB8NeHwlUOdH1evhzv
	MRWhqNRbsbZ8WjYWZ1z8sKkJjUwWbvQdhRnRTnMzpGiG4My3vdXn0eXVcPgupC0ZAjK5RJlcgN4
	aVaGTwAi3QGXZfStPD
X-Received: by 2002:a05:622a:5793:b0:546:92f2:7830 with SMTP id
 d75a77b69052e-55d881afcdamr18746941cf.6.1795319230781; Sat, 21 Nov 2026
 19:47:10 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org> <20261121-some-more-ai-fixes-v1-7-236e925d9b64@kernel.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-7-236e925d9b64@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 21 Nov 2026 19:46:59 -0800
X-Gm-Features: Aa3M54qHKxQ5rzbJaPdufivAA2W4T_-0OZh6w11WIANryg0XGZpusAUS75t9P2Q
Message-ID: <CAJuCfpH=srDXBNiPWWBopsjYMkEtebWO=-6cyYn7H98-e-q8Rw@mail.gmail.com>
Subject: Re: [PATCH 7/7] mm/vma: make brk mappings non-executable under MDWE
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ollie Wild <aaw@google.com>, 
	Adrian Bunk <bunk@stusta.de>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 49B89100002
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: on6gmm79ockggdwpkpbxxuogerhrbwmc
X-Rspam-User:
X-HE-Tag: 1795319232-381970
X-HE-Meta: U2FsdGVkX19S+xLPMtM7n9PYwoV2Njghj3sdcXsmqe5VRBrouYVD7b6yj7s9vdyA7dRamro2YJycBHHXY3HMGpjl1/1n6h/rIeZ961i/0GMoDUtuQ7eoD8EQNuORSm0ngt78Hwenvl78K0Pyxd8Ze2QioWnCyAhUsf+W2pQMAVaHEwAygrbGV4g+zXdlHQ4KaXA5DKVnzevAHJzLPU3wAMRVJyg2XOcmkqIdxbEHWnOhBxo1yYi1h1mcBE6FlgAS1AAcbHDzg7t4VnRV9UQu/+6cmTf28Z58issrEPXKiphGMkWt/Qo7W1ZWkm051eXF1GKHGaYUpal87AE034pSDJxlCOIWNlt856neIbOvU7fz3xql2y2v9Q6wCHlWkPTAIL9cc+grXppc5krK019ryEb0YeEvTaNYqNt5Bot1cTUJXe4lOJOkew4BNacQbky7YU7N2stYPDZG5f+PFOJW7AswM+SW9ee7muZFb65P/eY4muQFwFEEOByi4mg9Xhvuz51my72d+rVrku1PMtpoFKVCEBzYyWdxdHc/b63B9NC0MaKHDPoFwRaiAbSxI+nUIvfYKrQ0D9oKW5rn2Re5pgW6PNrNhG0XhlrEU7C97ohtWSG43DHd9DKcHho14TD6nHKLAVpfCBKJpUDQIopvEegD2YvDEOBqz9YsciVxZLqdkf8JxmG7++a6sUicSmUVvUDknsDyh8lDcNPpzLYzwvfQYHSd7148PvPwlx73U3BPUnH2EeOqYQWYORrQ/8eDcqH4redHpMopTEn5dZ4tasAA+IOxP18obIYG7M3ff0L/hEHrTXqxBoKmsEHEc8pydcbbLHhCkaTKscFBtilBycfTIjpwa4pn3HyA8XQJ3M3lSPdYQuKwxwO2SmfRTXROIgKoNu1uLgXV2vRBdgpUNubld0gxddopJpOIMXw6Yrew7Y/kWsEPIaqsf/a63Kzyw8dyafyvwu+S6LISm9C
 L+w8mtjs
 U2siUdjMgM9pptw/oVBndqnCsaZlonnPL92mVCb73odDqulTNaxNM6jYntLX0p8tJ6ai+B16WC5XECebXAb24bWjsrZwPpT7MChBz5QP+pgrSZnE4kE5gfs6PqXbdeeecyqU5JlnkMbuTGWdmDD+oKuizZEwYKvkbSs9Bl1IddFQA5ySRt4nhCa0H64mkVTWBgAB4qaSu0Ti7MVa97UF5dT9xuh3gCqESlAIcSCnoxLFzK5tm/PBhLt5SrTqodvuyR3L9E1aIe0P86xN0UGcqwnOcdejkVovQmbGCYTq6EgycUuGj4bNb6ZDtFZtafYSWg/45AxH38W19nW1lb45MNBw4G6mlk9KyuJPb9zGloyiz96qjNjMJQLjCNxZDnJOGe60otV39eE/9+c5lG0QDuAK2nCjymVO6DMRmHZWwNP1SW8XLw52QjHzidoKBbr01Prvj/Wxe+A4aZ2JP5yphgwDAMrQDkx+KLqhTHGrfG0U/YG82BxPJrlB+9trFtbDiZni+m1M7C7hlOent48I9C713NsOefgA/ZvTg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 8:03=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> From: Chris Mason <mason@kernel.org>
>
> With PR_SET_MDWE in effect, brk() and the ELF loader can still create
> anonymous mappings that are both writable and executable.
>
> MDWE only holds if every path that decides the flags of a VMA asks
> map_deny_write_exec(). mmap_region() and do_mprotect_pkey() do, but
> do_brk_flags() does not. It always sets VMA_WRITE_BIT, and it gets
> VMA_EXEC_BIT in any of these cases:
>
>     VMA_DATA_DEFAULT_FLAGS is
>       VMA_DATA_FLAGS_TSK_EXEC    the personality has READ_IMPLIES_EXEC
>                                  (e.g. x86, arm, arm64, mips)
>       VMA_DATA_FLAGS_EXEC        always
>                                  (the default, e.g. m68k, sh, sparc)
>     vm_brk_flags(is_exec)        elf_load() of a PT_LOAD with PF_X and
>                                  p_memsz > p_filesz
>
> Fix the issue by dropping VMA_EXEC_BIT if MDWE is in effect, so that
> brk() and execve() keep working where the bit is only a default.
>
> Under MDWE, a task that runs code from its heap, or from the part of an
> executable PT_LOAD beyond p_filesz, now gets SIGSEGV in the cases above.
>
> mprotect(PROT_READ | PROT_EXEC) on these mappings now fails with
> -EACCES. While the personality has READ_IMPLIES_EXEC, so does
> mprotect(PROT_READ), as on any other anonymous mapping that is not
> executable.
>
> Fixes: b507808ebce2 ("mm: implement memory-deny-write-execute as a prctl"=
)
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: switched to MMF_HAS_MDWE test, tweaked commit msg ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/vma.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index f8cf319ff9cf..a8b8101ff781 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -3235,6 +3235,10 @@ int do_brk_flags(struct vma_iterator *vmi, struct =
vm_area_struct *vma,
>         vma_flags_set(&vma_flags, VMA_ACCOUNT_BIT);
>         vma_flags_set_mask(&vma_flags, mm->def_vma_flags);
>
> +       /* The flags are implied, so under MDWE drop exec rather than fai=
l. */
> +       if (mm_flags_test(MMF_HAS_MDWE, mm))
> +               vma_flags_clear(&vma_flags, VMA_EXEC_BIT);
> +
>         vma_flags =3D ksm_vma_flags(mm, NULL, vma_flags);
>         if (!may_expand_vm(mm, &vma_flags, len >> PAGE_SHIFT))
>                 return -ENOMEM;
>
> --
> 2.56.0
>

