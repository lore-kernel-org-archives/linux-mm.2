Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2047FCCF9EA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 04:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F30D8E0127; Thu, 30 Oct 2025 00:40:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC898E0112; Thu, 30 Oct 2025 00:40:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E01F8E0127; Thu, 30 Oct 2025 00:40:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5D6968E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:40:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D578FC098E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 04:40:33 +0000 (UTC)
X-FDA: 84053529546.28.0761C07
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id E838C1C000B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 04:40:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=c6C9KBfA;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761799232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQ/blAUtd3RJvFkaQNVmmQwc7XQHf3yHIB6Jvobdagw=;
	b=YJuNsl0r2Gy4gJNkd2TNN7gDUGQbpvx0+0EbLOtqFMaDMvG1WWmzoTTDYzo3bNS5K7mhkN
	AH6u+fdzFE5WNfI3z532F/q8DMDmZwEZ6O6FE9UFaF0/3WY55a+bN9k7WlvvlfXLBGOJQx
	cWaue+b+PR5G6Ruri8tLfpFVpvZ5pCg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761799232; a=rsa-sha256;
	cv=none;
	b=OVPi+TmFZ0xEirwcxOYhBgnr59I5JkAOxrNtCJTCa/eBxnCCRmrcVTkDK95ZxulkFE+RR/
	AJjwicxPEzQ+vOlsnColf2Y6ZJ1fAxgdsCRuuH7NUw92L6alC2v+XTLyVhFgtg75JBtx66
	gxQYaL9MV2j+KsSsAbwbBCP+MLWIS3w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=c6C9KBfA;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ed0c8e4dbcso136731cf.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761799231; x=1762404031; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XQ/blAUtd3RJvFkaQNVmmQwc7XQHf3yHIB6Jvobdagw=;
        b=c6C9KBfA36Xhvw2RjciJevm8mXMu3nq7HjMt3jJ3gYho1C1C3Gs/jcuZQcAFk5hAED
         Pr+t9mPPTa6VIVoP2AO0z9uKNnI4CTwZhcoCNVYQgzpZLFq7fDYlEoA4UIv+gOiVMgo7
         bBagQOrv9AIeogo9NTj92ZHw832uYsKxqsLohNgflLicd0/QG5A4KYX/22mhmYSM4Spm
         Rey9lG3FjS4PSUC50F81FNUve5j/O5kzEbeapbdLyHvUNR5KWEEopcLYbAilXAo6OH8t
         9XrbE1zzZwNGNO+oArWBZy+J4Nyr1tQeB2tQ7lz1jXijn9bppXpaRbv1PoQFhRD4BJoG
         NjTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761799231; x=1762404031;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XQ/blAUtd3RJvFkaQNVmmQwc7XQHf3yHIB6Jvobdagw=;
        b=ifY01jQniuClKP/3y3sthl+/G0L/3PaemMWF4vCyHISVOfbfpJe6+1WJORP+smu/Ww
         svO2fBQCSVo10IBf63iu6F7+l25qFqscY7WcNUW9aD6ZeE4YHhbZaCCTZctBOwmTL2ei
         PavHd8H+71VoZUC+2nece1E75XfP5x/Wr7ETacJ9XERLhdaZPt43XHkyVdXzwLBfiSQF
         RZNm7E8WL5wtNNmuB3X1zzvGlxzRGAwZUcMuFkGYUFQBAw2p1SWnrLMIKZ2Cyi3eezpB
         06d19CQ86yG90lZZyJef7YCFK0kb9KS5BP3b1MSwrb3G+K4NoWJKPo5v5kG/phgrPj0Z
         6sUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLnYrSOt0D5A5E0QrZ+F6EWMWuMtuDfH+R+2vVbLJpz1SBV7S39JDwXpJNCJEVSs4p0bnJ/M1V6A==@kvack.org
X-Gm-Message-State: AOJu0Yx7H3xllzrWrfM3PuIjcgoSTv+SwSz3CK2X7HwaoyBTjxt9rfPi
	9zZRiyvbRPpfHPEUVRnVAfooa3tIAhyo8irins6pHC7e/I9Mk9Nkw6Y+j+eXXbsRGZhQ+agm2lz
	jPFJ/j5sZpEBJRRQ/LLEq3gImq3vFcruds1apzn3P
X-Gm-Gg: ASbGnctdmQSn+4HFo3Bt5+o3XWDOr+YH2DDSW5vUHcbscYLlXWZ/w6c+xMgpaLjB/LC
	AfoSZeqF3Sy+9/940vDE7qvuxwyiQSO98uvUdWY6uYhjDN5jkQQ7qI06iL+5+PiGvjFEG6PBLyv
	xY2f3PjtdEv7HJTp2aEhn+qdOLnpji57FyK2GH0oTxLPw5xdf9UBvwutM3SRYk20FxaTc98X4HZ
	YgQJX0nPutVHVFjiwmFIhz6dfj8N/F9oPG0mD5sAZZ+igdTfmy8SvEeuQbaFEchU1ko9w==
X-Google-Smtp-Source: AGHT+IHUTVIoMGgym7Rl26g/BilUAT4CgTBJK8bytma8Yytb4fFlVaJbZIP7eL03YRO77BOZ2/iZU2Eddn/9UG3dHtw=
X-Received: by 2002:a05:622a:1790:b0:4b7:9a9e:833f with SMTP id
 d75a77b69052e-4ed240d674amr2436531cf.7.1761799230462; Wed, 29 Oct 2025
 21:40:30 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1761756437.git.lorenzo.stoakes@oracle.com> <9e5ef2bedbff6498d7e5122421f0ea5ff02236b7.1761756437.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <9e5ef2bedbff6498d7e5122421f0ea5ff02236b7.1761756437.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 29 Oct 2025 21:40:19 -0700
X-Gm-Features: AWmQ_bk_ynX9lneWpHBfJJexvgQjPhSl6AaFwMQbkIx85JwpdO8ydosQokMaIkg
Message-ID: <CAJuCfpGFAv9DizXOzCn1Qi5=NDyHh6XyxpmsQr0K45LS6x4igg@mail.gmail.com>
Subject: Re: [PATCH 3/3] selftests/mm/guard-regions: add smaps visibility test
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	David Hildenbrand <david@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Andrei Vagin <avagin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: ti5zfnfstru5qzx7wffw7mirkijgsgek
X-Rspam-User: 
X-Rspamd-Queue-Id: E838C1C000B
X-HE-Tag: 1761799231-388528
X-HE-Meta: U2FsdGVkX1+NK7apfkgtyc9R6sewYakrwzBYqESbaxUoSpNRtAdS6n2uXGqvmd6LNeBjZXokQx9znVmR5uKjnQ1hYlJ8G9LwGZbcvayYp6jPsSPbeZtfNFKXl8CNq0ZJ8ME6RNLnfQsl9t5E2xjIR/Gr2zWHk8z6T+yVMnIV6UJdsqCloO+bLnVpnRkXPYCmv0Re1/sI59NyeJgSTYyQFjHapDoDDfg4YAG1dWh8Z6NTlIvKHg8JghzOY08Kb5RwlzNmTZlcMoJdokShNaOO6AiJsDlP7pAlFW7YUaDoOafHmD2PoAEApavW22RZp/C50Vkeh6eA80+1yiQw+Fa5vtOde5XL35Ec6v3OW8K7G1TChDburyWzsR5esaZ+mCTjNtRDUdZba6OUP9zm0UR8IW3nh6cGJJzoIdd2KQBCufkWyF91WEuN67QXG+owBBczp0yUVcx878R0KUoawYQ5TK2jiqtZWXT8jxj21Nj3VvFkkiZ3+zdVg0TFnazuxMkAzImGsr+Ken5NPcnAJtkxYWivEMVP2v5WclhSldfYyk8B2ppgNEO+EjTI/Edd2OiSJwxtrUC54qqPKMsalBZXjlaQztUyAmEkevTfQlbKljX057LUbaFSvhnmIMQW2A+GEQkVhCF8xxqPoicqx4kM9QGERtEOYOyGBRVfEjiJa6wujS3apQa1FMknAXPzxuQLrgnL6wrlhRuy/06LqvHT2Q0jFn6d9SIXpqlKmLe9jk5EDBItdx/kCr0/h3s6TsWQyot+2V2rZILzzvzk00+Z6uGtBBGJJNFXxNVjObg/slaa9XIdfbQz5F6+NXgEo3wCSGmTWlj53Cy4s5ONV17r/Ubz30n8Og+74tGgX1F9Y4mdRvvKRvOU/VvqDwcei2dnoWgswjspbDjt9OYn8iYyocgQIUCjKhIxYo9Cn4Qnij0Rn+pt3EgHajf5sJ2U3yTdKjIE4wJ3FpwytKEcHdM
 wjxSoJru
 JUE7XoVkMP61qH+Zz+mDcX9omsiqXJu2EEuX1IxZqoxFaKManaTY4/LhTTIHQIysH9GD6iXurzKU5LtJHA8Z1E4HXJyK9l7JiqPT6QsfDCe6AhMeM/6+k9vs+Qb9PKE75pSDvsYoBsHkmYaojVFxNEZQubclH19hyXgb5ag5FoptbYHqb0JxmFLAYhcHAepUnXRdvw6Mqpz2my+JljNAz1xkPrs8doD2w74csnhEwWFg/amqtl/fzUQ57KQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 9:51=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> Assert that we observe guard regions appearing in /proc/$pid/smaps as
> expected, and when split/merge is performed too (with expected sticky
> behaviour).
>
> Also add handling for file systems which don't sanely handle mmap() VMA
> merging so we don't incorrectly encounter a test failure in this situatio=
n.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  tools/testing/selftests/mm/guard-regions.c | 120 +++++++++++++++++++++
>  tools/testing/selftests/mm/vm_util.c       |   5 +
>  tools/testing/selftests/mm/vm_util.h       |   1 +
>  3 files changed, 126 insertions(+)
>
> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/s=
elftests/mm/guard-regions.c
> index 8dd81c0a4a5a..a9be11e03a6a 100644
> --- a/tools/testing/selftests/mm/guard-regions.c
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -94,6 +94,7 @@ static void *mmap_(FIXTURE_DATA(guard_regions) * self,
>         case ANON_BACKED:
>                 flags |=3D MAP_PRIVATE | MAP_ANON;
>                 fd =3D -1;
> +               offset =3D 0;
>                 break;
>         case SHMEM_BACKED:
>         case LOCAL_FILE_BACKED:
> @@ -260,6 +261,54 @@ static bool is_buf_eq(char *buf, size_t size, char c=
hr)
>         return true;
>  }
>
> +/*
> + * Some file systems have issues with merging due to changing merge-sens=
itive
> + * parameters in the .mmap callback, and prior to .mmap_prepare being
> + * implemented everywhere this will now result in an unexpected failure =
to
> + * merge (e.g. - overlayfs).
> + *
> + * Perform a simple test to see if the local file system suffers from th=
is, if
> + * it does then we can skip test logic that assumes local file system me=
rging is
> + * sane.
> + */
> +static bool local_fs_has_sane_mmap(FIXTURE_DATA(guard_regions) * self,
> +                                  const FIXTURE_VARIANT(guard_regions) *=
 variant)
> +{
> +       const unsigned long page_size =3D self->page_size;
> +       char *ptr, *ptr2;
> +       struct procmap_fd procmap;
> +
> +       if (variant->backing !=3D LOCAL_FILE_BACKED)
> +               return true;
> +
> +       /* Map 10 pages. */
> +       ptr =3D mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PR=
OT_WRITE, 0, 0);
> +       if (ptr =3D=3D MAP_FAILED)
> +               return false;
> +       /* Unmap the middle. */
> +       munmap(&ptr[5 * page_size], page_size);
> +
> +       /* Map again. */
> +       ptr2 =3D mmap_(self, variant, &ptr[5 * page_size], page_size, PRO=
T_READ | PROT_WRITE,
> +                    MAP_FIXED, 5 * page_size);
> +
> +       if (ptr2 =3D=3D MAP_FAILED)
> +               return false;
> +
> +       /* Now make sure they all merged. */
> +       if (open_self_procmap(&procmap) !=3D 0)
> +               return false;
> +       if (!find_vma_procmap(&procmap, ptr))
> +               return false;
> +       if (procmap.query.vma_start !=3D (unsigned long)ptr)
> +               return false;
> +       if (procmap.query.vma_end !=3D (unsigned long)ptr + 10 * page_siz=
e)
> +               return false;
> +       close_procmap(&procmap);
> +
> +       return true;
> +}
> +
>  FIXTURE_SETUP(guard_regions)
>  {
>         self->page_size =3D (unsigned long)sysconf(_SC_PAGESIZE);
> @@ -2138,4 +2187,75 @@ TEST_F(guard_regions, pagemap_scan)
>         ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
>  }
>
> +TEST_F(guard_regions, smaps)
> +{
> +       const unsigned long page_size =3D self->page_size;
> +       struct procmap_fd procmap;
> +       char *ptr, *ptr2;
> +       int i;
> +
> +       /* Map a region. */
> +       ptr =3D mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PR=
OT_WRITE, 0, 0);
> +       ASSERT_NE(ptr, MAP_FAILED);
> +
> +       /* We shouldn't yet see a guard flag. */
> +       ASSERT_FALSE(check_vmflag_guard(ptr));
> +
> +       /* Install a single guard region. */
> +       ASSERT_EQ(madvise(ptr, page_size, MADV_GUARD_INSTALL), 0);
> +
> +       /* Now we should see a guard flag. */
> +       ASSERT_TRUE(check_vmflag_guard(ptr));
> +
> +       /*
> +        * Removing the guard region should not change things because we =
simply
> +        * cannot accurately track whether a given VMA has had all of its=
 guard
> +        * regions removed.
> +        */
> +       ASSERT_EQ(madvise(ptr, page_size, MADV_GUARD_REMOVE), 0);
> +       ASSERT_TRUE(check_vmflag_guard(ptr));
> +
> +       /* Install guard regions throughout. */
> +       for (i =3D 0; i < 10; i++) {
> +               ASSERT_EQ(madvise(&ptr[i * page_size], page_size, MADV_GU=
ARD_INSTALL), 0);
> +               /* We should always see the guard region flag. */
> +               ASSERT_TRUE(check_vmflag_guard(ptr));
> +       }
> +
> +       /* Split into two VMAs. */
> +       ASSERT_EQ(munmap(&ptr[4 * page_size], page_size), 0);
> +
> +       /* Both VMAs should have the guard flag set. */
> +       ASSERT_TRUE(check_vmflag_guard(ptr));
> +       ASSERT_TRUE(check_vmflag_guard(&ptr[5 * page_size]));
> +
> +       /*
> +        * If the local file system is unable to merge VMAs due to having
> +        * unusual characteristics, there is no point in asserting merge
> +        * behaviour.
> +        */
> +       if (!local_fs_has_sane_mmap(self, variant)) {
> +               TH_LOG("local filesystem does not support sane merging sk=
ipping merge test");
> +               return;
> +       }
> +
> +       /* Map a fresh VMA between the two split VMAs. */
> +       ptr2 =3D mmap_(self, variant, &ptr[4 * page_size], page_size,
> +                    PROT_READ | PROT_WRITE, MAP_FIXED, 4 * page_size);
> +       ASSERT_NE(ptr2, MAP_FAILED);
> +
> +       /*
> +        * Check the procmap to ensure that this VMA merged with the adja=
cent
> +        * two. The guard region flag is 'sticky' so should not preclude
> +        * merging.
> +        */
> +       ASSERT_EQ(open_self_procmap(&procmap), 0);
> +       ASSERT_TRUE(find_vma_procmap(&procmap, ptr));
> +       ASSERT_EQ(procmap.query.vma_start, (unsigned long)ptr);
> +       ASSERT_EQ(procmap.query.vma_end, (unsigned long)ptr + 10 * page_s=
ize);
> +       ASSERT_EQ(close_procmap(&procmap), 0);
> +       /* And, of course, this VMA should have the guard flag set. */
> +       ASSERT_TRUE(check_vmflag_guard(ptr));
> +}
> +
>  TEST_HARNESS_MAIN
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftes=
ts/mm/vm_util.c
> index e33cda301dad..605cb58ea5c3 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -449,6 +449,11 @@ bool check_vmflag_pfnmap(void *addr)
>         return check_vmflag(addr, "pf");
>  }
>
> +bool check_vmflag_guard(void *addr)
> +{
> +       return check_vmflag(addr, "gu");
> +}
> +
>  bool softdirty_supported(void)
>  {
>         char *addr;
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftes=
ts/mm/vm_util.h
> index 26c30fdc0241..a8abdf414d46 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -98,6 +98,7 @@ int uffd_register_with_ioctls(int uffd, void *addr, uin=
t64_t len,
>  unsigned long get_free_hugepages(void);
>  bool check_vmflag_io(void *addr);
>  bool check_vmflag_pfnmap(void *addr);
> +bool check_vmflag_guard(void *addr);
>  int open_procmap(pid_t pid, struct procmap_fd *procmap_out);
>  int query_procmap(struct procmap_fd *procmap);
>  bool find_vma_procmap(struct procmap_fd *procmap, void *address);
> --
> 2.51.0
>

