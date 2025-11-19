Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A1E0CF6487
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 22:41:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B538F6B002F; Wed, 19 Nov 2025 17:41:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADCEE6B0095; Wed, 19 Nov 2025 17:41:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A5546B009B; Wed, 19 Nov 2025 17:41:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8693B6B002F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:41:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3EF47160674
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 22:41:09 +0000 (UTC)
X-FDA: 84128828658.30.50083A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9BADF1C0003
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 22:41:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J6nhLkGs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763592067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNNyzAvT37GxfbD66hG6BtD4VOfte8+FRmctAE5cf0A=;
	b=X5xtcI2lM1sZfnDfltW6megu4MUCFJUR6bYWJmydSypC0OJJKH1+OFjt30tY+X4eRLBUzO
	XCzXxvVMwYk9ZK2vSjNUadnHHOXchSpI0Po+LlpLMOPeHQz+T2NNg9xoZ2L5PSLyoothLh
	rSfJOQGOKaSUZQQyiVpYC+FekKYXDzY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763592067; a=rsa-sha256;
	cv=none;
	b=LBnzgxVwgyLWC7zNlKfbmBbdxl2QATFgsMOGeB/M1wJhaEX4Lf3ODclEFaj8LMxGEf5/au
	gR3IBzik9sTN37X87IAWpS2zPYmv9AcH/f+cLoSsz1jfblcgIUFROctaGrqusN0LEbGozw
	gh9kGN9AtierSDOtK/N+HJ6I8SZtsys=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J6nhLkGs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 184E54171A;
	Wed, 19 Nov 2025 22:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0ABCC4CEF5;
	Wed, 19 Nov 2025 22:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763592065;
	bh=621P0U/ZMt9tfYhYpJzFH9MENbuLn8U74VwfdbaCPcM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J6nhLkGsqbguAOhXecSgsGeAmS5FWmPuncCmtlhyfugKFhj4ajks8EEEfm6I2n12s
	 85/HMv7UNfckOzrYLWFGN/4fh4McgSbveXPT+BX03o5hwYrHo0CYjzXgVlHoizRmGs
	 LGEksWxWWBPskpE2YaglnX9OvbYv+b/szfG0L2Rn6QZLkdBClnHgBLwmj0AV0h9kpF
	 GnF2Iz17WrlWEXzyOJ/+EYr0lHQ+YjV05Tv0b8MgPMAMGAruWq//Vua0vm5rzYpZ94
	 we/VjSi2R1VClnL6MFdBCDa5FeDqPAzHpO007LFlJm0v43VqS+K5TWrpVO4vV/gCVO
	 I0T2b/JvorY+Q==
Date: Wed, 19 Nov 2025 16:41:04 -0600
From: Rob Herring <robh@kernel.org>
To: Eugen Hristev <eugen.hristev@linaro.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
	pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net,
	david@redhat.com, mhocko@suse.com, tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com, linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, jonechou@google.com,
	rostedt@goodmis.org, linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org
Subject: Re: [PATCH 25/26] dt-bindings: reserved-memory: Add Google Kinfo
 Pixel reserved memory
Message-ID: <20251119224104.GA3371358-robh@kernel.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <20251119154427.1033475-26-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119154427.1033475-26-eugen.hristev@linaro.org>
X-Stat-Signature: cj6ie88pbhr47f1bs6pk6uxxnn59quqk
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BADF1C0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1763592067-367094
X-HE-Meta: U2FsdGVkX19koZx6gQ9adkDbGjaIQZ6tQaRpMULpXuOdIDS+/t5M6vHqU7efSM0moHwfxeIvPKuxNGKzk0vTnX2oObIGLcB5B05oi1MOi8/I9+D4OFaFDQQEeRqsT/l+YOLpsRM/ilU5BIaWuCdEfXmYCVvLWoHXdjMxZRVxgSiTZCAIpQS3hlp7FjSpQ4ZUqJQycFpl1oMxPJCtfskOIpHcEC0gC6WroOgUiKfXmgSU7KZFQBDW/azUayJKaMNAkKN11+jBQZkr9tg7U23A/lz9fPmkXJ7eV6owRPdQA2RIq9Lv11EJDAHV0qsW2i77fqeyWPGqHCJUXqWJQWSQ3WM0wYS1VXUs4jktKi/lVwOiZB30L33T45qMyPjNOB9A9+SQqg+KZbjKonXSC5AvfObmu5H8aWiJ3FZhczvileUxNGPrCkN7nhqvmvf8Cf+RrAGKPuosvSxYww/ofSRp8rdvoL49QEdoKsKwoZ+V3dmyZlpdL2BjTKs/uZy4o16hmgiTTW2HE3PB2QO7yGAkkG7+TtMnuvnoHijU7dIB0pve+HBPpiRpsuEXU26wB1AT59ka6xYF6xD8gMyx70cE49FuNt2KWL+2fnpr6kPkL4zwQRMEL1F7Tuc3HIVHVaEG7vZ3pY/Eow10LL0wfZwQy7ijqAN+D9GWx0zojSQh03h+jbQz2RrSEl5jKj9zyUFFR092sn/hBxAiU8CdGoM3l+M/0ecTt7QNRNN+FCil2X0FiBNm8NkfQisNQSJqek3WsfhmxdnOBm0wj12JWJ2c+x5MoSjW2NFk4wRn2P4F9XyRJjDpev2sPZxq+zDnseeA1Us0DES0Ja2yrEKmIcIW/NBU/QGzq500ROdKMivAkp8QfhuANDTr9yGbMlHo8bbnTalL1uMj1Uj58gW9lO5XzOUc6wBvQE0yW8fPDtOY+FPucW105Y6HRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 05:44:26PM +0200, Eugen Hristev wrote:
> Add documentation for Google Kinfo Pixel reserved memory area.
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
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Google Pixel Kinfo reserved memory
> +
> +maintainers:
> +  - Eugen Hristev <eugen.hristev@linaro.org>
> +
> +description:
> +  This binding describes the Google Pixel Kinfo reserved memory, a region
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

Just put the google,kinfo (or google,debug-kinfo??) compatible here and 
that's it.

> +          reg = <0xfa00000 0x1000>;
> +          no-map;

You don't need to access the memory?

> +      };
> +    };
> +
> +    debug-kinfo {
> +        compatible = "google,debug-kinfo";
> +
> +        memory-region = <&kinfo_region>;
> +    };

