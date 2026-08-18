Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 973CBC5DF80
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ED526B0200; Tue, 18 Aug 2026 05:03:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89DE76B024E; Tue, 18 Aug 2026 05:03:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766956B0250; Tue, 18 Aug 2026 05:03:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4399D6B0200
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:03:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E23540B8A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:03:34 +0000 (UTC)
X-FDA: 85113801948.02.81FA24A
Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	by imf04.hostedemail.com (Postfix) with ESMTP id 123F540003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:03:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=WPZZoKGM;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="N YaRi+T";
	spf=pass (imf04.hostedemail.com: domain of contact@jaseg.de designates 103.168.172.143 as permitted sender) smtp.mailfrom=contact@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787043812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZX1CnQZZsg94K1w9ifnkc6/NmgcRySaktgXNfBgb7AQ=;
	b=CRZARl5axa/mvtobFzvOnzlQba8cXvY8K6NTt0Tr1uuVc491SbxuCpJk7+RC871myS9V/J
	38DbTgMulptGD7k6oZyWfyknIkOPyh+65QXtfMGTzz8KibJTCjJOS1ByIwmO3vt4tYlc0M
	87W7tnN7REhperkX7fwwp+WU91u9vGo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=WPZZoKGM;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="N YaRi+T";
	spf=pass (imf04.hostedemail.com: domain of contact@jaseg.de designates 103.168.172.143 as permitted sender) smtp.mailfrom=contact@jaseg.de;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787043812;
	b=eXgxIus8DAE9T/3SmyEU9Y0l8yP650ZESb5Jjg8abR0EIEHDkIdOs+2hbuD871QhvOrWcD
	uSRVqzHvFeA8zeSsQWMqIhmvKIqr4cYy6KVWS9Yvxp5IQQhzqfFckoIjoxrCTvzGU+smFB
	XSpYxeEU+gD9nVmcZ5CpPJLuZszwKZc=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.phl.internal (Postfix) with ESMTP id 5C82F1380244;
	Tue, 18 Aug 2026 05:03:31 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 18 Aug 2026 05:03:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1787043811;
	 x=1787051011; bh=ZX1CnQZZsg94K1w9ifnkc6/NmgcRySaktgXNfBgb7AQ=; b=
	WPZZoKGM/D3I5ywu6hWxeUzIxxVJ8JaogWauiMKsZIA9L+2KD8F1opSZimhHAVKL
	5a0sb6E7AE1N+ZTNYCeJQBZ+m2FEM4CV7GMsqbHBUWfOHXeEjAaQ1OAiBbBbW59J
	b1PhzIsGrQ2x+2Dni2rvrHfHUrqMx08mPCwM/2bfa9SldiuOZjcpcWOlGE1HpOcd
	G0YIdXoV0HVGd4L+mxlNmNNDIhof5BifyFVcHuhiep66N7ofIvUZTm6prDYrlyWK
	zAEmkzqJ+outKDKC0CHUxyq53gCJ6k58wqWemTPbG92+4A3wfTcxtWmA675wMRHC
	QYOZU0KDnVhgr69AP0V0Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787043811; x=
	1787051011; bh=ZX1CnQZZsg94K1w9ifnkc6/NmgcRySaktgXNfBgb7AQ=; b=N
	YaRi+TSIddvpqgRTVgxa6VkeBfERJbKBvbyZhIzfXNJys/mMTEU1csXrJL5DGzbN
	PCKZKgL431iiunzQQDBvFuzWW69BqYCSsFA5vAr0RhpoL1B1z9aPTFCNw7/QA19A
	saZ0S0t62u9ilibZlZt1i/7WvU/qVXs+q65oY7JWrtfuouhLYcwOK4sxpw9so70V
	0/BgQw+DhldDFVQAVyvQgDYSDnmVHgBz/o60QfvZIbIrNu09JczWI0nsBqGFZNEN
	5UPYGIzCosYhlot0IWvFxAqjKXNQIIe5Nc3jckxMBZ736pOuOvMzIar47qPI4WKI
	FVKhOCCNDBW0c2jXhd1ZA==
X-ME-Sender: <xms:4B-EauM8Y-WoFhcHV7CDKlTqAXtB-K4KRmaH8Ji1IGVdeubq9ketyQ>
    <xme:4B-Ealztkx_kES_mWsN78pZXU9JB54Mew-argE8U363HXR6ZZcMDZrZ1r7KLZayGA
    VUMOnw_bfE8_HFBnwIY6yzIzSIEfLRM4kpRnIw3jK-F75RiMw1zRw>
X-ME-Received: <xmr:4B-Ear2lM4JA7KsBrcTQX5tTYYYgKvP9cy4R-UIHarqqQ6wJIAuSBmfYB-cMSSdOV5yu6OXNk-afOhj4igKm>
X-ME-Proxy-Cause: dmFkZTFpA2CAQ9HsB/cHX0jgjtdDSxrlNaH1N5XdMBpyCH9Ywi6Hdh5ucTA96FWQa4HkQJ
    FvEd7sRFuzES1QTCCXc72OlhgrTRDpI/mv/2h44E6mQB5bIPt7uKTuP2q0GgZRoIvFIf7T
    TMZ3/nzGVeOohp8c3ZE54qSC9/YJNe9f6CUcVKmuTPT1A2+XUIsIivDdrhAHumwFv6AQfa
    NNzoFOD5IVmP3t/+TNxvkur2XMEg96QOc5X07R9jGlcw1D3FBObbnwVn6TapmMDjTj8mel
    XF3EW9HqD7I9ZDaJuBDS4ARPRSLFsySvU1MjYl98Znh+hLcqka5PZ2lKMDy4GytU3qjXHP
    98DJem6QpOGqfB3BYBGJDTFsCAtPWcw71a1t0bx+yVXLzQg/zX2eANVIW+Pof9QleQxvN9
    P/N2zoRmGcsxnzVAX9yilz5Hf18JYw9RDeTkD0e4hVVYoyZ9d7hMxsqFj8qpAc09VhOuqd
    r9AoF++WkVV8iSPyIp43mJ0TdeQR0JQhCzxLX9LtVsEaNESQdPbIT8kPTvzqYUZ7lqGq/k
    PEaZa2BEeR2Eln3RH9rkvTn6MqyAurRLUbA+ihdv70Bc4xu6lg5mm9xC/+Pb5HPANA2dOd
    Ytxl5ozIB8gbREK41rFGTIGGQ9URIpBxDMvfEg9AUeTxj19lPYQvx6jTJGSQ
X-ME-Proxy: <xmx:4B-EasH0JHdfdUJp3cw75hmN4JbAktp9qP7MbFjC7JV7n6UctIxhEg>
    <xmx:4B-EagKH8JC384TlH3cR7ulRAHL02wkXnaDo1V9ztrqMfX9MoWhZwg>
    <xmx:4B-EarwND5OYC8e2x_4D5dXRVAx5TKWwG_rdZqfJdmokI7UUzMRH2Q>
    <xmx:4B-Eai1Yt3SDtzatr_bnVyQU5MFRORQZ930EDB5uwIJ17WKuX-K8FQ>
    <xmx:4x-EahEHf5VCv1VRvxU22t6K4tWi1wKnPfuGOHSqlSCXyfMxLQLJcyjV>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 18 Aug 2026 05:03:21 -0400 (EDT)
Message-ID: <9071e03b-a633-43e4-ac77-3b05291c1f66@jaseg.de>
Date: Tue, 18 Aug 2026 11:03:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/13] kexec: add CRASH_WIPE_SECRETS to wipe secrets
 before kdump
To: Baoquan He <baoquan.he@linux.dev>, Lukas Wunner <lukas@wunner.de>
Cc: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Dave Young <ruirui.yang@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Ignat Korchagin <ignat@linux.win>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Keith Busch <kbusch@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>,
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 Marc Dionne <marc.dionne@auristor.com>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, kexec@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, keyrings@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-nfs@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-afs@lists.infradead.org,
 netdev@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev
References: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
 <20260811-crash-zeroize-rework-v2-1-9561d13c2340@jaseg.de>
 <anw9ILJiO5xIjP4f@MiWiFi-R3L-srv>
 <9765f7ea-36bb-4c7b-a19b-7facec97b762@jaseg.de> <aoGpcczo5GkBsPwt@wunner.de>
 <aoK6jXA-tF9qfKOZ@MiWiFi-R3L-srv> <aoLFai0gzzH2bGgy@MiWiFi-R3L-srv>
Content-Language: en-US
From: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <contact@jaseg.de>
In-Reply-To: <aoLFai0gzzH2bGgy@MiWiFi-R3L-srv>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: meoc4ixsznju4mccq3d74ann53an6k5u
X-Rspamd-Queue-Id: 123F540003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787043811-446704
X-HE-Meta: U2FsdGVkX19FED6IoNuXvlCS/aT+2b4KSl+JiGLpJ9F040Srd3UfYJyVvq0cLrMLOAV5RzORghlmKEU8qHvHrzc5feYceTVOMNhT0i9ouDwDx5BU32WuV4XdCp8WD+Is6ohLXKS3cdM92qea8Ep4E3lNkmrzt1WrdQMOjtoyiPPpYY7KNW6bSq/f6Cf+Km18x3LKy6g4c8swpGkujobrKwJQOIbU3lGUwR7GCti+CT+MNNezpPyvnbxQI5Y3hKkOHIxSWzGptpuRcly1bZqyq982NwUnFo79stqZOkefPQGmmM7rRhwHxWy3cpK6ccEYkQqk7OezuXgb40Y9cxB5AUYIprNbVrwRknZBN6zGFzCCxXCu7Xu3PHGJd8yDz4UJVo95YsyarQcS7KmP5izluVcSbTz+b6BAfaj6bri+7zXY8+4LDMS7GgiCR+dLvHNkg9b9FsVEIx9yezEs//cBOli/nywZNmzpyGcGAhw2fcA657hA6K3eEKv+DCuEm/aosbWa8MR82tD2tZ/82Zw8Y10TXBri3gvSs0opEL2mZYkqdvi0O/tiwX/w7zb4SaqKDDi/3m+Hpp1T+kliHRjW1+0wdt51IhW+HUr6SPxRYiGcNJcuGDab8niwvlI90sT9o3Wi0UqUADrtDp6y3A8rFij9uECUoUdQnAx29ljnX6rK5G2iPgxqD21oDXTTGfWfbaka4SSU1ZgQM9lFEsNTokg9pwE4BBihPA2A7565pBYxglQKwjOrJZX7C0KEvUmnz5nuEVBTk7MUA0BE+fsVjRhhKZTftsSjg+DvYbvyRO2KBnsQWacsVX2dMMgEANVZwRArMkXnJjZ/Jb5JX0TLvVIi1hNd4Jyi+O8Y1R8tKHcSYU8Gpbu74lgAxqjrzTCpHe5+Y/DmNAfsGht7jAosjBYAm1qqKYvJKnq/uNtMv98Z5qasXRuE2Yh8bvT3TaKOxMuNtQGvxOOotdYISnK
 AJMdYw1U
 7aV+9t+hWq4bIa6Di6FxNkywGPoGXRcAx6/8LV1JpYydq2yo6SM8qI933eMhFcjIJSuixf8U1Lho/sNhGbbqUALR/xPJh7fsMNqY/B5kSAkn3VRTYMjlIHlkVbK90AzrTRDGgGmkP0rESkd6Pz/LAJM6LYKqvz6RVwhxCP1j7kqUHZ/82jzX9lNAPVek1iQKyo5vuURUCw87Y0Vebt1I1MVpZ0GiN6cemiU9+VJWmmsojRrqvASRi7tBYPHvQZPey9tMhOK0dIz/iRmtH+R+WAwPiR6GQEkWpDBZ3SAHOv2kQ1YCbC1HPxab40Of1K4ux9eWyMnb5WA6/3Y6pbcI8bI1smoOpsavt8UcunjhKjGSxv+kp6jvC6x9cHwlD9on6WtKLFzQFgf/7KeM/xZAuiPcJW0DPgsD/lQpxoAH+Yvdt0SP8QvSfXmJmjf1AGKG5iMaP7UbL84HJBjvPQ1Xgxn6cbFQumwEHcIiUAXe2Br+iSyTm8bRSR3uZlhFDl04dGET+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/17/26 10:25, Baoquan He wrote:
> On 08/17/26 at 03:38pm, Baoquan He wrote:
>> On 08/16/26 at 02:13pm, Lukas Wunner wrote:
>>> On Wed, Aug 12, 2026 at 12:08:39PM +0200, Jan Sebastian Götte wrote:
>>>> I can imagine one alternative way to approach this, tell me what you think:
>>>> Instead of registering wipe handlers that memzero places on panic, I could
>>>> put an optional registry of (addr, len) descriptors into crashkernel memory
>>>> that the original kernel populates with the PAs of buffers to clear ahead of
>>>> time. Then the kdump kernel could do the actual memzero. This would remove
>>>> all code from the actual kdump path here. The registry could be made
>>>> per-core to avoid locks.
> 
> If this has to be done in kernel, your (addr, len) registry idea is a
> better direction, and we can make it a bit more general.
> 
> Instead of a secrets-only wipe registry, consider a small "crash memory
> region" table with an action per entry:
> 
> enum crash_region_action {
>      CRASH_REG_WIPE,   /* memzero, then dump normally (leave zeros) */
>      CRASH_REG_SKIP,   /* do not include in the vmcore at all */
> };
> 
> struct crash_region {
>      phys_addr_t addr;
>      size_t      len;
>      enum crash_region_action action;
> };
> 
> void crash_reg_add(phys_addr_t addr, size_t len,
>                     enum crash_region_action action);
> void crash_reg_del(phys_addr_t addr, size_t len);
> 
> Two actions because the use cases differ:
> 
> - WIPE is what you need: zero the secret,
> - SKIP covers things people do not want in the dump at all
>     — Registering as SKIP reduce dump size. I have been considering how
>       to shrink vmcore size on some big system with huge memory, the
>       vmcore size usually is several or tens of GB.
> 
> If this is OK to you, you can start a regiestry table
> infrastructure with wiping secrets, we can add SKIP later and plus some
> driver used memory.
> 
> I am not sure if it's satisfactory, but you can give it a shot to show
> what it looks like.
I think that's a good idea. I'll post a patch adding that registry this 
or next week.

Thanks,
Jan


