Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81ADFC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 08:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 908A26B0092; Fri, 25 Sep 2026 04:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B9346B0093; Fri, 25 Sep 2026 04:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CF946B0096; Fri, 25 Sep 2026 04:52:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57B4D6B0092
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:52:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CCCFF1205D1
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:52:29 +0000 (UTC)
X-FDA: 85251668418.06.E9223D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 426F620004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:52:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fwDAiGFw;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790326348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4ptkTNJohdeKTdLCn1SvyIDDWNyPxqWpX2yO7CKxHo=;
	b=XKhg9SMN4tr+zs04znVVQtA7B7HRymyU75wGHESeQGb6LKRtQKSxYP4ofgQoPwSjjhiSTj
	hIniXVLa/XtYZUNlwav2O63FmVBU+LzoZry7bT8AU8g19DlYPUpDyLar2DCSsrnDycCatE
	zbCFM8WJxKEsVwFLTnQ/8uCKB7v9Z1g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790326348;
	b=QpbOWPAhavZtkEgHiRwzUSIDSbqu4HbI7IR3/ZghPaPJHoNkFX2QVg6s1G41JB97acIMHH
	en2frmg7L+ZTqG8Cyxh61YNg0IG3Y6Xq4zRPFAtYs5QwNRzA8Ta9WuQGJc7WyWJBw0SSJx
	6gfu//V+0EU9OG3EfepcWJoRqALNCrE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fwDAiGFw;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D41C60239;
	Fri, 25 Sep 2026 08:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10321F000FF;
	Fri, 25 Sep 2026 08:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790326347;
	bh=f4ptkTNJohdeKTdLCn1SvyIDDWNyPxqWpX2yO7CKxHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fwDAiGFwokb5eUjOgjzBenqA3PusyO+kfYTFnmgXTYyzx+YeYa1AV6UU+Wio2StcL
	 0hiiIiaGOQ4qbX18OEatoqlJG7Bm2UTreJdkzdctaXobnKfCl6SEcmJ45IIP6SaQrM
	 kfP3xHUgk1Ud2nihXyK/02zWfh69tdVCaG/VuEG6R0+TD5w/GA1u6Lz0Qq68nYWmz2
	 ANkRSehxqkSu7IcCaeHJDU0e+ytyM8NClrAFKRhlJOr200POns9tfLVaIbGkBBH1y2
	 RqbJnbgjdsr8Xe2aTcJNHTw+9+lM/dzBgxihE1WqWd/LXEJ6FlgGZZLHXBMk6j4Sil
	 SoCxMPcooXcuw==
From: SJ Park <sj@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/damon: preserve quota state when constructing schemes
Date: Fri, 25 Sep 2026 01:52:20 -0700
Message-ID: <20260925085221.47343-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260924201615.4478-1-kmehltretter@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 426F620004
X-Stat-Signature: a4naujj4td9fwix75d49q5ehhfqewefx
X-HE-Tag: 1790326348-487938
X-HE-Meta: U2FsdGVkX19ygQ64iLTib56OWB4TuV0rZhJcvoqcqnkH7yHkZQeTS6oXcJY84yXiw2rlAHk3+ROvI1DQXg/tAJMgKTyJuzhnWa06khknEFcc2rlXsUmIpDtw/fGG3EWZIStZNntN/UTsfUC0wdNs+u+yY7GfinfwQZsDM5665tOx9k/TXsBcnpe+6K4/oT6ZITn4wF2N5XQ6RjJT/vRP4fluH54HxzMbNWabYCQoimERhR1cxgcn9uFsuC2WvI1jSLWzT7SANKGc4ncdDdNgIk7//UREyn6TUYRiIzect4bsOtowG4GanIDQRiiztNjHd6V2uWw643Fw0FoZzy9Zar6OltSXNl8/4nX+WKLhNWvAbtX/6io1sLsqeBhqKrPjffHe81eoYa3OWZNEFMx6q7DKfDS14mJ6cudWRgP/DKJ+Q8dCM2rYjNkSKSfKc8zEE7+8tt56UilZTlToa+da5MX5YL+oyBwvyJpGnn+8TIUfRFabOk+eyGzGhYWCLs8P51CIUAFrBFIBWpfYxtYDk/9bKapWwo+OoUPffZaOWjkyjc+3a3wtqZv6eyADY8cnCzg2lnrQkau5OWntKKT/vNLhf+VF+d66f/uNepQ6meABALCrFMGKG9WVqIiff994UboiTNJq3BCWYD1uR9BtpC/2YshSqT39wZ7scO4rVXwDEZiD1Bo5XeCt/DVd5eL/IGfXYMYQd5JdixYvzF1CbQ+hSasFVl5xrbbQMtbUex40hqrH8NHBWV2CowpToaOtnpWv61vH07qrsP7jDekp7R/jh6My/kw9xQ27LPiKQRLWjBKqEFaD6kvCReyevaFBrk+Pzz7J6mXskcVns4tcNFI64JYJy+9zs9PdJOzrWDSDIU5khcgOmme0/WgedGjLvsPjDGwtIiBiInWl/5s8AfoIaQgpufmZsZa0cGQ3RAeT9VhGx/v6EuxuUSJlIgoT1W4aJr7WyFZbKy4dIja
 2hsRfex4
 j1bANWaNg16VEbAr0ynfEDHE2dv5gvKUJr/NQ+ZkYVDGt3YrVB690upL2WosX36EHtdMfGL4sXzW312UnaFGgWRqIfGZ58a6kZVXuxDvYTH5RGErFnFnUiW72h1opcrnwelzpsy93+d1ZhqnRlvvpIpE1bS46/dOydb8QHaqPwlSerrcnqnGmLlGTgBzNxj/eWkCwFn9Kio2ke3oRNEImbVPYFFaKA/QIoemUTXCNX7HRoAD+rpzYxvJp9+bxCTStIK9dvtya/lJuwPE/kuAcOy5ecw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 24 Sep 2026 22:16:12 +0200 Karl Mehltretter <kmehltretter@gmail.com> wrote:

> damon_commit_ctx() first commits the running context's parameters to a
> temporary context for validating proposed updates. Constructing the
> temporary schemes clears the running schemes' quota state because
> damon_new_scheme() initializes the quota passed as a parameter before
> copying it to the new scheme. Even an update later rejected with -EINVAL
> loses the running quota state.
> 
> Initialize the new scheme's copy instead, and add KUnit tests for the
> constructor and for accepted and rejected context updates.

Looks good to me.  Thank you for this series, Karl.

This series is applied to damon/next [1] tree, with an addition of user impact
detail on patch 1.  If there is no more change requests and this series is not
added to mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew
Morton) to pick this.  So, no action from your side is needed for now.  If it
seems I also forgot doing that or you cannot wait for my action, please feel
free to ping me or Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

