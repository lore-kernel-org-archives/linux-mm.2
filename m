Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A529CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 13:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C83018E0005; Tue, 11 Nov 2025 08:32:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33608E0002; Tue, 11 Nov 2025 08:32:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B22608E0005; Tue, 11 Nov 2025 08:32:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A01B48E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:32:07 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 028E458C36
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:32:06 +0000 (UTC)
X-FDA: 84098414694.03.EE43476
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 64A53A001A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:32:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Rv7fQ4u/";
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762867925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=aHNyHA21xkUXdLLpPFtnEexb2IGz+Hpf/swp+DuT/l4=;
	b=18J5auT/qleey+hET+yuRprQNNHbgxODHSUKFNv2jFnFjY6NvOUzkxGSdLjyBZwEz1Szre
	EDie/P5f/7SOWyW8vxILO69W56Uf/1zJRPS6nUb7UPRFIRTvuZonVbbWM/Qjb+U+CG5JH2
	k5IHYMxQBZITcc37+Jar0/HIPBbD1cs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Rv7fQ4u/";
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762867925; a=rsa-sha256;
	cv=none;
	b=7j0Jl18ryPt9kFTFShXZPqyH8aAvFwAijKaMuBr+LRWahY8b4DvabNYN+sPX59rsSL88iG
	Fycpjjt3ORwAM0YC0Ye976brh1vvWs+DSV9HFtRleQWHSpdIQocyuhZuomZ46fIXOFdrdz
	kruQ9SUTRTbeHdaAD7rEgtYIgZpigK0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 83BE960224;
	Tue, 11 Nov 2025 13:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53EFC113D0;
	Tue, 11 Nov 2025 13:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762867924;
	bh=9S/7h0tpEhNa3W4t88n1LzGQmFNKsax0JY70Y6JvupA=;
	h=Date:From:To:Cc:Subject:From;
	b=Rv7fQ4u/JisLQd02bZ7vEob1RDj4MjZDt8gS0e2xo0PcoWJdI1iYdNkzB3W66BT+v
	 VoSI+6uysQW2eNXTf0HmsOuBWF66gQkeSNr9B7RGsEpJjcwnJTZQPUVPQG3++bZKDJ
	 MvLUh+A+1Von0OutzrLoPcfSC7ikB8baZyQEeeSDbV3ToY+88G8XMtK7WyhxtasKA1
	 OXSwKJj1pxcHiahz0xf+7/uobIcl91Hikcssw8dNc1sWCeTr7J+d+cskAyrtLo1eGR
	 xrDEBYSuGVTE4QNcdwMDX/CMz8dnOGll01RpKTyhULNFEYevQSoKdFcwZUru/gfuuQ
	 JC5AzPaXjitCQ==
Date: Tue, 11 Nov 2025 15:31:59 +0200
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Christian Brauner <brauner@kernel.org>,
	Luca Boccassi <bluca@debian.org>,
	=?iso-8859-1?Q?St=E9phane?= Graber <stgraber@stgraber.org>
Subject: FOSDEM 2026: Kernel Devroom CfP
Message-ID: <aRM6z7EU3sNljgx2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 64A53A001A
X-Stat-Signature: 8aaikqfnrai71f6pmutqqcmmid6tqc8s
X-Rspam-User: 
X-HE-Tag: 1762867925-897339
X-HE-Meta: U2FsdGVkX18lt2m8KsvQeTSV7sdpPgrm6zwYBd6QGyPovkO0WV7EG9CbxqJNWKT875pkF1unKOBhioY4ab3pu35EH5MP8VLUDZmVAHqd3Kn5ezmnnF619oXFpViZmydh+SXJkp/Hc+ds4MaikieWYgtZMss9Nn+ZB+rid17eP6jd9X7e/kzc09HPr7pOi6yXKDA9BJkfEFzd0LwZOMrhhna/GpPShFf2xkSVcqB2zVZ0seRaL44IOVbzQjpeWsIgnREk4FzLc8V2rWtsTLfP6sRcwdZmHxwQ4fcMxTD+naRr7GOBUi9wdLDKYMw6sQJcb3NuAmsPmUi157gEDYQBlKM6mLhQfU27jPKgdcPVGLRuEM13KbLDQZ98AKErC55drWXTOUiwxNS/zFBwibxe6bO7XllYTugzVNqVbB+LRI8wxGPxifKkmZ15TEFf83/Ro1bW2/6i+aPJ8bY5EGV0SL+zT4Vq4WNpLwebqwHQP6qPkamQmOYY+9dghZpkxbx3gvKfX1XTFHyEIWYX86Wt94695idopOjqzXXfOOYjKLeGjYO4X68LNSSXijCHFT2bW1VMXMkY1PGangyUns10IwadXUfzy+Xqx4dsmQ+VSxHY67unJOZKfYb1odCHFOG5waV6kcbiAwrvzUt+qnFmhJ/uJm+vsRUSlWX1Js90bJVIvgyyOhXGfRJS/Y4sVFy/lwPDu/k/iOAbXWrg65Vh7kwIGKQnAul6C4aorhLCEkE+84mJUaYmJAl0S0uNHxlxZS/8lRkWG197DFnMIxs5dWprcJ56daoZ8ZNnnQI7qIrWq1/W4QEeC4DmY4LcZRss6CC+9CljYvp9Y09WqOf9RQG+9+rkngWXejmopynuHkViDY0EXEuaOaRDTYIEMtGnlwgeyK289VWnuGGrWdpmhC43y7Z4qTRQ1gNKAp8gNwBbP+EC3exgrHZu8+Gue+B5WCLoMVweXyKmb0nr2El
 pTljQfJ6
 Jb4AGdlF3G4shsrV2jpe+Hdpzy7DI/ytnXIN3+Q93Ugon09Mu67OT3Z7Qqrl9e99EWZKMajyX01ekbTMXnFO2r9+202t0QAK+fKVsFX3yqQqKHsxjGEAf9xLkQPnWXG5Z+AC0XfkFA5XvgDsAYEVW+8zV2GIkCFV/mHp1SFVszQb+nLwyVJWyPD7sxkBJxVIofJziTfjHejRk9X96ra3Ywin7xKi4fsMJlT5PkAVVVLVvlXFco2v8t0d39OX3lYMsyfATHR9aRiPDgr/ZCAH6rZCJrXgChEDkXv64O0c9106x9SnxvMH/fH1B+n9wt9tGihwxw7JpR7n/Al17egugsoASd+9SsmTD2x0O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

We are pleased to announce the Call for Participation (CfP) for the FOSDEM
2026 Kernel Devroom.

FOSDEM 2026 will be over the weekend of the 31st of January and 1st of
February in Brussels, Belgium.  FOSDEM is a free and non-commercial event
organised by the community for the community.  The goal is to provide free
and open source software developers and communities a place to meet to:

- get in touch with other developers and projects;
- be informed about the latest developments in the free software world;
- be informed about the latest developments in the open source world;
- attend interesting talks and presentations on various topics by project
  leaders and committers;
- to promote the development and benefits of free software and open source
  solutions.
- Participation and attendance is totally free, though the organisers
  gratefully accept donations and sponsorship.

## Format

The Kernel Devroom will be running a whole day, exact day and time will be
clarified in the near future..

We’re looking for talk or demo proposals in one of the following 4 sizes:

- 10 minutes (e.g., a short demo)
- 20 minutes (e.g., a project update)
- 30 minutes (e.g., introduction to a new technology or a deep dive on a complex feature)
- 40 minutes (e.g., a deep dive on a complex feature)

In all cases, please allow for at least 5 minutes of questions (10min
preferred for the 30min slots).  In general, shorter content will be more
likely to get approved as we want to cover a wide range of topics.

## Proposals

Proposals should be sent through the FOSDEM scheduling system at:
https://pretalx.fosdem.org/fosdem-2026/cfp

Please select "Kernel" as the __track__ and ensure you include the
following information when submitting a proposal:

| Section |  Field       |  Notes                                                                             |
| ------- | ------------ | ---------------------------------------------------------------------------------- |
| Person  |  Name(s)     |  Your first, last and public names.                                                |
| Person  |  Abstract    |  A short bio.                                                                      |
| Person  |  Photo       |  Please provide a photo.                                                           |
| Event   |  Event Title |  *This is the title of your talk* - please be descriptive to encourage attendance. |
| Event   |  Abstract    |  Short abstract of one or two paragraphs.                                          |
| Event   |  Duration    |  Please indicate the length of your talk; 10 min, 20 min, 30, or 40 min            |

__The CfP deadline is Saturday, 10 December 2025.__

## Topics

The Kernel Devroom aims to cover a wide range of different topics so don't
be shy. The following list should just serve as an inspiration:

- Filesystems and Storage
- io_uring
- Tracing
- eBPF
- Fuzzing
- System Boot
- Security
- Virtualization
- Memory management
- Rust in the Linux Kernel

## Code of Conduct

We'd like to remind all speakers and attendees that all of the
presentations and discussions in our devroom are held under the guidelines
set in the [FOSDEM Code of
Conduct](https://fosdem.org/2026/practical/conduct/) and we expect
attendees, speakers, and volunteers to follow the CoC at all times.

If you submit a proposal and it is accepted, you will be required to
confirm that you accept the FOSDEM CoC. If you have any questions about the
CoC or wish to have one of the devroom organizers review your presentation
slides or any other content for CoC compliance, please email us and we will
do our best to assist you.

An up to date version of the CfP can always be found at
https://uapi-group.org/docs/conferences/2026-01-31_fosdem-kernel-devroom/

Thanks!

Christian Brauner
Luca Boccassi
Mike Rapoport 
Stéphane Graber

