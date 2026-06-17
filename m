Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADC49CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 11:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78766B008A; Wed, 17 Jun 2026 07:15:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50086B008C; Wed, 17 Jun 2026 07:15:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E4E6B0092; Wed, 17 Jun 2026 07:15:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77E836B008A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:15:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E23471C200B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:15:51 +0000 (UTC)
X-FDA: 84889149702.21.441236E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3B22640002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:15:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V8QKJV2y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781694950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8OVn5cSwrAaSds42v4NucAklapZL31OeeEiylDJQAEs=;
	b=lNdsi7oHZ+bVYl9EyDKHp/rEoS0KBP01805kU23ZqucgqsbX5HQkNX79bFJ+gJbBjkbTCh
	1LaiY6O9Tf1+q9eM7jIHCIOqDK4dLk+2H8qW8gCaFmBJzjX88CrUgXzM1g6E5pyaVY7MvD
	Vjlp8SeWzsl/FRhEgY5lSWWdEpQ583w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V8QKJV2y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781694950;
	b=olWmJ2LiRXxMiPR8KhJ5t6pWnurqZiibpLcFkKIeAvDsZbUEn3uMRZaGpgAZo0hDdF3thI
	Pg5Cjr0TE9aCXuHMCvE7zqnczrn5VlJIJrnRsZUmAVwdGOTd9jYoxOFQnJYaSvhNG4Umr2
	M38mmJ+3LSn5AjpkvWL0cwtomyjmEPw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C7EE8600AB;
	Wed, 17 Jun 2026 11:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36431F000E9;
	Wed, 17 Jun 2026 11:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781694949;
	bh=8OVn5cSwrAaSds42v4NucAklapZL31OeeEiylDJQAEs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V8QKJV2yG5eXD+JvRDZqbjoNG8wdlQL1/xQA+P73ais5nQreg8JLtqHAEb6LhxY60
	 076IzSkZa+K8iZthau/3PQHnFHt5oBEH2NnZBpfcHmn4PhmMWipRLDRTmiP4jW7O45
	 7jH3HOO7ewh/Fmkh2ANswAoN8OW2U0mfYa1IHyciS4J/slTiD8RCxJaTbsVv4kKrJj
	 zd4efYEpfBe50Rf90FkaWcVdpCDLpHr15vZ9FKQcWjz5kM/paF/4qI+9Oj8jqdUgR1
	 vWjWn/Be/0FzDkqhc74ErfanKuc2GzEVssP/c+Ea9pOpqsHPrV3kpsmprwl6+CwcrL
	 QKcoXUtmvucbw==
Message-ID: <849ad1f8-973f-4742-b56b-7d31570d93fc@kernel.org>
Date: Wed, 17 Jun 2026 13:15:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Remove mentions of PageWriteback
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
References: <20260526195650.353196-1-willy@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526195650.353196-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B22640002
X-Stat-Signature: crm4cn768u9niyjcemu3yah9dy6a8bbs
X-Rspam-User: 
X-HE-Tag: 1781694950-477164
X-HE-Meta: U2FsdGVkX189r1fgZVb6fQpp5bEUFeFoL1YK2pIiLzXn11wlN0EBo0AlRDJpuxX4w4Hen6il3QBKUEhGRqcstpAieElWUCPMc9Xheb9FtpOffnlFh/JxXiI5Oiz2u+D8gcNNwYZj6S+UcobI64xdnDTv6fpa+xXr8f3QRZjfszGxYwRUIVIFNIXYmR+IKq/lHD+8Y3OrvsfqKbtqspkB8PdNrtprPJabAF6wrp3TB/r/3XF/7lDzL030OU8u1qY+9VXYH31zFalGoVsTibEHe8BOG6VNz8DEhvO9CeEQN4Q21TwLa1VpFHYhmncswJqqgdaCNA5IV261pF6PiroEOhE1yjxUYHXnz/142SVvboIcG0dIU7zGThkfaRxk0EiY7UuLMknuXWex51QXsj/L72MUWHPPVhO1e1a/pxiK7FbzJ/p4Yk2wofe7SKtobJnTw2uy+Tih6KB1vThzSL5WSZUadh3Qv5da/K0fLyaN8fcWp0Qdt5JCHdlYn7KnDSbIDS7pCxVz6KYcvec/k4P2LUHz3i/bGEM4t3Z0x07CAixFzKfGiVFDutMy4JC817ijcKsdbc70RWGpzCtRfhNDiZVI9uuPnRt0LX9zhEo6+eeaQ2MGALAkTg+fi/KBuscP7yIVTy/UdgciOt/y9Iyx3JdKGlD2zeVk3iHwTxBihsEeZ8bL9F7GfonF9LMR3p//rm5tb48p/2fvXPueBx/8HIOFeFeEhuWIMf1NAgyQF5cPj8Xw4ZpM1gW9lkYfjxq50ros2ymI4f2Wr3ybXpjA2iCC5dVvs/cLTJ2B/Rl4fMlVT4Y73jxd07GD5fhqgoM1IV9d6f3oti+ajeHbHwP/t4f9AHcH15xyhqvvt3cqddz3F0owmUZGOtnPUGc6lEOM0+W02O5JsQgB+YIlNviWCJvJx+3M5D8w3GOiz0b8ozlJCdhaZSYbHECiqQpMYZymbQLZiElB3+LIHaJSLKZ
 tgzP0uMP
 YvHWQb2QzD4HQnO+rRaBcwJfCvVn8t1EBzIwxwF33RRbJP1MumEQ+SaS5r5ntazMUNnp1IPkpeF6HWYtc8LJ5kCVbiO6NDIXVcPtAamrFW9jrsLuGoCdhx7QxCq5993wfzxuDnJYZ/UeJc+RIkbXljqvtBoItqN2QuwRiKjX5teqVcODDkmQydOArioNgwqP+OJJAGK+9RuFt28uVGDg+LIMKGJ2Dvyz3fj6IuQI02/trgmmHhaOlU19Q72Xegx9DGpt05XKLDda72tLvmmFX/Bl5/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 21:56, Matthew Wilcox (Oracle) wrote:
> Update two comments to refer to writeback in general instead of the
> specific flag.  Convert the large comment in memory.c to be entirely
> folio-based.
> 

How could I tempt you into using checkpatch.pl or similar tooling to pick up
people to CC from MAINTAINERS? :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

