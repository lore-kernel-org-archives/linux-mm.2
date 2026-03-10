Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23515FD4F33
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C44A6B0099; Tue, 10 Mar 2026 16:17:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78F676B009D; Tue, 10 Mar 2026 16:17:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663686B009E; Tue, 10 Mar 2026 16:17:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5376B6B0099
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:17:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 24C0E13A2E0
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:17:48 +0000 (UTC)
X-FDA: 84531264216.14.6B40011
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id B2AD6A0004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:17:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=o0NzaIEi;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="Vy7NML/T";
	spf=pass (imf15.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w7+E6tcC7Zn3D/FOetfIObIGYaQ1VPmcpoDua1SoidQ=;
	b=y8xYO6RMkeQLBRm5a8BliJTz9didcYGvfyJvZLA7WVxGSH3FXKRDJD0AezoZ/aeod+MKXU
	VUkT9WtqtdivWiI/JK/wI5zKYpfQP5mk1rQw11GvRfrXCg5yHQV03o6d+jj8BEhnY0jo0b
	ENwLEK0SnGtitas3ruZDHAsBX01IcRs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773173865; a=rsa-sha256;
	cv=none;
	b=CLk7uCq9VjxYzViFL6CRau++3qtSzww5nO8E5ye2tlRL4N3hau5MqXYE6ipV38ECvdJa5n
	WIVkcgSBDio+GFgnV1NKe1+M8QOi/GDQHDsy1BcKp0V/dyHOeniUOg36HWbKb/gZpuHt1M
	SszW9oMZXucSgcvMOwgIzqc4w7XULCQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=o0NzaIEi;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="Vy7NML/T";
	spf=pass (imf15.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AJ2ZbA3297898
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	w7+E6tcC7Zn3D/FOetfIObIGYaQ1VPmcpoDua1SoidQ=; b=o0NzaIEixTPEJiWg
	f6i2mY2sd1H7AlygHakRZ7oGEADz2/Jp9nZlqbyUBcshQS3v7WrjyAMmWKidrH9c
	dhQWPWDnPUsmSPbFbHtaz1+77QKuX8/tN/pY/1LJgzKjtQ8nhp9N0cD+c4pH0LwY
	Dt7JR4xY/m0ao3cLPl+t6ztu82HEy4GhMm3xg5gtHeqpEROzR8nDGPdwBheou/6l
	41A6ZSo9LfwWC1cXz7EYqgUnDjflhENTKrxRwuE403DVexMEQodj4xrE781T3uHw
	wxp9R0QNnViNnZMof3ge7i4AWRc1IncqnRCa5/M9QpCEL9ThZPTlSvz10WvSoncl
	hjf0gg==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctg1mtp7n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:17:44 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-829ad8a2896so12375730b3a.0
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773173864; x=1773778664; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w7+E6tcC7Zn3D/FOetfIObIGYaQ1VPmcpoDua1SoidQ=;
        b=Vy7NML/TZP9BIEp6EYKrL+E2oLS5Bsbc7RIPdl++G1CP995neWjJ0PhxxtfT18+/gN
         W8tj7uqzOvjd80yrCxESVhiEuzCiFgaxxHgN8r3IxvDi/xBNiWLovFDKW1VEdaTfJkx1
         0MjIRtsU/BTV+Aou7XCGId+IqV/Jxk16E+ac+yDmpWL98B6y0vQObT7NCTiQqpURxrbT
         0w0vFvj0LZ9UofqIZoncF43zFLdpwJyR9g7dIWObrb3pIoPHuKf/Cy954ljt2gZBJizi
         1QGiRJ0im0tw1ojyJKaR9bXbPymNCNJmHcWX83L3jKJ3lMiT1aMg58MtaJ3jaha7furg
         5JJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773173864; x=1773778664;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w7+E6tcC7Zn3D/FOetfIObIGYaQ1VPmcpoDua1SoidQ=;
        b=BKXjncgiIgWm13DW/ed6BtPx7SS/wqqzDbTcN9foyd6WHSm6Wa1eT6mqET7N92JzWh
         4V87xReAiV6ZbmErqWlfQN7Q0ZVlEiVxYT9vLRVftOzH4HQM1IihbL4Yl2bKWETsgIsC
         mz2uHFSXj7nNdyXPoQAUTMouYsjmg45Zf+7xEEcayMGEBErFw5UQGOTJqlWs4j72/rNH
         9Nt0HxuiaYjher83ilN2ByRfUMhNBrAjFWIfHNhw4ZcUvxHsPS4LIRn3oXcPz2JnpDla
         UkOvra2Z48d850dnF8TbX7sdqE3sTh859bUQD+7l0oXmQlyGFU1qmrnuVfSg38nslqBi
         zbaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzwLahBvFLobqjxhnFQdWR9YlnbWzj2aNg8M/W0Od7azGzFmzqRwqZNrQY2PaWOW267OtiLrQHjg==@kvack.org
X-Gm-Message-State: AOJu0Ywe+H8CbdTYOnS75aMUk6i446rkHnecxgsK8qCTenpXvjAJOV0K
	fOGp/zOtWOAVcnmjfNnH8fDKuWNvR5MPz9dAWe0FnFZ6U6he8tOoLcuAIvEoVtthFBKXqR4BsCM
	l+J1vbYCoC2syMdWM1punfQDAS1sjd3DUjIo5ny2bt+INcdMU9xIffg==
X-Gm-Gg: ATEYQzxlmxLhjBoRNOoQX5m0IR79Lqyb0APaP1j+vGxx7+fNF3M6AGS4BmbGcbmCBoJ
	RXdgQKc23m3KkM4n0p76PQ3b3dXLwFB2BTZMU4nvGJ7sRrBxIHLZ64nZCTf7qhYCNi9kPESJtMg
	svBRKrjvfrTOUSTAAiZ6lbX+vqQXaSBXtdb+Ca80hCKBgAWrmcUtYLQDwEiSnw+hMbx2mohxy7X
	UMEPHCvxbl6NqRM+Jtjl5I1tYZTifVmvk4DEbsUOMearW49YzRlMPARS6P7kTlNUI2tWfbFiFq3
	csim8okVzXnX6euChITFifjhPltmSPrirR0HHF+81+rB2qQv9YvGjOHLMOAspDJZEti/M2jQ95r
	XJNnIDUCTRXYM2ZyDGyzJxmSvFCpXGirtw2F+OytBDrtFO7kc
X-Received: by 2002:a05:6a00:92a7:b0:829:6f37:158a with SMTP id d2e1a72fcca58-829f6ee7dc6mr163689b3a.18.1773173863661;
        Tue, 10 Mar 2026 13:17:43 -0700 (PDT)
X-Received: by 2002:a05:6a00:92a7:b0:829:6f37:158a with SMTP id d2e1a72fcca58-829f6ee7dc6mr163660b3a.18.1773173862976;
        Tue, 10 Mar 2026 13:17:42 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:17:42 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:45:50 +0530
Subject: [PATCH v2 06/25] timers: Annotate static information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-6-f91cedc6f99e@oss.qualcomm.com>
References: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
In-Reply-To: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
To: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
        Eugen Hristev <eugen.hristev@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Kees Cook <kees@kernel.org>, Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Saravana Kannan <saravanak@kernel.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
X-Mailer: b4 0.14-dev-f7c49
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=952;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=RRdQeUZhXK8oMvnjfZr+NslKrJ0dwYGiMqLubz+98F4=;
 b=672vJ0CFnnKoQ49ty46SFM2zWdDu9NewajIDyLG+c9snNCv85PGMNaorgu5yAClaDe90mDCT7
 1A/cz9yzCb4Bg0lYVsxjwR3A6k52kB0mgUgypaY38fPEcU3A75TbROH
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Authority-Analysis: v=2.4 cv=YOeSCBGx c=1 sm=1 tr=0 ts=69b07c68 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=WZmkKkIAQcJSthQVk9EA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: j5p9A9nawZnTcJrd7JfiRK363_xq8eXt
X-Proofpoint-GUID: j5p9A9nawZnTcJrd7JfiRK363_xq8eXt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NyBTYWx0ZWRfXwgfK7xOrnf+F
 iPILY1w+MCxGZtr46AdJbNYjMh8XDFG9lbw5tYC6Ui+EQUvyEIBlaCcXY8XA825Ksz3PvNRMoOH
 GbZBK3e0aT9cQzsF/PPkqRNLemlrphVkqYKw52EaNCdL4M/SJMa0X+ey9y9VbX2yMD5IV4zqA0X
 KSqz4NNsH811gnAGr/+DU3BDYVTlMTat79xPdLlIsBx8meMR9g3JK4XldGNOKYDU1o3S4qTCb2S
 gsB3ijXm7G5c6nk8UxnGnd7vMv2ZmU+W8k+xEEEgBJFJneI4tlV9Dw40v/C8t+QzWrJOWgx4lt5
 wXbGwalQ6lEHhiqMnEf0LH0YH0fbp5r88T+Unier7bGhhbTUF4aLBjDj75HbzXGus7lZEN1Oqnm
 PrQctXEmJKokNR0RBQajcZJuGG6Tav8wClrk2SRnxf3FoHAsUeMkL77viTPUtRm3XTlkmFIpj/g
 r5g779MC0sINvAK+H0A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603100177
X-Stat-Signature: jb1asau1r9huden9wzptda7ri6y8au75
X-Rspam-User: 
X-Rspamd-Queue-Id: B2AD6A0004
X-Rspamd-Server: rspam12
X-HE-Tag: 1773173865-530530
X-HE-Meta: U2FsdGVkX18EGSgvgGmLzR1VBRtlpzSgDAan6ncjNQw5bV1Hkvt+G/KNtW3NALB6aZ0Rb65MB+5HOPdhMe55fQF+KGO2EY9NinK3kp4R7KxdVHw6g7+argKPxEQNFegsW7/xxuuReciYbdpvkLOZ4Y2Jnf9wgQ97KZFOvpvoB9sQyU51a/l3jsxTOKkyli74/+r3XK9Ar7dGjfr+ybPru0JaFfvHo0dH24qW34u386m6kilXGKpx8TTLTNXTkk1zdIqT9l4Nv5iyywbJCl4p1coy2wP9AdDcsaoaPKnuQ7K/L67SceTqw0Yt+h/uuEhPn4NDPQlEycD2rO1V2AK4eG9I85L+Q7lu/Ynctz3KtqkZHrD8lcQ8cEDIfpeQ+l3g7H0hXoHu+T3gfE0Mljf9sng+6J3LaAM3sii7EVOYXN+pMryJiTjuo2la3M7HagSKq6BmhEMdgAWFnNIrkGlCST82TcaA2NIlaTFjZfu0TUZjTkbB0kKNTFwwMjOzk29njMB04wNrjq+GrQenlmmU3mqS9oiK0jMHtDoD9QCo68Um1Ys7qIgZJq1Y5bnfyFDeydOG4v20Vmpe7HD5vfnsOdtlv4OJfwh7V3zxvnDs2wddD7S0sgPZNjfIN+RZcmNUwSaM/77vHT+YWuUdmJBrquP81GtcDmbwzMnpMiBKdOdBKappEvNueu6OwGoO9Oh2HJQPI+enmy+hbu9Kdt10um8ycsaUIAJcXyOAMjC/oLueHP7Rov9TGZf4ivc88fSVhyQ+ZV8tunYtq/dfoAHDnYQe1dwN43mI0J9ZORE8+05ww9jgs6X4e/sopZGQn6GthR/ijly5fcKUHeh7oQ4oHeSZPJQgOlTrF47WaXUSO42uBjBwIeH6FtdH02/JL9Pre9RHERT4EYH2dId5CZeImnsZ+lFCOXsM2YLLbq51h439iFsLJAiyuQrFWLVhG/epZ1E/BFnTj0dQUSCXi2H
 tvqJcxf7
 NJCeumkJ3DxFqvhgoYEekJk4AAx+1AKJFcRXfqmcBh4TsRfH5MBXloo+9RLuKUVOEx7hmsIs3PFr+MUsHbBk5dEKlBTXhJE5dDS03juwWIQZ59Qon0GruP/Ptc5OWLt0TEjZ7Yigxp7HjJ4Dbv8DaPkmzmxjdzrWw4MaNaKL7+yjSPs8mOlGl8KT8KNmc5/DprRfJpnSt2wIfGreX7IEvAejrYmX7Gzivqb0sdoHrB48LJ+y2b4s5KHTQXrv60sB46au6Sat6MtB2ov+516ZlofEIg1udECVdF2NBKJ0lnP5mddknhMbdrPZwOqPwnzwxwxNwRmDw6SXqxaGqAhGlEOx+P3V4cZvrn9Eb1B21yZ9Vxts6PoS0yFc/lQ9S15VWPZkE1+y8Mp5FBS7AbtREOYoTDsgvLZhWCTvn7uHNOf651z8XgMqBgYHsF5Xa5WdvVaxYHhZ7l8VT4i8/K2i1HiTb66pZoODOR+krU3DWx6ui3eQLcmRqg84ZT6Uoj9c0XjGryd0nnpBRHRnqdGFXgIa/Tz6Qn7efGuRKNGOR8BWY+oEm4mUbOG4QXSbh9tbMFCgCwccfr/uzMRY0tZyBt+SCRJy0QGtxWnnWjcGZimxD/1/CB7Ncbb6Nsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

Annotate vital static information into inspection table:
 - jiffies_64

Information on these variables is stored in a dedicated meminspect
section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 kernel/time/timer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 7e1e3bde6b8b..ba86a5a7ebbf 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -44,6 +44,7 @@
 #include <linux/compat.h>
 #include <linux/random.h>
 #include <linux/sysctl.h>
+#include <linux/meminspect.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -60,6 +61,7 @@
 __visible u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
 
 EXPORT_SYMBOL(jiffies_64);
+MEMINSPECT_SIMPLE_ENTRY(jiffies_64);
 
 /*
  * The timer wheel has LVL_DEPTH array levels. Each level provides an array of

-- 
2.50.1


