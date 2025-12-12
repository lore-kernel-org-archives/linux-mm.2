Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFADDD43369
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 05:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F4176B0005; Fri, 12 Dec 2025 00:34:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4F96B0006; Fri, 12 Dec 2025 00:34:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E24D6B0007; Fri, 12 Dec 2025 00:34:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EC8F06B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 00:34:28 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84840160429
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:34:28 +0000 (UTC)
X-FDA: 84209703816.10.E1A9D83
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id AF84A18000B
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:34:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=TuQVDuyz;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765517666; a=rsa-sha256;
	cv=none;
	b=kmh6jEbBM+4BothsKGOFsUkcon09s0L4gxXsQ2p9R/jAK61rCqpjlfQiEmJbbJ1mxF+BFK
	KkdrcF7qQkQApSihnl3N73lRDsCXawRUotHJq6VvpvcuJPNvo1D1VQtWVCr8J6K7HlkV9W
	vCyjqVoOv3JcJnHmf0J7suCIF7GD5lk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=TuQVDuyz;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765517666;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TlpYrSosOBmNWlnFfYJnHh8ac0VqsZN0gBrjnGMp98E=;
	b=TnLN+EfEQeEp6ETN1VUwjCbMNRPNSENuz3IwImewS28qQk/hen2eIQrD5uXYsAU43+9qj9
	n8XG5sex+2FtsqxirpskG1WMF6kCUGG41onkBXc4FxlwAEXPtuDmYS773th2xG9KAZNbUw
	fsuwvsVLo2CjPNry9gH4Kc4iPx/g9x8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TlpYrSosOBmNWlnFfYJnHh8ac0VqsZN0gBrjnGMp98E=; b=TuQVDuyzmfD1zEEjoneYjUYdl1
	EtEYQ17Hm6dGjcPhp0LIuKcuz2d26+57P12EoYAdxnuOq/5yG+LrSaC81afa2nNA61A28jFRpx3uK
	cOrHuq80BCyjoy7Ihzht6mPKIHtiIguODQa4N+AOvhk7N/zdocgFPqdcpoLJb79JImlm3u2VureMX
	86PQ8wUxGbjfX8IaSbYC5OnniGmsX+7pjdxr+vQzm8bzoOM+vrwP2hTa9V7Wq1vh04NNECKCcLtlW
	3g5r+3lD9vPMnHSxwGPQSA0m0z25tC0ARqh12CjSzS+M2ug/ek8b7GPef9AbTzKhXsjncxBYJ/JDD
	a/jwk5jQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vTvnp-0000000B92D-01cz;
	Fri, 12 Dec 2025 05:34:53 +0000
Date: Fri, 12 Dec 2025 05:34:52 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: 6.19 tmpfs __d_lookup() lockup
Message-ID: <20251212053452.GE1712166@ZenIV>
References: <47e9d03c-7a50-2c7d-247d-36f95a5329ed@google.com>
 <20251212050225.GD1712166@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212050225.GD1712166@ZenIV>
X-Rspam-User: 
X-Rspamd-Queue-Id: AF84A18000B
X-Rspamd-Server: rspam04
X-Stat-Signature: 8ryyqh14d99pa7hfdb1nm7qoqq3nu35y
X-HE-Tag: 1765517666-60774
X-HE-Meta: U2FsdGVkX1+WT6JIphC44GTY0N9xpcgrkl4PMX/62GiKT2Xj240r1UGY+wf9lVhdaYTyCNEQUSu/jxNbJlnfeAeCizXkx71tJabZOg+gFzqrOLWNfLBHf4Dqfa7GTaKMsg8mEKwzewK8iHd630kGhO3tU/aw/gw+d8tmvt8Z07jm6TucCalVMEfeo/pueKuSgdwbE3+mmNniNEMYZehrf1/Po5lZHVGlua4eB3wGejVzwKeVGaqE+zrkfT2NeGzBHR4tp+zeUbDWMG/NC6F1QDb31d5i2HrgJ3wtFrxXqWU896lHEvRCrGOrD9fT27IZ/36la8qX4EyWkcwCEMCJ55UGAlzGVW4k9y//tdXDQptot5f/u3gNdGo0Lc1vxkV1+SyfEJtzl2GLmgR43+e8LdAY6rRQfpZhwgXkoUQ8rwuQPdAKPPcCz9VUZAB6PhFMnjaKY6XftxRcv6lUHnN4/6/vJUAkYv9hTCFg1WH58fsaSUkJlyCT6/8ZCujCG40RyjTZWH+MAre2XG4TsW+yNQRGcWwl5/A8rqbp7iljVgfk3gij10D7WKtYfmoYTWpIrFn7iJfwJVHx+EmjoZFQtRtUxXn/ERANkyVDPZUFCx0l7XLQTx7fmxfbtJWd6T+4V3aQfOWTsEYf4I58zk2f+t+oP35Illnrp4acmHCQLlJfpLeqfXI9ttucJl8cXqPK+DYzee5QS9GmzlLCcPNDk9sx614GYvtgfz/i42on6E8QY3Qkcm7xYQi+XlaWYAWy8zBJ7qrmmwNEHNj/yVni2vs/sEaDl98awf52xmLirPzpk7kYJdj89z9+xOFEYm3GbkF2te0rU3+u4NDFSkq/Gst6m3yS3M3FkK9beOLy+htT/ht5oAFhmMks70nmRaqs+IHi13OT5XWstPCJgUGhL7v+jampN2kIQOx7jlPpBbkRHu6Z8MVkHK46H2W3Waj/+da+MRszcSzuahxQAPh
 Uj3CYBlv
 V0yOqUtAkoesXX7d/3NUKmBzXkWNC9p7CcNhnrC9vPAq2isb2I6/YzzVpklBsTyxkDggcGimoyMPZQWT5TO59aCcEuaoAw7Fq5AJtYtHiKIRMjWi6CXtPgR7mU2gY8yvjCLhYL5uzI4XSY3zZXM8AP+LGX9D4xjvYzhcD4GLZVpFnxpclppRp1CaIdfkt2g/RlvzYE4TqXAKl0qp1gJLsZemGzfuSUGuJ1KThkdPsSl4hTjbX9YEHmmG43xNCxNglY6VOcCrmq3lAw8w6sqOZI2IjEQdqGEykV9dTlbBxzbW0M3r0q93l+BS/OWzi9/p88qTJivL1H3dUTpAS2l0d0WiorRJ2P/4IORH129zLlBwqUzuWtQ4En7IXBzzvdWU7SQDB71yBxIRFW8f7Q2AcL8G30FJdmcZA7+HZ/UZkI1Xl6fCKOLaIznd9gDA5fthDImfyY18k2W5in8KQUm0MUiVahb8QEYuNzrdY7lP51Ycfqt0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 05:02:25AM +0000, Al Viro wrote:
> On Thu, Dec 11, 2025 at 07:56:38PM -0800, Hugh Dickins wrote:
> 
> > Of course, 2313598222f9 ("convert ramfs and tmpfs") (of Feb 26 2024!)
> > comes out as the first failing commit, no surprise there.
> > 
> > I did try inserting a BUG_ON(node == node->next) on line 2438 of
> > fs/dcache.c, just after __d_lookup's hlist_bl_for_each_entry_rcu(),
> > and that BUG was immediately hit (but, for all I know, perhaps that's
> > an unreliable asserition, perhaps it's acceptable for a race to result
> > in a momentary node == node->next there).
> 
> Hmm...  Could you check if we are somehow hitting d_in_lookup(dentry)
> in d_make_persistent()?

Another question: is it a CONFIG_UNICODE build and are you running with
casefolding anywhere in the vicinity?  If so, does this thing reproduce
without that?

Because that's one potential area of difference between shmem and ramfs
(as well as just about anything else where tree-in-dcache might be
relevant); if that's where the breakage happens, it would narrow the
things down nicely...

