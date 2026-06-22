Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4613CDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 00:16:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71CEE6B0088; Sun, 21 Jun 2026 20:16:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CDEB6B008A; Sun, 21 Jun 2026 20:16:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BE596B008C; Sun, 21 Jun 2026 20:16:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3560F6B0088
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 20:16:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9964A404F7
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 00:16:10 +0000 (UTC)
X-FDA: 84905631300.18.5AE37BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 92DD140003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 00:16:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cMLhsAtt;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782087368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHIwIiKiSPJeb13YpcTgfxJcsK09+PRa0/JU1j/CnWg=;
	b=mBCesKQ5BjXFRMQRqZaiySXuEZ6xWjYD/Wgwa592sgAHcwm5Q3w9QWx82eTWm5UsUGGWZr
	vfWcHR7qdZxm3PZRUwss8flqZtcMdpyL71UyPjtRFhp0NaJaGlxOMliRBTYbXnnrjJ5IYs
	OqGferWcHG/DhWHFm4xKZ2x3NDL45us=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cMLhsAtt;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782087368;
	b=PuoqT5VtTqqRfkGCWEgz71Tu9AOR0hCUpU5TodjyP14J4YmQ/BBVvtshOsQKIc4Y78OnFg
	ET0gzv9CuKwgFbsXtCg7KEM+wgGwd5WckL91MeYDJhQxxlFWdY3XNk2rwVn+nQr5vHASsZ
	awLXIQWTJOrbW8p4RuFrrfN0UiRufY0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 87AAE443B4
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 00:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5870E1F00ADE
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 00:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782087367;
	bh=IHIwIiKiSPJeb13YpcTgfxJcsK09+PRa0/JU1j/CnWg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cMLhsAttTe8dyYAVQ5ButgRPTCNVZUjJ+rFUJS/Nb+BEGqhTUydcs0LU3Lix/Z3ek
	 KD0MCI/yAPBWlN6wb7sqDiwlAttozmfCiUFWz9O3jE4hYXuyhq8p1QaOAF9Rxm+bPp
	 zboU9r+goMAm9xbYv8LFtKEEZ5j6ZLteAPSQZ6OcSh5MIs/62zPpZIj5oiIaFmvUDR
	 QC6ZRHtySEUkXZIEInSyph82+HpL4LpnJ7gqwRc/Aciq0eNZH9YLMUThL9XzXyeqjI
	 Rm0VjsR1+yxuogHe+HIFTcJ5KRUzQnReJU7/nUzkEoFcP0eQK2LX+MLHdOMaRBfjL5
	 BYH2jN1C6LQGQ==
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-517863a2edfso29922891cf.1
        for <linux-mm@kvack.org>; Sun, 21 Jun 2026 17:16:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8y7IUqB22JQg94O0iU8CWAnAQN/20hUOKO1SQko71/Ea88qsQHJ66y3RH+hy1WuP5sQ972Ab5Myg==@kvack.org
X-Gm-Message-State: AOJu0Yy1aSwUqbJhAQRN1KA6bsHI9xeAL+fP7VhlLnK//9E51IGgi/OI
	+Bpwctnz4ucg6TF/xJ9pKUDWwoX15zuuOGg6eCOXS32tcOHbvNKMb0+14eDUKYkDSVvfeaKAPp2
	c98lrrIeLR+CaMjbSmDOd/CGQ0NyGhCY=
X-Received: by 2002:a05:620a:2991:b0:920:bc4a:6d9f with SMTP id
 af79cd13be357-921d185ff31mr1291391485a.25.1782087366553; Sun, 21 Jun 2026
 17:16:06 -0700 (PDT)
MIME-Version: 1.0
References: <5zdaa5uv5oj27q3taopl3amops57ouxgyfsdveudz4ovmbdw7z@6lwrlyvmhcp2>
 <CAGsJ_4yKxg1QugcsJi3WD0KVGJKe-zXycgm5D6cRi9vWtNcpDQ@mail.gmail.com>
 <ag4h87CBd-gph9zX@casper.infradead.org> <CAGsJ_4zA8afu0xXy0WS+tMe-eesDX1W6UBmfAsuouUpcAgK8JQ@mail.gmail.com>
 <ag4kj84EcKqamdB-@casper.infradead.org> <3be9475b-0e8a-4df8-a130-4262f993973d@kernel.org>
 <CAGsJ_4xC5LdhuoWV1=tK-RZ5rkjc8aOKOkmb1L_8BG_3gtJhDg@mail.gmail.com>
 <ahB6QyHgYq8ksj65@lucifer> <CAGsJ_4zxLvZ01i19vdo0xA47T1hxa1VRYvxLmiDhy5q1GDKPRg@mail.gmail.com>
 <CAJuCfpHTxaU4KdNmefU7C7cWZSLCFDLPdUrnqV6yzxzN+8RQ0Q@mail.gmail.com> <ajhOUdbWsswgQyl2@casper.infradead.org>
In-Reply-To: <ajhOUdbWsswgQyl2@casper.infradead.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 22 Jun 2026 08:15:55 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ybg5LGYopTUJTh5R2rN6X3uR9xoJSL+RdTYVtm1-xqLg@mail.gmail.com>
X-Gm-Features: AVVi8CfKzSAPaNgcIJCxOHQBAHV_wanqXUmTigM-8i98Bk0ci-4XCgmSQNzZol4
Message-ID: <CAGsJ_4ybg5LGYopTUJTh5R2rN6X3uR9xoJSL+RdTYVtm1-xqLg@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Matthew Wilcox <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 92DD140003
X-Rspam-User: 
X-Stat-Signature: y41bc19tpc7k1eoepi5uw1d8zyd8awh3
X-HE-Tag: 1782087368-909090
X-HE-Meta: U2FsdGVkX18s8eteQaqdvb0rWe4eD7DloPAOkiefoqsm9ufnd+ICX/KdAUQcB4Xic3V7VDOz48hcsc9xgJDtPi2MoP9af4mQG/jEwLwu9ed34cSiXf5p8h0w8gk5WkWdzmVbw65xsZ9Jee7+fltXp+8R837iOno9EZ6in6H5PPBlp+nzdtdPu8LF6pS4bqh5q3rRWyojQhfBkI8ReO8XejVzJcIb4jIY0NQFBluhVp0TGkMh4rO7Cj0qUqHBKZ85HyDfcO/wsYUs1yMdxIX2ypvFRp0nnCQ9Khoht8QJvNZbDXprGNo0xxRDOMfKhJrK3/m9awhliVz19Hjj6/pEynMdSUpP//V/LXqbf1Q2fzKGCySbxZmDuNXBVdishREpz1u9LKUB5T4ckJ/C5+lyTH2HrR0HQqgzwWSaG2kD6gZxbVEWuKmnJoZFZSzGTEb2L8SsF4SThwT+P/3CxhWPXHyC59LnvSMKUr65uZhURjdx8jfuDEaYtK227lpvB4tVpVGBvobicGyAzyLTRK/+ND3qPqTcPTfyY9FLNNI5XhBwp4iYqpm20PPrpBTB06WT1wf+6aXiDlPEhhS5sxyTFNWuunODzojNAtojWTO16q465cIjSXWkF9SH2cMP0YJ22eErMmLA2N45xO8W07ZUcxqA/+nCtLe2wXGG14BuyhGJRraCtN/1VnbTdcsU87hQRRcY8qp377S9UkquU8EydgbeaSWQWPdInnrcWqWnygcygwklMXgw2iVvbcVhdwJWqYc15D9X3u8zN89g4Z2/IexzokfRd8v1k37ZIt+OC6788nT6N+yOsrAP5TLAuI0LdUQ+Ch6+1mg/aACfStgH1Xgt//oYEe8tkNw6uO8ir/301X8yXATNSCLQM4j6EyFjsru62CQSP+GeWwveKtgR1VSz9wv5pvytaUkoBQou/5rEI2+i+TbYGLwZE+PeZ2MUhfjQSePLqlMbiK4iHcT
 QeTjXHoW
 WPwacrgCgR3wY5rteJG3q0kVrzCUpBXY1IRohE5/8wJ8pJj3EA27kdRe7yp+TbdPuRF9lKw+TdwTMWM/7wqAvIl6e3x8f9dJYt0YW7uz82p+/Z54VQjVUgxbKgBB3dpX4WCnwbhwvOrxGk3iY1NE2l/v39NS7Jw8E2+p6r6kinkX4Fzyjg5J61Hjaay03lYqgYRU+7G+8jUDPBycxfS//AB9w2hiTNjpMyJBdyh4FBPCDHfQI9faG33SCegHVMhgHjKdffVwYc0ClL5dr14ARER/azrKNhAuG/G3CEcjN48eEVJSbN7rtYxeFCPdWREfeAgshd7JoRBm8NlsvFyZLz6XOnX0QvHmt78fC9W9VOT+Cb4NEXh3u4UeSKwsyjKfbzMcXO48ExHT5l3hLOPSkEtIozKchB0zs4DQP7xNUeweA/OgUcmiIRpjvEpTwWZH1YxtuhhDKhzyegMBb2OE8RH765Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 4:49=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Sat, Jun 20, 2026 at 04:48:57PM -0700, Suren Baghdasaryan wrote:
> > Just checking in on the followup plans. IIUC the RFC mentioned will
> > try to implement the solution we discussed at LSFMM: splitting
> > VM_FAULT_RETRY into two flags - one for retrying under per-VMA locks
> > and another one to fallback to mmap_lock.
>
> I continue to hate this idea.  I don't believe that those who were
> pushing for it have ever tried to understand the whole fault path.
> It's utterly byzantine.
>
> I defy anyone to make sense of this:
>
>         /*
>          * NOTE! This will make us return with VM_FAULT_RETRY, but with
>          * the fault lock still held. That's how FAULT_FLAG_RETRY_NOWAIT
>          * is supposed to work. We have way too many special cases..
>          */
>         if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
>                 return 0;
>
>         *fpin =3D maybe_unlock_mmap_for_io(vmf, *fpin);
>         if (vmf->flags & FAULT_FLAG_KILLABLE) {
>                 if (__folio_lock_killable(folio)) {
>                         /*
>                          * We didn't have the right flags to drop the
>                          * fault lock, but all fault_handlers only check
>                          * for fatal signals if we return VM_FAULT_RETRY,
>                          * so we need to drop the fault lock here and
>                          * return 0 if we don't have a fpin.
>                          */
>                         if (*fpin =3D=3D NULL)
>                                 release_fault_lock(vmf);
>                         return 0;
>                 }
>
> Wed need to simplify the fault path, not add additional complexity.
> Josef has said he wouldn't've done the lock dropping had we had per-VMA
> locks.  We should rip it out.

I think you have agreed that, at least for anon vma, we can
keep the current policy, since anon vma is much more volatile
than file vma.
Concurrent page faults and VMA modifications can happen more
often than with file VMAs.

For file vmas, how much code can we actually remove, given that
the first page fault might already be holding mmap_lock?
It could be the case that lock_vma_under_rcu() fails, and then
on the first page fault we end up holding mmap_lock before
retrying. So are we also going to rip out the lock release,
even if it risks holding mmap_lock for a long time?

        vma =3D lock_vma_under_rcu(mm, addr);
        if (!vma)
                goto lock_mmap;
       ...
lock_mmap:

        vma =3D lock_mm_and_find_vma(mm, addr, regs);
        if (unlikely(!vma)) {
                fault =3D 0;
                si_code =3D SEGV_MAPERR;
                goto bad_area;
        }

If we still need to keep the page fault retry code there, it
doesn't seem like "ripping out" really reduces complexity in
the page fault code?

Best Regards
Barry

