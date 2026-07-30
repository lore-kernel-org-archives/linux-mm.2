Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39C18C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 06:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34C956B0096; Thu, 30 Jul 2026 02:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1126B0098; Thu, 30 Jul 2026 02:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 150B76B0099; Thu, 30 Jul 2026 02:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB49D6B0096
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:59:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5593B1408F3
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:59:08 +0000 (UTC)
X-FDA: 85044541176.18.1348437
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id B884C180004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:59:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=UCAOFlRP;
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785394745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7lnMAQUAxGl0d0xuPXIIpzK+l0m5WwNxFhJZwOOAO20=;
	b=x24FPoV+jiEgxPqYM5U772mN99W72yCUetj6Cglg2RmnUV+HOVx74w54q4PCyDVElP5ypV
	fq19CzvrrsKvznVkoSSL4e/vqmf6MwfvWJlii1tZNKchJt0hCBnyDKG05KDzzkGlqp5Fin
	RehPcpsWkppKAMVaQxyx3zs/jTQTarI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785394745;
	b=CGAncipjDeEz9OXo7V8Y5OakWQr5JwMeTvFvI3fFyzKDwqDZqDpNqK6VuNogBMN4ixnFx1
	JX4IVMgVFe5cGRnqJ61pXR+4ZKDCPO3yKblwcsdAUHe99tL7Sz2/fNqVxNR8WOIEXcaP1t
	uBwSLQfk2iWTDAk3djZYW3MElRI/QNY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=UCAOFlRP;
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6vRbF2268400
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=7lnM
	AQUAxGl0d0xuPXIIpzK+l0m5WwNxFhJZwOOAO20=; b=UCAOFlRPJWowBl3rU040
	SwZ/JO6HqMmh7w10K/pEOvfmU0vwubvQfrY+WMvRgG4Sga5moOoHKNyIzkVd5Dzu
	jqfahkydSebUt3mV4LY6uMauUWmZDaLaVG6DJ8zuquGQHjwda5DXs/HyE6Xiy76v
	8X3qvA6KXU7iaDGIIoDgLC6lxS2+oXXqSPwjDJUXSy22sYMka8CJlsgohpQfkcTW
	LpH4yJB+C/7+PoeS6rF2sFhJdG/fD89iCJNYXO8aOs2edt3Xj4Q0ig8B38u3LCbU
	WIuh7wRAr4Xj+4p4ZfApoiz+Gt7hx7vC+MQhge5/0L0nuYJb4SXiEk7ZY7OWpx4g
	Lg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fqrjq25cd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:59:04 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92e632390d2so335423985a.3
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 23:59:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785394743; x=1785999543;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7lnMAQUAxGl0d0xuPXIIpzK+l0m5WwNxFhJZwOOAO20=;
        b=QBniBY6B7AsYC6cfayd2+1DzqTwtIZ/n5foZ34xORnMTRbkVyLMuW7QsLg/HO1NE3n
         wlRiy1ql+3KpGfeV9oLwPouzo6wgLf0vLYAciR8XECEA5o1ofCUX2EDLPFn1dlCYY3PH
         ptjgsH7pHJtYuQWOaa47IzTSOFYL9cDpdzg4QJPFy/urFB6edbph9OsOifVO+XEe4IjD
         DNQiEdImWHqMfdVCI38xFEgdiNbqqCEK7OFrbkIEeQhm34gPB9tWDZpXKqueR+y4+Z7d
         AZzYES6v7MxXff10qN0bJkS5KaUtTB+usHzitO593b/rdytFGbW9RouSNyK2hmQF9Zmt
         AYXQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro6QVeKFSUNhtYWaHOcr1JgcikrMEqh+FZALdckgVKcBEHizV5zLLhqsy9Ajf9RuTwsB0LdZn2H5w==@kvack.org
X-Gm-Message-State: AOJu0Yx3qw1Tl+Mh4TVHX2N5s9lrU/ID1foU8oS6TOLX+3fHqPk38buT
	3McAsaOzwb/TGDX5hjAvxXGXwi/ZBsGM7TFAX4r8Py17sxiztLHpFKrlwTwth0QgJ8Mr7U1y3+f
	lLEVVvIrwG+OnCpw8NSNZWP7AdpPzKq4nP9K8Au8jun1ePL83
X-Gm-Gg: AR+sD10Ja7/Vy6009PLH0FNMQSNldj5Jlju/bc57+xZ+IYITrKM+nWDfTwSiRIYMG7Y
	cEGYlhUihkbULs13fowKsMaQP63tVmORdFFz4mhZcsS+YdL06vsWgA2YeL8LB0JLLrmTVYhQSBj
	6kFN9xDTyi5oJaZaI7T1TYOT3RqgzK+m8RV9mUNGHjyYOCe1JUTWt6o88EbRk1HvH1031sTJlYm
	KJ+pA6Z/Ws7nk6R8Qc8fczXWUVu71pqV93juF8svwfkiC7VndTQvP06/p+3HxByp8yO+FGxMy3J
	IXSvAN9GTdLDdK61U/3PuaFVv/eLPFyCEPv6zRiUEAdjEQCBwSzxyUhR0MvpjpZ1iR0FX5RFulU
	bC0UzQbYxzMG6mPN1Vw+Tr6TyKWeIN9vWufR+TVtHLi4+0Q==
X-Received: by 2002:a05:620a:1a05:b0:92b:6805:9175 with SMTP id af79cd13be357-93486af1e68mr113646885a.61.1785394743686;
        Wed, 29 Jul 2026 23:59:03 -0700 (PDT)
X-Received: by 2002:a05:620a:1a05:b0:92b:6805:9175 with SMTP id af79cd13be357-93486af1e68mr113645485a.61.1785394743228;
        Wed, 29 Jul 2026 23:59:03 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3221bc7sm349752485a.7.2026.07.29.23.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:59:02 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 30 Jul 2026 02:57:54 -0400
Subject: [PATCH v7 4/5] buffer: set BIO_COMPLETE_IN_TASK for dropbehind
 writeback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-blk-dontcache-v7-4-3e8e6850068d@columbia.edu>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
In-Reply-To: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
        Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Hillf Danton <hdanton@sina.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
        Christoph Hellwig <hch@lst.de>, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785394735; l=981;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ZEoFDRdKJkaZHcFnJ/ZnxZn4DtJcz5dwb/qiVw90Hj8=;
 b=b+UxIQsoik7/2fDHnDW0olnU1/qVCDwC00Ozr0+zhh1d0+inVyiX96cXmklJSMAHbamG5lxnQ
 vFMiJx13/y+CaUo/njnCuStF0po4vXeZjTMmpT6DPvkv37PX9GBWJ6S
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: ZPzYsuu4Sijj98JNYXtPQeZKA6A0csSI
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX9G9nWhvUzx9R
 EFKLMTBJOQgXhDyWu1SIKq8W7gIi3OYer3edygbA7n6Vy5KNR+sSPHDKrPWpEXk/N8lFGPsRCGI
 mVAUWjnFjQjoXiw5DAG3af3dXMi3uYyX4hhE0ERMFQDiGFHZFjn6
X-Authority-Analysis: v=2.4 cv=S4PpBosP c=1 sm=1 tr=0 ts=6a6af638 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=WzT6SMHhq-VMa0lE35UA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: ZPzYsuu4Sijj98JNYXtPQeZKA6A0csSI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX+XMXz0ARbu0R
 neuzLK4KRs6Ozzto9ZOepp3bNANT/4JX0BJg1XWsP9sD9awNgigtFwjIwJ3c0925k0pz5KWkws+
 STscWtn9w1E9vcHZpycVGCUXuMbKv/FOUVx0kLoEEgPE+JZmLr8rpNpLxsNrq8M0SuVCDDXuhal
 A8oKRYnZ3j0LacmBNQx6aNTbrAnWNiFGBQgOWXUWtqdwG591venGJDddUHhYSUXCFaqM+3nu72E
 YqqJspa33E3vMxMh0lPP7bLRtB/3H+0oLfhRp7hYnwX+sC+0Sucei3DShvrQSOu3wjcRKM0XR06
 smgC6W/VkvRRV/OG1TX1INdu52m3MO/PWiGPDGYRqY6x1U/gbdqzxuHlRasKk9pgRn+yvZF6Fhj
 Lzm1dALruLwSMV7+Rwlulwzj+zSinOPE9bTR21YeMXNyA+ZNITRfYad1t+EQVGBJH6t7L6IFeUa
 Cujrm1r7hhgGW46ZomA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11859
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 phishscore=0 lowpriorityscore=10 impostorscore=10
 clxscore=1015 priorityscore=1501 spamscore=0 suspectscore=0 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300048
X-Rspamd-Queue-Id: B884C180004
X-Stat-Signature: wwx1i1h9mzrxb3pisa5o3schao43wnio
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785394745-744413
X-HE-Meta: U2FsdGVkX18xaxjmnG3KmUDenC3IH7jbAyw/jTSpM/nbbMsVnXzo1ZOf2BAkF8qEmQjePDYJpxagj2P7HCiWJEwyMJqCXMPWssbFVDLLS44s6zunEwPit4WGyvI0fp5ZYqXSnVntMg42cSVeOvVRj9UQDqwIffkGdvRqihZU+E6PBTengk044VNq4x3U7NXn5iZC8Qo4XOPuOQeMsiedKIzjw9qBZxSsiJsyfY1Lbo0YMPkeDm1okijs9QjkBhqCmllJsMTX5ZnBnpv8ruBXLYjtptquqouCTthrScrIyM6LoqH8Jy3vxf5A2vOiopF6LrdOpJ+cFtaRvN/TQb8OFKHCTh1SI7bMhkJsoKUkeUuPhRYYnIUxlatwV1TRd2HMccMwe9UWTsJjjcyCfzw0cifypvQ34kzL3DEhdtnR2NXULTTv9eASHtRLsw0idAOTVsbVa1QCLgP1FSKMcE0a4xEApx5tnogqK/AaOX/xy72zMRALEtA56jZ2OpHHjW2KME6pr2QRzxCm937gxmMG4e3FoUMozA+U6Z0zimRp06zNrjhN37g1wPblc2Q+FE6m7vYPFgO88+Uux55Sr0bbuXVa9IV+hAL66buzmv1c/UeAFobypGT9255pHOo0TmusCm+WjkeWjUfiO8fo/uwOcDyQUTw+5uzk0rnkxp1Dm5gtDn56UbUB903VyGjdsUbfGFN5giEieJWjeTpTo6vmLg5QSFg4lAX7yyy1qvkUWqhzOnSp6Geo7kQc4frvl9M0oFeMn5KUkGwFuSTsYpBAPCBZ4rNY+03cDasMKCNvKNJbLfkDQG+lAtqIsear2yT9kmf9ErkopYXqTU6I1rGnPgncRMWvBooEd5h/4C/XVcU39b2wFJE+AAK+1U7v0U4pn/lMrsceZ2PtvRKX7K13C+3dr01fp7QRG+6iSdqztCMQ5d93OI+wmeM3nxlikUCzRvVoyucD7cGmulyRBUQ
 UGH70a90
 ey9Nd3xD8n6pF45SSJFlD8WfbiWxzNqhedm5xAbNYXqsGGf3/cgBXXISL0E+bUHdlaRML0xHTxIWaWUqS0Qg0iRUfM+dIiDLJIW1aswpAFXa4K2+GheN5z4HIUcYNcxgg9Oh7/9zf8lwnayMLtk9Yfy4H5fwOYYQtNVGe8oI178ue8bBZ+hiA29/EdX3u76wYK0q57NnPGBT/jQsjOAs8QEHeeuDpfy7nzVkldHcQi+5XOFxq6Fx42199j/IVtcplY7QwZPRtgSPUh61J/2P5xIh1/WYam5VbAtbLu2Om2UGPR2QATQ/fnV7PpEuh4nWES5czgbvJ2fb082AlDynnLx6QGE4yO+4kf6EN2VkIKpD6wq3d7RNHYCUQxCq6sJopPmMkgf3OrzWV5kU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set BIO_COMPLETE_IN_TASK in __bh_submit() for write bios when the folio
has dropbehind set, so that buffer_head writeback completions get
deferred to task context where folio_end_dropbehind() can safely
invalidate folios.

Read completions are not deferred since dropbehind invalidation for
reads is handled synchronously by the reader.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/buffer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index 9af5f061a1f8..6f099847240e 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1203,6 +1203,9 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
 
 	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
 
+	if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
+		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
+
 	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))
 		buffer_set_crypto_ctx(bio, bh, GFP_NOIO);
 

-- 
2.39.5


