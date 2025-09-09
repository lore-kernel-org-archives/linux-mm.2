Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7596DCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 17:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B86EE8E0001; Tue,  9 Sep 2025 13:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B30008E000E; Tue,  9 Sep 2025 13:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1EA98E0001; Tue,  9 Sep 2025 13:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 926928E000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:13:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FBB98658A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 17:13:07 +0000 (UTC)
X-FDA: 83870357214.17.05076C8
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5889D180008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 17:13:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ventanamicro.com header.s=google header.b=LUYRDn2V;
	spf=pass (imf16.hostedemail.com: domain of ajones@ventanamicro.com designates 209.85.166.182 as permitted sender) smtp.mailfrom=ajones@ventanamicro.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757437985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CLUjg7yNG/ewQNg8kcK05UeNpGcVlJZKIKA/TtV5FkM=;
	b=NHxoI3XSGe7j9zJIFraSCVP2Bt4jKHbz4ydEUwSaDDd2wGf3uOQmJqn4aOIgsNyojx0bUL
	L2pYCMhwWPE4TgQhB3/tQL3gxAPBOZoP0BlYlwXWF/WDffhE6iI1Y391pzlvh1oHpEFQpw
	DZcBQDORfNOlMZ8EZZuz5dGKW/0MZFs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757437985; a=rsa-sha256;
	cv=none;
	b=QQbb3fw7DTIhApfhMyubANSTlvHSfD2YGmVJ/2lboU2qEkB/JfCjD5ojfkSQadtCfeu5Oz
	xeAxwN/h6B+4jVVwiOsb3MfO0wDaQRSPKeM+0oCZPpHNpGzdvNPZ/F1FxRkvL+1jbZpXTp
	QBFa94qPIwM0amXaZCVrGHO0//XePtE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ventanamicro.com header.s=google header.b=LUYRDn2V;
	spf=pass (imf16.hostedemail.com: domain of ajones@ventanamicro.com designates 209.85.166.182 as permitted sender) smtp.mailfrom=ajones@ventanamicro.com;
	dmarc=none
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3f66ad3fcf4so59619495ab.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 10:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1757437984; x=1758042784; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CLUjg7yNG/ewQNg8kcK05UeNpGcVlJZKIKA/TtV5FkM=;
        b=LUYRDn2VAumwYn9i//49mFPnawNw9sTzJCuHhqI4ElytRu0cOhPyajQM3JxMhnvCj1
         DOFzL7BVzL5clymVp1YD1LPd2aC6l6GdsRliS+2yhu6AzsAC61gVyHwJVoVZeuLT5EmY
         fvsuAemgEz4AEx9rEKdOPxszclSaAjz9Hzn9dIBvnrPpGaAvt4AvzDLVNigyMJks5k3R
         K4PreGJSth2qwMgHoAQiJB5DiHKtM6+KQ7/gYK2HAzz4cCpPDt758MndkyNPwA7Nm3sD
         HxRgrwydxjt5c6vzrZrufxIePA2cuR/DUsvfiST8V8V7C22vN/yYfHpYqjLAk0SPAAMp
         SysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757437984; x=1758042784;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CLUjg7yNG/ewQNg8kcK05UeNpGcVlJZKIKA/TtV5FkM=;
        b=DmX7LdnLqPaNadmYNFVBJtTsMYx90MxSrhBbOZUmz7ZHAZSMrqtAkdasa5cnpKQByV
         p9vWQQeafb31vSJsVcCj7hWYJ/OcdDxajcH5An9qWnuqoR2NcKEaSx1zol/38oLSMCE9
         b2/o+2sG7hoesoLahrNZYO+sOYP3DnFc4JubZPZFAeqGBUBexRF/d/XBoc18giZSIH4c
         FCGrpJpuWHcfIVRUCIMtfaBSeTpcWOELw8phV3CPUAohDulvgmyzoD3jht0Zxp0r38KU
         Nwit8tB6rp47vZEvCeZfEJoLPYOCLQUl0zMwJHzYvjeTr2SQt1MUTYmyIfJUBR/SoxZ/
         vmNw==
X-Forwarded-Encrypted: i=1; AJvYcCWFo8a8eRNA7XgTTpReFQfJ7w3Cepy+MwAhgx1nrdnWtI7AIrMjiXi2oi8rRx1GAWITzD8L3L4yDw==@kvack.org
X-Gm-Message-State: AOJu0YyVVC029xsO13U2PRgR0CHHpCtocIJEmTubgifZ8//uKO1gjiqg
	cpG5bQ30rjtBulgbgJtOaQjQLmvM7knSKyESNg/+aLzTtGMBMLABRxIpmqBSm5JsfKk=
X-Gm-Gg: ASbGncsISAOHqcTfcDvZmCqqaxu963+kEjc4/GLvsX7CtTI6R4rfK2F2bQMPG3cnJsD
	O/10jfX2Fbx/eaDy8nDxNX3H8skV/iANpg+BO3cgXPZOyM8Bd0VpauU9xQy0lLqLIkeTifqZowL
	YffJ8sGOvvEMwJXGRXu+UCW5KAWiHzS1Rv1b46jK77gOy1MefM+Am5WhNZal72YoZ/tAofU+FDj
	dK/Z7UqU4GjNHgQop9CGLhe3z2OUXDRNitufATy20Rig2X8tsNf3MvOqOL9XhDvJXohWuyLi8LE
	kzUo+azYywq0nwgivQLbtFhoVc30+mAOPR7KmFM2JrQKa0tFFYR4Q9e3p1iArJOuGwistGv48Nu
	K/iPY4336dVH2Y1A6iadIUVad/o1csHCy6VI=
X-Google-Smtp-Source: AGHT+IEMFpaj8bMLzDHV4JtX7+vWxYaXCZCBKZ479bbfT1RoejNAOJVpK28JUe1NbmGtyLq/mXgp8A==
X-Received: by 2002:a05:6e02:1a0c:b0:40a:e839:a2e4 with SMTP id e9e14a558f8ab-40ae839a49bmr96540285ab.30.1757437980965;
        Tue, 09 Sep 2025 10:13:00 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5104c5a4d0dsm5507495173.0.2025.09.09.10.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 10:13:00 -0700 (PDT)
Date: Tue, 9 Sep 2025 12:12:59 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Cc: linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Deepak Gupta <debug@rivosinc.com>, Ved Shanbhogue <ved@rivosinc.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Chunyan Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH V10 3/5] riscv: Add RISC-V Svrsw60t59b extension support
Message-ID: <20250909-2130daabd7f57a8a357c677f@orel>
References: <20250909095611.803898-1-zhangchunyan@iscas.ac.cn>
 <20250909095611.803898-4-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909095611.803898-4-zhangchunyan@iscas.ac.cn>
X-Rspamd-Queue-Id: 5889D180008
X-Stat-Signature: wit99tjoi99j16tdh7drtga68jafg53b
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757437985-819873
X-HE-Meta: U2FsdGVkX1/ZfeEsjr2alT9fliF+o+61aGucDwbSEvgeb2Q0cFqXtnhKmmKk/p6LDZwayIx59ZiLbyF1W8aAta98kImlsrV8aBMwx314k0JK6e1+ylrsE4IBsuH09AeLSBaB+22qNLvYI6ciL4HXiZmmV+HxBh3eGGk1cYfxsHZsRno+XmNQ+dh1nsvXcVOOr9S9NVVKmTbjdRNGCzkafCEp2AeDS1GvHOk5tCgBo0QTNX+gvB9Xmjfdqd6qRo/QQ/eAADAhkR/JvQ2IIkcKqWOJ6FbPqP1Apl/sknB9DiN8Us5fSE011Nd4uhn6li7CbisyoXOcAQgyjirs+hspbvpLAE2DamMSUG19JzyKMtqArTj39h1vxCSoZehHIYe0Xt3fyoplMiyoFqJKHbEowUjyISKl3ROV6z9OHo9+AsY+ummATffYm46oUhtvsDPYDtF+UyRubGZmO3ar5bDskEHjqebylZ2HPqQ9/HukMr9WSxM4gyQvuE9ErfhM89v7UIDa3qx6eWdy8AeH2kkvvgU4jfOJglEkTAp95d/ocM5yrsUYpooaHdN1c3/X+wKsiP2QgYbz3Mp+/Si0zYx9L9FASk1bNlmNEDBandBeMMoT0mB8/nyzN68J1lgkp1/otcqjtJ+TXGH8ZvtyvsjATBUfgIlBS/W2JvoEKl9769VJz4mqpTuCX7B/6JKj4Hc6r08k9MdMSErXxdO84XyXFhK0cLcBUUKWRWmyRLsGTRYv5gnPpF7wo2s9oKz7sN+cVKb/kwX0aUYFRZfU+FAY7dayyG9O3ghdcJzVPrIInNOh8PkWj562UlmJGVy/Jkgo2DXkuy9/IlMSWfyik6wNeT4C7ldNFjVmin7RV48VCynlXaJjxQkNNcnRp6KgXJpxNc+ZpyLg0DSpa0DWOcCbUTkjodhuz7igHuSDff8Kfp+ZeMLHZTsiQY8Wzr/jL5UGDUYWYUXxEkIHbeZmpbA
 fXnX6etS
 e1ZR4IUzev5JNmZTJlliO2Zaycnfwct7PTJOgoZesXgJz6HBt1+4hlVxrBNa80Q/BN0SOpMqBNbAgNaVxbdpY0Jx+BrpeAPkCAsPcWGQCGqKsVkuohJtbuh8rYQ9Snj7lP2Ij+Tquu5V0bwSSXuHFkh9zPUqe+hb5hdFiepR+p31WZmUTklXfzGk6ePdZTzsQmXqVKIRUQKv8h1JpW1abcm1qZJV+ytvTLxLuoYMyzZhh0RK2EjTrspSikRNxRlD3Dcj9nNtsps8mvibnshSlgjxCWkInpUAfxZ8IQ8p+x16lc6PLFtZYoRk2T6QgdnhGxPGX1KhkB2JdmNYdhWtTTkKQOKw4beFtYu+o/2MMzTJGUTlXT/44kboCtdOf4avrO+7YVMC5ET/l80o5mD9cvoFAIOdNABa3JFj9y0uXx1FKcncZ2CavrG3YRFiITf5rQUspe6LiM5QgcTT+UjPor0EiPqTZJeYDoe0oaQsEK9UP44z9tqrBt8FdBa8MX8X9JaKVo2Bo2OFKrqf5g/zSU1UeCMP1mheDLvl2JnTx0zmcNaljZNYYwQCN9AxotH6Nnojy9OsOEVj/lIfaUdYZVMdl/R2vsNA1cET1Dhx1MBzJSFKkW48bOUHXbYCTnhvRqPX15IG3jEdnHq4TiBLwg85uJRJJh9W7M/ix
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 05:56:09PM +0800, Chunyan Zhang wrote:
> The Svrsw60t59b extension allows to free the PTE reserved bits 60
> and 59 for software to use.
> 
> Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---
>  arch/riscv/Kconfig             | 14 ++++++++++++++
>  arch/riscv/include/asm/hwcap.h |  1 +
>  arch/riscv/kernel/cpufeature.c |  1 +
>  3 files changed, 16 insertions(+)
> 
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index a4b233a0659e..d99df67cc7a4 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -862,6 +862,20 @@ config RISCV_ISA_ZICBOP
>  
>  	  If you don't know what to do here, say Y.
>  
> +config RISCV_ISA_SVRSW60T59B
> +	bool "Svrsw60t59b extension support for using PTE bits 60 and 59"
> +	depends on MMU && 64BIT
> +	depends on RISCV_ALTERNATIVE
> +	default y
> +	help
> +	  Adds support to dynamically detect the presence of the Svrsw60t59b
> +	  extension and enable its usage.
> +
> +	  The Svrsw60t59b extension allows to free the PTE reserved bits 60
> +	  and 59 for software to use.
> +
> +	  If you don't know what to do here, say Y.
> +
>  config TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI
>  	def_bool y
>  	# https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=aed44286efa8ae8717a77d94b51ac3614e2ca6dc
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> index affd63e11b0a..f98fcb5c17d5 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -106,6 +106,7 @@
>  #define RISCV_ISA_EXT_ZAAMO		97
>  #define RISCV_ISA_EXT_ZALRSC		98
>  #define RISCV_ISA_EXT_ZICBOP		99
> +#define RISCV_ISA_EXT_SVRSW60T59B	100
>  
>  #define RISCV_ISA_EXT_XLINUXENVCFG	127
>  
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> index 743d53415572..de29562096ff 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -540,6 +540,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
>  	__RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
>  	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
>  	__RISCV_ISA_EXT_DATA(svvptc, RISCV_ISA_EXT_SVVPTC),
> +	__RISCV_ISA_EXT_DATA(svrsw60t59b, RISCV_ISA_EXT_SVRSW60T59B),

svrsw60t59b should come before svvptc. See the ordering rule comment at
the top of the array.

Otherwise,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

>  };
>  
>  const size_t riscv_isa_ext_count = ARRAY_SIZE(riscv_isa_ext);
> -- 
> 2.34.1
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

