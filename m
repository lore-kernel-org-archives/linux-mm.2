Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9B56F531EA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 05:37:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A0776B0088; Tue, 14 Apr 2026 01:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051756B008A; Tue, 14 Apr 2026 01:37:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED10A6B0092; Tue, 14 Apr 2026 01:37:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DADC96B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 01:37:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 737E21A0435
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:37:52 +0000 (UTC)
X-FDA: 84656054784.29.38D4D72
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E17B4C0006
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:37:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cb3Dh9r+;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cb3Dh9r+;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776145070; a=rsa-sha256;
	cv=none;
	b=5BhPrLfGmC/KWYP7P2OC7VxtYoArNK0EuMKFJXc8rlCQ0A2w/6MMC9xupWAa/2gZCJANyO
	QFzTiA3KXaJeejqtZcW7Q+HeqGfdMSA2J31DQQGu/HEkK4H9Q18qbz3XyDU/TzU44j/FQy
	yKclyPNDuasYvcoT8j3H4Ei8EF27dhs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776145070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0G+5+QgflCG+TqPtaclFd5JaNVwgwTdyYqSgOfeTC0A=;
	b=mJaRlBxc9Gxt8eLTt094+VUYyl7H5Pecro6Th6xKYN+hfMbcb26lOjJGeHCeOIRAKnMPqd
	sngEcCla560bUashgfhi8ym0bPkA0JPnRANuiv6XdqpOpQ1/ahgkUzbg6PUHGTyZvrg31d
	NF7ySiImVr303GmaiJoA8rT75hV/o0s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2938B60018
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C36C19425;
	Tue, 14 Apr 2026 05:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776145069;
	bh=g/+F/QbX1zjCLTtq9nQIK2PoeggWzfTxbvqrEl/rsxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cb3Dh9r+W+uy0GWfhQUrZrxaP/wXOX1wnE0xZ45BDJcg4E1jKkj5qtaBlLK0/aFrJ
	 HGafWySSJgu97/7EOWiCQmOKY/d2VSNA1cWk+F5bYINUr60tFtepu6/xKHpPR9cvEb
	 Ce2lzgr5mileqPUNU/KS/zR+mwFIHiwvaw2JLTuOVroMhsQCTEi+PJlMo2RH7UXmFn
	 YcB7uP1dxZzLno6nuAUuNHSOuL/xfn2OdFAt5YUyZVgLNLPHdsu+YdoTGHoT27cEeq
	 SWNBmjxQk2xwWrNjbzYceRL4UvnFSumWeLI8hXfxfwvVQ/jY1wTfz+l3QRsEdi/mQ+
	 wOBuWqOPt1gww==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH 1/2] mm/damon/stat: add a parameter for reading kdamond pid
Date: Mon, 13 Apr 2026 22:37:41 -0700
Message-ID: <20260414053742.90296-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260414045002.88110-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E17B4C0006
X-Stat-Signature: zidwmqiyq783133wekhdtx5d8esjzthi
X-Rspam-User: 
X-HE-Tag: 1776145070-895843
X-HE-Meta: U2FsdGVkX1/Ow3NI1rOK52zN7ROyGcyQ5/1Pdy36yNpOgWxL7eelVSBIop6GSEJMYKudOSNUSFK9xhDGhOxL04OL9v66hbk4m7KdIHp2Up2LY0+hyZLxubW3TEltNug2Pp+ekZrhjMf+Qf5Q5sZZIVWjX4SybfrYlwb9b9VvIdKml1PiTfoouX6FJOHtk4/A/CxNbvqmgN6Hir9WGugbq4i3Y8lnkh2jN//jWypQFU1G2oN1cAp3nxMitGpt5/Ot0XN/RNU60xuGD3yZxe4xkrhLunoS4dHZkceg3tCy1/j/4erx/H/S7bCKsjWYU1oo19IlL9ZPXGdB4+jG/duF+Enn8MX9Wkhe1ALI82yqOuvY7ubHV9TmWQrG5FxaxozgstiamxsTvg+BRqxw43g1PFPB6uQO0xCfuFenpTReT6Lv9fxtKJihDXtDFrJ1gSSzqqKRaVx8Sa5li+auswJhV4CoPfaFlEG1a/4i3XTNG7pz4hj7ngRZhiZxV43OkLhNdaIKLs73N4fjdqVhfu3pnvr9SC2bFjEvLpQxaWnhTBaF0FKleoyPfuXsHbMHQhoh1VcmJdMP0SVvxC6E0bbHclpd1ZzNmsHoHQr0/g8KWUEQ4/1Mr6HlyQOtzWRa9Fg5tWxSkB55DvQwThSXx5GP0ORE9aH7XLlEr9ONICCpFUm6W+tRrPqvcxgFzGOoTkaBcXtgh7JZ5b4FizcLwTKvdijamKCuxVdW7ALWAzzsRTmyPS8gl5oF3BiXH568tc7dd29PIGQ5rTOM6RAJbWBVMGBq8XdkuX3zmcVb5o9kjPbbBHDomYHg5Kb8nepttiSsUOJIjX2qOStQmPYZGEIEFuVjnT6fQmB1S9z9MHfvwQgFLPjTaVJdBs3DvYu6mq0b4WV6YocxVCeSJoYxO8BLWB7ayQU0++1TL5zmDdnGuXPX65X6Du8qYDsDNJOEogBJav4AdWFk6jkwuXTWdzm
 3Rb9n1H5
 NZFU693aiWroX9Da9VLvaqnUfG8TL8gje6GX/4A6UJ+VoVwSI7U+n7IV3xlf0gt9mm2TiaHg+ocOg0dzuh8WzTlUhDL8pKRKayyPjd/xOvGfi3VhcZzYx6iL0tvKpEoLYzv2cZzXA/fpBPXrukTRLwftuaCtTlwICgB7k0OlflzEtOsCbK9GipV4tCgzP8wrThLnof3q107DoqgtiGRf3Kx44yCU1d9NPXk+otC0eSG9Ov+2c1Rxr925PmKHiI8VE3pl3mMy4aMhodixR9DGqbjmwacK7+iGf2hKz1FHIcfa5ONq6/kq/rr27K9tnFFvkiB5fZmEXmzdKceYq1ZrwuT9Y9UwWkXWEvqhKGMKEoeewsjUk/Zo3ibGixhcbQgdMki4M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: Sashiko found a bug of this patch; I will fix it in the next revision.
Sashiko also found one issue in the existing code; I will work on it
separately.

Forwarding full sashiko review in a reply format with my inline comments below,
for sharing details of my view and doing followup discussions via mails if
needed.

> # review url: https://sashiko.dev/#/patchset/20260414045002.88110-2-sj@kernel.org
> # start of sashiko.dev inline review
> commit fc6c9ec12df0df57fcce5c90c7a0604cddb1cc78
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/stat: add a parameter for reading kdamond pid
> 
> This commit exposes the PID of the DAMON_STAT kdamond via a new read-only
> module parameter, kdamond_pid. It intends to set this to -1 when DAMON_STAT
> is disabled.
> 
> > diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> > index 99ba346f9e325..21fa04d95eeac 100644
> > --- a/mm/damon/stat.c
> > +++ b/mm/damon/stat.c
> [ ... ]
> > @@ -260,6 +269,9 @@ static int damon_stat_start(void)
> >  		damon_stat_context = NULL;
> >  		return err;
> >  	}
> > +	kdamond_pid = damon_kdamond_pid(damon_stat_context);
> > +	if (kdamond_pid < 0)
> > +		return kdamond_pid;
> 
> If damon_kdamond_pid() returns an error code, doesn't this leave the global
> kdamond_pid set to that negative error code instead of -1?
> 
> Also, if we take this early return path, does this code leak the
> damon_stat_context allocation? The error path just above it correctly
> calls damon_destroy_ctx(damon_stat_context) and sets it to NULL.

Nice catch.  I will fix this like below in the next revision.

'''
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -223,8 +223,12 @@ static int damon_stat_start(void)
                return err;
        }
        kdamond_pid = damon_kdamond_pid(damon_stat_context);
-       if (kdamond_pid < 0)
-               return kdamond_pid;
+       if (kdamond_pid < 0) {
+               err = kdamond_pid;
+               kdamond_pid = -1;
+               damon_destroy_ctx(damon_stat_context);
+               damon_stat_context = NULL;
+               return err;

        damon_stat_last_refresh_jiffies = jiffies;
        call_control.data = damon_stat_context;
'''

> 
> >  
> >  	damon_stat_last_refresh_jiffies = jiffies;
> >  	call_control.data = damon_stat_context;
> >  	return damon_call(damon_stat_context, &call_control);
> >  }
> 
> If damon_call() fails here and returns an error, the caller will handle it
> by setting enabled to false. Does this leave kdamond_pid holding a stale
> positive PID instead of being reset to -1?

Nice catch, but not this patch's fault.  I will separately work on it.

> 
> > @@ -269,6 +281,7 @@ static int damon_stat_start(void)
> >  static void damon_stat_stop(void)
> >  {
> >  	damon_stop(&damon_stat_context, 1);
> > +	kdamond_pid = -1;
> >  	damon_destroy_ctx(damon_stat_context);
> >  	damon_stat_context = NULL;
> >  }
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260414045002.88110-2-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260414045002.88110-2-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

