Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AADB606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 08:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VoCgO/cG
Received: by kanga.kvack.org (Postfix)
	id 461386B05B2; Sat,  7 Nov 2026 03:20:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411136B05B3; Sat,  7 Nov 2026 03:20:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300816B05B4; Sat,  7 Nov 2026 03:20:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B42D6B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 03:20:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D0541402C6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:20:03 +0000 (UTC)
X-FDA: 85407625086.27.F9A2959
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id B3E39A0003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:20:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="VoCgO/cG";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794039601;
	b=4LYYl6OJLCDzYQD5soli9wvUWU0t2nR4bkkIPwoaKpiCH0xYlFmQ/dztqYED7675MPsQXt
	cS+z+oQEUQZXUW/DFgPBt4G6ths3+GI4vdo2ihCVPgM8qDyPbOEYGx30RcpP7g6qo3k07d
	BZ/eGj3Yjomkrj2Q0tBVy2UM1aDKlD4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="VoCgO/cG";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794039601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWwZfF80258/+F+GHEmqApJo8cN5FKx3RYuWlNDDhXY=;
	b=qkbqAwCjSRVncyCJoWseG4liCHPUsihwfwggzbd1aKFENPeF2THZOSH4o6qwHuo7fC6wZc
	KTyNzh/GO0efYotrxsMoRZG9j4iEU2YhTcO7dHNYlq/PdCXNpkyl7O50cUSiADAsM8zvpm
	ZqWDxd4ozUlyEcXmBYqjttsdpBvnmvM=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48e47347279so776626f8f.1
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 00:20:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794039600; cv=none;
        d=google.com; s=arc-20260327;
        b=dzL68pTXdwCE3/CAZtQFnECzktNLItOythwCo3cq1IctdWOiwWMHhVEExIdJh1riz6
         jU+jCj9L1+U80yAQxRWjzIZO5E8bM2cuSbx0esVf9cEHXM9oHOWqalONt7J0aobjNGzm
         SJU0ihu+2osbUgi4anYijjFK9BiUuM448wePqS2mh3AjXE1oOb+eNLFQjKU/DrBxLAoh
         57Qan782IVVWgEnCNMzntW8HKY6OOtyAUYOH5MQ2+V3xgGEtCNLVZ3tiWC7RcN0Qw6v7
         cianlx/iWKKV5q3ds5Xfrdt2lczYLdYPAO1zAREUHfxDWOuyGrsJzwrXekCozKU6NCCq
         i7lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=BWwZfF80258/+F+GHEmqApJo8cN5FKx3RYuWlNDDhXY=;
        fh=xMyLx+ZXmgfYHhPSeZprS1NnwHnvOMrMHJ+XszaKwlQ=;
        b=ZD0Inp7EaAnOs2tkAAzzC+nQW+ysESMzWUgLP+sa1dKMUY5LG8An9mMmAJUTXmHjJV
         tf1rbfeFuCxvhJvVD37gOgJX8GHo4tAV4K71NGSlqaPK9w6xnQvryrBWzge/pOUKt2BE
         SsK8rTGWXWqIM3y5X5VtWMLswMfrZB1WfNgXCT+53TPuqPpLlN2gG+YLmfNATHIuEHYk
         EJYnycGECU2lLkztpySAYZjjYMPf6ekRjPs337YXDSU8HJYBpYJnN08thjUFwZkpOrBV
         XEM7DSJyVWVBVJdNsZgvcAU+WaUL7jwi6HdrcdCKd4DChiGsJRbsJUrBSLnTIdYrlhOR
         3oBQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794039600; x=1794644400; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BWwZfF80258/+F+GHEmqApJo8cN5FKx3RYuWlNDDhXY=;
        b=VoCgO/cGP/zoU6TPaCGuJM7rMCEOkbdX8gA5xfVCd3R1RCXNP4b4QjZXb9b47EjL8x
         PdebsPEx4lvxnMgism6j0Jc5EDrKwQjYpv7Y4SQ1awu6ZLD9OpmL1rmAu+JATuffanh0
         yEybVPFsLFhZBsq+5WY5pp+YJ9knYJx+/m8Om/+z1oQhyozkvqiwC1kVBOBmTN8scXkY
         SMKkskI0SXPwtovPQq0D7lhGmrbWywQQUgl2sw4ZGtpuAlM310+0+mpcR0dobE8rvFF5
         ZRwq+A1llbWVvZjR2um/U5dZZGetZjeqp9r7Ukagar0q3DZBq9Ll8okheo+1Jnyfya9d
         SpPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794039600; x=1794644400;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BWwZfF80258/+F+GHEmqApJo8cN5FKx3RYuWlNDDhXY=;
        b=dMxFPJ+PUGEn7ecJZX4Db1ZWSZ7p2GBwPlkMVlqK3k7znBltHvCNORPOwtUi/MVLkO
         TVzbg5E+K+cGODNF7BL3870GKreV+2gh0bLUvLQuOZR0cA+DeHzt+WTFx/NP5M0oMlER
         lYiN3FNKbCnr27i7iVL5p6xbKjKFhJaItuu+xvT7HxOoflQduXQWPm5zBQHhlEW2DqHd
         Y9ZbUCn2mSej84KXMkyiaPPJLBaU7/fbrAAWXjh2PtP1Vt7Tw1zSh5QxmauCz8G667eU
         YtqSrfMfqSPW0RIakXi/bjr8Lg/URKSDblZhse5MSJKpsPvnLKs2K0eiU1UQgysFvFS3
         uLnw==
X-Forwarded-Encrypted: i=1; AL+hErEQ3w7h/EpkvdIa3YGqdT/TzDUBnu1l4hlH9ygLS9ugj6y1AfEFh7RGzwe31LZgb3KFgc/FwAlRng==@kvack.org
X-Gm-Message-State: APuU4Z9/hfDRLEEZLNvuUDrc09tAI9vvtdaQpqUy7NW0QdyEhEgLYCMe
	IOHSaF/kXPdh93A+7nOSi1zDcLbSXYo95gp4dwhLL2LnSuHx1xM32y+e6GBZoX/XJDxv6MLOaaW
	anrFrgC9J4thZ0s115i4oRHlxahdoQ/M=
X-Gm-Gg: AYBFou3KjE4ioAnA2JZkxXQb3sFWBs63tdoh+rzNFnKyiurgF5CM7KHev6omUPkjp8e
	+oA1yvyuEnmshdZ8UNBcX2PTCFjlRAddpE2RuaOB2sb8S0fXz9xqUSN6fWl2Dd6z/z/L1Te0qJ4
	tRn/CkKvcJWe5Z+miPSW/PGtsYrSRZJy9pfzaRx4DBYs4MURMPezlKEqX+WMIHQPztmKIapr9fw
	PQA3GEZsqV/lTqmwvLmKwu4EhMhKogv5XzDC+YxRLMcNeEibNxsLFYEyQ3N/33bg10iCn+oT4//
	+EAOueCupRwq3iUz0aYXjFSY8892IahFcTZFAfw7r15sQDRDZZ1J+VgmuIyjhkRjtKb15LTLLtB
	Zix4MPPUxcJzFrUbr7InI7MiHi/5FcorZewG6zQ==
X-Received: by 2002:a05:6000:400a:b0:48d:cda6:4dd7 with SMTP id
 ffacd0b85a97d-4927f78fe8cmr9200523f8f.44.1794039599942; Sat, 07 Nov 2026
 00:19:59 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
 <20261103101658.766905-10-jiangwenxiaomi@gmail.com> <sashiko-outbox-197081@kernel.org>
In-Reply-To: <sashiko-outbox-197081@kernel.org>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Sat, 7 Nov 2026 16:19:48 +0800
X-Gm-Features: AclHuK8xVs7cZe9aVBZpOoOS5AW56CL1lPNfImzX0W7yFxv2KA4L34W4gYXh93Q
Message-ID: <CAHKocdED6i52rn38qsWOFwEF=kYZ54iqoqg4fHCk_n5Cso8Ahw@mail.gmail.com>
Subject: Re: [PATCH v11 09/10] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: sashiko-reviews@lists.linux.dev
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	ajd@linux.ibm.com, anshuman.khandual@arm.com, baohua@kernel.org, 
	chleroy@kernel.org, david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, 
	leo.yan@arm.com, maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xdb3qbedh6w4myqi7gejjkpnnwsp3f37
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B3E39A0003
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794039601-770663
X-HE-Meta: U2FsdGVkX19b42hGVCOkKjkhgO8e8w5gH6Svbrbjm4TpdS9f+xGsL1Ha0HjOrYcBLbZNFgRcLs636OkI5Alwou+KYrT90YBkqwD5U+Da9YC0o96lrDp+f7I+I8SUaxCN3iCyzeGoZBEcRbRE3jxu5GBpt81nCz3azp2w3atS2Ee2eOFp8apfYhojjojtMkmABoZW4C5hWZOPJoiMuh+ET3EJ2yyLmZupEUc3Ro9DTxXHESz1epRlgDHNb+fv8jyhACzNtl0ecd3MBDpdd5VxFrTnMrlnyd1vDKI9h+662iUEdT6+T88F1IO0VRnpPGbm7VZWEU9i4EEl7+3DdOe9cye1qOXDgw85Ze3hsrciJmSniG+au1OZA/rZjJZyKVX2aGiz4mZ8qbxuhCI7F8/5PSZUSDgoiDUWkjum3j7bDRbHwC6pYhalsDEMGvGBPKjydNeBq2WhXBR1ErWOsuNyQvVAp+aGcKvc8rjEwN38l1kktlUn+9zQhpcAPDjcyaRSfDaocbraau+kmSiUk+qJ40ga4Qtp6JueLHJmXam/+00f47tKO2IRQJ4c5E8rDGSop4C2OoIwn9Lug0lRaBMxRIj9Kvu29QtKNZs2LRcvrl4Qm4CkpA1Mkucp0DLzSz/+WXQSArYPe8OosVsrDzFnDdmHsx5e5MqMsk9SC+SripfNTCdsE6l6bLp60lfdD9LHH+627phlboDXDcWY8CLFho0SRGcLsgdP04gaE+F0V8KWEqGoTrERjzF+EcEAmkP5Qu68tg7Vxz+TaoGFWeJZ/LdLj024VdBoBVIcF7FFkslIbuYTw1cMjxRFUY9bH7UU3BK+R3mNzyk3sHgsHw8CuHk7zDruRvQR51DFnE7/Vwl6vo/4iByqABxEJcBZBIVITnyLLTI2fy0RqObZVd5BX/I+6TNCcM6Sx3Trf6Cn/6z3epHi78VsW5wkiapyVsQmIloelg5NbWobjRvM9HN
 0uHKWw5X
 eL6qQU7ATiZIgkw7WwcWSY6NB4j4+RiCRA42oxwu0H6Ux4K1MI9ho6iRdWdFRQHKR3LqbJ610WvWPRP538pNutOYjEsl+kJz61tV4utirAW845gdZGqfxavpAPqmf5u/rT2XXJ9v6IVatycdSNmk0Mvxi1R12sjyWlaYHTIZSwri9SjYr5YqSvn0ZjUJAMCPQxBRywJQM2RjN1arOz+auWVYdk/ogtBG8LClkQ65kIum9ditkZu4Dnt4vVLCiZbnVdRjVGdoLiZhmfVFEu1C9LdydY+39rrJqoEscLr+NAwz9r/pn0EXDhZIzoUH2N6SRN6tx2LgXmcB+ViXhtrbmW9Omtg8H2pzRR4nO0l4G8N/8wUwaxxzX/sTvpEPaMZR5rua7qUtqCXRrbs9lGg3DqdQk7dAUBkq1Go6/ERoJHQNVp8C8SvJ/w09kKGgG9tFI3YC+ERLUcTyW+4C/snB8kInhAi44qBgI2gJFgraOe9jwwxtOg/vOafTneA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 4 Nov 2026 at 18:19, <sashiko-bot@kernel.org> wrote:

> [Severity: Critical]
> Can vmap_pages_range_batched() overrun a physical chunk and map unowned
> physical memory when a coalesced batch of same-order chunks straddles a PMD
> boundary?
>
> [...]
>
> Should get_vmap_mapping_order() also bound the mapping order by the virtual
> address alignment of the current page or by the supported architectural map
> size?
>

Confirmed, this is a real overrun, and the same root cause applies to the
Critical findings on patches 05 and 10 as well. The batched walk coalesces
physically discontiguous chunks, and when a PMD boundary splits such a batch
in the middle of a chunk, the resumed PFN is still CONT_PTE_SIZE-aligned, so
arch_vmap_pte_range_map_size() maps past the end of the contiguous run.
I'll clamp each mapping in vmap_pages_pte_range() to the remainder of the
current chunk, so it never crosses a chunk boundary. Bounding the order by
VA alignment instead would split large chunks into smaller orders and
defeat the batching.

> [Severity: High]
> Could switching vmap() to vmap_pages_range_batched() without setting
> VM_UNINITIALIZED on area expose a race with vread_iter() when a PMD is
> promoted to a huge page?
>
> [...]
>
> Should vmap() set VM_UNINITIALIZED when allocating the vm_struct and clear it
> via clear_vm_uninitialized_flag() after vmap_pages_range_batched() finishes?
>

Confirmed. vmap() can now promote a PMD to huge via
pmd_free_pte_page() while vread_iter() walks the page tables without the
mmap lock. I'll set VM_UNINITIALIZED when allocating the area in vmap()
and clear it with clear_vm_uninitialized_flag(), as
__vmalloc_node_range_noprof() already does.

Both will be fixed in v12.

Thanks,
Wen

