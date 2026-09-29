Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 777D0C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876446B0088; Tue, 29 Sep 2026 03:43:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FF9D6B008C; Tue, 29 Sep 2026 03:43:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C7D26B0093; Tue, 29 Sep 2026 03:43:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 452406B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:43:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C09DF16043D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:43:07 +0000 (UTC)
X-FDA: 85266008814.14.24D0067
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 37E0C160008
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:43:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GoO/qR8P";
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790667786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=33XS3pljtgekiEg6Mr1oe8Qx6Mc8aJxJsqmFopwyONU=;
	b=FPmD/7XAHpqBUk+LLZgqusUonaAqJaWFhWyvOuBCyvkE8I+08LDSXa8tRXj7zn1mcYN4Cn
	7izSaJI/uBFfU4btjdWG4VG856Io6gv5UDOZwec2ClSriteI6BDeREvUSha0O+fs63jGxB
	N4+vTvy0fRBl+zA6KAsEydq0OSq86qI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790667786;
	b=6hgVzvrDh4sfSJthSypP0D+lv9AKEEWFOcG3vqUiwRNZFu6pwDOfUSOwZYvKCGY6hy4GY4
	2zIRQvAT5MdLXgDKz9woMqggAoThH6VqBrOaH5SFK2XWgqGMn886DaJLTECtlFaTL5QTKh
	FVyFQ+MoVWQ3lPRbq7IgKG5sr98gZiA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GoO/qR8P";
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB3BA602CA;
	Tue, 29 Sep 2026 07:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D0E1F0089A;
	Tue, 29 Sep 2026 07:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790667785;
	bh=33XS3pljtgekiEg6Mr1oe8Qx6Mc8aJxJsqmFopwyONU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GoO/qR8P4mfouqOU/vYLtzRNnWFHNol3JvN9wjAKgcll/AWX6dLOtGmrz4tid2rEF
	 5EIwtIGqfhRxnymTsQnTNNgBbXaufIjKDDCQmnN/e88W2v5KjAfdhIaDNCARK9rK7O
	 1DxEOviVRHmIlP7J3q1uQ0wWR51kS1lrqbyPZx3PVZ5CEKbnAuun7+dfnlPZbeMDix
	 qahHEyK8vSn9BxrixT11N7nhXuSVwqFezJZGvSfDfjKHkTbz/f65d/HJaQIlOPLb0e
	 OZeUWYmUGJtS/X869qMQpFVayiBaW5/8UMbZVQ9QMrHa56fCAjNaPhT4EcXDlIH/iu
	 WbBbemCDLdU8g==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC] mm/damon/damo: saving damon sysfs configuration
Date: Tue, 29 Sep 2026 00:43:00 -0700
Message-ID: <20260929074300.40012-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260928191332.138511-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 37E0C160008
X-Stat-Signature: 3xutfnr5wwanhcgorn748ccp43nah4an
X-HE-Tag: 1790667786-892277
X-HE-Meta: U2FsdGVkX1//x8I607is8I7FiQNjDOMK6QWB4m8pRIE6luE5ZRS7tBQSxcglPWYKuwxa8RxGSPr4e3qpRVvjqRo443iExtTSQhHsCM0FZ/2G22VlD3YQS5fSHB1YT7bswRVSP76sC+yBpr4mpky0isIJC0qA4G+aLUOGUI3yLm2fc4utB0LS+GxYlK8U9txCwTIiJNRwjjO0H4BO2FSo5cEOhVnbL19hAfH6TxonZY6GrcUXT4+e+pTZQDALgSJS8DeH10MbvBeprSIGpEcU5vEPBNmrmn214rEdsw5Srbfs8yjmklkHh/UaZBZLQiZKon6V0xhWObsE8v3E/TDHn3DHlLwWmdRcfQOFMnDdQVWoKen7AMn/ww+js7BtVmux4NHSaWxHV+0/l28oX/E1wfNnp3yAZqCTQNs4xEKAHmt0Kpp893X8e5+8LonpimvP/KcONHtO50tBGA4suoLHptItpkvaaOu+rjupUGAW8sL5lm35nDR8YTzzLlW7iNXVkG98Upi2O/bWhkMKN8BYJfP9nR7s4oNUlab8kl1IYFCQ3z99FRm3Eq5d1ebxoRX49JSnXu8fx/Xv1miMVj9zomQqFb4r0Uu8S80pzZ3UqNzRKxNOzjimZaHMnaICRgklb+xprwWLF+jcVB8xpueaQiCNaLVnny9Jj0wlZwPZr7W/h/ACMouS32V7jugAHL8CfNEfV5QAyKZA0KWIREP5mxltNMMgjDeuUOt2VttgNEpaxy0oOZ06HB4XPAxVN9dTqq7ueU27od0hwBS6Z6gfUqT/ZSIc//a+y+TQxoE4yCE8knKiVzt2LD94lPik78sUmxGc8RNkPiFOPlQSM8px6O6AhjdylP+WYPCwdxv77ouUL9FolCVWnf0woGl8TJt2SbJx9GbmR7jGRR78eXrKltPs/dufEWUETqjAc2DpYg0q4+BjkdBbvnGIGOQwzz7BWoJ3AgeGZwGf+L5HwGW
 F/l7jHm2
 UNooyfGZjA7ueFXyDn8PGSEidKKZnzOSeCdclht0fr498O8XQ5SZbPxHg1jCjLGVxJjX7Bj72WZa+PWDkpw7VbzfjerijoO+0r04R86+DgP+VsmhMKt26rBYHSdr1izOSF5I1uKq/PcxlW3Ucgjy7GsejyIaOyoCBEaeDn4NI6zCASQMtFOI9nvBtA0are+myPYOq6k1t/WRAvYcy/lwqlpGEFvK0M9FPm4HyjMXA80QrsHyVGq4yTuqOw8vDeiYHGOrz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liew,

On Tue, 29 Sep 2026 03:13:06 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SJ and Community,
> 
> I've noticed that damo [1] doesn't seem to have a feature for saving
> DAMON SYSFS configuration.  I tried 'damo args damon', but it doesn't
> save the DAMOS schemes information.

If so, it is a bug.  Could you share more details including how the issue can
be reproduced?  Directly sending a PR should also be fine.

> 'damo report damon --json' provides
> more detailed information, but its output cannot be read by 'damo start
> --kdamonds'.

Maybe this is also an issue that we could fix.

> 
> I'd like to know if there is currently any way in damo to save the DAMON
> SYSFS configuration that can be correctly read by 'damo start
> --kdamonds'.  If not, would it be worth adding one?

I believe it would be useful.  Please feel free to send a PR.

Nonetheless, we added the json/yaml kdamonds config support mainly because
there was no good way to flexibly configure kdamonds with the command line
interface.  Now it is much more improved [1].

I'd recommend using the command line interface.  That is, you could copy your
command line setup in a bash script and modify/reuse it.

Is there a use case that it cannot work or suboptimum?

[1] https://github.com/damonitor/damo/issues/3#issuecomment-5655965736


Thanks,
SJ

[...]

