Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D58B7F013E6
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 09:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E3A76B00BD; Mon, 16 Mar 2026 05:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0920D6B00BE; Mon, 16 Mar 2026 05:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA87C6B00BF; Mon, 16 Mar 2026 05:24:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D695F6B00BD
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:24:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E13F14013F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:24:03 +0000 (UTC)
X-FDA: 84551389566.18.E154255
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id B10D51C0006
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:24:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Aw+q1Bv1;
	spf=pass (imf21.hostedemail.com: domain of 3L8y3aQkKCPocnkegt0jniqqing.eqonkpwz-oomxcem.qti@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3L8y3aQkKCPocnkegt0jniqqing.eqonkpwz-oomxcem.qti@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773653041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hJekOo29lf5mJautU95qylonu6gRgxCG19qcBQDNZqA=;
	b=lqviIby9ax6Iy3rAkN+RxlVVGEm4fI4LLQRQMR0KExHldq+30bEcOOCSQEZnamM1H4rySA
	qId8zy8vWN1O6Kz2+aYszFX60vRrgfEoU4fwBQcpAE29j2pXhDYYrSsAR00Ak9wWDhcvVp
	e5XnT9oH+etbLIo1HG7QbXiEwZ6Pp94=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Aw+q1Bv1;
	spf=pass (imf21.hostedemail.com: domain of 3L8y3aQkKCPocnkegt0jniqqing.eqonkpwz-oomxcem.qti@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3L8y3aQkKCPocnkegt0jniqqing.eqonkpwz-oomxcem.qti@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773653041; a=rsa-sha256;
	cv=none;
	b=viZR/HY7tx3/CixMa0EUuBn1Tuu7LrnM4Jo7fLITLbFYvkWmnULttj/qFv8wXQ2Nmez9Hh
	ixHVVBpso/hN7xtm3xrJ99j4SkNXKBW5kBm8pKGZ+IYPRJSekmsLNhd1qHfIHUSZHtcCGk
	fdhU9c95Qa2C0nnDELyIUeYiW+/oHRE=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-439b8bc43aeso3911492f8f.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773653040; x=1774257840; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hJekOo29lf5mJautU95qylonu6gRgxCG19qcBQDNZqA=;
        b=Aw+q1Bv18yzHnFsf1uHku36/UcjpOobvqUxOBXFZl9bNugcn+yLvkZ/t8NpucK9CLN
         Vaeh2jIR+iY/40foLuhusNFVnVDR9/fAx0in1B8/lv7sQny4taBTk7h9mXpR+5+rx3/x
         xd8sNgy5V2YOyzCNBh0ofi94yUr+FlkGIjgHnHDp1+s01Kkxq63GPq8/3r2v+BV8rFZb
         agtT1/rxKdJkFzcKpoFuMgycFHXksOH5JVgnqF+njuFLMGq5zzaR/xTFug0Sn3i+4JhH
         T04lLEHe4kAdBA4OjAs8/a8kUG2UNSDfAV+RBhq0oyh8xlWa7Qx+lRHD6gxYIZRHOy9s
         jq2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773653040; x=1774257840;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hJekOo29lf5mJautU95qylonu6gRgxCG19qcBQDNZqA=;
        b=SY9e0TqItwOGPORkmAnc6zGNu4AwTPDGZmSqk+BlUlS8erMJXoxCUHV3MTckysAPBw
         umgzW37e9Q0ABk57oqba9U6tPpJVQucc6SlWjxenqThBM0WSHit0dtG5cI7s4WlyHA4Q
         QAWrLTBt7WQI36g7MGrk1FRsMTl/aKEim+x6ZGlAD+xlJg0l9eOlwFKohGtS5A75ihwT
         JmUA8SpDAwRcCH2ZJJ0vZDw0ILMCGmvZvl8mrEoCkQ9+CFOgHuHymHdg1J58PNEtDTc3
         GU4HTZIg5qkqIGXb1omtR9Zs+tAXSC4YVNxkyPdrTUWKSasy9ZSUiPTApZdC3YoziPkV
         gxIw==
X-Forwarded-Encrypted: i=1; AJvYcCWXhVlKUam2uOQx0E5sojoJPQ/p06v21foNzUkW8Pz1YL7g81hDINlZtxUHon5fBT5t54TXQ1QuFQ==@kvack.org
X-Gm-Message-State: AOJu0Yz9O2lYwaTHkQZhDLaavAvHjlnje/HdbGP3Pdnnqxtc4iiTxTJd
	b0Gl/Jy3Ab0cD0JfQxbwbi3HQNHFY9QsX682QtR4mKKETkAlRQWdj3HS10L0svJlRvZIdUNV/In
	XkmgeQdw9CZTSdt51QA==
X-Received: from wmqu15.prod.google.com ([2002:a05:600c:19cf:b0:485:34c3:177])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a011:b0:47e:e952:86c9 with SMTP id 5b1f17b1804b1-485564981e5mr208897415e9.0.1773653039981;
 Mon, 16 Mar 2026 02:23:59 -0700 (PDT)
Date: Mon, 16 Mar 2026 09:23:58 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-3-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-3-de9a7af4b469@kernel.org>
Message-ID: <abfMLujw4GbncLVR@google.com>
Subject: Re: [PATCH 03/79] block: rnull: add macros to define configfs attributes
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
X-Rspamd-Queue-Id: B10D51C0006
X-Rspamd-Server: rspam07
X-Stat-Signature: bwweps8g91fr8449t368rptpqw1hyaak
X-Rspam-User: 
X-HE-Tag: 1773653041-197670
X-HE-Meta: U2FsdGVkX181n8XxWInmTgyX7AA+A/Q11AHMSaJI4s45S1fGcFhcJliJTRemrNWSgaHL+viiVn6bIyxmYK/v7PC1yvOtO05J411fDSZSKJgvJ7V9JF9iqeAi8bkAoWnhPB/46+p2P95+/G5HL8vuS3rih2MgynDd2ktZiL8vgt0pNg7uD0V0scrTGNevGyz4ki/y+OcUyF7HXyajwCd6NyqUPsR00RD7JTTsGM01PC0bDqWOPnN6d5MqrR9m8Dxs2aiAzaBmUcIUITq67+jHOTj53JMiuvTW9OHZBi+UIEZyFl2shRhYm7Iyx+pPneJdUezQ5kqPgLvGA77rrONP4lM3ZJLfr9TrnwP04uRIqGx8a5skGwcZ6czNTPkQTveriL1YU/LdQ/vDDVIvSYF75ISWhQjnJWZLtbbsJKmFN8GwhEvV2epp/UH/uV/Z+FIuI170JvXQh2dt/Oe1RBMb2VeiyrgUrEX99QLs/ydoV81kWK8KmQ1qZts1Ipq1lu/tRPPgI+lFN0K064piIy3WwMymumEdyTS0XybzdmdpmwhQm2smLLG1KyGef1Y00nmZZ/kGCR9Tl3RSGS5EJUtSPPnRUoWcMs2FStDYLGLB7jyl/u5SJelhEdnDiS/os1T39OLdDJQhLE1vcUEY7GWA6lJQYM42SM04oRXsxaTSt9wTI5Svg3Ue7r0HRICHyBSxG1FSU5nBUN/NIZ5ZLMhrTMlBbyRUZED8Q8u9WyVAQhQ3Kdq+MKYmI8EPzu5qH2TGtkXMQzn921EUrJ43wuvoT2My2pjK5yvopZDdo7i76Y1IbUyCLU9TliZA9GFh3+clnom83PYGVI2m3B8Z/Vz1mD7S4W27SuI5Od0sg3SdBoEvsLFASgkNHXmtNcyFseSlXklSym1YoQPO8EoWEimaiJGBjhgFePLn7iO3xr7XSl3ZM8JUmHbEdFwf8y8oi+02E5YmRNHLBKD72tTjD8O
 KZ/YRBuZ
 kzSrwFUAX7YgggzucRqP4QsI8zKQTI0XzbfgG4MiKhpiHZzJiU6RohWoKW6b0WrluvAMY2JhEPWE5k5QJmaHIotinvpYY0xzeVvaM3zNXkSxifZ9RIbCuN0gA3sO18Mzb9UicfJAGQLqOg92uMP6ihNaUpbE9ckF8uSEHDy/awsB4CB9bz4TTDoXNAIDgItaFB4UntXPUswyZIISpvQK7I2m3seOoAmNjFLpYPPvKUGZHOgFT/1/wj9PCaNjM1AopzAMGY7gGJ2LfSPerz+Qc3lEMWQzAhd31n1VRzDHcngBfcwF+Tk6v8YWDKH12njaLVbgq6eDInhRgO9YHoQBTo3soOd2I2nFzM+GAsqGOthP4v44GlVx/92n+2a/wklQyVOe4FHe98SJcGkDZaImIWOJc0vmT/YoUfAQMeywfQ0+3i9uaT2enL3XHi+Rf8SyEu5XLGHXRkbGRVCmE69o8bEh8spuYtH7XAibLkgpFcCpz2cwt6KDQNkQ9BBkvrbWQMuyyi+pRI9vQ0vHsQ8FneExoSAZqSuoTM71JXsxgmEob8o5Vt+2w7g9y/cFN1JA/uuws+jcT3/VziamRd26k4zvV9vnmgZh4Hx2I1Yb3HcI3jwpGQBg/W6erb7WtYzZajqXCI4ELi1h+TKatSKKWWzBXCnwCs7Q0L5BSrYqAsU8ck6Vmb80ZKoJQy2PyZnuvgQW/dtq0EIgZVUE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:34:50AM +0100, Andreas Hindborg wrote:
> Defining configfs attributes in rust is a bit verbose at the moment. Add
> some macros to make the attribute definition less verbose.
> 
> The configfs Rust abstractions should eventually provide procedural macros
> for this task. When we get more users of the configfs Rust abstractions, we
> shall consider this task.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  drivers/block/rnull/configfs.rs        | 134 +++++++++------------------------
>  drivers/block/rnull/configfs/macros.rs | 128 +++++++++++++++++++++++++++++++
>  2 files changed, 164 insertions(+), 98 deletions(-)
> 
> diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
> index ea38b27a9011c..eafa71dfc40d3 100644
> --- a/drivers/block/rnull/configfs.rs
> +++ b/drivers/block/rnull/configfs.rs
> @@ -1,20 +1,41 @@
>  // SPDX-License-Identifier: GPL-2.0
>  
> -use super::{NullBlkDevice, THIS_MODULE};
> +use super::{
> +    NullBlkDevice,
> +    THIS_MODULE, //
> +};
>  use kernel::{
> -    block::mq::gen_disk::{GenDisk, GenDiskBuilder},
> +    block::mq::gen_disk::{
> +        GenDisk,
> +        GenDiskBuilder, //
> +    },
>      c_str,
> -    configfs::{self, AttributeOperations},
> +    configfs::{
> +        self,
> +        AttributeOperations, //
> +    },
>      configfs_attrs,
> -    fmt::{self, Write as _},
> +    fmt::{
> +        self,
> +        Write as _, //
> +    },
>      new_mutex,
>      page::PAGE_SIZE,
>      prelude::*,
> -    str::{kstrtobool_bytes, CString},
> -    sync::Mutex,
> +    str::{
> +        kstrtobool_bytes,
> +        CString, //
> +    },
> +    sync::Mutex, //
> +};
> +use macros::{
> +    configfs_simple_bool_field,
> +    configfs_simple_field, //
>  };
>  use pin_init::PinInit;
>  
> +mod macros;
> +
>  pub(crate) fn subsystem() -> impl PinInit<kernel::configfs::Subsystem<Config>, Error> {
>      let item_type = configfs_attrs! {
>          container: configfs::Subsystem<Config>,
> @@ -166,99 +187,16 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
>      }
>  }
>  
> -#[vtable]
> -impl configfs::AttributeOperations<1> for DeviceConfig {
> -    type Data = DeviceConfig;
> -
> -    fn show(this: &DeviceConfig, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
> -        let mut writer = kernel::str::Formatter::new(page);
> -        writer.write_fmt(fmt!("{}\n", this.data.lock().block_size))?;
> -        Ok(writer.bytes_written())
> -    }
> -
> -    fn store(this: &DeviceConfig, page: &[u8]) -> Result {
> -        if this.data.lock().powered {
> -            return Err(EBUSY);
> -        }
> -
> -        let text = core::str::from_utf8(page)?.trim();
> -        let value = text.parse::<u32>().map_err(|_| EINVAL)?;
> -
> -        GenDiskBuilder::validate_block_size(value)?;
> -        this.data.lock().block_size = value;
> -        Ok(())
> -    }
> -}
> -
> -#[vtable]
> -impl configfs::AttributeOperations<2> for DeviceConfig {
> -    type Data = DeviceConfig;
> -
> -    fn show(this: &DeviceConfig, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
> -        let mut writer = kernel::str::Formatter::new(page);
> -
> -        if this.data.lock().rotational {
> -            writer.write_str("1\n")?;
> -        } else {
> -            writer.write_str("0\n")?;
> -        }
> -
> -        Ok(writer.bytes_written())
> -    }
> -
> -    fn store(this: &DeviceConfig, page: &[u8]) -> Result {
> -        if this.data.lock().powered {
> -            return Err(EBUSY);
> -        }
> -
> -        this.data.lock().rotational = kstrtobool_bytes(page)?;
> -
> -        Ok(())
> -    }
> -}
> -
> -#[vtable]
> -impl configfs::AttributeOperations<3> for DeviceConfig {
> -    type Data = DeviceConfig;
> -
> -    fn show(this: &DeviceConfig, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
> -        let mut writer = kernel::str::Formatter::new(page);
> -        writer.write_fmt(fmt!("{}\n", this.data.lock().capacity_mib))?;
> -        Ok(writer.bytes_written())
> -    }
> -
> -    fn store(this: &DeviceConfig, page: &[u8]) -> Result {
> -        if this.data.lock().powered {
> -            return Err(EBUSY);
> -        }
> -
> -        let text = core::str::from_utf8(page)?.trim();
> -        let value = text.parse::<u64>().map_err(|_| EINVAL)?;
> -
> -        this.data.lock().capacity_mib = value;
> -        Ok(())
> -    }
> -}
> -
> -#[vtable]
> -impl configfs::AttributeOperations<4> for DeviceConfig {
> -    type Data = DeviceConfig;
> -
> -    fn show(this: &DeviceConfig, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
> -        let mut writer = kernel::str::Formatter::new(page);
> -        writer.write_fmt(fmt!("{}\n", this.data.lock().irq_mode))?;
> -        Ok(writer.bytes_written())
> -    }
> +configfs_simple_field!(DeviceConfig, 1, block_size, u32, check GenDiskBuilder::validate_block_size);
> +configfs_simple_bool_field!(DeviceConfig, 2, rotational);
> +configfs_simple_field!(DeviceConfig, 3, capacity_mib, u64);
> +configfs_simple_field!(DeviceConfig, 4, irq_mode, IRQMode);
>  
> -    fn store(this: &DeviceConfig, page: &[u8]) -> Result {
> -        if this.data.lock().powered {
> -            return Err(EBUSY);
> -        }
> +impl core::str::FromStr for IRQMode {
> +    type Err = Error;
>  
> -        let text = core::str::from_utf8(page)?.trim();
> -        let value = text.parse::<u8>().map_err(|_| EINVAL)?;
> -
> -        this.data.lock().irq_mode = IRQMode::try_from(value)?;
> -        Ok(())
> +    fn from_str(s: &str) -> Result<Self> {
> +        let value: u8 = s.parse().map_err(|_| EINVAL)?;
> +        value.try_into()
>      }
>  }
> diff --git a/drivers/block/rnull/configfs/macros.rs b/drivers/block/rnull/configfs/macros.rs
> new file mode 100644
> index 0000000000000..53ce9d5dbdc8a
> --- /dev/null
> +++ b/drivers/block/rnull/configfs/macros.rs
> @@ -0,0 +1,128 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +use super::DeviceConfig;
> +use core::{fmt::Write, str::FromStr};
> +use kernel::{page::PAGE_SIZE, prelude::*};
> +
> +pub(crate) fn show_field<T: fmt::Display>(value: T, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
> +    let mut writer = kernel::str::Formatter::new(page);
> +    writer.write_fmt(fmt!("{}\n", value))?;
> +    Ok(writer.bytes_written())
> +}
> +
> +pub(crate) fn store_with_power_check<F>(this: &DeviceConfig, page: &[u8], store_fn: F) -> Result
> +where
> +    F: FnOnce(&DeviceConfig, &[u8]) -> Result,
> +{
> +    if this.data.lock().powered {
> +        return Err(EBUSY);
> +    }
> +    store_fn(this, page)
> +}
> +
> +pub(crate) fn store_number_with_power_check<F, T>(
> +    this: &DeviceConfig,
> +    page: &[u8],
> +    store_fn: F,
> +) -> Result
> +where
> +    F: FnOnce(&DeviceConfig, T) -> Result,
> +    T: FromStr,
> +{
> +    if this.data.lock().powered {
> +        return Err(EBUSY);
> +    }
> +
> +    let text = core::str::from_utf8(page)?.trim();
> +    let value = text.parse::<T>().map_err(|_| EINVAL)?;
> +
> +    store_fn(this, value)
> +}
> +
> +macro_rules! configfs_attribute {
> +    (
> +        $type:ty,
> +        $id:literal,
> +        show: |$show_this:ident, $show_page:ident| $show_block:expr,
> +        store: |$store_this:ident, $store_page:ident| $store_block:expr
> +        $(,)?
> +    ) => {
> +        #[vtable]
> +        impl configfs::AttributeOperations<$id> for $type {
> +            type Data = $type;
> +
> +            fn show($show_this: &$type, $show_page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
> +                $show_block
> +            }
> +
> +            fn store($store_this: &$type, $store_page: &[u8]) -> Result {
> +                $store_block
> +            }
> +        }
> +    };
> +}
> +pub(crate) use configfs_attribute;
> +
> +// Specialized macro for simple boolean fields that just store kstrtobool_bytes result.
> +macro_rules! configfs_simple_bool_field {
> +    ($type:ty, $id:literal, $field:ident) => {
> +        crate::configfs::macros::configfs_attribute!($type, $id,
> +            show: |this, page| crate::configfs::macros::show_field(this.data.lock().$field, page),
> +            store: |this, page|
> +              crate::configfs::macros::store_with_power_check(this, page, |this, page| {
> +                this.data.lock().$field = kstrtobool_bytes(page)?;
> +                Ok(())
> +            })
> +        );
> +    };
> +}
> +pub(crate) use configfs_simple_bool_field;
> +
> +// Specialized macro for simple numeric fields that just parse and assign
> +macro_rules! configfs_simple_field {
> +    // Simple direct assignment
> +    ($type:ty, $id:literal, $field:ident, $field_type:ty) => {
> +        crate::configfs::macros::configfs_attribute!($type, $id,
> +            show: |this, page| crate::configfs::macros::show_field(this.data.lock().$field, page),
> +            store: |this, page| crate::configfs::macros::store_number_with_power_check(
> +                this,
> +                page,
> +                |this, value: $field_type| {
> +                    this.data.lock().$field = value;

I think there's a TOCTOU issue here. You take the lock to perform a
power check in store_number_with_power_check(), then you release the
lock and check again in `store`. But `powered` could have changed in the
meantime.

Alice

