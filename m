Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AC14606A336
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 19:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aFACtggm
Received: by kanga.kvack.org (Postfix)
	id C350E6B05B0; Fri,  6 Nov 2026 14:59:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0D0B6B05B1; Fri,  6 Nov 2026 14:59:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B23B66B05B2; Fri,  6 Nov 2026 14:59:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B76A6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:59:45 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1422DC01AA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:59:45 +0000 (UTC)
X-FDA: 85405759530.04.29A07D5
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2AFED120004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:59:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aFACtggm;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793995183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4IjryWNxdORCjNaHoK0nCSyu8CfUlBnhe9uOpGWyC/k=;
	b=eNf4CiAs/FMpQe6GNaSl48X25quM0hitJKU4W/ALlBgpQS7CoZg7d34DOGCL2fwMY3gcHw
	7fOnsL+8EzuEmnp6y8wYvAiOakbCQVnBIcS5nCnWDG7BEshxf/9HljK/A5z/AgZnP9zFGp
	IRbic1Fe1jIbbyVPH39FcnHsjY7GJSo=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aFACtggm;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793995183;
	b=QIYAhCSjXr3qG+XjcWLgS4GlnYCGmmYFDzuGTB82LczD6/HiiURLUFzOirLXTma66f/tQk
	fGH+yjjyh/AHtU51/HTVjoNPOpEqPH4D7R34i+lcIUwA5P8MgBxbcm8CpHRgH+JnwKkIsA
	TBWobai1mTjZyr85y+cMWM5cTfWfexw=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a208d93758so10878445e9.3
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 11:59:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793995182; cv=none;
        d=google.com; s=arc-20260327;
        b=X+73wpdTtRSkt8WEke0sPF+kEe4p0wWnQBjAjaMVf+CDid8r+ko6cXgY9CsAhlv4Mn
         7dXgayEMrtVTjtZiRU6K8cnSnvvE0OFQ8NVCtOHDTsN0765r23AQe+f2rkbcYNxipr+V
         ruzeRvIyL8vDxALsF1PNzPnz/dPvxlJHUwAvzu2fD/uVSAVzPGhhed0G51Z5vD0uQMSd
         9qDHnGxJr/voUnKkYVAEvghHp/BXW0Bq7W+hUW8Y1lJYdtrIv7SZARzYnWvvhEe3MlsC
         kd3jichOGz7JLYb3r4Y7XtEXv+eziqTxpLHpNeLTTTLe49FjmzQ/go133Uni+nnpbF3V
         HNcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4IjryWNxdORCjNaHoK0nCSyu8CfUlBnhe9uOpGWyC/k=;
        fh=u422dgagqtW+wwzV8B/cuwJ22PhiTvFBtarLUYn3eaU=;
        b=IljrBdCDQJcc6IRZ8sZt+g+KcFTQaoS/SKG6qARu3ahdDawpVFqm4CKL7grophLrFo
         iXdag7KPhYpTPe7J+QDFRHOUJwc+92Iu2dTBCxx+kOX7fr945rTreqjKLoIpjjvDJSAf
         ehvRnjFPqEC2/OmE/1WWBwfmULR4GBAj/ITuzTpJQ3FX4PNJEm2R5qspe9tCEjRxB4Jh
         GamcftWtr/bN6GZSY5FdJm1poRIQpegdMuQQeZhCJPT5do7aygXCC9tZ/fRB5tJP/DCr
         YjmZlH18gfiI8vVnyBdH5ajbJPyNOJEoALm/Pyi/roOa1NJ3icl7zVs4WCPAz1walmJ9
         5I5g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793995182; x=1794599982; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4IjryWNxdORCjNaHoK0nCSyu8CfUlBnhe9uOpGWyC/k=;
        b=aFACtggm3Z17ac7Q7sOWQNrrUHmflJR/j8jjHRL2401bjiCMEwKQGMrqIVZjOdGf63
         ttffrAUX5+elx2Oue90YD5zHRh0UFbacFVgUrdrnlUe8Uvndu6uRVHkYxf1cdaj+6KNK
         hkpHswt5tusgLUwrXvxnSG3NkuyS2r/GS3X8MAu67mZGiyMyr4/jV5iqeFt7mX5dyWcj
         tIiiNNrvzNiNSvShhDOTC/luZmOkjqzrgy2H3fEQAOigzW85hh++x5zFgfk8XxsN+jk+
         MIyipPINTxn5Udw3y43ch7BF15CVX6+y9qdf0CXwv3TUFdKxwhP+KUE1QaEzcigIOipR
         IfFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793995182; x=1794599982;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4IjryWNxdORCjNaHoK0nCSyu8CfUlBnhe9uOpGWyC/k=;
        b=c5XUseib0FM8IcRCANxI3wZFRCNf9fXJD50gyHs911x3JJfuJrp21N+vn4WhNDgHKz
         lilOi7vvAUDvt8SwMscMY4uLvo9YR3OZ8WhVhso9Cg6Hi9S/NrRICfqreDiOaNftsGMK
         QS3smrcc9L8MhxJWWvw479M9oSvHkLY2Qi+tl9RMWiAo/MZTlMkx2oK9QB5CWAj6ATfk
         6oiqSLMn6s6zWxhRtokrklgwRYgUzAaUTYpBPKU0eTAfdBOXTFrnAX4WRitybWhyZy9T
         vjWp6FC63uyD7f4JsWyRGzdp8YWvefQ88rX0otdsr3HkPjrK98N/N8u3lBamiu1MfK0Y
         cXIA==
X-Gm-Message-State: APuU4Z9ZxkLJLXQpQ3o/zPiNLcsHrT81S8TanhEyl56mvE8vyMl6keDc
	3iJ1ctSBFOEZFaI9iV5K+eXyMz856ziV9849tnb7RmZc7lgAl75D5oj6CUTiTk+u8lTl2RnZY5d
	wffxDacsUm4UbGodmdxV3Z7KbWEHWiq3PdOpVHBe60A==
X-Gm-Gg: AYBFou2kOwFWPjrYKMLrMxK4INb1QE5mLeaEQn6mSLeiRL7BVUZ7flobhAkSloPphEd
	5Y6jXdRQzTB+NFTCBGah4vty92D67toJ3yrB1N9uvWuBOd/H2z9sRUQf4QMsHZet5nfS7BRwJO4
	fI6koWQqxn0vrl6Ye2q99Wjg0rdryp7J3Uh2wwaQ0aEMAI3uqYIR4v2HlnAHFmkM/JU/xuwS2wF
	F0MjhaFCSlKO+qvE/+v+KgAZKsJ2Nrek5qAVcQeBqIyPM31TnfLAbELZG2eOnhKZlKaA0IRu/PT
	VBc15sWGFJdA4XVJfJfK0DhRZXQJ6ycjvyBTc+LRHUzH6CoK6WQnfVnvpSddub4Gy3KjdjRlBj3
	oJnXy5LslvjhPdfPxBJ150OckyV5MuG9Ji4x9A3DKI/0N7BXTLSTneQcVcpC5/HwMvBPDnaPKV+
	XLDXJaKzhl7lxzL5D5POHeEkjD65HIjVFojWVt0jPMxWR+z2OrmkbD
X-Received: by 2002:a05:600c:818e:b0:4b3:9540:47a6 with SMTP id
 5b1f17b1804b1-4b6dff86e38mr59681805e9.28.1793995181368; Fri, 06 Nov 2026
 11:59:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106160432.2552507-1-nphamcs@gmail.com> <20261106160432.2552507-3-nphamcs@gmail.com>
In-Reply-To: <20261106160432.2552507-3-nphamcs@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 6 Nov 2026 12:59:29 -0700
X-Gm-Features: AclHuK-x2stv42uMBHd5li29XslCAB0_-6f7YisoUMr7LicPx45if_utjKD95Yc
Message-ID: <CAKEwX=PiM8vc27jOVdinOGO9AdCOpbKozu=Hj_b55y10-ynFyA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/swap: publish cluster tables after reacquiring
 allocator locks
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, brauner@kernel.org, 
	chrisl@kernel.org, david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com, 
	ljs@kernel.org, mhocko@kernel.org, nphamcs@gmail.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, weixugc@google.com, 
	willy@infradead.org, youngjun.park@lge.com, yuanchu@google.com
Cc: stable@vger.kernel.org, ryncsn@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2AFED120004
X-Stat-Signature: z6mtuw9qcu1eytdq43uabfd9pxoyr4jj
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793995183-410153
X-HE-Meta: U2FsdGVkX1+r4c+LlGghuQdyOgGzDNAzay62HqOBabVwrdZY/EpI/+sX98oQpcUjKGp6unbodbVkGZ5DN4IVq41PEmQsBe1xjeNpSnjfsPYGamF4/NAYlMdJyQDGWkZBJorvQbK5B3Ql9Yb2Xs74VKEX8AxdDKSGIU6lb4O1tH/EINlyb9NIuXCF6q1/0dYAGFJVrbVFYN48cEcNSIq1ydhLz6xpzov82atkt7vPLMENt9JZ6H3bwa7RrnT3amsbCfx8rieF1SWj9Rvj63fgNnNlCEXgMm6w7eNFJNIorE+MrfjzaPKVIWClHhG2a9X/D5+ALlcxTbAmfIEDWfu/w0y/0p1MptaPNeg4zAPUuNDqT0xn3G/GrS/amVIqCavEB1yEg/xT5Gkk9C6odqqeBOdlq6hN0Cz4s+rjcAVp362dhaU5dWN/WxzTWLtwaMoeKzLS7YpTUCI/gbhoIgl9wA4S+oWmSihDI3p87x18ZAJAAJlTNXuacVStA03ynhsu7oc2ya3/wODOKeIY4h3Oqoynydjp8RPJnzzO3E5Eo64Qlg5gSqxz4Hm1ONYnX6+jcsoLwwI+uXH7f0K+2MK4mFAn/lX7yJIKvB6u8cB3yoFppaHasoDB+L+k7U1kWJdFDEtDbsdTglpOX8C6gOq80FW43j6eIsbNvl+ni6Jpg1N0uGrkWnLx9UiFTWTWvb0WYOfjfMhIsztXtOidswzzr+eraEjEpNchWr+4deQ76/iAewtHKsE3Uh/xX8D7g+Ft860ZylC3Sbn8MRN9IcvTLDpRaMmKfNzOne+nW8am+zBB9Cj+FeiaVHok9d2RQSvxLkHku2Ue9pC/kF7VgsGOnmZLzMKTfvlxxzghPyXKBjXPhQBcKcheR2b9iLQq6VVtnELn2xbF1vBdkM4bEBtyY9lno8ytf2TcLwRT9qKDnNLcJ1zK/WmjGgM8+Vjn4sbtLP/Yg0ftexa9NPeQaXN
 VmUeZJq2
 n0mTSab3ZoIJ+WcesiqkO/1yKy2sKnFkNjHetXBrJlSuXpTzHxCWPWixuP0zBhLVLUL6ovMy5lRgkiPHIvE1WpBSx7DZHWDy4Pg2OW3Sm9oYnV+WzinU80kIvcPtqiwbmsnVi/1RCi9jdkYHWxTJDMzXX2WzEM4N/u+jcFB8gIGycZ3qJuC7YUOqgkWViG7JoTMW9vlGrAoW8JacFXVts23webiEL0m7Z04cTaNxDzbAGTx2Ik40+1G9XUJJ3N8GOF/Vfs+gH1JqrR/BjBsDwU+TV3fsq+up8iy6HzDsN+tWIOAS05wxASJGCQc8dvymWldZyysGNWQmbg7BfQXHZn7oo74dpsTXtMM4AKtisa8UJ1EaqkUG3IE5o6AAjsMGIGdHVTiBxMYuGhLXl1LqXqWwMOqrFn/L6iyJAwOCeAdCIW49v0yJDT0xTnG5XThTtZwFn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 9:04=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> Under memory pressure, swap_cluster_populate() can publish a table
> while its locks are dropped for a sleeping allocation. A cached
> allocator can consume and free that table before the populating
> allocator resumes, leaving the resumed scan with a NULL table.
>
>     CPU0                           CPU1
>     swap_cluster_populate()
>       drop local/global/ci locks
>       allocate and publish table
>                                    swap_alloc_fast()
>                                      consume the table
>                                    charge failure cleanup
>                                      free the table
>       reacquire local/global/ci
>       return ci
>     alloc_swap_scan_cluster()
>       read the missing table
>
> Keep the count table, cgroup table and zero bitmap private until
> swap_cluster_alloc_table() restores all allocator locks. Install them
> under the cluster lock and retain it through the scan. Initial bad-slot
> setup takes only the cluster lock because the device is unpublished.
>
> A stale reclaimer can return the isolated cluster to allocation while
> its locks are dropped. Abandon installation if the list state changes or
> a table appears, freeing only private allocations. Restore locks on
> allocation failure too, so the caller can return a still-isolated
> cluster to its free list.
>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://lore.kernel.org/all/sashiko-outbox-181084@kernel.org/
> Link: https://lore.kernel.org/all/sashiko-outbox-181086@kernel.org/
> Co-developed-by: Kairui Song <ryncsn@gmail.com>

I think I need a

Signed-off-by: Kairui Song <ryncsn@gmail.com>

here as well...

(Kairui - up to you if you feel like Co-developed-by + Signed-off-by
or Suggested-by + Acked-by is more appropriate here. I just filled in
the sketch you gave me.)

