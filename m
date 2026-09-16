Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36703C982C3
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00FD96B008C; Wed, 16 Sep 2026 11:16:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F04E26B0092; Wed, 16 Sep 2026 11:16:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB1E6B0093; Wed, 16 Sep 2026 11:16:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B30226B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:16:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39DA0A552E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:16:16 +0000 (UTC)
X-FDA: 85219976352.21.4AA74B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6B50AA0007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:16:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXALUMGF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789571774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCPRrbMitCn2R1NORvmiGIytFMtrEhSP7twr2VDXeFI=;
	b=R1C9hMwLIKNIZ1be3nEmd+TX3YoFO8SZguQtLdd87TkSTBWhcIVIs3JR6UotDpV36C1krj
	aqTkmBOz3GclSRPNlfdsruEwLjjorzZPm1PEjHFpm8g+F2qi0N98kRf69aGRqSolf3yBNL
	tY9HZ5PH6R+9xXLTlYdzdiHGgVN5lXU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789571774;
	b=wGJOPOtA8ldD+5uuJ6oWUxQZHIr/efS6LNlRtBx8cTpL8krZAvzGG/FRMaAKFFBtjAeNKU
	AxaipjOJ/ccSK3AANX0sqjqahSP6/Ihkt94rXy8430+EF0KIwC5AHU847rDJRUkURgMuHP
	/L8lbfjRdsERoYwpx57D3+OSJju1ZFA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXALUMGF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CAA4400C3;
	Wed, 16 Sep 2026 15:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AD01F000FF;
	Wed, 16 Sep 2026 15:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789571773;
	bh=BCPRrbMitCn2R1NORvmiGIytFMtrEhSP7twr2VDXeFI=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=WXALUMGF17LNTY8vF7rM/+E6lmP4/WUqjCjFabo38I6XnG3DIHLLZPJX7BbfLRWuy
	 p+4NtN8CjA7F/61OplsrWvd4ZsFoYXpkgFieSKgYSOdYYC0zD2ubn4kKyuEtdqWHCo
	 mTcGtwo8Acl2lR2sA1VdiCo40OaQTESKGyYuM60fxWhiIhQJ4Ekn4Onc9aV6GJQaYt
	 IKIjO0/NY5povFKSxLC74Mnewj4oQwr2RXlBi56KzWeYHcOQGxrKYClg/iYCK4h45j
	 U6GHja5FNg/ruhh3qu3cVYuEZKG8YxI9CBCSAZ9Gm8zvae/pFSfQeQS0rqAQhwpXjb
	 Yb2rt+VNKA3qA==
Message-ID: <16ffff40-4ef0-4312-a700-348603f05c0c@kernel.org>
Date: Wed, 16 Sep 2026 17:16:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2026-09-17
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Cc: ackerleytng@google.com, amit@infradead.org,
 aneeshkumar.kizhakeveetil@arm.com, ashish.kalra@amd.com,
 dwmw2@infradead.org, eberman@quicinc.com, fvdl@google.com, gshan@redhat.com,
 jackmanb@google.com, jackyli@google.com, jthoughton@google.com,
 kalyazin@amazon.com, kas@kernel.org, kevinloughlin@google.com,
 liruxin@google.com, michael.day@amd.com, michael.roth@amd.com,
 mike.rapoport@gmail.com, mvaralar@redhat.com, pankaj.gupta@amd.com,
 papaluri@amd.com, patrick.roy@linux.dev, Peter Xu <peterx@redhat.com>,
 pheragu@quicinc.com, pkondeti@qti.qualcomm.com, prty@google.com,
 psalian@google.com, qinkun@google.com, seanjc@google.com,
 shan.gavin@gmail.com, shivankg@amd.com, sidtelang@google.com,
 suzuki.poulose@arm.com, tabba@google.com, tatashin@google.com,
 vannapurve@google.com, vbabka@suse.com, wyihan@google.com
References: <b91dbfae-20f1-4b9f-a25b-4397afae80f9@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <b91dbfae-20f1-4b9f-a25b-4397afae80f9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6B50AA0007
X-Stat-Signature: nwnu9rmr54bwrs6ho3yw4uatya3wdt7a
X-HE-Tag: 1789571774-753602
X-HE-Meta: U2FsdGVkX18rDeC7pqNonTwmqaogv/qO7zIaF7ti7f9ARdNIkD6Ub4vsHTn/ASpCzxrhBUEuDXDbKwV0rVHq/vDHgUUjE6LuYhiII7fcs/gfWRg5kuyJh2vsa0cyRHp+vAGIbZB/xywluWJo4ol7u89xvtoo6EkJIY1jPHkpfEE8A3dVooVj2byPhdfKyY6kMCEaIEtp85PLwO5kQva+4YWmDA6/5dsxBG7DivMyJjBRcl4NPp6ih9ixt2YK03R08GWTeumvKKnzoK/TymIcRLMpehC5KMBPI0fyIzX1DHJbqhLRymRk0yZHyijnNUybIpfNKxy8ikbQtIxYoGcqwJM0MR0mTLKMtNqHAeqHfzvmOQlhiPgDaOOTu/p5YRNgcUx0QHZDGcccjrk51jc8C2/qSuof8IjU0+ENQE0UkKcrX1y4bxZlsB/952KT9PQfWd6oZYnFp1ceIOz6rGbTpBZf+5LUCX5aT+gkSnJvva1LzPwLD478XLNJlKKgjKrgSksBE/Ibc1udm6zPl7eH7T4+XJ0NSXKqMEoL62eVJReVzzPxaz8p0VA6cfB2i3k3GBhXknAsDjUg/pTWrZFWtA1b1oldkYAnfxjQxHlcqVgAg4Zk+oeNRqWsygS2df4gVECkv5oI3uY/anngrkKb4pBB9/Fb1Loa6ZczZQBltQaH742N4GseaXd/r6OhOJd3qo/xmTlXDLc4W7Ztv6jVOSHMN+qCML84xqJmFw/XdcxjAOS63q45o4MhXskuWQ9A/+YX3KIe3iGZglWePk2+BG41Pr4G9uOZJMLE9ns4CKCRkoQkt5avHM/UsOS6i/jLETiIX4qdVkuhHWsZMZdhRiBolPBqn5xBOPNbVhPu9hIthLfRt5g2jv/AnhG4gGaVy5P/bdtEby8OtN+LOvS4sMQ3l+oZCiLznSpWkvzjapiVqavMySDGBna01pXjKslUICgxpbPRBKuxvix/3Gw
 7b4lNPfA
 yzb/7HLX+8fFYfUuXoVINLRnQT0lzKLzkQGF4YZPMxKqfhYNLSo47pBxuVkrngqYnDYBou6K8JCKcJpDctOBPhLa571Bx2TVXTbMu/bY5L2evWZAucHGOdeykC9LRmU5pB3unD2HXij8N+mZPGDmsFzL48xJokdufGCHLt14fez/ER9Pm/teMN45AKukLALmAPp1rW0oF67yDkRzGA0or/UcgdG6SkC6ls4cl9aCZo3wBtcy9y4r+t8OsSXpOHk7lKD/rIp7et7ghpmTNMUEknWAbgwmE9m9dVxS9iARYinkprxfMkN6F8pZToLmGTsmXhfxtyd2/FrNYUZDnvpEMIi39amUc7zEa50nHGbibg1KhewxX3FpbfumbGIHlzvlHFIJ01dsefv6KaRBx5W/dc9ZlfmmHrOZLRaOUytP8V/lHTFD9YdkJp/h3aYY6134ypQ/z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 17:11, David Hildenbrand (Arm) wrote:
> Hi,
> 
> Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
> 2026-09-16 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

Sorry, tomorrow (17) of course :(

-- 
Cheers,

David

