Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C9CC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 02:00:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A16A8E0001; Tue, 29 Jul 2025 22:00:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6518B6B00A2; Tue, 29 Jul 2025 22:00:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518E88E0001; Tue, 29 Jul 2025 22:00:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4E36B00A1
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 22:00:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05E8E80314
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:00:12 +0000 (UTC)
X-FDA: 83719275864.14.25DFB06
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf19.hostedemail.com (Postfix) with ESMTP id 010051A0007
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:00:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of zhangqilong3@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753840810; a=rsa-sha256;
	cv=none;
	b=WSmljhLUl6m7YlhvjKnwDbKrO9tAA7wkyZe5kpt4CllDwFraxT9Se7RGsW150n1USCKnI3
	2VArplkVK2/j3ZEozZfuhAkXz8pTDunxsQLBFMK8iQdy1h9CQVFQcEV1YnJsWtbjaZCBkZ
	sFTBiA888McbZ/iFDP55i2UugU7MY2E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of zhangqilong3@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753840810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=cjaLG03jGt3qvSpkYZeLoGMZcEMqmJAj+RhgIovZryc=;
	b=jAujfRrdRDC5bnvkK6Fxf5B3ZHlb4+GteOR3T5/B7a6FVto9hyXpUDSpq2QLHB6IIiMeDr
	XWzsxxi8Ds5kshymeLwx7eRtwRAzaTu+GdB4EJCjHL2z3BiBD9YUKS6LlFmheIw1z+DNfH
	iNH0vC66NgPLPuopeQXRJPlrRGvbz0I=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bsFfT4qJBzSjfM;
	Wed, 30 Jul 2025 09:55:29 +0800 (CST)
Received: from dggpemf500008.china.huawei.com (unknown [7.185.36.156])
	by mail.maildlp.com (Postfix) with ESMTPS id C1BE81402DA;
	Wed, 30 Jul 2025 10:00:04 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (7.185.36.8) by
 dggpemf500008.china.huawei.com (7.185.36.156) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 30 Jul 2025 10:00:04 +0800
Received: from dggpemf500012.china.huawei.com ([7.185.36.8]) by
 dggpemf500012.china.huawei.com ([7.185.36.8]) with mapi id 15.02.1544.011;
 Wed, 30 Jul 2025 10:00:04 +0800
From: zhangqilong <zhangqilong3@huawei.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: "arnd@arndb.de" <arnd@arndb.de>, "gregkh@linuxfoundation.org"
	<gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Wangkefeng (OS Kernel Lab)" <wangkefeng.wang@huawei.com>, Sunnanyong
	<sunnanyong@huawei.com>
Subject: Re: [PATCH] /dev/zero: try to align PMD_SIZE for private mapping
Thread-Topic: [PATCH] /dev/zero: try to align PMD_SIZE for private mapping
Thread-Index: AdwA8B+aYBqfNHtAQZ+Ap7afBezwHQ==
Date: Wed, 30 Jul 2025 02:00:04 +0000
Message-ID: <2348ddc4573143e48de87cfc66e6748b@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.174.177.115]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 010051A0007
X-Stat-Signature: bq3mqxdzin4edws4ushtodhbtgt7yz4s
X-HE-Tag: 1753840808-326682
X-HE-Meta: U2FsdGVkX19P8TZtaNydmYTEk98WiVfQNN4cUhoZK0TMC3Ah73QMWMWdttHxk/zsWYqtgwh76p6uObvmq06g+llIAsdQ+uh57QNVfnMDf+AgGy7m1IQwrx8nrKpaourFTyfkipmXjQM6enj2XFEJ5QXGSfwbWMwAjAkqVuvfJcranb3dy7MyhRQC2Zdcwmdo15W6IzaHH3hG2pZJP7ome5u3TzQLzEdGWD/U0+PUYuxAPwpxqqPcd0n/tn2z0jTlXx+f15agSI56Ac7D9IuE5730jiT+dhYQYyH4Z2L1zGN96rXqjJwH0z7fZVNkMx6L35DiAGlMoYjFGO+9GIo/guHmfRbUbcLN7zp41KzzXd8fnHXKtVWAw6PqUrBkvsdZdiTWHQ0HxEM2XZ7cT0+5iM8gckenN0doKlGT5YzXgIgmi4jWbDOuxmr5bAkKFvciAsmE2TZi3v1S238GLLxSAWagrTw5GGoA6YOIgH6/pcwsxRnTDqKK7LKTvaMwkZOLDD5guJIvMMbtX0loaxmluitK1lWSZShl0bKkYG6c2Z70Sv7Km/lBfsnxamBxR6ZlFvvRpyUvG2IeGox61H//EDoVKqfVTzmSN91RDEXLQiEv92wCwtC+fFGVkHZ0i9mEA1XtcGiMwG/9IZbEGeMVQCtGQAKVCmH2punCEdrwqCkfSriyeDTPq+7GzUoEERKaLqFcoX8V3YNXxjdbAQD96nwHvjM1zRj0hM24UAJOUEcoK3wsY77k2V2+U2XT4pNwpSQGmsRgk6VjPe42LDAvoXp8W74LsF/MYVC9TAKb28kL6QhBbodiXblBnhxm87v8QDIfspKCOIGkMei5pDJLSvwiGlBEK3o2AnoZqt0GdgoRcLNEFrSmbgRK6hT4G8Rtep4q1vbC1jxfq/4Kib6RXPGYGJ+kugH6GtA/Sm/ocv5Hinmp37WVCLYc7rW5H6dFpI5ozuozDUWiZwiD6u3
 QxYGZFIV
 fWDFv0W4g2U0Uq62D1GWJy3Ixqnffx7vNFU/g6ukx53mGCDS17Zjwrs6oZSSIjHt2H1PcJ1Sl0ujWa+mRD599xYinCEW9SmC3LuMN/8RsTWXpJTUl9z5CBAmI9WYBTQCVXxxgYqFE+Y99h9+tif4BA2rr/l5fjdGVrdCy+ms/neEbbH5TAS43DCO7XUMSWzj3mxiaPbMf0awYXig66H36d91f9zQHOd6bnzPoHGDr0tQuTQJIC9twJsAjmy5+iP/dsNsODm+HQ9l6DxutrgbJCiptC/2dvxNt8/UOKUtsgz6U/X6zaUzs1u2ldataSCbGQGdpkWLvuJLnSVqUxAWa31ME2oDIAxeZ1ww6oAe5y4O9BoS7knKS9lCXD5ka+11JZaq0YhPXWHX3w/Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
> On Tue, Jul 29, 2025 at 09:49:41PM +0800, Zhang Qilong wrote:
> > By default, THP are usually enabled. Mapping /dev/zero with a size
>=20
> Err... we can't rely on this.

OK, I will update this description in next version. =20

>=20
> As per below comments on code, I'd update this to say something about
> fallback if it's not.
>=20
> > larger than 2MB could achieve performance gains by allocating aligned
> > address. The mprot_tw4m in libMicro average execution time on arm64:
> >   - Test case:        mprot_tw4m
> >   - Before the patch:   22 us
> >   - After the patch:    17 us
> >
> > Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
>=20
> This looks ok to me because there's a precedent for using
> thp_get_unmapped_area() directly as a file_operations-
> >get_unmapped_area e.g. in ext4.
>=20
> We also simply (amusingly, or perhaps not hugely amusingly, rather
> 'uniquely') establish an anonymous mapping on f_op->mmap via
> mmap_zero() using vma_set_anonymous(), so we can rely on the standard
> anon page memory faulting logic to sort out the actual allocation/mapping=
 of
> the huge page via:
>=20
> __handle_mm_fault() -> create_huge_pmd() ->
> do_huge_pmd_anonymous_page() etc.
>=20
> So everything should 'just work', and fallback if not permitted.
>=20
> So in general seems fine.
>=20
> > ---
> >  drivers/char/mem.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/char/mem.c b/drivers/char/mem.c index
> > 48839958b0b1..c57327ca9dd6 100644
> > --- a/drivers/char/mem.c
> > +++ b/drivers/char/mem.c
> > @@ -515,10 +515,12 @@ static int mmap_zero(struct file *file, struct
> > vm_area_struct *vma)  static unsigned long
> get_unmapped_area_zero(struct file *file,
> >  				unsigned long addr, unsigned long len,
> >  				unsigned long pgoff, unsigned long flags)
> {  #ifdef CONFIG_MMU
> > +	unsigned long ret;
> > +
> >  	if (flags & MAP_SHARED) {
> >  		/*
> >  		 * mmap_zero() will call shmem_zero_setup() to create a file,
> >  		 * so use shmem's get_unmapped_area in case it can be
> huge;
> >  		 * and pass NULL for file as in mmap.c's
> get_unmapped_area(), @@
> > -526,10 +528,13 @@ static unsigned long get_unmapped_area_zero(struct
> file *file,
> >  		 */
> >  		return shmem_get_unmapped_area(NULL, addr, len, pgoff,
> flags);
> >  	}
> >
> >  	/* Otherwise flags & MAP_PRIVATE: with no shmem object beneath
> it */
>=20
> Let's add a comment here like:
>=20
> 	/*
> 	 * Attempt to map aligned to huge page size if possible, otherwise
> we
>          * fall back to system page size mappings. If THP is not enabled,=
 this
>          * returns NULL and we always fallback.
> 	 */
>=20
> I think it'd be sensible to have an #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> here, because thp_get_unmapped_area() does the fallback for you, and
> then otherwise we'd be trying it twice which is weird.
>=20
> E.g.:
>=20
> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> 	return thp_get_unmapped_area(file, addr, len, pgoff, flags); #else
> 	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff,
> flags); #endif
>=20

Trying it twice is realy unnecessary. This looks clearer and better, I will=
 refer
to your suggestion in patch V2. Thanks a lot for your and helpful advice.

> > +	ret =3D thp_get_unmapped_area(file, addr, len, pgoff, flags);
> > +	if (ret)
> > +		return ret;
> >  	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff,
> > flags);  #else
> >  	return -ENOSYS;
> >  #endif
> >  }
> > --
> > 2.43.0
> >
>=20
> In _theory_ we should do the thing in mmap() where we check the size is
> PMD-aligned (see __get_unmapped_area()), but I don't think anybody's
> mapping a bunch of /dev/zero mappings next to each other or using them in
> any way where that'd matter... So yeah let's not :)

I agree with your thought. Do not make check here.

Thanks.
Zhang



