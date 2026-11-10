Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AB6160A3806
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=KXixUmBT
Received: by kanga.kvack.org (Postfix)
	id 5E5AF6B05D6; Tue, 10 Nov 2026 10:08:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BD546B05D7; Tue, 10 Nov 2026 10:08:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3506B05D8; Tue, 10 Nov 2026 10:08:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 225E56B05D6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:08:24 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CA48120905
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:08:23 +0000 (UTC)
X-FDA: 85419540486.11.E36D6E1
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4D4B3100008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:08:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KXixUmBT;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKAEhFQ+Dah3DMHVjGDEQ1FI4504gN8wbhTTvAQenls=;
	b=GvBy2Rtv7GQ6BQYjCpgd6emOGGbXA933xC/iH9IpNEf2NwZq2ofvk4697M+Ll0+M4te1qu
	aoDePostSGll0T2GiQAsHwTfAJHK3HS6LWb2rOCqPy5GeY+ALZ1leANKBaXAtEJV/Lr+hN
	2TH1Uh0YiV2C0GPGObFQpzIoyMDeW8A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323301;
	b=QIcUnh/sTcwYuET41ds2m1L58QTB1vD0/TK3+y86KJ9Y6DGixQL4btPTEfnl+nPxCCbCaF
	x0RKoXikJYCWK2S8oGHSOG2BmBAOTXH6NLKxJOcS+0I0SoDtC2zApZJUqG2pMnj38Ejsbl
	+nmQU5uZ3DRtS23GVhr64lR8uGYO4mE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KXixUmBT;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-9908c849564so582041241.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794323300; x=1794928100; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WKAEhFQ+Dah3DMHVjGDEQ1FI4504gN8wbhTTvAQenls=;
        b=KXixUmBT8a9Nj3zzvRuUUxZX47mLJm1/bKBr3bJ/Ctow6mzoYpZWiPeYxmDAPq3QHW
         +tMUcpq5vHT1t5UMSYq8JkuQ3RZeZx+5+EUvL8YZqOx7ftpPBJ5ap/gpwv8fetwO8lEa
         Tw5WW8ceLZPzpRliGFsjwtl7vbYag0LxZJ19Wxg4SxrSxCsXQt504sZsN1t3dC07poY1
         V89rFCajqvVq4vrPXOUpF6PpKYl01nhDMID7Vo7N58Kb/ZplkVyX5mJKVImd9ViMsCx4
         2XVzGCYu2M9kJUWsbv8h7N7SrKYTbxtY7CPaOFx1BuwQLjBF/E4PZlFMl0nzo6o3K6QM
         y3hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323300; x=1794928100;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WKAEhFQ+Dah3DMHVjGDEQ1FI4504gN8wbhTTvAQenls=;
        b=za00AwRLaZfoVO63iUKgNIlTo7Y/fzaF+fzYT0J17Qtbt9zR/au6Qj2v0+5GfB9T4J
         pLNago+OaA/TtXPhN23o//asSpV0yYggfRVIu2HPQRJDTBuEKpl7l/L3yRtz428WXUZQ
         cun/SW8sWJClmbbG77DGKc+7ltWQUYQCvR/Z+AYzG5543FxHPGGVsFOu7q9hg9OUvfCW
         sAT6iZb42TzSJnrEuOn4F40KTljf56m75ILwjLaGqqNlS68edwRZiv3XC9YRoeEc4Wy7
         l5GsK9RKCga/2IjVxGotImM7NayyDukJxxROQeL3syjiuPYiHvuq3rUmSMKaFxdOFRdz
         EHuw==
X-Forwarded-Encrypted: i=1; AL+hErFROkksExjPrDTH/fml2RsUDPqRhBoNSILPRkFSCO68+f8P5WZom0xKjXN98Vk6FewIMtpujo4d7A==@kvack.org
X-Gm-Message-State: APuU4Z9L6HKg180f81ameRZWnL5gj6aMS5XmqV2J7/lsqNW+tH+tFR9X
	/p8K8O0iZ/sfGVxhurfpBYcY5WqVvlL9/SRupmk99hZ98C3x1XUyeNzxE2pTz0DtADo=
X-Gm-Gg: AYBFou09nXLr5QQX8MU0FfW1x8C0APVfVr300RPCdWY/+3Pp2ELHiK3N+tYdZhC6Q0q
	gC29zrg7n05N0cpjthDJ1KQQOXlEZ1jlh1ZSgc1OKno9l5vkXXoiQboBHyRRKvt5y43f9lWPVtR
	zhF7N1rk4sCBTWW2GxFt0b+LfbiW1Az8tZFFt5mPKUitMS4MCeWQ63zPq+lE9uwFFFFUwm2kq87
	rQ/WEuZOkOzLPmHOL7rEuiynRkOuCEEHfjtXBPR6mloE/E2lyBvCTlKhWT7zuy4frWRe/t//C62
	5MqS1Msaq39MzA+/5ewHXvpUx6/BgsSBlR5xQwq32iTUKXr9uLr1hVC0adLKH8AWVRLTjZAj0qn
	qVZzlTX5gw3xI3ZxH8zt5VWM1B3L4mLqveuOzpFJNt++Yr9nSVP754Rz1o0rvwKiB0D46rzfCDL
	aFiZ3s/HMnc90eYJKn2h4kjkuSh07yBuX+Xx/D7wF1A+fvZTe6YlHgdWUuoLGligS1M+6BEHucc
	cjmMOvYEN3FxIS7UAXpxE/9fuBxrCATnHJGPIWue7oHhzDH15WvUEp0MKdj9KnBq+/6EXs3Rk9i
	gIAKnO5ggDC2iYcs6NmDp+magVtWepqkGOyJT70Ol/DFDqrBG76RHdMg4BCw05MyAeHCVG836s5
	29AJmDZXA6xdPEPbTeUjFYiTST8qDZMfj7VJOvR5Ci1iD
X-Received: by 2002:a05:6122:468c:b0:5da:a74:d6a4 with SMTP id 71dfb90a1353d-5ee0d1254cdmr983516e0c.15.1794323299946;
        Tue, 10 Nov 2026 07:08:19 -0800 (PST)
Received: from soleen.c.googlers.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99c1fffe63asm1965122241.4.2026.11.10.07.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 07:08:18 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 06/19] kho: kexec_metadata: Add the feature header
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, maz@kernel.org, 
 will@kernel.org, David Matlack <dmatlack@google.com>, 
 Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, 
 loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org, 
 baolu.lu@linux.intel.com, Bjorn Helgaas <bhelgaas@google.com>, 
 oupton@kernel.org, alex@shazbot.org, gle.com@google.com, 
 pbonzini@redhat.com, Andrew Morton <akpm@linux-foundation.org>, 
 kevin.tian@intel.com, joro@8bytes.org, kvmarm@lists.linux.dev, 
 linux-pci@vger.kernel.org, Pratyush Yadav <pratyush@kernel.org>, 
 kexec@lists.infradead.org, kvm@vger.kernel.org, iommu@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, skhawaja@google.com, sagis@google.com, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261110050202.529473-7-tarunsahu@google.com>
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-7-tarunsahu@google.com>
Date: Tue, 10 Nov 2026 10:08:12 -0500
Message-Id: <179432329215.2329176.14453669404153142360.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3169;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=QPKh6oqVuep5a0uq5kk2HJ+pkn4UzCARnNzVJdUZk/E=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq8zNhLa8G7KPQhtpqNqIaC7iUSrItiw95IH4+W
 4FZp+mLRNmJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCavMzYQAKCRC7dyhM23N6
 3ixyD/9hSlVPu6pn+Usl6EKxRh1wkp2nNTAGfSwd0T80brdKlRNG7a8mQqhUQi1H7cXmovyHBUq
 ES73eQCtV9EEqD3V+9mhbM/vQ3DNxapFoBftgUpOKocv/TyzS+fnYCCd+V4qkZp6JbEE04DX5ph
 RXIIzYY1cOoM3lIFUa3WAKuQ5IlLTqUrcCnmCGDDA2ABc3Dn4YGxVfA+j1TEgs3i5/pZ3Jg6vPm
 2w2Rki59ZZh1OvjNwqaQcNxFUaUzOua2A1T1C5uWqXUw29+H364g+FPC9TsTFighlf5Dm5nInFm
 sy05T7yV7PmS1d4eRFn5VjWQo2hboOwrVmB5E3sLTnbZ+oXkY0TgWbPqKYlXfKYQ1RF1dttkf3y
 L666oJVxxNOxQuWbB80WyaaQp1G11CUhLjsRBaxuJqYWD3LuhT6NKGc7rkKJ+4Y1QHbv77qrsL0
 xU62OLvV+UYlxbDgjPM1r4q1njY/2zmio3uMBSt4oubrAmtiUMAW6J6dY86mFHlcm8xgbSUbn5B
 HOb83UbLMhoMCV4Zf4R9ofmr8Zb5PO+Ieg4+UAv33DElEYGHzsZJuh7rv0KDrtHn6JA4zqY3vNY
 KpfJSWU9gzyoa94bAOMSWiRRC/83AeXcMfiQw7G8I+bNVH6Sm/Q6RfvqXkiiTkw9BXIWwqNbXQH
 2NBA/068NaYZqOw==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4D4B3100008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 9jjphagto41pr9377pies9tbgqkwa7em
X-Rspam-User: 
X-HE-Tag: 1794323301-548711
X-HE-Meta: U2FsdGVkX18P5Z+vqFbiIojCDKmTXlBVDWP29gQf5tezSsqGVbT6Jz3v93uAxZ5leQuviv0wwZevcUDeZKFynJ51Y4nmFQ6FZbpgQmC+iMTnvtdxHtbC1LvmQJRQpeK6JJdI6b/8fn7fIKPlqsQBrBtPePhAWOsQzm2godrLCnLD8B4XDVN4z6184ON30u1SOMHYWXWS2qVqfrPfCYR1mpfieQBUtYg7zt5vp0uPV7nyj6jCO9vVT3mW1g7lAzM0aH3L372daI08uxAig38FVCIC43Hr3HcTUj9mBIsdcHg2SwDRBfp+NbQjx3Rh9TlesRwArPX4ZKJmfBSdhnf4cMuVk2KfGab4x7lKPrCETrHz3X/znktNZphohhwHv/EMf1GRPwTwPAqG5iBMxAjCGygZOxNZqX4xLarST5tA75jBSWECY7WX91K0+427jEJVrrFKzod+Rsg5vvzz7Pg/srIx4GwSavo2wOIIVAcC3Q6RKbfFH5Dg8Tty0AZWcvFuY8fxMYrDFy50bA31GDnIysiNDPmrUYh1UdcgPB5xrdD90I/VEOSQo4o48jS3aXli1BqQJxLtlyx5bu1BPsVF5fqzzTo5y30y0y0dWU/mM5DIBSFf1CdndSTGPklaCktLc//YztRDgd/zEFOH8mbZJ00ELnqJbNCZPqLYScAYUq4MqQIF8Rrh5wQFeE3L6qCdQv7wsbNNEX95Ty80smsa1Jz3RNqa3RDwNcrGiyXHaqJJziZ/2fFTvCKlo8AfFblE4TWSgJb8M19zF/vOLLVQs0rbgFZMtcHQVvBblzNbBMcN04WqBGYRRC3BSWVb0zJ+Ax9+rtdizr1mlaBlYDf0Tq3ricu4YQzYW8ny7Ckmc1dzhKnDe01DPddscAfO30l+xIkKr9k25Kfr9ZgScyg1v8Xw2ddcY7kuyVB3G/TZKuoCLnFj1X569IfFjlz88j41DfPi4HbOYN2aEIfHMnw
 bGfFczEC
 nvEagJdMmyQiuWpG81uI6lnNmSDByD6E1RHWZiyD4/UETxXcf4auFKZEU4uXydXYA5DGyDsdm4jEl8XjPqTLjFjaUnirTgUsm5aoYDWUhs1DaFDCWRU0E3kAfXLAW80fiCYxj9oh8Vldl17whZXrD/IlSu1S55wy6mGk6nV8WBN4U8p244u9WDzPuv1Lcu81PdJ751IT2UX78PQL9E3Hz1WKF56UJg2ZgZmVOQXpiMQleoRK2v03SWfS00+RHr36BpDz+ipLe7WxLdX7RfKgTKwjn8yP4V8B6VWUrX55iHmGOnDq08UxxZBPB7dhoTNFLICNkYXee+OQL7DDyTqro8b5b0yhMOJfjOpvUJFsDhaKF8UmwleNctpVYd8UtMRFXogFx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> The kexec metadata subtree currently uses a monolithic u32 version field
> to identify the metadata structure layout. Any change to the structure,
> even an optional additive field, requires incrementing the version and
> breaks compatibility between adjacent kernels.
> 
> Replace the u32 version field in struct kho_kexec_metadata with
> struct kho_ser_hdr using DECLARE_KHO_SER. Later fields can be appended
> under new feature indices without breaking compatibility across kexec.
> Also make the 3-byte padding hole between previous_release and kexec_count
> explicit as reserved[3].
> 
> During deserialization, validate the blob size against the header size
> and reject unknown required features. A legacy v1 metadata blob is
> ignored with a warning.
> 
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>
> diff --git a/include/linux/kho/abi/kexec_metadata.h b/include/linux/kho/abi/kexec_metadata.h
> index e9e3f7e38a7c..316b3e5ad01b 100644
> --- a/include/linux/kho/abi/kexec_metadata.h
> +++ b/include/linux/kho/abi/kexec_metadata.h
> @@ -18,28 +18,31 @@
>  #ifndef _LINUX_KHO_ABI_KEXEC_METADATA_H
>  #define _LINUX_KHO_ABI_KEXEC_METADATA_H
>  
> +#include <linux/build_bug.h>
> +#include <linux/kho/abi/feature.h>
>  #include <linux/types.h>
>  #include <linux/utsname.h>
>  
> -#define KHO_KEXEC_METADATA_VERSION 1
> -
>  /**
>   * struct kho_kexec_metadata - Kexec metadata passed between kernels
> - * @version: ABI version of this struct (must be first field)
>   * @previous_release: Kernel version string that initiated the kexec
> + * @reserved: Reserved for structure alignment; must be zero
>   * @kexec_count: Number of kexec boots since last cold boot
>   *
> - * This structure is preserved across kexec and allows the new kernel to
> + * This structure is preserved across kexec and allows the target kernel to
>   * identify which kernel it was booted from and how many kexec reboots
> - * have occurred.
> + * have occurred. Preceded by &struct kho_ser_hdr.
>   *
>   * __NEW_UTS_LEN is part of uABI, so it safe to use it in here.
>   */
>  struct kho_kexec_metadata {
> -	u32 version;
>  	char previous_release[__NEW_UTS_LEN + 1];
> +	u8 reserved[3];
>  	u32 kexec_count;
> -} __packed;
> +} __aligned(8);

Why __packed was not removed in the first commit? __aligned(8) should 
not be needed, given that it must follow DECLARE_KHO_SER which is 8-byte 
aligned.

> +
> +/* Register kho_kexec_metadata with KHO serialization accessors */
here and in all other places, please remove this comment.

> +DECLARE_KHO_SER(kho_kexec_metadata, 72, 0, 0);
>  
>  #define KHO_METADATA_NODE_NAME "kexec-metadata"
>  
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 6f1f55fe3181..2edd772bb6d3 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1740,6 +1740,7 @@ static __init int kho_out_fdt_setup(void)
>  
>  static void __init kho_in_kexec_metadata(void)
>  {
> +	DECLARE_KHO_SER_HDR(kho_kexec_metadata, *fhdr);

Please don't do this, use kho_ser_hdr directly.

-- 
Pasha


