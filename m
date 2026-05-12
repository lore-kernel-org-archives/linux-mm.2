Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A490CD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C44776B0088; Tue, 12 May 2026 01:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCE2F6B008A; Tue, 12 May 2026 01:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6EBE6B008C; Tue, 12 May 2026 01:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8EEC96B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:09:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1531B1C0DE0
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:09:31 +0000 (UTC)
X-FDA: 84757589742.14.86F3617
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id E2408A0003
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:09:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PfJU9KQA;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778562569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZVstgjihvKChR7FG4EvWKQrLQX/rJidvg4YgkMpnUuM=;
	b=A/tWjqibswjDF9FBe8zJ2RuxZIb91ZX+1CsCumuySmsnyHqPRDM4WRbysZN5eebPbY004P
	/n2OXlL1UZ/mYzbUYTyTVuEbGnFrEw+qx+czWAJ3Cxycb1WnqMJLL4i+G1IISsiXCY1/Yo
	0HrF9brN8GKJpc/vjFSh3tBSPzqh1PY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778562569; a=rsa-sha256;
	cv=pass;
	b=1KGaTBta+4l5/iUMiqJwQ5CFQcHvd74y4jlTY7aEM5gCiAtlUjVNib8h/ufFXurup0k/7L
	BcDY/x24JN4W67QGMSAAa6mwRPCJddlKY+KbtShh+qtctjOTUtV9pH3LdWwRHSwhpCECJG
	thEo1ITLFISX8Nq+C0mgjXQqOkNGUPc=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PfJU9KQA;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-67c1e0229acso7780318a12.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 22:09:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778562567; cv=none;
        d=google.com; s=arc-20240605;
        b=ZgsET6dM2ajpQSPSlJNr7m4f9qn0mKcF5S1vy77iW0WsgDSTgfMFoLQz3+hTGfmutV
         2fLBfjREMMuFJz/t8MyAbJzuStngjqTtyaKN44cEnW7xNgz2zcrxAyJ2xbX6hlfTJoem
         ndBAvN2EX5HukmhV12P7ilVHCaLbFlUZHol6KnYwaD7UIBOyMe3ll6P857FsH3d/vOr5
         cyQ0bY5qzsy/Mo/ya2iv/ENPVsECEB2JsbwDJOXKz4JORAdExJ41iuZdxsyId0KFTM8I
         JIlY6BxDDuFxdw5jLiPO4HfqgfhxU8JYk+4ImB3QLdqcly1nCwxm9usErl0NmvUVI5yI
         Hv/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZVstgjihvKChR7FG4EvWKQrLQX/rJidvg4YgkMpnUuM=;
        fh=TnDzDe7FuiG/kwBpyDxKnol8NnzTpSi4+j4aTgiwmPM=;
        b=eLw9bw3Ld92N4Be82WB3/nj0ZMCYSamW2tFj8ZwGT6piIkfJO6k4mJ6dvYbTHrHNjq
         ZNdeEr6bR2/9c8BEL/sDV5pI0ewoFZxDocxEoEJUArVbursUEvChCQdXFcqb5T5oLsGA
         2scd0wi5d797tWVxcsz7MndBEKglXtL8bj2lUV0/x94er7RuN/rvB8JcwBmcY4xubz/S
         4oHDfwvqsOSAr6dW24+kQ8oG8l4isaD/141tA6/W021HbMCZruC37iTWROKrZO2i4Q7A
         S6CwMJFnwyfyU6OBf9wLRmcz0Qw7R7aBE2K44lpIgJMiSN+cNSBDckYTg3jxIcsL9dev
         8A1A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778562567; x=1779167367; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZVstgjihvKChR7FG4EvWKQrLQX/rJidvg4YgkMpnUuM=;
        b=PfJU9KQAKZ+NiSGV5dqaHH2hIFwhr8cg6839tAqBXDf4WEUQE+U9M2hGdvK2ZCzMVr
         OO9ymfYwFRTa5LzHPTAXoStuWwdniHY8lDefAjK7wRTjL+m5UoZUJKTS9doOHhATGrq1
         HpBgpOIcYGKsoWIFQs1X93oJr9VnCensr/WPKdHig/iHYFN9ggad3J/am3zRGyMJRW7f
         I0dM44kHSWyC+EuscIciw9usNQ4qMkvOUdPsfg9alislcpPB13A/aAgIhu2xGrpwh1wP
         vSDOhuUE3OkwvOG1mMUIiuMRuvY46Op5ZDSxQxHVJDXQTHhQoVYOP5asywOOplAgE33l
         Q41Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778562567; x=1779167367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZVstgjihvKChR7FG4EvWKQrLQX/rJidvg4YgkMpnUuM=;
        b=E8OTTIiTRb9S6dOm7OzT1gsiIv1n9D8y20jhPJe7Tf8hrlet/x96shLbzpxDLhaTtO
         EFlxo00h03LRF+GHbReu4GC9KMauAOECYRqv0RPF6facKF8dFL5P/qSwQrmsQkvjM7dJ
         cfbCHmZhcx1keYRu2aJzV228aodSPrPJ1k1pnD+CBQQ2kuHlEl37swDdFFwH9Mli7oW0
         mpCo4z1AHO7ivBzIA9R5RH+MFqpHJpnJ66UICKGuzbz1w9AaCPcqa2Cu+pxRmZijJnV5
         XL6SihmGQo0hLOyGx+qpR8HhVLS8asM2ARW06tsVpE90mebiya2r2QqfkMhA5pW/prpl
         PO6w==
X-Gm-Message-State: AOJu0YxC6l4uUHJ3B11oLzpMQ+CnAqeHApCCZ6EN/E+D5SPsx+czdrgW
	OFkoJ7Swm2FCMzhqg5WuW+zYJkl5GHDzb8O69VAsS3DKwbBRCikCEN4/9KcG2lRg4nI8xodvZhk
	yWmpXKpE4K9dN7iBNKZedkBZ3zXg6rzo=
X-Gm-Gg: Acq92OFloIduwFqsIJskbh35fPH9y+selnKnwMXV6J+u6diqmYHs0qtu6s7zNuDDicr
	hVmeX0pmf66Ppo/WcWuTlpSU5ad3Dm76WaOhstapg5cODPUO4MbRosD/BkS9FtfimA2UNPWBgGP
	7vb7XvYzU71+D/xJIUu/Y00YqxqDB9/Uw8FjULAWAaFyJ1jK70RD7HugoqM1zx4rzTEXxFsHR7e
	ca1KFH/OlBGaWWWMSCqWUXmY+0n54gENUNRx3UQrqRPGer693E1UR5wFWzI4msz9YDk9zGs5ALU
	1cIbmikge/eT66vGGlnuHJzO8tELPYtcClwsEgBz
X-Received: by 2002:a17:907:1c1d:b0:ba1:1181:b773 with SMTP id
 a640c23a62f3a-bd28e31c827mr77303266b.10.1778562566420; Mon, 11 May 2026
 22:09:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com> <agH7qYcyFgRzkQDB@linux.dev>
In-Reply-To: <agH7qYcyFgRzkQDB@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 12 May 2026 13:08:49 +0800
X-Gm-Features: AVHnY4LWUSQuZig1ilMOUQHzBDrWFXC68EAPAavPhiFpf0vTvK096mmMULc1M7c
Message-ID: <CAMgjq7BzQAPp8u_3-9e3ueXmRCoW=2sydok0hFM=MYL7VC1YYg@mail.gmail.com>
Subject: Re: [PATCH v7 00/15] mm/mglru: improve reclaim loop and dirty folio handling
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
	Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
	Qi Zheng <qi.zheng@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E2408A0003
X-Stat-Signature: scxqsiwmne18fhxm9y5k1ra8zbprrjah
X-Rspam-User: 
X-HE-Tag: 1778562568-168548
X-HE-Meta: U2FsdGVkX19tTzKaB9Q7238tvYe9S3+BGssRHL0f1GyqMy244nm9IH18mQLBGuFVgFys3oLEiwPsxsWzyNg0EkpribITfALU6LxQt4V6ABC1tFtPEvNppHr9LYMH2xRv7SuAeqh+LIXYPboZx1UpdBwmlrKJerZSr/9Kf2bV95S/DP8DyHrraddlxq4IVpjWbQ/yHXKGQEW70uWI0XI3gPD7XIDEorwr5778QNHBw8Wd0161MtEB2A440sDS7JX+6H0g8Nw0PdrCO+e8t2n7R+eWhn0cgJwU340TxY1xsD2Bdm1IMXJn3TWrfYj2pg8mAghySJAldVTvaIbJlrNzkHBaeWLSzKOtKpSVQnMVQKrD2q9u/25M5cFCCFGmx0SNmp4qnNydQVL1uAHn0bL7XzddKDh4lM6+f6fgiUfYHU+hdT2NSLewbh/+Rlv5ph+/GR9uillKxYpYueMi8BJqgufzrMuJ+q2I9OxcihHvDNAhp2mzNnvkNG5GIgUTswGUycS8CB5llgZLdzAHAz6i8JfUpRENchSXZHYXmJVJYFqiNVENEMy3o9Q1Bs6Nv2Ui3VX8l3KdaPm9JXLz18uTAbX53QCXwVyPuS63Tu7KJA9vH2fpnn/A9pC/9U3kiAerlqzilZNGrLTIkiIzhIAn/v0SW6Rtra/qc9NjWYIqXhMiOSQmUQDnqQMGG4Kq5yt32rppvIMHZ28C4j/5Qdfr82Jy57mGTs99FMPPGNOELrcI9/drYpOl1B0OSnDxFBP79rylgTr3ULZGYVBcqavevxZBZg1hKivYIpNWDTi9ATv33j3xVPyOqiaA62DmRbFhRNbnc76W4NbKJL8yPceDcN1Jaf5aqDPnmyf3uPqpvOg24Rg0KCLemOk9/LxHxFvJVlQy3DqLjxX+wXHjxB/j8mmsnr+Tr6cpp1KB6vXBJnCmt0Kol72FSy7g7KPbfdKHV0q4LvAjLU6L4yX3yAD
 ptLsuetP
 G+Kp6Y3IROm+Rzzj4r2Zv9/Xv/RZCvXAx5UScKEtSMcBNQ196YNa57KybR6Xil5+0qwwtsTeSdU2eDgxua59d/LqhuW37C2eb978JJdtPhME28DSmw0fEOLplRZ2UZERveZe8v6blnRrdzWSnDsKdr7sMt2B4ZIPCfj4VlMhCEY8bDCCH+KsjpfbaARDqz13Zkhve11M1KhSVRO8rKFk+PP7Hf6QBVqks32ZsO1Zg9J8I8SeBa0GjnNZNtVHumH1FusB3PRuvfVgq0lR9QhxPVTBsClv0Y/htcHwNuuHYLg2JBU5lTZGImLR93wz0EemZVA98hIcmduUc2mvldNvKHWlse+I5hBW60llKLbzYVaEPEeNUzeUlWKwa/1kblAyjk+Nr/6PjFzJSRs6RBNNQvOz5TsWad3xbTx6Lkw4uEWc4C+jAV+QURliFZ4GEn5wKJn7hwO6y2ZXRXif0mUyMHHFZOPNygHV8WC0UDxHXtlB08ftgVzJb3q0O0qWWTpXJPZoU+XD+5uYr72hxSmZOOUjrNwDiijUAR/6KInq+EpjXQWX8pHALrxvuCHZdFyfNgeciTcDMVhUeYxEFzDZtqJb+G08IypZGKOVJ4TnAaK7FYbGqltpmQ9LQ3YXj1dro4IPirG+chOrAwIMbFT4qUh0EJKR/cMrT7ZasJa8OtU6szV6FGJJFmcQdoMbERvkTxO6SAjuQgyqwGrzGAdqB9Oq3BA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 2:51=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
>
> Hi Kairui,

Hello,

>
> On Tue, Apr 28, 2026 at 02:06:51AM +0800, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Test results: All tests are done on a 48c96t NUMA machine with 2 nodes
> > and a 128G memory machine using NVME as storage.
>
> Please include traditional LRU results for all of the following experimen=
ts as
> well (where it makes sense).

Sure, I've spawn a few test instances, was busy travelling last week.
That specific test machine is occupied so it might take a while.

A systematic test run takes roughly one or two days to complete for
one kernel version or config, e.g. the JS test takes at least 2 hours
to finish. Comparing versions/setups takes more time.

>
> >
> > MongoDB
> > =3D=3D=3D=3D=3D=3D=3D
> > Running YCSB workloadb [2] (recordcount:20000000 operationcount:6000000=
,
> > threads:32), which does 95% read and 5% update to generate mixed read
> > and dirty writeback. MongoDB is set up in a 10G cgroup using Docker, an=
d
> > the WiredTiger cache size is set to 4.5G, using NVME as storage.
>
> Can you add a sentence here on why this workload is chosen and is importa=
nt for
> evaluation?

Because that's exactly the one we observed with regression since it
involves mixed writeback, and it's a pratical case.

>
> >
> > Not using SWAP.
>
> Any specific reason to not have swap in this test?

Because we are testing the writeback here, not related to SWAP, so
just to avoid noise and irrelevant parts.

A longer history involving SWAP is explained here:
https://lore.kernel.org/linux-mm/20230920190244.16839-1-ryncsn@gmail.com/

And a longer discussion on that:
https://lore.kernel.org/linux-mm/CAMgjq7BRaRgYLf2+8=3D+=3DnWtzkrHFKmudZPRm4=
1PR6W+A+L=3DAKA@mail.gmail.com/

Both are not easy to reproduce, though. YCSB with MongoDB seems close
enough and I believe we are heading in the right track.

In an internal workload, we observed that patched MGLRU is about 20%
faster than classical LRU with MongoDB. Upstream MGLRU is still
slightly behind classical LRU at this point, and will hopefully be
patched soon, which is the RFC I posted:
https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-0-913619b014d9@tencen=
t.com/

>
> >
> > Before:
> > Throughput(ops/sec): 62485.02962831822
> > AverageLatency(us): 500.9746963330107
> > pgpgin 159347462
> > pgpgout 5413332
> > workingset_refault_anon 0
> > workingset_refault_file 34522071
> >
> > After:
> > Throughput(ops/sec): 79760.71784646061 (+27.6%, higher is better)
> > AverageLatency(us): 391.25169970043726 (-21.9%, lower is better)
> > pgpgin 111093923                       (-30.3%, lower is better)
> > pgpgout 5437456
> > workingset_refault_anon 0
> > workingset_refault_file 19566366       (-43.3%, lower is better)
> >
> > We can see a significant performance improvement after this series.
> > The test is done on NVME and the performance gap would be even larger
> > for slow devices, such as HDD or network storage. We observed over
> > 100% gain for some workloads with slow IO.
> >
> > Chrome & Node.js [3]
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Using Yu Zhao's test script [3], testing on a x86_64 NUMA machine with =
2
> > nodes and 128G memory, using 256G ZRAM as swap and spawn 32 memcg 64
> > workers:
> >
> > Before:
> > Total requests:            79915
> > Per-worker 95% CI (mean):  [1233.9, 1263.5]
> > Per-worker stdev:          59.2
> > Jain's fairness:           0.997795 (1.0 =3D perfectly fair)
> > Latency:
> > Bucket     Count      Pct    Cumul
> > [0,1)s     26859   33.61%   33.61%
> > [1,2)s      7818    9.78%   43.39%
> > [2,4)s      5532    6.92%   50.31%
> > [4,8)s     39706   49.69%  100.00%
> >
> > After:
> > Total requests:            81382
> > Per-worker 95% CI (mean):  [1241.9, 1301.3]
> > Per-worker stdev:          118.8
> > Jain's fairness:           0.991480 (1.0 =3D perfectly fair)
> > Latency:
> > Bucket     Count      Pct    Cumul
> > [0,1)s     26696   32.80%   32.80%
> > [1,2)s      8745   10.75%   43.55%
> > [2,4)s      6865    8.44%   51.98%
> > [4,8)s     39076   48.02%  100.00%
> >
> > Reclaim is still fair and effective, total requests number seems
> > slightly better.
>
> Please add a reference to Jain's fairness and a sentence on why we should=
 care
> about it.

So first, Here is the previous test setup for that:
https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@google.com/

The basical idea is simple: if all memcgs are under similar pressure,
they should be reclaimed equally, which seems fair.

The fairness index measures the equality of resource allocation among
users. It is commonly used to evaluate network bandwidth distribution
for multiple users under pressure, which seems suitable here. We are
also measuring the reclaim ratio for multiple users under pressure.
I'm using a numeric index here so I don't need to post 500 lines of
raw test results every time:
https://www.sciencedirect.com/topics/computer-science/fairness-index

Also here is the longer version of test result I just collected in
past few days. The test closely mirrors real-world usage from desktop
to web services.

Classical LRU:
------------------------------------------------------------------------
THROUGHPUT
------------------------------------------------------------------------
  Total requests:           60226
  Per-worker mean:          941.0
  Per-worker median:          931
  Per-worker min:             678
  Per-worker max:            1252
  Per-worker stdev:         131.3
  95% CI (mean):       [   908.2,    973.9]
------------------------------------------------------------------------
LATENCY DISTRIBUTION (all workers aggregated)
------------------------------------------------------------------------
      Bucket     Count      Pct    Cumul
      [0,1)s     19493   32.37%   32.37%
      [1,2)s      2024    3.36%   35.73%
      [2,4)s      5621    9.33%   45.06%
      [4,8)s     32881   54.60%   99.66%
     [8,16)s       207    0.34%  100.00%
    [16,32)s         0    0.00%  100.00%
    [32,64)s         0    0.00%  100.00%
   [64,128)s         0    0.00%  100.00%
  [128,inf)s         0    0.00%  100.00%
------------------------------------------------------------------------
FAIRNESS (per-worker total requests)
------------------------------------------------------------------------
  Jain's fairness index: 0.981188  (1.0 =3D perfectly fair)
  Coeff of variation:    0.1396  (0.0 =3D perfectly fair)
  Min/Max ratio:         0.5415
  P10:                      780
  P25:                      855
  P50 (median):             931
  P75:                     1040
  P90:                     1112
------------------------------------------------------------------------
PER-MEMCG BREAKDOWN (sorted by total, top/bottom 5)
------------------------------------------------------------------------
  Memcgs: 32  mean=3D1882.1  95%CI=3D[1799.8, 1964.4]  Jain=3D0.9860
         --- Top 5 ---
    memcg  6:   2423 requests
    memcg 10:   2364 requests
    memcg 31:   2213 requests
    memcg 20:   2207 requests
    memcg 30:   2156 requests
      --- Bottom 5 ---
    memcg 27:   1658 requests
    memcg 19:   1645 requests
    memcg 12:   1610 requests
    memcg  0:   1566 requests
    memcg 28:   1533 requests
Raw Result:
client: 8047 total:    984, 0:    293, 1:     44, 2:    108, 4:
538, 8:      1, 16:      0, 32:      0, 64:      0, 128:      0
client: 8058 total:    882, 0:    289, 1:     18, 2:     63, 4:
507, 8:      5, 16:      0, 32:      0, 64:      0, 128:      0
client: 8017 total:   1051, 0:    347, 1:     43, 2:    133, 4:
528, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8059 total:    952, 0:    274, 1:     41, 2:     92, 4:
545, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8005 total:    921, 0:    230, 1:     43, 2:    113, 4:
535, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8063 total:   1173, 0:    459, 1:     50, 2:    161, 4:
503, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8051 total:    986, 0:    296, 1:     34, 2:    122, 4:
534, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8043 total:    949, 0:    260, 1:     53, 2:     90, 4:
546, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8045 total:   1069, 0:    362, 1:     46, 2:    143, 4:
518, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8008 total:    857, 0:    259, 1:     25, 2:     69, 4:
500, 8:      4, 16:      0, 32:      0, 64:      0, 128:      0
client: 8023 total:   1049, 0:    348, 1:     44, 2:    136, 4:
521, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8015 total:    895, 0:    221, 1:     34, 2:    105, 4:
534, 8:      1, 16:      0, 32:      0, 64:      0, 128:      0
client: 8027 total:    899, 0:    219, 1:     42, 2:     96, 4:
542, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8061 total:   1093, 0:    396, 1:     31, 2:    157, 4:
509, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8038 total:    737, 0:    174, 1:      7, 2:     46, 4:
501, 8:      9, 16:      0, 32:      0, 64:      0, 128:      0
client: 8056 total:    678, 0:    133, 1:      5, 2:     32, 4:
501, 8:      7, 16:      0, 32:      0, 64:      0, 128:      0
client: 8040 total:   1039, 0:    423, 1:     37, 2:     93, 4:
477, 8:      9, 16:      0, 32:      0, 64:      0, 128:      0
client: 8036 total:    766, 0:    202, 1:      7, 2:     54, 4:
494, 8:      9, 16:      0, 32:      0, 64:      0, 128:      0
client: 8000 total:    697, 0:    136, 1:     13, 2:     48, 4:
495, 8:      5, 16:      0, 32:      0, 64:      0, 128:      0
client: 8030 total:    804, 0:    232, 1:     14, 2:     53, 4:
501, 8:      4, 16:      0, 32:      0, 64:      0, 128:      0
client: 8006 total:    852, 0:    267, 1:     18, 2:     62, 4:
495, 8:     10, 16:      0, 32:      0, 64:      0, 128:      0
client: 8062 total:   1040, 0:    437, 1:     43, 2:     61, 4:
489, 8:     10, 16:      0, 32:      0, 64:      0, 128:      0
client: 8014 total:    833, 0:    254, 1:     14, 2:     58, 4:
497, 8:     10, 16:      0, 32:      0, 64:      0, 128:      0
client: 8060 total:   1063, 0:    465, 1:     23, 2:     81, 4:
485, 8:      9, 16:      0, 32:      0, 64:      0, 128:      0
client: 8046 total:    814, 0:    244, 1:     18, 2:     40, 4:
508, 8:      4, 16:      0, 32:      0, 64:      0, 128:      0
client: 8049 total:   1080, 0:    388, 1:     40, 2:    123, 4:
529, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8022 total:   1001, 0:    422, 1:     22, 2:     62, 4:
486, 8:      9, 16:      0, 32:      0, 64:      0, 128:      0
client: 8019 total:    988, 0:    304, 1:     36, 2:    116, 4:
532, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8026 total:    780, 0:    218, 1:     12, 2:     47, 4:
500, 8:      3, 16:      0, 32:      0, 64:      0, 128:      0
client: 8024 total:    719, 0:    163, 1:      7, 2:     43, 4:
501, 8:      5, 16:      0, 32:      0, 64:      0, 128:      0
client: 8053 total:   1045, 0:    360, 1:     38, 2:    120, 4:
527, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8034 total:    873, 0:    286, 1:     19, 2:     57, 4:
508, 8:      3, 16:      0, 32:      0, 64:      0, 128:      0
client: 8048 total:    889, 0:    301, 1:     26, 2:     59, 4:
497, 8:      6, 16:      0, 32:      0, 64:      0, 128:      0
client: 8055 total:    871, 0:    199, 1:     40, 2:     89, 4:
543, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8001 total:    869, 0:    196, 1:     35, 2:     95, 4:
543, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8003 total:   1051, 0:    369, 1:     42, 2:    103, 4:
537, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8011 total:   1118, 0:    398, 1:     53, 2:    156, 4:
511, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8018 total:    762, 0:    192, 1:     15, 2:     45, 4:
503, 8:      7, 16:      0, 32:      0, 64:      0, 128:      0
client: 8021 total:   1112, 0:    410, 1:     41, 2:    145, 4:
516, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8050 total:    869, 0:    276, 1:     21, 2:     71, 4:
496, 8:      5, 16:      0, 32:      0, 64:      0, 128:      0
client: 8032 total:    823, 0:    238, 1:     21, 2:     54, 4:
505, 8:      5, 16:      0, 32:      0, 64:      0, 128:      0
client: 8044 total:   1030, 0:    433, 1:     31, 2:     66, 4:
496, 8:      4, 16:      0, 32:      0, 64:      0, 128:      0
client: 8035 total:    965, 0:    283, 1:     42, 2:    112, 4:
528, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8025 total:    891, 0:    212, 1:     43, 2:     90, 4:
546, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8039 total:    908, 0:    241, 1:     36, 2:     86, 4:
545, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8009 total:    963, 0:    286, 1:     36, 2:    108, 4:
533, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8037 total:    917, 0:    227, 1:     45, 2:    100, 4:
545, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8020 total:   1252, 0:    607, 1:     51, 2:    115, 4:
477, 8:      2, 16:      0, 32:      0, 64:      0, 128:      0
client: 8004 total:    818, 0:    245, 1:     16, 2:     47, 4:
501, 8:      9, 16:      0, 32:      0, 64:      0, 128:      0
client: 8052 total:    870, 0:    285, 1:     20, 2:     52, 4:
507, 8:      6, 16:      0, 32:      0, 64:      0, 128:      0
client: 8033 total:    925, 0:    269, 1:     28, 2:     83, 4:
545, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8010 total:    931, 0:    334, 1:     29, 2:     62, 4:
500, 8:      6, 16:      0, 32:      0, 64:      0, 128:      0
client: 8016 total:    990, 0:    388, 1:     27, 2:     70, 4:
500, 8:      5, 16:      0, 32:      0, 64:      0, 128:      0
client: 8012 total:   1173, 0:    556, 1:     51, 2:     78, 4:
480, 8:      8, 16:      0, 32:      0, 64:      0, 128:      0
client: 8028 total:    837, 0:    253, 1:     32, 2:     47, 4:
500, 8:      5, 16:      0, 32:      0, 64:      0, 128:      0
client: 8031 total:    992, 0:    315, 1:     33, 2:    119, 4:
525, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8041 total:   1168, 0:    452, 1:     52, 2:    162, 4:
502, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8054 total:    787, 0:    212, 1:     15, 2:     58, 4:
493, 8:      9, 16:      0, 32:      0, 64:      0, 128:      0
client: 8042 total:    799, 0:    227, 1:     13, 2:     45, 4:
508, 8:      6, 16:      0, 32:      0, 64:      0, 128:      0
client: 8002 total:   1034, 0:    449, 1:     32, 2:     59, 4:
488, 8:      6, 16:      0, 32:      0, 64:      0, 128:      0
client: 8057 total:    855, 0:    184, 1:     47, 2:     81, 4:
543, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8007 total:    965, 0:    269, 1:     36, 2:    135, 4:
525, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8013 total:   1250, 0:    536, 1:     53, 2:    143, 4:
518, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8029 total:    973, 0:    290, 1:     41, 2:    102, 4:
539, 8:      1, 16:      0, 32:      0, 64:      0, 128:      0

MGLRU (after this series, results are similar before this with seems
slightly lower throughput or maybe just noise, see cover letter):
------------------------------------------------------------------------
THROUGHPUT
------------------------------------------------------------------------
  Total requests:           83926
  Per-worker mean:         1311.3
  Per-worker median:         1306
  Per-worker min:            1170
  Per-worker max:            1466
  Per-worker stdev:          70.8
  95% CI (mean):       [  1293.6,   1329.0]
------------------------------------------------------------------------
LATENCY DISTRIBUTION (all workers aggregated)
------------------------------------------------------------------------
      Bucket     Count      Pct    Cumul
      [0,1)s     27929   33.28%   33.28%
      [1,2)s      9075   10.81%   44.09%
      [2,4)s      8558   10.20%   54.29%
      [4,8)s     38364   45.71%  100.00%
     [8,16)s         0    0.00%  100.00%
    [16,32)s         0    0.00%  100.00%
    [32,64)s         0    0.00%  100.00%
   [64,128)s         0    0.00%  100.00%
  [128,inf)s         0    0.00%  100.00%
------------------------------------------------------------------------
FAIRNESS (per-worker total requests)
------------------------------------------------------------------------
  Jain's fairness index: 0.997138  (1.0 =3D perfectly fair)
  Coeff of variation:    0.0540  (0.0 =3D perfectly fair)
  Min/Max ratio:         0.7981
  P10:                     1220
  P25:                     1253
  P50 (median):            1306
  P75:                     1367
  P90:                     1398
------------------------------------------------------------------------
PER-MEMCG BREAKDOWN (sorted by total, top/bottom 5)
------------------------------------------------------------------------
  Memcgs: 32  mean=3D2622.7  95%CI=3D[2601.4, 2643.9]  Jain=3D0.9995
         --- Top 5 ---
    memcg 24:   2719 requests
    memcg  5:   2711 requests
    memcg 16:   2703 requests
    memcg  0:   2696 requests
    memcg 19:   2689 requests
      --- Bottom 5 ---
    memcg 20:   2550 requests
    memcg 21:   2534 requests
    memcg 23:   2521 requests
    memcg 22:   2514 requests
    memcg 27:   2514 requests
Raw result:
client: 8028 total:   1252, 0:    410, 1:    132, 2:    106, 4:
604, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8026 total:   1220, 0:    390, 1:    107, 2:    106, 4:
617, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8036 total:   1260, 0:    403, 1:    154, 2:     92, 4:
611, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8038 total:   1322, 0:    475, 1:    150, 2:     90, 4:
607, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8002 total:   1220, 0:    384, 1:    137, 2:     82, 4:
617, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8008 total:   1264, 0:    410, 1:    138, 2:    108, 4:
608, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8044 total:   1180, 0:    339, 1:    123, 2:     94, 4:
624, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8062 total:   1267, 0:    428, 1:    125, 2:    111, 4:
603, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8050 total:   1197, 0:    351, 1:    131, 2:    113, 4:
602, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8057 total:   1379, 0:    480, 1:    142, 2:    158, 4:
599, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8048 total:   1301, 0:    454, 1:    142, 2:    101, 4:
604, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8034 total:   1266, 0:    422, 1:    140, 2:     98, 4:
606, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8020 total:   1282, 0:    425, 1:    153, 2:     98, 4:
606, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8000 total:   1245, 0:    404, 1:    137, 2:     88, 4:
616, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8030 total:   1282, 0:    411, 1:    164, 2:    104, 4:
603, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8045 total:   1334, 0:    424, 1:    147, 2:    168, 4:
595, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8053 total:   1359, 0:    462, 1:    139, 2:    161, 4:
597, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8060 total:   1240, 0:    375, 1:    158, 2:    110, 4:
597, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8043 total:   1338, 0:    437, 1:    138, 2:    171, 4:
592, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8041 total:   1323, 0:    438, 1:    124, 2:    155, 4:
606, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8025 total:   1331, 0:    435, 1:    130, 2:    180, 4:
586, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8040 total:   1227, 0:    389, 1:    133, 2:     92, 4:
613, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8022 total:   1240, 0:    393, 1:    139, 2:    100, 4:
608, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8049 total:   1418, 0:    510, 1:    145, 2:    172, 4:
591, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8012 total:   1205, 0:    373, 1:    120, 2:     93, 4:
619, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8059 total:   1375, 0:    462, 1:    171, 2:    152, 4:
590, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8037 total:   1412, 0:    513, 1:    144, 2:    171, 4:
584, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8001 total:   1451, 0:    536, 1:    160, 2:    191, 4:
564, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8009 total:   1356, 0:    451, 1:    133, 2:    182, 4:
590, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8039 total:   1367, 0:    456, 1:    144, 2:    186, 4:
581, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8042 total:   1196, 0:    345, 1:    134, 2:     97, 4:
620, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8013 total:   1409, 0:    519, 1:    134, 2:    172, 4:
584, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8021 total:   1392, 0:    478, 1:    156, 2:    169, 4:
589, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8031 total:   1373, 0:    477, 1:    135, 2:    174, 4:
587, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8014 total:   1271, 0:    419, 1:    152, 2:     96, 4:
604, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8015 total:   1305, 0:    398, 1:    139, 2:    179, 4:
589, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8024 total:   1251, 0:    390, 1:    167, 2:     78, 4:
616, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8033 total:   1335, 0:    408, 1:    169, 2:    172, 4:
586, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8004 total:   1245, 0:    398, 1:    129, 2:    107, 4:
611, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8003 total:   1394, 0:    494, 1:    144, 2:    154, 4:
602, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8052 total:   1296, 0:    444, 1:    154, 2:    106, 4:
592, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8061 total:   1353, 0:    455, 1:    142, 2:    147, 4:
609, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8017 total:   1355, 0:    451, 1:    153, 2:    166, 4:
585, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8063 total:   1367, 0:    474, 1:    136, 2:    152, 4:
605, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8018 total:   1225, 0:    379, 1:    132, 2:     97, 4:
617, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8029 total:   1345, 0:    460, 1:    129, 2:    152, 4:
604, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8027 total:   1398, 0:    518, 1:    121, 2:    158, 4:
601, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8007 total:   1253, 0:    375, 1:    118, 2:    124, 4:
636, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8047 total:   1302, 0:    414, 1:    126, 2:    170, 4:
592, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8005 total:   1397, 0:    488, 1:    151, 2:    161, 4:
597, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8019 total:   1347, 0:    437, 1:    145, 2:    178, 4:
587, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8035 total:   1361, 0:    453, 1:    151, 2:    179, 4:
578, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8011 total:   1416, 0:    517, 1:    147, 2:    172, 4:
580, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8023 total:   1385, 0:    473, 1:    161, 2:    172, 4:
579, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8046 total:   1219, 0:    388, 1:    123, 2:     91, 4:
617, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8056 total:   1304, 0:    463, 1:    135, 2:     95, 4:
611, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8006 total:   1306, 0:    442, 1:    147, 2:    130, 4:
587, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8054 total:   1170, 0:    321, 1:    136, 2:    101, 4:
612, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8055 total:   1344, 0:    447, 1:    141, 2:    169, 4:
587, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8010 total:   1295, 0:    429, 1:    164, 2:    100, 4:
602, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8016 total:   1292, 0:    448, 1:    140, 2:    108, 4:
596, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8051 total:   1466, 0:    555, 1:    152, 2:    200, 4:
559, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8058 total:   1278, 0:    430, 1:    144, 2:     86, 4:
618, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0
client: 8032 total:   1368, 0:    502, 1:    168, 2:    113, 4:
585, 8:      0, 16:      0, 32:      0, 64:      0, 128:      0

The test is rebased on 7.1 rc, MGLRU seems ~30% faster compared to
classical LRU, better latency distribution, and better fairness too.
On my x86 machine the gain is not as much as the one Yu posted
for ARM, but it still looks very good.

Ridong also reproduced with a much better result where MGLRU seems to
be much faster than classical LRU on ARM (or maybe using different
time priod?):
https://lore.kernel.org/linux-mm/20260120134256.2271710-1-chenridong@huawei=
cloud.com/

During one or two test runs, a single memcg might archive much higher
throughput with MGLRU, causing fairness to look slightly worse,
however, overall performance still seems much better than classical
LRU. I suspect improvements are needed for aging or the random bucket
part, but I think that's an irrelevant topic for now.

> >
> > MySQL:
> > =3D=3D=3D=3D=3D=3D
> >
> > Testing with innodb_buffer_pool_size=3D26106127360, in a 2G memcg, usin=
g
> > ZRAM as swap and test command:
> >
> > sysbench /usr/share/sysbench/oltp_read_only.lua --mysql-db=3Dsb \
> >   --tables=3D48 --table-size=3D2000000 --threads=3D48 --time=3D600 run
> >
> > Before:            17303.41 tps
> > After this series: 17291.50 tps
> >
> > Seems only noise level changes, no regression.
> >
>
> Please add a sentence on why this specific params.
>
> > FIO:
> > =3D=3D=3D=3D
> > Testing with the following command, where /mnt/ramdisk is a
> > 64G EXT4 ramdisk, each test file is 3G, in a 10G memcg,
> > 6 test run each:
> >
> > fio --directory=3D/mnt/ramdisk --filename_format=3D'test.$jobnum.img' \
> >   --name=3Dcached --numjobs=3D16 --size=3D3072M --buffered=3D1 --ioengi=
ne=3Dmmap \
> >   --rw=3Drandread --norandommap --time_based \
> >   --ramp_time=3D1m --runtime=3D5m --group_reporting
> >
> > Before:            8968.76 MB/s
> > After this series: 8995.63 MB/s
> >
> > Also seem only noise level changes and no regression or slightly better=
.
>
> Same here.

I tested the page cache performance with buffered read. There is
another test involving classical LRU, where MGLRU seems to
significantly outperform classical LRU. The case was provided by the
CachyOS community, I didn't include it here because the cover letter
is already getting tediously long.

https://lore.kernel.org/all/acgNCzRDVmSbXrOE@KASONG-MC4/

MGLRU seems to have significantly lower jitter and better performance with =
that.

BTW I also disabled OOMD or any related daemon to avoid noise during
that test. I repeated the test several times, and recorded one test
run as well since it's meant for a desktop test and I was discussing
with distro communities at that time. MGLRU TTL can completely avoid
jitter, however, it's not enabled during the test to prevent
confusion.

Classical LRU:
https://www.youtube.com/watch?v=3DpujboGNcBNI

MGLRU:
https://www.youtube.com/watch?v=3DffnFUeaBQ_0

>
> >
> > Build kernel:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Build kernel test using ZRAM as swap, on top of tmpfs, in a 3G memcg
> > using make -j96 and defconfig, measuring system time, 12 test run each.
> >
> > Before:            2873.52s
> > After this series: 2811.88s
> >
> > Also seem only noise level changes, no regression or very slightly bett=
er.
>
> So, the kernel source code is on tmpfs, right? Also 3G memcg means memory=
.max is
> 3G, correct?

Right. That's to avoid I/O noise. I also tested with source code on
disk, I didn't post that because I think the MySQL test already shows
a workload of mixed anon / file.

