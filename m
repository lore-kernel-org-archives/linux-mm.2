Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DAFCC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 06:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 803738E0002; Fri, 25 Jul 2025 02:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3C28E0001; Fri, 25 Jul 2025 02:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2D98E0002; Fri, 25 Jul 2025 02:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 591FB8E0001
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:23:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F2F559EE2
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:23:53 +0000 (UTC)
X-FDA: 83701796346.16.436C379
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by imf17.hostedemail.com (Postfix) with ESMTP id A0E5A40004
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:23:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20210705 header.b=KJBxipd7;
	spf=pass (imf17.hostedemail.com: domain of heinrich.schuchardt@canonical.com designates 185.125.188.122 as permitted sender) smtp.mailfrom=heinrich.schuchardt@canonical.com;
	dmarc=pass (policy=none) header.from=canonical.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753424631; a=rsa-sha256;
	cv=none;
	b=g8r2+ekXlRR9eml+/nn3IzqMfieqdVPDe3vgxVFZguguryRo6w0GIc9B9drsAspPzXKVCC
	Bg5VfZ+e2SugT6SkkrFRGvGvAdWsuyUJsjLsuRr4St0+gwUWB3jTrFrUotBzhPdtrtXuHw
	oYFTpGjKPxec55nkF9FGggnlljc+zLA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20210705 header.b=KJBxipd7;
	spf=pass (imf17.hostedemail.com: domain of heinrich.schuchardt@canonical.com designates 185.125.188.122 as permitted sender) smtp.mailfrom=heinrich.schuchardt@canonical.com;
	dmarc=pass (policy=none) header.from=canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753424631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yY/SYQrNWX8OlVsdlpiMi286zoK+AXS6J+gjgGy9bGo=;
	b=75UN/7XGoBQ0uIczmlcdUT4Zc1tZfk/0ogZP3ab9epY2Lnjzxh/CF36Al3TEQXr6jVJNom
	Uq+Zi00ZejPPY42lzVPXmOvRGn5Z2TS0SeFP9hYwnbtMq5oXv1f2jlwDS0kADasaEt3YAy
	6+XViJogTS4+At+B96acQbJBr27Wm3w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 7F3F83FE88
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1753424628;
	bh=yY/SYQrNWX8OlVsdlpiMi286zoK+AXS6J+gjgGy9bGo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=KJBxipd7Ok3pTZP515xFxl1IqDlys0htEUqIsYbdSRS39m/Px3R63Thm0IeUdcNpR
	 0E8gtwpkwkmt9k0euiG1LyN5hMr0I7kXFJhvV3Fj8rAMZLROVHa2s865pE/fjUY5GB
	 IMhHCKGciGqs8XqaJrQXmO1T/l5xeNV0JZbuOfmyBaUooHmmuC5HvavdvsmnR71TW/
	 LbL8VGh/xmt80fQIPxEoOyqDNQU2WxLa8NanJfQHOu+BW8t7ksBUR8LKOesxIXvqY0
	 dCLYOlsw31pOHlfRTqUUqh2YTelgitVdpLUb3hx8V0tA6wD5Sjm0cy/n4LbanhY3fr
	 Un7nyrDE5yjdg==
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-455e9daab1cso3359525e9.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:23:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753424628; x=1754029428;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yY/SYQrNWX8OlVsdlpiMi286zoK+AXS6J+gjgGy9bGo=;
        b=AKoVHiLLYKSyiQAn8g53IZDt2DPTP+LN+iHE35ZBFZEMCiybdrhEkwarwqIfTIQjc1
         AIOJQxD3wVQ9CdziemW9pCCqgTG2iZ+7ycDw8t0Cu/FCzZufuZVuXw0l8QsYg8SUAYVA
         VZUjDdOkylafSL9a0tZfY19zsF7Ia93UfH3gc61RcCS9FRukYNrkbvml7yFe8Gw2O3Gt
         xbupYAFT60PeiTPmN2raJ4EWpHDEk5cLo1jkNGWO/bdLNBViPy5bvG+gKzD8sKW7ya0w
         WC2MlK9crUm9e8a1doOI7phMlMTztz4kcCJj6BlcOw1b5Se1DdWkNC/LNYOJGnoWEllr
         TH2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVRE8utNrdmU9upVBxyLBBEzErNrRq7srlObyYyPDJqHECJZ0uUpF4Wi5HTc4UgzqduldYsRuzKeQ==@kvack.org
X-Gm-Message-State: AOJu0YwXvJVFyOR+rDbQtJchszN68BKMTn7XD+eEbFnL+x7c+/6paWei
	22JaQiwMO2ZFq2Qr/RQQXrAx+xSCEEckZHY1trPf/xa1cj77k00k9+1zcej2//R0RvHaqyJGt6D
	uoRocsa+LKc0ZAqGFk/UyVYS1i+2H3uMJa6x5ZF/cFQAFUPjwPwW53TuGEVUzAqEmDkOb
X-Gm-Gg: ASbGncts7m14oxqEIiS6BSsTcTgbcrllvLt+stxZvu96ZwJHBJ0ojL6qlp7ysHtbvMH
	iSoHEiQ5+6reXIf2vWKRuf4b6E3sdgbIRs4Y+WDY53swS5oT3SJ2V0sK45KV+n9AlnHVTs3iado
	rufuA1L4pPrinVbvVLA2ooiqt9L1YbhRNjat/w9RfbcFTpqmFfj12Zm6z81B3galVMde85a78Dz
	cddCcLn/Eqc4OicIy4rTODlAGSPOmlqTE03S0lkHaBj+5NLTgYeXE5nwj1fXdv0NveTCSRYNAjL
	vGpmAwtbW/Srer1rfJt98yPG55IbsmayrtfuKZgboAGvKh4NbglELVVcBn9aNBVo2DZTXdtCy4k
	UxtDIbQGIyH3MByMPGicJx4xUeOLQCUtnd6V2
X-Received: by 2002:a05:6000:2306:b0:3a5:527b:64c6 with SMTP id ffacd0b85a97d-3b7765e57c8mr626017f8f.1.1753424627759;
        Thu, 24 Jul 2025 23:23:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1tfqV/uoCrIpUQ7zCYW6YsO9mWdhr+kRfUXgDIjxIPForORsIR9T6UJpoi3QB0+gQ5qNtNA==
X-Received: by 2002:a05:6000:2306:b0:3a5:527b:64c6 with SMTP id ffacd0b85a97d-3b7765e57c8mr625975f8f.1.1753424627337;
        Thu, 24 Jul 2025 23:23:47 -0700 (PDT)
Received: from [192.168.123.154] (ip-005-147-080-091.um06.pools.vodafone-ip.de. [5.147.80.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fcace8csm4135036f8f.54.2025.07.24.23.23.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 23:23:46 -0700 (PDT)
Message-ID: <4ad699fc-a89d-4740-bdec-ecb9a2134c90@canonical.com>
Date: Fri, 25 Jul 2025 08:23:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/11] riscv: update asm call site in `call_on_irq_stack`
 to setup correct label
To: Deepak Gupta <debug@rivosinc.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev,
 rick.p.edgecombe@intel.com, broonie@kernel.org, cleger@rivosinc.com,
 samitolvanen@google.com, apatel@ventanamicro.com, ajones@ventanamicro.com,
 conor.dooley@microchip.com, charlie@rivosinc.com, samuel.holland@sifive.com,
 bjorn@rivosinc.com, fweimer@redhat.com, jeffreyalaw@gmail.com,
 andrew@sifive.com, ved@rivosinc.com, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Masahiro Yamada <masahiroy@kernel.org>, Nathan Chancellor
 <nathan@kernel.org>, Nicolas Schier <nicolas.schier@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Monk Chiang <monk.chiang@sifive.com>,
 Kito Cheng <kito.cheng@sifive.com>, Justin Stitt <justinstitt@google.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-2-04b8fa44c98c@rivosinc.com>
Content-Language: en-US
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
In-Reply-To: <20250724-riscv_kcfi-v1-2-04b8fa44c98c@rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A0E5A40004
X-Stat-Signature: qakkuj83nj8x7rwcdcrzt8xwfibdwd8z
X-HE-Tag: 1753424630-426269
X-HE-Meta: U2FsdGVkX19xaX2MT5/MERikonZbP6NhTWj2F20UpK6+JU3QxmfsZb7JMRME4eNHEUxkfRbxnyGbkbkn9D3mA5sVoTEzBYwkgOXDSNMrkIfV5lP4lfh2ehgMSI85hAZI/Y365ibRm7iPtqdL+CARiw0a/JyMN0dkIALk5uNpMFovtlqrekAS60azVJ3IEsU8WB9eYIeuVyJ6xShQJKNpK6PB3SzrbTSsYoXi0L7pwQ/nEPfABxw7D71kiLFax1hJUuMjxgyAD+401XGld9/WX+Sa0zubot5A/PanH9PPyyE9RGNyp8BkSUM47DerzOhPALlLxxE0vXcnlCU0yFfQz8fQr30D34BA1bOFAFVMllJaQHtKJjL+8OuVlvydwNWqAQWZ6dhKuVMsWHLaqKjZVG84HQMfJ/JaNbH7wrAetBp5l/qaAUG8vV6oyc7rjvtikDt0rZifHL6B8Clczcasv69p0w3zwWTeAaAKuVd5U00IAM6/SETf/xBen9ooAq23xRjY0WUoy90FIvNkXBiJ01fFcGzp0ZX3p1txSB4YtiEcoCY6WgUSrsdqW90HN2Q6rxhp9vxg59WFt3q7kOky6EDUQSjB2lFM79LH0deP5H5LhzMcviqvWEwB54ICs9yEBCs41TdIcihmhJMqaKKSJ0yELssuia53Z0zdWmicii0SqhTF7i5MSrcvO1+CkGe/5BEUxqVSumSK3eT2+/U/j+2NSYFopTI3gPP7um8tvvGcuJ7dBmcCZeaCqBHi6do8r9hz/cn4RkQ0UvMQEkFBgMFs1fjMkpSnXnwqugzuRd+pHhiAhtj3JJXVGaM0jGN5X6BRFGTcpokz3cC1pOD6sYj3RBSfvpzV9KQ6CK9eVvxvTOWuXdYfoblQ9x0PdSNOfx1IFCWnQJmD0Pf+HoG2T8kyY0dI55ZVKDab8yG3/9kcXmsjAXN7N4ZwXIX2yMwy7eWJChoayGIIA3fS3zx
 DmL8CBSx
 bjz6kRjSPy1WoCSD8tgo2NS2Ud2SI4js6EHnd3yOVSs5cSCxwkwZ/tnbUKSnEjE1RUjI+WuyMXo0fPFEClloWvvIY1OFuoV0hTa/+9hvgYYToF0sixqH2Ne0KW8ZlDIBBoLCOo5vQTo85Mtihi6C9czBG+iQwZc2eG2fnTC2lTwWT5oC5xg4/sKGbKo/H7iJT1nLcdVGtmgPqHImbqZVIQfyzimwHxxNlMbEwFMs8u/YFNB2yto2lXeLXB61bddAkYB7qa9VzXdTKCT6IhBci1iS3hXxTHE16XI/hoMzxK+PND3bYCBZnkKsn7tDyeTyheufxPk/efWGQV4l6A1yAPP4O5/tActGrZa8cPFoDZ4M/gKfYNziXIyqKzk/DC/uhiew5SrtzyPQGb0M/yCS7Ap7xSR95tY+l2titqUBwfOg2aOGokc0E2dS2xR9XAKC0OpOap7MVye0s5wwxPerbJ1muWdKsyQ90gL2UXLq6vb27bbzrWK/tVkZY12nfFRQ7Wt9H5JB1anTzIVk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.07.25 01:36, Deepak Gupta wrote:
> Call sites written in asm performing indirect call, they need to setup
> label register (t2/x7) with correct label.
> 
> Currently first kernel was compiled with `-save-temps` option and
> normalized function signature string is captured and then placed at the
> asm callsite.
> 
> TODO: to write a macro wrapper with toolchain support.
> 
> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
> ---
>   arch/riscv/kernel/entry.S | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
> index 2660faf52232..598e17e800ae 100644
> --- a/arch/riscv/kernel/entry.S
> +++ b/arch/riscv/kernel/entry.S
> @@ -389,6 +389,7 @@ SYM_FUNC_START(call_on_irq_stack)
>   	load_per_cpu t0, irq_stack_ptr, t1
>   	li	t1, IRQ_STACK_SIZE
>   	add	sp, t0, t1
> +	lui t2, %lpad_hash("FvP7pt_regsE")

In patch 1 you use lpad 0 due to missing tool support for signature hashing.

Wouldn't it be preferable to have a first patch series introducing 
landing pad support with lpad 0 and once tool support for signature 
hashing has landed create a second patch series using tags?

Such a first patch series would not have to be an RFC but might be 
merged soon.

Best regards

Heinrich

>   	jalr	a1
>   
>   	/* Switch back to the thread shadow call stack */
> 


