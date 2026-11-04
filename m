Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0189606A32F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RlGTCzi8
Received: by kanga.kvack.org (Postfix)
	id E19186B05B6; Wed,  4 Nov 2026 04:21:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF10E6B05C0; Wed,  4 Nov 2026 04:21:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2D4E6B05C2; Wed,  4 Nov 2026 04:21:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B655C6B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:21:29 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 632D2A069B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:21:29 +0000 (UTC)
X-FDA: 85396893498.11.7621FD2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id CC1A7180006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:21:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RlGTCzi8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793784087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLWmGN3SfRKJzJtFGqy9xXljoZdTMIGgQAZ0U5pRqZ0=;
	b=tfyMyD2B2NL5v0R+wJdopX4cL/DJ2nKs/PTfR+3dx/Qfw7rQ5NBrQLmrIS+Vu7NsnSBXsh
	ezgc8PpxokkpIbwH8wdjO7sEsfeBNfWlqshEBzer0qSvwLhHaik3F880OuvvFTnv4BDS9w
	GmvN1+0yrdB0kYihkcXsBPNnTXl8B8E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793784087;
	b=vC1QS3B1alM5ZdR6Nr/OWFCudG3S44c0/Cp2IERHTVaOxCma2S2pHv8BXLW1BsMouhhxNm
	1PH1GFPq410xstfor+xPE7BBTVq2QmjK0syquMo83MS9OpA6xAbSFP4wr1GU19iiN7TaZp
	Boz8L0tAB+tEssj27OzkhiI2uL0AV88=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RlGTCzi8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 43B4360142;
	Wed,  4 Nov 2026 09:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC751F00A1B;
	Wed,  4 Nov 2026 09:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793784087;
	bh=TLWmGN3SfRKJzJtFGqy9xXljoZdTMIGgQAZ0U5pRqZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RlGTCzi8pu88TVAb0kwn4joxUiR7mlBDOdPpezl4XmsvQd8kAh4iDFU4pQONkMHIu
	 eliic42rAIpabkq9bUb6HqnW9ZOmOC+nO6hIz58hrOaEoVJAOD6f1NccFejHSUbQEg
	 UcTtVvMVrKX8rkKsqChfbeyKOblU3iUz404/VcCwAESFTSpzfmuSYLv6tIXqWgvwx4
	 JsaFcHO4jSLDa+WNzQE5ZJzqGGlwKjwInimlKuIR6uaQtqBJZavxLJ41GnGzP1qeFj
	 IB/K6cI148TQ1ND1SEtNwA24wzZ0dXL4wMxQ/4D3P3yQeU5Lj8YAihYUT5N5BdD20o
	 LKB+GT+o55caw==
Date: Wed, 4 Nov 2026 10:21:13 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, 
	linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-modules@vger.kernel.org, Chuck Lever <cel@kernel.org>, tytso@mit.edu, 
	dmitry.torokhov@gmail.com, Petr Pavlu <petr.pavlu@suse.com>, 
	Anna Schumaker <anna@kernel.org>, yukuai@fygo.io, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH RFC 38/38] selftests/proc: check that a faulting
 readlink() doesn't hold up removal
Message-ID: <20261104-erwecken-pulsieren-anarchie-9a5a7582621e@brauner>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-38-59422ed3e465@kernel.org>
 <sashiko-outbox-195510@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-195510@kernel.org>
X-Stat-Signature: x7e5jggefr7yjobh8qfghmdgobuykcbb
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CC1A7180006
X-HE-Tag: 1793784087-582257
X-HE-Meta: U2FsdGVkX1/hxFUs7hEKC2G3fxE4HwhJ1w6tE+EZdbS/zHwLyovvc9ujrrgB7GVjgbWZRQusRE9bOUJ5MV1C0sCKX3N+/Z2OdSislSAWYoX9lIb0b8VE3UMpbI3ZdwGDJNxwYaju2fViO2PRauHndqCIpXVet+4IySJIhK1dS4z/WGpehzznUk9GzYMfSxEU5s9AuYPXnjM+Br8MRC5uwpAj3L2rI1rZ0gwnYAr9qTYneEN+6SEGxIpaLAkGfc9bXsjqlMKujt6Y75/o6T7vr856IFedl6RAlgDvpXJAVfBVAe5YEgAu2n4F3oH3tSV9jA7cpiBzKbbrUM27nUAHTdhdkORBTeWKUhv4pg+YbgOVDaUTMIExUDdmd3X0bF2Z7Qw2b1TknR17+5ygEaPIF+hB/ts6X52VDbmkLXv57iJ+PKEEi2QMX+gacW+BqyBG1oA6pNwB7QCtTjY+taOyjaDzemYoKQ7X9KkbpCz+lV0taAzkGNQ9Tbw3R4FWU5X2KJS//OHdzoV8gE4rSrTsgIR3Bm2DGHjv4ia3baXM4zAMzNToHnKqDQp1oWzWp+z6sD9XHXQ/S9BMWBYBOBHISAwzZQIPTvGf3xY+cVywV2PLt6AdpGcthaAje8pJBq9WEsKuK4gbC2BihR/eVUBgwEcae6SU0WZcjmk0Bw/TiRVNL+rshzTskwlDQgoyYxTvFwlb0KEsn0YubzBdQk1IvVjpLT5ZOaI0w3QPdneQ4LFm2b99ies5m2EV6PPWCc3xjmEfrxQ0wQVRH+ko78l2F8ZARA1vApbXX20u+Q2L4mBFck7OleaEJiRS18RiVFRdoQtwsBkU2Eu73su5C2RCLGzGasZ3VY4jifeubqjsBEWWKvfZd5EygIwcXpgCuFonInBaQSNn1b+koAM4gJDQPpjiusijHKIUFHrVb0j5yQqnvzJnQjmS/Dij8iwfhGZ0Gaa/91iQrS1wy0/WAJ5
 otpHhT+P
 x658rDBOAjETf55AeZ2wv/rECmKi3PRTduKLRQesx9At5iCqqSOo8me4T7Coem88NY42uiHPZQ2EohV54TrykaqVOCG3iGN+WB46pHrng7rzG+DvjibQsIb7RzwDoo4orlDTmR3PRq9b04RbHTeIOW6uqKQd5Rzv2awxMjRuD4L0srLZ/YhJqqeQf5Jc5R29fiObrZ9fmGIsnFMccDnu6CnQlyqb1qwtCiggZErp1svf/m1+Rs5AojY28gGjOQMLBUsK9iQauHQNOoaMhVrW7+Br8QBLHJxK2wcwP0qID8sX2ITOl36jvc39PShaxqxWErWWniEXE2sSqUdhPHs3mRNAeBVmlC6zCQDYTr+A/g8BWevkfd6j57uGn+Zm9tub+QUeNtStiZ6ebTburydCJO/uNa73Uy6YbkEuXLsImEcO5dcE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 02:48:45PM +0000, sashiko-bot@kernel.org wrote:
> - [Medium] selftests/proc: Makefile adds nonexistent proc-remove-slow-reader target

Fixed.

