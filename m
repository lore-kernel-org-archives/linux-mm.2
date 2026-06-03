Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F26A4CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 07:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DFD26B0088; Wed,  3 Jun 2026 03:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7F16B008A; Wed,  3 Jun 2026 03:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6D66B008C; Wed,  3 Jun 2026 03:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 193DC6B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:08:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A82AB40294
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:08:07 +0000 (UTC)
X-FDA: 84837722214.03.6F170D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E3193100009
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:08:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JD/8LfUI";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780470486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XlmdpT4JYV7meBHB+uyUg11V7gve6Af/lDfr6KlnYj8=;
	b=OrEn3Tcl6oIfFCad9hf8BM/Bq+mUluDGl+ShmJPRRqYte+Z8Gjh3QIsdEsYN1GMXyvMa3E
	DpGcKo3VNyJESve/+lKjQPivYfCn9Mvpn3lsNizymLiOe190LciB9xpSN14WMwTN35ylec
	oR+amX8q7cDBb8U2ja4aDogDfOiDDpM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JD/8LfUI";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780470486;
	b=fPR8xOREtYCuiQ9Ct81ipPU2OrMgrU0HbsZNjz+inVed43LhlkSI2HCE4/uQUhuD/AEBdQ
	TjWA91oxaMzIsViSVhks6Elh4q8c+XOGzp5U/yiah9ClxK4qwp0T0PP1F7OeVI1vKqMfUi
	ceJ37rERluRD511Rt5VBcu9l/UAVOfc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AF2D843831;
	Wed,  3 Jun 2026 07:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1AA1F00898;
	Wed,  3 Jun 2026 07:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780470484;
	bh=XlmdpT4JYV7meBHB+uyUg11V7gve6Af/lDfr6KlnYj8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JD/8LfUIQTxpPOnSS0u744+AXlLaxoZwg1g6Lxrq/IjyJ4a7jp90chFnFzfLhkiF2
	 z+UQqmlEgng7WqTXUMORV2SyQGHVrlhnQ5TipVf7BUgk88Hgl3xXPueGfU5QfXk9WC
	 Je+AIHwzRziAxWEuVjX7Rnkc0DBeccZd26lVTJ5BEFCjO7J/to+ne4mrXkVmqunex/
	 N/XY+RnCldJiFgc3QpYMj5jBaofMsY8ZYhe4RZuIGaDqh4hSoGTadyOgkW2vwnf8B+
	 5TZOqSNKZRVwwe2s3AI9RQ0xXqWx95mEzshcJhZOHI8kVaXCI+l3+/GLnbRLPpJfQs
	 /MGj0qzVLJVvQ==
Date: Wed, 3 Jun 2026 08:07:49 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"david@kernel.org" <david@kernel.org>, "willy@infradead.org" <willy@infradead.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>, 
	"luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, 
	"harry@kernel.org" <harry@kernel.org>, "jannh@google.com" <jannh@google.com>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, "matthew.brost@intel.com" <matthew.brost@intel.com>, 
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>, 
	"byungchul@sk.com" <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "jparsana@google.com" <jparsana@google.com>, 
	"dvander@google.com" <dvander@google.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Message-ID: <ah_O9NRJkH095jUP@lucifer>
References: <b24b4a8198ba412f8b8b42c43dccd058@honor.com>
 <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
 <99dfc4a50f3643a6bef6deaeccfcf115@honor.com>
 <ahlzj--3Gm5pD9ge@lucifer>
 <a90bcb0fa3a044588350e92a78258a09@honor.com>
 <CAGsJ_4wFr89M2i8pth79swv3==i8SGSMWrbr+Yp2umwFTuCShg@mail.gmail.com>
 <2e9175ab-f9be-44c6-bf1a-a82aeed18f98@linux.dev>
 <ah71gjj21rLIuTnb@lucifer>
 <CAGsJ_4yKtEnCEyLVpzKUNDDw0AwttnFhB7c1sicBpjecBxATQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yKtEnCEyLVpzKUNDDw0AwttnFhB7c1sicBpjecBxATQw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E3193100009
X-Stat-Signature: entzseos8qj9a5x6w86j4k56grd4yudb
X-HE-Tag: 1780470485-181734
X-HE-Meta: U2FsdGVkX1+abezCG42JWs03Xydb9JVfXyCWLYoZlrIAHmFijyAu5GpZ/mXveXEaaZU9qQp7bT9FStndvjHVV3lmQrIJmfroRlvcE7Q/VvS1zZF3z9VwR88Ho1s5xmdAk+FGf02ocxV9HXFfHk8yTLsU6DV5pUqmF/OXhCUsVzcNvqRw0Zm7LdR+7TOjV/TmY20xD33g5a46mfSnrvrbZvjX/Rc7SJimHIQl5n1x90RQn8bXOy6kUS+pwVOkQiyWTqIzkAoxb04ZSv09ykihTsj9C3RqIaQmNcc20MwR2HzDArBSWKky7VBW66hnwAup137UdF3r/xmPK7sPIL04CqUvRpNm0QRVr2SBGk5yflh1I1IKdmu9krzD0ZKm2OTRXttLV3NNA0cv41aEVPvtg4VH23fokrlqARgpo70RsXvs5eiX+2uJNv3/xnFriiTow37ieNs4pq76A/IBi4s2qg5/kzLtJINdFZKryRUBd6pmXPiZUq/QOdd0ms2b/MUyZUyv8xdX34eDkAjvAGdmgRtsiYQ3UbK8ybt9LRDg0hw9ITzhDnAuzYDUhYNZ7bCYdijKG90l3kuxitWkO7j5OgtJd65VxjOJOORPVBcW/Um8CeKsDLfhj0v06SytaytF6EGEmUyWPLz82Hlxka87lL+STjH4V5UVECKuL0zPtkCC6gTAP+t0LkMHSFunbBF4MhZIaDwjFFldFfOf2w4iK108p7uM17rMHrvNQ3wdX0/R6CbJ7VeE6lXGhRIfaLY9KnfhMmneVvaJfgslTO19MryhIFYGjCY8OIqxf5FPb8Cn4uyX2i0L3zXTRP+Sac3LBIpUV0RGCRRBjSBCmBvl+nACnimBpPlkn758Wal+v0SNxc76kPycUlsTgGjlO5PvuXL8qm1lxT5P2PGN2yw6Xsg+pJK8wrejCVvcXiCnfsa6D2cdGH8pUShS+dz4nrNF5/hT+aEs9vqHTaPPa4C
 p38UsTIK
 kb4sn0P6tSZ4D91vMtAYhicm+dXEA6cNPHlg0Qz6/d3ZRiSkPi+R8cJyxeVZMydoh3lfERqsjYEFeIZNAu06w10WMJlxervOaKehuVCc7B2Ey0mgTm6ZxoGpJyzpHtUetjP04ajeY+CIrcn4FMwgJJ6ht+8OfaKkQYgT/9BZyp7pMLek38m5OacTm42mfyRSad33WZq1JF7zgV8wFqGF1BZAANBqZav4F4uCUp3g9RPj67KsshCXu4KAzvktLkKRa2Sk+79HPFh9lgI70R44ZYkrX3O6nRbxiIIQR6sQKALhtsv9bf4IqGuAZr+WWu0C3jgD3Qwn1CZW4e9toxLqy3ZxE7lwWzxA50vPPMce2KRkvnLBP31On2s2hMFj/vzoq/aXzoYNWZBD82Bjd8/xlItDOym1DM/ZPT88Ub1+8arvQ355re+0+KH8zuPiegXn+cJcO5Y/EmsLk4aaIEq3wyi6do6t1Q1q2uOPYIGqeKOuNoNZ68LGAGwq91Yte2ETR5vy9GwFS4tLRRNE61fJOZTT2196+hE//8IHl28mkc5/0FPs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 07:03:53AM +0800, Barry Song wrote:
> On Tue, Jun 2, 2026 at 11:37 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > On Tue, Jun 02, 2026 at 10:46:35AM +0800, Lance Yang wrote:
> > >
> > >
> > > On 2026/6/2 10:15, Barry Song wrote:
> > > > On Mon, Jun 1, 2026 at 9:46 AM wangtao <tao.wangtao@honor.com> wrote:
> > > > [...]
> > > > >
> > > > > You said discussion was welcome, yet when someone offered even a
> > > > > small comment, you refused to continue the discussion.
> > > > >
> > > > > If I had known you would be this inconsistent, I would not have
> > > > > replied to you in the first place.
> > > > >
> > > > > This will be my last reply to you. I will not respond again.
> > > > >
> > > >
> > > > Hi Tao,
> > > >
> > > > Please don't walk away from the linux-mm community. I read your
> > > > patchset and found it quite valuable. It not only reduces memory
> > > > overhead, but also eliminates rmap costs for exclusive folios.
> > > >
> > > > Since I'm not very confident discussing technical topics in English,
> > > > I wrote a blog post in Chinese about your patchset:
> > > >
> > > > https://mp.weixin.qq.com/s/k00tzhTl8HbL3k4G6ev4SA
> > > >
> > > > I have to admit that I found the implementation quite complex and
> > > > in need of significant improvement. However, I think the underlying
> > > > idea is very interesting and worth exploring further.
> > > >
> > > > I'm looking forward to seeing a v2 RFC with a cleaner and simpler
> > > > implementation while preserving the core concept.
> > > >
> > > > Regardless of whether it ultimately gets merged, I hope the discussion
> > > > can continue.
> > >
> > > Same here :)
> > >
> > > Tao, please don't let this thread get you down. No first RFC is
> > > perfect, and the idea still looks worth discussing :)
> > >
> > > Thanks for working on this!
> >
> > Guys, this isn't helpful.
> >
> > We aren't extending anon_vma, and I am working on replacing it, that's the
> > bottom line.
>
> Not trying to challenge your bottom line. As explained to Harry, I
> have no doubt about your expertise in rmap and many other mm
> areas, and I deeply respect your work on rmap.

Thanks I appreciate that.

I don't mean to be 'mean' here, I'm only acting in what I feel are the best
interests of mm and the kernel.

>
> With more discussion, we might gain additional insight and
> inspiration. What Tao has inspired me with is the idea that if we
> assume most real-world processes are leaf processes, could we
> simplify parts of the design?

Maybe I didn't express it clearly enough at LSF, but this is entirely a key
point of my CoW context design :)

It's true most stuff is leaf, and yes we can take advantage of this, and CoW
context allows us to do it while also unravelling the issues with anon_vma.

I am actually thinking of doing some incremental changes as part of my work
possibly if I can.

I maybe need to expedite that to bring some clarity to things here...

>
> This is why I suggested a v2, to improve the clarity of the cover
> letter and make the code easier to understand, and to see whether
> there is something worth considering further, even if it is not
> suitable for merging.

Right, I see. Again I'm really trying to tread a fine line here between the
technical discussion and not pouring more and more time into a discussion that's
not useful to me or the community.

See [0] as to my reasoning on this :)

[0]:https://lore.kernel.org/all/ah887A5VkXOcmq-g@lucifer/

>
> >
> > I have presented compelling evidence suggesting this is AI generated. In
> > response I got more AI-generated nonsense. There's no trust, the code and
> > analysis are all wrong, end of discussion.
>
> I am not an AI expert, and I do not really use AI in kernel work,
> so I am not really sure what counts as AI versus non-AI. Sorry.

No worries!

>
> >
> > >
> > > Cheers, Lance
> > >
> >
> > Thanks, Lorenzo
> >
> > P.S. maintainership is utterly thankless, and I don't really expect much in
> > return, but honestly reading this, given the case I've made here, was
> > really quite disappointing.
>
> Understood. I see your position, and I personally have great
> respect and appreciation for your work on maintenance. Sorry if
> my words came across as disappointing.

Thanks, appreciate it. And no worries!

>
> Best Regards
> Barry

Cheers, Lorenzo

