Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADDCC606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=Qvu/LNvz;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=nZYXDgtl
Received: by kanga.kvack.org (Postfix)
	id 636906B00EF; Mon, 16 Nov 2026 18:14:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60DE36B05B0; Mon, 16 Nov 2026 18:14:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC9E6B05B1; Mon, 16 Nov 2026 18:14:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E3F06B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:14:54 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 64531120281
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:14:53 +0000 (UTC)
X-FDA: 85442539266.17.3B57FFD
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id C3BCC1C0005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:14:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="Qvu/LNvz";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=nZYXDgtl;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794870891;
	b=EctRQMPcvAf1v0DOZY8N6/UjzvxmvpP3FCoknNS/d1WcHQKtkAqbAPnpGHXk8n6dmG0Nf3
	GeKUiGsrPRzdMDb0yvK0SVPK/pOI5x6+QB1k0o166SsxcChH3ZGGfhKDZr+6OoNQzFM8Jh
	8OpdSpbcgtI2yCFTD71jI8t5bgbBfls=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="Qvu/LNvz";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=nZYXDgtl;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794870891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IBaXENMZ5iJzgPOhruOKYZkY/jWJHWgOsTH8WaEBqtw=;
	b=rZSA7tovh34GTjA0qYsqYwTmeAljX1Ibai2S7cu2CpEHl7S6Np1ECu847snSojG9FZNEGy
	bBT6PsrV51eacujC9IHI9BFJWwpYUMY2LCeON6lpkbaRNO+c+oey5royt4/MPal1QM+CNd
	ao7DeKxxk1oAbcOa1Q7tCMYr9yL16vY=
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGLYnIG1009095
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:14:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=IBaX
	ENMZ5iJzgPOhruOKYZkY/jWJHWgOsTH8WaEBqtw=; b=Qvu/LNvzQdlVIXStaq4d
	19eskLdatEfmi5pLGxcKnYo8l5kOsaQaX2JUwjTB0BZ8OpyfjV28Aue1w7kUDboz
	zI4ShmiWepAsmKYnQOrkRRYqoxkMwgLRQO/aZX2MJXGT3XkbowQcPPjYt9Dm6tUZ
	cbApTydUQZt6ExO1EPrsezc6g40V0InjycEB2XsxZP6V3LNBKQZ5zihIRsW1U0MM
	XKrAuVyIP/HnnuhfBpwPIZc5kWgDYbYCa/J0LjtKmbcJVHTdEMpwzFcNGF/yPVmB
	xD0K4Zs8sQEjDMSW91uOLpo5S7ih9FjJJECeBAlwp9zuK7JdKlyexuPqqCdkNOEX
	wQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j059quv25-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:14:48 -0500 (EST)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5364f562140so6958511cf.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794870888; x=1795475688; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IBaXENMZ5iJzgPOhruOKYZkY/jWJHWgOsTH8WaEBqtw=;
        b=nZYXDgtlqwgs9r1L7/tse/lv9W+VIYi7kDovn9sItZQHU8/rLyTwlOIhR9rxxuAJrM
         JVHQx6t+yezNnktDR6QwZDN/2WvbO+NYlVvU2DAZPqg0BOKrl+5v8Gsb0CNNT/BD82pk
         TH0H8x2CoB7NaAY/ctXG4jEHOqXcfy+ep6uqyklnRAl+fIOh3ld5EvYYkb0+hbDcGdEi
         zumMJGXI38V9VZqJMJq80Xy/dCZ94lzyhbUpUISnR1HrDfRZPXsFp6eF3y9tzqXFppw+
         GD25iPuKdZ0v7eBULSDKwJdEArkS/ib/duGv+kRcWPFvjhyMoC52e2aSFHAi6bbsvv67
         anvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794870888; x=1795475688;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IBaXENMZ5iJzgPOhruOKYZkY/jWJHWgOsTH8WaEBqtw=;
        b=021PpB4ZTsfTzqgbvu1YDrPBKrhkfmFA1nGEd9byygnumd6MeVI2BzE6Y1d6wUnstF
         eFIxOa/F6otkYzkpdw38CmTjKsHNlWyuoq7tT3D9nhg9eXNgJQ7jt+9ZCX352o/NEB2M
         sjsF8JdqBEv3PYc4PJQE6Gw74JhFlKnlewceIbuW6roeib123Q54DaO6u/lVf2p+d5qc
         upmkZG9WRJt2MY0KJCai95IWepJ4nVR5YHejH4Ay5bALPE9exv8gzC4T2wS0ZidjqP/e
         yJR8HHaDYIIYOtj9esXp9FhCE4hOQUcb+QkCyi35pvJU9QmMzbXrynjy1wF4vN8lEREd
         vUNg==
X-Gm-Message-State: APuU4Z/2QPc4dGdglzTv0+LuJY8ogE31ra+KYZizOuAbjZid5sGoVUfH
	NWSyPcU0R67yzM9h+MSR1/TkADEIZnbg8ygmGeuYesdCJW/isDkrzJlala1O8fMuwtOuUDOzDI4
	pPl+12GZIZli6LNoqWQ5eLDOxnrEuD0ulFvhY16jyniKaqGyC
X-Gm-Gg: AYBFou3FjpkgDvt4kzGjutWPE2NGblZowFfKl+M4aEyMkfldfJ6ha4MSgu0UIuaM8x/
	xspLa+fyPy5bpbNJ78iUVeZEenrTIxgFLT0UJ3U45TsbEVOTIhlUZPodiHWZwYxvLzs76MfFII6
	vcE0pBSoYZNQ6RZk498/+s7iX4piqqt22siT/8BldmIuJzIQlj5z2rQyadJzTJGM+XcD8mGvSCf
	IckCQTNzt5EB/21rlbxz8Errm3m3OE0KQTdRMNVaIaN92cbIAcnWxdxvN6ckZOBEmuQZTxhuStH
	03fxcs5AQNOayM9XMWjqONscidonqCyKpM8BZ4tZQUfKB3b2kBTGIzIkRWyvy1L3Ne+66cLRoJ4
	pwgDPfd7r5DxkL2zIzfK3jHGqr8T7zeBbBPm4aCuE6bnjB9633yTNQfF8l3Ef8f8msQu3XxmmIy
	IKb8h5oN9qOzd+d9kZhDrE2kjj
X-Received: by 2002:a05:622a:1aa8:b0:55c:216f:38b7 with SMTP id d75a77b69052e-55d494730b4mr16217911cf.35.1794870888197;
        Mon, 16 Nov 2026 15:14:48 -0800 (PST)
X-Received: by 2002:a05:622a:1aa8:b0:55c:216f:38b7 with SMTP id d75a77b69052e-55d494730b4mr16217361cf.35.1794870887543;
        Mon, 16 Nov 2026 15:14:47 -0800 (PST)
Received: from [10.207.2.125] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55ad043f2f7sm91128191cf.5.2026.11.16.15.14.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 15:14:47 -0800 (PST)
Message-ID: <6d884706-1e5d-45ba-ae02-60c8067c910e@columbia.edu>
Date: Mon, 16 Nov 2026 18:14:46 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 9/9] mm/userfaultfd: check hugetlb end alignment in
 UFFDIO_UNREGISTER pre-scan
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang
 <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
 <20261116-uffd-state-fixes-v2-9-4397a0196479@columbia.edu>
 <2837958f-5a9d-46ad-b6ff-5a922b09e81a@kernel.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <2837958f-5a9d-46ad-b6ff-5a922b09e81a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=L/qI0OT8 c=1 sm=1 tr=0 ts=6afb8e68 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=DH_EvkwUbuc_xQPnRhkA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: NMTsYw0IP4wJ-BLyup51_dpxnr-PFULX
X-Proofpoint-ORIG-GUID: NMTsYw0IP4wJ-BLyup51_dpxnr-PFULX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA5MiBTYWx0ZWRfXzj7g+PuWh59K
 2oapT4UU3GNwPCeQveWlriudZGBz6Ot50GIl8c4Vzvwb0ulueeVz5IfPmoXudJgxo6tTWjJU8yp
 9YyazYmt2wAQvFKHbjR+4O7A9No+/PD2NaiDFS+MiAaK6EAe9tXwOGENSezLnK4nhE3/UgTDNVn
 RbNP5kOifBlu//b71V/MZGMAVZoS9+3QDvxMQ52Ej87moLiWOpXHBDJQ9lQRJ2gXHAFVYXHhuVw
 mTpFGmSKW+VDBVVQYqAs3g+cFuTtL//dXusRlH289sUe2wQmINpISq+uABaQ3KGAiprprrNgCG0
 fChHXuITROoL1A9NA1hULF/ycaUScZCXasIu8OWmM3hZupyHNJFHL6CA8eK8397LhlZUG+AAtfG
 ZB9oKZ19MH2wIcB2W2zSusPwuY8PdyEMwNlvmhp+BZlfviUJM43sDcnoR2+8Uj6enplypdgZToi
 Z5A9KA39gTGCSb0JpTQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA5MiBTYWx0ZWRfXxPw8q1834DS8
 PURGmioTwgp2AO0l8JnA8dPAYZ5JWoe+22UJ8PTbo19IKpDNGuDJjPTHsP2bSg16rHZyzEX7ldL
 /X+Ts99CWo+IfUdtj/6MlTHpbmXQ4J2tcRPbXBHRP62/5HkwEpPX
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 lowpriorityscore=10 adultscore=0 priorityscore=1501
 malwarescore=0 bulkscore=10 suspectscore=0 phishscore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611160092
X-Rspam-User: 
X-Rspamd-Queue-Id: C3BCC1C0005
X-Stat-Signature: ztp64p9xb8xp3mqctfarb9tuffb49qyd
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794870890-370465
X-HE-Meta: U2FsdGVkX18FZSED++9T26kaAeSDnB+jTkzN04AyKWu/xNutrRDi/JpsxkvK9r+CQpAuUXP9oON5LkqhGlIXUv2PLLJwia3XnZ6YE7TfIyAuTwno1jC7ycCrlFLstq1m13Joe0S3JEX3BU9wSB5T9koruRTTHWkEvc6lnnekHbH0OyRA9gftyem2dDwl60MYLhMlEMnaM3RH6PKdXh1DTWGV5Da3MeLb+RPwP/rR3UuBKvnq34loY1sWZDA0h0SldEF8TSk7LwysbPWrtoj8uMmhvYMkW+VcvKZHwQTaY4+W16No39Gt0v0lzjfna9NVfITMdGIxKn4b3YDqOYbsT6/Ufue7sA851Xlndtmd83NScwaCpef2h6fbzR8Ng3dMM3Vpn3E1oUWdO38JMyLczAIl9TsLKWsXPntBmSBTNttQhLyd3myEAxC+2oV5Fq8g4SH9IOK4GQDYHvKkWneEDiTUy5NwwCWUOSPF5MylZR6lIpqCXlZLb6B+r3+xuBV01jzE1pR55GZ1+Lq7f9zZUNDV+saoxviX5TZfAU8JjhdFKBtjinUq5m1Ydga2a1xiX1RHoaQwwNmRlF/oijKAmRgOB0lFwYNBRm4W4TW+MRzGPOBb5YHb4HFF2PrIM5aLOA7cBsm1BCfMQ020LMp4bVDXBdNoeD9WA9IIuc0j0zlq2yEiLLheBhJhlf0+E7GQ3sBoMbYY9rYwQGEXXkEzK1OCI2da0t6vAJOzKaBFPgG0aHxdQ4MAZ1/OWBa/40yXlhJtkqS0fMzfG1SgkMYuD7wod/40G/AJ26pR1+9f9wZeH69DTIpDeYO3PgRvzUck2Xtm8ESzoB/5Q0fYWN1lP2Liv7/+5+ciaDG85rYqoCbs7b1LY97qJsokScdk9cMiOVFoBHr+bhbyBoVe+SGBaUFfxwRmhn7cnp6GcUx1Gtq4FErvN5nZa3VbLN9k2+uTEiW+sRLVlIP5YbV8hvO
 zNVdnaDp
 gwLU1sJ3TTSyozoQkOIX4xyInyIT7Y/ioaE1s89jNPSKhOat/XRTnSEuZ8gyoxu1N9dfFxmdw+bCG4dOAx6XhoLKgdkIewOSV5QFWl9QqLw4oyfLfwr/yKGrqO/JN9wvFSozrx7fPoO6mDd8kvZVxv7fsGB9gwQrwmhuraBS78X4azOvxCzE5qB7+JOtHK7HPNQ1d1U734l1N2d3BRAXi/vNSOkumpY/5Np7SgPw2Lu4n+s8eHo+f35SKfzSbKRtMWEhJJb01LkuvMxqy32rHpzAHCpmtLLRfrF6m3k829G7immv5pczFLpEb1uMiEA2AuZJHz3Dw/m5CVVA4aF9E+e7xRL3z15BbWwNrZun/8l1udsAUUQx1dRnzil63GbJ3cbC0V/MVO0+rdaauTWhP5qvRP/w5YF/Gj5Hcp+VeZZN+OlTuDii3WhgzJKwgJItKbmq0GqttVPdl2R0sAjKSZ5NZxpyFupb4qGoFxhL/bkWF7Yh6TKEjBQm4Si/j1Tf7xZqH3Ki7cftWOpbGl4NUg2Jebgs/VL0rspdo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 3:56 PM, David Hildenbrand (Arm) wrote:
> On 11/16/26 21:02, Tal Zussman wrote:
>> UFFDIO_REGISTER and UFFDIO_UNREGISTER both scan the VMAs of the range
>> before changing anything. For a hugetlb VMA, userfaultfd_register()
>> rejects a range whose start or end is not huge page aligned there.
>> However, userfaultfd_unregister() only checks the start.
>> 
>> An unaligned end only fails later, when vma_modify_flags_uffd() cannot
>> split the VMA there. At that point, userfaultfd_clear_vma() already
>> cleared the WP or RWP protection. The ioctl returns -EINVAL and the VMA
>> stays registered, but accesses to its pages are no longer reported. This
>> requires a caller passing a misaligned range.
>> 
>> To fix it, check the end of a registered VMA in the pre-scan as well.
>> The ioctl still returns -EINVAL, but no longer unregisters the VMAs
>> before the misaligned one first.
>> 
>> Fixes: cab350afcbc9 ("userfaultfd: hugetlbfs: allow registration of ranges containing huge pages")
>> Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> 
> Okay, I assume it's not a stable kernel, so we can fix this in a cleaner way.
> 

I wasn't sure about mixing fixes and cleanups, but absolutely.

>> ---
>>  mm/userfaultfd.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>> 
>> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
>> index bf42fabb5afd..d8abc24353e1 100644
>> --- a/mm/userfaultfd.c
>> +++ b/mm/userfaultfd.c
>> @@ -3960,6 +3960,8 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>>  	found = false;
>>  	cur = vma;
>>  	do {
>> +		const struct userfaultfd_ctx *vma_ctx = cur->vm_userfaultfd_ctx.ctx;
>> +
>>  		cond_resched();
>>  
>>  		VM_WARN_ON_ONCE(!!cur->vm_userfaultfd_ctx.ctx ^
>> @@ -3983,6 +3985,15 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>>  		if (!vma_can_userfault(cur, cur->vm_flags, wp_async))
>>  			goto out_unlock;
>>  
>> +		/* See the check in userfaultfd_register(). */
>> +		if (vma_ctx && vma_is_hugetlb(cur) &&
> 
> I'm not sure if we really need the vma_ctx. I'd just fail this consistently if
> someone passes hugetlb VMAs, independent of if they are registered or not.
> 
>> +		    end <= cur->vm_end && end > cur->vm_start) {
>> +			const unsigned long vma_hpagesize = vma_kernel_pagesize(cur);
> 
> vma_kernel_pagesize(), yuk. :)
> 
>> +
>> +			if (!IS_ALIGNED(end, vma_hpagesize))
>> +				goto out_unlock;
>> +		}
>> +
>>  		found = true;
>>  	} for_each_vma_range(vmi, cur, end);
>>  	VM_WARN_ON_ONCE(!found);
> 
> 
> Can we clean all this up into something simple like:
> 

Yep, this is much better. I'll mention that this changes the ABI to reject
all hugetlb VMAs in the commit message.

Thanks for all the reviews!

> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -3669,6 +3669,19 @@ static __always_inline int validate_range(struct
> mm_struct *mm,
>   	return validate_unaligned_range(mm, start, len);
>   }
> 
> +static bool vma_uffd_range_aligned(struct vm_area_struct *vma,
> +	unsigned long start, unsigned long end)
> +{
> +	unsigned long size;
> +
> +	if (!vma_is_hugetlb(vma))
> +		return true;
> +
> +	size = huge_page_size(hstate_vma(vma));
> +	return IS_ALIGNED(max(start, vma->vm_start), size) &&
> +	       IS_ALIGNED(min(end, vma->vm_end), size);
> +}
> +
>   static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>   				unsigned long arg)
>   {
> @@ -3747,17 +3760,6 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>   	if (!vma)
>   		goto out_unlock;
> 
> -	/*
> -	 * If the first vma contains huge pages, make sure start address
> -	 * is aligned to huge page size.
> -	 */
> -	if (vma_is_hugetlb(vma)) {
> -		unsigned long vma_hpagesize = vma_kernel_pagesize(vma);
> -
> -		if (start & (vma_hpagesize - 1))
> -			goto out_unlock;
> -	}
> -
>   	/*
>   	 * Search for not compatible vmas.
>   	 */
> @@ -3774,6 +3776,8 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>   		ret = -EINVAL;
>   		if (!vma_can_userfault(cur, vm_flags, wp_async))
>   			goto out_unlock;
> +		if (!vma_uffd_range_aligned(cur, start, end))
> +			goto out_unlock;
> 
>   		/*
>   		 * RWP uses protnone as an access-tracking marker. PROT_NONE
> @@ -3797,20 +3801,6 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>   		ret = -EPERM;
>   		if (unlikely(!(cur->vm_flags & VM_MAYWRITE)))
>   			goto out_unlock;
> -
> -		/*
> -		 * If this vma contains ending address, and huge pages
> -		 * check alignment.
> -		 */
> -		if (vma_is_hugetlb(cur) && end <= cur->vm_end &&
> -		    end > cur->vm_start) {
> -			unsigned long vma_hpagesize = vma_kernel_pagesize(cur);
> -
> -			ret = -EINVAL;
> -
> -			if (end & (vma_hpagesize - 1))
> -				goto out_unlock;
> -		}
>   		if ((vm_flags & VM_UFFD_WP) && !(cur->vm_flags & VM_MAYWRITE))
>   			goto out_unlock;
> 
> @@ -3920,17 +3910,6 @@ static int userfaultfd_unregister(struct userfaultfd_ctx
> *ctx,
>   	if (!vma)
>   		goto out_unlock;
> 
> -	/*
> -	 * If the first vma contains huge pages, make sure start address
> -	 * is aligned to huge page size.
> -	 */
> -	if (vma_is_hugetlb(vma)) {
> -		unsigned long vma_hpagesize = vma_kernel_pagesize(vma);
> -
> -		if (start & (vma_hpagesize - 1))
> -			goto out_unlock;
> -	}
> -
>   	/*
>   	 * Search for not compatible vmas.
>   	 */
> @@ -3959,6 +3938,8 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>   		 */
>   		if (!vma_can_userfault(cur, cur->vm_flags, wp_async))
>   			goto out_unlock;
> +		if (!vma_uffd_range_aligned(cur, start, end))
> +			goto out_unlock;
> 
>   		found = true;
>   	} for_each_vma_range(vmi, cur, end);
> 
> -- 
> Cheers,
> 
> David
> 


