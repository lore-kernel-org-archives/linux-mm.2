Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FE6AC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 10:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3CB6B0088; Fri, 31 Jul 2026 06:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 555006B008A; Fri, 31 Jul 2026 06:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4469B6B008C; Fri, 31 Jul 2026 06:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 126206B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 06:34:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78C17C03C6
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:34:02 +0000 (UTC)
X-FDA: 85048711524.04.EF72C4A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4F1AB180008
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:34:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YFZRFGWx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rPtVPnd1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rBFk2l+W;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jZeW2oam;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785494040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZC7k+oGAkj/JK2smcgUp2lutIw7bxKHZY4CcCNLvaU=;
	b=rI3OKJTE+zrFkN/wqdiC7n8TFCSRNcduBfWVwO6Y5SV+f5W8gfOg+8FcJL3Wf1DNUaAyV9
	M6xxfKQ6MbVcJp6XcqnnjoSqeXD8j4Mv9MwUKw3REn5NAkptM9m4c1v2KCPnTGU8TxUNBr
	csoE/znmTpuenZY4K8YZSYEgE2Edj4A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YFZRFGWx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rPtVPnd1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rBFk2l+W;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jZeW2oam;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785494040;
	b=0xfazhlr/Clp/WII10yUy25pAyqHXBukHFjcbT6CWtPucWtcwT3CpOXOAvUCMH4V9Lz1gR
	ZGcxkQUd5TWMOGPj/pZYNcs8720W6EzBWr4hMFm8W+E0aBGfycNIkOs4fHjxxmYKOPN03r
	t6ihN6MXZeUMX4Z6dYxfonmhR0foQf4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B483C7DECD;
	Fri, 31 Jul 2026 10:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785494034; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NZC7k+oGAkj/JK2smcgUp2lutIw7bxKHZY4CcCNLvaU=;
	b=YFZRFGWxWYTgW2zS+13Onzluo+QWNpBltz3MZGF+gk7CwU0HV1wYC46b24brNfKAKMYMIp
	PDaKsQl0GBCWMaTKLFx5G6pyqIUBwSvDwPbOwmUePCuAhzxFztRx+DG/iB4eMX83KyzLlW
	UUsLRKrPsPEm0ZBXsbLtnNtY2yiccl0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785494034;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NZC7k+oGAkj/JK2smcgUp2lutIw7bxKHZY4CcCNLvaU=;
	b=rPtVPnd1JhnbXcHoaNs5ASzYbVkmSeU8P78F2CuJmCbGnWhVpdUBYyFpN5C5ssg2jwbDzp
	FOVEwWu/y094wuCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785494030; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NZC7k+oGAkj/JK2smcgUp2lutIw7bxKHZY4CcCNLvaU=;
	b=rBFk2l+Wj9o6Tx01eTcc0u1m/cobHu8HXJDaAznY4nfgnybOHcGr9ffSXEHEDl/6EIXvfD
	NbfltnA4lPy6PGwTzBlYWnB+LWXHDscT67jzX/JIPtemagONURWN8bgC9mT/n0iroTtQFc
	YuNB3OxaxxgFB1rDs1a/Smwh/kdkt/E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785494030;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NZC7k+oGAkj/JK2smcgUp2lutIw7bxKHZY4CcCNLvaU=;
	b=jZeW2oam2wT8lmDRHuZozokpmGRbwOyhlHWXEglN+jsI8ULA2sQsBQdeo0R+I+wpMihADB
	jZgwwHqSyghHA/Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 85F93779C6;
	Fri, 31 Jul 2026 10:33:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hjYoHQ16bGoRFgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 31 Jul 2026 10:33:49 +0000
Date: Fri, 31 Jul 2026 11:33:47 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Jakov Novak <jakovnovak30@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kernel-mentees@lists.linux.dev, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "\\  Liam R . Howlett \\ " <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v3] mm/khugepaged: replace mutex_lock/mutex_unlock usage
 with guard macro
Message-ID: <amx5XdMQ7S_krjNA@pedro-suse>
References: <20260730204724.16912-1-jakovnovak30@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730204724.16912-1-jakovnovak30@gmail.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F1AB180008
X-Rspamd-Server: rspam01
X-Stat-Signature: axzyxk7hb57cy8ri3egtsch9ukgx569p
X-HE-Tag: 1785494040-933595
X-HE-Meta: U2FsdGVkX1/MNgns4S1N5xG/Nt/p+KAlF+2yHnvas7FRQRMrIplA/8zJob8Q2MpXO0yFqP9iY9E4maPxUA2o8MYUiZ9RlLIp3CGaMW0okfxxwtamtFFHdOLu7NaZy5CoWabZG7SpDO94D0mOa0Me7YBHugTWb30HgUrPtfEUQFo6Nx+7tJMbyk64CUZtRsPguGeweW5LYUSzSB39mwzvXsA0lV94zPzXFsi1bCmgk3YszfxEvmI5hsyZM2dhVaylkreE/6BbhL3+RP8aRi3WY/P3NVi4RpN4Sf29pfS3UKBGpvKbX32TIBhg5pmgQR4KYVPB0xxJ5my2Qlrpe/lCKkg2VbLP3aVlthyYSKWrNhPOzOtXs/Lxs8xIZBT5Du6Gve+nKpuDtO4+1+WTGYl8MqhDAVN94SNNITico683j1gNwNbQUTdDDsYGUQ+O3whanupcrRvh5ESqpUXHosRrGbkYJSDxoCOx6J5aec+WFrCNmRfp64TNeL0Aotr9DPOtb64drReNLHu6huujkZUeUksfVdLvwIU1axlUCqGW2wQuSlllL2txTnwc3jl01+Lgr8ktAgzWgs/rw/ZG/bRb3/X+b3X7y8XsCswBdWMJKrBL1T46IMwGG9YG+WINJ5RTBqJQsfHGNN5eKJ3/Ztsd3kiz4rX0PUxnDQZn8h2/MBrnwWPUlhGKoTCJdpgCzPlmpXqZxqDQyKBQD7Kq4HPEF7EfKWxGq/OG23QumpZZJa2agsCfIhLlzdSDgT4NfHwwc7D68EDb2XGJ7uswdMdsNwH1YbOFjdZ/UiXj+0PWFN+WeWteAdVm2Jfso5YDkkgOy0GXB1rXxK6RZatsZNPqUZPYomaNNut0JTUH4wk5DJrLQtHeOeH7aGZz4T2VPfJgzBdP/OBKVbcCjMDYEx8KWsuf/XQGTQjS0MzdXgOcR29QqTQFPhhv9hIbaYcgJFe+w+rk8CiKd21wnpjDV/e
 t2mDK6Se
 J7XOylGK19lCZWTITlV6w9IrHP7x2JIik4WB0fOwJZUFeDRAbHu2qqC02+XPOjMoaHH/WXWYCd1u/3lzS51i5IkWv2vnPK5KGe6NyuXm48k5+NcKuZ8f7Yw8EU3fEqx/2vwZdE5VIVQcIWleCS4RBe80FZzRDSMD1pKscy+9mow1T10sgRXez5AWcdi0eC37B/MolFbPxh59EWFyeKGJCSt0RDMwFCLwkw25LhJ9JX2F8UuylzeVl4oYC7A3hKW8JvdarMsHq5czyXOC2E+H2Tj9PkbpsnWgKswLUNfjXlusplUKcAAZJNWKyuggEKQkP/a7VQqp0ngPWjF9imSLCAru1XN3lPoWyx+eCf++U6BySr/7yeq9rEdV7EAlpX1pzY9KYUk8jtrlVnBM7e9lc2vh7jRcUa9o9o5mRp9v6Kb5mEhvqcpVeODBMc87IiZHaF6YCX2+tA6N2Ex1rpcE2DfZQSa7KWiUCGXkSOrEYldQp2mP4MURnX2L2lIL8dIE8O61IqhwNWojhALA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 10:47:24PM +0200, Jakov Novak wrote:
> Currently, khugepaged locks the khugepaged_mutex in two functions:
> start_stop_khugepaged and khugepaged_min_free_kbytes_update. Remove
> mutex_lock/mutex_unlock usage in these functions and replace it with the
> guard macro. This makes the code more readable (removing a goto statement)
> and makes it harder to introduce bugs in the future.
> No functional changes introduced.
> 
> Signed-off-by: Jakov Novak <jakovnovak30@gmail.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>

Hmm, did Andrew actually give this R-b tag out? I can't find it on-list. 

-- 
Pedro

