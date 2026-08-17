Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B9ADC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 19:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14CE16B084E; Mon, 17 Aug 2026 15:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D6CC6B0850; Mon, 17 Aug 2026 15:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92156B0851; Mon, 17 Aug 2026 15:15:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5E426B084E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B2C11A08D8
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:21 +0000 (UTC)
X-FDA: 85111714842.26.0BED268
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5E9D140008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=cgEgAngC;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=3WS69p4k;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf01.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786994118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uByW3kj0cNB59zzwcHQzAIcpQ5hlDdKKnX/d3JEUaiU=;
	b=bgtaJzw/0C0yBb1qcnBrw+uhz13xFZJWz4SC/x3p+7GKh3GUP8gmh/u83Y+g4Ixy9sxci2
	yJt+hYGz9zFwBADBfDdNRpd/8gQAvnKYA/odn2rJ13gkWPBJbDhI9zcG44C5RbadDYBKG2
	S9kemBz+mBvw6CdCkfg+0onz5DI5SPY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=cgEgAngC;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=3WS69p4k;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf01.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786994118;
	b=yk3trJ6ionV4Nwzu1K/rjl5HqQgW6aFJ1drvjJ6ND1XdSeEYn0K0ZTih108tmggXmzCfxA
	+9qp1vBtSAz8p2IDnenzfj0ulx1liFVTOR3UXLMHSV1Vu8L6hCUZ6hb45+rdHpSwF37RH0
	salCaHrLnqdgeps2RPpND2tqoXYBtsw=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HIYhoe4004499
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=uByW3kj0cNB59zzwcHQzAIcpQ5
	hlDdKKnX/d3JEUaiU=; b=cgEgAngC1RHM+L8E6tBdYeQb9iqkzadtLVuGO7mbO9
	dilB7H3YOGvtt2vHYykmsGIODc1BHasv+wdsMlwcbS0ndqFt5g0i2bsISQifFRRO
	AvN5cQ74rdLiu2fUcZqjlirXZLEcST2aP7hNlyPjUxI9sAE/rQM/NZydkpRTzuXk
	1jYW23Pd3Sd2P7p4MUCh6iVRpXjkrAp4rMSHJTvMC07sc4g6b/gGt2i9EXmc5L9h
	+K2uDiT4VkY82cIdvKXvmBdCBcxvXs7vX1HkdMf11l9sqOKM2Z6sVt1zK8gQ1Ygc
	uJOo8waAMjVBMOMjpZVQOu2B0ZgOoM8YBnqxD74rd1IQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4g43e0anaf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:16 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-92e5fc4c7e9so491921585a.3
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1786994116; x=1787598916; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=uByW3kj0cNB59zzwcHQzAIcpQ5hlDdKKnX/d3JEUaiU=;
        b=3WS69p4ktlMmYb83N3w2NvLbzMHcWaXdU7Axd4cwqInzIrT4TpLFcg5FAFEPv7VhpN
         HCSIgZJlpAHpQUJ1JHqxpPqc3102kCDzCvp4yeuQz0tGPfumkAMh5sM2wgOWDrOXA1ed
         Rrb3Nd1GI+m8cRC4jyfxYzQipLbZvC+DlH/8dSMQG8xDLJZqlWYcxozVPdyWmPNhcrGw
         JFt865iPq9Q9osqxZ9DsMtP0kxwIs9ENuAW4ODAdEB/Bju6gOWfIWrrBAMV7YwYYpeuL
         /iFlFHooQrC6XUrBSIcaUpPq78rqWGdM4LxB4znO8XSG7t4FdPBYMaGqJdvXWCaSsMi5
         6jbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786994116; x=1787598916;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uByW3kj0cNB59zzwcHQzAIcpQ5hlDdKKnX/d3JEUaiU=;
        b=icACM3evvaVBXWfa1g8I+/4eBMvMUwF6hPnqWu7FjHHK0fF81CYgHECe1zIEWndEc5
         rytRa0WpkaGn/rrYjXipawMxmiyCHfnSz31hEa4dOihPXmdFAP59lppCLgMlLGMP53sP
         crD/Er3pz8PdlzmUJkfJFA/MHhlOBygFaT/VyXwI/wcehMrhzMI3bf13rTXERXGAT5+P
         cEKeMc/QWcxK+THJ3PLJXp0hHQ3XR38Pkts0SfkNNxk0nuxR9T+dCuzv5iUPtlQ5HxVM
         BrVJqR+onKLr/jx0q+7bMixcksM6DoM0Wfqoh3x42Zw53t/1gN3RCJ5XwXkC4Jm5wtei
         zMKg==
X-Forwarded-Encrypted: i=1; AHgh+Rpz9ffYy2RM91YY5TxLPbOz5AsME/PSrNUD/EjWThZ4THthieK7eaUHpY/Qiy6cL775IDmZyGdNjQ==@kvack.org
X-Gm-Message-State: AOJu0YyLpDLNSaZREiQ8etWdKm2OhXZLLX5MYu81cb5Ylr8Zw+C5q+Nt
	3Voq+44WMyDEzEId0vE6qKLC50TQRktuZ9TsW1sPzcaejlbh1MNceI7kUo4YW4lLvqUUsLUvsIx
	FFdQVz9f+GDuUIZ608BU/DczTDhifmmj0t71U+y6AVsjI6a63
X-Gm-Gg: AR+sD10kTklnyz2m5PeF5+0YCISD1G7JDLBHuxXMCMouzRn/54E6ZqiiBPcu3T/Yxv+
	DYmvFZH+XLVbDkMwKtm2ffqsPdOmy6OL+SV6ZkU44RkJZ9x9XAz+Zr3XqtVuWYacElHnTlExicu
	N952QjxaneAKs+e8/crTjZJ55ba/sYC5zTgrITnYoSFnWm8LaU2T9iTtontyIecxAcaiy/m02p/
	W8aZXsGMQdCicG8/rCtV6Tndtp5sq12sMHw8Gvf5XYfXs3sugxvtxPVPVgJE8mj6ebgTn7b3bnB
	udgAHjs9sxIRuC1wiXN5stY3raZ5Eal4MQgIz21UorUiipfgLKOrS92qhqgRNzVL5UVkyL0x/Jc
	TfluZ4h2+
X-Received: by 2002:a05:620a:aa08:b0:92e:db1f:185c with SMTP id af79cd13be357-936d2355b08mr2578315485a.43.1786994115614;
        Mon, 17 Aug 2026 12:15:15 -0700 (PDT)
X-Received: by 2002:a05:620a:aa08:b0:92e:db1f:185c with SMTP id af79cd13be357-936d2355b08mr2578304685a.43.1786994114838;
        Mon, 17 Aug 2026 12:15:14 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.67.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499961098cdsm194692085e9.6.2026.08.17.12.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 12:15:13 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v4 00/10] ceph: convert writeback path to folios
Date: Mon, 17 Aug 2026 14:55:16 -0400
Message-Id: <20260817-remove-wait-on-page-writeback-v4-0-0e5e53d47eb0@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABRZg2oC/43Oy27CMBQE0F9BXuPq+hEnYsV/IBZ+3MAtECM7M
 a1Q/r0O3aAKiS5HGp2ZO8uYCDPbrO4sYaFMcahBr1fMH+1wQE6hZiZBGuhA8oSXWJDfLI08Dvx
 qa+WWaERn/Yl3CN61xgTtW1aNa8Kevh7+bv+b8+Q+0Y8LujSOlMeYvh8Hilh6/90qggM3XjXBO
 GWDMlsfz9PFkf3AMLFlrshnUL8DZQU70YN1YBrZ6RegegIFvANVBUNoGyVa0L38+3Ce5x9vt6w
 kgQEAAA==
X-Change-ID: 20260802-remove-wait-on-page-writeback-8e0cb766d4c7
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Christian Brauner <brauner@kernel.org>,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
        Tal Zussman <tz2294@columbia.edu>, Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786992937; l=3475;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=qVTLNDcbt+fJaFQvv2N1X2GXRE68u458QdYuIn9iM4c=;
 b=YF0CAtusldpvdNFh8yT893tshJfP33e71vJS/zp9Vyv5PiufZBdZxAi16AvQVuq0GUUWC20VS
 /B4v9H2a8PNB9uBQuLwzJLJsesUtNCcC4r5QOysYJvEWLuOWP5opkIY
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfX+rN11XRcgYhg
 LjLo05y1hjIni+M3yOMheXXdahqIqearofFrgZz9xLWIFAgJsWCTmca5Cx8YHC4D63BbJZUIWIf
 Sf5NoldwC7KGynUewbhwgk/+PJ2sEuDGLV8trNIKvbjGr9TbrT1AaFuE8ZG6x7p0T57eadaellq
 dk0ETi8m7Ukcp5/OiEq49dgoAIdYp04hfM7PPn1Vfw+EG6qfd35HRbQvSdLrJWYwqTqnjyvSxPI
 DKSiy6esL1U6MpQ6TfojrvqFpk6fygm24uESDDjxEhZNN7Tbjkw5gxI7xsM12ipUsDfxjPa/XWm
 AsJmpIph9RrhqeDKIjvtCAsEmgSpsvt+CmXJD1CnyZqq3U244iL5qZXsUVyyoCRlaM4wIcnP1dS
 FjqnbE1hHc+SpFxMvfzXex6/y34pBp87WLM0xdXTjGzY+TBN98O/Mw1FZmqOtv/QF/15Bvy8Mjl
 Iz4tgqg2s9doa+Xq0yg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfX38nKZ1HnbkA/
 Zvwl+Mdgb/E5J1r77UGBGJZonyN5a20yx+MzOaaOh4i2zwidHkE7rkybTi4fPnq6AtLqMowrLGd
 Oayt+lL0oA5pfyumTjsBOKIo2OYWeusaOcCbs07vx/+ITZVxmK3d
X-Proofpoint-ORIG-GUID: wWHGHE0KbUfIAqGfw_QdiY1gSN6ETMOe
X-Proofpoint-GUID: wWHGHE0KbUfIAqGfw_QdiY1gSN6ETMOe
X-Authority-Analysis: v=2.4 cv=HLrz0Itv c=1 sm=1 tr=0 ts=6a835dc4 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=+gpNN1aRt999K7yrv1sWlQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=K5e0w50Y35hYhEYsqgEA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11878
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 priorityscore=1501 phishscore=0 adultscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=10 lowpriorityscore=10 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170147
X-Rspamd-Queue-Id: 5E9D140008
X-Stat-Signature: bowcmkokp4zzai4gags1btsgbjfnyk9w
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786994118-362425
X-HE-Meta: U2FsdGVkX1+xnJSH0H5RqN2HZt6qcLADt5ceAS8OJ4qJgQAVAITTTOOJnnwlLPGA2+o4y9/xQe+ToSI552BQ4Tc6YMcwGJyzI2jyfgKSEnWcUZPPufn1CzMk4maJ2q+UX5Pu6HRuIDOgeIpVgIT98RaPmhhKBZ3fRYlsoMbt6viMrWMwFXWLRJ1DJJgyXy4OKXmb+qXLbUUW+R9All/rhsi1snt+65SpJLXGVUA7dt35EFvcXuxeBvu22FnBhSGKB35NXPbIjo5kIDZyq5NTdklyTsHKHfpVPPVyh+fP11xmSXUB/dAyHBG4LRTriRQbfAbj6HoS6SHipKg/FNRJl2/iJjLvO034axKpY4WhNfSLhJ4yqH+z0nX8BXn4MczvqYKqcJFa3davj58AW/qxe/P3VDQxsvHXVmoX79xKSZpbnxKJ8tarR225diqvpbqTHFG1M5GfCsSDKjug4fupzOxzmDa0DVwieWq8WtCkkgjjWLpnVk9uvDlHfvm8OQTYhuWPhcgKwiv5MIpogKgPTltM+BSfq8zCC0Vp2qShMAtRn8Alvqtyt58qa8d+WMHK+XNUvGrW5txVT3d/SENlWOB+Oq7VaziSOjEx2UY1WNFKnDb9ffw56/ynLklYkdCzMLJFQz7ToPeCDquNnSfWgLRgleIMbKrhd4n6RXuAv7ijBHSbOMyW53aH6gflbA9I/ELGRGnGCqfc7oaPUEy+Q6EqStP9M2Xgw0sf3jRlpbqe1HJ2w/JHYMX0B49F12xNtnhInbELK9SNE/ckmWwV2KHxUQUWuEnbWgnmrdrTAqa7rGZq9fn8Z/Dvvdpc2eJTn/BQ6Hg1KuDpdzs4w3XXrDQ8mIBcUiwbxRThCHKZkZP3xPBph4hxmXzSwaf/GsnmEjXichrESk5ZRg3MEvLx3cLCo8N3eE5zn3pdUq3XlCGvVVh1E6ru3jhILjmjD9OHA8EimC0TyVhB0facYL2
 pE2hahZS
 QW6yeBmM9jmhuG+mr3xgYIpmlv9EZNtO6kcip6w5pw56rhXC2lOdrLciWKBPQGvf8LlowjR/+XiId8u02Rm4WaM+BMPao5rWimzQIRidWEEatgar3RUEKKBQDSGKfYbbFNRUnf061AQ11TPizl6AqQubi/ncS4nHilyig2bwSPTBFEfV5DFd9AzMr1W8NNgBOkz5MUq3vEwVkgR/anUAuaB2VPTuUXWhzW+LJsPY8RCYgeZA8vxtge0Qn0ozny3OvT54F0MCaN4CBtO1uargtDM5tHaj0sMLI9H1E368X8dQNZKRFz8dpSETP0jOflTFWC9oWYBJ7/TFuQmTKbOpUUxvBAluncubRnwlP6uRKsx02G0Of4L9/kn9dVu1AUp2nXqsaLTKAO7hdn9TRLqFgKIs1altPvIxtK3cPhZO9wHX8qpEKFlv/U36jCTpSRQu+8/nAPVq4QbDtaW5F1KZjNeqXQZdqaQajKoI0gk1GJZwUusAm85ZqFDOsFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert ceph's writeback path to work on folios. These conversions
eliminate the last callers of three mm compatibility APIs:
wait_on_page_writeback(), thp_size(), and thp_order(). Their removals
will be sent separately once the conversions land, per Ceph maintainer
request.

This also fixes a couple pre-existing issues discovered by Sashiko
along the way.

Some page <-> folio boundaries are deliberately left in place where
ceph borders on some gnarlier page-based APIs:

- libceph's OSD data plane is page-array based, so ceph_writeback_ctl's
  pages[] and osd_data->pages[] remain struct page arrays. Folios are
  converted at the array/libceph boundary.

- fscrypt's bounce page API remains page-based for some functions
  (fscrypt_encrypt_pagecache_blocks(), fscrypt_finalize_bounce_page()).
  Possibly-bounce array entries are unwrapped to their pagecache folios
  via fscrypt_pagecache_folio().

This series is based on the ceph-client testing branch [1].

[1] https://github.com/ceph/ceph-client/tree/testing

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
Changes in v4:
- Rebase onto the current ceph-client testing branch
- Drop the two mm patches removing wait_on_page_writeback(), thp_size(),
  and thp_order(), per Alex
- Patch 2: wait for the pending fscache write before bumping the
  writeback congestion count and allocating the OSD request, per
  Sashiko
- Link to v3: https://lore.kernel.org/r/20260810-remove-wait-on-page-writeback-v3-0-dd7531704f26@columbia.edu

Changes in v3:
- Add patches 1 and 2, fixing a couple pre-existing bugs found by Sashiko
- Patch 7 (was patch 5): Rework the ceph_submit_write() error path
  conversion on top of patch 1
- Patch 10 (was patch 8): Remove the BUG_ON(), per Sashiko and Matthew
- Link to v2: https://lore.kernel.org/r/20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu

Changes in v2:
- Propagate tags (thanks David and Matthew!)
- Rebase onto ceph-client.git testing
- Rename the series to "ceph: convert writeback path to folios"
- Patch 1: Drop the folio_test_private() check in
  ceph_folio_snap_context(), per Matthew and Zi.
- Patch 4: Introduce ceph_fscrypt folio helpers and use them in
  get_writepages_data_length(), per Matthew.
- Patches 5-10: new
- Link to v1: https://lore.kernel.org/r/20260802-remove-wait-on-page-writeback-v1-0-6c35d6b3ad36@columbia.edu

---
Tal Zussman (10):
      ceph: fix error handling when the OSD client is stopping in ceph_submit_write()
      ceph: wait for pending fscache write in write_folio_nounlock()
      ceph: add ceph_folio_snap_context()
      ceph: convert ceph_wait_until_current_writes_complete() to folios
      ceph: convert get_writepages_data_length() to folios
      ceph: convert ceph_submit_write() to folios
      ceph: remove page remnants from write_folio_nounlock()
      ceph: convert page cleanup loop in writepages_finish() to folios
      ceph: remove ceph_fscrypt_pagecache_page() and ceph_fscrypt_page_offset()
      ceph: rename ceph_check_page_before_write() to ceph_check_folio_before_write()

 fs/ceph/addr.c   | 156 ++++++++++++++++++++++++++++++-------------------------
 fs/ceph/crypto.h |  12 ++---
 2 files changed, 91 insertions(+), 77 deletions(-)
---
base-commit: fce4f3da41f1145cfa400002ce3a66e4a89a1902
change-id: 20260802-remove-wait-on-page-writeback-8e0cb766d4c7

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>


