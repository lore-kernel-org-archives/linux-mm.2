Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D00EAC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 06:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2BD6B00AE; Tue,  1 Sep 2026 02:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53AE6B00B2; Tue,  1 Sep 2026 02:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1B576B00B4; Tue,  1 Sep 2026 02:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 956916B00AE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:43:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0CFADA3F27
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:43:05 +0000 (UTC)
X-FDA: 85164251130.29.CF7D64D
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3CF59180006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:43:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eMxazzka;
	spf=pass (imf24.hostedemail.com: domain of tahasezer.is@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=tahasezer.is@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788244983;
	b=xzSo7LfB18Gkh49Crb59I1H1QXLcRwT895mlY1RpG5lwp+BopAYJfpB1LrAWsBgVtVXZ1a
	u3m1cgFdhAiQfjQlTl028NeJpO78VwCdNE5UppFNYSNYuKn0VqiR45HoNI9OE9YqNHwHG8
	PIO4Q/89llH4zLoRPb/wZeK1eYWlpRI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eMxazzka;
	spf=pass (imf24.hostedemail.com: domain of tahasezer.is@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=tahasezer.is@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788244983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0mkAKxF+MYjQouhURxCh1vledmCnXNSmvpvHTqzwp4=;
	b=qCmV6TFyAXOXVcL0Sep4rLcXn499zxr186kxEmuaizWhmARXIsOIZIb/xjAnhbgfnVj8ON
	Dtflv7avRRZBzSy7KoleCtVhvEXk7HXqyM9n2Zx6GjpMqDp34GR2U+5TDHot2dmxzhZ2j8
	nqNhS/XFG4QBoC74XYAO99FS9unD6SE=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48441a2ba1bso359069f8f.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788244982; x=1788849782; darn=kvack.org;
        h=references:in-reply-to:subject:cc:to:from:content-transfer-encoding
         :mime-version:content-type:date:message-id:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+0mkAKxF+MYjQouhURxCh1vledmCnXNSmvpvHTqzwp4=;
        b=eMxazzka10nStAyQiZTRbTD2KbnxdehIHN/XbIjF4rt09jFQUBc+TmuMrx4j9ShDTN
         q9CiLeKTYrGsjC3+6txm+gVLlfsY1pIUIkGop4Y18LQA/CgVe+5WsgnQIDgYw3iDc3jn
         9D5uZJxGOc9dg8Lzn2LZUCbmXigRlRrNm2WzLhWOfBgTaWXsCLn02Wrxghx+J9Ab2zgO
         /RsCMZpr05SegCP9C6hOuVuXwFwrbGcsdb/MalnVa63QPcX0YAplzDL2+ETGL4rEfCNn
         ItOawAiU0xgvQ8w9rrnlJIeFXoou8pm+n061D+Hi0zVuEw5PNPMu2g8mpvUeKJHWp8A3
         H90Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788244982; x=1788849782;
        h=references:in-reply-to:subject:cc:to:from:content-transfer-encoding
         :mime-version:content-type:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+0mkAKxF+MYjQouhURxCh1vledmCnXNSmvpvHTqzwp4=;
        b=a3kKiGG2V1HsY5HT9K0jSLaAnz1wfV6lcHm7u54nMEdcU3Hm8L6UlwKyczabNSrWRw
         2jQdAyqbV3Aqa092AVpkT5MK9QnNlbjbJqc0WqDqUHK+vibLPQcm5vhEBKMm43q174tW
         LrAu7mHmxEyfX+BgjRmZJA1rNxXcNW4W58SDiu3oLNxG5aczO80lDN+9onGQOCrZtcqG
         W2fmVfvNwa/AkvMzmAt5eonZkMj3PHdQs4UyeGrfFEPN7FiF1/6rZHmxQHVtenYIbzO7
         +QjQS7iZtnMrTl6OUi+W9t3LNxBPpytF9kErRj6LKf2JJ6ycU4aTqcQv888VnBzSc8wO
         nVRQ==
X-Forwarded-Encrypted: i=1; AKwUvByHrhykl9hQFmyNV8G5jGI5u6t5knnNpJOHMki5dI30FOifHfx19XRgF5wsDqBYyNhF/+m7J77ywA==@kvack.org
X-Gm-Message-State: AFuF++ma5ihFBloAVNaJiF1Cwq9FHVeRNlS/jrDpQ2EF1ffurUABwEeT
	b6DikdAvU7c47O1YaQXL+u6r9evKuumVS6RHd6FP78oSgOb23vfRavVh
X-Gm-Gg: AYBFou32yGZBhem6N/1fNEvsCkpxvA4Pb4G8dnSqIQcEJH05t5csB3dQzzkYWbr7ciJ
	tTwabCqP9KpxuCrbCNrJPS9wZkDhupuo/RYoq2NyoFExNjV2y9lMYst2N2hGsaYxD0OPHJxiqHQ
	mKq0vIkppWGK+fL4fKRNY+8CEgtbPEIM5Sm/AKatcnSrVenfpH/PI3QjbF7uQvNj2lfjW5nC5Er
	PSC+6Q5zD/mrzApVjI2GfyFHT0y4bKqkDP1WI3gDUQBC7JozPANkfdbfrZew7twyYX80uYsFDFS
	MJGk5qebmY8RQU2oUK/uAcoFCy35PyTX+/zWdLSRgJ7KRP0+a4XzUlYJZLPidIEF6tAnDoJfMFi
	BM3ibUIqgIsrRad3uJfy3+xX1geZvOlN6kukKwwiB/2biIHzbTZ6jwizgTTkb7p0FSDLsCjWZ0Q
	bjHLgsPin107R6iM4N4U3kOmrISTlIMN/xRqBDxS65mGL4/j2Uu4Z1Abmx5US/mygWDpobmo9qQ
	e9muxNDir85osa+Lion4wPNepltquVP
X-Received: by 2002:a5d:6dd2:0:b0:484:416b:7590 with SMTP id ffacd0b85a97d-484416b764emr6601921f8f.10.1788244981559;
        Mon, 31 Aug 2026 23:43:01 -0700 (PDT)
Received: from Minno.localdomain ([193.192.121.123])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48442d3c460sm2724832f8f.13.2026.08.31.23.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 23:43:00 -0700 (PDT)
Message-ID: <6a9673f4.cbade83c.66f7c.3d66@mx.google.com>
Date: Mon, 31 Aug 2026 23:43:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
From: Taha Sezer <tahasezer.is@gmail.com>
To: ljs@kernel.org, akpm@linux-foundation.org
Cc: david@kernel.org, vbabka@kernel.org, mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmpressure: scale window size based on machine memory
In-Reply-To: <20260831130316.448-1-tahasezer.is@gmail.com>
References: <20260831130316.448-1-tahasezer.is@gmail.com>
X-Rspam-User: 
X-Stat-Signature: enqaqczkz3cnuimnbdfeiuc1bry3ujcm
X-Rspamd-Queue-Id: 3CF59180006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788244983-169950
X-HE-Meta: U2FsdGVkX18lbbpYvHIl3b9mmQYBv6+C2gl+tWb95QmTfYjbE+5Ag/29s4YsVp7NK3dvwg2bbivq6AhsF0fqv8b4/7mYjQDsRgUbPDw533eQsXBxE+5jV6qAuUKKd0rtPDxmjJnBdg6x4BY/NDLL63PgP/SkCDuHq1cGXHzxuANdsMSEXAPhDWHqpKN5+4xJbuzHCHIwvgQnVr9KI+r3efopy9Jg2WFtl54pH29LxYVsaRkijdvvgXTHjohRfW5oA5iUPo1SVzAw4cUcBm+gCJ//i1BXaE3i/1vXXdzA47suD7s8euB+CVbREEsE+TbXmTasmWlk9d89/g+FnzVJHHV7872R8fS7qvKJdvJW4a+AFwUquyOjLcrhsPAPqWk80b82X51o7hphdT2rerR7mR44cXaLnk7ej69h5zXZz1JIGcHWf1H/Gg7srmleyKW10XoqelM+2vEnruqZfG2vhfduvYiKNgvSRLT6W0SsFfCSuND9V+Mok5Fi5UkEjaVm3CI1L65wAQeUTJEYtuP/7uMUZ9waMQEUD+JZ/9GzgpYT+HxJ8f54fiMheTJTsWOfqwO9YpBJS6k9aWMATzQC9rYtw5jwfuI12iCgEh/Wrp9qUkPsUvtdBSzMzVJr0wg4TQJmjYdF0ykDhLZUSA9+aDHU+V1V/ss8nKyhmsd7IXoVqWlX1nwgTiQVX2onBtmQmZPiqZO27vs9dxiZl4eYlbWfDjZvIJ6uTY7lMtuoDNOQ/XUJXj9KnH4dT+CUzlBQG8ZV9DUOwnOtM0JIBklX80EHEnENnjjxcP33iX+T6wDOzbqYdosgmoBG3Z0hoZ3hRWMdpTB3TwNNxs/+BAK9EaEEzjj5IYGlCnUhZXTgPUxhz5DhOsz61cySFhdKVjSnKtI+cHjTa5PQqYDRQwMLfRdCQIG1m1h7HmPxCeIpqJHqnW0TUEdcYuiSPUnWFeVeQbgco/cMB0dA70ZNvzp
 JFytgS/v
 fOvGfsKhDts6oqpvcu/JMHXIIfYyYqCXEQc0CcxNEnvsoHU+N2/KJM9c2XeJ+aShb8vaPyOAQCf9txPgRfwpCGDMo7Lxxk0vH3AXLAVsEX78EfTq0Iq9tKe67+lKf6XSU6kEb+pmv3B5RBiJNvhpr5ozrzB2OwR7y2KYs6pqKyXjkeMP8KfAOhR1xANVK2Zyk2hbq15RAFEYTuCz8QTRli7KrRi+tUWUoa07X8Gp2qbXiueHmzVFqgkkbQPOybKZ2KJReiKsxMRwYqpeNq9tfghy1BxaFAO8JoTJZRrfYbrKGyrz+cQ8Vz1CCQHrLsNCI8qPgD21TOljzeAbFgC4iV7ZT2VVudgK0kh7MESeLopG0lUXRUhfXAAjLMqTr6y5VEduLHd0UFtXydGiikuU/tE6DEx+6MkUahxIJalVFtUkhQHNxru4qTsm+RIGdhKz6XmJE1iIby5c0j6nqETKlQdoR97HLsXwdFD8I5pi9YO/SOYI+bUm42w7/pcQIhbeJyuFFcwDZATSe2yU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgTG9yZW56bywgQW5kcmV3LAoKVGhhbmtzIGZvciB0aGUgaG9uZXN0IGFuZCB0aG9yb3VnaCBy
ZXZpZXcuCgpMb3JlbnpvIC0tIHllcywgSSBkaWQgdXNlIGFuIEFJIGNvZGluZyBhc3Npc3RhbnQg
KENsYXVkZSkgdG8gaGVscAp3cml0ZSB0aGlzIHBhdGNoLiBJIHNob3VsZCBoYXZlIGluY2x1ZGVk
IGFuIEFzc2lzdGVkLWJ5OiB0YWcgZnJvbQp0aGUgc3RhcnQgYW5kIEkgYXBvbG9naXNlIGZvciB0
aGUgb21pc3Npb24uIFRoYXQgd2FzIGEgbWlzdGFrZSBvbgpteSBwYXJ0LCBub3QgYW4gYXR0ZW1w
dCB0byBoaWRlIGFueXRoaW5nIC0tIEkgc2ltcGx5IHdhcyBub3QgYXdhcmUgb2YKdGhlIGRpc2Ns
b3N1cmUgcHJvY2VzcyBmb3IgbXkgZmlyc3Qgc3VibWlzc2lvbi4KCkFuZHJldyAtLSB5b3UgYXJl
IGFic29sdXRlbHkgcmlnaHQgYWJvdXQgdGhlIG1hdGguIFRoZSBvcmlnaW5hbCB3aW5kb3cKaXMg
U1dBUF9DTFVTVEVSX01BWCAqIDE2ID0gNTEyIHBhZ2VzLCBhbmQgbXkgZm9ybXVsYSBjbGFtcChm
bHMobWVtKSwKNCwgNjQpIHByb2R1Y2VzIHZhbHVlcyB3ZWxsIGJlbG93IDE2IGZvciBldmVyeSBt
YWNoaW5lIHVuZGVyIH44IFRCLgpUaGUgcGF0Y2ggc2hyaW5rcyB0aGUgd2luZG93IG9uIHZpcnR1
YWxseSBhbGwgcmVhbCBoYXJkd2FyZSwgd2hpY2ggaXMKdGhlIGV4YWN0IG9wcG9zaXRlIG9mIHdo
YXQgdGhlIGNvbW1pdCBtZXNzYWdlIHByb21pc2VzLiBFbWJhcnJhc3NpbmcsCmFuZCBJIHNob3Vs
ZCBoYXZlIGNhdWdodCB0aGlzIGJlZm9yZSBzZW5kaW5nLgoKRm9yIGEgYml0IG9mIGNvbnRleHQg
b24gd2h5IEkgY2hvc2UgbW0vOiBJIGhhdmUgYmVlbiB3cml0aW5nIGEgaG9iYnkKa2VybmVsIGZy
b20gc2NyYXRjaCAoQ2FlbHVtKSB0aGF0IGluY2x1ZGVzIGEgVk1NIHdpdGggQ09XIGFuZCBkZW1h
bmQKcGFnaW5nLCBhIHNsYWIgYWxsb2NhdG9yIHdpdGggTlVNQS1hd2FyZSBhbGxvY2F0aW9uLCBU
TEIgc2hvb3Rkb3duCnZpYSBJUEksIGFuZCBTTVAgYm9vdCAtLSBzbyBtZW1vcnkgbWFuYWdlbWVu
dCBpcyB0aGUgYXJlYSBJIGFtIG1vc3QKY29tZm9ydGFibGUgd2l0aC4gVGhhdCBzYWlkLCBjb21m
b3J0YWJsZSB3aXRoIHRoZSBjb25jZXB0cyBjbGVhcmx5CmRpZCBub3Qgc2F2ZSBtZSBmcm9tIGEg
YmFzaWMgYXJpdGhtZXRpYyBtaXN0YWtlIGhlcmUsIGFuZCBJIHRha2UgZnVsbApyZXNwb25zaWJp
bGl0eSBmb3Igbm90IHZlcmlmeWluZyB0aGUgb3V0cHV0IGNhcmVmdWxseSBlbm91Z2guCgpCZWZv
cmUgSSBzZW5kIGEgdjIsIEkgd291bGQgYXBwcmVjaWF0ZSBhbnkgZ3VpZGFuY2U6CgogIDEuIElz
IHRoZSBnZW5lcmFsIGlkZWEgc3RpbGwgd29ydGggcHVyc3VpbmcgLS0gc2NhbGluZyB0aGUgd2lu
ZG93CiAgICAgbG9nYXJpdGhtaWNhbGx5IHdpdGggdG90YWwgUkFNIHVzaW5nIGZscygpLCBvciBk
byB5b3UgdGhpbmsKICAgICB0aGUgZml4ZWQgNTEyLXBhZ2Ugd2luZG93IGlzIGZpbmUgYXMtaXMg
YW5kIHRoaXMgVE9ETyBpcwogICAgIGJldHRlciBsZWZ0IGFsb25lPwoKICAyLiBJZiB0aGUgYXBw
cm9hY2ggaXMgd29ydGggZml4aW5nOiB3b3VsZCBrZWVwaW5nIHRoZSBvcmlnaW5hbAogICAgIG11
bHRpcGxpZXIgb2YgMTYgYXMgdGhlIGZsb29yIChzbyB0aGUgd2luZG93IG9ubHkgZXZlciBncm93
cwogICAgIGJleW9uZCA1MTIgcGFnZXMpIGJlIHRoZSByaWdodCBkaXJlY3Rpb24sIG9yIHdvdWxk
IHlvdSBwcmVmZXIKICAgICBhIGRpZmZlcmVudCBzY2FsaW5nIHN0cmF0ZWd5IGVudGlyZWx5PwoK
ICAzLiBBbnkgb3RoZXIgYWR2aWNlIGZvciBhIGZpcnN0LXRpbWUgY29udHJpYnV0b3Igb24gaG93
IHRvCiAgICAgYXBwcm9hY2ggbW0vIHBhdGNoZXMgbW9yZSBjYXJlZnVsbHk/CgpJIHdpbGwgaG9s
ZCBvZmYgb24gdjIgdW50aWwgSSBoZWFyIGJhY2ssIHNvIEkgZG8gbm90IHdhc3RlIGFueW9uZSdz
CnRpbWUgd2l0aCBhbm90aGVyIGhhbGYtYmFrZWQgYXR0ZW1wdC4gVGhlIG5leHQgdmVyc2lvbiB3
aWxsIGluY2x1ZGUKYSBwcm9wZXIgQXNzaXN0ZWQtYnk6IENsYXVkZTpjbGF1ZGUtb3B1cy00IHRh
Zy4KClRoYW5rcyBhZ2FpbiBmb3IgdGhlIHBhdGllbmNlLgoKQmVzdCByZWdhcmRzLApUYWhhIFNl
emVyCg==

