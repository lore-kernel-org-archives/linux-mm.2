Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 731CFCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 06:28:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6590C6B00FD; Fri, 26 Jun 2026 02:28:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62FE46B00FE; Fri, 26 Jun 2026 02:28:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520716B00FF; Fri, 26 Jun 2026 02:28:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D42E6B00FD
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:28:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 965FF1C5328
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:28:56 +0000 (UTC)
X-FDA: 84921085872.12.BEB75FD
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf01.hostedemail.com (Postfix) with ESMTP id 441D540007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:28:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="B cr0RIP";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf01.hostedemail.com: domain of fffsqian@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=fffsqian@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782455334;
	b=4dzGQ19bER4sRHwE7JXbH8vIyrl5cR2+uXVYQk4ZYym8a8Iksiw1C4bDh+JxQKb7NfY6/A
	1gj883RNFWqFnJUWId+OuD7Fn1TjRUmzB9KJ0ZRJ/eD/Uc+9iEUqUEuaBxneztFAj6z3Sg
	q1UcPP6utruQ3ndEuQMz2xo1pzr4sn4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782455334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Er5P0lRLBiSouJ7AhmPBiUyxXb9smjqpEqSwVE75CR4=;
	b=6mN/UGPEi96uVV0K7Sk8Ui8mlW2ju7xn9u9AT1TF6bvQNF6t4RRdX/R10qQQd9NlpKhM17
	XomY+5cnAIpx0oIssvwyIo5okrys2uFcr5upQj9M4yIyhS9FQvjBhEFtV2j0IBwpUZTR+7
	5PAF+Fko84UrrBPJ0MDOr0EJD7faRCo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="B cr0RIP";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf01.hostedemail.com: domain of fffsqian@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=fffsqian@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=Er5P0lRLBiSouJ7AhmPBiUyxXb9smjqpEqSwVE75CR4=; b=B
	cr0RIPQ10JyEAq9mBAnUgS0xVdbXxFgTkwzNwFnqWsYGxN7O8dik7PWrWDlHFOCK
	IzSpejoFlVW4IAIyNYtw910KUGy2xkoUWV5AIoUvX++6UMgbjtbRG7LYkWRcoXxX
	llnE3c1V4HABonGZDIP6lmJ7Gjr7My/W4DmRbEjWOA=
Received: from fffsqian$163.com ( [116.128.244.169] ) by
 ajax-webmail-wmsvr-40-105 (Coremail) ; Fri, 26 Jun 2026 14:28:43 +0800
 (CST)
X-Originating-IP: [116.128.244.169]
Date: Fri, 26 Jun 2026 14:28:43 +0800 (CST)
From: fffsqian  <fffsqian@163.com>
To: "Muchun Song" <muchun.song@linux.dev>
Cc: =?GBK?B?uLXH5cus?= <fuqingshuang@kylinos.cn>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Dave Chinner" <david@fromorbit.com>,
	"Roman Gushchin" <roman.gushchin@linux.dev>,
	"Qi Zheng" <qi.zheng@linux.dev>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>
Subject: Re:Re: [PATCH 1/1] mm/shrinker: add NULL checks after
 rcu_dereference() in shrinker bit functions
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <305C42A2-1359-4998-A95C-49998B4660DB@linux.dev>
References: <923f391a-d760-4d78-92d4-2e765aa226f3@linux.dev>
 <6l2gs76zo6zf-6l2n5wa2xbvg@nsmail8.2--kylin--1>
 <305C42A2-1359-4998-A95C-49998B4660DB@linux.dev>
X-NTES-SC: AL_Qu2TAPieuksp5SOeZekckk4Vhu49Xcq2vvQv34Fec+4EmwXL5z8GT11gO2Pk7MiNBCGPlT60YhhUzudqZ7RWMfWGG5jimCwNvQJxj21r5A==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <549d2280.4ff8.19f029dcaeb.Coremail.fffsqian@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:aSgvCgD33+YbHD5q+HUPAA--.1527W
X-CM-SenderInfo: 5iii21xldqqiywtou0bp/xtbCwhs3Amo+HBvr-AAA3o
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 441D540007
X-Stat-Signature: qjrbpe6yqj4u61tn95qozgt7qa8hjjxh
X-HE-Tag: 1782455332-921758
X-HE-Meta: U2FsdGVkX19l9l0VrTZYWgc4LiMnnUCXWTmkyr5hIaYLipPrVUWmvxqP05Am45NlNLbTUcsB5ng2HCv0N/MGr1LGwqSXjAufqmEcoQRI1eaYKQZ5xxZdIPAtCkgL1zaPmlDW1MJYUMJL2S45HrjLdl6LgsFbP+jKQCSCfRriMutjSBJR4M975nLofu7ByoqKmOuytzJYy1Lizt3jKHkADWqK2jEE+xh3hsR07UfIV6p5LvhjuucLSdF6HGj/Nm1qH50Zyk8+bYT1D32XOTJrW9e1rxfpBpnrpRVSL6sAFpU/TEkfkn17GaS9RfS/RI/8cNhwlyF05OkHyytlGKwdLL0CfvfwcFCWBdy2OHdm4OM/Xcq9KUAojNVRI9i4JgLgOSUNhWGtcMGZf7XcyGnMBOmgAiE8wX1pkU5rMBJgGt/RFUCs0dWthnBPA6w13aEV4nxR3hNdsFnjRpuggYJuLSdc9i1ayhSYZUTbnO5oo7i7xiJG4vWE/Rv2ZGiE7m1P5WvsZE2fEuZPTjWQh/hdTQtdImnJtYTgZ7cMtrMXbipLGfOdzfoO9MnoOAcpvBtggtU6YpprltOMCx00I47Cb3eQ1m3Uc0j+PBiMwVLSHJoipuimjcbZNVqGdSbeB00dBY2XcBqre47Hpw4Q2w9DBsbcugrKJC/wn0pSp4q7XZma8MdwWl/Gukk2cm4aC6AAg4Pn9zez4qUbsd4/E73iHAGPvXaJAsOp73r8ua5pP3DoCH+ghq0I645LPkt1d7jGU79jEJEJLZpw99V7NuOLnWqKLn35a2+Y8S6c8DlzctJONS9a2NXpw5d8zoYVQZ9b20K8eJfEsKJ1z6XVwvUwWGhaYJNxKndp6g6Po4vJWoJuaBIgkkV/A0xJyD25BKmMuLgsH8vhtCmxelpjO+vSUlQwK2VjerzS8r0XEw/Nq1xfbibIPwkyiI/16vfRUQv6j/hbvhOMLi6gOzIdrks
 b+gU/EUL
 nV20KaDxdWBdzgH/poKMaFmhKpeWFDJNPs4IlKIUcjYVlXtX4w2c4ZDPF7u8dLMuLJG5VG8CBMcCIno4xb4EiG61ohUrayAC4W0OtHi4mpXsmR7wZ02d7vcJbzN5vAJNzODcHxvV0O1FeyxaOP7SbK2ZdZtpjHMTRYsQG/MqgXb/OpPY6q3K5+RYgVy0wIY8olIc2SM6urU0tXn2CKc9uv8c/uyuUagfgUzSQXR8T+pOqZLVDCv9Uv//qW3XTuNZ86WVLzx+EXFxS3uTgxEAePVzHM6TCmGuGeCRox+D1oQlIazwqR2AsTvdRc+vo+FIqk9j1okvLkmVgSEuaKLhUda8Q+/30Z7VpZ/TtrdRyPgLRjJmZVs52WMZmugj59jcb15Be2ms3Ba8/5tE2RBoqqJdUcLjYyVOUMj5v2WDB7ZzCEH6x8Lw73the2UQRnxwnrG9u0FyU+k0Q/5tkI4cb3lCE/3qk3nsBWkVO8EpEtB4Affg/A8SaIBcmgehZwWoPysICxjc+v+0RDhS9bMjWAPnlrvrvIILfKwq+/ZamQGvDvWFcX4dm7o8dVW72PQV6KPnOhU4sVxIcL+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

QXQgMjAyNi0wNi0yNiAxMTo0OToxMywgIk11Y2h1biBTb25nIiA8bXVjaHVuLnNvbmdAbGludXgu
ZGV2PiB3cm90ZToKPgo+VGhhbmtzIGZvciB5b3VyIGNvbnRyaWJ1dGlvbiEgSSBoYXZlIGEgY291
cGxlIG9mIHF1aWNrIHN1Z2dlc3Rpb25zIHRvCj5oZWxwIHRoaW5ncyBnbyBzbW9vdGhlcjoKPgo+
LSBQbGVhc2UgdGFrZSBhIGNsb3NlciBsb29rIGF0IG91ciBjb21tdW5pdHkgY29tbXVuaWNhdGlv
biBndWlkZWxpbmVzLAo+ICBhcyB3ZSByZWx5IG9uIHBsYWluLXRleHQtYmFzZWQgcmVwbGllcyBo
ZXJlLgo+Cj4tIEZvciBhbnkgaXNzdWVzIHlvdSdyZSBub3QgY29tcGxldGVseSBzdXJlIGFib3V0
LCBpdCB3b3VsZCBiZSBhd2Vzb21lCj4gIGlmIHlvdSBjb3VsZCBydW4gYSBxdWljayB2YWxpZGF0
aW9uIHlvdXJzZWxmIGJlZm9yZSBzZW5kaW5nIG91dCBhIHBhdGNoLgo+ICBNYWludGFpbmVycycg
dGltZSBpcyBxdWl0ZSBsaW1pdGVkLCBzbyB0aGlzIGhlbHBzIGV2ZXJ5b25lIHNhdmUgYSBsb3QK
PiAgb2YgZW5lcmd5IGFuZCBzcGVlZHMgdXAgdGhlIHJldmlldyBwcm9jZXNzLgo+Cj5UaGFua3Mg
Zm9yIHVuZGVyc3RhbmRpbmcsIGFuZCBsb29raW5nIGZvcndhcmQgdG8geW91ciBuZXh0IHBhdGNo
IQo+Cj5UaGFua3MsCj5NdWNodW4KCkhpLAoKVGhhbmsgeW91IHZlcnkgbXVjaCBmb3IgeW91ciBr
aW5kIHJlbWluZGVycyBhbmQgdmFsdWFibGUgc3VnZ2VzdGlvbnMuCgpJIHdpbGwgc3RyaWN0bHkg
Zm9sbG93IHRoZSBwbGFpbi10ZXh0IHJlcGx5IHNwZWNpZmljYXRpb24gZm9yIGFsbCBmdXR1cmUg
bWFpbGluZyBsaXN0IGNvbW11bmljYXRpb25zLgpNZWFud2hpbGUsIEkgd2lsbCBkbyBtb3JlIHN1
ZmZpY2llbnQgY29kZSBhbmFseXNpcyBhbmQgc2VsZi12ZXJpZmljYXRpb24gYmVmb3JlIHN1Ym1p
dHRpbmcgcGF0Y2hlcyB0byBhdm9pZCBpbmFjY3VyYXRlIHByb2JsZW0gZGVzY3JpcHRpb24gYW5k
IHVubmVjZXNzYXJ5IHJldmlldyBjb3N0LgoKTG9va2luZyBmb3J3YXJkIHRvIHN1Ym1pdHRpbmcg
bW9yZSBxdWFsaWZpZWQgcGF0Y2hlcyBsYXRlci4KCkJlc3QgcmVnYXJkcywKUWluZ3NodWFuZyBG
dQ==

