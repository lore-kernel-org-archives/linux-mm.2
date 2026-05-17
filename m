Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 803A7CD4F3C
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 06:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7DE6B0005; Sun, 17 May 2026 02:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 572686B0088; Sun, 17 May 2026 02:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439E06B008C; Sun, 17 May 2026 02:28:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8716B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 02:28:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3D6831405BC
	for <linux-mm@kvack.org>; Sun, 17 May 2026 06:28:13 +0000 (UTC)
X-FDA: 84775932066.11.7FE4F3C
Received: from cvsmtppost25.nm.naver.com (cvsmtppost25.nm.naver.com [114.111.35.36])
	by imf14.hostedemail.com (Postfix) with ESMTP id 83924100009
	for <linux-mm@kvack.org>; Sun, 17 May 2026 06:28:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=naver.com header.s=s20171208 header.b=juQwQlsv;
	spf=pass (imf14.hostedemail.com: domain of gganji11@naver.com designates 114.111.35.36 as permitted sender) smtp.mailfrom=gganji11@naver.com;
	dmarc=pass (policy=none) header.from=naver.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778999291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Rl8U5lF6kUN1UEVcJCjeQetsycSspUmJN4b0JVTpHw=;
	b=2ljHhtqvyX0Wgy1TK+l6+v0rwTE7e+kv7wTaacpz523fVJaF5pA+2s724L8UYQgzDSxXk9
	jurpZz4w0IP08UKAScYzp5Y73b+oIQ1HhZHLfZ/sXNDruMGzJ0YAdyob/451eR4CrH2om6
	NW4ZWtgz1U41ITKRKLwmLcD9Z8NsN04=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=naver.com header.s=s20171208 header.b=juQwQlsv;
	spf=pass (imf14.hostedemail.com: domain of gganji11@naver.com designates 114.111.35.36 as permitted sender) smtp.mailfrom=gganji11@naver.com;
	dmarc=pass (policy=none) header.from=naver.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778999291; a=rsa-sha256;
	cv=none;
	b=KIdigVSNKhGPJ/E+2tI/9RzHlSfnStppJrKPv8nCJ6mL9ABbsPgUxtIT2obBZ27XYXBgYb
	Kzgj1lflVnYqHdoi36PgIw00DORl17PLqBwhUVkET//ooSSnGm2C5sKzKnAZVmLvsOgngi
	7hV/ZNuPLvYfQqMbmh9/CLxLT7Vj6A0=
X-Originating-IP: 1.219.165.140
Received: from cvsendbo001.nm ([10.112.18.53])
  by cvsmtppost25.nm.naver.com with ESMTP id 4UstVSt0Qs2pUYZ7LltYjw
  for <linux-mm@kvack.org>;
  Sun, 17 May 2026 06:28:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1778999287; bh=A9Gygzf70+nWKnVlj44HVFuG2rmL4Zm973DScGNh1DM=;
	h=From:To:Subject:Date:Message-Id:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=juQwQlsvP+G8Xmmw5cTLbfpFlI2fcUMnoph/jEZBuE37aNTSxL5j6Jys39lgZ3pE7
	 yr7YEuKjSWkH3V3/8GRKFa0pkq4HKXvcMxFEB12IrpPaa3kSufqfEU24Sa7jiwwK8s
	 4NDKz+bTpFvvBjbCr1hgRL5p9tvVrZcKiAD6i6jv27yyqV4cytKXHkwY8ZH2f8AQcd
	 q/4n4byDokAzpzaOlqpnYmztAh79tliH/6Z/7gPcVDqRhqi+3+kg6IteJ+XtDcOCDX
	 Ofups5oRhaXdCoZ2d+hY0FJkDtx6ArLbTdqNvNFEsEeN36SrS5Ii8pTis2zGgfJIb0
	 RoOQ8G9YLRXiw==
X-Session-ID: EtOBAwjCSrS0IdSlGK01lw
X-Originating-IP: 1.219.165.140
X-Works-Send-Opt: LPYwjAJYjHmZKoK9KBmZFA2ZaACYEu9YKBmm
X-Works-Smtp-Source: zrKrax2XFqJZ+HmraA2r+6E=
Received: from DESKTOP-PE9G5L9.localdomain ([1.219.165.140])
  by cvnsmtp007.nm.naver.com with ESMTP id EtOBAwjCSrS0IdSlGK01lw
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Sun, 17 May 2026 06:28:06 -0000
From: Heechan Kang <gganji11@naver.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Michael Bommarito <michael.bommarito@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	David Carlier <devnexen@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Heechan Kang <gganji11@naver.com>
Subject: Re: [PATCH] userfaultfd: snapshot VMA state across UFFDIO_COPY retry
Date: Sun, 17 May 2026 15:28:02 +0900
Message-Id: <20260517062802.1860677-1-gganji11@naver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <agYNorGjJb3epGdh@kernel.org>
References: <20260514005440.3361406-1-michael.bommarito@gmail.com> <agYNorGjJb3epGdh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 83924100009
X-Stat-Signature: n7rxx78pwp114cbrq34t665yqq5hfbo3
X-HE-Tag: 1778999290-139907
X-HE-Meta: U2FsdGVkX18sB/kVCMjYJyen12qHVpXrO0QiFSkXYsIshaUBgilUmsEfp8wTjDEsvzeM9WDjqAlTxUwppubrfWvWSFGZMNMCd+5LjlsN3z8mESm68DZmosLWjqC+QdDa2Gj0/K/U4yxLTio8ZUNohuHKFVQwVUm1kssNXcKHLpFEYFoU9y8oPE4KDQyeViFwMNzGCM/yLFYIrZD796yU+E2W/1eMa+2csDUdnQwv4osDYDB9gOS9g5L1H0cgt5u/XKsLxJEIV6KOxSfmZR9DAbTbRfiRQ2jXMKDJt+YgBGHwvhpNxzrw0ImZbGMVGQ7e28avk0wSOtVikO9NTUicfy6PAf1kNBRJJwl5bTRrLA4TY7PqivTEGVrEMNjnpCcWZK5wvpv3BpNx1siqmxOILz1YcTFfCISXYenccwoXvwVN2GWi66pKl8JG/59bg7/7D73IDvmv5xrLgybHV2IJE9Nj1mB4gOE0WXFo/QNCd5+9OrwJ4jESs5bgkGQple07Q9aazMlINA/oW4Lhnk44lfmEKzAV9+9ppKZMAGACXsvIEb5et+cEPL1tN8nTuCNVG1OcTFLXGLuEDQfWGlF9eQWIOgEBA6TwKQsIr8Ol3GgTud7hi7LXkOQhtZuBM4OvmK9LyRw/TiZorEg2Vcol/B+Xks4feXFYwNrR/9Nwnb2w1ctFLZJ8fGEAZ9n/Qcx22u7Lzrvut2WEueoPvcPwMiicWqsQrjQcvZEbiCtn8wtW/NA4tm6ll03wl8QnLpRzCfovr8vCEV96PsNk3jsXfow4XMjZj4Z0NtYntk+0z/2cZeoeV+0mWthmEHfajl1clHXixbdU3SaziSq7InuqF8a/3Lr2fd0IlqLVyGz5WkPYc8wC9R29QEWPmiKiv8k0guQtniEOUfCsiCJ75hG9vsGq0Qxs6djWcuZIaoGmKvY9lMrbnaD/PNgjG1Jib6CrNUkGzPZQvXm0ZHfuGfG
 AiYjfZJT
 gMDoCG+Xg4ErL0uhhymAQcF7GEAYfbZI/T+Px7VBY+yFkDpKU7wi8eRhdQPC44xI66EX724U/fc6d+5Td/xcEy5pryLV5L6AqpZaa2N9LOXWz1U9VKfUhT91Ix3D1GYAKV+MGimjnLkFRJt6Hyy25CX1lISz/MXQMO8PNF3LXpKexqPITJtU6ZAo4WWTr0a1Duf6v+eI/LfH6JzMpIGafb4117fiie9jf7tpf7A1w01EPZDd2Pa02LxTe34Aataq1y46NneXB2N1z/JYbq1gOu7eef2D4OIIuORSAHQDJ/R8KmrzCDwAYAGj+Ma6cue52mKAXJnFEjK3tHk/4glD20+IueJ6AGUYNtgJIaOI1M0clTFleX+j+VNdl9Wxr1Tj7IrUrj9JHa5ksW8Ormpf6/Ysj6OicB0lh/kyFEn4+/ZjQwTkRrX4XfTgI8B0Kk4e8LrnJqda7SbY0esazjr7zZ4GfqigTnO1LrmQ29Sfpf+aTNgLeUBaV7fSpmOmXzsUNJzMSWFaDHJMFBfFn7b+QMcOwUYDIvZVoMvtDF/Y7fuxA+l2e5hKe/pgbADIN1sj6jnMqm6+AKQiNPiwpTRRtvYoCqZIj4Xco1ppxnye24O+sbNM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Mike,

I tested the vma_snapshot patch from this message on top of:

  6916d5703ddf ("Merge tag 'drm-fixes-2026-05-16' of https://gitlab.freedesktop.org/drm/kernel")
  v7.1-rc3-362-g6916d5703ddf

I used my UFFDIO_COPY MAP_SHARED tmpfs -> MAP_PRIVATE tmpfs replacement
reproducer against a root-owned 0444 sparse tmpfs file.

Before the test:

  sha256: ad7facb2586fc6e966c004d7d1d16b024f5805ff7cb47c7a85dabd8b48892ca7

After running 30000 attempts as uid 1000, the reproducer reported:

  RESULT: not reproduced after 30000 attempts

The target file remained unchanged:

  sha256: ad7facb2586fc6e966c004d7d1d16b024f5805ff7cb47c7a85dabd8b48892ca7
  first 32 bytes remained zero

So this patch fixes the MAP_SHARED tmpfs -> MAP_PRIVATE tmpfs replacement
case I tested. I did not separately test the MAP_PRIVATE -> MAP_SHARED
panic case.

Tested-by: Heechan Kang <gganji11@naver.com>

Thanks,
Heechan

