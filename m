Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E54F1606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZRoHMhL7
Received: by kanga.kvack.org (Postfix)
	id 91AF76B05B4; Wed, 18 Nov 2026 11:10:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F2856B05B5; Wed, 18 Nov 2026 11:10:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807A96B05B6; Wed, 18 Nov 2026 11:10:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 465A46B05B4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:10:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 675271407B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:10:03 +0000 (UTC)
X-FDA: 85448726286.17.784312E
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 602AE1A000C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:10:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZRoHMhL7;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795018201;
	b=kQCpEaB/wU3CO8j1ktSz99RfpF+nfi6btyknwlFmkhoN1muPFQkb4Wn1UEbtAvJKro1140
	OURpTaiKBUxRoJjQWHtiXQCJMR+LOI4jqYmJCprsCTKZlkbuuF6CPB30cnCgJazqaRlLYh
	VC+BCeVewWuBL5EAqxghYmiWmfgutQ8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795018201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbYXoP2RPMw58RAwQCFRXLN2yd0B0w7a3Dun8Sb9Zn8=;
	b=YtILlP2hDNP9qpVMyGDN+2jW2tTcIDHxuaqZdAGyzEnfIT+CnN4xcjMguRLLPQeirpdS3y
	arrrVuGJvpPlyMi3sbiofKUkSaVII2pvYt1C58PGneGW/QBJPFk3ojUR2o/s8H5wuYHcFt
	KgEHnKZ2DM1GwyZwk20N7LzDEz6fpxw=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZRoHMhL7;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4bb55cda775so7125715e9.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:10:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795018200; cv=none;
        d=google.com; s=arc-20260327;
        b=L1U0OFLDxTlMdMghlKX0u3K3mWEEgArh6n73Wq07oFY/P/Py/hBkKMEB6+cJ7SQAwA
         jXFb5t9Yjj70vLZtLvzhUZ8kwq82rrauFemL4SpUumFaOiK4ByfZhwnx9gqY3l8+Kte+
         YteuJmB/BBuxVFwZLeMu7arGDyA++iSMolsvyDeHOYrSb6KMQ1BFanPj4nrvXvtQGvaH
         Zs4nfqRT1B4+kvEXFRUtI0EuiRjYkpdER4C7BrZ6DhTJ1hMkztggtyCf+Bc5n4ldD2tW
         WLG/HYnuibtMoovp+ZlljA7WvFfB+1/eV/ojX1lXbvkoqNNGIZA5PYrI71bpOzWegRO4
         +BtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HbYXoP2RPMw58RAwQCFRXLN2yd0B0w7a3Dun8Sb9Zn8=;
        fh=J05y/aS0Wq4eozvrkWZeatYt4Fl4HoZIe2rmTtPw6I4=;
        b=MSoGIlzX3bC5WnkUp1QLc3yEKCIg2S7zM5HL4Ikbe0pL3o/kuMd7Y421zatkJS9X+J
         Jxb4+yJmRjAb+j+e0h42tQKQsZymy4drQ7G1r53a3cX4Z9xo4BCL7tmqMi/MsjjyED+z
         fnFzj+WQcNj4cNPhPVJ551zE42s5UAS6y7KYpQS3OrLedvBA5EzJWb16teIVdaX2FOR8
         vBMfSOBY4Z/zVUayUrTyofT45W1GzmPSlWBWzRwdO5pgfbICE+lR2vNnejXT5O9ZqEPm
         zX0BfNxa1yIKF72Rk/BxuuTvtIf4mmo6Or1aOODD6HT7dgYuxRjRjiTmyLShn1I1XwPP
         WeAQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795018200; x=1795623000; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HbYXoP2RPMw58RAwQCFRXLN2yd0B0w7a3Dun8Sb9Zn8=;
        b=ZRoHMhL7JzIDIOd8UNHz1+qqo+LlenafLDu6+G38sAsOmK0UW6ltaah+7sT97l5vUS
         frpsXNAweAjAOTxr9Ca//t7HioqLKfPZPykdV8WWo61GMJIljwpNJqCskR2eKq8TLlGo
         Ee6joMvnhO79eEVII+CyKPfGGwrrWyiIKtceRAdMowfwMVFAm27t1k//OmsZkJ3VZH4z
         IqtCT1NM/iAi4I3Ggc/+f6m6/VuC0vp5ICpIT8u2w8v/JkCzXXEuJQtWb9aXetIYRktw
         PsHEEoJbCV8qAKIJNBXhL5WSOSkj4zAQBXLgBcivhbYgAEXQvjWXdSbsrhovcp6HvOtM
         Ex9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795018200; x=1795623000;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HbYXoP2RPMw58RAwQCFRXLN2yd0B0w7a3Dun8Sb9Zn8=;
        b=xvzmwO9HW19q/ON1GzaKnqxYMxktDSlxIDOVJ8DDuITKBNo9zUUvKdDZCPQvUmcGbS
         Ivam9sPyd787poejsHBqzjiUwVI0EwxX8p/RzT4ex+wOFaYnTtUDxNgga38AhDCaL7BW
         B7LZr+WSqyYoAk1T6Eiv8JQ7htsiObGkvdgQD6SYn1XvxzucqvAAao2w92GtAaEqNZPy
         Yd7ZS0PkmjhP3i/1I4PbV4u1AYmyshDVoFSyS3CxhNlNOBVuxnDtMplvkNc4+XmwLGwG
         b2HSnvykYH/nkwTwrg6n0qRFdiJ71AdRbNiL9Ra5qoGEQHKX7M2s1bVrazidZwibotF/
         gT7Q==
X-Forwarded-Encrypted: i=1; AL+hErHS+43XipvzaHFhwnBSdPUgC+PCFvIz5x6RlE3rbacHya+RSCxpIfxvjT4WalzNB6U6d1n/hymMsQ==@kvack.org
X-Gm-Message-State: APuU4Z8xhkxCd34TZWY/+tSNCViwK75xAc49dJj1irINBrVEbhG3qYA9
	e4qPCCRxIzcQhHQYDgn6HZaoXu8hQqr3MzM7tVm1BwTNN0ZQsQui4NSNr3Qt6ihpkdX5y/ngRbW
	yow5MPnoT28HNYPb144+IPdjklmTy7bI=
X-Gm-Gg: AYBFou0NR8y3hFAKufuo2iwIvjQhL5LSZTaKfOTKacjNyeMvKbIZYjlzPflnlifPjyc
	+ohUjYBExvrxPAOh+oH4DP0gvo1IINYWogBpMsv8F5zsIH3uelPxoaoWfdXslSzKs2x26YJRxAq
	TfDC5+rsq7+vvsPmHjxtNc+p3JZu1yjDqW14ZSLUT9DlmPO7HXaRMvTm+F82QUgn4B2MT5/W77e
	BX+0wyYKkKRPrt0whUfGQPqVXeI8VGUU6g6QwhIPknTBYAYY7ysgVnRGCj/dYS1sn64UUFI5rWs
	EQe8/4QmT78xQUE/MaO0rHzpRDBeZQkjRZN+FsZ3ISy89JM83kqhS3sobZGAHl4nPhJYcMCeF6D
	xjyBGdy/Uv42QzYOaG0bTHyf0mBmSTSvoPzGcbZoTT1xMYbJ7//0MrcqxqvNxUvfNAttZDS1fyQ
	jG+wkiLsSfFjUpGfpaia/Ej0AYMQj4X/7HH0c5w1lnWM1tWoLU6uVaizxcOS5tdlEP+MVI1+8oD
	8er
X-Received: by 2002:a05:600c:3b1c:b0:4bb:5d38:259f with SMTP id
 5b1f17b1804b1-4bb7da24a26mr60211045e9.12.1795018199716; Wed, 18 Nov 2026
 08:09:59 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117062620.346767-1-yumiao@kylinos.cn> <20261118130537.750211-1-yumiao@kylinos.cn>
In-Reply-To: <20261118130537.750211-1-yumiao@kylinos.cn>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 18 Nov 2026 08:09:47 -0800
X-Gm-Features: Aa3M54qRdo3OaZ77M4orB5mZ70nSvNFV6Jxp2gOAsd1jbRDwyTe3QzmeCNTj854
Message-ID: <CAKEwX=MssYOr0J7tk54qUF7DbNb550KZrFmwnBD40L+tWde+5A@mail.gmail.com>
Subject: Re: [PATCH v2] Docs/admin-guide/cgroup-v2: fix npn tags in memory.stat
To: Yu Miao <yumiao@kylinos.cn>
Cc: cgroups@vger.kernel.org, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	rdunlap@infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	jiayuan.chen@shopee.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 602AE1A000C
X-Rspam-User:
X-Stat-Signature: bjdd8bzqsqdx7uwhatwmi68zbjh4uw9p
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1795018201-838495
X-HE-Meta: U2FsdGVkX19l98/tE22Geywf9UsD/qJLyfW8Zb5CeVj9z/HBtw9n9lZi2W84N0qwRZ16dRj0w9MGbP4jZi7Ereb2G3V9qnd6Z38NZoS8+ia0Zc4V7gbx6rEFijAJZ2Rr44GHEhUnila0w//1dny/H/DW46aibzYGVzLpzGQ+colzPqmwJiSNCtKo8MiOLBqpOpFeDT5cOfcEiKxYmjvSsvTlWSqwcrwWdTDwpAW15zEVhZJ77Ocp4y2ZkhZvzxrqX0e6ydeqoVHWODfijd8ar3a7WD5G0YkXB62kVyuzH8LKY6u+AS3GAYdHaZ3S1HcqH6r2RT7ln9s1ElH5KObkWKTz+PSFfo8SIDMuGn2wJ2FeVDJrR01O6bb83imCpG3Z4S7HO8uN2SJdwurjYbmFF+1e/CERAQ7zTg6ShfbgE3lOn39m+80Lkj0skQRgoqfxdpdct6BRsF+qg5GQlGacoFQOrL8G0eYQq/oIzmUUs+k4krb3zvlQranOc8i3AstDonS8YBzjnDpqpdpI7HrXTig4CZfgseAuZFhis9zW+ouXXqCPnJB1mmjlbQ/9f9hFboDre0KPBAkeWllJkt6CiFzz88Wt4rLfEcO8LrC7sGzT5Ufp8+sbCJwhiEBWi1LYXlYhT6NrJ7mKTBBLjucXv+0wzBjUEUUTQJc/qVtZbGT4/DCm98r2lRrNl8mB38DsY85XULAQsfIjq3DbNkdE1WRcLEVKYhFgJv0XrdvEZmTbQviKpcD/wAaOEV6nfZaHl5pVjRjzDqoGEgoFbqVo5RBpdb02S6s8bfNDeFe9NfQIIullD0cB8kQDns4Y9aB2TFkkpauSy9mtjZX6XFP0lLgXKNW2o+k7lS8i7OIqoYdQrnkvswcHXgI/m+09pqiHxvaf+b127TCsC+xpfeBCG24WN8RgpZVJfPLM+l+PRDp4zi3g1n1ZdEL8BV+vtPqow2vIGfGLXHZuyw7WhKa
 fDaen15a
 nnGqY2K9+MgxOWQjT/wDiPpSLOFGbPTfSzdCFhnG3ZnDIVWdyCMKuzIAwRCfWtIN71O+0M0TarMFDAq5RNLVoRNdAqjNvIjXGULu39zBxOpcZyokbtMsZTw37XuFFCHMMTcUr01ZQdtCdW+Py6g3W3jYZ9jWON/xJPhBjZCipM2kJJCYSHtNdAS+lsVQINHFA4YE/JO5K1DJN5V9c6AUFO3/qxPBYNIG19fKRXot1lC0XQYEloh33uDzBWaGW606/vXQiItO7549UNhrcFZ4fUKhgswPTNromorzssoi/b3Ld2dz/LmGMzMzXn2UeF8YjBzwJCXkjeG5+pOF2Mz054lRfjCphk13U/VsSECULOB519tPwWAnvCR1VNneyPu3lNa+0jgh3CDjTL49rVFQcpxv18NgJPbeQ984L2PtvEGMvHu9Pk36T9EXCUbHm1fx3fp0rEnO7RSCVCXeQ3DWuYaPNUNfi53bYN6Rkoot4ZHtAgKF06Bcqxq02L3/IPf/5vmD6sppXNiXq4+6dtYzqm7WLp6lIOJQuRS0i/qO9oNjfgIhNiTmiWeSH+yBHQ988BC+8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 5:06=E2=80=AFAM Yu Miao <yumiao@kylinos.cn> wrote:
>
> The zswap, zswapped, zswap_incomp, swpin_zero, swpout_zero, zswpin,
> zswpout and zswpwb entries never show up in memory.numa_stat, so add

For the (z)swap one:

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

(but the rest LGTM too FWIW).

