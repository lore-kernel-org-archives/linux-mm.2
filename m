Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DA11CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 08:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7C7A8E0003; Wed, 17 Sep 2025 04:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2D148E0001; Wed, 17 Sep 2025 04:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF43A8E0003; Wed, 17 Sep 2025 04:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B80678E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 04:38:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 67EC81DEFAD
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:38:31 +0000 (UTC)
X-FDA: 83898090822.05.4C7B8FB
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3C3AB180007
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:38:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=hrv3yhj5;
	spf=pass (imf06.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758098309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KBHmJ3YGPWtw0TVBcuf6xQxYfSMlt+upAEuM25ZvfTw=;
	b=wBM1lR6lASCs/+Gd1U1/a3CoYK0htsr1xpaQpObnyW9P6IE8yo5vWDhGIKQMu3rDP//qk7
	JqpgUrajtcJ0O6n5teEjDEtjS5V99VOvrO0ls1ZcOZhkSb3qTE9Hgd66y4m61/QjQlZzx8
	sXQfC4478Lf3Qsty2i4t7a8rMo8E3u0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758098309; a=rsa-sha256;
	cv=none;
	b=dFD/48d4uztWIoebFh305eGXygi7yq8QNSaqBdVBD/ioVL+zksZc6WJVpqgxSIs4G1el6I
	J3rhcS/SpjHRAvSbYPeOUFIcnuyFPRqotus070rvuFMCRAFYsXSsPCRJEPsa9tLl0UrMI5
	WKbxOwDDtYuoYK+fZG4b0ayR8n2GcrY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=hrv3yhj5;
	spf=pass (imf06.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b07d4d24d09so484461066b.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758098308; x=1758703108; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KBHmJ3YGPWtw0TVBcuf6xQxYfSMlt+upAEuM25ZvfTw=;
        b=hrv3yhj5Spxaj85YuNI9OmDVWg/Rv+mkwB5r/+ETsbYT5uiI7iD/1bkejxV8jvv0SZ
         3SSGjXcPg60w5w3nZw0DurOGGOYRiKbGXpRbS4umUXnwBEo4J0ItojGo9gxGTHKbQXyS
         uaIEc6tZjpwPmAoX1ZurOUuXBBwgk+UjLIEBX6plG547+hIWxjV28TFfXyycXwBp2cyi
         rdoKn+SJDcaa9Wc1VJWPo2WAP12qE1brjOkaSOCmCn8A1SgBMOlvRj1Bsq62K0ioNaOQ
         +TbOFdpK/XsU06dKZK5PtPaCaUQBK3zP1ra0mQlSmfF3IlDSfmVJ4dB6/fX418E8/x44
         nOpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758098308; x=1758703108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KBHmJ3YGPWtw0TVBcuf6xQxYfSMlt+upAEuM25ZvfTw=;
        b=U/iKQNXVE1WMp6wUadZitmki4d9OXCfdkfVTOOZkDbJVstn3ItRVKuHJMBqqlVX81Y
         DXdGeUhWtS3lSBHTxq7omgBriKR1ITrD9rKXg80YfYlhE5WW25Dns2K6HbzYYZO9cOcx
         jGd1TiyQrjPudyVEUlMn20iTrWeofEeIOpasLLEEhkEjVr0HvmrCl9CLenySo9CCAzJv
         rouqQc4uK4pnQDn2vQtuMc9oO4I0l8NA8ydy0Zlbv/V+vz9bV7ImxVXB88chO05HuTDM
         i7HXqgnG0qWIE8h1z1z1CM/ujlrPQnlkb4GlkZ/HDvPb5R1qhXWYrfaLouXN8iKkRGD0
         A0pw==
X-Forwarded-Encrypted: i=1; AJvYcCVVJ0B57XLbHBAo9BxEOgJW4GOLu1kEzU7aOvzDKBQxPuExiWoivf7btxIenFlBeHGeSX6cV+LVnQ==@kvack.org
X-Gm-Message-State: AOJu0YykshsWH3jGeZW7nkbT3OSA4gU+t+JqI8kDo//IjuWFHCEJpcmc
	d6uVdIfMIfYZjC+XKICj4KmCeWLI2jMRCgWRZpLMGrFemTl9HHah/d3E9txmJliW0h1HrbFXNDq
	+cg5RLgSJemN1VSnqnUPCgdMipO9UCXP5evDKbY2Wfw==
X-Gm-Gg: ASbGncv+zMXYZ1Gxn63YSzhvkBkVzh5msPBMgaSoHdi9wN7q4i93imQjRqVvQYkq9/g
	mFFqNbwBIaJyiQlLT6FHQ6YkOABlGFQee4kEkU+3MAKyGFaxD3TvXcoHlglD+MI39WPdGf1kj0R
	djtUj+QGFuA4DNCm8zYeorR18fR4QKyHyRMIWB4rpKxDdxgxEnwWYt9+MoNdoqddrmh0PBxJ3Ra
	tyKmfWUFtBFdfjE6yK+5g0j92KDAQCNO0Gh
X-Google-Smtp-Source: AGHT+IEMhj2KG5qf8fnmY8YQ236Z2f/mZuBCacS/ZiY/DG7jAo8+3I46DBQR8FMyLwnPYtxjdsnW2tAHRfHmFvDQvtc=
X-Received: by 2002:a17:906:6a03:b0:b0f:7d24:589e with SMTP id
 a640c23a62f3a-b1bb2ef9ac7mr134196066b.24.1758098307607; Wed, 17 Sep 2025
 01:38:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
In-Reply-To: <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 10:38:16 +0200
X-Gm-Features: AS18NWA-wrbT4q0S-rkaZcoEEdey-hG5hsxUREPMlCw6I5wTNJXSuzY62UoJVKM
Message-ID: <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3C3AB180007
X-Stat-Signature: fx57m854gz7hhcs6phwr7igm5mmxgcrj
X-Rspam-User: 
X-HE-Tag: 1758098309-923396
X-HE-Meta: U2FsdGVkX19UJ5W6Un7XZm8E0bRbwfGo1YvCTNc6dMihbJc+IJa/74EJR0w6p93cwEQx7zg7r62z+cxN9uYveenztc8MFlmAM/VaGJq7aj+P1nyALQ9BGHvV6Wuw1mPQ1XbZZzHtEn3s/k+mIbs0gcIqSq4oaKzJREPIwRO+6piKF9SaUd/iHTTwlhBHG8YL8JPtkcPGuTp+q488D5uZNp4aEoQRDN61lyhWoIjQFrcMMAuH7hFrmtZX4ONFspdeVJbbqcbOszhVJ+CEqmb4GbdIWByTNsppHEuVY8U1UvoQHZVxcmL8pKDTmWVE7XBA5qjnUQ2dtIhx3o+e0mZoxF0NqNZ7MRDhEmcubry56k8zHb66odtWdFCT7wZwnAJB20ZNTwMBwC9tcQYuisERAyjeqsG49DiDtj348+NNw3qyD3bigcBxVntMMGlubmK0HyU2XNR2TbYWQn4GcHP7p5Ss6ADcl+tbFZXUAU+KsDTiVU6wVdp7gRC4wka75ehJkFh2Qf9LbpiYZ55K65zpUOlnii25wJzuE90vDAXLxVNDFmei9dUbtFKgHPYgUrNBLEMs4KikQBvnl6pnMU4rx+cxolmnXrtZB4z1keSD/FYsXAhkdOy8USwA7dLCYVO/v7zWNUCqY7t5hnatkQfzhAQiECEWaypUoe6Pdf24sDsVuvv67yKZLFFsZG0l3tpxdJGaWArsKkj6oT5OiqkeCmoJtdGjERFDSeZ2VWsxmxBUR7fg3j033NfeStxP3dBp8vZXuJyVUIEaa4SZoBN03b6UgcxcEz2wuzXNESC4M5QPF5FhyONMOhHPJnFESKLuORDn8P6la1f8J6OjxHmTrfamp+IY9xJiuAM8msQBcbEOEy/iWbiv6ItrmJTak7JxCBb0wjJ9z+y0ayDRlqgkmVVL3Y3obnW81xOM0w+UglFvMr4gs8MQd94HH/Gn9eoH+C9cz4myz/6gGtfbAta
 CTowzf2G
 +DzLFyq7JpmDzlJ4coq0vtACBbWwLON2Lc4zwk7691yMc8yS1bRwa1XHJrrTdlrF15G5hMyA84FIvzbdVykGSNGyWBOuJ4JUNFNK8QjOdeh03kzv5xZTHdXi2yjx02H55lyZ3O0BtjCbNhK3xV6EpztqHkuZ72+T0OagtOlWtIb2hdq1U0rZlSSPKfLD6atHV8HIdqsiwDrxFXPdn6WO63lPIlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:23=E2=80=AFAM Mateusz Guzik <mjguzik@gmail.com> =
wrote:
> So that we are clear, this is a legally held ref by ceph and you are
> legally releasing it? It's not that the code assumes there is a ref
> because it came from writeback?

Porbably yes, but I'm not 100% sure - Ceph code looks weird to me. A
reference is released that was previously taken by
ceph_take_cap_refs(), but there's another condition that causes an
iput() call - if ceph_try_drop_cap_snap() returns true - but I don't
see where that reference was taken.

> One of the ways to stall inode teardown is to have writeback running. It
> does not need a reference because inode_wait_for_writeback() explicitly
> waits for it like in the very deadlock you encountered.

Ah, right. No UAF. But I wonder if that's the best way to do it - why
not let writeback hold its own reference, and eliminate
inode_wait_for_writeback()? (and its latency)

> However, assuming that's not avoidable, iput_async() or whatever could
> be added to sort this out in a similar way fput() is.
>
> As a temporary bandaid iput() itself could check if I_SYNC is set and if
> so roll with the iput_async() option.
>
> I can cook something up later.

My idea was something like iput_safe() and that function would defer
the actual iput() call if the reference counter is 1 (i.e. the caller
is holding the last reference).

That would avoid the other Ceph deadlock bug I found - because Ceph,
like all filesystems that are built on top netfs, uses
netfs_wait_for_outstanding_io() in the evict_inode callback. Because
guess what happens when the Ceph messenger worker that handles I/O
completion decides to call iput()...
Due to the evict_inode callback and the unknowns hidden behind it,
checking I_SYNC is not enough.

Almost all iput() calls are fine because they just do an atomic
decrement, but all kinds of scary stuff can happen if the last
reference is released. Callers that are not confident that this is
safe shall then use my new iput_safe() instead of iput().

I can write such a patch, but I wanted you experts to first confirm
that this is a good idea that would be acceptable for merging (or
maybe Ceph is just weird and there's a simpler way to avoid this).

Max

