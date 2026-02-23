Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF96BEA4FCF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AFCA6B0092; Mon, 23 Feb 2026 10:01:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07EB06B0093; Mon, 23 Feb 2026 10:01:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6D06B0095; Mon, 23 Feb 2026 10:01:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D92166B0092
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:01:25 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A7AC559C0
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:01:25 +0000 (UTC)
X-FDA: 84476034930.13.AA65D3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 745521C0032
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:01:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OaigYStr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771858883; a=rsa-sha256;
	cv=none;
	b=Wv+O87s13bbDChDLQcb/FP+Nw3O0gqNnvDPZDxXjBSOl5WbhbMJyYlIeOdn+ku/b6+lZgq
	uOs0HZmnIqiCuavADsCylC8iy8ecbg39AaYh/van5u9YroKtPRxhRf/OMUeCXz369x9Qfn
	R5qtkrPXGZZsaeHZo+7r2BkyU0nJWHU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OaigYStr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771858883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b4ITcFsBb3mWAjtJBgA+NWDk2XDKe5cxIpGg9zFoLVA=;
	b=LcChWEcsMW3mpE7TkSypr1L84Z68awfAiciGMAUsjEsr1mwUtFqIgILDD/dFUtS/4Nkdir
	4HA+CpLE4WAsX6EH+9wjcUWjGxur9+9PHx6ymOlNMG71D11yw9KhyogP9SvNHmkymKRfst
	WGO+Cam2WSMYlEmMzbzhVHTRaG+qUfg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 97584444C3;
	Mon, 23 Feb 2026 15:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40292C2BCB2;
	Mon, 23 Feb 2026 15:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771858882;
	bh=e5c5b74M3vTmffrZkxVqf33SIGqWmbbti+5cabgqU30=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=OaigYStrS0H58RnK9jYWZCcHDiqSEdAX7xgm52ZiTIH2hOr6lFz0pfIeHqnXSx22c
	 fPLAmdIje8wpwT3qgmVJaXPsnkaS7NB7FwbUnfh6uL4pw4ZkNksgkgpQj1U9soOJP3
	 I8zQ06tXZJNH9bmYxdwifxd2hS8ZyCjhPsUEDM0WvensrAB7wgg+ERxBdKJP20LcBg
	 JyDzx8ODMtCb6QkuTBbIFDF1X1wLOYFev6Eyzhc0eMwdUu/PVzCaS4BJW214un6Gfw
	 oem2r/xcNVnvVt1I21kKCGINo2ZynGSWPrRf7980RO65Ev+qkS2YfdT/tsiM9Vv5jR
	 s31T8kd8QKH0w==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Tamir Duberstein
 <tamird@kernel.org>, Benno Lossin <lossin@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman
 <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon
 Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge
 Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, David
 Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Igor Korotin <igor.korotin.linux@gmail.com>,
 Daniel Almeida <daniel.almeida@collabora.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen
 Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Krzysztof
 =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Boqun Feng
 <boqun@kernel.org>,
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v15 9/9] rust: page: add `from_raw()`
In-Reply-To: <CANiq72myc+tCEHm0WtZspZHWwsSzvesxsmUvk31=GCdUN_zVNA@mail.gmail.com>
References: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
 <20260220-unique-ref-v15-9-893ed86b06cc@kernel.org>
 <CANiq72myc+tCEHm0WtZspZHWwsSzvesxsmUvk31=GCdUN_zVNA@mail.gmail.com>
Date: Mon, 23 Feb 2026 16:00:02 +0100
Message-ID: <87sear33pp.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ifx74er68us3r6kauwasjdh4apo95ztb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 745521C0032
X-HE-Tag: 1771858883-704708
X-HE-Meta: U2FsdGVkX19q/b4pDu0GMGZeZO9UpjvsO/FFGn9uqejw3QdntN5/hjrzvZ08zHHifgGpHYi+MNxwMmEn54AC8abh3LRMukuh6SmCHMlBZcOSGxXpuEjpOqU76LIxWwbvPEuc9QcxShcIr2x+VCUHecfa44i9J4lAn8rdQdMmrhmwWbQC1Bq7ys/Yl7uxw3TNnd4EGnXiOYh8VQt7dlZXgoZ92EuDRmMPSxE82r7uZFTvIgRETM0Eeq0nSeFW0qJLG3WmdSq6q2G121nKYDSeu5XaT4uqptVWhAzFiAAspIS53G/M4tDy3Odu0dis8u03g7TmCnnvgoH+OPdksa0M295l7Yb0/QciIkC9csmNNFPo6xxZ/HTzYWZRYdj3xjbS5RY4CGZ+wH4/gJuFOdW1e97EmAxllOGhn8tdTrz6dOhHo46yMo4V8hk6hZC+0OlcSPfq9VOwLyyrB+4F/hR9HGvcKX+CHlZWtI5n1WqhB98QRv9CbsvBufBGKmrtGNWHDA22k4fZxFo6Mfqj6wVHdcbD0M8ZC2/QalpIjgUBA7Gzom8L4CY5j2KSquoNMeMSEdZkddkGR/eaJIjlGLVV7lfjY+sxdfMl9xf6G89ycY7UKqkmWDQfTowdN653kdzBob4UAYYh1A8V05By1/g1vAxHYC7VFbagCuMyEfqluQvwqpUJ3Z+1w9N46r/bnvSktC6xwAKl0qanSs/xEU53859LCdWPmLsszNTUOQHYDW3C+Ln11L2Qqef1Y7etF1cQSXhlTfeLKcpxm2lTposyRIKKJJbh/tkuRH02ddNznfr102tBrK0lxxpVy+AA1GuDuOdSVWIoiEN/yufzC0dTeCnjuzbGZh0Ry4Ca7boxBda/9uAqGm20A9df7znG+9e4AS3/G1m1+1H6FE0tYv95bx6MNLAnMkqlQkKFmhQ1/XVjix+4VwmZeqaeJcfo4EtNZCaRwODlYdLItgjuX/5
 TpWTycw7
 oM2wFS2FXEGc0SJI5WQnGOAoxnSPyqjJgGhhmxzJCAoP6kxrz57ZTE4msAqNK4WTr3Kf1oz+95oqP90jod76cIh5hA6ejnXAd4Thz1dQPnNmjaXE+2AC5UZaapiEBkmNU5wP0Unvt/KxgwVcC9zlSnx+VpwXeTgO982wywk5Q21Vdt2Bnpjl9O0dYrbWHjrn+G5Ag4Tda1JEkXqH+NBf8oRPLoRwVcTQ0m30xdeauBSTVyFiNq/WmeYhNQ6RZwf+v9875BLH4ViKaPWUulGT715ctei3jN7PiNLoW1OepFDrw85LH/V9q7Z0EvkG8S93pEbDKrvIxAYMY6iNWffwdY3v+kh0GD0eg9qlOQbbyuq+17jRXtDeV1WBPIqBQZaBPsExJcsTcWPQzEwjMQLpOZDFFfNRxXmD2ksy4J4bcMwU+/ZGGxgelD7NT9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> writes:

> On Fri, Feb 20, 2026 at 10:52=E2=80=AFAM Andreas Hindborg <a.hindborg@ker=
nel.org> wrote:
>>
>> +    /// Create a `&Page` from a raw `struct page` pointer
>
> Please end sentences with a period.

Ok.

>
>> +        // SAFETY: By function safety requirements, ptr is not null and=
 is
>
> Please use Markdown in comments: `ptr`.

Ok.

>
>> +    /// `ptr` must be valid for use as a reference for the duration of =
`'a`.
>
> Since we will likely try to starting introducing at least a subset of
> the Safety Standard soon, we should try to use standard terms.
>
> So I think this "valid for use as a reference" is not an established
> one, no? Isn't "convertible to a shared reference" the official term?
>
>   https://doc.rust-lang.org/std/ptr/index.html#pointer-to-reference-conve=
rsion
>
> In fact, I see `as_ref_unchecked()` and `as_mut_unchecked()` just got
> stabilized for 1.95.0, so we should probably starting using those were
> applicable as we bump the minimum, but we should probably use already
> a similar wording as the standard library for the safety section and
> the comment:
>
>   "`ptr` must be [convertible to a reference](...)."

I'll change the wording to the "convertible" one.


Best regards,
Andreas Hindborg



