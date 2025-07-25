Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB9AC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 14:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A92A6B0088; Fri, 25 Jul 2025 10:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77F6F6B0089; Fri, 25 Jul 2025 10:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695676B0095; Fri, 25 Jul 2025 10:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B2036B0088
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:16:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E11E61DBD77
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:16:22 +0000 (UTC)
X-FDA: 83702987004.09.3C96E78
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id D93F51A0017
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:16:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=jPMyvPrD;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753452981; a=rsa-sha256;
	cv=none;
	b=xiPGEXX2Pc1KGggeIQvF8WOKVpTflv7yvCmnc6vigp7LKcr+iPZwKI1WArRUFCta3Itg/b
	gbIPSe63CT9/aIldnGL3r/055A0rfbjHnKsp8Jx6X413S24EYqmMVvpgMi+zMs8JxuqDCR
	LreL+4+Mkf0OEYrmKP9KRt8OR0ugO44=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=jPMyvPrD;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753452981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m4zb8NrY5OXi5r9Et0ByFU2sSCQJb+4fxBPaABm8ZNI=;
	b=se8YGo7xriSHkOc9OKQurGI7fgTid1NMjAd2zV141JfPsKWHRkYsl/KXvuF0OhUaFMsLnW
	9b5vacyQIxja0yiO663QJpEpEDLXW6Ql9yeerlgrFxEGdxBms3RfOuE8OZRlerKzyG3Glg
	hv5wTF+boWa0SGSkwgU0HNddYBPyUk4=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-23dea2e01e4so27986475ad.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753452980; x=1754057780; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m4zb8NrY5OXi5r9Et0ByFU2sSCQJb+4fxBPaABm8ZNI=;
        b=jPMyvPrD08Eb6VHv60xf7aOTD5CcDRaW0ytJoaGTLUOraT9IRmCKniuoHVT1yfYRa8
         f6/6QTDFVc8WSsG3GxsjiZVLH3Vmo5yii/O7gbqOQpyn1ECiIR52NjiDzMcSOP5Wdv3R
         qPYp7GvaWA932kvQy/p3VNi4BBqLrdP+xXUuBcTbw5YU+jze7sDXyPSENAyuLZPXgYYA
         Nbfv75088dXAUyhCoBkLc16xhC5UDmtQ+q+zAFU3GDah1Rdpoeard2A+ph84vx08pcWz
         r9I7RtPfRppi9hOWYBeZCk7/Fj7sPdJREXgyfUQuv4fyhMM0LDalJMUZ470ef6r5EhX0
         XIWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753452980; x=1754057780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m4zb8NrY5OXi5r9Et0ByFU2sSCQJb+4fxBPaABm8ZNI=;
        b=BymSEYzx6nQXZZBdpa2IZwCbQD5xGLNFiZLoTY7Wg3eLOPddedbeoqF6JAqTd/QM6r
         1bDHIZ6ofIKfjUer31jBtgoC9XDZSuRYwGj928eU8DG4/6/eX8W8C9usiVrf4NVTLGRM
         bp5mm/0Sttp7qf91xUCFkYnP9COnfjeGqFg3F+/nImlxt2YI7n8+1bd11lpcu5u1Pjk3
         9Qm1KvU9ze//lmtQGZSV7Y4N310OkSiAISLndRkvQCq3XZROSNay0szaGNnKWyN767b3
         NyBsws2vZ+7BjrTnIway992dvO+NQQ8Z3NOT0NXpkyFMLGyrojXBpIq0mtlUxdPDvIuy
         XvvA==
X-Forwarded-Encrypted: i=1; AJvYcCXj0qptDoNjcNIKcsyHJ2ZsH37NUCfXaBLmJV6vNsTCpJrNktn1fcG2bBH0el88ii/DQzuDHXssQA==@kvack.org
X-Gm-Message-State: AOJu0YyljJ1vxL9meGd2qP/ME5v1bH8sZruxULoKr1U4Lnn65H7WhlSe
	n19Xo1iMIAlzjtgz4OxOzBdNGIivM41gBWfCK7Dcdl0caWcmZfWiHW0xgOtRFX42Z67T8N8CEVu
	FK5JY
X-Gm-Gg: ASbGncu7caY9M/vcGVP2OIVEKjo+guQfd/HVUy9HbMUs9N6lodOlfJKnzFA8FI71NQB
	pgy0o3NakUktvCqAMNvK3CDxzvqYtXjUNZdDj5Bql0AK8mAS6OzrcpE6N0w3MOyr6AQSBejuAou
	+PmG01lw+eJ5R/7fPQpm6OnQlrmbq5hTabRcsOotkOr9M1fpzk7UNTGKSRlmbHo+2AoNRtebtIQ
	qs1dzg0Je75n5wh+6v57ecLbRht0Z3U5TDfPZ1ot23uQ9oLWlo6V4j5gy+EQd3s5ngold9qfUh1
	2Z2tbJrsqQClsRetjXUmUcI8mov+Un7kaaO1k6KyeLF5K9nA6pCq5zBzHsUWTajJ19LRNl6DuTP
	W2TGRreOMojN+OQdQ0OZaPeXWiGtVj5nE
X-Google-Smtp-Source: AGHT+IE9XuwrXVXrIfvlI3DBKUdukDNvmbxm+Ndq+/QyLjAd0FPi4mKe09kh/NBw/3BKfUdqYZtXMQ==
X-Received: by 2002:a17:902:e5cc:b0:234:eb6:a35d with SMTP id d9443c01a7336-23fb30acdedmr35114765ad.27.1753452979529;
        Fri, 25 Jul 2025 07:16:19 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa491bb2asm38450025ad.213.2025.07.25.07.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 07:16:19 -0700 (PDT)
Date: Fri, 25 Jul 2025 07:16:15 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, rick.p.edgecombe@intel.com,
	broonie@kernel.org, cleger@rivosinc.com, samitolvanen@google.com,
	apatel@ventanamicro.com, ajones@ventanamicro.com,
	conor.dooley@microchip.com, charlie@rivosinc.com,
	samuel.holland@sifive.com, bjorn@rivosinc.com, fweimer@redhat.com,
	jeffreyalaw@gmail.com, andrew@sifive.com, ved@rivosinc.com,
	Paul Walmsley <paul.walmsley@sifive.com>,
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
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH 02/11] riscv: update asm call site in `call_on_irq_stack`
 to setup correct label
Message-ID: <aIORr7mQSbV8QMCq@debug.ba.rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-2-04b8fa44c98c@rivosinc.com>
 <4ad699fc-a89d-4740-bdec-ecb9a2134c90@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4ad699fc-a89d-4740-bdec-ecb9a2134c90@canonical.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D93F51A0017
X-Stat-Signature: wzjq4psdg7phbf6p5z7i1g3cr5qxkx89
X-HE-Tag: 1753452980-866705
X-HE-Meta: U2FsdGVkX1+j0uZumhgOBQbwco1XKUX+R+WVA2e78yk7TuRLu/9x6sxHUjdFW75w4D7VkrkCn6iM4fEZ4OAD4LRy21yrpdcpPKeNtzVpSQuz2Kq+tsiy2/tn7CuB/7M/CzbtSxx4QQJGSisNkkZm9ebPs/BvWkaEcATsxKmCXFO0HNOS1dtN8WCpFlmCKn41QPP3HVP4GAPejVE/QxfK3obyN98PvISYP5sIyMqXzXDUUuPSOZnaveSX2GuYYa+oba5OO2fCvzgoYY/XqgGtsSHtBhXMcOG/khRKEdlUxyddZrAf7KS7kbZyd+lG2OfciTiq2G4RHRB8fvYrBbs5gsLZjn9+SrfTHICYhwXHiLK/UEfMOySd6OpvZ1E0nRxjwGmKDG7jgipPf+K+PfygCHGRXdD3EgMOhcE2RqJGD4T2GaWR72jWd/hknnoaOIzmOu0CA0akg5f4Y2SwOGOf5/taHFm4JP/3KY5cp5rav0PZiUEg0KxU1YvW/c3G+8p0FXInj5Cc2WnmW86yNIQ05MFeM2G6/6VMMjZuRzguxCZEdNXEOJEg5wKiLCXNDfiifTxTZHUEIq9Xu/ipujWYVkKpr4DQ1EQual9ePi0nNDKInu33DPrCudp9cgOQX1tGjY249UxvLrjMdJfwqnoDqAGhJyU4Eacepsv+NNaN0GAkKYcDPOPZMUyjfA9MdmnToFVNk8nivzPRs9EoCUvS3gGqCRfI7UU7HoE4/4tUJj+R+VlwlKkuL4A7eOExByh/XO+6ukjiNGvOKWLgUj0+JDcCRtYxkHqKfD748rJOjZAkGpGogtmjG9JAu+Ha26RjOtjEobOjQq7GGnI6eT7zmKvh0f9e6fsKza01HhydOaIPBXgtYusRO9NCa2Mvc2HtRV9qy8w8/IeuXleTiq+twOhpWsAQrB3vvF+JN86cOvZs3x/nTAClMDCyLh8rO7zUi8VL0nZEsBvjtk03A0J
 XVIXvp9f
 z/KPI58jjtwAnD3JJeBMEUrNWoaFeH3r6RgimAR9ilM6VcyUOHxxXh7CijSXhc0qeuHccTgUiBxCF8XrO9kUPBJr51Tr0IirM+d0Rw16iGDYsF1dfyIz6kHx0bvVIUvt/mcxbM1ZuDaEaWVezRMb6WF6r4mJXQ3iDoKJXd4I6jidM96sL6dGB3x146NYv7j3UX0BwKLIPO4dP64lzahKYjqBMh8RzpAemdBcj73OKi1/kQo8W2Pw9bF5gmK5wrHJNtESAa3jTp4cGFGe5dcNEjNq/hMDATbV2LkfKfXjSl/+C9Ld5l3NZG6Y/YM30nHnmQ8AQEIHhBC2aeWtPKDs7/aadA3mes5Ol+gsC/x+1zxeokcmIXB+juCjz8wvEd/aKGiA9XwRHdNQJ7N49GfsMWMJtp9QWLjXzjZOE1eoerfd1RJaf9WQ41q0TMemSQzMI14dNsVUlH1w8GZL6559+U4HclJIH5zRd94WyP1NMDWyv0kJUb5r/BKBLRKfstOaD0Vw1gLq5MeGB2PW7+LMmro+ayPGc/yGefyMG94M0G18ARIIE/9Sz1zD2+QRZ2LCzqfxnE/TCuVI1e6M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 08:23:44AM +0200, Heinrich Schuchardt wrote:
>On 25.07.25 01:36, Deepak Gupta wrote:
>>Call sites written in asm performing indirect call, they need to setup
>>label register (t2/x7) with correct label.
>>
>>Currently first kernel was compiled with `-save-temps` option and
>>normalized function signature string is captured and then placed at the
>>asm callsite.
>>
>>TODO: to write a macro wrapper with toolchain support.
>>
>>Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>>---
>>  arch/riscv/kernel/entry.S | 1 +
>>  1 file changed, 1 insertion(+)
>>
>>diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
>>index 2660faf52232..598e17e800ae 100644
>>--- a/arch/riscv/kernel/entry.S
>>+++ b/arch/riscv/kernel/entry.S
>>@@ -389,6 +389,7 @@ SYM_FUNC_START(call_on_irq_stack)
>>  	load_per_cpu t0, irq_stack_ptr, t1
>>  	li	t1, IRQ_STACK_SIZE
>>  	add	sp, t0, t1
>>+	lui t2, %lpad_hash("FvP7pt_regsE")
>
>In patch 1 you use lpad 0 due to missing tool support for signature hashing.
>
>Wouldn't it be preferable to have a first patch series introducing 
>landing pad support with lpad 0 and once tool support for signature 
>hashing has landed create a second patch series using tags?
>
>Such a first patch series would not have to be an RFC but might be 
>merged soon.

It's mostly about security guarantees. Coarser grained cfi (only landing pad)
has been proved many times not that effective. Kernel is a monolithic piece of
code. If there is a good chance of adoption anywhere for labeled landing pads,
its kernel. If it becomes a long pole, it's a possible direction to go back to
unlabeled landing pad.

>
>Best regards
>
>Heinrich
>
>>  	jalr	a1
>>  	/* Switch back to the thread shadow call stack */
>>
>

