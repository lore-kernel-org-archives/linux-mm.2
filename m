Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A53D3CD98D2
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 18:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2E4E6B0088; Fri, 12 Jun 2026 14:48:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06A56B008C; Fri, 12 Jun 2026 14:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D056B0092; Fri, 12 Jun 2026 14:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C12DD6B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:48:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C24E1C10FD
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:48:32 +0000 (UTC)
X-FDA: 84872146464.28.2F6DE85
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8027340002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:48:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PKwtfbqi;
	spf=pass (imf01.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781290110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u4v2sfLHwc/NOGR7NmoDpsShvoSppPDh7E3Z/FyHNaM=;
	b=dLlf7bnGvoARwa/naIDaNIM3JNXEnHbYKtAWNdYN+bc/ndwnTqE2rJcja2ilugQ8ldZ2gy
	dcdq2mvmELK3G2LaJmFh3c6NJToBwPJKnMqzxT1Hw1NbmyYvSn2FQfqR3wb6g1cTFJqL3d
	wSxpiwoCGrXBB2JqltrayF0ALYt9XoM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781290110;
	b=t0sqPe8ZXO3SsdM5ElVb+aTe6vbWg1Dlh/gUM63pGTSrPTO7KT0gJR0P94/Y2t6nyym6SN
	Dx4780TCqXjzGDQjIRtWpmpW1s1PUjTZhiLg2+fjW35r5zra2sVHnTG7c8koJjCuquFodm
	we6ryH8GqCJk8HdaRG30M3PtNmx4pWE=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PKwtfbqi;
	spf=pass (imf01.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-43d23173511so813653fac.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:48:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781290109; cv=none;
        d=google.com; s=arc-20240605;
        b=giS0JWZekQabtkR5VyoGm/JAF+u6g9pmi1D0t1aDL7ham9N4gOfzIwLpelUrbOrFxK
         DoHWnMXotGCqG66J688UDWEsUR6BxVqYq+SJVGI9RFqJn8mUlib/oKV/p+ACMpbhs9Uf
         NKjQ6lNzKiE1GxRqsrWhzCngbCO/0+6ACJ7A1Q7nguyjZiTmTuNF/QSbNEgEg4wEfxpT
         wLDkY0tg/LrTU6oY1VJB2A4b9KYFOl8zpBR2v+ODi2AwFxV2WbwJJlVTdYZ4UJZBQXw+
         pcZmFXbnZUuGqcVzS1YuxMTVsyUJM6YHGnSlQoS4QAYtcKl1+ZWSoJ9LLEcnJPI/eZj0
         vJpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=u4v2sfLHwc/NOGR7NmoDpsShvoSppPDh7E3Z/FyHNaM=;
        fh=Pequ5utJTcCODSf5RT39vYU/biEA9b5YdQ9ABRpTRxU=;
        b=llhS+I18VHuWQomBl2T8Ia6t4guurJimcq7s75gYNUhxq99PgxWGdFH8Lw/UBfYAyn
         ieieg8d8fmXvlcLQH11/iQS/ZkBVApKpTPbNMtv3gq3mIzPfZVmRQ3ItqscjObX6PxSS
         4++0Bwim2zUIq8pVg2do1mzpbDvptpCEmVRLn/b9wFJN6cZhEwg+aJjkZiIR9xq+wAsJ
         9k2Lq6EUVzOjGknXMyUsRmrmPlR7If2vcdYd7Vr70Tpq1iVjwhCsJPXDGSKq/YztG3gf
         hjY2Us7OJHVT13Bug3Uzav0/YGvq8dUkp+ugYzVpzuCPsOZnsU4mdnFG9ZeW//YtuRaO
         JKZw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781290109; x=1781894909; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u4v2sfLHwc/NOGR7NmoDpsShvoSppPDh7E3Z/FyHNaM=;
        b=PKwtfbqiEtASkzFDEE9KgEG3RxRPGlA6SnVulti7u4+8kCLOtMG+qzQhSxd242bv0r
         fSeydiFqaaWio6nqEc1k1cGjDUCExMV/qic50vTBijedB5mfs3OOMAY25xd1dhMVLc98
         6v8U7LSJPgYGxMn5r1FoAlfCGLcb9pRF9WdUvzGQxdo/FGzTGB1npMBEsIeoeQTZhFJQ
         2Yp5QWJ06M+LvscdQtU2L6B9i47pAHTJgdABPLHWyMi3sRaTxMSZ2JZOoeIMMyKmUTpb
         U8cjr/LMssXWtvzXWCxf6TMXaN4YlKfjM7KNWEspVJ2tCY0Yx4+OdzJGwuNeKlvmR2A8
         Ivhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781290109; x=1781894909;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u4v2sfLHwc/NOGR7NmoDpsShvoSppPDh7E3Z/FyHNaM=;
        b=OaCp1ZAg6rSxDOQKlkjtr9qZabN7Lq1uXyVh5viXcb8GBRe2tYWCSd5tgcofJu9Kkj
         +1kgKHD3EQ+oYsJyhiDKnPLodUsY2T8zwm5e7yHNfbc2zYppNcxDhjGVLq+jX8pb/Po3
         9u7DkM7iDrP6PFWtXGrbW9qQ+HzeCo1SBWZ/gIBpeyswe4n/Pu7wVJR/JNXO5hgpA6An
         CHSQz2SdKSW83OftbIAIWe8Ri+cUIRF/cZ6QL8eUkszPxJWkRpAj36gJcqVrG9FLABfY
         6bJQgT7ScVqKXhsZ0AzFvQkAZfGYKPmO8rcT8PS5cT7MBhyjc/aQkQ7JQojhkzin6JL9
         6tNA==
X-Forwarded-Encrypted: i=1; AFNElJ85VjXp3jWV9QFys5ggkNJ9MmEM+BBG7yiT8Nb2J8fI+eIRaMsDc0DKgcz7KbJIN/YxDBFxWHYpIg==@kvack.org
X-Gm-Message-State: AOJu0YylCKsl7PNhouUmup+yjnXWUEXE7syamMw4B17jb54S/mF3PTfv
	tjB6GJpc3oRKRFSWB02Sop0Wbj7ewXDTsQgkRKBGP4me5s22XvRPOg2zZRhNPsaKE15gkbGOenX
	OhEn59D2vynhA1NAxugzVR9wraRm/mZo=
X-Gm-Gg: Acq92OGMHUCqMsDp5YO3A5NByz5UMJDnA5PrlZRYnbfaQu+qScYlyndBCf7FK7jwJWi
	MsmJB2ccknUK3zx5ls2TKgeP358pVcAZjB6uClTM4bqLsGxeP9TGuH31S4Yshos9RhPAVf8Fj14
	ru+sRaeeoCR1VJ86lkwL0B4odHykZr+ke2U+MbwxsaLKpdu1tUBIc/8ElnBGq93DR3VwW1fOoGW
	UGNstYv/I6eOgHnOoE9Ar81ctyWm/2+hxR6Gd60Xzs4b05CoV7xMemAQ/gDKRBDtbUpQndeEsdR
	KpY7McJbbSHW4oN89L755ts7jSRn6FqF4/qSJr2wiWyPVEhg
X-Received: by 2002:a05:6871:630d:b0:43d:108c:7138 with SMTP id
 586e51a60fabf-4426dff5268mr2263728fac.21.1781290109289; Fri, 12 Jun 2026
 11:48:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260612091215.b06dc7dc9dc894a5bfc75429@linux-foundation.org>
 <20260612172356.356894-1-devnexen@gmail.com> <aixGczWMAWoi0e5U@lucifer>
In-Reply-To: <aixGczWMAWoi0e5U@lucifer>
From: David CARLIER <devnexen@gmail.com>
Date: Fri, 12 Jun 2026 19:48:18 +0100
X-Gm-Features: AVVi8Cc0aJSXxfCuFpFz0T019t77IBO62kWMgVi03uIOX0gnmGedbVaZ_r4VBhA
Message-ID: <CA+XhMqy2Hq-LO11Drcj+o=n2D+czv-R=e223m85zzz7wcgz-Vw@mail.gmail.com>
Subject: Re: [PATCH v3] mm: pgtable: protect lockless kernel page table walks
 with RCU
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, 
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kevin Tian <kevin.tian@intel.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Dave Hansen <dave.hansen@linux.intel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8027340002
X-Rspam-User: 
X-Stat-Signature: rp5g3axi6w4kszm4wrqjeggbd7tnptwz
X-Rspamd-Server: rspam08
X-HE-Tag: 1781290110-767563
X-HE-Meta: U2FsdGVkX1/si2gSiqLOxXUzha21xsmPlefiWTkNV2iM501r5ukIvNLx4nw7hM+Sw2XsajbJ2iXiGY7ua4TV18RKeumQ8ndG6sm3H3Au4GOL42p4gcmrujDftohqb4aB6R5trt3+8xR/R2JUeq3wM5KD2lLnLRGiLcjHyuOYX5KuiA+D4AqpquJSt3q0ouYS0+a5W27ktyqiDDtcNGHcc5HMax8+wcKk2tPbsNVNzIx0ct2AZdiMD9nH8xCAqGj7a+1FopnqkKph5DQTLFcbb+c67zUrqh6g1XZBbCxjC9d2H3V9ZyxsCI7lBuGI9p94PCZilLTPO4EteW4d70c+3FSiXo3Ie+CCx76lhygbfeBWUXuu67oxibEqslZPsSBad/XptuyTww57tbRSkwDciMQMigzXwUZcp/bKs8jlhswpL+mJSe2tvCGv2Ymeacegoc89cV+KV4q11WU1ACLln1bN7YSumijbKjzOqjHmn3abiO2NNuc+BRQBslHwlM5puFOCVT/HVbi5GSRnkaR60Ikh34thFUJgXpPRmfNJX8gPdmjv/gC0o2ZoXBX1aHZwFDt4kULU2UN/YkO/3myPpPtPlSA4Qa32yOAzFKmgO4OIH1bUwiFqduCOYF8XVE178IOcLarQO7o92PGayCM46ewpovavVIIA0e1qF0Po0U9rJGoDRwSwEbqg5i8D7AtJ4P4TVN2RCkdIwBD3wcSPcqSSn+BeacxrQnyvHcPQp6NsEFhTvZ6JA5pYRT3S2CuzvbZG7ceWsoFVWJuHq3t/OmxbEp7HqZuANHHPY97hPYsY3Cha44rMw2tp9FklqfMo1jI7rfnGnWliCju5jJrHfnpFYsjvcsbhRIc47WLZVPWo8lCy9NMOWO1RBAWlLcl84ckKqtFLJ8J8tiG8Sn30DG/UrnnNATs0a2STXIVpIPad/yy8RgZ4itHk9hN83mbCNtdMVMFVkUReG1q9mbN
 XRx/8SRS
 4nMn8RZHWXNuCeEcDjfl4MiaMKh3/VV3CH4poNoMTmGeEBRHEd9g+yjfLgJigzmtzR2teGpQ2PCYWEwU5qx1xELrYwaBKnf1EcQXXghYvTNNIv+/NlnVCdez/KFXZzA1ei+CbGRH6jpTfJE4dKdxXSUGilDHCQK3rS2Y6nheCVSbIzQ7VuO3WQzcQffBlY7Xx2FsN843MNBxksbFTxOSP7rrwkZ3RANnOxXp1oicx9BqLh/3Ne/765trFop8mDslkknYIq7ULNvo2G3Cv/xuSv2DwxANzZg5QP6HD0V1G6ctEMG5Bmlr5RB2xKsT35a+zNb55HDjOI3aI9F7RXvgu8tKoKsmHwkLGCnuWbURkMmPceEn4gdeNEKsVOlvpW83LJgYcV+MAsj5HgHajoidD/2AAcuZhSfO5KDwRegdmhdceuFvxC48jcaZxRA5urjNjlXbG3AOtMSqfyr93ubDVOaMexrCLMXgiGQDYUo8g8O6BxA1af0cEQtb/ERUOsMEs25TpbHKMtu4YaJC4yf9/gPZlOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> It's not teardown is it? The only caller is vmap_try_huge_pmd().

  Right, it's the huge-pmd install collapsing the pte table, not teardown.

  > And if !CONFIG_ASYNC_KERNEL_PGTABLE_FREE then ... everything's
broken again isn't it?

  Yeah, that's the real bug. Non-async pagetable_free_kernel() frees
  immediately, so the rcu_read_lock() does nothing. v3 only ever helped the
  async config.

  > now we're unconditionally waiting a grace period ... this seems... silly?

  It only fires for kernel pte tables freed by the huge collapse and by
  hot-remove, not every page table free. User pte tables already rcu-free,
  this just does the same for the kernel ones.

  > why the arm64 page table split path is safe

  It only walks the range it's actively splitting, so nothing frees a table
  under it. Same for the other walk_kernel_page_table_range() users. ptdump
  walks the whole kernel range for the W+X check and can't take exclusive
  access, so it's the one that races.

  > I'd rather you add walk_kernel_page_table_range_rcu()

  Will do.

  Resend standalone in a day or two.

