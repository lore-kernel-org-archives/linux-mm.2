Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38BEFE9A047
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94DB66B009F; Tue, 17 Feb 2026 15:36:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA676B00A0; Tue, 17 Feb 2026 15:36:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CC876B00A2; Tue, 17 Feb 2026 15:36:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5636B009F
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:36:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 189BB1602B4
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:36:16 +0000 (UTC)
X-FDA: 84455105952.09.98B8ADA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4EFED40002
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:36:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rtD/S8cv";
	spf=pass (imf11.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771360574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9ebv1IdymMqISuF6Bvk5yr/zCSbo5wBPDgHfqRgBQM=;
	b=nM+IVqhQRFfScj5zz+2PmPmnzFsX0uEt3UYAkKpzzogJ59yL8llMLwxouakrlSMWmlH1mV
	ZaJgLsiRPEveEDcyrBJOYMmQDXoWNPdbkmiMd2KHUAomvY9Jv+nozPnoE3tb/vHUKw1PMe
	CRoJsM0hx5Svsoh9lAASnuq1l0CUdWo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771360574; a=rsa-sha256;
	cv=none;
	b=osIagrKPkbZzMCKysYP6coIVUm2tz6uPFNucza08saNpXQc4lBxQfTelHDU+7rEkQyBRJi
	DACyNIu+CYdIx3zNe0HYWyYbbNzMNzyiYUD2KsjyRmJSEKu+WLRQsiRckHPtG02uAiOmFS
	H1LgLWGksg86qStLF/B27cHSUpj+z18=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rtD/S8cv";
	spf=pass (imf11.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F2AD43929;
	Tue, 17 Feb 2026 20:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD193C4CEF7;
	Tue, 17 Feb 2026 20:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771360573;
	bh=Hre9WgpSXBPPAauTT+j4xPzl+La6DQvAfmH8iONcoq0=;
	h=Date:From:Subject:Cc:To:References:In-Reply-To:From;
	b=rtD/S8cvmYyGB9r+fNWB5vstF9bRcUNPYjgbX26nD2szUJ+BaOv+0DQ6wo0vwXq/F
	 g4SCh8+TMS7aCiwxR9Q+4WDechO2/HhSN4vS86rKIRAZ8eE89vRwiZWZ75JlJo46Wf
	 4nZWYOvSnPrCQM8pqxLJjFU62FEAYgWhPkPlSihqSwzrD0AKHzjR6J7iIKyPmYKXZm
	 5Odm3FG9JM3DLyaviylQ23YjEV9D234nnebZcDOyZwMl9YZScUjdyHl59HyBt9ZOHG
	 bOgCBYNhSVjLyGvggSVk2qKiO4/v0JbuhbNTiqK68jEsZX59TC4YR+/FT7BbpdzGlR
	 G/0xVPiUp9vNA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 17 Feb 2026 21:36:08 +0100
Message-Id: <DGHIWYZTJONF.14FN5LON1T455@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH 1/2] rust_binder: check ownership before using vma
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Carlos Llamas"
 <cmllamas@google.com>, "Jann Horn" <jannh@google.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, <linux-kernel@vger.kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-mm@kvack.org>,
 <stable@vger.kernel.org>
To: "Alice Ryhl" <aliceryhl@google.com>
References: <20260217-binder-vma-check-v1-0-1a2b37f7b762@google.com>
 <20260217-binder-vma-check-v1-1-1a2b37f7b762@google.com>
 <DGHC1OLDIXC7.Q4IAOOSMHIY@kernel.org>
 <CAH5fLgj2+XUzsuAnvwL=dc=5yOZvXCapBWRbFGwJAX2v5Wk4dw@mail.gmail.com>
In-Reply-To: <CAH5fLgj2+XUzsuAnvwL=dc=5yOZvXCapBWRbFGwJAX2v5Wk4dw@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Stat-Signature: yiyy5uho8njbuaz7utmsdsqn1y44n1gp
X-Rspamd-Queue-Id: 4EFED40002
X-Rspam-User: 
X-HE-Tag: 1771360574-128023
X-HE-Meta: U2FsdGVkX1/+/GZ2RgfL1vzYUP3poHHxlJ0eY6E98eRalbluVGTtNBU0O+jPfJ0x/mjvX3xE3CSS6deWhyMoZXNlEsAMXhL7YAn+bloE7Vj4pwxvrcIowUOHKOcRinMNUBcIp7Vc2dSI3A0z0TGksnq1u5wukVHftFcZgpiJeYR8uFSj2Fc0eHeDv+nidTa6NoubfYxTu3J1HpTyHsTnBH1bLhlxwzhXsEBuPn0pVD+cCGuifpabk7vPIaPFzyOjTqbr0+afJmCk89HIOl1MfFB7pC0G1LA53RPBs/3KewDsaPxGkGAKM6dHY+9TBfddktPTH8eUBdKri1N9YJoV8BX3bH/yTm+uAwpdzwXVR7ZaI8nHANVySB9zqdRet2Acm0VE4SN+hnRxDQ5ol0MAgxcrRORP8McXipiWvez2D62tDNnyMjiIx60EWenFMoFM+S+zfuDqybkjzt5NLb2QBTm6jG3AyVneH7/ZUOmfzzH6eIuRXDXtLszGRsHBBrkS6XkuXmh8M8c4MFmZSwO3ZA6WssWCa4ON5xUTJ4/P+33SxyDG31xybhuP1xipQOGHvKe32OaVlWx6ljbMJX2O7GamFj9ph2qEy5kLKB+3bjofrZEz1drI9Qmf+h+93JGawTJJSNXqoJuBh73yHPKL+8r8hK4lVZK5OclxKP6oIaECtpWL/k0AcmL5/A+1SzjjdcROD4CjJvdenGQ9OjIa1Ex194UsRb5QjxAa8CqaXMpLZ7DM/eExL+IWl0y0nh++ugJVxtCpY7y1TvwhXBa2is2bxI93OxJE+s4Pr1gVuaRfUYPQNdnmvystIODRenynHMIwZCPk/v45N5CCiXXl/cxvls6jGrwCgsHtUWBGqROMESmZKUtlTzufF7OF61ABRIXgnEliVctT5La8Xfq7A1ya8Gqw0q9OpE4W8szLYoOu87ChQaNOGFByvMD6YrbgGDq6AxKKFwFV578Svxb
 6+HZhG9H
 l3iVmIt+kW6r0GaFw4HTUb1iKU7UT8YbwMStQGsBrF2TyzkVXBVDgpm9Ku6DgjHpjV3WzBEjXjVz5dGlHMx5OFhPPSthkSRzi9GAo4pHZajePciEHC7zxZOZVj8kodoTNoIskkV+JkWtjzpbGiD5cEvqUHL7Vn5wTbiXsFYc4XD7kdNydJVSEKyLAP535OLd4fwl03YpgBJbPSU3pZvzg36St5bEnMP33/QI2wtkDiBnq/L3boyLF8VTi6VClhC7Q8p0VnP8mVC4s7MYh7uowlXCRu7cGk8seqC2KmfmXSvcFVwNKwldoP7+nzJJ+kyUYvk+qq5dOJYZHIvlGEgrxPPSUGEW5g8qKHZnm4c5QKx1/40t65bm0QD4oXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Feb 17, 2026 at 9:12 PM CET, Alice Ryhl wrote:
> On Tue, Feb 17, 2026 at 4:13=E2=80=AFPM Danilo Krummrich <dakr@kernel.org=
> wrote:
>>
>> On Tue Feb 17, 2026 at 3:22 PM CET, Alice Ryhl wrote:
>> > When installing missing pages (or zapping them), Rust Binder will look
>> > up the vma in the mm by address, and then call vm_insert_page (or
>> > zap_page_range_single). However, if the vma is closed and replaced wit=
h
>> > a different vma at the same address, this can lead to Rust Binder
>> > installing pages into the wrong vma.
>> >
>> > By installing the page into a writable vma, it becomes possible to wri=
te
>> > to your own binder pages, which are normally read-only. Although you'r=
e
>> > not supposed to be able to write to those pages, the intent behind the
>> > design of Rust Binder is that even if you get that ability, it should =
not
>> > lead to anything bad. Unfortunately, due to another bug, that is not t=
he
>> > case.
>> >
>> > To fix this, I will store a pointer in vm_private_data and check that
>> > the vma returned by vma_lookup() has the right vm_ops and
>> > vm_private_data before trying to use the vma. This should ensure that
>> > Rust Binder will refuse to interact with any other VMA. I will follow =
up
>> > this patch with more vma abstractions to avoid this unsafe access to
>> > vm_ops and vm_private_data, but for now I'd like to start with the
>> > simplest possible fix.
>>
>> I suggest to use imperative mood instead.
>
> How do you propose to reword "I will follow up this patch with"?

To fix this, store a pointer in vm_private_data and check [...]. Subsequent=
 work
will follow-up this patch with [...], but for now start with the simplest
possible fix.

>> > +        // This pointer is only used for comparison - it's not derefe=
renced.
>> > +        //
>> > +        // SAFETY: We own the vma, and we don't use any methods on Vm=
aNew that rely on
>> > +        // `vm_private_data`.
>> > +        unsafe { (*vma.as_ptr()).vm_private_data =3D self as *const S=
elf as *mut c_void };
>>
>> Maybe use from_ref(self).cast_mut().cast::<c_void>() instead?
>
> Honestly I think this one is easier to read as-is.

I remember this series: https://lore.kernel.org/all/20250615-ptr-as-ptr-v12=
-0-f43b024581e8@gmail.com/

It talks about enabling clippy::ref_as_ptr and I think we have it enabled, =
does
this not apply here?

