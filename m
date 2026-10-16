Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02661CCA463
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 01:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB21A6B009B; Thu, 15 Oct 2026 21:26:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E88DB6B009D; Thu, 15 Oct 2026 21:26:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F676B009E; Thu, 15 Oct 2026 21:26:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B82676B009B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:26:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 413F840298
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:26:32 +0000 (UTC)
X-FDA: 85326749424.04.FD05036
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A97E91C000B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:26:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PN2TqF7m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792113990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3bd81Hi/rmFImpkTrd3Z6omZvXbyOiJ0Rex3nfosaXM=;
	b=m39PFS+SK8bwLWOaQX5s6lzfLCziOgGyIvYngYuEvsoJYAcgxRQlNpetyTvnVKLzCDvxJv
	Rs+s534rSpjIcCwiHfPk/3ZbIpXNN0uDen+M+SZfQVy41zL+KZ4tJuZQWrKW/ui+th/Dsg
	ERNHhFUV8P6aPI3GrteQFnGxCTfa3m0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PN2TqF7m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792113990;
	b=Hyb7+xe6ODAoof+7iqhfwDpNmIvy512+vHHpoXGO4nxYQGE3aEHJbFxdlWPSft3MW/ehNV
	+nkzUamJcTfnq3JyhyFeJMzBwSpmfTMiXWZWVr5x0twGIa0S6i0/6GNvWmpLODlmoiabqC
	386DLuPvWjQZ9/Gr/Qc0KaLcQCAQTco=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB05060A74;
	Fri, 16 Oct 2026 01:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B86F1F000C4;
	Fri, 16 Oct 2026 01:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792113989;
	bh=3bd81Hi/rmFImpkTrd3Z6omZvXbyOiJ0Rex3nfosaXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PN2TqF7mywsldtZ/1r+qhAFjnHWy5d5K9e9jGU+IoYRUIj3HuzIEbmujFw4NtvAAa
	 9zB7ARDDYylKUH0hna69orBn5qin2E/UaDci7PATib5CfeZcdiPX4C1ouP8gmEzgiZ
	 bEL0fMJ62GXrGkiViEihf9T3EI7WIYlJxOVM1kq6vzdO+4Xhz4lwxsf6Z5/CP+xkBb
	 w6Xo3K06b0bw2A69f73unc7GtDhOwaVjBAtr72KCU3Whxo2JS3ddEKscgQyBJlxgLe
	 9M0aQErBMRi4faekAGL8Sl+w0xi7yfXmzw8nsf+dbNyAhxd15oXYDDlR7mi/FEKZhX
	 eBfh0Wm+LGOXg==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] DAMON sysfs: failed update clears tried_regions snapshot
Date: Thu, 15 Oct 2026 18:26:21 -0700
Message-ID: <20261016012622.114496-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CANOyQmHhCJEbHpHUZ2P0hui+We7wxWkEde-Vh4k2rRXWovRYrQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A97E91C000B
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: pcu3rx4wa39d1ccamx5sijkui4exf98t
X-HE-Tag: 1792113990-16135
X-HE-Meta: U2FsdGVkX18bSgVHC0Zxnky32TbRxXhJWcGxbqi+wvnqzhk4unTYkq6eHqawvBwFHyf8K31vX3SIgG95Vxn5YvGE8y0Q5rXBBgj8HbgG2/ZC5eQpoNgIODoP7ffVZ92ztP6D7Zk8wdB/gCpYVhmYCmOMX8qI2U3rY7qnsHNRKPZ409BDB4O4sLUot7nSvVJNnqNtAZar/f6m9x5H8i7nhVA6QjP+GYo8HtaXmFTRiEyiV5Uh6/pQNd+k3rAQSAwOV83d2eN4hSqPt5zshDO+onm83043I5z1R3vaNy+ZG5ypq/nw+sPlOq3owMQEfxBnmUKvsNi0NfKzOt4KdKja1Fwv/kSJjrNJJUED89An4srCG06IFz9LBB6AKdErSOG0dVtnNzsS54g7xJ+7RFwSIEbe4uzVvp0O1pc/lxW4IPW9ZbF69V8BiD1A3uxCSHK4ukZbwnyeY5u+ktOZfne6TdGN+tC8rwwqTB1hUAgHqGGaFgeBQtZ3OdOXhA0ZqUs2CkahYsI571bGWRVXemGbxtwlKb+qBl7NhPGgavdAlwvirYLXw6wPE3tlzVtFM+WVI3SwK8danNio4YJOnYzMKtj66cgZ01Fh5amtGQNjotvKqqNbzKgv1zv5KhgTUqvKzyV+kSU5psQLOKATTJ9GbUXeV8ojxTkcKdIR5A2zeBlcMor4GHrwkDyEdSV4rdk5MX2NMerEzRf8y7ySe+2ql5iFMFA2BcH75Ywti/oqMLwpvH8nsbWic0+jq0uLhZzRtYf5O77OARKEJh2SZk37rNBptvn1CDNUvcSFKU6QZt5PIQQWvZfBpA5VSwwecnPpkvlM3nrOKT8LIbLnN98T0opH9rVSSLVDrh2QPgEW8J5cjTiDnyurH0azp6a9B65MYxvQSmyVa6c5QcwasGaYmMI6lFFmKK2+XTAz8eVQYA33ZFIqOjpbiDEGYV8eQlUQ7lUP8LKQS6EGPZgVi2+
 6ljsU265
 y6+uQX6/mZwsGJLd4RVFRDRTDOXcKuMbzQp5LXl/1e1F+JOKyCYgaYbxtLgH9KzTtZeYkxatOVTNoENepyzgNQQNstCKnq4GSuXtW17WotP3TOmz0lKii4SRW1kXBeID+6mjwmts4ZmYAdQPhu7AHzIkiYXV0rJcM9e9tAvVC/CIvlHSWIc9S9P8ajzDGcvAA6kztWbl7aVY/VociZXe9t43XPODywdHMFtcCdBpuo0Mx/BMKdcyMLczCaepGs2+8kDZk9jDvgecTpMbUl2nHe3oxMZ0zcc5LLoHuMKa6/eMmTb/nUOa69HQ9fRvj6Xo7/qg2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Aveline,


Please do not "top-post" [1].

On Thu, 15 Oct 2026 10:17:05 -0500 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi SJ,
> 
> I haven't seen this affect a real workload. I found it while testing
> the DAMON sysfs interface.

You shared 4 bug reports in very short time.  Three of those are from 32 bit.
Could you disclose the purpose of the testing and how you are doing the
testing, finding bugs, and reporting those?

> 
> If a tool tries to refresh after monitoring stops, the failed request
> can delete the last snapshot. The tool then has no previous result to
> fall back to.

Why would the tool tries to refresh the regions after the monitoring is
stopped?

> 
> I built and tested 66178e4ec30a and its parent cce0b334c310 with the
> same config and reproducer. In three runs each, the parent kept the
> 4 MiB snapshot after rejecting the refresh; 66178e4ec30a cleared it.
> Both returned -EINVAL.

Is this an answer to my bisection question?

[1] https://subspace.kernel.org/etiquette.html#do-not-top-post-when-replying


Thanks,
SJ

[...]

