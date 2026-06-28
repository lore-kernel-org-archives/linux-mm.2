Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B92C5C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 16:11:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A42B16B008A; Sun, 28 Jun 2026 12:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1B916B0093; Sun, 28 Jun 2026 12:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 958B76B0095; Sun, 28 Jun 2026 12:11:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CC8E6B008A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 12:11:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D3EB98DCFD
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:11:13 +0000 (UTC)
X-FDA: 84929810826.04.47C23E7
Received: from outbound.ci.icloud.com (ci-2003h-snip4-5.eps.apple.com [57.103.91.206])
	by imf09.hostedemail.com (Postfix) with ESMTP id 04DF1140011
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:11:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=SA+dIVDC;
	spf=pass (imf09.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.91.206 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782663072;
	b=4wBOPssqxzBC6ntxObwOFfBC6KMu1TdjuUNkCKOR2unD9ly3xDapUub2bm2ybHiIM3Og5+
	vcZxOHQB0Gz1VxtWHujCepYkSd4vJbzhQBPXFgPfPo/OP+o+veq197gCJtPy9a6lCVWyhB
	A4dEvLC8u3CxSug8sGWLph3XQkwzw5g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782663072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mAOO0o4SBJP+MukLGY3LcWspTKkA+ndkgr8RkyABQDs=;
	b=pcM1eZDXqmEK5lJMhl4qEI5qU1B7vOFr9BBMafzuTmWPcupp+4tcA4s4HCUpZkieFLqJ8g
	Nilc3dmuf5hfq6wA3r1Bxl+BNKQpN9nLotjL6K7lzp97P7N1l0gc1pS3c0EIJd4nuICpbe
	hXK1GOVBeZADsiJlq6ZFOuiUVHWnWiA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=SA+dIVDC;
	spf=pass (imf09.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.91.206 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-60-percent-1 (Postfix) with ESMTPS id 0CDD818000D6;
	Sun, 28 Jun 2026 16:11:06 +0000 (UTC)
X-ICL-RepId: 019f0eff-b53e-7b93-b21c-ac4bb3c487f6
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQhKB0MGWQReCEsLQwZcBlBcHA4XXhtCFUsVXANcDkswUBtfAkIPHBNWFRMLU1ZbE1UXRgkZCF0dGQpQUAVaEhhcFFxQWB5GElYNXQkZCFteUBtfAkIPHBNWFRMdQxkPKwhKBEMHRQJeCyUTCVNWWxNVF0YJGQhdHRkVWgkKV1RHWxtWDgZdH0kOG1VAA18DExQZV1QFRgZDD0xQVFRYU0JcHXMEVAddBV1WUAJaVRIEQAhWUF4IXh9MHA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1782663071; x=1785255071; bh=mAOO0o4SBJP+MukLGY3LcWspTKkA+ndkgr8RkyABQDs=; h=Message-ID:Date:MIME-Version:To:Subject:From:Content-Type:x-icloud-hme; b=SA+dIVDC7PRv4mvw10+waxQSwaQiLDDsD+uiw11UywHlvhjfiYmZV4GZsfK85b+ODy0mhFQM3f2N7kQbL+cbCI1A044HuTTFbfB/23eGOUqf93K/EzHSmWZKcGpL+Gu9enyhRUbxBS8jhGYoMDY7mEBf9RXYB3tOHujXMbzH3MvOJTCI5Uo1NxHxJk1stuo4CBRtQyI1jxf9NNIzocsl5o9VDIhwlKy1yEbKQDI6nLPduHhNFFvJfLt9etoZH/kAJCB+z+b5oXdgEzVzp1+9L2k/ccZuGSKMdx3zX8uR5vklAcUcjXu2uFGplkKSpcs3MahwAw6pXqT+96jsxUl8aw==
Received: from [192.168.255.10] (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-60-percent-1 (Postfix) with ESMTPSA id CF4A518002E7;
	Sun, 28 Jun 2026 16:10:56 +0000 (UTC)
Message-ID: <f7bcec16-97cf-441c-ad92-4364c9c3a2ee@icloud.com>
Date: Mon, 29 Jun 2026 00:10:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: david@kernel.org
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org,
 bruzzhang@tencent.com, hannes@cmpxchg.org, kasong@tencent.com,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev,
 rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com,
 vbabka@kernel.org, weixugc@google.com, yuanchu@google.com,
 zippermonkey@icloud.com
References: <72874bf7-d2f7-4bb9-9211-804533bd5c19@kernel.org>
Subject: Re: [PATCH v4 4/5] mm/vmscan: extract folio unmap logic into
 folio_try_unmap()
From: Zhang Peng <zippermonkey@icloud.com>
In-Reply-To: <72874bf7-d2f7-4bb9-9211-804533bd5c19@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI4MDE0NCBTYWx0ZWRfXw3TTZVdDs5al
 HqteUu03x0zhHuDeHImA290awxRyVzDPYJALWT/i2hhcLbSLLo8iSFhi9EYQuELFcFzGUvDzqZY
 WqXD6D0hl9jO4p1AmBiKq9EB5uvfV7E3WFNxvm5a9NhXKxj1oHV9pTrF7gleprURx7+VdGHfcdY
 ZVL/7o8trWurA6FSBJGzQZXefXmijgONR/68U2I2ln2VecNOaVKQXCbzF3d8JT3a6V6AlPc1Doi
 rzeFu2NPuN+IRF/wUeitFC7ACpL4urSrfAgq6RusBucxpoBkeSpjuGp7Gygt32hVQK1XX+8GIWe
 n5J0QRfp3/Wf52zsjbM
X-Proofpoint-GUID: xjjpjZvuRlOQhwU3p0jGO_NC-BhpC1dC
X-Proofpoint-ORIG-GUID: xjjpjZvuRlOQhwU3p0jGO_NC-BhpC1dC
X-Stat-Signature: 3ib6cr5pfd74fwgdx6xhahho1xz4h3wo
X-Rspam-User: 
X-Rspamd-Queue-Id: 04DF1140011
X-Rspamd-Server: rspam02
X-HE-Tag: 1782663071-737793
X-HE-Meta: U2FsdGVkX18zzEJuElA3JiQKJ2dUrh3dhVndgDYLBQfH4ObSRDV3t4Wnd+HX/l27emBaRWEvWi0HofUOKQlZQa1rd76+SI29zDsMXS+15M7NDqtN6gP43w26pwgmY16Re1wEWBPED4f2LM8/DvRX0w6aqAgmivYcBgTBrOlJINNSu+dSiq3PjPIwj2XG9+HWUDtbnK2jp97ovobYhHNfAONXeszQkMwE741jBRmyP84hG5oXgN6x2477XPw+z54JhivX7OoLIBVg7gmU7aRb48+AYMUy8y/UhqvTA+VzUs/xd8eAiKPkbOxbfEwg7UNIz0vCrVtSAKq9cXq/uSlugyN+IpCdXIFwiLy04gP1f2X/YSP4ldz0y2w9YAblb79hnlAJAI/nqeXIndDR6gzEtSPkV3nzV3KkBHLFVFDLKs+gAYrLc2sfj27fwAEaR79uAz5FQLg8iXLxhET8boBlxARjQeJVYg/OOsAAQDIXxJ4f7dIcIH8zEX4n+6aO+59GFXl9F0u17G7IQQJfopLJW2Z/csZhwMEuUYdeVrexbLfw+Q6UR1Zq8bgPGimIvpTmvhkUBK6cp4gDWVthjK3kkY4JKimQVKEK8OIKVeKuoTW3Hv9Guybt4q53TSgnU6o8erI5fjfGA/6N+AZzXMN1P3Cm1Q0Gzyaum/cOrgNxrRcruGPUMMOvh+LUUReXuDKksJzhAbWljqJEuEwdrqfLxZGkabYM58yWruEK2SlFGF/XkXyNPHgkEM8qrex/+TyZtDSJRG9m4ii/QjiKrF52QnE6iyjapb8aIbvBB+AULUqPc2iWuk8J6TfS4sBLwTzKte1z6PTBIqRiP31TkxSYuoDqnUVBKUUU0xQ5oDuU8qQPUgYkZbJXP61WZmfGwLMyg6VLlOTrqVc173Yd5A3elE9pYIdtB2Jh3zeLT32/2kdwuamRUjOSCgXw+76waf468Faf438apghfFvSXfPN
 fXL/wcSm
 xAv5xmjhVDHYaH4EzK+DpiuwdrMq/5cuJPWWCsnT3130GPGrrK4RCTPfPoKfZvs2pYjGWa2IjHAZak5yOTqH8glj93ZiVjmM9/DWHuDn8dzKMmb3AG9swtrfzSHUgZbY14Tkxcu3kCozVzAaHK2efj+DzpTu+Z+V2MFOeMoR2VHiobu0SYI/WLkT4nS8DPdYLMVl8Cocu9lvWlArSwwncCkg6PBeNJzUeWIsfsbGfXo6yXFM8E8FOjWkMGSw+iOpFXmTM+Z/VT4Auw6JgMDgLGsCxeVcOarx0TSKwJ9wEGZqOMDklfNUu5wDaDQ6QjZqrGO9/gCcFZQbSTgCcT0HlCMf25qB2ma6MAWzI9PT3IhJ9wWtkAAfxEt5lLmlg4dhKFvj4nImxfdIH5zRZNaa1UQSqbId05bhxFSILtDsOXw9Uzh07W+9HezEcLK4TZJE7TgMdEDy3HrQN8Q1XRJMv2lTZwxkVBsSyHzOJvhv+McEFXW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 02:28:42PM +0200, David Hildenbrand wrote:
 > Two tabs.
 > folio_try_unmap() vs. try_to_unmap() Hm.
 > const bool was_swapbacked = folio_test_swapbacked(folio);
 > Probably best in a single line.

Fixed alignment, const, and joined the short conditions.

On the name: I'll keep it as folio_try_unmap() — it's static in
vmscan.c, no risk of collision with try_to_unmap(), and the try_
already tells you what it does.  If the _for_reclaim suffix matters
to you I'll add it, just let me know.


