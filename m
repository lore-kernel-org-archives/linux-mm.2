Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE44606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=L1gmG5pY;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KK3HPOu5
Received: by kanga.kvack.org (Postfix)
	id C75856B05CC; Fri,  6 Nov 2026 21:40:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4CB86B05CD; Fri,  6 Nov 2026 21:40:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14666B05CE; Fri,  6 Nov 2026 21:40:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7EDA06B05CC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:40:30 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E192C025C
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:40:30 +0000 (UTC)
X-FDA: 85406769420.03.37C945B
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id A9A8C180003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:40:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=L1gmG5pY;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=KK3HPOu5;
	dmarc=pass (policy=none) header.from=oss.qualcomm.com;
	spf=pass (imf16.hostedemail.com: domain of himanshu.chauhan@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=himanshu.chauhan@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794019227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxv5EqtnYWUCOVJkYUviHmwxoOD0vd5Ri8oexCtFYW4=;
	b=pbl8QiVVg5tbOHxKFF20MLndJ6pllr+ebxtw3hitf/e1Lse6jA3QNFlQfcO6ppLYVUYiDz
	HAnGvrd9L+NW2q0qx3zQ4ICfco1Pu2GBus8Cf6QpZE3F8fGz6QrIihF56Lj79Pi226r7nm
	9+33C9sVugJDg3ftoM/cCW/FBi4MOS0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794019227;
	b=JImpnWlYgo77zlskxDuK+Ocp3uylRCM5aRZzq6xUbnMTCBg2f9UV9kPoTO1IU3zY/aLGD6
	ujatgRjBoGUKcGsAn07S/+Nqot+05f09pe6OjW7k39HdEXaoO7VdKZzgH2pyLt378skv+k
	hX996Oi9W7MwUUrypRfzgcA68sFs8bo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=L1gmG5pY;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=KK3HPOu5;
	dmarc=pass (policy=none) header.from=oss.qualcomm.com;
	spf=pass (imf16.hostedemail.com: domain of himanshu.chauhan@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=himanshu.chauhan@oss.qualcomm.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A72B3Pr1537656
	for <linux-mm@kvack.org>; Sat, 7 Nov 2026 02:40:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=sxv5EqtnYWU
	COVJkYUviHmwxoOD0vd5Ri8oexCtFYW4=; b=L1gmG5pYYAgjaDrzkHaVi16Gsq6
	/LL/bdPzdAX+2q1kcDuvVuYbcHTP9YzU9jn16oZISlObiwgRlIxwbZW9kJI9vQUj
	WVGtlB3lCpDLs2sRw5F137AbZn8tqtHCfw1DoysxFjVKjoM/HCiWHUnWVF9YvRF8
	q4DeiWs7kiZTohtW0hA9dT/QPrJnvSPDnMNQDBD8/F2eKDk448Wx6S3wG7/cBwSs
	IO/cNrdrg8zXPxmdC79q77wGkr5uVdPkdfVXICkT9OltUFRUPjMJ3fchFLYcaMa7
	ZUltcETQFkaXmYGOJNKXt7SiZ6PyJs2iYJLoKbueD3CNUN5AosrUJ+Nol9A==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hsn03s6b6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 07 Nov 2026 02:40:26 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso2313167eec.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794019226; x=1794624026; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sxv5EqtnYWUCOVJkYUviHmwxoOD0vd5Ri8oexCtFYW4=;
        b=KK3HPOu5DZKnnU4XU1cXPyB+SRxJXZjU5Ql3u9DrO09hn8DHJjOhO5UIgtFUL1OqTR
         Xr/F08PGabVy7oeN0Q4TozxspublG+tA9ljYHYzZuitL5fnb/SZNxQRhlOu7qW6BiRji
         fycYF4bkjgB7SO9WlYwd1SVJfpXnynoot2XeKip/kcPiTEeSrI0dSzP5HTnrYcyo9wxG
         12LUVi85ygZQx+9ZttcRBm3CJhRZr+maeVgmQ3FKE4VFnuPDc/QmmDg356Ee22Z1YPB/
         xPKmhDBZpeeON0ypz6C4aGacmDeUdukYFUOViYhpmI/u0o8jNSpLx4GSzHpr5UUQc4kw
         vTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794019226; x=1794624026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sxv5EqtnYWUCOVJkYUviHmwxoOD0vd5Ri8oexCtFYW4=;
        b=DOjO2rOP0geHapcVBb4hZM/rrWSXHyJttVvDCkPlV4byaNkE44Url2kaiavD//x+s4
         HQALqC/d332y9W93gsdsfvrdrFiGlgfcRqm60jsZZ3Vrg4boD9c595ZPLqvvv/oQ0P2D
         G5RlPPy7RYhUzPJ2W736vZkJVS7g9p7pMGleOfPUz1LQ04TN2eRGQPUf/NdlPCiMUZAM
         ms/6dD7jQ/kcXBm5TW25rKWy0sWebMO8A1TsC2Z75kfNkNDJ+zXMrcrspNgTwUJomapc
         AGiPj5SmwCL7kLMR/PhtTmoxlXjmNcKyjuZh9Lxobq0agmOh7JjSpTp0qW0QbYkFtajb
         tFYQ==
X-Forwarded-Encrypted: i=1; AKwUvByrTzlR/DUf8LzrWfkhHpBknsAWt6xUz7B50uhym1E54Z5ONsNsNb4/CP2v7oNR6dMzbt92KxcCSQ==@kvack.org
X-Gm-Message-State: APuU4Z9Dm07U8pqwfLg/Z+hETZnZwCL2o5mciaEOqN2kbE5pMyeQ0U6l
	mxE9nb3bA7Yc1yGnrc2/TgNmT/YNcC9S5Kgx3j/AvQLEmIZd3uU+N8zECMiAQesq7dGH3RCE6am
	UByqQ5KwZ0geYSI9iiqCHz7Vx6WafFvKl68OubPr8LjzVH7SQPzE0xw==
X-Gm-Gg: AYBFou01jJmgrctwn/HDGBavTHAjUFMwWtXaINobxkQ9SWoaYn1KGX7uQfxGeIrJ0t/
	JusQMgN5GxjghZI9H49ZO/a0uhYQLFFI+pqly2E+KcpsC/rrV/MJy0UIJ+y9Trrc+z2KXiThPkC
	EPzuHYaGijvQ47GnTd/YELJegJNEkQXgeE8Nw5Zg6K8cic4jo5IPQZg7Wmpm9oyHRnpBlgL9pde
	SOSU1BjKtBaZeCLAwm0QhVJ17eOsJX25D6gHHSi5EYap7+yaIQR+szcUdsm9tuVvVSI4x02JA0U
	N1akD2tnsuhKn4EfHb9whIchqUKXcHI2oXYZjd7LEWA8/WUioMW7c8C9Z/eS6Mlam1xDU6rtfuU
	RuNm2NMskCp8PdwZufN0tlJx95LPMAKkrHaVpeoGch7sLSdmfDLjSvFG0BjIQ+3866kKbUQvCnA
	/tqGOXhw5SM6X0zmKljX5hWqLvaDFFWNBY8HUWu+iXMKrY221OTZeSSTLSFHRd0ywiVZeW4Hi/v
	A==
X-Received: by 2002:a05:7301:6190:20b0:36a:1089:9836 with SMTP id 5a478bee46e88-36f75839295mr5734774eec.15.1794019225406;
        Fri, 06 Nov 2026 18:40:25 -0800 (PST)
X-Received: by 2002:a05:7301:6190:20b0:36a:1089:9836 with SMTP id 5a478bee46e88-36f75839295mr5734715eec.15.1794019224581;
        Fri, 06 Nov 2026 18:40:24 -0800 (PST)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faac86a96sm11069040eec.29.2026.11.06.18.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 18:40:24 -0800 (PST)
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
Subject: [PATCH v8 7/8] riscv: Add software supported single stepping with mc/mc6 triggers
Date: Sat,  7 Nov 2026 08:09:16 +0530
Message-ID: <20261107023917.40606-8-himanshu.chauhan@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261107023917.40606-1-himanshu.chauhan@oss.qualcomm.com>
References: <20261107023917.40606-1-himanshu.chauhan@oss.qualcomm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=JMSuIMKb c=1 sm=1 tr=0 ts=6aee8f9a cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=m8l0dXrX7-G3mt2yGekA:9 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDAxMCBTYWx0ZWRfXxF35HmB8UE4r
 h+5LNlYdJOWi34KBTICYdUrsFWNIGQl/oiems5ByxZyJFWkglFvOdbNzyGj3NASFNCskHV8W54O
 gj+iaKpiGIqubDdlpERtb7RfPjm2gBs=
X-Proofpoint-ORIG-GUID: b2FgFz9FKntWfNMQSpoqZ1_BillsCDMl
X-Proofpoint-GUID: b2FgFz9FKntWfNMQSpoqZ1_BillsCDMl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDAxMCBTYWx0ZWRfX4xgVINU60Kl6
 ha7y19UJ/UYCtZhtcnN8L3J8f7iTCo3PctiS1wl+EkkMTnUqP31chsNiEdvw+KaiP1vcEhrgSoJ
 BZFTaMo8Dxjak5QDg/7IiuyEPzCOoFh9MkraNfVNBgvev2icA/IGCsYdccis4AOgLNz5D7zTyNG
 ymJGgjTCuF8R54VrcLVnMjQFq4QY8cqfn/+DFB0F4tuEXzV+kPJ2Lgb5Oy4q9iay9olVWQtoFn0
 MTAgjLSSuAK+s3ZjpRYwlyKzBw/jOcsnFFYquplTS3mMi+/8UJWoVN68ckRfyuYd3hA75iWhP7b
 90eSy15jFqf/ZSUM7ro7UtcmbUKfrN0ldmUG1e2kS4NeU5tWcBscITEU4NmbQ77ziso1Hn/NGYk
 36rR7Myt3flhEUpbMKClg96yIcVmDU50CGgZJWlaviZI4carI8SOZ2/8Io8aGkXtIqLws2VtpuO
 qyBzEIXCVObbpwMBlDg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_01,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 suspectscore=0 adultscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070010
X-Stat-Signature: xybu9j9y8w8w8soua1ufjbq6oosiu1x8
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A9A8C180003
X-HE-Tag: 1794019227-282612
X-HE-Meta: U2FsdGVkX1+JjGPoG9FPvLIXcbaFIGQnWbzw53fDoHgzuvWphjJ7whSBn0vyU4Y6AartADe8fWNTssykIJEBWef0SScarmJXQWa+VnjjdyFQMQ5EYTi0a94okanGlLcHGh4koJ9mwmT8FwPASujU9jYA81Z/mz2EtIK8MHVvI2wVItxC/7vH4Wb1evcNiCLkXWEEwjQ6lzv9amxG3pa9Rpsrs0jk1kmKHej9otA1flnBt08lS5UJw71uZhHUrjQx3WMFkjHGrgVbl43tmr7FWtMI+GYk1TtyfVxor/Vj9XKGyK8PnQYWwMMaxRRT1P745Jvv2PqWreT354CnRsrCKVymCngQV/Varooh+ZcY+ZXuOKI/nReAR/HGJCOuOpAzz4JUi/J0ezsdspLFCvAdPT+/HA5WE6ViI1we2b1fV31tdg7pJd+QK4V+QrkDyo9LczJbmKBE/W3mZnlNh9lfS4/0WyCRGS9VPRkoLQkCS5blmJgWvk31bB0pE3LFa9pFAFUsgYonYwIrjbaFYMn62EMtls0P/UBIi4PBhm4a7A0c51U2+VTT9WFQrI7KRjwEzUP2J8qgdZ8N+071xvOaETfV+JgzdWX95ImGe2qdB4vt0ib66ZXlr+52dSWNrb1Y8+intxC4Vp31mE3zgdKKHVrsjMsd1XFMRp7Wkf5Dx3rGtMLbT6Wb5w0lYEEzKvyz39UQKYGhYaGcPIReQlybiS0RBr3uzBvWdj1lev72wDKU/YqtjcvjpZjDZ7yOqDs0pzbltWqYxkcIovzHtYF4kb6Im6FEua8v7duTG1zcnqZ3+ODWuF07uzL485pG3hH1g6NuEjmdLQoc7oauppLzAy9nwOXd3puPgmDPpG7ar1UfbxRtNmUWgNNWnaQYBaW5SwQz7ex1ljhS5BJINSKXPyjSJygZEP18dYYQ8yX+QD1XP8iyDT/MyIPhRsG2JCKXLF9dKGeVBHrPScCKtVY
 hFc9JhWL
 fTOPcojUBAZzUP6tp7X+5pjCV61gU2ikFHzbAlv3xLb+Gx5dTgNn6wt1LNQxHkP99El6Deu7+B6VNKgG1qepABzh6L/bykSRut2KU8COQH0nXb/YSh3hn9iBDtOmVV+dF/Pm+i6iqf5VXM8HHeuen7NW0+hXqI84fYCjuUri9h8YX2uPfkENx8KnGlE/YBIqw3QGtpA4CMnrMKz0Tm8TNvdYqHduqFUPO8d2jWDugu6E3fLQ9XaFaFnBh5GPrtvbU3YipK/2O5UShOyJJjLJELpmZ26jvAqZr8Lymd+vCavUxftHIC6KO8qUWXtnSoNzlWCd1UnTUT/aTVBHUC/GyIwfDc9AvC1LQ6p/t/05z2fZmMqRT5YE7UtmCeVVYetX8gpYfkOa51DZrjm/7Es59IhZGJYbsBH9Z/KIViY/ifXz0BC9LBUZg1vZr2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With mc/mc6 triggers, after handling breakpoint at current pc, there
is no way to tell trigger to skip same breakpoint after the handler
returns. This can cause loop of breakpoints at the same address until
the trigger is disabled or uninstalled. Debugger may keep the breakpoints
enabled and if kernel disables it, there is a loss of state coherency.

To avoid the loop, software disables the current breakpoint, finds the
next instruction that would be executed after pc and puts a breakpoint
at that address. When this breakpoint hits, old breakpoint is reinstalled.

Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
---
 arch/riscv/include/asm/hw_breakpoint.h |  16 ++
 arch/riscv/kernel/hw_breakpoint.c      | 297 ++++++++++++++++++++++++-
 2 files changed, 308 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/hw_breakpoint.h b/arch/riscv/include/asm/hw_breakpoint.h
index 6e8913d69df2..b3ccebb5185e 100644
--- a/arch/riscv/include/asm/hw_breakpoint.h
+++ b/arch/riscv/include/asm/hw_breakpoint.h
@@ -15,10 +15,26 @@ struct task_struct;
 /* Maximum number of hardware breakpoints supported */
 #define RISCV_MAX_BP		16
 
+enum riscv_hw_bp_step_method {
+	RISCV_HW_BP_STEP_DISABLED,
+	RISCV_HW_BP_STEP_ICOUNT,
+	RISCV_HW_BP_STEP_SW,
+};
+
 struct arch_hw_breakpoint {
 	unsigned long address;
 	unsigned long len;
 	unsigned int type;
+
+	/*
+	 * Single-step callback state.  While step_method is enabled, the
+	 * hardware slot is temporarily programmed as either an icount trigger
+	 * or an execute trigger at next_addr, and the original trigger config
+	 * is restored when that temporary trigger fires.
+	 */
+	unsigned long next_addr;
+	enum riscv_hw_bp_step_method step_method;
+	bool pending_perf_event;
 	unsigned int match;
 	unsigned int chain;
 	unsigned int select;
diff --git a/arch/riscv/kernel/hw_breakpoint.c b/arch/riscv/kernel/hw_breakpoint.c
index 4231170d4901..72be50943937 100644
--- a/arch/riscv/kernel/hw_breakpoint.c
+++ b/arch/riscv/kernel/hw_breakpoint.c
@@ -15,6 +15,7 @@
 #include <linux/cpu.h>
 #include <linux/cpuhotplug.h>
 
+#include <asm/insn.h>
 #include <asm/sbi.h>
 
 #define RISCV_HW_BP_NUM_MAX	32
@@ -62,6 +63,9 @@ enum {
 #define RISCV_DBTR_MC6_HIT1		BIT(25)
 #define RISCV_DBTR_MC6_HIT_MASK	(RISCV_DBTR_MC6_HIT | RISCV_DBTR_MC6_HIT1)
 
+#define RISCV_DBTR_ICOUNT_U		BIT(6)
+#define RISCV_DBTR_ICOUNT_COUNT_MASK	GENMASK(23, 10)
+
 #define RISCV_DBTR_MC6_HIT_FALSE	0
 #define RISCV_DBTR_MC6_HIT_BEFORE	1
 #define RISCV_DBTR_MC6_HIT_AFTER	2
@@ -77,6 +81,7 @@ static union sbi_dbtr_shmem_entry __percpu *sbi_dbtr_shmem;
 /* number of debug triggers on this cpu . */
 static int dbtr_total_num __ro_after_init;
 static int dbtr_type __ro_after_init;
+static bool dbtr_icount_available __ro_after_init;
 static unsigned long dbtr_init __ro_after_init;
 
 #define MEM_HI(_m)		\
@@ -194,6 +199,17 @@ static void init_sbi_dbtr(void)
 		return;
 	}
 
+	tdata1 = dbtr_tdata1_type(RISCV_DBTR_TRIG_ICOUNT);
+
+	ret = sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_NUM_TRIGGERS,
+			tdata1, 0, 0, 0, 0, 0);
+	if (ret.error) {
+		pr_warn("Failed to detect icount triggers\n");
+	} else if (ret.value) {
+		dbtr_icount_available = 1;
+		pr_warn("Icount trigger available.\n");
+	}
+
 	tdata1 = dbtr_tdata1_type(RISCV_DBTR_TRIG_MCONTROL6);
 
 	ret = sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_NUM_TRIGGERS,
@@ -397,6 +413,9 @@ int hw_breakpoint_arch_parse(struct perf_event *bp,
 	hw->tdata1 = 0;
 	hw->tdata2 = attr->bp_addr;
 	hw->tdata3 = 0x0;
+	hw->next_addr = 0x0;
+	hw->step_method = RISCV_HW_BP_STEP_DISABLED;
+	hw->pending_perf_event = false;
 
 	switch (dbtr_type) {
 	case RISCV_DBTR_TRIG_MCONTROL:
@@ -414,6 +433,168 @@ int hw_breakpoint_arch_parse(struct perf_event *bp,
 	return ret;
 }
 
+static ulong get_step_address(struct pt_regs *regs, ulong insn)
+{
+	return get_next_insn_address(regs, insn, regs->epc);
+}
+
+static int dbtr_update_event_tdata(struct perf_event *event,
+				   unsigned long tdata1,
+				   unsigned long tdata2,
+				   unsigned long tdata3, bool wait);
+
+static bool hw_breakpoint_event_active(struct perf_event *event)
+{
+	return READ_ONCE(event->state) == PERF_EVENT_STATE_ACTIVE;
+}
+
+static void clear_singlestep_state(struct arch_hw_breakpoint *bp)
+{
+	bp->step_method = RISCV_HW_BP_STEP_DISABLED;
+	bp->next_addr = 0;
+	bp->pending_perf_event = false;
+}
+
+static void disable_unhandled_singlestep(struct perf_event *event,
+					 struct pt_regs *regs, bool deliver_event,
+					 int err)
+{
+	struct arch_hw_breakpoint *bp = counter_arch_bp(event);
+
+	/*
+	 * If the temporary step trigger cannot be installed or restored, leave
+	 * the CPU with no active trigger instead of re-entering the same debug
+	 * exception forever.
+	 */
+	pr_warn("single-step setup failed for bp_addr=0x%lx epc=0x%lx: %d; disabling event\n",
+		bp->address, regs->epc, err);
+	clear_singlestep_state(bp);
+	if (deliver_event && hw_breakpoint_event_active(event))
+		perf_bp_event(event, regs);
+	if (hw_breakpoint_event_active(event))
+		perf_event_disable_inatomic(event);
+}
+
+static unsigned long icount_step_tdata1(void)
+{
+	return dbtr_tdata1_type(RISCV_DBTR_TRIG_ICOUNT) |
+	       FIELD_PREP(RISCV_DBTR_ICOUNT_COUNT_MASK, 1) |
+	       RISCV_DBTR_ICOUNT_U;
+}
+
+static int restore_original_breakpoint(struct perf_event *event)
+{
+	struct arch_hw_breakpoint *bp = counter_arch_bp(event);
+	int ret;
+
+	/*
+	 * Rebuild the original trigger from the perf attributes instead of
+	 * keeping a second copy of the trigger data.  Do not update the
+	 * temporary trigger in place when changing back from icount/software-step
+	 * mode: uninstall/install gives the original breakpoint a fresh hardware
+	 * slot and clears any transient hit state.
+	 */
+	arch_uninstall_hw_breakpoint(event);
+
+	ret = hw_breakpoint_arch_parse(NULL, &event->attr, bp);
+	if (ret)
+		return ret;
+
+	return arch_install_hw_breakpoint(event);
+}
+
+/*
+ * setup_singlestep - Set the breakpoint to next instruction after current breakpoint.
+ */
+static int setup_singlestep(struct perf_event *event, struct pt_regs *regs)
+{
+	struct arch_hw_breakpoint *bp = counter_arch_bp(event);
+	unsigned long insn, next_addr = 0;
+	int ret;
+	struct arch_hw_breakpoint tmp = {};
+
+	clear_singlestep_state(bp);
+
+	if (dbtr_icount_available && !arch_check_bp_in_kernelspace(bp)) {
+		/*
+		 * User breakpoints can use an icount trigger to retire exactly
+		 * one instruction.  The sdtrig icount path reports EPC after the
+		 * counted instruction, so the callback sees the post-step PC
+		 * without decoding the original instruction here.
+		 */
+		tmp.tdata1 = icount_step_tdata1();
+
+		ret = dbtr_update_event_tdata(event, tmp.tdata1, 0, 0, false);
+		if (ret)
+			return ret;
+
+		bp->step_method = RISCV_HW_BP_STEP_ICOUNT;
+		bp->next_addr = 0;
+		return 0;
+	}
+
+	if (!event->hw.target) {
+		/*
+		 * A CPU-wide software-step trigger follows one task's decoded
+		 * next PC.  If that task migrates, the per-CPU slot may wait
+		 * forever for an address the CPU will not execute.
+		 */
+		return -EOPNOTSUPP;
+	}
+
+	ret = get_insn_safe(regs, regs->epc, &insn);
+	if (ret < 0)
+		return ret;
+
+	next_addr = get_step_address(regs, insn);
+	if (next_addr == regs->epc) {
+		/*
+		 * Some control transfers, notably SRET, cannot be represented
+		 * as an execute breakpoint at a different decoded PC.  Refuse
+		 * the software step rather than programming the same address
+		 * and looping on the original breakpoint.
+		 */
+		return -EOPNOTSUPP;
+	}
+
+	/*
+	 * Software path: update the trigger in-place to an execute
+	 * breakpoint at next_addr.  Build the tdata directly without
+	 * calling hw_breakpoint_arch_parse() so that bp->len and bp->address
+	 * remain valid for the handler's matching logic after restore.
+	 */
+	tmp.tdata2 = next_addr;
+	tmp.tdata3 = 0;
+	switch (dbtr_type) {
+	case RISCV_DBTR_TRIG_MCONTROL6:
+		tmp.tdata1 = dbtr_tdata1_type(RISCV_DBTR_TRIG_MCONTROL6) |
+			     RISCV_DBTR_MC6_EXEC;
+		if (user_mode(regs))
+			tmp.tdata1 |= RISCV_DBTR_MC6_U;
+		else
+			tmp.tdata1 |= RISCV_DBTR_MC6_S;
+		break;
+	case RISCV_DBTR_TRIG_MCONTROL:
+		tmp.tdata1 = dbtr_tdata1_type(RISCV_DBTR_TRIG_MCONTROL) |
+			     RISCV_DBTR_MC_EXEC;
+		if (user_mode(regs))
+			tmp.tdata1 |= RISCV_DBTR_MC_U;
+		else
+			tmp.tdata1 |= RISCV_DBTR_MC_S;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	ret = dbtr_update_event_tdata(event, tmp.tdata1, next_addr, 0, false);
+	if (ret)
+		return ret;
+
+	bp->step_method = RISCV_HW_BP_STEP_SW;
+	bp->next_addr = next_addr;
+	return 0;
+}
+
 static void dbtr_encode_update(union sbi_dbtr_shmem_entry *shmem,
 			       unsigned long idx, unsigned long tdata1,
 			       unsigned long tdata2, unsigned long tdata3)
@@ -574,12 +755,43 @@ static unsigned int mc6_read_and_clear_hit(int idx)
 	return hit;
 }
 
+static int handle_triggered_breakpoint(struct perf_event *event,
+				       struct pt_regs *regs)
+{
+	struct arch_hw_breakpoint *bp = counter_arch_bp(event);
+	bool defer_perf;
+	int ret;
+
+	/*
+	 * Report user breakpoints after the temporary step trigger advances
+	 * past the armed instruction.  Otherwise signal delivery can re-enter
+	 * the same execute trigger before the PC has moved.
+	 */
+	defer_perf = !arch_check_bp_in_kernelspace(bp);
+	if (!defer_perf) {
+		perf_bp_event(event, regs);
+		if (!hw_breakpoint_event_active(event))
+			return NOTIFY_STOP;
+	}
+
+	ret = setup_singlestep(event, regs);
+	if (ret < 0) {
+		disable_unhandled_singlestep(event, regs, defer_perf, ret);
+		return NOTIFY_STOP;
+	}
+
+	bp->pending_perf_event = defer_perf;
+	return NOTIFY_STOP;
+}
+
 /*
  * HW Breakpoint/watchpoint handler
  */
 static int hw_breakpoint_handler(struct die_args *args)
 {
-	int i, bp_ret = NOTIFY_DONE;
+	int i, ret = 0, bp_ret = NOTIFY_DONE;
+	struct perf_event *deferred_step_event = NULL;
+	struct arch_hw_breakpoint *deferred_step_bp = NULL;
 	struct arch_hw_breakpoint *bp;
 	struct perf_event *event;
 
@@ -590,6 +802,74 @@ static int hw_breakpoint_handler(struct die_args *args)
 
 		bp = counter_arch_bp(event);
 
+		if (bp->step_method != RISCV_HW_BP_STEP_DISABLED) {
+			bool pending_perf_event;
+
+			/*
+			 * This trap is for the temporary trigger installed by
+			 * setup_singlestep().  Software stepping must match the
+			 * decoded next_addr; icount already reports the post-step
+			 * PC and can restore the original trigger immediately.
+			 */
+			if (bp->step_method == RISCV_HW_BP_STEP_SW &&
+			    args->regs->epc != bp->next_addr) {
+				/*
+				 * A nested breakpoint can fire before this
+				 * event reaches its decoded next_addr, for
+				 * example when perf delivers a signal handler
+				 * with its own breakpoint.  Let the later slot
+				 * handle that trap and keep this temporary step
+				 * armed.  If nobody handles the trap, restore
+				 * below so a real divergence does not lose the
+				 * original breakpoint indefinitely.
+				 */
+				deferred_step_event = event;
+				deferred_step_bp = bp;
+				continue;
+			}
+
+			if (bp->step_method == RISCV_HW_BP_STEP_ICOUNT &&
+			    args->regs->epc == bp->address) {
+				unsigned long tdata1 = icount_step_tdata1();
+
+				/*
+				 * A trap can be observed before the original
+				 * user instruction retires, leaving EPC on the
+				 * armed breakpoint.  Delivering the deferred
+				 * perf event here would account the same
+				 * breakpoint twice, so rearm icount and wait for
+				 * a callback with a post-instruction EPC.
+				 */
+				ret = dbtr_update_event_tdata(event, tdata1, 0, 0, false);
+				if (ret) {
+					disable_unhandled_singlestep(event,
+								     args->regs,
+								     bp->pending_perf_event,
+								     ret);
+					bp_ret = NOTIFY_STOP;
+					goto exit;
+				}
+				bp_ret = NOTIFY_STOP;
+				goto exit;
+			}
+
+			pending_perf_event = bp->pending_perf_event;
+
+			ret = restore_original_breakpoint(event);
+			if (ret) {
+				clear_singlestep_state(bp);
+				perf_event_disable_inatomic(event);
+				bp_ret = NOTIFY_STOP;
+				goto exit;
+			}
+
+			clear_singlestep_state(bp);
+			if (pending_perf_event && hw_breakpoint_event_active(event))
+				perf_bp_event(event, args->regs);
+			bp_ret = NOTIFY_STOP;
+			goto exit;
+		}
+
 		switch (event->attr.bp_type) {
 		/* Breakpoint */
 		case HW_BREAKPOINT_X:
@@ -603,8 +883,7 @@ static int hw_breakpoint_handler(struct die_args *args)
 					       RISCV_DBTR_MC6_HIT_FALSE;
 
 				if (hit) {
-					perf_bp_event(event, args->regs);
-					bp_ret = NOTIFY_STOP;
+					bp_ret = handle_triggered_breakpoint(event, args->regs);
 					goto exit;
 				}
 			}
@@ -640,8 +919,7 @@ static int hw_breakpoint_handler(struct die_args *args)
 				hit |= ranges_overlap(bp_start, bp_len, stval,
 						      sizeof(long));
 				if (hit) {
-					perf_bp_event(event, args->regs);
-					bp_ret = NOTIFY_STOP;
+					bp_ret = handle_triggered_breakpoint(event, args->regs);
 					goto exit;
 				}
 			}
@@ -653,6 +931,15 @@ static int hw_breakpoint_handler(struct die_args *args)
 		}
 	}
 
+	if (deferred_step_event) {
+		bp = deferred_step_bp;
+		ret = restore_original_breakpoint(deferred_step_event);
+		if (ret)
+			perf_event_disable_inatomic(deferred_step_event);
+		clear_singlestep_state(bp);
+		bp_ret = NOTIFY_STOP;
+	}
+
 exit:
 	return bp_ret;
 }
-- 
2.43.0


