Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64E8EC79FBF
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:12:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BF566B0088; Fri, 16 Jan 2026 09:12:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C406B0089; Fri, 16 Jan 2026 09:12:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76E1A6B008A; Fri, 16 Jan 2026 09:12:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 683C66B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:12:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 127C0560FC
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:12:12 +0000 (UTC)
X-FDA: 84338016504.07.0300A34
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 05EC118000A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:12:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=Iskus2kJ
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768572730; a=rsa-sha256;
	cv=none;
	b=BEx8CLwVKsvqUHCezHdwiqt/FoVO/xvQU3FnqH0t+kf7q0z6Im65Z5XEOrrcptnqJcoEdt
	0yM077QX7WPZuozTnkNccdroPQ113J/JXSVBzNz/iMtMuihxmMGqvkAERxpuoOVuXCbwo5
	lnau9Zk737yPQeiMfE5mP8/259eMSG4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=Iskus2kJ;
	dmarc=none;
	spf=none (imf06.hostedemail.com: domain of boudewijn@delta-utec.com has no SPF policy when checking 209.85.218.47) smtp.mailfrom=boudewijn@delta-utec.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768572730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ftGOR3HCczg9PRGjML2ssDls53360eFYMzlALTxJm8=;
	b=6pqVwkhzbmpkSMACwLF+AWAWBmTTjQXEtRa/IMldgW/VSqnV96k+ga9RvqN+JxqdkUmEPL
	dPqtmCrYcnGii0TyTfa2J7oVZvp50glhU03VDTigi0Hu2DgxVst/OKuIxMfaF5G6uO1u6C
	QmYdCn7roIkwPF333gm9mTZd5ItrWA0=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b872de50c91so323300166b.2
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=delta-utec-com.20230601.gappssmtp.com; s=20230601; t=1768572728; x=1769177528; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ftGOR3HCczg9PRGjML2ssDls53360eFYMzlALTxJm8=;
        b=Iskus2kJZhnpq0NptiaWfcrD7nHofI282+n/Vi4Ka3I1wwOw0/NcxRZTaojP3XISkm
         ZoxRdNTXOznGzuR477wa+HAoMuDqyMpQdjMFKLfXeVlbM+2+zX3y6EqsFZ2+NC0BKrdc
         DONI9n4MxqGdNpC55Tq2xqBjSJeG+ihNl23v7X4WKGj8z2dfwt0JvnXoc/DkMPxEl4lh
         uVsNokz1p28QbuWefQOfZ+b+dHNTsuI0ripLllFIWWc/5l1Q5YvZfqEU/ChTIgi+Uaji
         zhKy8D7Be5oEUSbOxKvQcpGNapzZ5lVPnSbKnsihMbJPCJhfbjQA+rdTXxYg2uyKn+ri
         q0Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768572728; x=1769177528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2ftGOR3HCczg9PRGjML2ssDls53360eFYMzlALTxJm8=;
        b=k6vWIeJvW/TotULjrD0BqYIpIXy0A4qKGlghp26AG1pUb8+tr2XkIVfx5kpM79aeCg
         G1CmyW4k7rB4MYJivd+wwB4CNDxrb6wyRwT+V0Dlt3xr3lIKGd3C9/+ekoL2Uno7I/OS
         LHTowI1oNchiO2F2Kq2X+TWSEbmRPUxIxAPXB84qRMkeHOQ5EmYaOAMJF/LjKZDhNs6s
         xNfJraY3PcBBuPSUG0vJt1zJbqZa0C2/c92GBHmANv4ljMImpMXbbd64ixs/r0csTU05
         oZv9veX8Vgc6dRCD8lroyx1gKMYetGiTB/3J+KVW3b9CC8MBJjUd0xjYF6Oce2HyJXfc
         XIHA==
X-Forwarded-Encrypted: i=1; AJvYcCW31dX3VzqHXRwlqp7ulFQqOmojwVmEWI7lI+UJFJR2xkkJzC4zIQr/sOQMxA2qtO10zW6JwPq7lQ==@kvack.org
X-Gm-Message-State: AOJu0YxNT+7YXXYclKpeaidHoiIwQN7MlJq6HVkrdyfY+tNHC0EQoWee
	dZk02ukNFZa+ancHG8v1JvFhUoYrkaosHfs/ojDANAmUyRDSF+Pem68lD2m1hcM2LQ==
X-Gm-Gg: AY/fxX7+GKALOY5N2tVrd2Mp30lBYpw/r3n7dsv06xcFHNPySb3W2drQUNfNYt9o8Od
	+6qvsRz2ZcQ43rO2z/ieGEpKXABkKs+QClCuywpGyUubt4g6VMvTxx30Gu6u3rKofURph2YQIzM
	X9GHAzDCgLGzHM6aozYPz6p652orLbGCfHUjz7qdsalAU2lK+rQf8fqyVXxg+gQEpKdwavzisF0
	ET6GWtmHitjyiBSwHbJoUfNVZlQE9gHwN0VA3kNZX9SRrEx+VyHBbh1lCDHtaDkl2KIxj3g2UFA
	/aSNqje87WrErtNvTjLSQRHD+N90ASGL2vLLYAmwohEoUvFdEgOh8fvmFu2U3PHkYicSPe2ESbQ
	pl1G7bolyayBiiTr3eBUAS8PVsxka0+4Y64VfMD1LRReZj4L6dKtTWe2c0HTWtZ4vgdvA0u4kkw
	YdEZAO+KlGZoVohi4re6X6LZatDlUPHqPl6kixVxCk5ChIB0ages2x1BfruUbKpNhfVZIaMKDBQ
	wdiTNNeGpRE12eruRGdrhjEy5v+/QiGiBpsCa8=
X-Received: by 2002:a17:907:845:b0:b87:778b:89ba with SMTP id a640c23a62f3a-b879300d987mr287076666b.39.1768572728262;
        Fri, 16 Jan 2026 06:12:08 -0800 (PST)
Received: from localhost.localdomain (2001-1c00-3405-d100-b173-9aa6-05c2-3fe1.cable.dynamic.v6.ziggo.nl. [2001:1c00:3405:d100:b173:9aa6:5c2:3fe1])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-654535c49dbsm2583543a12.32.2026.01.16.06.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 06:12:07 -0800 (PST)
From: Boudewijn van der Heide <boudewijn@delta-utec.com>
To: jiaqiyan@google.com
Cc: akpm@linux-foundation.org,
	boudewijn@delta-utec.com,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	linmiaohe@huawei.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	nao.horiguchi@gmail.com,
	osalvador@suse.de,
	surenb@google.com,
	vbabka@suse.cz,
	ziy@nvidia.com
Subject: Re: [PATCH] mm/page_alloc: Fix freeing of failed-split poisoned compound pages
Date: Fri, 16 Jan 2026 15:11:57 +0100
Message-ID: <20260116141157.29578-1-boudewijn@delta-utec.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CACw3F52D8=s_uj_jRtw1J-GjAvt4c3HNMKb2sJGUjznvyAK80A@mail.gmail.com>
References: <CACw3F52D8=s_uj_jRtw1J-GjAvt4c3HNMKb2sJGUjznvyAK80A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 05EC118000A
X-Stat-Signature: nst5e9cm77fk3pr1z9wq5kwtkpgitbry
X-Rspam-User: 
X-HE-Tag: 1768572729-764874
X-HE-Meta: U2FsdGVkX1+FKy9u6EUIESdgH9eYSMbWHjGFjr1LoZwIIU2zKjc+1/+RgYpxZ3ajvANFm3sykKzukqrj+g9Lodqo2si+2m+KrA9SjLSU90EJEnjVp3DsJ2nLeh7oqxW0YlS7TMXCrwtm/03d/vpAR8QO78C4ug0ln3DPDT0En1EulZE251nq28Pn6EQ7hWPrNjA62jIXeoGgSDfecB6B0QXh1TYRoLhc2VBV5NTVgPuwzamRR7BiShozAFRxFdgouHvQ3ZWxg0vKkJ1rsM8+O2tEq2A+r78Imh/GDqlaV7EmVTJTVKnQmpcQ2zk0xDPtdWvJbs+CJr30GVbwivWzadWSOMk1N+kttDvqKFZke95rYXyjwmTaw56MjNmE2vRNe3HrPsUmkKdWIgEHX59lbM6Zzl+NF6I1e2hqEymeMAUpCdHiO6Jothgh78daELf4E3FMTMGu8OXKkCX4KQgYjOX6NQqQ1Dyt06JHTxuq1BRJ5oB9TJbykRocwMJ/Vyzu6dQtqoUvCKx+BWa+wSHRA0uYMNYWsh8NaWYwXrzbPdH3aBZXVO6yXwW6RFFSIYrCKqZ0hZysvbKub+6iFRjUJRwSlCnGeRMorvelrkgZPJp9U/ArS9E8NaPHUmRF2APcdL0cYj4KdgFycHzBy+r3OOaa1b4eBnarPapXxiXp/AhnnmAa6x4LTXy41fS5rU7vJ5cox6WLN9ItUY3cQ4jK63Up4vlbPOOvfuCDBtCta87tuhXsTfV+9h4urXUS7mEvjFL9jpHXsCny+F4Ggjw7iugc+8R9zyuMEAYSUUtOyo56YDyv4tdooslYmy4mJhL+ckFTUZsAf1d8DJa/h/ZUDGQ8A+0YMS7OXSl2znmawP4N5HzEPyukkfASpo53B1blC40yor+fFWSTOsHlJwJ4BjwbCtlljeV/+uRsAbhM5NXn82KmFQp8hnM91H95bqskmtAuS58se1mWKMJSVH3
 Y7qspykQ
 aQHdL/7Gh0VSjt3WjJCEE+qbq7w/aol5oy76ABn+0xwGH5nI9cv/MgudNzE1dajiYOi6OJHLO7CIIXi6+jWcw9GyMBHBUBaGW24UMFQ06OlGGfmsKJY1ClJcjkNk9+Go9BkwovXUqkf8/yef6ms+MVZz1Tnrj6P47UzvER7oBeVR+3saZ+3zEje71dDeBgK8q8u+aAx2x2uTx6VB8FQ5Jpy6KX1cRCkQHol58BKacKVIrIcGERrN3MANcpbvapNbG1Ix4uGue3yX0d/BMpzoMvrdsHBwlGyTEmNS0OSkVWAQ5rwzKVgfaKBJYdqaxS0PDEcSwkiHikOrXicsGW4sdGAJD6WGxo/LAb0HeFdaw8nGCTQ5yjgccSrP9VuOMyFlP++vxOgnB0BZlAJQZyKYHwHKLTj2/WcyRwLkaSB96mupSfbGWEaYoL6KlT+MGn+GwZh0Syaw2GTcGAFCu9HrQxyQeeGcrsEY0dL4Ial9PpQium0nd8gy/oelSkajOdke7GYh6X3UHKjAgyTKHaiRLdycbqrP1pRNhArTjvVaz7Y1AT3GEp4hXS6p6UlB8aZMkGrKB9AE//0Th87pTJGpC9ajxS/2fviKknjzltb+yBGNn3w0++kQq9iaQIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000813, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks Jiaqi for the feedback, that is very helpful.
(and thanks Miaohe for connecting the issues.)

After going through the memory_failure(),
I can see it indeed puts the PG_HWPoison flag on the specific subpage pointer,
and therefore my fix won't work as-is.

> >
> > Yes, this is also a problematic scenario for Hugetlb HugePage. And Jiaqi works on
> > it now [1]. I think Jiaqi's patches might apply to THP scenario too. Add @Jiaqi to
> > verify this.
> 
> Yep, I think my work will also help solve the concern when
> try_to_split_thp_page() fails.

Your fix makes a lot of sense for hugetlb,
as it linearly scans through all the pages.
From my understanding, 
your fix also provides the perfect architecture for also checking THP,
though it doesn't yet cover the in-use THP case outlined.

For THP I would need to trace the failed-split paths more carefully,
to check where the equivalent path for THP would be. 

If there is work needed for THP, I'm happy to help.
Would you prefer I work on THP support as a separate follow-up patch,
after yours is merged,
or do you prefer to integrate it in your patch series?

> >
> > [1]: https://lore.kernel.org/all/20260112004923.888429-1-jiaqiyan@google.com/
> >
> > Thanks.
> > .

Thanks,
Boudewijn

