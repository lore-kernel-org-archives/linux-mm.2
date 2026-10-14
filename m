Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92AF9CC6B19
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:15:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 718406B009E; Tue, 13 Oct 2026 23:15:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C8946B009F; Tue, 13 Oct 2026 23:15:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF2C6B00A0; Tue, 13 Oct 2026 23:15:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3408F6B009E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:15:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9BD14160414
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:15:43 +0000 (UTC)
X-FDA: 85319766966.23.A0A049E
Received: from mta0.migadu.com (out-231.mta0.migadu.com [91.218.175.231])
	by imf02.hostedemail.com (Postfix) with ESMTP id 836DF80007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:15:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tKhrhIBU;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791947741;
	b=UX7soZNFjjzXVFwhbXFUcOzsd43EX9Fd+axSB5qDJ1ZDQ4OoQUm88h18F+SWBUcmEIbvNl
	s1eS3JXFqw3kow6/FUK2sfvSycOS19QaPnxHVukxOKagm0ttDu7CFXopfyiN8CQSAuuwRc
	0oQdzAN4+0k12HxoKTMDC21gebc+Kvw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tKhrhIBU;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791947741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NusBsCN2k4Xho7tFqt6Nsy/lET1cpsFWfh7l+lu9ruI=;
	b=mty22Gh8ibxF+Lnq9+ugfw+AUb8Si09B3v/llfJEI10Fs4Q7O9yCGDT8s1OUnER0V/XoKr
	fZnppHHDu7JjGsh4tykZ7ePNlAWV58pCbtZeVWCmo3KvjWVHCYii6u97qxkXMcbbKMR5ch
	IH5p903G/zXIO5OSVhdJaGta3Jz8/sI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=iqnSwKThg2r+VCDBnuDtQZqs0SPn1wUtvThsdo011rc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791947740; v=1; x=1792552540;
 b=tKhrhIBUM6qgaovyQEmAqfsIydfzZnq2dAVYYVrkFsHxIw41OrEg7A0QjTBJzABK2WkZ0eqM
 VrU+81+2AulglWueC1JJudluCFP6oqpPk3iCRfiH5bS4vf0ABgZW8o/dK9ZQWC+3POCXlQN4NK0
 TZrnpNT2NlHAfioR+WsRkxS4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5554c545539641b2;
	Wed, 14 Oct 2026 03:15:40 +0000
X-Mizu-Trace-ID: 5554c545539641b2
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] mm/hugetlb: use sizeof(buf) in string_get_size() calls
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261014031147.444733-1-lienze@kylinos.cn>
Date: Wed, 14 Oct 2026 11:15:26 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: 7bit
Message-Id: <A872D399-1D00-4306-9EF2-F3BD6330E9B0@linux.dev>
References: <20261014031147.444733-1-lienze@kylinos.cn>
To: Enze Li <lienze@kylinos.cn>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 836DF80007
X-Stat-Signature: au63fwnbpshqszqkx7ib3w8cuqam9t6k
X-HE-Tag: 1791947741-835377
X-HE-Meta: U2FsdGVkX1/Rxanx7poFKFHWOV6zo5RiooWqUDSQUiD8fkxZoI28J/x0QGXCvCKCCkWKpWVvJ2LFuA5fB/aQxGlYy28LxePMUgTwwyh4xsuIViTvHTvKnzPbOqDcetKBB/tgMwQBT3IN4kIVDcN4TwVb7mYu6N/zGirsmq9/UVu6nTU3+bJs7k5RC/7XWfJP5YClvFqlPLniDKzIT3V6DL/ZNZ5X2Juut90K7p4fAvCwUYRwRO9FZPveEaR+Nj4CmgAukL5fj2tIiUjN0jsK/evVIoJsSBLu0T6Mg1k73TaeJmlzVMUyc3lKppzyQSPTqBXpCXJFiXrXmRlj3EJvZWpxaoNhbGIz8dnFRfTMrUC9SOl6oe6R+ZHeBUNZtU3ztvtn5v/uEaHP68e7yvXN9hZzNnYZ5efhPVTFn0lhINWeKR+//12qjg4+ouxu8OV8kKoPPKXJhjWQmlq4e74xdYXVbzYu3c+HGIIaAOCeVu3e6wKfORBBA+wz4fiYOiWFSb2+HLMdG72Hdcxv11oSXbgx4YoyGeDdgG5TICFPjf0Wdwrf8qldYUg6+kyqI56ku1y0MpY1z3s6fjsT5NEhzOgtBjcbkTS2ay+n8UJT9YUGZ42pamUWKtF/6kxdjT/ZAl0vtN2wykr9qA1GR/8fYBJhZ7PIJQM8A3Gn3OqB/sTQpNNPpXHJszeAhEUkUuXbK+uuS8EAv45eN5sCyiRpgsrBpizut2vwZtYtBVf4AiaKsJwXfg796JP0Q+S+Up0PRLEIggFr+XpeyciXlBamfTyBmNnpIfDH4U0aS8xqVFn5byrC/FTv2f5fuoGx0hCgO8DJ51ulgiZ+8D8qRx+1VCByJZeG2hBaMoy8ofkWWr4baoaEG1oB41MLfqLAJxPoEsnT1wtSdjhwAhxvsz2bZrOc813E68kQZgmmuLA6Qef0qUT7quHgpvRnGrJ8UvwaJMdWA2lPOb5BcRbX6o1
 7p/SOw62
 nA8DECQ5qO3R2A3olc+VtTcpI66na/7tdb4zjrB2Xjqar3eM2MksvuuXgYuNkEQrw1/WBmTfFTXVPuaYisJk+Nbzn08GSDV1hqQC+t895WbFPJVb9i9djuph88GB4Rcztc0LgshdxOMkcqpP6FReOS310XyRRVpZqLbOopa9PHhzTwCgTJHsZ9ujrgqAEmiwMcpY2GfhkseBCiKIh58UjzxCls/U1XAFxgybbcwEySAOzAvfSoZRukdVS/5KqJIfOPOqIXLY2N2MwA9uo2Pjyp+gXvpS1HjFul+/GrYv3Woq62RykVooRnmzmOa6IBp0co8qSmYL0ikQyiaetpPc492kP1j21q2iQyUN2KP53XuKviEiKyYkNyp5a3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 14, 2026, at 11:11, Enze Li <lienze@kylinos.cn> wrote:
> 
> Replace the hardcoded 32 with sizeof(buf) at the remaining four call sites,
> for consistency with the rest of the file.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

