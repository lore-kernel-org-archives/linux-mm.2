Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89CC6E9B340
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 09:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3376B0089; Mon,  2 Mar 2026 04:50:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50926B008A; Mon,  2 Mar 2026 04:50:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE4C6B008C; Mon,  2 Mar 2026 04:50:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D24D6B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:50:13 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5300A1CE92
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:50:13 +0000 (UTC)
X-FDA: 84500652306.06.F9933F3
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id C82001C000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:50:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=OIzRQTqF;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Nzd90SbF;
	spf=pass (imf20.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772445011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QRKxM/P9l/2Z1hR6WxyeRaZQ55JcQ9u9VYXCLMJIR1U=;
	b=pMqnA2X3HIOSl2kb93vIMqmwvB0a8UaH41kq3cxJMibmwihNyTdUM2bG+01OxNlmR71yNA
	x0Ivynjv98qBG9MNXNfePh07Zhl0UlM3IQdu4WboB+2XIDmJafJDmN+L1QGdAinV2SGc3U
	3KwNBv68lvAbMWNsBOMbip+8Vgtyrlg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=OIzRQTqF;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Nzd90SbF;
	spf=pass (imf20.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772445011; a=rsa-sha256;
	cv=none;
	b=Di0MpZW/We6HjXDkYwwgM2fazBNd+tsHWWIXJhs6rNG1FYpTjsDaFFuIsWvm8V6jWisA10
	mVwumKK/+PuKpDAVs1vPpMYIj90FEUIhgc++4lgzI6a9Ympg3kpdGEVMwLR4wSSbqgpRCk
	H4YVnDP/VJTy/b41HWd1+L7vCWCTIE8=
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6229Jchb3742181
	for <linux-mm@kvack.org>; Mon, 2 Mar 2026 09:50:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=QRKxM/P9l/2Z1hR6WxyeRaZQ
	55JcQ9u9VYXCLMJIR1U=; b=OIzRQTqFJipxKuT+C6DHeqrfvDJYYRPlB/CM+r1w
	6T6L55qjSbNMz9tX0sQdtFbked9kH0Q1OSGmoeskImmKnZvdLAhehs50qRTihjwP
	jsUcf9dniYuepWQIeWEc/pdLT94X2mrrOP6TRIg1T6CIzzm3w7EwgW1NELDImI2U
	wlNUc1krHXfqFLMkIZ1hSGwNc+FIHN/2kvvwi/fQ3b7HHN0j8TIr8VIgwWPjr/uN
	BXuT5dnhDVwtD9/5mGcm8E9TbpgfdkQLiTD7nIZlMF5JKxj3qRZw7Xicpz2y1t6l
	vowH+8dS/EKVvpvJ75MdqGY1zJDQCKLfUOZqaiZn38Bi8Q==
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cn7trg444-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Mar 2026 09:50:09 +0000 (GMT)
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-45f0bfd68a3so21611865b6e.3
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 01:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772445009; x=1773049809; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QRKxM/P9l/2Z1hR6WxyeRaZQ55JcQ9u9VYXCLMJIR1U=;
        b=Nzd90SbFaIYj/UNxsbqgUSmM3/3fD+iFghzSSQwMRIPhE8pgHWl1TJEFi72ODpJivr
         YZ2Ds4mqWVWEcpfWJPDudzIx69PmrE1d8V9avbLpyxBujdkSjLUthfcB1P1Wcx7+/Uo6
         EfeYrd3oh3XiTaRydm4G3zNOP4eQhrS7aL2ZmRwj2mRd3nBcziI/gQDWYVDcHlU3DcRS
         eMkZv53/k3GoTwPrMnfdjAN33pgpxGN8ed/a2gFf4/nGF57H3g+WfT1xMW+CJXQVZ9X1
         SV7p79vS+QtkhG9/1z2YO5uySa46mgZpkTQn3TO0/YkY6Q9st2y5dSeuxGX4jHAIiHy0
         NldQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772445009; x=1773049809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QRKxM/P9l/2Z1hR6WxyeRaZQ55JcQ9u9VYXCLMJIR1U=;
        b=STKjVssXxvxD+UT1cewqt6kq27aAfl4CUGwCtiF3DzCQ2+pAIDVwd6IUj8imUwz48Y
         T0ib3a6vnUtRBPCHnP6to9Bgahtjc2nQ2OAJtUI9RqcnSjtVUykAm/wwAITttBLDZDiM
         FVwnQl3Cwd8K5IMRZwe3LTZXCc+JcdKTxE2HYuXFNuIUjRbENA7khnzeLU1I712RhZsP
         np4HUMpwsK/xvkMTn4ZpvS5UjrZX+T0MKKlKDg6GggOhLu4C/oWj/PaxVY/icmpdTE1X
         1E9PxK83H2GIjCwDPen0c+KKIrAe4sGOd6o9WLSjEaqZRPVUxd2mQgGoqkKk+6eo5t7h
         wLpQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+E589yYTY3KhVzIqH0ClIxqIhAhwRb4NiZny8m1VKAKIsMlfgv6HLj4Qrz7hs6yq5bNCjajoIkw==@kvack.org
X-Gm-Message-State: AOJu0YweH/i1srEWaWdl3XbsX7IsPOyZmkc/V8BB4tusDxLrvBq9kLCp
	DFeZt1MTGWXtcYI9cfrxOVI5XrFcknh9CQ2gMMc1ngRgCD94nQg+653zSZj9iEZGeF+L+IdvI2T
	o2QEtJ7nd5JA3y4Rz5/b7faiiJcZDLlqatHqIuV/8xQiTqG07ERNoQg==
X-Gm-Gg: ATEYQzxFdB1J9T+Vj3EpnJdXHHCRbbZkSnaLolASv6izhBQrrQSTMxiX1nDzxASvZig
	1vslZ2AofEOixvOqLX20lxm6OM3f9YNP6UC6aA3YG4KvoKbhENLPqQZ4CtvDhB7VEk3+qrBD/Qi
	vlkcWK1mkK3EI8zV+hfD5oGRSRNE5n1fM0Jw/zQTf6b3WvhF+t0vvmfZy4FbuDr+hrQZXObI2CS
	l4OOvQYEiiPT9oJqWjtUqpaBJ+Eyn6V9zzFnIM1X5sLEqX379yU1O1/zfBS3I2xwmS8Z4cGSzJa
	7tHqKqJ2G4eT2DMcey6hBxvm2WrpwvmgwnXC+fBQ6c7Pz6OUFQuJrRpbLm4JQAO9Evfnu604bsc
	ln2ohVkvYRvyfrLb6HITW7EH1fYhR+6d9vl+x8ULRNhwpcC78xlIKQpGaxDvLmdAj94OAej32GZ
	JtAyA+
X-Received: by 2002:a05:6808:1705:b0:450:b7a0:41ca with SMTP id 5614622812f47-464beceb57cmr5117097b6e.22.1772445008444;
        Mon, 02 Mar 2026 01:50:08 -0800 (PST)
X-Received: by 2002:a05:6808:1705:b0:450:b7a0:41ca with SMTP id 5614622812f47-464beceb57cmr5117069b6e.22.1772445007942;
        Mon, 02 Mar 2026 01:50:07 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb59be78sm7391540b6e.13.2026.03.02.01.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 01:50:07 -0800 (PST)
Date: Mon, 2 Mar 2026 01:50:04 -0800
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Michael Kelley <mhklinux@outlook.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "decui@microsoft.com" <decui@microsoft.com>,
        "longli@microsoft.com" <longli@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
        "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
        "surenb@google.com" <surenb@google.com>,
        "mhocko@suse.com" <mhocko@suse.com>,
        "jackmanb@google.com" <jackmanb@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "ziy@nvidia.com" <ziy@nvidia.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 4/4] page_reporting: change
 PAGE_REPORTING_DEFAULT_ORDER to -1
Message-ID: <aaVdTM3ubiDa2ELR@hu-ysakshit-lv.qualcomm.com>
References: <20260227140655.360696-1-yuvraj.sakshith@oss.qualcomm.com>
 <20260227140655.360696-5-yuvraj.sakshith@oss.qualcomm.com>
 <c618e7a4-42c1-4438-9bc2-9c41450a81a2@kernel.org>
 <aaUE7M9QkfnYh12e@hu-ysakshit-lv.qualcomm.com>
 <SN6PR02MB4157D37B3D254251F0135B04D47EA@SN6PR02MB4157.namprd02.prod.outlook.com>
 <b1390b24-eaef-40e0-a16b-77c27decb77e@kernel.org>
 <aaVDiwEPl5t2UPX4@hu-ysakshit-lv.qualcomm.com>
 <a0133403-8ce3-45a4-987f-96fb7421f920@kernel.org>
 <aaVQXbllLVBLZCwQ@hu-ysakshit-lv.qualcomm.com>
 <571547b0-007a-4cf9-be1d-95a0ef871cf8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <571547b0-007a-4cf9-be1d-95a0ef871cf8@kernel.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA4MSBTYWx0ZWRfXwBx81oijnx/C
 +MfVB32KPZR5A66qNkM08bZ0gPR7fInTAxk+Hud8u/eXEHMWxnYFJKZZASfpT+tnuzsBCycCePT
 0IPxq+CoACzH6WgE0ooTkSn1d1/gUHl0UIoWfu7/PbLrehpg+3lfxPzWgXCrM075dBeHu8WS9NS
 w6ASrA2KHoT94P8WuZCQCBlWhplP3+1y7J6FtQy/NOxt9ElUJsmDF20QeIbRetecUtL9NDg3LPK
 dXaPM+Td3sMgo6a+UbXP+j59DoBdMc2r0uoacjTxU2bjKG/G5FHr+DVWhn25Dz3S9kuHq6aE4Aw
 PA6z2giBogC+w8STC+4ub0tN6q8T9ltpxLUUF+KI4pvoYKqoTjmZpXaLYw8IZ9i2i1qEHyjvTKw
 fLiTdX6/NkWkcNv62+Afg0fRNJXHUbfJGBJH43cE41enUYsV9fiFHBYEA6/y2HuhvfXZGy0dOZE
 HzGtLjudK3767I0/rxw==
X-Authority-Analysis: v=2.4 cv=TNhIilla c=1 sm=1 tr=0 ts=69a55d51 cx=c_pps
 a=yymyAM/LQ7lj/HqAiIiKTw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=0mXQa5sO9039VI3KVg8A:9 a=CjuIK1q_8ugA:10 a=efpaJB4zofY2dbm2aIRb:22
X-Proofpoint-ORIG-GUID: BuLUTR7PxNj2l_ygosv_eq7vT7G86Nw6
X-Proofpoint-GUID: BuLUTR7PxNj2l_ygosv_eq7vT7G86Nw6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_02,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603020081
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C82001C000A
X-Stat-Signature: qzomphsry5ow19uiu8cb6ihkxwco5sod
X-Rspam-User: 
X-HE-Tag: 1772445010-999491
X-HE-Meta: U2FsdGVkX19k2DxIvIIxehaPRpRTIoq1MtqwLezqAuICaW5Ny3vLkZScdEzyDaWASt/le0U+Q3BNCvU9Q7vo5D7n8hkxvokVESWfzdB6pdXaydme+o8JJKj81zuDzjzUVZmku0HyCH2X5dw2qHNLWW12IpJwpj9YkdB3qLCawAjA5HUvTpHW8u9+KiNGoiw4nG2aeu6xyHeHlWx0GSl++5uccoVDkI9H4viRM3klZJBr8HytDF/Ixxr4TsGCMsoUQNcTcP3YAllWRLfCGQo+WeNMlFPMyA46bkRmiQk6+G8RNW972LVZNJYbxkaj09T8sCi9oFqv12a16AJIVOWyyBVn394G1TgacdO8V2xp+MjKppppiYPUJ8PaPbqb/eg2gXXZcMm7O70/ou1sJWh8baSoxtMXEaKnHgPMAXhwumaWDdWUB9+36waS+4G7L88ev0JciUOnIGwwjyJ6JF1eRyYRUq1/TcHi5lgkysbJxqm6sVlJKo1gmrfh2MkXdiachyas5zstj7S1eBg9i6ms2h0+sLk65L3uO5kt/xXoE3AmxOakZ0tWE+LQYwW6dPnUMgjOdc+IFZXOzKSa+DndKOSW3z4MpdUXnfkGXCScsVdzXpO9ntCYgHxTf5lmL19dnJi5zsU4V3wMZeP+B1iKAJjyL3T9gOA36llEhtTnyOozozzIammJib9bJmRgg0gKzdfok64rJd+tF58BvSRFRTbV0Z3GqzIfWPrKSGVlnYl0oK71frH5R39O5rSte0BBt8Ytjg39Vtqt6glwNUI6qtUgwdgoYW8jq4k5x51qBHswhs4bGl/2YiVUTcjy/+K+65U+jq8gD9hM7xn85ctqGRHHJO/CBD9ojEGKU+HmE4ej/+iVPFTIdx13UUJVQzfShL3AtKQ0p95Vwei4J2MoMoyTaAuNxoyEJ3SGAyQ+t0ktEJIEqqGNz6iaPJsboB5OTO8m+EqO+yqO9FFecg3
 vugTJWVP
 hBQ0T0uMWc0wtl2IErSEnjiL/k92gN06VuvrIw0DSwR3imCzEf8hQUurGX0mx1wsMlr8xwXYpR8+VdNedKVWDxtbYxZMzNoFYppC2mUdqsDqkRwgGdNSEzfa8ELvePGBPV24irkGk9Yc8Quf+OkRjAQqCXOPmTvNX7SgGq/WZNPYHrHCfBI9xyoF+9twkuR0Ew5O9VbjCv7XcQctR1XPkUlHKkUrirFB6IpjQ9JmpZqLcV8KZmXC8Ai454KoFOqzxsD5861j95wntcIp9b0qtkr9NEyBDCljAl3Ay7lsBwCcYFSZbHdwdEhg0kTW/c6eUd3zG3y0LUfdp7iA4AWqxEWFArRmvHQj7tfS0TdXKrqhmT9Z2csMbYpfMBA4biEdsMyrRvcL4/LuArflNqrW8aOdCnFuUP35EwESlFTIbfdGdhc7TkSgP5EcLN9LH4NRZvsuEsTgtaG0jXvYPw1teAu9U4zLF1J4pPmJzVUykdSDXHIHqSeU4RRfe/4BrgdQyDAvmrshwzhi2aAwgTKNSG3Jgh2zS3y7EXAW/euW1Dj3Wbx/SwEtSEVTDCTuQQ8lEryrQzaarsLjOtq8fpWd/Oo9PViuodROcvrUdFLRXqsRUNFT2kWZeFpZilt9ZDLR98Gp6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 10:18:23AM +0100, David Hildenbrand (Arm) wrote:
> > Great. Much more clearer on page_reporting.c 's end. 
> > 
> > Don't you think on the driver's end:
> > 
> > prdev->order = PAGE_REPORTING_USE_DEFAULT; looks clearer? As compared to:
> > prdev->order = PAGE_REPORTING_ORDER_UNSET; ?
> > 
> > I'm thinking, why would a driver worry about page_reporting_order being set/unset?
> 
> Maybe PAGE_REPORTING_ORDER_UNSPECIFIED ?
> 
> In any case, we should use a single flag for this. Everything else will
> be confusing once drivers could use only one of them.
> 
> -- 
> Cheers,
> 
> David

Sounds good. Thanks for the suggestion.

Thanks,
Yuvraj

