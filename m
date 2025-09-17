Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B28C9CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 07:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39508E0002; Wed, 17 Sep 2025 03:38:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEA5D8E0001; Wed, 17 Sep 2025 03:38:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD8D88E0002; Wed, 17 Sep 2025 03:38:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ACFDC8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:38:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25C591DDFB3
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:38:48 +0000 (UTC)
X-FDA: 83897940336.04.A06683A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id C04B080003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:38:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E2+PiBdF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1paEusad;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E2+PiBdF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1paEusad;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758094726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ITCMlsFIxE+UIfyD3VibFZmpAdYbM+Tp7kiWDSAXLy4=;
	b=mj3Sb93Z3PmJDMwSYiqa5+fO37wegzPoLk9dmFzapMqHqHqdUYgdCCCjx2UtfqakCbbvXh
	9mD8tTh+U6giBHW+eTPRf7YztiTqwAwIZLpLpZFlNutJakZZvC8C6fZ03MUKWsK5BJ/qF5
	9KIZwIHNWoX++HDPQLPuITRTGPYNtvI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E2+PiBdF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1paEusad;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E2+PiBdF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1paEusad;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758094726; a=rsa-sha256;
	cv=none;
	b=tQ5UpQ58OBP6JVcOAofqPp7Xpmy8YHNBmCJmvkrVS1RLYvoobFpwCxBS7sy1OkjsEl82Kb
	tBpXK4L5p3xV5wbeeC6LDnLpyfI+9KKY/V1Q3UpE5IjMYRCSDnM0XFveqYh7SS0qBGfx6i
	592D0IM9ATeqYXJekANgg/matb+TDno=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 26CD41F76B;
	Wed, 17 Sep 2025 07:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758094724; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ITCMlsFIxE+UIfyD3VibFZmpAdYbM+Tp7kiWDSAXLy4=;
	b=E2+PiBdFDPIdItusE2CFQ6kmbOtgMsO3tXknJ6h4xEGiu6QrsDXz9v4zf8wN5nnJwjAxZY
	ZLegEOkn7JWH+C41Cby+xregx82MCxvwavOE1H444XXl9daxJ8JqErEp0siyVRfe/roD7H
	zmrQGKzWOJ7nTakUW062IHzxYJq1lkQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758094724;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ITCMlsFIxE+UIfyD3VibFZmpAdYbM+Tp7kiWDSAXLy4=;
	b=1paEusadbNBcfB/T8WMGOYKKw6YeqRzlOxtiJC1MFrwLFWJrCSAXlfq+rMEkTowpK0QzQo
	o2hV5Vae79YdtiDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758094724; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ITCMlsFIxE+UIfyD3VibFZmpAdYbM+Tp7kiWDSAXLy4=;
	b=E2+PiBdFDPIdItusE2CFQ6kmbOtgMsO3tXknJ6h4xEGiu6QrsDXz9v4zf8wN5nnJwjAxZY
	ZLegEOkn7JWH+C41Cby+xregx82MCxvwavOE1H444XXl9daxJ8JqErEp0siyVRfe/roD7H
	zmrQGKzWOJ7nTakUW062IHzxYJq1lkQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758094724;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ITCMlsFIxE+UIfyD3VibFZmpAdYbM+Tp7kiWDSAXLy4=;
	b=1paEusadbNBcfB/T8WMGOYKKw6YeqRzlOxtiJC1MFrwLFWJrCSAXlfq+rMEkTowpK0QzQo
	o2hV5Vae79YdtiDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B967137C3;
	Wed, 17 Sep 2025 07:38:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1PV7AoRlymhxdAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 17 Sep 2025 07:38:44 +0000
Message-ID: <af62a2c2-3c01-408d-b694-aa7e95d23c18@suse.cz>
Date: Wed, 17 Sep 2025 09:38:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>,
 Usama Arif <usamaarif642@gmail.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, hannes@cmpxchg.org,
 rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com,
 shakeel.butt@linux.dev, 00107082@163.com, pyyjason@gmail.com,
 pasha.tatashin@soleen.com, souravpanda@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250915230224.4115531-1-surenb@google.com>
 <2d8eb571-6d76-4a9e-8d08-0da251a73f33@suse.cz>
 <CAJuCfpHXAhGZb1aOPyHOPiTWSwQJi570THqJQcjrVPf=4Dt3xQ@mail.gmail.com>
 <a8519bca-ae16-4642-84a1-4038b12e8bb0@gmail.com>
 <CAJuCfpFJabb02OK8Rj08d7WU_7AM674i=vsZxzfw7i7h-PGftQ@mail.gmail.com>
 <e5e3d96a-d0aa-4466-8303-5a7e8f96bbe5@gmail.com>
 <CAJuCfpEULVxMixDjrk_xg7+3+97dkcMmkDd++BaR17X4tDSs6Q@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpEULVxMixDjrk_xg7+3+97dkcMmkDd++BaR17X4tDSs6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sunu4snyrcs4s39pbaa8qjow9k3cygau
X-Rspam-User: 
X-Rspamd-Queue-Id: C04B080003
X-Rspamd-Server: rspam04
X-HE-Tag: 1758094725-944253
X-HE-Meta: U2FsdGVkX19FdCXGun7DDXAO1tgTmYGsWeg9XcuvkHmjVhmeayz3sJyCFgNh/zDZkxg36YO3xTq0l9/2wiN1e80aS1CjpsTyoTl74AGec99/MTgtMgXerba4H4unctGUk+HtnjBowPhALaKeeqqDwTFp/L4bBNdAtjlqVyKxyUHozN9h+Z2LWLFE3bkb6aVu/Dpc+zShX9HKdnRIsTn1WWwj4URZS4jYp7lrzuae/wTjvI/GWoKIrGGlPv3+VSiBYwNEpcDG5G7rhwhmgfK+mvgH4pUVrbr30pRcRS2KHVu0oX+LTof9JJQmE2fXfXLEszsV3lZJenNIBpb0R599G85SUNx0935TWaI+MT6IgvU3UiC/fZ3VGSdOVsSO4179RhvupwGhbI4lhUakMslGArCkp8iaVub/j4je+pHEzSSeAJdR9V6DwGUh5qt3IIjQAiuU83jZuo1cy2VMfFMj2NADz1Eg9xE2tY+QEciEPIMpzKDa3lUgHW41vdq7xbUDFBt0smCk8IyiRb+FufVotk3etOZfNX79pR63AenaSgvAuRwITXqbjvFO/QF5AYawJ2M5xSYPJ7/Y5HgLrKqC3f2uezu4qyxLUE8BpPIYv3XMXEsGReRh98o+Y6+jYVapECMVby2wCZcPd9P0WKpaHFlCu6JnNJ1BFaArMhy0SO8J6s3JtWeHJklVP1/9q416EgMmaJlO/Gt4iHNyFQX+TdYuywBkmf7CZkuNps+0Sk86txKY21UgWXqRMTqeyfLpVkF6PBok8lPyXJlCk1CAXVwns3EVQzqmIf0u4CDfX8Z+gL0G0Gkxa3EzaBOco9Ye5NY3zVDrfH0DR7ZUBAR5gRj30eu6kj58Tq6NZ9+cquwaNGlNiFZ2FKOck1FFqHnrL8MAQB8LyOrBpO47vSQqXxcf7MrNGuffFOeCPM8zDFqJBPh4I2NGqbNXbrizdVh0m4RUW23fUKMInC83arT
 c7TxFf8F
 yDBs79+hbTZKnuPMTQ2ads5eK1s8kO7Cp2b0Y+Pt+FibkbA5yUUy4joKgJTdxidyLi3ALdqPwjCQlt4pAyztp7qvHJc4xhXgB7n8dNRmGBZ8StpCgG3bBizqs+Nlgb7q8ryRlSrRAhSOg+EvuTOzh015T2xd7geceqjlqV4MtERggEKwqLfY9bE0GbEMYn/3MqbI0uitoxqH/FdbpCKI7sTOFJeLR9Js2RUSlWvdTOrIY20OkWehyw0U7UvGTx0hO9WWaX/liA4L9hJ2r+P6VF8lRhMJrzXFwi0khD1ZonfJ2EypVln6LzdWUB7TQH5EaqEx0hmP6PPr69eQitFCCCzPwcgGGww2bsNzcMTx0MI2EbredfDdp8qm2PmUB8kgGtwbu1DDm0ptyQQQpIEfBYjATYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/25 00:26, Suren Baghdasaryan wrote:
> On Tue, Sep 16, 2025 at 9:52 PM Usama Arif <usamaarif642@gmail.com> wrote:
> 
> Hmm. Missing a large allocation and not knowing about it can be a problem...
> I'll start sketching a patch to see if tracking such a global counter
> has any drawbacks and in the meantime I'm open to suggestions on how
> to expose it to the userspace.

Could it be made to look like an actual tag in the output?
e.g. lib/alloc_tag.c:1234 func:untracked_slab_objects

(probably some better name conveying it's uknown due to failure to allocate
objexts)

Maybe even implemented in a way that it's not a specially crafted output line.

> About concerns on the IOCTL interface, would it be more usable if we
> get the alloctop [1] or a similar tool which can be used to easily
> issue such commands into kernel/tools?
> 
> [1] https://android-review.git.corp.google.com/c/platform/system/memory/libmeminfo/+/3431860
> 
>>


