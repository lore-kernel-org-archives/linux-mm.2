Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0949F606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ve+Hyde8
Received: by kanga.kvack.org (Postfix)
	id 192546B05B7; Mon, 26 Oct 2026 09:10:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169A96B05B9; Mon, 26 Oct 2026 09:10:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05A066B05BA; Mon, 26 Oct 2026 09:10:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D894F6B05B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:10:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 67CAE80732
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:10:46 +0000 (UTC)
X-FDA: 85364812092.04.8B85CA7
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 78E9D140011
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:10:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ve+Hyde8;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of elver@google.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793020244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QTkhF8AZkeGXg887W3q7liojKnQudM6PWhmi3F33YG8=;
	b=bKVlkN++T1TdrPnIqDSMCxWZgnD89KskhosB/Il5wdf46Oz3YG6bM3OxNcYy+FOTOAuZz6
	Vot1fQ1SKqfjWcJ8t5qCeHSWg9oLvTkBc9JTJq/gLThp8bZUjtgGAEj9v3+fWIvcoqySbW
	FMQNWMIAuZIRJOobrF6RJ8GQfLz3roo=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ve+Hyde8;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of elver@google.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793020244;
	b=aTXafSlQf6uUli2f1VIhcHVzvocjzwNCLzmwQUmQ+6mDNtRN80eLtXkqLqhrNXAjwFjPZm
	hnfG0vrkf2e1tgGRXoxT06+PSSdZ8X57KuNwtQR1TpXn9Oxoe7KU7od3t60PrTIqU1yiDX
	kNaTUvQLG2Ll9xvn3s2AujT5eEha4pk=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-14fc585291cso1354680c88.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:10:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793020243; cv=none;
        d=google.com; s=arc-20260327;
        b=SqDXEnXDjlomklZYZAYzFmr0LLhd8eWtVJ5qLHJK+gvsKsTlllFLYYFZZljPDx3iXm
         Sd5pVXenEj5cLE3g1ktpkryzpzFzi3CG50w0EpdDM91tpsHk8GnO4z/g1d/zI68Vby2N
         DYa/DUWPdS/xwaD6TFg1ndThc4l3xNrCwe9igx7HaVHs/vv1Dxvxrzqr0Bdxu/B/WPbC
         6hv2E0P2xWLD9kAyvoJ5/HWuFG470mMOIZBj+U2Jv57gNXc2w2Vm8lPPSKUG6zs5hUaE
         upIxLscpKWAcjDTeQhYhSukAP7cOhnv4E/kYsbaOaHg94wm+9OhSDUfFjaemG2cr4Ca6
         WZQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QTkhF8AZkeGXg887W3q7liojKnQudM6PWhmi3F33YG8=;
        fh=RpJS0JiJQs/dItvoq05l9Sf0ZsCiZCJcqmE39SYqeKY=;
        b=Mhl5E9XMGc2xrcYF0b9PyDxoPZnfPHW5UKpxMF5f31QuIq40/vTtlL2Ev5O/yaB3xi
         eWvA96Ty2yAhF2EXbMvzJ+z3NC54xwbw6Bd6su54NiXtRBVn4bJzhjBfXm6/V9Rqo9wT
         L6/TxFpMAvT/cPS+aG2d6q7aQsvgNm+ChS6wtKAdJjBaxN4Tuxr/a7JFXZ7Cmdos2plT
         ITCUrYyQFvfZK62bplo9ri8moPGMHx8cM57fRxSTllbhQ2CXsF/9fkbNox+hcEzH9IfS
         /+p4R7KmCWvCZ7ByxRUnm0+i0iFh5TptBeA1L3jw02PRePCwWBtHHRcwCEd/scryorbf
         qXlw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793020243; x=1793625043; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QTkhF8AZkeGXg887W3q7liojKnQudM6PWhmi3F33YG8=;
        b=ve+Hyde833XhkX2jn959oVx5hmncyxtkHdKIKrJFSMMqREy/fowPBzEFb6pm+AVzQE
         Fws26mL6T8CuifDK6bBkiX5m3AYBLwe0bu+ma8jNoH2F9GmtPLPwukJ/gQGhfLN5+9us
         oA1TmvplhjxqIA1c9a4Ohjz4IxBj2h8PAXq9oGMcZ2LF4KqTj/Q+/28Pg17iLH3cD5zg
         VgDBCpVcBXz65RzVzAvFEhWmNqDnK55PS6vgB3TUIK0MSOdqL9NpbA/A7OtCh4SvOUzM
         M0ZOPAizlHmLvAZ5GepshHLRyY5NB7q3u49iuSuo+Ull824g+jhzq9fqt/tqXfzbGIxj
         IScw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793020243; x=1793625043;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QTkhF8AZkeGXg887W3q7liojKnQudM6PWhmi3F33YG8=;
        b=LDHB+b7IuFNX+3ED4U5HkxuAwPZT0eF+VbjmSXadQviShAYOhOeb6aZXs4nYBSeI6e
         +/N57Prs7lSk/FY4Db32zQiFZnRY1sCH8EdPSj27HM9sqTH5hYiejmLq/SJzK+j7Zrcf
         JEOZGUH3rva9yPzshBi76JndZ2SmHlC2emns2IY1ApO0HaKPCqXXigh6mcD7PA8tUQYC
         p/6RzAcRlNtGuDUcU11zojmBGCEZfCO1otUridImCKtlb2YRYSuallHXe8XaZU/UM4Rl
         NcCDcaiySpU1IqeX+uRxXW37Ptb4kEHk1Hoj4rDRSGg0b4wm8BfhqcY5vpTyDQKJZgW9
         T07g==
X-Forwarded-Encrypted: i=1; AKwUvBwH1g4pLPLAXbO5jjf7hQgehiulNN4m2MCDKW63s72lPl6oVM5XGRMTuwyNH+T0jjpua+tQVxihvQ==@kvack.org
X-Gm-Message-State: AFq9FYLGAQ/cu/PGInC0IEep/sMX9WAkDefPTBH+sBG/mOURfg+N8CNC
	mbvgdWAgZkEOS0L7S13CiwpfHtqIzvLZvBOqnRg32Z501UCHkSuGROIQzpIH+3ySR8jonpIIaHk
	0pSqXkUxWMhZPH42e/U9aQlHRYYGTlOy2INBCpWlU
X-Gm-Gg: AYBFou0n41NyB323Bk/SQJ6g9pzYUHlCghTnCDf455e6HtbA1Pginw+fnsS+wIxzJXC
	C4QkNEII/lFTySXxmOI3lxTFD0DQehI+Z8st94dwCYl2oXOGLEC566yqXMKdDtGql5xMErp+iQl
	GrYnYWk6g9LmWTWYAGbVHMqqu2PxDMYix3X+a7ncm96+fG736/EbSPQcc6EBj+sACKm687uwswI
	tFoiT5LSPY+QQv5WX7FKzKgJwqy7TXF4qTRXxijodhZ1u6mSmVybXt9BeG5gEeVWcaGpoedJ1pQ
	k9bdMwgXT6uxDO592ROq1T5m7iXk8k45pi/gTuxlIghiTB5DXiydevS2HDJ4562Bft17p6JGuG0
	mosLatPQvFoG2zYwPqV/8GdrkJqcjJlNIh8qquvlUdD32WGholnJS+tv6DXMIyIV36r0QqwRrzc
	+eGrZoK6VP/iAK
X-Received: by 2002:a05:701b:2719:b0:14c:c947:6afb with SMTP id
 a92af1059eb24-1993505eb6fmr9755750c88.15.1793020242405; Mon, 26 Oct 2026
 06:10:42 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1793017073.git.liuyun01@kylinos.cn> <16dd0366222031d0f5fe398926b16edd6e956e0f.1793017074.git.liuyun01@kylinos.cn>
In-Reply-To: <16dd0366222031d0f5fe398926b16edd6e956e0f.1793017074.git.liuyun01@kylinos.cn>
From: Marco Elver <elver@google.com>
Date: Mon, 26 Oct 2026 14:10:04 +0100
X-Gm-Features: AclHuK-qQC9TSp6y1w0jYuZwekrixl0YqhoKCZ6MwBRL0eAUB01yK6AwzJ3fce0
Message-ID: <CANpmjNOr-d-HA7SUZgyP8Yz_tNyq=_fcg9NMKw0jTYEmV+B+HQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] kfence: clear the pool pointer before freeing pages
To: Jackie Liu <liu.yun@linux.dev>
Cc: glider@google.com, dvyukov@google.com, pjw@kernel.org, alex@ghiti.fr, 
	aou@eecs.berkeley.edu, linux-riscv@lists.infradead.org, linux-mm@kvack.org, 
	kasan-dev@googlegroups.com, muchun.song@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 78E9D140011
X-Stat-Signature: the64pe55zzedg3ck58xjbnjskeyi38d
X-Rspam-User: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793020244-899411
X-HE-Meta: U2FsdGVkX1/TXcD0EqPo6giYbFn7ThmyswMdvS12L8KNeyToNOedIH3KbE1QaGszdzSUY92XdTf82kmEaGPnkQXthJmytKW77FxsLtucxI5zxotCgacbWibdRpN68C7DklTeiMnCGHG1eWsQtnhLH434w4jILg/tMN1mtdv7i7Q12sGlh8gg/OCg/q3a8RRtFmDXcK9aouls4QYRPBc677/p2n9GFC3D+LqLIeB+MG/x4dspLRTC4vmF2Jd1k3uAyjuSF0QC2m4x1Y61yzEcSnvdtBaaDb+2/4jFiOJszcvgrfOa0e3/MwI8zSkoeN8K2sL012XqlqUBiKFujsyLlmn87v6SctXY40QxJKLSSWBg26Kt8g96VpT+kxWBgdx9pLv3gpJaOfDTLRPJ9O9ks2iIP9kK9hXwMK7Z163LpK95hIb3Sfdj7SXuHHivBSaPdp8pnoIgshjVU/7kyb9VYTp9c+QznYvkIToURZ+nAWMaWQyb9skFnawGsiWEzX8PWxurIcqmJtF/yMmdbqg0D0zJJxUemOA2uu2FQVBoGXSTItUgehhaEDXNx9z1MlCkIvTZyWjb6+SMKcPJhrazUTCGa7wdlHADzw+Iu2b231D1ufFIBJodsMGex2N2R1Ex+j28fU/PIMiHxJmqkGIP6HLBnxLB06jvufYhtfdm+Z6TydyfsHiOV2+/chn+exN5/VHpm/7pnQTaAuNEp3xxGNo4vIW3WfDkulfQMZ3jpitytg7euIJ/WzmRwlWm2RVNF5cX1gvZhdJRRqjGdkQUpwt+L1vPMAmShe5KgsUqrfUV34ZzN0lY8crEC4niUnCApMddowwy5MTitUURYD9dyGf6e6Z2P0Ri2buV3Vyc7jLuqkDEA4E9LCBxBORpn7Lxf+CuFcQeI8WjDnJkNK6t4MeZ5nqsSsGp3Jhdh0v58tlwBxLxYtzoWwN714B3V/vuvOhgdVEqH01g4NBIJse
 PIOsPAzx
 zkmYZZhlZs8+loDrv3bSzyr7qzRs2nP+c/rTXTT6P7eHEdfpjGwPUIPc8T6GGeWFsn8GTlUIxRqqDx8e20tCIy3oWvBw6rnrTyIBb4QW/LToIJ+fZISqhWdYLBwhJ1L2HJXJNH/zouCWrlnWMOhPmyfyl8fo0UC0Ztmujd3WsKFq/9Cz8HjiovvTw9pW/Qb5J57azt06gyDxq3ztS0jDrD6myNv+6p8zahfjUHshS3uzKStf8NGZo0gr01+qmLt1AsZ8g/UqFoGd5PTZrCmS0fFpZ6Pc/IDYSFleh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 at 13:23, Jackie Liu <liu.yun@linux.dev> wrote:
>
> From: Jackie Liu <liuyun01@kylinos.cn>
>
> Late initialization frees a failed pool before clearing __kfence_pool.
> Slab allocations can reuse those pages in between and be mistaken for
> KFENCE objects by is_kfence_address(), even though KFENCE is not enabled.
>
> Clear __kfence_pool before freeing the pages, and use the saved address
> for cleanup.
>
> Fixes: b33f778bba5e ("kfence: alloc kfence_pool after system startup")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>

Reviewed-by: Marco Elver <elver@google.com>

> ---
>  mm/kfence/core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 6e3d01bccdf1..434df6cef7f2 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -1052,16 +1052,17 @@ static int kfence_init_late(void)
>         free_contig_range(page_to_pfn(virt_to_page((void *)kfence_metadata_init)),
>                           nr_pages_meta);
>  free_pool:
> +       WRITE_ONCE(__kfence_pool, NULL);
>         free_contig_range(page_to_pfn(virt_to_page((void *)addr)),
>                           free_size / PAGE_SIZE);
>  #else
>         free_pages_exact((void *)kfence_metadata_init, KFENCE_METADATA_SIZE);
>  free_pool:
> +       WRITE_ONCE(__kfence_pool, NULL);
>         free_pages_exact((void *)addr, free_size);
>  #endif
>
>         kfence_metadata_init = NULL;
> -       __kfence_pool = NULL;
>         return err;
>  }
>
> --
> 2.56.0
>

