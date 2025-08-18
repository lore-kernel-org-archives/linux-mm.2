Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E4CCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBE368E0033; Mon, 18 Aug 2025 08:04:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E95A08E0003; Mon, 18 Aug 2025 08:04:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DABDB8E0033; Mon, 18 Aug 2025 08:04:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D07CE8E0003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:04:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 935CD1DDE5F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:04:26 +0000 (UTC)
X-FDA: 83789745732.07.E245D12
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 57AB94000E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:04:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=beztyR7s;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WKulBeCw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=beztyR7s;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WKulBeCw;
	spf=pass (imf01.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755518664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rM7e3IdiwaCTEtvovImthX0CfEk5ySRhUVWdsnkbP+g=;
	b=uuGQgIFsYCfvd/EZnHn+b9nDNvHEBN6dsP49QbCiJiObfwo5UXHx9E8hdvrS1HFa+UroDC
	XosqXhgF28hPna2Uge5EZouNatatvhbXCm1kPCDL2a/F8jA37g7h+Amw/dpnyTWLZm3JhQ
	VizXt9JyYc6+LDkR9mfumlGFTVOHvJw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755518664; a=rsa-sha256;
	cv=none;
	b=CPZmEQ3czDOEFUunQOQEfWbm3Lq2pJXgRyXxqDRjt8nji06Lg8ldbqo3LXrPaCbUCr5CPN
	x/PNP7atNiyz0r27uLIRVt8cQ3EJ7HJ7mw0PfWd4jTltA0jedmXp1fteH0H3YQBmjN+b3T
	wboF0Li92Hv/ZjE+ZFNMwr6+G7UzgnA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=beztyR7s;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WKulBeCw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=beztyR7s;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WKulBeCw;
	spf=pass (imf01.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BF98C1F387;
	Mon, 18 Aug 2025 12:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755518662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rM7e3IdiwaCTEtvovImthX0CfEk5ySRhUVWdsnkbP+g=;
	b=beztyR7sBDGZyBm/JkHUTLHBQR+sgiZoXt7OYr0PnM1UUEnK31rzHY1r2xAsm1D7caS6ql
	BCWupQGv3dDbKphH+UrBJhD72p3oaaZDYTDs0AEqJ15vrq3QBR7Nodscx7R1o2A2UQEEvR
	x7Via08+M2V9275HyHH3RvC7iRlL+io=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755518662;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rM7e3IdiwaCTEtvovImthX0CfEk5ySRhUVWdsnkbP+g=;
	b=WKulBeCw6firgU+sJgKSzp/MVu6/f/9T6Blez64p2SqXHBsQNIQitUMNZHlMVf5L4lqP/+
	pPxyaQde5yv9owDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755518662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rM7e3IdiwaCTEtvovImthX0CfEk5ySRhUVWdsnkbP+g=;
	b=beztyR7sBDGZyBm/JkHUTLHBQR+sgiZoXt7OYr0PnM1UUEnK31rzHY1r2xAsm1D7caS6ql
	BCWupQGv3dDbKphH+UrBJhD72p3oaaZDYTDs0AEqJ15vrq3QBR7Nodscx7R1o2A2UQEEvR
	x7Via08+M2V9275HyHH3RvC7iRlL+io=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755518662;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rM7e3IdiwaCTEtvovImthX0CfEk5ySRhUVWdsnkbP+g=;
	b=WKulBeCw6firgU+sJgKSzp/MVu6/f/9T6Blez64p2SqXHBsQNIQitUMNZHlMVf5L4lqP/+
	pPxyaQde5yv9owDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 048BB13A55;
	Mon, 18 Aug 2025 12:04:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4nltAMYWo2iqbAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 18 Aug 2025 12:04:22 +0000
Message-ID: <47277451-4220-436a-a2ef-b0a58d556c4f@suse.de>
Date: Mon, 18 Aug 2025 14:04:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] mm: add largest_zero_folio() routine
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Vlastimil Babka
 <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org,
 Ritesh Harjani <ritesh.list@gmail.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
 Pankaj Raghav <p.raghav@samsung.com>
References: <20250808121141.624469-1-kernel@pankajraghav.com>
 <20250808121141.624469-5-kernel@pankajraghav.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250808121141.624469-5-kernel@pankajraghav.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 57AB94000E
X-Stat-Signature: 7koft3pnfyu1gzmfqhp9k649t5pwz7s4
X-HE-Tag: 1755518664-554014
X-HE-Meta: U2FsdGVkX18nTGR3EN90l6HsVws8yq68r8vVoHWDVYcJ7J25II47yb51W/ITce9Hh+hTOhcCANlfwy4MKINkg8BuPqGiilVeC/00d3ibFYTgIUcAxByvZomHFFla42t/QU+Ogrd0DHxDNuFpsg4PXLZKo7Jd7sZR9NIY0WtfTVDhtyUp8mXjwNc+ciILQYswoN34mGQNv7mvvN15wnWEenHivpMWu6uD4vookW0bjgHSDHMQfUceDGmujh+sYc4AIHF8k/49t2wsGWwveLuaYrp30aEpUisP9JLldBojHpN6mbVo+0w7K77lB40uyinHxymCexAvDTpvDduEbtgoMEYNXZLAxH3Cm4Psz18QnCCsufqFI3Zww1IM180WXkQm/vXC/yM52jsD2UeyKA3pdrjc7uHFGOx/uc9TW+yW8TWI44eegiJixM1+a6wa+6ZF+7f4pTZZkmp2kJLJL+R4kwf6M9R2BeeY5OCvOuAY2OzZiPwUNvIgKEUYdV33M7Rt6b9wlsOvdhbqM4hQwVXJC7qBMdyOAOJMhMUx1r9HFZpzr0Ci8GB9Ln+j+IGo8yWlIp1CYxBMvC8eBaE1duJ/WuPmpbpP1xBLxCZRMtdmY4II+VR6HH4BawoTEOSAV+qFmZ4/MYd2FchSU/wbtChBtJ2EQWtq2poR7nQcXFJnicq8MGXiCw0TdxUCNWnpFEh0HimkCOlP/Rm7WiWhTdT2/zlhclTf/IZVY1ZKmsvTp6frAcy+NNhkLdkb+4avWI7usjZ3XCYcAAu9F2pUPVJgD8VKA0YvOo2pRsdRpGWvoqXGytOgmd9en4X+gIZ4Y6K5G2KttjP7qwoc76Kx3M6RhaLfR7Nn5ctT40bCv7UO/0+fnCi/JDU2SYwzMyhPBV1FN0u/NOmrJMj12Bwzxsn7D38TR4r2Qm3FhBqB+8BUoiLlC2uDfEYqzI3b6mi6TfMKCVDmcfgPYVOquAO1qbe
 t8ykunM9
 xWyLycVd8OwR/wkgYNKM54MBDUv9LRs1sPZ8fn2aZswx0oAUpsj3yf0OZnNZQRTLOc2glAx0iHZzA0Xhm8OJbEZx0hzZiOhTdAjvaF5kmQcRMBlE3WZAZkfMoY4849+mJNYx0T+QT9su3zOY2uw6T8CNtUwCE8Q7gI7l3ZhEAd2GamuaQun5qh0tWtXD8BqceM4uNYpotd/+R0IOs4l0VX62jK65ZrCGlfNiAzjjCte8JdpAgSTnV7+KNeZUO64tUAAvezoHr3i1xcWPtjsS8JJVh7s48MX6PZrPazEaicHpYkl6FA4yzys8CdE4lq22ryt63UsPpPeD+lkgYWzmJKAiAvZpIgit8IRxKdN+l5AjMWhciS+NcgEr5hjP2pz+5b+t88R48ZZv4zISGmcU2vcTtk3NgjLkxxKAzAq2LDmARg3n7/ZZg6yaSEKLJSq8fwtGuw7AfMSnN8qxPx3fFt+oDjI6RFUz1FeJjumqC5wbrCjaBmKaRtOOY9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/25 14:11, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> The callers of mm_get_huge_zero_folio() have access to a mm struct and
> the lifetime of the huge_zero_folio is tied to the lifetime of the mm
> struct.
> 
> largest_zero_folio() will give access to huge_zero_folio when
> PERSISTENT_HUGE_ZERO_FOLIO config option is enabled for callers that do not
> want to tie the lifetime to a mm struct. This is very useful for
> filesystem and block layers where the request completions can be async
> and there is no guarantee on the mm struct lifetime.
> 
> This function will return a ZERO_PAGE folio if PERSISTENT_HUGE_ZERO_FOLIO
> is disabled or if we failed to allocate a huge_zero_folio during early
> init.
> 
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>   include/linux/huge_mm.h | 22 ++++++++++++++++++++++
>   1 file changed, 22 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

