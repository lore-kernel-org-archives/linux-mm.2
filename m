Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90B39F8A16D
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 12:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF6A16B0005; Thu, 16 Apr 2026 08:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCE036B0089; Thu, 16 Apr 2026 08:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABD826B008A; Thu, 16 Apr 2026 08:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A5EC6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:25:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2ED7DBB77F
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:25:21 +0000 (UTC)
X-FDA: 84664339242.01.9EC5AE6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6FBFF20011
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:25:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GQGv29sX;
	spf=pass (imf13.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776342319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EW+81uRJG1PkQDI7vy+71C2mKk60lXiMxe7+Z/S5SCE=;
	b=K2SQEEWfaGsjsLg+is0jZPu7RiP5VL86jp+pulN8XrKyHPVaBblbu9ebs0MoxzwU8D8xda
	lP3qZsubGjeKE4Iy3Kea1Ey2ZMuEbxFpttgBGVWCUSzzevOsmKhx7Do0PCXdFG1iaTlYJV
	xfP4Fdk4kNnZPmwF3KxYiiLmIWNUJD8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776342319; a=rsa-sha256;
	cv=none;
	b=dy4rAa7iLarGqJ/UTBnX1etYKm6rSVCgZs0mmkzqwjvwJ7WIJNXHbNU58Z2D27yYH1ynJg
	dx3yOfNgv30RiiDTpgvl7S+/dpze/SDpa6qiopwLZxEwHbjzKhEzAqshPI0Rb+Sv/L6XhF
	ftObGiujzurWuTsLrx1jIgWMfxVaiyE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GQGv29sX;
	spf=pass (imf13.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 54A6B60126;
	Thu, 16 Apr 2026 12:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4797C2BCB3;
	Thu, 16 Apr 2026 12:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776342318;
	bh=gECMS4EGrtN1lWkNcMdqV1cQaJPbxrgRQTXN3zouHSg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GQGv29sXj5S5z7UPKnXaUJAuD1qc92DQaWs8UXQ6wwBCK62RBOeMuB3RtNcxzLs+n
	 PPcHL7L8pFqT/h2G0bvvPkUySB8nqp1hX+g8DsxNBEPpxoa8+yXm1bMdZVixBjqxgs
	 n60V3osh+8lSW6pt2nDmsfqoDHDW6Auv9CDrXKgdtoPlM9Xla54AXl1OSAYSKpcXrA
	 NmL+fSV7Qk/BTzx5WK8y+vV+U+fxOTS5SiuiemUg0UByoPARoWSlKdZYhXUYnMvTFf
	 DgJsTYvf1ogHE4V/gC2FO90mA6aK9sVcz0Z1Cm9dDcGVpaCAj1nCKENYb7/YBcL1F4
	 1oc9q29NjGBrg==
Message-ID: <1fd72d1b-f5cd-447f-ae11-6f4d4426b8e8@kernel.org>
Date: Thu, 16 Apr 2026 14:24:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 55/61] interconnect: Prefer IS_ERR_OR_NULL over manual
 NULL check
To: Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org,
 apparmor@lists.ubuntu.com, bpf@vger.kernel.org, ceph-devel@vger.kernel.org,
 cocci@inria.fr, dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev
Cc: Georgi Djakov <djakov@kernel.org>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-55-bd63b656022d@avm.de>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 xsFNBFVDQq4BEAC6KeLOfFsAvFMBsrCrJ2bCalhPv5+KQF2PS2+iwZI8BpRZoV+Bd5kWvN79
 cFgcqTTuNHjAvxtUG8pQgGTHAObYs6xeYJtjUH0ZX6ndJ33FJYf5V3yXqqjcZ30FgHzJCFUu
 JMp7PSyMPzpUXfU12yfcRYVEMQrmplNZssmYhiTeVicuOOypWugZKVLGNm0IweVCaZ/DJDIH
 gNbpvVwjcKYrx85m9cBVEBUGaQP6AT7qlVCkrf50v8bofSIyVa2xmubbAwwFA1oxoOusjPIE
 J3iadrwpFvsZjF5uHAKS+7wHLoW9hVzOnLbX6ajk5Hf8Pb1m+VH/E8bPBNNYKkfTtypTDUCj
 NYcd27tjnXfG+SDs/EXNUAIRefCyvaRG7oRYF3Ec+2RgQDRnmmjCjoQNbFrJvJkFHlPeHaeS
 BosGY+XWKydnmsfY7SSnjAzLUGAFhLd/XDVpb1Een2XucPpKvt9ORF+48gy12FA5GduRLhQU
 vK4tU7ojoem/G23PcowM1CwPurC8sAVsQb9KmwTGh7rVz3ks3w/zfGBy3+WmLg++C2Wct6nM
 Pd8/6CBVjEWqD06/RjI2AnjIq5fSEH/BIfXXfC68nMp9BZoy3So4ZsbOlBmtAPvMYX6U8VwD
 TNeBxJu5Ex0Izf1NV9CzC3nNaFUYOY8KfN01X5SExAoVTr09ewARAQABzSVLcnp5c3p0b2Yg
 S296bG93c2tpIDxrcnprQGtlcm5lbC5vcmc+wsGVBBMBCgA/AhsDBgsJCAcDAgYVCAIJCgsE
 FgIDAQIeAQIXgBYhBJvQfg4MUfjVlne3VBuTQ307QWKbBQJoF1BKBQkWlnSaAAoJEBuTQ307
 QWKbHukP/3t4tRp/bvDnxJfmNdNVn0gv9ep3L39IntPalBFwRKytqeQkzAju0whYWg+R/rwp
 +r2I1Fzwt7+PTjsnMFlh1AZxGDmP5MFkzVsMnfX1lGiXhYSOMP97XL6R1QSXxaWOpGNCDaUl
 ajorB0lJDcC0q3xAdwzRConxYVhlgmTrRiD8oLlSCD5baEAt5Zw17UTNDnDGmZQKR0fqLpWy
 786Lm5OScb7DjEgcA2PRm17st4UQ1kF0rQHokVaotxRM74PPDB8bCsunlghJl1DRK9s1aSuN
 hL1Pv9VD8b4dFNvCo7b4hfAANPU67W40AaaGZ3UAfmw+1MYyo4QuAZGKzaP2ukbdCD/DYnqi
 tJy88XqWtyb4UQWKNoQqGKzlYXdKsldYqrLHGoMvj1UN9XcRtXHST/IaLn72o7j7/h/Ac5EL
 8lSUVIG4TYn59NyxxAXa07Wi6zjVL1U11fTnFmE29ALYQEXKBI3KUO1A3p4sQWzU7uRmbuxn
 naUmm8RbpMcOfa9JjlXCLmQ5IP7Rr5tYZUCkZz08LIfF8UMXwH7OOEX87Y++EkAB+pzKZNNd
 hwoXulTAgjSy+OiaLtuCys9VdXLZ3Zy314azaCU3BoWgaMV0eAW/+gprWMXQM1lrlzvwlD/k
 whyy9wGf0AEPpLssLVt9VVxNjo6BIkt6d1pMg6mHsUEVzsFNBFVDXDQBEADNkrQYSREUL4D3
 Gws46JEoZ9HEQOKtkrwjrzlw/tCmqVzERRPvz2Xg8n7+HRCrgqnodIYoUh5WsU84N03KlLue
 MNsWLJBvBaubYN4JuJIdRr4dS4oyF1/fQAQPHh8Thpiz0SAZFx6iWKB7Qrz3OrGCjTPcW6ei
 OMheesVS5hxietSmlin+SilmIAPZHx7n242u6kdHOh+/SyLImKn/dh9RzatVpUKbv34eP1wA
 GldWsRxbf3WP9pFNObSzI/Bo3kA89Xx2rO2roC+Gq4LeHvo7ptzcLcrqaHUAcZ3CgFG88CnA
 6z6lBZn0WyewEcPOPdcUB2Q7D/NiUY+HDiV99rAYPJztjeTrBSTnHeSBPb+qn5ZZGQwIdUW9
 YegxWKvXXHTwB5eMzo/RB6vffwqcnHDoe0q7VgzRRZJwpi6aMIXLfeWZ5Wrwaw2zldFuO4Dt
 91pFzBSOIpeMtfgb/Pfe/a1WJ/GgaIRIBE+NUqckM+3zJHGmVPqJP/h2Iwv6nw8U+7Yyl6gU
 BLHFTg2hYnLFJI4Xjg+AX1hHFVKmvl3VBHIsBv0oDcsQWXqY+NaFahT0lRPjYtrTa1v3tem/
 JoFzZ4B0p27K+qQCF2R96hVvuEyjzBmdq2esyE6zIqftdo4MOJho8uctOiWbwNNq2U9pPWmu
 4vXVFBYIGmpyNPYzRm0QPwARAQABwsF8BBgBCgAmAhsMFiEEm9B+DgxR+NWWd7dUG5NDfTtB
 YpsFAmgXUF8FCRaWWyoACgkQG5NDfTtBYptO0w//dlXJs5/42hAXKsk+PDg3wyEFb4NpyA1v
 qmx7SfAzk9Hf6lWwU1O6AbqNMbh6PjEwadKUk1m04S7EjdQLsj/MBSgoQtCT3MDmWUUtHZd5
 RYIPnPq3WVB47GtuO6/u375tsxhtf7vt95QSYJwCB+ZUgo4T+FV4hquZ4AsRkbgavtIzQisg
 Dgv76tnEv3YHV8Jn9mi/Bu0FURF+5kpdMfgo1sq6RXNQ//TVf8yFgRtTUdXxW/qHjlYURrm2
 H4kutobVEIxiyu6m05q3e9eZB/TaMMNVORx+1kM3j7f0rwtEYUFzY1ygQfpcMDPl7pRYoJjB
 dSsm0ZuzDaCwaxg2t8hqQJBzJCezTOIkjHUsWAK+tEbU4Z4SnNpCyM3fBqsgYdJxjyC/tWVT
 AQ18NRLtPw7tK1rdcwCl0GFQHwSwk5pDpz1NH40e6lU+NcXSeiqkDDRkHlftKPV/dV+lQXiu
 jWt87ecuHlpL3uuQ0ZZNWqHgZoQLXoqC2ZV5KrtKWb/jyiFX/sxSrodALf0zf+tfHv0FZWT2
 zHjUqd0t4njD/UOsuIMOQn4Ig0SdivYPfZukb5cdasKJukG1NOpbW7yRNivaCnfZz6dTawXw
 XRIV/KDsHQiyVxKvN73bThKhONkcX2LWuD928tAR6XMM2G5ovxLe09vuOzzfTWQDsm++9UKF a/A=
In-Reply-To: <20260310-b4-is_err_or_null-v1-55-bd63b656022d@avm.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7q47m4e9sjmxnnre7yp5ka6wixr3e59q
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6FBFF20011
X-Rspam-User: 
X-HE-Tag: 1776342319-357259
X-HE-Meta: U2FsdGVkX19+roR58WDgNYyWtjsZ5WNvgZfdux8Ho2pChu6IV9q1b13yzrTAM6MmhiGwZfqKWeqQnGjVSkWeZTKz+3PGSAT1qV/8LavXDXNjfsIfsTMUXse49H5WohQgJ+2+rIjb4jxGoI4POFE6XwOLc6mtcZSS1qWKEmIScY+T22xHl1TRADuzaXA93sBdLOhtDU56m2WfnA3dWFAMEtjk+52lhLJxNwmyhtSlhtPW0I4BXxL7ZL0DtOjhLANH8rwVCZyz2czo2ulVtXiSCVAqi1P2sXccsUDhgKhiJjmpa/kxJO3j6Ick675yx7Mtq0PjxfKABWKXHL9x3OLquxMtV8u1P7kX1v8fAZYfgVrxv2N5+SZbKWUbWI71XzQzEGDBq0IS2DQu+FuVB3BdWbrogyC2qN4h+pkbVYYik2pDZLXHRpbdIy573QMCUOSJOb57vE4hohCHItYZAePY2DHuEXYKT4tbgy1DFmEULpqZGxwdAKcEzTYEiaQbF9dwqvw6z7By0zudw9XpJrh/mK04UjPWxwLPsFOmfPowGc6O27WPZ5nDpDoBBeZP+Zjr6fbFXcvWRDbLhDcu2NRrgCn+dAucMXYIqcKWf+41+P2Shj6zSCY2LMreYjSASW/aU5dUOovDruSbeuLPiixtIpDBVyRkwjSutG79Rrb5oAZsesyPG8VH/kWVZxhSj5hvKExJ/oMHg2OTxXfs8whG6any8PMcTFB5fcQXzzIewi9WUBdyHaStVJ283UcBlaZBCeszjfNE/3D8bLM9KgMD+jXvBGocWsko47Ja89Ynxx+YNeDHR4j04oI9EssZQDHriFySzNZYhD1QBq24vCBrloUp9xbT3w9+stQCm369K8vftPAVPI7S45OpDkZGTiT1FGTzp/HYfvruHxLX7/Sui5BB8/+tJc9yAwA1I64k6bwJglnV64bwdDtHrkkKY7NfQo0bK51p8t4P35UVlOK
 dS+VUYmH
 ywNbN9+dJmyI3I1zJr0+qpWtYpRqDKxtZGkdQ/V5mLmIINQ58U3D/DD2BcOwrKgIWaDodZyx4gZdUD63+UqTlZvS/fdBgTHGSVhOmpyWlUjx2b2aZ/09uAPzdsYekIpjYymFhvuyyFdTub12aEuWqFy0PgrHFvjY43MUUNFbr3oGccipHMF4I7HFU7KsPlmA+AfPwXSubCvVMGU10xHFEd3LfVYGTSNbh6mrViY3U0zL/hWSHP7XCX290W3wBmRjbOmMNFfHlHDKo2AAJiXsc+rBKjAGVgzdwElt42wwidZCT6/XtBQ7rPc1BX5ktSZkCzx3XCo5POkPnFO7gH6LNfiDyjhTCDRf7UAA0BbHcZ/PwqmI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/03/2026 12:49, Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
> 
> Semantich change: Previously the code only printed the warning on error,
> but not when the pointer was NULL. Now the warning is printed in both
> cases!

NAK, read the code

> 
> Change found with coccinelle.
> 
> To: Georgi Djakov <djakov@kernel.org>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
> ---
>  drivers/interconnect/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
> index 8569b78a18517b33abeafac091978b25cbc1acc7..22e92b30f73853d5bd2e05b4f52cb5aa22556468 100644
> --- a/drivers/interconnect/core.c
> +++ b/drivers/interconnect/core.c
> @@ -790,7 +790,7 @@ void icc_put(struct icc_path *path)
>  	size_t i;
>  	int ret;
>  
> -	if (!path || WARN_ON(IS_ERR(path)))
> +	if (WARN_ON(IS_ERR_OR_NULL(path)))

IS_ERR_OR_NULL is simply discouraged, but beside of code preference, you
just added bug here. This is clearly not equivalent and you emit warn on
perfectly valid case!

Best regards,
Krzysztof

