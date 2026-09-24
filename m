Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 039DCC98317
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 12:11:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CB496B009B; Thu, 24 Sep 2026 08:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1E76B009D; Thu, 24 Sep 2026 08:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E0BB6B009E; Thu, 24 Sep 2026 08:11:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E02416B009B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:11:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6DC15160335
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:11:13 +0000 (UTC)
X-FDA: 85248540426.02.421E331
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4C30F12000E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:11:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JhQzEFhQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790251871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JDrK6jWmSv04P1PCELJaUCtzX+TaKcO7dGIXMzIhumY=;
	b=mXFT0LUSF38EmyDQZ9PsIvINcebhpPuJ2graa6/WWPHYX1cSj8FZWzpY0MvFijj2DsdKAC
	8YD31lxO17k1cMe57wGp3keJxb+jD4F3hGzkB6HqtqzerFQpQahKNea7x45HnEnQSutw7b
	ML8eCjQ/EGVQbJ7LUYXUCx/ewrrPmxg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JhQzEFhQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790251871;
	b=MI4qc9Lc2wbv2YHqYzXita7ExiA+5juXIsht1eM+pDtQIl0Fm+8oj17yjozeBs6FIvuZZq
	x9dnLj8ud5pirQrvNBGsvBuTHdljRcr9gVwgXKKLdCArZZLlQ4BPNYfZN/jnl5iFJLCDU4
	1oh5bs7IJvZIo1vIEcgsmCLZkkTme0I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790251870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JDrK6jWmSv04P1PCELJaUCtzX+TaKcO7dGIXMzIhumY=;
	b=JhQzEFhQOXnZLtvmEExSrC9c47KB66vMj5GKnbrbknMxQWAiyUlDkGbwXDPJZV2cmz+H8n
	lH9osGhQzDHRsbolwGwQeXrvHZ82+kt5HtbykDdUo2VkLJKOMde7Osd/Ijq7fkQildb6dO
	zbibCEpZ7OhPFNqKqa+/wNKix8J6IK8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-435-5BP1BdFpOxKT_Wmpq3Yv0g-1; Thu,
 24 Sep 2026 08:11:07 -0400
X-MC-Unique: 5BP1BdFpOxKT_Wmpq3Yv0g-1
X-Mimecast-MFC-AGG-ID: 5BP1BdFpOxKT_Wmpq3Yv0g_1790251865
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1B8C1801317;
	Thu, 24 Sep 2026 12:11:04 +0000 (UTC)
Received: from fedora (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id B2EC31956054;
	Thu, 24 Sep 2026 12:11:00 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Thu, 24 Sep 2026 14:11:04 +0200 (CEST)
Date: Thu, 24 Sep 2026 14:10:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Chris Mason <mason@kernel.org>, linux-fsdevel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH v3 08/17] exit: hang up the tty before closing the files
Message-ID: <arUTU8oO1pce4bd-@redhat.com>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
 <20260921-work-coredump-fixes-v3-8-8e4adb1619e6@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260921-work-coredump-fixes-v3-8-8e4adb1619e6@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: IY_uTrwghdQkGvaIa1QsgG5OWCXJ_uIpqocZSc_gm4k_1790251865
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 4C30F12000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: g3wbr6e4uu6maeeesrxh47mi6iktaj3a
X-HE-Tag: 1790251871-601561
X-HE-Meta: U2FsdGVkX19hdwMm0CWP0SspJP2ax9UAqjt+C1pij6iy4aim0M16krX8EHwfah6LOGCydMHEEQQSgH6hKnmfxbuokaZ0raQcOzIpd8rnJ/ZcvoLJfL+2B2ZlJVM2JiJCAMIPlal2Wnko6+vdrw2vrPF3ZSi9W+8D7zVPu5zQpoCl6osFX9W7hZh/ofKmqWhvMfKB9B26q7tq+xK04RJtt8Rzo7kw4Pl+eLcUOEeZ9RxNF45rADepoul/c0N0W+5vmB88s/Oat2piMHhGPUiLtJR+mHJ5zQbkpQCvk2tvTlZUeY8G61iamRp70S4P8b9VGH1Nslbbl2Xm1P6KsHzclNAnZMP1AGkVAsuSNpBGa2rfFyThthjosz2F3xIjAXtlhAxy2mgy8X0FeBcj8dxkUUnKfO5bwoJ03BpVUVHGHoySU1PYvzfescNS1cOaDIbLkuP9Vd/ziKRHAsqWdVxpYlefa+fvcpVaKWoHyDzN3DbDlBkz+LLophDPxMeJCbblsuwoeRUd1SUISWawmYXFG8pPvPbsXR/V8gUW0kf7yf4pon5DxfUg1CzmsD8l0Sq9yFYuRt2uaPPSKvdBuKNvCyGPRKtVfkjzfRyvnvB/hA2MYMT9QLkc2Z56Z1uh7ekJEpv6INoIIQYZDmG1EKu5zf+STE4tO61019Rd1FXb5oQi7ORcG7D8FcAbv0oWEGQXUdGxERZXWwFYQm/Io9TViFXyS9GQjl65ye8i6f8dp0TfeksUEOdRHT/xRq2ltr3poWUVkXJYBTr9StIjTunSsZPgJcOjkH4gP0hytHaLqgzNQARLolo4ik5UcbENDJeuNSoUrTKFmpnDpRw5FPPFlcdPo8bDpuIi9O632aO+Xv/jdi/TmoaJLke460av3KF9hnvTI+ofs5G8unfad4CjQUkTthbEfqDOklSFez7V/jbgoo8MoIFyRmIcqAG3CuOx4BvExVhEda3tnrHAO8p
 FBASZLLM
 egfalR+f2PvqY+rR4FDWSzZTgfyZIzS+b1nd9f/3oOiVL9U05S7KghXTkrEikRYCJQJDLN0iNKoYxM52mBYmvCC2bQWcu+Qdc6QQ1q3P0BtaBf7RVB5E569ZB8z5Ic/RkFt9H+XOUdXa2C7cN3lVPkUhw1k2NC8otOdRAaua8VSbNwpBzBFBn9BnLswMjOKF+t5MbDbXsz9/KEeDdo24VtY0vE39fk+oVeO3GUnsmT0IhhBRpBHuG0VPmzXsWsNOsHBAFi/qCglrqV7qGZzx/T3RYvyjaFalnh9SpUjRjsi0+TRcz0mqeRwvCxtk4rSTV5xro933KYzxieYxXOHqrguSkhOpfZcsyRBNGC1Eu76p0Iu0o8yeMmGlUJrr+rzNx6bhrGg2qxabWL/QrTrgDhEF6zA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/21, Christian Brauner wrote:
>
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1003,10 +1003,11 @@ void __noreturn do_exit(long code)
>
>  	exit_sem(tsk);
>  	exit_shm(tsk);
> -	exit_files(tsk);
> -	exit_fs(tsk);
> +	/* Hang the tty up before the last close of it can clear the session. */
>  	if (group_dead)
>  		disassociate_ctty(1);
> +	exit_files(tsk);
> +	exit_fs(tsk);

Acked-by: Oleg Nesterov <oleg@redhat.com>


