Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1595C44501
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 10:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1FEB6B0005; Wed, 21 Jan 2026 05:38:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC5E16B0088; Wed, 21 Jan 2026 05:38:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7A76B0089; Wed, 21 Jan 2026 05:38:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA2A26B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:38:20 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73E231A0AA7
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 10:38:20 +0000 (UTC)
X-FDA: 84355621560.13.4C25F9B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 122F11C0004
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 10:38:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=01qCLiPV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0C60SNaU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=01qCLiPV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0C60SNaU;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768991898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ticWtdx2fEzPAZqNQf4bgVrxD5kj94KneesvApIQRus=;
	b=wYCfhgvBm8n8Q+ojwKSMocpOS8n93Ke9Z6HFmd+zTN5F+PQNZRWgT8mBqN5r4t45OWRIrN
	xfQvoSNe0n/3Od33sPtsqLUD/ti4FlaePFyy25AWPsqW0TgbdqzFPXGHxVUqbzvSQnD2TS
	+b00vKvhtBvzRKpes+JlDMi1OOrKjsg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=01qCLiPV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0C60SNaU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=01qCLiPV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0C60SNaU;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768991898; a=rsa-sha256;
	cv=none;
	b=t5ijboltgc2rCkxlEnRZj1nQRdSnWL8NCnkg2YsJuiKSP1JKXAf/fTnUmVDzHOPuPVhrHT
	OycbTceUhNUtFrMlJd3M/zCRX26fZjTAgD6PuiKN7Le9YK4XBPXvGWKZPn3HcEJt/v1h+V
	P7cXwBC+tAF9YS3J1bMbIciCxzow/qU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2D66533689;
	Wed, 21 Jan 2026 10:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768991896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=ticWtdx2fEzPAZqNQf4bgVrxD5kj94KneesvApIQRus=;
	b=01qCLiPVU5UKJ7agJWNIu3zAIS4Zsv2CqnAZZmJAxnGUP+TMfGnfrrMczZ+kckeV103KeN
	tHXWNQj7+iR7ACXfhP+lIwTEBT7vEJjL8ZDQrE2tfbvWgoXDzugGuSTY12Je/rO+ZYx82p
	5PTEHgxHj5qar2plF8I9VSLVNDj4wVs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768991896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=ticWtdx2fEzPAZqNQf4bgVrxD5kj94KneesvApIQRus=;
	b=0C60SNaUgX9nMqiyzIEvBsXCNaid2upMTG+TVHiMj/wh0yvz/VJ4TRSOpmcwruPiatTbxm
	Yhho2wUkLKTDElBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768991896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=ticWtdx2fEzPAZqNQf4bgVrxD5kj94KneesvApIQRus=;
	b=01qCLiPVU5UKJ7agJWNIu3zAIS4Zsv2CqnAZZmJAxnGUP+TMfGnfrrMczZ+kckeV103KeN
	tHXWNQj7+iR7ACXfhP+lIwTEBT7vEJjL8ZDQrE2tfbvWgoXDzugGuSTY12Je/rO+ZYx82p
	5PTEHgxHj5qar2plF8I9VSLVNDj4wVs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768991896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=ticWtdx2fEzPAZqNQf4bgVrxD5kj94KneesvApIQRus=;
	b=0C60SNaUgX9nMqiyzIEvBsXCNaid2upMTG+TVHiMj/wh0yvz/VJ4TRSOpmcwruPiatTbxm
	Yhho2wUkLKTDElBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 971F43EA63;
	Wed, 21 Jan 2026 10:38:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4GaJI5escGl8BAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 21 Jan 2026 10:38:15 +0000
Message-ID: <76e95710-77b3-4095-b640-0a801dc055fd@suse.cz>
Date: Wed, 21 Jan 2026 11:38:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab fix for 6.19-rc7
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 122F11C0004
X-Stat-Signature: ppz91rwqck7krbnnpz8owi4bpjs7pmj1
X-Rspamd-Server: rspam02
X-HE-Tag: 1768991897-795177
X-HE-Meta: U2FsdGVkX1+tHjIF0FMzc5GXLOcywTi9X/hieyHn8LD/eBypHuoN+hLIhAEcZDJHrcCYF13Kf/P6SJrJMJPbc2liMBZ9U91w2OD2Mhdfi3wjvOHpxGZf9etwqoB3daYETuEc7tYYPS15MFHPzK4XUuUVuHWJn+4qmkjIVfFlxCUpV3oQftxLwKVvvK1xRJ9NGtffL/W8vQhJI6JIOeBKTSgtED07GUYG7W1F5UYvXpknaXgdzm+ITr3+zsLjnESDcIKW20JwneoQRc0nNttkRZlhe4uQehIf2meXgTPHq9jQqgqmdBtDXAKuyz3xrqMztq5j/8KleJ+i14lA2lDK0v1mCKP1Ihh2q/c++zGCwkOJL3euJt4UXgSCF5BTTdyDk7H/O4skmZq6OFvlmRAZZAviX7sYcnUNS9QxiyVwkXAIvHmUdVNOO7s5Wzd2JzdjXeANR9WJ3EBrP6leRfQhv2AIJsViNGJz6GVFY9aOMc/4UgJAY37MjZDoKdi6iezBOp2Zi+TNgCkEY+zwRGvAtD55fwUH0cP0pKeZmxJFJqUdK/tUObFCsCaJHfu/hFE5CvTihJnxgI4tzQi2Ahw2ggaN0hX4/mmawlLLl7iQWiD5D6iPHvO+P0/Q1iU8ycEZHvHGWc3ZDYCxBQM1iwAG1ad4euB147oQhg4gQBTKImBJEBc2d3wSpBzo4EOLM7KRB4egYi6opFW1MvnPe339ctyF8EXOayXfzkQavL28G3TCpPKve3i3JOoiNgtky8eyfDZNnbRtXUa0tTD4O+f5nm3qH7Ne0Qg8GIhcMx9AxLAvyGg5BMZ9M9GieVa/3/6Cz73Vo+LajHiWpH4HZIEr2zI6bCmElcGWJDI9GfjAufKXL1qrM8/02UQhHTud0cxDzAwNUl/zgp1Jw9feaC+VVn2fEHO7u/0G3zEbGb33fOMhWnpFjLSXu2fkHbdv0ACODFWL21FXhfIcmN+xxA8
 NqQX/Zmi
 y+IuXzKJX3uxhgZNWfpftTcU+6FY3iSZMH7tdjiez5XG402Vw38UnIqKC2OP2D8OpArlrf/50YbMYNAI3wgcf/QWllUWwdy6vtVs1HsduP6Hikz+CsM1s/FeMx+t+frHgutQcKuBdSWFY5UH0S3+RgMN7kfszbjsFl0xw4VGpmrstZI0PThdh622qlYeCxFPCnOf69/r783/4eiYmsnrhA3lnZxLJCS8doqT08t4zVrcdj+GKqmB9BgjvMsDPiSeScHILe9WEDriGb+BTJvVrvMLTbNDltUyWLLTMdQlIpY2wzX++xMZ7q4xBll7gcqJa8DikBACisE43bZHwcoUuFK1afJZaY0TNKm7/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the slab fix from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19-rc7

Thanks,
Vlastimil

======================================

- A stable fix for kmalloc_nolock() in non-preemptible contexts on
  PREEMPT_RT (Swaraj Gaikwad)

----------------------------------------------------------------
The following changes since commit 0f61b1860cc3f52aef9036d7235ed1f017632193:

  Linux 6.19-rc5 (2026-01-11 17:03:14 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19-rc7

for you to fetch changes up to 99a3e3a1cfc93b8fe318c0a3a5cfb01f1d4ad53c:

  slab: fix kmalloc_nolock() context check for PREEMPT_RT (2026-01-21 11:34:18 +0100)

----------------------------------------------------------------
Swaraj Gaikwad (1):
      slab: fix kmalloc_nolock() context check for PREEMPT_RT

 mm/slub.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

