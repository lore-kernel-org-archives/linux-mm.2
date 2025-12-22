Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7473E674B9
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 19:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DC916B0088; Mon, 22 Dec 2025 14:37:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093456B0089; Mon, 22 Dec 2025 14:37:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8B36B008A; Mon, 22 Dec 2025 14:37:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E09426B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:37:39 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C243586E0
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 19:37:39 +0000 (UTC)
X-FDA: 84248116638.25.E44D0C1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id F08AC1C0003
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 19:37:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="W+Lk/2rO";
	spf=pass (imf18.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766432257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3XktKFfQ8uJsVluMD3VHEpq7VzmUmMEGAbNz9VTvAGk=;
	b=ezTIP5m4FzVN3FbqiSt3nX+uvY2x2bkgVDxUH9XKcp389sQC7Rt1zxSlkL8RONEFa83G7x
	DxOrPm0w/fe0d5fH7SG7EMash8xzSPr7WORUYwA6ZeFmVXot4Ubigo+L01c9r+7EiO/41X
	sluW8fx18UQHwnivMwAB/XT0HnRbD/A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="W+Lk/2rO";
	spf=pass (imf18.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766432257; a=rsa-sha256;
	cv=none;
	b=Vlw45Pj6AYJMo4t/S5sl2n1113QIYkHAZfy96DgSHZUkTS2h5r8G2fWaQ0oNjfWRHfutis
	zmOvVJ9weD4iuIJ74zTHWEbO/mDR5YTeiGOa1vzxaMM+xJOxROlrsga26DLiArwgj+Mip8
	T2nyhjIU7a0Qv5S6gMOlPfLg4SbPuqE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766432256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3XktKFfQ8uJsVluMD3VHEpq7VzmUmMEGAbNz9VTvAGk=;
	b=W+Lk/2rOjaOaZyage59n9KY8t74PNIBP+0i4bT/cqHxTMJFLfYwMqk/3EcroCDC+eIHIWj
	labqSuo1CG4JUfcz3S81GG7npjhluGO4AG7I4yB5SlLn4s6LYScefgVBonsjaGMVtmO8xo
	dN0JfRabWgkKoozWuZIAdPgaqm/Ebko=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-0VsuJcTjMh-aCK43NSssUg-1; Mon, 22 Dec 2025 14:37:31 -0500
X-MC-Unique: 0VsuJcTjMh-aCK43NSssUg-1
X-Mimecast-MFC-AGG-ID: 0VsuJcTjMh-aCK43NSssUg_1766432251
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-88a2ea47fa5so117089716d6.0
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 11:37:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766432251; x=1767037051;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3XktKFfQ8uJsVluMD3VHEpq7VzmUmMEGAbNz9VTvAGk=;
        b=VuD3BKTqQUNh0nQgcwF3a/L9tjzqjw4NLZUEnMOkyfHb4HSphpOeDxPsQf1BlVnvZX
         vTqhl47x3CtK7UV2CDAgplGM3HnAx3ZKOFoOm/dMYOKr/SjpPQag8L0TIss2jqaxXKz5
         sg6wnOeXyeINU7svXiVCYkHObYw1qRq9uCRZF7EgzogM9w47WR52X+ck1k26Yhjjxj8K
         /Hm60DDLx03u4s+JwdmgEb/h8TQsgYhLBuAK5/Vr17K6hhsnWlYMMO5O26HQhS1x7ns7
         +3PtbnRcs1v8qUtBV+kS3uBrj0yIDZnN44AZFrthHEgJwiH5VfZ6FLs3k4Umv55k2rXK
         1UKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpOovlm1zDZIJsksTqW6gCzEuaZncXha6Hc7EYHYN6McfNqaCu2ve+zoEB6JV0vFKRJUXciRVhSA==@kvack.org
X-Gm-Message-State: AOJu0YyZIACIMlQkLaybRShKLQbTqJeOM4Kd/D1JlnrZQNGV0zSSZPS3
	QDbKERHT4s5y4ZcnBKwTEYcrDgD112LIXjdHMWN7/EhK/nRiNc/UyqoOI4td2BeW9EJ2ODUDegq
	GemnCb5rUWZNH5JbI/cG5DwRdDgbalrXEdIOQsB9vwDOYZDfqM1hn
X-Gm-Gg: AY/fxX6d999ebcDh5/8xnKnkeR8ioDoQAjMLoA6js5K82KE6aVJgMUm9As9bYiwSRL+
	FrtW+J5+U31uw6eYI1yRt556Z6Odh2kPwIDc3gxyuuZvF2s8HrU8XC2MpuOaRSPUs3nb05NUvwK
	3BghBZo2BI2te2VGvMEq6kOQDZRw4CfujdMDbj73Qbgy/LGhAMwA9LB9FXHFMluMFdR7XKczvgh
	k6oX671/2MDcuUZtxEdDEuqQ2YIJcM2jaiCcnhxGzvh301aXrcCc6GY4JUvmwf86fs65e3fB43c
	yQZg/mhNWHVzqJFSBeJ4CBr/mmipotTapSEldnffFjvTz9GDuTb8F8OuHCeh+m0HeFmckXp9wMy
	KFNt/83cI5yQ=
X-Received: by 2002:a05:6214:1cc5:b0:888:6227:3e77 with SMTP id 6a1803df08f44-88c5001ff71mr280547086d6.4.1766432251298;
        Mon, 22 Dec 2025 11:37:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHRXC9/ZSKqrXplj4ZTnSkhC+GYjSHWSB/3j0UjZR2/CilRiGnbj5SN9Coz7NzYDjkORfBbzA==
X-Received: by 2002:a05:6214:1cc5:b0:888:6227:3e77 with SMTP id 6a1803df08f44-88c5001ff71mr280546756d6.4.1766432250935;
        Mon, 22 Dec 2025 11:37:30 -0800 (PST)
Received: from [192.168.2.110] ([76.65.77.217])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d9623ffd2sm88370666d6.9.2025.12.22.11.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 11:37:30 -0800 (PST)
Message-ID: <cc3c5224-e012-426b-a66d-d4c7bd945bcf@redhat.com>
Date: Mon, 22 Dec 2025 14:37:19 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] selftests/mm: fix comment for
 check_test_requirements
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 david@kernel.org, shuah@kernel.org, linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
References: <20251221040025.3159990-1-chuhu@redhat.com>
 <20251221040025.3159990-2-chuhu@redhat.com>
 <20251221040025.3159990-3-chuhu@redhat.com>
 <20251221040025.3159990-4-chuhu@redhat.com>
 <20251221040025.3159990-5-chuhu@redhat.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20251221040025.3159990-5-chuhu@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: H7pjF1fJArYpb0jT4eJVgH-pFvUnfNQZMhZECH1lmU8_1766432251
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F08AC1C0003
X-Stat-Signature: cjkwthk9xcyz7mrhc446dqe6tpdesmoy
X-Rspam-User: 
X-HE-Tag: 1766432256-91710
X-HE-Meta: U2FsdGVkX1/oyosXK03VlnL0XA5YG37EQJpVfFIRw1eVgBmVIX7bQ+34DyVFaw7+3G+fvl1PjbF/DbwCx6HvIRHGQTnxk6sBkYc5Fz+FJWEf03KUnUcfA1xZt6E3VKIoAJY/wuRriLaqn0bhQShvqrA4/lt1bI6LoJd364vVs1Q1r1BNi5ksDxaW2/kFmZjguSKhM6urPSX6lnW6cgXC2l/ioZAmayBn8qFtWgA0Rp6l491c4J9ztyxVXNOc79ecy2zFc+wQP46VWaDXK+otLDjvhZzVsc7/gj6Dvp2AhomU2PZ0VT022BasAFGLcIBphvMBi4BAERmlZQybV1nzgREG4HCXnx4layN9ZMimxAdwp4dd9hhGT1bmdHd0CcjjzGMggNXb+9sspVFyKBf2ASuVZzm59kHoX72/T90zSiKgbfQu95wjW/1CsCa8OFasO6EOKi4P3nLE8bcS+uz4K7Dx1HDblbOwg9QNcl0cJCdmvtY8SWmQEH5oYmP3baTEuYh+WLtaU3wbuw+Kxmi5s6tHQc8tZWqHYOU0Zl3ULalS0PxjcIvzU9hjodUuEfN0AkUnD6naQThVZdnbhysY54rWscJBFIfJaOBN02qjhxV7VvFWhfrPWHFUBL+mj4mLZM+Uw9pZH0/DV9OeI3TRhBTRD2gxrN+cwrl6IdSmzPEypRNPmTHViIZ+Y1ZDFQdNCuFNxhtT8qEztQuYOs11ttYdAkIlNLn6ztroJs4qZsY8/3hTcK536A25DoutNkX+UUZ3rsh6M/3lkwprzNrQM0V95mvB5qNA4S46UIJvF8OLTt/uLDvhDjGcDEG3/NQiwHKCYB3I1IpckZTQltC4iLm0cTAUowfmOWT0dJzlmFQxCsnK+0HA2fKaQmW3xbhMqdTGT5nMlnP4lZVi8d/vlwHcGLZmpXDn54OIGrodDmqNrr1/ZI4obvS+4T4ksdj9dy7PgT/Fn4bMyB9pBpC
 W4rLvAva
 f/t7bJXhFvZrIUMQ7aXrDbLwzgrosubiqEz7SXRuTTalmysy4fZbsawZODaFJL5EibUNjrRL7X0tqENyPZdNWs+U7+Cx3MmZTdSqhzbbN1IOLADUfarKBgIMnwlH+1C/D8S0GBLmQI/5fWm7yb1yNoeF6WpUnSEe91pMnj6Zkz01XmgT7G9uXQ4ALWH+j9WuM1TnsaMZtEh+5yFdS0s4jOrqAjIiqJdjufTmVgyua8DAPz7lzpWChQ0GgFYwyeXOUkr+NtACgbovGGsg2ccWhBS65UVH55zm+eZfBqnC+yGtO24ZGqd4C5Mv5iOguxIvpKclIOYjkGbcZ2hosWRbnWzgY3edYatzCGC06hUNVcq3yhL7gVfzadhflMV0zie+MOOYjVsqoxLKgiz6Fc7D/aATW8WDbf59o43WdfT96mXM8DqtDs/2Tfb3Rr9d5xTqNt/H/CFUwkCEzvb74KgIKa9+Z9I7S7plQyuvx+IZ8FBQ8OhpgVRiosJMWj4ZYmt6cfkOA+BdqB36qD/HnNDKY8GpvyobuDXfPFuf+J8wUBaFQtsg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-20 23:00, Chunyu Hu wrote:
> The test supports arm64 as well so the comment is incorrect. And there's
> a check for arm64 in va_high_addr_switch.c.
> 
> CC: Luiz Capitulino <luizcap@redhat.com>
> Fixes: 983e760bcdb6 ("selftest/mm: va_high_addr_switch: add ppc64 support check")
> Fixes: f556acc2facd ("selftests/mm: skip test for non-LPA2 and non-LVA systems")
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

> ---
>   tools/testing/selftests/mm/va_high_addr_switch.sh | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/va_high_addr_switch.sh b/tools/testing/selftests/mm/va_high_addr_switch.sh
> index a0c93d348b11..9492c2d72634 100755
> --- a/tools/testing/selftests/mm/va_high_addr_switch.sh
> +++ b/tools/testing/selftests/mm/va_high_addr_switch.sh
> @@ -61,9 +61,9 @@ check_supported_ppc64()
>   
>   check_test_requirements()
>   {
> -	# The test supports x86_64 and powerpc64. We currently have no useful
> -	# eligibility check for powerpc64, and the test itself will reject other
> -	# architectures.
> +	# The test supports x86_64, powerpc64 and arm64. There's check for arm64
> +	# in va_high_addr_switch.c. The test itself will reject other architectures.
> +
>   	case `uname -m` in
>   		"x86_64")
>   			check_supported_x86_64


