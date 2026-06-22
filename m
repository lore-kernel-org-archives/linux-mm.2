Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09ABFCDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 19:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AED76B0096; Mon, 22 Jun 2026 15:45:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85F2C6B0098; Mon, 22 Jun 2026 15:45:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DA9C6B0099; Mon, 22 Jun 2026 15:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25AF76B0096
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:45:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7569C166121
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:45:38 +0000 (UTC)
X-FDA: 84908578356.04.5F834EA
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf31.hostedemail.com (Postfix) with ESMTP id A884120004
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:45:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=QgoGMeqM;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=aft2ZknU;
	spf=pass (imf31.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782157536;
	b=ExGly63+uIlRCTx2G9aOjtOOxLALxwk0oxN6hgnNBI6xUskF5/2xS2EMJgvHdzQNT+VzLm
	yFZCx1fm+LH2x6MmcXOIkyhxHzD00d5N6p4asDmQi77wYXCXcKmQGb4ocRuJc9ounwTMAC
	ZYcjxBFrvpKNeTv1a+QlWLkG1aC1fHM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782157536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KjoHWP/GNd8XzkURSsjarJERcmLz0FeprGXlq7m6kmw=;
	b=B1wyqwIZm6TcnNBfHuicPzgp9Eq4tJ/3EGPNwwy4+oXXUOFunc+cLefHVYJykzpRi3669q
	fSwMgp+95D/4pcMEonAS43TRb7e+Nungz3PChFQ9S0SM60/dND0JURZVMCTZ7+87AVIK7R
	pWwC/lggtatyqcXnayQ8eJJzcEOEJhU=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=QgoGMeqM;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=aft2ZknU;
	spf=pass (imf31.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65MJbA5x2205753
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:45:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	KjoHWP/GNd8XzkURSsjarJERcmLz0FeprGXlq7m6kmw=; b=QgoGMeqMygnqk2Y/
	joGIOnPfDp06RjLx8Df6pM0vBcNl5GbpKU5S33Bs0SIAJLQ6pTovIWZ5NqQ6CXDo
	F/J9Vx4RaeWCDHgi97HLJ3yVOmg4do/SMz7fIBes++CZrkW2cCkeaJ8fbaf/HuVK
	avK3HNNor+QK8q+mbhnmE1cLRbp9CxZ9jtBijcAyEVHF0L1+9ythRuMz3oYcuBxp
	8528JW9aYMK8PLg4k9Y0coDTc2P1Ithl18BYKzFCv5hP/cnBEonlrrb7G9rp1CZr
	ZRwzaePlQEUKLtPZ3pNJIHloTFG4HI2yhA4Foh54ES8o4upQcKASI9HDw+pCOmuF
	S3pPVg==
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ey6tms6hb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:45:34 +0000 (GMT)
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-7df25ce3000so106594127b3.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:45:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782157534; cv=none;
        d=google.com; s=arc-20240605;
        b=B5/38wYk+fhrZx7GXlxvry3KTXGjA6TB+Hp4zOydTE0mwIbYSfFbFBfGumDXyr8SMd
         ncLH2gKMCIqZEe8X/JHhEMAPAgp3WHJWj7ky5NqCvfZIRCaAjdQ/1Ze+dT/miGywa1Ci
         jim7GZKsO54ny+rLtu/bo3gtNQcUCqYc2J9Hd8FzoUFCrx2qBqzUcWsb8EPHsagzCCGH
         4GQPA1i0HfqCYJmwYDLD4Kal+OCnpFRO5cMfPAJA/VVB8ulC8q/+4dUHm8e9AzR8NMsU
         Z4vXRbBVh8nlcnC4oAqtfaHwQ1PLi+5WjCmEC2sirRJUHySXdKCz9VrlQXnW5pUmQhi1
         HGjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KjoHWP/GNd8XzkURSsjarJERcmLz0FeprGXlq7m6kmw=;
        fh=sWGkgon96dKr00cnjLyFWMbbYTBNro5SxgJ2z3TF8/g=;
        b=Ixl60QtGvkZ+615PRuARu9iB6d42HzYFd3P2OV/WbLSKor2xJlquWFDz9Saxyvkqby
         sYeQuZn7gNcvDRnibfcoCEiYXY590RcDPcWyfsqcG4KnhVgVo1V9JvR3NTfDgPwFCdwS
         MLncIRck43v7Woee9pJmFN8xQZjCkpSsvP7/D9oUrpqusnjyHUSMgXILAdayAXqbtP5z
         KxWooioFnWYXoIEPQscmgtztURHmq7Hl9csmw/uHUSu9YurnglAxPurT0/bYyfMPwnZx
         Gs1jRq/b6oqOon+fujXP01EE1+XYLoP1uYI15CV0OKKAvz2h8M22uuzHrUHlWvzp16Vr
         XFxg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782157534; x=1782762334; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KjoHWP/GNd8XzkURSsjarJERcmLz0FeprGXlq7m6kmw=;
        b=aft2ZknUyItOeazS1nc1ZzigTm6BPIbVb6enO6C5IR1lmY4gA6yGf+FihgxeDdZNlk
         gn7auC1RBKVsc2G5B0IvlIY238DUodcLkgVDo1Fau3AQ94RMUZyJ1LwzldFWZbcfd3DJ
         fdGg0tThvC0W/3WHF1tzM/n2LDKvqib1F+IOHT49hB4umxWxhvgEMr8UCQSjGOCqMCN0
         9wAJ4EC0qqAUZy3c8JnUcaiMf7syhj4bkuyTJ/Ctu7J5RuptuOdPMtRQQx4yCTADjcoh
         +jajyvB/RmQoXHAr+rwvnjQTwCp0f+O+aIQw0OEvsAG2BiAM77Ks9utWSk9kD6SS7Cnt
         EMRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782157534; x=1782762334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KjoHWP/GNd8XzkURSsjarJERcmLz0FeprGXlq7m6kmw=;
        b=pQrGdnU9/MD1+qO5VyW9yqCFqJrQFoCEY4hfbvrIY7g5Go7KXGN8E2dvEYTK2o3gLR
         htZIp/WAgsiangWeDnKFoAAgqjV1FC8pLUUcx7KY2E3DVosvUZ7K8ETw6yZOATazubAp
         1iFbB4RMfWXyIfxOBe913/x9Q/bzzJmu7i4TXoV4AEUZeDWHUgvIFK07wqmBsRIZEVAG
         hBH0sbK1j7LLtUHjy82V68smUEdUIvcqeRehP/zq9Klwa/wKe+hV6xDITf7DqwqyUgsc
         72Es9/tTrTQjNN7urLNrG+16qGPue4+wdA8fR7uVlwlbz64lDflLcAeG4BcYaFdQrM3N
         103g==
X-Forwarded-Encrypted: i=1; AHgh+Rql1wrZvxara1ErGmExwI9WCn9MdChA82CARXLv1gAfQabnewzkJRZ8ZAVs7cuHE6NINmKD5YyCaw==@kvack.org
X-Gm-Message-State: AOJu0YztAHfyx/FDFWPiPD4WxQPaPEI+i/Isal8us+6pYEL+GKDaX/cr
	Qbc3+TKlHNe6AsZ8GqpGdWLt8xV7OkiiwcZugsMJ4AKvujPzPexbM2wfdd5UD+wwlbpzMx0C0+O
	rF1VxTqEGwOeLMS+gZ1F5Iyb5zhxBWg94cQG+rXHtiPg7DQe76onq9fBnJporqSoCcQMJ/maTmP
	ooy9Lx5Q5jcz9WagkQEEmqczOe3riv
X-Gm-Gg: AfdE7cmiAd25sKD+fTjiOs1B62E4Rxci9NZJUkIrr6wabIxH0snFbgCjIw4rsW4QBAA
	oifsmzsvP4JEu63KDZa0NRVhKkPnd45x8MV0tOixfyAnKJ6Atdu5U/RGMOURoTqk6NdTq6tvN3x
	X8/pVEggHbeDJ/pWezK1jsGPXy4ZG6fUt+ihSHhWDZk04Xdl99u25PUE1wU8H6DZpmMnwD
X-Received: by 2002:a05:690c:b14:b0:7bd:577d:7828 with SMTP id 00721157ae682-80134c787a7mr171856207b3.31.1782157534033;
        Mon, 22 Jun 2026 12:45:34 -0700 (PDT)
X-Received: by 2002:a05:690c:b14:b0:7bd:577d:7828 with SMTP id
 00721157ae682-80134c787a7mr171855877b3.31.1782157533540; Mon, 22 Jun 2026
 12:45:33 -0700 (PDT)
MIME-Version: 1.0
References: <6a396a5a.ac26f6c2.9a9c4.0000.GAE@google.com> <88AEEEF8-B9D9-48C8-9069-00E8528BB619@nvidia.com>
In-Reply-To: <88AEEEF8-B9D9-48C8-9069-00E8528BB619@nvidia.com>
From: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
Date: Tue, 23 Jun 2026 01:15:22 +0530
X-Gm-Features: AVVi8Ce2VS_LW6HKwQlFH8hNBHkfiSM0A_5L0419nLeoXjFofdIM8pmW8_DIuuc
Message-ID: <CAEuHeqQ+AcNwQGB0a+Buqfs=_S339UD521ryez1NGmwZ_e0Jcg@mail.gmail.com>
Subject: Re: [syzbot ci] mm: page_ext: add count limit to page_ext_iter_next
 to prevent invalid PFN access
To: Zi Yan <ziy@nvidia.com>
Cc: syzbot ci <syzbot+ci8a7f89fd8f70a458@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, david@kernel.org, hannes@cmpxchg.org,
        jackmanb@google.com, kernel@oss.qualcomm.com, liam@infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
        luizcap@redhat.com, mhocko@suse.com, rppt@kernel.org,
        stable@vger.kernel.org, surenb@google.com, vbabka@kernel.org,
        willy@infradead.org, syzbot@lists.linux.dev,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDE5MCBTYWx0ZWRfX6iHoxpJVYZCD
 C8NRxsulR2GT12sOCGbYVBGkIAjpgHkiDEcKfTeme0naTDApRon6o/fs6NTjF8mfe230CbEmof0
 XWrUzTM3Ai9XrYOr088kTDa4Q/umB1U=
X-Proofpoint-GUID: RGS5eiVP-vVTvrzv3Wyu0I9TpGmFbKPl
X-Proofpoint-ORIG-GUID: RGS5eiVP-vVTvrzv3Wyu0I9TpGmFbKPl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDE5MCBTYWx0ZWRfX9YceRjbRQlIg
 PXYonwo18XDKC913csQ5LSnl9mJ9k+UMJfIPORAvl2f9jgw2a94dwedifPqjsmNFhQe5hgYc4Xz
 qER66kqeQFD+fT/xnbbIAiSBa3txt2EHhQGpEP6TPFjtD4I62azwoi8O+5VKweGpkHYtdXf+k5A
 dpPvWdikXhIsgZK87jAwDQDzCQxl4xamNKCMebm0FDTKqjiBx3BgOvSfGGzX5iZPvapkHzX40UE
 GcFTtX//Q/stxig+C1bnHVAw8M19rsFf9sszqcBXSkQhxC0JE140AL5DBlmNbu5K0bo9ROBhaGz
 r29ZQu6NGKlcg/cgB4B+ROapxQQy/QKLLtG0vUfNERdNFm3BlvtszK3wxeIEP9RfHT5ZIfCuKR6
 mOIzCfPlxXnwXIq1VVmeqSrxcYBSveYyE1cynXTnK8CSxLcqfMU7qQI+UabmfzQtktQK/F+5Uuk
 DRUeQi0u6AprBUw8Agg==
X-Authority-Analysis: v=2.4 cv=H4HrBeYi c=1 sm=1 tr=0 ts=6a3990de cx=c_pps
 a=NMvoxGxYzVyQPkMeJjVPKg==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_glEPmIy2e8OvE2BGh3C:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=-ibLmwfWAAAA:8
 a=Oh2cFVv5AAAA:8 a=Ikd4Dj_1AAAA:8 a=hSkVLCK3AAAA:8 a=4RBUngkUAAAA:8
 a=Ddikh3kw0lfEB4zVT9gA:9 a=QEXdDO2ut3YA:10 a=kLokIza1BN8a-hAJ3hfR:22
 a=A6MkUVyZPcTV1i89ro0M:22 a=7KeoIwV6GZqOttXkcoxL:22 a=cQPPKAXgyycSBL8etih5:22
 a=_sbA2Q-Kp09kWB8D3iXc:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_04,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 clxscore=1015 phishscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606220190
X-Rspam-User: 
X-Stat-Signature: 4e7yu9gjdjmopy9rd66i4fbhcf4cwjzc
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A884120004
X-HE-Tag: 1782157535-400374
X-HE-Meta: U2FsdGVkX18nMi3pJAAIZtM5BgC0qOn/LVE2NeK4s//CMp+ps/uli1ZZ1EqvdZGGozq1axLJ6nwkYsRgfNCMKYI6zdpeiwJHeXKOzjVd/T0cdja0Cszk+wTtIIoNr9+PpuStF1ogDWFRW84YQ2ktqSTSAXw/hZ1lc2uGHYv+/y9i4VGnXk6kk8kgnPoiWfN25hc/wwClfEGufUe/ilq2A/1uTdnCY047wp79iFfMJP7Yp0EnmX6i0ZRG7viuk20yuMZo9cCuHt/HadHufLkAgSFc1u2jTyWdrX4/y2lnSkkdN8A8Alz++LP4755vkwQOK2NC8N6iBPmIA1bzmYAEY+CMEqxy1XUIbYziDa+wwDBmRCPYuUGS/On2PTacTgvhY0CqGTvbVbqwsD0zvcQCNTGsJOH/o9w5uXlb4wS4pJ0EcL71zew8kN9VisOx+39GT0ze4N+kOXIpYDuc2zRqBj6Tq+xdFImx0aPYgmYJPJuyZ8Fs3f1oF4eKK63cl7azzVNTpDOBWd15Cml+2mgrbksNlWWQDAZT3HI98CwTLRVfK/+u7CwzJLLLYIrM4tVs0heDGdAhqbzNyyQUD94dOj+ynRhHoe+ttY5z+x+G7BLwLcGC7F63FykCIO4L/hd6A3gcqEpLy07KJy2TYjyoUjfJbbl2qHXT8xx6/Zk4x3hSNKFveFeT6ZawpeBdnan1lGsZ7t1tXmGYMqSjU7/+AYNsol2ePAyYqRT9CrtDXZ5a2P3Rh8KCUj1c9TTUPHuhxyTNfWbTDnC2LmpZK3hOc6EEL6sRfM7jzZI0gbiLnraOFL5d6okUpgVI2YoBr212U8NV4O0996Vh5X6dAncbmp4tBRfQTCHUvj/O3fJHUNDzGviBvQZ5zwBzepR7/qXE3WTo5BD60YQVS3cEtY7+XMoflavDPyvg1j3BUUhlXtgvpvW6KIiokvT1lbBzdzQdWXS79LYuQPRy4AjkhM1
 oJotQqQo
 uYYLc7whVhWxrkwcGyv+sFYBJM7EYtou8ixPFLOxYpKo9IS4LE5Yq1UGrB7tmQSwu6hhzOvhL4MFF7zHetnY+XoyBRu9wkEv0YiosQJdHh/fI4tFd8qzH8MeX2a3YN7kFDeOUuInkVurv/MptCSBvCFJVOqa8R1yMcST9Z9AUdMXLnQIhww9ViK1oeN+PSqh6UR23n/za8pPLZPd0xIPyWauHBWm/OWXNAVkDRvS8Ei4+/SiiCEDXgZlrEd143+68N0igIxLWftf/bFVlmod6XqSXFQfouB07s1UkBft7BoIf7vVUrAXUtaVLnnjGbIkWQQ3kOLJqNvhrHSnGpekLI4/ggb4TNzIV58HjGHdmD6BM9l3OkRiELSHT9v0Iah+Hn3eElVG3hgoRoD4/J1KEgHCMeJ7+bOSq2CQZZdIf+QT8HjO4maCC9oZVaONy8rHsZLq/edK9nNlvGjIId7QAkm5g+mGxQESYG32fRtTGaPqRUSn/8eqTIY3ZA64XMmYWBwfQO+K2OiB93734SopGOXF1wSHs0bf3z60DUwjs8mC1Ye2hLLdefwP/LZWzKsOlLWgFoEZxniDNQuX2yoMF+xXg0oYkjKqWB0A+WnbMLaraLoelbC9/cFtQh+oo67Iu/w06hcqFMNGVvX6+e9JkvzJV2hFI9WxHjPUk2Cmhjc59xSVEGAjbAx++2NymTvEjxNep+aASymu9MOGPP6ObYqOCLsLSvrHUL7rDhdB488ix6DoNUvfKl4kmnOpiNmPDF4IuOgDVOc3DK+IGM3PjuRt2JwuU2t6LJqsk5vx6B4MAupH4sCKY63pqTFdAQre85DH2JfZ93kZ89L8PMgz1Ne/w/ogmdpCuMBjb7lNtR6+O77/++ywyjdTBblBys1lWDFdeOH1Us+POHbs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thankyou Yan.
i missed the post increment change from the last v2.
i am posting a v3 with pre incerement.

- if (iter->index++ >=3D count)
+ if (++iter->index >=3D count)

i think that is aligned with the fix you suggested.

Thank you
Ketan

On Tue, Jun 23, 2026 at 1:06=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On 22 Jun 2026, at 13:01, syzbot ci wrote:
>
> > syzbot ci has tested the following series
> >
> > [v2] mm: page_ext: add count limit to page_ext_iter_next to prevent inv=
alid PFN access
> > https://lore.kernel.org/all/20260622-page_ext-v2-1-135d4cfbc42f@oss.qua=
lcomm.com
> > * [PATCH v2] mm: page_ext: add count limit to page_ext_iter_next to pre=
vent invalid PFN access
> >
> > and found the following issue:
> > WARNING in depot_fetch_stack
> >
> > Full report is available here:
> > https://ci.syzbot.org/series/092dd7dc-cb78-46b6-8703-6044fff2631d
> >
> > ***
> >
> > WARNING in depot_fetch_stack
> >
> > tree:      mm-new
> > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akp=
m/mm.git
> > base:      e1201ff76176ef666b13d1a4ec6b6190ddc6abc8
> > arch:      amd64
> > compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1=
~exp1~20260514074407.73), Debian LLD 22.1.6
> > config:    https://ci.syzbot.org/builds/18f461a2-7098-44bc-9d42-634b56b=
a48d9/config
> >
> > ------------[ cut here ]------------
> > !refcount_read(&stack->count)
> > WARNING: lib/stackdepot.c:517 at depot_fetch_stack+0x91/0xa0, CPU#0: kw=
orker/u9:4/1114
> > Modules linked in:
> > CPU: 0 UID: 0 PID: 1114 Comm: kworker/u9:4 Not tainted syzkaller #0 PRE=
EMPT(full)
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-=
1.16.2-1 04/01/2014
> > Workqueue: events_unbound call_usermodehelper_exec_work
> > RIP: 0010:depot_fetch_stack+0x91/0xa0
> > Code: 39 f5 72 d0 48 8d 3d 7e 1b 4d 0b 89 ee 44 89 f2 89 d9 67 48 0f b9=
 3a 31 c0 5b 41 5e 5d e9 87 67 b8 06 cc 90 0f 0b 90 eb ee 90 <0f> 0b 90 eb =
e8 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90
> > RSP: 0000:ffffc900079a6ce0 EFLAGS: 00010246
> > RAX: ffff888168b94000 RBX: 0000000000000ce0 RCX: 0000000000000067
> > RDX: 0000000000000000 RSI: ffffffff8e215937 RDI: ffffffff8c28ab20
> > RBP: 0000000000000067 R08: ffff88810495a407 R09: 1ffff1102092b480
> > R10: dffffc0000000000 R11: ffffed102092b481 R12: 00000000019c0068
> > R13: 0000000000000001 R14: 000000000000010f R15: ffff88810afb1dc0
> > FS:  0000000000000000(0000) GS:ffff88818dcb5000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: ffff88823ffff000 CR3: 000000000e74a000 CR4: 00000000000006f0
> > Call Trace:
> >  <TASK>
> >  __set_page_owner+0x140/0x4c0
> >  post_alloc_hook+0x1f9/0x250
> >  get_page_from_freelist+0x21fa/0x2270
> >  __alloc_frozen_pages_noprof+0x18d/0x380
> >  alloc_pages_mpol+0x212/0x380
> >  alloc_pages_noprof+0xac/0x2a0
> >  get_free_pages_noprof+0xf/0x80
> >  __kasan_populate_vmalloc+0x38/0x1c0
> >  alloc_vmap_area+0xd1a/0x1420
> >  __get_vm_area_node+0x1f2/0x300
> >  __vmalloc_node_range_noprof+0x358/0x1730
> >  __vmalloc_node_noprof+0xc2/0x100
> >  dup_task_struct+0x28e/0x830
> >  copy_process+0x79d/0x4380
> >  kernel_clone+0x2d7/0x940
> >  user_mode_thread+0x110/0x180
> >  call_usermodehelper_exec_work+0x5c/0x230
> >  process_scheduled_works+0xa8e/0x14e0
> >  worker_thread+0xa47/0xfb0
> >  kthread+0x389/0x470
> >  ret_from_fork+0x514/0xb70
> >  ret_from_fork_asm+0x1a/0x30
> >  </TASK>
> >
> >
> > ***
> >
> > If these findings have caused you to resend the series or submit a
> > separate fix, please add the following tag to your commit message:
> >   Tested-by: syzbot@syzkaller.appspotmail.com
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > syzbot ci engineers can be reached at syzkaller@googlegroups.com.
> >
> > To test a patch for this bug, please reply with `#syz test`
> > (should be on a separate line).
> >
> > The patch should be attached to the email.
> > Note: arguments like custom git repos and branches are not supported.
>
> #syz test
>
> Best Regards,
> Yan, Zi

