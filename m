Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04D0AC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5F0A6B00FA; Wed, 12 Aug 2026 05:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C101A6B00FB; Wed, 12 Aug 2026 05:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFEE76B00FC; Wed, 12 Aug 2026 05:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 809E06B00FA
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:57:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE73812019D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:57:13 +0000 (UTC)
X-FDA: 85092164346.30.5FC1DA8
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf24.hostedemail.com (Postfix) with ESMTP id E41CF180009
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:57:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=ZWurAWcr;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="j nFJzft";
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of contact@jaseg.de designates 103.168.172.142 as permitted sender) smtp.mailfrom=contact@jaseg.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786528632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EhHKwdKM1yc/CfVWe4UOIDuPAVGA3p3ZiR3TRLo68EY=;
	b=E26iKP9x8lcIiWGg73z+WZJbn/tdJrnpXQgbZIcoKws3q905lKdnlYwlc223N+fj3ZtcLR
	QMMkhgNKyPthz3Tv9plKKIpYsAxXqoV8QbrN+ns1+vTp0JAAdd5K3M6OzPv/rvMI2rO+3g
	BFM5RKnnfRJokpAMyQPdDnNKbpcirwc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=ZWurAWcr;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="j nFJzft";
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of contact@jaseg.de designates 103.168.172.142 as permitted sender) smtp.mailfrom=contact@jaseg.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786528632;
	b=BtXHnTOoiSdlE1jzjnxZTdZDUQs7lTftWFAW7WeSE01cTmxXETxw2XAxfmTQpa/QsY8FEc
	niPgHDDdf4h+BjHQ7i9VjOEHiQXv5x3jY2iFENf9xBLreoh153Yj5IBgWzXfwqtU3WmQht
	zeIJZpyTsIHGAUWMulE5tgjFu3Nw2Bo=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.phl.internal (Postfix) with ESMTP id 3C9FD1380188;
	Wed, 12 Aug 2026 05:57:11 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 12 Aug 2026 05:57:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1786528631;
	 x=1786535831; bh=EhHKwdKM1yc/CfVWe4UOIDuPAVGA3p3ZiR3TRLo68EY=; b=
	ZWurAWcrO5oZdtEPmZtocYvy6AV01AahFXUyTdHsT0+DJwJJrfSK0XQBWf4CNmxi
	JWHrdfN8DiWC8vUKb/jJzPWGzQDCPMGFjDPajtnKN3N1uLnVtYyIzllHAjBmmvYN
	HdtTXSyy+6cgcE/GYna4jIGNzn0zTfnRmAeHvc/KSQhSF19nZAqT2Y0dGe0oRWJ8
	OcJWO1LS1UCXQ7cvITgclieSIJAIPF6DK77jiuh9Upms/QmSAIMAwZ3+Tt/I4ltz
	yiktEDVxZhTYHmU4USUsev3A4H+F4LGpGd1S+/3Cq/j3cD/WRZZwfGjyc3U1oTzf
	WYZedHoU963WaJO2FqmTKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786528631; x=
	1786535831; bh=EhHKwdKM1yc/CfVWe4UOIDuPAVGA3p3ZiR3TRLo68EY=; b=j
	nFJzftoUyOhx0iuIsp809iKT+Vl5BM7p4K21mivtVLaE0Q3O/axViMtkHhq0PNx8
	fnPUPUqWOil5GNeG1qX5kc2x1H1y8SBNGuSMKphq6Cp+eI1jmXmFm5w11mlNLp/H
	Q8WRc4xU5Sm5KdidKmAbs+cVZ6KKytmxd390MreUAK4+A9saBgdrOIcEhTcM9zma
	ijVk3zVDSyLCkUR84HCt40x6MEsvtKO+Qjuwf2m/l8pQXK/JOCPfskJscMvc5vWH
	4IBHN+wdv5DpzLz+V8C6hZ/ZAaLSDJUMjMKPr1Z0eRjBE3Bsp9Gyak+5RKR+uAMi
	uMUgF60LOJws9qOdZMiyQ==
X-ME-Sender: <xms:dUN8akp1LtgF57mkMifyjGWooDezmto2YOXMyfBugosGI-EhK6TgbQ>
    <xme:dUN8ahW94MRFVaDZxI_WFQYULpafOYFTyR32ZrcMs3nz1ENZPkbGc1n9lm2XMvz9y
    B60n1Bgd9BOjm4dSuxm7nWkB-eqYwDGyZVqV-ogZ4DjQEEJy-82BU0>
X-ME-Received: <xmr:dUN8ajYuucSdJiCHU9oRJJINGse1tOWKmr52dSrvuX5E6UtoWaZ3vmNpz5gDeG8p6t2yL_k-csynv8K_Ty1VN6E>
X-ME-Proxy-Cause: dmFkZTFnqHB+QAaKfDQjW9D4jGyVFcpA4ZfYq+XsdCheHQ1Cv+90Ot8B4MS4g5RXsHrbcY
    gkt1BA1rw9cagEz/S0Ac2U7EsqF7DLCgLpCkDa3C3WCjc3GZUwmc8bAjltKjJg0QKxG+Ph
    rCspg0M4YQ8Fy4cHxWZ/khO1XnIDW+6xK0bHpn2Lq6jz2nni7TmGeqVE1rgVRKTf1WXo85
    MVmoAxHTC/Z1NGMQVl+rPEBclzLpstBKfZAeNsWOWqzlnZ+3zsPux/r2Jct9Z8fJu7q8WC
    SulO5qzLxjLLfZSlQmmTNVxiMNXhFc6dPqOOXyoB3oNdktGtJaiAQoajvh6xJX5DSgT1bO
    WUTjoUPf0j0DZZkAWs5IwNekrtaIiQmJ2dlG9RvXqn8bjfwwOq8hcbNNvw0LRe1efISe8I
    15xJstyd7QgXtyqSN+1wHnSOBY141cLgwg0PgyvSXXSEBnPc9LzFoY+X5ZnH3CFu4XSvtp
    KWPwMN9WL4yL8fZ8F0qzgZ29rFA1zMENVBaBghXUMQPRsQpFce2otNqARuI8aXSPMwx6/D
    MeyBNNwe6M2Li4+tZoEpDORU338B8LESQJBvfQuokfJx6E2P6S3FSx4EnwYIA982P8d8+1
    wcEuaRezgU4FT+SyMbJHMrw4hZ9cMBP0nlxhyvYbffJ267v7eqGfbxx+rO1A
X-ME-Proxy: <xmx:dUN8ashOKqdbSREO4OhcBfuqehnSCJlMy2cq4ssM8S3OJkH7LfDiUw>
    <xmx:dUN8anrEBBRoAoDpuO7jWY4FJMu9GcTvmXAzItNMPB5gWIPanbcZjQ>
    <xmx:dUN8aoUVQT0F4EubYVwtGqEJg9AXbMVlPLQ3itWQ2HIHge51WBR2Ag>
    <xmx:dUN8aor8VZw9gKb62idBD1DVFey6ThUyP4isRVDtfutcsNOAahB_aw>
    <xmx:d0N8av6L8ecf0NiQyi07oEvZGVap3m5iH2aoSzwRsMwHVxu_ypMg_olu>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 05:57:01 -0400 (EDT)
Message-ID: <c5376b88-cc68-420a-ad8f-d494db9c7b1b@jaseg.de>
Date: Wed, 12 Aug 2026 11:56:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/13] dm crypt: wipe key material before kdump
To: Milan Broz <gmazyland@gmail.com>, =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?=
 <linux@jaseg.de>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 keyrings@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-nfs@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-afs@lists.infradead.org,
 netdev@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Dave Young <ruirui.yang@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Lukas Wunner <lukas@wunner.de>,
 Ignat Korchagin <ignat@linux.win>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Keith Busch <kbusch@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Marc Dionne <marc.dionne@auristor.com>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
References: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
 <20260811-crash-zeroize-rework-v2-13-9561d13c2340@jaseg.de>
 <8654c2d4-8d9d-43f5-9256-adf2915209e9@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <contact@jaseg.de>
In-Reply-To: <8654c2d4-8d9d-43f5-9256-adf2915209e9@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4qr3sh8xkjnayudy1g199qsmzdnunfig
X-Rspamd-Queue-Id: E41CF180009
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786528631-273369
X-HE-Meta: U2FsdGVkX18/UFiksVKfRwT4KPReTvyJBWGqqXwLdBpjX+ZgIA55szhhMaZDlLoPXLJQgI0YG831Kk9sRWeloh6wMSmPQJrkdK22HXXg2vTSbHkEdpZaZO9KU/gR/yVouKkQj4zb+vadNwSbVM/IWCaaeqzBF1mBVpgSjTneS0cL1ga9mRcinEp4sfSYO0eNUf0N0ZauXo1Ug62aS4zamUAp1G9Y8XXJKLVNkHe3ntkqUNrsx9PKqZ5vKaqLF5U8xgSdJsj/YsUwG3BGGfl7F8lVBmIELbffOqXuU9Qzt+kMBZIJ6JEYhG7ELUSgyzbLoqBH/trfrQXKhVi9Y9d5hwQWr6GfynasvB0iwqaEhcoPcEhICsS4yG3ijCcmoB1LsRtCCtM7GUFY3itoEgCWZNpg+WICxdTxZGrtw1ZKiWjeCekdsa+/ntexo3zdm4tldACanbQWAFtaprO87LnZ5mdXCTqVnrfIC+r6QR0kjBD3XTY0ZZlBZjAFNzpXsEJC6zdhh7cpv5KEToriR7kQN1YZdlDvp+sHU5CjLgmuyV6DBzf4Pq4Ruq3h2jty+e0MAoDlxMoJD3PzvtEN9sOK4kKDHC9RMi0IxZgMkal8GiQ4zunpA5OeokRMeasoMXJ9wYkrVucCigjSHQx/MoKFs6EmN1sz3DRTACsk9wWnC4SZ2CH3EDasd23uEl6wsgTYAti9Khz17cUnjSEn8DbyCuf/uhRz0TemBkaE6Ch2Vaxbjg4bmLNZRTbrt0Da9oVCcI20+LpLN7RD1ZoCZmjM80smfdrUw+YACSxprhS7kLzagvJbuFocI40XaJaIA3zvT33lhxFHJLId1N5AG80w1wK5xD0j1X4DIvIHqWqKeNAFKU6C0IZsHZqtr2GYApKhnJnvZ49gjyINxrrbhebEAVwWyrYSOaXF11x7BjhgjtJUUZY38sHIvgRFHdFNFD7nrRmcO97yyRb9RqFjOk6
 T75RpBFj
 tEY0d+tSoJ22DkWKzB1EIipOrcw5rvHsMzBmbjfFOBksg7mMPV/B+8WN6GMoIc8AbQ5CU1ahCs/25jjP+qMt3FIZOFY1maiN8p2fowOhXFqNu7BytuwRiCRAvRE+ojjlCqmarIJTDe7KzzpywVJu9gd/tN46i3oqlsDHX/of896LA+kHSTvQyQ683nhvczdvJrdMsXbjGpdz5Kg4qk4qQuvb5Df+5PaA1YVGc4DWfBOvTrdkf1QdMpz3oomdddfGLA3qAr+J3k5yMsj1BT0vzXtMcSKCWxCPCbK0V3BVFsiuZ0zWzyo32qok+3aCRO2wQ5k21oJ1Jv1JFLGekLlwbLb60YGfFx+8eJDHp+grYMv+rsWGM6cyz1hK+bitc+zWSJduwAf0xyq8/ww4BNyptSpqN6UwPv4MFrdQAIJ+IFDgZQjO0Xop0Dn9flG9q4TEg3iqWXg9yyk+rqhs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 22:18, Milan Broz wrote:
> On 8/11/26 7:53 PM, Jan Sebastian GÃ¶tte wrote:
>> Wipe volume key/iv copies kept by dm-crypt with
>> CONFIG_CRASH_WIPE_SECRETS. The backend tfms are already handled
>> separately.
>>
>> Add a list tracking struct crypt_config instances when
>> CONFIG_CRASH_WIPE_SECRETS is set. Structs are tracked here to avoid
>> having to enumerate them through some roundabout way before kdump, when
>> we can't safely take locks anymore.
> 
> Well, dm-crypt has crypt_wipe_key(), which can be called through a 
> device-mapper message.
> It also sets keys to zero in the crypto API.
> 
> Why do we need yet another way to wipe keys here, reimplementing 
> everything twice?
> 
> I can imagine an emergency wrapper callback that will suspend dm-crypt 
> and call existing code.

I originally decided I'd keep these function separate since you can't 
rely on memory allocation/freeing to work during panic. crypt_wipe_key 
currently calls kfree_sensitive, and inside crypto_*_setkey there's also 
kalloc/kfree calls hiding.

I could rework the patch to call into crypt_wipe_key, but I'd have to 
make that avoid memory allocation/freeing. The direct kfree_sensitive 
call can be replaced with a memzero_explicit, but I think I'd have to 
add a dedicated "wipe without allocations" function to the crypto 
backends as an alternative to setkey with a zero key.

>> Use custom wipe handlers even for things like ivs that have existing
>> wipe functions elsewhere because we need to use crash_wipe_memzero
>> instead of memzero_explicit. The crash_wipe helper memzero_explicit's
>> the target buffers and flushes data caches. On ARM64, missing that cache
>> flush could lead to the zeros not being written to DRAM before the kdump
>> code turns off the data caches moments later.
> 
> Please no. It looks to me like you are trying to fix this on the wrong 
> layer.
> This way everyone will need their own memzero...

You're probably right. I'll remove this from the next version and make 
sure the caches are flushed properly during kexec instead.

 > Dunno, but I really do not like dm-crypt becoming completely bloated 
 > with code
> that has nothing to do with the original purpose of this driver.

I feel like "delete key quick" is a pretty normal function for crypto code.

