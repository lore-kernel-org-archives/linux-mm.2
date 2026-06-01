Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 068D2CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DFFB6B0453; Mon,  1 Jun 2026 12:16:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 690666B0455; Mon,  1 Jun 2026 12:16:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CDBD6B0456; Mon,  1 Jun 2026 12:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C38C6B0453
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:16:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D69C140758
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:16:47 +0000 (UTC)
X-FDA: 84831847254.16.9F383E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5777280010
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:16:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SC2lQoFO;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780330605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2bpASveTKRhnnK7RqHQ/gb28QgUflHaWAOnJOmldcic=;
	b=p/+tjzUkyM/2O9bS9hSf8X8qb75/Eevr8Uu3+YQvzCjtDTHLVosrKV2RNFKnLhs1c9ARQB
	uk0ixbION4m+4RmTtsDqvY4KoDsAiiFXVsupEgxQMvgEMbh1AC7A7XKwGcpMFUwTYRjafh
	iNRrKIk4Pr0uEptoLzqtZSu1Ibl7Bm8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SC2lQoFO;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780330605;
	b=LQSYHqF3SiKJGtmMydDJ0oUsWe533Z1aEpqqsIBXXhoKAxJ/h2q/QTMMivGQ8MCBJ/YJX+
	WCF9vxZ8Ume9MFPDlZ9uTC4l6um0/qsnAncQVEeNlK010eQS5NdwXCWjTfCPeYdD5E32sg
	bT0WElkA3T2rS7zgnpoGNK9OtgmGJw0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE1C5601E7;
	Mon,  1 Jun 2026 16:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58ECF1F00893;
	Mon,  1 Jun 2026 16:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780330604;
	bh=2bpASveTKRhnnK7RqHQ/gb28QgUflHaWAOnJOmldcic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SC2lQoFOOIhfLyd8tXQdxDdmqlHh9UsZzkKnvBXZS7YH1EDA3xXwa0KDVHF+d8axL
	 M5OfrFlp/JDROL+rcPjrEQfZNvvu2lJCW4q4otdgrG5bSTil3DuJHrrXiZ6jMSqh6F
	 xiM7NvDLMyrWbZjwVrzJHvPYzokqTNRWMq9ZiRTCoyvNfPIGyxNXa8S5LV0bqwbNX3
	 0UbA0pJw8sUDVj/FpSxjv8EzfPaQBHDnkbeWB2cAypMoH0ecPMwpwP3KS/YcKN7/DD
	 W+sun6C4ZP+KZgsptnq+BlE4ePLceTcwCoPYnW0thVe15UfLkVST4AEGucAmLSqgJQ
	 DzaspGX/nifJA==
Date: Mon, 1 Jun 2026 18:16:37 +0200
From: Christian Brauner <brauner@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: Pedro Falcato <pfalcato@suse.de>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, 
	David Howells <dhowells@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260601-geldentwertung-aufdecken-aussehen-1502bfad440d@brauner>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <ahv16ogY8Zx3Rtox@pedro-suse.lan>
 <CAPnZJGD5QR5jrNMAem7FjMRTtw+Ue+jm7Dc2Kp8Lcjj+9TDw_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPnZJGD5QR5jrNMAem7FjMRTtw+Ue+jm7Dc2Kp8Lcjj+9TDw_Q@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5777280010
X-Stat-Signature: wiw7d31p7udxd38nn9d9m81qk9yidhj9
X-Rspam-User: 
X-HE-Tag: 1780330605-737985
X-HE-Meta: U2FsdGVkX18gee5ovev9lnoTFwPJvN7YmLU/9mUhflLqWrZkF2KvLO6/J8nF0WPN94/zdQciw8qw2ZHU9WYY4hXe84NrsMv1WGKWQaU9oNpc02yDkvYaH/53p9t5XrDlR1NSbfDSLAQ1qjJCdAaonGYiXUu6+numbGKn6KwcFNXQqDdoYqJ8rz3GVBml3HCaFdb895XDlTbHlPCuBB2cOxeSpxXJ3gyxypOsobt7YMfVb8ri3dPw/BUiWxYcHZjEmVWAduOjIG10VRLyvBDr+99LNGlkXnfXw6ExLdB+2u3ezs46voX85FLW2Xpa8qlK/lTa3ZR7IVS7SPZtEfvd3UmSWpJRh0CEwQp0Rnk4vCKoWxxj5/wPK+RaOGWom83GuqWT/v6l7DKI6NZiLEIpFTH5fZX44Q9PT8tiOPFcRs6FjNE+ABcBh5u1YjWBMJIo59VSF2WoxkexXsZtpxT/Zl1xCVBu0e95JO41Q48VP84SmeBs2krFo2rk0lKeQsRypoqwEm7D8f2r+vnqSAAMB2eI+eXx/ui2QSuMVS0+jSRKRMEmfwuDzsdAoB02DNbViO5168du5wYicJHTLRHYUfy4h5ZS9gG1Ts1TAfIsusPRHJdjvvwb87/LWr357ha11j5p38G3BaRzvrBvM0klnzkB+3Lo6lWXdYd8vXNfzqBC69BHrJZQMu1F+VsE55UzXl4sRWEN7H0FUwmO55jDZ65A0deO/zdyv21unUWfX7qB7hZZZU3YnDjUFlVD/YWMa+CmGW57Nj/Z38Lb2zIPbSdLhCIWz4iMjPXTOPYsc4cUVYeOApL+Fx/uX2GnLfvv7ewYGRutzWB89iVpF2MvVj4q+RriNaS/l8w/bBdxztwLyd9Bq+n1VoxdiMPqGNFHTztWyDsTEPlWZXzGP60Xr+3ffqqCzWqDYMYLrdWlAGzW8Ht2UdvpxUAiUtmPEjGR0pXSExnlS4TDxdzwE3A
 blnDwPKj
 0UJw5HI6tdVoC1gAq58jkeQPE1IEXwdfoH630l0OpS7S4QvvJ5iWFbWOxqCcS1nzgbtAdbBAOmugmK7YW2QZkkM/HChmgr6zYd+5ijbvVXHGnTuYmMALAPcA5jJKc8Yu9WXEZvH5SFFpJ0fuATFplEVgwV5N/+GKJ2unrhLSaPSkqzUXBWsU3hb03N1C3YZAp870e4wbNrGbYT6aqDRj7AlXnxSBNYi5/vtsfnH3dZOhfVt2g1TiRE01PxFRcBYXMnz/sC2JYQoRMJbXolYDFQfgdhAu2kbDmrDVSUjMgOMnFlW6vDacpq5wAOTva1EcGXlB1Hx2Mu9kKWdw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 12:21:06AM +0300, Askar Safin wrote:
> On Sun, May 31, 2026 at 11:54 AM Pedro Falcato <pfalcato@suse.de> wrote:
> > So, you took an ongoing discussion with an ongoing RFC patchset, and you
> > decided to reimplement part of the idea on your own, as a concurrent patchset.
> 
> Yes. But I propose an alternative solution to this problem.

So I think this is a case where no explicit rules have been broken. But
if you know that someone has been posting patches and is working on a
problem just racing them to get your own stuff merged is very likely to
unnecessarily ruffle feathers. So sync with the person next time.

The discussion wasn't at an impasse and Pedro is expected to follow-up.
It's not very nice to just have someone else's work be for naught.

> Brauner said in discussion for your patchset:
> "So I'm not very likely to pick this up as is".
> So, I decided to submit another solution.

This lacks quite some context... I said "in its current form" and the a
long discussion ensued.

> If my patchset is applied, then I will try to deal
> with splice-pagecache-to-pipe somehow,
> probably by removing it, too. :) I decided first

So ok, but this is literally what Pedro is working on. This just wastes
people's time.

