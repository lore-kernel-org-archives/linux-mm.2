Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C2A8D3CCA0
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 03:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0C356B0088; Wed, 14 Jan 2026 22:13:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9EA6B0089; Wed, 14 Jan 2026 22:13:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBC4E6B008A; Wed, 14 Jan 2026 22:13:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C96C86B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:13:55 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85B141401AB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:13:55 +0000 (UTC)
X-FDA: 84332728830.17.A4167B9
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9415080009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:13:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ldLfHJq6;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768446833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Jw+mUY3hA7BYhlUNwtrUxUYy8CLTFaUlLtDD3kSUDM=;
	b=DPvCwbs/QZ+b3nfAw/qeLwJ3uGG70PEXEqBJ2B3fZK0BFy+h4LvBxn2vQbKhvavSr7b4k8
	nSXfhjPC/g4NzECi2J5kHGHqnecf/GIG3fENt0uD4sRBFCCyFznopOGqOFdNefsSHRl47S
	pWg+6TvNza9yxhHzzbvNu9/QqGeDQSU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ldLfHJq6;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768446833; a=rsa-sha256;
	cv=none;
	b=uXFbw+iYVH5lqF9mhAedI430tod5P0l0Jhn2lwYnnb36W3G69nnLGUkuXutlkNNAaayV3t
	M5D49VUx3HFxGNCO1gEoIEZzdAJZG6DkdM+slZPO4Y+bfgarEDWtA0mUX/nW0ghT3EGvbQ
	eYcb1FxR/c7grVHNtIcspqKmJ9VPFw0=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a07fac8aa1so3640355ad.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768446832; x=1769051632; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/Jw+mUY3hA7BYhlUNwtrUxUYy8CLTFaUlLtDD3kSUDM=;
        b=ldLfHJq6aclA9vV/KhLZt8idjxxbZ8n59krz4X6plWCTA8+WYWUsPxIv8u4UdDLd+0
         W7oLgy87PjIYKcGd5zRH9mfvzTxuPDKvk0eqFImYz/YJ5gFL4y7A09NoxeBXLHvsVAvI
         dDJ1iseCb6Y7YWebwUwE11h322fZo7N42veDk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768446832; x=1769051632;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Jw+mUY3hA7BYhlUNwtrUxUYy8CLTFaUlLtDD3kSUDM=;
        b=HHvFnA6kcMKeFgq1Xg8ROrcguHNUsUchweyWaXZXJS44eXHd3F3RfWkj+++RQKork3
         qgPJiXUmT+r1bYrOw0RpgDwd3ulyacPozKmFC+W+FPglWNZbxeYTXBkeVHD67wUI+FA9
         WYSXT4/AchA4iqbqFm+TReYppBzN72AmhYiRBuGTK31pXVFdifNwIRcTScZhvsL1Z6lZ
         V3tLggJExuQeQOsE7jsrXAGT81tnjQTfCu4nZc1uc0uPSOqM6u1la7oviD8aDRUDXz7O
         fdM1BPfekT7izSai8YB5nXtJRltMS6vEM2XmK0bAlvz18bi4coLEH0WCLW9Lvs4EwzFk
         359Q==
X-Forwarded-Encrypted: i=1; AJvYcCW03Dq9RgMYN/zcLb6ERYe5KfCfQgLmZX8L6G1HhQE7vopLv/c0nyDgASeY4lZ+kIj37iWsT7xvcQ==@kvack.org
X-Gm-Message-State: AOJu0YwOjcPhxJA5/4NrDxS9Y6SBuaijJZrK6IOkmXUC777xeR6RKNkk
	btoEw76hWdyELZ0VMpOTKH9CW/lPankYhzewjIw1hAPzJjOguUvYZCo7M9pCfslz3Q==
X-Gm-Gg: AY/fxX6eOem7ML0BhQ86ZPatD74TOykNbb7Dr9y9YdjTHo9MxtBO6rPKFSf73GKOOio
	+Y7E8pb5X5zkkbSRXYxomRLxMdNlEUzJSMRvTGJUeXmzNmaxKzxuYy5oTPpKZW6FmnRQ6/XO/Li
	FpTQXMs7kd4WCY0ayPOlDNg4ING1IoNWctoBklNvNvAMagQIvNLkX9FynwbYS9nAnxR+oic6i3z
	bmMeFVbhdZe/1xH3hEWPufPaEqe/N9HCYUY31i0wSOJcq6Dqv1D0jHO41/2SHlbtAkrFesgSAvg
	Lh9ZXDKkBTbd/yrrK0Y4shRexd5Xdmu4yzL9+0uo77/2L5hmUPz33OAc5J++J5Im265CbguLAFv
	C7ZGG2IGZVya6k94RO+igEnvCF+HHSrE2v8HV7FrdymygIrtZtKVga7Hyaf0fJ6lKnscSVN60e8
	I9Nzyzy38bEDUctThPQRpGpDhpzNyfsfYudB+ii7/vSetk5zKv6v0=
X-Received: by 2002:a17:903:41c2:b0:2a0:de4f:c99 with SMTP id d9443c01a7336-2a599ded072mr37132945ad.9.1768446832370;
        Wed, 14 Jan 2026 19:13:52 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:36c2:991a:5236:1fe5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c5ce06sm235752335ad.44.2026.01.14.19.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 19:13:51 -0800 (PST)
Date: Thu, 15 Jan 2026 12:13:46 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Chris Mason <clm@meta.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Brian Geffon <bgeffon@google.com>, David Stevens <stevensd@google.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 1/3] zram: use u32 for entry ac_time tracking
Message-ID: <5dm7qshgxenr6urnd4mdis75r6zpk2rlzcey4svjsp6m4jvnqw@iq4myzyiwm6u>
References: <d7c0b48450c70eeb5fd8acd6ecd23593f30dbf1f.1765775954.git.senozhatsky@chromium.org>
 <20260114124522.1326519-1-clm@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114124522.1326519-1-clm@meta.com>
X-Stat-Signature: 7igs9co9qxkk1c1refag6eatfwufudrh
X-Rspamd-Queue-Id: 9415080009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768446833-467502
X-HE-Meta: U2FsdGVkX19qB5jexq89IJ41q/6Mko2RFQe0wz8S5nGfUDs1seSqrIhYqCUmPMW6J+IULrQfLWehp6SMqXBI3i+23SUaqEJdFWwNim0AzCtUcalZvD/bJshnStQ65NpNzjqPei/iYJKfeC0tx52gHHkOip1QiY1e70JyKdf6cao+8EHlj+tntqdBdpqzCnqFj+uAAKwObZKCd9GlJU23rvqaSMoQlCwToMX4jkmCh5xQApwtjaudDBYnuATh6lx1PQ+QNA3NF3cfRdx+XUywVoWVIIwi2FPdlUiCsV0IiMmP5S2XcwbP/ij+1oGk8ZPnXcfi1fpKQtQXEs6SqvtW5HUTZCKvsmVJQ8+1Xd/4SYHs61uphmw5jhE4pVAhaFrkunE1pYofAFF4dwr3GmOi2z/CQ7cxL/ugzpmyk50RfiT3g+jbVpMHVf/S3LYQpvC+JsqQTOxSt+/s/UbXDDZrlFIO4Jafgo0wdzwvdXMmn4uTVc32/UAhIRiYffuFQAo2t0DGz3xTiNqN5Go33AmLxu+CCF9IFRJuD6hk5VCxzo+gBDXzPHb35jICsGWgvkLvPl2FZ7197YLg2yua7ez0Fp8vh1OcDgzH+jVH5cQ8l2xLk8B3i19X6YmaoPG+z0/vi3nJOqjMHus4eLR8in2uV+jZArzq9fV0BU5r/lECqB+rmzgMtb17+TjEOSTf6LOdRaaRjSOim26co/acIekrCet7IeBRtXLjhajITL9xj8ItgRbhODGnIRDxdiAcI23skb3wR1TWhFWSrK/utVg/vZFy8B+09gU0eUkB8ig8ZxOhlLIza/sg44qWDMNWe7SJkOz0yzQBidW8WsflmmJD2G/eMCaUSS/+mMWluZD94SgqBscsIYvejiqBGk6fxtjMwofaIT2Iqn95072iZaprON3N7RRIQWzVomunQyyUyoZrsuit46NW1tVCONsMX/f/TSuopkyYjfsRVmKJcJw
 zovgEy6c
 XekrRzi1gkt1su/99A95FUPX/Fcbtcobnz/P4dlCFoongYkpMfmryrk7UGEcR2y8tLZxp9XcYtynjix+DzkvdLNYp8mAOmGREQhoZ3c1LGmOBBp+HjMKMyXTMTgFD3ypgsQC/HsF8exoeHtDwR6CP55SO5I06WrTPKLrrFAiX4ZzCkJqfwekAl1XXNOgkSWt/Rff4JIJBw82kefv7GFrCjt6xsfeXi6h0k039tywVgjW5hmugwABZtppYsA9TW7OmaUcBJtt/2c4GAGlziFNV9Vrd4zDR3M0EKZHEAS+pf3RC14e/t7JYmFDNPaDqN/+pn2wOYTrnlBItK5lSkBKTV5UR1dlgE2C57JCLZnC69L0GgzkqWMFw0YP/Ifp3wBJIXWkqulGSFIDMwX9PuJkmqiDcrd7ykmiRJsUwA1SaosTkflRkcTp2PiXfFCARTxPINOIr1xDnduVgj8oOKdJrZvRoLOSqPzdYXh1geimASc5srjo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/14 04:45), Chris Mason wrote:
> > @@ -1588,7 +1588,7 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
> >  		if (!zram_allocated(zram, index))
> >  			goto next;
> >
> > -		ts = ktime_to_timespec64(zram->table[index].ac_time);
> > +		ts = ktime_to_timespec64(zram->table[index].attr.ac_time);
> >  		copied = snprintf(kbuf + written, count,
> >  			"%12zd %12lld.%06lu %c%c%c%c%c%c\n",
> >  			index, (s64)ts.tv_sec,
> >  			ts.tv_nsec / NSEC_PER_USEC,
> 
> ktime_to_timespec64() is defined as ns_to_timespec64(), which expects
> nanoseconds.  Since ac_time now stores seconds, will this produce
> incorrect output?
> 
> For example, if ac_time is 3600 (representing 1 hour of uptime),
> ns_to_timespec64(3600) would compute ts.tv_sec = 3600 / 1000000000 = 0
> and ts.tv_nsec = 3600, resulting in "0.000003" instead of "3600.000000".

Good catch.

I think it simply should be like this now (I don't think anyone uses
this function tho):

---
 drivers/block/zram/zram_drv.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index cc51aa8b6181..912711faa4e4 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1579,11 +1579,9 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 		if (!slot_allocated(zram, index))
 			goto next;
 
-		ts = ktime_to_timespec64(zram->table[index].attr.ac_time);
 		copied = snprintf(kbuf + written, count,
-			"%12zd %12lld.%06lu %c%c%c%c%c%c\n",
-			index, (s64)ts.tv_sec,
-			ts.tv_nsec / NSEC_PER_USEC,
+			"%12zd %12u.%06lu %c%c%c%c%c%c\n",
+			index, zram->table[index].attr.ac_time, 0,
 			test_slot_flag(zram, index, ZRAM_SAME) ? 's' : '.',
 			test_slot_flag(zram, index, ZRAM_WB) ? 'w' : '.',
 			test_slot_flag(zram, index, ZRAM_HUGE) ? 'h' : '.',
-- 
2.52.0.457.g6b5491de43-goog


