Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ECCAF94CD4
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 06:54:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 545746B0088; Wed, 22 Apr 2026 02:54:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F66A6B008A; Wed, 22 Apr 2026 02:54:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E62A6B008C; Wed, 22 Apr 2026 02:54:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CCA36B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:54:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C49101B9982
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:54:48 +0000 (UTC)
X-FDA: 84685279056.13.85D423E
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id A2A641C0006
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:54:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776840886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zyxMyDKhrlWE+5iCHg59pMAULgdQUBAeBRtLLkE5UPM=;
	b=52HCl6DU78oXmoGJrhuY3yjxK1F2sDBvyrPNSHL/PabxQjvlS0Jrzs4XFQRdgUNix0AhAN
	c2V5r5WfEYGMN4PsCv3+bXfYZGOYCcq7MsShKdpJM0HM7vTlPMfbFyOaswSRTqYyy2xy3E
	npdwpZHZmInV4BUz0+qIOuRC7nDDkuU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776840886; a=rsa-sha256;
	cv=none;
	b=2VifwYy23d7vA7EgDdUfekZQKZd7xVxY0FQVmKVImJx+dwj25rEGvYHZsi1tPF++fU+tyS
	qs9OTk2HCbXPcS3bktDDy+aRy83cnD2aCEpBA/zPHS8rxiYrqaHrEnij92SfPqX5/XuwWn
	VxaIHEIKsBg/R5SReae9u5g0SlADhM4=
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-56a9076813bso2098977e0c.3
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:54:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776840886; x=1777445686;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zyxMyDKhrlWE+5iCHg59pMAULgdQUBAeBRtLLkE5UPM=;
        b=g3TC9txhzQwfKvE4EMsFNt614+Z++Qgf9LVapaUoNtlab7nF0jlFLA7OEXli4L5OtG
         sSVqNf1iJ5QKXva/rWvPlpibI+Wh8IzxgeGdSdCyIb8nsAF5oLh6DAgBen4RYq76FzN7
         GR0sUhR49F69OpePpvbq+EYod0uYCBeqVmwVso8nSrBkf0vXkXSI2O7WJp0USy+IKZHJ
         XKcVdFZNE4ADfJC73OKGMtZmiy3pRzERpx4LickFa9/A79pC8B6YT3870rf8W2HCC53T
         0KkhuIFk7cexwYeuGQj2pICUHlLrcx9pS2zUsHeF7M+mXyfow3UHIvajxmbSAVX5aTvn
         PXoQ==
X-Forwarded-Encrypted: i=1; AFNElJ9RI72OGDkiEWeNYXdgyBoCrryocZvxwG4h+2ABj32LsNibnQ3mhme1MrLcx2eaPGN5SJB0wR4Kgw==@kvack.org
X-Gm-Message-State: AOJu0YwnGOxmZbpkcXmsvUa8yF6Es/QLw7mBHivodzdc7+Uf1TbKFDaD
	BeJckhwWibLP2YfF2fr7BDnocfkvmxIDa6BbDM8lL5ukw36RGGBD1QQV4Bqqeog1q3c=
X-Gm-Gg: AeBDievdYK6gwjce55MA9rwpHVVtmJLt3busj+RWCoP9HWGbZsUSkxq28sInKX9Aa3H
	7u12IoCp7X6h/va4pJ3/xYdb0navgIOBvCPe6O81e4eT7iKd+lNrAh+gup76RojfKehVlxdg/De
	4Mm3xiIQUbnK2DnfemySdvi8sMgFO1ZbUq/IXdDtjXCIqk2oGRjXKxzPR1eghu5XmdKyB+zf76f
	ebTebEUX1i8+kBT6PHUOB2R+uuq/Lm+SC52dVgkjJDYiUps82VKlYOixduuoTUHdAAWebUsTi+T
	dSCVvqcS1ykXgWvOqKedLHoFT4kLJsOVpk1S3B6mORbu/vILhc1fVUAOIk1TKoY4Qb7iexw+KK2
	4ounUqMzDIWxfJcTqXphTeCS8qSgfCEj6kDTeuGbmYBdUWS8Dx5huBU+OhBvCaImcMvi2qJAwy7
	ZAiIDxqPxUYffGk2zv3KYxHwguuYxkWZI7pbtwVHIGf2zLoSXswTuL0CQRfRzOITg2vq5rwmPle
	n066KxeVY6/dg==
X-Received: by 2002:a05:6122:4696:b0:56a:9841:9f81 with SMTP id 71dfb90a1353d-56fa583840emr6330243e0c.6.1776840885490;
        Tue, 21 Apr 2026 23:54:45 -0700 (PDT)
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com. [209.85.221.176])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56fa91bf120sm9773711e0c.3.2026.04.21.23.54.45
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 23:54:45 -0700 (PDT)
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-56d8d479149so1743140e0c.2
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:54:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8Y1AMXHrxPF/upD/Jbqb+DRanhjDVlFzdYuKXahzPDRQcCO9maJJFPCSGgtAQ5NnZLNvxaQ1aHfQ==@kvack.org
X-Received: by 2002:a05:6122:f84:b0:56c:db8b:504e with SMTP id
 71dfb90a1353d-56fa59fbc9fmr11532873e0c.13.1776840884876; Tue, 21 Apr 2026
 23:54:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1776808209.git.mst@redhat.com> <006f9142e591ba8c340c3b354aee76aec5c285b9.1776808210.git.mst@redhat.com>
In-Reply-To: <006f9142e591ba8c340c3b354aee76aec5c285b9.1776808210.git.mst@redhat.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 22 Apr 2026 08:54:33 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUtNPY1=92H8GZSDkQ5_rNnxL6WkjTF=1ApjwTA4z1TqA@mail.gmail.com>
X-Gm-Features: AQROBzCgl_wyqpfJ8JAvw4YHU8svwkzmMCs8RMYgDiGFQgsN4z72BoUKVxkZaoc
Message-ID: <CAMuHMdUtNPY1=92H8GZSDkQ5_rNnxL6WkjTF=1ApjwTA4z1TqA@mail.gmail.com>
Subject: Re: [PATCH RFC v3 10/19] mm: remove arch vma_alloc_zeroed_movable_folio
 overrides
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Suren Baghdasaryan <surenb@google.com>, Jason Wang <jasowang@redhat.com>, 
	Andrea Arcangeli <aarcange@redhat.com>, Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, 
	virtualization@lists.linux.dev, 
	Richard Henderson <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>, 
	Magnus Lindholm <linmag7@gmail.com>, Greg Ungerer <gerg@linux-m68k.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-alpha@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A2A641C0006
X-Stat-Signature: 3yoi7r4qbhorthty46jnobndwktzt87w
X-Rspam-User: 
X-HE-Tag: 1776840886-917620
X-HE-Meta: U2FsdGVkX19CTT1Hixei9Vh1fz9TJFGPZqefNQ3eVcai3CoILoU7/yq41+WtfId4YnDhrYQNwGv6xnJ2KmxcR7Ijmmye891JhbHjNgs0Xj8hpjqXQseaiToGav686U11O0Z91D3AtUtSoZm6s3am25u0c05jGvk/LcJr2v06BWQ8KffusLNjANqb/UHu9NJxYzckr/87W5udbWTChT3jmF0wYVuJDMzNp7pHFOIByA/ce0/2tn2kVJeucKAhkXs5CzR3LqPs500LSYdqSlL0Lm3noapUEY37Gd/in59ZEevHKS9oWeNgvWMdUH8Fa/ZQifai4OZvuTTqXOmFLBFKiaF8H7Ku8zECGqd7KUvkCIj+rt5qku4oi5335iqVwqRCaEUzYlgWtYJyJmJIGSRF19PCT33w38ZuLo1llm/KMaVMqo7b243e/AXoE52ynbF+cm7BcVsevyY1foJ4epfBg4eEy//9mjcb+Q3YVGb8p8ylhTm4n6fuMaMPZD+cWztH2013MZ7z2tmTAnHSr6feisvWirhh846QDWjArOjCMQpuJny5HjPZmlyHXqhdFOIx+z1e9e0/oDqRqvkuKhPRPR1j1sZeTgC0jANev1peCrqSVt2X9bQ5WzJEvTMmSBJeduxckWAPWz0Ek2nn6HJWhIh8pLx0wawNIO4vYBGGUw81pTkDntGgJOYdMWJtT1k8x4NWdzYbimvBPWzb0xgFIAAAgThoeyZ0O0iCv7/pk4PYBMGd1buT0jtvA8WZ9Ugsxzyh+RgQ3+dIfyKSJBB1WPterlPR7qc7WQGK6fjSW9QqU3YE3a0lAYKTfYOVqbOmNOu2BwiE4cGWYN1YMjMbUWRX7k07anKLVNOSQKoEmXE/dJKQH16qOL/kAmp10DwPU6lIfoQF4EXHwpyd57e+mDrDKbyh3Dkko31NYxUyggyri9CFCrcaag37y86f8x6r2oLf5QgNudiC/X730kN
 SZfkxH9Y
 mtLHK8jsc5ZQjOGQtruGl0sXYaYTS3/X75yoTtocq92CGphrYN6pYIz3DRcPTOJeVzVAIpjt47BOvn8WCeY3NOEfkjpdrB/7ow2MARKUrYdUzQPf/LgqIdOwvQa40xozxQjy5bVAWUy0tzIM/7u1A+Djk9xu3h/BQ5xBXn/+tpYkHRXPGUMl4oyLiWk4PNPo9ZRtZymPlV+ZWsmkLDQOitGk5xfKzDl958NcWG280MZoiW6J3sjoC72yLTt/5aCjqurXJVVJQKnvnFEpiz8hK46sL4YpHvELsU1SCliy3bOYdLg5O6zb01tqzAmOCdeyOuKLcitUdqCRSPW454E1kRgnAoYQm9lx2YgIP/bh/2eTh+15xkv7UK6lBzrKgidEn/zTO7M1FR5B7lJsD7vKYGeFBG0AUFOgGq2QNb+mBgFaSX+gdWuyjEplFHqY5nnG47QwNHxiY4jlMIoeIY0uGuGPYl/eyDZ3QyWK5PUrbbJwaWShFkyeOL/wx0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Apr 2026 at 00:01, Michael S. Tsirkin <mst@redhat.com> wrote:
> Now that the generic vma_alloc_zeroed_movable_folio() uses
> __GFP_ZERO, the arch-specific macros on alpha, m68k, s390, and
> x86 that did the same thing are redundant.  Remove them.
>
> arm64 is not affected: it has a real function override that
> handles MTE tag zeroing, not just __GFP_ZERO.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

>  arch/m68k/include/asm/page_no.h | 3 ---

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

