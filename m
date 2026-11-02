Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B595606A332
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 08:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kUTbAdm1
Received: by kanga.kvack.org (Postfix)
	id 0DAC16B05B4; Mon,  2 Nov 2026 03:11:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 064B56B05B5; Mon,  2 Nov 2026 03:11:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6EAB6B05B6; Mon,  2 Nov 2026 03:11:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0A916B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:11:49 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81BCA140BAF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:11:48 +0000 (UTC)
X-FDA: 85389460296.12.9079CA7
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf18.hostedemail.com (Postfix) with ESMTP id C05011C0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:11:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kUTbAdm1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793607106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=n45aLFyavI2LtF2m7I+VQnPGHMyctlLmfLLfzdcQlpQ=;
	b=GVU8imEgoihilM1fSP/Sngq0kgAd6kvkQYT7oHORTMCpy2+o2dBzHS1x+m4Impg0rSSaY0
	QptOhzzga/U4AvgkPo2suyGSe8UIheCndvWdS3YU7jlqwgp+nOdg/fra3NayPn0dAnZawh
	nhYT15liFdKBmwnP9Z1gWdQLKgQlgIE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kUTbAdm1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793607106;
	b=6dPipv627EzRSCPQhcjc1n7cGenMlNA91lWM10teKgys2u9JlyWHTTXV2mALCDhPMAwdhw
	wGBvUTW46TKme9idUDoB1/4EoDwD+4y4du/1Y0bFZ6ycmjogYPzPcK7Dhd5WnWeQ0to3Q8
	Ie8ZOxK70NW/5CC8VsyZpC3IbGlm4mg=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso30577575e9.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 00:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793607105; x=1794211905; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=n45aLFyavI2LtF2m7I+VQnPGHMyctlLmfLLfzdcQlpQ=;
        b=kUTbAdm1MWjn10xEQU1auuSvgb+5QGEofgWkEa43Hc/F9ddmdTIoU2My6ITCD610fZ
         QmlhHf8VQGg4VWG3SWExdT/jOKROgCZKFHBJN6sv2dGzO4uFPF+R/pUd3z7BxBzKAsap
         JQS0d4cLwi3vJ7hHbmJ0YV4ta1paTPLlmBLm30t6iul9TQTRuD2jjCW2rqQbfOHmwaiu
         7Z7mxidYRzsTQsOkHIKVc12+FqywQkg+l9wuLDCM7cVTtZCJtlinzKpxrNrTxf9ZkOa7
         AEJfiG3i/Qo3FPxz3RbWg6kMXSozOWSOzNsqnmUfanhFaUEKheUVwXbzRTzEIMojBCfi
         d2Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793607105; x=1794211905;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n45aLFyavI2LtF2m7I+VQnPGHMyctlLmfLLfzdcQlpQ=;
        b=M4LCq23TeuKTLktWtSwUVcqL3o38F9/lGlv2WiSlN/eMOF2/QSFb8PoiXGiesWkp4e
         pl0yPWNz1BFLY3V+oy5ur1SsD1+ap9e6bodmf9hYd0g2+0njiDz2Bo5xY1Yme4fj6bZP
         U0JYilXxBLOJR27Z1QEtRgNOz56qEna7kZZgtxVRTEdvYTx1Xyht16eMKyU6BpmC+FK8
         VMQDKoivSsEB2YmdiPDWWPhgz/u9NWYP8p7CHqbVgW6pBxDMK4gUPLic75djdxr6KPOo
         JzAz0OoSlfX+t7gEZiFP5ojaw4zyECdh0Cv5ToiWBJEd/AT3J6zDWCAfJkYfDnNG+KmA
         W1RQ==
X-Forwarded-Encrypted: i=1; AKwUvBwnEtGi3poQoIRmlhfhs2yXEs80AQbsA6ji50nxquqSIy8v6gHi+zXiyanQ1DaOwMj7d2Pc6SpWcA==@kvack.org
X-Gm-Message-State: AFq9FYItnsAqlBqgGSlm5HA1eIADQNOaw1lqmhWUUsYaQoBmfbalhrdr
	gIi0+ozYEJwj/Yy0jhqPuNxTPOlxIr5GaLlkg1VBBFu1m9yu90r3nQ95
X-Gm-Gg: AYBFou0vHP9KQagRalisBUNucePQiz1GgUQWPb8nsGDIsbOcJF6qqcNFllE2c1LSdUW
	KsH5ZUw6lpnbqBFqyzKlrOrKvQL/x5bp89dGc5myALAP1EVRFSQnnmDdcGJ8QWWJfLpaqUHuZ84
	14ekqtEgMMYR/1XkCZa3iAZfht1+4KCLHGAiQsV+RIO2THUj6RKPHu6lDDIOWQeOwFW2ehvBGL7
	T24mcm2Q/fnRSdYeF/oPEpV7/3yNn8zI7b82EcIaBMovNN//lcn97P4uDKVr5G63srFFoziAmeg
	55ntcCUh2Ev1DIOJeaBsDTWy1gg6lF+tjVOaIWHN835HT6CcgpD1ndOOQoqYzhdLCPCQu7DiGRl
	CBcKLCdI18w206dxkL0oaHwmv7dXPLSm3RA+yNdOu7LbuoQbAFcSgOrYPFYEStMzJQRGrroR736
	6fGNUcS1H7815AULZTmr3O7wSU4mdjoQzh4/Ck1fJHG/6LNRW75Kev/4FT5Za1DrWXP0lV0aQOw
	jH7HSt4va8QZ2WqquDRF/jNg4keCviDpBqAp9TN06zKLOMn6OOMaC7IQN8uU/vKPzFP2oeP9BLV
	oAddoJNiArmXfgTfxDcnccGRe9ob0Fahpoo=
X-Received: by 2002:a05:600c:46d2:b0:4a1:7ec7:a479 with SMTP id 5b1f17b1804b1-4ac1980118cmr202498175e9.33.1793607105171;
        Mon, 02 Nov 2026 00:11:45 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa8213ead6sm333331005e9.14.2026.11.02.00.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 00:11:44 -0800 (PST)
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
Subject: [PATCH v2 0/2] mm/userfaultfd: recheck WP registration in the hugetlb UFFDIO_COPY retry
Date: Mon,  2 Nov 2026 09:11:29 +0100
Message-ID: <20261102081140.201987-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C05011C0005
X-Rspam-User: 
X-Stat-Signature: 1hn7mnxqnbra4cyf9h4ywom5ymxkwjb7
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793607106-666758
X-HE-Meta: U2FsdGVkX19xs0ztVjDiF2xlolpX47VYN32CCYnIEFrdyg42Q8ub8u883faWR1JQH0N6QWXcxAPIGSaPwy5CCkKfLI3atNXELY3pcRk0wAHFPn4suUQ4HC6nP3IRl/UJfQe/oMDJ4qWuaI+PZmu0cNSgdr5kepxk7FB/Nl93XWSgrd/jVM+lAilbSoIPwbRrrsYXz0SRj1wER/tzbTdch/g/GSBrTZ5DnuZ+A2zzuSDW8wrgKdM9kb/4yZtou9H+1DuoxcTgMU8yp+ut7dIS3thI6Ivg2Dk3PhSE/DT/EGsEsxSzRUAVI5RUUeW91RHAcCBTH0yxp3M7weXfzGyt6GFOoxoX7Q7SO6L2TMDdvB6Sij+h+Smmkp+eYmwacUZdy1a2JFH23RxXjUlsVOR4JJAK/zsAqJ29eKjPUBAvB8h5fY6h+tZVlkEdIJ50qwY3vUfCYtmoh26OjlSRGDzpFO1b32H5TXRxY3Iib/awi+mDZjeqn/bbzx0C0k8olKW2hjp27pIa0oyECkAwKz4MrLfWQgtizztFIWTBOPvkScKcPlwgc1KSJfM8rpehcRjt1ajvjilr1Hq0ZNSQYq3HbCAmwd0TQZmKTuazHyObLNbEpBZaMhsmvLX0EuP2O3R/YJYimXE4KJDpEPrWVADbOly2Mdxp1JnI2wKXUfz6IjLi44hfcgg378AIKOuOgXKhqgKiVjSUoG1toz0Wfbi5CcI/zAMgh4cu5yNpSwZw42V9OVO2BgQv17bPGTV6GXghBBaJ75RoeaQAKXR+ITOyQCqbk11Gjtebv08q9+3YJAWY/8iNT7SsS4hzAT0yZPv6EFbl+Ln5KGQKPIrxp29gVGtIip7bFemVOQE6AhxLtZDQhKu8orpBiVmJeCpZ+6/Ejnh4IDWWH0k4VbfddXV+Gxl9qN5Nyz3dounE11m4XUJuu5hfWQII0DC3ikp9dchC1lr9QC3FrowyHFbIgSi
 3+go2Nqq
 mb5sMFAAGKNUYNGckqfthhCoyDnnUi52ZkoWH+ViUWdxdBY+yK0FymZXQ23/VPXT1vIVXXJSTZl03uKwPobWt+P3t9JC2tkrzL6K1+DtsRGlBPn0LjzvTgJJOqM9nOz89nQlkIEqz5tMYzIn1PS/hdjIxIfdqqLcNbyTV9fclPiyxakAJgiqaTGKqSACsoe+g8Qr09GGl2tp509DMH2oKoMolGJg0Io73GPPYcmXqx6m/zBLFt4joG8WoC/R0CtrEOut9ynDKCLo40vIgguxgG3h3CFewOWJH/QP35DqGQWdaP1gPWWrv2o5jEnnr9IAUR6lKt5+oYIyDv/p4kvwXi6jlmesPmdJF+u0/gPaVjuzu42HqCaSMsHv5eBTfp14XnawyafPUWBf7S5nT9VxYVdbp9Lf6cI1NLj/9iETcYr1o5XnVzRZ0by9sFoZ8YG83pR5GHr0rheXwR0tsWsy+0qFg5RuAufzuWEmA/asael/nXJc=
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
[3] https://lore.kernel.org/20261027-fixes_core-v1-23-6f74bec9a5bb@kernel.org (v1, now 23/47 in v3)

Changes in v2:
- 1/2: drop the leftover sentence and the non-hugetlb reference from the
  commit message, add Mike's Reviewed-by
- 2/2: "all memory types" in the commit message, rename copy to result
- rebase on mm-unstable

v1: https://lore.kernel.org/20261029221129.89068-1-azpijr@gmail.com

Jose A. Perez de Azpillaga (2):
  mm/userfaultfd: recheck WP registration in the hugetlb UFFDIO_COPY
    retry
  selftests/mm: add a uffd test for re-registering during UFFDIO_COPY

 mm/userfaultfd.c                             |   4 +
 tools/testing/selftests/mm/uffd-unit-tests.c | 105 +++++++++++++++++++
 2 files changed, 109 insertions(+)


base-commit: 34f88a114888c9dba49e45f2b0c2a3e83c4c871c
-- 
2.56.0


