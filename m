Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E195CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 21:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8EDC6B0005; Wed, 20 May 2026 17:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40416B0088; Wed, 20 May 2026 17:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08026B008A; Wed, 20 May 2026 17:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA6A6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:40:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2AF74039E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:40:04 +0000 (UTC)
X-FDA: 84789116328.10.2A3EA72
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id A9BA14000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:40:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lhe+b957;
	spf=pass (imf01.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779313202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FmdK4vbjUWnyTBEm67qsNClqg8Ylwzn73Ycp8tLb8QQ=;
	b=B3oNjV/ovjLgwnvm5J6FlxqriBErH5yzZxyXDBi78XWLoN7RVwezajwdIg/nzdZIKSvXbg
	Grr0cQj+ShsDJSLgjFyA/8X0H9GGc5ZyRBGsyzdFrLcmY2VLLEHDqQ4TaXM8h4VhmhPyFC
	V7Tcos6VD8LDIBTjkAcv1rOKy73adWk=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lhe+b957;
	spf=pass (imf01.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779313202; a=rsa-sha256;
	cv=pass;
	b=2VQWvccUHMkTuiXgTVT3eJ6akFzm0P/hyP04Cb2mNCxieL6QHaGy5PHNPURgaNR/LBusWT
	oSU2W2nrGuHmv1sCgpNT9jnCJNsD1G86xOCCwZk5PotbK3TswWAhlRW9NlPrsSYnJneg6P
	3/bfzYhAVv5mPxTvjVOyuU4WetqET7I=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-bd01481e592so789446266b.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 14:40:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779313201; cv=none;
        d=google.com; s=arc-20240605;
        b=WlkukezPOLL2a0I9rGrwjFXCxywjBS1+qJD289HW0pEm0BhGGcTz3GG+/wyDInnVI8
         4DkDR4Bke94BaFRh/yGoBYR3KKKSU+12CkpD1FMQO3cPHQGv4boqrWFGMevQp3eGp33X
         Ig+ZBJzQ5PojM6jzJVDuLL/qWiZrXzr1GJTsxvwrUZH7d9P+Xmgit8juRA93Nlnk5Hua
         bOGrriXRo/qBOnJ5Bx1dEoVaQ1YpHXIEtSBqYBFOjP17pmK4wvc8Bo1CY7DHYME+wlGk
         YUDFK2scUB0SV+fQcxNJv9gs7JODlbF6cy7/xIAREcbOqAo8aTQFfJ5CZLddgb7B7ICq
         AGwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FmdK4vbjUWnyTBEm67qsNClqg8Ylwzn73Ycp8tLb8QQ=;
        fh=XWLXyS695+z0n6kiaY3Lb1+beYLdLqfYHbu1quYQWo8=;
        b=CG5ffH+jjLwZned22A7XigCcD0fZXNMUUI13a4XpnhPixNgsPjjCSliiLzLRRbn3N+
         sbcvt72sKR2D6odS6k3lawca/HqK6Ubyv85gRTyAEjWY5z9uEGNenbfUX3WLOcX7mh3Q
         BbYkeBz+pqQD/jjvSCLNyyjv3OJym1S2RVVWXWW/iimCI9kX0c9FWsVBUjkiZpmnwaex
         P1/8YC6J/CikynHiEFdsFxPdqcsgta+GemwM7dE6QGtHcdrsi8Bq+QPRAakJdh4rwS/O
         CNwxS5blz0xiFfXsbFaTB+ILb8rgyluTyhs7bO9kg3Creywfs/B3G6QFz6qeG2z0K/JJ
         JHqg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779313201; x=1779918001; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FmdK4vbjUWnyTBEm67qsNClqg8Ylwzn73Ycp8tLb8QQ=;
        b=Lhe+b957IutY79j2ek1ojEul8JKyyis950gDQMuqugax8pME4VPcqKvOYNBEBe8mJG
         GlNc2CUHZ7uNJvif59P4rulYqKbZ7DWxXBL9LoHriD8N79InWXoVAFAaB0444ysGKlLE
         FLXiV1A2R+EblF0PaCcdwrgL4G/QzvaasQzWszk3XaJaEi1pOKv+LmfX3MIKMPjnkJIg
         TCTi9YsPLrD3lGiz/Gk2D9nm7MxZLxkI8BTFYaJIC4cxuq9wswQ8u8QWARRksaq4PsRM
         HIRB+Ijp9j5qlRi5Is5zV7lz8jkzVZmzF3/EVWzitDY/ERN7GOfYqOQoSiAjvCIcbCQ7
         OYSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779313201; x=1779918001;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FmdK4vbjUWnyTBEm67qsNClqg8Ylwzn73Ycp8tLb8QQ=;
        b=iaijlI1lKDwXp6pDZIDNkhPzbIMzFqDQQ8M8a6+v8z8uZK65lZEloUkKnI0EBffQMs
         NFZpuTPyhatriOUVYhvPZYH1QbkC1kY7lRKIgxMu9UYau8ZBEHQTJwVg5FJGuvmJyOsJ
         xmhFy2kJjZCZfrJnfjRZNeB2PBHhUnIVjhELTKsk7VMUZlfNuPMBWFBqmQNnyNd/aHov
         ag2KkJzK2CwwlDbf1P74YyXeDZINTxvVRAQ9EA+vqc+PRS5+e7+bTbQ6/lPpPij+b7z8
         rTTGqBfoqqIxzse208hilMXJUVyUx7Q/qtEmJ9lJdoNXlfw4Y/3FkvKccAzQyYYnMMr/
         tjbA==
X-Forwarded-Encrypted: i=1; AFNElJ8qyAagazbtl3EEIPL2JOdWvfyBaNTTighXW0Z0rd/aVzE1GAIAeoAH0chT0yZ3GeEyn/PucN7yvw==@kvack.org
X-Gm-Message-State: AOJu0YyOge7gRnCVG8CxgjB5w+e3AS35f6VlM0vG8y7p+QrcT0elPKgw
	RdSgC+UK6/qwZ1WEBVXx/+NIHItPIlHcnuUbW+R4dS+PH2cnYZ+Jzu5XawzDdtdJmQLikDNvmq/
	rdpWn5WeR7ZOicykT+KJOqJ16Y3y011A=
X-Gm-Gg: Acq92OFoLlDShWYUQZQYO8FlG3mE9WdxP8mYOd8ykRNdvlXDx8Gju3iKQ0211CbrqKU
	Ncf3oEjAtNzHp93JxEyIylVrDuvsOf9Mxsig9/73aPobtAIlqmTlzark81bHgeTUD+IgC3XoKom
	Mvcb2Q+sspU3u7NNMQGTu3BIfMC/opKHKmUHbXu8oyL5N06QaXBfge9CiMVhJEmGF/d6KNapEJm
	lkKY5K9qZivxPenTUZ8Vd7a+PZWtqVxZVVT2dzQwtYy/vwuqF7nc5qyBPzh89jUenRgZFQRSh/W
	0BazH63jE/h8iQ==
X-Received: by 2002:a17:907:e14b:10b0:bd5:151d:2d31 with SMTP id
 a640c23a62f3a-bd51781106dmr1121316766b.13.1779313200765; Wed, 20 May 2026
 14:40:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer> <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
 <agxbq1TxJdniMQT3@lucifer> <e6d1017a-e4c5-493e-bfca-932c6d64eaac@kernel.org>
In-Reply-To: <e6d1017a-e4c5-493e-bfca-932c6d64eaac@kernel.org>
From: Yang Shi <shy828301@gmail.com>
Date: Wed, 20 May 2026 14:39:49 -0700
X-Gm-Features: AVHnY4IxXAq80R4nUJKOoKG85hi3I-EgpsftnPlc019PI3pxbjgBD4oSC5VrWsM
Message-ID: <CAHbLzkq3S7NDYe4LXjurKNQU+40-wtqrD_PT18YcyHbAcNxiRQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, 
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
X-Stat-Signature: 3zr95n4p6xthsg7pjapek1ow4qamh8w1
X-Rspamd-Queue-Id: A9BA14000E
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779313202-327085
X-HE-Meta: U2FsdGVkX18LapzhUM8lvBwr6NvMcGAYtRJnGjt5LVcwXAY06kIw2c6ocNauWufbBMT+d6Y9jlREx6K/XnutHuCPPl9MQsey3BRZuMLN4szxu8zyXblwD9FJk53Owf1DVYud45jkT4Y2cVqr1nhnxuRWWro5RwsR9Ki8VpGvQs8JRsVWjPab7pFSLbJoqWXjl4WWR8m3kERHG9Dwin4qqAKaZqb2btwVYdo4U2o0M3p9K7xpIW/1/3Z1dDqgPweXFSi/t8g1L+4qaC2Heqj+YRHF6WLDBeOgktaA+Kaz1CB0TJpYYXzJMndg0ZIUOQefW9RMfVW/2m0sCB05m8mhw0v/YRULpnavOu7YFY43A+zLSTMwU16Y6QTbQ3bqQb0boo5TTmxEL9/RsK9//JmhVFd/OR5qzJQcVILvz/sWxTrGoefwKdMPjvvVFHs8B92ha2x74O6Qdnrq9vugLUXJYraDE22zn8Lv9/oCb9gcHqv5yLtyG9do4TUsk606msAPLQbxFYtMGhI2EEKrrs4ouJj383PD3ScvRZRsnNH3BdflRnRhhxLTiwL1R37vwgfG0lkTIFxODweJQe30Q6yAxFh2Erl4FJMz5y4p7nLAvVyVaEp8apT4c0Eh3qUfNvPkT6YkulpMvgdI+hTRURalEsPYhGWhrrAxm19NF/RgDJUtAJ1Sjs/tRwXV35QbIVqFDGYBxnahP+OwxIYmnGOsbu+w7e32txlcaannl1U1pSK9NL+J8uPXR1b4/EkaiGjKAcES6XXDVB9ybuvKkXiHcJBIc6utrjI82Ok2uchqdvmKTAhFbl3lrJm1svQpp9OME+lF4c+Z/FCHC5nMgToipjGKFnIBKOBVXfCx5FTU81SKQipEEX3wymUyDqOAIZC8UrEXeMPjJLsuDFux/Irokib/fvNyrYAhqUpFlM63iWRPLB2/BlaQ+OPVaALjXW3edNx4I/+6wbnIp0oTSH3
 cAsasX+7
 51yBtg8OZUPRO1iNa4pv64+AbMdLP4tIoAEiM8YQq0JllOad7AS3szwOJerRUJK58SQmkCK7IdoiJoYEPRWGImPldKXNoUFzouxxfDW7Xe4HA6kFEgkEKMKl2sPFqFFNKRI6fhbcJoO5N5SeEK8r4x7z+sjFRlJZtg/vcEdhSUOn1SDxE8MdOzUwaH3eDZ03wf00qw9gr9i9VL1cwDbDaIBlP9e9KSHx1DqCyV73oXEcDNqmJlUUdEucBoOfMWU3wIdkAIB6nx63PM2ANHgCbUmK547Qj+xi9ZvQlaJa5yBzlLtgbONqMLMvJuVn6CLdQ/tJlTwhpFYvp7mzE+ll+KLzBdI5hKM/jmU9oLYUZLq9DgxPlbbnaTddM1UNeWgxf5Fl3/10FGK2SnRkuMNMMgrwCiFbZkaU1eNgc5SVjTm9yvZ1Nnt2PwKa5Eqrgj6bR5EisvoB/yqaQtNmi6DlLA6ECJ2WFiY2wRwBNXnT5FQYQZowwKqWy/uYpSoarDyC+y9I3sdZwGv0Tbw4aIBI+SAfSZOZsg4iYESwNl/DHaL5BR0IznM1DztofJQPjbVKApuoW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 3:34=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 5/19/26 14:53, Lorenzo Stoakes wrote:
> > On Mon, May 18, 2026 at 12:56:59PM -0700, Suren Baghdasaryan wrote:
> >
> >>>
> >>> I think we either need to fix `fork()`, or keep the current
> >>> behavior of dropping the VMA lock before performing I/O.
> >>
> >> I see. So, this problem arises from the fact that we are changing the
> >> pagefaults requiring I/O operation to hold VMA lock...
> >> And you want to lock VMA on fork only if vma_is_anonymous(vma) ||
> >> is_cow_mapping(vma->vm_flags). So, we will be blocking page faults for
> >> anonymous and COW VMAs only while holding mmap_write_lock, preventing
> >> any VMA modification. On the surface, that looks ok to me but I might
> >> be missing some corner cases. If nobody sees any obvious issues, I
> >> think it's worth a try.
> >
> > Not sure if you noticed but I did raise concerns ;)
> >
> > I wonder if you've confused the fault path and fork here, as I think Ba=
rry has
> > been a little unclear on that.
> >
> > What's being suggested in this thread is to fundamentally change fork b=
ehaviour
> > so it's different from the entire history of the kernel (or - presumabl=
y - at
> > least recent history :)
> I don't want fork() to become different in that regard.
>
> There is already a slight difference with vs. without per-VMA locks, beca=
use
> there is a window in-between us taking the write mmap_lock and all the pe=
r-VMA
> locks. I raised that previously [1] and assumed that it is probably fine.
>
> I also raised in the past why I think we must not allow concurrent page f=
aults,
> at least as soon as anonymous memory is involved [2].

Thanks for sharing the context, it is quite helpful to understand the
race conditions. Because Lorenzo also raised the concern about page
fault race, I will reply to all the concerns regarding page fault race
together in this thread.

IIUC, there is already some sort of race with per vma lock. Before per
vma lock, mmap_lock did lock everything. So page fault happened either
before fork or after fork. But page fault can happen on other VMAs
which have not been lock'ed yet during fork with per vma lock. For
example, we have 3 VMAs, we lock the first VMA, but page fault still
can happen on the other 2 VMAs during fork if they already have
anon_vma. This is the status quo now, but it seems not harmful.

The bad race shared by David is caused by racing with copy page. So it
seems like it will be fine as long as we serialize copy page against
page fault if I don't miss anything. Since we decide whether to copy
page or not by checking vma->anon_vma, so it seems fine to not take
vma lock if vma->anon_vma is NULL. This will not introduce more race
either because setting up a new  anon_vma in page fault or madvise
requires taking mmap_lock according to the earlier discussions.

Thanks,
Yang

>
> ... and I raised that this is pretty much slower by design right now: "We=
ll, the
> design decision that CONFIG_PER_VMA_LOCK made for now to make page faults=
 fast
> and to make blocking any page faults from happening to  be slower ..." [3=
]
>
> [1] https://lore.kernel.org/all/970295ab-e85d-7af3-76e6-df53a5c52f8b@redh=
at.com/
> [2] https://lore.kernel.org/all/7e3f35cc-59b9-bf12-b8b1-4ed78223844a@redh=
at.com/
> [3] https://lore.kernel.org/all/2efa2c89-3765-721d-2c3c-00590054aa5b@redh=
at.com/
>
> --
> Cheers,
>
> David
>

