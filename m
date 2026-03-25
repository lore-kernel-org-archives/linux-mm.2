Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 076C7106B504
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 21:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23C1F6B0088; Wed, 25 Mar 2026 17:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ED0B6B0089; Wed, 25 Mar 2026 17:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1036F6B008A; Wed, 25 Mar 2026 17:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F3D4C6B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:04:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 963AEE0DD8
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 21:04:10 +0000 (UTC)
X-FDA: 84585813060.20.A7530B0
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7984EC000E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 21:04:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=d+SBetD5;
	spf=pass (imf10.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774472648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=97Z41foFc+tZXOntpL6elWdJfICUWmGkxy05YMBEDcM=;
	b=Z/Uf5npDIyoAMe4Ls3DXdugMnAZ2qq+Jis7ibTiQVztmdlPZVQ6zfjyOAvpwqnN0rK8vZC
	2sKy2HNow4XbsHvSHgkmTpgRKeHr6L0ey4Q66we5GVpKlkpJZhEg29aokOqh/TB+OTyH37
	np8UR9qN5bHijdanUlc6Ru0FHRXxUgY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=d+SBetD5;
	spf=pass (imf10.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774472648; a=rsa-sha256;
	cv=none;
	b=huTMk8jqKXkWVDf7topGG15CCocsflAIOWvQN12SlwT80njhs6NWLiU9lsC3FiPX/QZjKx
	SzwyI3705LofAVvM5kczyWAFMx9O28baixwKUd/9UhvFFr3o4xcixYF4j+HxQxHPss/47l
	51wNr1giuSgBOvYqT6q1l6kZO0Alb8M=
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fgzsy2sJbz1XM0nj;
	Wed, 25 Mar 2026 21:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1774472628; x=1777064629; bh=97Z41foFc+tZXOntpL6elWdJ
	fICUWmGkxy05YMBEDcM=; b=d+SBetD5T0ANFFheTW1fVKWSFv622BZGQ6g+ZEyE
	UNlC3HQ/P0Ll2JB997Q6LcPJtI+v0U1Clqwcx1FhJR3izYI6raLBgB1ccBDpql9t
	SDsR2f20v2xMEnwl7XT54GdVTWWDvNYTSv0vTutu8ugaRgu7qeWcu9ryU8tlZaiM
	RQighKsSFMsM51W+FZM4BSWFc1MifYA5yFIdIvcKQqOvkbzyWC4jlEIZR2qMwknu
	Lftj++TFcm7/uLSgSjaZUhsBBP5nLMq8N9BuXEWTMmmbMBrjtXdBYQDgpEeH90j/
	wJoddw+Wy4daftuF0ePYNFACEC9w5GPMp1Ze9+4w1dZ0Mw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VRWQ3mJKAFHd; Wed, 25 Mar 2026 21:03:48 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fgzsW1yFlz1XMG4r;
	Wed, 25 Mar 2026 21:03:42 +0000 (UTC)
Message-ID: <8f554173-4864-46fc-85e0-0a7f3ca70210@acm.org>
Date: Wed, 25 Mar 2026 14:03:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
To: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7984EC000E
X-Stat-Signature: jh5bqqx9tj5w5gwo5g5xpun7coesfd31
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774472648-958113
X-HE-Meta: U2FsdGVkX1/3mxqQkIA3BXlM1eFzOZaA2mtAUfcLnmJyFgMLjI0xNQpmKZFM6rfNzh7bhvwiM9V2W99wy7OsWXjFbhihvB42xZZkBhHe9T5mIJBdJV7ItyT+yW1YeGlcOf2jZwevur71rHOOJm4RZqidCvj7ERLQ95HJjl5z0A2i6U8xyI/jlgm2JtFMGSRdjJ1NHgGUVb5SYucCF8NbLqds+EdSHMtf1wDj3rrBG6qMcsmbFrwUglP7LmS87fgUT1EPMEJEPhVF2pWD1zFC1wiJwbmMQ1arMlsVJ3VSzDsDl00WXWAGf0/hcCtpy/HDj7jh+rVVX6CvyNB5QJNNaqrHldmC+RfQbSjUIJufXQtJEySN6UK82HNNFlyUfLQH4FbHEI9rJJlNlnkqq4Sht+IcOzI07r+OM0Uj/ude7NpiPJYuAeUa3sSSdEkCWQ5NusZ/MuHb1AKtjsFz+E9pGanlc43KuE/HDuEA5WkRfRk6NlRr35n5xN5O+OjfgCny/tPeE70OEvGlbyK9FnhTdmAvwglagZL08UZhZXSGYovA52tm8vaNF1FUqeb7ZvMDqwLqdj8u8pW4DakkAP1tiK2ZNx7zBceqR+u5Jz/ACA10VZQfDNsZ9wkEeyPYOFY2NnevdV2zYa6FydyFvsHJ5DTuCrANMaKPfLjjNPwpMw00LadEzxqpY/tQX9EbKFlYXJjDQYbWgD7HhJE/6JaDZY+e+1Eh3mg2ZmOyxvwBUgN8ZDHCn+Z7WY6f7QFTfPi3QzVeelvifju1OyTiHuLpmbBaTjdkQWzDd5xAuIJgSv5S2ow1pTv7oREp1yKDfUCPt6EXjZ9mGhdsLUJHL5oiXdmRQsoieBJna1DOhjlW5WqNirykeO8935BEQMTcN45EFwrLvG3CfArzhlJ8F5xZN/4jo7aYFJfKmWtB4n3qeSr2uS3M9ZfZ7L7p3ynym6jJOukgD746lCLruy/z2E6
 mTHFf//D
 OQso+uWyC7/Mvcr5Azm40iBrZuE+67FYbBH7bxIwzRIDFxGllkSVV679TdFQLGFca7mk4BfRV+lkleOs2vcHWLCTcnG9gVOqL9FuKNvkpl2ZcuUurMiz0Uj5tW6IVEGMKtmDIG+1kmuvqUpKV3OK5lWQqv4Iw/iXl7M295MxzV7CouOEPbLHenvTVXzD3/Ev8hLpmMzbq9PB1XNb4NzVMB2G/NM6VvoNPvfrfDaV2/e6BjO7hsJ63Qe51oeo1L1jznDWsIgOwof0KVYW/e6Qt+JGphZGH8gbwdWKfuFu7NLx7SHjLM3HMop7F+NquufQ+zsBxeD/8UopETw4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 11:43 AM, Tal Zussman wrote:
> +	schedule_work_on(smp_processor_id(), &batch->work);

Since schedule_work_on() queues work on system_percpu_wq the above call
has the same effect as schedule_work(&batch->work), isn't it? From the
workqueue implementation:

	system_percpu_wq = alloc_workqueue("events", WQ_PERCPU, 0);

[ ... ]

	if (req_cpu == WORK_CPU_UNBOUND) {
		if (wq->flags & WQ_UNBOUND)
			cpu = wq_select_unbound_cpu(raw_smp_processor_id());
		else
			cpu = raw_smp_processor_id();

Thanks,

Bart.

