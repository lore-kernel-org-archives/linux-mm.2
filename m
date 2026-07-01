Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4448BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDE836B00B6; Wed,  1 Jul 2026 12:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8F506B00B7; Wed,  1 Jul 2026 12:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31EF6B00B8; Wed,  1 Jul 2026 12:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2086B00B6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:46:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0DDA11C7220
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:46:34 +0000 (UTC)
X-FDA: 84940786308.29.9B437EC
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id 22C8980004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:46:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GmgJa+68;
	spf=pass (imf30.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782924392;
	b=nWr3WdgNlJimJh/YXelUdhjkB0lAJSle+2ylv3CT5n3MTJhHMtdDpJZDn05sznvNT7rjr8
	z/MSfieq0o6nG4NbpheW4W5IpinzBFLt8gmI8eGzoufzukIGExNnDETSMgTFwY2CNZXfbb
	5W4ERkeDUgseyMBFQWK4zhsFGCgAnrU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782924392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cdd9rY5oP30RnQMgnsEDsM9Bt8UvFzdvGQmBfn+/Lf4=;
	b=l4k264xsENWul/dLIc4S1t50SA100cquJwsGJPS+MW49SnsAsHqSorIg7MjTPK30nSmDbX
	4aPqMaCEo1SkLUPPFZBRbP2ZXFmo4hebe8WGqCvCHalQDMKq5AtVuVOMmnbIwPDsUiIlPU
	o+QR27wqi/KnaMKnhT7T96wHkXDbkJU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GmgJa+68;
	spf=pass (imf30.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5aeb8c19017so1068610e87.0
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 09:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782924390; x=1783529190; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cdd9rY5oP30RnQMgnsEDsM9Bt8UvFzdvGQmBfn+/Lf4=;
        b=GmgJa+68aqgE1m/KS5rNQW+vIrykW6tAM46kBOS2TTQPBfpxQmMhkZ0i+D57OlxrEd
         zrsVrBCI2qt/ehGHfAwIj5XjxRT/Iz6Y5kinOPATs+cCRYx01WZwkeliGkasy5J0l0uo
         KZW2NKY5LOPKxcBGsAxezq9WhQB3diCDP5UUhV9iTQtmd0L58O5YzFDJ6SvajgTcIACa
         XQkYfqPT6vLbxE6SmZr0yaK/yjw9yRXW/XqxtFQNZxhTSnLi0y6Azgd1KBwOljJFD7NL
         b1+xsX3uu1qqLqsJc8nHD+xWubM0yHVq467um4NH+S5a7C1LYZfnN7iu6dR7is9hKEXB
         cP7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782924390; x=1783529190;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cdd9rY5oP30RnQMgnsEDsM9Bt8UvFzdvGQmBfn+/Lf4=;
        b=mk6XSYau2QX2uwCeNhvPKmPByIKwn7WB5VGLOcgjrP9UNLoybuZP7uezg+WIhVUQC4
         +pMQsCEZR0C0TqQcU0h4fley6xMxg6QjF94gA6jlXOqjzjlQxdF+cJwBjBjxo02Y7Ii6
         r2B1dCVbQGdq5Ln4vNwrV3xu16rUuIjKMOpSasKfPg26uYSEyeBRPProXR+4a8yAvddn
         ED+5WXvt0W6NTH8TWf5znQVtorMBT8ApTTg9tiJUXw5T/Kk5BPSGY0F8ZUh9fvsBiaNu
         o8B+baX9p7Pqr+B5SIEOvc9Xt40GA+patCUrjkwL2BF/Hhx184X1TIgG3YKt+zg7IyXu
         sAPA==
X-Forwarded-Encrypted: i=1; AHgh+Rq7tfblZjNPWCOzsAPKtOVC3WpAoHejcVNuXVP9ji0s+xQE71XkO8fogXUbohszEl3VA4i+1Rt52A==@kvack.org
X-Gm-Message-State: AOJu0YxPRg5yd5b+1BW/aobxC1CGcE86oGDfjG+BY6KR4lHkIyvcsMXq
	6f0WzgpDmGn7Bsj8CFj2PHYQXH2wIF45Z44PIeTLCIsvjuHsM9OqmwDu
X-Gm-Gg: AfdE7ckK2VGtB/Rk5AN1PgPtZJ03X5ZhAG+JEQGgrmveTVV6qWwI8K7i53OHFLU7qKQ
	mYWVBSeIqPdMeLMwPV8SscNEzXqQ+O3AJVhg1xXU/MdPDxa6HfsrzrhqBDBO/pErXVMm/wH24mz
	c13OPOLVrDZPLvMQ+ut/aFPNlJXBmI+2/hm6ru+PHgEu/KNhuAv4Sd3qCigKCMkkE0MGjtklDdP
	fv6PYaHuZwbBU8SIo7OhypU7vcnHr4d0HF502w+veW5iOBV0gS6+TMcafR3srX+J/GsZ0fI3GVq
	8pysurv0/NX8mkDelEj1GTJtl/dTObE9nWBrmfnxW9QcYmNjQggdu7zrwo7n8CLd439n/TpZkkw
	SvKSGKKfZhm2t1DsXG0grOMRnOFj5EsjeWsN8zVwa1vYVIweMONf6ZwDRcKx6vRq1c3Z1FQReMj
	wLjPC4E5eh8Y0DelWA3THyqEMlNn9hP1mbDbSMEw==
X-Received: by 2002:a05:6512:22d8:b0:5ae:c099:a92 with SMTP id 2adb3069b0e04-5aec68b7ea8mr494950e87.42.1782924389903;
        Wed, 01 Jul 2026 09:46:29 -0700 (PDT)
Received: from localhost (soda.int.kasm.eu. [2001:678:a5c:1202:7b92:9ac1:b9ef:5287])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aec894e5afsm140232e87.0.2026.07.01.09.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 09:46:29 -0700 (PDT)
Date: Wed, 1 Jul 2026 18:46:27 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: david@kernel.org, richard.weiyang@gmail.com, akpm@linux-foundation.org, 
	ljs@kernel.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, balbirs@nvidia.com, sj@kernel.org, 
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [Patch mm-hotfixes v5] mm/page_vma_mapped: fix device-private
 PMD handling
Message-ID: <akVDNLGaCfr-PF8K@soda.int.kasm.eu>
References: <d4e4180e-dcdf-40e6-b5a2-2ac55f4aecc4@kernel.org>
 <20260701163356.22936-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260701163356.22936-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Stat-Signature: psd9uft4ifzsjzhch76kwdm14g5tnxoe
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 22C8980004
X-HE-Tag: 1782924391-197439
X-HE-Meta: U2FsdGVkX1990jN4obIrjYdMOtsIIquRWlpQmxt33IBLZu31WeMeguL0amHYdRfsR1xXhuU5XpDuLB2+aZTmZK/PveIfHVv6ky7HGFZ2l4qptuDgBhf0h/KmsaRQkoV3Y4UT9nuSXUnZ/pjA3UC1kiyfZcdP/hNfRIlIBMhZ/ksJJ1MVG+NKdm+1mqk68zMlRY7J/X05d/N4hY8YNQilSytDR/hffVTKYdDTecjeE6JMRg4mRpocNEzXlSo/QM4kKHqtesx1fU+n89byLZz0H5DTKNNjx5D9SWrV8Z/P0pYCeNhm7hMJU1CySkBCp9MYxx0/N9Uwbo8Xkbx+utb1wL2xf7wG4jCaIOt+w70payNB/nUg2t6l+o2oZu9k6rwZIm8c7n1Th/9YFWDKy6Z5NirdUWm/zGRJVsP9VZRXTcSu85TGpKPsGw+YpH/Sk7qbtsbfcMyMwr+iNgOjkQUcFUIZ/R6zXkVoVSR51OQjxI19Mqgp/+mTSAIwbhwpVyRandoK3yz38wN5e9Y7bJNfkXeLk8/Qrj1mwkzEGuCYMzAH4pAXuJDuUswSzuo7qQ2pXuRoaQlwPOkThfCUxyS8Qemoy9+yGcJ4vV9BK4a8uIjz25VJozXEWNKP+0Lsfr4a4Ii9q5AiAxi0UBHfEddJlVwWywwhWdqzaPCsOVLd+AUECIG0FnUQ9/TEk6Gx7ItG0F/aCn+zcpIpeGMfEyBzKLpXQKao4MoiXXwy/ljUP4kyN5WcMP9BzDQsGau3erCzkPzrFtnJXa4kTheGvxbd8ILRMd8uOwNDpKqoiZhODFlLkvMUNA1UmoPf677U7DsYSUdH9CkVCcSZBqaiLj2vQL9xhaBd5RUUpD4+hdNnlGAiaqG9YmiUu5rWM60sBjuYS3Jpx5zYNXjNokkyLrJTWOfGLH/nJauPbwt79LIwv+2CnoS+c4Nyi+X1u16Ic8rxlVvzeHiOTYmDRVhvvHp
 b3n1WJfk
 JpuBe1mJIbKk77pb8fISjB5ZBBqsYe1Cs8qFvVbHLdI2eTLg8DfVwULJpBpvD/5LNFFhbnt97KBPV8SYnzlgbsBnC1o9x5cKhpxX6F4ht0ZUlcwIQyStvVuAPqctfakxKxrbu93tVqyFym9wLgOr6702JX8cmNTi0UXgpC+AcFo69xGJ9CfbX+7MkbNuPu6xbW84vKG89J8er1/vEgPto21OzLY/LQsIg8tC6s3sH24sgjCXjfGVWFNLwqlK6TTtBFwb/GLaaCsB21nCBzzTrWtreynFcYt0HFT1b8D209k7ejrx8GjipBOEfTyVE3AvmMY4bLXwFkLx+I0rJHR6BVqrjUwWdlHv9jZnSz3hyZuiFnuef0dKh5X48RApnuwkr+h5f6XIVpVfNZvK2lOsoz1N/6Qu6nstMXaYNA0j1Tcd0KgUbS212A2j/lw71yoaj2/5WQafiC9v6WeupCY1fl1rowcXKqDkPBGbh5VlRJ0CB/McKxWGu4bqJz0vXoaTgSOD4YzgmKli7UQjlHCCBRinNJsbZm7hvy48FkfPpbwTQuasCnwtjn83w2ogahB4xzMns3I5Ofwa0n15ZdhoFuEyy2XL6CNN/ZSYa4WXkxmMPvJXWzHbTV54uwZhepTuMPRWLwcqGaRnV5C08W0uG5HYKve1+m5wjX/G4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-02 00:33:56 +0800, Lance Yang wrote:
> 
> On Wed, Jul 01, 2026 at 05:36:33PM +0200, David Hildenbrand (Arm) wrote:
> >On 7/1/26 16:33, Klara Modin wrote:
> >> Hi,
> 
> Hi,
> 
> [...]
> >> 
> >> This results in a build bug for my Raspberry Pi 1:
> 
> Thanks for reporting this!
> 
> >>  In file included from <command-line>:
> >>  In function ‘check_pmd’,
> >>      inlined from ‘page_vma_mapped_walk’ at /home/klara/git/linux/trees/bisect/mm/page_vma_mapped.c:256:10:
> >>  /home/klara/git/linux/trees/bisect/include/linux/compiler_types.h:702:45: error: call to ‘__compiletime_assert_433’ declared with attribute error: BUILD_BUG failed
> >>    702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> >>        |                                             ^
> >>  /home/klara/git/linux/trees/bisect/include/linux/compiler_types.h:683:25: note: in definition of macro ‘__compiletime_assert’
> >>    683 |                         prefix ## suffix();                             \
> >>        |                         ^~~~~~
> >>  /home/klara/git/linux/trees/bisect/include/linux/compiler_types.h:702:9: note: in expansion of macro ‘_compiletime_assert’
> >>    702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> >>        |         ^~~~~~~~~~~~~~~~~~~
> >>  /home/klara/git/linux/trees/bisect/include/linux/build_bug.h:40:37: note: in expansion of macro ‘compiletime_assert’
> >>     40 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
> >>        |                                     ^~~~~~~~~~~~~~~~~~
> >>  /home/klara/git/linux/trees/bisect/include/linux/build_bug.h:60:21: note: in expansion of macro ‘BUILD_BUG_ON_MSG’
> >>     60 | #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
> >>        |                     ^~~~~~~~~~~~~~~~
> >>  /home/klara/git/linux/trees/bisect/include/linux/huge_mm.h:113:28: note: in expansion of macro ‘BUILD_BUG’
> >>    113 | #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
> >>        |                            ^~~~~~~~~
> >>  /home/klara/git/linux/trees/bisect/include/linux/huge_mm.h:117:26: note: in expansion of macro ‘HPAGE_PMD_SHIFT’
> >>    117 | #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
> >>        |                          ^~~~~~~~~~~~~~~
> >>  /home/klara/git/linux/trees/bisect/include/linux/huge_mm.h:118:26: note: in expansion of macro ‘HPAGE_PMD_ORDER’
> >>    118 | #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
> >>        |                          ^~~~~~~~~~~~~~~
> >>  /home/klara/git/linux/trees/bisect/mm/page_vma_mapped.c:142:20: note: in expansion of macro ‘HPAGE_PMD_NR’
> >>    142 |         if ((pfn + HPAGE_PMD_NR - 1) < pvmw->pfn)
> >>        |                    ^~~~~~~~~~~~
> >> 
> >> bisect log:
> >> 
> >>  # bad: [be5c93fa674f0fc3c8f359c2143abce6bbb422e6] Add linux-next specific files for 20260630
> >>  git bisect start 'HEAD'
> >>  # status: waiting for 'good' commit(s), 'bad' commit known
> >>  # good: [dc59e4fea9d83f03bad6bddf3fa2e52491777482] Linux 7.2-rc1
> >>  git bisect good dc59e4fea9d83f03bad6bddf3fa2e52491777482
> >>  # bad: [6148219e90732fd06f5d7a498bda974e6a43ab4b] Merge branch 'nand/next' of https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git
> >>  git bisect bad 6148219e90732fd06f5d7a498bda974e6a43ab4b
> >>  # bad: [e0326ebe10191447ab8fa2e904080df7b743765e] Merge branch 'for-next' of https://git.kernel.org/pub/scm/linux/kernel/git/soc/soc.git
> >>  git bisect bad e0326ebe10191447ab8fa2e904080df7b743765e
> >>  # bad: [fbc9c5ac47cef5a2b04aef30c8e990b32dcf2548] Merge branch 'hwmon' of https://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git
> >>  git bisect bad fbc9c5ac47cef5a2b04aef30c8e990b32dcf2548
> >>  # bad: [e488171f6f6df6fc899a355079665fdb3c50b0e3] Merge branch 'for-linus' of https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git
> >>  git bisect bad e488171f6f6df6fc899a355079665fdb3c50b0e3
> >>  # bad: [60db0fcb8fc9d80ac0b63041c632b41a311a45f1] Merge branch 'fs-current' of linux-next
> >>  git bisect bad 60db0fcb8fc9d80ac0b63041c632b41a311a45f1
> >>  # good: [51021d260d682aa17b3533848a99160ab83e0c93] Merge branch 'vfs.fixes' of https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> >>  git bisect good 51021d260d682aa17b3533848a99160ab83e0c93
> >>  # good: [ded56474db6552260786a65898322464b72c7540] mm: a second pagecache maintainer
> >>  git bisect good ded56474db6552260786a65898322464b72c7540
> >>  # good: [6c893b948351d42cfc3761cc746ab5b3d03ee7f3] Merge branch 'misc-7.2' into next-fixes
> >>  git bisect good 6c893b948351d42cfc3761cc746ab5b3d03ee7f3
> >>  # good: [bfcc55a14179495b0c41408908fd7b9d7785c694] lib: test_hmm: use device devt for coherent device range selection
> >>  git bisect good bfcc55a14179495b0c41408908fd7b9d7785c694
> >>  # good: [a27318567c92ba5482906d047e71a7aa4fd01889] Merge branch 'fixes' of https://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git
> >>  git bisect good a27318567c92ba5482906d047e71a7aa4fd01889
> >>  # bad: [6887a39652cdfd4cfd3b0962662c9cbc26ce5252] mm/page_vma_mapped: fix device-private PMD handling
> >>  git bisect bad 6887a39652cdfd4cfd3b0962662c9cbc26ce5252
> >>  # good: [2cc6bd0efc264b9ac760c2bc74dff4f521a680a1] MAINTAINERS: s/SeongJae/SJ/
> >>  git bisect good 2cc6bd0efc264b9ac760c2bc74dff4f521a680a1
> >>  # first 'bad' commit: [6887a39652cdfd4cfd3b0962662c9cbc26ce5252] mm/page_vma_mapped: fix device-private PMD handling
> >> 
> >>>
> >>> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
> >>> Cc: <stable@vger.kernel.org>
> >>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> >>> Suggested-by: David Hildenbrand <david@kernel.org>
> >>> Cc: David Hildenbrand <david@kernel.org>
> >>> Cc: Balbir Singh <balbirs@nvidia.com>
> >>> Cc: SeongJae Park <sj@kernel.org>
> >>> Cc: Zi Yan <ziy@nvidia.com>
> >>> Cc: Lorenzo Stoakes <ljs@kernel.org>
> >>> Cc: Lance Yang <lance.yang@linux.dev>
> >>>
> >>> ---
> >>> v5:
> >>>   * put device-private pmd handling along with the other two cases
> >>>   * remove thp_migration_supported()
> >>> v4: https://lore.kernel.org/all/20260624065353.1622-1-richard.weiyang@gmail.com/T/#u
> >>>   * refine subject and commit log based on Lorenzo's suggestion
> >>>   * put pmd device-private entry handling in its own if branch,
> >>>     suggested by Lorenzo
> >>>
> >>> v3:
> >>>   * remove cleanup part, only fix the issue for device-private entry
> >>>   * refine user effect description based on Lorenzo's suggestion
> >>>
> >>> v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiyang@gmail.com/T/#u
> >>>   * specify the possible error case of current code and user visible effect
> >>>   * besides fix, cleanup the pmd entry handling based on David's suggestion
> >>>
> >>> v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
> >>> ---
> >>>  mm/page_vma_mapped.c | 30 ++++++++++++++++--------------
> >>>  1 file changed, 16 insertions(+), 14 deletions(-)
> >>>
> >>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> >>> index 2ccbabfb2cc1..2d6c58488e3a 100644
> >>> --- a/mm/page_vma_mapped.c
> >>> +++ b/mm/page_vma_mapped.c
> >>> @@ -243,21 +243,30 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> >>>  		 */
> >>>  		pmde = pmdp_get_lockless(pvmw->pmd);
> >>>  
> >>> -		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
> >>> +		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
> >>> +		    pmd_is_device_private_entry(pmde)) {
> >>>  			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> >>>  			pmde = *pvmw->pmd;
> >>> -			if (!pmd_present(pmde)) {
> >>> +			if (pmd_is_migration_entry(pmde)) {
> >>>  				softleaf_t entry;
> >>>  
> >>> -				if (!thp_migration_supported() ||
> >>> -				    !(pvmw->flags & PVMW_MIGRATION))
> >>> +				if (!(pvmw->flags & PVMW_MIGRATION))
> >>>  					return not_found(pvmw);
> >>>  				entry = softleaf_from_pmd(pmde);
> >>> +				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
> >>> +					return not_found(pvmw);
> >>> +				return true;
> >>> +			} else if (pmd_is_device_private_entry(pmde)) {
> >>> +				softleaf_t entry;
> >>>  
> >> 
> >>> -				if (!softleaf_is_migration(entry) ||
> >>> -				    !check_pmd(softleaf_to_pfn(entry), pvmw))
> >> 
> >> My only guess here would be that the compiler evaluates
> >> !softleaf_is_migration(entry) to always be true and optimises away the
> >> !check_pmd(softleaf_to_pfn(entry), pvmw) which is why this worked
> >> before?
> >
> >Weird, we enter this path only with
> >
> >pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
> >pmd_is_device_private_entry(pmde)
> >
> >If any one of these would compile for !CONFIG_TRANSPARENT_HUGEPAGE that would be
> >odd.
> >
> >pmd_is_device_private_entry() is hard-coded to false unless
> >CONFIG_ARCH_ENABLE_THP_MIGRATION. Which is only selected with
> >ARCH_ENABLE_THP_MIGRATION.
> >
> >pmd_trans_huge() as well.
> >
> >Maybe it's struggling with pmd_is_migration_entry() on some (older) compilers?
> >(not innlining stuff and not properly optimizing it out).

It's a GCC 16 cross-compiler for armv6 so I wouldn't call it old :)

> >
> >The whole conditional must be optimized out.
> 
> Right. Kinda weird if compiler didn't fold
> 
> pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
> pmd_is_device_private_entry(pmde)
> 
> away here ...
> 
> >We could check for IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) right at the start
> >to make it easier for the compiler:
> 
> +1, explicit THP guard should do the trick :)
> 
> >if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) &&
> >    (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
> >     pmd_is_device_private_entry(pmde))) {
> >
> >
> 
> Klara, could you try with this change and see if it fixes the build?
> 
> Thanks, Lance

This does indeed make it build.

Thanks,
Klara Modin

