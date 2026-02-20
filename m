Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4DDFC5518F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 10:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95F56B0088; Fri, 20 Feb 2026 05:50:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4D4C6B0089; Fri, 20 Feb 2026 05:50:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3C436B008A; Fri, 20 Feb 2026 05:50:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B01D46B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:50:13 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2BDD5140C24
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:50:13 +0000 (UTC)
X-FDA: 84464515506.22.E11A9D6
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 15B75C000E
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:50:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2DcS2NV1;
	spf=pass (imf28.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771584611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UAf0+WPiEFSXz/CCPkkC3DmUlSyhmOoTBssum21ipoU=;
	b=RgslRsZEz2UBNRM+uzQcJEZsGmpQZSrwGt/5cu/TVCY3Zyzs/cFxO9RE6gel2aHcdmqMZt
	OpSPNjpj0dq5oMilOFZI+EctkvA3NEkFledOVY9z0xkyuR3+v1pxgEqDbPvkp9ph64irhv
	Gm9uTo88h4HgAE2CVDQJ7rb87MkWqVo=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2DcS2NV1;
	spf=pass (imf28.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771584611; a=rsa-sha256;
	cv=pass;
	b=P9ZWPKQkCB/IouC1mMvHZaufRQ7+jGGfeVon/QpT+ku6AphBHyGUtCSJsrSuXQTzE9JcZ/
	YweXtNlBsPOjl0u5kcM50Drsi8FJ1QRq5/ZJuQ7J9KapN4nIHniB0Z7NckARgaoQt+jVD6
	mUqSay6U+jeHGj2CNKn2WqXOrXR6NU8=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43638a33157so1805135f8f.1
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 02:50:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771584610; cv=none;
        d=google.com; s=arc-20240605;
        b=ahWsO4tZexdWrXzerjquQGk0+93ZE8LRHRaxImw4Is2pG+cP6MC8wEoKx6tmXNuDpM
         /I+DcYHKAoCvt8BYauwPvP6m092YRlur22fsCvcxkkiupFO5TaIfmj/bBwlNP7vZaXEF
         wkNhht4kyDRpf/b04SyB40cmfJdrgpd5zRtBTWJsXe5CR/qjM+XS1RbzfG2ff/HJ1AuB
         xsHn49rAAmoLay005IhUJN23ZpdPR8HArjSf6+6VlpW34LC6h04oG+IR6RRp05vUW2vg
         f2/LjS2Yf1af+fv6k2AnsSNOh9pMpLnGKmTWfRfSy8OWGUS9hyDsGKIzu4J4FtJRKWyR
         W3qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UAf0+WPiEFSXz/CCPkkC3DmUlSyhmOoTBssum21ipoU=;
        fh=6GmM30I050fVfdm9vMdiEYrtqwhnsgt+oiIIzhQGGpg=;
        b=i0GpuqFzc0VRzKzlTnmFMXNluG5Psf373ywJT84zqNZdPfU3WaqhfsyGfActuxbCOm
         8sNjqFe1b3IJTgFPGy18eyd74Vx3bsgv5U3l+iUmeAbSnc7FDoXMDcSwwnpY/a/IdJ63
         FcegEHbw57VXPE+UO39AGzsnPljuSos34hSrukB9roW8jWYFq+CTlT8nQmmKchf6zhUo
         HJ5hThl1BGo8RRRkFRb8Y+dNbbAb7lzzVU624/DPWGCknG+BaKtLlBSwO0joH8WH/VsL
         wFqPfRhSEuN5MpZDrp8kyCr4Ff+mKBzwQ6QEsOIaGFPL6U8uzbaXhW40U+V3vbVY1bLy
         Bl1w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771584610; x=1772189410; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UAf0+WPiEFSXz/CCPkkC3DmUlSyhmOoTBssum21ipoU=;
        b=2DcS2NV1dpipI6ZHQRfyADH2o/O62r9DRqPq/0Ryedpx+K+RNCYnpOcxDM/gxPn69k
         9fypS2eFZI/Ap+mbP6w71XJSj0cmHy8ihuNcx7+CXMo0HVc6+yq0C7tZvtXmAu6TfcEf
         5xnZxwOFkFUhP3cdS3jTIey6ciE4AmH32hPKTUUzW5DqqvHiaNLC5Fk5L+PHKsPd+Jf+
         Mb2VDoJGbl3kDROzyAiovD3S/kU3OFxq1xYoRm4Ar1of2S9iSdNbXfovanmacvglvD93
         PfeFjTJr0bsk2qb2Wd7MgUyn+GxxWdTDzv+I6a1micsZX/zKD+oPPZ+JSjehINiagpUx
         PpCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771584610; x=1772189410;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UAf0+WPiEFSXz/CCPkkC3DmUlSyhmOoTBssum21ipoU=;
        b=gqSoNwOQcSes43znkXtaXGUeZ/GyJ/Gi9/sb0QgPhLifizqXouO95GGN/Ttrce/2kg
         vugl5cKNfj+bHks93ZSmXKttV3GxJNo9wuR1JuvpkEchOlmU86ICltu1jHRpDKOlGwPl
         dqL/5udbViaDGnKwq5FpIkFDFju/IwVnT65GdpvVFSRr3r1whDEltB1DJCQWB7RD/kCg
         QIA9oDFoC+vo5LxOabfNb1M9KDq4TOFo/hTQxsqEH76f4Pjiw+GV+GduCp/1VGFVN3dU
         wjI27pFSdibEO5uGqNaQxQtp8yoXdWiuleq/JcJyxUWO8ZFHH6VlOS3tXwuneE9aoBV6
         SNbA==
X-Forwarded-Encrypted: i=1; AJvYcCUUb0g/5LxIIBRYaBW2WT/weHN0v7b8w/ptuLvlMXWhiA15al0Z6yfdOR3F2UWj/2CQ6IVmYoZBTQ==@kvack.org
X-Gm-Message-State: AOJu0Yx4684NH93FLyDaY6QU6+mu1XMX3JpMjQi3/lKiNINzH4JDCKSJ
	SsseBFkANqKNqYEnM20mcq8rwZNg6hWPnhru/wHVETPKC5Nm6iZsGevX7e+Ao7c4v9QY8o2PYqw
	kwx6fR7G/5DpT6zXBGpAnX2sp/yUZ5CyxEiaoL5id
X-Gm-Gg: AZuq6aKVuJGty/ubbmhf/0Pke6zGPXdL7eHDabfYeehfXWBQndTh+k/Io6SktLaQmAR
	WNts958qy30VWufZm2w5CKTPQAp6IVy7Pbe6iscpWxIaUeVbQjM4frFfxt04rBLaicfaYbRR1eR
	PDImwfnuxD3A9B4i8Dlw0v1fUYzEaMzu7o9mr3Pok826/Vtk8wGG7P6KIYkA53Yhb9ZqyZ2ITnS
	BZfqq9gmAvt7iZSIh4AKi0k+CNlPNOwAVoILTJSk58ZGcOjcqZojuRlf37n0Dwkv9ITIORCeVnt
	rL1rVwkFSzn0o+WZ3VPJ9MaEt0StKsaGcajUrg==
X-Received: by 2002:a05:6000:2409:b0:435:95c9:6895 with SMTP id
 ffacd0b85a97d-43958e00ce5mr15101201f8f.18.1771584608836; Fri, 20 Feb 2026
 02:50:08 -0800 (PST)
MIME-Version: 1.0
References: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org> <20260220-unique-ref-v15-3-893ed86b06cc@kernel.org>
In-Reply-To: <20260220-unique-ref-v15-3-893ed86b06cc@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 20 Feb 2026 11:49:57 +0100
X-Gm-Features: AaiRm525n9TXR47KvplRQPUHuuUwgU5iN4_ng3kUHWK8LN9TrQcHulfhA1IhjZ4
Message-ID: <CAH5fLggNjCZ3AvHnhO8O0cmd33B3zMbfq+hhNvonznTsLLtgYw@mail.gmail.com>
Subject: Re: [PATCH v15 3/9] rust: Add missing SAFETY documentation for `ARef` example
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Igor Korotin <igor.korotin.linux@gmail.com>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
	Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	=?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-pci@vger.kernel.org, Oliver Mangold <oliver.mangold@pm.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 15B75C000E
X-Rspamd-Server: rspam02
X-Stat-Signature: f1xumkdr3h4z9ktnwe7pwi17njcqfjfz
X-HE-Tag: 1771584610-724310
X-HE-Meta: U2FsdGVkX18M1VLljlcaA22WOW2NtX4OLPjkT2fZA6TE3tyKOWXvJmc74ki0SY36E8t+Dbxg6WvVTRDGFugmGYFWFSA0GEmwqJ/KXM8M9c66VQep2S9Jeb0jeGRqJ3jfyOFnWOQsBItkgAo/XG7T8MmfJg7WcrRSR6U8A2XewVhkxMlpvlRIJE6PUS7mrRDw0sKR8LWRWYMp5OIj++Ut8NpCRbkjSu7P0kyFiVz6GQGHFyplP1MTAqFC8kmyPQ4oyFohn/6MElfGHXvg89k8V8G8/LAXOIgbHGoq2jSVkygGxxqAl1+Xkw54s/VMyqQKnaM4A/4bdKCddIsVTvoYULdyHJOSpE4zCn3IxxFIik6/TIjY+4z6EfXS0fyRTb/Zldiy3i0Y1C+Bx71CcEeP+ud+t2X+rUjFHspwfgbTDEsj2TaQyqAwUNeyXdqIR137DsALjcMvFG+1UK7M0t9/Posxn/3ooDggKaepRPcfh89dPvnS3m1fV7HHNbLAQz8/bKTktNTj0edtxpOoHLB2mdwOJjK4kotEgjkM6/8v03brbJ+Ua7c2jaBK3lidktECccA1lPqybZM8FbiyqfOzJEKJ/BET7v2PSBjUKigMDE4JK7tOM0lemGNV5rhF/1klsyWSYldJoIyBGqfHQsVXT1tcI2YThRkr8laJCs2jr0YCgVYmtroIS1wUjFkUaAmfP80e42bFP4nJxHmZjjJL+CdBSrC3TR2NWzQOvELvGlDQh/BO4JCjmOBJHywv+lWzqI2AflH8OqV4Vdahs7IQk8fUUgA8vWdE371+2GO/j5+pTzlvJkPwDUuC7VoK8SXWZPYBAq7aC0ZMs8VSvjAaCEN5bX9ZTwpwi/sJurtRCJpfsyOONymmzfXZ9NrYsSYusCn1Cugq0qnfWoOA1dD79KaI4myEaX7jdyVz1/pGvJlbXYw6RuCtdysiskmIXvZBgsAmh3G09ieZKurYTF9
 ZPWGqvDP
 yNRXLCuUCrde3Q9RsViwjMiZIeXH6327Lk1uLSkw9LXyxgOG1qpe+uTVwK3bQYpca93JSJws9dm6m6UyoICjD9HSnYYUCDvvHrBuvuohBJpsJtevjr6L3cQVgVbP3+lqgqrikLuG9TxnB/wwKEr4coqCxKRgG03KoCGUa1TrENGa7NcI09MpoOXdD1QoQFD7btxOq5i39IdwZozK9iWoJ4+0YlivsRgWtz5vac0P4mGolHD/KKkVThML5lGPOJZlVqB3XbgLGLgFPQwxKUuVKXzo3U6jkel9WeNttjeDYsVUkJdy7+TpX1HGHlXA50/tDt77B4wfQX1DtEKFTIltycnvZ1M66egbZ0yC6OPc03zxkEm6lw6ovlSJdaOGYVfP68JlO4wk1+M1M4ohp/B+DJ3OjrYStGRze3elxdfa6mOlbpJeTlvb7gvPKcpvrrxkkqN5Ptbncdk3tFSMFJQeYkvqZAYA/j9OMZnfx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 10:52=E2=80=AFAM Andreas Hindborg <a.hindborg@kerne=
l.org> wrote:
>
> From: Oliver Mangold <oliver.mangold@pm.me>
>
> SAFETY comment in rustdoc example was just 'TODO'. Fixed.
>
> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  rust/kernel/sync/aref.rs | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
> index 61caddfd89619..efe16a7fdfa5d 100644
> --- a/rust/kernel/sync/aref.rs
> +++ b/rust/kernel/sync/aref.rs
> @@ -129,12 +129,14 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
>      /// # Examples
>      ///
>      /// ```
> -    /// use core::ptr::NonNull;
> -    /// use kernel::sync::aref::{ARef, RefCounted};
> +    /// # use core::ptr::NonNull;
> +    /// # use kernel::sync::aref::{ARef, RefCounted};
>      ///

Either keep the imports visible or delete this empty line. And either
way, it doesn't really fit in this commit.

>      /// struct Empty {}
>      ///
> -    /// # // SAFETY: TODO.
> +    /// // SAFETY: The `RefCounted` implementation for `Empty` does not =
count references and never
> +    /// // frees the underlying object. Thus we can act as owning an inc=
rement on the refcount for
> +    /// // the object that we pass to the newly created `ARef`.
>      /// unsafe impl RefCounted for Empty {
>      ///     fn inc_ref(&self) {}
>      ///     unsafe fn dec_ref(_obj: NonNull<Self>) {}
> @@ -142,7 +144,7 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
>      ///
>      /// let mut data =3D Empty {};
>      /// let ptr =3D NonNull::<Empty>::new(&mut data).unwrap();
> -    /// # // SAFETY: TODO.
> +    /// // SAFETY: We keep `data` around longer than the `ARef`.
>      /// let data_ref: ARef<Empty> =3D unsafe { ARef::from_raw(ptr) };
>      /// let raw_ptr: NonNull<Empty> =3D ARef::into_raw(data_ref);
>      ///
>
> --
> 2.51.2
>
>

