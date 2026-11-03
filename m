Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8DDA60A381D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zetI1pZh
Received: by kanga.kvack.org (Postfix)
	id E72616B05B3; Tue,  3 Nov 2026 05:28:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E498D6B05B4; Tue,  3 Nov 2026 05:28:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38826B05B5; Tue,  3 Nov 2026 05:28:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A977A6B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:28:50 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 90D26402D2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:28:49 +0000 (UTC)
X-FDA: 85393434378.11.882A195
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id E207440005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:28:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zetI1pZh;
	spf=pass (imf17.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793701727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+slzZtIqAmiMo+gR8iGw7sSnQz1zeHTQz+LiYF2Om1s=;
	b=tGaBbZ4em1vOJLZbRbvjloAxfNc9P4S24ey3CGCQgoO95xtDpzdZdS18VFIwgcMHWLC1k3
	o1nZZV7M16dXn9wJBZ2atEt7+o8KXAm2QG3HGpUZgcW3I2Tml6+gxCjQoVKqyi1lZvWQBW
	vhF0/vZNZ/awNzx889naePEJcKPYE30=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zetI1pZh;
	spf=pass (imf17.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793701727;
	b=RoT2IZhop8hfINw/fygYdam/OZe9pk18U+z6W0o+G3akAggOh9l12TuyZyv1mG/FE7u5CD
	YWsy2Tc2qE55m3izaHQJFfxeIrqg7hLi4HUW39jooWjcId6doxVicP3xbseBtMaCn9JxlJ
	20CxYektm2p6T+QvqBqrr96SytUN+nE=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48dfb76b304so380568f8f.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793701726; x=1794306526; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+slzZtIqAmiMo+gR8iGw7sSnQz1zeHTQz+LiYF2Om1s=;
        b=zetI1pZhPd8u4JzF+htOigeEIKtSW2xgosDHxovyU+SJJLjFZJuKCi0XUW2GgiRBZ3
         GIYHcJoqQJLROo6wsQIqLnsjmjekAE24xFvtsd2d+0CVGkc3HElZnEAM3XYZuY4FYZLP
         odzm5zzfN2tkKcbPrUBxEXx++hisc74XiqXMpYek0NayTMDaQfrOd1Yef5QM1Q98Nu3B
         SetQV3G3BpPc+qHAZTnyCcIFoB1Tshz4NhoSXL14m6QCzs8EIPbP4yygEjNipZhYISeg
         99lBjgJT/epPOghuoaEG52/n4W8y8AYOdyab6whJncPho8wAKk4Ii5/E6PqESLPIi3L5
         bMkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793701726; x=1794306526;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+slzZtIqAmiMo+gR8iGw7sSnQz1zeHTQz+LiYF2Om1s=;
        b=nl0TfVhKa+PtyjyLFD8WmROg//XjJEQaR/sWvlezBpxU458eyy+cQzhvsgi0RJDmO3
         I3ojgceF52e4PB7kd9Kdf4qQF4YjFMCpsOx+yEsVERgBJeECVcxm+BnMp7EKjQPDOBbg
         UjQ/Fc3kIsLaxNuNxqgu1N3rE8Ndj2UInNFahXV3NTaUv01duABTX60YCDJ3v37FukCn
         1OtSYmFkjIF9FFm9kVYWvOOhxZ00Ct2t7YRtkTBhoUUf6MzbNn+AP2N0mv7Gtc0qCVSb
         u5dTKXDaPI9ptF+SDggczo42D/P/fxyn6IaSq+wFq6+hHy9H/ZbmA47QFMKkagA6TVlM
         dMIA==
X-Forwarded-Encrypted: i=1; AKwUvBwSxazOCjPk7QsZW+Mu4YA9862xcEWwamJ93178iZejieXgyShCBYuYiFVniu3YUtstBMUWNvGJtQ==@kvack.org
X-Gm-Message-State: APuU4Z+YU9FFeCiqsrkK7dOHGO7PoWMZZ68z8YTw5+mJtgua77ddlrij
	13gs5aGfQk3XSUta6jFUZEyQK+KDbEIJWe8Bf8keZSTcE5JpdneI8r5h
X-Gm-Gg: AYBFou0ojAzzYdxAvQnr6Kq2sDahu3V6313HdSfnFyS/Lv1GpOLsUXftQow6lh/NZuW
	k5v2z7aLrfwDW/0AUgI9CpMk5utvrvojjdXkIuR8R4ILtMKaxxgVKzItGuiz9aCEQFdBdaXFZeB
	li6bL63hOe8ELk4VKwEe4tE9PEzRJ3O5CKv7yD61FrdWxqBCWAclSsu36u1PvKJ0BklWP+HBt7p
	uajIZev/RFwLcQ0IbdC+orUjVtHdCPPwwpgJVJd5eo9YFHH2th6lSuCUMzTevwJcI5/G0B/IodD
	cqySiZEPuYvZuPhAKw+coKF7IR9+nzVlNwYfIsP9OcYm5L6tUvrklTSX5uXmYtVhdjfQn74gyU9
	t9XsHjfZt7ckw/LG60mZ1OWYySnilFfHeFkJWHq21iy3RhgYW58PSEe8fnL7S8m5yFK0sJGCZKq
	T42d/mM1E9sBg0/k3U5U+r8rLXLObbl+XI+JQalVdtmo0kE6NE93seOiOcxOFCxS3XonoMJeyf6
	qTMvSSqvYvIWzc5pqnDAN0tvywgRZXlaVv+H1Kk7MqZt3XMIQnlz/H9lgUcEpLEsb2tRG8bsXtm
	LpqGdNNSQW2zRg==
X-Received: by 2002:a05:6000:e89:b0:487:baa:aa6b with SMTP id ffacd0b85a97d-48e6e4fac5bmr20986010f8f.43.1793701726165;
        Tue, 03 Nov 2026 02:28:46 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b7815fsm24941003f8f.22.2026.11.03.02.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 02:28:45 -0800 (PST)
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
Subject: [PATCH v3 0/2] mm/userfaultfd: recheck WP registration in the hugetlb UFFDIO_COPY retry
Date: Tue,  3 Nov 2026 11:28:34 +0100
Message-ID: <20261103102840.68903-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9hxi93buwd3ndd8ky3m8e9gxxsf3n8u6
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: E207440005
X-HE-Tag: 1793701727-119749
X-HE-Meta: U2FsdGVkX1+vCR0cd6jncowmH8KQP+PpW3MCN7jL9NKowpMbwccCMNc9/YsJDCbt4Up0LsPX4nFs3GuA8GWYrkLPUFFEPDE3iaXud2cNpfAXSgh7dO+YxYpLxLBdvsfKArPUnAySjeHzXYexIWpe47pKbzy/7F0oCWTW2ndGnX0cCsIHhCvojW8BE5vHEEKuTM62TRPQSRFJHIrz62sJbS5R+hHxRWU7b6Rdj82kQOIx7oQlLotljX/jBMwvaX3GR3sK4//9yd0itq4LuMYx6BpmQA2F9FKTHfEygPR8UUhQHcOaQW0tdAQtyQPdrJBhPKWWAIkAi2c9SZ/o2pAJgWH0cjPRDCW0ylA0YpKKfQLwsRJeGmlF6ZyCTFk4savSgy6PU7qEJmiBT1oiE77MBOGl/kFNtXJBpLL9YUFrptY+2GWgLI12NUv3CoRIbqzupQADfDHvQkxbRyKg0CfKSSMUJI/4JektxsRUu4nMpIk3DVvLMyJG2+kOl/6iC8NqCpHixOihsQrAwC3fVLGCP3UNyZOvjuz2prJEBofT3tMiJk+spjpqcH+jquFJ1zmm6LCQUjS7nIUYYEVzLoGbTiBHS2R25BN3vUjUBsGXsbwjP4lJ1gL7M2aIXVem7OmhJkzOFrEOqrRhvafd4xFRF/lWZo5Z/mFKZ5P9WDU20k3m9zuwmqQ3tNZEqzfDdCSHFbthowWQRHpa2vkDLMY+dF/ZPd23hl1lhJgoimTOa5XEBlYglN+nH6iyiLm/zHqx7VyfkIae9YgWov3v4vWH/zQNaiFBNzvTcZU30djU38QELXO9Al8CUaIR7j624ttGf6TFT6bCgy6vGsB9faXyruZOnHggOQEuYX2/zQmQ9Igt2Rrt0gid1fDVkIRc2gTr/VAT2h1w4HrfMhVZNYm/slASmyCMhO/1S2CvufdA35Pa44yDK92W69f1fRwxnfGoqIJKJdpgqkZAKmz/X2D
 TmLBM2E0
 1deEKJtV4Gnvz2TkUG5Eg1e7o8U3q+OVRpWCNzFslVTEXTepbk9/+KYA2HiuhuET6+hLDQX+d4J2ZWcS7PmzqTp2YD0i7fFhKUUtRbmPStvTc6d71QZUenYjJrOuApbjRzSUrss2do0lnJLQDIjti9bkOQtXIgs0ixQ+zPyTj3smdrTKfLbKf8R2CyQdpFixHKi8fTFaFs33w+jCeTCnQGbdrAaVhytU6QbCrQRIjSMfrjpqp7p8d18bAaloqHAvNvvKL0JR1QNhC5jHI77xhRdGg/wM2pRHTJw8pvPrBj3ixGUP8+Nwd5742BJJwEOpaLq8GPKg05kXrA8cOPgh/kdgSQf0go3raKe3qv4K9LKV3WVVYwKB8KFk4BQLS6uGfpKaWUkOaz/xF7yLorz1lpqYVcGgLivaSUTmuMT1BhOTjnvtCcy0SttygQ1pGok4TxN3zrEsqW9ThvZNJqlDLqo1mdznzdl3Gq6VM+l0Q0v8PIPY=
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

Patch 1 adds the missing check. Patch 2 adds a uffd-unit-tests case for
it, which fails on hugetlb without patch 1.

The other source 6/10 of [1] mentions, UFFDIO_COPY in MODE_WP racing
with UFFDIO_UNREGISTER [2], is closed by "mm/userfaultfd: write-lock the
VMA before waking waiters when unregistering" [3].

Based on mm-unstable.

Tested on x86_64 in QEMU.

[1] https://lore.kernel.org/20261015-urgent_fixes-v1-0-42796911043b@kernel.org
[2] https://lore.kernel.org/20261015-urgent_fixes-v1-6-42796911043b@kernel.org
[3] https://lore.kernel.org/20261031-fixes_core-v3-23-d6437171ecc3@kernel.org (in linux-next)
[4] https://lore.kernel.org/sashiko-outbox-194303@kernel.org

Changes in v3:
- 2/2: open the source userfaultfd with O_NONBLOCK and check for POLLIN,
  so poll() waits for the fault instead of returning POLLERR at once
  (reported by sashiko [4]), add Mike's Reviewed-by
- rebase on mm-unstable

Changes in v2:
- 1/2: drop the leftover sentence and the non-hugetlb reference from the
  commit message, add Mike's Reviewed-by
- 2/2: "all memory types" in the commit message, rename copy to result
- rebase on mm-unstable

v2: https://lore.kernel.org/20261102081140.201987-1-azpijr@gmail.com
v1: https://lore.kernel.org/20261029221129.89068-1-azpijr@gmail.com

Jose A. Perez de Azpillaga (2):
  mm/userfaultfd: recheck WP registration in the hugetlb UFFDIO_COPY
    retry
  selftests/mm: add a uffd test for re-registering during UFFDIO_COPY

 mm/userfaultfd.c                             |   4 +
 tools/testing/selftests/mm/uffd-unit-tests.c | 105 +++++++++++++++++++
 2 files changed, 109 insertions(+)


base-commit: 0ea6dc8c4a2192227ec25768625686b8fcd5cb09
--
2.56.0


