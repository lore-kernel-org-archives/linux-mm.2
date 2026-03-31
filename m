Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEF9410F92F2
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1456B0092; Tue, 31 Mar 2026 15:33:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0520D6B0095; Tue, 31 Mar 2026 15:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0CD6B0096; Tue, 31 Mar 2026 15:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D74D76B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:33:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 08A105891E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:33:39 +0000 (UTC)
X-FDA: 84607357800.29.4A8DD6B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 41E9BC000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:33:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YScw01Dz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774985618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=33QqE99cT8d+4XQe5GecjlmJDpYF4vvAl5znRdf6zwE=;
	b=iL7SaFtZFpTj6tPzBt9WGBX4B06oCHMRYMnoLpSU1uAsF17WSLvjWd1lN3hrrYt8B/Yk3H
	far9xVwDrqY2MrDFceju7BiPF1vmr89h+9jAVgB3wzf8mN6dMbHRYFtsdO2nVJl38VJzZH
	6brg9qn+l+t7Lavq4XpRr63c2OmmY5I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774985618; a=rsa-sha256;
	cv=none;
	b=6C5Th2hYb6ufzsHB6ZI4jpRrGknW4F0F+YVWDdMlSquC9bQGg4YrsMmCYevp34gdF3IjgR
	dihPyeSw9HX66TdBsvk7y7QjEan4aZbwp/oi60n3uLBb+sSUmWwzKpDA1lztPbwp8j8ZXR
	/XajgcEsXwFkp7sLy9EyDC5Co0FJYns=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YScw01Dz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AE2860133;
	Tue, 31 Mar 2026 19:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E30C19423;
	Tue, 31 Mar 2026 19:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774985617;
	bh=tug8kCzckn5mE4rcWJDNZKZm/0J7JcgITmBTVRpC8Rs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=YScw01DzXCSKknGqi1JzAWPcaf99FWmdnvyQHdWCu4uRQZn6l2RPKexUVyZzINPI1
	 1tgkRhhyF+TVgHk2fyCLm4yT5C1FrS/P43iT8uyBvTopdvS6QbqTU81OVbe38L7eVk
	 r2VzTCyYWuJ9MQEA47erEM6RMvWo4NmwDyROe/gu552wReg1B8UEf/hmr0oV0RkQrX
	 G+Kb5m8mtr/6m+jYNH5G9d/RcrF/eTB87RAKGgbUB4Hsrl3pXfUgsQ6OKqU1jqwRP0
	 tTJ+ll0zux6XZxCKPcNXeV95U3IPIuzslUL+nbwaWu0rKpGx2yJEEps0Xnd1wJZ7cc
	 SE9eH12Nwl3mg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org,  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,  pratyush@kernel.org,
  skhawaja@google.com
Subject: Re: [PATCH v3 04/10] liveupdate: Protect FLB lists with
 luo_register_rwlock
In-Reply-To: <20260327033335.696621-5-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 27 Mar 2026 03:33:28 +0000")
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
	<20260327033335.696621-5-pasha.tatashin@soleen.com>
Date: Tue, 31 Mar 2026 19:33:33 +0000
Message-ID: <2vxzse9fhjzm.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 41E9BC000A
X-Stat-Signature: 841cwd6mt5p5t7zokswgy1kwuczoh6nt
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774985618-442296
X-HE-Meta: U2FsdGVkX1/3ue6SNAYRRa5cY9xIvtNf+DvDgf3CZCfNsDErDtqzbz/5r8PS8cZ4zr6lWZpIlJMZXVc/1h0zQC8gKEK/sD6lqW+2ZlBVdppX/gHQt4pOuf8kl1qvCYDF0R2UnJ+JympxGtmwLVtcjyus5V+LkrlqU+4TnWQbcWineT53QjbEoj1gM7aP1cRLCCpqug2maGP2I20P6koHbAE+JawnGk3hgB58zWmkuBw2LMbgh+b2MGq+MYjnrf3ZotE0PnBjovU14uuVgFWqeqFF1nR0MGbl/7xQIHoHflvzIvLNVbNtRrinb7Zf/+dkv66jV7dWEsqMCMq6hgr+e7Pwrk6xG8ZAIg1L7ZPK/+gDcSlUUl6kLhrP1I2TsOXpQNK/BRAEPWip1D7PAtnN26cE1X2DyoPYoO569dRmh9VOAnf2h/9+C2ceLAKUVadX9giC2W0TaEokP50Pmv31tnK23NQehdWLUu2IZtsO7nuRmVOpBc/86zcXyZl74gz63jz2PhWBP19ODi3GR4KzMPS65QW33PBxD55DP11dxZSRbvXy2hmsCETScDz6bHSJ5c4bRQhav/6TGDqWMIY2ID0ISzWTgwJXhT//c0FThkDWRibQsIgbAcVeU9gqTy2nzYROmsdzdbFtJhRCJBKsiVrGMXLGQr81mBrtl9pYAeYh28zC+pwWRWsfDhGiP7EwC7zIrMPjHxbqHg3btXITW3LSV2GvaJqaF/5t6yh8oemd/k4lulgXY8eWnJV5W8MXOqgYdUjxz/30zffdR1hHcKa0BHeKSGG2K8auxeZbx3uriatK3ybdrGLYW+LZUDOJeQ8kOv/Blupaqui0/7PI7yXxzGB6UjF9AB6otJyXHYomuglMRXRVYFnxvH2l3Kjtb1t/AQ05nzCeOfbPCkIw7bMb8I1RtOr3YnHvH8x7qjmH7us1hwG/lHjQIYI78xlxHwrpSwLPVNkq0u/oD8F
 6pI0KvYe
 ZlfnIV4U+AVCJSAn2YAP3luoXh1VjWct6nIhGao/+p8T4BudSSdNpDdfI0pKn2xfySetgGkdpERySb5+SLAEoTMLX/cC2qhMDL73Dnze+AzcSPpZoZLaT5eUrjBBzrvGwRB9Whohxs6ppZok7UDr6lPVgcWHwevUORTsyrJ89foUWmFw0RgisiDLN38Rg+1nXE4vA5CAHnCLXGuZzLhsLwMNY/INvp899nkQ3Wzj4YqehuSbjU5zu/Ea3aczRb/OdSU+c80hUgqJtZ46mU3uLrfUgV96WU03AakJnjkz73GLpMfE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27 2026, Pasha Tatashin wrote:

> Because liveupdate FLB objects will soon drop their persistent module
> references when registered, list traversals must be protected against
> concurrent module unloading.
>
> To provide this protection, utilize the global luo_register_rwlock.
> It protects the global registry of FLBs and the handler's specific
> list of FLB dependencies.
>
> Read locks are used during concurrent list traversals (e.g., during
> preservation and serialization). Write locks are taken during registration
> and unregistration.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

