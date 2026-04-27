Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FB8BFF8862
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 08:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47C026B0005; Mon, 27 Apr 2026 04:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42D456B0088; Mon, 27 Apr 2026 04:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5226B008A; Mon, 27 Apr 2026 04:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 174B66B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 04:26:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C1C17120781
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:26:11 +0000 (UTC)
X-FDA: 84703653342.04.272E18C
Received: from mout.web.de (mout.web.de [217.72.192.78])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8FB8E1A000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:26:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=Ug9kqZSt;
	spf=pass (imf19.hostedemail.com: domain of Markus.Elfring@web.de designates 217.72.192.78 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777278369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ut77cdJ1ONmHYmjJBQ7/EMBfr0LmaUb1R7pFT+AsGVs=;
	b=xJEYanzRoWKspxIgRxDXzQVvPD+zwOKPD11vM3QAJGFA/aI4V72wlSRGG7lcsQ1rZQnZLI
	xfWaG0Lem3ptMsc2qYs2+MGETQaf0kelXv3H2sni5X3H5OV6l371mX0htaBIs6zTXcYJ/d
	KzXlr56iZCJohf1fSGtGGAUxgdL/zlE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=Ug9kqZSt;
	spf=pass (imf19.hostedemail.com: domain of Markus.Elfring@web.de designates 217.72.192.78 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777278369; a=rsa-sha256;
	cv=none;
	b=LbccHtnEvtkBpsJQzz+Yw7z50AoNQIeP+bzFty0708eoHHkOiBM0gTD3KTXX0r3xBISPeT
	LrSf9z09NEs37TVLo1U2p0VwbDErEXwvkQ8Ul/5cCpCehJIE5lZYftNKB+CnJyDKY8s91N
	NEq3ZRKMGosrx52586/gvqX8TIdLzeg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1777278329; x=1777883129; i=markus.elfring@web.de;
	bh=Ut77cdJ1ONmHYmjJBQ7/EMBfr0LmaUb1R7pFT+AsGVs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Ug9kqZStnyF8267bzbH6Gi6YV+e3RN/wChj3sQBPCCbhHd1OXsxYZ+76v78k/ozn
	 yOfxvkOh4Ni/4S44Q82CFqkeky9bj+TN5zMoJfxpq492nS4S+QzfBX5X78cZhn2yk
	 4y75U3vm9lDCUfDCV8O+49W/YcoEPfJO+mw9JdUw0+5MTqAo/hh5D/43kupmDSdt7
	 6nJYB1C8h7fGWcpNaDYLEnpb0yHjYA3b5Zho69I6MFLb0AQywpMdp4n1JEEYAp4LH
	 JwoQX+ofrNchO3QBqYnH45bEdneeIiqBq6WmIssMZiWB6GkNdPrjUJwWNyWQvp9w4
	 bN1k9+LZlrhjgzVU5A==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1Melf5-1vgq0C0fWX-00onAk; Mon, 27
 Apr 2026 10:25:29 +0200
Message-ID: <f7da0a9f-cee7-4c0a-a800-b6b020fcc2f3@web.de>
Date: Mon, 27 Apr 2026 10:25:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Sunny Patel <nueralspacetech@gmail.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Alistair Popple
 <apopple@nvidia.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>
References: <20260427063729.17294-1-nueralspacetech@gmail.com>
Subject: Re: [PATCH v2] mm/migrate_device: fix pgtable leak in
 migrate_vma_insert_huge_pmd_page
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260427063729.17294-1-nueralspacetech@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nJG4YSEl9CCx2eoZB2sIJeRKnbonVaCBVQTiNzL/opkmZ92WTF2
 hrE5GO0jQi21GAfD2Rk3YLgfOBbU0XXsI8jASGd9bMkhuXFQocdRKDZgsJidZdxaI56HxQR
 o2mKNHt2MRPUp2ZvOcnI59QBrAYvksRMr55EWzqWOoukx0Tpl5X1Pj7o7CIN2iX9AhCSmnV
 SXkV3Bkj+KlhhuqmFox9g==
UI-OutboundReport: notjunk:1;M01:P0:bE5/nmSNmJI=;4Lwu/NYzg/58hB5MFiy5q3rhkWY
 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
 JYG24BPrGRY+gimX1xNPHWwk13HlCLrkG+N0=
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8FB8E1A000D
X-Stat-Signature: bkktw7pij9nza4t85cbqwdstquin8owa
X-HE-Tag: 1777278369-14189
X-HE-Meta: U2FsdGVkX1/P5B1rMTYXlUdIhzQXJLvc6fR/yQ6EyHNenStN3gOZsGpn7FNBnHkW5+CzF7Lfa7bB5wK9m1gimRVSmWEC0ElvFINXrQU26BB5uK3VhofOk3xe1ELV7HrxyaC8mq5nr5vbn8Js9pwKecoVXL3S7Awcyl0+zhY1yWGVAvrzkELJNMsXoKBZovrQAzFj5aTVRid1JQpif+aPhvCgnVXcITbu3hs7vu+778rHcEZuklcm9iLTqGdqUhDXQ6wlBD/qFs+xiF4v18ruZKaCXZG/WuYUq2sk6lg2XjK6DgSXKad0WC6xqob0q4/EkpmCObLrwt3+cm/qjyJ+2v565JVSxNm65yKdih0k4b2wxiKPt9ACIaaFVFkB9WgWlq2iWK0pvEr4jqBYvnnr//HJvpUBun1axwWXJTLhemeGyt78bXkKN9uJh5Q0Rco1enaSzwKgTqXgS6MYrN32xBPo+m8lrL2Qnfr8OAwkmgkD+9hqspGPmh/WQVMe9dwSrBAvMLEZeZivbEkKazpobIMfLCPkMAftCvZooDlXaJE4i9KLsGB9CPBTlUOXjbj6mNQ2P9+4Ui31JaJPC6dhBt3IAiTOF61AvFxGDK7J163zrbsu2gF78AGWLcYJapgqeGG4FiGlDUTPetMQiYvno7FUGPnOGPjB4jnEAeAgS2Ye9efo5WbdIZ92qyxO8jcGBlY8d9brvMDkxCDMQeyP2lE/KmFJewg3BsIC+VjEp3SPZe+hYk3DrKudGnpbeeVFupYrLR15DijgoeoEfi7KKq3dbDkG8/N6SwES8V/tqffGoDx7jupP9Wo5xUEulkysQIZu8FkhzcRLGZJZPaT/IqJTGPJde/adbD6QAR7/8JK4bdSj7zPyBX/Wet1MiJNyuqC8EgrUgoDdaf+nKKBiZWGjmp1L8OOa7kYMH173MfJI5thui0g1rq3SdhptIqc7BlgCRAk684SZ5TVGUT6
 uVpe9O/T
 Bc0Zd6yECuv+HQ8azvceg9lbBwpMNDEcSjHpElxK9U3RBwRZxBqotktHU4yDKuNwmqNIFPW34eUOSRnnGz/S9dh93TpxJL1zc4vZ4QN2O1UTcm6nt87mIRbZN41AjN9QgV72ydudv0hQ1MpM96asBnHTuJi62tdJ6iZqp6IO62ukKvYwT078Ca94K3V/1wWnGSWIgnCfpC+ub/NWTJBEwY3iBzHHO58wBt4BlVOZ6AOU+yr/XNGD2ppNwYBXT5y/9ocHe3sfBay/kdIgfMFY2uswFJYZ9hMdVvk3LjJAZp4zxhlIwhSp6T9E4rOkm1MfJveoJmPq3gOADnRWPgYTKOG2Oowmh3LFsHkQA/vz3vflfamMi4RBnDJrlGcOhygp+v1Qc/iEk5FpGbMsh2LTw+AsV2l/FZOCnWclqh8YGZvp81GafhknSZU1q/Rq0cAZ1eBhaoalMEY7K/jE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=E2=80=A6
> Add a pte_free() call in the unlock_abort error path to release
> the pgtable before returning.Also included before goto abort in the
> folio check path.

See also:
* https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/process/submitting-patches.rst?h=3Dv7.0#n145
* https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/process/stable-kernel-rules.rst?h=3Dv7.0#n34

Regards,
Markus

