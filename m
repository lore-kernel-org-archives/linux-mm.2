Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0485CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 09:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ABF08E00AB; Tue, 28 Oct 2025 05:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 783438E0006; Tue, 28 Oct 2025 05:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C06F8E00AB; Tue, 28 Oct 2025 05:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3208E0006
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:05:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BCFA713ADC9
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:05:46 +0000 (UTC)
X-FDA: 84046940292.27.59A28C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0DE791C000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:05:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="PZec/Lez";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf18.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761642345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYG1/RX+eliusqnCBd6U7J9LKVWeo4069gz4bEck/bE=;
	b=EzQ2kroaEeOWmFs2mJAI5U17GUh59dGA3aknKSiLxuqnt6NPLKCuhNeswKDZ+mzvad3qMX
	hVdwBwrYFqiBb+Uhr+a5lhQHwc/2oFVGeNtVUyD7dU6XE98eFfhETDOUb0ycDL/NVbExiz
	gzd3MHoFIg+aoq1zMGV5YUdx99RMX10=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="PZec/Lez";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf18.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761642345; a=rsa-sha256;
	cv=none;
	b=GXQVONwJAwv5aNiqbTQxRKWvFsS3UFoAqlBSbBSbUHPXnr6tVDN+VuqbNJbB9GsTgpSDgp
	LkqmcQgPAar6zC1yyiITPoPH8YzJWx3VEzFdJ7wYqa0o01aZQttdpsSGTYcDjqyeaiMKDf
	TjnkxkViE07e7C7fFTMrBQNwYgX928M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3107961D2C;
	Tue, 28 Oct 2025 09:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B71C4CEE7;
	Tue, 28 Oct 2025 09:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761642343;
	bh=K7A5LEXplzJkfbatI7862m7lOmxo9hUn+BBYMb0zq7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PZec/LezMN2HA57TVdFf37v+PPHo/3Uoto2mBVGcWze/3hNKVlCb7PYXJVs3YNupN
	 pyndNNhHD/RoU7+mn0gX0mv53jhremANWz5BQkh4M8PvOOj2/3ifonoe4IqN0K0zi2
	 DAubPAv4WvADNnAXm09I1n3+c8kTGsA1cpQ7JrOI=
Date: Tue, 28 Oct 2025 09:47:55 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org,
	linux-usb@vger.kernel.org, paul@paul-moore.com,
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com, selinux@vger.kernel.org,
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Subject: Re: [PATCH v2 36/50] functionfs: switch to simple_remove_by_name()
Message-ID: <2025102848-freewill-atrium-ea47@gregkh>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <20251028004614.393374-37-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028004614.393374-37-viro@zeniv.linux.org.uk>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0DE791C000A
X-Rspamd-Server: rspam03
X-Stat-Signature: 3houcg1gy1rtap1ku3oi94dhusu7hqxb
X-HE-Tag: 1761642344-157101
X-HE-Meta: U2FsdGVkX1+BkcUvifzWeC52Y2CSAwL2fIvJgy5jC89kMx1V8rg056lA7rNYepWbZqk6qPsCLqOGyQFHs1xSYTdJnUFMZ7nipnL9/YI99pdEUZhaamawU1SV6yHOBQ04oFCQop9oRXwudc5lSonnP8jx4yXCqGi97U0FrMWfb/Nr+dKxeDSWeZQxmq23tXUTXIIS/c4dXvJDD/jeD4g8J2eBujYTAJWBgI1/ANgkt9xSoNHshXQ80qaQicD3OaeJ//Im3Uxqjyho5yGQmzrPahkt+X9lvmLVlEZ1Zr8rPc6kzU+RwF3G60RK6xK0DHNrZlofKdwSMP9sHrQdb0AjPiPJ2G6pdhMccT19Q/LEwn0nIxLd+HnSrlvU9Ng39TU1LojeLn08L5bQL53eZKTw2vuoDnscy1acWUJxBSCNNOPZOLvoYvPUaWoqopl+mxTT2fnhuB9DC7jgABsNk54ynpu/BJEGKrhmOIHD+v5P3Iv0xi+FUPxIfggqj8u+/gHUoQDFlH3sqP9G3oqDvMuggMOxijNxkAs7g9XP2KdPqZFhl5eMOw13gc+Fzhz9mWFvxMWjK6F7MlNQO1p/ilnWOVAn+feuKtZtrhcZS3liyI9t0QKip4YhbntQL2XK6v9rzw3GPw/wBzQoYQkCyoup+6oucQycA6dTjmrAL9305DMMrbqDmn1CcsZtU1zSBgDRv8o3whjHj56i63SCdT5oB5h6yRUlNS8nABSRb42xiH+Q7f9rACEk8I0VTHStKSo+ONpI7jYTZsRFURTx7KY9uoA+MJRvMTYycHZx1ZKjeNm7NMQzVWHHGAJPDnYnsKepAdNzJejfmpsVcBbgjnhHkf6FHv1WE8MYZwZ8NnouhCjpYZNNtHdf5k4jHXk51aiB/ckwTH4cUbesCQM8WeVESEmxQgyWCIAAZrURYO2P//l2p36DVFlNhQAXTKD0YGOMLJAn0oTReZE1ZUcmPxq
 4UjVG0ZZ
 InNY15Fe/9pBjprnuxFfeFDAy8HzcR/Y7sfp9sgsPHjUHiO79Rv7CnOEdByDzBiKxUtXHNEX1C6D8/3/x7N28ATxMJD5xUyQa/C4ScBpmpOlIyZyCVBCNDjcKBkdg4kV/FKVLRy2d1vASN8pZUkXrA+4i+HgahkUo/Bo2RKmTGdzQizIEkjUXGTyakARq0TMrDUm+Ts77zZZUa4Wn9W4k1fPr/B2RdG4rtliAik2KoBRY/vjXcQGfKy4YC5eQu9JYtPum4a4sGnOeFXlSDUtDTdQxIynS7Minjh7tJEl4D1aMdCoHXaDYpfXppPgcsz/hCDs8I9rjdZRfUNCtimEEAGPhvyTYv7VMdoKDsrEYHG1CedBiRDjoDP4WCiQ/RSoGm+5oG+47Run6jqlJmJtrzw9G5g0XjVmkoJVzCZcEFGIy3VYw0qm/ZUWj7znHaLANB9C8U2kcnFsG9lSHWyfw1yzg5GhhCh5/FOYzV82UkhLJUKsVW24YU0PJ1Cc6yKECoxWc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 12:45:55AM +0000, Al Viro wrote:
> No need to return dentry from ffs_sb_create_file() or keep it around
> afterwards.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

