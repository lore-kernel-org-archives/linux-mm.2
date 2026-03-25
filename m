Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41B1CFEA82C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 07:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A106B6B0089; Wed, 25 Mar 2026 03:38:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0C46B0005; Wed, 25 Mar 2026 03:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6F66B0092; Wed, 25 Mar 2026 03:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CB5C6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:38:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21E7A1B89AF
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:38:20 +0000 (UTC)
X-FDA: 84583782360.02.053A8F1
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3093E14000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:38:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=Fx1OVqB6;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	spf=pass (imf09.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774424298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0kayvcEZaNNI6TyXOdbY7FEWhmp/oITq1MJpxJ5exok=;
	b=lbI6uvb2K1yy3ksE41uJSxrxUQsqu0G9T9c4sp2xBasK9wR49/IRqVTSOGJT15B6QAS/PC
	WDOo9+G56OlyIWQk9Rn6Q+saAxb+pu0IlX4BmLFdQVS0cRw6H6ZldpOwnMFdnaXYuCanVf
	se8DtN7E5RHqmI3CPtZVKuIDgowOQQg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774424298; a=rsa-sha256;
	cv=pass;
	b=DOkvfFQxOeJdF2KcU2AP2LUz+NTzHC9qmC2PVp3y5KUw72WQdHQh8E5eKqKOVhZdaiC4HW
	KYT/Z3V+6988v7q+mqt2Qi70oAV6pXePdXJowN42sUDoORa/PF6naX4TEEVF0DxxmqYd5H
	RFgusR9jSlcNCYeqpOR/eieg+HlKzOE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=Fx1OVqB6;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	spf=pass (imf09.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1774424284; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=QPL3xoec3+J16npX/yz/2M5R3W1E6C3tR1py4XzMlTvaCFq4LUuzPH2gTSiT+3/ZHadMhEuco1CCIiEHXBeEvrShTlo6BrX49OBwKJ7TDdQkx7zuNjrLcRmptyCPkRTQVJD/o3pPe19zjt4wNowSXcvPqpHoJsbU6E17CfLrM4Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774424284; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=0kayvcEZaNNI6TyXOdbY7FEWhmp/oITq1MJpxJ5exok=; 
	b=gVGMeEifXtiSW/dOGM8LOOBNr3STQQ8iAcdz12Np9Tr/zLl6x3XJrJar1/BWWOePbbkQA/3LgOAwnEEiC6xhXIEmrYM0llK/ey0iVpBDI2Xb+4nxJDmM1suFdA/32+dBhXkgLE0GY4RwoKQ/MN3oVAsEmAFt/6JCEn+GRA7Rvvc=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774424284;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=0kayvcEZaNNI6TyXOdbY7FEWhmp/oITq1MJpxJ5exok=;
	b=Fx1OVqB6WtNEBn8pwvSs1o03QLWi9WcRTJReosKdlkqH1w27ArGsuvpYIAkH2G2C
	fzdSrB1r/2qqBuKHu2Thr1mlXtPWmuoa9i3eSqHm62RaKTQK5Xl7xBpyB0BWgnwjOXY
	XPrjkz6DCePqPIrr/KqeFWPy6xEKmmUBwHMd5kfE=
Received: by mx.zoho.eu with SMTPS id 1774424281840800.3483260836631;
	Wed, 25 Mar 2026 08:38:01 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH 0/3] mm/damon/core: small cleanups
Date: Wed, 25 Mar 2026 07:37:57 +0000
Message-Id: <20260325073800.141756-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 3093E14000B
X-Stat-Signature: b9ouws45orpgxfs6e4mxas83f3an4n33
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774424297-688755
X-HE-Meta: U2FsdGVkX18MPmDtK1t30KbcThzyRVuZ0kIUKRo5xMkVVBynk/AW7R5X6dlhPM8iiQmyDXajh6oAfprn1tTKpcFEYSAbC+bkOIuWslviI4ZPFEiVbnuNxQA/Go/pTrnSpfdXNzOHK1qYYxFwxpbkQRQwfeCkAw2TjO+pwzAy0TOz5tfI0jzWTL+hNzLEBBUWR4+hhaE0Q0xUVFjR2k9FRO0Ru8vdHQxcEx1EZwBO3YDCKikz9LNJv7UktIwaXh3BSHQ9ywwh5bsCktDa85295ljRia8pf2vkhfXSMWK1YiZVhvmj6GmSg5Bf71YSlcxl9cvZ5z7KGi9TcQ+hvaGVnOC9ajDYxFPYf7qE3/6bT+qxBYfQrvqXkdCwK53T+/QU+77XGZflTsN6qSq/4nJ14rKkViJtd4fQ7X4TPaIjbvDrKXa8a4wyHdCugIU98mbBx4icz//ythex1NTyJbeUpXef3cXekmMb1//cHHOCp/rT8XY6cShrPyyDdnP24WNCPET9xdhJff/t/ARzHtP9MaIr/0XjfbVLGUholUZ6sRmmVh7JSEmbtuGCPQ/9bXGImzK/IYLaUkfwmj7QN7MSUOe/w+dJ9SX3sPPBy3+kX0BZ7yjCc9xLSH2VqQ9NZ0PTrIbmUhQebPVQgYtM1+hdR2ET0xgQjtAuCt4DGnu/4Hbb6vN1azwjizxBR/EREQR03c8zxeyPZeowvZbWnqbmamWVfdfdzlXfs74zNqCYUhiAmEp4oJbTRCV6JdO8jNika3RqNksU23aRbgTyYwdwtaV8WQv1OfqGTpiI4jBZKW2jATtLCHzVULhf4CmcF5HXptfa52SQLvD9INo6BdzZU1XQNz4zP64Zbzu9hYvNepBLD3lW91lVOXt2AEPBQfin3RFyp2dvRoYkxyN225HQioWuwKHqvpf6xTUaFMXn8KiJ0olgOv8+ByMnVBSVL+NPIxjtiKqbRdGG2+Lml7P
 lHTX+LWD
 xJ/aUnAIa0+EMuY7LiF5AulgukxJ3Mxv2renrBp3atdFqZXQqfoxo6NgRJpnsE6zpIQAKSsiFJGrSK8E3RhmBnPdx+YnoMhY/hkqXK3oq904Nj4BtORToTy4Pol9f+65LHeNf4gi5QGH38yWzQ7ardYTxz55HeaCWbXihz28oHlZOa3S33LNSX6Asg/86zxFH5or+Zh3bDcceD0UeMSXt4371c8AKATQLcVYIquBzJId+M15QPp0j160zNMUeeAN9SJMAan1mnldjbWzO/vdcM4nj1xfSLTR7xgDyGhZ2mo80SH+BzCJA1dPyXxN86FSpll1r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Three small cleanups for mm/damon/core.c:

1. Extract duplicated scheme-index-finding loops into a helper.

2. Use the already-maintained damon_nr_regions() instead of walking the
   region list to count in damon_commit_target_regions().

3. Move the static last_nr_regions variable in kdamond_split_regions()
   into struct damon_ctx so each kdamond tracks its own state.

Josh Law (3):
  mm/damon/core: deduplicate scheme index lookup into helper
  mm/damon/core: use damon_nr_regions() in damon_commit_target_regions()
  mm/damon/core: move last_nr_regions from static local to damon_ctx

 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 54 ++++++++++++++++++-------------------------
 2 files changed, 24 insertions(+), 32 deletions(-)

-- 
2.34.1


