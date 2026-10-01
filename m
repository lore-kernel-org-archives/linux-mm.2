Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AF9ECA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 12:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C5636B008C; Thu,  1 Oct 2026 08:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69CF46B0092; Thu,  1 Oct 2026 08:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B48F6B0096; Thu,  1 Oct 2026 08:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 370D46B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:50:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B63C21403BF
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:50:46 +0000 (UTC)
X-FDA: 85274041692.15.A3A3ED6
Received: from mta0.migadu.com (out-198.mta0.migadu.com [91.218.175.198])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7C59714000B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:50:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jNxuqGAa;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.198 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790859045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A6uzEPlU3m+tC2T/IPimTxSKKpkObr48dKbKfO0N/e8=;
	b=SWbhrW9ttgwfdovj/RZtuYFqUsHI/VXutm2NmjG0omMKSrxUBMvhdASx2//xpHzXn/vB87
	6F9GHXLyK8J8e5Kf0ue5/RSNQmVeTnqJuJFyFgJuQw8BohVLPLs4A2/O0hTEJsQmO+sJQX
	rUOB9WZO97sJ9uy93WRdWUg73O/MtQ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790859045;
	b=YKncl0LV+Iw51ize9fLEXO36S2B9MnkrlSUQIYln/BxqnKNeeSaRTRaiLPR1vx5HkBvc/R
	Q5IDPVT2ORCsT7L3/qq4jw14M7LDkk70JIpY8lAuR9dwgjteWNjJTBOtFpnq6oPbzY5mGd
	O4rYDxKZ/o2D/N7f3CgSXxeoNXh6u0w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jNxuqGAa;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.198 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0fdJqXzFPfspnsaQxtUBLrb4T7g26YsIA7I4yNfXBLk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790859042; v=1; x=1791463842;
 b=jNxuqGAagTEdz7K9ZTowCqSMnT5ySPMpwgEfaVUCHA3oFjZtUXglSShpptTJ7wj0NFbm65SJ
 Wf8Hn3QO1aJ9SCjqW55gi6g2h+uwUuDt3F6w6uyHvCk+s+3OpE09RHPJkY0HJe/25qJkPtXf9Mt
 ACFrhuv9LY/SHhg3hMfOP2Rg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 0be64d2780400ce6;
	Thu, 01 Oct 2026 12:50:29 +0000
X-Mizu-Trace-ID: 0be64d2780400ce6
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 1/2] MAINTAINERS: add include/linux/hugetlb_cgroup.h to
 HUGETLB SUBSYSTEM
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261001123747.634845-1-lienze@kylinos.cn>
Date: Thu, 1 Oct 2026 20:50:14 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <835335E1-70DD-47A6-92E2-2D20AD863670@linux.dev>
References: <20261001123747.634845-1-lienze@kylinos.cn>
To: Enze Li <lienze@kylinos.cn>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7C59714000B
X-Stat-Signature: 71gdgniephjtnmg73ez6i4rarfykmzs6
X-HE-Tag: 1790859044-446788
X-HE-Meta: U2FsdGVkX18vN0DqWgZ0e1/zu0S6+Ws5KueETrLId5571BSeUhUUHRRt0WSAkNUQZi0EOYuN1/1vlrTE6x/zyJI3r5lmluWOI/znASUBMSe+adeHmuyrJxS6/3Ono42Dld4dXNPgzFWT1xLfLIepyykHeY1NGeY60enfJAZT68GiIHjSx+Fj+g2Z3HRWAwxlqGZZfBTZsYKvczEFQlLxevPcmsbkjM1/KU2l5uPRyqlO9HZrPX5U32XlgVBLoGMYsU/ej1WKuXtP30y3j/SaNRJKk4GX4r0DAHBwUzf7JTNxl3GNkV76UTWBzNkSXMSZUKnFd/7qC/29QT8qfijV7ipxaCS0XDQRnKZaPrBX5XtogNP9+07mrNNCZL6di3ClqZAjj24FfaPUIFh2EnSk23/3ck0tzMeY/URH1TOdsiMgLZwDOVruOmPQ04nqRLs+pq7JKBREZKq41rkJA+pyb9r91fJ21GCKQWV8UNYRMxYb4xJ9BAQl+qTApl9YBOwSwbPFA30XSlOzg1m5920ba9dwQlnGFC9obIKMYg9A2bhHRZjE7V/vfZwvsUVFp0IAtGrkReEGx6BgQ+h9yKUBxfBeZ1jeNkgucX8VeJrIawC1mJA9fOjNY1FdIgTz5Wdry1AS6oZ3Vw7kdcZSZr/CvNTOgXUOX2Ac4tgXPKDc9rJ/Pl86G3UhFZZQlRb3I94jrAVR6Ac+sMVx/VYe/8BWjh56eLIf2alymt3OlhmQ6UYHT61L9fnCqBy9gOXyusUI/GMrS37m/S1pdIbtQz8sacB/XDuE6HMeo6zP4Eiuu1VVIhUwSLeQpmjMvR/j1CRF07UY1g/5abPXcGVb7suPJtn8CUDwlZr/8mcuoCoPpyIAyHM3V28U6pRUXu/QVNcY6xuesor91NoLSsNck45lUeyqm2shmfGrWrGSMnylHLGtatrBD2YY/3uYPJvLJdsRCojaUN0QMJVBuBd022t
 LRPV4FQl
 Z7bmRKAiZL0oOh1Ns8lcSrkYtUQljocRT5nSYoG+Dd32TCg5RsyaJ3mpcOuKgrVPhlwsHCdWTnjeJpMpwibt+jSuLzh6W4AscdXesmUm/AkTu6kN/mjbf8q1c0Bk9nOadg1xTigqdNf76XlOJBlaQrmVB6YphGIo0kL5n5tHYHon+fA0dgD7DS641L95zZtYjfM3pzvY3lg8Jhtks1DJVda9d7gQ3U7avFn7u15V9frDbvsEQDPUG13G00BJg2K2vjFWqiZXUiYm3Thg1voZJU5zvcynA8mpripGzntIIGRN3EpdnDN9f/VIPlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 1, 2026, at 20:37, Enze Li <lienze@kylinos.cn> wrote:
> 
> include/linux/hugetlb_cgroup.h is the header file paired with
> mm/hugetlb_cgroup.c, but it is not listed among the HUGETLB SUBSYSTEM
> F: entries.  As a result get_maintainer.pl does not attribute the header
> to the hugetlb maintainers explicitly.  Add the F: entry so the file is
> covered.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks


