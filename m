Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE1E6606A324
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 22:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B7j/We1b
Received: by kanga.kvack.org (Postfix)
	id CDE786B00EF; Thu, 29 Oct 2026 18:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8F136B05B1; Thu, 29 Oct 2026 18:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5786B05B4; Thu, 29 Oct 2026 18:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 917736B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:11:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23DB94058D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:11:38 +0000 (UTC)
X-FDA: 85377061476.25.499E358
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5620F40002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:11:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="B7j/We1b";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793311896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3qbCVY70IGSK3kVBC6Qw8VcA8OjZRClUiqwt47D/E8o=;
	b=WV5q1DmQplj8b9o9nFvY9gU1UZ3OoNyx2meR78VXoDVGCJ6Op+Z+fxTnnavMU2hJmysfF+
	r0XxSJ4wFn3K918PKJGx/CfjJ+tdOygajvSW34XMLTYoaZHlLIi6yK29WHg2pgQf9bwzpi
	dmxJF0xJIoUQO4qFYD/+6kEr+erwHNk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="B7j/We1b";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793311896;
	b=z1CzEbu/Ftkty0MiWDtmrrubieVdDMe183WcDGLC3UAM4ZoRl2lVwAH69vWm5WeQBBn6BT
	/IsLo6WHuTpLOm1sR2J3WgU2m5zkmqlki2eLPjgRCVPtI9zM8y2iRaRZxOooWKvrVmmHWz
	UhuJHRhVfh6vRouSRp2/6m0+qM2u3lo=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a2069b9710so421085e9.2
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793311895; x=1793916695; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3qbCVY70IGSK3kVBC6Qw8VcA8OjZRClUiqwt47D/E8o=;
        b=B7j/We1bugkYP6yzPYGBhqPkFihlkR91hytgHwkNyFC1Um7Yu/7EGMx84YipL9veOS
         Ga6xwykKolzQQUtXLpQWNP6phbhAhx987SOSrifjXhBP/JGrxwfvEH8rpA9l+V63e9VA
         RbouuuG0cVhxXmJB0no+He1h9kr/v0sWJXXDogQBROunp8WeKjxrWByeBbcJze/H4kkK
         a/MxWgph4Lb8vXvuXe1WfkcnmLS2ibaG4qX7HlmDoN+1Xp7bSoUGR+yKNBLBh0pPqFa0
         oVsbv4eTuvLdSVt66NpPA4JmB9IRqeyF+mO/HrASGSdg4hxNrwzp6htA1uBfHcN+X+qy
         fxpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793311895; x=1793916695;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3qbCVY70IGSK3kVBC6Qw8VcA8OjZRClUiqwt47D/E8o=;
        b=YbPFtBbsT85DXQ7KE4WJx9AZi//lZ/YlbHfwgyKCaN5Hhn7v6PO/yb8zyu3MDFKDfx
         +fc41vpb41HtFh/bnz0f0NIVxu7QhsdytZoFjaxcGZL2POxiRQmpiiG8aNwt4bbrDg2r
         JvapPEyc9L1yGfzM1TYCC7rxoJzOS03dPznXdZZ57XTJgaRLyumaMPNFxJg5uKVUodho
         3N6EFZz90Ueq4IwE60P4JmjhTFy3wy67k9mVHGWcMYCasjXIVPaAj3NAqGhf3+nbQ71n
         +Ntsdl1AD5EEu9bhnWYbv+2KPBH/X5ur3tzqYWoxQILu6ONjAFdHa+GQPDebWNhwNAWL
         6KnA==
X-Forwarded-Encrypted: i=1; AKwUvBy+9LQDnkEFuy0zBHS/2lWqWu8+yeEUSjohhCnBRe+2fMWcodbSI8IqH2iQOXuExhXpnrwba4RlvA==@kvack.org
X-Gm-Message-State: AFq9FYJjHuQdnlH/zP/5zeyDmnVraGfyJCOmfDHtg0+O3rTFCw6jvPvK
	YQbxbK6OyXFEzFfNT+m2yZcFTr1F5rJ1EITwAYy6iZYfuBfa0akyq219
X-Gm-Gg: AYBFou0roR3maXMfUcgWUDaQeKSUB/cL+cp/R9jkGDluzuIAH6asZN2nScODFvCl2Cm
	eAn4TWlPpJvSZFUbNp+nPuiPNhgMO5x9EVE4Kskb/PC4bmQAdNCZweZFXIG4GKTMUs+DYZO8Piz
	+qnpEdUcNLMa1LKrewpsgmS3+PEJUrPFzJN892COHj6T1+2mN229sKeMN3PXAniV2Cz7olHvWgu
	48sSjkBujXebXTsogFAWbjQg6DmeV+/f/5OUrNAKgxrRmS6QY2BI4Tb0b7UNadi4VDADZr3rJaV
	KR7qIduSJgH4xfU2gEwQ/CY55AODqDyiJpuLmnkBCdNV8ieRfaP4CV+ur9LEKtEzElcB4tIWHap
	dBHwlaBbMde/MwEjlzM3E33G8DUtYpfVn793O5lX+R0R7qKQpAdS46+e2t8hULlf/tjcj892riG
	j188aTFCqIQqPy4hL2DJEcyJOA65g/7JqUwYulWF2d9mmzdfnnY2ExXJ7wZGNBaYId6t+ChwemG
	tkyCaV9Q9uFpiWxZf09Slnll+1CjCzBpFxAiZc1FeLXk5roqd7+8eeQ8lVJUEHSTeIIvYZDznJi
	4hX+rGFIavn51Q==
X-Received: by 2002:a05:600c:4f55:b0:4a3:d327:6ed with SMTP id 5b1f17b1804b1-4ac182dcba3mr6955425e9.17.1793311894768;
        Thu, 29 Oct 2026 15:11:34 -0700 (PDT)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81a896fesm104011305e9.10.2026.10.29.15.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 15:11:34 -0700 (PDT)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Peter Xu <peterx@redhat.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH 0/2] mm/userfaultfd: recheck WP registration in the hugetlb UFFDIO_COPY retry
Date: Thu, 29 Oct 2026 23:11:00 +0100
Message-ID: <20261029221129.89068-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5620F40002
X-Stat-Signature: yugsqrwsfqj9i3e1t9m8s33cakwbhqe1
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793311896-491573
X-HE-Meta: U2FsdGVkX1/luJLSxi5P45QSSBC6AMW5s0xa2HSSgEE5+rhhx4/raB3vMW1G4ID08Z2K1QgvzKCqzlFi7IM0dc+lWAPk0jmfL+D0NTfVXL3X7tdGiDEWnoTGU3WWW6oFk6dwAfGJnjGvyxhUDOaLtKBxmRut75kr4vcxvZJeiFx0db/vr2u+q8fclKN0BtCr957L61nxKtRsqzqTQuaWfvxnLPjYZvlYOA3R4Ac9aD2a+VgT55wc9opB4kSJRAQH+yuswTdIL/MQeKl1Rwh3R9Z0csDRv/dtrWnWvgG8VDe9MfTDeM17K/jQa/UIlV0EbiwYhExFqG/A8tXECMRZNrCkP/jTCBONnONSQXXb6opH9iG9wIBho03IAwXnwULlWuJEB2jYXaK/7kqGQkInwzZ7e5dJD2VDRdcDmwiI7/vHOlx7pojXI0Y5DON00O7tHWStkhLnYwyiAj4cy9CGKAKwgRifNUKVvrxHsFnEltLyzxXG2Rig7R1fpxS4QIivwjxPDuht1uwXEs2fJ4MTDjhs17wVOLq5elRy2B7GbdMo4RaPKTip3mAI9VOdPEF+RaDMmN5dilHSDq7WWgF1qaonaOrw3VyqRhGrnGXg8srX2boyPADAj3HtPLnrjj52Vlb4o7DgX6+fKBe+mvyC42fx4WHjeZJdbqStHMYdxMEYdECmAjDwAnf8BmBBuOUxf5awa/54eMd48FrxL6THstZBXm12CHgZjFlw/eQNB1i8ovg2suw/7fzkGe75w+zHgpYIPe+JpsQMJMwuqcR0UW9cUvC7zFSLXZg09NIV/2O6CQTjmeB4/uommEV+3HGiI6jdHiK1jC4siXxgQUYqTX4aTvSc5ADdIDkLQ7b40YATvpXhqTmTKxuXFF9sNZM3LfHet9NKkUOoZ5jJgIDoTLhjo+Ps9Un9bHZ6IvybQqOG680eD3CocY4LSEQFNeuDXyqZQDvotBefXJaLc28
 UsEShV2D
 LNyXIVFN3SwHfFKpDjp2um4XBsfZx2mxXc16e8xTfMIRsLp+7RKNMf6AHHTS7nBBpV2j0kCWyGaDQHKBhgsbBdJ60JRClehSY7aN7Xs183MYcTF7ctV7g2XUtW3fCBWAA1nBNNHo5dNR2lUf/9jS2PKIkgTiW0VH+rUgKfmUOFEZmSmYVNmD6IFeg77ZrEI80sboq0XdGvAVt6pBFcWaqzcX8A/2FCO9hGMy3vjw3byGzV9gllPH4B1COd7HwBwoUOWW+oU1DmAfizofo1fgLRQVXRGxaWAM84T0TwQGZlqS+41gUSutoUlod2WDklwx6w4zpnuX69YSeWkUNctFsjRifeKs/j/UKDd0NqJbdLtmv8Q22tP6iFLbnHFOzHiUJ+vjz6TeiFn4L/ucZIqUb+HKs5kC09g3kX/86AZKFQ7oAM4XeFAS1AHpipxX6MoHcIyl6uRNWTCUieqw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The urgent fixes made hugetlb_fault() tolerate uffd bits left in VMAs
that are no longer registered for them, and asked for follow-ups that
remove the sources [1]. This is one: a hugetlb UFFDIO_COPY_MODE_WP copy
that has to fault in its source page doesn't recheck the WP registration
before retrying, so re-registering the range without WP in that window
leaves a uffd-wp PTE behind.

Patch 1 adds the check the non-hugetlb retry already gets from
mfill_get_vma(). Patch 2 adds a uffd-unit-tests case for it, which fails
on hugetlb without patch 1.

Question:

- The non-hugetlb retry compares the whole mfill_retry_state. hugetlb
  copies into a freshly allocated folio, so only WP seemed to matter
  there. Mike, would you rather have the full comparison on both paths?

The other source 6/10 of [1] mentions, UFFDIO_COPY in MODE_WP racing
with UFFDIO_UNREGISTER [2], is closed by "mm/userfaultfd: write-lock the
VMA before waking waiters when unregistering" [3].

Based on mm-unstable.

Tested on x86_64 in QEMU.

[1] https://lore.kernel.org/20261015-urgent_fixes-v1-0-42796911043b@kernel.org
[2] https://lore.kernel.org/20261015-urgent_fixes-v1-6-42796911043b@kernel.org
[3] https://lore.kernel.org/20261027-fixes_core-v1-23-6f74bec9a5bb@kernel.org (v1, now 23/47 in v2)

Jose A. Perez de Azpillaga (2):
  mm/userfaultfd: recheck WP registration in the hugetlb UFFDIO_COPY
    retry
  selftests/mm: add a uffd test for re-registering during UFFDIO_COPY

 mm/userfaultfd.c                             |   4 +
 tools/testing/selftests/mm/uffd-unit-tests.c | 105 +++++++++++++++++++
 2 files changed, 109 insertions(+)


base-commit: 24d45a1475dd4c671feb1df705f67ef2fc293969
-- 
2.55.0


