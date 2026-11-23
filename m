Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5D0B606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KqUklFMm
Received: by kanga.kvack.org (Postfix)
	id 01D8A6B05B7; Mon, 23 Nov 2026 12:35:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F10C06B05B8; Mon, 23 Nov 2026 12:35:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27026B05B9; Mon, 23 Nov 2026 12:35:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD3F96B05B7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:35:53 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 612B0409B7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:35:53 +0000 (UTC)
X-FDA: 85467086586.06.83809C4
Received: from mail-dy2-f9.google.com (mail-dy2-f9.google.com [74.125.229.9])
	by imf31.hostedemail.com (Postfix) with ESMTP id 83BFC20007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:35:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KqUklFMm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.9 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455351;
	b=SZFPtRrYQiwX8zsEmp5L/GXi4F8Dd/HqGBGE45sof4dQ3ZAEX9+h5mYLp57D2NfXe5ObKT
	wzkUh5S68X8AfKFqhpo70DQzbrynLpdwtLpHE0iFc+5we0CbPD0oftGKK4JnaJymngFsyd
	NETFUggCsJ2RUcgSxwJXGcN6h88YXMs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qEZ/6YgmZAusnYMPizU5ad+3JlJMNNGOuuByXU0MIWo=;
	b=y86CQcipG1wJCTlKtcn4hmoUrTM2Ij5sfQtcvDqGf4RmyON8Mkvd65xKq56EwiGHgpUBfS
	iHXbvLmIuHtrvtYYJnCYF9S+JL9zeHnmWiAXGo/he1E0/BPJuB/KCjSN7vCwgQga5BaLdj
	N8KVq0+JyoYqa+E+giGuHWT8ptj41Gg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KqUklFMm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.9 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f9.google.com with SMTP id 5a478bee46e88-3678f64d078so4258377eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455350; x=1796060150; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qEZ/6YgmZAusnYMPizU5ad+3JlJMNNGOuuByXU0MIWo=;
        b=KqUklFMmJOR6lsPK/bGzclqgZbgXrBKHBLDUc19hyguR78BshlbrD2UpMWvqtKB7eM
         TUoFLDmsYd4EjqfF2AToeYv47vbz90fFaIuN5fYi9oDf9WHJrlWOdyYjZKQfqQLDlkv2
         8R60Jm303o9krd9gEV9CYV/8W/eiW8zog3DFQpz6zWRzQSIE+oLJKyiuyPOvqcPvidgy
         QjeaBYVrjn/lQ6bUsj7LxEgne0YnATs5DH9uQtrwZR4cTsi10/xN2rbcvcuUKNpfjGzt
         kydWfL+FjbBELmtjOYtSSUbvx9d3kMIj2SZy5nwgkjwCCB8CZBG8r1rAi5hABfQQucxd
         NokA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455350; x=1796060150;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qEZ/6YgmZAusnYMPizU5ad+3JlJMNNGOuuByXU0MIWo=;
        b=WKm5Rb5hqouLenLvbKAD45OXh/lzGdHXybO3zkj2F5dLmtl5wcZHD/Ap4wlhWqn4xt
         I8+yQ9rFJAxw0VEdHvaSOq3pbEl8d6/kIQkCMeWiNX2uqC8VesIihikIP5QUhq0Tu5Pg
         0Km9qm3htta+KVamSPEkrCCYuwXTGlB7wXoIhxIvGPw0G/qye8Oi4hZd77mv6+MXEmTX
         dv6U3Arxr5jaLet0on2JE+b6pnBMh+ne4zfT3onyFbqVML50UfZO3XawFtVVy7RHrgBB
         l/DBP4J9M3xO1TD5KQT/loyUtkidKFVxaafe7NSYkS9MyJ5Qjj/QFIJyonYXo3KOgcm3
         VOaA==
X-Forwarded-Encrypted: i=1; AL+hErFhUoYjPp8FpSovDiM3gkGcmPVfWOCuCmLSZvglCvH5BBvC5UWKbn6W7YFPFrKo+xsmeVB1XEjzHw==@kvack.org
X-Gm-Message-State: APuU4Z+HC2G/95iSQJO3RbgtE6r+EOjPjYW/lI5eekXN2QJWLUNZwjRl
	75+KJ3btNE1PRuyQt50RiuCjmkH7giecQO8UE3dcJ2BoTy3gAE19BoZV
X-Gm-Gg: AZFdTZdmbB0/90rP9lE+wfGVHHE3BSAUAScZDvsUlHpTMf+S122e3vH7tZCpYQ/T9dg
	roVGnCyiwA05ib9+Jhpdr5aYs9rvb7Vx+sFiwrWGJeyzbaQOpNoELF+pv9SQS95qMI1KGeSlrIq
	W9u/qrHITEjKwmiT/evNZvR8TkQHOPrYNDKeplv5XamcvhLkZNSw9chPi1LRm+OXFlH37l+eXc3
	Y5yIwu5o/ho+d2g5noyqo1IyjpLJvUguIqaeQT5baLkWbUuPrC+Mtk+pz6QLaMCJqjd1h324+ex
	IoEY4y/OQILdhFwwBXYHhUlm/xDmKLNPF0lp1ylcPX8PYg2gEz6Kx6ZwjIXGH1vlMkbDbqsQ5sH
	69vPR3zUV4OkfwKFifrJiu/T7Xm2kGHKphYjWSrY6MTgMGt6epJTlJZPbeYm1KgA3o9bsjQ/nQm
	by7deG9V+vA6ke+qA/Mw/wQHxZaWTp1jdSvmcC7RVMb4pYb/rrsc91NCS3LYuLG4S+t2v6NRtnD
	sSR7McBhHJrGcKZyJG/GhaLqeh1bsCn3K/isGpWFkQcJH8eR7cMgkOlQM8euWuDVQf5lVRW31/p
	igJmme9IV7qViSthvyXzCQ+7JHKc0TqeT20QLKu+T98tsWYYIr9od9x99lzfqImQ8oL/+1lW/RV
	MY0zha7AnCOK5/WHdZMf2Niz+54NG01yVs9hkwydP6kDr51Xlejzpjim6gBXGsg==
X-Received: by 2002:a05:7300:fe83:b0:386:2184:42a7 with SMTP id 5a478bee46e88-386218445bfmr11662417eec.10.1795455350079;
        Mon, 23 Nov 2026 09:35:50 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:35:49 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 05/27] mm/damon/sysfs: add reports/producers/ directory
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:24 +1100
Message-Id: <179545256499.4.12378392251322743126.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 Lian Wang <lianux.mm@gmail.com>, linux-mm@kvack.org
In-Reply-To: <20261121210013.130397-6-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-6-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83BFC20007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: js5frkb9sqztbe969kdez3mu7hb6apbs
X-HE-Tag: 1795455351-559636
X-HE-Meta: U2FsdGVkX18Qe5xTkS8PQB1q1LaClIZTtm4+6QJFEQXdbjunLOZkblTAeHAASVUUy6hqEUEswRxApyc2WzKNuH3YwN8gpo1RB9OISq3phC9hmNyBjQLkMzkNxGZ+aXOFfpxuM/WtI7jDeFJVleMkQI/rGN6pxWZbDrLh4p/9ingU9w5WNV/idiFcU3crrtOurdpa6pWGwd666L/VGFeIC3/sqBmjD7fTc+2ye8ZZlMyj4ukWrfnKniN5lsYruUE580KdxTA+sTnNMA7TTTKBMdm9F2SoMk+MRaEPWbvjeYH5EP2ysfmVSOSp8EKi09S6FcOBRZaz8a/uj1dYO3MEhRbOxS8TiYyehyT3FlISWGj9ZxVD1PbFmy8II7dT+tak3iINnCaGMSqmnP58hlScHAehR5qPIl0Y5vGP+hCu2gkvrOlE687Dyknmf6/RDWOA24fdviP8h3yDLsZKcAVAIKbZ2R0O/lqVmHttlFLQuF0uxP8qE9YxtKAoi01+/kcsJ39v4MaSbPvgT05mJehLS+7FJIuwKEvD+4DTnzY1pr6ym+6VFhR71Zg1kf1rOnTSio11joPrImq7qOAXSriu8ZartyzlqTEpN0KdlHslzvzd3xZM6qfc8a7qiYuvTqlzgReMVOAQzm7rJkIEBZg/ArOMJHA8TR8YBAdFBA9TDSMdV5ZrccClB7KOrASRoTX8BNZB2xwn/ZU3BxR5BIvVH1kLMEg5tk8UIr7veGIJju1VnyVQpAaGp1MqoKbCD9WoD8dlR0+sMEBjiKDbB1ES56VFFEw2eSWj8yWaqe2ggGcQyvpTJXTjID1HPwwOXTXAIXOUJNUSy9cXF1EqnnUG1IbFjjxSU5YG3uykjfs/1c7jSc/2OYj3ycXtCv3LFbIzclSLYWe+gjFLaPL7tEXxHeON2hgS9fzPMvTkhGxmGtQt0NavQgD7xzICwR8xDVeUj/cMIzqmW6nHCJ1j+Jh
 4HILGBzl
 YfrrioyZKryVA1rIfVGNv2MkcRVbfmAL67dOT6AV5dgx1MvyUPN02wXaKFP9wVEw74+cP1vB23AId4ZoUQ7qFePG7wV3BRcJBp2PTrfvN8ZBHuQzQky/JmdnDMc4JESDlzIFcehKzrgA+MTTzyjBeZeYQZYQJtfM93+CIkE0zse3qnu87dyNSyBJ7YSdNYcfNA/Iy5mpvr0HCoP/PfEaajqjQtFqT6u/Z+kT3UFfF91Kj0blAkK90TvjGNw9kM84RKmbcPJLmKgjwNzjyTrl5nI0heblpl9yvdx0XiGc47t4e0HwP7inw0HaZfoSQi++81J4C32OSw8bmoFSwMRtJlG3LBAHHtpie/Db4sM7d8VWEFMX5D0GQSK9j0UMhMao1R5mo6f4cXpuhGhv7lwH91zZfoxNKRLRd5cyTLpDyhdpnd5pKsJGGmPMDrb+HljAf+W6ipWZ4W0RJXAUKk3z9dGsXSsYXJm8v+hEadiKpOjMsu8uF/DLRlJGC3MM4rbmGeQvy1lM4hlrWZlkwclzaBKe65v1NKrhNmdoXGGjv/WKzCN/RbdtXpQqagewg8ynhPeXnnZ/DALSOO3AIj+hicBYu3knHv/R/oTpLSpjHiusK/GZY5LFEnFNKQ+3zsa2J8t/XfgQrSK6nG7kts4ENBSujmKqd/fwI/ShcVVnonktNpnb1yBjCHACcS0Zq5YCFMe5TSAMGGGaxDTqynjP92HTggxHE653OQNEFUAIko+jzV+sc0f8HlWVtdVeJCs6HE5x3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 12:59:49 -0800 SJ Park wrote:

> Add a new sysfs directory, producers/, under reports/ directory.  It is
> a placeholder for files that will be used for controlling DAMON report
> producers.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

