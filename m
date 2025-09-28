Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB5F7CAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 16:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A2058E0002; Sun, 28 Sep 2025 12:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279B48E0001; Sun, 28 Sep 2025 12:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18FA68E0002; Sun, 28 Sep 2025 12:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 020D08E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 12:01:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78BB5160146
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 16:01:17 +0000 (UTC)
X-FDA: 83939123394.29.E73C885
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id D4E7E140012
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 16:01:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=kHQMOjAt;
	spf=pass (imf09.hostedemail.com: domain of charan.kalla@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=charan.kalla@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759075275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cPFVpHWsZToVkjvByN8+NS0wTPCw0JUGnzSj+xr+rBc=;
	b=HxTIARIg/AMvFzAX5XEOLjVSbm2IGuTr4vHCSnkvC/bYVM0oyqBCbX4Ix2SMPU6lJ+j9dG
	9XWT636zNj+bOc6cJkbnW3hal+sE2M4Vf3vfFeSiMPYh8/CWELU9U3XVRufPmJcQsz4YDD
	+5+VjHeYHG0t1dnjxOfzMK3A+n8zPdY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=kHQMOjAt;
	spf=pass (imf09.hostedemail.com: domain of charan.kalla@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=charan.kalla@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759075275; a=rsa-sha256;
	cv=none;
	b=Ll8o1YPAq5mWg/EUO9WjpKbS0Fjl4D/ft6KIG0oYI7II6YLm6XTPYpAICzmlUHoMmaqbOW
	mMVpWY+nmyX3S2ex5cLjROHfE/pms5eoDg5j/hMRxLd+WZzJyyBzvL3a9aoOWn3lyuOSCa
	BjhwolLN8GuAmQTPRf9tiJhQjUlbpAc=
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58SAi82S028278
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 16:01:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	cPFVpHWsZToVkjvByN8+NS0wTPCw0JUGnzSj+xr+rBc=; b=kHQMOjAt18xVyxOZ
	Gx0lnuqw/oQviTlDkFSmNPUNaSCs2b6RG3JLGtfnQOdI6UHNGdcS6BCJOYgoAhlq
	MhjsfZCZJsw+SAbucEoNdAls4Qvjl4j/a/XbbpQbgLmn4d8zXY7GcUKEavklstNt
	hDxzje0IKWnDSUxLs04YX6mncsUcqdCVl0fGA0W3DitbLH00E4zZm6anmLEEMCTt
	OOqvBM3uCDqCo95O7Q00J+9VtmoTViL6pqirZjIC24CeLNmyYVyLhvbXeJrajPKK
	Gk25qJKuc+C0op4E4BhXGDCYTEAJJ5EFPh9wEadmz1kHa0FsZVEZcXxsTkBqnyR+
	eE/KMA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49e6x5k0wt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 16:01:13 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2699ebc0319so38878135ad.3
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 09:01:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759075272; x=1759680072;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cPFVpHWsZToVkjvByN8+NS0wTPCw0JUGnzSj+xr+rBc=;
        b=nOjSP7X40xRkL+c9WXdZPMWo3JukVPArsIHSX/lHgncLZ+gZvHCv/uQ+UG+b0KBlZn
         5Bi9O8DcykMIKuUDEbQRGsUVve6dxUT5onGGfjH1yr7+Vu1cO66t7gev56bi8v70t8dc
         V5FrTVDgrX02X2VQnw9bkClCcFzb4YnUWInzKC62N/8qyxoLIF4Vsqd+MAJRgeHrlbHr
         xyiGfUIdPKByHmwX6mog3o3vwyavj8pTtiJteBJupMLYQGL4OT20SyLexiGAxddevYGi
         mFbBdM+zfOFC2QOWsk3BWA8JN6QlZYAo9Ym4FZCXYB+7CXT+FoH+VP2ev+g6ne2elco4
         ld4w==
X-Forwarded-Encrypted: i=1; AJvYcCVlcyobqRDqVKwXpSrj7TQAfKDcMmYcUtOY0UlilBr+XDy9D3dEYtRRT/ucE/2W7I77pRqvInjnwA==@kvack.org
X-Gm-Message-State: AOJu0YyFSiLLGYwxOKfvUfHAMOKIlzEtNyttRarNlm8tRXMZ1zzgAwHb
	NsOUq/+/IUOkPSDGP5u6a2gQ6ZoC3DGMu6JcWmZp/JcW8ren3as0J6yjcmVYMgicPmnh9UNYDHA
	5A2LxNjrBGxvqz9MijIDV9TKPtu6khqBaMREGUeqn5rCfkjkHcOaR3A==
X-Gm-Gg: ASbGnctQM4Ee4Fbnh4Hq8DzImHkMS49H3bk7D0cdngkLTpuqbMfgPXGtGKBLGMX5z42
	YqdwlNWony82fqsI8IeHRGV9pOYwt2zZ3S9Jq0b1kWCX9kvII+hdVmfhhWE75OPScX0a1c+eE3A
	vNhT/j19edHH9vL3bdTc3BbwZrMGQfA0saHpOSq9WuNkZzpsFFtKwXuGtTv8noopE24UduBWuYi
	lyHkXMtNHZIiNxSX2mThBpg4miuHmk/Xx9pPYBjwyhM7pH9y1YfwOFrNSFcaiIX/V1bwbHjA4ai
	GDwblCwYiPEw9hLDvGehigd7gPg0EJTtf0hIUFqAYbo6ynok3h3m+/vZOQqzOcgkq7GFqg==
X-Received: by 2002:a17:902:da2d:b0:269:8fa3:c227 with SMTP id d9443c01a7336-27ed4a06e11mr127912585ad.8.1759075272315;
        Sun, 28 Sep 2025 09:01:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKu+Mjlu4lZU0z3b0X20n3n0XWiHLgmlWPxFZKPAgl2BOGgx6FGTyHcwjgZgfLcJLNliYZPQ==
X-Received: by 2002:a17:902:da2d:b0:269:8fa3:c227 with SMTP id d9443c01a7336-27ed4a06e11mr127912335ad.8.1759075271816;
        Sun, 28 Sep 2025 09:01:11 -0700 (PDT)
Received: from [192.168.1.5] ([136.185.249.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed68821a0sm106708625ad.85.2025.09.28.09.01.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Sep 2025 09:01:11 -0700 (PDT)
Message-ID: <a3b3f044-5a84-44e6-a2f1-0e590a9beed6@oss.qualcomm.com>
Date: Sun, 28 Sep 2025 21:31:05 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm: swap: check for stable address space before
 operating on the VMA
To: Barry Song <21cnbao@gmail.com>, Chris Li <chrisl@kernel.org>
Cc: david@redhat.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
        akpm@linux-foundation.org, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        zhangpeng.00@bytedance.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20250924181138.1762750-1-charan.kalla@oss.qualcomm.com>
 <CACePvbW=-KZhU_qi4UUw7Pjbz4o=SQwHmQyEOkxhpMvdetbPCg@mail.gmail.com>
 <CAGsJ_4zhL=4qJDmGA5E-z7=VixkUXOi+qBnN3S-WWH2UbYj=ZA@mail.gmail.com>
Content-Language: en-US
From: Charan Teja Kalla <charan.kalla@oss.qualcomm.com>
In-Reply-To: <CAGsJ_4zhL=4qJDmGA5E-z7=VixkUXOi+qBnN3S-WWH2UbYj=ZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: WkrosaAt3TUgHxXly_gv4C67fPkt0d0H
X-Proofpoint-ORIG-GUID: WkrosaAt3TUgHxXly_gv4C67fPkt0d0H
X-Authority-Analysis: v=2.4 cv=ZtPg6t7G c=1 sm=1 tr=0 ts=68d95bc9 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=FbHnbG6Tk0goxvMXmgMzoQ==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=9XW7_0HgatEhwW1_NykA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAxOCBTYWx0ZWRfXxV0PE+YCGTnl
 R+DEDjbsCSjXw5bWgfhN628KWkbLR2rgmHeDNEAw4r3ddKd5e42cqK5zH0DQj5pnNrscO2vgS2M
 BqygXb8Oi6VDIMba6Hwk63WQS2hw3qwPBT+Y7etIkt0RFk84h4Upibd3FJ9oLf6uBX5bd+ayxLv
 TniV3OdXTUGU2O7U4Ov9vct1uyMWyPcsfHFRTJNxER7EsUrHoVYt+Wx+b25MqrfCpTNagY+Dics
 YACz10Imvh6EZC15mLrDUhMFZwJWglILxtslIsawlWyHqUuMve035vigxDp+Sk4aNu1LX3TxAkf
 Jaziyy7PYBE3Pw0eDmeQdwFEW235mUuYjiWzmduMpsrggu64DuJ80SWPnF+NIN5xDFA50eRSVdZ
 hBFCFMvCOgYblX0aAAbP7oumGFKO0w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-28_06,2025-09-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270018
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D4E7E140012
X-Stat-Signature: 8x3fx6qanqj695whxsd9xwqtudsb3s5t
X-HE-Tag: 1759075274-621768
X-HE-Meta: U2FsdGVkX1+ceXmPLHFP0B6bRoyIifKdDfBNWAblmNZtykdl1G82L0Bp3AW++McJ+RmXW/8WUFVlYgyMJQr5XS8yPK7gDV2UFDHIEAl3fuLd6s08RsgjKzB1E012WOeWkbfApnaVHh9LeKyQIhaqn91vm1xagO+D3A1vPT2+wvua+bWLZGMlvNmqf822wKRMhJd4u485NMjcJcExwnhpRLmmf/CdFh9/UMnEJZf1+7aIXjhN05/0ty9AnZ8Q3dyuPG6pACFRtbif0IQrtmK1js+StYG++Ryp7Mpk34Qpi6rFBS5RvtNU0JNne0WiaiOw7qDV+z/IBxbIEJjT+0h3bH5+Tydl6Shb8gqa4DCP2ILMLQdfQpRmyKaFczHi0QZyQRDtP0F1pYWGz9wMnp+io5VjTGTR3MQv1xhHj21qwSqTaCCMnNfxVnDHrgP45/0EonPVIMKDwFJGWl3rmSFoL4dvtosmbKmxFPduUCM8R2CVDvD6bn9oQmjjku3X1aBjbUqS5Vo71Igh8ZM1mFHElhFnNH4ZfYFVORBN7CwD3MYPiTHV60kvWJxpoNjWYyRVp5Ix4t3o0Y26FyKQdE80nSWPD6OXp4zo+ALJAq0VHcYrM8qPa6Qpn2sEq7b9ux9e3SR2hFeY5ac6z6Y1/MCr4e2hc41qMwHAUs4ylGnPb+84+RWci2QoDN68BpHZR0qzUwpQXc57Q6B5nbgVPvb+oKTgOP8UZZAwuFX4kdzhwWMDRu91pxEWjBx0RTXHGD0i/MCeIwqNzPIUlfK9KHWZ97Fg6WeHOTAx8xX9WCbsNnlBorg9S9voAmiImwYZGUBBlvgnto/e9wVPsi3DW5wRLuRXT+Kw/eam6bKyta3CiMyRYOGqbRObru8t0IGwr6fchsjomm4OY+i1wBn1TNMo0Ln4DpxEpekjiaJjcNKW8PLgQvH0dMOtT/TWhx+9zueG3a88izsqRVveqSe7zy8
 6VLLs+lS
 3ttqBN7GUgpfkbAu/OzjT6gVvC2ZuGSlOcRZeAZ/0aZG0sXrnPq7abLseiXPO14pKa6QmQMsM8B14j6e/xsD3+eiyyqmFggQ4TfUQievaGd4244ZyV806Wnm6nb5z973xfwuRx7gfHPW0ZnlKJD+ESmLPBwDUBF8TgAZXlxGMZjyggQMp+vsUpi8aTiYsnXLp+SxdtYmfrVZYgn0oi35vBK0RsUOl1c+2rmjketreJIr0oBasAadGt7ZGYF8o1MPB3W9h5AnA0gHi+9YoYQhyRwqRsrNx1Y0Z/TwfquhUOnxZkzeYKDIPAnZ99xQF0GDJ7eRsCs+d6zckg0V9sUNvRDPH3w7cEOshfwzOXRG4Vu9Cm6W7qH8QEAyriFEq2/enfnzuRlS12vJUTos7MbQ/XR8UDUyJJmT8kkKs8/kiGX3dxvpAavqamlB6hKxnyn2vFPR5F7hF++BcfDjwHcMPjPB+8Y7g1HHJkZvT1bCWNbHU43U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks Barry/Chris for checking it.

On 9/26/2025 2:00 PM, Barry Song wrote:
>> 2)  __oom_reap_task_mm()
>> It holds the mmap read lock when setting the MMF_UNSTABLE as far as I can tell.
>> So checking the MMF_UNSTABLE with another __oom_reap_task_mm() does
>> not exclude each other.
>> This is more of a question for oom reaping.
>> Does MMF_UNSTABLE have the test vs set racing here? It seems this
>> check does not protect against  __oom_reap_task_mm(). I have no idea
>> if this race is triggerable. Just want someone else to double check if
>> my understanding is correct or not.
> I haven’t actually run the code.
> My guess is there’s a race when checking MMF_UNSTABLE against the
> OOM reaper. I think it’s fine either way—whether we skip an OOM-reaped
> mm upfront or take a middle path—since the OOM reaper will handle those
> PTEs with the PTL just like unuse_pte() does and eventually free the mm
> of the reaped process. It’s probably better to skip it early and avoid
> unnecessary unuse_pte() calls.
> 

I am sorry that I can't really see any stability issue b/n oom reaper 
and unuse_mm(), but yes that unnecessary unuse_pte() calls, as Barry 
mentioned, after reaping.

>> I can see this patch does protect the intended race in dup_mm() vs
>> unuse_mm(), it adds value.
> This also seems to add values for OOM-reaped processes to avoid a
> useless unuse(), in case we aren’t skipping this mm right now. I’m
> not sure if we’ve been skipping OOM-reaped processes elsewhere.
> 
I don't see any explicit flags that tells the process is already 
oom-reaped/under it. There is MMF_OOM_REAP_QUEUED, but this doesn't tell 
if it is already reaped.

If the unnecessary calls to unuse_vma() is really of a concern, then 
check the MMF_UNSTABLE while traversing VMA may be a solution but this 
looks ugly.

> Hi Charan, do you have any observations on this? If an additional value is
> added, could we record it in the changelog? Otherwise, can we add some
> description in the changelog to address Chris’ concern?
I do see that Chris ask can go as completely different change as the 
mentioned problem exist even before this change, please CMIW.

Thanks,
Charan

