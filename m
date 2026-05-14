Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E930CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 21:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CF036B008A; Thu, 14 May 2026 17:51:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27FA26B008C; Thu, 14 May 2026 17:51:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E496B0092; Thu, 14 May 2026 17:51:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 05BC26B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:51:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A6BAE8EEA4
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:51:53 +0000 (UTC)
X-FDA: 84767373306.11.01B526C
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0E1D018000C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:51:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=GlIkRig6;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778795511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gL3IniCxmcO+YyN31TeP7KDvS27s+0s8k2VEJ0rAxzM=;
	b=Vn9BSlDzdDiQBJBID6G3fcbS1uxoeWCJZWKjKM+sdLoM5kCHGg3nBBZj2DFRJfxHUnaTnO
	ov6U6t/yHLHskLM/CJRaWU226ELXJKVt4mQ2xxnzVFApBCWueCxJ/AF7zFlfH+oKKNvnKv
	6+QUAZCumPZWTZ0q+JEiGMELNdLDDXU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778795511; a=rsa-sha256;
	cv=none;
	b=hr9xZHRmIemWNCZP8myZbAud+PwHDkyqIUXO3W3p5kPip0KI3aN8gChFkCDkn0rmgMJ6ab
	LEEfs+IGu4phTA91u1x8Wx6elhdQCzQiIClaRDVWLA1O5tlItDcq/fd+z0mCjAvf/O9hyU
	9pUFvZiwQrgUZq9fOW76sKUWphccaNE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=GlIkRig6;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64ELgdd7789235
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:51:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=gL3IniCxmcO+YyN31TeP7KDvS2
	7s+0s8k2VEJ0rAxzM=; b=GlIkRig6oRPwq2PsSM5jFH4ymDLopdQUub4Tf4MZHK
	siDypWLzIoVUvvSDqMzeleNX7JsjyD2f6DlVDUig3883ZLex09fNgfsdwOUMSoJQ
	vqbMp2Lu7Tddd+AdJZcMO3a92s8D7Mv1xiLSIkdH7DySTxMPzrjz6YY/1RvB3w9C
	eORw3QK4rEH+JsxhKQ32UsoMJGoB0wL7QpzqKx7QZ50fPdcCAuS163EvqLmONH+1
	YkR/CsCtP/LkAOE/6GBLhZq/ww9kUsjOI0eRaGp2wstvAEtjOgr/vjn4mp8F1p2L
	9R5Kvxn7jQVE5VeNDMVWNYaNwLiXGk9UyfWWUQ0Vk48Q==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e5m299h7t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:51:49 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-90d5e856e17so920450385a.3
        for <linux-mm@kvack.org>; Thu, 14 May 2026 14:51:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778795509; x=1779400309;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gL3IniCxmcO+YyN31TeP7KDvS27s+0s8k2VEJ0rAxzM=;
        b=c5XgwRlb2qOB4ys1Laa9Y2FVcBqkBf6PIzdYGu8fW//lEDw4nta6t/6P4ZyzIzzWF9
         R8vlJL00WGLnR78vR7tK+y8xD7ZpwEYe/tuuhHj2vwnAKEFR+jT41FuOUJjrcpqMN2oe
         5g4LUrr+QtbvIvH/dSJFHgCoOBD9nA4kBWY2fYOug/WCU2bst8T6Je3JIYWA2JmaLs7V
         8VJabhPvydY54XDkRsXAXlRwXrnbzeGrHbXbAACpg7uMwnJS+L0RGb85cGCKEASF6l4I
         OH5l39rNuxaAPL7jh1nQLeeqXpLQPEPgoa8wToTh4tx/KNWAGJ33PuPlqm+1yRMNzOTb
         zixw==
X-Forwarded-Encrypted: i=1; AFNElJ/L2Mjecw+TFV4xEp5aWxlhx5/h9JTiLD8hgKFUOu2/apE6lyduvQqKtCtdF/wb0gTDWtdvpSRKyg==@kvack.org
X-Gm-Message-State: AOJu0Yx1kJxqp6+YRwFfCh2CGYG9WuUMJgTnvjch9ZkHD5ccH42TTwny
	ox4LmO7GNCB47Me+YFAfMF3NDTdr66JnfwBWQf1G3X44vElVWMFu2DTr3wzY8qb2ehBg8Hevasy
	D0kRX1pym1RKYF+Kjq97XmicghTyenevmF4TyEvDFZ3xraVoy
X-Gm-Gg: Acq92OEUq4QXAQlR/8MqArujxUbTe13GfHskd8CffYVmiIm8YPx8twsnhZwQA+eXcNH
	d+e3f8+K3ki1N8vlhBkA9FUNWrGqVcoPs91GWSvDoo2qBuxEK16+1ln36s5gFo9WCqtyPFOJCSX
	bMJfrucLUhQpYIsa1zvaZbSqGZEzUelMHy79S5pg9mkual0tDltpGTRlAkuV5zIzpIp6d9KqyQG
	vWpASU+k5HtpQ7gDKviEWSlnaqOTLUF49h5aUV0wPJSNP4BjkiP1mcr7WzczDDUr2Wst/lb5wC4
	hckfNRkvkAle7arxdtLaT3lY3tJXDvcl11NPAoTWMwmVPAUBSuoJ/5Y/2X9X+eRxz3E3O9u1Rqw
	/AEychPs/9JNyFl3GRwJs5hm0Jhh8zQL0
X-Received: by 2002:a05:620a:459e:b0:8cd:b617:6522 with SMTP id af79cd13be357-911cdc43821mr248437085a.29.1778795509193;
        Thu, 14 May 2026 14:51:49 -0700 (PDT)
X-Received: by 2002:a05:620a:459e:b0:8cd:b617:6522 with SMTP id af79cd13be357-911cdc43821mr248432785a.29.1778795508692;
        Thu, 14 May 2026 14:51:48 -0700 (PDT)
Received: from [127.0.1.1] ([129.236.229.175])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba18132fsm354966085a.6.2026.05.14.14.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 14:51:48 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v6 0/4] block: enable RWF_DONTCACHE for block devices
Date: Thu, 14 May 2026 17:51:13 -0400
Message-Id: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANFDBmoC/3XQTWrDMBAF4KsErasy0ugvXfUeJQt5NKpFU7vYi
 UkJvnvlbBIcd/kG3sfwrmLkofAo3nZXMfBUxtJ3NbiXnaA2dp8sS6pZaNAOtAqyOX7J1HcnitS
 yRAwKMSUwlkXt/Aycy+XmfRxqbst46offGz+p5fqfNCmpZI7JOW85e5XfqT+ev5sSXzmdxYJN+
 gHQdg1oCdID+0im9iFsAPgI+DWAFaCEsCdKNrgtwNwBfP7ALIBprEuNwezMBmDvgIGnDWwFIEM
 A0hD3br3BPM9/sZsVarEBAAA=
X-Change-ID: 20260218-blk-dontcache-338133dd045e
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778795507; l=7017;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=LhYeH/mJ2rWshbCTnCkimmhXW5yvpSfYzhx+I0SXhZs=;
 b=FnFs0Q/bkJsVMU4mvf5tEHoM0rAglLF1PocraE3Zcd5SE85JgeordHVq0IsksElTq+sqwEiSZ
 0MWzs20e5wZDOZX1xp4P852lxKsWm4p1BAGxJyaoCSsVIV2cTFmU0qx
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: J36tSMXHll8UN3Av18RVCz8BHvrZeeuu
X-Proofpoint-GUID: J36tSMXHll8UN3Av18RVCz8BHvrZeeuu
X-Authority-Analysis: v=2.4 cv=Wuob99fv c=1 sm=1 tr=0 ts=6a0643f5 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=nkegbr1AwBRna+m8FBH0UQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=VwQbUJbxAAAA:8 a=MODqGFHVcVHO9IVmJf8A:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDIxNiBTYWx0ZWRfXxV5aV/zbf9OW
 hr8Eld/15kKCce5fBCZQOmMFhnk7bdHETNQPzCA856vvQftqWLr0kCqvNVpxlbxfJl07T3Y0eRf
 pU5771ZrwYxS7OaGeshSq242IkJ5L+IYeFl8R/mcscW6VxiG7VxXxSSsjBKlfcU5RGDbA9wRQfW
 dTrK1NFE7JKFcHVgcKODeHIlev6tKgFopFW3N5Q5j1ENHxrqe6hAv5snTZqix0eHxQiIeFd/29x
 Si2LCyi2OQJYT4TwGIModxrN2qDNm0tgT7dBnzD97lP6SfkgNx44k2+sipUhMD70UzN4Xu9DiZV
 4S+aemUNaM1Sgn9FRzos0DD7HGx1G/UcfeKcnVt6ZenminVhmS6vEXYO1Ke0XY+vIZv1UPtVjM5
 wCy9Dgs8x2RBJ+o/LccqBat9MmpQxauDGtwkUIzReCpb+zwICvFYkHjo1KpnXy1LCH/kkOviJ9J
 Mw1fafQzwyRWIPAy+DQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11786
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 spamscore=0 adultscore=0 impostorscore=10
 phishscore=0 lowpriorityscore=10 priorityscore=1501 bulkscore=10
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605140216
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E1D018000C
X-Rspamd-Server: rspam04
X-Stat-Signature: i5wmozzui9utouas1sjo5mh9pomufpjj
X-HE-Tag: 1778795510-694262
X-HE-Meta: U2FsdGVkX1/rJc7LnRqiOHaCCAVBRIMmjx6CIo6LSdL15lDMRZU9Y2haRi+Tr4DvkoIcvRUDX4SMy4ULvySvQEs57MEWgi1QR1FVZkvRJ0st8Vnd4iuN4GhkoLf3djR1b+ltUyBjuByIgGP5Nv9heYg/Y2/bhHgChvvnd48VdBOQjz2JWRy1LFh7YrIOL0N5zufgkojkuJXg30yqMhdwXXLyux2v+tL8wtkFG93PZeFDjiBrBjH/1ZvRhcWTSYy2CQpcDPD/BFwToJVBW0BmYLr0nRCb4qQa01AIlMmZGVf++1BVT8IAyEqpQRgXayj3wudGNr753qjXLijB8UBSOqKzqlYTb+svwJ2POpz8HvN7X9q9pqvBh82IuBHy2xGDMlUBTKRIPFHro4Bi5iXFDTSlf1hIXSyjlzuRkBvvtHNvlJHxwdDaVAExQpwSGiEmKZA/N71Ow0Cn11N809OlL4HcXiOZtKT1UtGs54TTp+Qf+pibRHcKHuaPo6mQYMk/rGsEjAG5zRISveFb2U7J6W6+aphHqfd3HzIA19Y2aoR3l76pseEvGhOczs1XsMP5cARsJt45eJcQVtMl/bL8Fv/ZM8ez2DQuF+d9gvrXRQ14eud9vk/lN9xHV7kVZafBA5iUD75udOoVJOlo2l06IHpUbA5XJXsOzBq3qxGkXy/QeUTcJoHjO1ZvJ+WQ4J1BhNUWof1g0vz0aW9mvszYkdtvb0p+wWypmEySuXalsKrSRKvijPiTOhWPd56hzIcFoPMVTzypVYuhhcMiY639HCEa/l5ESa1KtvMtONcq0IhMWUGCIipY91YQWj6IBtC2daT6LuX4CmllSH+1bcN8VXDxx8x+Fpy0FJW5AUJqTLS5Mmqw8+yB7BkjEqVqHvR9gmuKJpvOy2ixCmchvfkVG7AAC0FHevIBUZzIQ9SFyJfUB/1vNHJehvZ+2i8xSJ0UaDf8okU7B8iPfe11VFr
 C2KgD3Z8
 ossJkSv4epdgo1XHJMI8RzqdaV4rGMkXaeW7hJExnjV8ZgX65ATE8sbLJmmieaYE1WCx9VjpuMGYeqEwVW35RoFL8QHWYyT8CF33tErDftMkdzxXBHpwd62ikes40zxSec0U83d2kucpuBzSDMIbaLsxitJ6PFMJ1ABO47g9JFPrxdedZn01hXE568pXO6yXQssWVmQaDSZYATHxCvRUX1MXBgI37OG8ym49PRVd1bRmwlb4m3vFhUz+rpP7xNCyeXwPmSmhSDFBGpCt16yFNPlwzkTts9DxSx7fcjtGswPPdoxIfIJYlV26jdox4ek+M2tXJpaLyath+8fLYNAt371drY/6Z4xRGB4534Cxf81CoNi70CTmPlzF6sIy5/rRNUmZoQIfNfRlIEkBSB/cPYkSjwg2aMtX760wJCnPTv9H3jyVu2CG6Tvl775R1iuQyex2kGcoiA/9e526+FR2tENgWVoA4Z+KeHaB23XtdJrZQT3kypUwr3yhDkUvq3ceZEYpr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for using RWF_DONTCACHE with block devices.

Dropbehind pruning needs to be done in non-IRQ context, but block
devices complete writeback in IRQ context. To fix this, we defer
dropbehind invalidation to task context. Add infrastructure that lets
bi_end_io callbacks run from a worker, in two forms:

  1. BIO_COMPLETE_IN_TASK, a bio flag the submitter sets when it knows
     upfront that the callback needs task context, as in the dropbehind
     writeback paths.

  2. bio_complete_in_task(), a helper that callbacks can invoke from
     bi_end_io() when the decision to defer is dynamic, as in iomap
     fserror reporting.

These queue the bio to a per-CPU batch and schedule a delayed work item
to do bio completion.

Patch 1 adds the block layer task-context completion infrastructure,
with both the flag and the procedural helper. This builds on top of
suggestions by Matthew and Christoph: the procedural helper and
bio_in_atomic() come from Christoph's "bio completion in task
enhancements / experiments" series [1].

[Christoph, I put you down as Suggested-by for this patch. Let me know
if you'd like it to be Co-authored-by with your sign-off.]

Patch 2 wires BIO_COMPLETE_IN_TASK into iomap writeback for dropbehind
folios, removes IOMAP_IOEND_DONTCACHE, and removes the DONTCACHE
workqueue deferral from XFS.

Patch 3 sets up DONTCACHE support for buffer-head-based I/O by setting
BIO_COMPLETE_IN_TASK in submit_bh_wbc() for the CONFIG_BUFFER_HEAD
path.

Patch 4 enables RWF_DONTCACHE for block devices based on the previous
support. This support is useful for databases that operate on raw block
devices, among other userspace applications.

I tested this (with CONFIG_BUFFER_HEAD=y) for reads and writes on a
single block device on a VM, so results may be noisy.

Reads were tested on the root partition with a 45GB range (~2x RAM).
Writes were tested on a disabled swap parition (~1GB) in a memcg of size
244MB to force reclaim pressure.

Results:

===== READS (/dev/nvme0n1p2) =====
 sec   normal MB/s  dontcache MB/s
----  ------------  --------------
   1        1098.6          1609.0
   2        1270.3          1506.6
   3        1093.3          1576.5
   4        1141.8          2393.9
   5        1365.3          2793.8
   6        1324.6          2065.9
   7         879.6          1920.7
   8        1434.1          1662.4
   9        1184.9          1857.9
  10        1166.4          1702.8
  11        1161.4          1653.4
  12        1086.9          1555.4
  13        1198.5          1718.9
  14        1111.9          1752.2
----  ------------  --------------
 avg        1173.7          1828.8  (+56%)

==== WRITES (/dev/nvme0n1p3) =====
 sec   normal MB/s  dontcache MB/s
----  ------------  --------------
   1         692.4          9297.7
   2        4810.8          9342.8
   3        5221.7          2955.2
   4         396.7          8488.3
   5        7249.2          9249.3
   6        6695.4          1376.2
   7         122.9          9125.8
   8        5486.5          9414.7
   9        6921.5          8743.5
  10          27.9          8997.8
----  ------------  --------------
 avg        3762.5          7699.1  (+105%)

[1]: https://lore.kernel.org/all/20260409160243.1008358-1-hch@lst.de/

---
Changes in v6:
- Remove RFC tag
- Rebase on v7.1-rc3.
- 1/4: Revert to using a bio_list, per Jens.
- 1/4: Restructure and simplify work function loop.
- 1/4: Expose both the flag and procedural version, in order to allow
  static and dynamic deferral decisions, per conversation with Matthew
  and Christoph at LSFMM.
- 1/4: Use bio_in_atomic() predicate, per Christoph.
- 1/4: Use the CPU hot-unplug protocol from mm/vmstat.c, to take into
  account use of delayed_work.
- 1/4: Mark the workqueue WQ_PERCPU.
- 1/4: Add comments.
- 3/4 and 4/4: Split into two patches, per Christoph.
- 3/4: Drop the cont_write_begin() change. Block devices don't go
  through cont_write_begin(), so it was out of scope and was left over
  from v1.
- Link to v5: https://lore.kernel.org/r/20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu

Changes in v5:
- 1/3: Replace local_lock + bio_list with struct llist, per Dave.
- 1/3: Use delayed_work with 1-jiffie delay, per Dave.
- 1/3: Add dedicated workqueue to avoid deadlocks, per Christoph.
- 1/3: Restructure work function as do/while loop and only schedule work
  originally when the list was previously empty, per Jens.
- 2/3: Delete IOMAP_IOEND_DONTCACHE and its NOMERGE entry, per Matthew
  and Christoph.
- Link to v4: https://lore.kernel.org/r/20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu

Changes in v4:
- 1/3: Move dropbehind deferral from folio-level to bio-level using
  BIO_COMPLETE_IN_TASK, per Matthew and Jan.
- 1/3: Work function yields on need_resched() to avoid hogging the CPU,
  per Jan.
- 2/3: New patch. Set BIO_COMPLETE_IN_TASK on iomap writeback bios for
  DONTCACHE folios, removing the need for XFS-specific workqueue
  deferral.
- 3/3: Set BIO_COMPLETE_IN_TASK in submit_bh_wbc() for buffer_head
  path.
- 3/3: Update commit message to mention CONFIG_BUFFER_HEAD=n path.
- Link to v3: https://lore.kernel.org/r/20260227-blk-dontcache-v3-0-cd309ccd5868@columbia.edu

Changes in v3:
- 1/2: Convert dropbehind deferral to per-CPU folio_batches protected by
  local_lock using per-CPU work items, to reduce contention, per Jens.
- 1/2: Call folio_end_dropbehind_irq() directly from
  folio_end_writeback(), per Jens.
- 1/2: Add CPU hotplug dead callback to drain the departing CPU's folio
  batch.
- 2/2: Introduce block_write_begin_iocb(), per Christoph.
- 2/2: Dropped R-b due to changes.
- Link to v2: https://lore.kernel.org/r/20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu

Changes in v2:
- Add R-b from Jan Kara for 2/2.
- Add patch to defer dropbehind completion from IRQ context via a work
  item (1/2).
- Add initial performance numbers to cover letter.
- Link to v1: https://lore.kernel.org/r/20260218-blk-dontcache-v1-1-fad6675ef71f@columbia.edu

---
Tal Zussman (4):
      block: add task-context bio completion infrastructure
      iomap: use BIO_COMPLETE_IN_TASK for dropbehind writeback
      buffer: add dropbehind writeback support
      block: enable RWF_DONTCACHE for block devices

 block/bio.c                 | 147 +++++++++++++++++++++++++++++++++++++++++++-
 block/fops.c                |   5 +-
 fs/buffer.c                 |  19 +++++-
 fs/iomap/ioend.c            |   5 +-
 fs/xfs/xfs_aops.c           |   4 --
 include/linux/bio.h         |  32 ++++++++++
 include/linux/blk_types.h   |   1 +
 include/linux/buffer_head.h |   3 +
 include/linux/iomap.h       |   5 +-
 9 files changed, 206 insertions(+), 15 deletions(-)
---
base-commit: 695fee9be55747935d0a7b58f3d1fb83397a8b4f
change-id: 20260218-blk-dontcache-338133dd045e

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>


