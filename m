Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C67B4D59F7E
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 09:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33A206B0007; Sat, 13 Dec 2025 04:11:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 275346B0008; Sat, 13 Dec 2025 04:11:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E156B000A; Sat, 13 Dec 2025 04:11:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 048D26B0007
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 04:11:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5214135924
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 09:11:15 +0000 (UTC)
X-FDA: 84213878910.23.4D98F5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 01ABA140006
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 09:11:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pHnRcyyc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765617074; a=rsa-sha256;
	cv=none;
	b=MAVQHiDN2j+mr0hgVS3Wcz4xwfPgMrJsEKUIpM/E/uRX7YMpLKlJV4/HP9dn3FVR6IsFd+
	9DL4aF6N9fGRxqAbzeiNvON2OsQFs1uvZ5CtxfKkfyP0DAb4wx0ldGtdmNSsqCc5c1YK4u
	9pGuo83d8AAyMsfKBVvliKCSHFtm+eU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pHnRcyyc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765617074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=lVGQYCvNJxyGMbbvutGBIeS3mCdwtfQz0tNWYATLTJ0=;
	b=PAk3umWuija1wXVQgk6BCtwkaizh2C2qs2hY2IvEcmcXLBlq/qVF3CnxH+V69hmH9esu6y
	D6G4III0l10N7Un0pNxNxTQupbzR/tM+suYDke8EQ9KtkHYhm0y6FGAjSHiDCUNh4836AZ
	eTjOUMifnE2P4x4gUljdJw8o0lH5vnE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F72B601A1;
	Sat, 13 Dec 2025 09:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34888C4CEF7;
	Sat, 13 Dec 2025 09:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765617073;
	bh=n8v7mjktx34ZyZNyQCtUPWSe1lEJnUWvpFY8sC7hqmY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=pHnRcyycwk+bmPNuxRFgQMgvOEpNjdeswfjhTHW3QUc7gMijnU8mZZ0kCpj7O/ZUk
	 MMLuMtxRHdWQXjKrakJYCOUHO2B1XdBPf69yTTJIr4d79Az9dk6FGHYYQleeN8FTL3
	 1Lk+foC9JWi0o93KYO+LQMPO6bf0IBPOijcbC554zlOMtF4AeHIlq4ncv7oo9zBdFD
	 OwxqeBweIyIfdTXtJfDSwF6oKruhXjKUtN/zWkjLImJC8nz8wKtKCGmqOY8rExno/G
	 UmnxS7i8gvBOchWeHpO//jjdoLmEFMcS5tJNsIAZ6WEDc+cv/+EyqPYAn9UDSabfSe
	 KiLo61fKaCdeA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3B81D380A956;
	Sat, 13 Dec 2025 09:08:07 +0000 (UTC)
Subject: Re: [GIT PULL] additional non-MM updates for 6.19-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251211131145.512b1694cf5f46d959cfef76@linux-foundation.org>
References: <20251211131145.512b1694cf5f46d959cfef76@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251211131145.512b1694cf5f46d959cfef76@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-12-11-11-47
X-PR-Tracked-Commit-Id: 601cc399a01049efa76be8f496541315dc9cf914
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9d9c1cfec01cdbf24bd9322ed555713a20422115
Message-Id: <176561688573.2460530.13988646072896057380.pr-tracker-bot@kernel.org>
Date: Sat, 13 Dec 2025 09:08:05 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Queue-Id: 01ABA140006
X-Stat-Signature: ntaebeenibxysmn6uayu51hkwjknct6p
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765617073-163812
X-HE-Meta: U2FsdGVkX1/Th2UNhcf62H8DKfW0mNArfTnxwhoSi+ScO+aUrmFeNoup9q1c7WmFp+3kPJ110Itv4VEplYvxGY3JkH5baR0tmV4D8ANOgtuWrd82H4wlB9eoNZAXRWjG+qTVysG7E2eYHtU+CqOEVFa0sMPGWwgdGUDuBuqutrjChE0uMZbfUkCmFBTVcQbpha4VoI1px+/30s37I5YGGKVoqlK+nZEQ7cJop7H0RFXLs7bZ5WYvk6FF7cQhYl6mnGYU+VJGW2uC9be7nAuHpW7K+dLjw6VeEsP0oYpgiKYiTF2WS2LnLq8yZvUJ9tSZeHkhdPPPOW2+G91TVklEaCcalg51W0DRHsb9gdSXBqR2p/5voJ8oUZCnVcJyXimqVcR0amxy1mIP+IVtknuLdpFR2L/WYIorFPyzQhFDNUfll210k9+SXO/xjKuYAkqEIBgm1bE7Y+0+wSMlly0xvsA9/DjziSYT1K9wymbsbePUGMSP5Irc3ZheYxzFQs5ggbN8xcI56mOcs+SVP4a8YdqZUtFM4OeKgioYXM/488POh7FKNxSvgk5avKh1K6pNNyf15SvhGFhNkUVyeapDSaByqvVKcay4HEiADYiQxegvmqmEe9ZqfmO2Vt635qrnbAGs7oFnysua2bErpl0a3PqRAcb5+P87Dz9/NUSlcC+TBC0/fxFx7oWJDcUPYfZ+uDlkkGmttkieFf26ag0bRuI3/o164S0y0DPgWrQK6IT8bcO9cY/+i5EsYN35g2GLiXC9iYzUtKA+ynDFQCHyF2OYTKWjiNJNkD3ctfUd93p8nJFJC3M6smt4cdN280Ij1IiZIAOnKpVzvZ51+XgBRJqwEJozhRHarxBtwBufzsK3AH94S/mOjnnbEfDCKlaHmzisPtExcsGcIEWA3h4u01tcD68Gk4NL8KMrabdKahb28yFGTgH0wnhKygaCHf42VmZDDQJ73XYbgy0OLrQ
 AKH8Ihck
 nKW3/bpfPvwxZZzY9rWzo1BELj44ThggD+aOF7NokNgM/YzrTTlorEIAvnt2npNmkWtwJM6KzJ9KIK8si2oM+ykQC3GIBymdNZ+GEdyyxiuXRuTjrinYcK9eqKlpTc6MzLfkC8MzqBEu+r+eJfvg/C2xFc4BF2BdV0pnTkOXsAfdN9HLBFOqJtE0raTgMQ5JnkH+lXnT92PYhgR33NEC0L9dX/NyhEIhAD/ezZMfCZuq0rTIle1Q8jeZYD8dmsqBZkYdluGus4edDFDyc/3AAcyZPKl2MLsfuNRqUWQ9aFmhUVWtr2NavIdAqA+WubP3MrsIScbNY3jWvvOpEdFP8SNshzP2i/Gk4ZoKj/K6hd7MDUOqDoHoEEj37iWkBu+6wIFdB97lqwUUWAx0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 11 Dec 2025 13:11:45 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-12-11-11-47

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9d9c1cfec01cdbf24bd9322ed555713a20422115

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

