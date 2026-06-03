Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29595CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 19:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0576B009D; Wed,  3 Jun 2026 15:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 577926B00AF; Wed,  3 Jun 2026 15:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B4CA6B00B0; Wed,  3 Jun 2026 15:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE3D6B009D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:30:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B45B61C1E94
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:30:20 +0000 (UTC)
X-FDA: 84839592600.28.EC3069E
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf16.hostedemail.com (Postfix) with ESMTP id F0568180014
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:30:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780515019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZMEqqBXFv5uH4HrFQch4g3OunQV8fry10jnxLXZrvsg=;
	b=xTzAiyCtLXG2U8Ud/XOw8ZvTNbCDGB2oJMGwdH/fS5KwRIgUnx4d63mHU0blNCCqMQQA4J
	T7hPpjKBjZRC76KIGKJg6gIqRDq0vh8Em2ECElxKSVshZGf0MKbfGbK1Okqjtps4Ijg9jm
	Mf8PYjZ6p9cfIspfMxTb28i6elZYD6Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780515019;
	b=5A28nxMlP3yGOlN8LQf44D3WeN5urNhOPh5UzB9PQ0RiC+++2wS1gXoO0L11PEeDIyXphv
	GqG1KHCrWgefQf1DRdcFF2bZdO63peeLFjbIcJ0u0vSjl+KWmXs5/FSgOKtiomPi9lPSsh
	xq4OSJ2+cEUyrneJXHXvieEDN3kF0hE=
Received: from omf07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5CAE8CC90;
	Wed,  3 Jun 2026 19:30:16 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id 77CD220030;
	Wed,  3 Jun 2026 19:30:13 +0000 (UTC)
Date: Wed, 3 Jun 2026 15:30:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
 "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>, "Luck, Tony"
 <tony.luck@intel.com>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "xieyuanbin1@huawei.com" <xieyuanbin1@huawei.com>, "Lai, Yi1"
 <yi1.lai@intel.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-edac@vger.kernel.org"
 <linux-edac@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: mm/memory-failure tracepoint change breaks userspace rasdaemon
Message-ID: <20260603153012.68a4ceaf@fedora>
In-Reply-To: <b637ede2-73da-49f0-a7eb-70ec79e79624@kernel.org>
References: <CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.namprd11.prod.outlook.com>
	<b930678d-a1ae-458c-8705-7ca9680d4cb6@kernel.org>
	<20260603121707.7eccb9fb@gandalf.local.home>
	<20260603161947.GBaiBUI7C8WWPwD84S@fat_crate.local>
	<0c16bf3d-7c6d-4e28-b200-03b7d0ef714a@kernel.org>
	<20260603130006.7d2c4a62@gandalf.local.home>
	<b637ede2-73da-49f0-a7eb-70ec79e79624@kernel.org>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+Yc1+s+cpTaOQ67esXGNHrUDWcjq+NSXY=
X-HE-Meta: U2FsdGVkX18v7iMYUEW0g3+XMctZ0GI3DcZlcv/LKdYWui6sUi0y9Z+MHojHkeTRXkt3/B9P2leWl/d1Ou7gwWo15wnVZyYSdPzbToSltpamxuc+CAw3+8Wiiha9UQJLJoOuhdw8f8tIQ7ol0VDo6Hc+9rq/yUTrx785LNL07NO4xa6rxAE11vkCoIEHsGwJxZmzizgR4QhnhmqgVxsTkoLS1DONoiWmhgc3o1Ey5dRYmuIS7BpDGnY7ifHIzKf3YQyBLeQB6HwsYHtDe09n5rdbi+ou4K4icYMxalzv9hQkGsqmU2Nr88zht5FHEbd9yDqIRBOiGtH2YLoOsBzK1xf87TteaWrlPLze/QJkcUTCLeasBA9chQ==
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: F0568180014
X-Stat-Signature: 9ak3p9hedcp6mocfyrf6tw1d61i9oadi
X-HE-Tag-Orig: 1780515013-642169
X-HE-Tag: 1780515018-347577
X-HE-Meta: U2FsdGVkX19SsVnPvHIn4iNKtHdy3ofL+GTZun2NG7b3zlEimRcScKFPeCeBx0FgASJ0nxB11mCMK5ISr7hmS3y8La67foMDgEk9Gp9O5Se/vU3fx+qdgQqg3luuh8Nr8MNX0/dFGVLAdLDvl7CdP0hN35pnxvR7sjH42bKbbVl4duBRiuFB5L0x2wYdMC56KtnaH94lcxWQbjnUNxHYMVaP/5BgWPlB/c0dJfOclmpcd73zmrkwmKCknEfjJ3An6D/K7G9JAmaVcTgqKgSekquOwlVBrTlC9Lw9+OTd1tygnOsiW8YFp+VNaEI2ttG7MGAiA2j2Y8+wP0FJKfROw90fzHjaW+OFluhzZKCUWtiovjSLZNC64N8J33ZmaNljt4lyfexanDjtypjz5K+aBscf2QlnQ4UK+2RZRrfY30PdsMZLX2Kq60UPSdCLoUgN7MXBTXcAU315Sph6+gI3cWC7FMwEU9XhB/GnUn/A4rOmBBrAkujOiv2cmYxFEu1Rarxqq8DBl4eLIT78edBueAabDXZgDTj0TeAw98VLI0FeYk791fwNpeXqq9HlsW7M4UKYN8XsokjPn6j47ybORqF2NxCKeL2R+d72cbTqZocrgGdBemfZBopxQrEcchofObr1Nfzuhe8MGe1MdocgbMSP2KhBip017avKvceS95i227dAH+qEUdIZTEQNrexsMjxI17UZTseJMojE+i13YRinPBd232up5p91s1sDLhljfOl5Z6xxozpCS82mUWAUXrFymPWgsE1bKhuurEezWt0sbtzveCfb5cSjxIjCf2uWWzTr6EcaloDDYt4FnRAIwRuZWzxSV6DuGbF7VSuTj66nb8sjKVjIV6HaGevKeMjAeobQ3bAT+nAsXBL8wkQen9SEXKu715LjNG4pE2YvljyzI3xDNyMsQl7UcsUzEfFX1tfNs758vtsaGHbxNLiR3LulNjTAsF1G2px9Bfb
 B5KrTMVL
 y09dRqDeLKkXaA2OHcD1zY6SwoNNDUtz4XMfDoo37T4Qy6W8A46CPxKxKTOjVqlXFqW6K59gbN071rQ8OZ1FNbQRL7AhgF6y5n+nVSHpibVzF9BW4Dv1lnN0aZzoyu6BAG6iG0Iphyi6JouBx0yDLdfYgtmKtJVr4ub8RLGbTiH+LaLOqkW4KNTEqI0pgPcjJn4iHyCEQhkd7FgeLFDKNWvDf6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 21:13:30 +0200
"David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Would the following be sufficient to avoid a full revert and the dependency on CONFIG_RAS?
> 
> diff --git a/include/trace/events/memory-failure.h b/include/trace/events/memory-failure.h
> index aa57cc8f896b..c46b17602578 100644
> --- a/include/trace/events/memory-failure.h
> +++ b/include/trace/events/memory-failure.h
> @@ -1,6 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #undef TRACE_SYSTEM
> -#define TRACE_SYSTEM memory_failure
> +/* Some user space relies on ras/memory_failure_event */
> +#define TRACE_SYSTEM ras

If that puts back the original path then yeah, all would be good.

-- Steve
  

>  #define TRACE_INCLUDE_FILE memory-failure
>  
>  #if !defined(_TRACE_MEMORY_FAILURE_H) || defined(TRACE_HEADER_MULTI_READ)


