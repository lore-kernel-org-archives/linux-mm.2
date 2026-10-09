Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6344BCA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 12:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740466B00A2; Fri,  9 Oct 2026 08:51:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0896B00A3; Fri,  9 Oct 2026 08:51:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62DD86B00A4; Fri,  9 Oct 2026 08:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 436506B00A2
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:51:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2D654036E
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:51:01 +0000 (UTC)
X-FDA: 85303072722.10.2A7FDE6
Received: from mta0.migadu.com (out-137.mta0.migadu.com [91.218.175.137])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2002B40007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:50:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UcgbplV0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.137 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791550260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTlpNdCy9Fp4DAC0se8dvmOA2/CgJ/3brp8BarkW9zE=;
	b=IweDLw2dbuQ5nd+qDNZLRJ9C7Lhixq7aHgyb3uBwKQA9EdhW9xQTOow4mmkl3SPbXc2Q7q
	wOgRS7l31rhI98V5C5otrO6DtVT4bGLtbo5JQmD2LpsGDg90bjCFWmmPxikFrj8yZOpOjY
	F7ppzNknDts8hioL2JoRKTjCjyb7y9s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UcgbplV0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.137 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791550260;
	b=A1gVfjq8SMqBHueOgNwhwkM3ouQSodrw76ebh/twP2+MhLdbxxkEgMBUUBrlAcj4v4eaLa
	8uY7nmxX4x66icl1rjiv0ft58QTzPzpdDx1y5gZplRN+/ahRb/ARDbqntD+g9pgLICEBM/
	a3Y5W/XgU0MXeWo53NfRzESTOtkXnyc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lDUj4mkLtrImvVcsiqCP2Uim2o1Ybt71xn1xDrpS3t0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791550254; v=1; x=1792155054;
 b=UcgbplV01cWVfYAM2wEzoYbHbnndJLiuw/YAv0/pX0ifc6k/lJPb04XF0xRLiSXDKzCRMlC5
 IsvQJ4VNDC7sPhGenlMzwuMAGfMJxbqNZT3wvfKkLoKyTtazEiakFryW8TrVl1LniJPYW/31ZoX
 Mc9wl23ZV0ZAWVxpQbbTH12g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a0ed347038679126;
	Fri, 09 Oct 2026 12:50:48 +0000
X-Mizu-Trace-ID: a0ed347038679126
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] mm/hugetlb: drop the empty register_all_nodes() stub on
 !NUMA
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261009092832.393778-1-lienze@kylinos.cn>
Date: Fri, 9 Oct 2026 20:50:33 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 enze.li@gmx.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <286A8A23-C420-4393-ACFB-361CA14BE316@linux.dev>
References: <20261009092832.393778-1-lienze@kylinos.cn>
To: Enze Li <lienze@kylinos.cn>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 2002B40007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: gnhohgxmpouqx5y8sg4a93f6d4mm357a
X-HE-Tag: 1791550257-972846
X-HE-Meta: U2FsdGVkX1/KMbbNQQoD7OdI+Og+0Zq7OYlTcndnVYbmu8O8coHTfvlDhmLGH4ILJAHUtA4j4PzLPDNta1o4B5C2jMIl2X20dlKbsdZoueKTG/Z4jzRbPV3Ew0YE/g0i7jiVGnelELD+oDGEyBePZeXby/Sn+yGgHA3y/i1LAEtiZxpVCVzo4m8Jgo27aPxxyYNGB59wCw+AQQ8Pd4vcaaZcjiUGBllFDczeGSt9oXSpjYimxNdzMoJN0h9+PPyIQEg0jCXeqn2HlaHdqWvmD9K3rWmcnd8XmTd8Sb4B6ZLjV/OAyCsmbyhjJQpwjCohNA35Q3m8KLQV2/+z4ktAYFSDy1fDItaLvPlGUESdzsGlXLJtI1XcsPwoMHcwqQwhQ2pdy6oK+eHODmkyyFsUC2D9TP+J3Sdn4Eil69c0A/7OZBIfUefiogj/A3+LnA1YRHLkRRXi20qCUI9mVlpIb68gx3qocbmxm/WaBTCw2m78LUSXa7O2QtRCs2P0HZC2Ygoh25+BwfrucHrzhpttLmZB2wv34ZmK6DLVDcOtq5+nMH5Sr0DWhbCKL32dzBHtBj+RxKDVEg0jTc8Hvp8w5N75ajpOYt8BYzXFYye5xPITRwgml9qqh5I9UuVn7aGuRQkf/dCh4tY1uJ3oY8UTe9nvcX3BcMZeb9En9wF5Om3M28srs7G2lcfYRzlIzGpbdz50/1qBZa7xGqYOyC1/Rn8p8/qjjHKSflgNBuV19ssYp4y+4W5u7USPjE1k6NhzNvIGe+Y+sfO4MmlL/NsVnwSMPrPaL8Ma8vnJH6D2jgCyfaxI7ipjisaBNMpXKKpQ5cna6ANob7vRtTri+IxSOccBH2F4W5nW6AutNxecxU9jSg1oqWp1saMndz4vKQCfoFkJjKdRtEBIF4mGTVXav51KwcojQKqH5mKDNSICjjMkUjuKLizeUDoIckcSEQHGzFKSSgQf08JMg51FcIg
 JcYtibLq
 qVkKWXgaqt6pes5WYhsHVjyjBgIlc6JwX8rYoYflw8OIVKHDwHyjm2e/AwMbP/AeBHRVBGrnDCtpMx7EpsvHBWngtCXLpba/VmLpxrfFSnXkl83TuLNyHXlcDIeht/E8sP0gFanlLoNKkvsTFSClIy1B+yzj5mgGja8NAK8t9yCq6ZJuFONaVJopFXWZsiTv6zndayBqscRUgJnwbMFIU4yKCqqodqtlGt5V1lgLDRsb1XF9/YISg/smgXzCqmsdbux95XtIxdiO4JRF1+faFD3qqpfq44U39fj8ePSkFomqOwKQg6mtBO1JHEHPQSox2iBHD4Ackh7GH776sVqWgXUkDZ4ZJ50mSrOup
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 9, 2026, at 17:28, Enze Li <lienze@kylinos.cn> wrote:
>=20
> The only call site is in hugetlb_sysfs_init() and only matters with =
NUMA.
> Drop the empty !NUMA stub and move the call under the CONFIG_NUMA =
ifdef
> instead, keeping all NUMA-only setup together.
>=20
> Signed-off-by: Enze Li <lienze@kylinos.cn>
> ---
> mm/hugetlb_sysfs.c | 4 +---
> 1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
> index 326a54b4d991..de439b3b7f01 100644
> --- a/mm/hugetlb_sysfs.c
> +++ b/mm/hugetlb_sysfs.c
> @@ -475,8 +475,6 @@ static struct hstate *kobj_to_node_hstate(struct =
kobject *kobj, int *nidp)
> return NULL;
> }
>=20
> -static void hugetlb_register_all_nodes(void) { }
> -
> #endif
>=20
> void __init hugetlb_sysfs_init(void)
> @@ -497,6 +495,6 @@ void __init hugetlb_sysfs_init(void)
>=20
> #ifdef CONFIG_NUMA
> 	hugetlb_sysfs_initialized =3D true;
> -#endif
> 	hugetlb_register_all_nodes();
> +#endif

Actually, I'd prefer to keep the stub myself. But that extra
"#ifdef CONFIG_NUMA" is really annoying. Why can't we move
"hugetlb_sysfs_initialized =3D true" into hugetlb_register_all_nodes()?
Then we could get rid of the "#ifdef CONFIG_NUMA" here.

Thanks,
Muchun

> }
>=20
> base-commit: 8b38ed9ab5b09c8ba168cbcc49524e9b380ee5c4
> --=20
> 2.55.0
>=20


