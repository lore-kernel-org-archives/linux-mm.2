Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79599CD6E56
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E07B56B0092; Wed,  3 Jun 2026 08:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDECB6B0095; Wed,  3 Jun 2026 08:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1C756B0096; Wed,  3 Jun 2026 08:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C53206B0092
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:09:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8655B8D16B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:09:39 +0000 (UTC)
X-FDA: 84838482078.21.650BB46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id DCA5820002
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:09:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hudv1vT9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780488577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TnuFx4Ou3kejucSUC1CjBWPb8/IIbrdEZSaYmxrJMXo=;
	b=4XX2clh7ekp5spLpCht7oXfs5f+cp3L///up36/e4ehQhfSb26ISOVGQylkmQWqRqPHWT6
	jZbuz4DuCiyyimJpKmAGOntZaxVLVLEOhq/9So379Wy2lxDpwGJynCctiV9j1LtREtkqIb
	Nqo4MPi8l9XJRF0H2IQ5o2Nf0hUDTzY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hudv1vT9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780488577;
	b=SRo/mVAMBLivkOdO3NJMC+Lm0MKUx3l2sfVrQtrrBe0XTXhQ1+TYEL70On/upe7bBrzbgD
	C6CdAc3qTOBcJM+0EFbvk9JRbM95EnKwcFS3H3BV2CLTlDxSxSfz68kNuwDIJTvgKEiPcf
	sZo8X4SfvYnEk2Q9jeZ7ocLi2sqFdEA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 16E8741706;
	Wed,  3 Jun 2026 12:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D5A1F00898;
	Wed,  3 Jun 2026 12:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780488577;
	bh=TnuFx4Ou3kejucSUC1CjBWPb8/IIbrdEZSaYmxrJMXo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Hudv1vT9OqicBhA3XISYHEipfy8FQmRWxTfPZ9jZFgY5EZqvVMG7+hOsfzAa3geFa
	 llZzLC4aGEBsxE7wPLpES/rpe4l+Lvet3VGeR70wmk8OEtNmysRisJWr1RUDG5RrYv
	 GnMsOAfkyO3iw3VDKraNRk+WZBCO/M37aifHQ1m6kN39ri4CjFq8z+p/6+hF7Po8uU
	 ZkdM2MFPrUIR6HirYHTHvFjdX6Ds5SzmNiaBync+kWfhuIUYVUZZE6mYzT/9LPPsco
	 2lUlL33vAbUpXWxc/3YQoZK3Mk8KVMRN8SfYkEU7350ymoSSnac+eVkgLPGu9Aimwo
	 mol4W5y7LyXIQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, Miguel
 Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6?=
 =?utf-8?Q?rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, FUJITA Tomonori
 <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>,
 Lyude Paul <lyude@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz
 <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 14/79] block: rnull: add submit queue count config option
In-Reply-To: <abfeIpz8HP_Pr5Yv@google.com>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
 <20260216-rnull-v6-19-rc5-send-v1-14-de9a7af4b469@kernel.org>
 <abfeIpz8HP_Pr5Yv@google.com>
Date: Wed, 03 Jun 2026 14:00:00 +0200
Message-ID: <87jysfkf5r.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: i6eqdajz3xxca7umm3xj98hs41wsdwr6
X-Rspamd-Queue-Id: DCA5820002
X-HE-Tag: 1780488577-643874
X-HE-Meta: U2FsdGVkX19hAZMylzGH4itxwYmFvXzyN4BNUYRK1IPm/BanKZTZMFwM3VBQG2MZd6zF4z3tQeCCjkiTJBauqJIgJohVAoJQiGx4CCRRC1P7kVGSXHVdxDPAZ8mYJfhaP6rkphF1279aSIq4AgZq1HJHa1qiBzE3aDDQZo0wh0kI4q2RgxPy3Dbp9c8z7/FSkX9AbJi5e71FCDFfcfnWFgkGaKb+Gui/lfPpg8eLpX8lEoc56c7jAHG6ynui9esqhr6NCOBn8j4IJ8eDJDFySajKa8STPBEUzG2f3ZA6km3H9uD65woJiDpBBafQl5Is//fWOap9PehZgQTDE0/XPAYKXMhmIeo7N3noQRRV/dFU+bkcDGPf3WN+FOkv1p9+I5sTgsApjttemJW60WtfEuIDSKzRIfruofMy7uppfV+sqpA5DCpRLvUDJumMmq+SZ2/MM5E23HMWTLZ7XEVGSwDPGobf3/fyaB0bQ8KUW+KuKkgxf2Y0hCL1c8rdGOaiFl/HZuYmKMpuqXpl0IXx3VVV9a9xPvMsNm6lMLQF3CqgENNu2DtxUSLge/UyPOEHz7BArpccN1MFUIcnbYGYkDUfawH0PyK9rePRFM3ctiS+DHJaE7e9t4iQLsoftwtzyOfjjZRLPqN3Aj0/4+O1v1wKLJc4pDaCJYSy7jDgYJqW4lHEgK6g58I75pFAHvBAUGeEOMj5lOquAVhgwJ4NmRJ3RPx1A/b3+TH9gCMf2cmLWrbj/WPjylsDiTIOZxcBxPqvhojeVTifYr9RyFDKSW5dFsG1WV5NXlQZ26RDSZ9wVr3NwsVnJx2ZteFS1A20Up/qWq1WdCsDGfnP5LyLfVpjRnE8gmXRtkTTDfNrs3Zdh1rdLnvP4iO6ZMaxWp6LO9v4zGYcb0R+WrgYpWBCKf7leNnpdYB6HTjCuX5CL4f+fHINFpDFpj1xxZU4+XRaARXp8TjvptVw0lY4jiI
 v7+cGOwz
 2F1kvukO+Be/L80W1bdCo9vSvx1//+e35L5VrGURbABeqxG/Vs2ihwsxB09DpScvuTMnMM8FjWFSuglMfM2FyaTdN4Tlqdt7NXmBkiny87gzHbj3Xi762vDo5929m8FxdIQfM9NmGPZtTTOM8Qse8tDkt2f/+Xc0ECc8qJy9oxdm2bFfWXeGwJUqQ6H39/2YbklmFD8XYow+RCRkZSXrpj4ARkb+JKBqAF6nac9hDvhSNBBYI9ggDJGq+qhFQcvQyXBk8NDjkXxmZXl6q7fuZEGtkZLEi26/N84bvdcool0Xw1SpfW9uJhzwcoKACJ5t25vhWarzMREGFWNQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Mon, Feb 16, 2026 at 12:35:01AM +0100, Andreas Hindborg wrote:
>> Allow user space to control the number of submission queues when creating
>> null block devices.
>> 
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>>  drivers/block/rnull/configfs.rs | 56 +++++++++++++++++++++++++++++++++--------
>>  drivers/block/rnull/rnull.rs    | 56 +++++++++++++++++++++++++++--------------
>>  2 files changed, 83 insertions(+), 29 deletions(-)
>> 
>> diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
>> index b5dc30c5d3e20..fd3cbf7aa012e 100644
>> --- a/drivers/block/rnull/configfs.rs
>> +++ b/drivers/block/rnull/configfs.rs
>> @@ -59,7 +59,10 @@ impl AttributeOperations<0> for Config {
>>  
>>      fn show(_this: &Config, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
>>          let mut writer = kernel::str::Formatter::new(page);
>> -        writer.write_str("blocksize,size,rotational,irqmode,completion_nsec,memory_backed\n")?;
>> +        writer.write_str(
>> +            "blocksize,size,rotational,irqmode,completion_nsec,memory_backed\
>> +             submit_queues\n",
>> +        )?;
>
> Missing comma? If so, this may indicate missing test coverage :)

Indeed :o


Best regards,
Andreas Hindborg



