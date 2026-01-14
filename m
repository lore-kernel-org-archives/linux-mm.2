Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFB74D29FE7
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 10:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C96F6B0005; Wed, 14 Jan 2026 05:49:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 477026B0088; Wed, 14 Jan 2026 05:49:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37D0E6B0089; Wed, 14 Jan 2026 05:49:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27E7B6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:49:28 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E0D57B98F1
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:49:27 +0000 (UTC)
X-FDA: 84330247974.02.6502307
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 05BD41C000D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:49:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZalrBIh+;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768387766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yHljD2KSk+AyOLhFgKljoeT4RVHw13m3ZypQFkUkChw=;
	b=25u0WSbSOIDfgw6dqQv5CDRZqN2FWZTtGHbyAIV5aDRbqggP/vBNbs09RqlvCUSxmKSBl6
	ElRcu+H0TFFAmMn2oe2UGDPZpwLFgrT0iAoSGd8QznWuKTJMchjzd5Fd4XpX2sWz1CukgL
	/0qDGCsLaGE1IxXKo+6SbtVlYvXvRPQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZalrBIh+;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768387766; a=rsa-sha256;
	cv=none;
	b=LDX6ylsspUovwjRkQv2jAVn2qr+jfS+B75Ez3iFTDCXaaz5JTF7x7sgQlto8L8G7raU4JM
	YjcIofVX/DocBvAX1UUNrIZKTWZUhn7WSfOAaP48c1Q1Uk04ie56bUTuTkcZLmdWp9Tp+q
	JD0m10DBkNs/lLuMHUVoM6zlynPFg5E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AD06D40982;
	Wed, 14 Jan 2026 10:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45EFC4CEF7;
	Wed, 14 Jan 2026 10:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768387764;
	bh=79/0LC4XFZkQa9FcixVBMSelu5diVWBx5HiiyCfVe6U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZalrBIh+6TpqN7ymyXJCpyYRdW7dF3W8SHHJm8rtm4xILFsYOGZ1dYTT0+5OJuITx
	 FAF+b88uA8O4ghuRa0FYLpUH2HMkIDWp1zQ/wH4dWLTzXl/f52M53Weh7lUAJIUtYd
	 QIMO8H4LcGaYyDDipdBsn+13+EA9Yo594MvVJ4PkMk9/i8hwn1re6TZKqRuFLDLieF
	 b5CbUtqCpzlGAVDLThfdkLSY9Q0nU18U6jHNb6C2aeg2fMgX5W6xEy+xTduL1NPwVv
	 /xYDwlwS6XmoV8fvratJYauAscLKY/ixlIzEJjty50BxwlgRFyRxAkk0hmF4Hk/F5m
	 n36k2s8+S77vw==
Message-ID: <6a9db6ff-2fe8-4be6-baba-7db7913898f2@kernel.org>
Date: Wed, 14 Jan 2026 11:49:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] mm/memory_hotplug: return online type from
 add_memory_driver_managed()
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kernel-team@meta.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, osalvador@suse.de,
 akpm@linux-foundation.org
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-5-gourry@gourry.net>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAa2VybmVsLm9yZz7CwY0EEwEIADcWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCaKYhwAIbAwUJJlgIpAILCQQVCgkIAhYCAh4FAheAAAoJEE3eEPcA/4Naa5EP/3a1
 9sgS9m7oiR0uenlj+C6kkIKlpWKRfGH/WvtFaHr/y06TKnWn6cMOZzJQ+8S39GOteyCCGADh
 6ceBx1KPf6/AvMktnGETDTqZ0N9roR4/aEPSMt8kHu/GKR3gtPwzfosX2NgqXNmA7ErU4puf
 zica1DAmTvx44LOYjvBV24JQG99bZ5Bm2gTDjGXV15/X159CpS6Tc2e3KvYfnfRvezD+alhF
 XIym8OvvGMeo97BCHpX88pHVIfBg2g2JogR6f0PAJtHGYz6M/9YMxyUShJfo0Df1SOMAbU1Q
 Op0Ij4PlFCC64rovjH38ly0xfRZH37DZs6kP0jOj4QdExdaXcTILKJFIB3wWXWsqLbtJVgjR
 YhOrPokd6mDA3gAque7481KkpKM4JraOEELg8pF6eRb3KcAwPRekvf/nYVIbOVyT9lXD5mJn
 IZUY0LwZsFN0YhGhQJ8xronZy0A59faGBMuVnVb3oy2S0fO1y/r53IeUDTF1wCYF+fM5zo14
 5L8mE1GsDJ7FNLj5eSDu/qdZIKqzfY0/l0SAUAAt5yYYejKuii4kfTyLDF/j4LyYZD1QzxLC
 MjQl36IEcmDTMznLf0/JvCHlxTYZsF0OjWWj1ATRMk41/Q+PX07XQlRCRcE13a8neEz3F6we
 08oWh2DnC4AXKbP+kuD9ZP6+5+x1H1zEzsFNBFXLn5EBEADn1959INH2cwYJv0tsxf5MUCgh
 Cj/CA/lc/LMthqQ773gauB9mN+F1rE9cyyXb6jyOGn+GUjMbnq1o121Vm0+neKHUCBtHyseB
 fDXHA6m4B3mUTWo13nid0e4AM71r0DS8+KYh6zvweLX/LL5kQS9GQeT+QNroXcC1NzWbitts
 6TZ+IrPOwT1hfB4WNC+X2n4AzDqp3+ILiVST2DT4VBc11Gz6jijpC/KI5Al8ZDhRwG47LUiu
 Qmt3yqrmN63V9wzaPhC+xbwIsNZlLUvuRnmBPkTJwwrFRZvwu5GPHNndBjVpAfaSTOfppyKB
 Tccu2AXJXWAE1Xjh6GOC8mlFjZwLxWFqdPHR1n2aPVgoiTLk34LR/bXO+e0GpzFXT7enwyvF
 FFyAS0Nk1q/7EChPcbRbhJqEBpRNZemxmg55zC3GLvgLKd5A09MOM2BrMea+l0FUR+PuTenh
 2YmnmLRTro6eZ/qYwWkCu8FFIw4pT0OUDMyLgi+GI1aMpVogTZJ70FgV0pUAlpmrzk/bLbRk
 F3TwgucpyPtcpmQtTkWSgDS50QG9DR/1As3LLLcNkwJBZzBG6PWbvcOyrwMQUF1nl4SSPV0L
 LH63+BrrHasfJzxKXzqgrW28CTAE2x8qi7e/6M/+XXhrsMYG+uaViM7n2je3qKe7ofum3s4v
 q7oFCPsOgwARAQABwsF8BBgBCAAmAhsMFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAmic2qsF
 CSZYCKEACgkQTd4Q9wD/g1oq0xAAsAnw/OmsERdtdwRfAMpC74/++2wh9RvVQ0x8xXvoGJwZ
 rk0Jmck1ABIM//5sWDo7eDHk1uEcc95pbP9XGU6ZgeiQeh06+0vRYILwDk8Q/y06TrTb1n4n
 7FRwyskKU1UWnNW86lvWUJuGPABXjrkfL41RJttSJHF3M1C0u2BnM5VnDuPFQKzhRRktBMK4
 GkWBvXlsHFhn8Ev0xvPE/G99RAg9ufNAxyq2lSzbUIwrY918KHlziBKwNyLoPn9kgHD3hRBa
 Yakz87WKUZd17ZnPMZiXriCWZxwPx7zs6cSAqcfcVucmdPiIlyG1K/HIk2LX63T6oO2Libzz
 7/0i4+oIpvpK2X6zZ2cu0k2uNcEYm2xAb+xGmqwnPnHX/ac8lJEyzH3lh+pt2slI4VcPNnz+
 vzYeBAS1S+VJc1pcJr3l7PRSQ4bv5sObZvezRdqEFB4tUIfSbDdEBCCvvEMBgoisDB8ceYxO
 cFAM8nBWrEmNU2vvIGJzjJ/NVYYIY0TgOc5bS9wh6jKHL2+chrfDW5neLJjY2x3snF8q7U9G
 EIbBfNHDlOV8SyhEjtX0DyKxQKioTYPOHcW9gdV5fhSz5tEv+ipqt4kIgWqBgzK8ePtDTqRM
 qZq457g1/SXSoSQi4jN+gsneqvlTJdzaEu1bJP0iv6ViVf15+qHuY5iojCz8fa0=
In-Reply-To: <20260114085201.3222597-5-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5txr1jkemgsxqw9re17rupic1376acbd
X-Rspam-User: 
X-Rspamd-Queue-Id: 05BD41C000D
X-Rspamd-Server: rspam08
X-HE-Tag: 1768387765-278231
X-HE-Meta: U2FsdGVkX1+DxDfawCULugYWxylCEDiObBGbMh/1USrXI7IA3RcbgPpH19ODKwpOzO/6+Zdewl6VB/LTrVzaFgfXNswLKSy6sVdg6jnoYUaPwovBdANgP/+aHN59ULzh5HrRqyHEMTHi7X4D56r5ppWWguCwlclQM60A27c8HXHllUU3RY6JG0vlT0RmjQ6iX7XnAT+BrVwodjmd0Rbcx8AINbSdxGGfZ8FkL5u9dBPghxnyFfoVDfo0ivNN76a6dir2ZdJdnoEl94JwtvfRBer9XtJkaEnvfXMH0hS5/pDYDhOzfuCOlLR8vDkxEIR1TYSRrobfrkcI1ApQcNF2pgN9lEddCWlyxv0fFSU+tSAqcvV+qOW4u0PKfKrVRA8/2YKA93ReZLm0L0YOMOSi4cWiot+1tocsllNtwesWmkdntyG2RhDbPJykHetsx9LVNSv1Zn0B4KxjIX4/QStLHVPLcKVD14Hzas2ZSF+9RBHdhKj0t7ABt6cwdNfdKTHtNcM21O4cfvUC/VYEkkYUxexB2FOI/xzZc+SoWqdDpL3yNQ8ZlKGFtvsSOE/mbqwQQI/Xouz5hAeF7lXELYdSbxGhlXsp+NhKvMInRIiRiNtDu9U1y1ofaDAI0GFs9OdmlVj3ZYW1+J9N9lJEdULCPoppR0LGJtpzi+2Wp7zIE6jvL2HLUPB1k/jEkxJ4YPHOhu1Nw0dQohw7EQ1AI8T0/VsXG0bZbNnYwvvLlWK0IOmH4YaLP/enqkSBipCqkxb0gD6opXtl8VfHyhQToA0FxHlgo0pSLf8o88hx1viJU9V95LoLra1B+e2+h1sACZFVOI70P8Eqw1+33xxVN15kcQMGvXZOv61PHP8C6f+g9q2jly7pdqdGE9F55BTtA+OT2bjsZfxkCLE4QQL7nYNxc6PlqDZ5rpfXPSPegR/TcsjaRPk6LNp+kBTvwkPKiToaHptW6rkQirbApHGb+y+
 9kwMEflY
 iJbKYZiwmbhIQEm6EY0W5wl0OA2Ur73Y5JiCfA2xc0BzSVnJx1AmIly0SVlKWfjblwk/Ed2IC/ChEkgqQMdOC8/AducR8q1WITXciBJQ7fM+PuczSLVSSyaQyaS4P3Qi9De8wW0VlKIPkIN0g8DGSqw9Y6ZlQL+0XwQEfmnOkkd3j7eOE21YSKrHaI8GxGYFUJ59YnR/N8/rnHhtHJjL+IbYKJ8qhNK66G9DUtNRCofFyC5xL7rOIHGcbQ2uj+CSHXDZrxMY+JSz7DhAd7iHyZWkvQx/RZl3FJxajY6Mu6x4jjUmgiOZ3AKfnWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 09:51, Gregory Price wrote:
> Change add_memory_driver_managed() to return the online type (MMOP_*)
> on success instead of 0. This allows callers to determine the actual
> online state of the memory after addition, which is important when
> MMOP_SYSTEM_DEFAULT is used and the actual online type depends on the
> system default policy.

Another reason to just let the caller handle MMOP_SYSTEM_DEFAULT itself 
by calling mhp_get_default_online_type() :)

-- 
Cheers

David

