Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A424F46445
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:40:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2EE96B018B; Mon, 16 Mar 2026 06:40:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDCCF6B018C; Mon, 16 Mar 2026 06:40:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADEDF6B018D; Mon, 16 Mar 2026 06:40:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1356B018B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:40:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ECC8314019A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:40:38 +0000 (UTC)
X-FDA: 84551582556.09.DF8799E
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3476F140009
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:40:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GKLSTRH1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3I963aQkKCBQu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3I963aQkKCBQu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773657637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KKz2KTzlcBf86rOKf9vSTqBmxmc8gj/65J7dXuwwtTQ=;
	b=bTjPruToxZ/oH0BFU35w/ggJjBSYRXpsPx0qISc0/nITDkt6TovsXo2bKTpdsnOnuoC8Q7
	BSirZ2AU/0wKoHf5fogOk3qM4j/+BJaR/X7REpvRElwNXaB/rYM5ot8Qp9cUi0uDoGQ6UE
	CKlah3anTv+ppbaIpM7F6iPiVFqmQ0w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GKLSTRH1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3I963aQkKCBQu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3I963aQkKCBQu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773657637; a=rsa-sha256;
	cv=none;
	b=JjZ4GFfpnSq5d02kvgtOv2GJqsvI5eMWaJR7KHcFiKx+FyXUNUg6ql8h7YrD5LiCUSIkyV
	0SaGxYYN6Oja6CxdmLrZGY4KwIGAMKfVZs6PAMvEqNVkyRppOA2ZHAmT8qJ6PiPvZqm8kY
	Zh0N5BKrctQHh6XoimJYKN1yM/KFWhE=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43b3d3d2d22so1294550f8f.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773657636; x=1774262436; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KKz2KTzlcBf86rOKf9vSTqBmxmc8gj/65J7dXuwwtTQ=;
        b=GKLSTRH11oUQbWLO83APFwMxxJktM/2DpRkAzQzfBVLXcv9Pn9g89KG9GUNhRBuVD0
         os3qKnMsvWArwueDU66deEmDCFitQQOsbKvAl2YR/RrA4Jcf7M6it9j06eovj4h+DzJM
         ItNwUWwqnoeE0z2UlIUDGEz1D88ABh2gxkzyCo1qX/6fEQTHm2cB+PvbD8LsuG4OcAJG
         ptt0/YVUBvq52E1/+qGRYlpAH6De3nf8iF7ryZGa+ALyROWZ0pkeX3xgbzmowxOr5Ezk
         G2UdmxBkE1ubLs31N/Tyf8s9HAbh+soWE3nS/8ldZAMXvqWhXnlEfT/5cGTM7LzrWHIP
         DvBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773657636; x=1774262436;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KKz2KTzlcBf86rOKf9vSTqBmxmc8gj/65J7dXuwwtTQ=;
        b=TVs0FnzdXIagMoLkh7swwbfWF8Tz8sfIZUg2M2hpWsIBKLUb4w51qrSsps/hn0fTuI
         nl8WX3YGN+rzSdlChhh+2L1cnvrgKVejhziMC3OwxhhFcVZp5yr3409l8vu1msuJRj7w
         6y3kwlOjktezYQZHEqjVvd3xTCj0foSASeapjgfek1F7qWFiVCwwVHFz8RdLmULzRn3g
         +m+W0c0kjGlDcpOsTMMy3Ot24WQxu5Q0cf+bRicmNTW9i3DbdfZy8xrb0j+2hIfZWPyA
         DPqEP7Intw7h2rZPnlprw+Rda8gdWPkPwqUwxW/LYBdzpLNmkfsdJEmMGVli2u249so+
         dBAA==
X-Forwarded-Encrypted: i=1; AJvYcCWvP11SY3Q+OFtuQJHtc4bjYLRO/NM+0ZL6IjUMXZo3Yd1gFXWSdLNIvVtboB2bCPo8QSuKHrDIXw==@kvack.org
X-Gm-Message-State: AOJu0YxY1NKjBhtKfjgUCl57BxihTOy6icY/hN+W6My8dztJjE3TuOid
	dA2UIJZPYodxWEvl0st5a/L8/EpuOlvnZs0XR6VQMBQXbK2AGkoDVive14mffBUdG2zekIU/YRG
	mFdMDUr73bc2e/7Uy+w==
X-Received: from wrbbs28.prod.google.com ([2002:a05:6000:71c:b0:439:cc48:d5])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:26c2:b0:43b:433f:489c with SMTP id ffacd0b85a97d-43b433f4a72mr6008387f8f.13.1773657635312;
 Mon, 16 Mar 2026 03:40:35 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:40:34 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-14-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-14-de9a7af4b469@kernel.org>
Message-ID: <abfeIpz8HP_Pr5Yv@google.com>
Subject: Re: [PATCH 14/79] block: rnull: add submit queue count config option
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3476F140009
X-Stat-Signature: sr6c53naqhpayep3x6udt7qw9x1813pz
X-Rspam-User: 
X-HE-Tag: 1773657636-259764
X-HE-Meta: U2FsdGVkX19OuETbHYUtHwpOcEYX/JoSeDzWcTxCcpfndaooMo3XDkbts9IWrEMO7bxri1YH3RBf1PZMqpu+WL7oQfXejjHmbH8RZX2uI7KS9BVnGdoxcdZhy3wXTEWcyQAfbHH04WSncba/q9z+d9LNws7of81XLs2+QEucgBpe4feI6Vhwzt2/OcaE5saf50gwUm9r2vZRmlhK1KuKc1CoWVlsNR1wU/YugXNTVkPb6yxlr6xbzALei+TvkZ6i8Q7U7jk7Om8oIgqeJqw0cnu8uTBoH5AHMLA9VnKnUNnLabH5Ni23LrhCyduzM+TKErQQnFzh5h9hsVNeIyns33VOn+nM+E6x76Tgo+ZyH9pmzTFoEJQemEQUmVvDsS/aiDGyg/DNFJJ+ZormMb0xxIr3/K9vvvgBirAcKwbQ3cDdxppAa2f9lsTzPRKb95IQk8PYHG4SfjIBS79umFFvTkbkYocRH5E6Ji1Qh/Q1afLrESevLwhkXJhrJ0r3e4087sLL4ugVw/0OENmCNF+ZSvHGng5a0I8BxbbXFp7KWsa+zf4bT3Uj9YZy37cn+xp5FspKzNpOHjqdBwwHBV5kHkyOEnEUhjIJjmSFR5l3sesPDXzMaam0Dxs7BE2B3kAdePltL/MpLSZWgVHRT3Cg1eit2SR9bdzbVgErzGiy8yNzS9hWSrQSg4K8InPJ2hfiMMEbxE5Z87xzOlpblRd+n4TxMTlfACcD75qXXH3mqG3wAYItzxWXdetwGL4d2zpOdoTj7fI6cLDc+qpqznCwQ6qNv2VCfdT3D2RnFxwCJAMrcvAlePQOwYby3W2LOKc/UlE5bcuHDhY2z/YUnRVZlM6nxpmR9BAGbkBT+WjtSD7za5VIi/z9/8ZYPrBALEgNK6a58hu9rxmL4rb4CEM/Lh+S33Xp2Trhh2e2SZWEDLaa5TA7Pf3dE3SJc0Oa1ETavGXh+iY+F18RV4EOU7y
 KmPctUE1
 5/70/biwvSxavOVTSiAnsOgrGhXN7WXC2AuyszM4buIjoBu381aI5EQdSW6PN8ICmlQmymQUh8nslwhHeRGjfQDh2L39pWeO7tcKqa1v5ndt0r7rMVZT0/fTkW9dqlDSSx3INMzUaRaLP82jPVK7Xpkn1dINddv3DrF8yoHJw0VxLF9lrNArhlwM2/l/Ngz8+WEO18ZueVpEdBE+AK7dfF9vSVbTS1fhnt+9I0mliJYhXYhB1Bzyyo1PzSCj4a97Qhb9GJAbm3rbqj0kwec1+iYkAQAnMAXlwiwtPURrOvkn9wWFbO0PLK3KF55PVVTHmd5jIda/LTifhBPS11MpYA+xr/VnqSjINiA/+wv/ePpqdWoU/FlSp7ZpIAJTly+4Kx/CyCivZpcMByzdqYQje01EVMasSv293XJKHV6bn8FNCf3iHQNiILx6n4OutaRSmYXVuzkYRkQfqxYNTxDDuQ62SIGTjzisJ2Ho/OFFbcAfy2HPeQdQURXWXmPaxGXGOH0QizIA0oj6w3mCeqIL8AkDT70q7PiqY6jn9AQ4HByzgBfDIhekzp+kOH5kDSykFR7f6YCU4iAEGFgovg3m2OJ2X3QSviaMXvFmdsvgg7BfGLLT7tltrS+HfEfyl4UDj0oRVmNV/k1qdoi2ekZwZ3p3UKWwTbSrrts+EBpCrkJP8CJawfi5UijEgUTvbdVXz+BAk9k865MdzTWY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:35:01AM +0100, Andreas Hindborg wrote:
> Allow user space to control the number of submission queues when creating
> null block devices.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  drivers/block/rnull/configfs.rs | 56 +++++++++++++++++++++++++++++++++--------
>  drivers/block/rnull/rnull.rs    | 56 +++++++++++++++++++++++++++--------------
>  2 files changed, 83 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
> index b5dc30c5d3e20..fd3cbf7aa012e 100644
> --- a/drivers/block/rnull/configfs.rs
> +++ b/drivers/block/rnull/configfs.rs
> @@ -59,7 +59,10 @@ impl AttributeOperations<0> for Config {
>  
>      fn show(_this: &Config, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
>          let mut writer = kernel::str::Formatter::new(page);
> -        writer.write_str("blocksize,size,rotational,irqmode,completion_nsec,memory_backed\n")?;
> +        writer.write_str(
> +            "blocksize,size,rotational,irqmode,completion_nsec,memory_backed\
> +             submit_queues\n",
> +        )?;

Missing comma? If so, this may indicate missing test coverage :)

> +struct NullBlkOptions<'a> {
> +    name: &'a CStr,
> +    block_size: u32,
> +    rotational: bool,
> +    capacity_mib: u64,
> +    irq_mode: IRQMode,
> +    completion_time: Delta,
> +    memory_backed: bool,
> +    submit_queues: u32,
> +}
>  struct NullBlkDevice;
>  
>  impl NullBlkDevice {
> -    fn new(
> -        name: &CStr,
> -        block_size: u32,
> -        rotational: bool,
> -        capacity_mib: u64,
> -        irq_mode: IRQMode,
> -        completion_time: Delta,
> -        memory_backed: bool,
> -    ) -> Result<GenDisk<Self>> {
> +    fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
> +        let NullBlkOptions {
> +            name,
> +            block_size,
> +            rotational,
> +            capacity_mib,
> +            irq_mode,
> +            completion_time,
> +            memory_backed,
> +            submit_queues,
> +        } = options;

Nice!

Alice

