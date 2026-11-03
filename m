Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23AE3606D803
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PyzLButy
Received: by kanga.kvack.org (Postfix)
	id 3E68B6B05B6; Tue,  3 Nov 2026 06:49:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 399696B05B7; Tue,  3 Nov 2026 06:49:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AD846B05B8; Tue,  3 Nov 2026 06:49:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE936B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:49:59 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8FB3C40243
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:49:58 +0000 (UTC)
X-FDA: 85393638876.24.8DD2FAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id DC907C0004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:49:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PyzLButy;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793706596;
	b=vG7k5SSIILkUPTTA2jEWqbbNuR/B1RREDgzgSmrni9NrX6mqSKmbtv2x2vt7KlnSN4Rf29
	O6u+PVvYf/qYgX3Ah2oeO0pdVzJvlRxNgUf47MEZa0cz7NsdqC9v6JVIkLyUVdQZ4rud/O
	HGXVgw3vSiRskug8EOWPx1WsAsupjKo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793706596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=twt8xyp/PjuLOlMXlHAivsnx0jkVr0LdLW19Gs2AtO0=;
	b=1PeDKrtdUpW1cDcYyysemnN6J9QxOm77k7jpEXZXbspICV53mFxyNlxT7x6KvZOmAuI8Fv
	K7uH8sZ9Cj/SX+f+d1JOrhQVl71Kp+keFs+x8nYFl1cDGEe5GPZPbP4MSH1AqqKYRI3OAW
	RrMwb7JtIaJL/wbUT5OSYH3jON4xwxk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PyzLButy;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC2C643B5F;
	Tue,  3 Nov 2026 11:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A851F00919;
	Tue,  3 Nov 2026 11:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793706595;
	bh=twt8xyp/PjuLOlMXlHAivsnx0jkVr0LdLW19Gs2AtO0=;
	h=From:Subject:Date:To:Cc;
	b=PyzLButyVIP9s2N73x/7CD4RsthvVm0yhg9NB9mJIJEVW3AC9qYF3D/4UL63y2P5n
	 SqKTUVJkDulKszJ1WG+cseu48umKgXQlidqY/+KJJGYHbD/d2D1jvVzDpm1Cer33CB
	 zKqRyxEaYi1x/V8LAj5hMl0pnkvdIMaZF3nZZQLBUFsUYmsOlJYZJ0R53/gLx7AgM2
	 V77gJB6YkslcOQtrjBZ/ow2B6qUGcS9QSgD3NAAX8KWREIOfVh+7GoiwHFF3WJUB0z
	 yo3Jb0IJjP7nD4PF0LXi6OdCzoRjj1y3losd2DhClyZlw237SXIIcxRR5vy+bz/ZfM
	 w1TZmK2lIDKKQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/2] kho: fix bootmem sizing
Date: Tue, 03 Nov 2026 13:49:48 +0200
Message-Id: <20261103-kho-bootmem-sizing-v1-0-45aa74098f34@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMyw7CIBBFf6WZtcRCa038FeOCxwijAQyDxtj03
 wVdnpt7zgqMhZDhNKxQ8EVMOTWQuwFs0MmjINcY1KgWKcdJ3EMWJucaMQqmDyUvDm7R6OajVvM
 ETXwUvNL7Fz1f/sxPc0Nbe6k/jGYUpuhkQ59yIU9pHzVXLLBtXzJtQn6WAAAA
X-Change-ID: 20261103-kho-bootmem-sizing-5d6aed47a243
To: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>, 
 Kexin Liu <liukexin@kylinos.cn>, Sourabh Jain <sourabhjain@linux.ibm.com>, 
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: mx6ffq7uzhemcm3ww4weh19skrtdhpxy
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DC907C0004
X-HE-Tag: 1793706596-537980
X-HE-Meta: U2FsdGVkX19R7Kl/AYOuvU63XiEpgiFq62FXC5t1opfHa2e08GudrXLj71dphLRbSszETaZmMELe59yuPWyLF8tjHqP0ZkWe0KzyXBpH5UpYSN68CBMPiVP5lQAVB0dweleQB4LogMQw3MXI0R9n0Bf5eQbYOIdY+p65SKPKkU6FjHVggAPhsA6PgyAOW1nqhJytWyXkw/UDDtKc6t8UkQzHTmGKWRdPHVgNoBF/QLtzp3pqFUvEak5ZLHeIMoR7b0WfdCd0tDZzXiYcQg6vUx1bl1agtR4fP0qLckKlAuoZxgUP5tYAjfmKoTPZA2BKDWQVB4ImLPsJJRLce64pjJ2Y5v+7wYrPqges5hGcsFEKXUp36irjGsAia6tLV18nnW1EUhrKetTuHcbHXnIiTcemNcTG5dmcAceAVqu110+EsC1SvuKaR+SgkZoyxaRniuDpgo1d2o+Xdlw81IDOTXCt09Y9PMyVd2G6qXAyc12yF521Ish38i2YWEiz3ciYBXuXL1R8slKh1hZcHUDq51cPo7vVuhPuynw2tReNZV25LUw37dJFiee6KFUPgP6LOxYVCU/kMOCnfJYBtwR2zXbRQc7KUxgfgy+5/4EeHcn8wOjxfWHQun57W+kZmvIk6RW4yygMMUIgaUXRenMo6ew/5OQC6scLjMRO46dX/unQoFgGZ4BRtfMqKfV5/R/vC1HeyR1msP1Qt0WlNx1oflAoOTAT8y0GWt/nPcCqB2piQRzY9lLDxw3tPoQUQaanIE/lviphm+nsT8kgHYsCeYhu/PXfuEbNmu23Cxu2j+PYRLKkG2vZqMVaoI6AkGvUSKWXIZUTxUnR0Kl2+bHCwAPAh25tjyHjsrhUH7oaWQs+O/JaWuLXbdbigN/f5oSS9h0QT0F8z9U/rxGQ04ccY+ODzG9rvIrHKkN4WI4xODsih4T8oaTyJRDYrjGsSf9fpiWGy0u1lSyMW47enAw
 6LAw66Hi
 B6FnVXFwlvcPOCdV+F8E+GdwaGuk/3DBQbgox8Xx3uicHwEoUI/5BVJGMDNnJ8nKbHWaWgt9w8SXoNCVlPU/FuMDIg+RgA672cfFwJ+GNlDiLyGpwZeoiG4Zxg5SCTfwbBmTiccu8OPWAg0ZIgvsjmJMSwUAhQNaXugLigzjAiWBI5WZ544038czGWJYKvvllELf8mY/zCJ+UEnJP9EqTlBFbznLy24KTLdY15eAclnDA+IXvzLlL6fh+bqiGgebAJ6nGJx8ddJiE2KI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There were several reports about issues with KHO bootmem sizing.

The bootmem areas are sized from overlapping views of the memory reserved
in memblock, so on NUMA systems memory allocated on a node is accounted
twice and with CONFIG_NUMA=n the lowmem and the global areas are accounted
once again in the area of node 0. Besides, the lowmem and the global areas
are reserved even when they are empty.

The first patch skips empty bootmem areas and the second one makes the
lowmem, per-node and global areas cover separate parts of the reserved
memory.

---
Mike Rapoport (Microsoft) (2):
      kho: skip zero-sized lowmem and global bootmem areas
      kho: fix bootmem sizing

 kernel/liveupdate/kexec_handover.c | 142 +++++++++++++++++++------------------
 1 file changed, 72 insertions(+), 70 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261103-kho-bootmem-sizing-5d6aed47a243

--
Sincerely yours,
Mike.


