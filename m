Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9F30D4336A
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 09:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F13B6B0006; Fri, 12 Dec 2025 04:14:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A23F6B0007; Fri, 12 Dec 2025 04:14:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFABD6B0008; Fri, 12 Dec 2025 04:14:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1BE46B0006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:14:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8510A13515E
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:14:00 +0000 (UTC)
X-FDA: 84210257040.15.24555CB
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0B44A1A000C
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:13:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=SUefY2h+;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765530837; a=rsa-sha256;
	cv=none;
	b=Neuj0uk8scLmozxfEeZIUKqFmvQ1nO30wT26tnyiUL6PKjOcTa7rzQzAesr/d7D2ua43PZ
	ljwpEfMs0cS5DE+XBAE5XIV61qGh8DXiuBjE4jyb6yYudfTqp9itNf5XvJLNVo60wJD1XJ
	KEbrGEP2Y3EoyrKng5E8PRS4y6IJuQk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=SUefY2h+;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765530837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s1cTPmb/E3ED4jNPhT8P6htYkPi/ZEzeet04bZUSBAw=;
	b=hDqHBruV9KIndnwCtVD+sRYwvpGdBrkn+VQmEDjQzpQwBInFnP93y72KjnpV6goDC4GZwx
	FItonjRyrPhVcYzxhVCDUyERvCzBALQTLOnRJFqQQENkKFECm9vPD6dCjrc5mVhdPvB51P
	+J2wYeGknn0eKroFnF1jtdoDxFlhoNc=
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BC90Ysh2432569
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:13:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=s1cT
	Pmb/E3ED4jNPhT8P6htYkPi/ZEzeet04bZUSBAw=; b=SUefY2h+X+0yV5h9UDKf
	0L/P4l74lqkcaH0AfwtOqJvXh9ZG/pfMqujyu20Ftb4CVkk6J+1RC5lzd9o/25I7
	fafQTEqH0vIvoUHqBkOKBZOgxQSWiutsZbsGEEKnx3mWq2jPLYlqCkRceS1YyRQs
	6g+X+xm/foRjPN1An4/Lpo+e+BGfMfvGzU/WvYaNR55GBetwqVHOkFHWJL6C+L/i
	xIbtfsofl5qhY4V7kRx8weBnBodlUlQmyC1YbISzVWba6/k+IHT3+9DdGcUoVM84
	jAXmn+5ZSw1Q3dt6e0NbHq7BY6R6NB0whQVK70XDP1g3sMkwKKK2VeUN40FVUItt
	BQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4b023bwfus-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:13:55 -0500 (EST)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-29f26fc6476so6932835ad.1
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 01:13:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765530835; x=1766135635;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=s1cTPmb/E3ED4jNPhT8P6htYkPi/ZEzeet04bZUSBAw=;
        b=bqapZ108UzrnrBc+T1WRNUx5C9xnEzHjzFZIxRXY+Tutpl55FnXkmjm6RQNhNPA8me
         rawfYuZJViD5pEACl/3dZrDTmdS/DXdEaEle2lQvOxDWXgoRkcHxbTHVidqJUFPZHdKv
         bsI2Pok9SGOb1rdg3uvEAy7VBT/kBPZeot80P0xWvhwgQM/mQjIXo10sMGQQcHBE+jMl
         qkvRoS9UGv9Yf4/r9ujYrKagg17thvhWSyIr5IHl29Q+qwa6xelGtO77kauf3u5frW0r
         EFZ+Vx+ItA8+0zLZZctKx7ZINMIifTau3rIcbU+NHPIQCuAvyS0Q0VRl7uiFEmPRG9+H
         PLsg==
X-Forwarded-Encrypted: i=1; AJvYcCX67bCk2Y5yf44fW+rhRmSnahcNEY4fiJcwgiq8MAbiMaZzGNEh9bW7nYCtjI906YcezVmomqkEEg==@kvack.org
X-Gm-Message-State: AOJu0Yw5RJAscIFkfisFBTrILrFP6Ar7b+kWRH2yv185a+14JOrY4Uau
	zFy8ipR6K21sJuQx5XA4oFE9oDRiYoa1EaVdcIZs0yup83/xi2PN0gWpCwVbl5gmbWBX/5ISUGe
	T7adXYW76EmgIm5uHnUO5+sTgsHxt0kAQ4ESRJI+CreZe+uyE
X-Gm-Gg: AY/fxX4FMPqStoGe+rWaK5kObgS5hHnwJn9SCToYOyaTbTZx/8rXsWYF4BcZLVLNkbm
	dq+KhDsoYHN6ngzSdIjWizX3arNzWm03ggFu92QhH8/9fow7OEE2wBwJ+FHuoEzH3peMCTj0eK/
	sfZoE8sGGqcQ1GMfF+Gub6CFv8UVS3ZkJ3YnhanxQuJgN5Mxo6SD3k88VD5haMs75bWBOiQkHIN
	Dbj7979zsRyOGb5Ko37bAwfhtiXvdPvq0Dk1LHn8U2Yf4knqELuAlG1wdxqZiKsEqBXOCDJZgjy
	xwUnG8jdfKfCL6LDOwJ/8xB13m2h2ZUj+h3ScWB5DJm9Mpy5itPC6Glkt1qnZrXsUrT9Loz9l81
	daAlcAQC2ujra3u6zfSHkNIP+w2I4x+fwHqs+CiWEqabINlAge2kredQ5
X-Received: by 2002:a17:902:e80f:b0:297:e66a:2065 with SMTP id d9443c01a7336-29f244bcf85mr18583025ad.56.1765530834989;
        Fri, 12 Dec 2025 01:13:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHwvOAURq/suPyQQI1KUWuzlf+xBV7BfHZ9tWHXTmC5W67Xs98SEZvrSF3mE+NsgMan4KBjtg==
X-Received: by 2002:a17:902:e80f:b0:297:e66a:2065 with SMTP id d9443c01a7336-29f244bcf85mr18582605ad.56.1765530834512;
        Fri, 12 Dec 2025 01:13:54 -0800 (PST)
Received: from [127.0.1.1] (p99250-ipoefx.ipoe.ocn.ne.jp. [153.246.134.249])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea016e57sm48497255ad.63.2025.12.12.01.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 01:13:54 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Fri, 12 Dec 2025 04:08:07 -0500
Subject: [PATCH v2 1/2] x86/tlb/trace: Export the TLB_REMOTE_WRONG_CPU enum
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251212-tlb-trace-fix-v2-1-d322e0ad9b69@columbia.edu>
References: <20251212-tlb-trace-fix-v2-0-d322e0ad9b69@columbia.edu>
In-Reply-To: <20251212-tlb-trace-fix-v2-0-d322e0ad9b69@columbia.edu>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@surriel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        x86@kernel.org, Will Deacon <will@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
        Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        David Hildenbrand <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>,
        David Hildenbrand <david@kernel.org>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765530499; l=1293;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=3RXsGKqukvEhsXy2ryEgjMGzkVB8QVOoAFGKjU+lkAo=;
 b=u8Ap52Jd1shp/j5YC1M4uPMvXwfjjDYnAsVA6o3090sKSZmF8nxXTd4XMzAAufSFFftag/Sds
 I9zmJSMnLejCrmyrOBBN0KHmXvL13pBcYyuqAhhaNXDrChF9WQe589R
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: ZLmTLNLMlX-4iwBGho12tB1uMoRYkuoz
X-Authority-Analysis: v=2.4 cv=ca3fb3DM c=1 sm=1 tr=0 ts=693bdcd3 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=gC7H+NTNV8TiHuUi9Bl0tg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8
 a=fwyzoN0nAAAA:8 a=tN_j7I10ly-BD7A3SNgA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22 a=2JgSa4NbpEOStq-L5dxp:22 a=Sc3RvPAMVtkGz6dGeUiH:22
X-Proofpoint-ORIG-GUID: ZLmTLNLMlX-4iwBGho12tB1uMoRYkuoz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEyMDA2OSBTYWx0ZWRfX2TsGUEhTXW0B
 0qQF22xbKIxLu/Hq0upOKJLL9SZRfv2nXG+Ju3QK0QKosBp/IaoYy1aVVm8kB35CdmX6PL83Su5
 eb5aN/G3bWbB1uN7Nss5fleRNiNBEeZT8/xfsQsP2W9iSpoPEoqJvPql33hNHZkc0HU41FvMpfG
 Jds7R8/nIj2v+kOeFgkPWqfFsqT/IRJgMRKMcOmklN8zQkeyISzGbWEF6yEhOP2Q42Qyjzkq8Es
 CRtC43c90kJ86qTOMgP33/9sCf2XI7FoTvyJJaCn9IazgkAbkF9+ctglMxTKnPE9dyVdv2Ly/WS
 RNrT8UYAOGtVnd76Mju8fu9xN7FWUOjH0FarUibvc7ssnnKxGNnkREX0g6mgFrwDXyrv7ZQkrNj
 OYLAP5cd0wiecgHcr30nJ+nuv17/8A==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11639
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=10 spamscore=0 clxscore=1011 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512120069
X-Rspamd-Queue-Id: 0B44A1A000C
X-Rspamd-Server: rspam03
X-Stat-Signature: e9cyhb3aeq18q1ge6gw34w5jhynga659
X-Rspam-User: 
X-HE-Tag: 1765530836-780031
X-HE-Meta: U2FsdGVkX1+Zl4gnzzfD9CLdbhgl8JGeqJ9drC2885m1/XH7rh5xemRfEZONDElmKwah3WwwO38bMzGgAoBRjijpOLdnMnDZCOdf9hR0QNwSpQsCIcSLPF+OPU7kF51h4tqlOrUmqfD8RDqWCt09EH4l4PzTTnYs0e6e8L9AW9bC2Dx3cuvb/UOj3GxOK29CPtxhUSCl7IbxNWM+FrM6AvVURJcsmCktgZGcdjwm5kms4OTmhQghX0SHZdJ5/b7+ZUNzXslMZymuT7ujzQfkLy6T9hWg4qw5aa19pTe1KDcybfJxv4LPPGSJb3hiNW0RLBEBX6p1cBQgwz1JrfRezbk4STWk/YcEB3Bb2bRDzQ/au6R8Vw5x8+NCNDcFokKZ8bqbYH4wyduFgvRwm2TeNsTzTeQmEJbPW6a3456P2Zb4MJpARzzt/TUxHNGdIjrJ6rjILDEFh6Cm8BSXKK/8t0Is+32a0ECvA6OXFfyFJaeHUmUeZTxMU7QWLEsFBrALbMuO6xSyZEo5vKDHOop4DVdLGSxe2Z5lQhi5SONNcrjOaVO7yjOBrI5hV/7PTP5RVq1PHQt36kV8QTSnnK+4uc8dpjRe440IggvRbkV/8lK+geisJ5xlUpKZNTvmHVfsR+yP/yzxUl8DSlTuqNeLhM/lXKfIa5l62tiqXJ45oi52cY6wG5VMl3tpz7l7pp3LYcmceJhtdOWaVa42Qh+dq4ddQ73iLECNaQeEf2qqyP3WpU+3AVI0eaLJbjzjCor+7pvG/IQvIHAx6xNF+xcuiWFKptmKD73A0G6r5j2z0MImiAoZonu1mlYyLucLjarwmNtgo5/1vpz6DZGExrXa9xWDo3HXDGUvty2z/ToBofg1JCMWtU4V3ZSGdaYJfUCEjkMzu+3OdJDfkQcySYGIH3GZPv8h/Y1l9YFBhdkVz/nZf2MqLx68TzPhcmwW0P12Qx8B5jlruZuKOWSDaRW
 dVoiV3Qb
 39/+73bbdr+pJSKx4BOJaIPmilGchbZ3DjgBpXiTqsHliQjFmtH7b/YQdOt7r/TIafHgYiAsGRe9BFqPTE4a0KIwtrN+7k4z7VbkeL4Cc+W2VOptlukXqynykHKvenBn2yWPQW2frMytGfhVF3U0JqjPSG99KIXKoFLyFogO7z8meX+i9W+j/MH+Kw2BlHz+iwu/kB0bf6NWPK6uC6YPMasUp8PWwj6ByxC+i/NGjMgiVjP/Q+ujhZlDN8qzHyoNBHytJvjtzuAHseVxh0IKanCT2s5ArNghTTd0H14cpb9g//pc6rRfbHuEaBvJfh52yzD5D3Nl5z8uBBZWtEVqNmvL8wtAHsh5OTbnd4r9BReNss5KXMYyNP24xF2Rhn0dLtM6VBNnytgBnWQDKG1lzNhlnB+ptZy9BRUhO5kH/sVPIeK8iCE99M6Pqo2HB1w4NwP+1lLHVreH26m0XGvwoiycxrfHUjpAtQTF+hOxRlix7h57i6boReVzQHciTJW4yi2sdqX4YYB9A2sLXKUssHm/d6+ONKCZnL7F4znOJQ7hb2BoXOQwH3k5Ir3ib6yyyjt8oW6SblS9GdcdRY5hyMtdxmIlVEUMwuHt+6cDxRcWHODM2hQCN4+1r6sB5tyz3TVpmZ7yDvNJ868U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the TLB_REMOTE_WRONG_CPU enum was introduced for the tlb_flush
tracepoint, the enum was not exported to userspace. Add it to the
appropriate macro definition to enable parsing by userspace tools, as
per [0].

[0] Link: https://lore.kernel.org/all/20150403013802.220157513@goodmis.org

Fixes: 2815a56e4b72 ("x86/mm/tlb: Add tracepoint for TLB flush IPI to stale CPU")
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/trace/events/tlb.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/tlb.h b/include/trace/events/tlb.h
index b4d8e7dc38f8..725a75720a23 100644
--- a/include/trace/events/tlb.h
+++ b/include/trace/events/tlb.h
@@ -13,7 +13,8 @@
 	EM(  TLB_REMOTE_SHOOTDOWN,	"remote shootdown" )		\
 	EM(  TLB_LOCAL_SHOOTDOWN,	"local shootdown" )		\
 	EM(  TLB_LOCAL_MM_SHOOTDOWN,	"local mm shootdown" )		\
-	EMe( TLB_REMOTE_SEND_IPI,	"remote ipi send" )
+	EM(  TLB_REMOTE_SEND_IPI,	"remote ipi send" )		\
+	EMe( TLB_REMOTE_WRONG_CPU,	"remote wrong CPU" )
 
 /*
  * First define the enums in TLB_FLUSH_REASON to be exported to userspace

-- 
2.39.5


