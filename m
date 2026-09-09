Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BBB0C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 23:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C612B6B0092; Wed,  9 Sep 2026 19:44:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12A16B0093; Wed,  9 Sep 2026 19:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B28216B0095; Wed,  9 Sep 2026 19:44:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89ED46B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:44:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20CBBA03C5
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:44:23 +0000 (UTC)
X-FDA: 85195855206.24.D539A5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 856DCC0002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:44:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kvdssDLK;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788997461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dn6dhmzXIta29auJrOPZZyLCN/0sZUS3eFdMoIZgqmM=;
	b=ygRRiGW40xeEK/X1aOEv3zMiLy3bTTpyqjPCfqjg2nUAxp/7KlQtwsDgCmfGLobNdC4rbo
	/YlA9rDkiHDMGWZcyl6zO/yOMKJqlrI9l2qlEyDN25o7XSy3S5qg46XIgui++yEp2hkvqQ
	aCo88FvwUlga/T7URclJKz01gCaQGfI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788997461;
	b=BPSrYDPd8icPXWMT56Szduitvl63kw/U4tAeHgv/f+IuP0xUaDQ+VTasBzvnLWh2UEHWYI
	+ry3ZkS+JFM6irC4hEeoWanK1FVHdNdssHRAwhSDkzF9ryCD1MQ3LLoP2/pPiC+dV+W1eF
	kyJc4rmLlpnWIiuxOxQUqdtdKE715rc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kvdssDLK;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E091D415EB
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21AC1F000FF;
	Wed,  9 Sep 2026 23:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788997459;
	bh=dn6dhmzXIta29auJrOPZZyLCN/0sZUS3eFdMoIZgqmM=;
	h=From:To:Cc:Subject:Date;
	b=kvdssDLKRouNRQdcpwf27BN0zjX3j9PxXzJfF4M7eRuJQtRDP4PsJpuOAGw2kKD/x
	 7Etn+nzVl/9LkREieq7r8A175RXvO0qf9vt496kAIIrMvcfPjbZdTmvhvoBTNID2C6
	 g3XJiGFe2rwM2hpsc7c40uai2/aCmWD6JNSg28qvAmuFWWGe0VxMsHzXp9AkFKOh7L
	 Vq4ZzUIwL8fVWn4aLWsImZJxr+lj52s2lFsr9gmQHle+0/4F4Pv+koxzg4TH+AugiL
	 BcjrM/epQdBAI7qCBDPEWuCuRygDyiLxVPwARZ0s6ykhb1TDRt+ZrlcQRzPGwFbW86
	 6tzrFb4Lk8mNg==
From: SJ Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-08-17
Date: Wed,  9 Sep 2026 16:44:11 -0700
Message-ID: <20260909234412.108985-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: dw1e69db7b3z3kph9b49udd7s7s94xie
X-Rspamd-Queue-Id: 856DCC0002
X-HE-Tag: 1788997461-119661
X-HE-Meta: U2FsdGVkX1+AGkJrauEgnSNdCWXBfMLs96ewai9QYn1XsM1Hf5OXAUosrN2NLFBB3gclNsSh4sEgGlWQRBWUs/BOB2Cs7FAKjH99Sk6BWlE/PKkkf0bAeR2TcAJH+MKriTc3I5VahF95IP1TAmTmk61nko1B9fJSav/GpmNlCXVgUlPe9Zea+FI3pkSOlJsMwUk95fZA9QaMHh23cnInzKeS2eourjHZpt4bWv3I13zCQQCkEBVffGE54xNDXbsziSfnz0A8InWXqiP5oCzCbshGyI6F0FMMRojolkceixOMbeYTxtyZV4UwNfaEM8XHCrkRDpMZW1IKOjgkucoCZVTqx4oVattZJtVgZhaxGIMmOWQbiChXJChgKqQj8HlurQvrEwqNkdcgf+uTLdrax6pyJuq27gvRqkCCurOCa0/s5Kv2rDJrM3OAO4I8svSaKiarpFf2C70NfszvaHMzvDVVA/927lhCV2LzP+b6zv2+hol1f9ZR48ULLY3qHopMHA9P6ZGeezRe2gv5ccrY14lkzpL6zTYgeI9lui42ATLU+qpmaDG4hJfcl6kXrQlKft+ndhi81n3RsFK6gj2SHO7wpEsgWPwvBbNyl7HsiSLROOKAHMUpF4ObqF+QKhQbXiu46bzposcUdvlnR0yUr+ypO4JUEM3x4UiIm1GxiRU9hrZl2c/dn8DhI0/Y3uK6nhv3FDLoMPeSvyz6hTsbMj9K4wV198G0HuWq1ADdr7z2sfcOdtrT7Wzn+85qYrBanjQc8Z8TsoPhkhvlOBGrFEwHCALFFY4sJgEfqrirMVx8z6fV8zbl+mDrRaCRkW7/OXNTvAsrN9mKZynP99l3wa1+hpc/FGeZMV0goti5sk4wqaFC37l34Jzzhq8yvHQ+YIoJwy708zNUIrPe4tObIiiO2rp2UsQZ5IDjoVg852uhbPBJl6vSg/eL2/NKltcMFdMLcklbuxMYr9O/yLE
 rl4M0gMM
 GvreIUYwnpbVOzUfx8PKqF/mznbIA/AE0lb9oDoyCw2KySZhY2Egkeu18jhKygjtd6yDdiR0143vie5vv8Q30ziU3pISziBGOPRsB7I0b6Y0SXGrACkdK6B3lh2mATOq9XfsD2dXieXrNMSHWpwFFhS97Aa7LaOhRoIupXhh7dn/OACWEfGRXS2i/ZPwpbcn5rqfF3dNb+D5YbFc8lzGZM3bPy9fod+Yx0kUo2ZImkWs8d9KxQRqzYHaYkSc7plmStunZt6n/ologPha32gtlpx7rKAfRtj55w/DdmWvLJfpby4+NviVMmT1GNoigFPJmWI9xb/OYh+s2472vtOb6/dM8lP1syNrzbqxU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2026-09-14.

As usual, we have two time slots for meetings in the week.  The slot for
Tuesday is already reserved, though.  I will also be in Europe in the week of
2026-09-28.  Changing the time to CEST.  Next six time slots are as below.

2026-09-14 (Mon) 18:00 PT (not yet reserved)
2026-09-15 (Tue) 09:30 PT (reserved)
2026-09-28 (Mon) 18:00 CEST (not yet reserved)
2026-09-29 (Tue) 09:30 CEST (not yet reserved)
2026-10-12 (Mon) 18:00 PT (not yet reserved)
2026-10-13 (Tue) 09:30 PT (not yet reserved)

Please reach out to me (sj@kernel.org or whatever) to reserve the
not-yet-reserved time slots for your topics.  The reservation is made in a
First-Come First-Served way, and I will send a Google Meet link to
reservation-confirmed attendees.

Please note that other time slots are also available on demands.

Shared Calendar
---------------

You can get the schedule via this shared Google Calendar:
https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t


Thanks,
SJ

