Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1170EC4451B
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 22:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3AE76B0088; Sun, 19 Jul 2026 18:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C13176B008C; Sun, 19 Jul 2026 18:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04616B0092; Sun, 19 Jul 2026 18:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C0036B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 18:31:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7131120700
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 22:31:58 +0000 (UTC)
X-FDA: 85006975116.22.25A8BA9
Received: from smtp-bc0f.mail.infomaniak.ch (smtp-bc0f.mail.infomaniak.ch [45.157.188.15])
	by imf20.hostedemail.com (Postfix) with ESMTP id ABEED1C000A
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 22:31:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ik.me header.s=20200325 header.b=LJk+VVcg;
	spf=pass (imf20.hostedemail.com: domain of nadia.yvette.chambers@ik.me designates 45.157.188.15 as permitted sender) smtp.mailfrom=nadia.yvette.chambers@ik.me;
	dmarc=pass (policy=reject) header.from=ik.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784500317;
	b=nDJ+T06cUid2ebFbbmc63l0reIgsVvHNgkd3ITW1dIRSKxOVCmHtyQdMIVn+WagkxOvGCi
	bx2jUfBg43hqbH99GWB+j6MHhqxRbQLXBUugg9m80ypjXxxHohPhA/Nnk1XUDhHUsqn1HA
	ksp9u18WTfFSB192n7mqbzzUV/0e40U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ik.me header.s=20200325 header.b=LJk+VVcg;
	spf=pass (imf20.hostedemail.com: domain of nadia.yvette.chambers@ik.me designates 45.157.188.15 as permitted sender) smtp.mailfrom=nadia.yvette.chambers@ik.me;
	dmarc=pass (policy=reject) header.from=ik.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784500317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wM1/+Ssl5lb/f8P5nWzlhL+7cN81hvJNcfIMkDKJQJM=;
	b=VI0bG9LGorGG2xCjlC/ruvi9o6jI1NUOEgT5ecSb2UJQPlwDTMey7vr9I7hkhu+16Fd+zB
	cEMwq/X5SIm7mFzC+mPg8FHdVkQ4x4jXL4ysysLqTrocNLFLA0uYKaVQpH76Ox8REng6w4
	zl8XuOAZHPK9VM5P8ZVhe7OzKBFUQ1Y=
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4h3JKk6rKTz7WY;
	Mon, 20 Jul 2026 00:31:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ik.me; s=20200325;
	t=1784500314; bh=wM1/+Ssl5lb/f8P5nWzlhL+7cN81hvJNcfIMkDKJQJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LJk+VVcgpPTVwDgGzASJk8W6JvdF0ueL6YzhxX43xjN5jtCft3Yc80T+0Qmeuld4T
	 RxAZ2BFGifR8sc7DSuQ4r7nPmWBs7dViyKqk1KA3f53HA6XTz4AV/P+usTXBbI6CvE
	 A9QXcFb2ZoJ9bbYEi8S7JhoWomdWOqr0tmpn4G3c=
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4h3JKj0jRszgmr;
	Mon, 20 Jul 2026 00:31:53 +0200 (CEST)
Date: Mon, 20 Jul 2026 00:31:51 +0200
From: Nadia Chambers <nadia.yvette.chambers@ik.me>
To: David Laight <david.laight.linux@gmail.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, lsf-pc@lists.linux-foundation.org, 
	linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <al1O957ydi8MvOHF@ik.me>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <20260220090409.1784bc64@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260220090409.1784bc64@pumpkin>
Feedback-ID: :965687c8d9b437c:ham:b89b32586f6d122
X-Infomaniak-Routing: alpha
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ABEED1C000A
X-Stat-Signature: kwmi19tgrit6ss6z15ow4rxauossbd7h
X-HE-Tag: 1784500316-501033
X-HE-Meta: U2FsdGVkX1/yMxL+5/BJ+FFwDIdkpbIwKvv1lbImWxCrqzCCBA0XXhynbn5mxOxKzmkMJXXER3W3hrtGsX6857QisO0C3SzACsORL/ASZvlSX/HPGX7cp3JblKAjBX/7uxzMfiWguEKD6mf94KIhPI9sTPnRi+OIB3aN+7fk3P2up7pQHJOvP8XRb/IiLTBv8woEC09AyGcCEA7PttRafQuu3zVupTUBvNbnXdhEJU8FduDGJ43WQg7elET9fCQ0g1voMgSb6L6HBJ5pfxVkaLG6sWdOWFJ6wyFHdXJhN94ToUUWuf5zoY6sr3nv1bwmwjPHYj11DO8FGno7kNlk3a9HL/QR2JhYdxoe1FtIRNVB1CVfmzYAMUULyPAQ6qsxz1vycU9afg3m8kN91BHQ+vQSDVpiD3kYkG3vXAqFGFGjH8LxT5tsj8RvdShJgV0W/gzNB4j8yL0ANUEnMbz1HREQgXxjCuZS6yDqOY4ZCR/lnMuyNNGANuNNrawKPItOHBMxz4fchCjz1TQp9ckipcNhXAFiE4htLC5LXUR9q07qLVEAqq0/d/TpOSBkeMJgu9hA6GjskVQLmwyzuYlQZTn1JdlatLlmLVgNkIiIVTU16MXRS/YJDFygpC97Q159HX683iGCqfWPJyLLuJ9a0mVcUJPlHUL91JZ2l1Yadej3Tzw1N42xNWUVoBBG0SPuzsNFldjJeYJwgn4k/X/63FdQ6Ng4Iq939Nh8nIw0g6RIQvwKY/meLo9Y5kdjWXVAvVzK3vk3TAvisT3L2dnL6OdI3TmO3MoTnwP4cEJSSwJwHrWywhAvxQTZlkMF7lTrHL8JAIBbZEBb/v13cGbuE3RJe6F7nTFXvXCrhTfMzLrX6mICc+5MJ40NguRmqJHJkmFWMqFeQuNdbsz+8bpXI9DBnvZgvUKMEE5vZeLHVUUENyeAasSc2fUd2VU6txdpa2Za3TGqbbzbqUnNCVV
 3QS9OCQc
 Gg3OUBpv/+QrhFHC2gWDUzmM19O1mDVuWpNil901PQT/Z5XiFlkwXjXbXaLkAOWdVifWB8j/YQW7D3XjIZTFrQWI2+ExsDD0taYwTlMeRjCVZWajDfKP3YbPsqQUySASoBNfBwnHf7ne/5viIwQe8sa40MQQqy+qtEJVkxiRfzE5zp1k//nxjmm1xGP/bU4yq/W/gwepBYtzIQZuKZWXq+mwvpTcwNjCHURYzBiw5va4Sv8uFlxz47+AbilTRF/51XgERZaaR4IyuatdYkrlDTd/ehBNh7RBHLvhUFrIca+NHuCJjgbmWijF34qjFxIEbHgFnuZKJkzei2pvUCmk/F9e4Ko2n/esSD58IRkwEjDXH0b/2gsWzEjT7RGQRYMDIRd31mqFIvifEiJA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Feb 2026 15:08:51 +0000 Kiryl Shutsemau <kas@kernel.org> wrote:
>> No, there's no new hardware (that I know of). I want to explore what
>> page size means.
>> The kernel uses the same value - PAGE_SIZE - for two things:
>>   - the order-0 buddy allocation size;
>>   - the granularity of virtual address space mapping;

Am Fr, Feb 20, 2026 um 09:04:09 +0000, David Laight schrieb:
> Also the 'random' buffers that are PAGE_SIZE rather than 4k.
> I also wonder how is affects mmap of kernel memory and the alignement
> of PCIe windows (etc).

It doesn't. Any adequate implementation has to sweep drivers and update
them to use MMUPAGE_SIZE or other address calculations that are still
correct for device memory, buffers need sizing so they work usw.

Yes, those things are there. Sweeping them is integral to implementing
page clustering, whether it was Hugh, me, Andrea or Kiryl.


-- nyc

