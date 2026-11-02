Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FC7F606F3D0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:41:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F0E76B05B7; Mon,  2 Nov 2026 09:41:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C8066B05B9; Mon,  2 Nov 2026 09:41:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205246B05BA; Mon,  2 Nov 2026 09:41:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F120F6B05B7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:41:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8ECAA120150
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:41:10 +0000 (UTC)
X-FDA: 85390441500.17.1D58868
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	by imf23.hostedemail.com (Postfix) with ESMTP id 757E2140009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:41:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of fw@strlen.de designates 91.216.245.30 as permitted sender) smtp.mailfrom=fw@strlen.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793630469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OMjVTvjZtZrTjrcI72ExCzD1i9afB7DwzHLxEXPZD7Y=;
	b=Olp4hyuqJXTNQBdMN6EP3KqqxeoiTm0fZ6bWtobC/YBfc2cGGPc6rKafgIPm4uWSMFkcTq
	3oY74srK/INb6HN8UEGdnVc0uW1I3i0agEMdLYKxFon1zU+6JM94zGBGK+zA+DgS2QdW6+
	9MwPdMBpiU1Xs5f2JJCc+2StQq6LjwU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of fw@strlen.de designates 91.216.245.30 as permitted sender) smtp.mailfrom=fw@strlen.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793630469;
	b=sHZ3K/ADuMc/KrSyE96yXaewRX4b8voUjTHZ0zJDQ3TvExYE//28N2cuwfRWld8jXtHAkv
	1TXwhL1LoYNnwY99dQ7RQvcYFvo7FTVpF5cC8Yq9aeT0pchtzl30xu+AlzQVTrBya6h1Hk
	UWkQgqsz3+E8+57mIzKTr7/R1Oct7is=
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B65DD60342; Mon, 02 Nov 2026 15:41:04 +0100 (CET)
Date: Mon, 2 Nov 2026 15:41:03 +0100
From: Florian Westphal <fw@strlen.de>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org, ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org,
	kexec@lists.infradead.org, linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org, linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org, samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org,
	Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH RFC 03/38] netfilter: xt_recent: don't remove the proc
 entries under a spinlock
Message-ID: <auig_zhd3L0HEis3@strlen.de>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-3-59422ed3e465@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-work-procfs-bugfixes-v1-3-59422ed3e465@kernel.org>
X-Rspamd-Queue-Id: 757E2140009
X-Stat-Signature: hmcthy81ahhc73ztwzrnfxan14gwwctd
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793630468-394366
X-HE-Meta: U2FsdGVkX18t8sRLMnEt+Bg2q653sH2cYTfAq/gwUSW/seI9ahwvZ7iDWoeMoU159hMJZ6yHHx+HrHJaSZAotqydoHXCv4dfwQz5D+GJRhQoZ69Z2TUWNTE2pV0iqC9BUAu0gKFlIzeqksTWmA9N+9+Ai6G+u6DD/PLQebHIKnhfh3GA0PdeF9ZrX1nHk+VbLQtGrbV9cwcLiydUj20tsbHn1rLmETUelVFlxtRPazpq7KnHKF1pKCxqSDlHEdVcK4LulAHBs2C8z3b5vElha4IALV5DgahXWr0zkNUNLkRWtCHdReM3a86kmnbvlGJ1jNasWAerNHK9/FDpis/E74zBLUUy+yKjelJWm26fb2Nh4u4vmixjH4xpgYs5m0OhZNaCnk6+Do4ESrZqOBvUpaKG84iqM+mWcR9ob7FIJxPO9lNvn63fnnhqTvyNY3gYQ0YwuSF4NkZKfu0RBsG46oy6VN6QzyvAltDWqFoF6Qf0dP46oRKOkaj3VTg3W77RCjNQphB0A0h38CMUbie+BNRH/hEqDpROtDR12wRE5pLdmD2t75OuHbbIKK5hXDqgKZno7RBY61FAN+v6VVCEpi1jKUpXkQXMGBHFaPpRhU8MxdyZA+3BolAfTPIpDNFOPNsXZ8YncXr+68D6TsepROlXnOrYA/eawC019tQMCjj3fCZWcBD3y2INKSJfJ54L9680GmIXyP+edBkqnYIfup+A933Co+w5WI+nKbMWWr3MHZuzSlNqYNo7cSbuCRs2Kcjux81n+Yv5DE2rAJlS6Kv6CFF3l86HKFgCs0fVTEHHYQzu5t4TtAcnLp44Ies6xipRkmMbEZL4VP3sSIYe4CoQAUw+mLLbP9hOMmYH/4Abodpm6trKr1giHRXmz+DP3FLIBq/26nLKWPBLOlLeaOYgfAIYS6Ubna5yZyfUTRAKrxKR7LdvluC5JtkaSYgbBhFIkG1xhb/kut30Nuv
 snZvxqYK
 I7sBH6da+AgivgZSRls4Th+RHvbdez0CcrwynLiRo9/fnZ2O81f/ji8zefj+lPpVhXcFU3BrnXDvNZfj2luAYzEZzYwQ2pLq+39E910sauDcLidRP69aNnIZ0zWcUGxT7K/kWDXWHGqdefiKXIWVgtLp+jW3rJozx9xGifn1S7gkPGAI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Christian Brauner <brauner@kernel.org> wrote:
> recent_proc_net_exit() removes the proc entries of all tables with
> recent_lock held. remove_proc_entry() waits until nobody calls into the
> entry anymore, and reading one of them takes recent_lock in
> recent_seq_start() while procfs has the entry pinned. So when a reader
> gets there while the network namespace goes away, the exit path sleeps
> with a spinlock held and bh disabled, waiting for a reader that spins
> on that very lock:

Yes, but note that this change is already part of a pending nf -> net
merge request.

