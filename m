Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EA2FCAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 17:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC4088E000A; Tue, 16 Sep 2025 13:09:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4EAA8E0001; Tue, 16 Sep 2025 13:09:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15E48E000A; Tue, 16 Sep 2025 13:09:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 970F78E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:09:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C9E71DD8EC
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:09:46 +0000 (UTC)
X-FDA: 83895750372.26.CA64584
Received: from smtp112.iad3a.emailsrvr.com (smtp112.iad3a.emailsrvr.com [173.203.187.112])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4D57D140006
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:09:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.112 as permitted sender) smtp.mailfrom=dpreed@deepplum.com;
	dmarc=pass (policy=none) header.from=deepplum.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758042584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jp0lGQUO6tKCulfsQ8dirXWIEhTA1ZW1LFSxcp2oA/M=;
	b=xZJqf7C75wl11mEtxv3AbxEgyoBVmB20F3QDGsOGj04UHGhEoOuCJcAo6N7EXkMKJ+VgXq
	CI6H8yoZjhSytBdEGxNXTOHOaNxLIEoyVTuzITbdDUteEPU7HDiDJXocqUNFYnt6f1b++N
	YNLbUk7aE8xvovxqlZyqNresyeej4p8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.112 as permitted sender) smtp.mailfrom=dpreed@deepplum.com;
	dmarc=pass (policy=none) header.from=deepplum.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758042584; a=rsa-sha256;
	cv=none;
	b=O8M0Xi+TF18sDqS/GrVKTuVYsw4FeQkTOYL1yHKEtgpz7zZyQIb3Q7xp9DTwLSefYGMIi7
	O9zPqP2WbLuLsOb669yeXL7krimyMWceb/Xjp/kj3Nb02N7U5G8pu9LM8YbCa+LixKMovm
	Ax6R053gWLucqJmKtMBOXb/BFMYA08s=
Received: from app57.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp39.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 3ACF65808;
	Tue, 16 Sep 2025 13:09:43 -0400 (EDT)
Received: from deepplum.com (localhost.localdomain [127.0.0.1])
	by app57.wa-webapps.iad3a (Postfix) with ESMTP id 1B8B3E00C6;
	Tue, 16 Sep 2025 13:09:43 -0400 (EDT)
Received: by apps.rackspace.com
    (Authenticated sender: dpreed@deepplum.com, from: dpreed@deepplum.com) 
    with HTTP; Tue, 16 Sep 2025 13:09:43 -0400 (EDT)
X-Auth-ID: dpreed@deepplum.com
Date: Tue, 16 Sep 2025 13:09:43 -0400 (EDT)
Subject: =?utf-8?Q?Re=3A_PROBLEM=3A_userfaultfd_REGISTER_minor_mode_on_MAP=5FPRIVA?=
 =?utf-8?Q?TE_range_fails?=
From: "David P. Reed" <dpreed@deepplum.com>
To: "Peter Xu" <peterx@redhat.com>
Cc: "James Houghton" <jthoughton@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 linux-mm@kvack.org,
 "Axel Rasmussen" <axelrasmussen@google.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
In-Reply-To: <aMmMnfU-Koopc9mL@x1.local>
References: <1757967196.153116687@apps.rackspace.com> 
 <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com> 
 <1757977128.137610687@apps.rackspace.com> 
 <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com> 
 <aMl4qLyNovWHhty9@x1.local> <1758037938.96199037@apps.rackspace.com> 
 <aMmMnfU-Koopc9mL@x1.local>
X-Client-IP: 209.6.168.128
Message-ID: <1758042583.108320755@apps.rackspace.com>
X-Mailer: webmail/19.0.28-RC
X-Classification-ID: 9dcbf7fb-7473-485f-8f3b-e7a452678835-1-1
X-Rspamd-Queue-Id: 4D57D140006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 6rmnzeqtu49mzbm5pypmq3hihbuwxekh
X-HE-Tag: 1758042583-473517
X-HE-Meta: U2FsdGVkX18g8t4V03mUN+xqfCRVflOKzSdLpMsUGQoUfNKn6mo/VVRl/h40g53GL+Qkuwte5NwsVtfl9FRx/buQAlvj2/QTJYCkTXygu8dUNekmFvlxB4Q4ixRLimiIko87Nx3l60SNF+1gMVzMqAHZZlhteEQABZ5cPwSNotlzYE0oQv0uLDYBKkak2NQyMe6SNr43IWDZxrNuySegSLUvomUeHAE77tpa2WfJ36bWgS2ACXGwr1EIiEaWUsryFjOEVYzxf1C8WHTcsDmcqSzddq4F9QYV2n9r0aR1ouLCsEdoZGSfA16xA69U2kiFInyOVWVdSiEZP+nRuU/3/t8U+e7XuJoT6EBzZ6gliFNbqcyjWC4ruJDNVIl3aXs2oU3MWdpH6VNcaq4QkJMuFeu5SYM1ZtdVq60eANq0Y1kehhtrVPKrkibgJ8xm4OMDnva4pSk9vJW5sM9gxIDKbBOJwh5aHiRQ4uedOYnMHcStBSGLARAgQMcMHZBYAN0clJYCui9eVsllw6fhxOF2bijEmF9dXPLdOWI2jFGRktksN17STeooMnnI23h4Ef7LHU8GiMQFsJ+rScV8BCbTq4YjdZdwJEtDCqul40X2cwndAyBOmud8dGtm+c++nOVpcIQXhyLpoIfSPRF1gwS8ClUVZOPLZSScWYwMNwiK1thOBhDxxz9QrZ+RpkuZ1XGmevsl4aCL3lrIK9fkVvGyzjTL/3x8e2DY2gbMy78P5VULH3iqO+JUK02sPtAwlgPzSVfY0/mN9/ZUxIjNA3owCN72AHsHDZrN282zZkZsqmHLaeKlas+xxgjVhSBFA5ao0TFDE5ZMEZf8zo5WluT3d0yDHq5/+D42oEilyxhArqhdeTuv9JTod1BkSYHCU76/eqdLeH3yWYv4wztApoPqv498WrDEnyhVXfh5MSKK/iXyspUjHCcA/0jYa1U+kA2V++W8mDpHdG1j8ECYz02
 F+wj6Tzl
 SUygx3FJIo8KQS3mGGSwqswhJJ7CRLSs7Gs2Me3w37IV7i/6W6q597PLZVE87VojZLQO6iOSOEQxc8ctePpUkc35sJPnrtQHIlxFc4XiKI2hp0VuRob+apGyU7puTk/l76sqtm00qZUALizQfsyKbMQ9267X+MCHYlpJ1iDYGfgvgc32TmFtizyzfWCxEk4RwJRPyAxg8dKznxuYBabpZJnSxM7tPJ8L7TPv5QQZKXPnyQuH2xZ37w5PmQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Than -=0A=0AThanks for your interest. Some clarifications on my current use=
 case are interposed below. =0A=0AOn Tuesday, September 16, 2025 12:13, "Pe=
ter Xu" <peterx@redhat.com> said:=0A=0A> On Tue, Sep 16, 2025 at 11:52:18AM=
 -0400, David P. Reed wrote:=0A>> synchronous would be better. But what I w=
ant to do is at least get=0A>> notifications of swapin events (including th=
e case when the page is in=0A>> swap cache). Also, using UFFDIO_COPY can be=
 useful for the swap in case=0A>> might make sense (but rarely, because the=
re's no way to access the data=0A>> that was swapped out).=0A> =0A> Some mo=
re info on the use case might be helpful.  I can start with some=0A> more q=
uestions if that helps.=0A> =0A> - If it's about page hotness / coldness, h=
ave you tried existing facilities=0A>   (page idle, DAMON, etc.)?  If so, w=
hy they won't work?=0A=0AYes. Those functions are just summarizers, giving =
counts and averages. They provide zero detail about specific pages to the a=
pplication running in the process.=0A=0AI can clarify my use case focus by =
pointing out what inspired me to use userfaultfd for application specific m=
emory management (which is, after all, what userfaultfd was promoted for on=
 Linux Weekly News a while back when it first came out). This 2024 paper is=
 along the same lines as what I'm researching, and was published in 2024 Us=
enix proceedings.=0AExtMem: Enabling Application Aware Virtual Memory Manag=
ement for Data Intensive Applications=0Ahttps://www.usenix.org/conference/a=
tc24/presentation/jalalian=0A=0ASee figure 3 of the paper for their perform=
ance problem with userfaultfd vs. their kernel modifications (upcall). =0A=
=0AThey had tried using userfaultfd for their work, and found it was "too s=
low" compared to what they call the "upcall" technique they achieved by mod=
ifying the kernel page fault handling path. (see paper for details - and Ja=
lalian't thesis dives into it more deeply).=0AI could code up an equivalent=
 to their "upcall" - but that would mean completely non-standard (and fraug=
ht with security issues, as well as not being able to use a separate manage=
ment process).=0AFor me, the performance concern is less problematic - I'm =
doing application analysis and experimentation. And I don't want to have to=
 maintain a kernel patch set.=0A=0ANote that I expect to use madvise() and =
process_madvise() to manipulate page coldness and swapping as well.=0A=0A> =
=0A> - Assuming it's async reports that can be collected, what do you plan =
to do=0A>   with the info?  Do you care about swap outs prior to swap ins?=
=0A=0ADetailed application paging measurements, modeling, and so forth.=0AI=
'm not asking for a big enhancement to userfaultfd - just expecting it shou=
ld (as is) basically work, if the UFFDIO_REGISTER actually allowed to regis=
ter the minor page fault mode,=0A=0A> =0A> - How sync events would be bette=
r in this case?=0A=0ASimpler to coordinate the interaction with the faultin=
g process by far.=0A=0A> =0A> Than=0A> =0A> =0A


