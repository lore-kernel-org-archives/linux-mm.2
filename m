Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF888606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 23:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ik54Pdhl
Received: by kanga.kvack.org (Postfix)
	id 009136B05B2; Thu,  5 Nov 2026 18:59:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFD506B05B3; Thu,  5 Nov 2026 18:59:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEB616B05B4; Thu,  5 Nov 2026 18:59:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B66526B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:59:30 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 528D91A0CB9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 23:59:30 +0000 (UTC)
X-FDA: 85402734900.03.2FD2EFC
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6A99940005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 23:59:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ik54Pdhl;
	spf=pass (imf11.hostedemail.com: domain of demiobenour@gmail.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=demiobenour@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793923168;
	b=bu2Thd5q/kIP2+gVRy41wvsw0mmi5QaqG+1ztwHErEyxMIzDCAZbzW0Rg0X/yCrH5RbNC+
	4Lj8bmjVLDF6nL4uBB6TFrhFcBqOeMRjvxzUOAghAM9B3FSCP5Gs9t+h3m/ggLo2oNalAM
	LTSWODUS23BOviLvN2JgVMvh9rlVrMY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ik54Pdhl;
	spf=pass (imf11.hostedemail.com: domain of demiobenour@gmail.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=demiobenour@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793923168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T28C9sQ8FiCIuaarqzvmePMhVsvyoXKLzlM0HPzQJ7c=;
	b=jkhLf9C5GyhzxNmgDh8qM/PojWXCrs8pxmXKqAV+M5QUoWdY7jzZrGF70FzSq+d1IDGGZX
	3UYjkEJP1ilZ8TRb1DaM4jD4BPKwgRp6Fxt8PMIcVPv7iGaM5R8U3vI5FgV9/MMLQ4exZi
	RaDtwkPhIcW/iMsWkYUb4C+1NI/U0QI=
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-9912c47367cso60633241.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 15:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793923167; x=1794527967; darn=kvack.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=T28C9sQ8FiCIuaarqzvmePMhVsvyoXKLzlM0HPzQJ7c=;
        b=ik54PdhlEhuyNEbgHCNpPprf2Ia1z3zEfkZtXpuhBMVCdCrygZNfOWCvshqk8M1n34
         E9UfxrFXQSdew9ad5Epmobqf3f4Fbe5RQPg1CzbuNxxboqpTA1NlZjshfa9rbG7sf8x9
         om7KRG03ivw9BXu/Ehuj7dtaUxfoZV7KJNZG2+kU4tKE3qFmcZR3miRbTBbQiYcWYmjD
         x6iPiX0dBLu4pWGvTA9ladnrMb6UPx0Ik7+bMFTtDxPgOz3jKxdsnlEr0d1XVSYtIpWV
         tZx3H1kQCwdbFCljEfPAtCeZHMf1fP2OpU+g/B1J42h9BMIMTsXi+/ae4Fwqq/H4hIKB
         9EsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793923167; x=1794527967;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T28C9sQ8FiCIuaarqzvmePMhVsvyoXKLzlM0HPzQJ7c=;
        b=jdHu1jUzqSzOAiS+bXLr4EgCUldEZME02Jf+K5mFQcMlkDAlqygdrNnwBHAZKRf9n9
         WYFOmS0gkc34LjpGGfvpdj5oD/O8RrkkpMyo/PrD13ukJWxtYvKDnITS3EiGGJOlredk
         lXP5La29J3mC1vXUNltPsIILE387MxV1Wa0R/Eu/WqPyH/p+09sg4al5dlyLcEsSx4PJ
         w4zDnD0a5smju5HHkkIzIxIDbUJwyXUssa199qm1j1SePSVsOqLawBxcWT605JCXQBq9
         d4WRP1ql8xlrdX7qypjCbaTTdAIwGya7zr9Bdzd9HbICJO/NBGYz+tj2NmS5hbi3CpvY
         bflw==
X-Forwarded-Encrypted: i=1; AKwUvBwtf4mh9r4Avj9zxrWoWJ6OlYH2h7ab/6WvS9hLKoFdpfc7N8lqFqPfM9UacGMc5aVDoUE71ooq+g==@kvack.org
X-Gm-Message-State: APuU4Z+h9lqCEsYhJaWASd/M2IOmB6aWOcZK5jSRw5AKjFfK5zvqjFMv
	95TFdK5xG1SmMz6JOjSohHezL6p9yjYAXS5vs58OP2DWjyr81+iOzWqG
X-Gm-Gg: AYBFou2SKHlq/xWFCWlU5rbLkrg9VrjNIoqXKmWpo2rFY91Mh+kdzi7fl+/d/DRbGHw
	UH4xuSMAiofyd5kITP5ScRrqg/hWHgcgzgrCNxMkW7NOLzRIB/PockFn/l1DpbWJtV5n4v+1N/H
	UQsRZXuoiAN9ZdC4dwQedDnXYdHiFWN32evO5c3O9sje2X4KoyCrshwOa6LMf/jeMnUbbG5fxQY
	6L3PLk8a8Wk+1GOhg1dktjH/B0D2hHZZililpBgh/Z2dienXX8cv33JWie6eybZ1g1cyBVwQMV/
	LFP0kscjvl7KgkeJEz3Ubt5kTAmAPHNl1v7lHDOIOwH+nJVd6gxkyGkUiLN+qxGsYquJ5UprgeK
	ILdb4m9OB0orZ3lqVVucVdTBF+xxGoHsesHyeLJYyQDJri5buUf+D8rQLGv7Wnx8gX9UwI8aFeE
	NtMVmjo5CoOcZwMlOFxkF6rHxLhqiQ0/F8ab8ySUpElDC5BhZGrcH+6GqZc4Z2mBlbaFFJb9w+k
	rSZ4Byk/nD66RzQZFULOK8u3J7g7FobxyAvFecl09TDbkiBl0AahdzaVlVE4wHP9N47m/IK4snz
	xpWBcAHBaUGkjmJgyk3dspuvXaIASQOH
X-Received: by 2002:a05:6102:a199:20b0:7d2:9ed1:3773 with SMTP id ada2fe7eead31-7d29ed13a45mr743172137.27.1793923167308;
        Thu, 05 Nov 2026 15:59:27 -0800 (PST)
Received: from [10.138.10.6] ([149.102.242.31])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ecc650fc3dsm176157e0c.15.2026.11.05.15.59.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 15:59:25 -0800 (PST)
Message-ID: <310aec2d-3a83-4544-870a-ccd5abd78f48@gmail.com>
Date: Thu, 5 Nov 2026 18:59:03 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: MAP_FIXED leaving holes on failure is very difficult to recover
 from and can even be a security hole
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 linux-mm@kvack.org, Bert Karwatzki <spasswolf@web.de>,
 Jiri Olsa <olsajiri@gmail.com>, Kees Cook <kees@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 "Paul E. McKenney" <paulmck@kernel.org>, Paul Moore <paul@paul-moore.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>
References: <8b45a161-101f-4f28-9b7a-c7c8b8a29f90@gmail.com>
 <auyXeApQlV_CMQDm@gremlin>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <auyXeApQlV_CMQDm@gremlin>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------v3Fk1rd1TVAVxiYTaToqVCZE"
X-Stat-Signature: czo3b616ph6hcknumrjyapa67u5uegd6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6A99940005
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793923168-199071
X-HE-Meta: U2FsdGVkX18ZaZ96jixTkkc4hpJG8mvXpF3qYjVUxK1y/k5FYpUbfzQyaG4Yy6AuI23qkm3V1ZZYhk5OLMERBsTRSYx4pNBwc1YKjXNEy6m30piExrq/A3Yr+7AlBWyurgziJMSZB1cVzPEKfVItRYTG2P9o830XLrfJQT+a+M4F9YqWq2OE9iJVoO4GMLaD8T+J6ry7jmZYEBToIjAg5t3a/uVzwF5kCzhVI5ImM5BIhddP5IhnAgaq/UL4epUGPv2menzAaJbrhVq2l+ac++yxVjF7G8dk6hgkPPrFTsCsF/8JDeZr40iS/ewtqJ9/hW94cbD09CqwH6V4ZCO4a6q4OEFB7D7fpmg5Cc2DtIChqsFOcsRVE3Ikzkm7+CHU/RvOMK+cYsHlbDTd56AnDsWjNug6QilVbS4ZxHLpt6OugtaImpiIrORDIFJXos9OpEfqddnBRaEpXO3KVnuWUOyRAnCaoB24sVUhKhrbMEgWsrO5a2/HL8Yw4wFXFNZwNQoOwcmqrfFlAvWikSQZRK75I8c7Qg6W5W2oyvR0g0WktKly/LWl3NzKDDNX3cq9gukoFLffXRMGU3JY7MvzUdYnvLQc4SzYRqA3/KhWpODHzhGfABeNcDpbxb497Xb8Wy1GRjOGp7dX6A+Xy8gByXX6JznLqWnS+39dE6hYODS6JCPyZIkAeJ8LzXH29c1liw95H9vmu7x7QHwtLie07pZDlkvbzEO5FFanvQaFXaxCJcETVHq/dypBXJYQLLxfhDhXVEqy2dCTkTwcK62rEs72NS+aLhkYIjKvjBhqssHgDHu8udlqX6R3jmcxD/fcbRJEZOg28IrTqqBVNr/0w++W0UiLbaImeWRNJdS6jy5xhy4RrxYq5KjK3UNXqN2/C6+s7w0EHQaU1MqaLGapRYvTQOc1xy2xBvT8heVsg1hxaoOlwGDi7iaE7Qzu1TPHiNcBDFjzDSFhFXFwSCM
 0QXR0lMt
 vAb3oxB2PLWb/L166S+CaZXd2EuktBi6bbuQV64qIy6JvU1amAbEgieB/NhOYaqSzqx78pY82lPMYfFFdeeJwMUdMX8cWa3xgKKJQgnecs/c1xfaN60NnAcjxGoBXzGBJu80PvCBOsWVyZhs1r/7k4/Tlqmg3vy2eMbMGNfEq0IUZDH3GW41Kcd7SVMz/UwPRIzG6Cc3M4mADUft06Hn1Tq1jRbbWH0agEjBDau0KdnwWKDO3FxvOifIvDgKLtUg8rRO+KUJtpG+oScLRcff6Qn9OraFNXADfVq/RTLKnBbvkJqKsb4h+Lpd+q8uNt/6d8xnHE1fGdD5TYKfr+fox+jQenBpaGpgzuCNSQ2NJpVR8RHlZdHqySP10C0y3LdyEluS/+XOqrMzHVYnixLhFuC3Yw0bUrJ+ix0bigTWX4vy9E8rR7kDfMmeV93EoOrI9esv2ybrRP11xgqrUJ/Cf98xn5u3Ulq2Muhd/PU3kDayIOgrNjvD7NkywBZE6jeNDQ+BRlbYSdpVmZFPkv3w1vuTZ0itJcO6fo45DW8qKdqnirIcZVOmrr028Mv0+dXsc7wbw1J6hiRAy2XPG9xYZHYuz6j14GU8hqGzYqTq0552Dk89x4+M1CA7KRzRptrsgPRkYXcOw7vQd+80byK5PU/hoPJ5hKylVjalcz9wMMpQaumv4nqLkA8xT+dik7tya2KUnorpmY0awiOzvwl0AcztNIO5HQ3WbTC50AxWrF2GvW5R99KNjkwygzajrrYJ6EmxySRTNR9cN3logaoxeefJsQ/BngxTbTZ8/aAS0By57Oq0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------v3Fk1rd1TVAVxiYTaToqVCZE
Content-Type: multipart/mixed; boundary="------------83icaf8RpTmC0OcPxXVMnRa7";
 protected-headers="v1"; hp="clear"
Message-ID: <310aec2d-3a83-4544-870a-ccd5abd78f48@gmail.com>
Date: Thu, 5 Nov 2026 18:59:03 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: MAP_FIXED leaving holes on failure is very difficult to recover
 from and can even be a security hole
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 linux-mm@kvack.org, Bert Karwatzki <spasswolf@web.de>,
 Jiri Olsa <olsajiri@gmail.com>, Kees Cook <kees@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 "Paul E. McKenney" <paulmck@kernel.org>, Paul Moore <paul@paul-moore.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>
References: <8b45a161-101f-4f28-9b7a-c7c8b8a29f90@gmail.com>
 <auyXeApQlV_CMQDm@gremlin>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <auyXeApQlV_CMQDm@gremlin>

--------------83icaf8RpTmC0OcPxXVMnRa7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/5/26 10:11, Lorenzo Stoakes (ARM) wrote:
> [ please check kernel mails in MAINTAINERS - my and Liam's at least wer=
e
>   incorrect, which makes it easy to miss. Fixed those up. ]

I thought I did that, but obviously I didn't do it properly.

> Thanks for the report.
>=20
> In general linux system calls do not guarantee compound operation
> atomicity, and any assumption based on that is incorrect. If you see an=

> error - the operation failed, perhaps partially.
>=20
> Further, a failed MAP_FIXED leaving gaps was the case for most of the> =
history of linux. Avoiding that is infeasible.
>=20
> I advise you to review the NOTES section
> https://man7.org/linux/man-pages/man2/mmap.2.html on MAP_FIXED - your
> suggested use of it is not recommended.

Does that mean that MAP_FIXED should be deprecated?  It seems that the
safe use-cases can all use MAP_FIXED_NOREPLACE, and that the use-cases
that cannot be served by MAP_FIXED_NOREPLACE cannot be served by current
Linux.

Specifically, if a MAP_FIXED mmap() fails,  the mapping might either
still be there (in which case one _must_ call munmap() to cleanup)
or it might not be there (in which case one _must not_ call munmap()).
There's no race-free way to tell which is the case.  This means that
MAP_FIXED is unusable in multithreaded programs, unless one is okay
with leaking address space.

Are there cases, such as anonymous mappings, that cannot leave holes?
I believe there are some programs that depend on this to handle
SIGBUS faults from truncated mapped files.  If even that can leave
a hole, the only thread-safe alternative would be longjmp() out of
the SIGBUS handler.

An alternative behavior would be to unmap the pages, but keep the
address space reserved, as if the mapping was a PROT_NONE anonymous one.
That would avoid the "it may or may not have been freed" situation,
as it would be safe to retry the mapping or call munmap().
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------83icaf8RpTmC0OcPxXVMnRa7--

--------------v3Fk1rd1TVAVxiYTaToqVCZE
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmrtGFYACgkQszaHOrMp
8lP62Q/7BcuZTzNzDjqSulu1PZ3/tUbs2jPgRtVT5LhsEf2oiGxL2EdiAWkv3BjC
H+8rqHEku3aP58uLRffqPi9kZY9Xa+V8OfD65coQFYoAjjNwUw9FunF3xlkz16Qb
uo4J0RpFHdJ28SIJI3soCLpyIblsRrsVngml34smiRZ45cpiN7E2D0w3/gxe5hkm
WCkZTlLEzIwTVHNp9ersihO/42l9fgwCoTg0mYhwRb6cBtQVe/dnzX43GuSbXXb6
nXmS3olDR2vkdIejl6WHwLgspT4nRcZMotr27kspanPKfy9CXF/bvNjyTdIbnmcO
duL3/Giw+FiFDWo3NreNgcviFYA0xwitOvyzUhkab+Hc0V6H8ihx1C59E8+cUPgu
juZZg+Vm90eCIx7UkSvIEVEsXi1wcnLBvAJiLOT8Io2kqQOs4RaelRkTRosawY8u
SVzdnkSpHNcd9bQ/KTKRZ6LaT1//M8TO9zIQj0RW3v67J4nApgEh02LK+zQSO9z7
BnryJdGTann2cQkth8VNyTLYN2VCo5UW8gYh1fvQFjU0Cp3aP87tKxwRC59Et+kq
LEaNGRSNYAb65WN6s+SYq/+OxAA60qB68jTIHMbfYbL8mXmlEf+lPctmihxE96YG
vOIZB3vR6DsPbjyl/ZlPhQptzUt6nwuMMTmX85RgNSHwICvq3To=
=aUcF
-----END PGP SIGNATURE-----

--------------v3Fk1rd1TVAVxiYTaToqVCZE--

