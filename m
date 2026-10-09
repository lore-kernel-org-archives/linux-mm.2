Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D627CA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 14:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47EDB6B008A; Fri,  9 Oct 2026 10:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455EF6B008C; Fri,  9 Oct 2026 10:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36C486B0093; Fri,  9 Oct 2026 10:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 15B3F6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:36:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8FC73120435
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:36:41 +0000 (UTC)
X-FDA: 85303339002.20.0156DD6
Received: from sender5-op-o11.zoho.com (sender5-op-o11.zoho.com [165.173.182.11])
	by imf29.hostedemail.com (Postfix) with ESMTP id A67D0120003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:36:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=GC2wHIce;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf29.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791556599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g4UUnYhHV7ucZE6mbImtigGPnQ4SPA1INEgqC2/4t4M=;
	b=mo/HQWeqqeOcyvbfV0+gouHopCChs7qRWrknhEAnGEJZLqSGHhcA/kxxDuO18lptoxxGVc
	h8t3v1piiSnV5ttIa818+8cgXN3KQTvd8uEnk/GJTN/fECErExHrONjLl1nCJcNaYkc+3X
	MCkgJ17dXI2y7BtRzSgu5WJL6yIATDk=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=GC2wHIce;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf29.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791556599;
	b=EkpfvNIb7UqNc5BqM/AHaiOzCWleFwmvcXoWyC9iocwsnLDRkHvibGQ6o1MY7B50xeTB9Y
	WiUojWdg8Vg11pkjp59Mdr9OVzKmUceYLF6zKt6Dm6V5nMMfwu9f2xegh5a5MrXTM2zHKb
	dbChk8CbDDETgYNqTJYOFd811NDBwCI=
ARC-Seal: i=1; a=rsa-sha256; t=1791556590; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=nXhJggP73UHG7VkWulp5vqTh3BP6i7wGtgpkYOKUPOM+U/DzbpruJR/ymLbV6W5A7VrGFJFePxlIrWKqsm5DAyOZXN0BtWbeOMX3QdQCsEWJWHImyT2Or4aWCPWTAvgvht+8O/RHlrtpjIoqWECUU/UmN5eHIImEHr+UT2Mssvs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1791556590; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=g4UUnYhHV7ucZE6mbImtigGPnQ4SPA1INEgqC2/4t4M=; 
	b=BJP+s4ZrZgogIh2zHi2NnR8WAU/Lxq8QPu82ysdraYJBDRFlVTb2vRNZiklQ+ZsXrsr0XLmr1RdM+s7WLlaZNgpQM7JjqlxqDHgrgcTISm3Do4LCvFz0fAoCqjI2/n5/DRWXJO3zaRMjj4ynbkYjCMmJ/WDbI7LVNbHnHEy1I+E=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1791556590;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=g4UUnYhHV7ucZE6mbImtigGPnQ4SPA1INEgqC2/4t4M=;
	b=GC2wHIceWth6rBpgcOPzsl3yXK8F1YE5FnWs6ql6bagW8xh78+g7XtzA2VHQ+OIG
	35EfNElXdnDKSUeIvHcbg+KHV2qcZ0ILHmQUxTkv1HMT7AbOg6E4R6CAf1Zf5yfMlcv
	95+X5YbZersRMSj1tN6KPn77cl1Bz2t8PZkVGJAg=
Received: by smtp.zohomail.com with SMTPS id 1791556588006355.21426914343954;
	Fri, 9 Oct 2026 07:36:28 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v3 07/11] drm/tyr: add VM-related ioctls
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260929-tyr-ioctls-v3-7-26955fb111d5@kylinos.cn>
Date: Fri, 9 Oct 2026 11:36:08 -0300
Cc: Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Tamir Duberstein <tamird@kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>,
 =?utf-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lyude Paul <lyude@redhat.com>,
 David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>,
 rust-for-linux@vger.kernel.org,
 linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org,
 driver-core@lists.linux.dev,
 Alvin Sun <alvin.sun@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D57A468E-4256-40EC-99BB-43B931E0D4BB@collabora.com>
References: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
 <20260929-tyr-ioctls-v3-7-26955fb111d5@kylinos.cn>
To: sunke@kylinos.cn
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-ZohoMailClient: External
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A67D0120003
X-Rspam-User: 
X-Stat-Signature: n77cnrks8sz7bkah8w8urso68bnp9d55
X-HE-Tag: 1791556599-267275
X-HE-Meta: U2FsdGVkX19optyega7Chp4n6wRf8/1ZP74Gf5Lm9gpQBhexB0WByjebd5aJrBjFjylpOk8vhkFXaPpIBry9QwTM4pWQgjqsOsjdlBOeflMOOibYFRbCSDN1NdwePJrxZ78zUUiRqyHblqmMboCld3a7kG/E9uU5mx64kIqgX4FVuVoBDhpl/mWn2L4VnCLVLU9qaAIJGQMOrAZxineSTLueEBFU7Ml1D+uhzSPzZLaLS4IYkJiQrinLS6MCp68maqm4AbjXkf/ZKQ0LCPsZThxvhHvzWtQXPcJjXZPHRkQgrrSLumYvIfKIOwnFYkzU5cApMbcEZhwSA6stpaQtTj9553LDk2DR+E85GpnI2XjJ4SRUz8C/NVWnpjoNXTApfODAvs8iJSx1PnwMcoEImAnkA1bexhzcLXlR1v8IgLySqaeD0ggK+XWHchh2x6UpX4IXoUl4QFxd6wVE5treGuQX0NwWWlpphJcYNHF/pH8bsphZRSCkFl0Lc4cLtUVPzSFgsolIM+jETegur1T2iq5yo1rSoRaClXTzc4yrn1Tb1YCp7Wgy8GSFxsmWgx0CDufN4gebjVpe7Ym2kkIm2BSlcvbkyiW9Q6rmtS75+8mzeeU4IQWH3Uy8sL1pu2fDCq0fvmtMwE3bjpIDjX0Y2EJASFDUDHBzBGFankPVXrd6ea7TVa00pRjc4ZpJTJCMIB3v/DB5Btmsqz3Jf9eMeDv8dF/YVaOZePq8ke7t8G3tA9fVqXLgHrMBMbY3jREPxit98tD8F7RCZIdjPusCPgfo8IqvbpFrWvSqK2tNKtltey9P7WvdvgvVW8eat/InNV0z9zteV/bwIS2KOU3Yj5vpa0yjbcxN+cuCprUd7bWKNGTABxc7FVS/DIaTsHqionpe7SQ3pvi5PlZs0nwGC18yPLAT6cQFrli0NPwGnpc/yjW9SPeJiWgAX0okQnGAy2F/i2bBITxU33CLgdv
 KrhltmGS
 b8wDVdz6JzaZ/SS7jJyoyqUTmOCTNuBHm3g0CAcYv02V2Ca/cgI/b33M3wu9d1Txen+qBF089BARZ4M0u2KKhd/ZK8LWqxCHmc/UAPhnjUSZsfNSdP79kwugUQCt8iOuDO4gJES/9jNZewXkwuTGRmEL4hINN9R0EkAZnteHVndo06XiZjHIre5sOwRd/TC7YeyqLCRO5H32gUGf1gvQOJEyRk3o1g4WBnIcL0gm/dfQ56EUVt60AxzuWBszM2bdRicVbgQSQo/qfZAlxOmgc6/VDiaAh8bPwsQFG2TrzyApWTtj4UbfNN7TJRxKVxz9gt5mJ7SR1uq14Jw6zyID4jg7vng4JhSS12nTw+w3cdFkmler8MFJsTVZGZ+LYhB6tJUntDR4inFLdfTEvZ5+aScWg+s0UW1nyo/tzW6bCHipznts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alvin,

> +
> +    pub(crate) fn vm_destroy(
> +        ddev: &TyrDrmDevice<Registered>,
> +        _reg_data: &TyrDrmRegistrationData<'_>,
> +        vmdestroy: &mut uapi::drm_panthor_vm_destroy,
> +        file: &TyrDrmFile,
> +    ) -> Result<u32> {
> +        if vmdestroy.pad !=3D 0 {
> +            dev_err!(
> +                ddev.as_ref(),
> +                "Invalid VM destroy pad: {:#x}\n",
> +                vmdestroy.pad
> +            );

For invalid userspace arguments, let=E2=80=99s try to use dev_dbg =
instead.

Same for other places.

> +            return Err(EINVAL);
> +        }
> +
> +        let ret: Result<u32, Error> =3D file.inner_with(|pfile| {
> +            let vm =3D pfile.vm_pool.remove(vmdestroy.id)?;
> +            vm.kill();
> +            Ok(0)
> +        });
> +        ret
> +    }
> +
> +    pub(crate) fn vm_bind(
> +        ddev: &TyrDrmDevice<Registered>,
> +        _reg_data: &TyrDrmRegistrationData<'_>,
> +        vmbind: &mut uapi::drm_panthor_vm_bind,
> +        file: &TyrDrmFile,
> +    ) -> Result<u32> {
> +        let async_flag =3D =
uapi::drm_panthor_vm_bind_flags_DRM_PANTHOR_VM_BIND_ASYNC;
> +
> +        if vmbind.flags & !async_flag !=3D 0 {
> +            dev_err!(
> +                ddev.as_ref(),
> +                "Invalid VM_BIND flags: {:#x}\n",
> +                vmbind.flags
> +            );
> +            return Err(EINVAL);
> +        }
> +
> +        if vmbind.flags & async_flag !=3D 0 {
> +            dev_err!(ddev.as_ref(), "Async VM_BIND not supported\n");
> +            return Err(ENOTSUPP);

IIRC ioctls should not return this, but EOPNOTSUPP instead.



With the changes above,

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>=

