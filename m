Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A116C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 17:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A435F6B0165; Wed, 23 Jul 2025 13:32:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F4686B0166; Wed, 23 Jul 2025 13:32:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BC276B0167; Wed, 23 Jul 2025 13:32:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B0446B0165
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:32:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E7B3B567F0
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:32:28 +0000 (UTC)
X-FDA: 83696223576.19.60153DC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8E81A140014
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:32:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pzp8XHwa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=J+Sae5JF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pzp8XHwa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=J+Sae5JF;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753291946; a=rsa-sha256;
	cv=none;
	b=Sh5deOcPtyFbBWG54Zk69FIMx6WjAOb4gsnvnUcxCZMfluCzVzy3Lb8Q4J0MZ9/dHzLEcL
	KhaxVBCOonjzIga/sTmuz8zKuUFY3t2MGntGLUqKh4VKj9fCIaLUglTUtACW6IfLA4vNgM
	igXYY4ifF7e1z1aotV6kgKuGFoSPXXQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pzp8XHwa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=J+Sae5JF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pzp8XHwa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=J+Sae5JF;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753291946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uv9cgSgJNK/4SUviYYqTvJigVNWYVKzTAd2VQDKUkF8=;
	b=7eGDNzFSZsbTuZ8oLpb7C1QnkVsHkoyPqZan2Tafbqh3/o+ldTRq5zVOOnyMs28dFJOLZh
	YiJCdMloftauQ5S2nmYGKZr6dE/FvdVrz/2e7SdU5LcfstDg3rOYXOOkFPO1qE3xkQR97Q
	Uf2GnCPCFZN3xr2Oy/2RgbXxSzwCaHE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CE6F31F793;
	Wed, 23 Jul 2025 17:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753291944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uv9cgSgJNK/4SUviYYqTvJigVNWYVKzTAd2VQDKUkF8=;
	b=pzp8XHwaNXj54Us1LhOKjVEzmk6KLKrTghaeHTchfUuPX+ZIW84zEc8kaFrPFk6wQbAKIW
	4G7Yb0TsgSA+3hPMR010shZ7pSF7/0gZ6LP2M36cJe/uOtglVbgYtp5domlJMgYACKnnV2
	2UeEdUdIIeTRo5mhWQyelKVYxYM9C7s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753291944;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uv9cgSgJNK/4SUviYYqTvJigVNWYVKzTAd2VQDKUkF8=;
	b=J+Sae5JFx6TQ0BGgaEjNIA1HgP+INc/cVdQeNp2B500pIn4IYH5zCfdvCrEU8Ifl62P97L
	o/s9fnhvCbfuR2AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753291944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uv9cgSgJNK/4SUviYYqTvJigVNWYVKzTAd2VQDKUkF8=;
	b=pzp8XHwaNXj54Us1LhOKjVEzmk6KLKrTghaeHTchfUuPX+ZIW84zEc8kaFrPFk6wQbAKIW
	4G7Yb0TsgSA+3hPMR010shZ7pSF7/0gZ6LP2M36cJe/uOtglVbgYtp5domlJMgYACKnnV2
	2UeEdUdIIeTRo5mhWQyelKVYxYM9C7s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753291944;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uv9cgSgJNK/4SUviYYqTvJigVNWYVKzTAd2VQDKUkF8=;
	b=J+Sae5JFx6TQ0BGgaEjNIA1HgP+INc/cVdQeNp2B500pIn4IYH5zCfdvCrEU8Ifl62P97L
	o/s9fnhvCbfuR2AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B505513302;
	Wed, 23 Jul 2025 17:32:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eQWbK6gcgWhlZwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 17:32:24 +0000
Message-ID: <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz>
Date: Wed, 23 Jul 2025 19:32:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
Content-Language: en-US
To: Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>,
 kernel list <linux-kernel@vger.kernel.org>
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8E81A140014
X-Stat-Signature: oa4cxp4176s6nqd91hbq9zqpq5o3jc4q
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753291946-46628
X-HE-Meta: U2FsdGVkX19ygUddCyMMD4juL8gNVOoOAosD07y5p0b5o9dMuIcxaMPPltFlsIS8dYecw5NjMkU+w8I1ed9tsprmeNBQsErQlIJZMfMXL/T/BOumSiJZrlmyu6T8mCvm8AMMmk7IKd3A95ayFxPaD/uHoGUosdgLQUJQV0kRvxbLGUIMezDb8mC9LmvbiFYMvtIT9UFtMrPIVG5ctSCbou78fuVz1i3XzLaZq2yOJwZDOv29JeT5PIQ98FgoqN2+EJnEmkqXqwqh3J0oXNxikw7MZa59459tfoNPiKpfNmtL+MnDZL87/qWPxfyMTeBkn0BXQysDxpzTzSMJbygRUOusE9rhrd1ZQF9zrXeKERAYlpd5jLinvpxkYGPGahmefffLTD6hnDKrZGAtWkWBWrCtuL0fZIPEKRCA07tFbO20fUR81rvgViAx6nVqJSHkBvBo5UG/1Ur4QIbR8+b5qWG3FlAKIP5PTku/5wyBK5i89gHFZ4KYlbUlkvxGB1OoxtLktuP30fkx7a2JVwxFZk02YD4VbqiD0u34aGzVfaipzXxqMFzs2hu/9QLLsSSuFQfY+dyZem7eOLEda5gTiRcBRZe90deoOXxn9365Cuj/TV93Ok5y5fdUxv7VwljcIXgCDqrgvjHt+h9hFKOlLyW39+3s3GthLYBiK0IpVlKlnWEhWqGKIwRy5tjc04OH+SmBDc07QXdcfdMxB3OIag8gEl4Wvn9vIsonCmZOx7rsuLouzD5pfRXcRG3RqGYve5EP3TzARDRSCp8lmwfQ9aV/mG19+3f98iD+YgxpJ47uM53NLEwdpUgblA3+PUxYls3mr4pDRfvAq2/qTev6oM/kynMRY9Fz45JrHEL7nkSmaG2cmaQTSJkmFILQ5R3Jm3c69IrWsEnDJx1KG4Fbbr2f13avHrmd6a5p5x/pND1BVM7KLvHobmmPqEi3LzHs6ZXe8CB9YrjUejeGm+w
 ksSpeasE
 rgIHlC29bnxjVXZkVxB0MycamJAFfJDaFu0jo+C1KDaRixpVTZUDo0LrCr/BdhmGubyPaT1Jd7f0aFa9pM/fsMkk3ceeJflfBDpCmoxoJsctRM4mLl+Ig362OwgNtg7b77RIxTE8YJuERjo9PPENM8Fjr7VZnR05HYVzWoY0iNzwNP8wHeTyqcE0YS1ydtUm5f+bNWWIau2L+Msvwf44tqgAViT+LTNkQGFRcoJqRu37zPu3iHIOd1c+ILGh1caXFgjonUlPZATReAyKbq2cHA58HUNfLFUa2ApTQjeuSzgD6Ag5QiWTc/TH3n3OolcaAWx3UXpgetfnqgJ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/25 18:26, Jann Horn wrote:
> There's a racy UAF in `vma_refcount_put()` when called on the
> `lock_vma_under_rcu()` path because `SLAB_TYPESAFE_BY_RCU` is used
> without sufficient protection against concurrent object reuse:

Oof.

> I'm not sure what the right fix is; I guess one approach would be to
> have a special version of vma_refcount_put() for cases where the VMA
> has been recycled by another MM that grabs an extra reference to the
> MM? But then dropping a reference to the MM afterwards might be a bit
> annoying and might require something like mmdrop_async()...

Would we need mmdrop_async()? Isn't this the case for mmget_not_zero() and
mmput_async()?


