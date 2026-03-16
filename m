Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5FF2F4644A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 282EB6B0190; Mon, 16 Mar 2026 06:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2437F6B0192; Mon, 16 Mar 2026 06:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 170856B0193; Mon, 16 Mar 2026 06:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 008CC6B0190
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:46:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0926878C7
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:46:35 +0000 (UTC)
X-FDA: 84551597550.09.20836A0
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id F278D8000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:46:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vatpLY5J;
	spf=pass (imf02.hostedemail.com: domain of 3iN-3aQkKCHsZkhbdqxgkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3iN-3aQkKCHsZkhbdqxgkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773657994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LZg1f0pUQ21eLP/CjPzvaDoUL0JnStFtL27P6lG08E=;
	b=N5uh9lRxpV61qm55zPcQK3hWna6mdtcotswPC4oDf1XMKDwjalbZoWgO4ZIwj7TRP3ZhRX
	rTyRqdhuLaRSk1a0JvLDC/W/q+KSnmbOkHAn1YRz2VaOqjJlPsgZA+3fq4JACGXY7EEWlf
	aEzthpDoNTfJgvqCmTgBZw+z72w0h+g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773657994; a=rsa-sha256;
	cv=none;
	b=CWH0RXqQFgocI1F5BGwbTj0x6DYoScGQr7ZxXFEduntqRs2yy8Z2Df9zqZ+jVR6PN0cVPW
	kX2OwqBD4qiL29nd77VQt3c7crieN+JrTC1hHYmeyKs3yxa2epjU5N8ikmxMbpLj64z4kF
	HLnSd08y1HFx9EgHQ9iZrA4xYU+A27E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vatpLY5J;
	spf=pass (imf02.hostedemail.com: domain of 3iN-3aQkKCHsZkhbdqxgkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3iN-3aQkKCHsZkhbdqxgkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4853b5b0fafso55391215e9.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773657992; x=1774262792; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8LZg1f0pUQ21eLP/CjPzvaDoUL0JnStFtL27P6lG08E=;
        b=vatpLY5JgsEG6/JmUs951CLIBzKn6CqeI8Ix864IgL7OrD5cVSIB5qvDiyznasNQ+g
         8rlPk0z4mDtGpH2iNzCmymik9n3r4dgVOqUVaCYQkbcDhGNbez4xCf+lwLtMhb0B2ykN
         6MDR0tffuuI/pViWPOPNmijc88UapKbBeJkEkRsqUIl6m6NlGTFu2IRnsjwrKB2tPGp5
         pTQyKVV72m6ZVj/pm/tAy3o31u84OoSVZe0qVR+n3+LVUSyeTrMLNmVpdafV1Lf2Qeld
         IZUk+MJf4Zt3TH/odsn1ulv2/c99ztQP/VIE6clUdaRL1XZMxs5mfEz6E7sHiTTTRoT8
         evZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773657992; x=1774262792;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8LZg1f0pUQ21eLP/CjPzvaDoUL0JnStFtL27P6lG08E=;
        b=J+q1SayqO7qYDQsPhegqoerZAk6w4WvsZCpwK6vue61+PMjLb0HumvbkUs1RGndakI
         llVqB9eH8i+CWDtcWtxvel9Pv+resaep4zCMCJqla9HPIP43B8iO16it0XOg2ef2jXNF
         2FDzS3+FnAdC1Hf0NNkIrrEETpst0vfJEXlIcEMoe8Muoil2wxqIrfcauRBa1A4Zstz0
         qHIhNLa9VhKHPFvjMP8Dksrp8viwWE7HKLd83zZxsSYxn0WHjuNoBgUW/+IEpk2ZMuZE
         xVUA2/RY9iYI60oqU5tcUUZyNtU7cBpmuhv5b+bgs6RUuD3LIc8DWrggMOQeaB4VOIE7
         gPaw==
X-Forwarded-Encrypted: i=1; AJvYcCVHzSWv/JlcMVZDJ8/yyn/Jr7OcMNPV/JOY/Pa0jwMHcC2/FZIiCvshbaOCXcU0TiiJQqU5URiXSg==@kvack.org
X-Gm-Message-State: AOJu0YzvgW8JZ64n8nMyCRrpwwD/s3IDPNuJEoI+vdcG1ogkEBePgi0G
	bCl3Z4bGoxP+OmoJWRyFNMipa0YXLMjbgp21fGCeMfLtQvqQalEwZtnh+bd6fPpe1zlDacNlnAk
	JI5WacbCN4VK5GQ9dNA==
X-Received: from wmga11.prod.google.com ([2002:a05:600c:2d4b:b0:483:7fc9:95e5])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c4ac:b0:485:33ad:3c9f with SMTP id 5b1f17b1804b1-4855670c164mr205445595e9.25.1773657992295;
 Mon, 16 Mar 2026 03:46:32 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:46:31 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-16-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-16-de9a7af4b469@kernel.org>
Message-ID: <abffh79AODRjhcqM@google.com>
Subject: Re: [PATCH 16/79] block: rust: allow specifying home node when
 constructing `TagSet`
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Lyude Paul <lyude@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz <jstultz@google.com>, 
	Stephen Boyd <sboyd@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-block@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F278D8000E
X-Stat-Signature: 5shnipj95uedyremdhoqtjfdyunhgt45
X-Rspam-User: 
X-HE-Tag: 1773657993-823111
X-HE-Meta: U2FsdGVkX1+PJfEpIQO0nWCc8ar9+4pTCS672/25S9Po3ToCBhv/LL7K+gzlO7KAQiQIKFpQcGjCYs18HJlnplu5ZGZHX68WHHwa38s0pdCW1YhFtEWD7bH95YMFeaiwJjT2qA+agvhy9AtLrtwO/uAGEGfjP0rZm0MqehD31UjoIzykpptDGWN6h0euysDXgSGdN9N4IZewVjKcjIRuLOMOu4w7P3kyQezolEgXoKx+tCgRv/WWxD7O9XnRi7BLQmIzxeVZxlRPHAbscEN/2g1KB/xH7Q4KarESpIQ+oL3yzwCsJLBuJ1vk5wAoQEAVm3g7wJE2OdF1iovk6SfYWSOp4WKYkO0nYmgETPPZM46wySsB2dujR5tuJOTNHI2Xle8krObV5RjhCOivldfIKKtc4qKxDl8zjto5AvJyr0Wsj4BL68he3X8zvoP8/t4WekJZo/rH/jFV9TNU8Fbo02rZG9pDphrVgDp02Har/7zKYmbvEQeQa0gAKs4fu2SbT7T/DWfwP3HJrwj3pxdBYEm9ZC1CvmYi/UrPa97tQQbIZ3X8Fo02ym9GctD7PDkQ33AnG6gnE2x8V5Ju86FFERgzuqi7uMY3MgU1Qns57Xb/+mWzH5nFa2Uo+8pWo7VOrJgcebyxTS1omIdwxJxT+q/FPwGaV9oEnEWYBybeYN9tgvq3e0Rg1Ll/l5uGzRXyWB5+aXXceU9+6zMj7p4wTNfpZQzMhsdxK8w+ENeThYGoG4C6u7xzgNwSKXOT7h/mWQu1IG2rS7BvWBOrUfImrTSQGsrggbf9U5Slh6/6OJ6fRE/+TVEMgHqpV1Ye3N9jvNinC4z0jGmnNpVW19w/SCXM7S9AVCd81sSICCZjcW7kx3YJRMIjDEEEG4w8CdiG6Hbaosix/qKUgAVbRx0PW+a7xxcM+WWDGiRiPDLEcughw4g63cEaxmJIrEXQ3g8Dp4KOcewtPP/h0QKa/13
 hWl2/wj/
 Pjg8+yZ2c/99/JH92xUwIXHYm18yloVRCTsjvp8NUnhInoJ2sv8Y9PMfPvkeESc16Ihrut/72Z1ek3ks+1MryEnb5A7WlK290y9i0LKETmnPNEBDZVc/NwVoT6xZ/2QTEPO7SmgKJUi3VsyNuS0BcFMZH+QUcXZ1oNstL1f1DrkGNVivShPiNuj7U9Own3/Kk/sDxqwwEnqjLIPiOafG/3RN4swl2LFM+lW2q52EgqKCdf+ik2kUSX4IR+bP+plfsGyAH2d4F22nXIKkLNhW/wVMsANKKDQ+qigAm/Cg8EXNwI/UGF/Djlown2SQSB3vBi1nkpU+a+N90HuNyA8ABsr++QrUO3ZF4zC1wmVrUooa7lEDw/7KDBiT+Tb70nNGsyQ2I8ZeytOgxDfMWxFTN/D/PpMfCDQ5WwvSPg0Rmwwla8PzfvSj+WQrJF1PYudxuyCxj/cI2HTNa3D15BeOUnYl8iz8WhPbwVQfQQStwnsxaIaY3MRghIRlCyy3AE6Yf0JbOEHHFwfycxkl7uakHdC/pg+e1VcmByonoapL4/dmjdOYONN15jQAjeR05yoWy3xplgVb2ZQzZc/N4u3foiMPWfmNslmXpNjvh4No2brEJQwnxSPJOwEVyC4M2Fv8w9RKdGhduzgBQ7N3pL6oR1zdpQffj4RkicDUDyym8RuuZ9LwxACgveRgmonZFDhes6tck3JTFcixBFZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:35:03AM +0100, Andreas Hindborg wrote:
> Add a `numa_node` parameter to `TagSet::new` to specify the home NUMA
> node for tag set allocations. This allows drivers to optimize memory
> placement for NUMA systems.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

We already have a NumaNode type, which you should probably use instead
of raw integers.

Otherwise this looks ok.

Alice

