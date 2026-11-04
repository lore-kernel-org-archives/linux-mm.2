Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85446606A329
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zrynaZ1Q
Received: by kanga.kvack.org (Postfix)
	id 9A90D6B05B4; Wed,  4 Nov 2026 04:41:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97FCE6B05B5; Wed,  4 Nov 2026 04:41:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BE2C6B05B6; Wed,  4 Nov 2026 04:41:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BA106B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:41:44 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFA3DA069C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:41:43 +0000 (UTC)
X-FDA: 85396944486.19.7A9BF6B
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 345AFC0002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:41:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zrynaZ1Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of wangqing7171@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793785302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/c8hVYKhMMh7/DfCYh54Utq4oZ1iPTgNxmSL7+jkyU4=;
	b=GL1hdXl0jTOO+w0A5QOH75LraP8+5Fls9gKbizrhg+hFUyPNTuHUgfa19IZw5WLQW7pukO
	1H48olk/epcn9g+gEghHvPjEee9rJRkfrHSBv7LPB0fHTw1OtWXyWy3WZk3egw1C3zsHq2
	h+m3HXt2LAxQgZfqpvT0yuL/Jkwz4iQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zrynaZ1Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of wangqing7171@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793785302;
	b=eV2tr9Gx1eHijbp1gRBlPL625mdh8CjleDI5G3OU8Kh8vJ7JnsWU/td9NNMwBz79VqIiKk
	b1YjgT7BTOilJW58Wu8JgSRCgy6IZjq64ZPt6bi1VnBchg1FqAjqwn3cU8NzehcG1vF3ND
	UyucVdXEjqcxZPQpWbEnlcGsJSOP+Ak=
Received: by mail-pj2-f3.google.com with SMTP id 98e67ed59e1d1-3adc0ac3564so201017a91.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 01:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793785301; x=1794390101; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/c8hVYKhMMh7/DfCYh54Utq4oZ1iPTgNxmSL7+jkyU4=;
        b=zrynaZ1Qh7z1EukCprs7cn5ftmgg/ufIyRjZEJgNWYKKEjfuOY7gP0yXe0gyf7As9q
         3PEJ1z/uhJpgCqcsuZeZ4l1qem9FV3z1gSUAoOCvCzy7OKY2YFx+sHO/EWaFzwjFFb6A
         iZXV3NnsXEt1JNXfIlELu3zJemv3dF/RwIXgkItWieFrdX4yiWzpI6lN/cO+8Jg3n/TF
         iSYY7VHWzpTqKUfqe8xOaxq6jtysxdpvDch6t4ZX4o47juH7fTI5EYQtkYsam6NKhT1A
         V3rOsj3SbGs3yoF7X7ww4QcPE4K6Oa/1LruYqIlgDO6zo7CpUI76mt5Indfty+ofZuCc
         Brsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793785301; x=1794390101;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/c8hVYKhMMh7/DfCYh54Utq4oZ1iPTgNxmSL7+jkyU4=;
        b=YcQ1mmUJEIw4ZMa9ONfeoVpnNbCumr7qqlTq1koXzRnS0693Mi8JLHaXqO/nR9wr48
         /Vd3/0l99MOir4YDynZav8tKS6CJCNXJ0xu+9roMG879ivAJitTY0XtabohMF9vaLKwx
         a9rR1wmj30n/Pr3W8LrZhd+E7oIwNoEzQXSUC3Teqod9ID7yB8texekq6nXvQD3rBUtm
         xPKjRHqQqtlWrRb4BPe5R1ZOAWATZtjRsjWOai2Pqst+4X2lh/cIkycutamKfVFsLVGO
         TpsUB1twn+wMk6BAaIeum3a1oAVVj71KhPq0GHCt+qLtZBokLB5RZVBxyNPPWrETjWpz
         bPXQ==
X-Gm-Message-State: APuU4Z8cNzeJc2OwTnkIWxcNn4z6Fy/Yig53WXwmQjdt+dwndDa7Javc
	Bau+o51/BZfsN9Z7McNYPx7QUSBkSd4d5ogPn7Fwpc0PwAS6SfwCMhqw
X-Gm-Gg: AYBFou17hsJc4XELx3noEJcYIB8zKahAZiQOew0FEJi/hBYZ6clqpCCdbVpI5zjr4WL
	fUSfFZt9d2+WcIbztznTfuRZkCrXq9EPi7aqsC01viBAR9AOHQNL6aforSJOVlyyDVKnTW/Mk4z
	mAZI87kWBh4FUJCmQxlfMElLNrrvktMPLHaMPfgj4Z7KBv3VG3MDtQpQyCcIm3lIR/5JIzshj4o
	48527e3ew/H42sPFFsdqyEd2FDapAlCykZMMl2aAkAgMiqFe17NByf3EoVsgbBa8LQ1kUcQDVoY
	bygY/WJCjIWMzdoISdfUe2XWrE+qqy8U4P44RUMJptu7hRQXLjzX2QG/A6JD9EGv1pBDCsrKSFI
	tKliR5L2smaU/yvkvKbIHiPqb6xgQbIXkazT0Uns7aPgrDwH6CMs7hLRRXglLb37gQ9KJr9MrJp
	z2b4Lw7QzsscyBgXnBHdydsj/32VHQIoU0zSvOu+Zv5MCJ667gfGCRTSQOlZuO6XCddHQ6Cq2Kf
	8r2MxEZIR7YeB5DzXKg6ktmFfObAlVfLkss43O79q+fW6J1AyVRw0kS0vr3bnRtM3UUn+Srfd5u
	Olikf38HqrTyG1ydkSweFw0VhcSbC9grCLW5olXEzeLzaqdw7nWkQOjK
X-Received: by 2002:a17:90a:e7d2:b0:3ad:a270:a623 with SMTP id 98e67ed59e1d1-3ae8957452cmr13058560a91.4.1793785300942;
        Wed, 04 Nov 2026 01:41:40 -0800 (PST)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.214])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c903d0dsm8661386a91.12.2026.11.04.01.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 01:41:39 -0800 (PST)
From: Qing Wang <wangqing7171@gmail.com>
To: xuhx@hust.edu.cn,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: mm/slub: has_pcs_used() reads remote per-CPU sheaf state from flush_all_cpus_locked() without synchronization (data race; KCSAN  blind spot: slub.o is uninstrumented)
Date: Wed,  4 Nov 2026 17:41:32 +0800
Message-Id: <20261104094132.2665206-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <363227fe.1d637.1a1a124c2b0.Coremail.xuhx@hust.edu.cn>
References: <363227fe.1d637.1a1a124c2b0.Coremail.xuhx@hust.edu.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 345AFC0002
X-Stat-Signature: wyypg1xixmyct7my5j8g9huet9zbszhi
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793785302-92789
X-HE-Meta: U2FsdGVkX19lud3SyJ+K378KfwNvU4VBiTPe7F5R+vCrsL37HESwq3UHhajBet0kBuoIq4bbYwN76vei61+yjxN8TXpmQSjdVw8YRbdZIuCgs9mX6U0kJFLbLfVMXG5zbLaPZmZHWXcAbG0AuZ1EbXEVBxtLzkCDyxCBs1kIxjlvXGp9syYllfwfbVImiPkbGe0BlZxR0vQ669dhOlkUgxaikQlpoiHob9NsV9cY17TvL5ex/R8nwl1fQG6mjrRiEDDE4dgdVvgHYOn5kwTden5+bez03FXLD1Bn7cy1HSWDi6I/F9K4qk6C+4q3GKH+6KbPC/UXp65U2t/EfqjZGeTM/SyzCpHW+WvyjW5meWMs6tQzMVnhHBWHSoBX0SzqJDMDCYPqjO0q+PWzXp+z+HU8f3D9jY5PbUowlnScfOYx6EHJC9X5ycttehAV0ohS3mY9IYPnfIrDEfaVUKAzB2f8jJQZnYHM4EKGl3mPq49IDwJdWUrj4yenXKwcuZmtnIAi4PTaFLK2dIqd1MMIye0x7Rfe7rLicF94Eld8TUR4yzEw8E1A48J+YtlQdBy394JUSw14pRPL8HWj2tCXa0iRYvc70faCsxyFV41E+5UDnHVaGCGbwJnK+xu+gfC31I7FsX6W20PvAYRhDpQcw9oEChBPeq38mTzr5+uLx+vp+3cViUoc+YHgp+X3NyeL1WWGEpjldv4ekUIRJBoT/gQqKj/IHDOkywzTTUR6zqVBo4Ou2YszP4mGPR91xm3ZPeviwNOl4gtTiD7V7phAeke40Qf4jrk5ta1YDJDVQa4s0jtTn2toeam1FB4nPYam8pZuDKBGTZIQ9zBYbPWBjp9U5JVexgUf3vOqOaebpg9eE4RBAaf3UgoD+yXgIBJD6IRtscB54COEl+RHYA1Qo8ur06LWUrhK3iPm389izFVZqrY2Z9EJJuM+7Z3PKE1H0zYrZt6ktLpwSCZDFv8
 aBLGbqkz
 ptzzx/KfUgGImn/ZpsDucusa8DTl1WkrhftTRx4oNMcKxorb5qjGG2yHQY2U6NePJp/lZEF+vLUvW9L2BnPLMRNKuEBNE+hzANzXx5Z8/b+s/qQics6CJANGCaOMO7B03nfqUeuuiZ5IFhcpaMmSfjk6580GS5f7vKsDxvZeppEQS6kxgncL4RB+mCtv0/8ZGpP5ga3MGYYd6wZmxwcwVgkvm59pS5irkC+iWGNKj9+B57AT7ril0bzemXCCmgn2SeMjmDtPsvMb6yOEbKDCLJ9lqTjuF6gn9FHD/TbsMEBcS3LW+IeHqpgOeWevUmXRMKyGNCW4nn5c94onv6Pc2YzOxfPW3P09JEu9+uKULhVVLnfS4ZueEJX1h27g46DO4vMegXKf7IW6ggV2FH8Fw5O4MYgwLtftgPJpmNF75ufz9rV1VotVXvhKApe1mYfa/bLAPOukBb4WOj8TzGicXLOAMZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 03 Nov 2026 at 19:21, 徐晗翔 <xuhx@hust.edu.cn> wrote:
> flush_all_cpus_locked() calls has_pcs_used() for every CPU to decide
> which flush work to skip, reading each remote CPU's pcs->spare /
> pcs->rcu_free and dereferencing pcs->main->size -- all locklessly
> (mm/slub.c:4041-4051, inlined into flush_all_cpus_locked) -- while
> the owning CPU's alloc/free fast paths mutate exactly those fields
> under only the per-CPU sheaf lock (pcs->main->size++/--, the
> pcs->main pointer swap in __pcs_replace_empty_main, etc.).  The
> reader runs from kmem_cache_shrink() (sysfs shrink attribute, memory
> offline) and is, as far as I can enumerate, the only cross-CPU
> consumer of this state outside the sysfs slabinfo walkers (excluded
> -- they read other fields under a different protocol).  I verified
> the race with KCSAN after discovering why nobody has ever seen it
> reported: mm/Makefile sets KCSAN_SANITIZE_slub.o := n, so BOTH sides
> of this race are structurally invisible to KCSAN on any stock kernel
> (verified at the disassembly level: the four accesses in
> flush_all_cpus_locked compile to bare cmp/mov with zero __tsan
> calls).  On a diagnostic build that only flips that Makefile switch
> (no source change), a shrink+churn workload on a dedicated cache
> produces 436 reader-pair reports covering all five writer families,
> including an 8-byte pcs->main pointer swap with an explicit "value
> changed" line -- the snapshot prerequisite of the (extremely
> unlikely, source-argued) use-after-free chain: a stale pcs->main can
> outlive its sheaf's retirement (spare -> rcu_free -> call_rcu ->
> kfree) if the reader is preempted between load and dereference.  The
> practical impact of the race itself is a wrong skip decision in
> sfw->skip; the fix is to move the emptiness check into the target
> CPU's flush callback, where the state is local and locked.

You're right, there is a data race in has_pcs_used() reading the pcs
fields.  The possible consequences:

1. has_pcs_used() observes an empty pcs and sets sfw->skip, so the
   flush is skipped and the memory is not freed in time.
2. A very unlikely UAF: the reader loads pcs->main, and the old sheaf
   is freed before ->size is dereferenced.

For the fix: could we simply drop the has_pcs_used() check?  The cost
is some extra workqueue overhead — flush work would be queued even on
CPUs whose sheaves are empty.

--
Best regards,
Qing

