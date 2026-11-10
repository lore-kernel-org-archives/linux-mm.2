Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81C84606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 00:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=jOCviDoU;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=C2Opkp9E
Received: by kanga.kvack.org (Postfix)
	id 8E1096B05B3; Mon,  9 Nov 2026 19:27:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86BB16B05B4; Mon,  9 Nov 2026 19:27:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70C2B6B05B5; Mon,  9 Nov 2026 19:27:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5EA6B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 19:27:37 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C2121C426C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:27:36 +0000 (UTC)
X-FDA: 85417320912.28.129351D
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id A57EE40006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:27:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=jOCviDoU;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=C2Opkp9E;
	spf=pass (imf17.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794270454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0bTkl0ZeS10Rc1qvdgpvqwy+jnWQCRdinOmlNk+hTA=;
	b=KMGKXjFIpm8lAVRtn3mSbMajdqBsxVApkhTavZAI1mQm2e7zOQrSVk+VawA58IB5bDt+AU
	7PEMBggRDdy3hHHdqQ7TKoTW8pZFu+BfIz9VF1mebRX8DfFyhGiHzY7vabb8n5Zu5yaoGn
	guy1aSHzOzyFY4gnfeLgw2dX2Tj+E+w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=jOCviDoU;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=C2Opkp9E;
	spf=pass (imf17.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794270454;
	b=Esz0/3aF4Z3WOaKx9dE+GABpEKd/I94nvxFwA3UdSQPDj7BA2n/YVLqoQDx5/J87rYfZPP
	+BmbhHuUPJ1IpedHvoeAB6jGpBq7bwdB+QMA3JbyK73aiMMaA1DoSZWEKlzjxgbW9gdREw
	zgB+5BN248SDZA4xAJvboyD/Z+025kc=
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A9NZ9wE3830559
	for <linux-mm@kvack.org>; Mon, 9 Nov 2026 19:27:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=R0bT
	kl0ZeS10Rc1qvdgpvqwy+jnWQCRdinOmlNk+hTA=; b=jOCviDoUV/d+SBS9+iko
	Dp+sdqHEyd8SiXDTjRw3mosnYhHzzqA94GjHpHpXbj2rXDHIWgTioMoMgs1G0vx4
	yYqCJ3+A5N6xVan0OOtxwO8f1H+vX/+MkPsPQJulZtzLXUWsW0C2Iie93T14f1Fx
	UTOxKmkFqDk68PQ6FgUd17ny5o83+WVj4trMpGfmWZwucNvgIbUr9sVuy0NEBT98
	CqbC/arbYfWLUWP3CaPG9vKS4HgBNz6ZZpWbS8gl+xVoa5F9YitxG9nKwg7xRjBF
	Uf6eDeUFBvgVzo7KYOjH7cW8NXmfp+RdKdjwggD8VbBFbCRBMlF4F3VV9d3EfhIR
	ww==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hupvugrw2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 09 Nov 2026 19:27:32 -0500 (EST)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-53664911d46so29816721cf.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 16:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794270451; x=1794875251; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R0bTkl0ZeS10Rc1qvdgpvqwy+jnWQCRdinOmlNk+hTA=;
        b=C2Opkp9EjF8xF8Ab5sd7SQdvEVwaRhQKrtt9P8CL1CIsLgkpRU3grZVIYMxCpBbLd4
         TmqoW4eEBCufCaRnYGTTf08uBD924+iYkaPgJli1uDRG51weD0h/YdJo7jn+szgZCC+a
         WfUfklxM+RwZjBMLxbAh+izYLAMv6U4Q2oWHBRhbrP265Bds1CV4eFizSg9nKGaLcjwH
         hT3xLX33xsxiTLBfwEBCZt3c3D/53nqt4tfQWDxLgnWzMeXfVapNyQEGOXK4DS795ffH
         fZ55E1g/QqETJHuojunvJDpVCaItHY09VkM3MOdZ3ms8aj2pgyJyl1VWt95SkQwnZfO1
         cSnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794270451; x=1794875251;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R0bTkl0ZeS10Rc1qvdgpvqwy+jnWQCRdinOmlNk+hTA=;
        b=XAbs8Z0dCDu6hVU4qflHbSQ2aX7U8FPMauZNs1A/i24UFbzoObwsqqPSSnCNrri/W6
         jNlDB81s9bnQp5A8w3AUNoLoNggW2ufa4P+LwVe8RMbZeCYNeFicbXaIHMjigcnIKP7i
         6I9FhpwK22p3lCkZ8YwIYel08sQEVcxu1pifja5z8Ft4g1ETc+mmxlhoNi5GjK0Zrv/8
         FoDnBnblL7NIJN5i96arJrkcoWpHF0gEOMRjCJpwLf8hFqger32HKhYNdNVdWai+wTSV
         QPe7y7+mS9jHXmpM1e5JCTHqG4TAchRkVxcYk40+03pwXG3F6DivdLFOWSRt4LavJhPm
         t9Iw==
X-Forwarded-Encrypted: i=1; AL+hErEapsxUdqup8P/eA14NFrDG0+X+BVeuz9CvuFmbef4+tr9n18jUNulbmzazzFFwazYQgP6ZDifrlQ==@kvack.org
X-Gm-Message-State: APuU4Z94/Sor0Rkwu/jX7r5qmzh7zWWa84tJCrXrgdn5OPeEWv2rXw2K
	rQ1j0RDqHcoOmaIDnnDQJMXxHUTCaxufEoVRvzJWjB89ggBJFf2cbLs3rv35YL//hPUZIYM+SjU
	zXlQUne8JXkhzJE32vyyf44txJKguAg8/5vb7BMVvLocauqLW
X-Gm-Gg: AYBFou0XU1nQ0gMWHrI9Wso3RhimiQENTzeM2YBbvlmddMUsYfOn5HuNnqaLZEcQpOn
	8uE0yUdUxNQF+9CeBnkHNvF0SOhkW0SAr9vGMC7sGZZK1vdXuYJp+OV/3eZb+xZO0e1zD6ZNjNp
	CPRSxinQ+1Egdm77m1mBBFYfDcfhkKitH2YgsGBDfEHsRxQSF11wYoQ5VQ6tt62b3w7t8Gsz8/Q
	IDpF6R3XUHBWun3Onopqp8EffK0qWWFeEdKnbtJ3/9IBEvmgVXDcMIuGbeGM/6Vot28O5I724bU
	MRjC8tZlHXVkyhVj6U7GVb+dNDKqi37siA+tl2YOrVqjZ0rJnKwxjybdBMOtyXpmMZh2r78MBgC
	LthqjgOOe0WtMyB0r6VgAmKAKhYn23NIXyUjqGlVRG44/0dsNtVk+BUoiPgpULOWES0PPd7DvVw
	nDKsymIqPxnY2fDhkdUD2S2hNh8CrJlPtRtsiN1xwsflPMVJ8iPb+WNTod28ypHSKAcvTtlITse
	G5kccAlZMGVUmPv4QPOPxZawReMg7M36HJYHtU+iElbUW0OCpZJzDuggtMQdEAKgz2Va4y1lQOl
	q205UKxxwwZVPeaDu9AH8w==
X-Received: by 2002:a05:622a:2a10:b0:536:e29:e774 with SMTP id d75a77b69052e-555293bb0e6mr16117001cf.77.1794270451580;
        Mon, 09 Nov 2026 16:27:31 -0800 (PST)
X-Received: by 2002:a05:622a:2a10:b0:536:e29:e774 with SMTP id d75a77b69052e-555293bb0e6mr16116841cf.77.1794270451295;
        Mon, 09 Nov 2026 16:27:31 -0800 (PST)
Received: from [192.168.0.76] (dyn-160-39-51-212.dyn.columbia.edu. [160.39.51.212])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-555091eb801sm10414481cf.2.2026.11.09.16.27.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 16:27:30 -0800 (PST)
Message-ID: <0bf0a413-7f7e-4701-8907-cc44dba4509f@columbia.edu>
Date: Mon, 9 Nov 2026 19:27:30 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory_hotplug: don't offline a hwpoisoned page still
 in the page cache
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Vlastimil Babka <vbabka@kernel.org>, Gregory Price <gourry@gourry.net>,
        linux-mm@kvack.org, linux-cxl@vger.kernel.org,
        linux-kernel@vger.kernel.org, tz2294@columbia.edu,
        stable@vger.kernel.org
References: <20261101-memhp-hwpoison-pagecache-v1-1-ed8785ca44eb@columbia.edu>
 <1b6a6d13-8a01-414b-9bbe-cd194af1f539@kernel.org>
 <a002901b-715a-4adc-bdcb-7a6fcda67711@columbia.edu>
 <a2ec6814-d3d3-425a-b379-f99b219aa55e@kernel.org>
Content-Language: en-US
From: Mani Tofigh <mt4022@columbia.edu>
In-Reply-To: <a2ec6814-d3d3-425a-b379-f99b219aa55e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEwMDAwMSBTYWx0ZWRfX/9CAQx+1eBTh
 7wX1XLphA6CMnU75A9lshHJ+25zqcI7pOrP3RP80Z6kTdo3EXw0A3iLBPrQOmG8wUzyTcB2QHo8
 r44Sp/8NA/eRziLsF3TFfQLhiv4CvyB8WDDCmFlC5Na8vIpUT8SdnngD6Ww9YBpbta8rU3IAD6j
 rdxjPRsg143hy+ep8ldZZZgh/D17oVr+tEMb7/BA+E+Akqlv6RKfcBsni5eILxJpvCHmMQcYD7a
 5taRWd2IBE4cw9HF3cGlcq+GxZ5ZfKBqIXPOKe7SmBwWEVtSSPO43JF3h0+EOO9hGLByfo4UMUE
 LZFveT4m4mZjDwah6KMXpqQkxu5G1RF33Fzp8B94TuvYis159bTn7xNQz1/IIkzUSWdHvTKH3R1
 OKkr6rFhvW1UbL3yW5G+KibMF5Um+gWAkRoYKnlySywthgk/obWL0hIcqIfg4ybBXsScjddJi0e
 w3JrOXrpfd5YRg3ZZhQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEwMDAwMSBTYWx0ZWRfX/OoBWnA/GgmO
 I9vK53c2gyPma9fR10OXIUI56tlb0SOIoW751hDuBb+VFfX5AGS0xTeZKSWWHKeLxXeb1bhqOqU
 zyvs29TGFkWX/jenHJvAXrL/cFvbzfOUG7NBzeNWOhuBJnYXMlIE
X-Proofpoint-ORIG-GUID: 1j9kVJpnCdoHFWOdFRHLg7JD11XYAiQ3
X-Authority-Analysis: v=2.4 cv=fcA4WEQF c=1 sm=1 tr=0 ts=6af264f4 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=l9izRfKDRJJ6Wn/vzKnQSA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=C_JoN6WlG-creS2BCkQA:9 a=QEXdDO2ut3YA:10 a=QYH75iMubAgA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: 1j9kVJpnCdoHFWOdFRHLg7JD11XYAiQ3
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11961
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 suspectscore=0 impostorscore=10 adultscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 bulkscore=10
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611100001
X-Stat-Signature: f541f5argcdz3ctu6w3ruw4rwkdts3zy
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A57EE40006
X-HE-Tag: 1794270453-986480
X-HE-Meta: U2FsdGVkX18Xnutitkx8ZHCPL1J5C4a5O35Ej4IPi9qndZihnzgCT0u3GGIVikZsMx7PWtz4OADZ6t6t/3tY0eyzs1hx4Dn3FG7kEM1mXUvwzjmlSX9zpbjRVTI4hvdjkzI+vk5oUrsuDjEyfln4pEsRHAHfVJpmhvjDgLu9PKj07SG/D4S1OeSsbqvd4ELP8Bba6lJau5zVjNdSwL5zSh4IqZAgufs9wEnzeAc7QZmtWos8jKjbOJbNLiNeL7CPQpqICDioTShT+19B/ATd/q4x14cPeUFPaw5PdxCHGBwKY83YuFpg2vblEqKhp6MeIQW7tPfd0fEj211WGBY2A6N7de/zfNn59x/RtULz1nbJKaAuoyiFqovlUART+YA12sEYgl/wAGi1ZaWWznlEvH+hADo9WvlD/hwDm3hThljF2hWwHYAymlpUtAKPriKU+8li+oM+7Gzrn/YJ9maB7bwJipA0C5wsACBJvP+1DiUshTehcWnMnD165nV5IOw660cHEv6kRcg6ylRdY0dUvfzPmnAzcajTRPGzqX/mMfZOPYwfYcNk9Ah5nS6pFdMVNmPUNOwrVdIqnKDYAWCvQv9hSenq4JdnXNtI25Q8wD3PcJTFnT+Zxn4yAqPn+aCL1w/oT2hPROXlfcl6cDljRuVPu6twz14QUuqyDNvm0a1JPjHBQNoUevhuqfAaiII599b0Ksafi6xpylhP5YF9/7SIGrXPjBGiTodpYrB+PDNEis4jgJphda2yGG5fL4HVdQWF14i4gd3Gu4skXcYyUvRjTKdpNJNv3jWKbvTnlFq9S0/SQV3Mn9uis/0r+T6Md2ygkOVubj8z6n0uIBb7pKnM5cbrndl63MVlr3/66ar6aICfoxITim7ZvPhSY2iT8JGORfD1ulXtgIjUM4NPLUWqeGndv9Q1CaUvDzddqwTPF+oyzqGVdcgq7WZZPNY0F7ZdxOguQNGH9vN0x9A
 KkT7HylJ
 FngheoZpbNquSERyTaYK+qj6rTEMoYMvCXzvy1gVSJANxVzsWkXUIZ/bON0Pez2RUYk6KMTyVjkAShxFK5tTEXZ8CcBUXY5yl0xyMslvXA1QW9xywmbKl66AJLEZSvVff1eCw5o4hHdY3O+/jjD7QJfp+XamfP2JcpVYML4HkmlGWrK5fFFiwjaydirfJQoWoXHaBh2wFFVv/HAEEcYAo9n29/Hdv7wfWny1wpixMzQrW+Fd0h6M5HmhdTODRwW5DG+iu+GO02Uqh5ni+5+W9sDV0gGKO8RY8VOr2qRhHauq3KtMQt11f2YIRzFWcz4HAtT0RUsfx9USuymR3dfzOMqHdQBBUlz2MtSNiUDYf24PgWCGIK+cm5FcU8SgmW488A7z+Rhu1Zc36V2ehkxJmW9m1T6ADnpRsEomtVI9scClzIG39+ajKL0kdllWqTXIqXhxO5CYC07qGN0739+hAObAR8zxNscNbFqDlWIDvH+qTVawbbIn25m1ExL09i+XYuYSoYFNjtMxgSqW2FyzkDd3iYN1BivMnOkBFqyqkt/ITtCiCP5qFf2Wi2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/7/26 2:41 PM, David Hildenbrand (Arm) wrote:
> 
> So the right fix is to fix that then.
> 
> We'd need to sync memory_failure() with memory offlining, correct?
> 


Yes, I'll rework it that way.
Also sorry for the early v2 :)


Mani

