Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAD36CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 18:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B17F8E002C; Thu, 28 Aug 2025 14:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 989408E000F; Thu, 28 Aug 2025 14:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89F668E002C; Thu, 28 Aug 2025 14:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 782F88E000F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:31:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 24E5D1DD56F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 18:31:35 +0000 (UTC)
X-FDA: 83827009350.18.5001291
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id B4618A0007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 18:31:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="A/Sz5XHn";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gTQsMHTI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PQJttCtL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="gES4/ihe";
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756405893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b9Upyzvi5i68wBVImXDez81ZGBVloAp3dNfB9SVZ+nk=;
	b=uY1Qx3nNiRuL3XUMu1gsqxjU0lQ4i0nOzbGmc1X7LdhdXsUvwJQtDyq3oMuOz8Zr4m5umo
	3RAHBnr5/bvRIpORE9Hmsg1Uo/BuljSabHxealvJ2fc/7NlSL+oI9AJpuxFXmx7R9QdHr/
	zOrIJLK6hULy4Z3PdfIUNvD4RKXoQD0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756405893; a=rsa-sha256;
	cv=none;
	b=jRv6fwUMW3tY+JBr/WJz48FNjZHH9qQbsNkbx+5vBMQI2VNvtycNAXw6VdTrEWEn6f06ny
	bksQ5bfTHty3EBuWgWTK/phEYZY59eyc6nbsiNx/8esAG1EULcrNIMHWoNGZQCnAu+B+x4
	fwEAtf1JEr3+MA992o/E+rlOFgUbysc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="A/Sz5XHn";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gTQsMHTI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PQJttCtL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="gES4/ihe";
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E13C420DD4;
	Thu, 28 Aug 2025 18:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756405891; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=b9Upyzvi5i68wBVImXDez81ZGBVloAp3dNfB9SVZ+nk=;
	b=A/Sz5XHnMHmk4ppy9+PunR4+zEZF1aNDo78upiHtAV18YbM4ZSMf5OgnTiG333anpBoPzf
	t0T5nUXCh+wLyLMp5dZWWFzXLJdX+w8VrlprjSihqLYcqkPlHnSCN1n2vj+XtBG2+rMkCG
	kDNWZVvZFfs24fi4gM8/uZJVgUShL/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756405891;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=b9Upyzvi5i68wBVImXDez81ZGBVloAp3dNfB9SVZ+nk=;
	b=gTQsMHTIpCcbeXBeAL4p+p0u3bgCVJQhBD/iyQZQc7QWgfzUl+yqWGN9TaqoglZ705E9Hz
	7wZJh9fdS010yyCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756405890; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=b9Upyzvi5i68wBVImXDez81ZGBVloAp3dNfB9SVZ+nk=;
	b=PQJttCtLR5tG1P4I7sHZrfHD+v8iRWUV4u0YpYegtA0M5wh+4TMOcYWQV1rhJRlys83wKJ
	AszXC1icd0nCKhVPxLEgOjzSJpJRcxDXT7vv8yWLvKKx0JfzoOWLiirjlZ47RLWS85DTZy
	PfS2lveLfuiv0/wDeKIdriuh80CbOxM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756405890;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=b9Upyzvi5i68wBVImXDez81ZGBVloAp3dNfB9SVZ+nk=;
	b=gES4/iheOhrkzmFt3HmXh/UUWt3aCi8Q1Hlxz4/gsyCuGIdG8HhZWpO9scLKDEz5tJ7zF/
	tDdUGEFvI8c+ROAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CAFC81368B;
	Thu, 28 Aug 2025 18:31:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7BI5L4KgsGjWbAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 28 Aug 2025 18:31:30 +0000
Message-ID: <a6571b18-a63a-4e9f-b911-7cc10c72a4c1@suse.cz>
Date: Thu, 28 Aug 2025 20:31:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: Harmonize should_compact_retry() type
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250826-cleanup-should_compact_retry-v1-1-d2ca89727fcf@google.com>
 <20250826191320.d5aa551eb5abef316de41175@linux-foundation.org>
 <DCDBG4WR1ZDF.23COVR1IO2OSJ@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <DCDBG4WR1ZDF.23COVR1IO2OSJ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B4618A0007
X-Stat-Signature: dc8kxujjtme9or38j8muc1dkpztu5k5i
X-HE-Tag: 1756405892-657195
X-HE-Meta: U2FsdGVkX1/dQFcpYIbNdSOALAchGniF6szGcm+Qb04BrZS7tg0GTlwtfuyoRrwAB97nmscBRyA/DZbInCaM+P1e/y15mu7v8b3WxDlqABq5NOTOqpF5yTZPv4l8G4CCEnGbQabNFHd2F0zUg0KRx7gi1TrU7P4dOIc4v3/UA2WRBWlRXjtGdBj2NWfezN3mOcukgemb8WACdqYzFfqgu7oYlZ6FQe6aqc5cgF0ZD9TozBwHkkcC18V3j017BcYCay2TdqhzgjlPlb3ADEBUuR/gXFLVHQ/r4nM6Dz7vsHafjj3ULwTHvDuZv8AEwruM7fe+NSC7W4tbQAIZXyMduC7miswMU+TpJY5M+MBRZ8zQL59Ydot/GPc9sZSI2gkkmF59IzVwduZQr7LELyq85j6NCtebkrY3iml1J9HPNd6R6JUGHfPVSj1iQZgDFC8I2JR1BQEEwnSbySC2GNbI4HX4w82sTLROfo/BBvhqs6soSNr0xXWgkyOrIXpnr7MCnB2qmJmZgz6Qp99O/d74RDQdwEukagbl/ZYwRkKncw3ja3z3RiJSNBvWkG4owEeGHyfN6QePiu7dkwjkC8F/R/iOMmLu/on7VR8rD3Zj7XvDi1hpzmbnccoZmxTDYeVaJHBy9yf3PvyAb32FRrFDTX0r703kkoAPpkiN1QW+W8sVQb/8dBlyzaYaET84gOiLT89gmbtAqsxFnLQbYkRLoJD03Mq9hN2ohTTFWDC5rdxKswCFSODsqZDudpKXWourUyp21IHSotDfEnqkVIzRnz+Vq1aK2H2fL6ztox9XR/1hNoDmgyqXMkpKnuApiuOePy1/dZ4cx+UtUSpg134f6pqw/bOd8crEYSkUtfsN4b4l7g/TJ+KIG+YO3iOvyLaOQN0AEqHt2cFT23IvOf7BSeqK+87YgTI5D9l7oaknTnobZkI68Ir9GYsmPPHICE6mVxVEdtyGi2VKw3+t7We
 7jER0/2h
 Pok3VK0gmi3qHcY5Dx0HKJ+593heaR0pY0URt56iHP62Cghs1VqhML5Qa1yOELfRfzncooOKwT+A9OX+pugZsietgqayRGh4gHl2eF6s2y1Sgs2fNwkGF4fcO4pyQt8YabwzB4CIp7TzOCBbgMck7bB3VGocpyB2qsL4Li46LTDeyJ/DSRzFkDHaFtY5O4fHdoAL5UHJWXeIMPwpuTCRhbrcn6TE9vyhUu0WuJdoktUGi1h96/3yP/H9NFruQI5XSpnsCC7cLrvKZ6h9SdrQEEYoBQdWzPqgSch9Di4OeFZONZV9ncrwcm1z/yWIKrEzgpOZBPnoCOTOTlG3gQ6sHMIQfnvynBFGUULli
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/25 17:30, Brendan Jackman wrote:
> On Wed Aug 27, 2025 at 2:13 AM UTC, Andrew Morton wrote:
>> On Tue, 26 Aug 2025 14:06:54 +0000 Brendan Jackman <jackmanb@google.com> wrote:
>>
>>> Currently order is signed in one version of the function and unsigned in
>>> the other. Tidy that up.
>>> 
>>> In page_alloc.c, order is unsigned in the vast majority of cases. But,
>>> there is a cluster of exceptions in compaction-related code (probably
>>> stemming from the fact that compact_control.order is signed). So, prefer
>>> local consistency and make this one signed too.
>>> 
>>
>> grumble, pet peeve.  Negative orders make no sense.  Can we make
>> cc->order unsigned in order (heh) to make everything nice?
> 
> I think we can't "just" do that:

That part should be easy to convert to a compact_control flag.
Zi's point about going negative seems like more prone to overlook some case.
But worth trying and the cleanups I'd say.
> /*
>  * order == -1 is expected when compacting proactively via
>  * 1. /proc/sys/vm/compact_memory
>  * 2. /sys/devices/system/node/nodex/compact
>  * 3. /proc/sys/vm/compaction_proactiveness
>  */
> static inline bool is_via_compact_memory(int order)
> {
> 	return order == -1;
> }


