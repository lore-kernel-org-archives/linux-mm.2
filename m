Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B89B3109B46D
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 14:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4E6E6B0092; Tue, 31 Mar 2026 10:11:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFF6F6B0095; Tue, 31 Mar 2026 10:11:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3C876B0096; Tue, 31 Mar 2026 10:11:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C43706B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:11:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A285C3F10
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:11:46 +0000 (UTC)
X-FDA: 84606546612.04.302ED93
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4475D8001B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:11:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pj06nudl;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774966304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uEOp0RWGebAq1pKpMH/DnvyOx31FKeMcpUjas+GFEbY=;
	b=MiNWLh88UboAWvP6dmQc8y3IDrrsuhG+LaaD8mYmifMnpfP57QCxTP4C1DloI08NaIAzcb
	+7+epJoemA364j853lPB5YGkfs2wQJLkQzkmX4GrkQ/2OawnNJSOMSlpcezPL+WrEWPVZ6
	PNuV/VoR8byivFwh8EoS6p6cEfQ/Cmg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pj06nudl;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774966304; a=rsa-sha256;
	cv=none;
	b=XbH8ykL0gtaPXOqmaUzcfy5n1VrlrVK2lhMObRaB48lTEdNHhmJGLF7TCtsUO6JMmtVoal
	/zineWTyECLJxjtrOFRpjRu04JR6TD3+EEsQeNUtLZAbhiCxrEklxsDZ8o8m65i4c3d2L8
	NvSiEWazcYxNekmcoXAKzV9t5/AOoW8=
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-38cb8e42d1dso4869531fa.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774966302; x=1775571102; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uEOp0RWGebAq1pKpMH/DnvyOx31FKeMcpUjas+GFEbY=;
        b=pj06nudlNusY3Hf6qqm7FV3A/1ZSG3bPQh5kNy6iySeWHAZi6TROgy2wdHegEjinEP
         BQ2G3Hzmo0ZdvYjgJZlBKsnme3QvoJ71LwCWzEgigBqYqejmNljcDVzwY9Qs+RBs1c31
         tBOSVyckhcxjtsaqVTHUGS/GW5hKXrVFE7Bw19RZVFSJv+WjYL1cSIvrysjmqu4stb0k
         CeGAPIBJYx8PrCgoem3BidhL2Un1mvsDNcWrhJEB91I6IxfV1YtCWsO7wN7DpPz4EoMI
         U9WC4kc6d6ysA8KosA2073snBmgL/e9Nab/AYXvtk8kEkDuGx26kB4YvGACQSDjrGW46
         IJFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774966302; x=1775571102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uEOp0RWGebAq1pKpMH/DnvyOx31FKeMcpUjas+GFEbY=;
        b=qHhlF35j+f0pdH67eCeV6v20YxEx6Ow9H8tMCQwg0ujK4MYzWjr8p7iUeHk6y1BiKL
         fK7xy5+uYzKSnobfX2/oH8d0KIeHRCzALJ2CqaBb/51pr/g9smFOuoDHsCTzSjr9Dshr
         t7AR1jMSQuz0ADNTd8zK2Ilp81kA7tScSXJL6d76eVdHf/SA1oTTtWDTOou5SiboxT7U
         TvgU5Oe5rhOHdU0SPlbjdD817XSW5nu+ifngtcp3I9cv6AcoiRqm4X2knObzPeDfo8zt
         1iR70Seg09YcWrSS489Dy0SzxZ+Mt/tD0l1HoHsi0tDD2TGLiuBQEWcmvqVQcxQIn0cN
         KlMg==
X-Forwarded-Encrypted: i=1; AJvYcCUpD6lCTl0ATPkMYcB+zeGyQFZRVPcp1jtNra2iEVef9Y+jsN4zrT/h5cnKgACcYyB7bHaNtdmBww==@kvack.org
X-Gm-Message-State: AOJu0YxFIy/MMcOXRF2iCC+c63z/SSrRDiYME42o2dcyBGMB6uneEHJF
	ZpUzGL6/jMYOgnespmBpXeu3lH+XXnNon/NQg3KhzRwgQJS72+80IsMl
X-Gm-Gg: ATEYQzygvXEX1scgpt3SK8gVj6NwozothO35p7h/Dwnxj+f6Ayx1VyuGnt9SlaT2dwO
	nZRGOXuGJHHsXha6BWFZug2hJEMwa4qpENZIvGXP8T0xBarEn0YVuOiqWSbWEhCsv6zda5II+Qa
	6x7qo7yjZa6mUnVJ8pDaoUKrqozm47hkgsnMlST9/F7+W+nt0sHFaSou+hHJgbZncnH42zEDsiM
	KInIg2jDaCPZfcoP19H1oqbkwqgiaRZ6A+GoyF/r+IbxpaadRYha3+fN9cJSmn/sGrnuU2Ef9Cf
	oVWydf7x5fhJTo7SuBUJu3HfeXolwG814r/hmh/8wTYLDB+0YcYKPYlcRg6Ftf/dGYXV56bGrqa
	E8SMcx9Eos1TYv/+rsc/47fogJf88ZP9yNnEKeNFsOUEkVpwjO1/3D3KDnUebZ2Vasq72Gpkhgf
	c=
X-Received: by 2002:a05:6512:695:b0:59e:57d2:75f0 with SMTP id 2adb3069b0e04-5a2ab928655mr5498684e87.32.1774966301894;
        Tue, 31 Mar 2026 07:11:41 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2bd66239asm514817e87.51.2026.03.31.07.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 07:11:41 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 31 Mar 2026 16:11:40 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	lirongqing <lirongqing@baidu.com>
Subject: Re: [PATCH v2] mm/vmalloc: Use dedicated unbound workqueue for vmap
 purge/drain
Message-ID: <acvWHBzPc82kPEdM@milan>
References: <20260330175824.2777270-1-urezki@gmail.com>
 <20260330121625.c69f46a63c86c9540b823398@linux-foundation.org>
 <acuWOtKmPTzrYEEG@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acuWOtKmPTzrYEEG@milan>
X-Rspamd-Queue-Id: 4475D8001B
X-Stat-Signature: mfw35u4fznygzwu74pqewfomam5ym94q
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774966303-638378
X-HE-Meta: U2FsdGVkX1+xa5GJrL/dYv2Zf6c7uMyaJknv0HSZQVZx58aTORXIWKwcKRrZaS/CTvS+ZW1KHmDlgAnxfaocZOrG4R5R96ptyl3B1ocJtQ6YT/W/S1argcOWLlMXlJWoygsJom3XK5mKMH5h/6fxiDHu04PgO6d+CFXJgiUDVou/AuFZKsh8Oy+xcpZyqiGHBtjoGUPsv1EUaG4ECJOoaiNv+IN1HT9PiadOIRU8dJLsnHZ7T53Yl6/UVyv0zDAA22UiX6EfbbVt4ZDnMXxw91N76rywN8279KIJefIQqV3BTbvSGUInGU4TxMZVOnYv+/gMNLYETYrfpGf5dLrEE2mIF6D20+Zv8CNsqg/y0hRx1B/7RfBDvhJQ3IT0+FqsMq186VI4zB2JHm3SQW6cLVmda1/m7zlThM68h1PU1AU738rCCN1mi7ckaYZUuaGSi2cuZP/xgMIeWYLBBVX8oyMDO1BzK5sg4jyTRb5UoLZVKVgKIPErNdPyIw16Dl5UwmY2gD7pgmgpUShDeHUmcq6mRXl8NQibKQ28j8LxF1o3bf5THDnjaNQc4yXiGa9XRNwRHt5nvQXCuW9CBZ1oDMCbOmRZU5ZWtatbgI/E0/STmSMmWVa7+ACh4d5ZYU4ORfTVaBbOiQggIaT80X/uOFpmnZo22ujK186tf0JHXZrwvMt6RJRvJDdFVa4YBOT7XFjTVkFXQ1JTJTOvsZsHy7gWphB04hkH3CrDTTLMQjwhSktf0pCaGp56nw8cOhK1Q5m5efpIF2Y3Mc9+WN8pHutFeQ989gntl5Du+7+6+6wcLcP/m165IOtZnCsVwTOp9DSgyHEYdPkkFWTPHm46tjRXNAsVe2bzMEXyWCcxLTTvRKRrKUR63LEsx3dmXIoxOsQ0cQE4Kuxe7Fk+QXnX2FAvm0Meji5jalEMiOKQBiTgusvjF0qEq30/NfD1Qkh2uzOWk4gD0ER58YFm+kY
 QdjWsN+x
 oayb2KSoN1lbYAxmCnQlgKeSPScNOHhYi4vrPIXrqNxolj9cHQzj6bM9SvGWqz4ZVbhse/gy2sXhXIC1BTmo4zZvxe6jQJ/PgivXw83bFUbu5qq03pxwyBwa6D492QVazHV8lGUoQ0xVnjFIz3zOWiMHIG8vwczNIH/kYMXlQw4r4pA/0Ml8+zwby/vi/XMe2YNxie19e9X2/0xqyrKTh8hiqA1oC3Qc7kB3i5ybLOd3rrkQAJg1XaB6BM1WoLlZwYQRK7X4sVOTTMt4RQH+kMQ5QYlJoVlPUkTsIr+yt892wFbgZ7JjwH0DkO93VnBgLe59VXPX57MKcFc0uMR/NkLq0S/2oUJtiTPUKWPSBaKJVY5w7gwnRnpmrrLOqFi5jo0XYvp+//AeQGSa1tm3BfnIbCQqcWQdTWA8zkEIqqSPc68w282WSYB1YqaCWlVb83nQ7gmztdLuYCgJOFpArOzIHTirkEHFyJjRq2JVBHpf86cgqxGY5yiqvJiONckPn6nwZ2n5jerXm9EU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 11:39:06AM +0200, Uladzislau Rezki wrote:
> On Mon, Mar 30, 2026 at 12:16:25PM -0700, Andrew Morton wrote:
> > On Mon, 30 Mar 2026 19:58:24 +0200 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:
> > 
> > > The drain_vmap_area_work() function can take >10ms to complete
> > > when there are many accumulated vmap areas in a system with a
> > > high CPU count, causing workqueue watchdog warnings when run
> > > via schedule_work():
> > > 
> > > [ 2069.796205] workqueue: drain_vmap_area_work hogged CPU for >10000us 4 times, consider switching to WQ_UNBOUND
> > > [ 2192.823225] workqueue: drain_vmap_area_work hogged CPU for >10000us 5 times, consider switching to WQ_UNBOUND
> > > 
> > > Switch to a dedicated WQ_UNBOUND workqueue to allow the scheduler to
> > > run this background task on any available CPU, improving responsiveness.
> > > Use WQ_MEM_RECLAIM to ensure forward progress under memory pressure.
> > > 
> > > If queuing work to the dedicated workqueue is not possible(during
> > > early boot), fall back to processing locally to avoid losing progress.
> > > 
> > > Also simplify purge helper scheduling by removing cpumask-based
> > > iteration in favour to iterating directly over vmap nodes with
> > > pending work.
> > 
> > Thanks.  AI review flagged a couple of possible issues.  Do they look
> > real to you?
> > 	https://sashiko.dev/#/patchset/20260330175824.2777270-1-urezki@gmail.com
> >
> I think the problem about itself locking if running by rescue thread is
> a valid concern. I will address this. I think the easiest is to use two
> UNBOUND queues one for master/main thread and second for helpers which
> reclaim if there are too many objects so the help is needed.
> 
> I will work on v3.
> 
> Thank you for review!
> 
> --
> Uladzislau Rezki
>
I will fix the AI concern by maintaining two queues. One is parent
second one is for child helpers. That way both will not block each
other and both have a rescue context to move progress forward:

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6bc2523bf75b..2c1ed76cffe8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1068,6 +1068,7 @@ static void reclaim_and_purge_vmap_areas(void);
 static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
 static void drain_vmap_area_work(struct work_struct *work);
 static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
+static struct workqueue_struct *drain_vmap_helpers_wq;
 static struct workqueue_struct *drain_vmap_wq;
 
 static __cacheline_aligned_in_smp atomic_long_t nr_vmalloc_pages;
@@ -2338,10 +2339,9 @@ static void purge_vmap_node(struct work_struct *work)
 }
 
 static bool
-schedule_drain_vmap_work(struct work_struct *work)
+schedule_drain_vmap_work(struct workqueue_struct *wq,
+		struct work_struct *work)
 {
-	struct workqueue_struct *wq = READ_ONCE(drain_vmap_wq);
-
 	if (wq) {
 		queue_work(wq, work);
 		return true;
@@ -2400,7 +2400,8 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
 
 			if (nr_purge_helpers > 0) {
 				INIT_WORK(&vn->purge_work, purge_vmap_node);
-				vn->work_queued = schedule_drain_vmap_work(&vn->purge_work);
+				vn->work_queued = schedule_drain_vmap_work(
+					READ_ONCE(drain_vmap_helpers_wq), &vn->purge_work);
 
 				if (vn->work_queued) {
 					nr_purge_helpers--;
@@ -2479,7 +2480,8 @@ static void free_vmap_area_noflush(struct vmap_area *va)
 
 	/* After this point, we may free va at any time */
 	if (unlikely(nr_lazy > nr_lazy_max))
-		schedule_drain_vmap_work(&drain_vmap_work);
+		schedule_drain_vmap_work(READ_ONCE(drain_vmap_wq),
+			&drain_vmap_work);
 }
 
 /*
@@ -5494,11 +5496,16 @@ void __init vmalloc_init(void)
 
 static int __init vmalloc_init_workqueue(void)
 {
-	struct workqueue_struct *wq;
+	struct workqueue_struct *drain_wq, *helpers_wq;
+	unsigned int flags = WQ_UNBOUND | WQ_MEM_RECLAIM;
+
+	drain_wq = alloc_workqueue("vmap_drain", flags, 0);
+	WARN_ON_ONCE(drain_wq == NULL);
+	WRITE_ONCE(drain_vmap_wq, drain_wq);
 
-	wq = alloc_workqueue("vmap_drain", WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
-	WARN_ON(wq == NULL);
-	WRITE_ONCE(drain_vmap_wq, wq);
+	helpers_wq = alloc_workqueue("vmap_drain_helpers", flags, 0);
+	WARN_ON_ONCE(helpers_wq == NULL);
+	WRITE_ONCE(drain_vmap_helpers_wq, helpers_wq);
 
 	return 0;
 }


if no complains, i will send out v3 soon.

--
Uladzislau Rezki

