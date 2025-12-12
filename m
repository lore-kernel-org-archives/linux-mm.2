Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A459D43369
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 05:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F4B56B0005; Fri, 12 Dec 2025 00:08:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A57B6B0006; Fri, 12 Dec 2025 00:08:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BB1C6B0007; Fri, 12 Dec 2025 00:08:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8836B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 00:08:51 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 96B7B601FF
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:02:01 +0000 (UTC)
X-FDA: 84209622042.23.107F208
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id B415EA0010
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:01:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="Jn/oyTQp";
	spf=none (imf25.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765515720;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ovb8csmcXCyUzvPPL/s5rZjS0U6avn9QuytjWB/Yh1I=;
	b=3V9zhlrEUL/tyWpdB8+/70iwOAlAXLamqx27hxzaQxCom738uk+5z7XYqFxSRAnf8jFIRa
	yE9H4/LRCWYEtzt8wbm95xtWRQdnRLABqz88LvhzE8uO6J4hzAwZGo/8ED2w3AyWp/tb8/
	UNWjBbrG+BH2KIhNiXzK3b+hGUapEz0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="Jn/oyTQp";
	spf=none (imf25.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765515720; a=rsa-sha256;
	cv=none;
	b=kLuavU/4WhV68/KZ2uAXqaP16l+yQC643c27wRFoc+oR3hb4p5vRVruLHZcwKY9l4lJ1st
	QPlbBW2HOofeSve8dXsGNeXPmK4638gstrhNtA8VHOEfc4kn4FdiLQWiqFYQq2MuLcBsgj
	PKJMgyYDhMOQFmBvZuK7Sr6T1r0fYtA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ovb8csmcXCyUzvPPL/s5rZjS0U6avn9QuytjWB/Yh1I=; b=Jn/oyTQpLShNLcDQ6f6TaTWNtC
	di/EaBklgDBoDZRfOlDcJ8byPFubhakbpoCES85WmuQDG9pNVloED+HpK5gtCijVFnuX8HXrtpIZU
	tEE4QEZXt+ESzboR1cvMVPJ+Zr8uP+91qOx6Wsq/bWeLHavMjALbdi80gtf3347MsQdlU+S1UgDnt
	EuzHQ4IM8Q7pUxz5hzv0smDZZ8HS5GFkMW4HN9b+NXFU/Prl1CmNVcCpg2SEL5lhn3O1MW+DwnBkI
	fW1C379ZPtXKdtcRQA7Iinu+5NrFwjDxcDShVPo2j7X73p1EB1HemuJVvwdjFN4BsoP9pPaerT7Fc
	l1VoO14Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vTvIP-0000000AkHR-47w8;
	Fri, 12 Dec 2025 05:02:26 +0000
Date: Fri, 12 Dec 2025 05:02:25 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: 6.19 tmpfs __d_lookup() lockup
Message-ID: <20251212050225.GD1712166@ZenIV>
References: <47e9d03c-7a50-2c7d-247d-36f95a5329ed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47e9d03c-7a50-2c7d-247d-36f95a5329ed@google.com>
X-Stat-Signature: 6yzmgyoe4uqykqaj5mybuqdd4ws7nqes
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B415EA0010
X-HE-Tag: 1765515719-157322
X-HE-Meta: U2FsdGVkX1/6KEp96F9dc42GiW3lkF5Cu+LDCs8/vO7TfORUYDBTJ1Lrlc1MXlhusZNu0OD2bxRDGkwDnYt1INTKhsGimmjwZYh4cgwSwH+i3TieI6Xo4NLDbCxmHTTVN6QzvCAhx5eFJwLEXOJWPxynfzBbVH6DRuuckV2vbJa0hU9ApGstN7kGM7BtvyAOQhnkqFq32OSpSE7j7h7QusBZSLuCs6waUNHFvY6EPMNa8Y5q3kv4V0F6tD9kqMgZ8MeIAbzlKL0bZwjpLzfl4orKWPLByTVXgleF6HoexK2FbT3bVPfiJrWjKA+dfqOVvo4tVQTRUOWkwrlpldzWbjFNKPJ738kyLoEDm8al+iS76qfGdT0ajKIINuIdo3fC8Vzho++dtmSk9EkMQQP2MlufFd9Hr0WVMIfyV8tqEReo3z7SlefrWzS2fnBc2UDx/4P94mgOhJx5HOnK8Ql0z+XTbMzwfx5tkH2o2O6i7XTcw6YEbo+SThAavqAw5139IGLwRmcuQ+i69lyeFqyJoy44U16Sqps7D3Tl4MvKauDFNOBU1RUqabAZO0vib2SX5aB6nEDWGonw1JVaJgxtPL87zx5FGg4MPsTc0sXftKL0j5lN6BceIHQh5HIQQxZshP7a+XngLBUjEHlv5FZlFajE7B/tRejUguqBdJt4qOda1gBH9cVQ4DOQC5KgY0Y2vbl/CgN3iQ7pBikRqLC0zRjDBsOoFPHDX69RvzoE6zlPHvAPCg0HrOZL/Du6tsuiWSHV0MeMd2qJujo5vwdqCi/1pOFPiqFtqX8bXuyuswqPYFEGwDeHX+k8GDrAdbj9onsQHlptialndTNcVhLBhmJV5KNYYh3vZ6OxGKCME5Y4a59rSMcDLzCOC4W8Pb+g6CLcZMwL6SuGUGY12Ggr9OeNHvMSqK2xuqQZzbJoN12HzskAvu4eBf9GcMZEn6sWtGBvjdFz8p9GZKmgITz
 zhJ6hcGN
 bWzYZ8uB26gPKofM6O6jbbUkYQy/50gK6KzFTeuQZ/Dx18RHtHO0o3R2QqbaqsDfsHJpGjhPcly0vw6jaLiQMolQoQ8PPd1HRpmeYND+1ulT2HuWRhj3mG45FXSKHFHNeXKz/ponEqcMKcsXsZSDZ5dznHaqJrJga8uuLHkgGanLpnwOT01LaGwEHWLc1KViCdLPbDG3pHk8pRxesMjGZeq9rS3xChi9n8jvkG9f1GS2gP1gEuOkC6Mg2Lo9rndUTD2npcebAmQaPryXJUvD8GlWZeSYm8EAy5BIcQrPZdNpDXMbYL2zjC3reFbk2bIOTBezsgWBJUInMJwcQaPTt4LgfewIAESw/w5Ox9eqXmAIlqtWTb1fqDgBD0zSefVvNMyLg/lAoGUIQ+Uiy7G8ZDBp2cRsaCTaoanXOuKwTysVFqmePVzNVQ0VcSEU1C05hZkOclOJHYQ3jwhHEtF3jO+SIHc9atFqpnhuxP3Vpr6+s3eE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 07:56:38PM -0800, Hugh Dickins wrote:

> Of course, 2313598222f9 ("convert ramfs and tmpfs") (of Feb 26 2024!)
> comes out as the first failing commit, no surprise there.
> 
> I did try inserting a BUG_ON(node == node->next) on line 2438 of
> fs/dcache.c, just after __d_lookup's hlist_bl_for_each_entry_rcu(),
> and that BUG was immediately hit (but, for all I know, perhaps that's
> an unreliable asserition, perhaps it's acceptable for a race to result
> in a momentary node == node->next there).

Hmm...  Could you check if we are somehow hitting d_in_lookup(dentry)
in d_make_persistent()?

