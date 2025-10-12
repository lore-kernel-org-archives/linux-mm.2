Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EE16CCD187
	for <linux-mm@archiver.kernel.org>; Sun, 12 Oct 2025 20:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E8228E0005; Sun, 12 Oct 2025 16:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 398F68E0002; Sun, 12 Oct 2025 16:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 287908E0005; Sun, 12 Oct 2025 16:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1277B8E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 16:41:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 16BFE1DDC17
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 20:41:09 +0000 (UTC)
X-FDA: 83990631858.04.B3F7DBB
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4ED17A0007
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 20:41:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WZVzV9Pf;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760301667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fQHJ8QLx2geHeW6ZIJDpG39/R8n6Xfkfv+hR5rBK1gk=;
	b=vl2aVxlZzKVr87WMeSgkCcFHkCnnnLiSXsQLOeNtTM2CQBxElNiJ8bVBwS2aOdv2o7WJYt
	O3hXLRUG1EBTgpEImCTbLe4u26hZOZkEW0cQqbft1WCCSlbTJ1fxl0euE6tfVlcZwuzbiy
	WIpNhRI8uqmMIScK9aFowwm99yUg5Cc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WZVzV9Pf;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760301667; a=rsa-sha256;
	cv=none;
	b=3eRM2WsC1ioh/JLuMzrwgM5hJvX6w+fp4Ez+YhT9fq3SJWR+GlfM4V9iS5gnuqp5O8E0xN
	snBHee0UmJVQGwfZVNlCbIT5a0JmAG1S/O/nFHGWvLVkTo+hbrkp8FmPLp+2UOXETTxxs1
	L+R9iBP0E1sh0NOieJgrSTqPQSbACac=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-87bb66dd224so42968346d6.3
        for <linux-mm@kvack.org>; Sun, 12 Oct 2025 13:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760301666; x=1760906466; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQHJ8QLx2geHeW6ZIJDpG39/R8n6Xfkfv+hR5rBK1gk=;
        b=WZVzV9PfG49LPiSUs0c6WgW7FAVKIjtitG15In58Z4gG5/Smqi1+bszJnsw0sqqj/u
         0xgOTElWL4r0bl9KGhLyPfOgKADNWINs7RUVXygkrJ9EcHHDjV3L4+ORbYBFI7YfnZg2
         pOXMb32vegWZQeQXPbDkm5yIfCE5+gz2mcvkWo3aRIbeV4Ni2rwScSEAZEu2Hq8rB6Nl
         Qt+PUuIIBB1xMdjeR5ki1DCOlaYudkCo+RdlyTr337PBkcU4A8BN2NxZ2KO113L0vYYF
         WRUTFz+C6ADdFS8WSIg19e8TIx1uTahRK1H7Bkczo8l/iVxwpCFHxdLWK38IFzgksqUk
         mWfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760301666; x=1760906466;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fQHJ8QLx2geHeW6ZIJDpG39/R8n6Xfkfv+hR5rBK1gk=;
        b=RoP3Nt8+o3OueaT9R6QPIEeC4XFszKEySoouQ5hsO05XxJ/WFsZL/AkbJzuPDQSGtm
         NGz9P9bQ13IG7GjD3upKKQRszVh19qUYM5Tx9lqwxDV3eTRpOyGn44pkRSfVn1bpzhzl
         EjISuu2IFk03AK4XsZsfgt9ZWaJ7aqdsVrWpvUJJLpEGbJ0lmBpARrpPvP1GndVXZhhw
         /19osNy2/iueDZBeFS2yX+yysoDyle8Y3ifiwAOtpBDe2TCz0Jl7s4Ao7iecyWq18Bjj
         ihGRobUVaOjI9yImqUJ1zrFSHJ5J8ZJ0cnYlBFqJL3zqEVHLFMQmJ0ChOygiB/ztT7wa
         5DRA==
X-Gm-Message-State: AOJu0YzobOpTyYdiFUyqYkQPddkOQ8yTgSptQYoddBn/zmaH83bkubic
	FkQfHH3NzeCFXaoL5LkcSgEoZX8+XjBE1NC6iMe3BgOFADfcnjue526RtAfP02/ngRnohzpza4p
	dEw0eI2qrraVjTSz1/nU9WfG7tYl+XKs=
X-Gm-Gg: ASbGncs075UiFwDwrgB+7yTh4YOW4hwLOmKVnJUnb0eIHLJ84Fb1J+Ct/WZhNZWao73
	quw3KgjYm5ePIHSVF+0EHDcxw/UmmmZSYMSJum34ckEcJwAZMLkCR5Pp4Q8f2om0Ki+bXeh6vR5
	3FrKrW32AA/GuANtKFtBNbshd4D+lmJ2tubds8VPhYxMquxwn6rjC4P+q/c6zSXdQjLkFBzdXsP
	QR+YfVtGti7/oljhzAkaGljYsRPDGwp/2h2xnr9runAr9CVDUwNJJrVKw==
X-Google-Smtp-Source: AGHT+IHABqgGwKiLbXi36FhtQ71YDJ+WKfQmCPBQ/yUQMsJ0jZDgpBJAuwgrwuU6/ddPjyXXVcN39doQ9pCA+vjHSk8=
X-Received: by 2002:a05:6214:2629:b0:7a1:6f84:88fd with SMTP id
 6a1803df08f44-87b2ef92e38mr313434226d6.45.1760301666155; Sun, 12 Oct 2025
 13:41:06 -0700 (PDT)
MIME-Version: 1.0
References: <20251011081624.224202-1-bhe@redhat.com> <20251011081624.224202-3-bhe@redhat.com>
In-Reply-To: <20251011081624.224202-3-bhe@redhat.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 13 Oct 2025 04:40:54 +0800
X-Gm-Features: AS18NWDMFFIfVuRNn3FKOPIbqxi90GD7_EunJ-Z8Wurap9DCZm2jWlGrRyASNgk
Message-ID: <CAGsJ_4y4CLu7qeHijhJtL+NDrehfiWpu9mtsVGxmn5rBy03v0w@mail.gmail.com>
Subject: Re: [PATCH v4 mm-new 2/2] mm/swap: select swap device with default
 priority round robin
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, youngjun.park@lge.com, aaron.lu@intel.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4ED17A0007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: gytn5bmo19ie1e4czqytg817zhkrbqsg
X-HE-Tag: 1760301667-421703
X-HE-Meta: U2FsdGVkX19aswD6cGA109CWS3toqt/3FPiu9dohA2wgjdc2UCEsmdzRxsYtNDhagQ0FStCqEHHN6/xALnpO/fvmH6c7fbMi3yyO1BMtETlROVJMaVTifo1/xkx8N07KZy1TSLgCU8r2bGlFpEthl6PDaCSErcTa4EB3XI2io6wu+zLnBynrcFVzIVNVhZhXFKDSAJ7pcEo4gbgF+2bZ1lcZOhoecOdK5gufXfregvoxkn6K3rxJlG/zI8FyBwGjH9pDohMjfCuPFc4M5RV8uHI8DJHx0zDrr0oVACo9jHgIfSbSJVpWM77v9SQ3+2CLbHDKtBrquXpvTB+8u0cRMpdvnX/yv3ixxPevFLKAGxMUceKrWsFfEx0FJ8otZlsgGdlMrHijTVyjrnVSqccP1I60N8WbsnemrmR1oJWdQL5Kx2svYroiX+8bzUST8QegSMHcISasZaqyVtxOC/4xBTjWVG4PgXU4rF0nTuZ7yn/3oPxyqWhK/XPFBg3/5tKThcsck9JQWAJ5OHeiJmtWdYY+4ow8vk06Lb4bemMSrblOEnZ0WndcoqYZ2VzGr0saJ76DM6NIzcUFfvFlSeRpI8I4wZISAp2qpqlaAiVUGTkc+ZkrXII5ikocvqNy5DhCOQZ4y+90VVS9VqPtnf+7kPgdGVI5x62UwFCNVHRVcRBTHsu0pkNqmLCW3B5Bt1HxRNZ5USbJhLndB2HB/d8aAAoYMY83td07VdlAljLMZ38+hAA653lQsNylY/FoR5mYMFbn9DRr9jsL7hI1pDTOdc2akUg0PQgQZE/5MDPxihSOIHLSfhBvDVU8o21fZsWL2sLlCSTIA6tLtOZqom8PbLBsuZKFhpNGrpeoXf9XmKjT1oD08iDasy8zQ5wz9TVhqjJ2cbiAo+lVrYnEEGwuVE6ZUl/pq3YgavPdnjT6sA3jwyx2RyuBSoYm+fza9X9nUVWdzsU5aSDUyYqfSsZ
 7JAU74p+
 hJ9ceMjRnhYbM91y5MQ4tXgQWvSYVexNqGhGhkw5/+wDpIoCdYvLJp/Tx0Py2yElbZ/aGz9iCAW0pz2j5L+BscDpqQtX98NX79S+rVWlZegBAlBKW43MJhyj/eg+nZnq0tV4VXW8l4cHve7hggUB3KE3c0B1BWTBHFSaV1Sk4CCCfqyEE6xNGFLi/PS4qK6S1W+KMkDcLsowTuxv3cTqujAYwZbDvGGewp1NyoIq5sGpXIY4Eehfedx37++ro/MqKI54kRSToWzFmAJPlOtk3zFirOK3VVEHgxH1W7TDLjkrorSThUdPuNtpV0Ff7oGVuDSlH2nALPsV8cm0a4UPoR+hS0f3KmtXtFzKE6IMjFGQuguYhWz5cHEIe7/jx0MwQFD9p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 12, 2025 at 5:14=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> Swap devices are assumed to have similar accessing speed if no priority
> is specified when swapon. It's unfair and doesn't make sense just because
> one swap device is swapped on firstly, its priority will be higher than
> the one swapped on later.
>
> Here, set all swap devicess to have priority '-1' by default. With this
> change, swap device with default priority will be selected round robin
> when swapping out. This can improve the swapping efficiency a lot among
> multiple swap devices with default priority.
>
> Below are swapon output during processes high pressure vm-scability test
> is being taken:
>
> 1) This is pre-commit a2468cc9bfdf, swap device is selectd one by one by
>    priority from high to low when one swap device is exhausted:
> ------------------------------------
> [root@hp-dl385g10-03 ~]# swapon
> NAME       TYPE      SIZE   USED PRIO
> /dev/zram0 partition  16G    16G   -1
> /dev/zram1 partition  16G 966.2M   -2
> /dev/zram2 partition  16G     0B   -3
> /dev/zram3 partition  16G     0B   -4
>
> 2) This is behaviour with commit a2468cc9bfdf, on node, swap device
>    sharing the same node id is selected firstly until exhausted; while
>    on node no swap device sharing the node id it selects the one with
>    highest priority until exhaustd:
> ------------------------------------
> [root@hp-dl385g10-03 ~]# swapon
> NAME       TYPE      SIZE  USED PRIO
> /dev/zram0 partition  16G 15.7G   -2
> /dev/zram1 partition  16G  3.4G   -3
> /dev/zram2 partition  16G  3.4G   -4
> /dev/zram3 partition  16G  2.6G   -5
>
> 3) After this patch applied, swap devices with default priority are selec=
td
>    round robin:
> ------------------------------------
> [root@hp-dl385g10-03 block]# swapon
> NAME       TYPE      SIZE USED PRIO
> /dev/zram0 partition  16G 6.6G   -1
> /dev/zram1 partition  16G 6.6G   -1
> /dev/zram2 partition  16G 6.6G   -1
> /dev/zram3 partition  16G 6.6G   -1
>
> With the change, we can see about 18% efficiency promotion relative to
> node based way as below. (Surely, the pre-commit a2468cc9bfdf way is
> the worst.)
>

I=E2=80=99m not against the behavior change; but the swapon man page says:
"
       Each swap area has a priority, either high or low.  The default
       priority is low.  Within the low-priority areas, newer areas are
       even lower priority than older areas.
"
So my question is whether users still assume that newly added swap areas
get a lower priority than the older ones?

I assume the priority decrement isn=E2=80=99t a stable ABI, so this change =
won=E2=80=99t
break userspace?

Or if someone sets up Linux assuming that a newer swap file will only be
used after the older one is full, then this change would break those cases?

Thanks
Barry

