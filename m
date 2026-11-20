Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AD9A606A698
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 22:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Bvb3741+
Received: by kanga.kvack.org (Postfix)
	id 8B1A36B05B1; Fri, 20 Nov 2026 17:30:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8625A6B05B2; Fri, 20 Nov 2026 17:30:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 750CC6B05B3; Fri, 20 Nov 2026 17:30:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C0496B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:30:15 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 563C9C0200
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:30:14 +0000 (UTC)
X-FDA: 85456941948.06.C1731D2
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4812840003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:30:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Bvb3741+;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795213812;
	b=U6yZI5GPL27E/NVhnzxxK9UT2AqC1s+gvvQB5DGci4sfvRRucgId9K+EbwAq+LnqxuVWSv
	AHlUO7kge+2hmhMDsegE3DuykFvTKmFCuoShqu+NwYqg5SRBbXwWHIuz0fMQe4SDEOjudN
	BmFU6zeWO1urq24FrnQ0zQlbyYqPA2E=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795213812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oSCVbmqxiQi2DoLmGcMaMHvDma566TKArudq046yQIs=;
	b=DpTuPShhsImQ36symulK7JuUwuCZNvJqK3Ar0nu/5IyBjeH6dNfxJ0sD/WLNsK5OW1CP6D
	w5yrA70kXf2HsEPHX32HBvapadzw4qXd0tMLlLHSnQdWw9vygejWm0IAMUZVQ8tmsf2A0k
	wyDH4xNKvSV6EBEfd1Gc3BNIPB9dUi0=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Bvb3741+;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-55be673e029so34241cf.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:30:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795213811; cv=none;
        d=google.com; s=arc-20260327;
        b=czLRtSFT1bCZ0yqqhrkbcrAvb1C06U8TySQ6GkHDQlUFBIftQEWwW+6gIKfjGO545z
         hPNO7QxseKH/OsmZNI/22f86L1dG6sQH+LdT+MPUKRCiGrKvd+s4Urcg60bqvZD08yxZ
         eCypoubUDKCY9U0r87s9tgBo1dk0kmxxcDBY7dYwqqQ++FlIZbA0yvoxHioV3qBmzMMh
         x4TcuZs5Aw0LjUJ9FPVstNfchjbXzvVZnpO3FIlhcKZNQxHjbXFZYPdioYiIZilKn+Db
         1xAFjrPNN9uyTH6dDePYtrjcyaOdIqF++pUrAPQSvVNBF+d9O+zhUKfExZ6xadCQVIa6
         NudQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oSCVbmqxiQi2DoLmGcMaMHvDma566TKArudq046yQIs=;
        fh=g8JFw7vDtwVVTMeINsQrU4q92rvD0HLOILG7LitkSpE=;
        b=hxCEfDeaG0ONnX1D0rMxSr+SXW3Wmrpn8i+P6J+IqJE4yq3HLyPkepLtXkk8Ow5wzs
         wMygvkpLcBuGVOJLM3KI+UaSZ5FxTYIcsCjvE6BJ31ka3EM/W22atX4HvfPTQ/sz3yeZ
         TSqdgDGfy1Us/QiRT4qjkP2Ro3PH956EPRxdxhgRqkIu6EZYpy6zyc+e/UoDV/YbK9J6
         kL0NFLKTLyNfWX70C32LCT3WkVPqERs+85t56FK1vd3+q/6jsiZLsdJyxlOypuTRFqSz
         8p98IdPA+720CvpmBwwbdENrnCyV3IiNdBGxn/bYhUDJJpnSB4GX72KGPgj6pPCEJEm6
         y7TQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795213811; x=1795818611; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oSCVbmqxiQi2DoLmGcMaMHvDma566TKArudq046yQIs=;
        b=Bvb3741+aXfvGi3Ja5w9GbHtcd/6+pO6rkC1ryG3KINLOMduR1VxpGT2YDBUBRbMb1
         gpoLP+vTK6v1UM5IFDis03ctwYcQ3rgNiZz91YI7g3kGF/tUQytGgTvpqxPkKCKBybAq
         beQ+EFA+L5UFvz5e+7GzuMMCrSJZTLJE7mqYxlwHGrPwzji9yGFSQYMb7ZMrHsJ6nJhI
         r4zdtuN0evWhMUm/Xw8lCkEP85BN3RL5SdvcuHEJJXpQpYmr42jVofeqRnFBHkgJOxg8
         sFwP7R9omfFA//z1YcZV05Hm5nH6+m6YbX7BcSyydNm7GKXkVVtMfp6cXJ6XWwDm8MJr
         fgwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795213811; x=1795818611;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oSCVbmqxiQi2DoLmGcMaMHvDma566TKArudq046yQIs=;
        b=NSiERFLdX+oAvFJSo/YcT5ptNrSpGiLpcPnUChznr9metwQtSI81PjJzqTrutw2xA6
         ruIk42M8WUbAkdfe0n/JrQLTfy424JwmC9e3KCLnlmy9Sj9JOeYKwCzuwW91H06uTMoa
         xFahdMMfz3DW3GgsFJZsRCaKwW/mgwrN2SuzOmgG4bnCpucHPUbO3hWmRxmotHJgfhTn
         ZOFriXzbrVmaziyIseKZGZfCTooUN2yknApAYZ8cFKIVtL3qqvu3UhCQEp13j3lJoHg8
         RQ9kZnIVOWW7y3aiWy0546JokaPuom5+d0URbyuBH/iiiDRLZgzjEjuJcmqlNwLeDU1b
         tCUg==
X-Forwarded-Encrypted: i=1; AL+hErGZNycUEAaVjlDGvaJ+e/l3dln3Kde9oobXuZywtqPnaMGTnN/AgQXNsWNpaBdFgE5UA8wWRVf23A==@kvack.org
X-Gm-Message-State: APuU4Z9KXudZb0EiXFLdimL9rT4DkHO7+Kio/8eqZ6Oh5N6Uh3OqxYO4
	a8e6lvZrgT497vMSWj86QO9g2mhB2hFL4YfY7KlHsPe/68OJvqBVo3yD1812krw3wrX8RX8wfhl
	cdg4RZYZKM5yDReo8V40FL9e3S2Yq6lFGXYElezkQ
X-Gm-Gg: AYBFou2EmSoZTU29eXrrQidPvXo9lSf51jDqAP+CEyYweAFazMV7kYlew56ISAqQcLB
	Y0cosi997V4NVDlc60hz0658GBYn3JXpvBf4pjkUX1UM9blQwcZixqRytVuQjS4z1NUaMvz70y/
	dVZyOYVZBcU88ivOV9TTj99YzuAFA73xoQ4d/SdFBMyieKKoTK2h+f+o8XHs27rzguXfMNi3BR0
	Wx5qrd34ZGry2/U7c6xX2IqFtgaOBhYVhmEWl2Pp6zoAD0eG+DPeR41JjOnZXCElTeBMU+fJO5b
	TsbhXkMJgDg9amvp03uFTSO5flKY73uAk4XCWYWEZgYP6ncveXOVdFt34TPh9ezLDa47WzWxt/Y
	6CCNdkV7OzfAMd86/IQlY0dR7LtSZqE0i15uZLU1Uqviq7nZrqPBG9RZSL573qqDD7gZ7EuxeUd
	iv4jYpW+oVnxOkzS2fqAfNwcmq
X-Received: by 2002:a05:622a:2b44:b0:536:934f:7da2 with SMTP id
 d75a77b69052e-55d88013e93mr5507861cf.2.1795213810431; Fri, 20 Nov 2026
 14:30:10 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116071325.263682-1-hao.ge@linux.dev> <20261116071325.263682-7-hao.ge@linux.dev>
In-Reply-To: <20261116071325.263682-7-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 20 Nov 2026 22:29:59 +0000
X-Gm-Features: Aa3M54pjipOW7ZzgZHb-E-Af8isX9CFT5XpnqdBhptBuFS7GWS9SCDR86t6dxYw
Message-ID: <CAJuCfpEZ15zhoBsHuO1CD2JpYOQ5SrjOaZ_RkR=y8Gne557qMQ@mail.gmail.com>
Subject: Re: [PATCH v5 06/11] mm/vmalloc: undo what vmap_page_range() mapped
 on failure
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4812840003
X-Rspam-User:
X-Stat-Signature: t7hccspotdsxa7j1uk7s44yjr7wj688i
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795213812-62643
X-HE-Meta: U2FsdGVkX1+W7CTFI/0W43inNZMbJWaWs4DExSwDFyTyrlhBzE09skdOZOU2n7FbXrtP92JXsp3aoKDV8KwECjPr+2E/b0y0mvupFH+iXEw5Tgd0Q1OITAhNnWupPc2pV7iSfRu9T9vgLKw06GyCfpqwuyIYaViyIaETJxmyY9DREiA+WrzdL4Mj9oSTywoA0sKn2eYWBilGVDr87+eMcaM7204QfP5MnM7nWo/M689yG06YJzmoGSlU7Fufsebxsd4hu/X/UOsu2QwVo+GyfyRxteeklg8JdLgertv9+xhCRmpY8YI6xmAUPPIKBaD5HLnthXOWhrf41oYMuwXtL7PPv6TDF9RBWbJxw59m8laAf5WJI4yCfEEuqZItw+1R6OCWeYnx5aHAZY8JbfamO0puMdViUA9vYkaup2BOOFLUfROeCkPK2fq6v6QYbrDQqc+nbKakzpnR62ExFlHpC4NIUUVyOKt9g6ai5+bv4EpWdkMjobRsMGAgxflaHm+WraWxd7xB1ecfST9vlHXc6IJtWzHOSz2mX6mjZZ8Wy86grBS7+spIfG4MemQKisWYpTfd/ZSdWdP0F+lwuSZrRqborfoXur4qTLE15TsIgsEppJLoqZLMoSGTYbXTX9VVNOE90PryhV9d3ESnBQWxTUt5cWTzvdvtYPG2/gaX/auxplyqHh6rm/G861dZ6dXZEpbG1AMQg2ZKe0R3WseY5CprsB2qmnWJHo03ADhwavl9dUG6HgZ1AtZk8bnqmEqXdJN+9TTmG4FkmdDy6xY+xrsXSHYh73a5egPNbr1Y45CAXMQDcK8L5Ljilp/NX+rbe5vMw7Kguvqy3a0JEv6N4RFj449tmNjoqzF0mA2C9NS/SkhJX4gBNVyqu4Shiw4pNH9Ca8MvCCmH+7jgSmew2LoaGi8mKSmFvTgKK0VE1TKLWjfcJPqK9/m54N2yegMnsOxGXSgbw2VbFiS8Ddw
 TH2UG9xV
 GQ8LZYBBT/TXPKQVCu/Syn7SaJdNG3FSo5EbROSaKAIRXeQXnchJCvqvXP1eXSqcIO07Dkq0y+y+GE64AhVGnWPvl0FtUKcA1t1Uy01ovLRherxpByCi9jY+W/Kdk9UMTBIzYzteeP+p1l3rGfEZAVJSOt+bEUgLbXCqPPjldmWqbyIJiHtR/y8rWSgUWxQfu+fQ323VI4jlx0prujaITGqagOB/C6kc+6rBvoY3OpTKuESzj+oldqKfbhCnAb3nmMtfAPSdk5yZVprE7brLIuah70EirdS7vFQS4sdfQoDUr11CyVYjNYT1LDOVBWBPtC32VU71vXVt9hBjFNDwViqQ0Eu9kamQTErT4QDj6+uJssID/U/XLXiXpx7q4GfaPde1HbcSGzV8R4WVE/1vjqpQJQGvFQBrAZCv1fmP21f0s67mwc1W1f4q7sXKnG0D7OPqU9ihiscKI3mq+3VjEFsngXaqfwUmzvWBQe4Vnbm1e1M7tLa4HtUz56FmrmBmKAC0rsfMdhbtAQVJTTtjDi0UP1gf/+HYragDPuvajEB3agWoprK82rkHYm8TeQ7g5lAcNpA5QBJYd8V4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 7:14=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> ioremap and arch setup code map their ranges with vmap_page_range().
> When the walk fails half way, or the KMSAN metadata fails after the
> walk, the ptes installed so far stay behind. The caller frees the
> vm_area on the error path, so the next mapping that lands on the same
> range trips the BUG() in vmap_pte_range().
>
> vmap_range_noflush() now takes a mapped_end argument that the walk
> levels advance as they install, and vmap_pte_range() BUG()s before
> it installs over a pte that is already set. The ptes below mapped_end
> are therefore all ours, while a pte above it can only have been put
> there by somebody else, for example when the caller's range overlaps
> an existing mapping. On a walk failure the undo is limited to
> [addr, mapped_end), going further would clear ptes that are not
> ours. If the walk completed and only the KMSAN metadata failed, the
> whole range was installed by this call and all of it is undone.
>
> All callers are sleepable, the teardown passes can_resched =3D true.
>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/vmalloc.c | 52 +++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 39 insertions(+), 13 deletions(-)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index d99d7710e1ba..5c1eacc2a0ac 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -117,7 +117,8 @@ static __always_inline unsigned long vmap_set_ptes(pt=
e_t *ptep,
>
>  static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long =
end,
>                         phys_addr_t phys_addr, pgprot_t prot,
> -                       unsigned int max_page_shift, pgtbl_mod_mask *mask=
)
> +                       unsigned int max_page_shift, pgtbl_mod_mask *mask=
,
> +                       unsigned long *mapped_end)
>  {
>         pte_t *pte;
>         u64 pfn;
> @@ -143,6 +144,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long a=
ddr, unsigned long end,
>
>                 size =3D vmap_set_ptes(pte, addr, end, pfn, prot, max_pag=
e_shift);
>                 nr_pages =3D PFN_DOWN(size);
> +               *mapped_end =3D addr + size;
>         } while (pte +=3D nr_pages, pfn +=3D nr_pages, addr +=3D size, ad=
dr !=3D end);
>
>         lazy_mmu_mode_disable();
> @@ -188,7 +190,8 @@ static int vmap_try_huge_pmd(pmd_t *pmd, unsigned lon=
g addr, unsigned long end,
>
>  static int vmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long =
end,
>                         phys_addr_t phys_addr, pgprot_t prot,
> -                       unsigned int max_page_shift, pgtbl_mod_mask *mask=
)
> +                       unsigned int max_page_shift, pgtbl_mod_mask *mask=
,
> +                       unsigned long *mapped_end)
>  {
>         pmd_t *pmd;
>         unsigned long next;
> @@ -203,10 +206,12 @@ static int vmap_pmd_range(pud_t *pud, unsigned long=
 addr, unsigned long end,
>                 if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot,
>                                         max_page_shift)) {
>                         *mask |=3D PGTBL_PMD_MODIFIED;
> +                       *mapped_end =3D next;
>                         continue;
>                 }
>
> -               err =3D vmap_pte_range(pmd, addr, next, phys_addr, prot, =
max_page_shift, mask);
> +               err =3D vmap_pte_range(pmd, addr, next, phys_addr, prot,
> +                                    max_page_shift, mask, mapped_end);
>                 if (err)
>                         break;
>         } while (pmd++, phys_addr +=3D (next - addr), addr =3D next, addr=
 !=3D end);
> @@ -245,7 +250,8 @@ static int vmap_try_huge_pud(pud_t *pud, unsigned lon=
g addr, unsigned long end,
>
>  static int vmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long =
end,
>                         phys_addr_t phys_addr, pgprot_t prot,
> -                       unsigned int max_page_shift, pgtbl_mod_mask *mask=
)
> +                       unsigned int max_page_shift, pgtbl_mod_mask *mask=
,
> +                       unsigned long *mapped_end)
>  {
>         pud_t *pud;
>         unsigned long next;
> @@ -260,10 +266,12 @@ static int vmap_pud_range(p4d_t *p4d, unsigned long=
 addr, unsigned long end,
>                 if (vmap_try_huge_pud(pud, addr, next, phys_addr, prot,
>                                         max_page_shift)) {
>                         *mask |=3D PGTBL_PUD_MODIFIED;
> +                       *mapped_end =3D next;
>                         continue;
>                 }
>
> -               err =3D vmap_pmd_range(pud, addr, next, phys_addr, prot, =
max_page_shift, mask);
> +               err =3D vmap_pmd_range(pud, addr, next, phys_addr, prot,
> +                                    max_page_shift, mask, mapped_end);
>                 if (err)
>                         break;
>         } while (pud++, phys_addr +=3D (next - addr), addr =3D next, addr=
 !=3D end);
> @@ -302,7 +310,8 @@ static int vmap_try_huge_p4d(p4d_t *p4d, unsigned lon=
g addr, unsigned long end,
>
>  static int vmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long =
end,
>                         phys_addr_t phys_addr, pgprot_t prot,
> -                       unsigned int max_page_shift, pgtbl_mod_mask *mask=
)
> +                       unsigned int max_page_shift, pgtbl_mod_mask *mask=
,
> +                       unsigned long *mapped_end)
>  {
>         p4d_t *p4d;
>         unsigned long next;
> @@ -317,10 +326,12 @@ static int vmap_p4d_range(pgd_t *pgd, unsigned long=
 addr, unsigned long end,
>                 if (vmap_try_huge_p4d(p4d, addr, next, phys_addr, prot,
>                                         max_page_shift)) {
>                         *mask |=3D PGTBL_P4D_MODIFIED;
> +                       *mapped_end =3D next;
>                         continue;
>                 }
>
> -               err =3D vmap_pud_range(p4d, addr, next, phys_addr, prot, =
max_page_shift, mask);
> +               err =3D vmap_pud_range(p4d, addr, next, phys_addr, prot,
> +                                    max_page_shift, mask, mapped_end);
>                 if (err)
>                         break;
>         } while (p4d++, phys_addr +=3D (next - addr), addr =3D next, addr=
 !=3D end);
> @@ -329,7 +340,7 @@ static int vmap_p4d_range(pgd_t *pgd, unsigned long a=
ddr, unsigned long end,
>
>  static int vmap_range_noflush(unsigned long addr, unsigned long end,
>                         phys_addr_t phys_addr, pgprot_t prot,
> -                       unsigned int max_page_shift)
> +                       unsigned int max_page_shift, unsigned long *mappe=
d_end)
>  {
>         pgd_t *pgd;
>         unsigned long start;
> @@ -346,11 +357,12 @@ static int vmap_range_noflush(unsigned long addr, u=
nsigned long end,
>         BUG_ON(addr >=3D end);
>
>         start =3D addr;
> +       *mapped_end =3D addr;
>         pgd =3D pgd_offset_k(addr);
>         do {
>                 next =3D pgd_addr_end(addr, end);
>                 err =3D vmap_p4d_range(pgd, addr, next, phys_addr, prot,
> -                                       max_page_shift, &mask);
> +                                       max_page_shift, &mask, mapped_end=
);
>                 if (err)
>                         break;
>         } while (pgd++, phys_addr +=3D (next - addr), addr =3D next, addr=
 !=3D end);
> @@ -364,18 +376,32 @@ static int vmap_range_noflush(unsigned long addr, u=
nsigned long end,
>  int vmap_page_range(unsigned long addr, unsigned long end,
>                     phys_addr_t phys_addr, pgprot_t prot)
>  {
> +       unsigned long mapped_end =3D addr;
>         int err;
>
>         if (WARN_ON_ONCE(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end)))
>                 return -EINVAL;
>
>         err =3D vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
> -                                ioremap_max_page_shift);
> -       if (!err)
> +                                ioremap_max_page_shift, &mapped_end);
> +       if (err) {
> +               /* Undo the part the walk installed before it failed. */
> +               if (mapped_end > addr)
> +                       __vunmap_range_noflush(addr, mapped_end, true);
> +       } else {
>                 err =3D kmsan_ioremap_page_range(addr, end, phys_addr, pr=
ot,
>                                                ioremap_max_page_shift);
> -       if (!err)
> -               flush_cache_vmap(addr, end);
> +               if (err) {
> +                       /*
> +                        * Only the KMSAN metadata failed, the walk mappe=
d
> +                        * the whole range. Undo it all. The callers are
> +                        * ioremap and arch setup code, always sleepable.
> +                        */
> +                       __vunmap_range_noflush(addr, end, true);
> +               } else {
> +                       flush_cache_vmap(addr, end);

This again skips TLB flushing after __vunmap_range_noflush(). I'm not
sure that's ok even if there was no explicit access.

> +               }
> +       }
>
>         return err;
>  }
> --
> 2.25.1
>

