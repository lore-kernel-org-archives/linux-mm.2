Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9AD2CD98ED
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 21:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC19A6B0088; Wed, 17 Jun 2026 17:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C73186B008A; Wed, 17 Jun 2026 17:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89286B008C; Wed, 17 Jun 2026 17:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D40A6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:22:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 13A88166626
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:22:11 +0000 (UTC)
X-FDA: 84890677662.25.D63604A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 88A80100004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:22:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EvgBeayl;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781731329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kUSLuADlGuyB6w8Kyvi/AxqjQ412r5lYEyZTSDVMugo=;
	b=a4EO8fAL5x1sXUYdHOGGLgrjjp9PPZ++mXhA21S0r/1W2dSW5shGEDBZe6jBdoWADMkT6l
	9Q7OTi4kv1kW5u6pIGC0c4YhaXOCusTVToHpqtzXqYOyClZ1tcxlnDQ0N3HY/Hes2gC8Pf
	3Ht3bcn+THCzLq3RkEJjUMDx/HmxZpw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EvgBeayl;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781731329;
	b=votXzKg7hrI5JfZ0ySzZ5PiXR3fQCD48UcTBGnnLDwOpPtLbVNCgNJ+HNR+IcJY/FiRlUz
	6I28FHuWd+6zAGpOUJ2D/G7UhOsQRnBWjGRluZKBetiHtMQp9AM7v0tdorqdwetBi0OMkF
	B234COnFODfG8x99nKxy6PeS5xO59jw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B930A40BEB
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1E31F000E9;
	Wed, 17 Jun 2026 21:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781731328;
	bh=kUSLuADlGuyB6w8Kyvi/AxqjQ412r5lYEyZTSDVMugo=;
	h=From:To:Cc:Subject:Date;
	b=EvgBeayllHaViEBS5h9q08CKx5DMzcIgVNXIFEO4KwQe2U1XFQJBK+Ryu8feTtvdo
	 L4uXXnQ4rDw58kGU1jthhJTYSJ7rfJX8U3n1B2bGXwi1duiSM1oK416D/bEtBT9iMD
	 hfoIHeooJu1OQ4RtZXuJW2LAaQk09NfqCa4pr6MZL+1Lj6c3vIBH+8e3AZHzh9CQqW
	 n/GDcg+dxk24DsDjL6AtVLAflq9srCyCExrKYeOCV+X2Gtm4u6ogpX1iDTJh69DOsX
	 H38B7lVN2R92E5/rzmS9iPhRq/mb550L+08SGReJqBMv08pF1eQEiK/RBmbz6cX+Vc
	 N3n+bPTwAk/jw==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-06-22
Date: Wed, 17 Jun 2026 14:22:06 -0700
Message-ID: <20260617212207.4584-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 88A80100004
X-Stat-Signature: zzewz4r9i6zzmce7x9imq5gntewrs5fj
X-Rspam-User: 
X-HE-Tag: 1781731329-225149
X-HE-Meta: U2FsdGVkX19wI9Jere7hOLwaSeufW/ZH1pBtPdPpQhw0OUS2bKLEz+E9Hs82HuGUgYPOFpLP6bPCzgbGluA5YYWu7koYOzDEip6K4y/5ZE//xbI8LUfTS7OtV6EuenQsX+XzdwZEXqDRWR1WpTVlCNHl6/+Lfx3msetTpbHiHHEtKGWKcPgdTXqDbUgnYpbrg/bc1GAwfUgf5BMQA8LZg5L+I8qIhcRN9hdt7zoruVkZuapp2BoDEHptpjiISj1eazgIgRWSR/b4SMfrmqLwUdILMwMK1Rp9+schMAJFgWplxUh18DpMUYvTv/nXpjVcc2/rNiy9QmnFbRkk/KVLvt6ieWfv7760+r9cKoOPnOWxRLMSke/EQqTQYs54AmN/U4dbo699V/PczUNi6c1PA03NwSNPg96yZdHzFGWiAfjtF91yMVC/3qEpPIplmngtK5bj9AMQphbz4kC/pb7Ayh7jx3fHKvvIId4xEuMIXwv6pBqzf6PF+SqP/Qh84VYCoFt5I7gdf8fDMq6NgX0zTyyt4KGecwsc+z0SBuZaDR9BbvVuPP5EcQYaFBxNNbPZcJBD3Ue+xLSv1QV1db2mfLQBB1JSOIudu853u26En96ylUAtn0f8tYdBV2Lr/lWCKEUrpCzaleQ5aP+wo6tJP8qee0L5vrD4LhQyrcTUS/gXMrlhqEVWK5O6yP8ZGHJgNzDC/rpJLHl2RDZmJeC+L/SgHNGK6p11jsdF6t+dwB6YNpwHl4IK4XeBUfm48olEJXX6oGvfVosLzhybHEmQk6c6xD9/hSFmX3UoKkLOo0JWwqcHd4rGt0MLtufmPOFF9eEi0LWYDyyMEt2VHhruhkPiBe2UtHFsafywqipozl9Py6oD6HVYEvizn8usS6QIIZ44x5SAPgN02vITD9sTy7oc7w4CKyjMZQHO3U8K54azsz9u6yChouHKhJ73M3ajFJ9X8kZa4ya9O2G9Tn4
 WmhI2P7a
 ejZF+/3Zoiw8o0MArF3vnfhWFkmudoF6RTrc3wd7H3Mj269hWdFN8m7K7YmrObyHHSqbCDbxdB+FWurvlbOFNOHvUkJRlz7I7UiLggpW4WalW2jlChZb4OjOF5zJKnTY1cXfjFZ7B9bW4Di5gA0/0ZKzooOArAdujXGsDGxCgko7UpAq0NgxC87Uv4SaqYXWs13fY8y4NJsc2NBVNNdqq370eXeb/aHAhUZS27T3Y7Obnopm5mvfwTmUBFBuzYNuqxUpc8wjxgJXDRD92/e6JhBO21qaBId1FVvSGvHFcgWhoVx7xub+CAoO/f19sVEqm0laAYcZBK6Doxfqk+4wsW9BZetOsVvy6Gq/u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2026-06-22.

As usual, we have two time slots for meetings in the week.  Next six time slots
are as below.

2026-06-22 (Mon) 18:00 PT (not yet reserved)
2026-06-23 (Tue) 09:30 PT (not yet reserved)
2026-07-06 (Mon) 18:00 PT (not yet reserved)
2026-07-07 (Tue) 09:30 PT (not yet reserved)
2026-07-20 (Mon) 18:00 PT (not yet reserved)
2026-07-21 (Tue) 09:30 PT (not yet reserved)

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

