Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B80560A6F71
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ARtF1On4
Received: by kanga.kvack.org (Postfix)
	id 8930F6B05B4; Tue,  3 Nov 2026 05:15:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 863326B05B6; Tue,  3 Nov 2026 05:15:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779896B05B7; Tue,  3 Nov 2026 05:15:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9666B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:15:00 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3138C0382
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:14:59 +0000 (UTC)
X-FDA: 85393399518.01.8AB68DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id F00CF140002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:14:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ARtF1On4;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793700898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jqwECtvJ6u0WXCetJHRwIFMx9iKDN0fT5jXgsr5loWQ=;
	b=T68QHevRcyrSVIVCeNFLPDws42bp7uZZqNy96sZRDmDLvmSuRFHW+PstybNG7gAoSWl02U
	uTsQrxT02lnVu6VQ8PUBfj2vYT9He8wYXFj+IpxXpSw5huVHbmU2a/nJBE2Vmg66lYwC3x
	FeO9xkqDVOaL9N/ZYI9VCJAmcW1ICpk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793700898;
	b=eCsiSOwK+KOaE8ORLKxKPm5ElXt9IGv7fzTiR7/QcSQ+cBjaPL/raCUyP6bEac3lE0fO2k
	RCF6KAes4b5SncjwzVjTOe9G1900eRnrPlx9FoIfg4I0xDuTHuWbPsRODD/Yraq4MguQTg
	PWZrOuCA2LrewSnK93X1kUJYLZ2WrCY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ARtF1On4;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D17BE43CCD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B820E1F00A2A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793700896;
	bh=jqwECtvJ6u0WXCetJHRwIFMx9iKDN0fT5jXgsr5loWQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ARtF1On4Y3++hq+BvsbtHb9HfZ2OJj6B/TvjM1lge8G9PyPscyMjkYiubFnS5tI9S
	 Xr03vbGBjVYXG+7PnPlB62hQRupMEEiHFSXEyfyBPlo+KJyQbj5Z+XtptO8OV1t7xB
	 0qHgmAuRpmxZAC7d/NrggXosVlnpk1fwAhZmo8pqDu5cu0sA1Cj42GM3c/ONn7F7xQ
	 8gMSFdXiGrl1nMPgI0CPsFQLVfK7vc1B4Llq4bTgArgSYDaQOtuPm/jU5brdnN+NU2
	 1rG+zZrVX/XiRfuUYwf9AuAEVYgERIkMruNtEV+UBO/CiMy0J1JFAUcJWz6TzxBQYK
	 c1XEHAhwQDkTA==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93ece7a73b9so531421985a.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:14:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwqprx6j9/ph69GPubVuWGnqraSUQpluhn0nribgwRCSMtTVbRp9ZumTKGpHl9VOBbjnaaipVQ55A==@kvack.org
X-Gm-Message-State: APuU4Z8N3bjWCHTccgguMjBCYRWSSLU61yKj1iYa4Q8Gy+afjr/+2Ovp
	DQXSfu81Czzl8PHXS4ZUO61UWaa4gZCmIe72+RL/bH53RYB6SUp2rPPJ4m2nxv/gJ7AMzA3ur9G
	CmsjCFOfz80EsfOytiHTBo7cS0FPlY70=
X-Received: by 2002:a05:620a:8395:b0:93e:ce12:aadd with SMTP id
 af79cd13be357-944217b270bmr1858889885a.58.1793700896121; Tue, 03 Nov 2026
 02:14:56 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261012205447.2717801-1-max.kellermann@ionos.com>
 <20261012205447.2717801-3-max.kellermann@ionos.com> <CAGsJ_4zQh9HrvgaqD32_A=bSdqmPqP4oV_SxMXMEDBrHe4jjhg@mail.gmail.com>
 <CAKPOu+_coR4Z=cbsWOG6zgbSWGvmp4=9=uUphkC3TWTTGn0Pqw@mail.gmail.com>
In-Reply-To: <CAKPOu+_coR4Z=cbsWOG6zgbSWGvmp4=9=uUphkC3TWTTGn0Pqw@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 3 Nov 2026 18:14:45 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zOnfjsM_jR-hdeH4YwqKgRYNwj5pv8sFJz-0sJQqojEg@mail.gmail.com>
X-Gm-Features: AclHuK_R4FODI0ZSMjhFi0nwMKEXiaxVpKfhugt2bmG4DXnFW2ixLEichw0jm98
Message-ID: <CAGsJ_4zOnfjsM_jR-hdeH4YwqKgRYNwj5pv8sFJz-0sJQqojEg@mail.gmail.com>
Subject: Re: [PATCH 2/5] mm/vmscan: move code to lru_gen_{add,del}_memcg()
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 4dqq4bhnbzac39xjqd3w67d8jamht8pr
X-Rspamd-Queue-Id: F00CF140002
X-Rspam-User: 
X-HE-Tag: 1793700897-3379
X-HE-Meta: U2FsdGVkX18vCowUVtAS4i8gPnFek5jLLnTHD6WXTPX11sAuV5jkT3eWxERmhavBVO+bD5aQCNhFCTzH7dlOszzUCb1RMTe2iUyQezDfjB8svQ5PulGaBSbpyenN86ps4hiJASyu/L77cD8NymxiATjcpHukw5qQkt4FL+BMqhn3evGQpIAAR6MSBpkS5y50rc0hLJVFq8n6z1/TdIgq45/ezgg5HbsBqTsNsQ6kjj87KDvT0oND7gZo0AuMlDQkIkjoHy4sYQSSyiSnA5zhjIhoMEjYw+6KUTBrAj23K/R3fF24+jrGn5/K8/Xkajejwyd0zp+pTFVH5miLT1Ra8cIL/6ed4MhZZB8AwqKAqr4Vkz/9mgMO+OC34ucR5De/aHlESxg6o9dDrWaeEXBTY50SXc562UjhauAYWIil8XDOGrquIyhamj+m3GALffEa5+1yvOoOiMFb5af7xj+bSKlwI+53+xRQzubYFTp/rSecKx3A48YxYHOF+k0gmHxNa74Z591jXkky6Sybl31tramQ6p5uAlO/T4ALfULbS05thoFcW15/LxQsbT/LUHPosCPrk+jvb1tI5b1ghdg3xdfYsdJrdlHXuzo5yNnFXvIZzHF6fUOKw8t0e7eJ6IGaawTNmJjKPygMW7d2yr/WmmBPxVxe+7F7ygsrI6M7LiNIaYJ98YlcSjiLLx1aQOMNR+BX3AZeZD/zcZKeB7FW0WzmaLLg3A3FFL3Sxxa6LIFBQ3NdlkDeKIJ9dy2sJP2Ecn9bUrl0IEbW6NANvGKBfu1e47gOhLDlni3VbXWoTQxGi3dLKyGGTfNag6XBY0NZmuC5/XNFrOaOylzuAm/HBWLoXMaqUZy8QZqJgy7T1UJHLmEXoGu9LYGwvkv25RD1oYgUFHz+lLHv417A7+ni4v/uuSmfJfTE1S4MVKjq7xRXJwrukzMXHYlUen2CNLFouBt1nhj4w+kNkb+OHKq
 BAKOfxIr
 SoKorcIPd8/sM4KAuVd6GlZoBadbASSPRlsqnuEqLJ4UUDlDPEzyg147cNJ7cS7UfcAmLn/U9OQlEHG+OnyYyB9d6gZGSrW68I1i4J1VxbCyaQ6ZjkYLc1ZNP3cuAPOcZbWubfTwIM2S+coWvJKaN7dzfTPTglYnALdMM6z1MM1HG85Bw8dRBA/hR2dHq/VK63bJ1ZsPxukOCyUZCaxDjUamKuIUl+0TxyWF9lUFg5fXYHmYvr3d7sXLtCraEPdbZpDsOUJdzetMWzzdm41ntU1qUC+/stSDCII+Ejq2PJZiPKlXlAkoatKncpiezbjoV1Uh081zGubtCqUGRZVNaV08IjhilOZJ80/i+fb2y6uMRFisAssLhTfJt0EvyEj7MYzdkwPvZN/SkQbVPU420JiIkFW1Mt6ZO1G2X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 2, 2026 at 4:27=E2=80=AFPM Max Kellermann <max.kellermann@ionos=
.com> wrote:
>
> On Sun, Nov 1, 2026 at 10:03=E2=80=AFPM Barry Song <baohua@kernel.org> wr=
ote:
> > T.J. series[1] removed MEMCG_LRU_OLD, i guess you will need some rebase=
.
>
> Aye, will do if you decide the series is worth merging.
>

Having to find the TAIL seems quite inefficient.
I don't see why we shouldn't use your approach.

Best,
Barry

