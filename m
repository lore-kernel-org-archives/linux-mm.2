Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA2FCF8E4B7
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 07:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DFA06B00A6; Fri, 17 Apr 2026 03:44:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 269556B00A7; Fri, 17 Apr 2026 03:44:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 131BC6B00A8; Fri, 17 Apr 2026 03:44:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EEF1E6B00A6
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:43:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31BF2140B42
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 07:43:59 +0000 (UTC)
X-FDA: 84667258998.08.111E658
Received: from mail-106111.protonmail.ch (mail-106111.protonmail.ch [79.135.106.111])
	by imf20.hostedemail.com (Postfix) with ESMTP id EEED81C000A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 07:43:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=protonmail header.b=mJFkuCEP;
	spf=pass (imf20.hostedemail.com: domain of work@onurozkan.dev designates 79.135.106.111 as permitted sender) smtp.mailfrom=work@onurozkan.dev;
	dmarc=pass (policy=quarantine) header.from=onurozkan.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776411837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZa+Mnzu/JpBzgLh0lzaJukLWyuYJOgfdAVRo87Yl94=;
	b=4KV9Sjx5PZKqv6Dw4au1xtvHVqb4FjCyGw19u8O0QNNAOWKs+7I1WJqb4DkhcSHt507XUE
	pL1VIrYyjhyxW190cpR7xBGCMMYgCVTaDbV2oNgtQPT1kko71zb5vB0k0x2Lr/781v1khL
	D6T4RcyjTRLM9kKWkQSsXet0c9p9gr8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776411837; a=rsa-sha256;
	cv=none;
	b=t5qTUPHgpR8r5E6CWopdO4CJEKoC4ext0STwcQ3UAoEgQxiTjUvVqLE65D+U+p+U6YOCDy
	31vIouGIZalfIQQvTlepeb5gowgynuXDRaJxmnhcFDip9N19RB+9yhEa3ZeUVYaM2Pq70R
	UNvtLeZsHpPEDa1tIFv2wH9G9g4p/2c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=protonmail header.b=mJFkuCEP;
	spf=pass (imf20.hostedemail.com: domain of work@onurozkan.dev designates 79.135.106.111 as permitted sender) smtp.mailfrom=work@onurozkan.dev;
	dmarc=pass (policy=quarantine) header.from=onurozkan.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=onurozkan.dev;
	s=protonmail; t=1776411833; x=1776671033;
	bh=QZa+Mnzu/JpBzgLh0lzaJukLWyuYJOgfdAVRo87Yl94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=mJFkuCEPAC8Ljzgn/nT+d29HTVK+iOCHk87qesBbqf8A54lvToD6ZdWLs8tlm9nZl
	 ldnoyY1SmGpQIhjv8/abSy0Z86p2bg+Iz09o1wHSd7LTdooHdtOgfs3TbOKb4L28Wd
	 tvwIPWHUrUQHedszmETSAM3VbVJaEDEUeCKzvEDyxZBGS36gKV0pTvfn8HvPiSOzjP
	 4aiXQF1OHKWGudGlza5Yxp2s9iOXPj4LR+1obUp34WbgCLf/ZP2g+cZYqlBV7jdmXj
	 SaD1WthRsj88UJsdwTvMWM/zFiDSVwPX47V4NyLkkIQCy1UrBOQIK4lpu5lqQY1ECl
	 qNB+RkRwINE9g==
X-Pm-Submission-Id: 4fxn1z2NJQz2Scpl
From: =?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
To: Alvin Sun <alvin.sun@linux.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Tamir Duberstein <tamird@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/4] rust: Add helper functions and constants for Tyr driver
Date: Fri, 17 Apr 2026 10:43:47 +0300
Message-ID: <20260417074348.98280-1-work@onurozkan.dev>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pqxztpk36suyr8gqekkneyxux8o5z9cw
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EEED81C000A
X-Rspam-User: 
X-HE-Tag: 1776411836-342060
X-HE-Meta: U2FsdGVkX1+ae92XAwPjtWb0I+FNpQv5xbcHVzgDUWcvr1aamt07QFKEmAzJ8NzhYgMm0U2pa45n77f93R2Pf+qtRixIeh3l8u+KVwVxejcH0+jb+f87JPtPN5A7PSoaLrHZyLLang9iJQn2NNH14Bp2k43CZdhXh/V6Vrru1Omm6k/0xuaqRyfdFtvvSk0mdhVc+2QAeN8ss/2rOYJbjNJu+cyGspCeBLGPIgMBlIJasAyqvjCJHyzEy5Pmri9XOZdyXCVZDVJgrhGjYvAw09bUZcB4eg6VTLnt2tzqgmMY1q8mbd4eMr6b1ej01KNQUKBo2hUnrtvIZlZ0eb5/7uvFIqwj2GclJTbJZYEazsLl0NpSO6zUAiRhacZ4UJSWqZtnA0aHtYaHxy3A16+usZLsMSvnvVqgLR3I50g7LpkOwrofErfyS3WTR1Qwte8Ru9+2a2rcYbSyK1I6MVMoQdVGli8J3bheaykzY0TYKrcSLfCqwgBQLmDs7HUFDHLz3TeBptAwA6n7pGmJ9pxppay4V6lcvVth0zyrzCUssnHS6TYX1tz/ntGX0XoScPo9H7cQl0sgoxKBuDa/HRfUgk9VygKmRI18sPec4k9e98eiXvNvtmzrrYH71glUsZqCBvgQlhl3USWW0i+hF/jZulDPdOXYkkcv72PHF1n/MiutYJThI0tuWQXD1vyxxY2Cu7JgiQLsfeE9OkLSslK/cUpBO1Y+4Xb2CEmRvg/0/cMAOJmhY/2Y1pIFAq+5v7IDA5c3MYaFdMoMTHYkLehQYyCRXiscryyGZ0Kr/nmmSEHXlTCP0iLFPbV/IwXp/+otQ9S/PCipy7ADS4wv3eJfeFAUDsmdJWZ+8fKThgQCLi903Xjvt9ECRlbAg9eplS5ovrNMrFWI2m3eJJ8p+gWb0JmEzri0O3KJNuq2eGSAntTRCT1WTPf60srT5mLRHxbb53xrGq0L98O1yxhWdZM
 RtcDw4/h
 pjj8TZRl+FYs4WJ6IxaW15YGrx1IwIwMBwjiZHmw2zZtrBvFr828o39VzEB+CC7NWdd7yd9t8LuJK5YNBUaLgiiTehA9Ol2dji6ACqcHdGXicTzfvIJD3NlFUaiVQ6Y8HTLqTgdFS6SlEEesV/HJ6WfLeKChhXL87WgLyAx6C49rbLx3zAbvxn7NAmnnfe6KDGf1tiAaPFYU7Fp7maQwHuJRrIgGZqmOdXEziAHJ5XkZcwGyGMZRMsIUd7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Apr 2026 09:05:50 +0800=0D
Alvin Sun <alvin.sun@linux.dev> wrote:=0D
=0D
> This patchset provides helper functions and constants that will be used=0D
> by the Tyr driver's VM and BO related ioctl implementations.=0D
> =0D
> These patches add:=0D
> - SZ_4G constant for VA layout calculations=0D
> - A task_size() method to Mm for determining process VA space size=0D
> - Updated StoreError comments for alloc() usage=0D
> - Guard::find() helper for finding the first present entry in XArray=0D
> =0D
> This patchset depends on Onur's xa_alloc implementation [1].=0D
> =0D
> The complete patchset, including the Tyr driver ioctl implementations=0D
> can be found at [2].=0D
> =0D
> Link: https://lore.kernel.org/rust-for-linux/20251006163024.18473-1-work@=
onurozkan.dev/ [1]=0D
> Link: https://gitlab.freedesktop.org/panfrost/linux/-/merge_requests/64 [=
2]=0D
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>=0D
> ---=0D
=0D
FYI, there is v2 exist and I will probably need to send v3 to address some =
of=0D
the review notes. It's good that we have a use case for the series, I will =
share=0D
(probably during the next week) the v3 before sending it to make sure it wo=
rks=0D
for you.=0D
=0D
Thanks,=0D
Onur=0D
=0D
> Alvin Sun (4):=0D
>       rust: sizes: add SZ_4G constant=0D
>       rust: mm: Add task_size() method to Mm=0D
>       rust: xarray: Update StoreError comments for alloc()=0D
>       rust: xarray: Add Guard::find() helper=0D
> =0D
>  rust/kernel/mm.rs     |  7 +++++++=0D
>  rust/kernel/sizes.rs  |  2 ++=0D
>  rust/kernel/xarray.rs | 28 +++++++++++++++++++++++++---=0D
>  3 files changed, 34 insertions(+), 3 deletions(-)=0D
> ---=0D
> base-commit: d1d81e9d1a4dd846aee9ae77ff9ecc2800d72148=0D
> change-id: 20260416-tyr-ioctls-deps-25805eedf332=0D
> prerequisite-message-id: <20251006163024.18473-1-work@onurozkan.dev>=0D
> prerequisite-patch-id: c472a9548969ac774d36fead73378961a0d0489c=0D
> prerequisite-patch-id: 63890b91e911cf96cb42308c056d639580ac0fa0=0D
> prerequisite-patch-id: 337eb93db35359c611abe9cba299e6ab0525a2b5=0D
> =0D
> Best regards,=0D
> -- =0D
> Alvin Sun <alvin.sun@linux.dev>=0D
> =0D

