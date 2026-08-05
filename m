Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15FEEC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 18:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9E916B007B; Wed,  5 Aug 2026 14:29:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4F796B0088; Wed,  5 Aug 2026 14:29:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66036B008A; Wed,  5 Aug 2026 14:29:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EED06B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:29:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 12A241C1060
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 18:29:41 +0000 (UTC)
X-FDA: 85068054162.01.3430035
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5A5FC80014
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 18:29:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oKIksMlR;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785954579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ubge1xIhaMVtNlK1W4+X5SNrqz3ntDqZDTmYPkn/nf0=;
	b=dH8ENciXSKmJz65W6eOpG78mVy1gkCLtG8WgfuCvjehGFJL0801/5w0U0c4P4UvFJ2XyWM
	tgOwhFvS2oD1P7LIYEHOZXfP6qE8bkVFLB/YAbtDTtBs6H4fFhTtRJwvkX3Yfhv3axvT7T
	E+GbT9zyeY5qff/UwVdPhJtmWv7x6Q0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oKIksMlR;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785954579;
	b=liwDgjztdc3S2iTbwjaK5anFczeSzvn4TFSDZUHcJ1oalZBUfcyf4E2zVLjm27KOYkssnn
	tFmi2LvlxxSZlCUL6eHuBZXt1RdmTqLEJtNmF/cFpA6ikRT9aoHolFxwGOryX4+FrVKfLf
	NSJTUOtHsVR5U2KtK5FY7ScLn1XOpMc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B8B941190;
	Wed,  5 Aug 2026 18:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD051F000E9;
	Wed,  5 Aug 2026 18:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785954578;
	bh=Ubge1xIhaMVtNlK1W4+X5SNrqz3ntDqZDTmYPkn/nf0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=oKIksMlRhAGkTOqGfbYfo2uxbddIDPJ6yRuC1+qz0HD367Nw3b5uYOY7dJs6so52h
	 lPBCXxoBowrthLhtQuXnRCtfrCBvaNpishqA1ly4MRtnADuozm09vt/3ADBMG9VT1p
	 sHCeYqeSdkUWyfKQYQmHKenSMrN7+VuS0ZRKwMl8uXLFyKsxYTnc5tw/MCBeLUmmLI
	 ggBxcCdCTCPM7IIkH1PxMMHu9hGrczfwaqeUHJHXEbvL8qOtOBtF2pJmv5nEOHNnOL
	 mF6nK8TqTY51otnDD0UUyZIImdB35MGEF+GZ7VXF4qwBwGi4jMOtjwSIlPD0dmk2Gk
	 7iT75Pb8pB9+Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Trevor Chan <trev@trevrosa.dev>, gregkh@linuxfoundation.org,
 rafael@kernel.org, dakr@kernel.org, ojeda@kernel.org, paul@paul-moore.com,
 aliceryhl@google.com, airlied@gmail.com, simona@ffwll.ch,
 viro@zeniv.linux.org.uk, brauner@kernel.org, igor.korotin@linux.dev,
 vireshk@kernel.org, nm@ti.com, sboyd@kernel.org, m.wilczynski@samsung.com,
 boqun@kernel.org, gary@garyguo.net, axboe@kernel.dk,
 daniel.almeida@collabora.com, shankari.ak0208@gmail.com, lyude@redhat.com,
 j@jananu.net, lossin@kernel.org, acourbot@nvidia.com,
 markus.probst@posteo.de, driver-core@lists.linux.dev,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-pwm@vger.kernel.org
Cc: david.m.ertman@intel.com, iweiny@kernel.org, leon@kernel.org,
 bjorn3_gh@protonmail.com, tmgross@umich.edu, tamird@kernel.org,
 work@onurozkan.dev, sergeh@kernel.org, matthew.brost@intel.com,
 thomas.hellstrom@linux.intel.com, jack@suse.cz, ljs@kernel.org,
 liam@infradead.org, bhelgaas@google.com, kwilczynski@kernel.org,
 ptikhomirov@virtuozzo.com
Subject: Re: [PATCH v7] rust: aref: make `AlwaysRefCounted::inc_ref` an
 associated function
In-Reply-To: <20260628100731.64885-1-trev@trevrosa.dev>
References: <UWdIvfYijKEB-nyPuUo4FRBSzoE63d32sYuIQ9Cn-wWmceZpbNq-V2rcl_vTofMvOWAuXSPSc6YnxpYgwiMmjw==@protonmail.internalid>
 <20260628100731.64885-1-trev@trevrosa.dev>
Date: Wed, 05 Aug 2026 20:29:21 +0200
Message-ID: <87se4s775q.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5A5FC80014
X-Stat-Signature: 4j4c3be8gkc6acgao1tnb6ytcxhau196
X-HE-Tag: 1785954579-491670
X-HE-Meta: U2FsdGVkX18HS2nQrCZQwoOvy1CMhVqZD6CaZ5Z/9TJh9uAqcjOBnEmsODM3PRqDGlf1s7MVWh2BJHdk6fQrRByexHvIhFyKqL94f5pkFg3dUMmaxrZu7pXS5r6+spWgtqEeXFRtUQidvkVbs6WCBWWAcrCC7XGYyiIVZfvcaLpPHOpA7hpgDgplcPMykapvKIVCYzuWZBHeALA5WjhXa84jcwmUV/e0eA0R5MDrVpCjxm6qKUkrzoeMraqBuByrPSQ1ndckxiQQJr9zmDqGVRE9/4G5IiPifHdkGxMyzycqD7mEcClJ4a8kN6e2xWS0MA2eUTsu4FUQ+gqOvBeycAyOnIdVX4delto+hK71rI3EgV3m2/LdaH8W+7kcdk+peK9T01e/tYC+Julb3NwhFwtCYH/uMTXxgnkb8Gu4/FuFg7OiJKskcUEtyau74Hu9RBe4Y8Xz+6CKcRjV+yF/v6Xyi1QOoHhF4iRfQjvv+a9OTgEaJv8rHFecievkUqRraTbmDURFi2rz6mast94LT8UPCgrjSRncO7HMd+txrcF9J1MH23fPvpGUjwLHkmBDoHbXW+cp3eMqRqWnYgXJ6d2TdWI9ocIoLj+kp+5VQC+SnSl9y9SEvHtXonHp5CJLd6SpiefhPQQrIdI077Kkp/O4E4mGWqnscEdfvX4K7b2eX9k5JfJN1fu09lRZAwlx5cFNcptKzUgwgt0FQ6ZAmFM3qoiE6RsB13taE0TKipXmRXsZdOCZsMwiR6yeP6nsI9tB0OppIhGmp31C73740Orn6r934t5XA1XQdHj5LdwMO9GxscXAXH3KCxSCHBLLBOTPJh03m5K+G0pNRNHfCXHJTBp5LFREsnORIpSZYXcbapNUjZl75MwzqEuMMHH5jhwSJP9ISyhnrct1AWDPopuMRvq6HZyN16rIN0TxtMm2Ul1aZ4ihNXZ9m+YS2kKIDtzl1vGXW3b7nABwtrC
 V4HeOtaT
 zp/N11eopFWIZMbjD+tyEb2UwHccc1Cg3yx+cIzCcbt1+KqOtVGBDZsFqW6P4uRaJNbskNY9Cf+i0g6JiIJ25VC37WTKLbBDLfaa8FbZ7FaTP5vKSqYx6DJPvIrjS8TCY3WqOn6hOnrBxmquftvyoRfXd063Zxso/12d0swWoXWi+QoGo87L637y9w/X+KiMjVOqKOS5b24Me06aHl4KOeV+GZe7YHVeCh9QgyhnFcqaysW226fi0x4c7wliGLLGOgSuC71B5jep/zSiWgVCjK/r1jOm7c3w+eEH2WoLh7OrQNtjz1jhjY0VPjSBYQTk12+cJo/fCJXetyydGvls0zZV4dZjK8qPCqEHqvqA5upPhzUAnHKkVEJ2gWNJV9n8fl38iQG2peenyOSqMF/4oHk7GJKVgjJJzgjXsM9ZjjypkxnvdgW9qcj9tkAScEBPS0/VIRAN16QKyS5DNf9NNnF/uNMmalHUSCbt4Cr5epxXh7xglTmaIKZStILOsiwWXnpJbNXd2b75L9XyCmaCI22CxgRQ1rpkRLZ2q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Trevor Chan" <trev@trevrosa.dev> writes:

> `AlwaysRefCounted::inc_ref` is a function that shouldn't be called lightly.
>
> To prevent accidentally calling it, change `inc_ref` to be an associated function.
>
> Modify all `AlwaysRefCounted` implementors to work with this change.
>
> Suggested-by: Benno Lossin <lossin@kernel.org>
> Link: https://github.com/Rust-for-Linux/linux/issues/1177
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Trevor Chan <trev@trevrosa.dev>

Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>

Best regards,
Andreas Hindborg



