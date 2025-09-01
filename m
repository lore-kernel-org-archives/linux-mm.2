Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FF96CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:15:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6872A8E0019; Mon,  1 Sep 2025 04:15:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65EB98E0013; Mon,  1 Sep 2025 04:15:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54D968E0019; Mon,  1 Sep 2025 04:15:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 40E8D8E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:15:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03F0513AE75
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:15:08 +0000 (UTC)
X-FDA: 83839971138.21.6860F6C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id A359A1C0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:15:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u1cO2mqA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lUhUBp3A;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u1cO2mqA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lUhUBp3A;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756714506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ag6Bx6oNBAllS3Gz2RlALtf/L70h9xsODr9ce4Xmxq8=;
	b=MmpKee0bV1l1DPNkSdQtT22XWCHpQWnEctyApEgFSf0V/y2YNofuSpXB1hl6cd8JgcXutU
	CNNwI/lKamlSK1wu3v4mwV4o6DmrmXt5Cz9ZFdAtI35LdIV/KMJz14BIIG1OMZno0RKhCy
	AiI1KtfFAEhsifqMeo4qOik9bwzaeac=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u1cO2mqA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lUhUBp3A;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u1cO2mqA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lUhUBp3A;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756714506; a=rsa-sha256;
	cv=none;
	b=4K86WYqIzClj531HDdda5ftUs8fbFpSa3OAvEidZj2Ypp/gJkIH6BNwlIA7A5YyHR8Jooi
	uMLxspJKa/z/9uMjDJbPUJI02uVgwEN5T+dfSkOcXQA5xHzCAnrRJfZjjci0aVv6CrOMXL
	WXwQJApRwks1j8z6/NchgwhIWfpBNWY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BAF451F38D;
	Mon,  1 Sep 2025 08:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756714504; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ag6Bx6oNBAllS3Gz2RlALtf/L70h9xsODr9ce4Xmxq8=;
	b=u1cO2mqAbDOT6YQhb+fA1KFZ2ZsjP6e5+rPCQDo44vNkVzjUFgr/ndaj5UE/5jJH04nb2X
	daEJDoW2kcTYZsY2sWAFFWxR9a+vCHya9Tz30d1RrqW3BX2hkuiS8jeGiript4pIPekh/O
	voC8uFcPcIaNKZhYE1yXYROEhvNBI/E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756714504;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ag6Bx6oNBAllS3Gz2RlALtf/L70h9xsODr9ce4Xmxq8=;
	b=lUhUBp3AgAqUH6YH4G5XyuVFNfwkG+8XOJz75zy1T6dc9HCyTDSxLsWBWoNAf83Lgp3j5E
	pCCDR2azJJzazDDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756714504; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ag6Bx6oNBAllS3Gz2RlALtf/L70h9xsODr9ce4Xmxq8=;
	b=u1cO2mqAbDOT6YQhb+fA1KFZ2ZsjP6e5+rPCQDo44vNkVzjUFgr/ndaj5UE/5jJH04nb2X
	daEJDoW2kcTYZsY2sWAFFWxR9a+vCHya9Tz30d1RrqW3BX2hkuiS8jeGiript4pIPekh/O
	voC8uFcPcIaNKZhYE1yXYROEhvNBI/E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756714504;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ag6Bx6oNBAllS3Gz2RlALtf/L70h9xsODr9ce4Xmxq8=;
	b=lUhUBp3AgAqUH6YH4G5XyuVFNfwkG+8XOJz75zy1T6dc9HCyTDSxLsWBWoNAf83Lgp3j5E
	pCCDR2azJJzazDDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C35C136ED;
	Mon,  1 Sep 2025 08:15:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xhphHAhWtWjoVgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 08:15:04 +0000
Message-ID: <7f30ddd1-c6f7-4b2b-a2b9-875844092e28@suse.cz>
Date: Mon, 1 Sep 2025 10:15:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: slub: avoid wake up kswapd in set_track_prepare
Content-Language: en-US
To: David Rientjes <rientjes@google.com>, yangshiguang1011@163.com
Cc: harry.yoo@oracle.com, akpm@linux-foundation.org, cl@gentwo.org,
 roman.gushchin@linux.dev, glittao@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, yangshiguang <yangshiguang@xiaomi.com>,
 stable@vger.kernel.org
References: <20250830020946.1767573-1-yangshiguang1011@163.com>
 <c8f6933e-f733-4f86-c09d-8028ad862f33@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <c8f6933e-f733-4f86-c09d-8028ad862f33@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A359A1C0009
X-Stat-Signature: yhfgzyc5s5zb8urw63gmwhh7ajuhpsru
X-Rspam-User: 
X-HE-Tag: 1756714506-569441
X-HE-Meta: U2FsdGVkX18s4gnQXjPgntX3sbL0TZ/9lAdKaI2p8jFIH/6GgrjyByJILabQzvEiC+iBLwPmZWQJ+asb6S9c+Z8nW10uaw0/wbDZIafrxeKDhUljeQjOo+NCHA0f/szCfp+BpXGj4z8aYCQmQ1Zn7F5Iqvcmm9f/HSLVrmfY1nZdaRf6C7UnY+qAYYnSQzsMbYo3D2Ha6hdybpH8DHqcGzFNX3/JkMdsQiV2X48e9MnXCBDJ4IxQH0EUZqvWcH41qQoeO8lmzte7ImL8rMsVyE6ejJyZYKEDC7U8+FpGFlB6AMbp0Y0jr2RYd78n2vXkO/7s0y+lXUxIQK2h1aNWByzhSC6Jve5U1x95IU7VX6wP04ITTwLLgkOmlNalimChFej4NFcsgroN6q7gaTdcryXraY6ncBeo9EWn6LvSE1nf8YCxxlSgDuvY98np2WfvgtADJQ9ojmCcEVOw5MkgO/etrWsNj0T2Gm1vvZuWrTC4a7Y0g1N5mrfrkAJlgX6ZCgUtdDyk5tAUZ7a/sEtzD0fFKbhS26ZVRBGUTv8GJiO0O0HSIQ85WJOPkorsglCel13dZJM1p3LMq+crYr5f55uWlUj7od7d5qmmibwVhhe3KFTid+OtAFOw3Dxb5jJEvDkhWRmQf5XDwSY96FXcotBXqLl0ooon2MiUFCwasoU59atvraoursnPGZAUCergZY6u1KyEzUZCEZOIjHkejT2HGfZRJLWc18LefdNjt8JcXnzabPCdYA3dNUoc55SdR7gqD8Y1A539cw+07nDy1TyZwPGNeUir/E9v3S+pr1bBN3nnsYRbwATdjVp8Ftp2P5ek6Linqzs4SHsVEPY/X7CKrwoQrjxkcvjB6ewz+dXDPFuhZZs1oNFgfzg3RD6xhvoHHKKMdnFlGV/5IvgMUGrT9r+vRTjsWuhO0IPDE0TR+QO0us5jFn0J6+5SVmvIBs0pyXhmpYNEd0r//yK
 qemAvQDg
 szgjaqdrGmlhETeD32zqOADCNSxdZu5q+0t4eq202MH15fc7giDngbL9+HesaguuDiDOgbnRmXc3ekSo2Wr/J6D+/7XXdNp7YmkbMp9LFjThDsHkLOyYUV912wdJszZYnIyvwWShC3m80jT1C6JqnG8/9o8shkxNRoiFCCGTeERC6+huD9rSgn8G0/H5uwYEPLKRuPYI9V9i+U7g0f4xdMuCq0CRyBWk7EmxuSi7iFTxye07dEshWPeJubxeJz/kxvL6QkmqGE6sHwT7E+Qgs8yf7pEHY/2WUMR2gPQvmG9EoKWRTb2b49A3ltq1LQciBZve7xeCTNCmBksCl5kyV7en9DkGBptWgHAzUA2xnA/34Yz33s/19EaByyJvo4GOD5WPM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/25 09:50, David Rientjes wrote:
> On Sat, 30 Aug 2025, yangshiguang1011@163.com wrote:
> 
>> From: yangshiguang <yangshiguang@xiaomi.com>
>> 
>> From: yangshiguang <yangshiguang@xiaomi.com>
>> 
> 
> Duplicate lines.
> 
>> set_track_prepare() can incur lock recursion.
>> The issue is that it is called from hrtimer_start_range_ns
>> holding the per_cpu(hrtimer_bases)[n].lock, but when enabled
>> CONFIG_DEBUG_OBJECTS_TIMERS, may wake up kswapd in set_track_prepare,
>> and try to hold the per_cpu(hrtimer_bases)[n].lock.
>> 
>> Avoid deadlock caused by implicitly waking up kswapd by
>> passing in allocation flags. And the slab caller context has
>> preemption disabled, so __GFP_KSWAPD_RECLAIM must not appear in gfp_flags.
>> 
> 
> This mentions __GFP_KSWAPD_RECLAIM, but the patch actually masks off 
> __GFP_DIRECT_RECLAIM which would be a heavierweight operation.  Disabling 
> direct reclaim does not necessarily imply that kswapd will be disabled as 
> well.

Yeah I think the changelog should say __GFP_DIRECT_RECLAIM.

> Are you meaning to clear __GFP_RECLAIM in set_track_prepare()?

No because if the context context (e.g. the hrtimers) can't support
__GFP_KSWAPD_RECLAIM it won't have it in gfp_flags and we now pass them to
set_track_prepare() so it already won't be there.


