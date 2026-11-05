Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8102A606A33C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EZRf4hhL
Received: by kanga.kvack.org (Postfix)
	id 9FF516B05B6; Thu,  5 Nov 2026 07:34:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6F46B05B9; Thu,  5 Nov 2026 07:34:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ED4B6B05BA; Thu,  5 Nov 2026 07:34:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69BA96B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:34:07 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A4401409C0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:34:07 +0000 (UTC)
X-FDA: 85401007734.10.B769F5D
Received: from mail-pj2-f4.google.com (mail-pj2-f4.google.com [74.125.227.132])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0AD9840006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:34:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EZRf4hhL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.132 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793882045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnbdQF+mYCE0wEkhXTSh32IAVnsikEgxzBr/xzLSIyY=;
	b=CnQDvUkQ7pdIJHr27pSQlaiqsWbr+J4L0veatN0TZrV9VZOBRXVs0jup5l37jlQ0cf1Fcq
	b/WXa6sZo7K1JBTTBtv1cW8dB9nTs5Hl47GsIrFnnC+O1bGV+CL8UFFP0Yxmgr7jI8ucdD
	wMkLoRGsawRxMgdEE1dcnuG1ux2bZr0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793882045;
	b=mafcLZJgN+X67dyceWtWxwcQnFXiH80HyfaMEmI9DwHGaTLKU9WqyYVDQ+S041gvfVGwCN
	8/11Ex54zCJG+p/HJxBexKqFYkmnc7/E3hwGfTluwiaiDAu2KVAIcMluqTEEK/LRl1one+
	Nni/MPLp3JuSY1F+X0DgJXgHAAAUkFk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EZRf4hhL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.132 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-pj2-f4.google.com with SMTP id d9443c01a7336-2e96b8bfb43so6622335ad.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 04:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793882044; x=1794486844; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xnbdQF+mYCE0wEkhXTSh32IAVnsikEgxzBr/xzLSIyY=;
        b=EZRf4hhLfV54jDJ5Wa/DLV7IIVO12/nDK7iCBhbxfS1BwEgB8ngL9qexKEi7AKXxjY
         boDAVPLHm4ci94u0DqPPGP6qJmtQNVwxdCdMV7ycG82rKl9b5gZYslQmiMjrpXzteXxQ
         HM2u6Xb33Qp5qa1wH1BRYc6+HE5R9nx7crX9ejAeV1fE6VDoZNTm8rjHNWqx93T7Wu1i
         rsWkgUIU7Fz64MRZHrvlOOl3+zRAc3vQi2fBGQqmNawPwyfMJucioC2sxleZTbRr2i1w
         nsAdtVH6OaEIhywa9L3FTC1TYZv/UeuJEztfDYOLnPuyaQywnx7T10F23bEWXsazXkn0
         5x6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793882044; x=1794486844;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xnbdQF+mYCE0wEkhXTSh32IAVnsikEgxzBr/xzLSIyY=;
        b=uAu71bmKnMtE2e4Cp45a1UR2qsRprfRQiAnK7RuV0NRXSr1MRiAUuMtNGDFlc4/0Mk
         EiWA/kbzT3T3E/wGN+OcJagXozkoNY6NNyo7hRo8rDg6p3gRl6YNXsDqk/vKBGDJKBM4
         u5nDJPMzyuZL/kzKmiZmACqjUrnO3ZcGPc8MR1fBf0x0gQkcaM37gClHGOshDBRBnKqH
         /ORHgHY8CuCYh8h6tAVZa48WXWLtIymN3+FyRsyC6AO/gcENAPfbdL0x5C5Xglvm73k2
         TCcFTXhekvraD6qmJVGE5E96ofICux4p12ZyYPIlREVx12cgz0TUo0CU9+RolbuFcZL5
         BPhA==
X-Forwarded-Encrypted: i=1; AKwUvBxCe4vvJkfE0Fc9ZX+AMLmqJM2BAJCGqA3svdYDT47roDivXTLqfUS/aFTu1Sb2VqF8r9lUoOL3MQ==@kvack.org
X-Gm-Message-State: APuU4Z+VFqH8jMWurgyFT6gbk3MIS3CRVIP/mMEsiyAXFMZkD0YFgg/J
	viF++a0+1lU5CZ35V99LVK0LxxKEgNEAKWZoK+LHVp3/Sonvt2YurL+Z
X-Gm-Gg: AYBFou21zRzS0IOLWBIsfov2cde8Pluia/NHioif/sKjV360cRq2fpQT9E+4quYV817
	PTkRIM6hXhzZrGFRJAku6loxEtsqLmSd3VnUMnH2n1rBYEnAScg+URwpWrKys1gd4k2On90KwsV
	xG/kcJaJnpZ3TAjxhpgq/UcxQqeFWkitWn34+Fh2j2wGTfiLIi8iRRKANQ+7MK5RN+wFJjiWckU
	61ixbLz8XNkQhHDmy8AwFIEAIMoLrsTxezhuJww82h+WzU2OAiZOaqCg/LsFBcR/8iU2AKwPygH
	9O7zfKwdaUTOqF1C05HUB0cj34Ida9ydXjCvk0xlNUddIotcJNp4Vn3udFoURVIXX3Of8+qnBIf
	xBs0FYyxSgPYG5eHX6Mjk7NzxmA6Uj1UyuYrTnj1vamFkfXSLPU0q3NPQ+attdmPYA13ax9qXoN
	vFes9K7/E6X97LhCaeBMbTRvaKYCvGqN7KIDM8zEjJCeXBZ84EGZ7AyiwmJEodg8fK9y1dQidHV
	5SzVp7qD83SWdVPYqm5Zx5sll+z0OwMEPxkVgKlVqc5mYbgx8z/tszb+eDO6OW2L11C4YSby7Lv
	/AcsqcCbip4nrD3/E0HO6EiBoOQ3xqWla3zcv1IFbB/DJbxyv1mSowb7FMyo75kjow821/V6ikB
	KG3rVsCL4Vcvdw9BMr+MzPTYOWWk=
X-Received: by 2002:a17:903:3910:b0:2e9:3dd2:a904 with SMTP id d9443c01a7336-2eb3648b6aemr182844655ad.16.1793882043510;
        Thu, 05 Nov 2026 04:34:03 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed08fe55bdsm17043995ad.15.2026.11.05.04.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 04:34:03 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH v2 0/4] mm/damon: introduce age_ms damos core
 filter type
From: Aveline Noir <jm5905938@gmail.com>
Date: Thu, 05 Nov 2026 23:31:53 +1100
Message-Id: <179388191315.401969.13923237674993632654.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, damon@lists.linux.dev, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Randy Dunlap <rdunlap@infradead.org>, sashiko-bot@kernel.org, 
 sashiko-reviews@lists.linux.dev, Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261105044425.87142-1-sj@kernel.org>
References: <20261105044425.87142-1-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: b45xxshh3mekd1crqro61imbmjap91k9
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0AD9840006
X-HE-Tag: 1793882044-433945
X-HE-Meta: U2FsdGVkX18rk7AgrONmgAUeieL4E3oV50VkOFM6J+gVoAJDRJoUGEZCG/I0OuP+t8bxePEFw+CS7E1hXpvHlkzUXkuYFvhZPFhwhI4EtQcaM0wNLpJuJamNV6i5QKXrRcceQdJdSibv6/IDvUlcCeZe0tZ/84sLT27sFh+iNjhK3Z8kVQL6QdQFk9J29yEVrwo8J9+F2g9rM7k2YPZqvjag+KARyYU3lmz7VpaosSrWEI7rzcDMN/g9jO+ZjU9Cn2U0YFY4XEL8OzatLKHXvTpnS3wR+plO7cTWbnX6ulURsjJpLRWHZO6ET85AbFDEBLw0Zeyxdu+2WU7EJzLLmlQOyPBwNTeJABtP2CyY1qmtP3oB2+ZwJ9NuYolts0igRg7B6ehRQg4mHH5HvGQ9kR3shUMgytBLXrCLPFwT72GnsDnHbAFxiMRDDX/wLrF8m5yQz8gQDcNBYmbPh5T9pRgkgujp0sPLdfpHHX8o11Pue7oxFRF8zhXp588/QvQ3x1yWLHrvwRX+IMXZYCLYlpZyKPHEdlwzk2ZaIiYSX1dZBGXTV+7j+DOWwtjz9BzfPRKYEQOkz07kQUMlh9uEh2rxP3NoX67Q7pG8Z+uHL5ylfE/gLXNgJih4DFd98rqUv5oKr8N5oRiGFHe6A8rK/nsJmuFMGRZXfuDozfd1NgWLymWUFd74dtScrb9mSBkie65O3vs/4fYyOjG/xiZEeP7Eh0cn6bZZLPCHNB8DmrA81Q7N5Fc7symY8lmDqb3mAwZDdArJoLCiqNGEBwxUWOwZfzQniY+X2aIKNuEBOVdNhzCp71L1zsGjWzxV/aSWObhjii+ly+HgN3s9md6rq7wywIcMUOfQjViSq6s4a/qetFXQwAc/QLxHJqQSgHyQqX+hFPfm3bxNWIiZJezK4UfZ1sM22iDutHxvtoupD9xpH/RL3uQ8fGjTBBgj4lGIqwiIAr1FdJTQqqXea7B
 8pfz51Qb
 VfEEgKUk27uc1Yk43hYhFPAyX6SlcsHhyljYAF77YjO5ozZIJph19zgKf2MQ1/jmtJboaHoxTv6pgagILg3hGJroi/PbcfLG33VmQU54M/ytqV7i7TI3rTTFsHQOAbidsZymRV8VZu2O29CFBo2larasDCae2OJe686JenYdNakORhcfF0ufdEl1MEncuRZGJ31TnE0kNpg//lVroHlze14uUFsPOAv+mYJxmMLC2NlpI/GmV5VAACkaxfnc9cUvgXJE518a1nquVsDoGvPKw60l2CTg84v3Zld/SEr/rjKRoRu2QrjhJ1nWFpEZ46rdjLYw/exl2sUx9rpghDV9TLVVA4kf/MULeW3d/60V6yqp63ApHxQjay3KHEnUNZ84DpgNFt0sK8/HNeEXtczGTeTcZBELI0XIRLZ0Zb4GDyhh3mT3/YLz5Gv2KhbDehG0tNMIWi4VhdjPbwVzv7XtmQmaUjKZP6j50+kVsnXnq4+7a8AgUd0SGYxfrX+a7ei4NZPhSJ7/QACdSxuWf1N6kDO53vc/w3ZFBK/VY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Wed, 04 Nov 2026 20:44:20 -0800 SJ Park wrote:

> One straightforward solution is extending the DAMOS access pattern for
> specific deterministic time based age specification.  However, DAMOS
> core filter is a better option.  It is playing a similar role in a more
> flexible way.

Makes sense.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

