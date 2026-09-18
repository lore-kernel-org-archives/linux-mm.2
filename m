Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87330C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 14:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74DC76B0092; Fri, 18 Sep 2026 10:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FF346B0093; Fri, 18 Sep 2026 10:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ED4D6B0095; Fri, 18 Sep 2026 10:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3ED096B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:55:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C83C4A0190
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:55:53 +0000 (UTC)
X-FDA: 85227182586.06.182A720
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id A4AEE140003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:55:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dss5sRPT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dss5sRPT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789743351;
	b=OJSKTqjP4aCdGR2he0zT1HfJFjCjIe3Q2Mwe+15qFekNfPkQwa4whH3NSO9v4f2mmb47H1
	3BlT4afjdL/5cZ4xpPIhuRX2ZIVNi9ePo9Wyr328XleBI5qFAe38+MdgTQ3boO3BJS/GGw
	Dwo2/xlc56A6wz6ytgiwrPK4M+oyu68=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789743351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=193Eukm5kz/lh19QRcN0hlB5xjOPp1QwF8rk3uoxO/g=;
	b=wRsrMjTjvHPA/Xw91yPEUnVufXQ+30Rfa+yx0SJ2PlY3z2dioQm0VqWCDe/HJco4XMppQT
	QWae5w2GRrcEdq6rBMhJT4QRJCsq/54KsvXFfEhxKPC/qoVQ3fcE//AS4o6uWGNFNyPS0/
	EJFQvjxsrLM3MrfZF9xHW0+3euN01q4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789743351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=193Eukm5kz/lh19QRcN0hlB5xjOPp1QwF8rk3uoxO/g=;
	b=dss5sRPTVf/awXGvJTH9LgqpD8cV8gZ0KNlhuWBjj6NXAWhuk3V+VYGnBD5fHMHH9ZPuOF
	6U+E3wdrL513R5V6AQkpppVmoWHE6ypoKrAp0thgLbqgFGYanvGiFUoP1Y4WKK8G2vZSKI
	0l1brpJFwZfyE3TnFEDUyT9BwD+BzfQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-342-2AFqT8aRN9WgKt31jB8-4Q-1; Fri,
 18 Sep 2026 10:55:47 -0400
X-MC-Unique: 2AFqT8aRN9WgKt31jB8-4Q-1
X-Mimecast-MFC-AGG-ID: 2AFqT8aRN9WgKt31jB8-4Q_1789743345
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 49CBC1935DC9;
	Fri, 18 Sep 2026 14:55:45 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 61DD01956095;
	Fri, 18 Sep 2026 14:55:41 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri, 18 Sep 2026 16:55:44 +0200 (CEST)
Date: Fri, 18 Sep 2026 16:55:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 5/7] io-wq: order the exit bit against worker creation
 task work
Message-ID: <aq1Q652euXxJVf36@redhat.com>
References: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
 <20260917-work-coredump-fixes-v2-5-f3787fcda051@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260917-work-coredump-fixes-v2-5-f3787fcda051@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: OrE-ltQQ5CjIRWb8VuyJRmqYiG4S6Ygl1jxSQp-GF94_1789743345
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: A4AEE140003
X-Stat-Signature: ux56wknd4q1h31sbic545mwe6bckm51c
X-Rspamd-Server: rspam01
X-HE-Tag: 1789743351-10044
X-HE-Meta: U2FsdGVkX19h5WKsu6gbgQlGFc/FbA/u6J8q6ddZB4NiNRVytYs76waWEE3QzhDhK0W57fc0991pHplbF4ZkT31UolWzgia5yOckNLmVkxAcBs6hARVR4Gt7k7LwLI6Irq/XxtbYh1O4g+weGKlaV0POn8QtIIuWTc+tnJO/G7kVx4RQtDZ/6jy7jlPDHi6W7ew5SmUsnkdSVlMmihf5xXdtGqwPhXOc5UAFlBU5BBhJ4lgVoy/xCZYrNIuoO2YeNoaBdnM8xsdlFXM7AP9XXBQAL3ATWFsBImO7WD7SqoGlpfTB4zmYRUfJ2aSRiUNRwKhMzdY4d2vRLNEhvuAdttYLfEOQGi5bNQ2omzMJer7ssdGjK8vtKhB9AqC0FijAlDeaPgZWITgA8e/6TBkCC9AHyQQbqZidZ4mtNXqBTksbL/LvxPKV5mURSnGb5eTufJXBy3urzHf+Kl3mTUtbJZHIO85Z35eZHv4aeC+Id9Dezd2YmLmVr7AQL5O0kXvBu5gntkTtBIGeIL+HYHUY2TUGjcy2tp/hTPO84af7t/pDp4pFzPG7cw/A+IpE0roT6Z3qs51XAq3RDv1b1qJtHGffaqfIwQBq0f8Pej34upDZve+4SKrdef0o64V7ndnc1vgStvxxX7pvzy0EbsICcbofvvRUjG7ilt9bLKv0+7QBWAOn606XDVMNEZmelvpazy5oPgh+D5EhD69EGRetylg+aJoRLMvn6VoJygEmyw9CDpzcsY2n1zrexAMFGTz4uIIO3YbxvZ7348XrJ4r0fyfnA3oRWNMK3L+cO/1GWER6sHq7EdwtGd7KR5hj0hr5dYTdk85AwPcZPaq8fIWFKCHvHjGbMUNpT/RZh8PUGpr6pld9hrN6HTDDf2RTZXHryDFvcA6SVz8/rkfW3hMNhUyqaIsrcm8rgx5Q/VNKkGF0xpgXq+IBeEOSQOwXOISfPotkcrnb648CIeXsWq3
 p0etmeai
 bTd3mdfSdUwjG3qXqEygl3Yx84kmjaWYVYihnk2V/sUdM64t5IC6asbImR7o16r26qdGkW9Z3Lnx/HHfRjgGfBMjoRKpKjoNpaOuckLi9rvrMRWl1SVpv9JGkt12xZqk4FUS1ziJPGX2D9DzA/CBDCgIzQw3w/BA25s/zDbA8SRx+JUBeoAVyzRWfu1wboXokuB2t15NZDocscU3tOV3/a/VBrulk6d/XSLiv/aX9riT6BNeBOq1zeIC199oe75bNfBTDVCLLb0prDIuoguGlbxIeWdMSagFPF116Ff3n+NzowBZL46oL7LIFZbuOM21HUKBDcBWc6sw8WfQHd1RABP5mStiWPeokyL1swN1A03VdGLpaSSJVvyMmV6ujsh1dNsPTR0+aQT/hAKQKDM+LYcktVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/17, Christian Brauner wrote:
>
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -1324,6 +1324,8 @@ static bool io_task_work_match(struct callback_head *cb, void *data)
>  void io_wq_exit_start(struct io_wq *wq)
>  {
>  	set_bit(IO_WQ_BIT_EXIT, &wq->state);
> +	/* Pairs with task_work_add() in io_queue_worker_create(). */
> +	smp_mb__after_atomic();
>  }

Acked-by: Oleg Nesterov <oleg@redhat.com>


