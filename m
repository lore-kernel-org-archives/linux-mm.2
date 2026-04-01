Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6574AD35165
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 16:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DCCE6B0005; Wed,  1 Apr 2026 12:20:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E086B0088; Wed,  1 Apr 2026 12:20:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756006B0089; Wed,  1 Apr 2026 12:20:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3AA6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 12:20:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E7357BB80D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:20:20 +0000 (UTC)
X-FDA: 84610499400.10.1F3A589
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5D6B0C0010
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:20:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rMNwA2eg;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf28.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775060418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rwcseRkZvSpJaBHvc4m1vR1SSI585GgXp6GEMFc3uMI=;
	b=jufVZhdnL2WGNzGF3mhqk0oYva/uWatteorTYsmDeRlKCA1DtEcBVO5/cf+ehkSAsfmC9I
	FvplYl3fTNx6nkauuq+R+apX8bRy/WOtK8fY3o1Vxxa7EWZbRmkZnH3JBGe14z1BmxXeLZ
	BfuS2ld41Q+z7ONc2kXl0ho3X3dsx4w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775060418; a=rsa-sha256;
	cv=none;
	b=EXO+GsNxJmCAk3UOo1eWVMYh2/vqeZm6WM7RD6WU2GK/QqBxJZmRuOzB3VJGMhKKKt7x2h
	qCEs2UewTwlRiyYrjqy4iZttru1MUIQiH49V0Sq6Rn/ROslb6sJ+WMvcf/6r7+oownAJOq
	VawVjI84KCQdTcKWXU4K4Q4oSQkmbT4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rMNwA2eg;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf28.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 631CXfQo169440;
	Wed, 1 Apr 2026 16:20:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=rwcseRkZvSpJaBHvc4m1vR1SSI585G
	gXp6GEMFc3uMI=; b=rMNwA2egnvxMa1g8omsIRfJxfHQkKHgPykpFUz8P0vgwes
	2/hgUbx1z025YXRSmepQAfKvb86YVNRZNTgbdkzad3Gt8n1wRx8w8P2BYaVTYDY/
	idcV6JTfPwJt8sUM82DgSaQLYJg7z6ry6/GcKDcmaUxX3uwmoYjSX1dJanEs0WZ+
	4n4MuJaSrNg6JhfT6HwEXOWFEFRevrST1WjqzSRNLRcSt5yg3T5GEbzdg2w/AS3e
	guKUttFNSDXGSpOG2iC7Ew+yDWNF0eWt0epXlpyALKGriltDiwHXmk4iYhseDua3
	jCvf4t7YenOaz/dMwS6TnNlvtJQqM0xkmSeJoXOg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d66q391tc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Apr 2026 16:20:11 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 631Coo8T008751;
	Wed, 1 Apr 2026 16:20:10 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d6v11p5d3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Apr 2026 16:20:10 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 631GK9wd24838838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 1 Apr 2026 16:20:09 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5428F58050;
	Wed,  1 Apr 2026 16:20:09 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CB72558056;
	Wed,  1 Apr 2026 16:20:03 +0000 (GMT)
Received: from [9.39.18.42] (unknown [9.39.18.42])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  1 Apr 2026 16:20:03 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------EQ30VdHhb33YDv00OO9Y9p4A"
Message-ID: <0dab0668-3b26-4de4-9732-e175f71fab7f@linux.ibm.com>
Date: Wed, 1 Apr 2026 21:50:02 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/13] selftests/mm: size tmpfs according to PMD page
 size in split_huge_page_test
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <2fd965ce641d32a759984943a427fde47d7c3b13.1774591179.git.sayalip@linux.ibm.com>
Content-Language: en-IN
From: Sayali Patil <sayalip@linux.ibm.com>
In-Reply-To: <2fd965ce641d32a759984943a427fde47d7c3b13.1774591179.git.sayalip@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: JQpxQovDFN9rx__MD5rBpPgLteUK8VHE
X-Authority-Analysis: v=2.4 cv=frzRpV4f c=1 sm=1 tr=0 ts=69cd45bb cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=r77TgQKjGQsHNAKrUKIA:9 a=Ikd4Dj_1AAAA:8
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=9xpQgMCZT6CDAktlhO4A:9 a=QEXdDO2ut3YA:10
 a=oNkvB1tdlSU9MeNmM38A:9 a=376m0CbwF7od3y55:21 a=frz4AuCg-hUA:10
 a=_W_S_7VecoQA:10 a=lqcHg5cX4UMA:10 a=3ZKOabzyN94A:10
X-Proofpoint-ORIG-GUID: sQt1gMsI0qe_Tdtfpkj_U1j8UMfg3AXd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAxMDE1MiBTYWx0ZWRfX/DqgAJyPRr2a
 9TOuARmgHB3+e+hbJ2hfZcin4dNysJOW+pLKZDDcloDad6SEjFqVagxmWWDizNWPrY38h1npu5a
 yQCp52XGi2TNCnXY7RWIDOiO68pP/LzrqupsqXFbjgZzlRERM+9oGlP5GjC37IaO7YrH1Az4gAe
 oL3v20znF2xGcyvumfUvTJdEnYUx9bQY+us966wK/t2oREi9KIXRtDI7MLi2f54JAGQoKw2n6Yo
 AKO3bZKapAIOFSKOf0b4xPOw3e3Z0+oWZaIQuCgkBW1prRX1Gw0JT4S/PVufv2iUF8L6WB/ogrB
 aL76dVSBiU206G1iKlKiHDcClCR/9cS7Xjk3iZdlTA8fgcEcZqPP1WxpfucphON2FE3o+dFEb2A
 lS0nKxZdBaZ3Xs8rt5za3lxhSW9LtfsBo72xQd2EKz4ucA9/53KJmudfYeI8tmrQajfzP1CwleH
 EAn1REeIK+ra0aizFpQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-01_04,2026-04-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604010152
X-Rspamd-Queue-Id: 5D6B0C0010
X-Stat-Signature: z338bwmoz4um4qef3iehkpqwkym3meum
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775060418-929116
X-HE-Meta: U2FsdGVkX1/CftnqRO37Snn1FJl297ZAyMO6o0IM/Rx7CJ2+/z8kk/KP2uGG7qBLX6K/Wz1wKyV81qfbHK2N25OE2OtNvdzj0YNkgJcr4cwFiRKbzhODY3pEg/CAtefZQKn16trJui8ziDG6zvSgI4uZtxlKRDPohKxPVZn3fuHDuEw9idrLRdpgRrJTkrwhLGBFS3SKKa0RcTew1gxFSwzglnCFatVGFA4XEK6OVMdtoXbRq+7za3gh2cxEMM8aIDXcGTsbnKjcfUZgxlRl79BmxGxs3hzmdD3trbjlpQHKuIo+VCUCghVliDzDiMWQNG/IG0BjJ3l+JAAWT2qwlpjoUAr+Br1vBvDmksUMI9pm+/37Er4Amke7mv1fKxql8s5gcfW+huMGggkfwDC/d9qwt96EjUCfFWcMHUBZIeniFgTiCoC11ces1aFCwh8dwsRAynDX5nji84bAnBWk2gIaMvNQM10vM97KtnwE7CFNQYHidx56BV5Am4pcmm1RhNpWNOTmkkNaJystlx6qgiwyLpzbo7zV+sTDYe5iQ/GITQykjHQflR0qcpUSKix+t6GImS41oXoWowOidxu+cA2Tt8c4arjwYMqQ78o9+3hq0KDBIn/CqonXzUNAHa9xYc7qbxelxq4TER8HDaws8hZPOKvL/m31MTY9gIdXKO1k6z9yPA8Q4+DspiFdeR2IArCDBFxoM/k1Ke3FwvePbTAJLpGLMFu+pTgB2L5IQl/KmPP1VZvVLOWoCHNK3NwlDhpTrfD/Vj+Kv4hbAcnQBvUP82DvFDP0BDKmCJ/eOXZF+yuoCOwD2EorjZM3IATdp7bwcybXSG2bGw3by+k+lmNgj07nAARoL7aup51FZzJHlIbT7XBaGyZDlKBHLTBXzYsOD7VPMy3RbCR1JpK3IUVDKsEbHo0GAYAtkjby2zoQCg1GX3Xl/+LqQFK/qvMJ0xppsQDqjpv0qe23DHq
 UwehQWbE
 DPkKprhgOltCMUaqfvEpCoSRcYyXwC1bKte3GKZKFltHcipGb+K4I3wfvVbG3o4PPVVFf8Jp5HbYRab5j1UiA2LWewmZqxyeRYvg2xdZGpQIrGMJoBUjqW24rvyINAj6aXaqxXZ7XfVP+tT2+QD6zjI1BrxCwFClzHnDmFhJdWp0CamHho97RiFwmL22NKsm3DtUvqmJok9uYxnYEhqhtZZM+p8RtzohKpCg5ysi0k0JQxAIWjIdZSwkXQZx9nBLCUXLX3sMkN8oxTx+0elLE9ms8/+DDT5KKKDCBiqHyuXkQhojIJsJQXYka81EpdgCMbO2Cfjttg44hKl0l+RBlyNMjVM4XYQ8rlA1f0ZPvSP/hP8FSO1ixABIFs9AnF+/ocBFvAjGjGqV6P5oDGz5re+pR23ulnHZSF4IH3c4o+drvwpKd/quO3ddVvucUJPV6MdOwmV3nIbYpMZxstZwwjxh1rrXb/xs9xqUcLwTCC5sp39t9LD/+mMdMilK8yDW5KpGYsrW/hzUAiENhNwqQVUxg6WZsDteNEO5h7Ja/PkMrN0Ig3fncCxGzWYFUI/UlnDCTlRg5+OR/I3vp/FWlwnbXM+ndOExxa+C7CCPGK9ayRyPd0XZpvkO0Bkg9Y1nH4Z9aL8jza+DVrHK1SNTFyQ7ClokxWULB6nXFByWLRdM5cyaT/RQvwDNERI7Qm5JzASsvBia+OaP7wmsMYwQvi70KQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------EQ30VdHhb33YDv00OO9Y9p4A
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 27/03/26 12:45, Sayali Patil wrote:
> The split_file_backed_thp() test mounts a tmpfs with a fixed size of
> "4m". This works on systems with smaller PMD page sizes,
> but fails on configurations where the PMD huge page size is
> larger (e.g. 16MB).
>
> On such systems, the fixed 4MB tmpfs is insufficient to allocate even
> a single PMD-sized THP, causing the test to fail.
>
> Fix this by sizing the tmpfs dynamically based on the runtime
> pmd_pagesize, allocating space for two PMD-sized pages.
>
> Before patch:
>    running ./split_huge_page_test /tmp/xfs_dir_YTrI5E
>    --------------------------------------------------
>    TAP version 13
>    1..55
>    ok 1 Split zero filled huge pages successful
>    ok 2 Split huge pages to order 0 successful
>    ok 3 Split huge pages to order 2 successful
>    ok 4 Split huge pages to order 3 successful
>    ok 5 Split huge pages to order 4 successful
>    ok 6 Split huge pages to order 5 successful
>    ok 7 Split huge pages to order 6 successful
>    ok 8 Split huge pages to order 7 successful
>    ok 9 Split PTE-mapped huge pages successful
>     Please enable pr_debug in split_huge_pages_in_file() for more info.
>     Failed to write data to testing file: Success (0)
>    Bail out! Error occurred
>     Planned tests != run tests (55 != 9)
>     Totals: pass:9 fail:0 xfail:0 xpass:0 skip:0 error:0
>   [FAIL]
>
> After patch:
>    --------------------------------------------------
>    running ./split_huge_page_test /tmp/xfs_dir_bMvj6o
>    --------------------------------------------------
>    TAP version 13
>    1..55
>    ok 1 Split zero filled huge pages successful
>    ok 2 Split huge pages to order 0 successful
>    ok 3 Split huge pages to order 2 successful
>    ok 4 Split huge pages to order 3 successful
>    ok 5 Split huge pages to order 4 successful
>    ok 6 Split huge pages to order 5 successful
>    ok 7 Split huge pages to order 6 successful
>    ok 8 Split huge pages to order 7 successful
>    ok 9 Split PTE-mapped huge pages successful
>     Please enable pr_debug in split_huge_pages_in_file() for more info.
>     Please check dmesg for more information
>    ok 10 File-backed THP split to order 0 test done
>     Please enable pr_debug in split_huge_pages_in_file() for more info.
>     Please check dmesg for more information
>    ok 11 File-backed THP split to order 1 test done
>     Please enable pr_debug in split_huge_pages_in_file() for more info.
>     Please check dmesg for more information
>    ok 12 File-backed THP split to order 2 test done
> ...
>    ok 55 Split PMD-mapped pagecache folio to order 7 at
>      in-folio offset 128 passed
>     Totals: pass:55 fail:0 xfail:0 xpass:0 skip:0 error:0
>     [PASS]
> ok 1 split_huge_page_test /tmp/xfs_dir_bMvj6o
>
> Fixes: fbe37501b252 ("mm: huge_memory: debugfs for file-backed THP split")
> Reviewed-by: Zi Yan<ziy@nvidia.com>
> Reviewed-by: David Hildenbrand (Arm)<david@kernel.org>
> Tested-by: Venkat Rao Bagalkote<venkat88@linux.ibm.com>
> Signed-off-by: Sayali Patil<sayalip@linux.ibm.com>
> ---
>   tools/testing/selftests/mm/split_huge_page_test.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index e0167111bdd1..57e8a1c9647a 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -484,6 +484,8 @@ static void split_file_backed_thp(int order)
>   	char tmpfs_template[] = "/tmp/thp_split_XXXXXX";
>   	const char *tmpfs_loc = mkdtemp(tmpfs_template);
>   	char testfile[INPUT_MAX];
> +	unsigned long size = 2 * pmd_pagesize;
> +	char opts[64];
>   	ssize_t num_written, num_read;
>   	char *file_buf1, *file_buf2;
>   	uint64_t pgoff_start = 0, pgoff_end = 1024;
> @@ -503,7 +505,8 @@ static void split_file_backed_thp(int order)
>   		file_buf1[i] = (char)i;
>   	memset(file_buf2, 0, pmd_pagesize);
>   
> -	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, "huge=always,size=4m");
> +	snprintf(opts, sizeof(opts), "huge=always,size=%lu", size);
> +	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, opts);
>   
>   	if (status)
>   		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");
AI review question:
> Are file_buf1 and file_buf2 being leaked here?
> While reviewing the patch's changes to support larger PMD sizes, I noticed
> that earlier in this function file_buf1 and file_buf2 are dynamically
> allocated using pmd_pagesize:
>      file_buf1 = (char *)malloc(pmd_pagesize);
>      file_buf2 = (char *)malloc(pmd_pagesize);
> Looking at the end of the function, the success path returns without freeing
> either buffer:
>      ksft_print_msg("Please check dmesg for more information\n");
>      ksft_test_result_pass("File-backed THP split to order %d test done\n", order);
>      return;
> Since this function is called in a loop for each split order, could this
> cause a significant memory leak? On architectures with large PMD sizes
> (like arm64 with 64KB base pages, where the PMD size is 512MB), leaking
> these buffers repeatedly could exhaust system memory and trigger the OOM
> killer during the test run.
>
Yes, both file_buf1 and file_buf2 are leaked on the success path and
some failure paths.
Since this function is invoked in a loop for each split order, the leak 
accumulates over time.
On systems with large PMD sizes, this can potentially trigger OOM during 
the test run.

This was likely not noticeable earlier with smaller PMD sizes, but 
becomes significant
with larger configurations.
This appears to be a pre-existing issue and not introduced by my patch.
I will prepare a separate fix to free both buffers on all exit paths to
prevent this memory leak.

Thanks,
Sayali
--------------EQ30VdHhb33YDv00OO9Y9p4A
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 27/03/26 12:45, Sayali Patil wrote:<br>
    </div>
    <blockquote type="cite"
cite="mid:2fd965ce641d32a759984943a427fde47d7c3b13.1774591179.git.sayalip@linux.ibm.com">
      <pre wrap="" class="moz-quote-pre">The split_file_backed_thp() test mounts a tmpfs with a fixed size of
"4m". This works on systems with smaller PMD page sizes,
but fails on configurations where the PMD huge page size is
larger (e.g. 16MB).

On such systems, the fixed 4MB tmpfs is insufficient to allocate even
a single PMD-sized THP, causing the test to fail.

Fix this by sizing the tmpfs dynamically based on the runtime
pmd_pagesize, allocating space for two PMD-sized pages.

Before patch:
  running ./split_huge_page_test /tmp/xfs_dir_YTrI5E
  --------------------------------------------------
  TAP version 13
  1..55
  ok 1 Split zero filled huge pages successful
  ok 2 Split huge pages to order 0 successful
  ok 3 Split huge pages to order 2 successful
  ok 4 Split huge pages to order 3 successful
  ok 5 Split huge pages to order 4 successful
  ok 6 Split huge pages to order 5 successful
  ok 7 Split huge pages to order 6 successful
  ok 8 Split huge pages to order 7 successful
  ok 9 Split PTE-mapped huge pages successful
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Failed to write data to testing file: Success (0)
  Bail out! Error occurred
   Planned tests != run tests (55 != 9)
   Totals: pass:9 fail:0 xfail:0 xpass:0 skip:0 error:0
 [FAIL]

After patch:
  --------------------------------------------------
  running ./split_huge_page_test /tmp/xfs_dir_bMvj6o
  --------------------------------------------------
  TAP version 13
  1..55
  ok 1 Split zero filled huge pages successful
  ok 2 Split huge pages to order 0 successful
  ok 3 Split huge pages to order 2 successful
  ok 4 Split huge pages to order 3 successful
  ok 5 Split huge pages to order 4 successful
  ok 6 Split huge pages to order 5 successful
  ok 7 Split huge pages to order 6 successful
  ok 8 Split huge pages to order 7 successful
  ok 9 Split PTE-mapped huge pages successful
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Please check dmesg for more information
  ok 10 File-backed THP split to order 0 test done
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Please check dmesg for more information
  ok 11 File-backed THP split to order 1 test done
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Please check dmesg for more information
  ok 12 File-backed THP split to order 2 test done
...
  ok 55 Split PMD-mapped pagecache folio to order 7 at
    in-folio offset 128 passed
   Totals: pass:55 fail:0 xfail:0 xpass:0 skip:0 error:0
   [PASS]
ok 1 split_huge_page_test /tmp/xfs_dir_bMvj6o

Fixes: fbe37501b252 ("mm: huge_memory: debugfs for file-backed THP split")
Reviewed-by: Zi Yan <a class="moz-txt-link-rfc2396E" href="mailto:ziy@nvidia.com">&lt;ziy@nvidia.com&gt;</a>
Reviewed-by: David Hildenbrand (Arm) <a class="moz-txt-link-rfc2396E" href="mailto:david@kernel.org">&lt;david@kernel.org&gt;</a>
Tested-by: Venkat Rao Bagalkote <a class="moz-txt-link-rfc2396E" href="mailto:venkat88@linux.ibm.com">&lt;venkat88@linux.ibm.com&gt;</a>
Signed-off-by: Sayali Patil <a class="moz-txt-link-rfc2396E" href="mailto:sayalip@linux.ibm.com">&lt;sayalip@linux.ibm.com&gt;</a>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index e0167111bdd1..57e8a1c9647a 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -484,6 +484,8 @@ static void split_file_backed_thp(int order)
 	char tmpfs_template[] = "/tmp/thp_split_XXXXXX";
 	const char *tmpfs_loc = mkdtemp(tmpfs_template);
 	char testfile[INPUT_MAX];
+	unsigned long size = 2 * pmd_pagesize;
+	char opts[64];
 	ssize_t num_written, num_read;
 	char *file_buf1, *file_buf2;
 	uint64_t pgoff_start = 0, pgoff_end = 1024;
@@ -503,7 +505,8 @@ static void split_file_backed_thp(int order)
 		file_buf1[i] = (char)i;
 	memset(file_buf2, 0, pmd_pagesize);
 
-	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, "huge=always,size=4m");
+	snprintf(opts, sizeof(opts), "huge=always,size=%lu", size);
+	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, opts);
 
 	if (status)
 		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");</pre>
    </blockquote>
    <font face="monospace">AI review question:</font>
    <blockquote type="cite"
cite="mid:2fd965ce641d32a759984943a427fde47d7c3b13.1774591179.git.sayalip@linux.ibm.com">
      <pre wrap="" class="moz-quote-pre">Are file_buf1 and file_buf2 being leaked here?
While reviewing the patch's changes to support larger PMD sizes, I noticed
that earlier in this function file_buf1 and file_buf2 are dynamically
allocated using pmd_pagesize:
    file_buf1 = (char *)malloc(pmd_pagesize);
    file_buf2 = (char *)malloc(pmd_pagesize);
Looking at the end of the function, the success path returns without freeing
either buffer:
    ksft_print_msg("Please check dmesg for more information\n");
    ksft_test_result_pass("File-backed THP split to order %d test done\n", order);
    return;
Since this function is called in a loop for each split order, could this
cause a significant memory leak? On architectures with large PMD sizes
(like arm64 with 64KB base pages, where the PMD size is 512MB), leaking
these buffers repeatedly could exhaust system memory and trigger the OOM
killer during the test run.
</pre>
      <br>
    </blockquote>
    <font face="monospace">Yes, both file_buf1 and file_buf2 are leaked
      on the success path and </font><br>
    <font face="monospace">some failure paths.</font><font
      face="monospace"> </font><br>
    <font face="monospace">Since this function is invoked in a loop for
      each split order, the leak accumulates over time. </font><br>
    <font face="monospace">On systems with large PMD sizes, this can
      potentially trigger OOM during the test run.</font><br>
    <br>
    <font face="monospace">This was likely not noticeable earlier with
      smaller PMD sizes, but becomes significant </font><br>
    <font face="monospace">with larger configurations.</font><br>
    <font face="monospace">This appears to be a pre-existing issue and
      not introduced by my patch.</font><br>
    <font face="monospace">
      I will prepare a separate fix to free both buffers on all exit
      paths to</font><br>
    <font face="monospace">prevent this memory leak.</font><br>
    <br>
    <font face="monospace">Thanks,<br>
      Sayali</font><br>
    <style type="text/css">p { margin-bottom: 0.1in; line-height: 115%; background: transparent }a:link { color: #000080; text-decoration: underline }</style>
  </body>
</html>

--------------EQ30VdHhb33YDv00OO9Y9p4A--


