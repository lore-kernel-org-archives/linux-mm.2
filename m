Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0DD9C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0A3B6B0192; Thu,  2 Jul 2026 21:13:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1F36B0193; Thu,  2 Jul 2026 21:13:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1F116B0194; Thu,  2 Jul 2026 21:13:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A905E6B0192
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:13:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0DD391201E7
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:53:08 +0000 (UTC)
X-FDA: 84944431656.28.36589B0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6FB0310000D
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:53:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Big/Uh5x";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783011186;
	b=ZuNqpGkxtArI79VQEPcLNKaSulweGkBlN+ponwwFuqCmzTssMVVkSuc6jI1Lew5PGcTOr0
	QWSMkBWk+lFnHyP6yu8WlgQzF+p9cu3q8sCQWgep0OuRuoHZUtO74XBXj7Re9BDYq5QAqV
	+Q3B+exdAZKO0oV0tKdzRx/DdSvKG1o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783011186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AdFubk+JD40bWGnDszpUR8QtopM4gDG6s4W5ZjSbVSM=;
	b=XtVP8C1MCmV52MLnbojC5D5UQchiqfl9sSW8qnn78aBqnXiTs5MwrIiHKjK9rM+hLStao9
	Pv+zBuL2QK8x0Os7vozaC2kH9mNZ/bReqqs96vHDOmH7S8foaO7XcRcv4XiV7T9GZapWbk
	vWDFjvRzeD6ydoL/rkBj4tDiDoty0iA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Big/Uh5x";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D66A601E3;
	Thu,  2 Jul 2026 16:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FC41F000E9;
	Thu,  2 Jul 2026 16:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783011184;
	bh=AdFubk+JD40bWGnDszpUR8QtopM4gDG6s4W5ZjSbVSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Big/Uh5x+p9UFUyrs0H+TX8SkxXowLs9309ENEt2bZHNEFPVeSIvL00bHj+6bpm/y
	 s8udHbi4jszqqgXKeOlXpUA7KzmEVpFSNVFpyyDq6Q2tuQAlNTHZgadeL2wS+BpmDr
	 6duTpmSGL4zT1r1ioPN028UWP/YtE5PatvwARH4Ev47D7gXUxGX5zO/VlTN87FBAj4
	 1G3pLC0fuQw3cvxZISOhdXlr6cOuusPnuh2jpCqFPzERMGSM8ehDyvqT4qLyVPPXYT
	 mvmg6zxqVvnS0/yc+YD9yAa6o+SLV0TJiBWDgaGH2m4YDAPlF5N6U0oQT202lLwHRc
	 amVrZi3QepJIw==
From: SJ Park <sj@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Lian Wang <lianux.mm@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	daichaobing@sangfor.com.cn,
	kunwu.chan@gmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: Re: [RESEND RFC PATCH v2 0/5] mm/damon: add mTHP collapse and split actions
Date: Thu,  2 Jul 2026 09:52:34 -0700
Message-ID: <20260702165235.86684-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <akY6ZzPnwk-CToMp@lucifer>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bb3tojshuk5imcugurmg4ep14n74t4kp
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6FB0310000D
X-HE-Tag: 1783011186-308150
X-HE-Meta: U2FsdGVkX1/1cWVkalgSjuHVVQD/QDk/2RLI+wVy5YOnCO1psIhL91aNTmFy1vaUWtPT3xP7W5RxTw0A1Za7nPRot+U9c+xsRdJIdoPtAsbW2XdN/k0cuF5hFiFyfBK0ow3xDeuaeVg/v8CVSXH6YY6UT/suUKZcW6X0o69CHYB3hBtx5ebRVIMZhBhz69SFNkoEpZSqWpadYoK8hpaPfHvfrhu2h8G0zEduHp2S38sgtC9Y4l8Xy6FJkuXg5CIOOC9F8T5Ds+HifMRsrnknqvXctBarVQ3G0Br9rDfc+WV+gDNJkBDjWdQh1lBtNYXrZ0GV6+Nk48mu3QFD+lGwln8MngOWn3idRVgH3L2g0Qhqty/vqJS6JIvYA/K4I5ZHEdhtwFSlgqVydWkCjQB6IBaxARH9j3/PBuLuoagNA4WmcEDkkpBVHnO0UssWqaGrlilI+XrXB23lHyVKuTrqVt6Hlvlz7TIHCKbhp4uRI05OVwt2V8tUtio+sbjOu4EyNRLFmCBufKq9LwRmQ5Z0/rUsgRd4EkubwTplEDbg7bzCI/cHKEDXuXm5w2JHTKfZKPQuVjkTBvKpFS5+txCAHqoPTNohoJfhaF4LlmDSlWMZ2r9azznPpNuEYohVeufx6dQaRRpJ/XuB26XctK6mzejMYKNagWzFOCTUPwKya3SGMgbdkvhy56kDzRKT5O+RTc5sR7i9QvtqdMHk42hrIszT43R+ZHS2kFQOHstL5iUKNxAu94K+tw3K2OCXhygY2TDIx/fQHb3gKe2+/gMPCLTzLD2jG6AMee2IaEz7C5aq3qpj39nYuZD6/yLG+GgKDN3Io4A4Ufl04xuOT/kOg+KkZjowlKV3QSukZpHRZYpmiXGFQcjCE39aVGvVd7MBWWH2wEKmonYbbhWGkpAG+kamXBoWLSlJCNV1y+vW4LCdezrg2eXZPD2YyOtut+5YpCjQWmBmRNeJEe02AuR
 M7+tt/a1
 dQTSFG2ilj+i4UWAbv21Ci7UkIUC7bcs+UcFuPkfMyb1yrQ/qy7hnivszd40oa3ZAj61f9q0fx5+JdTBdsEmgzRJvm4GG+cTF95/DOkNUfsCmckZVLJrtR60wbCRicQlT3l8TzORLl7j22CzB3tJFBq93NWAUTs9UgWa+IZPpMUlCuO7eAtgWwbVz4H/EZFokIGYtaXRgDe7v6vOpc+H2m82dnHFWav863gQZql0jMmaXZviykJ5sXVPvG4iCHcNFTmixv+p/Nm/lrhORdMzxHJxnFRVCp24bgM+NzSwM0u2/B7X2wLTSV2xwOFPZeQvbW6kjYDn1lh0qDjMF1J9tQuKXV8i/TMe9Rfxo//3q7JtnGUSeX7gyqc52NxdfZAsNo84Gkq3bfdT3TXI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2 Jul 2026 11:23:55 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> +cc all those you missed.

Thank you for doing this, Lorenzo.

> 
> I really need to write a bot to do this, because I'm getting a little tired of
> pointing this out :))

Good idea.  I will also consider implementing this kind of checks to to my lzy
tool box [1] or hkml [2].

> 
> On Thu, Jul 02, 2026 at 05:46:28PM +0800, Lian Wang wrote:
> >  include/linux/damon.h      |  10 +++
> >  include/linux/khugepaged.h |   9 +++
> >  mm/damon/core.c            |   2 +
> >  mm/damon/sysfs-schemes.c   |  77 ++++++++++++++++++++++
> >  mm/damon/vaddr.c           | 128 +++++++++++++++++++++++++++++++++++++
> >  mm/khugepaged.c            |  46 +++++++++++++
> >  6 files changed, 272 insertions(+)
> 
> You are doing damon changes, and that belongs to SJ, sure.
> 
> But you're also changing core THP code? Please ensure you cc- THP people because
> without our approval this cannot be merged:

Thank you for calling out this, Lorenzo.

Lian, please do as Lorenzo kindly asked, from the next revision.  You don't
need to add those recipients to all the patches if you worry their inbox
volumes.  But do ensure adding them to at least patches that modifies
khugepaged.h and khugepaged.c, and the cover letter.

If it is cumbersome, consider using 'hkml patch format' [3].  It does that (run
get_maintainer.pl and add recipients to each patch and the coverletter) for its
users.

[1] https://github.com/sjp38/lazybox
[2] https://github.com/sjp38/hackermail
[3] https://github.com/sjp38/hackermail/blob/master/USAGE.md#formatting-patches


Thanks,
SJ

[...]

