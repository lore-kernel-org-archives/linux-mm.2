Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A2C3CD5BA4
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 18:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02C446B009B; Wed, 20 May 2026 14:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 002E06B009D; Wed, 20 May 2026 14:19:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5B3B6B009E; Wed, 20 May 2026 14:19:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D710C6B009B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:19:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1F00C1A2E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:19:47 +0000 (UTC)
X-FDA: 84788611614.17.2985D1A
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9B6A3A0009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:19:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iTVvVGS4;
	spf=pass (imf25.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779301185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iO9EnVNw6+es9aVQd0uOwgoZSjTQW8txHk+VZ7fQZzc=;
	b=youN2zeRxZYbZ8YBYLFKUsKf18/wl8nUMwXacagLozJrWGFWQqD1U7xId6o7eXGa27MmZq
	N+8gJQAG67xcbSIsuMe5ProSJUzqj+KXUX99shCt2EAwA1Ysy2TRVcWja9NU35ZlxC7Bz2
	89Y720ylJrC6jyy2E8CAF5B1OTe6PEs=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iTVvVGS4;
	spf=pass (imf25.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779301185; a=rsa-sha256;
	cv=pass;
	b=aeqiGpAl9JCUodOrxtrlM0N7kGfTET9aGK0XGs0+wB3MoK4JT+lxPMSH0zCJGsD/mWjmFO
	EdWkDRQcwswZ75GtttcQPOmwXmUsG64k/5PC2/xvYMDwKWZw4gBlHP6+ZAf9UWBF+8Rs42
	ZYESS16/eQ5y9grnnPIenYObEwmTzHY=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48ff4f8ef0dso57879125e9.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 11:19:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779301184; cv=none;
        d=google.com; s=arc-20240605;
        b=b68aTitNVJeXk2d/0mEARdvJUC8YzbgZWmYRtjWEKBusRTqtlE13+ptx0z0ApCghEl
         ajlm8kRSBDEe0qNw6ij//DxZrBdkdqIbeyaK0E/8qjjvX6VmI1Na0QAvGROSzm4csAXd
         2w9hsK7ugzV5VwMorTiDLxoHIi2UfSz1KRaR0/5KpjMW6r2OJ2/S3lqMewYvHYNClGs/
         lQPx5RATOuLULLKMCalodqCYZAnL9gLq31ZzbgDTFb/tXottR3KjMJiKBSXYALiCicOe
         DQ8useqjU/jrlsf3xmFfBIOnFgDwl2RwTARENrfFy8dW34+YbAIz3Qb3hSvw5YEXtkqf
         AznQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iO9EnVNw6+es9aVQd0uOwgoZSjTQW8txHk+VZ7fQZzc=;
        fh=8UJb8E63QZ7qGWXefjBkyuKr7GnGy7rr7kaiIuvFkTc=;
        b=ih5LTCEy1brau1hVwAO4zOsFfAr5PSk2nGgX8Bx2gVOEYSMBWRAoNekH/bXSRcPJw6
         L51G/c3w459lpQk2aDkMu9Xs1Y/9tS5Guz1Z5vtW0hQSDU9mQ//4nWXFgBoKHs4W0PK+
         sb1mp2JELNMVvMEcXoxPNe5Fq12O9+PUvZk7ugZdCwLp+qyQOzKEzdd60GtMj1+j8Da4
         r8ddtJhI+pYF3w/JdFvAtcbfKg6doVjPARm9yEPpwggdw1LsQIzjX3hBm681KokglQx/
         6F0Wjb3ce+WWgnDoV3jdlf2S6p+s0vZHnjtZOptSuKlGtzTOza51s0wX52MjF5m1AwFf
         7irw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779301184; x=1779905984; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iO9EnVNw6+es9aVQd0uOwgoZSjTQW8txHk+VZ7fQZzc=;
        b=iTVvVGS4KIf2bBkhiNK1f3t//aHJ8wlK31VFwyA9lrWtxaYdNrXLS1jwQCbPlLp8ls
         zEf2JQJdLaPOxQUQ7XtThVx8lajAwUrAnHtcCEEzxP/iH+ZL6HhkhxTpteQ33DcXATqV
         JoGOJ0CBtAT5iQ8OkIDJRhZMEefmszwNkJkvPy0GYzZnOZZwtz9W3ltzdIvTz84NsOu1
         p3XeT5F3awCs2YuSSj5NQbevTdjeS1wkFQ0+HmivbVqJ4xJpyw2xr0clj5Vq9KZTYQJ9
         FwXWjoj1C6+w/dRbCNVMQOyty8ePMLULGY4AFMdrt9zZjhZ0i52r7a8XkBVG3jUetiZG
         T3lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779301184; x=1779905984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iO9EnVNw6+es9aVQd0uOwgoZSjTQW8txHk+VZ7fQZzc=;
        b=aZytcrBuTWmlqrulsEB9F3HWre+orFIB05W2YLGKpf1T69T14uKMeVlBNsiWv6bpPa
         S5Dmbr6cW3FjNwoMWUjD24YAw36oBRoAbXWsNSHqpeJIdILrvL0Ul1l6uovm/tSseB4F
         YeFWUBcaVGOSfBAizwxKkqC83efDVHKUozLnaKEamYktQQ+Wzxzn7Y2AyziCajlHqaB0
         wJU7Gq1qIewrEHPNemy1+P05OlNZFEb2o9LgVUqtl5zM9qvq7LgKGItaLx/OgKWFmef6
         E8qVO9O3DTjkoc/ySWSV5W3FgUycnXgUZNkZuxo4YD2hob+W3kbhXd0KXe+dPdZTxGED
         TMPA==
X-Forwarded-Encrypted: i=1; AFNElJ87gfl23D794s+1nPkPERAxltwYx7EZc73KNSU8iBJFr7c+SpfdqvY/YjiCBxW+6LhIYOJ6iFNnPg==@kvack.org
X-Gm-Message-State: AOJu0YwNx02u69GEBTM2ViXLmOTNS/a6FkAqpzduMSTXzvtiZZ1J5Eif
	7ogVlEFyioaoDWwIUwEEeU8m8gzcwEP2N/H4D9wTg4S1JxSZ8sz/1tWk8SYlrv23KhAsaZ0Bm6v
	vZ7y4iHx13WFZen24cCIUZrzpp3oToeE=
X-Gm-Gg: Acq92OGLhlkpHsT2RoLCZ1/J7AlkJM9FbS8alzOp8FfyNC1S9Q4wwAVzzYqpJYUbsio
	zu1GdVIqOGsIPRkgw0XQGGtodO7fjwTMJfErInY5nyxbtt/ohesmPBY3HgtGia1KoFaoEmYyzjU
	5rUqnRwsitRbVhMVz0/Ynh0EfUc4LcrSOYyuQ5lAd0BUMrAc//w9VPAJPuppEDe9yDDie7lh0gi
	pw1XUp7TBhsi3wvagpW4PnCHMdDKAga3/ae+yFGXhLkLjxwlXVOEaQUpoXvXG1lkEKukJ6ei+GG
	P6jyZhGATlpV5SJF7v8z+OuKSvZ0YTcafukSkOAEJesXm4+8G8Rf
X-Received: by 2002:a05:6000:26c3:b0:45d:b14b:23fb with SMTP id
 ffacd0b85a97d-45e5c366f83mr41883455f8f.11.1779301184133; Wed, 20 May 2026
 11:19:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260517071713.353579-1-wsw9603@163.com>
In-Reply-To: <20260517071713.353579-1-wsw9603@163.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Wed, 20 May 2026 20:19:31 +0200
X-Gm-Features: AVHnY4I9Jt5G7lCutMGGfiz1HqfoG3jfSxGh9bZhcV-5AT801gz5GE3b12Ca6gE
Message-ID: <CA+fCnZcKwsY=QugBgPAV3GzU51oy5=Q8qGXXzOQAXW=M899umQ@mail.gmail.com>
Subject: Re: [PATCH] kasan/test: only do kmalloc_double_kzfree for generic mode
To: Wang Wensheng <wsw9603@163.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com, 
	vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B6A3A0009
X-Rspamd-Server: rspam06
X-Stat-Signature: ycbrmsjsidnthr1tspuq64haw1x3453x
X-HE-Tag: 1779301185-599398
X-HE-Meta: U2FsdGVkX1/3d5sWWLXuK20gvOYq3xbwo/+efnDS5Oxm48nvRQOApmGvMqRAZ1JR3jJaTLC8dwOiNLdSY+v9V0NBZ9bp2UGbXguGzD1bEznNhW+h1haHlMJQSq4ixELcIOHScmKFWlg3wqizURWUr4FZe+3fo9eXYtkVWrIjSNIgZGgxiDz9icbD1P+md0BZs3wZlTZSxvKRssdtUvG17jMmhVrflyNkFaFMmtylwGP9EnAm1lX4buMQ2MJAKEcKWbT3Aim52hsKgMsONJhbCUSvFelG0S2kULoahdWTP1Mzwm1PBlCoQVHDqJ4hYZ3jGQhkm6uE/8NupNLlsbKbI1Jt1bCQ8S02XuXQgHErKI93DP734TYTghLioB5KGJaMyHyKyiX99kHlHYqhPBsbV0QH071BKORR62HVjYw2EZ+B/tbQAJorvjx6GJiXTdKJi0FYkNoODktg22ToyU5+Gm/1ZIqGepTwa+8ZLQ8j4ejNFa5TRpHW9yNRrlI7tyZqSzmiCLYVMu2x1CzZzwo7U59cD3Beos+WJ3qHIQoBtR7EeH6XOSYqgopXK97Y91YYeZB08eLS7fBtUJPinqyI0u8MC9L33KFDbblsd3mZ5xC9anR8H4BiB47NBZo16YYWVcLQGOoMc+WL50SzZ5t3hkDE4aneLQ//G9Q8DpKSS7rKeob8aP7Amsdktf/dMSrkGLcyJBiYLdwopBF5GFmNrbjO4zqbv6gEeDq7LwgE++02lWi3Ahlg4fX8hzi5QXr1gsdxJ+FpY1cSDvTy1LqSgUXNC+l4ACa8HOhKFoSsLTfyH+uRHXWGqhc9BETnHvKyTEstD+e/TycQ61Mf9M67GiL1sTtSyAeqA397AVhnPHm/vLbM4R+t7dUHNebytRrE/4mw0WXGbcJ/m893Cfs7TcTFi/W8NQoEc/yx/GCr65suSMOdoe0uvuWzUKPTBg04mj0U4VO6ZHZvoZQSQtI
 VogmZmWX
 fVX577fVOISXviu5SzCWlgIUfRdmgxueqK4u3I0ymf0N3rp40cAmQlWd8zaJ75ga31ZW3sxQ2tUYLiBKnjZxsr4j1ZQv9zdLH2/adUWjmRJVTUAg8zxEoKRj425lE4plJ/uhkT5gyPd+x8/PVyA8SobuuGz2DoSzzBQV3SVL1zbxpVn77iq4B91VLIPOD3/V0bHrhuFm0hBilNEUnBoC/fXQzZpRak66piYATY757a1tKMoouEuO/vpONdfoS46JESYyNMuMTbHreESsibLj8VJ7t1FYaRTuRKDwaTl112GlkaByBCnUT2uaFpgPnjzfxwsSlPP61wPS2NQ35KqPmbctY/eD8C8u+MC8Nz7DSCAG1Bd2nfb6Nv+l0wTwnpxQ2tCrZ8BkczOILbDXwjDLI43wjTM4yBcGSsNLGeEd269csS63KNYL3XPEOOAhSjGqsX9XoNpvvC0FzYHGbPnHFfCqivn1NMk3nPbmuCMtAaGnJ9djAK/yEWUEyJyaS2obYQ797EM6v4JpORU5SqW8qamN8vhu0Nzo2vOJ+KIdwSdeRUAvU9A1QP/1YLyRsXCDzyVjMclnzsh37O/ggxYdYeE98aVSLV66uIQmEI/u7SWFkwrmgfAWgLZyG2PPr33etHCHY/kzCzbxw0FedU4MgrFjT9Mv9n3mLJHL6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 9:17=E2=80=AFAM Wang Wensheng <wsw9603@163.com> wro=
te:
>
> kmalloc_double_kzfree() would corrupt kernel memory when the just
> freed memory were allocated by another thread before the second
> call to kfree_sensitive().
>
> This could not happen in GENERIC mode as it uses quarantine.

Quite unfortunate to disable this test for HW_TAGS, but I don't see an
easy way to resolve the issue otherwise.

>
> Signed-off-by: Wang Wensheng <wsw9603@163.com>
> ---
>  mm/kasan/kasan_test_c.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> index 32d06cbf6a31..02e43ccc9f21 100644
> --- a/mm/kasan/kasan_test_c.c
> +++ b/mm/kasan/kasan_test_c.c
> @@ -874,6 +874,12 @@ static void kmalloc_double_kzfree(struct kunit *test=
)
>         char *ptr;
>         size_t size =3D 16;
>
> +       /*
> +        * Only generic KASAN uses quarantine, which could prevent the ju=
st freed
> +        * memory from being allocated soon.
> +        */

Let's reword this to:

With the tag-based KASAN modes, if the memory happens to be
reallocated between the two frees and the new allocation tag happens
to match the old one, the second free will cause a memory corruption.
Resolving https://bugzilla.kernel.org/show_bug.cgi?id=3D212177 would
help to deal with this. With Generic KASAN, it's effectively
impossible for the memory to get reallocated due to the quarantine.

> +       KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
> +
>         ptr =3D kmalloc(size, GFP_KERNEL);
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>
> --
> 2.43.0
>
> --
> You received this message because you are subscribed to the Google Groups=
 "kasan-dev" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to kasan-dev+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/kasan-dev=
/20260517071713.353579-1-wsw9603%40163.com.

With the comment rewording:

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

