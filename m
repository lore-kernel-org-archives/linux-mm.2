Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0299606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 17:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 158726B0177; Tue, 20 Oct 2026 13:03:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 109326B017C; Tue, 20 Oct 2026 13:03:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A1F6B017F; Tue, 20 Oct 2026 13:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D461F6B0177
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:03:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4C2CE802D9
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:03:54 +0000 (UTC)
X-FDA: 85343626788.16.9D4892A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A6A6940014
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:03:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792515832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OnO3sUL+tL/P4D7M/RB/v1+t3Pv2abKUS1M6dTbvBMY=;
	b=1d52ZpevFIgcnJSY2MtjQWj6a5tj9vn1+DGP7uP5OD0GDcYnCcAW6uF4ReA9WYAZWCGjQa
	cE7gcViIc+kOMvkP+VWIU6zGe+jbrci9tAihb+If5V5FNlVhAPsAK4UA+oFcheBIECdXCG
	K3ppDp0PE7SLXsvykN9yG6SDp2GvBek=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792515832;
	b=whob0qMZW3SfRSDh5UzVepf4kVkKj1VgLV5UUPwi8n2/83u52e96HpPDFkRkLIj/HJAVPd
	d+kbD5AEUXmc3KWbc/LA/lrF4EYQd2lbcHPIFkdzE6ZATETVGTuXSc6q83I5CtIcBE9gRB
	kVJKJh33K7Fy3uP+nJbT5u8KCjy7xCo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D6A060098;
	Tue, 20 Oct 2026 17:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9151F000C9;
	Tue, 20 Oct 2026 17:03:50 +0000 (UTC)
From: Chuck Lever <cel@kernel.org>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH draft-v6 1/6] NFSD: add tracing for how direct-mode READ and WRITE are serviced
Date: Tue, 20 Oct 2026 13:03:17 -0400
Message-ID: <179251578815.1375755.11152570607599449216.b4-ty@b4>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <atbfEbgMU6UGkn2X@kernel.org>
References: <atbfEbgMU6UGkn2X@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A6A6940014
X-Stat-Signature: ps4e7iwhzbzf5h5s764si5mujiatyrcj
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792515832-932618
X-HE-Meta: U2FsdGVkX18mFTjeiKrn3GXUjfXOR5wo0r1mSWO0oxRzl1RT0qvDkwjsTYUMVdTH3LXPcrNHXurlLt6seBVVvezriq7vDgdZpikAO2eKrJrfrpr3Y8hBiZ9WrBSgoJJM1js744IvaSy4636ES+IUoOouU+fzNExEGfYOxKrTdLSLJtEYWfMlv9LCRyfx/O8viI2Q1qpLCXa8Vs1Y7GXBzmgTJ/fh+vIg6LHDA2WJSdydGyKQyRv8KL9Ck9hGp2jvClXTag3t0nE/OP2JsZwNqZyY4kkne0l9YEx6HXcSaSAk/zc0rv0h8leL2XwkWxGLKcq/o3eLstAWydO1s6uJ5KXUlaDp5CpqhHN0h+I3raq1w7RE7xtATwmbH8/UFCK52B6i5qubMNygO/H+dz6a/lTBjr3MlFLJHCSjT3VqLhHLuv8bzW22LV1EPOX1aoeIjm0G9wtsEfH4OhY9tFNySR1+ClAGpcWSAI2477m6rnYfyMCT8jJMsedBrt+73dvKgCPn3zrC8g4EOfIPyqNgWMNXU66AyFgzZyGSax2Nfkl/GOCnxejbva3P5ur6RydxIvOXtyIUDrl7o4xAWYkKAlelpj2tY+/kE1jBGXBSUH4CYx7z+yZQxnQ2JkFla8u9qBY/M1Jx1T2wMC3/DV8HtQQVC8ui9Zj0XG5pKdm1hxJeiWmLzKvKkKbdo0NYonbgKoskCvXdkbC+/flpK9M0rqsYgazSPwxVBSyHwm/V1DDVTga7JrSGRowgN7U6ZkMmtJBLzZYcM52vHaG6eqHEA776U89ToszC2U5kwQZydqXLsXpHFDVUsl7EQQKY32aV5u+1SH2pp1zeYNaTdRdaqJC/KBninNWxFGm71RowlrcQts2X/nFBdVBHEb+1QwkUWR6ovU9UKCf5XAJLXraT7shpE5Hl+OjI+5KxQ0W4wNqSqqYhQ1hLcK2WTog6EtxKJC7OoxqI0J51IcfYrmq
 mQEtK2Sx
 NIN805fUsc9xqDJxATWzX8RXKU0p7JmirmT0ZMm7dWx8QJMjQFCO/qNcIm69FOuxuO2J0HN6LK8G3I5bOjgtBZpHQ1j0RSrweMIFSDUgHPqVooUwTVygKdFw8ztGKTlWY1E5raEFKxmwpryesdnpSGLayg+Io2Xwij6uPv6g+fns7NhrxqRyB43d8NoHblFMq0spv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 23:25:05 -0400, Mike Snitzer wrote:
> On Mon, Oct 19, 2026 at 02:33:47PM -0400, Chuck Lever wrote:
> > On Mon, Oct 19, 2026, at 11:07 AM, Mike Snitzer wrote:
> > > Add:
> > >
> > >  - nfsd_write_dio_split, emitted once per direct-mode WRITE before any
> > >    segment is issued.  It records the advertised offset and memory
> > >    alignments, the payload's offset within its first page, the start,
> > >    middle and end segment sizes, a disposition naming the path taken
> > >    (direct, no_alignment, too_small, no_middle, mem_misaligned), and
> > >    whether buffered segments are issued IOCB_DONTCACHE.
> >
> > Let's define a single event class and then use DEFINE_EVENT per outcome,
> > rather than one event with a disposition field. You'll notice this
> > pattern is used elsewhere in trace.h.
> >
> > So nfsd_write_dio_class with the alignment and segment-size fields, and
> > nfsd_write_dio_direct, _no_alignment, _too_small, _no_middle,
> > _mem_misaligned fired at the site that makes each decision. An admin
> > chasing "why isn't this direct" then enables only the decline events.
> >
> > Also, let's give the READ side the same treatment so admins can see
> > the decisions that prevent reads from going direct.
> 
> [...]

Applied to nfsd-testing, thanks!

[1/6] NFSD: add tracing for how direct-mode READ and WRITE are serviced
      commit: ad42983b887e9abf7109535a654dbac6cfc3b72b

--
Chuck Lever


