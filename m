Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EECAE60A2603
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nlM5W3Mz
Received: by kanga.kvack.org (Postfix)
	id 0B0CC6B00EF; Tue, 10 Nov 2026 15:59:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 062036B05B0; Tue, 10 Nov 2026 15:59:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB9096B05C3; Tue, 10 Nov 2026 15:59:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8A666B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:59:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA0B91A00E9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:59:43 +0000 (UTC)
X-FDA: 85420425846.28.D1FAFBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3D75C1C0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:59:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nlM5W3Mz;
	spf=pass (imf21.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794344382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRLf2eJN5BnQ1Rs/bcxgd+v8VFy6BbzXvv2K0AmYCKg=;
	b=zCi4H2oUZhZFN1bdpNLHSKqCokPK4paz73h3VYj6NtEwj/WvHoTVSHDrEZBE3ZeFnu/3X7
	KJVkBg8n0LUnA1OP/PDcrRzXMz2md0b5RoMXCK0G5xwoJPuwmn+qFBS8oSjX7RzkYynfp/
	RSOconpb8r1a+CYxzKwtLbfnth5fGsI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794344382;
	b=p+yGzkreRXp/liqfOcsp9mZKsgudcCaEkXZV6R62olwPYgdv24EU7/fSu6ugl+kboZ0/AE
	3v8VNZYTW1/FgO966+C17Xpi96eDLFlIZ8N+jUMrOwfYsHOLkxs4wk1M5J25ctXQRAE9b1
	tiRTgZ1g1QrWhVa8/dQ4+Rm4ZVas+Bw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nlM5W3Mz;
	spf=pass (imf21.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4BCE61DFB;
	Tue, 10 Nov 2026 20:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389351F008A1;
	Tue, 10 Nov 2026 20:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794344381;
	bh=bRLf2eJN5BnQ1Rs/bcxgd+v8VFy6BbzXvv2K0AmYCKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nlM5W3Mz7qJXbzXx+vZqRsw7/wYbIpJjW9CVOWIElD2gFAzHeGVdC3miiPm60ZYd2
	 yysxsqTt2svLatsCIvl1eKxOT6xEE55TJIX3kMDWCll7w6A8sAQzmD5BY9pjyHesC/
	 GLvjcxlUpHEPLybSF2JtQwHkTzs72dGROkS5tND0AWjvlPX6SEM8O/u3jpfP/Su2g+
	 oSh7ZohunDzJRGuH81LixqMm13wLh1Qkf/5NIWnTY1g8+VmbnojQTN2cE37piI3rD9
	 ALTwJWhYqsc082U3k2/nSs+52KPp6sbJTpIkRV0F+4SV30kTdjQADQ0AVr3xLU8Tst
	 OnNBSRP3E0ZIg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	ranxiaokai627@163.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	linux-mm@kvack.org,
	Hamid Nassiby <hamid.nassiby@nokia.com>
Subject: Re: [PATCH 6.12.y] Revert "mm/page_owner: fix memory leak in page_owner_stack_fops->release()"
Date: Tue, 10 Nov 2026 15:59:04 -0500
Message-ID: <2026-11-10-1-daily-reply-0008-page-owner-revert-6.12@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261109141509.2880440-1-hamid.nassiby@nokia.com>
References: <20261109141509.2880440-1-hamid.nassiby@nokia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: twkb36pnya66m9shhse8f7z9mbgwky43
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3D75C1C0005
X-Rspam-User: 
X-HE-Tag: 1794344382-969240
X-HE-Meta: U2FsdGVkX1+4JjrXhFdjPC5frsq3+4Yp6c7Nb7ZuPQlCjtgGnAm2zn/Ahh9x7xuj841cKRVUKOoZ8cSBNFvxqm+4BMrW4BZtufJqy16/iuFtJIrkww86nPGHHclm94e/qD2Ghw9ZBRwiiEBcb6xboYPVg8mUB9ciTIUNRrNqCFsQd2mNxZ4jFMN5vrfe1ywi79CYmbE6Mo/zF5hsf0Woq5tKNHiUmoObaKnqmbI2at6sGTAXPMJk2Cu4fMYvt+EiNJr/y5s6wCs0wzNBKBs/To1iKx6aN/n95OU1pWwFzeMh/Ae9/ufbTF3RNdajcodchwQD0M+MAOF7en98AwP9p3dDKDCKTdQQxMILRVrG3CjMmDmxlNxEuuCGT+HjTF/qpULE6doeTC56U1Uk6rnSjjURs7Nne4gPQNCUAILCp7xDD6bqgNJBLuqFATGE1lj/1O1NgwNUv2+fAm36mj3U+vA+IbCzDHAAybLW2nTxSpbLvNF1vrs8ZB3C2SdMCyQb1tFzjwDzapOg/HIJUZHajY+fnKirs4CKdHp7ePnt0MtOmX8447R83gruAeNdCbkZGNWS9n6yl1mHfc+XJz7Yt3iT3HUgMcptev9muaXBdkxeiDHFb2Au4hmJ1mSwD3xQyDoW17UycL1ukKGcX4YiIneuXCv6VkD7DxuOnii7A0BekiD4tzbjZD8Y/WuK/aO89CkUi9uYTPbyIt3sHz+Yb4kmemb7bvLM3Snji3w3q5/bI7zSSAR4j6Tk248IfmL15jWb1QbyqsEyPs3ocbOmPz3EN660BoKhIiHcUZR+1wtFwAK4Ig9tRkyFiVG3RlzvBuiY0HoZD/VL42jNUDIV8gnP6blkUgIMf/xuK4fd7iMYc22BTyuOhFtlmaBaM9UOApY9Q/iLFweZgCv/kgm8saGeOhVBgQAaZYdzxeKmB3z7ItTCHjJomCeg7sDe2n6TP6Hmjrw+jj1LXR8sCkZ
 XGXzI97Z
 JmmD01sqoGw3iftzwIuDlrgKheazTF76zrj9jTidxMQ9HEhZiWIs+S6SCoh/fzY5kIwPdxjWO3YZ2H+WOCO5t7AXwD/256o0h0UxlAzpPCFMxbdSMOAfAVQ/5XovRzz/mKV9+gKNt8KkHRZDvAquuo30Vem2hN+0nPtCGjtoDwKA2291Vat57irHrf8cg26H2pV16bxpEPVkI8hTQbTb8wb4Bfq9J49LkCo7fPDZLfTBWZS7/aiL887OQd2oSuFyYfxo+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Revert "mm/page_owner: fix memory leak in page_owner_stack_fops->release()"

Queued for 6.12, thanks.

-- 
Thanks,
Sasha

