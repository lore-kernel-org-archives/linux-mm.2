Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D0D7FD4F2A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA9FE6B0088; Tue, 10 Mar 2026 16:11:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A57796B0089; Tue, 10 Mar 2026 16:11:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939106B008A; Tue, 10 Mar 2026 16:11:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80A9E6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:11:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B7401A02C0
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:11:53 +0000 (UTC)
X-FDA: 84531249306.25.E2A1DB9
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0A32F180004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:11:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e56MoYOM;
	spf=pass (imf16.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NWxIAA2ibBPYq38Kyu40enuK1AAGX6EsiWRJPLR8zng=;
	b=fgMMdZOmhtjkOUD/jkjV8zZ+vSQ/9Rof2yCJuPG6+zBtkhoh1Q7ggAZmKvmiaS8aWyim3J
	ybm1fkXtUg8F6wYGdiNcWDYg5aMMG2vq6rAPzHZN2cBmUe2MD22qbXE/+4rBHab6vU56mE
	TCl9kxPhA0G3wWgkSxE4YBJ/AztojKI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e56MoYOM;
	spf=pass (imf16.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773173511; a=rsa-sha256;
	cv=pass;
	b=IpUDuV5qfgVAoP+iV9Frz8W9hUqclvtI++Hz/C29W7oLH0JeD1A6a/Rf/ZzwT5BAmXuh9y
	IJxcjDJpmv9EbXKKYHR9zMbkJAg9ybwdoPMaOjwLeVZeq9+9R+9gxsR9EE8KYsveeBT7sb
	5IMI8mKv1jzQXqSr49bz6t+Vesqx+BQ=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-89a05955720so132300976d6.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:11:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773173510; cv=none;
        d=google.com; s=arc-20240605;
        b=UXwkMOmRy7awYGJZ012YdXLs87IEbwW7PygE6Eo4Nt79i0rVlRtBCbkQvl4kUwaeTC
         OmWZqPR2ZXaXVFcv/Q42K9cJdnr5RIkY/XU/39X6RBDswNUM33Ofjlv6KhFkiTwFxADg
         2WXtDeN6MUSaoeJw8U4GTDPSpAlbek4jFEZ44ghuAIiuTQs340vTkvHTCD3h+0VQJFl1
         qnngYpnBhed0OXXZg/kbJcfnwF8D6k/qrHWe7S3vp0hq8oEFz9vLaTeQuLdoUwIdLbjU
         BBMS7qxpDOsUdnRq5f0mQBUrgPeKAZvXzmDZsnsrJfrIIx4i4N4MzdObofHVaubb6RWr
         phdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NWxIAA2ibBPYq38Kyu40enuK1AAGX6EsiWRJPLR8zng=;
        fh=pIMgj4Tst7Dex1E13Qz809EIxbtCFkcUv+s8AeK5OrI=;
        b=JzHfmCWEVeGIsD0jnxL+9V2eQm6jCVUrUGzpaqC1zr6xEXGstVL21KX++LvsIku1NP
         rWTBjlYXr+UJJeQHq/muivC6J0ycp1P59mPUFXpZfpcW5zozhwWqpWDkIRujgV8sEFin
         gXF6T42u/ceXLKdw+UJJNMFWJR3JBjIBLYXlCidrhTPPXHOtuvN93+jONzaC8ujMBpWP
         hzxu0Du+hlWZ1rWFjddV7sj/Mkr5KQz/kJcJyg3LYrodIPiD1PIr53TRTM6ncCSV1wt8
         K9F78oiczZL1O+ktSdx2aQOhPdL2wI5NAY7BHe1YN4pFXSlj3NVg1nHEXylkah6eX5MH
         NH7w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773173510; x=1773778310; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NWxIAA2ibBPYq38Kyu40enuK1AAGX6EsiWRJPLR8zng=;
        b=e56MoYOM3lgRbwArV3H7aqNON/JJUrIlKu1FDcpjg7Zh2uBJzybsa8Mpu+4haK9JVT
         aU9XMemU+TVksyS28yB0qOp8ajthwadHH9M3JGyKERIpa17zpyg8fZhZESQ4hTsN/Vj7
         WrCU0GGa1qT55mTSfUWcNaHjUs6ixWTrs9qw7n+Pk/5yPOQxwB/fp98fxh8qzqphVGRH
         y6p95sDsVomc4s/da9Yo7EOQzhdQnqhLYFQCA/e1PtYgutNPR4pQr76Y6oAsi59RA3Z+
         IXCC2cF7+Docs81w1IROn2YUJjbLhLmO2kTQp3e2Ld4LZtkkoOJEqCkLk8cuiLQ9PMvX
         GqOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773173510; x=1773778310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NWxIAA2ibBPYq38Kyu40enuK1AAGX6EsiWRJPLR8zng=;
        b=QE0vIRdkBOi8DR/O2SiP7FD8I4nHOM5kvSd7mdQt4Rjqoce3YARBPk+fRBrXI8yogt
         zo4Y/dacYmXZvjrBip0C8wIU8KC6M4w0QTqUJs29pSvTpzfCKJoOjOAJQlaS6ox0T31I
         PwIxCLV4yFrnChAGWjKzvWmXrYtn0yts4/zaLGk68fYhuSoM0vGOEJoZ7NdWlkXMpls/
         M+jt8nDVOcJV5vOxqvXfj4pek3AKCPLFCZ2sVV7g7nqVaD8euS1WwexfkZOgS3aPRQcq
         TxD0WaoMb/t+Tw1JxRn6wx37lE0BvLLa7OkjO0h2ojMfRqhuIGuMpLsSVw+yQJBzzeq4
         nTFA==
X-Forwarded-Encrypted: i=1; AJvYcCVNirF8SHocDzbCXrYs2tIOrtG46n2b0v/AlKWAC9blujagkHuXj7yeY2F3+obaeb2mouawPq9TFw==@kvack.org
X-Gm-Message-State: AOJu0Yy8GsQvpedEkBXpYGrKqEyPkmblTiUQNgn5pD4e919nRccEje9i
	BSG5oIj/f87h5zJ0tlQSR1+RIg4GOffRc5GH82Q89lruggUCSXYM8O9qoMy9P2MUIfeXQwRwcuz
	BL0JzNXI+lrch2Janow5IbXkFz6ebTjc=
X-Gm-Gg: ATEYQzx6sU0dRBSs2l11XoCJ4bXVvG7ToSNIO1Zuea5lyn83NU2SZ300zeKyTOYxAXH
	4i2bgrofvfhXWEUdJO+cP7KvLxj20CEENWcd4TmOpmX/g4fVj89hbFOcNmfPq0zTETKz45Dpz//
	bZNxP/jW7kBMUUgnChqeTlPd9aeNkrCnZvebr/1P19H1IhkMaQLdMPezBis0m4EBwjUts0p1Bzi
	dr9zc07kJoCvOXRRSjAX47NU3NSxMWa/FebEm0st9atb4EMyN6cUmF7haRvQJvwhwAz5r7wKQ+J
	bWhjOHLhuYvBoh1B
X-Received: by 2002:a05:6214:5083:b0:899:fdb1:3cde with SMTP id
 6a1803df08f44-89a30a59869mr239982776d6.26.1773173509728; Tue, 10 Mar 2026
 13:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260310-thp_logs-v5-0-686099175bf6@debian.org> <20260310-thp_logs-v5-2-686099175bf6@debian.org>
In-Reply-To: <20260310-thp_logs-v5-2-686099175bf6@debian.org>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 11 Mar 2026 04:11:36 +0800
X-Gm-Features: AaiRm52B4Vbm_qQBeHopA4-nh-OCV4j4DrqEsielWMnrDy6fFosxcM6VDoqMrX8
Message-ID: <CAGsJ_4zUQPfrpnwcXJQUGMP_0dUW7uQpVuGr7EfNm+qPnDGLHA@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0A32F180004
X-Stat-Signature: h1pwb6czeaxgbmn5ssdw435spuijkbh1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773173510-455118
X-HE-Meta: U2FsdGVkX1/QLfHzqFWKeXDMo9UklRqoxaGf6eYuXBYeBwMgB26vRcjUEqhmI4XyfX5IWvS54sT3s4PKNYESBvoD+Carc94yP8Z09CVrU4LH1So+BBqg/S5kwqMfRaMK3mRM/JoycOeiSmKFpouYBmg8qiap2ehU+9a9ogQ6o56XpyEbHV6CVRc3u7kittvEewfomQ3QLs55beUw1qabEtZt06Q+whjpFmVPHI1+p3Dlz59Cr5DHeDY03idTCv1b9zPdXkJNbUmAlLYQuPC42L/7XQrue0OXqcxge9WD028iA2Xhp11vDy9va2EUORn5zUr1MIeYJul6GeIi4CstDR9R5/jgn+HFYxNIoKpmTZI3KDZviecuabUaJWk/vCz6ENhm8LdjWW/70c6o4Ro3am10s+VpaaE9NYz5O+yzZEWSPqM6qJA3PZey6k/6Q8yWVRUKwtRr+lYeDuc/7YZtVQnZq3r+eIyyqGnmRuqDITuOWf0ubW8aOkSIa0oUzVXsETWMQQyoD7Mr1sugh99K7cCe10AnZWXtPeUSOsCR+exjuAe4Pem2kqX4aJYZl2u7bkl2paDnytfwiRL1ChzTurkVwaxhkuHfHO86iR+qBZP01X8idFB1DAVOMBDazaJVh5tVt0oIVAn+r+DH2aQsTLbPAcLXtD4QJaTmzrb1Un7ypKYCd5ny8a+uYwsahFzNUhbjoHq0D5u+0FYsRVojDT+imbw5yVaNe56C8qBGYq/+dLdK49uUfGhvV4RHU8yfvMZpLGBuAIx0yW6mhMM1t9GANWeDGvgOW88M76XzDQ6GsnJr/vF9EXAo/Sj+0RLtt6gfZNdAt//is2ZXWAy3622ML1CIc7FmvV+j598ziQSwJ3OytV/V3ya2SC8GZnmKurAp6OiJ6RvdfUhSe+5IAjrNEqRTBCZvO1feG72cIgBq3mQxETD+hhC/UY4uIrbowgYmFdIgzeNoCbI/euw
 IxTiwVoh
 VBi8fIJRTkMaT+OmeMtcCQ4nR+D4Ir/XWhEBsvQXsKcPJG1yoFrypXQLJ8tZesYNcyanvH7ZoSA0ix7bJx88FEZsiAaiKv0ufKHveqvFO7iGYe5I+Kc386UzoDH7uccQE6fepWFH1P06N2giQDzTBDIxD9iqoXCmA/8oATQf/JC/1D2OQYiwxNSNNPq852HjCfA1O1bKusq3ff4xg0r5nxG2xP4PuZKj+Ua288ImEBZqKTyMKIea7TW6r098FETwOYtj5A9ZWmEQYIliuuNi2ByQRL9Jt2zgThEAxZ8sefIu8QYIo1yy7isnIce104xb8Bc9VPrsmm93bgWHCgfU9mHNFr42zZE+UB7ScYw/rm2n4IVpZOUGE41ruPEpPmgXbDUvJhgC0eSpQRto+EceqcOhK8pPx9bj1buqhpUrHbxKHk/y/se3gN9NpDs1lTV1lFdTzoNpNLRwCknJ5XH9dTrwZIITJ7y4sH7ZLpJkPSXLlYzlfVLhT5da4sA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 1:58=E2=80=AFAM Breno Leitao <leitao@debian.org> wr=
ote:
>
> Consolidate the repeated spin_lock/set_bit/clear_bit pattern in
> anon_enabled_store() into a new change_anon_orders() helper that
> loops over an orders[] array, setting the bit for the selected mode
> and clearing the others.
>
> Introduce enum anon_enabled_mode and anon_enabled_mode_strings[]
> for the per-order anon THP setting.
>
> Use sysfs_match_string() with the anon_enabled_mode_strings[] table
> to replace the if/else chain of sysfs_streq() calls.
>
> The helper uses test_and_set_bit()/test_and_clear_bit() to track
> whether the state actually changed, so start_stop_khugepaged() is
> only called when needed. When the mode is unchanged,
> set_recommended_min_free_kbytes() is called directly to preserve
> the watermark recalculation behavior of the original code.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  mm/huge_memory.c | 84 +++++++++++++++++++++++++++++++++++---------------=
------
>  1 file changed, 52 insertions(+), 32 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 8e2746ea74adf..e19dda5aaf195 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -316,6 +316,20 @@ static ssize_t enabled_show(struct kobject *kobj,
>         return sysfs_emit(buf, "%s\n", output);
>  }
>
> +enum anon_enabled_mode {
> +       ANON_ENABLED_ALWAYS     =3D 0,
> +       ANON_ENABLED_MADVISE    =3D 1,
> +       ANON_ENABLED_INHERIT    =3D 2,
> +       ANON_ENABLED_NEVER      =3D 3,
> +};
> +
> +static const char * const anon_enabled_mode_strings[] =3D {
> +       [ANON_ENABLED_ALWAYS]   =3D "always",
> +       [ANON_ENABLED_MADVISE]  =3D "madvise",
> +       [ANON_ENABLED_INHERIT]  =3D "inherit",
> +       [ANON_ENABLED_NEVER]    =3D "never",
> +};

Do we really need anon_enabled_mode here? Would it be ok
to just use ...

static const char * const anon_enabled_mode_strings[] =3D {
       "always", "madvise", "inherit", "never",
};

Nobody else cares about the values like ANON_ENABLED_ALWAYS
except the sysfs interface, right? Maybe we don't need to
force people to understand the enum.

> +
>  static ssize_t enabled_store(struct kobject *kobj,
>                              struct kobj_attribute *attr,
>                              const char *buf, size_t count)
> @@ -515,48 +529,54 @@ static ssize_t anon_enabled_show(struct kobject *ko=
bj,
>         return sysfs_emit(buf, "%s\n", output);
>  }
>
> +static bool set_anon_enabled_mode(int order, enum anon_enabled_mode mode=
)
> +{
> +       static unsigned long *enabled_orders[] =3D {
> +               &huge_anon_orders_always,
> +               &huge_anon_orders_madvise,
> +               &huge_anon_orders_inherit,
> +       };

Is there a reason enabled_orders needs to be static?
Could it instead be allocated on the stack?

Thanks
Barry

