Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7126FCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 17:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0DF08E0015; Wed,  5 Nov 2025 12:52:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBE9F8E0002; Wed,  5 Nov 2025 12:52:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAE018E0015; Wed,  5 Nov 2025 12:52:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A68118E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 12:52:17 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5282213AE83
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:52:17 +0000 (UTC)
X-FDA: 84077297514.12.467C196
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id CF255C0010
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:52:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bn6l5ujV;
	spf=pass (imf10.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762365135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=22J/h+lLE1UxeOHhi0cAJU/qaxgcN4DGatLlI0jWwtY=;
	b=6EA2PsVzkNYPHF440Qr/S8HJXgDtqTNIi2dPVburesvgyKxGM7dpbinVETsOIAeuNTDRIG
	7Utr0eKQ977jaM7vO5rh8TtcnBCpv1a8bBDuzzotmjkpO2WV3HXhwF5nJtMz+nAf6kWkkm
	+wv8wG4n0Uwj1cv7pc+tv/yby9dd0AE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762365135; a=rsa-sha256;
	cv=none;
	b=iSdiu20OETHIGPTEN7doGMQ7VOyLW40ytWPXjYa+OLYbkfB+8gRKhUAvzbqT5QEiq7sYtF
	94oiaExt4doACyq/pgM60XNrqenru3SGQJGOHKS5ep2CdTlnu5CEFvd6mbN3ad7nWhJufG
	pbO+zOuSm6tLq/6tC7Z+941kqCT2fmY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bn6l5ujV;
	spf=pass (imf10.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762365134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=22J/h+lLE1UxeOHhi0cAJU/qaxgcN4DGatLlI0jWwtY=;
	b=bn6l5ujVKtT86oyM5aTI1Srdfk93Kcya5c/URSLQPQ+E+ZBOvIS2rb2IxJ/rxcHxH9vp1d
	Ufdp42h05X1qWBc0efMad7roJPYt3GyOZoOVo3ROC6a7xm8GYZpqKAu4VJiMK4Wnb1b6uM
	YQPZHttOYUZDjRztWFGDLh/usyLlqTE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-8vlp1kIePlimKMbSfWq-og-1; Wed, 05 Nov 2025 12:52:13 -0500
X-MC-Unique: 8vlp1kIePlimKMbSfWq-og-1
X-Mimecast-MFC-AGG-ID: 8vlp1kIePlimKMbSfWq-og_1762365132
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4775e00b16fso522025e9.2
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 09:52:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762365132; x=1762969932;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=22J/h+lLE1UxeOHhi0cAJU/qaxgcN4DGatLlI0jWwtY=;
        b=N6sJKy2IF7xIacrF+IYW7aHifuILOBwoyCES5uNiw+BxGd9NTVx5wT3CiWvel6mxLB
         yt7NDWJyytWzYB44PvQpmUj3zjgqnJ/3OGSjPO6p/NpZmire+0bLk1NOpBU7riYFNe+B
         1IhFTxe4clggTTaez3BncgLVUHp184LeQC6d9sYcf0CCfwybAbdSZLlJvIsfPSMkWvw8
         PNqOy2tJN9P8S3tiS2plvw0uHS7hLKmm04Du6kss37NIfhBfjputVFSW638OkWyhMENy
         h96Jwste+Ct6mbfprkdq8560YxovwBIkufq0B562rIxIFFuH34YmFgHYP4g4wwBrmZRD
         048Q==
X-Forwarded-Encrypted: i=1; AJvYcCW6/7Edn7K6sw0Zvq3R0/4ZyhZsuwMgzWSQZHUjByJ67A6SBlJclYSUiTdf34pTmJCmYRXUad2p0Q==@kvack.org
X-Gm-Message-State: AOJu0Ywqcrt7/rYxsKzbF3Tw7hTUUkpT+mHZ/bP/4c13pG2MRmI7BsGv
	53SPjV5YFbIo6h+l5NUI0H6V8ysQ8XA9Tgn8X+ru/OU+GNxbzzMOlXLeENxthcRQ8mE058/O3DO
	WbY9ITRN7NTit6sEvcAjpi8RzpaJRk8Uyv1RDmPSb+iyj/TP8mIe0
X-Gm-Gg: ASbGncuAJ+bK59v3k9WkJADAzg/wRDDTfO/2OPHQrwTqXjfXWWLapU67GQwk0KJ+11q
	QAyFBasgo5ek192XQnDaWR1cWyH5nH+1YfgtjSuM5Efy3uMDfE+P7d2ZoTusjftcoT0JRgYNqA5
	NJb7kyfpPj62SxjDXHeaxkPPGiKkGqi5NTC6KLvji6Vm2MnxpKwceYhM/Blq7lkNMxygoxfZg2g
	ug7NMRRTp5LzcffyHJ1GOG2k9RHnHr/J6sUPr8MjEbzrlJLf63ehoY5MSE1OE+E9dZQot3aIMgt
	RbJJbrMt85pMnLCFMkBC+GNOpYq4ZgqLX/z7mAe7xEDizK9l9QGRCmOGRo4Nq7KmIXdUsQiTzHT
	Nfw49Yyu6ogpSfBgDtIWqm6ZT01/qJdiIiGqwwtuyTZNJhYK0WeaNZqnU8OdKynJvNnQT8NT0IS
	mzmwxC/w62ags1LWe2ZDOsPSQ=
X-Received: by 2002:a05:600c:6388:b0:458:a7fa:211d with SMTP id 5b1f17b1804b1-4775ce1874bmr31530285e9.29.1762365131861;
        Wed, 05 Nov 2025 09:52:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGoDD6xbgf1IJR1sJkj4i5jcg9ZQmi10dSKftCfvD4xCVv4EPQ4q7rEAGjS7V5F+bOGJZiydw==
X-Received: by 2002:a05:600c:6388:b0:458:a7fa:211d with SMTP id 5b1f17b1804b1-4775ce1874bmr31530145e9.29.1762365131454;
        Wed, 05 Nov 2025 09:52:11 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477558b826bsm47438195e9.3.2025.11.05.09.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 09:52:10 -0800 (PST)
Message-ID: <63653e44-3a30-46e6-8a3e-f62d73f3f6a8@redhat.com>
Date: Wed, 5 Nov 2025 18:52:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] ksm: perform a range-walk in break_ksm
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251105172756.167009-1-pedrodemargomes@gmail.com>
 <20251105172756.167009-3-pedrodemargomes@gmail.com>
From: David Hildenbrand <dhildenb@redhat.com>
In-Reply-To: <20251105172756.167009-3-pedrodemargomes@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BtRLsvW8tnRbuy1_4LuCFRDKjO3nonxdg-p8iM2DOhM_1762365132
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wy4jw3n1673iq731dyfrpsgsri5zu5wa
X-Rspam-User: 
X-Rspamd-Queue-Id: CF255C0010
X-Rspamd-Server: rspam01
X-HE-Tag: 1762365134-107923
X-HE-Meta: U2FsdGVkX19lxELrbNwiLkAwGtzcotMyTgJ+pkRFAX7rk5ozXYxCxwgZQIbJRC9hpETonTJDm6tVM5XeTcHtppUrfT/PGAoptc8E2vzf92+/ed5obnnanEBcIiymEg19OU3KteUYs2oKUUUMD5x+93v5CnkmvRi+mVPbD9G9fVPvDC8+jAp61DPawxI4CwDm5mRASvhal3PaEMcpHpZRwUc7aqybDS6MtLbrb5wMiGwJBoSOa2UTF7zZcr2kulpru3NKzPvJW3JyCR/b8xd4mOqhKjfC3LF3kq0IizHzI0TMSAv3ZxkiCxMytZHbeSBjQyIfJtvlUktwViWkjvbpUVlO671z7Y0GC3n9jATql/SXu4BwD5h1wn1esz1R4vBJadXRK+W/CMyjNyp2KdsVoauo4JfyzEKi1UZN42RfHklhIVfL6+HYy1/1gp2QJwSkLoGu6myu9im3x4qEXgxk0Z5OUpLwBP1N7y7gE6+xV5cqkrwBT0ubE1fS8Q2LGDmmsjOjOQAUKmywS0gKjY+aVxBYMcabphmTQTgmz4PMlEu3+2+Ic7QRYnS6x/b5FSmsYTPqSZdD5VpkiydODt8m2ZxGW90eJg/NJ6dD+cZW0hy8Q/UW3QSDY6VxWVT4mWPi0olY3Sg5QNrlY6vh8E0wAfhNfWNvleTiM+gMpTP02MFL12W4lcERYXTlR8ta4Kp4lLEzIFSiyNOvhL0G+PSXMTv5D4BKQ49M52XwO+C2OQeFtXQ/SzWaj/NmjFbsma8R3kOY7GJVXMy6VHdJ5LVgvOGSLbQrS2x6pQY4fJmN7/A2VtsVkTTlh4BLa1wvEcOlMo8w07woT+F4cM3Hj1cwCYwd5pmuN6sFqoWd9vIZJgR5CocuHQQ1kADe/hNTAD7YY5MoOw55HplsBXvMevCwfgDZEYpiurdQgp+1odzrBfgWzBt5/yIuAimqJgTDcgbksAog7HeSbrIEWQBz5he
 m+CvWRkk
 Cdci94ty3LmgfRCV3w2qnnOtgwTUz4bMC+TW7iyKdzl4/+D4H/Ia+dPgZRo3r2dm2yYsBzKZ3SKaNZAilSl4W/KjwrL/Fu9GJedzjZYUhF8pqRgHWoxKuBsIJhexJmqgOr6kgt45OVKivoy8otzmdj1d1r5uD6vaad9OJac0KKjwzYadPzEYEWLpuUqjzx0m8OKQiFkzjrz1igGXf5bk3MIYrt5zc7lBjYMS80cRYqbwyo4hBp8CHqfsn4A1H6ncSvM8mgkAQc44n3YRgXjqTbhh8Hl3zs7a+pTQ0BFDB5zUlhP+8hUApQAjTDdcKONFSPtgpxHii1vERuM6er+7TXsg4D3u/kK9kJmDQk9gUVLoxUNV1HO7eiTXKiBGYGzJ5wDTjf9KDiqgjCwOMgZYQvNoezsfvDrl3JMFCuXOJ1NhCtgdNHOwcjdJe17ugLS8iZ5PR8jT+tcaQXJ1x3d1rawzFcXHVmf6z4XB05d319UVm0fxPk32ENOwtEYzulzzlMUIvn9+Ho4V1MVtaeVgv8G+xwOpUmhCpdUF2i+rUKBL5ZYbWswcM1ypTzaBzHMNjoenxUUIfJ79wXD1GjZzGdcTN0vLM90ehLA0mKv+7tsvRuaAZmlxr8ehhiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +			folio = vm_normal_folio(walk->vma, addr, pte);
> +		} else if (!pte_none(pte)) {
> +			swp_entry_t entry = pte_to_swp_entry(pte);
> +
> +			/*
> +			 * As KSM pages remain KSM pages until freed, no need to wait
> +			 * here for migration to end.
> +			 */
> +			if (is_migration_entry(entry))
> +				folio = pfn_swap_entry_folio(entry);
> +		}
> +		/* return 1 if the page is an normal ksm page or KSM-placed zero page */
> +		found = (folio && folio_test_ksm(folio)) || (pte_present(pte)
> +			&& is_ksm_zero_pte(pte));

Same NIT as for previous patch.

Apart from that LGTM, thanks!

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David


