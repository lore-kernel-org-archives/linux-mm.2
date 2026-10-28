Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26A52606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LM2Iui4k
Received: by kanga.kvack.org (Postfix)
	id 4543A6B05B1; Wed, 28 Oct 2026 13:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405736B05B2; Wed, 28 Oct 2026 13:57:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31AC26B05B6; Wed, 28 Oct 2026 13:57:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0DA6B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:57:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CA5EA72E4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:57:15 +0000 (UTC)
X-FDA: 85372791630.12.EC40C6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E6B6BC0009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:57:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LM2Iui4k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793210234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=he9R0+zwy1kJdSQ+18m+O8g+ZftkvP66i5BPO2efjII=;
	b=h+6KftaNIGN8+56W1sau+FjdF7ZR/hiaMD4HWq8jlQtH8RHj4YeWttB/vJxd8pLDSDJpYp
	hQ4Spb8LRc2dl8Njoo37K64PApjZ8RHv/RltFRA+LUz0GGLApk8xOX80sELG0qvvCKuTbR
	EtNMMAgeU9KgT4lis10RJ8zHrRDekXI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LM2Iui4k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793210234;
	b=uQ5n/ULOc45NrugmViXvamWYdjv9fFotWwAhKh5lmEnp2LH5sPLROdJdyee6H4ATQqeAco
	9sysl+GBc1ruBTzUyVAMdTeJEsUlkEagR2Ft7P6cgEkXuP1GzLRKEhjFjuuuBqITd+qE9x
	39ekdHXUpwgl9A92YkueXJ8zD/XR5Vg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36764435F5;
	Wed, 28 Oct 2026 17:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C241F01825;
	Wed, 28 Oct 2026 17:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793210233;
	bh=he9R0+zwy1kJdSQ+18m+O8g+ZftkvP66i5BPO2efjII=;
	h=From:To:Cc:Subject:Date;
	b=LM2Iui4k0AA2176MJZKQkqYDXSz4cQ+1ELOn8IzuiESt+qqYyIxOLnwy7lm16gL3i
	 uK5kzRiCQnwso6Dj6dlLtSLCq7qG5crpJ0fyNbPy0+/ZZxsVEhPoXW65xg5kHE9pRx
	 VigvUKU/z5C8FdA0da020kXOYLzyFotu2o8ZyPhgZQJUOQHyVznhsdRIvsVAiH/j7L
	 Zlv6N0ygZKNH+SV21OOWEapClHpTUGpGa4nWAMX4OttERmpuPH7pPH74x6x6k/lZeN
	 gnNUbdnJTQgU18iVNsjpFOCekM8s1iQHKqfdxVf1JdUUlbR3TBYtR/h5sxXIKCgnGi
	 W4Yb1vhy1PhKQ==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Luca Boccassi <bluca@debian.org>,
	=?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@stgraber.org>
Subject: FOSDEM 2027: Kernel Devroom CfP
Date: Wed, 28 Oct 2026 19:57:03 +0200
Message-ID: <20261028175707.905913-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E6B6BC0009
X-Stat-Signature: sjpeqk8kgmsrmzpq7mrsn78qe1fix8sr
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793210233-34017
X-HE-Meta: U2FsdGVkX1+/JzbtAOTmKMRbT99LWIK7Hex295KnRft83pSglribC7LYFuNAMeDZGYXGQ3bdhiz3hBL3zF67XsWthK6qFOIyMDS1xRO936U6fRrTC+I3vs2IzMf+WY5QeOIfKhb5qmWbUlGVxuNZts3x61h7nNGayf1BGVplxC42NyjweBvmo0A2d4jbGGQb82YihN4zhaMBQZ1dM9ByzmKxS8BTc6PzTl040EkJiZtJJHAB1OgGgT2+g3+Lu9W2sBnPTwjWyzRjos2TH2QZvVHiQErPRJxukeHCCFMLI1xppRiWRdeCp821RRPVv9h6qFgZCEeGwGPfcqREtj/gqRJlMAWqflmILsWYesyxJmx1k1yN6Bar1AjKAWaN4wqQ4RoY/MFM1xzxAhUB9fYYcu1BlfTz1y2zf8Z0+lf8nV8FShoe9HN1QM+zQxJrSJEiRA/JSUSoXUuIf8JbldukpcLcPu0oB5QIJiJ3moIvyB/RW5nppGLdIw2TQQVt5qgBiVCDmFBMCk+bBLgQh5Q2TZp8bG4U7RBjfydcabCm8grOacy/qCHq9D7Qd+QymKK7bQRpaDDFMrYi4kW6/iah8lRo1+si9IX5Qw3CXzPJxPoz50fLqRBYY4vSvwm838MDPre5BvkRtHZDxymXHbSbPzrb6QK5ojN1ZhqMWxci/48VHduNEYqpqDupQDNv0BMNEplnz+TwPQi/sMZEaGztNX3Pq54hyNotpqr7SV2npF9bI2VaYwUgRRhoRZsu1FQYl0I303dGgAoldp9NpQszFOPfAwei0dXMmUxcKIeybTjPCeFdjuLavsLAdVxV46KOCXzrXt5kk8XvNWJF/SsyT7eHja+o3bnUDv7T6Hkxc51Jstd2Kolooj0Y13sqZhh5W/0BLBtG2VS+pjGTvt8teRF2kDJgeGsFRvNCdsiZpbnFz4bl8j79E6dr1N5g+ZJKGAOdqIQtAYOQD4oGIM9
 VuO2mt2c
 WOai4D+xvrdZJKS8tTPT4XkJksgD/FbpSCc656iMJsdJFbHya0SyLp7E5GmX++J1Ti0ySsXUKaBL7Y+o8XuAuVY5lR7ILLi2os8K5qD5hffJmatrk690hUdBa1Rrn20/XXtmLpvfhrTaOpQ1SINzyadK+jkTaqxGTGDITDVeAXU+yiz0rDhKYoBhboX6A+PiFEjyg7p2sAHZM74d8Wqlhnf0IK5Xlu5ri7Kafdbftp6yVXtce8fLHRxokVoLUTCrq6nXl31ePxkvYBG+Q+MP9akVWlmQSZS1da6yfqqlwQNfY6KUFJH7H1nc8/JM+9R15wzANkKzLCRD50WHnsKK/Lli0Ru+Yqhi4Z+xTt+Q8hHQpc/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi all,

We are pleased to announce the Call for Participation (CfP) for the FOSDEM
2027 Kernel Devroom.

FOSDEM 2027 will be over the weekend of the 30th and 31st of January in
Brussels, Belgium. FOSDEM is a free and non-commercial event organised by
the community for the community. The goal is to provide free and open
source software developers and communities a place to meet to:

- get in touch with other developers and projects;
- be informed about the latest developments in the free software world;
- be informed about the latest developments in the open source world;
- attend interesting talks and presentations on various topics by project
  leaders and committers;
- to promote the development and benefits of free software and open source
  solutions.
- Participation and attendance is totally free, though the organisers
  gratefully accept donations and sponsorship.

Format
------

The Kernel Devroom will be running a whole day; the exact day and time
will be clarified in the near future.

We're looking for talk or demo proposals in one of the following 4 sizes:

- 10 minutes (e.g., a short demo)
- 20 minutes (e.g., a project update)
- 30 minutes (e.g., introduction to a new technology or a deep dive on a
  complex feature)
- 40 minutes (e.g., a deep dive on a complex feature)

In all cases, please allow for at least 5 minutes of questions (10min
preferred for the 30min slots). In general, shorter content will be more
likely to get approved as we want to cover a wide range of topics.

Proposals
---------

Proposals should be sent through the FOSDEM scheduling system at:
https://pretalx.fosdem.org/fosdem-2027/cfp

Please select "Kernel" as the track and ensure you include the following
information when submitting a proposal:

- Name(s): Your first, last and public names.
- Speaker bio: A short bio.
- Photo: Please provide a photo.
- Event title: This is the title of your talk - please be descriptive to
  encourage attendance.
- Abstract: Short abstract of one or two paragraphs.
- Duration: Please indicate the length of your talk; 10 min, 20 min,
  30 min, or 40 min.

The CfP deadline is Saturday, 5 December 2026.

Topics
------

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

Code of Conduct
---------------

We'd like to remind all speakers and attendees that all of the
presentations and discussions in our devroom are held under the guidelines
set in the FOSDEM Code of Conduct:
https://fosdem.org/2027/practical/conduct/

We expect attendees, speakers, and volunteers to follow the CoC at all
times.

If you submit a proposal and it is accepted, you will be required to
confirm that you accept the FOSDEM CoC. If you have any questions about the
CoC or wish to have one of the devroom organizers review your presentation
slides or any other content for CoC compliance, please email us and we will
do our best to assist you.

An up to date version of the CfP can always be found at:
https://uapi-group.org/docs/conferences/2027-01-30_fosdem-kernel-devroom/

Thanks!

Christian Brauner
Luca Boccassi
Mike Rapoport 
Stéphane Graber


