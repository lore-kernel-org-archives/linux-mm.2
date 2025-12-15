Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08AFED5B16E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 14:20:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59BF26B0007; Mon, 15 Dec 2025 09:20:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 578CD6B0008; Mon, 15 Dec 2025 09:20:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1286B000A; Mon, 15 Dec 2025 09:20:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3A3196B0007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:20:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D269013A037
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:20:03 +0000 (UTC)
X-FDA: 84221914686.01.B7FD6FF
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf06.hostedemail.com (Postfix) with ESMTP id C595B180011
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:19:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765808401; a=rsa-sha256;
	cv=none;
	b=h5A0eUXJEz3g0Wf0BMOx5D6DWNFbe98+7QERbXUUBdA1iqAqxcDJQkLKbnO/SGHHNWIiDh
	hQdnP6e9LntsPqKGwdet0I0a4cNSVbNN7nGMp7pvaAG+xJs9to0B8iYSuW7S/k6q89SRVx
	N3NUlwKjjeGLRbbCqazuYvAnYblygvI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765808401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vJtHB5agQJtkgkedcXAXnopwHm4Lb6eqN71i1ydJQ30=;
	b=tW+U4IWIiRjqiQhSQ2Zo9suu0mB1UbXixOtHwXskIxcUniOF03UnjOqddPsrtI8UOw7jeq
	bKwyEPFneOV1sYKbOvPzmK0zKzyuWKhU0aV6ETShGzm1BLU+sFi7XWgVI1RZJfj4AuihJo
	ELkkd94SJkryFTzAE0F3Uso5tss/5bs=
X-UUID: 1d6263d0d9c111f0a38c85956e01ac42-20251215
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:dc04beda-5203-40b5-b43f-f1ba260bfba1,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:dc04beda-5203-40b5-b43f-f1ba260bfba1,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:c48fc8d29e45d7aeddde6f1fb5a8a4da,BulkI
	D:2512120555166V56SJ2P,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:
	nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0
	,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1d6263d0d9c111f0a38c85956e01ac42-20251215
X-User: lienze@kylinos.cn
Received: from [192.168.3.106] [(61.48.214.33)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 2023791574; Mon, 15 Dec 2025 22:19:49 +0800
Message-ID: <a14163a9-0553-4baa-8887-4e7203014887@kylinos.cn>
Date: Mon, 15 Dec 2025 22:19:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon: add loadable module support for sample modules
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 enze.li@gmx.com, Christoph Hellwig <hch@infradead.org>
References: <20251211215504.79014-1-sj@kernel.org>
Content-Language: en-US
From: Enze Li <lienze@kylinos.cn>
In-Reply-To: <20251211215504.79014-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C595B180011
X-Rspamd-Server: rspam03
X-Stat-Signature: y6db93gnqfngta7m6ut86krst78mjt33
X-Rspam-User: 
X-HE-Tag: 1765808399-998560
X-HE-Meta: U2FsdGVkX1/nDmQYVAn21TVwnlA+vep0I0yhk9xSjK46ZYajzkRGUYSszpPdifE+WesHRO37MVQzF44eJKR4w51qn8An/q+qpdDKD+iKq86HLhWana5+aGwGqfn4j4JJ06WvXLp8E7PfmO1WeyV5MKG8GdrNRWPpssDX88V2nrm8zWGCcWoe0L7iKeeE9csvhwrVXir69BAna6un4TKlwVSeZYxonKuwaBeepcHsWt5KLIw3v1Z6QcFC2RSB5XE1i/Der7j67d2S5Px0myJ9Q9AsvOw9y8SXaVqosYpseEMjW16VNuQ1Nswz8BKyT4xi+Bth2RcoMx9LfPh5I1dBHbM+fulsPtoVG0/7NHo8kwvhxckupA0C0YivAHF5M+/it3l3Aw7yTPgJQZXMg42B8XlwTybUiePLF4T7R5bBGIJ6gzvagYAxk84chl1TQ1/o+qXL8Mm4L4FLiDas83s5gZGlhQVNbvGYzDK8/ManBuP/LDTKh5+lcKmrxNfpDPiTb48PeM1QnGfqS/v7M3hBOWqqtC1GsZWd+9mbGyUX1scO0QwmVw0sXHEFS7pRlZDWL1wkRy8xixJSaPHdYwVfQZjc9MsFZnP92hpI0OL7cFybsFlbALQ1ArixeCM5RsyEYELGBcPBtSWPyzp0pjYUtq4XgvkgEHzOZX+OTrenka/8R5xjchvbhk/hZls+xD1hZUQ0iSuev2u7XSja/hR7iFu0ebR1gecXJD/vbNDIBg38WjC1taAuQxkUq92uT5EXL7hKD8gJfQwd2VvoQC4eZxA3SHPGhwO1Hmm+QRL6LgnSlxFl/f5H2XS/Cn/I2QIfiEH5K6n3Cvk6ekvFVlTgXrySNVnG5u4oEql6+vSxUcigtErVsfBJoF/irew750QFGuJED/Tu0+coCD2f5/uA2QyQYI/itiDTq6OnBwi9+kq/XiJTi2heARzMnrlAHmztmqVnXl+uj2fR6ErQ+MW
 SZPZB6iS
 9N6xS7hb3T7lCMDaErxficGrFiXuB3zsdDTXbhTCrSmh16nF6g7lnoy5lOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/12/12 05:55, SeongJae Park wrote:
> + Christoph
> 
> On Thu, 11 Dec 2025 20:56:14 +0800 Enze Li <lienze@kylinos.cn> wrote:
> 
>> This patch adds loadable kernel module compilation support for the three
>> DAMON sample modules.  While preserving the existing built-in compilation
>> option, the change introduces necessary code exports and configuration
>> updates, enabling these modules to also be built as independent loadable
>> modules.
>>
>> Key modifications include exporting required function symbols from
>> damon/core.c and changing relevant Kconfig options from bool to
>> tristate.  This allows users to select between "built-in", "module", and
>> "disabled" configurations.
>>
>> This enhancement provides greater flexibility for both development and
>> deployment.  Users can now compile the sample modules as loadable
>> modules and manage them dynamically at runtime without reconfiguration
>> or system reboots.
> 
> Thank you for this patch, Enze.  Actually we tried to make the modules
> loadable, but there was an objection [1] with kind clarification from
> Christoph.  In short, we don't want to make DAMON supports loadable modules
> unless there is a real use case in tree.  Samples are supposed to be samples,
> not real usages.

Hmm...  Fair enough.

> Do you have a real use case of the sample modules that require loadability?

Yeah.  Just finished preparing a patchset -- will send it to the
damon@list in a moment.

Thanks,
Enze

<...>


