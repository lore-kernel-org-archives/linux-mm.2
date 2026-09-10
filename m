Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A37DC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C4896B008C; Thu, 10 Sep 2026 05:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6766E6B0092; Thu, 10 Sep 2026 05:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58B8C6B0093; Thu, 10 Sep 2026 05:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33EA26B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:50:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 73A3A80452
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:50:22 +0000 (UTC)
X-FDA: 85197382284.25.6517EA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B3A8340005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:50:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iXU/ICQx";
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789033820;
	b=bgXxmEFtWMQI7OK9rBJ5bF6gHs6lIJPJ3Eoi/Yo4g1Dfxlu7IyTZLX2zthTKW/R6tHIm4u
	yjw51pxB50lvGUWqq47YjMDvXG86F/kwy1uxrUFQNaxN9OliFa/4we2PaOoQTsrTXlL5FS
	5CtnfgTjQillLEg71Yy8VKDlhkovPgQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iXU/ICQx";
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789033820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+muI1Y++JAFHBJSAeF9UgkoNUlxYs81VMFK72BiNI8Q=;
	b=gxMr5HgIMVAENqYPOVhtLOoOyN2tJZ+r7VjaF6mtnbBjk0h8qswbe8u382emHuUlcHqzgr
	8+EEnSB5XAYWM5vb11XfE3L1itSw3/1q2NHWfgEtAKzjwsGk01KD94+JtzG1PG2FsAGSGD
	SJs+tsesfrs5s9+DcPNN1CO8+6t97Jk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DECD440F0C;
	Thu, 10 Sep 2026 09:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C871F0089A;
	Thu, 10 Sep 2026 09:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789033819;
	bh=+muI1Y++JAFHBJSAeF9UgkoNUlxYs81VMFK72BiNI8Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=iXU/ICQxczIvc0UXPeHKVCCyAbyrOUnU28ptUDZtcUkKUshVpMQecMXSxoJfLo2y8
	 tLHwnte/wRhOF3BSyZe4lOs9Va5P1R95418z+3EO3bsGo0h8ovmkIrijsO1HYcOr98
	 Z+yp4LVKWS8UiOn8DM6OoE4YVEHGLmZWeRxTH5kTF6x0hBV8zZxGllJekHEdzEoBIv
	 kbbt+84OtF64aQPTikgs4DN7nFHRTAnIcxs7AYRZVwSuzCk7W1swrWwIPIouZgA3X9
	 Mh8vHTdS4hY3j/QroBuuqMR/JP3hgbnEPIlvnraDWpTclm8ozqf263IuJqeqOkYYp6
	 TRgx0mM8LsjyQ==
From: Mike Rapoport <rppt@kernel.org>
To: Alexander Graf <graf@amazon.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org
In-Reply-To: <20260909103001.2423403-1-kamalesh.babulal@oracle.com>
References: <20260909103001.2423403-1-kamalesh.babulal@oracle.com>
Subject: Re: [PATCH] kho: docs: fix scratch_phys debugfs cross-reference
Message-Id: <178903381353.3691424.1681861521367117461.b4-ty@b4>
Date: Thu, 10 Sep 2026 12:50:13 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B3A8340005
X-Stat-Signature: nfjy6zjykk75przofu6jhd45dbrpsun5
X-HE-Tag: 1789033820-663461
X-HE-Meta: U2FsdGVkX1+pc7dDxIFbWJAjz/QxQMd22meJffXK1AI6R94PEnyqFjj5zCU8CRulgAu3lwV+9ScK3Qt7AzKAnHe7pqNu11O3WovUfGsm2s/nIAT/4dxwnzb/7W+vjeua9yD5ecdX45FKSfPjtSuu14odBl1jsHXMiYL1gXCYpVuGKjbBFb41doR93fjZozySm8DFqrNAnhMSNXjApmi1AyZg1boqdPcqlADqsh2k6sAePbq08i2G7GNX46A2mCOwKc+hRvJTqfYSZNSE/bm2c3E42tKfWkpN+TV0qE6s1zZ8V5POUqQhmbHrxoqZA0HDCE1fdsmqCgi1GhLgXpLdpoYhamaj10ookl0fhhDiB5uHjLB3+4ntD+J9ek9ppmsEdSrsKWc0qUIxCMTagl07V3zQb0aWB+1Lh5AahqZEUD/QF3G8Z7RMSY+sM7thXf2gSRlX6NyEa0PIRnz8FnKef2MPUZB17HZvY+M2RcKv660mRk8Jtgbz+PE2KBuLDOyVLFA3srIgWD9zvj6+GKX2/I92PSnw3ONaLsQY9UdPQQL1PaRllJ4BkvJ1f2uPaKjexGT+VwuCHKi0vS6olTee4ck2vSYqEhqqw84ewwK670vs+vutcN5GOnNPsG+rjzUMoI9U/9o1YWWq9ElFmPQ1AEHV+uTUoI+zpdVhbbcnNNkR9do6a9Vkwp4iwFo9RvORbD3cZ5sUsrahI1PX/Cwtt2phR4Io8GnMaeLgUJzFHSn/+kOB7Z5scU9/yiVt5QhlQ6i6tD/e2/jxP5EvOR7iTVdK+e2yQTMigFUmPpURFo+IbQjSFcDqrP+rtj26rnWPCR/usebJdhsFyBoZmuVEqf8jQbQqpzyY5uRzpeYX0vUX2IHQ7hBKH0PjeWvkCqPecFNQYL8Rlh7BxWmj4NdPAEU/M52z3MVT2C2pxW0jJM9mYjJfbjKtuWyuzHc57dHijLUDfGlbgrfjwHsP5Gf
 6hLsTk0/
 e+8LQQN+S8JIswuBm4Ky2anAkoAOB6qGq4iFa8cc0pRmSiS6fz4XiZi2rDKNKSeeurbiube1adwBCwynCcT9dixPN+Z8xE5qaDUn6VMFyADJrdliHsWrHa7uPl75SxZDIQZkPYh2V/BKUFRD/SOTm+Hh3iCV/JIubDgaktAF2nHiKy8/dDJvgA2CVeM3FhVVoafTbl/VscW92HWxdoRI/g0R3/DilyHQHxA7zabz4Z5NKBVkZbIuReOja/bIjSG1j/CKni/Jd01ZAPWRVIna3NC8xYhK1sFWGakVY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 09 Sep 2026 16:00:01 +0530, Kamalesh Babulal wrote:
> kho: docs: fix scratch_phys debugfs cross-reference

Applied to liveupdate-7.4 branch of liveupdate/linux.git tree, thanks!

[1/1] kho: docs: fix scratch_phys debugfs cross-reference
      commit: dc645f2db7539352404525dd1b80236520fb39eb

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: liveupdate-7.4

--
Sincerely yours,
Mike.



