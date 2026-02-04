Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F402E9D3FB
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 15:41:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD4346B0005; Wed,  4 Feb 2026 10:41:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A585E6B0092; Wed,  4 Feb 2026 10:41:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 963CF6B0093; Wed,  4 Feb 2026 10:41:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 81A306B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 10:41:40 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1613B1B18CD
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:41:40 +0000 (UTC)
X-FDA: 84407189160.10.C4FE6DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7213E18000A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:41:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YblZPv9N;
	spf=pass (imf24.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770219698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RmfM/AZglZOEG9CAOPaE0engWdOby0R8qOmmSRG9PzY=;
	b=XmYzluHrVHvUWQrWt7zU4aiuVr2HtGA7dq/OJbQcU6AcRtwAINzrHC7daO/VBPY+BTIVay
	AW4Fr+E98g8zf+iiktYvffqporTCcTsJ5ZBAp+x5AI0HPBik0t5YOW1xuaB2ybO7ie1C1q
	nSnht98R7qxS3HXooQ5vuXTe2b30sjI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YblZPv9N;
	spf=pass (imf24.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770219698; a=rsa-sha256;
	cv=none;
	b=wazbTRjF5DxJ9EVANfl5PWa4KaztWmQ0+4hvcoFlCDgOjPMOhPyj/8aAXv+ZFMYD4PAgRQ
	u6x0h6yBQMUizN+8sY8FU2s6w85ZzdbxvsiICCYqWekzJykIGAfiYjflFbkNMHpLHdJhyc
	PM3CWcvYWPHwU9YMlAGAg/7X7VpWooo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D79960010;
	Wed,  4 Feb 2026 15:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E497AC19423;
	Wed,  4 Feb 2026 15:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770219697;
	bh=RmfM/AZglZOEG9CAOPaE0engWdOby0R8qOmmSRG9PzY=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=YblZPv9NZoOzZEJVNv8HA1+4sFt1ES94BtjWj/jwWQhsxY3vxHvf7DqTQjEjeqbo2
	 FJ58mPfgwvoLWUwCabHSjaw7P9XfHuXBYHi9pP4P0EN9anoZf58friJHJvHzYEZKJ3
	 YSf1Sg9av7M3sW/wxmVSYf+8H9OQTpsN4hyu1DXefDBPyPxBT/EDgF1GIkrJNmKzE2
	 /Pn7KQINq88+5nWE0xyysbbTiRv94r/J9PC/wIXx0LkQ+Rexm9iDVw8wj4CY3cOtm3
	 yjgIAK1AFaVnQOwfUfyNh0bCF4+GnX9NHHcHDgSINoTEsHr0Scg8O22oJZ0KOaSpVZ
	 FhpluNISWJfGg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 04 Feb 2026 16:41:28 +0100
Message-Id: <DG6AIA0QK77C.EKG7X4NBEJ00@kernel.org>
Subject: Re: [PATCH v14 1/9] rust: types: Add Ownable/Owned types
Cc: "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Dave Ertman"
 <david.m.ertman@intel.com>, "Ira Weiny" <ira.weiny@intel.com>, "Leon
 Romanovsky" <leon@kernel.org>, "Paul Moore" <paul@paul-moore.com>, "Serge
 Hallyn" <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 "David Airlie" <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Igor Korotin"
 <igor.korotin.linux@gmail.com>, "Daniel Almeida"
 <daniel.almeida@collabora.com>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Viresh Kumar" <vireshk@kernel.org>, "Nishanth Menon" <nm@ti.com>, "Stephen
 Boyd" <sboyd@kernel.org>, "Bjorn Helgaas" <bhelgaas@google.com>,
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
 <linux-kernel@vger.kernel.org>, <rust-for-linux@vger.kernel.org>,
 <linux-block@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-pm@vger.kernel.org>,
 <linux-pci@vger.kernel.org>, "Asahi Lina" <lina+kernel@asahilina.net>
To: "Andreas Hindborg" <a.hindborg@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
 <20260204-unique-ref-v14-1-17cb29ebacbb@kernel.org>
In-Reply-To: <20260204-unique-ref-v14-1-17cb29ebacbb@kernel.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: yewwj64qq5t5jeueeah1d88ncwjirb8b
X-Rspam-User: 
X-Rspamd-Queue-Id: 7213E18000A
X-HE-Tag: 1770219698-850020
X-HE-Meta: U2FsdGVkX1/6FwBI5k+N+HHUbbm+7B9CXE4kAi5SS4vq7ei5KZjGT/RRtO1Illc4+/64aVfTMSnGRK6FVM58p+dMI8wbhg0gReEteujklIOnm6/EzpxFqCn1CdttUGQYRNZmpaOfWsVhGaeXSmxQJMVM8SRqSw2o9OmIA+RdXqZI9IB8Lc/Ei5V+h/XXAb6q4dU1RBMWsimLrM+DU9EfHExycpxRY3SJiOACou+2h8kXnUykSeEGk5jmo7+72yZNpRnaK2cWcB3s9/w4G3CrsDU5Vz38Fh3UAk1Gq8xRPYvRlqlfsTorqx5xSXsAEaCTFjRoxzWp8aM0jvx9C0EHMHyJDVYevEUMViSx9KfK0VTFP/nWOVr/zIqTVbZhuIatY8phMGAlVn2xN/xaDHw7u3yzWIfoK8Ot/HlVvZiqYFo7N2F15whplaSyozv/NEL2sSHhGSyWS+6V3MR/g0sDjqAY2r3+yV/iSd/OnUQnztg81ZXLeKL3bpwHu7n9ZeOpa81NW9VNsUDx+mBJ+mahj8PFf2jWrb8w2PNGf+CaMd8ipNsiGuenwK3hI8uF+jmDqJ0kDRwdYQit+w7BTguxXRbdRiPT2RurakrAX/fzE3/HVZoOpwAjIPMG6Q73KyM8PDrbgdT0mUMz2SOWNRBouprJWalY9HoUouE/o9cBBcP5CvjcfvKEj4oUquhPey3P29ZI2QepPyHcPnIrqm8kwiE+uV3T6PhWFVdqa/IpWA3mRS8CLf5/OWu7kuiBOcQ33n/SHdA6q9D9/F0MMowulFFxOkOqS3VVXAj4X3GcWV1bf8k4Ym+RKdmJ6G+WgKZ0ymZaOiSP128XqhDeBj96MWut8/Fgm6HF1gpOcXif8m7Dg4+U3H0kijVdfORB0r0owkXcFYMeXh0cl3J5oaMEeA0w6B9BFhjecULpz2GJTAlcAGUxw6FkfjAGGYK9aJG7nv0BevOpqhRMS7YUIUj
 MW+hrCnk
 Fv23TxhWt7bkMzYClKy9bdP22/kANGWI8tKjVKE58S1ErLPNyOwDu9JrVtrcmX613NsnorOB/AKZj5QDne8+qmpZCU8PCP1LigBGAMS8byaanu4YWNJgpxo2Mkvt0SzR9ITUk6M7DpLjR5so2syO6rfweX6aEUZ9WTmRnAprRAsm4qj21GQlalbAHkBJT9rVz/43+hY/0Q1vbScg4uSJp02ffJ+BkrDzRBVYQIjLFW/n5vn17XfpmLkYj2OfXBLz7LiPbkZBqQvATeq+e9RYaHjZvrz1hhHWaVf0Uuj2O5PCOmXrNzOI6//NWDOWbmAzW7l0rVn/iwJjA5+hFup7RYThF0rhSXms/v6x4+Olja0WWN5auKkMdh4NCtbn+TFh5mD/DEhfHXEdzp88Bj2yBqnblrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Feb 4, 2026 at 12:56 PM CET, Andreas Hindborg wrote:
> From: Asahi Lina <lina+kernel@asahilina.net>
>
> By analogy to `AlwaysRefCounted` and `ARef`, an `Ownable` type is a
> (typically C FFI) type that *may* be owned by Rust, but need not be. Unli=
ke
> `AlwaysRefCounted`, this mechanism expects the reference to be unique
> within Rust, and does not allow cloning.
>
> Conceptually, this is similar to a `KBox<T>`, except that it delegates
> resource management to the `T` instead of using a generic allocator.
>
> This change is a derived work based on work by Asahi Lina
> <lina+kernel@asahilina.net> [1] and Oliver Mangold <oliver.mangold@pm.me>=
.
>
> Link: https://lore.kernel.org/rust-for-linux/20250202-rust-page-v1-1-e317=
0d7fe55e@asahilina.net/ [1]
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Given the From: line above, this needs Lina's SoB.

This patch was also originally posted by Abdiel and Boqun and I think we sh=
ould
account for this. I mentioned this in a couple of previous versions already=
,
e.g. in [1]. I think we should account for this.

[1] https://lore.kernel.org/all/cc28d048-5e0f-4f0e-b0f2-1b9e240f639b@kernel=
.org/

