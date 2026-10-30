Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA2460A6F44
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 10:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=NGPwwBpS;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=wAQrMb8b
Received: by kanga.kvack.org (Postfix)
	id 8E4876B05B5; Fri, 30 Oct 2026 06:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC116B05B6; Fri, 30 Oct 2026 06:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AAB16B05B7; Fri, 30 Oct 2026 06:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55CFB6B05B5
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:51:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF9641C3D5B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:51:12 +0000 (UTC)
X-FDA: 85378975584.01.7566CC8
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 71241A0008
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:51:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=NGPwwBpS;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=wAQrMb8b;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793357470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJBs0pTceSyS3PVExgZo8XWqzDRyuZNRvwKFnHo9xDo=;
	b=43f3rcfQF0pVXh8a9nrtp7W25luqUSptfErWCyBbAYOq91DIhjhQ5MMX2E0vqW2/AxKefv
	5ypK2nQ3omKieHyiOJVwNiMu4IuERRycF1Xy9b881R8dRsCfcPcwHVdHYQcyG/E/NN30Wu
	c1iuF0cDkaAJaGYW0TZ3D9NJLo/Y6Io=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=NGPwwBpS;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=wAQrMb8b;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793357470;
	b=hCq5hubq9diqTJOpadr10MDjyPtBw2DmdJak2ucAiQuMZN/ynBZimVYBvKtxbYTmMpy276
	uUUSs7O6xf7nE8m9b2ykrL6tYBZDydrhDWBvTI1Dk4HsYnDcWgHUBWTqmQTtflmy8qx1PM
	Di+4IxAGLdK1k5GZnPGFICiGP+ctJfs=
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UA01ce741844
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:51:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pps01; bh=tJBs0pTceSyS3PV
	ExgZo8XWqzDRyuZNRvwKFnHo9xDo=; b=NGPwwBpSza0naj99pmHYtUOK2/1y5Nl
	brTuCIlQuOr8r94RfzFS6dZtQQPIoQGBmcatz6wMpru2KOpH2S9bYjpWvYRpAAE2
	g9kKT2qm8GNC5v0r2+uyv0DsZhy0hp8wtquvCW7Imu8Xwqh11nag87pKy9cRTLin
	ZmZqAYbIuxZm8IaDCV+x7Dk5IaqjnvmSmqd0Y3pMIyWM2+Lain2ypReU4AlYG4yv
	6aUIpscwZjfXETpIWw3e9eFWrrYOmO6E0JapuD9tRGtXzRAGvKasSZAECCgXq0UN
	oMxihv4MYDEdzVJOvoSzJDxla1kg6AHWlYICVmlIQoTQqxvszLwmfVA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hme7a2s4s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:51:08 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-542fc619afaso4829191cf.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793357468; x=1793962268; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tJBs0pTceSyS3PVExgZo8XWqzDRyuZNRvwKFnHo9xDo=;
        b=wAQrMb8bMRyAOAUw9yN3eWmzNwGTPsbcP8ZwMO9+tqeR33ILiurg9e0HvUoN5CfHyi
         PAu6mCOOHQReN9jkUJBWnlgrvu8dyxywLoDogz3lCfwejYQT9ONglsTg8y9VrLv6/PLy
         99QXv3itwuFRRcmY17PBn46i3WX572Neb+ZRlk2UhRXDncEEq3XJZt5OR9ZTu2pWYNDs
         PBUbnBuk9oZ25QF591mUbfV9+rRwkSLVm29pODkayB80JZfi98KqRYy9U1XmDPacZ+eJ
         FNz//NA0nj8MlL/i14kuVAieBxZkaco8OPonH2hlAYdw+iKAzSzxisJ/+Toaz5HvTMHp
         79Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793357468; x=1793962268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tJBs0pTceSyS3PVExgZo8XWqzDRyuZNRvwKFnHo9xDo=;
        b=Rxzq82Ev69b5h8W2CqppbEfOGjUu8Kc3wSXgJuby/0DEjIqUUvLXJxfLTM2VKVU/D6
         4owBy0/JLiHuLLCVIb67s5jko88MiaDZMMr2PeU9c+cnviSb8xTOGiHnHFnvwOdofvQR
         BzLDP1rh2bOlURhlrddx33gW4ia7aHPN3UNBYA1DM+48MbxkGX15WH8K0EhiMB5Vg2A1
         7LO1PO3vAvPjr0z6bJe9iMjVid6OwlB3q32XBRTHwN4+LIMCadfpdZu3xGH4SJLoK5rs
         vXjsTfNjlpJ/lJjEtXuasowStU9hvLGGqafo3arOnDj5BhL6xLyT6F2sPVen5yt6+YW2
         4PuQ==
X-Forwarded-Encrypted: i=1; AKwUvBylNls66+XO1En06bROrq3Ndbj0gveRaBH124QLaBZ+yhlZwiGeCpTlRF8KSQyVf4iGkvUvx3DKhw==@kvack.org
X-Gm-Message-State: AFq9FYJGLSJhIlaAcORIAWX3leVimNZcxefPCLK3XW4wefccITPpQc1z
	plYFDmKd/6Vl2msKr7Z8sgHJeLd6ysnLd+fs+tIr1OQ2oWqXRdyMjOZk3DYCxWtqr3EiOP3iA9w
	Ndq4sxgeAbmYXPSSYwL2IyuxbC54DJ7CYMEyLOyseszOZOnt3
X-Gm-Gg: AYBFou0kqkKwhiRDwwgskdFKHXhfUT1VpSPWjzXbh56Sxm8CgwA0TOOfHyjig8QhIIv
	3zP7SDgRsH5HSMFnlh6CGM2zJ6h3nKOlTHPZDnwPAbNE1jVos4loaYghfCR1dC6tXfOeK11lSBW
	HEUhYPGwoTkU0gP7TBSpYa5sxx4t5MYrUlzkjlrf9bpj/q7IiJl537AQpWVviL7y/y8BJNJhjs0
	vL3JKM7dOIwZ6N9+xK2Iiv4q2xOJLjIZ3VswgmBUFACK/eWSyGXhs6tBF+sYQNKBnCLS5YuY4ph
	fe5OxSpDSa7K1Gw8k8gYnjBwM0qqRRhroFoWhiwNno+Ep/cMHGAIsFY9ITQdkpeqlPkXQIw0dTw
	4n5hIBhctgwNtV3f/5cU5lyYvD+R3IhjSNN59jYjsfzetnUpyUxG1rTVs/B8/whxjl7cNjgIa
X-Received: by 2002:a05:620a:1a04:b0:944:3c5:ffd8 with SMTP id af79cd13be357-944216ee039mr321428485a.35.1793357468060;
        Fri, 30 Oct 2026 03:51:08 -0700 (PDT)
X-Received: by 2002:a05:620a:1a04:b0:944:3c5:ffd8 with SMTP id af79cd13be357-944216ee039mr321425985a.35.1793357467484;
        Fri, 30 Oct 2026 03:51:07 -0700 (PDT)
Received: from localhost.localdomain ([37.142.146.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf5b289f7sm51389245e9.5.2026.10.30.03.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 03:51:06 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
To: david@kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
        ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
        lance.yang@linux.dev, usama.arif@linux.dev, linmiaohe@huawei.com,
        nao.horiguchi@gmail.com, richard.weiyang@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mcgrof@kernel.org, liyouhong@kylinos.cn,
        tz2294@columbia.edu
Subject: Re: [PATCH] mm/memory-failure: fix folio refcount leak and min_order_for_split() locking
Date: Fri, 30 Oct 2026 06:50:22 -0400
Message-Id: <20261030105022.903008-1-tz2294@columbia.edu>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org>
References: <20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: dm6hKygkFKtza54QDmT9O-W4i4HR8BeY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA0MyBTYWx0ZWRfX3jZis7RSJGDW
 l/qxzozt5a/KqgZbXVwdWavaZRqwNXggS8i1lmv5o1dXa6LA+RCyKVJdkoBbLSOjN2j7UfsChXM
 OgiHI3iWquhnNa1zt7jHfb06uhn5JTYEHVL6V/ZDIdsnOddQccAZem0R3Vr1u6z3QGbz2YLEzhW
 NZjufmkZ6ghxHvEtURVJC97VBvVciD1wXoRMaON4yoWKefoMuE16Tj/QA/BE896WG3mPQJpOAzO
 s0GJbKm9YFugadNUKxD+COWEausMD7zlYsDdjhn5mVMeBpspY/ysYzDK+hcGF7LUvrtis2/SHv2
 fiq3vNse1DWgKB7B9I+4GZpkS9J3tdhdizW4StAGDCYh+a+SBGxMVmZippwjhK16C/KqyJdzO3Z
 I/+aaYBCgK0bLSWAlvpVYwKJBQaZTyrfxLrqay7Vd5jkjXlyeDqb/kbNGm4bx7lEsmvh5LZs9yM
 6nbiWcyvYI9h2GVVMHQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA0MyBTYWx0ZWRfX9wvl8GRAchh1
 ZivbU/HcKnHCgRDtPfFfHSNtobbaajN7LSCq17V+SzOQ0aW3eDlSChh+ge8Up0W+h29vrJ8HPE+
 UxrxR2MOxjgCxq9S9R/h1W+ZfdVTUFv/f1+nuUZPxWQUxArxkm+q
X-Authority-Analysis: v=2.4 cv=EcBd0/mC c=1 sm=1 tr=0 ts=6ae4769d cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=2Vv74F+liJFs5eLlGJuaDg==:17
 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=Z5Fxo1IbJ55YNqwXoCEA:9 a=zgiPjhLxNE0A:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-GUID: dm6hKygkFKtza54QDmT9O-W4i4HR8BeY
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11950
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 bulkscore=10 adultscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=10 suspectscore=0 impostorscore=10
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610300043
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 71241A0008
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: i8e6kyn8xc8fbbnxwtriuici4hhb9k1s
X-HE-Tag: 1793357470-561554
X-HE-Meta: U2FsdGVkX19tmuUB0Bpw3kFVhApkdQjuqHrymy7b0LSoiuEgG8O7Wx3R1yeaVDNz8M+dm7xOmUzJUdS4C+G4pO80nSY0t+nQ59G7TeRK13NnygujCk36IfCj1mJX0I0o86hgQMrLqrnDPqUJlg0uAmms3Cbh5f5QiEBdT/noxPwdBFu+m5bU21DQitVVdqBEzx6E8yovGDySIYlSSZThNQFAI57LjPDGnsp1bQUlQm7mtNoyvugjZiDI6AxPLUxHI4aHw1dpcM1sryqb9dJRU2h+SFqbqCabbH41/f7Rv7OV05bgTvHeesGGYn57gJYjRFFUwa45lGsySKgzo+nIqV0nikxhV2B4RqjFgZ4wVmVCBp3BS7iiu1szLSY00MJPU2fPtlUTOSX3OQGRucm23wnh5ORebcixQp3fYfsY/ZN8hoinLS/qbEbJyLSgvKCy9PcTksD1BlRnTQ6Az0ZIZmUXAHVMU0awfWr2c6tWtxA0XcI43Z5m/ONInFs+s8mWk/IYF6yUqz/kuSp5S/jCLXQRoo923Ipyg6n9sGWI24wLHDQjEcU1f2fp0HXs90zQBYP8JWXt/Fp38IerK90xtupndspSFVYFJnF7Y77U7ZB3sYsLQEU5GRvSN6L/FXuHPHdhL5X49mJSYzuOevakSbUdBohy2x5taOKcxAD0ikAhFfpfLZVLLs5gx2KNTNIfmlPLRVoKDCBMkUP3hi/WTU/lqcaLn5sw+tP3UTpyiDEXXlihyQuZuAGxyGj54gDP5yZr9d0dso5P0eeSSQ2C708C9HoNQYMgTfVaPPGLrCq02AWfGT0XkDKoQ+fgZiW/rPv/9qOtCeHsRQnoXdRkmkRtyVx+jC2OV6ZyV7cRtutqK9ZZOCdIeHkVPZL7y3i0TmAxvS2KrQAn9RTYe4kYP6FKjiyyEdHuMWlsSv45t0rfnvrfq074BDxp4fb2qoCF2H9c7zh27ISE+SWvvKp
 7lbeFVK/
 vkFFTYsPgif9xA7r8KchI3xp29yc52QlqPV2lip82KZRnsDhLq0dHTDjOCgMT3FO0cNVrlZAh+gYKLBS26wgcjFjc9a2s+YLlp+AngKSfOT7U3qGjZyhnWQMIOENhT4C2zVosAx0MLxnbNJH6GS+S78BrPMk+RByUojr/mjEzwJXbXrPDVVysUXNQyAwY+aoEs5Nfie3LCz8s2Vkq/VUAHXFwMy05y3HojTji1Sn9ihstD4X9ppEIa1B/9HpEuDWgbGZ4NlobQoS8vG23D80nZtpsCL82VdjnoMY2DrW3zlHCHsA4R2deD4LXMwGeIraO5/4f77hn0qw8+ChGTd/2SOFmnAWjlFqEtBPx9Kc7L5fSUNhLma7qf8YJcCftXC3rVNDko7zKttZkXHo+EsfCrR/2FZ+FZUqIMONW1OSbfI4RDCugQ6Or4ko6MHgGDic9RXgkmjRFSViB0/2zogOYWjbs7c5nSTx/pksEEd6ktT0wutrDzmrlBU0Qgd10kKGp/CiB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Aug 06, 2026 at 01:14:38PM +0200, David Hildenbrand (Arm) wrote:
> hwpoison code can end up calling min_order_for_split() without holding
> the folio lock. There isn't really something that would prevent
> concurrent folio split. Consequently folio->mapping can get set to
> NULL after checking for "!folio->mapping", and if the compiler
> reloads folio->mapping, mapping_min_folio_order() would try to
> dereference NULL.

Hi David,

Did this patch ever make it in?

Thanks,
Tal

