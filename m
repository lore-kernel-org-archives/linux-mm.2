Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83EC6CD8CAA
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 16:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2B8B8E000F; Thu, 13 Nov 2025 11:57:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDC2A8E0002; Thu, 13 Nov 2025 11:57:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF3488E000F; Thu, 13 Nov 2025 11:57:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF5AA8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:57:52 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 55A0E1A0A44
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:57:52 +0000 (UTC)
X-FDA: 84106190784.07.1359E2B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id E88F940011
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:57:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AEywdnIK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OESjJwnj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Qur/PDel";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fDqTZrHM;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of jdelvare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=jdelvare@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763053070; a=rsa-sha256;
	cv=none;
	b=E4UFzd2RN2CFfnVpNRr8kGiNugj8AUTWRjuPLUesxW+euDF1/XwZJ+pviXV5vgJzJraxux
	bZ2NV8fi+HQvuuKpacCvBCr11tGC5hxEG71AC1758T4FibnuYDpgoCuAuIDHi8xpYpJgos
	3mqrSyUZMj5+IZNg8YYWrYzPsQEKfEU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AEywdnIK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OESjJwnj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Qur/PDel";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fDqTZrHM;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of jdelvare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=jdelvare@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763053070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zTCbrUfTP9d/K0a+blntLQtIjeHzDVEspbGQ29js3Fo=;
	b=ATZkknq0uhCLPGNVtSIzgHrTNVTqRTm87ywY2mSIGergugAQCkcROvNcwcZzqdEqpYHeMZ
	BpNZ91sSuz9ttOigzHOHPPhKCREbf8v7exf6zgcZBRt5LsepR8fnMm1+KagoysaSI0vuFY
	FBojjgTMfzq5sdKf1KyY8L7u5snclrQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 545D71F449;
	Thu, 13 Nov 2025 16:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763053068; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zTCbrUfTP9d/K0a+blntLQtIjeHzDVEspbGQ29js3Fo=;
	b=AEywdnIKWcBy9JWvsjEUU35PEF35jxpc2jdpK/le7QCOtnPj2v/kZrbtdiZjxav0nqLMPh
	SG7jW5oZ2Un4ip9aGsWG0FCMWuaynenpX5j5oKOp2LCq4fvFckrZ7YtUrmqqJnRzeyu9QJ
	CHxLFO9h7Zj0B6ejKGQ/F6k1PVvXjbQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763053068;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zTCbrUfTP9d/K0a+blntLQtIjeHzDVEspbGQ29js3Fo=;
	b=OESjJwnjjOfDfrqOirI9MQ/Q9zW8tvjuho/CJJVHMejpA6tsmzqEmzgx2sJF+5e6IfQDLx
	8wle4CG/3ke2c3DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763053067; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zTCbrUfTP9d/K0a+blntLQtIjeHzDVEspbGQ29js3Fo=;
	b=Qur/PDeljgQMw1mQhLoccPWYJqi6uKcustAdpsIT8xHsPFrw42BKTPsksG4U680TXmPrwC
	7fx08X6VQEMC1IfiIv/LglvpSXR0mBt17mbhuK0g1s9WwfSvEuwxvThvZRncWsVlry+lys
	j3fqhxH8JNaghKwW9cc4jn6V1PEiyFs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763053067;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zTCbrUfTP9d/K0a+blntLQtIjeHzDVEspbGQ29js3Fo=;
	b=fDqTZrHMu4op/WM8I+Qgqs3Nl1CEWnEk/3p2ADLfGiMMQA8112e8cpr7SNfj3+qgU8QP+U
	7QWZrlERFfarzWCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 275CF3EA61;
	Thu, 13 Nov 2025 16:57:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xlmkBwsOFmlTOAAAD6G6ig
	(envelope-from <jdelvare@suse.de>); Thu, 13 Nov 2025 16:57:47 +0000
Date: Thu, 13 Nov 2025 17:57:45 +0100
From: Jean Delvare <jdelvare@suse.de>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/cma: Remove CONFIG_CMA_SYSFS option
Message-ID: <20251113175745.2e29afe7@endymion>
In-Reply-To: <73552a22-c7c8-4106-949e-471b9a7bbc87@kernel.org>
References: <20251113145636.731a24e4@endymion>
	<73552a22-c7c8-4106-949e-471b9a7bbc87@kernel.org>
Organization: SUSE Linux
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.43; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E88F940011
X-Rspamd-Server: rspam07
X-Stat-Signature: kj5uwqznkmib1wucwk6hd8owed6ah7oy
X-Rspam-User: 
X-HE-Tag: 1763053069-124055
X-HE-Meta: U2FsdGVkX19raQy7X5ChnxgO0cSie4Zahi34OYbNLKgyBsEXfEMYJ0vwzyiKO1j/U9HlvpIBaYh2/90M9PRNaS7riSaIOiyuci7KC9ScnUpvBiwQNISP8OicOexZ9StSi7ILUNrKAHnBW4JS0PFRmvy4rWJL1D4KNp/2gUOiB2Va/OwK1QNgroiXai4IivxNvHF/2u+SuYwVx2TINqJS6jpbF31EDgfR7wdaMu7oHpmD30kE8TuB++C8X499wP1mVyhBuil8/rj2b8HrTpqcC7Xo8tzSjgRqjiRy0YwxQk5n3wGZ6o2DZ+wYyAVE5ALDpjoZ9u2uPAmuVxG6zOS7OARIO+vs9jc11crZ/FyQsAiWMX4Hs8GTnbtPD8J21401nKqIps29axg+3jyIGX7nFR3fdQCQ9TG1NwABEC5m1NppOzVcDxievp5Mryu5M5zxEcLQD670kwsCWQqAZdCCRqkDey/PFD4hIyayye5tPDboBnO51eye9lxPcymNdM1z7GRN4vpUKYWA4C5LH89vXfv4tqDucsZxOnk15OMnpRbQg8JKoH3uaHch/79FtGni+ks1c/MId2i+yxGZrB+jtxyJThtSULnjhoM7D7wbcThqmkfeLgcithREVY4gAdbwWAkuLIwQagYtmvAbOlFF9psEsrA4C/tOfnIFXiBOLk4L8BRDbrCkXEqgoADj69W4i+EQKgQXpvgo7lBWB0pCz6O4BVyAqRZI2pH3OAaVTi+lBaZl8hQFe30eMbKGDcZzP/JDfd7VcDaiL6eogG3DONxFjeoVXFSol6Jv1CtRvWOEfjWmbz4uqYgc3eiDh8YI7XICvWIIm8r6KfYgZgmEhhb+mfYUuI/5JnLpwZDoZ0eqD0QqGZU0nGuVrgNXoitwbSpG66iYxQenpKlXgoeAMQ0M9fgxgNRUUo1OlkPt61ya8Jj2lWRztGblXnbrTp/0lBGnaUGAQorWhtk/a9x
 Cmi91LPe
 ZxJGscvmYDGakG+ZyhhLcZ6sfkXQqfe+Q2WBYzvXvObqcTFjaSmlDx8uZNJhB0LLZAFk12NaJSGeZfetsxMgJOrQOEJgEDyRFsW+0nHrb15GsoMzdcqR7r6UCLu7HpausAV7mheSfMCfbXSJdaqTdKpr0EVgz4OV2tmokNhPZFzcE7aJ2is3yVrFswLfFVAzwXK51Y31ETjbIZ4RPCoHiRps36BRgXoCoE6oEM/SPRRFtrNP+wOXRVU+Q8M3/osgES3TC58l71CSrhMnXpOCBJ+OrT2cxVod5DT+cIRP3y1RDfou4QGnx6G+G7E1r5WoPD2egAZ2oMQFvT9U6lb4gY4VbljgDtdwDwfkMB7fK55zhw9DCR4d/8REfAcxUkYAD9Vq0RZWWkOzltZRhWzXb49hlJIijdPgwLki0srdzcKOZRF72HRjwXxZ/ew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Nov 2025 16:35:03 +0100, David Hildenbrand (Red Hat) wrote:
> On 13.11.25 14:56, Jean Delvare wrote:
> > The sysfs interface to CMA has a marginal runtime cost and a small
> > footprint, there's no reason not to include it in all kernels where
> > the dependencies are satisfied.
> > 
> > Signed-off-by: Jean Delvare <jdelvare@suse.de>
> > ---
> > As discussed with David:
> >    https://lkml.org/lkml/2025/8/6/371  
> 
> Thanks for the reminder, it sounded familiar but I couldn't remember 
> when this was discussed.
> 
> Hoping this was properly compile-tested :)

Yes of course, I build-tested with both CONFIG_SYSFS=y and CONFIG_SYSFS
disabled.

> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Thanks,
-- 
Jean Delvare
SUSE L3 Support

