Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A278B606A321
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 12:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=NME0/zL3;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=QfluBSFW
Received: by kanga.kvack.org (Postfix)
	id C3D496B05B0; Fri, 27 Nov 2026 07:10:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEE056B05B1; Fri, 27 Nov 2026 07:10:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB5136B05B2; Fri, 27 Nov 2026 07:10:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3BB6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:10:43 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA7E7802CF
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:10:42 +0000 (UTC)
X-FDA: 85480782324.12.C67F141
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 06115140004
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:10:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="NME0/zL3";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=QfluBSFW;
	spf=pass (imf26.hostedemail.com: domain of sathvika.vasireddy@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=sathvika.vasireddy@oss.qualcomm.com;
	dmarc=pass (policy=none) header.from=oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795781440;
	b=ZCpB43HhWk4SrFDqGVjC/ztpTybV/ugVP+pgUfxIrZC0QohA1OmRqWYPnG5AUB1raW6HyI
	OGFZp22sQ2f3q/fNXbE4HsM5IOFWRN140JTiIINg1NZ0buitgGzeok+xIfBf7MiABODRFU
	SuCSdGWg9HmLA4CYdwFlDD+vR15FOdc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795781440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Edlnli8/pVvjmsK/V5fSAop1oIXHSuOLdm8aMgYJNLU=;
	b=OLnoUFkRmqy/yL9tIhJvHRAJ3d/KD/1ByQmfg/3rBzEEXzooeovpJPu/Wdtj6KR5Xk8Qb+
	WhS2AX78TLhEQyKBpWUL/G9aZ/8lF3HE3PnWa4/FG6wmFLC3sPxIIWqpJY71QkplL17dvK
	IzvC6VlLbLPLLDVdmH/Z4uRxelylpB4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="NME0/zL3";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=QfluBSFW;
	spf=pass (imf26.hostedemail.com: domain of sathvika.vasireddy@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=sathvika.vasireddy@oss.qualcomm.com;
	dmarc=pass (policy=none) header.from=oss.qualcomm.com
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARApVsc1685548
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:10:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Edlnli8/pVvjmsK/V5fSAop1oIXHSuOLdm8aMgYJNLU=; b=NME0/zL3lOee5+hA
	/Mj60l7TselHqAE2SvbCoAJihq0N6SaOIl9sRs65slPfhPSyAyBKIY2Vlo4MkRbW
	+PfwaFn5WjxTgoE4kcKnUv8stNlGPARGhfcGAklz1ZgcG4JBOKs5192vM/lyDZal
	5ZDPAXlYhpRLeMf8J7V9mv8IQKjMV0/DDHCeQjK0pBOMtyjK5u7fSdOMFX8c6LxZ
	nd7wiCoICVjweMbV9tqb3HU4HRDm0SVyPp0bnXBgLZ1Ff9L3MouI8equqEWkHMpt
	32kbbOWVOhSihkxsYHOiEs4blKFK0xs0W0Aqy3wH3d6So3o7vGti7Q4x7P911Dmo
	CVUH8Q==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j756k95xu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:10:37 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cdeb1f93b63so133301a12.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795781437; x=1796386237; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Edlnli8/pVvjmsK/V5fSAop1oIXHSuOLdm8aMgYJNLU=;
        b=QfluBSFWVsqDB2wpXkF6S4GqDyRxMKN22euDb88kx+eWvufq5MfwYyLhRk6WBBeaKn
         MsOJ0MGDMe/vA4WJADXsv5Y2zJQ+IXmyDfMeGYA0334clbWH0sohE43z6m/QB19H4cC7
         YPIM6M6vLAiXBa/DppWvmK7Z14RB8SFAOsk1lpI47rJFlgny8uCX1FA8brK2/mN60p9M
         Zf/Y5w2esbT2ha9Wh5TSmCOHU4Axx4GuMFZR7KoyPRlIPMFPuOx6iWpoIt1YGLyEyozu
         pCub4Oc/vP+5PuxpAybuTc1mGYlkghheefzEk/9gSoVsSlDLLguaO9VP7oHOuiVkuiU3
         pGMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795781437; x=1796386237;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Edlnli8/pVvjmsK/V5fSAop1oIXHSuOLdm8aMgYJNLU=;
        b=r3VxzYzaghjPwqnYNbsQY4ygHUhVn/8gew28BRL8zOnaqmK4TajySuIXxE8of3nDZa
         CdGbiviLtRUI5tZ1V0cOFLLHBGsu+yebXUWtv9goaigG5hMKFZOhtbBPSbtkMZ1eJpa9
         paCkAmlUL68kY+PJhQkgoRxmDoKfpeDN5wrT12XsiG+Nv+6m/g8urWL9w23RRCFSWkLH
         LGKEbVRWiFXj+LBXoBLMZffNSgizZb9G91eqjQaYFlwGq0L6veUprxS5k3gBMRpd9xVi
         kKVqV/27lBQz9YaZTLbu+WaHJYlSXtaTHu8mbhVpAleZVYFyFJ6pL0NtjtDj7L+9wje2
         GcIQ==
X-Forwarded-Encrypted: i=1; AL+hErH+0bEvwK7leIY0Wpz1lWseihjk2UEHAQOHLm/LZVV2bFiun++BS6BNOyliDec65HjNeYw/y+FF+A==@kvack.org
X-Gm-Message-State: APuU4Z8l7upRggQ+aWXVp9j7CwTkQBr0PCEAm59Xh5owsMgFa4zhhL44
	R/AXi+pz5K73c9rKIqvUXPo//xGlecGRU1pWelQLUE2S7BU2qXZfiEI8TnHU3OuAG302De2hOMq
	Kq7R44sNTyIv652INafxrIrIkZ4ZOlbBezDV4Hsb5EE0qTRhiJnjrxQ==
X-Gm-Gg: AZFdTZfxMwsgzdF50EtAjHUF/2NEWFGqpymun7l8tRGTSaxNicbjbdNuMvTqJtmGbSA
	QVXAbK0T2K2d1pBGeX4b7sQbG5RP8n2VZUggjT3LHgZmKGcc4oykA3ha9p1JT9x/PjPtO6Dy+Qt
	/p7L7WTo0SicwuezgcuWjquBZ/gv7cLBXe9G5AjTbH/OEeDtSi/qLdMd18EqZQsO383UKj9bl+z
	rYUPfBi4+atxRraJMHZZvzfLmW8jUie2lDS3NDyBJwokPMXkEjQ5vg1CQHgbpFWMvGJ46FPh+Yv
	jQ0XDr5Aj6jm2oBhT/ldJzttSyJCO7Stl1qdz+tz/GebafKusLczmDWNRFTAYF9NhzH7507lRwE
	XHLk58LxcT82/lsDV+JTtNp9B7zQTpuNjwHcXOoUAYKUzOBPrv1rVBurPqF4qcyAVAYE+5fT87t
	I37ZlfZzMi2avaizdqGIkOWx3uDl9RCgnJKbPjjnY0yYei2DtEn7vWtphjfOK4i9ke7A7h9ggA4
	o8=
X-Received: by 2002:a17:902:e847:b0:2e9:6468:2005 with SMTP id d9443c01a7336-2f03f117acfmr387785195ad.2.1795781436647;
        Fri, 27 Nov 2026 04:10:36 -0800 (PST)
X-Received: by 2002:a17:902:e847:b0:2e9:6468:2005 with SMTP id d9443c01a7336-2f03f117acfmr387784315ad.2.1795781436128;
        Fri, 27 Nov 2026 04:10:36 -0800 (PST)
Received: from [10.149.104.122] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f120016sm119339635ad.58.2026.11.27.04.10.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 04:10:35 -0800 (PST)
Message-ID: <079e0de1-f07d-429d-bb50-c0f6b8600c70@oss.qualcomm.com>
Date: Fri, 27 Nov 2026 17:40:21 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v23 2/2] ras: mem: Add ACPI RAS2 memory driver
To: Borislav Petkov <bp@alien8.de>, Shiju Jose <shijujose2008@gmail.com>
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
        dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
        Yazen.Ghannam@amd.com, mchehab@kernel.org, ashok.raj@oss.qualcomm.com,
        jic23@kernel.org, linuxarm@huawei.com, rientjes@google.com,
        jiaqiyan@google.com, Jon.Grimm@amd.com, dave.hansen@linux.intel.com,
        naoya.horiguchi@nec.com, james.morse@arm.com, jthoughton@google.com,
        somasundaram.a@hpe.com, erdemaktas@google.com, pgonda@google.com,
        duenwen@google.com, gthelen@google.com, wschwartz@amperecomputing.com,
        wbs@os.amperecomputing.com, nifan.cxl@gmail.com, tanxiaofei@huawei.com,
        prime.zeng@hisilicon.com, roberto.sassu@huawei.com,
        kangkang.shen@futurewei.com, wanghuiqiang@huawei.com,
        sathvika.vasireddy@oss.qualcomm.com
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-3-shijujose2008@gmail.com>
 <20261017055852.GBatMOnEl66YObvU5k@fat_crate.local>
 <CAG4KcR+NOKHNzg6FN-oLLHgUxeitZHKXg9cN7dz24+Ap=RrwSA@mail.gmail.com>
 <20261110071729.GIavLFCfLKzPx8R0i0@fat_crate.local>
 <CAG4KcR+ikfQEBjCZiNJ1CUz=u3Gtbk_XDroA_GQqYpgO4Lo5Qw@mail.gmail.com>
 <20261121194030.GBawHzrrCNCMpfr7Gx@fat_crate.local>
 <CAG4KcRKhE1UXwrhscUdSpDJS8R0t7kWp8RXZm8j_9yXYJSQ2KQ@mail.gmail.com>
 <20261121210749.GCawIIJcidCeWs3ij9@fat_crate.local>
Content-Language: en-US
From: Sathvika Vasireddy <sathvika.vasireddy@oss.qualcomm.com>
In-Reply-To: <20261121210749.GCawIIJcidCeWs3ij9@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA0OCBTYWx0ZWRfX33oGTgHnRDgE
 saYqMJKfzi/s2xjpCzZdmzACrXFP67rvDapM/gCI0d7TaZD6NpYCmyvnL7qko5hxWZJjGdWYCXN
 iWRDPVj8FeKfPzUwGlUeyOPE1f82Iv/izRb31e+4YFsN1C851X23BEhUCt0k+8fusxypMGLvfte
 oUYDR5D5e+ytbRkrAWXK/MEkz+VV1nCrK3qSTlo8ueIs8iVRnzQuuVgn6pA0cOSA4y8xrszhMFk
 mbhO3ADOgh7qRRa/ww42vXMu+KVbMsDQidIFqZp84SwLIO5G8aWCU3JsGpPY/tCbow/9Sdppjik
 l0YHJKCT7Fa84emZ+om8UBZM9uIQm3yJEqrsNzZe8x4ctFIiLonfabRljoszhwrw2K36t6sp4LT
 otpUSRCnSVgB8N5pawa4HppUJK0Mic9PoAOXT+EyvDlIp0nbAwGp61tW5EwI7s1ZXXM2NYHhkvz
 wwPM+nGAVbFWhwj4xxA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA0OCBTYWx0ZWRfXz1+bPirx3t5n
 s17eHyOnSo+OgUH6OzLbuZDVQ29/yzXu00E9B1/hB1GhSO/Uyt01+FS9PIawnBc8irx1VQm3CNO
 tMF18FGuVCyHxBqC44rl0wH9+16TCx4=
X-Authority-Analysis: v=2.4 cv=ebWo7LEH c=1 sm=1 tr=0 ts=6b09733d cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=PZ-A5icK-3gcoNPXnSMA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: U9nPYXK2nRRZSIV5TxamZsCfxBQuMS_O
X-Proofpoint-ORIG-GUID: U9nPYXK2nRRZSIV5TxamZsCfxBQuMS_O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270048
X-Rspam-User:
X-Rspamd-Queue-Id: 06115140004
X-Stat-Signature: g477wxz1hom6tgkt17oiugym79s5bq8y
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795781439-487107
X-HE-Meta: U2FsdGVkX18PChjCD3XxGInp95WN9C0v4xYkX5kcIHxkrglKsOotPp2lVxRCDXkncEcOpoI5CnmMnthIpIbf5616QHGnbVjYppCnDP+VV6WhBYid9K+Eex+N9K2KHbNRGOnGMEitBurORnTRs9pVokzxiaTTHkeHosVH7t9GKPyMw70tMRFbDSb8FVwomf5RlbcdA5MXwCv4nE0IdAShE2Nc8ndh8HSQGhD/7y6Qr6Mm1Y/zLGWGArsxRUHxYCHK/JRzrBIfbFDCtGPcLWmAqHhYVY2jqtbRRHi+wTrfEeuwYSAZMzsb9prncUabEWf9CyawgLZTBsLNERypuvbqySpvLZI0fn5GvsvmBmemt7ELXBsTVxym/oi+7JCcD8c3eY0bKzUIXmmoFGLr10NaX6qevbWFD38VgVGtOk+nAk8NYAv1rSW+cjz4pu7n7ZL/N9zsxuDyAvC4S2eQDJtBHZGgp1eJDB8tPfWVG5bVvZhDpRZyX6Kv9n6a4YinBzGNjmZjeOrwLHGtz9a22N9z+bv9KLclVP0qf2HcGqt2n60xAAPEN6T7uLM+gCP63/bKqhnlJEumAQQHOrF9Y6DhikvfYP2CgAjGLn+hzLoLyktcQkxUzHNuVIPhUrB6r8zR+ktG+2psJA5/B/DWf93RCRN96A6KvVopgFqUU5JXJEghfL6qh6+aZ2Dob1B7mEiOFyydmAnbjc6Kp2UyOoCbnEDF7WbSAJ3pb2RK+2ITKrqMloJdxTY8k6LYDu51KAQsN9PNv1goICu3qNgNTCynI47k8yv0poJI/AOIt5ZZyQ+IKYvYrfI288dGw8fHuvDp7Dq7DqC/4OWYUkKE9167VCnIB3s5LDCBkt+2M9iMHAlc9+fpQcsPPuQVmm2nM4QRgdnGJvphK8UhkEA/tRpI9F5ZhTZ/55WeuKqWqTwwJAl7VJUkn+VLDtkq16hZdjLje+8pGaAGaHzxzavvI7l
 t9Z0/TgP
 Vr6Y/EVqkfUYI5EAcfDSSUWs7bfNwM9Zues/oXhX/S1NIFRV6ZqO5dF6dYKfSvUVZpRKIodHvj3jr9Nyf53zHzKtj2yRQ0tWJSQnJGRAtVRCv0R2RHIf7eSmrWb8LEE8CH4j0HR9RnrM0EBE7Ka1MgKtRLfkeXyNdxl3vWpxee51JYCq8qECKQDOtELiMmq9XX8hkNgjEEdL3y7PPazcQdKKBO1CUg+tfm5kkzJOfGhNJoi7m9AUe+6xGPiSbgMj54F9tKSQLOFkDAbwAvEIWxsNcgTN6VrX60ZczZApPusdc9Ag+49m1e74X7cdbW68PQ2Hmbh2mRyqhlEFq3uQzNr9O+DNasHduhnwTU409xIfhLbZpBh83afKSJVBL9xzSgUYYWVeXaPrudrzBJG9q+7XSFopq8z/6M+Hl6mgvDHPWz8mM/I5ezjudyiwzWLsw8kGDVa/GDtiFLU9C0M3j3Enw81SMGxyjNWk4LhA5fScNevE6T2fiLl90WAFmu7j9D5YQlQL1yb+aDQMxw02CCMLyJYiXj/ie6W49jXrZqWtyYD7ADKFQAfHGuTGe0Zb+0aqGknHGB92+7n/gp17/K6WliYwLNu3Seflq/osTHV3ZPUEjJuS8Mdo8WQAYzgFR10KkrnNAVK6Yrq7HC3YB3Xw/ZRdmspz44f4zdG85+bXRLDkIl+yjRpP9+KBoct7Sy//yqJg4L4uY59pBuBJwgBYCs2QRqEXVxlNj6cG1heARX8jLZN4JV+inXwgKcvQPA6cDvZ9L0mFcNHYJXI3f7jSp2sfEhtI84eMELM0708UoO0Q10BPqNoMrjLZKB8sHxVk1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Boris, Shiju

On 22-11-2026 02:37, Borislav Petkov wrote:
> On Sat, Nov 21, 2026 at 07:53:54PM +0000, Shiju Jose wrote:
>> Please find the attached patch with the changes.
> 
> Thanks, you missed a spot. I fixed it up:
> 
> diff --git a/drivers/ras/ras2_mem.c b/drivers/ras/ras2_mem.c
> index 70f7f0b497ed..de5555d2e1b8 100644
> --- a/drivers/ras/ras2_mem.c
> +++ b/drivers/ras/ras2_mem.c
> @@ -117,10 +117,10 @@ static int ras2_get_demand_scrub_running(struct ras2_mem_ctx *ras2_ctx, bool *ru
>   		return 0;
>   	}
>   
> -	iowrite8(RAS2_SUPPORT_HW_PARTOL_SCRUB, &ps_sm->common.set_caps[0]);
> -	iowrite16(RAS2_GET_PATROL_PARAMETERS, &ps_sm->params.command);
> -	iowrite64(ras2_ctx->mem_base, &ps_sm->params.req_addr_range[0]);
> -	iowrite64(ras2_ctx->mem_size, &ps_sm->params.req_addr_range[1]);
> +	writeb(RAS2_SUPPORT_HW_PARTOL_SCRUB, &ps_sm->common.set_caps[0]);
> +	writew(RAS2_GET_PATROL_PARAMETERS, &ps_sm->params.command);
> +	writeq(ras2_ctx->mem_base, &ps_sm->params.req_addr_range[0]);
> +	writeq(ras2_ctx->mem_size, &ps_sm->params.req_addr_range[1]);
>   
>   	ret = ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
>   	if (ret) {
> 

I tested the updated RAS2 series with the readb/w/l/q and writeb/w/l/q 
changes. Below is the git log --oneline output for reference:

f2508c0f7672 ras: mem: Replace ioread8/16/32/64 with readb/w/l/q & 
iowrite8/16/32/64 with writeb/w/l/q
21c2b3102060 ras: mem: Add ACPI RAS2 memory driver
cefb17f4cc2b ACPI:RAS2: Add a driver for the ACPI RAS2 feature table
4dce97c6c265 Merge tag 'ext4_for_linus-7.4-rc5' of 
git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4


Since my tree is not based on linux.git v7.2-rc2, the diff suggested 
here did not apply cleanly. I manually applied the equivalent iowrite* 
to write* changes in drivers/ras/acpi_ras2.c:

└─$ git diff
diff --git a/drivers/ras/acpi_ras2.c b/drivers/ras/acpi_ras2.c
index 0849dd247cac..cb80fb193347 100644
--- a/drivers/ras/acpi_ras2.c
+++ b/drivers/ras/acpi_ras2.c
@@ -117,10 +117,10 @@ static int ras2_get_demand_scrub_running(struct 
ras2_mem_ctx *ras2_ctx, bool *ru
                 return 0;
         }

-       iowrite8(RAS2_SUPPORT_HW_PARTOL_SCRUB, &ps_sm->common.set_caps[0]);
-       iowrite16(RAS2_GET_PATROL_PARAMETERS, &ps_sm->params.command);
-       iowrite64(ras2_ctx->mem_base, &ps_sm->params.req_addr_range[0]);
-       iowrite64(ras2_ctx->mem_size, &ps_sm->params.req_addr_range[1]);
+       writeb(RAS2_SUPPORT_HW_PARTOL_SCRUB, &ps_sm->common.set_caps[0]);
+       writew(RAS2_GET_PATROL_PARAMETERS, &ps_sm->params.command);
+       writeq(ras2_ctx->mem_base, &ps_sm->params.req_addr_range[0]);
+       writeq(ras2_ctx->mem_size, &ps_sm->params.req_addr_range[1]);

         ret = ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
         if (ret) {


With the above commits and this additional change, RAS2 functionality 
works as expected. I also verified that the series builds successfully 
for x86_64.

For the series with the above change, feel free to add:
Tested-by: Sathvika Vasireddy <sathvika.vasireddy@oss.qualcomm.com>


