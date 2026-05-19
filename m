Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F4C5CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 04:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4BFF6B0005; Tue, 19 May 2026 00:50:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFD376B0088; Tue, 19 May 2026 00:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B120E6B008C; Tue, 19 May 2026 00:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9CFE06B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:50:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F87DC062B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:50:11 +0000 (UTC)
X-FDA: 84782942622.13.29CC271
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 48F00C0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:50:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PEJwg7qF;
	spf=pass (imf28.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779166209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UzE6dS67UUBJxmSXjvbVhyaMNxVQpaBWqnB9f+wBmj8=;
	b=GOZJvDPsP8VFyHg4tfq9MV1wyO1I8DWqu6P0WmbQP399GeVhg5Q9EKTIWuZ/UQUAeaL162
	/aNf04lNIE/RoEgdyCOaZZxJyunIh6OeW9zssKKgrloi1VcjZWBipIcgp8e72XR0bdB3jO
	w2QzrLR6O7AAJyw06/2Eb+6D3QR1FnA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779166209; a=rsa-sha256;
	cv=none;
	b=0UaibQ1wAotpmE0s5qNmVToYS/eAHMdCXNlp59ku1EiQwE+mDAQ0qaakaKuBkoiHhhyGNf
	XCAFIaasnktCe0Wv6NRHDZT+rGdj6OgF0mWbVrKYDxJKjrNQWlb0GKS4DACigDWUOM1S/d
	zt5w6/kyNyv4alfUmDxzNLft7OpGFLk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PEJwg7qF;
	spf=pass (imf28.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779166208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UzE6dS67UUBJxmSXjvbVhyaMNxVQpaBWqnB9f+wBmj8=;
	b=PEJwg7qFJ4gLikqQ0nn/M7X+sp7FQ2oKpNXd4dQlI1G1Ik17nK5zkPqALgOmYBg5wpHWmX
	r0ByPHdZuUeaLP+yhMvtA7xzTEgcoY+/wbHrYGKCXDlWaJr4D6w9cEcg2Whi91ILaanyei
	ovFuqwZHwsRHwcKyWzCbU01Tgh5VZks=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-360-YJSbT7tfPwa0kNW7QCKDyw-1; Tue,
 19 May 2026 00:50:03 -0400
X-MC-Unique: YJSbT7tfPwa0kNW7QCKDyw-1
X-Mimecast-MFC-AGG-ID: YJSbT7tfPwa0kNW7QCKDyw_1779166202
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 88C5F195608B;
	Tue, 19 May 2026 04:50:01 +0000 (UTC)
Received: from fedora (unknown [10.44.48.45])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 6ECE41956053;
	Tue, 19 May 2026 04:49:59 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 19 May 2026 06:50:01 +0200 (CEST)
Date: Tue, 19 May 2026 06:49:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v2] do_notify_parent: sanitize the valid_signal()
 checks
Message-ID: <agvr9YmjPN_T_Swo@redhat.com>
References: <20260316151956.563558-1-kartikey406@gmail.com>
 <abld-ilvMEZ7VgMw@redhat.com>
 <20260317113452.cede9a514dfed36a1cb0e5a9@linux-foundation.org>
 <abmmnjgxrrGLKn2D@redhat.com>
 <5acfea15-f2f7-4498-86e1-a383e17adad0@I-love.SAKURA.ne.jp>
 <aglotu9HOXmwMM35@redhat.com>
 <20260518153755.f3248bc3725d5b745a6696f9@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260518153755.f3248bc3725d5b745a6696f9@linux-foundation.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: 8UoAU0pD-zKVN4gefi-0nf7qaDLehuyQGsskG-_SSS8_1779166202
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 48F00C0005
X-Stat-Signature: dchygtfzgegfi4pi9rnzhp4bbprnzw6h
X-Rspam-User: 
X-HE-Tag: 1779166209-242541
X-HE-Meta: U2FsdGVkX18a471bbRtDtY5bPrOE563gXJlkwDIlC/HUSYiNW+wd/dTcay4hghELSfZu65OUk3zrnSPx1XQtO9V01QWzI0MKSnfAOwrwXC4DUcbBM6yHXg9vjwPQFhoI8Unf7kIRDmyZmvvA4GoBfe02M2wTyfYCb4iuOYErC3z37aFe7h4OId/pCpOYnCIAq55vjceilccodtBH8BG0cVJjo+CGkRZc2p3X1IqRhNNkfcqVIpvDBN7czN4dR/jaru8jqYPFLwwZdE8qNB9sVHWKnUdEp7eLSriP8UMxun1oL0xN60hnEGF7JxYXGMLBDCYMhYCAQkH5/3N+drqWOJ8iJWetOHGYdfFskzEWFUnHIj3p3aFVyA/SBFGIbrTL1qfgccN7VIdMS74necgiGpeXNeI8YPWahqNiiqr/lIjI2KSxLk08wn9QPlPIWVoMU9mobyK00HTWJtkSMKyMxjYIdGcirh0Y/CM9ZZMn33NK6w+X+lzIlreyhihk/zc3S5m5Txe+S59kW/HLSpnTYq8xpp0TJSj86QGnPT+ldSJouMvBq37puUZAFLAqKdCLQDi0WCnoYdG8cfYJefmMouwa9Zxah6PZl61/Ke+eaVXdELkjOVDHqzERoB95kFtavR0s6jgU39AtKvoLFLnLF87LOvKBlpX9IMDusWq7oCA49ezKRvq+8iYp5Dx3y/8tSQa7vRO0/4M7U7Zn7AIPpaSu6iWs/JFJW0SVYA12e5w2aNEGuZe4lusdNbPrBVkJ/HmyNj6NjWvF/tzcXMh6OzE7Oz+RtWEFm0Zk1H7Ol6zajjeQJQrr3PuXH1bSAGf+0akmPne7lAlDCAMb2LT8W2cApdpfeRBi3WuexC9DPmpaDs3vP3uAfjDV72g99gqoYVaTahpOC4UeHsWHt+xbOESMlyHOV91Pqv1mjHwEOYDnhhoATcoSGasfSllAXNi8dnq589Ppmzwz3x3RYOB
 LKKIBVna
 Kriy9HY1XbT0yx6cTYWnUaOl+YNo4UptN7MCzULwWqjR+Ly9OUaAtrQBGDWpW6SlHMwhN88tWgu3TeCeCSMEFi+DptVYMdkiZZJbOrcVptyfk+jKmr8koORhNbtul9JAeJ6dD6zPvbpDUTO/xoSGTa/MjGg5b1tPnpuQ8Tw92zdHimwxUYpgo+1mwbU5P9fXTR7mU7HpNOJdrRmrB8XexC45bGffPtvYheuvFH0BEnwacrumDdwuicbUEvDSZhO/lxYRteL+1vNuvYyzP1lbTXM3qoDYeYsvSBWxbR0PTiRhRS+RiWByzkHLfm1bkrfYMyzgU93ZMIZBiZB56H2jvodj4b5hAZqtZ4pyNvQwso2Xf+awmvUj/+YPPOSOB9lxB9SkhrUPh/yHT4N5og29NBOpxDdyAG7QOGpcXaOxqH3Lbzv3ZzD5nR3oyov8l3mIMawAuZqiZZgEhfxfduQokN/7sNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/18, Andrew Morton wrote:
>
> On Sun, 17 May 2026 09:05:26 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 05/17, Tetsuo Handa wrote:
> > >
> > > On 2026/03/18 4:08, Oleg Nesterov wrote:
> > > > On 03/17, Andrew Morton wrote:
> > > >>
> > > >> On Tue, 17 Mar 2026 14:58:18 +0100 Oleg Nesterov <oleg@redhat.com> wrote:
> > > >>
> > > >>> Now that kernel_clone() checks valid_signal(args->exit_signal), the "sig"
> > > >>> argument of do_notify_parent() must always be valid or we have a bug.
> > >
> > > No activity for two months. When is the fix expected to land to upstream?
> > > This bug allows a local unprivileged user to crash panic_on_warn=1 systems
> > > by running below program, and therefore should be fixed before Linux 7.1 is
> > > released.
> >
> > This patch depends on
> >
> > 	[PATCH v3] kernel/fork: validate exit_signal in kernel_clone()
> > 	https://lore.kernel.org/all/20260316151956.563558-1-kartikey406@gmail.com/
> >
> > but it was merged without the patch above.
> >
> > Andrew, that patch is still in mm tree,
> >
> > 	kernel-fork-validate-exit_signal-in-kernel_clone.patch
> >
> > could you merge it as well?
>
> Thanks, I moved the below out of the 7.2-rc1 queue and into the 7.1-rcX
> queue.

Thank you!

> Should this have cc:stable?

No, without my patch the change from Deepanshu is not strictly needed.

Oleg.


