Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91026CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 16:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF0CF8E001F; Mon, 17 Nov 2025 11:47:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA11C8E0002; Mon, 17 Nov 2025 11:47:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E06198E001F; Mon, 17 Nov 2025 11:47:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D0AE58E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:47:47 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 89226875C5
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:47:47 +0000 (UTC)
X-FDA: 84120680574.05.5D20C32
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf10.hostedemail.com (Postfix) with ESMTP id 03185C0015
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:47:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=qhRdYaal;
	spf=pass (imf10.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763398066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wpd5rVPPeXh7kmsgFmv6GUZgyfiVNvfbxMDKaX59gXU=;
	b=YhCIByqZz1zO5oXFkTUdSLj63vAqaULn6jwtoarAk0h+RF7fE558xSO6GzNbiXMDF4fTDc
	bIRSLK5yg1+3U+Z1oyMbLeazgAaZzMenquZeVSvu5TKXPtB0sAP9Alq4KTCBlCuUMnzS58
	qICJLpZF7Zca/1bmBGhAatXK3AS2GOk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=qhRdYaal;
	spf=pass (imf10.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763398066; a=rsa-sha256;
	cv=none;
	b=Jk8nwFe+EwxUR3nigd+t4ZNFRbsaYtHUUcCYc2k8FZTCbHfCmmYtZEGDwO41dxUMpsbs5t
	Tiu3fP2vIV7SaVnWaU0nr04DRGNdm98T8coCSqNIBcbsBnhIJLZMPcKoPCEaPolueRKGae
	v6pmOwWtRg58s6f381FOQLzEpBgDWsI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1763398064;
	bh=wpd5rVPPeXh7kmsgFmv6GUZgyfiVNvfbxMDKaX59gXU=;
	h=Date:From:To:Subject:From;
	b=qhRdYaalGt4YQhi5+ZwQJKQAH1evnZCq/AZWH4tkcxTY2t0h0WxQ/O87t5r5SUord
	 0rc0bkuWPraA9w5KolmYU9fBRvEbnz7HloKdA28F+oGNO5TsZ/fmCHmNWAMglh1eNL
	 OAsVVS8rPJ7rt/poKmatie2ZxfvPRnnM1XCjFSAk=
Received: by gentwo.org (Postfix, from userid 1003)
	id C289340345; Mon, 17 Nov 2025 08:47:44 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id C07E1402AA
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:47:44 -0800 (PST)
Date: Mon, 17 Nov 2025 08:47:44 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: linux-mm@kvack.org
Subject: Email cl@linux.com decomissioned
Message-ID: <ba4bc7cf-699e-f6c0-54d9-24c8293f6425@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 03185C0015
X-Stat-Signature: 3p4bzwdhmh6zurnfxfa3u1kd8wfnpz7t
X-Rspam-User: 
X-HE-Tag: 1763398065-696975
X-HE-Meta: U2FsdGVkX1+hGzeZIVtS6PPizYLH9tj0h0DaoVAGW2Wy4Bq7HHgg/xCQpczzf8VS5S7E43ErCJEc8yiTjpw1udrgwbh4mBhNq6ewM3DWiUnPXLV0nmHy7PiUpC6wh21dOxDWPu5Wqy1s2G9kPKHVSLPsmS9EQ+vQhFqSFO3l4Tl47xxiDulYy5g3+MQAISRtNlxf/y1Baw/f9+A/SaTlSlZVTRFW+H6uer/3JL5EGE6XM+BpKYnPhezLOhkPQn3XxU+yRpvfHnwX0Ashnrl1tKrdu9ZL33ZMS+5P7G8vadYivTFxY/B25aP9gaQMRzdleQ+TlquFyqmCMzepUMGhcZdGcC33KkbASvcOIrZqTmtusJ+rkhP3ryNd1EFxaJ5jsquyqUARFiuoTTduArlqnEXCiyuE2y33NPccGjBgYulEG2HRfGOgpW+ds3/FMG82l0MN65ugnMjaSGHN4Jmkh6mtKwv5rbvapcOn2wfLbCgvJo/nBISq3ErqEZzCpp5R5pbWe7IVhDGqioSHMt1VC/ifN+DhjVs00mYncOmHhX1m6vFTRQzFSeC/EP62uE7kDTfkDJ1dFvphg2wcY1XEuOcyYwwg7dt4brlN5de4iS++n/7xKlfZH3aCx3xrwtKhjJfosbyzh8542779iMEOOQFCyxmKTkbAT0jmKIy71rv5BmfznYeYEer2Ojl/1ZLN4mGkFoVbxFUQ2BeteVUOX1W2o/7dlfKVRDKwmq1GZ9YLESwBEAfgk/6ltlFA8mRFVqDcrp2n6nvQQF7OHSNlpp8Y+ZujumO6zjXgmUXinoikbplOEyPtjm6mpicJ64j4Jcx2nYG46wJPR4XWv1fJl27lThHxrj7fsdWmG7xHnl//5J5WoBcX42kHrYR4Nj73hckXAYYPvg7QdOFZwkHwNsie+Kb9nkjocO2NLxHUzrkA6QBIgXAUM5P+q4Rf5kOn96yhYa4k8vczk2SJiRS
 qEgqVcG2
 bqJQSSPqJIIsP2j5gdXduczQJ+N1DuTj28muKUzfBZxJinUc9kMcW6XO3zQVTCNWmxwSWgbyvvwFE+FlOATG9nwxwWSo+bZzEnS5fxEQG2mosFWhNF6OygCe3AjlmevV4rxORYjackhGTJLRekmveC3ZZ5Gt54ki0ebf/bKpoOtH4v/B+mynPFC1FHafjErOUSCpuocrYxIH6WCzM7q1v0gXFeVpHdBqKJXAGzxiNeTn9Br5pT62Yc8RPxE2r29pqIef89r7/jio+p9hZfIpGbej/zt3RKczBhBvlzN0j/YLsEwqAxmIOfNuK8YuwBXqlWZREv5lTEZ+Z2Nj4WUxO8YIGWPHZt/gOjYAso5joMDFbH4AaUvc+Ff9GI7j5DrB2RGgQH700E3g7SdJxQdys+bpkwKb2pbiaUwNoivj8vhnGv+GSPOUB+z13BN55JsguP2RI0YgHoWkUaxw=
X-Bogosity: Unsure, tests=bogofilter, spamicity=0.472447, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cl@linx.com has been a spam magnet for years now and I have updated
all uses that I could find to the new one.

Please update if its still used somewhere. Email should be bouncing now.


