Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24F43F436BC
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 07:27:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 630CF6B019D; Sat, 18 Apr 2026 03:27:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB716B019E; Sat, 18 Apr 2026 03:27:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0496B019F; Sat, 18 Apr 2026 03:27:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3762F6B019D
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 03:27:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CEDA61A044E
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:27:51 +0000 (UTC)
X-FDA: 84670847142.06.A0A7220
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf15.hostedemail.com (Postfix) with ESMTP id E706AA0004
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:27:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hxUqAgvC;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf15.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776497269; a=rsa-sha256;
	cv=none;
	b=bafEi21SCwGl4eV+S0UTKhwIlv7w+m341bjfQBnQtPUvatDXABuY/p5B0SVh5bPDchCsLv
	0CXAgUohu0mLG65e0e3OH/VM/bQTcDhubJQafrjfRvfTvHUBDB/Ug3yMfzKTuuN8ewAO8t
	j2XZqfvIAFpWD0dlTFxFIFO9KGPRngc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hxUqAgvC;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf15.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776497269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3UcfRf5hLw4IB/6slz/PWLrVHi+t9Kb7u9t3nrC9M8A=;
	b=SBRLhbC9INdquGRLkEmXoeHsWR7/lw6UhNbbTbhMsaJK0zLIum0GvbWIETdXNoiZhMUwT7
	B26ULnZrkcxEvAjQ3NYoVg90kYhty6lNEm7BhRusBwSDs89p3m9FvaG8PF4VgRblV1PhU5
	hQR3NSiKC/jtOMxRazHOhc9N1u+rWng=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63I7Qbb13074796;
	Sat, 18 Apr 2026 07:27:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=3UcfRf5hLw4IB/6slz/PWLrVHi+t9K
	b7u9t3nrC9M8A=; b=hxUqAgvCJlZUp978BMJxZuGZHwxUqmbj1NF/QhYhhpv6hn
	Bx0bZp7MJe4vHF53PLnjja0LMj6RyDvj/Pypnp+qoOoe6Q59zfU3S9x+52QwZ59Y
	qbhDcGsCLp3QdokFZCw5fA9p5hoAghZmXYpf+IAOLdGcCUldWeNrDB50HjKqyADh
	4tSjOsXjrmAYEIzau1AN25DwGT6XwmYwA6kTxoOISNBD+6JZsX+3KjRbVsxw+pth
	tOjZt6yAMwB5Kaq7RtOlT/yccx67InBV+0JHCk2GcvT1K2jlw92wwOAwOf0aV8g2
	YwKp9MNxCsMLbr5iKyKeeSgJ2ZS4PTThnq1CF3MA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2j68eju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 18 Apr 2026 07:27:36 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63I7KNBp008694;
	Sat, 18 Apr 2026 07:27:35 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dm21b8h0w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 18 Apr 2026 07:27:35 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63I7RXlR46268682
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 18 Apr 2026 07:27:33 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C670520043;
	Sat, 18 Apr 2026 07:27:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C744320040;
	Sat, 18 Apr 2026 07:27:29 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.28.145])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sat, 18 Apr 2026 07:27:29 +0000 (GMT)
Date: Sat, 18 Apr 2026 12:56:54 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
Message-ID: <aeMyFgfHYy6FToBS@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <q5ksnnwwnjqyvzqrlx5u2zzsq2rs4uoirn4xvt6dfrdck7df5e@pxyaupfbdb3u>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <q5ksnnwwnjqyvzqrlx5u2zzsq2rs4uoirn4xvt6dfrdck7df5e@pxyaupfbdb3u>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE4MDA2NiBTYWx0ZWRfXwFPJEJS7wVp6
 CESWDNOiOf9/f3ODyOoRfe8qmhogcakqYitJmNelpO+jPZVI7bbHZJ2ZY05E++w43Nz3avsU22X
 Nqggc0oYXlbZ1FlHIZrH/tJ2JYYibHGCtUKMwuEwWX+EPmMWgG1ff7mfL5SAxFo/3/t6arQqmRA
 EBxkKoH4SLdA/foT/jISbLIpHCnN/zaouoB6eaOTE9Ze5RdP2AK8AIULq8MZLIYIrhgC25Z5QiO
 T1b0kkn16BNCW/8Q/OoMDgl0DhpsAE6Ck1CkXbzbmFCWjum1qiGwlVolm8XM6DY4BBKUrazPqnV
 r/eOcNv58qZrnwGdbSjFRlXbvdYTG0f/zT0nkjTXszAKwENibVdP06IaGg9BxeB1Hnhxh9ItsUu
 3RbzZGji7v/qVCrjFjy2Htx+ASOIL/ykW8zdxJc+kCj2fIkBOcCowfmHmKGPoAc+6yqFdPNjyRT
 MJmNezbe1p/E1OLBt+g==
X-Proofpoint-GUID: FNkw54uiIHo6KhVeRBeSwe8XbvE3EDvW
X-Authority-Analysis: v=2.4 cv=SOJykuvH c=1 sm=1 tr=0 ts=69e33269 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=NEAV23lmAAAA:8
 a=Mcrhb_LkTwXRYZEqJH8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 4wNoO9SGHnkx-6V8sya06khVAmjV_C6t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-18_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 phishscore=0 suspectscore=0 adultscore=0 impostorscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604180066
X-Rspamd-Server: rspam10
X-Stat-Signature: jeqxm9ajyibz9ecf8er5wctjx8jau7ei
X-Rspam-User: 
X-Rspamd-Queue-Id: E706AA0004
X-HE-Tag: 1776497267-207527
X-HE-Meta: U2FsdGVkX19mgiCwbdw30k9DJdDskj8xZ4OxZNEpY6spOC81u1w1uj0PIOU+eVk2DtLjp2DId6SOWNTsMuO1Pg0+M9sB4OAJWsJCkyNosh5yZrLdLl+RLRqNgYes8+donGzpe82wsdyyrr1U3HdXMwj/tPEqBZNVGKiBDocV4YTY3LkIV694nXIJHNwx5+VcTWUH4FNp9WA12QxIO9nVfMu1i571/CdMm5QOeYsQkyTLmRs0ZedRXfpbvfzVK5vyZO5OzL+upTn/AWvvgiPshc9ab/IIUm64kwyXUeiCnxH9tQuBIoENmfJEkdVj3QcmRDsYd+ydQF+leUMIDeExOyCF0LrqvrdSAkgk7mww0bX4WAEceNqXrMNd7QzDtY+k8+0Or21iNmCKSUv7f2RqqYkl21DgkZyU75sPO7dvG0WpNKbcYQ+okQSMNgm4Cfvya7lqUCtY+PrLN6mHbxbfi8IGhniF08y24yCVTPZJ6rL9I67JEDZnXAYrbuSxe8iXhACoUZHzaaDXKAZ1LFHisTzJvMLUSEJ4k9atGzOcePZVyir1Jy6vRWrFKPrO/S455gi03EaGNFidOvp7UHoupzFuXIfG9G6XCpiNq/1RLcBfxyhj351NlDI62lhjm6xkhxetcUd0fRxo+I8ge6V+sDjUIxfETGLeZe1qoTDj2mNnh+MWLOq5qZr4aFFiiGMpfbRiutO/7Z/E8gUM5ypTHu8ipZSt3kTYquTC44xB3+l7vs484FLwosJoCP20WJP8uJhr+xcKxBWpeCgvlOx9X5G5VgJxqjCWCpRbfmPtUr3NAGOBjmr7lgl7aU/o80HPPnNepGoshUSdwc95p350A8ft4OteYKbC/uDJj610+RVDYixwRI/+UatHKtuJuFGFIWDdUxT8e3npc0pm6dUtpDAFxGusyTcv3o9cdx/jVulqqA1u/DuG+AdQezbCCl//RsSj9fVsW9cYuuvvxqr
 cT8eo2BP
 2Z/o20GI3DzO5VM4vkp8WhI8TWlhCGbHtyliN1v4kV0kI7SyxYx2OYkHaolPh70/GBbLJ7vr51wmjxk0Edw6ccziqKrPIjHmvm0vXr0XpUCRUSL1A5WT/b06Gu8o47Tb6xpAaynBJjZv1Wadct5AhcZGjwruOJVwT9AHi6rasZmjM+JRHlDzVPF8CHVdClip+XEuCa+R7imyke5A9qEV6wLezx0uyxx8yK9z3UtHrF9xwZMy038kCK9jXWLkhAxLqWsgeuNz1ARVS2CwHuF/lmbad89acun4wVHkaIVp1lh4lo2BKg0qw/afJampGzANwG02L79zmEqQP7FuNHW8C9PpjjLWisv1t5GaGHk5d6WURkfQxLwCDaQ69MkqdtpBB973NnSK9SNzGPRxHyaeIWJPini4VZQfvzUEH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 05:54:46AM +0200, Pankaj Raghav (Samsung) wrote:
> Thanks for the patches.
> 
> > The implementation of write-through combines the buffered IO frontend
> > with dio backend, which leads to some interesting interactions.
> > I've added most of the design notes in respective patches. Please note
> > that this is an initial RFC to iron out any early design issues. This is
> > largely based on suggestions from Dave an Jan in [1] so thanks for the
> > pointers!
> > 
> > 
> > * Testing Notes (UPDATED) *
> > 
> > - I've added support for RWF_WRITETHROUGH to fsx and fsstress in
> >   xfstests and these patches survive fsx with integrity verification as
> >   well as fsstress parallel stressing.
> 
> Could you point me to your xfstests repo where you have added this
> support? :)
> I have been traveling the whole week. I can give the patches a spin in
> my setup in the coming days.

Hi Pankaj, you can find the xfstests support here:

https://github.com/OjaswinM/xfstests/tree/iomap-buf-writethrough2

For fsstress, I was using generic/013 modified to run more operations.
For fsx, any of the run_fsx stressing tests would do, or you could use
the following command (writethrough should auto enable if kernel
supports it):

/home/ojas/workspace/xfstests-dev/ltp/fsx \
 -N 100000 \
 -o 65536 \
 -l 500000 \
 -r 4096 \
 -t 512 \
 -w 512 \
 --record-ops=rwf_rt.fsxops \
 $MNT/junk

Regards,
Ojaswin

> 
> > - -g quick with blocks size == page size and blocksize < pagesize shows
> >   no new regressions.
> > 
> > 
> > * Design TODOs (UPDATED) *
> > 
> > - Evaluate if we need to tag page cache dirty bit in xarray, since 
> >   PG_Writeback is already set on the folio.
> > - Look into a better way to refactor writethrough path by reusing common
> >   parts of dio code.
> > 

