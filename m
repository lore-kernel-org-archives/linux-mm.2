Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82167F99378
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 11:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AF8B6B0005; Thu, 23 Apr 2026 07:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860CA6B008A; Thu, 23 Apr 2026 07:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 776736B008C; Thu, 23 Apr 2026 07:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 654D46B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:47:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0055CA0101
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:47:02 +0000 (UTC)
X-FDA: 84689644284.11.223F0E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3FEFC100015
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:47:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VR1KrBY9;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776944821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XDKSlXg6ujrv4T/QoeVpg+ld9Uvc5Axc3KexdwpK5wI=;
	b=HnbvxJ5MO03QEH4FGhcwRh5xSFJsjPVnUUFvk/NMmdurp5VoB7Sw9SiXwVU2An9moZuCeG
	mZ3WYr/ToYG+xtiWtQVMB1JAsfpNp9tqJxtq7RzUDfR3w9s7GGNtie4s9ExFEyyvOeP49I
	aHtSlopzjsIi/OYG3I0OIUM4cft+H4I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776944821; a=rsa-sha256;
	cv=none;
	b=Kiki6qy0ijSHpVcoR5pu0hd3RSIekIJb7h8QG4aUef0LsyfNBAO0FuN75ANwfABcUXwqn3
	eUZnpecF7gMU1B7dmwssPRRmxYMRcIIdfCC3QEJsCgVS0AfVNKImhBBWu4LuKf7BJdfzmb
	34ZHf57bp5csSYS+KUy8p7BnAtJLeO8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VR1KrBY9;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A1C840A34;
	Thu, 23 Apr 2026 11:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA02C2BCAF;
	Thu, 23 Apr 2026 11:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776944820;
	bh=lAH+tMgsReb5YVC0CmXAwj1oMmvhUfKDEdN5ypoXL7A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VR1KrBY9S+BKA8k7jOQ4sG8OyVJgAf6WtmbQeHmDYORbAMCr5fh7SpjfbTE9eZZxN
	 rzHKzoxMGlqJJ6utbOn/T4Sg/BVYFXnKlhovHu8Hnk7nwTRdzPnxczM8ncMLTxEa6I
	 /wlmNFzw1+ZOcQ1W26d+BcC9P5CfcCJA+EMtq0sjeFT9AB9b0m6Iv/3V0CegpKOGx5
	 1208mxBZFaUodfH8KMVxqvI0AsIzojqJrDysFUAKn835F3B5vL8ltK63r7S484cONZ
	 uECR5DDXheZKCldg6TyodnS/qboWOInXZISKyaXrr7Qv9jezXVe3Vx6epCT3FOHNwp
	 CU3ro1rSzVU1A==
Date: Thu, 23 Apr 2026 13:46:54 +0200
From: Christian Brauner <brauner@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-nvme@lists.infradead.org, bpf@vger.kernel.org, lsf-pc@lists.linux-foundation.org, 
	linux-kernel@vger.kernel.org
Subject: Re: LSF/MM/BPF: 2026: Call for Proposals
Message-ID: <20260423-auseinander-steigen-b80ee53079a8@brauner>
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
 <81033e57-99e5-43f1-a6c3-c363e96f9c9f@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81033e57-99e5-43f1-a6c3-c363e96f9c9f@acm.org>
X-Rspamd-Queue-Id: 3FEFC100015
X-Rspamd-Server: rspam07
X-Stat-Signature: azaixbd1z7fuuwkii6nhfjnkqqzeky3g
X-Rspam-User: 
X-HE-Tag: 1776944821-499905
X-HE-Meta: U2FsdGVkX1/Xd1Vymmdv1AcXknWnDPZhu3Ge4u5qaeohsEEvWbAgHVAB4Y8F3jWJ7Gd2rxLJkrwiT6rzKLUqQEBdoEQyqKu+a7vcw+YyTjlI3NycwxV5zNFlFSyDghHKrFWzdalLMUiq0FJnTkdpYvwJvG1MwxfdWmjTzVKURPQKraYxkHY9uap3PH6QISG8UnTHTU5u+O2xZd6MXfQ/ciqZ075LhRFMQXbRPURYdliOd3c/GaE02W+6o2UMjTzBRuYhSCcQFbvjMXlyOUIFABwXa7B3Wqbnwi1w8PItq8RXBELjfWb+RbLb9w211IJMlMIO+azkYS1RLtKtn3QsSnm1Vzkk41hnyhP5q/q/EcZHn7GuX5Vu2u+0KumEykNCjt2jfFYqPq/vvHzf95farXH8g2IgsmgVVjkPIktg4BU4AAattwum8qv197f+tbxxUNJ13HCNNWLetoFbict4UnMCncp2WMRg622UHoNGJZ5BaSqi7cLGuvXkbspcbSLJzAPSWYtaYnR1+HL+1L6Twkiu5HeJjrBKrBL3E5QZ1vM+qh2YehJ7zkaWYUY85JOhyi1zy93WnBQTU0jSePFVwYOTztG3ULW4vE8rH8phVWHquOt409LXNkkJ52tJX22ZWOSoCbZnxR5/OQnZDKdh3VcCOQQa/CK8k9m5UR+GWBDyDu6qb1ZDZigiRHQ0EL7jwH/7tWeADuwTk2liaZalQJe16Q6QrLQcWXdtAUDj3XAtc4665X5DZ0Rt/Be2Cf6ohwDHiX55VkSJocVfCXQGNdSSFNELbMn3FZ0lNBtGZPKKwvhmLNakLeZP3lPni1oVmEVW3vh3oMwojPTq4BJncztZ6RuwK/Rl6AHJHILmn+nEiRGntxG99QCod3L3v48ec+y0rTAw6neeXWXBEqsPqBy6X+n3fbW5KNJE/7BQc4H8wJPRmM/fZqP9pvi74q2iP79EC+GjPreS2yYfzBH
 0ShE+tBH
 42uN15GEcxNmXdjpkdD/QqCk9cKAPwq5sQk6xU+6EYi/TAmxup/nuIiKJAIWL33w043crA8vkthL0M5EJxtcynrW8AIpYTPOOdY1g8nJ5eEFW9qc51VeEROIKEgnpTMGtnFYm+3bqKnKs+gUwwGPxUz+0UXrNjB0KFoveq5NQj58WPe+2V4CW1lS5nkXxJqIIZNOr+W/RubGEKVs9sFxDeyxWzYC6l1iIAw8sN/qp2ry/zrDQ94P+NTvTe1CgutRWZNtNztwu8OaE4J1dQY0T8hmTxcGBoLdv1I/7qJq+swRSSQiD63kN3V/M6olbZWi6cTx7hnBIm5q5/hZSTza50HFxsNI6/WUDVEQPaLCP+ZpHlrbAfXA1XfWegSMS+PPu+3hZ+78AKvUc1GOf523jnATqQ60un9KTDTAIOSAMdCXjSDw9/EVr9rn6HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 01:29:56PM -0700, Bart Van Assche wrote:
> On 1/10/26 5:24 AM, Christian Brauner wrote:
> > The annual Linux Storage, Filesystem, Memory Management, and BPF
> > (LSF/MM/BPF) Summit for 2026 will be held May 4–6, 2026 in Zagreb,
> > Croatia.
> > 
> > LSF/MM/BPF is an invitation-only technical workshop to map out
> > improvements to the Linux storage, filesystem, BPF, and memory
> > management subsystems that will make their way into the mainline
> > kernel within the coming years.
> > 
> > LSF/MM/BPF 2026 will be a three-day, stand-alone conference with four
> > subsystem-specific tracks, cross-track discussions, as well as BoF and
> > hacking sessions. Please check out:
> > 
> >            https://events.linuxfoundation.org/lsfmmbpf/
> > 
> > for further details on the venue and hotels.
> 
> Thank you Christian for being one of the organizers of the
> LSF/MM/BPF summit. Will a schedule be made available before the summit
> starts? A link to the 2024 schedule is available at
> https://lore.kernel.org/all/20240510212132.83346-1-sj@kernel.org/.

The preliminary schedule is accessible here:

https://docs.google.com/spreadsheets/d/1mGEdDrWskp7Ua91jGXzquQGinorcD58DAVXhOiRp2Gg/edit?gid=1852749899#gid=1852749899

It just hasn't been liked on the website yet.

