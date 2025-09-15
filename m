Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC5ACA101F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 07:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09748E0002; Mon, 15 Sep 2025 03:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1718E0001; Mon, 15 Sep 2025 03:21:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A8EA8E0002; Mon, 15 Sep 2025 03:21:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 75BE18E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:21:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BBF88B98D2
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:21:20 +0000 (UTC)
X-FDA: 83890638720.22.8158D24
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6A0D4180002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:21:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aXitDdmo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xuX2f4ZL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aXitDdmo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xuX2f4ZL;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757920878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXzSMCtEJ6DwIEW1xw8G1n6EK7kUk6ewP8JZ5iyPisQ=;
	b=OOZNzWNhlFer1HsIwx0o+uNfhKTDUX7j40Eu9yecG9W2Bf220BmISYbeES3DxMPFfeQ4MQ
	oW2YrI6IYzkVgS6l5Iyz1JXyqS0XKrZg2m+6bcv0kTOjo9rPaRAjn/rJlGke00K3NkPGcC
	F1XFP/gJ77odsHSBSq5e3EmXD3ACPLU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aXitDdmo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xuX2f4ZL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aXitDdmo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xuX2f4ZL;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757920878; a=rsa-sha256;
	cv=none;
	b=QOQuU0G0bkE7u/Ap4QCoPGphQ3uKJwTgwPIhLyFtEWd1Jy/amI5fbryuVuB07a9+E0QwJp
	L7LgyR6+gSU7XTcfBM2jEJNyWJcmMSP8mnhmN1leN7UW/goJrtBEVITXOAaQRvP0JiOFvs
	XDpfvpUXQC1e8aT0bS8LPgodjxTTEPY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A662F1F7D3;
	Mon, 15 Sep 2025 07:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757920876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RXzSMCtEJ6DwIEW1xw8G1n6EK7kUk6ewP8JZ5iyPisQ=;
	b=aXitDdmoyCJ4eESAnJA9sxjgbLVLzrXwgerfMVONUFOevIyON3ssT3k+incicYrV29rYm/
	94o6bwxBoq2BBduBpKAPou8ZRyCQB5y3bpsBqzTJJFam+80FHj1wEfiPRXYkMYizzpj7HV
	6XTkNv8fKEWu6BZbTiiY+ecAQjag8QI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757920876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RXzSMCtEJ6DwIEW1xw8G1n6EK7kUk6ewP8JZ5iyPisQ=;
	b=xuX2f4ZLKM3f7VEHK/N46Cepg8M8r0WtRJxYauXMHJ+B3kMwhJj0f0POJNOyjWQII885wP
	2fwtuLC1aH+tUSAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757920876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RXzSMCtEJ6DwIEW1xw8G1n6EK7kUk6ewP8JZ5iyPisQ=;
	b=aXitDdmoyCJ4eESAnJA9sxjgbLVLzrXwgerfMVONUFOevIyON3ssT3k+incicYrV29rYm/
	94o6bwxBoq2BBduBpKAPou8ZRyCQB5y3bpsBqzTJJFam+80FHj1wEfiPRXYkMYizzpj7HV
	6XTkNv8fKEWu6BZbTiiY+ecAQjag8QI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757920876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RXzSMCtEJ6DwIEW1xw8G1n6EK7kUk6ewP8JZ5iyPisQ=;
	b=xuX2f4ZLKM3f7VEHK/N46Cepg8M8r0WtRJxYauXMHJ+B3kMwhJj0f0POJNOyjWQII885wP
	2fwtuLC1aH+tUSAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 888AF1372E;
	Mon, 15 Sep 2025 07:21:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4SWdIGy+x2gAUQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 15 Sep 2025 07:21:16 +0000
Message-ID: <02568985-b6c0-45cd-924b-f86f7975c119@suse.cz>
Date: Mon, 15 Sep 2025 09:21:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/14] slab: add opt-in caching layer of percpu sheaves
To: Hillf Danton <hdanton@sina.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250915001139.7101-1-hdanton@sina.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250915001139.7101-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6A0D4180002
X-Rspamd-Server: rspam05
X-Stat-Signature: 1td1ewz9y3sj8o3gpkg9afh9g1bnumx5
X-Rspam-User: 
X-HE-Tag: 1757920878-740563
X-HE-Meta: U2FsdGVkX1+s1PnJ9eRP7AeU2+f3eJcqiNhHL7nOy/SEtjLo+JOpYJOURSHE5xYPCbmYH/VHQHx2Rp4Aug6C/VKlTkc4Ihn+MA7LlbI/OO7+0NC/+Bc8PWl0iw8sFTo0M/QgMk9sry6zMlS/e3a6KgWihZn1DSrTsUyLqglA5aRD1GEdw2fTQz0qV1XhytjrIygQbmA0Yf3uADAVX/3kzHaAP842Zt1DkQHIEA9K3UZ3OVGLhDMQUxJE2DLbxkzsNDVC5mFDfGEac3AuvuBAuhYe0U/apxmDuBGJuavGFgceojajOLSxbIPqlhMKeR0Iuos3oroa3cWpoCk9ZpRifSQYEn9xzPLz1UUvvoWMoLQa73OWFYEewZK9c2ZD8sLxmRZ5J6s62cAnAb+DURoBHNUaN1eimrNozbuICElrWfqATfCoyFXYNdMvhskaURwq5dRoTcnrkXUYxVMC880QyFDKo+ltP5yd/r9ZIPtPRYwS+PhefbPNP7uOlC4MSOQOIpnObf/kd3iWbMsU+0APnuaE65+WVp1JN69dDyilfq4X1gNWCoUN6wX/JFgyKBxmArxBY8U6u/nVhffqEwHdYl/ldEWEUO4BrT4gBCQ49X6XZO0Ew+8r8S3o/AkUFn+kjUt4E+1OAfH0QhH42qTDmT2ud9i29m+ZBPIy0ZklhZZC990SI2pzO8grNjr75TAWAa2i+XwgGweiqkhBOF+ElWNllvNvSAGQ9AgSUM0F8wRTyNcrZW1Gb+R49UNewS8gfGT6YlrBnR130R+ygdMY8l7JTSK8OqOeKa6s2lEKuj25lcl3Y3BRsXi4A99wrBEyqctdEu9YMcrhxQPkNYe9cQ4clFDtd+AFrLqSEWnDYPBHIDxmdUFTuujS+lASUDGV9B9dKQoZVGLFP2CEv+3QND5heeMpqisMThnOng2Os7IP0dLqWeBMr/xSp8d2zbOUuSbGpo/2/+i1g91doM+
 l48IUPLA
 600+Pj0VpFFVMVDt81eytceGwuZ/3IU2nyB8VgJyuUkPoFVRbhDfEQSHv8K9H7oNT6571IzMx7bS8Jv2qH6tO9ZSypCBe3zbqPBqkByNdW60jeemb4Rl4uwkGnnuG7eWQtJYhwXNyGL/+wWMkKsOun4mMg95uKhw0BFbKA8XJbFdCZQdB4jV+rHejpM4WBlfe9+Nw4lDpVidAR3Hk+GdWPUYMUArk1JivfYTX9E7qOX8qa6YyWNc4uwhRyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/15/25 02:11, Hillf Danton wrote:
> On Sun, 14 Sep 2025 22:24:19 +0200 Vlastimil Babka wrote:
>>On 9/14/25 04:22, Hillf Danton wrote:
>>> On Wed, 23 Jul 2025 15:34:34 +0200 Vlastimil Babka wrote:
>>> Migration is not disabled.
>>
>> Can you elaborate how it's not? There's a comment above the function saying
>> "Called from CPU work handler with migration disabled." and we have relied
>> on this before sheaves. queue_work_on() says it will run on the specific
>> cpu. AFAIK the workqueue workers are bound which is effectively disabled
>> migration (we hold the cpu hotplug lock).
>>
> CPU affinity and migration_disable() are two different things regardless of
> queue_work_on(), no?

Well as long as it means the execution of pcs_flush_all() won't change the
cpu it's running on in the middle of the operation, it's the same.

> I think you are right in accident rather than by design in this case.

I don't see a mistake in the design, there are many queue_work_on() users
relying on this property. It's only the comment wording where "make sure
migration is disabled" makes you expect there to be a migrate_disable()
somewhere? But why if it's not necessary?

