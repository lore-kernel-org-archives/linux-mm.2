Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CBCFD609D7
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 18:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8958D6B0005; Tue, 16 Dec 2025 13:14:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842E36B0088; Tue, 16 Dec 2025 13:14:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 716A56B008A; Tue, 16 Dec 2025 13:14:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5DE146B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:14:07 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04A048B3D5
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:14:06 +0000 (UTC)
X-FDA: 84226133334.21.F5F76B2
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	by imf06.hostedemail.com (Postfix) with ESMTP id ABA17180014
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:14:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmx.net header.s=s31663417 header.b="Uv3k/uM4";
	spf=pass (imf06.hostedemail.com: domain of j.neuschaefer@gmx.net designates 212.227.15.19 as permitted sender) smtp.mailfrom=j.neuschaefer@gmx.net;
	dmarc=pass (policy=quarantine) header.from=gmx.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765908845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L8FQ2rgVLCdkD/oF0eHdo9FUsYW9diG97aFUGJ99iGw=;
	b=pV0j1sDC4k0Zu3NFN3ftPRdR3owx3UB9C38vwjPNxe2guYg8w5CF3ouaWUcIRCorsJxC21
	1h1Fd0zgcWFzufq0WNJX7hvK465mJWr+STltRzbpmkcsIFQvbEyZL/r/YCd/vv5TOM8/c2
	IiOnsNi3055gIR6P6okWOhaVmS+eckw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmx.net header.s=s31663417 header.b="Uv3k/uM4";
	spf=pass (imf06.hostedemail.com: domain of j.neuschaefer@gmx.net designates 212.227.15.19 as permitted sender) smtp.mailfrom=j.neuschaefer@gmx.net;
	dmarc=pass (policy=quarantine) header.from=gmx.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765908845; a=rsa-sha256;
	cv=none;
	b=t1KflsqucOVYJnbPFViM9isw+KKuAz+cSkpuokSPHu1hiv1p+JCx2lx4byC8XrD5vuPk0t
	qyRahB0mURZzIndHHGSMN/mXHyZVlsFzG3fIB5broVnuitU5C0zlxc4DJcPyI7AYg362vA
	FHjv+nelD5XQQctHwmjM29PDReMrDJs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1765908837; x=1766513637; i=j.neuschaefer@gmx.net;
	bh=L8FQ2rgVLCdkD/oF0eHdo9FUsYW9diG97aFUGJ99iGw=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Uv3k/uM42oIPhA/ZvpsLkiDMSos0h+YodmndgiX00sDnjeSmatTVNcmN8cOc1Pob
	 5w8k35zIaCjmyImzopDNfOdTzl4Q+Cez891p1HrnqdWdvCf8UUsYDJWfuwH9MfeP1
	 oQaB8G1OGjx7Agg8AfGJjufj9KySKghgkZHQgwHxLefMqCfTh7PxfUztsJ/8xjXGF
	 ygCw9DNzHRteol4H7LF1iSzWwy1yDtdTytXRThC2lbPJxsEupcy1sDE0xaBjqDEoD
	 wigarnoODsqMOifxgVI6Ddl0d7Cl9WawjqQ6IqBz208kYiOY7Y6iJnFnXqJSbPwH5
	 XtBCJ3/gxDFAeISqBg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from probook ([89.1.209.246]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MIdeR-1vjaBE0Yyb-0070dz; Tue, 16
 Dec 2025 19:13:57 +0100
Date: Tue, 16 Dec 2025 19:13:56 +0100
From: =?utf-8?Q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, miklos@szeredi.hu,
	linux-mm@kvack.org, athul.krishna.kr@protonmail.com,
	j.neuschaefer@gmx.net, carnil@debian.org,
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
Message-ID: <aUGhZM5pl8JKBGvR@probook>
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
 <20251215030043.1431306-2-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20251215030043.1431306-2-joannelkoong@gmail.com>
X-Provags-ID: V03:K1:2CwlOGn9Hl+M3/cVdNFnPEX6oSIqboEhfldkkQoVU/NHkdValS5
 m7OW2RgwykwP8c5uHHAfFrsqJ8uWwqKrVxoKo/A9ykHJ5Uc46MJzBw0L2GuRMJjqVMAFoRx
 /+1xiQXhpPQmIduaoaHFDhp0e2Ii9rAvHAIFGdJo0bJrLqj3aZmyeBpzcvCrLL3JewntUXO
 Yfzeu7f3FANVFg2foqpog==
UI-OutboundReport: notjunk:1;M01:P0:DjCyqchm0cc=;GX5yp3ip5mQdvDrNweDnQU0+V1F
 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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ABA17180014
X-Stat-Signature: af35c3w4ywi4kfatqk479inueoc8qhdd
X-HE-Tag: 1765908844-554820
X-HE-Meta: U2FsdGVkX1+X3LHtu5LTpdDVj9PJPKI/hZqq8xftfzKSkj69Cz3q5dstUsrQntUcHZenGFlpDxcdDoggeDSB+wsz0yzyjIha8hXitYWQxKLiBx6IIbS9xL54l+NgfISOGix6Eu070TuXJPZ5eJqDhWekeQlzrfFzhdF0vwrXxh02fIOPTTyEp6d562Qwbv+wJ0beMb/e97Pe2Fi7wd8+pZf8VTkAGGWy+eZxdnd+1MdQjskqyX6ARgjAf1ijSg4xSn4OAYqJ3h0KRfaOhFAwOofXomoAtu4hgWpZfjHoHj6zT3hY7sNVLgKnefg0CyA5tWlljm6Aq/vPLleZWyniD8Dvoungbg2Fb9rrBMoSkxh6Zat+TDU99tKwH4pgg8eYFt+AJboy5BDBOHrctMzBVvgevmGjWZ+2nfBAn5uzS7muDnLEUWwkFG+9XqMJ8dTaZYU+7reVNh4dE3wbY2dL0V0yNm6BBqzvE0i5WEUcSRxR7KgYsk6WoY3Q1j02qpW93AEvSnB1hkfMgnFnlM6PS/Vmq2atC2ZNTMbAZolEvKG+9Aa9Khjy+E/+2MSNvPPHJ4ONyyFSRg6bxmU4zyv0T4iWmr6G5scTO9vQrA4x8lq37F0qLzG7zWV7XQL0AI0pNaJwRWBHIiY7VZdbdxP9Wxb8hXKuZSElWOztc15UzSJ/ISuyNZ86AeLEdSOE9hK64qBAJDR0buAUuEIZQjYGdWgQBnILQwxvaGapbjwZHyfugh0TwshPgV66sUUElh8eQsDzaIvSl9Q4UBV1JvN+ofAyGAIFPxlK5tKuYa2K5gQtzUpo8uH8cs/2RwU6owC4TUUxQs9aEwugr9Yfe4KRVr4MlFTHG65peVlU4Fdj1IjMum9lyQtz3XuapQzmEjKhkH4jrjKRXN3+E0IpKv6bhI0kAikBn2vjfQjHNivgYuz3eFv36u6jDp1hRG8rPwQghTBuDYWv7NMt6hJI4iO
 3Ye2IsEP
 ZfjyU920TEPf44XvdVH7dCo3GtK14YH8cUbJahApxUFAHSGdkcYJU3NCHzL3REI27+8WkZ87As0kNd2i/a9qp3o6ZTbURM2wDBWfIz7so9hs2WE2KEtizXklaBJeYQ0SIAs44rIY/IE9wmiMNTFGJLFIDOme+ffIOxUTizb+w1NAOKiF4D4TL3WNYfrBqIuVrQLHN1GrMkVP7oC+fpjNqxsZP1yUPYDQb20Buf5X2hoxyXrZeQceLRIJBDauWaTECzH0hXr1SH3UreHDwLc2HxmDT2Rii9orpZr4ckHX7r+K5p0MDg9U9JjunPGNCbDTYtrgSGmROHAIEGrn5kSKMNZahF1s5I7ruysfwtvdBNWBUt1PCqK6VfXEJ7vZf3q1z7YmkkgawXNwKhCugVoeQ4dLUF5e4JdO/sm3ceKSuwTHQSHbbLspqCWLeW9TpvcMDQkAA4IeaZuwjzIClrBclGAvyyTbKH8eGMsW/asq/0WcBFJGoVGSgwysTaHJgcpvZQIUZkuG8FzjRvAVz+oWjSEBOu7GDa6yS09ir4xTLpigVek3Ku36KUABnEvzjn7xDTx+2sRGegzKgBu1GCOIC2fTbiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 14, 2025 at 07:00:43PM -0800, Joanne Koong wrote:
> Skip waiting on writeback for inodes that belong to mappings that do not
> have data integrity guarantees (denoted by the AS_NO_DATA_INTEGRITY
> mapping flag).
>=20
> This restores fuse back to prior behavior where syncs are no-ops. This
> is needed because otherwise, if a system is running a faulty fuse
> server that does not reply to issued write requests, this will cause
> wait_sb_inodes() to wait forever.
>=20
> Fixes: 0c58a97f919c ("fuse: remove tmp folio for writebacks and internal=
 rb tree")
> Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
> Reported-by: J. Neusch=C3=A4fer <j.neuschaefer@gmx.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

I can confirm that this patch fixes the issue I reported.
(Tested by applying it on top of v6.19-rc1)

Tested-by: J. Neusch=C3=A4fer <j.neuschaefer@gmx.net>

Thank you very much!


> ---
>  fs/fs-writeback.c       |  3 ++-
>  fs/fuse/file.c          |  4 +++-
>  include/linux/pagemap.h | 11 +++++++++++
>  3 files changed, 16 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 6800886c4d10..ab2e279ed3c2 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -2751,7 +2751,8 @@ static void wait_sb_inodes(struct super_block *sb)
>  		 * do not have the mapping lock. Skip it here, wb completion
>  		 * will remove it.
>  		 */
> -		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
> +		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
> +		    mapping_no_data_integrity(mapping))
>  			continue;
> =20
>  		spin_unlock_irq(&sb->s_inode_wblist_lock);
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 01bc894e9c2b..3b2a171e652f 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -3200,8 +3200,10 @@ void fuse_init_file_inode(struct inode *inode, un=
signed int flags)
> =20
>  	inode->i_fop =3D &fuse_file_operations;
>  	inode->i_data.a_ops =3D &fuse_file_aops;
> -	if (fc->writeback_cache)
> +	if (fc->writeback_cache) {
>  		mapping_set_writeback_may_deadlock_on_reclaim(&inode->i_data);
> +		mapping_set_no_data_integrity(&inode->i_data);
> +	}
> =20
>  	INIT_LIST_HEAD(&fi->write_files);
>  	INIT_LIST_HEAD(&fi->queued_writes);
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 31a848485ad9..ec442af3f886 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -210,6 +210,7 @@ enum mapping_flags {
>  	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM =3D 9,
>  	AS_KERNEL_FILE =3D 10,	/* mapping for a fake kernel file that shouldn'=
t
>  				   account usage to user cgroups */
> +	AS_NO_DATA_INTEGRITY =3D 11, /* no data integrity guarantees */
>  	/* Bits 16-25 are used for FOLIO_ORDER */
>  	AS_FOLIO_ORDER_BITS =3D 5,
>  	AS_FOLIO_ORDER_MIN =3D 16,
> @@ -345,6 +346,16 @@ static inline bool mapping_writeback_may_deadlock_o=
n_reclaim(const struct addres
>  	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags)=
;
>  }
> =20
> +static inline void mapping_set_no_data_integrity(struct address_space *=
mapping)
> +{
> +	set_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
> +}
> +
> +static inline bool mapping_no_data_integrity(const struct address_space=
 *mapping)
> +{
> +	return test_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
> +}
> +
>  static inline gfp_t mapping_gfp_mask(const struct address_space *mappin=
g)
>  {
>  	return mapping->gfp_mask;
> --=20
> 2.47.3
>=20

