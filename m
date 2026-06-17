Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0859ECD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 11:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C16346B0088; Wed, 17 Jun 2026 07:08:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEDF76B008A; Wed, 17 Jun 2026 07:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2B526B008C; Wed, 17 Jun 2026 07:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E29F6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:08:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 293391A0380
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:08:00 +0000 (UTC)
X-FDA: 84889129920.03.D402CAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8F36810000E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:07:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NLqJtmaf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781694478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t8E4VL5k1FCWK4bBsLA60HlUaTKskXgiRWXceTi/Z7g=;
	b=oW8721fkUnZN5F4N4y0f5UrdOEwB06DC/Og0tOHwa+UOhosBA8pEN83Tc0wxMDmnd/rULk
	EJZobKWOTpinrdCkpw/4suMqvq2E/8DCns+1RjysGWSHMc7+j+aqIiX+4PGMKFp4WngsGm
	AQXySM4Mx5SvJR5MICle5K0CidcCHWY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NLqJtmaf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781694478;
	b=A27ZttsI4ul1XKKYQmnLBt5tWVs2Od/3X7dq37Kdn6yLTt8EGTB2y/jKZtGBTzfg1ERumV
	ymvogAwfwb7q94LP9y1Edxegi2eGXn65/JugbesCisoYzgwhOk1AeuL2E/F9vXUvqDblRC
	tqECwsmSbGCM6zDaXqxjxZLQXMBC2Hw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DF0EA442BD;
	Wed, 17 Jun 2026 11:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8091F000E9;
	Wed, 17 Jun 2026 11:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781694477;
	bh=t8E4VL5k1FCWK4bBsLA60HlUaTKskXgiRWXceTi/Z7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NLqJtmafqtIX3Tb8AE5w+R11U0MKcAWK4r/JDthJKBeBFww+/nhMWIF7Vcjo3XlrP
	 C+sMhhL877RwyM+BGepimtw0NisPuB3Fe44rYPXiUZt9dVlwKN4VrqVF9me6YdDbHl
	 pFFXT0/2ZIigetaxoFUza6yYSkGZgku//+clVHrXjPGOM3iNH3j6c9GZ2OoQTBrAiL
	 VNnD6yyvKpw7cHJSzgO6M1+U/I2Q5KYWJMTWD6vE4mdDhWQ/4FmLOGMt9O6OYslvQT
	 ZVS4vIGo6Gf6cZHxw6BlWAWXLCudd7RA3cuiRLh4h9rHyWFqgckeY4P/SUMhk1pdmH
	 DcVGLtqx4J2yA==
Date: Wed, 17 Jun 2026 13:07:50 +0200
From: Christian Brauner <brauner@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Val Packett <val@packett.cool>, Al Viro <viro@zeniv.linux.org.uk>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
	fuse-devel <fuse-devel@lists.linux.dev>, Bernd Schubert <bernd@bsbernd.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260617-attest-gewechselt-tragik-7ed473860051@brauner>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV>
 <83f05c55-efba-4bf5-abfe-d2ab0819e904@packett.cool>
 <CAJnrk1Y9egYizkx1H9K0cqxSYuB+7vLvQbV7Tf4C5eHFqnnC-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJnrk1Y9egYizkx1H9K0cqxSYuB+7vLvQbV7Tf4C5eHFqnnC-A@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 484f9xobkryng3iyydhawfe1fb6o6w4j
X-Rspamd-Queue-Id: 8F36810000E
X-HE-Tag: 1781694478-472303
X-HE-Meta: U2FsdGVkX1/DZRX8g3rKqV4vNuiu/wh7QLQRCGXl661VzLRJELZcaBKa/MCNyTZ98fVlC+rZdS/byA2uGTAWlfUNprZr9mxCGyqeQJ5LWmN63Y+MqrutCk7yF9i7G7EF4jywqIcZY/cNxV+UOQ/FTo/fk3an6UOAJh5k937TshXiVHeLV6coyGZf2ZNqS7e7229HT13S3iY1rxQbR2cEqISAaV8TIimjTxa9Zg9gFyR43AXk+rcRbM49Vmvx0MyiTOb+5iHxbcTZc0al9s/sEkk18SECmUYXPCA8kU8Hjp6b0BRPGW6a3XO3P1UOlrsPLNorAiDGwKqn79GbdcQ54ze1IHuqMqOi+yfw8Fwjiu/vdVL0VqcGlghvjuz+HkugfG2apU9mAnw1qbUQNz6Dk2Ng2+5x0viMYZf6+wmy5CbhrJbcl0SbDpkcnWYqzFVEL2nYGz23NJ2eWuUJbZVb9F2VoYG+2w+L/3MBc/rd8jgyZWJsXYWWVCUayqpDq/vva52mRGl8q/E8d5P243xDz/kj+yv3tktt0pfC+WUzJh28KLyH1qRMDVKC5glYhKrNFkvPVPcaoBEpm7bIgMBOcXB6aFQ/V5SuIhqFpRexCAkj//PDJ3AXGArtwG/W9Uzydh/MF+DFjRfcG2VPNJkyR1QXBwgu9DvGoj3OXu5z+6KliSudAk4HJrSFhBO9m9l/QmQCl2qkWrEvlATPQwnkcWM9o7YyInvgf2iXDm8fEIjXOoxvQnnTJ1vsTwTWWp+tvO37eBuwniZT5jeJNOXa0iYPd5L0Iwf1VCLY2eT4r2mrB1c1ksYmtO00UBB2Th/FDemAimCbfbJxLtSUY9amWwWZ3oaJdPvBp5dpwKvXwLWjeKR1Bb7/svmDpMGwPpRvUMOh+OhfUDukT69Wg0PqAUxsGL0KyRGQBQDsGZ++xgF3P/jLqH56FHSzl20uFwy+3k1tHmbVOGcyqlMUjyq
 x3lNWMT9
 cVQHCl1i8IbGEmdEyA+4ofaQg8K9EN4mioyFhwvnNCmrmLONpsc3ciX2WLgUb8k2XS296tcaftF+RDlT0BTcqQgw0+qnN49x34JAnUAVRmq7V8xxS/JmAGgjcyQPownRuaAfBXbFoEVloB4Hp3rdnJV2mqHXjhp0jGD8EF5FX4lGo6QpYfWEazxTdCqiMDq1mjXowhCt5cao2dusiRSbbqTu5rHlYNXE5BchgsMnGXvtf1liRu0BXWjcykNkAmucDJ0vp/I4Qn/FmxAizr9erZMYP9Nxoc3vNnK062FHP8zdKUDvNUcag1dlasg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> After this patch, step b) is a straight copy which means step d)'s
> fixup doesn't modify what's in the pipe. This could be fixed up in
> libfuse to not depend on modify-after-vmsplice, but I don't think this
> helps for applications using already-released libfuse versions. I
> think this patch needs to be reverted.

Note, nothing was merged. I deliberately kept in -next though for a long
time to see how quickly we'd see regressions.

