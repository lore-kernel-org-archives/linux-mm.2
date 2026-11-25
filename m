Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2077F606A33B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 12:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=R9PqZMXb
Received: by kanga.kvack.org (Postfix)
	id 43AE26B09F9; Wed, 25 Nov 2026 07:52:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EC586B09FA; Wed, 25 Nov 2026 07:52:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DAA36B09FB; Wed, 25 Nov 2026 07:52:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 04CC26B09F9
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:52:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A7571C49C0
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:52:05 +0000 (UTC)
X-FDA: 85473629010.25.6F161DF
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id B9E2310000D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:52:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=R9PqZMXb;
	spf=pass (imf05.hostedemail.com: domain of alex@amutable.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795611123;
	b=IlJr1vfXv5AjBwnnCBgwpRzcd5cEoxOS2S7BkZkIjIkKaDwB2rZNAySuFym7au/mtbCsCc
	L0Arw9mN3k1WQddMLRcGId8ljLccHQdDDMWdVWr00zFRK1ESeAGDqbpH8uN3G/uGPFGCFk
	CqhGuoRx2hTDKie4VVpboFZace5kZK8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795611123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a7/VZHL1+Zykiy4bJ1WLf1Y545HqmJxQ5d1ZgPnt3mk=;
	b=VwveevKF1xE3mLeDCDMm2J29khohKtTy6YHUNWNBAU3leiP48f1J4vCg0mbQA8d+VM1Xjc
	QG96xpjZ3b3Gh6pL7QA4T/06TJamkonBLh+5Nrqbg3+hAvprw5FiRi5FEmvJvo9vFos3Xn
	nPb/uY5LvqUaSQ558lIolbuL+ocMrDY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=R9PqZMXb;
	spf=pass (imf05.hostedemail.com: domain of alex@amutable.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4bb606491faso30669475e9.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1795611122; x=1796215922; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=a7/VZHL1+Zykiy4bJ1WLf1Y545HqmJxQ5d1ZgPnt3mk=;
        b=R9PqZMXbW800tAB2HAzwGxeRCX89WizreI1oCTC6U8KNfy17Iw60xowM1XOJ9boe4V
         1L8DSNdyNM5XH6kuahEHMvdYqSe8oCnYYJtyRdeWalOLoBCXbkOHr8Pb/+CdEv+0Rvsr
         yG3tLcelFPeq8a46GHGrPUD7/0vqQv3tgsRgblUaify6+kiF5q7w9wJBvyzrboyYrJMG
         356vOC9Lsgb4L8i/1S8TnZ93F20RkQSKN1Y6xhRw0rzsQmdt8iN0A9l/+mQX6VfaSgZ0
         l20DVvt4P55vO5g66sgoEVb8eq/D8kOf4cXA+ZiLmBUerkF2qbCnvmjAoVanyyr3hrtk
         LbSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795611122; x=1796215922;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a7/VZHL1+Zykiy4bJ1WLf1Y545HqmJxQ5d1ZgPnt3mk=;
        b=1Nh6CPWTkamfS3xlKnUggPJr9ffxXNkBiRamoUIHDMItixo1+aWNsEkqsQTJ7nw3k1
         iY5GQtfewnX3woDJvxKDmHQOyb9t47T0Og0Wuazvm1FOIEyz+mmvitDcCj/YMhuL1Lrw
         FOJs+yqLVZVnwceQuYOaNpVyXGnIwBHep+kPfN68hEd9/cCLqGTxBJ2QJF2dicR2owXK
         X/vjZXBYfkInk55QqccrQyl2h9yRp1MRB9hRPlNZTLv9jOwAXJZ12e8YGw47SBTtVp4c
         g3wp3zUVvGj3L+z6gVpqbckzI4sbVpp+cAN20gjSAPLaDQlvRdC7LpR/ErHZghAM4S6q
         lvGw==
X-Forwarded-Encrypted: i=1; AL+hErHfvTTwRVqOiNwLKojH3wVcEgokbE4nfIfA+aGiM+kvP1XKGYSi0rFEjj0Pnx3DTKeC+pulS+uJRQ==@kvack.org
X-Gm-Message-State: APuU4Z9KS9kvFrccp7g1ZjBpKgdwO8mAciQIvPQnK5TIBquPO8em5csc
	EOSOuO+Pg7DtT5eLRvgVq/ANXjuJHoHUN6G5WuCFCQVCZrwwWa6d9Zl70wKVvoUDaAtd
X-Gm-Gg: AZFdTZfo/f5cLM4urkeF7iDaOe4XZ/MYVfGjY7pbADJqrBaFdQGefJw3AJXC/zl5XO+
	vIL04VB9lXQpdkblGpEuHkNVMRJoFL3RkbeH066Q2Y8yC7QoPgzl5G5vo4qPNTAhz9dN14Y7m/t
	KjK6xzktWLVIvWyS+tirxGKdfxgUxtyTSSaoZHgQjurze34YuZLVLmlnjzR7EVp52ltorxOyEMD
	0zpH9XMng8z74bDffmzOerBhwXXOGDl3u1Ecy+DVkXUo16ruuomet1p11f57dpdlmMskUs7dnNp
	fxNrvC8VyH++D+B3UO6qTJGAE0k6+GSPem3hIh0EUEjGKZ4HLY2fS3F2Lsdlno+xNS1O4wx9iIm
	fk2NMiYyEHuL9v9ehXZqY81Zv6ehmXI37FLxHcOyUKvAkapqIpVEIFtpEfJddJI6gvbhdElqQpe
	2C0W8uypinSfd0JyXHr+9J3VQTI6JOS2QRzWp12mt2ft8mfjDrLffgyySea/E4cqIar0STWidaB
	ZdFclme5JH24y+GV2ndFSrLuyZxdOF+HIdHDtZaMJuzagbxzuPCiTT+ed1Us4sCIpCMRq87iEJZ
	MocCsxYDW5meBzJmTYUrG3uLBKHn7xLsQHklcgEBMglRERBi57hK6/jSvNfL/uSCplQJ82nS4Js
	NE7FAGxWHxL9NHXhJymTfuR/abiMR/kHnuFcqx+jQQ6CXuRQU4gvWNw==
X-Received: by 2002:a05:600c:3b8a:b0:4ba:761:c0c5 with SMTP id 5b1f17b1804b1-4bb8880f0e0mr363677835e9.5.1795611121806;
        Wed, 25 Nov 2026 04:52:01 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:c235:97b:8b16:8928? (p200300cf572c2800c235097b8b168928.dip0.t-ipconnect.de. [2003:cf:572c:2800:c235:97b:8b16:8928])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb90660cb4sm462265225e9.2.2026.11.25.04.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 04:52:01 -0800 (PST)
Message-ID: <c4b406a5bb8968e4fd73bb984c55f8aafb4ce355.camel@amutable.com>
Subject: Re: [PATCH v2 07/13] ima,evm: use d_real_metadata_inode()
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, Amir Goldstein
 <amir73il@gmail.com>, 	linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>,
 	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, 	linux-trace-kernel@vger.kernel.org,
 linux-integrity@vger.kernel.org, 	linux-security-module@vger.kernel.org,
 linux-mm@kvack.org
Date: Wed, 25 Nov 2026 13:52:00 +0100
In-Reply-To: <20261116-work-ovl-d_real-v2-7-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
	 <20261116-work-ovl-d_real-v2-7-90564c4ae347@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: nmeqkfwhzxtahyftmtb5kyk14opxtkxf
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B9E2310000D
X-HE-Tag: 1795611123-517419
X-HE-Meta: U2FsdGVkX1+WNFOg1Fw96XQ6vu72uwPyUAhmzsDljN0BhlKAyoiIW/R7PwgVQsIIV6yqXSe86XRnbS7dcRTK4LAFthnae70mFd/R8gMxCFX5Xdb9OvrEKQ+Fe390ik2oXdLYGsM+iC7NoHbglLNHXMLqzPAQPVK40fvG40y/VkbELU1Q6VfcTdBrAfL5jMF1cnxBTM5yV5GJyo2Tva6u3O8qroCuZ6fW/970yM8ucHlx8zz1SGNUyL7+yEYimxrvgxqfel8qWUNiL37DlHu0Sn70T2RzGsTr4C1c0j7rTEpFDdmWMM0AuAzlIqZwZLX8KMo8R5SvbJ+narmGjMIB8hP8GqdjyZZnSdhp/u1l8DnhsQKRu8xDvosaNmpWEscODjbok+5xDbjL7Yn+OC4XlsI0QEjphhmShUGsGlN8AZUGQd8RcCrRG2oVuUsv+fttBay0KCZeT+LCOFDX4maPa0AGE8Z7vs+T7ToM4pXxTkWLodKapb8vDcX4M5Dg0LmAm5uQBDT3obMox1Md4JrjPz1NcgOWDWhHN+iGtHlX8LtDjMQy+iJa3wysB1uLXjxqmKb+Dz6AOyCM672+J7GuXOuV2No/otwjKNZm7CZP2rTaff7dKr8wepWxCI63K1Klf0RiueE703uQjCZ+tvwpH8Be2ezc0KKU2dZfl+EgDUhaLjo3YvypEgiOUbDy6K0AgWpKwIW5TKTSpHROM/a4K9c/8C1sLpyqo+pd2PLgf3MlVasWLE41bRhL+lf5eOKX/Eanq9hA3euqOXs0tOaQMmEDq86p0EFIPdaZBVVXZJTcdfEfMrRr9vMu9P9WC5UDBVPTC4rNH18FVY+fymNYWT/aXrIvXtCVOCKDUoh/XTBMvYBhsbYAQgNERtDRw/8tuBOlqpCo24iR9SZe7IU+PIa009aOMJF2sSbtXfrD9iZEF0l4sjdZGE9oaqE7943GxExBNEJoUOfwSSIyEQq
 Y8D8JVjv
 NZimA2S5a0gigS24MFWX59IP3O9g0g32mhe8kF1HtsVFLfX7lnN0H4d3Ix2smUNBXevO9P6D6Jgj/Src9le28aEtL6fEOzziozICw7sFt2sLJwKIVjeSsI3D/+NYAz1emnS5j3PqIRHq3sV78ClTfoX3VDPSkdmxsVyQ13rIeses7E/LPqBH1D94Y5d3sRQ3T4xjzMmOFkLrqYIZTL6iQRfO9uEl53nHGMe17y+10coKlwa6GEaiMlTSwTt+5qVqRMqkApwCm1wODPqV5dUhhvUmSGHubq0zehBJizxnlwYCUuWtUsvmry/ImsP4vAYmycvn8Furx3XOe+Lsf7q7RTlbUcdmp3m5+L5BYoxA4Ic+PPR6M+9CnAQR2Fb5VJnAJ/Tap+fY9dNr4Ge6HLKzdykm1GNhdIsP96ftj0mo/DZ1i57gbRR4+oF2dQ0nsvQfQbJ9am7AtHL6x1OmFt3Y73ByLor/qo6fPmPm9MIbz3QJR6E/cEuDpGx9GViaa4Q4NJ0DxUORxoL7h8CnQDlwkYSmLgYKpR+UCKXggKf7mbWmmi2DSNPWsoKb32O5w+kAGeLnP9NkAz7rswdyslG7Tbv6AaXYKLZ4bNXliEBqrbd4losZVI6bR3Mk45zwNfTe4XgSBWxqs18PgWKLS3ZNyV/RnlxpCO00x+PzCdIzDZRdr0ywdQSXWLUU62ukmnBjYnvru
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 10:44 +0100, Christian Brauner wrote:
> d_real() is about to be able to fail. D_REAL_METADATA never has to
> look
> anything up but we don't want to promise that it never fails. So
> switch
> the open-coded d_inode(d_real(..., D_REAL_METADATA)) in
> process_measurement() and evm_calc_hmac_or_hash() over to
> d_real_metadata_inode() and deal with errors.
>=20
> evm_calc_hmac_or_hash() returns the error so EVM fails to verify the
> metadata. process_measurement() passes the error on to
> evm_metadata_changed() which treats it like changed metadata and
> resets
> the EVM status. That is needed as evm_verify_hmac() would otherwise
> hand
> out a cached INTEGRITY_PASS without looking at the metadata again.
>=20
> This is a no-op as long as overlayfs can't fail D_REAL_METADATA.
>=20
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Link:
> https://lore.kernel.org/all/CAOQ4uxjoHbevvu8auB4m8AVcY9H6uHdDAP6mfi9OOMh+=
3775xA@mail.gmail.com

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0security/integrity/evm/evm_crypto.c | 5 ++++-
> =C2=A0security/integrity/evm/evm_main.c=C2=A0=C2=A0 | 9 +++++----
> =C2=A0security/integrity/ima/ima_main.c=C2=A0=C2=A0 | 6 +++---
> =C2=A03 files changed, 12 insertions(+), 8 deletions(-)
>=20
> diff --git a/security/integrity/evm/evm_crypto.c
> b/security/integrity/evm/evm_crypto.c
> index 1c41af2f91a60..17d528771d8fe 100644
> --- a/security/integrity/evm/evm_crypto.c
> +++ b/security/integrity/evm/evm_crypto.c
> @@ -231,7 +231,7 @@ static int evm_calc_hmac_or_hash(struct dentry
> *dentry,
> =C2=A0				 uint8_t type, struct evm_digest
> *data,
> =C2=A0				 struct evm_iint_cache *iint)
> =C2=A0{
> -	struct inode *inode =3D d_inode(d_real(dentry,
> D_REAL_METADATA));
> +	struct inode *inode =3D d_real_metadata_inode(dentry);
> =C2=A0	struct xattr_list *xattr;
> =C2=A0	struct shash_desc *desc;
> =C2=A0	size_t xattr_size =3D 0;
> @@ -241,6 +241,9 @@ static int evm_calc_hmac_or_hash(struct dentry
> *dentry,
> =C2=A0	bool ima_present =3D false;
> =C2=A0	u64 i_version =3D 0;
> =C2=A0
> +	if (IS_ERR(inode))
> +		return PTR_ERR(inode);
> +
> =C2=A0	if (!(inode->i_opflags & IOP_XATTR) ||
> =C2=A0	=C2=A0=C2=A0=C2=A0 inode->i_sb->s_user_ns !=3D &init_user_ns)
> =C2=A0		return -EOPNOTSUPP;
> diff --git a/security/integrity/evm/evm_main.c
> b/security/integrity/evm/evm_main.c
> index ac8328812e6ef..71faf156f9d6b 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -763,11 +763,11 @@ static void evm_reset_status(struct inode
> *inode)
> =C2=A0/**
> =C2=A0 * evm_metadata_changed: Detect changes to the metadata
> =C2=A0 * @inode: a file's inode
> - * @metadata_inode: metadata inode
> + * @metadata_inode: metadata inode, or an ERR_PTR() if it can't be
> resolved
> =C2=A0 *
> =C2=A0 * On a stacked filesystem detect whether the metadata has changed.
> If this is
> - * the case reset the evm_status associated with the inode that
> represents the
> - * file.
> + * the case, or if the metadata inode can't be resolved, reset the
> evm_status
> + * associated with the inode that represents the file.
> =C2=A0 */
> =C2=A0bool evm_metadata_changed(struct inode *inode, struct inode
> *metadata_inode)
> =C2=A0{
> @@ -775,7 +775,8 @@ bool evm_metadata_changed(struct inode *inode,
> struct inode *metadata_inode)
> =C2=A0	bool ret =3D false;
> =C2=A0
> =C2=A0	if (iint) {
> -		ret =3D (!IS_I_VERSION(metadata_inode) ||
> +		ret =3D (IS_ERR(metadata_inode) ||
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !IS_I_VERSION(metadata_inode) ||
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 integrity_inode_attrs_change=
d(&iint-
> >metadata_inode,
> =C2=A0						=C2=A0=C2=A0=C2=A0=C2=A0
> metadata_inode));
> =C2=A0		if (ret)
> diff --git a/security/integrity/ima/ima_main.c
> b/security/integrity/ima/ima_main.c
> index e463cfc1e3f43..016de5a66eced 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -357,10 +357,10 @@ static int process_measurement(struct file
> *file, const struct cred *cred,
> =C2=A0		}
> =C2=A0
> =C2=A0		/*
> -		 * Reset the EVM status when metadata changed.
> +		 * Reset the EVM status when metadata changed or the
> inode
> +		 * hosting it can't be resolved.
> =C2=A0		 */
> -		metadata_inode =3D d_inode(d_real(file_dentry(file),
> -					 D_REAL_METADATA));
> +		metadata_inode =3D
> d_real_metadata_inode(file_dentry(file));
> =C2=A0		if (evm_metadata_changed(inode, metadata_inode))
> =C2=A0			iint->flags &=3D ~(IMA_APPRAISED |
> =C2=A0					 IMA_APPRAISED_SUBMASK);

