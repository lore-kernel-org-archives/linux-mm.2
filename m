Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF44CD68BD5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 04:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAF736B0088; Wed, 24 Dec 2025 23:15:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58EB6B0089; Wed, 24 Dec 2025 23:15:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30986B008A; Wed, 24 Dec 2025 23:15:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD6BF6B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 23:15:45 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F429B9E01
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 04:15:45 +0000 (UTC)
X-FDA: 84256679850.02.343F655
Received: from sender4-of-o52.zoho.com (sender4-of-o52.zoho.com [136.143.188.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id F2B48100003
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 04:15:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=VtPP2esm;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf14.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.188.52 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766636143; a=rsa-sha256;
	cv=pass;
	b=3VF/hTv6AIgR71jr5Ucp0Q+i4anwQ23sSO57zT/MYY13oY+qocRUblYZl+gv18EyIDFVvg
	TKlLzOGjQAWHiU2TWcCYBNGGDh9LwjoMAcmJv4rle6Z92pb6swcDR3869xka/du+4OFuiw
	SEQaFFFUo/qZZw0+miOQwmDBVZOHGq8=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=VtPP2esm;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf14.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.188.52 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766636143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=En56k355+h6jvrDLlFr7qoTzHrfLKklZe97f8ari3Rs=;
	b=T4383hMJYt86rcPepVLrmdkOOwf0C8OVP/ZUBVcGbHTeswyRnly6FJ4lBDF/jGU/DnHuLP
	0bIT3dp1eTgm25izIBB9JCcG6DoNMA7FG5Je7tr8tMnrIaQKOo146detY1ckPQKfe8fcVW
	yf62JjlqEOEbUiBSc9RimUrqwlwIfT4=
ARC-Seal: i=1; a=rsa-sha256; t=1766636127; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ZTAoD8k3e5x54K2r3e6I4xg7TJj+5JxUrAp/MNkDuF7LkUpLGGP9EjBq1sGQxOFiO7DvM3g0dPiKruZk7Wx7UBSev6MRUfdUupmFgAVDncV/wSwp+Fj6g0C4Ha4SCQYmXMCd98ZSjTp7QjTrRuN+AKUsYBKW1MnlSs0PhEJhuzs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1766636127; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=En56k355+h6jvrDLlFr7qoTzHrfLKklZe97f8ari3Rs=; 
	b=gLg8MdjYhYyvcrjhd9rzBeLAnInKK6bK7uiSKYwPjJdectsuQpu5mSro/t2GLMNBLXNwFjrJuEX42/L7gnDz2QgPxBm7A26x/vq7ToVA6ZQV1LH1T0IU4JLSyHYsWDA2WGRrvv57+1Aav7Mh+rP6/28Y+Ps29tc3tqq4LSL6MBg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=mpiricsoftware.com;
	spf=pass  smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass header.from=<shardul.b@mpiricsoftware.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1766636126;
	s=mpiric; d=mpiricsoftware.com; i=shardul.b@mpiricsoftware.com;
	h=Message-ID:Subject:Subject:From:From:To:To:Cc:Cc:Date:Date:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:MIME-Version:Message-Id:Reply-To;
	bh=En56k355+h6jvrDLlFr7qoTzHrfLKklZe97f8ari3Rs=;
	b=VtPP2esmCZun/qqTOpz/+Z4su++uOmrG0ldjJNWaO1XcISlU1wLDnr7bgx91f0xd
	BXTaDXFFP5Kre+FkJXw+3V0BjPRs2RgffLkhPuVCjOZMqRyjXuLAbhly7v/hVfjeoc8
	x1fE6IJwykqkSrpTNv1n4oPHCznmWs0dXrn+ub4s=
Received: by mx.zohomail.com with SMTPS id 17666361239511021.7792756869057;
	Wed, 24 Dec 2025 20:15:23 -0800 (PST)
Message-ID: <308b7b3c4f6c74c46906e25d6069049c70222ed8.camel@mpiricsoftware.com>
Subject: Re: [bug report] memory leak of xa_node in collapse_file() when
 rollbacks
From: Shardul Bankar <shardul.b@mpiricsoftware.com>
To: Jinjiang Tu <tujinjiang@huawei.com>, "David Hildenbrand (Red Hat)"
 <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew
 Wilcox <willy@infradead.org>, ziy@nvidia.com, lorenzo.stoakes@oracle.com, 
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev,  linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, shardulsb08@gmail.com
Date: Thu, 25 Dec 2025 09:45:16 +0530
In-Reply-To: <a629d3bb-c7e2-41e0-87e0-7a7a6367c1b6@huawei.com>
References: <86834731-02ba-43ea-9def-8b8ca156ec4a@huawei.com>
	 <32e4658f-d23b-4bae-9053-acdd5277bb17@kernel.org>
	 <4b129453-97d1-4da4-9472-21c1634032d0@huawei.com>
	 <05bbe26e-e71a-4a49-95d2-47373b828145@kernel.org>
	 <a629d3bb-c7e2-41e0-87e0-7a7a6367c1b6@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
MIME-Version: 1.0
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: F2B48100003
X-Rspamd-Server: rspam10
X-Stat-Signature: g4yu9d16ujzagyw5qoxirh49zti39ccn
X-HE-Tag: 1766636142-935969
X-HE-Meta: U2FsdGVkX1+cpMdLrUmUYUYUsaRamtuD0cSH/7mjb3iarnV3yNT9ccMib/gLjZkUTNCy0NdEmTbhjBp+ZNIZOUji/SLcE7ne99is2RP52nWbK7L/z55aeQdB/leAuIdb8YGK+r6BIyggJ9PThDOrwVIMUzYjWubxZml4mkPFxf7LlCPMCcfZPv7pVT1mxnlzEFrTfYmPTjy7WCeDgIXKc1Ur7XUwCk9s1Bf7rNOkEKVawpjGhggejuPcAyUxvwiT8yVsqdcHIFv7z4ojMV5JW5lntzFe1r6BXQhMJ7nHsiwPkGA2jEeJQOJe3riZcXeukdgrrTTSV8NJnEV+9R63z+3GoZeu4xVQShUaG5QAcFca0kGhx2Vi5ZRJVDTku6puxDf6+KJI0R1uY+lwRwwtkUryulxS5AVjY6egoHmeWN4HrBh94vTWkX1qAqCLDKlu9kr17u+Km/n9G4Wx/ZEnXCMFg62xzFSH5jWObyXrrw+9N3Ld4sWt+lNsl2HZz+Y4CjRXouZm73XdnjV/BJDD5ZFZzdzSsEBoc1/YC1VWHB+meGMwQceOPmHXzSXsyHoV4ePUwwyp9ujST9gADH6RuoL4U1fIkoKMoH1GfgG+/n+5KzvM12N6u0eEKup0sVUBHAYTNXvzYFtj611AihXrZ4ERJBUK4/NRpJPIBR6wR1OVyMRVyHMM0fgI9oY8rENQybbRuDbUi8Yhoijlcg8flu6JcURc32sCzQQVIpc8T+4xsBMFUFXb/jgnlAvcPalMJprMBR8DWesBBawoBEBFi4zddpmn8ooCvbYdfI0wsrxbTFlkeV07TLmUGAHWTo9sJ65VwRodC4ogRdCbBdl0/EICHEYUkqP0Ltkz88uyhQJ5sMchbheIAiSki4AHAlbZrXcE1l6EUgyrDlnHsqY33FjSf+N59ZdRJmFRKr8cGPq8+fphtmXnx/Ql2ytBYkzphveaXiftYR5FY2gmrjA
 3YEr+E0Q
 9Hj8wdd6mnF1585U7kFL8mRDMYflZ4nO99Xox3tshK+pK7yDAf1ES3P99P/EjS2SqvNqqY+KEPeG2eTgbzD8dqY+hLJIig8Em5LHf/y1FlntfcASBYF9yp5YUNbtcPjGeSDcLai04j+vC1mYXWx6dP+PYScLpEU5ks4OFLN9AnDjFkCnt2h1dPTczgv3a+j/+zNE6+MTnEfF8PLrYGSca+u04Wdm8++HjtSYlZs3lE0++SggEDExmT6XpRwzmD09DY6RIXR2paTIyDbG4iOyy8CckEBhOAB/vfzk0w4OS7PLKk0EhRdO0GL1JwgwNVJxpz4dMSLasTb51PTc5skqFyLhrjwN+qBQy3W3vAaEXzLWDUO5J3zuetfUox9M8mXR3LF0ulIn1zWxM2KdU5pbBQD2X6yBEE/FaYrNtsfVLB175af/dOBjUPgDIOOFKfmh2euEIYHJ3xh0Wz3i7yXUmkw+uhe9+dj0thllQYU4RF3t/WLGfx/w35hkPj9OhE4B6Z7g6HosPa5N072LRiKfytcoRQFJxE/kLnN68XeNt2vGu+zSNv2i2nfbpyJ3Qe+YbpSfA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2025-12-18 at 21:11 +0800, Jinjiang Tu wrote:
>=20
> =E5=9C=A8 2025/12/18 20:49, David Hildenbrand (Red Hat) =E5=86=99=E9=81=
=93:
> =C2=A0
> > >=20
> >=20
> > =C2=A0Thanks for checking. I thought that was also discussed as part of
> > the other fix.=20
> > =C2=A0
> > =C2=A0See [2] where we have=20
> > =C2=A0
> > =C2=A0"Note: This fixes the leak of pre-allocated nodes. A separate fix
> > will=20
> > =C2=A0be needed to clean up empty nodes that were inserted into the tre=
e
> > by=20
> > =C2=A0xas_create_range() but never populated."=20
> > =C2=A0
> > =C2=A0Is that the issue you are describing? (sounds like it, but I only
> > skimmed over the details).=20
> > =C2=A0
> > =C2=A0CCing Shardul.=C2=A0
> Yes, the same issue. As I descirbed in the first email:
> "
> At first, I tried to destory the empty nodes when collapse_file()
> goes to rollback path. However,
> collapse_file() only holds xarray lock and may release the lock, so
> we couldn't prevent concurrent
> call of collapse_file(), so the deleted empty nodes may be needed by
> other collapse_file() calls.=20
> "

Hi David, Jinjiang,

As Jinjiang mentioned, this appears to address what I had originally
referred to in the "Note:" in [1].

Just to clarify the context of the "Note:", that was based on my
assumption at the time that such empty nodes would be considered leaks.
After Dev=E2=80=99s feedback in [2]:
"No "fix" is needed in this case, the empty nodes are there in the tree
and there is no leak."

and looking at the older discussion in [3]:
"There's nothing to free; if a node is allocated, then it's stored in
the tree where it can later be found and reused. "

my updated understanding is that there is no leak in this case- the
nodes remain valid and reusable, and therefore do not require a
separate fix.

David could you correct me if I am mistaken?

[1]
https://lore.kernel.org/linux-mm/20251123132727.3262731-1-shardul.b@mpirics=
oftware.com/

[2]
https://lore.kernel.org/linux-mm/57cbf887-d181-418b-a6c7-9f3eff5d632a@arm.c=
om/

[3]
https://lore.kernel.org/all/Ys1r06szkVi3QEai@casper.infradead.org/

Thanks,
Shardul

