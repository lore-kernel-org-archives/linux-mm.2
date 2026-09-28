Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE32FC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 06:06:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC1F66B008C; Mon, 28 Sep 2026 02:06:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E99BD6B0092; Mon, 28 Sep 2026 02:06:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB0046B0093; Mon, 28 Sep 2026 02:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC78F6B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:06:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DF44C0B4A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:06:36 +0000 (UTC)
X-FDA: 85262136792.03.8074763
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 85809100003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:06:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HiR35QFN;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790575594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXLr7+E4dU595JxZiGB+0CgQXdpJyxw7uq7+O1c8tt4=;
	b=4ypw0I2e1DnjX6kLpyPcZCysmdKQNjHIj9tG6UmtHK6dXEwdU1C+IQYYcgPLFDFmzcgmov
	sewjqutKCRyVN+baKgtaIAeAZwjswUSDXu16Nj/tXUMg7qSXESn0YyU5g6c1cNv5/KGO7l
	fPqqtMXWcoRZ7tkI6jLn4dB1eov11H0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HiR35QFN;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790575594;
	b=WgkFS2MEj2TeiZFoX6EWxet/nuPfkXpAdn02DWV12Ba00Kr9fPLPckW+a97R2pBSLITU0U
	tkH8N8Ig8pQvsPKqhfErlcgfT4ZjEwR81EpTNiY4PxRQyKbUgQ79QV+MUFuik5BgzgwCwa
	fp2ua/OD1NUSYHmRtqQytA92jIjiCb4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BB78644507
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38501F0089A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790575593;
	bh=OXLr7+E4dU595JxZiGB+0CgQXdpJyxw7uq7+O1c8tt4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HiR35QFN0blJ+lqS0ryibvdb3UA3/66y2mi0XvdHonRkFRVixY424DYqL6jsx0sU5
	 oLm5/OrJHH8MSRVDcnBgXsBuOF/sa3Y1hUrkdBF9C/TLWWNSgTImW8UU8LMRIV2afm
	 iWBjfDCBiR+57g/+Rb4f+65orIIof/vsgovDklFDi2M7jXwwh69P5lJEvHd6UbP/Pk
	 gyE95sGMBTqENHqDXvvF8tGBKt/FebhhAtMd+wPRubcb35BMw4nKU+nlJym9OTpnRc
	 n6+HTV8MU29JclWki7JchesXxz/gAWgcx/fRBj7rXF7hfT6ktwgsU3XOsdv6jM8GCI
	 9rLbMToctc89g==
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c2dc50c6edfso110533666b.1
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 23:06:33 -0700 (PDT)
X-Gm-Message-State: AFq9FYL1iM4pwmTWbqnK92v8R8KrBZiGC5AwpFtY3m4vI8TTlyr4Zw1i
	HTD589q/NocsDYqrhRYLowxZXvO9zRV/g7g2KFPX4fBqHZG3LFQyxmZoA4++sr+ILli4xGOyc7/
	/I/GK0QhasieWr3IbYKYcvCcNiZ2oUrR8OY5KI4T7TQ==
X-Received: by 2002:a17:907:6091:b0:c29:f5d5:5aa6 with SMTP id
 a640c23a62f3a-c2ac24d0b7amr982485266b.48.1790575592442; Sun, 27 Sep 2026
 23:06:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <20260916101929.149106-12-hebaoquan@kylinos.cn>
In-Reply-To: <20260916101929.149106-12-hebaoquan@kylinos.cn>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 20:06:20 -1000
X-Gmail-Original-Message-ID: <CACePvbWx1F6Lyr9EtUpfrfQUO7zqG_6mW2PNEXNXrDgwjr-vUA@mail.gmail.com>
X-Gm-Features: AclHuK_qTxqlktk7LrMSAhuqzolmpbDtpL9nH79YNkCpgy3Im6cg3WLSZOD5r5g
Message-ID: <CACePvbWx1F6Lyr9EtUpfrfQUO7zqG_6mW2PNEXNXrDgwjr-vUA@mail.gmail.com>
Subject: Re: [PATCH v3 11/14] mm, swap: require zswap for xswap devices
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 85809100003
X-Stat-Signature: mc64tgo7kyra8qjsw9xc1sa44m8pnyzu
X-HE-Tag: 1790575594-730272
X-HE-Meta: U2FsdGVkX1/qUNokCr3xcFvYsro5Scf+47+u4bJiVVqDJDfVaPNkMN5Nsh8Ft7ZnYQLkWjqQM4yjOG8OJWQ+3JHewO5NyXFEtpIB/byIcp/OQLFBvieDbl6WTpbDbxOl8Pcx6OUey2S0QnzjEeZe1BSOPmL94Xz/qQzHOlFkydLgc8FD8+0X5iA2ibzO8lYDCg8iRYVjHt52aCGwbEstAd6xibvaap10nnf9Jg+MiVmnra3GsioOTFMslkRRQVG7Q/1EFnIHfnFZYTGaOnZTMDtJeRT8US8LDIn9EkOSecGCmi5RHY8oSUh5PfAaBRNsaoYyyEeyPZ/glo8Ql6BcF7Zz62MYXYcDU90fHpa151PUSSivvAp1C4OaTMscpHe9/4LOKH1QGDDVYExiJ9BG7wYk/5XnSwLZaLUmII6zAU7JOTtLQyTb9g9GI9cMEhjG87kzeFzTE2frimnYZHjlLedMRm/vlvH5MopWz8O+eScQkqAy/Om7c8jYMT1TbjlEjdcMosZEaEhsfg39Jmq5RArFa1JEoJx1Ylo2tV/edzgw5svZM5XKdBa4qfqw7Vh/Q1uNurm2jTdC/CxaF9GIqiIimBGleBPx9simPT1dv8Ijh1JVuWuTNElkSuUZpLzLTM6IP1d0YvLVVjmozLqvjYzMxKOT7UwfmvdoWO05V7bE3DlNzOTlmhBh/bckDyMrPjEe47FYVdXYbspcN4e34xs/xxDb212cMidNG3erKTrxXWEw/66ZuZ/wKSSrmHnqPsZozMBLZkm8677Wd8NCaAj1x7Op57nUOO45TnDeaoElZwCYY7BGJW9mrbsBSk1Ke/e6HyLx22zT6NVcm5+rz4qSEkMI4s1NkA5Th4aywOw3YvW2MrZhCZntHts5UwDc18L5BwUQ/l5rJeiks4wf9Ouul4ACFhBJqDZI0Ijc7YdEnii+S7HfJ/t4sFWhOBBDotslhwsYaTOejSlNSJM
 wuIxevVW
 o8a6d5TzfO848ShgtbwRrVYjij2A+dyfzhBcUjXq0zpS43EkfAjC1Ev3w9yM5tC4+tEVM1OGwpUNRCSJpv3l+D45Bht43zSphIbJswAF3OaG/5oc2/ORx0x9slJ8MG01BqXozq/C8Bp8keU4X/uTWGcMLlJm3LO6v5KVQM8z29Y6diws/a3LNSPlW8WpdA27ypWQDbLkT4U7OauU3aPXxn9cD5rag1Z2YwsE/4bHPu1rRAv7AvOPqm52KdfYvNfTdvcV0dGwdGhpTFfKGHTWwi0LAmyC11wltN9GCm4XxHJzzQMQmgxVmgmb1RrJRm8Jk9N6b9rJ4qYTFZqeOZwJrbqxYAGxkEZ617tqFkByg5pM3Gq8DyL1e3+NxSNi/mtJ3a8vz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 12:21=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> =
wrote:
>
> xswap pages live only in zswap. Without zswap, swapout cannot free the pa=
ge,
> but still takes a swap entry. So the device consumes swap entries without
> freeing memory. Fail to create a device when zswap is unavailable.
>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  mm/swapfile.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index cdcbcbaa6d87..cac084bc72d6 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -4439,6 +4439,10 @@ static int xswap_create(int prio)
>         if (prio !=3D DEF_SWAP_PRIO && (prio < 0 || prio > SWAP_FLAG_PRIO=
_MASK))
>                 return -EINVAL;
>
> +       /* xswap has no backing store, it relies on zswap. */
> +       if (!zswap_is_enabled())
> +               return -EOPNOTSUPP;
> +
>         si =3D alloc_swap_info();
>         if (IS_ERR(si))
>                 return PTR_ERR(si);
> --
> 2.54.0
>

