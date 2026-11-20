Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A080B606A333
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 23:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YTwdcx88
Received: by kanga.kvack.org (Postfix)
	id C32F66B05B3; Fri, 20 Nov 2026 18:55:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3B76B05B4; Fri, 20 Nov 2026 18:55:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD49C6B05B5; Fri, 20 Nov 2026 18:55:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2AC6B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:55:19 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14A2BA025C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:55:19 +0000 (UTC)
X-FDA: 85457156358.02.588240C
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id 13E011C0005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:55:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YTwdcx88;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795218917;
	b=aCt+lG3sL7FwELrJnUAwRaIIMAKl6N/DSLZYuuw2joGBaEaKlTMPvyFpdhXCh0W85kvNj/
	6nPLb05NJjk4nNNzRNQYBZS5oW9bMm4n/cK7+GprzJ0Fz0WbqOqoS4N8yNSV0f0K5nDYeA
	kqUDnzCnB7vgsVCCt8vkMJ1NMOercGY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795218917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsHal6o5nRWNnSKiS+O4IM67tsy/StPXyCl5eMW8G3Q=;
	b=vbkFfZuMZvVfBm6RL1Kx51KhHx2HMtSOdnlQN0+J9kecKd9X+k0zj6NF+UQbCB1aqYqzdB
	3QdMLLyTzgPn/Epyls6kMdBqkpZ5MW0jc9GU9Wk7RvhKD/4Zeata4EjD9jqxfR7Ue3a96p
	5NTVvP0U2tNypF+h1fYehjxz4IFbPIs=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YTwdcx88;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4a68190a2a7so1257851f8f.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:55:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795218915; cv=none;
        d=google.com; s=arc-20260327;
        b=nYOvYqjUZpmaZyBsJ17ae7CETKWnqWJ99TccayaNjaVllp7Cf0uGGazaPwjrICJoCE
         82c58IH/RULWiIz2Q8BMWozA916y6SStcD65gdHuXoXDpoj5YZg4C3c28+CEAXdD9FpL
         x+sm6+957fV107pr4hH7PaVO9m8LDNe8Egnpvfk3J1ftgUqYlYkf3etiixBUpnD9U9Ws
         jX40VKMe70RrDku94W6iGCTE6Z6R5XGbUVWg9ypYsu3nAjJTUJICgq8Ck2aonXCUUtew
         /QvtgV/DiupfHha4p9ROawALG7yz+iHwIKmvMA1gQHOUaAivHkJhgxT8RaD0Bam1a+sA
         GNjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YsHal6o5nRWNnSKiS+O4IM67tsy/StPXyCl5eMW8G3Q=;
        fh=LalmntyuRFL53wgS88/lDp2JIfWLIUjd7WYbR9Dmp28=;
        b=D+oKSVdUaGiwJSwYa8e/IvgJ9awVWsCvqhFT+2sVbhgOWhzz+FbUuMH6JwdkIlCQ5N
         23ITYKXYVTNo8APf7Kt8KNw9Rqoc91en6N8rbgg+jYlWjBuyoUe97g90BUttBpAflJBZ
         Xn+Li/UoVoPdqbnv2jg91pQ5E0yVMcPqQtDUL3AEkjsEe0ZZvvoxE6v3lODa2Y+YYQn0
         SNMP7prC/hqS68viPkW72QhTlPBfLyJmE5IfcopwxgauEkyEt/YwHCpjBd8yIu08JD/o
         w5OMOLKRpS9+4P9/MBbB+bqzEKV9NHGaGxkwqFq11tEzphLE42P7IlrE8yaM1ePGqzEv
         dKrg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795218915; x=1795823715; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YsHal6o5nRWNnSKiS+O4IM67tsy/StPXyCl5eMW8G3Q=;
        b=YTwdcx88zrtsdWEcexY/OotcaLJeceeR6DMhEUGuLVaaRZpKb2LEOcO3H5mvWWgknt
         oXroNDFQBZ4KI7Jn65uW7ZwFbrCUfxzM5p1dSaTZun3830LyYZLlwe+b9ynJcM7agF6w
         Z/N3w42MHF5ZKDgDYLLLbLa+gPuJwp2nd4BUSW9Wtmv41Z83Ze/vkSckOcpgSZQA6DXo
         XsRQoudqc1ecbIaO6dcHsSiuK1ruo55bX/H1PC2n5fzLoyP9nNbce9SBHgpQ3V3JVdn7
         LbsnWZjsPpu0wHf0JBWaD3lUvqcYvh0fhmx6ANxr+nvaXj1Be4z9KlJVobLDu5dOi0uI
         JDhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795218915; x=1795823715;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YsHal6o5nRWNnSKiS+O4IM67tsy/StPXyCl5eMW8G3Q=;
        b=AxImgm1iBnvONOW4z0FlFbHud6o/dQm+QD51WSIzvk4Fa/tWljqVXwH1OS3+mROdAI
         /n0hxS4Vj8z/Lglr1j/v2G0FJA8Rq8K3gdW3VF6gH9kiHyycuXpM5DxGgzuunfFZtXWg
         Lq/yyg10j5gBWfdSjWcFPk0lIFwZ5hcSxMudXD4DOeQtDgQ6xhVyeSsmiH+8dnOVLDta
         18wGZzkWaOmNamiUKmnTiU39/poiVymOEpf9ngwiJovEPXFdMCMvZOWrWOGxpJZOgPfT
         WF0OSXqReHtkLoObsaSZEYIkAcbVQfsLU++feiMIB7nVbWGlLEdjrfvSdoE/+ylC/fbW
         iQCw==
X-Forwarded-Encrypted: i=1; AL+hErGs9ytCkaU64+vMJ0tZFiWLJSPW25GpdfWGhmBYBY+WcfrzHan40fjuqFZQJYKZa8gEXsfyaqHwbA==@kvack.org
X-Gm-Message-State: APuU4Z+1SFHL/CTTqmoPWYjJUvo4lZCIaSWpnD59ryVX+p+OHGn21ZOZ
	XXskxugziSOwJa98CJfGh7cfBUSlWwgeSYpg4L2t79H+aSqOQtNgMHfrPejrXr3/dioOhc8CXNx
	f08Zfcr6N1TSZLVbAKrheLBjNAtwPg4A=
X-Gm-Gg: AZFdTZcH1a6gUrA4a6VL+UDy4AI5Tdk0SKph5eLQooJB5/+5ey/CEQP/A+q2X5Hy/yu
	xtcq0rEB9X+2Vm1fHqDPSumeEfIkgovGUJm75LM6PJozp8CcVLXcgAuVjwGWxMY4BtmrmgjFUK9
	JPrti2ZcOT/R6zhgS4D9ljh99TuYgvcyUKY8H2QlXH3Z12ATi6nJfNawBtrzoSfpuM6DanGKZap
	rVemDJ/jexc2YG4+sjiATuWGMu/ev2vNF0hXQsq524tNQMUCTXd7naERbzvbdFh0U9yd6hCxH8a
	Dg/xuxYUOQRU22Wjm2Z+pKvlY9/OTf16zOR08X5WU5lQZTzOVUKCCTyol85NOlmN8XMAGxRvhdb
	nVayShyWL3vDEJsYVD/Cwd3upFTELCtkcL+oiCXwKZWhACvzpjP0XHEDYyVWd+rqFRZsm0sFWAm
	kg2tsM7jLSidJUZv1/2j6eadLfs/AuuwBGERtnBxWQwIOwcmFbZM+6ep4=
X-Received: by 2002:a05:6000:4381:b0:4a6:ed6f:7a6d with SMTP id
 ffacd0b85a97d-4abb1d93c3emr9288838f8f.28.1795218915387; Fri, 20 Nov 2026
 15:55:15 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com> <20261120041906.5785-9-kanchanapsridhar2026@gmail.com>
In-Reply-To: <20261120041906.5785-9-kanchanapsridhar2026@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 20 Nov 2026 15:55:04 -0800
X-Gm-Features: Aa3M54oUDY9bCyxtNFZ-ITKxLcqccLM_og5aWM-IgYq9zskwWDXgegX58dgm7ho
Message-ID: <CAKEwX=NtUEd7+Q2rW79LtObnjHT5uNFAUKfkRJJN1Wppe4Yc6g@mail.gmail.com>
Subject: Re: [PATCH v4 8/8] mm: zswap: Batched zswap_compress() for storing
 large folios in batches.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 13E011C0005
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: mbdaeeemyygdzfy3sqsjmkfq4uqqzrxb
X-HE-Tag: 1795218916-409311
X-HE-Meta: U2FsdGVkX1/hGK8jeuDqlrn5DhsH4OCAEQGqBPrHi6BEKPXng9gfG1XmWmkQkYjRhWyui+o7nVLhUGe4/Fl5C1lEzAIrNk5V1AW5CGowgEC66CDSizm7lTQmOVgs79LEIQWgOhdvnuf0AdiwLk4MBl0cKUgaPPRUV/8H8uuXVDMD+LbMFk+go2GOm3RZysgCGzXgC5UxnDVOVr7fluFTW/TaJKr42skwAkhJTnw8qlP1d4jTuUFakMaiR9KvnNDj3VhYe7VOJBOILi0v03WjsfDHn8dAwPCOVCAgHzHLwK8nCLXLzd+uDzHoo/hDrnrruGNkR5wz97eh0k8Qgb+aYSbC2O+Swpvlc+xXLo3Mh7TbSpvmTSt9OGncLvRnTfbhj/AcOpHRfhXwV1PnmmcXtRyIOdGVwQUB2VGNOOTaa+Phb/6gCPuurrBCRfIJgBYbKDhNiTk3eWTRovUGlGj6RijxKX4BBcFrvaecufhEEfFjeqy76dwY8gXLI5j7VA5J0YmtPmpLcsRO8B0FHwV96FH8pYhk9LrfsCdxCfwq4Lb/oLbiUzpirquXGxyWdfAAvuqVl8XEKf9+hMR5OoSLpkt7ViY7pfWJdPue/IXl+79bbzzCy4wX7qXYMtXF7S0YCsW30MetQdVPYlxy7ukxulmKIXsfhyWicwJaiL/x9V7UDzVwv/8EhWDz9QPz05LKTMZFoukD3ju8rywce7h9V+Z7D/R21q4V6cBmieqFsqTZm1onLSvZNB8da45q+NVwun/ZEjoKoh0InqVPSRf/Y9O0eCU0SYLN3yNqxjOf/G7A1F4030iNWinXj5xWgkKjVKsdxxwbYwStHLIgX89+/lVOZkIlGlvsR5dJi+MkpGpF86U5H8olu40iTjOtG9g/LSvtW6c2nku8UHY4a/IhazVigq7TqN7q4hYyBnUs/ZvvL0HAnJpbu7ECN01raqdUw/CbwRR+QrLpBH5tzk6
 L/qdIsO0
 AiQJ4liQAgMLoCtsknAiCV1GAqVD0f3lFj7sjzGhPpmcUO81uYaIJ4htnKBDEeFpxVohsFsEcFeKtkZE0vLoju0X8BhHyapzJsWqlU8t2QLm5Z4GAH4iXtVJnJ7Nl9YstGP+5eTiEIyiT+ZLIOrKlvEKViBP1bPXbC4/jW9+dDdyZTU9TG0OLxdt4m2XUYvksoCZK4vAV+WQv+aEjVOcVKHY5aNln9u+lfhrl13rkRjjnAUoapg9kq3far0Y9nVevWZ/AKK+WWvTAxcZCwv+glrTkxH7v3/DfpMfAoLDk8al958CTKfC1VCdvWLca3Q5JKEPh2lVrFk3qn0zMIXMkFDgOT8nPlEDWT0wXSQbXMG0WUZrOldSGgRD/XT2J88dGhYkl7s41fa5+eSS/Vic+d21qgDKqk6qiYmAqr4c81VVq3EjaXCwCPuF7XSUG3T6NXq+2gfnZFqoPjJ1Jlnp1SC6t0Il51dGrW0NzJbmCbHSG9eTpUuIzT8CGDNkLI1OuyHmbITBvuJPaRvqP9A/tHWMK7teO3CMxlynmwt7zW7CjY5y7rvAs9xV74CYvWU4Sq1wlKRl/KyxeTXCpMdmz4GIPvffuMsy/7QYIz700fK2N2OSXfnHTBpJfgSxct5B+LPYyxOGuoQy1/3MiufDtmJmZHpvSY1TrXIysxtHJ5KC5sD/bL2LCyyCz8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> A new batching implementation of zswap_compress() is provided for
> compressors that do and do not support batching. This eliminates code
> duplication and facilitates code maintainability with the introduction
> of compress batching.
>
> The vectorized implementation of calling the earlier zswap_compress()
> sequentially, one page at a time in zswap_store_pages(), is replaced
> with this new version of zswap_compress() that accepts multiple pages to
> compress as a batch.
>
> When the crypto_acomp is used to set up the per-CPU acomp_ctx
> during CPU onlining, the compressor's batch_size is obtained by calling:
>
>   crypto_acomp_batch_size(acomp_ctx->acomp)
>
> This is bounded by ZSWAP_MAX_BATCH_SIZE to limit the memory
> overhead and to reflect the store batch constraint of max # of pages in
> a batch. The clamped batch_size is stored in the per-CPU
> acomp_ctx->comp.compr_batch_size.
>
> As noted in previous commits in this series, ZSWAP_MAX_BATCH_SIZE
> per-CPU compression buffers are available for sequential and batching
> compression algorithms.
>
> Regardless of compression batching, we always process large folios in
> batches of ZSWAP_MAX_BATCH_SIZE.
>
> If the compressor does not support batching, each page in the batch is
> compressed sequentially. For batching compressors, up to
> acomp_ctx->comp.compr_batch_size pages in the batch are compressed per
> call to crypto_acomp_compress(). The first phase of zswap_compress()
> thus only calls crypto_acomp_compress() until all pages in the batch
> have been compressed. When this finishes, the compressed buffers and
> compressed lengths for the batch are available in the
> acomp_ctx->comp.sg_table->sgl scatterlists.
>
> A new zswap_update_entries() then iterates through the (up to)
> ZSWAP_MAX_BATCH_SIZE SG lists in acomp_ctx->comp.sg_table->sgl,
> allocates zsmalloc memory and copies all compressed buffers to
> the compressed pool. All existing functionality on zswap
> writeback_enabled (or not) fallbacks under various error conditions
> denoted by the crypto_acomp_compress() return value [and with this
> commit, also stored in the individual acomp_ctx->comp.sg_table->sgl
> sg->lengths in the crypto_acomp_compress() fast path], is essentially
> preserved.
>
> A significant zswap architectural change is that the batched
> zswap_compress() incorporates Herbert's suggestion for SG lists to
> represent the batch's inputs/outputs to interface with the crypto API
> [1].
>
> The introduction of zswap_update_entries() presents an opportunity to
> optimize the task of storing a batch of compressed buffers. Subsequent
> patch series will be submitted to optimize this phase by replacing
> zsmalloc with the SLUB allocator to improve zswap_store()/zswap_load()
> latencies.
>
> The batching framework introduced in this series improves zswap_store()
> latency by a lot.
>
> Performance testing: usemem30 with 100% over-commit:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> Validation was done with mm-unstable as of 11-17-2026 (Baseline: commit
> 866f761fd414) and with this patch series.
>
> v4 was validated on an Intel Xeon Sapphire Rapids bare-metal instance wit=
h
> 48 cores.
>
>  Bare-metal instance specs:
>  --------------------------
>  - 48 physical cores
>  - 190G RAM
>  - 200G SWAP disk partition
>
>  Workload: 30 concurrent usemem processes, each allocates 10G:
>  -------------------------------------------------------------
>  The vm-scalability "usemem" test (unmodified version) was run in a
>  cgroup with memory.high fixed at 150G. There is no swap limit set for th=
e
>  cgroup.
>
>  To quantify the performance benefit of zswap compress batching at scale,
>  30 usemem processes were run ("usemem30"), each allocating and writing 1=
0G of
>  memory, and sleeping for 10 sec before exiting.
>
>   usemem -w -O -b 5 -s 10 -n 30 10g
>   echo 0 > /sys/module/zswap/parameters/shrinker_enabled
>
>  Performance validation methodology:
>  -----------------------------------
>  These settings were used to minimize variation:
>
>  - All cores were fixed to run at 2.4GHz with "performance" scaling gover=
nor.
>  - Turbo boost was disabled.
>  - CPU power-saving C-states restricted with:
>
>      GRUB_CMDLINE_LINUX_DEFAULT=3D"intel_idle.max_cstate=3D1 processor.ma=
x_cstate=3D1"
>
>  The usemem30 experiments were run with the baseline mm-unstable as of
>  11-17-2026 (commit 866f761fd414) and with this patch-series.
>
>  After booting into each kernel:
>
>   1) Constrain the cgroup's memory.high to 150G.
>
>   2) Run 2 warm-up iterations of usemem30. Don't use this data for benchm=
arking
>      since sys time typically skews higher for initial runs.
>
>   3) Next, run 10 benchmarking iterations of usemem30:
>      - Log these high-level metrics: Sys time and individual usemem throu=
ghput.
>
>   4) Sys time and Throughput metrics were gathered for three mTHP setting=
s:
>
>      - 2048kB
>      - 1024kB
>      - 64kB
>
>   5) Benchmark summary data includes Sys time and Throughput components f=
rom the
>      10 iterations of usemem30:
>
>      - Total Samples
>      - Mean Value
>      - Std Deviation
>      - CoV (Variance): Coefficient of variation (relative standard
>        deviation) measures spread relative to the mean rather than
>        statistical variance.
>
>  An LLM was used to help generate the benchmarking and data processing sc=
ripts.
>
> usemem30 Benchmarking Summary:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>
>  ---------------------------------------------------
>     Improvement with v4 zswap compress batching
>  ---------------------------------------------------
>   mTHP enabled:       2048kB     1024kB       64kB
>  ---------------------------------------------------
>       Sys time:      -13.87%     -2.64%     -1.72%
>     Throughput:       +3.85%     +0.42%     +1.31%
>  ---------------------------------------------------
>
> Detailed usemem30 benchmarking data:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  1) 2048kB mTHP:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  ------------------------------------------------------------------
>  2048kB mTHP usemem30 benchmark suite: 10 runs (Limit: 150G).
>  ------------------------------------------------------------------
>                Baseline mm-unstable   v4 zswap compress batching
>                               (sec)        (sec)
>  ------------------------------------------------------------------
>  [Run 1/10]  Sys Time:    1581.414s    1356.252s
>  [Run 2/10]  Sys Time:    1642.874s    1478.929s
>  [Run 3/10]  Sys Time:    1594.458s    1411.252s
>  [Run 4/10]  Sys Time:    1580.988s    1380.959s
>  [Run 5/10]  Sys Time:    1579.654s    1380.609s
>  [Run 6/10]  Sys Time:    1627.765s    1345.582s
>  [Run 7/10]  Sys Time:    1593.872s    1334.485s
>  [Run 8/10]  Sys Time:    1623.189s    1405.471s
>  [Run 9/10]  Sys Time:    1661.954s    1433.365s
>  [Run 10/10] Sys Time:    1602.098s    1329.813s
>  ------------------------------------------------------------------
>
>  ------------------------------------------------------------------
>  METRIC: System CPU Time (Sys Time) : 2048kB mTHP
>  ------------------------------------------------------------------
>                Baseline mm-unstable   v4 zswap compress batching
>                               (sec)            (sec)
>  ------------------------------------------------------------------
>  Total Samples    :              10               10
>  Mean Value       :        1,608.83         1,385.67
>  Std Deviation    :           28.67            47.47
>  CoV (Variance)   :           1.78%            3.43%
>  ------------------------------------------------------------------
>  METRIC: Per-Process Throughput : 2048kB mTHP
>  ------------------------------------------------------------------
>                Baseline mm-unstable   v4 zswap compress batching
>                              (KB/s)           (KB/s)
>  ------------------------------------------------------------------
>  Total Samples    :             300              300
>  Mean Value       :         292,261          303,508
>  Std Deviation    :          12,946           20,806
>  CoV (Variance)   :           4.42%            6.86%
>  ------------------------------------------------------------------
>
>  2) 1024kB mTHP:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  ------------------------------------------------------------------
>  1024kB mTHP usemem30 benchmark suite: 10 runs (Limit: 150G).
>  ------------------------------------------------------------------
>                Baseline mm-unstable   v4 zswap compress batching
>                               (sec)        (sec)
>  ------------------------------------------------------------------
>  [Run 1/10]  Sys Time:    1567.639s    1594.696s
>  [Run 2/10]  Sys Time:    1537.577s    1456.113s
>  [Run 3/10]  Sys Time:    1538.562s    1521.887s
>  [Run 4/10]  Sys Time:    1626.176s    1531.962s
>  [Run 5/10]  Sys Time:    1593.955s    1528.733s
>  [Run 6/10]  Sys Time:    1643.519s    1558.482s
>  [Run 7/10]  Sys Time:    1510.613s    1480.177s
>  [Run 8/10]  Sys Time:    1632.018s    1584.093s
>  [Run 9/10]  Sys Time:    1569.424s    1528.915s
>  [Run 10/10] Sys Time:    1552.747s    1570.451s
>  ------------------------------------------------------------------
>
>  ------------------------------------------------------------------
>  METRIC: System CPU Time (Sys Time) : 1024kB mTHP
>  ------------------------------------------------------------------
>                Baseline mm-unstable   v4 zswap compress batching
>                               (sec)            (sec)
>  ------------------------------------------------------------------
>  Total Samples    :             10                10
>  Mean Value       :       1,577.22          1,535.55
>  Std Deviation    :          45.13             43.79
>  CoV (Variance)   :          2.86%             2.85%
>  ------------------------------------------------------------------
>  METRIC: Per-Process Throughput : 1024kB mTHP
>  ------------------------------------------------------------------
>                Baseline mm-unstable   v4 zswap compress batching
>                              (KB/s)           (KB/s)
>  ------------------------------------------------------------------
>  Total Samples    :            300               300
>  Mean Value       :        289,904           291,114
>  Std Deviation    :         15,385            14,553
>  CoV (Variance)   :          5.31%             5.00%
>  ------------------------------------------------------------------
>
>  3) 64kB mTHP:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  ------------------------------------------------------------------
>  64kB mTHP usemem30 benchmark suite: 10 runs (Limit: 150G).
>  ------------------------------------------------------------------
>                Baseline mm-unstable   v4 zswap compress batching
>                               (sec)        (sec)
>  ------------------------------------------------------------------
>  [Run 1/10]  Sys Time:    1914.525s    1878.483s
>  [Run 2/10]  Sys Time:    1869.412s    1863.177s
>  [Run 3/10]  Sys Time:    1944.049s    1863.502s
>  [Run 4/10]  Sys Time:    1942.757s    1900.144s
>  [Run 5/10]  Sys Time:    1866.505s    1887.285s
>  [Run 6/10]  Sys Time:    1877.716s    1861.668s
>  [Run 7/10]  Sys Time:    1861.741s    1868.788s
>  [Run 8/10]  Sys Time:    1904.735s    1816.372s
>  [Run 9/10]  Sys Time:    1891.074s    1850.435s
>  [Run 10/10] Sys Time:    1893.366s    1849.747s
>  ------------------------------------------------------------------
>
>  ------------------------------------------------------------------
>  METRIC: System CPU Time (Sys Time) : 64kB mTHP
>  ------------------------------------------------------------------
>                Baseline mm-unstable   v4 zswap compress batching
>                               (sec)            (sec)
>  ------------------------------------------------------------------
>  Total Samples    :              10               10
>  Mean Value       :        1,896.59         1,863.96
>  Std Deviation    :           29.86            22.96
>  CoV (Variance)   :           1.57%            1.23%
>  ------------------------------------------------------------------
>  METRIC: Per-Process Throughput : 64kB mTHP
>  ------------------------------------------------------------------
>                Baseline mm-unstable   v4 zswap compress batching
>                              (KB/s)           (KB/s)
>  ------------------------------------------------------------------
>  Total Samples    :            300               300
>  Mean Value       :        239,114           242,254
>  Std Deviation    :          9,090             6,419
>  CoV (Variance)   :          3.80%             2.65%
>  ------------------------------------------------------------------

The numbers look nice, but what's the zswap setup here? What's the
compressor? And how much of the win comes from this patch v.s the last
patch?

This patch series, and this patch in particular, seem like a lot of
complexity. I'd like to understand better the win before adding all
this complexity to the codebase.

