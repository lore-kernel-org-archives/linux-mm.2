Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38694C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 314FC6B00B3; Wed,  8 Jul 2026 01:37:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5DD6B00B5; Wed,  8 Jul 2026 01:37:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B60A6B00B6; Wed,  8 Jul 2026 01:37:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E38C06B00B3
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:37:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6224BA067B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:37:17 +0000 (UTC)
X-FDA: 84964501314.19.708251B
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id D7BE6160005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:37:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=P+jq7OyT;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=VfdO5s6d;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf08.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783489035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=236Inguw/8J4ynlJvnfLp1ewWMlbBoPnuOUaZpd8dt8=;
	b=wEv+vd3iuh5uGlyNrQ1oovj887Gg7mU/A5/xn8oQ91dAQsuFzGJljEin2dDSkV/YRHowhU
	SPS+MGlAQ1Zj3+eyC2AZN6U3eah+USMEuvzDoppd9aUZdy+xzyKmsmaO2Frgfe6KdUGRsn
	EmgM+08Of3VomlhGBkpmEvhPa7QUQvg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=P+jq7OyT;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=VfdO5s6d;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf08.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783489035;
	b=i+vnx2iinQfdc7FvxWu6uMO/oB7dNi8tYtB+HfT4HPQbGlSOCxnSLxTgYZYfkVhIyx5NAA
	WhfRa1AXGXXkub3Sl+B+gLi7BcUYtHUkxYCEwQ91MdIQ8DFjNXzI6lUshNol5JXNkb6nK1
	mavs5PMmw7m8cgxPNI4h/wvrGh3Jgqs=
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842U9M1447476
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:37:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	236Inguw/8J4ynlJvnfLp1ewWMlbBoPnuOUaZpd8dt8=; b=P+jq7OyTqjAc9wXu
	RxNeVEVWgYrBpdAGK5o3b6AWPpRdC/g1cbrqpKSQiGfUKvq1e+0DgOyE1riJOnZj
	lMFxe7ytkjieiLs1bLJJoI6UfdSwS/kZFnw6Ci9E1IqzyI6Y9DJJ7r08KjH1V0ru
	9wrL3tchIUUG+dXTt3ewbVrMxTEodI7+6+wCRFSxdpxYZ7QWyJD1wL8qcbsxkW5N
	PWAAHB8x9PzRoHQMrt8RSH2RzIU9BvQagmTR5nMG7cOd30b9kwE3GnbuBDdz/2dk
	0MbD7d+C9BijjANSzQYL0Nrm5mXyk//z9XTUjvKIIksxsnJNEWkm7PJ44mkMqK5t
	bfEhbw==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f97u11u2t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:37:13 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c860544c077so597097a12.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783489033; x=1784093833; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=236Inguw/8J4ynlJvnfLp1ewWMlbBoPnuOUaZpd8dt8=;
        b=VfdO5s6dH9DykaokWz/wRakV+eEBmXj93z3e3Ao2wnJSbeXMI7Kp1BDOp5hBszSJsO
         0bYzLq14qULkK8zYI83QlfCl90HYuHedQZB1nRHPq9YFO8i9kiYoi3qte8aAJvplLQWD
         dW2Nw4B1V5NIbYR7alW4eU6qTzIn5szmsIm2519N3xxkNfzgc6b5XUui7THIk9ZBfows
         IessMw00I4SzQdzT5dCE8HcDoUCY6bM4TvlnURLAfCvm6ka0hCK32BikarYWV6sUsdEp
         9Y0pq0QPA+yDbKkJGJY+PMta4bDX5rS3lOkrJFFRHYTYyW9r0vJrWKYVkIaJdMCskLbe
         UrrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783489033; x=1784093833;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=236Inguw/8J4ynlJvnfLp1ewWMlbBoPnuOUaZpd8dt8=;
        b=n0hGTVdD+Gq8V+GFxBVI/ff9zE8QnsO6k/+AwKiIA5v23kbRCFhXanrULTj93yWirG
         vvZdRZbMtdcHx+NCW4HI2JNrtBzTt2V6a8tZicW8cgwwZt/m9a3KbikdxMQnxUmIomDV
         3eRBCc7fO/EvYT566/tq6LOdIWGFVoXmswim9U/VmAyUTIjrQoWXQBJF6MeJL0cCAcsI
         mQXTiz0WG0PnJDOkX1BXiHK/+H+b1AWsvJoSlnzlJepV/En9Q8WlUvDnwZhCS5/oeYSI
         fIvXsOHLjB5NrOWQd53gSbBSsMxRAPwSgjP/oErUbMMo7K2TtkozgjAkWuClWfUNdoMW
         Wo3w==
X-Forwarded-Encrypted: i=1; AHgh+RpZDKwpuy4YTZO7wy5kVwNBU9Cr3VC25iSDOZIpAMQh30YCMVzGRtTtSowo+hgMt2E5pguckcPy6w==@kvack.org
X-Gm-Message-State: AOJu0Yyw47dimE6/74bCjN4qWVBZH92zIlgAzWzpcOEsWiuxGpgD7IJ9
	daLC/gOaTe9Ym0gXiaD/ZRZUTLUSRUmPajnG9KS87vgpWNDvryVLnHs/0Rsx/f6IPjmIvbJ1g57
	M3G10/kNHl8VVnNetWnQwRZezJ1osYlU6O7s02XhgBSJnruFuXK8KDg==
X-Gm-Gg: AfdE7cmlQQ2PZI/hH/2uqzavMbSKD59zTC2oLhQm6q07PqPNGZUqMVNKEHLwi71Gsbk
	tGTdBqIF1QE0y65Fqzdv4mi0OC0iwJmEHK6HA4KycYLmNvaM5KfQcVIukWmB1PN9X3f+tzTXZuJ
	YN6QIa63De6nQeDZ9TZuSQOjiPBH2SNKnjw/Yjr5zv1LXrEryiHotnulct/TEkPWmcAuG2Zlc7X
	U2GLk+9uhry6/qqPvCIKiJX8W8jwdtIGufdo2bL1erisnDr4xz7Q8x7kY/s9dtRKQsWkPMARyOu
	AEHMdh5UKiOcJhkCnpRDzXGX30QDbImBdB20/qZuzDgQa4ew3QhqYMGjp1R+39A3cs5jLtSUIR/
	vE4kYUhMVTARDucFTmCrFXbqJ2iTfm2+dlcNDRg==
X-Received: by 2002:a05:6a00:2990:b0:847:927d:47a8 with SMTP id d2e1a72fcca58-8484327cab4mr1157472b3a.18.1783489032768;
        Tue, 07 Jul 2026 22:37:12 -0700 (PDT)
X-Received: by 2002:a05:6a00:2990:b0:847:927d:47a8 with SMTP id d2e1a72fcca58-8484327cab4mr1157416b3a.18.1783489032130;
        Tue, 07 Jul 2026 22:37:12 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:37:11 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:58 +0530
Subject: [PATCH v3 19/26] mm/numa: Register node data information into
 meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-19-7aa5a0a74d5c@oss.qualcomm.com>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
In-Reply-To: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
To: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
        Eugen Hristev <ehristev@kernel.org>,
        Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
        Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>,
        Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Saravana Kannan <saravanak@kernel.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org,
        Eugen Hristev <ehristev@kernel.org>
X-Mailer: b4 0.14-dev-f7c49
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=1048;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=ulGsdKu+z7HvLotkVxGi0y8RHEdMhDyQClvnrll+Bzk=;
 b=MyMhtvJ0wOXNwjzXvlmiA8Ab9JBujyIxKxBCpE0ObhCZPfckWyAffIDGpRxS9EBhvOuKic1KN
 jH7INpGJKThDjepKcHIt//QYPSzCAx6MP/DqcCdV9jTWtJ2PBlwoCaR
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-ORIG-GUID: mAPF8ikdlFRCRIUCVEgm9LnEXtZoZn6d
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX92n2u2Uia8JH
 l9YWCdyyjPLbVuFTifq6nQVz6y4uPZpeByhLRRdU6bUYhFYiXI0UtPvwXRirXcY/Ywgxj+v/j2P
 D26hPt1SEHz+j16mnAfC5/H2vejHyYk=
X-Authority-Analysis: v=2.4 cv=F9JnsKhN c=1 sm=1 tr=0 ts=6a4de209 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=nLJQaZXserL0MincpKQA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: mAPF8ikdlFRCRIUCVEgm9LnEXtZoZn6d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX7YBC1dhQjAgc
 oliUzjJ/9i3r+LfaijdLEy/4JG5KoLt2CdbYN6IthuNMbwNRcAXTTqtHyFVGwU4YQ81mzZccimc
 OwGsYCZn255oArEyIq/apZDJnHD1T9ZJW9E4E4RFLYfzSlmnVvvMIb6wHGtE5fAnxsNFrY4pvtc
 updpj9rGdkRbzjr98N4/qRw3Jzq7s0ZIwvvrvWMPSNoZGdvC6nJ/ilc0cu/Qk8XNvyaoNg4B9rt
 CoCfTLmmyp8YxjBaisjSOWj8Z/Iap1OXh01FCerr9TDxD2MKo8zOMyM37OLMuYU4nWwzGhEJzz6
 g3J///RS7QgACIK5MMjvcEU05WG5AXUSD5AKkpEG1e0npICASHdO/3nA2L5WRwtb0UzY4GfxILS
 mO1c5FQc2VPRtLl5u2n18dSSM6Uk5aporRI+Bo8ChaOQHQ/hjq/AUNTSsuujC+1Ptm1YXMiJFT8
 Mop7nSSAsLcTdY0YmsA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080050
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D7BE6160005
X-Stat-Signature: u584symzbana4u7s6rbwryzge9nemhuu
X-HE-Tag: 1783489034-277870
X-HE-Meta: U2FsdGVkX1/2H/kLQQ3SEPFBDFHe6OKlM1eOXkD/j8hLUQBaWd+7SFgVkGhVCe/cIkVCfJMa4JYUSpobp340aLHitB0mQvMCFwLUCPRTO3+rs2TJL7szL2Au3ok7HVxEcrplI15fZq4FAMTyNKzfiL5+FTEz+6fbAAuOvCICcnh69LXPYt0NMJyNcicnY2kc2O5327viV/AjPMGBeFjVJNypvgNLoZPvTuv/69g1SW3NleKiDCrUqcjPtM6RrjRDLwYnTAbBpi+hXWDAvstlEj9nU33S/jmuHtD6/2jK5HVFGm5KCgLyijOO0Z9P6c4aKA5HHJX9daCbKW2JIZ1hZaUixwjOSa7O4I1VGMPCKs5v2SOFUgapcHwU1WJAldvULX72ZOgxZbpoQX5zLvNHRdFKEK6sTBg9W8eBXL6j+9bS+8tLg9yjz9rm4ATQyvZIlsHMvHqit1zwqJ/TGLSn/5qZjvyA/uXgqZuADsQHiNiaiZTDcpofmRD8sXmPPRj8WOS7Nu7FScjLO0BVXSjsJNIdwG+yOuA4RoJfccJE6Nxw5XPmsy6mNGY9n/aGTbiBCzZxuFPVIgncxLEFVo0Es1JRAOs7+7xdN/usui38qjybzX5t0raKOndn6Oo94rLyLpn9V7LNevx/PfP81MvSjMNSrp5+T1fSxfGm9t8kI2yOa1NT6SBkB5v1CdLFbU4rrMIDLII46bA5tCA/Rvumw2evkv8HWtlrZdSQ8xFKN706c7qdWCglhRKgFbgXS+y3EpKBn0GDIGl900Mp0pxxHuDQgFIrdqBWFMir7kA21wE4w15RUM1zDTHXn6IDDJTlyc+hjdLCV8hzfNa5ZaRbOyR6msiBZFVO0CKQCXz1qLFqaIAVJ8MXEyKg9hCDvhBT29rUJXez17igwzoNUQe/YTc3wZiMvHMl62qOKBy0+Qrng5xbvMIPnAYVVd5HXDOzds/uO+dfwI04fwkHjx9
 XNpG4Oeu
 kjXeoRoOtq9CuQaRnd7oGMlx31VToNwjCdbFScLZJi53bsfT0ngAzcwnp5FTbea7tZnzIx9oxKi2XzCHW7wgrft0B29msJjs1+H8MlWMEMqTG70exe6U5ZUgJcPQ1wNeICNsaR5vQyIWJ1iMqqg0/9k6CJT48ZCi6EygdGxcxTMjQssn4VzerACrULA9wAPinXIGz13U5xKSBlyxdUG0WGbsZXxrGIorqjDLXE0MNmim1QJ3J+/tl9/L7kJVkfQVzSb43g+IpSW9+zuy3avlx+iGow72l3nnn+Qw2X11IorrOhItg9BMz3WtULT+Wv7vSewlLuu4cVxViWd2MfnbnC/zPtoApHvBkE2z6p3FpLsfmJFNIidkC5ZZODb7Mgrnte9jfj5UZ/EIKf2pNO6k2bKu20mN8K41UnEDid0IuPGdwFJY3o/PBTx2tI0r5MEfD4DE1wjnPAoV2goA/KqEGq240LtLqvoU5kex4CViBrctCKqwxG+LXP36B/KPE0b5O5mRlrgQUL2Z77cOcIyYWeaOb00YEw/PX5KFs5Zgxzs+nVzw+GVRZ3QKekFrZKAIBCoAMdOsYpeA90KCvHe53sJf2u3MrIGFCpj8W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Register dynamic information into meminspect for debugging:
 - dynamic node data for each node

Use meminspect_register_pa() to collect node data into meminspect.

Co-developed-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 mm/numa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/numa.c b/mm/numa.c
index 7d5e06fe5bd4..f04740dfb2cb 100644
--- a/mm/numa.c
+++ b/mm/numa.c
@@ -4,6 +4,7 @@
 #include <linux/printk.h>
 #include <linux/numa.h>
 #include <linux/numa_memblks.h>
+#include <linux/meminspect.h>
 
 struct pglist_data *node_data[MAX_NUMNODES];
 EXPORT_SYMBOL(node_data);
@@ -20,6 +21,7 @@ void __init alloc_node_data(int nid)
 	if (!nd_pa)
 		panic("Cannot allocate %zu bytes for node %d data\n",
 		      nd_size, nid);
+	meminspect_lock_register_pa(nd_pa, nd_size);
 
 	/* report and initialize */
 	pr_info("NODE_DATA(%d) allocated [mem %#010Lx-%#010Lx]\n", nid,

-- 
2.53.0


