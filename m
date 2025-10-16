Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D516CCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 10:19:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600FE8E0002; Thu, 16 Oct 2025 06:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B18D8E000B; Thu, 16 Oct 2025 06:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479A48E0002; Thu, 16 Oct 2025 06:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2AA9A8E000B
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:19:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A93CDC021A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:19:44 +0000 (UTC)
X-FDA: 84003581088.07.FACB137
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3FE1418000C
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:19:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=cgQc73VU;
	spf=pass (imf16.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760609983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=270gr2GlhcdRXsppPlOLN/loQsGJhOZfzMqO8Lv0EOQ=;
	b=kFwGN8SZ9aDK7MyoiFAC2PHkEzGlI45BoQSIhabZQaF2d6OZ9KXNfZ0/9Uqfs7iw96+HtD
	fS+l6IuA5u6OSHkzF27DzP5qV+f4f1Y2Tpg7kmba9YQ3uaLys/s2xQ4GmISBrTIggacUZf
	xz4xbI9m5WmfzwIUNp+YnII+4LxUuZ8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=cgQc73VU;
	spf=pass (imf16.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760609983; a=rsa-sha256;
	cv=none;
	b=QqnI3Vi06CVZWDBW4xu+G8tpbg2bx11gHVmQrCRtSvT5ETKgGhAiETt03w9am+Ee4iugUa
	7rXYB0dXSAXyFBfKmuhONfpnH82Af5U/p/Fx/NkXfzq2Im0WdPsrZjwyN3v0BmA/XpzLgT
	Xizd9/D4sOSwICKKcTs7SBZZgd2hu14=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=27
	0gr2GlhcdRXsppPlOLN/loQsGJhOZfzMqO8Lv0EOQ=; b=cgQc73VUFSh/vB3tLT
	vptjlO8XFmpvYW1MA9MCmxyf4Jhmq4fSOb/I2GfmI4f1Fo0r8qRDtzWNbEHbwmqu
	IXZjRR4mQZshyEgyLwqvJGf5GBVhmffT2oZRX+yDtAbB30vFycv+sd174NnLGkJB
	3GtoWahdt7/cK4YY9eEuziUok=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wC3v6GsxvBoxGKIAg--.5453S2;
	Thu, 16 Oct 2025 18:19:25 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: linmiaohe@huawei.com,
	david@redhat.com,
	lance.yang@linux.dev
Cc: markus.elfring@web.de,
	nao.horiguchi@gmail.com,
	akpm@linux-foundation.org,
	wangkefeng.wang@huawei.com,
	qiuxu.zhuo@intel.com,
	xu.xin16@zte.com.cn,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Longlong Xia <xialonglong2025@163.com>
Subject: [PATCH v2 0/1]  mm/ksm: recover from memory failure on KSM page by migrating to healthy duplicate
Date: Thu, 16 Oct 2025 18:18:12 +0800
Message-ID: <20251016101813.484565-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3v6GsxvBoxGKIAg--.5453S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Gr18Xr1kCw1UuF1xXryrZwb_yoWxuryUpF
	9rGFs5K3ykXFyxu3WIqws7u343X34kCw4UG3s29w10kr4Yg34jyw1ktw48Way7Xr4Fya1x
	J3yvqr17Ka1jyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U1KZZUUUUU=
X-Originating-IP: [101.82.139.53]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbBcx-o+Gjww-s9qAAAsJ
X-Stat-Signature: ioo5bg14y65umyiyj139w33astr4a64t
X-Rspamd-Queue-Id: 3FE1418000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760609981-143061
X-HE-Meta: U2FsdGVkX18L4SvdciGHZ2EnB8rPuUI2e/L6SZMTOX3IdJ7Y6OVC2A1Ba46MJEMdrAKbObY5BnKlZV9lMfzwpS5k/XF5yGR31/fEj9U4qbp1ITTqK55/pQyr4j41nL8BrmNTjptAAgdEFvOp99IA+Qwu9TMvnita5zuFSexrLj1S8cVGQ7wRQdi0m64B+aQwWQuIyY2KJ/cYnA32x4GGflTSH4fsjwVCBdomJ7bWYjGStioVOC1AkJJnv+TapK42NR4YjzEsq61Wh7W0nQNt7PcdfkCGersz4nlpQbWQFa2iVfAcvMZCSY9OzjBn/qxsqXrTZMIMSRQg+Yq0DkbwibepkNAsx1hcAit93pciJuErWN/mIJxbWPwbTLoQKlVSU4XIa2W6asoW/jaN8Qoqb0U7MOxvUc/yzC76Rd8hV8SZ1ZMw4JbZQ2Jqnart87rotH/U1Wfb4ds2rLQkCMnb5tRXG3/oc9PHxPi0Xdyj5vNyM0akbWmcPF345/mXZP6zfzHFAItRF6ThtH/IgMIg16ymhqLcxRyvi3Z7mD4WAhV2b/0m06n9bcMoilQERRG13rbJ3sgoUreRmAQY/fUp7DqfAEziVU5033UuEC0TzGLJZ3NK290TcYUEmnTnu1Y4lZYo8UOiE2Cz/BGBWkVtrOL3T+YMNttHsCuSCKEwwiyQRXhEDRA2VnCUuhdf+R+uDMVe7vrxIoIXAo6BxYqYVbYt9agquGeBGQc/NF+KS/tmiaPNHIdU/iSmxfvebzuPwKS/89wn7GAiHoEnC1+1M+ALDAGZ3cHGeAT4bJDhvw+pJ1QOLT/z5rSVJqmf0foE/QY82VKN5sT4dGQkFGYGpkq1IaHMk1/vRWRnHuv1aessn0OyNl+JcoO8fFjFRXVdVYGMJ2JrYJAqwcv4j7aBkMutAeIXHRA63R6Q/jlIXl4EisqINL3kyvH8VpOyog928hLxT/EyBCWqrI5+6GB
 tRuFADU2
 PgtneI6rtJtC2dypd+GCk26FegQY62uz48Q268BkuhzKUFOA6Lc8uQKRnPqI0XdGABeedfsqY/ylbvzts6fhW8REucIPN6nKQlG86ApbBlJgnypa1O5FjGloSmSXHIK96K1rbl4UHijYY3sKScOyruiWHHF5YFQp+H4Ep6YKyE0BuNJxeghy0BqXxsXfvxLieR9MEnMTbFDTecw6FwbfU1+9ZlU12J8FrOIXi1yrGZFuJnk8oKIKyl99WKoQ6fi7BrPtOklBg23s+o+KQgPRhcPv7AFAqhdiLZFzJFvvJlEmTt4/rpzby8ZsS9WK3DcmKowI1GhzGqFez8gb7Eiu7ok2wN5EVniJBmPEKlnrgH05xed1rr3W7Wz5jUar895XWfrRDAk04Qtjq7i797wPgaVU0/4A87UeS9J+cZlUV1cblSlhZ2TP3mWC7i/YbzPW9kvVU3Ot47L721EYRWa85CdcyDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a hardware memory error occurs on a KSM page, the current
behavior is to kill all processes mapping that page. This can
be overly aggressive when KSM has multiple duplicate pages in
a chain where other duplicates are still healthy.

This patch introduces a recovery mechanism that attempts to
migrate mappings from the failing KSM page to a newly
allocated KSM page or another healthy duplicate already
present in the same chain, before falling back to the
process-killing procedure.

The recovery process works as follows:
1. Identify if the failing KSM page belongs to a stable node chain.
2. Locate a healthy duplicate KSM page within the same chain.
3. For each process mapping the failing page:
   a. Attempt to allocate a new KSM page copy from healthy duplicate
      KSM page. If successful, migrate the mapping to this new KSM page.
   b. If allocation fails, migrate the mapping to the existing healthy
      duplicate KSM page.
4. If all migrations succeed, remove the failing KSM page from the chain.
5. Only if recovery fails (e.g., no healthy duplicate found or migration
   error) does the kernel fall back to killing the affected processes.

The original idea came from Naoya Horiguchi.
https://lore.kernel.org/all/20230331054243.GB1435482@hori.linux.bs1.fc.nec.co.jp/

I test it with einj in physical machine x86_64 CPU Intel(R) Xeon(R) Gold 6430.

test shell script
modprobe einj 2>/dev/null
echo 0x10 > /sys/kernel/debug/apei/einj/error_type
echo $ADDRESS > /sys/kernel/debug/apei/einj/param1
echo 0xfffffffffffff000 > /sys/kernel/debug/apei/einj/param2
echo 1 > /sys/kernel/debug/apei/einj/error_inject

FIRST WAY: allocate a new KSM page copy from healthy duplicate
1. alloc 1024 page with same content and enable KSM to merge
after merge (same phy_addr only print once)
virtual addr = 0x71582be00000  phy_addr =0x124802000
virtual addr = 0x71582bf2c000  phy_addr =0x124902000
virtual addr = 0x71582c026000  phy_addr =0x125402000
virtual addr = 0x71582c120000  phy_addr =0x125502000


2. echo 0x124802000 > /sys/kernel/debug/apei/einj/param1
virtual addr = 0x71582be00000  phy_addr =0x1363b1000 (new allocated)
virtual addr = 0x71582bf2c000  phy_addr =0x124902000
virtual addr = 0x71582c026000  phy_addr =0x125402000
virtual addr = 0x71582c120000  phy_addr =0x125502000


3. echo 0x124902000 > /sys/kernel/debug/apei/einj/param1
virtual addr = 0x71582be00000  phy_addr =0x1363b1000
virtual addr = 0x71582bf2c000  phy_addr =0x13099a000 (new allocated)
virtual addr = 0x71582c026000  phy_addr =0x125402000
virtual addr = 0x71582c120000  phy_addr =0x125502000

kernel-log:
mce: [Hardware Error]: Machine check events logged
ksm: recovery successful, no need to kill processes
Memory failure: 0x124802: recovery action for dirty LRU page: Recovered
Memory failure: 0x124802: recovery action for already poisoned page: Failed
ksm: recovery successful, no need to kill processes
Memory failure: 0x124902: recovery action for dirty LRU page: Recovered
Memory failure: 0x124902: recovery action for already poisoned page: Failed


SECOND WAY: Migrate the mapping to the existing healthy duplicate KSM page
1. alloc 1024 page with same content and enable KSM to merge
after merge (same phy_addr only print once)
virtual addr = 0x79a172000000  phy_addr =0x141802000
virtual addr = 0x79a17212c000  phy_addr =0x141902000
virtual addr = 0x79a172226000  phy_addr =0x13cc02000
virtual addr = 0x79a172320000  phy_addr =0x13cd02000

2 echo 0x141802000 > /sys/kernel/debug/apei/einj/param1
a.virtual addr = 0x79a172000000  phy_addr =0x13cd02000
b.virtual addr = 0x79a17212c000  phy_addr =0x141902000
c.virtual addr = 0x79a172226000  phy_addr =0x13cc02000
d.virtual addr = 0x79a172320000  phy_addr =0x13cd02000 (share with a) 

3.echo 0x141902000 > /sys/kernel/debug/apei/einj/param1
a.virtual addr = 0x79a172000000  phy_addr =0x13cd02000
b.virtual addr = 0x79a172032000  phy_addr =0x13cd02000 (share with a) 
c.virtual addr = 0x79a172226000  phy_addr =0x13cc02000
d.virtual addr = 0x79a172320000  phy_addr =0x13cd02000 (share with a) 

4. echo 0x13cd02000 > /sys/kernel/debug/apei/einj/param1
a.virtual addr = 0x79a172000000  phy_addr =0x13cc02000
b.virtual addr = 0x79a172032000  phy_addr =0x13cc02000 (share with a)
c.virtual addr = 0x79a172226000  phy_addr =0x13cc02000 (share with a)
d.virtual addr = 0x79a172320000  phy_addr =0x13cc02000 (share with a)

5. echo 0x13cc02000 > /sys/kernel/debug/apei/einj/param1
Bus error (core dumped)

kernel-log:
mce: [Hardware Error]: Machine check events logged
ksm: recovery successful, no need to kill processes
Memory failure: 0x141802: recovery action for dirty LRU page: Recovered
Memory failure: 0x141802: recovery action for already poisoned page: Failed
ksm: recovery successful, no need to kill processes
Memory failure: 0x141902: recovery action for dirty LRU page: Recovered
Memory failure: 0x141902: recovery action for already poisoned page: Failed
ksm: recovery successful, no need to kill processes
Memory failure: 0x13cd02: recovery action for dirty LRU page: Recovered
Memory failure: 0x13cd02: recovery action for already poisoned page: Failed
Memory failure: 0x13cc02: recovery action for dirty LRU page: Recovered
Memory failure: 0x13cc02: recovery action for already poisoned page: Failed
MCE: Killing ksm_addr:5221 due to hardware memory corruption fault at 79a172000000

ZERO PAGE TEST:
when I test in physical machine x86_64 CPU Intel(R) Xeon(R) Gold 6430
[shell]# ./einj.sh 0x193f908000
./einj.sh: line 25: echo: write error: Address already in use

when I test in qemu-x86_64.
Injecting memory failure at pfn 0x3a9d0c
Memory failure: 0x3a9d0c: unhandlable page.
Memory failure: 0x3a9d0c: recovery action for get hwpoison page: Ignored

It seems return early before enter this patch's functions.

Thanks for review and comments!

Changes in v2:

- Implemented a two-tier recovery strategy: preferring newly allocated
  pages over existing duplicates to avoid concentrating mappings on a 
  single page suggested by David Hildenbrand
- Remove handling of the zeropage in replace_failing_page(), as it is 
  non-recoverable suggested by Lance Yang 
- Correct the locking order by acquiring the mmap_lock before the page 
  lock during page replacement, suggested by Miaohe Lin
- Add protection using the ksm_thread_mutex around the entire recovery 
  operation to prevent race conditions with concurrent KSM scanning
- Separated the logic into smaller, more focused functions for better
  maintainability
- Update patch title

Longlong Xia (1):
  mm/ksm: recover from memory failure on KSM page by migrating to
    healthy duplicate

 mm/ksm.c | 246 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 246 insertions(+)

-- 
2.43.0


