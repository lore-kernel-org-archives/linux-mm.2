Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80F2FCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 06:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA8238E0002; Wed, 10 Sep 2025 02:10:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C800D8E0001; Wed, 10 Sep 2025 02:10:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6F4F8E0002; Wed, 10 Sep 2025 02:10:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9FBA18E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:10:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C5A5BB61A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:10:10 +0000 (UTC)
X-FDA: 83872315380.29.0B9DB5F
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf15.hostedemail.com (Postfix) with ESMTP id D5F41A000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:10:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rWNoOzLm;
	spf=pass (imf15.hostedemail.com: domain of skb99@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=skb99@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757484608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Wn+VjVrW/FxQKYpYPw1n45utb4/Zi2fMljwN+MX69M=;
	b=qyUvNhLJSj8xwXQrv8VARV9XXfKrDkQfhzQtRdswgA2NyFQMVrGvQpKsvDUijsRLlcV1UP
	ufSmQycX22XHRgVWaSv/cyKudWw8NK56EGGLChY8OlxD7tqYj+HVtDqCqX/3IeMfTnJ05M
	itVx39hET85vqiktFcaPj/RGgxUospU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rWNoOzLm;
	spf=pass (imf15.hostedemail.com: domain of skb99@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=skb99@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757484608; a=rsa-sha256;
	cv=none;
	b=GrznhXP73w1g+VnotZ/1SkeCFp8DqD7l5yY8XCYmtaMjkWTvfIszUsns6XTgj7ZC/Nbu2p
	4c+4IqjvJu4bjud1YyBh9Frq57g+/sFZjuP80Ppt2lS1Odm4NYuhz99o70xoSoDMt7Ne1q
	I49d3C9B44DpIRwr+dvPDSzVUPoz0A4=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58A4vTrg024507;
	Wed, 10 Sep 2025 06:10:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=9Wn+Vj
	VrW/FxQKYpYPw1n45utb4/Zi2fMljwN+MX69M=; b=rWNoOzLmhxde+nSsLqFc7X
	a0NuSfPNQ1j025DEWvfmIlzBTLEzWa5updw/znlyPooUWTmNoq8iupkDlipe1Flm
	ZSyqdHDLZSj5kssyM3JkNKMNHv/RSpdFcEiS4e9kbeXE1dIyr5UTik8YzconuIP5
	8nYDpO/uc0eDHC436yAY24twqcCA0pAeLERnZWmtagEifCvNZ2y6shDQhf5zuafS
	LyZ0YCdfQ/XcfsS/8Y4Of0YKTXtgbNr79hHxmLf49x4JDkbFUhsNShK56kJK1N0q
	xQsT/z0ZW/yupp7GfWWUrPXvOp5glE96J+BQfq+AxjW2qtutKVIK/lfR4yxAq5bg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490acr40sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 06:10:03 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58A6A2Ah032422;
	Wed, 10 Sep 2025 06:10:02 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490acr40se-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 06:10:02 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58A4WUW7011447;
	Wed, 10 Sep 2025 06:10:01 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 490y9uf71c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 06:10:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58A69v3t18612682
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 06:09:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB1BB20043;
	Wed, 10 Sep 2025 06:09:57 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 76F3E20040;
	Wed, 10 Sep 2025 06:09:50 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.43.126.129])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 10 Sep 2025 06:09:50 +0000 (GMT)
Date: Wed, 10 Sep 2025 11:39:45 +0530
From: Saket Kumar Bhaskar <skb99@linux.ibm.com>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Jiri Olsa <olsajiri@gmail.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        adobriyan@gmail.com, shakeel.butt@linux.dev, hannes@cmpxchg.org,
        ak@linux.intel.com, osandov@osandov.com, song@kernel.org,
        hbathini@linux.ibm.com, donettom@linux.ibm.com
Subject: Re: [PATCH v2 bpf-next 10/10] selftests/bpf: add build ID tests
Message-ID: <aMEWKR2QPQtRMxp7@linux.ibm.com>
References: <20240724225210.545423-1-andrii@kernel.org>
 <20240724225210.545423-11-andrii@kernel.org>
 <ZqJBK4loBv030jj_@krava>
 <CAEf4BzZkGur_zPrPCEo6=asFGO1uBShvf1wwEoBhaKk-46ctAQ@mail.gmail.com>
 <ZqOWGvrrubXbVDlY@krava>
 <CAEf4BzbF+Q14fW-z2Fg02AEcFaF+dU53FVpDO_K_Tz-xQP_k5g@mail.gmail.com>
 <ZqaeOl8c_Jwl3ieR@krava>
 <CAEf4BzZtu_LWu82z9RFDf00a77uJuEpqYtuJWqz2zvm8jG3UWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzZtu_LWu82z9RFDf00a77uJuEpqYtuJWqz2zvm8jG3UWA@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BO7BRFxRISagf-vE1e_qHS5U7SvP3K-L
X-Authority-Analysis: v=2.4 cv=Mp1S63ae c=1 sm=1 tr=0 ts=68c1163b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=uwPLXEwYxtaKiSpnTQ4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 1vcBwzQx-Lxobh9DTBUO7xtOIsFultWW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAwMCBTYWx0ZWRfX8vTuDjO7nBji
 ImLUi2hxmQ6ENZ8z//9oO7w2cD67jxQWm/4NhRHY4JfEd5iKcfxPOJwPLlCLtUw0dmibR3VhYEk
 95FiFEOiK8sdkCnvXT7WRDCC5eyIeQ5KlgIguV2JTW/cnQJ5ReCKaF3xga0Kqn9MTPo+idr0bCY
 CJ4qS3l2ewXIFmVk8vmPJnCqv0EMFlH1fS/tqxD+UzzP2zfijuWLQ7NayAohP7GFXId4k8dAJIu
 xe67o49Bs/kH4qeXqQP8VCEddDz1jpLRgd1fVWMMR5OaxjO3zKLxUPboHFIZvpjvUTQj6gWyIbv
 UlGKNoHnbHgbAw+OH8uUsVu9QjMtK8JFZqQdenIQvzmvENJW2gSY2W/aBR6j3e2l1AHAg41rV61
 Z7vRhYNK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 clxscore=1011 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060000
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D5F41A000E
X-Stat-Signature: g3zsc3c5xxwq5xhmezy58wck53pbtdp7
X-HE-Tag: 1757484607-508466
X-HE-Meta: U2FsdGVkX1+MSiWwQr93jqPdVzHCqt2uz1ZMW5ZKmSuHLknnM9kFx+PKWbZfoTjmE2aUmVU6zK3fn97D3tXJWLDqFhIk+ByqFAKeA9FSJThtZSvx56r500gaxxY4ivVhQwHotmy2qE63FgqSW7Je0A8SKlyubkEMdLyUT/wuG7lu4nUgxyollp6ad2pjsL6EsRcZtq/8r9nbsDaAG+KUyy4RGbBSuWp7WVQIGCZ1+ojoJwt0+dZAbYuC7yxSLe8PNDPdpWwtk3ckqJiXxOSbyVku+7v6+PsBWKAspYVpQZPjhQA7m8XnfPtl+oD586oLH0iJ/jIEcUeG+CSOmdPeEse67iiRrpt5PbykA2dO90QwSu+I4ehnTsRYQvgIuV0jXDi/pVenbV68lXDg7lvNQCzxhfeQF7T0Ga9iIfl3KxcEsDqN1fFLidlikkSmWegwtZ19glNKhBEcIs852rw/3ENopnLIwYCM1DFL3hyyA+eaykv5r8iYK1cuhmz3ujWJdpD3Fng0xUbsWHEhS3mCdiZWWK6gL6Zf1ej6aj+3PR5IXmyuYOEWHPs6aJDdCV2R1uNr8JSSQhGBoz/Vf7IsbWdiud8JyPkIqYNo5H9QmcM0OgYXNH5GVsLlnkAdxLp7X84xLYxEwZ7c9kzxNd1AELo+Ty/qJO1ae5qtaxv6hIoN7yZHFWfcbzzavt11XLuVQEVpFhtPvx/vt6BjuTTKnFBvavZBl2VoV/2k40ZUGpunM5RJJLVgDXY+54mi2Qjmv4RRCtKXGteR/Ohun0VnOEPMjS+0XcEqAtiR4MVDyf8AY6HG3N/KzJiwcp6ivKrnIxG0/Fv2+jEqcwL22UxBBVZgTcnLVZJdpbBICsiOOF0ykZ+Zec+D56JfRxuzZFdHrztmaMdmQKaSIJVvBEm41Avd3QHU9F5K5svmXygcqRzULi9Ag2uzzdVyr3RpNgBHsMdjgt+bzRjRQ8mWeVi
 T1OgWCy/
 QE2fEqjBenXfXUESWe8v2muqUGZ/jH8VAXYSiMW6H9UTTN3ucdaYNvnFin+VfbHxOOs6mP3lpnns1OYF4kiH3yrZrNsHV54aRCjI1bkk2cpZHKDz4q2vTv2J9/OemN2RL/nqs61pNZ4lQNbyZiP3B3cf1R5Od2VJsgTmmYpx9ukqPsTXpiPjxzclqbdCshd0YBXIV3HXd+d0/kfSGsjQ7YI6r2HKnwxvMQa7PlrKBLEgl6muPdK1rn3hYI8RWiis38T/33kvMI1//Es6vbYu2KwZBbdl9k1zMOCQ9CxwjnwSFBvmI3P5gWXUuGXmc1+VYrqlkTLISTtCFoRQ0VDzOvwU1mfO8HMCWrO3zAD09YCM6U4qWecHdvUDhUZlJFickYGfkW27Uy+yHYRQteQxImIyjD/B5fYUuzYV06u+01xJk1ROFoe30U5iNlZsvPrhHc35OiY7g7qe88TI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 30, 2024 at 01:03:17PM -0700, Andrii Nakryiko wrote:
> On Sun, Jul 28, 2024 at 12:38 PM Jiri Olsa <olsajiri@gmail.com> wrote:
> >
> > On Fri, Jul 26, 2024 at 05:37:55PM -0700, Andrii Nakryiko wrote:
> > > On Fri, Jul 26, 2024 at 5:27 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> > > >
> > > > On Thu, Jul 25, 2024 at 01:03:55PM -0700, Andrii Nakryiko wrote:
> > > > > On Thu, Jul 25, 2024 at 5:12 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> > > > > >
> > > > > > On Wed, Jul 24, 2024 at 03:52:10PM -0700, Andrii Nakryiko wrote:
> > > > > > > Add a new set of tests validating behavior of capturing stack traces
> > > > > > > with build ID. We extend uprobe_multi target binary with ability to
> > > > > > > trigger uprobe (so that we can capture stack traces from it), but also
> > > > > > > we allow to force build ID data to be either resident or non-resident in
> > > > > > > memory (see also a comment about quirks of MADV_PAGEOUT).
> > > > > > >
> > > > > > > That way we can validate that in non-sleepable context we won't get
> > > > > > > build ID (as expected), but with sleepable uprobes we will get that
> > > > > > > build ID regardless of it being physically present in memory.
> > > > > > >
> > > > > > > Also, we add a small add-on linker script which reorders
> > > > > > > .note.gnu.build-id section and puts it after (big) .text section,
> > > > > > > putting build ID data outside of the very first page of ELF file. This
> > > > > > > will test all the relaxations we did in build ID parsing logic in kernel
> > > > > > > thanks to freader abstraction.
> > > > > > >
> > > > > > > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > > > > >
> > > > > > one of my bpf selftests runs showed:
> > > > > >
> > > > > > test_build_id:PASS:parse_build_id 0 nsec
> > > > > > subtest_nofault:PASS:skel_open 0 nsec
> > > > > > subtest_nofault:PASS:link 0 nsec
> > > > > > subtest_nofault:PASS:trigger_uprobe 0 nsec
> > > > > > subtest_nofault:PASS:res 0 nsec
> > > > > > subtest_nofault:FAIL:build_id_status unexpected build_id_status: actual 1 != expected 2
> > > > > > #42/1    build_id/nofault-paged-out:FAIL
> > > > > > #42/2    build_id/nofault-paged-in:OK
> > > > > > #42/3    build_id/sleepable:OK
> > > > > > #42      build_id:FAIL
> > > > > >
> > > > > > I could never reproduce again.. but I wonder the the page could sneak
> > > > > > in before the bpf program is hit and the buildid will get parsed?
> > > > > >
> > > > >
> > > > > Yes, and I just realized that I forgot to mark this test as serial. If
> > > > > there is parallel test that also runs uprobe_multi and that causes
> > > > > build_id page to be paged in into page cache, then this might succeed.
> > > > > So I need to mark the test itself serial.
> > > > >
> > > > > Another issue which I was debugging (and fixed) yesterday was that if
> > > > > the memory passed for MADV_PAGEOUT is not yet memory mapped into the
> > > > > current process, then it won't be really removed from the page cache.
> > > > > I avoid that by first paging it in, and then MADV_PAGEOUT.
> > > >
> > > > ok, I triggered that in serial run, so I probably hit this one
> > > >
> > >
> > > you did it with v2 of the patch set? I had this bug in v1, but v2
> > > should be fine, as far as I understand (due to unconditional
> > > madvise(addr, page_sz, MADV_POPULATE_READ); before madvise(addr,
> > > page_sz, MADV_PAGEOUT)). At least I haven't been able to reproduce
> > > that anymore and BPF CI is now happy as well.
> >
> > yes, it's with v2 and I can still see that.. but only for the first run of
> > the test after reboot.. so far I have no clue.. I can see the successful
> > page-out madvise (still not sure how much is that telling about the page
> > being paged out), and then the build id code sees the page just fine
> >
> > attaching my .config in case
> >
> 
> I wasn't able to repro this, sorry. It works very reliably for me with
> your or my config. Given it also seems to work reliably in BPF CI, I'm
> still inclined to add this tests, I think it's good to have that
> coverage.
> 
> I'll monitor, and if it becomes flaky, we'll need to reassess this, of course.
> 
Hi Andrii and Jirka,

I encountered this error on powerpc, which is happening quiet consistently:

# ./test_progs -t build_id/nofault-paged-out
serial_test_build_id:PASS:parse_build_id 0 nsec
subtest_nofault:PASS:skel_open 0 nsec
subtest_nofault:PASS:link 0 nsec
subtest_nofault:PASS:trigger_uprobe 0 nsec
subtest_nofault:PASS:res 0 nsec
subtest_nofault:FAIL:build_id_status unexpected build_id_status: actual 1 != expected 2
#46/1    build_id/nofault-paged-out:FAIL
#46      build_id:FAIL
#397     stacktrace_build_id:OK
#398     stacktrace_build_id_nmi:OK

I dumped vma mapping using pmap in trigger_uprobe function 
before/after MADV_POPULATE_READ and b/w MADV_POPULATE_READ 
and MADV_PAGEOUT, page residency using mincore() (as shown 
"Before uprobe: Page residency = ") and addr (as shown 
"Entered trigger_uprobe addr ->").

Here I am putting out 3 scenarios:

1. #./test_progs -t build_id/nofault-paged-out
Entered trigger_uprobe addr -> 0x105a0000
144992:   ./uprobe_multi uprobe-paged-out
Address           Kbytes     RSS   Dirty Mode  Mapping
0000000010000000    7744     704      64 r-x-- uprobe_multi
0000000010790000      64      64      64 r---- uprobe_multi
00000000107a0000      64      64      64 rw--- uprobe_multi
000001002bf90000     192      64      64 rw---   [ anon ]
00007fffb55d0000     832      64       0 r-x-- libzstd.so.1.5.5
00007fffb56a0000      64      64      64 r---- libzstd.so.1.5.5
00007fffb56b0000      64      64      64 rw--- libzstd.so.1.5.5
00007fffb56c0000    2304    1280       0 r-x-- libc.so.6
00007fffb5900000      64      64      64 r---- libc.so.6
00007fffb5910000      64      64      64 rw--- libc.so.6
00007fffb5920000     192      64       0 r-x-- libz.so.1.3.1.zlib-ng
00007fffb5950000      64      64      64 r---- libz.so.1.3.1.zlib-ng
00007fffb5960000      64      64      64 rw--- libz.so.1.3.1.zlib-ng
00007fffb5970000     192      64       0 r-x-- libelf-0.192.so
00007fffb59a0000      64      64      64 r---- libelf-0.192.so
00007fffb59b0000      64       0       0 rw---   [ anon ]
00007fffb59d0000     256       0       0 r----   [ anon ]
00007fffb5a10000      64      64       0 r-x--   [ anon ]
00007fffb5a20000     320     320       0 r-x-- ld64.so.2
00007fffb5a70000      64      64      64 r---- ld64.so.2
00007fffb5a80000      64      64      64 rw--- ld64.so.2
00007fffee7a0000     192      64      64 rw---   [ stack ]
---------------- ------- ------- ------- 
total kB           13056    3392     896
144992:   ./uprobe_multi uprobe-paged-out
Address           Kbytes     RSS   Dirty Mode  Mapping
0000000010000000    7744     704      64 r-x-- uprobe_multi
0000000010790000      64      64      64 r---- uprobe_multi
00000000107a0000      64      64      64 rw--- uprobe_multi
000001002bf90000     192      64      64 rw---   [ anon ]
00007fffb55d0000     832      64       0 r-x-- libzstd.so.1.5.5
00007fffb56a0000      64      64      64 r---- libzstd.so.1.5.5
00007fffb56b0000      64      64      64 rw--- libzstd.so.1.5.5
00007fffb56c0000    2304    1344       0 r-x-- libc.so.6
00007fffb5900000      64      64      64 r---- libc.so.6
00007fffb5910000      64      64      64 rw--- libc.so.6
00007fffb5920000     192      64       0 r-x-- libz.so.1.3.1.zlib-ng
00007fffb5950000      64      64      64 r---- libz.so.1.3.1.zlib-ng
00007fffb5960000      64      64      64 rw--- libz.so.1.3.1.zlib-ng
00007fffb5970000     192      64       0 r-x-- libelf-0.192.so
00007fffb59a0000      64      64      64 r---- libelf-0.192.so
00007fffb59b0000      64       0       0 rw---   [ anon ]
00007fffb59d0000     256       0       0 r----   [ anon ]
00007fffb5a10000      64      64       0 r-x--   [ anon ]
00007fffb5a20000     320     320       0 r-x-- ld64.so.2
00007fffb5a70000      64      64      64 r---- ld64.so.2
00007fffb5a80000      64      64      64 rw--- ld64.so.2
00007fffee7a0000     192      64      64 rw---   [ stack ]
---------------- ------- ------- ------- 
total kB           13056    3456     896
144992:   ./uprobe_multi uprobe-paged-out
Address           Kbytes     RSS   Dirty Mode  Mapping
0000000010000000    7744     704      64 r-x-- uprobe_multi
0000000010790000      64      64      64 r---- uprobe_multi
00000000107a0000      64      64      64 rw--- uprobe_multi
000001002bf90000     192      64      64 rw---   [ anon ]
00007fffb55d0000     832      64       0 r-x-- libzstd.so.1.5.5
00007fffb56a0000      64      64      64 r---- libzstd.so.1.5.5
00007fffb56b0000      64      64      64 rw--- libzstd.so.1.5.5
00007fffb56c0000    2304    1344       0 r-x-- libc.so.6
00007fffb5900000      64      64      64 r---- libc.so.6
00007fffb5910000      64      64      64 rw--- libc.so.6
00007fffb5920000     192      64       0 r-x-- libz.so.1.3.1.zlib-ng
00007fffb5950000      64      64      64 r---- libz.so.1.3.1.zlib-ng
00007fffb5960000      64      64      64 rw--- libz.so.1.3.1.zlib-ng
00007fffb5970000     192      64       0 r-x-- libelf-0.192.so
00007fffb59a0000      64      64      64 r---- libelf-0.192.so
00007fffb59b0000      64       0       0 rw---   [ anon ]
00007fffb59d0000     256       0       0 r----   [ anon ]
00007fffb5a10000      64      64       0 r-x--   [ anon ]
00007fffb5a20000     320     320       0 r-x-- ld64.so.2
00007fffb5a70000      64      64      64 r---- ld64.so.2
00007fffb5a80000      64      64      64 rw--- ld64.so.2
00007fffee7a0000     192      64      64 rw---   [ stack ]
---------------- ------- ------- ------- 
total kB           13056    3456     896
Before uprobe: Page residency = resident
After uprobe: Page residency = resident
serial_test_build_id:PASS:parse_build_id 0 nsec
subtest_nofault:PASS:skel_open 0 nsec
subtest_nofault:PASS:link 0 nsec
subtest_nofault:PASS:trigger_uprobe 0 nsec
subtest_nofault:PASS:res 0 nsec
subtest_nofault:FAIL:build_id_status unexpected build_id_status: actual 1 != expected 2
#46/1    build_id/nofault-paged-out:FAIL
#46      build_id:FAIL
#397     stacktrace_build_id:OK
#398     stacktrace_build_id_nmi:OK

All error logs:
serial_test_build_id:PASS:parse_build_id 0 nsec
subtest_nofault:PASS:skel_open 0 nsec
subtest_nofault:PASS:link 0 nsec
subtest_nofault:PASS:trigger_uprobe 0 nsec
subtest_nofault:PASS:res 0 nsec
subtest_nofault:FAIL:build_id_status unexpected build_id_status: actual 1 != expected 2
#46/1    build_id/nofault-paged-out:FAIL
#46      build_id:FAIL
Summary: 2/0 PASSED, 0 SKIPPED, 1 FAILED

Here it can be seen that RSS for vma containing addr (0x105a0000)
is not changing (remains 704) and the selftest fails.

2. When alignment in linker script is changed to 65536 (default 
   page size in powerpc is 64k):

git diff uprobe_multi.ld
diff --git a/tools/testing/selftests/bpf/uprobe_multi.ld b/tools/testing/selftests/bpf/uprobe_multi.ld
index a2e94828b..2063714b2 100644
--- a/tools/testing/selftests/bpf/uprobe_multi.ld
+++ b/tools/testing/selftests/bpf/uprobe_multi.ld
@@ -1,8 +1,8 @@
 SECTIONS
 {
-       . = ALIGN(4096);
+       . = ALIGN(65536);
        .note.gnu.build-id : { *(.note.gnu.build-id) }
-       . = ALIGN(4096);
+       . = ALIGN(65536);
 }
 INSERT AFTER .text;

#./test_progs -t build_id/nofault-paged-out -v
bpf_testmod.ko is already unloaded.
Loading bpf_testmod.ko...
Successfully loaded bpf_testmod.ko.
serial_test_build_id:PASS:parse_build_id 0 nsec
subtest_nofault:PASS:skel_open 0 nsec
subtest_nofault:PASS:link 0 nsec
Entered trigger_uprobe addr -> 0x105b0000
145238:   ./uprobe_multi uprobe-paged-out
Address           Kbytes     RSS   Dirty Mode  Mapping
0000000010000000    7872     768     768 r-x-- uprobe_multi
00000000107b0000      64      64      64 r---- uprobe_multi
00000000107c0000      64      64      64 rw--- uprobe_multi
000001003a6b0000     192      64      64 rw---   [ anon ]
00007fffa3eb0000     832      64       0 r-x-- libzstd.so.1.5.5
00007fffa3f80000      64      64      64 r---- libzstd.so.1.5.5
00007fffa3f90000      64      64      64 rw--- libzstd.so.1.5.5
00007fffa3fa0000    2304    1280       0 r-x-- libc.so.6
00007fffa41e0000      64      64      64 r---- libc.so.6
00007fffa41f0000      64      64      64 rw--- libc.so.6
00007fffa4200000     192      64       0 r-x-- libz.so.1.3.1.zlib-ng
00007fffa4230000      64      64      64 r---- libz.so.1.3.1.zlib-ng
00007fffa4240000      64      64      64 rw--- libz.so.1.3.1.zlib-ng
00007fffa4250000     192      64       0 r-x-- libelf-0.192.so
00007fffa4280000      64      64      64 r---- libelf-0.192.so
00007fffa4290000      64       0       0 rw---   [ anon ]
00007fffa42b0000     256       0       0 r----   [ anon ]
00007fffa42f0000      64      64       0 r-x--   [ anon ]
00007fffa4300000     320     320       0 r-x-- ld64.so.2
00007fffa4350000      64      64      64 r---- ld64.so.2
00007fffa4360000      64      64      64 rw--- ld64.so.2
00007fffc6880000     192      64      64 rw---   [ stack ]
---------------- ------- ------- ------- 
total kB           13184    3456    1600
145238:   ./uprobe_multi uprobe-paged-out
Address           Kbytes     RSS   Dirty Mode  Mapping
0000000010000000    7872     832     832 r-x-- uprobe_multi
00000000107b0000      64      64      64 r---- uprobe_multi
00000000107c0000      64      64      64 rw--- uprobe_multi
000001003a6b0000     192      64      64 rw---   [ anon ]
00007fffa3eb0000     832      64       0 r-x-- libzstd.so.1.5.5
00007fffa3f80000      64      64      64 r---- libzstd.so.1.5.5
00007fffa3f90000      64      64      64 rw--- libzstd.so.1.5.5
00007fffa3fa0000    2304    1344       0 r-x-- libc.so.6
00007fffa41e0000      64      64      64 r---- libc.so.6
00007fffa41f0000      64      64      64 rw--- libc.so.6
00007fffa4200000     192      64       0 r-x-- libz.so.1.3.1.zlib-ng
00007fffa4230000      64      64      64 r---- libz.so.1.3.1.zlib-ng
00007fffa4240000      64      64      64 rw--- libz.so.1.3.1.zlib-ng
00007fffa4250000     192      64       0 r-x-- libelf-0.192.so
00007fffa4280000      64      64      64 r---- libelf-0.192.so
00007fffa4290000      64       0       0 rw---   [ anon ]
00007fffa42b0000     256       0       0 r----   [ anon ]
00007fffa42f0000      64      64       0 r-x--   [ anon ]
00007fffa4300000     320     320       0 r-x-- ld64.so.2
00007fffa4350000      64      64      64 r---- ld64.so.2
00007fffa4360000      64      64      64 rw--- ld64.so.2
00007fffc6880000     192      64      64 rw---   [ stack ]
---------------- ------- ------- ------- 
total kB           13184    3584    1664
145238:   ./uprobe_multi uprobe-paged-out
Address           Kbytes     RSS   Dirty Mode  Mapping
0000000010000000    7872     768     768 r-x-- uprobe_multi
00000000107b0000      64      64      64 r---- uprobe_multi
00000000107c0000      64      64      64 rw--- uprobe_multi
000001003a6b0000     192      64      64 rw---   [ anon ]
00007fffa3eb0000     832      64       0 r-x-- libzstd.so.1.5.5
00007fffa3f80000      64      64      64 r---- libzstd.so.1.5.5
00007fffa3f90000      64      64      64 rw--- libzstd.so.1.5.5
00007fffa3fa0000    2304    1344       0 r-x-- libc.so.6
00007fffa41e0000      64      64      64 r---- libc.so.6
00007fffa41f0000      64      64      64 rw--- libc.so.6
00007fffa4200000     192      64       0 r-x-- libz.so.1.3.1.zlib-ng
00007fffa4230000      64      64      64 r---- libz.so.1.3.1.zlib-ng
00007fffa4240000      64      64      64 rw--- libz.so.1.3.1.zlib-ng
00007fffa4250000     192      64       0 r-x-- libelf-0.192.so
00007fffa4280000      64      64      64 r---- libelf-0.192.so
00007fffa4290000      64       0       0 rw---   [ anon ]
00007fffa42b0000     256       0       0 r----   [ anon ]
00007fffa42f0000      64      64       0 r-x--   [ anon ]
00007fffa4300000     320     320       0 r-x-- ld64.so.2
00007fffa4350000      64      64      64 r---- ld64.so.2
00007fffa4360000      64      64      64 rw--- ld64.so.2
00007fffc6880000     192      64      64 rw---   [ stack ]
---------------- ------- ------- ------- 
total kB           13184    3520    1600
Before uprobe: Page residency = resident
After uprobe: Page residency = resident
subtest_nofault:PASS:trigger_uprobe 0 nsec
subtest_nofault:PASS:res 0 nsec
FRAME #00: BUILD ID = 4f635d1d48e4f2b67b62a9a07285668cdc85fb18 OFFSET = 2c3f1c
FRAME #01: BUILD ID = 4f635d1d48e4f2b67b62a9a07285668cdc85fb18 OFFSET = 5a0824
FRAME #02: BUILD ID = 4f635d1d48e4f2b67b62a9a07285668cdc85fb18 OFFSET = 5a0994
FRAME #03: BUILD ID = 09139ae1e5cbaf5c598222698e5b8e2e250260b1 OFFSET = 2aba4
FRAME #04: BUILD ID = 09139ae1e5cbaf5c598222698e5b8e2e250260b1 OFFSET = 2adec
FRAME #05: BUILD ID = 4f635d1d48e4f2b67b62a9a07285668cdc85fb18 OFFSET = fffffffff0000000
subtest_nofault:FAIL:build_id_status unexpected build_id_status: actual 1 != expected 2
#46/1    build_id/nofault-paged-out:FAIL
#46      build_id:FAIL

Here RSS changes(768 -> 832 -> 768) but looks like page is still 
not getting evicted (as shown "Before uprobe: Page residency = resident") 
after MADV_PAGEOUT and the selftest fails.

3. But in the very next run page is evicted and selftest passes:

#./test_progs -t build_id/nofault-paged-out
Entered trigger_uprobe addr -> 0x105b0000
145256:   ./uprobe_multi uprobe-paged-out
Address           Kbytes     RSS   Dirty Mode  Mapping
0000000010000000    7872     768      64 r-x-- uprobe_multi
00000000107b0000      64      64      64 r---- uprobe_multi
00000000107c0000      64      64      64 rw--- uprobe_multi
00000100317b0000     192      64      64 rw---   [ anon ]
00007fffa5cd0000     832      64       0 r-x-- libzstd.so.1.5.5
00007fffa5da0000      64      64      64 r---- libzstd.so.1.5.5
00007fffa5db0000      64      64      64 rw--- libzstd.so.1.5.5
00007fffa5dc0000    2304    1280       0 r-x-- libc.so.6
00007fffa6000000      64      64      64 r---- libc.so.6
00007fffa6010000      64      64      64 rw--- libc.so.6
00007fffa6020000     192      64       0 r-x-- libz.so.1.3.1.zlib-ng
00007fffa6050000      64      64      64 r---- libz.so.1.3.1.zlib-ng
00007fffa6060000      64      64      64 rw--- libz.so.1.3.1.zlib-ng
00007fffa6070000     192      64       0 r-x-- libelf-0.192.so
00007fffa60a0000      64      64      64 r---- libelf-0.192.so
00007fffa60b0000      64       0       0 rw---   [ anon ]
00007fffa60d0000     256       0       0 r----   [ anon ]
00007fffa6110000      64      64       0 r-x--   [ anon ]
00007fffa6120000     320     320       0 r-x-- ld64.so.2
00007fffa6170000      64      64      64 r---- ld64.so.2
00007fffa6180000      64      64      64 rw--- ld64.so.2
00007ffff1890000     192      64      64 rw---   [ stack ]
---------------- ------- ------- ------- 
total kB           13184    3456     896
145256:   ./uprobe_multi uprobe-paged-out
Address           Kbytes     RSS   Dirty Mode  Mapping
0000000010000000    7872     832      64 r-x-- uprobe_multi
00000000107b0000      64      64      64 r---- uprobe_multi
00000000107c0000      64      64      64 rw--- uprobe_multi
00000100317b0000     192      64      64 rw---   [ anon ]
00007fffa5cd0000     832      64       0 r-x-- libzstd.so.1.5.5
00007fffa5da0000      64      64      64 r---- libzstd.so.1.5.5
00007fffa5db0000      64      64      64 rw--- libzstd.so.1.5.5
00007fffa5dc0000    2304    1344       0 r-x-- libc.so.6
00007fffa6000000      64      64      64 r---- libc.so.6
00007fffa6010000      64      64      64 rw--- libc.so.6
00007fffa6020000     192      64       0 r-x-- libz.so.1.3.1.zlib-ng
00007fffa6050000      64      64      64 r---- libz.so.1.3.1.zlib-ng
00007fffa6060000      64      64      64 rw--- libz.so.1.3.1.zlib-ng
00007fffa6070000     192      64       0 r-x-- libelf-0.192.so
00007fffa60a0000      64      64      64 r---- libelf-0.192.so
00007fffa60b0000      64       0       0 rw---   [ anon ]
00007fffa60d0000     256       0       0 r----   [ anon ]
00007fffa6110000      64      64       0 r-x--   [ anon ]
00007fffa6120000     320     320       0 r-x-- ld64.so.2
00007fffa6170000      64      64      64 r---- ld64.so.2
00007fffa6180000      64      64      64 rw--- ld64.so.2
00007ffff1890000     192      64      64 rw---   [ stack ]
---------------- ------- ------- ------- 
total kB           13184    3584     896
145256:   ./uprobe_multi uprobe-paged-out
Address           Kbytes     RSS   Dirty Mode  Mapping
0000000010000000    7872     768      64 r-x-- uprobe_multi
00000000107b0000      64      64      64 r---- uprobe_multi
00000000107c0000      64      64      64 rw--- uprobe_multi
00000100317b0000     192      64      64 rw---   [ anon ]
00007fffa5cd0000     832      64       0 r-x-- libzstd.so.1.5.5
00007fffa5da0000      64      64      64 r---- libzstd.so.1.5.5
00007fffa5db0000      64      64      64 rw--- libzstd.so.1.5.5
00007fffa5dc0000    2304    1344       0 r-x-- libc.so.6
00007fffa6000000      64      64      64 r---- libc.so.6
00007fffa6010000      64      64      64 rw--- libc.so.6
00007fffa6020000     192      64       0 r-x-- libz.so.1.3.1.zlib-ng
00007fffa6050000      64      64      64 r---- libz.so.1.3.1.zlib-ng
00007fffa6060000      64      64      64 rw--- libz.so.1.3.1.zlib-ng
00007fffa6070000     192      64       0 r-x-- libelf-0.192.so
00007fffa60a0000      64      64      64 r---- libelf-0.192.so
00007fffa60b0000      64       0       0 rw---   [ anon ]
00007fffa60d0000     256       0       0 r----   [ anon ]
00007fffa6110000      64      64       0 r-x--   [ anon ]
00007fffa6120000     320     320       0 r-x-- ld64.so.2
00007fffa6170000      64      64      64 r---- ld64.so.2
00007fffa6180000      64      64      64 rw--- ld64.so.2
00007ffff1890000     192      64      64 rw---   [ stack ]
---------------- ------- ------- ------- 
total kB           13184    3520     896
Before uprobe: Page residency = paged out
After uprobe: Page residency = paged out
#46/1    build_id/nofault-paged-out:OK
#46      build_id:OK
#397     stacktrace_build_id:OK
#398     stacktrace_build_id_nmi:OK
Summary: 3/1 PASSED, 0 SKIPPED, 0 FAILED

Here it can be seen that page is evicted (as shown 
"Before uprobe: Page residency = paged out").

Although the selftest occasionally passes, its behavior 
remains flaky and unreliable across runs. But introducing 
a sleep before/after both MADV_POPULATE_READ and MADV_PAGEOUT 
tends to improve the consistency with which the selftest passes.

Your valuable suggestions or thoughts on how best to address/debug
this further would be helpful.

Regards,
Saket
> > jirka
> >
> >
> > ----
> > #
> > # Automatically generated file; DO NOT EDIT.
> > # Linux/x86 6.10.0 Kernel Configuration
> > #
> 
> [...]
> 

