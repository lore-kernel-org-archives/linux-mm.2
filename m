Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A923CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 13:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2ED88E0001; Thu, 25 Sep 2025 09:22:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDF4F8E0014; Thu, 25 Sep 2025 09:22:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C86958E0001; Thu, 25 Sep 2025 09:22:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B46018E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:22:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 660D057270
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:22:18 +0000 (UTC)
X-FDA: 83927836356.08.CBE809A
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf26.hostedemail.com (Postfix) with ESMTP id B1EAD140014
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:22:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qiGxjWcH;
	spf=pass (imf26.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758806535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ia1/4RPTVr5lEOH9EgydCuHgeKLgDIxOVSwAP9XSPBw=;
	b=4/j2TeO+QWcXC/OtID0W0DarVeOoVtOtVK3E73WCq39waCj4izU7ukLkLxqKP/0VGhImkC
	PGH254eFrBpJjzvu2FtvvohBEbuHcq4G0O7Mc2AgMTjN73OX/FLipnpsoEUpNXTXnqpvz8
	7daW7gU6w78EffWuQUd+tv9tMIhZd/g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758806535; a=rsa-sha256;
	cv=none;
	b=ztgvkNpET701Uf7EaBL0pEliBOX/jEFCWpQyPmmZTa95j0CS6L34d8xEzhmpQ7w8+/fBb6
	P6GvAfaiGm6yzenLex0PKPtzPflSuxerfszHBEr9p1fRg7HAtKoariWRbYFOegWsBSb31v
	e4ysiWZPTymXz8kjU+1zdzgciAh5aBw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qiGxjWcH;
	spf=pass (imf26.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58P4O0A1021262;
	Thu, 25 Sep 2025 13:22:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ia1/4R
	PTVr5lEOH9EgydCuHgeKLgDIxOVSwAP9XSPBw=; b=qiGxjWcHB9EMO3wjfXOoNk
	Mr9r8KQDe76QddxPs9VXdPfJQ9rO77jnLeVExDPYwKqOgYiMeUdPk5ZSsdGjxgyx
	czyJDBxVBi4o7pYSS59eJvJJ7O/lCuZ1N/IaYa6CVkJRvHRKrHl2NsXm/Po+b9wv
	WGT0SZTRVb1c1XMWbO4pzwKuTePt6SBVCVwlmGfqRrK+y2YK8oPwxd7UYWx49XME
	Ahd8sNKw0oBgdfKUH5uR7veU3WNaO7SE1knduUZPS/RyaYLRYOsxVlLkeV8UPyGl
	2pDnRhPuSt/7lkmyFfiQ9VwgKBS1r6iHywUlLpff4b4TgoGgCTDyMasppqKIECPg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499hpqnbyv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 13:22:07 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58PDFLwJ022612;
	Thu, 25 Sep 2025 13:22:06 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499hpqnbyr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 13:22:06 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58PCZZNN008826;
	Thu, 25 Sep 2025 13:22:05 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49a6yy66wt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 13:22:05 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58PDM4Nh7471794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 13:22:04 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 31DAA58058;
	Thu, 25 Sep 2025 13:22:04 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ADC445805D;
	Thu, 25 Sep 2025 13:21:58 +0000 (GMT)
Received: from [9.39.30.226] (unknown [9.39.30.226])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 25 Sep 2025 13:21:58 +0000 (GMT)
Message-ID: <5fa436bd-2cea-4958-8a0a-ac636595a974@linux.ibm.com>
Date: Thu, 25 Sep 2025 18:51:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] drivers/base/node: merge register_one_node() and
 register_node() to a single function.
To: Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org,
        Christophe Leroy
 <christophe.leroy@csgroup.eu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Danilo Krummrich <dakr@kernel.org>, Dave Jiang <dave.jiang@intel.com>
References: <cover.1758736423.git.donettom@linux.ibm.com>
 <40257b5228dec05e5b252f02438608eb8d681a2d.1758736423.git.donettom@linux.ibm.com>
 <0de65980-4333-434a-ae7d-2b7be46c2cca@redhat.com>
 <aNUMnK23qKTjgEdO@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <aNUMnK23qKTjgEdO@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=FrEF/3rq c=1 sm=1 tr=0 ts=68d541ff cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=4V8e3p56BTpXgw00i4MA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: JxDWaNRkxF6Qy8ZF0itz_n9KFqDcMh5m
X-Proofpoint-GUID: eFhaTNISHQyCqaBy1Lml0RWiZV5isRK0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE5MDIyNCBTYWx0ZWRfX8HWeJU6DODxO
 mVDGFoZYhbxVlQ42sMVXhcMo1em/K1n/asrIZtm22eEauoGI2b+tljf5OPYm7mCo89NR0AiNVeA
 b5jCUQnfGSxBxmx3Ze5g9gKB5ZVRCq925XpPOgVE990hkJ1OGkeiUgBwSEw3MCJvsD4sJP/CgE7
 KmipbmGqy8j0TU3bqN5yDenmgBOqwd2838nYCAV989pTuQHkTCOhtJ5iRFnVDJQck6vCeyoo04G
 zluW2Ml2x6ZMSM+Su5PLZUsDK/tAU7bKf7VgB8uL13+TtySUavFIT7dfCcDAUsa/k+eZGEGZJmw
 KmcTgbAn7PVX6TY6pcwjxM+JNqY/FsdvpIgoDh4vyqsniAcKnvzrrVbleLD+hixPXdjqFolNu8R
 iSpNXE6i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-25_01,2025-09-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 clxscore=1015 impostorscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509190224
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B1EAD140014
X-Stat-Signature: 4pbwkuozzgdeiutscegjxs44yn35mhcb
X-Rspam-User: 
X-HE-Tag: 1758806535-358920
X-HE-Meta: U2FsdGVkX1+s2lqw6p8OW8+c6Ral2VbrXhaC5nA6KINzY79RiafJtqPBMG1+NI6uc2rUy2uU8+GjIn3Hf5k2SGwRVdjCJltsGULOeAJpKaOErQXzkaJrojVBu3TiLy9D8gKGQuzkj2MONX91aBbPPBFeisu4GH+acutNBMvs4dEkI39nQrLoT3LvJllsz93zEai1qk/6J/klgF3KyAFat3mVhQ2Ka0m/J7V2tov0pmvXTp5lrRs1UZZ98mMpCjKIqxOGgguQQZAT3dWc3eAUPxXTIFbzAUNWRPh03tV6+qsVfFkcdzQchGCy1kyceNd3eO0lFB8jgpb+mzaK5McUDTR/DiprH+2h61muJ6d/Z7peXQ78l3eDLn7768313lSWGCkeQz6/ujgUnUAm52gkl544vFmCcW+excJ0V+9UUezkaz4Ij4F9pyD8ikYYOFjgwoDRsS9XMqc8TGwExAB3Gh8MCSlAMSVckUPenMB9jQliPrH6tao5TO6erH0OTFzuSGxKkUWh0lKux51gStM2DV6/XplU7tAhtqjmhCPKaJDnGJ9+7cZ73v7f/FB8nWosE2Ww53UEMTPjKreXiVKP+2xV5gpvg3ZEBgXldVEsVfBc1thzKpqo3snMsoxCoabxzKa1BRhiRgg3wnLdfNzQRqYtgC2Cl+Eh7PBgMsTIyqZM9FlZGV9rCb1Y20/28KZwhwL/sFTPIjiCcFAnApNe9Qiz+yDxg44CIhNyQ3Ou1HJsLqVcT1/TI+43fKt/BNA/H20n6MAdqNWhcBOoil6e4KHeHEbk8+r78A+ETgEw5ib8jzMitc4hayCGwHXHB7eXNiSpn+U8Xn+QFoc0G7+J7Ra17V7zmSWRqJwkFHBCt5QUovvv2OwK8dzcvvcCdniZBDMr3G9hAvTTz3oUEILyUZmbzMydmfBZCfHvxF7rMYydGV8t6zPKnM9hJPb0cT8IsXkxLzqhJhnNgH8+P7C
 TB4hA0Av
 wiUWvjTZ5vNOesupS3H7PV4a1oHYpjikHR0TWkiqOXGxN5imcqlOualGw/lTSfWR5oeJg79Q/zM8oaJsM0+5xKi6C6R3lB1KjIZroa+pQP3vmFmCW+0uybKiZ2nBg+bi4WvalMPas3uVd0R5tH9Y9Kdx8av9IMg0+PlTko3VS6EyaTFrnQZAC93GhyW2mkEaang21xmxionAeXXP4tgJLxTWpPSRotJkPMTJ1zV43dBsqAtu7uGgDR9zaUyI57AQaBMAtqK7/Nt4goS3nB0cDG9gk8kqpi4HhlTEYX/93MTqPlJ6xAx71NPdbRZ3Olb2hbkI9yOKL6+GyoyZN0VUSjcRygtjlxu3nBEizeS90RZn6wutz45bMyMBWDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/25/25 3:04 PM, Mike Rapoport wrote:
> On Thu, Sep 25, 2025 at 10:54:07AM +0200, David Hildenbrand wrote:
>> On 24.09.25 20:40, Donet Tom wrote:
>>> register_one_node() and register_node() are small functions.
>>> This patch merges them into a single function named register_node()
>>> to improve code readability.
>>>
>>> No functional changes are introduced.
>>>
>>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>>> ---
>> [...]
>>
>>>    /**
>>>     * unregister_node - unregister a node device
>>>     * @node: node going away
>>> @@ -869,7 +842,13 @@ void register_memory_blocks_under_node_hotplug(int nid, unsigned long start_pfn,
>>>    }
>>>    #endif /* CONFIG_MEMORY_HOTPLUG */
>>> -int register_one_node(int nid)
>>> +/*
>> We can directly convert this to proper kernel doc by using /**
>>
>>> + * register_node - Setup a sysfs device for a node.
>>> + * @nid - Node number to use when creating the device.
>>> + *
>>> + * Initialize and register the node device.
>> and briefly describing what the return value means
>>
>> "Returns 0 on success, ..."
> For kernel-doc it should be
>
> Return: 0 on success, ...
>

Sure I will change it.


>
>>> + */
>>> +int register_node(int nid)
>>>    {
>>>    	int error;
>>>    	int cpu;
>>> @@ -880,14 +859,23 @@ int register_one_node(int nid)
>>>    		return -ENOMEM;
>>>    	INIT_LIST_HEAD(&node->access_list);
>>> -	node_devices[nid] = node;
>>> -	error = register_node(node_devices[nid], nid);
>>> +	node->dev.id = nid;
>>> +	node->dev.bus = &node_subsys;
>>> +	node->dev.release = node_device_release;
>>> +	node->dev.groups = node_dev_groups;
>>> +
>>> +	error = device_register(&node->dev);
>>>    	if (error) {
>>> -		node_devices[nid] = NULL;
>> Wondering why we did have this temporary setting of the node_devices[] in
>> there. But I cannot immediately spot why it was required.
> register_cpu_under_node() references node_devices, so that assignment can
> be moved just before the loop that adds CPUs to node.


Sure.

Thank you


>   
>> -- 
>> Cheers
>>
>> David / dhildenb
>>

