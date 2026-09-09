Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A037DC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E2EA6B00AC; Wed,  9 Sep 2026 12:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 892FE6B00AD; Wed,  9 Sep 2026 12:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7823C6B00AE; Wed,  9 Sep 2026 12:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 346946B00AC
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:05:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8FDD314026E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:05:41 +0000 (UTC)
X-FDA: 85194699282.19.98A4C4B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf29.hostedemail.com (Postfix) with ESMTP id EB3AD120008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:05:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QeKYMNfz;
	spf=pass (imf29.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788969939;
	b=s+Y8rhQ1y7oVqgO/ZGkwNpz0NghSU9IKIiguwHMtoZFjEkZE/1wOzLpkmO7w0/OF/a7rN8
	Sr6HQ2EtxmW2qhe/x8kzarSs+9FLtZ87zHqB9DaD/pA0LwJPHRv6dRDm00iswKhYtcL0Ku
	cFcCRjzIO8FPFQIpFaEOrRkkRazKgwo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QeKYMNfz;
	spf=pass (imf29.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788969939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLPrxQOiJeWhEZABOiyLZGxoksizk3WYYJKqJ5KGjx0=;
	b=SKFpd0dfiDQEyRFTU3X5dVV2TApbJR9LOIXoWKqtkePqf66MhsY6O4SDPsFludVtxoH3Yi
	lWLwJbIyo6YEh2TWi5fR1wrMOaEkgMNjfnJTaet1hBtEgyAMDCx6LR9nKFSYHSeuqLeL5F
	7KidamEDy4ZkHO8AXrfXUJyu/HMgaNM=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689B1vdp3818304;
	Wed, 9 Sep 2026 16:05:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WLPrxQ
	OiJeWhEZABOiyLZGxoksizk3WYYJKqJ5KGjx0=; b=QeKYMNfzkxOM7qamVkCfaK
	bPNKHMdTw9owvz4UmvvucOM9RLBi12rGjir7rYstrd8TvxVY+EGBK/1z3REaIE/7
	79sBYF/sC0gxOqMEFlD1WS6WEIXZz4j0Ka9oAEJsVodE82uWkZbYLhDQ4qxBtGcX
	ftHccE1DRPVN6Tvpb91yaK+RloLexpy2ODuN9tZmsG8/ECnAkWG+ylGOkKIilpSk
	/ZZihgaTyDC5NeNocYLmS54zAI+AbS8K1CCCldPpjXOqh+r6xW2sWZlx3C43Lv/y
	QOklcIUrZGvtcdlmHgUzcs9LeYj0+l2Kwm9FVn+DOuLtNBDESlSUmwrVmt/b9G4A
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbf4700y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 16:05:30 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 689FuEh0021645;
	Wed, 9 Sep 2026 16:05:29 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ggymgk1rb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 16:05:29 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 689G5Rtb51446168
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Sep 2026 16:05:27 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5996220040;
	Wed,  9 Sep 2026 16:05:27 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 619B32004E;
	Wed,  9 Sep 2026 16:05:17 +0000 (GMT)
Received: from [9.61.255.18] (unknown [9.61.255.18])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  9 Sep 2026 16:05:16 +0000 (GMT)
Message-ID: <b651dfa8-1d00-4e58-a6d7-49fed218e12e@linux.ibm.com>
Date: Wed, 9 Sep 2026 21:35:13 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 18/22] selftests/coredump: test COREDUMP_RECORDS and
 COREDUMP_SPARSE
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>,
        Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Omar Sandoval <osandov@osandov.com>, Jacob Lalonde <jalalonde@fb.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
 <20260820-work-coredump-sparse-v2-18-ba32dd718c51@kernel.org>
Content-Language: en-US
From: R Nageswara Sastry <rnsastry@linux.ibm.com>
In-Reply-To: <20260820-work-coredump-sparse-v2-18-ba32dd718c51@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: v-vG2yeWVHIQ_wW1LJ8i4ElP23HHTRg2
X-Proofpoint-GUID: ZZNE0Rar6DeCVr0uPYtK8yvy-NyWJf0j
X-Authority-Analysis: v=2.4 cv=DbEnbPtW c=1 sm=1 tr=0 ts=6aa183ca cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=oSmbnvTJNHc5gxUO8T4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE3OCBTYWx0ZWRfX1dfxC3zJ0Cpw
 DcnNc62KeUBDArAxQJ4RJXJp73DAae3sAQZ9PiKPPOzUdsrGR8+ZOMPKUNk8ISPUS9LoQ7GTp86
 pkt9tFF6RwNrnGQYO/R5+HQoBIpCmO/g5mqDSH2c/quXFrbxJ8ew/zMtgvHFs5LCTRaTfkBLDA3
 6sze0rsvu5USht6z5NNq6YTwLiKMrplbBXh0SGbtBQv1JbJ0ZcKZTDu3WdkPYGnFQnonEDp881a
 4Kqeg23b53kQYNBMhT/QQmQ6M10bLu/Ew42WMwNtygBXFEVVY+EvHSnRgTWEE9GZBUsyUSV58yW
 hOyE3iFnXwp39u96359hhpg95uuKPoH3ZEYIbxZH7+qQqo6vz29n/FWV8sVlI2Q9Z5p6rzTY93i
 RlD+Fit/eLTiTXtzAdfVDI4MH/BNN5V/L75IE0Qos/sAcbFASg2xeGBzr6Ta6aFcxbxQdCEhRx6
 S/0r99CrBdKxOKdXo+Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE3OCBTYWx0ZWRfX3PFZwQ62LhF9
 J9UzwB0qUJpriY5fHDn6AKdAinh0W5tx1cl1pDm0FDEqg2GhlhWN9wRwHkrF9PiDrRjOu8tcbBB
 UI1eIg/XAwaEzAXfnBJFurlS7Z/WGBg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0 spamscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090178
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EB3AD120008
X-Stat-Signature: zua8moi1mfifwhbdufi7o1summgmhs3j
X-Rspam-User: 
X-HE-Tag: 1788969938-549769
X-HE-Meta: U2FsdGVkX18t16hYIYk8jqjCQZKvmlXRF6P0Bt4kBdhq9s3kw3QdHBsV70DG5+3KROR1JTELuwQ/MXEOdCwaBH9b1VTXhg3lzXkgx5LKj/lRiLjfnUlYdOjltPomHZNbMwlBuwpTUldnKrJxz5hr4FvKs3TTxNsiS730zIo96fGwyDzno6apzEndYnlWUddmAZtsZi3ejvjlMqtjSh5aNWC/KNOo04bwnmMBDz7VMPoNqAIHpytTQtltML7A7mDyseZlMFFK9t5CP/Xn0ONMXrjdBRM5WwKd0Js1D7X/pyRodnHIPRB9paux05IGI3FwNulGvM2XTm4oOxsenG21zuF0PC/C+FAKqAPh8rrMPcXohU4vn7HNJa1TdIfPbsJHC1dqs3RdOincFsckbjIwdo5Usf5RH36g3dljxOfx2SPmdklDDewqVH3TSHWSLw0fq3tAQMl9qVEVokDMI8da8HsjWxuQ3IQzl9xEkHEG4mliUsccoMHEloViFl8IS1UjK6sKMuKfaHhlZWyCEsoAogjLvtgw0n+fZT2uxm8soKvhuYxAxPYnLDoqVaU/z60GS21+vruUKk2yfFtvU+YthtPohtJjicLhkLuTzYxzSLqMtR21sL9vxCiAGMT7PQ8qQxcVCmY3PZ12ZWWlyGzHaO45p8T0xpy6AiL5wsaXOEPtxyvVCg6pxlNnvsm8JdQKt/iNhV31CHHxbA3xnAy0GysJdVZE1zb4vvyKVwRiOD/UHTc+WI/Rlwu1Ycv4W7uGDt0/jRzSin7u51VXCuX257cXBUazrCfXaHolamdO7dXcTScz4s8hkv3LjieaGYddXjHd+wXPxaZy0Rr2WysmnbTDQqVcmC4/V2gzUMXS+QZfcfEVMM1nLQkbpvieNoIopQOBVsH2nh9/Ous0B4RcYxFZdy//H4xk6iO5LzzM1zkrUtteh0UWoCB6t90P83yQNuwn9Q8YEkFm4BupfB3
 9RmO1ZeE
 a04Zcx22WI9bNAl2ZT+EJVXb0OjeJ5Ug7GtqGyiujiM2R1hYIyGbUugk8NGKvOrZhsTSwQCAst6ctXwNcsMVf08UdYEKiywaYQ4dufCRtiGen1lYinr+54lK45qsjWcIeA0OhlVK+SwBwZHKtc4QTR10xelXbbgSK3hrkTiAuXYNDnWeP4OS+I24zrdEoXXxwbDBZmujRIMINzqAGvYkfvHXMky4mXyef0Ocgl0J25EnJ2r3KjFlzrPMkJjh3fakGdnEXHcKscjx5kCC4jsHZjwZdu+MPucq2me7tCmIdFi39aUnYG+xPbTLfsg8ieDiOs9g5g9b3HAqNLkMrZbaGNpSKUIAHg+x/pruD4DoVN1kTC7IYYeocCYUNnftFPSjCMOV4NqdjCk0kiD8j0h1xbvT4UkBpzyzGQVSa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20.08.2026 4:39 AM, Christian Brauner wrote:
> Test the new COREDUMP_RECORDS and COREDUMP_SPARSE flags.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>

System: ppc64le LPAR (IBM POWER), Linux 7.3-rc2
> ---
>   .../coredump/coredump_socket_protocol_test.c       | 407 +++++++++++++++++++++
>   .../selftests/coredump/coredump_test_helpers.c     | 236 +++++++++++-
>   .../selftests/coredump/coredump_test_helpers.h     |   8 +
>   3 files changed, 650 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
> index 60a357e628eb..abf6e2c4c354 100644
> --- a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
> +++ b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
> @@ -1573,4 +1573,411 @@ TEST_F_TIMEOUT(coredump, socket_multiple_crashing_coredumps_epoll_workers, 500)
>   	wait_and_check_coredump_server(pid_coredump_server, _metadata, self);
>   }
>   
> +/*
> + * Reassemble a record stream and check that what comes out is an ELF
> + * core file. The records themselves are validated by recv_coredump_records().
> + */
> +TEST_F(coredump, socket_request_sparse_reassemble)
> +{
> +	int fd_core_file, pidfd, status;
> +	pid_t pid, pid_coredump_server;
> +	struct pidfd_info info = {};
> +	int ipc_sockets[2];
> +	char c;
> +
> +	ASSERT_EQ(socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0, ipc_sockets), 0);
> +	ASSERT_TRUE(set_core_pattern("@@/tmp/coredump.socket"));
> +
> +	pid_coredump_server = fork();
> +	ASSERT_GE(pid_coredump_server, 0);
> +	if (pid_coredump_server == 0) {
> +		int fd_server = -1, fd_coredump = -1, fd_peer_pidfd = -1;
> +		int fd_file = -1;
> +		int exit_code = EXIT_FAILURE;
> +		struct coredump_req req = {};
> +
> +		close(ipc_sockets[0]);
> +
> +		fd_server = create_and_listen_unix_socket("/tmp/coredump.socket");
> +		if (fd_server < 0)
> +			goto out;
> +
> +		if (write_nointr(ipc_sockets[1], "1", 1) < 0)
> +			goto out;
> +
> +		close(ipc_sockets[1]);
> +
> +		fd_coredump = accept4(fd_server, NULL, NULL, SOCK_CLOEXEC);
> +		if (fd_coredump < 0)
> +			goto out;
> +
> +		fd_peer_pidfd = get_peer_pidfd(fd_coredump);
> +		if (fd_peer_pidfd < 0)
> +			goto out;
> +
> +		fd_file = creat("/tmp/coredump.file", 0644);
> +		if (fd_file < 0)
> +			goto out;
> +
> +		if (!read_coredump_req(fd_coredump, &req))
> +			goto out;
> +
> +		if (!check_coredump_req(&req))
> +			goto out;
> +
> +		if (!send_coredump_ack(fd_coredump, &req,
> +				       COREDUMP_KERNEL | COREDUMP_RECORDS |
> +				       COREDUMP_SPARSE | COREDUMP_WAIT, 0))
> +			goto out;
> +
> +		if (!read_marker(fd_coredump, COREDUMP_MARK_REQACK))
> +			goto out;
> +
> +		if (recv_coredump_records(fd_coredump, fd_file, NULL, NULL, -1) < 0)
> +			goto out;
> +
> +		exit_code = EXIT_SUCCESS;
> +out:
> +		if (fd_file >= 0)
> +			close(fd_file);
> +		if (fd_peer_pidfd >= 0)
> +			close(fd_peer_pidfd);
> +		if (fd_coredump >= 0)
> +			close(fd_coredump);
> +		if (fd_server >= 0)
> +			close(fd_server);
> +		_exit(exit_code);
> +	}
> +	self->pid_coredump_server = pid_coredump_server;
> +
> +	EXPECT_EQ(close(ipc_sockets[1]), 0);
> +	ASSERT_EQ(read_nointr(ipc_sockets[0], &c, 1), 1);
> +	EXPECT_EQ(close(ipc_sockets[0]), 0);
> +
> +	pid = fork();
> +	ASSERT_GE(pid, 0);
> +	if (pid == 0)
> +		crashing_child();
> +
> +	pidfd = sys_pidfd_open(pid, 0);
> +	ASSERT_GE(pidfd, 0);
> +
> +	waitpid(pid, &status, 0);
> +	ASSERT_TRUE(WIFSIGNALED(status));
> +	ASSERT_TRUE(WCOREDUMP(status));
> +
> +	ASSERT_TRUE(get_pidfd_info(pidfd, &info));
> +	ASSERT_GT((info.mask & PIDFD_INFO_COREDUMP), 0);
> +	ASSERT_GT((info.coredump_mask & PIDFD_COREDUMPED), 0);
> +
> +	wait_and_check_coredump_server(pid_coredump_server, _metadata, self);
> +
> +	/* What the records reassemble into has to be an ELF core file. */
> +	fd_core_file = open("/tmp/coredump.file", O_RDONLY | O_CLOEXEC);
> +	ASSERT_GE(fd_core_file, 0);
> +	ASSERT_TRUE(is_elf_core(fd_core_file));
> +	EXPECT_EQ(close(fd_core_file), 0);
> +}
> +
> +/*
> + * Crash a child with a mostly-unpopulated mapping and reassemble its
> + * record stream, reporting what crossed the socket and the coredump
> + * size the records describe. With @kill_peer the server kills the task
> + * once the coredump is under way so the kernel has to cut it short.
> + */
> +static void check_record_dump(struct __test_metadata *const _metadata,
> +			      FIXTURE_DATA(coredump) *self, __u64 ack_mask,
> +			      bool kill_peer, ssize_t *received,
> +			      off_t *coredump_size)
> +{
> +	bool truncated = false;
> +	int pidfd, status;
> +	pid_t pid, pid_coredump_server;
> +	struct pidfd_info info = {};
> +	int ipc_sockets[2];
> +	int pipefds[2];
> +	char c;
> +
> +	ASSERT_EQ(socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0, ipc_sockets), 0);
> +	ASSERT_EQ(pipe(pipefds), 0);
> +	ASSERT_TRUE(set_core_pattern("@@/tmp/coredump.socket"));
> +
> +	pid_coredump_server = fork();
> +	ASSERT_GE(pid_coredump_server, 0);
> +	if (pid_coredump_server == 0) {
> +		int fd_server = -1, fd_coredump = -1, fd_peer_pidfd = -1;
> +		int fd_file = -1;
> +		int exit_code = EXIT_FAILURE;
> +		struct coredump_req req = {};
> +		bool is_truncated = false;
> +		off_t size = 0;
> +		ssize_t ret;
> +
> +		close(ipc_sockets[0]);
> +		close(pipefds[0]);
> +
> +		fd_server = create_and_listen_unix_socket("/tmp/coredump.socket");
> +		if (fd_server < 0)
> +			goto out;
> +
> +		if (write_nointr(ipc_sockets[1], "1", 1) < 0)
> +			goto out;
> +
> +		close(ipc_sockets[1]);
> +
> +		fd_coredump = accept4(fd_server, NULL, NULL, SOCK_CLOEXEC);
> +		if (fd_coredump < 0)
> +			goto out;
> +
> +		fd_peer_pidfd = get_peer_pidfd(fd_coredump);
> +		if (fd_peer_pidfd < 0)
> +			goto out;
> +
> +		/*
> +		 * The reassembled coredump is bigger than the mapping the
> +		 * child made, so keep it on the detached tmpfs and sparse.
> +		 */
> +		fd_file = open_coredump_tmpfile(self->fd_tmpfs_detached);
> +		if (fd_file < 0)
> +			goto out;
> +
> +		if (!read_coredump_req(fd_coredump, &req))
> +			goto out;
> +
> +		if (!check_coredump_req(&req))
> +			goto out;
> +
> +		if (!send_coredump_ack(fd_coredump, &req, ack_mask, 0))
> +			goto out;
> +
> +		if (!read_marker(fd_coredump, COREDUMP_MARK_REQACK))
> +			goto out;
> +
> +		ret = recv_coredump_records(fd_coredump, fd_file, &size, &is_truncated,
> +					    kill_peer ? fd_peer_pidfd : -1);
> +		if (ret < 0)
> +			goto out;
> +
> +		if (write_nointr(pipefds[1], &ret, sizeof(ret)) != sizeof(ret))
> +			goto out;
> +		if (write_nointr(pipefds[1], &size, sizeof(size)) != sizeof(size))
> +			goto out;
> +		if (write_nointr(pipefds[1], &is_truncated,
> +				 sizeof(is_truncated)) != sizeof(is_truncated))
> +			goto out;
> +
> +		exit_code = EXIT_SUCCESS;
> +out:
> +		close(pipefds[1]);
> +		if (fd_file >= 0)
> +			close(fd_file);
> +		if (fd_peer_pidfd >= 0)
> +			close(fd_peer_pidfd);
> +		if (fd_coredump >= 0)
> +			close(fd_coredump);
> +		if (fd_server >= 0)
> +			close(fd_server);
> +		_exit(exit_code);
> +	}
> +	self->pid_coredump_server = pid_coredump_server;
> +
> +	EXPECT_EQ(close(ipc_sockets[1]), 0);
> +	EXPECT_EQ(close(pipefds[1]), 0);
> +	ASSERT_EQ(read_nointr(ipc_sockets[0], &c, 1), 1);
> +	EXPECT_EQ(close(ipc_sockets[0]), 0);
> +
> +	pid = fork();
> +	ASSERT_GE(pid, 0);
> +	if (pid == 0)
> +		crashing_child_sparse(SPARSE_MAPPING_SIZE);
> +
> +	pidfd = sys_pidfd_open(pid, 0);
> +	ASSERT_GE(pidfd, 0);
> +
> +	waitpid(pid, &status, 0);
> +	ASSERT_TRUE(WIFSIGNALED(status));
> +
> +	ASSERT_EQ(read_nointr(pipefds[0], received, sizeof(*received)),
> +		  sizeof(*received));
> +	ASSERT_EQ(read_nointr(pipefds[0], coredump_size, sizeof(*coredump_size)),
> +		  sizeof(*coredump_size));
> +	ASSERT_EQ(read_nointr(pipefds[0], &truncated, sizeof(truncated)),
> +		  sizeof(truncated));
> +	EXPECT_EQ(close(pipefds[0]), 0);
> +
> +	wait_and_check_coredump_server(pid_coredump_server, _metadata, self);
> +
> +	if (kill_peer) {
> +		/* The kernel gave up partway, so no end record closed the stream. */
> +		ASSERT_TRUE(truncated);
> +		ASSERT_FALSE(WCOREDUMP(status));
> +		ASSERT_LT(*coredump_size, (off_t)SPARSE_MAPPING_SIZE);
> +		return;
> +	}
> +
> +	ASSERT_FALSE(truncated);
> +	ASSERT_TRUE(WCOREDUMP(status));
> +
> +	ASSERT_TRUE(get_pidfd_info(pidfd, &info));
> +	ASSERT_GT((info.mask & PIDFD_INFO_COREDUMP), 0);
> +	ASSERT_GT((info.coredump_mask & PIDFD_COREDUMPED), 0);
> +
> +	/* The mapping is in the coredump, holes included. */
> +	ASSERT_GT(*coredump_size, (off_t)SPARSE_MAPPING_SIZE);
> +}
> +
> +/*
> + * A mapping that has been written to is dumped whole, including the parts
> + * of it that were never faulted in. With COREDUMP_SPARSE the holes stay
> + * off the wire.
> + */
> +TEST_F(coredump, socket_request_sparse_hole)
> +{
> +	off_t coredump_size = 0;
> +	ssize_t received = 0;
> +
> +	check_record_dump(_metadata, self,
> +			  COREDUMP_KERNEL | COREDUMP_RECORDS |
> +			  COREDUMP_SPARSE | COREDUMP_WAIT,
> +			  false, &received, &coredump_size);
> +
> +	/* The holes didn't have to go over the socket. */
> +	ASSERT_LT(received, coredump_size / 8);
> +}
> +
> +/*
> + * COREDUMP_RECORDS alone splits the stream into records but elides
> + * nothing: the holes cross the socket as data records.
> + */
> +TEST_F(coredump, socket_request_records_hole)
> +{
> +	off_t coredump_size = 0;
> +	ssize_t received = 0;
> +
> +	check_record_dump(_metadata, self,
> +			  COREDUMP_KERNEL | COREDUMP_RECORDS | COREDUMP_WAIT,
> +			  false, &received, &coredump_size);
> +
> +	/* Records alone elide nothing, so everything crossed the socket. */
> +	ASSERT_GT(received, coredump_size);
> +}
> +
> +/*
> + * A coredump the kernel gives up on halfway still ends in an end record,
> + * and that record says the coredump is incomplete. COREDUMP_SPARSE is left
> + * out on purpose: the holes have to cross the socket so the coredump is
> + * far larger than the socket buffer and the kernel is still writing it
> + * when the kill lands.
> + */
> +TEST_F(coredump, socket_request_records_truncated)
> +{
> +	off_t coredump_size = 0;
> +	ssize_t received = 0;
> +
> +	check_record_dump(_metadata, self,
> +			  COREDUMP_KERNEL | COREDUMP_RECORDS | COREDUMP_WAIT,
> +			  true, &received, &coredump_size);
> +
> +	/* The end record crossed the socket even though the task was killed. */
> +	ASSERT_GT(received, 0);
> +}
> +
> +/* Ack @ack_mask, expect the kernel to refuse it as conflicting. */
> +static void check_conflicting_ack(struct __test_metadata *const _metadata,
> +				  FIXTURE_DATA(coredump) *self, __u64 ack_mask)
> +{
> +	int pidfd, status;
> +	pid_t pid, pid_coredump_server;
> +	struct pidfd_info info = {};
> +	int ipc_sockets[2];
> +	char c;
> +
> +	ASSERT_EQ(socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0, ipc_sockets), 0);
> +	ASSERT_TRUE(set_core_pattern("@@/tmp/coredump.socket"));
> +
> +	pid_coredump_server = fork();
> +	ASSERT_GE(pid_coredump_server, 0);
> +	if (pid_coredump_server == 0) {
> +		int fd_server = -1, fd_coredump = -1, fd_peer_pidfd = -1;
> +		int exit_code = EXIT_FAILURE;
> +		struct coredump_req req = {};
> +
> +		close(ipc_sockets[0]);
> +
> +		fd_server = create_and_listen_unix_socket("/tmp/coredump.socket");
> +		if (fd_server < 0)
> +			goto out;
> +
> +		if (write_nointr(ipc_sockets[1], "1", 1) < 0)
> +			goto out;
> +
> +		close(ipc_sockets[1]);
> +
> +		fd_coredump = accept4(fd_server, NULL, NULL, SOCK_CLOEXEC);
> +		if (fd_coredump < 0)
> +			goto out;
> +
> +		fd_peer_pidfd = get_peer_pidfd(fd_coredump);
> +		if (fd_peer_pidfd < 0)
> +			goto out;
> +
> +		if (!read_coredump_req(fd_coredump, &req))
> +			goto out;
> +
> +		if (!check_coredump_req(&req))
> +			goto out;
> +
> +		if (!send_coredump_ack(fd_coredump, &req, ack_mask, 0))
> +			goto out;
> +
> +		if (!read_marker(fd_coredump, COREDUMP_MARK_CONFLICTING))
> +			goto out;
> +
> +		exit_code = EXIT_SUCCESS;
> +out:
> +		if (fd_peer_pidfd >= 0)
> +			close(fd_peer_pidfd);
> +		if (fd_coredump >= 0)
> +			close(fd_coredump);
> +		if (fd_server >= 0)
> +			close(fd_server);
> +		_exit(exit_code);
> +	}
> +	self->pid_coredump_server = pid_coredump_server;
> +
> +	EXPECT_EQ(close(ipc_sockets[1]), 0);
> +	ASSERT_EQ(read_nointr(ipc_sockets[0], &c, 1), 1);
> +	EXPECT_EQ(close(ipc_sockets[0]), 0);
> +
> +	pid = fork();
> +	ASSERT_GE(pid, 0);
> +	if (pid == 0)
> +		crashing_child();
> +
> +	pidfd = sys_pidfd_open(pid, 0);
> +	ASSERT_GE(pidfd, 0);
> +
> +	waitpid(pid, &status, 0);
> +	ASSERT_TRUE(WIFSIGNALED(status));
> +	ASSERT_FALSE(WCOREDUMP(status));
> +
> +	ASSERT_TRUE(get_pidfd_info(pidfd, &info));
> +	ASSERT_GT((info.mask & PIDFD_INFO_COREDUMP), 0);
> +	ASSERT_GT((info.coredump_mask & PIDFD_COREDUMPED), 0);
> +
> +	wait_and_check_coredump_server(pid_coredump_server, _metadata, self);
> +}
> +
> +/* COREDUMP_RECORDS applies to a coredump the kernel writes, nothing else. */
> +TEST_F(coredump, socket_request_records_without_kernel)
> +{
> +	check_conflicting_ack(_metadata, self, COREDUMP_USERSPACE | COREDUMP_RECORDS);
> +}
> +
> +/* A zero record can't exist outside a record stream. */
> +TEST_F(coredump, socket_request_sparse_without_records)
> +{
> +	check_conflicting_ack(_metadata, self, COREDUMP_KERNEL | COREDUMP_SPARSE);
> +}
> +
>   TEST_HARNESS_MAIN
> diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
> index a5b9cde47239..5b2ffe17f7b7 100644
> --- a/tools/testing/selftests/coredump/coredump_test_helpers.c
> +++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
> @@ -1,9 +1,11 @@
>   // SPDX-License-Identifier: GPL-2.0
>   
>   #include <assert.h>
> +#include <elf.h>
>   #include <errno.h>
>   #include <fcntl.h>
>   #include <limits.h>
> +#include <link.h>
>   #include <linux/coredump.h>
>   #include <linux/fs.h>
>   #include <pthread.h>
> @@ -13,6 +15,7 @@
>   #include <string.h>
>   #include <sys/epoll.h>
>   #include <sys/ioctl.h>
> +#include <sys/mman.h>
>   #include <sys/socket.h>
>   #include <sys/types.h>
>   #include <sys/un.h>
> @@ -23,6 +26,12 @@
>   
>   #include "coredump_test_helpers.h"
>   
> +#if __ELF_NATIVE_CLASS == 64
> +#define COREDUMP_ELFCLASS ELFCLASS64
> +#else
> +#define COREDUMP_ELFCLASS ELFCLASS32
> +#endif
> +
>   void *do_nothing(void *arg)
>   {
>   	(void)arg;
> @@ -44,6 +53,228 @@ void crashing_child(void)
>   	i = *(volatile int *)NULL;
>   }
>   
> +void crashing_child_sparse(size_t size)
> +{
> +	char *p;
> +
> +	/*
> +	 * Touch the first page only. The whole mapping is dumped because
> +	 * it has been written to, but all of it save that one page is a
> +	 * hole.
> +	 */
> +	p = mmap(NULL, size, PROT_READ | PROT_WRITE,
> +		 MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
> +	if (p != MAP_FAILED)
> +		p[0] = 'x';
> +
> +	/* crash on purpose */
> +	*(volatile int *)NULL = 0;
> +}
> +
> +/* Read @len bytes off the socket, writing them at @offset if @fd_out >= 0. */
> +static ssize_t recv_record_bytes(int fd_coredump, __u64 len, int fd_out,
> +				 off_t offset)
> +{
> +	ssize_t received = 0;
> +
> +	while (len) {
> +		char buffer[PAGE_SIZE];
> +		size_t chunk = len < sizeof(buffer) ? len : sizeof(buffer);
> +		ssize_t ret;
> +
> +		ret = recv(fd_coredump, buffer, chunk, MSG_WAITALL);
> +		if (ret <= 0) {
> +			fprintf(stderr, "%s: short read %zd: %m\n",
> +				__func__, ret);
> +			return -1;
> +		}
> +
> +		if (fd_out >= 0 &&
> +		    pwrite(fd_out, buffer, ret, offset + received) != ret) {
> +			fprintf(stderr, "%s: pwrite failed: %m\n", __func__);
> +			return -1;
> +		}
> +
> +		received += ret;
> +		len -= ret;
> +	}
> +
> +	return received;
> +}
> +
> +/*
> + * Reassemble a record stream. If @fd_peer_pidfd is valid the task behind
> + * it is killed once a data record has arrived, so the kernel has to cut
> + * the coredump short with the stream already under way.
> + */
> +ssize_t recv_coredump_records(int fd_coredump, int fd_core_file,
> +			      off_t *coredump_size, bool *truncated,
> +			      int fd_peer_pidfd)
> +{
> +	ssize_t received = 0;
> +	off_t size = 0;
> +	bool is_truncated = false;
> +	bool ended = false;
> +	char trailing;
> +
> +	while (!ended) {
> +		struct coredump_record_header record = {};
> +		size_t known_size;
> +		ssize_t ret;
> +
> +		/* Peek the header size the way read_coredump_req() does. */
> +		ret = recv(fd_coredump, &record, sizeof(record.size),
> +			   MSG_PEEK | MSG_WAITALL);
> +		if (ret == 0) {
> +			/* Nothing closed the stream, so the coredump was cut short. */
> +			if (truncated) {
> +				is_truncated = true;
> +				break;
> +			}
> +			fprintf(stderr, "%s: stream ended without an end record\n",
> +				__func__);
> +			return -1;
> +		}
> +		if (ret != sizeof(record.size)) {
> +			fprintf(stderr, "%s: short record peek %zd: %m\n",
> +				__func__, ret);
> +			return -1;
> +		}
> +
> +		if (record.size < COREDUMP_RECORD_HEADER_SIZE_VER0) {
> +			fprintf(stderr, "%s: header size %u below minimum %u\n",
> +				__func__, record.size,
> +				COREDUMP_RECORD_HEADER_SIZE_VER0);
> +			return -1;
> +		}
> +
> +		/* Consume as much of the header as we know about. */
> +		known_size = record.size < sizeof(record) ? record.size : sizeof(record);
> +		ret = recv(fd_coredump, &record, known_size, MSG_WAITALL);
> +		if (ret != (ssize_t)known_size) {
> +			fprintf(stderr, "%s: short record read %zd: %m\n",
> +				__func__, ret);
> +			return -1;
> +		}
> +		received += ret;
> +
> +		/*
> +		 * A flag changes what the record means, so refuse one we
> +		 * don't know rather than guess.
> +		 */
> +		if (record.flags) {
> +			fprintf(stderr, "%s: unknown header flags 0x%llx\n",
> +				__func__, (unsigned long long)record.flags);
> +			return -1;
> +		}
> +
> +		/* Discard any part of the header we have no use for. */
> +		ret = recv_record_bytes(fd_coredump, record.size - known_size, -1, 0);
> +		if (ret < 0)
> +			return -1;
> +		received += ret;
> +
> +		/* Records are sent in order and they don't leave gaps. */
> +		if (record.offset != (__u64)size) {
> +			fprintf(stderr, "%s: record at %llu, expected %llu\n",
> +				__func__, (unsigned long long)record.offset,
> +				(unsigned long long)size);
> +			return -1;
> +		}
> +
> +		switch (record.type) {
> +		case COREDUMP_RECORD_ZERO:
> +			/* A hole. It comes with no data and needs none. */
> +			break;
> +		case COREDUMP_RECORD_DATA:
> +			ret = recv_record_bytes(fd_coredump, record.len,
> +						fd_core_file, size);
> +			if (ret < 0)
> +				return -1;
> +			received += ret;
> +			if (fd_peer_pidfd >= 0) {
> +				if (sys_pidfd_send_signal(fd_peer_pidfd, SIGKILL,
> +							  NULL, 0)) {
> +					fprintf(stderr, "%s: kill failed: %m\n",
> +						__func__);
> +					return -1;
> +				}
> +				fd_peer_pidfd = -1;
> +			}
> +			break;
> +		case COREDUMP_RECORD_END:
> +			/* The coredump ends here and nothing follows it. */
> +			if (record.len) {
> +				fprintf(stderr, "%s: end record covers %llu bytes\n",
> +					__func__,
> +					(unsigned long long)record.len);
> +				return -1;
> +			}
> +			ended = true;
> +			break;
> +		default:
> +			fprintf(stderr, "%s: unknown record type %u\n",
> +				__func__, record.type);
> +			return -1;
> +		}
> +
> +		size += record.len;
> +	}
> +
> +	/* The end record is the last thing on the wire. */
> +	if (recv(fd_coredump, &trailing, sizeof(trailing), MSG_DONTWAIT) > 0) {
> +		fprintf(stderr, "%s: data after the end record\n", __func__);
> +		return -1;
> +	}
> +
> +	if (truncated)
> +		*truncated = is_truncated;
> +
> +	/*
> +	 * Nothing is written for a hole, so grow the file to the size the
> +	 * records describe in case the coredump ended in one.
> +	 */
> +	if (ftruncate(fd_core_file, size) < 0) {
> +		fprintf(stderr, "%s: ftruncate to %llu failed: %m\n",
> +			__func__, (unsigned long long)size);
> +		return -1;
> +	}
> +
> +	if (coredump_size)
> +		*coredump_size = size;
> +
> +	fprintf(stderr, "Received %zd bytes for a %s coredump of %llu bytes\n",
> +		received, is_truncated ? "truncated" : "complete",
> +		(unsigned long long)size);
> +	return received;
> +}
> +
> +/* The ELF header of a native core file. */
> +static bool is_core_ehdr(const ElfW(Ehdr) *ehdr)
> +{
> +	return !memcmp(ehdr->e_ident, ELFMAG, SELFMAG) &&
> +	       ehdr->e_ident[EI_CLASS] == COREDUMP_ELFCLASS &&
> +	       ehdr->e_type == ET_CORE;
> +}
> +
> +/* Whatever the server ends up with has to be an ELF core file. */
> +bool is_elf_core(int fd)
> +{
> +	ElfW(Ehdr) ehdr;
> +
> +	if (pread(fd, &ehdr, sizeof(ehdr), 0) != sizeof(ehdr)) {
> +		fprintf(stderr, "%s: short read: %m\n", __func__);
> +		return false;
> +	}
> +
> +	if (!is_core_ehdr(&ehdr)) {
> +		fprintf(stderr, "%s: not an ELF core file\n", __func__);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>   int create_detached_tmpfs(void)
>   {
>   	int fd_context, fd_tmpfs;
> @@ -86,6 +317,7 @@ int create_and_listen_unix_socket(const char *path)
>   	return fd;
>   
>   out:
> +	fprintf(stderr, "%s: %s: %m\n", __func__, path);
>   	if (fd >= 0)
>   		close(fd);
>   	return -1;
> @@ -264,8 +496,10 @@ bool send_coredump_ack(int fd, const struct coredump_req *req,
>   	large_ack.ack.mask = mask;
>   	large_ack.ack.size = size_ack;
>   	ret = send(fd, &large_ack, size_ack, MSG_NOSIGNAL);
> -	if (ret != size_ack)
> +	if (ret != size_ack) {
> +		fprintf(stderr, "%s: short send %zd: %m\n", __func__, ret);
>   		return false;
> +	}
>   
>   	fprintf(stderr, "Sent coredump ack with size %zu and mask 0x%llx\n",
>   		size_ack, (unsigned long long)mask);
> diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.h b/tools/testing/selftests/coredump/coredump_test_helpers.h
> index 45904bd177b8..fe0a88a71b05 100644
> --- a/tools/testing/selftests/coredump/coredump_test_helpers.h
> +++ b/tools/testing/selftests/coredump/coredump_test_helpers.h
> @@ -15,9 +15,17 @@
>   
>   #define NUM_THREAD_SPAWN 128
>   
> +/* Size of the mostly unpopulated mapping the sparse coredump test maps. */
> +#define SPARSE_MAPPING_SIZE (256 * 1024 * 1024)
> +
>   /* Shared helper function declarations */
>   void *do_nothing(void *arg);
>   void crashing_child(void);
> +void crashing_child_sparse(size_t size);
> +ssize_t recv_coredump_records(int fd_coredump, int fd_core_file,
> +			      off_t *coredump_size, bool *truncated,
> +			      int fd_peer_pidfd);
> +bool is_elf_core(int fd);
>   int create_detached_tmpfs(void);
>   int create_and_listen_unix_socket(const char *path);
>   bool set_core_pattern(const char *pattern);
>
-- 
Thanks and Regards
R.Nageswara Sastry


