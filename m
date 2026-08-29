Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5CD2C61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 15:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73C656B0088; Sat, 29 Aug 2026 11:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713C76B008A; Sat, 29 Aug 2026 11:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B8026B008C; Sat, 29 Aug 2026 11:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2509F6B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 11:53:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 139B7A2D6A
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:53:35 +0000 (UTC)
X-FDA: 85154751990.22.B51BE7F
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5CF1140008
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:53:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=o+T9xXEZ;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=SRdU8aGJ;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788018812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ymDovfw/EFXV/LaI27PWgfgegjJSquVlVvW7s1UYGk=;
	b=fN4v7kFZyA2uzqcIy/37e3XjYS7RQxriqUrdNRA/Nn0jLrc6fSl+v3Zv783+/iGkAjpVLz
	X4rr4gSdqtvrn2928s0o5KruPKq0JS/2pM/kEUpnI/KPxS1Sm6aI5FnsqwIk2OgdiWV871
	fkCVu2EP4wUhGVS/s8HJh4cdjvcw8RY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=o+T9xXEZ;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=SRdU8aGJ;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788018812;
	b=2vkM+VdWUoxNWsSroIracOrgjtVFuwupalXLLylj6AV9Wxwed6ooAbL1yfsa3YN+/1A7sY
	HhTGNjryMJgD8cQ7mDsuolmVnT0IGFHEbyroAtHTJq1wuf6j3UPVvO+OMpzfg9qdrUbZ3g
	xQg4hvOTjtlTliA6naXW1aOeWXjutc8=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TEer1d2262581
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 11:53:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=8ymD
	ovfw/EFXV/LaI27PWgfgegjJSquVlVvW7s1UYGk=; b=o+T9xXEZ8enT9OA0oMXX
	MAwHYlBvVBNQq/jeJDWvIJXTZNvcPRZPR/NMQFGbDwud9gBXxSv8nupTfqjdIWum
	JPRQsdHKxBJSdb+bbK2Ast6AriOck1LKP3Y5rLtlAuImz53Tc6zsuWqevgLS4Hlk
	XI79aokYsSont52zNxNWqDAUdn+59yzIAUgpgRrUlZoGDmKysiWCNF/Ki8xGH2eZ
	Jtuyaxv66aS5sDXDd9d+V1erALxlKH4hruwqaIBo9r+OMsauBA8rrQhbAQ+DPnRC
	cIXQWQ/FW2jfmg/e9gIdFZhYND1MKch2MKuDbyTmyKc/XXZU7N2yjNsowcRP1bXW
	fQ==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gbvch9v3g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 11:53:30 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52d33c89a29so48477731cf.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 08:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788018810; x=1788623610; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8ymDovfw/EFXV/LaI27PWgfgegjJSquVlVvW7s1UYGk=;
        b=SRdU8aGJ1Y7k8FLbZulOfbrXsI7Z2Ui3KEqytAtsb0rUzMgalD5K2hW54L4IhdPxuI
         T7/JO/6cmZaaiqSOvw7cijg7dzi2cP5QEky82c9XDIYfqGjYSIjPdM6BNgGBY9jWCAG0
         AzT0qqFpsh/n61/9u4L+Ur1iW5F2IsQdvJffloeDysoTNZQTj39AbIABgS8+ZvjQwjNV
         zChbQHclSTIAq/Zi6WryFG9+HeKgHtU11+4X/oASzFNUy/bLOUkO/Ipyg51e58cIexcC
         BBHl5cbz4A2wRq0Y7Uxjs0C4AW13F4lwDQXXK6uxkxkAkT4k7LRrAURx3Ra/fjofyQM8
         ONcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788018810; x=1788623610;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8ymDovfw/EFXV/LaI27PWgfgegjJSquVlVvW7s1UYGk=;
        b=BHFUtGy/PCRk/h2S6m6id+871kG8BfKSZmoq0OVNkgOJEVSJPVe5TSA7W7A9PXtEn5
         R5vQkKvLzK8iGautvkGwYRMuUvKiI7hOrAlX0fmK9ZInc2HaWZFbu/UmVBPdI05zVlDp
         GJrxVm4OqwU2q+6jr/LqujT7VjxinpO/fbCAdblHLQGG1GsF17n3ahenR/u/Plbe469l
         KlHfNupcDfMXfl7ETNscU70aeXhPMz6/PoO9eD+0MY9mf4+Hg0vgMw4LR6OeLAu6Jarf
         f4hGfRMg7WmSivnfrS80sZHncNF/sJb+c1JBDUltHwHonUleXfppI7EFfFXLLuMQKzyx
         bO6A==
X-Forwarded-Encrypted: i=1; AHgh+RriuHLaOpZ4IdPaAVlMITvzvyFkNrp8WVy0PM3RZqmi7fGYvrHJ3XkAZcsl2p7jOTRnRB/1L2Ytjg==@kvack.org
X-Gm-Message-State: AFuF++noq1CWZyeNMBID+eTdw3OT/PzipKy5yZ9zfH45x6Gjddp3dcfp
	7tiqrk39tbnWppVUdn28jUdQ6b9m8PXwtjo9ttmtcLc0z+7B8hZRM1WbKHWhCS9FR9oN1a986c1
	6in7W1MKq8mgopU3leOmjplK5SESvE/uFgZAQLp/sMyGWME/K
X-Gm-Gg: AR+sD12RlMld204oLQr6kBTzjg0puTke8EyMnT6A67CJruhy/LRHb6fgBPgmI2twahm
	+i+FBnFlHxi5CPdk15BGo12OAy3ZLpGRhIiSSoolE9h4nm7/ooORs5PqayYAslfhav0lzJ8NdeP
	iOzQ597dd32FbT7z/420v4JmpYoDF3ofqclSAsn7yhRkjTWLT/Ic4l/J5dqzeVwqqrmOyEwPuZF
	fwcL0EyUwzJtigLSQmXocKeDVPvKPpgsZRdhzMUDjBN/4eI/KS2mrHCzyvGqfk4HxyG5YknrAD/
	UO7sDEFrE0C5k8iMKglE9IfCRmEmoYQ2xYn8jPkJg7PARF0pS6il+yg4K8W8Mws2a5aJsEgugDD
	Q54jxLQk7ZCgeSpe5VBMlSKyBzB2W2yEHEj980oHF9w==
X-Received: by 2002:ac8:58c8:0:b0:52f:f546:c683 with SMTP id d75a77b69052e-52ff546dc18mr97024121cf.29.1788018809915;
        Sat, 29 Aug 2026 08:53:29 -0700 (PDT)
X-Received: by 2002:ac8:58c8:0:b0:52f:f546:c683 with SMTP id d75a77b69052e-52ff546dc18mr97023781cf.29.1788018809486;
        Sat, 29 Aug 2026 08:53:29 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49c5a8e0657sm108099655e9.13.2026.08.29.08.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 08:53:28 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] mm: filemap: retain mapped dropbehind folios
From: Tal Zussman <tz2294@columbia.edu>
To: Wenjie Qi <qwjhust@gmail.com>
Cc: willy@infradead.org, jack@suse.cz, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, baohua@kernel.org, axboe@kernel.dk,
        trond.myklebust@hammerspace.com, qiwenjie@xiaomi.com
In-Reply-To: <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com>
 <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
Date: Sat, 29 Aug 2026 11:53:20 -0400
Message-Id: <178801880005.667254.16521776519325089161.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788018806; l=870;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=qh51favisqRYFIIJw45kc1LAAx7fR21479+AvfqL/04=;
 b=9D2u9tIK2luFb739fqW5+911YvX99bhciYQK2e9hDkpVr5QE+J47y/qLzFvrZsNOv4iZBwOd+
 88JH/jEfrXMAg8nXG80s4x1xQYClTr9LeVpgl9V2v1bUAu3R3xvjiUE
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: G8aEQhA2rYfnfErbsPhQLrQ5LN0z00D7
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDEzNyBTYWx0ZWRfX9KB060ynQ7/j
 tFvpw3GyN8lm7dyxLvXAABKSoiJdSLy9kLQe1z1UW8cl2ZnKtBjJYEJmIdUzuyjbDQLaeJurMuJ
 S1Jge4XUZIogUn0pN/QWezVjSbf1vtmW0Ko2QpUILC94KwNO43RS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDEzNyBTYWx0ZWRfXwTFSY3eMlHFv
 xasRWBorjjXFqB4URR0llxKU4aJKzDvWDNmwWZgVx4OsCns6nsu810XpelfsHONbIXZeiV5rCdR
 JGZDq/0J87CS8RxKiiYtUGLw5scAzJ7psM085CuUgHBJZGuUhajdS/F7tCsKLJH5QCZLq1SIdu6
 euNej24d7xWtdSABYwo90K2ZckrDZrmFBus8YbAzpKfeQx+mJppXCq8a4fuXICpRNgGyeks90kJ
 JY/EAg52DY7rgzLtVH8LTPsKXdjg6Tghx5d7SPwQETlpctI6WS5vB1+LNHXUmgKgwUkKLah9VRY
 LXVI6Mb5wL6gKv0yP4jFQXcNoiTQ5EG2XHN7B+odQYWs5s47YGWhY3zRbZatX/R2KFLm7Lry+mu
 nx7MI4mpm3va8rvsvmDpky5l9OSNI2eYq6O3sYoVHHwP99Z8fWPDkAYcxfaIHL+3/ysn5/cz7sw
 04P7oxNXnTmZcPojgXg==
X-Proofpoint-GUID: G8aEQhA2rYfnfErbsPhQLrQ5LN0z00D7
X-Authority-Analysis: v=2.4 cv=cMbQdFeN c=1 sm=1 tr=0 ts=6a93007a cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=pGLkceISAAAA:8 a=IeNN-m2dAAAA:8 a=Xs2TF1iIujOxxFI1s40A:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 bulkscore=10 clxscore=1015 priorityscore=1501
 lowpriorityscore=10 suspectscore=0 impostorscore=10 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608290137
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: bkbrn8zunn3d3etxh81c13wqh3yi3pws
X-Rspamd-Queue-Id: 5CF1140008
X-HE-Tag: 1788018812-464600
X-HE-Meta: U2FsdGVkX18wE9BmRbs5SDOagd1FBuodW7qf/ApgWPwbCF36siqTQwpVwAkZTjmd15iSpMMDhCdoZSsVO3qMIN+CcgR2/sJWhCC2FicSWdfhU6HOI8/0TCD0eWy5rabXZx/Ad4JaEWEmRWdTDq2ZLTVTxCfg2+jzg2BsU0PR+O1XNyRklnm9bzFksa0xPtrIibM0lUYxYq09l4yh/Edqo7p7jVyNis7RryzU4+snd4q4xWVtk6ohyuWdS/yqlob0mOnkXdbPYrXA9TTNYyPi++34i3oDaj2owKn3J0+uScPsbEid3WK053W3wypmgSgxZUcUjSD5620Bkx7WEcskiFDAarRQtHiPYZgMUWWLKGEPSnbzlQm8fzO0olW3CFIAmujQb1NJS+aj14ZGT16oHaj7Mer2aZqo3tPyT6DmzpIVXYKLX0OffPaUHlQQPxcqQzoZ+qmNI/HJy3a0A8FJfUuBxkj7u+/zH4VVWv3AphT6Rp8wys0W+1hct2kc2NhtQjfhhu7JHkIRnqUEh1l2uipxTv15kO6TXHENHCRqUn/6trlN9cYct8T6r4ziysRxT+THzR+/+xR1frPHIZxIVLAcNRrnPwlGzOJZMxbKgfBbotPYVgN0Cr8VQoGvagaOM47bQifug2F/fq8aWPvYk1ZhwN2mAN69yOonxrxK5kaa+E0tsp/upwmYMAmTt3I216IvO20Yh1B17yxb7VkqFth/RluqZZwadWkT1NQWyEjuokHR56UMgew2CGHrFHJ8h5yge0gy+DBGJLErekPQHgaD2pSHlcXytCkRdFOvSYtv8rbsNeb4Ta9ajPJqiO7NWZGUERPNhKH87aJtfqdvRW6GtDHM3ZPx5a50+wvDli033MkGIJgjyk/mBZEJVxKI9EEJ7LO6oWXCD8uSjHwH6M9J8uz3SMGpavSy/ErFjTkJOjzzg/GJFnsxKfqJ5ic9EzsXeKecucW/0ij/s5D
 RWlVisOd
 WGlRPUiGLtel62acBkopqbTDF1+bjLXMX3H0IrZ3VFqGsjWWdDsR7UiKxoSqjYyo8qPnzIIrz5Iy4urA6D/Zc6DwOXRRiPpue1d+wONeZH8CL1GUhP1CRvDeYBlOcaME3xWDBlJSwdPgAoeZZmGhvmRPnXgdRGLLGe3xErB1R5GjmKxBWrYPkWiGDDgA1LBRLbw6/R+eTVWt+dIjoYzdese6PzeVZQVbFQl08uBvcw7ztm8uGpPZHYzOoWNDBgHc1NfgwPJmoGsXmoLwK8Reexbm2bCs0PPJls6o8Rox41dl6xBhNe6nqw6uRT/7zE5Oz3MBxiuHkp5WUMUIRRH4hyCbHWM88EGAkbByRHYmCK9+oSEslETCqbh0gdWkX1pryOeeLZH7CmBvVNuL3erUMF+Uz/pTzRm3fBYNjX9F1p5eG+eo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 29 Aug 2026 20:30:47 +0800, Wenjie Qi <qwjhust@gmail.com> wrote:
> Fault-around can map ready dropbehind folios without going through the
> normal page-cache lookup that clears dropbehind. A mapping represents a
> competing cached user, so retain the folio instead of forcibly unmapping it
> when writeback completes.
> 
> Unmapped dropbehind folios continue through the existing invalidation path.
> 
> Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>

Overall looks good to me. It may be nice to add a sentence about the
safety aspect of this in the commit message. Maybe something like:

  folio_unmap_invalidate() may sleep if the folio is mapped, so this
  also ensures that folio_end_dropbehind() is safe to call from
  non-preemptible task context.

Reviewed-by: Tal Zussman <tz2294@columbia.edu>

-- 
Tal Zussman <tz2294@columbia.edu>

