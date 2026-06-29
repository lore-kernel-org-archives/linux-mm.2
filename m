Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 475BEC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 06:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9D8D6B008A; Mon, 29 Jun 2026 02:22:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4E806B0092; Mon, 29 Jun 2026 02:22:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F256B0093; Mon, 29 Jun 2026 02:22:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9750A6B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:22:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 98E20120577
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:22:20 +0000 (UTC)
X-FDA: 84931955640.15.C90502F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E12DEA0003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:22:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qo6qrJOS;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782714138;
	b=G5jg10Wb7uuYY5Ln/ROwgGupkVLSjTbohJg9XMKSK9ZLnWHeOyoS+4lsMp4UloUvfAOEQ2
	FkUX9pjLqz03xJDyQ8jM8JKbKo/gq9rb0b7CuZdX2CeJDNMysnnrtDLClL8kDk0kSHEXSW
	2j/0Fk63gWDhNvQTXtJICilhO8ReQho=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782714138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9lY/q6EG1uWHGsH7wIr0duaXw2mcsQSmZ1KCAL7TeEM=;
	b=0db590wzM+rXkiDdS2ytP8LZBGhHKv4nz5QZk8m6QJUutCNJtOp2V+ou+SS/A3Z2vm5sfC
	j705RQjUQQSRVkYaUAOsl25q0c8ZDgJMFQiKUWqGFktkCAonXcAbKIQmLWISv+tYaHyzjc
	zpnRAWntbZ/A+zh2MSDSmZ/YbhzaoAo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qo6qrJOS;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6016060052;
	Mon, 29 Jun 2026 06:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7551F000E9;
	Mon, 29 Jun 2026 06:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782714138;
	bh=9lY/q6EG1uWHGsH7wIr0duaXw2mcsQSmZ1KCAL7TeEM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Qo6qrJOS1GZvxvO2xbMH2XsXHWaLa0mXXumTJg52fmjwY4sBdmfTQofEY6eeI7NC2
	 zWEXBLiYM847GHErX+dAOXFL5bWcfz7J/tDNktVW6yz8sOXOe9oMDiBG5pSuDWhzvW
	 B/QqK5roSxYW3okPDu14yLH+lqTxDqUHbAy8hmSKX0Y6EAaKcc5qfqbFzK1gcTN0WD
	 sUi2IeOZiDIJIb7pnLFzReqFj/t8WRqUS5obDdOSx45Pe73zwdanf8AMrzAvljAxCr
	 4W3i2ya6wRAdCMHJQ9F/DlNfRy+YfpGYutrcRMfCQ8SiixuAYzd4wQ1LwkkQAmzCHc
	 04dfMIg0oYjZA==
Message-ID: <0c3634d7-855b-4f80-99f3-342309d74e10@kernel.org>
Date: Mon, 29 Jun 2026 08:22:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] mm: assert exclusive nid/zonenum bits at the
 page/folio access sites
To: Hui Zhu <hui.zhu@linux.dev>, Leon Hwang <leon.hwang@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <20260626032012.1049667-1-hui.zhu@linux.dev>
 <925c8686-9ff6-44c1-9780-63bd7cd8a1c3@linux.dev>
 <e46ba0c9-6a24-45e5-99f8-b4f454887f50@kernel.org>
 <7561266d0aedbb55f3f67090fb2493f7a899b66e@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7561266d0aedbb55f3f67090fb2493f7a899b66e@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ofs461md9twzh4ku6roid5dsxtz39er3
X-Rspam-User: 
X-Rspamd-Queue-Id: E12DEA0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782714138-140927
X-HE-Meta: U2FsdGVkX18Ho6Q2+7NDILn+gjJtIpfaSOpPuRAI9Zp7Dbkeyx/2kegbtb2Ye3v9miYq8OuDjkYxgCWcOLG+3j3vs7BUIoWHmhe+8HbxLHDRgNZj7mW9jKt8ESSFS1hQQfOcOKC6IVg6MllNx/mseTqP4IhKZgTLppTnnzAckJTCusmUZwGM2VNzYGkbqhuMZYNlgwm5BHtyRTs8c95a1MRJtabDjc6g2VeO43V/ljG0JIRfNlbe+ViCGH5NeVzM28limfoGqgOYA2sx+mO8NKqI7YyabTVw5xRSTQbT5zq8eznm1OsYR6r/I4V+S+2aafDVlJu3HTkEcxYlpaiuFWsZbAWMuQ8KShO3NCcYMAZ/lMVK0Mt3RmXRnC/6XlawDHwWlbYcG7nbRNSbXrRXGfosHGa6FPvp1B+XYeg6XzB3D1z+CPGrRX07gti6ljhJEVU9N6TysxEZKLNjeX8T+skfxyh3WVWofpipMijLgJ7fTnhQbA6uMWHxcmFQIowFcNQir02j1XzW0iDbFKCBb5B7mPC7fFgct73LsQNpLh2F9W/Bh/Q6nbGkv82q7sb061tR4D3yF7lM4c0cZFa5IElTsc41CRl4mExZSI+a82E4Ukm8dW0IAUfRwC3iqeIfO14FJGXtHHAzK/KD6IiGx8Qy88jYwqR67OGWmPLj0B+HalkjsxtgUrt/8E/h/GATTYl9DACVM3C++E73U0hk6K4/1f7dfeq0HTNkwqakIV5yy0ROjX3+jdhs5zzazkXCInNEmdt6ljtIifiSJPfbKEQsRvIjOEogscAHoXZL3h3fiJHqPscw6Z4spbJpqMIIXhx6snQjvBSED2A6yHHku1Tpar8FEIuMu5vxZH7d1g+bT5YQScbj48Y/CdowG0KeCP01TT8kmOP2XZIBtzzTS8n0uWV7wploPO9xLDtH+zoh5NyJnCaPhJYGJ/kPpNTAhD5kDUi4ok8p3FU4aU1
 t+6i2n7p
 F5XfOcyuyOfCEmX4pERvCduD1q/azR2biaLhezR6zwxf/G5KeHuRc8Zkhfb9IZbnse18TqnEaDWTlS6KVIJlImieKPVrZAx1FUvLhKdT9o7qd115qN1E90N38wars56PH7S3onKLBX/1iKgesj3vfC65zQYcW6BMWytZ1B43jbhpe+LG8i2AtGj5mFI2/ZPeIj0ET7shOLk0fG2b0L9j7JWtcmOe7SkKvKU98zVxfmHKd2C3tcWA5aJKLUEEU2Hl9/e18/syYEXQuDsJv6QVSD9zRTgfgg/OJ8/BeqSqkhTnfi/BTsgfI8EYfHPE5DFvopeSilIXKkoXVR+FgNhs3hj44jQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 05:32, Hui Zhu wrote:
> 2026年6月26日 17:09, "David Hildenbrand (Arm)" <david@kernel.org mailto:david@kernel.org?to=%22David%20Hildenbrand%20(Arm)%22%20%3Cdavid%40kernel.org%3E > 写到:
> 
> 
>>
>>>
>>>  
>>>  Better to factor out a common macro alongside a comment for these two '#if'?
>>>
>> Yes.
>>
>> And while looking at it, doesn't memdesc_section have similar problems? And
>> there are other callers of memdesc_zonenum we wouldn't handle. So the
>> macro approach is only partially helpful I thing.
>>
>> Maybe we should just pass by reference and fixup all callers? Ends up the cleanest.
>>
> 
> Hi David,
> 
> I think pass by reference is better than macro.

Yeah, as long as there is no other (future memdesc specific) reason to pass by
value. I don't think there is.

> 
> Would you like to send this out as a formal patch yourself?
> Or would you prefer I include it in my next version with your

Please review and test the patch (and fixup anything wrong with it), fill in the
patch description (explaining why passing by reference) and send it out.

Feel free to keep yourself author of the patch and add my

Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Above your SOB

-- 
Cheers,

David

