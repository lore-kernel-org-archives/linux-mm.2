Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B0A2CA0EE6
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 02:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 900EC6B002D; Tue, 19 Aug 2025 22:53:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B1E16B002E; Tue, 19 Aug 2025 22:53:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779066B002F; Tue, 19 Aug 2025 22:53:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 657126B002D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 22:53:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF7E31402FC
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 02:53:16 +0000 (UTC)
X-FDA: 83795614392.19.BF74FFB
Received: from siberian.tulip.relay.mailchannels.net (siberian.tulip.relay.mailchannels.net [23.83.218.246])
	by imf28.hostedemail.com (Postfix) with ESMTP id 541ACC000B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 02:53:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=jtrroeHd;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of dave@stgolabs.net designates 23.83.218.246 as permitted sender) smtp.mailfrom=dave@stgolabs.net;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755658394; a=rsa-sha256;
	cv=pass;
	b=KzKjpL/H8ue6OzFRDCP7eebDGhDy3cWm3TALi4v/ZCYwNZFnRcqDme4komsME5ytk1uSRX
	2GXXDxegB2kCKR+qQI/v6bnUXaEPl5yXn1947tTXrk0CVD7Rk4bhH6hqAoR0wZTE0fq5Mb
	Wjrjwbe+Dfqn2yHkzHjQYy/PX0jlW2U=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=jtrroeHd;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of dave@stgolabs.net designates 23.83.218.246 as permitted sender) smtp.mailfrom=dave@stgolabs.net;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755658394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iZir/QKK5JTqAfdGmgVb/hXLInesr/tGQLazPkNll88=;
	b=5Ja1dMrFON9vLW9I8wJQO3sSib6tQcFe7Vu+awFltdt5cA4thSEUKimXb0CL8P5Dx1lyv+
	MwIXjxDE/vTGloniKQs0n3dPXdAwhjxPaRv4ZayCNfA2tfLOtLtLDg0itLAiC25oPkRJzz
	SQo3HWmbL8EtppP97oix2rZWt3vyijQ=
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id EE20D8A5ED9;
	Wed, 20 Aug 2025 02:53:12 +0000 (UTC)
Received: from pdx1-sub0-mail-a247.dreamhost.com (trex-blue-2.trex.outbound.svc.cluster.local [100.96.24.204])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 6EF568A5E79;
	Wed, 20 Aug 2025 02:53:12 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1755658392; a=rsa-sha256;
	cv=none;
	b=XM2faQq9OTuEJNEwo04eH/6Axi/dDX1xJkrb4oZd18HuWF/dAX7RdXuxBUajph4KMjxTcG
	ui9p8wnRxnxtw+r/exFpowMerR9Ebos7KUM28IGGCnoXpAfUBS5IfkzKRx+4ctRrveBsXB
	mJPzRgNZT+ZC7SjixaChUPNuqNhZcdNM1J8XYDWTd09m/aoZc9BOnDZ3fscnPW+rDnGF10
	DcNzJhauhnxBPLh7SLmFD170HEydxeReyuLQZo8jd34vK4GnibIb83uj21q+JdSgPLjZVJ
	5G2K3tT8VGS59WnUJPnT6Ld0fqtze0rcQJABG+ha/0DRZZJqHcFHZBqzlfERXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1755658392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iZir/QKK5JTqAfdGmgVb/hXLInesr/tGQLazPkNll88=;
	b=R6IWtoToKQz1gB8/I4CawnjzuMUDAbmbUdZypQY7XQHBFp60oc8E4Y7P/dlMmi3PHZ+5MI
	92ZuRDoRsrj860fBbnbrs3klsmqo6OsDHQABapRV3iTt9PKQXGXiwnzmpXwCWTceghI/dS
	7txFbg/Iv6546g1H925RGBSHGkHaTDivEGEe7oeQh7lVTRHcZD7V3Z5x5iHNnj/ZetsTvQ
	tlKqD6TKDpHOq3Qn2pDeRWALg5L5110kWXH1AX68vApbcRshK1nq12Y5IhcII7e46G/6Yv
	sk9YutHO+/VhxjqMW15l0FTfzxEVv7fIwQ1JDST6NLJOYtIIe3EowNQDEJvq0g==
ARC-Authentication-Results: i=1;
	rspamd-7dcc9cf4b4-dlnc4;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Skirt-Bitter: 24cbe2cf071be96f_1755658392800_1249402012
X-MC-Loop-Signature: 1755658392800:1048781
X-MC-Ingress-Time: 1755658392800
Received: from pdx1-sub0-mail-a247.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.24.204 (trex/7.1.3);
	Wed, 20 Aug 2025 02:53:12 +0000
Received: from offworld (syn-076-167-199-067.res.spectrum.com [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a247.dreamhost.com (Postfix) with ESMTPSA id 4c69xM30YWzFG;
	Tue, 19 Aug 2025 19:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1755658392;
	bh=iZir/QKK5JTqAfdGmgVb/hXLInesr/tGQLazPkNll88=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=jtrroeHdkHuJtsqb5l11kvf1MI9vMHXSmzA44PUngxs/RwGTt4cGZSAvff5GR+dvm
	 qhNeuI0ZNVn0oimGsMDmMMHhTd9hIHDPomPJjVHJFLe8MdtSSMIRhS7OiAW8SN4eGP
	 DsqRBGt6MtWDWPc7dGFjAO1exLJ4MBOy2SB9POuEBvqkpdFRKIQlRjQ9QfBRiJYPDX
	 ghHEi85tmIyqQK5NbHDoRbgVJYNaCIXho3a+xjphr1Z1S86DbPx0D70+9fVj73zujo
	 e5jwSxu81ikpAoBx7AT9kUcMcFRAsY3WXPhGjHeva9aw9mCv3QuAtdEcIgiKY5olGR
	 sovbvoUeJ/wPQ==
Date: Tue, 19 Aug 2025 19:53:08 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Michal Hocko <mhocko@suse.com>
Cc: zhongjinji <zhongjinji@honor.com>, akpm@linux-foundation.org,
	andrealmeid@igalia.com, dvhart@infradead.org, feng.han@honor.com,
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, liulu.liu@honor.com, mingo@redhat.com,
	npache@redhat.com, peterz@infradead.org, rientjes@google.com,
	shakeel.butt@linux.dev, tglx@linutronix.de
Subject: Re: [PATCH v4 2/3] mm/oom_kill: Only delay OOM reaper for processes
 using robust futexes
Message-ID: <20250820025308.rkqlvauh4dz42oic@offworld>
Mail-Followup-To: Michal Hocko <mhocko@suse.com>,
	zhongjinji <zhongjinji@honor.com>, akpm@linux-foundation.org,
	andrealmeid@igalia.com, dvhart@infradead.org, feng.han@honor.com,
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, liulu.liu@honor.com, mingo@redhat.com,
	npache@redhat.com, peterz@infradead.org, rientjes@google.com,
	shakeel.butt@linux.dev, tglx@linutronix.de
References: <aKIvd4ZCdWUEpBT_@tiehlicka>
 <20250818120819.26709-1-zhongjinji@honor.com>
 <aKRWtjRhE_HgFlp2@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aKRWtjRhE_HgFlp2@tiehlicka>
User-Agent: NeoMutt/20220429
X-Rspamd-Queue-Id: 541ACC000B
X-Stat-Signature: aw4fa88c1e9dmyuuksadjq6uhyixt6ii
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755658394-193940
X-HE-Meta: U2FsdGVkX1/lDCYCp/daoMWzAmpLHAP2hKSRLTjXB3GhRzqc8I3Y1V5eBABEQnzQnil+aRxXOemFeje/aoY1YtaAtFWzpLV+W+EUgDoHlnqNmSx+1Xfig9Pp73v82QVZ8y/DJj65tq/PY8esxrysaHDm6CwulNaw63a9MzDcFC9y0vWKk3L0e+ZUqhNzaf30qQs/pdkbalKt6uMsYXkRE5DN3qAxT4PUtJym5ZkOMd2JgxUeKr6fUwcyVnO2sB+voMXp7QwiO/lA5XAaZ9dyF0tBsIan+lTWVJ0OdDJp42sEQ0ozk45sfEFJcr7RYBCxcEJRp4GUFW0EIVhP+JQdTHdjqjZ16a2kZ4QQoKCyv3610gvYhZ9+TEvzC46Q8V9pEmZg8+90bAoNJ07m8vBiBPAlFdl44QRdG/Xck62Whv+8VAubLVbtwX3Ew8mVnlB8Jgiw/btnIF+XX4YK5c1R6ii4P5I4nnLYtAcIGrbXW9VNZz3hnEL34lwctFZb4HLVdpe7aidlF09eyPdoDXR2lob4yw/F9GW5M62kYj1dyAyRBgCQiBC9wlW4+M8WNrsTobztBB1ORImaLKQ5BWFN1p8DnVhH0VbmCUXUPG7GxlKjwDDI8gxgY39VK4UmXFvNxlN4NisbZkcL5tJVt+ZBgjNk2O/Ej5QaYAW2Gr2rNELnrU3sBA8kEqes3FLvYFr5O8hDkHkROKLdrb0WZDytrXyFmZkN804xef/tiL5Gs2HtvRbo+Si8UXxRQdwGiPYxCPF7orS5MEggOEIPebgL5ZF0hoOEHwVxV89riJjckfxpQhW/okUqVlE1s3U52vHCYlJiivXF0hdrY7C0I+K0mb5Nvu8ewg92FGGpLwN/ZEEGzEFUmkbH/Xox0f6VuJgmn30NTk0b3cMi1wMsgDMaXPMdVhHBv5HaaaEGz4LpYzS62u6iGDAoRFyTW/BBNjSqfQzRLRsPuKU+IE7I5za
 MkSbcYm2
 ab2wRTqQqXZj49RYY1EeZSz1JfywDqiPfOYJL2gtfBhyHyRUVXa92HjC4489M1X9MtHclDCSFKTi3UCDW/zZFEks6GyQf+U0qdSp5ulJfImPUSbyW4WqucgK7kVsh1VxEcb/8hg6BpRILVSnFAXtUl4H7KB+jUes6aPg2zGQamRtfL76GT6eYiwFkztryt3MGWmBnF5qs/lkgyD3YiTD2yUezTfova/0zPCqqI+BXsQYaPV865gxzoCam5OoQhadK7b+uo7ZkFdCWmAt+2tW1vG9PNwatyTgVhnPIktJOScyCyp9EMJO/jGnng5yldhi2nbF6bHF+s152yckDQpkP42/jGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 Aug 2025, Michal Hocko wrote:

>On Mon 18-08-25 20:08:19, zhongjinji wrote:
>> If a process holding robust futexes gets frozen, robust futexes might be reaped before
>> futex_cleanup() runs when an OOM occurs. I am not sure if this will actually happen.
>
>Yes, and 2s delay will never rule that out. Especially for frozen tasks
>which could be frozen undefinitely. That is not the point I have tried
>to make. I was suggesting not treating futex specially because no matter
>what we do this will always be racy and a hack to reduce the risk. We
>simply cannot deal with that case more gracefully without a major
>surgery to the futex implementation which is not desirable for this
>specific reason.

Yeah, relying on time as a fix is never a good idea. I was going to suggest
skipping the reaping for tasks with a robust list, but that still requires
the racy check, and your suggested workaround seems more practical.

Thanks,
Davidlohr

