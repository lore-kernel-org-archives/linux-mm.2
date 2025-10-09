Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FAACCCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 12:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93B308E0030; Thu,  9 Oct 2025 08:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC588E0002; Thu,  9 Oct 2025 08:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DA5D8E0030; Thu,  9 Oct 2025 08:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 679358E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:37:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE78013BECA
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:37:41 +0000 (UTC)
X-FDA: 83978527122.04.6ADD62C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id EB2E9160012
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:37:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lpVNI5GP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760013460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bc7Qbdz031rGeQiwr543DPxZW57aCmxmgUx3ouo0t5M=;
	b=eUm2ieJFaMGLYv6EI6OyH+ROcNGXGoQuaBEo65dfd89jO1VIZnNEWkwMTJ+6FvlA1UkyCM
	PeeE9TRfm1QNPuK1UCKeZXA7sVo5mKre6uXpByLy3imWbOZsfRGDOZRc0pP7OrIKhpD99N
	2JEBovhe2KBZSaiJa4c5iiicR+ww5xs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760013460; a=rsa-sha256;
	cv=none;
	b=nnoyc8FLzV0+4T6v9H9UntmSZnD80OLyDqKBd8zsZYrFHt0fuNp/fYVW9BKrVaJSGshEyn
	SLMKsXLOMDtzbJLRGXDSI91cLZWcef4ZTR6zwQ/yLirEUvY1HDcVxTYfAvtX7tz8OBA2bs
	yHZXaMjfUWI3O8SV60YhI4oR4Vg1pJ4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lpVNI5GP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A9FA4089B;
	Thu,  9 Oct 2025 12:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1255CC4CEF5;
	Thu,  9 Oct 2025 12:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760013458;
	bh=azd9FVCjk0aIj4ni+YQWAJAY9F/HKDjvW0AfWT0OlKo=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=lpVNI5GPx3+9zLTr6fIc28Kr+bKLW7kKmT4TlSKdjdwNxM9DoPkWtk3j3BZaDgklH
	 YuNjCvc4VqSq1v7swX3OuldWGdI3Z41FcJkecOo4F8DzPxKtn7jEDfLKkdzvkE/dpt
	 +Qe9nPnM/1mfGXsVpxp02XOtenfCd/kFeiAHLM3E8txzqil3zs/jMdng85Yu8I0kmZ
	 JQZeYZuoKYR4EAogYd16fbuqFnMYr9hnFI9UTk7K7j+w3BdCfLPVm6YiRGPglFU6QK
	 36uc9cA6hmhJ5a9utKKm0LYMhgS/tDprx3Xfadx5tktACf7FGGgrCR2HHaaBR8E54q
	 cIkI4jy9nU+Gw==
Date: Thu, 09 Oct 2025 07:37:36 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: devicetree@vger.kernel.org, Palmer Dabbelt <palmer@dabbelt.com>, 
 Rob Herring <robh+dt@kernel.org>, Paul Walmsley <pjw@kernel.org>, 
 Alexandre Ghiti <alex@ghiti.fr>, Emil Renner Berthing <kernel@esmil.dk>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-riscv@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor@kernel.org>
To: Samuel Holland <samuel.holland@sifive.com>
In-Reply-To: <20251009015839.3460231-16-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
 <20251009015839.3460231-16-samuel.holland@sifive.com>
Message-Id: <176001310599.1845440.13113067302880070823.robh@kernel.org>
Subject: Re: [PATCH v2 15/18] dt-bindings: riscv: Describe physical memory
 regions
X-Rspamd-Server: rspam01
X-Stat-Signature: zecsw9axibud9z1dtjep5h39x1coocyx
X-Rspam-User: 
X-Rspamd-Queue-Id: EB2E9160012
X-HE-Tag: 1760013459-855636
X-HE-Meta: U2FsdGVkX18IlqB3UiYmWtM4tDJGXOhf0mEvsA9mWSIHnrC5NJpGtPR7ioAh5Wp79kGpgP7yx1HmIW4ZH/A/R9YgQbB2mRbLlU59ibBNx1R0iMaNOXniQleqNtKx8+a45SRsUfPaXi28+RXytp2+cM1pnRhT48OJvMsCrb6KeaA13XeuK1umD9DoirKEMFuXTdfgT8gZq9RWIIoxppIZq0Nm3LOo6PvHWWv89YBKquerq/EZef/XS9qCz5k/EM2gL5rcmZasjHW6MUFew25iKQ3X01XiV6CovoXKomxlr+D/TlWUV678KSl+xC1SQAW9nFT5Tv8tKabXtQedNps5UjU6GqEkWBzdJqDSOq+afgjVZI1yqeFfTOxVwduuJ+Tr6KzosS645ZDrdlXkrWAt/5EUMP/CYmcm3VMlGVXIwdMeIYrMSg6GqsFyNdb57a4bKlv8arTadE27XBIs7Slin6Gktx4tqUYXDSNH8G9svsk6Zo1iNRx4LuJX/FyKDGy32TcCLPQgfD9EcNbCmLswiiM25pmYXWsI35Up22s/q9CFQAKCDrqJ4rWFt1qZK+w61lcqfOqEcY1BfjkYk0udHPery6/6stc+8lCCqhYo5J1/jg7KqmEwcZt8O+vRQiSs/VfOCgELEaRDCAWz4aKeyxSLXQjUkT/VG98SVFbDMuAKf16UR35PZjkACPt2DsXFt+Viwjkm9krua2k+Q9eoRGL0K59mVhf8UE2uj83yj5J+kbfPnjPFdUVscGN/iI+zygE3HR0vlp89Qko7qEPwE3j+SIDM8eINDSOZ16DAsBngkEJsJ4iXeg+5KNK8z8z1zDWr6i2nNE3ipP37PQZuY/LnMhP3lknSS2MDJI0StNtiKD6U/2/CMDUWutbFev+RAv83/iPF+4n1VNjYl/LMHRNR4SUNE8NZez/kRtB5LJtrNckYcYm+boej5Idi5vrQCFymwy1XnwdshvyYxHi
 K7mArC0z
 8eyCxL+WLVvXOnd3MpDjZGmL6jGDzJzQztYdoqr6a9Er/oc0lCBT0wXKUMWIomWOjad4e389yTIqGKrWzbHzXHVuDo5Sp03IZtojfEsJN2Mgb6H5EDN9uM1rjwsuSpePKGoHQTkSos6vyxutNJlOLZuNxydc+P8WKaKRhaSixJy2PEWY/f3MuzRoBqIEzWGmGP7PCeg2OJR+EofdJuNwvs5S+yV51Xls23iJp6mX74bVxj+GMzfEYgOchbKz2H+b1v++wKv61LqzzaRn5W4hPxGzP+yoIRvhSBrEk7x4vECgrEbWMBj3dpq9d8eNyRT58lzoPzW9ukPmHR4EaTYeekjdGi07W7eRoNLtpnDw23So14GRlYnqKiDsQlZyd3xPudAcvN20RbOwhCw32s+hzeBkzqH6eb9icitlfpvkYjQxLURLlrAiqYwHtOFwK70wR1Pr2156Lo9mN/78o/ipZpWLvcFJXfIszsyroVbV4OiIj2dJ5xYhJSu0fSPt5QIs7R9RB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, 08 Oct 2025 18:57:51 -0700, Samuel Holland wrote:
> Information about physical memory regions is needed by both the kernel
> and M-mode firmware. For example, the kernel needs to know about
> noncacheable aliases of cacheable memory in order to allocate coherent
> memory pages for DMA. M-mode firmware needs to know about those aliases
> so it can protect itself from lower-privileged software.
> 
> The RISC-V Privileged Architecture delegates the description of Physical
> Memory Attributes (PMAs) to the platform. On DT-based platforms, it
> makes sense to put this information in the devicetree.
> 
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> ---
> 
> Changes in v2:
>  - Remove references to Physical Address Width (no longer part of Smmpt)
>  - Remove special first entry from the list of physical memory regions
>  - Fix compatible string in example
> 
>  .../bindings/riscv/physical-memory.yaml       | 91 +++++++++++++++++++
>  include/dt-bindings/riscv/physical-memory.h   | 44 +++++++++
>  2 files changed, 135 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/riscv/physical-memory.yaml
>  create mode 100644 include/dt-bindings/riscv/physical-memory.h
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/riscv/physical-memory.example.dtb: / (beagle,beaglev-starlight-jh7100-r0): 'model' is a required property
	from schema $id: http://devicetree.org/schemas/root-node.yaml#

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20251009015839.3460231-16-samuel.holland@sifive.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.


