Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A340E9E2E0
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 10:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66A986B0005; Wed, 11 Feb 2026 05:53:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642316B0089; Wed, 11 Feb 2026 05:53:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54E426B008A; Wed, 11 Feb 2026 05:53:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4654F6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 05:53:54 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E37551B3664
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:53:53 +0000 (UTC)
X-FDA: 84431865546.17.7F8B07D
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id D7648A000B
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:53:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jfSIfQCz;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770807232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kvmAg2kqzfViwumrS5M3A5Undk34/pw+oV9Ro+ELMA=;
	b=iUKwwHG55uX7siu6ckZgCku3av4xzM504+XOTY7I3Gp6QQUXlsqKyPUCZ2+IpQCnyahsMq
	Ixt4nzlBuP9R5eW/hbXYUOr1iEtFg2lBDcSceuQ5K7CEyVG5h1HMU1jgN4LSR7LbgH5LQH
	N1jBfw3VWidWhLVnu56F4BR14DV5gEY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jfSIfQCz;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770807232; a=rsa-sha256;
	cv=none;
	b=FzFlHFg26RxheLil8TT8ay5DCSo4Kz4L9Qjr1tlZbjeNMKdAcGzwyJXRkPW8RriSg/Mwa0
	H93tUErn/v+8+2WCJbb8irhZYmux5UOPCHZWzZ06+JAVAPnplP8VBpIuzDFwzZyWrRzQoR
	PqchEGTSvW7iRHU3jOuxOQ0TFbja86I=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-59ddf02b00aso7769452e87.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 02:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770807230; x=1771412030; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5kvmAg2kqzfViwumrS5M3A5Undk34/pw+oV9Ro+ELMA=;
        b=jfSIfQCzQ0FGldQYAh2y5G3dArzI6F8nGQfF8T5J9RDHd2iZPxXGnERMbR4VLlKyGz
         wJ1jl63krvYF0kbkysWGRN7KhqhBeydsx1HUZ4rjFgzlXr+WOm0q/BT3op0JLXxfHAfU
         SCHZytu/6Qm4u0CReKiw5/XUGz59Fr3Am0FDVAjTjZkxDsVKf0UWARcWZckRdh8+f4Sv
         pKgL033FdlMxnpOHJoI8DmirdIlYJB8PJ0wvlHpdm56Zh4XLQopaSyOTy813QDRsc3XL
         4nFU+gJH7CKjFktFlUYpplE3bzYPiFMB7q2yiLXfvz8YxnE2iFfXn4e/jOTT644SnyRq
         i2KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770807230; x=1771412030;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5kvmAg2kqzfViwumrS5M3A5Undk34/pw+oV9Ro+ELMA=;
        b=KMf0LlADWONtPST/DJVL60ssIzKUAHa15OFVm73vBs9pDEAhl2lAJ/FKP5MdUXpHhM
         XdyLtDLiuAM2ayGS4LxeR5VRRlXzr/ws2tgE5am0xyuyPa+5nbdbsrwu51E9JkNx+TSL
         9ZU0+OdDAytRrtu2q7shkT1jKtW94EhfBEaTOihb1vqG/naSadAJuNgqZFOip0e+v7XK
         UO7wwE3kazK/JG/UdB32CyOHCamnjwFrdDK3RcUN2z+Gr+w/rPI2AmSCdXwymwpX2zit
         AS2q6y+1oPQZmXbrOe4EbPtQ4OFuwW1rfaLHDVAqretHtqjGdCn891kJBNPvIaHPevGB
         K9Ew==
X-Forwarded-Encrypted: i=1; AJvYcCWgVypqD+ePFdNT2ajmH2pQqxXOHJQKM2/d2nbN18+5TY/xCJzZb9YFRzF5BTzTx8M69n5rQt7JNw==@kvack.org
X-Gm-Message-State: AOJu0Yysz+fb/F2p+H6MfXZBDTrstuM3GUXFjHXL0QBu85XyADYQbxVJ
	EURbQpzA+9DX583KMHd7fLmWX8e/QvyjXSp5fyeqrq55RQlh99Ivib1c
X-Gm-Gg: AZuq6aJpaY3XxfyTv4/Fm3GGw6jpqzC5QRasf3TBXJJXuwWtePiOoKfu53HkJF3dpzZ
	b1ENkUEz1hZuASJroXCHbAq2rC3p2M7sFXy9ssQOE2HdN6yXqdb+EboZ4E/WKHkH5/5Ws6sk2Az
	aMyV3vhDVOk07vHcRWQXALGKKMRRTriXnqajgWOQyHOEYvB5I4cnLBRp0QtDQSLBwhBBB9AHKOk
	q6LO/E0/lSw6WZqgSJG+kr0F13maUNZMt2elog9UtWV+HS769NQzOuKy8HM7cn58DlU4YRjE2v9
	5lkm5Dk7vjxKMLnA3iEfEp8PWOasUTlqY1Lfz4zYUBh5qLgts2z0f4yoV/O0KhRXIiykMC1xPna
	IYK9qwbxqcgddnjAsibPoyvggG5AuL35XKYuKYGI3YJl0kWjX6gF9jE6EXGmZ2XsfeyzQTOOEqx
	U=
X-Received: by 2002:a05:6512:3b95:b0:59d:eab0:c836 with SMTP id 2adb3069b0e04-59e5df4670amr507151e87.6.1770807229920;
        Wed, 11 Feb 2026 02:53:49 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e5f5a50a1sm267273e87.57.2026.02.11.02.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 02:53:48 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 11 Feb 2026 11:53:46 +0100
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Puranjay Mohan <puranjay@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Dave Chinner <david@fromorbit.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
	linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 1/7] mm/slab: introduce k[v]free_rcu() with struct
 rcu_ptr
Message-ID: <aYxfumz5IlwBDS4n@milan>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
 <20260206093410.160622-2-harry.yoo@oracle.com>
 <aYxXE6CC0XQr1KNK@milan>
 <aYxdleYc7_TWj9To@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYxdleYc7_TWj9To@hyeyoo>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D7648A000B
X-Stat-Signature: fjtyxwmi4z58qrcy7k77zbhhoa4jkse8
X-Rspam-User: 
X-HE-Tag: 1770807231-865300
X-HE-Meta: U2FsdGVkX1+ntAOLYdvaU0VNNLaveEwR79G1vyF6dTeukSBXEVJ+2PWkssqf/RwaCxBgopNNvvyR75bq4kRwNFbzFzMPTkJy2VVVPBe2BS9xU4jnlSWiAVmjSd+ogO33wTlqW7X+RPFvl/jRndeuB8yKj+vSTxARC4z215N6MwxeWBPVcxpZexPiznTCSHZlor7Wsw6l726WtgWluLi6ET3oHsPUgTvVnVsT2/1Me6ISqFi+MsU9M5o2JNM5RUwjoVxLx6K2KL/Q9OvbQkcJIX/oreao9CL/xpvjvR5KmxwV9YRMbwjB3WFEPoqWRJ7yJj/EdrOAxVAQm6eW4phoRp7agyKi1l4+SBlijhmq16/BLCl4OEUgtR5PqhWdC0MXVnjAt4meHFRNEOdXuPRBCwDkn3hdvKRdSWotfgNntRiqO94nGzJoSj5c43aORfTp7zDDBVi8cMYzU8D9SiWw1fx4e7xajKqmBKScOxzmRv/OsCwiCkGwzgLsY0JNKNY4PfKpwBd2TImD635tYnIEN0IYXV0YdQWtViNQi3eiRIsCT3CoXBtBwZDLimdWiDzTzPFjI60oKpGk0fxPB/DsdQbpf2YKHvh75HHhSQIc5ijl3yLzhd0LtSe3fy7cuLbDkJ/07rinGtjqvV5oGFQRBBnIpfa0ktI+8LAIZfQ2iTqjMY3Zd3+OV3oNBcoND1DfLl2Hm6+0461g2ZJc1rHZQ2vhEXHe21zD89ATB6z07Goien1gtYcW42kjnWBqPMW+NCDlYXo2BAjK5Is57Cc2o9uxoJztG7GMWkvubT1IQCnLGDMzXCxRYgHnM1QhgihbeO+IobLdcXZ768ew5nmPgYDxzvxoNOai5rUB5cfl3G6y+x0F7OlHuppWTbEc7tTn15wOAEX2TmcSgejOJd6Tu1ZLLxpOtvVM8PVt92igeXnmooy/XXYvpGjVanrhoPZ2IEmCXipbmCkz1npaxAo
 JgXH+HQQ
 PVuJE+Mf7YFAaA94ScwAlmxehO90/QT7rjeayy7tMRhNV66q1QJWkQZ+bDBMJ8adJFJ+67c3hXrclUTySUM8X8YDIMb9LXhbusVGwDqsDq6xxrUMs+Zqds/KCh6xoWNf0B7qTZjhXK+5MAlUTVChVQDYECG+HGLpqysU1KKH+DkuNapZCk3jyamMPU098E9557wRjo0ShMfTcL6XD0ZY2RHh1F+89qaPPQ520TYX7DZpVBri5XL0kBEZ3ftwd3Q5xiDkB31WmiN25hopO4UaaN3nF83iIcHdbyI/X1tx3BotYYb8SkJZNzwb/q1zK2bg4wnr0mm4LE5j2i3xSzlQdiDFRrY/pm35VrWCgCOBCV/nDaYmNm5BqGr0N/KLjMvqg3Xsh5YoKlPSRoHtayOkIajza/5KRrFWg+7Abfv2U9BJGPBjA0IQkPnuFSqawrj7yvt0ETizJry8J7h+dHQCyn6HkrWMBe25LDM0fOCNCJkKQh1kNhNoIyYgzSx3JMZ9OA6210SsizSP98AqvzrYU6X4dOwFPATSqtOKqk0vRbBJGnL+XMtSoeocOpk8lUs+GmyFu0DBO48o6ytjJhky7utyyfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 07:44:37PM +0900, Harry Yoo wrote:
> On Wed, Feb 11, 2026 at 11:16:51AM +0100, Uladzislau Rezki wrote:
> > If this is supposed to be invoked from NMI, should we better just detect
> > such context in the kvfree_call_rcu()? There are lot of "allow_spin" checks
> > which make it easy to get lost.
> 
> Detecting if it's NMI might be okay, but IIUC re-entrancy requirement
> not only comes from NMI but also from attaching bpf programs to
> kernel functions, something like:
> 
> "Run a BPF program whenever queue_delayed_work() is called,
>  ... and the BPF program somehow frees memory via kfree_rcu_nolock()".
> 
> Then, by the time the kernel calls queue_delayed_work() while holding
> krcp->lock, it run the BPF program and calls kfree_rcu_nolock(),
> it is not allowed to spin on krcp->lock.
> 
> 
> > As i see you maintain llist and the idea is simply to re-enter to the
> > kvfree_rcu() again with allow-spin=true, since then it will be "normal"
> > context.
> 
> It tries to acquire the lock and add it to krcp->head, but if somebody
> is already holding the lock, it re-runs kvfree_rcu() with irq work.
> 
Check no_spin on entry, if true, llist_add, queue-irq-work. Re-enter.
You might need to set-up interval to prevent frequent bouncing.

--
Uladzislau Rezki

