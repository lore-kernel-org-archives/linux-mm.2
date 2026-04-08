Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0544DFD5F6F
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 04:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12EB16B0088; Wed,  8 Apr 2026 00:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DFFE6B0089; Wed,  8 Apr 2026 00:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F108B6B008A; Wed,  8 Apr 2026 00:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBC7C6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 00:29:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82146E226C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 04:29:17 +0000 (UTC)
X-FDA: 84634109154.28.526060F
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf03.hostedemail.com (Postfix) with ESMTP id 28EEE20005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 04:29:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HH44Swm7;
	spf=pass (imf03.hostedemail.com: domain of maddy@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=maddy@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775622555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fbU3U9g+IPjQX/84R/EftEMLT3wDPQDbCdM5WWuF8w4=;
	b=A6f9BNJ0GXUB+BtHvWaacPJ/18MhAHsFNZBzkRXpHH5nwtbXGeDs5TRlhxYr3xDzHucUPD
	SftG5kLGRgri66Q5vCPVQxHJ3mEZVuAjTvZpNgHmovx6Q+LadkRWU+SV70kRwXuaaxdAIQ
	DLT39/9m9gz3c2/P2sDli4m+VFxwT58=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775622555; a=rsa-sha256;
	cv=none;
	b=Nl5jd4iGGej/5cjRI52b6ub4dNQ2JCsiz+soFAEv1aX4o2EAFDrq7L5zKcXGtyrs7l/1sQ
	C4fDTT4zT49Mb00KbUyQZ42mXiFCHtoZvHP2ruMP0SK2h8FTq7fpiy12NO7VDRhJ1AgEDo
	yfdMfX7lPeb2BteyPDU4CJ3jZAqz728=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HH44Swm7;
	spf=pass (imf03.hostedemail.com: domain of maddy@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=maddy@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 637Eno5j2329508;
	Wed, 8 Apr 2026 04:29:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=fbU3U9
	g+IPjQX/84R/EftEMLT3wDPQDbCdM5WWuF8w4=; b=HH44Swm7Ykd9Lg9Npx0R+b
	WzZmJPNppRyGix4yqXbnHnl/NyIdYmSgtd26l/YdUNLkfJZOp4VoPo5IZ+mYTKnS
	IPGILyML3qwONd7Krk2b7IM33m+lwzOyBu9DgmSZZTonR3B6R0jRPYNA5zgOoBcF
	1VKPXmINwdLaRSW4tWzXIKMizMrLZJ52Oqh+4cRalPU+6tfFpW06MTFJl9DS4hkl
	H/UqHzsOWuMd76f+OINgG6owENJ+tN60QA2cCCbPTnwEPi7NBDnJbzhyv4PvXHWc
	/JqORlFLO8WLSxqpkMGLpIOcIy2x1BwqUkcESYsjf56ajXlCwqV8kctmggJSO5QA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2kdrer-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 04:29:11 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 637NnE2P007917;
	Wed, 8 Apr 2026 04:29:10 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dcmg2dyyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 04:29:10 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6384T8qv34079034
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Apr 2026 04:29:08 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A215B20043;
	Wed,  8 Apr 2026 04:29:08 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 09F2320040;
	Wed,  8 Apr 2026 04:29:07 +0000 (GMT)
Received: from Linuxdev.bl1-in.ibm.com (unknown [9.123.3.0])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Apr 2026 04:29:06 +0000 (GMT)
From: Madhavan Srinivasan <maddy@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>, linux-mm@kvack.org,
        kvm@vger.kernel.org, Alex Williamson <alex@shazbot.org>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2 1/2] drivers/vfio_pci_core: Change PXD_ORDER check from switch case to if/else block
Date: Wed,  8 Apr 2026 09:59:06 +0530
Message-ID: <177562236414.1381144.5625779243354479459.b4-ty@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b155e19993ee1f5584c72050192eb468b31c5029.1773058761.git.ritesh.list@gmail.com>
References: <b155e19993ee1f5584c72050192eb468b31c5029.1773058761.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDAzNiBTYWx0ZWRfXxHzVAfxPfHY6
 EKqjgTI2MkqUEF04YC3L+FdtHaHfmYfrT9+WRNltZwCelmXviAjJV0qZI73MqNGcI672XNHsoaS
 VbW3a1L0ijrR4aIT6h12p6L4lFy1XGaGzRl/NDTq0A2wwpU0zIL9cMzrsWxu5/qL2O6PqMrcH8r
 ZqRP6gX9WlzX1vNSAB71LgTZIuL6FlUVBg8sPVGo1nRy7hj4d6Qa7rgrZQ78sFjrCWRSg5tvoCP
 SXkwZGgvfZ7u5gYYsJgE5vEmarW42K3W2w3tE43s645h8fVaRkBLKEfW6yuE58fBGouYZqhCUiY
 jM+fd7sYvq7s5jm9tcSJtexfvbOltrYSW0eA3WW05Al8d0WFwiBpCbMoRG/LdVxG1UfJpAmbGTW
 1puX9KVpYIUN7NUwHME80Ihkwhr0QIdIFhK5Shk7yIJaj5KBtBGUW5bKB9dYmZc7Q7b9UfCPjQ1
 z8gbaq6BhqLQE85+vVg==
X-Proofpoint-ORIG-GUID: 7LjTGaq9Zv79J28arr1hhQxynanjC-Cr
X-Authority-Analysis: v=2.4 cv=e9k2j6p/ c=1 sm=1 tr=0 ts=69d5d997 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=FPAXCejgittSz9clB9QA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: KQK6zNVxSIIYeGvpK0VHj7vdbHkJuYoH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_02,2026-04-07_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 malwarescore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080036
X-Rspamd-Queue-Id: 28EEE20005
X-Stat-Signature: amm697wurtmtgf5fdpph96psdwjq9sw9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775622554-861635
X-HE-Meta: U2FsdGVkX18VCriap+LecnfG4VZl4Q9nmkfaVPVP7sJmDcyH2VgPwu9R7r0fi8vXNZdYGHW+FLr678e+d6Nx3WxREaINQD1CaFS+CUpLgfIfpKGptc2I+dfl+mmUdWmN7GScx2RsdTvk7UUc3f36Ww6E2rNREG04jCRyF0k44R/op956kO0ET2qdqTQB9Gyt5F5uAO+lJ/g6GZuGYsiYocI8sOdYGDelx5j4UmdD2n48RXS9tICV6YL03/oFfA5Wd73KlwmePF27D4JarFs8RkgCN3LUFthxiPbErtCK5Il2djfrt1io50m88T+OtAB3zVcyIxF/wYzYJJbNPjzUccpSxEnNGnmsAZArii85EeaoFdATj3Gg2Tr+fhv0XaB+YkP3rMiHmqmoU6BPKMk6w3VB/GPtpNCKa0S5qSoLLhq46XXvYfUV0k5YiEV1t+QfMXQSJl6YxMacWmEliZ/2aLEJ05z+cCAvlPiX5qJx+TfGPehkESw5yijFugPzmWQkah5H9PzQ54l0M8mg1iZT6cCjxGHs3c1yLVnXmSAdzsF1epeq4IySyZU7SHjODSgcraVaMx4aTY/pnx08cm2y19PuczVVdfdJjo1/n4kyrvcpLzp7HdSpU0zsw0VDdl5q3N/cP+1beNXSI7PZOj3ZOiKfNGLS6PcgOExbkHoo/3z3eH2eNPsRVdu7g8Jli/LqY8kenBp39zjKJYcre8XegSDhumYPwr7sJU0sk9lgv8fW+QUWShsAQsUvC/jGbk3jxL6phQFaDhZYRqD0nNQd9dP6jbREXrI0JVK5K0JY6EIOA2KfEwrueI9HA4F9hXIgYxQpEL3n6t6vcEYlqZmXJ2YeQdZ85aQXgRnIDpocHmlajeOlgHVHXqo1oym90cyxaI3yArDRij8l7tvndbQpUDunh4nuUHWlwPDBd16DSd2AZ0WVksetWBShQvHc5dNHvRy1k6+/QWFMjvNcS8G
 /oorwhEA
 gYOHokaN8IngPQwmq6u2eq192zILgmCeMjKxInZf7nAB0iVe8QZuiCBKDJPCIcGrzvmwFOYCihd6K1oBdFHmCuuCr4/dzWzovIHeM+fCWCNp2foM5D/rl7Pa+e170EmL2BYfMZVWGb/D62T5ZjIjCJnFh6zSP1TEH0+ehhsGJJm1AkxqEmnMJHCCwRuUZzyeCV5/VStKAFcvZGZUWel4LsHCwOE+oGp45bYrTzxdszH89V3lbeRXaCZjzMjhK7dcX7YMJIPapiHrdi4ZJ9gx+7X7o4t3If8Mb93hifI/Uh3nANuQuNe5nxlFt8FIOJWWxa+91kjkbo4VgRD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 09 Mar 2026 18:08:37 +0530, Ritesh Harjani (IBM) wrote:
> Architectures like PowerPC uses runtime defined values for
> PMD_ORDER/PUD_ORDER. This is because it can use either RADIX or HASH MMU
> at runtime using kernel cmdline. So the pXd_index_size is not known at
> compile time. Without this fix, when we add huge pfn support on powerpc
> in the next patch, vfio_pci_core driver compilation can fail with the
> following errors.
> 
> [...]

Applied to powerpc/next.

[1/2] drivers/vfio_pci_core: Change PXD_ORDER check from switch case to if/else block
      https://git.kernel.org/powerpc/c/948b71aa81cd89b222942db6055e8d9c51c54e78
[2/2] powerpc/64s: Add support for huge pfnmaps
      https://git.kernel.org/powerpc/c/d1503aa9ab8057cb93367e0184528f61f7510845

cheers

