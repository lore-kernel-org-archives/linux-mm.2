Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803E8606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=FXwGhxDE;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=yqmpsHz2
Received: by kanga.kvack.org (Postfix)
	id 8EB306B05B2; Tue,  3 Nov 2026 14:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2416B05B3; Tue,  3 Nov 2026 14:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D8806B05B6; Tue,  3 Nov 2026 14:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9756B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:59:09 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D1119160473
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:59:08 +0000 (UTC)
X-FDA: 85394871576.15.E292F4B
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 09E2010000B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:59:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=FXwGhxDE;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=yqmpsHz2;
	spf=pass (imf05.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793735946;
	b=vN9fQblmgdvv8A7vKWPfVxaNe32wnQLckMjPmxNk2gXXLzQ8YytAZOMqZSFW2jgR58l7B5
	o7R7Tyw0wG5yyQnlkzSFCVajEiNG4cxviAMfKsbhuPaI4H7zhRNiUBsF9m1XPkE1H70fSv
	+XJlV26k35AqY7O8lZL2MBlPiQVV8pc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=FXwGhxDE;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=yqmpsHz2;
	spf=pass (imf05.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793735946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xpOJgsJz0sB9K9v/xEpka5H4yAVwg4X0Reyl3yXA6Do=;
	b=RkJv2cmxjQezpYK6ws0QI2rWU8DMkUcTfNsIk4FTgXPHwNmCgqci2sagH1oWQbXUUvOafT
	8g/mlDXFT82ot/VMwM9wuP4SkCFgXFlWInxOyJfNW/QfDT15zELNXp78vqDU4/0hv3UTxe
	U6R8HFxg773CLRd3/HcfFGazzNV8jdk=
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3I4cta560406
	for <linux-mm@kvack.org>; Tue, 3 Nov 2026 14:59:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=xpOJ
	gsJz0sB9K9v/xEpka5H4yAVwg4X0Reyl3yXA6Do=; b=FXwGhxDEyiYhfsw+MEKc
	iO0eBRAzcshzu7iioSTg0l4c/nSPG+/zQx8xhKoqHzoxaS/xYHaWqQyNCBePASkp
	cJlVaVT7G9ZeiWlELtAN6O245MoqLDujnT4Jcz8wscpAP9RqI783TDLEhRf4Jyj4
	gbOQPQmMARPk7y6ytdo9OoIhnD0kTrjSAYs/uio5hAxfXmehy/LbjJFA1teyeQSw
	88mjVAEfgt/vw905KGKiSzeLnQYg3s0X9LpfJiYDGaSBtqzY/iHCcFMePyi3VEmk
	azNZEYGsHqT8NXwYiuZEHSrMwnTAczP3IO5Z9MY5nqKvsVVUBYfMfDhurMMbpK2B
	gA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hqmjvgskc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 03 Nov 2026 14:59:04 -0500 (EST)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93f62934ef6so413585a.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 11:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793735944; x=1794340744; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xpOJgsJz0sB9K9v/xEpka5H4yAVwg4X0Reyl3yXA6Do=;
        b=yqmpsHz21FAof6mGwsRRoccG6ihdGAAgwhPaWTUYIUZMvvse9upnr30Ag7gBKcQ0ED
         TNvmTqaraGRoFlzXBFuXzsDM160VNKbl8xGgg+VEQpNJI7iSjI2RRlVO3YYRC6TfDEEM
         gmgtpLTrkuG/KBlQfhhrwxTCAkhfo09/CgxgXGc75jdWlDKVdpsvEj5guiSuDBUG/bDE
         v4oKKW2rYbadtWdkiyyu4TwfU6IreeMQ7P0sYWxmowDmrG9b+QAqpd19oKdegrZl3vV7
         LloRLxah7/WQKGdQGxaBNk9ezpfqkMVNXT1zkczv5EMhjfZVoKxnnXA89GUJCA3gmTm5
         mraQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793735944; x=1794340744;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xpOJgsJz0sB9K9v/xEpka5H4yAVwg4X0Reyl3yXA6Do=;
        b=RejNFanMHmh2EzQMAZZyDktJIqHUM3Zf1Fo8YlRgAIsZDf8pFhePSppqp9jSZsk3tB
         uc9QAuEAY0ZhuuZYJhfYJGEEdq0qFGPxcmVYWVNC8wRsn/uGiEexp09GwdnFYfpdQnIx
         23AVQ5k7br2zS7D4E67qedbn0he0nMj3kiUcUAPSE0t6RJ8yaAiUgsGMRN1mILy349es
         OHLH0kJGx2lH/uJkeL0HkX9a20Fiejv8ti9fGje3VOIZ1xt4Mm2LP1h7gFdd08anOzk8
         PtZqylvkGV0n34MIA3rIwWSBWqbsGFdpHqTXx4k4SP1YdbFnwZ5t9ZFJAdpmeDcp0LZL
         VJKg==
X-Forwarded-Encrypted: i=1; AKwUvBxxz5f1nCZSPP2DnRHQtuvAdgB/eeoSsWs4s2kpfEMGAvnZh1i89K8XAPWaN9WwJjc9pJ1shiUu3A==@kvack.org
X-Gm-Message-State: APuU4Z+R4fvaBcUH6nkhrjE1ennOa4JbqEF2INUKnX8PpSfRi8bM98dr
	F4RM2hm2MPS3k7WoEUf6pKgFdgqc4MWv0wEPAagDR2wWlq0rhI2u2V2YN4DjbJ70F2BZ/EnDliJ
	o1ZouF/MmRXAUBHT59Q5IXAj5pziNw4+8EnpeRUmkKS5/EDiF
X-Gm-Gg: AYBFou1MPuwJ6r0QSYmbWFTmy/GYCNxU+S6XrkeXFawhTNxod0qo5xMj0eKzeMhHCr3
	fzvivTu+qggzKkWHSwMqgtEBDltVtMktjtVXAGW/JXx95UyLht0/LrbtXtEcdZMRVcI6LUYR3rh
	OQfw/hDTpzDLgo2WU0iQq0er2cLam7MfDcXi+Yax7TzhXi7fws5lFUhy62y9mmcHASAYi0EI45n
	ATIe1xowYnoOp3CMsrvK/T6bQJbsqMyYTTM5M8hffncPMEYZ4oxXi2vLt2QXkv6Bs5vk4iC8Tp6
	MqHGmXYEsy8w6H4nZ516WSTJb94RZK+aB9ibF72Nlmr3zkyty6exPGpRyzZ2ivL0a3iLbNUoC8w
	SirBl9j3EFXGiwOhiYgVADSNfVYN+h7qSXf4uPLDcmgiXbBg36jwF7MaKamUIl+n5jgoqthsQ7M
	mI98s4TxK+sZpdeWgv4Wpw70sW6FiglxooyivyMknjeD1+9VX1y659jzBupTGkDLAbhUqcib3yh
	FeLqkLbECg6CgNruy6k+ZKtmJLXHTrpz67Dr3OaCHZhxZOBf+FXJolHyuBW84A6
X-Received: by 2002:a05:620a:2909:b0:93f:61a6:b89 with SMTP id af79cd13be357-94421588cd4mr2307141485a.7.1793735943865;
        Tue, 03 Nov 2026 11:59:03 -0800 (PST)
X-Received: by 2002:a05:620a:2909:b0:93f:61a6:b89 with SMTP id af79cd13be357-94421588cd4mr2307138385a.7.1793735943552;
        Tue, 03 Nov 2026 11:59:03 -0800 (PST)
Received: from [10.206.225.113] ([129.236.228.41])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-945d4799adcsm15298185a.13.2026.11.03.11.59.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 11:59:03 -0800 (PST)
Message-ID: <a002901b-715a-4adc-bdcb-7a6fcda67711@columbia.edu>
Date: Tue, 3 Nov 2026 14:59:02 -0500
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
Content-Language: en-US
From: Mani Tofigh <mt4022@columbia.edu>
In-Reply-To: <1b6a6d13-8a01-414b-9bbe-cd194af1f539@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: h0-Eac9OKzCYTtqQGzZqvq3JHBNoLDgN
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDA3OSBTYWx0ZWRfX38FuEz2BEx3f
 zwfp3jJqCiB35f2WXNIa9Jq81nJ+qy0KROX/tKcAYnzwiZNEuNLDGkAdDDmAqKAWhdX0BvRwkoj
 01F7kz60IUhmPZXcXOdDqsfNHnELesOewQItJPROoVDYQy2UG/y6
X-Authority-Analysis: v=2.4 cv=D5XSufRj c=1 sm=1 tr=0 ts=6aea3d08 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=hEunIlkDQR9riCPXO4CBGQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=qOjK20r3ws_Z4Kvo5k4A:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDA3OSBTYWx0ZWRfX5eGkiopoXWbX
 1mvMS1+8ub0hI73pv1oBfd+AXxrmZbgNx1209ti6QPPwS0LH6Rw+jiUnSCwz2LDGXHauVm/wrWv
 03QGLXbbNy123UJTubbz/8K2kVGLTg2aYcnri+GPvKnlGmfL3uDgvzpltF3CrEGx6YsUy3EwWwP
 EHSlSM21JuSpYBuLmm/bO/2GCmc1Wa53KBP83125iP/IWgncxYwtNahaz7eq8ZC9HC8M347hKh3
 VLZxXMuPB2qaclju/02JKXTB4j+nmXEQhWrARNXpsaYcy/VnZbnr79+wGF4PFmSe4CZqpDilTzD
 ZXjpzUVWT7CtrWPsJdtAawpzxF6llrv91Go95MLSZtU5aWmItijBdF1gOESOXXOGXxOt5w/jMw1
 7dDoK0kjlpeGFrfboBnn/LmgYQRhbKbBOKWZqjik297yp+LNtnEZlX3CynSyXbeyqdrjmUnUn6d
 JS9ch/kU0aerf9pZZeQ==
X-Proofpoint-ORIG-GUID: h0-Eac9OKzCYTtqQGzZqvq3JHBNoLDgN
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11955
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 phishscore=0 clxscore=1015 impostorscore=10 adultscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 bulkscore=10 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611030079
X-Stat-Signature: aa19bm5kz7ci8qguiyac7fajertt465q
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 09E2010000B
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793735945-426336
X-HE-Meta: U2FsdGVkX186XzoRC823vVrwgSrJI9Wu5IEWxXaWG+dH9ALKf6igGG6pJDIDZK3YBRic1IoOPeJ92P70ry0muUR6ZFI1wokz8QkDr4/EqrS0QDg/1wUkLQlrz10s/so2fZbam8tlrZRr0/szwLP4HxZM2SdQr9oD5TZm8otpj2osmN5mkIUCa0rOc0ko6hVREiguKAmYR3saQh8ViNx0tEq5wdPAA+XsbD8EyYQMoHRBsusMDnWqoIhRBCka8zfxHFRJMQoAwgV54s1fktzIi0YiVBM52zpLewrAYi3KZ5hoJy92/ZhWfo64h5xxI4Q+mSq+Yb2MKkNbXk2c5bG+h/R1ix+LErVmDhyAwCUQtcGrmZ6xbBv6R1XJepYiB2u4KDYrlhZaRKCrXrbbn6PDpE6ZojqSoJJqiUJYfihl/glimYyUPBU95Vr9ApTeFMdmjo4JufWe9VxrARbVR1EVVLGccmfKvvFWfjNidIPHafUzxHjbkbh+Df+tnFcoxZCvvmqppUXlAfIZ50EVWyenA8mfcijFopEX8n1Wv/sS8Yai92I+tmSuo0EwdYawvyKbAqkVoWrLWap0JQxTsU8/njTJgBfgF4XAnEg/ttrb03amtX8H4ei4zMyz9YZUTcXibZgkhuIjc8nh59gcHCxS/rY1mc8LvYi4TAsNOaXwpsfBGMXiMhGMTnByp3MJLGBb+abmQPRCNFTQ0WHgpc+P+aXp7DY/VLZ/1Kc+NKCMmLGN7lCrueFC8HjvzIcmJ8RddrMwQjQ8NWmlPp8OyHUdgTRemHwdRtpwwGEJ6o71pY6clrIZ/mA/3vS4R+ttgml3Yer+71RJ/maZ4/N0L+0qi7qnR/xzs6cHi8cL0IZHwg0IcBAJB476udD9zQx2CMtJrm+4hkfow0isWusDRJkVwwM9HjtIoEcBLOHf05gf3Rfh2o3hUiS8/ueS4tQw0wx4nURTK95TF6dLST3RoII
 mZAMX5dB
 oDRkpgVfwuO1SXYRhd3haOvc1ir65WNlGpc0U4Qn5gF0+MiEOwL3J7mM698OSYl7FewoM6YepWiPRGidlJqhFyLdEaBaKIQDSK5pJor6rBbbX3T9T9fwwmBFLifX6OX9Wd7I1nz2R/KISnNu7MyPdLhvKUIaTWayBrHcibJtQOLlvMcuc/IXwGbl8+qstUfEVJfNuwp6vr5QhWMY8ciqQ8jsg/pZZUjKdYr84+QQUqlXRTpt3QfUkUw3mfW0xdcKzEk8n/614Tv21Zvdbxo81pkhjBb6Fu3PfdgBxfJyiDBCHQx2bmV/7yinO6sv/TI+b9vkBNKyqP+BKLGBLPpmZ4JKjl7b0g5z4Rl0ZOAswvbEy+5cTuOAw93Uyb9Zebb4p93tmQdmYWTz19jPdy/Unc66yg9tc+nNBis97UlmZDOHUrsG/yKjI+rSyAiuV8d8CugoInDaGj4UUBJD/C74c+a0YQARodvpXCw3NHAzRYVXf/CAW4H1/h1E+o9WAMsHFRq323GCUZHaac12pSYyNfesELUwClvCXO8fR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 1:56 AM, David Hildenbrand (Arm) wrote:
> 
> What if we still have the page pinned somehow? (vmscplice etc).
> 
> Wouldn't it be better to make sure that poisoning code holds exactly one
> reference (whoever set hwpoison) and check here that the refcount is 1 ?
> 
> Pagecache references would turn it > 1.


Yes right, a pin isn't covered (neither before nor with this patch).

I don't think refcount == 1 can replace the mapping check though. In the
race from the changelog memory_failure() has set PG_hwpoison but is 
still waiting in get_hwpoison_page(), so it doesn't hold its reference 
yet, and a clean page-cache folio then has just the one reference from 
the page cache. memory_failure() also doesn't take a reference on the 
kernel pages it ignores, and a poisoned page that gets freed later sits 
at 0.

So I'd keep the mapping check and add "refcount <= 1" on top as a
follow-up, since that also needs do_migrate_range() to drop the 
reference it takes when it takes a poisoned folio off the LRU. Does that 
sound good?

I'll send a v2 soon with a small do_migrate_range() change from the 
bot's review.

Mani

