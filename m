Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33817CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 14:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B2316B0098; Thu, 28 May 2026 10:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 962726B0099; Thu, 28 May 2026 10:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A0486B009B; Thu, 28 May 2026 10:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DA946B0098
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:03:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48099C2982
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:03:22 +0000 (UTC)
X-FDA: 84816995844.12.EA4D8E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A629D100016
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:03:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HiVW2yH3;
	spf=pass (imf14.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779977000; a=rsa-sha256;
	cv=none;
	b=gS9iRcU0N6GAQrlvwo75bStiZ8XJi+K68fXTP+ARNFYxOyoKPbxe5W7o+KYA4bT63YSI0/
	Optjg/fBANSXJmGPQneLs1t5b02ac8vef92sAdUh6XWPqeOkJsD6stzM15iYPwCqB0I1wC
	IAuFktSXEWQJofMSM004CHhODfi6Xao=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HiVW2yH3;
	spf=pass (imf14.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779977000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XpxnCGqlRrEHebmmwDWgQQACrD5dqRhOE4/6MV1vagI=;
	b=601aktTj9Zy/2wPw7mHraIBBFjDZkEQYGM5GzYSlqGsfR3HuiqoS/oN3m4G3Edis7mIONj
	/zIiKWiLv4BhrqmHbNZnCwQyq0cn187mpIDDA7WYK30FelWLM0See/RRTLLBpnjLoFdrCV
	pehj63w0Sm5pDpARteUF0cZPmqBHLtU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C85C240806;
	Thu, 28 May 2026 14:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787BC1F000E9;
	Thu, 28 May 2026 14:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779976999;
	bh=XpxnCGqlRrEHebmmwDWgQQACrD5dqRhOE4/6MV1vagI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HiVW2yH3s3ZBqVBJKx8WVnShIc8H+iOmdkAIwz/pS9P/L4tlr6mcwfQqj5HFjiw0/
	 VXn7u3UxK5MIvAkm8T3BYsm0AhwEyl9gt0txfouQ1IJFyaymSWk9k6bJaF414YulV5
	 LuQj9pmWe/SoUOcX2B4mJSlxWFVO8q88auVe8fLmDbYtzOKxYmPJ6cVHpLe3lumO+1
	 uwzu5T2OHSY8TwZxn++EQKNsFEoSom68JvLQzekGrPx/6teBT4HH8SgL1Xhg2gYPRd
	 b7F9/I9rVBj6Vxfxfd+88U+QRR4JC9PB/KuDA9qcWtvvrC9XFLIFZqqgl0TpmR/tyq
	 ef/SgEshS+0Mw==
Date: Thu, 28 May 2026 16:03:12 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Karsten Desler <kdesler@soohrt.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [REGRESSION] x86/hugetlb: AMD F15h VA alignment offset breaks
 MAP_HUGETLB alignment
Message-ID: <ahhLIOB7u210pjfA@localhost.localdomain>
References: <20260527143643.GO31091@soohrt.org>
 <ahcTYufV7P5Cmotq@localhost.localdomain>
 <ahc31AChKqnfItHW@localhost.localdomain>
 <5f70e840-9d0e-4cef-8574-b355cf26e0c4@intel.com>
 <ahfWdMdxX68ni4ZM@localhost.localdomain>
 <ahg4zTSRK6THd2yP@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahg4zTSRK6THd2yP@localhost.localdomain>
X-Rspam-User: 
X-Rspamd-Queue-Id: A629D100016
X-Rspamd-Server: rspam03
X-Stat-Signature: 73fisi1hfbf5uhxpdbab99g3kcnhsh3i
X-HE-Tag: 1779977000-437647
X-HE-Meta: U2FsdGVkX1+yUloJOar8VmYObiStVLJRr7bWuNnPnHbl5h4ufzV/VYFhquCM4VqnNWhAHwKtudRsmZCfrjBECve7pxLVpujyobwv450Ua1oObGXFRPBPqRFxbDLt36WKTDSO6PHrQcyRghZKBF34nHgxRlNTQa0fOuKIK4M92mN2Zfn6IDYVDsT8dIyJ4y8ipRb+KUyx6bH978tGz4ux54VpnQHgZkAW7zt2tpJ2tS1jw9QOJ7an0kOKPrpV1rdNVMkhL0W8cLn7bf8WMEYHmytl4NpRLqjS5iDgPXwNi79595ctcWqygSK7YjZq21Zq5sppZ/c+HPRhfbuBD1pJFr2lwXdt5eLn9V47amiu2pW303+pKGlEqQW+woczSdetsif5NZ84Y8rgP/8xY/xsbfwLVAa2aPUjjhs4/mHniGsDJ1BRi4WUjC/J0pQbHNRHi3ba57XgBgLYXKkV5wpJbf05nd1p91Bailxt4cKut6QpsOhSmfSb4AJlv2oPt5xXw9+HeLg+QydRrgphgAmhh26r4Qm65WHrI3MljlNfWsNWg280lCEf0af4TjWmvv7oQ3vOqvS8deCaOTmZ4ze7zVr+lJG1WXWgjDi+dMwJBwSc/+7N04KjvnipsnLrptXZu8CoWWxBcMdZBxsOAYYV+HD6t7pm4l7gpfQfJ3NLpHJoa5hjZ2fBNt8Zv1QMItIHg++evOPMoCRQnd61UzkrXNTCgmVN8iEXFTvWba33ZTT7mvXwtLe+UrJaoz9vhqizGNjdBMrWx/Xyf0Bed2HS0SHGkiZgA1o/D4iIqPo7Wz3rSo9qLZ+azhvTDaPJhAbm4wKeGuMhbZ1EFhKEzO03TSEm75qOmUmMTvDW9V6l4fkBvbNob4j/ALSYzB/w3QbCNqysFCF6J3ClBBgA/Jh9tGt1uV6Mep16+EvyXDPKDnSgMdwKuJrTxOTHbzwqR0ORy0W3aN4Z8IC8FPVsB+f
 Y22Kzfhu
 OLSSgfJGxH2BSrnHr082e179xyRzUzdrTFFvhTsvEVTvUD2gzph2zt/9VNzs4Li63QEw7rBfb+eO1K8cb/3tB7RwC0w5slgb3oujtmgdedTTLT2AIYMJ4sLITmt1WcTAzuqDngjDNPC3rrguWRwhzZP6EddM7VUaGNi1a7CaVy+5cLOJnFfZi3JolpNabeL697WFt6Q2JZO2LyPWda/fxRb5c5Di7aT65P2B/XFOEkksz/JdesU/6XZuUGrV4sKRYSUri
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 02:45:01PM +0200, Oscar Salvador (SUSE) wrote:
> The only thing bugging is, should not the same happen for THP-file-backed mappings?

Aha, no, for THP we do not set align_mask (at least on x86), and the masking off is being
done in __thp_get_unmapped_area().

 

-- 
Oscar Salvador
SUSE Labs

