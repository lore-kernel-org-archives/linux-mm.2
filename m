Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A51CC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405DE6B00A6; Thu,  6 Aug 2026 04:32:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B5D76B00A9; Thu,  6 Aug 2026 04:32:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5806B00AA; Thu,  6 Aug 2026 04:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 062B26B00A6
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:32:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8422A1C0184
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:32:55 +0000 (UTC)
X-FDA: 85070179110.10.B260B26
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7E60220005
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:32:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YrYZfAAy;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf31.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786005173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a8S7/JFgNnijj79KFMHsJp0QhSQmc5cbmCjp8MdJIz4=;
	b=Zf5/i/yxeH6+jA/BxW8BZVsYKzBKg0ajEgso+eup02gEzER/yhZUaDGQhM9Sb2kxfy6Kfb
	otkhL+GyT5F/MmjRnjX7we94v7YVfVDZxjLofyI4cLfIW99CDh8720DYj6TFXkSIuaxa23
	/7IduI+DS6y34M+HT78xzBtlXVPTALc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YrYZfAAy;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf31.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786005173;
	b=SFXYuHp8z+0nyXg+l18ldZJRYP0cXYyMOMtHoJglhH428T6UGOGOwSQBhw2gc33K7ibwUi
	wG3ioMV33yfDnr1UGmwbbzkzCKEzcYn5qD0+GRS8o2A6aLWakqfO7tlVpVOuwDfIfMfWBA
	/hyxwxGy4NlR/xDqn4lORqi3uMdrykM=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47fde295992so554824f8f.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 01:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786005172; x=1786609972; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=a8S7/JFgNnijj79KFMHsJp0QhSQmc5cbmCjp8MdJIz4=;
        b=YrYZfAAy+9fGgcLarvErVSGYCK3mclQ5DlEYLsoJs6X4q73JY8l/864ArwES+MElKH
         /CngBrtxoSgCY4LmepH1eABnMlENZWg9py/9FBHOoWURWd01Q2IVNtv7C0Uv5IjsSYtU
         f8CH8zonFTTJeLDgJ0kdBGvmHGPTyALHS2QxtEuh7ii2MkUrJD3wh+Y0BJZ6071V53rn
         cUBCXBYsv5c6Tvk7ruJ3jO2xVGpilA8hBxvcAKblzCAY3XNysYtFRDZ6/IiX6C6Q0LxT
         3V0qsykW1oVn9+a3MPYQ9EG09Y7+r7U+LwETtdg0kyyRhDGc3AYh7Td5kFpoa4OhC6QS
         KK1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786005172; x=1786609972;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a8S7/JFgNnijj79KFMHsJp0QhSQmc5cbmCjp8MdJIz4=;
        b=sZsaR4jy4E0Z6Zv5aVsdyRC1q7fczMUpgxMPIbO3jeFyJD+bVqS2xkmpPsHDSXjk6t
         EHbGizTfE8PdKZVtcQyqbEmypeIG0St/lZ+yGZSiPpaoUG/inVRISTVjWeCsgzIdEGnY
         Y5zlmIWc2HdpJWDEvlrRoYO7e/DM2jp2UJJqpWqCi4D9BQGd+0aP6GXxZejn11DFSz9A
         1YoTKuVpCGixCCQo4uKApqyN4nAqPp7YT8rUYfuIPsSr6PXOwr8eDvZIstTURZyqAxj6
         8ixNBbYT2J8MucIz2njWFDW4qIJ43IpdLg41jaJjAo7OOZtlKzZ9oTdTu04apzXGZBYZ
         gucg==
X-Forwarded-Encrypted: i=1; AHgh+RrrHx3TyFE10TPu5sgfbqQOpNaqqia5kHNpAMOm4+2bk0Tzi/8xcrWsSAi1ymLQjPLKPTuAfI2vtQ==@kvack.org
X-Gm-Message-State: AOJu0YyBflsc2Ju8QaXEkMdNKHBGrIvdHxg9ljpXoEJi50zT8XJZmIzF
	Q6AA+9P46LtsAg9vF8BfgL7k+sA/C3LsKUlfokLMvFU8yNyt2adbHyQUnU1JEOMJ+QI=
X-Gm-Gg: AR+sD12N31MsPj/iXZ6Q6cAgYj1/hhcKcntaN16klo/8beufftFZeSswU7eE/yKFhQv
	WFjQUu6XInP66PN2yeJgrLMY+w3YbqXkbCJRGVtgyf7kGKqUmskXHscgUICkLj1TjL4+Mmvzx2F
	hlLZm6MCLalzsu1560cyrAg2myDSBEwvSnHVDkBamE8W7Ex2K49AAKZ/g0s54tW7PA9SBHGRs+x
	4PTrise2ZVt3RWfY5z0fGaEthXmu+M0DrQvsY1BwTEgfziWtp89/GMKrGYWIK5uf7ieYjnc0R6Q
	7onDe+Pd6/8FBh1+8qvy3ELm6v/1LachGdPv9BMzbbOf61cU8PGhf3lDPKzYV8I/d9EZMZ9Aw8c
	vZ/ApuO4two8fjPmiBFluLDnWpO02LRWGfanI33DGXtnRYvx7496H6TPHaglY5xMhwFlSzT8P1q
	9uW0lOyZE3dBlJAQPkA6pnIviQ3zsAScuIcWVKlhI3OrOJbM8comWoEQxi1pQiVzuy
X-Received: by 2002:a05:6000:2893:b0:47f:8abb:1fd2 with SMTP id ffacd0b85a97d-47ff4ba8c30mr7832158f8f.3.1786005171925;
        Thu, 06 Aug 2026 01:32:51 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff79a7258sm4332220f8f.3.2026.08.06.01.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 01:32:51 -0700 (PDT)
Date: Thu, 6 Aug 2026 10:32:49 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/2] selftests/cgroup: test_zswap: fix implicit unsigned
 promotion bug in test_no_kmem_bypass
Message-ID: <anRFukpcm9Pb97AQ@localhost.localdomain>
References: <20260804042053.56940-1-wfelipe@google.com>
 <20260804042053.56940-3-wfelipe@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lcbrsqi5muuudvb7"
Content-Disposition: inline
In-Reply-To: <20260804042053.56940-3-wfelipe@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: m6wqgwscm4py87srn7h3okizo5uruys7
X-Rspamd-Queue-Id: 7E60220005
X-HE-Tag: 1786005173-440471
X-HE-Meta: U2FsdGVkX1+wyhQ0fPl61w7EPn7loOSF8Sl2wzbXHvmdfYU6dAdlOVbcfGF7iL2tVfscCDIYxyTiEz3oS+uTB1btaXzxHgiJYDno4FULHg6LdlJn6PGypqs0tCS0Fb94/R0dLg6YJOZCfortOTtJLs1MH+oOFfzrZ9yMOXB/VzjEeLQMasJUWOasi4Za9nbMmgKo+fP736srYvXjbQhLzxqCSrsNSQ25iJPOzcTSNTbpnDkKnwc6IIbwLdv9JdVXYQGNb326ty4CsCkXnJOtRltbwyDLzy3IRRIgX11BHk4RvhaMEg6DDmit23WNcgmK4BkvDRKcm7Cg/hf5Oijqv0Z17Yi03Pgrv0OHf7AvBztrB51aTVRR9iLJmHP6oPxhIBF2AZuValam7OzXAGKG8ltvknj4MPlZAz/dp8sqjDJvp/MMBz3qvpTDQFWVsM8FQKpU+/mzluTTvEnk7zJ+hEeXNXS3MypNWlrC1suxCjp2f8VrE+iD2XRDpd9DJZogu2/dfsvx2Fpq3GQ9BJM6g6Sgoc4hamVale3ml8z8kUtV3bxFAv1vcSwCyAgnCgiD+TjHAjKT5mVXk6LeKyjFqIpMtbCc1E/mL3TV2CuOuOF/iV6ycMgiZJOA8iff+eIqkBluSfjl5ew1Szl6XEgoDH1lrKdSTBbMBs9Mh5DFhRQKjKPM/2Tj7S4bprHJgIV22735Qrh1kqyOmENKqy4/l9ddE0lKltFJq1wGWWKxAdp7FvwvJimvynZMx+kJzSh3v5UUCjXmEE76gNJcaVJPYkC1nJn36kwCltbUxBoQUYaHRzxNIIpHmhm3ydifPnek301NZ9YD4hcEfKzGE54kxUVcqknZ7IUrPN/IXz+NxY1kjvxQAA7j8P9OoQFp1FzZwxow2R8HiDQIfkcG/2YT6fL4y0yEO0Hyqdk6VtrOsMvBxij96q3jC9x1UdCQtQo4T5SmK67lxHy4A97wcof
 18JnVW2C
 YC43Udqe5S4AQz94FZFRZIg1z76PhQWa3FqNQCukO72p6mk53dl/v36QKWjgxZs5Kd8pRo1FEU7QH98BRz/p1fbpuJfk0wQKDvujXqa7qmx96fWXorzaknvYjIQFwl0EVAiPXPtay9EZBjGreg0rDupT5H5HCdH7coiC3dKQQukQHnW5h1RQ8WJGS2YI8NbfMfBqeaCEvlUB3INZs/VV5IAOe5gXTplSkX6febsdon05Svqq4Fiugdti/Urz/qXhggNFenMQfXvKzdGvWvzCEyoYqHVmCjdvk/miwlD5jeqnrtSnb90cuI//R7g3Q/k3LANKv/SV6Rz/pKw0FH3TadGuhfMHkhao1Ddrzn+s8eCu/BxUiBPqRzok3PS6+HS4Gqabq0ABDXdunFTsGkK0vbDUO3zc91ISQOw/tKh8KV2enHVmcQBSaLgoH+Zvpf1muRB7MpHDFHKCw7iWuwqM8lQNbqjNqUI3ED9w3hkDagsDwKPH7mRMtEpzjAJLIg4Vzfwfi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--lcbrsqi5muuudvb7
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 2/2] selftests/cgroup: test_zswap: fix implicit unsigned
 promotion bug in test_no_kmem_bypass
MIME-Version: 1.0

On Tue, Aug 04, 2026 at 04:20:45AM +0000, Wilson Felipe Pereira <wfelipe@go=
ogle.com> wrote:
> In test_no_kmem_bypass(), delta (stored_pages * page_size - zswapped) is
> checked against stored_pages * page_size / 4 to verify that the pages
> pushed to zswap belong to the test memory cgroup.
>=20
> Due to slight stat update timing differences, delta can evaluate to a sma=
ll
> negative number (e.g. -5MB out of 1GB). Because delta is declared as a
> signed int and stored_pages is an unsigned size_t, C's usual arithmetic
> conversions implicitly promote a negative delta to a large unsigned 64-bit
> integer, causing `delta < stored_pages * page_size / 4` to falsely evalua=
te
> to 0 and fail the test.

Thanks for the breakdown.

> Fix this by checking abs(delta), ensuring the test correctly compares the
> absolute difference between system zswap and cgroup zswapped bytes.

I still think the delta quantity has some meaning here and taking the
abs() changes the semantics of the checked inequality.

What about making both zswapped and delta `long`s? (Under similar
reasoning, there's already a possible loss after squashing
cg_read_key_long() result into the `int`.)

In any way, also
Fixes: a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem bypas=
s test")

Thanks,
Michal

--lcbrsqi5muuudvb7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCanRGrBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjG7wEAubwExH9IrXsRlyXqhce7
oitcuCe9bJ98x6HC+nOhwGYBAP1BPxXMx8oSYQJbEG2gUmqt3VXQUyW00jKZMzWe
GagA
=B29m
-----END PGP SIGNATURE-----

--lcbrsqi5muuudvb7--

