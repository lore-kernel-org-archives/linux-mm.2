Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86155C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0ADE6B00AE; Fri, 18 Sep 2026 05:20:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BB846B00AF; Fri, 18 Sep 2026 05:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D2036B00B0; Fri, 18 Sep 2026 05:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 761C66B00AE
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:20:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01257A5EF3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:20:12 +0000 (UTC)
X-FDA: 85226336706.11.CD0F7FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 45B47140005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:20:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HQJ/ZmZk";
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789723211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qcjMRQxp+/sMO1VfRzkV7AtKn8HnHm257Vdf/wTuJpc=;
	b=RIB3f3QFZUc8pvdqVG/a6VmhBAXys0MVYr9ZOCzi/W4Y7TqGDd6duppDJ5/UP5oy20Jtgt
	z3qV5PsMHx+Gpst3onQHk1ClvK8YzIVyikB3Q5mObw6zRw/SpufAIWqZhbI0gEW4eQPVsO
	LH30MGQuRN8mBylYhCVh1TvrSBozLvI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HQJ/ZmZk";
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789723211;
	b=GJANMSlZK0fyj9VNfsW2LteZ26rX1scqJSLNwgOU0y54cvAs1tATNE5CAcEH7ooUnwIY7S
	LmyM1nIn8YooyfyRdvPDlWwPwgHniUJTOrqbV8EeUubHTHGjN7Bn7Y0Tm1FjFRjc+1cWwk
	QnZ619iIQFRk/PkRMyu1ckGwzjYeeAY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7974742B1E;
	Fri, 18 Sep 2026 09:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8801F000FF;
	Fri, 18 Sep 2026 09:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789723210;
	bh=qcjMRQxp+/sMO1VfRzkV7AtKn8HnHm257Vdf/wTuJpc=;
	h=From:Subject:Date:To:Cc;
	b=HQJ/ZmZk5Y7hsLMb5Aa2CErWCujQt969MoiusSghROOLQ26sFezd/Eo99+mzRgIxw
	 WdHJEfikNfs4FtRecqgX/bDcs7QsxoIApH9mTIKHoFC8OnKpR/UJiooqU0slNgJQVj
	 bwpWf+Zv44YHM0Qp9lZRtF2ivsPrSLMXkg9Nl0njJOWbRKF7O1mVi0DNXEC9EUU6FD
	 elApxctaET3HUEk9p9pV726SKDgpv6+A7YOMo/uZbmxbLaDDLEESNHh1lkEYaocnd0
	 vmYxgQP9ceExIsDJku4sfIMB2b9wU1yRzpThLtmPsmkk6N000lfgXsD7xuHsflddku
	 5sf5X8/xd7+tQ==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/2] binfmt: fixes for kres reports
Date: Fri, 18 Sep 2026 11:19:58 +0200
Message-Id: <20260918-work-binfmt_misc-fixes-v1-0-647b24bc1c46@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/02M3Q6CMAxGX4X02i6wGARfxRizn06qYZgVfxLCu
 7vhjZen/c5ZQCgxCRyrBRK9WHiKGZpdBW4w8UrIPjPoWrd133T4ntIdLccwzpeRxWHgDwn2nds
 Har3VBw9ZfiTaHtk9nX8sT3sjN5daWVgjhDaZ6IZyKl3111WbrsoK1vULvNoxiKgAAAA=
X-Change-ID: 20260918-work-binfmt_misc-fixes-98c4fe6db27d
To: Chris Mason <mason@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=622; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IupCRxNYnQ07rFqb9hyW1BDV5Tr4HCbcp/WYfHOr65o=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWStZXKL/u1g9otpw5ml70tfqb7OffbuRWeo17fzR4+de
 zd1xr85Zh2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQATWbOLkeHxpuUbTwkd69hy
 lnNHHtPpVxeZF7EdEi5+9/jWdBau3Uv3M/wVKV9/jW3XzxZrlbt366ZJ8J9+v82iuURL2vjs6aT
 +PzUcAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 45B47140005
X-Stat-Signature: zrywsin51f5q59kjdnu4c9xmpckj5c45
X-Rspam-User: 
X-HE-Tag: 1789723211-294033
X-HE-Meta: U2FsdGVkX18pWGy38c0XnsRABFv7xXt7j34y1oT/5UixwFvWacG5cjk73ANOyKPexvc39jwsPk4PIrBz7pTRJXBEk9rfegRSOqzPK0CqD0MqHhR++KIrBmRU3lbprBvaW9mWPS9hDreMK1ZHtvuBU6AF2ULF5rfPxrNeIUFBSCsG2Fk5bPN8AsFYahdPyj9w3LsOBaS1z0/kyFgh28p4KvLkgq2z3FUSsblAxAsXpjlzqKme7ttLToctfgDfoUanzoUj7wlkE12uTFgx+67/+a8OxsKcPHfMZLeoX6MSxkpaoiadcXLzY8pnHAQhjA6+pA5uxmMwc9AIZPsIHu6HcqBzri57DiW49LPr70eGDNeDE6IXiOqJJYxCXY2tYtFjoFclN8X+8ZfUoOeC2NWinmge9uBdEDeGQeijl1+37BukS52MvQouxeACffYBPgRRSXLlD3DzHzdI2pZ5Viow9t/+N8IkFwcgpMtCpTEavpYc5mCkPqEvZF65izz5duGN9c5Zx3Kf2tFNO7ivYKot3aP4WrNvfIH7LJ1sYF7qQT79BgwOFsIWRJXWR4VPunb+mj6IdIvcBOsofgHmtuGleje/mGpWPWQ+Kfy8yR6pbh83dW3Bj5jYn/rOzMre1wFf0gpEOJ8HRnFH9KvO6VPig3hDY27HMiG9L63SpkwANJrUzYfvbk/SZqeidorudefHsefPhx57L//Try08vmVg8+lHH1fleaYsoAw0kBGUQBzH1oUjSixI9YqzHw2CdyNk/dIQWpY+orE5bqcOna5twkmGKxPrVVuNI9xoYe6j4JURHw2YPpCNGmfbmGrxRSac+kq+NGAf8dXlWicFwqheOKnS3OHWbRE+3pwHE4zfa9DAmuhl4RxRJIxIrHzvldh76rvfmUl9rUpoEDwQke3pisLT8soB7JAwx2qi+zBaGdQOXeMbkkmpRvnRdywDdu6+aPLUJas41IDO5YTJ94O
 DG+FlYyQ
 Qz6cgI26qLvklVuYHkWJ0GmKIlpDrd+Civ1L83T9kp3TOsHiPDmuN/+dp2rmacRQChU89fqHRUd9gLYyfYcBqeBjk96SW+WO8m4o/iMzfMi1B7hpglY5I9e94P01owenUXsT+X1sinTwFp0AVtkaCoT9XlXRKaByYKffPZWjBb0j6a9430LvFL77W3gnSbW59mmwUs3FUjQwwsQMb79Qy91y6muj/hwlt1arrGMlNQLXoJJB0E8rZ05GTAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I asked Chris to run his kres tooling on the binfmt with bpf changes
merged for this cycle. It found two issues that are fixed in this
series. I reproduced both of them.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Chris Mason (2):
      binfmt_misc: fix OOB read in bpf_binprm_select_interp()
      binfmt_misc: fix racy checks in bpf set_interp kfuncs

 fs/binfmt_misc_bpf.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)
---
base-commit: 5179241521401ef364294128bb43cdbce7252457
change-id: 20260918-work-binfmt_misc-fixes-98c4fe6db27d


