Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D8C4FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D70A6B008A; Mon, 27 Apr 2026 12:39:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7880D6B008C; Mon, 27 Apr 2026 12:39:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69EA56B0092; Mon, 27 Apr 2026 12:39:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 548D26B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:39:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5DB2A01DB
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:39:06 +0000 (UTC)
X-FDA: 84704895492.03.81F7E9A
Received: from out203-205-221-210.mail.qq.com (out203-205-221-210.mail.qq.com [203.205.221.210])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2FCA5160012
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:39:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=r0WpfC0I;
	spf=pass (imf08.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.210 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777307945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mx73HOQOsxaSSA+LxPDa+bf4ZsHWMMr1s2cLGFRHWfY=;
	b=0RKsGYHsetIMXWZExQIezzgyHBvqlmwHKnOGVhfVVEyxuRipFjD8DBnrnpppd59LpAmkYb
	U2JuZ2DTVB2ncWB6fecEPsH2GQyTSCbhlUeRD9BrHthcR6rRuWSCFuZbVYsJZhXxyLSEL0
	tYvt8+qYPp+i3wbd6iahsDEe2qfFnDY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=r0WpfC0I;
	spf=pass (imf08.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.210 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777307945; a=rsa-sha256;
	cv=none;
	b=kJ69B9GdeMrtBAjymwdlvE3hv/NrF/ag8+yE01Plnw2TijzTdrbLnswc6hRQ55NJT+ZQX8
	IQdfOp0CiEvdZduiJWpR5moqAyDJjuE5ZHosd8bXMD1mYH7M3H2xabMKvsnFmOloiitwqr
	D4aWd0O58c9xjv2INhXUdsTG5BKaxlU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777307940; bh=Mx73HOQOsxaSSA+LxPDa+bf4ZsHWMMr1s2cLGFRHWfY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=r0WpfC0IfXHfa5Y3rKCEemO4CeZLoMqJrncvRlnYztuaEEWPL2A0YkQmdyh/6Qwtp
	 7I1b1c2sAM7+8Y7Each9qrPV+ydNS4mk7Vr70XN6I2sZN+OveaX+Gu21TNTktjIzrT
	 499zCwCrm91tSTmcXclLUtX4zSjHs9bXPNGSQ79M=
Received: from [10.46.141.45] ([36.112.3.68])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 9BAB38FA; Tue, 28 Apr 2026 00:38:58 +0800
X-QQ-mid: xmsmtpt1777307938t19zjv3pi
Message-ID: <tencent_54339C62C9BCA8C7ED48DB0D91451157FB06@qq.com>
X-QQ-XMAILINFO: NoLc/2Jxb1KSDntDTYSL1mMEq9utSbW19IADQ/x9a7q41v0fiNrr4cR54FVxSu
	 GROBmsPzCYE5fLDk4VoMDtlU4Ui/sXXeXa247oVVPkjF4NmMCJBKhXStv8WAMPGnpl5GVgiGWbEn
	 vlVXVM/eFV1eQBpbr9O2DeaPdwp64MSszQ1aM+3HVPMTpXojGEzeTcXrXONZKwYpIhOpc+4S8Jju
	 8xms1IENcD3Q3+KbrEz4npO9U/GcCdXx0/ixial2mO+AmD5TZg0+vGdmNlrPAPmHr+zpFgxpVgxI
	 Vn/Hs0MUt3Kj1eJKS1zcU/gr1ZIW4mq0Y2mtI9JIf9/be0xl2Ri1zFr5IZTTd6ICdgclaAKvWW2e
	 eOUhPEVvE56u+W2DkaOQJreCFTYaBjuMcwXFgWPYf6CIuTgmvHvobjNfqUxD10Cw7xGZCTV38fea
	 zuyfzFSjB65T5Kk0YfHaqUVyxoQdI3k/z5kbrgDq9qmBAgjIn6FJ16KvGY2tomILR9q7TfPjGqG4
	 HM25qs7iSnQ12d0vtnDQK4b06/Bv7QoPbnvgCokIfCsFcUCeXIFG0hXmV5Y3dn4HvBrx+4troQfA
	 0PPvv4Fyaa0mXaJTqdZ9Bi2C1oGzzz6E96jCI92T6ouMFmnk2vViWfFaIedtV3nRkH8KfhLK0So5
	 X551eAxHmR1YqIoVAe+qpJTC++LQbqSeLAjzjW/Vls9O8aRTs3F4aMU2AqHLCtB16avlq/NPdHv6
	 ZQLDuy5maIz5XqTCh+Wy5qdxCDPU23khh15t7eFgF7C8MA+jfyQEoqqBbTrTPup4fzKrv9Z9Wiu/
	 +TcjIkamtnr4xBMxXOP7UFZVv8ry3k6RyVY6vEj9b+EAXEGmJKxaKn+j5fyCPGano3eAO0b3wuwt
	 XfmxJrQQZw96tZ1SsTnhEiZdX7p7U260Q1Hrnj24GLQwjxLe6yEsDKRtm7TnAZ//47YbZ0KwMUrS
	 GhScyS1DOaPtsuDbu9i4n4zEaRoEsD31HMySuxSnqh0cXUoLlyZ82x6M7QBNUr02w1lw3CO8mRvu
	 NXBNRZECwU62kEZPtgo/TpoMR8jAt8mfzmxtPzpbp4MOBwi8yfqj3m9BG2qeR1MXQ+5NeLe5P/Uf
	 ixsRHd
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-OQ-MSGID: <9347ab3a-a482-4155-b518-0decb095d37f@qq.com>
Date: Tue, 28 Apr 2026 00:38:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/1] mm/vmalloc: reclaim tail resources on large
 vrealloc() shrink
To: Uladzislau Rezki <urezki@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, shivamkalra98@zohomail.in
References: <tencent_824873CD3C7F2A76CD237A308C00DF18580A@qq.com>
 <ae-O3URyANS-mkoV@milan>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <ae-O3URyANS-mkoV@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2FCA5160012
X-Rspamd-Server: rspam06
X-Stat-Signature: 7sr7c5j9ne7msutq4jgbh4zec31bzxj3
X-HE-Tag: 1777307943-773008
X-HE-Meta: U2FsdGVkX1/kYyhVkMuL1X5pgnhfO8GXt5qiivPQl1SF/Himbo30B+0ZrfHgFefKpctR9kSyjK6yf2jSQAQRLT30aU/vejA3jBnePX0DZ6jDomz85P3eeMRyFtniqOlVNXT7/idwd13rRAMpc2qITv/OUuaTzQU+sf/wkt+sC7nP2ynKvliRtkKT/IT2QsWVz8g2yxy2RkosKzICS65vIcUdU1lrrjinzAx2EvKPFY4S0lywYKn0+3O8iT+PCO76yFn4L7yimGN1hqpfbUnRPmi56+3kxBVb8/AQTqGCIPy907Vimy4MOZ3q7F9erRzG3DQjLYp19tR8raZjFBQ0G0wD//RGjCU6txkkYErleMt/r3j6mtuauZpe6Mq7VByrJKW7wy8BVH/+/1JxRvqDl3qYKq/d7gVhZSJ1DfYqRo4Mso7ye/Q5lMwK1ysDE614IfoyZXi6MjE/Q1ljNzB7M1uD8HkGqDG6v9Fcnr6nv20I+TuQrUB2XiZAUp2Tfzn9hXvHMg6Y9LHFM7qHjtOLSaCFsFe+py7CDcpLg8WujTJD0/O8MOeL74HPel5P+92OWTbCZ8khnYbhxib/yv78NUBUuhtqKDGleayVFS3O9LPrBfaOLBFhy558IuVUO1W/nrh3LCOzAWFUrmfSXfcfceIMekj9YPR+qxkFkd/b+mrgAELvFS8e0UCIlg0pO+jGJkadjgOZZsqlvyGJvuHd4OcPZE44sEnR0Mg8Q256wVhMtZSaIEhEC/1jt1ImxzjDsAa/22tyVUTrdLwkP2B6kKaPjKpB3U0VfsxnBXV16BQ5tADaL2MyyqVrIzYBiRG6nLGpfeQpuNWJ908Tzg7vBNgyK9tgkGeRChVuXABQNIumpYq10ap7CUYAPoxZwQMUzaJtFp9UewIZuVvWWYQnaV2I49fZHjtGILh6fivj6hZtt/E17kiJUXQtmNkv2fj76nt2CLkJiHW7CjPyIsZ
 7cDv9qSo
 LDBixWZmO00HHoqEfWAHdmsgnFqiLmX/GuPyxC3kCHQjqHwGCAHsRvPpR7wlUkEQcx7mKmhmKlg0augOBDs7dN2VQD+iKoA6TABeoqd6tQcXrchCXeMRybekz6GklltHfo/03Tc1Mx0Q2gy9dxCf2xB9ySd297rVflM+15L0Xa9sDXOSKhpnK56vVDsDqzYlpAbhY2/OG0+2AYYusaNCuOfpkEmB58PNUai6kXCToMLS7fAs8vVAV/CiEIIQjybkubtzxC7Ihf08GPWopeUbhcQkJvi9QhTcXk0s9zIs8NFELM91oOpowoX3eSa7cmqXLfWGTOIP43cT/QqdJG1S98HJ5LWXJcaJR4feBUL/MXrUvpvVQTA2VPAyOY6qrhDRkmrGV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Tue, Apr 28, 2026 at 00:29, Uladzislau Rezki wrote:
> On Sun, Apr 26, 2026 at 05:28:56AM +0000, fujunjie wrote:
>> Hi,
>>
>> This RFC explores closing the resource retention gap in the vmalloc-backed
>> shrink path of vrealloc().
>>
>> Today, when a vmalloc-backed allocation is shrunk, vrealloc() updates the
>> requested size but can keep most of the old vmalloc mapping and backing pages
>> alive. For sufficiently large shrink operations, this can retain a large amount
>> of tail resources even though the logical object became much smaller.
>>
>> This first RFC keeps the scope intentionally conservative:
>>
>> - only ordinary VM_ALLOC areas
>> - only page_order == 0 allocations
>> - skip more complex vmalloc object types
>> - only reclaim tail resources when the retained waste is at least PMD_SIZE
>>
>> The current evidence supports this as a resource reclamation fix rather than a
>> workload-tuned performance optimization. Local validation currently covers:
>>
>> - synthetic large shrink correctness
>> - shrink-then-grow regression
>> - threshold boundary correctness for the current heuristic
>> - KASAN run-rootfs vmalloc_oob regression coverage
>>
>> I would especially appreciate feedback on:
>>
>> 1. whether this shrink direction is desirable upstream at all
>> 2. whether the initial object-type restrictions are reasonable
>> 3. whether a conservative PMD_SIZE threshold is an acceptable first heuristic
>> 4. what kind of in-tree regression test would be preferred
>>
> Could you please have a look at this work:
> https://lore.kernel.org/all/20260420-vmalloc-shrink-v11-0-cad80b00853a@zohomail.in/
> 
> Shivam is working on the same feature. Could you please check?
> 
> --
> Uladzislau Rezki

Thanks for the pointer, and sorry for missing Shivam's series before sending this RFC.

I will read through it first and avoid duplicating the effort.

Thanks,
fujunjie


