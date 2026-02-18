Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF616E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 22:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F3646B0088; Wed, 18 Feb 2026 17:46:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A13B6B0089; Wed, 18 Feb 2026 17:46:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEF776B008A; Wed, 18 Feb 2026 17:46:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7CE86B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 17:46:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1CE5B585A4
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 22:46:49 +0000 (UTC)
X-FDA: 84459063738.11.A60B219
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8D0A980002
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 22:46:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hgA8Xewf;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771454807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sVE/Dmq0+VH9ONqfuxduxL5alPkPbDWL6QiRv6bdZqI=;
	b=K3VgZin4c7BxRPzRER/ajRrR6HxTsJqUXU0OMYtdZxIOg/ZvGuzhbrsgQWcBA9pY194e7Y
	Fen6vrntxzBxvCx/8bbVfWdQ82h0/Ed8kZ3ShvJjBU0pq4YDEZWKDH3nNYcWuf5C+ovaEU
	QTjMeItMRvmwgUcqpXg7mlUsq+PgJUM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hgA8Xewf;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771454807; a=rsa-sha256;
	cv=none;
	b=q5oeIWwYoPRWDFBi59DFPligoAYqoJrq6rBXy067f5UauFxyoTR/q+2NTf49hk0mgaJQvC
	j7dvzEP/CKHSgWSYSQZWW8m3h+SkbeDxCJiGUXMMrSmtxKeqsQN/IpNMuoDOuIwHpRqpuY
	3VHl8AuLNoeUYoH+Naq+T+hTBKwB23w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D96BB6132F;
	Wed, 18 Feb 2026 22:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AA0C116D0;
	Wed, 18 Feb 2026 22:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771454806;
	bh=pyyYJ4hmcUKB2vRyhIa2pVbMn/y1a5Gv7RKxJ7FsfV8=;
	h=Date:From:To:Subject:From;
	b=hgA8XewfMLVTy6fx+G7BXwcxXKjrcCPuBp+GNIpfiKEFpHG1uKZ3G0ARz4XreHYvf
	 hchDeOV6PJIapWlIPAeKeEZIEkt/NX3reMoLCHtXrj5GnFR/MJnElmEdLLkCbj1LUP
	 vByOocRbAh6mgAT6fgXfxswdFogN31PHsiz4f4XkFre0ij3+3LKxyRf/6Z496x5EAx
	 UKs1W7P+fUo4DOpjSWPyxcNRQvvw8MVe0HQSMi2QfiGOj3H7O3bPhIHuFzjmHlEV9+
	 lSb90Xe1dPDJdp4pKn4rEQer9qF7ZvMdMdi32r/zuEFggWYIhf9u5gflzPEF779E7v
	 qFtgIi6jD95JQ==
Message-ID: <54c018a4-9f11-40a4-9d1f-caf353aa75ed@kernel.org>
Date: Wed, 18 Feb 2026 23:46:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-02-19
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
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jby5dxezqu3rin3p766e68m1ztrzkk5o
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D0A980002
X-HE-Tag: 1771454807-577470
X-HE-Meta: U2FsdGVkX194OxKT28WZInI09mlcw3/w6bnDu6D/aKZG6hOPhINdsiaA/cX42U6nu6YCT0HNoWXZJqTemk8b/Q5TMkQvDMK4GR0HhsXHzTXgF2Qx8ZUL/Q9UY1cdsGoJpwR2xH+HrwoYZ1AXSlXZ60qxmB5OGA2LVhCAP4r5wzzZk2ACY1LyAxDCvw6Ww6Dgr8Z2AGbN+dXPGuJ0txWLvMJ0VE3J+jpiClY0S31t2EQo2kQ5J/c3ahsY7sMAIdoPDufy7uH+VY4Jf517VSfuA8eBBAioKTdRrlEYVajR/D9tKzkjUW/MiQa/P/U4e1Pu0Vqv3CjBGDo059i14X5l8Q038FEUfkdLEC+Pw+BXmUMyq12i/1XM/garjR+u+MO552wAAlFPBJKMKgp2+n9bM9fGkP7wHNKEJUgDfnMCpnAxoPsNu0hq1lGpTFMi628aaPT+QRMIgSWKacAzSWQ0YoO/eWxdXFn41SraKytV77cHeTmPs3YrsTx8B5tlJBwSeqZ01KRLrgahNXpVo76krLhnBVkReBiDri7QfJOd65PG0Wuzpj2cwtoM4Lc41UM4GLAz3m9bAOSrRsfN5cTshZpix3WBlEhLKbonkvKvtj8i1CNwyWs8TCpI6ArOgjWf5ea0VXPBSfHKJrBcQN5iDDKl3ksBn3gF9GVDYpps0YGa+zwKdVijR4CnvZiDKXvV7RZ1MihwaGR2if9bxjdUISSz0judZGNAgyC6c6Hdwe98lcjKxvoNzpooX1KWqyXg9smoJ49+42DAFbfuzTmjbV6yp5m5HGwQIZBpeXtposgND0bOPlDg01PPbMCsxXSyEYnuQeSBDtXN+L5A1eHyJSEljFIiepZc6Np6S0uChhBy130nxptpnHltX0w2zxcuzhPdTJMtSjiu2HcKh1i1gszxeh+rZjwl036tKoSj+SKuixv/tEj2TP99PjWSha6IMQPKLsMF9qwkLlOm0Ve
 LFtDJULO
 4CBxPNlDYoy/MZRZX0D/n2lihECfgr2OTocLSzXphFOcjwLTJ1+Zp0u0Gc8/9ocNqqLzRcXz0InQmyDbLzWLncsuoXlSSuRlZMQW2iZi6Zlwr3kXzf2dOwW4QhtapfyJglakxp8eqz0IoQ9Bmg9BcaIaX63M3SAVPIB/ZBn1RSe80Z4ikgNLoEsgjB+P0OSbekZuZoewzfvK7runC3ZC85DstSR+heqiJ3WOgJWjmpK6ynSLQR7luDpq3OrWC4YuRpmg1kp4uBQTVr5pJxh9jNtZ5zSqlu4w8w5BylKPlcCCs9xMlLK+O5vJtjKakrCaItHzdkh15OAjpNqa+vwlh95X85QP68Vj534PQG30u3tnphVlxAhNsrHszTWNO8fkd+IN1XTTp8r0nWdClV9G2DgSG2rG6S/as02x494wePoDnACCfpMqcSpk+Lw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Our next guest_memfd upstream call is scheduled for Thursday,
2026-02-19 at 8:00 - 9:00am (GMT-08:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
or Ackerley a mail.

In this meeting, we'll discuss how to best handle private MMIO, and I'm 
sure some other topics will pop up :)

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.


[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing
[2] https://lore.kernel.org/all/20251203144159.6131-1-itazur@amazon.com/


-- 
Cheers,

David


