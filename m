Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D0BF606A33F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fq1rfYgK
Received: by kanga.kvack.org (Postfix)
	id 2B7196B05B2; Tue,  3 Nov 2026 13:19:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28E4E6B05B3; Tue,  3 Nov 2026 13:19:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A53F6B05B4; Tue,  3 Nov 2026 13:19:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAA436B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:19:30 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7AA7D80521
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:19:30 +0000 (UTC)
X-FDA: 85394620500.04.437090C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id EE1B780002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:19:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fq1rfYgK;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793729969;
	b=ayiIpwFL0qTTNeonybl48MnM8ldqZuNpbop+loluP5WKdClTd5eoPjIIN26tPhI2Xbm4Sm
	p8uWnP463iHwKpzqyKXfBVCe/Kvx/wU5iJOXW8UaakzpfMdm5g78YAx25prWOVFT6n42t5
	xjT1b6TGTk+O1uCfPLKiy7eSGKQ8qPo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793729969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=311d7n2dqnSPEAnLl6q87tl5I8DFqOkQSr5KKtyq8g8=;
	b=DVAgHFoCM9AN/zNCcfOM5xxsbANpAx/xIwlUBv4rYtiY4RPpwvGAO8PrDcTYotlklaiU08
	8PwlMgHR0xWtWYJIySZcSZD0qlRPKyKUaTHdd3y3O2jj73kXMhNH/oNLQ/8ay8NzNBlrK1
	E2R4a7db6y30ZZUgDcmAEJCc4z8D8Uc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fq1rfYgK;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D903C41625;
	Tue,  3 Nov 2026 18:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C0E1F00A22;
	Tue,  3 Nov 2026 18:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793729967;
	bh=311d7n2dqnSPEAnLl6q87tl5I8DFqOkQSr5KKtyq8g8=;
	h=From:To:Cc:Subject:Date;
	b=fq1rfYgKXk42I9ToJEzH73Q9X1IWBI2kJKuMUvrEQ77nSva0xnf9nltI88RY3onHu
	 K7iTQ/pcQotwqKX+7eB0AZvkGVaT3W0tjqSbV3FTb4Jt7iDPVp1GaHjPjOmSVXazRT
	 C+jVBJ++MckWwU4WdjJn1dxNX8WRr7TArZ027tWwy2SsBA4oOPMKHtsOoc8D5WYUhz
	 qHAKOWBsViGGU4HsnJKHMIyNaIlJNkLendDJJZE9U5OcNxan2CFopA3mLqgMUa7Kqz
	 G6FVmtWAeKYlO/H6YyJYIRAwQyFMwNvn/DkYO55naShWgbwsLnbCIEB9gfPUtMaR6w
	 g59g4NhKrEQlw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Samiullah Khawaja <skhawaja@google.com>
Cc: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] memfd_luo: keep memfd frozen until finish
Date: Tue,  3 Nov 2026 19:19:12 +0100
Message-ID: <20261103181916.2462825-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: i8thopws9ojj88sgbtgbh4on8b1rf637
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EE1B780002
X-HE-Tag: 1793729968-530653
X-HE-Meta: U2FsdGVkX1+gQQJD5GJNOo2Ob4LFLzzIIdeKqrXqBRHk6cK45cirWErnDpJJCetZ2A9ICqQctmQQFL2ang3KHF8SDa6apOU8xGrB3io1Ed9bnvCNXUaXhuCz6WeCtwIEPWp8OKO496f+HJI86Sq/ffm/Vq4pqH8pGuaEhDUBaer5V2iirnlLvlVEhIx1VGp8XyKV94cbcaRancy6es+p9qeq/uLUh6+g/7AFimqdFmdYhTLMP75rppzHN5ESzanl8LIEl9gmTxyFBDaQg4buu5OwLGgnJ4EZguDiIpN4hXphvCPo0hh69C9Gx8hjtzEy3kDHHzwLP3MIxNE8xR4byCjQWH++5gfEIuG193lB+xpXPo+l9kDwJWDwTWcJZ0hYE9LFyrlxXU+xKovbK2x+UyD7/vUN9metOLoR+RwYUEJwZRKqOBJqC+aBaPsqjKVM2yLAZmliuzZDqe6OooTHKuP1cNp62Hdqeerc6SNqVXMH36PbhPkgPJNLw+qEFD7d+s4U9nbEBsYQI3ljNz2/mbxjI/U19k/2ApaSnt0Y7PZQRgLxYy3M3VGhv0KkuZ5ILSpM6KVyASKK1X424nRxXG+djGoIIEt8VWZO8RMREocGZfCPKhx3GcnZAbGy6KIWfh0Yi43SlUgk71fLeWx65J/AmONmCfMVk3mHfCUMZF1H1fsxq8Bu4Wgyf4nhP7/sjbzBWcEt2a1QNymhHUeh5RlfqFs6UQJn+0nDW+qqpvppVPehep9bujx5hTz/sae8iiVBe26EVl9lYWhsN+l1uqZYv+TXsIEARCt4AYNrOOvlVmfFH8PxPDhU1Ea0EuQ6F0Xiki5N+POxRQtLUPx6MYIxLmm4+0ALI+ZlRgHeU0ShsV+GWjhYKLE6RaEVpfJgujqqFTSyie793D65pg4TtYu3Mm0nLHauUdZVvdhf9CVDZBv3vRn6Hrwf6DLJry0+P6KemYhIR9vxa3UojZt
 Sz4uR32g
 7jtWwigEPjOsFOuNrxANpWQc/SjML5zFBxa2/HlVZ+i3+g4qjv/frwsoqIHxWoaQhAMEexmRo6w4LIzrfrMB6fcGGWCWFsKD3JAmsVUKYiBAQse/Gp31sFJu+anPqiDZwq8Kr3lmK1OmedimecnCgPsqafl+9oFfefFMlWAfmoW3sNHzQzQ1D3KeZHQy8EvsAw2VuO8lsieHb8lPUVZeAUUG/I8v1HyHE+NSYs4XM9d84GXc3f6iWY8HOntIFVO2FYBmF4L8KPQRq9uNfecipx5iV5ne/b9z2QHghgOnWcqbFZIQmJasWpSmXH0pLcSmxQZB9HRqVDI4Pyrk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hi,

This series keeps a retrieved memfd frozen until finish. The main
motivation is to let dependents like iommufd have a chance to acquire a
reference. It also fits conceptually: finish is the point when the file
should be back to "normal".

Patch 1 allows keeping private_data from retrieve to finish. This is
needed by memfd to keep hold of folios_ser, which it uses to give up its
pins.

Patch 2 does the main change.

The series is based on
https://lore.kernel.org/kexec/20261103172251.2348370-1-pratyush@kernel.org/T/#u.

Regards,
Pratyush Yadav

Pratyush Yadav (Google) (2):
  liveupdate: luo_file: allow keeping private_data from retrieve until
    finish
  mm/memfd_luo: keep memfd frozen until finish

 include/linux/liveupdate.h   |  8 ++--
 kernel/liveupdate/luo_file.c | 11 +++--
 mm/memfd_luo.c               | 87 ++++++++++++++++++++++++++++--------
 3 files changed, 81 insertions(+), 25 deletions(-)

-- 
2.56.0.385.gac671c819a-goog


