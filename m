Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2C35606A331
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 06:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xfC69jVk
Received: by kanga.kvack.org (Postfix)
	id B31376B05BB; Fri, 20 Nov 2026 01:08:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1766B05BC; Fri, 20 Nov 2026 01:08:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1F046B05BD; Fri, 20 Nov 2026 01:08:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6E96B05BB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:08:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F39F11C486F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:08:44 +0000 (UTC)
X-FDA: 85454468568.30.4BFB327
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6279412000B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:08:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xfC69jVk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of joaoanandalima@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=joaoanandalima@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795154923;
	b=3F4OfKzE9E977e1x8GBYBg1YF1euiD0bndB0KSCjNXWxTSK/gFZ73MtiLMqAuwmpuUvKa+
	uapeLwfm+dI5jLfbHte9GT8QUKhOLMWCFs/muyGlIL+3ZgvWYeNTEdEipPgVmD8WwGDJAG
	7qo48x5hUzYEs8liSHiWA80Pkl0JuDU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795154923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=p95UrQA2ZjM3sDJiu69VdilYW3D+lfsUq1prVd9Q3po=;
	b=4U9O/IjwuljiE+mGbw7dlVS6QTnp4OiyWivH/KZLSW9Jn+s35bMRhqJeANtmWuzztGgfCH
	GHW8Si7KLutrIoLCAG/nJJe0zEYIWbzk8TDcX0Gy73lXbzmDaLbp/vbVCMtKqpFroN7g7m
	nGQzCm1Jv8s42KG0V4RXdFCUpduScZw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xfC69jVk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of joaoanandalima@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=joaoanandalima@gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2f04244c3d0so4361125ad.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795154922; x=1795759722; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p95UrQA2ZjM3sDJiu69VdilYW3D+lfsUq1prVd9Q3po=;
        b=xfC69jVklNXWOw1L3Mmthv4O7uRKgfb4iW9zpE1jKA8tOACe9vSqn+GNdIArFRBY1J
         oXYKfQEyIQ9Yvss/hlQ5p6yfk+QJOrCsk3AzAyMN6LBQu6yq5EbruiBlV7Dj45Ixbxia
         J2JjAN+ZthiQqyqCYXnldxBc1wlLvt32j+Yx0JKiHyQ+9r0O4E9oXe641paXvEZxQwxS
         gV+nSI60+9zjRUSQ6qbUoEVycbMbj0KrGkZ4Qse9SUjVrTJCZMUcPiBW+Q+xPWtrDcb6
         KLdLAm9PwipQrDY6PDvL24GS1j8CpNT/rRNrJksGlDNpGcNbPGb7ATk9OBMAQJQ//+d4
         f2Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795154922; x=1795759722;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=p95UrQA2ZjM3sDJiu69VdilYW3D+lfsUq1prVd9Q3po=;
        b=jiGUZNGM4XRCcDyh3sXj9/7earB8x7CTcgdIV6XqKjJUlI08gZzsYkLCSfk6OoE/lU
         cOc39MtTelgyoAJICEnwOL8fYuKZ0LtDjxLdHv7gh4ItxCbElOVW5AIsk7cUFU2ZeYbY
         c6lsmMwPA6mtZk89bEjyR2iHmjpiAPfVMMfv46y+8LEp1Sg7NWktOfvJgAFa19zR2B/n
         jRcKZk+vGD5ICCcJvYwFF9w7xfbCBYBpQTwoAQ26JsXveQqUgcwzma5WBOHjFkreOmxG
         MbHyyVcLwSLZ/FNx658nJiHJx1tN9Oxwhj9C3O6LuyHyvHBg+jP9odqHMMcbC/a8T68W
         SCKQ==
X-Gm-Message-State: APuU4Z+W680j8Bbdu70twBGzR7fON0hruak89l3Vis57nzHWzw5nnwJ1
	GPyG6tgDmOH3YPm7G0SYmNwsT/34v5n8s9CDpYfAQDXg+Q2fP3kVhPSzdDzPKxwzEM4=
X-Gm-Gg: AZFdTZetyVyZvr7XSTPhjB1LqG1tdXnjmJwAaurgcCCvwDqTJQGdANgpLlvKuZxYWXj
	pN3kbAa6vgeSdwOqeCngYL4eNhvgyfz0EFsv1VGmssGA/6KgtX3C9V9IMAdYEFUYjJtZNguQlPe
	gHJJ0rz90Tt+RuefHwaJndoG33mSm9D3XNQdbteYS/4KtJQkI+9uyD+srzOCIZUow8gz9Oit7g3
	WrbZ4qv6spu8zObCg7x0h08mGIyEv8FD1HgHW7QiQVwBAq+FpAirg+LwKkAjZlZVWA/1DcwMBpD
	RsGBHdMCW9UrQSYJIEtKCoe7New0eZnpO6MfL+yhSLoJue0ADSDqxOzS6bEItjUulj7E7T6Eiyk
	evqpcl+Ed8PbQRtxZxxzOf4NU0tSFbdIEkc74N8H3oOG3wPK3vZ0WM6IiBnhAqEf0tfajZ5njwt
	2b2ciuinvo6acVgX0bfhBC/TMbylfaFX8QSWERAHOyCTnaqUUxbWA6lkFJf2EsS7aZIL0XRYZLX
	HGtddEEVlDgA7CBA0SsBkuJswdOmbwa5nw+YXbOtq98q87RXBpQs4pxCnIaWlSCLk1wMqc9o0Ty
	5XpLmNcW0lMN0mLLfGHGDcWij/ISlB1k/8hhDZwSueCKSeQ8MCueHx2FkRQwE97Yl6Po7pvnM0K
	3JsN4nx2Gpnk=
X-Received: by 2002:a17:90b:1c08:b0:3b0:9deb:d990 with SMTP id 98e67ed59e1d1-3b41cafd549mr1739331a91.39.1795154922012;
        Thu, 19 Nov 2026 22:08:42 -0800 (PST)
Received: from DESKTOP-7QP7L26 ([45.190.211.142])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d63728sm6322499a91.8.2026.11.19.22.08.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Nov 2026 22:08:41 -0800 (PST)
Date: Fri, 20 Nov 2026 03:08:38 -0300 (Hora oficial do Brasil)
From: dev12124 <joaoanandalima@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
cc: vbabka@suse.cz, david@redhat.com, hch@lst.de
Subject: [RFC] mm: alloc__by: create a function for allocate pages in small
 microsseconds in boards no-MMU 
Message-ID: <1ee9b247-6758-c146-2d03-0acea98db33f@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7872875-14611-1795154921=:13716"
X-Rspamd-Queue-Id: 6279412000B
X-Stat-Signature: ebky7y8ur6ngepntugyr7tf3qtymz9br
X-Rspam-User:
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795154923-986124
X-HE-Meta: U2FsdGVkX1+K7HS3nZpeuEUG1hQXUfIw1pjJm5Ryck/9T3sn5HsTauk9xuk3Vgm7c0+pl0HRbp8PHZtsh3AbkFvZQ4zNChACaGdjRH2x8Wb2UEY/xJDwyLJYzfihAY03FcbVm/mtlPKRLHYWm1/YgCCLuG00YZD6jsyeEl+Pb+uHZ2TMXa34a9lTnUCELmrihULB7j7Y35dZn/3aS+3TK6z2in3u9cVLAzErO0/zdDq+uVAYFMsKfPAmRv+w8K3nFX27P7/2P4p0HQ6TIuQPGSRKZ0LnPGLnQw3PxJyMASq33MinyBpU8REGb5/ojJ4+Jk2eE1SnEHshAg1R9l0bJoXFPnOeOs5FzgfiUnMEoDon0DepVhF1QD5m4JX7knFHoZll6VokNj0aCryID8xiIK4UMi7L1ze5/eH5uNm9rZh4buEZffOZ8hZu46X6VGkYsNPCj4hvm+xc5Y5LxRc8DCEjxr15lIPazMLxPNYZZmXMYYJAJeOvmHjRLjuTwkMQl3oY4CaHZPuWmL2KPIjfNyc3lq5NpVrNf11W1stOm324HqbAV9weu2b9l0WmT6JX9xxTdrdk+qJyV+0PqOXf82gInEiCq0hxBpwYqdc/2/UySRTr+CI0E687aJgFbaqWBwUf1oy+ZvsYJK3E4BSr+EweuEU9FyGk2YxTUJA8B4fhn4+FLeOcCujfSt9vx5m2lYXwuAjGvwt08dgj/V9JBAjGMN2ADAmvLKfUbrK+23r3lS/Ktd4tvzOxNwvnIxaWlavZDwoCpAee7ySQ//upo5iL0s88yUAuEoA/u4D7PySr31wN1Ef+vbKegK39chMgRFAAsdYwQDZD7rpKEGCX60AtPkwi5Rz8XloIeeOTsp7l+ZIcXEAUH7xt4oMlFtlipoRNvMesQ27rWFQkmjTTYmLWL0PtKa5ijqjzAa01be+i2Myd/ydGVMS6utK0FW5wl+L65xCGRyYtW8TVcKn
 9qEzgdeh
 ZtVuTAJRLorKZR8PrNDwAHk0Jg+wTX3eCdqZuPWCXfh6l2Q1Nv6Caeg/BhR1Oi1u9uVBl42we8McXUBxAIFfaR2U4Z/x+kmPQBVF5l2i/fTr9MJmJFEDfISEkVrVKcwavCMS8RfWIHvFmluEbdsiFSZDZd6h4VTtFu2YyMtVckt0yXc/E2UkrCxnA/DV3rfDdz4QNUsu8jaK4UQBc1oBJFJtjtWSVtbjJdJBsNJ4C275aTZRZea4OBZA3LXAojkiaoBwXbzvrUXFs/EnBwAhofAI9Mh+NvxGdDQ2Gs6F4hbYJmP6ud44N78SWxMA9Lx3aJMwLWqH2FG4StV+GlqiuHo41dDhU/bE/RNTPyU49rB12ArWJnaIOY1azY708NdjkDeLhw8KZKtr7sQeFxLDpCX97Bh/Ys3j1ILP7MTBn7YElDq6tWmbF7xhTen4OQwwLV3PDOxHS2WBWc1fCqClg4ZEzUOIRhKB3dJa/oxhazIBnIclKO5I9KY0XHoNKBiXJcbVrM4ZXygpD0WrcGjIp6Qy7b9VuyaaZ29BInsD6TfsdPn8OlaHhlej6dec85s9vjzWtedYccKj3KAbfB+rqkIgrtlgkFjvGFnT6wtqvEg7PVcagoimToGtlLMPYJ3Znb+ayCQ8O+8KIcqY/08w/E2ufS8NSkATqZcNB+DrmvrWoFJqTguDKHh1JLWkL8UthaUtTvb6h3qUnZMfY+wUkMwZy6HYk1wwZXnUf6dwYbs6ZEA2AL5zEdFOnqk1p5nT1TJYH/MDv5jaxCxkI9fvYAxCxEpx4ZrRxZxOfZHObnDimQ4RLZ0+bHLcA5U4OjGAQ71DJOzDyOo4C9QaY+K31TCxllh5QaO49WrvTBbcT8/e5gHM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--7872875-14611-1795154921=:13716
Content-Type: text/plain; format=flowed; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi memory subsystem,

Actually, boards no-MMU do not have an integrated MMU to translate 
physical to virtual addresses or support hardware paging and; for this, a 
few points:

I. Requirement for Contiguous Memory
Without an MMU, the kernel cannot combine scattered physical blocks to 
simulate a continuous space, making the search for and allocation of 
larger blocks very slow due to fragmentation.

II. Demand Paging
The system cannot defer physical allocation via page faults; instead, it 
must reserve entire blocks in advance.

III. Use of simplified allocators
such as SLUB_TINY or linear free-list scans (instead of the standard 
SLUB); it saves space by 
scanning simple lists of blocks, but it performs very slowly during 
allocation.

IV. Proposed approach
The function alloc_by(size, address_initial, flag) haves:
* pre-reserved pool per size order;
* cache fast-path no global lock;
* bitmap O(1) of free contiguous blocks.
This bitmap, more specifically the blocks, have the pre-reserved pool (per 
size order)and the pool have word 2:
* Word 1: The initial address (starts in cache fast-path)
* Word 2: The final address.
For example, a Program allocates 277 bytes, the alloc_by() enter and 
verify the bitmap -> viewing the request is 277 bytes, the aproximated 
size is 512 bytes and alloc_by alloc 512 bytes.

Thanks,
João Guilherme da Silva Freitas Lima <joaoanandalima@gmail.com>
--7872875-14611-1795154921=:13716--

