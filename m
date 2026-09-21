Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22418C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:15:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 166BB6B00C7; Mon, 21 Sep 2026 10:15:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13E336B00CB; Mon, 21 Sep 2026 10:15:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07ABD6B00CC; Mon, 21 Sep 2026 10:15:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC5896B00C7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:15:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C6ACE401C1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:15:08 +0000 (UTC)
X-FDA: 85237966296.28.F20C17E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4C701140006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:15:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aqLXkHu1;
	spf=pass (imf09.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790000106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JYmkAVW6MGL7d6FmukCxqbleAMN+cIrtRe3QYgaLMXk=;
	b=HuC2F1ETSsvtd18KhkhyACdqqlnf6Nogd6ot8OHagAkD2VS6tzSuUgw+HY0we/0iEyO1qA
	gwJ0VhtIekX3EBuPABf4PjoCLNDmgi1TwZ40Q+53qgiMSM9ZuMgfcV2IyUpw6ZPgkSMgGB
	lRvMloLHLhc/X9hxTGngO9u466+qOxQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790000106;
	b=EY/3+zu8lnLw+GD08hO2qQD4rtcPc7xivVtXPT5/RFoyHnLMrRBKWLC0fb9oIOJb3ILJGL
	asVNJAeHlFHwXXX4GfQUxZ3r1vMQmUSI9UM2vvclHrwwjJMG4YD+Ch2UxDtJLIdWu9ZIdR
	sUChqNfkAr9DJPhBmMA5FNjvviGdPCM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aqLXkHu1;
	spf=pass (imf09.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790000105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JYmkAVW6MGL7d6FmukCxqbleAMN+cIrtRe3QYgaLMXk=;
	b=aqLXkHu1lhmaHL8CC2ONtVkITGdbwv5qpPNyBLUNoi5OuGJ/NHiDa8APDw0zsdj4FwIaJl
	xnYHeDwTOs78jvnC55sKUTPe5xJk3ye48pjfFQlA2xPlmVDjaPWqRoIlnWeApfBBMlMxCZ
	MTNk5L9w6PXUtxbet3n+nVB5LgDuisw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-133-aXu1BVHwN_OPLkok5J7aYw-1; Mon,
 21 Sep 2026 10:14:59 -0400
X-MC-Unique: aXu1BVHwN_OPLkok5J7aYw-1
X-Mimecast-MFC-AGG-ID: aXu1BVHwN_OPLkok5J7aYw_1790000097
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7805B180B5C9;
	Mon, 21 Sep 2026 14:14:57 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id EF8DD1800348;
	Mon, 21 Sep 2026 14:14:53 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 21 Sep 2026 16:14:57 +0200 (CEST)
Date: Mon, 21 Sep 2026 16:14:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Chris Mason <mason@kernel.org>, linux-fsdevel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 12/17] exec: cancel io_uring requests before
 de_thread()
Message-ID: <arE73DiU0QWOeepF@redhat.com>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
 <20260921-work-coredump-fixes-v3-12-8e4adb1619e6@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260921-work-coredump-fixes-v3-12-8e4adb1619e6@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: eI4H1HqEwrRqVoSdVncxKTFUjOXehj4i5nbYFzkZODQ_1790000097
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4C701140006
X-Stat-Signature: 9d6767namkhq33wcf1q3xeyrmriuwdix
X-Rspam-User: 
X-HE-Tag: 1790000106-127549
X-HE-Meta: U2FsdGVkX1+tmS6sWXYe+YbZ2C0ORlxJ9kc2p+gCgF4NUWN6xxiuGiWAPpoAz0vF5Me1wpaze0dudnBkqYwvDErwOJCGOJwkZ8qZhcaH5mPi06hUN5NNDONpC2LYa/0WumwPMOiWGC+l4dAwviVxaXoINYfV0+7tQcY8Sf5RTSdDNC/Bz7ajkhfcF0xJQDdBqBQFPcQ9pLYuiqX73lGqBI7RTcTsfBJKUviYhlY3Gkc49AQPROeoXkKK+QvXA1H29QsvTL2C1WGKZyKhrarEo9gCIwwwcDzln/E/Qu4PUbD3SfMAF3bDMx1aJXEAXKCedzb0yJhhkhHiYffU2urd3UukVlLGXEq8rWecdvGA5+EJ3XD9U5Zz7WMr3tfgz2/Rz/YylustHgGddLSndbSasS0wAQyc59Z3MO1KJsEhLfwf+UzdsEz47hQuNQgdE4JaiQ5FTT4UHhlDnTlmDtWRi13jybx7LoSXw0y5VvMOeOTOpR0QTnv2ecI1NklV0NDdIQFM/ZJqPJAQJ78cI9/zMcBoTfIhrKxYMt+mxQS17MhutGnty5/gbrIv6BmfP7loAoZ4aXn2OhiEUFAMZPeVUFU+DgLcPWVW+w6rhqD0iJOEO045L9jDhtgFxtOkWAKnvbzcGQtLDhPUH545w9T1HOV9pzY9A/21iB7xUgtLIppJ6+YYRGernX4QZG56xosQ8F2HBTxBX5NXGiYChzlH8/8hb4NdwkliXvBMOx96/KIdYKwq2btS9KvBwD3dg7qg5qO1JUty8gZZkwbEhHKYa2N5WPoG1TcOi5zM+G6XO9JC2SXFkBS8CswaxU/Za5V7E32kGJVEgbZhSC690Y6fzq9ygeoUEk6B+Ro9OYU3fdIGPM8ao3KfIbori1y1EjHVGxEz3PnuUYXw7zHyVqMzCega/U7WEJEfOkuLeBL9XvLBuv1tIzrXzCvSrFpEPm+XZKOAU0QkH+TBoMgIBLo
 D/14rmEt
 /1sdjkWG5Mv4dqV7RAWaIx70epnbyAglp62NeQptZBQjfYX6ADsKfzcnGrdKJ7AOOIJJJM1Se6Sox7XPxKpWpz8FT0JVPKTTjHQ/RZqHIaapttViWoydLiAQb9lMasyD3RF89Gk6+HIDGmIw1PrwdzZcsermy/23XQ/vMpgKj9LUKRTqUL5ULFJ7jrQ9oW3YwxnjpyOKvp9N3Pt8foGdePJnDFKCr+sLWjdWKvRj1ZwWNZgVamWvcalGSx8nt0xGpNpUfBcNrPvorAAZ7SF/buhUa4LGG/jm+dtkl4qL0nT5uSC59VXk/Ao7Or/y+Xkox69OZptnHy64Z15v9R44g7FPu3d0D/HkomE5GLBiXcznSATnuK1fEp/5IgGmOGR1CQqYFzJQOOmpNEe+eieJNOKYpqpxxD4NfvIHh63wiQdfJoUlgIXrTVTAB6nBHQ9ca+VZT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/21, Christian Brauner wrote:
>
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1149,16 +1149,19 @@ int begin_new_exec(struct linux_binprm * bprm)
>  	 */
>  	bprm->point_of_no_return = true;
>  
> +	/*
> +	 * Cancel any io_uring activity across execve. This runs task work
> +	 * that may still create an io-wq worker, so do it while de_thread()
> +	 * can still zap it.
> +	 */
> +	io_uring_task_cancel();

Acked-by: Oleg Nesterov <oleg@redhat.com>


