Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3273CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 22:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14DA48E011A; Fri, 24 Oct 2025 18:38:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 125898E0112; Fri, 24 Oct 2025 18:38:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 063248E011A; Fri, 24 Oct 2025 18:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E888F8E0112
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 18:38:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA754160FB2
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 22:38:42 +0000 (UTC)
X-FDA: 84034473684.24.6593EF6
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2843320008
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 22:38:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Lo5bTlqP;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf03.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761345521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cjiWvHOz96eVWBeUiSoBAexp8LAy46Vszw62SUjwR/U=;
	b=Mk/nSh4TJ5kExntH6pwpKcyyzV+o1RBlBceGoRcsXcwUVzaDz+wbh14T3lB8I1EQiFvW1m
	PQk1A/Az3EN8aj6731856BxNOzsN9LRGE2HnJoBiNgpXjG3NsuuwCWXPoR0+3prNOXGcHo
	s4fEq5OtBJEm2+fN3jyZJ51YYgiKhPs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761345521; a=rsa-sha256;
	cv=none;
	b=l0g1buW7hP6ExA8Vhh/PWfOn2HF8vjc9H/vTWfRJWYonIkFJGJqbVs8gwdfSTIBj5Lept/
	B8FG7TouEukJtXB7V1jL6dJZnF8DR5kdzfMgBcbziAZ2+5xpBsZfj7BCmO+ShsYPcnParT
	inAvvpJ+A8nb+Tgo6i/67pgszZr1uf4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Lo5bTlqP;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf03.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 088FB40E0200;
	Fri, 24 Oct 2025 22:38:36 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id cOwGoV0MZ8VE; Fri, 24 Oct 2025 22:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1761345508; bh=cjiWvHOz96eVWBeUiSoBAexp8LAy46Vszw62SUjwR/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lo5bTlqPQSXK3Lal9wLXwg3wRc8QxEUY7IUksdU6pYq6zD5sD+hZNAiktj9sFFuTw
	 rjF/o5+O04RUvyx7EpuGIxz7HoWFjNkaijoc+A1i1+/0aO4tBaggAjxWHXRnInfAeq
	 Zhg0r7133XfBadt49MbzCHHXBVXFyXeTIs8ffusMvHCLcg7hX7RpplLJwQVY2loYqZ
	 SRF6kJZRl0nmZ1xF6JmuDKPz/aD7NmTnmP54tg/gZfzriHkTiNRwgtfiRucMGk3T6s
	 p7Ahf27EptzvoMsOvg9HKPDV1YcDcpHLBnfsDzzJ2F+R7T30gl2YJvadeTAGINkhNO
	 mBuAn4s45rpC+GcgBQz++v6nL6PUSJCxGwAfWkZQ4Yu7R5mXQvnUlMAOLTDPAfIFz3
	 2aFHdIXRxS4UuRaR3HumwpXXVwHw0AZsOPwbRN8hfTln9BC/JkgL4NQQ7Bw2PJ5E9i
	 TVx5zO5ejfU/xY6WF2pHKe6rQ7xmS/bQalBGwCJ1XxJWRvMAxdNkuqQgFOIDp33naN
	 0eVfB0nBNHmwHwFfo4poFGkS8wVW3B6IlyK1wHaMBUGhcD0xpopnG3un0elZKbSyLX
	 /Mp/MHLoxyhx9a4mX8b7tF1oVS1ti+Zk1ISMS+3zwulMWv0SOS/o3/47YtGB9aSjmU
	 Q8ZQYzozoLOTwILXQ5M7cS1k=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 4EEF440E019B;
	Fri, 24 Oct 2025 22:38:01 +0000 (UTC)
Date: Sat, 25 Oct 2025 00:37:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andy Lutomirski <luto@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, peterz@infradead.org,
	dave.hansen@linux.intel.com, mingo@redhat.com, tglx@linutronix.de,
	akpm@linux-foundation.org, david@redhat.com, derkling@google.com,
	junaids@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, reijiw@google.com, rientjes@google.com,
	rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
	yosry.ahmed@linux.dev
Subject: Re: [PATCH 01/21] x86/mm/asi: Add
 CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
Message-ID: <20251024223746.GTaPv_uiyc0wd1fPjV@fat_crate.local>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-1-2d861768041f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250924-b4-asi-page-alloc-v1-1-2d861768041f@google.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: k6j5bwwx3cq17o4o64uhorphgfhtjw6o
X-Rspam-User: 
X-Rspamd-Queue-Id: 2843320008
X-HE-Tag: 1761345519-324244
X-HE-Meta: U2FsdGVkX1+cwDm8boJNikX9Av7bUIEVLDhArsP0OaQYcPfRlkFagWSmqzEjGrilUvgwJKSexb0/tW69SE+VSZ0MzY02PfHrOyhz3j1jvXnBCechyJYmLezwcCd1gOpKnGjL2h3m09pDrFzpf2X8ahLUDx4g6mPUiGheow31DnZksTKOyisRaCjPdsxQTtDdCoULh8UI6uBdZ0qx+q58EbTYusU2mI6mZgiEJlrj2XD+4wZ+kqxrdK7YhCj8N367w/N8Dy7wGnQu0vuOk7ttoqIkEAAK6+Pg99pyHnBlXz5EOhiD/szE9xQXDhm5WdD8epnjuA5ghJsbqqpHxy4Yh49GPPeunRz8BSnLFE0ihZ6aXN+wUT/PlZBk96rz7onrAoSXMwRutHnCyDjronu2H+d6S37A+pFmd1PoxZUQyTmrkQdanR2Gkx1ADeOaigje1LmoE0MpH1637ohqPsD07WtBtq2RAV3rvlTjpoVsY+yB9kw5pfXfBk0qMnZDsk3pVB226VdQGS980ye+Q9K/sVT+7yIqwoO7fcjtBV/RzkZuhKjwrrYDbC7NrzAlCEDxjw2Zwxh2EC0EZmkwXqWmIeuqz/faXhnKUurrGnoFmiUpH2FcgkRrMoCLluwtKUr2ea6GFelR2ako2DKgIsSoP+4Ez93+b7COBzeX7JLGJjm+VHNcOqTxDD9HociPILvsleAJ8cfqiUX2z3N1ofMBriufeVT76PgPly2KOtL+dpe+X5111MK7AY1exKi706QkKgkta4j5jHWdrR1J8xhh9Nht4tw+CMPaOxDO51zCfj8QBUUc1OvGnCXOXqiME5GGQRWHXMJO8VAA9I0KH+piVpTUTkCdBZTakh0mWp6lDScVOys16b+2kR6A98dyBRrXHLJTU+qZ5LxRFs7IMtxs9RFp6Orf5A4c1fMCbrRElBuF/XMa5a3jRSKl6W+TaH6wd6Dep5sDziSiiumHOjB
 vY6bzJvR
 JjKdYvGUgRkQV+f6+MfB8rLLV6aDDcCMD+ljuWY9812nK6seM5O32cZoQXHdus5Aj5/BGKbUwqPSWEX5N54mB1YIjzp5lBE+a7tfSzePmih5m4IcGENM2eXWuCPnzM9BfYB4kA9wEteukV9oKitEv3hilZe8ugVUIPni6CnspTg3AaYz1UH6iU5EtnNDba+ll/sMd/wVg0126lygiQMaZnCyXAUqQbiUI1Zamj/pzWLe7/QwFvIHBZiGeKirPG780amdf7qTuG1SasZYF+3C/4Skn1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 02:59:36PM +0000, Brendan Jackman wrote:
> This long awkward name is for consistency with
> CONFIG_MITIGATION_PAGE_TABLE_ISOLATION.

But why?

I bet you someone will get confused and mean
CONFIG_MITIGATION_PAGE_TABLE_ISOLATION when she means
CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION or vice versa due to the
conglomerate of similar words.

Now compare that to CONFIG_ASI! Wonderfully short and clear.

Especially when the namespace already is "asi_" ...

The only problem with ASI is it doesn't tell you what it is but you can look
it up with simple grepping...

I'd say.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

