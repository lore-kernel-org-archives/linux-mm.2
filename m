Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE701C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 05:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E8A06B00A9; Wed,  1 Jul 2026 01:01:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899836B00AC; Wed,  1 Jul 2026 01:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB996B00A9; Wed,  1 Jul 2026 01:01:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57C1F6B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:01:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B819A8C5E1
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:01:29 +0000 (UTC)
X-FDA: 84939009498.23.689BF6E
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1D73E20004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:01:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782882088;
	b=DCRODdIPAds/P/7JViFLlvuY12lKnrl+PY7unySlCceWO8FCkKrA4RXLYfY89JWgn0QLOd
	v2eRCdMxJJt7MIZmOGgG2Z0F+mtnksiDkRulu+2Hu6z6G6MhILdLvSvA+wg9cpG6zmSXX5
	zQ+GMFV/q6GqWEaEgRs9vEAyXR+0QDI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782882088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9eB9DJeUcSgw7n3l3tqGhEAIZqJW6Uq4QI/4au/pHGA=;
	b=xTqL1VVfFPQTVb+wHT5IQ09VaXLl4xuzBniy3vV6200vbEJdQ8DQZi4KKUdcXHKmoe3rAC
	kmKzb177DGf+13sz6sTYV/bx8Fg1OWE+kKRE8ilVQgnPS8rPG/+myl6WaNsW/sQRi0QWn5
	pTbSK4QCXWkfq130ObLeBEd9x5nXqQk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn;
	dmarc=none
Received: from [10.213.6.98] (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAAHqtIbn0RqUP83BA--.18158S2;
	Wed, 01 Jul 2026 13:01:16 +0800 (CST)
Message-ID: <cd8cd425-7615-49a2-b26e-81a9aff0af28@iscas.ac.cn>
Date: Wed, 1 Jul 2026 13:01:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] riscv: mm: Avoid spurious fault after hotplugging
 vmemmap
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260630-mark-after-vmemmap-populate-v4-1-febbc15da028@iscas.ac.cn>
 <20260630211100.5c8f09c607595fbb5bca0a74@linux-foundation.org>
Content-Language: en-US
From: Vivian Wang <wangruikang@iscas.ac.cn>
In-Reply-To: <20260630211100.5c8f09c607595fbb5bca0a74@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-CM-TRANSID:qwCowAAHqtIbn0RqUP83BA--.18158S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZw15Kw1UArWrCr1kZrWfGrg_yoWkWrX_Cr
	sxKa4DW3yDJ3WDKw4rKF43Wr4kJayDA3yjvw1kKFWYvr9xAFnxXrZ2gryfuas7Gw4IqF1D
	J3srK3yfJw12vjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbskYjsxI4VWkKwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
	6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
	8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0
	cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4
	A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
	w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Wrv_ZF1lYx0Ex4A2jsIE14v26F4UJVW0ow
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l
	c7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
	1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
	14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
	IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E
	87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73Uj
	IFyTuYvjxUgl19UUUUU
X-Originating-IP: [36.110.52.2]
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/
X-Rspam-User: 
X-Stat-Signature: 4oxnorxzd7s4xwhihtx1jyja5fws9pyf
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1D73E20004
X-HE-Tag: 1782882085-893445
X-HE-Meta: U2FsdGVkX18W9QZIzmaH3wrCAzzAjwVA1Bal5l+D33r5fUSZmbH3nYLuo7JzE39MGaaYBP1HOqKWMBJNbrJ6KDjL5fnAfail7lkVejL3yIdOx4C/IMJyYKFJBDyQV+frjT/kuC01Ezs9y/WnhxUS46271iOAZWaDPmJyTWTcM/YrNci/3yHx2WZrYj3/b3A3w9PkY1kzEJDNULIOiVjhigcRm+SoHz8DHnCmh823NenKnB/0r+2Ty42LCkZ0Hv1vMBp7O8jKEtqdHPZDf58/VrRZqTrdBXCkc86g6LDyXeFKHINnvSiC4Fw2wc7MMPpcU4qkTro2LC/yXbg33G07h8/2cegAnkNLdH5TjyuwJHyTXQlz4RhC9DKXRnk8H/M2MmIFRNjJ1NdIKVfcgAZ+a7EnfKKi7KNc5RxGmI5tEHSZbCOEZ9UbO1yanzHZkudLR+4VqIscbsc2P6Vv97NPJRqJmQT3QR6+XnkXkjry20jO2RvWSSVAbz+I4+IuVXO+H8Ie5xvE/U+xXtysQcM9hVT2viWFfh7VAvQTkC+XXC0fHy/gvUNxcLzdxONIMsfJt8rbzP/oJ3MHYdO+i5Zu2a9Kkpg3tj0LmyuTuc+EMMczy/9UVr5sBxxhqztizp95PeuDwiBU1tS5OCmpDCigFWOzoy0UIcWiTtGftz27VOz1DLe2Ori9c/l9e/pvnOLgSHvOb/n4C4Bk+YdvSuBuSwJLeMipnzgLWFV034l5z9vHttcDC8Ifs/M2YnRMdekQTBCNxnf1AZgtBTzZhUJUqPhrfkre5w9CjQeWI6cs7eeIZwNx96Z0VOHH3L6EApZMcTtMuuupW/exaOYEVZo5mQkxQ/Yebr2fzpkWckgELp2w9sNxUrTuTs9hwDRa40J4dMUmCtWYoSt5dx34vC6p8oaKwzIHTLz8C0MFz/9Nq2E4dUjfgwlP5iZUpWRzLDhRRTG5QCqi1Xv41v6msD9
 QbOg9OcH
 bAotR0INBuFtQUB9L4dgidMLb6bwXbYeDwYw+vIZiCcHZWd/YTcrdYKOoOuhfjHe9tcMX02vgYdc3NS8ZlqrcJp7H16SmqWmdCw0FCuKiWASuT1hkrOrWC8djdcTlYdr+4rGId3xf8B/AIhHZ1zScn+LR4kOiFMbVIOqsa4K1eLHwUrK/C45b85urtgkjxtuqWjUUkRlDOabkzSMcFssNWbwT0mJUhTUjB8UTVA7idSSQU/Sar4pmmimWu5OyRhEUkRXMQ4nT75icdZnaSBV5AO5WlHmu8df96izdH1EevcoSwrVPrAJwp1YZF2+8U6P7XH6doxgPiZUrySxduptlfU8Kzvc20sF/ghDJm+PMqY9YEUv0BsC352hbOA+xb3Nzjsn7eyPHlXFgN9GRyJG5h5abag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 12:11, Andrew Morton wrote:
> [...]
>
> btw, AI review suggests that there's a missing barrier in there (a
> pre-existing thing)
>
> 	https://sashiko.dev/#/patchset/20260630-mark-after-vmemmap-populate-v4=
-1-febbc15da028@iscas.ac.cn

Interestingly, whatever thingy that is sending patches into AI review
seems to completely strip the message below the "---", which made it miss=
:

    Changes in v4:
    - Rebase on v7.2-rc1, drop dependencies
    - (No code changes otherwise)
    - (A concurrency fix for mark_new_valid_map was sent independently)
    =C2=A0 https://lore.kernel.org/linux-riscv/20260629-riscv-mm-new-vali=
d-map-ordering-v1-1-60d8c10c6292@iscas.ac.cn/
      ^--- this

    - Link to v3: https://patch.msgid.link/20260605-mark-after-vmemmap-po=
pulate-v3-1-a06001ac9264@iscas.ac.cn

("Changes" was probably not the best place to this kind of addressing
review comments, but this definitely belonged below the cut.)

I've reported "being able to read below the cut" as a feature request to
Sashiko: https://github.com/sashiko-dev/sashiko/issues/306

Vivian "dramforever" Wang


