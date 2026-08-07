Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DB26C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 06:10:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C45D6B0093; Fri,  7 Aug 2026 02:10:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19D1A6B0095; Fri,  7 Aug 2026 02:10:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E06A6B0096; Fri,  7 Aug 2026 02:10:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E12116B0093
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 02:10:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E74DA02E4
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:10:19 +0000 (UTC)
X-FDA: 85073448558.15.833ABAE
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf27.hostedemail.com (Postfix) with ESMTP id F18A440009
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:10:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Px1dKUSg;
	spf=pass (imf27.hostedemail.com: domain of jackzxcui1989@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786083017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGRz6WB9lU3wlD2STC8uk6Jl3YtCrm4akVDEQj4iVJI=;
	b=BYXVYNY0hcWBNiqeBgwmeE9CwQceAWZRUumVaFT+IDNrFi5VtN/AzzWgwg+ATrxUibl5pw
	f9h++qzb9uo6FobkPo7klNPCLU6yW4VME52QyXtAm8hD+L/VBToOzXA0voFv4T1WXsBuQR
	oTLlR1R52+Jr/L77ESrdbLqgEOziZSI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786083017;
	b=3rDtnAKYY0AOi90s/6QVeVyPji/XsGNF1CP02B4EdRyazK6N0sPZfxMYtXEWbRB9WQ3u4a
	WMp5yUPCInU791T4jXLA2AiOm0VsTenFCTulWZaP5+7+Pw5wf0+rXAgARo7lrzkC/Okt1/
	+iOn1NeJmwn3mZzXCO3EJun66RZf47c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Px1dKUSg;
	spf=pass (imf27.hostedemail.com: domain of jackzxcui1989@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=YG
	Rz6WB9lU3wlD2STC8uk6Jl3YtCrm4akVDEQj4iVJI=; b=Px1dKUSgN0ds0QRJxl
	zFG7j0Hbb06euelKNoN1Bds7SkB446HEeQAtU2xTWhOw/e7kWkFJKTnU/pGzDoLM
	YdrciyVOwJ0KVq8jdFO/i0HuQy+Y0CEC+giBSSKhyP5XhllL1NfyeR5QnKEW379t
	J9bss1T/sTJatoLqqa2hssNEE=
Received: from zhaoxin-MS-7E12.. (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgAX62t2dnVqBJMmJg--.29689S2;
	Fri, 07 Aug 2026 14:08:56 +0800 (CST)
From: Xin Zhao <jackzxcui1989@163.com>
To: rdunlap@infradead.org
Cc: akpm@linux-foundation.org,
	alex.aring@gmail.com,
	allen.lkml@gmail.com,
	arnd@arndb.de,
	brauner@kernel.org,
	chuck.lever@oracle.com,
	corbet@lwn.net,
	david@kernel.org,
	ebiederm@xmission.com,
	j.granados@samsung.com,
	jack@suse.cz,
	jackzxcui1989@163.com,
	jlayton@kernel.org,
	juri.lelli@redhat.com,
	keescook@chromium.org,
	kuba@kernel.org,
	liam@infradead.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mcgrof@kernel.org,
	mhocko@suse.com,
	mingo@redhat.com,
	mjguzik@gmail.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rppt@kernel.org,
	skhan@linuxfoundation.org,
	surenb@google.com,
	vbabka@kernel.org,
	vincent.guittot@linaro.org,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH v7] coredump: Add bit 9 of coredump_filter for pre-exit files before dumping
Date: Fri,  7 Aug 2026 14:08:54 +0800
Message-Id: <20260807060854.1785634-1-jackzxcui1989@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <a2293778-bce7-4f88-a049-6370707694ef@infradead.org>
References: <a2293778-bce7-4f88-a049-6370707694ef@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgAX62t2dnVqBJMmJg--.29689S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZF1fWryrZr4fZF1kCw1kuFg_yoWxKFb_Xa
	yvqr9rJr1ru3W2vF43GF1FyaykK390yF1fJ3y7Zw1jqayktF1agFWDKFWSv3WxKFWDKrZ7
	CF1UXw4Sy3yavjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUU7DJtUUUUU==
X-Originating-IP: [124.77.128.89]
X-CM-SenderInfo: pmdfy650fxxiqzyzqiywtou0bp/xtbC5xizvWp1dniqEAAA3a
X-Rspamd-Queue-Id: F18A440009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: od5ks44e71ntxxtrjdr4sdu4eiykert4
X-HE-Tag: 1786083015-706269
X-HE-Meta: U2FsdGVkX1/8Ilv4JdfUvOcRO96yzWgl6idHnmb2zRoSSkTEwiPXEAhiE+xQDlR9QEQRdgJx6S9V7b/TZEDQltu8WNT1YYPKDU9bVeHK9ktI5FlryMKG5yZX6kHl9nbOGnRUh5SSTP4Fpw7nclASNUsvm9wRYLQFQCwa5qc5WYh5HaDNNf8jEHVMLiDreLJOJpjyxZhquUSREa5xl/QZX9g3yUvGdgrPuRznM3xIk8LFaOGVstDJn6e8KuU7spzdoBF04osQL9YJ3sw+TjanNYkyUdQDHMq1iRcGuXZt2a6+KfQ3IRD/j+CmQxtYtyjzKDixX6yrN15v/w7vZGD7VSxoFsL72snezQFv0IXjKJyhvyj9Lgqth6ucOtwyK4wX1IY3Meisxd1E4vclM5hEP1pwuyz67mcfH37pD3CddKRmvAcFc2VJRvxYFh0pJ5nXqPmTKs3VnNSf3ZvufAtF+9futEqnJwC0VUGxSiBz5BtE+oemFvjmkrKXRiDwh8Zi4hJ8l3qQhklpLr44VxsIBhMXPahiH/PZaGrCsb05yzdxmXcDRHYaVDzjvo31+B3l/E1Tpm6UEARvejbyKJeTOEUoqmgLP2ZVnAiy0G7Rui307+nX08AAO/TKUFH+e/3RwL8AZdtnJZnVEI4VVBfob3VaTfQ4qpcn/Zq0Vy/VWWuED3ubiqCGU65tWrI5/ObKzqv7uVnsZhZ/2LGt2LpODdwi8DfXQKGkhFBlbGup+9HPO8F9iDT0wzc9bnkuh5ukAx1uOmjzCUlUQ5WehpgpNBkEJd276oT6h2cES1NzXXzqHVZO72BTY0Y5I5OAmiRaOOGeoQ2qhooPfwf9DZXmWa/HEbv211UFqRVNatye/8hQqSm1Sh3MT+1x+WfRD5AlwXsmF4FBWiiUCccLAJU6efCerlbZBkflqCGfz6IYOyqMU8lmmvT4GDBy1PwCCPIoVYD3Y8mZYLLfxO91FB+
 e2CSLvR1
 UCKYVUE4lLpf5Gjt5T5tLYxWUcWjzX2GIeFh8HxyXfR9BYJj7SvIg5WXRkZiMuU21/twoQmQwR8srO+/t3q9SViSt8INm/FSVddLIPsWcyHMQc3rrDYdXrlPQuww5QWeTaiLihLL/ouP+RroFiPCI5eQm2txcNMOm15F24eCPA2qQAyInr+7ocVGiJJcV0t3Zg063ATWm2dQpnUtrL5/jbL/eWcUBhpG53Tc4yTR6SElXlKDb6dn+GMpvvSGFVB091duvfTCb24lAGbwaXOgC5JfGxikhsL0Du8V2kfp6NGzDH1p2vaGWJA9G7feKlM6UG4cC4LU29SVwlJZUjYzyzGj17gGq2SC+X30TVV25smYuiBmHqFwcu+lwi6oiqwPSI34NSCS0nmuo/Z7PWYDl54iMbHo3igWrjym1z8MIZFqe2CSNNYu08TDg2zkUmhs+hcK0+qUNy9aoDL3dRRPAk+28KG/LJT4h7O4q5adNHryP/TQienuDqF/oB6LFsigtqiF83QHFbhqfTyn3XQXlNUJRqOs9KOdknQKiV47I3BW6uKc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 6 Aug 2026 21:08:46 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:

> > +The default value of coredump_filter is 0x233; this means all anonymous memory
> > +segments, ELF header pages, hugetlb private memory and fd list are dumped.
> > +
> >  The default value of coredump_filter is 0x33; this means all anonymous memory
> >  segments, ELF header pages and hugetlb private memory are dumped.
> 
> I could easily be missing something here, but to me it appears that the
> paragraph immediately above here should have been deleted (i.e., replaced
> by the one above it).
> Can you explain, please?

Thank you. This is another silly mistake. I'll fix it.
I think I should see a doctor to check my eyes. :(

Thanks
Xin Zhao


