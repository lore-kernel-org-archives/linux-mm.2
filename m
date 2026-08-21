Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCD39C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 17:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5A5B6B0095; Fri, 21 Aug 2026 13:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A996B009B; Fri, 21 Aug 2026 13:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A21786B009D; Fri, 21 Aug 2026 13:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 805E06B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:35:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2D5C160187
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:35:40 +0000 (UTC)
X-FDA: 85125978840.23.B487D9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3AF5840006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:35:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J+zR447H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787333739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBbqTbFHv7pKzedTZH/lCiI+YYBR6Pv1KSsCDjZ+Z1o=;
	b=dP7X7WHJqneiPpvfINsOXUS452WZSJQqYqv5REzIVgzDa/WPwOp7T4V22oLExc7wLxLCce
	/uaL8dgpKU6mZuHWf1wM0Bcf/ZrpYOo+xyJUnoJH5Yl5s21IhYdu6QYxYd4rp3zJDsqzY6
	FSnviJzic+HJUyexdzvPkD9zMtJCjUo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J+zR447H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787333739;
	b=FRoQG0NeDBdqMzXE1W8sOGse/HbrWRIiZDUfhIqUxbWN6Sb0ggpsVJQoMtI3Fp2H95hbaq
	iQx6sDvJ8h/fBlEyofxrOcM4qCpMcG0FFLai7LsEe6eHe6QFm60dxl4s3yDB3TEIorqSyL
	ZzvgSJM5g0qHnkIGzXIsB05ES6F4Ki8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F676600E2;
	Fri, 21 Aug 2026 17:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E571F000E9;
	Fri, 21 Aug 2026 17:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787333738;
	bh=RBbqTbFHv7pKzedTZH/lCiI+YYBR6Pv1KSsCDjZ+Z1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+zR447HAPNgRWn956XNzQiWtBGUOJHpCmMFDBeIsOG4ma52Gd6H9PYcP6W7mBpt8
	 2bOdyf+ObO43Syg2TsJSMqMsM3SQN0uXxyL+wtx3yNJ0PLsBQecm/FJb+JIRK/vvSB
	 a8BKCzLis7wt/fBfAkh+nfIG+50UDFaI1abkIYOzXN7Cozs99yAmkffWutx0uu33zz
	 fENwASQJmaUMucMTo7VcOuxXVasS6C6NciOzVzjIgR/H6nTH8PyNfYM1F9lsvlsxdp
	 QLnmv6LTaLDZapeGNpA7MKVe/uQKS5/kgq6uQ8iqaOIYvyV4ll0EJ6I4/rNSivw9Mg
	 crvLqsTff10gg==
From: Kees Cook <kees@kernel.org>
To: Mahad Ibrahim <mahad.ibrahim.dev@gmail.com>
Cc: Kees Cook <kees@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lkdtm: use kmalloc() instead of __get_free_page
Date: Fri, 21 Aug 2026 10:35:34 -0700
Message-Id: <178733373230.2180937.14384871679243927060.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260722230246.2869-1-mahad.ibrahim.dev@gmail.com>
References: <20260722230246.2869-1-mahad.ibrahim.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ttgdetcsr5dczmqsi6bg8tmrmmqdk1wg
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3AF5840006
X-HE-Tag: 1787333739-153583
X-HE-Meta: U2FsdGVkX18xK8k7BUsoaxuBXNAX103KlOu9/8CMa7+LxXaDLj1lg2FUrzKBDWozjy5oLmfb59UqfdoMH7cWO+7p03p13iv52cruI6C/z6+Xmg+UG20k5GC5EVKTt22AYmlrjk1JFJdy4gkOCzyd306lEgVSRJHLX+dzoELRfayneWaE0dJGKZ0wH4Yigo2rYizJimpneKjsrGVqQblgOcFZgKvgp8mpR798q8FRzPerlyYOnHru/zptpbiNxZnrqXlQYwXMH2bDSKA//TykmnA7XTGJ06mZqFg6qq/aezHe39i1ebbr8ScvwMzjEsddSPzxgFfTxpX047OKeyacoSpGzWEhZOZ8ON40f1q7VeZ4f+0Y6j5VMIXTFwBa6numvYpSEkXt8IABiCwS40/BESKUy7k4i6JYqeVSiGX7eVdxbEF5V7yj9peO5WwFz0nKGS1sviocJU6epEUGfy5feWbeqYcMugtjsF/kHje2pYJ2X5LL5AWx8F1FORqPjwH1U0HyChyvOR9n2DmxR8OfllcvSvXBCDhPW5DDZzH24wYXt4Wz/3ZS6aRZkSrqpXlZlCyFfQBeppwOopCMOD3tPZoU+pn3EhCao0vQ/0KGOTpiiFHBCDsbJiN2c8k1Oaki2PFakLZBBNNCVlk57wUek883Bv6uQIB8wv8SwU/aFr5cybJatrjZc/EwGqmOwzvGVGBG198cZmlJClMfxc9k+zlAfAovX89tzePQlrVrVb8AAyNitNFAzzRig6SAHBIhHx06E9LLFfXPTqTM5ebewyWqr6Rwo+nhn9TNsgIp7f4s7nlypFiyesqil4yQSA3JnM1Dw4m9wGZYSkRHjo2zXMCiyCyA3zUqAGbjSO9RClfYV0TRFxYhzAQ8ZrxxVEQYrrU0DEOx9agq11r9UHxkJEIjnlydFuUjzage5jb9NsAypOvMya63pJKraWukDyqPPMB3SnzpHFatneHrnmg
 9hBhbz1M
 8UORQtHZqy9mayLTgSyjiNRpC+EKVEkTzbuqFwdRqz9DMV3HBLqGRujjBdfxo0bv7tpkZKCaaVLc6rcBL60rCWeLlwfGHw/BWfNSXI9i2CoZiQ1D79RvykDI4/dOyK4G9C/y68Z+8EO7RKDSiNrrED8cqnPusMJdzFMWY6FRjQM4mmEN0H0Jwx9R+hRdQivlYF8sAwOdHxbA8j2E+vuP7feDlNDCQw/8ZAAlAr+9auc8mHeCaaju2FhJdBz8e1UKoIarTuA+dLgFDomsGUn2/E4lkqAE8Ix6qf+HHp3Qsx0B+yJ5uZL/iG1SMa+8GXfGaGwfl5kAM4c39GIZ8wyzYqjr3BP4JbL18GDFhiFk5pJbrxmwd4aJBVlbial1LtM5IwzdJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026 23:02:46 +0000, Mahad Ibrahim wrote:
> lkdtm_debugfs_entry and direct_entry use __get_free_page to allocate a
> temporary buffer, perform copy_from_user to get the crashtype name,
> strim() to strip whitespace and find_crashtype to find the corresponding
> crashtype that is being requested.
> 
> The lkdtm_debugfs_read uses __get_free_page to allocate a temporary
> buffer to store all the available crashtypes, and then copy it to
> userspace.
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] lkdtm: use kmalloc() instead of __get_free_page
      https://git.kernel.org/kees/c/c7ca1fa293ad

Take care,

-- 
Kees Cook


