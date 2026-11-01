Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24FF5606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 15:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=P/K5G4Mq;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=DBIUsW3V
Received: by kanga.kvack.org (Postfix)
	id 497976B00EF; Sun,  1 Nov 2026 10:54:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 448616B05B1; Sun,  1 Nov 2026 10:54:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3373C6B05B2; Sun,  1 Nov 2026 10:54:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 037A16B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 10:54:53 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56DD71C4463
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 15:54:53 +0000 (UTC)
X-FDA: 85386998466.14.281248C
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id 909EF80006
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 15:54:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="P/K5G4Mq";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=DBIUsW3V;
	spf=pass (imf02.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793548491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESraT188hHqeA/eG2HAU4aWg3ncS/DlKucSFgZXYCzQ=;
	b=OBOdCDw/7wLB27OPlLdvSrp5BNWKyCqXN6LCq0Mpu3pQQRuYcGlOdVZB3GKM1ptOR5jTHV
	NRIjDnXybifrxBMqXY05tmJMfy3CnEA18W0WCgcYxkFo87d/QgObtKX46/rx6o1cLk7p4e
	DJcJsJLIwdXKNr+NWFvRtzoA9ABLsUc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="P/K5G4Mq";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=DBIUsW3V;
	spf=pass (imf02.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793548491;
	b=UB3nCfE4ogxxZDOjoSHmD6Rk0XkKreV4ZHboFxYempz9dx/iz+wyl/bdoEAGd9RfLUCQti
	83WpVZ++t7rBpq3G3Laq/N7fPQXLceohztOftZD1mXgV/dv6YMKJ40i9BzLK+tEnd2Mv8I
	ZKBk+Bzf8waW92DFLTjh67t9B5jOWB4=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A1DSuwU3811199
	for <linux-mm@kvack.org>; Sun, 1 Nov 2026 10:54:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=ESra
	T188hHqeA/eG2HAU4aWg3ncS/DlKucSFgZXYCzQ=; b=P/K5G4MqEuZj9+6+RC9s
	jnCwKpynXG5iiq0cGPCeDjgJ54gVhUu9AfrGHD3HwtbCoiAcHToOPbuUz6LWJFTD
	9FIjOEFgB1+fgFZtNSTc7RfNrR356rGOgHrSdZ5vT3vLxkmoIN4eS/27VThq0Rf6
	JEbNc+8tuvdUQaAUoabBGaZX4w46BM1trPb+2QQYS2fnJHoorpvX84dR2zD3OLIn
	l/KRnqYFddnkjJIrglo5U85zxeVyyANYOOiEaj+ILTcfJAqqNNkDRY6eqHecnujN
	nItLYO7BXQ/j3zV0DNPBftKyL8rj+nSO32tYdtaDouydEVQI6wJwko6Sm2dfMGbh
	Gw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hp26w1ncp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 01 Nov 2026 10:54:48 -0500 (EST)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5337b591609so25767601cf.3
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 07:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793548488; x=1794153288; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ESraT188hHqeA/eG2HAU4aWg3ncS/DlKucSFgZXYCzQ=;
        b=DBIUsW3V/cyLxpfAKKsfz0+XKEh0ngcLzrELcdxLO45hMMiQjiIQK1x2RBRptNkbQ1
         0DZ7jKbNPTSBtdUNz46q5uO1rjmtmf6WCSC0YHfG/Bh60706Ch2C7A7cTXiihFQHooaz
         QTvim0NsQbrI1iRhqGLWCrSchWXyX/Fq+prvUbGWemrM7C7cEOsnWoxsoq2ykbPk2o19
         K8jP+3XXnmaJZTfEMSmDP/t6JtA6L58SOPMQ21rYDn9dLlubbwEv5i/F+/lLoctGezo2
         ntt2M0eTFYFWX5e5tfXfFf7GU4PPxjQv5pr5ubR3zcg3yAbNyIQd5zS+LHUixo6Fb2xE
         uG/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793548488; x=1794153288;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ESraT188hHqeA/eG2HAU4aWg3ncS/DlKucSFgZXYCzQ=;
        b=F3qN/4TCUguO9qJKIAfpHHNrFzZPzpEnVxSxAJJCxoxGEDNMpBhT4gwOjXVRxeRYXg
         5DM/ibticDxWR2Mpa6k83SSXCC6SepYJIqk5DogKmTJZtRjeavdWxfJvdGMZAy0o3KV9
         HvgZFiMRM+/Ft1/0LJHCqc4Jh22x5eFAt7ZLzajFRL+v4ftx7KY1SEbJ2ssd1KyzQBC8
         kqEqOlMGQPEcuDhZu43WFLB/nMLYBGVKlk/7HNMCNK9R6nyGByi5pq5NSxaBXRx08pPb
         zSU0t5kzGtOrxx2fZEgwViWt8WA4WujooxW4zQSoMxPlrmv7Q+juMOYBWCNz+ntyEJSP
         wtFQ==
X-Forwarded-Encrypted: i=1; AKwUvByQRvcPE7x6reiB7mTyIYtNHsjaS1VMicR9wBlYQVUe3LuE8plQMJaBeBSF3AaJLC1O2f/GNvajnQ==@kvack.org
X-Gm-Message-State: AFq9FYIV5600A24RZqH3EobJa6EsMaXsyz7mlsHkovXketmuCj5I4OnF
	7NGs5pfATCTvcKzFVd9DkYD6/ay+6BfEBkCVrN4SIfcy8C0MhggUAn/i0DCRjAFam6hpbhdOq7I
	+8C8Kkazig9PuqKnjs2hy6YEK7U9r3GgouDIgunH0JqdtLSxs
X-Gm-Gg: AYBFou2PNcxghv5+nZAPkCZlKV8XuJIVdwiRDwp1JuLDXy6EQt7up5QpquTXbsIgUvn
	nwvPc7l29efwSccDT0CNOrKqyHZ6nuvTtT3FWNajz3IugsCGcwqWodge75qZCOZvRMXIRaAkHYS
	Z3fyraYTQyYaeWQviU1xUeY0uTMEwA7Q0V2jNfUeHXNdC8l7JRXRRHKb9nxDXZ5MuRIrbjNnEwb
	3sezlQMxJcDRlMSAr0jfzBSN5qGweSxdxtwqZ3Dy1uFqWVMwTTzlUulw3+YvHp82d3V6RU42auX
	MGplrjOkB9AouMfZp2hMWIYMl5ACa1w5CApNRSTMzgqxGDGpu1MxVMw1dAGKV6l21e3kx+RV381
	NKJKR29rVP4nyNe/8qeckDEgT6v3nfqR4hMESNq4a0+kQl5Nqg/BMXE4bL63UR38sYg4spnkFN+
	GFZQ2+tKfqqVdKVVuc4OSjpfwt1FWoGQITB+EAYrX20chXy9RJ8ZVcAuzz6ED56p3AEglPg5g0o
	n/zyGXz7RIC74Yfq5nYGqVHOMkGq524ezuej5e+FsBJeM8Wo/s/voI0VHbYAL6G/s6Nte0G12yM
	r1eiluaFGuNXriEcqhM=
X-Received: by 2002:a05:622a:649:b0:536:6946:748c with SMTP id d75a77b69052e-542b771ed82mr132792411cf.53.1793548487892;
        Sun, 01 Nov 2026 07:54:47 -0800 (PST)
X-Received: by 2002:a05:622a:649:b0:536:6946:748c with SMTP id d75a77b69052e-542b771ed82mr132791951cf.53.1793548487394;
        Sun, 01 Nov 2026 07:54:47 -0800 (PST)
Received: from [192.168.1.187] (ool-18e492e0.dyn.optonline.net. [24.228.146.224])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54311f75fd7sm63339941cf.11.2026.11.01.07.54.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 07:54:47 -0800 (PST)
Message-ID: <b12ae064-012d-44b9-9d27-461e4af83f3f@columbia.edu>
Date: Sun, 1 Nov 2026 10:54:46 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/swapfile: drop a large unmapped swap-in folio in
 unuse_pte()
To: Kairui Song <ryncsn@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
        Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tz2294@columbia.edu,
        stable@vger.kernel.org
References: <20261030-swapin-large-unmapped-v1-1-41e4ae378e6c@columbia.edu>
 <20261030155419.b10056c8fb37bc784b0d2778@linux-foundation.org>
 <CAMgjq7AUvsHVKkHmLzL-KKf+MBed6e4TeVP7jcGMLM22xO+=5g@mail.gmail.com>
Content-Language: en-US
From: Mani Tofigh <mt4022@columbia.edu>
In-Reply-To: <CAMgjq7AUvsHVKkHmLzL-KKf+MBed6e4TeVP7jcGMLM22xO+=5g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: PQb-R7n9zjNeaUzfxy7ZHC74xfJLLu0p
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAxMDA2MyBTYWx0ZWRfX3+JampgjN6a3
 wV19C6cCaW0raHYxxi8EZtLHo3AZLVRZbY6QVXnPuftMWs0A85K316cntQi7fCkcFw9FSblhc4/
 4+bn9n8jm4T2h7/z7za5ljvqezkyGM8CLlnhGB0SVf4vUmuVftQx
X-Authority-Analysis: v=2.4 cv=E9JYNqdl c=1 sm=1 tr=0 ts=6ae760c8 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=FE+fbgsriwsnvVT5CFHM3g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=Z4Rwk6OoAAAA:8 a=CbAtmpW2TtMjExKzJAEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAxMDA2MyBTYWx0ZWRfX0AH72MhVQtrD
 v3rDLwFuXeawsM567YmXuzeB0QJvuQEJe4k+sCHdoiVNKUQ4qHcPNfbW2s7mXVQQLEkrfXDqJ2B
 feXDF7kVL2aIAMhAFDeWTLdikusarRWO7VR4Xt2ACuDj40JkSOzGDKnaddLYz6VL53df8BrlN2o
 i12Fcx5Pzms9ApZkCLNxU/WYX/BFXYhkj5OwuBaummgTRqYoTyfCN9FL1WJC3zLCEjjKlbD9uff
 8+l8J1E+yETSvXxOmlTLT8tIY+zCRxK+ooENr40FR6cyOlVDZ7oHjZk7yupEQm4/H/Q9K5f27Qw
 1DjKWYX0qj1U2kbIl++kxq0dM6HD6ZL+rDXGjtqvsOkx2W+89s3uoTGtgW8StL7QTVJl3UsIUsY
 Jlfkj0GOG6E2zWvchukZK//byTkWhghg7dpIdxVys9C19KzG16Lkyn+R+I0a2Ct0q0o566SPjkj
 Iotu3Ir8W4SC8DVriWg==
X-Proofpoint-ORIG-GUID: PQb-R7n9zjNeaUzfxy7ZHC74xfJLLu0p
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11953
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 clxscore=1015 impostorscore=10 phishscore=0 lowpriorityscore=10
 spamscore=0 adultscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611010063
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 909EF80006
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: mkbkqock9goo9rfyp4nn7cx4guxtb8au
X-HE-Tag: 1793548490-880786
X-HE-Meta: U2FsdGVkX1/B/TQdnMqSm2F5XlTbLOD2p9BoZj9YWM5cYzzJ8EX1ICppMWKhB1TgWKa4DgqSi98zhK/UAeESgAD+KgJVLLoacCb3Mh9NqXM43NQSETOiDNNeavDwRQ9uHz0E7JFPcveIPSoczA0VBd6QzMi3LYSrm+lCjslSZjIFyk6cap5XVwL5dWiviN++MYyU1xZiLjTuZTXU2a7xwm6Ua0/abgYaok4tk14bnW7ayKkXKRHeOmFUsv1CSVf9wSZoo2L6RWESPdW/XttYTTDJ5E/MLJM1xpXEGViR8BhAEUu+egmwPKFXH+uRfI5HJ40qFgDcfo6gR04I6J3/U/693+z+DmrVu+EQzVAs2rwBJ1e727fFXPFolbhlHArsHMVmS1TEZc8j1AF57vEA7nbr3gSik3gx/EjBYwMakBTZzQzx8z0vpQrMjmYrD7w3VPV5ICUi7XzkGT1iIImUQ57sGCOAmEoj9tjMFV4WoO7tnvic63X8AwmgPpgVR6GwgGYby4ljZG6/m87HcAK5575DeHxKd4xGmGUtarlLY8YkJpxNL25akNbldIHl89MPJlJsTI5uUHwnUb58HNhnWmhugL3uT/Dw/TooJVSHlksxStZKbFMH7TyLqpaI/Lr2pviLDPsIiXIjQ3ZQJzSTqyp749JExfmXUDGnKdRz7hG3lWVOOpP2i+1Nv+yn4g9gBe9qExQQXshrsOzY2wtuW7lvkRVLZKYN8rpo8kur7oFcQIYaRxb5BnneB5uzyLVOB9VM1oDNfzveQ2CQcjxi44sqHF3C+9axX66GigIT5MVClj0d+JJg+GTx4Vpc5x3mpbu8AXOnQl/Vgwf33+k9TqsEkk9TWL9IJNxPeNKTS0rko0kAPIInnhOSsZzq4qLxqZEKqThUDRegyEzZtMP/UG1GqEThtP4xjKUcTJ7DUt1rYs8B4BwDW4r3DF+jhNDjxydHDRMGx9Z2RWX8oe1
 55NlV3BD
 P0FIDW193G92EEQTPHKS5JEQb/mynpETRRgZPowd6EBjzcApnt0mrU1k64iLK/ZJtfwZmTN8W+fOP6RKg1vOafY3/Tp9o9JSHaOryhbQkgSFYrEh3TLb2f7BGtKGOmRLvyUzkdICT6/zjudjngiFJ05gNlxUVBc1oaUrQoQbOnUNsoBSSQls12UPYCnVkmdk4N3oXTdvMv7u/Z8BFeO9cWM69fNTAdvJ4y37VxjEQleFF43Xpc6vxjQlN4FPE9NjyPfDBa5bRGW5hT3Kt7M4oF0sIR9M1VqCPZ3CsMp0nzvsAJLjqjbuzLNjvlUPttKAjsTd5TqIs82dm5RDtAjLQKX58CbxZGhDTOQZzcfpGZbetNRl5s53ybEoTAGoi4x4ew4oyi9oTpO3+cc+dqry0DyijVY1YfgbFrkrIjRLYYVdMi+5LrzUNumzTKPxS4HOMW0YYj/zo0Vb6XROL20KhMPhmhvtcXo4q0SmrwsK2S8ZSXRQupaWeTquHVOrLXxrp7DZz+2gMj+MTXVczwZfMu10cQgAhzA0f1XaHzLqLwwBDnpo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 1:54 AM, Kairui Song wrote:
> On Sat, Oct 31, 2026 at 6:54 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>> Also, won't this change cause try_to_unuse() to keep spinning away until
>> someone kills it?  Might be better to return -EBUSY and fail the
>> swapoff?
> 
> It seems fine? The folio is removed from the swap cache, so the next pass
> will go on. But you're right about the dirty and WARN case, it spins, so
> maybe:
> 
>     if (unlikely(folio_test_large(folio) && !folio_test_anon(folio))) {
>        if (WARN_ON_ONCE(folio_test_dirty(folio)))
>           return -EBUSY;
>        swap_cache_del_folio(folio);
>        return 0;
>     }


Right, in the normal case the next pass of try_to_unuse() just swaps the
entry in as a small folio, so only the dirty case would spin.

David suggested a VM_WARN_ON_ONCE() since a dirty folio here would mean
a bug elsewhere, so for v2 I'm thinking of combining the two.  It'd be
a VM_WARN_ON_ONCE() for the dirty case, and the folio stays in the swap
cache with -EBUSY returned.

Thanks for taking a look!

Mani



