Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3C24D46952
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402E46B02D6; Thu, 22 Jan 2026 12:36:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C3E06B02D8; Thu, 22 Jan 2026 12:36:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1076B02D9; Thu, 22 Jan 2026 12:36:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA346B02D6
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:36:26 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D7EB914046A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:36:25 +0000 (UTC)
X-FDA: 84360303930.23.435224A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2C0F0C0002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:36:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J2UlAbs/";
	spf=pass (imf10.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769103384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9t9Xol7Q8/sep6nxpCGFp464gvrarPBWKIBIvx6HDlw=;
	b=KfanheIE8m98TFeLS3oiUvIzdOP2VS9HlRsl5OqvOPJI48rLDMmYW039zQNCsO4wDwOlrg
	li1dDP6iGa6bjpUqP/ITWU8coNeQP99jhAuIMATHGdhp0T6ZoCtmaSWfibhhV0I0rFWHv4
	CeRbvontN/26jSrNmk4sOA9QwTpUHAI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J2UlAbs/";
	spf=pass (imf10.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769103384; a=rsa-sha256;
	cv=none;
	b=29m0G5U5NqSIWHn1gs6HHDwaxEfdJ0sA13XVjRc/+qS/Dn0cxSqb6lExqiyveIFendQASC
	H+g+FlzJwdMa/jIn1tFymb37qeiuMjDyB+60lVMEkBEaJqsSP/suv2BtcSDUH6kfiqrglb
	qA37+DXmxOB/nT9vPtUtgDaqIbOdciM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 881C26013A;
	Thu, 22 Jan 2026 17:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E08C16AAE;
	Thu, 22 Jan 2026 17:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769103383;
	bh=LWuS3t9H4s3n6SwgiZKmTr2O9DxNfnIGAD3zPijQ33Y=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=J2UlAbs/vbrkBlyTHAfoan1jPcOAJxwT4BQ6oTfUzQfCjFYnYuBOLhk45uDRuo3H/
	 AJ8YLsNqMPeQk6bxrBUW4PebRQqKIJGaBH3o3sVJ/wCleTmh3Xs3rYCTFcCTV0DjdL
	 lFfljb7U/kwXSMP8Jr+si3Cl0QrOaYVUt06WEriczzOsLxWottOB5M33ZaHWcmER1j
	 Mk4ThL/ejNwhMrlPiTqkuu5YaIQ2gd2Dv060RYhMQ27NGNiy7CnmBVzhiURLuxKoM4
	 Us6ZSRm/FeOLO4R3kRcxyGhfIE6bksw1Y7YGglSW0V6erdeJECMaqujSUGr8LSxRd/
	 1+7wE2rIsVeXQ==
Date: Thu, 22 Jan 2026 11:36:22 -0600
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 David Airlie <airlied@gmail.com>, Sumit Garg <sumit.garg@kernel.org>, 
 Sumit Semwal <sumit.semwal@linaro.org>, devicetree@vger.kernel.org, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 Brian Starkey <Brian.Starkey@arm.com>, Conor Dooley <conor+dt@kernel.org>, 
 dri-devel@lists.freedesktop.org, Simona Vetter <simona@ffwll.ch>, 
 linux-tegra@vger.kernel.org, John Stultz <jstultz@google.com>, 
 linaro-mm-sig@lists.linaro.org, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 "T . J . Mercier" <tjmercier@google.com>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>
To: Thierry Reding <thierry.reding@kernel.org>
In-Reply-To: <20260122161009.3865888-3-thierry.reding@kernel.org>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
 <20260122161009.3865888-3-thierry.reding@kernel.org>
Message-Id: <176910338211.2903017.10944159060341564914.robh@kernel.org>
Subject: Re: [PATCH v2 02/10] dt-bindings: display: tegra: Document memory
 regions
X-Stat-Signature: kb6u4ncayrh87p1a7fxw69x6t9s3zuse
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2C0F0C0002
X-HE-Tag: 1769103384-279399
X-HE-Meta: U2FsdGVkX1/ymAVzBfVDurN3NfMUgdxSriGXZrhbxRhNQ8MidhkJ5eIYB3N6JqcAp7StLClRMIxWxffbqzfYtztV5oXpZfFnqLpcuuuy15ka37b4Hw6g5acog+b8OQL73aJ22gR7Med9g+1jy5j58Yb342jKhtDF/ktMwNyT9SaCyV8aiR2IQV7HIquEN8/ZXpuz4dmhcr2pqURT+TW0/KvTOjJ7hDCdRJt080pbEapqxyttyS2RT/5TbCOQgtDb5tB4rb4+/iAkZzA3t5ujT+ygbH7tfkOmM9RGpQ9nFXL0kZhkvqBeOIgY95PkT5xNLXL/HK1oaIpLhaQIgpymCYdqaheRByaNNxKiL51L2m/I9b/vlOOZOrbRsizsC2z+SSWXZszmnyFS6RiV4CDa/A6aLafCwhpQWE0QwgZ9s1ZlEuZmEVdrA6RqxaIKKA3caAeFAVTwPd7XHD5tO2PQ2EXNQEEHDKETDCSlBp47vxTsgabfsVU8fV5vVOn0zmj9P8n84rtiHrVNeOzcVPRggbbqJNVRUKGpkNZrvWkvBIl0K1gWuiL84h5GQ49VH+g1h+izInNxrkpeIP6u04flWPouUjwUgPXnw4AU4hDrRQegDmCFh9OZkxDxJS2wDMujFIGOfFnBEgv8UjNPgbZ+ZKPrWTwlCI2OCG0+aKbUOUfDFABDOmh0hsXmHtkaPLtsP9l2npNxrxUxQd1plRNkfFtJEZYhGzHzcFibrRIyB3bHMMBEv+MfKxPSRf63BLGwVLgC/DTVJR9PMhZoAhfXSRvYJKgGvsyo82VteBxrVf4Fc/8laozDurr14kA9MvPWeLfeE8zyf3nMeW8wLmQFFwbFMxCb+bt8VPvv4e8k4cXufDM+yO5luMI3u/DAhoEb34jbEygf6xnuh5lWjjZeqR3cUPYo763CWUhV/yz5U0PBOKd1h+iNrEkN7A1mCWdNWt7LvkV7z94jZR7TSfK
 FUmuLJrc
 sgRVf/Tx3cr58SelJcj/o/ALcOBBZtfHq5eof4LUH8gVW+CIE/PDHdJYqA3GwkWMylGqXdNTbdFX0k9RiA7xTX6eI6eJZpoY5bwOZcs9UDUgO2AVG0Wh3u+MXGn8fAz0uXLOxTLkN/H8vfEeTwnpt38iZ10na4p1Iei/rBiONO5u8jxD3ZcrUC0pjmHS+EJ+ak6L2jMvRNrReW+MzawRC3HOZ0h5B7Q7YpEZmfFyJgpW+C7w4XNvw8B9ynwjh4CjQyO9wSWWP6Y9AGZ+E7wE7CwXJUcJcA6xtszjNvjSgyU2klI/MXg+c4Qp2Gocxx1NqknNUVilzesiddDdfpT6RSkGFEUtZ7XY+yo0V62DtnYxjRCBzcAvtUvFESDU9SbEqvYDCw5/ToCQA7zihYWkoOSheZ29EnD1LuZL06HjTTqFsoRclKheRVjlksQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, 22 Jan 2026 17:10:01 +0100, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Add the memory-region and memory-region-names properties to the bindings
> for the display controllers and the host1x engine found on various Tegra
> generations. These memory regions are used to access firmware-provided
> framebuffer memory as well as the video protection region.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  .../bindings/display/tegra/nvidia,tegra186-dc.yaml     | 10 ++++++++++
>  .../bindings/display/tegra/nvidia,tegra20-dc.yaml      | 10 +++++++++-
>  .../bindings/display/tegra/nvidia,tegra20-host1x.yaml  |  7 +++++++
>  3 files changed, 26 insertions(+), 1 deletion(-)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml: properties:memory-region-names: 'anyOf' conditional failed, one must be fixed:
	'maxitems' is not one of ['$ref', 'additionalItems', 'additionalProperties', 'allOf', 'anyOf', 'const', 'contains', 'default', 'dependencies', 'dependentRequired', 'dependentSchemas', 'deprecated', 'description', 'else', 'enum', 'exclusiveMaximum', 'exclusiveMinimum', 'items', 'if', 'minItems', 'minimum', 'maxItems', 'maximum', 'multipleOf', 'not', 'oneOf', 'pattern', 'patternProperties', 'properties', 'required', 'then', 'typeSize', 'unevaluatedProperties', 'uniqueItems']
	'type' was expected
	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml: properties:memory-region-names:items: {'enum': ['framebuffer', 'protected']} is not of type 'array'
	from schema $id: http://devicetree.org/meta-schemas/string-array.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml: properties:memory-region-names: Additional properties are not allowed ('maxitems' was unexpected)
	from schema $id: http://devicetree.org/meta-schemas/string-array.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml: properties:memory-region-names:items: {'enum': ['framebuffer', 'protected']} is not of type 'array'
	from schema $id: http://devicetree.org/meta-schemas/string-array.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml: properties:memory-region-names: Additional properties are not allowed ('maxitems' was unexpected)
	from schema $id: http://devicetree.org/meta-schemas/string-array.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.kernel.org/project/devicetree/patch/20260122161009.3865888-3-thierry.reding@kernel.org

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.


