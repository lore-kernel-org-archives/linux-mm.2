Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC6D9E81A3A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 15:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1BF6B0005; Mon, 16 Feb 2026 10:45:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083316B0088; Mon, 16 Feb 2026 10:45:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4A36B0089; Mon, 16 Feb 2026 10:45:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D76E36B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:45:47 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D07F1B5532
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:45:47 +0000 (UTC)
X-FDA: 84450745134.30.41A76CC
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf25.hostedemail.com (Postfix) with ESMTP id 34593A0013
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:45:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm3 header.b=fLcbJWSQ;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=TEBdSCZw;
	spf=pass (imf25.hostedemail.com: domain of andres@anarazel.de designates 202.12.124.159 as permitted sender) smtp.mailfrom=andres@anarazel.de;
	dmarc=pass (policy=none) header.from=anarazel.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771256745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=byd/v2KyqyDmof5svJZ7UzEBF0pNwQx35fX6HwsRSGs=;
	b=E/aTxi5HMFKBnL/pLYBbUryq9Ab2S07jftNjFZ1Vmkof6wzDfYl9yFaooiG3Hr4au/X8Iw
	6c+ymojlnb2S6soI2w5185DcSjqWCZQVtjYDZH2qq5uezJs761TubyaZVTxozT1Vose6GZ
	62taBYRR1Qetwc3UucvhrK+rjD0mhm8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm3 header.b=fLcbJWSQ;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=TEBdSCZw;
	spf=pass (imf25.hostedemail.com: domain of andres@anarazel.de designates 202.12.124.159 as permitted sender) smtp.mailfrom=andres@anarazel.de;
	dmarc=pass (policy=none) header.from=anarazel.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771256745; a=rsa-sha256;
	cv=none;
	b=p/7v7/VyU+obhBsvAj+R+gunwqVXh0PTRfXkFK5WtrEMrKwcrb6482o1uL/3ZW06hWXkDE
	i1x86VvmPzTlZCya/0SsW9YXeUcyFHv5F/Y7Jo/6PL8Fluweo6fQz1luY8n2I0ceQZEkX/
	Cf8aZOWMFOHbo96OOlPiOa2PQ7N4tls=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 8FB777A0132;
	Mon, 16 Feb 2026 10:45:43 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Mon, 16 Feb 2026 10:45:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1771256743; x=1771343143; bh=byd/v2Kyqy
	Dmof5svJZ7UzEBF0pNwQx35fX6HwsRSGs=; b=fLcbJWSQjsRhBbOBtM2EW8Z+7J
	MqQnRDhJLYSMACQ3EJqa4WizGze79ppT7QggWvX0dP2MEMHguctxA7EZdn5v5g22
	78F3huI8LgHKdVH3dzS0fqJ1EtOvsaYOFqSiADeXt34dhqaItUNbRME+xKU/gJFq
	esAWi4t+c7F5UvMeUSZhKZ5aq1J1mphwvYYqSBXU1sHA67jmbOv4KzSOzxGsTd6Q
	oPXzwDneb/A6o/QMslyJO/0mhLwXg5tyCT3jRx/K16d4sn435isg8kXvu9nzZOTt
	QcrZLq/6YgWjUiersqTNFhBFStjMxT0Objk2aa+xdbUxFjYLV/I2NY0wf8tw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1771256743; x=1771343143; bh=byd/v2KyqyDmof5svJZ7UzEBF0pNwQx35fX
	6HwsRSGs=; b=TEBdSCZwiOP63qvlCuIBpa6qUvBOh5Z+T7jXUo+gKDBrBiIk3RC
	wp7MY5EY94uq3MlfAdpBZgPQ6iAJzB7PxWTcVc3JaUheJlizdT7O6w2Fzj4jCz36
	dP6nCJr/YHi8uPf4EU0l+IeqW4YiNGT7yi78bx1DpYgM6wCbtobMhFezzz32MtIL
	7zJ39G1E0Cl9MmMo6wHs+PRKgWoNPXiMUQ8HPhDgQ+wUMwpEcImYOjmNWheMwH+e
	uhmiT3094iGrZWpACEWO9Bj/ASy7+VWJ3PHHzb0+kdPKd7Qbf+LfrZqbwlXC1D2u
	Xw/dJZwCyTWihCGbUd0JfxldtjXdqgzKifw==
X-ME-Sender: <xms:pTuTaa_UHB7SBUzARRWugCYU1fi6tg1hE4XJS-reok_qw6Msi5ykiA>
    <xme:pTuTaRomk6HNgnr-JwZDaToS0XjX02Xv38_eHpsbstwupjNS9i8iiQalS76v7Mtqo
    h9rzioOL-Rh6wn9AA2vvevLSOly203B8YUeLObfdLo7iS7d6-Izyg>
X-ME-Received: <xmr:pTuTaVHnyV0scUE-Yl1IbhBsGRO5nxCm5pj5dO4LEIy18KkLUzAaHUF1IND_FXBO-LDIiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvudejvdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrfgrth
    htvghrnhepheeiudduuedvleetjedujeffgeeiueevgeehjedtgeehueekledthfelhefh
    geelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdgu
    vgdpnhgspghrtghpthhtohepudelpdhmohguvgepshhmthhpohhuthdprhgtphhtthhope
    hrihhtvghshhdrlhhishhtsehgmhgrihhlrdgtohhmpdhrtghpthhtohepfihilhhlhies
    ihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopegujhifohhngheskhgvrhhnvghlrd
    horhhgpdhrtghpthhtohepmhgtghhrohhfsehkvghrnhgvlhdrohhrghdprhgtphhtthho
    pehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehprghnkhgrjhdrrh
    grghhhrghvsehlihhnuhigrdguvghvpdhrtghpthhtohepohhjrghsfihinheslhhinhhu
    gidrihgsmhdrtghomhdprhgtphhtthhopehlshhfqdhptgeslhhishhtshdrlhhinhhugi
    dqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohephhgthheslhhsthdruggv
X-ME-Proxy: <xmx:pTuTaZl7LPYcsR3rciVtoJqfCZEOB0JQbGcoz0-ic0KULz8k1mwQAg>
    <xmx:pTuTaZ8KZ4GEjbzHp0LCzKCqshn9ctf2Dn-xgEqWJjKR4M-qcJlGKw>
    <xmx:pTuTaSk30NVwN2D8fPSMsDU74Buf2DDpFgtKwP5EK8n_mhC5E9Fq4A>
    <xmx:pTuTafmaTrZODoYe5KF8w9RVTJWLs_dmhfkOxz02Sp2egRBkDarhgQ>
    <xmx:pzuTaTlhh_ePKldq6rQo1A5lMYc_mOlA_DBFEWV_-jnEBGri5pawnUv9>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Feb 2026 10:45:41 -0500 (EST)
Date: Mon, 16 Feb 2026 10:45:40 -0500
From: Andres Freund <andres@anarazel.de>
To: Pankaj Raghav <pankaj.raghav@linux.dev>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-xfs@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, 
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, 
	ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, 
	dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, 
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <zzvybbfy6bcxnkt4cfzruhdyy6jsvnuvtjkebdeqwkm6nfpgij@dlps7ucza22s>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 34593A0013
X-Stat-Signature: sqkio197qe1ttdadmjsw3qmjr8hkb9qt
X-Rspam-User: 
X-HE-Tag: 1771256745-915991
X-HE-Meta: U2FsdGVkX1+Jah5LyNfi+Ywj4vJSfla9E4YdPxiKsTiTk2HZQAodCnTsVQ83D+AuZP1VSoumCJLeyM+/hAAtMJfRtVUJ3YNMYZOBH7qY4xdfOoNqyDqcKol5OMC2h8s16JP4ZCBs6VpGbrMedqphMMPmZfAznig6+EIW0VGdu2yeZEMVDF5hz1ZobkbHhGP3fR8WHISMU2RZsywTYWDC5o0h+NOMm5HQYzw9fwm8exkei78u16/8GFdwjLprvlQ+3U7a7glS8AWcLrKYJAIEhplOvhsaF83XnRy/32OYxxQM9TElfEoRkmxwNEPL5dnZyDGScGMX/Gzc6CSAhiyUmK9hP8fgUpJO/sQAKBLkAumvF6Gn1bCliY4eN5ZtnUHQKuT5OGQrCbtAOo8SJasfwZhkXO3p0h8lgCH47vxdjxfVRIcdVC8A120P+cqtiK/8488qYtJRxUgWAAkUlcAyy0JwYUNi+Udm0CF7rLzM+fE3un2Un2Mg9O7XJCagGHAg6oHvvawDoiu/rtIfZZxPLCC90acXmhUNkyR/2oy7BwInL8WZS9eqhNBimBRVifKZT/xLaNCIbbpInWw4ue2L1XhQU48yGELRp9/zQly+Iv+UO2JS2i1CTm5atyISnCUGFw1omw4xce00UNtDh6vac5EeupcJldQyFQjcH1fqsRziJTikcH9sbrQqcTLs27+LXJ2ZRzv5JXhtTo/y1QcdIUtpX8MYVk1IgjdVvSFMYFN841fbooMgf/lCZuzAa9aNxHoumfQ6LaX/3ZOGItwEeQAlWUcO6lgITXoWIJN8ZHlEWOxjN4LkLOyBvM8/H3UmNBBUTBhvtEyLQjmRfOK8cr3kR8LTDcldGl1pEQX10q2E6RSoW4hvxcekbHZQY4Vkgn20t2QtNXJ4gu1tN6PNMWicIH2vAcng0CxeUp86++D0bjlnCu8TEUDmaWhPNQ3sQ0O38MLGo/K5wb+VSG1
 kPzNQ4ab
 6zuA++YkWgd0u2MPurkAkjW9icZrY9/iLDmOBYNNFuM+SQrEkZPjD6qObr+++Eg5OtttC+gjfVvKWNnfx5sVYP3LCRU3YLS3DaxuxTcqy9nzn2zZ1rqaUnNXCfu/0NQ/wgWKoDysE5dSzLApENSTqbdCFd78TgpYCFpEVer/1Cygd0dxE9DW3ETCBLNYU9tFno9b/Zo8L+RstH6HSE3lu9Lm7eJZe/J4s9gIF2T2BRCRwRDW1SJ57wqhmMKkgSdhC8X6Ftz3fsj68Fyyqkfr56Q/xs77CpayF6D7yD+5tUVukJbqqtp0/O5XGS/LN09bTBaPF2ic7VwwcbtPz/SdutveJwiZb6d6VcROg4Nvi55IyiWrw94BKW+Ie6MPN+/aTl5QoalnvJl9KpG5KUkx0orXOpsY/vq7WWDIq+iiLsJNUnTu9LKHFb6G7SOLUZrSieiGLdoaOh3E//iNvPAHJYoLnwrSM3wq2w94X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2026-02-16 10:52:35 +0100, Pankaj Raghav wrote:
> On 2/13/26 14:32, Ojaswin Mujoo wrote:
> > On Fri, Feb 13, 2026 at 11:20:36AM +0100, Pankaj Raghav wrote:
> >> We currently have RFCs posted by John Garry and Ojaswin Mujoo, and there
> >> was a previous LSFMM proposal about untorn buffered writes from Ted Tso.
> >> Based on the conversation/blockers we had before, the discussion at LSFMM
> >> should focus on the following blocking issues:
> >>
> >> - Handling Short Writes under Memory Pressure[6]: A buffered atomic
> >>   write might span page boundaries. If memory pressure causes a page
> >>   fault or reclaim mid-copy, the write could be torn inside the page
> >>   cache before it even reaches the filesystem.
> >>     - The current RFC uses a "pinning" approach: pinning user pages and
> >>       creating a BVEC to ensure the full copy can proceed atomically.
> >>       This adds complexity to the write path.
> >>     - Discussion: Is this acceptable? Should we consider alternatives,
> >>       such as requiring userspace to mlock the I/O buffers before
> >>       issuing the write to guarantee atomic copy in the page cache?
> >
> > Right, I chose this approach because we only get to know about the short
> > copy after it has actually happened in copy_folio_from_iter_atomic()
> > and it seemed simpler to just not let the short copy happen. This is
> > inspired from how dio pins the pages for DMA, just that we do it
> > for a shorter time.
> >
> > It does add slight complexity to the path but I'm not sure if it's complex
> > enough to justify adding a hard requirement of having pages mlock'd.
> >
>
> As databases like postgres have a buffer cache that they manage in userspace,
> which is eventually used to do IO, I am wondering if they already do a mlock
> or some other way to guarantee the buffer cache does not get reclaimed. That is
> why I was thinking if we could make it a requirement. Of course, that also requires
> checking if the range is mlocked in the iomap_write_iter path.

We don't generally mlock our buffer pool - but we strongly recommend to use
explicit huge pages (due to TLB pressure, faster fork() and less memory wasted
on page tables), which afaict has basically the same effect. However, that
doesn't make the page cache pages locked...


> >> - Page Cache Model vs. Filesystem CoW: The current RFC introduces a
> >>   PG_atomic page flag to track dirty pages requiring atomic writeback.
> >>   This faced pushback due to page flags being a scarce resource[7].
> >>   Furthermore, it was argued that atomic model does not fit the buffered
> >>   I/O model because data sitting in the page cache is vulnerable to
> >>   modification before writeback occurs, and writeback does not preserve
> >>   application ordering[8].
> >>     -  Dave Chinner has proposed leveraging the filesystem's CoW path
> >>        where we always allocate new blocks for the atomic write (forced
> >>        CoW). If the hardware supports it (e.g., NVMe atomic limits), the
> >>        filesystem can optimize the writeback to use REQ_ATOMIC in place,
> >>        avoiding the CoW overhead while maintaining the architectural
> >>        separation.
> >
> > Right, this is what I'm doing in the new RFC where we maintain the
> > mappings for atomic write in COW fork. This way we are able to utilize a
> > lot of existing infrastructure, however it does add some complexity to
> > ->iomap_begin() and ->writeback_range() callbacks of the FS. I believe
> > it is a tradeoff since the general consesus was mostly to avoid adding
> > too much complexity to iomap layer.
> >
> > Another thing that came up is to consider using write through semantics
> > for buffered atomic writes, where we are able to transition page to
> > writeback state immediately after the write and avoid any other users to
> > modify the data till writeback completes. This might affect performance
> > since we won't be able to batch similar atomic IOs but maybe
> > applications like postgres would not mind this too much. If we go with
> > this approach, we will be able to avoid worrying too much about other
> > users changing atomic data underneath us.
> >
>
> Hmm, IIUC, postgres will write their dirty buffer cache by combining
> multiple DB pages based on `io_combine_limit` (typically 128kb).

We will try to do that, but it's obviously far from always possible, in some
workloads [parts of ]the data in the buffer pool rarely will be dirtied in
consecutive blocks.

FWIW, postgres already tries to force some just-written pages into
writeback. For sources of writes that can be plentiful and are done in the
background, we default to issuing sync_file_range(SYNC_FILE_RANGE_WRITE),
after 256kB-512kB of writes, as otherwise foreground latency can be
significantly impacted by the kernel deciding to suddenly write back (due to
dirty_writeback_centisecs, dirty_background_bytes, ...) and because otherwise
the fsyncs at the end of a checkpoint can be unpredictably slow.  For
foreground writes we do not default to that, as there are users that won't
(because they don't know, because they overcommit hardware, ...) size
postgres' buffer pool to be big enough and thus will often re-dirty pages that
have already recently been written out to the operating systems.  But for many
workloads it's recommened that users turn on
sync_file_range(SYNC_FILE_RANGE_WRITE) for foreground writes as well (*).

So for many workloads it'd be fine to just always start writeback for atomic
writes immediately. It's possible, but I am not at all sure, that for most of
the other workloads, the gains from atomic writes will outstrip the cost of
more frequently writing data back.


(*) As it turns out, it often seems to improves write throughput as well, if
writeback is triggered by memory pressure instead of SYNC_FILE_RANGE_WRITE,
linux seems to often trigger a lot more small random IO.


> So immediately writing them might be ok as long as we don't remove those
> pages from the page cache like we do in RWF_UNCACHED.

Yes, it might.  I actually often have wished for something like a
RWF_WRITEBACK flag...


> > An argument against this however is that it is user's responsibility to
> > not do non atomic IO over an atomic range and this shall be considered a
> > userspace usage error. This is similar to how there are ways users can
> > tear a dio if they perform overlapping writes. [1].

Hm, the scope of the prohibition here is not clear to me. Would it just
be forbidden to do:

P1: start pwritev(fd, [blocks 1-10], RWF_ATOMIC)
P2: pwrite(fd, [any block in 1-10]), non-atomically
P1: complete pwritev(fd, ...)

or is it also forbidden to do:

P1: pwritev(fd, [blocks 1-10], RWF_ATOMIC) start & completes
Kernel: starts writeback but doesn't complete it
P1: pwrite(fd, [any block in 1-10]), non-atomically
Kernel: completes writeback

The former is not at all an issue for postgres' use case, the pages in our
buffer pool that are undergoing IO are locked, preventing additional IO (be it
reads or writes) to those blocks.

The latter would be a problem, since userspace wouldn't even know that here is
still "atomic writeback" going on, afaict the only way we could avoid it would
be to issue an f[data]sync(), which likely would be prohibitively expensive.



> > That being said, I think these points are worth discussing and it would
> > be helpful to have people from postgres around while discussing these
> > semantics with the FS community members.
> >
> > As for ordering of writes, I'm not sure if that is something that
> > we should guarantee via the RWF_ATOMIC api. Ensuring ordering has mostly
> > been the task of userspace via fsync() and friends.
> >
>
> Agreed.

From postgres' side that's fine. In the cases we care about ordering we use
fsync() already.


> > [1] https://lore.kernel.org/fstests/0af205d9-6093-4931-abe9-f236acae8d44@oracle.com/
> >
> >>     - Discussion: While the CoW approach fits XFS and other CoW
> >>       filesystems well, it presents challenges for filesystems like ext4
> >>       which lack CoW capabilities for data. Should this be a filesystem
> >>       specific feature?
> >
> > I believe your question is if we should have a hard dependency on COW
> > mappings for atomic writes. Currently, COW in atomic write context in
> > XFS, is used for these 2 things:
> >
> > 1. COW fork holds atomic write ranges.
> >
> > This is not strictly a COW feature, just that we are repurposing the COW
> > fork to hold our atomic ranges. Basically a way for writeback path to
> > know that atomic write was done here.

Does that mean buffered atomic writes would cause fragmentation?  Some common
database workloads, e.g. anything running on cheaper cloud storage, are pretty
sensitive to that due to the increase in use of the metered IOPS.

Greetings,

Andres Freund

