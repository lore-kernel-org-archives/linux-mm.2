Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 483B060A2620
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GrCxvm/1
Received: by kanga.kvack.org (Postfix)
	id 7024C6B064A; Thu, 19 Nov 2026 08:34:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DA776B064B; Thu, 19 Nov 2026 08:34:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1916B064C; Thu, 19 Nov 2026 08:34:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 349A76B064A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:34:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E6FD140A8A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:34:21 +0000 (UTC)
X-FDA: 85451962722.01.C8545B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0006240008
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:34:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GrCxvm/1";
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795095260;
	b=C6AUGQ8/rrX42ahePGFACiva+a6rEJP7vjnOgXOKWxC/Hh0xWiiBhOMWiUsSEpChTK9CQE
	LUgEIO+ZSyJ8uqjerkSEm3w4HfH2HXGzQTUpFQXQ98eo314E1+M39Uv3lu2ld5jLio7aF3
	sgmJ0igmb/5Ts9RgMmwMOEl0PoSED8M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795095260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZEhJOzyXKju3tKMEHQwkNUXNp0T51VucdQQfkmvqiQM=;
	b=DUYQWHRPNOipSjeZrG2kgDXrvaRSX3CzP5gg4ion0D0EqKipEk5qycjWJCa067cuuUIEsM
	AJQgiM/p7rPhcUXz0X0h740mKntD9ZWTPFiH8TOvuNgpV2yxj9uK/haHVpBOMheHqefLo1
	vGXymFhFvKHG3dwLBa/hEmUJlPPFeYY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GrCxvm/1";
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D3F9E46053;
	Thu, 19 Nov 2026 13:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FAA1F000C5;
	Thu, 19 Nov 2026 13:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795095258;
	bh=ZEhJOzyXKju3tKMEHQwkNUXNp0T51VucdQQfkmvqiQM=;
	h=From:To:Cc:Subject:Date;
	b=GrCxvm/1lTIpcplkRdycUOpd8LVxmcPVO6UlPCcpghV8chsq66wX7A7O7TxLup21a
	 pWIcbGGSrVmxkJTuFAJgNiOVC4ou3TGAx8Gmgh2LFsrtjcM1eYJ/sqRT7p+z09a5Ku
	 +FkxP7Y4U+dV7F9m3UXNaWI544KdtoU5vOTRGSbMCrIrWYHK7h+NtQUXQHr/IZaZjM
	 qv0yO2QAK4wQBVFeiYu7q0dMivT1CnGyBlmaULCWxP50XnjNFaACPP/IEUAgaYRg2e
	 1uX5zf32+m1tKzZO5Hsp1MBL8GjysMxL372SXHLPLsPpadYgh/NfVjrC8Bx5G//qwU
	 Soeyhs3nmUgpQ==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	bpf@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	lsf-pc@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Vlastimil Babka <vbabka@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>
Subject: LSF/MM/BPF: 2027: Call for Proposals
Date: Thu, 19 Nov 2026 14:33:58 +0100
Message-ID: <20261119-lsfmm-2027-cfp-b7edcf7eee48@brauner>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4868; i=brauner@kernel.org; h=from:subject:message-id; bh=cENfH9cFzvlCJSmEwugWKvbkFTl+BgVyZRO6iqPrl+M=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9+3VG1DDxxd21Poei9nSxHb701fr/tFS26NI9pTvER DV/vPD37ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhI/X+G/2H/jtyIlWyy/Kzx pkTjrv7suc3aO9J/f7a59nzzxGs/iw4xMnxfnLzy8SvWLZstLi0+oXpXekH66ZjLC5b3zF69ztR vrjULAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0006240008
X-Rspam-User:
X-Stat-Signature: 8ju1cpska83q5fa7e8u7j6rhfwnws97s
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795095259-72738
X-HE-Meta: U2FsdGVkX18ECxRW3AuDLKQ55RGkntYZxAInUPPPiXU2/jC5iwZy8Om8Gr9VRny718Z9pReODuTHigqmb/RtBW2OCw0PgmjJMHhkBCRwgIAiY1Mb1zPK5ERC2xI61vbe2OBKtuBBy0paikxrvNn+94DN9W60UeRRxXLCbOgdgZlJyHdHNnjnXTlixMthAjVeQLmWNVS7w8mT2eDK2UYbBUU4X5gSEwrB0uv7Wb4kpQJYdXO37NIs4lUAhwNU0yyuMNz2rZD815FHws2pq3xNfh1EVXv66nK8AjRgWYjgsVePEE5bwHGpFwk4Q3P4Jc9d+upLzLDP/4hZZ0TkBxnVgN5l+BFaItbPzfkw6qHdwdPZTKNRdAwxBAZM1Y/vKDRxGxk5DFBvIH3rKr2OP69NiYGC5miL5m1ZUwrwrHbBChm6pudwkt7JPqYiJf2do/zUIJ9ZO4DyQvwJ27FjncWGQ1e5uyJIYqGZFVMilR4Dqns+Up1zblsOkTPwKGPJ0FMK5JTtLGlND5zLLbzgUHy+yibOEKXfcWlGcrBRtohbmR8o/ALAlJK3Ptvro9nq3b2ftL8YDEOCzVJFlBbwn8InRpQ/kAuQpqVcUtOsL4pOqUNx9omUmyj11CJF19clvF9+sdva5W577FEgGWlTucB7qdQlO93y3N6GMk3CAlgMbw18zDucmlwblpBhEDCVrU3pNO25SwDAh7p1PhwoSlat7+TtGsZsF3BaqRVprc2/xBnaN9IxM45zLxEhoKjAHYIbldzA7RhhMB0XUrqvIyoTte+JDFpMsKbYM6X24sTEm7YFNxtNjVr2lUENDWQ6D0LYjjYwM6HPLiypn8ZS7Zm6u/KD7wjD9oY9EL+4xPtIuX1NVBhc280I08ImGSwmbBEjIKQpf8ovbrJf/tvcYXxzDZdwV5W2mcc7HcmWacm0Wxr/BXxbgFxLIDtE0L+0sdxgnBjaGIzVa0qCG2PHO+M
 mEyuLDb+
 WDDOBt5nN1fcDMS/zc8AOEVzlN8jLEw27yiD6WYS0op1hisiozgW5Ddd3m8OVdV05QMxiLqhGZlQGC36E68jQkpS9ASAJGt5kGeU4sTDb2t+HSGXm4JsyJAJctqAJOTyOco5knXWYljuOfPYriZYvd/Rx3rnsfrBLEd05/DeTHf1l4eN/fnzNWvCAVW1r69nSODeFsGLSO7kowEDuz/Y+lS2CB+8XObqCQPETpCNSKvin91Rjs+OVfNQqEoSNUZfTPedi9W9Hy8JJNfz0biTq8t/i0Ipr9cGDDpDt4kbQInVpBdv+MMzzYpRSUSFAe4/3sbgBKyWSJQxe8rLj6FkL/Jvjixo5NVpvB8UwOU7pbJE2fBGGX7fChozyj15asJiLrIIWfY8W1SrRGOv9/hx5IK4qYedYfRW1jlA7nFKt8MqSVmw6kx6qLgNKjUULdeOV4nzUMT9EiVH0CUrQiyjByEjBStuCRVHLTZkuRyJTAoyWTanXevbgzUQCMMU1OO7gJf/TAk8ULQMPdhMyN5sY6UCwNh5u7Al4TXavCQf7ttQn2qpjJHdCUheguy3zsY8HdsxvjvfCowXwQXc+QCxV3+qDDVFryru/XRysejhs9lP+XTc9fGk3a9zsR1An0mW/Am5hh7eHXM6B8mXZpSFcslwQPyAztjhtJikPGmza9XIRaS0z3M7c0+WRu5wrVjrTe9w5LpBAVGNn3sTeDUAAtgIEZJDqPwSdZDZlMPBkT/J2ZM4kvEsKBKbiE40TF7yO85cm0AhsuBO0nF0QlNH0v+5RC8bssJl8C2debYLrWf8X3MYGhEQXZQagnD+qMpYKFRPifMTC/m+MZ2CjGSvir8Pa+9tYclNP+JhggpiTGtXxtER9yWawBDAoTeMEz1hkSnjC/1YYbVfTOtf0/2BVshqZ3PgmENXARNRorW3yIkO0GueGCGTVCUFIhn05yyLbV2xeoU7sgeuyCG8bdJLz5Hwd4jAs
 EXMHea52
 /c3d7og+MAPeBtKAyJPbHr5IjC6bUvun7cFq7OFmjLfKR1+vry7nPSdKGVmEEYa0uRonVPOzQktAozN13GD6ZQPAdMCdID2aJdkA0ouUUuc1Gl/9IPTeJx96Lqqngsrm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The annual Linux Storage, Filesystem, Memory Management, and BPF
(LSF/MM/BPF) Summit for 2027 will be held April 27-29, 2027 in Porto,
Portugal.

LSF/MM/BPF is a small, invitation-only technical workshop for the
people who develop and maintain the Linux storage, filesystem, memory
management, and BPF subsystems. We get together to work through
problems and to map out improvements that will make their way into the
mainline kernel within the coming years.

The summit runs for three days and has four subsystem-specific tracks.
Topics that touch more than one subsystem get joint sessions with all
affected tracks in the room. You're welcome to sit in on sessions of
other tracks too. There's also time for BoFs, hacking sessions and the
hallway track.

The sessions are supposed to be interactive, inclusive discussions. The
discussion leader outlines the problem and then the room works through
it. Slides and visualizations are encouraged but please refrain from
lengthy presentations.

The agenda is built from the topics proposed on the mailing lists. The
discussion a proposal gets on the list helps us figure out which topics
are important. The program committee then selects the topics and sends
out the invitations.

Attendance is limited to keep the sessions productive. When you request
an invitation, please tell us what you'd like to discuss and what
expertise you bring. We also want to make sure that people who are new
to the community get proper consideration. So if you're a maintainer or
have been around for a while, please nominate newer contributors in the
form.

LSF/MM/BPF is an in-person event and we don't offer general remote
participation. If you're needed for a topic but can't travel, let us
know and we'll try to find a solution.

Important dates
===============

    January 27, 2027    Deadline for invitation requests
    Mid-February        First round of invitations
    April 27-29, 2027   LSF/MM/BPF 2027 in Porto, Portugal

Venue
=====

The event will take place at the 

    Sheraton Porto Hotel & Spa
    R. do Ten. Valadim 146
    4100-476 Porto, Portugal

Do note that for this years iteration it is of the utmost importance
that you make use of the Linux Foundation hotel block.

All further details are availabe on the event site:

    https://events.linuxfoundation.org/lsfmmbpf/

Requesting an invitation
========================

To attend, please fill out this form by January 27, 2027. Proposing a
topic on the list without filling out the form will lead to us discussing
it without you!

    https://forms.gle/hhC9zXMsAJCR2dda6

In the form, please tell us:

    - what general areas you'd like to discuss and what expertise you bring
    - whether you need a visa. We handle those requests in the first
      round of invitations, so please don't wait.

We realize that travel is an ever-changing target, but the requests
help us get an idea of possible attendance numbers.

Proposing a topic
=================

In addition to the form, please send each topic as a new thread with
[LSF/MM/BPF TOPIC] in the subject to:

    lsf-pc@lists.linux-foundation.org

and Cc the lists that are relevant for the topic:

    FS:     linux-fsdevel@vger.kernel.org
    MM:     linux-mm@kvack.org
    Block:  linux-block@vger.kernel.org
    ATA:    linux-ide@vger.kernel.org
    SCSI:   linux-scsi@vger.kernel.org
    NVMe:   linux-nvme@lists.infradead.org
    BPF:    bpf@vger.kernel.org

Please use exactly this subject prefix so we can find the topic
proposals when putting together the schedule. The mailing list
discussions will be linked from the schedule so other attendees can get
a sense of whether a topic is of interest to them.

Previous years
==============

LWN has covered previous iterations of LSF/MM/BPF extensively:

    2014: https://lwn.net/Articles/LSFMM2014/
    2015: https://lwn.net/Articles/lsfmm2015/
    2016: https://lwn.net/Articles/lsfmm2016/
    2017: https://lwn.net/Articles/lsfmm2017/
    2018: https://lwn.net/Articles/lsfmm2018/
    2019: https://lwn.net/Articles/lsfmm2019/
    2020: 404 - Cancelled by The Plague
    2021: 404 - Cancelled by The Plague
    2022: https://lwn.net/Articles/lsfmm2022/
    2023: https://lwn.net/Articles/lsfmmbpf2023/
    2024: https://lwn.net/Articles/lsfmmbpf2024/
    2025: https://lwn.net/Articles/lsfmmbpf2025/
    2026: https://lwn.net/Articles/lsfmmbpf2026/

Program committee
=================

    Kanchan Joshi      (Storage)
    Martin K. Petersen (Storage)
    Christian Brauner  (Filesystems)
    Amir Goldstein     (Filesystems)
    Jan Kara           (Filesystems)
    Vlastimil Babka    (MM)
    Matthew Wilcox     (MM)
    Daniel Borkmann    (BPF)
    Alexei Starovoitov (BPF)

Thank you,
Christian Brauner

