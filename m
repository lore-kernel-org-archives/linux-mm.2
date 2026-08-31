Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AAB3C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38C226B0096; Mon, 31 Aug 2026 11:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363066B0098; Mon, 31 Aug 2026 11:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3A96B0099; Mon, 31 Aug 2026 11:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 019516B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:02:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A151EA14AF
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:02:37 +0000 (UTC)
X-FDA: 85161881154.10.31AB2B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1A18C14000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:02:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I0YuHnBq;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788188556;
	b=g/1shQ9kiXPahXyq3piQBCMYAInHJPolxB9Zqcay88iyZCHeJzMriqTl+SowJA8S2+yOYc
	OSdIOIXGOjMICj3GUVIeT52RZ8WM2Xi1VxGM7QfrojuD0ZSCkOFCmRzCfWRjfG++CQynGU
	Zf9guMXXNGv87xxEAZtov0EdsKJVVZE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I0YuHnBq;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788188556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AyvY9IIUeA8/wq0mVdMqWHFeuah1T8v5iyraiZ5SRJY=;
	b=xTIBNe7z8EISrGCpIZPTfvRJFLy2l86KaMXzq3o0pN4AcUODtVVUQji3HZmxGjLKNh845+
	vysA3Y0ydpbPfnqcVSJ75qj2yTSgv6WpN1fxSF9OmoJeyB79dCMZuAi69suU0fFWePSxJ5
	MiukZBD6zvSnD5x7N7TUzM8mwoj3G5g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A101E601DE;
	Mon, 31 Aug 2026 15:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C238D1F000E9;
	Mon, 31 Aug 2026 15:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788188555;
	bh=AyvY9IIUeA8/wq0mVdMqWHFeuah1T8v5iyraiZ5SRJY=;
	h=From:To:Cc:Subject:Date;
	b=I0YuHnBq3ryHN4v6fO+Gay2QtKjKVxpWUP7fTVztDe/L7zR3X954DMjI+NPL0Z63V
	 nQbIhcCq3F27F2I/CIsDx2J0FNY4DYDmvyelT448mQzsD8h9MpBBk7YH2v84wqqTqF
	 evzvsz+Y6BCVTw5QQ1q2nOXsraVfPVyZh6GVXJYcS+UOCD7X22wBoWP2xr18YaiE/U
	 GANl2xaF77HLZ+MBdSLFU7DxzRKa6AU5AxtatB876Jr1lw3sTa+ZNHA30Gun7WgrhV
	 gkgxPsOULwSJfaiCsZ61psHwbWyNC2e1+w4WJqfTEuHb/bWPYYeC35WjnmJZEOLbow
	 GHSK0g7FZH80g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/3] docs/mm/damon/design: add explanation of nr_snapshots
Date: Mon, 31 Aug 2026 08:02:23 -0700
Message-ID: <20260831150227.83416-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wxs35it6wk4ge6ck3mwunpf8xec9dwk6
X-Rspamd-Queue-Id: 1A18C14000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1788188555-865919
X-HE-Meta: U2FsdGVkX1/qVy+PKi6BEF6oGY1qrTh5Q0OKkkTBljr69pj2/hELzkBzJuRuGAbFYCrFRFl26P0jeYrOO40U4vZpR/1/JOTKMy8G9waCKe3MtI64bbh07ztxlaedqv6xMzZXqrq1VIfccmb7hzLdN3VXu0M3CN0g9Bs04fhdMIvMy6OXI+XYmupV7kW1rv7+KZrEniV1ZcGFQptS82K5dWqhrtfaSdhtGr4abietgzsqYPr8Dgw3RIJM2/NPtob7DfiR5bkFDjMCY8qQsWiEUgoMCW1skpkHp9iVraLZhaTROfd49DcYlfGqlUw57h3HYjwRCYyczDoeAg6DrxwqZFy3IjwoI4WuRQyVnTSecE3ecQBZAf7kzgy+d88XhyLmr7IPBPH8iYYpKyeloorcBx6LNdqbt6qEFr7jsMR444UyspX+nR/E1WnUmO03jKFvROi5bBdb4SY20BcmywcUc5PovbqemywW0mcsKFihrqh97ylETR2u6wKJRFdNW2cv2BPhchMH7k35QztbwW2C81D0WduaIhPkzOff4jWUt3Kj1xnDN9ZxFxwfp0FQzolz3UEjeGE21V9xD+tzR0b1bn0VtxyGXozCKFZ54Ba58jNciOhdr213+KKAwWb1U0AiYdKl9X9cOxhxuniEykquv++9pn7JHo+fBV7QhtKJDpjJUOIGAZqIXVq9O1mUhU0hy8LaDoEoSwCm44u92zoxV3kTi0mpe8SGiSdNevORiWhG7H50wdhwN2T9kGQIu97GtqeJl9ZADKExIcivHdIjVGqoTP3dQ7lw12F+NUbtGGKnMvQJwVdoYQWKnaR6IikPaM8UoLTSXxMadTB2nvhYnSDrJJB4jXoxhefM8bLkJB5LPxzxt6JAVl6vhPRnok8t9+wmWjm1DXQOnKTMOb0nA5dK0tNS26QDMdBCzqZOI76/03Pdt7U0Z4Y4FQAJmTru8mYUv3o8XMoQrOrZ3+R
 HxOaQMS5
 GSXc9VR5jAD323cycXxnQiQ2oa/sdaMrqgX8N5wPPaHN3NMwZATO8fQv3BXmLNU9MpQiwCNQXIfW+zOrUQe8YACv351SPzGfALeUXZ7+sdBkyaRY8bpRLoHGi1YTbiWxgeVbFZPtsT8k4FUlC2nedyMOywGgr6AGGQ4x3lzA4PqH9hnPhnyoj37DBBc66YFbLT4XR7LML9rE+JFLp2k5u2KosKvUeewe0BiH/oVMoQSS35L7MHlf9htUeITB3ebdoCsdizrbz8M7d0sFdDLifu5wfl0rpJG5iF2jqzW23oJxVNl14hGre2loSdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an explanation of nr_snapshots to avoid misunderstandings.

Changes from v2
- v2: https://lore.kernel.org/20260812104002.15225-1-aethernet65535@gmail.com
- Collect R-b: from SJ.
- Rebase to latest mm-new.
Changes from v1:
- v1: https://lore.kernel.org/damon/20260811101841.804596-1-aethernet65535@gmail.com
- Patch 1 word order adjustment: Repositioned "completely" ("tried to be
  completely applied" -> "completely tried to be applied").
- Patch 2: Use two spaces between sentences.
- Patch 3: Add the "Reviewed-by:" of SJ, because he added this in v1.
- Patch 3: Make some minor modifications, Patch 3 can be applied after
  Patch 2.

Liew Rui Yan (3):
  docs/mm/damon/design: accurate semantics of nr_snapshots
  docs/mm/damon/design: difference between watermarks and nr_snapshots
  docs/mm/damon/design: fix typo of max_nr_snapshots

 Documentation/mm/damon/design.rst | 9 +++++----
 include/linux/damon.h             | 5 +++--
 2 files changed, 8 insertions(+), 6 deletions(-)


base-commit: 5c4fade039dbd572ba5ad9cf993fbb56e6a5613f
-- 
2.47.3

