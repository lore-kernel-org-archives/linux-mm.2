Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E42D7C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F19F16B008C; Mon, 31 Aug 2026 12:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1BF6B0092; Mon, 31 Aug 2026 12:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E086D6B0095; Mon, 31 Aug 2026 12:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC50F6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:20:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 632661A01AD
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:20:52 +0000 (UTC)
X-FDA: 85162078344.20.199006E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id CE7ED20011
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:20:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PMQrHkaF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788193250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tI1sWrR0uNh0TXdJTPbEYJyehu63ytxRVKdQE/GQYG4=;
	b=e6Jk0nmv7TSJN98NHgV3H6GAFM/arspvah3pQj/YUmQEhi8oenEK8jzjIso3TQSNAVjolE
	2v3NdwSfC7VQdDyzUmyPmK/swkI+9Td86mObcdCtCZR7rnQn4/TOgqLjMDTCAs4fKXNzAa
	hPWAQOrrgW9ogXvMJZeBnWPaCDV7Edk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PMQrHkaF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788193250;
	b=VviJtJlcK++QbOidckWdFtNCEZUPamshvZIZwn3r1WpE2mCiyq0o0Y9aa2WRZIcNdb+mDt
	05U+6CYp7p9VedBi5WdoTNq2YihvjV2NVVfsZUdphN3oB3N84x+eoxluqJanRg4SBAKYWv
	HSS4dm2D+zmS/RsIf4diNjMvpQ5X5S4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EE4F440E24;
	Mon, 31 Aug 2026 16:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141811F000E9;
	Mon, 31 Aug 2026 16:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788193249;
	bh=tI1sWrR0uNh0TXdJTPbEYJyehu63ytxRVKdQE/GQYG4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=PMQrHkaFWC+D3XenUSOXVVfwJVpDfELNYu8xlJ1JAOFrd7/+ae7emP9kKi2wMufD1
	 kKKvd0RrxU0mVv1Ydumxvl9FhXN7zN0OaRcZvzTJYWqqishBG9YRCE36yDOyLZ+V1q
	 bSLBEjZ9VX6Z5zoYcfJYpDhCi22Gh3ZpHgzi8/eZxgFgRaeUUqOl2Com7wLTnpsBVE
	 /DCvBLhCVDVlXid+J05E3eZHof/yRpY+h8pGpd7T3SW21wzBTAZjPQjuDVFQa9Gxpv
	 bqfLxYDgETax8eKgJb+AJRdYcQNHDo68H2FCGD47951r6aoe9PfpsXDR3D18ivb8XD
	 5nK8yvkH889qw==
From: Thomas Gleixner <tglx@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Hyunwoo Kim <imv4bel@gmail.com>
Cc: Frederic Weisbecker <frederic@kernel.org>, Anna-Maria Behnsen
 <anna-maria@linutronix.de>, Kees Cook <kees@kernel.org>, Christian Brauner
 <brauner@kernel.org>, Peter Zijlstra <peterz@infradead.org>, John Stultz
 <jstultz@google.com>, Ingo Molnar <mingo@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, "Eric W. Biederman"
 <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] posix-cpu-timers: Dequeue per-thread timers before
 exchange_tids()
In-Reply-To: <ao7iQ_wOLghOvTsq@redhat.com>
References: <ao7Q8miiuLAPVnWv@v4bel> <ao7iQ_wOLghOvTsq@redhat.com>
Date: Mon, 31 Aug 2026 18:20:46 +0200
Message-ID: <875x0qclcx.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CE7ED20011
X-Stat-Signature: hk7oibk1uon77bkthopyk3ksm4fzhrw1
X-Rspam-User: 
X-HE-Tag: 1788193250-623160
X-HE-Meta: U2FsdGVkX1+sEaVUS9Tvu8d6m5lwTeok6qoI597aGSzlu9qXD31CWUBcYnfQYOkQBfP6L+HHmBEsMNfZxpF7cUOxhUZ+Gk837HAcDAgpKPke5SwxJPeqKPHSghxPlLQvFvH25OBFeyh0rOAdObTlAMy81/apiik/Y/ijB6U7lPCd2t30S78kaMuuyGcAoo8wmJ3s0TSd3Cu6iGXXm8Exk14XguDafQm9SepMEvgbUxLROJagr/CjIPEnjDeFH2XQWPA2o9+Le+1b1kdD2H8bEa5LFz8nBVPZpUp4cjAEtyYUw1CyZhdnY0+1tPpKdnFEYdxCFVLVkk0h42Oy9aKnFUQnSe4IhwqIMvIOcUbZEpJF1hLdyookHwhlgdwa0+gqpJKpRdgQ6Q+qCLAabG7kXcGGjLvWG2pH1Wcot/0kn3T/uFzkKPiioBOmjEURK0u0aaSiTzhuiMEzahKxI6WG5Ne7o6VuhTZbprwq7cTfMHnsOiPc/hU8uJil9cPHUTagk6I5lsN/oWTAqsg5fcjtAUmWjMhTwxHlY4hNKgLYS/XLHP4I1L9trEd5tkEoFYtq9MotmY4QYX41KtWrSfmhSMEA20orEdWZtNN/MShqRHUwfu7Di3h8hocm4/R0DugkxJG6IWRhjR64Fx7iYme9t+cHNqH1P/mptFQdhEkAQc+QrXuhZXTb7dM7DerP4qVtzyeXAD1XGWlzXhaNDNARLCL3hXKgUpGP65mVXpw0yXtvRBwsCXEGhY+Ee1tKlWJas3scIJgQs9EItvjcZ6SsI3xZK2maMmg826PQ34UpG1g7N/XWrk3W6rnTYq+ERl3eD/ixUYHM5rCeTUt4SrwLkVMJpsfJKA4rOryoGNlXFz3WPFp7d5FKJkTVKXGNvXhYh7NSR+4M+06mOVf+1vIzHQMdhYwBX5FADrbhDDZPt4ZtXmJX01hMUB/Fx/5DDlM8+H1DxnXDx6q1DZNc5eY
 D/pLe0Nw
 +gpLyzcTtPZclXI8CoiE2yzKLE9gJMTTdMhQsJszKXdkILTcd4OmkdFspU99xIKk+/WAKdX3gE73WDDhv9YDwDDa7bdFNQa1ccaB3Y3RoSmQMEwa4rXObCpqnTRue5dggT9z+rNnMQmaPjLOJ7bWq0z/9QEHkDVLC5phIFcpHsqUlqCPvAdUektIPrguAbEJB31NvHpb4RdO/FpmrSvRQvNIOtJcZXT/kZsyKiV3As/gM1l/UG8dNFVwXAf5AsMLDGvxGoUO54UW38JYZWPC99Nb3CnFyaygFSi3i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26 2026 at 14:55, Oleg Nesterov wrote:
> Can we move posix_cpu_timers_exit() or the whole CONFIG_POSIX_TIMERS
> sequence in begin_new_exec() up, right after de_thread() before the
> "if (retval)" check?

Yes, but that does not buy us anything.

