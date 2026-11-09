Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0DB1606EE81
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 15:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lTM5tkgK
Received: by kanga.kvack.org (Postfix)
	id C28A16B05B1; Mon,  9 Nov 2026 10:54:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFFAC6B05B2; Mon,  9 Nov 2026 10:54:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16876B05B3; Mon,  9 Nov 2026 10:54:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 983016B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:54:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32D251406E0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 15:54:04 +0000 (UTC)
X-FDA: 85416026808.04.E88D1D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8346E40006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 15:54:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lTM5tkgK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794239642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QhynUeXTwcSAR/KwaSMAEuWBx3KAgf8Lzi+ULRihMp0=;
	b=amgZAZOeLBTBEgkHJSEFZhVZLWeiSlCBd9vR/so98Qx6JZZAemlbgXaDwdtpzi29TmPMdB
	9D/5TVh6FsWhT/qYL9El8/8YhK6mWcYXrIxCoZdh2HowhZz9rCOba/n/ugb0TMKJoHl4CW
	tf5oX+C3TeXy84fNfBL0fDvj0SkNDfY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lTM5tkgK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794239642;
	b=BUkWF+F3RiMfRa5xAeQpqSFQ5wf70jNinkvgHcFBazkVAIVkYbJwbD8uElvtkBYrbOihuW
	i30ip4zBTSlVSBjYYh+0ltwqRmDZMla/sjRYRELyXnitTLTs4gCu6iYaqeu3zX+G5a41Ic
	JzN2XrRaYCb6Gga1udLSMit/REeu1Hk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 672E243EE3;
	Mon,  9 Nov 2026 15:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435221F0089F;
	Mon,  9 Nov 2026 15:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794239641;
	bh=QhynUeXTwcSAR/KwaSMAEuWBx3KAgf8Lzi+ULRihMp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lTM5tkgKZsV8a253kJYvuAT0z2Bj6WDX3dextB6DosfsT8Rj5gj3TA8MlrUkc99Aw
	 MknREf202E5KgXm/nUZ0gzv+EQhiD5C6ScXs9EDNUp8FcTgo2sNRh117u/ATW7ivgs
	 yPyDE/0fFwllsGsYhV+CPyd3HX6lILI/WIF624nvHxH6l+3PA7KVwVG2As7d4zSTHu
	 rAoqToNvekYITPQuSGufxHHdZvOps1HKU8bbhmlPtg18W5RHvHZNvH/7VkR49ty+IP
	 TNDCMgWNjG0eaM9UiDhfh5233GjVuVlQLRdGgF+L6STc6zBSL6Q32Gm1du807J3sho
	 xLqTDS5UchNbA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 6.18.y 3/5] mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
Date: Mon,  9 Nov 2026 10:53:16 -0500
Message-ID: <2026-11-09-1-daily-reply-0034-damon-sz-range-6.18@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261108192221.114362-4-sj@kernel.org>
References: <20261108192221.114362-4-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8346E40006
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: yhtawzuigm5ce6asot9oed8jgq8pw1jz
X-HE-Tag: 1794239642-933278
X-HE-Meta: U2FsdGVkX19CXmNqXWRRoiALdA4BKl6+HIeWbqWEoIvQtBE3DYx5EZrDw1ja+ECxQf0nj7R6JvAQDuhpzDvRgmeFGHCcSv6Jo4Ten5OoLNAD8cXwBirIrwUX8KDnW31KKbxSlxgbl6XekhXJhvbID/9keL6jhKtWfc4R4OFcQsYw/wkahDCFdfFA/mEefFCn6lwQVhzVfJciRg7LX1O8oT5QJ4+ijWLVlwB1sfdeAYCwpn/Rke0BCFBkPBdUd9dwdikGPXLisSZqQopYi/fM8FZfD7lPoSR63F09aZaHth+KUohwlPeU8wq9i238mvv+DoE8xtZYrbAADdKA6NtQBOi2/BBE9NCmactAJ9ABD7o3VsYyxLFRJqBpxBPlz3XttQRFeh3kQye1TykhftQ8hDXlBIYqZVAMgHNgDrFXb4ZwowhemywBjs1q1THyeK/Y0PdRj1b9j/U7YEoUMXAqgmthO8n4WMXRVH3tZWa5I+s/qqKZXW7hh5BaXZBkvCgM4fwn7Yb2gVXfwpqe8E0ssfpmnvwh30LnaQBjgjrK/mHb0DbwFQV7p3bAddCkVojMIU5WfL9ynjiueboI7TqcD5HfIzxJ6XObLatl/EfpjH3MxAZVbFukzjrWegV435kbiLndqG/bIPL0CrzCuPZZ8uwjDABlx2UcWySTdH6/czSZA2iUWehJ8AfWrFdX8r5rbropRLkWEIgVwpqsAwfK1t3mw8dT62Lv5XtdJbjr9s6ffMYSIRDf8anWchXxuwjgP6Wr4a8LVwbA7RgS23RfVOwOs3PqlMkTO78/BpRTFrRqww2RhMKPxp28Ivglp3lin+g26xq82mqG3fkJnFCKPbBfwpnFkP4ziTh1s7EBjmbK5sryJ50XDF/puYLFw5+Ate91sxR//ixs4UtXQ5TskuAmsQmONfys0u/CjI/UZ7nN7lThwJkcejTEl0Jj1AtQWVZp9fmy1Q5L5XZCRpd
 yEY31NGb
 q9EmIM8FUuFfoTEeQ/rZo22tN7K+S2o97WON2Bnf0d3JWBJNpUQauW4UVWA83JC32L+GtE8u4YPsiA81YYkafP0hcY9lrZlSm84Bf7Ln+Z1gOpjAxnULsjmxXvMiISn6kX9otW8WdQ/Z15VjNB83x1gEHFqYOpqjOh2ZMd5p4LPaiHhgPvQLXKp4+LBBZq2qRT2ePTDczMduVBmw/WK07r69OwCWSzD9hrZQglR1gHXI+kjl4c04HrxnLYaJZAYErsffA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once

Queued for 6.18, thanks.

-- 
Thanks,
Sasha

