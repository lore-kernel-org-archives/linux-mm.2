Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D37C606A8B8
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=B3knZGFb;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=1UQSHGCM
Received: by kanga.kvack.org (Postfix)
	id 4F3986B05C7; Thu, 12 Nov 2026 04:04:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A3516B05C8; Thu, 12 Nov 2026 04:04:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36A976B05C9; Thu, 12 Nov 2026 04:04:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 12DA86B05C7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:04:17 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8493C042C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:56:45 +0000 (UTC)
X-FDA: 85425861570.15.4A6354B
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	by imf14.hostedemail.com (Postfix) with ESMTP id 60F95100005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:56:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=B3knZGFb;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="1 UQSHGC";
	spf=pass (imf14.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.147 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794473803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rEDyzDvctiKMCWHEwGxzSSTUsEjyrAP4XO5pemqaf/w=;
	b=ftCvLO5lnR/CgioYDKrsCDkg40vLBgsJHUoPTTZbg1nHAmI6oiDWlZ17f4TNNO7/HudaXd
	8ruHjnDQcg8P2+SZMFf8R99dY8kR3s1/GOZ5blq+s0Wbu9R0kYskp3rX6q4mqlKoagRXqQ
	gW60hforlhIsKtHqT67s/Q7D4HExQ8U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794473803;
	b=QjDzZsPgavNAdqYlmd9Ec2t/5UPXH8QSGDkKPtsvBrrX/xRtVMMI5qfw+QPoLsI2Z4qdLz
	TKwOEVRRapOhDiFpGLNUfGR/5+WOw/Qt2EBmd83hzSOr5/fBtIvMgfZwl1u9v0tVC0FfPm
	mYo4SAnLQ4o15/HqC65HTYTz3MJ5et4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=B3knZGFb;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="1 UQSHGC";
	spf=pass (imf14.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.147 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.stl.internal (Postfix) with ESMTP id 672271D0024A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:56:42 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Thu, 12 Nov 2026 03:56:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794473793;
	 x=1794560193; bh=rEDyzDvctiKMCWHEwGxzSSTUsEjyrAP4XO5pemqaf/w=; b=
	B3knZGFbJoyqxhvAjg5ey4pgvXQ0+dX+2yrqxypUpfmLl52FvtNsp7+AX8SbQ/eD
	QB4o9/31f8xFXCXe56hraiMz96Up0KKZvOb2Y5C65VShVM0pPaDafBjDrSUg42VY
	tu9bgejyvmqkt1Sc9Y32autzBDXmungVYOYMmKlWzY8ke9h7yX3aXbw7wQqSIKs3
	owqqHduQlPeKvwCMeJG/2LJco0+TSA+EyuE40Mo+9A/AlkXjnBpb4ObaqIe0Doxc
	7R11bWCv4vRYIh1QpCl5N1NsJgYyvfBQVk0IZtDm5jfVeuHETVudImiaPHrGdr9O
	vc7/hsrU2ooBu9I+vxQIQA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794473793; x=
	1794560193; bh=rEDyzDvctiKMCWHEwGxzSSTUsEjyrAP4XO5pemqaf/w=; b=1
	UQSHGCMZ2A3z8bSIkkWxeq6RnxTXCPrxpPWHAyytgP+bJFnjHFjyYHqv4hm0qCHi
	QYj5WIQxDSWITpVoqdkvKqOQ6WfVb701r08hcNQLu5c31R4jKN1xLVhnaNofI2HX
	7FdlCq7ohwLhQBbrPhAF/DBKK326jQC/kxRtegHB3eLgHLY3PWtxVOOFT5sBaYxH
	iEXrIpL7ps7Vq4atKdHaQMjAWH1A1hydNB2gIjGap0JgIebeP6f+c/OshDqYw/Jr
	vUJZRxhTpwPPzneK6Bk38wsyBQPOmtYPcLegI1AUZjxz+ntB7H/oAx/pXKxLSRwD
	hopHAfS59cof80uyciXMg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794473793; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:J9xfKR3j+LFABVsqaZNogE/OSXGEqdKsw9e4VXyCPc2sTCe
	I3n538uaI/Re9/f7/ZKQ2QnHtvD5iNKaiWrqVpxFDnAt54URzLYKvNV3fz5kPvhQ
	BUbO0bi004ylrVykpzfdnQMuSJJ/qTI3VtHRuNJqEnuTKTZvHkGJSB9o0quIutn9
	i/ZcNXLxKO9d8a08bGUPt6FwFOpO2vTAA8MZq3/GsqXmsaqud5wJj3bG0B5lmgyT
	nfkonn3FQItTxDbjMAyOpnfhEDFhELYBo3bwFEvAuOp5LPaOKteVOyKNOJo4ecSp
	qwIRi3Us0fkqtlyYDVWJz7W1k7ZSpsdJd+gRk8Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:bxT2HtsddpIKccxw7D1EmmeuIKfYJp+MJ2nSGobHrHU=:sEmA3MCn6JLrIUaQkRNBmsF7Hz02Y0iwntBVDLMI0ZY=;
X-ME-Sender: <xms:NH_1asWKISFAZPfViYwtF0t1h1O_t_TUK-yUOcamOFfpOmsJjSP4yg>
    <xme:NH_1arbnH92k8S1-bT0BlraQyd9qZk0y0Sn00uORJAF8vwlxDDfIbDO0bjykC8awK
    bmkq2V7jpdyyeJMnsesd2PBlWQc6-IxQ5LTwSVYBMhTPwlK8kfbKFQb>
X-ME-Proxy-Cause: dmFkZTE3ND7a5+W1Z07eormEvJEB+XP9yRNxmJWlhqo4nFZBM2kAyJQF7ZgJlr2V+yFcEa
    l9MRmavypBJJ+1A3waVwnEHhrM4U0pZpCmMYKIXvfnZkXMGbKdecZtrxLKkn6LEq19o5fE
    gPq8WxneDUi3v4xiFBdFxJqhhRjF9l4qFHfKxbM/8/kEKMzoow8MOCqc8EgLK/YGye/NOx
    vJ+BeW0pJ1MEvAjPtKHXRRQgaz1GtmTJKeuhP2oScGxUjAxi6NvtA3CvTfeHnIQJVEo9ZV
    dg2D6P1vG5wAmVpHBLy1jTDsA3jHwbynxf2/c8p8S1vmmHEGJ6xAPZTTV5Umrrj1UI3Khs
    rJijqRdX01D2IUPunT3qBzgERFBVZ8jYBYw1H3yAWZItZ9j4airbtb5XjMvlG++YM1xjMj
    nmYen9siqd5jtfWF+5rxuSCWu//0CHbbjZOuheK/lwuiWNnUidGYUvyWOFd9E2OfMRQyJo
    NHUJLrgFmF/YLzCIRd6QgoB46bEjyL4va2ECLKod74mkfUM9Bt3nKjoMZsBw6FKGE9i6pb
    kcdlCi+42mrcvNt9/oRYrgd7nZbADhLRxQvbPjTXfqJ8XvHIJ7OuVZ6HyNF9xugO4WyMQv
    IHitba4dtlHe8UFBYfWm9s4Tizbuv07yoIS03Wj6UhMEjI5BgOKm5i1NzONA
X-ME-Proxy: <xmx:OX_1atJeGP10qV3r_BB9LlbDWvzjzAT8IKY6g0XHpnMofHCEovQSTw>
    <xmx:OX_1ajjzmcyTWNa03jroLuvYNjQrc-9N6_xxwGxAK_v1HHphOwD9Lg>
    <xmx:OX_1ahRgitGd4zqX3yfmA8xLG4zFwqJjTP381SaWrv0nOrdNocAf6w>
    <xmx:OX_1aoabTMJLtPTZZWDyERW41w-hFW-0kPrJfUFDo4kw2bxAwi0xvA>
    <xmx:QX_1apsoJxByQcSYtOm475IyTqWu9-y7wuRQ59vqRM_Lw5w34HoWDLYb>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 1A43C32A0099; Thu, 12 Nov 2026 03:56:20 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AD8wiEBgakfZ
Date: Thu, 12 Nov 2026 09:55:48 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Christian Brauner" <brauner@kernel.org>
Cc: "Matthew Wilcox" <willy@infradead.org>,
 "Kirill A. Shutemov" <kas@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Miklos Szeredi" <miklos@szeredi.hu>, "Amit Shah" <amit@kernel.org>,
 "Jan Kara" <jack@suse.cz>, "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Zi Yan" <ziy@nvidia.com>, "Bernd Schubert" <bschubert@ddn.com>,
 "Hugh Dickins" <hughd@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Malin Jonsson" <malin.jonsson@est.tech>,
 "Richard Weinberger" <richard@nod.at>,
 "Geert Uytterhoeven" <geert+renesas@glider.be>, "Nishanth Menon" <nm@ti.com>,
 "Frank Li" <frank.li@nxp.com>
Message-Id: <e94bdf7c-eae6-4f64-bf93-0aeedca1a22e@app.fastmail.com>
In-Reply-To: 
 <CAHk-=wjGXBnme-N+HvbzHH40ftb7Suc=kZVT5cuintQWyMHJ7Q@mail.gmail.com>
References: <20261110145241.536019-1-kas@kernel.org>
 <20261110145241.536019-2-kas@kernel.org>
 <avNuQqLf9CG9dSsE@casper.infradead.org>
 <20261111-heimreisen-ungeziefer-empfunden-a892571f2c07@brauner>
 <20261111-thunfisch-wirbt-waldrand-822275b2d3b1@brauner>
 <CAHk-=wjPY=kfgnmtx4COEQjD5UzKx9m2-=KLGAZP4d=RKEH+pg@mail.gmail.com>
 <20261111-stumpf-montag-miterleben-c4e2feac8090@brauner>
 <CAHk-=wjGXBnme-N+HvbzHH40ftb7Suc=kZVT5cuintQWyMHJ7Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] virtio_console: copy pipe buffers in splice_write()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ssaougs7pomkqc3argfet5dzk43f71g8
X-Rspamd-Queue-Id: 60F95100005
X-Rspam-User: 
X-HE-Tag: 1794473803-343745
X-HE-Meta: U2FsdGVkX18mcFfLbrLndC+whCL7+YP7G2Zdlzrq68/lvtT3Y4a2VFTXcyNcEMf3XL4RcuRvc9UBIQxqQxnbPXoyRHxEr9VzIg+nz7QYISUZ6kLDeRat7BGo+wHKgr7j2WrLZPKDL+zUEsaggyFduc5nO8oTJs0GaLRO3cJ+z2nJtQt/sOstKPwwkq0vuaWZm5eNrR5lk4uJJMS6HRP+k+ytD0mNV8Y2gdWzAoJXzJZi10pdEhyFYFQBsw6ITVJ7omK5uJQMlsfahi7e7Z392bjTNhUcDs/irWP3WhrGeQwux2TMK+fECtNOki7GbNdoleRjQNMGoiQerqJ79zTn/bEamFinM9ZjYRXLXmqXvOH2djeHV3tiJo5H617SXDfauB4aTDmEuquLz/pRBA4Era8THrnFV/KvT/8+pcIK+L6Bzy2L3KRBRkSEo0r4x3j7T1G/RFt+6cth1Uz8xM3V59oEOq7sVIA/NyzQGmZeHcvEtFjQYTLC4tnoJaD7iodjXejFf+wI7SlfzX88lL6ad/WaWFyPpukCR520MOq1POyW4DfY5NxEC+/7U7T6pyC98HK+jInZsuaDt31mvsh4z7XNw027gHMVKp2N/YJIikqnhHk6ODylaIeJ7ipd1OhZaLBKOTVTTS8JbfOylkgmpvZaXoXsl2WEfjvagCe0Fn99BYrMke0SfUt48loiUfoZwdJHMWJcvqydkOFRgKGBroZ5uJ4sE3VlVcXjUUh0thUs6GNmgdSSeiybexFoDfjo4yYYAm/Zea7F7/yk4PjgAzAEM96uqjXi/BoQ9A8DwWYPPbGr0jNUPXrzQzc7wQW5CXFuqPq6eQVdbMzW69riJOy7WXqV8bGo6O3ISQ49DFuJGPRGIwTf5xdATgjbNN1k4foUu/mcnhO6rpVqmIfhB5IfYSbga+JKCfMUxsCIg2j7u5F38GzxNb48OLte6GckuW29F3DHzmY/Zl6ous4
 ZzGWb8gD
 XvMlzJacR7ntblFbMnL+yvyhPM7iecKoeAIwAMhQI2m6t+CFDT8KyNPansgKcGpQlTcQmwb+2J8cfsyBvLyJsWqTG1FNkdVARjtMw1RFJ9Zdtltg3K8BouwB/2d+ibtrn9AokTrqGccd5Rw6PozjeSn4p7T6RQgQDvEu1Nwstu2c7xxoQ66Icyir/5Eg499L5riVq2AALbJtgO3Mw6vmKVRsn1YsQda6bJrfU85yoIUCog3Efx30sDRwjimjj1qf3I2Ix70drJ1SIFIep6I7QT6pj4Uz1BDWecSDTfEZsQVAdjPHqeV5c8C3Bj+CBqH6TrrWH17dVOqEVRwTWjYVtQ18mw99zRVXmKOsX7DHv8TvnyF2bABh/GAM6Df1qrSJ4mM/jJo0ieui78r303j2wg2ARIWE+YS7J0rOruuYNO6AnOgxNwuQlDLTHmFRLIiG8kbs344HB8y0DNyZZ93jOGDKkef2xyCkalbCrsX+Wgl8uIVWqrbijehr0pK2x1OrNt8MoNVSFFfei6C5mkfESeCP+pWimVhp67AEi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026, at 20:26, Linus Torvalds wrote:
> On Wed, 11 Nov 2026 at 10:53, Christian Brauner <brauner@kernel.org> wrote:
>>
>> If that's the official new stance than I'm very happy.
>
> I definitely want to remove HIGHMEM entirely in the not too distant
> future. And before we remove it, we can most definitely document the
> fact that we will not be worried about insane users.
>
> And things like security issues count as "insane user": if you use
> HIGHMEM outside of controlled embedded setups or museum pieces you get
> to keep both pieces when it breaks.
>
> IOW, it's legacy. We should aim to not introduce *new* bugs to it, but
> if there are pre-existing bugs they very much count as "don't care",
> this will be removed soon.

Agreed. There is also the option of adding Kconfig dependencies to
mark things that are known broken with highmem when we either know
that it is buggy, or we have a good reason to break something that
none of those remaining users should be using.

> I think the only reason it wasn't removed a couple of years ago
> already is basically a few old 32-bit ARM platforms that still used
> it.
>
> Those platforms still exist, and I predict that they'll still exist
> next year, but if those users have to stay at the current LTS kernel,
> that's fine.

I tried to push for what I thought was an aggressive timeline
last year, but that would still keep the Arm bits for a couple more
LTS releases and only gradually reduce the scope of highmem in the
meantime, removing support from architectures, file systems, and
drivers where possible. See https://lwn.net/Articles/1051010/
for a summary of my talk in Tokyo, including the slides and
a link to the video for anyone wanting more details.

I also prepared a number of patches towards this, but have so
far not been great at following up to get them merged, sorry
about that.
I definitely still want to revisit this soon, in particular the
bits about defaulting to VMSPLIT_2G_OPT, and probably my patch
to allow having (limited) discontiguous lowmem on Arm systems
with a large MMIO hole.

Scope-wise I think we absolutely need zsmalloc (zram/zswap)
on arm32 to work with GFP_HIGHUSER, but enough people have told me
that they still expect to need anonymous memory and ext4 page
cache for a while, and probably powerpc32. The majority
of __GFP_HIGHMEM allocations can probably just be converted
to use lowmem, which would eliminate a good chunk of kmap()
calls as well. In my attempts to do that, I came across two
problems I'd have to solve though:

 - Movable allocations (GFP_HIGHUSER_MOVABLE) imply highmem.
   while I think only 64-bit architectures support movable
   pages today, we cannot currently express an allocation
   that should be movable on 64-bit but lowmem on 32-bit.

 - Internal users of tmpfs (in particular DRM/GEM) usually
   don't want highmem or movable pages, but actual tmpfs
   does default to GFP_HIGHUSER_MOVABLE. Separating the two
   is complicated.

I added a few people to Cc here that I believe care about
having several more LTS releases with some highmem support
because of existing customer requirements.

     Arnd

