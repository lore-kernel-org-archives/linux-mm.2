Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6775D606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bd8T52sM
Received: by kanga.kvack.org (Postfix)
	id 660616B05B9; Mon, 23 Nov 2026 12:36:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60FE66B05BA; Mon, 23 Nov 2026 12:36:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FFC66B05BC; Mon, 23 Nov 2026 12:36:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B28A6B05B9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:36:12 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 918851A0991
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:36:11 +0000 (UTC)
X-FDA: 85467087342.26.DA1FAEE
Received: from mail-dy2-f5.google.com (mail-dy2-f5.google.com [74.125.229.5])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9931A100007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:36:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bd8T52sM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455369;
	b=jh0Hq0RGa+8R1REGiE6WdvfUMUMPJMwX66gBk42LeDqWaWOhPHz2oj82zFTyoJt/PwAYVD
	zkINibc7RdhePg0L5f8CESLvRpMW0my9pIDIxd3AssHhTuNOE+liWepNQVsNEY54oR6H6e
	bfCh2j6fLFNENMrwVDcXKw6UM6E2xpY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1YI2orZDPUDngnmyZYKSupAwoF5o8x/LtOe/S2TQEqQ=;
	b=kU4gY7Hs6qe/zyXKfJ0VfNENPeLYJ7XL9vE74E2Oo8u2UolNNY7LpjJM94Nc93srtVPACR
	Fsgno0KaI7MSIAwU+1sqXWOcYkYIckZRP+fZFzAG4qmV2eKQSmK6P8+tEuywYz1tH5CagY
	/ZOzNVEkdpNBGOPWng+BmGUhSavyGCo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bd8T52sM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f5.google.com with SMTP id 5a478bee46e88-36f936424f2so992913eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455368; x=1796060168; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1YI2orZDPUDngnmyZYKSupAwoF5o8x/LtOe/S2TQEqQ=;
        b=bd8T52sMBPd4uN8+e/K6tEPdx/RHQ6AWYK43ME5VuPuL2vAf0KkGmpfzNggZDDb+hY
         qdGS2OmnJCUsFZnbkH2d/l1sKumY9VZ3TN2CSFISVZU+4G7KlFlHfgB3p1W+DeIZnuGJ
         wYgf6VHib1x4I4rQRCJOU/SlbM5lX4lf2SyzNvZ9XO8QXqUQhBVOgsi2h8HhzYZfaqtp
         kUPPGClJX07tLE4st74cK4JkMfy/Rq/MRnDGv/JkPLBuXhEJfAQyfEmtkoipOU2kYyRA
         I4ttFo9irsZHMPJpEoDCHRqam7aW1xkdHLiuWEYibSPHXTb+e/a/D4wMMuLdHCZEgfNc
         VN2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455368; x=1796060168;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1YI2orZDPUDngnmyZYKSupAwoF5o8x/LtOe/S2TQEqQ=;
        b=uSXKNCDWfY8teXQ5F8Bvn3WjktARdzwqpg4053KjaFr8MWhhix43Ul47dgUpNpTkWB
         oiEw2CMGrzE2RJUU2stM51UqmFcoEhqbLTJ9JD/E3HRPDL1dfqwDqMgDXMEHJLk8G8yN
         iSWDtpi8QAk6V/UX7q9gfoi3sBtIYyCvB/keulqSRiXbP/jhXil8mavwKSLYPPKD9H+8
         Zj2NmsACrY2wodOiKNzGjs5hJfzYwMLeobEktXbRvMj82EgGgJlN6bcxwRPM7e79L5np
         zNCmbomFQBG0mOLdEr6HvqaTX8grx3I4W+H3TrSTZR4hGz8ZCulPgIOMpFCuo/g2fBjm
         kS2w==
X-Forwarded-Encrypted: i=1; AL+hErGVUv4UADP3412GrvUFEwHrn+Oz8PFJq0P5dNC47ys8BjmgBui/diNE0waRaOkuZqbMZ7ljwhc82Q==@kvack.org
X-Gm-Message-State: APuU4Z+RUuhFjDUtuUiPMjpxn9Skdk/GNQ9enxiYVmK8nhxLYbvY80/S
	C1vCUu0IkdNQOf3OI95N/T0w2SMETMLK8riuXrvJx/hstVmOjK+dn2z/
X-Gm-Gg: AZFdTZcN9YWhcXnTKd3zjJNWSBQqghTEMeH0moRkte4gV0XCqh+b1MwIR6WsxGxLIFA
	84rvcXosFc763BppmCenHokNA5uyiboQVuVeM6x21YUNZrymBu05B6sbJMZuy1+E0avps4bRvvO
	K1aSYvR9/PYn4LiLrzuvepDwXqAu8wCivr50sbPX4teHOEa1cGNNC+VJd3dCmxxCUzH1wmNZyYn
	j7iwCzn/C48p94SYGwamumYQq4dVB9FXck+J8mWrrrsecstQA4U2j8QBFt+a0OJWVIC02HzCeTu
	vtg8riGulu87iS2Jb4N3avLlBUhAzR5UTgA/6eqcsD7A1eGgvFpfROiDs5l07Mh23Zk7o3bHI9A
	v5dcBSZuts92MU39cidg4rJzD/4xKqQUq7d1Ihe1Fsx8D0wDZ0Tvz25CmLGS18DMj0LV4BBB0zd
	mRX5XVfwd7wmFiW5RNv9AIcLVhO/l66qmQkTGNguDDSlfFAqK/5jxHvkKkulYpMeMCtTzJ11gf0
	lQG/B+sSNAigQq2JXDTvHsaG1xyj9QxchQt5mGaeshXYTRyLEHiZTzk4Jy3+nxGcETkl1DKiuH4
	xDJ4niOd9SarGOcmmqH22LShDr19cVzpU3IXdfDWt2U6DAOvfjm6B+fkdXIs2Zb5BsFrrqD1lEa
	X023/1cZeWfd5xzPogYPQzD4hBoTvnUvFLDW5x5943mDJpeoOEn1hnjrjh1MVFKgtThyDf2me53
	pl/e2g2VA=
X-Received: by 2002:a05:693c:6010:b0:385:849b:7899 with SMTP id 5a478bee46e88-385849b7adamr14110309eec.4.1795455368271;
        Mon, 23 Nov 2026 09:36:08 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:36:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 07/27] mm/damon/sysfs: implement report producer
 directory
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:24 +1100
Message-Id: <179545256498.4.5820255102137100111.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 Lian Wang <lianux.mm@gmail.com>, linux-mm@kvack.org
In-Reply-To: <20261121210013.130397-8-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-8-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 9931A100007
X-Stat-Signature: uw5eq6ady7bdfaam61fpmx7xbhybj1y5
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795455369-110408
X-HE-Meta: U2FsdGVkX18jDkLq/HzfH/CPAQpz+pryuQk3PwJ8dl8KgkuzPIpYfo+SEJFwMwYSRMv0DnzttKXfw556wWID/JPtLFltIms4W/Bbj75zHsJVtPu/wAJz6HziqWVkFkkgFDDvkoHNeKgE2VVXjQO0w9KmcHLD3c8MbnNi1Q8PPEEk7QCfh3yT1VsXrP18n5v7IoQaLxflNgeLhPyjWFheEyI514Jwk3e5jjBfBOiuSKOPLoiHFCd9vT2SyVsc53B22PnKeuTphYucfkHUALhcNkn97B6d7lZeADfDHPzMqUTjHSqB92gEcTaHX6O0yBGR5VtEG+SK3zQJUXui7U4AoWBSUkgULLtqgNPCeM8Xr1pdmXHfoYgj3Lbl4W9dIsfbWZrYicuZsjpQz4+cjVSikvheadue5hgEX/QWH7dYd25WENEo+SU24qhLFoTDQUbYI+vywn2v2RqnmCOGpce58jvRsNYY3dvA+u9m7aqgrsFQjM2KfUNMiuanUkgSEFgtEAgDM40czZjoAl2B58M8bChgCBTr4to/zbs8INIh1RzZ4YMp5c5TyeY3k8xLoH+Mzx2/RDklsaibbF3xbtJphNl2IeZpv6qytZ7SAE9syqqroTuH06i4vzZryZwBi2GuD64fhOg5EOqvm6nMBkkBAJsqK6dRjuyuY42xRc0vLNOP8Wzet2dUR58w5tT6s1Pe4HldAkyEmeNa/YOsGeGiCBJG4TnhsRmlEOyz0M7NR/OhvwMXF7WzYZps1VLTurdqhdaReL+eLfl6gk9HU1GpqSNIhgo+kVXhs40Wu2kXerDWZxFZ9AFPes725mA8E642ZZcT0m3jv7I7055OimjcUJgvoj4OCwenALFigb/Se18pSGcBP+ur3k6+kd16bRxRw2qzjMCpN/cF4U+HlLOlfTJzmzOwKQeg4jjbSBXT0DTAdmyUAbx+1vPbWFH0NBK7u18pC4gRu4/CvdUIP0h
 ZLXncJEv
 yLrN89ExdmEdVqbq4nlLdpTf/Tjbn3H1Rxc+RVGEnbmfjZbz+z1MFEO+HJnfm1lv+HG3hVWelImgKCtHCXX4UiMx/uu+IZWqRI5f06015V6evnaS0bVBBF7N4ipMqEGcQKpDWnARKZ9ZFlMVnnsFRcoTW3VYiyLRoqQ3LqHn/ftdCWdicGlQI1NvFXKMYGduLmI3uK7pP0AHy/b7/fNxVrtRPl6VL6l5MdxsgoiR1dIaJgM4DM2/baXHdUSOS56qVfgnjgI9SKbrC8vBQ8TZpaKWJZ2/wm47kqJRPn4TXyGOyz7BtHSnCnl7MzVu7T1Oh3CHnmdAi1O1OizCmZuE7eJYJTfBqD7iSZvh4YQsFn5LuRgbmxZWBlFtlYLkLIQTiZO5zpsHhC/35j2wrsWyic88fDgf6ggH3sVzwGQx2u084OY/lg8ZTV3PZRE3BkFn5ubSbQjtV++q5HGYBWyBcPr5+mItNpxfLZzF2zb+Hx1q0m2mK2c+o3X9aYo9PLlZhI9SeGrOcvY8Wu9W28x3CE0OhQO+1AShgqY1IrcOiM+Hsx4aArlxF8XnwVF66FldSd2ljHWkRUd+KQ9lPdRTfbhTH2CuWFWlBFMr5EAIAAslatfd6Nz1awi2yw2M0a7ykYlMmfQ0EJPlTwUp6ZRDlv5e+R5L+SBDGpFLFRiwmtASdi4d2M+4d/FayNShmuLoOXh2+z4rkTUKINmp7pCYYMsXwgAqHbfVm0lDRZ0z5XYZDCIpufVA0qnlPUDH6uPEEgjE+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 12:59:51 -0800 SJ Park wrote:

> Implement a sysfs directory for each report producer.  Create and remove
> the directories for reports/producers/nr_producers file writes.  It is a
> placeholder for sysfs files that will be used for controlling each
> report producer.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

