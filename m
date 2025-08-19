Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B124CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02BB86B00A4; Tue, 19 Aug 2025 13:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1E9D6B00A6; Tue, 19 Aug 2025 13:23:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5B978E0005; Tue, 19 Aug 2025 13:23:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF2276B00A4
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:23:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4568BC016D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:23:10 +0000 (UTC)
X-FDA: 83794177740.18.92B5A58
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4189B40008
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:23:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=R99CMyST;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf01.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755624188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IEcw8YukMBSRSfgVR4aQ1OUUrw+SZjoWnTgXZ8LvAnk=;
	b=F+vF+LgEMhoGbwuR8v4h/YQlISxn0fpcKOWURiIHuj/zTF8qvdHyzcAsQAICPICziGZDmv
	iIxa6J6VpWPC1gAOMghy0WBY3B5eV7GlASzcVae7Fbi9OubdXCFOkxrVWgGl4TTXtjWO7g
	TinSfvSjtgFaGDsuUMkoeIvx6xnIH2g=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=R99CMyST;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf01.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755624188; a=rsa-sha256;
	cv=pass;
	b=Xw+ILRJgXiR40wx3s7ysF7AmlsJ9fKO1IPBuJMSh48HOsHKd1+8iL18Uk0vFRkerdE+vw0
	BRTZlk5mdYXnvMx5GGsYBVrprrouWN9P4i8777dDDfMME4b7DhABWyvCLCJEoy/8E7w3Pg
	tWu+MlEzuuCt1BNq86vDDib+sTIUmwk=
ARC-Seal: i=1; a=rsa-sha256; t=1755624170; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=dB17iMupUftJlAcD6wb2PYq6XfkpeMPwyMGY1qBl7HKmzi6bPP4WdbqZdDrdUqiNBPlnFm9Pl4Bx6hpzVYPSjmQJcadJsyuCBF43wmhPveoypjdIHSdU24NIxdcxf+U6JgVDIh0H+rI+5oeoSSlzoBFb6pc7CJlRIzYaoY9sTPU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1755624170; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=IEcw8YukMBSRSfgVR4aQ1OUUrw+SZjoWnTgXZ8LvAnk=; 
	b=YF6Bk7Mt0+IE4c/6EOfrbjtV9WoESHNBs6d/lcbYDKg/5tCV3GN5oTTcLE7nLh1wtfXxYJkIK9aJa3Rck2u/0SktWBY375oS6HlFjYiXtYnRXVI+K7XzBkQnPUi+e5czCsUOYQEr40gOMgOIKQ6Ajb/Xuru6ko3O7ongv5Fpbjg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1755624170;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=IEcw8YukMBSRSfgVR4aQ1OUUrw+SZjoWnTgXZ8LvAnk=;
	b=R99CMySTuMb2AjbZ8UU/ldDlpGDB519kO1Tx6MgrQf2pZ6ewYD8pepJvEypBDOaC
	I5piGs1GE+5VAntotzPQdWYwNnbpiGjtMBKyLiakrpgMwfbaaD5OEKsBfZnp74OJkIv
	QPFbDqVLh/ZsRmcNYtTAgJd1LZWO2suYfpdJBe+M=
Received: by mx.zohomail.com with SMTPS id 1755624168270959.8687296541492;
	Tue, 19 Aug 2025 10:22:48 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH v2 3/5] rust: maple_tree: add MapleTree::lock() and load()
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <38B2DEA2-774D-45B5-8923-C5330B975FB9@collabora.com>
Date: Tue, 19 Aug 2025 14:22:31 -0300
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Miguel Ojeda <ojeda@kernel.org>,
 Andrew Ballance <andrewjballance@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 linux-kernel@vger.kernel.org,
 maple-tree@lists.infradead.org,
 rust-for-linux@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2E3FBB87-EFCE-425E-8ED8-6EE0EF19C6F2@collabora.com>
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-3-229b48657bab@google.com>
 <38B2DEA2-774D-45B5-8923-C5330B975FB9@collabora.com>
To: Alice Ryhl <aliceryhl@google.com>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4189B40008
X-Stat-Signature: 5ux7wbw13xubnmpq8x4ur8wadfwz6if4
X-Rspam-User: 
X-HE-Tag: 1755624187-891559
X-HE-Meta: U2FsdGVkX19kAkIL+0HqDfMxky3DLjwvZREJdSK20CLMRkBui9tIou9dfKkcMntxEcCpbeFULd3jGAdAr8qljVwyEZ4p1WzCJastgyfNULyeaGXdeAXIBGE91vMrp0vA3OCAoCQJ1hI8l/udtB58jwvmd3sY4jE2EHkKhA6YsxOSMjsLy1mhRt8TtXWp+SqtjVmCLauUx/kwFB0uKLp2TycvlTGeegMTLp0bdRsbrv5JsDcGBUb42x85XMc+PJ7xYm01AqETaYkoN9SO+eAEDytWICsV24weEYteyeSNbLoIOahIW+0qTaoAsDOZSsaSTyFYFew9keRb4Pg/Hdup4B18X7Uchcr464HwN/FuzyFklu0nxD/YkiNvzjNuWSetcxhnDBQDIJt869I5CIfOm76YHCeS+gm+lMDc+qpMlP1bBIpGdjnkRI9aY02OM5B3sZ+w70O7BPhBCDEunzfe72eT06KA6bAdnIxTxubK+RSfD/uuEzJPlE0jWZoVYX1nhNHvPrDpgoWCDpn5IMgSAwGchBC49wlOaxjV1qvDHYqOz/DQpb+NiiYGjjCnzPIRURq0/rBCRdLd2Zlw7+JrY8NtxpWxyFqTD2ahQbdmPgh7sHpGFnQqvBuNPAwm2vHHo/4LRqTBiXP1NRYbvGMd/GdSrqYLwoWvrypD2dbYXsMaHbwbOxeQR6sfcxVOBwyZKqJRm3Ruy6YWQ3sop+IoiXLmV3PjWEnNYJDbqlU81aczjThn5O2kFhCGLjiIdX9xWRD0dGIj8DHVyKHfbZ9IGM+HWYBN/ObO59IUwn0dwe9iRX4OpiXWLAOpN9lLq1kNO92kNB7HTCSWtpkbfSKb2kQ3p91xQnYMr3Puq5DdnchcPobgkjoXR5Lk0Y0xL/2PhF0JI4sl7k7sljKU98clokdBnR26hH4Q75cIh3JDWxbxKRaS2tnOaCVnMClrp4meszJyT8z3zXWNBDUiNqg
 vMSj1Mys
 +uVsbxELkCQWww9mXa6P82QZSvKcsNGNAHOuoNofzyhjvimGzXFX5dLMMGfP/nNxuJGVuciGeoRWnY3FpacaaR5xKFr2kKTb5NIgNAznbTql3X9aBPUT6BMHK/CyIWvUvuzd49HDPawahamElspxtTLQw+iBHGAX/z13NIr2srvWdNj7P+4LQvzb2nnJsHajKUAhStCp2NRPSXjxLLRMHV8uEoZsutCx8i8+EJgITH34Wl+y/fhEqrEOj1HfYYNCD82WB2HHlU8WHs2mb2/ZorAuiliIUzbDS1ZiQNy5LSrWz7D9/z7cC/NCay3GWA2CQ7StnAY+xoHvGKuxfWiPw9vs2i0jGviDf0RLuHrrLF8Lh1SfMLzvD4UnWVTO0aaCWpgAXmYSXJ9mWYisZLW38A2eQlsPiM7jIsBSJ13OFwZrrRZP77MZCQY2Mx+jTCt8D7autFBiEM2qzUUJDGku89P8D265GQBbsy7fqBBhxDMVd3L0Fpnqt5wNy9sbwP2Th/EO99+8RD87QTeDU8KH3g1osAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ah, something else,

[=E2=80=A6]

>> +    /// Load the value at the given index.
>> +    ///
>> +    /// # Examples
>> +    ///
>> +    /// Read the value while holding the spinlock.
>> +    ///
>> +    /// ```
>> +    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
>> +    ///
>> +    /// let tree =3D KBox::pin_init(MapleTree::<KBox<i32>>::new(), =
GFP_KERNEL)?;
>> +    ///
>> +    /// let ten =3D KBox::new(10, GFP_KERNEL)?;
>> +    /// let twenty =3D KBox::new(20, GFP_KERNEL)?;
>> +    /// tree.insert(100, ten, GFP_KERNEL)?;
>> +    /// tree.insert(200, twenty, GFP_KERNEL)?;
>> +    ///
>> +    /// let mut lock =3D tree.lock();
>> +    /// assert_eq!(lock.load(100), Some(&mut 10));
>> +    /// assert_eq!(lock.load(200), Some(&mut 20));
>> +    /// assert_eq!(lock.load(300), None);
>> +    /// # Ok::<_, Error>(())
>> +    /// ```
>> +    ///
>> +    /// Increment refcount while holding spinlock and read =
afterwards.

This sentence can be improved.


