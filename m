Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6D6B606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 12:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EIYxJwKV
Received: by kanga.kvack.org (Postfix)
	id F14C96B00EF; Fri, 20 Nov 2026 07:00:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC5C36B05B0; Fri, 20 Nov 2026 07:00:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB3AC6B05B5; Fri, 20 Nov 2026 07:00:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF5756B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:00:49 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2063EA0EEC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:00:49 +0000 (UTC)
X-FDA: 85455355818.14.30C293E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 84BB71C000D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:00:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EIYxJwKV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795176047;
	b=Qp5nIHZvE620IPg9yJff9bd8d8jSKamm4H5oYBq2PfqlF+MxwYAWbx6+Kp9+CiHP/yVngi
	LEn1riFfXOZOslUzE85s75ypC+a7oTZ9SYNkI7Gw1jlI3wFMpJBTeCCAc2BeaGq8dm3EqK
	MDFyPJn91rbP0e+IvsHqr/pRxZ1q2RQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795176047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=beQWb4LoAtDg8Zy+5AKtlfFZLus+EPwyn9DYxNFG6mU=;
	b=GSMrVdWzahCAvEtT4V6B6ffPgCR5YaMFwTMM5pWzwMQKY/idubweZoLSegPCcw0mMEINr3
	l4jW9krzQOKg230pOfNIgkSgz4I0eV6mTOY6/1ebdR3ddLKYx+uQd79WbjsO2/orbIGqko
	oGDP5ZAdHhG9M8w0246umstrVHC/u24=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EIYxJwKV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F2A666185B;
	Fri, 20 Nov 2026 12:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5811F000CA;
	Fri, 20 Nov 2026 12:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795176046;
	bh=beQWb4LoAtDg8Zy+5AKtlfFZLus+EPwyn9DYxNFG6mU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EIYxJwKV6pKOzzIEBuRXOlDo0Y+HodiAO2ZB2R6VQEfoBQ/HvGlDsgCsZZD6G5Czz
	 6Hw2mEq4W7WWL2M0khcowQ1ijdyhpl4Mf5E6jvjTXU3BGCjU3W7JH3HwTFePuk7BsW
	 Zf0fcxra0plL9c0eF7Yjpx+CYN7bzoUzk/Q+FqleL9bhb1AcVGEf22bj+ScG5xaNBz
	 T66Fe3ePBa9AIlYOk+9jLYdZIJzmgdv7gXFnPj3yOg7RrM21kpYHHujoSPlrAH4uP9
	 arxmZfKtYgbrYZDY/oMy1BhaVWUrcfXk5RMw2HX+ZvgFLWMDcsj5WLUngXGiGzaopt
	 u7hrJu5tbh8fQ==
Date: Fri, 20 Nov 2026 13:00:27 +0100
From: Christian Brauner <brauner@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Gary Guo <gary@garyguo.net>, =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, Lyude Paul <lyude@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Dave Ertman <david.m.ertman@intel.com>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Igor Korotin <igor.korotin@linux.dev>, 
	Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Michal Wilczynski <m.wilczynski@samsung.com>, 
	Ira Weiny <iweiny@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Johan Hovold <johan@kernel.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Dave Jiang <dave.jiang@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Saeed Mahameed <saeedm@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Jonathan Cameron <jic23@kernel.org>, 
	Markus Probst <markus.probst@posteo.de>
Cc: Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev, 
	linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
	linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, linux-serial@vger.kernel.org, 
	Oliver Mangold <oliver.mangold@pm.me>, Viresh Kumar <viresh.kumar@linaro.org>, 
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: Re: [PATCH v22 4/5] rust: rename `AlwaysRefCounted` to `RefCounted`
Message-ID: <20261120-belichtet-austoben-januar-9fca976c1371@brauner>
References: <20261116-unique-ref-v22-0-12029383206d@kernel.org>
 <20261116-unique-ref-v22-4-12029383206d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261116-unique-ref-v22-4-12029383206d@kernel.org>
X-Rspam-User:
X-Rspamd-Queue-Id: 84BB71C000D
X-Stat-Signature: g54zx5tdyqcgdodwma1ezah8fmpmgetp
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795176047-434870
X-HE-Meta: U2FsdGVkX1+7hkBNUvboTQf7bX/bEqHUJ/9oOOe1VOjkJ66TeGYSNo9ngnwCxFlMh+qGqJpZ0iRqlR3hQyGESYXDy9FTnZkmlnUmU95MItfOu+e3ZP7XtwSvNqBgbXkzoDzEbTxS9cMy0FT6etUMm18e3M2Q2R2hpZ8KeIjix9dMrgkjF/nyN35OKR8qU0pRYVt5jZWsryS5WjcQ69lV9fPqMoJQ6gVRJZE+lGaiSaHQw96VwxtCssFfEkwQWPv+q2tV8B4T/PkZbDsqK1j3vff3BYuseSrIJNtweP4qIocOW0Oy4CgX37p98nOkQFJBktrr7GW1kvbpsFnd063/h5uPK2EXvfGjxTGhiHoUEFOMdWig3wSCIIfk1VRKT5m7pe4jmSy2DXXBprGM4vIOfDFmMJnehR9efwUvduWZTygAPuDNdII1zfS9gRzaZanTZwcTebe7iZiNFZmCzQx+41R1gPM4kdIGr48/O0XbUhl8ziVTm9zmL0ig3xDv4Vc6l7QikQ0ZA7nYyzEpZzj3VuKn+pFpRcWOk0FA45ifqdoCm7bRWAemn6Y2E/KHS6zYgvDWQvfS/c1yw2FYVg5PR1blaC8HUNwKy7u8eTXb7o6WWE0L/OOinihVRzea7oHYvO/4wQfuuLX3gbSloWxGID6uAketUREXi2PHQ6mnMsVZGe/5bLW8XHaLkRZ4NtzA9olJFzvtdSJdo0BmcE4/09rBXxhKcwIE+iNrlOncsv1n3RmJWDyGS2jY2ID7wPL92BZPPUYZiy+bAmKYNVWk6sgqGh0IXxpURaBjrHYUqAvLv+1wNfV98PV9C5r3xvUlHuQ5ekdJYmWT1ct9LfiVjtzBFi1ghosczJPujkzgQRWkrC5c63a7Jr9ROSVyAZgWg4uX/01tHQo0Glf4V6SDejT2FYQgK81g/0GGsh6H756JjpG4IijHUKTpbUE9EUNXDoGoEtG3eBPW2vO6ex5
 SHgdWpkx
 yB3F2EcnTsO1OebCqunCaBnjRwTVWjH1/pJgQB79mIDEtHjKkKh38kNNxbGG3JVuDgZo0TRQHkvwk39oc/0TypfDrA/5p46tF3LfU8Me3yEDX9lneNSOs17I/URFNfgjuMl9SNKvsUAqAVyE398NNvU+TbFRKbRz7/6/X1NXxhWigLUADWQLuM9cv0Ym8V6pmJTavMTQPoEsuF4ihEeZq+ZdUNh6aX7tOQl8w6W2X5dDXvUe1528FHaeX3hLcOLCW1wkJlB6EZ9nCMm1W1x9I9gWT3Ic6aiIpTD/JvAXTcTTtq76bj9xzMDMrXL3PQM1EhM8Ie38srM+4iRG0XFoEwbj7/vN0KD/N30SZs3JY7mM3Xn01S07XwTHrjPkYbUSQW3Tpj+U8LlacDORqYpoQQWYNS+FXLfJD916qG6W+Gr9gH+gj4Br2tADUmMb1MyxbN4NzWiXaA+bgFoUeYM5gMj8SLSn1qDLCZ5w1/U3xBBc1bAD//zZD1qrDI7hlGJ5JklRVV9jgwAO9KTtsoAUDM4B3MJ3lkCpuVwcT+92eOGOwn262RsfwQfG5qYObewlfSD/tiUjolKRyDgCNMRk5Pi6LPLpiiaB7ZkW79B05GyxqU/0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 03:21:01PM +0100, Andreas Hindborg wrote:

For the fs and pid_namespace bits:

Acked-by: Christian Brauner <brauner@kernel.org>

