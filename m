Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7692ACD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7053F6B00EF; Wed, 20 May 2026 11:40:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68BE96B00F0; Wed, 20 May 2026 11:40:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 505D86B00F1; Wed, 20 May 2026 11:40:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 302D96B00EF
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:40:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3F08A03A8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:51 +0000 (UTC)
X-FDA: 84788211102.03.F6A3400
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf29.hostedemail.com (Postfix) with ESMTP id 372F6120003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779291649; a=rsa-sha256;
	cv=pass;
	b=lI9t25Bl5kc4laDKbeEfB1+05VLV7bIoXUvl75/74QpK28SXOCDpLygW4wI14mRF4gxSQ1
	eN3jASUIKOSh0wtfsgDaPvaFk+W0LoXQ2Ts7lXKbm/aj0Z1lxmXFE3Dpan0S06THf0GTe0
	IqR0e6UMJwyWAcYUz9EGE8YU0BWaeIk=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779291649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yu9YEn7cMwbNDaErbgC10vKCiE7zCGLCJox7Eg4hlxw=;
	b=oX894UaTpQkJU1IcpqzknkS9JnBTkf8cCvbzmXTxe8u/ZzCkfnr6SMJ53xgX5o4+aqVvJ5
	rquUNLlO+H3pqy1OiIa0YrZL0pzmnQ8omrCNHGTtSxFoHcEet9X5f5nQsRVhRiqw4uH6zK
	mLjGYNdxh61ZKnQucbFj7bkpgNJbJLU=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CBDA88CFCC
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:48 +0000 (UTC)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B53140210
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:48 +0000 (UTC)
X-FDA: 84788210976.02.97CE7DA
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1FB4F180012
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:45 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779291646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yu9YEn7cMwbNDaErbgC10vKCiE7zCGLCJox7Eg4hlxw=;
	b=DxEdELQK1CD/TKDgZ+Ihd706xPfsZSqH0t6623jSSoMGXFV0xAHUT5TgPOUmEOyLC3THqi
	6aGQkxQ3tqn1z9f5JNLueIbwdGkmBgTWGAsc6/V6JDB/wQIrMjS02zvbQrPBgwK3hOjn40
	ZkqdrzRR8AhapZfbr5beyzaBmlIsflQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779291646; a=rsa-sha256;
	cv=none;
	b=QUVR9PqP99u17jcJpEQupcdDxaGv3GA/gBP/8ibtdeVWhPNeapiAgFiO/qvTxu+vNPK16i
	NYa4SHJ8M3fI2bWDqDpYkYdYPporVWsgcdhuHtuVYH5WuAFrrj/VLuojBmP/CttrrldwfS
	C5Wv5N3b9si1pKpPTq3L2gpvJ3TbunY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=KYLcYfxc;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf06.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KDqNrc4104744;
	Wed, 20 May 2026 15:40:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=yu9YEn7cMwbNDaErb
	gC10vKCiE7zCGLCJox7Eg4hlxw=; b=KYLcYfxcO3nqtmX//Y6eVNl3yMEZ1eXSr
	qDi0jZT9nG6g4n4zLeFP8hjIZoO1t+JHunUUOfMQ111LIxAN1Vc618Zt5OkINVMW
	fquemVt2MlIJiyI9GF9EOXrB6X7zf/tWJ5Po7vbgdsZ75mHD+nsiMMSi/SN3il5E
	HQkhJj+Kk3DLo/enrA90VBDyEK4wX7wX0Bqg/TPaGPazk8wkPemzqaQfoF4tkeES
	CKOppDxk+iSNYneBT7iylzPqnWkJlREk5jGyrAp5EMe6u9z8dKklXugew5RADaaX
	omTG1hzv6Dm5f8nE+X0+Vli6eitpWTxZpPBQiVZbfBWHCqCSGQkJA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h9y2vn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:19 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64KFd9on008388;
	Wed, 20 May 2026 15:40:18 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e739w03bb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:18 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64KFeElH44237218
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 15:40:15 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D1F1420040;
	Wed, 20 May 2026 15:40:14 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 52D0B2004E;
	Wed, 20 May 2026 15:40:14 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 May 2026 15:40:14 +0000 (GMT)
From: Jens Remus <jremus@linux.ibm.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        x86@kernel.org, Steven Rostedt <rostedt@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <ibhagatgnu@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dylan Hatch <dylanbhatch@google.com>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Kees Cook <kees@kernel.org>, Sam James <sam@gentoo.org>
Cc: Jens Remus <jremus@linux.ibm.com>, bpf@vger.kernel.org, linux-mm@kvack.org,
        Namhyung Kim <namhyung@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Florian Weimer <fweimer@redhat.com>,
        "Carlos O'Donell" <codonell@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v15 13/20] unwind_user: Enable archs that pass RA in a register
Date: Wed, 20 May 2026 17:39:57 +0200
Message-ID: <20260520154004.3845823-14-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260520154004.3845823-1-jremus@linux.ibm.com>
References: <20260520154004.3845823-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDE1MSBTYWx0ZWRfX+ZJ+3qEpulp9
 BPO8NYhXZzH0Ny3YLbhLv8U9s/DDBqHpZ1G2HzppTO2GEySYMNtom0KBol1DYSgNmEEJ/9TZIzE
 t/MKr0wyZVdq5HZD4HgwRj6irE66q0X9OOlPIb0J71I9MUJn/s6KXssb9DE0nbg4KrkRqZ5dTnl
 Qvop6V9bEx33jm1DRKnjeJCkQkBPkm32hdmY4+3XIrTHS5r5BcVVh4jx6jt2zeEIZvQUE9gzslX
 OVZLTyVrlksaoecaS23DoE5V7E3D9qRdgfEdIeed5cwMm6pebyZcOxaCE2Nx2GXGNT5oYUW3ZyY
 B6tR/EKDHvLQc3QmOI+tS/3qJFEsz6e9Vt30QJZkFZA/kRtiJAwLfnS8wji6l1b9nN+1RD7rYEV
 EVctAemmYp6SZb9GY1LyoGMNUdtZE9ZB//Kz6m5UTpHITxeGSEI6xE0jIP/Cxybj3GNAJYeiWq6
 YwGyLK/iMXwireapCRA==
X-Authority-Analysis: v=2.4 cv=BNuDalQG c=1 sm=1 tr=0 ts=6a0dd5e4 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=c48flIb4C_QYATK_dV0A:9
X-Proofpoint-ORIG-GUID: dtAPcJIj4_HKjvCpdMenCV1ryW5p_1td
X-Proofpoint-GUID: CcKY7XMm1KJQsZb35JSoWVF1glEn73FC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200151
X-HE-Meta: U2FsdGVkX19jFacrNlU5I3yl175yxMAZAxb9D2TMsWFIKQQpKXOp0OfRnNSXyT4Jz9KCfGfixy6Ai13E6psdnHQsZTurz3gGTYfJyeYfA0K0NMc7Z0t1UVywDPGaD0QZHbFTI2I/uYik1BAoRmgvdDzsOMs6rV2/Dw5YYA8Vhd30elVX6yF+bxqCf9ByRm46/v3cb3k/brH80S61582cy0Nj0NoCnzF0VAQpozmD2z7oS597Nmrc+N0AiEXyzYCCS2KkxkBSkl2ZkSUIMP1VyY0pb8waf0wfXsORYbTGJf2faiuVtPf/XgN5wSGZDZVWvmOiLJOLnd4qqI8P0mw5laT+shJeP14I7KV1BSj2onzMcEvVSHye/yeLFg6XZ16AwIrvdOrcuoXGNSqliHQMtoHmIxCFtfKWN8O2v6IX4Z1z9ZY0utotRLLJ60XupqAF3FBZu9kWolPzthgcSjpyhhzO10BKqwvVALTPHD+/34XVBCILMunJuKCL1TryuY7Bf/iG8PSOMbwYE2OKhEGaoAqzr78Kt96SKkMth4ZUgUyJh2NeJjJ6B1x3I0bz5uWTi6vsW5TJXowC8MDSWUzqNdON3MyWo2DsBhzlQ+/WzbLnl9RycztmhuIAP6+jvd+Sy/6yb5dTy2JGpDo1gbTmh3jy8aJ38gbLhRMPW0cLB63yko3hMIVDaaQdNfzpPxXbThbjA7BbGWf/12q3wEOR6naobO99gM6pwsy4xxq3R1kVp6Nzfzh8ahSsUO0EXpTMY16exFEXvMfVibvyaJO0pH3B9Gqd0f6hY3KbEk6VGohGe4DvLR4RQP4S/gjzEMsUv9q+NxbPWbqWH0MiliqY+s7E84bh1DrDMrVkBwrcRONWJF3f9804Jr1MYyGgM0vuBeFqIfLgsu0BD7nbdyv9XExpMlLO7diTx/vkabXaSz1XBr7cRBb71qtM/7FkHGsw/gyZB8qgQnJgZYa3fnE
 S/YM6pRk
 Awos6/gvxmQq8eh2k88HsZ3zoyvUK4tm/gFC5JetlC/L367EcUwyD9tDJq/3QrAXxMLU9ilsLZ8InEGLzefvl2+eEGTmUvnM/TWiIs2lm1ce8L86oZSK+aedW/X+9D58G/qt8UVVpEHHbIv8lw8CFKhDd/xbIlPfUc1cNosICCmCN5q9DHcrCdz06ycB6ZLum+4hcCCC104oiTbHPukIj85QvLYsL1yxTya8eakdxQgpzKFS2LBu8VwGpQ/PtP3cQCUWUhixrr9Oq4ic=
X-Rspamd-Server: rspam07
X-Stat-Signature: 6ddsdcp4d1tqu8osky7ryrpptoiy5rhi
X-Rspam-User: 
X-Rspamd-Queue-Id: 372F6120003
X-HE-Tag-Orig: 1779291645-12581
X-HE-Tag: 1779291649-935379
X-HE-Meta: U2FsdGVkX19I7aMy9xpe+EdV5NaSc+MPn1LM56GXKl0wqae72oSz5Hwzz9CsfblazXYjJEyqyrnyUeHzRAXBKqTP1gxXOXO+eg2bA8Twyy/YRy+6wfNey8EPKBezCl6arp5uSUPUxW29t2ICzROOAgUSGVLimRiAe7SvSCWLr8piKo2dNuHyXCwYLGthCW6hmFzN7DcLrmAMG9LK04q4hPI3Dy+MxJRAC0pDW0ej8HAk6EHAcyng9Ult8mvOWbAVbVCsJMC6O/dtl0UEktcshAmVKPmwoTZC5DL+NxUOVc2rzrQkCiyGtfBkX4F3cByQKpdq2eCwYlA5PWYSlD4FOnY0yTw/jU2c3JUFgqJhbfAMxhU1YAVy8po1vKhXAGG1JKBj84syMCoL4WqVrIk/k2ShVGWwGFHbbH8xApWR5oC0wKk9cEljT43FjOIdeTpDI2nsa6+eHWjqT3AJE0pWQUTQe0LlgSpfaLX5bE31AwF9s02QRPpl8UdJX+W6OeNW+NDRzTMAuvh1OFJC8WwnyBHmrM8HVPosH1shHlYl8uEhnqVQQzH5tiPhpAi5m/VW4Aut8O/I8kDA8bRHejdyN0f/iU91fiX0rmAZu4Izc2LaoQoYjpBM8JJFNhhoMJ/VpmbCFoULNAYro6syP6rjkaE4Dk3IG/lgRom6apGNeSnFqVTBQuuJRIIUpf7xMhjV+Q8ZSHyub4MQm5CNMuPQifF3c2iOlG6XVlELosaXIIMSn/sjK57MbjoQ3jO3Syt59FlUEsTxTnOHpyllYEw9hV0LL2OKp9cW0Rr795IdWCRJd2f0JNBjdwpdaYdAwgRYnPrTr1dhgocSI8ontajlOWDD5BMekuDYg6FitHJjOUOrNL1Ua8RqPpOoMEUEhvZ/QjcLhtQThZ8aUP9C53UVMfFQiA/gbM1HAEaK7hOStowlIjvlSez0imeT0MyBaggqYOmIVVsnzbUq7Gu114m
 YhOe8rw9
 RPLNnYdcN9vMhlj8NN9cdF1P62KOYVEPUypOJeC+gNyNupJ7s/FZYz1dEd6xsUyeA8P0MRR/MpQrYXxWOFWuIbGeU5UwvzaD8oLrbZC1te0y8QFBT4l2TJOqTgh8HQJFKrNWy1tFjYHs7+n4V5yeWCVtZuIAeFL1Xmu1taS8LVHYsKT5XRGC2Wl4dCI+66HfWOzpZyxHeCGjgnuMbcDUoO+9L+BeUIarIooN0llqRStQZKXE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Not all architectures/ABIs pass the return address (RA) on the stack on
function entry, like x86-64 does due to its CALL instruction pushing
the RA onto the stack.  Architectures/ABIs, such as s390, also do not
require the RA to be saved on the stack in the function prologue.  In
particular, the RA may never be saved to the stack at all, such as in
leaf functions.  Unwinding must therefore not assume the presence of a
RA saved on stack for the topmost frame.

Treat a RA offset from CFA of zero as indication that the RA is not
saved (on the stack).  For the topmost frame treat it as indication that
the RA is in the link/RA register, such as on arm64 and s390, and obtain
it from there.  For non-topmost frames treat it as error, as the RA must
be saved.

Additionally allow the SP to be unchanged in the topmost frame, for
architectures where SP at function entry == SP at call site, such as
arm64 and s390.

Note that treating a RA offset from CFA of zero as indication that
the RA is not saved on the stack additionally allows for architectures,
such as s390, where the frame pointer (FP) may be saved without the RA
being saved as well.  Provided that such architectures represent this
in SFrame by encoding the "missing" RA offset using a padding RA offset
with a value of zero.

Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v15:
    - Define pr_fmt().
    - unwind_user_get_ra_reg(): Use pr_debug_once() instead of
      WARN_ON_ONCE() to prevent user-triggered warning/panic. (Sashiko AI)
    - Reworded commit message. (Indu)

 include/linux/unwind_user.h | 10 ++++++++++
 kernel/unwind/sframe.c      |  6 ++----
 kernel/unwind/user.c        | 20 ++++++++++++++++----
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/include/linux/unwind_user.h b/include/linux/unwind_user.h
index 64618618febd..7bf58f23aa64 100644
--- a/include/linux/unwind_user.h
+++ b/include/linux/unwind_user.h
@@ -23,6 +23,16 @@ static inline bool unwind_user_at_function_start(struct pt_regs *regs)
 #define unwind_user_at_function_start unwind_user_at_function_start
 #endif
 
+#ifndef unwind_user_get_ra_reg
+static inline int unwind_user_get_ra_reg(unsigned long *val)
+{
+	pr_debug_once("%s (%d): unwind_user_get_ra_reg() not implemented\n",
+		      current->comm, current->pid);
+	return -EINVAL;
+}
+#define unwind_user_get_ra_reg unwind_user_get_ra_reg
+#endif
+
 int unwind_user(struct unwind_stacktrace *trace, unsigned int max_entries);
 
 #endif /* _LINUX_UNWIND_USER_H */
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index b5f984fb2df2..4af533e9f980 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -255,10 +255,8 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	dataword_count--;
 
 	ra_off = sec->ra_off;
-	if (!ra_off) {
-		if (!dataword_count--)
-			return -EINVAL;
-
+	if (!ra_off && dataword_count) {
+		dataword_count--;
 		UNSAFE_GET_USER_INC(ra_off, cur, dataword_size, Efault);
 	}
 
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index fdb1001e3750..afa7c6f6d9b4 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -2,6 +2,9 @@
 /*
 * Generic interfaces for unwinding user space
 */
+
+#define pr_fmt(fmt)	"unwind_user: " fmt
+
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
@@ -48,8 +51,12 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 	}
 	cfa += frame->cfa_off;
 
-	/* Make sure that stack is not going in wrong direction */
-	if (cfa <= state->sp)
+	/*
+	 * Make sure that stack is not going in wrong direction.  Allow SP
+	 * to be unchanged for the topmost frame, by subtracting topmost,
+	 * which is either 0 or 1.
+	 */
+	if (cfa <= state->sp - state->topmost)
 		return -EINVAL;
 
 	/* Make sure that the address is word aligned */
@@ -57,8 +64,13 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 		return -EINVAL;
 
 	/* Get the Return Address (RA) */
-	if (get_user_word(&ra, cfa, frame->ra_off, state->ws))
-		return -EINVAL;
+	if (frame->ra_off) {
+		if (get_user_word(&ra, cfa, frame->ra_off, state->ws))
+			return -EINVAL;
+	} else {
+		if (!state->topmost || unwind_user_get_ra_reg(&ra))
+			return -EINVAL;
+	}
 
 	/* Get the Frame Pointer (FP) */
 	if (frame->fp_off && get_user_word(&fp, cfa, frame->fp_off, state->ws))
-- 
2.51.0



