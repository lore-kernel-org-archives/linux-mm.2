Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8810109C05D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 20:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5DA26B0088; Wed, 25 Mar 2026 16:34:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7F36B0089; Wed, 25 Mar 2026 16:34:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF3E6B008A; Wed, 25 Mar 2026 16:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 860276B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:34:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 41D571B6FBB
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:34:04 +0000 (UTC)
X-FDA: 84585737208.02.DC6D354
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id 257284000E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:34:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jdUo64yG;
	spf=pass (imf11.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774470842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Bx7O08fLm3R/wc0dHMJOEG74sKjKAWbEHkEchxKEVc=;
	b=4lDWonYauTKIkF1IQQesexa6+KTbvFRJI/XiTW3v/wt2687SEKSNocPCUwBcskT1RO2Rak
	eNtywXD80ULGhwtScjl7QiJm+bu1dtcF0PHtbl6IIALFdbNZnqzlrxYyNML4FWZ5Io2LUD
	9RSZvkjgYCrii2NxtraiOsfZsmHZWLo=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jdUo64yG;
	spf=pass (imf11.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774470842; a=rsa-sha256;
	cv=pass;
	b=cLgEhZyaMM/w/Wejapn6fE10/DSFZmRTOMozvRpc9Wwaer58eIVFLNv96xsVwU413GYQvV
	UpcoL2KnSEBCQUDbDq2AmEtpo+BTsoLyCGKUtKjETgA9auvNmBJ+uwu6nj5Smzya69E06U
	t4/o9AJjm6CcluFm9EqfTOadO1EShD0=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5a298acb395so423491e87.2
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:34:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774470840; cv=none;
        d=google.com; s=arc-20240605;
        b=DhtRitVtydyT8pQ7XiZLWzOZF/zl/rEFo6zNt6Ut9Bv40SpImqtAw7tIoid2QKNXmo
         C1JIEH7LjZbgUwgFJXeWDGZNrtkPUwDBouC+v+oYRRTTh1G2gHS1dLqZxzQ6RFH5Xlhn
         B30QmOvChcyGENe8RxLH2+QKPJAZpbZJBlZcmWtOIx4alH9xwixLt3P3adeZn4XOw4jM
         o3sX83J1lQeYsznykTBEmWFXUf3QtqpgbPvaP14hlqwlQyCaGA5vPmMAcBUVLxQu2dvX
         7MEpE/nblN5EDLi6/MpDBk55TLk21lfon6+PIFp/HhgqGdRWN2fhZl5iTcYNS/HZ5vpN
         WQEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9Bx7O08fLm3R/wc0dHMJOEG74sKjKAWbEHkEchxKEVc=;
        fh=3V1Zl2aCRrGTktEkaiySvqv7/lgfTXwvki2WYBoDfos=;
        b=VQpJFvJzuRSOCzVZgLg5wNojLOrp2EdoQps7XODUJhC65D0kqjK8CdskDz/eMuOuiB
         vWnGGc7hcS9wV7X6m8/RMYfa69bWd5bTy5/ySaD/e4NVvUQOfujScYCKnU3/TvHVfLu6
         wTfrmY52FEnpBaNzBhsuPv4A/PB1hpElw60APCcDlRBH/qQ6OrFY4fJ9o2vNHssxC2c9
         RnYNPFSI/thmIpNEH9e6wB2UY86DOECXk//kpUQhXZk2K8AK/peahHc68tEOfiS97kfu
         OZSXpuajyit+BCg5EeoLwRa6UOtJnKP9diU6ydddGNIlpSdTMhZn86VGyGiDtYBl3FR5
         TIDg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774470840; x=1775075640; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Bx7O08fLm3R/wc0dHMJOEG74sKjKAWbEHkEchxKEVc=;
        b=jdUo64yGJC7qNyCTdxJt7wrAKoojpTYcQS1eqbbpHQdrJuRPxOlXND7Qm93UU38fRS
         fp0aQ+bMoiRdRJEKJSyCWJ9WRdcYHAXven2jYvFX2Zha5HvTX2+glRvNBx4jx/3BlVcj
         rRkOIwKx8IHAozIRjL1hLXipZtQfwpKzOgkn2oSsShCoSDh4m71QMlupM4IYMmwFs1+u
         BgdFq48VDVFdF3N/ZxvGxv17b/xN1pGDaBhpzZXXZH2SDxaW29IGLLbbDFenPxwjxum0
         E93/E7kWRz4dabvvaEJHRLiBQhhp7t96275qT9iTgeYSxjhHPnx7voBlVWijhkCY2ahL
         lnig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774470840; x=1775075640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9Bx7O08fLm3R/wc0dHMJOEG74sKjKAWbEHkEchxKEVc=;
        b=nFDBPUQVHNujkRj3v8UGI9bQ4e4Cf8DWPO8OarZC2pR2jk9PQ6JfFAvzI2gWFt7TsB
         8ryXnnnjqc5YaaxspGusJzsjScbtfvLaZsN8bh31dAWx5j2vi52Z421822LMWsu4pHRW
         amORriYkkLItC1YBFcdfN0GbTJqEl3xQiMDZwWVp5Y8LY+nUbI6scdQLb9auA3JgQr5/
         WaW87WjOrSJ1uyY+MBTCSjYWZp1wFpAHYW19ytKg8oKabEAEVkrQ4rawlycfVqjiPZu7
         LGaiFc0fXagL1U2g4nLN4B4B7M8aug42kQV7u6kwt36xVH7ygZpGjj2+FUe5Ev4hdihT
         aLVg==
X-Forwarded-Encrypted: i=1; AJvYcCWErVHk8Nydq/YRtir+H1UhDQ9pwd6Ylww+W7qoxCLQ2IxYjBmnTh5ivtccKAKoE/lx5aTI6ty+xw==@kvack.org
X-Gm-Message-State: AOJu0YyhM9Eif8i/r6rUf5nKK0kC0yZBD/xRncse5G9O0au6uHhEdTan
	9mUyJNtJ+tcyXz/m+N73opCNqtcegqTjukUCrP25nqLT20HRla2R1VjYseQHbCa21B6P1kwB2xK
	biboI4pxgYTFeEDeiwgVYtd2ESn7O6wsdkLuxAZdE
X-Gm-Gg: ATEYQzyPvSvqO1OZK/EzQSnTen6ZQLgkBtK7WY9a4/1BZEt7bEqIwn+Pp8QICtszsSJ
	sBdl9deJ6W56oH/dp9BY6ROPpsbk3gzajFQTMySnPqHQ1bTu2AtaNlA3g2Y22IrcoG51whYTQA6
	runxXKz7CzYrucJKfJzn4iRdrcLxGsavBYGceErul5LDDTOYXfyNbhS3cpQrZQnr0bdLNvhR5ta
	4S/5+HQT02KtjkpikjiUQuQmgTLXCji0ofVDK+6N/Ef4WYLC9yDqJo6fQAfG5vprucQbbRXLUVe
	Ici/8S7A
X-Received: by 2002:a05:6512:108f:b0:5a1:3134:923f with SMTP id
 2adb3069b0e04-5a29b99ef33mr1526971e87.40.1774470839740; Wed, 25 Mar 2026
 13:33:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260325182026.467307-1-pasha.tatashin@soleen.com>
 <20260325182026.467307-2-pasha.tatashin@soleen.com> <2vxzikajacgc.fsf@kernel.org>
In-Reply-To: <2vxzikajacgc.fsf@kernel.org>
From: David Matlack <dmatlack@google.com>
Date: Wed, 25 Mar 2026 13:33:31 -0700
X-Gm-Features: AQROBzBIp18gRPLcKPfh3wjTKZUVHHVImeKDpRy0cS80NjooMtufSaZyOa4m9uM
Message-ID: <CALzav=eybgJwMQEtvSi2bUv8u7cic6d45r4wFZdZiKFFrrLJfQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] liveupdate: prevent double management of files
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kselftest@vger.kernel.org, 
	rppt@kernel.org, shuah@kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 257284000E
X-Stat-Signature: ydu7qp6q1u58uc4hxcef8z1fa18jr6tt
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774470841-325471
X-HE-Meta: U2FsdGVkX1/wWYGSMJDwTsup83EGe3F2aqfxYmCHst1cq+VMM3e/mLtTpTKSDvHrtVP9WLsJQY3C9Yw3E0XU4SvgYs1wf0hLqYLpKYEHMKTUW1lOUh7DvIrlHVULhhBoV3I/PWHXM7JwBOQ3SLCoeT+cctkAtf6WSLhwuvDBXd6QEKOevUVqn+nS60qWHouq0lt+oCOJ8rDk6xKb9xzlp+nfoXWruO/zfcm9tNrM2HlV05+oWdGYZBIlaD0zmVR+HPUfKOei/WzX/R4OpBkql+0UU1B4J9a60QxuxIduTegqcfRWlMZL3+6DfcygDzFTm4riN+sth0kR5bMmlB3D4HQrpgM5QufTSwJKRRWZb3Y95tIRqgCu77v3pITBNeAgSmoPxr+cNmXx2CoYw9JRlvDowqBWq58Lkfs1Jnx3tUga4XdffpDu9ZkEZB0Ze1OIjgaXeTTG1Q+Nab3ljqjwgY2bdcwRu/vxdj4F+MKespOZBl2nnko61xn12S2lLQJP8ReUqrD4DHE3gCaeTz+tz4LCYppf9i6iYm7869Js9UXQAvT57px7K/xq4hq+LaPBgDIUOCXSUznAoGS94e8ReNX78xnfiX26IlWoAf6/vVxFSlJoUMsaeZLu18/Jwbqo9KJYzSyf9AKAsOPUCxQg1QPV8NxmBLZURbtNMDnvM6TB/xhmfz6jHRULKk2y9tB0zXae4Ivsu4PiZOoXLaAJmSe+VlIZEqxruP5reR9eTL0nAlQNbK89HrcSrnibEQWl5vNHR39Gmv2RKEwu5GNC63bfCPbSTuUjQ3VWXuSj0IB2zbYPA6tAoIxGdqir5eOtfKwS3/FwJeZrYfx7fQDx8VE8EKY92oCY/nMi5ys6pWeDi/3RDDBKcQqoEsAKt5SnyjloF+364GYFkSPqRE2DsvTJOqwEA6eWdFJbVWJrJ+7nABqdre3mhbTpxgMye7umHWduSL8hdaEi3GPSBBm
 sGyekiNW
 E/jnc+PONMHV3TWDgKnn1qYW1FiPKJxCRH07W945j5zI5jY2FwQYz48UZZ7/dqXuLwdRa7CjZF6o7q/quJEfxt+zeMxM0qdkr8UkeENP+CSXoDsJMMY6xqNJ/zHVwjrdg+UYRLmwu0exu0qgFQK2sjAtHDpKcpD/Y+pwRzIVTRYVFKikTRkCCVSVFd6Skm//+f49MkJytMEJ1uU5cl6bD9Z6k1Ts18xX65hipMuMG+QUg6nFwlsN1D3QF+ePTIqorMAWv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 1:20=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:

> For memfd and hugetlb at least, we serialize the _inode_ not the file.
> The inode has the contents that we care to preserve.
>
> So if two FDs point to the same inode, this will break. You can do this
> by first creating a memfd and then by opening "/proc/self/fd/<fd>". Then
> you would be able to trigger the preservation twice, causing all sorts
> of problems. Same on the retrieve side.

> So unless I am missing something, I don't think this approach will work.
> As much as I hate to suggest it, I think we need to move this check to
> each caller so they can find out the object they need to serialize and
> check if it already is.

I think LUO can still enforce that the file is not preserved twice.
HugeTLB and memfd's preserve() functions just need to also check that
the associated inode has not already been preserved?

