Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 903B7606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 01:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=sina.com header.i=@sina.com header.a=rsa-sha256 header.s=201208 header.b=WatzQVmK
Received: by kanga.kvack.org (Postfix)
	id 41E486B05B0; Sat, 24 Oct 2026 21:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CEA46B05B1; Sat, 24 Oct 2026 21:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4086B05B2; Sat, 24 Oct 2026 21:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3D906B05B0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 21:11:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 09ACD1A04C0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 01:11:48 +0000 (UTC)
X-FDA: 85359371496.15.0D004F4
Received: from smtp153-171.sina.com.cn (smtp153-171.sina.com.cn [61.135.153.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 46ED4100005
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 01:11:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=WatzQVmK;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf14.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.171 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792890706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q8QjgI+cguG7bWbedFj22oT8cvaLq++BS/0yoHckLkk=;
	b=YXHCfD18PDe2+0PACayVcQyvyYelrx6+qrVMZjmY6D32Y0kx2RcSvB8UgAowIgxMIyHTE5
	gVSHlnn8FKZ7K5W4TG35cenUgqJAm4QYSjS9/YG9TcTt4nbJXrYise6xWaUkcGKOjCRwSN
	zrdIKm/upslrK6L6JH4Abqn3Rvn3wD4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=WatzQVmK;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf14.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.171 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792890706;
	b=BbyiiDkBA42OFY8U+OTbQ7+00eaUsRrjiaRjzzoPnFb0RQ8w2hISkqXjFeNyY7lCxF/ipC
	oiQ30V6+YZ5yu7fbXfRcfycfJzo/dwAbs5O92kpZ6R5QTpw1PR3rQDt8aKxzRwWQuMsM6b
	efVbEzaVX8qgLKiWOc3D/FSX+ThrSeo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1792890704;
	bh=Q8QjgI+cguG7bWbedFj22oT8cvaLq++BS/0yoHckLkk=;
	h=From:Subject:Date:Message-ID;
	b=WatzQVmK8F5eXoTxX9UG220qxvpN1JA94Z3YB7uqW46R6b51atuSzip7T1MeWwaj1
	 OfncNFYxrfHG4pC3bMRNh3x1yEwtiXboOJnVTNaOkuEwYNa7Rst82qH2b6hg2HGmMk
	 XlFRqkYsOS0aWV0ibT2WlwIQvIXet5PGRqNuUq6A=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.254.1.249])
	by sina.com (10.54.253.34) with ESMTP
	id 6ADD574800005F4F; Sun, 25 Oct 2026 09:11:39 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 4931906291679
X-SMAIL-UIID: 5492C95F558C4561AB8994FC81A21430-20261025-091139-1
From: Hillf Danton <hdanton@sina.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Barry Song <21cnbao@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v6 09/13] zram: split zcomp into separate R/W streams
Date: Sun, 25 Oct 2026 09:11:25 +0800
Message-ID: <20261025011126.1100-1-hdanton@sina.com>
In-Reply-To: <20261024101401.1035-1-hdanton@sina.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 46ED4100005
X-Rspam-User: 
X-Stat-Signature: aikredfaiudbkt5cfu589r1qo3cburrj
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792890703-799899
X-HE-Meta: U2FsdGVkX1+wjx8Ct9vmCYL8tyiL6Cnl9Wkcexqw/llkdCAPRYpPvrxA4OkqGdEAmfKqPNJ8ZOsnDLg0w/R+oI+oecXUvRqbpR942uotrXuJP5Fhm3tS7IRVR/MLtIyXyK9rexD+Q8qGShBhaj0UyQWsm3M4TsmNqJTxYFvOIknKTzQ+WQ1vqt+35oUx4OH4UrR13q7fvicN36gbtgZL2NlzAWcY/bNrLfPPuFYaAJHcBb9UhNxYizejGROEHbbr35RJ6+WcOIgdq2djcq+au9CiuclAGj8OrCTUS+RiSGBXqXj2qhCe2YaRLpwmycfmjc9REgpZoOCylYHQZyivrBV7BoY97qf/ysWdngjqiIwXzYhFUDOBC4bY5GCFXW+F2tNSIRKn44E1rZEhrh1lPwPmOLgG3VFLY0zI7OSAI+JgKTJf1O4cV/hRf/PhmmxKnmIY2LG8W1z8HZEiXZ2I7gGquS0plVl89cWeZhCO2h7B+Zvdp7LuZDsPj99ZmSfFCr6+1oN1yGTL5MjGBnS3EIpmv0IfmuOM2CS354kM1MN3IXyd7fCd6hDIgBDC6DMnD+bsHbd3VDOrjq7vtckbshOLqikWzu1nnwxY4JO9OY981oiX7yQVr3HcLckitqy9YBCMMP1WLdXwqyH58yM67TX37mQZ6JXtDobfnHHUL7OC3ADyDQ6wgxfHgTEN0DDt2SWYBIu7N2n8pp17CHUWNFxosID79qRTBlV3xGor5+DtAXugG0/zSBewDUkXydJEfxsRho8rqQLDuzhX3vFHzwKfMjE8BfVT9ztqUr+T86/Zxw9IUUP/B1WHFsHIr+SF9XnEMU7GKmmbo8382kG/H67RnM9kRdnmT/HCA5q20b5swo8cCb5dXwrBwMMWWI3Z+7ysi1sQRunRRLmZh4Jbl8OQzX96J6JC83YdVD01ilpx0j1sdPEQqVNiiSh4elPt5PtAxCCSscAAwCP0GAO
 wXFQlbBU
 uZ9wJY0QNGfGZLhb+Byghs5zH7cl5sCZRuwisBPGkb8FQ2R/5iYCyNdtceOM+V6bHw/xMhmCQAfAOeJUILppKZy2FdP/BoxP8z78uDD3UnkverdB4fn+j01RXNCvo8if78DZrOAIJ0NU6+kEWdahsQ1HpUpdTUrI5qc9BJIEjkoJwSimvx0PPH+l1A+dVgJOORtJQ3Uxfct5N1ICbiDYZ9UgVMNcwpKdrYio+vBt/T6aJjnpaBeKxIcH8gYqwiUmOvgE1lFOVW9WAQiIX+AFe/L5eWRAZA9jO4sduPweDJeOmEBQUtfqnAZArJMmO1yuon7ny78P1TXTV6NH32tiiSvSHbTv7vdsdHYw1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 24 Oct 2026 18:14:00 +0800 Hillf Danton wrote:
>On Sat, 24 Oct 2026 14:48:32 +0900 Sergey Senozhatsky wrote:
>> On (26/10/23 19:40), Hillf Danton wrote:
>> [..]
>> > > writers vs readers 3 runs
>> > > 
>> > >     BASE+PE     IOPS 1,271k  avg 5.57us  sd 1,393us  p99.99 27.5us  max 1,581,800us
>> > >                 IOPS 1,461k  avg 3.43us  sd    78us  p99.99 23.9us  max   227,015us
>> > >                 IOPS 1,444k  avg 3.48us  sd   222us  p99.99 23.9us  max   592,628us
>> > >     PATCHED+PE  IOPS 1,457k  avg 3.32us  sd    18us  p99.99 27.5us  max     5,620us
>> > >                 IOPS 1,464k  avg 3.31us  sd    17us  p99.99 24.2us  max     5,621us
>> > >                 IOPS 1,475k  avg 3.29us  sd    16us  p99.99 26.5us  max     5,620us
>> 
>> BASE+PE looked noisy, so I sat down and tested properly (also tested
>> zstd and various compression levels).
> 
> Lets see the data from another pov (feel free to disagree) -- in the android
> phone/car cockpit environment, the render frequence is required above 60HZ,
> IOW a frame rendered within 16ms, so what share of the 16ms does the IOPS
> account for after this patchset, for example when an app in background is
> brought foreground?
>
I mean cpu cycles are burned to reclaim pages, given zram and swapout/in, OTOH
given whatever a GPU, slow or fast, if it would take more than 16ms to render
a frame, then there is no cure for the dilemma.

