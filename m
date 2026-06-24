Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B63DECDE000
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 19:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63C116B0088; Wed, 24 Jun 2026 15:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6136F6B008A; Wed, 24 Jun 2026 15:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5508E6B008C; Wed, 24 Jun 2026 15:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A67B6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:16:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9AACA8DF5A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:16:30 +0000 (UTC)
X-FDA: 84915762540.07.462B6E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0EBCBA000A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:16:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XnOgRR5K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782328589;
	b=cne76AQGDuZ8/f+ApBNt1mrePBczgd7S2Jccygb8aagwSlk/diF6GSlA9W8JqsdGCLtiDG
	/ghNE2qzkrbn2zf7tK0v3ibE5TLRmzwFBLGVPFvb2q3qp0oCXQzPKY6plVKPjMoymScl2q
	C/Q8p5fZjzaKT46OKfbKRtEsk3VtcV4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782328589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KrEIkLxcPGYN34vBeTlzsqHNKqQFfNJZucq2NDeLFds=;
	b=YL73bc7sI71rZ8O4XPoC3mUtsOaGihUofFOnPC23ZFSWrjPacp/HFsTn3hUYjKiTWo7iZ/
	vsZPE3ufoTgLo0y22u7kBVUredZ92zyzrrffh6E95IGm6g2LhyF4q9Fbf5rLdRIDaRZi4X
	/wNXI0+5NuMrwKftuuUJ+hMRc6k/e9g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XnOgRR5K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EAA8743A8F;
	Wed, 24 Jun 2026 19:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EEF1F00A3A;
	Wed, 24 Jun 2026 19:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782328587;
	bh=KrEIkLxcPGYN34vBeTlzsqHNKqQFfNJZucq2NDeLFds=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=XnOgRR5KS/l4WG/j1n3WoPLzoAlQNFABguQn7ZtgvJG6R/Lk+Pb5+MmbghczBYMQa
	 8cHtbFvfrX5WYSg1jz9tE2kwrJ2AqvMqVWJPvy+db6JmaB6vvJo07jbY9sDcoXbYNp
	 O7OR24FEQHPSBIGrqlv3crUToit8sFF2NfToUqUMU4TP2PU0zH8yp5vZoTYkY35QcD
	 VCwKoUa+xOI1bGGwIGwqheuD2tb3egqLNaoweVgQf4aUeDHy7Fsff3WGaoNewhDe4O
	 0FlfN6+MWzs8cJRqtO4bYBJJy7pGKqvIOKZgeNCvRev/dSJgJReB7ZXgNZTM19S6aI
	 1Qay1fRI6EA1w==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Onur =?utf-8?Q?=C3=96zkan?= <work@onurozkan.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, Ira
 Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, Paul Moore
 <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, "Rafael J.
 Wysocki" <rafael@kernel.org>, David Airlie <airlied@gmail.com>, Simona
 Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Daniel
 Almeida <daniel.almeida@collabora.com>, Viresh Kumar <vireshk@kernel.org>,
 Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?=
 <kwilczynski@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Igor Korotin
 <igor.korotin@linux.dev>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 driver-core@lists.linux.dev
Subject: Re: [PATCH v17 08/10] rust: aref: update formatting of use statements
In-Reply-To: <20260623175531.85421-1-work@onurozkan.dev>
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
 <20260604-unique-ref-v17-8-7b4c3d2930b9@kernel.org>
 <20260623175531.85421-1-work@onurozkan.dev>
Date: Wed, 24 Jun 2026 21:16:09 +0200
Message-ID: <87fr2biwau.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0EBCBA000A
X-Stat-Signature: ar71u6pnknnbtq9eo4t6imkpepjftoo6
X-HE-Tag: 1782328588-11339
X-HE-Meta: U2FsdGVkX18DVhkHnmpaEyGJaDhSjQLPpJEeFVINpoV9Og8BLO69WSkzrP7OhGO9QOS5PQnCXadDTHiPR6fgf+DB5JTmsG1IGwi6kPsutAlj0HoSApT4NXLtTr1QSHeIv8PDMUdSnZMOVeMrcFVHBc26VWwS8yEkzPqziw4IGcJJ9iqBoy2bwS3PJ0joogyjUJWMPqASWxRM901eNcEj9LPhbckLwNN+MN7YsSFCAPlbBSUsNreBW75rTVzbrNVzq/3OggCAdgDRqRsxoaZIG6XczkzXa21q4RpadMh1E2zfzsEiphNkMESPXw1vngSGaY7fANYYBbb542ae3BPQ4930osNiRF5qZx5N1ZfZKS3d876S3+K0d3VlS4RpZcvbqwdQaVuNNQlfCCPtbeetig0/K9Pmbb//Xuv0GW9E7Uha9BF0nLD4FaqWf/D2A9XFUY312J62gZ5CKpFzXNlL6xeQbbw3ivD5zTpYI1le3+ork3/hWtqX7D3c0LKkc+Ph+uxqkY8ie1e2Sw+pg6aQVk7nLbOEXjc6FPK+Ac4G+cfzaHkTk33/ehGz20zl4ZslqAQ0ZUr1q0hFmtgmoAb+k85hj+J4WjXv2uAm00GkQR81g51JR9DtiMrAMCMbfeFo9w3ZZ/LCb7d7QECFGDrbTm0/IuGPVpyiAlxv7c5oRDBMR31Zna+ijfdnLSWPIb8xm6fnw6MvJ00KrKB4erEfO34F8zLjsFTNvcuwe/1ZLlRsi8tQdI/vUnVgVRa5oPfwcrZN+W7wJQnBbisCdZi4cTcurAvUL+RD4uejVEPnh/Kh/seEiYwRgRt+ALZFqG96VXcPq3to5juLzII5YKjGVPeDaaMF48xsvk6jcB4HRpf9j8pVoHXVU019mX5sKZDa3blMLtFOtpI27V96XxEUr5EqVFa2H62jdt5P3sbRMYpbOQ2yyAk08zhg+5+H9jXqyrVXXPiMbJrE/CqhA4A
 d6xhozgv
 N99fxlIIau51JgXglBuoPyAT+zp4JMX0jne5dNppgPu+B0qvuCS4Nqk9H6RTdkZ2eo49twZXZECt1X6MlTadYj+8PvjHWNx9bkw++Tds+g7X4pQKRjqLsNmH6lUYLc2ewG46MrDDthZh1Rv0uZBQHoThBXbw4skXUvkeZJfzlzvICyfscMsOI7XK7OI3boxTANBtmzcLg6quDYtzwMKjowgKNiQhvC9NbfDTSDjL26Wqo8FE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Onur =C3=96zkan <work@onurozkan.dev> writes:

> On Thu, 04 Jun 2026 22:11:20 +0200
> Andreas Hindborg <a.hindborg@kernel.org> wrote:
>
>> Update formatting if use statements in preparation for next commit.
>
> I guess you meant "formatting use statements"? Also, why not doing this in
> the next commit directly?

Because it is an unrelated change.


Best regards,
Andreas Hindborg




