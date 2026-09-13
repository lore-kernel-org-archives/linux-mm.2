Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBC9CC88E64
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 23:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAC2F6B0088; Sun, 13 Sep 2026 19:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37156B008C; Sun, 13 Sep 2026 19:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D6766B0092; Sun, 13 Sep 2026 19:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 683B86B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 19:34:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 338EBC0CF1
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:34:10 +0000 (UTC)
X-FDA: 85210344660.07.1A1D246
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6230B20008
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:34:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=PSfd0VRm;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="kjRkeR/L";
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789342447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CfiPtIpaVHaFgHCxzYZpBn2tB3324rBaeeRf+dOQHKs=;
	b=yh5YutQPN7PGde+PdNU4l5m8VW3ploDTsCGmvzvyyDiNNfBUbI5gN8IapMiibL/EbXLh2S
	Ux9Ln0VIsnljF9Y/SJttxUkPml3XvX+pYjdXugbIkYCech0fx4GflYR+lt9YWztoxzmS04
	vhD4GYB8R5Sz5y3JBCNLZrCZ5uVMJ2k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789342447;
	b=NjytEMAB3DCUWar6iAU6rUSdnbtckM/vy87rpqgCRC2hUcP+8ulSlgC0WDkeo5PhfCWToM
	WPe3RDvJsrkDEHPQjUKCRuo1ruEuH2cCN/1F/X8Lj5gpK/n14Da25N+ow8/K86u0NKAoS8
	H2hOPDvm1SPT9GyJFFLXt9goP/Hp0jk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=PSfd0VRm;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="kjRkeR/L";
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DMZ1GT800202
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 19:34:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=CfiP
	tIpaVHaFgHCxzYZpBn2tB3324rBaeeRf+dOQHKs=; b=PSfd0VRmn9GZFlSpJeog
	S5dgc3N4oV1hg867SEsh5JrtaxyJMmB1h5o9bY+OFMD07wd5WLANakrU8L0DRrOJ
	G0EFeXRbk3i689WWSVRBaPtm4pTNh+OtnL/Nfube6B1ZRB9HkCmqh62NVe4BqhNG
	v+xm15X6pKcMheiUfx/BdnuhsiiulQ2v2HbOU6zCYfsEWDn112E5aD0c9FZlVLm1
	CPRAC0hsw8kQTkhKbuoyuGtAyn2jDK54CEYM9Ayjan48SPgyVXgk3VF/CmsRevgX
	NeYbX7Fj3xrMomScKOMSPbIFQx9/rgP0fU4Wgpbku+xZ3fpjIj0GRBjpgcX82mS6
	kQ==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gp3ah8gt0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 19:34:06 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90e8135d7eeso49696256d6.1
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 16:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789342445; x=1789947245; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CfiPtIpaVHaFgHCxzYZpBn2tB3324rBaeeRf+dOQHKs=;
        b=kjRkeR/LE20g2uj0MCbl3Qi37nRzaVZouK+3hidBEDdrzfeVkn/EMiM3jHJNz4GhER
         tdMU/SOF31CGJnhbxXUp/9wyLmc+Xkk79nBoUtoy9rVI1Qs1GsUSQa7hb4e8pb1hRXvn
         eOuT/Qqnno1Nq81qdV1So4Z4nd2nIkrFLwd7oRgsXySeKGcUaBGkDKKjMZ95iJoE7Rot
         COjZ/LrvY78v5o6OmZyrapAiKpbgsiPZPnJjGWLq+hkUMaziPVIB9FOj8TJZIlEgw7bG
         yYRB8Pr3/q9EwApKTH8qDTl/btfvkoLi2YK5n4hhK0DfdHqkZhuO+w6EfBnP4qicGFQH
         UGOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789342445; x=1789947245;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CfiPtIpaVHaFgHCxzYZpBn2tB3324rBaeeRf+dOQHKs=;
        b=IsD9d5qKwRbZwgNbM/jY2Fko+oVAtRTx1mBiNMP01wpXSFbDdHWOCgrd85Yv7QM5fR
         XLcORRiHI1mXaZsz5Pdl9lEvLI809SPCryo7LTdgY4qJ+mfVPQ+haEBS3sjHyR3IOCNU
         Oc7nNYGuJ3DezFv3w2rRaVdiT0NZkggqm2+r3IfuN/JTcaDoPENdbRbLF0kV00RbSQI1
         jZ83FiTkd1lw14g/QQhFvf4G+vyifcNVlNFzdhL7v6qK1wV4h64vZYcKqDxtxHAgnaO3
         TXZBOj8/eLK5bdsoZeSRp6IfQL6Tdb51Eflx1rgubTDzDsdc/ag/qZfUe1L0xIRTCtaH
         bG0w==
X-Forwarded-Encrypted: i=1; AKwUvBxdz+cQl755XJZ7aCir/4MpUBAX3dUbIsgwnyV4Nbp10ujO1EhtXKBZ+Rq97F/fqrWcC3aufTEz5w==@kvack.org
X-Gm-Message-State: AFuF++lhqTYEYYGDM+aFyh60rEoeParHAn8i+/27ulPWmDYNAgEBNZqE
	Yb//A+sfKXQjJxXnCDW4VjEM3V1kUvfMVrU3fBZoeb1RIsR4Ae2nEnba8ByWS9ndwgtXrTD1YYK
	VY0QToSFUPJ64SfMJXBvjdsqKYKmsW05aXYAORBDPPb3BIsS8
X-Gm-Gg: AYBFou3A8PS+JcFZaFgFGfAxTZrloTjpuyedxQwz3Yo9tOV6EbDbO9eSoJmOQAZl9bn
	kTXml6jmQMmiVMQiY3Wz1NOOiF9Ne29FKihoa8Q1CUy7FM2K1DCTF0tgkUeKNV4N1BGHIGtrNHh
	BmkTxiPfJoK4PpXKgPnI6d8a8k55ugzvjmF1GbGb+pQFBn+MJ9dI6omndnUUCaFJPxvu6fNK+28
	lSdZ4qJT0vw8EGQGyQxB+mGr5fYxpuO8hwr0SHFT+25BDIwWUlMyd1CYl2Xr/s4TUKbl9rOTxRZ
	0gKgvXruyckI4yH//I25Rtw7EQ6k7+TTV8zzAFkUs3Nfvohoor44JP/1/sdvLhUelJgba28ZBJF
	53Em5WXVsJJxGZYlnYkScrrSV50UGIkmV9VgTAHqhANpcpavHL2UBHUZw/g==
X-Received: by 2002:a05:6214:319b:b0:90c:5947:7e60 with SMTP id 6a1803df08f44-9122e4ce87emr5954216d6.4.1789342444476;
        Sun, 13 Sep 2026 16:34:04 -0700 (PDT)
X-Received: by 2002:a05:6214:319b:b0:90c:5947:7e60 with SMTP id 6a1803df08f44-9122e4ce87emr5953806d6.4.1789342443979;
        Sun, 13 Sep 2026 16:34:03 -0700 (PDT)
Received: from [10.207.49.22] (nat-128-59-179-215.net.columbia.edu. [128.59.179.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f45adbfsm80697456d6.13.2026.09.13.16.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2026 16:34:03 -0700 (PDT)
Message-ID: <65a2c7df-0d2e-46de-9580-01e9c35a7e32@columbia.edu>
Date: Sun, 13 Sep 2026 19:34:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: filemap: retain mapped dropbehind folios
To: Barry Song <baohua@kernel.org>
Cc: Wenjie Qi <qwjhust@gmail.com>, willy@infradead.org, jack@suse.cz,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, axboe@kernel.dk,
        trond.myklebust@hammerspace.com, jaegeuk@kernel.org, chao@kernel.org,
        qiwenjie@xiaomi.com
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com>
 <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
 <4aba05e1a2c3b61cb337d373eb9b7a8db4ddd822.1788024049.git.qiwenjie@xiaomi.com>
 <20260829111621.41ed2bc9a0e99e3367eb96c3@linux-foundation.org>
 <ef160933595c365f2c47597b260bc7ecd98ed7ce.1788029516.git.qiwenjie@xiaomi.com>
 <076bb01b-6fcf-4691-be8c-0e8507c9fe64@columbia.edu>
 <CAGsJ_4xMK=rPXCH5OiCOYHKRQp-w+xDJQusJ_ykbuAuLZr+8bA@mail.gmail.com>
 <1e5118a5-6b61-49d0-85e1-825e22059241@columbia.edu>
 <CAGsJ_4wj6XvPB+QF+_X1BJ_8Y2sZEEFAw6RaJJz-cHaDWLkxaQ@mail.gmail.com>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <CAGsJ_4wj6XvPB+QF+_X1BJ_8Y2sZEEFAw6RaJJz-cHaDWLkxaQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDMzNiBTYWx0ZWRfX0sasTjAaBp52
 LQiBenF5TIHZ3+jMsCuqINcgWNUprFKrcZU4YZHk0jDZ34abQL0Ne7SQAX7n2BkEicLJI013AKn
 972NydF7O25WkH5OlLGYnX21cw74RIsmZhC0FlvrHneJcCcOomZh
X-Authority-Analysis: v=2.4 cv=Z4x5j3RA c=1 sm=1 tr=0 ts=6aa732ee cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=2jelXx5xVcRIF5zNctN5Qg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=IeNN-m2dAAAA:8 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=xcoSihzll435I0Xx0lMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: fHxGuQGucoAyhvwxm0HDfkfb0My1dn6-
X-Proofpoint-GUID: fHxGuQGucoAyhvwxm0HDfkfb0My1dn6-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDMzNiBTYWx0ZWRfX2gs2qua/LWGp
 5zg45Uk0Lj7p6/dZpJHF/FIQSN5zM3B1UQcYevEHNWQmzAvjIC9Wa+oT/+DB0i8xLCwr00zaC65
 A2D1fsfVvgrghKZV0jaD1bSxG0IFlDsLuhGEd7y3/3kYrjyxKVvlYAnpt7kShT1nsuxq4MLUyZ1
 Zn6EegQg6FaGYUVErF/sQ/v/bikm3rQCbnGfsW9BoelxcLF/VCffP+RIzfpiFRY3z6b3YZrQihC
 pazdy6JHJ6/Rsx43y8T2t/gQ3OXd1+ZtUoSXmxtDWMzmlkG5NzZoInh8tOVBdsRoqdgrzO9eCb7
 HpocwGVEC7gqbNv5XAfTeYLG6e/7+80v7lx3t7/0vRioiAgKY0fKfsmjsIRYhkIqH5DfJGkdt9r
 iVZnOevRGQzoAqVoTKo6ADsPKBfQwBv7OE+6GK5Xe9RiZDPaelm9Iog6TtJUyvFiIbFoblnovre
 VhZ7P9A8g5a5Nwh3IKw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11904
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 clxscore=1015 spamscore=0 suspectscore=0 adultscore=0
 impostorscore=10 bulkscore=10 phishscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609130336
X-Stat-Signature: ddjh7m7754b4dfdopijh31r8pefrruro
X-Rspam-User: 
X-Rspamd-Queue-Id: 6230B20008
X-Rspamd-Server: rspam03
X-HE-Tag: 1789342447-960421
X-HE-Meta: U2FsdGVkX1+i/hTHBsKtOCef9uAIks2vbfDM7z9wSTj98ONdA8IqxfA1EgrKQHUEmZp+0DqMY8jOtRLhXjdZAHRcM3Yo5wXHxHg2mIbSc/s/NXXfilbr7elf6UqJ9ey7aXoqE5987ZSl350EpxBAoNX/E0hEhIjMfwHseMp6QpZza/Dsg0j/qnUsm/00u2HB8FtN2g0cdRuC6Hij/+7U+AZqOwbewBuaO+MDJiOadNiB+8F/3j+cYqAqd7L/hZK2hRU9dFF1ufe5gPGLsw+jYDPQji/P70CYPXJ2NYpdsn0bxtwBDV5rYRHH/jSieTemIbRP4MRJPSqZa5lh1v9yGyScF7Ni0u+kRHbHMX3B2qnFXVVyuYuEO9r+dvERbnT1yxPFQNhIZoZ2dH4wwJF6h3PakkZyi90804Vsa9AxCau7DQXiUAC+465RR/yEWG30GLqBsenu15205ZIFVo/2RDeslxiLKqGGZC37K30B2esJaV8GMnOu9NWgJASZb0TtN+QmUbDRSw594iKx9Is2iHG9rb/5+rU6+AHEG98YSSKaAe3cX7cO2d5p1+jqHi/mOHJ4CJ0QMKYdMdfDD4y+VrfPIJk/KF+xujB0fNmsRh2TjC944oV+Qw8Y6iroJn3iUdPwdSG+rK3dFJjg4CHiju6CXEKdt+MYUGFt7531y7jce2GdIWalmSmfevqRRGGnXbZkrO79Kxvjp8tGPLb12/qT+MuNPLULPWD4uvg00mBO/tLEB3VcKxy+veSBHeOoNDMdRb0GW5fnzVgmAvERsvdvtDJkhdqCHSu+Tp3wa8Gb90qmf09XXEBpxHe/EPeq3qhSrvugzR7mMDb9puNDdwZSxCA9fTnN5kfvnC4EnzIlsMxPteH4r0ckExIVuGNeRxeE1/QhY2nhP5XrxxifXT9NUzamB1F+3wvTPAT3ivQnQbLUOGB3vKUZa2HfU8sCn1ccv2lwc5yIaL8YCzi
 hFd+Wi5y
 +kFk+ueQ5JtLZNHIgqpEcGnntuTjGvFvOGuAmQaaaqnheO2pB2W0rtZpbFJpVre+ZjAflIy4hzKob75rVhlOog/A7upEDcvXgxcG4rd1k7uGExI/fSZNyhAXFPzv1HFk3KqXxfXtyZUaPoPEcKlp5UHDaS/fhExtdnFj2tdQmv1/amA5ZxXhYlqazAYwh4VMXC7UeMnYAczfsO5YI/L+8xYv5XN+GlEC76Xtlf5f5l1V2c9EzEcBDwawasNIcZQTGZbltCAs4yPHjlwvGIOWTbevE6LxThrlm2Ps18dNSuuLkrfigMDKa8pQ+a7Mg1yCikI8HpOYbxlzivITgevDGV/OF9RCni5iTahY6Yu2FWa8Gj/oE8g+a3RXb0Iocb7U9qBe3WJDic1/OC67Gr/4BlFTAWB4OPBhu+5ypqAq0f9EtakbBULPm9v76JUEqojx8n/zy3+UjdZoSxcZpSxDRebnIJqyqxFIY/2AyAx3SpZMnJqVwXbA5SCDLf7qxdRCvOj5Lt/k4fx0FR7xB4tSBz/9p2M8ZDlM4h0J6YhcTnQzVnis=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/13/26 6:51 PM, Barry Song wrote:
> On Fri, Sep 4, 2026 at 6:36 AM Tal Zussman <tz2294@columbia.edu> wrote:
>>
>> On 9/4/26 12:28 AM, Barry Song wrote:
>> > On Sun, Aug 30, 2026 at 7:59 PM Tal Zussman <tz2294@columbia.edu> wrote:
>> >>
>> >> On 8/30/26 6:25 AM, Wenjie Qi wrote:
>> >> > From: Wenjie Qi <qiwenjie@xiaomi.com>
>> >> >
>> >> > Fault-around can map ready dropbehind folios without going through the
>> >> > normal page-cache lookup that clears dropbehind. A mapping represents a
>> >> > competing cached user, but writeback completion can currently unmap that
>> >> > folio. A later mmap access must then fault it back in.
>> >> >
>> >> > Retain mapped folios instead. For a mapped folio,
>> >> > folio_unmap_invalidate() can call unmap_mapping_folio(), which takes
>> >> > i_mmap_rwsem and may sleep. Retaining the folio also avoids this path when
>> >> > folio_end_dropbehind() runs in non-preemptible task context.
>> >> >
>> >> > Unmapped dropbehind folios continue through the existing invalidation path.
>> >> >
>> >> > Fixes: fb7d3bc41493 ("mm/filemap: drop streaming/uncached pages when writeback completes")
>> >> > Cc: stable@vger.kernel.org
>> >> > Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
>> >> > Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>> >> > Reviewed-by: Tal Zussman <tz2294@columbia.edu>
>> >> > ---
>> >> > The mapped-plus-dropbehind state was reproduced in QEMU. The patched
>> >> > kernel retained the mapped folio and continued to evict the unmapped
>> >> > dontcache folio. I did not reproduce the sleeping-in-atomic warning and
>> >> > am not aware of an existing report.
>> >> >
>> >>
>> >> I was able to trigger the sleeping-while-atomic BUG on current mainline with
>> >> some help from Claude. The reproducer itself is straightforward enough, but the
>> >> configuration was a little finicky. The atomic context comes from using
>> >> threadirqs so that virtblk_done() completes requests from the irq thread under
>> >> local_bh_disable() and the vq spinlock with irqs off, so in_task() is true but
>> >> the i_mmap_rwsem down_read() sleeps. It also needed 1 vCPU (so completion stays
>> >> in the irq thread rather than softirq) and ext4 -o dioread_lock (so end_io runs
>> >> inline instead of on a workqueue). With v4 applied the bug is gone, so:
>> >>
>> >
>> > Thanks, Tal. Then I'm getting quite confused. Since with Wenjie's
>> > patch, we are no longer going to sleep for dropbehind in `filemap.c`,
>> > do we still need all the complex logic in the block device and file
>> > system layers to move dropbehind to a workqueue task context?
>> >
>>
>> Hi Barry,
>>
>> Let me clarify. Wenjie's patch prevents sleeping in a very specific case.
>> The existing in_task() check covered most other cases, in that it just
>> doesn't do dropbehind invalidation if we're not executing in task context
>> (for example, block device writeback completing in interrupt context).
>>
>> However, dropping the invalidation defeats the point of dropbehind, as it
>> leaves the pages in the page cache. If we get rid of the task-context
>> deferral mechanism, we wouldn't sleep, but we also wouldn't invalidate.
>> Wenjie's change is largely unrelated to this.
> 
> Hi Tal,
> 
> Thanks for the clarification. However, I’m still not convinced.
> 
> If `unmap_mapping_folio()` is the only place where we might
> sleep — where we might take `mapping->i_mmap_rwsem` through
> `i_mmap_lock_read()`, as Wenjian pointed out in [1] — we have now
> prevented that from happening with `if (!folio_mapped(folio))`.
> 
> So no mapped folio should call `folio_unmap_invalidate()`:
> 
> static void filemap_end_dropbehind(struct folio *folio)
> {
>          struct address_space *mapping = folio->mapping;
> 
>          VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> 
>          if (folio_test_writeback(folio) || folio_test_dirty(folio))
>                  return;
>          if (!folio_test_clear_dropbehind(folio))
>                  return;
>          if (mapping && !folio_mapped(folio))
>                  folio_unmap_invalidate(mapping, folio, 0);
> }
> 
> Why do we still need the `in_task()` check in
> `folio_end_dropbehind()`?
> 
> void folio_end_dropbehind(struct folio *folio)
> {
>          if (!folio_test_dropbehind(folio))
>                  return;
> 
>          /*
>           * Hitting !in_task() should not happen off RWF_DONTCACHE writeback,
>           * but can happen if normal writeback just happens to find dirty folios
>           * that were created as part of uncached writeback, and that writeback
>           * would otherwise not need non-IRQ handling. Just skip the
>           * invalidation in that case.
>           */
>          if (in_task() && folio_trylock(folio)) {
>                  filemap_end_dropbehind(folio);
>                  folio_unlock(folio);
>          }
> }
> 
> Could any other operation in `folio_unmap_invalidate()` sleep for
> unmapped folios? Otherwise, it seems we don't need `in_task()` at
> all?
> 

So I think you're right about the sleeping aspect, but the problem is
that this still gets called from interrupt context. folio_unmap_invalidate()
grabs a number of locks in a non-IRQ safe way. Just at a glance, the
spin_lock(&mapping->host->i_lock) call could lead to a deadlock, since other
paths don't call it with interrupts disabled. And xa_unlock_irq() enables
interrupts unconditionally, which would be incorrect from hardirq I believe.

- Tal

