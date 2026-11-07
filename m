Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F31B606A32D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=H6newvIu;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=N65omf7f
Received: by kanga.kvack.org (Postfix)
	id 632F16B05C7; Fri,  6 Nov 2026 21:40:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60A0D6B05C8; Fri,  6 Nov 2026 21:40:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F8CF6B05C9; Fri,  6 Nov 2026 21:40:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 141FF6B05C7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:40:08 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9882CA7C53
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:40:07 +0000 (UTC)
X-FDA: 85406768454.20.91BE2FE
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 11678140004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:40:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=H6newvIu;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=N65omf7f;
	spf=pass (imf09.hostedemail.com: domain of himanshu.chauhan@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=himanshu.chauhan@oss.qualcomm.com;
	dmarc=pass (policy=none) header.from=oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794019205;
	b=QCyEBZkQvbec7vWZr5XM4Cfcmctt/VgbLNjO1D5S7OEMaat+QkbSy2PIQU+5SuaQ1dvpPe
	EcKRUohInfDhZ5UqkA17m9nXHgX5tB1bONMIBXwbt4mIK48ePC+iWIMaOI52z4bg+7e5Tl
	0684Ld/GfYYdkso0/nmq00Al62d8hGY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=H6newvIu;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=N65omf7f;
	spf=pass (imf09.hostedemail.com: domain of himanshu.chauhan@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=himanshu.chauhan@oss.qualcomm.com;
	dmarc=pass (policy=none) header.from=oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794019205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0vRJrxBmWVbIvLRhEapzyE2zsMF2/4hAuNHs6uFZtVk=;
	b=AQ9ye5hcy/DTSGNpWp3MXvbGEE7CZMH/eo/NvMhtP/V+IhIPcrFNYc2J0PsgdJp5IznEtW
	oN829IDrCLxtNS/xp6qr/vuy5fSbG+MY2u6cpc3VjzmsU5lFxJlJap/4gJS3UlS9vbhZoe
	GBLhi/rwGc10uYajtOhBuP/3hsVF5tk=
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A72AnHB2563264
	for <linux-mm@kvack.org>; Sat, 7 Nov 2026 02:40:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=0vRJrxBmWVb
	IvLRhEapzyE2zsMF2/4hAuNHs6uFZtVk=; b=H6newvIujGT75ZuPxlanKkixR4o
	KpXY2uYE3AXKRnk/Weuqslh3dJ6BxfNUHPlcB4ZINj7kawdD7VXICZQgozUT8dyE
	ZbppYmYxyA0dXy+0DjIMp0IoDzjWuMwV8qJRY0kJIDOGDLDHt5riVRATFHS5eK0C
	vnub+JfVZSsScIbIVB/w+flY5x10bJezHjhQZ9h6YcB/TXq9zgIoOCA7IUhuZTK9
	PgVDOF3PMvlq+y6uIosog8SObIsLgCUBo3EWWGFyYlCHTEHmXO4W1rzgsYhY8SBQ
	IH26MNinKoz20PMUXmrvOCBtqq6rmT8PoD7iEb0oJDt/zdNBVsBIsnGOTjA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hstxs82y2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 07 Nov 2026 02:40:03 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36f26e6abe9so2220088eec.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794019203; x=1794624003; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0vRJrxBmWVbIvLRhEapzyE2zsMF2/4hAuNHs6uFZtVk=;
        b=N65omf7fDERHHSEJmW9b86fJeUvYeTsQslWXHKzE2Rt1RRoMbTS5Ec8amcVFYLIYk6
         koPWhAYhuISaYA64iXtTeF0T6B0br2Gp4i8hRxHWFITljkf+EPF11XxYThHgD0smlNjJ
         HiM5Z5bI6PF8+T7QRKWt3pz+yZcmSWsNczjLIZzd5qJbyfLJQHFtL5OQcwco6JlmeFkD
         bvm8Y2+TCgNeYFctQAU7aQccRkKUETMxkcpO5I2L/TWDJOFntXwYqS65v1o8es47uOBX
         Cusi0uZjJkwhmAwtdMszoQNQMjIQc+WE9k2UfXjO7r4VtFXr8RkFHm4f4B8WVdr832NM
         DLxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794019203; x=1794624003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0vRJrxBmWVbIvLRhEapzyE2zsMF2/4hAuNHs6uFZtVk=;
        b=mnTJq6i9QVnr2kBigp7iBSzrQrpMKNdSRqwlH/agbgaoaxRwfmywx6f9DX8hio5rcC
         ZwWxfaUZnatlqklryKN1fmBiXSwXKLVf3vAAiOls4xs2XjCPpSXvzzFnyFUajtX7QEJe
         7gV40nKz2nvKLf3D4WI7OgaMI71QCO2kG6Mz1azhxnWk8fteRagZ70oCPygeqG9c9E0N
         kQv0aARjDQg30/wQC3NoeC+2xCn/Di1wRp14bKijezi1UgKFdHq8ZTQlUfHeKMFMJGW5
         PVN9tKiwZaOtJ01hW7vE5stYhLntZyDyCYqxt+p/vXXB2LgVbY5WPcQXArg0N58C1N6T
         /CMg==
X-Forwarded-Encrypted: i=1; AL+hErEu9fambTOV92XZ8142NJ8rpVgjAJ3e5MlnrtWQ58hZL0zvqttBWlH7wAKKa3tfaZ0fMybuQknmHQ==@kvack.org
X-Gm-Message-State: APuU4Z+CjTczxMwK0PR5oB1Shft7YexDxN8BicpOZAGPoWHdGAhEoQGE
	MjjM/QRM6wU9m38A/xmEllUIVvtlSzONWD+bHUKbwG2NicvQgYdYGj0sfqz8DJvSZg4ea23lNQR
	XryuIwrS9KCLswnSWibVtcv8JSJuRxlJtEkGGR0QsjA8lNgOUHTrAjg==
X-Gm-Gg: AYBFou0F2JimmMlFg6Yx883r/P+BVXXu5KChuno+pbs1gJREJj3HN/T7th60djcOu3u
	miQrQyEMtTLMyXPRJMpqbiXKPNC9RBvctMviLwyrLbZV6a8klZW5W7q3QiZKIfk3IjbAh2P1a+Y
	S4ne+Y3ulT5PVlqyuPJewu5QrGTPDmiXckCK5pCz/8RIrPu7HN2EFrlzdrisQvpWqHSTrQxBeIg
	yxOA/cCl5T+/emaGcWoa5phhz25wmUv8AeUK8PFpWe5/PEXb/2QbYstESz3evQx33dKUWBudHjT
	t0xwz/cAi97tWaW3EwKIn5JO7kGsAGc+so69/0vn2YwQmBgass9hN/nB4mT8IuqCb2FOd5vEgu1
	zkHlT7ujUDrMaO4ndS38mFxzVCtcHAv1g/ojXmKimP8aUONJPvJjarsTIkvMmdPVqYLs+5blWLH
	dGzgwIfsFt5yhPWHTRlXYX2TPCSIkwr4YmlQZVLSjkdPMql/jeO48owSOe2xb1XQ2Ss1WXWTjBr
	A==
X-Received: by 2002:a05:7301:190b:b0:369:faa2:1fb2 with SMTP id 5a478bee46e88-36f75441608mr5918559eec.8.1794019202550;
        Fri, 06 Nov 2026 18:40:02 -0800 (PST)
X-Received: by 2002:a05:7301:190b:b0:369:faa2:1fb2 with SMTP id 5a478bee46e88-36f75441608mr5918516eec.8.1794019201699;
        Fri, 06 Nov 2026 18:40:01 -0800 (PST)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faac86a96sm11069040eec.29.2026.11.06.18.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 18:40:01 -0800 (PST)
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
Subject: [PATCH v8 4/8] riscv: add regset access for hardware breakpoints
Date: Sat,  7 Nov 2026 08:09:13 +0530
Message-ID: <20261107023917.40606-5-himanshu.chauhan@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261107023917.40606-1-himanshu.chauhan@oss.qualcomm.com>
References: <20261107023917.40606-1-himanshu.chauhan@oss.qualcomm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: ZWZH_D-mQS77lOJ4cdsKTqdd24JMOPIb
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDAxMCBTYWx0ZWRfX+/7wXquHdf7X
 7LSSft+SYqr/Ryq8mtsBGPIjV2ZSXyO6Ozy0QPO64DFcCXcu4iRjeG9fR+osx8O1NN4Z+Ce4MwL
 f2vA0wiNh1VIlfDOc0sTTB2TDoa+QWM=
X-Authority-Analysis: v=2.4 cv=dZMVTnXe c=1 sm=1 tr=0 ts=6aee8f83 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8
 a=JzL-O2mrLglAivqIvYYA:9 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDAxMCBTYWx0ZWRfX16eX3B3cLgHp
 WhCrCqgaHZ5aAZd7FXN3AX2Ri4laPy/lVIzNN/E6aTNffMMYEPgLBNhfiusHcBBEVfMOx7gOjwm
 tEBDVQvOVVLDMGgkL9Bof8yAPWbf16N4pnP8m1F1LBT5nBSf5qdXXezyzID7Puqj/rUdIbiVP2r
 /VpHdYd1/ohV3xw48trsyp0BdljTMsoGXYhND7x/z0wkM8zjmeqxZiv6nUQS2VkPqxd88Ecus+1
 peL7seXWOV5n3EsqUC7JR5iY95bPYCaOyrOLxJ412rf9WmOqeLQ5fj+S3tUKWOCVdo1swo1wsAa
 qRR6wHC368SI/UIsemCfs4OPHWVXian3fsvueLdhzP2JIajdduerdul8RMAm20W3nrl/ChP8Y5A
 KvzQOcRxSOD7SpNg5U8/rpBq5c8F49tqXi9dUrtf0137qXzG1fHouFfwdTYP67Dzfsc0/+K2Rjt
 fwkM1wF2nAZMeVvwMkg==
X-Proofpoint-GUID: ZWZH_D-mQS77lOJ4cdsKTqdd24JMOPIb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_01,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 spamscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070010
X-Stat-Signature: xgfu6hshcszw4d5nz4oi8k1uw7arpk8u
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 11678140004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794019204-766781
X-HE-Meta: U2FsdGVkX19Ra41A5zVsolMj1Au8iOWWSgD/ux0H7ERvbucz67j9chBxmx+MJR2LpuhTzDmQw12LIm3HGFtjPlKepnJoHYMGJ3+3fTSyEgpL6knc5lCsDP47fdKbwEv3j8qulXWaJwDCHMp+tMZRZv0eMUPcADQP1a9qEWPTlP7Av1TVYB8TTCWV32wmp0ecIG8j1/K7YaXmOWrww3qsTUMS3GOaQSsy/zYk+Zd7P1sV0IVrqZWXUZ2XmHgcck6Kvuc+rO1sZWftO7Sbni916vFjppFX4RfEKOHlnuXWMwj5MndsRABBGVGbnfpe4P+AXhZoRQoSWxC9ZXuv1WLAcC1Zn8SqIfQ7Vb1MDWpnMRIjCdx2SlUqUIy+XXepByfO1xvt+7KER+cRG2gziiYX1Xxj5Az9NcmBYqJss7XMA7nvc1ebfeRzgCyirE29hTj+EHZRBTpQEEAjMfTfQQIZ6O4Usc9Uu/N99QrT+zBxmMH3RbPYHhkFJBc1EbdkUHzrWiIezDvrk6khL3ubbFW8dk+IGnFRy8ohLc8vXdz2fFDaDa3WPBzV5p1HNrC2pCIBdE1i/A63TQQ5xp2v9Kt5aLant8a9IMIQtlTLY2jVoEn4NAY5A1+JcQ+dtxUC1LJDYmuWhFhWywTylv3eZ9EgUAF7AU3mgi0r8RKeNa41CfqrbLKeMNwVxR7HsE6nye/3gy12RdUTls08Y+sYtk1EfGfQ7a9SrUM/vxufuJD3gevlpISxSK8fcqmp+BDZUGZE/68tkALKV8iqF0CPMzHGOJTVgRICCLBc60dJMZ1ynkUFmu9OmLOkEe4SDD1rARb7K/I0purq9uGUlksbgl5cgh+PzoOgSB4AAhXqqqPYzANKc0Z9cWpdyYgVWlixmuMogLKw8HzoKWo3ABaIvcbRNnYHT+ot9qVd+ywdIRM/nCiQXkzapZCbR5kJU6kkhoDiaq/Jn0pA5yAnh2QPP4e
 YTpEhcHD
 78+7i/uldEoVe/tgMHbE+2vnR5KqMY1pz6YKHLsVi1uYr6eqL5ApVKVtIdL3Czw1Fi7NouqZ+z7FnEYAp04Vi6HRjJ4f3kS7KhGZEGb+Cg120W97g6tmm5qt+IbzuiYQ+lDnSwn4ggxcFQoGkBZq3Aqjpn9VoN2A7UYuPENvbDPJ9vpZfmUy+99frKIdSqOCVGgzNeFoaUX19/eEml8TI/DeZrl8+NFD6+JypndADyZzzuImbmpSBe9va2+UfzmvCpiTx1glqKnMKK1bwXRCfucNz57a8Z5FYVjWkHpIOmEUcpx5nx3QX+Nyg2869VEtChxupMZ6sJ/mdxqn9oMCA26dkI2gb6sRON8GNhtD0OdqKtq7PPkrMcU6bF9W/INQSE23SOfDhBwA9AxvIZxXaSDv5EbUprMbi3eCFw/8HoYbJ+6OOMWaW1wxMIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add NT_RISCV_HW_BREAK and NT_RISCV_HW_WATCH. A tracer can use
PTRACE_GETREGSET and PTRACE_SETREGSET to read or program the RISC-V
hardware breakpoint and watchpoint slots.

The regset layout uses fixed-width address and control fields. This
keeps the native and compat layouts the same, because the UAPI fields do
not depend on the task word size. Reuse the ptrace-owned perf event
backend from the previous patch.

Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
---
 arch/riscv/include/uapi/asm/ptrace.h |  41 ++++
 arch/riscv/kernel/ptrace.c           | 340 +++++++++++++++++++++++++++
 include/uapi/linux/elf.h             |   4 +
 tools/include/uapi/linux/elf.h       |   2 +
 4 files changed, 387 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/ptrace.h b/arch/riscv/include/uapi/asm/ptrace.h
index 373a1c14f207..c6beb7b287fe 100644
--- a/arch/riscv/include/uapi/asm/ptrace.h
+++ b/arch/riscv/include/uapi/asm/ptrace.h
@@ -10,6 +10,7 @@
 
 #include <linux/types.h>
 #include <linux/const.h>
+#include <linux/bits.h>
 
 #define PTRACE_GETFDPIC		33
 
@@ -166,6 +167,46 @@ struct user_cfi_state {
 	__u64 shstk_ptr;
 };
 
+/*
+ * bit[3:0]        Match
+ * bit[8:4]        Size
+ * bit[11:9]       When
+ * bit[12]         Select
+ * bit[13]         Chain
+ * bit[16:14]      Type
+ * bit[XLEN-1:17]  Reserved
+ */
+#define HWDEBUG_MATCH_MASK	__GENMASK(3, 0)
+#define HWDEBUG_SIZE_MASK	__GENMASK(8, 4)
+#define HWDEBUG_WHEN_MASK	__GENMASK(11, 9)
+#define HWDEBUG_SELECT_MASK	_BITUL(12)
+#define HWDEBUG_CHAIN_MASK	_BITUL(13)
+#define HWDEBUG_TYPE_MASK	__GENMASK(16, 14)
+
+#define HWDEBUG_MATCH(_ctrl)	(((_ctrl) & HWDEBUG_MATCH_MASK) >> 0)
+#define HWDEBUG_SIZE(_ctrl)	(((_ctrl) & HWDEBUG_SIZE_MASK) >> 4)
+#define HWDEBUG_WHEN(_ctrl)	(((_ctrl) & HWDEBUG_WHEN_MASK) >> 9)
+#define HWDEBUG_SELECT(_ctrl)	(((_ctrl) & HWDEBUG_SELECT_MASK) >> 12)
+#define HWDEBUG_CHAIN(_ctrl)	(((_ctrl) & HWDEBUG_CHAIN_MASK) >> 13)
+#define HWDEBUG_TYPE(_ctrl)	(((_ctrl) & HWDEBUG_TYPE_MASK) >> 14)
+
+#define HWDEBUG_MK_MATCH(_match)	(((_match) << 0) & HWDEBUG_MATCH_MASK)
+#define HWDEBUG_MK_SIZE(_sz)		(((_sz) << 4) & HWDEBUG_SIZE_MASK)
+#define HWDEBUG_MK_WHEN(_when)		(((_when) << 9) & HWDEBUG_WHEN_MASK)
+#define HWDEBUG_MK_SELECT(_sel)		(((_sel) << 12) & HWDEBUG_SELECT_MASK)
+#define HWDEBUG_MK_CHAIN(_chain)	(((_chain) << 13) & HWDEBUG_CHAIN_MASK)
+#define HWDEBUG_MK_TYPE(_type)		(((_type) << 14) & HWDEBUG_TYPE_MASK)
+
+struct user_hwdebug_state {
+	__u32 info;
+	__u32 pad;
+	struct {
+		__u64 addr;
+		__u32 control;
+		__u32 pad;
+	} dbg_regs[16];
+};
+
 struct __riscv_hwdebug_state {
 	__u64 addr;
 	__u64 type;
diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
index be076865d02d..9959a8e4a307 100644
--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -37,6 +37,10 @@ enum riscv_regset {
 #ifdef CONFIG_RISCV_USER_CFI
 	REGSET_CFI,
 #endif
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	REGSET_RISCV_HW_BREAK,
+	REGSET_RISCV_HW_WATCH,
+#endif
 };
 
 static int riscv_gpr_get(struct task_struct *target,
@@ -526,6 +530,302 @@ static struct perf_event *ptrace_hbp_create(enum riscv_hbp_type hbp_type,
 	return bp;
 }
 
+static int ptrace_hbp_note_to_type(unsigned int note_type,
+				   enum riscv_hbp_type *hbp_type)
+{
+	switch (note_type) {
+	case NT_RISCV_HW_BREAK:
+		*hbp_type = RISCV_HBP_BREAK;
+		return 0;
+	case NT_RISCV_HW_WATCH:
+		*hbp_type = RISCV_HBP_WATCH;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int ptrace_hbp_fill_attr_ctrl(enum riscv_hbp_type hbp_type,
+				     struct arch_hw_breakpoint *bpctrl,
+				     struct perf_event_attr *attr)
+{
+	int len, type;
+
+	attr->disabled = 0;
+	type = bpctrl->type;
+	len = bpctrl->len;
+
+	switch (hbp_type) {
+	case RISCV_HBP_BREAK:
+		if ((type & HW_BREAKPOINT_X) != type)
+			return -EINVAL;
+		break;
+	case RISCV_HBP_WATCH:
+		if ((type & HW_BREAKPOINT_RW) != type)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	attr->bp_len	= len;
+	attr->bp_type	= type;
+	attr->bp_addr	= bpctrl->address;
+
+	return 0;
+}
+
+static int ptrace_hbp_get_resource_info(enum riscv_hbp_type hbp_type, u32 *info)
+{
+	u8 num;
+
+	/*
+	 * The NT_RISCV_HW_BREAK/WATCH regset ABI exposes 16 register pairs.
+	 * Cap the reported count so GETREGSET/SETREGSET never walk past the
+	 * fixed UAPI array even if the platform has more triggers.
+	 */
+	switch (hbp_type) {
+	case RISCV_HBP_BREAK:
+		num = min_t(unsigned int, hw_breakpoint_slots(TYPE_INST),
+			    RISCV_MAX_BP);
+		break;
+	case RISCV_HBP_WATCH:
+		num = min_t(unsigned int, hw_breakpoint_slots(TYPE_DATA),
+			    RISCV_MAX_BP);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*info = num;
+
+	return 0;
+}
+
+static u32 encode_ctrl_reg(struct perf_event *bp)
+{
+	struct arch_hw_breakpoint *bpctrl = counter_arch_bp(bp);
+	u32 ctrl = 0;
+
+	/* Expose the generic UAPI bp_type values in ptrace control bits. */
+	ctrl |= HWDEBUG_MK_TYPE(bp->attr.bp_type);
+	ctrl |= HWDEBUG_MK_MATCH(bpctrl->match);
+	ctrl |= HWDEBUG_MK_SELECT(bpctrl->select);
+	ctrl |= HWDEBUG_MK_WHEN(bpctrl->time);
+	ctrl |= HWDEBUG_MK_SIZE(bp->attr.bp_len);
+	ctrl |= HWDEBUG_MK_CHAIN(bpctrl->chain);
+
+	return ctrl;
+}
+
+static int ptrace_hbp_get_ctrl(enum riscv_hbp_type hbp_type,
+			       struct task_struct *tsk,
+			       unsigned long idx,
+			       u32 *ctrl)
+{
+	struct perf_event *bp = ptrace_hbp_get_event(hbp_type, tsk, idx);
+
+	if (IS_ERR(bp))
+		return PTR_ERR(bp);
+
+	*ctrl = bp ? encode_ctrl_reg(bp) : 0;
+	return 0;
+}
+
+static int ptrace_hbp_get_addr(enum riscv_hbp_type hbp_type,
+			       struct task_struct *tsk,
+			       unsigned long idx,
+			       u64 *addr)
+{
+	struct perf_event *bp = ptrace_hbp_get_event(hbp_type, tsk, idx);
+
+	if (IS_ERR(bp))
+		return PTR_ERR(bp);
+
+	*addr = bp ? counter_arch_bp(bp)->address : 0;
+	return 0;
+}
+
+static struct perf_event *ptrace_hbp_get_initialised_bp(enum riscv_hbp_type hbp_type,
+							struct task_struct *tsk,
+							unsigned long idx)
+{
+	struct perf_event *bp = ptrace_hbp_get_event(hbp_type, tsk, idx);
+
+	if (!bp)
+		bp = ptrace_hbp_create(hbp_type, tsk, idx);
+
+	return bp;
+}
+
+static void decode_ctrl_reg(u32 uctrl, struct arch_hw_breakpoint *bpctrl)
+{
+	bpctrl->type = HWDEBUG_TYPE(uctrl);
+	bpctrl->match = HWDEBUG_MATCH(uctrl);
+	bpctrl->select = HWDEBUG_SELECT(uctrl);
+	bpctrl->time = HWDEBUG_WHEN(uctrl);
+	bpctrl->len = HWDEBUG_SIZE(uctrl);
+	bpctrl->chain = HWDEBUG_CHAIN(uctrl);
+}
+
+static int ptrace_hbp_set_ctrl(enum riscv_hbp_type hbp_type,
+			       struct task_struct *tsk,
+			       unsigned long idx,
+			       u32 uctrl)
+{
+	int err;
+	struct perf_event *bp;
+	struct perf_event_attr attr;
+	struct arch_hw_breakpoint bpctrl;
+
+	bp = ptrace_hbp_get_initialised_bp(hbp_type, tsk, idx);
+	if (IS_ERR(bp)) {
+		err = PTR_ERR(bp);
+		return err;
+	}
+
+	attr = bp->attr;
+	decode_ctrl_reg(uctrl, &bpctrl);
+	bpctrl.address = attr.bp_addr;
+	err = ptrace_hbp_fill_attr_ctrl(hbp_type, &bpctrl, &attr);
+	if (err)
+		return err;
+
+	return modify_user_hw_breakpoint(bp, &attr);
+}
+
+static int ptrace_hbp_set_addr(enum riscv_hbp_type hbp_type,
+			       struct task_struct *tsk,
+			       unsigned long idx,
+			       u64 addr)
+{
+	int err;
+	struct perf_event *bp;
+	struct perf_event_attr attr;
+
+	bp = ptrace_hbp_get_initialised_bp(hbp_type, tsk, idx);
+	if (IS_ERR(bp)) {
+		err = PTR_ERR(bp);
+		return err;
+	}
+
+	attr = bp->attr;
+	attr.bp_addr = addr;
+	err = modify_user_hw_breakpoint(bp, &attr);
+	return err;
+}
+
+#define PTRACE_HBP_ADDR_SZ	sizeof(u64)
+#define PTRACE_HBP_CTRL_SZ	sizeof(u32)
+#define PTRACE_HBP_PAD_SZ	sizeof(u32)
+
+static int riscv_hw_break_get(struct task_struct *target,
+			      const struct user_regset *regset,
+			      struct membuf to)
+{
+	unsigned int note_type = regset->core_note_type;
+	enum riscv_hbp_type hbp_type;
+	int ret, idx, num_slots;
+	u32 info, ctrl;
+	u64 addr;
+
+	ret = ptrace_hbp_note_to_type(note_type, &hbp_type);
+	if (ret)
+		return ret;
+
+	/* Resource info: number of available slots */
+	ret = ptrace_hbp_get_resource_info(hbp_type, &info);
+	if (ret)
+		return ret;
+
+	membuf_write(&to, &info, sizeof(info));
+	membuf_zero(&to, sizeof(u32));
+
+	/* Emit one (address, ctrl, pad) entry per available slot */
+	num_slots = (int)info;
+	for (idx = 0; idx < num_slots; idx++) {
+		ret = ptrace_hbp_get_addr(hbp_type, target, idx, &addr);
+		if (ret)
+			return ret;
+		ret = ptrace_hbp_get_ctrl(hbp_type, target, idx, &ctrl);
+		if (ret)
+			return ret;
+		membuf_store(&to, addr);
+		membuf_store(&to, ctrl);
+		membuf_zero(&to, sizeof(u32));
+	}
+	return 0;
+}
+
+static int riscv_hw_break_set(struct task_struct *target,
+			      const struct user_regset *regset,
+			      unsigned int pos, unsigned int count,
+			      const void *kbuf, const void __user *ubuf)
+{
+	unsigned int note_type = regset->core_note_type;
+	enum riscv_hbp_type hbp_type;
+	int ret, idx = 0, offset, limit;
+	u32 ctrl;
+	u64 addr;
+
+	ret = ptrace_hbp_note_to_type(note_type, &hbp_type);
+	if (ret)
+		return ret;
+
+	/* Resource info and pad */
+	offset = offsetof(struct user_hwdebug_state, dbg_regs);
+	user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf, 0, offset);
+
+	/* (address, ctrl) registers */
+	limit = regset->n * regset->size;
+	while (count && offset < limit) {
+		if (count < PTRACE_HBP_ADDR_SZ)
+			return -EINVAL;
+
+		/* user_regset_copyin() can do partial copies for odd offsets. */
+		addr = 0;
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &addr,
+					 offset, offset + PTRACE_HBP_ADDR_SZ);
+		if (ret)
+			return ret;
+
+		ret = ptrace_hbp_set_addr(hbp_type, target, idx, addr);
+		if (ret)
+			return ret;
+
+		offset += PTRACE_HBP_ADDR_SZ;
+
+		if (!count)
+			break;
+
+		/*
+		 * Reject undersized control writes, and keep ctrl initialized in
+		 * case user_regset_copyin() still performs a partial copy.
+		 */
+		if (count < PTRACE_HBP_CTRL_SZ)
+			return -EINVAL;
+
+		ctrl = 0;
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &ctrl,
+					 offset, offset + PTRACE_HBP_CTRL_SZ);
+		if (ret)
+			return ret;
+
+		ret = ptrace_hbp_set_ctrl(hbp_type, target, idx, ctrl);
+		if (ret)
+			return ret;
+
+		offset += PTRACE_HBP_CTRL_SZ;
+
+		user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					  offset, offset + PTRACE_HBP_PAD_SZ);
+		offset += PTRACE_HBP_PAD_SZ;
+		idx++;
+	}
+
+	return 0;
+}
+
 #endif	/* CONFIG_HAVE_HW_BREAKPOINT */
 
 static struct user_regset riscv_user_regset[] __ro_after_init = {
@@ -577,6 +877,24 @@ static struct user_regset riscv_user_regset[] __ro_after_init = {
 		.set = riscv_cfi_set,
 	},
 #endif
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	[REGSET_RISCV_HW_BREAK] = {
+		USER_REGSET_NOTE_TYPE(RISCV_HW_BREAK),
+		.n = sizeof(struct user_hwdebug_state) / sizeof(u32),
+		.size = sizeof(u32),
+		.align = sizeof(u32),
+		.regset_get = riscv_hw_break_get,
+		.set = riscv_hw_break_set,
+	},
+	[REGSET_RISCV_HW_WATCH] = {
+		USER_REGSET_NOTE_TYPE(RISCV_HW_WATCH),
+		.n = sizeof(struct user_hwdebug_state) / sizeof(u32),
+		.size = sizeof(u32),
+		.align = sizeof(u32),
+		.regset_get = riscv_hw_break_get,
+		.set = riscv_hw_break_set,
+	},
+#endif
 };
 
 static const struct user_regset_view riscv_user_native_view = {
@@ -919,6 +1237,28 @@ static const struct user_regset compat_riscv_user_regset[] = {
 		.set = riscv_fpr_set,
 	},
 #endif
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	/*
+	 * The hardware-debug regset uses fixed-width UAPI fields, so the
+	 * native layout is also the compat layout.
+	 */
+	[REGSET_RISCV_HW_BREAK] = {
+		USER_REGSET_NOTE_TYPE(RISCV_HW_BREAK),
+		.n = sizeof(struct user_hwdebug_state) / sizeof(u32),
+		.size = sizeof(u32),
+		.align = sizeof(u32),
+		.regset_get = riscv_hw_break_get,
+		.set = riscv_hw_break_set,
+	},
+	[REGSET_RISCV_HW_WATCH] = {
+		USER_REGSET_NOTE_TYPE(RISCV_HW_WATCH),
+		.n = sizeof(struct user_hwdebug_state) / sizeof(u32),
+		.size = sizeof(u32),
+		.align = sizeof(u32),
+		.regset_get = riscv_hw_break_get,
+		.set = riscv_hw_break_set,
+	},
+#endif
 };
 
 static const struct user_regset_view compat_riscv_user_native_view = {
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index ee30dcd80901..1315ac35157c 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -547,6 +547,10 @@ typedef struct elf64_shdr {
 #define NT_RISCV_TAGGED_ADDR_CTRL 0x902	/* RISC-V tagged address control (prctl()) */
 #define NN_RISCV_USER_CFI	"LINUX"
 #define NT_RISCV_USER_CFI	0x903		/* RISC-V shadow stack state */
+#define NN_RISCV_HW_BREAK	"LINUX"
+#define NT_RISCV_HW_BREAK	0x904		/* RISC-V hardware breakpoint registers */
+#define NN_RISCV_HW_WATCH	"LINUX"
+#define NT_RISCV_HW_WATCH	0x905		/* RISCV-V hardware watchpoint registers */
 #define NN_LOONGARCH_CPUCFG	"LINUX"
 #define NT_LOONGARCH_CPUCFG	0xa00	/* LoongArch CPU config registers */
 #define NN_LOONGARCH_CSR	"LINUX"
diff --git a/tools/include/uapi/linux/elf.h b/tools/include/uapi/linux/elf.h
index 5834b83d7f9a..21f225502051 100644
--- a/tools/include/uapi/linux/elf.h
+++ b/tools/include/uapi/linux/elf.h
@@ -460,6 +460,8 @@ typedef struct elf64_shdr {
 #define NT_RISCV_CSR	0x900		/* RISC-V Control and Status Registers */
 #define NT_RISCV_VECTOR	0x901		/* RISC-V vector registers */
 #define NT_RISCV_TAGGED_ADDR_CTRL 0x902	/* RISC-V tagged address control (prctl()) */
+#define NT_RISCV_HW_BREAK	0x904
+#define NT_RISCV_HW_WATCH	0x905
 #define NT_LOONGARCH_CPUCFG	0xa00	/* LoongArch CPU config registers */
 #define NT_LOONGARCH_CSR	0xa01	/* LoongArch control and status registers */
 #define NT_LOONGARCH_LSX	0xa02	/* LoongArch Loongson SIMD Extension registers */
-- 
2.43.0


