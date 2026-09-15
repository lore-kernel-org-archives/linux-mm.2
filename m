Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63D36C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D605C6B00A2; Tue, 15 Sep 2026 04:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3086B00A4; Tue, 15 Sep 2026 04:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B42486B00A2; Tue, 15 Sep 2026 04:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C6E86B00A2
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:35:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22803A0363
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:35:51 +0000 (UTC)
X-FDA: 85215338502.15.4EDB9A6
Received: from mta0.migadu.com (out-75.mta0.migadu.com [91.218.175.75])
	by imf24.hostedemail.com (Postfix) with ESMTP id 11A1B180009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:35:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WLE7hqkF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.75 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789461349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvZsQKGcj9Vqs134Kw99g8pcS2/twYrrNuAewcEgKkM=;
	b=w5VSc8L6bluxiAbyTI9XHzEH6l7kM7OXev7NFtQXboj/OX21bp8/Pv72hxUbE+u3sFaNdS
	rUo90KAux33DU+ryfcjkgXPsqdrmi1DIHJ3awOmKy76LsDi9FJuGZYCgShdK0NTPZlDBrr
	wmwyNDKS+u57NXbG434qCxAdw8ZNsnQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789461349;
	b=SwfgJj3/x6PTAa0VgclSgfZAQcLfq7ilT2z1KiqVaBdiuR0Ta4MYY3O/mfhstRC72UVlPq
	Ov0mD8VXM8QbDfHyE3n3zEka9tuNum3IPzswQ17iYPHdtXUKUNkr8XmKaLXzwxfybo7wZF
	S7kkwUohBzm48y2kLrMRy3gKKyDghpY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WLE7hqkF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.75 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UxWvBiFLrCuQi9TNkzjtu18nlHcBKoUJpDAjQqN5GgM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789461347; v=1; x=1790066147;
 b=WLE7hqkFT8CS5SvSefyHcNXeI+YjVi/UdWZ0cmTAWGz7wpLiPqSl5L7h6GAQRLSrLQ9iQmWM
 OXqAXdT+iNDx+wXRpLIiPswiHBHdi7+If+iROQ9KWMYaBAyvz4zPBfhKGIRzoFZkvnP/kRlWqUc
 KFS7/nqdJa4oAP2OHksGWZJw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 1ae303b1f455d87d;
	Tue, 15 Sep 2026 08:35:47 +0000
X-Mizu-Trace-ID: 1ae303b1f455d87d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH] mm/hugetlb: fix misspelled parameter names in comment
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <tencent_034C6FC23D4817C40657E5F17F64E260A009@qq.com>
Date: Tue, 15 Sep 2026 16:35:33 +0800
Cc: linux-mm@kvack.org,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <276F2B46-5BA5-4C54-88E8-3DC75AC179D2@linux.dev>
References: <tencent_034C6FC23D4817C40657E5F17F64E260A009@qq.com>
To: Zhenghui Hao <zhenghui.hao@qq.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 11A1B180009
X-Stat-Signature: 7d7au5ogey8oipp7gobykjsxkwku34jx
X-HE-Tag: 1789461348-368725
X-HE-Meta: U2FsdGVkX18BeQSsPgAb0zyJTH6Kmi96KfqaLndQj0FT2FxO4mibJp+CrLgCIgtf+LwcGzmZJi1FcCG3Qh2heFmbc3T1h+yAwD6+wJQ7UsuKyvFwfFUDaS5f7ODptTByfuExBO3Mv+/UjM90m5XfSFd+8L4NuLglDgNOck/pW3+n10Dm0XgymcNnFjo6RzmYmHqG5IuX24s+er0C9Sz+gNSF1801EbNVTdr7/uR8+hNsEQjkiAfceQ2/ouaS0wbO7MKFO+609mQTa6ynzExFlJpcvo4OoS8al+A96A27XOZoahB5ZrL2zF/dBg6oEICmclkZP5dLOVibsTZnIzMUAOXFNWtkzEh2n0Lh4q+9fU47wzAxVujLrUyryP36JQQrlRaVTP4TJv69A9WWBGsx1UaEQ2E0H+XfCZoeR/ePNBJrA8UH/5P5bzxBFYOzhaCHOLVX8xvBzbi23M4aGx4GuHXGtiYH+942xyle9XJX9WVobSVj7qz4Ckk7l3y7zjU2x/yD6fiDHzBY2ugoiMpUtGlE1JDGNL8r08GVA1IrSgTkstXMPrpHMq5o/S7e2L/mkOQGCrGPnEAVIiDqIWwZM8FJrhLfYWzTCqcrDHZrpHeZZIrUpqxiv4+suZLtb5aO+GfTS++V9b/DgDomsSlyIAW4U/6mgFqqKdTLwpTPAIFXBTU7N7z9X/Zls4FWTsbA2TRfrGuXiZpXrp3TEy4x46Ei4yKh6Ky/VRbuLcEjtPmNIrA93QljyP5UBbxtSQCQvd4PdhkQ6YG+AhCFOZrzwGxPTqT9uFoA1mScY0rGaxM1Hb8QfRGYs6gPYnFwYMcFWENMAMEy/w5lj45YPD1A3pRh8HMogyuQxok8mQEiUp9o48bJzuYQuOS6TOXBJXrLkM0IJX3/uGl/ixlCCDAX1PhK9h9x6NsP/UAhdU6GaNd1qPSAHOjFoUgwJ53MalQbPc2MtqgINLNIBFKy1Z+
 MgF75ChV
 14DBd7QmZTsy6fkU/0AMbE+Q0bYFoJPtN9EIzJeWjTZnqhgBy5cXoVRPZrGHrDkGdawzdDAlmW8O6TF94LWp+E5+oj+vi7m+PAcBECoIC7NOa5j6iSSApMj0jpZqDFjZVKgExmCHClqR+atI0OX7BC1fFmkhxxVoKjgR6OILkoQPAccEY687KNb2wMgWZPVQnokDG+qMLXWV5nQSbWxT6nA99fEp5Tfg2EHtQGfgIH2RKnE1G3z7mgJ+OFV5u0dBvvQX8Y4WshLYBGO5VPY24FagLVqlVaqnTBH1E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 15, 2026, at 16:20, Zhenghui Hao <zhenghui.hao@qq.com> wrote:
> 
> The comment above hugepages_setup() refers to "hugepagsz" and
> "default_hugepagsz", but the parameters parsed by this code are
> "hugepagesz" and "default_hugepagesz".  Fix the spelling and also drop
> the redundant spaces so the comment reads normally.
> 
> No functional change.
> 
> Signed-off-by: Zhenghui Hao <zhenghui.hao@qq.com>

Thanks. This makes tree-wide searches for these command-line
parameters more reliable.

Acked-by: Muchun Song <muchun.song@linux.dev>


