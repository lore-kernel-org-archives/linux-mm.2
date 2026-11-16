Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78276606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 16:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=QAwsBxMn
Received: by kanga.kvack.org (Postfix)
	id 890CE6B05B2; Mon, 16 Nov 2026 11:29:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8683C6B05B5; Mon, 16 Nov 2026 11:29:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757A46B05B6; Mon, 16 Nov 2026 11:29:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 541BB6B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:29:39 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A701FC01A1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:29:38 +0000 (UTC)
X-FDA: 85441518036.29.A352D7A
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id A25F114000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:29:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=QAwsBxMn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794846576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShKIQFI3uGIhr4DBTVUmVEiZQKVcNYjQ9vNtabc3Rxc=;
	b=XfIl59Br60vHcN2gADF5noMTUHZ0W6HMqKymOl4MTxUZSb9WEzjqhaubb/6Fy7YWI81DIf
	Pn3TNtlnMFi5CUGQAmXduyFu8CKXT41deD6EOkxKfG5TefyIx/fszzwP+HlqFE4ZJuwBH+
	DbT2SOa4BYvfUma+MIgkB+/IxOUCGHg=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=QAwsBxMn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794846576;
	b=iQfitymxB6WYYirpoxiS4bJFbtv1PSASShkxE1wXB83RoboK6rZ35kovmeU9X/VBeHxQQk
	CaUBh2WSAQl9tesRAV2EJGGh+mTYZ3zzClW/dAjKpgsVkS8Iexy/7Pvnpnq+odoW/4L2TP
	px1pUa8JzgHqZR3pb1x4VsH2U0DrMic=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c45551fa84eso702495866b.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:29:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794846575; cv=none;
        d=google.com; s=arc-20260327;
        b=sYXI7zzHXw+b8xef4pEEw5iRgOKha+twEK44iJv/r6Tc/Fwo0fKlsHvWJZdturMyQR
         Ftjd6wMHSbvvHd+OlecWsAcgDDSuSUMF+wWQNES0RyAxtlCA8lRbkIisJvgQlucNqWdm
         p5VfLTybSX7tJdjyo8oj95qGq6KX9c7bUX43SeB/hVtBTBwjlpyqnNuJN/E7a4ERTOfe
         mxmC/J7s8eQd6JI7kZH0GVasFWU0cVNYY+a7o8hmJjf2N3M775YaqLufJDWwj+691LRj
         DUkJNIFy8rNI8eImTFk2lVfJsgt/s0cyIshsFQwy6xgSHQ6yki9Q91gqCw4GUeDM8ynh
         0VTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ShKIQFI3uGIhr4DBTVUmVEiZQKVcNYjQ9vNtabc3Rxc=;
        fh=W6p/oZFlJIv2gMDDli/AVU8PqP7jRj4uKs3BI752dAc=;
        b=ZiuiLAXIT0GiDaFLI7XQL5FQG/gtW5nblesejEA0Yb392JQ2edaz2a7YoQK6ZYreCI
         7uEmBa1ze/8+rZ4InVOfdYEHitrAxdXbh0ph4RIhqlYhmPtUbwjcuUp9hqi4GJ8BIb6f
         gl/KSD+A31pJtKWD/k0YKOJoWGXt74544Q58s3pvlqcHgwaEPqvk3hvf7kMmNkTCqHza
         ufoUp3d4FarZFBOleQqzZX6zz4CQdAaKnwc9Y64v48apxDG6896tLP92SoJCp+Ezf13a
         i+o0pNQG6G9lSKdvluUMebGfr/B3Yda/RrBIKszmudN9HyCyChBCUrC/VGiGGIEim85u
         AJUg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794846575; x=1795451375; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ShKIQFI3uGIhr4DBTVUmVEiZQKVcNYjQ9vNtabc3Rxc=;
        b=QAwsBxMniHhUYbWjsmO5H7KlMsmugb1YC1gWW/4a9Xuub1y59sOcDT0/Mow6jJhxaF
         NUaWi8NjvLV6gWM3xMJxPUXo0D0mf/0Ga7lLn0U4+Xm8Qi4St9QkwZHMmIDwt4TS9erv
         MC3nPH6sQoTuGaQUWVSeAXG0LOnjPSlPXQOeaCiRSLVWNdBUpbBReM7me/ox6VBsR7bT
         olH16oKhfTcDr9PQxCOoJsQhtEYW3lZXVo9WwcpEXkdpSB2HFKq+yB6Mb3wHuuYD0rPv
         JUQT2DZszQ3pGs7iL/4KYJKj+53w/IGRipEMCghjdJVqKMwRviLhS+EwguinLb1shBrj
         TJLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794846575; x=1795451375;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ShKIQFI3uGIhr4DBTVUmVEiZQKVcNYjQ9vNtabc3Rxc=;
        b=ki6cCp/+Si8R0KOAqOobkE9twDX+OZdhjZ/ZsNR6AD3Rj8MLWNY4LJBRtQbbAGJkaS
         Bq+Mo1223au6JRo380yg+7o/hUQ4h9JTig0w7sf7H92gturu5s4AkhbwxF2U6oZiViRC
         +bFAwoIu1k/AijfazkIDM0FRazh0UYVDTPlLxFCv8Rx1K46pvi2X6H7AJ1Fs9YhEHi5V
         7dxmgWp/vznWXiEmvcVw/CAQJ1vm0e6xfoUUwoM711rfEgeTtDNz7ORkY35MjTg81alj
         oM9cyoT4GfKFzllUWAFTRx1eajNFZ5rProfnYpDS085gM4dgxbuNCfmwBffbDlDz/SMI
         A9pQ==
X-Forwarded-Encrypted: i=1; AL+hErGtr68PcLBNpwdBP0QuwhDsSGvoen8Az3PhwmjhKXeths0gs9DL3afm95MuvYdtb8d0nH6RgWwrUg==@kvack.org
X-Gm-Message-State: APuU4Z9WyP0D16PU7a0u4iAiOcyK0u25Lz0wmcvRVfYr1OA4NQi1W72N
	bD2eQeH0o92ZzR8HFpUPaBgRfzek+VHVmXIj4XISBDEBwniyeS+gWQ3K2jbFDPXr+uSgXqXqpDc
	sD4XXDhGPUX49eo+RyFtL1mM0qIAli3geg4TNJdOa
X-Gm-Gg: AYBFou0xbQxYA43YoLI44kLxLl8LV+YG7+N1EH/Db9hG12rfQB2uLKy7uLCZBUEZNLQ
	OZOSOexGs91iMALdfB8P2VBj7rZKaMIMKQkBR9d0oWZGqHyf1tuypwKQ2USgKxOpiNTseRMs0Wa
	uMZ1sQa6UGxZC9r4ipDs7Znj0BG30ci6DRSrPg088ar24WD/qCrG5YkKJ45nyxXAtZO0pXDNUrV
	sbEV3LdkCo4JOzZyszF8ChMeorQlZNMm433wmMK+Y1YFVPzCKOD3pvjpRbVSTAmgDHpk2VLZevf
	bXot8Sq5Fqw/Z9GFPlezxAO0NeewWuC5hC7+mvDQxUwb++/a6DHaDa0TAxR1n5UtmCNYHIVJ6+u
	92ue91oOdyop1ap2U80/0BScYazGAjnwyolPKTShflJHrZtm85uMtcdhtEPuAHKNe1OG41J/A8N
	hjAv15zkPl94mHAwN6jqbCGFhWwVi0zoRu1KDRLSBEpgwTjY58
X-Received: by 2002:a17:906:ee85:b0:c4d:906:e979 with SMTP id
 a640c23a62f3a-c50961992c5mr881499666b.3.1794846574496; Mon, 16 Nov 2026
 08:29:34 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <491B482A-8177-447A-8CDB-AF83C13A5DEE@linux.dev>
 <20261021212738.321547-1-jthoughton@google.com> <11457D37-5AF9-46C2-95BC-CAD4B22741A1@linux.dev>
 <7C857138-E17C-40E8-9F72-6FD3E3AB493D@linux.dev>
In-Reply-To: <7C857138-E17C-40E8-9F72-6FD3E3AB493D@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Mon, 16 Nov 2026 08:28:57 -0800
X-Gm-Features: AclHuK-zpZUq8W9nNoH-Fxmelqg6hPrcZtO370EgGILVe_jjsPQzSM8Wu11E_Lw
Message-ID: <CADrL8HUkUJHW0oT+tPhhyYdx+5+boSb8QRk9Bwp4mzVGpgRg0w@mail.gmail.com>
Subject: Re: [PATCH v2 01/20] hugetlb: Don't restore vmemmap of non-HVOed
 folios on bulk restore error
To: Muchun Song <muchun.song@linux.dev>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, 
	David Hildenbrand <david@kernel.org>, fvdl@google.com, linu.cherian@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mark.rutland@arm.com, nikos.nikoleris@arm.com, 
	osalvador@suse.de, rientjes@google.com, ryan.roberts@arm.com, 
	sunnanyong@huawei.com, will@kernel.org, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: uef5wdjz8dh618p1r8tra364zs6fy7yk
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A25F114000A
X-Rspam-User: 
X-HE-Tag: 1794846576-218802
X-HE-Meta: U2FsdGVkX188ZjCbEDaarxiMppoEfkqGlN7imDkQWQetHl1/C76pLQKWpif5g9lPRIyhGOGhferESO65+czgdXcn53PD6vDHWokGF6Mydn2UaB7EebzG7iX0bwPm63tfhj/U/PhFttVdl34TBfcRAmzZqNBLLSCkR16YkfLz81LwU2n9Z1mhLHGp1lfATDjZdgvdklTaCn8Dz51H4wahP3+dQGuu8P6tmXzKFu22aPrCFkvZsf7WjHOKxgBxT0rzk7gnUe6f9Wzd9tB1yb55vjtri93JAHLvZmAvJF4qA/ZHBBYL6JWLVPUMd5i1AjRVNHhTubO9Pr9Ivk75gdNw70vE9pRg/crD41sx8mCI800rBhfCs8GiRaz/Ew5fJEdqeGOxeK6N108aMogVjGQ2SOQ/m6EAJfwANXQQ15ZqmXxDnMB3vsu3x9+TA8AJnw5v94CNixpOhEmy6uSuFEwJEeFSmD0egz9piKlqIuOACHkrtmgXCebCushkrHOOBRatjLBL5C3yDvcPoXJxWnUFbQcDhDs9xnKHtP0ZJVIR4iSq2gFFGuZegBPwfyvgMq5TPrQphXR0tlYP+FZDB9SX5uJQQ20txGxQ3uXDI1qvItrx7jFUvTzuI68eviX1Cx56PH1P5bIFmjhWfM2s0TFFkX1cmQlC2opo2M/JpcB5dLom+NB6b/UQ4jHGY6YuNxoQAEyf+/QdCoDPJgDLzelrS0pnYSXNsqgbLS0QF/l7EtJ+sTlf+zUPhQLhgs79Mha8kbZ6hGWBMcV3bQRHxK7FC01WB2Tx2p+/t9DSzwRSU0uq2B86WJhj7QVKZGqIYw9rSJy1qTTdQmmpJd98S/2m7e9Hj9sUAhITn6wIJL9NzDjq7U3MWjLHoU0UsoEuCZBX6z+2YqvKWch0ukNMDoLW8dS/mRuqBq/WY5M0nxDiUxSqLP+JFEmxe4TJGcs9Q8ImK4Qy4RODBavkdoCp2CJ
 5y8JBn3b
 oSq+ywJ0Nm8CuA58p2Y7nVfuPAzQpgZGXgqHQnWIkADbHA/ebFFoR+Rk6ASdZEEpOjc6EtslOFFcvqFmXo/OR/kAkqbDS6/zrqAs+y3WvLp659utghnswJ1U9MjcB1w8NvEfmDgxHLRbg608nn6IlGrU0UHNDog4o/YSFwB1sUKuZCYbUuXrKAhf5tddEznwrU/IZ+s9NM0lwla8aUCwB15AVgLSuQzpqA8Z24O7MO3pRzemcVIZjn9cpgZNkTPN0AjSfcsiRCZiMNSQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 7:46=E2=80=AFPM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
> Hi James,
>
> Could you send it as a separate fix patch so that we could merge it first=
?

Sure! I'll post it today.

