Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C72CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 09:52:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90AD68E000B; Thu,  4 Sep 2025 05:52:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC078E0002; Thu,  4 Sep 2025 05:52:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1448E000B; Thu,  4 Sep 2025 05:52:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0C18E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 05:52:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 437311A0A97
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:52:05 +0000 (UTC)
X-FDA: 83851101810.11.D47A4B2
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3EA5DC0005
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:52:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=IzbD0+2u;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=9gUm64XN
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756979523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4IuKTho9AadcM+Re0nAwehN+zaegfeyCAyeD2EXwBdM=;
	b=VqoKuEGHO2vwlcyf16LgdKPCB/m4d1o4w7PnHynmJ1FRLMSLnDZ5y6KV7sVMLKwnPgiuPC
	dN24fuvPxuF0NG3dFVY4B2jisr98GV1a0d4LguuVIKaLJjOau55N2is/3lyVoLo7IEb6H1
	jzWsDkpVY9zqMQMKCGC1nbmGH2VI2xU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756979523; a=rsa-sha256;
	cv=none;
	b=bUMNzlqr5UnPGd9n1KCZ0HubYeeEoZUptfLs2ueN/7t8eJqeieiyvSDSaQ5CkJNadf/vm2
	dtQytSD8YzZEZ+I15fLrqlSceFYQB0mGPVX+Q1cddvWZe90T6H+bTSiKAFKiCNlxyBWOpQ
	YLXSk3o3peRyJkMYDdNpV2lWT8u9oBs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=IzbD0+2u;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=9gUm64XN;
	spf=none (imf10.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1756979520; x=1757584320;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from;
	bh=4IuKTho9AadcM+Re0nAwehN+zaegfeyCAyeD2EXwBdM=;
	b=IzbD0+2uO5U8AscM4gquZJ3tAqNYStOBjdL12NYAp5Dcjn9XjytYchcTeGTLBkv9MrLBGRQL5iM99
	 Z7SzMmgVKEHmrEp+cahwgJ3hVdsZgsFe7JYrmeYLVabFh+SDMhBPZS9qXF3ypyxo7iZBN5mo+X2m/R
	 VYtWh63Vg8yv8TfqfXXzikRsJUD3wwAXpT6HNW+hEcbT8+pik0DHWx5jqK8J/A4iOs1zGxrBZZTv2G
	 ZtxxUkFwA/zSI7Pmv1D5H/lhj/uEHltqBju9KJCYvwpdQ8RiEHVlRIKQ7ibC/jhh210BjX0/l/0SeX
	 1Zg+/0ryeDCbc/GaMc0+pelej8Oi7bw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1756979520; x=1757584320;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from;
	bh=4IuKTho9AadcM+Re0nAwehN+zaegfeyCAyeD2EXwBdM=;
	b=9gUm64XNHZ4cOo/2ZWkc5UqXi6ybhDmmSCuReZQFe5x22w732XhYI0nMT0nGI6mlW9Q8rPeC+QePM
	 QMQ/EojDg==
X-HalOne-ID: cca8378f-8974-11f0-940b-632fe8569f3f
Received: from localhost.localdomain (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay2.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id cca8378f-8974-11f0-940b-632fe8569f3f;
	Thu, 04 Sep 2025 09:52:00 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vitaly Wool <vitaly.wool@konsulko.se>
Subject: Re: [PATCH 0/3] mm: remove zpool
Date: Thu,  4 Sep 2025 11:51:50 +0200
Message-Id: <20250904095150.2770293-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250829162212.208258-1-hannes@cmpxchg.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3EA5DC0005
X-Stat-Signature: hfi1a87xs8eayt53r8iuhb3d9qeam666
X-Rspam-User: 
X-HE-Tag: 1756979523-383199
X-HE-Meta: U2FsdGVkX19pVdhBVjaRotMrShgnsJkqnVGI3CIg9xJL2P3EAYOlA78PU+ZKE9qRsrk301mqhS1KhMiEOxDZyKp5pizFMpF+uaJ7tUUG68FpoqlBRIzwzJWTCF/kXS4tgmvpe71QJtDfRTEs+0hAYuBkiApvsfvLH5wpEQFnUv+b7OWC4q8TeH4Imjgy1i6bEUVKYl78y6s6rPYwn+dJTvAmsAiT1/kk0g00KHHjwf2AgjZ8zvRfG1QbiO+MT9FTkPURmzJeVmx5EGON1JbmMWoU/j9BpP2LwopNCOJSlr5hQ/3j+HDQtGHdmMtdsm2wMLrKY99AwT7u38/pbyIIYvNtTxJmtTp+bamtCiN8TzMO9s4wSDt9e1yeVTWLaoMraSDKGInARtNBZGp7TBpdrIQCdVaPQLhVmeZ1g98RjRSitvu5O4SNmvvVsWNMfbml2rKv7Ymjx+Yt09xjCwFaBV6T30n6mETUkFEXR+zFh6lrvDgbEGq+Z6sCPvVVPopItTSiKw+4a72Ox1P4iF0ASTaU6BAMIMSXDPLF+gtpkb8xYSOS0HNKidljdhnCPZH62jrAn9qBLb0+T5wglsIftLz5adkADdq7SsThJ8vhbO+i2knEOLKgOOKRyYeCyZ8AeM/84ezVRzSrr09AKRf39jDGDhQmWOAN2Phe+Ae8azjzQ77tVmNGtx6lTtkxdQz8jc+kVXD6e6nfVhinV5HYXW5AS+/cANwTMLjaAO2CRH8kfDV9IqDRbLQogIbuHEdKrVENYJL3lN/92t+/hZnwaRr8pO7+9Ezxmiqn5sA588YWlWiw4qPm3FvPuZRLXFZQ/k5+zQwENt3eCkTEqVwkyYJPztoGpsn5s6wG6jdM2yA75UmNFOWu0j9bkA90xLZfHK9JTxB3kujaT2d2P6/WcdUEj6T3mNluBRfWNwiqDaZ6YqjZUl4Ua+jAZ3/3zIG54Wdj0zJ3SWw8QwyCZUH
 PvvgMmyk
 rcix2xQNYC7qpYsJFyTToG/OBMeL4IMl9mgthIjknHmOmyjp9zl9yYl839faONPmYVpmxAu7FmlxQdCeBqRAEaLgod58k/MSOXGpkygmW53K2M/IK1C+hqXiHLyqgyG3akw8eiPSlv8Di3jqEjBsUhuebQpQyHSysrHEqqCzlkc/5ZxJ4NW2P0HFsEWWH8yvYuaEV+ZUTlttb2+V9MPvqS+aWP0L2Rmkqtt9zFwAQUHJH3cM44NiDWXrTsm+3Ipqng8ogaYsYWNdYuW8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> With zswap using zsmalloc directly, there are no more in-tree users of
> this code. Remove it.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Per the previous discussions, this gets a *NACK* from my side. There is
hardly anything _technical_ preventing new in-tree users of zpool API.
zpool API is neutral and well-defined, I don’t see *any* good reason for
it to be phased out.

BTW, remarkable is that you didn't bother to CC: me to this patch.

Anyway,

Nacked-by: Vitaly Wool <vitaly.wool@konsulko.se>

