Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B01410FC460
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 23:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F41C6B008C; Wed,  8 Apr 2026 19:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F266B0092; Wed,  8 Apr 2026 19:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AA6B6B0093; Wed,  8 Apr 2026 19:09:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 51FCA6B008C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:09:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 152161B7471
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:09:16 +0000 (UTC)
X-FDA: 84636931512.20.4315852
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf20.hostedemail.com (Postfix) with ESMTP id 607A41C000A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:09:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775689753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dslZ9dvpn2QBwNrcJEpfHjycCNypPP7xdaXKfMePho=;
	b=DPsB87FLTGMHZU0PRxhEQ+Z9u5yJqDQRNMht/69y7mkm3W46CPSgxFwZb215SDfbDJAP4V
	q9L6N06ytndmuwS8OerX5Qvl7cU4qxfHGWgsL0jbTDBSBbJ1bbaqbz4L+GdR1poPRDXgw0
	00W0Kd0pjZyQtz1A6/8pKUd6bRMjhuc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775689753; a=rsa-sha256;
	cv=pass;
	b=727Nn66WIz/DxIVcaQ/E1yag12c/OCRh+8QuuMPEHn3C+TYqbv8hMxGGEUQbGeD19yfkc9
	xllwxxmj6KkJd5QxVq60QlAr1faGrBWffHWYVDxIq3zhaVnuODEb1UF5FPGvRdNlG7df/S
	yN7osgQ7rE9tRANpTEOwzOYwI+EatvU=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3826B7FC8
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:09:12 +0000 (UTC)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CFDF0E03B3
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:09:12 +0000 (UTC)
X-FDA: 84636931344.04.5CAC03C
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6765040004
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:09:10 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775689750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dslZ9dvpn2QBwNrcJEpfHjycCNypPP7xdaXKfMePho=;
	b=CcVmFYKy3b39fclWHA0SUhva4uvjbeZY/Q34L3v9Alauo0+T7N27frj9S3nlIC+2xU+gwT
	vM88Pnxt9lRxpCBiDUPDuv1BvLo3ovDNNji2x0SeBOfZpihRm3kQkrg+Aa3FUniQ2OV/yI
	PIus/vs3cpL+jHgKER7BJat1zUUFyDA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=G95NswD+;
	spf=pass (imf04.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775689750; a=rsa-sha256;
	cv=none;
	b=t6jUEc52GcQyDSTTuQWfj5HEIoRw7wMKEDGVFiQtNw01Iw4+N0iXR+CXO1EsF8ztuKDXk+
	4XAAnwzBWBmdKRtdhWwit3D7CJiYJOwIYkf8sFZU8WknJr4l7YuJg/gz98+l9zzLpFquSB
	3ED5S17rwOgMBGVx3OLokOBGKSO9kfk=
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638MuJ5r3333496
	for <linux-mm@kvack.org>; Wed, 8 Apr 2026 19:09:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=8dsl
	Z9dvpn2QBwNrcJEpfHjycCNypPP7xdaXKfMePho=; b=G95NswD+1AgrwF1KSmuo
	7ejnwnOjIs4ukUSShU1rYQhI+zrg5Ns4e67slikatL5s+3HTdp0Ob+Y3K+es5jKl
	PA+SO8dD5ezEfR+GrDhs9SMAoOHcQS/sWaEWVi+Bc0WYLYSL5qeiOyKsmNwe+1Dy
	x8DB5xHpHsRjQfFhUzF2YM/jsDzZXKmKA6c/euUY1KUgWXso3wAhwiAiDFB9udzF
	NQnlG3OYbqFIe11dVdrc76+R8CC0VBm8h056JDC0GpLqoSxncN/Ipiyl/dFo9skJ
	UXesjWHj5qmY1lJ2eH9Sl53JNd6z/VnObBZyoXey6h30J2sRqT42No8Z4oBUZKtR
	og==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dda3mrtd1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Apr 2026 19:09:09 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8dacf883e77so54631285a.2
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 16:09:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775689749; x=1776294549;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8dslZ9dvpn2QBwNrcJEpfHjycCNypPP7xdaXKfMePho=;
        b=MW/r/4KVgULLJeAlqmoK4Ic2zPgfIN6TPy17CJsisJAWY8FKLjbnHUt03WSkwUflH3
         HmhZog4XyrvGGlKV28MdUbag7VFcPf+unkG29uulXI2HMARLo7YFJfBorLf5kt5K3lEZ
         vwtxsuN5Z4Jp9XBmUuTNWZUX7piSNWNlKi5kcbUfce3KxHvjxNCXY6dTRn2dkBoXM/Tl
         o0v6oh/uJMmIj90IOcogzi2bZ3t+7JXNBTUI9NP/4yszeIT2MpdJ/mmJsPRrtAMK7u5i
         8nAG4kp/GZIRIw3DP5E4n4PIfftdLVH3Vg28nUuEIO8+p5icKPLf+IMkyVJzFfqe+4Ui
         3NTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNoHl7QJGnryI8BoJSaIWktN0p+wleMU/OHdZfYnr5psi1oHZ1r//NPdoOqelABacOHMASbwxL8w==@kvack.org
X-Gm-Message-State: AOJu0YxnI6h/Uj4OlquyAOFRwc32YLWHe4oPOnY1CLEJBwe2f0azH6lY
	zXz+lmw+M4mASXL3RvUVoYuN2OXInS0XJoSk6YSNhrw98SUhmEJRuw3+1fr9+uT6R1p0X8bVZ+K
	VorRtQ449ByEJUq1BQqre+3Vi9FifA3kSarghOZwQIFR3eR6F
X-Gm-Gg: AeBDiesSwm80NMZE1PeonNIkS3ZAZmlBqZEeU61VYNkS5azNBXCAYYUe5QDdRpJ/Oas
	lh4gHl3p/qbWlk2VhcXhHFSeW0xpKWpOtw/Lxzjw70GZjPS1Dx8Vpcb4GNY7wsZM1t+qHFGFlre
	MX/huAlZcypZgQ0F5KvATIbyqsQVTjMvwyChUi0dydSAgibYfDBNuYcXQetx2D696melP/jow3O
	hOLSY0qwa8b2yYMg5YMoRNV65MebcykxutlvXd0X+OMeNMJ1EMJaLzOE7jBHOHrVc4mTkaE4wEG
	DF86Su2WiNdEBlpbNIwsHa7tegRO6UsVyfl9qAEddWj/udix4h1i8qUzPhxe1TYIk3talo7miRA
	ImMeNmEWF1AOP8/lPd0YAglwKI5ItZTwc
X-Received: by 2002:a05:620a:440e:b0:8cd:8f04:50ec with SMTP id af79cd13be357-8dc3b03cfe9mr238711185a.2.1775689748767;
        Wed, 08 Apr 2026 16:09:08 -0700 (PDT)
X-Received: by 2002:a05:620a:440e:b0:8cd:8f04:50ec with SMTP id af79cd13be357-8dc3b03cfe9mr238705885a.2.1775689748199;
        Wed, 08 Apr 2026 16:09:08 -0700 (PDT)
Received: from [127.0.1.1] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8dc1514d382sm125665485a.4.2026.04.08.16.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 16:09:07 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 08 Apr 2026 19:08:50 -0400
Subject: [PATCH RFC v5 2/3] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260408-blk-dontcache-v5-2-0f080c20a96f@columbia.edu>
References: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
In-Reply-To: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775689745; l=3055;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=uxVNlK6BMzyn/Swuex2mcjfTN1L938gYzjb1HF2lqyU=;
 b=wiuqQGIUXlaDQRyL/2cvKQLeklEvgNwRkNWuSOVmD4QDiAmxSLl8wwsDtLCKaObM2FWAiuPdv
 KjGXMpBW4o4ASxzBvkdeJ8ApER14bjxSNNSrtc8cfpyy9YHBS4vsTeF
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: aw56t9jNmGdiE0Mnhf6S0eFoM-6ChCcF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDIxNCBTYWx0ZWRfX9IMUfX0MEDY6
 p1u1M8W9Q+Mi+0NZLoE8SKjI3Bn2AJCTk3gz6rW8LaGAoCwsKjRLrfT2sL4b39AgxgHG2TsRcia
 nWcDIlnaDqZQ/JLAEQdsnB+1N02lNIWAnyl1uablvYsWAwWrkoL1Q239NY1Ruhg92OSuZE1G/8u
 bZX/gbNhF20bIcjB4m0kZXg+VbZNJ6+mPp0tyUc89y/llQqIoEa/u0InU1nVy0eCh6rFID08k44
 7lp/QuoiFYdD2BCPHSwTsAcf5+jgxgYFetYzskUTnf2WIdMdpgQgrFqtZz1IdYTBJoTBtf5yYWf
 4zkNp6KCUGZiqdv11ceCMGyWRIn1lVehFTpT03XMzSMzBayAvu/DU80QzzJfyOviowezq+Aq5/Q
 HmUf3gA56w2C+5i/+kfB6ZxxkT+gLV1Mjn/laaA98wjXcwWQILAOJLiz/BQEdAm5SnuKuiB/ZL8
 ur1vjfNP911ns3HGKFA==
X-Proofpoint-GUID: aw56t9jNmGdiE0Mnhf6S0eFoM-6ChCcF
X-Authority-Analysis: v=2.4 cv=eOcjSnp1 c=1 sm=1 tr=0 ts=69d6e015 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=tmanUA2hrRIj4wcn57QA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11753
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 lowpriorityscore=10 adultscore=0
 impostorscore=10 clxscore=1015 malwarescore=0 phishscore=0 bulkscore=10
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604010000
 definitions=main-2604080214
X-HE-Meta: U2FsdGVkX1+DAv6UnRUWbeTGzK5WINBT390Wla7P7Yaenx8ZuVpktwWCpSu0uZ3XqRY3YiXnMKk8FBOPLIwlX8I2bF50AyvEJXETpJgzEZivT1qrQhwgLyQXuhjpADmYtv8aOCH8uyrJME+BIVtOc7K6NOJcbRFc9rN5/0MEG/Q/8ywBnPWfY3+ePVGN8vDBBz9mM3Yjy3xQHrtDlBqt66f2pKKwQ4DtlXSToNqSS6Y0u6Y7v9sosF1SOJ31zfpocttwDcwL4THnQ5GWDtQsGuYNL/EvXj2xIejBPCWVb7vor2TwLuQW1VwPJO3n3mPK8rGGdR8HI1clycftzonQoE2UhvEWuxVHISfClTYna17/Dez+T8Xwhz8hDRi+DYx6BG/JdU0bREaoS7492KcIjPzquxUcI9x2d4Wc+fZHZhW7kQTkYxoxN92niuBkIlgoaAXxF+HGFyq+Ado7qCeYwcKgaNB2l8UedzVPpkK+gR69/WnxxWrCQquSnpz3li6SRcs6DSXM8zPszp7oMZZWLnsNTEt2rq++tb8uNw+HOD3HZ5u52k0SuiiNiEdXMd43F2UTLgCihWpWmp/vOYeXT73TjFdG3kPwnlKVJN3Cvsxi9JdVbNFAN5NWmBUD4I45iGbN+BYHf7gcFDGilXKnn4q9ADmVCtn5rWjfWr95zITKR2w1d3BxW6iypvAo2NfIL5QIcwe7GcGIIqWrvTUBdoZkXa+/WsTS2mqf4F76/IqniEqvgfyo0j20eKeW4IgZrfbA4L0X719bUxUohVKlyWGDh24Wrrn2LCxyBnkGHuU91zUTmuji9CTXNurNfzUtG2SCGaDlZRaNSBOkn6+yA5YyTYO20+aTBOFIxcDshLiW1ABMCDiK7YlBp2177oLtKJNltiO1Xw5FvVd4zXWK3UyFLnKTYIB4D/FTLEg/g2pc15UgB8YCTjNru0/sQ98XCqzWIQN+fMFcOvjoyjl
 qu3o8ueL
 iAzr7Exj1cR5L1u7cXTuT+h7iNe41WxGp+FAdLV0QJn6xKRYYj4jAz0fnFKSo0RRRV9VqOX0TpoyvmDrIWVcAPhB6Az5sK6qA7TwK7rUsgzzwTLB61N14V0o9aznyImNfg8XODW4YC94yRVRZQABTFZnlmC0Zm93xk4m0LucGN6M+BJpLZ0/SmWbCpjxruw4d3GePFQKO00FrTYHaZP+mQ3vIBgPpEZZLq2/5R3PrWwpt/8AmhrZyS1zHCygoihVWDO2a+rnJtqF0NwRCj6FAqLfuC0p+gXZfjhpxQpUGmJKt6ChVxime/1mAABYjmygLiYDqyytloA00c75OMk2fuHeB35tEYgn/UjSVjuzQCfr8DjFWFeLba2WYibSHLh5xbKYVqqK4ad6eNW4WxDR/yVpn48EGxWWT/ETgDhY4AqopZl0HoSF7XdTH0oGqzqce/30RnxXx5svP4xIruZUWe9C1ckpDe+juMGtco633j14w6p8=
X-Rspamd-Queue-Id: 607A41C000A
X-HE-Tag-Orig: 1775689750-212974
X-Rspam-User: 
X-Stat-Signature: qnfdqf9fnt6a91tekgh4ii81i5tthf78
X-Rspamd-Server: rspam07
X-HE-Tag: 1775689753-5270
X-HE-Meta: U2FsdGVkX18XL1LpyVk5riGk2AjS9cE4ZcZUI+DnLrB4r/HzuYNK+OJdj3KmADGA3Wt9tT2+ACadl2Jcqu/duYICWj4sVScbk1CP+dVW3nJuZvR3d3R01PqVSUON6gnfoZhQtURjRg9q4Fdk5vqDrDASw6MfD+wiZfZoJ3jvTlBq5AYdLHspdo+8Fbq977hCJ0viEvcsZo83k3D7SCrKnJ329s/Img3hmR5EDboBQe2xGNJJPLvkNGBq5HcpJQK6nc4gEYNo+HA5v/nglgC7pDiaPmUmXHShAvH2vLpqy2B2GYZwZ1gtzcunDAmRtcfSUT5QgPWkLa8HEXAJc7upbXY7rkxmb8qxzkVArEdV4h/GJrGxH403K4qDxaPq8OIgwbHEiXJPf2DsviuYAmWCj//9289VSGvjwldeb1WAs1JlQ7qTKhS6NhEaM0dgYcVowNNMgjLgDDIiC7RUomnUdzeyz69r+DZBUzhkMrBFVGjUi5K7G/D5OdcygNFvOg9t7RWkArZtQH0DlTqVbRQqthH/1WBuGsQklbE3GXvuIi93u/nlTNgBwcc5b/gZhwsgmM+no7Kc4mi7h6q3aHzXxcKPqnodgY9H6kkem+/ud1+ps8KLujoq0LrhNMVCfHDUWL/rySL8hqaKOcTWEaRf41/zeNq4amL+0GOKDJN1mcQLn2DhZ71cEd8AmLiQi/8OHHHHRkqQsekpejvF9ya+MUIIqt0QWNNrUx1LMjEUlMKjPgq8n6KPoS4250pQ9QVrLb6+ABwrz5V+g3WHaBxG8+xyMcD07GW/5/mO/osvsZeuZL+iqYfleKDrKSJy33Vi7/WCdn5FDBFmD0IDNu8+W64W+M4qocFI8fhHbQOzQc8uUESeMBYROHPIH0mzn6kA99+98FA0O73MkjwGkodTTcF6gOh1dtwh+Z5IGZqudQzXh1WDOk/zuuXPuUTAE+GZF1+GNu7pnNDT4CDScef
 g9VqsMF6
 /o9aeGNuDmACSAEU6eg6ipH48iSq4YtXePAbpIHlIe5jDoRedxzh9RMSAq9VR9Q0jP+2Mat07o7kH3eUQbRMgOyIikc2ztVQA2kfEreLRBloF2l2y70h8cK98rUhfL9iBrkM5jCO9lb+EKE55eUkguUghI2f0qof788x+I9jCIKQcDTwvsRCAl6bCrlPeMbNU9FQ0QigZcbHBNPaHz9AZpLS8moKVRnG37/VhMQ/x90CINBvatLDznYZXqY5PiqOx7FnazA3zuHDo7s0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set BIO_COMPLETE_IN_TASK on iomap writeback bios when a dropbehind folio
is added. This ensures that bi_end_io runs in task context, where
folio_end_dropbehind() can safely invalidate folios.

With the bio layer now handling task-context deferral generically,
IOMAP_IOEND_DONTCACHE is no longer needed, as XFS no longer needs to
route DONTCACHE ioends through its completion workqueue. Remove the flag
and its NOMERGE entry.

Without the NOMERGE, regular I/Os that get merged with a dropbehind
folio will also have their completion deferred to task context.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/iomap/ioend.c      | 5 +++--
 fs/xfs/xfs_aops.c     | 4 ----
 include/linux/iomap.h | 6 +-----
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index e4d57cb969f1..fe2a4c3dae42 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -182,8 +182,6 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 		ioend_flags |= IOMAP_IOEND_UNWRITTEN;
 	if (wpc->iomap.flags & IOMAP_F_SHARED)
 		ioend_flags |= IOMAP_IOEND_SHARED;
-	if (folio_test_dropbehind(folio))
-		ioend_flags |= IOMAP_IOEND_DONTCACHE;
 	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
 		ioend_flags |= IOMAP_IOEND_BOUNDARY;
 
@@ -200,6 +198,9 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 	if (!bio_add_folio(&ioend->io_bio, folio, map_len, poff))
 		goto new_ioend;
 
+	if (folio_test_dropbehind(folio))
+		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
+
 	/*
 	 * Clamp io_offset and io_size to the incore EOF so that ondisk
 	 * file size updates in the ioend completion are byte-accurate.
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 76678814f46f..0d469b91377d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -510,10 +510,6 @@ xfs_ioend_needs_wq_completion(
 	if (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED))
 		return true;
 
-	/* Page cache invalidation cannot be done in irq context. */
-	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE)
-		return true;
-
 	return false;
 }
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 99b7209dabd7..a5d6401ebd80 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -392,16 +392,12 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
 #define IOMAP_IOEND_BOUNDARY		(1U << 2)
 /* is direct I/O */
 #define IOMAP_IOEND_DIRECT		(1U << 3)
-/* is DONTCACHE I/O */
-#define IOMAP_IOEND_DONTCACHE		(1U << 4)
-
 /*
  * Flags that if set on either ioend prevent the merge of two ioends.
  * (IOMAP_IOEND_BOUNDARY also prevents merges, but only one-way)
  */
 #define IOMAP_IOEND_NOMERGE_FLAGS \
-	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT | \
-	 IOMAP_IOEND_DONTCACHE)
+	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT)
 
 /*
  * Structure for writeback I/O completions.

-- 
2.39.5



