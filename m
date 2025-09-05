Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D167CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 05:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C3D58E0003; Fri,  5 Sep 2025 01:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 474238E0001; Fri,  5 Sep 2025 01:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363608E0003; Fri,  5 Sep 2025 01:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 212408E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 01:36:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C00D913BA99
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:36:26 +0000 (UTC)
X-FDA: 83854086372.28.7116CBA
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6032E1A0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:36:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=U6RueJvg;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=IXh94vyA
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757050585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJz2nmOPN6XlfPRfntHnHCKTk/nsiJ7oT+wmn7ndJ9g=;
	b=yxi/neGSblhKwdn4qkMLDgybYQSl09sttCNCMdoRkPA0fVomkpp7IrlLafM8Ao56RFc+q2
	bg8CdC/U68dC5Jp98uxlX3+Jtnt+Qm9aS5U2SO50COSrApxBZXCkxukcxHU7zr5e2EZD6y
	QmXTs6szn0uu0Ji1tO8jnt7xfbhMNLs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757050585; a=rsa-sha256;
	cv=none;
	b=gw4wM/Lto/6BHGAkWsd0JLfUUJB0I/TWgNVolmNZQ+3m6H2ED7nK+3si/mfFSe7EtRIrAb
	1DbVkHLzEBK5HBS670Eb0g+hvM+ZDjeA2X5UjPA6l3fZIvMQNSE6pwKWj5Zd7hv+hNIJR/
	RyodmDOtZGwqLWB79MP4q0fPmmkTfyA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=U6RueJvg;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=IXh94vyA;
	spf=none (imf19.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1757050581; x=1757655381;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=yJz2nmOPN6XlfPRfntHnHCKTk/nsiJ7oT+wmn7ndJ9g=;
	b=U6RueJvga2W0r8/6brgwvK6DLdXTlIwDtceuWCrS9SUaa4ik/QQ3Xmne0Nv9c76kpNJ1wLLK033dz
	 jUIr6IBnRFp4aN12GrixITh7VRvEPfOt+jNdeRDoHyRx6IA6FpBUse3gM1UAj9KDWGZgw6yUy+na22
	 oHjUMxjs/idk6DPy8+crvfHQJ9t8Ee2KMs+WCaPl5i97Yq3bCZ0Tp5EhLrhivNThES83WmvSaewQ9F
	 lBRYJ+0mozbtjKEpSw49o6LySGV5j0xBQ/v0Uvq37WvWSHcNgy7hU74ek+VlsZ7EjCeOR8BPgITJwZ
	 XVQcXqSUlykymAECYl9qE92NZ0JLNiw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1757050581; x=1757655381;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=yJz2nmOPN6XlfPRfntHnHCKTk/nsiJ7oT+wmn7ndJ9g=;
	b=IXh94vyAqu9+nL4OhOa0uG7cGlT7oNYUn4pQX+fiohR4ZLrmDrJ9ym7zvejDHdIytJgNd5OCCnpfs
	 +buo4E2DQ==
X-HalOne-ID: 40416bf4-8a1a-11f0-a503-81a63d10fb2d
Received: from [192.168.10.245] (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay5.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id 40416bf4-8a1a-11f0-a503-81a63d10fb2d;
	Fri, 05 Sep 2025 05:36:21 +0000 (UTC)
Message-ID: <bd3d2c7f-93a1-441c-b475-873d8d92e839@konsulko.se>
Date: Fri, 5 Sep 2025 07:36:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: remove zpool
To: David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
 hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Hellwig <hch@infradead.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250904093325.2768507-1-vitaly.wool@konsulko.se>
 <7b1ca42d-1b89-44f4-bffb-e6b09f86fdc5@suse.cz>
 <8984f395-9043-49dd-a53d-bd344fd419bc@redhat.com>
Content-Language: en-US
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <8984f395-9043-49dd-a53d-bd344fd419bc@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6032E1A0006
X-Stat-Signature: ykybipy9uq6qeuuntgfwyp1no7a5ae5a
X-HE-Tag: 1757050584-770557
X-HE-Meta: U2FsdGVkX1+cGZjKYo1jmAVt5fvD8XobS4PiVjkCs/FSlXjRJ5buxG4rqioMld7coRbulWv766ur28x4JJZ4NfxLzFPRQExc36FIuNPIUBPE8svEiTKkYJer+Z+oExQifB7tErmqZj1dDhUf7ldEIMtz1fmynhcJXYEwsvjUXVDaOSjZhh556NwlYzAPI1PqtXihQiX/deMinoQ5SP9dwi/A1FHgCUWJephed4tn/0oJNIZ3ilifOVe2Qg31BdVx6i6dn015v9Qu4cT5LDUafBdr3DfVTc6rjkRZPk8QSnwBmn/2/bkRG5glO0sND4AND/0gW77DpfG71XFko2KlrqIC3HGNcBqOTs3YVyEAHGlcdrVCRa53OyE4SLk8fAuwwewStxYxx7vRFGNYyaDNyJFjSc4QLyoqHZ0KWfKykoGdF7N+tS/zsmELRsjpVkoaHceooV3/zf33pjnQ5yHDmsHqURgULmEjpXM30A/MdxqgBjQcwsHn+49Se+cLNDDDiQTf2TDrW3BhIwe97B+S2Bsy6LeqO9LtJ2+aqWLyiYv0D6KwnyFzUw83JFi1BtLKpL1l96JPDSsglDgwfz0IjxyxZGedPo/DKvpapZY2UQWJ25MfoZgrbV+YP1CX1SVpA2l8ZOLEgs9+T3L+7o+lcZ5c0Rfu/lgP5hdVCoZmgvdPtiffrXf9+UQm37KMq11MFcMXX6+6PybJg1AG4wWffFAVInVO1dziV+/EPU5siEsQ/H1mRAxC0Nzx3mNnj5VXKF8nzyaoB7lnweybyf9sYyAp3iEg++xsluIGeSO8TRvBGip2gekpvEDnzkQR9TCDSsy3canW/h7mThKzxW7BbXzE4zW8VCuxeuXmgeJ7sk0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/25 13:26, David Hildenbrand wrote:
> On 04.09.25 12:13, Vlastimil Babka wrote:
>> On 9/4/25 11:33, Vitaly Wool wrote:
>>>> With zswap using zsmalloc directly, there are no more in-tree users of
>>>> this code. Remove it.
>>>>
>>>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>>>
>>> Per the previous discussions, this gets a *NACK* from my side. There is
>>> hardly anything _technical_ preventing new in-tree users of zpool API.
>>> zpool API is neutral and well-defined, I don’t see *any* good reason for
>>> it to be phased out.
>>
>> AFAIK it's a policy that unused code should be removed ASAP. And 
>> that's the
>> case for zpool after Patch 1, no? It could be different if another 
>> user was
>> about to be merged (to avoid unnecessary churn), but that doesn't seem 
>> the
>> case for zblock?
> 
> Right, and
> 
>   13 files changed, 84 insertions(+), 715 deletions(-)
> 
> speaks for itself if there is no new user anticipated.

Well, there surely is.

> IIRC, we did a similar approach when we removed frontswap.
> 


