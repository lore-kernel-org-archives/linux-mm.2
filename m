Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2D7FCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C2608E000A; Wed, 10 Sep 2025 04:39:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14BC58E0003; Wed, 10 Sep 2025 04:39:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 014BD8E000A; Wed, 10 Sep 2025 04:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D852F8E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:39:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7AC5813BC0F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:39:02 +0000 (UTC)
X-FDA: 83872690524.03.875B38D
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf28.hostedemail.com (Postfix) with ESMTP id 65854C000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:38:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757493540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OcGpZjdiY9hrkVpCReXe+DC/oLVSLqeRIWi4ys+DtWs=;
	b=jKoYNk37LcBssNR9OeZnAD2ZJBS6W2VirttCxZ4gVhcjuys/BJXkARczV96d/eXfL+qIyf
	fIWfjjLCz9qRpuJCx4Fo1H8xws44s8q3KIF2Yvnt3AP7N0VEDv92PhcGUHZAaqFXmSuhiS
	hJvfNj8Rt5+M0CagnBL+uRRlFv0aDmU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757493540; a=rsa-sha256;
	cv=none;
	b=t73QV0B5HfIJPYTxfJzmx5Iv9hybRrl7vP38Shs93DVtgHwMqFGj6UtjLQm15Tyq1hhnjl
	l1mOISs54FZuMAbY2itRIXIdnf/BrTkwFQENMhQYL6rCnG+oMDOJKPe8sDVCe1JllS4mfv
	0wvy5oxkHNAxDH8CNYyEt40fX93x9Y8=
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cMDbC6vdSz6GD5p;
	Wed, 10 Sep 2025 16:37:43 +0800 (CST)
Received: from frapeml500005.china.huawei.com (unknown [7.182.85.13])
	by mail.maildlp.com (Postfix) with ESMTPS id E95FB14033C;
	Wed, 10 Sep 2025 16:38:55 +0800 (CST)
Received: from frapeml500007.china.huawei.com (7.182.85.172) by
 frapeml500005.china.huawei.com (7.182.85.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 10 Sep 2025 10:38:55 +0200
Received: from frapeml500007.china.huawei.com ([7.182.85.172]) by
 frapeml500007.china.huawei.com ([7.182.85.172]) with mapi id 15.01.2507.039;
 Wed, 10 Sep 2025 10:38:55 +0200
From: Shiju Jose <shiju.jose@huawei.com>
To: Yazen Ghannam <yazen.ghannam@amd.com>
CC: "rafael@kernel.org" <rafael@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "rppt@kernel.org"
	<rppt@kernel.org>, "dferguson@amperecomputing.com"
	<dferguson@amperecomputing.com>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"tony.luck@intel.com" <tony.luck@intel.com>, "lenb@kernel.org"
	<lenb@kernel.org>, "leo.duran@amd.com" <leo.duran@amd.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Linuxarm <linuxarm@huawei.com>,
	"rientjes@google.com" <rientjes@google.com>, "jiaqiyan@google.com"
	<jiaqiyan@google.com>, "Jon.Grimm@amd.com" <Jon.Grimm@amd.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"naoya.horiguchi@nec.com" <naoya.horiguchi@nec.com>, "james.morse@arm.com"
	<james.morse@arm.com>, "jthoughton@google.com" <jthoughton@google.com>,
	"somasundaram.a@hpe.com" <somasundaram.a@hpe.com>, "erdemaktas@google.com"
	<erdemaktas@google.com>, "pgonda@google.com" <pgonda@google.com>,
	"duenwen@google.com" <duenwen@google.com>, "gthelen@google.com"
	<gthelen@google.com>, "wschwartz@amperecomputing.com"
	<wschwartz@amperecomputing.com>, "wbs@os.amperecomputing.com"
	<wbs@os.amperecomputing.com>, "nifan.cxl@gmail.com" <nifan.cxl@gmail.com>,
	tanxiaofei <tanxiaofei@huawei.com>, "Zengtao (B)" <prime.zeng@hisilicon.com>,
	Roberto Sassu <roberto.sassu@huawei.com>, "kangkang.shen@futurewei.com"
	<kangkang.shen@futurewei.com>, wanghuiqiang <wanghuiqiang@huawei.com>
Subject: RE: [PATCH v12 1/2] ACPI:RAS2: Add ACPI RAS2 driver
Thread-Topic: [PATCH v12 1/2] ACPI:RAS2: Add ACPI RAS2 driver
Thread-Index: AQHcHC9WuMPoKRXbY02Oy+WxUZ/jerSK8o4AgAEvHbA=
Date: Wed, 10 Sep 2025 08:38:55 +0000
Message-ID: <81f32641fbc5448c8da1918ddc5d6965@huawei.com>
References: <20250902173043.1796-1-shiju.jose@huawei.com>
 <20250902173043.1796-2-shiju.jose@huawei.com>
 <20250909162434.GB11602@yaz-khff2.amd.com>
In-Reply-To: <20250909162434.GB11602@yaz-khff2.amd.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.48.147.226]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 65854C000C
X-Stat-Signature: 9p5p8o3qm5hfey9yhx6h9oybndsngxwx
X-HE-Tag: 1757493539-192218
X-HE-Meta: U2FsdGVkX19arxYHc/zgI0s3GRz2HXDhsOYWKGaMaOyE8JFPO9Phk9QTWzbRErkZkm8nZ+3mR2uO/jVO7e/U6aDkgcMLuEWNm+j1ipZA8HOiHLApg80c4NOM7YVlx0UYmagKuqDmddoHlxkBZqrWpGF8DKIogQV8K8994QOb4i8GQjmxoriV/trv8LK9FUSFZsUdn6jLg21CHucYsikH+J+rEDuRZlsQa4im6BxYOusLSwYXNv3fvCXLCPK4M7c8blwY5PEqp7DHmoftCSFgO94hMpVs53yzeOTi/d+/9o0O2qvzB8rv6uNpeBHfTtpt8sCBrcPEMLVSe8ew4RCdldk2aDU2bsJgwKymN1D6xCdvCVPGj7oIQUYTYpfU6sX6xLIaZJluV3VeUTGNJ1fXV2g/GFVf9pSClMgrnl87O+SdB8zan0HYvO6wNJdhavwcCERYqrDG8tbQHh7dtFnHA4UKN2E6vbL3MS2sYWYRxIhTxL4k/XSBUFiJqgnWlv2dgYEdJCQ9ZY2uNnkG4qF64KiGX4pfMd4Gr15FJre4zg4nDhqNT7QKr/HMa1UGdqtdOV7DTyyn8whf+IsfUiN0+aw7Bklt1b1lVaBAHyYhEhEw9GztoK9pVvrLqf+3U4/4ELHSBvZLqFYWqbZh+G42074c2TjksMg7ydzRs7EKCUqQSdkbhvagolZjrl6rXFaTKrSjT95hU4DAqMo472AWQYURLOM46SlW9Y49fzr80g6HJG01OWr/HJrCrG83ixflN1IByxvpc/E9E+fPi39IH8kd+qKgrdc25rAVnRbXgQ1vMExXb0mBF9MBcZBIgAzeDuW1BZueIm2lH/lQN6A8AB5g1VDauIFtRhL+/KssSBIulAtF0HFrhoDjzv2Jc2D/lqqxW0debzHPyldmCw2GTr/IHFkEy4Moz+meSB6X+bFHIZhtjZTXvie7Z5HZV8MePAyqSAnOdfpZUe/dtsy
 ozq4vbc3
 +F38v3RNEdyxVIkJ1WO8WuKXxOBCw6j/QvNK1Y2R20IZB6ioZgC8SkH5s+iZirobJG+12djifpHVhY0C2vunZqBUws1Jfz+3ShVA3NkxLQt0DKxBQFqHDiOoK8DIivVqrxthiWb+m07xVv27vfx5g4Ab1tN6N1i210HQ0uvDw91t2eTp9OUBTydpIwrlhe7qFN7NeIAZDoaqrrJwl0iCI644xlcSh/rYrXOzecOpkTkdk5TK744DQ1w+aFY2R5tsT9KdXNT19BDS+nSdF97nYMWiFCt8Qv186VsuqlMb2lEUIsNey2q9U1PR5ciHIqp24Xnk8N6zZx5wwP6PpBPZZzMXc1Kr5+9NLAANIG4sETyERUUrArB8GdeKiiBq9WMv5XXsK1OFjLbXRGbsE3gAuInOVYlZOEU6y/Z/r5qQpEvQdzIDc/y9WWs9xwGje7Wmzf8lJFuWUB9q3u/6WWCUnBCLju2aK1bCFfuFAQF/P0yLXn6Ez7z250BYxApeBKb7ALX2ZgbJDkpH7XsV+qJ0RbgjGSqcsdtNirk6IPk0E2nBjxAGhogxSR9XlldPa9XamiarvpPxuWUU58rBz93sfNRZCgvqV20vF9rDA0pKUzpYf8ttgeEqi/7jpF+T6gO8hLk/91z9FXnCpCSEf+4seGxrkMMOGtL18kiboUSrdRmIPKNsX0hkvPUOK8t/3g3aZuxb+UBw+ver+KaYKKdaFCO4L1/Nl7BQ/1y2rQ8V2JRTVhNt2Sg5EmR5i6y8XCATU5oj7iIgRdFUtYwOjYNCYvgtrRmgVjQINb437wIYyzUxVB/xcBPl4UHIg++QzCnnkBFdFBFwe1/eQ3GBTF6oObcVsv/D6gbkKRj9g88oqbvfT32k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>-----Original Message-----
>From: Yazen Ghannam <yazen.ghannam@amd.com>
>Sent: 09 September 2025 17:25
>To: Shiju Jose <shiju.jose@huawei.com>
>Cc: rafael@kernel.org; bp@alien8.de; akpm@linux-foundation.org;
>rppt@kernel.org; dferguson@amperecomputing.com; linux-
>edac@vger.kernel.org; linux-acpi@vger.kernel.org; linux-mm@kvack.org; linu=
x-
>doc@vger.kernel.org; tony.luck@intel.com; lenb@kernel.org;
>leo.duran@amd.com; mchehab@kernel.org; Jonathan Cameron
><jonathan.cameron@huawei.com>; Linuxarm <linuxarm@huawei.com>;
>rientjes@google.com; jiaqiyan@google.com; Jon.Grimm@amd.com;
>dave.hansen@linux.intel.com; naoya.horiguchi@nec.com;
>james.morse@arm.com; jthoughton@google.com; somasundaram.a@hpe.com;
>erdemaktas@google.com; pgonda@google.com; duenwen@google.com;
>gthelen@google.com; wschwartz@amperecomputing.com;
>wbs@os.amperecomputing.com; nifan.cxl@gmail.com; tanxiaofei
><tanxiaofei@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>; Roberto
>Sassu <roberto.sassu@huawei.com>; kangkang.shen@futurewei.com;
>wanghuiqiang <wanghuiqiang@huawei.com>
>Subject: Re: [PATCH v12 1/2] ACPI:RAS2: Add ACPI RAS2 driver
>
>On Tue, Sep 02, 2025 at 06:30:39PM +0100, shiju.jose@huawei.com wrote:
>> From: Shiju Jose <shiju.jose@huawei.com>
>
>[...]
>
>> +static int ras2_add_aux_device(char *name, int channel, u32 pxm_inst)
>> +{
>> +	unsigned long start_pfn, size_pfn;
>> +	struct ras2_mem_ctx *ras2_ctx;
>> +	int id, rc;
>
>'rc' is uninitialized, and LLVM gives a warning.
>
>The issue is the "goto ctx_free" paths return 'rc' before it is set.

Thanks Yazen. I missed setting rc with the error code in the failure case o=
f the
newly added code. I will fix in the next version.

>
>> +
>> +	ras2_ctx =3D kzalloc(sizeof(*ras2_ctx), GFP_KERNEL);
>> +	if (!ras2_ctx)
>> +		return -ENOMEM;
>> +
>> +	ras2_ctx->sys_comp_nid =3D pxm_to_node(pxm_inst);
>> +	/*
>> +	 * Retrieve the lowest contiguous physical memory address range within
>> +	 * the NUMA node.
>> +	 */
>> +	start_pfn =3D node_start_pfn(ras2_ctx->sys_comp_nid);
>> +	size_pfn =3D node_spanned_pages(ras2_ctx->sys_comp_nid);
>> +	if (!size_pfn) {
>> +		pr_debug("Failed to find phy addr range for NUMA node(%u)\n",
>> +			 pxm_inst);
>> +		goto ctx_free;
>> +	}
>> +	ras2_ctx->mem_base_addr =3D __pfn_to_phys(start_pfn);
>> +	ras2_ctx->mem_size =3D __pfn_to_phys(size_pfn);
>> +
[...]
>
>Thanks,
>Yazen

Thanks,
Shiju

