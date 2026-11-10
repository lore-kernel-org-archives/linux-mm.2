Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7749D60A2600
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F9C36B00EF; Mon,  9 Nov 2026 20:29:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5838E6B05B0; Mon,  9 Nov 2026 20:29:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 429C26B05B1; Mon,  9 Nov 2026 20:29:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10E156B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:29:17 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81291A83CA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:29:16 +0000 (UTC)
X-FDA: 85417476312.27.B89B201
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf07.hostedemail.com (Postfix) with ESMTP id BAB9140002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:29:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794274154;
	b=gFR/+IHA5iowbt3GVa9sjsQXk43BpkzjqUJhAbGDX5NHppCipIJOj8uKe7YjCfitRXRZmZ
	TeU4hkahIeJLSkUn06qXy9OuMm8H6bkEfSRh++TF4D4FUcGSVkKjtyVVtuvP6D1984Vui8
	pxz9wJrcZBRt/imHt7FC38OQT11GsX8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794274154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aVUk5KNfoVM/ifJWEbEfsYize+Uhc5V1gasZQZSUIGY=;
	b=U5Nq8H7tH7WYZlYiiNHyMnhoJs2eb195/4PYEpK6UhaiV9U7bNaku3sFM+S0hAyJYydqId
	+JwsccecAUugf0grPaNETlqA0fOhtaLiFosHnBVqtqlmSEOz8PJTgZvDSxiGAoKueKOxNH
	57x9+++l+18FasotD0tifwMNtL9GRBE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn
Received: from loongson.cn (unknown [123.138.236.242])
	by gateway (Coremail) with SMTP id _____8BxbdJic_JqYQQeAA--.22802S3;
	Tue, 10 Nov 2026 09:29:06 +0800 (CST)
Received: from [127.0.0.1] (unknown [123.138.236.242])
	by front1 (Coremail) with SMTP id qMiowJDxTs9gc_Jq7l0zAA--.39359S2;
	Tue, 10 Nov 2026 09:29:05 +0800 (CST)
Subject: Re: [PATCH v2] mm/slub: Genericize x86-specific cmpxchg16b comment
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, loongarch@lists.linux.dev, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261109035906.10857-1-yangtiezhu@loongson.cn>
 <DMQW32TTNOPX.24GN6Q7VI6QJR@gmail.com>
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <145c23ea-bc4d-b235-c822-df94b00a647a@loongson.cn>
Date: Tue, 10 Nov 2026 09:29:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <DMQW32TTNOPX.24GN6Q7VI6QJR@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:qMiowJDxTs9gc_Jq7l0zAA--.39359S2
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj9xXoWruryxJF1kWr43AFykXF43urX_yoWfGFb_Cw
	n8GF1vkw18XFnayF10kF12vryUuws2qrs7ZrZ8JFyYy34kt3s5CFs5Cr4fGr15XFsayrs3
	Kw4DXF9xZFZxCosvyTuYvTs0mTUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbxxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8
	JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4
	xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v2
	6r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67
	vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
	1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU7_MaUUUU
	U
X-Rspamd-Queue-Id: BAB9140002
X-Rspamd-Server: rspam12
X-Stat-Signature: 9c3uhg3momaqho6dx5dz57n5e53s1qrr
X-Rspam-User:
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794274152-391111
X-HE-Meta: U2FsdGVkX18jSni/QmiqW4XbJcOS7XwnjtN2llH891RLDFWgPdF5UPTlD9H3025FjkjOIvvcjvN+t0Bu1WYTn4EdP7Cav9M5jbR5GOeHC7ZqEqBEO/H8HTNL3vg3H1a9WsIedL/A2e/+y5vQRuFOqT6vRoQUJcYY4Wz98qYkopjJpIiRjpqTTpaj/WWv3MULwnqKgPt3M7qxvclfjfEnmAJ244tDj0M8QBCbDIZduDBssUlrIYIefehOTnCYtfNgxlXSYm2m6hRmtbzCrvq7Xg24cj+IgTMer7/Tro6c14I4Yvpucvdsy8QKkrxxzyUZAJU6uPqfZHb3+wkrViBgLJLbAdQPU2chpe73OcsBSUi/XW71Mip9JkWnhU5FxNXT9CbPC5lgMclIo5oMWDM/fO8hcTIDGeuMQSBmQcMD89O8WjgBfCaOSlHGXbkJaMDtL1WHJY0Te8XgiInmzYlrbcx9miNaYZjoucBgK86pklPk3tqnsrKQQkEDT/yrOgJP5FeS39u/aUrEFcDyJ3xMBIVyykhZ1Ij9RFsqbLstDpZWSXL3RfxrOr1MX5Gr1szD1wRUFcQVcDRXXqCX19rE3GEfiatAlSMmfbImyM75BEufTLoO4GpTWJqd4KoopQ+0LUjJ7cm8ZgxpIN6pcNwUtaJE/1h2zSdHh/l4j29cA/TAcoXRwyqWkcKVSYgUglMQFOor74vdGK11uD3eV0uqqSp0zcwwowd3B/1p0BVN8+53iP+r1YZ3A/XIT4YSPFfvcqnnekWvVucRRpjdDfSmH4GT7MziMo6vECKbsI1Dimq4HP6mvX98lz8adyEJEzdEbfAg4RVMhC/yi1N8ms2Hg/f6oNSWxiAkQxlNRTIOWgEXYKbNbFZfTwlAozMiT8dNsH9tP7ASBSgiUBGjue8WxUVDhR9YijvAOrbtjBh2MBndHo7GxNBKffa6hs8cPOa+zxyhirPRJARuWxQwAzQ
 BxYGhkb9
 G4g3dr4M8ny2Y0IcIMId7+JHOoPnea/Dy5P74ldaveRqI/LJ2hbVqZ8TGAYrYuhOTrCiiu8FOAor9gXhBxGKAgMvBbUQMELUV3iwjPxcy+C82fShZGOM7N1Suyxz/EiFY+zTui6G4Yuh4R2N6sIW8ebOhQAkAT7BlYqXQRXqOv6sUqpJ/SJizds2SJwXYE2ZBWE+bL9xweEZbVKo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 2:25 AM, Alexei Starovoitov wrote:
> On Sun, Nov 08, 2026 at 07:59 PM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>> atomic primitive is satisfied by different hardware implementations:
>> (1) arm64: satisfies it via LSE atomics ('casp' instruction)
> [...]
>> Update the comment to "double-width atomic cmpxchg", which provides the
>> following advantages:
>> (1) Accurately describes the cross-platform hardware invariant.
> 
> You ignored Hao's point about shorter commit logs.

If the following shorter commit message is preferred:

   mm/slub: Genericize x86-specific cmpxchg16b comment

   In __kmalloc_nolock_noprof(), update the comment from x86-specific
   "cmpxchg16b" to generic "double-width atomic cmpxchg".

I will wait for a while for more feedback from mm maintainers and send
v3 if necessary.

Thanks,
Tiezhu


