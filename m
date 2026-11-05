Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E050606A33E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e08A3FoR
Received: by kanga.kvack.org (Postfix)
	id 5A3166B05B6; Thu,  5 Nov 2026 16:06:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57AD76B05B9; Thu,  5 Nov 2026 16:06:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48FF06B05BA; Thu,  5 Nov 2026 16:06:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 225C76B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:06:48 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9280AC0C21
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:06:47 +0000 (UTC)
X-FDA: 85402299654.10.AFF587B
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id B6FE214000D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:06:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=e08A3FoR;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793912805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PQ5xrz6/5W9B/AU5YTZ4/YsX+i9J+WP+jzQ06aUOz0I=;
	b=iAgK6QkmA43M0+Y6S5jI5afxePl10ovovopyKdb1AmD3TfNUxINTAYCTQZypd2hl1WQakx
	xOzH4nUaUcWh+rEoDz25gAtM02wXsLIVdjcRJQGh6PIirmAjkV9o6wZ4pN3EG2itD3Z2V4
	sj4gXAcXe618uLOzebfjPL26XD4Omlc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793912805;
	b=t/1THgDP0hcaYO2LfpRnY3ihqPvOesvT1RZfpiIdDzF7p5ODZqpLcdRX8wdq2Gt4Sjuv6X
	bU/8ZMR1Y5l+jAWJLD5DYWvm9/0UleJoSMZNKb1GwzAeKju45uumOwskcjWnhTXObjPBmb
	jYuTOiDfrDSmFb/WLahYeR4TLM0XN4Y=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=e08A3FoR;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-49134c8509fso7851f8f.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 13:06:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793912804; cv=none;
        d=google.com; s=arc-20260327;
        b=IgZmCapcTDjQS3Jt7/OSwFOUfZva9BWRJkwwOA8ur0GlYTtXEsblZjnthLfzMFfOj8
         rRspGuFb+XjwqTsmQSsi8VuNezaq5ARVKUH39vhYJXUjiDKdecU+ncT4XsrXTkLy8uBX
         0mwVBI+oW8gllO88XMEadIArDOEQU7lLzdUEhY/R1PnndVKOsAVgIShGwd9I4tMclzBf
         0J7avJU8zsAOGEvq9JJ5/QM0Y7De4PmS+knqTBkhB9XZqtQBAIpHPGTVRiWGCqhqpOdl
         06/FhiBqG6yReckLwz0Xbygp7dsb0FCoLYZyqLyX+7xV9WljKt73mih1l4atE4VNVgG8
         cXDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=PQ5xrz6/5W9B/AU5YTZ4/YsX+i9J+WP+jzQ06aUOz0I=;
        fh=nG3wj9vygmdo/+AbxqoOAZTQV4FnuRAOb8M7YqNfZU4=;
        b=pD8e2wfMqaVUJR3mxIReCuV/46C/Gnyevsp3iJQigJ1V+wJsGSSrUmi6SaneeYoFCo
         vArQh2HcCkM4GqUcUyd/0BdA1abNrUY7Aw0xrlLkMKxXNnhZpb2fXteC48VQ4ox3t+g1
         WmxB2Y+Pwf2HvTUBxsC7BhQOOnSbcKXQajLos8UF4NHmkCXhgJ6+tRqzBODQ6QktDuul
         lLki5Ksn9sTDPdPIo4uYcsSZUQ4Y/5nNYOmpdC/apddksEXhX0vft6n+kp2v3gk24pFH
         YU6Am5MfsLJ8VJ0ma+sFklNy+59IcLSCqoP6H+KlOF5MOZSY7fnUenLHp5e1z8KL4vwr
         6Irw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793912804; x=1794517604; darn=kvack.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PQ5xrz6/5W9B/AU5YTZ4/YsX+i9J+WP+jzQ06aUOz0I=;
        b=e08A3FoRCZG4CBhqvtj1hBR0IZrZdMCD8JiLdZ955dOW/kSaXmk5yopmflztjLz47C
         dgaTHsDNSJLGinKsFC5W60tcRvVrFBQQVzZ9v2X59c+aryCfJ5qjBJEys0K9byKAgtaQ
         Mvt+g9F8b1y6NA5hXjYETlGNXXSK1pdqpvZX80hHJ5O8t8fs9qsFsWbR1CsrSod/QC9+
         3TSXeTsDxyW7K6GDa5/w9c+Omc2LUbgOPen98lW4hyf7ExiwPuL6BvERk95UgFm4ZSGN
         EMVqFp6JtCcTOqXcsNNrivTs85t5Tk4ojD7wTa4AML9ayQjEoYYz0z7f7z+H3ccw+dkV
         hehQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793912804; x=1794517604;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PQ5xrz6/5W9B/AU5YTZ4/YsX+i9J+WP+jzQ06aUOz0I=;
        b=YyTxABT87hQ6kIcfAG4bkgSMbmmOryrpyGet4IgENleds5oXQ85dkVSPU2qo4Fsm/A
         wyMwf8VDCr8woHjqMpk/i7FXzKbmDJg4jO+8VKXBdxXcxv5Hxpnt2muMDpvEuX/swsO2
         QmXQBwCE0g14ALNnLAqOKfNWbwLz21oFRKi1VgvEarDK466wG2f1w2tVKgAFtTQz6UmQ
         L0kLpts323OWtwqFMm4qPCfXnYWHlOJJbGEC7frYo5NMItTZPY7CZ48HMEDwpbTjZbNs
         gd9GYNHVoSvFEhUxWJe37HOUpH3sYrWu2yI8mhc2J0oRi630oSGJ26EGLFomYd2cMysM
         99Og==
X-Forwarded-Encrypted: i=1; AKwUvBxWE3xgwdhAoLv2Dav3eiAQXQSurnvfDMDb/E5zkv8m5OLe1nuxcIe5HB3UOl6mwvDro56IXxY7kQ==@kvack.org
X-Gm-Message-State: APuU4Z/yceYRcmc7ewtVK72nrkHUvaUtajVBcB2WkUsCU/rbkDDBM12u
	v3aZh+FXGBN+Y0M9/D6uHwuDhF/u0cvpEPPovFOZhCdK9NkjzaH4n8KY87Nc4M919F+i0jJy6c+
	/4zuiDszY2IBl5+aU8kYQw/OzFqCE0lk=
X-Gm-Gg: AYBFou1EK5v+/R4QBxnJBOgDVYdDKN/zBTLdJs+XKnjm4FWrZh+QzfShipyQm3XVVod
	OzPtg5xRvY8VnaUJ9sDHTu6LVJKsM2BGaO3i4/wOiTl+BjlFIOpc6aKTsUBEI10i3fRdthe2jR+
	lbH5ohK9Cl6++/5o5mHyD0Am3nwolnaRzeJkFIBqUfZYOocOV/LgfYVHWvTv/VPJnRpA8uoiLx+
	/pdTKqw8jE0U4hVvpS9bqNmInRZQDkSJuD04dVlsJwWw/wA+y4Xrl22JXG7e8cI3FMwS/MU0uAi
	JNShym6lmTtF80EeNstQhjdc+aTDw7yIAxh0kGCzd91mKJBosSutjrAeAbIF5qc7ICiwJUi82qx
	AunPQkZbXdPFVdWrHRdHkEhBLh+F0Yn7X0cLUrCRBSDg0rDNtGQObcDkvWWQl8AxGOUVUWxL0Ez
	7BXluurUdwGR3vS9i2wObkfMWMyWqyH9yeoSMRT79N0malUlaKFGY1
X-Received: by 2002:a05:6000:2510:b0:48d:f488:f32a with SMTP id
 ffacd0b85a97d-492775f23a9mr1599167f8f.56.1793912803834; Thu, 05 Nov 2026
 13:06:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 5 Nov 2026 14:06:32 -0700
X-Gm-Features: AclHuK8Cjd9cUW2LR9znWEJxOp10JF8kDZifUXejaVPmbKzhx3QybC-mp6UtYl8
Message-ID: <CAKEwX=NXSwSiuY65EV5nqFocMLd6-afsiJfgy_ahB2v_MDmcng@mail.gmail.com>
Subject: Virtual Swap Sync
To: "David Hildenbrand (Arm)" <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Gregory Price <gourry@gourry.net>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rik van Riel <riel@surriel.com>, Wei Xu <weixugc@google.com>, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: pzgkw1tye9ycg8h8z6x7937a1cwxpy8t
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B6FE214000D
X-Rspam-User: 
X-HE-Tag: 1793912805-558849
X-HE-Meta: U2FsdGVkX18Py5MwFTBqOZMW9+0keX+LpVsnLgsGgxAOyWbHHNyyFSTgWyCasyJ0h/yL+BMHM4Sj7d1f65NVp4yuqbWh5euvqDlkILJ4odetMwDT0QYokT+PsjVUstiHGuvwUngjj9Q6Mf/lx+yi6svConIDe/8J7M8bYCBsSuGH3xUkKMmWHJSnFokiNM+dEIL735H/m/akzTyWCkIPk6oxRbzsC86qEhGwmqpH588tTbDhjHTjIThlDy9fbTQTU9rw2ifo4EQUviX0+J/TsCWrNPJHZP8G6MvO5zs3hZ5phdQae/Jm9+IKC5PyhEbLdxAwWiApm5KnIp75445xuQ2Z9dzdXZ39/xd4c72FBrSwTNJpv8Qvdc+aRZqA2yvpTPgRth8saAJlHGkghU0kAeqJRCpZgG+bQAklNise5zstt4TqvSYeu/yCfJf/URt9iNs7WzHd6cMMcaZ7MxcZ5FRkaJUXgqlya+zGSsPSqROAb7jruO7kuK/Sm0jiU4b2xIRujKc4fE7iZ2RD2PMTv3GBEfe23VbVtSbo3mSicjA3sG6cpXcwt8Tu/a3kj4B92cdh/3VazjPlpcUfmLUREVBBLKuvxoW7gpAbksqsMxXpM2dYeyO+weVwYXVYDk6X3+vuEUvZU7pVD13eVUPDvBcZCeuOkWmJ3v8JcGThEHWmkeIUSUlX2Sy4ZmvxBW1qJJlKVoOAsP3lUqIfnb9QFc+TbyvArwbzYMWbC4Fz7c1SfdsaOqXpKtz65ZUz4g7msCt56QRQiD7UR4lWsHlOLV2Vm86cgutpdccKOOTudEgJns+b316MvjVwllu47E4Tk+uwiCNO1GkMLWbG9LzTXssJl0+QMHbt0NAJMwGZjGJ+BGvtGD01DY7c6CSP2QStn+fB/ivD0nX9DsoQXq/+rnXu56OSTz4IGiBOWevCeMGAF/kiXV+oBV7F6i3/tKNYDutH+SfghV8/ipHDhRO
 giL3tBPK
 5efiJgwW/jFMkNjMLfv2IRXBh5x8AH5uMyV1nKnanbyKUE6NHByluc8kDQ8q0qU99YvDb7Ixsss/BsAoJeweCFu27RMUHc3aXCQV8F9rW/beHoD1XoBc/GLbZsWIA/OBt/alAi+adGQh2T8yWjdySi0BlijyjNz3QD0jEGsZjxV7sCuszrwEDFrcEBUFndUcBetzx8uiiIICMBr1LSfpqZccpg6JWSdt6RagL+QwVZv+wo5CyD/akkj+0ZibvS5nMqfdbhg13XEPPnDto2Zj1KWX07qBlwidYBmzZ590uILEmqmVToXXKCeKXachMO6MhDZaixBsra2l5Bgqk0sVQQM7Aa9PS3IGlWUIJtLN4UBEwcem7jzIZo67GIi/FF05WpBvOPBcBntE98y5jgOXdgr8WpByx4g9UrhwBiB3airMgnK7qUlTZKDf22jA/b4ZlWTgaudDwJ8VRc/JlUTLPbUwnZewJ6nEADwGi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi folks,

Sorry for the delay in scheduling. I also figured it was not a good
time with all the merge activity + the big list of issues that needs
urgent attention :)

Since no one responded to the last email, I took the liberty to do
some timezone math and create the meeting myself :) How does this
sound?

Thursday Nov 12, 2026 =E2=8B=85 5pm - 6pm (Pacific Time (Canada))

which translates to:

Vancouver: Thursday November 12, 5PM PT
US west coast: Thursday November 12 4:00pm PST
US east coast: Thursday November 12 7:00pm EST
Europe: 1:00am Friday November 13 CET
Beijing: 8:00am Friday November 13 CST

Folks, can you double check the invitation, and please let me know if
I missed you in the invite :)

Best,
Nhat

