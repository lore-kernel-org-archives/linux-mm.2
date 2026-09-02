Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6CF8C624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5A7E6B00D3; Wed,  2 Sep 2026 10:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C31A46B00D5; Wed,  2 Sep 2026 10:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B202D6B00D6; Wed,  2 Sep 2026 10:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EA9B6B00D3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:34:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 310F440245
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:34:14 +0000 (UTC)
X-FDA: 85169067228.26.5199FD4
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9433A100004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:34:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=leWXjE2R;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="ee7EKx/E";
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788359651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5nq8F0xboXei8La9m4xhYCwKh6IJ8CtNFoD7hWN6IF4=;
	b=SGKIKe2dRx0LUq8DQSCL+AdCE9wtLV+ScG7QOw0z2cwj97jUqQ94Tojdmyo1KEXFW/STw3
	S73E5axOysxbL0iIR2OUbu5sqyYkSJ98rrenkoduhZNJh/G1grEcRCUxMg3Sx9gIUK8TC/
	Etq6TmDA68odCUI0s/pm4Ne1miHzkkY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788359651;
	b=3aNMQDmh9pKBOEvVDH6oOXPjCi6V9AGjHFHPlcF1xOB2v130b24CCu8fj1fCPeC2opJKM0
	aJDcjuKS6stSsoZeFnU4saJIoijBQs2gbrdj27IXvKxMkndVjrPCR/QSlz/z1uncnSIajb
	27KcaqfUQweo5fzD+sYMew+tcncyP8o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=leWXjE2R;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="ee7EKx/E";
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682EWIZU336495
	for <linux-mm@kvack.org>; Wed, 2 Sep 2026 10:34:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=5nq8
	F0xboXei8La9m4xhYCwKh6IJ8CtNFoD7hWN6IF4=; b=leWXjE2R9OMgS3Kr0MGQ
	pxvMVDL8XeBDSu8+tM3NjwSGeKHPK/86EjabJLTaUdwjcOSc6YCNjyAw59bFet6l
	slMFCA2Jbtpu453vxYOn0S9QBcmFmrc0gq4P2iBRc8CsONhhH153FBkBoZHUFWU0
	hED/3nH+IC68PvBWJUIgOET0yyDcdzYF58uAeJ7UfWnpaQtEEoHFhzSrg/QLPDKN
	w1CROv6PeuNr3zPiAYkl3wMFIyaai93LdbcTcmAiDFBqkgXQWZKAFtxMJ+2N9LIM
	C86ETTwNnCaUqH9PEa3+OitF6/CUInUyrWuWzu72yWxkfSI1+kMD94DLaI3DqLPM
	xw==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ge833v191-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 02 Sep 2026 10:34:10 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-92e820609d9so237811685a.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 07:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788359650; x=1788964450; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5nq8F0xboXei8La9m4xhYCwKh6IJ8CtNFoD7hWN6IF4=;
        b=ee7EKx/ELv0bSgEyaa1AUTuo2eufWrgeDh/Z7SAtlHUsTn7CF9nIAqqoy7mziuhxQZ
         YRci2sKGtqegI1XmZdj5sx901JCZxrQqktB/Aegq0JG9TdVAzLwv7szTwJiE1pMNlRoC
         Y6e6/3kzUUT2Ul10b0C5mw68Yg8GKFfaTCtpmV1nyuqHbLdNb+Xu0apekwGpgAUC5/3S
         lAb7iQ12RbxhtD8KVhOX93EMcAd1wTAmK4V2raOt0OeKiJ9wvO77U3u70JKWUDtP/xMS
         tsmKwsGEWcSBLafoeUPSpJSLc9OA1yelnh+VgGQgRS+A/0vH3nkSaSHdVCZjfw5M2dwu
         8rHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788359650; x=1788964450;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5nq8F0xboXei8La9m4xhYCwKh6IJ8CtNFoD7hWN6IF4=;
        b=ZCc+W3JiKLys1f5bfUblAFGtn9s2qo60aXTGGZAmaoweZEFjc87CaO3pslWWs1klEB
         VBXeACWtdrbMZCJFgdpbPWwmLSqZ7sJaoXDimMNP6bdo0x3H2mumy0M6urH0LCOWiYEi
         PHY05E2abqNc7xnYGw3RaNHoYlmcDBqUPAg7Zy0AwmXJGMFlHvaSkZTEiuLPrsCPWlMb
         plmCA9K+ABqNpPfFFvLOfvK7xvBxwTIHJHG1S2AsR3AwEEEIDuUICBg601l3N8HSHAb8
         2iQJwpwBTdaplQolah5AenxPYOQa/dRjybFTD7ruh+aR+6PbB2ptQQxLlJuxErkz7HjQ
         I8Kw==
X-Forwarded-Encrypted: i=1; AHgh+Ro0+BYEutiTqv2pHX/owXvJeMBiTB2PrI9GVMzZBpCkVc921H1toH+tek0lDw4sTkD80HoADDp3qw==@kvack.org
X-Gm-Message-State: AFuF++kd6PnvTOKYzyLLrO3YNnv1BjeeeEtPhGYIRhkKJ7aa4m2nLWLv
	/5o/+ymezGS+ZmyQULXmyyRRHdtZzbE7dCTFjqPL0K593VPknW4QNKfn02tUB+tY3ozYdvTC+1y
	NYBFHoSEQE4ZfizpF92Z2CCyGALHl/1o5qG3ZDC7l19JMUWsH
X-Gm-Gg: AR+sD13vowJ855mRNuiPc+uFSOIJZ4EGdy4pzXme4uVtCNyWBqgyX/jmLn7jbPgJS82
	vR+2XeJ/N6YnV58Z3/ZdtUY4GUtL9ksxjK9yqj9EWQBGyBqol8hDd6orfSgdkixRMMgx40t8dcD
	PmqqjKO47K6BGJe80TR5TkHUKKVNcFsJNZTeFHpahuRCekq5ltUBYSlAv/K6HcNILsY9NjWBDqT
	GSsScVHGil65bYEc1Y0Que3IHi9Z+YF4NghE7OhTQet1+y9pZRxK/DeKtT6SoWE9vuHv7lnW3sr
	EY5nHSYBhmL1CZgHiSGuxwyoL/NWSwY+1Yc3NdZWmo1jE19g3Aek7tT8i8pYCSl7mcAqQllO6my
	E6D6O9jLhj4rT2Yn70B2bEil1OIn8gjohcwdx37ZsjY4nG3YNqeI61EPjSw==
X-Received: by 2002:a05:620a:3196:b0:92e:71bb:d1c0 with SMTP id af79cd13be357-93960dea964mr622057785a.15.1788359649517;
        Wed, 02 Sep 2026 07:34:09 -0700 (PDT)
X-Received: by 2002:a05:620a:3196:b0:92e:71bb:d1c0 with SMTP id af79cd13be357-93960dea964mr621987485a.15.1788359646377;
        Wed, 02 Sep 2026 07:34:06 -0700 (PDT)
Received: from [10.207.49.22] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c25d043e6bcsm152362966b.61.2026.09.02.07.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 07:34:05 -0700 (PDT)
Message-ID: <dac0f543-4687-49eb-87ae-500ecf32112d@columbia.edu>
Date: Wed, 2 Sep 2026 10:34:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/10] ceph: fix error handling when the OSD client is
 stopping in ceph_submit_write()
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko
 <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Christian Brauner <brauner@kernel.org>,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
        Sashiko <sashiko-bot@kernel.org>
References: <20260817-remove-wait-on-page-writeback-v4-0-0e5e53d47eb0@columbia.edu>
 <20260817-remove-wait-on-page-writeback-v4-1-0e5e53d47eb0@columbia.edu>
 <CAOi1vP8SCZaFTodwm3_c9cFfc4UB5X8J8vF-sxh+4TuhCS8iog@mail.gmail.com>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <CAOi1vP8SCZaFTodwm3_c9cFfc4UB5X8J8vF-sxh+4TuhCS8iog@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: HsTYzg3d6FT6I18JymO7up3sHGIJsWK7
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDEyOCBTYWx0ZWRfXxAbnwqsfMfpM
 XB0Kmh7X0Q93GV4ufsdpJUydRh56ceaORP9YsXvofQRSAfTDx6p3hIwUtsIkjPdiYofxgdQ3DvS
 tuvCRmi0DzihU3q75HGlYUEGItVYNvcFy8Xpi0slvKdvYpZXdsir
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDEyOCBTYWx0ZWRfXwW68n0g6NSFO
 9PDn+6NCb1LCGCJtjlOSFXx75zyGHwngtbwBZFr3P4bN1+2iihys4Ece9i3WmtfGLwVrY1+KUky
 GjIXN5KsoF9WzyNwr+y9exTX/TE4wn1iIQYbZX3bu1JXXlKkYNQO9Lh+6vhI0GEjm1ugHg9PYMc
 WoKVVyqfjIAF1XZoDtjm0OAW+JnzEsZqHCkbxTYIiCVxBNjqUHeMlNgMTeXfknjRfGRcK/6B7Bm
 AUtbb+kfJThTV0duSqqvLT/HUdGW6pdIknuXPolqKdKbsJhJkpAXKMiqGwtUaLL6uPxRG602k1/
 j1hJaG0sX0J7QLQfkLkNCWJxS7q6KBlTQXmszo6ua4YuJAFXeg3xx8pJcnLKzVtm3zmhvkYuir8
 SGKfhO7cW853lmaFqnI/m5uCYORQ64NhAJIxKN8Hnt1dIAkKPMJDRC3Obw9nTiDcWeNU7BIEZvG
 QA+vQ9GSQ8vYMUWmdhw==
X-Authority-Analysis: v=2.4 cv=ZpPd7d7G c=1 sm=1 tr=0 ts=6a9833e2 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=uherdBYGAAAA:8 a=c92rfblmAAAA:8 a=VwQbUJbxAAAA:8 a=TZ2kbKYv5CYyi6T0hQQA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-ORIG-GUID: HsTYzg3d6FT6I18JymO7up3sHGIJsWK7
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 suspectscore=0 adultscore=0 clxscore=1015 spamscore=0
 phishscore=0 impostorscore=10 priorityscore=1501 bulkscore=10 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020128
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9433A100004
X-Stat-Signature: wka4xrtf6sdfnfinhp9sse9sjy9pke6r
X-HE-Tag: 1788359651-941818
X-HE-Meta: U2FsdGVkX1889DHaieCIetJjjcw4aaG7a0YgyCBW8KaU1iDGtD/qgaQkFccKxDrwgFXA1Ti9d66l+19nJ3Ti+YsngnyFfxyQM9Kf85+BEAKGX8xE/30/qcGzb0QUTswkk8MUMsZQ94/93DXQw9MQEp7TZ9mPJdUfqj/r4H9l45KXMxf0YDjcgKhjfyG/mFhf1crGu1NSAOhZMwfTa6Kf8pzG+NXqmMChZ9Z433y2DfuusuwQI/V7HIxPR2Wvu+Byc7arGHfrKsTq/0XzgVsDTuxhJPrMnGIuyIlmbvxN72f1gJfcihEfpgFD95tgQfZBnUFpuMsaANok250USDUdiHdeyl2sv/EJCG8F54nKQ43G+opaQL9d+J2mB2dCIi0k2zT09/xyDdB0WLgBOvWbbvH6h5Lj2cAi7K+10aKk2A1+HGwdftXc910B3DoLbyeua41GdIkObdDoMJFVXVJMa0f+/tKPmQiVpyhLkCCbrqNC7XlOHshzwewSv83VcJPZ+d2husirz0EIE4w+ILzF5RabZieXNVzQs2hdg7bU1iVE7eTilO58RlffsgRoUjH0S8E0CVPAJIY4fpZ9tQdw8xjGzaBLAQAvDqO3iq/XE/ztcB0LYd5HVrIqy0+NvxmWgcMZ4gRayxYoh8gU6q4IRlIWbCnYyglBY6D6FQRQC2GXveCj5UfeZPO98PL9dALoNU3e06Zjo//HT2TbW7QcnXfsyo8MQOYak0bVjjisQrWgbYHHxwGLyZYJMZw06I4WHUmbZp5Jq6tCrihlv3Y2i+HWBe74pAp8DNdGttW/UKGxBtZOypPepVe9oPLE1FE+4q6oWlO1gBwkE6x21aqt+O7tvEB9A8J4t0mvuLEsmFai+nRcsxGG4y43bxANHm90Mo05X8vn/1SfIwrwJCh5MxP+/2ENpz0C+foCT6IwEHEHSzDrNvNy3/ckeqKRpcKhv0EDDaGCBV8PggpyY2Y
 Pwe9jVMZ
 seH8cfFAVJ3C6rT2hWe5lFprbxKSfcPDXiy5uGeDdcXSX0upHUzzv96kXyhuhBTItMBTTGJ4BXu9unkvcjJBEixqTfqP782Zx+m0dl4wzTY7T5b85arZW7vkIcuYh1SIcATMJ66/u6z3XoNQ34rV5MAKKm885MUcwE6KVbhvk6e1IyRTjL2NQKXf2UsCZt+X/WiPEXEmktnWnchhi2U3QmHFBIHNI4xXCUJdXAuXLINL0QUqmTZS0tKExWWyFToTXszT5ueSsPKByUR4HFTQ+VSNRMU29EqrVADk+jIqXYqFDnYTvrKMJqzWBcm+8kc9O9ttzpLpq52YGV/aGdmm7w/C98+ec/GSk8OegOMutwO1+LN6I0VpuGh5ssWDjyBhqSop/b9S7GzE2RjdD6R4n/Kkh1AlfLFM+xrxIIfpwr2Ou0e9Z+HYHodt9hzsXmwBTiLhTt15JZmwZhYcNrX3gwrGnxWACcKwb3svDi19PvcWBMS3W3nQzUGBWHntbkq7gWB2GULWGh3iirt1e3tWHhxe4RsaKW5uIup+rDVSAdBpNAlNjiQCx05e34Gt1fsbu9Fsaj6pHoHV950JOHwdlQgOAft23xGp9nyQ4BNmtXlRYTWa/JrmPIsbw8Jfu4E29f6PV7z8ltyaL24+BfADeFr6bhU/YTmyPT3+Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 4:44 PM, Ilya Dryomov wrote: 
> On Mon, Aug 17, 2026 at 9:15 PM Tal Zussman <tz2294@columbia.edu> wrote:
>>
>> When ceph_inc_osd_stopping_blocker() fails, ceph_submit_write()
>> redirties and unlocks the folios remaining in ceph_wbc->fbatch.
>> However, none of those folios are locked at this point: locked folios
>> were moved to ceph_wbc->pages[] and removed from the fbatch by
>> ceph_process_folio_batch(). Unlocking them triggers
>> VM_BUG_ON_FOLIO(!folio_test_locked(folio)) in folio_unlock(), or
>> unlocks a folio locked by another task.
>>
>> This error path also returns -EIO without fully cleaning up the folios in
>> ceph_wbc->pages[]: their references are never dropped, fscrypt bounce
>> pages are never freed, the writeback congestion count is never
>> decremented, and the pages array is leaked. ceph_wbc->locked_pages is
>> also left non-zero, so ceph_writepages_start() loops back around and
>> hits BUG_ON(ceph_wbc.locked_pages).
>>
>> Leave the fbatch folios alone, as ceph_writepages_start() drops their
>> references when releasing the batch, and unwind ceph_wbc->pages[] the
>> same way writepages_finish() would have. Abort writeback in
>> ceph_writepages_start() instead of continuing, matching the handling
>> of ceph_inc_osd_stopping_blocker() failure on entry, as the OSD
>> client is being torn down and further writeback cannot make progress.
>>
>> An LLM was used to verify that the cleanup was comprehensive, and
>> suggested aborting the writeback instead of continuing.
>>
>> Fixes: 1551ec61dc55 ("ceph: introduce ceph_submit_write() method")
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Link: https://urldefense.com/v3/__https://sashiko.dev/*/patchset/20260804-remove-wait- 
> on-page-writeback-v2-0-81f0ab065284*40columbia.edu?part=5__;IyU!!BDUfV1Et5lrpZQ! 
> WQ0-twAxqcZ2nQ5MBrBDnqIxwPV4RXuFNZvUldEY6jTQafdUjhi46Zgym70Ltd8gwAKpSl92mam7YO- 
> tlU-7hw$ <https://urldefense.com/v3/__https://sashiko.dev/*/patchset/20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284*40columbia.edu?part=5__;IyU!!BDUfV1Et5lrpZQ!WQ0-twAxqcZ2nQ5MBrBDnqIxwPV4RXuFNZvUldEY6jTQafdUjhi46Zgym70Ltd8gwAKpSl92mam7YO-tlU-7hw$>
>> Assisted-by: Claude:fable-5
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>> ---
>>  fs/ceph/addr.c | 36 ++++++++++++++++++++----------------
>>  1 file changed, 20 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index 1f77aec8e960..d5a349daf4d0 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -1482,27 +1482,28 @@ int ceph_submit_write(struct address_space *mapping,
>>         BUG_ON(len < ceph_fscrypt_page_offset(page) + thp_size(page) - offset);
>>
>>         if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
>> -               for (i = 0; i < folio_batch_count(&ceph_wbc->fbatch); i++) {
>> -                       struct folio *folio = ceph_wbc->fbatch.folios[i];
>> -
>> -                       if (!folio)
>> -                               continue;
>> -
>> -                       page = &folio->page;
>> -                       redirty_page_for_writepage(wbc, page);
>> -                       unlock_page(page);
>> -               }
>> -
>>                 for (i = 0; i < ceph_wbc->locked_pages; i++) {
>> -                       page = ceph_fscrypt_pagecache_page(ceph_wbc->pages[i]);
>> +                       fscrypt_finalize_bounce_page(&ceph_wbc->pages[i]);
> 
> Hi Tal,
> 
> fscrypt_finalize_bounce_page() was removed in 7.3-rc1, so this one and
> patch 8 need to be reworked now.
> 
> Thanks,
> 
>                  Ilya
> 

Hi Ilya,

I'll send a v5 today.

Thanks,
Tal


