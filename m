Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B741DCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 16:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 231608E0062; Mon, 11 Aug 2025 12:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BB5F8E0060; Mon, 11 Aug 2025 12:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0837E8E0062; Mon, 11 Aug 2025 12:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E473A8E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:30:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC1DF81B52
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 16:30:11 +0000 (UTC)
X-FDA: 83765013822.23.4580563
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3490640010
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 16:30:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=quicinc.com header.s=qcppdkim1 header.b=RZyKPJdh;
	dmarc=pass (policy=none) header.from=quicinc.com;
	spf=pass (imf01.hostedemail.com: domain of quic_charante@quicinc.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=quic_charante@quicinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754929809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HlMP3HUL6Cc8PMyjMVeTRfAvfp9gV/f6PuorDrC/x9M=;
	b=1ED5PXfAr2F9shmtgKUI4pw2N0/A7KeeyI68CjFHmmMgEPtTVRJVtcXUztlP3mrTkgb1sR
	ok4XkAN/Mc3fr/tfrnZV/FJIOP6wp7eplkDwyZDqjFcXt/WtdjTeAx9IWGc+N1gghB3wsP
	Sig7ROopJ9Crxunv9raP0rvQ0moh4hE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754929809; a=rsa-sha256;
	cv=none;
	b=4h8BMejEOTlk6WXlhCPADDZ9MVxULKmSrSj5XiBeNi3T2SnussqU2EzYFd0AIIE3msIzyA
	oDGHHnsAvIWqYWWU/bkYQWdBJvziHBNE6eq0i5SX4ZJkWdjVDeJclh4fLbJN9RdBzZHi66
	2CJZ0mE5Zo4LiotoUULMOSTXWDedGxg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=quicinc.com header.s=qcppdkim1 header.b=RZyKPJdh;
	dmarc=pass (policy=none) header.from=quicinc.com;
	spf=pass (imf01.hostedemail.com: domain of quic_charante@quicinc.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=quic_charante@quicinc.com
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57BBWOV5007754;
	Mon, 11 Aug 2025 16:29:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HlMP3HUL6Cc8PMyjMVeTRfAvfp9gV/f6PuorDrC/x9M=; b=RZyKPJdhen1V4+Hr
	zW2NEPk4jQDgQ7MYOS5fc1lmVUVeFQWVbb20VyG60DZl7yVnWonD3XNH4BNO6JBl
	yiFFK8qRpZi6wTqEhSZvIWV98cIooL+0rPy7budq1lz4Y8F9KWeRtkRn4QvmyD76
	QsClMxdjqCCKaNZFTvnewjzKcij2PiTyF/d2LW1fIgaM21+WCEl4YEHAAqahFJm+
	uPdnW6WoCTVdtXaDGmXo3iLUxAuTE8euMbCJhEE1+GfOfamrFUfsbfdkfOrp0C8s
	v9jyPQhqsuQXrLhKB3jRXy+qBoiaiLsepYhq3nz91/f8g2RORx7S3/M+nahKFLuE
	0RGXww==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48ffq6gx3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 16:29:56 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 57BGTtYc030278
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 16:29:55 GMT
Received: from [10.216.45.192] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10; Mon, 11 Aug
 2025 09:29:51 -0700
Message-ID: <25f6b30a-75fd-429c-ad3a-29cfc3a677a8@quicinc.com>
Date: Mon, 11 Aug 2025 21:59:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: swap: check for xa_zero_entry() on vma in swapoff
 path
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: <akpm@linux-foundation.org>, <shikemeng@huaweicloud.com>,
        <kasong@tencent.com>, <nphamcs@gmail.com>, <bhe@redhat.com>,
        <baohua@kernel.org>, <chrisl@kernel.org>, <david@redhat.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <20250808092156.1918973-1-quic_charante@quicinc.com>
 <46d4a5bb-5734-40b4-a5f1-3094500ef1c3@lucifer.local>
Content-Language: en-US
From: Charan Teja Kalla <quic_charante@quicinc.com>
In-Reply-To: <46d4a5bb-5734-40b4-a5f1-3094500ef1c3@lucifer.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDA3NSBTYWx0ZWRfX3cOyk7cOWaNP
 X9O6YD0qm4tN42PMd2cVWr4rmsRn728khHrJMWs/qobrWaMvg4RtLXsudawgppGwIfXcLYEMTDs
 KnJgyKSAszS0V0IekerdkFlSTN99leBMVSw8npoeg96NEoLSoHnIK3u2IiPt5XjYWVk1to6e/Wm
 OUV+h0+nzky3WHvhSC8TQtVBrgcl17/6MIgzxwGyHlsA1T9y+BziezB4rO9RorilhzhU64s+5t2
 GSiQawACZX9kw+8zg++Ru1ZBl32Yq1KnYG5s3iScUlYZfYPIoSCpr721dCqXJJJFZnZZI4W5PY8
 MP+sENMEGy/NXlmfHIeTcC+PSP83FfB21witL+OVFBmA7W0d2i7H+4vFVL4cM17ZxmZwNzMnxfq
 4CBQW2NC
X-Authority-Analysis: v=2.4 cv=TLZFS0la c=1 sm=1 tr=0 ts=689a1a84 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10
 a=Eu7-4bY5xJMfsWnsbBEA:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19 a=QEXdDO2ut3YA:10
 a=QYH75iMubAgA:10
X-Proofpoint-GUID: dgL5N7pKdAMMncEIiKUWYf5ebzNIeq1P
X-Proofpoint-ORIG-GUID: dgL5N7pKdAMMncEIiKUWYf5ebzNIeq1P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_03,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508110075
X-Rspamd-Queue-Id: 3490640010
X-Stat-Signature: 9x8bhomnjazwmukm94aqxp5uaoce57u3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754929808-540668
X-HE-Meta: U2FsdGVkX1/a1zI5bklra0NtpEMNo1OGAgxOQ8WfcrPSALzgVYbnH4NmWOxFjoWs7opghpZ1oPgjjRYfLwF2Wn6roRPeRyI7ecRGGwhrnHQZ7RG0RAdrWpKX3Dz68OwDevraOLUapBUh2HanKyt1t5rvUpGKj4Kmrr772ajxZLdYglE6iUKS9GCrJRS85Maee7U0J+ha4jXj3/sti0JhISnavpJsmOVvd824/I+A73X4ytoEonr8c+5jWIYH5wHATLEqmoZkwctnDwTznMJyioIWVCB+VkZseycUjXvDRp9xe3gtP1rBn0cPHkpeQxOGn+R8AyTH8qRPyKNBJ7nmuVOHahZH46HrstU7PKirB+QrPm/Gp6vVJMvTI5f5KnHA0I+EKlnoERyHTEEfaeRryD/bnzDLFbiSXeE68JOlKBSIYtH3z9RgNf7lqMaVJcDJbVhEqz8bTVC8d71WzX+8fUKddsbpYwCP9V7tZ2gQH3lkDMzVTc+4+Ej/pWW8IoC50QFa6qnHQbe0KydMyZm+pAaBG7t1WX70aDysHVd+OjmljS3BKHLEWTnAckazmh3LZLQEo3S9jcOEnhG9LPxS4eA2KhN9yqONJh7sOw/ByJm7elvKyP7ZfRfvdfkGgLLVrt+Hm8qk1KEoqGggaSXnZozccOyp32NatBktDb+HI72uCVWb9ezCAHjJssGJXXoz9Df944QE4Om+fG2lUmZzkAN0LmoI/oR3ezFDHG0voM0tH00+w3diq0fZLmlr+U1HnWfi89fR9ifvLzEWLwWVlydiHxmIw2gXYIIArWOseGHh5nM2q/bZPqTG/uixlLOHwlRh5esPeggT65zlQG+KqLumU1nziWKZHO42ywzQvnRqZBnrdGKSfhqemvVqGowaFFO4Qv4CcuJ+UWlR26va8Bka1+R7OWWvkm0o0Xzx6PDninvRyfPHb+F2L65DqX8SoJqxoBB4Q1T1DucLyj5
 x1WImAZ6
 6kBPFFtMKpxXsGvfM0SrPrV81YOwm8SGAvpKQxq81mBbonhgGDqJBDC6Lzr6FTFt5fTud23b/jY64rQkJ45rchJ5tvIOFWNciKFx1ERYy97Dr5M6aYorL7Jpzj2aBKiS33F26X/cuzjdQp8Ua2DPOoCVOdTSiwSpB8BO/h3n3SuJ8/gkGT0hTs6A5XxxtYeeZyh+ioTR7huRgGbG4WkaHkUf46JjHLVt9BK/MR4T5OmjGZ4lgRTx+MExD46nkOv8oRe8a6rw7sUGlj6aKWDFmvwg5YukanSp05LedgEovizDWpvp4s6xUSYA++UjodgWpp8hdmpBHZBj28ekgRI/qkGAe6U/Hu7PFLXgFR7H8bVBbl4OgP02NXZpnHO2phwUBb687gMMVqqTEd7fPEcwoK7okp6iFVDMINk8ZGNGS24Bhkp4hykKKRdKXs5CX0FHsQPxV68U+VCYGAmJQSV2SfvEFbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/11/2025 5:37 PM, Lorenzo Stoakes wrote:
> Any syzbot link or further information as to where this bug was found? Was this
> on your system?
> 
> Has this happened in reality or due to fault injection?
Sorry, missed to mention this information on the commit message.

Yes this is really reported on the 6.12 LTS kernel, while running the
tests on the device farm, though, reproduction rate is very low.

Thanks
Charan

