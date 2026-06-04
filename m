Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9FF8CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 14:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163D06B0005; Thu,  4 Jun 2026 10:07:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 114646B0088; Thu,  4 Jun 2026 10:07:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0512E6B008A; Thu,  4 Jun 2026 10:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E8CC86B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:07:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9252440762
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:07:40 +0000 (UTC)
X-FDA: 84842408280.11.BCCFCB0
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4A0EC1C0028
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:07:31 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780582051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5s99V2F+cdxC+MwrT27Mau0Uu2siNBpgurBs08PszHI=;
	b=60L1htiwomjz7hoR6FqLbL/+AfIb3VZZa+tCryo5mg3tl9wY//xedUa0aNagZ6tl8V31lt
	q8KF//fWBhaxkW2/cioisArXedNlwhyCZkiLgirkC9Sa0QN3Sh/EEyEbm2YjsSQaooI6Ky
	nxnjy0TnsZxJLWm2B540SZeir7vLH9Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b="mb/IBx2t";
	spf=pass (imf20.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780582051;
	b=mqP6EG6dfCElaVy65KBEMjOtGx3HBAXeCScY0Fv23COQR4Lxjc8XchVq6KcuRvxuGgjYBM
	y5uc6MtWJsJAAqPVOYrRufHQpB3mxJv9HHCVoPT4F+obwVatpfFHCyYKgeUWXr4N6kqMvM
	2kzUhmU1vhyMLMcm3ZDPwSbyP8ZAl20=
Received: from macsyma.thunk.org (pool-173-48-113-247.bstnma.fios.verizon.net [173.48.113.247])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 654E6rvL025698
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 4 Jun 2026 10:06:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1780582020; bh=5s99V2F+cdxC+MwrT27Mau0Uu2siNBpgurBs08PszHI=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=mb/IBx2t4Epn1180cTZPKExA+5u946+tIwlV31jpfDtN0UiOTyD0Hl31IYSdo6HEC
	 kuQbQnyc5edecobCL5JrbpcyK5pHbtgHcD/Jc8TQWSO1qBkfNL95JoWIgDAs8IGKBt
	 uBG9CP9x40IWHSEnEPklfmc8Uei3gfqs9m/dTJEFJODXZ6nVP3b/R8vroBVkUEW1Gq
	 tr4zxnTzkZEmmCDYotcI+GORmTAykiAacHUlAIw/6Z/bI4lAyVeYWvg7XuwidEXkQe
	 60NEfoN/RFaTuY9hSDI9GhFLE2N+msS6oWqaHWyRFqJPqBnGuLGlZsZ0vrl0RBcYOl
	 I/KRqdjz9TCRQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id ED63E37A6B9; Thu,  4 Jun 2026 10:05:52 -0400 (EDT)
Date: Thu, 4 Jun 2026 10:05:52 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Mike Rapoport <rppt@kernel.org>
Cc: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
        NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>,
        Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Dave Kleikamp <shaggy@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>,
        "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org,
        linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <ximvn6jwgtam665a4droqkp73o55kwvd5uukyidwjesmysobth@oe7rigpsjfkz>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
 <yfzx3jgzwesernofl7mzixa2mhjfii5v3o7yapghtmozixrpfu@6bsh7iixyiov>
 <aiEX4UTxEnBTjVKo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiEX4UTxEnBTjVKo@kernel.org>
X-HE-Tag: 1780582051-159790
X-HE-Meta: U2FsdGVkX1/FlUpLB2c37EWDFL4ksO/xFtf/s9YscuxCoeZqvth82uooH5oncoveiCCuo1opvfAoj1oMaVPpvRXK5Qvt/qI1kQvoOBtL+LDORzb4bPYcAPiQA3c5AM/kUZxIXUiG8fg4tK0bvidlyfR4b95ar5I+r8ZYUOpimjUVgdj8LxcJVwSVL1UnxtLNocMwYjzXzgksj2RTlHCNKKn5KWvt1A3SHQZPRQYw8T5J1uISE6UFKn35J0R7ktbAWP5/IPbrzn2qfn0DHvx/f2ZieWZYjfJ091/kR6Sc0Yv3IyB47yqh21iNunMfvwlVaiXC5ruwLuBXOGm5tsykL/EWNQ7AEo8usmNhWoz8g3dgfJLK/9J1Vf18FGbf+wFykdtLffG0zQE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 09:14:57AM +0300, Mike Rapoport wrote:
> There's no memory overhead when order == 1.
> As for the CPU overhead, the difference for the fast path allocations is
> not measurable and for the slow path it is anyway determined by the amount
> of reclaim involved rather than by what allocator is used.

Thanks for confirming!

> Larger allocations (> PAGE_SIZE * 2) go straight to the page allocator.

Another question: Today, we can either use kmalloc() (or
__get_free_pages, previously) or vmalloc().  Is there a way a file
system can say, "give me physically contiguous pages if possible, but
if it's too hard --- with some TBD to specify what 'too hard' means or
can be specified --- fall back to a vmalloc-style approach, with the
page table / TLB overhead that this might imply"?

I suppose we could do it with kmalloc() with some flags which to
prevent forced reclaim / compaction, and if that fails, then fall back
to vmalloc().  Is there a better way?

Thanks,

					- Ted

