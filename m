Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3911CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5D2800CC; Mon, 27 Oct 2025 19:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09582800C9; Mon, 27 Oct 2025 19:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC605800CC; Mon, 27 Oct 2025 19:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB816800C9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:54:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 758B212A3D9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:54:06 +0000 (UTC)
X-FDA: 84045550092.28.87DA46E
Received: from duck.ash.relay.mailchannels.net (duck.ash.relay.mailchannels.net [23.83.222.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id C6EAAA0009
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:54:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b=V5psUi7S;
	spf=pass (imf25.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.222.52 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761609244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2hHmlaz+cO6ss8rEa7DEhaPgSA8+zPxoNmKUdon4sxE=;
	b=DI0yT5zGpDaI1S+Cbi7Jc4dlj6wTDgS+RxmNYLhk+bOZ4Oow88RUKrr/j0kbHQWraYaaku
	nfdUaYtUWSsfIe2UWisflF/whZwAuMzKYQrhodZH5xf7jV+iq6XF6/tWcJZj+AN4AILlrL
	aSUnJqMVVUC7RwCrefN9si3r27nwXH4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b=V5psUi7S;
	spf=pass (imf25.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.222.52 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761609244; a=rsa-sha256;
	cv=pass;
	b=ZP6wbqpi1RvinBz4DN7XiBgOtzM5trb+GhKjc1nsyzmmr9Km6xUSdbdkAWgttf/9eCXNhs
	h20tbjl0cYg217clcSHJs/b0joEeKoyjH1DCS+EWXlAVoT0uoM143htpdooGvcin5R1UMT
	Xq5RKXt0JjgqljWTgI+ucZEE1dxHF7Q=
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id DDAFC901A48;
	Mon, 27 Oct 2025 23:54:01 +0000 (UTC)
Received: from de-fra-smtpout2.hostinger.io (100-117-132-18.trex-nlb.outbound.svc.cluster.local [100.117.132.18])
	(Authenticated sender: hostingeremail)
	by relay.mailchannels.net (Postfix) with ESMTPA id 5E8569019BB;
	Mon, 27 Oct 2025 23:54:00 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761609241; a=rsa-sha256;
	cv=none;
	b=rqJYtCvOCDrcpx+2JXR+s21IGNL4tnaczAC4qk8qCqvkeObLIMkYj7oKUA4LliVRD+omto
	8A2BK/J2/s60dZbHb5LN7QKVpktXLNAOyuXhqV4Ne3+EDrA4mJOlT4/Zu/fyXgXO2kRQu0
	h0G0B4JvZBfHWP4RQBUAzGtHbJmA1erLm8c6vwBMK6Im/F84BvqXFpT/UlFbf3YXjyjbRG
	dQyWQvpm6+TEcR9Gk9lgUzx7sptboO/t+6MFcidclxHEZj3OJONi6laVs0UyRCc+S/juaT
	JzHspExZyKBGGsdto55qRQVqRJQtIM22ik2W0033YtTOhQud+M+BJdifwK9Y7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761609241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2hHmlaz+cO6ss8rEa7DEhaPgSA8+zPxoNmKUdon4sxE=;
	b=btoGfdvgYQWCXN2mQe+cj94s/JJlvM0x7UJL+tocq6fxyKKZDZMXo0cRkkQZX23vP4pP7E
	8/6ClyeC6V5riLpuGDip3b9/xvTHrLyYP5+Q12zJklvPDXLgUmvh9a64p77NfSkKHBUGtU
	Tz5WkP+P39uaVfHapHWUd4sDYamJTjsw0AAgb/uv4ea6H8O24suSxfDsyFpLWNelSkZKN8
	N5BgAKhhLHzNh5fzM6X1VTk18m01iFOmBifnbrTA9nwUiCxXK9r1uI0mYjcrJhWxz8+g0D
	AjIUKBLwFE250aSNbssi3HJPOjIh+hDHng4JpextzlnOS4EOFyQcbylk1HMSqg==
ARC-Authentication-Results: i=1;
	rspamd-9799b5d46-sl7bq;
	auth=pass smtp.auth=hostingeremail smtp.mailfrom=linux@israelbatista.dev.br
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MailChannels-Auth-Id: hostingeremail
X-Sponge-Tasty: 2a24e5a130323413_1761609241797_968232376
X-MC-Loop-Signature: 1761609241797:3855391038
X-MC-Ingress-Time: 1761609241797
Received: from de-fra-smtpout2.hostinger.io (de-fra-smtpout2.hostinger.io
 [148.222.55.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.117.132.18 (trex/7.1.3);
	Mon, 27 Oct 2025 23:54:01 +0000
Received: from [IPV6:2804:d59:8970:3b00:5f26:e2da:68e6:2358] (unknown [IPv6:2804:d59:8970:3b00:5f26:e2da:68e6:2358])
	(Authenticated sender: contato@israelbatista.dev.br)
	by smtp.hostinger.com (smtp.hostinger.com) with ESMTPSA id 4cwVhj1cvnz3wbj;
	Mon, 27 Oct 2025 23:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=israelbatista.dev.br;
	s=hostingermail-a; t=1761609238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2hHmlaz+cO6ss8rEa7DEhaPgSA8+zPxoNmKUdon4sxE=;
	b=V5psUi7SswikmUfPKEutE0yIsvu2VGZ+xjWmYfqp931bUUfCe9N1zlVkRNexCtpndWJfVJ
	CRpmFL1ocRNbABJjLvpNmCR1tnTPWRSHPSCdXJsaZSrAlXuPReEfy6iLC1RmPg3PWxiF9K
	HsXwrTvgaK7TwLYPT6NOjgewy7rLx6nebbX1iPie7zK+w7fk3/rPn+LJCRlyCBFBfRnqNn
	zUP/73qk61pRNud7hT+09B0uRHAqh7CQ2LH1nVRozk1ExLcqSzZjT8XEvQ9iBGvsfce3rU
	wwLDlZjibqmDzIH1GNkTy6iB6MgDM5CwBm0OB7maXoNkaOVcPbJE86a3hRTIlg==
Message-ID: <aaff172e-8fdd-4ff3-8161-1c7afb1f3e64@israelbatista.dev.br>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Convert memory block states (MEM_*) macros to enum
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Omar Sandoval <osandov@osandov.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-debuggers@vger.kernel.org
References: <20251026162156.12141-1-linux@israelbatista.dev.br>
 <811fd675-b231-45e4-b9d5-636fe63bde6b@redhat.com>
 <aP-2x314BKks2_N9@telecaster>
 <3d3bfa52-3e13-4d23-8ef7-6cb8b1ab7d79@lucifer.local>
Content-Language: en-US
From: Israel Batista <linux@israelbatista.dev.br>
In-Reply-To: <3d3bfa52-3e13-4d23-8ef7-6cb8b1ab7d79@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Oct 2025 23:53:57 +0000 (UTC)
X-CM-Analysis: v=2.4 cv=Ceda56rl c=1 sm=1 tr=0 ts=69000616 a=WIeu/gG1zxr2CnNbFFeIHA==:617 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=a51BL_R8RzZOHhO6insA:9 a=QEXdDO2ut3YA:10
X-CM-Envelope: MS4xfGXM2iX6cMtMD4gYf0VOTxgQxMkzqQMmPBhXrc8K4Diye1+jZk1x7wGKANwGY+9urEwZMQM3ns/EtmRuuUYlLZdM3cwal165PTsGCkd633bO2GCHibYT zWrR/CL8l6CQzAPCVwfzuLVTrSCa2kuulzAi1SqHlCdjj2DaDNJ0qUAbMGB37y85D04QJeicJbIvS/81lNnmV4/IPhjUrXOSZWDPRizTuJJsZtVoKWCdFgtC F+k9uiWKETeqmUD7RetGmzQhIOGcNGMTeGJJaQaZz99x5KBDzdau2dj1EUzTa1e6fa4g7ddozP8FR1jsFonn253b38BqtZL8at/mu0fMUlJ7Iyc3VYFMm0Aj C2NKdxnsn/XnJ36rlX+vPH0z1t/mbUyExx4x4V+mgvPsgVnGJsyDgE9j6PBqT+yw5OTCuazugVWkPmEGrsKOBhazwG/fesvPBktjnb+o4Xfvl489QT7krt+C UbHuITY5+AzOiZyK
X-AuthUser: contato@israelbatista.dev.br
X-Stat-Signature: 4fb3bsxzm6pu9drdgx6h9kn4ags9ymes
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C6EAAA0009
X-HE-Tag: 1761609243-5129
X-HE-Meta: U2FsdGVkX19iDpl6IRcMrmGNuL3NaMG8kACc7KL7GiDFiCgI+W8nKWof9p2A+qgfGpgpPOzBnrVPiCgrJJcQIHba9NIlBzERmFqPeluNgkonRed7Bi2vlNE01NjV3xoy8N9bBnOFZMTAJh2gr8kXHllu7JDWBzQarceSOHflc3VloAq5/yquywZENZiVvBtTolQiygIyWoDj1JvI6NmYjCTiS0M6wv8zroaQkmE822OEImp6CNz+0u43JNUysy4kTYRhVz3t5J2zGopRNvNuFf7TE+916SAl6JCJ3bmqW6AgDMjH+UdulEO7qSZ7Bly2zrFoePRb+4AmNfu0aQfJBQmdndTXczobw1U1c12FsnH3T8qCfkn7UuycaWkODrTkx3IumWAxkxChI2UeXqCNOQ4L2ntumEWdLO7p81JPQEAS6/UUuiKy7TX4Gnk8h7kcZPxYrKvQisdkNmndbgmabFWGq28ZHxesUfN2JSrVrPwDAj5M/AbPy3TTSxBngOlzQrBfN5AhOhIP4utDS64Y3IGmt6EbMpMG7RZwvxYkNWU+tQZrro93Rq+dT5h9tCxvF3VGFeCX+rX3WvQX6w+tTm6ACSU0Mzi3scBUooITx5MY004JecZky48v80pYLtFTJ5anreRegyScW16LNmGjqGJY2FVr+gF01Zpd6fLQkJgP/hUrWUkR4Ag+K69DfOag3D2VtjubBqcJL09S1GYmYz6nLaYM3XbZdjLNdSSOrlwKrwlAMRSypC9R/TzETgHQ/yWBXB9JdZhsNivdQeqgv8jXMZrcvbNfIzpykUDiMtfD6CBK3jKZ48Hmt/s/YHbOqt96R3TWt5sDrh/hmiGRg0w6qyVOUJlwsNJTfZbVoSkkWNclp/wrDDGhLeRubPfjlxk2zaAWAvPtDtFNka+ssX6S4yR77hHmyftUhuLNDoBk05myVerDc0IqU2eF2/eq1uzsy5wf4HsSIBfrxTh
 JuR07Nr7
 Y6I0XzwpW90akcASB3zDlibTJJk8HZk73cW0WPopzgMWLt2Lw/O9XdHhJb0HLpy4kDZQcPsnsdsztruTM95nBdZUjlEpz9HchSCuyod/Kid3q+qMpD68za8as43bIekHW1ptSwAHOvegW6XCiM5OJRLyLC9qYzh0CVV9c4Q4hDU6FoIBiKV4PbT9v63kBIx42X9276v1TnhJaqQBK4u40C0c3OZ0dDEphQubdWc01x8vzCXBe7cC3uwO8eKPECw2bhdkJe72n1JbHBOT8q9eBXUPw9le/1alhg1M0YmFfrph7gz2k332Xl1RP5RrpR/hHNULOdGAXbjIWJdkvgWy7FSMhpkqMX+bStjVRQTRqIy/5XAwmd4jfAdZzv79o/ofZhQt8OSWqdhDLu/7UOKWBGyYNkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.016637, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/27/25 16:46, Lorenzo Stoakes wrote:

> 
> So why are we naming the type... does drgn require it?
> 

It doesn't need to be named, but as David pointed out, we could find
where these values are being used and replace the type with the proper
enum. I quickly grepped the codebase and it seems doable, I'm probably
adding these changes to the next version of this patch since there are
some things to fix anyway.

