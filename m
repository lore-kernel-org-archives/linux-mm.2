Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30B70606BD14
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=an7qNshc
Received: by kanga.kvack.org (Postfix)
	id 24FFC6B05BF; Fri, 13 Nov 2026 12:22:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE796B05C0; Fri, 13 Nov 2026 12:22:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D72E6B05C1; Fri, 13 Nov 2026 12:22:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D02476B05BF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:22:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2430C029F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:22:38 +0000 (UTC)
X-FDA: 85430765196.24.98DB03E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6CBBC140003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:22:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=an7qNshc;
	spf=pass (imf23.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794590556;
	b=SSFboVi1yU+My679g4bXebRnBwg+CpZw/XQEUvcp5qWF3Bb6AEVhFLHI95+/IZ/B2bzw0U
	fwioniTJ8cPpu1KjJFNDSr+918H6rRIFVXhGctAJsvXdF+V2EuZRcK8596uv2/W9xFVc8m
	gGdkPfVzD8usTllHgj1PRkwcSLmzjwI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=an7qNshc;
	spf=pass (imf23.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794590556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z43uFM3Pjo7vfGW2mID+1SupLltnf5Xt8DNDDQTTcdI=;
	b=3yBDsHOpch/SodR4zR8DbixWPcLeHjWpUDiuLgPDMfl04SZyud9L+PrGSKlwgG7tb8inaw
	mahqJ+a3gY4Holk8ccJnPHAoirpytfOtFYsiAlYSa3OV3K3q3+aG2h2tf55Z2+oQ6x5lRO
	AvQTNKb6v4NsYDlmemjl/qq8gRRb99w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794590555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z43uFM3Pjo7vfGW2mID+1SupLltnf5Xt8DNDDQTTcdI=;
	b=an7qNshcty32otm5qc6CSPxErGcMnyUYWXQa8X2t7Wm7rmmS2RBjZ9GNdTNRIwjpIF8iAb
	UlezVmtgYquLGDTsS8QBdBAOiVnfOwFYZepup5h9hTPFUvP5uKAcP4efq2CvLNy2InrgLl
	VZC3e6d68eeiNBko8aMNA31HguofSvw=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-301-vnsAK5gJMRKclhZG1Ox_Ig-1; Fri, 13 Nov 2026 12:22:34 -0500
X-MC-Unique: vnsAK5gJMRKclhZG1Ox_Ig-1
X-Mimecast-MFC-AGG-ID: vnsAK5gJMRKclhZG1Ox_Ig_1794590553
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ed276af91dso20958645ad.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:22:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794590553; x=1795195353;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z43uFM3Pjo7vfGW2mID+1SupLltnf5Xt8DNDDQTTcdI=;
        b=2G9q1wXhd/xbm9SMng2bSwuj7NQVp25O2d+WcsPjS5htOscTZodjx0rk1WXtuA70GI
         AUR7fipdRGH4P1pad3Yq3pD0h780TSFUTRnjGsL53tCYG5m8BXs79/vvc+/HMi6bP+gw
         cEr7Ugv/FvN5vFWyvb91YTP0fkuoRmfR8ZIjheYAmYDcfYURuNzbBhD78n17pmySvIFW
         +i6imoo4+ynN+6BLrFHmCrtUoT+cxjNpGgLli3bNf2sKAxR8TI1rV/u5XvRxfyj3XSLN
         qoi/+am0zi8KH69pjYD3kMdEqd5/9wGdvVfT4mDkenmrydW+OftHJTDSpG9yz2LT/wCD
         DU6Q==
X-Forwarded-Encrypted: i=1; AL+hErEYVMtewc5pS9K/manGRGwErRtNrsdb761JXdmHX1lUxxYiaRIXull6yuwBxJ0pjFtuah4aYcDysw==@kvack.org
X-Gm-Message-State: APuU4Z/w3Lk91ruGMKGdWkdHWw3B1Go9wOhhMuld9hx62f0UyMXsTN3M
	yV4pZcQ1Zictak9uri6dWcUkamNS+Ny9liFKngT4xAOmdqWhbSkUshSP+eQ8SDpmDOxoT0Bxqoh
	s6TbJz7PmfdAa22fFBhRUdHKxCPfdOye7TfSefBpB9N38hsCtvBWh
X-Gm-Gg: AYBFou3JLmwqFIMvACXJ3w5t4FqcUUKV/hGYfKXCLo2Z3WgMPT72pRCac5X67eY7gc5
	GlvmD7lLZDAgcePBCGqGFY0MHRhTAjEZeIoHLQrRpytwFw97zyZphHDNoDibDtsiahJHDeYcmow
	S5QQ3rwX1boriB1yaAIEsmqCtwP451AbM5JtL6oWjQnXnlyU80rSI7HznA5IFGX2hAsNQx+cacS
	qssb2ybqey1WfOWlILnOEAY+Ep7DbPyR19j6BfjZLBdPveWdjndNlLI1/Ogn4PwOYZvx89FNMQA
	gacUh7MJjV7WQN++ny/lCsbeUSYVg/455EgiRg65WBm9MGfrIGL6hBgRk5fs0BKYyUF8RcRTFg2
	zSa6kilcbBFSN+dUQYekD6qM2i66nsykUAChVrK417AbMUFpMDKdvLM5puY3vXSsy3ynKqsQ=
X-Received: by 2002:a17:902:d550:b0:2e9:6f2c:71b9 with SMTP id d9443c01a7336-2ee0d6654a8mr33241545ad.1.1794590552873;
        Fri, 13 Nov 2026 09:22:32 -0800 (PST)
X-Received: by 2002:a17:902:d550:b0:2e9:6f2c:71b9 with SMTP id d9443c01a7336-2ee0d6654a8mr33241305ad.1.1794590552278;
        Fri, 13 Nov 2026 09:22:32 -0800 (PST)
Received: from [192.168.1.102] ([117.245.168.128])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f809867sm14050805ad.41.2026.11.13.09.22.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 09:22:31 -0800 (PST)
Message-ID: <9eac28b2-1931-434a-ad06-ceddf34869f1@redhat.com>
Date: Fri, 13 Nov 2026 22:52:24 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] kho: docs: update description of bootmem regions
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>,
 Kexin Liu <liukexin@kylinos.cn>, Randy Dunlap <rdunlap@infradead.org>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Sourabh Jain <sourabhjain@linux.ibm.com>, kexec@lists.infradead.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
 <20261112-kho-bootmem-sizing-v3-5-f0c8d00295d5@kernel.org>
From: Mukesh Pilaniya <mpilaniy@redhat.com>
In-Reply-To: <20261112-kho-bootmem-sizing-v3-5-f0c8d00295d5@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iQJcqRWkdlJitXdcFwXXkVbddGbedFRg-jCt2ULsgW8_1794590553
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f7w8yyfz6g9gfouodt6kt7ghuxyu7ykm
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6CBBC140003
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794590556-870738
X-HE-Meta: U2FsdGVkX181san7cLxXTGZeFo57iq9qMJEq1AFd3/AFgIaWblf4UP3Hs1I5nBx0NiElKiHrp8XM9DDca9CcY2MAawIenNvfP2Tqf3ysV4Pz7CCtZI8VxX3cJ/8+T0pxUCDSfwk1lw+KAh9uvaF55yOc43EwBUndPfIAFY/5NgyldpE8v4Z+slS97vAOMPA3aQxJo1yN8lKN4Ub63hXTj9HZkJEemw32GV2jZI727wBS9V77I5x9GJfykWw5bxUK5znyN7xQzAh6lk4gjuk+632yAxYyrhE62kuelH01vw6PlMJFmSlGB/1WJTBftRxtmNrk0uTnhdvFjGQsm8OEnZAEIQ9TmS5ScC9cOl+/XLuSUd7eeXTHm61p7zm21RjqrR1FLv+p9gxMQrfbDAxZ3gn+vFpb8cDSi+GZzC0MpXQ2tsqQZewdOiXO/uQVSFnJvAi6jnBmO+bQ0ji5LgH7FyHXXS2gdTWzs8uNjDrulC3gdhgyUPvZCgaMDaGjid/hPu2R0B2/AdUHvlw6z9MaJxD0oDSlqC3EBJVbMgGdkE4nZw9iI14JcIvrs/71VtoEEx1pl7Szd13LwqBt046LMFwyJIMohfKwF4WNZJ8eaU7iviL0KZHtdV7Y+SArO+eJkTcnQLX18tWzri0Jx/VNE3RbVLfSSBnLa7/fd1PXw0Kbz1gG2ow/uU2KphjXa8nihkLkviBOb9B25ync3T74RaTYIwusnQjnPo9aQIm+EqZD/kZGaW7rC5fcD9rZxPMcV3YyxR5w9odmjl2LsUjQrZx0ZDH8KUYn8fzyvzIvvAwlO57blUrND7T9jN8QHQQYMW5GLPdS2Y4csj53Iae6UNQEJ9rXBoleC2nFime7BT9NUtQZW20u5Q400RD4xq4VoCLMROJCrC5dqd+WJnFtTQ1VUpEqcLYaWNJeJJ29A2ZRADyNcdC92byT02Jbwo9vxoL1qJlbpUbSsduXXqy
 eA3rWbrT
 UHAYU32Ymt9V2qolNb8YXO7voR3gvgvAOFChFo03WQoz+n2PgiBLu8tLH4TCZnRnPBpwUIPYgCe+FS5USqqCU91IFfEsRwq5BEHM7TdKqoEq3XZ2aVhIRn55VYuI3slVPMz09RMBHax/JFumX8NkMOnjoTSy1uqMqoxjEC0ToAOfrbPVWg3BXpvD91KXitz8YjA/cpNZ538X8t0yrzCIytkbkdHE0Mcbr6n1mLHSbOKGZwmBORYBZXtXU+Xsf+5hJbG3FVP+d1zuErrfV7LmMbYnyg92v0/0Cz2PtWmRGYnhSrhPhyvPqHD7Z74Ofsbd7y4knVx/gqHzU/naVQ6m73PBxOCrK9P112MnXeCz4HDjpT66/0IdVPW31xOy4UxA8cXfh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 12/11/26 4:08 pm, Mike Rapoport (Microsoft) wrote:
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
>  Documentation/core-api/kho/index.rst | 31 ++++++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
> index e78a2bbe2be1d..ce2bf9cf66514 100644
> --- a/Documentation/core-api/kho/index.rst
> +++ b/Documentation/core-api/kho/index.rst
> @@ -52,17 +52,26 @@ allocations before during boot up to the initialization of the page allocator.
>  
>  We guarantee that we always have such regions through the boot memory regions:
>  On first boot KHO allocates several physically contiguous memory regions. Since
> -after kexec these regions will be used by early memory allocations, there is a
> -boot memory region per NUMA node plus a boot memory region to satisfy
> -allocations requests that do not require particular NUMA node assignment. By
> -default, size of the boot memory region is calculated based on amount of memory
> -allocated during boot. The ``kho_bootmem`` kernel command line option may be
> -used to explicitly define size of the boot memory regions. The boot memory
> -regions are declared as CMA when page allocator is initialized so that their
> -memory can be used during system lifetime. CMA gives us the guarantee that no
> -handover pages land in that region, because handover pages must be at a static
> -physical memory location and CMA enforces that only movable pages can be located
> -inside.
> +after kexec these regions will be used by early memory allocations, there are
> +several types of such regions to ensure that all boot-time allocations work:
> +
> +* a low memory region for allocations below ``ARCH_LOW_ADDRESS_LIMIT``
> +* a region per NUMA node
> +* a global region for allocations that do not require a particular NUMA node
> +
> +Regions that would be empty are not allocated. For example, there is no low
> +memory region when ``ARCH_LOW_ADDRESS_LIMIT`` covers all memory, and there is
> +no global region when ``CONFIG_NUMA`` is disabled.
> +
> +By default, the size of the boot memory regions is calculated based on the
> +amount of memory allocated during boot. The ``kho_bootmem`` kernel command line
> +option may be used to explicitly define the size of the boot memory regions.
> +
> +The boot memory regions are declared as CMA when the page allocator is
> +initialized so that their memory can be used during system lifetime. CMA gives
> +us the guarantee that no handover pages land in that region, because handover
> +pages must be at a static physical memory location and CMA enforces that only
> +movable pages can be located inside.
>  
>  After KHO kexec, we ignore the ``kho_bootmem`` kernel command line option and
>  instead reuse the exact same region that was originally allocated. This allows
> 
Reviewed-by: Mukesh Pilaniya <mpilaniy@redhat.com>

-- 
Regards,
Mukesh Pilaniya


