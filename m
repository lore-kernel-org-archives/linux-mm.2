Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CDC8FD45F9
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 22:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888806B0093; Wed, 25 Feb 2026 17:41:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83BF86B0096; Wed, 25 Feb 2026 17:41:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73E486B0098; Wed, 25 Feb 2026 17:41:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6202F6B0093
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:41:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2289214017F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:41:43 +0000 (UTC)
X-FDA: 84484452486.01.4D01B92
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3204014000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:41:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=RImKPNCZ;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772059300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NwfwFIozanEmKQ2WboEF2eLSp6u+ajjzqhBznl9Xp5k=;
	b=o7PTKkYS5kBCCzlmHPdzJm3eWkDeWSK9s31bztqirJP7tTHeCNzkRBXSZ0VXW2dpp5KAD8
	aNkAhooPB+okx7DqjzKm8ZrZVJP+yZH9zvjaUAxCwKTJYloyFRvEH8yuKkgUCmbdEyFF6Z
	2XtPz8/DJsC3W6xIPqRYGdXU982oM80=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772059300; a=rsa-sha256;
	cv=none;
	b=Lz/SlSAxOA2ELpbHY9LPcvu2yUwQ4Nv/SL0YiHbTGGP9utxXAe4idjexYDteBQ0FB77rux
	pxjU7StoQIr2NMWiO83izcd9jT8TofXR/fLYqBhdnTXLyvmhnTunEIzSB2IpaLVg+WNDFy
	qLv/OH76IcOJy+cFNcHC7wWCAZnz2Tg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=RImKPNCZ;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PMC4Ip1274747
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:41:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=NwfwFIozanEmKQ2WboEF2eLSp6
	u+ajjzqhBznl9Xp5k=; b=RImKPNCZ8KR3nDEvDi4Gz9JoREnYDKQllwTLwprPHg
	EZofUkqZpuHKMfVkzs+LY3j8dY74beRPFZZqhviKCUh1A2aNAYdfXqAiPMNKe6ks
	loSk5i2FGL9XrTFvsXn+Fj4ikmc+y8v6qRN0pGcWLyoBDKExdlR/F0ck5JmojNjI
	6CWLc67/eX71ODfjr0b3f1m/+oygS+gHi2JrNGQpDfZmE2mf1hqoIkjHVplkAx94
	MuZA83rNfSsk951VH5T/nWxyNcGJ7PcZNqaziom5z3Kb+zCPooeJAAz6nS1ZIV6n
	eVf8ho1hT2KaT6aXMhD0vvQDM44N5ONvCiXmsLg8j3UA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4chx6v5y43-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:41:38 -0500 (EST)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c70b6a5821so98388785a.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:41:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772059298; x=1772664098;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NwfwFIozanEmKQ2WboEF2eLSp6u+ajjzqhBznl9Xp5k=;
        b=f6h4KEmkhkGPD2O+1RKbcjLJw2mh7E0RPpQz/CrmUGDZ+OaIlfpNfSMnSY7c0dStPm
         tkeXuuna+MQ9I3wTSTeQ3kWSr8Hj2+GDa5aXl/Qg2hC9jv/nJr/OMw7xNmyfMQkpH4/e
         03qHeDpDVLOA8mNLVPyhjsRvLgEm//tktvEtX1ZoT05AMZjsrYqlY2G8+OG+e7AYV8ul
         RfEjUNBtEq1bbpBsl+lNTWLnLSM7tFgdjkKAvyU64Qcdeh7DTzSpv18x/gfBTGFgd+9n
         6gi0Ib9wMdSziKiHtAuPeS4UH5MEr0Lejqkhf5txm80y6MKgmVjlgvkMGQIA3BmJV+Cz
         +BSg==
X-Forwarded-Encrypted: i=1; AJvYcCUX4+0z/rzNGYziEHhkcRfk7ouArI2lweLvhuiunAhlfYvxgLCqzfP4/kd2ccznaYsoWWdNly1GIw==@kvack.org
X-Gm-Message-State: AOJu0Yz4vsS9uExGzFKN/0JFGwuoVAAWEmyPAJtFj78Il9zpO+eeHfEE
	cKVd2ijSQCvLDJbc1eSQ1oZnE1fFGBWP2E3+T7h6JT/UhT3VyGysurusfPWiF20lhSuLG24mbHo
	fLr/SkFY27FM8zyEU0zL2f2YlAnjLp/St8WUMD+aiBXgW08q+
X-Gm-Gg: ATEYQzwpccR1vkMlJS7SN0CE3ub5O0y1C7ZL9OIosDEe4/RREcC1TwuUPxMv71PNdni
	YWc/emJ8qcDSj8tBVsPM3aldtB9qJ6sSgsxty0PE3Mz+iQzNST9fFibQ+YUGV6CrzNRb8Rz+Vms
	16S1liaAehHhWSOQFJQzyPfZCglwkGxg2EeUG5RehVWfF5iOFerB1c9H8VcBx2rW9rZyq7BzrOj
	P80O/F6/+e1cDPtN/b9FJuu7j/uZXxLcbXeJ0f5wQ4mQyhk1hUHapsKF4JMXbvKilwIk5yT/f/q
	Dig8wUgBKGU37DB5qe0XaOly9lpWc66EaXbG/YCeD4oub9OVPi3s4L3irRvDVpkAIWN0haQMgRG
	iHVLxLEt/dJ2VC7q8IfV4VMZgh2cSor/2
X-Received: by 2002:ac8:5a10:0:b0:507:3d1:1dd7 with SMTP id d75a77b69052e-5070bba1d4bmr250747131cf.6.1772059297763;
        Wed, 25 Feb 2026 14:41:37 -0800 (PST)
X-Received: by 2002:ac8:5a10:0:b0:507:3d1:1dd7 with SMTP id d75a77b69052e-5070bba1d4bmr250746791cf.6.1772059297257;
        Wed, 25 Feb 2026 14:41:37 -0800 (PST)
Received: from [127.0.1.1] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-507449be47dsm4196231cf.15.2026.02.25.14.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 14:41:36 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH RFC v2 0/2] block: enable RWF_DONTCACHE for block devices
Date: Wed, 25 Feb 2026 17:40:55 -0500
Message-Id: <20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHd6n2kC/3WNywrCMBREf6XctZEmsQ9cCYIf4Fa6SJMbe7FNJ
 GmLUvLvhu5dnhnmzAYRA2GEc7FBwJUieZdBHArQg3JPZGQygyhFXQresn58MePdrJUekEnZcim
 NKU8VQt68A1r67L4H3G9X6HI4UJx9+O4fK9+rP7qVM86sMnXdVGgbbi/aj8vUkzqiWaBLKf0A3
 ZPdNLIAAAA=
X-Change-ID: 20260218-blk-dontcache-338133dd045e
To: Jens Axboe <axboe@kernel.dk>,
        "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Yuezhang Mo <yuezhang.mo@sony.com>, Dave Kleikamp <shaggy@kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Bob Copeland <me@bobcopeland.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
        ntfs3@lists.linux.dev, linux-karma-devel@lists.sourceforge.net,
        linux-mm@kvack.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772059296; l=3435;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ekfAVbLYcjxp51ZCBzMQhFzplblwqexTK85RlJKVH8w=;
 b=2wmi7DKqWa1grTlTD1dZPRjRg04r6SzcKRju6wHkROUyXexSvTsDYhaJkZR7D1wKnD2GYouNO
 3Rj5CWfTkXjD0Y32lUMXPSG0+DtraUDXS1xjTx+UYD/cLuEYlAV1ClC
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: EG8-rxTnTkAl0MSVDgl1bPTmr7UXdHm9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDIxNyBTYWx0ZWRfXzHIf00Pn+LqM
 afVgh4VqHqRATdLjUFw4FRVTln07ikg24k8MLWlTHn/zJeoMsxtWbQbR7q7nnhbJWUcveNxgvSJ
 YjYyskNYV3QpOciedamG5gg5l4UcpwM+bQ/GtcbEn7+OzyeQbCdqokJC4Y5voPnDqCwcTGseUKn
 XVGLdgG8N61esY7PFrGgBkM2TYdVc/6zo+XqyZymMMtIcQW1VsJfI/Eg1Ie35oaPA7AZ4CI6Poz
 DIlWvvR8eFQWtNlP+x6nUhfFIriUp7LkJJ3QSxC97MWgIDGPjQwPd6nn0gt44huGJZpagUgoboC
 J/Ans3UsI1DC7OXPO8LpP2r7cV/zgY+rFZhIh8ovhLqG7qA62qgDllzGNtpjbbdvX4nwhe3yX3d
 k3dveE93ZrgtAFRbTTY4JVJBa8ZMZjsJhe2RsE44M5eIe9roRr9YTwfXGbJP7WPF9Hib7UszApN
 gS1b9NVWLaNupxp9faw==
X-Authority-Analysis: v=2.4 cv=FqMIPmrq c=1 sm=1 tr=0 ts=699f7aa2 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=VwQbUJbxAAAA:8 a=sdoS8YJ70VgF2Jk85QkA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: EG8-rxTnTkAl0MSVDgl1bPTmr7UXdHm9
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11712
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 malwarescore=0 adultscore=0 impostorscore=10
 spamscore=0 bulkscore=10 lowpriorityscore=10 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602250217
X-Rspamd-Server: rspam09
X-Stat-Signature: p9wkjfwb8uoejosskytj1i3m3hyzyhx1
X-Rspamd-Queue-Id: 3204014000A
X-Rspam-User: 
X-HE-Tag: 1772059299-200441
X-HE-Meta: U2FsdGVkX1+n26wsliOFiTJNmWTUrmHg8V+eHvvERNYAkDql8aYFwRDtGPA6NxObAcBvf6Hi7SUjA2ro8bX6osriAR6miwb9SsMhXiHJDI3Uw7wH8MteG/J5vFg5ONI0YYtHkhbPw1lNDkDP21D88bL+ZFq9DKJGij/PXsWi9aZvh09+AMJFU0BcykBqSqHdKiWrXYUhZqJbXOM+g9ttwaBMm6nz5HZJFF9KWucUAzq0q4JScCHG6Dng7qtf5J6yhubm1tJy0lHHIR73NPWonuTLhtkJeCRKdovlzbKCfDdkHhtfgbzuvwDQJi2tPhkgjTGXQECy3jSwUbhzGRNCgpgycJNvJBCP8f5Yii8kS20kmR5s1RnWDYXY+BNoZlqH7DeXqlGYI5q7XAWpC2WUzqCEOWIRdzu3ZWhTiTAS6LMzK66UZ1cDjSg46w/aCQ2db2b7fiBTGWj5pUM2e+EOB3nPALWznoQZm45IGEY7A4RmSxLa+fD3VltUG0511e1L4AmT3hRQJ9Mo4R5VU/oaaeRDkz9WXilhwTeYsj7bXvM74XSeknEKZeCQBYxGeeLWEkoaTJFnqD1t4nAyuxAigraFfEs8+ipk6lTKfXP9x61AerRa6U3Z1wUN449GYR0Xp3+SoB+26pVR0mk9DBfRiv17Fu6rG8wjEPu77ec8rKdryLjhSyVpmzXu3oTlLx6QTM4nR5bZiWZqh3irYCXCy+7N7CdIpyF35qyvoQTK/fiNILlv6alWNvbhsryqR04xpvfsfQze3Lt09e6q3kmqpLrQa7MIK8iieCB4/RgExcx0lnFIkuW6h/C3XdABeUiJI6xjYLCuwZOYAZS83p1xFI1/eEvN5bpKiFyT15fF5j2Z62tgW6uhiPIGYqk1y08CP62ccdLmrW/89uw6TqG5Q5Uvrvsu/fhGYtM5qIXO4ZvoV7Iw8i+PEGyv2e5rO9vtY2d2hG+kPxSLXhH94D4
 Y+DIxVRF
 Me8SdZPgbIarXcWRi6Op/totn5Oa05J8VfjDzRIGEKairfIQ4jrfu/5gkPKdTe3wXcV/EEQDUL090ewHmdX0pNvGqs1h+Uoy1T99ES218fHCzHtiABAXu1/6awjUmUa7oTb4oEz6q1Bw1I8o+AVi3AWOHdarUZvOoVjRjPKS3SgmU/c4EgjagLCPbqYoTHjF2GXQmOONoDh47dJZtAwtZ3d0zORbQ7IG8hMKWUmtuqhyQ7wX87L36ZnwsQFL/3qL3SdI1Wvmc700Ok0Opg/Z/m12K1juuh6GuxrOoNdbJWJk8Eq4PPw1o/lwjXTl3FKpNhbDKLsRasJEEjUoQQX22a4a61oPyujEtwrf1ysSoHSSVmgr45bWBDPG3Bf0cQDBqwBoHOAOntnTVXtbMOhxvNmVPIFutPmStc67K4RdZsPvQhBF9dRzhU7bBoAWP8dueVQyddhsCzoxJWOj3qEsM46VD/jzZzLHa7j5UaPfAVJM4/izNjqnUmRkxnVk+zjnFwDe9zchEqH+0vdK0EHrzIoxo5/JmEuoXRiwcL06GGhvYIRj1jGsefXJ7i88kLsoMLx63C6bmr6h6NYw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for using RWF_DONTCACHE with block devices and other
buffer_head-based I/O.

Dropbehind pruning needs to be done in non-IRQ context, but block
devices complete writeback in IRQ context. To fix this, we first defer
dropbehind completion initiated from IRQ context by scheduling a work
item on the system workqueue to process a batch of folios.

Then, fix up the block_write_begin() interface to allow issuing
RWF_DONTCACHE I/Os.

This support is useful for databases that operate on raw block devices,
among other userspace applications.

I tested this (with CONFIG_BUFFER_HEAD=y) for reads and writes on a
single block device on a VM, so results may be noisy.

Reads were tested on the root partition with a 45GB range (~2x RAM).
Writes were tested on a disabled swap parition (~1GB) in a memcg of size
244MB to force reclaim pressure.

Results: 

===== READS (/dev/nvme0n1p2) =====
 sec   normal MB/s  dontcache MB/s
----  ------------  --------------
   1         993.9          1799.6
   2         992.8          1693.8
   3         923.4          2565.9
   4        1013.5          3917.3
   5        1557.9          2438.2
   6        2363.4          1844.3
   7        1447.9          2048.6
   8         899.4          1951.7
   9        1246.8          1756.1
  10        1139.0          1665.6
  11        1089.7          1707.7
  12        1270.4          1736.5
  13        1244.0          1756.3
  14        1389.7          1566.2
----  ------------  --------------
 avg        1258.0          2005.4  (+59%)

==== WRITES (/dev/nvme0n1p3) =====
 sec   normal MB/s  dontcache MB/s
----  ------------  --------------
   1        2396.1          9670.6
   2        8444.8          9391.5
   3         770.8          9400.8
   4          61.5          9565.9
   5        7701.0          8832.6
   6        8634.3          9912.9
   7         469.2          9835.4
   8        8588.5          9587.2
   9        8602.2          9334.8
  10         591.1          8678.8
  11        8528.7          3847.0
----  ------------  --------------
 avg        4981.7          8914.3  (+79%)

---
Changes in v2:
- Add R-b from Jan Kara for 2/2.
- Add patch to defer dropbehind completion from IRQ context via a work
  item (1/2).
- Add initial performance numbers to cover letter.
- Link to v1: https://lore.kernel.org/r/20260218-blk-dontcache-v1-1-fad6675ef71f@columbia.edu

---
Tal Zussman (2):
      filemap: defer dropbehind invalidation from IRQ context
      block: enable RWF_DONTCACHE for block devices

 block/fops.c                |  4 +--
 fs/bfs/file.c               |  2 +-
 fs/buffer.c                 | 12 ++++---
 fs/exfat/inode.c            |  2 +-
 fs/ext2/inode.c             |  2 +-
 fs/jfs/inode.c              |  2 +-
 fs/minix/inode.c            |  2 +-
 fs/nilfs2/inode.c           |  2 +-
 fs/nilfs2/recovery.c        |  2 +-
 fs/ntfs3/inode.c            |  2 +-
 fs/omfs/file.c              |  2 +-
 fs/udf/inode.c              |  2 +-
 fs/ufs/inode.c              |  2 +-
 include/linux/buffer_head.h |  5 +--
 mm/filemap.c                | 84 ++++++++++++++++++++++++++++++++++++++++++---
 15 files changed, 103 insertions(+), 24 deletions(-)
---
base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
change-id: 20260218-blk-dontcache-338133dd045e

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>


