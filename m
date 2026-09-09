Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A2E8C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90C256B009F; Wed,  9 Sep 2026 12:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E3F96B00A0; Wed,  9 Sep 2026 12:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ABC46B00A3; Wed,  9 Sep 2026 12:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3886B009F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:07:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A47D912021E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:07:08 +0000 (UTC)
X-FDA: 85194702936.08.157F918
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2870A1A0009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:07:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=N4+PqsGX;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf19.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=N4+PqsGX;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf19.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788970026;
	b=0zepGi0JTQ/vf+kV10m9TmvMX5DTZIfutefQEIlxNedZkAlXy84uXLJNZR3i1Uiw1YfrEh
	Oi8mx5Q8Y+MyyyHIDB54ORekQYCJlR96RuivzQ4TKtvPonz3zeJhwvQGuYAY9hm8vXzRRr
	ejtkSmjlGStXBJY1jpcCd1Z2EnLkZ3Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788970026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J38RGijN+Ynh3uMdjHoMrrjPz4RzXMqA/AaF+1KqLl0=;
	b=KvkdDCbvzTo0e5PQk6o3xBPNYnVFVukMM+nh0+KOVjHlnqdc4PILRh0WJ61UXqLDjBo0Zk
	kKp2FtnzLDXitO7AnqgIfX1jvmMUP2nl0HWD5YnqK0pYlZKKATkPLAKFyXVURWZoEHcsza
	Dlk+NCsGkRkEDBsvxvMJg57Evj87Y7s=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689B1cKC3839630;
	Wed, 9 Sep 2026 16:06:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=J38RGi
	jN+Ynh3uMdjHoMrrjPz4RzXMqA/AaF+1KqLl0=; b=N4+PqsGXlnxR3zPN2dSBga
	j/J7PSM6Vy0V1ybNbFJdwF+n+KNq7syqG4RfLuIUkV1lvmrD5LnvECgpn2tgWBui
	hxYc/KTPeljLp/Y9tXGxVnWv5qFT8HjQJFmgoEFy/EWlo2JIKvhhTIVk2XuzNbaS
	9Z8okgtJz65+c2u0FkBChCP4uGASZebPsHulbVXcOjDEf3+++U2OZWklJejJuANh
	9WLyR9N0uFP7sZ7T89ktfgurJb18ZkpXuDQwKBhdOagVxSKAZYo3rGVwsAQPLuVZ
	xqCvvAyNCMGp5tTzG6LZR1SetpYkFCU4qAdhv4UcF3eN3ee0XOnzQhUnh0DIuudQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbhf6km5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 16:06:56 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 689FuIuh016960;
	Wed, 9 Sep 2026 16:06:56 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ggwdqkbdy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 16:06:55 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 689G6rrc43712868
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Sep 2026 16:06:53 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 790F32004E;
	Wed,  9 Sep 2026 16:06:53 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 15BCE2004D;
	Wed,  9 Sep 2026 16:06:43 +0000 (GMT)
Received: from [9.61.255.18] (unknown [9.61.255.18])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  9 Sep 2026 16:06:42 +0000 (GMT)
Message-ID: <5563177c-96ca-40bd-a513-378b759fad47@linux.ibm.com>
Date: Wed, 9 Sep 2026 21:36:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 21/22] selftests/coredump: simulate a blob store
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
 <20260820-work-coredump-sparse-v2-21-ba32dd718c51@kernel.org>
Content-Language: en-US
From: R Nageswara Sastry <rnsastry@linux.ibm.com>
In-Reply-To: <20260820-work-coredump-sparse-v2-21-ba32dd718c51@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: ECPp3SZdLvYeXZImHelZkDTUn5wmk8x3
X-Authority-Analysis: v=2.4 cv=RIaD2Yi+ c=1 sm=1 tr=0 ts=6aa18421 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=LyCfBNzgLuTRjMANzUkA:9 a=uYE9TVJzJjuILj13:21
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE3OCBTYWx0ZWRfX6X9MMCBhuj9/
 Zb2h0fwYl7UHgE/g3cXSxAY8aIEsBKVV6KbLcZze3CQZBJq3oQUBg0yfYSQ1cVu/EUEgATzjk+v
 WeRtFWuNvJYtPZiQVibiaj/cemDhqks=
X-Proofpoint-ORIG-GUID: DytZI0PBxIhdGf4P0Kfba3Ufh0Zzh8Yx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE3OCBTYWx0ZWRfX7MayvEp7aKIS
 i0vkEpfwgKMOvbltlE4OJ9Y52QFr43M6KOyP5mfjcD5XL+1W2fBmd1AeQEh01Y11PtE1xK9uPRx
 5yEpX6z3v03QH2J5ddxvxY7Ot2t2sRJeGKT7H4MfgIm+XiiyhaK02RY19Xq+5IKR2sR7vceMw1S
 KcWmqJR7GFHfhro4QUD0FC4+t1vPBKg/VqT2AKaWjRYoPeHbWkdjpGZoszOyALSeuJEGHnjW+pW
 TS/NOrfwDDX3CmV1K2z+WWwWJC6Z4VjmNuBFYI2G/86EJg06BUYQ3jaRUwRKK6M/pWGuK1rP6lD
 A7A5MEGhtcEQY+uoqXJEfC9c+qYvdH7OyiHpC/1f5M2Qh35wc3UOwWkW85EgIQht2B83vfLelji
 d8qYEnssG8lXSwiJe1MkMkdMJAttRbsE2CkMtV7JqN6UKMvRcpkDkelQJkMSvVE/prLaT8D0r+t
 zMsfAtJ6YXtDkpPrLBw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 adultscore=0 phishscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090178
X-Rspam-User: 
X-Rspamd-Queue-Id: 2870A1A0009
X-Stat-Signature: ej7k8jktysuwyb9a4zok8t5jm6zu7efq
X-Rspamd-Server: rspam01
X-HE-Tag: 1788970026-971760
X-HE-Meta: U2FsdGVkX18oLRdNsvGJwPZ0V5WISd+Om4CDi1N33MUQyaYGqYCwAbVQxi9LeCekD+BxeziUDc3HupntNCvoFYhiUydktLOTuYZ9KQW2IJLzIDmRPQuLH6aL0qmre+pz0co2pqOKqQpGFpBrY8xlLZoS4xdsaax5WTlOIKUt02BNaANvTMTpNm3oBpqBIYtkL0RW2UQfOFvDjGHDUkNv2ZXU6b2pLTeWKbJLvFhwhM6cTDJumWouDrl2pw3sakqG4Wr739ffuv1H67CnrXxW2mGhlE1eU4//fkr8t596jhNhUS587t9huPATkWix70WC8JTO6CDV8wxiY45qFkLOr9klb7dtjTwXPVKXctUCvG0xg/HviELTbh7uMNCOzNI/AdCmpCWTskKP69VBTVPYLkjc0ZXdGj5gXTcQmAxNm5/7f9leyYrEQE8jo9XzqdTOkmaz8WC6vaTAQyIzYwkiWsML9ONqCulsR9FJ1aOLfTXFrb8Fupya4zy1k+eT1Upj/6h6daAyfM8HO5Pu0hqkTOOA/EHlvb0hF6oOAupE4LYKP21lkgCruKOQlsj2lVwG9PVpFrZiSAd/QblJyRZH0K5j9qzz3TNLiaKD662iXixSAwWA0D1Vv3a/r8uqgwUCfAA2//6oub/zcHdRAvKGetCoVy+ENJNF9rP5Ehl8afnAEVOoBT3gyrOtmkV6Uo3LNQDNKJCOvvHayTwxlBI/t2MTUsjfspfjyy1eJB72OxB/TPBRbSjs7a+ZxRrqnTGWIC1tHEvVPYypAljO9IZAtnis+TDLQuqOOz9Lx51GRaaCG9d4Bix/90FckyiC1HHu14ipLzLi2xxUlb72gcvKaN6aFid19/5GxXW47dXMyAFQ5/WCEZM+T4IZ7VH88LUEP8/sX77zf0knm27ZS5RVscB2ev64PdvnmfzLJvLY5hg306gEQ8d1VT+W3XJrWiKZ3EzDa34bGRZBJBw+kt5
 9U6e/yJ1
 rRvoJh7H/r6xrv8swWtbkY/octGn6uxKvvsUvQarLE1SZu6UDtof+3B0jP+AKdt07j0/fI2gvjU1QerhyC2NmKJtZOEg8HJw5o2pCeEYKWbGzryZs8G4L+eRMjMF/naFkn/Uj3NcrZqtplOaJlaxPl2qZ5+dWMIucdYL3Un2qxyZ6BbAohiE8h/ko/BV9EFvWGsNE449HKj815phHy/UDxKeNUplHeNzNoB8IhAYgf5eKB9nwqdtWpjcU/gIwJFeWC5G9DvbFmjJFKDjd4gtqff5MwmzK11SvhbThRhORPwUWmHcjsVvIWFyPfmGTs4C1AwZe/p2IJeNP/+37UNUo6o38sDY1rrYuyixTxBoh5bUVa2eCcJi2sWb9QI1cT165676RGvvSM9h13DU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20.08.2026 4:39 AM, Christian Brauner wrote:
> A coredump server that uploads to a blob store must redescribe the
> coredump and fixup the phdr.
>
> A segment is split wherever a hole was left out and everything a segment
> covers past p_filesz is zeroes anyway. So the blob store ends up with an
> ordinary ELF core file that is missing nothing but holes. Nothing
> downstream of the server has to learn a container format.
>
> The coredump with its holes still in it is reassembled alongside the
> object so the two can be compared.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>

System: ppc64le LPAR (IBM POWER), Linux 7.3-rc2
> ---
>   .../coredump/coredump_socket_protocol_test.c       | 156 +++++
>   .../selftests/coredump/coredump_test_helpers.c     | 765 +++++++++++++++++++++
>   .../selftests/coredump/coredump_test_helpers.h     |   3 +
>   3 files changed, 924 insertions(+)
>
> diff --git a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
> index abf6e2c4c354..f33eaf2fa93d 100644
> --- a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
> +++ b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
> @@ -1882,6 +1882,162 @@ TEST_F(coredump, socket_request_records_truncated)
>   	ASSERT_GT(received, 0);
>   }
>   
> +/*
> + * A coredump server that uploads to a blob store can't upload a sparse
> + * file. It doesn't have to: it streams the data records into the object
> + * as they arrive, leaves the holes out, and uploads the corrected
> + * program header table last. What it ends up with is an ordinary ELF
> + * core file that describes the same memory as the coredump the records
> + * came from, minus the holes.
> + */
> +TEST_F(coredump, socket_request_sparse_blob_upload)
> +{
> +	int fd_core_file, pidfd, status;
> +	pid_t pid, pid_coredump_server;
> +	struct pidfd_info info = {};
> +	off_t coredump_size = 0;
> +	ssize_t received = 0;
> +	int ipc_sockets[2];
> +	int pipefds[2];
> +	struct stat st;
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
> +		int fd_object = -1, fd_reference = -1;
> +		int exit_code = EXIT_FAILURE;
> +		struct coredump_req req = {};
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
> +		/* The object is a plain file. It never sees a hole. */
> +		fd_object = open("/tmp/coredump.file",
> +				 O_RDWR | O_CREAT | O_TRUNC | O_CLOEXEC, 0600);
> +		if (fd_object < 0)
> +			goto out;
> +
> +		/*
> +		 * The coredump with its holes still in it is bigger than
> +		 * the mapping the child made, so keep it on the detached
> +		 * tmpfs and sparse.
> +		 */
> +		fd_reference = open_coredump_tmpfile(self->fd_tmpfs_detached);
> +		if (fd_reference < 0)
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
> +		ret = recv_coredump_compact(fd_coredump, fd_object,
> +					    fd_reference, &size);
> +		if (ret < 0)
> +			goto out;
> +
> +		if (check_compact_coredump(fd_object, fd_reference))
> +			goto out;
> +
> +		if (write_nointr(pipefds[1], &ret, sizeof(ret)) != sizeof(ret))
> +			goto out;
> +		if (write_nointr(pipefds[1], &size, sizeof(size)) != sizeof(size))
> +			goto out;
> +
> +		exit_code = EXIT_SUCCESS;
> +out:
> +		close(pipefds[1]);
> +		if (fd_reference >= 0)
> +			close(fd_reference);
> +		if (fd_object >= 0)
> +			close(fd_object);
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
> +	ASSERT_TRUE(WCOREDUMP(status));
> +
> +	ASSERT_EQ(read_nointr(pipefds[0], &received, sizeof(received)),
> +		  sizeof(received));
> +	ASSERT_EQ(read_nointr(pipefds[0], &coredump_size, sizeof(coredump_size)),
> +		  sizeof(coredump_size));
> +	EXPECT_EQ(close(pipefds[0]), 0);
> +
> +	ASSERT_TRUE(get_pidfd_info(pidfd, &info));
> +	ASSERT_GT((info.mask & PIDFD_INFO_COREDUMP), 0);
> +	ASSERT_GT((info.coredump_mask & PIDFD_COREDUMPED), 0);
> +
> +	wait_and_check_coredump_server(pid_coredump_server, _metadata, self);
> +
> +	/* The mapping is in the coredump, holes included. */
> +	ASSERT_GT(coredump_size, (off_t)SPARSE_MAPPING_SIZE);
> +
> +	/* The object isn't sparse and doesn't carry them. */
> +	ASSERT_EQ(stat("/tmp/coredump.file", &st), 0);
> +	ASSERT_LT(st.st_size, coredump_size / 8);
> +
> +	/* And a debugger still sees an ordinary ELF core file. */
> +	fd_core_file = open("/tmp/coredump.file", O_RDONLY | O_CLOEXEC);
> +	ASSERT_GE(fd_core_file, 0);
> +	ASSERT_TRUE(is_elf_core(fd_core_file));
> +	EXPECT_EQ(close(fd_core_file), 0);
> +}
> +
>   /* Ack @ack_mask, expect the kernel to refuse it as conflicting. */
>   static void check_conflicting_ack(struct __test_metadata *const _metadata,
>   				  FIXTURE_DATA(coredump) *self, __u64 ack_mask)
> diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
> index 89f3954c5607..9346b8f688e2 100644
> --- a/tools/testing/selftests/coredump/coredump_test_helpers.c
> +++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
> @@ -330,6 +330,771 @@ bool is_elf_core(int fd)
>   	return true;
>   }
>   
> +/*
> + * A coredump server that uploads to a blob store can't upload a sparse
> + * file and can't seek in the object it is uploading. It streams the data
> + * records into the object as they arrive, remembers the holes it left
> + * out, and uploads the program header table that describes the result
> + * last. What comes out is an ordinary ELF core file without the holes.
> + */
> +
> +/* A run of the coredump the object doesn't carry. */
> +struct compact_hole {
> +	__u64 offset;
> +	__u64 len;
> +};
> +
> +/* A program header of the object and where its bytes sat in the coredump. */
> +struct compact_piece {
> +	ElfW(Phdr) phdr;
> +	__u64 src;
> +};
> +
> +struct compact_ctx {
> +	int fd_body;			/* the object's payload, append only */
> +	int fd_reference;		/* the coredump with its holes, for the test */
> +	unsigned char *head;		/* everything ahead of the segment data */
> +	size_t head_len;
> +	size_t head_cap;
> +	__u64 data_offset;		/* where the segment data starts, 0 while unknown */
> +	struct compact_hole *holes;
> +	size_t nr_holes;
> +	size_t holes_cap;
> +	__u64 body_len;
> +};
> +
> +/* Write @len bytes out, short writes and all. */
> +static int compact_write(int fd, const void *buf, size_t len)
> +{
> +	const unsigned char *pos = buf;
> +
> +	while (len) {
> +		ssize_t ret = write(fd, pos, len);
> +
> +		if (ret <= 0) {
> +			fprintf(stderr, "%s: write failed: %m\n", __func__);
> +			return -1;
> +		}
> +
> +		pos += ret;
> +		len -= ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Keep @len bytes of the head, or @len zeroes if @buf is NULL. */
> +static int compact_head_append(struct compact_ctx *ctx, const void *buf,
> +			       size_t len)
> +{
> +	if (ctx->head_len + len > ctx->head_cap) {
> +		size_t cap = ctx->head_cap ? ctx->head_cap : PAGE_SIZE;
> +		unsigned char *head;
> +
> +		while (cap < ctx->head_len + len)
> +			cap *= 2;
> +
> +		head = realloc(ctx->head, cap);
> +		if (!head) {
> +			fprintf(stderr, "%s: out of memory\n", __func__);
> +			return -1;
> +		}
> +		ctx->head = head;
> +		ctx->head_cap = cap;
> +	}
> +
> +	if (buf)
> +		memcpy(ctx->head + ctx->head_len, buf, len);
> +	else
> +		memset(ctx->head + ctx->head_len, 0, len);
> +	ctx->head_len += len;
> +
> +	return 0;
> +}
> +
> +/* Remember a hole so the program header table can account for it later. */
> +static int compact_keep_hole(struct compact_ctx *ctx, __u64 offset, __u64 len)
> +{
> +	if (ctx->nr_holes == ctx->holes_cap) {
> +		size_t cap = ctx->holes_cap ? ctx->holes_cap * 2 : 64;
> +		struct compact_hole *holes;
> +
> +		holes = realloc(ctx->holes, cap * sizeof(*holes));
> +		if (!holes) {
> +			fprintf(stderr, "%s: out of memory\n", __func__);
> +			return -1;
> +		}
> +		ctx->holes = holes;
> +		ctx->holes_cap = cap;
> +	}
> +
> +	ctx->holes[ctx->nr_holes].offset = offset;
> +	ctx->holes[ctx->nr_holes].len = len;
> +	ctx->nr_holes++;
> +
> +	return 0;
> +}
> +
> +/* The segment data starts where the first PT_LOAD points. */
> +static int compact_probe(struct compact_ctx *ctx)
> +{
> +	const ElfW(Ehdr) *ehdr = (const ElfW(Ehdr) *)ctx->head;
> +	const ElfW(Phdr) *phdr;
> +	size_t i;
> +
> +	if (ctx->data_offset || ctx->head_len < sizeof(*ehdr))
> +		return 0;
> +
> +	if (!is_core_ehdr(ehdr)) {
> +		fprintf(stderr, "%s: not an ELF core file\n", __func__);
> +		return -1;
> +	}
> +
> +	if (ehdr->e_phoff != sizeof(*ehdr) ||
> +	    ehdr->e_phentsize != sizeof(ElfW(Phdr)) ||
> +	    ehdr->e_phnum == 0 || ehdr->e_phnum == PN_XNUM) {
> +		fprintf(stderr, "%s: unhandled program header table\n", __func__);
> +		return -1;
> +	}
> +
> +	if (ctx->head_len < ehdr->e_phoff +
> +			    (size_t)ehdr->e_phnum * ehdr->e_phentsize)
> +		return 0;
> +
> +	phdr = (const ElfW(Phdr) *)(ctx->head + ehdr->e_phoff);
> +	for (i = 0; i < ehdr->e_phnum; i++) {
> +		if (phdr[i].p_type != PT_LOAD)
> +			continue;
> +		if (!ctx->data_offset || phdr[i].p_offset < ctx->data_offset)
> +			ctx->data_offset = phdr[i].p_offset;
> +	}
> +
> +	if (!ctx->data_offset) {
> +		fprintf(stderr, "%s: coredump without a single segment\n",
> +			__func__);
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Take whatever of [@offset, @offset + @len) still belongs to the head.
> + * @buf is NULL for a hole. Returns how much was taken.
> + */
> +static ssize_t compact_head_take(struct compact_ctx *ctx, const void *buf,
> +				 __u64 offset, __u64 len)
> +{
> +	__u64 chunk;
> +
> +	if (!len || (ctx->data_offset && offset >= ctx->data_offset))
> +		return 0;
> +
> +	chunk = len;
> +	if (ctx->data_offset && offset + chunk > ctx->data_offset)
> +		chunk = ctx->data_offset - offset;
> +
> +	if (offset != ctx->head_len) {
> +		fprintf(stderr, "%s: head has a gap at %llu\n", __func__,
> +			(unsigned long long)offset);
> +		return -1;
> +	}
> +
> +	if (compact_head_append(ctx, buf, chunk))
> +		return -1;
> +
> +	return chunk;
> +}
> +
> +static int compact_data(void *arg, const void *buf, size_t len, __u64 offset)
> +{
> +	struct compact_ctx *ctx = arg;
> +	const unsigned char *pos = buf;
> +	ssize_t head;
> +
> +	/* Only the test needs a coredump with the holes still in it. */
> +	if (pwrite(ctx->fd_reference, pos, len, offset) != (ssize_t)len) {
> +		fprintf(stderr, "%s: pwrite failed: %m\n", __func__);
> +		return -1;
> +	}
> +
> +	/* The head has to be rewritten at the end, so hold on to it. */
> +	head = compact_head_take(ctx, pos, offset, len);
> +	if (head < 0)
> +		return -1;
> +	if (head && compact_probe(ctx))
> +		return -1;
> +
> +	pos += head;
> +	len -= head;
> +	if (!len)
> +		return 0;
> +
> +	/* Everything else goes into the object as it arrives. */
> +	if (compact_write(ctx->fd_body, pos, len))
> +		return -1;
> +	ctx->body_len += len;
> +
> +	return 0;
> +}
> +
> +static int compact_zero(void *arg, __u64 offset, __u64 len)
> +{
> +	struct compact_ctx *ctx = arg;
> +	ssize_t head;
> +
> +	/* A hole in the head is alignment padding. Write it out. */
> +	head = compact_head_take(ctx, NULL, offset, len);
> +	if (head < 0)
> +		return -1;
> +
> +	offset += head;
> +	len -= head;
> +	if (!len)
> +		return 0;
> +
> +	/* This is what the object doesn't have to carry. */
> +	return compact_keep_hole(ctx, offset, len);
> +}
> +
> +/* Where @offset ends up in the object once the holes ahead of it are gone. */
> +static __u64 compact_offset(const struct compact_ctx *ctx, __u64 body_start,
> +			    __u64 offset)
> +{
> +	__u64 elided = 0;
> +	size_t i;
> +
> +	for (i = 0; i < ctx->nr_holes; i++) {
> +		__u64 len = ctx->holes[i].len;
> +
> +		if (ctx->holes[i].offset >= offset)
> +			break;
> +		if (ctx->holes[i].offset + len > offset)
> +			len = offset - ctx->holes[i].offset;
> +		elided += len;
> +	}
> +
> +	return body_start + (offset - ctx->data_offset) - elided;
> +}
> +
> +/* A run of segment data that made it into the object. */
> +static void compact_add_data(struct compact_piece *pieces, size_t *nr,
> +			     const ElfW(Phdr) *phdr, __u64 start, __u64 end)
> +{
> +	struct compact_piece *piece = &pieces[(*nr)++];
> +
> +	piece->phdr = *phdr;
> +	piece->phdr.p_vaddr = phdr->p_vaddr + (start - phdr->p_offset);
> +	piece->phdr.p_paddr = 0;
> +	piece->phdr.p_filesz = end - start;
> +	piece->phdr.p_memsz = end - start;
> +	piece->src = start;
> +}
> +
> +/*
> + * A run of @len bytes the object doesn't carry. It grows the piece in
> + * front of it if this segment already has one, because everything a
> + * segment covers past p_filesz is zeroes anyway.
> + */
> +static void compact_add_zero(struct compact_piece *pieces, size_t *nr,
> +			     size_t first, const ElfW(Phdr) *phdr, __u64 vaddr,
> +			     __u64 len)
> +{
> +	struct compact_piece *piece;
> +
> +	if (*nr > first) {
> +		pieces[*nr - 1].phdr.p_memsz += len;
> +		return;
> +	}
> +
> +	piece = &pieces[(*nr)++];
> +	piece->phdr = *phdr;
> +	piece->phdr.p_vaddr = vaddr;
> +	piece->phdr.p_paddr = 0;
> +	piece->phdr.p_filesz = 0;
> +	piece->phdr.p_memsz = len;
> +	piece->src = 0;
> +}
> +
> +/* Split the segments at the holes and write out what the object became. */
> +static int compact_build(struct compact_ctx *ctx, int fd_object)
> +{
> +	__u64 note_offset = 0, note_len = 0, note_new;
> +	__u64 align = 0, head_len, body_start, pos;
> +	size_t nr_old, nr_new = 0, note_piece = 0, i;
> +	struct compact_piece *pieces;
> +	char buffer[PAGE_SIZE];
> +	const ElfW(Phdr) *old;
> +	ElfW(Ehdr) ehdr;
> +	int ret = -1;
> +
> +	if (!ctx->data_offset) {
> +		fprintf(stderr, "%s: coredump without segment data\n", __func__);
> +		return -1;
> +	}
> +
> +	memcpy(&ehdr, ctx->head, sizeof(ehdr));
> +	if (ehdr.e_shoff) {
> +		fprintf(stderr, "%s: section headers are not handled\n",
> +			__func__);
> +		return -1;
> +	}
> +
> +	old = (const ElfW(Phdr) *)(ctx->head + ehdr.e_phoff);
> +	nr_old = ehdr.e_phnum;
> +
> +	pieces = calloc(nr_old + 2 * ctx->nr_holes + 1, sizeof(*pieces));
> +	if (!pieces) {
> +		fprintf(stderr, "%s: out of memory\n", __func__);
> +		return -1;
> +	}
> +
> +	for (i = 0; i < nr_old; i++) {
> +		ElfW(Phdr) phdr = old[i];
> +		__u64 end = phdr.p_offset + phdr.p_filesz;
> +		__u64 cur = phdr.p_offset;
> +		size_t first = nr_new, h;
> +
> +		/* The notes move because the table in front of them grows. */
> +		if (phdr.p_type == PT_NOTE) {
> +			if (note_len) {
> +				fprintf(stderr, "%s: more than one note segment\n",
> +					__func__);
> +				goto out;
> +			}
> +			note_offset = phdr.p_offset;
> +			note_len = phdr.p_filesz;
> +			note_piece = nr_new;
> +			pieces[nr_new].phdr = phdr;
> +			pieces[nr_new++].src = 0;
> +			continue;
> +		}
> +
> +		if (phdr.p_type != PT_LOAD) {
> +			if (phdr.p_filesz && phdr.p_offset < ctx->data_offset) {
> +				fprintf(stderr, "%s: segment %zu is in the head\n",
> +					__func__, i);
> +				goto out;
> +			}
> +			pieces[nr_new].phdr = phdr;
> +			pieces[nr_new++].src = phdr.p_offset;
> +			continue;
> +		}
> +
> +		if (!align)
> +			align = phdr.p_align;
> +
> +		for (h = 0; h < ctx->nr_holes && cur < end; h++) {
> +			__u64 start = ctx->holes[h].offset;
> +			__u64 stop = start + ctx->holes[h].len;
> +
> +			if (stop <= cur)
> +				continue;
> +			if (start >= end)
> +				break;
> +
> +			/* A hole can span more than this one segment. */
> +			if (start < cur)
> +				start = cur;
> +			if (stop > end)
> +				stop = end;
> +
> +			if (start > cur) {
> +				compact_add_data(pieces, &nr_new, &phdr, cur,
> +						 start);
> +				cur = start;
> +			}
> +			compact_add_zero(pieces, &nr_new, first, &phdr,
> +					 phdr.p_vaddr + (cur - phdr.p_offset),
> +					 stop - cur);
> +			cur = stop;
> +		}
> +
> +		if (cur < end)
> +			compact_add_data(pieces, &nr_new, &phdr, cur, end);
> +
> +		/* Whatever the kernel didn't dump of this mapping. */
> +		if (phdr.p_memsz > phdr.p_filesz)
> +			compact_add_zero(pieces, &nr_new, first, &phdr,
> +					 phdr.p_vaddr + phdr.p_filesz,
> +					 phdr.p_memsz - phdr.p_filesz);
> +	}
> +
> +	if (!note_len || note_offset + note_len > ctx->head_len) {
> +		fprintf(stderr, "%s: notes aren't where they should be\n",
> +			__func__);
> +		goto out;
> +	}
> +
> +	if (nr_new >= PN_XNUM) {
> +		fprintf(stderr, "%s: %zu program headers don't fit\n", __func__,
> +			nr_new);
> +		goto out;
> +	}
> +
> +	if (!align || (align & (align - 1)))
> +		align = sysconf(_SC_PAGESIZE);
> +
> +	note_new = sizeof(ehdr) + (__u64)nr_new * sizeof(ElfW(Phdr));
> +	head_len = note_new + note_len;
> +	body_start = (head_len + align - 1) & ~(align - 1);
> +
> +	for (i = 0; i < nr_new; i++) {
> +		struct compact_piece *piece = &pieces[i];
> +
> +		if (i == note_piece)
> +			piece->phdr.p_offset = note_new;
> +		else if (piece->phdr.p_filesz)
> +			piece->phdr.p_offset = compact_offset(ctx, body_start,
> +							      piece->src);
> +		else
> +			piece->phdr.p_offset = 0;
> +	}
> +
> +	/* Only now is the head known. That's why it is uploaded last. */
> +	ehdr.e_phnum = nr_new;
> +	if (compact_write(fd_object, &ehdr, sizeof(ehdr)))
> +		goto out;
> +
> +	for (i = 0; i < nr_new; i++)
> +		if (compact_write(fd_object, &pieces[i].phdr,
> +				  sizeof(pieces[i].phdr)))
> +			goto out;
> +
> +	if (compact_write(fd_object, ctx->head + note_offset, note_len))
> +		goto out;
> +
> +	/* Keep the segments aligned the way a debugger expects them. */
> +	memset(buffer, 0, sizeof(buffer));
> +	for (pos = head_len; pos < body_start; ) {
> +		__u64 chunk = body_start - pos;
> +
> +		if (chunk > sizeof(buffer))
> +			chunk = sizeof(buffer);
> +		if (compact_write(fd_object, buffer, chunk))
> +			goto out;
> +		pos += chunk;
> +	}
> +
> +	/* Putting the parts together is the blob store's job. Do it here. */
> +	for (pos = 0; pos < ctx->body_len; ) {
> +		ssize_t chunk = pread(ctx->fd_body, buffer, sizeof(buffer), pos);
> +
> +		if (chunk <= 0) {
> +			fprintf(stderr, "%s: short read %zd: %m\n", __func__,
> +				chunk);
> +			goto out;
> +		}
> +		if (compact_write(fd_object, buffer, chunk))
> +			goto out;
> +		pos += chunk;
> +	}
> +
> +	fprintf(stderr, "Object is %llu bytes in %zu program headers, %zu holes left out\n",
> +		(unsigned long long)(body_start + ctx->body_len), nr_new,
> +		ctx->nr_holes);
> +	ret = 0;
> +out:
> +	free(pieces);
> +	return ret;
> +}
> +
> +/*
> + * Reassemble a record stream into an ELF core file that has no holes in
> + * it, the way a coredump server that uploads to a blob store has to. If
> + * @fd_reference is valid it gets the coredump the records describe,
> + * holes and all, so the test can compare the two.
> + */
> +ssize_t recv_coredump_compact(int fd_coredump, int fd_object, int fd_reference,
> +			      off_t *coredump_size)
> +{
> +	struct compact_ctx ctx = {
> +		.fd_body	= -1,
> +		.fd_reference	= fd_reference,
> +	};
> +	struct coredump_record_sink sink = {
> +		.data	= compact_data,
> +		.zero	= compact_zero,
> +		.ctx	= &ctx,
> +	};
> +	ssize_t received;
> +	off_t size = 0;
> +	FILE *body;
> +
> +	body = tmpfile();
> +	if (!body) {
> +		fprintf(stderr, "%s: tmpfile failed: %m\n", __func__);
> +		return -1;
> +	}
> +	ctx.fd_body = fileno(body);
> +
> +	/* An upload is appended to. Make sure nothing here can seek. */
> +	if (fcntl(ctx.fd_body, F_SETFL, O_APPEND)) {
> +		fprintf(stderr, "%s: F_SETFL failed: %m\n", __func__);
> +		received = -1;
> +		goto out;
> +	}
> +
> +	received = __recv_coredump_records(fd_coredump, &sink, &size, NULL, -1);
> +	if (received < 0)
> +		goto out;
> +
> +	/*
> +	 * Nothing is written for a hole, so grow the reference to the size
> +	 * the records describe in case the coredump ended in one.
> +	 */
> +	if (ftruncate(fd_reference, size) < 0) {
> +		fprintf(stderr, "%s: ftruncate to %llu failed: %m\n",
> +			__func__, (unsigned long long)size);
> +		received = -1;
> +		goto out;
> +	}
> +
> +	if (compact_build(&ctx, fd_object)) {
> +		received = -1;
> +		goto out;
> +	}
> +
> +	if (coredump_size)
> +		*coredump_size = size;
> +out:
> +	fclose(body);
> +	free(ctx.head);
> +	free(ctx.holes);
> +	return received;
> +}
> +
> +/* Read the ELF header and the program header table of @fd. */
> +static ElfW(Phdr) *read_phdrs(int fd, size_t *nr)
> +{
> +	ElfW(Ehdr) ehdr;
> +	ElfW(Phdr) *phdr;
> +	size_t size;
> +
> +	if (pread(fd, &ehdr, sizeof(ehdr), 0) != sizeof(ehdr)) {
> +		fprintf(stderr, "%s: no ELF header: %m\n", __func__);
> +		return NULL;
> +	}
> +
> +	if (!is_core_ehdr(&ehdr) || !ehdr.e_phnum ||
> +	    ehdr.e_phentsize != sizeof(*phdr)) {
> +		fprintf(stderr, "%s: not an ELF core file\n", __func__);
> +		return NULL;
> +	}
> +
> +	size = (size_t)ehdr.e_phnum * ehdr.e_phentsize;
> +	phdr = malloc(size);
> +	if (!phdr) {
> +		fprintf(stderr, "%s: out of memory\n", __func__);
> +		return NULL;
> +	}
> +
> +	if (pread(fd, phdr, size, ehdr.e_phoff) != (ssize_t)size) {
> +		fprintf(stderr, "%s: short program header table: %m\n", __func__);
> +		free(phdr);
> +		return NULL;
> +	}
> +
> +	*nr = ehdr.e_phnum;
> +	return phdr;
> +}
> +
> +/* The segment @vaddr falls into. */
> +static const ElfW(Phdr) *find_segment(const ElfW(Phdr) *phdr, size_t nr,
> +				      __u64 vaddr)
> +{
> +	size_t i;
> +
> +	for (i = 0; i < nr; i++) {
> +		if (phdr[i].p_type != PT_LOAD)
> +			continue;
> +		if (vaddr >= phdr[i].p_vaddr &&
> +		    vaddr < phdr[i].p_vaddr + phdr[i].p_memsz)
> +			return &phdr[i];
> +	}
> +
> +	return NULL;
> +}
> +
> +/* The next stretch of memory the segments cover, split ones merged back. */
> +static bool next_range(const ElfW(Phdr) *phdr, size_t nr, size_t *i,
> +		       __u64 *start, __u64 *end)
> +{
> +	while (*i < nr && phdr[*i].p_type != PT_LOAD)
> +		(*i)++;
> +
> +	if (*i >= nr)
> +		return false;
> +
> +	*start = phdr[*i].p_vaddr;
> +	*end = phdr[*i].p_vaddr + phdr[*i].p_memsz;
> +	(*i)++;
> +
> +	while (*i < nr) {
> +		if (phdr[*i].p_type != PT_LOAD) {
> +			(*i)++;
> +			continue;
> +		}
> +		if (phdr[*i].p_vaddr != *end)
> +			break;
> +		*end = phdr[*i].p_vaddr + phdr[*i].p_memsz;
> +		(*i)++;
> +	}
> +
> +	return true;
> +}
> +
> +/* Compare @len bytes at @offset against @len bytes at @offset_ref. */
> +static int compare_range(int fd, __u64 offset, int fd_ref, __u64 offset_ref,
> +			 __u64 len)
> +{
> +	char buffer[PAGE_SIZE], buffer_ref[PAGE_SIZE];
> +
> +	while (len) {
> +		size_t chunk = len < sizeof(buffer) ? len : sizeof(buffer);
> +
> +		if (pread(fd, buffer, chunk, offset) != (ssize_t)chunk ||
> +		    pread(fd_ref, buffer_ref, chunk, offset_ref) != (ssize_t)chunk) {
> +			fprintf(stderr, "%s: short read at %llu: %m\n",
> +				__func__, (unsigned long long)offset);
> +			return -1;
> +		}
> +
> +		if (memcmp(buffer, buffer_ref, chunk)) {
> +			fprintf(stderr, "%s: %llu differs from %llu\n", __func__,
> +				(unsigned long long)offset,
> +				(unsigned long long)offset_ref);
> +			return -1;
> +		}
> +
> +		offset += chunk;
> +		offset_ref += chunk;
> +		len -= chunk;
> +	}
> +
> +	return 0;
> +}
> +
> +/* The @len bytes at @offset the object left out have to have been zeroes. */
> +static int check_zero_range(int fd, __u64 offset, __u64 len)
> +{
> +	static const char zeroes[PAGE_SIZE];
> +	char buffer[PAGE_SIZE];
> +
> +	while (len) {
> +		size_t chunk = len < sizeof(buffer) ? len : sizeof(buffer);
> +
> +		if (pread(fd, buffer, chunk, offset) != (ssize_t)chunk) {
> +			fprintf(stderr, "%s: short read at %llu: %m\n",
> +				__func__, (unsigned long long)offset);
> +			return -1;
> +		}
> +
> +		if (memcmp(buffer, zeroes, chunk)) {
> +			fprintf(stderr, "%s: %llu isn't a hole\n", __func__,
> +				(unsigned long long)offset);
> +			return -1;
> +		}
> +
> +		offset += chunk;
> +		len -= chunk;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * The object has to describe the same memory as the coredump it was built
> + * from, and it has to describe it correctly.
> + */
> +int check_compact_coredump(int fd_object, int fd_reference)
> +{
> +	ElfW(Phdr) *object = NULL, *reference = NULL;
> +	size_t nr_object, nr_reference, i;
> +	size_t io = 0, ir = 0;
> +	int ret = -1;
> +
> +	object = read_phdrs(fd_object, &nr_object);
> +	reference = read_phdrs(fd_reference, &nr_reference);
> +	if (!object || !reference)
> +		goto out;
> +
> +	/* Nothing may have been dropped and nothing may have been added. */
> +	for (;;) {
> +		__u64 start = 0, end = 0, start_ref = 0, end_ref = 0;
> +		bool has, has_ref;
> +
> +		has = next_range(object, nr_object, &io, &start, &end);
> +		has_ref = next_range(reference, nr_reference, &ir, &start_ref,
> +				     &end_ref);
> +		if (!has && !has_ref)
> +			break;
> +
> +		if (has != has_ref || start != start_ref || end != end_ref) {
> +			fprintf(stderr, "%s: object covers 0x%llx-0x%llx, coredump 0x%llx-0x%llx\n",
> +				__func__, (unsigned long long)start,
> +				(unsigned long long)end,
> +				(unsigned long long)start_ref,
> +				(unsigned long long)end_ref);
> +			goto out;
> +		}
> +	}
> +
> +	for (i = 0; i < nr_object; i++) {
> +		const ElfW(Phdr) *segment;
> +		__u64 offset, dumped;
> +
> +		if (object[i].p_type != PT_LOAD || !object[i].p_memsz)
> +			continue;
> +
> +		segment = find_segment(reference, nr_reference,
> +				       object[i].p_vaddr);
> +		if (!segment) {
> +			fprintf(stderr, "%s: 0x%llx isn't in the coredump\n",
> +				__func__,
> +				(unsigned long long)object[i].p_vaddr);
> +			goto out;
> +		}
> +
> +		offset = object[i].p_vaddr - segment->p_vaddr;
> +		dumped = offset < segment->p_filesz ?
> +				 segment->p_filesz - offset : 0;
> +
> +		/* What the object carries is what the coredump had. */
> +		if (object[i].p_filesz > dumped) {
> +			fprintf(stderr, "%s: object carries %llu bytes the coredump doesn't have\n",
> +				__func__,
> +				(unsigned long long)(object[i].p_filesz - dumped));
> +			goto out;
> +		}
> +
> +		if (compare_range(fd_object, object[i].p_offset, fd_reference,
> +				  segment->p_offset + offset,
> +				  object[i].p_filesz))
> +			goto out;
> +
> +		/* And what it left out was a hole. */
> +		if (object[i].p_memsz > object[i].p_filesz &&
> +		    dumped > object[i].p_filesz) {
> +			__u64 left_out = dumped - object[i].p_filesz;
> +
> +			if (left_out > object[i].p_memsz - object[i].p_filesz)
> +				left_out = object[i].p_memsz - object[i].p_filesz;
> +
> +			if (check_zero_range(fd_reference,
> +					     segment->p_offset + offset +
> +					     object[i].p_filesz, left_out))
> +				goto out;
> +		}
> +	}
> +
> +	ret = 0;
> +out:
> +	free(object);
> +	free(reference);
> +	return ret;
> +}
> +
>   int create_detached_tmpfs(void)
>   {
>   	int fd_context, fd_tmpfs;
> diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.h b/tools/testing/selftests/coredump/coredump_test_helpers.h
> index fe0a88a71b05..00d695b67b3f 100644
> --- a/tools/testing/selftests/coredump/coredump_test_helpers.h
> +++ b/tools/testing/selftests/coredump/coredump_test_helpers.h
> @@ -26,6 +26,9 @@ ssize_t recv_coredump_records(int fd_coredump, int fd_core_file,
>   			      off_t *coredump_size, bool *truncated,
>   			      int fd_peer_pidfd);
>   bool is_elf_core(int fd);
> +ssize_t recv_coredump_compact(int fd_coredump, int fd_object, int fd_reference,
> +			      off_t *coredump_size);
> +int check_compact_coredump(int fd_object, int fd_reference);
>   int create_detached_tmpfs(void);
>   int create_and_listen_unix_socket(const char *path);
>   bool set_core_pattern(const char *pattern);
>
-- 
Thanks and Regards
R.Nageswara Sastry


