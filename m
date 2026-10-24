Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06A56606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 19:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CjP7AiuL
Received: by kanga.kvack.org (Postfix)
	id 6CB7C6B05BD; Sat, 24 Oct 2026 15:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4056B05BE; Sat, 24 Oct 2026 15:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E12F6B05BF; Sat, 24 Oct 2026 15:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FAB56B05BD
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:09:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6AFA1A7F75
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:09:03 +0000 (UTC)
X-FDA: 85358457366.25.D8914D6
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9623AC0005
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:09:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CjP7AiuL;
	spf=pass (imf10.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792868941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1KmGtfkzCXHo4XGQE9aXZCjXYpjChENBSuESrEsEx4=;
	b=icS17rkDsZdEAhTLXB9mYNHPOFhVmEA6pWOCxUDcSYnqD2dryTL3zIOMwxKxeihORMqQVH
	JLmeV0CkJrKk2qSS9h3U7d1rjTvi7qVa88YMHoLVmytxw0vLcLe7CTsUWGFOwU9qzDJh7z
	l509VUa1YRg1ibnARjeo8y04IWaqatM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CjP7AiuL;
	spf=pass (imf10.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792868941;
	b=sONyLLY8XDWCwufpz6nApmEJraCfrVjImw2KkSiOjCMAfemD27IPXV62ASbsvtRI3DoEIE
	9KuiEbTNGMiaG9EnBV6g80y9QW2BK+wlkKhQ4u/ExpGgMOAra416H0ntHhYvZ3bnF/HVp7
	JmvMnXhJk0QEY06eYigtri741WV03DQ=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3adac5b29ebso1174239a91.2
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 12:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792868940; x=1793473740; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:from
         :subject:cc:to:message-id:date:content-type:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b1KmGtfkzCXHo4XGQE9aXZCjXYpjChENBSuESrEsEx4=;
        b=CjP7AiuLuQNUWXuJVHGPY5WTXu+sZ4C0vcx2sV8Dxpnx+/Z28sACI4zc1b6xqJOjY2
         zqpyGpr0CiyCNvLScB70Wp6e3mio3yFy1RdA7+/D+eMhrtcYHkRFj4xECDxoe+95PKOh
         f2PuL9K5wyqag16JavgR0lcCs2MjsR5feofOsGUmKSolEb854Dt7/v3HSyQG45ivGXo9
         2Y3Jp0Nz0AmiYmu/I3w7HvU7Ge51jLL5Gr3a/Xg0Gb0i0uZ2yAnuNOno5dByP1uwdEF5
         uC6eri1swLz8Jj2kWz+1OSClkh1NYkHi915T4cHnXsDXXYtlGkboHw4pnwaNY1p3NB9h
         hznA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792868940; x=1793473740;
        h=mime-version:content-transfer-encoding:references:in-reply-to:from
         :subject:cc:to:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b1KmGtfkzCXHo4XGQE9aXZCjXYpjChENBSuESrEsEx4=;
        b=NW7ygQwe77zIuX13V9+WHhwHftVCd/RZ/bD0Oq45KjRhjiYLEEGmRZgJODZ00mALNW
         gi5ROi9BAkYLfhkNdsQ3ZQzJXq9ZEFIsJzGi0sDeZU5RsC3Ii2UobNVR/B2QE+mLshSR
         +tZq5VDwK6ECBRkFiLvgqpnz26FpYkx2SEZTjVJNMgfQRwxkcctoZ+dM+8DR/2XyJhna
         DxnpVChZyipFWb0yWQa4h2dDdULzTX2p7PSyOhHvPs7o7m69nzXksIhmqfu9+27Bn1+W
         dL/PK3GhrmTULlaiCV1A8CHXz8n567mAlFkRJhqhyxib69rvklzE7DdBplb3UPgNOh1f
         pNsg==
X-Forwarded-Encrypted: i=1; AKwUvBwT/T88H4QcLFhWW+XBQzWBAPHgg9VzXUKA+Bs9R3DTRzYHc4GpPVOg4wjsCaLL6QcAdAk0zi0Ztg==@kvack.org
X-Gm-Message-State: AFq9FYKHjYJ8+ETOBSJTPi4h2kk5YrhOAVgvpmHzjYKqrZ8iF5pXSIYD
	VdIukf0J4wTmHTeeetHVuH+G9lKRFHEGsIBpbIVBzKNERGBrcOlTgMFl
X-Gm-Gg: AYBFou2yK1yNTCsrdj59S0LOcTZCgFYrZQhdjvHouGqe5hvMpCb0hMT3ABunn8Tbmx+
	/zACp4/OgdWnAOIz+vot5J1Jb7C9xXE3+25YX6BKB5MptCx8w5YSCqD2EgYlfxI5w8XAUr7HtAr
	VhtunkSExKjPk09nAKJEOuK3kkEyS7sGSK3WQk1T7soGZpuN9E87JeU4mprG5Fk7fQIK4Edabnm
	3tWsNr/h42ybGeG9XnOd3iX6FnMnkLOXqJVYGfgMsUUdRi+S51nh7K4SQkRxNCoZ/OZZQ8XKJhB
	adfR+ZWFvWMgMjvgZ7MtEtShRf9xZh2xlA2QPZpP6Ajw+nb6AjyAK8fH55xG9ynm8RWQKPl26wJ
	5gaCGqqOVCVegncFl4NaWDiVjIAPscigbLBInAXXeIr9Qb0ImZ9Y41Lh2ghoYQx5tQAdzCwsAol
	DYQCyz6eJjqILd1GhtfmMgOgOTdSw+EJOYFSaVU9ymVt4hmiAJGEWEty+UY0eyVwWBBCF8qOGqk
	R41xepJ4d57o3SX2UOzKmgIst0fY/J6v+ONvcp2rLCBxXCLeUgz8TQOm3+JmufjJLH/gRTPgWLc
	TLc2QlL7PvFyqiLotN9Vw4F2FNPR7GXckRZHlLOqkoxp5khYzqDedx1t8Zv5
X-Received: by 2002:a17:90b:55cd:b0:3ac:9e76:aa97 with SMTP id 98e67ed59e1d1-3adea1a76b8mr2258311a91.6.1792868940394;
        Sat, 24 Oct 2026 12:09:00 -0700 (PDT)
Received: from localhost ([153.61.198.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adeba32e38sm3785610a91.2.2026.10.24.12.08.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2026 12:08:59 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Sat, 24 Oct 2026 19:08:59 +0000
Message-Id: <DMDAZW82I9LT.3FNX2WI80GNE2@gmail.com>
To: "zhen.ni" <zhen.ni@easystack.cn>, <daniel@iogearbox.net>,
 <andrii@kernel.org>, <eddyz87@gmail.com>, <memxor@gmail.com>,
 <martin.lau@linux.dev>, <song@kernel.org>, <yonghong.song@linux.dev>,
 <jolsa@kernel.org>, <emil@etsalapatis.com>, <ihor.solodrai@linux.dev>,
 <akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
 <ziy@nvidia.com>, <shuah@kernel.org>
Cc: <bpf@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/7] mm/page_owner: add bpf_iter and kfuncs
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
In-Reply-To: <06925440-8df8-4f2e-aea0-ede1a98435fa@easystack.cn>
References: <20261021112437.1799213-1-zhen.ni@easystack.cn> <DMAURQCKK6CG.10CZ7MFXGJO3V@gmail.com> <d39db4fb-e511-440e-9065-72c34a1a295a@easystack.cn> <DMCCBEPCIWH0.2JEDKE64WPJRQ@gmail.com> <06925440-8df8-4f2e-aea0-ede1a98435fa@easystack.cn>
X-Mailer: mkdraft (claude review draft; edit before sending)
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9623AC0005
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: s7qtampu5rp1guo177bc5ngfe5jc1u8i
X-HE-Tag: 1792868941-241604
X-HE-Meta: U2FsdGVkX19l4LkDdeKothqgEjMQOwB1HNeB+w2QLPpWkwUmJCZmrtJPAmQLN4GODGhKX48VD43Ny1I8Hl+avicrZk60jD4qqXcQNzARMjw4VMEj3zv7e7lg+7QbW+HbcVgvvV0du46G+3T8v2Z1CJ8TaFTCTNnsHcjh9vtwHnVjCpZD6HCcPArnpWHhf0JiY0lkDP7P2L2ZJH4pOfvnNlu1PQjgPtaMkZL/MqDKl2gxFl0sEHj8gVS81av/FBlr0FXXkBqidXb+VAUSS/XkoyKFppazgoHKltJUG/XodTZpgZCdWvuphyMxSJpY9Q6T0T9Rk+449C6SB4zRLkcBVdYwYdzkzPlpH4UEumqbSGF5f0+HqYb2Sd7v6Qs4lncxff/lRESehv7751X7b4/KmAcS/agU/GpAoj6mjGwwuo8wM2rDtDDiJ7bTShijRyUK+uZ/itxaa138Uhf6hEPBnOrZvYnUGgiFUKzH55yoCmRnsPrss9np74jYnbA/lwc3UoX3mzJxCjwZav5QsY3eEFwTTrCDveq6EyqZVLlTnKd2J+2jplXxW/hHHLyltQ9BMTq6C8iCfu3KI+4nGJ7pjkPGp+vuKgT1izJ4srj1UfLIIRDsvjA0yocJrYfPF4eiLVL7/VsT2pc8qKHLUraZUzXbifQCHMi8Y1k7ZQwVcXc05m06Gp3/Y5hymsQl8TuxIbAYMsmGk+vMIatqWX/7DoD9uOp2VMBotM31gTrbJC6eyUGULyq97BaqdsVy2b452c/pOnjFuzoX9bCmi/AjPbo7QKQjfX1h3ybgiS5NVJxYTYeNy51vXHvrr7PF9USzfsia6p0ZULbjdTM8TDHKvrEfmnlA1r4YGSP5fhNKXBuZpd9vzQkKby0HHDVTxY4LyAMlHJT3Oqp/KozyXGh0eNwllw60lKvUx1KvLdrC1stE8iGIjK2AlIfIqgw4RP3o/+kv2G6tnEDSLlMJOH0
 RLZvY/3v
 3CnhzoIyIjIr50VjVdaJWfQ1maKWAOZigLhG92vVh8q7cOGbz182UIE6eI8GLih3PLDRqeBrlN8yVAvOe52h5N6szpsXscndhWlkgHa5Hkd38fX11evkRFLIgTNHf6Pk9teH4t8bx2qRvRE90jzb9cSbl+EU+2+AaKBQgmgHTs3n0C5bT1OHfkO3sqh2yQJOQ1UuPQj6nbcBqbbjOLhA+zBYerveRmo/zRPJoHMM/CZWmm+yhdg/hK99G6XnoZyqI9QkKp7atF18Wk9K0catbrhz2kvvd5w2GXztg280yH19QPt+MdykTHy+AgWKqR7JPQW8mSTCpCTi1HZvzgFwPUq82+Hms4QfMXYGjFgLaBiZ1Bnc4jjy0ma5IRw5uwZgcqfqPOPqNFoF0jYzKoxNVnY9P/pQhz7A55kf2iwJ2fT0gEqRfWY6BrYISxju4rycZza0kY6BhMFUZNrFDoEC3piGxuAjZTsi6AnRflxKQOTsPs6Fda6zqD56dcJUaZccfQfounj8iik3jxJ/FPSbqSJOKTopKo6CCOd6NpJzYlLt3qtQ5SOlhn3RlIbV0PvEZKDnB7hQdhqANLx8i9FqtZs5T4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 24, 2026 at 10:19 AM zhen.ni <zhen.ni@easystack.cn> wrote:
> For this one node alone, about 97% of spanned is holes. With
> bpf_for(pfn, start, end) plus a bpf_page_owner_read() per iteration,
> that is at least 16,712,944 kfunc calls, and bpf_for has no scheduling
> point inside, and all of them are wasted work. The gap grows with memory

Right. spanned includes the holes. So don't pass them.
/sys/devices/system/memory/ has memoryN only for present blocks.
/sys/devices/system/node/nodeN/ links to the blocks of that node.
/proc/iomem has "System RAM" ranges.
523024 pages in a 32G node looks like 64K pages.
Then the whole 256G box is 4M pfns.
When a hole is passed anyway the call ends at !online_section() in
pfn_to_online_page(). /proc/kpageflags does that plus put_user()
for every pfn, holes included.
Syscall progs run under migrate_disable() only.

> front. The spanned of this node is already 17.23M, so a single bpf_for
> cannot cover it; you have to split it into N chunks and poll, with the
> chunking state kept in a prog map, i.e. a loop nested in a loop.

The loop over chunks is in user space. One bpf_prog_test_run_opts()
per range with start and nr in ctx_in. No map, no nested loop.

> for 52-bit PA. A 32-bit PFN range will overflow here.

The snippet was:
  bpf_for(i, 0, ctx->nr) {
          pfn = ctx->start + i;
i is an offset within the chunk. start and pfn are 64-bit.

> Solving all of this requires yet another, more complex kfunc—and it
> looks increasingly like bpf iter. So why not just use the iter?

Nothing of the above needs kernel code.
v3 is +474 -83 lines on the kernel side. The diff I sent is +55 -1
and it doesn't touch the debugfs path.


