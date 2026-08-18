Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2D86C5DF86
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 17:25:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C47656B018E; Tue, 18 Aug 2026 13:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD2A26B0734; Tue, 18 Aug 2026 13:25:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9A886B0735; Tue, 18 Aug 2026 13:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DB806B018E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:25:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F2FFA26FB
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:25:20 +0000 (UTC)
X-FDA: 85115066400.14.F174BEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 40B1E80003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:25:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HHYuHZuq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787073918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AShWrs852J7IkStssEoEst3JiywPYlSikQUVe7RTkRk=;
	b=Ugj0tOXbdqm/5mTxrmLuctg5/SBh8Co+DObKelGUq1if7osrLuq1Cjj46yOqI7ZNq4gPtF
	YtHjq5gsz48aGBqKB9f7noL1ndK70PXtuMx6ALc+bXlxhA2QFnAhDaOHtbHNnd8WQ3MMGi
	b4opSN8/c6Z31swRV+GLEdZRHY75cFw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HHYuHZuq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787073918;
	b=4tf1D90JMnToSXRqG91VYq8nxjPFP3VMuWXE8O/72SNsBjW4rYkdzANN9Sk2FpakQqU6p6
	s86IELmsIq3dhHcWbaSPdeZvEl2pVmN/eS6t6XypnPO7jDlgSns/Y5Erq1NcZ4UqarmzX6
	XdtsGoUM5plL6H1Y+nzfkS9lxNBLbTQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C14943F63;
	Tue, 18 Aug 2026 17:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A28E1F00A3A;
	Tue, 18 Aug 2026 17:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787073917;
	bh=AShWrs852J7IkStssEoEst3JiywPYlSikQUVe7RTkRk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HHYuHZuq5zMXG+8OeZcsNEd1kunHyn8X+QRRdpazCD+PrQnY2MD+Ve9C7MoKwru4x
	 dbBzkW2cGWbBN3m3D8evXSCxOc8q2AyH3nSXNiWo+xrK2TdFxAIivDqioG1XAtwxtF
	 aMCegUXmfY55bD/l0MdwxRF/+47ynTjAj26vHT4KSJZRH0qcQ7HSLgqNnkGJ4K3+/W
	 crGr6GNfZ3DAGAYgRt1N7RBfRYxh3dfuxofB0XlSNCLCsppsmpUwmMlxXD5gurFGnn
	 9/OAXbxSo02M2icN//fOoDQwicorrXfhbp04ZPJhViHl6uwc6nkSncuJyuWweMLpgg
	 uyhaHGoSxMwtA==
Message-ID: <55d92b3e-ad3f-464f-b2db-a2552353223e@kernel.org>
Date: Tue, 18 Aug 2026 19:25:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V3 1/8] mm: Make ptrval_to_str() generally available
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>
References: <20260818040041.1891769-1-anshuman.khandual@arm.com>
 <20260818040041.1891769-2-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260818040041.1891769-2-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 40B1E80003
X-Stat-Signature: 35tmwjmmzbp9o4aax9cznb47i334xjdr
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787073918-502688
X-HE-Meta: U2FsdGVkX1/BW8XCcRXIjdLRCcGjmmgmUP4Rf+7zHDkp+jANokaeEeqEjVkHOLxZ339+UAqC0XWPcgLQGVeK19Yv+oKOOVCmtZwQ36J2aR3RqjWAnTufqv7/f67472j6gedtl91HtQzOwUQt4QAvpfC0Itza3F+ch1PTQveVFxfE9HZMueiCfwFdItaw5fry+a6NR/QUVZSicqZBzF8XXRXXMKUC9Efts11ozkhxAHtKzwrPiQbLxsVU11HSr9lTpibQ5ibOCB/zoSj4iWp4knxnM2CoSYwCiUOMoifEZV8+hhaUdT1zzV0FZlJRpIe+vzRuuteApDlThHRI0l4JBPlvx3ODEvkT2iuIY+Scrt4EpKjRgs7nl57jVwSz1HUabT/gkNL2pBnL+YZXEcTIrfnw4HoTxDmqVhgGTcFnj39O+acFx4SLfNUB7CWjhffaBSSYNI7GNXJtWP9PprPtCJu0B0bZ9ToDnStcsPF7BJN/SmXUVxPpih+RspLX4dUcqKxZuGVN69nG9/QX6SMl0yMLnpVn5cerhFguLZeATC+iaygdj0sYj82rCY/MD2EhLNeOEirnFIy3yrUqgsmDr4kJ7xSKhfXz/Oy61e7/Z+ygKSfWFVQTfMy/MCp/W+GqZAY3LMdOqqD9vfxaKP1Ue+jv5odv0BaMyTQVFFIU1ttXOagZDO2la5QE4tsxX1AmCnR6+rKbvyfbhFfZlr/H2/WD2YkJStdoTgMcwTAO7m5CGpH5g1ykZvYbVUaDlumuuLLr6YHWmLgFS5bGq2BORbRL3pOgPmOsKvgJqkvS3sOo3vYoBqLiYl7ELK71JwU2dMZ69DO8gmoCJAppAXDqoe2/e+TFiglolXtlkiQbbMw+qdSLnfJ6GefdNqRRI+gnM2bm8JiQAx99QaqjgPdeY07n7FjqiN9eAQ40Y7hBTziC2IUBTLqByNAcJKYZT5nWgYI5ba4p0GEg6DZp7Rx
 c0NW+2IW
 ej2qxIndVYrdLuHYNM73FaEze+qd13z0ZI53bfvmhPmf37HmmyHtEbCWosyq3+ZgRFl8sEB12XTh2/X8s7OWx0Hwy+QkCzClJ647XAzcN8KNKLKvGTT+jNZ7A4tJnDyoac80pO2nb3+XKYhtQFB2wi4RJDf2kdkW3lyf11kVFSQCT1SZmirjcrk5G53SzRxl8YCB0LF/xlKjC6GZzxEAF4Y+hsAzpp8ABv38Fy7NLzR64FQIqts0A63bbXwOYzrksxaNZ2hKd8TXlZu4kcwaEK9KDwk/2GJ/pOcmJWfmbjhWUu5HuKRG6rVgrv4Yg5Dg9poyLhJ75s+JaM7ID3h3Kpz1KJvzAuXtZDHw6ABrfwImLIYn1RsTDxwLAGgkNUE5bPFcY9QZdp9ZmEE4hweVOlcu8upHTO934hsPgUf+J27ZqNwwbYa/XOImq3bOnizs4W/p19NzDxWog2L9c/ZST7sU7Fo0A5TYRUY7ibLkxCIU+un8F0P44p85zMGBKKV9R3Pw1BwDK9XfTH/SojU4kEtsBUkFhfg6xekwrMQWmrkS2N4MSiS+J0gW2UBONvYbiRMmqOjjTMPOWrE4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 06:00, Anshuman Khandual wrote:
> Move ptrval_to_str() inside a header thus making the helper more generally
> available for new users which are being added later. While here, also move
> another related string size macro PTVAL_STR_MAX inside the header as well.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

I would have placed that into include/linux/pgtable.h. Any particular reason for
mm_types?

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

