Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0C92CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 14:17:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E33B6B0093; Tue, 19 May 2026 10:17:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BAF66B0098; Tue, 19 May 2026 10:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8AA6B009D; Tue, 19 May 2026 10:17:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2B416B0093
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:17:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B6B48D627
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:17:57 +0000 (UTC)
X-FDA: 84784373394.18.82381EB
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2B85018000D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:17:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=LqEEDVdy;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779200276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOG3vjg48Y2OExGcsPJnnxcSdeHB4GZLcBDULwcpd+s=;
	b=rJNIOuh0J2ycFbDSya18+vjoN2xTFpkDA9acmGLHDWoGsDAaSmupeNEVTA8/LITlDxmwVe
	4BSZPznHpXA7SWALDTWpPvFr1c5mqh+Ef/y8iH/cepdPbo79UwLpAh/fiKRT1KCkK/L/s0
	Rl8pJYSyhx7DtT+fEgsqLhums8U9BYA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779200276; a=rsa-sha256;
	cv=none;
	b=w/1dD0cE7EWDS25MOFgR7WClyeq9zp/Da/vqqBmOkOmrOZleoVuYB4vahQezzk9H5HH0Tv
	ylXOsoSdjNHlUT8paSd2i16ELXXpri96GkhKEaNoZX5wJTAjik8KoDGZ1/WuTWkP0o32JO
	exbP5v9SocQDT1x5/0v3EHfmopaB3FY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=LqEEDVdy;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=EOG3vjg48Y2OExGcsPJnnxcSdeHB4GZLcBDULwcpd+s=; b=LqEEDVdyFtTF76iaxzwAEvUpAS
	4AEcgHqdfLW5xQmDzAu6hu8X2QX4IinCmclKPFEs3rdc7+UUPP9TapeSujglLEina6lPpTj8i+L/K
	i30XqTLyzWGMQ9dOANTrNFM1ZaTpa78q4L425NFBI7KBoMv4BwF7gjGa7GQBUxmkDXgebPOAWEhYC
	H1Yhm3MG+1zKmlAu6zKm4U8sWFim40F6x288j1E0QSqbVozytnqd6BN/aCAG/aWnS3+U1U3KZFRXi
	7bEcZlkVtZfWbbozbGDNiYEBVwc2MZVWQknug36gZBISvVKWaOs6TNDovNYi23bK3W0dju3yZMf78
	o7nWCYHg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPLGV-00000001nH3-2Vp1;
	Tue, 19 May 2026 14:17:47 +0000
Date: Tue, 19 May 2026 10:17:34 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Barry Song <baohua@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, david@kernel.org, vbabka@kernel.org, rppt@kernel.org, 
	mhocko@suse.com, jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, 
	chentao@kylinos.cn, lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, Nanzhe Zhao <nzzhao@126.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <5zdaa5uv5oj27q3taopl3amops57ouxgyfsdveudz4ovmbdw7z@6lwrlyvmhcp2>
References: <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org>
 <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
 <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer>
 <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
 <CAGsJ_4zgeE3ebEJ+j7GJFzWVoVYHeiOn4dOoOsmWCLA6s=oECQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zgeE3ebEJ+j7GJFzWVoVYHeiOn4dOoOsmWCLA6s=oECQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B85018000D
X-Rspamd-Server: rspam04
X-Stat-Signature: ufgb8ykzkzynz5fu4jr15ajteujaw3dx
X-HE-Tag: 1779200275-798183
X-HE-Meta: U2FsdGVkX195gdmeRkHh8REi/x+VNhSJguDhgncmQ0piorvsNQihROpO/nWUUtuwcNMVe9dHJ/ckjOm/0ZicvuiKMVdyvLFDO3gaaw1bSe6jLwuR1xXWgD2HGTWGASzl0ObMURoAg40vdU5359RAP1XCh3bbhTYbB7QnsUdyjkWbRtwS+UM5XirQR0Ch/KOmn4mpHbs19Y8EC5O2foqhP/mxlSG0Fk+xFr0kAr810IuR5Y+5xwH6tmPe6eUSQnQby3OneQaZfD+JoORJdE/MXs+cm1aObpWMUlCEzE0dlz/mSowK86tjkP9AJmzYHz10n29TG5U690u+VCNC4BkgtBoHJWrDsQflTfLOWLjrttOfSfSkNMbu7C/f4xR6EzTuZgUkDqf0Lw6Ak3rJwIF2XW5b6TvxsuDAfIHJkQ5qJrICUed61i5Oy/fVUB2QsJgEMYzC/zWDCNIo7WcS450/UV7BE0dlklLKbb3DxPKyayrekRVzhcXqpi8wXDxnBUXFBus8yMzrRFTwY13CF2MX8Nlm6HuJxf266nniNFlzomaY0AjXm5qOZG6cdMZOQUsB3BFnBMClXnVt9zNn5V87ph+o7vpHcZXoKrnUb96K3rm/uxi7xFEXV8hMdRg4j6FX5LU9WXD93Ui5PgIczRtgZEY9EwvwfoSVrogyOq1lYU5CYEbVanqjdc2LBu/HdMeNjIz4rELnTPoepNx6f5a/sBh7PMiqjMN0DhCyEm9RHoe+g8DzI2moLfr7XlCcSA5Hi8cSr+pk5jwfH3bsb8vLYH2KNiI11KdtNxR3p2y4g2Iur8/tAdSvUdcfiUTfPY458sfnZFAYtBqkfN7j/j58lksR/CqhOC0y91UJiScIj+gvkQbodv2d9eEDmYJjL0xjpUEzDxfLncr21Xkn2iaO7hmMwRKZji9oeH+yii1OtriefdU1kZ7KNKuNDEvhVEK1hRTZfj7/1LWHthqs/rI
 yVVDq1Fe
 +WrfjdsSzzQO1R44iPrnwaSBt7Sy1eSQ6wNbY45RRKApqmap/3EqsOni11ORir2KekUye/DDY7yf4ErVVD2gGfHM00wvvivbv2pbv11AzTV2m6zwHcvjfC/2ceaGtLqUnokzqez1bQzvx3r52SXbx2qoKyn0aY7vaLzK2omeowXy5diT2yWWWhW4gylmeYYa4qjMGf5NjfoBbF/JCcZSWjJLQSg4VxvG969G6x5K4R5SYpSgJOBw5iYvlP76hcI+Hz9N637sRfZ8TAmtXArdiduOA3KcuRKFOlyoZxubKOK5DF2PopsFJsnFcO4DVLQGxCT2PohJP45l4wtlXIW4+jePbL56rnYkHAcYzCI7y0rkKIvX8hc3ma9iN2aCNmhwgIf/rFAxGrt6gEME2RddVIsxpWIRh6I/ANM9pObKRHql1g3U7IHpVHG8z1o2i19hrvY3xrnSf6dJYwTeOYMJHsMelQVTXYkKVDtNMpv/UCRU9w6SAfQuvnTUgYAAGv4tAyUSVINw1lRS0vrwpg4AJfnORN8nIPfVoD9nK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/19 05:14AM, Barry Song wrote:
> On Tue, May 19, 2026 at 3:57 AM Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > On Mon, May 18, 2026 at 4:26 AM Barry Song <baohua@kernel.org> wrote:
> > >
> > > On Mon, May 18, 2026 at 5:47 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> > > >
> > > > On Sun, May 17, 2026 at 04:45:15PM +0800, Barry Song wrote:
> [...]
> > >
> > > I think we either need to fix `fork()`, or keep the current
> > > behavior of dropping the VMA lock before performing I/O.
> >
> > I see. So, this problem arises from the fact that we are changing the
> > pagefaults requiring I/O operation to hold VMA lock...
> > And you want to lock VMA on fork only if vma_is_anonymous(vma) ||
> > is_cow_mapping(vma->vm_flags). So, we will be blocking page faults for
> > anonymous and COW VMAs only while holding mmap_write_lock, preventing
> > any VMA modification. On the surface, that looks ok to me but I might
> > be missing some corner cases. If nobody sees any obvious issues, I
> > think it's worth a try.

From Barry's description, I think what he is saying is that the vma
locking has caused the mmap_lock to become unfair?  I think what is
implied is that the per-vma locking may stall mmap_lock writes for
longer than if the mmap_lock was taken in read mode?  Barry, is that
correct?

Since Android is doing something (according to Barry) that should not be
done (according to Willy), both of these together are causing slow down?

> 
> Thanks. Besides the creation of processes via fork(), I
> am also beginning to worry about the death of processes.
> 
> One thing that came to my mind this morning
> is that when lowmemorykiller decides to kill an app, we
> want the memory to be released as quickly as possible so
> the new app or user scenario can get memory sooner.
> 
> In that case, if the app being killed is performing I/O
> while holding the VMA lock, the unmapping procedure
> could end up being blocked as well.
> 
> If we release the VMA lock as we currently do, we allow
> process exit to proceed.
> 
> I haven't thought it through very clearly yet, and I
> may be wrong. I'd like to do more investigation. I hope
> the apps being killed stay very still, but who knows—we
> have so many applications in the market.
> 
> Meanwhile, if you have any comments regarding the death
> of processes, they would be very welcome.

The oom killer only cleans out anon/not shared vmas [1].  So, what this
would hold up would be the actual process exit path.  Although that
would have resources associated with it, the amount of resources should
be relatively low compared to the amount freed by the oom reaper, right?

The other entry point that's mostly to do with android,
process_mrelease() [2] will end up in the same  __oom_reap_task_mm()
function.

So, for the most part, the memory will be freed while the file backed
vma completes IO and that sounds like the right thing to do anyways.

Thanks,
Liam

[1]. https://elixir.bootlin.com/linux/v7.1-rc4/source/mm/oom_kill.c#L547
[2]. https://elixir.bootlin.com/linux/v6.18.6/source/mm/oom_kill.c#L1210


