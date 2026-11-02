Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7146606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 23:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=e5cH0qIR
Received: by kanga.kvack.org (Postfix)
	id D0A036B00EF; Mon,  2 Nov 2026 18:46:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBAD86B05B1; Mon,  2 Nov 2026 18:46:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9CF6B05B2; Mon,  2 Nov 2026 18:46:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1C86B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:46:14 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F0CFF14027C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:46:13 +0000 (UTC)
X-FDA: 85391815026.01.0C66431
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0FFA720003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:46:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=e5cH0qIR;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793663172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Yxjtd7ITOpLnK9Ydn1+OyRmk1OKK1ic8RSl9/4faQ90=;
	b=vXeD5cr1bbANCpSUkMs0CMnxY5S9lat/hRxGEFVsW7nMQvhNIjgvaAu52lhWAeUBYs1IaP
	F8cA5lELXZtvRZIra0d452xV6gxBk5/xZcVwvdUmyyWdudVjoFumJUbt51PdwyY/2vJOPp
	gUI5CBdH7Eu2yRk7mApa/Mm9iChUCLc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=e5cH0qIR;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793663172;
	b=sYQ6jhuRalzVpgJLLWvRkgFDNR/Itw/N/Xw7lvEwBhLZJXhINiLKL4oPpun22j5BWn+rRC
	eU4VAzYME/OK3p4dF2EMCL4jtmmp8AoFFFNvqHSugWErPoxzAfDxWO78AiDisDMrupFmCP
	tglwoT7eEQJpP0k8OgBm6U7Dc8SE4Z4=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91c162febb9so42640296d6.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 15:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793663171; x=1794267971; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Yxjtd7ITOpLnK9Ydn1+OyRmk1OKK1ic8RSl9/4faQ90=;
        b=e5cH0qIRvh2t/+rHJ9ZfbX7Spp294Lx+2bfnwCO6VWzPYtRB/kS0NMAQI5Aut4uCYd
         MIEO8iSZ+EQObbN0HIzhZyHOcxadOQPG3YX66ekIukR6ueXPhZFjuma+oWRabiRlgrck
         o+Pj+uoL6uN+b/V9D0J7vh89oiFLjO+SATfoLQ2FsjL3c3qbC2qqy+2qreQL9UMsktlT
         TdO/9jGroeZ85esS4lHmnD130xwJI6tmYc1OWK3YMf4IhFOH0FFdhnEX/fL0YBcP28P4
         xQn/xMBLbtSO5nQZ175lTP+Yt+9Nr5YDZuZfWIb/IIAXV+b+EGy3IEnzAYP8NEB4yVOh
         ITTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793663171; x=1794267971;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Yxjtd7ITOpLnK9Ydn1+OyRmk1OKK1ic8RSl9/4faQ90=;
        b=wdEFRFoLyIUbk6HewSest9W78YqW/+DzdaxjkDxvnkMe3vZ1WwQF6vGdQVbab5mn3/
         kruHhGXYjCwXsFWLCXHSfo0HEZyo2ZVLlYCmLODhs7wpPa73BIQwHg4CIrreR+gDquKt
         v1cJKZeODo1TZv1G9BlJUQWZ9jibYIsGNYCYP4JobOhFtP0UISAq1j0rwJhaMUk3hvAG
         ZTqm5P2L9YfTtrpijrq7EIyM4MnRke3AJI9dk0r/1YQnH/lZaI5S+B5vdtaI+vgToXZz
         Azv0XrD5FFVum0K51UFFHLmRpeP5Hzwo5flNhLIWqo5qYaClg8ypBgrddGAJxKlXiCB4
         LjrQ==
X-Forwarded-Encrypted: i=1; AKwUvBxdQZA8tRfjRH4NDNs0V3ARa66Ba72vAcRCuM9wq9Tzrn9mT3KsiDBGylAaI4/Xp+vF7SC1VX810A==@kvack.org
X-Gm-Message-State: APuU4Z85i92OtN3H6v2yivdM2cz6YsJJFw1yNiRI7hQ5rSxCzPErhNWv
	2IpicObrjAn/ZkTBT5G+oFxzbEHA/NKbMIoMJlDM/55wwqGTUh4Mz9JJ8Sjh1qCjc2Y=
X-Gm-Gg: AYBFou1QGF33Y9eyRlJ+4eNK+Kf9rYGd1P3G1d1j1TDNW+O2SqWPDPX3BeFc3bOK5ly
	ZcXlyfDn5ajDKUiFcVmYzEwTADxVrwa9wmYE52ut6oLwJEkf5ZuNWChR4TEyTI3/RpFCnsogwjx
	dNJlAag7EA5vBOjn8zj78cZFubApHYq+1pbdg873OUTZ1zZXIR1ozu3BQKlOytEcaXBxtGuAENu
	lMt1Toy5LqhK2obNrBKpNBOLAjU+pFAkYYlUIhQusfiv/jLsX5KuGHASfIf8GG06HTTZC1g8vUk
	nbDcGqC+qrP8hr451AO7ZaNzd8Dr++LgBWm8iMjdgKWqjxDsFrF1uY7fNXwg9OM6BDPgr7zNaPj
	Gw5PGtuQGRpVIvtnSuBo/VlIP2Zw+FGGsbs04ocWhnduXlFBq3ayOsw/VovRJogSvKnNR5AZ6E1
	GiwnOilz9Vf82/5c+lG9x8gYN+bGrZOWY/wp0ydeZrtea9Uu8hXoh91xJLwIVvAHN1W9/2Es0Mf
	tCUzmW9cNuHZksmv/tdidfhLBIeSTmNipAqCFDQLfNmasnTt6PJ5rgu1HkH7WBXe4b+OiOWksCF
	76ajwjgrWPpGeQT0D2i00O46/xAyXcS2bUBzjOngyUFQROc=
X-Received: by 2002:a05:6214:4307:b0:914:563a:b3eb with SMTP id 6a1803df08f44-91ca4b5533amr194096836d6.40.1793663170876;
        Mon, 02 Nov 2026 15:46:10 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca7f47fd3sm103691496d6.23.2026.11.02.15.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 15:46:07 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH v2 0/5] mm/mremap: fix accounting on a partial move
Date: Mon, 02 Nov 2026 23:45:56 +0000
Message-Id: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALUg6WoC/32Oyw7CIBBFf6Vh7SjQ2lRX/ofpgsdoMRYIYFPT9
 N+FunPh8ty5c3IXEjEYjORcLSTgZKJxNgPfVUQNwt4RjM5MOOUtozUF2cAYcBQefECI/mkSsFr
 U+tjoVktN8me+3My8Wa/9l+NLPlCloioNKSKCDMKqoUSyOWzJr7lUBxOTC+9t4cSK8v+YiQEFx
 Tp+6hgTqOkludkoL6wWe+VG0q/r+gHq6uC++AAAAA==
X-Change-ID: 20261030-b4-mremap-pre-split-13a3d54d6dbd
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, linux-mm@kvack.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793663165; l=2985;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=s4CWcZfvWLhqRxz92PYtTT9U/uiHoblpa21cuiD6XnE=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QJxPBVQz5GtEQyqH/3DXA/aj1WpmI7A15MOw43zYXcMCJk6SacRHt0ffoxLibgv7WpryUzXoMb3
 FOgnWJ8r6og0=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0FFA720003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 6jasx3jidw1rugows4ghh8f3ku66tgs3
X-HE-Tag: 1793663172-60950
X-HE-Meta: U2FsdGVkX18dFB9rzFAXGrypZbugt4vrUjXXBnmJHU+UcEjZeHIvWsxY9Q+m33hsQ4sO+An8HyzcFXNjHvHBiEd8n6gRCmtam+DerI3eiR7dhBqzfWBkHm1ogef2JBMq960mdGf/pXLgPHrHxGi24CjzXap1OAzqX4GhTHyzDTcfLqAzVgBvwN6cSaW7oQdqbPvX1thQIn2McYNpQqBIcsdfWYA1FJ+jJjHQBApIvTUGlRcqkd1Gx9PozweaIb7mEsqLx/s4J3qVwDe567TBoEMunPeufANt3s0mdrYsIeA+oR7mMMRDBnJH4BjMvzbSSrGrkqFowbbvghO3sWh3S+rfM5sH8ROUtm5aYBHEaCgkIa5eycztkIQf1xplJHsr0HTObIkgS36BoWqj4cfYJKycYo4TiD6CnuFnPN6A+DqEhL5gb5ZS96wtOSK+/rJH4zRqF/yDE96lYMlqLdwjvaU7f+jIZDGT958SGdAMI8FAU9eU3GCr54chV2bIN5AToRl2aiUqXTZ5t3D7+sTUmTcrM8QQCYHBeou1Hp0K+kIUcaSbjQZVsbU9qfxKzgfzCWI0iok/v3+yCBFarQTq6JqE+WyDPnOFmKUyL5vqNWTrOEUXwInI3Hq7H2TTSv9qn2LUoREQhsPZcTZPJj1qAywWvibwJHb7bVyhlvInP3ONH6LPvrS4gGxVqCVXF+heeV251vltCIlIQWchqh6X6H8oZVRLTbEpiikbuHovciqD/MSICgEvjdqhJ7lm1tCAGz6XlQiE0Hny5MsB74YygAHEfqjDZohygjRL4+0HxYRiX8Pv0MltV1mW9DEKwGLwr30SZQwfaS8tD6ZFzCj8FWY9B+hNW3nJ5kVMNlR5g3gKPKUv6xn+rbUBTdwPq/9DjXCZsiFMCZEwdJ9YFc0WQJfBu1OWP5w4we5BUJ9ntpRmIeiD2onx5BJgin/bFbyKgW8+15TqdTVd0H8Twum
 QOQzgKaI
 ax0rYSVGE+nxTd/skyKIKFkYxlLSmYIWDcRrLc+6m+/tvZjKgP0lM3qgXG9Zz+5rGTJcl6j3q6VBZVI603Kbginaj0Dk1NXz113BtP9jhsk1iYd/nAZQSejNDTeTavFBSl7ZSBSA6+SmorwF7yoQ2VoCo7289Rj2GYNaNbmbNmXA6mLmqPn5cicgcxNt05nZuB3ct85JE4aJXx64HVi0doOoYcUwfWCKuR4hqdSW55z+nerTWkMo+d+WAKbdHS6+0/ZIvHAEpn5nrDUTr1FlSHbGwJQw67jdHbjDW0xXMSM2AN4BBwbffGiCJqy/0r0gL3kfulz38lGXdks+SVAynjrZHJbrNVTzuWdWCATiTZvVGtiKWgwq1PEvUrMrKraIsfGKYlpb/8Ceo4zFlM63FD8ANQf80ocImSm1qnB0SnE8YjX+ye+RlmGTzb2F1yIENdHik
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

v1: https://lore.kernel.org/all/20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com/

v1->v2:
- Dropped "mm/mremap: split first so a failed split is reported".  Every failure
  now left an unwanted split, for a benefit that only a doomed process would see
  (Lorenzo, Jose).  This is also why the series has a new subject.
- Patch 4: added vma_range_set_account() and used it on the success path too,
  shortened the comment, spelled the flag VMA_ACCOUNT_BIT in the subject and
  message (Lorenzo).
- Patch 1: dropped the comment above split_source_stays() (Lorenzo).
- Picked up the tags on patches 1, 2, 3 and 5.

--- Original email (v1) ---

Hello,

I went through the callers of __split_vma() to see who can't cope with
it failing, and mremap() is the bad one.  If you move part of a VMA we
don't split it until the very end, when we unmap the old range.  By then
the page tables have moved and there's nothing to go back to, so we fix
up the accounting and return success with the old range still mapped.

Lorenzo recently added a way to split ahead of the move for the mlock()
+ MREMAP_DONTUNMAP case.  This series uses that for every move that
unmaps its source, so a split that fails is reported before we've done
anything.

Doing that turned up a real bug in hugetlb.  We take the reservation map
away from the whole old VMA before the part that's moving is split off,
so the parts that stay never give their reservations back.  That fix is
the first patch so it can go to stable by itself, and the second patch
is a selftest for it.

The next two fix the accounting for when the unmap at the end does fail,
we either charged memory that was never accounted or lost track of the
charge for the whole VMA.  That gets a lot harder to hit with the last
patch but it's still possible.  There's also a test for an old size of
0, which nothing covered.

I tested this with the mm selftests and with a loop that fails each
allocation inside mremap() in turn and checks that we either moved or
didn't.  The numbers for moving part of a mapping don't change.  Thanks,

Josef

---
Changes in v2:
- Link to v1: https://patch.msgid.link/20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com

---
Josef Bacik (5):
      mm/mremap: fix hugetlb reservation leak on partial move
      selftests/mm: test a partial mremap() of hugetlb memory
      mm/mremap: reaccount on unmap failure only if accounted
      mm/mremap: restore VMA_ACCOUNT_BIT if the unmap fails
      selftests/mm: test mremap() with an old size of 0

 mm/mremap.c                                 | 69 ++++++++++++++++-------------
 tools/testing/selftests/mm/hugetlb-mremap.c | 52 +++++++++++++++++++++-
 tools/testing/selftests/mm/mremap_test.c    | 52 +++++++++++++++++++++-
 3 files changed, 139 insertions(+), 34 deletions(-)
---
base-commit: a792d9193312d7cd897391d99e4a57b25772c099
change-id: 20261030-b4-mremap-pre-split-13a3d54d6dbd


