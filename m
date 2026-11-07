Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCF04606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=lbXY0gAz;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=EmCzfMn1
Received: by kanga.kvack.org (Postfix)
	id DAC496B05BA; Fri,  6 Nov 2026 21:39:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84506B05C2; Fri,  6 Nov 2026 21:39:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4B816B05C3; Fri,  6 Nov 2026 21:39:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 878C56B05BA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:39:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 140468027D
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:39:52 +0000 (UTC)
X-FDA: 85406767824.28.343028F
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 94370C0005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:39:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=lbXY0gAz;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=EmCzfMn1;
	spf=pass (imf22.hostedemail.com: domain of himanshu.chauhan@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=himanshu.chauhan@oss.qualcomm.com;
	dmarc=pass (policy=none) header.from=oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794019189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L420166GSS4TE+K47OptRNcFOTisOIHTM/2QMseJ/eQ=;
	b=LEFN+OCsAbG8lD1GMILPN2NUx3HU07h/3BRPJxmvI8GrHW+yC+ae1DsHx7djKz1mu2odwk
	LGgmlwwa2t/s/uiI6C8C+gpG2ySSHgFM70lKVD3hHyGD6KSSOG+k6eeoJqzMQExhBBhd1P
	BSk2TXYt2g2kzvVJ50N3dqUndf7aqwU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794019189;
	b=AQcfxxgsVFDWlXAmDy5U+oNJ/TbT/QarCOxk+K434GPygMSdZyrvjxRndzQ0TI9y7nA3vM
	wdqh+c3G/S3iNX94DYTF4i74EWcP8lueO7Cro00zkDuNw6wpB2Blki73oHVmlYlFQ249YZ
	G2l3N0ej7wfZlkba3NOSNIsbp0WQMwk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=lbXY0gAz;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=EmCzfMn1;
	spf=pass (imf22.hostedemail.com: domain of himanshu.chauhan@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=himanshu.chauhan@oss.qualcomm.com;
	dmarc=pass (policy=none) header.from=oss.qualcomm.com
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A72B2wa1521133
	for <linux-mm@kvack.org>; Sat, 7 Nov 2026 02:39:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=L420166GSS4
	TE+K47OptRNcFOTisOIHTM/2QMseJ/eQ=; b=lbXY0gAz5PjhZ53/zvhjXNUzRVe
	2M8GWGe8UczDg43WWUJiAcU22wyjOmftVZWAKG/fBBUx6RC2ZGJdQW3zl20ggfIv
	jptojMcEOJJkSiicXOzxyARK0CjvbSqTYi+u3W5FtsBXHTygxuYYyIn+Hb0GWGik
	OUzC7GcOR/Pury2piCPxQeGZr/KFSXlNJdz/j00AzbYm085PJY1og9odi1OFxaJk
	4dNQhQEFGKqcZnxGD9CPfgqtcSu52bSU6cpcBgKDmki5xTBRzuqSjEfWPFLoo63G
	DLWGWbNaP2C7TaBPQgHdHyNjv41eQPUq9QOaAinxsUDhE5bouNUB/JXXAAQ==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hssbnr9fc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 07 Nov 2026 02:39:48 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36cec75d8caso349107eec.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794019187; x=1794623987; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L420166GSS4TE+K47OptRNcFOTisOIHTM/2QMseJ/eQ=;
        b=EmCzfMn1lzn6+h3ZDUZclrWFSG88yO9oEu+G2JZk+YY73KYSmn89mQ8JICJSU48zlo
         gefI+gtQNKwV+yM+cTtx3Ly5rRHHP9OypQcK05EnscCNGE7ElzlYqym3KCC4uKL6PUzG
         lqYvBIRlRLLPB7r5Q7lho19T2Kkf1ky6GZMtXEnMHYV+Raph72RPZKzydjhkTz1WIfV0
         407rjqtOUDxe6YtpkPC9HRmh1DZ4ZvZkmIERM1dr/iGTsquX43e689RRT9KKJB6SEch7
         N54xjt7DadILI1Ginls8JbPWdjvNoZVMmFChmabXdtqwNrnwuxxMI84TqmU6T7dXu3Ft
         HQLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794019187; x=1794623987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=L420166GSS4TE+K47OptRNcFOTisOIHTM/2QMseJ/eQ=;
        b=IPuMx5KLUHSr9yp9d8GNrmZJqgtsKAPl+CuaxU1UVf3eOlKr3TuCo7tpFcdclgTB2/
         eu1ekq3qL1DFkq393bosACD4jSJIwaPL+cW4SDLq072cgRoyztqpDXh8iaWSS3mcXvXK
         Gc/0me4V+HV2nHBKbJMTMje9m4F8o5OzbpjBt5ExVYtUbWNtLzG4pS2MwtkYpqvlMQqo
         TaWeve2MXASHAcMlehwfB9TeMtKNw3xN8PvXtOBa2wFT2/wpYCMNe4/4iR4hBhr/OFUx
         3q/TUw2lbygym6N3ZZRCFk9I7YsiIAXvGeq+P/jn7fzKWMc5W6drVPlM2g6P4n2d1NG5
         1amw==
X-Forwarded-Encrypted: i=1; AL+hErHEOeUngYMisRuIfBd6Ki6IE8uHOJRgLXuzLq8BOx6jMvudoZ96ycN4bTm4R5ddTZuM4Ut7+N/AjA==@kvack.org
X-Gm-Message-State: APuU4Z8J61o3FI5JalVgW0PuyKstR3gORHcTPuvOT9AsHfNFDpSb4Zl6
	qRnPd8k2TOMIaTmR3bDxTLYbYfNeRVi97O3t/FDNEaRPy1j3gMH+EBvuuP080S7zhvyBq56lfzA
	T7vM+znwBECE/FROp/2lQtRq8DOeLC/ioZk2or0OMUK41wxNrwP4vEw==
X-Gm-Gg: AYBFou3NFzk5McIYo4cEqwlZxpaQirHlzdzw33LP15BgxiWaf8VbaiIAbTj1euH7dwr
	nWRQNhOEpQTSwIJRwPbxyyRNizKN7JMhXIUvSm2YYME6ltme8CC4vqfVc4EcG8jh0EtJatCWnHK
	bKPz2bhSHjKZ1PW6iFajL8xge74xXpKnJ1LfCSE3LOBFMDzmbC7hFK5q+G96HIq8jRzL29YfSlA
	vjiAEIDGtYrqCA54IzoavGLFi6TeAp2gUThHtM/Mbzh45iRfP5Y2qPIeZRsf9LpRaulGxnjXTor
	1qcEi1+kIR0HMmGnfw5pOC+CF6hiD89Lv3+q9QavRzZqsUabe1mf7VM/itX0HMZtfHKP7HmqQ0e
	Eyuy/E+AY6MUEyg3NbUt551X4lYcWSTW4l8XEzBkr/1KI7KXnVIt5zNNytCO4SeQr/ii4zqMcB4
	5n4vr6RaaIZZ5y757mZNzVVAl2HUKv7Jm0LhfaWRIlVAKdEnhYW5nAjQ3elytQL47/NE94f3IVE
	g==
X-Received: by 2002:a05:7301:7c0b:b0:370:7fee:497f with SMTP id 5a478bee46e88-370f8269e21mr1593309eec.26.1794019187392;
        Fri, 06 Nov 2026 18:39:47 -0800 (PST)
X-Received: by 2002:a05:7301:7c0b:b0:370:7fee:497f with SMTP id 5a478bee46e88-370f8269e21mr1593255eec.26.1794019186655;
        Fri, 06 Nov 2026 18:39:46 -0800 (PST)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faac86a96sm11069040eec.29.2026.11.06.18.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 18:39:46 -0800 (PST)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org
Cc: Alexandre Ghiti <alex@ghiti.fr>, Jesse Taube <jtaubepe@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: [PATCH v8 2/8] riscv: Add breakpoint and watchpoint test for riscv
Date: Sat,  7 Nov 2026 08:09:11 +0530
Message-ID: <20261107023917.40606-3-himanshu.chauhan@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261107023917.40606-1-himanshu.chauhan@oss.qualcomm.com>
References: <20261107023917.40606-1-himanshu.chauhan@oss.qualcomm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: QusTlS7lThHvoWh5PWwP4YMwPh4L-FUT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDAxMCBTYWx0ZWRfX7nS1VXQfjMqj
 eDe2835RVulCwXdrawjns+8yKkiPVjbgmsMcALVrzOX8M3IVtYHOz6dg6fAas2/2GdIvoZ7srAq
 JeRCeh94SefIawsaTsSk2gPBqaqlMe7OIY7j5vvuT2jyOlQwNN8RVZZBPUpJ7/6bOZr1TogYfNq
 dSta8Vrrv6hPXw4U5niwBnB3r1juFHlhUyILhQVsaOKzmpuJqZx23dABZuJi9q2aPzbQyZPS36g
 ueHfNsY4ubZJrAgducmBt2D/EAJshA7VFcyW9gLxSWngRA9MNvWoY2JpAnLdUaW4UZyj2pMXzXm
 Ydby7CZdb1Jedj3gU+gl0Lcs5dXY5gOSRlmMZ6QS4+h1OqS1cz1V4jgtTpLEBRGk2+mtBtjgE6x
 /CxTG+lDR/nM3VfZuOkH+DeLZu+igLTUqu1sUSW5h2GQHpa19oCqTWt6K9Gh9YAh1e4t3mN9rIS
 YmPX6wBLot11d1iZz6Q==
X-Proofpoint-ORIG-GUID: QusTlS7lThHvoWh5PWwP4YMwPh4L-FUT
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDAxMCBTYWx0ZWRfX3n0499UZsjax
 8fSwZMrm460YFw1ZksY0uVGuFjmkpBSKVxKE2ahk9mgSZiaqh2B8eK8+6GRy2zcBuaEM0FHlcCN
 4XSdHR8jQnGcOlsYApjMDQ6PGZbknLg=
X-Authority-Analysis: v=2.4 cv=JtBkP84C c=1 sm=1 tr=0 ts=6aee8f74 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=2Ls8_GQA_paks6FoIQwA:9 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_01,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070010
X-Rspamd-Server: rspam06
X-Stat-Signature: tjobwomgyr6tnaoh7hokeed48wiz8n3z
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 94370C0005
X-Rspam-User: 
X-HE-Tag: 1794019189-32516
X-HE-Meta: U2FsdGVkX1+1A8PBT5rkuc0Bzv1cXQ+KZDJuYE7joNPOofpuQROnTXBYwWqDJqSLAjHHWAKBuKVCofUOjhBGaGVrluyNf3PXcisLVzsbhvCO2yy5/NjTqniki+u4RWO60844rxsp+9CApH0gI80V7jXUrre6scQr/HrReijsUr7iJo6D9L8yrsIunrpUKWV3hPQRfC7056RnBLfEESKzf3ASor6lYDaB/qZR2if1vhtjj/UqX+mY0VbW0MGLhJNRvanv6/tQkkcwmbW4sJ3IO93pOsQidt4RvUtWQxex0jdZ34C2+aeml3PXG0t7NXXrN5qbx5N/4UJ4Mpm4gkS4QTlhFtKcjlVEQtAk5ehGTKuMOT4XiAsyGTdZwmUvuiz8S5it1iNo+EuLDiiiSh9p2RoRMI6XRfFF/Ir2uS3WghIasTfZdcXbsD799oJ2rzdGJ5t88+NQROsRBUMPLbI3cE5rgla5OTjcrbs9YeEJc91bFXJIMAQRUejlzxJkYXKVDp5Hax6HIpQDwPa/gQvFZvekBQ/EODUefjzQGf73Rq2vaiq/k9/YPr10Tt41wS9ZNKGMkfC3o/hSwcc/+txiijPli/mJW+KbMXp074tJIXirnd3velDV53EggiugWXOOmf/0Xnn2otiQVP//jrl06JH+DPCT1JK7XT6Qf6LIP77q/xMVY028ZoxPuM6nO5J0JHM+r1mEyDog2SkJysmCcubsYeG6NQe5jw77KyxG5gROFNKmHvH1jrX+sUdRvey4EKxUTsa/eK32fpGJV+dq1b9dl6iIvqqTD2lBZ76CBTFOT7dhBCYrqQYxK+HFWcSOthhYNR8YLngOlFxxsRJq0TQMVBwJqN5jgj/5MSTJdXwduUZmy4/pAqgMPH5Xc/+HxurM6kVlw016wUff1N/cKAMlJIDeJwFYUQ+cmay1OwcKIzpQSVjqlTwSGZXCHvRHkaijcLTfGQYZOMu9HVq
 JQr+l3rR
 BTA8lzAqLu8G5Fbo6taHS0KZgvG6bLG5qB/zqKBUxKCKOISK+N1QAmUHiE62vDOt/Ss0hvaXtZ7Z31VorrkF6FKX2lKCR6vqQ9TcXijmgmdq/FdX7WmEDE86KOeC+HsBHp6KKjcLd5ibtzZTk1WrjP8kaR6FP0Yl988hxdI5/+R+Hb8PY2si3IwhgmkqvP7wI3G4ObrmtYFzHTezr5AnsEdTHQ0pz24WPSnW5Z4wbicyGRBCRNo7qQL8upCtLZ/IVu0SQL3cJ0/ohd6srZzK3XzwBv9cuynDuN7aMz1lsM+HT5heZNr2vzp7RGFaiFXGc2iHikqwoj6HCCQxhYXdyPkPQnA/6rQpiGSZZrh7ytulpiKpxp4E0/wIfQ5IYeuRoWmLKIQx0DZChhdiU8IWy39xufDcGIHeVL77iDpomh7DjKPDD2fRhrWJt7bl6TW/6wK0Y67jzpYW8cnY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add self test for riscv architecture. It uses ptrace to ptrace framework
to set/unset break/watchpoint and uses signals to check triggers.

Also add $(KHDR_INCLUDES) to CFLAGS for the riscv test build so the
UAPI headers exercised by the test can be located during compilation.

Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
---
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/breakpoints/Makefile  |   8 +
 .../breakpoints/breakpoint_test_riscv.c       | 215 ++++++++++++++++++
 3 files changed, 224 insertions(+)
 create mode 100644 tools/testing/selftests/breakpoints/breakpoint_test_riscv.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 73b69e8dcba1..baf97e8c39f6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24171,6 +24171,7 @@ F:	arch/riscv/include/asm/perf_event.h
 F:	arch/riscv/kernel/hw_breakpoint.c
 F:	arch/riscv/kernel/perf_*
 F:	drivers/perf/
+F:	tools/testing/selftests/breakpoints/breakpoint_test_riscv.c
 
 RISC-V SPACEMIT SoC Support
 M:	Yixun Lan <dlan@kernel.org>
diff --git a/tools/testing/selftests/breakpoints/Makefile b/tools/testing/selftests/breakpoints/Makefile
index 0b8f5acf7c78..1f28f50e8f85 100644
--- a/tools/testing/selftests/breakpoints/Makefile
+++ b/tools/testing/selftests/breakpoints/Makefile
@@ -12,5 +12,13 @@ ifneq (,$(filter $(ARCH),aarch64 arm64))
 TEST_GEN_PROGS += breakpoint_test_arm64
 endif
 
+ifneq (,$(filter $(ARCH),riscv riscv64))
+TEST_GEN_PROGS += breakpoint_test_riscv
+endif
+
 include ../lib.mk
 
+ifneq (,$(filter $(ARCH),riscv riscv64))
+$(OUTPUT)/breakpoint_test_riscv: CFLAGS += -static $(KHDR_INCLUDES)
+endif
+
diff --git a/tools/testing/selftests/breakpoints/breakpoint_test_riscv.c b/tools/testing/selftests/breakpoints/breakpoint_test_riscv.c
new file mode 100644
index 000000000000..a8a94a788142
--- /dev/null
+++ b/tools/testing/selftests/breakpoints/breakpoint_test_riscv.c
@@ -0,0 +1,215 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 Qualcomm Technologies, Inc.
+ *
+ * Author: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
+ */
+
+#define _GNU_SOURCE
+#include <linux/perf_event.h>    /* Definition of PERF_* constants */
+#include <linux/hw_breakpoint.h> /* Definition of HW_* constants */
+#include <sys/syscall.h>         /* Definition of SYS_* constants */
+#include <unistd.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/ioctl.h>
+#include <time.h>
+#include <fcntl.h>
+#include <signal.h>
+#include <sys/mman.h>
+#include <string.h>
+#include <semaphore.h>
+#include <errno.h>
+
+static int gfd;
+sem_t ib_mtx, wp_mtx;
+static int bp_triggered, wp_triggered;
+static int test_func_sink;
+static const int wait_timeout_sec = 5;
+
+int setup_bp(bool is_x, void *addr, int sig)
+{
+	struct perf_event_attr pe;
+	int fd;
+
+	memset(&pe, 0, sizeof(struct perf_event_attr));
+	pe.type = PERF_TYPE_BREAKPOINT;
+	pe.size = sizeof(struct perf_event_attr);
+
+	pe.config = 0;
+	pe.bp_type = is_x ? HW_BREAKPOINT_X : HW_BREAKPOINT_W;
+	pe.bp_addr = (unsigned long)addr;
+	pe.bp_len = sizeof(long);
+
+	pe.sample_period = 1;
+	pe.sample_type = PERF_SAMPLE_IP;
+	pe.wakeup_events = 1;
+
+	pe.disabled = 1;
+	pe.exclude_kernel = 1;
+	pe.exclude_hv = 1;
+
+	fd = syscall(SYS_perf_event_open, &pe, 0, -1, -1, 0);
+	if (fd < 0) {
+		printf("Failed to open event: %llx\n", pe.config);
+		return -1;
+	}
+
+	fcntl(fd, F_SETFL, O_RDWR | O_NONBLOCK | O_ASYNC);
+	fcntl(fd, F_SETSIG, sig);
+	fcntl(fd, F_SETOWN, getpid());
+
+	ioctl(fd, PERF_EVENT_IOC_RESET, 0);
+
+	return fd;
+}
+
+static void sig_handler_bp(int signum, siginfo_t *oh, void *uc)
+{
+	int ret;
+
+	bp_triggered++;
+
+	printf("Breakpoint triggered!\n");
+	ioctl(gfd, PERF_EVENT_IOC_DISABLE, 0);
+	ret = sem_post(&ib_mtx);
+	if (ret) {
+		printf("Failed to report BP success\n");
+		return;
+	}
+}
+
+static void sig_handler_wp(int signum, siginfo_t *oh, void *uc)
+{
+	int ret;
+
+	printf("Watchpoint triggered!\n");
+	ioctl(gfd, PERF_EVENT_IOC_DISABLE, 0);
+	wp_triggered++;
+
+	ret = sem_post(&wp_mtx);
+
+	if (ret) {
+		printf("Failed to report WP success\n");
+		return;
+	}
+}
+
+/*
+ * Keep a real instruction address for HW execute breakpoints: prevent inlining
+ * and force a visible side effect so the function can't be optimized away.
+ */
+static __attribute_noinline__ void test_func(void)
+{
+	test_func_sink++;
+	__asm__ __volatile__("" : : "g" (test_func_sink));
+}
+
+static int trigger_bp(void)
+{
+	struct sigaction sa;
+
+	memset(&sa, 0, sizeof(struct sigaction));
+	sa.sa_sigaction = (void *)sig_handler_bp;
+	sa.sa_flags = SA_SIGINFO;
+
+	if (sigaction(SIGIO, &sa, NULL) < 0) {
+		printf("Failed to setup signal handler\n");
+		return -1;
+	}
+
+	gfd = setup_bp(1, test_func, SIGIO);
+
+	if (gfd < 0) {
+		printf("Failed to setup breakpoint.\n");
+		return -1;
+	}
+
+	ioctl(gfd, PERF_EVENT_IOC_ENABLE, 0);
+
+	test_func();
+
+	ioctl(gfd, PERF_EVENT_IOC_DISABLE, 0);
+
+	close(gfd);
+
+	return 0;
+}
+
+static int trigger_wp(void)
+{
+	struct sigaction sa;
+	unsigned long test_data;
+
+	memset(&sa, 0, sizeof(struct sigaction));
+	sa.sa_sigaction = (void *)sig_handler_wp;
+	sa.sa_flags = SA_SIGINFO;
+
+	if (sigaction(SIGUSR1, &sa, NULL) < 0) {
+		printf("Failed to setup signal handler\n");
+		return -1;
+	}
+
+	gfd = setup_bp(0, &test_data, SIGUSR1);
+
+	if (gfd < 0) {
+		printf("Failed to setup watchpoint\n");
+		return -1;
+	}
+
+	ioctl(gfd, PERF_EVENT_IOC_ENABLE, 0);
+	test_data = 0xdeadbeef;
+	ioctl(gfd, PERF_EVENT_IOC_DISABLE, 0);
+
+	return 0;
+}
+
+static int wait_event(sem_t *sem, const char *name)
+{
+	struct timespec ts;
+
+	if (clock_gettime(CLOCK_REALTIME, &ts)) {
+		printf("%s: Failed to get current time\n", name);
+		return -1;
+	}
+
+	/*
+	 * Deadlock fix: avoid blocking forever on sem_wait() if the breakpoint/
+	 * watchpoint signal never arrives. Use a bounded wait and fail the test
+	 * on timeout instead.
+	 */
+	ts.tv_sec += wait_timeout_sec;
+	if (!sem_timedwait(sem, &ts))
+		return 0;
+
+	if (errno == ETIMEDOUT)
+		printf("%s: Timed out waiting for event\n", name);
+	else
+		printf("%s: sem_timedwait() failed with %d\n", name, errno);
+
+	return -1;
+}
+
+int main(int argc, char *argv[])
+{
+	sem_init(&ib_mtx, 0, 0);
+	if (trigger_bp() < 0)
+		return -1;
+	if (wait_event(&ib_mtx, "Breakpoint") < 0)
+		return -1;
+
+	if (bp_triggered)
+		printf("Breakpoint test passed!\n");
+
+	sem_init(&wp_mtx, 0, 0);
+	if (trigger_wp() < 0)
+		return -1;
+	if (wait_event(&wp_mtx, "Watchpoint") < 0)
+		return -1;
+
+	if (wp_triggered)
+		printf("Watchpoint test passed!\n");
+
+	return 0;
+}
-- 
2.43.0


