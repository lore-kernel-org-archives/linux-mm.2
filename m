Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31D6AC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 19:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E8746B0096; Mon, 24 Aug 2026 15:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C08A6B0099; Mon, 24 Aug 2026 15:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2846B009B; Mon, 24 Aug 2026 15:48:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD1DF6B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:48:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3CCF6160254
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:48:26 +0000 (UTC)
X-FDA: 85137199812.18.9B2EF52
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 60080A0003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:48:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ms40MnC4;
	spf=pass (imf25.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787600904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irfg0xHDxtBcVMGyL6ULAXhB1SaYDLc0s9Lgku2rCW8=;
	b=t9M5/+25W6vv1hZHR8r2ZNmWRwZfMlqHfuVLnIvtWi+o3m4ggtZZbMSZpv0QbAe/1whb8w
	yJYHLi6C50mWWCWwaQZZfYFdsJ/hRCCw2T59NNy231bCgDSBzXVmt7njjU9Eaj0CtZly3j
	eTsk4K2dm5IbBDvcQnNgYanGub/zWUk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787600904;
	b=oqASmCJug6HEFMkeFMejcqvLvL9YCkptleB8Ej0wnvctC4p6UAafKCPfoj69zHKSGpwG0k
	3nK7065EbmtHriy0rEXYOHIgqQfohLS3uzjX3NwlTGlHmj5Lj1T7Ds/G3KyhkzbPOv3ARQ
	b29d7PSMfuxQEf7cowJfhPTAbdtmbvA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ms40MnC4;
	spf=pass (imf25.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c1677c91969so479994266b.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787600903; x=1788205703; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=irfg0xHDxtBcVMGyL6ULAXhB1SaYDLc0s9Lgku2rCW8=;
        b=Ms40MnC4AAZgB3jG266oJ6rAYzH9CTFc3vXwHPqc995N3mmGyNkSvCLV2ytLiaSXyp
         DbhZOnM7jZWSo7viBcY17eEc6WmxQpqNpqm5zDn6c4IPn7/XsikFiycSbP8WuE16mtx5
         BBT6wUdxr1FhBwr5cAuJ7ISe+lKbazMgun7XXKQ535kKwFCBANHbsQxCJD8BPxr7aaAf
         i1Y/afUiH4TOiKOrX+acQmr/WiX008KhPsHlKxv772xrraqpmCQxUsD2aDhs95fve58f
         pxKDPSIKfoPgayyPsX9yFCwlW2y27/EACm9OatByWO1SFDjihzztrq0Y6yp+SzHXTNVZ
         nqQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787600903; x=1788205703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=irfg0xHDxtBcVMGyL6ULAXhB1SaYDLc0s9Lgku2rCW8=;
        b=PjAPBhC/hdU7dtUnG4+4G1Lt/CIWvUktkgsD/6DWWkc8oSeXmNjZrwtxI50R1Vl25F
         9rAilpTe8xNHH2oJbSQ/6dQdPzgucoadpcpKvW7vbkNvY6uf/vmLz9upZCOCtubieKwE
         aLfJEOwA+sNcK8wYvts5OwUUJVcniwW1O8xC8TOpDpaqYIEnV4CN/erM0ZBTMpijPNW7
         KeaiEx6xJ5E4isZSmdwBsWW1V0i7xBTcEI8olJbv3htn1L9x6CGLlYKcAlaSNAJh75QG
         3fIwc+FwOxDJvP+Ht0MJe1G10fWYsqJjk52SNu3gfrgAYNU3Uf74QYPkrRnZ1ZJGbeu7
         EQcw==
X-Forwarded-Encrypted: i=1; AHgh+RrKr+i/fvkTtAxPKllvzlGDqjvGaJBh0553L7DwDaiKYvFb4J0naVabQB6ishjGXpEqmx/6iZUrCA==@kvack.org
X-Gm-Message-State: AFuF++kjnMYf+dzkICpDFMS698qso5iPL37P/b3MfV0RKomie248ikD4
	OZjAV+9cVXCt3tziDbkDJ8+twvJm1FqGRlpsOjnwfhcdXpUtqKOT06ZQ
X-Gm-Gg: AR+sD10RTvzf0LK2Nnds2U57lx3qATijieg7CuNJneqp/9Scs1SwhTKV6+4Qqj1PTlJ
	oiZyKylzAGjOkGrsVDtq8IjaGXVnMvowgCBQonmzaeHK1RDmVcw+3hd3hkO3LyRjrzzYIwBjkVZ
	8q3SYHf0AzCGraXoz9w1Sfxj0HVQkRhQiUsnJ0UhMHkKOG4SqlBoRB2s3ASMmxl9RfIcrlIX5bR
	irrJoPcTKRBEwtQ9CUTftuHgvbOtSzUvkeZGBNaBlOOW1xXe+NftwMctdYQTAZ86gELUgDlXlY1
	nANtffGGWdgBbtHW8x0SyRDf4AJ54EDnt7Ucg0av0/G7b3L4KKCGz5Jm6ngx3QLc8MhcJX2XvK/
	yyHKAVIU2+WnJjgJsHrabkas2N43m4D/EF7DDap02C1mxlrR1vOdiBRM1TIx3NGf6ZLsj8U2A4o
	80aojvQxVoMlMvIAf0g5tM8wDI0GG8m6fFycOPQkoPyk/t6OCwmsHFCSEkZoORzsaZ/H1vvGxwB
	VAsp7jydUs7BrH3UBJc34cX6i5c2GNZj1T6QmMp6Hb3dDi3Siyt
X-Received: by 2002:a17:907:7a8e:b0:c16:9043:7973 with SMTP id a640c23a62f3a-c249257c10amr2243253266b.4.1787600902724;
        Mon, 24 Aug 2026 12:48:22 -0700 (PDT)
Received: from localhost.localdomain (46-138-191-2.dynamic.spd-mgts.ru. [46.138.191.2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24966f6ad2sm1426659766b.30.2026.08.24.12.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:48:22 -0700 (PDT)
From: Artem Lytkin <iprintercanon@gmail.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jann Horn <jannh@google.com>,
	Carlos Llamas <cmllamas@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Deborah Brouwer <deborah.brouwer@collabora.com>,
	linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] rust_binder: check ownership before using vma
Date: Mon, 24 Aug 2026 22:48:08 +0300
Message-ID: <20260824194808.216021-1-iprintercanon@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260218-binder-vma-check-v2-1-60f9d695a990@google.com>
References: <20260218-binder-vma-check-v2-1-60f9d695a990@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: bss5omobncqzhus1mwnun1j3dsmktmrs
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 60080A0003
X-HE-Tag: 1787600904-563288
X-HE-Meta: U2FsdGVkX18cHoMzOp+Pe32QR1vViPP0cSU/JIO5XiIOg2x/mRhkaA+ESsaOSE+Op4c4r5LNa9kp769UIG8I9pp8vF/7ydBDFK/KGKsCUcLl7VZfm3kxtOjrmrtvPoiQizQ133Lo/qqKyC+TjTO23UQprEgNCAFlhbaa2dG5NEozf0ZjM1Iqy0W/iXixmZ3IYBBWN4exz79K6yfgFvQ+PdLyF33S1pA1R4GQIx/um2ZA6x8S1pfloFwEhIy2AH3IiGWoRzFFs9uEuxL0I98rWWwteIF/CJfvMtwUwjyaYmMSF6/0hkNkjYdxkCXjNbS3+PYaoBpgXTfOVwEi1Bd8tMrw4LTZwqgnciQQvoI6BE9olklbdZStveADQkjLCt18GkAF653gYpHyxzWnJ1R1AnK/bGBpdllh/iFAig3ccCbISdA2KfGINs0qPP63Ex/4WsUgZ7wVDBk8oJt7tLLBjJQ1nnUUiAFVILjou4lMmKXWLk1PhEDRSJ+/hTsFbW2RZ3FgpmADkOpPleV4qYD9bKYfEexarZNTaFeVuwBUjpZOV31LlgJx6MhAcyfCa5yxt0jO7yBKb8BmQkdFnaQ5oFX4FTiGRdrCNq0i+9wSqzIB06YyC9fXzzBDfil8NqsV8msbUhuB/tpd0gAzxy9paip/hf2jLrpTNnnOcLL9PmQ4my3trJNbpQEnNouuLuKc7oyUa0vmZ5XLsjleseDdFTiY9oQWxn+h+6oW+deKpOtRfH4vYgyGLwDK8+/hBzcB5vWxp2nKXKgIAk2L7F6BtC57Ko5W5TbZcLsgSwt7Dm0EncwQmVeNIay1czZxXv3iCXIJRskKry0rqdwRNIu3S4X+otaRJUQEmZ+GgPrIAB55BHgYag0VsfWYbfpjKKaoODuWwyjHsSGzOJOEHqZo6GvVT9lmQ7/E5pSzIJYTf3/SJqqt+X777iAJw74MiqAbM2zkb43cuMD1ztu1Zw3
 7isk/BHo
 glTl3Idi2KbmYiM87G1HjgpaihhRvCizdI3hXx8sOi2Oq36O3xVpkJIBxj2iZc7fi0dnmnocEa7RpMIy19Jl4wr9nN7rv+5La4Ho7uQxvBBtCYWrYcI4JqDSQ0e42hwmEFYk6kSV5oPbmasH12S0x7BK2OLXrdEQAhsJ6Y697yzMGSoN5NPDpzylcdvTv50+2u8XHphBK+c/Cisqx6wfkIylj4ifLAbz20KH3yGe2XUsajMidm+9UbiEFyeRQeqD6FurliSGyYKtnVcGsFwjKl+8mDqh9JkMBIX6w27OZGr19Txo8+euiDE8oTsa2NctHKfWWxI/raoTqg+jm/Ui5plhTcwxQvD5C8MExK7xGaSKNLRx9KHv0tnpteugh7fEkFCZe/91a27V8k9oteR0p3kEOj09ZRs2iNHelDncsSx774l26c5Ifdfo43kjATr3ujP/Jea7LLkYMYnXpH9l2aOWwH49zYbIf9sw0Kf3JlUru28uET9wU368lEgtZ2u9caZd816jCIZ9cotu/ZN3hSCYIZqZQHsGzznJpvWt9CJUaOitrIM5rPfuekW942wOegLZp2aE6Iz9RyO1RB0RAH+uA4FPaNklV86HuZDY64bHLyvQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026, Alice Ryhl wrote:
> The plan is to introduce more vma
> abstractions to avoid this unsafe access to vm_ops and vm_private_data,
> but for now let's start with the simplest possible fix.
[...]
> (We probably still want to do both, but
> the vm_ops->close callback will be added later as part of the follow-up
> vma API changes.)

Alice, is that follow-up still on your list, or would you rather someone
else took it?

I'd like to add the missing pieces to kernel::mm::virt: a VmOperations
trait with open, close and fault, a typed way to install it together
with the private data on a VmaNew, a VmFault wrapper, and a PFN-map
typestate next to VmaMixedMap with vmf_insert_pfn_prot() on it. Binder
would then drop BINDER_VM_OPS and the raw vm_ops pointer compare and get
a close callback like the C driver has. Tyr needs the fault and PFN-map
half of that for its user MMIO mmap. The first two patches of
Collabora's Tyr series are the pgprot_noncached and pgoff helpers; they
have had no replies since 7 May, so I'd build on those rather than
duplicate them:

  https://lore.kernel.org/all/20260507-tyr-mmap-v1-0-eec048a23c25@collabora.com/

One design question first, for you and Lorenzo. f_op->mmap is
deprecated in favour of mmap_prepare, where a driver sets desc->vm_ops
instead of touching the vma, and the Rust side only has the old mmap
path today. Should the vm_ops abstraction be built around mmap_prepare
from the start, with a Rust mmap_prepare hook for miscdevice next to
it, or is landing it on the existing VmaNew an acceptable first step?

Artem

