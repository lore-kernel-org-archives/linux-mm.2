Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE74AC624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 02:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C70C16B00DA; Wed,  2 Sep 2026 22:32:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C21EF6B00DB; Wed,  2 Sep 2026 22:32:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37466B00DC; Wed,  2 Sep 2026 22:32:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CF6C6B00DA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:32:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2755B1A03E0
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:32:02 +0000 (UTC)
X-FDA: 85170876084.26.2F9CD13
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id 683A614000B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:32:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dW0snr29;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of hughd@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788402720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SZ9VwK4M9RrXiYAkL+dI7dyHkhFNxu+nw3mnW/q/dvk=;
	b=GRBQreKL4zgMt4VurweeY/wxa7XXSecET2xHb/My/NYVAANCbwNqiJAvl7WEURjjKb+fDi
	TNKcOFZrXFmz0O2U9Ls9LGecGldDCk2PgLrTSqi4eAVvSeCW1NRtc7O7Bg27/IHEQx5LCB
	gmCGp1TYnbgL8YfJrv9bwxtvayaavTk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788402720;
	b=cicAj3+FwV+zTbi1ohxE5fBbWfXu3NWp/+B+FQ9BojWaa4Isy36k/2u8dAj/wPb2ZlHiSn
	iFvlnCT1m4SRpQ3mOZwR47ob3dYo5AaJ8BBqKQppX1rRVvGT6E5aY38FQ9IkFJqg5gHxJy
	fkJhxYcazrruEvscEEMutb4gAn6QfmE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dW0snr29;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of hughd@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=hughd@google.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-836c8bdac50so22054007b3.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 19:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788402719; x=1789007519; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SZ9VwK4M9RrXiYAkL+dI7dyHkhFNxu+nw3mnW/q/dvk=;
        b=dW0snr29BN1Rgq9OPERqY9jFRHPbvBWD9PCnWD1+koNIhFkCIJLZoISuaJR6gMWK+3
         YwjcKjocqfY/LvLyaEeKAq3oM3khwr4ZarJ7xgApf7ylOfa13Wn7gUxy8K0naTUVn9Ni
         DOe8/Mgii307g99pLx08UcjO+4YKgsHvA0iYA9o1bGnTokK3F08WfsVjm9asJat2BBrB
         gagqovuEjmLpbZbqmR8nRpG8rVxSrdTuvze450bFyGuAoiGW88XUHu4arrf3aJLlarNw
         o3LH+JtZVfDj+X45YAOgS82QtCrAu4KJV66ICNVrTfRiavr07tqJxLpjI58uqtUG1AtB
         uNXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788402719; x=1789007519;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SZ9VwK4M9RrXiYAkL+dI7dyHkhFNxu+nw3mnW/q/dvk=;
        b=Ngdk7HgA9lCY2i/P+uunzaEpsS480KSw+auT5m8JzXBBs5yTcwzQzazDp2ujjZbVzf
         qXXehdWHjBakAeO8/OrNPivH05Q8JQPZtnY37KfsWn/LkRut06nrq8Q5SbwIYa9OkUnE
         ph25vs6zRPtSHcBwWghWj9j3itZ7w3ks7lsOx3SS0RXDrd/jpRm/SA2GRDOlsdbRQx+S
         Qgt4wsDhl/OXguHp06en0aoBY2G/fUUhGgdauckiTAA3JBNK3Ut7x/R87Lr4cgVyxJz6
         tY0e3ZsptE3CqVqjsGKv0FVSpmQoFP7AngUBIx8oQ/8c3DY4MCmPYcmKcIFgYZ0dzltY
         53wQ==
X-Forwarded-Encrypted: i=1; AKwUvBzaXg5hjI+wd+Y5NOT3EgAtE+qFjG0+LUVjz3CC3Zniql7HjQxBQcEA0XhskqRoV2RHW12C7zHVlg==@kvack.org
X-Gm-Message-State: AFuF++kcw3FL80L+P3JJxE+D1mjjhYZgoZ4e+rGTtW5aiVAAJ+GimkeT
	f5YnWaK0RENwf6U4zn8krWOLLu2e+9X+A7b0qejf4WHseJtEj0w5lINXN3DzrbeiHw==
X-Gm-Gg: AYBFou0I7SGxYthwYiQ1L8jTF0rbX7mxal1pKLEpytTw4YD6v/ZAZEC5FtnEj1Ku8xn
	LlDTuRqfAzbchqx/dYrKIYLGU/dpp5x9oovv71SjrzfXAG+p7zuR0f6V77LML+az+oQTzK2BTVD
	edjBotyb3g7TYqtchPV20ijtisMEytV2mXOF8fQtFv40UDPLiJQe1Cr3eWXRTdHUCiiHLkiUq5O
	ibSQereGVwn9KJdXGlV4sOJL20KYUZnJrL7srTYSstbwye4zZx8EoiDMcOFeIyjMln0nKsm9Dnh
	Fq349+2AcfUMxsA0vYFzO8qsBwcBJEUqkc6fQeZY7Mt94UzuE3bBNHShaAmytoFOHSeZMioX6rg
	f/6uBG524YZqy7vYb+Ece72feGjU9CMKrULVaHKS+bdXuBd6XHB3RqZHPG2dWD9XHtrwLQf16I+
	E50+z46wKk1Y4dyGcM4T3c6m4f/Wte6WkH8Io7Wa+D3F/3GIjfDEHhbdYRaVaaMf2kqiHG3nQrj
	6OMb2rgazAwCJh8aL49AP6PM5N5bKU+dQhSTCKkZ+d0RIC+
X-Received: by 2002:a05:690e:1689:b0:66e:65b1:6977 with SMTP id 956f58d0204a3-66f9b8f010cmr3430168d50.5.1788402718645;
        Wed, 02 Sep 2026 19:31:58 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66faa62c132sm753177d50.7.2026.09.02.19.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 19:31:57 -0700 (PDT)
Date: Wed, 2 Sep 2026 19:31:39 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Jan Kara <jack@suse.cz>
cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
    ocfs2-devel@lists.linux.dev, Joseph Qi <joseph.qi@linux.alibaba.com>, 
    Hugh Dickins <hughd@google.com>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: Re: [PATCH 2/2] shmem: Refuse to enable tmpfs format for another
 filesystem
In-Reply-To: <20260902133702.1313635-4-jack@suse.cz>
Message-ID: <5f7e2e81-6a79-3b5a-1dc2-83ce775017ac@google.com>
References: <20260902132458.23590-1-jack@suse.cz> <20260902133702.1313635-4-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 683A614000B
X-Stat-Signature: a6nrg14pgr8o7ra5m63mrridt3narrk9
X-Rspam-User: 
X-HE-Tag: 1788402720-753948
X-HE-Meta: U2FsdGVkX18rGNYbA6WALkr3dBpdGv9zb37hm7f39rvX1+ItqHrZlEU3eOFZedJmm+C2n7XGJuVSgA2ONgRJUmnX9g2f5a8L077nRilDRXK2Fb21fHtPBunZq/wUsGIMUqqHjN4VfKJEBewLpZbbkn0c7NSoCqA/TCClEzSbB2WyIbubQFGCa4l+w22AD1pU0Y6Xws9p2cS+PORq5upLQgJ+ZrJWtB+YXZj4KY45Lg+EY+xY2nasOaaH+2AkE0Ot2fEzeCt1dLZ7BNVCOH87bMtXIB/w8Wbsyg9k1ib587xfGYGRDNQi1pTc2oBpHeikOC2g0bF/AfDxGMI8ztaL7BtOuAJ4dp72IOLaDkxPnXhu3xFsWjPC6nFZb/bS46znlSWsRwl6D/vf3SP3tyef3lhHkkcsNMUsj1qUarSpkPuJD+UozOcWDtgHy7kExiS8xg1mRuD7EzgMujMDbf97M/wCrrc2bQzr6636iYtshim0ixXEZsOLNpbCGlKDA9XxQYxWeTr9A+9vPtEMeM1Answ6ndoS9fIJh7OF3s5SWq6yw9XOFTuXLYoiLwWpq7PMqwTjNSUwVEcQdiStdmAtJbmVN99dqjuWliYegotlFeQ6OQoufG0G2xJruFMqQf5hzIbHXpEsYMW0Q5B5Y9PM8Yg6nawXOMW4jP3LhIQN+BAgwITEEp9jt6pmCxOayB9doMJyyt+QRobgNyWymY4SZ7WCvA+/Xw3TJMgrsTtn8N5zmfu4mK+KXfq0pGXK+yY1HQhIX5nhy8oeueAidWuDohKDgU8KlEcZ9uwzkDbv6XJJDKiI4xeuh4s9OGXd58N5k3icX8MW/qUPGJVZoe9pN0QPMuUKqrow7UpCOwsTwyCsUIJQAea7T5usecNHW5xbe5PCK1wUN54Bb0urfAHkxlcl7vTDFv0a4wl16BFVo3YWlWXlslrBwJ+IilMumFKz8E6JNSwcE9uynGz3euA
 3D1CYoky
 HtICx7qyJihTRmrVVy94PdBevU57Cgvdh3q9TQwnYiz93bKP5XUhpt1iJTIX2uxhbUrWc2dIdKAnxYN9OTIvoAT+wm2/JyoyLheCG4/9sotAErFM7wbmBsjmlqtLJZaei0+DD71n4lbUV1a1KtptZYeRSgV7Vo8hCrSz+I7qrFfX8tjoN2rLj4BJZ+fOn4xzOF3yx/mLkf1PJcazU/ApCBrfXsG77YZD2B7OS/swInPmkwaiEPA5ZB018jfOhUh/9Q537Rcs42EigTsD1O/neo8jCgGiEREJ37JnbIK0TeKcEbGFryipxwBaVVgg3UitzxYJm58aai4P6Vbc4HGrtv4KRh6PKC/iV0kSxu5YKSk3werA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2 Sep 2026, Jan Kara wrote:

> It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
> requesting to enable quota using tmpfs quota format. With suitable
> passed arguments this can actually succeed in enabling tmpfs quota
> format on top of ext4 filesystem which leads to crashes later in
> dquot_acquire().  As tmpfs quota format is intended for tmpfs
> filesystems only, verify we are indeed enabling quotas there.
> 
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  mm/shmem_quota.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
> index d0b92d6da50f..6e0b43cbded3 100644
> --- a/mm/shmem_quota.c
> +++ b/mm/shmem_quota.c
> @@ -54,6 +54,10 @@ struct quota_id {
>  
>  static int shmem_check_quota_file(struct super_block *sb, int type)
>  {
> +	/* Verify enabling happens on tmpfs superblock */
> +	if (strcmp(sb->s_type->name, "tmpfs"))
> +		return 0;
> +

I don't object to this, but was rather expecting you'd check s_magic
for TMPFS_MAGIC: isn't this the kind of hi-tech thing s_magic is for?

Thanks anyway,
Hugh

>  	/* There is no real quota file, nothing to do */
>  	return 1;
>  }
> -- 
> 2.51.0

