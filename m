Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30440E909D4
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 16:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A7DA6B0005; Tue, 17 Feb 2026 11:21:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655296B0089; Tue, 17 Feb 2026 11:21:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536796B008A; Tue, 17 Feb 2026 11:21:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EFD36B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 11:21:25 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4BC7B6E9F
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:21:24 +0000 (UTC)
X-FDA: 84454463688.25.BDF720A
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf22.hostedemail.com (Postfix) with ESMTP id 02397C0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:21:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm3 header.b=uQNjVCQC;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="VCu+80/E";
	spf=pass (imf22.hostedemail.com: domain of andres@anarazel.de designates 202.12.124.155 as permitted sender) smtp.mailfrom=andres@anarazel.de;
	dmarc=pass (policy=none) header.from=anarazel.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771345283; a=rsa-sha256;
	cv=none;
	b=RT6ctWPYXkf4Lg9WS9VfAhbJBPsYAZeL8YHbOYjHnmgUPqFOlEnyv1JEV2GRQbUZCqHKPy
	6dlNLYSFTmKzKb8XP6FlmHOii0OCPc5cN3KNwOhel7ukZUatAU4rVYAgujNOCTs05q9sR/
	xAZCQUjYWe45U0Yuf7QxMiZ64oMB8kA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm3 header.b=uQNjVCQC;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="VCu+80/E";
	spf=pass (imf22.hostedemail.com: domain of andres@anarazel.de designates 202.12.124.155 as permitted sender) smtp.mailfrom=andres@anarazel.de;
	dmarc=pass (policy=none) header.from=anarazel.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771345283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLUeZ5F3tOY10JNA2p1BHXejENCtAykcv1Gn+DC81rE=;
	b=oP54+YFDJfSNt4XmtiJ5OnJlYE+2rWbLLsiI6iQFvR7ObbffTY5l5w0sZ5KyMbdJewXkXt
	nwhhzslwVEwP8z3gpM6OnzDZo9p0jY6FDgQZ7belQCEGndaih3MfV8neEks51lTvKSvfuS
	0cygxn+Hvqavgl9kJsEpmNRnM23Wo44=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id A1AED7A02EA;
	Tue, 17 Feb 2026 11:21:21 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 17 Feb 2026 11:21:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1771345281; x=1771431681; bh=TLUeZ5F3tO
	Y10JNA2p1BHXejENCtAykcv1Gn+DC81rE=; b=uQNjVCQC9X9F5StIFcthQyB+/2
	0eLnxGZfhCH22vl+jMjYUp+yjLLa3COMMLt2aQCP8csfgCPyg2kSOt0wSX/7Uadh
	61+WPDqgA+18YDsiDzkzgzaQsk7WlH8BKPWHTHDPtxd+YEUn7hwBm6O+stecCQon
	HALw0hlm9qmTQ4BhZvk9z2QXc2Kz1FqNNt1MI1CYjuXpymM8LrlysNqFbQNyQOYs
	jFJ/5v9PasfB4Z1FnU/T6dnzrm0VwsfVrO8wuI1Xx2Rdzk3b3Bj9iZhzBPNNP02O
	noXNSIZ43/umgD8Nzp+4rwYKgWCKd4XiONkCdeNmO6k2RGxK7IRMy7KKY7QA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1771345281; x=1771431681; bh=TLUeZ5F3tOY10JNA2p1BHXejENCtAykcv1G
	n+DC81rE=; b=VCu+80/EZiJyJBT9tjjOEtM6yFvMLCGv9EW1vd+W5dEciLbG6rP
	FfYTqCh8ditwkjQYLl1vUlRnvBXtAizzDw5eMX+l6gLtEDgL9Xj5/hL/NS5UM1r4
	rGa5gSTwuBA0DRycbwbwtEstGp88Po/0Jci3/vVwXaONvQAcPOtPD1QnPp3dfq18
	mojecoiiSWARNGKhdu5xsSykKn5ms/n78+7RylDa+NMMZe1hIZo8pz12YRTaM4nJ
	+KuTm2GstXT/M6pUMHOTrVS2V1KteDxT+RgBU3wnSGF/QBIEHnwSFgTmqkXI+nPT
	mhkpjDUcQp8IMGDJ+IZf7CRPFOXB1eednXw==
X-ME-Sender: <xms:gJWUaU8Ze8qUPt8xOQsz0Q9zLsszNKxxsnotLXScA29zgvvlBWSq-w>
    <xme:gJWUaToe3rphCXJLI3ZSfnYOHuxhHkjN1IAVByYkHeAxusxFhUEpQVYSQH-4N_TDv
    E9hKLXYMHJwI6xr47S3Jx9TORONtZsyEQg7h8Hp-lUbiPbdPmxA5A>
X-ME-Received: <xmr:gJWUafFMIvuHzz0E_aBccRd0yN-PPtysbCneUsPSY41WBNHFfizOIdKChobyeB2Y-RQJjQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvddtvdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrfgrth
    htvghrnhepfeffgfelvdffgedtveelgfdtgefghfdvkefggeetieevjeekteduleevjefh
    ueegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hnughrvghssegrnhgrrhgriigvlhdruggvpdhnsggprhgtphhtthhopeduledpmhhouggv
    pehsmhhtphhouhhtpdhrtghpthhtoheprhhithgvshhhrdhlihhsthesghhmrghilhdrtg
    homhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthht
    ohepughjfihonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmtghgrhhofheskh
    gvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhg
    pdhrtghpthhtohepphgrnhhkrghjrdhrrghghhgrvheslhhinhhugidruggvvhdprhgtph
    htthhopehojhgrshifihhnsehlihhnuhigrdhisghmrdgtohhmpdhrtghpthhtoheplhhs
    fhdqphgtsehlihhsthhsrdhlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtph
    htthhopehhtghhsehlshhtrdguvg
X-ME-Proxy: <xmx:gJWUabmAnc-nIab0cp41AGUcRtQbP9_DCdFRKe_ySSkDIlyHWIr-DA>
    <xmx:gJWUaT_5oBp-1kCztHEfPRFd63ae6VEh3RqwH_ZjhRni7fmstEVSaw>
    <xmx:gJWUaUmRXtuzaj5Xo1WrTZjrcFY063eBpLHPxbZI_8ppooOk5dMnaQ>
    <xmx:gJWUaZm6Y84tWpETdgRGoX3r_vktvIvun1TJF7p66ovN3nU1NOqZpQ>
    <xmx:gZWUaVl15IfgmJQLO3oi-CdzG1EnzgkN23ZUr7-KzMej6UbqkYLnnVrH>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Feb 2026 11:21:20 -0500 (EST)
Date: Tue, 17 Feb 2026 11:21:20 -0500
From: Andres Freund <andres@anarazel.de>
To: Pankaj Raghav <pankaj.raghav@linux.dev>
Cc: Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	lsf-pc@lists.linux-foundation.org, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, 
	hch@lst.de, ritesh.list@gmail.com, Luis Chamberlain <mcgrof@kernel.org>, 
	dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, 
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <ignmsoluhway2yllepl2djcjjaukjijq3ejrlf4uuvh57ru7ur@njkzymuvzfqf>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
 <zzvybbfy6bcxnkt4cfzruhdyy6jsvnuvtjkebdeqwkm6nfpgij@dlps7ucza22s>
 <wkczfczlmstoywbmgfrxzm6ko4frjsu65kvpwquzu7obrjcd3f@6gs5nsfivc6v>
 <4627056f-2ab9-4ff1-bca0-5d80f8f0bbab@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4627056f-2ab9-4ff1-bca0-5d80f8f0bbab@linux.dev>
X-Rspamd-Queue-Id: 02397C0005
X-Stat-Signature: 8wcbuzz54c7984tje4uiz4qwpxrhfrq9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771345282-299264
X-HE-Meta: U2FsdGVkX1/eUPoeMySVthPwg7T+IGmeVINImMK+WNAKHsmbh3b/CCoFm++4AwCjFYOmfLa32D+hogSflJ+hAQ+8Yw9JaR6/dzGsGJVY+giAjTWsvWBs2enH8QyTktnrcs2wzHYZXjzVwSvTRmwjxPs1NR9XJqDMLhoJ8lJLuMkmYQl2dHmQ38/O/UYRISpisqx5sgyZuzfTzFZmi8nxPN748qo4Sp2AUiyIkLhFyUP6H+wNXpopKM6y51huVUi7i8t2XgBucPkrMve8lsQRyu0lmAOhQOynOoQBmyuzRivZhgkfM9VFh1fii2dkt2sZqoFddMxbE55qvC5NscqOpFPmFFSMpFyFL6UdcQHJZevTdDaMXJ7SZ6XzZVk5017gVKhz53C3ElMAVzXaeSir2jbhRsi05aNns/MHuh9FrKg/aCoAkhvboInT4bqPeswU++4qMkfcnT5szPSxco4oXkS93XA+h2xvcXwZF5pX2HWFyNuc0FVGOspAspSlsjw4GYivx8JX5OaQbbkYzxfoZr245WEv/aX12QAaNf7jFqd1kaUpxal9dX9Djp6LpFpe8PqKFvnyd5yiUG/Ur4VIr1G1KATxYNYAQn1T8lex/M+0XzgCQub7rgEh+g/1mw1LaHmxUEYUbScsI3Ol4eyhF8ilBexzWO+YYhBp3rtl07nwLeeNv9lsPbDyY6MHYQJsafQBNACIvL72AwdPnsXClnnhEEUTR//5bGTfyJK0qSPHs3mQop2iW3ZPRNKFDvpyc+jh10/qQSEdf49+k3/TSzxuBLy37oTw4WYZVqjVZk0rLE1YQG4LsgjR2JrKGlHT+5aHc0/qu/TAUBEC/+sbh+rzR7UfgHr/5VpBPNjQA9Ox+YZ/iiAA6HHbfUvvKl1IZ46pmB2XGmubiUCoT1it62SHj3W0Ya/pcP3wblHCobUKMN3cr26LIZ7quGUGE9XcRboNO6C3e4KDzmgZPSr
 zwgnwCig
 CaLBOMEpZWVNQGV23esB9TEEYNP9lBVDa/NZoN0qNFEjZ0nB0jcTDUtAk+UAVmRvPCoiyGNgkl9e0dfva6I5dgChrDv6iiQrRa6NVcsswO66mP/SooW01KVCvlCCP0fHrfG8Rnc3ANd1csEfyP1lEyYy8VNqVw1g7SRV40Lbui1W4I/jBli/+FCFJ4iJCbiDjpZ4y3P4VFnb+k7tK7LM36TZpW2uXxGrAm53rgSwXQRUqf6dAjIcV4Ylm3wT3R0tz6lj/Ylg9JAqk5nlRD7GLbrJhKAXrvgensRgg3tsKrjdrvOBIu61BMEDoFZLqQSAJ50cax+KCXJF6PyoZAlZ6w/LoDiYtOnRE9WnaYzK5HLPaEYqU/Eex1cDmTnMhM0PO1uLW8QvcpT1xD9duid6guQq+GseTb0UJIDsRAB0Wf1ir3K0PZ1HNQchzDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2026-02-17 13:42:35 +0100, Pankaj Raghav wrote:
> On 2/17/2026 1:06 PM, Jan Kara wrote:
> > On Mon 16-02-26 10:45:40, Andres Freund wrote:
> > > (*) As it turns out, it often seems to improves write throughput as well, if
> > > writeback is triggered by memory pressure instead of SYNC_FILE_RANGE_WRITE,
> > > linux seems to often trigger a lot more small random IO.
> > > 
> > > > So immediately writing them might be ok as long as we don't remove those
> > > > pages from the page cache like we do in RWF_UNCACHED.
> > > 
> > > Yes, it might.  I actually often have wished for something like a
> > > RWF_WRITEBACK flag...
> > 
> > I'd call it RWF_WRITETHROUGH but otherwise it makes sense.
> > 
> 
> One naive question: semantically what will be the difference between
> RWF_DSYNC and RWF_WRITETHROUGH? So RWF_DSYNC will be the sync version and
> RWF_WRITETHOUGH will be an async version where we kick off writeback
> immediately in the background and return?

Besides sync vs async:

If the device has a volatile write cache, RWF_DSYNC will trigger flushes for
the entire write cache or do FUA writes for just the RWF_DSYNC write. Which
wouldn't be needed for RWF_WRITETHROUGH, right?

I don't know if there will be devices that have a volatile write cache with
atomicity support for > 4kB, so maybe that's a distinction that's irrelevant
in practice for Postgres.  But for 4kB writes, the difference in throughput
and individual IO latency you get from many SSDs between using FUA writes /
cache flushes and not doing so are enormous.

Greetings,

Andres Freund

