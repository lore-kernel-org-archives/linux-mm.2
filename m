Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F567C624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31C066B009B; Wed,  2 Sep 2026 10:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A5AD6B009D; Wed,  2 Sep 2026 10:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1700E6B009E; Wed,  2 Sep 2026 10:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E82986B009B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:22:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78557A3D32
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:22:51 +0000 (UTC)
X-FDA: 85169038542.08.BA4378A
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id A0330100010
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:22:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZdKgSNT0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788358969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhg4nFUTwBRfkzvOZ3lYhulq3dN/Jpsw7Gc9lSLlRQY=;
	b=dUIV4OJrtu58S4L3YzudX1NdQ+e6GiMpPFykXTTprWWvkUjEG4y0e+4xegKxq/KT4hB0Dx
	dH6gNAtREgp+2/PjSpgJWr7SAtvtbrUbAb/HmWvVeIb8qsLD4oGw0Wsd/I4XKk8eWhVLhd
	Ol6Vl4Wa2jiqi1o9L3aB4aHKTimcW+Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZdKgSNT0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788358969;
	b=x73zB7/33kDljvu162big3NwiTQcL4b6a2Skek/noDRC3OqLzo+dxlSdz58+bVG9eWeIpQ
	CKMzPqCk8ASRbTHYRWe2rbYbmcGpgV3CIkq24TBSDOzRl15r8mXhqyElCArBqujwhrSssF
	u72E25APfAj9+L4r3Ng9tAP6sZ05KU4=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cfbbdfa60bso13093325ad.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 07:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788358968; x=1788963768; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xhg4nFUTwBRfkzvOZ3lYhulq3dN/Jpsw7Gc9lSLlRQY=;
        b=ZdKgSNT07wlOLVZ08zSjfdY2lL+zgP32hx0Mhnz8jQAqQhyOTHeySguicDUlWTj5oM
         YNh1kRUUWg8ATIo6lC54/UKWObRcsN71/VfI2Y7xt8RMrKOFxyKlPKxWqh05ivFcQ5GX
         kj+ZuUVGjyKKrHpOBZU1Dqc5pvOuw6mkXckGZ9bAnmpDiR/38VpgWS1XqOJXu0+VFS8r
         eo+mFzJ7sjwX2SJ10aF0a6Qf76WgdHdXS4B/G3EoaDOCBj4cXAi45qblZ8Ae6LZf4KRe
         rI8XyQpqO5hXSWg7z1JxQpTtIiwydBAMC7Ie9aqNpMJQPgSxzq3uvH80TzhwDmEMlxZA
         vr2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788358968; x=1788963768;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xhg4nFUTwBRfkzvOZ3lYhulq3dN/Jpsw7Gc9lSLlRQY=;
        b=eFoG28d5ahg8Xq+qhJeJvLIqC4QNUopgDCvyhxOn6EsPWsgsdOCT7FJWK4p6vukwXi
         JceQSwPe4X0FZyr7az4f/7PgY/DbU5mp2WTLjWBXgHF3pRo+ULbDxlPQypRPCNxN70g+
         tJbMq3Fhj0HzQ0WAWc+mVvZsupi/nd4Ut4t1lWkiSq+3sQov3j9Q0UcXyymO1SnaavhF
         DOTOJw7AfWoYJJW7/RgDh7Vv3YpU/I04cQLxEU2BDwdyMb1LXgVym95mQIC0IMEvuSI+
         8PWMEtI65CwKAKIGwKR9NPDAVaXaEOLiTGurC7mYIGfSuFKx7lpLYtrjYcdZEKrlQpl6
         kfXw==
X-Forwarded-Encrypted: i=1; AKwUvByKjSpSHj/6wrK5w6tmT0bzSm6kGZb5KunxpdyEGEfC6CmjzwFhq0tKWdBeUcEmwAfj5lwE1xVLkQ==@kvack.org
X-Gm-Message-State: AFuF++lk5f3qGn7+7/U9eTcmR+PsAfllSk4QQnQk/JLumH7njH6SWs8X
	lR04b4PnXBAfap7eLJQ759jRsP7BiC/CyxSLV0gPmKJiwpp6+wQrYcia
X-Gm-Gg: AR+sD13+eofJx+4fVIdaVtCpuM7/GF/FLuk6v5BJ0sWBfaNrPEb50jGfZlpKwIHOB8g
	VQsqUk4cjk5eVGW3o45mX2H6LFZ/9FaN7Li1p0jwqXtxHRXPX0q3OeuaVdE1m1pQyjA4MjIsnGd
	ZTNqbrW0AroPx9wW+6SFQrp1z+72RGmOccHEOD/iOhkHYR9ICkI9oo9BwG0wYZxsLQqLqTZbnrR
	RVvRiZpNVDB4Z2rv1z9VxTtG13ffwtW2sy6EFyr6mWuaEfrxYmFZc9NiGhv5xuCXxRnmYuEqjkE
	P3J48RLbqaGuED3L25h5SnOVPAYvn+0oy3QUIrOHfB5f5KWXugIR9VFDcFgy7uC8LhKgUT32QE/
	DfEPlBUe12WcIyrtk8O2SReeXnhg2WdiKaCnYpZ9h0/mqO9SUXX0XCVgFF2rctoohJRN1EWNdiA
	zqtLBaU7DpBfHky8pRm7B7DEWZGvieOPGimZhcfwJkfh5jdVVH/+/ylKrkz8S6823FWigXZcGwA
	IgvwtEVb2QWcqsL
X-Received: by 2002:a17:902:d491:b0:2d9:3636:d01a with SMTP id d9443c01a7336-2daec74e5e3mr70183145ad.15.1788358968023;
        Wed, 02 Sep 2026 07:22:48 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:9c5:2de5:8b4e:3f3c:b637:4ca5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dadd383b36sm13853485ad.25.2026.09.02.07.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 07:22:47 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2.1] mm/damon/core: fix false positive in damos_quota_is_full() when esz is zero
Date: Wed,  2 Sep 2026 22:22:31 +0800
Message-ID: <20260902142254.5328-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902141001.86733-1-sj@kernel.org>
References: <20260902141001.86733-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: g6nrm6sjeioo7ygjrn1khbuyy756k7ya
X-Rspamd-Queue-Id: A0330100010
X-HE-Tag: 1788358969-649723
X-HE-Meta: U2FsdGVkX19+8oP1l+7wxdKcyEqN19YFmNJVmvLcwL2OdSxklk660TO/7xVVM6pjj4j10UJPzq6BoDTkxfyCTCZfu+3bWP0o13dCX+qG5OIOUjSB5CoJ1A+BRPsZsyyiVKojyb5+tN0oPBlu3lgdSQysnGEgMYsm98w3KKjb5ivCq43UFcLFvHrbbrv6B5I2s1SJBKxGWEle6KF0eJsMAhPMnFQAdOU/oTvS6BKUgGWqzbciuuUBO2VkZ+HCx4jwqdOlgiblJ+WHwvJsmHZ5Yc/IoIWLJcTX3FCXmI+J3THKj+9w61LUwDjwnRrFy25dgD4/CGUzzqyII1UiwQUk9pDLr4sjehioWQHI7LZI6TtuXyv1yskF7ooo5+NHLpz0OerWOVrPmygWahkxkf8AR0nqbF2wR32Jovs5rYUuH3/mXqb26MPmvxHEcjI/rJKqZxXXlL4mrNeJYaMU/a2hEKuKM/VjStMEbMYelwnTe3RdEzVZ6L0fxrNRbSMN6q7SPfl6DGgWi5TZVRQoN3yL2jvGaT9/6gsC1k/B9TVE0m1TvLCP23SkVlTN7IQNlaGSKLxgVIiBpzOSsgjxW/WaDIGFNw8cZa9rdZt02MtXIZDUW5rEGsKgBd5hMeO2PvUP4R6DD54XCNuxayp96TBRywZQ9s5eiJxLTqB5JiDP1oyh0jMpyGxkHD0Izm2J0m5dOpLUXZKD2DEoV4kWY17ws1sa2WTVpvCSesi58duuEexk9Izgt+/uGVDDYVzpvE8msHNxuehuY6e679AZ1iCvhFJ3GaVzme2TCbp8j28Nypa9ApgkdJS1DllL0lx0CYHtFMGg9GmLIcfEweujR2DQ80Dk7Wsd2AUHxH5Cl64Gyg4O61d8sZ5cMhNC67claYvShDlQEn2tmL2wRjVym2lSfUDqp6d2Gbok6VXKBub/5CWd5gHukSfePIAAv8CzI41+yqzjafSE06f+GkCgz03
 EYNfKGUM
 f64/tpkEToWvnKJ6ry6dM3h0AGIm7043RX4+QweIRqESy3J8pzHu+xXhWJkhiEEXE7HAOj7yHW0iJiiTB87cKQ0QSzdmOQerQPM4BVMOe+E9LR2ELKzOO43605W0PxeAK56WTYn6Qq342cLi3HuqYahfRDGpzeaL3oxDC9+dFX7H8r9gMkUo1UQXoaeZs8f1N3YHwfjbtqcIjr2omCrx6Trj5PGN44wo31oywbbnug1hD+g4oe+xu/YSpk/VSJoFEft4Qjump1Bk0VpvxzA7qldMhLLthuX6rIj0p2vvXGXNDUK+VDpid5y6/+gtBNOko2LAgNQYsyObwU7p3UI2xrfDi1mfvcIjaeu3a01RZagljnIneR/l+NpNQHYotZi5gFsfUFhcXZTxDeVqDTlB2693Sl9PF3nuPiObwjaR8YxYWIrbdjCdEwRVI4+UeqPytPMqpKFljBskpXYNWXrT00pKOOMCngA3/M+IDAH4hygjJKah7hjLstMLpsXim84+++aCVz5zMb6PqkPcdSvAl2wAwvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 02 Sep 2026 07:10:00 -0700 SJ Park <sj@kernel.org> wrote:

> On Wed,  2 Sep 2026 16:44:45 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > When setting goal_tuner to 'temporal', if the goal is achieved,
> > quota->esz_bp will be set to zero.  In this case, damos_quota_is_full()
> > will always return true, even if no regions have been tried to apply at
> > all.  This causes qt_exceeds to increase unexpectedly.
> 
> To me, this looks logically correct.  Could this cause any user issue?

Yes, I think this might cause unnecessary confusion for users, at least
it did for me.

I set quota_ms to 0 and set the target_metric for the quota goal to
user_input (i.e., MemAvailable).  In my use case, this caused
esz_bp to be 0 most of the time.  Also, because the quota->ms clamp
was missing, esz wasn’t set to min_region_sz, it was actually set to
0.

As a result, nr_tried is 0 (because damos_quota_is_full() in
damon_do_apply_scheme() always returns true), but qt_exceeds
increments once per second (likely because reset_interval_ms defaults
to 1000ms / 1s).

Best regards,
Rui Yan

