Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AA50C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 23:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58C9E6B0186; Wed, 12 Aug 2026 19:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53D116B0187; Wed, 12 Aug 2026 19:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 404FD6B0188; Wed, 12 Aug 2026 19:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 133A16B0186
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:46:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7021940542
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:46:54 +0000 (UTC)
X-FDA: 85094255148.16.12B1A0E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id EF55E40002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:46:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M3RMi0eC;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786578413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=STEyH6+S+leLoTBGNeAGk1gjokdgn1DVinq83zdPlOI=;
	b=Iq74OBXlacauuAmBBbYNhMrsPBXzEosRn1xETS92IyUta0ToChX0STSTAgpc+5YFcJdg0g
	1EyIvmDINo30yXKWTECohjiblNiZOskq/ocYSMxu0iePAhmEUnrCutkZPcfJ245OPgiaBZ
	3deX1TRL1ah0zlHLY3qnWH+0rPC6I1E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M3RMi0eC;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786578413;
	b=HtBxAd3tR3Gj9WIIHhXMkDa0G72n9PPvyh+1eMmdgTap0pZOAbq/WInA3/d3MVOolKFenf
	j55VU3eMDut6aYgr7A2Wzjf0RR8KaOxUl1AaR2aKyHheq5BD3fclVIYDDWPRFj18Iat1+E
	EudtJQuA1z8oNRoWVk9a7ZO5MPoX2po=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 703BF600AD
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070301F00A3A;
	Wed, 12 Aug 2026 23:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786578412;
	bh=STEyH6+S+leLoTBGNeAGk1gjokdgn1DVinq83zdPlOI=;
	h=From:To:Cc:Subject:Date;
	b=M3RMi0eCmHEW/N9RfgKNEe6lXHdIEpNYSTepzFpTd43JcPRHvF72rm7oxbktz6C8t
	 bEGFGe4vm0RI4WHbYgED/j5dE99qxKuSaXE/QSZhAoWb2TpaxJZFTgDLhzRWTNkVXl
	 NpHZxoGScnkFQ3p+ztr9aVLvtBHRtimRI36vgyTh8Re7ZVwRXmFpcTsIz0MSI5UY35
	 zOajhk718/au0hw9wXd5dIFS9eOXetMSsQic1ejVNh4b0IMI1FFgIsM77MoKybHH/6
	 ZWzog07G1bgLxNDnkmSbWRv8xYLKs0jv2lnJMUFoXSF+FcyjyctTo/5J+3QWZgCLPT
	 Yg8PASndP6x0g==
From: SJ Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-08-17
Date: Wed, 12 Aug 2026 16:46:44 -0700
Message-ID: <20260812234644.128198-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3kukhsaihjx9j56iqsfchbtmd31hwd6h
X-Rspamd-Queue-Id: EF55E40002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786578412-252794
X-HE-Meta: U2FsdGVkX1/JluhlT7FRsDefOlnUF6i7EHESdEqHeyqgXTMPL/TBNx0Oa9QMFJEs26BKOq0ixTA223SizlMiDoYau1RSkVvk2biPOSV1MS3KG46uCBmc9bWGtPekVUzlC3DDqLYgCDh9QqnXURNi0UJc8RMFXsqeKi/so35rMenJarQ05CvgIfKvViSfuzDIRiHIY+RqVZXMTd3lGs7fMZPihnxOW/hNLqSL1YJ/TXrwgMoQPOHSTgYNEk7+djklxCr9feYAF7bNjfvNFlZ4xyHlUCZ2b6KYKwZiJWNgKUUAZ5ZYCYQVhDpvRoWCDq7E5p6iqEjywykddpeKt1cAMMm8h/y1baLkXKqSgvpBJce4EFPjJz/DV1werDWxroR5z0Z+QU1PN2SGX+PqYrWepLifbLx79+69c2mWbnoJZz0L0HJXP2BjgeerCcGuYSi/B8YKLje8zPqo6AgJ17pDphGr7EEY0/PaIZ8xxnLOV7BXAoh1yCcuP6SJ+PmiViAnyyxZ/6cDFd4P18zvoMOqz3ofB3+Tgho+Z3mNKb88EeU0ky/yomNaObg7BsFJKV72+YbzGPcua2oF1xuq7/nK/hZKn0yR7uxcgKRK71wLQ9QwAScS82+bKZZNG3zr10ATlpJM1onNEsy5x5EsiKoO8FzvEpaRa4cUJ4FpwqYCR7oc96j/sYjQ0EToFMlDtRnjM09P/kfK/YUPvUjKyHfs4ing+DJpuFPuHNoeFkhXMzzEvp3IBb2GubKRlKIYFwWXdbeM/5fE4krp7RxvneaKTGB5PQiPyBTg9+TvieBn91JmzPPeKn32UJg9sS0Rdif8yu0ks9b3XpkBOIlkHKNKVz/aP0xdYXoj//NJ5gS1YEYVS5HUyUesrtaJzSyXj9hGRKgAnqeh39HMI4CuGogIW1HfwjqAiogCtmExNvW66Todys5bYA7CUpPMfFSRVScfLJWscR315L+jRhCv45I
 eTpPOkHf
 dqIcG3h4J6kxP9v362x3Esb6KpYtf/xPwo3DBMbw0gFtRc2QdyXMeSPRumV1XsJrJDDnQ0mwNSeapcoNxUnOr5I464UBKfXZUbHyI6stBScA4XGBMKgSwCQ8VEuXHUDcyrPmA6BaCDr2XtzP4lRZe0TTJ4WHKJE1pLJMjNI724mxJxnB+f72uUnEbo3QBR/4Y10B1Rd27mEJBA9NDsifjQ7DLE5JsaSI8GPewX1YJhs51xA+fr4FnMOzq5X8rPhGeW2U1/sKVgZ+0scYBJpadFJXoXF/xaK5TQFbKb3DlXg0RxrWACDDI7uLT0nycXXxo9xLzqToI+99BXv8aoVxlYAM0/Q==
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
for the week of 2026-08-17.

As usual, we have two time slots for meetings in the week.  The slot for Monday
is already reserved, though.  Next six time slots are as below.

2026-08-17 (Mon) 18:00 PT (reserved)
2026-08-18 (Tue) 09:30 PT (not yet reserved)
2026-08-31 (Mon) 18:00 PT (not yet reserved)
2026-09-01 (Tue) 09:30 PT (not yet reserved)
2026-09-14 (Mon) 18:00 PT (not yet reserved)
2026-09-15 (Tue) 09:30 PT (not yet reserved)

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

