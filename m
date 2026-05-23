Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55FDACD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789BE6B0095; Sat, 23 May 2026 13:38:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 760AA6B0098; Sat, 23 May 2026 13:38:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6764A6B0099; Sat, 23 May 2026 13:38:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 546EB6B0095
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:38:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2D29A0BF4
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:38:07 +0000 (UTC)
X-FDA: 84799393014.19.2AF32BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6396C10000B
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:38:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KqJXbRxn;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779557886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=b2hgNJ6czMQSIsEl8DkmP86xrB4tdXDcGlcGE91PXvU=;
	b=4BosOVoDQsb/VlaDVa1NPAZ4bZkhaRPh3yBvG+bNk3eL8OKswIAL5x9BeC1Y5zcHjSTkL7
	w/4NwCmHR1GhCxM0K0/cjQaXMr/5NXMrq2GxaZy10OblVqWGUCvAePSl/Vda7uAO4ug68g
	qgfxJZr1RFBaRxzJwj4CJTtYULcQvu4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779557886; a=rsa-sha256;
	cv=none;
	b=KcS6Dk5cYVohKDQWM0/9QGlPYm674QviQXRA0eU8X6dgNeep3ZM5/tzEiRUMkTNQfrvYHe
	Ro4apwL/caixU1hTZ+rsaJUJrxGqwTk98f/jIZ+VeiQL984DYq8xRVAsWJIjtTfG3Vhwy/
	DP3AIYU/h9zZi8NASc/vXv7FjN+L26w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KqJXbRxn;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8244443BAF;
	Sat, 23 May 2026 17:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60F81F000E9;
	Sat, 23 May 2026 17:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779557885;
	bh=b2hgNJ6czMQSIsEl8DkmP86xrB4tdXDcGlcGE91PXvU=;
	h=From:To:Cc:Subject:Date;
	b=KqJXbRxn9q4vsbwvkPAGO9ZHWLJvGAD8FFZD8mVOmkn1Scgz7d4J0txkEtY/RNCB2
	 dOj9ES/p2yKwMQNtdjp3rmifWnzW1mfbQTZ0j4YSGOd4bh2A6rzoBrcGxs5ySfGbKl
	 RKm4vtRBzTmRxnWSdnPBT1eG0L+jblYTHo1usUKpiQl6FvwhA7D5P1ZUDIElsEgpS9
	 D5gxptkQGGA03YGfA5v5RtsU4RshwLZgq+QFnKLTHMRd2mTchgBcknyq1tuG//77aN
	 VSp76bxmWxV8ohtAxrqsQn1A+NtWQjnC6j/PQaH3czFDtZqyb2EPmpIVY+wTHcNNcB
	 BUOpqUnu/IMrw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/2] userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c
Date: Sat, 23 May 2026 20:37:57 +0300
Message-ID: <20260523173759.3964908-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 3chza1e77uqzp3ixg788quz3cqn6hzs6
X-Rspamd-Queue-Id: 6396C10000B
X-Rspam-User: 
X-HE-Tag: 1779557886-728603
X-HE-Meta: U2FsdGVkX1+8o+Ui556TJfmlYJbstV/d6zqv2LdV5tWuPVpEEL0Dll2seLhLByyB03s2Pp4DQds4QkD2tU9ucjyG+zjm5nY+DXxrighMjMVfivw8HdiTpYgTtgr2jA/TJe3XI4LJ44xLptq/Kl7BLNJDhmCBp8bBYf9VmjEUUvPwqdV2AhW+/8gWZbQ4N1cGzORQe2JSEz+9W25YpOpzA8cR6IEAbQan54/LqLCJTVg+42eMMPX1SOIbU4f7LpIIBgFBNOsaTzUCNUlNUJxZfBzgtbfkPATieb2kMhetlDN1I1lJrenUSgvwYS4rJdJQvh/qfZql+l93QWK5aPD3w4Z101AMYZv/6FeiwQPxE54r+SqiOYJVpfKX4P+GlPlxz2+1MiUuAlSvoIsLdWwpjOPpXtS6ndlTbSK4/6EaDIxCWkMjLSgDCbi8NJ8WJcuPno/hmBE/4Ckydcq3bTBFOalGRqEK95ZNd62vvYjfW0Sjy21PmPKeeDC47Cc1E6fahBh17O/2h4LaHO5f/7O+s0v6JWNcqx12t4n3XRugubya5TCyCpz81zdvsXxurS1ywPLjZ0m6gm2lWJh/t7HMHcmYfxi5FYgeaLMwvLg/m4hJfzD4Xpye1jDGm6eHHRk9f7jHIryLjnVIRx0iFtod9lVElIinSMw71zFNihUw5KTN5DQaJkxH5oaor9hTAb7lEXaOFNDYU7L7JWdlwxucOVVKEkV2a1GCJ7i9x1Xsg93rXM5vTt9iEMj7xuyh6nbmYPpN5GEifib7cfMT730EabzomTSuXb/Zegm0v0/s6VFXbPUwtUIRmv+bjrtwm9udT7mGBbMR7y+7o+UOMnSHmndjP7JgM2XBTTX35bd/0BZhM0hDPa89LZxZG793WtBsV7SXVEHD73UWQQmj1cQ9o/VD7K300Tgz+oMqLJI5qvACYlYP6amDY9nnwIOTTBjQT1LrXj5frNXUC9XCO+y
 xUgGiZEC
 AWsZLMmYoRqD8Y7wQd4cCYUUG9o67BVCh/JsqgUKoxNp4LElyoXF8ZwT1W6hsqCRZ4mLQEsyH2okC/c/o809dATw0ru41NYZVz/N5gXl8yprWMh63DAdz8r44IewDAMBevqt218rcQvam3h1Kh9vCgv3oJfSmm8ob0SwgCf8bKsLtJ0qlhgFNLkY5agbObARtV3ASdNgr6J1L0av7XPPBRgOR+HLYTVY+fzwdZqQ6pg4e0bE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

These patches merge fs/userfaultfd.c into mm/userfaultfd.c and make
functions used only inside mm/userfaultfd.c static.

v3 changes:
* rebase on the current mm-unstable
* drop the fix for mremap_userfaultfd_fail() that's already merged

v2: https://lore.kernel.org/all/20260501145433.156211-1-rppt@kernel.org
* add a fix for pre-existing bug found by sashiko as a separate patch

v1: https://lore.kernel.org/all/20260430113512.115938-1-rppt@kernel.org

Mike Rapoport (Microsoft) (2):
  userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c
  userfaultfd: make functions that are not used outside uffd static

 MAINTAINERS                   |    1 -
 fs/Makefile                   |    1 -
 fs/userfaultfd.c              | 2233 --------------------------------
 include/linux/userfaultfd_k.h |   36 -
 mm/userfaultfd.c              | 2239 ++++++++++++++++++++++++++++++++-
 5 files changed, 2227 insertions(+), 2283 deletions(-)
 delete mode 100644 fs/userfaultfd.c


base-commit: 7f077167feb6e403ef039d6009d785d596ed8070
-- 
2.53.0


