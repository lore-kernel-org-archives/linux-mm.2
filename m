Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0325C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC8266B00A1; Wed,  9 Sep 2026 11:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9F8E6B00A2; Wed,  9 Sep 2026 11:55:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8EED6B00A3; Wed,  9 Sep 2026 11:55:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F7B16B00A1
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:55:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F0BD3120241
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:55:41 +0000 (UTC)
X-FDA: 85194674082.10.2C59F75
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf03.hostedemail.com (Postfix) with ESMTP id 695602000B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:55:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mBFdy8Ef;
	spf=pass (imf03.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788969339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVlPobEw7sYvhIuAsEh6LBacuzFL7HQuKo2Vp2QvpKg=;
	b=HafBUsJ/oDx1IIqjyqpzctYPRKJ1lJoeBBt9tU8wceKZqruo8vpA8h5RppZinPb7WbRdLL
	fIdez7nYatXrYb5qvSQouRaU8t8rJBW5glWro/h/oYd/W6Xjvr1NcHk+ZcAprO+Yy8E5PH
	skMo/lE95n877JrtUU3RFhDgOqFujbg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788969339;
	b=XxuuTPxxEbT99dBzms2dHmZEgXWbC0ld2ZMY5aHBKkxsNVd/+mQ3DQpfICQEnP/D/Ov/AW
	F/WVPNruXlJHOJU3LsZ90yxeafuNokxHieFQ7/I9MB0PeZM0LAartGZGpLVwPJMqPLRxQC
	X9nMEdYCud6NcefbWbaZV8Nfr0yjlkU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mBFdy8Ef;
	spf=pass (imf03.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689B1klg1931243;
	Wed, 9 Sep 2026 15:55:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cVlPob
	Ew7sYvhIuAsEh6LBacuzFL7HQuKo2Vp2QvpKg=; b=mBFdy8EfzWBHANNnk9SjdC
	av+eeYLpDGdGvJI2l3h26/be2J1G6SEocn6nlIzkd+8/2i3ZFVmBTUya484s9YDt
	Vdf6sHo/mQJLWsXlXUB2kwB2/979VR2CcjwPsy365sJKN2bl8vKGRtHUNbI8CkjV
	p+L3vX88qq8n2bpTf529phHGRYLgaBOrCwX6b6YabSa5ZbRdEzgerDE8ESddQjN2
	Fvx5UyPzX8p7PFphek/awyv9XaD8B1OMdXaRAbWQM7DMHyvDWEXZXnw15YLZC+eu
	5+vErzgxcNN3k+EF8KWk4Ps/xfUHWwOOIzbxpRg+b6dbshVWuGPeyBeIatBe6lLw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbqk6vxp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 15:55:30 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 689FfFp8028737;
	Wed, 9 Sep 2026 15:55:29 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gh03yjxdt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 15:55:29 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 689FtROe38535622
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Sep 2026 15:55:28 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D47B620040;
	Wed,  9 Sep 2026 15:55:27 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6FA7620043;
	Wed,  9 Sep 2026 15:55:18 +0000 (GMT)
Received: from [9.61.255.18] (unknown [9.61.255.18])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  9 Sep 2026 15:55:18 +0000 (GMT)
Message-ID: <e63b933a-62f4-4a6c-a212-51e756e09e33@linux.ibm.com>
Date: Wed, 9 Sep 2026 21:25:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/22] selftests/coredump: add a separate helper header
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
 <20260820-work-coredump-sparse-v2-6-ba32dd718c51@kernel.org>
Content-Language: en-US
From: R Nageswara Sastry <rnsastry@linux.ibm.com>
In-Reply-To: <20260820-work-coredump-sparse-v2-6-ba32dd718c51@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: -GMIu20S0TniOfQ60BcvKmA0xllf-m6x
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE3MyBTYWx0ZWRfX61sTyWDZzHhO
 vAW96M28cUm3istQNjY6HSsfJMd2gTfjtUgG6p7YYxV/g1DXYPC5tdZYjAteip1DFY3fdFmwDEa
 2w7DIjaYbJAtNLOPC7cbRqQE+9aBGoQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE3MyBTYWx0ZWRfX0dqDXbIZPQcy
 GXkNRAzJm9pDBTQAufVLC42a4PfAEuLn+8mNeiiZ4hYADx+dx1RhX2pPBHtQXUuFXqhPqo6lFam
 rZGPWNqTwFz0CesA8IqB1cQqVoGZ14Fp8wabNTTayPkIo2RuH8vu1vCMNkGu4+nY6qYJgN/nWEp
 W8iH2tyaKB0KxnUumZi/3g762GuHNa3k/u6CWoLppUm2lBANA0GWIgb/HNEZi5P523nMlDSBIXl
 OCD4/GxczRhY1TjLvgUEpeYnlP3doEDNzq+HBNiRnnHhskg0A4w7uRwr5BhviV/9uApMoMi6azA
 aixa+l0Sp/qMsHb5hC2vQPoKuADz4R8taZ7/FE0yAPa9QBrCE6+QNRSyInW4KPPCImmLmLi7lfp
 q2M3NiDdr2RX1BeY8lANZD2APxsX/cqtTNlpT7W0m7tHeDgnZh0VyjvMtT0Co2FgcwphhBrjGeE
 jGOdYiFOR8Mu/zGr0ww==
X-Authority-Analysis: v=2.4 cv=JaKMa0KV c=1 sm=1 tr=0 ts=6aa18173 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=NZGyf6CBCNZNBOKdOmEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: On-5XT6OAYh5oKFW31ohtNAb13DaAHrr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090173
X-Stat-Signature: w66z64b7j7ip8jmi55fmr8j4mma8tn79
X-Rspam-User: 
X-Rspamd-Queue-Id: 695602000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1788969339-589452
X-HE-Meta: U2FsdGVkX19Fvlnu2ZCPKntWUpPc6JgnO1Jx4CaUH7dgJqbSkbtLlkONze01gP+WDOQ3yv8E20QSujBa29Nvg/iL4RRoOmDwktmuOwX3qw/zq87F5luty2wQPb/c5gRLCWqa/kCbJvmBCKyBYCXGjOfw2p3gYVP4E25Vx7fnORTeS/ZSSv6jQzFMcwXIJ2CHZnlhw+Q4QcRMRNWeVd7OyLwQO22BPER6anBaPWqYi0f9FkTElIyVXeUMLNHeyxSpWiYAVa5Fntp0J6i9WvJGVP5w4ppKLN637si5FejQ8EEOzuXDHS49+lplSDmhUZWzfNMHtH1rZPswnV9fn6MYO/gjqAvq5FaT9cT8MHgvvp9lQixAci96x3i/DIpERodYfarYC10/jP0puGDzB6DDe7gAdnOnR3jdPGVchuKEuQ7Pud/P6O/CjVPvgD1mmLawq36ZoUHCeIdSjS6qRvNlJv4xCaDysPiOwwITF7SOOsHq2WcK/OgIOfrczCMzehQGtytuSW5YzmeD28jyWOGoMjALVHP/9J8x9+UdFbVypkBWWqoBUND4vseZx3s74JR95qvNjTRBLMWXzpf2Ll30/hGBTeEvsWZh5aeMdP1wOVbJHB3XJ50NaZennEOqEYY0SQn4KNzGzNUsvc1Z/kUjh6v3Knodx8aSWjWVSpNITMfjrjoBDctz32VWafhoXsqAiNjzyVeITTgKhzx2HBTlxl1//zsqRpowosxZ85t5Xi8OXR+AMBCN84FuCpFJSLUeu11bsAHwA/DVbuNMghV4pZYGykFMKQtYhve+Vbh4aiOu1XczQDuHwLXegAx8rTRIPtkwg/M8Mq/pit62Jj9lO34zkVk3jSOEAjq3pVHhT65M+jRA4DinfXxd3YM5+cpKuasOSjUpc1yQMQMnnZ4Pdeu0SDXZ2bRe31PTAgZ/YO2YAIawO7W2XJTQnMWfH3wCFSOQQSmoW6Z7RwXwP2h
 v3s6Z2AD
 B0Un3DqFOWBSq1sE9Z4QPqPqwt05Jv9TtDmfWs8IItMdzbo9G2jRlcksteziq3yOLzJaNL086SSsmFRL+HP3rtF5thW6NO3gNxxTGdQIr+FshYTxgo0r5E9ULdCJp38RapyKskptBwP/zJWP+cei+S3wmVjGaKMyRpcuidRynzVX4zjWK3mCNCUJbvCgOwTDfL5boh0snfV/LbQKwzIs6dowz7dcS2KoSWnSHMOXU6/md/l9R3+GyDTD32lfPSeFnCXu1YqExfMoYpAF1GPcvpEOv6zivo5ugHmozzn+hlWEUpPNMstvR7PHm/7HaNLm/iyD58OJ5hxVY3PWugjw+c8qF3Fv4MbHy3rw663BrUSKFy8dJp9eNhKtkjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20.08.2026 4:39 AM, Christian Brauner wrote:
> Right now we have coredump_test.h which pulls in the test harness.
> So it can't be included in coredump_test_helpers.c and it hand-rolls a
> bunch of stuff that is not needed.
>
> Instead of this mess, split everything out into a separate
> coredump_test_helpers.h header and make both coredump_test.h and
> coredump_test_helpers.c include it.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>

System: ppc64le LPAR (IBM POWER), Linux 7.3-rc2
> ---
>   tools/testing/selftests/coredump/coredump_test.h   | 30 +-----------------
>   .../selftests/coredump/coredump_test_helpers.c     | 17 +---------
>   .../selftests/coredump/coredump_test_helpers.h     | 37 ++++++++++++++++++++++
>   3 files changed, 39 insertions(+), 45 deletions(-)
>
> diff --git a/tools/testing/selftests/coredump/coredump_test.h b/tools/testing/selftests/coredump/coredump_test.h
> index a02809145e2d..8d99b5cb2f12 100644
> --- a/tools/testing/selftests/coredump/coredump_test.h
> +++ b/tools/testing/selftests/coredump/coredump_test.h
> @@ -3,18 +3,9 @@
>   #ifndef __COREDUMP_TEST_H
>   #define __COREDUMP_TEST_H
>   
> -#include <stdbool.h>
> -#include <sys/types.h>
> -#include <linux/coredump.h>
> -
>   #include "../kselftest_harness.h"
> -#include "../pidfd/pidfd.h"
> -
> -#ifndef PAGE_SIZE
> -#define PAGE_SIZE 4096
> -#endif
>   
> -#define NUM_THREAD_SPAWN 128
> +#include "coredump_test_helpers.h"
>   
>   /* Coredump fixture */
>   FIXTURE(coredump)
> @@ -24,15 +15,6 @@ FIXTURE(coredump)
>   	int fd_tmpfs_detached;
>   };
>   
> -/* Shared helper function declarations */
> -void *do_nothing(void *arg);
> -void crashing_child(void);
> -int create_detached_tmpfs(void);
> -int create_and_listen_unix_socket(const char *path);
> -bool set_core_pattern(const char *pattern);
> -int get_peer_pidfd(int fd);
> -bool get_pidfd_info(int fd_peer_pidfd, struct pidfd_info *info);
> -
>   /* Inline helper that uses harness types */
>   static inline void wait_and_check_coredump_server(pid_t pid_coredump_server,
>   						   struct __test_metadata *const _metadata,
> @@ -45,14 +27,4 @@ static inline void wait_and_check_coredump_server(pid_t pid_coredump_server,
>   	ASSERT_EQ(WEXITSTATUS(status), 0);
>   }
>   
> -/* Protocol helper function declarations */
> -ssize_t recv_marker(int fd);
> -bool read_marker(int fd, enum coredump_mark mark);
> -bool read_coredump_req(int fd, struct coredump_req *req);
> -bool send_coredump_ack(int fd, const struct coredump_req *req,
> -		       __u64 mask, size_t size_ack);
> -bool check_coredump_req(const struct coredump_req *req);
> -int open_coredump_tmpfile(int fd_tmpfs_detached);
> -void process_coredump_worker(int fd_coredump, int fd_peer_pidfd, int fd_core_file);
> -
>   #endif /* __COREDUMP_TEST_H */
> diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
> index 306711e1b24d..570fc2e005c2 100644
> --- a/tools/testing/selftests/coredump/coredump_test_helpers.c
> +++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
> @@ -20,23 +20,8 @@
>   #include <unistd.h>
>   
>   #include "../filesystems/wrappers.h"
> -#include "../pidfd/pidfd.h"
>   
> -/* Forward declarations to avoid including harness header */
> -struct __test_metadata;
> -
> -/* Match the fixture definition from coredump_test.h */
> -struct _fixture_coredump_data {
> -	char original_core_pattern[256];
> -	pid_t pid_coredump_server;
> -	int fd_tmpfs_detached;
> -};
> -
> -#ifndef PAGE_SIZE
> -#define PAGE_SIZE 4096
> -#endif
> -
> -#define NUM_THREAD_SPAWN 128
> +#include "coredump_test_helpers.h"
>   
>   void *do_nothing(void *arg)
>   {
> diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.h b/tools/testing/selftests/coredump/coredump_test_helpers.h
> new file mode 100644
> index 000000000000..45904bd177b8
> --- /dev/null
> +++ b/tools/testing/selftests/coredump/coredump_test_helpers.h
> @@ -0,0 +1,37 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef __COREDUMP_TEST_HELPERS_H
> +#define __COREDUMP_TEST_HELPERS_H
> +
> +#include <stdbool.h>
> +#include <sys/types.h>
> +#include <linux/coredump.h>
> +
> +#include "../pidfd/pidfd.h"
> +
> +#ifndef PAGE_SIZE
> +#define PAGE_SIZE 4096
> +#endif
> +
> +#define NUM_THREAD_SPAWN 128
> +
> +/* Shared helper function declarations */
> +void *do_nothing(void *arg);
> +void crashing_child(void);
> +int create_detached_tmpfs(void);
> +int create_and_listen_unix_socket(const char *path);
> +bool set_core_pattern(const char *pattern);
> +int get_peer_pidfd(int fd);
> +bool get_pidfd_info(int fd_peer_pidfd, struct pidfd_info *info);
> +
> +/* Protocol helper function declarations */
> +ssize_t recv_marker(int fd);
> +bool read_marker(int fd, enum coredump_mark mark);
> +bool read_coredump_req(int fd, struct coredump_req *req);
> +bool send_coredump_ack(int fd, const struct coredump_req *req,
> +		       __u64 mask, size_t size_ack);
> +bool check_coredump_req(const struct coredump_req *req);
> +int open_coredump_tmpfile(int fd_tmpfs_detached);
> +void process_coredump_worker(int fd_coredump, int fd_peer_pidfd, int fd_core_file);
> +
> +#endif /* __COREDUMP_TEST_HELPERS_H */
>
-- 
Thanks and Regards
R.Nageswara Sastry


