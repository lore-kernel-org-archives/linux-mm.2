Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09EFFF8FA7B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 14:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9CC6B0089; Tue, 21 Apr 2026 10:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9BE6B008A; Tue, 21 Apr 2026 10:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571F36B008C; Tue, 21 Apr 2026 10:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 426AB6B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:06:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE2265D5D2
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:06:31 +0000 (UTC)
X-FDA: 84682738182.10.1866544
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id EC3D84001B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:06:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M87GVt0o;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776780390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4xGrtscn802UXL6MBpynsI31x4BBY9WiKVH5ZwMOtw=;
	b=iu5HabFmc30QjUaDCi9DF65+vadClCmVuOXoUUDBdM8oCcH0NdvDShxShmst6vKUpwM1jZ
	W7W7J1F8v2fD0qgkdlY9mt0LCWWA5jMITCfZTHqUMp5KD+ppLTL3aFIF8oZdk/aDuogjsk
	+5P1bHNu+d7GpxFKrRNIcPhgsg5BCHA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M87GVt0o;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776780390; a=rsa-sha256;
	cv=none;
	b=HZN/jwbUvkI/xMlje+TC3M3z7sMpMmMMzuXrRFgnNAadA4YbmSeJQfB9hjDHDm9iuERFYf
	p8g3alsjLT5dLIMqrWMC0/576a05agDqUSMFOu9+V+fuhvg1kW1Ma6jupWcbMC2bmXQweQ
	wX4uXIjG4Tg8uliPG/YR7wJCtwszESc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 51A3E600AE;
	Tue, 21 Apr 2026 14:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C768BC2BCB0;
	Tue, 21 Apr 2026 14:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776780389;
	bh=KLkU2JaKNWfaB+72rvS+Uc2eWx57bAkCQqfvhEhX1Qc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M87GVt0op0cOWVFk+tFWcrm8TrcbedF7DeBnwyT8lgMWIsiK4r8n+rXttk73jxkge
	 d4B4z7Kerd43S3Oc3qwwKqnld3me9RXV9lFBcWya2N37p0Wa9HCbt7qhlsVNrXyUHZ
	 drv+c2aQB6wyEMm3CoilddIL+FGQdEp0Blt6FLky1zQh8qsNPQUHdq/0d2gkpAUn1p
	 +QbGZScd0MjKdBHY3+Fbf65nkX3VShTSY0Ph/9jMJK0LYeORR/iiTWq60h1waIffS9
	 DJ1vAIdM1Vu6Pax9nINvqHUgvW/GpmjYcr6mpJui2LphwLGptjRaWfYhpxrYYGVDGM
	 D+QcYPRlJKhDw==
Message-ID: <e48748ff-0fcd-4561-9958-124dd853e70a@kernel.org>
Date: Tue, 21 Apr 2026 16:06:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] WARNING in workingset_activation triggered by KVM page
 fault path on Linux 7.0.0-08391-g1d51b370a0f8
To: Zw Tang <shicenci@gmail.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 seanjc@google.com
References: <CAPHJ_VJGTsRDc7_Kv0oDObuDX2pJ0evcAvH-mnD_RYMX536+mw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAPHJ_VJGTsRDc7_Kv0oDObuDX2pJ0evcAvH-mnD_RYMX536+mw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EC3D84001B
X-Stat-Signature: fktxznt6i8797p81rwtdgny9kthja9ou
X-Rspam-User: 
X-HE-Tag: 1776780389-382455
X-HE-Meta: U2FsdGVkX1+24ZF+oCdQ6Cd3GP6MQnAGT828aNq2+jr/RFRuD/QEDUMmBMG7iHANecd2LkdZlhKf7OAftJznGueC9yP9I9sAjyRpaRgvn/XmNMXTkCGZaxBoqn81exx9qnG4vYQYlh9IlcD3tiGolP5D2Ph2kLGWHbbsw5EndfbF3UIJDWpP8UtYk4mGNdXl8hAHlUcfz0U8Ya7dOfmZd0SUcrxJWmExAv2leVQ0r2XywYomtFSTQ2hyh/AhnhE9LZP/m6DuxTwS9i9zkat47jdMqOwz6D2Yj9wmaVhlyF2chdpd3+3hqAQufwL5Jfp78Dl46J+0ah3xSvTT3y0qUQW+2uf2HDG4VPPKfGYxoe+/YtguvOkv3vNGLcZbRcaEBThNYxT/0gJOrANlYmlKAawrrqld3/qqGMrW/MQZ34tvlMmj9GFSkgm0DsuBoZy9gFfOfFT8qPA+geTi3loemwPyoIy3M05OYEbb5T5yU+EzoJE53xeqh8WkfA9IguXYjeIBP2YTaAFKB7a5dXHTGzdm3iQOldgPZnkq7HCdOR/0pJjFNtd+Gt0xFyViizCx/u6pvQD6rXvV56tGWlqMbplqRX5YXRQh3mlSr1OctnoAeWFwLa5RHT0K0aovzFHDdxqakRCDQriYe3E3yiyo9BjA+djVtBBceQwKcU7okcy0/+vUAwPC5sH8fjqwXg1IcVh9y0CeoMrolt+GmGrK2C8eEPazTHvtZoo0lOoewGIbDTQM2cU+QFpxIZ39vZ9doVrbn9ScW+wl+7TwuSoN5iDM8izCZbhE30edTw6glvDilRLQW6328UAUv63wM3GWBTeee2XyFrj4Kym6bo9TEFSLrwgS8251OoJVchm0BfvFOpocSGnjigznL1/1QAKutC7JbGlG2mcdE1vXRxY1pzAGRKeYIzVuda/udyxNE6Vp8Skvya8CjUl68qvxWFqCSHM8SD31eSzub2KY0Gf
 q1IqdSR+
 jsgTyn4RCRrhKxzIgriX0cwsWgOMwJxP2wtsve3M/d73BVxpj3OSKoXm3nEodQej6WKXo0Wjz+i8xU733YI0EojrGJU+ZXEaL9tRtz+kZVxhweDwrSGe3S5xWkF9bMD1NHHOqg/LVfI34N2FlQ2VKJPGmHrXWLB1qMsI+MR9cDmFK6UITXZMyDvWIrC6+7Sejhv/mqQRdEmkjrt0ZYFFcBbTX+sECwgrc6EET/xSrdCecc0ssKchB4kcpSM1m0bPp7NIXRlu6K/+g8h41V+GoTN4ilAZ413xswUAaFz6kLaqQGdY00Kbr2Onf/BiHqqqBTlgiiVYNhNaZXwk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 13:17, Zw Tang wrote:
> Hi,
> 
> I am reporting a WARNING in workingset_activation() triggered by a
> syzkaller C reproducer on Linux 7.0.0-08391-g1d51b370a0f8.

g1d51b370a0f8 is not a known git commit id.

Do you have an upstream git commit where the line number
include/linux/memcontrol.h:381 makes sense?


-- 
Cheers,

David

