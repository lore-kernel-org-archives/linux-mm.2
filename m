Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 283F1CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 05:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622516B026B; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CB796B026F; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 507D66B0271; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AE006B026F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:57:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08D7C1C0996
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:57:51 +0000 (UTC)
X-FDA: 84830287542.17.442FA2E
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf10.hostedemail.com (Postfix) with ESMTP id 91E57C000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:57:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=n1GCqtM+;
	spf=pass (imf10.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780293469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0JyrTMDTnIbsNnfvDIxSelJbEh2fWHCPQJttmJvmeJ8=;
	b=vztvwDxpp64i0jWvpk3OHlwrvZlWAm8q586rErBUxqpWNYis8s02QNAkJu0W/8H+8qOKfn
	EUu/nfnNZ9q4kJyfMQJGmWCtho+Q2A/5OGGXZsqNttSTP7ZNeQqPN+BxQ6xj52Eb102AqD
	7rzd9WjvlxeyQcPGKivdFl6KeJhTEsU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=n1GCqtM+;
	spf=pass (imf10.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780293469; a=rsa-sha256;
	cv=none;
	b=VKGee66v5LTWdAF44Ij99UTn26YOt62JbcyXFyd947QpJKYRujJJ8M+ahX9PyGEhrBeQQn
	fwCN0aCLQ0EJfwzk0fkqe5x8uKAl+lq3iZ1rmTJQ0WBKO5az1UGxldh9y8dEOAFZ/qMTmI
	I66UOjdrozIwWkN6EK/4/3g5RJZKg6A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=0J
	yrTMDTnIbsNnfvDIxSelJbEh2fWHCPQJttmJvmeJ8=; b=n1GCqtM+SPutVhqGs9
	QSVbCdEIenwGvdNvjIfuMibNyBBheCNf1CB9kzCk8tlTfsqnVB2W8ys9avUa+lZY
	NxowsBqke8DleHKQk97LEWYdN0gI9ZqctkQjO6Spq/sqzNw0Vl61+bT4NLZSBbGM
	2A1NfmExaubXy9x9ohk6Xc+vw=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3_7Q6Hx1qsb0MAw--.47504S2;
	Mon, 01 Jun 2026 13:57:17 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v2 0/5] mm/shmem: optimize read with reduced xarray lookups and folio batching
Date: Mon,  1 Jun 2026 13:56:59 +0800
Message-ID: <20260601055704.167436-1-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3_7Q6Hx1qsb0MAw--.47504S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ur15AFWxWrWxWrW7JFykuFg_yoW8Kw1rpr
	yfWr1fJryfJ34fAr93Gw4xKF1fXF95JF1UWF1ftr4fXFnYkw1Dt3WfGF48GrWUCFy7Zw1U
	Jr17JwnF9w45t37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jFJP_UUUUU=
X-Originating-IP: [116.128.244.171]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC+B64VmodHz5EMAAA3q
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 91E57C000A
X-Stat-Signature: 3b93ef9ie5gmr3fb7gzdragcnsaebnwm
X-HE-Tag: 1780293468-854083
X-HE-Meta: U2FsdGVkX1+BAjGaQt5Pd7JsvJG5gfI3qpHK92RIlg+H3BZMkYszlo+rwEsSBmyufUjnvqZC3w7lMG94WAWeQhNn14s9fhlaJEE+MNkPypJnE1lPeMQ3UMnIgD63MT+UkxhAkCSyEXRUmcyjGOCoQsOVPXRUNMrE9l4Ap9d0PcnWDT5owwCdR677xnRkUJ7UFBkGA23QuKUNO0XXwPILKSsBzoYzsnXvapKuZ2K9HxadCDnzcjIDvzmLsYb3x4rQ2scep2G0MVzFg+h8jIXTcCOhSA18Ph98Tp/XOTAO9n3WRCOjUavpbd90i3hv0+ae+1F7wK8T+F3Bnrh8KFbEHhMJEN1wsX7/KdphuDaEIRdQys7qVArxOElMPDvspqcqK9AmbKxSxAsJE1nRihmrbc53dF5HdT87s5+zb/LDiMLH1dQL99PqYIJo+oTrVZ9EjamvcAqxq/mroc9XtpnEC3prf43ks3YJVxCSOyTTCCAiojN+b3HH+u95pz0CK/SjVKP1+CVq1BV9p0GuuhEepj5s8suIyYgekQ/l1kn52y6TFIbdIOuolqFkIumcSY3Ha3+OckILyCcHLC7JYP46sqz/8BELbpgERd+GwUV0SW5bUqwI72e6vnyRrM1Pt4nXUYcf/eRRp1HiabTQQuU31vtruz9BNcI1s/zr3JzT1nRmAHiKDOgIFF8tWx3mGEs0t3tA6osaMiimLKCvruJhCIi5EopIXw2xZlwR/esHPtryPFUYWanMxMjqKXJ0/0CQwpwJbcfJsPHnhvaI9HVhqx4XDq/WcS1wVHhX7quX2KmlJu53xb7weo59L+6TdmVgDCfvDCzlndKSeFqlfmO4KYIvSzS9KMKUJhlwRxnmsJgaHOkesbhvZulZGMKfabAknvKT0RcUMDqKS/U9n/VjFBOxiHrHHJ995aP3SCpgwD3HpDOLcIl3aBCFbHdBxi4dqW+OjCV+i/55BOL2yHN
 fsYAz4b6
 isIEhnzTbUkkh1dp4c63cXX1XUIrACs8zhyref6KH6TgT1zsozBwrJebJrEvshPRPWfOHacXfz7J2H316bIJ03n1OX5drn006YY9mmwrYPkFBqEBro6nDYdQQIiXCSBaWmtmKoWUcIvMEhGiZxGmG7m0aefeD+C/Wr8EK3KGfpbk1krYJoJQSBfzku67dUoCwP7kwblWUYi46ttbCMo7G9trNbQVV9mjMaQUEQtQ3WReJk5BSED8qdErpYMMQXW3uH+V7P2lWpYvLEfWWUT0F4oIqfYji8r17lbjWCqkz4TrCgxPCccY/lwhWddanOVWx3Dud7NUC7t9h2An8V6JTbvzn7Umi/oXXjB3YwMCCKQZCEvkg0JjiRnM15OOCmB4ZCQjq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

This series improves shmem read performance by implementing folio
batching in the read path and reducing unnecessary xarray lookups.

Performance Results:

fio --ioengine=sync --rw=read --bs=$1 --size=1G --runtime=180 --time_based --group_reporting --name=seq_read_test --filename=testfile

| THP disabled in tmpfs  | v7.1-rc5     | v7.1-rc5 + fbatch | Improvement |
| ---------------------- | ------------ | ----------------- | ----------- |
| 1M + normal file       | bw=11.5GiB/s | bw=12.7GiB/s      | +10.4%      |
| 64k + normal file      | bw=11.0GiB/s | bw=12.3GiB/s      | +11.8%      |
| 4k + normal file       | bw=3826MiB/s | bw=3849MiB/s      | +0.6%       |
| 1M + fallocated file   | bw=23.8GiB/s | bw=28.6GiB/s      | +20.2%      |
| 64k + fallocated file  | bw=22.5GiB/s | bw=27.3GiB/s      | +21.3%      |
| 4k + fallocated file   | bw=4655MiB/s | bw=4680MiB/s      | +0.5%       |
| 1M + hole              | bw=24.2GiB/s | bw=28.6GiB/s      | +18.2%      |
| 64k + hole             | bw=22.6GiB/s | bw=27.6GiB/s      | +22.1%      |
| 4k + hole              | bw=4652MiB/s | bw=4489MiB/s      | -3.5%       |


| THP enabled in tmpfs  | v7.1-rc5     | v7.1-rc5 + fbatch | Improvement |
| --------------------- | ------------ | ----------------- | ----------- |
| 1M + normal file      | bw=13.7GiB/s | bw=13.9GiB/s      | +1.4%       |
| 64k + normal file     | bw=13.5GiB/s | bw=13.5GiB/s      | +0.0%       |
| 4k + normal file      | bw=3833MiB/s | bw=3859MiB/s      | +0.7%       |
| 1M + fallocated file  | bw=24.9GiB/s | bw=34.2GiB/s      | +37.3%      |
| 64k + fallocated file | bw=23.0GiB/s | bw=31.4GiB/s      | +36.5%      |
| 4k + fallocated file  | bw=4710MiB/s | bw=4655MiB/s      | -1.2%       |
| 1M + hole             | bw=24.3GiB/s | bw=34.5GiB/s      | +42.0%      |
| 64k + hole            | bw=23.5GiB/s | bw=31.1GiB/s      | +32.3%      |
| 4k + hole             | bw=4690MiB/s | bw=4647MiB/s      | -0.9%       |


v1:
https://lore.kernel.org/linux-mm/20260520101538.58745-1-chizhiling@163.com/#t
rfc:
https://lore.kernel.org/linux-fsdevel/20260515094702.1092355-1-chizhiling@163.com/


Chi Zhiling (5):
  mm/filemap: reduce unnecessary xarray lookups when read cached pages
  mm/filemap: reduce xarray lookups in filemap_get_folios_contig()
  mm/shmem: introduce copy_zero_to_iter() for large zeroing
  mm/shmem: remove page-copy fallback in shmem read path
  mm/shmem: optimize file read with folio batching

 mm/filemap.c |  46 +++++++++++--------
 mm/shmem.c   | 126 +++++++++++++++++++++++++++++++++++----------------
 2 files changed, 113 insertions(+), 59 deletions(-)

-- 
2.43.0


