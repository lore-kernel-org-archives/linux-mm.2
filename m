Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8A23E63F10
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 20:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965C36B00A0; Sun, 15 Feb 2026 15:03:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8DE6B00A1; Sun, 15 Feb 2026 15:03:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F42B6B00A2; Sun, 15 Feb 2026 15:03:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54CA46B00A0
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 15:03:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC534B7687
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 20:03:57 +0000 (UTC)
X-FDA: 84447766914.27.758F266
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D065514000B
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 20:03:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K8q0AdeP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771185836; a=rsa-sha256;
	cv=none;
	b=cGEwYeRRq/oWOalZfxZVc9O2QF+f6FbE7iN7A/scEG75Hr1XtO/RO4vZg8cjja/rw5eaht
	MlgzP0+w+gsR9GtOVfmfbrhkToaJzLj4Z/UxZJMp+ZisLxZ0jEA0Wu7Z8PDDa5iuMZdbz6
	sHxIfT7kyxKWjZEBfw/NsTwEkVy/z30=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K8q0AdeP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771185836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Wntg+o0ss5yE/MMQ9CftCE7vczYITvbfzWjqov/c+Rs=;
	b=XZHfTasU98S+gS0Kw8un2WQ30Sd6rg/4PIiXlAPaj9fYqk01O0+eUDVoKVbqXkwDw4EIch
	b7+e/TU7sU8fMHLJWf6NRqJlrI0/IEoFDY07TQlozafC0EjWhlptJPie1e+OrbFxUAWHqm
	CktKvZqrm6hxAzMLs+uhYGp5503TluU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 98C5143AD3;
	Sun, 15 Feb 2026 20:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F31C4CEF7;
	Sun, 15 Feb 2026 20:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771185834;
	bh=J3t/Dz+oED8t1uuEA1ZoRdXNWCBzjMMsc5X22A9qboM=;
	h=From:Subject:Date:To:Cc:From;
	b=K8q0AdePSZ0ZRnGYvwcPfgWhv+ETE7dpGUfjPae4FXj80cACogswmr7LupGSodPzy
	 ACD5rSvn/6ySs3D9Yh/qTNxDlB9qO84Gtcr0yFzE1IZcOB7YPuLSSjqfzahBrw4D34
	 xZszQCrAbRe7ntVA/SWunlPMSfzeYu/i9yWca5f88tYX6EXzZTAbns30pBz4XYAqXn
	 1xbo3QioOIB3WvxjfdFkV5iXLcA1KhXTqEu7RUnQqXR0P81CBkkscxIJhM+W6//u7M
	 v/B3/rlJaS9W2QFzg2gv0tBj3GnF/fDBe0FiGtjJnbvATJxwsMQ7+hTKoHZDwOeqRe
	 6xjNqRnnujBuA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH 0/2] rust: pages that cannot be racy
Date: Sun, 15 Feb 2026 21:03:29 +0100
Message-Id: <20260215-page-additions-v1-0-4827790a9bc4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJImkmkC/02NOw7DIBBEr4K2DhFgQwRXiVxgWBIK/8C2Ilm+e
 1Zxk/KNZt4cULFkrODYAQX3XPM0Esgbg/D24wt5jsSghDJCSc1nT5mPMa/UrLwPjRGtQZtSBBr
 NBVP+/ITP7uKCy0be9Qqh9xV5mIYhr47t5i4t/J85RldaNELzbczLhpyMXNkUonnoZNG6XbbQn
 ecXe18HBbwAAAA=
X-Change-ID: 20260215-page-additions-bc36046e9ffd
To: Alice Ryhl <aliceryhl@google.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1592; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=J3t/Dz+oED8t1uuEA1ZoRdXNWCBzjMMsc5X22A9qboM=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpkiaTu168SUSLg+pWYFC54waDl4cp54u+mshlC
 QrjDdTP9FSJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZImkwAKCRDhuBo+eShj
 d+C3EACQBF0qgfiP2oREwlY7BugQ7tZqaslNUSoWwp1CyCFvXAV7pbejUVgl7PvL+C8uQ+sxtex
 e8c9MQICKH47xTIE62zY5dRMgJeFTG2IdQQdhBVXOws9Hy3IbxejC6ePBt9oG+cwydMUiki5Xj9
 SQl43WYdW0Nu9t/Rv5TFHT+0wnyTYUZiNWfs0F78NBsT7jNw52d24hpRWYpHPQ82HV0tFhBrU8l
 iGuaKjt/IKuJvhmJYLX6GyoK+G80bYf14yf9JWrDERegsnoi5zek8GFVEvMQeK/MZFBJUh99quv
 jlYKhB3eInjRcV0sJTzN8Wc61DCEFcbZEKKD+6972bU3hXJh6sb1gKluzRPCcTRqQeDobDgOJMq
 b0txZu+XYTHiz6s3rwKs6QXqOko8hJN5T2wt43s7vW79BIzjzf++BFdvAV+8yw0m4WzRiNGfs4D
 S6n70kdXAFsP6EzKzaezy6xftO1krGLlVtyIjAI8Q2HyrUV7KvRNjPm24sCwB4iiMDjA2h94eJ6
 osk5lzMkrnPOSfdBkXkKCJut9aOEi++sIk4HEgxizHtNJ5os8KPmFn7rfObMhDsDtn6cnDBkkAs
 cg7Mp98pH7Q2uNa5FogaYZS0lqvwSMZ9JGajDcntv0oAcq6VKfD74+WzB4/jnQjEOjV9hSK0xOa
 rjcry05bh2GQGzg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D065514000B
X-Stat-Signature: jxdhsxgkyhq3detsoccei9cmzusi8wsc
X-HE-Tag: 1771185835-944144
X-HE-Meta: U2FsdGVkX18ZTWJ6Uo84Zcw3HX2XPTtdDrMzquIOJpyIHaHEPLZzkkZjq076TLgyoP88Gg30AmLjdstyOZABSEtT/kmckUNfGHcq+5HUiNJvGuTal4A7iri4E/WIYMxzpHoAKwPHAFdFwf9SRm+bLTn45ZuN2hsx8Dp/QRM8/yT4MoodGyu+PojuyU7XDMVIB+HSYg1RFgo76rAhfqs40IFosYZtIRclTEAAF4z1G3AKNd/MaVJUQELyZeASAuUAyILIcjI6IC72s9FWsbrtv2teNeOefblFT2So474GtUneoXvUU4uUmOQu+Tdb77j+m53rmKqCpY44BHHKu/rmfWF1+/6WX3N1gglNl8VjWFEDwgdiJjFlzEW/xsxy8d1Udx58Omp/IfEhenvPPv/9Brbs2kHb5Q5rpieg5HcjOhkFkwMTHZgfHhH6gboGyErztS++eB621UgU4uVb8AiYAiyIOL2ks9kiz4AR/6Txr1Gc1TPJvVcHABnKYeTUR8FtVBc7vAYETu2SX3mDcMofSosd3TPRk5yZ/JtHxI7rARJgTx4Ja9VCR0p1OmvW/FjxQ9nEUvtk7mz/wEeYcyvR4ewyQJKv1Xf15SQpRjFgdTftHUeobNui6K1Dub4Ct2jKmTDUlUlrg0FU1A/USucw3gWCd4ZmB2aKS6Jv4ayH7p8uxHUXb2igP69NR7c15gjaRBKSA39wE0a9vtZxgz4SyTe69U9jfU2eRr3CZ9J8oW9HwarDGeoYONXi+VQB6mpVjk9A9GGD3LL84RTvppg2Mm82NA2JmK1zpaUIjMtkhmqdZBSPXIHPV72XOCwqaSg9b8B+gymFWqA+m8ELiYEJ3DtKBHCOQSkp1/8c5i+atpAw9St6LSVZKyWFzCvxR8wfV8bT+oZJlsy3w02RrIOaK3O+XIm7GnFD8kl1sUnlyYLqO/XEm79MVe/nCrmNRRIclB9mnwcu1rMHpwtZAVN
 9HohkYvh
 vLtNoAJdCTudJbNcDlQ8T0qjPUMrno4T5FS9huuIxMa3s6Vr7xx6zNhSpqwwz0mRDxs7YoxDkKXckLgf2oyDX+cnUdVq/ZEs+5uigIVj/6Bdn3I6aoS8rEZPIHN4yd5TIrhFXErdAjFEvDmxpXqW4G0Zykj7D02O8hJA1TTCWSuFIDWdrL8BFxCEVq3HkOzbFDloIrPg+PxIpyYgkKY4Sjq5SqMeOsXIZ1649StVDSqUZltJc0pD/1LtHtR27K+eBZp8ycqQtqN8Y6Bb6zZZLMiHS1w3hMdF5HUrlj9dssP4yxJnmwjkr2SVTsbtj9P5aDAnd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some drivers might want to use pages for data storage in the same way
one would use an array of u8. The current page cannot be used for this
purpose, as it provides no guarantees for how it is accessed.

This series adds a newtype around `Page` with an additional invariant
that the data of the page does not incur races. This makes it possible
to treat the page as a regular array and even obtain a slice into the
page.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
Andreas Hindborg (2):
      rust: page: add `SafePage` for race-free page access
      rust: page: add method to copy data between safe pages

 rust/kernel/page.rs | 102 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 95 insertions(+), 7 deletions(-)
---
base-commit: e9ec05addd1a067fc7cb218f20ecdc1b1b0898c0
change-id: 20260215-page-additions-bc36046e9ffd
prerequisite-change-id: 20250305-unique-ref-29fcd675f9e9:v14
prerequisite-patch-id: cd414158ad8a77616cf5e20f01212929fe4a9b4d
prerequisite-patch-id: ff052142fd3b16d7190b0ad2fb79cc39813e49fd
prerequisite-patch-id: 4da98d17bef5f809a9caad013bab670f661c8d4e
prerequisite-patch-id: a31185fe1abbf553377d6d695c5d206eebc84358
prerequisite-patch-id: 8074279c3569e7997f7a993a8ecac7b977b4509a
prerequisite-patch-id: 541dba7938ba874f8d17fee05a36b1cd9fa2c4d7
prerequisite-patch-id: b7eb6740359975d4d781fbd4f684bc5a8ec277f1
prerequisite-patch-id: d83fb5f310b84492bdf44eeec0f9d3d3146a73f5
prerequisite-patch-id: 77308c47591e44920a3bc0279a4d9013035fcac3

Best regards,
-- 
Andreas Hindborg <a.hindborg@kernel.org>



