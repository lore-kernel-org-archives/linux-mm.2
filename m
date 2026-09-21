Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B763EC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB5FD6B00BF; Mon, 21 Sep 2026 11:21:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67036B00E1; Mon, 21 Sep 2026 11:21:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C696B00E2; Mon, 21 Sep 2026 11:21:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B6C96B00BF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:21:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30E3F160209
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:21:03 +0000 (UTC)
X-FDA: 85238132406.12.6A32FB2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9A4BB40016
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:21:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OBxIhJsP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790004061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sYN6gB7Ijq5F3mQPt8j/w5U9BHlrr8gpwOqMcp1ScAg=;
	b=C9cirJT99k8HCm9PXOJIZT3ZFOt+T1rEhknUUZ6OrYdpeo30OpvLNv+9QPt32OzcT7qxrO
	nRyS9j0EDu+N6R8Mqcw0gtWxfjVcGREpc/Pe3P76yO17yUWQPdFvdEkjTJ9BEKnXXur2kb
	Kwv9V6bXoBjiMEjU4LKg8XXhU1V+gc8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790004061;
	b=8GTfBP3RzxFK4VIGtEvrd5B+fmN6xtFSv8Yp52vxJxEHr9LKfnCyQt2JiSslILJlqnjKQv
	t/b1Iysk0j+49S4/sENBMr1Q81+DAO1mKUMMs4ue33nFqtkpJnSFZGDpw2oPF1SJikUXLV
	f3wj3Ca2nZhUptW4oOMXs2SqYZcZQrU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OBxIhJsP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C047E40F3E;
	Mon, 21 Sep 2026 15:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BD81F000FF;
	Mon, 21 Sep 2026 15:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790004060;
	bh=sYN6gB7Ijq5F3mQPt8j/w5U9BHlrr8gpwOqMcp1ScAg=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject;
	b=OBxIhJsPI6FsskimLCHHwrb8YKf6UPRxsiFCq59DToJg9t5AnuMw/QWSc+aBld6qV
	 NB3NNeRcUt3wKYVht8mQrwSIZ7/mOEejWEpr1fF/Dwd3BpiED8bv/PAPMsLaXsNGJl
	 q2NGUlDPTERSUs4uxPzUsiSo/mS/VKDXMhwjsqHr7hWE48gYYswEiAI8J5HyCcHPA0
	 EPSKVPrlwvmniMaY3C8eAC48YqmZNW9dFf1Lrsc/M2n4fFGXj3kV2L62rgB4CPVW//
	 4lFlmRyZkfTB24GFesazvM4qSuSQ8ITvwJTIy8phGp6Q5YPcDWnSUIR3Tfkim3WJvW
	 aGFFPbZg+71jA==
Date: Mon, 21 Sep 2026 10:20:58 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: sumit.garg@kernel.org, linux-arm-kernel@lists.infradead.org, 
 akpm@linux-foundation.org, mark.rutland@arm.com, 
 linux-kernel@vger.kernel.org, sudeep.holla@kernel.org, 
 thierry.reding@kernel.org, david@kernel.org, rppt@kernel.org, 
 jenswi@kernel.org, linux-mm@kvack.org, danielmentz@google.com, 
 catalin.marinas@arm.com, op-tee@lists.trustedfirmware.org, 
 devicetree@vger.kernel.org, will@kernel.org, ardb@kernel.org
To: Vincent Donnefort <vdonnefort@google.com>
In-Reply-To: <20260921110050.3977591-8-vdonnefort@google.com>
References: <20260921110050.3977591-1-vdonnefort@google.com>
 <20260921110050.3977591-8-vdonnefort@google.com>
Message-Id: <179000402021.412547.18161897733601725746.robh@kernel.org>
Subject: Re: [PATCH v2 7/8] dt-bindings: reserved-memory: Add Arm FF-A lend
 pool
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9A4BB40016
X-Stat-Signature: zad7hi4d9e3kumeowo6nr59ax5x5k64w
X-HE-Tag: 1790004061-967355
X-HE-Meta: U2FsdGVkX18Dut9CEWIGmhT6JZvbyGGTPBHuQg141MZTdAEUaAEhN3GoOQehO3sfMEsggfedtFt3IZjxFRmepIt167Tjfh1CplCsP5M9oll7FN4Yt13rF7AT0asaB2idR4oZWJkcunDjXhqfAsOlv1QzRTYFptJEu1wDgIMPs9ikVC2G8iNpcby2tNLg8fqG60mGe5YDOwhLTtllaXOrPej9bECILx1JAMBOzGjHoMFYtrlF2//KvqyAc8QbgU3+6XOTKZQSCywJ4L0qysgu7quiKpfqiH5jtbHsWMaWiCDthLcpfRmAXo2HciDkE97t6tiSuct4qygMhM0w4vVg3aJDs+3ardVr79Z7bGJSVqg76brk+B/Ys4SWJGL5clzmPQsObZ1ydtGt7OtcQSTZ3jTC8BLowJDEWMTSuLVWOPZHUA75heUVdzOblE8JL15HkdLkNszwYBSRq+Ap/sb6Z+hxQusm5LxksNMqirZu+WcmotkWHLjngFOQZK/o7XEEwnfzg+Pqzy3C/mygL7PZr14WxQIjx3eHMiS2NF5V8zVB5Qb3LIEHH0rP4sac71qGBsjQ86ann/vZiCHy1eLUVDTS1qSxkxAq2ItM/DDSh2Q3Kcl4XQ8HmGPIx5bgmY9jS/PCwdYy6OqY8ed55QXghRDLYzNqqk6hOFlogeRZyN+2PYHgoy1rVVcbd4HM9yD99NsQC57O8L6UkxyoDSR5ucuFotk1sgYdaj8CkCDvCL9PQswcF59PBc1HJ4KYKXe76rRXxueE/p05SDQybcNT952xWiIzBfPr9pDbl68y0fvRCnV8/KM7CmwXFUnxDakh1hjpfLPDRjm3xZgD8x0SjNiYcvI/RPpvG6LBb2Hf3lWoymDpCGUxCHuf1kymPL0PQQihmPEqCyFbR5oFUhRGeL+Dhjxrwh+lXQPg5qRQtc4AaUVWyUd08iS8/XdpYZp+TyGNYQDQfE//td37e3j
 PA8yPJY2
 ejoK7bY+xxTE6pM1Qp7ye6Ji+AsLRK+eaErTrzFPXPoqZ2BZe8ex8ByeeUVdkbVEFoFb5YkI9qEtlYR9oFkw2vAPhnTEQ5hmffQlPgaDCTdUBdWwxSosmIGLTLHRZmLB07/YtksxhZEaPtkyHZ7SSFn+A0BGZeGdtI/BNeQsyTKFApZCEy83w5yJe3sC0Uc7juZu8Qpmu0YYwfU8/QGeQa1bfMQ8JJh/wmHHCU7cfKHZLZW/mRemfYZS6RMprQBwt+jgHwzEoHEYj2cROAUq+PB9GtFf6o15EWh3YfnpM4IGpXEFU3dpOSFN9ia3r+gEbO1yW7tiIQh6hJ6r/FHllkdhbL5SNhMb+oICGdHJPKoAcVgU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, 21 Sep 2026 12:00:49 +0100, Vincent Donnefort wrote:
> Add bindings for the "arm,ffa-lend-pool" reserved-memory CMA pool.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> ---
>  .../reserved-memory/arm,ffa-lend-pool.yaml    | 55 +++++++++++++++++++
>  1 file changed, 55 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/reserved-memory/arm,ffa-lend-pool.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Documentation/devicetree/bindings/reserved-memory/arm,ffa-lend-pool.example.dtb: ffa-lend-pool (arm,ffa-lend-pool): {'compatible': ['arm,ffa-lend-pool'], 'reusable': True, 'size': 67108864, '$nodename': ['ffa-lend-pool']} is valid under each of {'if': {'required': ['iommu-addresses']}, 'then': {'required': ['reg']}}, {'required': ['size']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/arm,ffa-lend-pool.yaml
Documentation/devicetree/bindings/reserved-memory/arm,ffa-lend-pool.example.dtb: ffa-lend-pool (arm,ffa-lend-pool): Unevaluated properties are not allowed ('reusable', 'size' were unexpected)
	from schema $id: http://devicetree.org/schemas/reserved-memory/arm,ffa-lend-pool.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.kernel.org/project/devicetree/patch/20260921110050.3977591-8-vdonnefort@google.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.


