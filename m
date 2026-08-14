Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D897C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 16:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4686B031E; Fri, 14 Aug 2026 12:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28BA06B031F; Fri, 14 Aug 2026 12:03:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1946B0320; Fri, 14 Aug 2026 12:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EFA6C6B031E
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:03:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E01EC12014F
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 16:02:58 +0000 (UTC)
X-FDA: 85100343636.29.8C540FC
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	by imf28.hostedemail.com (Postfix) with ESMTP id B6E8BC0004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 16:02:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=sandeen.net header.s=fm3 header.b=M546g2yL;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="W uuhVAH";
	spf=pass (imf28.hostedemail.com: domain of sandeen@sandeen.net designates 103.168.172.154 as permitted sender) smtp.mailfrom=sandeen@sandeen.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786723376;
	b=jYmSmeNaleEJQSQ2FjPHGkvpN2ZeUPvRajSPdKtnxsalPjSElS2kv5JSSN7oJbBPvD4Yf4
	oLtKczcdA6GAzNcS/S87w560SmFkOdF9vT6cWYxYujN/157OAojIm+r3pzO/F4yb4GBfVd
	hd9Iusktchso1Kw/zXZeigyfbl+kvls=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=sandeen.net header.s=fm3 header.b=M546g2yL;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="W uuhVAH";
	spf=pass (imf28.hostedemail.com: domain of sandeen@sandeen.net designates 103.168.172.154 as permitted sender) smtp.mailfrom=sandeen@sandeen.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786723376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYhgrRzRiIDaFxWxjzhuwe8vWvGHjICrQiW1FTBvt1o=;
	b=DV3U/A3B5k/VxlS04n+fHIdnWHFfpQnI8QqQK2XCjGWEvZv3olMu9B21YviqviCpS3dErO
	UD/AHA833U67KA6qngHhgxujugvSQ15rN2YN7+AHmkRro9OnMwZDPoz1EmYDR3ccKdtEpg
	mzx+MO6a5j87c1ymqnK5zGUTxPxG6fE=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id BBD7314000E7;
	Fri, 14 Aug 2026 12:02:54 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 14 Aug 2026 12:02:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1786723374;
	 x=1786809774; bh=QYhgrRzRiIDaFxWxjzhuwe8vWvGHjICrQiW1FTBvt1o=; b=
	M546g2yLPQlqws0FGycFZwSzWMP8IqAAd/HbHHbXF2k3AawrOcXQ0Qv7TUaNQ8YV
	370FQH7SPZMVMzX+5qawmLIgYtmXvOApmH0Co7uF2sRRXxeTufp7rSo5uTRON8gK
	4HFyGgRk+YCEWvXgpJw/Hox9J/WBZk+GVz1LsNgMKPLe8mC7xmbj/ajPeu5iPNxa
	gY9o7z8GZNgb5muL01NgDksMVIpS5U1rh02M5+x8UpsZCFTsgOOmNRqr72ZhRzAt
	7Nt645kjl8YeIpV2GdQvOHDul2otdnfSOOwxfyAU5z8JJ/mWM1U85bKDLF5d6J2w
	WUZUUWZlO4szMPSFQhMghQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786723374; x=
	1786809774; bh=QYhgrRzRiIDaFxWxjzhuwe8vWvGHjICrQiW1FTBvt1o=; b=W
	uuhVAHUoYNMDK/0sGCf/BtQeWReCtDKjbhfXOMwfvKzvWQoFborrItm+eMKPW4YZ
	ZI3N5g/JFGxYSH7vbZcOzcuOwHsBX25ST8XDEIXPhNnWz7mIq4c4+xzl+2StTj7j
	Qz40GwamCc/WEMctr8XlWnaMkdAMJbZTU2zgOKs5+UGXO80pKC62Y42Cnnp8oZ35
	+ZAyeGQnp4vOZHUKN0y7BMuMpQvX9JV/kKZWpMHOqpg+5QbCS2xHHPVQ4S1qBFqD
	TjILwczbg6d0t755CfrY6DkadWH6HuZOQOkJLu23DAVLVDQ4ZlUMfjU5OzuGKPER
	iejwQ0/sacIHMUZkCzh3g==
X-ME-Sender: <xms:LTx_ajZ6FpZMX5Y1ecqtdIwZL3zoMELPlDUVrEp_I8eqcE6cBDUCcQ>
    <xme:LTx_amHOl46YznMCvDUGdPmvI-2Qk213W0cAMP1YDvOqK9-nOFirD-D_TbbXxueGW
    9ECSjIM_SG9WmD-nc3jSpGZwr4dl6Q8w6bk93817I5DSFuIUXEeYYY>
X-ME-Received: <xmr:LTx_avxfPcIJG3CatH2CeApsrKVAfPTV7BdfJQD8Ux5ZB9wBpcjkbga60LzlzFEBXIMoI7mvrDiyJIx_mdZHKVjN>
X-ME-Proxy-Cause: dmFkZTEC8hCadkRPHQJjEAY44A1Gs3XQA2yBp0wEpE+gH+Ek/olIlWLwulayq+FXgWuxUL
    jX7Y+AoEWkVUAgkUIbuyNiUUzCoGfHhAP9bDJHn94KrJ3cbFQ/0FIWmdq/AUqqN0o6nyPj
    7sjEEDHIpHZd66OBspZd7tjWc2VtEHfNcp+u7iQ+SLbW/wf0ng6VKnGhMVfoHA6FVabTtT
    lhlSjdTMaWL4zlQmm1MRWXPfX7LcjM30nr48cx7jIdkdi6Z7DMSIHa4Or5oxGj6LkZnnOF
    L72jHk921KmBzYLle+dr2NjVyFGLdmGcKjrigNRY0fvSEL5EwqfC0NKiSAQq40QQAIAcMf
    qEGRi2k329UdM8FJmITYpJDlDSbae60ECXdgaLOgir7ErC/TtpYgvfCkWIhukktw6Q1xAZ
    qVfPQ1ROdiHxY6MvidEd+pHoMo1zkCuZUyUh4VnYLpjGE3XoyTLzeSbVK4s5jhnRxFdwqu
    gOIJTkabgaysPvyDBGOzIGYHNPXaEqpcJyCQcmnx/aqhDSnhQ67hIJlsLQMXCT8YK57SHW
    lFyWvGk8QFYVyGd3mxw5VZFzZrH+iQCxqcC+pQOjthK7+F5lL66faH/Gu23DKvq0UKwwV6
    yGARW7W1rzeWRDkEXbDPozWwroc/y9/+Jpv9M/LpL7tvibv1IbtVOaW3UGDA
X-ME-Proxy: <xmx:LTx_agm2m8DkDoJaNBEEhbKSSO612BA-aDYRT2tNEaFmydiNUSoFrg>
    <xmx:LTx_aglnmuxfW9T4J0aAkvBU3NCyp8-K0ae5KuQ5KdScfX0F9zEyLA>
    <xmx:LTx_aqwTzM-OH8iPXAr7wz9GmAbOCMxJwSDF5qiLBpn5FVzl2EdHFA>
    <xmx:LTx_atpeKSwEAGMIBuAQJ9HInaDR0_pnpCkQoqSFAULcwYPiQksvCA>
    <xmx:Ljx_ascGYhi6V-y5gyiBka_dUbY8gDR5XLo-UVr-utb36f6PDbxCPDur>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 12:02:52 -0400 (EDT)
Message-ID: <afa1e118-954d-4cec-9417-a0f48474fe76@sandeen.net>
Date: Fri, 14 Aug 2026 11:02:52 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] xfs: count folio alloc'd xfs_buf items in
 NR_KERNEL_MISC_RECLAIMABLE
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
 Vlastimil Babka <vbabka@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>
References: <20260813204929.2253988-1-sandeen@redhat.com>
 <20260813204929.2253988-3-sandeen@redhat.com>
 <an7C0L2PT-Ous0hn@infradead.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <an7C0L2PT-Ous0hn@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B6E8BC0004
X-Stat-Signature: w6xquekqx89ipdfuuaz5h9snqpjkfuwf
X-HE-Tag: 1786723376-278282
X-HE-Meta: U2FsdGVkX1/BRsewg9x1CEWkITXskcFfp3aHimV8cbh+mKGYFAJYDZgZD8KayO0HQULc+bkptCm8iB+8P56EaMPkq/g8+GC8L4SyzG2DXeoonsjetqwZ5jvmdEqPqxjN7C9GcZqdP6cJgis1wS/hFswfh94f6EsWDc05ELEXu7qQEF/lSXx/drpsaFXOlFTqyNlMomJzOkIaY4aWZIv+uXG/kT8yIMOr4eGsBqCDwplzzzmxCjjzAb8AjZKs11ir2rz+ts4pR34IFrQV2saE5OA9bacPOBqmuw4WTZ6hAKN7U8dFUF98gn4d0rRZ6CTGE6ZWYXBbDNVvNRGACxbxRxH7JuVs8yG0oMjYXXe3p3lmMRmfjq3ohCPG7W2CgZ9LUZiikKcKSUprPKsKmp64XB1SEQt+tvBTqzP3UG3OId4TCSbQiUbC2Cx325y1+QkxEqf5SIgDNAaCQ838H5b7VSCjRfv+YjYwfYvDNywhj2PuRr5NT9si5SEGgicJWcrf+1WxEq13hNDPmPtRB6GJKojxoLsYlg1ttjkVJTE/u4NaHQLW0Xv9PF9Z9vulLAPru60150TObpOpoz+kmartpDU4GNu/aRmjIiuBrvN86Mf/+QxVdrcUoChq7dJOyLgBO6c5AMMgCYkUkZwX3uoksmIBPvzVnmyxf34VJ3u/jpX8f3o/Qj8rxfDvmHTG5tzr+Q5Mcfn8rGt9tJKvEeTieJppuctfng7qmHn4pkjvM7at8xKw8nmCk9mRwOYaQWEjk5785YBKCTUoVTXVKHmPNcR9yay/RTG31qk/fHasWS4BdNMfqvHVE/SWDPX19NuTjaK+VLn54pES7VcUi6+94eHLwVaLwVInUpkmQ0Ai4JNRjHhN+Aa06fXr1Lh0GicsJIi5wdc8SfKLTz6+S1gl32A5SL65ysBT7LuMY43qWvdqY0nOAVN68eDF9RqTEL1CCQpJ2a38oIdRjsNWul7
 w+L8oHuk
 ib4z5ZEQoBDuRTjuTSC9csxbvIZbVT9L1u7SQ2sog4ZzfCT6niWCz80Ri4FckuenboVSc5TILMhaR2DYpAq6n+QFCw1yp3CYRp0IWsqGC0ZlmD/SxDdUdTLVyx18Et1KOKSalOo5maC0NyuBKhIO47H9yyUcHMEjjIp8JW+SMdxajDa6kQpAHOYnohGCdS+a2Z5pVVcWiOLscN2Uc1sT+yieZt8ujePf52yb6xGoK+Lm/QxSr8NGYAayPH2logrgOgSIiwynkgUkVAi+GYsORY3I7giCTM8HLoc6uSgNYdlnhGh/ps64Xr8GQQeq1AufE6Iq4Q1sOkTFCq02L4Wuk+rAWpmCV/Wij7yAIIiFpfyJEARiXxq9PJQnrblXXdro2htxcBbZecfTonMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/14/26 2:25 AM, Christoph Hellwig wrote:
> On Thu, Aug 13, 2026 at 03:40:53PM -0500, Eric Sandeen wrote:
>> xfs_buf allocations via xfs_buf_alloc_folio are actually reclaimable,
>> but are not accounted for as such. NR_KERNEL_MISC_RECLAIMABLE seems
>> made for this purpose, although AFAICT there are no users today.
>>
>> To achieve this, add a new flag _XBF_PAGES to track what we have
>> allocated this way, increment the NR_KERNEL_MISC_RECLAIMABLE
>> count when we do, and then do the reverse when they are freed.
> 
> I don't see why we'd need the flag.  All buffers are either allocated
> using vmalloc, kmalloc or as folios.  So it should always be set for
> folio allocations (and is misnamed since it now covers folios as well).

Hmm ok I think you're right. And using PAGES is misnamed, yeah.
>>
>> These allocations now show up under nr_kernel_misc_reclaimable in
>> /proc/vmstat when allocations are active, which in turn makes
>> MemAvailable more accurate in /proc/meminfo.
> 
> Adding linux-mm and a few people that touched this counter for
> opinions.  I guess the counter is only for full folios, and we
> should not set it for the small than page kmalloc allocations?
> But even with that, why not set it for the vmalloc allocations?
I hesitated based on node accounting but dchinner sounded unconcerned:
"If it gets accounted to the node of the first folio,
then it will at least always be consistently accounted, if not
always 100% accurate for the vmalloc case."

I fixed those up but won't resend just yet, thanks.

And I promise to use more columns next time ;)

-Eric

