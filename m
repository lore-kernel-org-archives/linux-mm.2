Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CD7EC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 05:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C55D06B0095; Thu,  3 Sep 2026 01:24:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2D376B0096; Thu,  3 Sep 2026 01:24:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6E266B009B; Thu,  3 Sep 2026 01:24:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 911C76B0095
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:24:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 002D31C1E3F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:24:39 +0000 (UTC)
X-FDA: 85171311078.23.ECCE0E7
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 33CF3A0002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:24:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bsCpFhxF;
	spf=pass (imf15.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788413078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pSlJB3l1ic1Ak7Bmpv9oySIlyoLmdFz3JH+5LO86wZ8=;
	b=liDOLheUHwXtj/UwPeD+uoK7+Ckd39kzDOfgsJpTTawpJSQLWC2wiWYKJ+rx42W4uq9qn6
	LPZpnMSxOfXfR8jyjU4pa3sLeJ92DhQm3Idvf5TD+Ig6Hw0mnNciNdYN4YqboPuw93zkd6
	pL419S3LCJ93P7sf8BKv7b6JvN97ba8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bsCpFhxF;
	spf=pass (imf15.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788413078;
	b=eJRRLK0F4O5bLN9M06ZtvBdqzghgbMsFxnElzBh5wrk0QYU/yb2i5aopcm3OWyD8Tb/RNC
	wjb1Bbk/R9Oz0odX2ayb4vUc6JsRP9G7m+aj7a+Fe/mU/R0rUjwjITT93SzwgG9buh9I4q
	qCMlZ+uTDdgH7IGlFDkMwINBsm+FkRI=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d01663d816so16466715ad.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 22:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788413077; x=1789017877; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pSlJB3l1ic1Ak7Bmpv9oySIlyoLmdFz3JH+5LO86wZ8=;
        b=bsCpFhxFkFq/wV7NjVdpDh9BUaoqAEolUF2Ym+Z9eFaISPD5pLMw4GjRk2XcViDxAN
         mjyhq+v4+0cLUPmHXtYsadFByXYVtCPqa9rTdMM1V/l8dbBu5vAczxdtDp0jQCnrcMww
         Dv7ONjMy/4wS3KZSd01xB1MbLEuybVWyqAfdpLVtThRZWFMHrVt8f4K1IfZ4pgOtiBdp
         kDkxSjwi+TvZjJYaFQXaLNMem8AmdHgKFh5k/tCXyQ8/jpZowbIXoOuh8gtTGpi92QfR
         m0PC3JX/6Fb11/1RXxJr4QDV5KYYNQpyin+JDH6f/O2/FTOLKWQgiqu1tRYbXHq44QpP
         0Pgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788413077; x=1789017877;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pSlJB3l1ic1Ak7Bmpv9oySIlyoLmdFz3JH+5LO86wZ8=;
        b=cj+jVNAA4g0DkdFavLMliTKYadC1gRQEMuBRRpvJJgGv7jM0crwIuat6CnfyUreFKl
         1Pf45pSk5RJzMKl91KYbB9o0dvS8JPVfW5lcU73LqGu8ZsGkWy/66iqT73QEhyguwMZu
         EZx2sfOMtqL3iceVI1OSmrMnCha8QRQsEKkj6uSIAL/LmgpOl0wPaFfDr+GEdgLUjD3o
         HdvskFhMLIfIK2v0+LyhKfFhnCXm6yquZ1ukNT+EQR1u01neJg9yObncT4zfHWYr3Zma
         tGyiVQhGPrxK4Ifo5Z5GLnhkAi9Cd8KYdwaqoCPWAMXHAbIxwaaQqY18mpQpyz9cVI0Z
         KNcA==
X-Forwarded-Encrypted: i=1; AKwUvBxVyTFshzE8QDfLprOuEwF1goK+L33Ij0KavXK7V4glVHnt6e8Qn4aJqTAtyNoEOSNtK4VMvnNr+g==@kvack.org
X-Gm-Message-State: AFuF++kSGKv+URPonW8zLo3NNpyP/F1WURiZGJ/EcT+Sz+Q0xZzKHvnF
	Ks7plNTjb+Kuq68MrICHwddt2f7VwnXIyzfsb9TPKrMh2/UpPSjbmIWO
X-Gm-Gg: AYBFou1uuipPiU5MLXG7EQ6gs2dofFAJS1wkanS0/S65IMHlKFjtsBku7K+r1yiheK2
	Uf0EPFCK4kcnZfd/HGgqEpeVY//TeXPw994eqMS3dccD74DaLZYVk/PU8UJG9v2+RqTopmU/pbq
	274PUmYVnthf3cHSC1PxckAR9lDHwnSa81MeVUrU3nRVo1jxhfo7UHkgXpTXzUH+iCZ0fWmhbpz
	hAGlW//oVWuyp61zcb76iKTJDwQbjj/IqEw4/1PbjNe1AoxTL5Qh3c9uO4qocg+bZhe8RI9ZJwb
	sH4gk7B2c7egHz59v9FLPNREvoVo7GXoDp8jB5ZYGZtnp+bvYYxWSy8hjWMTvWhfbm7qntenU3b
	1+NrhSo50PHRf3KA7s1iLJhKEeaP6UJMg/xEAKxpY6ffgL+5bPyT4cc+7HQZY4rteqfFBuOaXlD
	95mc8x+nfpy5z06TOb5mJc8oiQCsVzicVH1csj3fNjid/b1ykywvezKBHs/2BJZxdJ8VOxe/QgL
	Pw=
X-Received: by 2002:a17:90a:c106:b0:380:f85c:94b4 with SMTP id 98e67ed59e1d1-39aedf1a98dmr16024181a91.7.1788413076702;
        Wed, 02 Sep 2026 22:24:36 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae62a54f6sm2738544a91.1.2026.09.02.22.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 22:24:36 -0700 (PDT)
Date: Thu, 3 Sep 2026 13:24:27 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, rmclure@linux.ibm.com, 
	andrew+kernel@donnellan.id.au, pasha.tatashin@soleen.com, kas@kernel.org, tj@kernel.org, 
	rppt@kernel.org, rick.p.edgecombe@intel.com, yu-cheng.yu@intel.com, 
	orsonpeters@gmail.com, linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, 
	Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm: Fix pmd_modify() dropping the dirty bit
Message-ID: <94ada6d8-4513-4aea-bde8-98fc589e2b6c@gmail.com>
References: <20260903031608.1194238-1-vernon2gm@gmail.com>
 <20260902211036.8184c6e5535669bd73c71fd0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902211036.8184c6e5535669bd73c71fd0@linux-foundation.org>
X-Stat-Signature: uxb8gon88c3f397cxnnpzcb41cxpxzpq
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 33CF3A0002
X-Rspam-User: 
X-HE-Tag: 1788413078-222446
X-HE-Meta: U2FsdGVkX18ssVS5J8YzTEHPn0cosORAXv8sW7L/smDtCYLCIp4ZtOaWekFHUxXi68i0NYKfVotV0D4jtOPu6m1ADIIQuGpTArWFn/V94/pH6sTT4E+4lyrS4TlwRnUNwnDV21SKkLCf4BcPkt8qZ8Up9HrS9Uay0TAvW5mgq85e8NZTqpkUdCP710LxW4acY0ARetILVSBlG9NkdrI3yXJhW97WjStPHv5jmrz5h2WeT872ylsRQWUe6JZOg/03UxERGRZupx61eCQ/bQOKzPmtMMm0ZG0vJDJLz8Cy42ZAn0IzH1TUoZp/7dJcEp8C27z8gxas/fV5ITWOFCGZEyMhRlDDXn67X6+Txd+2DqpPvvPQO+PejQYLwX+F/YN+nWgN5WDoQNtmwVlCdPNxigZ1o1/2WO+i9aLHJ+vc7vx7qeMec1EEbtT3GV8Ch8EKuow33AvZkrtVJgDYUV8jXmGoU6f75ipeSkQcPg+ejFgD69fJih+ZXMkz488X2UP0UrFDX6Drn9hVg0eSNnHtvWceWACgwyAkfKVi0WoCS7J5ktryPAgg1Sx9HX2EnaIovQ3t7XqtFgLZMionYR0h27Xu8iIXpMcgm7oVbs2XDtnLo71c3HtIxhPVFDuiVlmpvMyi9hIgE9JibHt4W2igLRbgq2z/doqB7JKeRuX3HgOuaVU3DTFmIClRrqI96vNi96TxwzCHHeuksRXqazz/OBHx0Rg2vHnXmxlbuwO1IJDEVJVN2RstXENQm05a8gyuMaxP2BFdAVp6QBB3REj2sBb0yxskr3NzLRRAiQZWEIbhaIJP5UuXHbS90OvTmlve33MDJ2ccQE6Iq/Eopiw/aTE7nzxZVN0T0vKy1nbVD3GC3do5zUAR+yTd2HWndCXlewuKW43eribj5wYz5n4p6yXpooone5Fwpnk0p/inQrWoRVOLWUoKW3kfZjrJwQURWwPauZe0MIxaP+6hNeU
 4y/lbMA5
 q0IZdh2PP1VJssyaWKMpub3dd9OZqhwFMpu1n7qdYuLrBQwaW3ldswibeq3rUpx53mWbod9rdgxynU0xEDiNRFhWGQNVedREPwytuk1wjHxtlgzMEH/LZ75LeOOY9Wqc2OBvPxlTn0I5Ndjjw0U3eYYpsKfz5KMli1r+Ye27XVdEwDumEOhsrrv/U1nphDvzITh2DTuC3w8VvgCdVK8Ao8Dq1xQQrWFWuMbwlr1Wy2NI7w5zocqPaNdh8t1xLagl9EL9jpD+Qll4UcjkK/IXWiaBKMbg8cZyRbDmCK7xQ/YzMVY8nUvguiKrY1suqgW0j9jamChjYnYPncmOaDJZtMPRuPjafy26Ic4kweWYya4F646Ydt1VHCYhdOfJpZoRrcgzoD50TdIr572WK8twoQPAEXI/azg4sTlAc6066YL0OC7yeiSIzzu2593lWQYQMt4pqn6DvI2LNjoGIBq+kPrHSKGqS/JcCHZkY+9+rvwhd3aevHXEDjXkX2OVgKFq3b7z8C1WS6PAZ82pA+eKfPZzJpu6KsHb9A7ahfs86YM0LU2hRBTLfKV4R039XuzQOXrFWTZAUe9x7AG5CpyIIIhLsmCcVZtr3+rjSllqrbhbyh9+Z9azdX2R7aCwgWC6pQRhNKKbzKprH3pQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 09:10:36PM -0700, Andrew Morton wrote:
> On Thu,  3 Sep 2026 11:16:08 +0800 Vernon Yang <vernon2gm@gmail.com> wrote:
>
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > pmd_modify() masks the old value with (_HPAGE_CHG_MASK & ~_PAGE_DIRTY),
> > silently discarding the hardware dirty bit.  The subsequent
> > pmd_mksaveddirty() call is supposed to transfer _PAGE_DIRTY into
> > _PAGE_SAVED_DIRTY when write-protecting, but the dirty bit was already
> > stripped from the value, so there is nothing left to transfer.
> >
> > Contrast with pte_modify(), which keeps _PAGE_DIRTY_BITS in its mask,
> > and pud_modify(), which keeps _HPAGE_CHG_MASK untouched: pmd_modify()
> > is the odd one out.  Any pmd_modify() on a writable, dirty PMD loses
> > the dirty state.
> >
> > One visible consequence is data loss with MADV_FREE on PMD-mapped THP:
> >
> >     memset(buf, 0x5A, size);          // PMD-mapped THP, PMD dirty
> >     madvise(buf, size, MADV_FREE);    // PMD cleaned but left writable,
> >                                       // folio marked lazyfree
> >     memset(buf, 0x5A, size);          // hardware sets _PAGE_DIRTY again
> >     mprotect(buf, size, PROT_READ);   // pmd_modify() drops the dirty bit
> >     mprotect(buf, size, PROT_READ|PROT_WRITE);
> >     // ... memory pressure ...
> >
> > Reclaim (e.g. under memcg pressure) then finds the lazyfree folio with
> > no dirty bit set anywhere and frees it in
> > __discard_anon_folio_pmd_locked(), even though the data was rewritten
> > after MADV_FREE; subsequent reads fault in fresh zero pages.  NUMA
> > hinting alone can trigger the same loss, as do_huge_pmd_numa_page()
> > restores the PMD through pmd_modify() as well.
> >
> > PMD-mapped file THPs are affected too: mprotect()/NUMA hinting dropping
> > the dirty bit means rewritten data is never written back.
> >
> > Fix it by keeping _PAGE_DIRTY in the preserved mask, exactly like
> > pte_modify() and pud_modify() do.  The existing
> > pmd_mksaveddirty()/pmd_clear_saveddirty() pair then performs the
> > hardware-dirty <-> saved-dirty transition based on the write bit,
> > preserving the shadow-stack encoding rules.
>
> Yeah, this is exactly what I came up with, using chatgpt.
>
> > Closes: https://lore.kernel.org/r/CAJxLxMUGu1-L+O_nAONOwOXnS=cNbNApCWqdthRjd76LThtSPg@mail.gmail.com/
>
> We definitely want a Reported-by: Orson here.  He obviously did a ton
> of work on this, and it's the least we can do to thank him.  I'll add it.

Yeah, I missed adding Reported-by: Orson, Sorry. Thank you for adding
it.

--
Cheers,
Vernon

