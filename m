Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAB16CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FB5D6B008C; Wed, 14 Oct 2026 13:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F2736B009B; Wed, 14 Oct 2026 13:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BA526B0099; Wed, 14 Oct 2026 13:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6356B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:08:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C2C83120599
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:08:32 +0000 (UTC)
X-FDA: 85321865664.04.A3B65A0
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 05B3C40008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:08:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="nV/mfdtJ";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=4Z5PE1Rw;
	spf=pass (imf17.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791997710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OQYG6p9/H5SkzSVfBEy5FmiFS3xl893haPgmkNoad14=;
	b=VRtmSrjpi9uGPZZbeUfZfU7iqDdL37OjzMCqjKnO/eia7ghhLcoVJ2PIkiVAhERi9IBAeh
	S6UDjf9bPh24UyZ9sG7b+58egWYYSApeRP3CHPm3YYLFpv5ty8dSIhoPudeMb9dW4Yduex
	HG4IElDl6A8aGqOFK5YBHoHl0aT5x8s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="nV/mfdtJ";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=4Z5PE1Rw;
	spf=pass (imf17.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791997710;
	b=7Vu7IifPix7bCY1BaKkBHelyp/4Rdpg5ffV208W0uEuyVPrQ3d5jY9R0/NlL/waviqxszV
	E1/d/NMnn4KKxwdqoLpsVu+XXUZ9PIY95VPmdS9rjvaVdRY2UktjcDKQYQo0fpLiMiiZT9
	mOBizQrwr6JRSMu33U2UQrbGmykaCY8=
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EGYMwZ3005096
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:08:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=OQYG6p9/H5SkzSVfBEy5FmiFS3
	xl893haPgmkNoad14=; b=nV/mfdtJwsdyFL48fZCD7ZGmuZMxwCLeQp5SnLo8Lr
	A8cRDwhYtsFiFAuQH7Ikk92CodAg8WQbgLRqQIk9zKPliDx4C7eYsoB1ByrV25l9
	Zuqhcq682ARPB/qBej31x9aKOdCqPUZG3Z6FzuxWoR/NbU6B6BqFcqw8hw8Mhs9D
	5U1XLcFU1S3YVZJ/S/+nT69vmXHjnM/oaptBGwYGodNSgGKFmBsorxJIDAKgAMB8
	NTSMs5lRFcvLLmrWkN9QPGoC/iLWQZCg5vxbghngY4GJrVx+qo0gS8Dy3ZripYyK
	0LNlWWx15nphWJ9OOzmyG8AjLAp1YTmBAEM0siUe07qg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ha83ekg3m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:08:28 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93ea9ea9d13so103903385a.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791997707; x=1792602507; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=OQYG6p9/H5SkzSVfBEy5FmiFS3xl893haPgmkNoad14=;
        b=4Z5PE1RwZPhuA0ZqvKqWhHwoJJacdnwF9fcsDXgDRx+opwJjUkX7IeQzACzhv/plAt
         RLvM4Le3dyI5N1l824p2qNmdRq9kc16fGHI4q6VQzPm8ZRiBzCdCXwQTNewsbYuWOIvL
         9XtCvc8GhOVPL0B946cBNtAuCxWivaMLRq96j2XZswUj03q7wMCzAHt0BFmH+LM+WwvC
         uAZAeVRYkoorzqBHgn0IpQUdvIU1xV8iggMic6wCVhJRwYKG3nTLf5Ruczi8zkaR+Sbq
         fjvs9/v9HnsSCw3FMUOXMheNPylftuSqFtFejoDzzWbG/Q4PPEBkMYSYrc8DrzG6Xdme
         hP/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791997707; x=1792602507;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OQYG6p9/H5SkzSVfBEy5FmiFS3xl893haPgmkNoad14=;
        b=FL3fJp3uuLgIJOBLmLuL+JtlWWV7KvsMWuxE0NUL9y/PiYBbpp9WKz8H94CohWj9/i
         1EKuj67RNg02yvouR/t+XiVckz0lL0V2UNbTXOCmEcC+jQGuswLbUM/eOSXrdQXlUvJN
         rGwZ/+XjiImoY+t47KhVpMpnH6DT04DITj3+g8QMayA8fqAS3j+lzDTgQ02xXh+rl01b
         VnP6TY7mVPru6V7YNxRNxoCiBHiKBwyHaxzLay0mus7eGTpz9+lcb9KStaz+nvIqCpMM
         /+uEiJkVZFqoY3JCWTeb9pq5iwm7fbIGGYv6X8jCmB6rfuIFDucWQVApV0WuKhM2Eila
         SbFQ==
X-Forwarded-Encrypted: i=1; AKwUvBxWaqAg21zdAR/nsJjqv8ov23Dl4VClCLZNY8AxC2PBLhdXmW7LwK516vCYptPCZe+GoJ91h9T8zQ==@kvack.org
X-Gm-Message-State: AFq9FYITBm9euPXJWNWYENYh42LauZECjfbTBfuxwRYIQUvKKhQZ1kfQ
	j36r9+YrUNIUpdIOW9xgciq3nQFK7KmfDqyj23mGzLR2+Nid9eH4fivu93GVM4imB0vZof+Xg5R
	InDGm7IW0uUcea8f4ry4WBYA6x9/GbxaCvs9veHEoohVkMuWWxraNhpB8
X-Gm-Gg: AYBFou0akx1r7GHS+QFiUI+kzsk1mgCeTnFZN20iXGuNNudufiU5ybEmVhfnEsotBSn
	lkod+gv/QOiHt8QEKgYAspL+4VilJbqm2nkrcU0cwFKHBElcKgbtCh/e7TXexRrDZJb/ooejdPC
	tv7bI2rcIb66Krsl0j1OJSOXEPII36ApiMfFfPYGuFjSc8FG2KvfEexXXIcIiLhcqhEcqHmzHh5
	7MC990caQYK0YYmG4/S43CDpuGw7KPB9d50RpI331ap0cLXdioksbgWm6nd0quHBNKmPzUxEAoQ
	N7udMMDyqCSgCsG6k9JRVG+L9OdqED1+y4HxAv174nd8Mbx2N68fEHFy3lh+d1F1w4c2fvYaiw7
	LxvoBY2VQZKtnQI+aKZn/KZQQmB4Gq0r5MrAX4A1cwXmQpUs=
X-Received: by 2002:a05:620a:2a10:b0:93e:c12c:9b71 with SMTP id af79cd13be357-93ec12c9ef0mr2595933885a.76.1791997707359;
        Wed, 14 Oct 2026 10:08:27 -0700 (PDT)
X-Received: by 2002:a05:620a:2a10:b0:93e:c12c:9b71 with SMTP id af79cd13be357-93ec12c9ef0mr2595924185a.76.1791997706379;
        Wed, 14 Oct 2026 10:08:26 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-148.net.columbia.edu. [128.59.176.148])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b9bda8643sm49190116d6.25.2026.10.14.10.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 10:08:25 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH 0/2] mm: memcontrol: remove two unused helpers
Date: Wed, 14 Oct 2026 13:08:19 -0400
Message-Id: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAO3z2oC/yXMUQrCMBCE4auUfXYhaUsQryI+pOnYrtgYso0Ip
 Xdv1McPZv6NFFmgdGk2yniLyitW2FNDYfZxAstYTa1pnTW25wVLmLjEohg5+TqY8UzIyqHv/Nk
 5wAye6j9l3OXza19vf2sZHgjrN0j7fgBGmuYZfQAAAA==
X-Change-ID: 20261014-memcg-unused-page-helpers-c43a866ee0ba
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791997705; l=474;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=18W50nwXyn7U9V9smq16pS1vshVmIOIZSXwkdv6O84U=;
 b=2aHeCLrlYlAv92xitm4F6gmPMcrkqJ1s19K+DNpvY47RTbxe5YJ+Y3C7BUgCYLBnYmZyOL5E8
 6o1NOqbqvThBeksuqYPHhAjtt0c+kANVTXW9anNm+a6Yw7hFwcwN4+Q
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=IaESymqa c=1 sm=1 tr=0 ts=6acfb70c cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=dxtdfZqDOO0kCslK4e47hQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=YtfsaVvi3jZCfUEAq8QA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-GUID: V-w4voJss7tT6PffjGgEnydbMKH0-42Q
X-Proofpoint-ORIG-GUID: V-w4voJss7tT6PffjGgEnydbMKH0-42Q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA2OCBTYWx0ZWRfX0pK43ceKAhCu
 RhRTBdzuNvJG8JwaJ3zGPUK4IrZmC5qIrYa6zPQQE2XqPGsx43YspJWDkRXG6C2cuzdUcYUizPP
 5TTMhTYmmAupkR8zdIr0RE5SQLOt16Rc3ngtDcVa2dX7hpEd5KKrh3xs8z4FHkAaEdkNckgBpO6
 nsP/YHaARomVwW+ISy2zvqUFWzzw5+zsvOZsQ58UuzrC3PMHrnzFvfuIGw609rrowfppvClGfv4
 TA8Hd5XQFKyWd8M+E36Hi89vOAoSHwhIO0NTW3+s2k9a23fQSCkfH5NYhOoBZFD/IqWLr448hKy
 U6+oCWBn2wTNMhtJkR8QgkdbwNv5VkHVgJvTxU/X5MA+Mxvyvp844KluWUjJNz8pcZBLQrTFvBC
 leVcWMfHtn+wOQ62fnTy41216Ctz8E7xoUeU+LdE1JPV9h+qgNN2v5zzV9QpQ0ctRJ8AFP42d8t
 wjNunJDkfLubHF5ZIZw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA2OCBTYWx0ZWRfX6WziNpl+nuT7
 Zsgp9Oon1zvqJYWvCGFu7Ky5nhZ5vtR73/of4FZwtzCKHwEI0qFacnxANHhua3Hi0/gIcC1eNGC
 JfmJ4CkY4l2jZCUuc1BOKtVK/VHaj26ClG1PaCvmwANnpWdLu39h
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11935
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 impostorscore=10 spamscore=0
 lowpriorityscore=10 malwarescore=0 bulkscore=10 phishscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610140068
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 05B3C40008
X-Rspam-User: 
X-Stat-Signature: 51kio8pqumhwrofqiuo51zapxh9i6qte
X-HE-Tag: 1791997709-839040
X-HE-Meta: U2FsdGVkX1/j5w5Q6kxfYH0mtJxSrLOSL6HTHBF+NIRA7nzqFz9j+SsbEPnDnsRKKwzSrav91cas/jqRXmQ2rJ6syBQ71ZhW4mi4bt0DUPhf2c9Ve3/j6QSzgPvybchqB/RK/YJl8XKnjtql+Y7ufSqjnB5iddsMEb6j6mcNo6HALFbWArp0h3tK+rLY5cmdFCvVY8u6r1/x/YZQZjMEWWHL9BY9/cIMNMcEgbDafTLHDTg4zUmf8vLBVTIF/dU16WQHZQY7Pgpy2XPpF7kxxZlj77hssQNtGseA6E/3/VNa4qoU84on592vjQ+oP2S0NSVdoOnSGW6VNpMscwa3tokT5FiB5EUk84cxKUKGMAaMH35LYcPNbM3H1HndvqdwlCfGibAiKJZz5DNS72UB4cboVSerevPEnaHBcNXRcn/ui0WpX85Tb4hj7n69QNQhmXW4wuopIjywQiDdApZhRiNAzbJimSC3ba/TXUOiVC/Vl0klEv7aNpFMU1EWmCjPll8AAt7/AWl64vLid+OWgW5Hd5PBQCNSDu5IBi2JY8BmI71aW7/A38xknOetFOSlMEszIhUFAM44Jv91u7yLws/SdoBURxQJJDR2lwv+R4EwkeOGqIodVZLSrjPx7XODtkAxnjcXeLky9aKWpd92INc1NccPBnXgYbEgh1QRdmEpUDPL7DSpGsflbBXmgF9lCKg2WxngofdmKUw5OwjyNgsFC08oerF3kT0VfMNkLmkdOQHu75bHLjBhH+k6Qbq61YgicV1hUy5VfeTV9T9ulOJZwZdOcSisvKbs7rL+cOmVgGVtPQDdAv1KdeyjVWOnxnRX0GYMLMJDzi/lGwYLswzXv+D766YeQxRiNiFQ+UUVVEfGtjAT+UwrfkI/4INFIgIQB4KNltGwzJzIWDfXlkoUijcH/nR/VU62dnsN41yTOWgLvHAc5CgacYA3xSBBoIHsZzsdnK2fChv09S0
 /9CQiFMH
 v0ndTia1t88RLjF+oS+rs5Va7Um8UJ5DZwymTXW/uHjPsnbFnrABgUzs4n0ZaP9yE4HBNYevY5XFcEynZHxjWk7YkxLSQuJI8bNT6alo2C+pAc9lY/zm3M2XbXwlkxT/+nN35rUAhef/CRU1B/MksGkg5Af1Wl8AxOLg/jIwqun5f6+MpNHpnLJA/E12Q30v/QzGkIBq6l3ro6/1YOktCOOzkGEs1KHHAGT1o/0FDYjX+Uj7K9KnTk7cTskGvyHnWzq9ahqFznYhp8O6tVIGDi7AQAJlaJyuO4c3dBT/AHsgvgUFMWrv+gmo2jdVErq/QEBd31eovIe3aAuBhZXTCsvOmfU4/pyfi+aVIyRCFc3oCnRu5ptSoulD7pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

They were happily unused until I decided to disturb their peace.

---
Tal Zussman (2):
      mm: memcontrol: remove mod_memcg_page_state()
      mm: memcontrol: remove page_memcg_check()

 include/linux/memcontrol.h | 32 --------------------------------
 1 file changed, 32 deletions(-)
---
base-commit: ad9f2d463666c64e94b04be5263c9bf8f9f96fb7
change-id: 20261014-memcg-unused-page-helpers-c43a866ee0ba

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>


