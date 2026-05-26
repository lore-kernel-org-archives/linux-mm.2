Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62F20CD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 08:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC4596B008A; Tue, 26 May 2026 04:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9BE56B008C; Tue, 26 May 2026 04:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A246B0093; Tue, 26 May 2026 04:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 83F8D6B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 04:17:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 257C6402C1
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:17:53 +0000 (UTC)
X-FDA: 84808867626.27.CAF76FC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0CE3040005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:17:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PIrlx3pP;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779783471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=czTwdpOB7hnag6u4YNY0f2YtokOqIdJ426QI+4b1N4c=;
	b=1XY7gNcyWZicQzL+xw1u6MHKp3VnhBGiw4CMdBeOB50wvBSkUiBmt3TNcvRPglWRSbZPYM
	Fs87AGAxW43zwfutydqBY4WszEdfnSRbVZWYocP3QgaoMnzrCF+3R/yMqDaA6V5z3iwNDe
	axy9tKN0LO0NCEPxV5+nS7OXjfC0JDg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PIrlx3pP;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779783471; a=rsa-sha256;
	cv=none;
	b=NzH7c97HtJ64Zb5i7aUWyJi5ujWq/7YsQI1vftMm5F0GlcFD+0j7592gdHmX26MYkf1E3H
	rG4J2LVm7p2hW/XyJG5hJeSN5ZCaO6BGK/1cZgxvAmbRp/DJWqINo4248mhqBCa2Bh9zG5
	JJQjuTbODdTuGX0g5/vUImYeP8yrzO0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779783470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=czTwdpOB7hnag6u4YNY0f2YtokOqIdJ426QI+4b1N4c=;
	b=PIrlx3pPWryvc3IJNcyVtbNSfBPJHpcVlm4bfyS/RYV7CedscJUBN7lwMQF4Zuv8zcX9l6
	PBperlyZ1fDBThUTdeOXhuIK1yY9IxmPpTRE0PouzynvdhfKphUZv9V5LwjiS7fdy1Swq8
	XDnL+2b7WCHUlsRtPMdAkiQnM2ljP04=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-465-RHxsW0B2Pny7sLDEBYZN4A-1; Tue,
 26 May 2026 04:17:44 -0400
X-MC-Unique: RHxsW0B2Pny7sLDEBYZN4A-1
X-Mimecast-MFC-AGG-ID: RHxsW0B2Pny7sLDEBYZN4A_1779783462
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B8AD51800618;
	Tue, 26 May 2026 08:17:38 +0000 (UTC)
Received: from fedora (unknown [10.44.48.14])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 9103819560AD;
	Tue, 26 May 2026 08:17:32 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 26 May 2026 10:17:38 +0200 (CEST)
Date: Tue, 26 May 2026 10:17:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Qualys Security Advisory <qsa@qualys.com>,
	Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>,
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH RFC v3 2/4] exec: introduce struct task_exec_state
Message-ID: <ahVXGuXiJywtSv90@redhat.com>
References: <20260520-work-task_exec_state-v3-0-69f895bc1385@kernel.org>
 <20260520-work-task_exec_state-v3-2-69f895bc1385@kernel.org>
 <ahBveiRasSfLAx5b@redhat.com>
 <20260526-halbieren-badeverbot-maler-d4bf1a6ea119@brauner>
MIME-Version: 1.0
In-Reply-To: <20260526-halbieren-badeverbot-maler-d4bf1a6ea119@brauner>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: h9Rcv8OME-Rb4j1qzVQwLC0u8GKENcvZT0Sje6sLX8E_1779783462
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0CE3040005
X-Stat-Signature: jyydcf9zzjzbqq98d3ysh74ykbug5mi8
X-Rspam-User: 
X-HE-Tag: 1779783470-824207
X-HE-Meta: U2FsdGVkX187C1eEwM3FC9E2Dsmxe3p3jVbQqHhNniN8SIofuNUZ25c4XlRJNb2NWxOrUOWQsgYb+cTb7MGUIvhQrL0sfaTFYCQKzmd0hoq1PfOC84mLzClaEKOZzxqBrefzXZ8sY8BmbP/Lp6j1Tm/xBaCdSs6mI10L9FgCCqOQck0Sqdvpdvy5ohQRcaWgQV0FPWXLx4If9nrgSPhyVB1L+yj/Z3N7DTQXVklp7GwwnVs/49KtFwRS4lMiXeTuI3P22a7LHylUeGDnY4zGyGV6ZPdhqwBToSsI58sgSYVMpJmQT6j9Fw/EzJoUgT0jk8TsUBxH7IE8ZtpAz8KeW4ITthdab42FPmtDCNXjI8ZYR06qCvnDhTcm3x2wA1SNqfSKO/5v9iFc4Z+MMYlVFZIso4X0GiA1eCSkZTysqTC4EJtFqJukehJar+6p4IlDzuZLPZxVDKSOQmdWw+wsjOAgJkUx5WgwXYraI78Y9l02dcREDZCNfqsXUQlJ0xYS8MG0eWQXzwa8I2Brc1tZGB4vfl9b/AbG6ntJtnz7+WeExwDK0gmIUMEJq1MUU1yTL68m68HcBmlJT0VuDOQz5KZ6pH4IjHx7eXVSFOr4+bJSEzhrCtimmnpUdEzAuL+VBvA1XCyvBdYugyC2yusyms60GPYX/EllBlkyrJ2h3LjouMjEksuG748EqYYErYJRjZ5QqTPUfWl1dnd3yEtoKuEgexqrUvVz9UrW17QxxfHa7VY3+w1VSSZz/gtw7TQjMssmHfng7GYCdJdlufMK76p/4RhdmC3aBi/wfVaaaPhvbkErO+cVn4wLRV34WbsnqazGP8XQaEgsDvD4RTtk1cN8BJowozMZJf01pav7ZokMYxOHCMhJv/v57/e+eNjeArBQ7fJ/4YXBkIpEhJOmgGBCXBMrk3fnAVsKihCQv90OVHfEMABJWSiDEX3GPLHpzOytuTeubOZaH2t/laC
 wefu5zv6
 sJ4gwZ8aeJgQSM5t5eGbR1PWwGAsN/M3Wl7T7zTQOaZGrJoM94QAues5PsSA6x+1o06miOQxC8Tkax+Vic9/2JDjQLbv4Fv0r/VnMHHD9RDeGodY5aU/k4BJaEcAMTnEoDR9FcN6aW/EQbDZmbHf2630S6y5qUdY6Td6Vzn+DvRUICEQQgFXSrSJ26rK6KRORN4gD3wjlfPHYrGwwv9tnBcTJyHisYzwni7XUKaDHZrtNiNUoAZQtebYZE+fAnDkaHJHqCseNCEvWn7FrjB/7UAEj3AbnMPjPBi0XFXnZvk+nB2pIdNjr6xlN2U/b5Xru+89mbr0rZrO7l5do588yFiTlyj6xwqm47Sr33oGqzl966oL7CNYl/ih5WLpdxN2PvsmI+n2B8Ezg5/ocUvkm3wBsJrxHocwO7fHbE/Bexavf6VMXNFjmST+VfD4Wv1CROv06
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/26, Christian Brauner wrote:
>
> On Fri, May 22, 2026 at 05:00:10PM +0200, Oleg Nesterov wrote:
> >
> > Can't we (later) move exec_state into signal_struct?
> >
> > AFAICS, the only complication is that task_still_dumpable/etc can't use
> > tsk->signal->exec_state if tsk was alredy reaped (another thread can do
> > exec_mmap() after that). But perhaps we can rely on pid_alive() check
> > and return an error if the task has already passed __unhash_process() ?
>
> So Jann pointed out a problem with this in
> https://lore.kernel.org/CAG48ez0Gz_GghVeVzaixAQRNYBdWHYEj3K6FXBSzc+8WNsFxtA@mail.gmail.com

Aha, thanks. This is basically what I have said above.

> I quote:
>
>     I think signal_struct is not unshared on exec; so in this sequence of events:
>
>      - task T1 is a non-dumpable task
>      - task T1 creates another thread T2
>      - T2 exits
>      - T1 goes through execve and becomes dumpable

Note that T1 can call exec_mmap/etc only after T2 is already reaped, that
is why I said we need to use something like pid_alive() check.

OK, lets forget it for now, this needs some changes in release_task() path,
perhaps makes no sense.

FWIW, your series + additional fixlets you sent in reply to 0/4 look good to me,
I see nothing wrong.

Oleg.


