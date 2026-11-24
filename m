Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93DE7606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gU072qSB
Received: by kanga.kvack.org (Postfix)
	id 9EBD26B0834; Tue, 24 Nov 2026 13:45:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C44F6B0835; Tue, 24 Nov 2026 13:45:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D87E6B0836; Tue, 24 Nov 2026 13:45:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 664526B0834
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:45:14 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00D9DA0D0E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:45:13 +0000 (UTC)
X-FDA: 85470890106.09.9970B78
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id EBF57180014
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:45:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=gU072qSB;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795545912;
	b=L8dNQN3MOi3F9gxUkYr3jDcwM8zkLReNQW4gVAWNeo+pLV0vggE97hbfZ5t99vmpJwS5y2
	A0Zur9sAQNqScIG/m9mMuMsHbkK4jPP4eEY82stNpSevP6lQyKK2nGj7iJhs8w4mOW1eEO
	xTxjZtI6PKT162cxkTV8CRSpw5dbJ8I=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795545912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eVt63sFAXFALqIi2TYrbUsERABkXRLEjuN5CXIXLcg8=;
	b=IIe1BehoklRm/z5e0MQE5jdgvehVdlo8j6kuHd440Z+vHH0Kx0IN+yW6fXC06lUS/bgC7G
	xpVgw+rfPgKLmIhVj2wOB7KHi3IEiCHgUAvLNN02XKGyEx+8i/cjDy7+9/Fiot4RhtcNJF
	IR64xTrSQ+N+zOupi3iOtpiDQfpaZM0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=gU072qSB;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4bb5b33e2ffso126665e9.1
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:45:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795545910; cv=none;
        d=google.com; s=arc-20260327;
        b=TYmzaqMI5OVNB/CrZYvhFje4ZfEwa7ZQS/qjQ/MF3E1wV7xevj2FSe5Vft9wtsTfl5
         cdHqvr4Id6q/9Rq5IpM0CUyEzY5jLsCXFF7RQK0gHkiM9IL00MyQPJRf2PNHHFlfCb63
         nrbFgwMq3OTHEfC/Ko7eDc+tzM7bfiPOT3b+prIrlPykww1+LFvVbHAUnC1MpvVLBljE
         HeB2aV2qu43WlmzAxGrKNOv0rml+/UGuBcVoTSmOXioXEgw1MNQIp+g2kUaNBXSsEPbc
         dwYnM8Mudum6sHYedIPB8zvKS2Q1tqV3qzAEWvyIyVAI3fu9jfywbpYqL1FcYChKX0Gn
         Kk8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eVt63sFAXFALqIi2TYrbUsERABkXRLEjuN5CXIXLcg8=;
        fh=YNhPopC5vahxvLMU/SN92SC3qhbPANFPlgU/yblL7hE=;
        b=povUDr+/s6m4JfXgZZchtEPRHHi4v3gNcM4ZA6CrD8bqqczf0TtpKi+iNpH6HL23CP
         4s5loYtfbokNU+ySTW45IqcasBN5weL90p0z/SGmlApRKEoUHd7RlNRxfJvROwYcBV2V
         p1eU2DMf4TzlZNZO5i1NasXWvcGtabkz9Kfw6g7tuX3WhPaObpBkcj2vxMHrPonM/NRl
         7CyJQKwNNdHySImWkgkm4QokrBkt+ioJR5w3d/k8N9dMiF5p8oxGwbHoAZE/iXTcexux
         jIvX/DHW/RwPV0lh16iRoIQv54slYVxEH1z4ZJ+mprzOPfaRh7P8/jk73wthIyLKZvNj
         dCCw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795545910; x=1796150710; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eVt63sFAXFALqIi2TYrbUsERABkXRLEjuN5CXIXLcg8=;
        b=gU072qSBFXjV/4ZAeLn7yGr7sofW8H8nFRyC4ZKTBf5koWiDji4CHL/ZoqEdHmpM0u
         kxCinofI0iD9G+4Y7r1ZkGutXnqmvitXtZFuAJwLa1SCNzJF/NWlrdAeIALpaJlT++gB
         g2Fs6LtLjQIVkldTP5p7ylkcKNEdiOgV3HLUENSdzrfd4nkx3OOI11B5mFcuydxDfPVi
         vAmv88w+aiioqc93OqdwGE+dO0TKTaczF/sJZA7sSMi1wH36BpoeT5DQhfy1Px6RlfGC
         wacb2vo539vPyDHu6uisJEQCkTTdNw8EjEY/Sm9PPBAxctPfRqe/gUDMiQCpSWFjOMwv
         8tJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795545910; x=1796150710;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eVt63sFAXFALqIi2TYrbUsERABkXRLEjuN5CXIXLcg8=;
        b=UXpV0NHvEEQ+fbP0cAbGg1uJIwsmWx0DKb1BqeA5NL3gESFP+AUecTjPa9YWXqAt5O
         t1osXV6znTX5Kruvc2Ky3mO7NGk/q3ay+UFHu/mg3zOeRqbBxO++bhmXAOfoZsfRaKO+
         nwz/SnD0n0fmh2gR4Okg1vzIsB8Dz9ZIdobqzK7CcBydy7msxcGMmoGRmP0qoVbaqWNL
         DXK0nST6OGoOzYlQAH4BeSef6tGU3F5zG44/qDkbF0VUaq69Yt9aD8nJKSco10ZBhGNx
         aB6xqhOgghmrcwW2WIMAd5ZNDD6IabsuTAlYyObuJqRgY1bgjJYDbas9pCjwHgtW5zGo
         mCZA==
X-Forwarded-Encrypted: i=1; AL+hErH+xPZz1GOypi1cYEbIpO6Pwb0RGgQttHwZ089dMdjYiC1yvEavKkmVCqMblf6MfBL9js41phf9pQ==@kvack.org
X-Gm-Message-State: APuU4Z/qhI0PgpzIJ6j2niEspITK6q/86lNwByKk+P+np+ksptd2HvD5
	iyy74v1xLaeAVPb1+Dr5kUedLxyx0Mpf5nNqyiDtT6oMoX6O5BsVoVq8NHv0KTdyxvkaHvlTP8C
	CWHq3cOvLcb2+E+uLbN2HEZfLuOmpeqbgQfW2tmac
X-Gm-Gg: AZFdTZdR4mtuCcBL7sVzenOAxmVW434eN8Gee3dT/O2AIEFhulCexZm0GzFa7JfLr2L
	8uF2lgeE+Z1S//JmMkX8MYljCGdrIb2Lr6q+IiO4W3rSc8Yiasqlp5Rw2JWks+oBWR/iQrcX9v7
	lxwudi1siAkPKbvoVW4lJN/MqFfAdkyXE1kpqT+OZVG6gepAmxi6VOwWb+UyHK2XruWmLh1Np47
	w4MMLKF4nT6Mu9s3QCkpFqiHERZqkU6BWR7msDfdF2FYR+CTj2Sd1SkWIAeVRtFYwjaOjLbJR/Y
	0Ut+7B14V2ThqaMKto48ctiY4zCsZJ/V3ti2aBmZYEOR35Hlx2fU3YSDpXPh1yyQg+1ooC+kRxT
	QEdMOjqHmjVina8nq0z2But7YVmGNT24en5Q2nBVbNztNyuFTsGhjTBsax9riSCxhcRV3C4Rnsn
	u2Bu06Qzww7+at9LEBxeps9TY=
X-Received: by 2002:a05:600c:5346:b0:4b6:7744:f4d with SMTP id
 5b1f17b1804b1-4bb916bdf08mr2257135e9.15.1795545910040; Tue, 24 Nov 2026
 10:45:10 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org> <20261117-huge-pfnmap-fault-races-v2-1-276007e73bcb@kernel.org>
In-Reply-To: <20261117-huge-pfnmap-fault-races-v2-1-276007e73bcb@kernel.org>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Tue, 24 Nov 2026 10:44:58 -0800
X-Gm-Features: Aa3M54p26FbeOYUnrfBkiQh43qYkPRTQzVHFI8sjfXLSBe0jiLLjZbk3gYWYOKo
Message-ID: <CABdmKX2PQu7VvJ_Xs9NpkFo-wD8LWxO+FNqmdTEZBt0iAd=w4g@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm: update walk_to_pmd() to explicitly return an error
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
	Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
	Roman Kisel <romank@linux.microsoft.com>, Saurabh Sengar <ssengar@linux.microsoft.com>, 
	Naman Jain <namjain@linux.microsoft.com>, Michael Kelley <mhklinux@outlook.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5rewo7s7j8x6zxd74u6tt3jn97hj7a1b
X-Rspam-User:
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EBF57180014
X-HE-Tag: 1795545911-476991
X-HE-Meta: U2FsdGVkX19e9fTyWYmGSpvm+Vk4wZHIqmVCR2PzyQY0IbBUTRsTy/g39/bXp4E59KUDLZGVv9d7KHnf+lilwjPlHnY/qHqiRG0nM/byoT0QKibSDX5XHm3MIm1WpAlgzUHKK9l0PGQmuUKHr96zraht4q433yFb7DfszWdAVl3VZvbOzuoaWAnHGy2n19V6Z0oHEq4B/RGabJ09ymsktzh+KXT0Wg8qYQH+MxfKXoH9HRsrMeYjFyajMGOFGR90B3GHZxAnbC/3LPolQsRsDYdxNHv7S7l5D0/L7nVWQ3motN9q+26ShUxWO11wQT0OJigI7eAUsQKnFogLM82ZLCH83b9c6rCyX2nekQKU35jm8ZPm+K9qrwemgji6/0zllyRPO5PGAUVuiIgfE7luTH5h1KDdQBj0sJZ7HYNIQhHtddmxRT49M1+lVWbe18LXjeMRkFITzPIlN+h3JJUPX7bmkkFdxDj7CIL4V4e0yiOOMMkXKDmtS5kfH6ji/re9lRPAjxpmX+oWhHcysGPvSwwF5JczuSXOi/s75kiR3miemIdzBXaitO4ybSaTKDgtRVfgfCUua+45lKoyP9BIAv2d6fpon+2ADEohl1R/2eaxSV4xFFX2QziSVRVN2EVpykm1A78OHXW0NGDULrmZGASEwbhhJCw+Q11mu/HMAe1v7/lcxM8nMhnjO5oiJKddN4t3Li9ehWoo0m1+0a8apIrhlO9SiUj5xOrCfYpakjTqrEnbE1i0zqhsLfzagg1Y84qJrVVHL3UyTO9rSAW6pgvoAZWc/HgQ2aP8Z+huEXdcvD2HBVUsoA3UCBduk6i/nj9KL2rLKYnphkqGM2TPYjEgwt9QjkSZh98QcmigAk3a4oMS8HoopSCjJRfmn/Ur9hqI1NtyjdNoyEoJpB4dIZwcfu0CirfdbG46rTbNUuw+nBCRYr0U4O4S2TwyGnSFMAjvVLm0QIydRfrgUcX
 4zkw2EHV
 e4tW0xkHWJjGxvhsiazd9l98PKvvD1okuOnOe//AG/3AZrJv3pnsuFJUiOjIEzNHrxKGLgKWpPvRbWv5FHUgaB31nZ2Ce7T/wzfj4ZJrFgVcv9zDXPxjdeu+QVo9kVALGHUBOgB5/f+snyyItTLX8lDbJ3XMLCFDXSpq5LRFD8wDhk4XU6MShX4v/eSYXU+WVhuZgeiJIyeHvpYnCzJ1o2MWD/yJj/LDgVjKEkH/qjEkNWNln+7n1pokbM4oqekgWDlbuTxQUXYrPQZqwM0QPEhbXQv+ZagbXfHglXm01ECeZJCx1WnXa6xqHTyqITZAwGdI4bKbeIko4LpAA4Lb25v2+2pf4GC7JDgSX5LTnR0OQTsRw1mtj4vETXa0nJ42lbueSKK9X/4CG/fq0o1HB/U2e6G6l0mf8BXsgxMTcTXoJRrVOHwZpZZKl0S5iUvV17O9gHK8ZC+NJitEH4Bsb7S51Fvb0xm1/+NKWr4bbjMIp8bMUS5eTv4JqcDNOSe4Fngc8wBdbnsoW4/6nL5/EWV6ChVIUp3Lroa4EfjfxN5SeqQ+wwY3fUiFWKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 10:32=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> Rather than callers inferring an error from a NULL pmd return, explicitly
> return error codes.
>
> This allows different error codes to be returned for different failure
> conditions.
>
> No functional change intended.
>
> This is a prerequisite for the fix to insert_pfn() which follows, as that
> needs to be able to tell a failure to allocate a page table apart from a
> race with a huge fault, so mark it for stable alongside that fix.
>
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: T.J. Mercier <tjmercier@google.com>

