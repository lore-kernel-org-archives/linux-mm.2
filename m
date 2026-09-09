Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA3E9C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7EE46B00A3; Wed,  9 Sep 2026 12:07:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B55756B00AF; Wed,  9 Sep 2026 12:07:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70266B00B0; Wed,  9 Sep 2026 12:07:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 795276B00A3
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:07:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2645B1A0284
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:07:36 +0000 (UTC)
X-FDA: 85194704112.20.F6CFA09
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf16.hostedemail.com (Postfix) with ESMTP id A3B90180009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:07:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=MzB7sSDU;
	spf=pass (imf16.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788970053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LErW1QXZbxGRWytEMWoXjnXzPIKqjkw115upO4vyhy0=;
	b=MgGPZoTMZCuQgaMBXljuKe05O+L+VwEUbQdR43zZMwe05Voq8WB/1UCzywFjnCNwPb4jLc
	ETRoemcHxJ9AnZb0irS6tOZD1uSWPM1ziYSua+fQNzeyCrL6Z9kl75+/shqTfdmuI6nySg
	iOOuq4CrL/KulogEQiTQC4mPYOhDx4k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=MzB7sSDU;
	spf=pass (imf16.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788970053;
	b=h9nlYumUUy24qeHozBLvWJjjDP2atuz/9Yezov27rv0UBVZRt+6kxU+8m8AKOpy3+pYK0v
	r3DHBqjJc299GrN8dk2d3GzPCz7KCWlM9YCzbfpSLaPVGnmwVZGi0UWmArwmHeT7hgysY4
	GENsnjs8aG1DjY9R6vP+IK4YKWxrJBk=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689B1aXb3839613;
	Wed, 9 Sep 2026 16:07:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=LErW1Q
	XZbxGRWytEMWoXjnXzPIKqjkw115upO4vyhy0=; b=MzB7sSDU5yllt5ivEOLP67
	oyr5F/bJI0Ut3d1MmKdUkfDm2SYEI4DhP+h2wrnpz13BeR6aeHytmSuvYrwqg9d/
	r1oL5gHoqjRv3t6ENr+KnS65lSaXCiK9HVrMTRJI9gxjlmVRYQTtjiaQXHOe6xeE
	6Wf9SBAEeJKNtzMMOYSWzBZSxhwoWWyDeZ4dtZnxCyww54sElGQFZmkV9yR2jiMQ
	w+Cbc42irxaWsYzyCwL5VMs8FwhosWqGBNSMZ8sgRDmvQEwVx52T8YQzH2C+TO8E
	LKlHVkcebJlfw1acP5NCK5bUdz4tFSZJ9SKKinaIDk9BRYsJkP1xdupNLJtOwzzQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbhf6kps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 16:07:24 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 689FuEor001933;
	Wed, 9 Sep 2026 16:07:23 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ggwswbacf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 16:07:23 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 689G7LRB51249536
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Sep 2026 16:07:21 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94CD32004D;
	Wed,  9 Sep 2026 16:07:21 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3E38F20043;
	Wed,  9 Sep 2026 16:07:11 +0000 (GMT)
Received: from [9.61.255.18] (unknown [9.61.255.18])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  9 Sep 2026 16:07:10 +0000 (GMT)
Message-ID: <8a6c3ee9-2904-4459-a7ce-0dd3a862c45c@linux.ibm.com>
Date: Wed, 9 Sep 2026 21:37:07 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 22/22] selftests/coredump: show how to inspect the task
 to decide how the coredump should be sent
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
 <20260820-work-coredump-sparse-v2-22-ba32dd718c51@kernel.org>
Content-Language: en-US
From: R Nageswara Sastry <rnsastry@linux.ibm.com>
In-Reply-To: <20260820-work-coredump-sparse-v2-22-ba32dd718c51@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: OghkNmaAUragxP0V7v_6J3AxvGElCJI0
X-Authority-Analysis: v=2.4 cv=RIaD2Yi+ c=1 sm=1 tr=0 ts=6aa1843d cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=X1guSlia4CSY-PBa:21 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=Xvi4HtpHqznmmyYddu4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE3OCBTYWx0ZWRfX6gZFyxg0LZuP
 dv5hOMskupnTlqSi2aoKO3QGs74H9omuFcBQ5/6LWgOGJMH5MWUflgbh1lZedC9y/6unj3UqChg
 RZILSJa5c3FfSW3JhaNiSGU0eR+rPPA=
X-Proofpoint-ORIG-GUID: 2lIday-SOMwsIjSNyng9yS6MxS3LcjXH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE3OCBTYWx0ZWRfX2MiFKFFDWZeQ
 RfIqJL9cQebul00XuEj6ET3DPixi+znqRsHDQLHR73JctHN4+YkhEKycm8tgoVz17I85wo0ov+I
 dtKV9fdRzQtit7WpBLNntG+tjzsodvSN2KWj96HGUy5UGsL6kFLjJ647ga3bLKmBQTflmL74Zjj
 220y1TwMy4mC8qnnnM6pT1fN6yGy7LEO+BLOarXr2PxzzMsrF9gaQuPIPNfpJNAJsVoFd5wCqIz
 x6hTVBOI2IS+XtW1wYtLMReIyCAfdHpeLZAnBI3yiYvgK3vYofFfSBvVLaItWnkUfGYNQvV48Fa
 iVC7jX3mNSFa104cw3Y6xvsuVcFseY/fyFFxesUuzmKLbPZ3jfrU3+WQK6R67KMrpUe/Q7TLlRn
 WCu79R+FYzKM2cCeDFNm1CCm6Y3rSXkqjPXTc587afmvseSC+C0lKHo2Rn9YlPNXVJx0phHABd+
 jG8HHiHifdyU83GZXaQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 adultscore=0 phishscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090178
X-Rspam-User: 
X-Stat-Signature: 34oroe8ygagzr4igf6dcdghtfszu5utc
X-Rspamd-Queue-Id: A3B90180009
X-Rspamd-Server: rspam07
X-HE-Tag: 1788970053-121791
X-HE-Meta: U2FsdGVkX1/HBsW2jpdd3GZOI+Brtsy40mkuwmFI1Tymi9qBsT+xwaagctl1yn6bPEC4gYp94rtzW3ttfNjUFjrhKGDZXtF0w9XkXDlGMLHxJg6xnhAicnOIiICRNVF0SKbOfOHL7863FkAqaUiw49KOUkL2m9WAUZKopnTOiTcVl7yYx+LHYuxSgP5OcaZj1/O4o+djnKbIVjVqvFEMWZNIc/Ut5VPu6QiMnv9rp5VNnyxtA502k28DvlD7a8IF1d+2CgDoKSs6n+hbPISoCzuVuLMYNkpNcUTpcQbs2BWjD8vYDwH3B3VMtZTdHszbS+QNa4FKfpw9CjJuXrkVAZWJb6nEMVGYfCDPklaMsAJn6CD5DFw0/Wm5wmLdBcO1nEAp2pK+zF6a/UsViG8MFvORPda/xQ2OUUuvpmFJWUlc6pHRl+jyPNozVfR0Cejjv+iKgQxxJvWULhtZOa1cBYgzRXZO0J9y2Zdyj5zDc2aWcZ4MYKhn7G2zealyAtHh2vpJ1jw8DOEiaDOFGx8g2jOrK3FZIpmoJxVO3vCEqS8RYqccnn1tzBP8Vo92eJGdO9cJcgBYAuFjo+aNimB37Z6FX0gbpOO2nFQQkXHbe5ID7ap+O5cylNY8Kphi90Y/PzmmRG8gy/qZB4nhGm82+ZtswvbHAhniRkc2AB3k937qnxRA5D8EZrr79b4Qp8GKnrNfxeTrtHL+DAPZSdEZUvp8aak2rJ61+8enjxLHu9nG60qZJz2uBwjIItHfh/bL8Dz+as7PX07Tt5DQoYVAxtM9nj7d0g5A1dVWVwUt6WBE4UpgZeFNCyE2F/6olckzDeQtmfcoJ1/yEq6YWXHWr4Q4sPvhHmIewenz8VcYj2wJdcmAtTLzJjCGEehNnrq5CPUEJHonSXJsm2Om+WpIGHlJitDK8IJVSzqZRquxW9V+tm8E3iav3WXWpt5tMcjryAppc04/OkOaIlZwzYJ
 bHFgQ24D
 e5ew5LWZUgc7XF/wKpkvYTKlPEYkaDxChwmittlELeN2H3FCBK8XfOws8UfZR+8RVwkBXEo8agYayDMRzmSdEPoxPVqv4cG0OrnEngyUxo2choC6ZH53Si486XTFjOwi7HXXo33lTkO7B0PJizJ1pQCJnZj9l1pXV7zu9wF/IeZkEh9AIAKLrYU8hi2NxoW8JzdvE0gdGWy3babLaUAaK5aVVtz+Kr07a76ZbkXTvkaZW7r7fx1TEpFVOu1hp/dUIhjfGF/hq9l8AzlFjQZH+8aB/ti6+4Y/JSdhoCApqYl+UnriceNjZ0tDBPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20.08.2026 4:39 AM, Christian Brauner wrote:
> The kernel blocks in the coredump req until the coredump ack is sent by
> the coredump server. This allows the coredump server to decide how the
> kernel is supposed to send the coredump.
>
> Let's show how that can work:
>
> - a task that has a large memory mapping gets sent as a sparse record
>    stream
>
> - a task with a trivial memory mapping gets sent as a plain byte stream
>
> Since the threads are parked in coredump_task_exit() with their mm
> around we can look at /proc/<pid>/statm to figure out what the task has
> mapped.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>

System: ppc64le LPAR (IBM POWER), Linux 7.3-rc2
> ---
>   .../coredump/coredump_socket_protocol_test.c       | 184 +++++++++++++++++++++
>   .../selftests/coredump/coredump_test_helpers.c     |  58 +++++++
>   .../selftests/coredump/coredump_test_helpers.h     |   7 +-
>   3 files changed, 248 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
> index f33eaf2fa93d..daff908232a2 100644
> --- a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
> +++ b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
> @@ -2136,4 +2136,188 @@ TEST_F(coredump, socket_request_sparse_without_records)
>   	check_conflicting_ack(_metadata, self, COREDUMP_KERNEL | COREDUMP_SPARSE);
>   }
>   
> +/* What the server reports back about the coredump it decided to take. */
> +struct stream_choice {
> +	bool sparse;
> +	ssize_t received;
> +	off_t size;
> +	ssize_t vm_size;
> +};
> +
> +/*
> + * The kernel blocks in the coredump request until the ack arrives, so a
> + * coredump server gets to look at the task before it commits to a
> + * stream. Take the record stream only for a task whose mappings are
> + * worth it and the plain byte stream for everything else.
> + */
> +static void check_stream_choice(struct __test_metadata *const _metadata,
> +				FIXTURE_DATA(coredump) *self, bool big,
> +				struct stream_choice *choice)
> +{
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
> +		struct stream_choice got = {};
> +		__u64 mask;
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
> +		/*
> +		 * Nothing is on the wire yet and the kernel is waiting for
> +		 * the ack, so there is all the time in the world to look at
> +		 * the task and decide what to ask it for.
> +		 */
> +		got.vm_size = peer_vm_size(fd_peer_pidfd);
> +		if (got.vm_size < 0)
> +			goto out;
> +		got.sparse = got.vm_size >= SPARSE_STREAM_THRESHOLD;
> +
> +		fprintf(stderr, "Peer maps %zd bytes, asking for %s\n",
> +			got.vm_size,
> +			got.sparse ? "a sparse record stream" : "a byte stream");
> +
> +		mask = COREDUMP_KERNEL | COREDUMP_WAIT;
> +		if (got.sparse)
> +			mask |= COREDUMP_RECORDS | COREDUMP_SPARSE;
> +
> +		if (!send_coredump_ack(fd_coredump, &req, mask, 0))
> +			goto out;
> +
> +		if (!read_marker(fd_coredump, COREDUMP_MARK_REQACK))
> +			goto out;
> +
> +		if (got.sparse) {
> +			got.received = recv_coredump_records(fd_coredump, fd_file,
> +							     &got.size, NULL, -1);
> +		} else {
> +			got.received = recv_coredump_bytes(fd_coredump, fd_file);
> +			got.size = got.received;
> +		}
> +		if (got.received < 0)
> +			goto out;
> +
> +		/* Either way a debugger has to see an ordinary core file. */
> +		if (!is_elf_core(fd_file))
> +			goto out;
> +
> +		if (write_nointr(pipefds[1], &got, sizeof(got)) != sizeof(got))
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
> +		crashing_child_sparse(big ? SPARSE_MAPPING_SIZE : PAGE_SIZE);
> +
> +	pidfd = sys_pidfd_open(pid, 0);
> +	ASSERT_GE(pidfd, 0);
> +
> +	waitpid(pid, &status, 0);
> +	ASSERT_TRUE(WIFSIGNALED(status));
> +	ASSERT_TRUE(WCOREDUMP(status));
> +
> +	ASSERT_EQ(read_nointr(pipefds[0], choice, sizeof(*choice)),
> +		  sizeof(*choice));
> +	EXPECT_EQ(close(pipefds[0]), 0);
> +
> +	ASSERT_TRUE(get_pidfd_info(pidfd, &info));
> +	ASSERT_GT((info.mask & PIDFD_INFO_COREDUMP), 0);
> +	ASSERT_GT((info.coredump_mask & PIDFD_COREDUMPED), 0);
> +
> +	wait_and_check_coredump_server(pid_coredump_server, _metadata, self);
> +}
> +
> +/* A task with little mapped isn't worth a record stream. */
> +TEST_F(coredump, socket_request_stream_choice_small)
> +{
> +	struct stream_choice choice = {};
> +
> +	check_stream_choice(_metadata, self, false, &choice);
> +
> +	ASSERT_LT(choice.vm_size, (ssize_t)SPARSE_STREAM_THRESHOLD);
> +	ASSERT_FALSE(choice.sparse);
> +	ASSERT_GT(choice.received, 0);
> +}
> +
> +/* A task sitting on a big mapping is. */
> +TEST_F(coredump, socket_request_stream_choice_large)
> +{
> +	struct stream_choice choice = {};
> +
> +	check_stream_choice(_metadata, self, true, &choice);
> +
> +	ASSERT_GE(choice.vm_size, (ssize_t)SPARSE_STREAM_THRESHOLD);
> +	ASSERT_TRUE(choice.sparse);
> +	ASSERT_GT(choice.size, (off_t)SPARSE_MAPPING_SIZE);
> +
> +	/* The holes didn't have to go over the socket. */
> +	ASSERT_LT(choice.received, choice.size / 8);
> +}
> +
>   TEST_HARNESS_MAIN
> diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
> index 9346b8f688e2..d7cc448eeaf4 100644
> --- a/tools/testing/selftests/coredump/coredump_test_helpers.c
> +++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
> @@ -1095,6 +1095,33 @@ int check_compact_coredump(int fd_object, int fd_reference)
>   	return ret;
>   }
>   
> +/* Read a plain coredump byte stream to end-of-file. */
> +ssize_t recv_coredump_bytes(int fd_coredump, int fd_core_file)
> +{
> +	ssize_t received = 0;
> +
> +	for (;;) {
> +		char buffer[PAGE_SIZE];
> +		ssize_t ret = read_nointr(fd_coredump, buffer, sizeof(buffer));
> +
> +		if (ret < 0) {
> +			fprintf(stderr, "%s: read failed: %m\n", __func__);
> +			return -1;
> +		}
> +		if (ret == 0)
> +			break;
> +
> +		if (write_nointr(fd_core_file, buffer, ret) != ret) {
> +			fprintf(stderr, "%s: write failed: %m\n", __func__);
> +			return -1;
> +		}
> +		received += ret;
> +	}
> +
> +	fprintf(stderr, "Received %zd bytes of coredump\n", received);
> +	return received;
> +}
> +
>   int create_detached_tmpfs(void)
>   {
>   	int fd_context, fd_tmpfs;
> @@ -1190,6 +1217,37 @@ bool get_pidfd_info(int fd_peer_pidfd, struct pidfd_info *info)
>   	return true;
>   }
>   
> +/*
> + * How much the peer has mapped. The task is parked in the coredump
> + * handshake, so its mm is still there to be looked at.
> + */
> +ssize_t peer_vm_size(int fd_peer_pidfd)
> +{
> +	struct pidfd_info info = {};
> +	unsigned long pages;
> +	char path[64];
> +	FILE *f;
> +
> +	if (!get_pidfd_info(fd_peer_pidfd, &info))
> +		return -1;
> +
> +	snprintf(path, sizeof(path), "/proc/%d/statm", info.pid);
> +	f = fopen(path, "r");
> +	if (!f) {
> +		fprintf(stderr, "%s: %s: %m\n", __func__, path);
> +		return -1;
> +	}
> +
> +	if (fscanf(f, "%lu", &pages) != 1) {
> +		fprintf(stderr, "%s: %s: no size\n", __func__, path);
> +		fclose(f);
> +		return -1;
> +	}
> +	fclose(f);
> +
> +	return (ssize_t)pages * sysconf(_SC_PAGESIZE);
> +}
> +
>   /* Protocol helper functions */
>   
>   ssize_t recv_marker(int fd)
> diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.h b/tools/testing/selftests/coredump/coredump_test_helpers.h
> index 00d695b67b3f..97ad5cfeae92 100644
> --- a/tools/testing/selftests/coredump/coredump_test_helpers.h
> +++ b/tools/testing/selftests/coredump/coredump_test_helpers.h
> @@ -18,6 +18,9 @@
>   /* Size of the mostly unpopulated mapping the sparse coredump test maps. */
>   #define SPARSE_MAPPING_SIZE (256 * 1024 * 1024)
>   
> +/* A task mapping at least this much is worth a record stream. */
> +#define SPARSE_STREAM_THRESHOLD (SPARSE_MAPPING_SIZE / 2)
> +
>   /* Shared helper function declarations */
>   void *do_nothing(void *arg);
>   void crashing_child(void);
> @@ -25,9 +28,11 @@ void crashing_child_sparse(size_t size);
>   ssize_t recv_coredump_records(int fd_coredump, int fd_core_file,
>   			      off_t *coredump_size, bool *truncated,
>   			      int fd_peer_pidfd);
> -bool is_elf_core(int fd);
>   ssize_t recv_coredump_compact(int fd_coredump, int fd_object, int fd_reference,
>   			      off_t *coredump_size);
> +ssize_t recv_coredump_bytes(int fd_coredump, int fd_core_file);
> +ssize_t peer_vm_size(int fd_peer_pidfd);
> +bool is_elf_core(int fd);
>   int check_compact_coredump(int fd_object, int fd_reference);
>   int create_detached_tmpfs(void);
>   int create_and_listen_unix_socket(const char *path);
>
-- 
Thanks and Regards
R.Nageswara Sastry


