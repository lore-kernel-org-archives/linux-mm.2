Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33BAF606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VyLM+F6M
Received: by kanga.kvack.org (Postfix)
	id 35A866B0995; Wed, 28 Oct 2026 00:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30B4E6B0996; Wed, 28 Oct 2026 00:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FA2C6B0997; Wed, 28 Oct 2026 00:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F13356B0995
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:59:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04913160BE6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:59:12 +0000 (UTC)
X-FDA: 85370830986.24.9E1C6FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7BBBA40002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:59:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VyLM+F6M;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793163551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HdV3apPdLyC8bMjqmehVYLY7PzMWkDboquQikZWI4nA=;
	b=haAxGdgwEp9hCtthjaf0OBj+IAh5fELxzWMnBz+HKVE392B41P6HXHTD4wWU78Im/F1gmu
	JiqgnohQ7w1ZJ5b0CNZsEnQDVIS8ZYdlq94/uyUdoZfj0ixq359X/VY+Ir1YzRZhIX9XBX
	PK5yOqYllI/yXi+lIfDWCrIjLLWVdYQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VyLM+F6M;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793163551;
	b=LOtmiXJWODIeVLNNzRf6BC7neisw3qHSphuZJ4OIACmklkQIhjM8oe7ju4tNUrzl50nzDH
	/z0nKX0trOqp8ANDcrxJBD50oDJk7KbV01yO632stquL6E56cbuE7IVxABFVJSrboAxMJb
	MFkdD8EwDB19h3FcXx5wX5G5lpPc6qI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01BE7600C8;
	Wed, 28 Oct 2026 04:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7855A1F01829;
	Wed, 28 Oct 2026 04:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793163550;
	bh=HdV3apPdLyC8bMjqmehVYLY7PzMWkDboquQikZWI4nA=;
	h=From:To:Cc:Subject:Date;
	b=VyLM+F6MHcWTFromvSCOBqhXHWYRMbinGuWPugK6lmzkCwg9gmaiSrBSGsIGxAUdZ
	 9i4lxi8niWvi0du/oMmqh/2Q7osrc9R29sVo8FXGNVGR/ST9NlTV1W4H6NwyS8DnuT
	 TU+i2btygCBSYC1s7E8FUZnxB7p8uQLpLtBPfErZbwsMKsKzi3kDiOM7oX3gtqneMY
	 Rg84AzUoEvaxNWJTvSsw2RWPqbeQZLLt6UHD4W+xBM/uKpEBIbGUlrSqI58BDT8ITq
	 eft7TvOBOBAxi21bZPDoGAG7+Q+C4x1xsUQkMKZo0HXZwqzGalhXK7keYjKegR2Wki
	 JMUwXSkXJ/mkg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.6.y 0/2] mm/damon/sysfs: fix pid leaks from wrong error handlings
Date: Tue, 27 Oct 2026 21:58:59 -0700
Message-ID: <20261028045902.148624-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7BBBA40002
X-Stat-Signature: g1g9ckmjb9bc9rgbbbx1grdysa5pap7e
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793163551-249755
X-HE-Meta: U2FsdGVkX18+V3K4Dtt+Hu307gQ9Wg2+bidh3eJHOemkMKBFhM9lNjDVJbIgYamonSdqhmPiqSUEjEojrlkfSMrX2JrQOoMK7NsjfEM0G4B3UyTZEt2Aj+mWCpNVvSSG9benDzZ7+Xdw7ks3JiTbT+SoqFPUC/BXTbSebJ2jDOSF9NX5Ik7DX1HV2p7JeQWXeKmQMl+/684ndzwTKourncPdAL7NoclXTXrHAMjDlsmCqREULP23gaZIipf92yZX/74iFqU6sU/vVSB6t2QmWRGSMTwZC16S5OhGAp83jYYtBDkc3BPWwE04iokbV436LwJaYkZxc89VkUSiCW0+b8lAJ3FEZOKT/dC14rpVuRHP91Yu5B4Xj5KpysLr5CuB8TqEMlx/P/prWSXL/+yJXPQOy8w7ZKjgE9O3zCxCtvZGZNJ/z5ay4cWRsBRTJ6NRNXmMfltRMn6B4EycCF8VrhfgnYcHQckE3NJyIXk9ExgUKAul3qGfqiGorD9RdL6CFQsVHYssQwZrVvs3cw4sJdsL5YlvY3+OK6P/Z3N2SfkwdpOvuOj2+aquhmLX1EEnjjnWYUIrf5S060xONej3DtTQmNASrSzaRY7HyF8Dmaxkp6hTMF9DZ1EOFBxljDJc3H4wJEn/jCgYHB5sx1NMJ2lk4ZJWXADZ8KfxQdvT1oYCAcEpwEXCDixMi7ryHG1zoxYfDLhDGWseupWuSR3JoHmEVQKo5lJc9xC83WqI5bE11Xhgts13/ShESQCBYSo017kRT4vvlOeIWu0PPyo4LB4WSzPYpTvQVXfVpsDVAi7q57YCw3fc2v7ONhygtFqTG+/4/uHMw2Icfpu6XDMcMUmSb5UNEql6Cr8j7qdG2uT7gD6hxRMpAMAlc2Ct1tn2tyNzoALU7hXDACIWexGmXYH7q3HsZd9Ex8P8BVtSpfIRAL20ftpINCRuIyVx6eppVDMPajL/WMCw2piSSqO
 RSZ1U07k
 S6qtvE4+n6DAnREs493JnQpJhx3uqz1DPnrJBIhI6bbhKVlxCqXhHpxDtQgegiBWOUN00dbG8U9G5UjISLNaD1ksqzaUtWpmg4WJ9YWbNusPZX24AUwaE2NCJHS9s7zFZxQ/og3HhCDcl8wETad9yEED88Sl0AIx9WZN2f306Kbk5FaDiVAuLfidbrUvPKUm/QA8eWND0LSWvTKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON sysfs interface can leak pids due to wrong error handlings.  The
issue in the mainline has been fixed with code refactoring.  The
refactoring is done with commits including 7114bc5e01cf ("mm/damon/core:
add cleanup_target() ops callback").   Porting all the refactoring
changes to old stable kernels will be challenging.  Hence submitting
this non-mainline hotfix series.

SJ Park (2):
  mm/damon/sysfs: put target pids for damon_start() failure
  mm/damon/sysfs: put target pids for apply_inputs() failure

 mm/damon/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)


base-commit: 4d7468bef942db9da779a5960cf42694e84397d6
-- 
2.47.3

