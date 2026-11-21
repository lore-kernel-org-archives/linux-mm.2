Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C0AA606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cu14TLOp
Received: by kanga.kvack.org (Postfix)
	id 46BEA6B05B0; Sat, 21 Nov 2026 16:22:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443986B05B2; Sat, 21 Nov 2026 16:22:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 382D66B05B3; Sat, 21 Nov 2026 16:22:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EDF26B05B0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:22:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8AA1AA81AE
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:22:21 +0000 (UTC)
X-FDA: 85460399682.01.4DBB31A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E7A13C0007
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:22:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cu14TLOp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795296140;
	b=VRv+Jvr5hX5aKp5DkE7dmbTP4oaLowNjj3oPPnOIDmLIHpbuuo2N5MEVC7KXOJnt6ughqk
	UGNjf404b1iX8WDkstkTFL6e7hOznRNSA9pUoWrAHCMc38p9T2s/0EMI9s4M8k/0VXPNOf
	Cw4xvSbqN7cWa/xcV49Px0VOmtv/Msg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795296140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBeiyIH7gMM3aoWsWeyzBdNbI0kDC6nmGHL/xgQXibw=;
	b=Wsv5K1okN6IbI5YJ6jQYdjgmLOcP5JKhycWwUOO43Vt06urFmKzsH4locz3YflMFoZmNZi
	2b41RYpMSSfDmdfZlW2ZxEq6Q7w4ub4IvMCbqiifyIrN1Pp3sOClAG0Aohs0T11tVLo5ns
	riZPa8UtAhpQk1tJwSzfYfZvkAF1Es0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cu14TLOp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2127344E8D;
	Sat, 21 Nov 2026 21:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88121F000C4;
	Sat, 21 Nov 2026 21:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795296139;
	bh=sBeiyIH7gMM3aoWsWeyzBdNbI0kDC6nmGHL/xgQXibw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cu14TLOpT2TjVU8lZhc/3GKBEQesCHMkSbSw4aUDjfjaSZIko105T4YqcbfG5TDmT
	 VsOGvvuh8ptLfANdFjinpSNpuQeaLPMhj5rJIqe5PhsTQXBnPpYpICISWeINRVlc40
	 WAOqTLo+Hq+zTJlg2LquVlwZQkLzGg4nDqPb5goEWbdwG1MyaaZH52Q+qeqZMWztpU
	 kwJ/Ii4FpiuHwoknwYuXqPjR9J3svmTVRZG6+iuurFtTTblOcSIKXaEbDEMKFnED1K
	 hSpGG3thI7MBdas8Dae28uB62B3EvrsD7xQvDTVCXbd0xBP1OPUJ9nmcnYlmUDMTjZ
	 QJQiHMCX8Ij/w==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 00/27] mm/damon: let users report their data attribute findings
Date: Sat, 21 Nov 2026 13:22:09 -0800
Message-ID: <20261121212210.131528-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E7A13C0007
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 1cn3hnb5gayz1muourpa69hhggz7gm6a
X-HE-Tag: 1795296139-456879
X-HE-Meta: U2FsdGVkX1/LnN4u6cJQw2X0X0hqZoHz1zwZ6egAdZTzMu5ZCUf/WtCQ7vIWDHdpk6rcV++ZknOoknXU4MFP/gVCmgcAOwYi/Jg5THPVd5sMXFpPSxDGPIXvFe5FBkCuet22Q8VOOQZRyK8tXAnlFQeBiTigBuk3t4XUOeTGuILSnDq/35s6UeISzMTogQ0WwPEMY42CBYYArMdqCGGP8FRru1gl9P1lo1YzLAMTvuIfi0bM5+UCKWZ8RL2YdzzsoZgoZcJCVFmkcolHZ2+KRwATZU7Ce3hFt8m6FPwbLprdir6q1lJkP/ULpYFlbg/XAHqOppd5izTK7FN7FG0shzlbw2SUhj3kLshnXSIsTLoYpwu29fBcGZugrCdFC8k7xeJl3nVRELyHJVjocr6YhK7G6jaPJPWvJtMTAXm8LcidVDes05CdWLOilNUGeXuXBE+YjoujW9ZQZ8idJqTQN/C7sskyZSceS4BiviBbYAS/2H2XBVUqow1HracwLDwaiS18KaViW7CGdA/7Z4fz2lV/aAo6qDzkmshd5QA1HILEyD+4n5jVJCSP6g2R0QoN50cC/5ChN0BGt2W54HEPuupJe6ekuHMSJg6xVTP2aZqUSA3fAtmAHeR1r60uXYdrJtM/5qzL6ejLpmXAcUX92Y8eLrttxRcFDstSjO9HkEQ1F6UkBqt2yocAmpSJviMagmZFwSZowXMlLU0rfrZ8M/qvHS/oq3iYL8kwyggdeeCqgxn6Dt9y8vNPkRGoZjH562u2Xe2Uu+3Hu6XeLjGGPwqD41Y76ku8Fliuksxwv7+ET7Ttfv1cZWnwFnDMGSIaoKk0yDgnRQH8uIOC0P9Ee1edM/FW2cxSEnDRIVAbBSKi8BplCRx8aX+rjnlsPU8IoiNKJhXQ3mnFIzHoVmCweZMASpewhHkzilYo/ae0Sayz37vsfwiDIMiQ/OWkCoqm8t+lgls+FbVMuc1Wx+m
 fNeWSBEK
 IzgOogArvwTitvw604o/vlpOjJ8h5dXjW2x6tbjnYZZKVxEUHWZMKETdgRlLgWv3F0PCvYsr4TqNfHpPuUhR9h7q7g8OEdeCwpRg7NrlSXwbTaJ4p5mqB3+KgVuNJyPIg6R2/7cotA5ruMIitTV7SpgnFyA1fWdK4dUb41kXTxnqL1bydAt32fGTW/F+GOa9FvN58rqlYwDMCBlbzbwilM1thQG6n6eIHS4JXCUbiehps75r9oJf4D8sSmx5ueln3+h8kHgwNoT8R8tX5ALF9Hk79NZI/lc+ESVw7P7H3S2XbDI8M/kYz+oCsjK+wAbNH7iuzR4O0gBOearSmoS+9xrsC9z7PwqfiFiAac9pF8isdhqlxtPdpE6SkYolts/G/5fK8ivgkqEYnXv0fiRlnE0uIMGYmHSY8NdFJx4IH6i6J2WEtbR991MBIR/CtGWoPPw71on+ph7rWG51MdfH9ho7FOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 12:59:44 -0800 SJ Park <sj@kernel.org> wrote:

> TL;DR
> =====
> 
> Build a system for letting DAMON-external entities report their data
> attribute findings to DAMON.  Let users report their data attribute
> findings to DAMON using the report system.

Sashiko found an issue [1] in patch 14.  I will send v2 with a fix of it.

[1] https://lore.kernel.org/20261121211922.131352-1-sj@kernel.org


Thanks,
SJ

[...]

