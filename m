Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB1FCCCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 14:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6AB98E0005; Tue, 11 Nov 2025 09:10:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C41E48E0002; Tue, 11 Nov 2025 09:10:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B57AD8E0005; Tue, 11 Nov 2025 09:10:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A48228E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:10:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5620D1405F0
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 14:10:00 +0000 (UTC)
X-FDA: 84098510160.22.37C6FE2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4406140012
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 14:09:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="F/rupKDp";
	spf=pass (imf17.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762870198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0jAePqN6TOEf6jTJjCEwq53g6vGvq/lRpJXMiEpVl8=;
	b=1kIH4n5EFmm7mHPCSrr3v9fqSmlqkQ0WqnAKVu+rFUjDVVyi0JxdJHRAmHkq+fhGgRDswW
	oQvrmK7uB2b1/WjZc/FOROSOSlQMqVP3H9byaVwQLwvbHtQsrVv/5WX5QedFs/KSiuWKGk
	Gkxq4RSMBbbJC4l3fcTvkil0FZx3D7I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="F/rupKDp";
	spf=pass (imf17.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762870198; a=rsa-sha256;
	cv=none;
	b=cafK5BJJ5y3EcgDeAzQpraSF1PBgSYb31YidzUENDD5BzTPEMwuDbDU0Ye7lhLLFJg2xDu
	nXnDJdoj5xywlLxKdDVIH2lJ9cEVcvXQHHbv3MlhB8Mm2C7NUKSHZa1MFmBO5FSjAGVLhh
	rRk1rSko767BleHakuuJ/1AhBHzlguA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762870197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z0jAePqN6TOEf6jTJjCEwq53g6vGvq/lRpJXMiEpVl8=;
	b=F/rupKDppR6K9zX5txcoBmIrRUlhPnoKC5gBG/tvEfQqpWBSlw7VQziODEsJ13BnJRx91S
	5bAzabL9o27QtmS2seyA2pfQF5z5Hp6eUFl2r+IFZw0hCURGZeWAb5AFeEBUze8zRlP61F
	PdCYL2vRH1Y7p0ss0FlatOyKz32gy1o=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-650-vw-lvJJNOaevRjFJJf1SIA-1; Tue,
 11 Nov 2025 09:09:55 -0500
X-MC-Unique: vw-lvJJNOaevRjFJJf1SIA-1
X-Mimecast-MFC-AGG-ID: vw-lvJJNOaevRjFJJf1SIA_1762870193
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E8DA195607F;
	Tue, 11 Nov 2025 14:09:53 +0000 (UTC)
Received: from fedora (unknown [10.44.33.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 19CF31800576;
	Tue, 11 Nov 2025 14:09:50 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 11 Nov 2025 15:09:53 +0100 (CET)
Date: Tue, 11 Nov 2025 15:09:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] exec: don't wait for zombie threads with
 cred_guard_mutex held
Message-ID: <aRNDrfjKQJpPNIUo@redhat.com>
References: <AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <aRDL3HOB21pMVMWC@redhat.com>
 <aRDMNWx-69fL_gf-@redhat.com>
 <aRHFSrTxYSOkFic7@grain>
 <aRIAEYH2iLLN-Fjg@redhat.com>
 <aRJd8Z-DrYrjRt4r@grain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRJd8Z-DrYrjRt4r@grain>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: 4406140012
X-Stat-Signature: c7s5wmncxt39jf4ffpsj7j8f1gxza1zy
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762870198-592801
X-HE-Meta: U2FsdGVkX1+/ZD2vd/j6XZeFk5YfBLHW9I7lsTgt1gXMEfpuywj8WT+BKOaAn0WAiOXAV5XA9VXAUeqR4U3+OAKsaH8+EZFjCF6oIxidQtiaeuFoIUE2iFYTH/Go6uwc+FiQzmlgg+tFpbh3eNR/ktWO5Iio7MoF85ApT94PIq5r+VSg+F9C+OozZXtSbcv967W8OmflMqh9tdC9O6PMjxmtRJ5TWA0lOsjLfY2hOePx5qlFxBDtWWie2duGKxs8oqLbhh4miy+1FrFmQcLWpg4dhknp6vHdsDAxNgVmM6lxbzPnZRMwDJ0rtjwq/V8i22clrPQYbwUGp12ikdx7faTY2dB8TEaRbUBvW1V1+Q+Z+74Uay7hcyhyRQiXGZfKhCLch4+hEusfiVdqg/xnNItv2sAc/LrpaKIhT0LY5/EMVittAUwYf9iepbcNfbMjl3DrvbeqPOAG9jpEY2Kq1+BV43OpEwwdWCgu0Cr+l+zHhc3bTrHg36DJNbDHa6H4geCp0cLj2zuwh/eApbEn/vaks6KKzO3BHHWgBwAC62mDyZe8JqgUDxqnADSWPLbUop4+JKfBxoReon3o5ZuM1ePrCrx0ZFi4wQZs2Jm8oPYzlTgIVztnyV3lJwMYrV9Ege0SM+HBCzLthJym7fBoar39OOXoNIe/pHtwo/W+v5dzKcYc056b0AzzItoBUO27mjxZUv8fGb7raNhS7vyIaPcSKl1y9G7eY9EX5dZBw+pIanAwIkLX/a2S4ySVGc0wdwUNyK78TKzGdXVRBj/Q4u7hXbYgoYGVchJeZdBHQMfYYhhMK57S1e4fYAXIydQJ36SKWZUz/uPhp4ny0u/2WDJXBgXAlxpN8nCn8Z8Foe75WqNJvhDEx3t1b7/lS1WQSM195UXjwVzGHEmykt9LLi7KAQn8ZmsQYRlRGoXTgZJr3cdqEe71LA+L3qOvpm4fcGfXHM/WxTvzgmEMSQ7
 I2FaOr6G
 dF1M7BUoPCgk137lksXS/MYmq+J3a6ukoIX730fiueH1z/YpTJO/aB7Qu0eN+KQSs/rEnfeJFydZO3cklTM0uIaigVSaG/dyG2jt7eUQhxjMsb7EpXRfOizX4XTfsgMJNMh1bdMQO3uzDqwmTzhIHrFoAeK5hKsJVUCZvZWubo3vczo7JaqlWeDLvztBB/m6X0UrBmTWt2w4kSG4UkzZ3gq7s9/IX7ZfYqccunxEsvJjORxzxDHgF2kS/Ja2aHCiPtrtPffeJJRzT53quRO5kCxsZhWxPWDezr91ITm5v+TgpGM1qlwQ8ktjBaAiTW1TRaj845HGiysRlqc0zRfuCZT08VU0oW7alKQHG3SuanIplIIDzCQXpW1di60G2s9WjjKC90gphmPn24iZRWiXhQ/sSL7Hq1DuntEQ/AAl3wl44sflPCQZwxMEoaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/11, Cyrill Gorcunov wrote:
>
> Anyway while looking into patch I got wonder why
>
> +static int wait_for_notify_count(struct task_struct *tsk)
> +{
> +	for (;;) {
> +			return -EINTR;
> +		set_current_state(TASK_KILLABLE);
> +		if (!tsk->signal->notify_count)
> +			break;
>
> We have no any barrier here in fetching @notify_count? I mean updating
> this value is done under locks (spin or read/write) in turn condition
> test is a raw one. Not a big deal since set_current_state() and schedule()

Yes, so I think that, correctness-wise, this doesn't need additional barriers.

> but I've
> been a bit confused that we don't use some read_once here or something.

Yes, this needs READ_ONCE() to avoid the warnings from KCSAN. And in fact
this code was written with READ_ONCE() but I removed it before sending this
RFC.

I was going to do this later. I always forget how KCSAN works, IIUC I also
need to add WRITE_ONCE() into exit_notify() and __exit_signal() to make
KCSAN happy, even if ->notify_count is always updated under the lock.

Same for the "if (me->signal->group_exec_task == me)" check in begin_new_exec().

Right now I would like to know if this RFC (approach) makes any sense,
especially because 3/3 adds a user-visible change.

Oleg.


