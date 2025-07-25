Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 650AFC87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095E56B008A; Fri, 25 Jul 2025 12:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 046D16B0096; Fri, 25 Jul 2025 12:56:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77B66B0099; Fri, 25 Jul 2025 12:56:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D681E6B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:56:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 805201340AB
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:56:29 +0000 (UTC)
X-FDA: 83703390498.12.770A7E0
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id 87675180004
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:56:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=W0zRL7aU;
	spf=pass (imf24.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753462587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WtgAXG2zxYUZH6Gw9dzWRKSuSkjlPnsCAnmjzmjgcv8=;
	b=dlDEW6hK6Ue/huekKp1Au+cl1eXJE3euD159fN7RlBBJJEJIt2UD62YW7U5tKvd1KMQADH
	JSrQevqySdT1st3L0eJ3gpGOwxKv4b5/nLXsq1l2P1JLQPeGr5R26roQjdw7mWZc/+XCFT
	3S++IRvYBvWYH3f74Ach5FGjeBJxIhE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753462587; a=rsa-sha256;
	cv=none;
	b=6/MTMd5idWe9EjT9oLf5uJqAx09i8Rnh8uNvOxNh1ZzpMrdOQ5ZpNyXp06ncvXZgK00wxL
	tslB/trIpiDjgOQdFODmDbJB8ckWgYDI/KzHwB40Ui9Y4x+TPIFMgdlzbqm4yOqnJoZ9gd
	9N8HfzD00JIroyaHXi1W5HvDNJaPgF0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=W0zRL7aU;
	spf=pass (imf24.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-748f5a4a423so1738322b3a.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753462586; x=1754067386; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WtgAXG2zxYUZH6Gw9dzWRKSuSkjlPnsCAnmjzmjgcv8=;
        b=W0zRL7aUuIuAskE46pPtab9y7KoCp9AosDwsngRkYVLdkOPzkCWkzh3A6ibFXBUcQ7
         Uab1d6M+uTbc77RBx0iGMCVdynXQcx2XTnAzIbHve9LIY3EXe5IZlnYg1VPns6Bejs0I
         G+ucmfV4PVM5GCAzoNAyv5rcTdIjOvIzyjCHNIw8f7tIk3yYdspWn3aLZynH3AEuGdvQ
         jzQHOF8JngVlsYvBB9/iF7cjQBxalFiEhjZeRocrPWb/Kgie47P1vajDRP4S7fbd0Fpm
         h2Uh0Lr+SgSPTdDeGhXKbEMF52+XG6MHDAo4/mJ2YrdyN3s/jgTYXXWCsQWSFHvYZVQC
         fPkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753462586; x=1754067386;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WtgAXG2zxYUZH6Gw9dzWRKSuSkjlPnsCAnmjzmjgcv8=;
        b=tCmlw23sShsfiK+NQPHOjMmrsWc1bbUeoGk5w04TOZM92DeWR+m2jmlFdOP/z+euAu
         Vr366k17bh9LXVVyL2WtwNyDRLw7ARKhEJF9PVS8Js3rG8LGD3M1oHSxZS8Q0QHjZiOk
         4hAe32pc0znC2AxfsnpIr8A2hbBiRkorbzoG8n5NoQwscaDjRAfAaVe1jyFzLF1SGxFC
         Cxqwf2DOfBme96MqhJyw1jHj/YEZ3OWCOU/qkA21ElY2yCnbu3UmKayRIxTl5ERkyhLG
         MR5Gjg1LDOyb0m+KKDB00Sb4sEDW3wUwAqRkA9iBKCDfYGl/J2/mD8pdmbJTeHETqpb6
         0fIw==
X-Forwarded-Encrypted: i=1; AJvYcCXg79DOdGF7U4Q7/wyyKac2tjov5OcWwfHoZbe9ztvPuNbbcvn9ihT9KTGbNOF6LQ7tJjIphfDO4w==@kvack.org
X-Gm-Message-State: AOJu0Yy7Sta9ouwsnWqT1uv5bFGXbW/rYf8qeArbBjXsI2TkEzp59SWS
	hRVDOgv7k1ER/66vWDl3OGeCDChmyjMGwIn9TepTskuGi2JQdH8SPcf7Bz/ZXIr86v4=
X-Gm-Gg: ASbGnct5pr7YeXS1L+EY+E9OZWrw6doqAa5cWLo4CMuUDcBSt0WMqAoP6AQZ5zP7CnR
	xqpRTz/DBQeLyQbkw7IXLWWpLzevLV/ae33VUinUezyTU5CTW9U2cbHRUwLG6RLGBtKaRbc3lYu
	XsgyUlqD08M54jwxxtAx2UumM0Gyet0AVYHoAPE7U0R44ApURdZMx0QzM+T4EqXp2NbyrVS+oZ9
	SlhC/MbP7FmxjEC68Z571iZkpUXCByCCLxdKsPIAX5K0cFxk/3yWLUY7lBvxzcu/QcjIFes2FUS
	CXEbCe0c9N55pTV2SVwgNaijF2POZZbCynpGW7AQ7gbhYlMcv6x5hA9MarqpK+89EQy7dx63/ad
	KwZwazbWeJX2X4TvKUSzNjegiPq3jA6Mr19zUodZcykY=
X-Google-Smtp-Source: AGHT+IETBPZe8HlkltWjZZmkG8X/wqZoM335inOFOubYlGpOP3IUTPKQOC96UsFlPqNZzJonrdrGDQ==
X-Received: by 2002:a05:6a00:b50:b0:740:a023:5d60 with SMTP id d2e1a72fcca58-76335b7ef36mr4059760b3a.19.1753462586198;
        Fri, 25 Jul 2025 09:56:26 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f7f6d6312sm231084a12.62.2025.07.25.09.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 09:56:25 -0700 (PDT)
Date: Fri, 25 Jul 2025 09:56:22 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Monk Chiang <monk.chiang@sifive.com>,
	Kito Cheng <kito.cheng@sifive.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, rick.p.edgecombe@intel.com,
	broonie@kernel.org, cleger@rivosinc.com, apatel@ventanamicro.com,
	ajones@ventanamicro.com, conor.dooley@microchip.com,
	charlie@rivosinc.com, samuel.holland@sifive.com, bjorn@rivosinc.com,
	fweimer@redhat.com, jeffreyalaw@gmail.com,
	heinrich.schuchardt@canonical.com, andrew@sifive.com,
	ved@rivosinc.com
Subject: Re: [PATCH 02/11] riscv: update asm call site in `call_on_irq_stack`
 to setup correct label
Message-ID: <aIO3NtHJ1iCoGOs7@debug.ba.rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-2-04b8fa44c98c@rivosinc.com>
 <20250725153351.GB1724026@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250725153351.GB1724026@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 87675180004
X-Stat-Signature: ptwoq8bb1mo8wupfo91mfxtrf3n7yhsu
X-Rspam-User: 
X-HE-Tag: 1753462587-229023
X-HE-Meta: U2FsdGVkX19cdQpa5UefKOjS7tS2gCKUbBZ3bXcqdNjhMSmjrFhjTrJz9WS1FRJmmVYrfztKnDazKE6sAN+ZpowlWiJmvg/rZyCHvV4jbj6CZjC3UIhmrA1KqTseF5PQ80XM6j/bzSrYfv6ULPxZF3Zz+BGP6RwBAXKdFSx5tY/v+KC7RUAE+G40W02YTgpyz+Dbyzs6DC73vBLGEvsX3tMuaAf1z7iNEbx7iVxsicu1/xNnNHYU8xBLcJgpn3Y/RacUlc3BSYUkmSqiXRPI9xOhYuNSisNs0tqxyKY7VzxBNIxqbv06et+oWo1kJS4IK236ysWZkSoAa+FQlP9EDOi1HaBJgjK2PuMMtdJSQ5tPsM3HJsG8a5tq62owc52NoJ6aJSPmiY7FDk6H4QsPHSwNz1CQ/1ZFBkCfyCz+g6IF7qI8/KpVhEZa6qRUCkNx/vlUbbh7zseec2hTMiYRgQE2GzYPePAg9GYZa5LEejQwKdusOKrDeJhs8onbGyFgMXeE//7z/4fIFdMVzTAs9y/oUTERakZyX7n9FZJhOMjnGWabPbRyiShse9h5qLdsaodoxTYCD7YZpCaeeWYMBmQlI/0MD2xSyUEpOTyANd9U79zyyLD4BEwSs057+wOhYiBSMhhs1x2OsAd7/I7/xqVepH8LALYp/5fRJqjx93uhVDDYVfh2ZF30fNKcKRsEAW2ckq5Zzqv5HT6QS8scAIHNZMwQ+A+SLSOk2fDxG+dJvMd4FJ0oiFl4WgwXcvh4mH+WhVWL0gIbUibbqNOdEAVoRDA/rIa+8sBQt3NMzrqx0D/7wdSo8iNDSriTCu6mq4cz7G7YKEmwQatUnQ5c331EAte8En8SjZZ0ecoONNuCVQrpy3/4CTAVDjZY/BCBK+c5gCqoxl0fIHsfv7EXgHGyT96KMaBcQLijfaYbuNlfdB4h3crVeeFuX1b0J6i0WxC07QuKlKpBPVbQlb7
 OOU8VYlm
 /i4huKMXT3QhT5kGeUhAGYoz134F226kx266qaDggjkiswKS4vzNeLUtL/ye8alFC+dKYTR3L2J9bqWiWrExc+ojMW9fBfQbo/OS5QbvBpRyUKjoW2GMnRC085k10RxxKeFnJvU1uAPvOlE6R8Ra+iy3Wyrk13fWJyYefKCy2q3nfjH0iyY1s9ZZxyZFl789ImnmzGi8vQqOCokYcj19om+6gyNKEYilEtxjT4zjhjA2odk1d6TqgDVP6I5CsXvdHVC9ZhnMeeFP9Qg9PbCpnUWHOVsGpqw6iC7FgAVhSPFHI2j4/e2siv6nPFwaomAHjJTzpqzmOC/pzU45QDsQxqOPjpR82SLMbhdeu8pYBDI/yrkU5/8K6Rp5ZXWpkaxQT+AB6heRGsoV8QnZdmLNfWhRAT4vypCp1fs1XtL7YGYly/J+xjIUBG1HkUxPRPayj541MjDO+zGKyAHg+z5mlmmRHeEhaJdNjdHkNOdI7y220Fn+4YDMiBcSK1eeZpP4MYmQNCZndXRO11CKUjG+AzKRjY2lNsB8bwdcm9WNlVddTmzntIuKCg1dMElsH6804KM2r6QvTwA+7obk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 03:33:51PM +0000, Sami Tolvanen wrote:
>On Thu, Jul 24, 2025 at 04:36:55PM -0700, Deepak Gupta wrote:
>> Call sites written in asm performing indirect call, they need to setup
>> label register (t2/x7) with correct label.
>>
>> Currently first kernel was compiled with `-save-temps` option and
>> normalized function signature string is captured and then placed at the
>> asm callsite.
>>
>> TODO: to write a macro wrapper with toolchain support.
>>
>> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>> ---
>>  arch/riscv/kernel/entry.S | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
>> index 2660faf52232..598e17e800ae 100644
>> --- a/arch/riscv/kernel/entry.S
>> +++ b/arch/riscv/kernel/entry.S
>> @@ -389,6 +389,7 @@ SYM_FUNC_START(call_on_irq_stack)
>>  	load_per_cpu t0, irq_stack_ptr, t1
>>  	li	t1, IRQ_STACK_SIZE
>>  	add	sp, t0, t1
>> +	lui t2, %lpad_hash("FvP7pt_regsE")
>
>Ah, I see. The plan is to hardcode the signatures in assembly code and
>keep them manually in sync with C code. When we implemented KCFI, we
>thought this would become extremely tedious to maintain after a while.

This is extremely tedious and not maintainable and primary reason (among
other secondary ones) to keep this patch series as RFC.

>Do you have any plans to add KCFI-style __kcfi_typeid_<function> symbols
>that would allow labels to be determined from C type signatures instead?

Yes something on similar lines. I have asked toolchain folks (Monk and Kito)
on how best to support this.

>
>Sami

