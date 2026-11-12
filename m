Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A113606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Rohe6mlN
Received: by kanga.kvack.org (Postfix)
	id A3DAA6B00EF; Thu, 12 Nov 2026 07:02:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A15BF6B05B4; Thu, 12 Nov 2026 07:02:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 904FB6B05BE; Thu, 12 Nov 2026 07:02:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71A506B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:02:56 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F0CBA12057D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:02:55 +0000 (UTC)
X-FDA: 85426330710.06.C9616E9
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id 15F49180004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:02:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Rohe6mlN;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794484974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4QOZ/ziloNp1YzjgE4+Apo8LJ81vNJIp5Lxxwu3DGk=;
	b=bpY8x0wZp60kSbUJQSbcCWboaxkU+deFW43vx4bZb1oD4aYbeNmNe/6RzHtTL31WUpGsfJ
	hE5dlqBOz7CIAqDZ45FqX/Jx/a4yHHpjcX9H76o7bg7cWkWC/TszYwKJSTcHCFgzHUInQo
	Amb1BXK22yEZfePu6xl3Ky9NGrA46P4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794484974;
	b=jShjpZskBGAjBB1zJJMIrgLo9aUAV4CCXCEYfB3VH2huuNYbtSJJD2X96h3+H7j/+sjtTK
	Spf5xDfOl/yXjVrNkhA7PHNel8O5MiaRNsuhBkSfNH1/5Ru3bD7WR2ia4alWenawmEav8T
	kiBSpJo7T/irwtP0baRI7l510uhjOJA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Rohe6mlN;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4922523d1afso2504549f8f.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794484972; x=1795089772; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f4QOZ/ziloNp1YzjgE4+Apo8LJ81vNJIp5Lxxwu3DGk=;
        b=Rohe6mlNlUVYH80vgAyzoLjO984FTpw1/TaNfVv6XBvctVtt4LCN0WsBSiKuVt9Bp2
         Fceoa9UOTELhHZmN8WwTH8AEy9l9uJU1PU+JbJ8/ukQqhs3uMnFVI7ExKXcwssLDHKgZ
         zW3yj6ZGgc1edkK7H8BcEmfgz6Ua6o4ysqj6UVMsCkHXR53dVsj4qBQOFysCTEjpxeJg
         L67MGzVVVP2JweAOH+LQvl4+ai7GIONKe+4eqTXw0p2Ando2ICMiJLs9QWvn4wOLghsd
         B2m/Ev7XhEMXdEybO+3NDZ+3M0jhMOJNsGcPy/SiFICieKlNrBKpboJqEsF3+hEdXMm9
         KQmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794484972; x=1795089772;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f4QOZ/ziloNp1YzjgE4+Apo8LJ81vNJIp5Lxxwu3DGk=;
        b=GCiCZv4taxnO1BTIRl3pJgtM+tHuOORW52ds752lH7949GAFLwGmPdkNkBWVhJ+Aco
         MeX+fWO7mJ9y6QllxSopFkwx9fRG5g07s7Ff3ovfavGaxIs7P2/X6Rb0wVcqJHACq3k3
         Uk4i3pX5TQO1YiZJsGXUnscn1exvywruzEcrZOs2WikFAZbdzpI18Bjs47sLZezTRc4O
         65gciorCNZgls5mfrsZ8q9F21axhOv8vsH3v4vVdOPXxt0MA8VlVDJgr9MzsO45XKJ8N
         xJfPJ6a827idlCJGVdhNlWTMqjMT/m1+SMEXQa8gSA9z5kBaQp1BqeV5AlD0lKtuQqZN
         UaDA==
X-Forwarded-Encrypted: i=1; AL+hErESyt+qRHOpRQY4YJymThLZ/1stlmi9q4S2OV+MQ6Fq/1E6efFQ485OxL0L6U//+06CytQ4Yc2brA==@kvack.org
X-Gm-Message-State: APuU4Z/rDPCuH1ZreuRQpyYbCvMhCmNU12S3jsUoHQoxFPLaYXMKN1Ad
	oyjmSSS/FNyXZWlyDWYLtl/ltlfJ8Ka76RKpzZFVmfL3PJfX5KaM8FPt
X-Gm-Gg: AYBFou0aWy4vthLbAoj5LhfDj2W7kEcESV8JxFAQAkZOrafs5Dbaj0NquSlmrWyvGV2
	t44oz8CukIPPzJR7UMSgYk7hVmgQDXtEaGfVuPNZOzYrvpTXHWPRRqSiHI8Za2XwEnm+Ap27Dkb
	tE10Mi+wdS3ny8OrsGZzjclxp4U/h4dtEAm+MyzYlVcO0wQedFV8YL0GD8OeDYkusODJyGCx8WC
	wxjAZwuG0N6nj2G3MJtRm0QLRB+hnPltAkER6LPdPCDRVF6e/DloRzSaJL7ByFOusL3ej4cZFnA
	Q73HAmivgbsAfbzE4HfjF/IjPWqU19XkwKzNPSXRdSAV6gqxUSBlOSmKjsNQCnwQNui3i+h5DtM
	Xd4xVU4rjJbjGziuG7xjxDqjkxLL9TztHtaeTNq6G0/hUTn9fabxpPv72F5mFLW9M9jGVq3tX6G
	wXlddHZXtwk/5/7rVnWDLmnpKHQ1ma7Jd0AMy5+q2j3Wyu0OukTuMH0Rk4pIVps7zJDvAbfPhSS
	Xce0JUuE5kQyP0WxGowBMbce3m+fjPlmJ+GzeuV7H6v3SuPBYGfTmW2XU4Sx44kji+SrW0obo9X
	kRNIcWEviezCRynQRgwQ/D8VmeuSLe4pMNLUx/DUg3i8imHzCfUWJ70meYWmcH1j9g==
X-Received: by 2002:a05:6000:460b:b0:491:1e3f:a427 with SMTP id ffacd0b85a97d-499c898168fmr8711941f8f.42.1794484971757;
        Thu, 12 Nov 2026 04:02:51 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498367ba82csm16541261f8f.50.2026.11.12.04.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:02:51 -0800 (PST)
Date: Thu, 12 Nov 2026 12:02:48 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 alex@ghiti.fr, dennis@kernel.org, tj@kernel.org, cl@gentwo.org,
 oleg@redhat.com, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 eddyz87@gmail.com, memxor@gmail.com, martin.lau@linux.dev, song@kernel.org,
 yonghong.song@linux.dev, jolsa@kernel.org, emil@etsalapatis.com,
 ihor.solodrai@linux.dev, bjorn@kernel.org, pulehui@huawei.com,
 puranjay@kernel.org, broonie@kernel.org, dave@stgolabs.net,
 jszhang@kernel.org, tglx@kernel.org, conor.dooley@microchip.com,
 thuth@redhat.com, ajones@ventanamicro.com, ben.dooks@codethink.co.uk,
 rkrcmar@ventanamicro.com, samuel.holland@sifive.com, zong.li@sifive.com,
 debug@rivosinc.com, seanwascoding@gmail.com, andybnac@gmail.com,
 menglong8.dong@gmail.com, cyrilbur@tenstorrent.com,
 wangruikang@iscas.ac.cn, atishp@rivosinc.com, apatel@ventanamicro.com,
 arnd@arndb.de, nathan@kernel.org, nick.desaulniers+lkml@gmail.com,
 morbo@google.com, justinstitt@google.com, qingfang.deng@siflower.com.cn,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, bpf@vger.kernel.org, linux-arch@vger.kernel.org,
 llvm@lists.linux.dev
Subject: Re: [PATCH v10 2/9] riscv: add infrastructure for preemptible
 this_cpu operations
Message-ID: <20261112120248.5c8265e2@pumpkin>
In-Reply-To: <20261112104149.38589-3-cuiyunhui@bytedance.com>
References: <20261112104149.38589-1-cuiyunhui@bytedance.com>
	<20261112104149.38589-3-cuiyunhui@bytedance.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 15F49180004
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: o51cumd34eg85ujia8d31bb9rpfhdns9
X-Rspam-User: 
X-HE-Tag: 1794484973-894419
X-HE-Meta: U2FsdGVkX1+WGbJtuHAOTD+rzJtHJhNeYC9jRjUrHfN76g6K2y2FzSBIEMk5JTLTEjoaTonMQebrwkZXz3BatrE0fwaIf/wZpyguXl3J2UdAvhQ+Zaa/uZgLh9bcvZwBwOsbeknlNEBBb8O/QO4FPDCOk+bqscyowBjs4ooZdxG58KVlCcUILLivLelt40Bg+5K1LppD99uZmuepkyW6qjjXwei9HxreKAmvGgwHhppbwAtx5DofrQOuQa1rppwEz9RMxJnn8PyWQv6nMtVB3fUQQOYwgZZYkp+ID5/YgTrtjgDVNLg6vJBDU8Icg0bCmzmSga2DA9g/JVemTHv8H5PzwCBVuK5xCus73dJCc32IHtHyqHveJlhsbCC9BYZ265pVZmCx/l4ySkmy6tjqFbmXBJIeNdLg0RoDuiY8Jmzy7gqPfxZapI+ocxoTE6CvwrpN2/kbhHUkjUgJLC4UNJJw9wkz8Ki+j1fdB8n2EYVBUKasvlCKaVhc5wvESnbkYahSBXd7VHJMg/qEY8eFhMHNKJElyMh1iQ6uJ/0Zpr9z4Ij9WG5K6I9nFkl2RFKm+Gjyl2cASLyBbDppEUxbUIRdsqoT57qmNG66Maptw70+h29uO+zM0ZicO5WK/UppTj+LLw0p7awvG3jmnf1T8WdbcQ70+7z9gBlfH0x68cLBRcKEtXLdOv+3o/Ewbbkq1uasiHsIwNxAgrLyzqvpIRtREXrpiPisBZ6ne/ncLDvQwiOOIoVzxZO/BK9MTShc5p1geNOPk7JW9vMa6jzmuq64jP/pRYRAeXo4N4Wwh9xmSw5yUO8eE94h1HezsWi5LHoJSnnkFgLLeF+/IdtHkSOkJzxOBx68v6K646gVCVw10O84keFr6FS+jguE/DveKH7Oi/qSDWgwhY+rcQqaW5TrmD5bdoAfkaad3HKpUXBwz0wQh77yzXFrGM6sNqVWzCBl8Mcvps+7HTE7kc5
 T0TnmHM1
 g2+0BY1KuJf0+Q7IwLzT1Eta3M4kpFZu+7NyzCrAYI6P6bPp2i5cJN4NxuJ2zG6wWG5vMznp2sCGMCxa8l2EJQfbT9K2jL84k5w8gWivXDMOZpztfqw/bOda0yPrA9bpmeabxmA5aGqWXLu2Sh2QPSw6upxYUVXQgNSdgfOUP45GlNmvh7NOOhzHq+AQ18MPj36+lpzpGTodQwBfJZGyL/olVTIT7h/oizYfyPQy950uKyo+Kh9haEb2UJWX+fbiC4lhixPys7Zu19VwGNMPAUunFTA9Bm7EkQ/MU9gGlv87srU091WTkVi+37rlTclvdqQLQEDCviIRvzSDHiN5vtNWTvdVInItkhoV8eqOviTDDMwWaCKGuVnRejsXVgLej5TfZunwTtdiOfgF81ArpRUyjkYkh9U3ScUjd30eKkZCleVblwK3R2E9c9KS8f2PhLIW58ef+MwKindDCeuimg5vmtu4iP6U0MyAxlPlQI5FKMm0J5ovDnuRn4a75ecar92YYeFW7jqhrSeVt0vtiONlhnl4L4ioMlJXLXMAZkkOVVJQUlT+uWnY4T6Ev5akudxV06WubmsR+VAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 18:41:42 +0800
Yunhui Cui <cuiyunhui@bytedance.com> wrote:

> +/*
> + * Mark a region where the per-CPU offset and address registers may need to
> + * be rewritten by exception return after migration.  The three registers
> + * must remain distinct for the whole region.
> + */
> +#define __PCPU_GPRS_BEGIN						\
> +	__DEFINE_ASM_GPR_NUMS						\
> +	__PCPU_GPRS_ASSERT_DISTINCT					\
> +	"li %[off], " __PCPU_GPRS_VALUE "\n"				\
> +	"sh %[off], %[gprs]\n"						\
> +	REG_L " %[off], %[pcpu_offset]\n"				\
> +	"add %[addr], %[pcp], %[off]\n"
> +
> +#define __PCPU_GPRS_END							\
> +	"sh zero, %[gprs]\n"

Those are quite nasty with all the hidden variable names.
It wouldn't do any harm to pass the names though.

David

