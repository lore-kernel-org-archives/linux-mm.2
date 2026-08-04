Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83908C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 21:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7720B6B00C6; Tue,  4 Aug 2026 17:48:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 749686B00CB; Tue,  4 Aug 2026 17:48:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63AD86B00CC; Tue,  4 Aug 2026 17:48:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38BFD6B00C6
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:48:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB298140305
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:48:29 +0000 (UTC)
X-FDA: 85064926338.26.039F768
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E9DC48000E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:48:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FWmZBXqc;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785880108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnD1aY9umXKgJ4BX/UkaEqEF7nCIFCkN3FqzmwMp/sk=;
	b=7bPv3Jo2uAslgej42TLCW96PzjCmEYBsZmzmOdeIKxjtNd0iR2w/6WWG9ihy4XEY+Hy3Il
	vnKvNCsGVn2KAxvd199qjuHmZKib/sc26vYOaVMY9U8RjflkGACaT+VcezVx292Bp86iZG
	iaLgrPE4xkOg7j6lFYbZfcXGzskrCTM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785880108;
	b=2sHVQXKQpB0Hcmnc9jpvKB3dNMAm6KeIh6RIyNzdWfJd1WLPlvwx4NE3+ZrwnzoHrhJDqZ
	Et51dLyaU4EYFwyVVPvK9IQCVfC8m6trrQ3ctybzFL5aSe9n47OgCAOaYm+v11a8GOFVBt
	f7QOSqLq1sSLYK6i1/U3aQnSFwihmR8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FWmZBXqc;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C1B740C42;
	Tue,  4 Aug 2026 21:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7E71F000E9;
	Tue,  4 Aug 2026 21:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785880107;
	bh=hnD1aY9umXKgJ4BX/UkaEqEF7nCIFCkN3FqzmwMp/sk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FWmZBXqcB3Idi01HEF+CZf/fEEpvgebfW3IQU5I+fqVB4HQp3R3crRPVxd6JfW9KY
	 EWWbYdFrbBWv/h6rv8zlKwwfM8yq/yejMkfknY0dOrzIuPHpXDBx7YSZE4sDMG3xum
	 1hWBMMWTopZ24hodB4HHFOoa32B54AVhKSd8jUMXI5tR7h4TRBSTYq38+qKSDUoDJm
	 oLU42Fd3T8I8X81WMlz0NGHvHqImCed/IKBwnNOiK5VcPNTZRbGZCBcHrR8rZsvFgS
	 vwtRT5pxsfRCV+v+1bJw7BRo+WHw4hOmOnLo1FSbgyj9S5PnmtGOfe5/HrEzSM+ybp
	 Pp1W+rF9kGXRw==
Message-ID: <4baf6edb-c84b-4da9-b905-4d40d4bf5fdc@kernel.org>
Date: Tue, 4 Aug 2026 23:48:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Mark Rutland <mark.rutland@arm.com>, Yang Shi <yang@os.amperecomputing.com>,
 Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org,
 urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org,
 akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com,
 agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>
References: <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org> <anHuLy52o5S9Nlwp@lucifer>
 <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com>
 <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org>
 <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
 <CAHk-=whjfRaeYsAVS9VfYO5uaSB43sT7zPOmNWR6gC8h=t60=g@mail.gmail.com>
 <anIhSGs70TTzymHM@lucifer> <8d6119c7-2216-fcdd-d0b9-cc60ccc8caf3@gentwo.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <8d6119c7-2216-fcdd-d0b9-cc60ccc8caf3@gentwo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E9DC48000E
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: u46kaqkcj3ptjg6zsonmb495wzwc7p5b
X-HE-Tag: 1785880107-604950
X-HE-Meta: U2FsdGVkX191yjP/1bXq5xA3EAonBrQgxZ7FT1AH9dXn5+nVCGAlbHu2kaa3l9cQ5QuU8OOY7len71htDwpRmpQ5rB8zs6+tWUMlHr9dgD3DtkbHn5uDkIsJp33Aw4JkfjIUqCZzeA+qqQ5uRSe6OkJCigvk6OwEKg0yFuFa0g1Jzuv3e+cZJDgCDDXFrw8QVWM/YpEh0rMtJ1DsgplGrQoQycrhbxWA96jm2Bwz9AE4x6f3T1MbqT7DZ0JQPsPsxi2R130NxqmsdlTzkU7C8C81zcrPkCzO6Gix8GgkokWX0zmrPXmF/sYubie6k1F9rK/tPRO1Aur9BMtlrRFrHGA4ro4inh4MYLB0E9p9iqVuBYhzc6o+mUz7PIVXDS7cMmEL/Qgn30hoq3dSqF7uEcDIzInXoNj7Au0xS+rTE51IwGhSkQ3oBl5K68+kdAq9hIAgBEUOM6k65h8M3Jp1eH+c/qETP07ooUx+pUNIZD33pwj8jvYDpGeJo8DDazV8G714FCANFr2NJwfBN9YrgixU7ZEvcB4iWkYUth9yxGpyh/HilBo0vggYJSdFisEgWxk3hOCvjAjX+NKqQPzQrGc5IbQce3+6whQ/ddQkymdLMTzggyxDRCKFdqv7q4SgCIc8C/LEHw22hfX2+xtVGE4e6f3J+CtazjAzRfNhwCTMCXaS2CC1c5Id3ZJx3QvyanGSgiBRApvUXdj89HeD4Ppt6w9ZL8STKNet0l328Ay/31KSS11wM09mihspNyL8G2Bvh4jk8DO4EEJkajl2iU7xl1FmLujR4eRozYi8y259PBLY6sgTpWF0dJ73yISPBGy7VuVrplmS4vSKsAFgW7q207itrmEUtLmVkLiywetSwyMMQ7Pxhtkun6HXCyn+3OgzteiX5op/MhnGnnCP3ATBCXNQaqKtakVg/FxIijmJHFT1wSY2iORyOSLPYFcujQRHW5B0GVcKQq6ZdJ9
 p50stQH6
 JG9mgdxzKNQO+goQfsY0eHIAkRSAVp7CCGCJ8lgkiq1k1E9tWVf7HJNlm/GsjtdndQSZRrqetUcJ7DhwWIjYJtx2TK95L3w3iMdudHix69+XECNaAmCVexDMzIXKFuH8fz/BU0d81WJFI0HU849LtWmkMrz0eLrNalxtzO5bbRCKuOW9EVZIuKBq6vP1AKPiOJwoo33GTwk7wyaqd4lgpL+LDtApFlUydPyBPCEkR+Zf1c2ih90Vueq7JufJecx4FT4HjeNXBizdJKDMOMLeJs805svMbTX8lpaiM+gf+l3UPEM62DjJH0S+Dow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> These are operations that are key to the performance in critical parts of
> memory management and this code is replicated by being inlined thousands
> of times in the kernel.

Cool, then it is easy to show the difference by running micro + macro benchmarks.

-- 
Cheers,

David

