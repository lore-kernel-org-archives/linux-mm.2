Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C825606A333
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=WsSQ4Mht
Received: by kanga.kvack.org (Postfix)
	id 33BC26B05B5; Sun, 22 Nov 2026 10:48:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313636B05B6; Sun, 22 Nov 2026 10:48:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DEA96B05C7; Sun, 22 Nov 2026 10:48:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DEEC56B05B5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:48:45 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 66BBE1206CA
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:48:45 +0000 (UTC)
X-FDA: 85463187810.26.BCCD0F5
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7F25880002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:48:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WsSQ4Mht;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362523;
	b=MR9F3hWaX0I6K66cFI90ImzPgYpexTYTnKsoU5LpIhOkRgraiR/G/0BsiFhMYk38Po21pM
	vxsWpd0THB48j0lcVagd3etudqZMoErYuFB1SdBvXGS90M66Aot8oPCJU0eopDlblm3f5S
	O39PmXfY7mlalFw0aDTdxcQEpUxhqO8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=grmqVvJL1PQoeJYgcb1eXI4pN3Ahy/cNA8wZ4nEV+2I=;
	b=Af7RFrfV/geAej2WR0NpM5+rLj2rJAd1fpAb/qcIwa/8DOGmkd2TrnkPyzXkOArFXpgAzQ
	2bJ8fLYU3t5owtQhDzI53ckQo+oIpvWe9Bvx84TgXsw55RgVF23FIlYleHDLXh/xAMOeic
	FixEhegMlfow2ea/GFiIg+eJmU/2+XM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WsSQ4Mht;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-536717a4d83so20927781cf.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795362522; x=1795967322; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=grmqVvJL1PQoeJYgcb1eXI4pN3Ahy/cNA8wZ4nEV+2I=;
        b=WsSQ4Mht7w5pHtCi2bcVbuMwULyjkEqDAC+7hAtto3nP0GmeF/vCeDroHQbfzSQLC7
         H2nbAeKG56BM9w+8+11WZF1SZGpxzHIF/e5lMAJOBkk1wOCMtv+zj7THPyN+WSwgPy9P
         x9n9UTaK8V94zteuGDheUpnKzd2XeFbkquGusNW/qcAF/hvmikhDGAoP8JdWCQ3P23XQ
         /NDFv8iyZ+Topg69BXhtj6VsiGNmUcmsl8ACOigMmDmZKY20GCvWkqejLJ83GMf3n/+p
         UYBlggFCymibqPIcq3Sosfu2RLgMzmsS2zlgkaiWI58beeIG97TRSMRk3oUazxtPQ6RT
         2ebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795362522; x=1795967322;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=grmqVvJL1PQoeJYgcb1eXI4pN3Ahy/cNA8wZ4nEV+2I=;
        b=ZVbG9tDBO60to51WCjk9peTL2ExUunk9A8anBdrUj7yh5sme9NN9p74Q9XrC4268l7
         pRo+vJWXJtElZhaD9mjWSJ2LlOzq3o4BbQEYYoe7HnOjZqTMCwYguyMZ+EPU8i9pizwB
         4PDqvFderrN2r3me8F2MGvqn+K76K7RT+povttW34TGRxkEjsfX9W30iBTXOSkjPYUk3
         bpTtnOivebONKMNYA8NG8jYOWTMySEkEIPdzk441U55YZLg0Qcg4nvUx2FXmfPBC5aKq
         zNjHOpQJORWxWjBYFo62jccTtpfHRhI6iNhZAfmiH+FJsnbkMHv0iudg2LmdL6LzIP9d
         xL1Q==
X-Forwarded-Encrypted: i=1; AL+hErEAw2vbyWTGWH3mej6RkMYW1AYlMRNxappSM3jqO8VeQlXlf+kgjt73h9dLs8uLGBDRZnNIt5zFFQ==@kvack.org
X-Gm-Message-State: APuU4Z9sTT/Byrd8R4mvxfgkjs7Wv1fCUc3CmJlBxLN4G+MJBEAPkAGE
	5OrcILVyFp1XtkCiKnWTeq6UiHBhXBeoDu86xm88LOVeSLGV/uFz4GL6IFkfVGcv4Qk=
X-Gm-Gg: AZFdTZeAIcepFvLfxOnz08Buvpoj0QmoZkF8z3uqC1e8zCtki1mUPz6X8lqP2haSF/f
	6CFyiZemnvNKgu9E3ZvMKdp55Ktszc4xsESzhkT9oDRUcGMiwm2s88y1SzxOM3eH/Nk5f+/kMMB
	bE4L2ZJC0ZTP36C9a3GXnPeZQLBIbXH6R2uUKtvRX2h1aqkiAbkrT+5/AXTNP8R3pRqwMocPAan
	ufuG8AMwCR9mLyLaXsOpRU7rasHUVmKpX3CJIqg5DP0pjp9xpEcc+RndHUArQRLOjxHE/ZxXQyJ
	AQDQm6b2dun0VcoWJbWCAQxhH1c8zJuhOILaT2wpZ5+72Z34jI6ebO2+A94W7TaYLIPvfEUc8iK
	J0RqVXcJ2H/JqT7SX4UnNiE3FFBt2ERI3Gk5ESIJgulCDVOtuFnSS9RFXYUW6kib2D8X/wIyVcO
	s4q8bgssBxY4bUxmqNqrYqZu87YSOAB/vjwQLBo5WhbGQ+azLgPc7RZqXzFiREl0NkQj9fZRxLH
	T6r28qlTG2L7pmysBTputm9U2RLmsIgA2XvfJUYduhhUyeUo595NbL0hrBlqz9J6mXszT1Qbiai
	7nFiUlBNw/b1/4pe78F+xdE9f0nKiVy3pDSd+iI0HLzl6HuhEVO+Xbj05dNpDVXuT46GhHU8HGr
	BMnGhdUw=
X-Received: by 2002:a05:622a:e3ca:10b0:55d:8486:afe with SMTP id d75a77b69052e-55d84860f8emr81157801cf.74.1795362522583;
        Sun, 22 Nov 2026 07:48:42 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d788506b0sm75398041cf.17.2026.11.22.07.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 07:48:42 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 7/7] mm/vma: make brk mappings non-executable under
 MDWE
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, 
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org, 
 Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>
In-Reply-To: <20261121-some-more-ai-fixes-v1-7-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
 <20261121-some-more-ai-fixes-v1-7-236e925d9b64@kernel.org>
Date: Sun, 22 Nov 2026 10:48:41 -0500
Message-Id: <179536252140.412063.16869457803147347876.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: zwtwrt1d5shpm1jnqqp37m1b3dkucgnc
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7F25880002
X-HE-Tag: 1795362523-607096
X-HE-Meta: U2FsdGVkX1859HVxNDkmOEyXY++vMT80Aot5gD+ueQorqO4zsMyLrNnWC5zUXBzwYnTQjjZm2DpAa5uJt8JrCW7UPqxaFsRmbJtDdwQqEMzpCZJRckU+ytvopIhzHGyYdXavbukFGFsZOpWBhfFzd74CNZlijRfMjAq0wrI1G+EGJNJU4akyAanBGpnUkeuMA2dYRcc5Ngn8zVe0ujEekCcwAuCXdAbvUw2Gl5Y/JWLUtNE72dJvBP33QuE1MzPT+Dbdu6dWjmpoDDvQ+3xys1UsZcEchOf26izbnEoapY7WDe+G8sKYo82ILtnY0IF2NCu0h5rPVWrVNSBYQw+YJnTWF8QfqbRmtogEe9SeQu/OGl8UDSWX/fFKt56cPDDrZ/CVCzzPh6c+1qbMqeKUzumOfO1Yvud5qjj9K1QngHWumYXIYttaQ7O8MwmZ6+rwLtj+S1458ue+NaS7M6g5DCsCDO+WB+jBMW4QctV+lhnSAav0ilDBepVWvTR5eR6EZzn7pO5ucPekyj+mrw9TOFickEuqZCuxMcthe5xDgCWYc6+PoAJxckTrC1BtxjvHzvwu9AoQM0iaV2pvdHpHVlHNAN/SGVVLI3XLLGljvK4tcPu/GclFqAC4Kgn/c+Za973U5N8wr3cFfQc0q19V0TokNLi7z5qTeGLu+R3MJXLstPWDmCNEM0aVVrEV29vk9K5x0ngBZ/QN+SsWs/WN4rEFoefMgI5yJx9/JabW+RGauTakSkUO0R9663TpdkOTT0m9IgaUP8AyBGIlCtTeGwQZ+whfas7YKymipFmDtR+wDxBilh/ICidpLKRn2OdOcexs2V01jaaWwEyeQU3V3OCcMHI74wg7ZfLf2PnD94Z3BbogiTkIrw0DBQKYwdSbAqBMxG7gl92SymkgUfwrNSx9al854VJ7V8o4hIalEy5PRBNNe0J3+RosHEuL1bMvtvajcVMvEYb2fRxVfPY
 cO0RGckA
 ydapooEJ05qdgislIA+86JZp7qbxVBXl85JjRN8ljU01S8PSUgtXToGXlxj9k1Qc5woEPFUe0MhKe33vnin203WQlN4mcdY9CrAcXmvSo7EFVMTXNs5yfkKkaMi1NhYyYLTFcvuR5LW2lOCK0jcHk51OKRFW9hCf7pSOsjMvPefRw7iSjXVU4BbG3fx92v9H8qpTfIVdTDnNI0PgLVUrGrqXfEKfaZYeAnBSW66x9h2B0WX2AgR+X2RIAGirVxUhZgiDvb3nH4AH0dh6SkZrIEKwcvac8aDqsbFpE+V284FwZaMe7O/K3ivTJoEpM62cFKiIWOMBgS6i7WsAPRRYZ1GVDmDECTk7Y5aWSrs8DDUkLL/Cdm47JN84WcIc52aslgg06k9MVQwJgWTDQu8SkytCZcW4Yl1e8nBN9JeoRZ/WFUGG3ZjOzTvLwRicpCB0SHErhd7m/j54Fc30DmHFpiR+DvX2lcntaL3huzpxFQA6OF8kNi2/dLOpwjqLj9M8OQY8IqsAFzP+bDPZ8yJnIZll1o7ADr9sWfxIk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-21 16:02 +0000, Lorenzo Stoakes (ARM) wrote:
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
> Fixes: b507808ebce2 ("mm: implement memory-deny-write-execute as a prctl")
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: switched to MMF_HAS_MDWE test, tweaked commit msg ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

this is a pretty bad bug, should probably consider stable.
I would hope no one is actually dependent on this behavior.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


