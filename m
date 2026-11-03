Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9334606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A4aik7Uv
Received: by kanga.kvack.org (Postfix)
	id E8DDC6B05B6; Tue,  3 Nov 2026 13:32:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3E716B05B7; Tue,  3 Nov 2026 13:32:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7B416B05B8; Tue,  3 Nov 2026 13:32:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BDB276B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:32:01 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5D4721C3D1B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:32:01 +0000 (UTC)
X-FDA: 85394652042.20.548C96F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9C53540004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:31:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A4aik7Uv;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793730719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YL7pUVyNm44/Ihd2CJn9w6SXbjo2vEV8c+XqARMDpew=;
	b=GEHYRhLe6JT/6CQfpBeYXuw5Q+wTOTn59aZ9NkcJYl9glr+x+191CqMVH/2hKCM55y4DJ+
	fLKJKu7+M3gMHNy2+UPysLxsx6iTM7ZyvyI5Mtmee5YhE5DmFudFcT2kH49TyWxbUac4HV
	zaOLhzgyfOYDVAKcwzcW2YlWLrpVHmw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793730719;
	b=KWSt2pEG90j92GNNlnAbwJVWXdoPc4i6AdDjJpQVvRbUr7FH7JtyTss8FAlRUps4VYfT08
	2FEJtei2Se0rsLl45o6gtrTN0dq+YoE8EM7kAfB44VPI9bvUov8zu3ydNOfSLSsUoK6l/u
	KHO99iBxGqaHw3vrMhb7OPxgoG4QvBY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A4aik7Uv;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B266B4125F;
	Tue,  3 Nov 2026 18:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA3A1F000C1;
	Tue,  3 Nov 2026 18:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793730718;
	bh=YL7pUVyNm44/Ihd2CJn9w6SXbjo2vEV8c+XqARMDpew=;
	h=From:Subject:Date:To:Cc;
	b=A4aik7UvTF+WBnIEzANiOSGgFaXLqjJm80sWxnLlbMh4FnIt0x8C5uRcgdMKlvJKS
	 +3D7SA68QXXmbdnQaybnbvcwtnvQ6BcikEn1lAWCt09If373L+S9PQ2j2CQfnzcLBj
	 3TxbEz81yFpdP+/UQA/mV+0sIGjX59VF4A71jqjZ80YpmimmDR+JzxiYxlhhQtBinP
	 DDyhfldjwHvV4Vu2cHjzNbl4Ej+UVYy5cL5ZS6SnV1RxtorKYeF8YdVGpULGZGQJLR
	 SLgrMbLoZKZLBvL9Wx8bqpbZ8GrvpUYxSvk7m85OmBC/j93QJ1U58pQv7Kz574M4+w
	 4xQtd7t8JUjaQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 0/2] mm/memfd: handle GUP references reliably when
 write-sealing
Date: Tue, 03 Nov 2026 19:31:43 +0100
Message-Id: <20261103-fixes_core_2-v1-0-f332954f1df4@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAI8o6moC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQwMj3bTMitTi+OT8otR4I11jy1RTy8S0lERLQ0sloJaColSwPFBHdCy
 EX1yalJWaXAIyQ6m2FgAYc4tScAAAAA==
X-Change-ID: 20261102-fixes_core_2-39e59afda919
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Rheinsberg <david@readahead.eu>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1358; i=david@kernel.org;
 h=from:subject:message-id; bh=7nmu6fRF1UbgSM50uuDb6xwGPEFwgJ+ETyCbNbuUspQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJeaUzXmx9/Xi7wYJ3EfcPQuq+aeyNMehVU1wQ9/ezl4
 OJpfTuwo5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgImcDmD4n/DbZVlKGAOfCcdW
 z/fTtX+v0ayb//LJfp1ovtSTEz9st2NkeMW5bKX8AS2Ps6ubhFk6jXu7SpUvzNcR1Dz+6fJ00/p
 +dgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: j374ubocgjkgj55uyzei3te8ner4onyk
X-Rspamd-Queue-Id: 9C53540004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793730719-678682
X-HE-Meta: U2FsdGVkX1/+82qLiY31JZd8F/WwNcjDxWutvWuii9I5e7sDCg4A7Da0xzdBUMfzSOai8dywRvzOaZGsOgjzyvZQ23Jz9Ga7+g6BkPL38NRdC4nfDzkImPZo+1DMZpy/M1c3abXDMprLv24LJUMg3hz2ZksVWyTjHBcY0CCzEHBcqsJP0HT5H6HsIXoFK5OpC131BC9x7E8gohwyr56TkHfzXfNDl7v2BK5ipKIUkcT1MQ230lcgyiW6ixNoWG4Suaci+hgPl/D54RU6WFmzN5jgb1IWxnOwmI25NVza3PAN4/sDXN1I2Upqb/rtfzviuyxTwQEJzn2VyuKVUuYyWDJLzQNdYpsM1/1hqOhiDwKlasMtNPjAWtySdvlZSN5y1MatY/Wdg1HLK6DiwqXmKwFXdvaV0NDuqLWLpW17jvme0o8yRnr+QHR2NanhLmaV2lcHAqSAzfqm4yeKkZ2qTTnoPg8PosiX+qBz0GLIZcOeYVsLrcZK8Ht90XdkqSZLujIE7s31w8otaKA5dGHxQsCNJySZjwW4dObQYZMrJNctIc0Ppy4lxtqdUC5oXboI9203HwxnaQz9waNnf2EbWn17wBsOJV0HvnhSGGqhNdQIgM5kHng6DHInWYZ61S03BfmfanXSKaNudHpvS6qgiGnju9VfXmu4J6X7jy4AmFJwCcX0L8P7Y3Jjx3puX5IjoR7kQJu0l9KpyMJ1lHgMxWK4Vj8A+DPTlM9UBYBRcidEyXJU0PXVcznIgSjcB77NWWewsGAG0cVhjY6Gpo8E8GAj+p2p82RD3n8ngOZBVzDt9fnh/pWNnqdaO8+NjficYWpTq3kcY51CD0aU8/5ttv2zsWmPaBiVMBtaL7ypFvu90inRK0IMouxuOSR7cO8W9t47Gsin4hlVfyy84Y9AgrEnh+V5oEvUDC/bw6K/Xn+YwH76ZbvJgZCbitc1Mw1Z7tQ+tUYlsJaQsgAzOwc
 zKX+jfL0
 BFIsZQk+b7Blx1AW64lSlcf0QVvnSpgPg0kuoRWWabYcB4V2XbLHPsGZKed3P/EVJxHZDMmva1y6YGkAqph6Xw28l9iziamqDSrVwmAtDxxBlxgCgQkS359bdpTDa5w6jbO2HcQchWf92wxjXMquiwtN07VYyncZO7f+Ny6CUvYAN4wuFCuj9hgH/k1s4lNdRmIPRrkq4bxBF9EgyZDYEq6b13iwg90AXo79dq5XYLBDtDJli6c3ZGmCTiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I spent way too much time on this, looking for better options. I think
patch #1 fixes the most immediate issues but something like patch #2 is
needed.

Long story short: someone can trigger a race such that we don't detect
GUP references when write-sealing, allowing to modify content later.

Patch #1 handles pins reliably for folios with a pincount. Patch #2
handles the remaining references, but can reject write-sealing with
populated file mappings. vm.memfd_write_seal_mapped allows restoring the
legacy behavior if needed.

All alternatives to patch #2 I tried ended up too complicated and nasty
in corner cases. We should never have allowed write-sealing with
existing file mappings.

Plenty of details in patch #2.

Did some testing on x86-64 without any surprises.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
David Hildenbrand (Arm) (2):
      mm/memfd: handle GUP pins more reliably when write-sealing
      mm/memfd: handle GUP references reliably when write-sealing

 Documentation/admin-guide/sysctl/vm.rst | 21 +++++++++++++++
 mm/memfd.c                              | 45 ++++++++++++++++++++++++++++++++-
 2 files changed, 65 insertions(+), 1 deletion(-)

---

base-commit: 462595652740dc45f2392dc59d9609e509ee60af

change-id: 20261102-fixes_core_2-39e59afda919

--

Cheers,

David


