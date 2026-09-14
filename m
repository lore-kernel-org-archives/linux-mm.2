Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6EA2C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAFA76B0088; Sun, 13 Sep 2026 22:23:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61026B0093; Sun, 13 Sep 2026 22:23:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4F206B0095; Sun, 13 Sep 2026 22:23:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7749F6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:23:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09823140EBD
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:23:21 +0000 (UTC)
X-FDA: 85210771002.03.7AF546A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1EBC6140008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:23:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NP8lrjCd;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789352599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bX0pjTa9Tn0AVWcZC6pQhwNld6XbQ3MUtrmnVQtVt8U=;
	b=lnbJyU1Q/zmJBH8zzqyE19mXQFGxs8mjsZCi8NcGdxt9kFVbvuKNZ9XCsATEybgHrZXdwO
	jfvW0DpskFWMoP9kCoPpi3Dy0xNesFlNH4m5rU/uwmmj7WPaibXWjPlLPabQ+ockjoAVBS
	9Ntkg07t1+DJ/fP/bK3JZhzs5zw+jBg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NP8lrjCd;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789352599;
	b=elgJBWr1pqO4j8a1TTzk7fhQPa5VpDHUmugoJf4uHUh9I4QPOmRTXF/uxz84muHcdm+AK7
	iG2z1173mS68uEX4eyw7FuAIS5aIBIBBxg2FYSg4jE0vDiSkc/+hLkoI8I0TAYv35u58aA
	CWQu35n4GmbdYZ6EzeO5/qdJrEMLOMA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 816EF44AAE
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DC31F000FF
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789352597;
	bh=bX0pjTa9Tn0AVWcZC6pQhwNld6XbQ3MUtrmnVQtVt8U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NP8lrjCdC6xxiHUtzriW3YAM3bjzD7h5RrodDsp8uSW9wnOAgFf6MN8uOM9JlAclD
	 W5PkIOEHPDakuulH0Tso+l4gUGwbdOplb27I0epU9FkgSviPy7Ac9KS9v4EolNIGZj
	 W50PHPzwCp0ubAcO7NEvhLu176Xn0xmoGt3VlDsB3SAnVmJ424Ew32lq9Km+4YIqCh
	 9sZnlXWfKmmGGs2qhZN3KjQ4aK6hWVQiLIC3gn9iAfJbNH5c9RflW4YtwC568y8NXJ
	 KU0oyRJZGY8rNPBUvtY+0jTzlkA6GQNdaMBE8hKUYRw8lwqnykP7bwFhvJfpEDyvTC
	 7QUzkZUkLw5nA==
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910cadeb7so212679785a.0
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 19:23:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzw7LUTbw+YHsxjto/g3Zs7aRCkahFHunC8SUoAUk38WdH3AiT5GPMVUGjEnjjYmhThRLVtyM3w4g==@kvack.org
X-Gm-Message-State: AFuF++n2wYWx+qeQJwhzkRpv8kjgY2uy3ihCVssBIbeUx+N8I1Ri/zAp
	2vCzcfC4x9toxcPNCYFGXe7hI9XejGkNrgxRr1+j6F33kfs1TQEqh685VUgyDad6J0Vr78NfIDL
	BNQW4saBddfgL9vXrlL2TQAr9BbplV+I=
X-Received: by 2002:a05:620a:461e:b0:938:e23a:2ce9 with SMTP id
 af79cd13be357-93a297fcd98mr101954785a.16.1789352596625; Sun, 13 Sep 2026
 19:23:16 -0700 (PDT)
MIME-Version: 1.0
References: <063f655b4d6c4234f3aa27ed6ecab10283ecb880.1789351825.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <063f655b4d6c4234f3aa27ed6ecab10283ecb880.1789351825.git.baolin.wang@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 14 Sep 2026 10:23:05 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xiWAs6Lxyec0dOiJTKyJEA0CfRMAWL+7SEcSjwpq2-qA@mail.gmail.com>
X-Gm-Features: AcwNN1VPBQqv9vFICNTYvJvIbMNevtTaersk2NCAqG67ENWfn3vhNYJ9jA9eluU
Message-ID: <CAGsJ_4xiWAs6Lxyec0dOiJTKyJEA0CfRMAWL+7SEcSjwpq2-qA@mail.gmail.com>
Subject: Re: [PATCH v2] mm: shmem: ignore sysfs configs for shmem forced collapse
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hughd@google.com, david@kernel.org, 
	ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, 
	usama.arif@linux.dev, kas@kernel.org, ljs@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: ed96mm9fnxo7pz6sj5c8k5dmswywrsrb
X-Rspamd-Queue-Id: 1EBC6140008
X-Rspamd-Server: rspam07
X-HE-Tag: 1789352598-965433
X-HE-Meta: U2FsdGVkX192/neoXCGVap8jXBBXDjW4IPnAs0F9HQSc2pmCvJta/w2Osh4CldAyxxCUuY0+ANYbuQEtvLN6iOaFvqrSf7MdTLajPzpfomrDjWYGrOK5dBOdQbOt5bVuvqHQuwGbj4wmKeBR1olM8svpx+Rx5rPHT+FmdlNERIX5GGAwNyN3Ddjqa4pPqljPgwR6xjQlXeW5VEbop8UIinMW03qeoiangMfiq/fysDOxhWcH/17eNFwuvY0X8e1I4urRwONeak8s4gfYI+sZyA6OBuFENF7l1xYSCmMHHUipa0nY2aNU8JJFMWnw142483KKUMxXjOHOmN2Pdxb5gWZZCaOB7yqSiFprkaxthpT4hozDu7983K6LXs1KCMnOWslbAHa+GqX/zDxEgDZ6/QNtWVC1d1P45zrDO9C4lVrt5VxapBhdtBc4yzbwvRreKQZUxvyybx5IhkGdw2F0VPK9lBLs5yS3Z4QjXdyVL+tbIbNmpZ+3mXRP7LVfhjt1WVNaBaJyixXe1UX0l8949bSZolpNdZyu496p9Uk2Sy2Pu+r5Wvf05IBf/LOYASprNdAIYnHFlOKTLBeC1lBRKuXEcSau+csUrWcoyalfvePLcyNjCSQVKKN4nRyfHz1Qx+LCfWmzMXQQd1rxa7B5dguF6HIjWjt35VArvjlVwp/BLJ+J+Ie9OEX9H9U6jwXlhPX09M0hjoEqneKqFfSbNJdRfDPBK6XkscSTRoZzwvm3e6zQrm1y4UdR60Wx0MyL5rQCY+cxe0QLmCPCRom1fbaF7oyAOqowhIfM3XpgGr5l/GJdqPoxxSFG0wqKiWriX1TXf9nQfCeS7hn7NUipz4AsJMFLpeapIouIRJLIOlZllshX5VmN7er+wwclCCbrLUD7sX2VQcwkZGrSyLAldPjIyN2aRPfO7Di0SP+KDKXHgxKx0kMBcyzQQVcWy47TQ6YhOlVcxcrP82Vk4em
 zz2MwpHK
 p/rN05nOJ0ZTDh+lO467dtP3oWVS5upsglp6lZE4ovkxLYj/7/4DZyj2L/Vlrqgm0mzmBFJS4xlxuxvuOvpQctbaICFBmzIEvhAF14RSn8VWkBdwvFyPVRYWOuyqw4FkNUOHInQnAwtFsSRvpAbzX/xKykhwNux4KpzjbeAJ0LosT9WbZ3MNqHtcmBWJOfS7C0nIdwN6N4VVM1lqW0K3O0gTdCWQvccGv6rzPbQ3k/QpywPgxGH6KO1UsVbrvE2SZLf10FjGde+uo+W52W07hjih6+wXAmQITS7Ht34fMJJcVbYbLrqZGh1cy02vaFx+ldt2QDVgHvJ2Q3jdmMCM2qgxJeyg7leagUxSZ9PD7FhC3jzg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 10:13=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> According to Documentation/mm/transhuge.rst, MADV_COLLAPSE is expected to
> ignore any THP or mTHP interface settings.
>
> However, after commit 26c7d8413aaf ("mm: thp: support "THPeligible" seman=
tics
> for mTHP with anonymous shmem"), performing MADV_COLLAPSE on shmem will
> depend on /sys/.../hugepages-2048kB/shmem_enabled being set to "inherit"
> (although that is the default), which can cause MADV_COLLAPSE to fail
> unexpectedly.
>
> Fix this by returning the result of shmem_huge_global_enabled() directly
> when MADV_COLLAPSE is requested, allowing PMD-order collapse while ignori=
ng
> shmem THP/mTHP settings.
>
> Fixes: 26c7d8413aaf ("mm: thp: support "THPeligible" semantics for mTHP w=
ith anonymous shmem")
> Reported-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Closes: https://lore.kernel.org/all/20260908125105.1510704-7-kirill@shute=
mov.name/
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

