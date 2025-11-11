Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB059CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:50:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F7A38E0016; Tue, 11 Nov 2025 04:50:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CF5C8E0002; Tue, 11 Nov 2025 04:50:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00CA68E0016; Tue, 11 Nov 2025 04:50:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E16B98E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:50:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9486813B0CD
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:50:05 +0000 (UTC)
X-FDA: 84097855170.25.A2E616B
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id C3D8212000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:50:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="WXA69s3/";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762854604; a=rsa-sha256;
	cv=none;
	b=kqRSnLBm208wAQl3x028BsehZz9iahgnLJTHMRQWIiTO+SjAd+GlS0ekNn5NXwFM7a0+dQ
	aYy8O+NFj84hmv/7S6efm9mcdUcUXVVXLRjfSEFXIc8Z0FtdNlSZQMyaFMAuqVapoh4OJ2
	yzBBNG+95UVJ9i21KkRV7AYOdZMVv24=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="WXA69s3/";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762854604;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6bsPdtBaqJ4UPF5R7K+ouK1dJ6DCyxBWv0w/QZnr7cE=;
	b=skS9njqw/CU9WKMn1g/GDXTvI1brZA6qIvplDRai6fO6BMMgUeYf4sJw8416FSbd/BuJOC
	nmDHnLky8ymmzeLzGs6o0b6isbkok3h/5tq0E0CctR1HbisMds1gH6BpJ0XFMnSlXFyNL0
	PW4NEHu5hkKgkd7aPuMj1tjhN35OeKY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6bsPdtBaqJ4UPF5R7K+ouK1dJ6DCyxBWv0w/QZnr7cE=; b=WXA69s3/ndSSCDKncRmaO/hjic
	O1y94fGm7YG4wpp1EnXG6yDbvuMjQmTNWvtrC7zZiZbJKSJQ3qPVVV+wFbvU9CFAsYmwuwFWd9TQz
	502RxsFSRuMlb+ZsoiAw/Eyy0gQ2krWPMw0fEZQ3Z1ZbYzdnWOQhbqHDcknhoQE/b6LUe5OiGj/uX
	ilItJNCZJAw3WeivKD5Fmg/6ibDscl4juFxBkBG0efupSFSIBUUIdS3DG4fn/rMt/0u9B5d/iqbE3
	VTHj0bLhd9xu7SVaxQVogoLmue/J7I9fcpgSO2MhCBANTrOxCwyy94lXIyVk5oV9wmikQTnsNUf6U
	oFmhH9OQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIl0f-0000000FPaa-0OxV;
	Tue, 11 Nov 2025 09:49:57 +0000
Date: Tue, 11 Nov 2025 09:49:57 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: bot+bpf-ci@kernel.org
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org,
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
	daniel@iogearbox.net, martin.lau@kernel.org, eddyz87@gmail.com,
	yonghong.song@linux.dev, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH v3 34/50] selinuxfs: new helper for attaching files to
 tree
Message-ID: <20251111094957.GT2441659@ZenIV>
References: <20251111065520.2847791-35-viro@zeniv.linux.org.uk>
 <70d825699c6e0a7e6cb978fdefba5935d5a515702e22e732d5c2ad919cfe010b@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70d825699c6e0a7e6cb978fdefba5935d5a515702e22e732d5c2ad919cfe010b@mail.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C3D8212000A
X-Stat-Signature: ht1mkgdyhnq1ttukfo3z6cc39imqx1pt
X-HE-Tag: 1762854603-151547
X-HE-Meta: U2FsdGVkX18bEIu3jz6K5mtMZ37kRxFQea1z1ABa8J5ndcMVD6q3o0QlVRhuyuc1JzsSlY7b0NPNoD9flofejKlfReOKMgzBSA6mSmLbk6GiXHYtYL8mP8fwvxVG7VYjRcwG7XCNkdVylwq1lzmcLWJ2Z/K5P8RubRVTvLKQtBFat1t7WHsNAeicrK9GlkwzeoUQWrkOBJKT7BgMtLoBh0tVggwQOPZo3oK9i0ViMziXomjpan4hqfwWcIl8RX1Ef/NqqTorbd2tFl80nJ4y10jqLF0jZHjvARfdHZV0tlGEVaQti5+lRXpprDs5Ury7nYK98zaZ8NDNWJ+cRkBbk7jR7KQG/3i0y58Ve2PzuAPD7g1FjK3Mx6VGPpsZWbVmsuA9A2DypmtPVzObJYFz7lNnDfIkGO4JS3jbVOnlClm9GWagVYlI+YwqjOUSTvm+gso9/dWA3BXUg+923Koy/4uGVywN4kazybknKLQSKbuvDFmvf4h/R+6jpN01qcbZHytjovqO1xRgKF3O4TCpAqi9O5tsoBjoSm1o+UyNGjUXE97O90XGpEq96/lEiqYzTJxJ7h0uekLll0rqXO38oPtO+GgUpCsPqyQ1ZWN0AjPyyvMVxjHNhVlkIdtRemouzG6flDxFgdLiaz0frXsP85UAnRnLtTpAElo2F+fxCJ0g3blltq33fCLthQMgAq46DVxgEXQlGRZR6EOzCNzh3zx4j1hekbpVwHeaxK9Yblk13zg3LdkQSPPPDjDgm2cgdjbw8rfcYnC0zVcUPsf4TH/5pzhAXU6mN2wsMISGSnNvxUGQMu7/Xwdc65QuYX5zlMN9hwdcNm6WEbkxwTvOrHO6/F/Ng26bKavRbjJiXaqWzMd1CoLCZg7RnudSh8flrjJ5sRv3SDBOU3bsBPKAr5waF3aZy9arBflksd3OobVF07fUub3q+PD46LxdeonExfmr1TFT6tv2FNRGkNv
 wdES6HWV
 LgJbOyJaATr5XWLL9j9Dt3JDZqfnXmyKEB2kQH0T9+gKHBe3zKPY3b/5Tk+gonpyr1z8g2eN5e/Vjvizwa+1g0KdChEIk7WAMmLfzs0yG66QL1TDeq+9UC8G0WQ7TTxOOUborGvHul2UhHZgmKOrWuW5UAWgwMVF13UsGJ94xn7/k6S4Tdd8nQwylzwB4tCJ4jb6+HQq7v9o5j1xrT8mJIoDzQv59TVWEZDmCOHqplpEEJv1jFEEYOxLfYuoA5IOuVx0Z6yIEpfQzjW8oxumywY5/egGNwjK3fLXjykSxmsPD8GthPOuVqw83NlQLC2JBe/8YnCf24Pn1vZIEYUCTnboZfT872Xe77X1VC1lopoRrvkXfWyvMghVHCBLJVGkP2CJbUPcoiZa0L20I3zXHT7l/lwDFJXvtdgpwJswaL6XwW6HiR+y+82x7NyGVVZKeMiEDJAVRDNdc+aiecAcPJEtaSg/p2+f4Uwmo2Cqu9vhfcQAV+zOT4kSnmvy5paDVGwOa/haqpfQ+mePDYffBpNSmjlyncYLxOgpY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 07:53:18AM +0000, bot+bpf-ci@kernel.org wrote:

> Can this leak the parent directory's reference count? The parent inode's
> link count is incremented with inc_nlink(d_inode(dir)) before calling
> sel_attach(). When sel_attach()->d_alloc_name() fails and returns NULL,
> sel_attach() correctly cleans up the child inode with iput() and returns
> ERR_PTR(-ENOMEM). However, the parent directory's link count has already
> been incremented and is never decremented on this error path.
> 
> In the original code, the parent link count increment happened after
> d_add() succeeded, ensuring it only occurred when the full operation
> completed successfully.

All callers of sel_make_dir() proceed to remove the parent in case of
failure.  All directories are created either at mount time or at
policy reload afterwards.  A failure in the former will have
sel_fill_super() return an error, with the entire filesystem instance
being torn apart by the cleanup path in its caller (get_tree_single()).
No directories survive that.  A failure in the latter (in something
called from sel_make_policy_nodes()) will be taken care of by the
call of simple_recursive_removal() in the end of sel_make_policy_nodes() -
there we
	1.  create a temporary directory ("/.swapover").  We do *NOT*
use sel_make_dir() for that - see sel_make_swapover_dir().  If that has
failed, we return an error.
	2.  create and populate two subtrees in it ("booleans" and "classes").
That's the step where we would create subdirectories and that's where
sel_make_dir() failures might occur.
	3.  if the subtree creation had been successful, swap "/.swapover/booleans"
with "/booleans" and "/.swapover/classes" with "/classes" respectively.
	4.  recursively remove "/.swapover", along with anything that might
be in it.  In case of success that would be the old "/classes" and "/booleans"
that got replaced, in case of failure - whatever we have partially created.

That's the same reason why we don't need to bother with failure cleanups in
the functions that populate directories - if they fail halfway through, the
entire (sub)tree is going to be wiped out in one pass.

