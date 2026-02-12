Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EC4CEEA844
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 18:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2FBF6B0088; Thu, 12 Feb 2026 13:13:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3D06B0089; Thu, 12 Feb 2026 13:13:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95406B008A; Thu, 12 Feb 2026 13:13:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A54856B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:13:34 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 512D28AD01
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:13:34 +0000 (UTC)
X-FDA: 84436602348.29.5B547EE
Received: from iguana.tulip.relay.mailchannels.net (iguana.tulip.relay.mailchannels.net [23.83.218.253])
	by imf27.hostedemail.com (Postfix) with ESMTP id C23474000B
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:13:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=gZLUv1CQ;
	spf=softfail (imf27.hostedemail.com: 23.83.218.253 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770920012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bHR+3mTixf9RIK5Gzvd/naYnT/4uOy0tnO1nYcYmufg=;
	b=RIsAXRcqXqdun+VVT0LtQWkXI1dAUkkOWqG5vby52U1RPuWe1EKaxFzybP7eWkWMHL0WXB
	KxoT+NWrTxX3vh0vy8pfmh1OaI83VnGcAwGti7+i0+tLBikrfOWTnwhXPIzX39gazyWVQg
	/8dLkgLpWxGjnH0b8lUHBbTjn9LsQB4=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=gZLUv1CQ;
	spf=softfail (imf27.hostedemail.com: 23.83.218.253 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770920012; a=rsa-sha256;
	cv=pass;
	b=lXf8/BeYAbSB9Xz10bvLpxDR02vbYe+WC4xJEL97YylpZwtbJw3O/c9MjfsxfTecuORZ1R
	eOWAFaW8RCN8EAJ1GQqwFdgVivICbhguooBBzFo6KzG2K9E30li3K5FgMB8DyOPXoQ6p3F
	yedTnS6Veh5/Fa08jByPfkeHTrPPVBQ=
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 6EDBF8A35AF;
	Thu, 12 Feb 2026 18:13:30 +0000 (UTC)
Received: from pdx1-sub0-mail-a254.dreamhost.com (100-99-24-1.trex-nlb.outbound.svc.cluster.local [100.99.24.1])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 5BBAC8A25AD;
	Thu, 12 Feb 2026 18:13:29 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1770920009;
	b=vfx1qrAaTP7mU0oouY/MzUT93SC5Yykx1Qg8J/kdjmS6KjkOnXoWkKrZ/afbdaEx8SiMNT
	KgWFYSQZ5fYVaxy4PwB8ljDrY5UTYa8vBxpMqwlcE4oBaeVwo19170bXk2og2caSDdkunX
	BOGHKOsnU2BZunlgWYXSh8YSui5mBrmbcu37kUQ9NCD3NI7gGVAfbsnsyZ3GhX0DZverPf
	NCC+YW/pSyOEUlhB2kdh52tub7z27m2iZymucEoB+IfDw0wofJNS1uJkU8pDWKyPveVXns
	QXorPvf8yj3WuNWxFWgPDPFUKmCk7hxzfURDFp09YEUuLIa9r1MU6+qd5ADGXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1770920009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bHR+3mTixf9RIK5Gzvd/naYnT/4uOy0tnO1nYcYmufg=;
	b=nd1rytp4Y2/RJZI5AhcR6xSJb6q6bctiJHggxTnP9CRzvSBLYUEZIbIOzX9V8jT8oCMaWD
	KfVx9zCCszleqGmx++XJbiZEMrsfvCFlnxOlrnmiMcXDRF/t45C8jBi3saHvuzyaaWAid3
	5d3EcvniqDRb5266wyyLMauAneWhuYFUEroEG5XGsDIjC4S95/CIIgaIihCuAYmqE9Wg+l
	sws+VA35IUccFpk9i+cpV8rO0MBzLa9Ul8MVZkG6bAk/acDZ3/pwsfQnh98pNWTBGllNA9
	eSrXFkyUN2T19pE7/gPwkOvpsdMwNGjT5Sky325SWUTXB+WR2X8RMgHegyY/BQ==
ARC-Authentication-Results: i=1;
	rspamd-79bdc9947c-c6d9t;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Hook-Quick: 17df99992162422a_1770920009714_4065537010
X-MC-Loop-Signature: 1770920009714:1590538124
X-MC-Ingress-Time: 1770920009713
Received: from pdx1-sub0-mail-a254.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.99.24.1 (trex/7.1.3);
	Thu, 12 Feb 2026 18:13:29 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a254.dreamhost.com (Postfix) with ESMTPSA id 4fBk202PVdz107M;
	Thu, 12 Feb 2026 10:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1770920009;
	bh=bHR+3mTixf9RIK5Gzvd/naYnT/4uOy0tnO1nYcYmufg=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=gZLUv1CQ0/sZcTakI0kU+sQvSPTJ19ODGSpC1dwM3DI2iOnpHBBPta79pfHu+PxtL
	 tjeEjOT3Af5qI2hzeFymu5TRcjLDQwtAucf8zEijP1xRaDTfJ3BICbeaIJ+8UcV03Z
	 ahDYj6GusuQdlYwd5UgtfqIvvo7Mk63Y3VXatWPQZdqW4/DL/vSjhn2/bOuzQwSxBd
	 sTD0ZCONZsKqUalsrUFk2xMd4HeeWUo7rxtXwmjxyHPv+8GrFNLojOB2pGMDyzr39M
	 z1bzHQKDrZN6Jyp1HkcVGEzulTdg1bHEFfY0ZgmUYI0EG2E7FRq9VAoqz9uXAinuAM
	 vccX3mKZTvPkA==
Date: Thu, 12 Feb 2026 10:13:25 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	david@kernel.org, osalvador@suse.de, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [PATCH] mm: name the anonymous MMOP enum as enum mmop
Message-ID: <20260212181325.riolqzwvhqjmv6mk@offworld>
Mail-Followup-To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com,
	Jonathan Cameron <jonathan.cameron@huawei.com>
References: <20260211215447.2194189-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260211215447.2194189-1-gourry@gourry.net>
User-Agent: NeoMutt/20220429
X-Stat-Signature: quzhuf4o9ed4ggrx4gjcirjktcxbmcc3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C23474000B
X-HE-Tag: 1770920011-771340
X-HE-Meta: U2FsdGVkX18RIjxSwXnkK8sc4Gq1dUikTx/OxyEFEK5ly96n/m0mKm/iXja88r0xFeUqzvP08atsG2sgq8Et62cz+GsnGuC98K2t145vXbvFmo/8wbH3wShEFrpRk/ycsShthX9ACZQUklLnqvrmITBZQbttgrzHYLQBA653zypi6WPPLRY/fmXeKp2xkNOzj73EBpNtcdTQ/1wcN2dO0B2tVcF2A3Igr7Kk6nORUGMuDloNDBbqQxNjrw/zRZ4i63FyYjQ5/hna4xUJXKmIjZcmRyKOwa7he0+tEwEMQAYlJq86Dc+09E9cCCl7bp6KkgfTZaIlPND4lJE72vgGi1mmy+n2KVkJ67T9LuRiarYj3iWtsUb6O9vMcEWzPAITgUeOE9Y48PQcLgI96pPQ33SGjNbTkR6JNF7YE9YKXUpONRih/qnqhnsUqftYvFQTPXwASK0HKMo3eYU3EYhqpqEuIaRQ/y2pzFN6DvT2z4CdoIp2FwPtsN2qyzfbMDaj9DMDngR0IiTB99qBddPBtgq824IRbNG4UuC+fZYeoSBV1kab1CsuUokLRFnnIXdApiyYx6CdUR05w9aU7OUmvbqreqJBK3lfJKc/6ohtxQRvVSZy/LaPUmLplqy8DjjtOrxgZA9y3fTHYCWJ4GKwms+1JyiaiACT/CfRMXfwDO8VbCQapWwkSuNO6uKlsW8ofq0HNNT2RYi9sgkATuQEtUoYmX4OFrcw9DuSBwdz38a74U+l57foQ0jV/21QFsmC4nLF1lFr3iBC6Ug3SAvEhm9uCnCk0poBlypWsdiyvj32eiq0UwD64RZK3m3iC1T/hsLIx5K5hndcx07wtCNVirSUmIK/icVU0DQcNwqMTppe3mBZEUTXIM27+OwHDfs3EqiJFQm+iKm5wyzDrTYYBGWPjXVWiv8ur1xUkembzZfBORb9rTqCAnFlX6wdxkzRSLbmodG41X0Uip2IiZJ
 B4NYqCnK
 smlQmVJX6C4XDMZfmGr2oBjBX9cOqBK6QnnOfsHEoljEPW7lKvAteZqkuB6hZzZTIBQRXIk1/Q8ILH0YNfDApXE9HxRt0+aP3WqN3eO6EJKlW3mE4QDXCNlETP57NMkcui+8GF0cL8R4p4iz8WoRut0RPrm396KJyXrYr4+oV9lqoXQGQYgyUH4SZJyd9+fcDK08Zb4hPNmGW0AXUy5M80WNCsYoqob8ROMaVi92veLe9Sw/XqEl/FZz9BuewL/MZr5DhKj1OTCYmIRNz3iUfU5nu9dwOBMYLDKJNYtVI8x82atxS08WUPeKOm9mqtTYaRtF36dmXLX8/UkfLGmzYXIBc2nNMkJryZAPvX60q+gg34Lp/uud+IHloBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Feb 2026, Gregory Price wrote:

>Give the MMOP enum (MMOP_OFFLINE, MMOP_ONLINE, etc) a proper type
>name so the compiler can help catch invalid values being assigned to
>variables of this type.
>
>Leave the existing functions returning int alone to allow for
>value-or-error pattern to remain unchanged without churn.
>
>mmop_default_online_type is left as int because it uses the -1
>sentinal value to signal it hasn't been initialized yet.
>
>Keep the uint8_t buffer in offline_and_remove_memory() as-is for
>space efficiency, with an explicit cast when we consume the value.
>
>Move the enum definition before the CONFIG_MEMORY_HOTPLUG guard so
>it is unconditionally available for struct memory_block in memory.h.
>
>No functional change.

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

