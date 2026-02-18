Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E73FE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 12:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5CB6B0088; Wed, 18 Feb 2026 07:08:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53D66B0089; Wed, 18 Feb 2026 07:08:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35496B008A; Wed, 18 Feb 2026 07:08:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9D06B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:08:09 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2EE99136CAD
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:08:09 +0000 (UTC)
X-FDA: 84457454298.29.F45D7FC
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5F82B8000D
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:08:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YV+Vf74/";
	spf=pass (imf02.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771416487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWJozyYgHIhJJQDNAoxanhYWFd4biMKeSCw3f5P1+Fk=;
	b=HpQFXZJinZH7dMMuLvWcPwtdiLd3aCOOfLOiWQxDF6DpKo/IjLriXOZSDlQ+Ox2l4I+Lrz
	rdjOSnD4oVrSdOWB1IBm2NYxpwf76rrG8B+58SxK/RJx0W6QDkfCkhV5/Umu1SRfnlaet5
	bJeC1M2DYVPy//TBwYGhecMW5/huyg0=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YV+Vf74/";
	spf=pass (imf02.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771416487; a=rsa-sha256;
	cv=pass;
	b=NuRmlOstnSN/hA4Whp+Ip1PCT49faeSRARjfh4NWNBje9fO2009+ebVkfuuakUomhwWO4z
	tqWxDELTSsbewNME1XkviKZHgsXjG5Q38LbUHGNs7q8ukZq4kHP2+le72vWP5eBggKm4rY
	LXw7+xGNurvdMYXccj81MrqWs73S/4o=
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-124b07e5fe4so331054c88.3
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:08:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771416486; cv=none;
        d=google.com; s=arc-20240605;
        b=MyxyqOmiagVF2wYtAPKmAopwOi2KjgtrjsvqVMKiDxAZloew5FAy6cKxwN/7jrxaQt
         FhFyrJfj5qtYORrPyIU2DVQD8m0ifivsvNJTkUxPbTDZjEl5YUvNRHDYeXiIJq8vXiBo
         E0Zsu4GY5veqrUKWKokMZvO8FKRGYu+F6RiCUyI4vZG6Xl8IRckU5GZcGar/ZxrFLzp4
         tZmDitNlusdmbVIvrSivfdi964TyKJR3ee6JXSr781fubFDZkYZCgk5wkxuWQ9XRWodx
         IcqjRbK8UKnwH/LWH+FwQTKdLpkA8JKjQESwxndB858beU/SxTLoIDqICrJ0Ef2o5WAn
         lxvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EWJozyYgHIhJJQDNAoxanhYWFd4biMKeSCw3f5P1+Fk=;
        fh=qA/wtSphPYFYAhtgsvHjRKrJFl4y8Lp2DHRNGqeoI8U=;
        b=PWusIkyJHGI5WzKEE4blxHifPeoyqHZqEm/mCW6wWJ6XRh/vnI+I/njcTB0wx9Ramf
         opOQj8mUaf1T+3k6wrWy/H3/cea0Hea2LXsTt32vjBADMLYk5USq9ZSJCnACfA26TUMP
         QmSKSOS5WE5HXZGIConGX9SBQyjajTYs7Lja5D9E4eL96u8hj1TNUzBDBfbBDUahV42S
         jPRc/WCS062wRoyYY3hXZfgCd1cN6FkwD+0eByxEKxOuP2nB9iV+8PuMlMOt8Hlxkhpa
         EmrotudJkgmkTcqFCCeqB8yfQLWHPHX5q55HA06dDvAA5bT3TWti3PnLXBEOfVKGMepN
         vfFQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771416486; x=1772021286; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EWJozyYgHIhJJQDNAoxanhYWFd4biMKeSCw3f5P1+Fk=;
        b=YV+Vf74/2/xblnnZSzHTQm3MOXlBjVVCFwiHycE1BGD7J+B1QXNS/6xHzCWddLVGQZ
         pEHfoklrv7sv4LOT211Nc8UVNcXRUfZT7qKH5KpL/o2AcETb5X4mSX3dy8PpaV1l00Ik
         WSFp++s1Hw8bYa+lQH1SeSkyvr+chcYFz4tSTVQNaCv2itkQepLuaf0qZKgwhZi3yGOo
         qmVKRey6DKtXHH1Lo6qIN1x0NzSphvWf5WKqAgCQXZlETGse/PAQUYsplpP7MyFJZhSl
         iT5+ORUqgu/bCDA4ukWj/rNxcDKPc2tPrj4umDjQUXI1J2e+JPOoeAb8Q2Y2bjBUe/8J
         vJWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771416486; x=1772021286;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EWJozyYgHIhJJQDNAoxanhYWFd4biMKeSCw3f5P1+Fk=;
        b=P5ESV/ET4kNxGWrAElLaV4+5boiZYMOJILR9BtlAWg7S2FwLozrwotR7YBzMw8/+8y
         p+TBt5fLV6gj4zQR4n6Ny0j7yfaNP9WA/tEb7OIDqSa2D17RKxalqNwP1UriDHm3CtuQ
         HDkWvm9sySjOObRSMyAk1rlsvQRHKWePcej39uwJsxqTcs4xrlbYDIxvmZ8sQstZzVmi
         3O+QVWljnCsiVQRIa7nw1TyEsUhldbBB9fcNHbTZ1ySj3EvFUW3ivziX5/4B3h0vjaKe
         rwod/hAB9GMc8kRrdCSRkrQ0JS8Ajx0vd76ug6m72c/UeCJT4bhUyFGsGNH6b1omfhBA
         91BQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTOPCv3jhur+A1Svl9YmIFY5KqEIg1wA2UFt1IvTTWHUzjoWeh5Y3tz3FWoRQvnHQDHsGvbn9acQ==@kvack.org
X-Gm-Message-State: AOJu0YzZND+OjXZasaGP1PDLjiN2WEKwc8u3tuDdhZmVUzmQXmPYMKRU
	6Nb2ifKpbIqvIaxIH9DexItvc9/1YPKDuXIoemJB29vKUHjq1g1KseLNrML49rrGM6SPAJCbpld
	i/TyybTlcm8g9YMSlPnLKNL9JT348AD4G0hZt
X-Gm-Gg: AZuq6aJ8wKuAJGFw+uMuwRdDHA3lOP/RYqSgikUxxW6VvqhRfJohvjwVVr2/Sq7UjSH
	AWn4rhiSMXAls4eDgmH97KnX1NhRx49LOxcQ5IEzriALFRNzMZ0kcSOCgWtfRHz7J+zoC+pT/Dn
	Ta6SeiIcBnLD6C7tribqPiScFrwUBPcpJ1euPTQ0oqsYedYnvJSPqhA6/MXYHBeeOvYUaEW0GQd
	+r8cxJIcL8J1deaR81qsCRsi/CfhawS1pP34cQ4HblVGYDKZqZ7+7TRbC7Ndr1ooJFeZspfunT/
	7Ku62fs4mrblET1dsY2aMaIYG4RbVFRceYtchNLGJ6BVzv3xeDooelzsJRlCFMF00UMnYVlABQK
	ddi2J1qxEejG5pvEQ8yJxNLyC
X-Received: by 2002:a05:693c:3106:b0:2ae:605b:d530 with SMTP id
 5a478bee46e88-2baba0f2974mr3533606eec.6.1771416485976; Wed, 18 Feb 2026
 04:08:05 -0800 (PST)
MIME-Version: 1.0
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
 <CANiq72=5r2miRm6GWszb2gDNi4k5-RZUzvdOdFQ3yyndvmHbAA@mail.gmail.com> <CAH5fLgi6NVagOPA_=r7Dmk9MFXrvZVuq85D9bsJfUqLNOZjCaA@mail.gmail.com>
In-Reply-To: <CAH5fLgi6NVagOPA_=r7Dmk9MFXrvZVuq85D9bsJfUqLNOZjCaA@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 18 Feb 2026 13:07:53 +0100
X-Gm-Features: AaiRm53ciXTCNQ_ps-BQuSDA2XXw4eXpbCyjDzFmZTHRgWlet3KnVIqUuIAfwfk
Message-ID: <CANiq72nCmZ57VmXsXdXbP9edmWYqOWCYgWNTPGKvxC30sy94KQ@mail.gmail.com>
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, Benno Lossin <lossin@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5F82B8000D
X-Stat-Signature: 1azzz4tw8czrmeykt6o5sduie5kph3on
X-Rspam-User: 
X-HE-Tag: 1771416487-554836
X-HE-Meta: U2FsdGVkX19kvrug//pNLJR1slmxaRj/TsFcK6+Co/3kndgsR7ko15T85R6jLkwRksExeHG3siv9Z06cjbysdmUoeKop67KNLRi2CMwwMSb35VUO2468TJkTkmEhap65HfuNpCrDYNc4eU1Fsi5b4LxCiB3MzqzSsfaOaP/kKzXNgGYsjLX4VjPSFMJFTIzksR0MbkieIFYQXiIyHGF9DBHV6Fkebyw5quPCE+GoLiO7W5eIROUuL9KdIEetjd9ZmXkUYvmZaIY+BQsvudmehG/y5pgvEmT37QB+THS0VgoHvHD1RDlHe0YzkgvXZ+Rch6Lddjnfasv6fnvrrW10/32LYpiY4WQFnGaFZNt7gIfsjkZ3I+OTeKiOX9rTL7hNuoxquY7G+GtZfvCOrR0UZMjur/OAcrIAxSDCIZ7MZf6gmq+ttLHogXWaP1AUozfpR6aAdF2K7bUNN0lQoF8T2cZ3wp9mXxzGbD8aPlDm9tpmZlGOuyFyVDOsqQpK33YnbmYc2du42i5YQarfVxXoGe8ai9IvSxoMAID32WcqP2ZGd1B9mhKxznhXkceMdPFES57l/mKExNiKNA2oquzJrDt0Yx1gqCQHPJhC0Tn3eAwZcruhVcW5n0wb/J5rjmmcGee8GLHfNyXUwg3RBsasSkhSW10Mu0X3Ak3PDtk2E7BnjA5MicmRz7ONGQYU/20WL3okr7k/PsJzU2rcddIDdNoe+AHKWEf7mxmL8N5gGCfnPWXb+Is43lXvkpNvO6uT65xANirGAYUK6BP4W4ZJ0oIzeK7PNJc+27Nj/FpquFthAeQdL50Pus+cFXikmC3exLqz0vcPJLBxNTcaHcZCsO+PwwXXveJRi7E+k69u4eUkJQiffkZoTL8DKZK5r2qvSC7vnoTfbSJmPpsYmA0OTP1abR1NoqoZXjP3gUZm2nScKBuCOpnpBEyHHwQSkG+PmC/xCgEplBGIOVt6TfH
 kxz0Be/v
 8lY2XooXIwnX+Rhoy484ATELRPOxgt4c0L40sptQZRApZocHn/Sf5Qf1n9I12twfM72XT1inzysEtdNXiofeL5IyxURKu9aI6elD3LJyHzwfag2Ld10pAB/AtG9IBWi9ttPxlapDae0vmrRtcLXGgCpntnwGdoBzT/fGq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 1:00=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> That's right, valid for reads implies that it's okay to read it.

Great, thanks for confirming.

> valid for atomic reads?

That is the one he suggested, so it is likely to be a good one if two
people thought about it :)

Cheers,
Miguel

