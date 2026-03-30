Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5169010D14A4
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:45:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E3E26B009E; Mon, 30 Mar 2026 07:45:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BAF26B009F; Mon, 30 Mar 2026 07:45:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1686B00A0; Mon, 30 Mar 2026 07:45:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3A46B009E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:45:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4355A140758
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:45:19 +0000 (UTC)
X-FDA: 84602548758.16.6177179
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id 51C1F40007
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:45:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rnMEZv2Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774871117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kTACHKzRTTQTHv2BeEVVc+PV7wXJkipQOVm/vndnvSM=;
	b=WuNI4gptd4X8qUuJ+xuyM1ZGEPEiI0mQhS8cyjABPOKxh9BR0ATV8wdwuwKkny2G/+Qzl5
	wx023Qz8ISKrfXI2GXpLm3q2x9I8zIaQEmqZ5h0xpi25gh8RYfjxFlMyyHixjNtVcLRprj
	otBiXArLJkBSsCLPsI+8yYbGHminesc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774871117; a=rsa-sha256;
	cv=none;
	b=3EvhkZGX3Q5TOgeJFx7G4Oec53vOAonjfgbXjekLwnvllOTzBhKrb+t0BNWCfGYCMwHnT6
	fkfxiTwAzO0HbEKA85Hah9h+LZ7VWb5IvihwsvJ0NqMvH3zN9XSVHJMw6VpahRG0S50Cg5
	myZf3sH8+uClOmMAGle8Oy+B1qPRTkQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rnMEZv2Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=realwujing@gmail.com
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-2c0c955a481so723460eec.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774871116; x=1775475916; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kTACHKzRTTQTHv2BeEVVc+PV7wXJkipQOVm/vndnvSM=;
        b=rnMEZv2ZX2Ith5BIcHtgBSfWqiwjLe8YeL7gCbDqsq9rx46xbQ3qddELl1Ug4aRehw
         ZKQbBgiV5+eNa8aNwnGi3sgKpPUhR880vyOze7S2nmGpmZCRLO7D/9UdE58guG+KC0lk
         NRjNAyEaNPZUT2A3nmMuQmgBwp54NM8Q4l+PS2ljCMBHyo9N6ybpNxUS3kw9dfIu/nuu
         wS+uoXdV1B1PKOcwLIzRutOdVvgALA+i9i0gAHVrphgAn9K47w4aznrZstzKsPapgGAV
         2RhE76KQ1KulP8UgC9FhTxjlCS3H4pYS3yksdmGQW2E0E76OopFb2cnf5eEMOupJ09Gg
         g3hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774871116; x=1775475916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kTACHKzRTTQTHv2BeEVVc+PV7wXJkipQOVm/vndnvSM=;
        b=pUmSci7YMCbguCg2n5Iw3Z9PTZYMkNMvxwoZcGPXC45RMnzGMabFEJhsgWmSMlfHqJ
         2BqDjjeNxuuFnZkzQ1ecCOqtVgiKtJl660r9gC0fkajz/YmVST/j2Mjh0Uz7IieH2nEk
         B/0ziTYmGezHZR8jSIWA80GMw78ylGX6ONYQIQti4sHNah+uDRegPEob4TJ3EmH225no
         FkSaOT277tDvkbU1TRQkS3SMgR9rq/xdtX8RqiRFqKmQ1SncaooZcXZAHjAMXq789Zu1
         wZaWpu0Z4/9h6kGCxpxVEH9B3UaeV1aqJ7+Eyq7D8Pykj/QDAqobZtVdQyvM/yjvseqq
         HtGw==
X-Forwarded-Encrypted: i=1; AJvYcCWGtcQhfmpGNbZmRuBZhgCpEBnP/565NAi3U0dsLomu52w+jurc8SGryAvxJHKmHFbGPsIlG4tAlw==@kvack.org
X-Gm-Message-State: AOJu0YyIrHZ1Bn+shIF6TUrZl1oZY0Fw9fRqS5+ZFtZRARggx05/SRXE
	k7g7nlqE/bsP6l4qOPPXhDwlouWbjWaOswg4i0p7q4Th/Xp94c6BVO8/
X-Gm-Gg: ATEYQzzVCaDDXlGPRXcA1mGJZjbmjXpr7sGeRjVYPt3LbccvXmAPLBfUb1jl4YU5k7G
	mLR4ZbqNo/OmhL4lxsdc92QmVqwLCdgI7SJXdJjypQW1qgU9cSMkyZhecEp9ky9hMCjUc47d7DF
	1gQVHeD3R0FWgrqmwy5GsCfYqn1VOP/PRuZDj1xJojJoPD+nh054amMvRdLLY7o4Om42yPW92DF
	eW5TDpIZgGxth0WRAU1ZZIAXE9yegWnl6qFb6h8ikupy9eTw8cxO2HH2tNB5QN+sYh1Ag/KWSSK
	lDdLqtU2i41mpiMRezmDB+ZdsLHJI/j9EHdh/xtjK6bZri2PjxWGoUDxzEQAlf2RXgT4dNU0oOY
	00eFGiKyFKBuzlYtVgcrEPbiO5MZKi1AXtfu6h5+w1j9d5Ns5QyxXkRWX74+Im2EJhRhf3p/YqQ
	qyerShhjDFj9VEPlqwDJ4E+J0BdtiTxncZDTg=
X-Received: by 2002:a05:7300:dc90:b0:2c5:a6ce:e534 with SMTP id 5a478bee46e88-2c5a6cef339mr2202718eec.8.1774871115888;
        Mon, 30 Mar 2026 04:45:15 -0700 (PDT)
Received: from localhost.localdomain ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c3c41c1513sm7056897eec.8.2026.03.30.04.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 04:45:15 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
To: peterz@infradead.org
Cc: longman@redhat.com,
	cgroups@vger.kernel.org,
	akpm@linux-foundation.org,
	anna-maria@linutronix.de,
	boqun.feng@gmail.com,
	bsegall@google.com,
	dietmar.eggemann@arm.com,
	frederic@kernel.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	jiangshanlai@gmail.com,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	juri.lelli@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mathieu.desnoyers@efficios.com,
	mgorman@suse.de,
	mhocko@suse.com,
	mingo@kernel.org,
	mingo@redhat.com,
	neeraj.upadhyay@kernel.org,
	paulmck@kernel.org,
	qiang.zhang@linux.dev,
	rcu@vger.kernel.org,
	realwujing@gmail.com,
	rostedt@goodmis.org,
	shuah@kernel.org,
	surenb@google.com,
	tglx@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	vbabka@suse.cz,
	vincent.guittot@linaro.org,
	vschneid@redhat.com,
	ziy@nvidia.com
Subject: Re: [PATCH 03/15] sched/isolation: Separate housekeeping types in enum hk_type
Date: Mon, 30 Mar 2026 19:44:48 +0800
Message-ID: <20260330114448.103086-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260325135904.GB3738786@noisy.programming.kicks-ass.net>
References: <20260325135904.GB3738786@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 51C1F40007
X-Stat-Signature: 7i9w4r4azyfkbycamdfwxrqboskabmmh
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774871117-928712
X-HE-Meta: U2FsdGVkX1/PuVoaNwBlMHjKByCObxvz75zd35rRtlu47JCSclr6JlwcXZhpS5ePcbHi8+U68GwlN2RMyE7+F+zejY9rT6DUOCY2b6BctOkR9TKrilF05icz0fc60PC05NdIvblgCE3snb8TiM14i7XogrZgEyrjqHABY6iev4CPAxCYDc7LwKHeLHlGbkJqnW8O+PVn9GnLG/lHH0leE7R3s3Sy2UCjcSIkzffmNiEJOHTSn4nsidLdWF2WHmYpAhkHLuHSMiWKzdXLqCXhWrFU3qOKGyIFW3Ccuhly4vY1peN4xmJDGVG5U3w2agODDe8CFgG8YJh0/MJmKDZZzLHwPoHAoeFvBq4CRhcylSNi7q77B6LddQyhhIVscHXIYgMCX8k3IFGiuP0ROcVMxjClcPKmjILl9gDFo2GvEUepYyzuNSpgyRc3hZZ4/+y5CrTo+kft2bHB5rptH/vGuEv4+kocRMlzuETDbQlGnvD/NuD/WXXMB6gjjzEVm0xlDDq25bAdMSqEDpH0Al2dS+Luc0zV2EYF464gO7hipGEsFv9B1AmHYFwTEQRFIh7yYCITndkju3xAeb+rjYezriWQ7gTLrZOIAeAsA9gpY5KMA/60ERmfzxi5Duoa2lX5OvEnYve9ePz1K9TsZnBLO4je+WbJGlPaP/lBzMYoBwePnyaqVbX5tF0u7iiAqDj4o3xLBOKvsHEhYgiCQmGIjtYhoqk/BKgtmNLcuDQO8QQ0S2TGJSM6hYckJ9y2YKSXj9CqT36uMArAHK8crHZu3KaJ/OyqZijFd/gwydDdKj50B+bHWXg29h9ryT1dASC1qGc7OEWw+oB7SBTStI9H4MH7r7Kf3TqGThf2cIBRcjASuoz28LqtxDs8+rwXhTFteEWKEysf2dFSWGsmt7Mak4thFAt8RYfqNopP/nR/Dv94IR2YXs8x7KECTl3xHZHyVzf9a5S3uIgYUAryHsj
 Cs+H8Rlf
 uzE3Rm03mocAFFc60rmKReijnHMX5ThRxbMhcqtMhihBwn8VLZ6BtRb++/9d5GFr2ESqlr/bYY6tzLg+I01QoAQTyLlk1TUEJzpj4IQJXPzwfgnoHv7W4wClk4NmN9CMoS4rpFxJJ4nVADEXm3/apQugc1aA7/JoY1qOiKibVW4umFGq0XMTuZHx/96Y9RJbEs9nEG9Mj1zLXQl5ZeKcAbDXOp4atRrdeQvdMMnamNzqWMbtyjdzOhp0hFP7ki9iAwrod37a/bomHdBX+7fYzbETbvCXvyU5dSjykKvPyL3wJfGbM77maTSJkKr5RXH7aPYGIni6RQktx0e5rkGQ6aVauADC2nRRuuDn8OHSreN6NW6Q/6wOPqtjU0nWuQajp5rvKG+4JUXI9sIBjAzWW8FFzwq7NBdvr/eOgmE9Dv/EWjEC4P7nOdCPP+fa5eATI61pC+vlAoVCzU6XrXEFAc0AGEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 02:59:04PM +0100, Peter Zijlstra wrote:
> What the hell for?

Direct and to the point. The original intent was to allow for asymmetric 
isolation (e.g. offloading RCU callbacks while keeping specific timers 
local for very specialized real-time monitoring).

However, I agree that for 99% of use cases, this is unnecessary 
complexity. In V13, I will consolidate these independent enum types 
into a unified housekeeping mask to simplify the configuration and 
reduce the "insane configuration space" you mentioned earlier.

