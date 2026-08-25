Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 134A5C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04FD66B00BC; Tue, 25 Aug 2026 09:34:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027796B00BE; Tue, 25 Aug 2026 09:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7EF76B00BF; Tue, 25 Aug 2026 09:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAE796B00BC
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:34:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5BBEDA2535
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:34:19 +0000 (UTC)
X-FDA: 85139885838.17.6133B6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C1A69100004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:34:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c4RbNxx9;
	spf=pass (imf14.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787664857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=izCY9jl5ux+/xwp3G6xz7Y4XyXtp+0iGLhW/GtYSXuI=;
	b=17UJ9WaALax09uQmnaA3IAsDeU2PxLwP4Pq+dEMV9KQod/JtM4mflSUD/70WVtRzB2Txaf
	I4KMLenF+PEj6+wLZbx07v/idKX/uOuOTjXtXqjaRh7ie7OPB/n9OADjgDgEHIm8cksY9f
	EzhLs/OEpK3wXeGNHremrdQmiZRiLQo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787664857;
	b=nYT8bM++ItoAd9pctiVbIWzzAzCNAZ22VtBz0CgBIAKnjMhQkUlS87cjM9sZqLfDaTptM0
	z8pZBSseLB3mB33q5rkh9MJIKUV0rVgmghCT2nQ0IEgWWyukpsTVeiBDVui27sWKLiYZ88
	1VB6OBBkIfhLkAcjurQDB+/8iPPcWQw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c4RbNxx9;
	spf=pass (imf14.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB60A601E9;
	Tue, 25 Aug 2026 13:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8EF1F00A3A;
	Tue, 25 Aug 2026 13:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787664856;
	bh=izCY9jl5ux+/xwp3G6xz7Y4XyXtp+0iGLhW/GtYSXuI=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To;
	b=c4RbNxx99qdAIlVUMDjcrwSrwiTcf+KRMHIyspQT8BsnpDvm2SZoSKkm+P2EHu2Ro
	 gI13x+I9KOAEC8fKB/NPiJ9JQfUbZrz1Q8dpZtAjsHOHUJjrnpFKnlZsA6R14/1+0N
	 82zFG7K8e70solKEqr73wvJixiwXqaACm5Se9k4RlhnfvVAh+vYk1n0SoTM/0tcPfk
	 aB+O2kumYbpwHuGdwNbv97z29ZGkJLRye5zustBansQZHpJNIXodNyArBYXjhu5rqd
	 5TaWL+Kh4tR1pQylB8IoBYRj1utmbnfcXvy4BBuVAzQUtRNTk3OxHbvukx20ZBNsTl
	 mpoZu06r840Ag==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Aug 2026 15:34:05 +0200
Message-Id: <DKY2ASIS7VLQ.3LP3N33T5V6N7@kernel.org>
Subject: Re: [PATCH v20 4/8] rust: page: convert to `Ownable`
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Uladzislau
 Rezki" <urezki@gmail.com>, "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng"
 <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>, "Trevor Gross"
 <tmgross@umich.edu>, "Daniel Almeida" <daniel.almeida@collabora.com>,
 "Tamir Duberstein" <tamird@kernel.org>, "Alexandre Courbot"
 <acourbot@nvidia.com>, =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 "Lyude Paul" <lyude@redhat.com>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?=
 <arve@android.com>, "Todd Kjos" <tkjos@android.com>, "Christian Brauner"
 <brauner@kernel.org>, "Carlos Llamas" <cmllamas@google.com>, "Rafael J.
 Wysocki" <rafael@kernel.org>, "Dave Ertman" <david.m.ertman@intel.com>,
 "Leon Romanovsky" <leon@kernel.org>, "Paul Moore" <paul@paul-moore.com>,
 "Serge Hallyn" <sergeh@kernel.org>, "David Airlie" <airlied@gmail.com>,
 "Simona Vetter" <simona@ffwll.ch>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>, "Igor Korotin"
 <igor.korotin@linux.dev>, "Viresh Kumar" <vireshk@kernel.org>, "Nishanth
 Menon" <nm@ti.com>, "Stephen Boyd" <sboyd@kernel.org>, "Bjorn Helgaas"
 <bhelgaas@google.com>, =?utf-8?q?Krzysztof_Wilczy=C5=84ski?=
 <kwilczynski@kernel.org>, "Pavel Tikhomirov" <ptikhomirov@virtuozzo.com>,
 "Michal Wilczynski" <m.wilczynski@samsung.com>, "Ira Weiny"
 <iweiny@kernel.org>, "Philipp Stanner" <phasta@kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <driver-core@lists.linux.dev>,
 <linux-block@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>,
 <linux-pwm@vger.kernel.org>, <linux-usb@vger.kernel.org>, "Asahi Lina"
 <lina+kernel@asahilina.net>
To: "Andreas Hindborg" <a.hindborg@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
 <20260824-unique-ref-v20-4-490735672187@kernel.org>
In-Reply-To: <20260824-unique-ref-v20-4-490735672187@kernel.org>
X-Rspam-User: 
X-Stat-Signature: q3bwsdbcxt7ptsm9zdy8nq3h8w66w5ms
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C1A69100004
X-HE-Tag: 1787664857-43261
X-HE-Meta: U2FsdGVkX1/vCNsSZqb7V14lfk3O+B+AQGHMML9JpNKml1hiHZFUe0JOdvbMcu2F5JbBQ68AhrEcRx5uNXrFD9yGecXBAo/Ae8pqanb/eKhUeZvU6XJAeO4/wFXfwRWpY/9A0g3e05J7BkSFN9CjXgyFnDHfnc5auzCsKwoz+LVeXEajkNiPcq3s1kL/tRCWpSqQKcO1jdruZa4e98Ur/6Zv8fJ5DvImaMJhhEqKD+KF2MGJGYrv21scU98yRjCDfM9eFGNuftC81TV/7vpxadm4b0JJcjz0X1pBXpi6ydT5QPzVeUyeKJTWlmCfuN8tqQdZ3mY6tiSceXZ0zJPc4PqI9dP9DK7e/Mu+p+DOQTKcCq2aGPgKHgPsOYm1wqa5GuRWvocJv7azJrz4saFHKinxHJb9L2Ll/TGzo0p1Ms9BSDKKVzeC1REipIaB1lYZ95I5xwtiaN3i2+0IkjvemIXbte/uOUJob8kuuZo2Ypqxkdo+qNxTw0NfU2VuJDynWIsViyR3C7OEjbIj9+xCjxt5gCPCkGi6tdqsXji48wiirANPzPiiXBBtSDDsQ5fPlGmdOUE0e6j4tA0i2b5xkUkpSDkBfI+v+7zP0WCNIcnitS8fIABfiXsLlaulYiH3Tm6mh3Czv0HhKUb9n+bDCgnspukCLn1mb+y6zBnXaB1CjUP2/E3V/HCNzRpgnhqnCjC5dJwyi8OP3S6aWQHZIv7oPqFYOuhAeMmFieEZQyirbNvqtQRprXc7M+V+J5HNWEWcb2el2WCp5TgySfLvBBmyrU9mv3fgYaZ4euOebwzj8Q47up84Q5OFCWO9AdcLZL2wPc+a3CLp2jEaAae1bDFdTzGm/tyOxGTjFQ/mcQp5k51CUfPeJP6u15aLSRpC+2pKjLPIOziEwAbvmfXQJt6KagL+e2KSOZKtJ6G4b0YhWn4/yLBtG/mOIxJOqcENhi9VUT6HyFv3cH1d3Pd
 +VxUWIcj
 uDoBrJi1sYbh3+omrHgi/L19wCgIN2R7Be/TVLHSWmlqkcB4MxVfKZqfeh6aYpNMybfDcZWF0vh7EAp6fhUcODongSFQzYAwe29d1J3nPS93CADC6fkKYkE/WB+4zfRc70BOtznC5W+7/niTlFZ+jAOLIJfSWAeJFmnIpT3REF2/g2UUCwPHGkY/VK4MYNkTvUVJY++4BMLsufxoPPFr0Sf2Y6g/6N02UXfouECKUYo4OZAys+Yc/mMJWBgQiPhEouGLa8LG5PBxxt8avqi8CLHNRemhMeZxCnbj5cfd8wt8teCyC0dZIyx1Zc1lpCF8OSqcgxTs6XdOJ6xH8j9Fed3riBd8lbBK7vmqSV5q8AF8BgRuODhRC3h+JYvB+9Pm0E2FHmvi580i/SPZ1cmCad4lLR0U3HoJ7M3Ea
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 24, 2026 at 1:17 PM CEST, Andreas Hindborg wrote:
>  rust/kernel/alloc/allocator.rs       |  19 +++---
>  rust/kernel/alloc/allocator/iter.rs  |   6 +-

Acked-by: Danilo Krummrich <dakr@kernel.org>

> -    pub unsafe fn to_page<'a>(ptr: NonNull<u8>) -> page::BorrowedPage<'a=
> {
> +    pub unsafe fn to_page<'a>(ptr: NonNull<u8>) -> &'a page::Page {

Of course the mechanical conversion is fine as is, but while at it, mind to=
 just
import Page, such that the odd page::Page thing goes away?

Thanks,
Danilo

