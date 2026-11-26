Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ACFE606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 14:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mKxSM0kO
Received: by kanga.kvack.org (Postfix)
	id 03A556B05B0; Thu, 26 Nov 2026 09:10:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 011956B05B1; Thu, 26 Nov 2026 09:10:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C5B6B05B2; Thu, 26 Nov 2026 09:10:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB6D66B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:10:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D2C440479
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:10:48 +0000 (UTC)
X-FDA: 85477456176.24.59B11D7
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6EB21A002B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:10:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mKxSM0kO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nico.antinori.7@gmail.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=nico.antinori.7@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795702238;
	b=exogOq76nqzCCCwxorCj/JsSe8a3ca4MI6+1GNlqPTMrbhDSGUK14fmK1qatqwHZ/obsWN
	J79DGs0RPABDXqVBtKcr1IwBasbMap1BPjKLOriLPugb4ILY9jol6iUQp3uHy0OdTYqmZL
	VF5E8g3OKPBSonpIs00Ly3axk7oNwA0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795702238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pZCrJxjGpKeIxaWqujE/cqP8aBauwoXvz6QYa0WHP4s=;
	b=j29447NVyOJlWPgKRJk5C7woSEQ+MpsGtX6KsxbqFhORrVpGlLlgXO0dia9V9gir9GVDM+
	gCttdg4xfsTxSTC17GBvsSmXy8jE3P9UnE9zlX0o6wiUAHGzqoH1wyNR+RRB/SJV8lydHR
	MutTOgYQ02n8tnEJTYAivNfEhODRcPo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mKxSM0kO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nico.antinori.7@gmail.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=nico.antinori.7@gmail.com
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5eac7220e9cso2741465e0c.3
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795702237; x=1796307037; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pZCrJxjGpKeIxaWqujE/cqP8aBauwoXvz6QYa0WHP4s=;
        b=mKxSM0kO5TNAQo0W7/yA1yMLEelEDSBmM08QkAgKwuqHF7qhzWKPcWq4OoosBWMf34
         qDFeQd9wd6Ke4CBDwasbltnwgAwor+RZIaRMhreFT9JBGTPC4DP+2ssmBT01DNCQeDFw
         iEQ70Ba7rwTJ6f7p38gezDabBtaHNQesyXhZjZBCQiGdqEgCiEmspjRWrIRux3iVvOwz
         FlLDsXp3ZILD8Hpq4oPtmZGE+/23f+MkjCTEsYZODbEPNEk7W80Nge7MROhLEYZNd3XZ
         D2VVOCNpFDwRVQk5d5nGVkSlZaVGnbSMBFwvQ7wQba2EDQooEyqGrb5MV7s9BkCOPuB+
         bTwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795702237; x=1796307037;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pZCrJxjGpKeIxaWqujE/cqP8aBauwoXvz6QYa0WHP4s=;
        b=GzUHQtCouETz5M8EAUX92uco+J6zofzoLbAYLXu1Trx9M4Mo7wyJ985b7MhY5yuNYq
         o2OCpsQgCEApYAIwXNfhVg/haburviDC+zd60TfmvJJ82jsCsedTJ/xLPdctVzsxoCYu
         5657WH+zbZesGda8EeC1v7VrdwHkrlk/k+FAHnZh4PPOZrJWgd7QTFhfrcxZYxB7TUZf
         v7oUwKHya+puWnNfGtWIeMBGrMtBydf+h2j2QS40CgKtJFTQn81ZiAlj4lnUHZlueZZB
         1yilBuTGrFIP8YSGOwcqoUliZgiU0Jc/4jcbeoKwf7N/0gshYhkB3sH52Q/Uv4BEjBnH
         2MEQ==
X-Forwarded-Encrypted: i=1; AL+hErGeCoeVAM3w9Aim2VLhd/isJa9RPUBhfGucG/iJblA8tdNmVd7agPP7pAq2QLIXRTgADhfECM9EHA==@kvack.org
X-Gm-Message-State: APuU4Z9Eqekf/AY8JNg9R63dQLUNlAcUyZKC1oWFPlQMvT+ThA/45aQF
	orACcTUt6cMQEjbEpL4iVpROhiuzF6+Kgo/f8YFW3LPWYJKQiF7jWq0=
X-Gm-Gg: AZFdTZeZbBmotmKY2D4/S0YiCoKcrVCSg2obJu1R1+2UqQ7X5X2iFN7scjkk0qdItAZ
	KS32SMwu94VbctI1YbdlG4MtIaAkVa5BrP0cVYr7iqNpkARmlGs7JQUQHVxiGEujIhcdhdgYSqd
	LXf7Xz/tQRWy9ilM28lt2sz+m36cCgeqfG6Qnk93mSf4YL8OiIXh1Fd96eoSI6KUNF7UzzpTSds
	qWKdTM77M9wokDpSA7PsOPDAT++3RmxLlfYLb/U/TsRVGztvh3Bq1ZyTrZ2WZx1EbUvVs4dZU5u
	Fjaepj9ysQ3Nhk/pyFecTQsz7Pu1GZwTh1ADclrSp0rOymFbESjo51/ZPZAAwt0Np4rUl8XplNW
	Z0mtAn1zTFb5hPCde+YYMHKXDexTqNq/BOigEi4r9AEka/gGTrVdfuJKzNxExGKcCNCIMHYFrVh
	o/7lJ+wZg80sbPdeg7jKR4XU4Q6jlTSd3GxylbE/Hx9NqjoDwTnQpz54jsI+0quVojtc0PWTX/Z
	3Fn0SyqNAdlHMo6IdQ21M1E6GZ+sffZUm6tyGg7FzUYsdRGv84R+eNTeaJFNIRSnVkEmt2QHh7r
	70aTYbjlR4GCT9vNf1zNygbLVCz+CrjcjdHb4F663Zgz9GzCPdmUivUGQXNyjVvj
X-Received: by 2002:a05:6122:3b84:b0:5ea:e324:7c0c with SMTP id 71dfb90a1353d-5ee8af8d6fdmr11736966e0c.22.1795702237493;
        Thu, 26 Nov 2026 06:10:37 -0800 (PST)
Received: from localhost ([186.158.238.108])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ee91a4e0cfsm19471567e0c.13.2026.11.26.06.10.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 06:10:37 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Nov 2026 11:10:29 -0300
Message-Id: <DN57BC2XOPSJ.2UE7DI9RNQUBD@gmail.com>
From: =?utf-8?q?Nicol=C3=A1s_Antinori?= <nico.antinori.7@gmail.com>
To: "Ivan Tverdokhleb" <mbkchelofficialdev@gmail.com>, "Alice Ryhl"
 <aliceryhl@google.com>, "Miguel Ojeda" <ojeda@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>, "FUJITA Tomonori"
 <fujita.tomonori@gmail.com>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 "Danilo Krummrich" <dakr@kernel.org>, "Daniel Almeida"
 <daniel.almeida@collabora.com>, "Tamir Duberstein" <tamird@kernel.org>,
 "Alexandre Courbot" <acourbot@nvidia.com>, =?utf-8?q?Onur_=C3=96zkan?=
 <work@onurozkan.dev>, <linux-mm@kvack.org>,
 <rust-for-linux@vger.kernel.org>
Subject: Re: [PATCH v2] rust: mm: warn once on invalid VMA range
X-Mailer: aerc 0.20.0
References: <20261124132609.101657-1-mbkchelofficialdev@gmail.com>
 <20261124153228.134723-1-mbkchelofficialdev@gmail.com>
In-Reply-To: <20261124153228.134723-1-mbkchelofficialdev@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6EB21A002B
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: kyhkdm5z9gqyyyuttkaxzk1469qn8fdb
X-HE-Tag: 1795702238-185587
X-HE-Meta: U2FsdGVkX1+SLFfGGIR1scsoSACAq2K5yQWVuWJGCiF4N2O9MH1Q9d7O48WSEfUaWKs+yw+QlpvqDgxHM2QkwOFbxgOejqC3+p3PordcWshWn2E2P5rOQ8nrFMW8WM45agBA3Of4lYDIUvwVkpccXWVtUQtLLZOHXG31d8yqbgZ0IxhRjXPYrl1t4awv3myQ+Os70Gxs9EODSU4vDHt3gf6/kMfrjznIg3zojSWnHc1Ygd/I0SRstsoL1OpWGyzstx9G+K1hPHfUb6PxXcnyG5fFK29w9bhSKQ978hurbzgp4Obliqm88YDUnB4P4PM5Voo1yeC2+/7BBS1PHyfZAGPn8jC+pZ7Sz7XP9Fl20Ld5Hh+jen4iWnmFbsI0FrYI7PH6O0aBgJDIhiUkthDGThDHHwrqYrTpsASkeLRzmAZjykO8qhLefLg26uwWxvx5TuqcyAQYCzvvtrTXGJvlyJA+sl/tVVHMjgXsGqspOlXnTKtSbzIBEXh22H3zdoIFQhEpzzknNvQAVK/cdXMFu2ZaJiz8/D2Q6ImQ6Pi4jH5lzqd+dhjPCjnEsAg+nyzosY2jFZtaLvF4xd/WJvBRzPo3l2HxwBsesce2G5dqo5kBnZTUFoxhZjhUdlXxDF0967dGeZLd2q3RulVG1Igjd8G8OcWprvacJeHezbY7UUAHzBcZFVrrkWtWlAs5zpnWkWZUPv7PVm0z9jay10QBkqW3ITtf1TxwMkCValZRwj7aTdqoQF6EGzlQMkx5Gy/6einKEdoaqzfhD60+DSiStM9q1ly0gPfwmi6Bl5oXdTy0Ud9d7+0y2lQc4bliTWn8v6XK7ePOt9+4y8MbduhMp5/VKDZUWseU8qYgx/AjyDrzj+/U324PKrJCC5/ywwYuiUxUXES2yeTmfhC40KXoFjUnSOM9LekIkmnT4JsOl9dEm6adBf2ORxCx49cOgNVn/nORpegGyXqw/c8/T5t
 C5Qj7eog
 8Kf0Tn2qQNr2Q0AUt1bvmfkFv6C+DZFxCOuEyAw8sizkZuPq79wLQMyNOe7R1/MipCrpPu0C1Z8MKd2zX4xUKiTZggdV+dbR5DJxWqU37rG43gPm+UyrAMQUXqp/HY3rhhSzb4/fDnuYfiHuhv3US9avjG0NxxTgGmpSc3jbJRTrv1lMMFba+nqrnMEixZxCvTlTz3gzMi7+/BLJa9FAZr13HF+jXeow9M2EpRpT/RvCPUQpHS4Kti0xw1b0M4iK3jvkftIhECcskEI0cVz/2pQ2Z+TCiyQsgvQV4BTFHGQHvM2TKvUg8B6gLA615KgFhs4Gn9ix0692PozC+Fqv2MkWWF6Gn3dbGyMNYQyAQS0glkim2fP/1Ow1v4zguef0qq669eKN82oHxPDnNwPsEWbBYo+ft9QhM0TzDARQVlZLP6dfWLIOQ5rDYUnU2gR9lA+I9jWf1ifg9IWfAyCH1BJlNi/qTuwltwoxi6nccOpykXG/NygmA6Io7791eSN8gZ7i0/rtdMSPwEqZTNWWdzVTbqx9fwE/mtgmSjqH5wMFgC95ezfMH+sch2DE4NzmvTsGjg7OPAGBLavCFNoWNLHzABx1/iXwRmKgilDaqU+O+B36raSIUKhCZ695EImW0s8vGW24pXIIHjya9wQGyeS50HzC4jr1RiMlPu6mjQvioMLl2KK2Vq3RlQ3ApVCsXr40RJIK+JSBIfPrmETIlufZNfFGt4HjGDAnZ1leZcv8gYEDl883jEnGTZ7p9YR02n6bznQxcP7pG7mIvRRwvPO2rfwVtypwZoV2FLSmrUMeuYwetCMOZyBs0mEixGoawUF0yi8oGq+LglUo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,
On Tue Nov 24, 2026 at 12:32 PM -03, Ivan Tverdokhleb wrote:
> Use `debug_assert!()` and `pr_warn_once!()` in
> `Vma::zap_vma_range()` to report invalid ranges.
>
> Signed-off-by: Ivan Tverdokhleb <mbkchelofficialdev@gmail.com>
> ---
> Changes in v2:
> - Drop the `warn_once!()` macro and its KUnit test.
> - Use `debug_assert!()` and `pr_warn_once!()` in `Vma::zap_vma_range()` a=
s suggested by Miguel.
>
>  rust/kernel/mm/virt.rs | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
> index 63eb730b0..1a3a990c9 100644
> --- a/rust/kernel/mm/virt.rs
> +++ b/rust/kernel/mm/virt.rs
> @@ -115,8 +115,9 @@ pub fn end(&self) -> usize {
>      #[inline]
>      pub fn zap_vma_range(&self, address: usize, size: usize) {
>          let (end, did_overflow) =3D address.overflowing_add(size);
> +        debug_assert!(!did_overflow && address >=3D self.start() && self=
.end() >=3D end);
>          if did_overflow || address < self.start() || self.end() < end {
> -            // TODO: call WARN_ONCE once Rust version of it is added
> +            crate::pr_warn_once!("Attempt to zap invalid VMA range\n");

I believe by the comment of Fujita [1], the `pr_warn_once!` should be
guarded by `#[cfg(CONFIG_DEBUG_VM)]`.

Regards,
Nicol=C3=A1s

[1] https://lore.kernel.org/rust-for-linux/20261124.225103.2152350984946270=
550.tomo@flapping.org/


