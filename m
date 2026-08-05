Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00F28C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2DCF6B00A3; Wed,  5 Aug 2026 03:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F04CB6B00A6; Wed,  5 Aug 2026 03:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF45A6B00A7; Wed,  5 Aug 2026 03:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B61C16B00A3
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:04:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5826AA03F3
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:04:03 +0000 (UTC)
X-FDA: 85066326366.08.6557663
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 749E34000A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:04:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DekxllV6;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785913441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rKp50+ocaiucP5R5HsU/6H4F5Nzmq7E60wr9XF9/R7I=;
	b=hURSGrgQxY1uxHcxSzfrM01DgGY0ol/L+jv8KB/NirLS9xIhjLLfDSHosz4zlKuLFfK74a
	KZD+Jo35V7KB/eBE9Uuuix3M9lxUWKGvDmsjn5CJ8qIaeJ8W/WaegBUT8Tw+VZgz1tTVfr
	VGtUskc4hgVyo4sLKNJdydH/w2ADsh0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785913441;
	b=yXU8ZoKjHBCx2tSKcDbIjuk4i1LHWNLsxeNpdCQ16BWvfAAxJbnolS71IB47G752/UMUkb
	QCx5VB28cM51dhxoQKjDC4wtbFfG0nyCa7a+CBV5m8xVy86lzPeOJIXlUyH5HfIqHJmzCO
	V4u4GHGnp6iT3s9XLTy76pMu9KmoFUM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DekxllV6;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 13AE5600AE;
	Wed,  5 Aug 2026 07:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCD61F000E9;
	Wed,  5 Aug 2026 07:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785913439;
	bh=rKp50+ocaiucP5R5HsU/6H4F5Nzmq7E60wr9XF9/R7I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DekxllV6vtLhpWxreWu3mz2Nigf6gm7lGotQAoEW+MXtoY5O1FtWdssPbOi0aa31X
	 Ar/i28APUH6wakpazB+ZOiXgPIMOIDX3w38+B5Hj9TWhyrC2AM+VqFKqZZcGiHQXq0
	 OGiCx4M72MDvcAtv5AAS94WEMp3cWiwgVmo8KEBT5nUJF69qtfUBPFQkED3kcT2YHB
	 fFMAHfIcUUUhcZZz8vLBvrg/iBpU6R/VFw1pqdZN69+6CpfpDsao5nNutoLtdxDCan
	 cKx5/O43W5wuy9imAj0RUfsHl+bLY7fXaRkuus/nHB9VYVDpjfYL5ux/NIjR0d17qo
	 uQ+l0l+eiYMew==
Message-ID: <ef88270d-6e89-449c-bb4d-7a6203185b2b@kernel.org>
Date: Wed, 5 Aug 2026 09:03:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch 0/3] lib: add synthetic MM benchmarks
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <d6787a7f-3213-2b2c-2de5-af3b02daa21f@google.com>
 <cec6f48d-8857-49d6-a24d-b072482bf0c8@kernel.org>
 <c76621a4-cc8c-b6a7-732f-633d372477ff@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <c76621a4-cc8c-b6a7-732f-633d372477ff@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 749E34000A
X-Rspam-User: 
X-Stat-Signature: xsit67au5ms7yej97chpatxhpoengci6
X-HE-Tag: 1785913441-84865
X-HE-Meta: U2FsdGVkX1/RD1OvzhQoHc8GHDDvcau30PgJ55KmGsjZ3esJMoCpCuqZczFBnp7oU/2gAB7DJxYJlnvrVYsxR4cafvdlP6RtKUyYq1eEDThTSNt2z1GWx0nd7kwXpMBAJDp2gGq6NJgZk5qKf06ZYMMR1TVWStlbGhOP3bENDGlp/OkQh/T5UClZqWGNddPFPcQcAIkSxFy/AqvKii8obb5vXRwSSKQm86D1IxzEy93LXrQE0XBUKJYb/2Ql+1NKDiC08JHoBo3D9UUCD8sXTYYW4WO+fMPIcn9FTgpS3jGuYsPTZaLayFyQhBifL2UUgsi5ZMsibjUbW5RUbbJz8HWHv43/E8er3oCeqLjfHLS2Qt7IKKG9PLqb67/V7vUNHGSMlVMCpA2Ng2WclkHwlXne2ztfoBqDwNhnWmw/IbxWvXyfTCz6eW+n1nc15q1WJj4bkRHHR4f3zx4QHinDoUe+W7Nstgu8cHnFwyNaopPjjSb54BgFBLw5f+j9anjCfF3hTILcNcTIyyQ1sk9hOs+G4gc0jhATFlm69AO56MhOlpksSNw10IE/qKssLidZDlmYtaYKu1P2XAigVKGrYcD9j5LTvgMrZA5DM0IbF+2lIsfIMofrnl9u8DiDycPU+jsjRYUROdfGKqw/2F5v+NLRGPcTKaSg+AtYXgF7foG7j7ZQBmk8ahIpwg1SmttxRC+gj4msepauEOB1VrfmNSkNq3v6v4LRA1cqgxkyGGDHlNMfgN4nM85WMgH4EMr9DJn4GOayzNorwOABv+bD67pVZo+m9sHDjg/l1/+kzbY8Wxk2MR7UvDscEQFKmIPBTqJIoKHwdSivt9uPiCZMcUBIiwQZDH3y3jaObWL7ps+G8KV3/YH/6ht43bJduE77+oanbgG0vLv3p37uVLo7sDBIn5Nz3wZPvsz6AAwndFulVcdHsnACcht/Q4VYwBUKhcCR+186rXzP3llrlVu
 eipZqB7H
 RB29NL+B7J+oKWe4cGjdrl6sqmyLCwmxSmqAFY9oMYIVb+CM5jXR7lJHBWIzpespoNZjckO7L8fDG4nxhCehyq9EiojcAEXNz0/8c4PCsNBzw9IoxAqRS50mCx5AQuV7UBjWVKzoOi0RmDYA2oq3THmboV0nkDIxuaGNalhtPfyc9exH/oM0uDYApdxTiEjWuAE+GfCd//iLopWvv4eZhZ7eNaPpShG0WiC89kEuI4PuHEEH37pFkCpoWeIh+tc5x/mGw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> But I also wonder if these test modules could be placed then in
>> tools/testing/selftests/mm/ instead (or some subdirectory for test modules).
>>
> 
> I thought about the same and just followed what appears to be the standard 
> convention (like test_vmalloc above) for lib/ for now.  If they should all 
> be moved under tools/ somewhere, perhaps we handle that in a separate 
> series?

Yes. Right now the lie effectively unmaintained (no mm M: entry) in lib.

-- 
Cheers,

David

