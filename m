Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA497CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F36306B0092; Tue, 12 May 2026 05:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE73F6B0098; Tue, 12 May 2026 05:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23EE6B0099; Tue, 12 May 2026 05:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D5BCE6B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:10:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7808C1A0403
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:10:54 +0000 (UTC)
X-FDA: 84758198028.19.F0366D6
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id EC97B1C0003
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:10:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DCEI6cgF;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778577052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pW8xb3lQZVwG9SPYcBLdpX+LoLXqJR9Zj/QEZ6SgtRo=;
	b=cEvwvFc0T1ZH7pNXz/Yfpg5TC3qJNWB08G0Ik6eNzbF8dTAsZui9Mzbodt7Hl84jMw2fUS
	2EndocIEwL9o+alkQBDRPp40RDWSuBnzWRRrnSjkzg6mGUHggLbpVQWfgpIEqUqVql2+Qe
	5rynBRFKLDA46aMfSI60vRomP+7jPco=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DCEI6cgF;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778577052; a=rsa-sha256;
	cv=none;
	b=oCK/KrKNwCqQpFFSWvQj5qB1NKiBlxKh+Y8aY22onFnUMe1SeZjbvjf71JdKO2E9E+LlrB
	lO8mLmpRRJn4NbRnRORhFnebU6k+9yRbcUJWHQXzVkG23ZeocqcpjD66Dqj5Ks0yTxM1PV
	nP2+StTjCAfbAjHxNmbMy+kX4tsM6TY=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778577048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pW8xb3lQZVwG9SPYcBLdpX+LoLXqJR9Zj/QEZ6SgtRo=;
	b=DCEI6cgF8YTaTCzw0zinvY1W92ic6asXnK56XhZkup4/a28KDmF0oYQEJj3THM+U9U5nOk
	geaZFAsavVFIChzY3Talo18o5WQ4YSjJI87UkQjqwubEP465K8vXmJsoPgYvqG9WqSVPUI
	E0CSaq9JZZ5RpEZI5OwVYDL7i42EnmM=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v1] mm/shrinker: simplify shrinker_memcg_alloc() using
 guard()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260512085546.368911-1-18810879172@163.com>
Date: Tue, 12 May 2026 17:10:03 +0800
Cc: akpm@linux-foundation.org,
 david@fromorbit.com,
 qi.zheng@linux.dev,
 roman.gushchin@linux.dev,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 wangxuewen <wangxuewen@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <616E5E26-BB36-43CD-B086-0F238903B1BF@linux.dev>
References: <20260512085546.368911-1-18810879172@163.com>
To: wangxuewen <18810879172@163.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EC97B1C0003
X-Stat-Signature: fcupkr717g87tzn5fwneanu7hn6p8b5j
X-HE-Tag: 1778577050-767752
X-HE-Meta: U2FsdGVkX1+BDn1qRUzawLbr/8MTCo8O3DDmhTfa1APrqHRvERuo1e7SVXCM4bC4ftWJQE6tozGqbWsBk4LcT2891rELYy5/Coj9D/XgvYpHI3g0R851HLJdiSj3lq/qiVPwIjaWOWgM/qfpVrdd16jtlU41XyQija4SC2C37xX+YJ7Eo6epGszNCK18uaEtWEFxEn1oCcWmeGsOIgY5eHRXOy1oSRbbavtuZSTW4s5TD8xGMR+9MxDzhqb4RbQh7KI+mwMp1K+U2+OlkauD/Whi/h+BdZZ711efwWwx7Us9nVbHzg2udSYetJirJ4v5H4nTJ5Ew+o6vjx0GI/phpfsYt8gEZaGjgv1qqO47I6Wsc/6X0piw5Z+wmVZ0/MVwweYPmbDLw+bm2IsHoRn2L95QeJj2513LivZT3UNFieR3syW89zCqhPtIQ8hot2t+eMWbvePjMd7y3A2ZKSwiMe4JR+f/gwNNVAtsXPCQ2Yh1o3pfmILV7SHS0QHhMJX3YEtY7XgHVDO7J6WBdwTAPEJBrqUHTeU+zzKKztfisOItPGHjgyyhwoWez1yqQz7A9FVFUKIpHbiGv6hf+iIY51qQqg8hilZlMp5/9WuH/3RJnZzNPiZpr3KeGXYbTEggvzmTG3vzcC5h1pyyE1Y3I055EijytjLZ/nmObB0/uO3DtoLmFp5rTeyngCWwrYfL3u4Cihi0EGzBoTT/e/LWbcg53S7oboDjhLk2SkdgXqFZ1JCtvf4oIqnJrXixNzke9gkt4jpmRnDovkF0yvIlpOijWWcIX0IDJHPn0ZOdV3VuHUQG5Jz+yiVA/5Xv2dqsAM39N/gOc3C5mp4HvLCcaiei0UKCw3pkUhv7T4Q8Fp6+dRA5ssbuQJ+avgdWgIGW0Hb9N35Njdx0vM5Q/3tCp347egj3+b84jUVnjqUj0I5XFKIZZXWj8g88M2Xkwzyw4+Tx2eyztXXRwdr1X5x
 xdNVjjYr
 p4OlArJimV/hWF4JfBGavWP4X4lTvkVY8JiPCiMP1S7fh7O9hUJILbm0MVcV5teV4IcsK0wRd2ATpCnXN6AV+Put+asRpMZf+FVakLMxpiTT4OjrkH7oGwfiKtmO8qXLMmTzHxzPQCjJ0W0a27r17CInas3RPe51YEqZyr0bX/+PCBKUY5Rvrd6YZxLFQ4At+YqLPLuqgA7z5bqyjToJw/xIgHriIPT9Pc9p50b/ZYCogNpz2JUHgsQ87HQKb3IO2fnQWXIelP//OXxxVnVmaBd6NkfVdjXjyTZXhoU5KXnZ+6tWfpKAvTl7dAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 12, 2026, at 16:55, wangxuewen <18810879172@163.com> wrote:
>=20
> Use guard(mutex) to automatically handle shrinker_mutex locking and
> unlocking in shrinker_memcg_alloc(). This removes the explicit
> mutex_unlock() call, the goto-based error path, and the redundant
> ret variable, resulting in cleaner and more concise code.
>=20
> Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>
> ---
> mm/shrinker.c | 11 ++++-------
> 1 file changed, 4 insertions(+), 7 deletions(-)
>=20
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 76b3f750cf65..1274130323bf 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -222,22 +222,19 @@ static int shrinker_memcg_alloc(struct shrinker =
*shrinker)
> if (mem_cgroup_kmem_disabled() && !(shrinker->flags & =
SHRINKER_NONSLAB))
> return -ENOSYS;
>=20
> - 	mutex_lock(&shrinker_mutex);
> + 	guard(mutex)(&shrinker_mutex);
> 	id =3D idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
> 	if (id < 0)
> - 		goto unlock;
> + 	return id;
>=20
> 	if (id >=3D shrinker_nr_max) {
> 		if (expand_shrinker_info(id)) {
> 			idr_remove(&shrinker_idr, id);
> - 			goto unlock;
> + 			return -ENOMEM;
> 		}
> 	}
> 	shrinker->id =3D id;
> - 	ret =3D 0;
> -unlock:
> - 	mutex_unlock(&shrinker_mutex);
> - 	return ret;

One small thing: since ret is no longer used after this change,
it should be dropped from the declaration to avoid an unused-variable
warning:

    -       int id, ret =3D -ENOMEM;
    +       int id;

Otherwise looks good to me.

Thanks,
Muchun

> + 	return 0;
> }
>=20
> static void shrinker_memcg_remove(struct shrinker *shrinker)
> --=20
> 2.25.1
>=20


