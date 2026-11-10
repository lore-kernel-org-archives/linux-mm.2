Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CBC2606A339
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=i2Y39OAK
Received: by kanga.kvack.org (Postfix)
	id E822E6B05C7; Tue, 10 Nov 2026 06:47:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5A466B05C8; Tue, 10 Nov 2026 06:47:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6FA66B05C9; Tue, 10 Nov 2026 06:47:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A80B36B05C7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:47:11 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35C31C055E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:47:11 +0000 (UTC)
X-FDA: 85419033462.28.04DD6C7
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id 73920C0003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:47:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=i2Y39OAK;
	spf=pass (imf10.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794311229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hbY0RzxFM5S4ir9xTxtZ6iuWd15w11W3iqB+mvroyYQ=;
	b=l4snLRhrKggrXoBh8K5d56rzqs4KWsRGvgVJVzKTBI74JfVRmfmOFAi67SbeDPqloRujtk
	AljtiLYV6cspSNtaurZJfTIU+KIAxGiBE6A4K4+zI3n3ke6+pE9XnTlPWb4QYrW2NeQ79v
	6bPFVqj3g1mj+lQfx17SvrKD/F+/6b8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794311229;
	b=G9mKk8mg4dZ9uIj89gON+mtDyBNAw+DLO6grzhXmKFwFEm00vVlvvIWAlq3Rn+r4BS9Cqc
	6JbTZYTYl1oIYVIrEdcft8Of00SH6bc0KxVomd1MT5YTNwC/dWUfHQ6DFlZtV/ETiVeSbm
	OOSlSeWVmbzla2V9sAu0yZq8jRwGfd8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=i2Y39OAK;
	spf=pass (imf10.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=hbY0RzxFM5S4ir9xTxtZ6iuWd15w11W3iqB+mvroyYQ=; b=i2Y39OAKDD7hr3QUivUv78G+OL
	n5jO35f1Bx7pUETtXw0IGi60mc3dkEEogbQC+IvFULrLl9/Y5Ima8+eCu+K/YEF0adnS2Fd3ylzqZ
	nMpVWQFvUqQsbZrioEYskqKBn49/ZVgidB5CJXjSDAUOyEIle3yRnBXe9Pb/fKD+i4Obj7pkoHMa2
	Fb3ftpWz2WS1KW2OP8Q1ugJTolMQrGbm2n0IIyYq12X9l7V//9LZeBk2qdFqF3INRBrtC0wx9KIRc
	qjfQlPeFQ9+u1t5FFtljEPE6QikTu7Qk1QVbKDSo7tIQ3PKM7tkBE3n71ZlUfkfxtDGZiKFfRsdD1
	A+sBEMaw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xQkJB-00CNSj-2Z;
	Tue, 10 Nov 2026 11:46:38 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v2 0/4] writeback: make slow writeback report more
 actionable
Date: Tue, 10 Nov 2026 03:39:26 -0800
Message-Id: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHMC82oC/3XNQQqDMBBA0auEWZuSxBrRVe9RRBIddagYmQTbI
 t69VOiy2794f4eITBihFjswbhQpLFALkwnoJreMKKmHWoBRxmqtCvlkSuhd92hjcvPcMq6Bk9S
 lKgvlbFVdLWQCVsaBXid8bzIBE8UU+H1+Nv2tP9L+IzctlfSD6nJfKZO74tajJ7dcAo/QHMfxA
 aSccuq9AAAA
X-Change-ID: 20261105-writeback_stall_report-170750a69946
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Julian Sun <sunjunchao@bytedance.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, cgroups@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com, 
 stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3450; i=leitao@debian.org;
 h=from:subject:message-id; bh=tDJ++Af7+O4AhquRgYHiOK13KG8D1GnF3NPlto0zneA=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq8wQYtHhI/oKszB0e1xtawWAcoGeX226O8qce/
 EKj6+dxdU+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCavMEGAAKCRA1o5Of/Hh3
 bcG2D/4rlCu3WQSAMkq9YS/yA/bsW3D4kFIaKGgigSHX02WG5qO6O7lisQ6Cjjtm8hR+xO6n4GN
 L+23KZS954trl4EIRd9oh7zktc+8kMLZIbSDRd0ex1nDDkjxksbBSOP64TQsqt/ssLTPunD2Nie
 v7qPb0OmBze/MtyLH/bw7IByqEaeLJVqjbfic0B2f4ndRUAN1DbcPxux+4DKcr2YzZlTwk9iuIe
 FeESxWiJO2YRfG5ldvpsBeQBNybcNNc1s/aNFFJ8dpalx51+Flqnp4VWLXwlf5p7rzalWZYzElU
 0gr39q6oyyJ5PBZ6d96wvbbKyacaqiFLwsNVnXD8e7uj/bm6rnI4sd/bgGb90AHk55BXBA2cBoe
 lD88KM7EqRjS8Xta14Ho5heYeHhyCA7ewxwpw9UJhjlTMAAOgTKi9n2tD96/1QMWFQE05zlFo0O
 EYU//p7M5IPjyGMtbnsUCnr7QV7qsuxsduao+ZfKTZzPk2zkdkltXktVmTAoLKYCZSMUnJ7VvKj
 FAEg9ukR6pmINzE+oB7kyiA2d5FUR8CAedZHQm2tiqiUmlmrtxr7Eema3X4VqVtssH27sb9W6zw
 qcE5JHnXfNRCbsGF84qqxmhSxaIbAhHBcIUH0TogcVlCRPDs4YBKFPqurUjw+63soAv1h0eITCS
 MxlTkeAwFFz7s0Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 3abuy6ek3f6b1pwichsfafruxng4ibx9
X-Rspamd-Queue-Id: 73920C0003
X-Rspam-User: 
X-HE-Tag: 1794311229-764239
X-HE-Meta: U2FsdGVkX1/NCUAaCg2G558I7Q7/Ggv/QDEAk+EfpO3HGE1QLyndYfBtXoIK7Uw+DcchJlLOrrwlRRwK/nlTkSanBPjlVD4T/5PihxYt6xkUZPPS7YWhZClVpFvZd3YY3ToqzKeSe5eNpcm6wQAyyh3K6NpsigwNq7BpuR3i6FEt3S2DD4orqVrN0Y07+o2eoTOe1NgHHhAFjxD/BF5LCoRy7KK1ZhNMhE1rFZzvTnFFFbQWhdoXLDSO5QDYRIFRfKOjmiklUkkvkZxR48F7RIeRLiYUEFRClhCBew3bjVgStOxRJAeLAyvzvSeocMOQbkP1DpAH7KRJ9nVFpFtgrEyzHkOMmuBDMOQNrNSChC604nBhsyBo1HRRoZS0SOudMJHNba1xuitmRPCgVmf6yiYsr1Ix9SEiUrySfsQk61wV8Fx1DAlR9Gn6l6iT8gKV99vUjZMy7fdKpfyPQtukdPzv6DAwPgeiEhKmCZG35cU3DePQFFVWHjgg8ayzFDhL9pK/ktqpcRJ40KH9GkciGb+A4qjz2CfmIOnxdXY+gVGsZ7F//+Itu6xSxZrbSNBNZy5oEoucEuwn0XayfdpPB3ypQQhuMZ500PJmS+Bne8WIpiQxUJqAoUnB863/YUNIXvwpS9kfYf8Cq72zL3RGnlvWR23a8faQ62K2dgoa70DpPodvTyntQqsPbsGJLQLNybpH6KvIRI//8J8ENKAUNajvAqb6/mxCLMV0jyYg3y88hEgk0OXVp7rlwD7vrINkyQpLlMsB2mUePasG6HfkOUEmzhdqgI/BYWVpvEMwaytLl5FcV5MMeVUiQIcxxWvwuyRdFc5GBpJLSjlH8j21TZee4LTuxWy5UH466yDABmKSoNGTQaIiuCNqMbM3rs9Bpv8btG9Y+6YIVDjP0/v5xEGNa/6nnwByTimzYXdNp2m0nw02JHPfxhU0YbNnAEN/yM9qR8nzvnvbEWJPN0B
 Pw+gib8w
 3bwTDHgK8ER3sUBs/ULInKG52g6xV1UZqKQIH3JGRDVBJnw/h+OORd3S1bwtUuYUM83zGsPxNm2snTl/RIFmVD9eHnBa10joc7JKWZoDYwianNpAo5G8hokuHVjBkNcqmmypn5B0FxB352umJJywdqD4rWgIUgVHhMp0Qs5PoingHYRD8EwqeHcoCuxrfIrKFKCZOCvLNHZuWJhhqILcWirVl/D/yUFLn3LhTtcNHfXymsBpaSTFvcFDxuDTPosS18NO5tvw80D9M0IUnHYqh1QSIqEwfdGtHTsAHo0Bg7yb/GHIUZmZLNKvkdjak+h4m9MTuGJT9L6ggD1aaKJ1W22Oa70dGZnvXGbTIQHnJmfNPZHSt/hT3t9XM0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since v6.19, writeback waiters are woken while their writeback makes
progress, so a slow sync no longer trips the hung task detector.
Instead, a waiter past hung_task_timeout_secs logs:

  INFO: The task sync:180 has been waiting for writeback completion for more than 28 seconds.

Across the Meta fleet, this line is logged about 19,000 times a day
(the median over 40 days), and up to 82,000 times on a busy day.

Over one day, 194 hosts logged 16,858 of these lines for only about
2,000 waits, half of them longer than 160 seconds. Most reports were
printed twice, and a wait logged a median of 7 lines.

Going through these reports, a few things made them hard to use and
quickly act on:

1. The message has no trailing newline, so it only shows up once the
   next message is logged. Patch 1 fixes that, for stable.
2. It does not say which device is slow. Patch 2 adds the bdi and the
   number of work items left.
3. The end of the wait is logged as one more "has been waiting" line.
   Patch 3 logs the total wait instead.
4. It is printed every half timeout, often twice. Patch 4 wakes the
   waiter and prints it once per timeout.

With the series, a sync of files dirtied from two cgroups, on a null_blk
device throttled to 4 MB/s and with hung_task_timeout_secs set to 5,
logs:

  [    9.262814] INFO: The task sync:276 has been waiting for writeback completion for more than 5 seconds (bdi 252:0, work items left: 2).
  [   14.683024] INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds (bdi 252:0, work items left: 2).
  [   20.103027] INFO: The task sync:276 has been waiting for writeback completion for more than 16 seconds (bdi 252:0, work items left: 2).
  [   25.222884] INFO: The task sync:276 has been waiting for writeback completion for more than 21 seconds (bdi 252:0, work items left: 2).
  [   30.542836] INFO: The task sync:276 has been waiting for writeback completion for more than 26 seconds (bdi 252:0, work items left: 2).
  [   33.562975] The task sync:276 waited 29 seconds for writeback completion on bdi 252:0

Without patch 4, the same test logs 18 reports.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v2:
- Print the bdi and the work items left on the report line itself (Jan)
- Patch 4: wake the waiter once per timeout instead of adding
  report_stamp (Jan); its changelog shows the hung task warnings that
  this can bring back
- Patch 4: the doubled reports come from wait_event() checking the
  condition twice per wakeup, not from the two flushers
- Collect Jan's Reviewed-by on patches 1 and 3 (patch 3 rebased on the
  one-line report)
- Link to v1: https://patch.msgid.link/20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org

---
Breno Leitao (4):
      writeback: add the missing newline to the slow writeback report
      writeback: name the bdi in the slow writeback report
      writeback: log the end of a slow writeback wait
      writeback: report a slow writeback wait once per timeout

 fs/fs-writeback.c           | 40 ++++++++++++++++++++++++++++------------
 include/linux/backing-dev.h |  3 ++-
 mm/memcontrol.c             |  2 +-
 3 files changed, 31 insertions(+), 14 deletions(-)
---
base-commit: 8b7179210b22f8e48a82c5ceacb9d56a9c4cfec4
change-id: 20261105-writeback_stall_report-170750a69946

Best regards,
--  
Breno Leitao <leitao@debian.org>


