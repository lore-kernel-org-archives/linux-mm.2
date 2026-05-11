Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31FF0CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99A816B00A3; Mon, 11 May 2026 10:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94B3D6B00A6; Mon, 11 May 2026 10:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8618D6B00B8; Mon, 11 May 2026 10:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 71F996B00A3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:39:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 41581140179
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:39:16 +0000 (UTC)
X-FDA: 84755396712.28.DCF4E64
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4AC2B20016
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:39:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KanksSou;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778510354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8MDXsAwYMM6FNhX8YA3zN6u5oeHiyH4nfmw0MtEAJ8=;
	b=x0Bwv9x6dQRUARAupdcESYOBYDGABNbI9Q/d8zBOSo/cl2HCttZgATYiaASQth8lLygzWG
	jSyNfWzs51uj2RO8+ET86yJlWbutxSZrio2XMX9hkspEoogQZ7JqAZ9BwyX3wVbr2tVVcY
	CD1iSiB5pZU7yljMncN7NH6tQTGkcAI=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KanksSou;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778510354; a=rsa-sha256;
	cv=pass;
	b=FquT7AHWdASXxscGfX+ULVLi8LiswdfKCJpeAu+DOtpPL4i3dDm823foE16gaV5p+cX8J9
	32Ju2sjU7fSaohIKUj3QuLXElcfFGXUmmBNzBUQlxs9WSkNwI7RJYPPZQeR/n6Ugpu2VcD
	KI8TkqDyYMTLVAkOZo5a8qACxVciqvg=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b9358bc9c50so692149166b.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 07:39:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778510353; cv=none;
        d=google.com; s=arc-20240605;
        b=eRuB+ioZW72Fh2eGr28HXh0XhWbQLCWzDj+AV2qufhXm6fIsxW2ECBuKl6eGDThfzG
         ncIpxXe66Yz9uOhwMVVwRZauDH2HZiIeOzuvxd6JVy0aYIlutRdG45OSIQeH3A8tp2yP
         qNiZDYtwDBQ4bxSw7y/OUddCrBbO5En6+bWNu5EwMQ4b/mFfe7bK8X7/YOZ6vijG5Ysy
         Qcigk0++4t8Ubvmo3JFQi/uI5Uqq/Kx5W9A8EkxK86lAp6yPlTZME8dnuKum3m/0iZE4
         ovNlXG0OVhKOT47BMf9djUmsYryF5tliDc1t10TVrSImBczpwcwDFGBRcGH5UuP+semL
         0AIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O8MDXsAwYMM6FNhX8YA3zN6u5oeHiyH4nfmw0MtEAJ8=;
        fh=YETrPt8XR3oHlUlnSXkPtCN072oz0e9BDfXU7IGYq1U=;
        b=FwrAUqAZdOBuODa04yWWs8KTwIUdGH+HD8AEFETDGbzbZxYYuRNxvYjSq31CoFmUt5
         pIVosoIUmCPDnCncLOKesb6bJPX7qVNF5WCUzPOeEVRZtCCq0Q/4SMMzO+/E6FY+zUFe
         Sd5yQygYpfoftp5tFWUfyr85gcu6VImxxxv2tFy1w71vhS6L+Ojbkq2BEs7eSbMJ8xaJ
         F9grdb72xZQTpva2wpmtiFXwi1B7rzePifUrXHKqAKo7BpUJnJXqUYOeavvEO/tjls/k
         9lHW7n0lMRRvFKvo5DvXbSVqFhc0fxrfPKke/pmg8DKsrPG0Gm2FojBbi2QryOw93BXw
         5OpA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778510353; x=1779115153; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O8MDXsAwYMM6FNhX8YA3zN6u5oeHiyH4nfmw0MtEAJ8=;
        b=KanksSouRyzqpL3hCupJOe7GUHkNXlQDNYB6lX5Gxp+L3p8hSGmEjL9/clHAJe2UAs
         JHBcaU0mGiivfSPQZGmuVcoHvZnN1bvcpB2KI0wLpBnJqy4saoavMQFdQ54PEtlYLmtX
         1hrJirRSMcpQKAq772RPJWcB5hjmwdVT0WlOLxBKdhmvsoWjuNUJcp5brUC+JCxWfA/K
         OwFrxOcz6CfVvN5aLGBdx3kwBtno0uf2Zs3Q9qICAnBnutYn1j4a6rQl2j4Nav0pNNPj
         EZ2uWCpkA4MDA0rTgNHTrSQx1UZTUqqSwbb3L6HxgL+cIChObNJmRPBECPhI3ZjfLw+T
         MxUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778510353; x=1779115153;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O8MDXsAwYMM6FNhX8YA3zN6u5oeHiyH4nfmw0MtEAJ8=;
        b=ZgapsARBZGX8uEA3x08ubKvtJR7fdSgKGsS8zvG/+05GfKUwNrG7DijqS7PJyQpvKU
         v34pRh/KSJ76MSLdhhpgzRPqomwanOLu2JppuD09So2CMp/SjudEb4B+5eFxgDJMxAn/
         722Sz7zOPBfqbYfJN6HHpvhiVoqk++fnS9OWrPWq/iHrG7dJMF2/P09bDAsdlAqZmZii
         p3OcmZDngK/PRMH8eVrILrqo4vihJmAgzcguXPAEqtSA5pxZrzIqWJd1Cx0615DX8vYW
         tMl9vgPJN7XAY/6WxtrLcG0VCgzAHzZbTYoM+JnPABPCeuD0vkz5CCmLD6KFW4QSRJDv
         HE4A==
X-Gm-Message-State: AOJu0YyS4/xViWA4C5cjLVGo/2Gl3BRhvnJVSqIi+7jfbP9uKJz6pQta
	mPLkp5EKvP3FmMm1r3quR1T7KFmo/XAiZk1rmjna5By/Kay35k8yhZb/LBFb7EW2u6+gTuFoNfI
	k5XAFt5lvHcuxNGJr+huonmcjrTI4KyU=
X-Gm-Gg: Acq92OHEEoVJRDhMa17UBS76lBgE8gWXvN/VrWn613S1qKUPIuepeVyz12/19OTSh6L
	WP8t62P6V7Tdz8Lv9IaJyiHgC2uUNMl1xI6VWsLN9xvF95UGsPJFTGaGcaYFnplEN0a5fOIhX3i
	KLIWBin1/Goh7yJRQPOxM9nEBTWqhB//h69DPvU9/ibh2SRQzd83uNhomFdzDpOyWCKgPn0Csxh
	tiPcQpg8ZjIxy4TPsnEF7B271/SkgYl33qBF+Dyaf0IB6cODo8aa6lnQ8xOgf3DreepauZAUp/i
	pOEsyBr/CP/roG+UcFjCVdNHumJ77dWgTuUuFeZI1NkVFVf+Y5Q=
X-Received: by 2002:a17:907:970d:b0:bcf:1d87:11be with SMTP id
 a640c23a62f3a-bcf1d871b7dmr330424466b.19.1778510352360; Mon, 11 May 2026
 07:39:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260511073334.635682-1-baoquan.he@linux.dev> <20260511073334.635682-3-baoquan.he@linux.dev>
 <CAMgjq7Bts08uH8Bvnhx-dbJiwPtRvXov3q-d5VtmJyEQOXqVcw@mail.gmail.com> <agHIvLIzh5Ce8LFG@MiWiFi-R3L-srv>
In-Reply-To: <agHIvLIzh5Ce8LFG@MiWiFi-R3L-srv>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 11 May 2026 22:38:35 +0800
X-Gm-Features: AVHnY4Le7veSfx7iLDaYxx9UTLgSR0eA9DdaaLATp5haUYmKBQIq0Gke_1f2jQ8
Message-ID: <CAMgjq7AX2UxujdntaCkWp26k12DuGnwWp1w5bJDaY4SHAdYKcg@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] mm/swap: use swap_ops to register swap device's methods
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, usama.arif@linux.dev, 
	chrisl@kernel.org, baohua@kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4AC2B20016
X-Rspam-User: 
X-Stat-Signature: qik9o8e9tdnbx11gaa45dfrgjhw8wzks
X-HE-Tag: 1778510354-867455
X-HE-Meta: U2FsdGVkX18n42azMgI7kYlxNnPnzTJLna33QARSISGNCoh1GF1qKpPRdDYyErfMQj1lpZHXTNuKv/WMU/PX7rhGlS8pZTYD7TU4O007RCDipHgF5dJ23H56U52ITUJKCeb4PKqhwB9MqOa9I1mXAY024gP9UnPzb4YFUUptcQ3K4HPEBb09yWQORmmZky2bd0g12fAVgqI05dnGbzakMVmHeqtEibQLFbvrRTrna/6n9s3h32DaMXMUndJl7reA8UDG1EO5xSV7O+GjcAHxr1IHoZG9kZWVQqEQLEA+L5+DOvy07THDapLOxewr0WO8722GfteFGgoI1FUCeTReTRTBCp/X/C9AeANd8qLaFq4Hs2uXymvUqqs+xGscPwws6j+8WP+re7DrZQ4LA8QanPV0lIdG5NUwcKWl3Tc1L7EmpaWMhum6XOHVk0RN46y/qT9syFHkqrYWqGgVu4lXsQGVst0pM+n8vwbGSjcnPhlilfJ0iB1QrtBR1lbsSQDzCqNu/ZbxgT1kPh/3b/WaxlZrvnAW1bg6d3rMvy/stQ5Ke1Se9/dqhaBbf5Z2wVhv0MXexvrTPPXYcEK6DSP9xAjyV0c2a7ywr9xYnCvHltZ7Sq/0rDvzh0INTbHDRDBmuMcNyZgh4Yhz/5Rx7tM72s2BkHh3SgPwuZ2/sI4OCNpQVNmN0o/hNuT2G1g56ZMuBAHlnISvjzY3JIp8QgWLM2r5bBhfAvVasdSjL6k7bt9oAcksrD+F+TUC693zYKeQxdZ2W6mQ78lT/J41AxYVGiGIx9zC7ezCqCYaP3BtU0yZLuiSkZjomKW2K1bYxYJorC/6MWu81g5eaFdRvcnF29dvZlQf9rAU/atNWqR49GYYHyAVFvTLyhSGOLm5N9keUGN+UxNQGEH3GlLObYAtLNlxLMV2Xj66OsqfAa4iopj/7VZ0XVZFF1xN/fmieTYV24Nn113iKR1JC9r6KJ9
 gEygdiDX
 j1Flo4NG7UMViZFqX8OYT3TCo3LUNcQ2NUOlhAaAs/tWtdAwx92B/k53FkoiEXq7KXvCLiAlkuYsMKJx1iZXHuAK2EOvtx80CMTiscLBp/PQfpOO4FZ32EtLh3LW1l/relnRkYFl1QeaEG1tzX1Ehg8n7YH54/yGYUDMfAvpjcvlyln9TCiYa75Lt0cUrA2SXv4m3Ki8b7gd5uXydEB4xdQ2/jsVVKzC3Fiwm97p+E+A9lrdgj0YCFO8TABgntUmBe5jrNVuQz6OPya/4+ZNTqvgtyxQKIHsmlkPgU+Eh/vObChJaka86Z9CUvjDdkzUzVIKATCKo1PyuooEn9h2tb2SrtaVnmuHUbcAeAOUxewm2u2u/FNQJ3SxLWEfatzfJInEeixRnaXlN4dDj0BhIu4gsFR/914xNxo5mJlGN97tZMo6Nh414S0AnhNM2dnQqcpfEGSCzxwLcmqBKu5ZZwgkGivvIR8Nwb1ia+Ibf8qZMI0zk8Sij5GDWly8nHD6osVHUcVLjOpbGYIKfS+sKaGUQdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 8:17=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> w=
rote:
> Speaking of comments, do you think below sentences are OK to you?
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 82d2c9b35b11..8012e5e334f9 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3518,10 +3518,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, speci=
alfile, int, swap_flags)
>                 goto bad_swap_unlock_inode;
>         }
>
> -       error =3D init_swap_ops(si);
> -       if (error)
> -               goto bad_swap_unlock_inode;
> -
>         si->max =3D maxpages;
>         si->pages =3D maxpages - 1;
>         nr_extents =3D setup_swap_extents(si, swap_file, &span);
> @@ -3616,6 +3612,15 @@ SYSCALL_DEFINE2(swapon, const char __user *, speci=
alfile, int, swap_flags)
>                 goto free_swap_zswap;
>         }
>
> +       /*
> +        * init_swap_ops() sets si->ops based on flags. It does not need
> +        * swapon_mutex, and must complete before enable_swap_info()
> +        * exposes the device.
> +        */
> +       error =3D init_swap_ops(si);
> +       if (error)
> +               goto bad_swap_unlock_inode;
> +

Right, LGTM!
>         mutex_lock(&swapon_mutex);
>         prio =3D DEF_SWAP_PRIO;
>         if (swap_flags & SWAP_FLAG_PREFER)

