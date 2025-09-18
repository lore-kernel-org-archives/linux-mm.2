Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC0A9CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 08:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1D418E00BC; Thu, 18 Sep 2025 04:09:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEEFF8E0093; Thu, 18 Sep 2025 04:09:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB6078E00BC; Thu, 18 Sep 2025 04:09:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B508E8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:09:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 487411407F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:09:40 +0000 (UTC)
X-FDA: 83901646920.24.903CF54
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id CF90312000B
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:09:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DwN6EA6K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xQHagFR0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cgOgH0p2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DeKysdDT;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758182978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fwq+c1VbJtqEjRRCDuc4Q/kLfnEVxaOxAG10H4NX2vM=;
	b=ZTIfEkqC6CNadw7z81T99WpZ/tNWgS2BNBmNbcJh5HPUn6l4nNzAweSIAWa8TFzZd28AwR
	myUGczr+Yl+a6LEzpxNoYBSt6YZoiHLO0pLlar0VfP1I3QcK/j+JCFVn0ZTDfvs1nN8cwf
	Rgt0/tFJ7QRDlxreIpi7eNGgIi7bb6s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758182978; a=rsa-sha256;
	cv=none;
	b=C9f8M6k+E7M9gGW4Bf043G1ncACJZzGgaGLIHOPowpgtpPuaVfBH+EtQaX+7Ht80PbLYL7
	WbmJFCwxksngICgG+dtKm3rWA3CkXzVVtgkQUt1g6SDHw22aYyCm5RS+bBCVKub/3ZByqE
	ehfu5Kx3/hLxdSwSVrcOgwFJcao7aqs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DwN6EA6K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xQHagFR0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cgOgH0p2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DeKysdDT;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 067A733791;
	Thu, 18 Sep 2025 08:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758182976; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fwq+c1VbJtqEjRRCDuc4Q/kLfnEVxaOxAG10H4NX2vM=;
	b=DwN6EA6K0Fmwd0N6qwptiNuwBztI6153e/MTRoLHF3RFQtFoAM9hSmg4B/5ZsASrxYza5g
	jeSL79PlQVN2wDtqGzPB/nUI73FEY2wbztTC0lpZ1lihLwEbqAaPTIJ50gqqc8GyTs2yZh
	scyF6Xh5Z7829tjxwPzBTpzDNXQuYqA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758182976;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fwq+c1VbJtqEjRRCDuc4Q/kLfnEVxaOxAG10H4NX2vM=;
	b=xQHagFR0ySXf+ywlHYdx/4z9N3nvat+zF2G5Bxqd4yNGbnjD44o8Vly0GUCeHbxWYMasGX
	YF+62AJ56JNxckAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758182975; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fwq+c1VbJtqEjRRCDuc4Q/kLfnEVxaOxAG10H4NX2vM=;
	b=cgOgH0p2cLUcCt/GNR//P+ZqrdMpJ9+j6fD6hgQ4Ne1ARRd36gSlKbDbcIfyV660rXXGPn
	Sl6zYA84A7SHdnb8D2PZNAb/4w/NYAV7JDFBR1ZlVT9Z1h8G8pdXvPESkdMpES0b0GzA0H
	xmFVC2oriiqMLkmREASzuQTt5d75Aic=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758182975;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fwq+c1VbJtqEjRRCDuc4Q/kLfnEVxaOxAG10H4NX2vM=;
	b=DeKysdDTSOwdsmQSjDPZSBJwHNQN2eBVl6HMnorf54LN9/rQuiBplvnZt1Vt0B0W+FcUzy
	5g3kGBuCL4ltXeAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DB11113ABF;
	Thu, 18 Sep 2025 08:09:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4biEMz6+y2gXPgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 18 Sep 2025 08:09:34 +0000
Message-ID: <40461105-a344-444f-834b-9559b6644710@suse.cz>
Date: Thu, 18 Sep 2025 10:09:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu()
 operations
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org, "Paul E . McKenney" <paulmck@kernel.org>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <aMpxnACqmsQl-lp0@hyeyoo> <bbda8c25-b575-4e98-b1ae-b103c6598d38@suse.cz>
 <aMqcXyKRlZggLxu_@hyeyoo> <6f92eca3-863e-4b77-b2df-dc2752c0ff4e@suse.cz>
 <aMqyn6nenR8V_p1y@hyeyoo> <bf8b4741-1025-4cc8-b9ed-5b566bdcb2d7@suse.cz>
 <aMq40h5iOjj8K7cc@hyeyoo> <a32bd837-2597-43d0-9da3-1ce5a53b15f4@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSBWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBzdXNlLmN6PsLBlAQTAQoAPgIbAwULCQgHAwUVCgkICwUWAgMBAAIe
 AQIXgBYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJnyBr8BQka0IFQAAoJECJPp+fMgqZkqmMQ
 AIbGN95ptUMUvo6aAdhxaOCHXp1DfIBuIOK/zpx8ylY4pOwu3GRe4dQ8u4XS9gaZ96Gj4bC+
 jwWcSmn+TjtKW3rH1dRKopvC07tSJIGGVyw7ieV/5cbFffA8NL0ILowzVg8w1ipnz1VTkWDr
 2zcfslxJsJ6vhXw5/npcY0ldeC1E8f6UUoa4eyoskd70vO0wOAoGd02ZkJoox3F5ODM0kjHu
 Y97VLOa3GG66lh+ZEelVZEujHfKceCw9G3PMvEzyLFbXvSOigZQMdKzQ8D/OChwqig8wFBmV
 QCPS4yDdmZP3oeDHRjJ9jvMUKoYODiNKsl2F+xXwyRM2qoKRqFlhCn4usVd1+wmv9iLV8nPs
 2Db1ZIa49fJet3Sk3PN4bV1rAPuWvtbuTBN39Q/6MgkLTYHb84HyFKw14Rqe5YorrBLbF3rl
 M51Dpf6Egu1yTJDHCTEwePWug4XI11FT8lK0LNnHNpbhTCYRjX73iWOnFraJNcURld1jL1nV
 r/LRD+/e2gNtSTPK0Qkon6HcOBZnxRoqtazTU6YQRmGlT0v+rukj/cn5sToYibWLn+RoV1CE
 Qj6tApOiHBkpEsCzHGu+iDQ1WT0Idtdynst738f/uCeCMkdRu4WMZjteQaqvARFwCy3P/jpK
 uvzMtves5HvZw33ZwOtMCgbpce00DaET4y/UzsBNBFsZNTUBCACfQfpSsWJZyi+SHoRdVyX5
 J6rI7okc4+b571a7RXD5UhS9dlVRVVAtrU9ANSLqPTQKGVxHrqD39XSw8hxK61pw8p90pg4G
 /N3iuWEvyt+t0SxDDkClnGsDyRhlUyEWYFEoBrrCizbmahOUwqkJbNMfzj5Y7n7OIJOxNRkB
 IBOjPdF26dMP69BwePQao1M8Acrrex9sAHYjQGyVmReRjVEtv9iG4DoTsnIR3amKVk6si4Ea
 X/mrapJqSCcBUVYUFH8M7bsm4CSxier5ofy8jTEa/CfvkqpKThTMCQPNZKY7hke5qEq1CBk2
 wxhX48ZrJEFf1v3NuV3OimgsF2odzieNABEBAAHCwXwEGAEKACYCGwwWIQSpQNQ0mSwujpkQ
 PVAiT6fnzIKmZAUCZ8gcVAUJFhTonwAKCRAiT6fnzIKmZLY8D/9uo3Ut9yi2YCuASWxr7QQZ
 lJCViArjymbxYB5NdOeC50/0gnhK4pgdHlE2MdwF6o34x7TPFGpjNFvycZqccSQPJ/gibwNA
 zx3q9vJT4Vw+YbiyS53iSBLXMweeVV1Jd9IjAoL+EqB0cbxoFXvnjkvP1foiiF5r73jCd4PR
 rD+GoX5BZ7AZmFYmuJYBm28STM2NA6LhT0X+2su16f/HtummENKcMwom0hNu3MBNPUOrujtW
 khQrWcJNAAsy4yMoJ2Lw51T/5X5Hc7jQ9da9fyqu+phqlVtn70qpPvgWy4HRhr25fCAEXZDp
 xG4RNmTm+pqorHOqhBkI7wA7P/nyPo7ZEc3L+ZkQ37u0nlOyrjbNUniPGxPxv1imVq8IyycG
 AN5FaFxtiELK22gvudghLJaDiRBhn8/AhXc642/Z/yIpizE2xG4KU4AXzb6C+o7LX/WmmsWP
 Ly6jamSg6tvrdo4/e87lUedEqCtrp2o1xpn5zongf6cQkaLZKQcBQnPmgHO5OG8+50u88D9I
 rywqgzTUhHFKKF6/9L/lYtrNcHU8Z6Y4Ju/MLUiNYkmtrGIMnkjKCiRqlRrZE/v5YFHbayRD
 dJKXobXTtCBYpLJM4ZYRpGZXne/FAtWNe4KbNJJqxMvrTOrnIatPj8NhBVI0RSJRsbilh6TE
 m6M14QORSWTLRg==
In-Reply-To: <a32bd837-2597-43d0-9da3-1ce5a53b15f4@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CF90312000B
X-Stat-Signature: 8rzdyt9n68jxyiqgb8m1m1btrsp3eri8
X-Rspam-User: 
X-HE-Tag: 1758182977-576723
X-HE-Meta: U2FsdGVkX1/l5byHbQgOQ6sS282qQ4YFjXTjv7VAlapGmoVXPavwoQAmh1ooLLQ+ZnUpkSaldnVJiH+e9Q5mox1ZxY6JvKRP9Lm61ZaBANz7fxXOytAgYrkydld/ojG6y0Rd+946c8qqHBH6koMCoGINGPl8brMNHKCVfgQ5QXtAhHpb1fwlyavBiS4Jlogqgqy6DV1rOJYZK+4ymcAdIHo2Zv1h6z9fv+qOEl8SYN25Y9QNBlBIVhPcxdC+Rjf32Dqk6Vi8K7HhD5I/ietlzeERt2kGk/sLReZ7CqRH/yeWp4X+ryb61qy83Jln/GaSGfTp72a/SKDabbAdfAKLpvEcLmWv102TexdLWdT/glWuDq9MAyGUmKFOh7GwwkFnIgisROjy59o3dizZKaQFg1FIu/IHUIXcqaa/Fr47QekgtcTyoIyc19daOZgdEFfZ5QD7TULmlu+DsBo/mvLnXMFn3oOJHrV0JLCC6X7r22IgklRYy6siv9NOVRimN2USnPI4GXSoWJF4xnh/8ms8rRLmhDk4y9rV7usl7x4bZ6xCQNttW4az0Eh+cJTZCSGgDjiWv/Gof8HbOmRVk+wS3gcB5rT58ThIl/LV9ANuTCFHAUa8VhDFKo5VSOJSKW6NZBqWNicxwME/71hER0pp0m4hPE5Z10W2AVX0InPLBRi1zWSZ04vWDg5vY8Y2v2jTtJ5SDtJHiplUEU/q718E5axYWZbITRtGcMlw5uxwVUK7mzPEPetxa8SlhgiDMu0FZggl3hY36tKaxcvjDAZZHD8MZW9lOkumApDPldj52Nfsa8T/7qLakrIuZnXUJdal8OUai7qRrD2BcL7JMv4NfMcQRcK0myE/gkOqaS8GgAIEEAupb6L51vT+YK3CDu33QJKyLsS4UxLf9JCiGPhaxusa9Af2ZYBrcAl0NVk5DT6tdME3ssS1h2kSBZgd7c2GFBobriLEGKUKqYeuseu
 uPBhthoa
 Rbujk8KITAk6k1YI9WsMYtCmKIw471zcMQUiX9g6Ki0RtX/g2B990PxZ8zBCEJ8d8Yj8SLyDzltaovK16Fnj+fH7c1N6MoDQRq0gON1+5myrDT0320qgexZgJyRaJilhoqkDl3cLxfUXVFKoi9iF741izhalD4D22BOjC8NaXadg5Oy26YfEnk3Ndwl/76C3gKuK5YMaXiJmIsfZm3X3k29qXqHJLFoqBnkFQ7xvEBmrZJxvN9XbPuvjzCaHI2YPAs3bUYDc60uGeW21Sid79wriuyl4L35qnQeOCUT2WQh8MfnqUVzFZ9K4DJJwPyC5/t60pXW+iJk24COY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/25 16:14, Vlastimil Babka wrote:
> On 9/17/25 15:34, Harry Yoo wrote:
>> On Wed, Sep 17, 2025 at 03:21:31PM +0200, Vlastimil Babka wrote:
>>> On 9/17/25 15:07, Harry Yoo wrote:
>>> > On Wed, Sep 17, 2025 at 02:05:49PM +0200, Vlastimil Babka wrote:
>>> >> On 9/17/25 13:32, Harry Yoo wrote:
>>> >> > On Wed, Sep 17, 2025 at 11:55:10AM +0200, Vlastimil Babka wrote:
>>> >> >> On 9/17/25 10:30, Harry Yoo wrote:
>>> >> >> > On Wed, Sep 10, 2025 at 10:01:06AM +0200, Vlastimil Babka wrote:
>>> >> >> >> +				sfw->skip = true;
>>> >> >> >> +				continue;
>>> >> >> >> +			}
>>> >> >> >>
>>> >> >> >> +			INIT_WORK(&sfw->work, flush_rcu_sheaf);
>>> >> >> >> +			sfw->skip = false;
>>> >> >> >> +			sfw->s = s;
>>> >> >> >> +			queue_work_on(cpu, flushwq, &sfw->work);
>>> >> >> >> +			flushed = true;
>>> >> >> >> +		}
>>> >> >> >> +
>>> >> >> >> +		for_each_online_cpu(cpu) {
>>> >> >> >> +			sfw = &per_cpu(slub_flush, cpu);
>>> >> >> >> +			if (sfw->skip)
>>> >> >> >> +				continue;
>>> >> >> >> +			flush_work(&sfw->work);
>>> >> >> >> +		}
>>> >> >> >> +
>>> >> >> >> +		mutex_unlock(&flush_lock);
>>> >> >> >> +	}
>>> >> >> >> +
>>> >> >> >> +	mutex_unlock(&slab_mutex);
>>> >> >> >> +	cpus_read_unlock();
>>> >> >> >> +
>>> >> >> >> +	if (flushed)
>>> >> >> >> +		rcu_barrier();
>>> >> >> > 
>>> >> >> > I think we need to call rcu_barrier() even if flushed == false?
>>> >> >> > 
>>> >> >> > Maybe a kvfree_rcu()'d object was already waiting for the rcu callback to
>>> >> >> > be processed before flush_all_rcu_sheaves() is called, and
>>> >> >> > in flush_all_rcu_sheaves() we skipped all (cache, cpu) pairs,
>>> >> >> > so flushed == false but the rcu callback isn't processed yet
>>> >> >> > by the end of the function?
>>> >> >> > 
>>> >> >> > That sounds like a very unlikely to happen in a realistic scenario,
>>> >> >> > but still possible...
>>> >> >> 
>>> >> >> Yes also good point, will flush unconditionally.
>>> >> >> 
>>> >> >> Maybe in __kfree_rcu_sheaf() I should also move the call_rcu(...) before
>>> >> >> local_unlock().
>>> >> >>
>>> >> >> So we don't end up seeing a NULL pcs->rcu_free in
>>> >> >> flush_all_rcu_sheaves() because __kfree_rcu_sheaf() already set it to NULL,
>>> >> >> but didn't yet do the call_rcu() as it got preempted after local_unlock().
>>> >> > 
>>> >> > Makes sense to me.
>>> > 
>>> > Wait, I'm confused.
>>> > 
>>> > I think the caller of kvfree_rcu_barrier() should make sure that it's invoked
>>> > only after a kvfree_rcu(X, rhs) call has returned, if the caller expects
>>> > the object X to be freed before kvfree_rcu_barrier() returns?
>>> 
>>> Hmm, the caller of kvfree_rcu(X, rhs) might have returned without filling up
>>> the rcu_sheaf fully and thus without submitting it to call_rcu(), then
>>> migrated to another cpu. Then it calls kvfree_rcu_barrier() while another
>>> unrelated kvfree_rcu(X, rhs) call on the previous cpu is for the same
>>> kmem_cache (kvfree_rcu_barrier() is not only for cache destruction), fills
>>> up the rcu_sheaf fully and is about to call_rcu() on it. And since that
>>> sheaf also contains the object X, we should make sure that is flushed.
>> 
>> I was going to say "but we queue and wait for the flushing work to
>> complete, so the sheaf containing object X should be flushed?"
>> 
>> But nah, that's true only if we see pcs->rcu_free != NULL in
>> flush_all_rcu_sheaves().
>> 
>> You are right...
>> 
>> Hmm, maybe it's simpler to fix this by never skipping queueing the work
>> even when pcs->rcu_sheaf == NULL?
> 
> I guess it's simpler, yeah.

So what about this? The unconditional queueing should cover all races with
__kfree_rcu_sheaf() so there's just unconditional rcu_barrier() in the end.

From 0722b29fa1625b31c05d659d1d988ec882247b38 Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 3 Sep 2025 14:59:46 +0200
Subject: [PATCH] slab: add sheaf support for batching kfree_rcu() operations

Extend the sheaf infrastructure for more efficient kfree_rcu() handling.
For caches with sheaves, on each cpu maintain a rcu_free sheaf in
addition to main and spare sheaves.

kfree_rcu() operations will try to put objects on this sheaf. Once full,
the sheaf is detached and submitted to call_rcu() with a handler that
will try to put it in the barn, or flush to slab pages using bulk free,
when the barn is full. Then a new empty sheaf must be obtained to put
more objects there.

It's possible that no free sheaves are available to use for a new
rcu_free sheaf, and the allocation in kfree_rcu() context can only use
GFP_NOWAIT and thus may fail. In that case, fall back to the existing
kfree_rcu() implementation.

Expected advantages:
- batching the kfree_rcu() operations, that could eventually replace the
  existing batching
- sheaves can be reused for allocations via barn instead of being
  flushed to slabs, which is more efficient
  - this includes cases where only some cpus are allowed to process rcu
    callbacks (Android)

Possible disadvantage:
- objects might be waiting for more than their grace period (it is
  determined by the last object freed into the sheaf), increasing memory
  usage - but the existing batching does that too.

Only implement this for CONFIG_KVFREE_RCU_BATCHED as the tiny
implementation favors smaller memory footprint over performance.

Also for now skip the usage of rcu sheaf for CONFIG_PREEMPT_RT as the
contexts where kfree_rcu() is called might not be compatible with taking
a barn spinlock or a GFP_NOWAIT allocation of a new sheaf taking a
spinlock - the current kfree_rcu() implementation avoids doing that.

Teach kvfree_rcu_barrier() to flush all rcu_free sheaves from all caches
that have them. This is not a cheap operation, but the barrier usage is
rare - currently kmem_cache_destroy() or on module unload.

Add CONFIG_SLUB_STATS counters free_rcu_sheaf and free_rcu_sheaf_fail to
count how many kfree_rcu() used the rcu_free sheaf successfully and how
many had to fall back to the existing implementation.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab.h        |   3 +
 mm/slab_common.c |  26 +++++
 mm/slub.c        | 267 ++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 294 insertions(+), 2 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 206987ce44a4..e82e51c44bd0 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -435,6 +435,9 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
 	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
 }
 
+bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
+void flush_all_rcu_sheaves(void);
+
 #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | \
 			 SLAB_CACHE_DMA32 | SLAB_PANIC | \
 			 SLAB_TYPESAFE_BY_RCU | SLAB_DEBUG_OBJECTS | \
diff --git a/mm/slab_common.c b/mm/slab_common.c
index e2b197e47866..005a4319c06a 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1608,6 +1608,27 @@ static void kfree_rcu_work(struct work_struct *work)
 		kvfree_rcu_list(head);
 }
 
+static bool kfree_rcu_sheaf(void *obj)
+{
+	struct kmem_cache *s;
+	struct folio *folio;
+	struct slab *slab;
+
+	if (is_vmalloc_addr(obj))
+		return false;
+
+	folio = virt_to_folio(obj);
+	if (unlikely(!folio_test_slab(folio)))
+		return false;
+
+	slab = folio_slab(folio);
+	s = slab->slab_cache;
+	if (s->cpu_sheaves)
+		return __kfree_rcu_sheaf(s, obj);
+
+	return false;
+}
+
 static bool
 need_offload_krc(struct kfree_rcu_cpu *krcp)
 {
@@ -1952,6 +1973,9 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 	if (!head)
 		might_sleep();
 
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
+		return;
+
 	// Queue the object but don't yet schedule the batch.
 	if (debug_rcu_head_queue(ptr)) {
 		// Probable double kfree_rcu(), just leak.
@@ -2026,6 +2050,8 @@ void kvfree_rcu_barrier(void)
 	bool queued;
 	int i, cpu;
 
+	flush_all_rcu_sheaves();
+
 	/*
 	 * Firstly we detach objects and queue them over an RCU-batch
 	 * for all CPUs. Finally queued works are flushed for each CPU.
diff --git a/mm/slub.c b/mm/slub.c
index cba188b7e04d..171273f90efd 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -367,6 +367,8 @@ enum stat_item {
 	ALLOC_FASTPATH,		/* Allocation from cpu slab */
 	ALLOC_SLOWPATH,		/* Allocation by getting a new cpu slab */
 	FREE_PCS,		/* Free to percpu sheaf */
+	FREE_RCU_SHEAF,		/* Free to rcu_free sheaf */
+	FREE_RCU_SHEAF_FAIL,	/* Failed to free to a rcu_free sheaf */
 	FREE_FASTPATH,		/* Free to cpu slab */
 	FREE_SLOWPATH,		/* Freeing not to cpu slab */
 	FREE_FROZEN,		/* Freeing to frozen slab */
@@ -461,6 +463,7 @@ struct slab_sheaf {
 		struct rcu_head rcu_head;
 		struct list_head barn_list;
 	};
+	struct kmem_cache *cache;
 	unsigned int size;
 	void *objects[];
 };
@@ -469,6 +472,7 @@ struct slub_percpu_sheaves {
 	local_trylock_t lock;
 	struct slab_sheaf *main; /* never NULL when unlocked */
 	struct slab_sheaf *spare; /* empty or full, may be NULL */
+	struct slab_sheaf *rcu_free; /* for batching kfree_rcu() */
 };
 
 /*
@@ -2531,6 +2535,8 @@ static struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp)
 	if (unlikely(!sheaf))
 		return NULL;
 
+	sheaf->cache = s;
+
 	stat(s, SHEAF_ALLOC);
 
 	return sheaf;
@@ -2655,6 +2661,43 @@ static void sheaf_flush_unused(struct kmem_cache *s, struct slab_sheaf *sheaf)
 	sheaf->size = 0;
 }
 
+static void __rcu_free_sheaf_prepare(struct kmem_cache *s,
+				     struct slab_sheaf *sheaf)
+{
+	bool init = slab_want_init_on_free(s);
+	void **p = &sheaf->objects[0];
+	unsigned int i = 0;
+
+	while (i < sheaf->size) {
+		struct slab *slab = virt_to_slab(p[i]);
+
+		memcg_slab_free_hook(s, slab, p + i, 1);
+		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
+
+		if (unlikely(!slab_free_hook(s, p[i], init, true))) {
+			p[i] = p[--sheaf->size];
+			continue;
+		}
+
+		i++;
+	}
+}
+
+static void rcu_free_sheaf_nobarn(struct rcu_head *head)
+{
+	struct slab_sheaf *sheaf;
+	struct kmem_cache *s;
+
+	sheaf = container_of(head, struct slab_sheaf, rcu_head);
+	s = sheaf->cache;
+
+	__rcu_free_sheaf_prepare(s, sheaf);
+
+	sheaf_flush_unused(s, sheaf);
+
+	free_empty_sheaf(s, sheaf);
+}
+
 /*
  * Caller needs to make sure migration is disabled in order to fully flush
  * single cpu's sheaves
@@ -2667,7 +2710,7 @@ static void sheaf_flush_unused(struct kmem_cache *s, struct slab_sheaf *sheaf)
 static void pcs_flush_all(struct kmem_cache *s)
 {
 	struct slub_percpu_sheaves *pcs;
-	struct slab_sheaf *spare;
+	struct slab_sheaf *spare, *rcu_free;
 
 	local_lock(&s->cpu_sheaves->lock);
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -2675,6 +2718,9 @@ static void pcs_flush_all(struct kmem_cache *s)
 	spare = pcs->spare;
 	pcs->spare = NULL;
 
+	rcu_free = pcs->rcu_free;
+	pcs->rcu_free = NULL;
+
 	local_unlock(&s->cpu_sheaves->lock);
 
 	if (spare) {
@@ -2682,6 +2728,9 @@ static void pcs_flush_all(struct kmem_cache *s)
 		free_empty_sheaf(s, spare);
 	}
 
+	if (rcu_free)
+		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
+
 	sheaf_flush_main(s);
 }
 
@@ -2698,6 +2747,11 @@ static void __pcs_flush_all_cpu(struct kmem_cache *s, unsigned int cpu)
 		free_empty_sheaf(s, pcs->spare);
 		pcs->spare = NULL;
 	}
+
+	if (pcs->rcu_free) {
+		call_rcu(&pcs->rcu_free->rcu_head, rcu_free_sheaf_nobarn);
+		pcs->rcu_free = NULL;
+	}
 }
 
 static void pcs_destroy(struct kmem_cache *s)
@@ -2723,6 +2777,7 @@ static void pcs_destroy(struct kmem_cache *s)
 		 */
 
 		WARN_ON(pcs->spare);
+		WARN_ON(pcs->rcu_free);
 
 		if (!WARN_ON(pcs->main->size)) {
 			free_empty_sheaf(s, pcs->main);
@@ -3780,7 +3835,7 @@ static bool has_pcs_used(int cpu, struct kmem_cache *s)
 
 	pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
-	return (pcs->spare || pcs->main->size);
+	return (pcs->spare || pcs->rcu_free || pcs->main->size);
 }
 
 /*
@@ -3840,6 +3895,77 @@ static void flush_all(struct kmem_cache *s)
 	cpus_read_unlock();
 }
 
+static void flush_rcu_sheaf(struct work_struct *w)
+{
+	struct slub_percpu_sheaves *pcs;
+	struct slab_sheaf *rcu_free;
+	struct slub_flush_work *sfw;
+	struct kmem_cache *s;
+
+	sfw = container_of(w, struct slub_flush_work, work);
+	s = sfw->s;
+
+	local_lock(&s->cpu_sheaves->lock);
+	pcs = this_cpu_ptr(s->cpu_sheaves);
+
+	rcu_free = pcs->rcu_free;
+	pcs->rcu_free = NULL;
+
+	local_unlock(&s->cpu_sheaves->lock);
+
+	if (rcu_free)
+		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
+}
+
+
+/* needed for kvfree_rcu_barrier() */
+void flush_all_rcu_sheaves(void)
+{
+	struct slub_flush_work *sfw;
+	struct kmem_cache *s;
+	unsigned int cpu;
+
+	cpus_read_lock();
+	mutex_lock(&slab_mutex);
+
+	list_for_each_entry(s, &slab_caches, list) {
+		if (!s->cpu_sheaves)
+			continue;
+
+		mutex_lock(&flush_lock);
+
+		for_each_online_cpu(cpu) {
+			sfw = &per_cpu(slub_flush, cpu);
+
+			/*
+			 * we don't check if rcu_free sheaf exists - racing
+			 * __kfree_rcu_sheaf() might have just removed it.
+			 * by executing flush_rcu_sheaf() on the cpu we make
+			 * sure the __kfree_rcu_sheaf() finished its call_rcu()
+			 */
+
+			INIT_WORK(&sfw->work, flush_rcu_sheaf);
+			sfw->skip = false;
+			sfw->s = s;
+			queue_work_on(cpu, flushwq, &sfw->work);
+		}
+
+		for_each_online_cpu(cpu) {
+			sfw = &per_cpu(slub_flush, cpu);
+			if (sfw->skip)
+				continue;
+			flush_work(&sfw->work);
+		}
+
+		mutex_unlock(&flush_lock);
+	}
+
+	mutex_unlock(&slab_mutex);
+	cpus_read_unlock();
+
+	rcu_barrier();
+}
+
 /*
  * Use the cpu notifier to insure that the cpu slabs are flushed when
  * necessary.
@@ -5413,6 +5539,134 @@ bool free_to_pcs(struct kmem_cache *s, void *object)
 	return true;
 }
 
+static void rcu_free_sheaf(struct rcu_head *head)
+{
+	struct slab_sheaf *sheaf;
+	struct node_barn *barn;
+	struct kmem_cache *s;
+
+	sheaf = container_of(head, struct slab_sheaf, rcu_head);
+
+	s = sheaf->cache;
+
+	/*
+	 * This may remove some objects due to slab_free_hook() returning false,
+	 * so that the sheaf might no longer be completely full. But it's easier
+	 * to handle it as full (unless it became completely empty), as the code
+	 * handles it fine. The only downside is that sheaf will serve fewer
+	 * allocations when reused. It only happens due to debugging, which is a
+	 * performance hit anyway.
+	 */
+	__rcu_free_sheaf_prepare(s, sheaf);
+
+	barn = get_node(s, numa_mem_id())->barn;
+
+	/* due to slab_free_hook() */
+	if (unlikely(sheaf->size == 0))
+		goto empty;
+
+	/*
+	 * Checking nr_full/nr_empty outside lock avoids contention in case the
+	 * barn is at the respective limit. Due to the race we might go over the
+	 * limit but that should be rare and harmless.
+	 */
+
+	if (data_race(barn->nr_full) < MAX_FULL_SHEAVES) {
+		stat(s, BARN_PUT);
+		barn_put_full_sheaf(barn, sheaf);
+		return;
+	}
+
+	stat(s, BARN_PUT_FAIL);
+	sheaf_flush_unused(s, sheaf);
+
+empty:
+	if (data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES) {
+		barn_put_empty_sheaf(barn, sheaf);
+		return;
+	}
+
+	free_empty_sheaf(s, sheaf);
+}
+
+bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
+{
+	struct slub_percpu_sheaves *pcs;
+	struct slab_sheaf *rcu_sheaf;
+
+	if (!local_trylock(&s->cpu_sheaves->lock))
+		goto fail;
+
+	pcs = this_cpu_ptr(s->cpu_sheaves);
+
+	if (unlikely(!pcs->rcu_free)) {
+
+		struct slab_sheaf *empty;
+		struct node_barn *barn;
+
+		if (pcs->spare && pcs->spare->size == 0) {
+			pcs->rcu_free = pcs->spare;
+			pcs->spare = NULL;
+			goto do_free;
+		}
+
+		barn = get_barn(s);
+
+		empty = barn_get_empty_sheaf(barn);
+
+		if (empty) {
+			pcs->rcu_free = empty;
+			goto do_free;
+		}
+
+		local_unlock(&s->cpu_sheaves->lock);
+
+		empty = alloc_empty_sheaf(s, GFP_NOWAIT);
+
+		if (!empty)
+			goto fail;
+
+		if (!local_trylock(&s->cpu_sheaves->lock)) {
+			barn_put_empty_sheaf(barn, empty);
+			goto fail;
+		}
+
+		pcs = this_cpu_ptr(s->cpu_sheaves);
+
+		if (unlikely(pcs->rcu_free))
+			barn_put_empty_sheaf(barn, empty);
+		else
+			pcs->rcu_free = empty;
+	}
+
+do_free:
+
+	rcu_sheaf = pcs->rcu_free;
+
+	rcu_sheaf->objects[rcu_sheaf->size++] = obj;
+
+	if (likely(rcu_sheaf->size < s->sheaf_capacity))
+		rcu_sheaf = NULL;
+	else
+		pcs->rcu_free = NULL;
+
+	/*
+	 * we flush before local_unlock to make sure a racing
+	 * flush_all_rcu_sheaves() doesn't miss this sheaf
+	 */
+	if (rcu_sheaf)
+		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
+
+	local_unlock(&s->cpu_sheaves->lock);
+
+	stat(s, FREE_RCU_SHEAF);
+	return true;
+
+fail:
+	stat(s, FREE_RCU_SHEAF_FAIL);
+	return false;
+}
+
 /*
  * Bulk free objects to the percpu sheaves.
  * Unlike free_to_pcs() this includes the calls to all necessary hooks
@@ -6909,6 +7163,11 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
 	struct kmem_cache_node *n;
 
 	flush_all_cpus_locked(s);
+
+	/* we might have rcu sheaves in flight */
+	if (s->cpu_sheaves)
+		rcu_barrier();
+
 	/* Attempt to free all objects */
 	for_each_kmem_cache_node(s, node, n) {
 		if (n->barn)
@@ -8284,6 +8543,8 @@ STAT_ATTR(ALLOC_PCS, alloc_cpu_sheaf);
 STAT_ATTR(ALLOC_FASTPATH, alloc_fastpath);
 STAT_ATTR(ALLOC_SLOWPATH, alloc_slowpath);
 STAT_ATTR(FREE_PCS, free_cpu_sheaf);
+STAT_ATTR(FREE_RCU_SHEAF, free_rcu_sheaf);
+STAT_ATTR(FREE_RCU_SHEAF_FAIL, free_rcu_sheaf_fail);
 STAT_ATTR(FREE_FASTPATH, free_fastpath);
 STAT_ATTR(FREE_SLOWPATH, free_slowpath);
 STAT_ATTR(FREE_FROZEN, free_frozen);
@@ -8382,6 +8643,8 @@ static struct attribute *slab_attrs[] = {
 	&alloc_fastpath_attr.attr,
 	&alloc_slowpath_attr.attr,
 	&free_cpu_sheaf_attr.attr,
+	&free_rcu_sheaf_attr.attr,
+	&free_rcu_sheaf_fail_attr.attr,
 	&free_fastpath_attr.attr,
 	&free_slowpath_attr.attr,
 	&free_frozen_attr.attr,
-- 
2.51.0



