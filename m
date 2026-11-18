Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65D72606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 13:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cAFLfsLi
Received: by kanga.kvack.org (Postfix)
	id 8B7E16B00EF; Wed, 18 Nov 2026 08:52:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88EF56B05B0; Wed, 18 Nov 2026 08:52:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CCC76B05B1; Wed, 18 Nov 2026 08:52:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5EBF56B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:52:20 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E86E0C0127
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:52:19 +0000 (UTC)
X-FDA: 85448379198.18.C1DD51E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3FAF2140004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:52:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cAFLfsLi;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795009938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fadJbRdwnT01mpVtOTOr/DR2sXf6oKH2cpwR7oHbpKE=;
	b=pko52HkwxIUFtjUgNNkT1uxc9Flo6qQOXXTUEDq6glx/k5JhSr/rFQ5ck9wL1FXtJjM3nB
	hRMDUkxa0AjjOtG3JJSVgCDYMCPeTzIk9S7W9ybBYSzzKhSbF8yxid+Mo9xDa9rr1xH+uR
	YvZspT1WZCe1qKCY/Lg5cLfv+YnYAVM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795009938;
	b=0MZf1EPdJdMqMb8dLxYOFIcpUFfRsQWRXSSOtbMdKHF1skLBTVa0aMdGFCTq7ZPX9wqu7Z
	FnNb9NmnIX+nqdMRgehFF4Wwf4mSI8OA6DQttoVCc0ypcQh54bXavt51kykZ/u5mOZowcT
	vM/o5ejwcxUs5cvIBK5PqZLYedIgK1w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cAFLfsLi;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BB2945E61;
	Wed, 18 Nov 2026 13:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C6C1F000CE;
	Wed, 18 Nov 2026 13:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795009937;
	bh=fadJbRdwnT01mpVtOTOr/DR2sXf6oKH2cpwR7oHbpKE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=cAFLfsLi2bo7R6VadIkjGduO1sPGao/qItOHf7NFXu0NFytl0TQeGSYusNFviTAyS
	 gx8be/Rcg0I8YmeC+3B+r4fUpjZFzuMhOhZaLNK8dVXIR8NZwiUwHKBFZ88hhH0o38
	 tRmponS529HAy+EZg6vsZ0Kv5f36iXtQK+o+rBBfJZOSurojFdoZ4a22lmMWCmWqfh
	 dMYf5q8VhiCfdoEbKETWqPcE4hWtkp4gdLH+qtDeLI58F6cZe0ebFV4TklkvnX0vwh
	 rIHO72nUB6an6sF8zhQzLgalweDfcKjstsNjpGC4I6xRjOtHBbWZlzhxCTQAhCMKs7
	 mtCl6/3J3C68g==
From: Christian Brauner <brauner@kernel.org>
To: willy@infradead.org, jack@suse.cz, corbet@lwn.net, 
 mohamedalibouhaouala@gmail.com
Cc: skhan@linuxfoundation.org, rdunlap@infradead.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 linux-doc@vger.kernel.org
In-Reply-To: <20261115001334.23026-1-mohamedalibouhaouala@gmail.com>
References: <20261115001334.23026-1-mohamedalibouhaouala@gmail.com>
Subject: Re: [PATCH v3 0/1] docs: filesystems: update VFS locking
 documentation
Message-Id: <20261118-anzweifeln-umtriebe-mittragen-88527e288aaf@brauner>
Date: Wed, 18 Nov 2026 14:52:13 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-04696
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3FAF2140004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fda6pa9hwdf19qr7ocfdhrghz7nzm7bw
X-HE-Tag: 1795009938-137319
X-HE-Meta: U2FsdGVkX1/bdJlCdyge792aJ244Tqzs+pfPRsj2o65F70IZ7B6oCdFlG0Zj7L5grI2STz1fktCraTaEQH0cls6c1dRfuQesvzFcYkSMuS68vug1qiG0leQp3+wTqP2b686r9xe44PNWc2QD+RynP19qiHzJbJ7xVPPCuiqd0/MQNPxLZLeh2Y/Tik36qBXjNiw8DtfYnZGry9RAmiKi7ASOoIbk2MCqvMCLHXHYg+iiTh4o+Ao6bxzSyxO+5huaFwxMAiMZ4EaYgEcIHsezP6FRZ2W4GpMy2RguB1nyKye2QcGP8o6AMAjbvEQgyHOUbsiRas515oC4b8Lq4uDUjGkCUAWwZFdC3HCQvLkQDebj/edbRGgY/BqftD+QXJExGvMGcYjcVnoivCN8Xk/qJnJGxMcYm/VTqNCCG/4tqbKOMRBdE6iu15S+GntkklaCOJM+0VMOdqd6oyDhpgwMNgXsLnoBEBKx+Ti4w7Ubrv0eIbaWRZVxnFDrR6cO1eHs4/8Tfgs0S3QumZVNAaJ4ukumF2ZtnCh5jzOlMMEKG1ZJusUEGKoMwX/oL/RTwoWn4O/LjXWX2bApWKXSJWJPlV0ANGv3lUJroPhcbt+tczRPC8bUddpsh2zUhnF4aeNQrtdBEvGj7AuvxdPfgmNCWRLisEuhE9v/CNjILQiPOJow2yN2h1yeTljy0aP1fl3D7oe4HeAFMrO/1OCWzK6SmqTsLNOjurUs3tW/eQ/hb4Qlj9C9luPzXRbxWH9SrWeVnyOjji55maJcFd0SvDfrxPjrWD10aGMUa1ZFWJv2RNVx76ur3HX5lU4LuAyKB2dODTW3nAQNMEF1UcWwTiRcrGXpCmXF7e6BD83u+hvk4fOvyggVbprGy/fHgvfu6Fbp5BR1Zf1LQYzwUtcnEWM2UmGwUtXl4yNxIXVgAk5IH2QnTV3RaXlRG04k88QGzUK1w/Ga4Q2kwx4EgdYARJa
 vxPGFGDp
 bg14DBvfMfr8UFUm/OMmroHJdKwoOQgioLNpZfO0PBn4xBN9hu0SIt38DWmlLK6dHKft0MdxaDIZYuIOnZc+OoJRLH2eW6ptZGXyBco181UXzWQjDPipG/TjDX0FyHkYlDb++vNu95EaAytG6nzY9WVASw6uydqZpvst7tDOD7xwoGocLGlKEFEKiu4bE6MVuGL96y7SOWy1DX7A8l6g1p3xFQ24Th1NLlSYjMWHelfH6fnS8Yi89JKSlGZTKkJd2B/zPvTrroAnTGhuyGkJCWiZIsTHcxu9dTYMMutztwAlBItBtYusmIFhJJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 15 Nov 2026 01:13:33 +0100, mohamedalibouhaouala@gmail.com wrote:
> From: Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>
> 
> Apologies, I accidentally sent v2 instead of v3 in my previous email.
> 
> Please disregard the previous submission. This email contains the corrected v3, rebased onto the latest upstream master and including Jan's Reviewed-by tag.
> 
> Thanks,
> Mohamed Ali
> 
> [...]

Applied to the vfs-7.5.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.5.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.5.misc

[1/1] docs: filesystems: update VFS locking documentation
      https://git.kernel.org/vfs/vfs/c/fa7f1d6a9213


