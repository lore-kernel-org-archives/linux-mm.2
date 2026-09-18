Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52F4EC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 18:29:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46D2B6B008A; Fri, 18 Sep 2026 14:29:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D9C6B008C; Fri, 18 Sep 2026 14:29:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E0D6B0095; Fri, 18 Sep 2026 14:29:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EA9B6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:29:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 35699407C4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:29:05 +0000 (UTC)
X-FDA: 85227719850.20.F2B2201
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5DE4980009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:29:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F77UZGCZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789756143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zdks7hdrheJUewHKZ8mwTNf/+CqwZZ9VKUB7klIjzhk=;
	b=7l6il/uSaRvdQEJq92l07k015EvvgKBo4xqRc8f75WQQ5dsC5rJdxNHgwdvGMQ1vFSvDWj
	DDneXaT6RN2xth1FexsHSJv4ezKR9nuZeAxRg/Id2KBA8TVUupPXvRMpVLn/PazEDOf97E
	exOf6J4RUJtBRIyl6DPQI8EE+Q8+7e8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789756143;
	b=hVwAPwV+PUUdbKwoSBUw5nFl3rH7xCavA5FmMRu49I4LncDfFh8AIPrrmc97MO5VrXYP1J
	/yGxOnyW2xNN1f8a6eU1RlM+8R2a5VbVTzwgm2c68JPP5ZQqRagZvLsjM2N9JmFuK1oVYm
	WFbWO6jArcr6mpSOOiTUbWtAEEvnfdE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F77UZGCZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-398c066106cso952209a91.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789756142; x=1790360942; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zdks7hdrheJUewHKZ8mwTNf/+CqwZZ9VKUB7klIjzhk=;
        b=F77UZGCZydpuKM/5JKVthQu4dUjCUy91kgaxtd8LUNEppcR8BwBniK30PLhF8UVtLa
         8KP4cL4+TI/CGIHenTHjXiPxR2veZ1171U2rXOcXajGeo78xARimoq1dmAt0rc5PR28P
         3EFeYsSRb1V70rcBCdQTGWBSjoysRzTdu74kKwxou1+tufxm0oXTzTNw+J5QgSfNBkl/
         SghEIjc1J4Mn53Q5sJtYaZEdiMMIcZQX5244JIYVOmliG3UEJMA/LdGjE+NumkE79OJh
         9K8W3W24CYXR00msg40t72zpX3RZoWBDixrjWHqNILPEQrLpYuBC3qMv+/gMrEUKxFKP
         4TDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789756142; x=1790360942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zdks7hdrheJUewHKZ8mwTNf/+CqwZZ9VKUB7klIjzhk=;
        b=iTqf6v8vi2wYcmFhfhpmlHlr3q/4cV9JO616x4I8y1MokWjF69Mh5Z9PeNwilEsYgx
         JVJC/4iFIDuViue7mREOIclVImoAJxaIN8IS4YdLsKmKbGc0fQpZ8OyR2z8p32nOLGkq
         wglX00c2eTvS05VaovPx7oxFHPk0BOwlqgS2UQZ1MmxPPD7+RuyUYyJoRgUw2k5S2yQM
         TaEgklaThS3fFY98oQ0GEj1gT4fdkjOtymM6JgxgkzwdXuKWdWNholrebvi8BpS7AaTw
         NzTh3sXel59PyUUk5kbgz07QqFfREz+GZxxbV1sHQkyT7n2g+Op7mwGZ2ADWr6bq3pVn
         kkvA==
X-Forwarded-Encrypted: i=1; AKwUvByqUH8F+xehSv2mHMbQr5DGHvKQO4VvAoCBmWjKaOoSLsF2+IGDC1mfvOw6Ht2JLQXLao8DLWdBtw==@kvack.org
X-Gm-Message-State: AFuF++k/bDXdscDbhCKdf9FDSTaMsW4j9vPsr6raP6fxCyq0X13+P7Pl
	Dah+MKg4YgKKKk4qwTeBrtXXZBAEm64I9y9FuGGhV7X3DwzZXv5sS2ar
X-Gm-Gg: AYBFou1r2EHCLnM/6bnWU20GdlAiDIUs62nlURfFy7OqN+X2NnyRtyKR9B0Iq4faPKL
	t2DF0lXLPwII2BNSzpMpOOoP/AtKojujeAr0nw/OJu7OubJGQyAc2nmdXZNxAx8zf2Oqs9vEW1R
	NMSV8SyhRF130RRxC0iFU7kdbKBZO8H4myFBED836D0U285mIo1jPossEDJvjNIsm/QYIRgyKeL
	5NacTUqCtIBlIBQ0JUxNWVhoSZiQ/a33LczI4JfDhQ8W/Bf0KmOccb3JOwyTPkpaJYa7X+0/IDb
	2joVkH4TW9AaWIGpL/dbPaRjjkpyahp3WwejtiRvaT9pZ4iSdaafsCU15p4t8+ov2OiwqtMwHyt
	vLr0hLkvPijRQ0X17mzCrCvx7lk+fz8HBKzxdUgULZJD7omcD4ngn9br1c/7CvwOgc9v0wT40bc
	OBo72nkWT59bZc7v45L92yBQc6Hy81FomoQEbGekYQIFsR3q8Ld0moMKO3UaU+FDGsbmekjaG0z
	CbS3rbkAt8m1rXYNWwqhQiVlcKiwwBoTTfQWZmRUIiTkj93Mj3lMmaiUuvGzGH7EnodBphxJom3
	y3JB1IPo4M7+8FT1GYD0kkNCog==
X-Received: by 2002:a17:90b:4b86:b0:39e:21a7:5dfe with SMTP id 98e67ed59e1d1-39e54c5a1ecmr12051276a91.3.1789756142193;
        Fri, 18 Sep 2026 11:29:02 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (36-232-230-153.dynamic-ip.hinet.net. [36.232.230.153])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e56368a86sm1718011a91.2.2026.09.18.11.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:29:01 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	liam@infradead.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Barry Song <baohua@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memory: reuse the whole exclusive large folio on a write fault
Date: Sat, 19 Sep 2026 02:28:56 +0800
Message-ID: <20260918182857.571-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <b1ba175c-ceb2-4e00-b233-d51dd8a2f4cb@kernel.org>
References: <b1ba175c-ceb2-4e00-b233-d51dd8a2f4cb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5DE4980009
X-Stat-Signature: yom59gtjxdkxz74km3p4fk3hpncw6f7t
X-HE-Tag: 1789756143-79433
X-HE-Meta: U2FsdGVkX1+gJwoPwPjhpZZ7F4hDgA5qVIN+q5Qrc08RtRayawDe9gBGgEKoSIIjitzazMNNd1u0SEHO68oZ2+kb/3zwdb80imdVXE2iJotbUF3ml4zKU1onaKTB2cn3b8Bn9Y2l7ebLYe3vEPCQ/N4Us3CSpsYeuwiwmFH1essSJQE7Qlgs0mx08+/Xn1wexiaC53A9KyR4SE5pfRd9ExdEQwVxs6bw7Fni1zSx1rMrPMd9u3eVKq7cfig2Irz45IpZyEDzMrPhdQQG/lFauOhuU57Inw/rI0UVRZDzFzLqgVLY4mfSvMOcJ91/A+jThOZPIWQvzGhJYifgDbaGsK175w1e8rmfEV+d7OdDnEz3tWcTlgOiIErVGDjJ0COkgv9GJ6jZTBJkPeXBheVygD1YUipw4eYY+OP2XcZ1fLA8e+OoN6Lrrw7Fizc4kl/pQRz5mjMV0pEwF/WPnNOSyemqhiXvZUsQsS6SQOprNENKLGnBmJCxCDKVAPVsBXix8OPQm9TNi89K0Nbkjzz65asoOmVsnWvAgqVz1aBA9SbVPOjdxKZjA1R9GO6F2P9hd+umC5JAQXyDaCEEgRZVfgGYnC+S4u29vCt/7KpYFw2r/cy22hvccCrt9Kc8fGeLHzXNVwzrKIoa8GPEYxRqzPG/y1hNZDU3X4nkYtJ4IhoeGMjfsii7p2prF9fkpgHYNvVvIqkW4PsweAWs3wcn4gG+nqRRCjoJNz1KuFdXCSWIJqVPXnFrSMOnFmWwXKQ9a62/hLFSk96gG1EqPWyG0zDLGevPKtf32bAZVgPdRrrI1risIq11j2Q76Kt446pYBC6dM+1m98KmEGmdY0WAH7LMRnx/G1CxZtQTIKoLJXvYbJHp9ey3TLj0K537Ibuqcl62KS355k9LxwQu2N0Eg5pjVELR6cSUlFOWfhDerKXBZ6Wzo/xjNl3D03MNTqz5q2Af221SPqe0GQLtVIF
 PxXanNup
 hhKiDF06+Zl7EhgNxV20dmR1JW7uZ7C36AtShUjOYki83qbOUxzPeCV09TtOLHR5DFUb3ROnYjImPg7CrcbB5Is5b68Y1Bbbi0UE2tYnYE3dhFs/10dlQvU7yefB7PMxUWXGBv/mOxKWZiynLxjoB2JEIoGtwbI/hCKynwDoSg4WWrIYWuanNPnrv86FaTRCep8tvwFApNovKbi9N7ZIOrKma0LlMZncFrgJEBEkQqbJljhlYcARobZGJGwQFaane50PbKpFqbYQf4m1lWY6GIoa2aQ4Cu3so560IZszN/6OWvl658ebMabIPxhk/5OvNdnbDS6FSNd4Z5SHzD9bzJ09Rrfp+Mj5giYhK4PlMS+zEgZ/zuGHbXUkZeL9AJcKG3cNc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 14:14:11 +0200, David Hildenbrand (Arm) wrote:

> There were previous discussions on this, in particular around how much
> we should actually try operating around the target PTE.

Yes, Barry's RFC from 2024 and your replies to it, where you were fine
with contpte granularity and not convinced about anything bigger. That
is why the description has the numbers for both: capped to 16 PTEs, the
1M and 2M cases take 5.4 ms instead of 3.9 ms, and the only pattern where
the cap wins is one store per 2M. If you would rather start with the
contpte-sized version, that is a two-line change and I can send that
version instead.

> How did you use the LLM for coming up with this patch + description?

I did the initial investigation and made the design decisions myself.
Once I had a clear idea of the approach and the overall structure, I used
an LLM to help with parts of the implementation and the test
programs. I also used it to help with drafting the commit message.

Before sending the patch, I went through it line by line and checked the
test results and measurements to make sure they matched what the code was
actually doing and that there were no obvious issues.

Lorenzo, for your bot's question: the reuse decision in
wp_can_reuse_anon_folio() is per folio. The patch applies it to the other
PTEs of the folio within the same VMA and page table using the mprotect
helpers (can_change_pte_writable() and modify_prot_*_ptes()), so
soft-dirty, uffd-wp and NUMA hinting PTEs are handled the way mprotect()
handles them, and the PTE that faulted is finished by wp_page_reuse() as
before.

The part I spent most of the time on was the measurements, including the
cases where it does not help.

Yuan-Hao Hsu

