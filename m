Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C40F0C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 09:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C0166B009B; Wed,  8 Jul 2026 05:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871086B00A0; Wed,  8 Jul 2026 05:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 788BF6B00A1; Wed,  8 Jul 2026 05:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 516BF6B009B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:09:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF8491406B0
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:09:12 +0000 (UTC)
X-FDA: 84965035344.23.140CEAE
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	by imf26.hostedemail.com (Postfix) with ESMTP id DF8E2140008
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:09:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=lZgxf3kM;
	spf=pass (imf26.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783501751;
	b=EpksvURVTyGVbXbz/h1n1WjF7wcFw9zX5Ama7UtE4gaLNJo3VGzUf6pADhqoNz324N/pgS
	XCNmwHukBlJWKImABMW/53kbXzMXtjpCJdNI0t8isRkmDqqUhTXyVA5sLwPN9IcxZp2CrH
	rxTgr7l/ToRMLB9zY2r2d5sjOmvJ3s8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=lZgxf3kM;
	spf=pass (imf26.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783501751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWsg+VRZP+IygMe6ufylZ2Cx4gOG+ZDTVRFd55uzSho=;
	b=XUBLD75V1bj+P6rHWyz2SfbkmnAy9HdwwQYeZbL/45CO5pqfyoefxWP2lh0/gFLnxvSZn8
	x1xF/XHJY68kme26VSgwlg1wW2uHcEnkZvLx6hn6cZpNx0+t2RB76hSHushLrTbcN9VFl+
	ob3HvtFFg43RB1V9t6IuVpH2S5z6ZCA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=fWsg+VRZP+IygMe6ufylZ2Cx4gOG+ZDTVRFd55uzSho=;
	t=1783501750; x=1784711350; b=lZgxf3kMF7WndkyGS1rXiR0+4/9Nz1tmQp00nRJRSTH5S3v
	8aD2GX+M3SATkUFSAaaxOQbScqQ/BNynpwMLYMyXM2tQZjNSFyi/LoJGJZdjyo3WN/65l53L7CxQy
	zMQneU3Rl17+js6xiJI0ThtkP+U5mjuvfI0DjqkaYkTsmImRR1BVu8Mao+HRbjNbJjb4dngvOgmSQ
	rDj0CFlv4WInVJLRE4VLk7q3UWfbkYMskrlZ1RtSWZL+S6BxWBZZOXhYDOicO6M6kuzDZwqroNLS8
	0Hv/+XEtKpE9vNvYHLa0+hmCv0A1qxDRvsEQOnwqeJsTjWUL6KZGzKvcv3c9vQOg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1whOHC-00000004WiW-0pqx;
	Wed, 08 Jul 2026 11:09:06 +0200
Message-ID: <867a09c9bc173902bf2deb9094a008c5cd33bc92.camel@sipsolutions.net>
Subject: Re: [PATCH 0/4] drivers/net: replace __get_free_pages() with
 kmalloc()
From: Johannes Berg <johannes@sipsolutions.net>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Brian Norris <briannorris@chromium.org>, Francesco Dolcini	
 <francesco@dolcini.it>, Jakub Kicinski <kuba@kernel.org>, 
	b43-dev@lists.infradead.org, libertas-dev@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-wireless@vger.kernel.org, 	netdev@vger.kernel.org, "Mike Rapoport
 (Microsoft)" <rppt@kernel.org>
Date: Wed, 08 Jul 2026 11:09:05 +0200
In-Reply-To: <3832c190-b5b7-49a2-902d-7f75598b0789@redhat.com>
References: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>
	 <3832c190-b5b7-49a2-902d-7f75598b0789@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DF8E2140008
X-Stat-Signature: 7sh6auaonmfm6auqahmxnz9fmkxk58ym
X-HE-Tag: 1783501750-918753
X-HE-Meta: U2FsdGVkX1/Js+Vkw+sd66QDi+illVLSdG5LrMEBO4gKVNl5u6Hox03aHJ0qnsYVP1UYqiFwpQFwoAHMUed8BbU5x9H8JqsqJbDGXteVsObeRXiQTYG9YbE8dnEhffsz01qEFmIeDX9osJE4ombhMtFR93kSTyxtwBjnmZjHKPhm3yKciRq8W0qmaDKnSM5qVBV8S5R2AnTYJg0kvWggGsF7pYqn44z5td4YcaTxXbeTfj8Rr+iKgk86ueAOd+O/wdIFdSR9miLfg+Z3zT7Ml+LRdlDjCv6s2op54rBd6a5XxMGwoViab8NmrGxnxKsw9LpqEAaZT2/hycCalOI/v/iYLabS/c9y26dC+lmz97ud6wNDX8McDNTfMEBkFuoSr2OCWom0J8SBvIWiV2MlBmHBMwEvIlB+5ZfWwWvYTunIJSazbhJxgFR6YqEIswi6TzDsMCeXLWL0PySUwzE8p2CjU7z2cU2ziGdXkmz0kWKke70+oofweXn/iDoEsexIT6ApIzItKtZxGHtC69GUqc20dras9wuOq+N7Afx8asduiD2a8mUGR70qkWYTQdwC6W1pWhHFF625v/Wdv3ER8znzUFp++2R54kMHxUDpninKVTwel/mMKUC0lEtjEXzjZa9j6MJvid9LC8cSkBffg08JOWY/0iWFIVmWFyY9MuKQ3Ej03/VnMLiqyZeu3ZViOUx2iGQJGrwRfsW3K2J8EAR4FJAn4gHXWMxlEd+zY6AOsu4Hhw+T25aVVisfrn5QqdDrfD/Iezule1XPuUHGEQhfVC1OAjg8iYExBoLlP47+nh/IPJT9+KMXboyvJORBIIGAUSIKTt5NYvmsNIKEzogQ7/v+S1bm6Wyg6zLgGEUuMPwtTtC0hPTVrii3RWm9aLA29zeHNa02t/XcC1AP49jzJLCtk47DW9acbUBf1wg9TkO3WQ6eP8/lWr0w4mteTFFFoHSpIaS/hJ+wyd0
 j137oxJ+
 5Mp1T2Iaifz8SyDcg+fN7r1CCgzu5p0TF2MmausSUNNDCGQBYDWea2ORxjtyjDzhar2VAw1AN96AZ0sCMM0FzinMDJUlLr0QlLIdgdvcYUqQTPnNiWNdSsmBnjD9pR7jwfByo4H8shC/XWkXEaDjzp0uHgINvFwTBrAAeWRc6YgETb1vgrFuTgJXrXyORCJK4uubdREKEkztxDIClCezOXgWC4NKiCAKfL1PPNJc+ISo33ncnUFoXPaOAozfVjOQ/KEI3RJMCfh5GF4vCcgI8wPSd9vkP0iGqPdCGXwLdRcL4UCwdiZSE4tbHGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-07-08 at 10:55 +0200, Paolo Abeni wrote:
>=20
> @Johannes: just an head-up, I assume this series will go via your tree
> (despite the slightly misleading subj)

I assumed the same and already have it in wireless-next (with fixed up
subjects to add wifi: prefixes).

johannes

