Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C6C606A325
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 14:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cevX3BAN
Received: by kanga.kvack.org (Postfix)
	id 479916B05B1; Mon, 26 Oct 2026 10:37:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4297C6B05B4; Mon, 26 Oct 2026 10:37:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 341FF6B05B1; Mon, 26 Oct 2026 10:37:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02DD16B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:37:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FF331207F0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:37:14 +0000 (UTC)
X-FDA: 85365029988.18.7A176CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id DB66B10000C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:37:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cevX3BAN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793025432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8PHEbKOgIuYghLeVCFmg8SLPsx9HPWBRfgbGFvrH17c=;
	b=OAdzu/Omjhu2Q2BhjsJTdYi66+Hc32qWBsAIfNER1XsfCcIJTON6mlnkiKF0KyGN5BsRLX
	9anhBrlEMc9T07RhoaYmcebP+5gxlhA36ePR147vt0U/V96MSfy1R+FuQMJeFXo90X+7WE
	h9yK3EmvXBrvQnxTb6kF2Ah7G2qHrX8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cevX3BAN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793025432;
	b=f0NWQpxQjqF4++GlvHcobuGjODY5+B5tPbvkrrjClVYLw44phbuKjvV7lO34TUwUWdGEqw
	Tqf2DBfil7F/gcAoqhryl0p1w5PXcyIK0N6rCcA/o2NIL1JO0mJBysvowzYtFo9Dw7d2/H
	wNyDEOuagcatKT0UTRfeaJWI3Kw/V0U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7704E6021D;
	Mon, 26 Oct 2026 14:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D6D1F01828;
	Mon, 26 Oct 2026 14:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793025432;
	bh=8PHEbKOgIuYghLeVCFmg8SLPsx9HPWBRfgbGFvrH17c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cevX3BANmffQu1qgFyv4HRuz8GW0FWfyx9uJqCXhZxAaiRMvlBOfO5dDbdqgN/HfH
	 XoRQ2EdMkdq9BScuvVuiOCS0DQ4K4Vc72eWHn+QYnoEyRZW1TKqa4szPjOZbGDCqR5
	 do8uY9SBE+0z0lI0qmghksHnTFh9WOpYEjfXxjxQD09lVNQ2p6kFaQ7cQ8SIrgYLeF
	 kI1VnfXebszpr3HB55cK4JmN1Al7Lvf4JSqWtbLE9Dht2w1XGmBgrO8/yWK10O4Y2I
	 8prW0ADDRSdd70UvO8HIhebwL7EExfseHMMMbSPyTHcJNCJ1k0K7DIFjtTb4Ibg2Lg
	 iZ4b7VA8bHnVw==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] Docs/admin-guide/mm/damon/usage: fix grammar
Date: Mon, 26 Oct 2026 07:37:04 -0700
Message-ID: <20261026143705.150221-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179301327249.2.6830202812762243627.damon-docs-grammar-3@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DB66B10000C
X-Stat-Signature: 6pqb8bzfxjzhhs9kk51gpocwmqzs7ebr
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793025432-427984
X-HE-Meta: U2FsdGVkX1/N0UHWNlpX/TD8zBPeACkpZsLsYcfsR5ZCyR/YEXxfHjjIUPjBH1OwFDXrTM1jYrClbPmlZf2O2FsvrXQGbHqB19DQPvGefkE527SI1chxSJJlwp75+3zUx05PB54KQf0VdOHSLv5VmnVTmDLvPvFNmnqsMXbuivgiRN+Iaghl5mB2tFJvEhf6R5OEIITvvKlp3zsB1smVQGo/5Z1Nfr6l8e1Aq5+rn3EWM6jhKglpazVF0T9A5PCyFuEkBAjFRB13RDZsrMG93XPF4NYfwPGX7bQvs3F8V/HVPB2r1O3FZcLIHfj1nByf+WwDJed/+GrxFXQKCaT7Fi3Df96RN/LLVSfdNiDVuHCzpPKkkjTHPDbJbvbeZ8GJSdMSXmb0I+7E/9V3cMv5ktRW70TzVCY9+lmKi1Lb9ZodABzWsenptWNv+kHk5CQF6f01mUMgGOjqVdhI21qW/tDPYaohoo9TO2IYzb8B8EpiJu/Z2a8cHq2SZGnQuMqAwJt0ZqUkotQdl2vun/QME3EiW+SeRlAWluCgSPFuTWRc4AeCdvqQh5YbAOzJgi1GNCDeAEM8TRt52vvKduBFHLTC7YdXLA4yr80+xO06kYV4Qnzx/wMvgTzb/bes9UwWsIKfI8Wp9M9PLLef80aaYKYXmSsEyCigQgCqTkm9AaC0PgRJ6QrKQBn7me/F5VXqMIpi1g8hjF/snPxtH4pl5c4qHsZX/yOpzaXNTZzHLm17EKYnzyswcD57vaNHahcyGtmLEXLsgBjlYVlhowYKgBEixDEtN26DY94AbJPROhW+/jtXaaSCf4j6VN1OAk1Vo83CndoPdCuYQpbc3vSyt2ytILXH2rwhtoyjxG4mao/YQusLhIfgfI7Qfp25obfWL3qUdalT1RVN7ZxIXfxBakKHvQWjRnw/AdKc2hwDY3Y7JpiMzpzmDd/0AL0yeCsU3C0OsOp8cNRnqwUsrW7
 /EtP3n2y
 WxTIjkV7PWGRLk+J/fg2zBNYPIQVa+ZZtkElC4mWaUqIUAXrXIbJA1O1EsrBvRq0HrCnB8z5DhLIWFfVoU+u5tgWzVnL4v659vwUctrm/ZSUoMdgxLpPT6qXDsqNN+Ag2PyCcw2TO5fVFmqyvX7NrxEwVO71lY+KUR2yJ8CqszfSJcbv/hFf0GOjp/YCG6FTEH4vc7H8dkaxBhUskzsMy+8gevGZTer70MkRCAeoCdlyYnJuuowzBEESo9uy8znmF9Q3G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 22:14:35 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> Fix a handful of grammar mistakes in the usage doc, mostly
> subject-verb agreement and a missing or extra "be".  Also turn "Below
> commands applies" into "The commands below apply", which I think reads
> better.  Rewrap where the lines got too long.

Looks good and correct to me.

> 
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

