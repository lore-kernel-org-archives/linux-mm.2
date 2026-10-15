Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A721CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 11:24:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AC2A6B008C; Thu, 15 Oct 2026 07:24:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 684566B0092; Thu, 15 Oct 2026 07:24:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59CAD6B0095; Thu, 15 Oct 2026 07:24:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2BFA66B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:24:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E0E5C04DA
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:24:12 +0000 (UTC)
X-FDA: 85324626744.19.637253A
Received: from mail-oi2-f9.google.com (mail-oi2-f9.google.com [74.125.231.201])
	by imf13.hostedemail.com (Postfix) with ESMTP id 741D120006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:24:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CeeymaV+;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.201 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792063450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WcPHvbOIREflq3CVha0FzUPYhrPrea+3ze3za5U7XAU=;
	b=pOiQW3nymfloDb91OqwC8VI7nppaqQ1CUVZPn6Iq5+HIVo1tsJmxt1yKjAjU/SrcJGy2wu
	OaS3K4vv9yny5nTSO8HHkUNvsLL0mgmDvhBueUecHVYnwBKQTXaNuXWuAmxau7qGvWAh83
	WVBPNY8vNnL+Cbm0U8lHxnIt0uDXYBo=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CeeymaV+;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.201 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792063450;
	b=Vlvb78LoNyllWSpY3TsZBi+kzo+ZJX8oHBej5Xl1vniJLYrAsDbmNLcpnIOypruhwoM4iG
	KVtZkaj3ibAJO7U5R25X9SAOtojrQvPcql4jGTTCrtYi8hyiRuprN7Sclx8AqOt8E76gxD
	oTa1zcHkkQ7QW9OblQ1wW39kLmqeywU=
Received: by mail-oi2-f9.google.com with SMTP id 5614622812f47-4f47feb5a15so794979b6e.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:24:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792063449; cv=none;
        d=google.com; s=arc-20260327;
        b=CsvUIOxTNC3AOE214R4savGPyK52ty43feXxsmMNwJzzled8qPeQs/H0i/2aHMKNRS
         I4V/Nsz4e961qK+P0JkkHnzZiWSpGGgyfkc2FVZo2hSojuY5OzkeFZ8BZqsPpi/KybEN
         VBlZPtmJ1SsMujxuvDrMR4hA7qrIPOeNOs/UoKmQhqaISy8Kc2wfePn/VQ/LOK7JgWMz
         seVYpfHgpvSARYFKi7C1tb5R2zT/U5xwhuiMl+nTvHPg3wYfSXTYrQ00FGQlLs8+kJTd
         HXZqFsrICONL7eZR9qra1JNfdWn2a84ux+ksWnp3oCbUuHUwq8M/vF7Clg6Cu7L76hTs
         628w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=WcPHvbOIREflq3CVha0FzUPYhrPrea+3ze3za5U7XAU=;
        fh=NfoWE1HMehgPm51BqX5EvbpGcDn6s3lPZwmvEMgHD4A=;
        b=lvz0H2ExGkEzJktiJsIi/CZnckO/IPRbZezWrJhiFkxDWEhzoMiZ7hUIcygGkJLeqM
         6cp8LjXxyLXUGECYjjFPViiViXAkh74rWixEq0f7BYUWi47qPg9uJTppLrg8ZMqZvlcu
         KfBfy4ig/opa1RXRqsKtMkeF036iJWPHBTM5s4Rah7oYcYwHaIL+ukcFnWY19menwoCS
         +TbvK/GJYCyXrisEChsfaY7nZcAM3r6f6+0GA0do8AyTweHyk2b2p+pRA+yH1m9mF0CB
         TpgjvBNe2SqRfUJA6o+HAJEMdHnX+KyANZ5sEa1qX1thPBNJk43UImMU54TYg94xP0sg
         zyfg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792063449; x=1792668249; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WcPHvbOIREflq3CVha0FzUPYhrPrea+3ze3za5U7XAU=;
        b=CeeymaV+mIvhOKZpCzpwAqhXb3uAdSc9VUWAJmLuQ7xYVYgY/FdQykzOvjf064vbdz
         Tnr3bHSiYbAQFWO938e5LB1aaX9qvMh9jhTYgtnKYx1HjRkbXyfIVjp95p6ffTHDQE6d
         qZEmkWXbDoMqOhx5SaQuWz9Rc/L2Ghv+HCo9yis06P29l4zAkBkGanAkrtDzcOuXVsn7
         U43kywa/ogHThp4lL4OrIzqro6TDooYydATjiL/7vTz13QEtXguXwsDcClZn1JuI50wi
         tfJKI5esOZ/a6IlPM+KOzcnoN8BLVp/YNXbSb+3HdokkwkdlxaCfdX/sbtbFFvDVVzzI
         RwWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792063449; x=1792668249;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=WcPHvbOIREflq3CVha0FzUPYhrPrea+3ze3za5U7XAU=;
        b=ahnXwWJ/Ar1HlMhte4jV9N3BbEI7vmf+3cAXU3o3si5KJt+ynLh0aL798MPlUbcQc8
         aCBkRjsFUE46uPHFEI2Glg6fkY+GfThoJOi9qXwQFacJsbC7CjBswunlWSYMxKz3fkRW
         Rl9AfQgf5d81TEW9EtenQ7zmQjp/FaP0OzP+0lrA1BtYz/l/AddjMHcXdKscFANtZDQL
         ViZXQ6rBZNlTT+56KuCbVdxoWxny6HIPTvNrXbFEXFqjliUjDh4GQEHsxLjoSqCt/Jbg
         sGersM6cZzuNX2JbZQYduNbYCpaH1RBDN508D0qHhprTs/RiZ5Jxfj8Iosyr/R6ZFxqH
         egjQ==
X-Forwarded-Encrypted: i=1; AKwUvBy5qYNg1Ub5mypF7wcG7Pp6A404Oso+PWzFbh4loOncgoMAAI4mMD7aTZRbZtMR+QTLVVYJJ8dXjQ==@kvack.org
X-Gm-Message-State: AFq9FYLU5J9TJuOPWfzuFYzO4QDHOWGg47HGZ2H1/kI1lwAD58n8UHWf
	QRvrUXDB8vQ2/NvAt7ma0LqM6tG7BLk6QMPjEr1rOLb3NQdhH7tyQx8zC3DL7mkdwBC4NbXQ86x
	zNVJoytEvwXsrbyGPHq17/7L5AfkKcLw=
X-Gm-Gg: AYBFou26O1Vl8OkkBW2pKJG7NgbRFnStUpmufK0Fs81UPOr0ZdHHmk+NShFi7Ev4DV9
	xJxXCkCSo2MvDiF85GAZHo0EF0+OlZX8wu5xu+oKv65yamnEfnnpte8GOjwfWued7mawtaItY8Y
	8KA2ys2MWPQMi932FCcGR/HY628ep9WJKgs2bzMkSb2Xbi70dt17OEYrfslEXmynbbr5GPAClnI
	0/48DL46ukjFfddvwpZH1bjlKJI0BsnpmX6xatdPZY/wpSwCNDHAMlgL9SiCiVGuqL0EdpWTCxQ
	RNKEWJSG4fyYapSiu0ZRioIkUAOB7t4ZB0q+4Yzsn1YY6lZsR84DTfqE0oB0LBKoB/cZLwh/F/F
	lQRiCDMv9LA==
X-Received: by 2002:a05:6808:15a7:b0:4e9:73ce:e2a1 with SMTP id
 5614622812f47-50c5417a0demr16310600b6e.44.1792063449448; Thu, 15 Oct 2026
 04:24:09 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 15 Oct 2026 07:24:08 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 15 Oct 2026 04:06:47 -0700
MIME-Version: 1.0
From: Aveline Noir <jm5905938@gmail.com>
Date: Thu, 15 Oct 2026 07:24:08 -0400
X-Gm-Features: AclHuK_yRe_VjBLBEog6BC-f_xFyKGJAr2pWJTMKXgRYUILAdC4oSPS6DMOyP2A
Message-ID: <CANOyQmFkTQMEpR10sxjoB+8XMsk=m9DAJVnyxguwV2LLYCg09A@mail.gmail.com>
Subject: [BUG] DAMON: 32-bit overflow selects wrong sampling interval
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: crue5pngyeo17k31wc5qbr8hxb6qshxb
X-Rspam-User: 
X-Rspamd-Queue-Id: 741D120006
X-Rspamd-Server: rspam08
X-HE-Tag: 1792063450-975932
X-HE-Meta: U2FsdGVkX1/Tr5/ME5bbXyH/opoMoDNIcQnqQXB7GUvQe5hf4j8JIhI4zYfRq50Q0I0HA71VlcWuBGMy61AHW6XgmvATy4nJVG2XUkm4GfSamoIrf/whhEi6eWDDsuzIiNRsOQeCY3oRPf+5DG5YJnz9Kc8vdhT1UE1ETYxUJZ+lBAzJoZhxh/bKOpG4Ce0+RfKsO35jRZ1YX+mlFJK2O5lB68pDB5IN9ETthvoH8xckUDcqcFX90+VA9HzaNqcOG303l2B9bTCdBLM7FQsjfNqTAc+eRVI22g8A+ITscguJZmmsY5OsTlW23EaTltroLJn4KwT4YWbp/7l8PYuV3GIQ4Clrfq3iqWULa0/xXR7u+WfuKVIEAPO4QHw9BN9WNKycvHuuA5D7RWZ+0HBkyXU1CYilOaMYAHr3fIfPg5sBuaT3g5Z4Zq21XMKDchvxYrisMEBR1H6cuJfdlI9S2spGsWJPXHnVd4gH3H/y1xyMbq1oe9Bb9mvSs77fdF2X83FaWmWyDirrPfQktIiw0q04qrwBmPOJiMZAx3zENdVYg4RRlfANarhnBN0k8qAVTlzwA+RDKtLxv0SCVbO+A3hXj0u/FqHKyIaziPgj+CBQP/c9yYLtICjvHT0HkCqgKxXO4KLeeeI0S2FdUDyMA18yn+RDIaseYyLzW5q78QLkVzfbTXwHMnlzp8E/UZHqtVUeYqRvsoAPdEFC/HgFORj2sOijHZBzy2Z8dO+TNOBqz2iDjSRCihyWesiz2CV9Rt1P5iSv6uuo6YpmptZZ7XikMnK6A7t7YeIBsSyBByGng8UEdL2sgBG/LDulloFx+3M/4GnOaEcQpXKpAw1VkDchnqjszq2kP1fxuZv5qiaLxUJ8Z/pKaYGLzdUxz/UjjGFp9gI3X4+tsasiao7qA5O40BhusdbAZ0Z+nxqIZLUugZHQBso02Jv6NiTQCaz5sYbLGTg1auj7gmMtaIQ
 LpPMrL/L
 vN+pJ/UOqH2kpLbyMb8jazh1Da0WP/a21T3PE1fpa9/K24yONbT9HK1126kG68Os9SGTGVEfHnYBWEWlaGc4rus8VZ4q4LNsUEehAE5qtrajsSV7i216v2PrfuDhhCm7F949g1AvaE2d3YdjwkO30JxRSUiIKFWn7HzmiNwrYOgS9BWJOjzy+Cwc+oz90yt1FDxGRBijLo0HEgitIRcbX6vsRCQDKcw9Rf0KmW0usWvPCY9CPSX1TnlncwcAbzIv9F6+hrCpuijRVy1F5h8KH4INZHThCSvUX5kNxW26R9Cx3d9dYe4VZQOUpNPI+2oPn7FKL8MoHOqTNB0xPG3cJCackfw38VTRbnfMzvtge9r7kQvKj2S33dAGd2Nvu7hxZLheHG7ikU2U6506MpngI30m5gWkQUpPLjacTGOx0D+OFPUhubnyxImfFVfEo6SxRHCVVDE8vvSRI4RP+SGPQLivZFYvzbaAhNwWx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

In an unmodified i386 QEMU kernel built from mm-new commit
ad9f2d463666, an intervals goal selected a 2500 us sampling interval
after the first aggregation.  The same trace inputs give 2812 us with
full-width arithmetic.

The kernel has CONFIG_DAMON_VADDR, CONFIG_DAMON_SYSFS, and tracing
enabled.  The guest monitored a 1 MiB VADDR range as four contiguous
256 KiB regions, with sample_us=5000, aggr_us=100000, access_bp=400,
aggrs=1, and min_sample_us=2500.  The default minimum of 5000 us would
hide the difference.

At the first aggregation boundary, the four damos_before_apply records
for kdamond.0 showed nr_accesses=1,1,1,3.  The next
damon_monitor_intervals_tune record showed sample_us=2500; sysfs then
reported sample_us=2500 and aggr_us=50000.  The records cover the same
four 262144-byte regions before the first tune.

For that aggregation, the inputs to damon_get_intervals_score() are:

  max_access_events = 4 * 262144 * 20 = 20971520
  access_events     = (1 + 1 + 1 + 3) * 262144 = 1572864

On 32-bit unsigned long, max_access_events * access_bp wraps before
division by 10000.  This gives a target of 409364, a score of 38422 bp,
and the observed interval of 2500 us.  With full-width arithmetic, the
target is 838860, the score is 18750 bp, and the interval is 2812 us.
The later mult_frac() remainder multiplication does not overflow in the
observed 32-bit path, so the difference here comes from the target
multiplication.

The affected expression is in mm/damon/core.c.  Widening only the
target product would make the later 32-bit mult_frac() remainder
multiplication overflow for these same inputs.  The 2812 us result
requires sufficient width throughout the score calculation.

The 2500 us interval was measured on the unmodified kernel.  I
calculated 2812 us from the trace; I have not tested a patched kernel.
The i386 config, guest init, serial/trace log, and build/run steps:

  https://github.com/jm5905938/kernel-mail/tree/195d7017352a3d0f4a0475b98f3b03650f5c14ea/cases/2026/damon/2026-10-15-bug-reports/02-intervals-goal-32bit-overflow

Thanks,
Aveline Noir

