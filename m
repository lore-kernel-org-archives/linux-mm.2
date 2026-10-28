Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD25C606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HOfCUqIC
Received: by kanga.kvack.org (Postfix)
	id 9654E6B098D; Wed, 28 Oct 2026 00:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D1F6B098F; Wed, 28 Oct 2026 00:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8527D6B0990; Wed, 28 Oct 2026 00:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59B606B098D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:30:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1B1BA052B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:30:23 +0000 (UTC)
X-FDA: 85370758326.13.BE59772
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1D4D1180003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:30:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=HOfCUqIC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3W3rhagYKCDQZUVVnkWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jeffxu.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3W3rhagYKCDQZUVVnkWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jeffxu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793161822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPQx6GgboXmcUMcY5/lzKrJ0ssCkME3FTMDmy2U7T6k=;
	b=JjFBvqu+vWWNkU2lJwMR/iTCXzefhs/T+FHu4dkuObAw0i5Haj9E3oB39+g8z0L46lPMaz
	K2qQXuNFg2pMbH6xwxY1SItRC239kM0ESJ+ZvHRw/XRIF17r0KdBe9MIoA97l2A89jjS+0
	BsCoqs7pKD5mo/MRw7P0urHlMsBiRJQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=HOfCUqIC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3W3rhagYKCDQZUVVnkWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jeffxu.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3W3rhagYKCDQZUVVnkWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jeffxu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793161822;
	b=qKrQRAmtxkOTJN45E8daDdKIIlMCpL3oLv/CsPjqePW5N0RI2JCaJrbSE8AyYt+8cOKF5E
	PlFDaN2BKapUMbAMIrYaXQt+o930t+O185E5H5WqvtunTZBJj4nOYtfBvj9EGWZ7GdfH5n
	lYlFSp1OKd6x+o9/H8dOTIxR9JmFLxA=
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso1038579eec.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793161821; x=1793766621; darn=kvack.org;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kPQx6GgboXmcUMcY5/lzKrJ0ssCkME3FTMDmy2U7T6k=;
        b=HOfCUqICXcBfhDcv8hi66Ni8QXbGbdG26YVFXc8F9TYkvMfc4ae8wSpvVA16ffnT3l
         oMvTv+muiNbNR4ApfJExnxBx0FIbME3vRAEYfaJ16SIZDGPZTXej0id+wF7m/lbrKBn1
         WF4u4oUsoUI2ws3ttAisMTV25i78vs8zy1m9fTTyTISHW8sY3QEYiyMTVKlplZsIWB7E
         6GKOA6inmLlzxChXWGkKSmtveFTlbiTTI2xlwGyhllfk3pBtEvFxPQsw3Lka04Cil4fG
         xx8gBgg0ZdIagbG8hp/oHWIHNM9J2r0Hz38s4VMtn2afcastmVrkNM54dq5YfMkHbeD0
         41ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793161821; x=1793766621;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kPQx6GgboXmcUMcY5/lzKrJ0ssCkME3FTMDmy2U7T6k=;
        b=K2Y+68Xu8vXkjHVuBwGkDKIBQ31UhxTAwhgR+H8j8TzjscPsZvwJEq1feds5yC5v3q
         sUNooRWKb0y1xMQwJlIMaciXh/A6cvDThGFXmj2D9JmeIhfQGsV1sWQ0amcp8n0K2PC/
         UkdD88T4d4TuhBXN9LNUMzbWyGN9MD24R1eR+KHLE2E50bMMdiM8fgf2jZF+bZGX22L5
         HhUbpLCCNb7lJ11c/VUInf/f3C9fDW+pzhjuZECzznJeGqcTLqgRZK/nHKQpfZjb0J4o
         24NRRgqQBXBSVNIDXQN2uJsNXr9/JdMJSpDT03NFJiRIrryVGJggepZtJyLuRX5QDNif
         fWAQ==
X-Forwarded-Encrypted: i=1; AKwUvByNfG/eXGgFHnSvZ9DLe8A24jRRoyGhJNsHTnafLEqsyDdorW2BHKy42ghFpNd9rMtHuiRSoTedfw==@kvack.org
X-Gm-Message-State: AFq9FYI9vdROXjpeu+ZkraSn9bI6ZCW5xdSulTshA0Vrv+7qMv3FkZQr
	dE99gnYR3dnKaYflSE2LNG5Gsu/LV0FTA+GQ9w1giovkilXJgatlWwN9/50XJP/5ekpkSJuJFpv
	179rkig==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: from dyaz12-n2.prod.google.com ([2002:a05:693c:638c:20b0:369:fbca:f640])
 (user=jeffxu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:693c:250d:b0:369:f5f6:36a7
 with SMTP id 5a478bee46e88-36a2014b887mr2079336eec.16.1793161819981; Tue, 27
 Oct 2026 21:30:19 -0700 (PDT)
In-Reply-To: <auDTptDQsB4xBcz7@gremlin>
References: <cover.1793094611.git.chris@chrisdown.name> <5bd3c89d733ad22224f296dfa8900769de937de0.1793094611.git.chris@chrisdown.name>
 <auCxjbvY3qPv1sV6@gremlin> <auDTMb6WMFUpxeZy@chrisdown.name> <auDTptDQsB4xBcz7@gremlin>
Message-ID: <18e2972cb8520c2e.3137322e32382e342e3434.279dd1.0000sendgmr@google.com>
Date: Wed, 28 Oct 2026 04:30:20 +0000
Subject: Re: [PATCH 1/3] mseal sysmap: Add mseal_system_mappings= boot parameter
From: Jeff Xu <jeffxu@google.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>, Jeff Xu <jeffxu@chromium.org>, 
	Jeff Xu <jeffxu@google.com>, Andrey Vagin <avagin@gmail.com>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Rspamd-Queue-Id: 1D4D1180003
X-Stat-Signature: wirp9dxu7oo86k7ww93bornjtso5jtf6
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793161821-54623
X-HE-Meta: U2FsdGVkX19enlwM7pjOKtfOTNKb/ScxQoIVp06PPc7Jy1TQeecdRGPsusI5mwftgCZJ9oLkF+xN/cfdM3SCbxCRRxV+ENqVIZGR9ylAB3t0vHFn0/gnWUoYOKvAbBeo3uH0jFxTS0XXxRt91mKwVrxVoHmJDFOhx4463Kmy1zd2FB8AYVS7/rhPd7NftJFE6H2e6AFeUMh23iUXjSASf1jw5QRTA77ucSvt8cUG2bifexkncQCWnCXIvuhyj6VPw9EGHyUvlj/d0lr3j+Z5Hxh5xE7iU6gwMce6a1BZGlyvHqSnJZduy73UXSwMBiaoAyntM2V7x65XfaSyqxDX76y6P1Fyp2wHT4EsjggnYjF4/kQZmrjYsjYSISZVI7yTdv3dQrSoqo6PCtrRU76DDyyjyK8oj81KTngeOdgylqyCzjZ6HbRmapXJOEmjO2qNZbqsShL0Z45n0qjGg/W6hhDSe8QDDkZjtn6kFfdg6BQyYt8fH1oFfWD1YUmx4twkeGjp8uGOu0fnhm7xgijiFJGmy+YtVBQNrnT0BAHVsa8poymNtRt827Ej14gtNlAo6fIGACKKuWKkFVyilXU3z7DpMFszAI0GfebpuKf1D6hBWxiGlbYaihTQWl+ku9BrcxFXISCVfSvE03AB1JNzR7KVE2QEiAfBpg230gQmzY7eSg1R+KSCEWGt4dc8IkCkCL1lR7zRpr6AAi6taRFTPdefNU8m7k0qFeHmZzinsd8WL8Ib52uBkZKEHeE2MRlP0+ETow4W2Fa3pczBzl/YIZ/zObEQQ4VgXfM384LJI4XJ1Q337qF4NF1BCse+zLEZAe0AdE2jVx/REeomjOOQ8vEv/eg5e8bWdpWlm1YapeGZRjxKUQpRavH3FXioDoDZ25GjTuGaDEn0iiV9VwQo9bIWJk+uf3UyrmrwIV4vLN3oiR6O6UoGdwAbkakdacuNPxVdzk6Muoq7pbyMOMA
 7I+hMvaG
 Gcsbs4elFVQ/TvyDaN+XJre3hCnKHd8Umk7WzN1gW0DraUveVV/uaHkccZMfIsWwdRZoOk5ttEyWv781rkDChXYlAAslBIA4oOwxISZcWQYZxq57IPpwtM8dlm/EEPluPgW32hv3FgGi+5BkXVUEsCx2cI4bYJv5TJc4ThAddy7aVD96OU4Zbf6s4BgCZ/sflGNyQzLSihNPJsIKrD6P/L2f6Q3x6JLJYmVJPiUEBZji9tqATZX1PK53v7nuvZU3i6Quygpi9FCz4o7B1c0CnOTze+eW3yswpa4jexhXs3xUT8LHGjnWAzqESKSY5ICsEFa5+ogLAA9i4pnKapq9XlAvXDVr1XEkvvx9AfnXebevnHNq8OefryOZ/Zgm3Bfp502P55D+WyOELcA06S6sFV8+GD2VjvwMf2N0BHh9hv8FyGLtPB8vSpjlTwQADlz+pR04pvpTIiP/xnGwH/CfHmkldCt5TwO8yA0aRl2ObdxS4YZ+RRiLYmicHB2po5Ztz8rFaFoVw4pBPEctcvw0yE+XSQ9UbmrgAN5miXOe3ReMbM3A0+RppHr4T7OJADqXTqahqYrBSaMz/UY5S8Wx6M9ninuh6oeIn1vHJ7fYPxR/N3vGLjfhDTdmMvizJv2wKjqqa3Ld+MbHeF/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Chris, Lorenzo,

On Tue, Oct 27, 2026 at 04:57:04PM +0000, Lorenzo Stoakes (ARM) wrote:
> > One option is to skip if [vdso] isn't sealed, and otherwise expect
> > all system mappings to be sealed. Then there's parsing at all, and it
> > also stops failing on kernels built without
> > CONFIG_MSEAL_SYSTEM_MAPPINGS, which matters more once it's in
> > run_vmtests.sh. The downside is that it can't notice sealing being
> > broken entirely.
> >
> > Another is to check /proc/cmdline for no_mseal_sys_mappings and
> > expect the mappings to be unsealed if it's there. That's only a few
> > lines now, but the test still fails on kernels without the option, as
> > it does today.
> >
> > Do you have a preference between the two?

> Yeah it's awkward, really moving the tests to mm we'd have to skip them
> if the vdso isn't sealed, then assume a sealed vdso for a new process =
> feature enabled.

> I guess at that point it's redundant to check if disabled?

Thanks for working on this series!

Could we please keep the test coverage for the unsealed [vdso] case and
avoid unconditionally skipping whenever [vdso] is unsealed?

There are two regressions I'd love for us to still be able to catch:

1. Kernel or config regressions when sealing is expected to be on:
    Distros/platforms such as ChromeOS and Android enable
    CONFIG_MSEAL_SYSTEM_MAPPINGS=y. Originally this test lived in its own
    selftest directory with `CONFIG_MSEAL_SYSTEM_MAPPINGS=y` in its
    `config` fragment specifically so that if a kernel change accidentally
    broke system mapping sealing completely, [vdso] being unsealed would
    trigger a hard FAIL rather than silently turning into a SKIP in CI
    (whereas `run_vmtests.sh` runs on kernels with
    `MSEAL_SYSTEM_MAPPINGS=n`).

2. Regressions in the new `no_mseal_sys_mappings` boot parameter itself:
    When booted with `no_mseal_sys_mappings` (or when unsealed), running
    the assertions in Patch 3 (verifying system mappings have no `sl` flag
    and that `munmap()` / `mremap()` -- and ideally `mprotect(PROT_READ |
    PROT_WRITE)` -- on [vdso] succeed) directly verifies that the boot
    parameter works and doesn't regress.

If we move the test into `tools/testing/selftests/mm/`, perhaps we could:
- Check `/proc/cmdline` for `no_mseal_sys_mappings` and actively test the
   unsealed behavior when it is set (rather than skipping), and
- Either enable `CONFIG_MSEAL_SYSTEM_MAPPINGS=y` in `selftests/mm/config`,
   or keep strict failure as an option (e.g. `./sysmap_is_sealed` fails if
   unsealed without the boot param, while `run_vmtests.sh` passes a flag
   like `--allow-disabled` when `CONFIG_MSEAL_SYSTEM_MAPPINGS` may not be
   enabled), so CI environments that expect sealing still catch a broken
   seal.

Thanks,
Jeff

