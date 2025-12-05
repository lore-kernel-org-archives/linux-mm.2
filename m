Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0CBFD2F7D1
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 11:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 006386B014F; Fri,  5 Dec 2025 06:03:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F20E36B0150; Fri,  5 Dec 2025 06:03:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36C86B0151; Fri,  5 Dec 2025 06:03:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD6D96B014F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 06:03:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F07D8593E1
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 11:03:28 +0000 (UTC)
X-FDA: 84185131296.10.332D6D0
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf01.hostedemail.com (Postfix) with ESMTP id 896D64001A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 11:03:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="Jlk/tWqS";
	spf=pass (imf01.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764932606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJmrnVAWmxW9nZlblGKQ8BQKPdrOnw9FZ2cIhgKrb+M=;
	b=ldwfFsr3t5Go93RfkXtamB8PM4sziCa8kywtscBDnliWvN1bnrTmtDC0RU4MtXO7EqUDcU
	REOIVVDIN4afWts0E3rZjeHO08wVxeSO198mcqm/DvFPKL9Ljxj3v5eC88a/DwWVjApT+t
	kbBoPya7Rp1tkC7PtSHHiaQWy85KC94=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="Jlk/tWqS";
	spf=pass (imf01.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764932606; a=rsa-sha256;
	cv=none;
	b=QKO3haVir0bPOVTQxay/nWODwmgbhYqpNGuIgV8Zt9M2KY3Da/WsfU0xxqAGUhzonpd+El
	M3NEBrq4HJJNekG1j5cipz2OAqetnruDqlLIFWetjdMM1y9l4yLbPMjFdmgqI9mf9ae0AX
	bm9hFZlI1y6EPuYpZiOH1tXFKqVEyb4=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5B50btS0008539;
	Fri, 5 Dec 2025 11:03:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=FJmrnV
	AWmxW9nZlblGKQ8BQKPdrOnw9FZ2cIhgKrb+M=; b=Jlk/tWqS+Mvj2GkJTqEjsM
	h9JHlqR5fEVkln5EC/D2gFobE6oWQM+eMTBuqtfHCReBQbKKZwfNixChaxcKFHVi
	06kSgn33U02ZgilNM0ivacYLVYJkoC9cHyA4hmTXfEb5hLxAzLUdyRx6Tdq3cBc5
	I+VNu4igdYJnX9erV55EV5oyGojlhMQ+vChL+dWOl1CcOuTahrLZHNLTX+dNJH0e
	y6WcSI6T2/WYbPWceKUdF+cOmK3fmmDezXYOx8oAqUP+gL5VjlTn7agxDxnLCipe
	ss2wPr0K9hTUzK+fdeUGb+YSF9tKRI93s0QLxRPefWUvvDILyMnJYRvZ+NI1MHyQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqq8v4kq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Dec 2025 11:03:17 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5B5B3Gk8027460;
	Fri, 5 Dec 2025 11:03:17 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqq8v4kpy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Dec 2025 11:03:16 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5B5A8Tdb024045;
	Fri, 5 Dec 2025 11:03:15 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4arb5sw0m3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Dec 2025 11:03:15 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5B5B3EQ738666604
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 5 Dec 2025 11:03:14 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 10EF320049;
	Fri,  5 Dec 2025 11:03:14 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2CED22004B;
	Fri,  5 Dec 2025 11:03:13 +0000 (GMT)
Received: from osiris (unknown [9.87.131.209])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  5 Dec 2025 11:03:13 +0000 (GMT)
Date: Fri, 5 Dec 2025 12:03:11 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Baoquan He <bhe@redhat.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>, linux-mm@kvack.org,
        ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com,
        vincenzo.frascino@arm.com, akpm@linux-foundation.org,
        kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, elver@google.com, sj@kernel.org,
        lorenzo.stoakes@oracle.com, snovitoll@gmail.com,
        christophe.leroy@csgroup.eu, Mikhail Zaslonko <zaslonko@linux.ibm.com>
Subject: Re: [PATCH v4 00/12] mm/kasan: make kasan=on|off work for all three
 modes
Message-ID: <20251205110311.11813A10-hca@linux.ibm.com>
References: <20251128033320.1349620-1-bhe@redhat.com>
 <CA+fCnZcVV5=AJUNfy6G2T-UZCbAL=7NivmWkBr6LMSnzzTZ8Kg@mail.gmail.com>
 <aTKGYzREbj/6Hwz6@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aTKGYzREbj/6Hwz6@fedora>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Eym7r3xetcUFAk65KHhR67Lgmhyr4aUZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAwOCBTYWx0ZWRfX7B7O4z0hwN0F
 PgOIq4ByAtB986RdaLRKvfuMymJWSwBG8yT17AQ+IHImaU5V4iKH22yS3C5KzddRnwhm3s5zhty
 J8dz5GSoaKbQ+QWsxQ/IMQIucT0AWhv6MkKp+FXlGEa9GYbg7YSn+ENTKp/TTwFRLBsoSbxTllb
 qvSSpl3oy3rGiW3WU8mRJyX4vV194CHOR93yKCJvGX2OKBr1BLyZUfduF/1ZL7Jy0g0ahlzhDGL
 q9S00qZyEdjOetvG31YFmuuXki4r0/7SHZr/UJeTmmxjCri8M+QGhX4rmnWXPlxoZICqVXOmPH9
 J1Sd2B/Ip0yIec6pnApVTgi8T9oMnMA+jxyng5MunAgiMX4gDXab2LXyFkn+hoMmV1m+DlossCy
 o4l0uJ04VKST6L6MWkGhMoRvN53nfQ==
X-Authority-Analysis: v=2.4 cv=Scz6t/Ru c=1 sm=1 tr=0 ts=6932bbf5 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=40HSkAYmfyoHoQYM2uIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: oD0qT5z5etYDFvofq45rGIQq18lrpDXv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-05_04,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1011 spamscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511290008
X-Rspamd-Queue-Id: 896D64001A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5po4yeebtgpwcmhqt1jdnibhjihqbhsk
X-HE-Tag: 1764932606-763987
X-HE-Meta: U2FsdGVkX18mBzghoK/osPiWJXnykqdkPKPMeifRN38Skgiq7V65h7AHKiBm4eXr9sgky3hkXtji8wxZMlFIQOXMifleP1q+8+PqOltilcdDUhsmYh4I26AA0DFxmfw8z6hG66mFOy6PY44MDpWOGm7ZUlBpTyv3e2pXiXjOX/XpAWUaNskhF95ZaV0iPYcMzxWllCE7TgtNzfcxPtisvUKxdWedQJhQJTIVfepMOinKGXAagZ4wESmc1LmD7mLghA3JOWm8kUzX88/KQsgYBfX6C5N41EjCKxQkeCotaMhMtUbo4oMB0Ah/23zk9JPoarH0zUc0N395L1Df9DYjQASV2zGDY8d67g2pFk1XRsoEYrrID7Gs/eLhsVJ1Yj8U+RaVOvrjZmsxs3l4blifvuBQmKm5JhAl9CvluKZac/Jji9wLxq5un7QAV9NGk1/Gre9jl146TSD7+TN5ZgJeuaw4tpd89NR7TerFhfoKtJ1qZGxP3YY5QumyPWmdyLAofbpRMKVd6WKM3iCi8Rw4IaaSpUcZD+WqojYD20H8lTPHjoR1NwDidvpZQPGwK7CNQoKW0D5+V4SajMOvl4cGPu7m94ha+w/VlBI3zI8d89S7Y2Uc5LCI/K1sCRwq99qApLVcWGdiDdewEiVQO8XwYmgv+ypKYxuxaqn3k+RbFWTZ5WXZDitJ0/DAEc21jk3PCcibbkzUOFGAEe+bCuoZuLXUrpIoSVmbcH32AQYeu/8UDbenJL81JK1zZYoUjUP2FL+xZXmsNoirojwTmKEWLmytEOrYB+mzEZ9YJjSyiyfnQBOtzBw+ytBjIbHSYpmzE0vnWSviDZMlIX/XYJ/PM9mTr3td6RWzbSNYiWqfe/7EuUYXt1PtsHse58M19MZyaopyXEvZ4pghuPtOnuHELSq9kqjvX+fAj1Jsay6M8R4RBNrjdK12zgZ1ftAnelXbf5rn8ROZ9zaaP7vCvuJ
 FTX5Gjjf
 NvY+L2fLQpSF8p7vXNnQ6rCIr3OlPruzM9wiHw5lAj8qXI7d5LIHrtSj61gbw675q6tQC/09GMceadASlTtXgykpYUWc1XCXgWMLICC6m3x65DgS3EqT7dZ4TOuEjHv0JUp97K0xyvaFb0FwMyshGrcb6gw+dV0XPy5EmYbQQ6ejbEjFcHcuiMEIsMDF+4+wN4RXb02Yv8tODvSmAAPYWM7GuJ5Ddd0DCUpZRJ8mJpUgCMCqzkxrs1zB1w8/dWD+molu3BREfZv+4vdyCVlcVMehJuDcwR2zRCBhAiSxuNqtPIpHwPsyh9hqxYZYz77bAWKLGo3aKzSIBsFc2j85laCNzt3mWk92kxumBeKixORxOUSCNGTCaPtYlTjkYig3nNISH4jVjv++DaMAfzdupbL+53HqbM8eIQRIgnL/T27E7fAUro1rZBDp63g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 03:14:43PM +0800, Baoquan He wrote:
> On 12/04/25 at 05:38pm, Andrey Konovalov wrote:
> > On Fri, Nov 28, 2025 at 4:33 AM Baoquan He <bhe@redhat.com> wrote:
> > I also wonder if we should keep this kasan=off functionality
> > conservative and limit it to x86 and arm64 (since these are the only
> > two tested architectures).
> 
> We may not need to do that. I tested on arm64 because it has sw_tags and
> hw_tags. And if x86_64 and arm64 works well with kasan=off in generic
> mode, it should be fine on other architectures. I am a little more
> familiar with operations on x86/arm64 than others.  I can manage to get
> power system to test kasan=off in generic mode, if that is required.
> From my side, I would like to see x86_64/arm64/s390/power to have
> kasan=off because RHEL support these architectures. I need consult people
> to make clear how to change in s390. Will post patch later or ask other
> people to help do that.

We are aware that s390 support is missing / does not work, and will
provide something. I guess something based on this series would be
good, or are you planning to send a new version anytime soon?

