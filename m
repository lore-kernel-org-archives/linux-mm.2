Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC7C0606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 15:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=fEm2njSR
Received: by kanga.kvack.org (Postfix)
	id DCFC76B05B5; Thu, 12 Nov 2026 10:00:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84EC6B05B6; Thu, 12 Nov 2026 10:00:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70056B05B7; Thu, 12 Nov 2026 10:00:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 947F26B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:00:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A580405E2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:00:39 +0000 (UTC)
X-FDA: 85426778598.08.389A34D
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1565480011
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:00:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fEm2njSR;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794495637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8yYqy1tuA0FyJjrVSCVgV+Doj8Jl7Ml/5bTTP3YOpXU=;
	b=XveODGZcyCGTxtotYt1PI3FRKfRNsc3UTfdmti0ASBbFX2QcJUwy1xTGQPKpv5SFuVydAI
	M7F3e43vC24aSUHG23anjhrU8063fK1aa8nRP1kNPv45wqvmyOzrzv53yY0LJx3V5Owh6Z
	2nJ1+kH6CSHWmRgqXJz2Hm/y43NcT8k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fEm2njSR;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794495637;
	b=BSX5YBjOftksT9c+tVhM2/6wUe8IWt1S0Z3I0DPEZvPKxDNbBl6036je3haM1CJRpAcWNP
	qrFBQyNamZx3ss7drAZh0UasemAMEZGh8uQ+p+qzNFIi03VfzepPVbuMNbY9s8U2ax9CTV
	/Sv1xP/wX2tDl8C6t+rJH9EWkQeiElE=
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5ee029fd76aso2066521e0c.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794495636; x=1795100436; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8yYqy1tuA0FyJjrVSCVgV+Doj8Jl7Ml/5bTTP3YOpXU=;
        b=fEm2njSRLPnSgaxGK6mY8rGt5RgSb6wdleCafEmR3jnw77Yhk6XC4/RhN1IR5Wmfzh
         +MfxWO9TjRA7pxfxOICEi9+bGIee2YNHVdIACZmzfVfl+K6EoNJ/i0IjpOJ5tj/ggn0b
         cK84HZC9A4G36whHhup82hxrYmzyHP+xhwm8McN/cwi4jUZyMACKZiyj9GdPo0t2aMYd
         gEOys5UsCppcBIZpCoqqBFa3mmC7PQaY42AmQRy0ntsOzMMtFimbT/vYVkzykDv3qTNy
         UKsxA2B9FmTDBK/DE+wiyn7g9G8N49zXyA+ZRipouQKRvzgSKQn148az2NFeeTT71fml
         VU9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794495636; x=1795100436;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8yYqy1tuA0FyJjrVSCVgV+Doj8Jl7Ml/5bTTP3YOpXU=;
        b=JfpsEMM6ehdTCoaBAqSmL2yIMRJxi6VsAusfZtUGNVwVsb8LVYXvS5Hv3KiF34CxLe
         xdUW5Hf75zKGzMmQNN8Fo6+qVVvJodyBasLFprln3pV1IRJW040t1XZ44f+VLxr0fEtg
         OXsJx8o9FVW6HFQbO3b47m16AKsdWDKlU/LE8jZtvq5ETDi3YnlHcw3ybueGFn6fSvJA
         /qJEOZ+MaO/5ZV9pmr2IfcuGHnwK2rdf4EqwvHuu1tnYnos3I9a7AbnzvNGke5fe6PsU
         KEl2xoxLzbXVPRBgB6YkScAR7jYJflbwMXiCgfF5ETPGOJobLXhhh/1C+mLYXOtjfiyE
         F5hQ==
X-Forwarded-Encrypted: i=1; AL+hErEfxOsmkv2OGT2/m4do3OmkxJaS3NHlZC9UUEd37t5fhFqCzAY3Ge/Vz3H7slP7soDJyQWybxJtfw==@kvack.org
X-Gm-Message-State: APuU4Z9l/oxDi/lEyEcKvhGkQTQYG7/cefBSg3g1afq6sHv0y0WN5O02
	uHoB5hXtdFwSNngkLiZULryIhCmUaLnqMRpJPoJAC7d6J3l0WvzLN07JhhInSk/pcaGMbtN8VzG
	42MhM
X-Gm-Gg: AYBFou1JjwXXvbQsT80CLZ0fQotDpy0SSj2aZYDHvfDxk8AZ9nFYSNPxs+zyFqCmd8X
	IMomcAt6EXI8rb/dJ6cePk64j1vDClgA92yBqrs421U6iHDqPY1ryWatVWdNoAwLwuXXPqkR4tF
	G5iLo5NtSN4wQ7tRrCWt+tlFlfH4+DnWtzmI3FveSZ30Ai/2IbRTUykYnV31uJIR7c6GzIbwaF5
	nA1ly02qXjYwOSDeHneuKSbngUpzzkb5FgTTgmp0MNVbP6uKFH128uvxd3ziTV2uxVr8+db5F1C
	OrAxk/sCkjuYYrgSiCCOV8mU6LXRCndXRgx6L/6sHT3pAdq39Y/kyFh6XZ/1Jr/wOaqCIYKtH9k
	jwmTN5B69IxkRgo2yXOp1rFiToV2SI07oNnFAgnNqX0BTI4J+PPeHRUJFI9kp116CLR2jqbs6ej
	mNFULxhbfXMOhUJUBKVb5Ie6FsqreOP0QOKI6Ne6rWPg/ePlncdeOPzBMuGCDCYZvbJz9wsCtbo
	W/+mRGObdIFFvoligRkKFq/mhm7X6z2MtQ47e2v5SCcHrQTcH3op3YXqBASNw5GOanVrbIQiJgz
	9+mdoowNLNUnNJl23S7Tk3g3e/iUM3O4X/BRfqqLTjeTsQMDOMG12ffiqhHcWiUnIK4c+B/g08T
	wu9FfTToYUA6fE0TpU4evD6vBloyl/9o=
X-Received: by 2002:a05:6122:1782:b0:5c9:a7af:8178 with SMTP id 71dfb90a1353d-5ee1c2b2435mr2759606e0c.2.1794495636101;
        Thu, 12 Nov 2026 07:00:36 -0800 (PST)
Received: from localhost (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ee3243e30fsm81430e0c.9.2026.11.12.07.00.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 07:00:35 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 12 Nov 2026 10:00:34 -0500
Message-Id: <DMTBM1N2LO8K.2LXV0IVP9ZSI@soleen.com>
Cc: "Alexander Graf" <graf@amazon.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chen Pei" <cp0613@linux.alibaba.com>, "George
 Guo" <guodongtai@kylinos.cn>, "Kexin Liu" <liukexin@kylinos.cn>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Sourabh Jain" <sourabhjain@linux.ibm.com>, <kexec@lists.infradead.org>,
 <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>
Subject: Re: [PATCH v3 5/5] kho: docs: update description of bootmem regions
From: "Pasha Tatashin" <pasha.tatashin@soleen.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, "Jonathan Corbet"
 <corbet@lwn.net>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pratyush
 Yadav" <pratyush@kernel.org>
X-Mailer: aerc 0.22.0-39-g5d7784875be2
References: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
 <20261112-kho-bootmem-sizing-v3-5-f0c8d00295d5@kernel.org>
In-Reply-To: <20261112-kho-bootmem-sizing-v3-5-f0c8d00295d5@kernel.org>
X-Stat-Signature: oaq9tm51bgdert5fpoeb18zw7byshtyd
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1565480011
X-HE-Tag: 1794495636-605392
X-HE-Meta: U2FsdGVkX19LhtyzGuEuyzizzdtxq97g75NGoKjT4T1BvVlIdShgZKBkBEZaXownF4Lq55VoEf663AYy5HLyaXOjOlwhZpmT/iyrE/TbsGLEV8bEISNxkRtB2UkwTDA2fQ28VWvWkkJqqmp58o9P9ipuss8RiOPIyErKjHgCEzVcwq5AeSmgj1dyWHRLXdo/xFu4mPIicAc3Yyl5po80VjYjWLx2gJ0Sf5YJWuLiEar+akfL4naE+ZZDke7m8Cptc1bk3U+pDWZKytMEyr2kHZga7+mZnF6MZezEc5iKqEmRZyCjfWjZYHC018FR+rQpiZj4ChnNMEGs0OIjEfXcaK3gaz/rUTJDHTLtwWQV3LgbxiPRuQwIVpPphXxH2FPUksnhps+uvc/KVc/Qrpquao0L559zcZIe3O8zQX+sYw1MjiDUazo5glObVg9jP7o8ZmMs4w9+cXKS+92USJjd6doy4RHWcY3w3KZCJR7MT/z/KCWZCxV1pXpBLZl9AhqpBlbVM1xnzbyh0uCmX+UZej+5cPFIV/VI9K/wAfSkfaQ333g78Bi+iLOp0XfndycemOXP4Ic248TAEkvxg7vyKEu+g+ezp/JvNSrbP+MKZAVqw13zgMpZSzcbUz3IwQrvAwmq5wqteyLVObdXE90xlavooWJJetyBzuW23/J/cphB/1LvD4sk+YRyOjZzW7DIFZDAf32tZ3/OPxPz7VE8GP1Zrt0/eauBO4gRCi2Gi0zc6HiE7Wekzl0sNaZ89hHx+3hjIq1GNORSIAnk8YQqoaaa8IbFlmrp283WdmuhMQyEggmcgRHNa3pWOLii54AuvOc0P9skCKYj+bC4VvYue4ek4MOQ2ijW05CfF+DZrwNqaqq97wlAuDETqcd+uHYnN71yrb9giPuIgzWuyPwqQHLV/XIjHdrTIpgHb3IADsLA0KaWBzrm54HyD/JfpoMu6KrsFsRg5miVmZAC3ft
 IwiM5+Al
 ZANWq6ATR9vIBTxIpeDHjJAYXXI9oVGzAl/B4mjzlJBMcxHt6WNFy71f02PbFCewg67L7nuXZXoPwP68BxBTCRlluJhc5XB2K3hGvFozH8/zrwGBRNnzl8rMWV8N9HCEHkacjLqxhKakD4f8B7BJ6enE7GNNTpWZn3BbyU8kA91m45a/k8TVTJUOR41AIQ7SiAHYvq8w6Lico8yTkouFld5MSd5T9wFHbn9VthJ9lIR36LGG92VybqWm+Lsy9GFtscpGaSrJOn8AonUC4QA+nFK48xjIwbdLRxzrrJe3G7zt9lGrm+PsK7SOHPvAS4MGy9wEqtdCz+tMrLd8yAhFrkrMmo+bLWXEjI6pZhq+hW/MiVKUZPx2SJ52QgrcccMmMBpjgVheI2TX0nlmPN284O+h5uDZjHULHF9WA5cwwea/fTzx5cjuOfOWD2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu Nov 12, 2026 at 5:38 AM EST, Mike Rapoport (Microsoft) wrote:
> The description of the boot memory regions does not mention the low
> memory region and claims there is always a region per node plus a global
> region, while the low memory and the global regions are not allocated
> when they would be empty.
>
> List all types of the boot memory regions and describe when they are not
> allocated.
>
> While on it, fix grammar and split the description of the regions size
> and of the CMA usage into separate paragraphs.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  Documentation/core-api/kho/index.rst | 31 ++++++++++++++++++++----------=
-
>  1 file changed, 20 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-ap=
i/kho/index.rst
> index e78a2bbe2be1d..ce2bf9cf66514 100644
> --- a/Documentation/core-api/kho/index.rst
> +++ b/Documentation/core-api/kho/index.rst
> @@ -52,17 +52,26 @@ allocations before during boot up to the initializati=
on of the page allocator.
> =20
>  We guarantee that we always have such regions through the boot memory re=
gions:
>  On first boot KHO allocates several physically contiguous memory regions=
. Since
> -after kexec these regions will be used by early memory allocations, ther=
e is a
> -boot memory region per NUMA node plus a boot memory region to satisfy
> -allocations requests that do not require particular NUMA node assignment=
. By
> -default, size of the boot memory region is calculated based on amount of=
 memory
> -allocated during boot. The ``kho_bootmem`` kernel command line option ma=
y be
> -used to explicitly define size of the boot memory regions. The boot memo=
ry
> -regions are declared as CMA when page allocator is initialized so that t=
heir
> -memory can be used during system lifetime. CMA gives us the guarantee th=
at no
> -handover pages land in that region, because handover pages must be at a =
static
> -physical memory location and CMA enforces that only movable pages can be=
 located
> -inside.
> +after kexec these regions will be used by early memory allocations, ther=
e are
> +several types of such regions to ensure that all boot-time allocations w=
ork:
> +
> +* a low memory region for allocations below ``ARCH_LOW_ADDRESS_LIMIT``
> +* a region per NUMA node
> +* a global region for allocations that do not require a particular NUMA =
node
> +
> +Regions that would be empty are not allocated. For example, there is no =
low
> +memory region when ``ARCH_LOW_ADDRESS_LIMIT`` covers all memory, and the=
re is
> +no global region when ``CONFIG_NUMA`` is disabled.
> +
> +By default, the size of the boot memory regions is calculated based on t=
he
> +amount of memory allocated during boot. The ``kho_bootmem`` kernel comma=
nd line
> +option may be used to explicitly define the size of the boot memory regi=
ons.
> +
> +The boot memory regions are declared as CMA when the page allocator is
> +initialized so that their memory can be used during system lifetime. CMA=
 gives
> +us the guarantee that no handover pages land in that region, because han=
dover
> +pages must be at a static physical memory location and CMA enforces that=
 only
> +movable pages can be located inside.
> =20
>  After KHO kexec, we ignore the ``kho_bootmem`` kernel command line optio=
n and
>  instead reuse the exact same region that was originally allocated. This =
allows

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>=20

--=20
Pasha


