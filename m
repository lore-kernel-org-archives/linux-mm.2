Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA4B2606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 06:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=RI/E6NUQ;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=HAZiNr9f
Received: by kanga.kvack.org (Postfix)
	id BF0336B05B2; Mon, 23 Nov 2026 01:11:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA1566B05B3; Mon, 23 Nov 2026 01:11:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8F8A6B05B4; Mon, 23 Nov 2026 01:11:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85B076B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:11:15 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D3101A0792
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:11:15 +0000 (UTC)
X-FDA: 85465361310.27.2CBBD73
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 69FDF180005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:11:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="RI/E6NUQ";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=HAZiNr9f;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf24.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795414272;
	b=usXW98JopecWgo8l2F2CRwVuUn85li+FfOx7jRxSpgej5DLxC0hNEAsXF7ocQJ7THmWo5V
	4NNZ9GIfw3AHMPzt9aXdp2Dxa2+7ddBl5xrLNw5Jv1MKh6c7THTOcDgguXlLJ0lR+lGJCm
	WC9h7dv0yeoBTkLEeHXBY60lJH5bRmU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795414272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KSzhoyMwT5e6SQRPRpjDWz3LMqHPstqyWrWP4FXLkKw=;
	b=8OevXE6P7EZxel8eCVJN879MkUpQDXSVVtWnP0j8fvEhMMAj+H4ODONzOU4IZUBRucyLYa
	+WeIPefkN4XBCpeZtVBT8y5ZVYEc4nv3GWMoDXcbhjP3slhDvUIyRA+SnKABqR+JinpiSF
	K/uALFmWlX6815znh4fRBpylm/hN3FI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="RI/E6NUQ";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=HAZiNr9f;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf24.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AN69ruP2167840
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:11:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=KSzh
	oyMwT5e6SQRPRpjDWz3LMqHPstqyWrWP4FXLkKw=; b=RI/E6NUQQfWF+ohmzMg6
	+VOhfBY83U8R+JfprawtsYS2H+16DJCjm1N4N2YDu1/Wr4L3HV4ExwOjeL/YVfl7
	MxCMkVsh1DudQiwPLm94HVzuSSZ5UIIMFaZgqZCjCx0JYDwfxov360yQl6P0Nvyl
	nw87TuIsFclP5YpzE5Pc53vtEgvoPEat/AtYgXQ9DSTGWq9xXrq1b8BzJ9fdqpfz
	znsWD37QGd/eM3/ha9J70B8MQ7OpWW/h1ri2BQCXBIF1EHQ0UEEDMKOiMpWuvi5j
	l8vwQwObZ4CzC0kfLRpo/v5emg/ReANqGWfP+A+U5OkSaJp2O7tQYIYdyHTClz1i
	bA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j43ge2xwn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:11:10 -0500 (EST)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-94961ed97d6so533207685a.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1795414270; x=1796019070; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KSzhoyMwT5e6SQRPRpjDWz3LMqHPstqyWrWP4FXLkKw=;
        b=HAZiNr9fNXTnIXvrzbIXRGA05O8ZpJp+BV2WIGLDIbWCmhvWoQFlLH6D6u8lh/OAUC
         NZhx5C3ihtT/1rH2gIsM0QaOTnHJvRHlr+uEHJ4RyFzuqMgw4VRBWnCWW4w2fVofGnic
         CwTNTcPBREAlLebfbXRuqbWLGKLNUT3k3wjuQOzbE5ZqV8BpyBg8/Mf5bJ/cne9rCNWO
         Vg9YhCEqMU+FvhL0JxyG2T8hvU2Adv97IyxkExH8ogs2z+iYM6tGCEurRYT/r8NDG4Zq
         4frmdEhPyZoLF+9DcH9tpwVGtQU0efFIKPq1A2yA/r5ks+VX3F2mXi3qmTj9ve3vjDGx
         IITQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795414270; x=1796019070;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KSzhoyMwT5e6SQRPRpjDWz3LMqHPstqyWrWP4FXLkKw=;
        b=FXiyXMpr6vdKlVy3URJkIi8MU76hX2Y20yLmJPNQi+ZESUo5Bvx51mY6aumXEJN5Rg
         hM5zGsrIwGcUxHBT37uRX0K3Jsok055A8PKa2L3Ou0YTJFtFzVBcTq1kGlboAuLmegDA
         i21rSjLJs51Rjsfd0asSlz9IoWEipHn1n06R2zvLXkhpp+CSHuPkuoLf2wSZLmETThki
         FvBSqb/UfIs89zq8SXHdw0HDYvtm7mB1E1/nAT/+HuCbV3qs6Jk3pe1uMXn5t6N0wEeK
         L4Ad41+nZARjg/eXXoWFQ0JY42s9KD0W9/7Dsh+jWEaP54VncgyposR+DUtEF91RKkgK
         o+Mw==
X-Forwarded-Encrypted: i=1; AL+hErGs3z+fyLTGpfPXuFTUaRRp362M+bu3gdfBx8FjyG19B2vpUEE7Q5G7EoZXcxxkypBW0V2BmTwOSQ==@kvack.org
X-Gm-Message-State: APuU4Z+tcuPcHlVhBqJ024e5t7KWCE44Ui1dRM3/JXExeTIp7nqVQ153
	OZAJF91PJJWZT8n0V/itjns+bc96GAWhFxbMz4BZHjrCo7UMkSGZl7EGkiznfsH30DuzbdJoqME
	itQ3TmEBYRRhkE6QMA578xN/a3ESmip3n4A6jY7GNZlw+OlBt
X-Gm-Gg: AZFdTZfPC1ik7JUkX8XVWrYH+iarTFBO5N5gV8sDE9Yw7Yns43PWnLWHZkuMnMj1VuK
	dED+uldqFncwHl+VMrlJARmAnpjfUUx6kOTJ9A2Ji/f63aMCPMfll72lHtzf/LGY7hekZKLKrZA
	AEpl5t1Ll9/BIBWQ7H9f9PSgE9Hd7OE46puzPZgIvH2z36w4Odek+KhmZrxrXmFjIpHTxEKbeZz
	Dg9raTsZPCN2FKbZ/4DJ9mysEwR3P/945UhvSUIjHEGePT87sWfFrMhMi3Owe1sWoNivqicyPzk
	uOnG4pE1wuk4eAXhwYI12SRWA+J7emq4UnyWCr+O0Ds4SvTnQ8SZSadqlkGuD5+496hyHatDBom
	8O6ZFH4MtNy0WVjuRSP0JPygwy1L6ReFYFl3H6mw2PLiq4IRVXAm788qqCcXBuwt7Ef06w1shED
	i90pEij8LVD+3F20xtPzibrDX2lRjWKPccdHmBFGn0LxyD9GdJ/mML+bn3B26hwuqTMfkCuM71e
	EjFlez/o9/53hPTQnyqh55Q0Woh7GFvoCgJHtSwBszogurxk51rw9JUDArwvddxIX26T/dXJdT2
	8VN2hwB0jQC04ICpMqzAoZY=
X-Received: by 2002:a05:620a:1727:b0:949:8109:67e7 with SMTP id af79cd13be357-949b3815a51mr2001859185a.36.1795414269937;
        Sun, 22 Nov 2026 22:11:09 -0800 (PST)
X-Received: by 2002:a05:620a:1727:b0:949:8109:67e7 with SMTP id af79cd13be357-949b3815a51mr2001857785a.36.1795414269671;
        Sun, 22 Nov 2026 22:11:09 -0800 (PST)
Received: from [192.168.0.76] (dyn-160-39-51-212.dyn.columbia.edu. [160.39.51.212])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb397b4bsm738891485a.21.2026.11.22.22.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 22:11:09 -0800 (PST)
Message-ID: <14836a15-94d5-428a-bb1b-abe4dfc0bc12@columbia.edu>
Date: Mon, 23 Nov 2026 01:11:08 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: annotate lockless accesses to vm_committed_as_batch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>,
        Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, tz2294@columbia.edu
References: <20261027-kcsan-mm-v1-1-66757485b917@columbia.edu>
 <20261115113851.f809d47b8356755c229278c2@linux-foundation.org>
Content-Language: en-US
From: Mani Tofigh <mt4022@columbia.edu>
In-Reply-To: <20261115113851.f809d47b8356755c229278c2@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIzMDAyNCBTYWx0ZWRfX4nWdQIMCMqfO
 VuSAwOYRlglkh+RhQ9jZVSGjWu85gKJ1KsG3G1ODVqT7PpGHtDJg7sNc3tuKReiop+SVvkDXmxK
 SMuyy2HU63DUIxw6nmlHmx4xF5G5nhaAUN11FlFqOzxNZkHnT7ek
X-Authority-Analysis: v=2.4 cv=c+M+0h9l c=1 sm=1 tr=0 ts=6b03d8fe cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=l9izRfKDRJJ6Wn/vzKnQSA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=GDd2V6ikjrV5M50Z0s0A:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: Qt0kFAYsHG93JbPBWDMRXnRvE3-QEU6X
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIzMDAyNCBTYWx0ZWRfX6Gx28EOno0Wu
 itw137wHKI4odlbv40nnfmTCztpn00ef2E/uLd4R4b3FUHIE4ZHd+P3osmfuZ/ZC5gkqoig9Gos
 8Ju6jBx6q1k1FIPU8KOj3C47nc3qfrjnOv5xoYgDTWYNLkV6tXmDWKHTJ/07eIIbQNToDklLaHm
 oEpL4AGHknA9rVn1vFysEFmHOgqQe9KY21hR5TVhgTmY8rCajVyw5PtXBiyK67VNi10v5N9+B5J
 1UG/WfBmjWdeSFAu7ZC6bg31LVhaWtPfUw9b+OOBJPK3X3phzoySmhCSp4n8z62FhIZ/c0bbcFp
 Lf7+/ETHoShwFFx6epb/SXLvUmWOfLBkwnfIO5kp8NeKEOY0/fca0rvwSuNkO3anYPCUlLoyFbq
 V6gSEsMYrjMFqAyj4d9iDmNYVrssHGjDwTDewwkUlaDFB5fuJeP7ard4XRARXbdp1kQlErbGU85
 0GacqbbGTj20glvUtUw==
X-Proofpoint-GUID: Qt0kFAYsHG93JbPBWDMRXnRvE3-QEU6X
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11974
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 adultscore=0 priorityscore=1501 phishscore=0
 bulkscore=10 lowpriorityscore=10 impostorscore=10 suspectscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611230024
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 69FDF180005
X-Rspam-User:
X-Stat-Signature: w887ymmnn6qyxghmsuauomuzuwyuxspw
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795414272-23145
X-HE-Meta: U2FsdGVkX1+gEateRC9D7lNZlwIhtyo1VloSotU9q1ytw7uQbeJilqMIGFJWhQcEWLHuYeh8RLomUtxbleWjLdljnJuJgN1p9+lfRvOAKAfk79eFJniZBXfPRLty4FtRd9OGB/WPFnXt0697XkHfguzQANY1M2G5TzDp6CcoivRcDlhhV0BKJQIyK4gPYru6a2fyCuZ+rrnTC2XM0kk5CcVbbTLNG7CJRcSyMYTsNSc/bQmfO8VAxlh4Zyyj2h0KiIph5x8hhAOESxirwpvVSWtBNHfA6yJZgc1R6YPGibvXDP/V4G1/MV6FYxxH7uHq84TshUlGHV44pU4qdiqQsHL4jGGX5fuOHuAqsN6BD2S0WirLsLNtimdmQabY2go7ILECGxSuM5qg3vu1bNy/FTMkFLd5INlDch/TyYsiy80sZd3h+TgErD7RwsQsFe16MK+/9eKuyq8aldMhtgMbD2eHvE9K9JmVQfNxi1TRwWY159E/lUaI2gWJMjUEgqfpeidj+3gh/69tYJpDiJMw+M7XQBJhQ6tF2it1NQVyAe0kIjHyB+vXnZ0mwAwL0eLl1cdFh6SeOniPmdzqRU6t3QEaNN+hQM3ocBMPXSD5mz9mpZOlD1pvbpGv3haGfE6la52X4okce0GaGFxrDboWLngSyWhY8AdFYEoJktJA3gxPZiB/6V/mgNLDleRNmD3HhEBol82VEvbbymI2FImndvXJFFhFjaAmYJJb7puw26WcBPvAdrxsDfR4zMVvjTQDFlCaFZXwChSXGdqZvK9xATSBp+pM6UO7kQxEFtIUCi97Q3e8eVlSUWeJTlNUNLR2muC/K0pVaRih6F6WlADOy4n3dKf2PY7O02Z+FCym2kdyuAai/vhlO3lhDPRLDgv2UkzupTeaWAK8+FOI0vTjgczsfl7KhJPbXwUdRGoJouA801fUmhZkx4tn/QYr+fbgK4tvld6TU7GYsPoJ0t9
 3k8cAWoc
 4NSCRSWdSUSoGpufgVM4tbiABoWp3kLowgmEatvbPD3Mb5Ke5p8uWVp33PbuUN1q6wpd3y+JlIul2Y5P2sSVNdQYXCNLx3jt7MGeTqAM3RpYMrABiwWrIH1roWkRIQ9VAnIth75253kl9uv5JVtQzb5MVltibCI+2Z7xOTr77lXWtwNJF2V8ulK1NRACjvLmzbcTnNrPRWZbYoNWtoKTZubh3M3WcNSbeumZS5QsM//c7NPaD1bmWmfSP3D4sMkrJSNkQ6JrGcJ8+zm5taSeBZa/V+U+1alIeoP86jTQMb/7qSGBNUnmJz5IM5PN/WWNl4sN9TAK8K1g6tNSbSIyJGSK2yczYNBdVwzVdIIYX5BJKCBCJzm7Y5G6+CdHzsKbZFCrpfJ8PDmnxPIP6Aj6gdGGnrnIfQLIh0Owm6Xlm84nJReZk9lpU0Dksx38EiFv0cWi0pHaaKHnSpFRlIqHer2ZJEUB4N0WWByuB5WJmQz+Ckt1tx2Pv6GYdqzi4ZzllKta4Qg9AXSwVAzv/x6obj6RNAx8S2PFXvYhwOh61U4NJ6zOjBWKbmWHiHxuD5sfNbZ87Dwnf1SZT5p2e2kFp/m5o6q/M0VhLoT0pDwn2Trmnai5lKN2IBbrLdGt+fbcM/V5pcA+t2V0vaglWSzt2IfIozqU/LbMWOiQFJXPDTJx7MbBqxsggkGROxwXvLRJfra0UPB5yGGM+lWZlD/e76nXt5c8bZviCopxapS3EG3uszYXxSkPeS0KoMcdIQlEMAbhG8q7G22qRH3GbkmY137Gh5uuDmUo9huLx5Az6coKyy9JDzYoCPzuBdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/15/26 2:38 PM, Andrew Morton wrote:
> 
> But why this change?

To silence the report since it's harmless.

Mani


