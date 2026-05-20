Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D43ACD5BAF
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 20:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244366B009E; Wed, 20 May 2026 16:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CED46B009F; Wed, 20 May 2026 16:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0969E6B00A0; Wed, 20 May 2026 16:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCB3D6B009E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 890ED140173
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:45 +0000 (UTC)
X-FDA: 84788992050.14.FBCB394
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2B43380009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=iHJauhNO;
	spf=pass (imf02.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779310243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yDlBtkSZ/QVPh/7V2LuCLj7vDoerhrZrGeObhOfbEDE=;
	b=2+s4X2V8QwPbvLwHtCMhFji4nOnoOz3b5A+k5lPGOupPSwUz9qEpofROxCS3kipLkwa/3W
	L2XdYpUBghwm8/YWjY0OBoeahKGPVxToqAIIKg+jUi25LcKR/VKZtpGfHizKxi1Oke36NB
	kFtyHEV6RN4n2/Mt1bofqs5lKNMVnk4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=iHJauhNO;
	spf=pass (imf02.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779310243; a=rsa-sha256;
	cv=none;
	b=Wk6UUu3I8dxB+ItT1rxdWzRAs2fYF9rhWdZc0IKs0QhSzB7nzp2y4G5gRHQSzIm1I3t/N0
	8VDGgRTaMg1n5jGsf7vg4dbEGmJLPEmum74tb1SIkI5W607Wyp8xx/L5nRtmQ6ciBihncq
	SX1RKBIBb7JAsHUoKXQMvrNTsqIV7QE=
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKO0Uh2354652
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=yDlB
	tkSZ/QVPh/7V2LuCLj7vDoerhrZrGeObhOfbEDE=; b=iHJauhNOQfQGuWQ9PBMd
	9498doyET3MaIYPPH6gAxhnfTbaNfiN2HpEWnhfQQydxrwb9YLjAr0f4Hzz9oE/O
	fgZj57LX1AT6vGPBI4TBSadyl2n+Ha4Tz+b8UVbJXRMfLIBkIuY/Ve9fGyVT4co8
	CWfypz/xg3x2wPetKTOGO0gbdH/nfd8bk8oUJYPlHyI8bnWD4jXB1S/B9q8XPwVg
	a/q7T59AHt1VqQQ1Jq/DCsxu26G8aGUFIr5qhSBAsd9ZVD/1vrojSd1jGW4Sf5ya
	FNIQdmkD5+yJCvLbmPd1L6c+MvkJlF6HEAnpWHT38ExeFCzYB0ApWQz8kBWW88CI
	Fg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e958qwyyn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:42 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-90d6fe98316so1206840685a.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 13:50:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310241; x=1779915041;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yDlBtkSZ/QVPh/7V2LuCLj7vDoerhrZrGeObhOfbEDE=;
        b=QSM88S7qx2X5OrulT1rEFxc/LVXsFqCzcjZJukYiYDFADG3G13fFuE+TjmlEuliPvY
         Azg1c/X33JKVovXbyLHs98P7jlnSBZZQEpCl6bSsQe1NdJZoQJMHGJ4eCDT2NB1bCPpt
         aw2uw5Cc/2hMWftD5sIPnrN+XLtOhLnp4MdRSMxqHjPFLpluyGM0y9FAsK+pmYQO7cCK
         OQ+Lsnq3H5YdLUqLAYF54WefdOUr/UBSW5B+T4UHC/zSx1UadnfzbOirvdA1KCgtJbfJ
         GDaU8Zy+AQb6SuhPQyt+ri1nFO6R6gUaJaX3LFNkZYZZKaVq0igCbPOxuEPSGhkmHiJi
         EdRA==
X-Forwarded-Encrypted: i=1; AFNElJ8kW9cpxUs2XK9nBZKqA7i4EYQJKqAZND1zzgh3hnMYwlztnalnmCYq89nI2AORvB3Af9MlECVe5g==@kvack.org
X-Gm-Message-State: AOJu0Yyl7knj2vy4Z2QUH5xxMHUEHuhS4nCetqnh5e9jbzWz5gKgxK4G
	Gpm2HyIMai+RRSP7/BnHhxpnfDrF8sk5NPuSrVaC+IK1hX/NSHb7nUT+fRPli83IQuUbyn2q+WJ
	xkFAFs+0sR5jpWF5/zMvEGfGj7rka90c4EQb9kV7o25xBgthc
X-Gm-Gg: Acq92OEhdNg4VDLakWAQfYxAQSV1C1+he98PnNbwElQkcSrJ4WAKQnv/DprAneNdnfe
	drzgG3J6xII3U55d7nrkH4uEAhTUYIb/7XuMujaj6/0HoabMQBkobDVCGGE/s4g6Y1vPH3TEZCD
	O/dH+zk0kU5UCO2c8dIo9l2occzUbuUXXmMBvjClt/+owgLURp/vckMsKND/yrzI9jYKU9IzOrW
	1hb/wJ/8m00J3K/OQdrPY4RSGYQ18cJZ/Xg+dYJXIOygiIoz7ehIK2eqjcU0ZaSq9TkAde8yd0H
	vNIuITBiuBu6rSo1TqlrUGo55GhgT5feJop4ik0/Obu0MVikFX8s277D6rly92yZ42nNhifgqKd
	T8uhNr5KMpA9ZPCYFbszPIe5qdtxF0QnKmQFRW1+PqRJlRR95WYtI5yC81tp5zyCD435rEKtNRA
	7z4A==
X-Received: by 2002:a05:620a:1986:b0:911:ed:d285 with SMTP id af79cd13be357-911cf9e0c41mr3857314185a.62.1779310241550;
        Wed, 20 May 2026 13:50:41 -0700 (PDT)
X-Received: by 2002:a05:620a:1986:b0:911:ed:d285 with SMTP id af79cd13be357-911cf9e0c41mr3857309585a.62.1779310241059;
        Wed, 20 May 2026 13:50:41 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:40 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:49:00 -0400
Subject: [PATCH RFC 09/11] fs: move dir_pages() from <linux/pagemap.h> to
 <linux/fs.h>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-9-c36ddc2b6cf2@columbia.edu>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
In-Reply-To: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=1369;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=rA3ee1bVN85AK8Xbqqgod0QTROlaUP31hnwYXO5EEik=;
 b=DCkZp86sCfuyRVBmRVmURwps78q7smwQhnDSiFfY5HPBUU3kJlF0UIoGU21dz9wQUTuZXJkNF
 UGqHDG78m7UBDAclN2Kez4FnTKNYWYrHvBGgRUTdHLcho2GLQ+5jpkl
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: JcSwQaM2sHEMiANdgpnDQbDXKt3XwMve
X-Proofpoint-ORIG-GUID: JcSwQaM2sHEMiANdgpnDQbDXKt3XwMve
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfX2C5JYfT6pKVy
 gdeIfnp3W6mb0fXPyX9U0hWtULo3R5HbjSyUnS8RUL8tXOgblzeTiBtzhW5VHeoXwKqy3otVJ7t
 USct6hW/Vp9p9/sC71R6dga0MGdJqsdtxXqFCsC9sEy9E409RqUyblCVipJgIDa+MoJ2n2y2PIS
 0OIyN/V0t29jmKqGTpJGe3ImXwfhnsWAh2AbQrXT2WjXp5/O05xGWDlpvye+esVI5xsDbvZeFFg
 4Ddc+N7idzjVCGFtLY+OUGmVsYxtNChcX0aw/0WFBJQpmxJSldKGeUMfVqo0UBQpcwZHRlympnX
 +njkZS+aJZtUOyakemTzeehot0hPiN7Wnlv8aoA38bg+HDzs/QvASi/cuH60cM2L9Uuwwr7yrQ4
 jm/LbCnYRbZnhPLO83HzOzzum37ikmpBVB39jC5J9o5+/V1ajCozNn+M/SBYJKCKz3nB+pueUgg
 Mh2oEzaBrMzGpi1jlug==
X-Authority-Analysis: v=2.4 cv=W6sIkxWk c=1 sm=1 tr=0 ts=6a0e1ea2 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=8LwvE8iKX1rSyJpzT4YA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=10 priorityscore=1501 lowpriorityscore=10
 adultscore=0 bulkscore=10 phishscore=0 spamscore=0 clxscore=1015
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605200203
X-Stat-Signature: dozqsseyunqd6eihke9kw4yfckjjn6eg
X-Rspamd-Queue-Id: 2B43380009
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779310242-673014
X-HE-Meta: U2FsdGVkX19DDsOdk8Sye7QQhzBkS+P1niQ5RS5strFOTQTmrAMhV/YFDTHcI/4sdQvJJ3ZRppPFVmrZJviyLWtXLMhBH9UBbT4pv3MFNjvrvOcdmmzOMyxwPwwn5mqF12HW/idFB/ORLR8PDnoz3koiRKCnMM0tmHKrSvRK1kCJhNiH1KIpyIqgFMiMe6+6pC39TWIM4c7CI4hNieZFp33qxa5vLamumQGU+uWOxNcTpz/Fcx63lVLRZ8fuc3LE8oZNcB78Wz9uItrajJdyfQQaf/1I7JO0XgrpyHBPv4Z6PCgRgrVzwBzn09WQY6bdNSk4j2ZABg9UtR5Vnyr9/HOmBFYEmgBis9EQhsayb0upD1TprYgFYNHqgrKg2qQjdwaPhvgQAtMcJmnUI4JWXPzQOwnmuSK+QILuX3Or5WmfSXkHmNvHXA2RQ1Q008SkSJ20BKBwsrj+p0/2tAAVDgINe3kWbQi3xDKWsq3BVZPQ+MnQQCVqwHfYj0JeieojCKZV4McOOaDzUb3tZn6v7s4PjNGNX2uLk3E3V23SH+7wkCBQLp7XjVGVEbfWP3ZwmKL1BhzJwz5U3IbcUCjjm5SoOc2R1N/KmuZTSNwIpILABN78qcqQzAKkfLYQiXd3kiqKkkQhrFqFV5ysJCcLTeCTHip06QYAikV1QXcC1i9lKiHhJbfXqAhiAVH2QlIQFYAtcHHfEk/dIEV7ZARYYu2xuP/GZe249Z2s+EFZWjOH5I0mzucVUP2N1E7PryaJSydUYDYaVBXBv1Z1horsotfx63ZPXJiyJWGzaNUkYwgtzsUVZ/ns/zkcX385ktU6nKifarWmWL0sjOpcoeODY3BZaXI1YT2uthMSA0J+bF8fSzp5oCB6sIB8hOek0HKSqew2NDVjorzfxiJpNWUpkeZx+LeC3Smdwp/yLYIMRmXio/5WoOQS6eevYch/liHPNF3M/WhLdKcvUBGrZ4M
 Bp1TBthr
 fBzY9JWmThRGf3ojQQEK6Aw+eXhew0w1GyBBFHqi+1HCRXrbBkaJlrE+WHP14fAJxwRpWTLptfg8ZW6iEa5XJU/crPdHb7F8cp4dSnJyQ5jSuAii99StHqlv2L4T24nsE9bQxWdy0Gdvi2yTNbJB5Sit5GR83dLH3vJBM3f/8sk5+cp++Kf3fes2Wxz0k1x3NpYcS5WKfESZgPHeW/NV0NGDLs7xXwu05JYisayNKSxAau5Vq/JXECMZrlomqdNO5i3oVkIW6kg/Apxkr7mfcoaV8Y5+9zXwoichpoSNs5qP3gNaiyKuJ4NSVoNr1iMWFO6cyqI+ylcFngk+F77NuWrIz9+6g22f5GUdd9XmLsQoN26Jf412bfO/zPVP51F1GOzStvCJfmqkAGEgA3NDaYU8jFhUQuS8h28qUucdYPSuh70fBkpZ4F0Nb8NHH4Iu/kFa70pzZ25QOvCLYCXf7ITwxHcoT9U/oi1Mz9+s3mh3gPoY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an inode-based helper and should live with other inode helpers.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/fs.h      | 6 ++++++
 include/linux/pagemap.h | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index cd5088dfe9a1..776cc82932a7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1171,6 +1171,12 @@ static inline void i_size_write(struct inode *inode, loff_t i_size)
 #endif
 }
 
+static inline unsigned long dir_pages(const struct inode *inode)
+{
+	return (unsigned long)(inode->i_size + PAGE_SIZE - 1) >>
+			       PAGE_SHIFT;
+}
+
 static inline unsigned iminor(const struct inode *inode)
 {
 	return MINOR(inode->i_rdev);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 84ccb682cca8..f86a550ad516 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1356,12 +1356,6 @@ static inline size_t readahead_batch_length(const struct readahead_control *rac)
 	return rac->_batch_count * PAGE_SIZE;
 }
 
-static inline unsigned long dir_pages(const struct inode *inode)
-{
-	return (unsigned long)(inode->i_size + PAGE_SIZE - 1) >>
-			       PAGE_SHIFT;
-}
-
 /**
  * folio_mkwrite_check_truncate - check if folio was truncated
  * @folio: the folio to check

-- 
2.39.5


