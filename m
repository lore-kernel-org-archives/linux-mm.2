Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4917606A33D
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 23:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=Nilnk6v6
Received: by kanga.kvack.org (Postfix)
	id 9C98E6B00EF; Sat, 14 Nov 2026 18:02:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97AF86B05B0; Sat, 14 Nov 2026 18:02:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842BA6B05B1; Sat, 14 Nov 2026 18:02:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B6026B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:02:26 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A55E31402F3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 23:02:25 +0000 (UTC)
X-FDA: 85435250250.14.AF8C614
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id BEA5B1C0006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 23:02:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=Nilnk6v6;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf20.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.51 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794697343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ogoLg/UrKn4w2HbWGHqWFTtUp7LAKklTdIxHd1gOThQ=;
	b=ClV5dv+UWYdYNl20n2KAKZrOw2nw4Y8bttIN52pCHjf5y62gtkQ0DqCUAd+SBr9ZKxMvOl
	Uc+hZlVPTkz3CY5+/Fe4/GrUr1J7jOKnsSF5inRNwCmxwuEz/aBN7b94ab1PpkI/FKJxT1
	VA/AZxtzV0C1ExRignRjveJr9BZeh/w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794697343;
	b=oZureOJ9OD/A6gkcu2zlDmAM1YU0xdFyOOiXQLADgzgMzBKDHC9BwBzjV/mR9+o7GReFQz
	0UL8fEbgpAVhezY0qMMhUh3Ms84jOYI7fhDZwIQLWm5KN+XbUs/XttbavZL3Jx+zGclcOu
	Xy/Ibbb9hjKl1eTDcbR5fNBEZRo2MqI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=Nilnk6v6;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf20.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.51 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-14394530ec6so2703679c88.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794697342; x=1795302142; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ogoLg/UrKn4w2HbWGHqWFTtUp7LAKklTdIxHd1gOThQ=;
        b=Nilnk6v6dBwJO454DMrovN3d8U+3lK2lhAEfimuZMIEh5eFDpEVnJysJf4xsEed4u8
         TDNOhSYAdKHTZDfZ6bNzrbARxuykAqis5diqziV7lzm48y9//8o3v76W6W7IyiuUrDgB
         8tH2PuqzVoivmHK8adnAvhoZ68i+KPJyRplp8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794697342; x=1795302142;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ogoLg/UrKn4w2HbWGHqWFTtUp7LAKklTdIxHd1gOThQ=;
        b=GQOOmZ6beN06RExYvpnWDUsSeUAyb2SY5acYAYK9KuIu3ZdjoKpumbwbXBj68zfqoQ
         AcQ1yboHOLKErpTCl7euUrgqpCI8ESXYAvITB/OHPoVKlCMSXENpjFPoIMKx1os2Fyfw
         He7E8bcWTEwA75poRW0Be9dO81ho/sP633x/jt+V3fCvFDl7svXpLNGFNPS7cYZ9iea0
         Q/+wr+WlX924fsb/fnTB/qbGJTuZsmUfxBSRdg+pT7Hjx5LlKYFynn3ckvL2ohU6PQYj
         t+GjR2VSK02E5VKkmMTvngHxxvADz9c6cbNzBcZ+deheaFAh3lECN91C6qiTy2VBIve5
         7y0Q==
X-Forwarded-Encrypted: i=1; AL+hErEVvDTAltsLgpzlRfbZdUao9E/rrxE7OSXEIjrny5vZ7VgVSXOEys2IorVwtA8q8e/fIYNgCISJmA==@kvack.org
X-Gm-Message-State: APuU4Z+Sik6cKDxdfO+lxVhIxDgUrinorFp+VK+Vb1/MLxHXApCAEm7V
	X3WnK/S0rDORY/5VFj5WrmD42RAul5Tb/7lf3SeWRHCpO63FfkNtS3ota1w3ZOq5kMLq4mQkcx/
	00HEOYpxwoqVA
X-Gm-Gg: AYBFou3QO7dB1azs3rTeHikrc8dj8bpERsKvuKuLjvlw+F2+ZYx1MjpOvt1sdijgBZx
	0gaXtKQWU8tjXyLiJXA7WIkd/o5lH3NrgbagP0AQlWmuICoURfOXS4OJd2HX4NfHq8rMaRruaYp
	AlvWzJbj+HUpBLfURy6MX9Um1Ch416KgUKaq2rkOS43zGDuve9sIosYz++lyTT7ideWwqOQVcB9
	CojuTbq7/aGfHc5MSdlDIgErKsqxaj0NS8J58NbNWn4rqAmJ0dDNHLoW8+05j3HnnMIQ7XXL6tF
	tKPvq37l0552s6vQLvaLeBXLz/Z+HshMP9SPBpIJfHCwOEjEHQSIijS4AoaYBXohYpIcr2HeSQz
	tci/TbkMLVtdAyayB1UVoChbwNc7Wk6r/NmhONZgmOfIfZzN9pJloIL21yCv9MxCAzBePz5iMuL
	K2bFC7nXi/Y2Cgtk4C5BPRFPOwJWCwDggBLz4HrHmrnUIVXVqkkSS4tCsSMA/LDuaUE0habLSgq
	7D/A9u/BaPe/0a46RqR2Urqcs3dUvXuRj9j/zCbaubQmEAIMnYzbYAA1vNSGruqsmH1E4AwNnpo
	MNyrC+AE7w/716+EdYD0SyZ1xQs6EM2PC94M0RIzDK6VbRkck0ISoWgd4+UFxVOWfBTl3QlFHPE
	lgvDsUFVHaehdRii/u5bQ2juasmbvrfNTMj4U7iJKXCsrIBr9fxIsp/rYO5cQllr/DTcQnzOpSV
	Mgg/5rmFx9fcCg2BofRLKYpP9AW9iZeXaL6aUy+nefkVs4w5vNZ47Hnqb0jE1jPzjLZVaOt8o3u
	jQkE5gP6CGMNCjN3MoVQXH9rUIwMxexkA==
X-Received: by 2002:a05:701b:2810:b0:185:8c9f:de82 with SMTP id a92af1059eb24-1b503124f1amr5429567c88.33.1794697342110;
        Sat, 14 Nov 2026 15:02:22 -0800 (PST)
Received: from [172.18.0.3] ([216.139.163.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b505b5bf76sm15078205c88.10.2026.11.14.15.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 15:02:20 -0800 (PST)
Date: Sat, 14 Nov 2026 15:02:01 -0800
From: Chris Down <chris@chrisdown.name>
To: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kfence: Allow selecting static keys mode at boot
In-Reply-To: <CANpmjNMunLgXHRqXgW3LnniCX50CLbLYsE3DpY7h=cuvu2vSkA@mail.gmail.com>
References: <auA7FdubFEDVPB7v@chrisdown.name>
	<CANpmjNMunLgXHRqXgW3LnniCX50CLbLYsE3DpY7h=cuvu2vSkA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114150201.d428c3847d573be1@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: y7qfk9ck1wqy1878bgn9quk4c1wcz43i
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BEA5B1C0006
X-HE-Tag: 1794697343-258027
X-HE-Meta: U2FsdGVkX1/Wc+0BJaroUDOwXZRXqiyqq3l24ipWoMdFJmbu44R6HlL+vQHkSujjVZN5tt3l4S1NNuVEdqdDskHpuAswNiKPnQYyeeg3AgqNN4OfAr9B2ukiiCz03KrZ5UUS1+AnSx57tBAl7t9EV41zeSn25CkrlTZpMkr3E1ugXLfnMkB4ARI8qHvpMneFQDW2NRrchh+G/S5WbT6F8aV6znUgUvdrGlPZkuudCh7iRlcbh3qflIKGkDxkzb2LRy7rSJ2MYAaj8Et6lC/JU4K2e3ygsCCzH2aiQVYGJj/vttA9wNwhGkkjhmUinCIEe1yLPnicZzxphDHVkLoKKj1etbxJcOGXTc4KzJyqFhEwZ9ED5MJBcyXqXlPioxNONRFm6sZrKNCsN5+O0rDi9BFF/NBGpxh5V+IEPmxfZ3fuAUsvJeN6EaiCt/Ox6HZ6jPOiLOZBXxvDFvw4XCqqZggOZEHqYEeB0oShAL/7Xawvusa0h+FxXvoNIvgl9SXZzIGUBotPCafaODR6MHTuuMDCgaKYb7NN63hKAMTyKl2818TYE7Mo/Fqkr8CYd9Wy720yDriXfkn8nxzYKEoz8ZMVf72fVDOruqut2M0mJqYxP1jjpMsf2lTOzDkqZ73L5I4oE7Rh2Sx70FaX/VfIXhjova3Zy0kTS0Dz8vbgjaZvG1PTRH1QGrgjps5ds/55QJVXLV4jATbrXZ/IuAL6FsANzYcFDvfdwFbMVGCElGcnxnTuHMX0CktfZ6NZst/p4JLbK3pXkOD4vdXh0qhxPTHrh1dNVv944Sia8i+dvd+6oWkq6nY6SslXe5Z6AVuRnyszPOJs/1IpdqWQNjnDkh1uKJ13rUzFbZAWgxSSCxHKk+4KKFTXff+UfCAFE0AFg1KbcRbqoKZkqkPdKvm8LE5H24/YlULT5wWUWEGyzG14yjfGBN2R9tWfxJUS6zaUlT4TTbKz+Aeh4xva8Bd
 IZEIIbIn
 wXwrbauWNxyfh9zcM/YesFCZZDKVeLzK8zIiDoAGoL5dIFsdX0VOcwYTuTN7zSg51f2nPaJ8HcZcqxqVZh2t22Nlvkla5wZ/0P1/lMwCh+Xj5nsI3OxkeloBMGBdMYKDamegZvNZV9Y4RnauxNudkNO8dpEyTqmW3H02cnDNH2SehhoCNjHEXM+MUooiz3X51LcQ54sPUf73/PxtyMFr1NkS+xxRQLJ7nJAEpWmNJl5MHBpiPUn0YW4PmLhGhzcCbku+65F2CP1wl20U9/QwojGF7sU4YzJ8ABbfgaRJPwlhKk3seO+wC6oRoOlI5gfKKtsvgflbAaT0qCnPlW8QHnslC0Vz0Aenrpg8P+YGOYoBOL/de0AsFJqUhcEBYv7MhV5v6bQXJzB3i+/QcKKpBtaCuus5NySTVn2uBG0BHzUNxE40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Marco,

Marco Elver writes:
>On which systems have you found static keys to provide a significant
>improvement? Can you share benchmarks?

I don't have numbers that show a significant improvement. To be clear,
the hosts that use static keys have had it set that way since long
before I started looking at this, so it may well just be cargo culted
by now :-) Given that, I had a go at measuring the saving on its own.
It's there, but it's small.

 From a quick check I did in an 8 CPU x86 VM, a
kmem_cache_alloc()/kmem_cache_free() pair takes 8.0ns in static keys
mode, which is the same as with KFENCE off. With the dynamic branch it
takes 8.4ns. A kmalloc()/kfree() pair takes 13.3ns in all three. Both
are the same with either branch layout.

So static keys saves about half a nanosecond per allocation at best, in
a loop that does nothing else. At a million allocations a second on a
CPU, that accounts for 0.05% of it.

>IMHO, I was thinking of deleting the CONFIG_KFENCE_STATIC_KEYS mode,
>because on most systems, it's not worth the complexity for the small
>(if any) performance improvement anymore.

I agree, and I think the numbers above are enough evidence for that.
Deleting it is better than this patch, because all we want is one kernel
across the fleet, and that gets us there with less code. I'm happy to
send the removal, if you'd like.

Thanks!

Chris

