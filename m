Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0546CC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7C406B0096; Fri, 10 Jul 2026 08:44:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C986B0098; Fri, 10 Jul 2026 08:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A386B0099; Fri, 10 Jul 2026 08:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B77B46B0096
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:44:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 58218C13E3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:44:23 +0000 (UTC)
X-FDA: 84972835206.20.B06D6B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id AB23D1C0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:44:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="EEELqsB/";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf21.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783687461;
	b=cirPqawmKfSg5Y39l/25YtgAacRL2/NslGnKnpU2qqNSO9gK/jp/K0v/uqlZBVgK2OkwsH
	ubXNf3OdSVnE638Y/xcRTK/5QJv9xmao4PEWFxOnrGAfNs2BCXorD3OidBA1d59dw+oOCV
	CwN852J3GEQtowGyMP3t3oyP3wyMoK4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="EEELqsB/";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf21.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783687461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9LEwRfQaoioBH//UsNLh50BwO16qRhtua4e0cQv6bg=;
	b=P2votj4Y0L6eWlx/og2Ks8Y6UajKs4iNlfHQnGLu4hYYkmT6946gLgqTnoqsrSBZFkK8tu
	9MCu8nxulTlh5ZpiYuVJ3lRJEq7tTe355TC4n6unULP7iX2l5XuBuXw5wSYNu/tARSz4Iw
	1LnhrK6JQ5UZ5MxPuUgizgJJ1LOtOJk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A546E60051
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0F71F000E9;
	Fri, 10 Jul 2026 12:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783687460;
	bh=Q9LEwRfQaoioBH//UsNLh50BwO16qRhtua4e0cQv6bg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EEELqsB/lvAiQCs8s4hbR5ZPsy9SiHScIesdcTHoPgw4dmqwi9bzCfnkQKBR4MHLo
	 2NjKayd+QrPl2Zlw2EESyDj7QOlOmSA0zeFeS7sa5k8c3GQNZ6c/hwnK/mES73dmmK
	 ort1EYjmiIt0MQigSAb0Vh6Me861x9qoFfXLEnWo=
Date: Fri, 10 Jul 2026 14:44:16 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jiri Slaby <jirislaby@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v3 0/4] tty: replace __get_free_pages() with kmalloc()
Message-ID: <2026071056-comfort-dynamic-a713@gregkh>
References: <20260630-b4-tty-v3-0-a8476c66c582@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630-b4-tty-v3-0-a8476c66c582@kernel.org>
X-Rspamd-Queue-Id: AB23D1C0005
X-Rspam-User: 
X-Stat-Signature: 9yuuibk4pwee638i5czpc9g6ks935uks
X-Rspamd-Server: rspam03
X-HE-Tag: 1783687461-806650
X-HE-Meta: U2FsdGVkX1+A/hWTSKfb3LjIIqf2hSCDuglWYKMnZj4DpJgWe4tjMEq4o8BfW+lJFgfcLc9Nmk9pG4t6Vh8k5TkFQN8uN6KlVLVaCeqmYOAzcj9XuXuPqUwSN025zpnCcbnfAGgIQosTy8yI3xkfvNPE0P3tqQGafqu966cBiv+XInMWXXgHT5ARo+UIySeG04dUbOFCvNIPyyvJD+9eZQLMqmzV8BKkW2CQYamZdbIC4JnkFWCRpg2OL8ebRTxYSl2nfTVWdiNLLDapfiOdRddPKVBDRXws7oWE3AqdhKFxwwViSVM2iPfEFO4pw6dKxHj91jm1vi6DQWeQx/6igl5MPh9x9gmm8nv4bLb+Wn9gADYgQ//hiJb4FBWZAlkx1nzCK6ljdmZygkoXaRPsR0baQ0rSCPm3Ui3wPwhq9mAeRkCubsxQ9a0Q0xkuyy+yJvojQ8jtBBu/puDRPDWH9c0ChjvpOo/O5c4C2/G0SsB6Gdvd74ep5rUEpEX+yUMrtdWmMW6sfJUmWWkvotpHnHKMiLc6S6/tked88rJ4gQkRzyB4rruzt8D2uQeKfolQuAUsazKliAoxDvFEa9aqHEAg3r7AYMVLOwkO8PxK+UlS80BegrUvSQ8ZG50ZBZagIumL0wpDku2YhepS8nXWe9B/fAvxg16cMMgurVXpqWZargaiQJ3KCWQoc6qeRExSd9eopDGOtc3a5Wre3i95zWyhlimVkMlHwr8mz4EZN0HtRq5o2VUHp0pSEKqtOr2H4BKS0VE4gMDgOFTfa06LAKq+fsU0Cttb0wqj35xsAneyJeAxonMRhzut0bAuPKZRYtJBluB4YlbrAgcVmUFlIFO8Lr3XZSQmuvtFMLuEiUOQSzM6s28C+XuaMJDZK2m4Rd+841TEdXOHgEAQlvBg7XdAo6d5j0jGQ3UU38FGp3/7pSAMgdf1TirYnud2ISGgbUOPnfsps1ZrN7EsLAU
 wUmagLol
 e+o5fFNtshr0bwkc/IVeEBCVLzMKK9qhhHpQW5m8QFQJsnkNH7MoivxfrerDsPDypF+avIEd5N8kMb+JVHL0NaJ7/RRkfR4kKtHnqTaeXV3yaHp54Zo1mQrVzHfDm9MFuJrZHJZkhIXgnvev5NTFaV0nHhoF6D6q3pIOZgIoCiAo3FJlSq0xzV1zCfieQ7939glPO/jLFCmxI9qso0nUEL6qkNX4BxoI4O76ccEsb3w7rwaVsbkd7ULDR82EbRV7Lwd7UUIHS3e4TwGhLKl6rRpafvjFP1pAfI56J/GPD8ZDZohqvQz8vyHvjjvuIy6AUM/tTEkR+ZeSy5ZIrWacrHTN+Db0cqd7fVbKmBrhw+W8oGA1OHf+Acg/CYGvUJeilvcjhzfV2xDSfwIJ9g7pv0MoAIh7E9a+Xohc4ZCwkJA0nmLuVw2+OLOCtsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 12:54:02PM +0300, Mike Rapoport (Microsoft) wrote:
> This is a (tiny) part of larger work of replacing page allocator calls
> with kmalloc.
> 
> Nowadays the right way to say "I need a buffer" is kmalloc() rather than
> ancient and ugly __get_free_pages().

I already applied an earlier version of this series, so can you just
send the fixes you made between them?

thanks,
greg k-h

