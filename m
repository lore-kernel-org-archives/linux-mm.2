Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B4AC105A590
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:56:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A5466B00A2; Thu, 12 Mar 2026 07:56:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14F9B6B00A3; Thu, 12 Mar 2026 07:56:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0892B6B00A5; Thu, 12 Mar 2026 07:56:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7D246B00A2
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:56:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A61611C0E5
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:56:52 +0000 (UTC)
X-FDA: 84537259464.17.AED5D6A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id A00D180003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:56:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G39xYL6c;
	spf=pass (imf30.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773316610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AzZZUL0bzEDB2kX9VRAM9goe/9K9/SlSptMoqCR0rOk=;
	b=PlH/0BPN8tqHdam8y8DxjUvWJJapKtoo6Hs94fkQq2k3PcuL7HWIWUyzh/KsnArER+y0EZ
	/bB7rAgHyNFnQs5iH9bwIzqZbt+Gay1T4csFIms5m4WxoeDuzmVNp0/ZJLh9BlQx0M9YFQ
	d+ZZ+ZBglS2KekJqe8zTEdM6ILWoTAs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773316610; a=rsa-sha256;
	cv=none;
	b=RGg1O/cxBNCwHe418tAg8oTZEEDntgeDN/My5mTtFo6qmVePjlf4CQgirEo+v+7pzGYTmj
	dO5PiObY/pTAo/ZEv4+T3TUaEYPjEn5psTVI7T9ZvGfjNoQeRc7L61m+64zDVhavxy+F7C
	9y3hNgoWt2LIPZMEzOExWP4bUiZZhL8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G39xYL6c;
	spf=pass (imf30.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773316610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AzZZUL0bzEDB2kX9VRAM9goe/9K9/SlSptMoqCR0rOk=;
	b=G39xYL6cDj/SEmyTkg1wP4TmxAEJ7WgdtbzxowDQXIJWLI4+wg8IRHVwnO5K0pkadbopCX
	gb6oE6sQld0JJRy3JX+vVbb2fQTg3nK6cv/r6Km9C2MQ8gpB5likmW4e9sHnDKaj3SLxxP
	DxRWTobz1BlSl23MuM/BSzJ9dN78n1I=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-435-cA4C5gVmMCm_2SwR6QNgOQ-1; Thu,
 12 Mar 2026 07:56:44 -0400
X-MC-Unique: cA4C5gVmMCm_2SwR6QNgOQ-1
X-Mimecast-MFC-AGG-ID: cA4C5gVmMCm_2SwR6QNgOQ_1773316603
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6084418002CB;
	Thu, 12 Mar 2026 11:56:43 +0000 (UTC)
Received: from fedora (unknown [10.72.116.147])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D05CA30001A1;
	Thu, 12 Mar 2026 11:56:37 +0000 (UTC)
Date: Thu, 12 Mar 2026 19:56:31 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Hao Li <hao.li@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Message-ID: <abKp7-HzFT6llbYT@fedora>
References: <aZ0SbIqaIkwoW2mB@fedora>
 <fbssy5y6kpyjlefacmabuojiustr3nocj7timpgejpchkj3lw7@qfss5ffmwdxa>
MIME-Version: 1.0
In-Reply-To: <fbssy5y6kpyjlefacmabuojiustr3nocj7timpgejpchkj3lw7@qfss5ffmwdxa>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: w9WXeColqVwipRScZOsxzNWOTHKhtk8Ldln3ZrMkeR8_1773316603
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: xxcmg558q5yz94snjm4mf4rzbtz7qu6p
X-Rspamd-Queue-Id: A00D180003
X-Rspamd-Server: rspam03
X-HE-Tag: 1773316610-174073
X-HE-Meta: U2FsdGVkX19H9wr4TMvGR34AudsFx4crLM2ylxeKgvubs7No0e9aN/omrn66mVI3b/tudmpiUT9fX1aMozhjBw9kPQGeoHo3YX4jXoAsH6VbctzOTq+DWUDhJ6KJtgSx07GhJFPbp+d0o78x/S19UBxAp7ylxgEu2jky/GmmgUpsdzs/PfVs9UElMHyx1jmf8adI6AlH9YLPP4ZzOo5i6F8tf/q62bQnC2jVaV4JIF6vKm2Ju9VzN97fevbJgCA9Yr9z3s2Jfb4aSKsQ7mj7SLRzBRRxdae4lNTwS0F+r8iNFnjhLRItm7lfHSFPnQJO4Unqx4kvKUEfMcKLjJyASCeQWrKdSNCxrrpxUJsTOoDU54BgxE+3kuYxJrp5YKUans4v5yR4E9ZkPn0PM+zPFMK6TGYcRT6R+0m83+DCTuCe29xTBdSEihJoEWR1yMhUcDAxrhD0mnTddIRfUPQ6D4+u8ZCV7HQh82vUvBHvIcV3zKhbMTwzGgDLLExFYXQ7bXpA+vzKtHOGxzeiJShi6CQ8p2TbxKqO568qtVPdo7dZMhwqm7a0VMSev4FRpNVghcP+N0c8OtxCN6D+D3Ul3LgcCpgMJKuIELpfZnJME0PCiDjp1HWCumeqPpZRY2Rz9ng3JM0uT4s8uC2GMKeac+HduM7n9sq+3j7P/5jZocqgGWTAw4RPTJ2Z6BiGo7aGuv+75dmB3FryE745MggfLKeNQRfabqlsfVy1tC67mSeRkiTSomrXfNS64M/8cM/E9Q9emSX8hhp5A1zGmzge6qDOnTJaRT8M+MT0KtM8fJYFg9/w1aTINWISY2EL7NE6MBRUXolEHj9DHgTTPcIr8XZeCUXFgXXQJrJ4LyXyrlAsZm9sd6c3xEG20/SRxZcWgFd+moVd3Db9XZJQ7Xulslp/fgqks6lpA0JhfHOR/jTCCbemXptT2Hc889geZX/Xt3qhg6ZSy/fQ/wu3Qay
 qy3cQpDK
 tUOzHvnyorMcj08ZbIZQZtqhwkrD/4NOVifQUZ7iERgM2GT/H+KmMXLEWPplb/EWcXOU1kIBQ85JAUom0MN8A0AG5Qy5rvS1UbEOr/pZjW3vGp6bFcrmPI196jpsU5TNF6Coup/p8Z8oVm61rpy5ZX8pikTOAHytusV02raXUatI9JW2f5ELPADUDBb0WRv2CZnVT31za6EAQFqvpNIhxBEZ4yadAxlgO/uRe9IXzF07dGsvy/fRWm8nVg1aYhtdXffEkulQxgZHawovTJ87cD5d/CrOwB7Nm1RoTP4YR3VyyLqOH1K1KCqXTDkMix+Op7ll/l8s0JgWESnmFy4ePKWHZig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 07:26:28PM +0800, Hao Li wrote:
> On Tue, Feb 24, 2026 at 10:52:28AM +0800, Ming Lei wrote:
> > Hello Vlastimil and MM guys,
> > 
> > The SLUB "sheaves" series merged via 815c8e35511d ("Merge branch
> > 'slab/for-7.0/sheaves' into slab/for-next") introduces a severe
> > performance regression for workloads with persistent cross-CPU
> > alloc/free patterns. ublk null target benchmark IOPS drops
> > significantly compared to v6.19: from ~36M IOPS to ~13M IOPS (~64%
> > drop).
> > 
> > Bisecting within the sheaves series is blocked by a kernel panic at
> > 17c38c88294d ("slab: remove cpu (partial) slabs usage from allocation
> > paths"), so the exact first bad commit could not be identified.
> > 
> > Reproducer
> > ==========
> > 
> > Hardware: NUMA machine with >= 32 CPUs
> > Kernel:   v7.0-rc (with slab/for-7.0/sheaves merged)
> > 
> >     # build kublk selftest
> >     make -C tools/testing/selftests/ublk/
> > 
> >     # create ublk null target device with 16 queues
> >     tools/testing/selftests/ublk/kublk add -t null -q 16
> > 
> >     # run fio/t/io_uring benchmark: 16 jobs, 20 seconds, non-polled
> >     taskset -c 0-31 fio/t/io_uring -p0 -n 16 -r 20 /dev/ublkb0
> > 
> >     # cleanup
> >     tools/testing/selftests/ublk/kublk del -n 0
> > 
> > Good: v6.19 (and 41f1a08645ab, the mainline parent of the slab merge)
> > Bad:  815c8e35511d (Merge branch 'slab/for-7.0/sheaves' into slab/for-next)
> > 
> 
> Hi Ming,
> 
> I also have a similar machine, but my test results show that the IOPS is below
> 1M, only around 900K. That seems quite strange to me.
> 
> My test commands are:
> 
> ```bash
> tools/testing/selftests/ublk/kublk add -t null -q 16
> taskset -c 24-47 /home/haolee/fio/t/io_uring -p0 -n 16 -r 20 /dev/ublkb0
> ```

The command line looks similar with mine, just in my tests:

taskset -c 0-31 fio/t/io_uring -p0 -n 16 -r 20 /dev/ublkb0

so the test is run cpu 0~31, which covers all 8 numa node.

Also what is the single job perf result on your setting?

/home/haolee/fio/t/io_uring -p0 -n 1 -r 20 /dev/ublkb0

> 
> Below are my machine numa info. Could there be something configured incorrectly
> on my side?
> 
> available: 8 nodes (0-7)
> node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
> node 0 size: 193175 MB
> node 0 free: 164227 MB
> node 1 cpus: 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
> node 1 size: 0 MB
> node 1 free: 0 MB
> node 2 cpus: 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71
> node 2 size: 0 MB
> node 2 free: 0 MB
> node 3 cpus: 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95
> node 3 size: 0 MB
> node 3 free: 0 MB
> node 4 cpus: 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119
> node 4 size: 193434 MB
> node 4 free: 189559 MB
> node 5 cpus: 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143
> node 5 size: 0 MB
> node 5 free: 0 MB
> node 6 cpus: 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167
> node 6 size: 0 MB
> node 6 free: 0 MB
> node 7 cpus: 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191
> node 7 size: 0 MB
> node 7 free: 0 MB
> node distances:
> node   0   1   2   3   4   5   6   7
>   0:  10  12  12  12  32  32  32  32
>   1:  12  10  12  12  32  32  32  32
>   2:  12  12  10  12  32  32  32  32
>   3:  12  12  12  10  32  32  32  32
>   4:  32  32  32  32  10  12  12  12
>   5:  32  32  32  32  12  10  12  12
>   6:  32  32  32  32  12  12  10  12
>   7:  32  32  32  32  12  12  12  10

The nuam topo is different with mine, please see:

https://lore.kernel.org/all/aZ7p9uF8H8u6RxrK@fedora/


Thanks,
Ming


