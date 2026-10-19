Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD61CCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 05:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E31596B0120; Mon, 19 Oct 2026 01:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09226B0122; Mon, 19 Oct 2026 01:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1E706B0123; Mon, 19 Oct 2026 01:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B347E6B0120
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:00:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 35768A80BB
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:00:42 +0000 (UTC)
X-FDA: 85338175524.06.BEA643A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 38010180005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:00:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="a0VF/tta";
	spf=pass (imf16.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792386040;
	b=CU+gTjvGgd+nHUdWZyx4VCB6kvsldcqyza9dbSuLHMik9bpYaoldpKYzYgvRvCpQVxCTex
	MbUzPy/Iw/MY72XeUpfe1TYnV87TAaW3UthCEWx69ugenWke3kJN3vfCWCIC3TFiAXQje5
	bFBcZglsJPMnBBHlcDrys77+MNKnppI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="a0VF/tta";
	spf=pass (imf16.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792386040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trJxfOdGMmGPD4wULnd0WACTIKb/cR1ipDUXsqkxIZg=;
	b=wzVRMDF7buGKHBSjwQ0W1jq94AGOOnvvkWVx1XMIYj+kxjdNEFlafwKtU6KfM62EU4G4SL
	Uqa9NQYI8mmJNUVN4YKw2e6YpF2qkiXi6XRTxEAe5kuJTvwXcgWHjoN5SM7OAthuky4xcM
	b1qe8RwK2htjfimCDPwUAT7gRyUNq5Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 270A91476;
	Sun, 18 Oct 2026 22:00:36 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA5933F673;
	Sun, 18 Oct 2026 22:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792386039; bh=MpFXJGreFC947YOltE/B3dvQz4LgDH3h21f59hHEwMY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a0VF/ttahHJY/sgcOLILs9GCKnmV6no4P6mR2TGUNcQXP9b5xmzh7MLKTsWeSjo1t
	 eeR7yREp+doEhnB25y8EnTyBQkFA/vG3+7Zu5Wtde9KgSTRZgFQvhATrGq4da0pRUU
	 pIaBw8jgrCtX4KqP0cBR2zwxRpiuOewhk2JL1OQA=
Message-ID: <964ec917-39f4-4309-8dae-fa41e2df16ed@arm.com>
Date: Mon, 19 Oct 2026 10:30:31 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] selftests/mm: check that MADV_PAGEOUT skips holes and
 swapped pages
To: "Gregory Price (Meta)" <gourry@gourry.net>,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
References: <20261014175756.2035176-1-gourry@gourry.net>
 <20261014175756.2035176-3-gourry@gourry.net>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20261014175756.2035176-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 38010180005
X-Rspam-User: 
X-Stat-Signature: 5taq4br4sufzdj8rio7oyukj4yak5d5b
X-HE-Tag: 1792386040-658160
X-HE-Meta: U2FsdGVkX1/tXn0OAiLkv1Vq8TaBNRaYETtEnT452hJI0YuBW2pSgLcj1qVczkZe8epK5k9ehRahqii1ARNjkjBA4s5KTpduDE+/JzFYs979lDlt46M1jMkdYsXZeYGXvzV7ezCJT0lIfZbsTc6+8m9FNAaoOT1HAO2wWSUrMX32Jjsb/4fc9PbiSX87KLLI/v87bgdk+mTCy7iNFjpMPYq0MiW7MHyHd39zfEs08JGGDoMJv3SC07eXuP+/S0yu/Hw+xuFOgH2NyOYpFgAmCOmZjGiLoaM5ykGur2fybjX7FOTwHrhIyGu3kRfORaD1xDpvWBH4X2qZHBQQcFsBC6HUbuHizQGLbaDlKYD7guI0Iijy1FxDZz1mkA+DWxHz2Sas0BeuhvvCtr2U/PMW5BMgl9wt/xHBPApGqCTYpQvwEvSGXUuEl/EawlGIAqmraHMKHGHtwLaEHuE+XrkvQM7lzA6Eo3v9rkE6t5Y0qBJee8xiSL65YJhDhd9ar4AmeapVIzrnh5BIeFIXkqNiogiIW54eEbFeFCR70251iX+QmTdoEgSJUcE9gFFEFwUIE3LwQUgqdRDrhCEWsc/QFKu0TJzY0lHF5mJ6VGXLHh9ClUqEOPDj5+oSCIYwzS9WvKn3KTm0FsSBWVDXngmW8rT+xe7XWQ7DNitlW5P8IX78aawzRvu6SM50FnxxdOQjNBE4kwO1RIBnPOFKuxerU9kIEEwIaxGV6eS2g3ve9UBd9JpIIuCTgN6waW5NHPbIiVd2P48YLQpRwYzCU8TydE7Qcg8lyq/kR3KzWT9EOxmlbAPcC6w/S33U5yQj8gkck9tUjjn7n5d8lTery9t/5L/x+xKq4QDE7bP7w1jiGX/4B/mFm81ehNrbL1sv763+46+QXvq/SqydPjKhqmZz2zeQT3tl2sSzqrQaEBL6dQOba3pW+CdAiI/OlRAEbvu9hMgk9rPFk9STrzjKxg5
 jgXQ+3yh
 CNWlDkpBHL+26KDLA3AzmipReP+ArU4CUXdZQyk2I93SbSH0GnEKV6ZVeHfMC7dImhpVEyuY5ghwWGEYoWZoTFodRvlzbPhH+8pu/LZ2BJnswDuLI/CbpX+x9KqULGTFRS/ZfwaHFPDSZ7AeRPWaL5P44MEzDSuyAYmUZntgiQxugqoRBSJuvfcNUWbrcpG8VdELnRRdsJh/8awP3N8oWhAFq06PZ4xOVRR2+DVr6DB1Rq4/6Yz2260YekAyj2nu4mTjcd8ReCqkbnFxVBCcySmEhx2uCu5NTOCLzBqv7nrsjljz7fy0o2aQzIq4sSKfzXGv1XY0pfn3KKPGmOOHuiMj3iybuFIWFG3bQP98ncpZY5BHwJRrgRawZh25M+6e9rtKkoCg/j0Xhwe7EWL3LsW43Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/14/26 11:27 PM, Gregory Price (Meta) wrote:
> The contract tests check that MADV_COLD neither populates a PTE hole nor
> faults a swapped page back in. MADV_PAGEOUT makes the same promises, so
> check them for it too.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  tools/testing/selftests/mm/madvise.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)

LGTM.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

