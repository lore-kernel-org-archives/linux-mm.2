Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15E07E9A03A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 19:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8A586B0088; Tue, 17 Feb 2026 14:58:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A170D6B0089; Tue, 17 Feb 2026 14:58:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940306B008A; Tue, 17 Feb 2026 14:58:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2986B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 14:58:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3EA801B4411
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 19:58:44 +0000 (UTC)
X-FDA: 84455011368.16.7E37154
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id 18CDD40009
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 19:58:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=aHeJwDhw;
	spf=pass (imf01.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771358322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=p1Z5OGRnctxXxv8c/Nb45yXoo2HLodfSskKuVvvpxq4=;
	b=GQ1V4UMy8vgQsijtpeXQ4zkVGQTjhdjNojpgNj4hF3OoQz3dRYxzLU8uxbtvfuHhM0w5B4
	KL6gvH3qv1rLUAOLv0OInNRrtSAo3uivkTpWj53GFMQduUs7VOnAoqxklBx8LKdoEGXGOr
	Y6pv0oCSwujP2bBkLdV/hhKbPisKAFY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771358322; a=rsa-sha256;
	cv=none;
	b=RyjDVKIP1440Hkm29Gf7nwQjFKs1vGEfBhXWsvE+LacYhslkBHNe3z4Edgyq9APat2iPKI
	PC189SNXitymyx3CfgaCQku12/TspPJ3P/Z4bq1EkKfnPi520JOOe6zT1+GIil4EssqzOl
	mE0IMmd5fv8p5jVanjgxTDstvkqtF/o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=aHeJwDhw;
	spf=pass (imf01.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=p1Z5OGRnctxXxv8c/Nb45yXoo2HLodfSskKuVvvpxq4=; b=aHeJwDhwo7N45R50h0WR4bnT/F
	jhHaCdY6VZy5syzvhL3Lehk78qxcRd7bZwXXYX+M6fTPTOnzgDdkPjslI54+1rK5klnxsNsk19NBq
	k7TfZ03xbGTziNur3G8QjkEnyCHD0X2DYcom3HMjZAROxBOdAwI7OXMRxjNFFFdp8D9wGpKPBwD4g
	nyopXHts0EjPXYBYrEzZjD6DGVUTNwNFUyqhlCz3k08r4uIbUYQo1EsWdV7sWbXuEI85DAIGGR9Di
	yThngb0TPVOd0B/lHzbDnv7YjqIp+EAQomvjgTGKQwR7j6zOr4O+VPmB4BGyl6WJOPK/dxlIKiZMe
	nxqHBTiQ==;
Received: from [177.45.213.208] (helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vsRDQ-001nL3-IG; Tue, 17 Feb 2026 20:58:36 +0100
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	kernel@gpiccoli.net,
	gpiccoli@igalia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/2] Some small improvements to reserve_mem
Date: Tue, 17 Feb 2026 16:45:05 -0300
Message-ID: <20260217195816.861684-1-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: 1b8yjju6y7w8u5g18okucf47ifceszhb
X-Rspamd-Queue-Id: 18CDD40009
X-Rspam-User: 
X-HE-Tag: 1771358320-654187
X-HE-Meta: U2FsdGVkX1/hpnWp7gm6OgCaDtFITuL5LVkkG003+T6ozRoxbiv/isVFSIaM9RB0KygaslwYAsu304YFW34tdTj0NFqkZ4oSYrwfx23nmG3YnTuJakEd1bU7BSyW2ELncmWX7EUVJOg+5svbnIeNcbZqY0oK1jC8pSZQSu16PD2tvQPzNP59J6PGsJPcOLbr1ALYrP4KEKfyc8R48IVplZUO8ppqAE2mtuTo/be/jvWqYTBpGN8ClV39rbMPOE/9KjSTt+8590weGcD4divW98On9yJFrqHi/i+hbvqi5tUx7xhnlCbIv3ZPfUUx/HtOLhPuXQFhotkLrJCcLkbJyVdlq3t4RGPVbDAV/F6FqQI8+bOsMlge+dkVMG2Cs0d566jql544bd+sLvO35laBul9nvTi5RPB8O7/mcjzD26VwEIyNSU+YivokuUzBLRys1RbtrqLZfSR+sQxCxuGLGDHS1Mbju9fYZCk1DoJYy1rUD6kASc0d7qmFOHDQPH6qwKAji5yh2U6nQ8+XA/OjdIK22+z4CSEEs3uHM0hnoOWT+5RP+hRjic8AEyHzqFgtYWjENnFfyQHnl9H8GYxdWTZOl3Pp26CH825dXDpLMO6nSyvTHimcG0zsa93bdPphGE/a9/KxDAXMZtFmoLkn9B7z2xuHq2ToJA2mKFKqyN0NcV6Ol8nSpPvVmzBuxqMDHTvFcXk7zLSlmpJNARehb/reKIrSbK/yNQz9yijpBQT5Y8PTXbqQ2tC8GFWw8zbEXKX+CYLUCDaZpatWizrv+NoRN0kNC9iCgXqqnkgcpC/mVC2WUxVPVAkjKtS34nv/0nPelkWxdbURkYMaKmuJgpS0Snelc+GXEFqLQ85rWssWmvJfJdV1PMu2vsMwN6O4ZFt961W0Xnw3nSbRRW/gUZA03NR51rrwAQHQXsj3KduCYUfw2Vv9eLe0p8CW9I/wZFlfVUabWYnAiFFc9WE
 qJdzaesn
 rL/V04bJrjQ86D0kPXwDFneUogayw1nXWoQ6NqTo2aYNZ25wGiTJwK7Bzi1fgi9Ml2fH54VFLO0v7YjekfouU33Tn7SA3n+Rno/rZU04XjeX1KYa/M3pMACfKgu2vZ3TgKvZ5n3D6HDroFO4IBLyq3K5QbBP+2BgE7GP9R1gvC65Wler54OlxckoNkU5uhc9nT4812GraWS/9O1YkHJjvY7YZFz0Pcl6yW2C9yS5K8o3iegiFwMfoWGqZyKkVLb+6k0lw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently the "reserve_mem" parsing is lacking information both
if it works or not. It can fail in many ways, so I'm adding some
messages to help users determine failure.

At the same time, if it succeeds, the only place I can "see" it
is in the accounting of reserved memory, as the following kernel message:

[0.086881] Memory: 3958852K/4189472K available (19671K kernel code, 2893K rwdata, 9724K rodata, 4340K init, 5040K bss, 220244K reserved, 0K cma-reserved)

Since "crashkernel=" reservations are shown in both kernel log and /proc/iomem
and other unused memory buffers appear in /proc/iomem as "RAM buffer" entries,
I've added hereby a debugfs entry for "reserve_mem". Though I didn't love the
implementation, I think it's not so hideous so decided to send, please lemme
know what you think and if we should improve code or even discard the idea heheh

Notice that, with this change, the memblock debugfs folder ends-up showing
always, no matter if we have ARCH_KEEP_MEMBLOCK set or if reserve_mem is set.
Thanks in advance for reviews/comments!


Guilherme G. Piccoli (2):
  mm/memblock: Print out errors on reserve_mem parser
  mm/memblock: Add reserve_mem debugfs info

 mm/memblock.c | 65 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 54 insertions(+), 11 deletions(-)

-- 
2.50.1


