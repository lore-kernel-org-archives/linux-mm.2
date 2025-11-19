Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DC37CF3943
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 16:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A2876B0011; Wed, 19 Nov 2025 11:02:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953216B00A7; Wed, 19 Nov 2025 11:02:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81A5A6B00B9; Wed, 19 Nov 2025 11:02:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1216B0011
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:02:31 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13D8113B174
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:02:31 +0000 (UTC)
X-FDA: 84127824102.22.D6FC1DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3965B18001B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:02:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hH4DrJg0;
	spf=pass (imf06.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763568148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=151gyubu2o8MzWYp3PTTQKW5Qbqj1WX/Go72qpQ9Z9Y=;
	b=0fc+bacC/n+QykXqCdkm+XfKG0V/pjCYR0vZkOdRYgzfbWJ3JOVpJ3iIZsKpxESl5GEeZ/
	6/AKTrG/vWQS8vSwXZQQCFeEw5z7uFPNkUocjMJcIKxAS6Ffeb4BC1nR6E+tVsUGGunAve
	knWILSTy3Drc/ewZy931jbvsMQPIchU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hH4DrJg0;
	spf=pass (imf06.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763568148; a=rsa-sha256;
	cv=none;
	b=guRJLI77t1lgJjArkWRfSxXrxME+ro/GdL2FHKPJt0LSwsFb8DFi8ACCDBPywkLcNVQSI5
	d5T6/PrISnNqQdz4ghbcrpXtF/xQnZ8CRlG8M8YdaXvtM1Mt3fBvdMiBuJ5Q72+gNc0dXc
	cslibCBDsXesOWlExiORQZg5KsS5bWo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A5F06016B;
	Wed, 19 Nov 2025 16:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9922C113D0;
	Wed, 19 Nov 2025 16:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763568145;
	bh=K6PMG4xSz7AcDJUWlqk2vPo0vVj8q+VRUlhpYysoEc4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hH4DrJg0JrMfS6V4azkeToN8uUfmwBchOsNW9Lp6DH2PGW0FPmjqSsUQ7r0MkJUjD
	 ZG95HzgnVqb/2yT6O/UMFuAdgVdOSwIQgM/BNMpAIo+YsyJiW2VRMKuj2+QZDpjehZ
	 1MzIVhY18a1VHigFeOk9Ev0DM0fGuEgoynUXFUw1qCg8UDKYwnNxyTcAeMu6+EAl9g
	 QAHgzyYoO7Ra1732ERS6soiwCGFd63RA/3PHsUmBXpWKh6Q9pU6RSktzMCavUQ3yNo
	 tPyn6xRSnpgsTs204hx01ut8a8VPFTFXViMcJh3/T1MGXHwYGvQNl5pfxTC1fy0fBZ
	 VhPhfSbuGiNBw==
Message-ID: <e73bdb23-c27b-4a18-b7e3-942f2d40b726@kernel.org>
Date: Wed, 19 Nov 2025 17:02:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/26] dt-bindings: reserved-memory: Add Google Kinfo
 Pixel reserved memory
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com, rdunlap@infradead.org,
 corbet@lwn.net, david@redhat.com, mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
 linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <20251119154427.1033475-26-eugen.hristev@linaro.org>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <20251119154427.1033475-26-eugen.hristev@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3965B18001B
X-Stat-Signature: 6n59d9acda6mezn17fmmpfnzsu1brnsj
X-Rspam-User: 
X-HE-Tag: 1763568147-330684
X-HE-Meta: U2FsdGVkX1+8BblGT3dvurL/aNIiHuFeDAGvTu+O/t3mrFAN5kb4pzh7wl4HGQOvUgNqFHyX6M0MYEWExsRuGRrU3CJJ2DTAwvcv73ERAbAe7gN/wahkvzC7FqpTPgCd85ALhaUBj/i21skGjo6Pk+3x35fhbwSHuT9zxKcFc0Pg9oMyQRhNcVcXB/LfNoGqxiXfdaBnlUJyOecMfT1lZVu/qSvA7xu7NvPIutcLEgRczAmqkx/0j5pAHXr+oa6AlrZiaIEoqVs90fBGLg0CVuNdpGSOsyCNAA+0kcLQCkJgB1YlhC2EpmEMFMtCGMVq/hW/rLSLLtXxl7pXMfmn8KuqLwatV7CDP+BmVsgo5OkZSSp2mK9gUh9eI806gnfb9ZzGS3RssCTmpyYi7AxQu0JSW7CSNpENXpoGVHWxQFkZq8Z66jvxPC0E79wM8lU8ICoNHyySKDABzHk+SAiHSP4wVWsvBRKkHorWG2/fhqPblIf+iOufrlTJjtaWBW1ZPSIRpcCONDCW2QGt8/tiNSuvVmpuU8AraYy6aep+8lq/s7TTeQEoDRBiM27qP2UkI9re7l9qaGQ9oEaY1DfAcMfTsksDox9WkwpN6aPQr0Vi4RXg225RB/OCAW+z1IaLqdps+PPWSwrI0DVLqg0uoiOBopkI9tyf/qoQAKeu0vmLPFgmSQhScE1pFtO//uDO1f8YNpHGSemL2gvGtY7pZ8ZoHsgpy9PJUxRvV2xjZQhIK5fP/PPRKtUrI/4ioq1RUKq6lRrT3hQF3QPuV7sByu+b1LBNtChKv17PuwdV4kHIGf577/p4agkYb4yHHJ6XmOsPm1f9uXDh3yl9/t05i7DBZdE9H8Q7zzvz9WofKtWWYN0lbPqgGJgBvMyMbvnnrb/PEwFRZDm6DeDg3VluRVco2G1zwYMxI+6xN6mKW9YEYowmjN2WsfYt5v9PjS5fcs3zievN5G9ted1A1W8
 sQneZ0Lb
 +eBfmvDuwTx9I9Nh7oaXwzdbY06H1UKZn7QrWFZbECpJGO9pKK3/P7ePHCoFqGAvkEp1fJq32ud/m8tcVBT8GDAZFxjjepUPNuwaaDCDrr6eoB9I+xpdRhrg5583cbcG2bU8Eyga4sxktx6eIUxtHQbZtnDl+UsRQALsIgLLYasiSBfA6/o9wzSyU1U5rM12rIlvCZBv94+feL3WEaUOxWYPdcOdpkTLTbbdO+LMYnBti+kPnzPHXywHK6I2n3CFd2+WYyBfOMHnGWzf+INu+oN6J6Q0a1YVmd99S7k8vTcbjmN+M9mnJ3XZVQ6oHNg8jdwOn2X5PQHR9Pdc62lR+lsf1e+YaNQdzG91g/SpPQPBSz9mAF44nbnsztw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/11/2025 16:44, Eugen Hristev wrote:
> Add documentation for Google Kinfo Pixel reserved memory area.

Above and commit msg describe something completely else than binding. In
the binding you described kinfo Linux driver, above you suggest this is
some sort of reserved memory.

> 
> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> ---
>  .../reserved-memory/google,kinfo.yaml         | 49 +++++++++++++++++++
>  MAINTAINERS                                   |  5 ++
>  2 files changed, 54 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
> 
> diff --git a/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml b/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
> new file mode 100644
> index 000000000000..12d0b2815c02
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
> @@ -0,0 +1,49 @@
> +# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/reserved-memory/google,kinfo.yaml#

Filename based on the compatible.

> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Google Pixel Kinfo reserved memory
> +
> +maintainers:
> +  - Eugen Hristev <eugen.hristev@linaro.org>
> +
> +description:
> +  This binding describes the Google Pixel Kinfo reserved memory, a region

Don't use "This binding", but please describe here hardware.

> +  of reserved-memory used to store data for firmware/bootloader on the Pixel
> +  platform. The data stored is debugging information on the running kernel.
> +
> +properties:
> +  compatible:
> +    items:
> +      - const: google,kinfo
> +
> +  memory-region:
> +    maxItems: 1
> +    description: Reference to the reserved-memory for the data

This does not match description. Unfortunately it looks like you added a
node just to instantiate Linux driver and this is not allowed.

If this was some special reserved memory region, then it would be part
of reserved memory bindings - see reserved-memory directory.

Compatible suggests that it is purely Linux driver, so another hint.

Looks like this is a SoC specific thing, so maybe this should be folded
in some of the soc drivers.



> +
> +required:
> +  - compatible
> +  - memory-region
> +
> +additionalProperties: true
> +
> +examples:
> +  - |
> +    reserved-memory {
> +      #address-cells = <1>;
> +      #size-cells = <1>;
> +      ranges;
> +
> +      kinfo_region: smem@fa00000 {
> +          reg = <0xfa00000 0x1000>;
> +          no-map;
> +      };
> +    };

Anyway, drop, not relevant.


> +
> +    debug-kinfo {
> +        compatible = "google,debug-kinfo";

Device node with only one phandle to reserved memory region is a proof
it is not a real device.

Also,
Please use scripts/get_maintainers.pl to get a list of necessary people
and lists to CC (and consider --no-git-fallback argument, so you will
not CC people just because they made one commit years ago). It might
happen, that command when run on an older kernel, gives you outdated
entries. Therefore please be sure you base your patches on recent Linux
kernel.

Tools like b4 or scripts/get_maintainer.pl provide you proper list of
people, so fix your workflow. Tools might also fail if you work on some
ancient tree (don't, instead use mainline) or work on fork of kernel
(don't, instead use mainline). Just use b4 and everything should be
fine, although remember about `b4 prep --auto-to-cc` if you added new
patches to the patchset.


Best regards,
Krzysztof


