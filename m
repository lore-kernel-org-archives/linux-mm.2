Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFE0CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 11:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13F628E0008; Wed, 20 Aug 2025 07:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F0818E0003; Wed, 20 Aug 2025 07:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006428E0008; Wed, 20 Aug 2025 07:02:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E31108E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 07:02:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8251B1388E5
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:02:40 +0000 (UTC)
X-FDA: 83796847680.12.0F835A2
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf12.hostedemail.com (Postfix) with ESMTP id E9F704001D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:02:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf12.hostedemail.com: domain of cmarinas@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755687759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LfBffobDpm6imAqV0LRbfY8+b7VM5PvIpxzRQcPayvo=;
	b=D7Zxzlfp6paNECfl1O5J5HXD8bDekIUGhaWRr6dVlk4E1A8XZh3FmzTz5PLDo8YICk2rt5
	MZWqCOhXgWF0sKoI8vBdlJ2YgBJH6OIu4aLO9ttrLlxedc4rNIX1XJOYObdw9y91NTbmz/
	yw7Oq1zotExpKNmZCqziZZi2Gsvy95c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf12.hostedemail.com: domain of cmarinas@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755687759; a=rsa-sha256;
	cv=none;
	b=JTRz4wHFBv5M1GYtBU7Gdic5LWi/gMyuYqwvAwkiQEgj8hOYaEIPnwpV/IH7nWJzjVAMiJ
	aa0WoHe52JLb2b8GsRgZB49FnTzKgUadJe5zNC6LUx79ja4d7RIXQtTphmeK5jscxO5a0O
	xnQGUO4q4vGfaXpgrjRL+HY998G2CDc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id EF5BD5C5A8B;
	Wed, 20 Aug 2025 11:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAFFC4CEEB;
	Wed, 20 Aug 2025 11:02:35 +0000 (UTC)
Date: Wed, 20 Aug 2025 12:02:33 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Waiman Long <llong@redhat.com>
Cc: Gu Bowen <gubowen5@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, linux-mm@kvack.org,
	Breno Leitao <leitao@debian.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lu Jialin <lujialin4@huawei.com>
Subject: Re: [PATCH v4] mm: Fix possible deadlock in kmemleak
Message-ID: <aKWrSfLD5f1r5rg_@arm.com>
References: <20250818090945.1003644-1-gubowen5@huawei.com>
 <113a8332-b35c-4d00-b8b1-21c07d133f1f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <113a8332-b35c-4d00-b8b1-21c07d133f1f@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E9F704001D
X-Stat-Signature: 1479mphyx5m955b76trcytemfpdms56a
X-Rspam-User: 
X-HE-Tag: 1755687758-872240
X-HE-Meta: U2FsdGVkX19cN1hgD3MiK5PDCkYbpMGSXQexjgtYjnxo7YbPfjm+Y537YndRWcNA0A2zYVdq9689Gcw9Yb+ULoF2tGgd1IKcvvxnN8RrTfsTZm4oSl3oOnPrj3MTSXNb8s7BUoZqmPs53WD92CvZXvZ9M68qENHV8Qee9xsmwg3bfgmTw3QYmTW65c2NUBTZxpWW1maNOTaIHmNwFe3Bl5O4mvFaf1QSuXLpOQYWUhAqAPWMSplRsrF7/FwO1BOqizkcOd7BUgbap0EZqJAf8DL15NnnODpyU0KYNNhWstUEptYcmcisclPhRAJwMpI1CN6mqFTaS0s2MjukbiyuLAzEcmvP7sTUXjvjAqrS1lGF8qW5C4oGOhIjc70gmOB7ViLUfk26zCKYiQBbakj+BGsZJicLm9TKi0jRa7er50CXpGW56RW/wJMoYJB56Xe3mSoX4M8/HRxyJs+Z/VigEmHHrLtMBqo5/JW59ZemVahV1iz6Z27ExMY67xz3jDIuIaGsSFCWwWqd2s2tTyx9hX9YRL8IKDGSraBcPuIvlt9ynFioLthZ2YK/AEPM3uQAVhZS5Mtv9IPTxIh5j7EVJh2k/R9yT0/0Pe7RSAKbkfoV6PKESnnmUy9bJ/BIFPHOyiSIUCbKq03+tDobF56Q6cuJ6YIeawxnU/o4tlE2F31H8A9pss2KdmA5BAc5uPBOl3yAxbG3c9X+0RTKDyUKNRJIss0B1EEal+tr7vGGhz2ZObFtElY5+MLQYllppatkBrEJ0CtbhMcFH3tMZu4Obm1WOJdPu+Uuu/At3PBN9AOLY94OsAposm+EPivXARCNC+W91Zz6NyHOkrEiU3r2qaMXikpCllBWj0K9cZPOgmeEdJRKnf+QNbunHsg0AUohaq2dC0BQSf7HiRrarlvPv5CIyKjDbCJ0fJaA1RMzZrklf0e8YiyCSXFBGel3rsR/zyiaIKQhK69SxZIbFkE
 +FMooKeX
 fbmN1LC0vWJE9Dsdk/LeWxTlVKav19LCpLJTQ7pTvgJaJalWVeXjBUNzZIqL4cZKawzy8s8FdOoWncFyx493iIfirJnCVQyOsAJojgFBmcMB9p6e049hmJl2RcykU3Lj6B7WFqAxXojo39emht6jTUcMgI/JL+oTE1QyGybmwyiR7USrAIclX8qxTLEsP5qQK8sr0e2l/ubmCeZ/UGiXwydS0LceoYG15xZJUgz5Iz6rlacv6tVT8+f66X9nGWUdxJMTXXx9ulVZFkg2VRUfaxdcPsykuH0pwt5UyUiz0ruYpaIANjEKEAiXA0Gq48aW4dXE1kPq1HIQ5vewVpJEvOIQhjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 11:27:23PM -0400, Waiman Long wrote:
> On 8/18/25 5:09 AM, Gu Bowen wrote:
> > @@ -858,8 +870,14 @@ static void delete_object_part(unsigned long ptr, size_t size,
> >   	object = __find_and_remove_object(ptr, 1, objflags);
> >   	if (!object) {
> >   #ifdef DEBUG
> > +		/*
> > +		 * Printk deferring due to the kmemleak_lock held.
> > +		 * This is done to avoid deadlock.
> > +		 */
> > +		printk_deferred_enter();
> >   		kmemleak_warn("Partially freeing unknown object at 0x%08lx (size %zu)\n",
> >   			      ptr, size);
> > +		printk_deferred_exit();
> >   #endif
> 
> This particular warning message can be moved after unlock by adding a
> warning flag. Locking is done outside of the other two helper functions
> above, so it is easier to use printk_deferred_enter/exit() for those.

I thought about this as well but the above is under an #ifdef DEBUG so
we end up adding more lines on the unlock path (not sure which one looks
better; I'd say the above, marginally).

Another option would be to remove the #ifdef and try to identify the
call sites that trigger the warning. Last time I checked (many years
ago) they were fairly benign and decided to hide them before an #ifdef.

-- 
Catalin

