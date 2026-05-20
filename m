Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 410A7CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 16:36:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81AC06B00E8; Wed, 20 May 2026 12:36:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F22A6B00EC; Wed, 20 May 2026 12:36:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BA9F6B00ED; Wed, 20 May 2026 12:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 59B8F6B00E8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:36:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 00C4E1203B8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:36:54 +0000 (UTC)
X-FDA: 84788352390.11.F689BC4
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4F77340010
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:36:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779295012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q5n7SZa1kCJjW4GKzWdX9Nc0n7Hf175be+HBk4Nr0Ko=;
	b=5szXhk0K+MpC1T0k/SNYdzIvpZGRbnK+O4o4oEjNYtZR78xiPntUsH/msWUbB1DQSoIqr7
	aCgvTK7L4Skte7gj4a5TpU8mwUKznCONP/3a3l5KO+cc/YPbjNpBpwZE1vYIgIMiCZxlm2
	eXAl7oc8CzNRfbjI4mre2VzmzPpFy98=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779295012; a=rsa-sha256;
	cv=pass;
	b=Oz6xontfnbceLKwRQ+T0slI3gcOIvKjKjFl+ssVFACEc0ZBAW/Q3iwe5/WJX6kf86ueoeB
	7/XlMvYXgwHhV96OxhvXI7vhxR93Uff/GeupyIEtJ5vLeMcfnClLP+uhq1rJx4gskk4Ap0
	QpKz+FdpNV6rJNm3daikhm8x0xB9HhE=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7B32C1931
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:36:51 +0000 (UTC)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A2E984039F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:36:51 +0000 (UTC)
X-FDA: 84788352222.11.F356237
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4274E140005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:36:49 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779295009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q5n7SZa1kCJjW4GKzWdX9Nc0n7Hf175be+HBk4Nr0Ko=;
	b=nO0rpCWT30p1j6MVntSrfvrsvUW97W8PBWf1qsYyNKE64oqGBjckHcgCKanH4Krfv5z6+b
	sJDK5fA2n3BHvC8wIOMN9Z6/adRQG0wayav259hzHYTErXZYsaAvsaoquXSu8cHIrUYkb3
	MGDXMYOz0FBu0N+8nnY3HW2yOGm31v0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=EdEukfR4;
	spf=pass (imf09.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779295009; a=rsa-sha256;
	cv=none;
	b=oGEYFlLsWM680Ui56r6sTwnhV9zDTON6EQWdmY6kJnV8TAJRFeo9+U2gndnDLF6JObj9Ak
	wtdq0QynZsIdbRRpCPZ3ceeZ553CkYIkCUd2hJkojZ3r5YTksvmqh5CncqaOCwQ1bNHcQY
	dYxrC1UYtXVOS173i3B+XCqesuOQfFA=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64K6Ehpp2818971;
	Wed, 20 May 2026 15:40:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Q5n7SZa1kCJjW4GKz
	WdX9Nc0n7Hf175be+HBk4Nr0Ko=; b=EdEukfR4Hw++PC1z++DjT8XQ0ZHyAG3wU
	d4C3cPoa/+Gp0dzzBFQpHyCoZExuwwvun0WFBNI+1Su/2fKLjFCg+sljbPNGVZsh
	NPAxKTmYkKUaZrka7vB4+s4DWb5aavXH1RW4Qtdc10fG/0+n0Bauybpcd5ICAbey
	wip3OcZcE4otIJkVBpFgeN1piR/s7KI4J/LMyRKeklw9qMA35GnWDGcKlfVkCKtp
	WkkfUZVCm8mQuJeud9j+61hoCCiPfmVb+axDYY6XlXIqYxzMEFpKk8fc5MEwoxy+
	txtZXZCo8p2I9pHFzbLceOUnjNyUeYXH3gH6xreX/UUfiIOmv0n2g==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h9y2vmb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:13 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64KFdACX016266;
	Wed, 20 May 2026 15:40:12 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e754gfrhe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:12 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64KFe8A825690384
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 15:40:08 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7DB912004B;
	Wed, 20 May 2026 15:40:08 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E4BA82004D;
	Wed, 20 May 2026 15:40:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 May 2026 15:40:07 +0000 (GMT)
From: Jens Remus <jremus@linux.ibm.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        x86@kernel.org, Steven Rostedt <rostedt@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <ibhagatgnu@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dylan Hatch <dylanbhatch@google.com>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Kees Cook <kees@kernel.org>, Sam James <sam@gentoo.org>
Cc: Jens Remus <jremus@linux.ibm.com>, bpf@vger.kernel.org, linux-mm@kvack.org,
        Namhyung Kim <namhyung@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Florian Weimer <fweimer@redhat.com>,
        "Carlos O'Donell" <codonell@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v15 02/20] unwind_user/sframe: Add support for reading .sframe headers
Date: Wed, 20 May 2026 17:39:46 +0200
Message-ID: <20260520154004.3845823-3-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260520154004.3845823-1-jremus@linux.ibm.com>
References: <20260520154004.3845823-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDE1MSBTYWx0ZWRfX1XVSLcrG7H6f
 KurXm7LSnAs0DOR1a2UG55zr6bNdqa4Tb0Zi91y/NYgWTbQLBCz5SDCq0TZIwoRK0fBLjs02ZP2
 kBQmUTYPssD1VsHcF7eHo7+OqAn1zMPKyB5S7l/pZhE1F6pCPS8GmofiElTj78DnExERr5csC+9
 hEC9MaRLOCsDSXVqmWfbbECbMvpGiexqK9KhKXqm3yiO28HlltEjAYYBpLlZVKwVLFzguiR8/Kd
 SPJI94kqFkF/TR/ss0rPVS9jKFusiW94cj2mHJGdcPAUmectyUSbIXfZuVTyYs2njBxB+RvRMmQ
 /YYlSgyro7R25hLrd6tjrKji0ZhQexn/DxG+gRDgDV09NXvMXOhxYH/tJ/jtdyKsjB0VkiSYMa2
 e047bWBfrxaoA+NV8XMx/j2vTAud0NuZDDv5WHhgNcCoaCoqGb8vTfwBJoa/s4Ufw9zNdGc0Gni
 WsAgv5KsUt//OJoNtNQ==
X-Authority-Analysis: v=2.4 cv=BNuDalQG c=1 sm=1 tr=0 ts=6a0dd5dd cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=CCpqsmhAAAAA:8 a=meVymXHHAAAA:8
 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=n2P1YqxNjAFD8MGDs80A:9
 a=ul9cdbp4aOFLsgKbc677:22 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: wdhLLsLq9gws6Xxr31fVHQt-1N207Km2
X-Proofpoint-GUID: AbugIBAPnhPyOr4ahSt9w4Zc9eJrIAqj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200151
X-HE-Meta: U2FsdGVkX18/XXuEhe5XFuAUevBlJ5sYJoD52reDmKBpormmK40Aum5JPiObO0Na2hBlOnvL2j8IDxlWuxLLD0acQPp3zn/yjBtkGuBm+KlD777Qd6zVKIWXiEKTsrjVpfU+nzlkoNuHyEAM3grtzRW7LhIp8YpWn379izetapQk3dmzoYrHDeDhhGKD2aYdVY3iltoJJFIxKyqhpCbE7szrMQzusLOqWB4PY9RafuKNZbbou/7j4aYLkKjNTf08eishrMYzszyoEyaCkAYqx7ZhFgDT+nczP0du5EdnaiD4RFexBGXEXX+8pJ/zHvm083YTRjueph3X1MhGeN8MCd28hTnQn4yLpVlzuVLW6OiXihKea7t267WGbaeHbQE9jHtMwVu6vzGLnHP/YIlJz4re4X4JJq9sMl6mKB0HotrJ9gkAa0FKc4txxBEyyr9kX6jrbLe94eaD2Q2kcTXF6Jvlj/7yClPYOPNuEyB1esdde+YUs1vu73Zykaqv9U5ucrv2rv0z982ORoiy3zNPksql8rC5VslAf5OtNhyHHBX1nFHOEe9hflZGjGjIbXze1AKMYmY1xKnp1zvjuoRjG73TuaFuQu+aGJbb7zTaa6YBclYzFtTux1HjUs0jmPE4khQqZDtmBIJF4g8fh+NhNd8FCN2N7S5I97wDp5IsMMyzSxyWcwyV59lgYkecSECCT5AItDq62f6Ex63oR3Jg4gn1HbdFNUcFGqWek8l93AO2G1ivJJ2QzO/q/pPTX7j8ADVU6W7FW/pi1JMFjwPsHxdvqi+9RZf1BCGFmt8U7Nzk2Y4lYj003kiyCVu25LUbKit2me5NiNkr6j8MqMEW+ogrj3bf0D2tHVUR8mbhFGcii9YUow3c5bJBwhyMWAQbhz231HDvBVWn8xxVohkTT8jxt+QfDeueOW76/dBY3h3x0A6pBo28j0RXmyMJsSR1kyFxrbOHOUQny49q0jC
 skCnnj2r
 +w1fKFIIhteY6p36TEF7iUWzftDJbZB24YWpf0kYQaVXN5zhnJUxEwFGDcHbLs02eIl3rIqBNzkQ15J7Ik7Qk961ZtWS8BolTdTTkVfMojG+ZAEy0UNvQzJpbdKVBpVDlWr8ZHMaD0VO/xdP8sCD0hb1UDikLsgfsjXH/YQvADiiJXxd3o+PXchxc8zG4gRls9sUp7fx9MHohOzS3p6JNpHUochghxKxqXEL2/2L01v90XzJbdX6vqIdK8iOEG9V/WKrfjk237+TNeP42YZm2075vLtSwZSkRyYXIIugCuKoPLRKvm7edVmz0wslGz5duQg9fwbsoaZSE4Lh7lTFROUQCm4+nmJd5bDmBr1qZW3G0Bx/NLQDVu3oSd9jGmkX1lWMWt9mUuJxiCYI/DP6HNQfG5dJAhoT1ZJV5f8Lf5EhK7z83osiyoDrta5IgmWrpGoYlpFQgyClT34ioc9ePskVKaPAeShFt2MuQTWgj/+Z8OeRxctMN6Uk4aiICpO3R2aBRKGahSJVdMF/2pPfBa9KK2/ewM9KsZpWRD9VUO4X2MGw=
X-HE-Tag-Orig: 1779295009-494483
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4F77340010
X-Stat-Signature: aqaqmj469osx1b8m84jndm4fnrzxmji5
X-HE-Tag: 1779295012-429509
X-HE-Meta: U2FsdGVkX1/twKEbWk+toPAjw3/vI7kO8xjsVB5goPuOxBxZWeMOJYEu9PsvelPKXiZWJWXssn3cCe6Wu26dK+DdWS+pxv6LsaQTMCy7cvPIs0n0hq234y2glJn7eS/Ow2ytgm6l/nXYAJE4ICseSYyua394cdp7Y98nf6DKAvdPC6738FocMyGfHaWz9a7gNVAfAcf7oacG5BFp2zzvscZ2Xp6VFXcFhKREs38SmuLvUgNJw8pStgzIQ9YYYhaYJrWvEQKZqsfHgvguTZG4J5APuo72lZsrKw7F1WPWfC3KGE/DQjX+JwSPzuAG9jVEqUl82/2DDvHAt1auHrx/2nAVCZBRg794nD5c9oks7haX5Hr2sdBZqKHimXxeSnX5nf/Xr3WaZyG3tfIxD++U7Of+2YWUXy3TMBjfBPFwIW3frsxDak6eX8UPU+O2irCeydW5DnpbX1Rum4RYPyH27SyMxfn9YYVbqycmK/666dsoLpG+aO3PApvI1R9fhoHUaAKbVhYz7wYsyzkfohHNDOnmtVgKPsA6ldy5Pk95xGxRy1WSv32qiHBm9GXwX1maMl46leOeipg1aoANpvf2GbPRd5vnoknuYjCXNNnwWsZ1tQW1mEG4kjktIeNrlAeZYZXNXOwxQMyQO/Glb8AHIRPbKrEpK5TYBJFajm1kL/BHeQ3TE0ORxs6ObUhEx8KOp6zfgjmUtaUy+H01f1yIDKr2jbdyHNYNKSz2hg533KD327lHAktfT1f5kymKqsm5VKbKizR6AC8yBFNp66/TIeDUO3aPB7sLHJhvbsLoV1rFUH81BXw80vu9uo7W53B4LDpyyWWYD+zFWwsSqpkWQl2SBKHbAztRmRH2ZsNRMsNDrvVp1F42eePsrl2zQTUYe5rPJ41jAxrVYIEhuN9xWVtYsIfFdVJfv4baEph5UgMFVGYhpcoGNtPz+ap9L2BoWk0WTcAH3y/lg1TSMUh
 Z1PRJ68D
 t57dctdPEv8KyS12ExXgW8ilW2OmSLRcDigs8DZX8oSojDH9QKrGO6NiLs1TJYhDRNYvDj4rjgYaqNKAQ/EtcpDFYm9ArylpOkXN5np6fx7WIocfaZP10Oyll64aFPbHbXiyRz5LsQS/Mqnoz9OPO/NzUK4kQU+mNmRW91RwT1ZO3gc+jKltexsg7GqDj5LwHHUtwBeWQ0C+QwoX9gxS4m0ng/dGmr0HFiWzX/Va8m/mwJU3CJRieblCEmRWqwlw5r4+XsSN3pAJeGcRK5guZOIMzjTQY+Ib+nIyZkaI0pVVTZRKofCxW5kog43TWH/Klh7lUIQqaC/Nrhbyczhoaykvz4rB7jDxP+NjoVuh9RDD2Um5mBrIes8BXq8pK24TwwR1iiMS/VGZLlFifhzTNmV5M1yjliUpzop8O+60pwxfPIBIcX2Nc4WKpb1qS/Iu/gM1ky6IAI2cftaE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

In preparation for unwinding user space stacks with sframe, add basic
sframe compile infrastructure and support for reading the .sframe
section header.

sframe_add_section() reads the header and unconditionally returns an
error, so it's not very useful yet.  A subsequent patch will improve
that.

Link: https://lore.kernel.org/all/f27e8463783febfa0dabb0432a3dd6be8ad98412.1737511963.git.jpoimboe@kernel.org/

[ Jens Remus: Add support for SFrame V3.  Add support for PC-relative
FDE function start offset.  Cleanup includes and indentation. ]

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v15:
    - Improve text/sframe section start/end validation. (Sashiko AI)
    - Use GFP_KERNEL_ACCOUNT instead of GFP_KERNEL (see
      memory-allocation.rst, section "Get Free Page flags"). (Sashiko AI)
    
    Changes in v14:
    - Rename SFRAME_FDE_TYPE_REGULAR to SFRAME_FDE_TYPE_DEFAULT to match
      SFrame V3 specification. (Indu)
    - Correct SFRAME_V3_FDE_TYPE_MASK value.
    
    Changes in v13:
    - Update to SFrame V3:
      - Add and use SFRAME_VERSION_3 definition.
      - Add helper macros to access SFrame V3 FDE type.
      - Rename SFRAME_FUNC_*() macros to SFRAME_FDE_*().
      - Rename SFRAME_FDE_TYPE_PC* defines to SFRAME_FDE_PCTYPE_* and
        SFRAME_FUNC_FDE_TYPE() macro to SFRAME_V3_FDE_PCTYPE().
      - Reword OFFSET to DATAWORD in SFRAME_FRE_OFFSET_{COUNT|SIZE}()
        macros.
      - Rename version-specific SFRAME_*() macros to SFRAME_V3_*().
      - Update struct sframe_fde and rename to sframe_fde_v3:
        - Change field start_addr from s32 to s64 and rename to
          func_start_off.
        - Change field fres_num from u32 to u16.
        - New field u8 info2.
        - Remove u16 padding field.
      - Split FDE into function descriptor entry (struct sframe_fde_v3) and
        attributes (struct sframe_fde_v3).
      - Rename macro parameter "data" to "info" to hint at fde/fre info
        word and wrap it in parenthesis.
    - Group SFRAME_* definitions so that related ones are together.
    - Reword commit message (my changes).

 MAINTAINERS            |   1 +
 arch/Kconfig           |   3 +
 include/linux/sframe.h |  37 +++++++++++
 kernel/unwind/Makefile |   3 +-
 kernel/unwind/sframe.c | 136 +++++++++++++++++++++++++++++++++++++++++
 kernel/unwind/sframe.h |  81 ++++++++++++++++++++++++
 6 files changed, 260 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/sframe.h
 create mode 100644 kernel/unwind/sframe.c
 create mode 100644 kernel/unwind/sframe.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 7434e9d7b33f..a9b42b67a88d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27876,6 +27876,7 @@ M:	Steven Rostedt <rostedt@goodmis.org>
 S:	Maintained
 F:	arch/*/include/asm/unwind_user.h
 F:	include/asm-generic/unwind_user.h
+F:	include/linux/sframe.h
 F:	include/linux/unwind*.h
 F:	kernel/unwind/
 
diff --git a/arch/Kconfig b/arch/Kconfig
index e86880045158..94b2d5e8e529 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -486,6 +486,9 @@ config HAVE_UNWIND_USER_FP
 	bool
 	select UNWIND_USER
 
+config HAVE_UNWIND_USER_SFRAME
+	bool
+
 config HAVE_PERF_REGS
 	bool
 	help
diff --git a/include/linux/sframe.h b/include/linux/sframe.h
new file mode 100644
index 000000000000..0642595534f9
--- /dev/null
+++ b/include/linux/sframe.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_SFRAME_H
+#define _LINUX_SFRAME_H
+
+#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
+
+struct sframe_section {
+	unsigned long	sframe_start;
+	unsigned long	sframe_end;
+	unsigned long	text_start;
+	unsigned long	text_end;
+
+	unsigned long	fdes_start;
+	unsigned long	fres_start;
+	unsigned long	fres_end;
+	unsigned int	num_fdes;
+
+	signed char	ra_off;
+	signed char	fp_off;
+};
+
+extern int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
+			      unsigned long text_start, unsigned long text_end);
+extern int sframe_remove_section(unsigned long sframe_addr);
+
+#else /* !CONFIG_HAVE_UNWIND_USER_SFRAME */
+
+static inline int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
+				     unsigned long text_start, unsigned long text_end)
+{
+	return -ENOSYS;
+}
+static inline int sframe_remove_section(unsigned long sframe_addr) { return -ENOSYS; }
+
+#endif /* CONFIG_HAVE_UNWIND_USER_SFRAME */
+
+#endif /* _LINUX_SFRAME_H */
diff --git a/kernel/unwind/Makefile b/kernel/unwind/Makefile
index eae37bea54fd..146038165865 100644
--- a/kernel/unwind/Makefile
+++ b/kernel/unwind/Makefile
@@ -1 +1,2 @@
- obj-$(CONFIG_UNWIND_USER)	+= user.o deferred.o
+ obj-$(CONFIG_UNWIND_USER)		+= user.o deferred.o
+ obj-$(CONFIG_HAVE_UNWIND_USER_SFRAME)	+= sframe.o
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
new file mode 100644
index 000000000000..d24e9d4f8bef
--- /dev/null
+++ b/kernel/unwind/sframe.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Userspace sframe access functions
+ */
+
+#define pr_fmt(fmt)	"sframe: " fmt
+
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/srcu.h>
+#include <linux/uaccess.h>
+#include <linux/mm.h>
+#include <linux/string_helpers.h>
+#include <linux/sframe.h>
+#include <linux/unwind_user_types.h>
+
+#include "sframe.h"
+
+#define dbg(fmt, ...)							\
+	pr_debug("%s (%d): " fmt, current->comm, current->pid, ##__VA_ARGS__)
+
+static void free_section(struct sframe_section *sec)
+{
+	kfree(sec);
+}
+
+static int sframe_read_header(struct sframe_section *sec)
+{
+	unsigned long header_end, fdes_start, fdes_end, fres_start, fres_end;
+	struct sframe_header shdr;
+	unsigned int num_fdes;
+
+	if (copy_from_user(&shdr, (void __user *)sec->sframe_start, sizeof(shdr))) {
+		dbg("header usercopy failed\n");
+		return -EFAULT;
+	}
+
+	if (shdr.preamble.magic != SFRAME_MAGIC ||
+	    shdr.preamble.version != SFRAME_VERSION_3 ||
+	    !(shdr.preamble.flags & SFRAME_F_FDE_SORTED) ||
+	    !(shdr.preamble.flags & SFRAME_F_FDE_FUNC_START_PCREL) ||
+	    shdr.auxhdr_len) {
+		dbg("bad/unsupported sframe header\n");
+		return -EINVAL;
+	}
+
+	if (!shdr.num_fdes || !shdr.num_fres) {
+		dbg("no fde/fre entries\n");
+		return -EINVAL;
+	}
+
+	header_end = sec->sframe_start + SFRAME_HEADER_SIZE(shdr);
+	if (header_end >= sec->sframe_end) {
+		dbg("header doesn't fit in section\n");
+		return -EINVAL;
+	}
+
+	num_fdes   = shdr.num_fdes;
+	fdes_start = header_end + shdr.fdes_off;
+	fdes_end   = fdes_start + (num_fdes * sizeof(struct sframe_fde_v3));
+
+	fres_start = header_end + shdr.fres_off;
+	fres_end   = fres_start + shdr.fre_len;
+
+	if (fres_start < fdes_end || fres_end > sec->sframe_end) {
+		dbg("inconsistent fde/fre offsets\n");
+		return -EINVAL;
+	}
+
+	sec->num_fdes		= num_fdes;
+	sec->fdes_start		= fdes_start;
+	sec->fres_start		= fres_start;
+	sec->fres_end		= fres_end;
+
+	sec->ra_off		= shdr.cfa_fixed_ra_offset;
+	sec->fp_off		= shdr.cfa_fixed_fp_offset;
+
+	return 0;
+}
+
+int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
+		       unsigned long text_start, unsigned long text_end)
+{
+	struct vm_area_struct *sframe_vma, *text_vma;
+	struct mm_struct *mm = current->mm;
+	struct sframe_section *sec;
+	int ret;
+
+	if (sframe_start >= sframe_end || text_start >= text_end) {
+		dbg("invalid sframe/text address\n");
+		return -EINVAL;
+	}
+
+	scoped_guard(mmap_read_lock, mm) {
+		sframe_vma = vma_lookup(mm, sframe_start);
+		if (!sframe_vma || sframe_end > sframe_vma->vm_end) {
+			dbg("bad sframe address (0x%lx - 0x%lx)\n",
+			    sframe_start, sframe_end);
+			return -EINVAL;
+		}
+
+		text_vma = vma_lookup(mm, text_start);
+		if (!text_vma ||
+		    !(text_vma->vm_flags & VM_EXEC) ||
+		    text_end > text_vma->vm_end) {
+			dbg("bad text address (0x%lx - 0x%lx)\n",
+			    text_start, text_end);
+			return -EINVAL;
+		}
+	}
+
+	sec = kzalloc(sizeof(*sec), GFP_KERNEL_ACCOUNT);
+	if (!sec)
+		return -ENOMEM;
+
+	sec->sframe_start	= sframe_start;
+	sec->sframe_end		= sframe_end;
+	sec->text_start		= text_start;
+	sec->text_end		= text_end;
+
+	ret = sframe_read_header(sec);
+	if (ret)
+		goto err_free;
+
+	/* TODO nowhere to store it yet - just free it and return an error */
+	ret = -ENOSYS;
+
+err_free:
+	free_section(sec);
+	return ret;
+}
+
+int sframe_remove_section(unsigned long sframe_start)
+{
+	return -ENOSYS;
+}
diff --git a/kernel/unwind/sframe.h b/kernel/unwind/sframe.h
new file mode 100644
index 000000000000..fc2908e92c7b
--- /dev/null
+++ b/kernel/unwind/sframe.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * From https://www.sourceware.org/binutils/docs/sframe-spec.html
+ */
+#ifndef _SFRAME_H
+#define _SFRAME_H
+
+#include <linux/types.h>
+
+#define SFRAME_VERSION_1			1
+#define SFRAME_VERSION_2			2
+#define SFRAME_VERSION_3			3
+#define SFRAME_MAGIC				0xdee2
+
+#define SFRAME_F_FDE_SORTED			0x1
+#define SFRAME_F_FRAME_POINTER			0x2
+#define SFRAME_F_FDE_FUNC_START_PCREL		0x4
+
+#define SFRAME_ABI_AARCH64_ENDIAN_BIG		1
+#define SFRAME_ABI_AARCH64_ENDIAN_LITTLE	2
+#define SFRAME_ABI_AMD64_ENDIAN_LITTLE		3
+
+struct sframe_preamble {
+	u16	magic;
+	u8	version;
+	u8	flags;
+} __packed;
+
+struct sframe_header {
+	struct sframe_preamble preamble;
+	u8	abi_arch;
+	s8	cfa_fixed_fp_offset;
+	s8	cfa_fixed_ra_offset;
+	u8	auxhdr_len;
+	u32	num_fdes;
+	u32	num_fres;
+	u32	fre_len;
+	u32	fdes_off;
+	u32	fres_off;
+} __packed;
+
+#define SFRAME_HEADER_SIZE(header) \
+	((sizeof(struct sframe_header) + (header).auxhdr_len))
+
+struct sframe_fde_v3 {
+	s64	func_start_off;
+	u32	func_size;
+	u32	fres_off;
+} __packed;
+
+struct sframe_fda_v3 {
+	u16	fres_num;
+	u8	info;
+	u8	info2;
+	u8	rep_size;
+} __packed;
+
+#define SFRAME_FDE_PCTYPE_INC			0
+#define SFRAME_FDE_PCTYPE_MASK			1
+
+#define SFRAME_AARCH64_PAUTH_KEY_A		0
+#define SFRAME_AARCH64_PAUTH_KEY_B		1
+
+#define SFRAME_V3_FDE_FRE_TYPE(info)		((info) & 0xf)
+#define SFRAME_V3_FDE_PCTYPE(info)		(((info) >> 4) & 0x1)
+#define SFRAME_V3_AARCH64_FDE_PAUTH_KEY(info)	(((info) >> 5) & 0x1)
+
+#define SFRAME_FDE_TYPE_DEFAULT			0
+
+#define SFRAME_V3_FDE_TYPE_MASK			0x1f
+#define SFRAME_V3_FDE_TYPE(info2)		((info2) & SFRAME_V3_FDE_TYPE_MASK)
+
+#define SFRAME_BASE_REG_FP			0
+#define SFRAME_BASE_REG_SP			1
+
+#define SFRAME_V3_FRE_CFA_BASE_REG_ID(info)		((info) & 0x1)
+#define SFRAME_V3_FRE_DATAWORD_COUNT(info)		(((info) >> 1) & 0xf)
+#define SFRAME_V3_FRE_DATAWORD_SIZE(info)		(((info) >> 5) & 0x3)
+#define SFRAME_V3_AARCH64_FRE_MANGLED_RA_P(info)	(((info) >> 7) & 0x1)
+
+#endif /* _SFRAME_H */
-- 
2.51.0



