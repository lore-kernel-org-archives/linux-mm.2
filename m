Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFD30606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MdpJFCRO
Received: by kanga.kvack.org (Postfix)
	id 02F2D6B05C9; Tue, 10 Nov 2026 12:23:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1FC06B05CA; Tue, 10 Nov 2026 12:23:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36186B05CB; Tue, 10 Nov 2026 12:23:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEF0C6B05C9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:23:04 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 53A461C445A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:23:04 +0000 (UTC)
X-FDA: 85419879888.13.65F75CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id B44FD1C0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:23:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MdpJFCRO;
	spf=pass (imf18.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794331382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qU/YBwcBTSW09tcoeJ7GijBACLV9An/e2EuN4/Zc9Sg=;
	b=NxJ36gV5M3PiBHVnTW15IEXOQXWK23pLLGij4HWL1PWROesqhP9Vyim8/JSn0H1plK56EL
	uooLVTsD6zKJ5Up+Ij7rAxdjK8xneOTn+/9zhhICYxciZXRxFXBNPpBxen79AYOmUKAg4+
	anhn08feUrGJ7mOh+hHuGWWPFQqMWrk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794331382;
	b=QYVrs9WmoUGa3cZKC9fJJO0OZ5dBrv7G8yP8wbCYCzUaTHXlXLOqV/udy4YgjAI8NF+cws
	w7nhxLTftI1guKimd2hYWGQ1g9gfso85XMHEV5rPfm14wJIcWJ/G1DTohcRUuCQXngMY/L
	k3kvx60f9FZHPeX9VKc+kAYl1480xm4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MdpJFCRO;
	spf=pass (imf18.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 39DBD63227;
	Tue, 10 Nov 2026 17:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC5E1F0089F;
	Tue, 10 Nov 2026 17:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794331381;
	bh=qU/YBwcBTSW09tcoeJ7GijBACLV9An/e2EuN4/Zc9Sg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MdpJFCROGyBYcN7mWJ2h78QRBDr/Fl/ZsKQlWVpd8pwT/yq01ngNExJ8X15QOrwsR
	 sk7rL5FOYp6lPcx+x7fPzofmSxgGVAAFFGCEFCaP56Ah/LP7eSEf3RX1TCMtNt798T
	 mExzsrT7iYw6hTvC27mzgrufj/d1QZhxdsOsBdcR2H15L2qEIivVxUj8ZXVLcRxPdP
	 lJ4Aw4IpoOBm6O9FTWQ/Bfr5ALMiZqvLhRXCXfc1ikWYB5vTiTmmTHV9fmRfW6j6ZH
	 QkD3b+xn5qIF5y56iQP2D++WMSIAkzp6r/hjK81fRf5EEf+2rFl6PzUScHmIke0Jl/
	 4oDe2DIyKoqLA==
Date: Tue, 10 Nov 2026 12:23:00 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org, Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: MM/iomap review of this v10 patchset is needed please [was: Re:
 [PATCH v10 7/7] NFSD: drop a shared boundary page only once both WRITEs have
 written it]
Message-ID: <avNS9HrDV8TbDTqH@kernel.org>
References: <20261103211754.35352-1-snitzer@kernel.org>
 <20261103211754.35352-8-snitzer@kernel.org>
 <20261104091543.GA31130@lst.de>
 <autk-osSQ8l2LKz1@kernel.org>
 <20261105075935.GA18069@lst.de>
 <29851456-2e7c-48a7-bf00-11a1f1a35024@app.fastmail.com>
 <au0H_TZCp1Snf_5U@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au0H_TZCp1Snf_5U@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: os5ci1kwwje7cbznr15b87ktzz1p3a7d
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B44FD1C0005
X-Rspam-User: 
X-HE-Tag: 1794331382-871753
X-HE-Meta: U2FsdGVkX19rRDOniA0Wnq/35WVysuVQ2xlVBV/YAkdhFJ1uh40tZH3hTUt+OQZnZm7IV9K/fA7beiBPknFtcaCqJhCSRkVReI6Z4m2p/fjxWrVXu5+mhm3M4SWWBdKzzPx0tmnXlyp9C7bC4K2r1CixLVJyWCLhP1jXZ7T1pMnBGecY4MjOiVuYryrmdZ3GM7B1ch1c72gZb0yc0amPFiYHOCNSFFDDOyD3Qpyk+ohx/xU7hDsnfwzIEmmIyHZE5r61du4pgW30u1b7U6PoFN+eXpRN0LmdaPQjev2venF8olfzWB44RXo7OdYcqiKNpduMvxBdp+cDS8DoHxjTd4npag/IuqcZQXCdycucczhN8ZWhmUu9uL9GGScetH43prFbIp/HXQlJKYCBJhHeTQh1q+klJbe/xwtPszi1SppIJDaHNpAUPWiQG8rWs5fvpIkFWgKe37RnV7i/a4juuFxhmS41wbjbSyvArxYKcZs1uERbVGLISX3NFiAlOBMnf7qJssfpwXTXPztCQ6A4wZMzNnOehP3QhsW9xLhVYAWrqkOQ6nNM5pA4n3QGdEG1nlJbtUBoPxmXNLbax9F+0qwssPX8DHe9xUtAlSYmWwEhJcmjnnyRsE/LrLUP2gVXFLmlwJQHgJm2dPx3Jin/I+XdupjQ4YET2Rh0x5e8dlWfNit+xyOvKEg8a16l9GKwXK88OcXZy7Ol4HZ444VDYABe92SrQRyfNUC3LhWxu5TH325GAgzGwlUs5TzIDvr6kDX0yWC/BLFji89IXC6pkGLHx+x+az2/HL/OOD9OjUz1hZRaD2MSLa2yb+J0uGs/M3V0MN+XQRyPVvzvsX+cdaLvyvcURnHtDSsgN2pUGqpVFoIhRowZA9hmKqlGIuFUJPf0gfmUT70UEHRkEHrTcnx+2HZ8cKvd0cRmLfQVdzQu0fBsHKozxkx4rB2Ro9mit4M2nnfzqKc1erPUTX5
 fxSS6f8e
 NYKaw/wMY4ABQ7LhCDiXPA4U7LJsz4/jMi08/scNXA4KKFGyfQ6B3XdCns4XLw5VJ3CO0pgMqBaD8MwmdmV4+X1Mn7adtV/Ag5j4pBg4d7w1zNmM9f0m2QzUSR40SupHA3YZnw6hnkbXAFtQRX6ilSQSY+USi8wpM0OSet9DFcccv6ALJ/Vig4ycahpZPumvnWlt16WkwCL/d9BhZteihvjK+hpnZLPAP/3GqH/7foghIxR16Yohva3ECE9/7Lpd/rlofnj+yjXSMXe8qCUcpmGiPjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[Cc: trimmed given To: refocused to required audience]

On Thu, Nov 05, 2026 at 05:49:33PM -0500, Mike Snitzer wrote:
> 
> I suspect MM engineers have just been busy with the merge window.
> Hopefully Willy and/or Jens will give v10 the courtesy of fair review?

I checked with Jens to see if he'd have time to review v10 but he is
unable due to his attention being needed elsewhere.

So Willy, Jan, Christian: can you please coordinate on reviewing this
v10 submission with consideration for 7.5?

Probably worth me restating this note from the cover-letter:
https://lore.kernel.org/linux-nfs/20261103211754.35352-1-snitzer@kernel.org/

"Merging: Chuck suggested taking the series through the mm tree.  1/7 to
6/7 apply cleanly to each of these mm branches:

  mm-unstable  0ea6dc8c4a21 ("fs/proc/task_mmu: fix lost maps entries above 2^63")
  mm-new       74d73ffcffe0 ("riscv: mm: fix concurrency in mark_new_valid_map()")
  mm-stable    6628e7d4c6b2 ("Linux 7.4-rc1")

7/7 needs the NFSD direct-mode changes that are in cel/nfsd-testing.
The whole series applies to cel/nfsd-testing at 693afd3ce9ae ("NFSD:
Defer the PUTFH export security flavor check"), where each patch builds
with W=1 with no warnings.  So 7/7 could follow in the nfsd tree once
the mm part is merged."

(and I have just revalidated that patches 1-6 still apply cleanly to
the latest mm trees listed above, with commits 93d7a816a2df,
488f62a72b8e and fa4ad798f6f6 respectively)

Thanks,
Mike

